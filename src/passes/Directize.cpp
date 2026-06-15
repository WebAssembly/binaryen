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
// If called with
//
//   --pass-arg=directize-initial-contents-immutable
//
// then the initial tables' contents are assumed to be immutable (see
// TableUtils::TableInfo).
//

#include <unordered_map>

#include "call-utils.h"
#include "ir/drop.h"
#include "ir/eh-utils.h"
#include "ir/find_all.h"
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

  std::unique_ptr<Pass> create() override {
    return std::make_unique<FunctionDirectizer>(tables);
  }

  FunctionDirectizer(const TableUtils::TableInfoMap& tables) : tables(tables) {}

  bool optimized = false;

  void visitCallIndirect(CallIndirect* curr) {
    auto& table = tables.at(curr->table);
    if (!table.canOptimizeByEntry()) {
      return;
    }
    // If the target is constant, we can emit a direct call.
    if (curr->target->is<Const>()) {
      std::vector<Expression*> operands(curr->operands.begin(),
                                        curr->operands.end());
      makeDirectCall(operands, curr->target, table, curr);
      optimized = true;
      return;
    }

    // Emit direct calls for things like a select over constants.
    if (auto* calls = CallUtils::convertToDirectCalls(
          curr,
          [&](Expression* target) {
            return getTargetInfo(target, table, curr);
          },
          *getFunction(),
          *getModule())) {
      replaceCurrent(calls);
      optimized = true;
      // Note that types may have changed, as the utility here can add locals
      // which require fixups if they are non-nullable, for example.
      changedTypes = true;
      return;
    }
  }

  bool hasTry = false;

  void visitTry(Try* curr) { hasTry = true; }

  void doWalkFunction(Function* func) {
    WalkerPass<PostWalker<FunctionDirectizer>>::doWalkFunction(func);

    if (optimized && hasTry) {
      EHUtils::handleBlockNestedPops(func, *getModule());
    }

    if (changedTypes) {
      ReFinalize().walkFunctionInModule(func, getModule());
    }
  }

private:
  const TableUtils::TableInfoMap& tables;

  bool changedTypes = false;

  // Given an expression that we will use as the target of an indirect call,
  // analyze it and return one of the results of CallUtils::IndirectCallInfo,
  // that is, whether we know a direct call target, or we know it will trap, or
  // if we know nothing.
  CallUtils::IndirectCallInfo getTargetInfo(Expression* target,
                                            const TableUtils::TableInfo& info,
                                            CallIndirect* original) {
    auto* c = target->dynCast<Const>();
    if (!c) {
      return CallUtils::Unknown{};
    }

    Address index = c->value.getUnsigned();

    // Check if we know what is called from the table's initial content. We can
    // only do this if the initial contents are immutable, or if there is no
    // writing to the table at all.
    auto& flatTable = *info.flatTable;
    Name calledName;
    if (info.initialContentsImmutable || !info.hasSet) {
      if (index < flatTable.names.size()) {
        calledName = flatTable.names[index];
      }
      auto* table = getModule()->getTable(original->table);
      if (!calledName) {
        // We did not see a value there, but the table might have a default
        // value.
        if (table->imported()) {
          // An imported table might have a default value, and we can't tell.
          return CallUtils::Unknown{};
        }
        if (table->init) {
          if (index < table->initial) {
            // This is in bounds, so the default value of the table is called.
            if (auto* refFunc = table->init->dynCast<RefFunc>()) {
              calledName = refFunc->func;
            } else {
              // There is an initial value, but it is unknown, like a
              // global.get. We can infer nothing, not even a trap.
              return CallUtils::Unknown{};
            }
          } else {
            // We are beyond the initial table size, and can't infer anything,
            // unless we are in the simple case of no growth, in which case we
            // trap.
            if (!info.hasGrow) {
              return CallUtils::Trap{};
            } else {
              return CallUtils::Unknown{};
            }
          }
        }
      }
      // If we found no data, and the table init did not change anything, then
      // we trap.
      if (!calledName) {
        // But we must not read a place where grow can write to - we must either
        // have no grow, or have an index below where grow writes to.
        if (!info.hasGrow || index < table->initial) {
          return CallUtils::Trap{};
        }
      }
    }

    if (calledName) {
      // We know what is called, but it must have the right type.
      auto* func = getModule()->getFunction(calledName);
      if (!HeapType::isSubType(func->type.getHeapType(), original->heapType)) {
        return CallUtils::Trap{};
      }
      return CallUtils::Known{calledName};
    }

    // Otherwise, give up.
    return CallUtils::Unknown{};
  }

  // Create a direct call for a given list of operands, an expression which is
  // known to contain a constant indicating the table offset, and the relevant
  // table, if we can. If we can see that the call will trap, instead replace
  // with an unreachable.
  void makeDirectCall(const std::vector<Expression*>& operands,
                      Expression* c,
                      const TableUtils::TableInfo& table,
                      CallIndirect* original) {
    auto info = getTargetInfo(c, table, original);
    if (std::get_if<CallUtils::Unknown>(&info)) {
      // We don't know anything here.
      return;
    }
    // If the index is invalid, or the type is wrong, we can skip the call and
    // emit an unreachable here (with dropped children as needed), since in
    // Binaryen it is ok to reorder/replace traps when optimizing (but never to
    // remove them, at least not by default).
    if (std::get_if<CallUtils::Trap>(&info)) {
      replaceCurrent(
        getDroppedChildrenAndAppend(original,
                                    *getModule(),
                                    getPassOptions(),
                                    Builder(*getModule()).makeUnreachable(),
                                    DropMode::IgnoreParentEffects));
      changedTypes = true;
      return;
    }

    // Everything looks good!
    auto name = std::get<CallUtils::Known>(info).target;
    auto results = getModule()->getFunction(name)->getResults();
    replaceCurrent(Builder(*getModule())
                     .makeCall(name, operands, results, original->isReturn));

    // When we call a function of a subtype of the call_indirect's call type, we
    // may be refining results.
    if (results != original->type) {
      changedTypes = true;
    }
  }
};

struct Directize : public Pass {
  void run(Module* module) override {
    if (module->tables.empty()) {
      return;
    }

    // TODO: consider a per-table option here
    auto initialContentsImmutable =
      hasArgument("directize-initial-contents-immutable");

    auto tables =
      TableUtils::computeTableInfo(*module, initialContentsImmutable);

    // Stop if we cannot optimize anything.
    auto hasOptimizableTable = false;
    for (auto& [_, info] : tables) {
      if (info.canOptimizeByEntry()) {
        hasOptimizableTable = true;
        break;
      }
    }
    if (!hasOptimizableTable) {
      return;
    }

    // We can optimize!
    FunctionDirectizer(tables).run(getPassRunner(), module);
  }
};

} // anonymous namespace

Pass* createDirectizePass() { return new Directize(); }

} // namespace wasm
