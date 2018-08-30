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
 function $0(x) {
  x = x | 0;
  var i64toi32_i32$1 = 0, i64toi32_i32$0 = 0;
  i64toi32_i32$1 = x;
  i64toi32_i32$0 = i64toi32_i32$1 >> 31 | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $1(x) {
  x = x | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return x | 0;
 }
 
 function $2(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  return x | 0;
 }
 
 function $3(x) {
  x = Math_fround(x);
  return ~~x | 0;
 }
 
 function $4(x) {
  x = Math_fround(x);
  return ~~x >>> 0 | 0;
 }
 
 function $5(x) {
  x = +x;
  return ~~x | 0;
 }
 
 function $6(x) {
  x = +x;
  return ~~x >>> 0 | 0;
 }
 
 function $7(x) {
  x = Math_fround(x);
  var i64toi32_i32$0 = Math_fround(0), i64toi32_i32$1 = 0, $4_1 = 0, $5_1 = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = x;
  if (Math_fround(Math_abs(i64toi32_i32$0)) >= Math_fround(1.0)) {
   if (i64toi32_i32$0 > Math_fround(0.0)) $4_1 = ~~Math_fround(Math_min(Math_fround(Math_floor(Math_fround(i64toi32_i32$0 / Math_fround(4294967296.0)))), Math_fround(Math_fround(4294967296.0) - Math_fround(1.0)))) >>> 0; else $4_1 = ~~Math_fround(Math_ceil(Math_fround(Math_fround(i64toi32_i32$0 - Math_fround(~~i64toi32_i32$0 >>> 0 >>> 0)) / Math_fround(4294967296.0)))) >>> 0;
   $5_1 = $4_1;
  } else $5_1 = 0;
  i64toi32_i32$1 = $5_1;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$2 = ~~i64toi32_i32$0 >>> 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$2 | 0;
 }
 
 function $8(x) {
  x = Math_fround(x);
  var i64toi32_i32$0 = Math_fround(0), i64toi32_i32$1 = 0, $4_1 = 0, $5_1 = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = x;
  if (Math_fround(Math_abs(i64toi32_i32$0)) >= Math_fround(1.0)) {
   if (i64toi32_i32$0 > Math_fround(0.0)) $4_1 = ~~Math_fround(Math_min(Math_fround(Math_floor(Math_fround(i64toi32_i32$0 / Math_fround(4294967296.0)))), Math_fround(Math_fround(4294967296.0) - Math_fround(1.0)))) >>> 0; else $4_1 = ~~Math_fround(Math_ceil(Math_fround(Math_fround(i64toi32_i32$0 - Math_fround(~~i64toi32_i32$0 >>> 0 >>> 0)) / Math_fround(4294967296.0)))) >>> 0;
   $5_1 = $4_1;
  } else $5_1 = 0;
  i64toi32_i32$1 = $5_1;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$2 = ~~i64toi32_i32$0 >>> 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$2 | 0;
 }
 
 function $9(x) {
  x = +x;
  var i64toi32_i32$0 = 0.0, i64toi32_i32$1 = 0, $4_1 = 0, $5_1 = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = x;
  if (Math_abs(i64toi32_i32$0) >= 1.0) {
   if (i64toi32_i32$0 > 0.0) $4_1 = ~~Math_min(Math_floor(i64toi32_i32$0 / 4294967296.0), 4294967296.0 - 1.0) >>> 0; else $4_1 = ~~Math_ceil((i64toi32_i32$0 - +(~~i64toi32_i32$0 >>> 0 >>> 0)) / 4294967296.0) >>> 0;
   $5_1 = $4_1;
  } else $5_1 = 0;
  i64toi32_i32$1 = $5_1;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$2 = ~~i64toi32_i32$0 >>> 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$2 | 0;
 }
 
 function $10(x) {
  x = +x;
  var i64toi32_i32$0 = 0.0, i64toi32_i32$1 = 0, $4_1 = 0, $5_1 = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = x;
  if (Math_abs(i64toi32_i32$0) >= 1.0) {
   if (i64toi32_i32$0 > 0.0) $4_1 = ~~Math_min(Math_floor(i64toi32_i32$0 / 4294967296.0), 4294967296.0 - 1.0) >>> 0; else $4_1 = ~~Math_ceil((i64toi32_i32$0 - +(~~i64toi32_i32$0 >>> 0 >>> 0)) / 4294967296.0) >>> 0;
   $5_1 = $4_1;
  } else $5_1 = 0;
  i64toi32_i32$1 = $5_1;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$2 = ~~i64toi32_i32$0 >>> 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$2 | 0;
 }
 
 function $11(x) {
  x = x | 0;
  return Math_fround(Math_fround(x | 0));
 }
 
 function $12(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  return Math_fround(Math_fround(+(x >>> 0) + 4294967296.0 * +(i64toi32_i32$0 | 0)));
 }
 
 function $13(x) {
  x = x | 0;
  return +(+(x | 0));
 }
 
 function $14(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  return +(+(x >>> 0) + 4294967296.0 * +(i64toi32_i32$0 | 0));
 }
 
 function $15(x) {
  x = x | 0;
  return Math_fround(Math_fround(x >>> 0));
 }
 
 function $16(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  return Math_fround(Math_fround(+(x >>> 0) + 4294967296.0 * +(i64toi32_i32$0 >>> 0)));
 }
 
 function $17(x) {
  x = x | 0;
  return +(+(x >>> 0));
 }
 
 function $18(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  return +(+(x >>> 0) + 4294967296.0 * +(i64toi32_i32$0 >>> 0));
 }
 
 function $19(x) {
  x = Math_fround(x);
  return +(+x);
 }
 
 function $20(x) {
  x = +x;
  return Math_fround(Math_fround(x));
 }
 
 function $21(x) {
  x = x | 0;
  return Math_fround((HEAP32[0] = x, HEAPF32[0]));
 }
 
 function $22(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0, wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  wasm2js_i32$0 = 0;
  wasm2js_i32$1 = x;
  HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
  wasm2js_i32$0 = 0;
  wasm2js_i32$1 = i64toi32_i32$0;
  HEAP32[(wasm2js_i32$0 + 4 | 0) >> 2] = wasm2js_i32$1;
  return +(+HEAPF64[0 >> 3]);
 }
 
 function $23(x) {
  x = Math_fround(x);
  return (HEAPF32[0] = x, HEAP32[0] | 0) | 0;
 }
 
 function $24(x) {
  x = +x;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = x;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 return {
  i64_extend_s_i32: $0, 
  i64_extend_u_i32: $1, 
  i32_wrap_i64: $2, 
  i32_trunc_s_f32: $3, 
  i32_trunc_u_f32: $4, 
  i32_trunc_s_f64: $5, 
  i32_trunc_u_f64: $6, 
  i64_trunc_s_f32: $7, 
  i64_trunc_u_f32: $8, 
  i64_trunc_s_f64: $9, 
  i64_trunc_u_f64: $10, 
  f32_convert_s_i32: $11, 
  f32_convert_s_i64: $12, 
  f64_convert_s_i32: $13, 
  f64_convert_s_i64: $14, 
  f32_convert_u_i32: $15, 
  f32_convert_u_i64: $16, 
  f64_convert_u_i32: $17, 
  f64_convert_u_i64: $18, 
  f64_promote_f32: $19, 
  f32_demote_f64: $20, 
  f32_reinterpret_i32: $21, 
  f64_reinterpret_i64: $22, 
  i32_reinterpret_f32: $23, 
  i64_reinterpret_f64: $24
 };
}

const memasmFunc = new ArrayBuffer(65536);
const retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export const i64_extend_s_i32 = retasmFunc.i64_extend_s_i32;
export const i64_extend_u_i32 = retasmFunc.i64_extend_u_i32;
export const i32_wrap_i64 = retasmFunc.i32_wrap_i64;
export const i32_trunc_s_f32 = retasmFunc.i32_trunc_s_f32;
export const i32_trunc_u_f32 = retasmFunc.i32_trunc_u_f32;
export const i32_trunc_s_f64 = retasmFunc.i32_trunc_s_f64;
export const i32_trunc_u_f64 = retasmFunc.i32_trunc_u_f64;
export const i64_trunc_s_f32 = retasmFunc.i64_trunc_s_f32;
export const i64_trunc_u_f32 = retasmFunc.i64_trunc_u_f32;
export const i64_trunc_s_f64 = retasmFunc.i64_trunc_s_f64;
export const i64_trunc_u_f64 = retasmFunc.i64_trunc_u_f64;
export const f32_convert_s_i32 = retasmFunc.f32_convert_s_i32;
export const f32_convert_s_i64 = retasmFunc.f32_convert_s_i64;
export const f64_convert_s_i32 = retasmFunc.f64_convert_s_i32;
export const f64_convert_s_i64 = retasmFunc.f64_convert_s_i64;
export const f32_convert_u_i32 = retasmFunc.f32_convert_u_i32;
export const f32_convert_u_i64 = retasmFunc.f32_convert_u_i64;
export const f64_convert_u_i32 = retasmFunc.f64_convert_u_i32;
export const f64_convert_u_i64 = retasmFunc.f64_convert_u_i64;
export const f64_promote_f32 = retasmFunc.f64_promote_f32;
export const f32_demote_f64 = retasmFunc.f32_demote_f64;
export const f32_reinterpret_i32 = retasmFunc.f32_reinterpret_i32;
export const f64_reinterpret_i64 = retasmFunc.f64_reinterpret_i64;
export const i32_reinterpret_f32 = retasmFunc.i32_reinterpret_f32;
export const i64_reinterpret_f64 = retasmFunc.i64_reinterpret_f64;
