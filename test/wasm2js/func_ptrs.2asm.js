import { print } from 'spectest';
function asmFunc(global, env, buffer) {
 "use asm";
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
 var print = env.print;
 var i64toi32_i32$HIGH_BITS = 0;
 function $1() {
  
 }
 
 function $2() {
  
 }
 
 function $3() {
  return 13 | 0;
 }
 
 function $4($0) {
  $0 = $0 | 0;
  return $0 + 1 | 0 | 0;
 }
 
 function $5(a) {
  a = a | 0;
  return a - 2 | 0 | 0;
 }
 
 function $6($0) {
  $0 = $0 | 0;
  print($0 | 0);
 }
 
 return {
  one: $3, 
  two: $4, 
  three: $5, 
  four: $6
 };
}

const memasmFunc = new ArrayBuffer(65536);
const retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },print},memasmFunc);
export const one = retasmFunc.one;
export const two = retasmFunc.two;
export const three = retasmFunc.three;
export const four = retasmFunc.four;
