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

namespace wasm {

// An expression with a cached hash value
struct HashedExpression {
  Expression* expr;
  size_t digest;

  HashedExpression(Expression* expr) : expr(expr) {
    if (expr) {
      digest = ExpressionAnalyzer::hash(expr);
    } else {
      digest = hash(0);
    }
  }

  HashedExpression(const HashedExpression& other)
    : expr(other.expr), digest(other.digest) {}
};

// A pass that hashes all functions

struct FunctionHasher : public WalkerPass<PostWalker<FunctionHasher>> {
  bool isFunctionParallel() override { return true; }

  struct Map : public std::map<Function*, size_t> {};

  FunctionHasher(Map* output) : output(output) {}

  FunctionHasher* create() override { return new FunctionHasher(output); }

  static Map createMap(Module* module) {
    Map hashes;
    for (auto& func : module->functions) {
      // ensure an entry for each function - we must not modify the map shape in
      // parallel, just the values
      hashes[func.get()] = hash(0);
    }
    return hashes;
  }

  void doWalkFunction(Function* func) { output->at(func) = hashFunction(func); }

  static size_t hashFunction(Function* func) {
    auto digest = hash(func->sig.params.getID());
    rehash(digest, func->sig.results.getID());
    for (auto type : func->vars) {
      rehash(digest, type.getID());
    }
    hash_combine(digest, ExpressionAnalyzer::hash(func->body));
    return digest;
  }

private:
  Map* output;
};

} // namespace wasm

#endif // _wasm_ir_hashed_h
