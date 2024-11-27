// Shell integration: find argv and set up readBinary().
var argv;
var readBinary;
if (typeof process === 'object' && typeof require === 'function') {
  // Node.js.
  argv = process.argv.slice(2);
  readBinary = function(name) {
    var data = require('fs').readFileSync(name);
    if (!data.buffer) data = new Uint8Array(data);
    return data;
  };
} else {
  // A shell like D8.
  if (typeof scriptArgs != 'undefined') {
    argv = scriptArgs;
  } else if (typeof arguments != 'undefined') {
    argv = arguments;
  }
  readBinary = function(name) {
    if (typeof readbuffer === 'function') {
      return new Uint8Array(readbuffer(name));
    } else {
      return read(name, 'binary');
    }
  };
}

// The binary to be run. This may be set already (by code that runs before this
// script), and if not, we get the filename from argv.
var binary;
if (!binary) {
  binary = readBinary(argv[0]);
}

// Normally we call all the exports of the given wasm file. But, if we are
// passed a final parameter in the form of "exports:X,Y,Z" then we call
// specifically the exports X, Y, and Z.
var exportsToCall;
if (argv.length > 0 && argv[argv.length - 1].startsWith('exports:')) {
  exportsToCall = argv[argv.length - 1].substr('exports:'.length).split(',');
  argv.pop();
}

// If a second parameter is given, it is a second binary that we will link in
// with it.
var secondBinary;
if (argv[1]) {
  secondBinary = readBinary(argv[1]);
}

// Utilities.
function assert(x, y) {
  if (!x) throw (y || 'assertion failed');// + new Error().stack;
}

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

// Track the exports in a map (similar to the Exports object from wasm, i.e.,
// whose keys are strings and whose values are the corresponding exports).
var exports = {};

// Also track exports in a list, to allow access by index. Each entry here will
// be in the form of { name: .., value: .. }. That allows us to log the name of
// the function and also to call it. This is important because different
// functions may have the same name, if they were exported by different
// Instances under the same export names.
var exportList = [];

// Given a wasm function, call it as best we can from JS, and return the result.
function callFunc(func) {
  // Send the function a null for each parameter. Null can be converted without
  // error to both a number and a reference.
  var args = [];
  for (var i = 0; i < func.length; i++) {
    args.push(null);
  }
  return func.apply(null, args);
}

// Calls a given function in a try-catch, swallowing JS exceptions, and return 1
// if we did in fact swallow an exception. Wasm traps are not swallowed (see
// details below).
function tryCall(func) {
  try {
    func();
    return 0;
  } catch (e) {
    // We only want to catch exceptions, not wasm traps: traps should still
    // halt execution. Handling this requires different code in wasm2js, so
    // check for that first (wasm2js does not define RuntimeError, so use
    // that for the check - when wasm2js is run, we override the entire
    // WebAssembly object with a polyfill, so we know exactly what it
    // contains).
    var wasm2js = !WebAssembly.RuntimeError;
    if (!wasm2js) {
      // When running native wasm, we can detect wasm traps.
      if (e instanceof WebAssembly.RuntimeError) {
        throw e;
      }
    }
    var text = e + '';
    // We must not swallow host limitations here: a host limitation is a
    // problem that means we must not compare the outcome here to any other
    // VM.
    var hostIssues = ['requested new array is too large',
                      'out of memory',
                      'Maximum call stack size exceeded'];
    if (wasm2js) {
      // When wasm2js does trap, it just throws an "abort" error.
      hostIssues.push('abort');
    }
    for (var hostIssue of hostIssues) {
      if (text.includes(hostIssue)) {
        throw e;
      }
    }
    // Otherwise, this is a normal exception we want to catch (a wasm
    // exception, or a conversion error on the wasm/JS boundary, etc.).
    return 1;
  }
}

// Table get/set operations need a BigInt if the table has 64-bit indexes. This
// adds a proper cast as needed.
function toAddressType(table, index) {
  // First, cast to unsigned. We do not support larger indexes anyhow.
  index = index >>> 0;
  if (typeof table.length == 'bigint') {
    return BigInt(index);
  }
  return index;
}

// Set up the imports.
var tempRet0;
var imports = {
  'fuzzing-support': {
    // Logging.
    'log-i32': logValue,
    'log-i64': logValue,
    'log-f32': logValue,
    'log-f64': logValue,
    // JS cannot log v128 values (we trap on the boundary), but we must still
    // provide an import so that we do not trap during linking. (Alternatively,
    // we could avoid running JS on code with SIMD in it, but it is useful to
    // fuzz such code as much as we can.)
    'log-v128': logValue,

    // Throw an exception from JS.
    'throw': () => {
      throw 'some JS error';
    },

    // Table operations.
    'table-get': (index) => {
      return exports.table.get(toAddressType(exports.table, index));
    },
    'table-set': (index, value) => {
      exports.table.set(toAddressType(exports.table, index), value);
    },

    // Export operations.
    'call-export': (index) => {
      callFunc(exportList[index].value);
    },
    'call-export-catch': (index) => {
      return tryCall(() => callFunc(exportList[index].value));
    },

    // Funcref operations.
    'call-ref': (ref) => {
      callFunc(ref);
    },
    'call-ref-catch': (ref) => {
      return tryCall(() => callFunc(ref));
    },
  },
  // Emscripten support.
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

// If a second binary will be linked in then set up the imports for
// placeholders. Any import like  (import "placeholder" "0" (func ..  will be
// provided by the secondary module, and must be called using an indirection.
if (secondBinary) {
  imports['placeholder'] = new Proxy({}, {
    get(target, prop, receiver) {
      // Return a function that throws. We could do an indirect call using the
      // exported table, but as we immediately link in the secondary module,
      // these stubs will not be called (they are written to the table, and the
      // secondary module overwrites them). We do need to return something so
      // the primary module links without erroring, though.
      return () => {
        throw 'proxy stub should not be called';
      }
    }
  });
}

// Compile and instantiate a wasm file.
function build(binary) {
  var module = new WebAssembly.Module(binary);

  var instance;
  try {
    instance = new WebAssembly.Instance(module, imports);
  } catch (e) {
    console.log('exception thrown: failed to instantiate module');
    quit();
  }

  // Update the exports. Note that this adds onto |exports|, |exportList|,
  // which is intentional: if we build another wasm, or build this one more
  // than once, we want to be able to call them all, so we unify all their
  // exports. (We do trample in |exports| when keys are equal - basically this
  // is a single global namespace - but |exportList| is appended to, so we do
  // keep the ability to call anything that was ever exported.)
  for (var key in instance.exports) {
    var value = instance.exports[key];
    exports[key] = value;
    exportList.push({ name: key, value: value });
  }
}

// Run the code by calling exports.
function callExports() {
  // Call the exports we were told, or if we were not given an explicit list,
  // call them all.
  var relevantExports = exportsToCall || exportList;

  for (var e of relevantExports) {
    var name, value;
    if (typeof e === 'string') {
      // We are given a string name to call. Look it up in the global namespace.
      name = e;
      value = exports[e];
    } else {
      // We are given an object form exportList, which bas both a name and a
      // value.
      name = e.name;
      value = e.value;
    }

    if (typeof value !== 'function') {
      continue;
    }

    try {
      console.log('[fuzz-exec] calling ' + name);
      var result = callFunc(value);
      if (typeof result !== 'undefined') {
        console.log('[fuzz-exec] note result: ' + name + ' => ' + printed(result));
      }
    } catch (e) {
      console.log('exception thrown: ' + e);
    }
  }
}

// Build the main wasm.
build(binary);

// Build the second wasm, if one was provided.
if (secondBinary) {
  build(secondBinary);
}

// Run.
callExports();
