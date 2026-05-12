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
// Sorts functions by structural similarity. This groups mutually-compressible
// instruction sequences together, maximizing subsequent compression ratio
// (e.g., Gzip/Brotli).
//

#include <algorithm>
#include <memory>
#include <vector>

#include "ir/module-utils.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm.h"

namespace wasm {

// Post-order traversal visitor to extract instruction sequence
struct OpcodeSequenceBuilder
  : public PostWalker<OpcodeSequenceBuilder,
                      UnifiedExpressionVisitor<OpcodeSequenceBuilder>> {
  std::vector<uint32_t> sequence;
  const size_t max_len = 512;

  void visitExpression(Expression* curr) {
    if (sequence.size() >= max_len) {
      return;
    }
    // Append the core expression ID
    sequence.push_back(curr->_id);

    // Capture important immediate type/operator information
    // TODO: There's probably more data that would be useful to capture.
    if (auto* unary = curr->dynCast<Unary>()) {
      sequence.push_back(unary->op);
    } else if (auto* binary = curr->dynCast<Binary>()) {
      sequence.push_back(binary->op);
    } else if (auto* load = curr->dynCast<Load>()) {
      sequence.push_back(load->bytes);
      sequence.push_back(load->offset);
    } else if (auto* store = curr->dynCast<Store>()) {
      sequence.push_back(store->bytes);
      sequence.push_back(store->offset);
    } else if (auto* localGet = curr->dynCast<LocalGet>()) {
      sequence.push_back(localGet->type.getID());
    } else if (auto* localSet = curr->dynCast<LocalSet>()) {
      sequence.push_back(localSet->type.getID());
    } else if (auto* const_ = curr->dynCast<Const>()) {
      sequence.push_back(const_->type.getID());
    }
  }
};

struct ReorderFunctionsBySimilarity : public Pass {
  bool requiresNonNullableLocalFixups() override { return false; }

  void run(Module* module) override {
    // If the number of defined functions is small, similarity-based reordering
    // does not help and can regress size due to increasing LEB size.
    size_t numDefined = 0;
    for (const auto& func : module->functions) {
      if (!func->imported()) {
        numDefined++;
      }
    }
    size_t minFunctions = 150;
    auto arg = getArgumentOrDefault("reorder-functions-by-similarity", "");
    if (!arg.empty()) {
      minFunctions = std::stoul(arg);
    }
    if (numDefined < minFunctions) {
      return;
    }

    struct FunctionSimilarityInfo {
      std::string typeStr;
      std::vector<std::string> varsStrs;
      std::vector<uint32_t> opcodeSequence;
    };

    ModuleUtils::ParallelFunctionAnalysis<FunctionSimilarityInfo> analysis(
      *module, [&](Function* func, FunctionSimilarityInfo& info) {
        if (func->imported()) {
          return;
        }
        info.typeStr = func->type.toString();
        info.varsStrs.reserve(func->vars.size());
        for (auto var : func->vars) {
          info.varsStrs.push_back(var.toString());
        }
        OpcodeSequenceBuilder builder;
        builder.walk(func->body);
        info.opcodeSequence = std::move(builder.sequence);
      });

    struct FunctionSortKey {
      std::unique_ptr<Function> func;
      std::string typeStr;
      std::vector<std::string> varsStrs;
      std::vector<uint32_t> opcodeSequence;
      size_t originalIndex;

      bool operator<(const FunctionSortKey& other) const {
        if (typeStr != other.typeStr) {
          return typeStr < other.typeStr;
        }
        if (varsStrs != other.varsStrs) {
          return varsStrs < other.varsStrs;
        }
        if (opcodeSequence != other.opcodeSequence) {
          return opcodeSequence < other.opcodeSequence;
        }
        return originalIndex < other.originalIndex;
      }
    };

    // 1. Separate imported and defined functions, and build sort keys
    std::vector<std::unique_ptr<Function>> importedFuncs;
    std::vector<FunctionSortKey> keys;
    keys.reserve(module->functions.size());

    size_t originalIndex = 0;
    for (auto& func : module->functions) {
      if (func->imported()) {
        importedFuncs.push_back(std::move(func));
      } else {
        FunctionSortKey key;
        auto& info = analysis.map[func.get()];
        key.typeStr = std::move(info.typeStr);
        key.varsStrs = std::move(info.varsStrs);
        key.opcodeSequence = std::move(info.opcodeSequence);
        key.originalIndex = originalIndex++;
        key.func = std::move(func);
        keys.push_back(std::move(key));
      }
    }

    // 2. Sort defined functions by the similarity heuristic
    std::sort(keys.begin(), keys.end());

    // 3. Re-assemble module->functions vector
    module->functions.clear();
    module->functions.reserve(importedFuncs.size() + keys.size());

    for (auto& func : importedFuncs) {
      module->functions.push_back(std::move(func));
    }
    for (auto& key : keys) {
      module->functions.push_back(std::move(key.func));
    }
  }
};

Pass* createReorderFunctionsBySimilarityPass() {
  return new ReorderFunctionsBySimilarity();
}

} // namespace wasm
