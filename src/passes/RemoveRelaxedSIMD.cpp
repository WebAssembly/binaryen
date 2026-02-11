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

//
// Replaces relaxed SIMD instructions with traps.
//

#include <memory>

#include "ir/localize.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

struct RemoveRelaxedSIMD : WalkerPass<PostWalker<RemoveRelaxedSIMD>> {
  bool isFunctionParallel() { return true; }

  void replace(Expression* curr) {
    auto* block =
      ChildLocalizer(curr, getFunction(), *getModule(), getPassOptions())
        .getChildrenReplacement();
    block->list.push_back(Builder(*getModule()).makeUnreachable());
    replaceCurrent(block);
  }

  void visitUnary(Unary* curr) {
    switch (curr->op) {
      case RelaxedTruncSVecF32x4ToVecI32x4:
      case RelaxedTruncUVecF32x4ToVecI32x4:
      case RelaxedTruncZeroSVecF64x2ToVecI32x4:
      case RelaxedTruncZeroUVecF64x2ToVecI32x4:
        replace(curr);
        return;
      default:
        break;
    }
  }

  void visitBinary(Binary* curr) {
    switch (curr->op) {
      case RelaxedSwizzleVecI8x16:
      case RelaxedMinVecF32x4:
      case RelaxedMaxVecF32x4:
      case RelaxedMinVecF64x2:
      case RelaxedMaxVecF64x2:
      case RelaxedQ15MulrSVecI16x8:
      case DotI8x16I7x16SToVecI16x8:
        replace(curr);
        return;
      default:
        break;
    }
  }

  void visitSIMDTernary(SIMDTernary* curr) {
    switch (curr->op) {
      case RelaxedMaddVecF16x8:
      case RelaxedNmaddVecF16x8:
      case RelaxedMaddVecF32x4:
      case RelaxedNmaddVecF32x4:
      case RelaxedMaddVecF64x2:
      case RelaxedNmaddVecF64x2:
      case LaneselectI8x16:
      case LaneselectI16x8:
      case LaneselectI32x4:
      case LaneselectI64x2:
      case DotI8x16I7x16AddSToVecI32x4:
        replace(curr);
        return;
      default:
        break;
    }
  }

  void visitFunction(Function* func) {
    ReFinalize().walkFunctionInModule(func, getModule());
  }

  std::unique_ptr<Pass> create() {
    return std::make_unique<RemoveRelaxedSIMD>();
  }
};

Pass* createRemoveRelaxedSIMDPass() { return new RemoveRelaxedSIMD(); }

} // namespace wasm
