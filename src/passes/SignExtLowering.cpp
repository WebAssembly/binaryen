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

//
// Lowers sign-ext operations into wasm MVP operations.
//

#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

struct SignExtLowering : public WalkerPass<PostWalker<SignExtLowering>> {
  template<typename T>
  void lowerToShifts(Expression* value,
                     BinaryOp leftShift,
                     BinaryOp rightShift,
                     T originalBits) {
    // To sign-extend, we shift all the way left so the effective sign bit is
    // where the actual sign bit is. For example, when sign-extending i8, the
    // effective sign bit is at bit 8, and we shift it to the actual place of
    // the sign bit, which is 32 for i32 or 64 for i64. Then we do a signed
    // shift in the other direction, which fills with the proper bit all the
    // way back, so e.g.
    //
    //  0x000000ff  =(shift left)=>  0xff000000  =(shift right)=>  0xffffffff
    //
    T shiftBits = (sizeof(T) * 8) - originalBits;
    Builder builder(*getModule());
    replaceCurrent(builder.makeBinary(
      rightShift,
      builder.makeBinary(leftShift, value, builder.makeConst(shiftBits)),
      builder.makeConst(shiftBits)));
  }

  void visitUnary(Unary* curr) {
    switch (curr->op) {
      case ExtendS8Int32:
        lowerToShifts(curr->value, ShlInt32, ShrSInt32, int32_t(8));
        break;
      case ExtendS16Int32:
        lowerToShifts(curr->value, ShlInt32, ShrSInt32, int32_t(16));
        break;
      case ExtendS8Int64:
        lowerToShifts(curr->value, ShlInt64, ShrSInt64, int64_t(8));
        break;
      case ExtendS16Int64:
        lowerToShifts(curr->value, ShlInt64, ShrSInt64, int64_t(16));
        break;
      case ExtendS32Int64:
        lowerToShifts(curr->value, ShlInt64, ShrSInt64, int64_t(32));
        break;
      default: {
      }
    }
  }

  void run(Module* module) override {
    if (!module->features.has(FeatureSet::SignExt)) {
      return;
    }
    super::run(module);
    module->features.disable(FeatureSet::SignExt);
  }
};

Pass* createSignExtLoweringPass() { return new SignExtLowering(); }

} // namespace wasm
