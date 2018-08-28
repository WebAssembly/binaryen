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
 function i16_store_little(address, value) {
  address = address | 0;
  value = value | 0;
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  wasm2js_i32$0 = address;
  wasm2js_i32$1 = value;
  HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
  wasm2js_i32$0 = address + 1 | 0;
  wasm2js_i32$1 = value >>> 8 | 0;
  HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
 }
 
 function i32_store_little(address, value) {
  address = address | 0;
  value = value | 0;
  i16_store_little(address | 0, value | 0);
  i16_store_little(address + 2 | 0 | 0, value >>> 16 | 0 | 0);
 }
 
 function i64_store_little(address, value, value$hi) {
  address = address | 0;
  value = value | 0;
  value$hi = value$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $9_1 = 0, $6_1 = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = value$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i32_store_little(address | 0, value | 0);
  $6_1 = address + 4 | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$2 = value;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = 0;
   $9_1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $9_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  i64toi32_i32$1 = i64toi32_i32$1;
  i32_store_little($6_1 | 0, $9_1 | 0);
 }
 
 function i16_load_little(address) {
  address = address | 0;
  return HEAPU8[address >> 0] | 0 | ((HEAPU8[(address + 1 | 0) >> 0] | 0) << 8 | 0) | 0 | 0;
 }
 
 function i32_load_little(address) {
  address = address | 0;
  return i16_load_little(address | 0) | 0 | ((i16_load_little(address + 2 | 0 | 0) | 0) << 16 | 0) | 0 | 0;
 }
 
 function i64_load_little(address) {
  address = address | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$2 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $9_1 = 0, $3 = 0, $3$hi = 0, $8$hi = 0;
  i64toi32_i32$0 = 0;
  $3 = i32_load_little(address | 0) | 0;
  $3$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$2 = i32_load_little(address + 4 | 0 | 0) | 0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $9_1 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $9_1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $8$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $3$hi;
  i64toi32_i32$0 = $3;
  i64toi32_i32$2 = $8$hi;
  i64toi32_i32$3 = $9_1;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$2 = i64toi32_i32$2;
  i64toi32_i32$0 = i64toi32_i32$0 | i64toi32_i32$3 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$2;
  return i64toi32_i32$0 | 0;
 }
 
 function $6(value) {
  value = value | 0;
  i16_store_little(0 | 0, value | 0);
  return HEAP16[0 >> 1] | 0 | 0;
 }
 
 function $7(value) {
  value = value | 0;
  i16_store_little(0 | 0, value | 0);
  return HEAPU16[0 >> 1] | 0 | 0;
 }
 
 function $8(value) {
  value = value | 0;
  i32_store_little(0 | 0, value | 0);
  return HEAPU32[0 >> 2] | 0 | 0;
 }
 
 function $9(value, value$hi) {
  value = value | 0;
  value$hi = value$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = value$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i16_store_little(0 | 0, value | 0);
  i64toi32_i32$0 = HEAP16[0 >> 1] | 0;
  i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $10(value, value$hi) {
  value = value | 0;
  value$hi = value$hi | 0;
  var i64toi32_i32$1 = 0, i64toi32_i32$0 = 0;
  i64toi32_i32$0 = value$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i16_store_little(0 | 0, value | 0);
  i64toi32_i32$0 = HEAPU16[0 >> 1] | 0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $11(value, value$hi) {
  value = value | 0;
  value$hi = value$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = value$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i32_store_little(0 | 0, value | 0);
  i64toi32_i32$0 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $12(value, value$hi) {
  value = value | 0;
  value$hi = value$hi | 0;
  var i64toi32_i32$1 = 0, i64toi32_i32$0 = 0;
  i64toi32_i32$0 = value$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i32_store_little(0 | 0, value | 0);
  i64toi32_i32$0 = HEAPU32[0 >> 2] | 0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $13(value, value$hi) {
  value = value | 0;
  value$hi = value$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$2 = 0, wasm2js_i32$0 = 0;
  i64toi32_i32$0 = value$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64_store_little(0 | 0, value | 0, i64toi32_i32$0 | 0);
  i64toi32_i32$2 = 0;
  i64toi32_i32$0 = HEAPU32[i64toi32_i32$2 >> 2] | 0;
  i64toi32_i32$1 = (wasm2js_i32$0 = i64toi32_i32$2, HEAPU8[(wasm2js_i32$0 + 4 | 0) >> 0] | 0 | 0 | (HEAPU8[(wasm2js_i32$0 + 5 | 0) >> 0] | 0 | 0) << 8 | (HEAPU8[(wasm2js_i32$0 + 6 | 0) >> 0] | 0 | 0) << 16 | (HEAPU8[(wasm2js_i32$0 + 7 | 0) >> 0] | 0 | 0) << 24);
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $14(value) {
  value = Math_fround(value);
  i32_store_little(0 | 0, (HEAPF32[0] = value, HEAP32[0] | 0) | 0);
  return Math_fround(Math_fround(HEAPF32[0 >> 2]));
 }
 
 function $15(value) {
  value = +value;
  var i64toi32_i32$0 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = value;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64_store_little(0 | 0, HEAP32[0 >> 2] | 0 | 0, i64toi32_i32$0 | 0);
  return +(+HEAPF64[0 >> 3]);
 }
 
 function $16(value) {
  value = value | 0;
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  wasm2js_i32$0 = 0;
  wasm2js_i32$1 = value;
  HEAP16[wasm2js_i32$0 >> 1] = wasm2js_i32$1;
  return i16_load_little(0 | 0) | 0 | 0;
 }
 
 function $17(value) {
  value = value | 0;
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  wasm2js_i32$0 = 0;
  wasm2js_i32$1 = value;
  HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
  return i32_load_little(0 | 0) | 0 | 0;
 }
 
 function $18(value, value$hi) {
  value = value | 0;
  value$hi = value$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  i64toi32_i32$0 = value$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  wasm2js_i32$0 = 0;
  wasm2js_i32$1 = value;
  HEAP16[wasm2js_i32$0 >> 1] = wasm2js_i32$1;
  i64toi32_i32$0 = 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = i16_load_little(0 | 0) | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $19(value, value$hi) {
  value = value | 0;
  value$hi = value$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  i64toi32_i32$0 = value$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  wasm2js_i32$0 = 0;
  wasm2js_i32$1 = value;
  HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
  i64toi32_i32$0 = 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = i32_load_little(0 | 0) | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $20(value, value$hi) {
  value = value | 0;
  value$hi = value$hi | 0;
  var i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0, wasm2js_i32$3 = 0;
  i64toi32_i32$0 = value$hi;
  i64toi32_i32$1 = 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  wasm2js_i32$0 = i64toi32_i32$1;
  wasm2js_i32$1 = value;
  HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
  wasm2js_i32$0 = i64toi32_i32$1;
  wasm2js_i32$1 = i64toi32_i32$0;
  (wasm2js_i32$2 = wasm2js_i32$0, wasm2js_i32$3 = wasm2js_i32$1), ((HEAP8[(wasm2js_i32$2 + 4 | 0) >> 0] = wasm2js_i32$3 & 255 | 0, HEAP8[(wasm2js_i32$2 + 5 | 0) >> 0] = (wasm2js_i32$3 >>> 8 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 6 | 0) >> 0] = (wasm2js_i32$3 >>> 16 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 7 | 0) >> 0] = (wasm2js_i32$3 >>> 24 | 0) & 255 | 0;
  i64toi32_i32$0 = i64_load_little(0 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $21(value) {
  value = Math_fround(value);
  var wasm2js_i32$0 = 0, wasm2js_f32$0 = Math_fround(0);
  wasm2js_i32$0 = 0;
  wasm2js_f32$0 = value;
  HEAPF32[wasm2js_i32$0 >> 2] = wasm2js_f32$0;
  return Math_fround((HEAP32[0] = i32_load_little(0 | 0) | 0, HEAPF32[0]));
 }
 
 function $22(value) {
  value = +value;
  var i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0, wasm2js_i32$1 = 0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = value;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = i64_load_little(0 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$1 = i64toi32_i32$1;
  wasm2js_i32$0 = 0;
  wasm2js_i32$1 = i64toi32_i32$0;
  HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
  wasm2js_i32$0 = 0;
  wasm2js_i32$1 = i64toi32_i32$1;
  HEAP32[(wasm2js_i32$0 + 4 | 0) >> 2] = wasm2js_i32$1;
  return +(+HEAPF64[0 >> 3]);
 }
 
 return {
  i32_load16_s: $6, 
  i32_load16_u: $7, 
  i32_load: $8, 
  i64_load16_s: $9, 
  i64_load16_u: $10, 
  i64_load32_s: $11, 
  i64_load32_u: $12, 
  i64_load: $13, 
  f32_load: $14, 
  f64_load: $15, 
  i32_store16: $16, 
  i32_store: $17, 
  i64_store16: $18, 
  i64_store32: $19, 
  i64_store: $20, 
  f32_store: $21, 
  f64_store: $22
 };
}

const memasmFunc = new ArrayBuffer(65536);
const retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export const i32_load16_s = retasmFunc.i32_load16_s;
export const i32_load16_u = retasmFunc.i32_load16_u;
export const i32_load = retasmFunc.i32_load;
export const i64_load16_s = retasmFunc.i64_load16_s;
export const i64_load16_u = retasmFunc.i64_load16_u;
export const i64_load32_s = retasmFunc.i64_load32_s;
export const i64_load32_u = retasmFunc.i64_load32_u;
export const i64_load = retasmFunc.i64_load;
export const f32_load = retasmFunc.f32_load;
export const f64_load = retasmFunc.f64_load;
export const i32_store16 = retasmFunc.i32_store16;
export const i32_store = retasmFunc.i32_store;
export const i64_store16 = retasmFunc.i64_store16;
export const i64_store32 = retasmFunc.i64_store32;
export const i64_store = retasmFunc.i64_store;
export const f32_store = retasmFunc.f32_store;
export const f64_store = retasmFunc.f64_store;
