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

#include "ir/intrinsics.h"
#include "wasm-builder.h"

namespace wasm {

static Name BinaryenIntrinsics("binaryen-intrinsics"),
            ConsumerUsed("consumer.used");

bool Intrinsics::isConsumerUsed(Call* call) {
  auto* func = module.getFunctionOrNull(call->target);
  return func->module == BinaryenIntrinsics && func->base == ConsumerUsed;
}

Expression* Intrinsics::lower(Call* call) {
  Builder builder(module);

  if (isConsumerUsed(call)) {
    // The final lowering must assume the consumer's value might be used.
    return builder.makeConst(int32_t(1));
  }

  // Not an intrinsic.
  return call;
}

} // namespace wasm
