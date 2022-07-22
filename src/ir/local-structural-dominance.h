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

#ifndef wasm_ir_local_structural_dominance_h
#define wasm_ir_local_structural_dominance_h

#include "wasm.h"

namespace wasm {

//
// Finds which local.sets have structural dominance over their gets. This is
// important for things like non-nullable locals, and so this class only looks
// at reference types and not anything else. It does look at both nullable and
// non-nullable references, though, as it can be used to validate non-nullable
// ones, and also to check if a nullable one could become non-nullable and still
// validate.
//
// The property of "structural dominance" means that the set dominates the gets
// using wasm's structured control flow constructs, like this:
//
//  (block
//    (local.set $x ..)
//    (local.get $x) ;; use in the same scope.
//    (block
//      (local.get $x) ;; use in an inner scope.
//    )
//  )
//
// That set structurally dominates both of those gets. However, in this example
// it does not:
//
//  (block
//    (local.set $x ..)
//  )
//  (local.get $x) ;; use in an outer scope.
//
// This is a little similar to breaks: (br $foo) can only go to a label $foo
// that is in scope.
//
// Note that this properly must hold on the final wasm binary, while we are
// checking it on Binaryen IR. The propery will carry over, however: when
// lowering to wasm we may remove some Block nodes, but removing nodes cannot
// break validation.
//
// This concept is useful for the "1a" form of non-nullable locals that is in
// the wasm spec: a local.get validates if it is structurally dominated by a
// set. That dominance proves the get cannot access the default null value, and,
// nicely, it can be validated in linear time.
//
struct LocalStructuralDominance {
  LocalStructuralDominance(Function* func, Module& wasm);

  // Local indexes for whom a local.get exists that is not structurally
  // dominated.
  std::set<Index> nonDominatingIndexes;
};

} // namespace wasm

#endif // wasm_ir_local_structural_dominance_h
