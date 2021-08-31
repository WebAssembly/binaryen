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
// call is a particular intrinsic.
//

namespace wasm {

class Intrinsics {
  Module& module;

public:
  Intrinsics(Module& module) : module(module) {}

  //
  // Check if a call is the consumer.used intrinsic.
  //
  //   (import "binaryen-intrinsics" "consumer.used" (func (result i32)))
  //
  // Loosely, consumer.used can be seen as returning 1 if the result of its
  // consumer might be used, and 0 otherwise.
  //
  // Precise semantics:
  //
  //  * consumer.used returns an i32. If that value is consumed, then used()'s
  //    value depends on that consumer.
  //  * If the consumer itself returns a value, and if the optimizer sees that
  //    the consumer's value is not actually used - for example, by being
  //    dropped - then this consumer.used instance can be replaced with a
  //    constant of 0.
  //  * Final lowering always turns this into a 1 (as we must assume the value
  //    might be used).
  //
  // consumer.used is useful to be able to get rid of an unused result that has
  // side effects. For example (in simplified wat), assume we have an if whose
  // condition is consumer.used and has one arm doing a call foo(), and the
  // other is a constant 0:
  //
  //   (if (call $consumer.used) (call $foo) (i32.const 0))
  //
  // Or, in simplified notation:
  //
  //   (if consumer.used() foo() 0)
  //
  // The "consumer" here is the if, which consumes the value of the intrinsic.
  // This is what happens if the if is dropped:
  //
  //  (drop (if consumer.used() foo() 0))
  //  (drop (if 0               foo() 0))  // The optimizer replaces
  //                                          consumer.used() with 0.
  //  (drop 0)  // The optimizer removes the if and the foo().
  //  (nop)     // The optimizer removes the drop of 0.
  //
  // Or, if the value is actually used:
  //
  //  (local.set (if consumer.used() foo() 0))
  //  (local.set (if 1               foo() 0))  // Final lowering replaces
  //                                            // consumer.used() with 1.
  //  (local.set foo())  // The if is optimized out, leaving foo().
  //
  // Without consumer.used() the optimizer cannot remove a dropped call because
  // it has side effects. Thus, this intrinsic lets code generators control what
  // happens if a result is seen as not used, which can include ignoring side
  // effects.
  //
  // More examples, with the value of consumer.used for them:
  //
  //   (local.set $x (select (a) (b) (call $consumer.used)))   =>   1
  //   (drop         (select (a) (b) (call $consumer.used)))   =>   0
  //   (local.set $x (i32.eqz (call $consumer.used)))          =>   1
  //
  // "Consumer" here means actual consumption of the result. For example, adding
  // a block in between the intrinsic and the consumer does not change things,
  // as the block just lets the value fall through:
  //
  //   (if (block (result i32) (call $consumer.used)) (a) (b)))
  //
  bool isConsumerUsed(Call* call);

  // Perform the final lowering of a possible intrinsic. If this call is not an
  // intrinsic, ignore it by returning the input.
  Expression* lower(Call* call);
};

} // namespace Intrinsics

} // namespace wasm

#endif // wasm_ir_intrinsics_h
