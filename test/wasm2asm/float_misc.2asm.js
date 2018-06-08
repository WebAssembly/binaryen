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
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, $4_1 = 0, $4$hi = 0, $7_1 = 0, $7$hi = 0, wasm2asm_i32$0 = 0, wasm2asm_f64$0 = 0.0, wasm2asm_i32$1 = 0;
  wasm2asm_i32$0 = 0;
  wasm2asm_f64$0 = x;
  HEAPF64[wasm2asm_i32$0 >> 3] = wasm2asm_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$2 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$1 = 2147483647;
  i64toi32_i32$3 = 4294967295;
  i64toi32_i32$1 = i64toi32_i32$0 & i64toi32_i32$1 | 0;
  $4_1 = i64toi32_i32$2 & i64toi32_i32$3 | 0;
  $4$hi = i64toi32_i32$1;
  wasm2asm_i32$0 = 0;
  wasm2asm_f64$0 = y;
  HEAPF64[wasm2asm_i32$0 >> 3] = wasm2asm_f64$0;
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
  wasm2asm_i32$0 = 0;
  wasm2asm_i32$1 = i64toi32_i32$1 | i64toi32_i32$3 | 0;
  HEAP32[wasm2asm_i32$0 >> 2] = wasm2asm_i32$1;
  wasm2asm_i32$0 = 0;
  wasm2asm_i32$1 = i64toi32_i32$0;
  HEAP32[(wasm2asm_i32$0 + 4 | 0) >> 2] = wasm2asm_i32$1;
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
  var var$1 = Math_fround(0), var$2 = Math_fround(0), wasm2asm_f32$0 = Math_fround(0), wasm2asm_f32$1 = Math_fround(0), wasm2asm_i32$0 = 0;
  var$1 = Math_fround(Math_floor(var$0));
  var$2 = Math_fround(var$0 - var$1);
  if ((var$2 < Math_fround(.5) | 0) == (0 | 0)) block : {
   var$0 = Math_fround(Math_ceil(var$0));
   if (var$2 > Math_fround(.5)) return Math_fround(var$0);
   var$2 = Math_fround(var$1 * Math_fround(.5));
   var$1 = (wasm2asm_f32$0 = var$1, wasm2asm_f32$1 = var$0, wasm2asm_i32$0 = Math_fround(var$2 - Math_fround(Math_floor(var$2))) == Math_fround(0.0), wasm2asm_i32$0 ? wasm2asm_f32$0 : wasm2asm_f32$1);
  };
  return Math_fround(var$1);
 }
 
 function __wasm_nearest_f64(var$0) {
  var$0 = +var$0;
  var var$1 = 0.0, var$2 = 0.0, wasm2asm_f64$0 = 0.0, wasm2asm_f64$1 = 0.0, wasm2asm_i32$0 = 0;
  var$1 = Math_floor(var$0);
  var$2 = var$0 - var$1;
  if ((var$2 < .5 | 0) == (0 | 0)) block : {
   var$0 = Math_ceil(var$0);
   if (var$2 > .5) return +var$0;
   var$2 = var$1 * .5;
   var$1 = (wasm2asm_f64$0 = var$1, wasm2asm_f64$1 = var$0, wasm2asm_i32$0 = var$2 - Math_floor(var$2) == 0.0, wasm2asm_i32$0 ? wasm2asm_f64$0 : wasm2asm_f64$1);
  };
  return +var$1;
 }
 
 function __wasm_trunc_f32(var$0) {
  var$0 = Math_fround(var$0);
  var wasm2asm_f32$0 = Math_fround(0), wasm2asm_f32$1 = Math_fround(0), wasm2asm_i32$0 = 0;
  return Math_fround((wasm2asm_f32$0 = Math_fround(Math_ceil(var$0)), wasm2asm_f32$1 = Math_fround(Math_floor(var$0)), wasm2asm_i32$0 = var$0 < Math_fround(0.0), wasm2asm_i32$0 ? wasm2asm_f32$0 : wasm2asm_f32$1));
 }
 
 function __wasm_trunc_f64(var$0) {
  var$0 = +var$0;
  var wasm2asm_f64$0 = 0.0, wasm2asm_f64$1 = 0.0, wasm2asm_i32$0 = 0;
  return +(wasm2asm_f64$0 = Math_ceil(var$0), wasm2asm_f64$1 = Math_floor(var$0), wasm2asm_i32$0 = var$0 < 0.0, wasm2asm_i32$0 ? wasm2asm_f64$0 : wasm2asm_f64$1);
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

