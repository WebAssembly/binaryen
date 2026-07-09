/*
 * Copyright 2026 WebAssembly Community Group participants
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

#include "ir/abstract.h"
#include "wasm.h"

namespace wasm::Abstract {

std::ostream& operator<<(std::ostream& o, Op op) {
  #define HANDLE(x) case x: return o << #x;
  switch (op) {
    HANDLE(Abs)
    HANDLE(Neg)
    HANDLE(Popcnt)
    HANDLE(Add)
    HANDLE(Sub)
    HANDLE(Mul)
    HANDLE(DivU)
    HANDLE(DivS)
    HANDLE(RemU)
    HANDLE(RemS)
    HANDLE(Shl)
    HANDLE(ShrU)
    HANDLE(ShrS)
    HANDLE(RotL)
    HANDLE(RotR)
    HANDLE(And)
    HANDLE(Or)
    HANDLE(Xor)
    HANDLE(CopySign)
    HANDLE(EqZ)
    HANDLE(Eq)
    HANDLE(Ne)
    HANDLE(LtS)
    HANDLE(LtU)
    HANDLE(LeS)
    HANDLE(LeU)
    HANDLE(GtS)
    HANDLE(GtU)
    HANDLE(GeS)
    HANDLE(GeU)
    default:
      WASM_UNREACHABLE("bad abstract op");
  }
}

} // namespace wasm::Abstract

