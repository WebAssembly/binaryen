/*
 * Copyright 2018 WebAssembly Community Group participants
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

//
// Removes the `f32.copysign` and `f64.copysign` instructions and replaces them
// with equivalent bit operations. Primarily intended to be used with `wasm2asm`
// where `Math.copysign` doesn't exist.
//

#include <wasm.h>
#include <pass.h>

#include "wasm-builder.h"

namespace wasm {

struct RemoveCopysignPass : public WalkerPass<PostWalker<RemoveCopysignPass>> {
  bool isFunctionParallel() override { return false; }

  Pass* create() override { return new RemoveCopysignPass; }

  void doWalkModule(Module* module) {
    if (!builder) builder = make_unique<Builder>(*module);
    PostWalker<RemoveCopysignPass>::doWalkModule(module);
  }

  void doWalkFunction(Function* func) {
    if (!builder) builder = make_unique<Builder>(*getModule());
    PostWalker<RemoveCopysignPass>::doWalkFunction(func);
  }

  void visitBinary(Binary *curr) {
    Literal signBit, otherBits;
    UnaryOp int2float, float2int;
    BinaryOp bitAnd, bitOr;
    switch (curr->op) {
      case CopySignFloat32:
        float2int = ReinterpretFloat32;
        int2float = ReinterpretInt32;
        bitAnd = AndInt32;
        bitOr = OrInt32;
        signBit = Literal(uint32_t(1 << 31));
        otherBits = Literal(uint32_t(1 << 31) - 1);
        break;

      case CopySignFloat64:
        float2int = ReinterpretFloat64;
        int2float = ReinterpretInt64;
        bitAnd = AndInt64;
        bitOr = OrInt64;
        signBit = Literal(uint64_t(1) << 63);
        otherBits = Literal((uint64_t(1) << 63) - 1);
        break;

      default: return;
    }

    replaceCurrent(
      builder->makeUnary(
        int2float,
        builder->makeBinary(
          bitOr,
          builder->makeBinary(
            bitAnd,
            builder->makeUnary(
              float2int,
              curr->left
            ),
            builder->makeConst(otherBits)
          ),
          builder->makeBinary(
            bitAnd,
            builder->makeUnary(
              float2int,
              curr->right
            ),
            builder->makeConst(signBit)
          )
        )
      )
    );
  }

private:
  std::unique_ptr<Builder> builder;
};

Pass *createRemoveCopysignPass() {
  return new RemoveCopysignPass();
}

} // namespace wasm

