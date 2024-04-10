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

#include "ir/properties.h"
#include "wasm-traversal.h"

namespace wasm::Properties {

bool isGenerative(Expression* curr, FeatureSet features) {
  struct Scanner : public PostWalker<Scanner> {
    bool generative = false;

    void visitCall(Call* curr) {
      // TODO: We could in principle look at the called function to see if it is
      //       generative. To do that we'd need to compute generativity like we
      //       compute global effects (we can't just peek from here, as the
      //       other function might be modified in parallel).
      generative = true;
    }
    void visitCallIndirect(CallIndirect* curr) { generative = true; }
    void visitCallRef(CallRef* curr) { generative = true; }
    void visitStructNew(StructNew* curr) { generative = true; }
    void visitArrayNew(ArrayNew* curr) { generative = true; }
    void visitArrayNewFixed(ArrayNewFixed* curr) { generative = true; }
  } scanner;
  scanner.walk(curr);
  return scanner.generative;
}

// Checks an expression in a shallow manner (i.e., does not check children) as
// to whether it is valid in a wasm constant expression.
static bool isValidInConstantExpression(Module& wasm, Expression* expr) {
  if (isSingleConstantExpression(expr) || expr->is<StructNew>() ||
      expr->is<ArrayNew>() || expr->is<ArrayNewFixed>() || expr->is<RefI31>() ||
      expr->is<StringConst>()) {
    return true;
  }

  if (auto* refAs = expr->dynCast<RefAs>()) {
    if (refAs->op == ExternExternalize || refAs->op == ExternInternalize) {
      return true;
    }
  }

  if (auto* get = expr->dynCast<GlobalGet>()) {
    auto* g = wasm.getGlobalOrNull(get->name);
    // This is called from the validator, so we have to handle non-existent
    // globals gracefully.
    if (!g) {
      return false;
    }
    // Only gets of immutable globals are constant.
    if (g->mutable_) {
      return false;
    }
    // Only imported globals are available in constant expressions unless GC is
    // enabled.
    return g->imported() || wasm.features.hasGC();
    // TODO: Check that there are no cycles between globals.
  }

  if (wasm.features.hasExtendedConst()) {
    if (auto* bin = expr->dynCast<Binary>()) {
      if (bin->op == AddInt64 || bin->op == SubInt64 || bin->op == MulInt64 ||
          bin->op == AddInt32 || bin->op == SubInt32 || bin->op == MulInt32) {
        return true;
      }
    }
  }

  return false;
}

bool isValidConstantExpression(Module& wasm, Expression* expr) {
  struct Walker : public PostWalker<Walker, UnifiedExpressionVisitor<Walker>> {
    bool valid = true;
    void visitExpression(Expression* curr) {
      if (!isValidInConstantExpression(*getModule(), curr)) {
        valid = false;
      }
    }
  } walker;
  walker.setModule(&wasm);
  walker.walk(expr);
  return walker.valid;
}

} // namespace wasm::Properties
