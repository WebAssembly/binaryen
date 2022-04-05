/*
 * Copyright 2021 WebAssembly Community Group participants
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

//
// Find struct fields that are always written to with a constant value, and
// replace gets of them with that value.
//
// For example, if we have a vtable of type T, and we always create it with one
// of the fields containing a ref.func of the same function F, and there is no
// write to that field of a different value (even using a subtype of T), then
// anywhere we see a get of that field we can place a ref.func of F.
//
// FIXME: This pass assumes a closed world. When we start to allow multi-module
//        wasm GC programs we need to check for type escaping.
//

#include "ir/module-utils.h"
#include "ir/possible-constant.h"
#include "ir/struct-utils.h"
#include "ir/utils.h"
#include "pass.h"
#include "support/unique_deferring_queue.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

namespace {

// *Location structs describe particular locations.

// The location of a specific expression, referring to the possible types
// it can contain (which may be more precise than expr->type).
struct ExpressionLocation {
  Expression* expr;
  bool operator==(const ExpressionLocation& other) const {
    return expr == other.expr;
  }
};

// The location of one of the results of a function.
struct ResultLocation {
  Function* func;
  Index index;
  bool operator==(const ResultLocation& other) const {
    return func == other.func && index == other.index;
  }
};

// The location of one of the locals in a function (either a parameter or a
// var). TODO: would separating params from vars help?
struct LocalLocation {
  Function* func;
  Index index;
  bool operator==(const LocalLocation& other) const {
    return func == other.func && index == other.index;
  }
};

// The location of a branch target in a function, identified by its name.
struct BranchLocation {
  Function* func;
  Name target;
  bool operator==(const BranchLocation& other) const {
    return func == other.func && target == other.target;
  }
};

// The location of a global in the module.
struct GlobalLocation {
  Name name;
  bool operator==(const GlobalLocation& other) const {
    return name == other.name;
  }
};

// The location of a table in the module.
struct TableLocation {
  Name name;
  bool operator==(const TableLocation& other) const {
    return name == other.name;
  }
};

// The location of one of the parameters in a function signature.
struct SignatureParamLocation {
  HeapType type;
  Index index;
  bool operator==(const SignatureParamLocation& other) const {
    return type == other.type && index == other.index;
  }
};

struct SignatureResultLocation {
  HeapType type;
  Index index;
  bool operator==(const SignatureResultLocation& other) const {
    return type == other.type && index == other.index;
  }
};

// The location of a struct field.
struct StructLocation {
  HeapType type;
  Index index;
  bool operator==(const StructLocation& other) const {
    return type == other.type && index == other.index;
  }
};

// The location of an element in the array (without index - we consider them all
// as one, since we may not have static indexes for them all).
struct ArrayLocation {
  HeapType type;
  bool operator==(const ArrayLocation& other) const {
    return type == other.type;
  }
};

// A location is a variant over all the possible types of locations that we
// have.
using Location = std::variant<ExpressionLocation,
                              ResultLocation,
                              LocalLocation,
                              BranchLocation,
                              GlobalLocation,
                              TableLocation,
                              SignatureParamLocation,
                              SignatureResultLocation,
                              StructLocation,
                              ArrayLocation>;

// A connection indicates a flow of types from one location to another. For
// example, if we do a local.get and return that value from a function, then
// we have a connection from a location of LocalTypes to a location of
// ResultTypes.
struct Connection {
  Location from;
  Location to;

  bool operator==(const Connection& other) const {
    return from == other.from && to == other.to;
  }
};

} // anonymous namespace

} // namespace wasm

namespace std {

// Define hashes of all the *Location types so that Location itself is hashable
// and we can use it in unordered maps and sets.

template<> struct hash<wasm::ExpressionLocation> {
  size_t operator()(const wasm::ExpressionLocation& loc) const {
    return std::hash<size_t>{}(size_t(loc.expr));
  }
};

template<> struct hash<wasm::ResultLocation> {
  size_t operator()(const wasm::ResultLocation& loc) const {
    return std::hash<std::pair<size_t, wasm::Index>>{}({size_t(loc.func), loc.index});
  }
};

template<> struct hash<wasm::LocalLocation> {
  size_t operator()(const wasm::LocalLocation& loc) const {
    return std::hash<std::pair<size_t, wasm::Index>>{}({size_t(loc.func), loc.index});
  }
};

template<> struct hash<wasm::BranchLocation> {
  size_t operator()(const wasm::BranchLocation& loc) const {
    return std::hash<std::pair<size_t, wasm::Name>>{}({size_t(loc.func), loc.target});
  }
};

template<> struct hash<wasm::GlobalLocation> {
  size_t operator()(const wasm::GlobalLocation& loc) const {
    return std::hash<wasm::Name>{}(loc.name);
  }
};

template<> struct hash<wasm::TableLocation> {
  size_t operator()(const wasm::TableLocation& loc) const {
    return std::hash<wasm::Name>{}(loc.name);
  }
};

template<> struct hash<wasm::SignatureParamLocation> {
  size_t operator()(const wasm::SignatureParamLocation& loc) const {
    return std::hash<std::pair<wasm::HeapType, wasm::Index>>{}({loc.type, loc.index});
  }
};

template<> struct hash<wasm::SignatureResultLocation> {
  size_t operator()(const wasm::SignatureResultLocation& loc) const {
    return std::hash<std::pair<wasm::HeapType, wasm::Index>>{}({loc.type, loc.index});
  }
};

template<> struct hash<wasm::StructLocation> {
  size_t operator()(const wasm::StructLocation& loc) const {
    return std::hash<std::pair<wasm::HeapType, wasm::Index>>{}({loc.type, loc.index});
  }
};

template<> struct hash<wasm::ArrayLocation> {
  size_t operator()(const wasm::ArrayLocation& loc) const {
    return std::hash<wasm::HeapType>{}(loc.type);
  }
};

template<> struct hash<wasm::Connection> {
  size_t operator()(const wasm::Connection& loc) const {
    return std::hash<std::pair<wasm::Location, wasm::Location>>{}({loc.from, loc.to});
  }
};

} // namespace std

namespace wasm {

namespace {

// Analyze the entire wasm file to find which types are possible in which
// locations. This assumes a closed world and starts from struct.new/array.new
// instructions, and propagates them to the locations they reach. After the
// analysis the user of this class can ask which types are possible at any
// location.
//
// TODO: refactor into a separate file if other passes want it too.
class PossibleTypesOracle {
  Module& wasm;

  void analyze();

public:
  PossibleTypesOracle(Module& wasm) : wasm(wasm) { analyze(); }

  using TypeSet = std::unordered_set<HeapType>;

  // Get the possible types returned by an expression.
  TypeSet getTypes(Expression* expr);

  // Get the possible types appearing in a function result.
  TypeSet getResultTypes(Function* func, Index index);

  // Get the possible types appearing in a function local. This will include the
  // incoming parameter values for parameters, like getParamTypes, and also
  // includes values written into that parameter in this function itself.
  // TODO: Also track param types specifically?
  TypeSet getLocalTypes(Function* func, Index index);

  // Get the possible types stored in a struct type's field.
  TypeSet getTypes(HeapType type, Index index);

  // Get the possible types stored in an array type.
  TypeSet getTypes(HeapType type);

  // TODO: Add analysis and retrieval logic for fields of immutable globals,
  //       including multiple levels of depth (necessary for itables in j2wasm)

private:
  // The information needed during and after flowing the types through the
  // graph.
  struct LocationInfo {
    // The types possible at this location.
    TypeSet types;

    // The targets to which this sends types.
    std::vector<Location> targets;
  };

  std::unordered_map<Location, LocationInfo> flowInfoMap;
};

void PossibleTypesOracle::analyze() {
  // Gather information from functions in parallel.
  struct FuncInfo {
    // TODO: as an optimization we could perhaps avoid redundant copies in this
    //       vector using a set?
    std::vector<Connection> connections;
  };

  ModuleUtils::ParallelFunctionAnalysis<FuncInfo> analysis(
    wasm, [&](Function* func, FuncInfo& info) {
      if (func->imported()) {
        // TODO: add an option to not always assume a closed world, in which
        //       case we'd need to track values escaping etc.
        return;
      }

      struct ConnectionFinder
        : public PostWalker<ConnectionFinder,
                            UnifiedExpressionVisitor<ConnectionFinder>> {
        FuncInfo& info;

        ConnectionFinder(FuncInfo& info) : info(info) {}

        // Each visit*() call is responsible for connection the children of a
        // node to that node. Responsibility for connecting the node's output to
        // the outside (another expression or the function itself, if we are at
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
              {LocalLocation{getFunction(), curr->index},
               ExpressionLocation{curr}});
          }
        }
        void visitLocalSet(LocalSet* curr) {
          if (!curr->value->type.isRef()) {
            return;
          }
          info.connections.push_back(
            {ExpressionLocation{curr->value},
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
                        std::function<Location (Index)> makeParamLocation,
                        std::function<Location (Index)> makeResultLocation) {
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
          info.connections.push_back({
            makeResultLocation(0), ExpressionLocation{curr}
          });
        }

        // Calls send values to params in their possible targets, and receive
        // results.
        void visitCall(Call* curr) {
          auto* target = getModule()->getFunction(curr->target);
          handleCall(curr, curr->operands, [&](Index i) {
            return LocalLocation{target, i};
          });
        }
        void visitCallIndirect(CallIndirect* curr) {
          auto target = curr->heapType;
          handleCall(curr, curr->operands, [&](Index i) {
            return SignatureParamLocation{target, i};
          });
        }
        void visitCallRef(CallRef* curr) {
          auto targetType = curr->target->type;
          if (targetType.isRef()) {
            auto target = targetType.getHeapType();
            handleCall(curr, curr->operands, [&](Index i) {
              return SignatureParamLocation{target, i};
            });
          }
        }

        // Iterates over a list of children and adds connections as needed. The
        // target of the connection is created using a function that is passed
        // in which receives the index of the child.
        void handleChildList(ExpressionList& operands,
                        std::function<Location (Index)> makeTarget) {
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
          handleChildList(curr->values, [&](Index i) {
            return ArrayLocation{type};
          });
        }

        // Struct operations access the struct fields' locations.
        void visitStructGet(StructGet* curr) {
          if (curr->type.isRef()) {
            info.connections.push_back({StructLocation{curr->type.getHeapType(), curr->index},
                                        ExpressionLocation{curr}});
          }
        }
        void visitStructSet(StructSet* curr) {
          if (curr->value->type.isRef()) {
            info.connections.push_back(
              {ExpressionLocation{curr->value},
               StructLocation{curr->type.getHeapType(), curr->index}});
          }
        }
        // Array operations access the array's location.
        void visitArrayGet(ArrayGet* curr) {
          if (curr->type.isRef()) {
            info.connections.push_back(
              {ArrayLocation{curr->type.getHeapType()}, ExpressionLocation{curr}});
          }
        }
        void visitArraySet(ArraySet* curr) {
          if (curr->value->type.isRef()) {
            info.connections.push_back(
              {ExpressionLocation{curr->value}, ArrayLocation{curr->type.getHeapType()}});
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

        void visitTry(Try* curr) {
          WASM_UNREACHABLE("todo");
        }
        void visitThrow(Throw* curr) {
          WASM_UNREACHABLE("todo");
        }
        void visitRethrow(Rethrow* curr) {
          WASM_UNREACHABLE("todo");
        }
        void visitTupleMake(TupleMake* curr) {
          WASM_UNREACHABLE("todo");
        }
        void visitTupleExtract(TupleExtract* curr) {
          WASM_UNREACHABLE("todo");
        }

        void visitFunction(Function* func) {
          // Functions with a result can flow a value out from their body.
          auto* body = func->body;
          if (body->type.isRef()) {
            if (!body->type.isTuple()) {
              info.connections.push_back(
                {ExpressionLocation{body}, ResultLocation{func, 0}});
            } else {
              WASM_UNREACHABLE("multivalue function result support");
            }
          }
        }
      };
      ConnectionFinder finder(info);
      finder.setFunction(func);
      finder.walk(func->body);
    });

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
      connections.insert({SignatureParamLocation{func->type, i}, LocalLocation{func.get(), i}});
    }
  }

  // TODO: add signature connections to functions
  // TODO: add subtyping (but see TODO later down, we could do this even better
  //       in a more dynamic manner

  // Build the flow info. First, note the connection targets.
  for (auto& connection : connections) {
    flowInfoMap[connection.from].targets.push_back(connection.to);
  }

  // TODO: assert that no duplicates in targets vector, by design.

  // The work remaining to do: locations that we just updated, which means we
  // should update their children when we pop them from this queue.
  UniqueDeferredQueue<Location> work;

  for (auto& [location, info] : flowInfoMap) {
    if (auto* exprLoc = std::get_if<ExpressionLocation>(&location)) {
      auto* expr = exprLoc->expr;
      if (expr->is<StructNew>() || expr->is<ArrayNew>() || expr->is<ArrayInit>()) {
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
    auto& info = flowInfoMap[location];
    auto& targets = info.targets;
    if (targets.empty()) {
      continue;
    }

    auto& types = info.types;
    // TODO: We can refine both the types and the targets here. For types, we
    //       can avoid flowing anything through a ref.cast that it would trap
    //       on. For targets, rather than assume struct.set writes to the
    //       relevant field of any subtype we could construct the list of
    //       targets based on the currently inferred type of the reference we
    //       are writing to.

    // Update the targets, and add the ones that changes to the remaining work.
    for (const auto& target : targets) {
      auto& targetTypes = flowInfoMap[target].types;
      auto oldSize = targetTypes.size();
      targetTypes.insert(types.begin(), types.end());
      if (targetTypes.size() != oldSize) {
        // We inserted something, so there is work to do in this target.
        work.push(target);
      }
    }
  }
}

PossibleTypesOracle::TypeSet PossibleTypesOracle::getTypes(Expression* curr) {
  return flowInfoMap[ExpressionLocation{curr}].types;
}

PossibleTypesOracle::TypeSet PossibleTypesOracle::getResultTypes(Function* func, Index index) {
  return flowInfoMap[ResultLocation{func, index}].types;
}

PossibleTypesOracle::TypeSet PossibleTypesOracle::getLocalTypes(Function* func, Index index) {
  return flowInfoMap[LocalLocation{func, index}].types;
}

PossibleTypesOracle::TypeSet PossibleTypesOracle::getTypes(HeapType type, Index index) {
  return flowInfoMap[StructLocation{type, index}].types;
}

PossibleTypesOracle::TypeSet PossibleTypesOracle::getTypes(HeapType type) {
  return flowInfoMap[ArrayLocation{type}].types;
}

//===============

using PCVStructValuesMap = StructUtils::StructValuesMap<PossibleConstantValues>;
using PCVFunctionStructValuesMap =
  StructUtils::FunctionStructValuesMap<PossibleConstantValues>;

// Optimize struct gets based on what we've learned about writes.
//
// TODO Aside from writes, we could use information like whether any struct of
//      this type has even been created (to handle the case of struct.sets but
//      no struct.news).
struct FunctionOptimizer : public WalkerPass<PostWalker<FunctionOptimizer>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new FunctionOptimizer(infos); }

  FunctionOptimizer(PCVStructValuesMap& infos) : infos(infos) {}

  void visitStructGet(StructGet* curr) {
    auto type = curr->ref->type;
    if (type == Type::unreachable) {
      return;
    }

    Builder builder(*getModule());

    // Find the info for this field, and see if we can optimize. First, see if
    // there is any information for this heap type at all. If there isn't, it is
    // as if nothing was ever noted for that field.
    PossibleConstantValues info;
    assert(!info.hasNoted());
    auto iter = infos.find(type.getHeapType());
    if (iter != infos.end()) {
      // There is information on this type, fetch it.
      info = iter->second[curr->index];
    }

    if (!info.hasNoted()) {
      // This field is never written at all. That means that we do not even
      // construct any data of this type, and so it is a logic error to reach
      // this location in the code. (Unless we are in an open-world
      // situation, which we assume we are not in.) Replace this get with a
      // trap. Note that we do not need to care about the nullability of the
      // reference, as if it should have trapped, we are replacing it with
      // another trap, which we allow to reorder (but we do need to care about
      // side effects in the reference, so keep it around).
      replaceCurrent(builder.makeSequence(builder.makeDrop(curr->ref),
                                          builder.makeUnreachable()));
      changed = true;
      return;
    }

    // If the value is not a constant, then it is unknown and we must give up.
    if (!info.isConstant()) {
      return;
    }

    // We can do this! Replace the get with a trap on a null reference using a
    // ref.as_non_null (we need to trap as the get would have done so), plus the
    // constant value. (Leave it to further optimizations to get rid of the
    // ref.)
    Expression* value = info.makeExpression(*getModule());
    replaceCurrent(builder.makeSequence(
      builder.makeDrop(builder.makeRefAs(RefAsNonNull, curr->ref)), value));
    changed = true;
  }

  void doWalkFunction(Function* func) {
    WalkerPass<PostWalker<FunctionOptimizer>>::doWalkFunction(func);

    // If we changed anything, we need to update parent types as types may have
    // changed.
    if (changed) {
      ReFinalize().walkFunctionInModule(func, getModule());
    }
  }

private:
  PCVStructValuesMap& infos;

  bool changed = false;
};

struct PCVScanner
  : public StructUtils::StructScanner<PossibleConstantValues, PCVScanner> {
  Pass* create() override {
    return new PCVScanner(functionNewInfos, functionSetGetInfos);
  }

  PCVScanner(StructUtils::FunctionStructValuesMap<PossibleConstantValues>&
               functionNewInfos,
             StructUtils::FunctionStructValuesMap<PossibleConstantValues>&
               functionSetInfos)
    : StructUtils::StructScanner<PossibleConstantValues, PCVScanner>(
        functionNewInfos, functionSetInfos) {}

  void noteExpression(Expression* expr,
                      HeapType type,
                      Index index,
                      PossibleConstantValues& info) {
    info.note(expr, *getModule());
  }

  void noteDefault(Type fieldType,
                   HeapType type,
                   Index index,
                   PossibleConstantValues& info) {
    info.note(Literal::makeZero(fieldType));
  }

  void noteCopy(HeapType type, Index index, PossibleConstantValues& info) {
    // Ignore copies: when we set a value to a field from that same field, no
    // new values are actually introduced.
    //
    // Note that this is only sound by virtue of the overall analysis in this
    // pass: the object read from may be of a subclass, and so subclass values
    // may be actually written here. But as our analysis considers subclass
    // values too (as it must) then that is safe. That is, if a subclass of $A
    // adds a value X that can be loaded from (struct.get $A $b), then consider
    // a copy
    //
    //   (struct.set $A $b (struct.get $A $b))
    //
    // Our analysis will figure out that X can appear in that copy's get, and so
    // the copy itself does not add any information about values.
    //
    // TODO: This may be extensible to a copy from a subtype by the above
    //       analysis (but this is already entering the realm of diminishing
    //       returns).
  }

  void noteRead(HeapType type, Index index, PossibleConstantValues& info) {
    // Reads do not interest us.
  }
};

struct ConstantFieldPropagation : public Pass {
  void run(PassRunner* runner, Module* module) override {
    if (getTypeSystem() != TypeSystem::Nominal) {
      Fatal() << "ConstantFieldPropagation requires nominal typing";
    }

    // Find and analyze all writes inside each function.
    PCVFunctionStructValuesMap functionNewInfos(*module),
      functionSetInfos(*module);
    PCVScanner scanner(functionNewInfos, functionSetInfos);
    scanner.run(runner, module);
    scanner.runOnModuleCode(runner, module);

    // Combine the data from the functions.
    PCVStructValuesMap combinedNewInfos, combinedSetInfos;
    functionNewInfos.combineInto(combinedNewInfos);
    functionSetInfos.combineInto(combinedSetInfos);

    // Handle subtyping. |combinedInfo| so far contains data that represents
    // each struct.new and struct.set's operation on the struct type used in
    // that instruction. That is, if we do a struct.set to type T, the value was
    // noted for type T. But our actual goal is to answer questions about
    // struct.gets. Specifically, when later we see:
    //
    //  (struct.get $A x (REF-1))
    //
    // Then we want to be aware of all the relevant struct.sets, that is, the
    // sets that can write data that this get reads. Given a set
    //
    //  (struct.set $B x (REF-2) (..value..))
    //
    // then
    //
    //  1. If $B is a subtype of $A, it is relevant: the get might read from a
    //     struct of type $B (i.e., REF-1 and REF-2 might be identical, and both
    //     be a struct of type $B).
    //  2. If $B is a supertype of $A that still has the field x then it may
    //     also be relevant: since $A is a subtype of $B, the set may write to a
    //     struct of type $A (and again, REF-1 and REF-2 may be identical).
    //
    // Thus, if either $A <: $B or $B <: $A then we must consider the get and
    // set to be relevant to each other. To make our later lookups for gets
    // efficient, we therefore propagate information about the possible values
    // in each field to both subtypes and supertypes.
    //
    // struct.new on the other hand knows exactly what type is being written to,
    // and so given a get of $A and a new of $B, the new is relevant for the get
    // iff $A is a subtype of $B, so we only need to propagate in one direction
    // there, to supertypes.

    StructUtils::TypeHierarchyPropagator<PossibleConstantValues> propagator(
      *module);
    propagator.propagateToSuperTypes(combinedNewInfos);
    propagator.propagateToSuperAndSubTypes(combinedSetInfos);

    // Combine both sources of information to the final information that gets
    // care about.
    PCVStructValuesMap combinedInfos = std::move(combinedNewInfos);
    combinedSetInfos.combineInto(combinedInfos);

    // Optimize.
    // TODO: Skip this if we cannot optimize anything
    FunctionOptimizer(combinedInfos).run(runner, module);

    // TODO: Actually remove the field from the type, where possible? That might
    //       be best in another pass.
  }
};

} // anonymous namespace

Pass* createConstantFieldPropagationPass() {
  return new ConstantFieldPropagation();
}

} // namespace wasm
