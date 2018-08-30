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
  x = Math_fround(x);
  y = Math_fround(y);
  return Math_fround(Math_fround(x + y));
 }
 
 function $1(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return Math_fround(Math_fround(x - y));
 }
 
 function $2(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return Math_fround(Math_fround(x * y));
 }
 
 function $3(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return Math_fround(Math_fround(x / y));
 }
 
 function $4(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(Math_sqrt(x)));
 }
 
 function $5(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return Math_fround(Math_fround(Math_min(x, y)));
 }
 
 function $6(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return Math_fround(Math_fround(Math_max(x, y)));
 }
 
 function $7(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(Math_ceil(x)));
 }
 
 function $8(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(Math_floor(x)));
 }
 
 function $9(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(__wasm_trunc_f32(Math_fround(x))));
 }
 
 function $10(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(__wasm_nearest_f32(Math_fround(x))));
 }
 
 function $11(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(Math_abs(x)));
 }
 
 function $12(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(-x));
 }
 
 function $13(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return Math_fround((HEAP32[0] = (HEAPF32[0] = x, HEAP32[0] | 0) & 2147483647 | 0 | ((HEAPF32[0] = y, HEAP32[0] | 0) & 2147483648 | 0) | 0, HEAPF32[0]));
 }
 
 function __wasm_nearest_f32(var$0) {
  var$0 = Math_fround(var$0);
  var var$1 = Math_fround(0), var$2 = Math_fround(0), wasm2js_f32$0 = Math_fround(0), wasm2js_f32$1 = Math_fround(0), wasm2js_i32$0 = 0;
  var$1 = Math_fround(Math_floor(var$0));
  var$2 = Math_fround(var$0 - var$1);
  if ((var$2 < Math_fround(.5) | 0) == (0 | 0)) block : {
   var$0 = Math_fround(Math_ceil(var$0));
   if (var$2 > Math_fround(.5)) return Math_fround(var$0);
   var$2 = Math_fround(var$1 * Math_fround(.5));
   var$1 = (wasm2js_f32$0 = var$1, wasm2js_f32$1 = var$0, wasm2js_i32$0 = Math_fround(var$2 - Math_fround(Math_floor(var$2))) == Math_fround(0.0), wasm2js_i32$0 ? wasm2js_f32$0 : wasm2js_f32$1);
  };
  return Math_fround(var$1);
 }
 
 function __wasm_trunc_f32(var$0) {
  var$0 = Math_fround(var$0);
  var wasm2js_f32$0 = Math_fround(0), wasm2js_f32$1 = Math_fround(0), wasm2js_i32$0 = 0;
  return Math_fround((wasm2js_f32$0 = Math_fround(Math_ceil(var$0)), wasm2js_f32$1 = Math_fround(Math_floor(var$0)), wasm2js_i32$0 = var$0 < Math_fround(0.0), wasm2js_i32$0 ? wasm2js_f32$0 : wasm2js_f32$1));
 }
 
 return {
  add: $0, 
  sub: $1, 
  mul: $2, 
  div: $3, 
  sqrt: $4, 
  min: $5, 
  max: $6, 
  ceil: $7, 
  floor: $8, 
  trunc: $9, 
  nearest: $10, 
  abs: $11, 
  neg: $12, 
  copysign: $13
 };
}

const memasmFunc = new ArrayBuffer(65536);
const retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export const add = retasmFunc.add;
export const sub = retasmFunc.sub;
export const mul = retasmFunc.mul;
export const div = retasmFunc.div;
export const sqrt = retasmFunc.sqrt;
export const min = retasmFunc.min;
export const max = retasmFunc.max;
export const ceil = retasmFunc.ceil;
export const floor = retasmFunc.floor;
export const trunc = retasmFunc.trunc;
export const nearest = retasmFunc.nearest;
export const abs = retasmFunc.abs;
export const neg = retasmFunc.neg;
export const copysign = retasmFunc.copysign;
