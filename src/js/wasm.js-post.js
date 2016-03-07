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

function integrateWasmJS(Module) {
  // wasm.js has several methods for creating the compiled code module here:
  //  * 'wasm-s-parser': load s-expression code from a .wast and create wasm
  //  * 'asm2wasm': load asm.js code and translate to wasm
  //  * 'just-asm': no wasm, just load the asm.js code and use that (good for testing)
  // The method can be set at compile time (BINARYEN_METHOD), or runtime by setting Module['wasmJSMethod'].
  var method = Module['wasmJSMethod'] || 'wasm-s-parser';
  assert(method == 'asm2wasm' || method == 'wasm-s-parser' || method == 'just-asm');

  if (method == 'just-asm') {
    eval(Module['read'](Module['asmjsCodeFile']));
    return;
  }

  var asm2wasmImports = { // special asm2wasm imports
    "f64-rem": function(x, y) {
      return x % y;
    },
    "f64-to-int": function(x) {
      return x | 0;
    },
    "debugger": function() {
      debugger;
    },
  };

  var info = {
    global: null,
    env: null,
    asm2wasm: asm2wasmImports,
    parent: Module // Module inside wasm-js.cpp refers to wasm-js.cpp; this allows access to the outside program.
  };

  function lookupImport(mod, base) {
    var lookup = info;
    if (mod.indexOf('.') < 0) {
      lookup = (lookup || {})[mod];
    } else {
      var parts = mod.split('.');
      lookup = (lookup || {})[parts[0]];
      lookup = (lookup || {})[parts[1]];
    }
    if (base) {
      lookup = (lookup || {})[base];
    }
    if (lookup === undefined) {
      abort('bad lookupImport to (' + mod + ').' + base);
    }
    return lookup;
  }

  function mergeMemory(newBuffer) {
    // The wasm instance creates its memory. But static init code might have written to
    // buffer already, including the mem init file, and we must copy it over in a proper merge.
    // TODO: avoid this copy, by avoiding such static init writes
    // TODO: in shorter term, just copy up to the last static init write
    var oldBuffer = Module['buffer'];
    if (newBuffer.byteLength < oldBuffer.byteLength) {
      Module['printErr']('the new buffer in mergeMemory is smaller than the previous one. in native wasm, we should grow memory here');
    }
    var oldView = new Int8Array(oldBuffer);
    var newView = new Int8Array(newBuffer);
    if ({{{ WASM_BACKEND }}}) {
      // memory segments arrived in the wast, do not trample them
      oldView.set(newView.subarray(STATIC_BASE, STATIC_BASE + STATIC_BUMP), STATIC_BASE);
    }
    newView.set(oldView);
    updateGlobalBuffer(newBuffer);
    updateGlobalBufferViews();
    Module['reallocBuffer'] = function(size) {
      var old = Module['buffer'];
      wasmJS['asmExports']['__growWasmMemory'](size); // tiny wasm method that just does grow_memory
      return Module['buffer'] !== old ? Module['buffer'] : null; // if it was reallocated, it changed
    };
  }

  var WasmTypes = {
    none: 0,
    i32: 1,
    i64: 2,
    f32: 3,
    f64: 4
  };

  // wasm lacks globals, so asm2wasm maps them into locations in memory. that information cannot
  // be present in the wasm output of asm2wasm, so we store it in a side file. If we load asm2wasm
  // output, either generated ahead of time or on the client, we need to apply those mapped
  // globals after loading the module.
  function applyMappedGlobals() {
    var mappedGlobals = JSON.parse(Module['read'](Module['wasmCodeFile'] + '.mappedGlobals'));
    for (var name in mappedGlobals) {
      var global = mappedGlobals[name];
      if (!global.import) continue; // non-imports are initialized to zero in the typed array anyhow, so nothing to do here
      var value = lookupImport(global.module, global.base);
      var address = global.address;
      switch (global.type) {
        case WasmTypes.i32: Module['HEAP32'][address >> 2] = value; break;
        case WasmTypes.f32: Module['HEAPF32'][address >> 2] = value; break;
        case WasmTypes.f64: Module['HEAPF64'][address >> 3] = value; break;
        default: abort();
      }
    }
  }

  if (typeof Wasm === 'object') {
    // Provide an "asm.js function" for the application, called to "link" the asm.js module. We instantiate
    // the wasm module at that time, and it receives imports and provides exports and so forth, the app
    // doesn't need to care that it is wasm and not asm.
    Module['asm'] = function(global, env, providedBuffer) {
      // Load the wasm module
      var binary;
      if (ENVIRONMENT_IS_WEB || ENVIRONMENT_IS_WORKER) {
        binary = Module['wasmBinary'];
        assert(binary, "on the web, we need the wasm binary to be preloaded and set on Module['wasmBinary']. emcc.py will do that for you when generating HTML (but not JS)");
        binary = new Uint8Array(binary);
      } else {
        binary = Module['readBinary'](Module['wasmCodeFile']);
      }
      // Create an instance of the module using native support in the JS engine.
      info['global'] = {
        'NaN': NaN,
        'Infinity': Infinity
      };
      info['global.Math'] = global.Math;
      info['env'] = env;
      var instance;
      instance = Wasm.instantiateModule(binary, info);
      mergeMemory(instance.memory);

      applyMappedGlobals();

      return instance;
    };

    return;
  }

  // Use wasm.js to polyfill and execute code in a wasm interpreter.
  var wasmJS = WasmJS({});

  // XXX don't be confused. Module here is in the outside program. wasmJS is the inner wasm-js.cpp.
  wasmJS['outside'] = Module; // Inside wasm-js.cpp, Module['outside'] reaches the outside module.

  // Information for the instance of the module.
  wasmJS['info'] = info;

  wasmJS['lookupImport'] = lookupImport;

  // The asm.js function, called to "link" the asm.js module. At that time, we are provided imports
  // and respond with exports, and so forth.
  Module['asm'] = function(global, env, providedBuffer) {
    assert(providedBuffer === Module['buffer']); // we should not even need to pass it as a 3rd arg for wasm, but that's the asm.js way.

    info.global = global;
    info.env = env;

    Module['reallocBuffer'] = function(size) {
      var old = Module['buffer'];
      wasmJS['asmExports']['__growWasmMemory'](size); // tiny wasm method that just does grow_memory
      return Module['buffer'] !== old ? Module['buffer'] : null; // if it was reallocated, it changed
    };

    wasmJS['providedTotalMemory'] = Module['buffer'].byteLength;

    // Prepare to generate wasm, using either asm2wasm or wasm-s-parser
    var code = Module['read'](method == 'asm2wasm' ? Module['asmjsCodeFile'] : Module['wasmCodeFile']);
    var temp = wasmJS['_malloc'](code.length + 1);
    wasmJS['writeAsciiToMemory'](code, temp);
    if (method == 'asm2wasm') {
      wasmJS['_load_asm2wasm'](temp);
    } else {
      wasmJS['_load_s_expr2wasm'](temp);
    }
    wasmJS['_free'](temp);

    wasmJS['_instantiate'](temp);

    if (Module['newBuffer']) {
      mergeMemory(Module['newBuffer']);
      Module['newBuffer'] = null;
    }

    if (method == 'wasm-s-parser') {
      applyMappedGlobals();
    }

    return wasmJS['asmExports'];
  };
}
