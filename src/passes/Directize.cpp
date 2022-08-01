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

#include "call-utils.h"
#include "ir/table-utils.h"
#include "ir/type-updating.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "../wasm.h"

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

    // If the target is constant, we can emit a direct call.
    if (curr->target->is<Const>()) {
      std::vector<Expression*> operands(curr->operands.begin(),
                                        curr->operands.end());
      replaceCurrent(makeDirectCall(operands, curr->target, flatTable, curr));
      return;
    }

    // Emit direct calls for things like a select over constants.
    if (auto* calls = CallUtils::convertToDirectCalls(
          curr,
          [&](Expression* target) {
            return getTargetInfo(target, flatTable, curr);
          },
          *getFunction(),
          *getModule())) {
      replaceCurrent(calls);
      // Note that types may have changed, as the utility here can add locals
      // which require fixups if they are non-nullable, for example.
      changedTypes = true;
      return;
    }
  }

  void doWalkFunction(Function* func) {
    WalkerPass<PostWalker<FunctionDirectizer>>::doWalkFunction(func);
    if (changedTypes) {
      ReFinalize().walkFunctionInModule(func, getModule());
      TypeUpdating::handleNonDefaultableLocals(func, *getModule());
    }
  }

private:
  const std::unordered_map<Name, TableUtils::FlatTable>& tables;

  bool changedTypes = false;

  // Given an expression that we will use as the target of an indirect call,
  // analyze it and return one of the results of CallUtils::IndirectCallInfo,
  // that is, whether we know a direct call target, or we know it will trap, or
  // if we know nothing.
  CallUtils::IndirectCallInfo
  getTargetInfo(Expression* target,
                const TableUtils::FlatTable& flatTable,
                CallIndirect* original) {
    auto* c = target->dynCast<Const>();
    if (!c) {
      return CallUtils::Unknown{};
    }

    Index index = c->value.geti32();

    // If the index is invalid, or the type is wrong, then this will trap.
    if (index >= flatTable.names.size()) {
      return CallUtils::Trap{};
    }
    auto name = flatTable.names[index];
    if (!name.is()) {
      return CallUtils::Trap{};
    }
    auto* func = getModule()->getFunction(name);
    if (original->heapType != func->type) {
      return CallUtils::Trap{};
    }
    return CallUtils::Known{name};
  }

  // Create a direct call for a given list of operands, an expression which is
  // known to contain a constant indicating the table offset, and the relevant
  // table. If we can see that the call will trap, instead return an
  // unreachable.
  Expression* makeDirectCall(const std::vector<Expression*>& operands,
                             Expression* c,
                             const TableUtils::FlatTable& flatTable,
                             CallIndirect* original) {
    // If the index is invalid, or the type is wrong, we can
    // emit an unreachable here, since in Binaryen it is ok to
    // reorder/replace traps when optimizing (but never to
    // remove them, at least not by default).
    auto info = getTargetInfo(c, flatTable, original);
    if (std::get_if<CallUtils::Trap>(&info)) {
      return replaceWithUnreachable(operands);
    }
    assert(std::get_if<CallUtils::Known>(&info));
    auto name = std::get_if<CallUtils::Known>(&info)->target;

    // Everything looks good!
    return Builder(*getModule())
      .makeCall(name, operands, original->type, original->isReturn);
  }

  Expression* replaceWithUnreachable(const std::vector<Expression*>& operands) {
    // Emitting an unreachable means we must update parent types.
    changedTypes = true;

    Builder builder(*getModule());
    std::vector<Expression*> newOperands;
    for (auto* operand : operands) {
      newOperands.push_back(builder.makeDrop(operand));
    }
    return builder.makeSequence(builder.makeBlock(newOperands),
                                builder.makeUnreachable());
  }
};

struct Directize : public Pass {
  void run(PassRunner* runner, Module* module) override {
    // Find which tables are valid to optimize on. They must not be imported nor
    // exported (so the outside cannot modify them), and must have no sets in
    // any part of the module.

    // First, find which tables have sets.
    using TablesWithSet = std::unordered_set<Name>;

    ModuleUtils::ParallelFunctionAnalysis<TablesWithSet> analysis(
      *module, [&](Function* func, TablesWithSet& tablesWithSet) {
        if (func->imported()) {
          return;
        }
        for (auto* set : FindAll<TableSet>(func->body).list) {
          tablesWithSet.insert(set->table);
        }
      });

    TablesWithSet tablesWithSet;
    for (auto& [_, names] : analysis.map) {
      for (auto name : names) {
        tablesWithSet.insert(name);
      }
    }

    std::unordered_map<Name, TableUtils::FlatTable> validTables;

    for (auto& table : module->tables) {
      if (table->imported()) {
        continue;
      }

      if (tablesWithSet.count(table->name)) {
        continue;
      }

      bool canOptimizeCallIndirect = true;
      for (auto& ex : module->exports) {
        if (ex->kind == ExternalKind::Table && ex->value == table->name) {
          canOptimizeCallIndirect = false;
          break;
        }
      }
      if (!canOptimizeCallIndirect) {
        continue;
      }

      // All conditions are valid, this is optimizable.
      TableUtils::FlatTable flatTable(*module, *table);
      if (flatTable.valid) {
        validTables.emplace(table->name, flatTable);
      }
    }

    if (validTables.empty()) {
      return;
    }

    FunctionDirectizer(validTables).run(runner, module);
  }
};

} // anonymous namespace

Pass* createDirectizePass() { return new Directize(); }

} // namespace wasm
