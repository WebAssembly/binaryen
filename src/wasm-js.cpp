
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
    }

    Literal store(Store* store, Literal ptr, Literal value) override {
    }
  };

  return new ModuleInstance(*wasm, new JSExternalInterface());
}

