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
// function is a particular intrinsic, or if a call to a function is so. The
// latter returns nullptr if the input is not that intrinsic, and otherwise the
// intrinsic itself cast to a Call*.
//

namespace wasm {

class Intrinsics {
  Module& module;

public:
  Intrinsics(Module& module) : module(module) {}

  //
  // Check if an instruction is the call.without.effects intrinsic.
  //
  //   (import "binaryen-intrinsics" "call.without.effects"
  //     (func (..params..) (param $target funcref) (..results..)))
  //
  // call.without.effects can take any parameters, and in addition a funcref,
  // and return any result.
  //
  // Precise semantics:
  //
  //  * The optimizer will assume this instruction has no side effects.
  //  * Final lowering turns a call.without.effects into a call of the given
  //    function with the given parameters. (This will either be a direct call,
  //    or a call_ref; note that either way, the function reference that appears
  //    here must have the proper type - if not, you will get an error.)
  //
  // call.without.effects is useful to be able to get rid of an unused result
  // that has side effects. For example,
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
  //   (call $call.without.effects (ref.func $get-something))
  //
  // which will have this behavior in the optimizer if it is dropped:
  //
  //  (drop (call $call.without.effects (ref.func $get-something)))
  //     =>
  //  (drop (ref.func $get-something))
  //
  // Later optimizations can remove the dropped ref.func. Or, if the result is
  // actually used,
  //
  //  (local.set $x (call $call.without.effects (ref.func $get-something)))
  //     =>
  //  (local.set $x (call $get-something))
  //
  // Later passes will then turn that into a direct call and further optimize
  // things.
  //
  bool isCallWithoutEffects(Function* func);
  Call* isCallWithoutEffects(Expression* curr);
};

} // namespace wasm

#endif // wasm_ir_intrinsics_h
