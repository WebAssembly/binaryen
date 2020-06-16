import { wasm2js_atomic_wait_i32 } from 'env';

function asmFunc(global, env, buffer) {
 var HEAP8 = new global.Int8Array(buffer);
 var HEAP16 = new global.Int16Array(buffer);
 var HEAP32 = new global.Int32Array(buffer);
 var HEAPU8 = new global.Uint8Array(buffer);
 var HEAPU16 = new global.Uint16Array(buffer);
 var HEAPU32 = new global.Uint32Array(buffer);
 var HEAPF32 = new global.Float32Array(buffer);
 var HEAPF64 = new global.Float64Array(buffer);
 var Math_imul = global.Math.imul;
 var Math_fround = global.Math.fround;
 var Math_abs = global.Math.abs;
 var Math_clz32 = global.Math.clz32;
 var Math_min = global.Math.min;
 var Math_max = global.Math.max;
 var Math_floor = global.Math.floor;
 var Math_ceil = global.Math.ceil;
 var Math_sqrt = global.Math.sqrt;
 var abort = env.abort;
 var nan = global.NaN;
 var infinity = global.Infinity;
 var wasm2js_atomic_wait_i32 = env.wasm2js_atomic_wait_i32;
 function $0() {
  Atomics.compareExchange(HEAP8, 1024, 1, 2) | 0;
  Atomics.compareExchange(HEAP16, 1024 >> 1, 1, 2) | 0;
  Atomics.compareExchange(HEAP32, 1024 >> 2, 1, 2) | 0;
  Atomics.load(HEAPU8, 1028 >> 0) | 0;
  Atomics.load(HEAPU16, 1028 >> 1) | 0;
  Atomics.load(HEAP32, 1028 >> 2) | 0;
  Atomics.store(HEAP32, 100 >> 2, 200);
  wasm2js_atomic_wait_i32(4 | 0, 8 | 0, -1 | 0, -1 | 0) | 0;
 }
 
 var FUNCTION_TABLE = [];
 function __wasm_memory_size() {
  return buffer.byteLength / 65536 | 0;
 }
 
 return {
  "atomic_cmpxchg": $0
 };
}

var memasmFunc = new ArrayBuffer(16777216);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },wasm2js_atomic_wait_i32},memasmFunc);
export var atomic_cmpxchg = retasmFunc.atomic_cmpxchg;
