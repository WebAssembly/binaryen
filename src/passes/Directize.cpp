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

#include "asm_v_wasm.h"
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

  Pass* create() override { return new FunctionDirectizer(flatTable); }

  FunctionDirectizer(FlatTable* flatTable) : flatTable(flatTable) {}

  void visitCallIndirect(CallIndirect* curr) {
    if (auto* c = curr->target->dynCast<Const>()) {
      Index index = c->value.geti32();
      // If the index is invalid, or the type is wrong, we can
      // emit an unreachable here, since in Binaryen it is ok to
      // reorder/replace traps when optimizing (but never to
      // remove them, at least not by default).
      if (index >= flatTable->names.size()) {
        replaceWithUnreachable(curr);
        return;
      }
      auto name = flatTable->names[index];
      if (!name.is()) {
        replaceWithUnreachable(curr);
        return;
      }
      auto* func = getModule()->getFunction(name);
      if (curr->sig != func->sig) {
        replaceWithUnreachable(curr);
        return;
      }
      // Everything looks good!
      replaceCurrent(
        Builder(*getModule())
          .makeCall(name, curr->operands, curr->type, curr->isReturn));
    }
  }

  void doWalkFunction(Function* func) {
    WalkerPass<PostWalker<FunctionDirectizer>>::doWalkFunction(func);
    if (changedTypes) {
      ReFinalize().walkFunctionInModule(func, getModule());
    }
  }

private:
  FlatTable* flatTable;
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
    if (!module->table.exists) {
      return;
    }
    if (module->table.imported()) {
      return;
    }
    for (auto& ex : module->exports) {
      if (ex->kind == ExternalKind::Table) {
        return;
      }
    }
    FlatTable flatTable(module->table);
    if (!flatTable.valid) {
      return;
    }
    // The table exists and is constant, so this is possible.
    FunctionDirectizer(&flatTable).run(runner, module);
  }
};

} // anonymous namespace

Pass* createDirectizePass() { return new Directize(); }

} // namespace wasm
