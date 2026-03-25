// Code that goes after the flush() function that autobatch generates. This
// instantiates and runs the code.

imports.autobatch = {
  flush: flush,
};

let instance = new WebAssembly.Instance(mod, imports);

let mem = instance.exports.mem;
HEAP32 = new Int32Array(mem);
HEAP64 = new BigInt64Array(mem);
HEAPF32 = new Float32Array(mem);
HEAPF64 = new Float64Array(mem);

console.log('calling caller');
let result = instance.exports.caller();
console.log(`result: ${result}`);

console.log('test complete.');

