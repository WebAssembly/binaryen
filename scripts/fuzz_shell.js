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
  // The fuzzer emits memories of size 16 (pages). Allow us to use almost all of
  // that (we start from offset 4, so we can't use them all).
  DATA_MAX: 15 * 65536,
  savedMemory: null,
  instrumentImports: function(imports) {
    var ret = {};
    for (var module in imports) {
      ret[module] = {};
      for (var i in imports[module]) {
        if (typeof imports[module][i] === 'function') {
          (function(module, i) {
            ret[module][i] = function() {
              refreshView();
              if (!Asyncify.sleeping) {
                // Sleep if asyncify support is present (which also requires
                // that the memory be exported), and at a certain probability.
                if (exports.asyncify_start_unwind &&
                    view &&
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
    // Do not instrument unnecessarily, as this adds overhead and makes
    // debugging harder.
    var hasAsyncify = false;
    for (var e in exports) {
      if (e.startsWith('asyncify_')) {
        hasAsyncify = true;
        break;
      }
    }
    if (!hasAsyncify) {
      return exports;
    }

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

// Print out a value in a way that works well for fuzzing.
function printed(x, y) {
  if (typeof y !== 'undefined') {
    // A pair of i32s which are a legalized i64.
    return x + ' ' + y;
  } else if (x === null) {
    // JS has just one null. Print that out rather than typeof null which is
    // 'object', below.
    return 'null';
  } else if (typeof x !== 'number' && typeof x !== 'string') {
    // Something that is not a number or string, like a reference. We can't
    // print a reference because it could look different after opts - imagine
    // that a function gets renamed internally (that is, the problem is that
    // JS printing will emit some info about the reference and not a stable
    // external representation of it). In those cases just print the type.
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

imports = Asyncify.instrumentImports(imports);

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
exports = Asyncify.instrumentExports(exports);

var view;

// Recreate the view. This is important both initially and after a growth.
function refreshView() {
  if (exports.memory) {
    view = new Int32Array(exports.memory.buffer);
  }
}

// Run the wasm.
for (var e in exports) {
  // Ignore special intrinsic functions.
  if (e.startsWith('asyncify_')) {
    continue;
  }

  Asyncify.check();
  if (typeof exports[e] !== 'function') {
    continue;
  }
  try {
    console.log('[fuzz-exec] calling ' + e);
    var result = exports[e]();
    if (typeof result !== 'undefined') {
      console.log('[fuzz-exec] note result: ' + e + ' => ' + printed(result));
    }
  } catch (e) {
    console.log('exception!');// + [e, e.stack]);
  }
}

// Finish up
Asyncify.finish();
