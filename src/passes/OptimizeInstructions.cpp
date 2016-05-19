/*
 * Copyright 2016 WebAssembly Community Group participants
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
// Optimize combinations of instructions
//

#include <algorithm>

#include <wasm.h>
#include <pass.h>

namespace wasm {

struct OptimizeInstructions : public WalkerPass<PostWalker<OptimizeInstructions, Visitor<OptimizeInstructions>>> {
  bool isFunctionParallel() { return true; }

  void visitIf(If* curr) {
    // flip branches to get rid of an i32.eqz
    if (curr->ifFalse) {
      auto condition = curr->condition->dynCast<Unary>();
      if (condition && condition->op == EqZInt32 && condition->value->type == i32) {
        curr->condition = condition->value;
        std::swap(curr->ifTrue, curr->ifFalse);
      }
    }
  }
  void visitUnary(Unary* curr) {
    if (curr->op == EqZInt32) {
      // fold comparisons that flow into an EqZ
      auto* child = curr->value->dynCast<Binary>();
      if (child && (child->type == i32 || child->type == i64)) {
        switch (child->op) {
          case EqInt32:   child->op = NeInt32; break;
          case NeInt32:   child->op = EqInt32; break;
          case LtSInt32:  child->op = GeSInt32; break;
          case LtUInt32:  child->op = GeUInt32; break;
          case LeSInt32:  child->op = GtSInt32; break;
          case LeUInt32:  child->op = GtUInt32; break;
          case GtSInt32:  child->op = LeSInt32; break;
          case GtUInt32:  child->op = LeUInt32; break;
          case GeSInt32:  child->op = LtSInt32; break;
          case GeUInt32:  child->op = LtUInt32; break;
          case EqInt64:   child->op = NeInt64; break;
          case NeInt64:   child->op = EqInt64; break;
          case LtSInt64:  child->op = GeSInt64; break;
          case LtUInt64:  child->op = GeUInt64; break;
          case LeSInt64:  child->op = GtSInt64; break;
          case LeUInt64:  child->op = GtUInt64; break;
          case GtSInt64:  child->op = LeSInt64; break;
          case GtUInt64:  child->op = LeUInt64; break;
          case GeSInt64:  child->op = LtSInt64; break;
          case GeUInt64:  child->op = LtUInt64; break;
          case EqFloat32: child->op = NeFloat32; break;
          case NeFloat32: child->op = EqFloat32; break;
          case LtFloat32: child->op = GeFloat32; break;
          case LeFloat32: child->op = GtFloat32; break;
          case GtFloat32: child->op = LeFloat32; break;
          case GeFloat32: child->op = LtFloat32; break;
          case EqFloat64: child->op = NeFloat64; break;
          case NeFloat64: child->op = EqFloat64; break;
          case LtFloat64: child->op = GeFloat64; break;
          case LeFloat64: child->op = GtFloat64; break;
          case GtFloat64: child->op = LeFloat64; break;
          case GeFloat64: child->op = LtFloat64; break;
          default: return;
        }
        replaceCurrent(child);
      }
    }
  }
};

static RegisterPass<OptimizeInstructions> registerPass("optimize-instructions", "optimizes instruction combinations");

} // namespace wasm
