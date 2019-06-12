
function assert(x, y) {
  if (!x) throw (y || 'assertion failed');
}

var fs = require('fs');

// Get and compile the wasm.

var binary = fs.readFileSync('a.wasm');

var module = new WebAssembly.Module(binary);

var sleeps = 0;

var DATA_ADDR = 4;

var instance = new WebAssembly.Instance(module, {
  env: {
    sleep: function() {
      console.log('sleep...');
      sleeps++;
      // Unwinding.
      exports.bysyncify_start_unwind(DATA_ADDR);
      // Fill in the data structure. The first value has the stack location,
      // which begins 8 after it.
      view[DATA_ADDR >> 2] = DATA_ADDR + 8;
      // The end of the stack will not be reached here anyhow.
      view[DATA_ADDR + 4 >> 2] = 1024;
    }
  }
});

var exports = instance.exports;
var view = new Int32Array(exports.memory);

console.log(view);

// Run until the sleep.
var result = exports.run();
console.log('meaningless result during sleep: ' + result);
assert(!result, 'bad first sleep result');

console.log(view);

// Rewind, run until the second sleep.
exports.bysyncify_start_rewind(DATA_ADDR);
result = exports.run();
console.log('meaningless result during second sleep: ' + result);
assert(!result, 'bad first sleep result');

// Finally, rewind and run til the end.
exports.bysyncify_start_rewind(DATA_ADDR);
result = exports.run();
console.log('final result: ' + result);
assert(result == 42, 'bad final result');

assert(sleeps == 2, 'total of 2 sleeps');

throw 'a';

