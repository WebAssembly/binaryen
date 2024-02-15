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

// Utilities.
function assert(x, y) {
  if (!x) throw (y || 'assertion failed');// + new Error().stack;
}

// Deterministic randomness.
var detrand = (function() {
  var hash = 5381; // TODO DET_RAND_SEED;
  var x = 0;
  return function() {
    hash = (((hash << 5) + hash) ^ (x & 0xff)) >>> 0;
    x = (x + 1) % 256;
    return (hash % 256) / 256;
  };
})();

// Fuzz integration.
function logValue(x, y) {
  if (typeof y !== 'undefined') {
    console.log('[LoggingExternalInterface logging ' + x + ' ' + y + ']');
  } else {
    console.log('[LoggingExternalInterface logging ' + x + ']');
  }
}

// Set up the imports.
var imports = {
  'fuzzing-support': {
    'log-i32': logValue,
    'log-i64': logValue,
    'log-f32': logValue,
    'log-f64': logValue,
    // JS cannot log v128 values (we trap on the boundary), but we must still
    // provide an import so that we do not trap during linking. (Alternatively,
    // we could avoid running JS on code with SIMD in it, but it is useful to
    // fuzz such code as much as we can.)
    'log-v128': logValue,
  },
  'env': {
    'setTempRet0': function(x) { tempRet0 = x },
    'getTempRet0': function() { return tempRet0 },
  },
};

// If Tags are available, add the import j2wasm expects.
if (typeof WebAssembly.Tag !== 'undefined') {
  imports['imports'] = {
    'j2wasm.ExceptionUtils.tag': new WebAssembly.Tag({
      'parameters': ['externref']
    }),
  };
}

// Create the wasm.
var module = new WebAssembly.Module(binary);

var instance;
try {
  instance = new WebAssembly.Instance(module, imports);
} catch (e) {
  console.log('exception: failed to instantiate module');
  quit();
}

// Handle the exports.
var exports = instance.exports;

var view;

// Recreate the view. This is important both initially and after a growth.
function refreshView() {
  if (exports.memory) {
    view = new Int32Array(exports.memory.buffer);
  }
}

// Run the wasm.
var sortedExports = [];
for (var e in exports) {
  sortedExports.push(e);
}
sortedExports.sort();
sortedExports.forEach(function(e) {
  if (typeof exports[e] !== 'function') return;
  try {
    console.log('[fuzz-exec] calling ' + e);
    var result = exports[e]();
    if (typeof result !== 'undefined') {
      console.log('[fuzz-exec] note result: $' + e + ' => ' + result);
    }
  } catch (e) {
    console.log('exception!');// + [e, e.stack]);
  }
});

