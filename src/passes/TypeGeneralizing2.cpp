//#define TYPEGEN_DEBUG 1

/*
 * Copyright 2023 WebAssembly Community Group participants
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

#include "analysis/lattices/valtype.h"
#include "ir/possible-contents.h"
#include "ir/subtype-exprs.h"
#include "ir/utils.h"
#include "pass.h"
#include "support/unique_deferring_queue.h"
#include "wasm-traversal.h"
#include "wasm.h"

//
// This is an alternative implementation of TypeGeneralizing, for comparison and
// exploration.
//
// Generalize the types of program locations as much as possible, both to
// eliminate unnecessarily refined types from the type section and (TODO) to
// weaken casts that cast to unnecessarily refined types. If the casts are
// weakened enough, they will be able to be removed by OptimizeInstructions.
//
// Perform an analysis on the types of program to discover how much the type of
// each location can be generalized without breaking validation or changing
// program behavior. The analysis is a basic flow operation: we find the
// "static", unavoidable constraints and consider them roots, and then flow from
// there to affect everything else. For example, when we update the type of a
// block then the block's last child must then be flowed to, as the child must
// be a subtype of the block, etc.
//

namespace wasm {

namespace {

struct TypeGeneralizing
  : WalkerPass<ControlFlowWalker<TypeGeneralizing,
                                 SubtypingDiscoverer<TypeGeneralizing>>> {
  using Super = WalkerPass<
    ControlFlowWalker<TypeGeneralizing, SubtypingDiscoverer<TypeGeneralizing>>>;

  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<TypeGeneralizing>();
  }

  // Visitors during the walk. We track local operations so that we can
  // optimize them later.

  void visitLocalGet(LocalGet* curr) {
    // Purposefully do not visit the super, as we handle locals ourselves.
    gets.push_back(curr);
  }

  void visitLocalSet(LocalSet* curr) {
    // Purposefully do not visit the super, as we handle locals ourselves.
    setsByIndex[curr->index].push_back(curr);

    // If this is a parameter then we cannot modify it, and so we add a root
    // here: the value written to the param must be a subtype of the never-to-
    // change param type.
    if (getFunction()->isParam(curr->index)) {
      addRoot(curr->value, getFunction()->getLocalType(curr->index));
    }
  }

  std::vector<LocalGet*> gets;
  // TODO: flat like gets?
  std::unordered_map<Index, std::vector<LocalSet*>> setsByIndex; // TODO vector

  // Hooks that are called by SubtypingDiscoverer.

  void noteSubtype(Type sub, Type super) {
    // Nothing to do; a totally static and fixed constraint.
  }
  void noteSubtype(HeapType sub, HeapType super) {
    // As above.
  }
  void noteSubtype(Expression* sub, Type super) {
    // This expression's type must be a subtype of a fixed type, so it is a
    // root.
    addRoot(sub, super);
  }
  void noteSubtype(Type sub, Expression* super) {
    // A fixed type that must be a subtype of an expression's type. We do not
    // need to do anything here, as we will just be generalizing expression
    // types, so we will not break these constraints.
  }
  void noteSubtype(Expression* sub, Expression* super) {
    // Two expressions with subtyping between them. Add a link in the graph so
    // that we flow requirements along.
    addExprSubtyping(sub, super);
  }

  void noteCast(HeapType src, HeapType dest) {
    // Same as in noteSubtype.
  }
  void noteCast(Expression* src, Type dest) {
    // Same as in noteSubtype.
  }
  void noteCast(Expression* src, Expression* dest) {
    // We handle this in the transfer function below. TODO
    addExprSubtyping(src, dest); // XXX
  }

  // Internal graph for the flow. We track the predecessors so that we know who
  // to update after updating a location. For example, when we update the type
  // of a block then the block's last child must then be flowed to, so the child
  // is a pred of the block. We also track successors so that we can tell where
  // to read updates from (which the transfer function needs in some cases).
  // TODO: SmallVector<1>s?
  std::unordered_map<Location, std::vector<Location>> preds;
  std::unordered_map<Location, std::vector<Location>> succs;

  void addExprSubtyping(Expression* sub, Expression* super) {
    connectSubToSuper(getLocation(sub), getLocation(super));
  }

  // TODO: rename to "connect value to where it arrives"
  void connectSubToSuper(const Location& subLoc, const Location& superLoc) {
    preds[superLoc].push_back(subLoc);
    succs[subLoc].push_back(superLoc);
  }

  Location getLocation(Expression* expr) {
    // TODO: tuples
    return ExpressionLocation{expr, 0};
  }

  // The roots in the graph: constraints that we know from the start and from
  // which the flow begins. Each root is a location and its type.
  std::unordered_map<Location, Type> roots;

  void addRoot(Expression* sub, Type super) {
    // There may already exist a type for a particular root, so merge them in,
    // in the same manner as during the flow (a meet).
    typeLattice.meet(roots[getLocation(sub)], super);
  }

  // The analysis we do here is on types: each location will monotonically
  // increase until all locations stabilize at the fixed point.
  analysis::ValType typeLattice;

  void visitFunction(Function* func) {
    Super::visitFunction(func);

    // Finish setting up the graph: LocalLocals are "abstract" things that we
    // did not walk, so set them up manually. Each LocalLocation is connected
    // to the sets and gets for that index.
    for (auto* get : gets) {
      // This is not true subtyping here - really these have the same type - but
      // this sets up the connections between them. This is important to prevent
      // quadratic size of the graph: N gets for an index are connected to the
      // single location for that index, which is connected to M sets for it,
      // giving us N + M instead of N * M (which we'd get if we connected gets
      // to sets directly).
      connectSubToSuper(LocalLocation{func, get->index},
                        getLocation(get));
    }
    for (auto& [index, sets] : setsByIndex) {
      for (auto* set : sets) {
        connectSubToSuper(getLocation(set->value), LocalLocation{func, index});
        if (set->type.isConcrete()) {
          // This is a tee with a value, and that value shares the location of
          // the local.
          connectSubToSuper(LocalLocation{func, set->index},
                            getLocation(set));
        }
      }
    }

    // The types of locations as we discover them. When the flow is complete,
    // these are the final types.
    std::unordered_map<Location, Type> locTypes;

    // Set up locals.
    auto numLocals = func->getNumLocals();
    for (Index i = 0; i < numLocals; i++) {
      auto type = func->getLocalType(i);
      if (type.isRef()) {
        if (func->isParam(i)) {
          // We cannot alter params.
          locTypes[LocalLocation{func, i}] = type;
        } else {
          // Start each var with the top type. If we see nothing else, that is
          // what will remain.
          locTypes[LocalLocation{func, i}] =
            Type(type.getHeapType().getTop(), Nullable);
        }
      }
    }

    // A list of locations to process. When we process one, we compute the
    // transfer function for it and set up any further flow.
    UniqueDeferredQueue<Location> toFlow;

    // After we update a location's type, this function sets up the flow to
    // reach all preds.
    auto flowFrom = [&](Location loc) {
      for (auto dep : preds[loc]) {
        toFlow.push(dep);
      }
    };

    // Update a location, that is, apply the transfer function there. This reads
    // the information that affects this information and computes the new type
    // there. If the type changed, then apply it and flow onwards.
    auto update = [&](Location loc) {
#ifdef TYPEGEN_DEBUG
      std::cout << "Updating \n";
      dump(loc);
#endif
      auto& locType = locTypes[loc];

      auto changed = false;
      auto& locSuccs = succs[loc];
      for (auto succ : locSuccs) {
#ifdef TYPEGEN_DEBUG
        std::cout << " with \n";
        dump(succ);
#endif
        assert(!(succ == loc)); // no loopey
        auto succType = locTypes[succ];
        if (!succType.isRef()) {
          // Non-ref updates do not interest us.
          continue;
        }
#ifdef TYPEGEN_DEBUG
        std::cerr << "  old: " << locType << " new: " << succType << "\n";
#endif
        if (typeLattice.meet(locType, succType)) {
#ifdef TYPEGEN_DEBUG
          std::cerr << "    result: " << locType << "\n";
#endif
          changed = true;
        }
      }
      if (changed) {
        flowFrom(loc);
      }
    };

    // First, apply the roots.
    for (auto& [loc, super] : roots) {
#ifdef TYPEGEN_DEBUG
      std::cerr << "root: " << super << "\n";
      dump(loc);
#endif
      // Set the type here, and prepare to flow onwards.
      locTypes[loc] = super;
      flowFrom(loc);
    }

    // Second, perform the flow.
    while (!toFlow.empty()) {
      update(toFlow.pop());
    }

    // Finally, apply the results of the flow: the types at LocalLocations are
    // now the types of the locals.
    auto numParams = func->getNumParams();
    for (Index i = numParams; i < numLocals; i++) {
      auto& localType = func->vars[i - numParams];
      if (localType.isRef()) {
        localType = locTypes[LocalLocation{func, i}];
        assert(localType.isRef());
      }
    }
    for (auto* get : gets) {
      get->type = func->getLocalType(get->index);
    }
    for (auto& [index, sets] : setsByIndex) {
      for (auto* set : sets) {
        if (set->type.isRef()) {
          set->type = func->getLocalType(index);
        }
      }
    }

    // TODO: avoid when not needed
    ReFinalize().walkFunctionInModule(func, getModule());
  }

#ifdef TYPEGEN_DEBUG
  void dump(const Location& loc) {
    if (auto* exprLoc = std::get_if<ExpressionLocation>(&loc)) {
      std::cerr << "exprLoc  " << *exprLoc->expr << '\n';
    } else if (auto* localLoc = std::get_if<LocalLocation>(&loc)) {
      std::cerr << "localloc " << localLoc->index << '\n';
    } else {
      std::cerr << "unknown location\n";
    }
  }
#endif
};

} // anonymous namespace

Pass* createTypeGeneralizing2Pass() { return new TypeGeneralizing; }

} // namespace wasm
