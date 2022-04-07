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
#include "ir/module-utils.h"
#include "ir/possible-types.h"
#include "ir/subtypes.h"
#include "support/unique_deferring_queue.h"
#include "wasm.h"

namespace wasm::PossibleTypes {

namespace {

// Gather information from functions in parallel. In each function we get a
// vector of all the connections, and later merge them.
struct FuncInfo {
  // TODO: as an optimization we could perhaps avoid redundant copies in this
  //       vector using a set?
  std::vector<Connection> connections;
};

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
    // current one, as it might return an output that includes them.
    if (!curr->type.isRef()) {
      return;
    }

    for (auto* child : ChildIterator(curr)) {
      if (!child->type.isRef()) {
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
std::cout << "new operand to struct loc\n";
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
std::cout << "struct.new adding StructLoc\n";
      return StructLocation{type, i};
    });
  }
  void visitArrayNew(ArrayNew* curr) {
    if (curr->type != Type::unreachable && curr->init->type.isRef()) {
      info.connections.push_back({ExpressionLocation{curr->init},
                                  ArrayLocation{curr->type.getHeapType()}});
    }
  }
  void visitArrayInit(ArrayInit* curr) {
    if (curr->type == Type::unreachable || curr->values.empty() ||
        !curr->values[0]->type.isRef()) {
      return;
    }
    auto type = curr->type.getHeapType();
    handleChildList(curr->values, [&](Index i) { return ArrayLocation{type}; });
  }

  // Struct operations access the struct fields' locations.
  void visitStructGet(StructGet* curr) {
    if (curr->type.isRef()) {
std::cout << "struct loc to get\n";
      info.connections.push_back(
        {StructLocation{curr->ref->type.getHeapType(), curr->index},
         ExpressionLocation{curr}});
    }
  }
  void visitStructSet(StructSet* curr) {
    if (curr->value->type.isRef()) {
std::cout << "struct loc from set\n";
      info.connections.push_back(
        {ExpressionLocation{curr->value},
         StructLocation{curr->ref->type.getHeapType(), curr->index}});
    }
  }
  // Array operations access the array's location.
  void visitArrayGet(ArrayGet* curr) {
    if (curr->type.isRef()) {
      info.connections.push_back(
        {ArrayLocation{curr->ref->type.getHeapType()}, ExpressionLocation{curr}});
    }
  }
  void visitArraySet(ArraySet* curr) {
    if (curr->value->type.isRef()) {
      info.connections.push_back({ExpressionLocation{curr->value},
                                  ArrayLocation{curr->type.getHeapType()}});
    }
  }

  // Table operations access the table's locations.
  void visitTableGet(TableGet* curr) {
    if (curr->type.isRef()) {
      info.connections.push_back(
        {TableLocation{curr->table}, ExpressionLocation{curr}});
    }
  }
  void visitTableSet(TableSet* curr) {
    if (curr->value->type.isRef()) {
      info.connections.push_back(
        {ExpressionLocation{curr->value}, TableLocation{curr->table}});
    }
  }

  void visitTry(Try* curr) { WASM_UNREACHABLE("todo"); }
  void visitThrow(Throw* curr) { WASM_UNREACHABLE("todo"); }
  void visitRethrow(Rethrow* curr) { WASM_UNREACHABLE("todo"); }
  void visitTupleMake(TupleMake* curr) { WASM_UNREACHABLE("todo"); }
  void visitTupleExtract(TupleExtract* curr) { WASM_UNREACHABLE("todo"); }

  void visitFunction(Function* curr) {
    // Functions with a result can flow a value out from their body.
    auto* body = curr->body;
    if (body->type.isRef()) {
      if (!body->type.isTuple()) {
        info.connections.push_back(
          {ExpressionLocation{body}, ResultLocation{curr, 0}});
      } else {
        WASM_UNREACHABLE("multivalue function result support");
      }
    }
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

  // Also walk the global module code, adding it to the map as a funciton of
  // null.
  auto& globalInfo = analysis.map[nullptr];
  ConnectionFinder(globalInfo).walkModuleCode(&wasm);

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

  for (auto& [func, info] : analysis.map) {
    for (auto& connection : info.connections) {
      connections.insert(connection);
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
    if (type.isStruct()) {
      // StructLocations refer to a struct.get/set/new and so in general they
      // may refer to data of a subtype of the type written on them. Connect to
      // their immediate subtypes here.
      auto numFields = type.getStruct().fields.size();
      for (auto subType : subTypes.getSubTypes(type)) {
        for (Index i = 0; i < numFields; i++) {
          connections.insert(
            {StructLocation{type, i}, StructLocation{subType, i}});
        }
      }
    } else if (type.isArray()) {
      // StructLocations refer to a struct.get/set/new and so in general they
      // may refer to data of a subtype of the type written on them. Connect to
      // their immediate subtypes here.
      for (auto subType : subTypes.getSubTypes(type)) {
        connections.insert({ArrayLocation{type}, ArrayLocation{subType}});
      }
    }
  }

std::cout << "total # of connections " << connections.size() << '\n';

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

  for (auto& [location, info] : flowInfoMap) {
    if (auto* exprLoc = std::get_if<ExpressionLocation>(&location)) {
      auto* expr = exprLoc->expr;
std::cout << "exprloc " << *expr << '\n';
      if (expr->is<StructNew>() || expr->is<ArrayNew>() ||
          expr->is<ArrayInit>()) {
        // The type must be a reference, and not unreachable (we should have
        // ignored such things before).
        assert(expr->type.isRef());

        auto& info = flowInfoMap[*exprLoc];

        // There must not be anything at this location already, as there can
        // only be a single ExpressionLocation for each expression.
        assert(info.types.empty());

        info.types.insert(expr->type.getHeapType());
        work.push(*exprLoc);
      }
    }
  }

  // Flow the data.
  while (!work.empty()) {
    auto location = work.pop();
    const auto& info = flowInfoMap[location];
std::cout << "pop item\n";
if (auto* loc = std::get_if<ExpressionLocation>(&location)) std::cout << "  exprloc " << *loc->expr << '\n';
if (auto* loc = std::get_if<StructLocation>(&location)) std::cout << "  structloc " << loc->type << " : " << loc->index << '\n';

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
std::cout << "  this item has " << targets.size() << " targets in it\n";
    if (targets.empty()) {
      continue;
    }

    // TODO: We can refine the types here, by not flowing anything through a
    //       ref.cast that it would trap on.
    const auto& types = info.types;
std::cout << "  this item has " << types.size() << " types in it\n";

    // Update the targets, and add the ones that changes to the remaining work.
    for (const auto& target : targets) {
      auto& targetTypes = flowInfoMap[target].types;
      auto oldSize = targetTypes.size();
      targetTypes.insert(types.begin(), types.end());
      if (targetTypes.size() != oldSize) {
std::cout << "  this item has added to a child\n";//" << types.size() << " types in it\n";
        // We inserted something, so there is work to do in this target.
        work.push(target);
      }
    }
  }

  // TODO: Add analysis and retrieval logic for fields of immutable globals,
  //       including multiple levels of depth (necessary for itables in j2wasm)
}

} // namespace wasm::PossibleTypes
