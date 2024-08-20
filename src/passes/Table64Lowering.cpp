/*
 * Copyright 2024 WebAssembly Community Group participants
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
// Lowers a module with a 64-bit table to one with a 32-bit table.
//
// This pass can be deleted once table64 is implemented in Wasm engines:
// https://github.com/WebAssembly/memory64/issues/51
//

#include "ir/bits.h"
#include "ir/import-utils.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

static Name TABLE_BASE("__table_base");
static Name TABLE_BASE32("__table_base32");

struct Table64Lowering : public WalkerPass<PostWalker<Table64Lowering>> {

  void wrapAddress64(Expression*& ptr, Name tableName) {
    if (ptr->type == Type::unreachable) {
      return;
    }
    auto& module = *getModule();
    auto* table = module.getTable(tableName);
    if (table->is64()) {
      assert(ptr->type == Type::i64);
      ptr = Builder(module).makeUnary(UnaryOp::WrapInt64, ptr);
    }
  }

  void extendAddress64(Expression*& ptr, Name tableName) {
    if (ptr->type == Type::unreachable) {
      return;
    }
    auto& module = *getModule();
    auto* table = module.getTable(tableName);
    if (table->is64()) {
      assert(ptr->type == Type::i64);
      ptr->type = Type::i32;
      ptr = Builder(module).makeUnary(UnaryOp::ExtendUInt32, ptr);
    }
  }

  void visitTableSize(TableSize* curr) {
    auto& module = *getModule();
    auto* table = module.getTable(curr->table);
    if (table->is64()) {
      auto* size = static_cast<Expression*>(curr);
      extendAddress64(size, curr->table);
      replaceCurrent(size);
    }
  }

  void visitTableGrow(TableGrow* curr) {
    auto& module = *getModule();
    auto* table = module.getTable(curr->table);
    if (table->is64()) {
      wrapAddress64(curr->delta, curr->table);
      auto* size = static_cast<Expression*>(curr);
      extendAddress64(size, curr->table);
      replaceCurrent(size);
    }
  }

  void visitTableFill(TableFill* curr) {
    wrapAddress64(curr->dest, curr->table);
    wrapAddress64(curr->size, curr->table);
  }

  void visitTableCopy(TableCopy* curr) {
    wrapAddress64(curr->dest, curr->destTable);
    wrapAddress64(curr->source, curr->sourceTable);
    wrapAddress64(curr->size, curr->destTable);
  }

  void visitTableInit(TableInit* curr) {
    wrapAddress64(curr->dest, curr->table);
  }

  void visitCallIndirect(CallIndirect* curr) {
    wrapAddress64(curr->target, curr->table);
  }

  void visitElementSegment(ElementSegment* segment) {
    auto& module = *getModule();

    // Passive segments don't have any offset to update.
    if (segment->table.isNull() || !module.getTable(segment->table)->is64()) {
      return;
    }

    if (auto* c = segment->offset->dynCast<Const>()) {
      c->value = Literal(static_cast<uint32_t>(c->value.geti64()));
      c->type = Type::i32;
    } else if (auto* get = segment->offset->dynCast<GlobalGet>()) {
      auto* g = module.getGlobal(get->name);
      if (g->imported() && g->base == TABLE_BASE) {
        ImportInfo info(module);
        auto* memoryBase32 = info.getImportedGlobal(g->module, TABLE_BASE32);
        if (!memoryBase32) {
          Builder builder(module);
          memoryBase32 = builder
                           .makeGlobal(TABLE_BASE32,
                                       Type::i32,
                                       builder.makeConst(int32_t(0)),
                                       Builder::Immutable)
                           .release();
          memoryBase32->module = g->module;
          memoryBase32->base = TABLE_BASE32;
          module.addGlobal(memoryBase32);
        }
        // Use this alternative import when initializing the segment.
        assert(memoryBase32);
        get->type = Type::i32;
        get->name = memoryBase32->name;
      }
    } else {
      WASM_UNREACHABLE("unexpected elem offset");
    }
  }

  void run(Module* module) override {
    super::run(module);
    // Don't modify the tables themselves until after the traversal since we
    // that would require tables to be the last thing that get visited, and
    // we don't want to depend on that specific ordering.
    for (auto& table : module->tables) {
      if (table->is64()) {
        table->indexType = Type::i32;
      }
    }
  }
};

Pass* createTable64LoweringPass() { return new Table64Lowering(); }

} // namespace wasm
