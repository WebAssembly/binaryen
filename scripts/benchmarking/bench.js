
// Usage:
//
//  * wasm-opt bench.wat -o bench.wasm -all --inline-functions-with-loops --always-inline-max-function-size=1000 --inlining --precompute-propagate --optimize-instructions --inlining --simplify-locals -O3
//  * Inspect the optimized wasm to see that inlining etc. worked properly
//    (we rely on inlining to let us write bench.wat in a short/simple form, and
//    we use very specific optimizations in order to not optimize away the
//    differences we care about).
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

// Create the benchmarkers.
function makeBenchmarker(name) {
  return {
    name: name,
    func: exports[name],
    time: 0,
    sum: 0,
    iters: 0,
  };
}

const benchmarkers = [
  makeBenchmarker('len'),
  makeBenchmarker('and'),
  makeBenchmarker('iff'),
];

// Create a long linked list of objects of both type $A and $B.
const N = 100;
var list = null;
for (var i = 0; i < N; i++) {
  list = Math.random() < 0.5 ? exports.makeA(list) : exports.makeB(list);
}

// We'll call the benchmark functions in random orders.
const orders = [
  [0, 1, 2],
  [0, 2, 1],
  [1, 0, 2],
  [1, 2, 0],
  [2, 0, 1],
  [2, 1, 0],
];

// Call the benchmark functions.
const M = 10000000;

for (var i = 0; i < M; i++) {
  const order = orders[Math.floor(Math.random() * orders.length)];
  for (var k = 0; k < 3; k++) {
    const benchmarker = benchmarkers[order[k]];
    const start = performance.now();
    const result = benchmarker.func(list);
    benchmarker.time += performance.now() - start;
    benchmarker.sum += result;
    benchmarker.iters++;
  }
}

console.log('iters   :', M);
console.log('list len:', N);
console.log();
for (var benchmarker of benchmarkers) {
  console.log(`${benchmarker.name} time: ${benchmarker.time}`)
}
console.log();
for (var benchmarker of benchmarkers) {
  console.log(`${benchmarker.name} mean sum: ${benchmarker.sum / M}`)
}
console.log();
for (var benchmarker of benchmarkers) {
  console.log(`${benchmarker.name} iters: ${benchmarker.iters}`)
}

// TODO: the othre patterns too in o.diff on remote!!!1

