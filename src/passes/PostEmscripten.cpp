/*
 * Copyright 2015 WebAssembly Community Group participants
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
// Misc optimizations that are useful for and/or are only valid for
// emscripten output.
//

#include <wasm.h>
#include <pass.h>
#include <wasm-builder.h>
#include <ir/localize.h>
#include <asmjs/shared-constants.h>

namespace wasm {

struct PostEmscripten : public WalkerPass<PostWalker<PostEmscripten>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new PostEmscripten; }

  // When we have a Load from a local value (typically a GetLocal) plus a constant offset,
  // we may be able to fold it in.
  // The semantics of the Add are to wrap, while wasm offset semantics purposefully do
  // not wrap. So this is not always safe to do. For example, a load may depend on
  // wrapping via
  //      (2^32 - 10) + 100   =>  wrap and load from address 90
  // Without wrapping, we get something too large, and an error. *However*, for
  // asm2wasm output coming from Emscripten, we allocate the lowest 1024 for mapped
  // globals. Mapped globals are simple types (i32, float or double), always
  // accessed directly by a single constant. Therefore if we see (..) + K where
  // K is less then 1024, then if it wraps, it wraps into [0, 1024) which is at best
  // a mapped global, but it can't be because they are accessed directly (at worst,
  // it's 0 or an unused section of memory that was reserved for mapped globlas).
  // Thus it is ok to optimize such small constants into Load offsets.

  #define SAFE_MAX 1024

  void optimizeMemoryAccess(Expression*& ptr, Address& offset) {
    while (1) {
      auto* add = ptr->dynCast<Binary>();
      if (!add) break;
      if (add->op != AddInt32) break;
      auto* left = add->left->dynCast<Const>();
      auto* right = add->right->dynCast<Const>();
      // note: in optimized code, we shouldn't see an add of two constants, so don't worry about that much
      // (precompute would optimize that)
      if (left) {
        auto value = left->value.geti32();
        if (value >= 0 && value < SAFE_MAX) {
          offset = offset + value;
          ptr = add->right;
          continue;
        }
      }
      if (right) {
        auto value = right->value.geti32();
        if (value >= 0 && value < SAFE_MAX) {
          offset = offset + value;
          ptr = add->left;
          continue;
        }
      }
      break;
    }
    // finally ptr may be a const, but it isn't worth folding that in (we still have a const); in fact,
    // it's better to do the opposite for gzip purposes as well as for readability.
    auto* last = ptr->dynCast<Const>();
    if (last) {
      last->value = Literal(int32_t(last->value.geti32() + offset));
      offset = 0;
    }
  }

  void visitLoad(Load* curr) {
    optimizeMemoryAccess(curr->ptr, curr->offset);
  }
  void visitStore(Store* curr) {
    optimizeMemoryAccess(curr->ptr, curr->offset);
  }

  void visitCall(Call* curr) {
    // special asm.js imports can be optimized
    auto* func = getModule()->getFunction(curr->target);
    if (!func->imported()) return;
    if (func->module == GLOBAL_MATH) {
      if (func->base == POW) {
        if (auto* exponent = curr->operands[1]->dynCast<Const>()) {
          if (exponent->value == Literal(double(2.0))) {
            // This is just a square operation, do a multiply
            Localizer localizer(curr->operands[0], getFunction(), getModule());
            Builder builder(*getModule());
            replaceCurrent(builder.makeBinary(MulFloat64, localizer.expr, builder.makeGetLocal(localizer.index, localizer.expr->type)));
          } else if (exponent->value == Literal(double(0.5))) {
            // This is just a square root operation
            replaceCurrent(Builder(*getModule()).makeUnary(SqrtFloat64, curr->operands[0]));
          }
        }
      }
    }
  }
};

Pass *createPostEmscriptenPass() {
  return new PostEmscripten();
}

} // namespace wasm
