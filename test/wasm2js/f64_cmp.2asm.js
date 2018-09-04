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
 var i64toi32_i32$HIGH_BITS = 0;
 function $0(x, y) {
  x = +x;
  y = +y;
  return x == y | 0;
 }
 
 function $1(x, y) {
  x = +x;
  y = +y;
  return x != y | 0;
 }
 
 function $2(x, y) {
  x = +x;
  y = +y;
  return x < y | 0;
 }
 
 function $3(x, y) {
  x = +x;
  y = +y;
  return x <= y | 0;
 }
 
 function $4(x, y) {
  x = +x;
  y = +y;
  return x > y | 0;
 }
 
 function $5(x, y) {
  x = +x;
  y = +y;
  return x >= y | 0;
 }
 
 return {
  eq: $0, 
  ne: $1, 
  lt: $2, 
  le: $3, 
  gt: $4, 
  ge: $5
 };
}

const memasmFunc = new ArrayBuffer(65536);
const retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export const eq = retasmFunc.eq;
export const ne = retasmFunc.ne;
export const lt = retasmFunc.lt;
export const le = retasmFunc.le;
export const gt = retasmFunc.gt;
export const ge = retasmFunc.ge;
