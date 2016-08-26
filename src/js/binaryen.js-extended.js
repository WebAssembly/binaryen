// Extended API

// Makes the internal buffer iterable so we can use Uint8Array.from
if (typeof Symbol !== 'undefined' && Symbol.iterator) {
  Module['BufferWithRandomAccess'].prototype[Symbol.iterator] = function() {
    var b = this, i = 0, L = b.size();
    return {
      next: function() {
        if (i < L) {
          return { done: false, value: b.at(i++) }
        } else {
          return { done: true }
        }
      }
    }
  };
}

// Converts (copies) a BufferWithRandomAccess to native ArrayBuffer
if (typeof Uint8Array !== 'undefined') {
  Module['BufferWithRandomAccess'].prototype['toArrayBuffer'] = function() {
    return Uint8Array['from'](this).buffer; // :ArrayBuffer
  };
}

// Parse and compile S-expression text syntax into WASM code.
// When running in NodeJS, this functions returns a Buffer instead of ArrayBuffer.
Module['compileWast'] = function compileWast(sourceText /*:string*/) /*:ArrayBuffer*/ {
  var parser = new Module['SExpressionParser'](sourceText);

  // console.log('s-expr dump:');
  // parser.get_root().dump();

  var s_module = parser.get_root().getChild(0);
  // console.log('s_module', s_module)

  // strange API for creating WASM `module` from S-expression AST
  var module = new Module['Module']();
  new Module['SExpressionWasmBuilder'](module, s_module);

  // console.log('module:', module);
  // this.WasmPrinter.prototype.printModule(module);

  // emit WASM
  var debug = false;
  var buf0 = new Module['BufferWithRandomAccess'](debug);
  var wasmWriter = new Module['WasmBinaryWriter'](module, buf0, debug);
  wasmWriter.write();

  if (ENVIRONMENT_IS_NODE) {
    return Buffer['from'](Uint8Array['from'](buf0));
  } else {
    return buf0['toArrayBuffer']();
  }
};

