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
 
 function $5(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(Math_abs(x)));
 }
 
 function $6(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(-x));
 }
 
 function $7(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return Math_fround((HEAP32[0] = (HEAPF32[0] = x, HEAP32[0] | 0) & 2147483647 | 0 | ((HEAPF32[0] = y, HEAP32[0] | 0) & 2147483648 | 0) | 0, HEAPF32[0]));
 }
 
 function $8(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(Math_ceil(x)));
 }
 
 function $9(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(Math_floor(x)));
 }
 
 function $10(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(__wasm_trunc_f32(Math_fround(x))));
 }
 
 function $11(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(__wasm_nearest_f32(Math_fround(x))));
 }
 
 function $12(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return Math_fround(Math_fround(Math_min(x, y)));
 }
 
 function $13(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return Math_fround(Math_fround(Math_max(x, y)));
 }
 
 function $14(x, y) {
  x = +x;
  y = +y;
  return +(x + y);
 }
 
 function $15(x, y) {
  x = +x;
  y = +y;
  return +(x - y);
 }
 
 function $16(x, y) {
  x = +x;
  y = +y;
  return +(x * y);
 }
 
 function $17(x, y) {
  x = +x;
  y = +y;
  return +(x / y);
 }
 
 function $18(x) {
  x = +x;
  return +Math_sqrt(x);
 }
 
 function $19(x) {
  x = +x;
  return +Math_abs(x);
 }
 
 function $20(x) {
  x = +x;
  return +-x;
 }
 
 function $21(x, y) {
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
 
 function $22(x) {
  x = +x;
  return +Math_ceil(x);
 }
 
 function $23(x) {
  x = +x;
  return +Math_floor(x);
 }
 
 function $24(x) {
  x = +x;
  return +(+__wasm_trunc_f64(+x));
 }
 
 function $25(x) {
  x = +x;
  return +(+__wasm_nearest_f64(+x));
 }
 
 function $26(x, y) {
  x = +x;
  y = +y;
  return +Math_min(x, y);
 }
 
 function $27(x, y) {
  x = +x;
  y = +y;
  return +Math_max(x, y);
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
 
 function __wasm_trunc_f32(var$0) {
  var$0 = Math_fround(var$0);
  var wasm2js_f32$0 = Math_fround(0), wasm2js_f32$1 = Math_fround(0), wasm2js_i32$0 = 0;
  return Math_fround((wasm2js_f32$0 = Math_fround(Math_ceil(var$0)), wasm2js_f32$1 = Math_fround(Math_floor(var$0)), wasm2js_i32$0 = var$0 < Math_fround(0.0), wasm2js_i32$0 ? wasm2js_f32$0 : wasm2js_f32$1));
 }
 
 function __wasm_trunc_f64(var$0) {
  var$0 = +var$0;
  var wasm2js_f64$0 = 0.0, wasm2js_f64$1 = 0.0, wasm2js_i32$0 = 0;
  return +(wasm2js_f64$0 = Math_ceil(var$0), wasm2js_f64$1 = Math_floor(var$0), wasm2js_i32$0 = var$0 < 0.0, wasm2js_i32$0 ? wasm2js_f64$0 : wasm2js_f64$1);
 }
 
 return {
  f32_add: $0, 
  f32_sub: $1, 
  f32_mul: $2, 
  f32_div: $3, 
  f32_sqrt: $4, 
  f32_abs: $5, 
  f32_neg: $6, 
  f32_copysign: $7, 
  f32_ceil: $8, 
  f32_floor: $9, 
  f32_trunc: $10, 
  f32_nearest: $11, 
  f32_min: $12, 
  f32_max: $13, 
  f64_add: $14, 
  f64_sub: $15, 
  f64_mul: $16, 
  f64_div: $17, 
  f64_sqrt: $18, 
  f64_abs: $19, 
  f64_neg: $20, 
  f64_copysign: $21, 
  f64_ceil: $22, 
  f64_floor: $23, 
  f64_trunc: $24, 
  f64_nearest: $25, 
  f64_min: $26, 
  f64_max: $27
 };
}

const memasmFunc = new ArrayBuffer(65536);
const retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export const f32_add = retasmFunc.f32_add;
export const f32_sub = retasmFunc.f32_sub;
export const f32_mul = retasmFunc.f32_mul;
export const f32_div = retasmFunc.f32_div;
export const f32_sqrt = retasmFunc.f32_sqrt;
export const f32_abs = retasmFunc.f32_abs;
export const f32_neg = retasmFunc.f32_neg;
export const f32_copysign = retasmFunc.f32_copysign;
export const f32_ceil = retasmFunc.f32_ceil;
export const f32_floor = retasmFunc.f32_floor;
export const f32_trunc = retasmFunc.f32_trunc;
export const f32_nearest = retasmFunc.f32_nearest;
export const f32_min = retasmFunc.f32_min;
export const f32_max = retasmFunc.f32_max;
export const f64_add = retasmFunc.f64_add;
export const f64_sub = retasmFunc.f64_sub;
export const f64_mul = retasmFunc.f64_mul;
export const f64_div = retasmFunc.f64_div;
export const f64_sqrt = retasmFunc.f64_sqrt;
export const f64_abs = retasmFunc.f64_abs;
export const f64_neg = retasmFunc.f64_neg;
export const f64_copysign = retasmFunc.f64_copysign;
export const f64_ceil = retasmFunc.f64_ceil;
export const f64_floor = retasmFunc.f64_floor;
export const f64_trunc = retasmFunc.f64_trunc;
export const f64_nearest = retasmFunc.f64_nearest;
export const f64_min = retasmFunc.f64_min;
export const f64_max = retasmFunc.f64_max;
