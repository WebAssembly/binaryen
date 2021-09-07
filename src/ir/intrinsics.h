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

#ifndef wasm_ir_intrinsics_h
#define wasm_ir_intrinsics_h

#include "pass.h"
#include "wasm-traversal.h"

//
// See the README.md for background on intrinsic functions.
//
// Intrinsics can be recognized by Intrinsics::isFoo() methods, that check if a
// call is a particular intrinsic. Each such call returns nullptr if the input
// is not that intrinsic, and otherwise the intrinsic itself cast to a Call*.
//

namespace wasm {

class Intrinsics {
  Module& module;

public:
  Intrinsics(Module& module) : module(module) {}

  //
  // Check if an instruction is the call.if.used intrinsic.
  //
  //   (import "binaryen-intrinsics" "call.if.used"
  //     (func (..params..) (param $target funcref) (..results..)))
  //
  // call.if.used can take any parameters, and in addition a funcref, and return
  // any (non-none) result.
  //
  // Precise semantics:
  //
  //  * If the optimizer sees that a call.if.used's result is not used - that
  //    is, the result is dropped (potentially after passing through as a
  //    block/if result, etc.) - then the optimizer can remove the call, by
  //    turning the call.if.used into a sequence of drops of all the parameters.
  //  * Final lowering always turns a call.if.used into a call_ref.
  //
  // call.if.used is useful to be able to get rid of an unused result that has
  // side effects. For example,
  //
  //  (drop (call $get-something))
  //
  // cannot be removed, as a call has side effects. But if a code generator
  // knows that it is fine to not make the call given that the result is
  // dropped (perhaps the side effects are to initialize a global cache, for
  // example) then instead of emitting
  //
  //   (call $get-something)
  //
  // it can emit
  //
  //   (call $call.if.used (ref.func $get-something))
  //
  // which will have this behavior in the optimizer if it is dropped:
  //
  //  (drop (call $call.if.used (ref.func $get-something)))
  //     =>
  //  (drop (ref.func $get-something))
  //
  // Later passes can then remove the dropped ref.func. Or, if the result is
  // actually used,
  //
  //  (local.set $x (call $call.if.used (ref.func $get-something)))
  //     =>
  //  (local.set $x (call_ref (ref.func $get-something)))
  //
  // Later passes will then turn that into a direct call and further optimize
  // things.
  //
  Call* isCallIfUsed(Expression* curr);
};

} // namespace wasm

#endif // wasm_ir_intrinsics_h
