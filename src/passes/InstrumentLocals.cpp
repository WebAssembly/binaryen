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
// Instruments the build with code to intercept all local reads and writes.
//
// gets:
//
//  Before:
//   (local.get $x)
//
//  After:
//    (call $get_TYPE
//     (i32.const n) // call id
//     (i32.const n) // local id
//     (local.get $x)
//    )
//
// sets:
//
//  Before:
//   (local.set $x (i32.const 1))
//
//  After:
//   (local.set $x
//    (call $set_TYPE
//     (i32.const n) // call id
//     (i32.const n) // local id
//     (i32.const 1) // value
//    )
//   )

#include "asmjs/shared-constants.h"
#include "shared-constants.h"
#include <pass.h>
#include <wasm-builder.h>
#include <wasm.h>

namespace wasm {

Name get_i32("get_i32");
Name get_i64("get_i64");
Name get_f32("get_f32");
Name get_f64("get_f64");
Name get_v128("get_v128");
Name get_funcref("get_funcref");
Name get_externref("get_externref");
Name get_anyref("get_anyref");
Name get_eqref("get_eqref");
Name get_i31ref("get_i31ref");
Name get_dataref("get_dataref");

Name set_i32("set_i32");
Name set_i64("set_i64");
Name set_f32("set_f32");
Name set_f64("set_f64");
Name set_v128("set_v128");
Name set_funcref("set_funcref");
Name set_externref("set_externref");
Name set_anyref("set_anyref");
Name set_eqref("set_eqref");
Name set_i31ref("set_i31ref");
Name set_dataref("set_dataref");

struct InstrumentLocals : public WalkerPass<PostWalker<InstrumentLocals>> {
  void visitLocalGet(LocalGet* curr) {
    Builder builder(*getModule());
    Name import;
    TODO_SINGLE_COMPOUND(curr->type);
    switch (curr->type.getBasic()) {
      case Type::i32:
        import = get_i32;
        break;
      case Type::i64:
        return; // TODO
      case Type::f32:
        import = get_f32;
        break;
      case Type::f64:
        import = get_f64;
        break;
      case Type::v128:
        import = get_v128;
        break;
      case Type::funcref:
        import = get_funcref;
        break;
      case Type::externref:
        import = get_externref;
        break;
      case Type::anyref:
        import = get_anyref;
        break;
      case Type::eqref:
        import = get_eqref;
        break;
      case Type::i31ref:
        import = get_i31ref;
        break;
      case Type::dataref:
        import = get_dataref;
        break;
      case Type::none:
      case Type::unreachable:
        WASM_UNREACHABLE("unexpected type");
    }
    replaceCurrent(builder.makeCall(import,
                                    {builder.makeConst(int32_t(id++)),
                                     builder.makeConst(int32_t(curr->index)),
                                     curr},
                                    curr->type));
  }

  void visitLocalSet(LocalSet* curr) {
    // We don't instrument pop instructions. They are automatically deleted when
    // writing binary and generated when reading binary, so they don't work with
    // local set/get instrumentation.
    if (curr->value->is<Pop>()) {
      return;
    }

    Builder builder(*getModule());
    Name import;
    auto type = curr->value->type;
    if (type.isFunction() && type != Type::funcref) {
      // FIXME: support typed function references
      return;
    }
    TODO_SINGLE_COMPOUND(curr->value->type);
    switch (type.getBasic()) {
      case Type::i32:
        import = set_i32;
        break;
      case Type::i64:
        return; // TODO
      case Type::f32:
        import = set_f32;
        break;
      case Type::f64:
        import = set_f64;
        break;
      case Type::v128:
        import = set_v128;
        break;
      case Type::funcref:
        import = set_funcref;
        break;
      case Type::externref:
        import = set_externref;
        break;
      case Type::anyref:
        import = set_anyref;
        break;
      case Type::eqref:
        import = set_eqref;
        break;
      case Type::i31ref:
        import = set_i31ref;
        break;
      case Type::dataref:
        import = set_dataref;
        break;
      case Type::unreachable:
        return; // nothing to do here
      default:
        WASM_UNREACHABLE("unexpected type");
    }
    curr->value = builder.makeCall(import,
                                   {builder.makeConst(int32_t(id++)),
                                    builder.makeConst(int32_t(curr->index)),
                                    curr->value},
                                   curr->value->type);
  }

  void visitModule(Module* curr) {
    addImport(curr, get_i32, {Type::i32, Type::i32, Type::i32}, Type::i32);
    addImport(curr, get_i64, {Type::i32, Type::i32, Type::i64}, Type::i64);
    addImport(curr, get_f32, {Type::i32, Type::i32, Type::f32}, Type::f32);
    addImport(curr, get_f64, {Type::i32, Type::i32, Type::f64}, Type::f64);
    addImport(curr, set_i32, {Type::i32, Type::i32, Type::i32}, Type::i32);
    addImport(curr, set_i64, {Type::i32, Type::i32, Type::i64}, Type::i64);
    addImport(curr, set_f32, {Type::i32, Type::i32, Type::f32}, Type::f32);
    addImport(curr, set_f64, {Type::i32, Type::i32, Type::f64}, Type::f64);

    if (curr->features.hasReferenceTypes()) {
      addImport(curr,
                get_funcref,
                {Type::i32, Type::i32, Type::funcref},
                Type::funcref);
      addImport(curr,
                set_funcref,
                {Type::i32, Type::i32, Type::funcref},
                Type::funcref);
      addImport(curr,
                get_externref,
                {Type::i32, Type::i32, Type::externref},
                Type::externref);
      addImport(curr,
                set_externref,
                {Type::i32, Type::i32, Type::externref},
                Type::externref);
      if (curr->features.hasGC()) {
        addImport(
          curr, get_anyref, {Type::i32, Type::i32, Type::anyref}, Type::anyref);
        addImport(
          curr, set_anyref, {Type::i32, Type::i32, Type::anyref}, Type::anyref);
        addImport(
          curr, get_eqref, {Type::i32, Type::i32, Type::eqref}, Type::eqref);
        addImport(
          curr, set_eqref, {Type::i32, Type::i32, Type::eqref}, Type::eqref);
        addImport(
          curr, get_i31ref, {Type::i32, Type::i32, Type::i31ref}, Type::i31ref);
        addImport(
          curr, set_i31ref, {Type::i32, Type::i32, Type::i31ref}, Type::i31ref);
        addImport(curr,
                  get_dataref,
                  {Type::i32, Type::i32, Type::dataref},
                  Type::dataref);
        addImport(curr,
                  set_dataref,
                  {Type::i32, Type::i32, Type::dataref},
                  Type::dataref);
      }
    }
    if (curr->features.hasSIMD()) {
      addImport(curr, get_v128, {Type::i32, Type::i32, Type::v128}, Type::v128);
      addImport(curr, set_v128, {Type::i32, Type::i32, Type::v128}, Type::v128);
    }
  }

private:
  Index id = 0;

  void addImport(Module* wasm, Name name, Type params, Type results) {
    auto import = Builder::makeFunction(name, Signature(params, results), {});
    import->module = ENV;
    import->base = name;
    wasm->addFunction(std::move(import));
  }
};

Pass* createInstrumentLocalsPass() { return new InstrumentLocals(); }

} // namespace wasm
