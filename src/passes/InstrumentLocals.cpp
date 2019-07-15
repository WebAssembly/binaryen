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
#include "ir/function-type-utils.h"
#include "shared-constants.h"
#include <pass.h>
#include <wasm-builder.h>
#include <wasm.h>

namespace wasm {

Name get_i32("get_i32");
Name get_i64("get_i64");
Name get_f32("get_f32");
Name get_f64("get_f64");

Name set_i32("set_i32");
Name set_i64("set_i64");
Name set_f32("set_f32");
Name set_f64("set_f64");

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
      case exnref:
        assert(false && "not implemented yet");
      case none:
        WASM_UNREACHABLE();
      case unreachable:
        WASM_UNREACHABLE();
    }
    replaceCurrent(
      builder.makeCall(import,
                       {builder.makeConst(Literal(int32_t(id++))),
                        builder.makeConst(Literal(int32_t(curr->index))),
                        curr},
                       curr->type));
  }

  void visitLocalSet(LocalSet* curr) {
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
      case exnref:
        assert(false && "exnref not implemented yet");
      case unreachable:
        return; // nothing to do here
      case none:
        WASM_UNREACHABLE();
    }
    curr->value =
      builder.makeCall(import,
                       {builder.makeConst(Literal(int32_t(id++))),
                        builder.makeConst(Literal(int32_t(curr->index))),
                        curr->value},
                       curr->value->type);
  }

  void visitModule(Module* curr) {
    addImport(curr, get_i32, "iiii");
    addImport(curr, get_i64, "jiij");
    addImport(curr, get_f32, "fiif");
    addImport(curr, get_f64, "diid");
    addImport(curr, set_i32, "iiii");
    addImport(curr, set_i64, "jiij");
    addImport(curr, set_f32, "fiif");
    addImport(curr, set_f64, "diid");
  }

private:
  Index id = 0;

  void addImport(Module* wasm, Name name, std::string sig) {
    auto import = new Function;
    import->name = name;
    import->module = ENV;
    import->base = name;
    auto* functionType = ensureFunctionType(sig, wasm);
    import->type = functionType->name;
    FunctionTypeUtils::fillFunction(import, functionType);
    wasm->addFunction(import);
  }
};

Pass* createInstrumentLocalsPass() { return new InstrumentLocals(); }

} // namespace wasm
