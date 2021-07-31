/*
 * Copyright 2019 WebAssembly Community Group participants
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
// Find struct fields that are always written to with a constant value, and
// replace gets of them with that value.
//
// For example, if we have a vtable type T, and we always create it with one of
// the fields containing a ref.func of the same function F, and there is no
// write to that field of a different value (even using a subtype of T), then
// anywhere we see a get of that field we can place a ref.func of F.
//
// FIXME: This pass assumes a closed world. When we start to allow multi-module
//        wasm GC programs we need to check for type escaping.
//

#include "ir/properties.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

namespace {

// Represents data about the values written.
struct ValueInfo {
  // Note a written value as we see it, and update our internal knowledge based
  // on it and all previous values noted.
  void note(Literal curr) {
    if (!hasNoted()) {
      // This is the first value.
      value = curr;
      return;
    }

    // This is a subsequent value. Check if it is different from all previous
    // ones.
    if (value != curr) {
      noteVariable();
    }
  }

  // Notes a value that is variable - unknown at compile time. This means we
  // fail to find a single constant value here.
  void noteVariable() {
    value.type = Type::none;
  }

  // Combine the information in a given ValueInfo to this one. This is the same
  // as if we have called note*() on us with all the history of calls to that
  // other object.
  void combine(const ValueInfo& other) {
    if (!other.hasNoted()) {
      return;
    }
    if (!hasNoted()) {
      *this = other;
      return;
    }
    if (!other.isConstant() || getConstantValue() != other.getConstantValue()) {
      noteVariable();
    }
  }

  // Check if all the values are identical and constant.
  bool isConstant() {
    return value.type.isConcrete();
  }

  Literal getConstantValue() {
    assert(isConstant());
    return value;
  }

private:
  // The one value we have seen, if there is one. Initialized to have type
  // unreachable to indicate nothing has been seen yet. When values conflict,
  // we mark this as type none to indicate failure. Otherwise, a concrete type
  // indicates we have seen one value so far.
  Literal value = Literal(Type::unreachable);

  bool hasNoted() {
    return value.type == Type::unreachable;
  }
};

// Map of types to a vector of infos, one for each field.
struct FieldValueInfo : public std::unordered_map<HeapType, std::vector<ValueInfo>> {
  // When we access an item, if it does not already exist, create it with a
  // vector of the right length.
  std::vector<ValueInfo>& operator[](HeapType type) {
    auto iter = find(type);
    if (iter != end()) {
      return iter->second;
    }
    auto& ret = (*this)[type];
    ret.resize(type.getStruct().fields.size());
    return ret;
  }
};

// Map of function to their field value infos. We compute those in parallel.
using FunctionFieldValueInfo = std::unordered_map<Function*, FieldValueInfo>;

struct FunctionScanner : public WalkerPass<PostWalker<FunctionScanner>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new FunctionScanner(functionInfos); }

  FunctionScanner(
    const std::unordered_map<Name, TableUtils::FlatTable>* functionInfos)
    : functionInfos(functionInfos) {}

  void visitStructNew(StructNew* curr) {
    auto type = curr->rtt->type;
    if (type == Type::unreachable) {
      return;
    }
    auto heapType = type.getHeapType();
    auto& infos = getInfos();
    auto& fields = heapType.getStruct().fields;
    for (Index i = 0; i < fields.size(); i++) {
      auto& info = infos[heapType][i];
      if (curr->isWithDefault()) {
        info.note(Literal::makeZero(type));
      } else {
        noteExpression(expr, info);
      }
    }
  }

  void visitStructSet(StructSet* curr) {
    auto& infos = getInfos();
    auto type = curr->ref->type;
    if (type == Type::unreachable) {
      return;
    }
    auto heapType = type.getHeapType();
    auto& field = heapType.getStruct().fields[curr->index];
    noteExpression(curr->value, getInfos()[heapType][i]);
  }

private:
  const FunctionFieldValueInfo* functionInfos;

  FieldValueInfo& getInfos() {
    return (*functionInfos)[getFunction()];
  }

  void noteExpression(Expression* expr, ValueInfo& info) {
    auto* expr = curr->operands[i];
    if (!Properties::isConstantExpression(expr)) {
      info.noteVariable();
    } else {
      info.note(Properties::getLiteral(expr));
    }
  }
};

struct ConstantFieldPropagation : public Pass {
  void run(PassRunner* runner, Module* module) override {
    // Find and analyze all writes inside each function.
    FunctionFieldValueInfo functionInfos;
    for (auto& func : module->functions) {
      // Initialize the data for each function, so that we can operate on this
      // structure in parallel without modifying it.
      functionInfos[func.get()];
    }
    FunctionScanner(functionInfos).run(runner, module);

    // Combine the data from the functions.
    FieldValueInfo combinedInfos;
    for (auto& kv : functionInfos) {
      FieldValueInfo& infos = kv.second;
      for (auto& kv : infos) {
        auto type = kv.first;
        auto& vec = kv.second;
        auto combinedInfo = combinedInfos[type];
        for (Index i = 0; i < vec.size(); i++) {
          combinedInfo[i].combine(vec[i]);
        }
      }
    }
  }
};

} // anonymous namespace

Pass* createConstantFieldPropagationPass() { return new ConstantFieldPropagation(); }

} // namespace wasm
