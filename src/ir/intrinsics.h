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
// Binaryen intrinsic functions look like calls to imports. Implementing them
// that way allows them to be read and written by other tools, and avoid
// confusing errors on a binary format error that could happen if we had a
// custom binary format representation for them.
//
// Intrinsics can be recognized by Intrinsics::isFoo() methods, that check if a
// call is a particular intrinsic.
//
// An intrinsic method may be optimized away by the optimizer. If it is not, it
// must be lowered before shipping the wasm, as otherwise it will look like a
// call to an import that does not exist.
//
// Each intrinsic defines its semantics, which includes what the optimizer is
// allowed to do with it, and what the final lowering will turn it to.
//
// The final lowering is not done automatically - a user of intrinsics must run
// the pass for that explicitly. Note that, in general, some additional
// optimizations may be possible after the final lowering, and so a useful
// pattern might be this:
//
//   wasm-opt input.wasm -O --lower-intrinsics -O
//
// That is, to optimize once with intrinsics, then lower them away, then
// optimize once more.
//

namespace wasm {

class Intrinsics {
  Module& module;

public:
  Intrinsics(Module& module) : module(module) {}

  // Check if a call is the used() intrinsic. used() can be seen as returning 1
  // if the result might be used, and 0 otherwise.
  //
  // Semantics:
  //
  //  * A used() instance refers to a property of the control flow structure it
  //    is a child of. Call that the parent.
  //  * If the parent returns a concrete result, and that optimizer sees that
  //    result is not actually used - for example, by being dropped - then it
  //    can turn this used() instance into a constant of 0.
  //  * Final lowering turns this into a 1 (as we must assume the value might be
  //    used).
  //
  // used() is useful to be able to get rid of an unused result that has side
  // effects. For example (in simplified wat), assume we have an if whose
  // condition is used() and has one arm doing a call foo(), and the other is a
  // constant 0:
  //
  //   (if used() foo() 0)
  //
  // If that is dropped, then this happens:
  //
  //  (drop (if used() foo() 0))
  //  (drop (if 0      foo() 0))  // The optimizer replaces used() with 0.
  //  (drop 0)                    // The optimizer removes the if and the foo().
  //  (nop)                       // The optimizer removes the drop of 0.
  //
  // Or, if the value is actually used:
  //
  //  (local.set (if used() foo() 0))
  //  (local.set (if 1      foo() 0))  // Final lowering replaces used() with 1.
  //  (local.set foo())                // If is optimized out, leaving foo().
  //
  // Without used() the optimizer cannot remove a dropped call to foo() if foo()
  // has side effects. This, this intrinsic lets code generators control what
  // happens if a result is seen as not used, which can include ignoring side
  // effects.
  bool isUsed(Call* call);

  // Perform the final lowering of a possible intrinsic. If this call is not an
  // intrinsic, ignore it by returning the input.
  Expression* lower(Call* call);
};

} // namespace Intrinsics

} // namespace wasm

#endif // wasm_ir_intrinsics_h
