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

#include "ir/subtype-exprs.h"
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

  void runOnFunction(Module* wasm, Function* func) override {
    // Discover subtyping relationships in this function. This fills the graph,
    // that is, it sets up roots and links.
    walkFunction(func);

    // Process the graph and apply the results.
    process();
  }

  // Visitors during the walk. We track local operations so that we can
  // optimize them later.

  void visitLocalGet(LocalGet* curr) {
    Super::visitLocalGet(curr);
    gets.push_back(curr);
  }

  void visitLocalSet(LocalSet* curr) {
    Super::visitLocalSet(curr);
    sets.push_back(curr);
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
    // This expression's type is cast to a fixed dest type.
    // XXX addRoot(sub, super);
  }
  void noteCast(Expression* src, Expression* dest) {
    // Two expressions with subtyping between them. Add a link in the graph.
    // XXX addSubtypeLink(sub, super);
  }

  // Internal graph. First, a map of connections between expressions.
  // map[A] => [B, C, ..]  indicates that A must be a subtype of B and C.
  std::unordered_map<Expression*, std::vector<Expression*>> exprSubtyping;

  // Second the "roots": expressions that must be subtypes of fixed types.
  std::unordered_map<Expression*, Type> roots;

  void addExprSubtyping(Expression* sub, Expression* super) {
    exprSubtyping[sub].push_back(super);
  }

  void addRoot(Expression* sub, Type super) {
    roots[sub] = super;
  }

  // Can these be in subtype-exprs?
  std::vector<LocalGet*> gets;
  std::vector<LocalSet*> sets;

  // Main processing code on the graph. We do a straightforward flow of
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
  void process() {
    // A work item is an expression and a type that we have learned it must be a
    // subtype of.
    using WorkItem = std::pair<Expression*, Type>;

    // The initial work are the roots.
    UniqueDeferredQueue<Expression*> work;
    for (auto& [expr, super] : roots) {
      work.push({expr, super});
    }

    while (!work.empty()) {
      auto [expr, type] = work.pop();

      // We use |roots| as we go, that is, as we learn more we add more roots,
      // and we refine the types there. (The more we refine, the worst we can
      // generalize.)
      auto& entry = roots[expr];
      if (entry != Type::none && Type::isSubType(type, entry)) {
        // This is either the first type for this expression, or it is more
        // refined, so there is more work to do: update the entry, and flow
        // onwards.
        entry = type;
      }
    }
  }
};

} // anonymous namespace

Pass* createTypeGeneralizing2Pass() { return new TypeGeneralizing; }

} // namespace wasm

