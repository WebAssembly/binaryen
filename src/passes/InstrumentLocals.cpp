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

#include "asm_v_wasm.h"
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
Name get_anyref("get_anyref");
Name get_exnref("get_exnref");

Name set_i32("set_i32");
Name set_i64("set_i64");
Name set_f32("set_f32");
Name set_f64("set_f64");
Name set_anyref("set_anyref");
Name set_exnref("set_exnref");

struct InstrumentLocals : public WalkerPass<PostWalker<InstrumentLocals>> {
  void visitLocalGet(LocalGet* curr) {
    Builder builder(*getModule());
    Name import;
    switch (curr->type) {
      case i32:
        import = get_i32;
        break;
      case i64:
        return; // TODO
      case f32:
        import = get_f32;
        break;
      case f64:
        import = get_f64;
        break;
      case v128:
        assert(false && "v128 not implemented yet");
      case anyref:
        import = get_anyref;
        break;
      case exnref:
        import = get_exnref;
        break;
      case none:
      case unreachable:
        WASM_UNREACHABLE("unexpected type");
    }
    replaceCurrent(
      builder.makeCall(import,
                       {builder.makeConst(Literal(int32_t(id++))),
                        builder.makeConst(Literal(int32_t(curr->index))),
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
    switch (curr->value->type) {
      case i32:
        import = set_i32;
        break;
      case i64:
        return; // TODO
      case f32:
        import = set_f32;
        break;
      case f64:
        import = set_f64;
        break;
      case v128:
        assert(false && "v128 not implemented yet");
      case anyref:
        import = set_anyref;
        break;
      case exnref:
        import = set_exnref;
        break;
      case unreachable:
        return; // nothing to do here
      case none:
        WASM_UNREACHABLE("unexpected type");
    }
    curr->value =
      builder.makeCall(import,
                       {builder.makeConst(Literal(int32_t(id++))),
                        builder.makeConst(Literal(int32_t(curr->index))),
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
      addImport(
        curr, get_anyref, {Type::i32, Type::i32, Type::anyref}, Type::anyref);
      addImport(
        curr, set_anyref, {Type::i32, Type::i32, Type::anyref}, Type::anyref);
    }
    if (curr->features.hasExceptionHandling()) {
      addImport(
        curr, get_exnref, {Type::i32, Type::i32, Type::exnref}, Type::exnref);
      addImport(
        curr, set_exnref, {Type::i32, Type::i32, Type::exnref}, Type::exnref);
    }
  }

private:
  Index id = 0;

  void addImport(Module* wasm, Name name, Type params, Type results) {
    auto import = new Function;
    import->name = name;
    import->module = ENV;
    import->base = name;
    import->sig = Signature(params, results);
    wasm->addFunction(import);
  }
};

Pass* createInstrumentLocalsPass() { return new InstrumentLocals(); }

} // namespace wasm
