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
#include "ir/iteration.h"
#include "wasm-traversal.h"

namespace wasm::Properties {

bool isGenerative(Expression* curr, FeatureSet features) {
  // Practically no wasm instructions are generative. Exceptions occur only in
  // GC atm.
  if (!features.hasGC()) {
    return false;
  }

  struct Scanner : public PostWalker<Scanner> {
    bool generative = false;
    void visitStructNew(StructNew* curr) { generative = true; }
    void visitArrayNew(ArrayNew* curr) { generative = true; }
    void visitArrayNewFixed(ArrayNewFixed* curr) { generative = true; }
  } scanner;
  scanner.walk(curr);
  return scanner.generative;
}

static bool isValidInConstantExpression(Module& wasm, Expression* expr) {
  if (isSingleConstantExpression(expr) || expr->is<StructNew>() ||
      expr->is<ArrayNew>() || expr->is<ArrayNewFixed>() || expr->is<I31New>() ||
      expr->is<StringConst>()) {
    return true;
  }

  if (auto* get = expr->dynCast<GlobalGet>()) {
    // Only gets of immutable globals are constant. Constant expressions are
    // also only validated in contexts that exclude locally defined globals, so
    // they must only refer to imported globals.
    auto* g = wasm.getGlobalOrNull(get->name);
    return g && !g->mutable_ && g->imported();
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
  std::vector<Expression*> exprs = {expr};
  while (!exprs.empty()) {
    Expression* curr = exprs.back();
    exprs.pop_back();
    if (!isValidInConstantExpression(wasm, curr)) {
      return false;
    }
    ChildIterator children(curr);
    exprs.insert(exprs.end(), children.begin(), children.end());
  }
  return true;
}

} // namespace wasm::Properties
