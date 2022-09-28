/*
 * Copyright 2017 WebAssembly Community Group participants
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

#ifndef _wasm_ir_hashed_h
#define _wasm_ir_hashed_h

#include "ir/utils.h"
#include "support/hash.h"
#include "wasm.h"
#include <functional>

namespace wasm {

// A pass that hashes all functions

struct FunctionHasher : public WalkerPass<PostWalker<FunctionHasher>> {
  bool isFunctionParallel() override { return true; }

  bool modifiesBinaryenIR() override { return false; }

  struct Map : public std::map<Function*, size_t> {};

  FunctionHasher(Map* output, ExpressionAnalyzer::ExprHasher customHasher)
    : output(output), customHasher(customHasher) {}
  FunctionHasher(Map* output)
    : output(output), customHasher(ExpressionAnalyzer::nothingHasher) {}

  std::unique_ptr<Pass> create() override {
    return std::make_unique<FunctionHasher>(output, customHasher);
  }

  static Map createMap(Module* module) {
    Map hashes;
    for (auto& func : module->functions) {
      // ensure an entry for each function - we must not modify the map shape in
      // parallel, just the values
      hashes[func.get()] = hash(0);
    }
    return hashes;
  }

  void doWalkFunction(Function* func) {
    output->at(func) = flexibleHashFunction(func, customHasher);
  }

  static size_t
  flexibleHashFunction(Function* func,
                       ExpressionAnalyzer::ExprHasher customHasher) {
    auto digest = hash(func->type);
    for (auto type : func->vars) {
      rehash(digest, type.getID());
    }
    hash_combine(digest,
                 ExpressionAnalyzer::flexibleHash(func->body, customHasher));
    return digest;
  }

  static size_t hashFunction(Function* func) {
    return flexibleHashFunction(func, ExpressionAnalyzer::nothingHasher);
  }

private:
  Map* output;
  ExpressionAnalyzer::ExprHasher customHasher;
};

} // namespace wasm

#endif // _wasm_ir_hashed_h
