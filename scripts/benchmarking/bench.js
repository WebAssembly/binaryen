
// Benchmarking script. This runs on compiled bench.wat and prints out timings.
//
// Usage:
//
//  * wasm-opt scripts/benchmarking/bench.wat -all --inline-functions-with-loops --always-inline-max-function-size=1000 --inlining --precompute-propagate --optimize-instructions --inlining --simplify-locals --coalesce-locals --vacuum --remove-unused-module-elements -o bench.wasm -g
//  * Inspect the optimized wasm to see that inlining etc. worked properly
//    (we rely on inlining to let us write bench.wat in a short/simple form, and
//    we use very specific optimizations in order to not optimize away the
//    differences we care about).
//  * d8 bench.js -- bench.wasm
//    etc.
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
  makeBenchmarker('iff-both'),
  makeBenchmarker('or'),
  makeBenchmarker('iff-either'),
  makeBenchmarker('select'),
  makeBenchmarker('iff-nextor'),
  makeBenchmarker('select-three'),
  makeBenchmarker('iff-three'),
];

// We'll call the benchmark functions in random orders. Random orders avoid any
// interaction between the benchmarks from causing bias in the results.
//
// An alternative to randomly ordering the benchmarks in each iteration would be
// to fully benchmark one, then do the next, so there are large amounts of time
// between them, but that also allows them to become more like microbenchmarks
// where the branch predictor etc. might display very favorable behavior.
// Interleaving them makes things slightly more realistic.
//
// If we have too many benchmarks then eventually computing all orders ahead of
// time will not work, but so long as we can, it is faster this way rather than
// to compute random orders on the fly as we go.
function makeOrders(prefix) {
  // Given a prefix of an order, like [] or [0, 3], return all the possible
  // orders beginning with that prefix.

  // We cannot repeat anything already seen.
  const seen = new Set();
  for (var x of prefix) {
    seen.add(x);
  }

  // Starting from the prefix, extend it by one item in all valid ways.
  const extensions = [];
  for (var i = 0; i < benchmarkers.length; i++) {
    if (!seen.has(i)) {
      extensions.push(prefix.concat(i));
    }
  }

  if (prefix.length == benchmarkers.length - 1) {
    // The extensions are complete orders; stop the recursion.
    return extensions;
  }

  // Recursively generate the full orders.
  const ret = [];
  for (var extension of extensions) {
    for (var order of makeOrders(extension)) {
      ret.push(order);
    }
  }
  return ret;
}

const orders = makeOrders([]);

// Params.
const M = 10000000;
const N = 100;

console.log('iters       :', M);
console.log('list len    :', N);
console.log('benchmarkers:', benchmarkers.length);
console.log('orderings   :', orders.length);

// Create a long linked list of objects of both type $A and $B.
var list = null;
for (var i = 0; i < N; i++) {
  list = Math.random() < 0.5 ? exports.makeA(list) : exports.makeB(list);
}

console.log('benchmarking...');

// Call the benchmark functions.

for (var i = 0; i < M; i++) {
  const order = orders[Math.floor(Math.random() * orders.length)];
  for (var k = 0; k < benchmarkers.length; k++) {
    const benchmarker = benchmarkers[order[k]];
    const start = performance.now();
    const result = benchmarker.func(list);
    benchmarker.time += performance.now() - start;
    benchmarker.sum += result;
    benchmarker.iters++;
  }
}

for (var benchmarker of benchmarkers) {
  if (benchmarker.iters != M) {
    throw 'wat';
  }
}

console.log();
for (var benchmarker of benchmarkers) {
  console.log(`${benchmarker.name} time: \t${benchmarker.time}`)
}
console.log();
for (var benchmarker of benchmarkers) {
  console.log(`${benchmarker.name} mean sum: \t${benchmarker.sum / M}`)
}

