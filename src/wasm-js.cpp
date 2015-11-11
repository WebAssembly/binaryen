
//
// WebAssembly intepreter for asm2wasm output, in a js environment.
//
// Receives asm.js, generates a runnable module that executes the code in a WebAssembly
// interpreter. This is suitable as a polyfill for WebAssembly support in browsers.
//

#include <emscripten.h>

#include "asm2wasm.h"
#include "wasm-interpreter.h"

using namespace cashew;
using namespace wasm;

// global singletons
Asm2WasmBuilder* asm2wasm = nullptr;
ModuleInstance* instance = nullptr;
Module* module = nullptr;

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

#if WASM_JS_DEBUG
  std::cerr << "parsing...\n";
#endif
  cashew::Parser<Ref, DotZeroValueBuilder> builder;
  Ref asmjs = builder.parseToplevel(input);

  module = new Module();
  module->memory.initial = module->memory.max = 16*1024*1024; // TODO: receive this from emscripten

#if WASM_JS_DEBUG
  std::cerr << "wasming...\n";
#endif
  asm2wasm = new Asm2WasmBuilder(*module);
  asm2wasm->processAsm(asmjs);

#if WASM_JS_DEBUG
  std::cerr << "optimizing...\n";
#endif
  asm2wasm->optimize();

#if WASM_JS_DEBUG
  std::cerr << *module << '\n';
#endif

#if WASM_JS_DEBUG
  std::cerr << "generating exports...\n";
#endif
  EM_ASM({
    Module['asmExports'] = {};
  });
  for (auto& pair : module->exportsMap) {
    auto& curr = pair.second;
    EM_ASM_({
      var name = Pointer_stringify($0);
      Module['asmExports'][name] = function() {
        Module['tempArguments'] = Array.prototype.slice.call(arguments);
        return Module['_call_from_js']($0);
      };
    }, curr->name.str);
  }

#if WASM_JS_DEBUG
  std::cerr << "creating instance...\n";
#endif

  struct JSExternalInterface : ModuleInstance::ExternalInterface {
    Literal callImport(Import *import, ModuleInstance::LiteralList& arguments) override {
#ifdef WASM_JS_DEBUG
      std::cout << "calling import " << import->name.str << '\n';
#endif
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
      double ret = EM_ASM_DOUBLE({
        var mod = Pointer_stringify($0);
        var base = Pointer_stringify($1);
        var tempArguments = Module['tempArguments'];
        Module['tempArguments'] = null;
        var lookup = Module['lookupImport'](mod, base);
        return lookup.apply(null, tempArguments);
      }, import->module.str, import->base.str);
#ifdef WASM_JS_DEBUG
      std::cout << "calling import returning " << ret << '\n';
#endif
      switch (import->type.result) {
        case none: return Literal(0);
        case i32: return Literal((int32_t)ret);
        case f32: return Literal((float)ret);
        case f64: return Literal((double)ret);
        default: abort();
      }
    }

    Literal load(Load* load, size_t addr) override {
      assert(load->align == load->bytes);
      if (!isWasmTypeFloat(load->type)) {
        if (load->bytes == 1) {
          if (load->signed_) {
            return Literal(EM_ASM_INT({ return Module['info'].parent['HEAP8'][$0] }, addr));
          } else {
            return Literal(EM_ASM_INT({ return Module['info'].parent['HEAPU8'][$0] }, addr));
          }
        } else if (load->bytes == 2) {
          if (load->signed_) {
            return Literal(EM_ASM_INT({ return Module['info'].parent['HEAP16'][$0 >> 1] }, addr));
          } else {
            return Literal(EM_ASM_INT({ return Module['info'].parent['HEAPU16'][$0 >> 1] }, addr));
          }
        } else if (load->bytes == 4) {
          if (load->signed_) {
            return Literal(EM_ASM_INT({ return Module['info'].parent['HEAP32'][$0 >> 2] }, addr));
          } else {
            return Literal(EM_ASM_INT({ return Module['info'].parent['HEAPU32'][$0 >> 2] }, addr));
          }
        }
        abort();
      } else {
        if (load->bytes == 4) {
          return Literal(EM_ASM_DOUBLE({ return Module['info'].parent['HEAPF32'][$0 >> 2] }, addr)); // XXX expands into double
        } else if (load->bytes == 8) {
          return Literal(EM_ASM_DOUBLE({ return Module['info'].parent['HEAPF64'][$0 >> 3] }, addr));
        }
        abort();
      }
    }

    void store(Store* store, size_t addr, Literal value) override {
      assert(store->align == store->bytes);
      if (!isWasmTypeFloat(store->type)) {
        if (store->bytes == 1) {
          EM_ASM_INT({ Module['info'].parent['HEAP8'][$0] = $1 }, addr, value.geti32());
        } else if (store->bytes == 2) {
          EM_ASM_INT({ Module['info'].parent['HEAP16'][$0 >> 1] = $1 }, addr, value.geti32());
        } else if (store->bytes == 4) {
          EM_ASM_INT({ Module['info'].parent['HEAP32'][$0 >> 2] = $1 }, addr, value.geti32());
        } else {
          abort();
        }
      } else {
        if (store->bytes == 4) {
          EM_ASM_DOUBLE({ Module['info'].parent['HEAPF32'][$0 >> 2] = $1 }, addr, value.getf64());
        } else if (store->bytes == 8) {
          EM_ASM_DOUBLE({ Module['info'].parent['HEAPF64'][$0 >> 3] = $1 }, addr, value.getf64());
        } else {
          abort();
        }
      }
    }

    void growMemory(size_t oldSize, size_t newSize) override {
      abort();
    }

    void trap() override {
      EM_ASM({
        abort("wasm trap!");
      });
    }
  };

  instance = new ModuleInstance(*module, new JSExternalInterface());
}

// Ready the provided imported globals, copying them to their mapped locations.
extern "C" void EMSCRIPTEN_KEEPALIVE load_mapped_globals() {
  for (auto& pair : asm2wasm->mappedGlobals) {
    auto name = pair.first;
    auto& global = pair.second;
    if (!global.import) continue; // non-imports are initialized to zero in the typed array anyhow, so nothing to do here
    double value = EM_ASM_DOUBLE({ return Module['lookupImport'](Pointer_stringify($0), Pointer_stringify($1)) }, global.module.str, global.base.str);
    unsigned address = global.address;
    switch (global.type) {
      case i32: EM_ASM_({ Module['info'].parent['HEAP32'][$0 >> 2] = $1 }, address, value); break;
      case f32: EM_ASM_({ Module['info'].parent['HEAPF32'][$0 >> 2] = $1 }, address, value); break;
      case f64: EM_ASM_({ Module['info'].parent['HEAPF64'][$0 >> 3] = $1 }, address, value); break;
      default: abort();
    }
  }
}

// Does a call from js into an export of the module.
extern "C" double EMSCRIPTEN_KEEPALIVE call_from_js(const char *target) {
#ifdef WASM_JS_DEBUG
  std::cout << "call_from_js " << target << '\n';
#endif
  IString exportName(target);
  IString functionName = instance->wasm.exportsMap[exportName]->value;
  Function *function = instance->wasm.functionsMap[functionName];
  assert(function);
  size_t seen = EM_ASM_INT_V({ return Module['tempArguments'].length });
  size_t actual = function->params.size();
  ModuleInstance::LiteralList arguments;
  for (size_t i = 0; i < actual; i++) {
    WasmType type = function->params[i].type;
    // add the parameter, with a zero value if JS did not provide it.
    if (type == i32) {
      arguments.push_back(Literal(i < seen ? EM_ASM_INT({ return Module['tempArguments'][$0] }, i) : (int32_t)0));
    } else if (type == f32) {
      arguments.push_back(Literal(i < seen ? (float)EM_ASM_DOUBLE({ return Module['tempArguments'][$0] }, i) : (float)0.0));
    } else if (type == f64) {
      arguments.push_back(Literal(i < seen ? EM_ASM_DOUBLE({ return Module['tempArguments'][$0] }, i) : (double)0.0));
    } else {
      abort();
    }
  }
  Literal ret = instance->callExport(exportName, arguments);
#ifdef WASM_JS_DEBUG
  std::cout << "call_from_js returning " << ret << '\n';
#endif
  if (ret.type == none) return 0;
  if (ret.type == i32) return ret.i32;
  if (ret.type == f32) return ret.f32;
  if (ret.type == f64) return ret.f64;
  abort();
}

