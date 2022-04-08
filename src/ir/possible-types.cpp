/*
 * Copyright 2022 WebAssembly Community Group participants
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <variant>

#include "ir/branch-utils.h"
#include "ir/find_all.h"
#include "ir/module-utils.h"
#include "ir/possible-types.h"
#include "ir/subtypes.h"
#include "support/unique_deferring_queue.h"
#include "wasm.h"

namespace wasm::PossibleTypes {

namespace {

// The data we gather from each function, as we process them in parallel. Later
// this will be merged into a single big graph.
struct FuncInfo {
  // All the connections we found in this function.
  // TODO: as an optimization we could perhaps avoid redundant copies in this
  //       vector using a set?
  std::vector<Connection> connections;

  // All the allocations (struct.new, etc.) that we found in this function.
  std::vector<Expression*> allocations;
};

bool containsRef(Type type) {
  if (type.isRef()) {
    return true;
  }
  if (type.isTuple()) {
    for (auto t : type) {
      if (t.isRef()) {
        return true;
      }
    }
  }
  return false;
}

struct ConnectionFinder
  : public PostWalker<ConnectionFinder,
                      UnifiedExpressionVisitor<ConnectionFinder>> {
  FuncInfo& info;

  ConnectionFinder(FuncInfo& info) : info(info) {}

  // Each visit*() call is responsible for connecting the children of a
  // node to that node. Responsibility for connecting the node's output to
  // anywhere else (another expression or the function itself, if we are at
  // the top level) is the responsibility of the outside.

  void visitExpression(Expression* curr) {
    // Breaks send values to their destinations. Handle that here using
    // existing utility code which is shorter than implementing multiple
    // visit*() methods (however, it may be slower TODO)
    BranchUtils::operateOnScopeNameUsesAndSentValues(
      curr, [&](Name target, Expression* value) {
        if (value && value->type.isRef()) {
          info.connections.push_back(
            {ExpressionLocation{value}, BranchLocation{getFunction(), target}});
        }
      });

    // Branch targets receive the things sent to them and flow them out.
    if (curr->type.isRef()) {
      BranchUtils::operateOnScopeNameDefs(curr, [&](Name target) {
        info.connections.push_back(
          {BranchLocation{getFunction(), target}, ExpressionLocation{curr}});
      });
    }
    // TODO: if we are a branch source or target, skip the loop later
    // down? in general any ref-receiving instruction that reaches that
    // loop will end up connecting a child ref to the current expression,
    // but e.g. ref.is_* does not do so. OTOH ref.test's output is then an
    // integer anyhow, so we don't actually reach the loop.

    // The default behavior is to connect all input expressions to the
    // current one, as it might return an output that includes them. We only do
    // so for references or tuples containing a reference as anything else can
    // be ignored.
    if (!containsRef(curr->type)) {
      return;
    }

    for (auto* child : ChildIterator(curr)) {
      if (!containsRef(child->type)) {
        continue;
      }
      info.connections.push_back(
        {ExpressionLocation{child}, ExpressionLocation{curr}});
    }
  }

  // Locals read and write to their index.
  // TODO: we could use a LocalGraph for better precision
  void visitLocalGet(LocalGet* curr) {
    if (curr->type.isRef()) {
      info.connections.push_back(
        {LocalLocation{getFunction(), curr->index}, ExpressionLocation{curr}});
    }
  }
  void visitLocalSet(LocalSet* curr) {
    if (!curr->value->type.isRef()) {
      return;
    }
    info.connections.push_back({ExpressionLocation{curr->value},
                                LocalLocation{getFunction(), curr->index}});
    if (curr->isTee()) {
      info.connections.push_back(
        {ExpressionLocation{curr->value}, ExpressionLocation{curr}});
    }
  }

  // Globals read and write from their location.
  void visitGlobalGet(GlobalGet* curr) {
    if (curr->type.isRef()) {
      info.connections.push_back(
        {GlobalLocation{curr->name}, ExpressionLocation{curr}});
    }
  }
  void visitGlobalSet(GlobalSet* curr) {
    if (curr->value->type.isRef()) {
      info.connections.push_back(
        {ExpressionLocation{curr->value}, GlobalLocation{curr->name}});
    }
  }

  // Iterates over a list of children and adds connections to parameters
  // and results as needed. The param/result functions receive the index
  // and create the proper location for it.
  void handleCall(Expression* curr,
                  ExpressionList& operands,
                  std::function<Location(Index)> makeParamLocation,
                  std::function<Location(Index)> makeResultLocation) {
    Index i = 0;
    for (auto* operand : operands) {
      if (operand->type.isRef()) {
        info.connections.push_back(
          {ExpressionLocation{operand}, makeParamLocation(i)});
      }
      i++;
    }

    // Add results, if anything flows out.
    if (curr->type.isTuple()) {
      WASM_UNREACHABLE("todo: tuple results");
    }
    if (!curr->type.isRef()) {
      return;
    }
    info.connections.push_back(
      {makeResultLocation(0), ExpressionLocation{curr}});
  }

  // Calls send values to params in their possible targets, and receive
  // results.
  void visitCall(Call* curr) {
    auto* target = getModule()->getFunction(curr->target);
    handleCall(
      curr,
      curr->operands,
      [&](Index i) {
        return LocalLocation{target, i};
      },
      [&](Index i) {
        return ResultLocation{target, i};
      });
  }
  void visitCallIndirect(CallIndirect* curr) {
    auto target = curr->heapType;
    handleCall(
      curr,
      curr->operands,
      [&](Index i) {
        return SignatureParamLocation{target, i};
      },
      [&](Index i) {
        return SignatureResultLocation{target, i};
      });
  }
  void visitCallRef(CallRef* curr) {
    auto targetType = curr->target->type;
    if (targetType.isRef()) {
      auto target = targetType.getHeapType();
      handleCall(
        curr,
        curr->operands,
        [&](Index i) {
          return SignatureParamLocation{target, i};
        },
        [&](Index i) {
          return SignatureResultLocation{target, i};
        });
    }
  }

  // Iterates over a list of children and adds connections as needed. The
  // target of the connection is created using a function that is passed
  // in which receives the index of the child.
  void handleChildList(ExpressionList& operands,
                       std::function<Location(Index)> makeTarget) {
    Index i = 0;
    for (auto* operand : operands) {
      if (operand->type.isRef()) {
        info.connections.push_back(
          {ExpressionLocation{operand}, makeTarget(i)});
      }
      i++;
    }
  }

  // Creation operations form the starting connections from where data
  // flows. We will create an ExpressionLocation for them when their
  // parent uses them, as we do for all instructions, so nothing special
  // needs to be done here, but we do need to create connections from
  // inputs - the initialization of their data - to the proper places.
  void visitStructNew(StructNew* curr) {
    if (curr->type == Type::unreachable) {
      return;
    }
    auto type = curr->type.getHeapType();
    handleChildList(curr->operands, [&](Index i) {
      return StructLocation{type, i};
    });
    info.allocations.push_back(curr);
  }
  void visitArrayNew(ArrayNew* curr) {
    if (curr->type == Type::unreachable) {
      return;
    }
    // Note that if there is no initial value here then it is null, which is
    // not something we need to connect.
    if (curr->init && curr->init->type.isRef()) {
      info.connections.push_back({ExpressionLocation{curr->init},
                                  ArrayLocation{curr->type.getHeapType()}});
    }
    info.allocations.push_back(curr);
  }
  void visitArrayInit(ArrayInit* curr) {
    if (curr->type == Type::unreachable) {
      return;
    }
    if (!curr->values.empty() && curr->values[0]->type.isRef()) {
      auto type = curr->type.getHeapType();
      handleChildList(curr->values,
                      [&](Index i) { return ArrayLocation{type}; });
    }
    info.allocations.push_back(curr);
  }

  // Struct operations access the struct fields' locations.
  void visitStructGet(StructGet* curr) {
    if (curr->type.isRef()) {
      info.connections.push_back(
        {StructLocation{curr->ref->type.getHeapType(), curr->index},
         ExpressionLocation{curr}});
    }
  }
  void visitStructSet(StructSet* curr) {
    if (curr->value->type.isRef()) {
      info.connections.push_back(
        {ExpressionLocation{curr->value},
         StructLocation{curr->ref->type.getHeapType(), curr->index}});
    }
  }
  // Array operations access the array's location.
  void visitArrayGet(ArrayGet* curr) {
    if (curr->type.isRef()) {
      info.connections.push_back({ArrayLocation{curr->ref->type.getHeapType()},
                                  ExpressionLocation{curr}});
    }
  }
  void visitArraySet(ArraySet* curr) {
    if (curr->value->type.isRef()) {
      info.connections.push_back(
        {ExpressionLocation{curr->value},
         ArrayLocation{curr->ref->type.getHeapType()}});
    }
  }

  // TODO: Model which throws can go to which catches. For now, anything
  //       thrown is sent to the location of that tag, and any catch of that
  //       tag can read them
  void visitTry(Try* curr) {
    auto numTags = curr->catchTags.size();
    for (Index tagIndex = 0; tagIndex < numTags; tagIndex++) {
      auto tag = curr->catchTags[tagIndex];
      auto* body = curr->catchBodies[tagIndex];

      // Find the pop of the tag's contents. The body must start with such a
      // pop, which might be of a tuple.
      FindAll<Pop> pops(body);
      assert(!pops.list.empty());
      auto* pop = pops.list[0];
      info.connections.push_back(
        {TagLocation{tag}, ExpressionLocation{pop}});
    }
  }
  void visitThrow(Throw* curr) {
    // We must handle the thrown values in a special way. In a catch body we
    // have a pop which will be of a tuple if the tag has more than one element,
    // but the throw does not receive a tuple as an input. (Compare this to a
    // function call, in which the call has separate operands and the function
    // that is called receives them each in a separate local.) To handle this,
    // create an artificial TupleMake expression here and route through that,
    // if we have more than one value. First, handle the simple cases.
    auto tag = curr->tag;
    auto& operands = curr->operands;
    if (operands.empty()) {
      return;
    }
    if (operands.size() == 1) {
      info.connections.push_back(
        {ExpressionLocation{operands[0]}, TagLocation{tag}});
    }

    // This is the tuple case. Create a TupleMake with the same operands. Note
    // that it shares the operands of the Throw; that would be invalid IR if we
    // actually added the TupleMake into the tree, but we do not, it is only
    // held on the side.
    auto* make = Builder(*getModule()).makeTupleMake(operands);
    info.connections.push_back(
      {ExpressionLocation{make}, TagLocation{tag}});
  }

  void visitTableGet(TableGet* curr) { WASM_UNREACHABLE("todo"); }
  void visitTableSet(TableSet* curr) { WASM_UNREACHABLE("todo"); }

  void addResult(Expression* value) {
    if (!value || !value->type.isRef()) {
      return;
    }
    if (!value->type.isTuple()) {
      info.connections.push_back(
        {ExpressionLocation{value}, ResultLocation{getFunction(), 0}});
    } else {
      WASM_UNREACHABLE("multivalue function result support");
    }
  }

  void visitReturn(Return* curr) { addResult(curr->value); }

  void visitFunction(Function* curr) {
    // Functions with a result can flow a value out from their body.
    addResult(curr->body);
  }
};

} // anonymous namespace

void Oracle::analyze() {
  ModuleUtils::ParallelFunctionAnalysis<FuncInfo> analysis(
    wasm, [&](Function* func, FuncInfo& info) {
      if (func->imported()) {
        // TODO: add an option to not always assume a closed world, in which
        //       case we'd need to track values escaping etc.
        return;
      }

      ConnectionFinder finder(info);
      finder.walkFunctionInModule(func, &wasm);
    });

  // Also walk the global module code, adding it to the map as a function of
  // null.
  auto& globalInfo = analysis.map[nullptr];
  ConnectionFinder(globalInfo).walkModuleCode(&wasm);

  // Connect global init values (which we've just processed, as part of the
  // module code) to the globals they initialize.
  for (auto& global : wasm.globals) {
    if (!global->imported()) {
      auto* init = global->init;
      if (init->type.isRef()) {
        globalInfo.connections.push_back(
          {ExpressionLocation{init}, GlobalLocation{global->name}});
      }
    }
  }

  // Merge the function information into a single large graph that represents
  // the entire program all at once. First, gather all the connections from all
  // the functions. We do so into a set, which deduplicates everythings.
  // map of the possible types at each location.
  std::unordered_set<Connection> connections;
  std::vector<Expression*> allocations;

  for (auto& [func, info] : analysis.map) {
    for (auto& connection : info.connections) {
      connections.insert(connection);
    }
    for (auto& allocation : info.allocations) {
      allocations.push_back(allocation);
    }
  }

  // Connect function parameters to their signature, so that any indirect call
  // of that signature will reach them.
  // TODO: find which functions are even taken by reference
  for (auto& func : wasm.functions) {
    for (Index i = 0; i < func->getParams().size(); i++) {
      connections.insert(
        {SignatureParamLocation{func->type, i}, LocalLocation{func.get(), i}});
    }
    for (Index i = 0; i < func->getResults().size(); i++) {
      connections.insert({ResultLocation{func.get(), i},
                          SignatureResultLocation{func->type, i}});
    }
  }

  // Add subtyping connections, but see the TODO below about how we can do this
  // "dynamically" in a more effective but complex way.
  SubTypes subTypes(wasm);
  for (auto type : subTypes.types) {
    // Tie two locations together, linking them both ways.
    auto tie = [&](const Location& a, const Location& b) {
      connections.insert({a, b});
      connections.insert({b, a});
    };
    if (type.isStruct()) {
      // StructLocations refer to a struct.get/set/new and so in general they
      // may refer to data of a subtype of the type written on them. Connect to
      // their immediate subtypes here in both directions.
      auto numFields = type.getStruct().fields.size();
      for (auto subType : subTypes.getSubTypes(type)) {
        for (Index i = 0; i < numFields; i++) {
          tie(StructLocation{type, i}, StructLocation{subType, i});
        }
      }
    } else if (type.isArray()) {
      // StructLocations refer to a struct.get/set/new and so in general they
      // may refer to data of a subtype of the type written on them. Connect to
      // their immediate subtypes here.
      for (auto subType : subTypes.getSubTypes(type)) {
        tie(ArrayLocation{type}, ArrayLocation{subType});
      }
    }
  }

  // Build the flow info. First, note the connection targets.
  for (auto& connection : connections) {
    flowInfoMap[connection.from].targets.push_back(connection.to);
  }

#ifndef NDEBUG
  for (auto& [location, info] : flowInfoMap) {
    // The vector of targets must have no duplicates.
    auto& targets = info.targets;
    std::unordered_set<Location> uniqueTargets;
    for (const auto& target : targets) {
      uniqueTargets.insert(target);
    }
    assert(uniqueTargets.size() == targets.size());
  }
#endif

  // The work remaining to do: locations that we just updated, which means we
  // should update their children when we pop them from this queue.
  UniqueDeferredQueue<Location> work;

  // The starting state for the flow is for each allocation to contain the type
  // allocated there.
  for (const auto& allocation : allocations) {
    // The type must not be a reference (as we allocated here), and it cannot be
    // unreachable (we should have ignored such things before).
    assert(allocation->type.isRef());

    auto location = ExpressionLocation{allocation};
    auto& info = flowInfoMap[location];

    // There must not be anything at this location already, as each allocation
    // appears once in the vector of allocations.
    assert(info.types.empty());

    info.types.push_back({allocation->type.getHeapType()});
    work.push(location);
  }

  // Flow the data.
  while (!work.empty()) {
    auto location = work.pop();
    const auto& info = flowInfoMap[location];

#if POSSIBLE_TYPES_DEBUG
    std::cout << "pop item\n";
    if (auto* loc = std::get_if<ExpressionLocation>(&location)) {
      std::cout << "  exprloc " << *loc->expr << '\n';
    }
    if (auto* loc = std::get_if<StructLocation>(&location)) {
      std::cout << "  structloc " << loc->type << " : " << loc->index << '\n';
    }
#endif

    // TODO: implement the following optimization, and remove the hardcoded
    //       links created above.
    // ==================================TODO==================================
    // Compute the targets we need to update. Normally we simply flow to the
    // targets defined in the graph, however, some connections are best done
    // "dynamically". Consider a struct.set that writes a references to some
    // field. We could assume that it writes it to any struct of the type it is
    // defined on, or any subtype, but instead we use the information in the
    // graph: the types that are possible in the reference field determine where
    // the values should flow. That is,
    //
    //  (struct.set $A
    //    (ref B)
    //    (value C) ;; also a reference type of some kind.
    //  )
    //
    // The rules we apply to such an expression are:
    //
    //  1. When a new type arrives in (value C), we send it to the proper field
    //     of all types that can appear in (ref B).
    //  2. When a new type arrives in (ref B) we must send the values in
    //     (value C) to their new target as well.
    // ==================================TODO==================================
    const auto& targets = info.targets;
    if (targets.empty()) {
      continue;
    }

    // TODO: We can refine the types here, by not flowing anything through a
    //       ref.cast that it would trap on.
    const auto& types = info.types;
    auto numTupleIndexes = types.size();

    // Update the targets, and add the ones that change to the remaining work.
    for (const auto& target : targets) {
      auto& targetTypes = flowInfoMap[target].types;

      // Update types in one lane of a tuple, copying from inputs to outputs and
      // adding the target to the remaining work if we added something new.
      auto updateTypes = [&](const std::unordered_set<HeapType>& inputs,
                             std::unordered_set<HeapType>& outputs) {
        auto oldSize = outputs.size();
        outputs.insert(inputs.begin(), inputs.end());
        if (outputs.size() != oldSize) {
          // We inserted something, so there is work to do in this target.
          work.push(target);
        }
      };

      // Typically the target should have the same tuple size as the source,
      // that is, we copy a tuple from one place to another. To do so we simply
      // copy each index in the vectors of sets of types. However, the exception
      // are the tuple operations as TupleMake/TupleExtract go from one to many
      // or many to one, and need special handling.
      if (auto* exprLoc = std::get_if<ExpressionLocation>(&location)) {
        if (auto* extract = exprLoc->expr->dynCast<TupleExtract>()) {
          // The source is a TupleExtract, so we are going from a tuple to a
          // target that is just one item.
          auto tupleIndex = extract->index;

          // If this is the first time we write to this target, set its size,
          // then copy the types.
          if (targetTypes.empty()) {
            targetTypes.resize(1);
          }
          assert(tupleIndex < types.size());
          updateTypes(types[tupleIndex], targetTypes[0]);
          continue;
        }
      }
      if (auto* targetExprLoc = std::get_if<ExpressionLocation>(&target)) {
        if (auto* make = targetExprLoc->expr->dynCast<TupleMake>()) {
          // The target is a TupleMake, so we are going from one item to a
          // tuple. Find the index in that tuple, using the fact that the input
          // must be an Expression which is one of the TupleMake's children.
          // TODO: add another field to avoid linear lookup here? (but tuples
          // are rare/small)
          auto* expr = std::get<ExpressionLocation>(location).expr;
          Index tupleIndex;
          Index i;
          for (i = 0; i < make->operands.size(); i++) {
            if (make->operands[i] == expr) {
              tupleIndex = i;
              break;
            }
          }
          assert(i < make->operands.size());
          // If this is the first time we write to this target, set its size,
          // then copy the types.
          if (targetTypes.empty()) {
            targetTypes.resize(make->operands.size());
          }
          assert(types.size() == 1);
          updateTypes(types[0], targetTypes[tupleIndex]);
          continue;
        }
      }

      // Otherwise, the input and output must have the same number of lanes.
      if (targetTypes.empty()) {
        targetTypes.resize(types.size());
      }
      for (Index i = 0; i < numTupleIndexes; i++) {
        updateTypes(types[i], targetTypes[i]);
      }
    }
  }

  // TODO: Add analysis and retrieval logic for fields of immutable globals,
  //       including multiple levels of depth (necessary for itables in j2wasm)
}

} // namespace wasm::PossibleTypes
