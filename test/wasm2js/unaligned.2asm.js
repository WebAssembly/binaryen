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
 function $0() {
  var wasm2js_i32$0 = 0;
  return (wasm2js_i32$0 = 0, HEAPU8[wasm2js_i32$0 >> 0] | 0 | 0 | (HEAPU8[(wasm2js_i32$0 + 1 | 0) >> 0] | 0 | 0) << 8 | (HEAPU8[(wasm2js_i32$0 + 2 | 0) >> 0] | 0 | 0) << 16 | (HEAPU8[(wasm2js_i32$0 + 3 | 0) >> 0] | 0 | 0) << 24) | 0;
 }
 
 function $1() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$2 = 0, wasm2js_i32$0 = 0;
  i64toi32_i32$2 = 0;
  i64toi32_i32$0 = (wasm2js_i32$0 = i64toi32_i32$2, HEAPU8[wasm2js_i32$0 >> 0] | 0 | 0 | (HEAPU8[(wasm2js_i32$0 + 1 | 0) >> 0] | 0 | 0) << 8 | (HEAPU8[(wasm2js_i32$0 + 2 | 0) >> 0] | 0 | 0) << 16 | (HEAPU8[(wasm2js_i32$0 + 3 | 0) >> 0] | 0 | 0) << 24);
  i64toi32_i32$1 = (wasm2js_i32$0 = i64toi32_i32$2, HEAPU8[(wasm2js_i32$0 + 4 | 0) >> 0] | 0 | 0 | (HEAPU8[(wasm2js_i32$0 + 5 | 0) >> 0] | 0 | 0) << 8 | (HEAPU8[(wasm2js_i32$0 + 6 | 0) >> 0] | 0 | 0) << 16 | (HEAPU8[(wasm2js_i32$0 + 7 | 0) >> 0] | 0 | 0) << 24);
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $2() {
  var wasm2js_i32$0 = 0;
  return Math_fround((HEAP32[0] = (wasm2js_i32$0 = 0, HEAPU8[wasm2js_i32$0 >> 0] | 0 | 0 | (HEAPU8[(wasm2js_i32$0 + 1 | 0) >> 0] | 0 | 0) << 8 | (HEAPU8[(wasm2js_i32$0 + 2 | 0) >> 0] | 0 | 0) << 16 | (HEAPU8[(wasm2js_i32$0 + 3 | 0) >> 0] | 0 | 0) << 24), HEAPF32[0]));
 }
 
 function $3() {
  var i64toi32_i32$1 = 0, i64toi32_i32$2 = 0, wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0;
  i64toi32_i32$2 = 0;
  i64toi32_i32$1 = (wasm2js_i32$0 = i64toi32_i32$2, HEAPU8[(wasm2js_i32$0 + 4 | 0) >> 0] | 0 | 0 | (HEAPU8[(wasm2js_i32$0 + 5 | 0) >> 0] | 0 | 0) << 8 | (HEAPU8[(wasm2js_i32$0 + 6 | 0) >> 0] | 0 | 0) << 16 | (HEAPU8[(wasm2js_i32$0 + 7 | 0) >> 0] | 0 | 0) << 24);
  i64toi32_i32$1 = i64toi32_i32$1;
  wasm2js_i32$0 = 0;
  wasm2js_i32$1 = (wasm2js_i32$2 = i64toi32_i32$2, HEAPU8[wasm2js_i32$2 >> 0] | 0 | 0 | (HEAPU8[(wasm2js_i32$2 + 1 | 0) >> 0] | 0 | 0) << 8 | (HEAPU8[(wasm2js_i32$2 + 2 | 0) >> 0] | 0 | 0) << 16 | (HEAPU8[(wasm2js_i32$2 + 3 | 0) >> 0] | 0 | 0) << 24);
  HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
  wasm2js_i32$0 = 0;
  wasm2js_i32$1 = i64toi32_i32$1;
  HEAP32[(wasm2js_i32$0 + 4 | 0) >> 2] = wasm2js_i32$1;
  return +(+HEAPF64[0 >> 3]);
 }
 
 function $4() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0, wasm2js_i32$3 = 0;
  wasm2js_i32$0 = 0;
  wasm2js_i32$1 = 0;
  (wasm2js_i32$2 = wasm2js_i32$0, wasm2js_i32$3 = wasm2js_i32$1), ((HEAP8[wasm2js_i32$2 >> 0] = wasm2js_i32$3 & 255 | 0, HEAP8[(wasm2js_i32$2 + 1 | 0) >> 0] = (wasm2js_i32$3 >>> 8 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 2 | 0) >> 0] = (wasm2js_i32$3 >>> 16 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 3 | 0) >> 0] = (wasm2js_i32$3 >>> 24 | 0) & 255 | 0;
 }
 
 function $5() {
  var i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0, wasm2js_i32$3 = 0;
  i64toi32_i32$1 = 0;
  wasm2js_i32$0 = i64toi32_i32$1;
  wasm2js_i32$1 = 0;
  (wasm2js_i32$2 = wasm2js_i32$0, wasm2js_i32$3 = wasm2js_i32$1), ((HEAP8[wasm2js_i32$2 >> 0] = wasm2js_i32$3 & 255 | 0, HEAP8[(wasm2js_i32$2 + 1 | 0) >> 0] = (wasm2js_i32$3 >>> 8 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 2 | 0) >> 0] = (wasm2js_i32$3 >>> 16 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 3 | 0) >> 0] = (wasm2js_i32$3 >>> 24 | 0) & 255 | 0;
  wasm2js_i32$0 = i64toi32_i32$1;
  wasm2js_i32$1 = 0;
  (wasm2js_i32$2 = wasm2js_i32$0, wasm2js_i32$3 = wasm2js_i32$1), ((HEAP8[(wasm2js_i32$2 + 4 | 0) >> 0] = wasm2js_i32$3 & 255 | 0, HEAP8[(wasm2js_i32$2 + 5 | 0) >> 0] = (wasm2js_i32$3 >>> 8 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 6 | 0) >> 0] = (wasm2js_i32$3 >>> 16 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 7 | 0) >> 0] = (wasm2js_i32$3 >>> 24 | 0) & 255 | 0;
 }
 
 function $6() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0, wasm2js_i32$3 = 0;
  wasm2js_i32$0 = 0;
  wasm2js_i32$1 = (HEAPF32[0] = Math_fround(0.0), HEAP32[0] | 0);
  (wasm2js_i32$2 = wasm2js_i32$0, wasm2js_i32$3 = wasm2js_i32$1), ((HEAP8[wasm2js_i32$2 >> 0] = wasm2js_i32$3 & 255 | 0, HEAP8[(wasm2js_i32$2 + 1 | 0) >> 0] = (wasm2js_i32$3 >>> 8 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 2 | 0) >> 0] = (wasm2js_i32$3 >>> 16 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 3 | 0) >> 0] = (wasm2js_i32$3 >>> 24 | 0) & 255 | 0;
 }
 
 function $7() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0, wasm2js_i32$3 = 0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = 0.0;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  wasm2js_i32$0 = i64toi32_i32$1;
  wasm2js_i32$1 = HEAP32[0 >> 2] | 0;
  (wasm2js_i32$2 = wasm2js_i32$0, wasm2js_i32$3 = wasm2js_i32$1), ((HEAP8[wasm2js_i32$2 >> 0] = wasm2js_i32$3 & 255 | 0, HEAP8[(wasm2js_i32$2 + 1 | 0) >> 0] = (wasm2js_i32$3 >>> 8 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 2 | 0) >> 0] = (wasm2js_i32$3 >>> 16 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 3 | 0) >> 0] = (wasm2js_i32$3 >>> 24 | 0) & 255 | 0;
  wasm2js_i32$0 = i64toi32_i32$1;
  wasm2js_i32$1 = i64toi32_i32$0;
  (wasm2js_i32$2 = wasm2js_i32$0, wasm2js_i32$3 = wasm2js_i32$1), ((HEAP8[(wasm2js_i32$2 + 4 | 0) >> 0] = wasm2js_i32$3 & 255 | 0, HEAP8[(wasm2js_i32$2 + 5 | 0) >> 0] = (wasm2js_i32$3 >>> 8 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 6 | 0) >> 0] = (wasm2js_i32$3 >>> 16 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 7 | 0) >> 0] = (wasm2js_i32$3 >>> 24 | 0) & 255 | 0;
 }
 
 return {
  i32_load: $0, 
  i64_load: $1, 
  f32_load: $2, 
  f64_load: $3, 
  i32_store: $4, 
  i64_store: $5, 
  f32_store: $6, 
  f64_store: $7
 };
}

const memasmFunc = new ArrayBuffer(65536);
const retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export const i32_load = retasmFunc.i32_load;
export const i64_load = retasmFunc.i64_load;
export const f32_load = retasmFunc.f32_load;
export const f64_load = retasmFunc.f64_load;
export const i32_store = retasmFunc.i32_store;
export const i64_store = retasmFunc.i64_store;
export const f32_store = retasmFunc.f32_store;
export const f64_store = retasmFunc.f64_store;
