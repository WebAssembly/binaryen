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

// Asyncify integration.
var Asyncify = {
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
              if (!Asyncify.sleeping) {
                // Sleep if asyncify support is present, and at a certain
                // probability.
                if (exports.asyncify_start_unwind && 
                    detrand() < 0.5) {
                  // We are called in order to start a sleep/unwind.
                  console.log('asyncify: sleep in ' + i + '...');
                  Asyncify.sleepingFunction = i;
                  Asyncify.sleeps++;
                  var depth = new Error().stack.split('\n').length - 6;
                  Asyncify.maxDepth = Math.max(Asyncify.maxDepth, depth);
                  // Save the memory we use for data, so after we restore it later, the
                  // sleep/resume appears to have had no change to memory.
                  Asyncify.savedMemory = new Int32Array(view.subarray(Asyncify.DATA_ADDR >> 2, Asyncify.DATA_MAX >> 2));
                  // Unwinding.
                  // Fill in the data structure. The first value has the stack location,
                  // which for simplicity we can start right after the data structure itself.
                  view[Asyncify.DATA_ADDR >> 2] = Asyncify.DATA_ADDR + 8;
                  // The end of the stack will not be reached here anyhow.
                  view[Asyncify.DATA_ADDR + 4 >> 2] = Asyncify.DATA_MAX;
                  exports.asyncify_start_unwind(Asyncify.DATA_ADDR);
                  Asyncify.sleeping = true;
                } else {
                  // Don't sleep, normal execution.
                  return imports[module][i].apply(null, arguments);
                }
              } else {
                // We are called as part of a resume/rewind. Stop sleeping.
                console.log('asyncify: resume in ' + i + '...');
                assert(Asyncify.sleepingFunction === i);
                exports.asyncify_stop_rewind();
                // The stack should have been all used up, and so returned to the original state.
                assert(view[Asyncify.DATA_ADDR >> 2] == Asyncify.DATA_ADDR + 8);
                assert(view[Asyncify.DATA_ADDR + 4 >> 2] == Asyncify.DATA_MAX);
                Asyncify.sleeping = false;
                // Restore the memory to the state from before we slept.
                view.set(Asyncify.savedMemory, Asyncify.DATA_ADDR >> 2);
                return imports[module][i].apply(null, arguments);
              }
            };
          })(module, i);
        } else {
          ret[module][i] = imports[module][i];
        }
      }
    }
    // Add ignored.print, which is ignored by asyncify, and allows debugging of asyncified code.
    ret['ignored'] = { 'print': function(x, y) { console.log(x, y) } };
    return ret;
  },
  instrumentExports: function(exports) {
    var ret = {};
    for (var e in exports) {
      if (typeof exports[e] === 'function' &&
          !e.startsWith('asyncify_')) {
        (function(e) {
          ret[e] = function() {
            while (1) {
              var ret = exports[e].apply(null, arguments);
              // If we are sleeping, then the stack was unwound; rewind it.
              if (Asyncify.sleeping) {
                console.log('asyncify: stop unwind; rewind');
                assert(!ret, 'results during sleep are meaningless, just 0');
                //console.log('asyncify: after unwind', view[Asyncify.DATA_ADDR >> 2], view[Asyncify.DATA_ADDR + 4 >> 2]);
                try {
                  exports.asyncify_stop_unwind();
                  exports.asyncify_start_rewind(Asyncify.DATA_ADDR);
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
    assert(!Asyncify.sleeping);
  },
  finish: function() {
    if (Asyncify.sleeps > 0) {
      print('asyncify:', 'sleeps:', Asyncify.sleeps, 'max depth:', Asyncify.maxDepth);
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

imports = Asyncify.instrumentImports(imports);

// Create the wasm.
var instance = new WebAssembly.Instance(new WebAssembly.Module(binary), imports);

// Handle the exports.
var exports = instance.exports;
exports = Asyncify.instrumentExports(exports);
if (exports.memory) {
  var view = new Int32Array(exports.memory.buffer);
}

// Run the wasm.
var sortedExports = [];
for (var e in exports) {
  sortedExports.push(e);
}
sortedExports.sort();
sortedExports = sortedExports.filter(function(e) {
  // Filter special intrinsic functions.
  return !e.startsWith('asyncify_');
});
sortedExports.forEach(function(e) {
  Asyncify.check();
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
Asyncify.finish();

