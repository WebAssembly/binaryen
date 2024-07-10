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

// Print out a value in a way that works well for fuzzing.
function printed(x, y) {
  if (typeof y !== 'undefined') {
    // A pair of i32s which are a legalized i64.
    return x + ' ' + y;
  } else if (x === null) {
    // JS has just one null. Print that out rather than typeof null which is
    // 'object', below.
    return 'null';
  } else if (typeof x === 'string') {
    // Emit a string in the same format as the binaryen interpreter. This
    // escaping routine must be kept in sync with String::printEscapedJSON.
    var escaped = '';
    for (u of x) {
      switch (u) {
        case '"':
          escaped += '\\"';
          continue;
        case '\\':
          escaped += '\\\\';
          continue;
        case '\b':
          escaped += '\\b';
          continue;
        case '\f':
          escaped += '\\f';
          continue;
        case '\n':
          escaped += '\\n';
          continue;
        case '\r':
          escaped += '\\r';
          continue;
        case '\t':
          escaped += '\\t';
          continue;
        default:
          break;
      }

      var codePoint = u.codePointAt(0);
      if (32 <= codePoint && codePoint < 127) {
        escaped += u;
        continue
      }

      var printEscape = (codePoint) => {
        escaped += '\\u'
        escaped += ((codePoint & 0xF000) >> 12).toString(16);
        escaped += ((codePoint & 0x0F00) >> 8).toString(16);
        escaped += ((codePoint & 0x00F0) >> 4).toString(16);
        escaped += (codePoint & 0x000F).toString(16);
      };

      if (codePoint < 0x10000) {
        printEscape(codePoint);
      } else {
        printEscape(0xD800 + ((codePoint - 0x10000) >> 10));
        printEscape(0xDC00 + ((codePoint - 0x10000) & 0x3FF));
      }
    }
    return 'string("' + escaped + '")';
  } else if (typeof x === 'bigint') {
    // Print bigints in legalized form, which is two 32-bit numbers of the low
    // and high bits.
    return (Number(x) | 0) + ' ' + (Number(x >> 32n) | 0)
  } else if (typeof x !== 'number') {
    // Something that is not a number or string, like a reference. We can't
    // print a reference because it could look different after opts - imagine
    // that a function gets renamed internally (that is, the problem is that
    // JS printing will emit some info about the reference and not a stable
    // external representation of it). In those cases just print the type,
    // which will be 'object' or 'function'.
    return typeof x;
  } else {
    // A number. Print the whole thing.
    return '' + x;
  }
}

// Fuzzer integration.
function logValue(x, y) {
  console.log('[LoggingExternalInterface logging ' + printed(x, y) + ']');
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
  console.log('exception thrown: failed to instantiate module');
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
for (var e in exports) {
  if (typeof exports[e] !== 'function') {
    continue;
  }
  // Send the function a null for each parameter. Null can be converted without
  // error to both a number and a reference.
  var func = exports[e];
  var args = [];
  for (var i = 0; i < func.length; i++) {
    args.push(null);
  }
  try {
    console.log('[fuzz-exec] calling ' + e);
    var result = func.apply(null, args);
    if (typeof result !== 'undefined') {
      console.log('[fuzz-exec] note result: ' + e + ' => ' + printed(result));
    }
  } catch (e) {
    console.log('exception thrown: ' + e);
  }
}
