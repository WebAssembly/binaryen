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

// Bysyncify integration.
var Bysyncify = {
  sleeping: false,
  sleepingFunction: null,
  sleeps: 0,
  maxDepth: 0,
  DATA_ADDR: 4,
  DATA_MAX: 65536,
  savedMemory: null,
  instrumentImports: function(imports) {
    var ret = {};
    for (var module in imports) {
      ret[module] = {};
      for (var i in imports[module]) {
        if (typeof imports[module][i] === 'function') {
          (function(module, i) {
            ret[module][i] = function() {
              if (!Bysyncify.sleeping) {
                // Sleep if bysyncify support is present, and at a certain
                // probability.
                if (exports.bysyncify_start_unwind && 
                    detrand() < 0.5) {
                  // We are called in order to start a sleep/unwind.
                  console.log('bysyncify: sleep in ' + i + '...');
                  Bysyncify.sleepingFunction = i;
                  Bysyncify.sleeps++;
                  var depth = new Error().stack.split('\n').length - 6;
                  Bysyncify.maxDepth = Math.max(Bysyncify.maxDepth, depth);
                  // Save the memory we use for data, so after we restore it later, the
                  // sleep/resume appears to have had no change to memory.
                  Bysyncify.savedMemory = new Int32Array(view.subarray(Bysyncify.DATA_ADDR >> 2, Bysyncify.DATA_MAX >> 2));
                  // Unwinding.
                  // Fill in the data structure. The first value has the stack location,
                  // which for simplicity we can start right after the data structure itself.
                  view[Bysyncify.DATA_ADDR >> 2] = Bysyncify.DATA_ADDR + 8;
                  // The end of the stack will not be reached here anyhow.
                  view[Bysyncify.DATA_ADDR + 4 >> 2] = Bysyncify.DATA_MAX;
                  exports.bysyncify_start_unwind(Bysyncify.DATA_ADDR);
                  Bysyncify.sleeping = true;
                } else {
                  // Don't sleep, normal execution.
                  return imports[module][i].apply(null, arguments);
                }
              } else {
                // We are called as part of a resume/rewind. Stop sleeping.
                console.log('bysyncify: resume in ' + i + '...');
                assert(Bysyncify.sleepingFunction === i);
                exports.bysyncify_stop_rewind();
                // The stack should have been all used up, and so returned to the original state.
                assert(view[Bysyncify.DATA_ADDR >> 2] == Bysyncify.DATA_ADDR + 8);
                assert(view[Bysyncify.DATA_ADDR + 4 >> 2] == Bysyncify.DATA_MAX);
                Bysyncify.sleeping = false;
                // Restore the memory to the state from before we slept.
                view.set(Bysyncify.savedMemory, Bysyncify.DATA_ADDR >> 2);
                return imports[module][i].apply(null, arguments);
              }
            };
          })(module, i);
        } else {
          ret[module][i] = imports[module][i];
        }
      }
    }
    // Add ignored.print, which is ignored by bysyncify, and allows debugging of bysyncified code.
    ret['ignored'] = { 'print': function(x, y) { console.log(x, y) } };
    return ret;
  },
  instrumentExports: function(exports) {
    var ret = {};
    for (var e in exports) {
      if (typeof exports[e] === 'function' &&
          !e.startsWith('bysyncify_')) {
        (function(e) {
          ret[e] = function() {
            while (1) {
              var ret = exports[e].apply(null, arguments);
              // If we are sleeping, then the stack was unwound; rewind it.
              if (Bysyncify.sleeping) {
                console.log('bysyncify: stop unwind; rewind');
                assert(!ret, 'results during sleep are meaningless, just 0');
                //console.log('bysyncify: after unwind', view[Bysyncify.DATA_ADDR >> 2], view[Bysyncify.DATA_ADDR + 4 >> 2]);
                try {
                  exports.bysyncify_stop_unwind();
                  exports.bysyncify_start_rewind(Bysyncify.DATA_ADDR);
                } catch (e) {
                  console.log('error in unwind/rewind switch', e);
                }
                continue;
              }
              return ret;
            }
          };
        })(e);
      } else {
        ret[e] = exports[e];
      }
    }
    return ret;
  },
  check: function() {
    assert(!Bysyncify.sleeping);
  },
  finish: function() {
    if (Bysyncify.sleeps > 0) {
      print('bysyncify:', 'sleeps:', Bysyncify.sleeps, 'max depth:', Bysyncify.maxDepth);
    }
  },
};

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
  },
  'env': {
    'setTempRet0': function(x) { tempRet0 = x },
    'getTempRet0': function() { return tempRet0 },
  },
};

imports = Bysyncify.instrumentImports(imports);

// Create the wasm.
var instance = new WebAssembly.Instance(new WebAssembly.Module(binary), imports);

// Handle the exports.
var exports = instance.exports;
exports = Bysyncify.instrumentExports(exports);
var view = new Int32Array(exports.memory.buffer);

// Run the wasm.
var sortedExports = [];
for (var e in exports) {
  sortedExports.push(e);
}
sortedExports.sort();
sortedExports = sortedExports.filter(function(e) {
  // Filter special intrinsic functions.
  return !e.startsWith('bysyncify_');
});
sortedExports.forEach(function(e) {
  Bysyncify.check();
  if (typeof exports[e] !== 'function') return;
  try {
    console.log('[fuzz-exec] calling $' + e);
    var result = exports[e]();
    if (typeof result !== 'undefined') {
      console.log('[fuzz-exec] note result: $' + e + ' => ' + result);
    }
  } catch (e) {
    console.log('exception!');// + [e, e.stack]);
  }
});

// Finish up
Bysyncify.finish();

