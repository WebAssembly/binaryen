
(function() {
  var wasmJS = WasmJS({}); // do not use the normal Module in the current scope

  // XXX don't be confused. Module here is in the outside program. wasmJS is the inner wasm-js.cpp.

  // Generate a module instance of the asm.js converted into wasm.
  var code;
  if (typeof read === 'function') {
    // spidermonkey or v8 shells
    code = read(Module['asmjsCodeFile']);
  } else if (typeof process === 'object' && typeof require === 'function') {
    // node.js
    code = require('fs')['readFileSync'](Module['asmjsCodeFile']).toString();
  } else {
    throw 'TODO: loading in other platforms';
  }

  var temp = wasmJS._malloc(code.length + 1);
  wasmJS.writeAsciiToMemory(code, temp);
  wasmJS._load_asm(temp);
  wasmJS._free(temp);

  // Generate memory XXX TODO get the right size
  var theBuffer = Module['buffer'] = new ArrayBuffer(Module['providedTotalMemory'] || 64*1024*1024);

  // Information for the instance of the module.
  var info = wasmJS['info'] = {
    global: null,
    env: null,
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

  // The asm.js function, called to "link" the asm.js module.
  Module['asm'] = function(global, env, buffer) {
    assert(buffer === theBuffer); // we should not even need to pass it as a 3rd arg for wasm, but that's the asm.js way.
    // write the provided data to a location the wasm instance can get at it.
    info.global = global;
    info.env = env;
    wasmJS['_load_mapped_globals'](); // now that we have global and env, we can ready the provided imported globals, copying them to their mapped locations.
    return wasmJS['asmExports'];
  };
})();

