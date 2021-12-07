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
// Turn indirect calls into direct calls. This is possible if we know
// the table cannot change, and if we see a constant argument for the
// indirect call's index.
//

#include <unordered_map>

#include "ir/table-utils.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

namespace {

struct FunctionDirectizer : public WalkerPass<PostWalker<FunctionDirectizer>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new FunctionDirectizer(tables); }

  FunctionDirectizer(
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
    WalkerPass<PostWalker<FunctionDirectizer>>::doWalkFunction(func);
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

struct Directize : public Pass {
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
    FunctionDirectizer(validTables).run(runner, module);
  }
};

} // anonymous namespace

Pass* createDirectizePass() { return new Directize(); }

} // namespace wasm
