/*
 * Copyright 2015 WebAssembly Community Group participants
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
// WebAssembly intepreter for asm2wasm output, in a js environment.
//
// Receives asm.js, generates a runnable module that executes the code in a WebAssembly
// interpreter. This is suitable as a polyfill for WebAssembly support in browsers.
//

#include <emscripten.h>

#include "asm2wasm.h"
#include "wasm-interpreter.h"
#include "wasm-s-parser.h"
#include "wasm-binary.h"
#include "wasm-printing.h"

using namespace cashew;
using namespace wasm;

namespace wasm {
int debug = 0;
}

// global singletons
Asm2WasmBuilder* asm2wasm = nullptr;
SExpressionParser* sExpressionParser = nullptr;
SExpressionWasmBuilder* sExpressionWasmBuilder = nullptr;
ModuleInstance* instance = nullptr;
Module* module = nullptr;
bool wasmJSDebug = false;

static void prepare2wasm() {
  assert(asm2wasm == nullptr && sExpressionParser == nullptr && sExpressionWasmBuilder == nullptr && instance == nullptr); // singletons
#if WASM_JS_DEBUG
  wasmJSDebug = 1;
#else
  wasmJSDebug = EM_ASM_INT_V({ return !!Module['outside']['WASM_JS_DEBUG'] }); // Set WASM_JS_DEBUG on the outside Module to get debugging
#endif
}

// receives asm.js code, parses into wasm.
// note: this modifies the input.
extern "C" void EMSCRIPTEN_KEEPALIVE load_asm2wasm(char *input) {
  prepare2wasm();

  Asm2WasmPreProcessor pre;
  input = pre.process(input);

  // proceed to parse and wasmify
  if (wasmJSDebug) std::cerr << "asm parsing...\n";

  cashew::Parser<Ref, DotZeroValueBuilder> builder;
  Ref asmjs = builder.parseToplevel(input);

  module = new Module();
  uint32_t providedMemory = EM_ASM_INT_V({
    return Module['providedTotalMemory']; // we receive the size of memory from emscripten
  });
  if (providedMemory & ~Memory::kPageMask) {
    std::cerr << "Error: provided memory is not a multiple of the 64k wasm page size\n";
    exit(EXIT_FAILURE);
  }
  module->memory.initial = Address(providedMemory / Memory::kPageSize);
  module->memory.max = pre.memoryGrowth ? Address(Memory::kMaxSize) : module->memory.initial;

  if (wasmJSDebug) std::cerr << "wasming...\n";
  asm2wasm = new Asm2WasmBuilder(*module, pre.memoryGrowth, debug, false /* TODO: support imprecise? */);
  asm2wasm->processAsm(asmjs);

  if (wasmJSDebug) std::cerr << "optimizing...\n";
  asm2wasm->optimize();

  if (wasmJSDebug) std::cerr << "mapping globals...\n";
  for (auto& pair : asm2wasm->mappedGlobals) {
    auto name = pair.first;
    auto& global = pair.second;
    if (!global.import) continue; // non-imports are initialized to zero in the typed array anyhow, so nothing to do here
    double value = EM_ASM_DOUBLE({ return Module['lookupImport'](Pointer_stringify($0), Pointer_stringify($1)) }, global.module.str, global.base.str);
    uint32_t address = global.address;
    switch (global.type) {
      case i32: EM_ASM_({ Module['info'].parent['HEAP32'][$0 >> 2] = $1 }, address, value); break;
      case f32: EM_ASM_({ Module['info'].parent['HEAPF32'][$0 >> 2] = $1 }, address, value); break;
      case f64: EM_ASM_({ Module['info'].parent['HEAPF64'][$0 >> 3] = $1 }, address, value); break;
      default: abort();
    }
  }
}

void finalizeModule() {
  uint32_t providedMemory = EM_ASM_INT_V({
    return Module['providedTotalMemory']; // we receive the size of memory from emscripten
  });
  if (providedMemory & ~Memory::kPageMask) {
    std::cerr << "Error: provided memory is not a multiple of the 64k wasm page size\n";
    exit(EXIT_FAILURE);
  }
  module->memory.initial = Address(providedMemory / Memory::kPageSize);
  module->memory.max = module->checkExport(GROW_WASM_MEMORY) ? Address(Memory::kMaxSize) : module->memory.initial;

  // global mapping is done in js in post.js
}

// loads wasm code in s-expression format
extern "C" void EMSCRIPTEN_KEEPALIVE load_s_expr2wasm(char *input) {
  prepare2wasm();

  if (wasmJSDebug) std::cerr << "wasm-s-expression parsing...\n";

  sExpressionParser = new SExpressionParser(input);
  Element& root = *sExpressionParser->root;
  if (wasmJSDebug) std::cout << root << '\n';

  if (wasmJSDebug) std::cerr << "wasming...\n";

  module = new Module();
  // A .wast may have multiple modules, with some asserts after them, but we just read the first here.
  sExpressionWasmBuilder = new SExpressionWasmBuilder(*module, *root[0]);

  finalizeModule();
}

// loads wasm code in binary format
extern "C" void EMSCRIPTEN_KEEPALIVE load_binary2wasm(char *raw, int32_t size) {
  prepare2wasm();

  if (wasmJSDebug) std::cerr << "wasm-binary parsing...\n";

  module = new Module();
  std::vector<char> input;
  input.resize(size);
  for (int32_t i = 0; i < size; i++) {
    input[i] = raw[i];
  }
  WasmBinaryBuilder parser(*module, input, debug);
  parser.read();

  finalizeModule();
}

// instantiates the loaded wasm (which might be from asm2wasm, or
// s-expressions, or something else) with a JS external interface.
extern "C" void EMSCRIPTEN_KEEPALIVE instantiate() {
  if (wasmJSDebug) std::cerr << "instantiating module: \n" << module << '\n';

  if (wasmJSDebug) std::cerr << "generating exports...\n";

  EM_ASM({
    Module['asmExports'] = {};
  });
  for (auto& curr : module->exports) {
    EM_ASM_({
      var name = Pointer_stringify($0);
      Module['asmExports'][name] = function() {
        Module['tempArguments'] = Array.prototype.slice.call(arguments);
        Module['_call_from_js']($0);
        return Module['tempReturn'];
      };
    }, curr->name.str);
  }

  // verify imports are provided
  for (auto& import : module->imports) {
    EM_ASM_({
      var mod = Pointer_stringify($0);
      var base = Pointer_stringify($1);
      var name = Pointer_stringify($2);
      assert(Module['lookupImport'](mod, base), 'checking import ' + name + ' = ' + mod + '.' + base);
    }, import->module.str, import->base.str, import->name.str);
  }

  if (wasmJSDebug) std::cerr << "creating instance...\n";

  struct JSExternalInterface : ModuleInstance::ExternalInterface {
    void init(Module& wasm) override {
      // create a new buffer here, just like native wasm support would.
      EM_ASM_({
        Module['outside']['newBuffer'] = new ArrayBuffer($0);
      }, wasm.memory.initial * Memory::kPageSize);
      for (auto segment : wasm.memory.segments) {
        EM_ASM_({
          var source = Module['HEAP8'].subarray($1, $1 + $2);
          var target = new Int8Array(Module['outside']['newBuffer']);
          target.set(source, $0);
        }, (uint32_t)segment.offset, &segment.data[0], segment.data.size());
      }
    }

    Literal callImport(Import *import, ModuleInstance::LiteralList& arguments) override {
      if (wasmJSDebug) std::cout << "calling import " << import->name.str << '\n';
      EM_ASM({
        Module['tempArguments'] = [];
      });
      for (auto& argument : arguments) {
        if (argument.type == i32) {
          EM_ASM_({ Module['tempArguments'].push($0) }, argument.geti32());
        } else if (argument.type == f32) {
          EM_ASM_({ Module['tempArguments'].push($0) }, argument.getf32());
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

      if (wasmJSDebug) std::cout << "calling import returning " << ret << '\n';

      switch (import->type->result) {
        case none: return Literal(0);
        case i32: return Literal((int32_t)ret);
        case f32: return Literal((float)ret);
        case f64: return Literal((double)ret);
        default: abort();
      }
    }

    Literal load(Load* load, Address address) override {
      uint32_t addr = address;
      if (load->align < load->bytes || (addr & (load->bytes-1))) {
        int64_t out64;
        double ret = EM_ASM_DOUBLE({
          var addr = $0;
          var bytes = $1;
          var isFloat = $2;
          var isSigned = $3;
          var out64 = $4;
          var save0 = HEAP32[0];
          var save1 = HEAP32[1];
          for (var i = 0; i < bytes; i++) {
            HEAPU8[i] = Module["info"].parent["HEAPU8"][addr + i];
          }
          var ret;
          if (!isFloat) {
            if (bytes === 1)      ret = isSigned ? HEAP8[0]  : HEAPU8[0];
            else if (bytes === 2) ret = isSigned ? HEAP16[0] : HEAPU16[0];
            else if (bytes === 4) ret = isSigned ? HEAP32[0] : HEAPU32[0];
            else if (bytes === 8) {
              for (var i = 0; i < bytes; i++) {
                HEAPU8[out64 + i] = HEAPU8[i];
              }
            } else abort();
          } else {
            if (bytes === 4)      ret = HEAPF32[0];
            else if (bytes === 8) ret = HEAPF64[0];
            else abort();
          }
          HEAP32[0] = save0; HEAP32[1] = save1;
          return ret;
        }, (uint32_t)addr, load->bytes, isWasmTypeFloat(load->type), load->signed_, &out64);
        if (!isWasmTypeFloat(load->type)) {
          if (load->type == i64) {
            if (load->bytes == 8) {
              return Literal(out64);
            } else {
              if (load->signed_) {
                return Literal(int64_t(int32_t(ret)));
              } else {
                return Literal(int64_t(uint32_t(ret)));
              }
            }
          }
          return Literal((int32_t)ret);
        } else if (load->bytes == 4) {
          return Literal((float)ret);
        } else if (load->bytes == 8) {
          return Literal((double)ret);
        }
        abort();
      }
      // nicely aligned
      if (!isWasmTypeFloat(load->type)) {
        int64_t ret;
        if (load->bytes == 1) {
          if (load->signed_) {
            ret = EM_ASM_INT({ return Module['info'].parent['HEAP8'][$0] }, addr);
          } else {
            ret = EM_ASM_INT({ return Module['info'].parent['HEAPU8'][$0] }, addr);
          }
        } else if (load->bytes == 2) {
          if (load->signed_) {
            ret = EM_ASM_INT({ return Module['info'].parent['HEAP16'][$0 >> 1] }, addr);
          } else {
            ret = EM_ASM_INT({ return Module['info'].parent['HEAPU16'][$0 >> 1] }, addr);
          }
        } else if (load->bytes == 4) {
          if (load->signed_) {
            ret = EM_ASM_INT({ return Module['info'].parent['HEAP32'][$0 >> 2] }, addr);
          } else {
            ret = uint32_t(EM_ASM_INT({ return Module['info'].parent['HEAPU32'][$0 >> 2] }, addr));
          }
        } else if (load->bytes == 8) {
          uint32_t low  = EM_ASM_INT({ return Module['info'].parent['HEAP32'][$0 >> 2] }, addr);
          uint32_t high = EM_ASM_INT({ return Module['info'].parent['HEAP32'][$0 >> 2] }, addr + 4);
          ret = uint64_t(low) | (uint64_t(high) << 32);
        } else abort();
        return load->type == i32 ? Literal(int32_t(ret)) : Literal(ret);
      } else {
        if (load->bytes == 4) {
          return Literal((float)EM_ASM_DOUBLE({ return Module['info'].parent['HEAPF32'][$0 >> 2] }, addr));
        } else if (load->bytes == 8) {
          return Literal(EM_ASM_DOUBLE({ return Module['info'].parent['HEAPF64'][$0 >> 3] }, addr));
        }
        abort();
      }
    }

    void store(Store* store_, Address address, Literal value) override {
      uint32_t addr = address;
      // support int64 stores
      if (value.type == WasmType::i64) {
        Store fake = *store_;
        fake.bytes = 4;
        fake.type = i32;
        uint64_t v = value.geti64();
        store(&fake, addr, Literal(uint32_t(v)));
        v >>= 32;
        store(&fake, addr + 4, Literal(uint32_t(v)));
        return;
      }
      // normal non-int64 value
      if (store_->align < store_->bytes || (addr & (store_->bytes-1))) {
        EM_ASM_DOUBLE({
          var addr = $0;
          var bytes = $1;
          var isFloat = $2;
          var value = $3;
          var save0 = HEAP32[0];
          var save1 = HEAP32[1];
          if (!isFloat) {
            if (bytes === 1)      HEAPU8[0] = value;
            else if (bytes === 2) HEAPU16[0] = value;
            else if (bytes === 4) HEAPU32[0] = value;
            else abort();
          } else {
            if (bytes === 4)      HEAPF32[0] = value;
            else if (bytes === 8) HEAPF64[0] = value;
            else abort();
          }
          for (var i = 0; i < bytes; i++) {
            Module["info"].parent["HEAPU8"][addr + i] = HEAPU8[i];
          }
          HEAP32[0] = save0; HEAP32[1] = save1;
        }, (uint32_t)addr, store_->bytes, isWasmTypeFloat(store_->type), isWasmTypeFloat(store_->type) ? value.getFloat() : (double)value.getInteger());
        return;
      }
      // nicely aligned
      if (!isWasmTypeFloat(store_->type)) {
        if (store_->bytes == 1) {
          EM_ASM_INT({ Module['info'].parent['HEAP8'][$0] = $1 }, addr, value.geti32());
        } else if (store_->bytes == 2) {
          EM_ASM_INT({ Module['info'].parent['HEAP16'][$0 >> 1] = $1 }, addr, value.geti32());
        } else if (store_->bytes == 4) {
          EM_ASM_INT({ Module['info'].parent['HEAP32'][$0 >> 2] = $1 }, addr, value.geti32());
        } else {
          abort();
        }
      } else {
        if (store_->bytes == 4) {
          EM_ASM_DOUBLE({ Module['info'].parent['HEAPF32'][$0 >> 2] = $1 }, addr, value.getf32());
        } else if (store_->bytes == 8) {
          EM_ASM_DOUBLE({ Module['info'].parent['HEAPF64'][$0 >> 3] = $1 }, addr, value.getf64());
        } else {
          abort();
        }
      }
    }

    void growMemory(Address oldSize, Address newSize) override {
      EM_ASM_({
        var size = $0;
        var buffer;
        try {
          buffer = new ArrayBuffer(size);
        } catch(e) {
          // fail to grow memory. post.js notices this since the buffer is unchanged
          return;
        }
        var oldHEAP8 = Module['outside']['HEAP8'];
        var temp = new Int8Array(buffer);
        temp.set(oldHEAP8);
        Module['outside']['buffer'] = buffer;
      }, (uint32_t)newSize);
    }

    void trap(const char* why) override {
      EM_ASM_({
        abort("wasm trap: " + Pointer_stringify($0));
      }, why);
    }
  };

  instance = new ModuleInstance(*module, new JSExternalInterface());

  // stack trace hooks
  EM_ASM({
    Module['outside']['extraStackTrace'] = function() {
      return Pointer_stringify(Module['_interpreter_stack_trace']());
    };
  });
}

extern "C" int EMSCRIPTEN_KEEPALIVE interpreter_stack_trace() {
  std::string stack = instance->printFunctionStack();
  return (int)strdup(stack.c_str()); // XXX leak
}

// Does a call from js into an export of the module.
extern "C" void EMSCRIPTEN_KEEPALIVE call_from_js(const char *target) {
  if (wasmJSDebug) std::cout << "call_from_js " << target << '\n';

  IString exportName(target);
  IString functionName = instance->wasm.getExport(exportName)->value;
  Function *function = instance->wasm.getFunction(functionName);
  assert(function);
  size_t seen = EM_ASM_INT_V({ return Module['tempArguments'].length });
  size_t actual = function->params.size();
  ModuleInstance::LiteralList arguments;
  for (size_t i = 0; i < actual; i++) {
    WasmType type = function->params[i];
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

  if (wasmJSDebug) std::cout << "call_from_js returning " << ret << '\n';

  if (ret.type == none) EM_ASM({ Module['tempReturn'] = undefined });
  else if (ret.type == i32) EM_ASM_({ Module['tempReturn'] = $0 }, ret.geti32());
  else if (ret.type == f32) EM_ASM_({ Module['tempReturn'] = $0 }, ret.getf32());
  else if (ret.type == f64) EM_ASM_({ Module['tempReturn'] = $0 }, ret.getf64());
  else abort();
}
