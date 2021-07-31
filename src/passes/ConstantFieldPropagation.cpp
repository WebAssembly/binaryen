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
    if (value.type == Type::unreachable) {
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
};

// Map of (type, field index) to data about the written values there.
using FieldValueInfo = std::unordered_map<std::pair<HeapType, Index>, ValueInfo>;

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
      auto& info = infos[{heapType, i}];
      if (curr->isWithDefault()) {
        info.note(Literal::makeZero(type));
      } else {
        noteExpression(expr, info);
      }
    }
  }

  void visitStructSet(StructSet* curr) {
    auto& infos = ;
    auto type = curr->ref->type;
    if (type == Type::unreachable) {
      return;
    }
    auto heapType = type.getHeapType();
    auto& field = heapType.getStruct().fields[curr->index];
    noteExpression(curr->value, getInfos()[{heapType, i}]);
  }

private:
  const std::unordered_map<Name, TableUtils::FlatTable>* functionInfos;

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
    std::unordered_map<Name, TableUtils::FlatTable> validTables;

    for (auto& table : module->tables) {
      if (!table->imported()) {
        bool canOptimizeCallIndirect = true;

        for (auto& ex : module->exports) {
          if (ex->kind == ExternalKind::Table && ex->value == table->name) {
            canOptimizeCallIndirect = false;
          }
        }

        if (canOptimizeCallIndirect) {
          TableUtils::FlatTable flatTable(*module, *table);
          if (flatTable.valid) {
            validTables.emplace(table->name, flatTable);
          }
        }
      }
    }

    // Without typed function references, all we can do is optimize table
    // accesses, so if we can't do that, stop.
    if (validTables.empty() && !module->features.hasTypedFunctionReferences()) {
      return;
    }
    // The table exists and is constant, so this is possible.
    FunctionScanner(validTables).run(runner, module);
  }
};

} // anonymous namespace

Pass* createConstantFieldPropagationPass() { return new ConstantFieldPropagation(); }

} // namespace wasm
