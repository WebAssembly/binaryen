// Code that goes after the flush() function that autobatch generates. This
// instantiates and runs the code.

imports.autobatch = {
  flush: flush,
};

let instance = new WebAssembly.Instance(mod, imports);

let buffer = instance.exports.mem.buffer;
HEAP32 = new Int32Array(buffer);
HEAP64 = new BigInt64Array(buffer);
HEAPF32 = new Float32Array(buffer);
HEAPF64 = new Float64Array(buffer);

console.log('calling caller');
let result = instance.exports.caller();
console.log(`result: ${result}`);

console.log('test complete.');

