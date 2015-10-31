
(function() {
  // XXX don't be confused. Module here is in the outside program. WasmJS is the inner wasm-js.cpp.

  // Generate a module instance of the asm.js converted into wasm.
  var code = read(Module['asmjsCodeFile']);
  var temp = WasmJS._malloc(code.length + 1);
  WasmJS.writeAsciiToMemory(code, temp);
  var instance = WasmJS.load_asm(temp);
  WasmJS._free(temp);

  // Generate memory XXX TODO get the right size
  var theBuffer = Module['buffer'] = new ArrayBuffer(16*1024*1024);

  // Information for the instance of the module.
  var instance = WasmJS['instance'] = {
    global: null,
    env: null,
    parent: Module // Module inside wasm-js.cpp refers to wasm-js.cpp; this allows access to the outside program.
  };

  // The asm.js function, called to "link" the asm.js module.
  Module['asm'] = function(global, env, buffer) {
    assert(buffer === theBuffer); // we should not even need to pass it as a 3rd arg for wasm, but that's the asm.js way.
    // write the provided data to a location the wasm instance can get at it.
    instance.global = global;
    instance.env = env;
  };
})();

