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

#include "wasm.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "asm_v_wasm.h"

namespace wasm {

namespace {

struct FlatTable {
  std::vector<Name> names;
  bool valid;

  FlatTable(Table& table) {
    valid = true;
    for (auto& segment : table.segments) {
      auto offset = segment.offset;
      if (!offset->is<Const>()) {
        // TODO: handle some non-constant segments
        valid = false;
        return;
      }
      Index start = offset->cast<Const>()->value.geti32();
      Index end = start + segment.data.size();
      if (end > names.size()) {
        names.resize(end);
      }
      for (Index i = 0; i < segment.data.size(); i++) {
        names[start + i] = segment.data[i];
      }
    }
  }
};

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
        replaceWithUnreachable();
        return;
      }
      auto name = flatTable->names[index];
      if (!name.is()) {
        replaceWithUnreachable();
        return;
      }
      auto* func = getModule()->getFunction(name);
      if (getSig(getModule()->getFunctionType(curr->fullType)) !=
          getSig(func)) {
        replaceWithUnreachable();
        return;
      }
      // Everything looks good!
      replaceCurrent(Builder(*getModule()).makeCall(
        name,
        curr->operands,
        curr->type
      ));
    }
  }

private:
  FlatTable* flatTable;

  void replaceWithUnreachable() {
    replaceCurrent(Builder(*getModule()).makeUnreachable());
  }
};

struct Directize : public Pass {
  void run(PassRunner* runner, Module* module) override {
    if (!module->table.exists) return;
    if (module->table.imported()) return;
    for (auto& ex : module->exports) {
      if (ex->kind == ExternalKind::Table) return;
    }
    FlatTable flatTable(module->table);
    if (!flatTable.valid) return;
    // The table exists and is constant, so this is possible.
    {
      PassRunner runner(module);
      runner.setIsNested(true);
      runner.add<FunctionDirectizer>(&flatTable);
      runner.run();
    }
  }
};

} // anonymous namespace

Pass *createDirectizePass() {
  return new Directize();
}

} // namespace wasm

