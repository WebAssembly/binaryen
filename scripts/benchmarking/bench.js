
// Usage:
//
//  * wasm-opt bench.wat -O3 -o bench.wasm -all
//  * Inspect the optimized wasm to see that inlining etc. worked properly
//    (we rely on inlining to let us write bench.wat in a short/simple form).
//  * d8 bench.js -- bench.wasm
//  * profit
//

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

// Create the wasm.
const module = new WebAssembly.Module(binary);
const instance = new WebAssembly.Instance(module, {});
const exports = instance.exports;

// Create objects of both type $A and $B.
const N = 1000;
const as = Array.from({ length: N }, () => exports.makeA());
const bs = Array.from({ length: N }, () => exports.makeB());

// Call the benchmark functions with a mixture of as and bs.
const M = 10000;
var timeIff = 0, timeAnd = 0, timeLen = 0;
var sum = 0, iters = 0;

for (var i = 0; i < N; i++) {
  for (var j = 0; j < M; j++) {
    iters++;

    // Pick either an $A or a $B based on i and j.
    const x = (i & 1) ? as[i] : bs[i];
    const y = (j & 1) ? as[i] : bs[i];

    // Execute the exports.
    var start = performance.now();
    const resultIff = exports.iff(x, y);
    timeIff += performance.now() - start;

    start = performance.now();
    const resultAnd = exports.and(x, y);
    timeAnd += performance.now() - start;

    start = performance.now();
    const resultLen = exports.len(x, y);
    timeLen += performance.now() - start;

    // The functions are computing the same thing.
    if (resultIff !== resultAnd) throw 'wtf';
    sum += resultIff;
  }
}

console.log('iters       :', iters);
console.log('sum         :', sum);
console.log('time for iff:', timeIff);
console.log('time for and:', timeAnd);
console.log('time for len:', timeLen);
















