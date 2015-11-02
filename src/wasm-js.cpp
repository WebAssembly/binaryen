
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

ModuleInstance* instance = nullptr;

// receives asm.js code, parses into wasm and returns an instance handle.
// this creates a module, an external interface, a builder, and a module instance,
// all of which are then the responsibility of the caller to free.
// note: this modifies the input.
extern "C" void EMSCRIPTEN_KEEPALIVE load_asm(char *input) {
  assert(instance == nullptr); // singleton

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

  int debug = 0;

  if (debug) std::cerr << "parsing...\n";
  cashew::Parser<Ref, DotZeroValueBuilder> builder;
  Ref asmjs = builder.parseToplevel(input);

  Module* wasm = new Module();

  if (debug) std::cerr << "wasming...\n";
  Asm2WasmBuilder* asm2wasm = new Asm2WasmBuilder(*wasm);
  asm2wasm->processAsm(asmjs);

  if (debug) std::cerr << "optimizing...\n";
  asm2wasm->optimize();

  //std::cerr << *wasm << '\n';

  if (debug) std::cerr << "generating exports...\n";
  EM_ASM({
    Module['asmExports'] = {};
  });
  for (auto& curr : wasm->exports) {
    EM_ASM_({
      var name = Pointer_stringify($0);
      Module['asmExports'][name] = function() {
        Module['tempArguments'] = Array.prototype.slice.call(arguments);
        return Module['_call_from_js']($0);
      };
    }, curr.name.str);
  }

  if (debug) std::cerr << "creating instance...\n";

  struct JSExternalInterface : ModuleInstance::ExternalInterface {
    Literal callImport(Import *import, ModuleInstance::LiteralList& arguments) override {
      EM_ASM({
        Module['tempArguments'] = [];
      });
      for (auto& argument : arguments) {
        if (argument.type == i32) {
          EM_ASM_({ Module['tempArguments'].push($0) }, argument.geti32());
        } else if (argument.type == f64) {
          EM_ASM_({ Module['tempArguments'].push($0) }, argument.getf64());
        } else {
          abort();
        }
      }
      return Literal(EM_ASM_DOUBLE({
        var mod = Pointer_stringify($0);
        var base = Pointer_stringify($1);
        var tempArguments = Module['tempArguments'];
        Module['tempArguments'] = null;
        var lookup = Module['info'];
        if (mod.indexOf('.') < 0) {
          lookup = (lookup || {})[mod];
        } else {
          var parts = mod.split('.');
          lookup = (lookup || {})[parts[0]];
          lookup = (lookup || {})[parts[1]];
        }
        lookup = (lookup || {})[base];
        if (!lookup) {
          abort('bad CallImport to (' + mod + ').' + base);
        }
        return lookup.apply(null, tempArguments);
      }, import->module.str, import->base.str));
    }

    Literal load(Load* load, Literal ptr) override {
      size_t addr = ptr.geti32();
      assert(load->align == load->bytes);
      if (!load->float_) {
        if (load->bytes == 1) {
          if (load->signed_) {
            return Literal(EM_ASM_INT({ return Module['info'].parent['HEAP8'][$0] }, addr));
          } else {
            return Literal(EM_ASM_INT({ return Module['info'].parent['HEAPU8'][$0] }, addr));
          }
        } else if (load->bytes == 2) {
          if (load->signed_) {
            return Literal(EM_ASM_INT({ return Module['info'].parent['HEAP16'][$0] }, addr));
          } else {
            return Literal(EM_ASM_INT({ return Module['info'].parent['HEAPU16'][$0] }, addr));
          }
        } else if (load->bytes == 4) {
          if (load->signed_) {
            return Literal(EM_ASM_INT({ return Module['info'].parent['HEAP32'][$0] }, addr));
          } else {
            return Literal(EM_ASM_INT({ return Module['info'].parent['HEAPU32'][$0] }, addr));
          }
        }
        abort();
      } else {
        if (load->bytes == 4) {
          return Literal(EM_ASM_DOUBLE({ return Module['info'].parent['HEAPF32'][$0] }, addr));
        } else if (load->bytes == 8) {
          return Literal(EM_ASM_DOUBLE({ return Module['info'].parent['HEAPF64'][$0] }, addr));
        }
        abort();
      }
    }

    void store(Store* store, Literal ptr, Literal value) override {
      size_t addr = ptr.geti32();
      assert(store->align == store->bytes);
      if (!store->float_) {
        if (store->bytes == 1) {
          EM_ASM_INT({ Module['info'].parent['HEAP8'][$0] = $1 }, addr, value.geti32());
        } else if (store->bytes == 2) {
          EM_ASM_INT({ Module['info'].parent['HEAP16'][$0] = $1 }, addr, value.geti32());
        } else if (store->bytes == 4) {
          EM_ASM_INT({ Module['info'].parent['HEAP32'][$0] = $1 }, addr, value.geti32());
        } else {
          abort();
        }
      } else {
        if (store->bytes == 4) {
          EM_ASM_DOUBLE({ Module['info'].parent['HEAPF32'][$0] = $1 }, addr, value.getf64());
        } else if (store->bytes == 8) {
          EM_ASM_DOUBLE({ Module['info'].parent['HEAPF64'][$0] = $1 }, addr, value.getf64());
        } else {
          abort();
        }
      }
    }
  };

  instance = new ModuleInstance(*wasm, new JSExternalInterface());
}

// Does a call from js into an export of the module.
extern "C" double EMSCRIPTEN_KEEPALIVE call_from_js(const char *target) {
  IString name(target);
  assert(instance->functions.find(name) != instance->functions.end());
  Function *function = instance->functions[name];
  size_t seen = EM_ASM_INT_V({ return Module['tempArguments'].length });
  size_t actual = function->params.size();
  ModuleInstance::LiteralList arguments;
  for (size_t i = 0; i < actual; i++) {
    WasmType type = function->params[i].type;
    // add the parameter, with a zero value if JS did not provide it.
    if (type == i32) {
      arguments.push_back(Literal(i < seen ? EM_ASM_INT({ return Module['tempArguments'][$0] }, i) : (int32_t)0));
    } else if (type == f64) {
      arguments.push_back(Literal(i < seen ? EM_ASM_DOUBLE({ return Module['tempArguments'][$0] }, i) : (double)0.0));
    } else {
      abort();
    }
  }

  Literal ret = instance->callFunction(name, arguments);
  if (ret.type == i32) return ret.i32;
  if (ret.type == f64) return ret.f64;
  abort();
}

