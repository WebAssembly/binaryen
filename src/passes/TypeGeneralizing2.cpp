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

#include "ir/possible-contents.h"
#include "ir/subtype-exprs.h"
#include "ir/utils.h"
#include "pass.h"
#include "support/unique_deferring_queue.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

namespace {

struct TypeGeneralizing : WalkerPass<ControlFlowWalker<TypeGeneralizing, SubtypingDiscoverer<TypeGeneralizing>>> {
  using Super = WalkerPass<ControlFlowWalker<TypeGeneralizing, SubtypingDiscoverer<TypeGeneralizing>>>;

  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<TypeGeneralizing>();
  }

  // Visitors during the walk. We track local operations so that we can
  // optimize them later.

  void visitLocalGet(LocalGet* curr) {
    Super::visitLocalGet(curr);
    gets.push_back(curr);
  }

  void visitLocalSet(LocalSet* curr) {
    Super::visitLocalSet(curr);
    setsByIndex[curr->index].push_back(curr);
  }

  // Hooks that are called by SubtypingDiscoverer.

  void noteSubtype(Type sub, Type super) {
    // Nothing to do; a totally static and fixed constraint.
  }
  void noteSubtype(HeapType sub, HeapType super) {
    // As above.
  }
  void noteSubtype(Expression* sub, Type super) {
    // This expression's type must be a subtype of a fixed type.
//std::cout << "noteSubtype " << *sub << " is sub of " << super << '\n';
    addRoot(sub, super);
  }
  void noteSubtype(Type sub, Expression* super) {
    // A fixed type that must be a subtype of an expression's type. We do not
    // need to do anything here, as we will just be generalizing expression
    // types, so we will not break these constraints.
  }
  void noteSubtype(Expression* sub, Expression* super) {
    // Two expressions with subtyping between them. Add a link in the graph.
    addExprSubtyping(sub, super);
  }

  void noteCast(HeapType src, HeapType dest) {
    // Nothing to do; a totally static and fixed constraint.
  }
  void noteCast(Expression* src, Type dest) {
    // This expression's type is cast to a fixed dest type. This adds no
    // constraints on us.
  }
  void noteCast(Expression* src, Expression* dest) {
    // Two expressions with subtyping between them. Add a link in the graph, the
    // same as in noteSubtype.
    addExprSubtyping(src, dest);
  }

  // Internal graph. The main component is a graph of dependencies that we will
  // need to update during the flow. Whenever we find out something about the
  // type of an expression, that can then be propagated to those dependenents,
  // who are typically its children. For example, when we update the type of a
  // block then the block's last child must then be flowed to.
  std::unordered_map<Location, std::vector<Location>> dependents;

  void addExprSubtyping(Expression* sub, Expression* super) {
    dependents[getLocation(super)].push_back(getLocation(sub));
  }

  // Gets the location of an expression. Most are simply ExpressionLocation, but
  // we track locals as well, so we use LocalLocation for the value in a
  // particular local index. That gives all local.gets of an index the same
  // location, which is what we want here, since we are computing new declared
  // types for locals (and not values that flow around, for which we'd use a
  // LocalGraph).
  Location getLocation(Expression* expr) {
    if (auto* get = expr->dynCast<LocalGet>()) {
      return LocalLocation{getFunction(), get->index};
    }
    return ExpressionLocation{expr, 0}; // TODO: tuples
  }

  // The second part of the graph are the "roots": expressions that have known
  // types they must have (that type, or a subtype of which).
  std::unordered_map<Location, Type> roots;

  void addRoot(Expression* sub, Type super) {
    roots[getLocation(sub)] = super;
  }

  // Can these be in subtype-exprs?
  std::vector<LocalGet*> gets;
  std::unordered_map<Index, std::vector<LocalSet*>> setsByIndex; // TODO vector

  // Main processing code on the graph. After the walk of the code, when we
  // visit the Function we perform the analysis. We do a straightforward flow of
  // constraints from the roots, until we know all the effects of the roots. For
  // example, imagine we have this code:
  //
  //   (func $foo (result (ref $X))
  //     (local $temp (ref $Y))
  //     (local.set $temp
  //       (call $get-something)
  //     )
  //     (local.get $temp)
  //   )
  //
  // The final line in the function body forces that local.get to be a subtype
  // of the results, which is our root. We flow from the root to the local.get,
  // at which point we apply that to the local index as a whole. Separately, we
  // know from the local.set that the call must be a subtype of the local, but
  // that is not a constraint that we are in danger of breaking (since we only
  // generalize the types of locals and expressoins), so we do nothing with it.
  // (However, if the local.set's value was something else, then we could have
  // more to flow here.)
  void visitFunction(Function* func) {
    Super::visitFunction(func);

//std::cout << "flow1\n";

    // The types of locations as we discover them. When the flow is complete,
    // these are the final types.
    std::unordered_map<Location, Type> locTypes;

    // A work item is an expression and a type that we have learned it must be a
    // subtype of. XXX better to not put type in here. less efficient now since
    // we might update with (X, T1), (X, T2) which differ. apply type first!
    // then push
    using WorkItem = std::pair<Location, Type>;
    UniqueDeferredQueue<WorkItem> work;

    // Main update logic for a location: updates the type for the location, and
    // prepares further flow.
    auto update = [&](const Location& loc, Type newType) {
      auto& locType = locTypes[loc];
      auto old = locType;
      if (old == Type::none) { // XXX needed? what is GLB(none, X)?
        // This is the first time we see this location.
        locType = newType;
      } else {
        // This is an update to the GLB.
        locType = Type::getGreatestLowerBound(locType, newType);
      }
//std::cout << "combine " << old << " and " << newType << " to get " << locType << '\n';
      if (locType != old) {
        // Something changed; flow from here.
        if (auto* localLoc = std::get_if<LocalLocation>(&loc)) {
          // This is a local location. Changes here flow to the local.sets.
          for (auto* set : setsByIndex[localLoc->index]) {
            work.push({getLocation(set->value), locType});
          }
        } else {
          // Flow using the graph generically.
          for (auto dep : dependents[loc]) {
            work.push({dep, locType});
          }
        }
      }
    };

    // The initial work is the set of roots we found as we walked the code.
    for (auto& [loc, super] : roots) {
//std::cout << "root " << super << " to "; dump(loc);
      update(loc, super);
    }

    // Start each local with the top type. If we see nothing else, that is what
    // will remain.
    auto numLocals = func->getNumLocals();
    for (Index i = 0; i < numLocals; i++) {
      auto type = func->getLocalType(i);
      if (type.isRef()) {
        update(LocalLocation{func, i}, Type(type.getHeapType().getTop(), Nullable));
      }
    }

    // Perform the flow.
    while (!work.empty()) {
      auto [loc, type] = work.pop();
//std::cout << "work iter " << type << " to "; dump(loc);

      if (auto* exprLoc = std::get_if<ExpressionLocation>(&loc)) {
        if (auto* get = exprLoc->expr->dynCast<LocalGet>()) {
          // This is a local.get. The type reaching here actually reaches the
          // LocalLocation, as all local.gets represent the same location.
          //
          // We could instead set up connections in the graph from each
          // local.get to each corresponding local.set, but that would be of
          // quadratic size.
          loc = LocalLocation{func, get->index};
        }
      }

      update(loc, type);
    }

    // Apply the results of the flow: the types at LocalLocations are now the
    // types of the locals.
    auto numParams = func->getNumParams();
    for (Index i = numParams; i < numLocals; i++) {
      func->vars[i - numParams] = locTypes[LocalLocation{func, i}];
    }
    for (auto* get : gets) {
      get->type = func->getLocalType(get->index);
    }
    for (auto& [index, sets] : setsByIndex) {
      for (auto* set : sets) {
        if (set->isTee()) {
          set->type = func->getLocalType(index);
        }
      }
    }

    // TODO: avoid when not needed
    ReFinalize().walkFunctionInModule(func, getModule());
  }

  void dump(Location location) {
    if (auto* loc = std::get_if<ExpressionLocation>(&location)) {
      std::cout << "  exprloc \n"
                << *loc->expr << " : " << loc->tupleIndex << '\n';
    } else if (auto* loc = std::get_if<LocalLocation>(&location)) {
      std::cout << "  localloc " << loc->index
                << '\n';
    } else {
      std::cout << "  (other)\n";
    }
  }
};

} // anonymous namespace

Pass* createTypeGeneralizing2Pass() { return new TypeGeneralizing; }

} // namespace wasm

