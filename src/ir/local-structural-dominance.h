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
// This class is useful for the handling of non-nullable locals that is in the
// wasm spec: a local.get validates if it is structurally dominated by a set.
// That dominance proves the get cannot access the default null value, and,
// nicely, it can be validated in linear time. (Historically, this was called
// "1a" during spec discussions.)
//
// Concretely, this class finds which local indexes lack the structural
// dominance property. It only looks at reference types and not anything else.
// It can look at both nullable and non-nullable references, though, as it can
// be used to validate non-nullable ones, and also to check if a nullable one
// could become non-nullable and still validate.
//
// The property of "structural dominance" means that the set dominates the gets
// using wasm's structured control flow constructs, like this:
//
//  (block $A
//    (local.set $x ..)
//    (local.get $x) ;; use in the same scope.
//    (block $B
//      (local.get $x) ;; use in an inner scope.
//    )
//  )
//
// That set structurally dominates both of those gets. However, in this example
// it does not:
//
//  (block $A
//    (local.set $x ..)
//  )
//  (local.get $x) ;; use in an outer scope.
//
// This is a little similar to breaks: (br $foo) can only go to a label $foo
// that is in scope.
//
// Note that this property must hold on the final wasm binary, while we are
// checking it on Binaryen IR. The property will carry over, however: when
// lowering to wasm we may remove some Block nodes, but removing nodes cannot
// break validation.
//
// In fact, since Blocks without names are not emitted in the binary format (we
// never need them, since nothing can branch to them, so we just emit their
// contents), we can ignore them here. That means that this will validate, which
// is identical to the last example but the block has no name:
//
//  (block ;; no name here
//    (local.set $x ..)
//  )
//  (local.get $x)
//
// It is useful to ignore such blocks here, as various passes emit them
// temporarily.
//
struct LocalStructuralDominance {
  // We always look at non-nullable locals, but can be configured to ignore
  // or process nullable ones.
  enum Mode {
    All,
    NonNullableOnly,
  };

  LocalStructuralDominance(Function* func, Module& wasm, Mode mode = All);

  // Local indexes for whom a local.get exists that is not structurally
  // dominated.
  std::set<Index> nonDominatingIndices;
};

} // namespace wasm

#endif // wasm_ir_local_structural_dominance_h
