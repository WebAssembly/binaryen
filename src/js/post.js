
function integrateWasmJS(Module) {

  if (typeof WASM === 'object') {
    // Provide an "asm.js function" for the application, called to "link" the asm.js module. We instantiate
    // the wasm module at that time, and it receives imports and provides exports and so forth, the app
    // doesn't need to care that it is wasm and not asm.
    Module['asm'] = function(global, env, providedBuffer) {
      // Load the wasm module
      var binary = Module['readBinary'](Module['wasmCodeFile']);

      // Create an instance of the module using native support in the JS engine.
      var instance = WASM.instantiateModule(binary, {
        "global.Math": global.Math,
        "env": env
      });

      // The wasm instance creates its memory. But static init code might have written to
      // buffer already, and we must copy it over.
      // TODO: avoid this copy, by avoiding such static init writes
      // TODO: in shorter term, just copy up to the last static init write
      var oldBuffer = Module['buffer'];
      var newBuffer = instance.memory;
      assert(newBuffer.byteLength >= oldBuffer.byteLength, 'we might fail if we allocated more than TOTAL_MEMORY');
      // the wasm module does write out the memory initialization, in range STATIC_BASE..STATIC_BUMP, so avoid that
      (new Int8Array(newBuffer).subarray(0, STATIC_BASE)).set(new Int8Array(oldBuffer).subarray(0, STATIC_BASE));
      (new Int8Array(newBuffer).subarray(STATIC_BASE + STATIC_BUMP)).set(new Int8Array(oldBuffer).subarray(STATIC_BASE + STATIC_BUMP));
      updateGlobalBuffer(newBuffer);
      updateGlobalBufferViews();
      Module['reallocBuffer'] = function(size) {
        var old = Module['buffer'];
        wasmJS['asmExports']['__growWasmMemory'](size); // tiny wasm method that just does grow_memory
        return Module['buffer'] !== old ? Module['buffer'] : null; // if it was reallocated, it changed
      };

      return instance;
    };

    return;
  }

  // Use wasm.js to polyfill and execute code in a wasm interpreter.
  var wasmJS = WasmJS({});

  // XXX don't be confused. Module here is in the outside program. wasmJS is the inner wasm-js.cpp.
  wasmJS['outside'] = Module; // Inside wasm-js.cpp, Module['outside'] reaches the outside module.

  // Information for the instance of the module.
  var info = wasmJS['info'] = {
    global: null,
    env: null,
    asm2wasm: { // special asm2wasm imports
      "f64-rem": function(x, y) {
        return x % y;
      },
      "f64-to-int": function(x) {
        return x | 0;
      },
      "debugger": function() {
        debugger;
      },
    },
    parent: Module // Module inside wasm-js.cpp refers to wasm-js.cpp; this allows access to the outside program.
  };

  wasmJS['lookupImport'] = function(mod, base) {
    var lookup = info;
    if (mod.indexOf('.') < 0) {
      lookup = (lookup || {})[mod];
    } else {
      var parts = mod.split('.');
      lookup = (lookup || {})[parts[0]];
      lookup = (lookup || {})[parts[1]];
    }
    lookup = (lookup || {})[base];
    if (lookup === undefined) {
      abort('bad lookupImport to (' + mod + ').' + base);
    }
    return lookup;
  }

  // The asm.js function, called to "link" the asm.js module. At that time, we are provided imports
  // and respond with exports, and so forth.
  Module['asm'] = function(global, env, providedBuffer) {
    assert(providedBuffer === Module['buffer']); // we should not even need to pass it as a 3rd arg for wasm, but that's the asm.js way.

    // wasm code would create its own buffer, at this time. But static init code might have
    // written to the buffer already, and we must copy it over. We could just avoid
    // this copy in wasm.js polyfilling, but to be as close as possible to real wasm,
    // we do what wasm would do.
    // TODO: avoid this copy, by avoiding such static init writes
    // TODO: in shorter term, just copy up to the last static init write
    var oldBuffer = Module['buffer'];
    var newBuffer = ArrayBuffer(oldBuffer.byteLength);
    (new Int8Array(newBuffer)).set(new Int8Array(oldBuffer));
    updateGlobalBuffer(newBuffer);
    updateGlobalBufferViews();
    wasmJS['providedTotalMemory'] = Module['buffer'].byteLength;

    Module['reallocBuffer'] = function(size) {
      var old = Module['buffer'];
      wasmJS['asmExports']['__growWasmMemory'](size); // tiny wasm method that just does grow_memory
      return Module['buffer'] !== old ? Module['buffer'] : null; // if it was reallocated, it changed
    };

    // Prepare to generate wasm, using either asm2wasm or wasm-s-parser
    var method = Module['wasmJSMethod'] || 'asm2wasm';
    assert(method == 'asm2wasm' || method == 'wasm-s-parser');
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

    // write the provided data to a location the wasm instance can get at it.
    info.global = global;
    info.env = env;
    wasmJS['_load_mapped_globals'](); // now that we have global and env, we can ready the provided imported globals, copying them to their mapped locations.
    return wasmJS['asmExports'];
  };
}

