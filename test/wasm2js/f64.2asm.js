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
  return +(x + y);
 }
 
 function $1(x, y) {
  x = +x;
  y = +y;
  return +(x - y);
 }
 
 function $2(x, y) {
  x = +x;
  y = +y;
  return +(x * y);
 }
 
 function $3(x, y) {
  x = +x;
  y = +y;
  return +(x / y);
 }
 
 function $4(x) {
  x = +x;
  return +Math_sqrt(x);
 }
 
 function $5(x, y) {
  x = +x;
  y = +y;
  return +Math_min(x, y);
 }
 
 function $6(x, y) {
  x = +x;
  y = +y;
  return +Math_max(x, y);
 }
 
 function $7(x) {
  x = +x;
  return +Math_ceil(x);
 }
 
 function $8(x) {
  x = +x;
  return +Math_floor(x);
 }
 
 function $9(x) {
  x = +x;
  return +(+__wasm_trunc_f64(+x));
 }
 
 function $10(x) {
  x = +x;
  return +(+__wasm_nearest_f64(+x));
 }
 
 function $11(x) {
  x = +x;
  return +Math_abs(x);
 }
 
 function $12(x) {
  x = +x;
  return +-x;
 }
 
 function $13(x, y) {
  x = +x;
  y = +y;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, $4_1 = 0, $4$hi = 0, $7_1 = 0, $7$hi = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0, wasm2js_i32$1 = 0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = x;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$2 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$1 = 2147483647;
  i64toi32_i32$3 = 4294967295;
  i64toi32_i32$1 = i64toi32_i32$0 & i64toi32_i32$1 | 0;
  $4_1 = i64toi32_i32$2 & i64toi32_i32$3 | 0;
  $4$hi = i64toi32_i32$1;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = y;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$1 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$0 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$2 = 2147483648;
  i64toi32_i32$3 = 0;
  i64toi32_i32$2 = i64toi32_i32$1 & i64toi32_i32$2 | 0;
  $7_1 = i64toi32_i32$0 & i64toi32_i32$3 | 0;
  $7$hi = i64toi32_i32$2;
  i64toi32_i32$2 = $4$hi;
  i64toi32_i32$1 = $4_1;
  i64toi32_i32$0 = $7$hi;
  i64toi32_i32$3 = $7_1;
  i64toi32_i32$0 = i64toi32_i32$2 | i64toi32_i32$0 | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  wasm2js_i32$0 = 0;
  wasm2js_i32$1 = i64toi32_i32$1 | i64toi32_i32$3 | 0;
  HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
  wasm2js_i32$0 = 0;
  wasm2js_i32$1 = i64toi32_i32$0;
  HEAP32[(wasm2js_i32$0 + 4 | 0) >> 2] = wasm2js_i32$1;
  return +(+HEAPF64[0 >> 3]);
 }
 
 function __wasm_nearest_f64(var$0) {
  var$0 = +var$0;
  var var$1 = 0.0, var$2 = 0.0, wasm2js_f64$0 = 0.0, wasm2js_f64$1 = 0.0, wasm2js_i32$0 = 0;
  var$1 = Math_floor(var$0);
  var$2 = var$0 - var$1;
  if ((var$2 < .5 | 0) == (0 | 0)) block : {
   var$0 = Math_ceil(var$0);
   if (var$2 > .5) return +var$0;
   var$2 = var$1 * .5;
   var$1 = (wasm2js_f64$0 = var$1, wasm2js_f64$1 = var$0, wasm2js_i32$0 = var$2 - Math_floor(var$2) == 0.0, wasm2js_i32$0 ? wasm2js_f64$0 : wasm2js_f64$1);
  };
  return +var$1;
 }
 
 function __wasm_trunc_f64(var$0) {
  var$0 = +var$0;
  var wasm2js_f64$0 = 0.0, wasm2js_f64$1 = 0.0, wasm2js_i32$0 = 0;
  return +(wasm2js_f64$0 = Math_ceil(var$0), wasm2js_f64$1 = Math_floor(var$0), wasm2js_i32$0 = var$0 < 0.0, wasm2js_i32$0 ? wasm2js_f64$0 : wasm2js_f64$1);
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
