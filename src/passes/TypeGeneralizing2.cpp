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
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

namespace {

struct TypeGeneralizing : WalkerPass<ControlFlowWalker<TypeGeneralizing, SubtypingDiscoverer<TypeGeneralizing>>> {
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

  // Main processing code on the graph.
  void process() {
  }
};

} // anonymous namespace

Pass* createTypeGeneralizing2Pass() { return new TypeGeneralizing; }

} // namespace wasm

