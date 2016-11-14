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
  //  * 'native-wasm' : use native WebAssembly support in the browser
  //  * 'interpret-s-expr': load s-expression code from a .wast and interpret
  //  * 'interpret-binary': load binary wasm and interpret
  //  * 'interpret-asm2wasm': load asm.js code, translate to wasm, and interpret
  //  * 'asmjs': no wasm, just load the asm.js code and use that (good for testing)
  // The method can be set at compile time (BINARYEN_METHOD), or runtime by setting Module['wasmJSMethod'].
  // The method can be a comma-separated list, in which case, we will try the
  // options one by one. Some of them can fail gracefully, and then we can try
  // the next.

  // inputs

  var method = Module['wasmJSMethod'] || {{{ wasmJSMethod }}} || 'native-wasm'; // by default, use native support
  Module['wasmJSMethod'] = method;

  var wasmTextFile = Module['wasmTextFile'] || {{{ wasmTextFile }}};
  var wasmBinaryFile = Module['wasmBinaryFile'] || {{{ wasmBinaryFile }}};
  var asmjsCodeFile = Module['asmjsCodeFile'] || {{{ asmjsCodeFile }}};

  // utilities

  var wasmPageSize = 64*1024;

  var asm2wasmImports = { // special asm2wasm imports
    "f64-rem": function(x, y) {
      return x % y;
    },
    "f64-to-int": function(x) {
      return x | 0;
    },
    "i32s-div": function(x, y) {
      return ((x | 0) / (y | 0)) | 0;
    },
    "i32u-div": function(x, y) {
      return ((x >>> 0) / (y >>> 0)) >>> 0;
    },
    "i32s-rem": function(x, y) {
      return ((x | 0) % (y | 0)) | 0;
    },
    "i32u-rem": function(x, y) {
      return ((x >>> 0) % (y >>> 0)) >>> 0;
    },
    "debugger": function() {
      debugger;
    },
  };

  var info = {
    'global': null,
    'env': null,
    'asm2wasm': asm2wasmImports,
    'parent': Module // Module inside wasm-js.cpp refers to wasm-js.cpp; this allows access to the outside program.
  };

  var exports = null;

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

    // If we have a mem init file, do not trample it
    if (!memoryInitializer) {
      oldView.set(newView.subarray(STATIC_BASE, STATIC_BASE + STATIC_BUMP), STATIC_BASE);
    }

    newView.set(oldView);
    updateGlobalBuffer(newBuffer);
    updateGlobalBufferViews();
  }

  var WasmTypes = {
    none: 0,
    i32: 1,
    i64: 2,
    f32: 3,
    f64: 4
  };

  function fixImports(imports) {
    if (!{{{ WASM_BACKEND }}}) return imports;
    var ret = {};
    for (var i in imports) {
      var fixed = i;
      if (fixed[0] == '_') fixed = fixed.substr(1);
      ret[fixed] = imports[i];
    }
    return ret;
  }

  function getBinary() {
    var binary;
    if (ENVIRONMENT_IS_WEB || ENVIRONMENT_IS_WORKER) {
      binary = Module['wasmBinary'];
      assert(binary, "on the web, we need the wasm binary to be preloaded and set on Module['wasmBinary']. emcc.py will do that for you when generating HTML (but not JS)");
      binary = new Uint8Array(binary);
    } else {
      binary = Module['readBinary'](wasmBinaryFile);
    }
    return binary;
  }

  // do-method functions

  function doJustAsm(global, env, providedBuffer) {
    // if no Module.asm, or it's the method handler helper (see below), then apply
    // the asmjs
    if (typeof Module['asm'] !== 'function' || Module['asm'] === methodHandler) {
      if (!Module['asmPreload']) {
        // you can load the .asm.js file before this, to avoid this sync xhr and eval
        eval(Module['read'](asmjsCodeFile)); // set Module.asm
      } else {
        Module['asm'] = Module['asmPreload'];
      }
    }
    if (typeof Module['asm'] !== 'function') {
      Module['printErr']('asm evalling did not set the module properly');
      return false;
    }
    return Module['asm'](global, env, providedBuffer);
  }

  function doNativeWasm(global, env, providedBuffer) {
    if (typeof WebAssembly !== 'object') {
      Module['printErr']('no native wasm support detected');
      return false;
    }
    // prepare memory import
    if (!(Module['wasmMemory'] instanceof WebAssembly.Memory)) {
      Module['printErr']('no native wasm Memory in use');
      return false;
    }
    env['memory'] = Module['wasmMemory'];
    // Load the wasm module and create an instance of using native support in the JS engine.
    info['global'] = {
      'NaN': NaN,
      'Infinity': Infinity
    };
    info['global.Math'] = global.Math;
    info['env'] = env;
    var instance;
    try {
      instance = new WebAssembly.Instance(new WebAssembly.Module(getBinary()), info)
    } catch (e) {
      Module['printErr']('failed to compile wasm module: ' + e);
      if (e.toString().indexOf('imported Memory with incompatible size') >= 0) {
        Module['printErr']('Memory size incompatibility issues may be due to changing TOTAL_MEMORY at runtime to something too large. Use ALLOW_MEMORY_GROWTH to allow any size memory (and also make sure not to set TOTAL_MEMORY at runtime to something smaller than it was at compile time).');
      }
      return false;
    }
    exports = instance.exports;
    if (exports.memory) mergeMemory(exports.memory);

    Module["usingWasm"] = true;

    return exports;
  }

  function doWasmPolyfill(global, env, providedBuffer, method) {
    if (typeof WasmJS !== 'function') {
      Module['printErr']('WasmJS not detected - polyfill not bundled?');
      return false;
    }

    // Use wasm.js to polyfill and execute code in a wasm interpreter.
    var wasmJS = WasmJS({});

    // XXX don't be confused. Module here is in the outside program. wasmJS is the inner wasm-js.cpp.
    wasmJS['outside'] = Module; // Inside wasm-js.cpp, Module['outside'] reaches the outside module.

    // Information for the instance of the module.
    wasmJS['info'] = info;

    wasmJS['lookupImport'] = lookupImport;

    assert(providedBuffer === Module['buffer']); // we should not even need to pass it as a 3rd arg for wasm, but that's the asm.js way.

    info.global = global;
    info.env = env;

    // polyfill interpreter expects an ArrayBuffer
    assert(providedBuffer === Module['buffer']);
    env['memory'] = providedBuffer;
    assert(env['memory'] instanceof ArrayBuffer);

    wasmJS['providedTotalMemory'] = Module['buffer'].byteLength;

    // Prepare to generate wasm, using either asm2wasm or s-exprs
    var code;
    if (method === 'interpret-binary') {
      code = getBinary();
    } else {
      code = Module['read'](method == 'interpret-asm2wasm' ? asmjsCodeFile : wasmTextFile);
    }
    var temp;
    if (method == 'interpret-asm2wasm') {
      temp = wasmJS['_malloc'](code.length + 1);
      wasmJS['writeAsciiToMemory'](code, temp);
      wasmJS['_load_asm2wasm'](temp);
    } else if (method === 'interpret-s-expr') {
      temp = wasmJS['_malloc'](code.length + 1);
      wasmJS['writeAsciiToMemory'](code, temp);
      wasmJS['_load_s_expr2wasm'](temp);
    } else if (method === 'interpret-binary') {
      temp = wasmJS['_malloc'](code.length);
      wasmJS['HEAPU8'].set(code, temp);
      wasmJS['_load_binary2wasm'](temp, code.length);
    } else {
      throw 'what? ' + method;
    }
    wasmJS['_free'](temp);

    wasmJS['_instantiate'](temp);

    if (Module['newBuffer']) {
      mergeMemory(Module['newBuffer']);
      Module['newBuffer'] = null;
    }

    exports = wasmJS['asmExports'];

    return exports;
  }

  // We may have a preloaded value in Module.asm, save it
  Module['asmPreload'] = Module['asm'];

  // Memory growth integration code
  Module['reallocBuffer'] = function(size) {
    size = Math.ceil(size / wasmPageSize) * wasmPageSize; // round up to wasm page size
    var old = Module['buffer'];
    var result = exports['__growWasmMemory'](size / wasmPageSize); // tiny wasm method that just does grow_memory
    if (Module["usingWasm"]) {
      if (result !== (-1 | 0)) {
        // success in native wasm memory growth, get the buffer from the memory
        return Module['buffer'] = Module['wasmMemory'].buffer;
      } else {
        return null;
      }
    } else {
      // in interpreter, we replace Module.buffer if we allocate
      return Module['buffer'] !== old ? Module['buffer'] : null; // if it was reallocated, it changed
    }
  };

  // Provide an "asm.js function" for the application, called to "link" the asm.js module. We instantiate
  // the wasm module at that time, and it receives imports and provides exports and so forth, the app
  // doesn't need to care that it is wasm or olyfilled wasm or asm.js.

  Module['asm'] = function(global, env, providedBuffer) {
    global = fixImports(global);
    env = fixImports(env);

    // import table
    if (!env['table']) {
      var TABLE_SIZE = Module['wasmTableSize'];
      if (TABLE_SIZE === undefined) TABLE_SIZE = 1024; // works in binaryen interpreter at least
      var MAX_TABLE_SIZE = Module['wasmMaxTableSize'];
      if (typeof WebAssembly === 'object' && typeof WebAssembly.Table === 'function') {
        if (MAX_TABLE_SIZE !== undefined) {
          env['table'] = new WebAssembly.Table({ initial: TABLE_SIZE, maximum: MAX_TABLE_SIZE, element: 'anyfunc' });
        } else {
          env['table'] = new WebAssembly.Table({ initial: TABLE_SIZE, element: 'anyfunc' });
        }
      } else {
        env['table'] = new Array(TABLE_SIZE); // works in binaryen interpreter at least
      }
      Module['wasmTable'] = env['table'];
    }

    if (!env['memoryBase']) {
      env['memoryBase'] = STATIC_BASE; // tell the memory segments where to place themselves
    }
    if (!env['tableBase']) {
      env['tableBase'] = 0; // table starts at 0 by default, in dynamic linking this will change
    }
    
    // try the methods. each should return the exports if it succeeded

    var exports;
    var methods = method.split(',');

    for (var i = 0; i < methods.length; i++) {
      var curr = methods[i];

      Module['printErr']('trying binaryen method: ' + curr);

      if (curr === 'native-wasm') {
        if (exports = doNativeWasm(global, env, providedBuffer)) break;
      } else if (curr === 'asmjs') {
        if (exports = doJustAsm(global, env, providedBuffer)) break;
      } else if (curr === 'interpret-asm2wasm' || curr === 'interpret-s-expr' || curr === 'interpret-binary') {
        if (exports = doWasmPolyfill(global, env, providedBuffer, curr)) break;
      } else {
        throw 'bad method: ' + curr;
      }
    }

    if (!exports) throw 'no binaryen method succeeded. consider enabling more options, like interpreting, if you want that: https://github.com/kripken/emscripten/wiki/WebAssembly#binaryen-methods';

    Module['printErr']('binaryen method succeeded.');

    return exports;
  };

  var methodHandler = Module['asm']; // note our method handler, as we may modify Module['asm'] later
}

