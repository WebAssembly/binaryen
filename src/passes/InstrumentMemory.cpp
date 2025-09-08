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

//
// Instruments the build with code to intercept all memory reads and writes.
// This can be useful in building tools that analyze memory access behaviour.
//
//  Before:
//   (i32.load8_s align=1 offset=2 (i32.const 3))
//
//  After:
//   (call $load_val_i32
//    (i32.const n) // ID
//    (i32.load8_s align=1 offset=2
//     (call $load_ptr
//      (i32.const n) // ID
//      (i32.const 1) // bytes
//      (i32.const 2) // offset
//      (i32.const 3) // address
//     )
//    )
//   )
// Stores: store(id, bytes, offset, address) => address
//
//  Before:
//   (i32.store8 align=1 offset=2 (i32.const 3) (i32.const 4))
//
//  After:
//   (i32.store16 align=1 offset=2
//    (call $store_ptr
//     (i32.const n) // ID
//     (i32.const 1) // bytes
//     (i32.const 2) // offset
//     (i32.const 3) // address
//    )
//    (call $store_val_i32
//     (i32.const n) // ID
//     (i32.const 4)
//    )
//   )
//
// GC struct and array operations are similarly instrumented, but without their
// pointers (which are references), and we only log MVP wasm types (i.e., not
// references).
//

#include "asmjs/shared-constants.h"
#include "shared-constants.h"
#include "support/string.h"
#include <pass.h>
#include <wasm-builder.h>
#include <wasm.h>

namespace wasm {

static Name load_ptr("load_ptr");
static Name load_val_i32("load_val_i32");
static Name load_val_i64("load_val_i64");
static Name load_val_f32("load_val_f32");
static Name load_val_f64("load_val_f64");
static Name store_ptr("store_ptr");
static Name store_val_i32("store_val_i32");
static Name store_val_i64("store_val_i64");
static Name store_val_f32("store_val_f32");
static Name store_val_f64("store_val_f64");
static Name struct_get_val_i32("struct_get_val_i32");
static Name struct_get_val_i64("struct_get_val_i64");
static Name struct_get_val_f32("struct_get_val_f32");
static Name struct_get_val_f64("struct_get_val_f64");
static Name struct_set_val_i32("struct_set_val_i32");
static Name struct_set_val_i64("struct_set_val_i64");
static Name struct_set_val_f32("struct_set_val_f32");
static Name struct_set_val_f64("struct_set_val_f64");
static Name array_get_val_i32("array_get_val_i32");
static Name array_get_val_i64("array_get_val_i64");
static Name array_get_val_f32("array_get_val_f32");
static Name array_get_val_f64("array_get_val_f64");
static Name array_set_val_i32("array_set_val_i32");
static Name array_set_val_i64("array_set_val_i64");
static Name array_set_val_f32("array_set_val_f32");
static Name array_set_val_f64("array_set_val_f64");
static Name array_get_index("array_get_index");
static Name array_set_index("array_set_index");
static Name memory_grow_pre("memory_grow_pre");
static Name memory_grow_post("memory_grow_post");

// TODO: Add support for atomicRMW/cmpxchg

using InstructionFilter = std::optional<std::unordered_set<std::string>>;

#define CHECK_EXPRESSION(expr)                                                 \
  do {                                                                         \
    if (filter && !filter->count(expr)) {                                      \
      return;                                                                  \
    }                                                                          \
  } while (false)

struct AddInstrumentation : public WalkerPass<PostWalker<AddInstrumentation>> {
  explicit AddInstrumentation(InstructionFilter filter)
    : filter(std::move(filter)) {}
  void visitLoad(Load* curr) {
    CHECK_EXPRESSION("load");

    id++;
    Builder builder(*getModule());
    auto mem = getModule()->getMemory(curr->memory);
    auto addressType = mem->addressType;
    auto offset = builder.makeConstPtr(curr->offset.addr, addressType);
    curr->ptr = builder.makeCall(load_ptr,
                                 {builder.makeConst(int32_t(id)),
                                  builder.makeConst(int32_t(curr->bytes)),
                                  offset,
                                  curr->ptr},
                                 addressType);
    Name target;
    switch (curr->type.getBasic()) {
      case Type::i32:
        target = load_val_i32;
        break;
      case Type::i64:
        target = load_val_i64;
        break;
      case Type::f32:
        target = load_val_f32;
        break;
      case Type::f64:
        target = load_val_f64;
        break;
      default:
        return; // TODO: other types, unreachable, etc.
    }
    replaceCurrent(builder.makeCall(
      target, {builder.makeConst(int32_t(id)), curr}, curr->type));
  }

  void visitStore(Store* curr) {
    CHECK_EXPRESSION("store");

    id++;
    Builder builder(*getModule());
    auto mem = getModule()->getMemory(curr->memory);
    auto addressType = mem->addressType;
    auto offset = builder.makeConstPtr(curr->offset.addr, addressType);
    curr->ptr = builder.makeCall(store_ptr,
                                 {builder.makeConst(int32_t(id)),
                                  builder.makeConst(int32_t(curr->bytes)),
                                  offset,
                                  curr->ptr},
                                 addressType);
    Name target;
    switch (curr->value->type.getBasic()) {
      case Type::i32:
        target = store_val_i32;
        break;
      case Type::i64:
        target = store_val_i64;
        break;
      case Type::f32:
        target = store_val_f32;
        break;
      case Type::f64:
        target = store_val_f64;
        break;
      default:
        return; // TODO: other types, unreachable, etc.
    }
    curr->value = builder.makeCall(
      target, {builder.makeConst(int32_t(id)), curr->value}, curr->value->type);
  }

  void visitStructGet(StructGet* curr) {
    CHECK_EXPRESSION("struct.get");

    Builder builder(*getModule());
    Name target;
    if (curr->type == Type::i32) {
      target = struct_get_val_i32;
    } else if (curr->type == Type::i64) {
      target = struct_get_val_i64;
    } else if (curr->type == Type::f32) {
      target = struct_get_val_f32;
    } else if (curr->type == Type::f64) {
      target = struct_get_val_f64;
    } else {
      return; // TODO: other types, unreachable, etc.
    }
    replaceCurrent(builder.makeCall(
      target, {builder.makeConst(int32_t(id++)), curr}, curr->type));
  }

  void visitStructSet(StructSet* curr) {
    CHECK_EXPRESSION("struct.set");

    Builder builder(*getModule());
    Name target;
    if (curr->value->type == Type::i32) {
      target = struct_set_val_i32;
    } else if (curr->value->type == Type::i64) {
      target = struct_set_val_i64;
    } else if (curr->value->type == Type::f32) {
      target = struct_set_val_f32;
    } else if (curr->value->type == Type::f64) {
      target = struct_set_val_f64;
    } else {
      return; // TODO: other types, unreachable, etc.
    }
    curr->value =
      builder.makeCall(target,
                       {builder.makeConst(int32_t(id++)), curr->value},
                       curr->value->type);
  }

  void visitArrayGet(ArrayGet* curr) {
    CHECK_EXPRESSION("array.get");

    Builder builder(*getModule());
    curr->index =
      builder.makeCall(array_get_index,
                       {builder.makeConst(int32_t(id++)), curr->index},
                       Type::i32);
    Name target;
    if (curr->type == Type::i32) {
      target = array_get_val_i32;
    } else if (curr->type == Type::i64) {
      target = array_get_val_i64;
    } else if (curr->type == Type::f32) {
      target = array_get_val_f32;
    } else if (curr->type == Type::f64) {
      target = array_get_val_f64;
    } else {
      return; // TODO: other types, unreachable, etc.
    }
    replaceCurrent(builder.makeCall(
      target, {builder.makeConst(int32_t(id++)), curr}, curr->type));
  }

  void visitArraySet(ArraySet* curr) {
    CHECK_EXPRESSION("array.set");

    Builder builder(*getModule());
    curr->index =
      builder.makeCall(array_set_index,
                       {builder.makeConst(int32_t(id++)), curr->index},
                       Type::i32);
    Name target;
    if (curr->value->type == Type::i32) {
      target = array_set_val_i32;
    } else if (curr->value->type == Type::i64) {
      target = array_set_val_i64;
    } else if (curr->value->type == Type::f32) {
      target = array_set_val_f32;
    } else if (curr->value->type == Type::f64) {
      target = array_set_val_f64;
    } else {
      return; // TODO: other types, unreachable, etc.
    }
    curr->value =
      builder.makeCall(target,
                       {builder.makeConst(int32_t(id++)), curr->value},
                       curr->value->type);
  }

  void visitMemoryGrow(MemoryGrow* curr) {
    CHECK_EXPRESSION("memory.grow");

    id++;
    Builder builder(*getModule());
    auto addressType = getModule()->getMemory(curr->memory)->addressType;
    curr->delta =
      builder.makeCall(memory_grow_pre,
                       {builder.makeConst(int32_t(id)), curr->delta},
                       addressType);
    replaceCurrent(builder.makeCall(
      memory_grow_post, {builder.makeConst(int32_t(id)), curr}, addressType));
  }

  void visitModule(Module* curr) {
    auto addressType =
      curr->memories.empty() ? Type::i32 : curr->memories[0]->addressType;

    // Grow.
    addImport(curr, memory_grow_pre, {Type::i32, addressType}, addressType);
    addImport(curr, memory_grow_post, {Type::i32, addressType}, addressType);

    // Load.
    addImport(curr,
              load_ptr,
              {Type::i32, Type::i32, addressType, addressType},
              addressType);
    addImport(curr, load_val_i32, {Type::i32, Type::i32}, Type::i32);
    addImport(curr, load_val_i64, {Type::i32, Type::i64}, Type::i64);
    addImport(curr, load_val_f32, {Type::i32, Type::f32}, Type::f32);
    addImport(curr, load_val_f64, {Type::i32, Type::f64}, Type::f64);

    // Store.
    addImport(curr,
              store_ptr,
              {Type::i32, Type::i32, addressType, addressType},
              addressType);
    addImport(curr, store_val_i32, {Type::i32, Type::i32}, Type::i32);
    addImport(curr, store_val_i64, {Type::i32, Type::i64}, Type::i64);
    addImport(curr, store_val_f32, {Type::i32, Type::f32}, Type::f32);
    addImport(curr, store_val_f64, {Type::i32, Type::f64}, Type::f64);

    if (curr->features.hasGC()) {
      // Struct get/set.
      addImport(curr, struct_get_val_i32, {Type::i32, Type::i32}, Type::i32);
      addImport(curr, struct_get_val_i64, {Type::i32, Type::i64}, Type::i64);
      addImport(curr, struct_get_val_f32, {Type::i32, Type::f32}, Type::f32);
      addImport(curr, struct_get_val_f64, {Type::i32, Type::f64}, Type::f64);
      addImport(curr, struct_set_val_i32, {Type::i32, Type::i32}, Type::i32);
      addImport(curr, struct_set_val_i64, {Type::i32, Type::i64}, Type::i64);
      addImport(curr, struct_set_val_f32, {Type::i32, Type::f32}, Type::f32);
      addImport(curr, struct_set_val_f64, {Type::i32, Type::f64}, Type::f64);

      // Array get/set.
      addImport(curr, array_get_val_i32, {Type::i32, Type::i32}, Type::i32);
      addImport(curr, array_get_val_i64, {Type::i32, Type::i64}, Type::i64);
      addImport(curr, array_get_val_f32, {Type::i32, Type::f32}, Type::f32);
      addImport(curr, array_get_val_f64, {Type::i32, Type::f64}, Type::f64);
      addImport(curr, array_set_val_i32, {Type::i32, Type::i32}, Type::i32);
      addImport(curr, array_set_val_i64, {Type::i32, Type::i64}, Type::i64);
      addImport(curr, array_set_val_f32, {Type::i32, Type::f32}, Type::f32);
      addImport(curr, array_set_val_f64, {Type::i32, Type::f64}, Type::f64);
      addImport(curr, array_get_index, {Type::i32, Type::i32}, Type::i32);
      addImport(curr, array_set_index, {Type::i32, Type::i32}, Type::i32);
    }
  }

private:
  Index id = 0;
  InstructionFilter filter;

  void addImport(Module* curr, Name name, Type params, Type results) {
    auto import = Builder::makeFunction(name, Signature(params, results), {});
    import->module = ENV;
    import->base = name;
    curr->addFunction(std::move(import));
  }
};

struct InstrumentMemory : Pass {
  // Adds calls to new imports.
  bool addsEffects() override { return true; }

  void run(Module* module) override {
    auto arg = getArgumentOrDefault("instrument-memory", "");
    InstructionFilter instructions;
    if (arg.size() > 0) {
      String::Split s(arg, ",");
      instructions = std::unordered_set<std::string>{s.begin(), s.end()};
    }
    AddInstrumentation(std::move(instructions)).run(getPassRunner(), module);
  }
};

Pass* createInstrumentMemoryPass() { return new InstrumentMemory(); }

} // namespace wasm
