// Test a file is valid, by just loading it.

// Shell integration.
if (typeof console === 'undefined') {
  console = { log: print };
}
var tempRet0;
var binary;
if (typeof process === 'object' && typeof require === 'function' /* node.js detection */) {
  var args = process.argv.slice(2);
  binary = require('fs').readFileSync(args[0]);
  if (!binary.buffer) binary = new Uint8Array(binary);
} else {
  var args;
  if (typeof scriptArgs != 'undefined') {
    args = scriptArgs;
  } else if (typeof arguments != 'undefined') {
    args = arguments;
  }
  if (typeof readbuffer === 'function') {
    binary = new Uint8Array(readbuffer(args[0]));
  } else {
    binary = read(args[0], 'binary');
  }
}

// Test the wasm for validity. The imports aren't there (we can't use a proxy
// because we don't know the types), but if we get to the imports, that means
// the wasm is valid.
try {
  var instance = new WebAssembly.Instance(new WebAssembly.Module(binary), {});
} catch (e) {
  if (e.toString().indexOf('Import #') > 0) {
    console.log('import error, the wasm itself is valid');
  } else {
    throw e;
  }
}
console.log('wasm is valid');

