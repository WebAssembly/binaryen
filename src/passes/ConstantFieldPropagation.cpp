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

#include "ir/utils.h"
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
  void note(Expression* curr) {
    if (!value) {
      // This is the first value.
      value = curr;
      return;
    }
    // This is a subsequent value. Check if it is different from all previous
    // ones.
    if (!ExpressionAnalyzer::equal(curr, value)) {
      value = &NoSingleValue;
    }
  }

  // Check if all the values are identical.
  bool allValuesIdentical() {
    return value && value != &NoSingleValue;
  }

private:
  // Start by noting that we have seen no written value at all, indicated by
  // nullptr. If a exactly one constant value is written, we point to one of
  // the (identical) instances of it here. If more than a single constant value is written, we will
  // point to Multiple.
  Expression* value = nullptr;

  static Nop NoSingleValue;

};

// Map of (type, field index) to data about the written values there.
using FieldValueInfo = std::unordered_map<std::pair<HeapType, Index>, ValueInfo>;

struct FindWrites : public WalkerPass<PostWalker<FunctionConstantFieldPropagationr>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new FunctionConstantFieldPropagationr(tables); }

  FunctionConstantFieldPropagationr(
    const std::unordered_map<Name, TableUtils::FlatTable>& tables)
    : tables(tables) {}

  void visitCallIndirect(CallIndirect* curr) {
    auto it = tables.find(curr->table);
    if (it == tables.end()) {
      return;
    }

    auto& flatTable = it->second;

    if (auto* c = curr->target->dynCast<Const>()) {
      Index index = c->value.geti32();
      // If the index is invalid, or the type is wrong, we can
      // emit an unreachable here, since in Binaryen it is ok to
      // reorder/replace traps when optimizing (but never to
      // remove them, at least not by default).
      if (index >= flatTable.names.size()) {
        replaceWithUnreachable(curr);
        return;
      }
      auto name = flatTable.names[index];
      if (!name.is()) {
        replaceWithUnreachable(curr);
        return;
      }
      auto* func = getModule()->getFunction(name);
      if (curr->sig != func->getSig()) {
        replaceWithUnreachable(curr);
        return;
      }
      // Everything looks good!
      replaceCurrent(
        Builder(*getModule())
          .makeCall(name, curr->operands, curr->type, curr->isReturn));
    }
  }

  void visitCallRef(CallRef* curr) {
    if (auto* ref = curr->target->dynCast<RefFunc>()) {
      // We know the target!
      replaceCurrent(
        Builder(*getModule())
          .makeCall(ref->func, curr->operands, curr->type, curr->isReturn));
    }
  }

  void doWalkFunction(Function* func) {
    WalkerPass<PostWalker<FunctionConstantFieldPropagationr>>::doWalkFunction(func);
    if (changedTypes) {
      ReFinalize().walkFunctionInModule(func, getModule());
    }
  }

private:
  const std::unordered_map<Name, TableUtils::FlatTable> tables;

  bool changedTypes = false;

  void replaceWithUnreachable(CallIndirect* call) {
    Builder builder(*getModule());
    for (auto*& operand : call->operands) {
      operand = builder.makeDrop(operand);
    }
    replaceCurrent(builder.makeSequence(builder.makeBlock(call->operands),
                                        builder.makeUnreachable()));
    changedTypes = true;
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
    FunctionConstantFieldPropagationr(validTables).run(runner, module);
  }
};

} // anonymous namespace

Pass* createConstantFieldPropagationPass() { return new ConstantFieldPropagation(); }

} // namespace wasm
