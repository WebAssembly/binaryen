
//
// wasm intepreter for asm2wasm output, in a js environment. receives asm.js,
// generates a runnable module suitable as a polyfill.
//
// this polyfills an emscripten --separate-asm *.asm.js file, as a drop-in
// replacement. it writes the wasm module to Module.asm, and sets Module.buffer.
//

#include <emscripten.h>

#include "asm2wasm.h"
#include "wasm-interpreter.h"

using namespace cashew;
using namespace wasm;

// receives asm.js code, parses into wasm and returns an instance handle.
// this creates a module, an external interface, and a module instance,
// all of which are then the responsibility of the caller to free.
// note: this modifies the input.
extern "C" ModuleInstance* EMSCRIPTEN_KEEPALIVE load_asm(char *input) {
  // emcc --separate-asm modules look like
  //
  //    Module["asm"] = (function(global, env, buffer) {
  //      ..
  //    });
  //
  // we need to clean that up.
  size_t num = strlen(input);
  assert(*input == 'M');
  while (*input != 'f') {
    input++;
    num--;
  }
  char *end = input + num - 1;
  while (*end != '}') {
    *end = 0;
    end--;
  }

  if (debug) std::cerr << "parsing...\n";
  cashew::Parser<Ref, DotZeroValueBuilder> builder;
  Ref asmjs = builder.parseToplevel(input);

  Module* wasm = new Module();

  if (debug) std::cerr << "wasming...\n";
  Asm2WasmBuilder asm2wasm(*wasm);
  asm2wasm.processAsm(asmjs);

  if (debug) std::cerr << "optimizing...\n";
  asm2wasm.optimize();

  if (debug) std::cerr << "returning instance.\n";

  struct JSExternalInterface : ModuleInstance::ExternalInterface {
    Literal callImport(Import *import, ModuleInstance::LiteralList& arguments) override {
    }

    Literal load(Load* load, Literal ptr) override {
      size_t addr = ptr.geti32();
      assert(load->align == load->bytes);
      if (!load->float_) {
        if (load->bytes == 1) {
          if (load->signed_) {
            return Literal(EM_ASM_INT({ return Module['instance'].parent['HEAP8'][$0] }, addr));
          } else {
            return Literal(EM_ASM_INT({ return Module['instance'].parent['HEAPU8'][$0] }, addr));
          }
        } else if (load->bytes == 2) {
          if (load->signed_) {
            return Literal(EM_ASM_INT({ return Module['instance'].parent['HEAP16'][$0] }, addr));
          } else {
            return Literal(EM_ASM_INT({ return Module['instance'].parent['HEAPU16'][$0] }, addr));
          }
        } else if (load->bytes == 4) {
          if (load->signed_) {
            return Literal(EM_ASM_INT({ return Module['instance'].parent['HEAP32'][$0] }, addr));
          } else {
            return Literal(EM_ASM_INT({ return Module['instance'].parent['HEAPU32'][$0] }, addr));
          }
        }
        abort();
      } else {
        if (load->bytes == 4) {
          return Literal(EM_ASM_DOUBLE({ return Module['instance'].parent['HEAPF32'][$0] }, addr));
        } else if (load->bytes == 8) {
          return Literal(EM_ASM_DOUBLE({ return Module['instance'].parent['HEAPF64'][$0] }, addr));
        }
        abort();
      }
    }

    void store(Store* store, Literal ptr, Literal value) override {
      size_t addr = ptr.geti32();
      assert(store->align == store->bytes);
      if (!store->float_) {
        if (store->bytes == 1) {
          EM_ASM_INT({ Module['instance'].parent['HEAP8'][$0] = $1 }, addr, value.geti32());
        } else if (store->bytes == 2) {
          EM_ASM_INT({ Module['instance'].parent['HEAP16'][$0] = $1 }, addr, value.geti32());
        } else if (store->bytes == 4) {
          EM_ASM_INT({ Module['instance'].parent['HEAP32'][$0] = $1 }, addr, value.geti32());
        }
        abort();
      } else {
        if (store->bytes == 4) {
          EM_ASM_DOUBLE({ Module['instance'].parent['HEAPF32'][$0] = $1 }, addr, value.getf64());
        } else if (store->bytes == 8) {
          EM_ASM_DOUBLE({ Module['instance'].parent['HEAPF64'][$0] = $1 }, addr, value.getf64());
        }
        abort();
      }
    }
  };

  return new ModuleInstance(*wasm, new JSExternalInterface());
}

