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

#include "support/hash.h"
#include "wasm.h"
#include "ir/utils.h"

namespace wasm {

// An expression with a cached hash value
struct HashedExpression {
  Expression* expr;
  HashType hash;

  HashedExpression(Expression* expr) : expr(expr) {
    if (expr) {
      hash = ExpressionAnalyzer::hash(expr);
    }
  }

  HashedExpression(const HashedExpression& other) : expr(other.expr), hash(other.hash) {}
};

struct ExpressionHasher {
  HashType operator()(const HashedExpression value) const {
    return value.hash;
  }
};

struct ExpressionComparer {
  bool operator()(const HashedExpression a, const HashedExpression b) const {
    if (a.hash != b.hash) return false;
    return ExpressionAnalyzer::equal(a.expr, b.expr);
  }
};

template<typename T>
class HashedExpressionMap : public std::unordered_map<HashedExpression, T, ExpressionHasher, ExpressionComparer> {
};

// A pass that hashes all functions

struct FunctionHasher : public WalkerPass<PostWalker<FunctionHasher>> {
  bool isFunctionParallel() override { return true; }

  struct Map : public std::map<Function*, HashType> {};

  FunctionHasher(Map* output) : output(output) {}

  FunctionHasher* create() override {
    return new FunctionHasher(output);
  }

  static Map createMap(Module* module) {
    Map hashes;
    for (auto& func : module->functions) {
      hashes[func.get()] = 0; // ensure an entry for each function - we must not modify the map shape in parallel, just the values
    }
    return hashes;
  }

  void doWalkFunction(Function* func) {
    output->at(func) = hashFunction(func);
  }

  static HashType hashFunction(Function* func) {
    HashType ret = 0;
    ret = rehash(ret, (HashType)func->getNumParams());
    for (auto type : func->params) {
      ret = rehash(ret, (HashType)type);
    }
    ret = rehash(ret, (HashType)func->getNumVars());
    for (auto type : func->vars) {
      ret = rehash(ret, (HashType)type);
    }
    ret = rehash(ret, (HashType)func->result);
    ret = rehash(ret, HashType(func->type.is() ? std::hash<wasm::Name>{}(func->type) : HashType(0)));
    ret = rehash(ret, (HashType)ExpressionAnalyzer::hash(func->body));
    return ret;
  }

private:
  Map* output;
};

} // namespace wasm

#endif // _wasm_ir_hashed_h

