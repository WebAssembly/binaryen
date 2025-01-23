/*
 * Copyright 2024 WebAssembly Community Group participants
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

#include "ir/return-utils.h"
#include "ir/module-utils.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm::ReturnUtils {

namespace {

struct ReturnValueRemover : public PostWalker<ReturnValueRemover> {
  void visitReturn(Return* curr) {
    auto* value = curr->value;
    assert(value);
    curr->value = nullptr;
    Builder builder(*getModule());
    replaceCurrent(builder.makeSequence(builder.makeDrop(value), curr));
  }

  void visitCall(Call* curr) { handleReturnCall(curr); }
  void visitCallIndirect(CallIndirect* curr) { handleReturnCall(curr); }
  void visitCallRef(CallRef* curr) { handleReturnCall(curr); }

  template<typename T> void handleReturnCall(T* curr) {
    if (curr->isReturn) {
      Fatal() << "Cannot remove return_calls in ReturnValueRemover";
    }
  }

  void visitFunction(Function* curr) {
    if (curr->body->type.isConcrete()) {
      curr->body = Builder(*getModule()).makeDrop(curr->body);
    }
  }
};

} // anonymous namespace

void removeReturns(Function* func, Module& wasm) {
  ReturnValueRemover().walkFunctionInModule(func, &wasm);
}

std::unordered_map<Function*, bool> findReturnCallers(Module& wasm) {
  ModuleUtils::ParallelFunctionAnalysis<bool> analysis(
    wasm, [&](Function* func, bool& hasReturnCall) {
      if (func->imported()) {
        return;
      }

      struct Finder : PostWalker<Finder> {
        bool hasReturnCall = false;

        void visitCall(Call* curr) {
          if (curr->isReturn) {
            hasReturnCall = true;
          }
        }
        void visitCallIndirect(CallIndirect* curr) {
          if (curr->isReturn) {
            hasReturnCall = true;
          }
        }
        void visitCallRef(CallRef* curr) {
          if (curr->isReturn) {
            hasReturnCall = true;
          }
        }
      } finder;

      finder.walk(func->body);
      hasReturnCall = finder.hasReturnCall;
    });

  // Convert to an unordered map for fast lookups. TODO: Avoid a copy here.
  std::unordered_map<Function*, bool> ret;
  ret.reserve(analysis.map.size());
  for (auto& [k, v] : analysis.map) {
    ret[k] = v;
  }
  return ret;
}

} // namespace wasm::ReturnUtils
