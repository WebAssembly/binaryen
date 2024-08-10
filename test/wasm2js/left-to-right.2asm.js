
  var bufferView;

  var scratchBuffer = new ArrayBuffer(16);
  var i32ScratchView = new Int32Array(scratchBuffer);
  var f32ScratchView = new Float32Array(scratchBuffer);
  var f64ScratchView = new Float64Array(scratchBuffer);
  
  function wasm2js_scratch_load_i32(index) {
    return i32ScratchView[index];
  }
      
  function wasm2js_scratch_store_i32(index, value) {
    i32ScratchView[index] = value;
  }
      
  function wasm2js_scratch_load_f64() {
    return f64ScratchView[0];
  }
      
  function wasm2js_scratch_store_f64(value) {
    f64ScratchView[0] = value;
  }
      
  function wasm2js_scratch_store_f32(value) {
    f32ScratchView[2] = value;
  }
      
function asmFunc(imports) {
 var buffer = new ArrayBuffer(65536);
 var HEAP8 = new Int8Array(buffer);
 var HEAP16 = new Int16Array(buffer);
 var HEAP32 = new Int32Array(buffer);
 var HEAPU8 = new Uint8Array(buffer);
 var HEAPU16 = new Uint16Array(buffer);
 var HEAPU32 = new Uint32Array(buffer);
 var HEAPF32 = new Float32Array(buffer);
 var HEAPF64 = new Float64Array(buffer);
 var Math_imul = Math.imul;
 var Math_fround = Math.fround;
 var Math_abs = Math.abs;
 var Math_clz32 = Math.clz32;
 var Math_min = Math.min;
 var Math_max = Math.max;
 var Math_floor = Math.floor;
 var Math_ceil = Math.ceil;
 var Math_trunc = Math.trunc;
 var Math_sqrt = Math.sqrt;
 var __wasm_intrinsics_temp_i64 = 0;
 var __wasm_intrinsics_temp_i64$hi = 0;
 var i64toi32_i32$HIGH_BITS = 0;
 function i32_t0($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  return -1 | 0;
 }
 
 function i32_t1($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  return -2 | 0;
 }
 
 function i64_t0($0, $0$hi, $1, $1$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  $1 = $1 | 0;
  $1$hi = $1$hi | 0;
  return -1 | 0;
 }
 
 function i64_t1($0, $0$hi, $1, $1$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  $1 = $1 | 0;
  $1$hi = $1$hi | 0;
  return -2 | 0;
 }
 
 function f32_t0($0, $1) {
  $0 = Math_fround($0);
  $1 = Math_fround($1);
  return -1 | 0;
 }
 
 function f32_t1($0, $1) {
  $0 = Math_fround($0);
  $1 = Math_fround($1);
  return -2 | 0;
 }
 
 function f64_t0($0, $1) {
  $0 = +$0;
  $1 = +$1;
  return -1 | 0;
 }
 
 function f64_t1($0, $1) {
  $0 = +$0;
  $1 = +$1;
  return -2 | 0;
 }
 
 function reset() {
  HEAP32[8 >> 2] = 0;
 }
 
 function bump() {
  HEAP8[11 >> 0] = HEAPU8[10 >> 0] | 0;
  HEAP8[10 >> 0] = HEAPU8[9 >> 0] | 0;
  HEAP8[9 >> 0] = HEAPU8[8 >> 0] | 0;
  HEAP8[8 >> 0] = -3;
 }
 
 function get() {
  return HEAP32[8 >> 2] | 0 | 0;
 }
 
 function i32_left() {
  bump();
  HEAP8[8 >> 0] = 1;
  return 0 | 0;
 }
 
 function i32_right() {
  bump();
  HEAP8[8 >> 0] = 2;
  return 1 | 0;
 }
 
 function i32_callee() {
  bump();
  HEAP8[8 >> 0] = 4;
  return 0 | 0;
 }
 
 function i32_bool() {
  bump();
  HEAP8[8 >> 0] = 5;
  return 0 | 0;
 }
 
 function i64_left() {
  var i64toi32_i32$0 = 0;
  bump();
  HEAP8[8 >> 0] = 1;
  i64toi32_i32$0 = 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return 0 | 0;
 }
 
 function i64_right() {
  var i64toi32_i32$0 = 0;
  bump();
  HEAP8[8 >> 0] = 2;
  i64toi32_i32$0 = 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return 1 | 0;
 }
 
 function i64_callee() {
  bump();
  HEAP8[8 >> 0] = 4;
  return 2 | 0;
 }
 
 function i64_bool() {
  bump();
  HEAP8[8 >> 0] = 5;
  return 0 | 0;
 }
 
 function f32_left() {
  bump();
  HEAP8[8 >> 0] = 1;
  return Math_fround(Math_fround(0.0));
 }
 
 function f32_right() {
  bump();
  HEAP8[8 >> 0] = 2;
  return Math_fround(Math_fround(1.0));
 }
 
 function f32_callee() {
  bump();
  HEAP8[8 >> 0] = 4;
  return 4 | 0;
 }
 
 function f32_bool() {
  bump();
  HEAP8[8 >> 0] = 5;
  return 0 | 0;
 }
 
 function f64_left() {
  bump();
  HEAP8[8 >> 0] = 1;
  return +(0.0);
 }
 
 function f64_right() {
  bump();
  HEAP8[8 >> 0] = 2;
  return +(1.0);
 }
 
 function f64_callee() {
  bump();
  HEAP8[8 >> 0] = 4;
  return 6 | 0;
 }
 
 function f64_bool() {
  bump();
  HEAP8[8 >> 0] = 5;
  return 0 | 0;
 }
 
 function i32_dummy($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
 }
 
 function i64_dummy($0, $0$hi, $1, $1$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  $1 = $1 | 0;
  $1$hi = $1$hi | 0;
 }
 
 function f32_dummy($0, $1) {
  $0 = Math_fround($0);
  $1 = Math_fround($1);
 }
 
 function f64_dummy($0, $1) {
  $0 = +$0;
  $1 = +$1;
 }
 
 function f0() {
  reset();
  i32_left() | 0;
  i32_right() | 0;
  return get() | 0 | 0;
 }
 
 function f1() {
  reset();
  i32_left() | 0;
  i32_right() | 0;
  return get() | 0 | 0;
 }
 
 function f2() {
  reset();
  i32_left() | 0;
  i32_right() | 0;
  return get() | 0 | 0;
 }
 
 function f3() {
  reset();
  (i32_left() | 0 | 0) / (i32_right() | 0 | 0) | 0;
  return get() | 0 | 0;
 }
 
 function f4() {
  reset();
  ((i32_left() | 0) >>> 0) / ((i32_right() | 0) >>> 0) | 0;
  return get() | 0 | 0;
 }
 
 function f5() {
  reset();
  (i32_left() | 0 | 0) % (i32_right() | 0 | 0) | 0;
  return get() | 0 | 0;
 }
 
 function f6() {
  reset();
  ((i32_left() | 0) >>> 0) % ((i32_right() | 0) >>> 0) | 0;
  return get() | 0 | 0;
 }
 
 function f7() {
  reset();
  i32_left() | 0;
  i32_right() | 0;
  return get() | 0 | 0;
 }
 
 function f8() {
  reset();
  i32_left() | 0;
  i32_right() | 0;
  return get() | 0 | 0;
 }
 
 function f9() {
  reset();
  i32_left() | 0;
  i32_right() | 0;
  return get() | 0 | 0;
 }
 
 function f10() {
  reset();
  i32_left() | 0;
  i32_right() | 0;
  return get() | 0 | 0;
 }
 
 function f11() {
  reset();
  i32_left() | 0;
  i32_right() | 0;
  return get() | 0 | 0;
 }
 
 function f12() {
  reset();
  i32_left() | 0;
  i32_right() | 0;
  return get() | 0 | 0;
 }
 
 function f13() {
  reset();
  i32_left() | 0;
  i32_right() | 0;
  return get() | 0 | 0;
 }
 
 function f14() {
  reset();
  i32_left() | 0;
  i32_right() | 0;
  return get() | 0 | 0;
 }
 
 function f15() {
  reset();
  i32_left() | 0;
  i32_right() | 0;
  return get() | 0 | 0;
 }
 
 function f16() {
  reset();
  i32_left() | 0;
  i32_right() | 0;
  return get() | 0 | 0;
 }
 
 function f17() {
  reset();
  i32_left() | 0;
  i32_right() | 0;
  return get() | 0 | 0;
 }
 
 function f18() {
  reset();
  i32_left() | 0;
  i32_right() | 0;
  return get() | 0 | 0;
 }
 
 function f19() {
  reset();
  i32_left() | 0;
  i32_right() | 0;
  return get() | 0 | 0;
 }
 
 function f20() {
  reset();
  i32_left() | 0;
  i32_right() | 0;
  return get() | 0 | 0;
 }
 
 function f21() {
  reset();
  i32_left() | 0;
  i32_right() | 0;
  return get() | 0 | 0;
 }
 
 function f22() {
  reset();
  i32_left() | 0;
  i32_right() | 0;
  return get() | 0 | 0;
 }
 
 function f23() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  reset();
  (wasm2js_i32$0 = i32_left() | 0, wasm2js_i32$1 = i32_right() | 0), HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
  return get() | 0 | 0;
 }
 
 function f24() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  reset();
  (wasm2js_i32$0 = i32_left() | 0, wasm2js_i32$1 = i32_right() | 0), HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
  return get() | 0 | 0;
 }
 
 function f25() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  reset();
  (wasm2js_i32$0 = i32_left() | 0, wasm2js_i32$1 = i32_right() | 0), HEAP16[wasm2js_i32$0 >> 1] = wasm2js_i32$1;
  return get() | 0 | 0;
 }
 
 function f26() {
  reset();
  i32_dummy(i32_left() | 0 | 0, i32_right() | 0 | 0);
  return get() | 0 | 0;
 }
 
 function f27() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0;
  reset();
  ((wasm2js_i32$1 = i32_left() | 0, wasm2js_i32$2 = i32_right() | 0), wasm2js_i32$0 = i32_callee() | 0 | 0), FUNCTION_TABLE[wasm2js_i32$0](wasm2js_i32$1 | 0, wasm2js_i32$2 | 0) | 0;
  return get() | 0 | 0;
 }
 
 function f28() {
  reset();
  i32_left() | 0;
  i32_right() | 0;
  i32_bool() | 0;
  return get() | 0 | 0;
 }
 
 function f29() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, i64toi32_i32$4 = 0, i64toi32_i32$5 = 0, $0 = 0, $0$hi = 0, $1 = 0, $1$hi = 0;
  reset();
  i64toi32_i32$0 = i64_left() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64_right() | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$1;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$1 = $1$hi;
  i64toi32_i32$3 = $1;
  i64toi32_i32$4 = $0 + i64toi32_i32$3 | 0;
  i64toi32_i32$5 = i64toi32_i32$0 + i64toi32_i32$1 | 0;
  if (i64toi32_i32$4 >>> 0 < i64toi32_i32$3 >>> 0) {
   i64toi32_i32$5 = i64toi32_i32$5 + 1 | 0
  }
  return get() | 0 | 0;
 }
 
 function f30() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, i64toi32_i32$5 = 0, $0 = 0, $0$hi = 0, $1 = 0, $1$hi = 0;
  reset();
  i64toi32_i32$0 = i64_left() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64_right() | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$1;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$2 = $0;
  i64toi32_i32$1 = $1$hi;
  i64toi32_i32$3 = $1;
  i64toi32_i32$5 = (i64toi32_i32$2 >>> 0 < i64toi32_i32$3 >>> 0) + i64toi32_i32$1 | 0;
  i64toi32_i32$5 = i64toi32_i32$0 - i64toi32_i32$5 | 0;
  return get() | 0 | 0;
 }
 
 function f31() {
  var i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, $0 = 0, $0$hi = 0, $1 = 0, $1$hi = 0;
  reset();
  i64toi32_i32$0 = i64_left() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64_right() | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$1;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$1 = $1$hi;
  i64toi32_i32$1 = __wasm_i64_mul($0 | 0, i64toi32_i32$0 | 0, $1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  return get() | 0 | 0;
 }
 
 function f32() {
  var i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, $0 = 0, $0$hi = 0, $1 = 0, $1$hi = 0;
  reset();
  i64toi32_i32$0 = i64_left() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64_right() | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$1;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$1 = $1$hi;
  i64toi32_i32$1 = __wasm_i64_sdiv($0 | 0, i64toi32_i32$0 | 0, $1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  return get() | 0 | 0;
 }
 
 function f33() {
  var i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, $0 = 0, $0$hi = 0, $1 = 0, $1$hi = 0;
  reset();
  i64toi32_i32$0 = i64_left() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64_right() | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$1;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$1 = $1$hi;
  i64toi32_i32$1 = __wasm_i64_udiv($0 | 0, i64toi32_i32$0 | 0, $1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  return get() | 0 | 0;
 }
 
 function f34() {
  var i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, $0 = 0, $0$hi = 0, $1 = 0, $1$hi = 0;
  reset();
  i64toi32_i32$0 = i64_left() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64_right() | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$1;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$1 = $1$hi;
  i64toi32_i32$1 = __wasm_i64_srem($0 | 0, i64toi32_i32$0 | 0, $1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  return get() | 0 | 0;
 }
 
 function f35() {
  var i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, $0 = 0, $0$hi = 0, $1 = 0, $1$hi = 0;
  reset();
  i64toi32_i32$0 = i64_left() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64_right() | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$1;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$1 = $1$hi;
  i64toi32_i32$1 = __wasm_i64_urem($0 | 0, i64toi32_i32$0 | 0, $1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  return get() | 0 | 0;
 }
 
 function f36() {
  var i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, $0 = 0, $0$hi = 0, $1 = 0, $1$hi = 0;
  reset();
  i64toi32_i32$0 = i64_left() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64_right() | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$1;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$1 = $1$hi;
  i64toi32_i32$1 = i64toi32_i32$0 & i64toi32_i32$1 | 0;
  return get() | 0 | 0;
 }
 
 function f37() {
  var i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, $0 = 0, $0$hi = 0, $1 = 0, $1$hi = 0;
  reset();
  i64toi32_i32$0 = i64_left() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64_right() | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$1;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$1 = $1$hi;
  i64toi32_i32$1 = i64toi32_i32$0 | i64toi32_i32$1 | 0;
  return get() | 0 | 0;
 }
 
 function f38() {
  var i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, $0 = 0, $0$hi = 0, $1 = 0, $1$hi = 0;
  reset();
  i64toi32_i32$0 = i64_left() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64_right() | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$1;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$1 = $1$hi;
  i64toi32_i32$1 = i64toi32_i32$0 ^ i64toi32_i32$1 | 0;
  return get() | 0 | 0;
 }
 
 function f39() {
  var i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, $9 = 0, $0 = 0, $0$hi = 0, $1 = 0, $1$hi = 0;
  reset();
  i64toi32_i32$0 = i64_left() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64_right() | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$1;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$2 = $0;
  i64toi32_i32$1 = $1$hi;
  i64toi32_i32$3 = $1;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $9 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $9 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  return get() | 0 | 0;
 }
 
 function f40() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $9 = 0, $0 = 0, $0$hi = 0, $1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  reset();
  i64toi32_i32$0 = i64_left() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64_right() | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$1;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$2 = $0;
  i64toi32_i32$1 = $1$hi;
  i64toi32_i32$3 = $1;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = 0;
   $9 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $9 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  return get() | 0 | 0;
 }
 
 function f41() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $9 = 0, $0 = 0, $0$hi = 0, $1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  reset();
  i64toi32_i32$0 = i64_left() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64_right() | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$1;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$2 = $0;
  i64toi32_i32$1 = $1$hi;
  i64toi32_i32$3 = $1;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
   $9 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
   $9 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  return get() | 0 | 0;
 }
 
 function f42() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, $0 = 0, $0$hi = 0, $1 = 0, $1$hi = 0;
  reset();
  i64toi32_i32$0 = i64_left() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64_right() | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$1;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$1 = $1$hi;
  return get() | 0 | 0;
 }
 
 function f43() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, $0 = 0, $0$hi = 0, $1 = 0, $1$hi = 0;
  reset();
  i64toi32_i32$0 = i64_left() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64_right() | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$1;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$1 = $1$hi;
  return get() | 0 | 0;
 }
 
 function f44() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, $8 = 0, $9 = 0, $10 = 0, $0 = 0, $0$hi = 0, $1 = 0, $1$hi = 0, i64toi32_i32$2 = 0, i64toi32_i32$3 = 0;
  reset();
  i64toi32_i32$0 = i64_left() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64_right() | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$1;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$2 = $0;
  i64toi32_i32$1 = $1$hi;
  i64toi32_i32$3 = $1;
  if ((i64toi32_i32$0 | 0) < (i64toi32_i32$1 | 0)) {
   $8 = 1
  } else {
   if ((i64toi32_i32$0 | 0) <= (i64toi32_i32$1 | 0)) {
    if (i64toi32_i32$2 >>> 0 >= i64toi32_i32$3 >>> 0) {
     $9 = 0
    } else {
     $9 = 1
    }
    $10 = $9;
   } else {
    $10 = 0
   }
   $8 = $10;
  }
  return get() | 0 | 0;
 }
 
 function f45() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, $8 = 0, $9 = 0, $10 = 0, $0 = 0, $0$hi = 0, $1 = 0, $1$hi = 0, i64toi32_i32$2 = 0, i64toi32_i32$3 = 0;
  reset();
  i64toi32_i32$0 = i64_left() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64_right() | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$1;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$2 = $0;
  i64toi32_i32$1 = $1$hi;
  i64toi32_i32$3 = $1;
  if ((i64toi32_i32$0 | 0) < (i64toi32_i32$1 | 0)) {
   $8 = 1
  } else {
   if ((i64toi32_i32$0 | 0) <= (i64toi32_i32$1 | 0)) {
    if (i64toi32_i32$2 >>> 0 > i64toi32_i32$3 >>> 0) {
     $9 = 0
    } else {
     $9 = 1
    }
    $10 = $9;
   } else {
    $10 = 0
   }
   $8 = $10;
  }
  return get() | 0 | 0;
 }
 
 function f46() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, $0 = 0, $0$hi = 0, $1 = 0, $1$hi = 0;
  reset();
  i64toi32_i32$0 = i64_left() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64_right() | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$1;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$1 = $1$hi;
  return get() | 0 | 0;
 }
 
 function f47() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, $0 = 0, $0$hi = 0, $1 = 0, $1$hi = 0;
  reset();
  i64toi32_i32$0 = i64_left() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64_right() | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$1;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$1 = $1$hi;
  return get() | 0 | 0;
 }
 
 function f48() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, $8 = 0, $9 = 0, $10 = 0, $0 = 0, $0$hi = 0, $1 = 0, $1$hi = 0, i64toi32_i32$2 = 0, i64toi32_i32$3 = 0;
  reset();
  i64toi32_i32$0 = i64_left() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64_right() | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$1;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$2 = $0;
  i64toi32_i32$1 = $1$hi;
  i64toi32_i32$3 = $1;
  if ((i64toi32_i32$0 | 0) > (i64toi32_i32$1 | 0)) {
   $8 = 1
  } else {
   if ((i64toi32_i32$0 | 0) >= (i64toi32_i32$1 | 0)) {
    if (i64toi32_i32$2 >>> 0 <= i64toi32_i32$3 >>> 0) {
     $9 = 0
    } else {
     $9 = 1
    }
    $10 = $9;
   } else {
    $10 = 0
   }
   $8 = $10;
  }
  return get() | 0 | 0;
 }
 
 function f49() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, $8 = 0, $9 = 0, $10 = 0, $0 = 0, $0$hi = 0, $1 = 0, $1$hi = 0, i64toi32_i32$2 = 0, i64toi32_i32$3 = 0;
  reset();
  i64toi32_i32$0 = i64_left() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64_right() | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$1;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$2 = $0;
  i64toi32_i32$1 = $1$hi;
  i64toi32_i32$3 = $1;
  if ((i64toi32_i32$0 | 0) > (i64toi32_i32$1 | 0)) {
   $8 = 1
  } else {
   if ((i64toi32_i32$0 | 0) >= (i64toi32_i32$1 | 0)) {
    if (i64toi32_i32$2 >>> 0 < i64toi32_i32$3 >>> 0) {
     $9 = 0
    } else {
     $9 = 1
    }
    $10 = $9;
   } else {
    $10 = 0
   }
   $8 = $10;
  }
  return get() | 0 | 0;
 }
 
 function f50() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, $0 = 0, $0$hi = 0, $1 = 0, $1$hi = 0;
  reset();
  i64toi32_i32$0 = i64_left() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64_right() | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$1;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$1 = $1$hi;
  return get() | 0 | 0;
 }
 
 function f51() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, $0 = 0, $0$hi = 0, $1 = 0, $1$hi = 0;
  reset();
  i64toi32_i32$0 = i64_left() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64_right() | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$1;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$1 = $1$hi;
  return get() | 0 | 0;
 }
 
 function f52() {
  var i64toi32_i32$0 = 0, $0 = 0, i64toi32_i32$1 = 0, $1 = 0;
  reset();
  $0 = i32_left() | 0;
  i64toi32_i32$0 = i64_right() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$0;
  i64toi32_i32$0 = $0;
  HEAP32[i64toi32_i32$0 >> 2] = $1;
  HEAP32[(i64toi32_i32$0 + 4 | 0) >> 2] = i64toi32_i32$1;
  return get() | 0 | 0;
 }
 
 function f53() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  reset();
  (wasm2js_i32$0 = i32_left() | 0, wasm2js_i32$1 = i64_right() | 0), HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
  return get() | 0 | 0;
 }
 
 function f54() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  reset();
  (wasm2js_i32$0 = i32_left() | 0, wasm2js_i32$1 = i64_right() | 0), HEAP16[wasm2js_i32$0 >> 1] = wasm2js_i32$1;
  return get() | 0 | 0;
 }
 
 function f55() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  reset();
  (wasm2js_i32$0 = i32_left() | 0, wasm2js_i32$1 = i64_right() | 0), HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
  return get() | 0 | 0;
 }
 
 function f56() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, $0 = 0, $0$hi = 0, $1 = 0, $1$hi = 0;
  reset();
  i64toi32_i32$0 = i64_left() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64_right() | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$1;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$1 = $1$hi;
  i64_dummy($0 | 0, i64toi32_i32$0 | 0, $1 | 0, i64toi32_i32$1 | 0);
  return get() | 0 | 0;
 }
 
 function f57() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, $0 = 0, $0$hi = 0, $1 = 0, $1$hi = 0;
  reset();
  i64toi32_i32$0 = i64_left() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64_right() | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$1;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$1 = $1$hi;
  FUNCTION_TABLE[i64_callee() | 0 | 0]($0, i64toi32_i32$0, $1, i64toi32_i32$1) | 0;
  return get() | 0 | 0;
 }
 
 function f58() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, $0 = 0, $0$hi = 0, $1 = 0, $1$hi = 0, i64toi32_i32$4 = 0;
  reset();
  i64toi32_i32$0 = i64_left() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64_right() | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$1;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$4 = i64_bool() | 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$1 = $1$hi;
  return get() | 0 | 0;
 }
 
 function f59() {
  reset();
  Math_fround(f32_left());
  Math_fround(f32_right());
  return get() | 0 | 0;
 }
 
 function f60() {
  reset();
  Math_fround(f32_left());
  Math_fround(f32_right());
  return get() | 0 | 0;
 }
 
 function f61() {
  reset();
  Math_fround(f32_left());
  Math_fround(f32_right());
  return get() | 0 | 0;
 }
 
 function f62() {
  reset();
  Math_fround(f32_left());
  Math_fround(f32_right());
  return get() | 0 | 0;
 }
 
 function f63() {
  reset();
  (wasm2js_scratch_store_f32(Math_fround(f32_left())), wasm2js_scratch_load_i32(2)) & 2147483647 | 0;
  (wasm2js_scratch_store_f32(Math_fround(f32_right())), wasm2js_scratch_load_i32(2)) & -2147483648 | 0;
  return get() | 0 | 0;
 }
 
 function f64() {
  reset();
  Math_fround(f32_left());
  Math_fround(f32_right());
  return get() | 0 | 0;
 }
 
 function f65() {
  reset();
  Math_fround(f32_left());
  Math_fround(f32_right());
  return get() | 0 | 0;
 }
 
 function f66() {
  reset();
  Math_fround(f32_left());
  Math_fround(f32_right());
  return get() | 0 | 0;
 }
 
 function f67() {
  reset();
  Math_fround(f32_left());
  Math_fround(f32_right());
  return get() | 0 | 0;
 }
 
 function f68() {
  reset();
  Math_fround(f32_left());
  Math_fround(f32_right());
  return get() | 0 | 0;
 }
 
 function f69() {
  reset();
  Math_fround(f32_left());
  Math_fround(f32_right());
  return get() | 0 | 0;
 }
 
 function f70() {
  reset();
  Math_fround(f32_left());
  Math_fround(f32_right());
  return get() | 0 | 0;
 }
 
 function f71() {
  reset();
  Math_fround(f32_left());
  Math_fround(f32_right());
  return get() | 0 | 0;
 }
 
 function f72() {
  var wasm2js_i32$0 = 0, wasm2js_f32$0 = Math_fround(0);
  reset();
  (wasm2js_i32$0 = i32_left() | 0, wasm2js_f32$0 = Math_fround(f32_right())), HEAPF32[wasm2js_i32$0 >> 2] = wasm2js_f32$0;
  return get() | 0 | 0;
 }
 
 function f73() {
  reset();
  f32_dummy(Math_fround(Math_fround(f32_left())), Math_fround(Math_fround(f32_right())));
  return get() | 0 | 0;
 }
 
 function f74() {
  var wasm2js_i32$0 = 0, wasm2js_f32$0 = Math_fround(0), wasm2js_f32$1 = Math_fround(0);
  reset();
  ((wasm2js_f32$0 = Math_fround(f32_left()), wasm2js_f32$1 = Math_fround(f32_right())), wasm2js_i32$0 = f32_callee() | 0 | 0), FUNCTION_TABLE[wasm2js_i32$0](Math_fround(wasm2js_f32$0), Math_fround(wasm2js_f32$1)) | 0;
  return get() | 0 | 0;
 }
 
 function f75() {
  reset();
  Math_fround(f32_left());
  Math_fround(f32_right());
  f32_bool() | 0;
  return get() | 0 | 0;
 }
 
 function f76() {
  reset();
  +f64_left();
  +f64_right();
  return get() | 0 | 0;
 }
 
 function f77() {
  reset();
  +f64_left();
  +f64_right();
  return get() | 0 | 0;
 }
 
 function f78() {
  reset();
  +f64_left();
  +f64_right();
  return get() | 0 | 0;
 }
 
 function f79() {
  reset();
  +f64_left();
  +f64_right();
  return get() | 0 | 0;
 }
 
 function f80() {
  var i64toi32_i32$0 = 0, i64toi32_i32$2 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $2 = 0, $2$hi = 0, $5 = 0, $5$hi = 0;
  reset();
  wasm2js_scratch_store_f64(+(+f64_left()));
  i64toi32_i32$0 = wasm2js_scratch_load_i32(1 | 0) | 0;
  i64toi32_i32$2 = wasm2js_scratch_load_i32(0 | 0) | 0;
  i64toi32_i32$1 = 2147483647;
  i64toi32_i32$3 = -1;
  i64toi32_i32$1 = i64toi32_i32$0 & i64toi32_i32$1 | 0;
  $2 = i64toi32_i32$2 & i64toi32_i32$3 | 0;
  $2$hi = i64toi32_i32$1;
  wasm2js_scratch_store_f64(+(+f64_right()));
  i64toi32_i32$1 = wasm2js_scratch_load_i32(1 | 0) | 0;
  i64toi32_i32$0 = wasm2js_scratch_load_i32(0 | 0) | 0;
  i64toi32_i32$2 = -2147483648;
  i64toi32_i32$3 = 0;
  i64toi32_i32$2 = i64toi32_i32$1 & i64toi32_i32$2 | 0;
  $5 = i64toi32_i32$0 & i64toi32_i32$3 | 0;
  $5$hi = i64toi32_i32$2;
  i64toi32_i32$2 = $2$hi;
  i64toi32_i32$1 = $2;
  i64toi32_i32$0 = $5$hi;
  i64toi32_i32$3 = $5;
  i64toi32_i32$0 = i64toi32_i32$2 | i64toi32_i32$0 | 0;
  wasm2js_scratch_store_i32(0 | 0, i64toi32_i32$1 | i64toi32_i32$3 | 0 | 0);
  wasm2js_scratch_store_i32(1 | 0, i64toi32_i32$0 | 0);
  +wasm2js_scratch_load_f64();
  return get() | 0 | 0;
 }
 
 function f81() {
  reset();
  +f64_left();
  +f64_right();
  return get() | 0 | 0;
 }
 
 function f82() {
  reset();
  +f64_left();
  +f64_right();
  return get() | 0 | 0;
 }
 
 function f83() {
  reset();
  +f64_left();
  +f64_right();
  return get() | 0 | 0;
 }
 
 function f84() {
  reset();
  +f64_left();
  +f64_right();
  return get() | 0 | 0;
 }
 
 function f85() {
  reset();
  +f64_left();
  +f64_right();
  return get() | 0 | 0;
 }
 
 function f86() {
  reset();
  +f64_left();
  +f64_right();
  return get() | 0 | 0;
 }
 
 function f87() {
  reset();
  +f64_left();
  +f64_right();
  return get() | 0 | 0;
 }
 
 function f88() {
  reset();
  +f64_left();
  +f64_right();
  return get() | 0 | 0;
 }
 
 function f89() {
  var wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  reset();
  (wasm2js_i32$0 = i32_left() | 0, wasm2js_f64$0 = +f64_right()), HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  return get() | 0 | 0;
 }
 
 function f90() {
  reset();
  f64_dummy(+(+f64_left()), +(+f64_right()));
  return get() | 0 | 0;
 }
 
 function f91() {
  var wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0, wasm2js_f64$1 = 0.0;
  reset();
  ((wasm2js_f64$0 = +f64_left(), wasm2js_f64$1 = +f64_right()), wasm2js_i32$0 = f64_callee() | 0 | 0), FUNCTION_TABLE[wasm2js_i32$0](+wasm2js_f64$0, +wasm2js_f64$1) | 0;
  return get() | 0 | 0;
 }
 
 function f92() {
  reset();
  +f64_left();
  +f64_right();
  f64_bool() | 0;
  return get() | 0 | 0;
 }
 
 function f93() {
  var $3 = 0;
  block : {
   reset();
   $3 = i32_left() | 0;
   if ((i32_right() | 0) & 0 | 0) {
    break block
   }
   $3 = get() | 0;
  }
  return $3 | 0;
 }
 
 function f94() {
  var $2 = 0, $3 = 0, $4 = 0;
  a : {
   reset();
   b : {
    $2 = i32_left() | 0;
    $3 = $2;
    $4 = $2;
    switch (i32_right() | 0 | 0) {
    case 0:
     break a;
    default:
     break b;
    };
   }
   $3 = get() | 0;
  }
  return $3 | 0;
 }
 
 function _ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, var$2 = 0, i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, var$3 = 0, var$4 = 0, var$5 = 0, $21 = 0, $22 = 0, var$6 = 0, $24 = 0, $17 = 0, $18 = 0, $23 = 0, $29 = 0, $45 = 0, $56$hi = 0, $62$hi = 0;
  i64toi32_i32$0 = var$1$hi;
  var$2 = var$1;
  var$4 = var$2 >>> 16 | 0;
  i64toi32_i32$0 = var$0$hi;
  var$3 = var$0;
  var$5 = var$3 >>> 16 | 0;
  $17 = Math_imul(var$4, var$5);
  $18 = var$2;
  i64toi32_i32$2 = var$3;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = 0;
   $21 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $21 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  $23 = $17 + Math_imul($18, $21) | 0;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$0 = var$1;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $22 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $22 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$0 >>> i64toi32_i32$4 | 0) | 0;
  }
  $29 = $23 + Math_imul($22, var$3) | 0;
  var$2 = var$2 & 65535 | 0;
  var$3 = var$3 & 65535 | 0;
  var$6 = Math_imul(var$2, var$3);
  var$2 = (var$6 >>> 16 | 0) + Math_imul(var$2, var$5) | 0;
  $45 = $29 + (var$2 >>> 16 | 0) | 0;
  var$2 = (var$2 & 65535 | 0) + Math_imul(var$4, var$3) | 0;
  i64toi32_i32$2 = 0;
  i64toi32_i32$1 = $45 + (var$2 >>> 16 | 0) | 0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = i64toi32_i32$1 << i64toi32_i32$4 | 0;
   $24 = 0;
  } else {
   i64toi32_i32$0 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$1 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$2 << i64toi32_i32$4 | 0) | 0;
   $24 = i64toi32_i32$1 << i64toi32_i32$4 | 0;
  }
  $56$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  $62$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $56$hi;
  i64toi32_i32$2 = $24;
  i64toi32_i32$1 = $62$hi;
  i64toi32_i32$3 = var$2 << 16 | 0 | (var$6 & 65535 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$0 | i64toi32_i32$1 | 0;
  i64toi32_i32$2 = i64toi32_i32$2 | i64toi32_i32$3 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$2 | 0;
 }
 
 function _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$1 = 0, i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, i64toi32_i32$0 = 0, i64toi32_i32$5 = 0, var$2 = 0, var$2$hi = 0, i64toi32_i32$6 = 0, $21 = 0, $22 = 0, $23 = 0, $7$hi = 0, $9 = 0, $9$hi = 0, $14$hi = 0, $16$hi = 0, $17 = 0, $17$hi = 0, $23$hi = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$2 = var$0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
   $21 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
   $21 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  var$2 = $21;
  var$2$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$0 = var$2;
  i64toi32_i32$2 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$2 | 0;
  $7$hi = i64toi32_i32$2;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$1 = i64toi32_i32$0 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$0 = var$2$hi;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$4 = i64toi32_i32$1 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$5 = i64toi32_i32$6 + i64toi32_i32$0 | 0;
  i64toi32_i32$5 = i64toi32_i32$2 - i64toi32_i32$5 | 0;
  $9 = i64toi32_i32$4;
  $9$hi = i64toi32_i32$5;
  i64toi32_i32$5 = var$1$hi;
  i64toi32_i32$2 = var$1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$0 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$5 >> 31 | 0;
   $22 = i64toi32_i32$5 >> i64toi32_i32$0 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$5 >> i64toi32_i32$0 | 0;
   $22 = (((1 << i64toi32_i32$0 | 0) - 1 | 0) & i64toi32_i32$5 | 0) << (32 - i64toi32_i32$0 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$0 | 0) | 0;
  }
  var$2 = $22;
  var$2$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$5 = var$2;
  i64toi32_i32$2 = var$1$hi;
  i64toi32_i32$3 = var$1;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$2 | 0;
  $14$hi = i64toi32_i32$2;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$2 = $14$hi;
  i64toi32_i32$1 = i64toi32_i32$5 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$5 = var$2$hi;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$0 = i64toi32_i32$1 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$4 = i64toi32_i32$6 + i64toi32_i32$5 | 0;
  i64toi32_i32$4 = i64toi32_i32$2 - i64toi32_i32$4 | 0;
  $16$hi = i64toi32_i32$4;
  i64toi32_i32$4 = $9$hi;
  i64toi32_i32$1 = $16$hi;
  i64toi32_i32$1 = __wasm_i64_udiv($9 | 0, i64toi32_i32$4 | 0, i64toi32_i32$0 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$4 = i64toi32_i32$HIGH_BITS;
  $17 = i64toi32_i32$1;
  $17$hi = i64toi32_i32$4;
  i64toi32_i32$4 = var$1$hi;
  i64toi32_i32$4 = var$0$hi;
  i64toi32_i32$4 = var$1$hi;
  i64toi32_i32$2 = var$1;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$1 = i64toi32_i32$4 ^ i64toi32_i32$1 | 0;
  i64toi32_i32$4 = i64toi32_i32$2 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$5 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = i64toi32_i32$1 >> 31 | 0;
   $23 = i64toi32_i32$1 >> i64toi32_i32$5 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$1 >> i64toi32_i32$5 | 0;
   $23 = (((1 << i64toi32_i32$5 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$5 | 0) | 0 | (i64toi32_i32$4 >>> i64toi32_i32$5 | 0) | 0;
  }
  var$0 = $23;
  var$0$hi = i64toi32_i32$2;
  i64toi32_i32$2 = $17$hi;
  i64toi32_i32$1 = $17;
  i64toi32_i32$4 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$4 = i64toi32_i32$2 ^ i64toi32_i32$4 | 0;
  $23$hi = i64toi32_i32$4;
  i64toi32_i32$4 = var$0$hi;
  i64toi32_i32$4 = $23$hi;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$5 = i64toi32_i32$2 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$0 = i64toi32_i32$6 + i64toi32_i32$1 | 0;
  i64toi32_i32$0 = i64toi32_i32$4 - i64toi32_i32$0 | 0;
  i64toi32_i32$2 = i64toi32_i32$5;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$2 | 0;
 }
 
 function _ZN17compiler_builtins3int4sdiv3Mod4mod_17h2cbb7bbf36e41d68E(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$3 = 0, i64toi32_i32$5 = 0, var$2$hi = 0, i64toi32_i32$6 = 0, var$2 = 0, $20 = 0, $21 = 0, $7$hi = 0, $9 = 0, $9$hi = 0, $14$hi = 0, $16$hi = 0, $17$hi = 0, $19$hi = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$2 = var$0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
   $20 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
   $20 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  var$2 = $20;
  var$2$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$0 = var$2;
  i64toi32_i32$2 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$2 | 0;
  $7$hi = i64toi32_i32$2;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$1 = i64toi32_i32$0 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$0 = var$2$hi;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$4 = i64toi32_i32$1 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$5 = i64toi32_i32$6 + i64toi32_i32$0 | 0;
  i64toi32_i32$5 = i64toi32_i32$2 - i64toi32_i32$5 | 0;
  $9 = i64toi32_i32$4;
  $9$hi = i64toi32_i32$5;
  i64toi32_i32$5 = var$1$hi;
  i64toi32_i32$2 = var$1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$0 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$5 >> 31 | 0;
   $21 = i64toi32_i32$5 >> i64toi32_i32$0 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$5 >> i64toi32_i32$0 | 0;
   $21 = (((1 << i64toi32_i32$0 | 0) - 1 | 0) & i64toi32_i32$5 | 0) << (32 - i64toi32_i32$0 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$0 | 0) | 0;
  }
  var$0 = $21;
  var$0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$5 = var$0;
  i64toi32_i32$2 = var$1$hi;
  i64toi32_i32$3 = var$1;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$2 | 0;
  $14$hi = i64toi32_i32$2;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$2 = $14$hi;
  i64toi32_i32$1 = i64toi32_i32$5 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$5 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$0 = i64toi32_i32$1 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$4 = i64toi32_i32$6 + i64toi32_i32$5 | 0;
  i64toi32_i32$4 = i64toi32_i32$2 - i64toi32_i32$4 | 0;
  $16$hi = i64toi32_i32$4;
  i64toi32_i32$4 = $9$hi;
  i64toi32_i32$1 = $16$hi;
  i64toi32_i32$1 = __wasm_i64_urem($9 | 0, i64toi32_i32$4 | 0, i64toi32_i32$0 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$4 = i64toi32_i32$HIGH_BITS;
  $17$hi = i64toi32_i32$4;
  i64toi32_i32$4 = var$2$hi;
  i64toi32_i32$4 = $17$hi;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$1 = i64toi32_i32$4 ^ i64toi32_i32$1 | 0;
  $19$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$1 = $19$hi;
  i64toi32_i32$4 = i64toi32_i32$2 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$2 = var$2$hi;
  i64toi32_i32$5 = i64toi32_i32$4 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$4 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$0 = i64toi32_i32$6 + i64toi32_i32$2 | 0;
  i64toi32_i32$0 = i64toi32_i32$1 - i64toi32_i32$0 | 0;
  i64toi32_i32$4 = i64toi32_i32$5;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$4 | 0;
 }
 
 function _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$5 = 0, var$2 = 0, var$3 = 0, var$4 = 0, var$5 = 0, var$5$hi = 0, var$6 = 0, var$6$hi = 0, i64toi32_i32$6 = 0, $37 = 0, $38 = 0, $39 = 0, $40 = 0, $41 = 0, $42 = 0, $43 = 0, $44 = 0, var$8$hi = 0, $45 = 0, $46 = 0, $47 = 0, $48 = 0, var$7$hi = 0, $49 = 0, $63$hi = 0, $65 = 0, $65$hi = 0, $120$hi = 0, $129$hi = 0, $134$hi = 0, var$8 = 0, $140 = 0, $140$hi = 0, $142$hi = 0, $144 = 0, $144$hi = 0, $151 = 0, $151$hi = 0, $154$hi = 0, var$7 = 0, $165$hi = 0;
  label$1 : {
   label$2 : {
    label$3 : {
     label$4 : {
      label$5 : {
       label$6 : {
        label$7 : {
         label$8 : {
          label$9 : {
           label$10 : {
            label$11 : {
             i64toi32_i32$0 = var$0$hi;
             i64toi32_i32$2 = var$0;
             i64toi32_i32$1 = 0;
             i64toi32_i32$3 = 32;
             i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
             if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
              i64toi32_i32$1 = 0;
              $37 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
             } else {
              i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
              $37 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
             }
             var$2 = $37;
             if (var$2) {
              i64toi32_i32$1 = var$1$hi;
              var$3 = var$1;
              if (!var$3) {
               break label$11
              }
              i64toi32_i32$0 = var$3;
              i64toi32_i32$2 = 0;
              i64toi32_i32$3 = 32;
              i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
              if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
               i64toi32_i32$2 = 0;
               $38 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
              } else {
               i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
               $38 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$0 >>> i64toi32_i32$4 | 0) | 0;
              }
              var$4 = $38;
              if (!var$4) {
               break label$9
              }
              var$2 = Math_clz32(var$4) - Math_clz32(var$2) | 0;
              if (var$2 >>> 0 <= 31 >>> 0) {
               break label$8
              }
              break label$2;
             }
             i64toi32_i32$2 = var$1$hi;
             i64toi32_i32$1 = var$1;
             i64toi32_i32$0 = 1;
             i64toi32_i32$3 = 0;
             if (i64toi32_i32$2 >>> 0 > i64toi32_i32$0 >>> 0 | ((i64toi32_i32$2 | 0) == (i64toi32_i32$0 | 0) & i64toi32_i32$1 >>> 0 >= i64toi32_i32$3 >>> 0 | 0) | 0) {
              break label$2
             }
             i64toi32_i32$1 = var$0$hi;
             var$2 = var$0;
             i64toi32_i32$1 = i64toi32_i32$2;
             i64toi32_i32$1 = i64toi32_i32$2;
             var$3 = var$1;
             var$2 = (var$2 >>> 0) / (var$3 >>> 0) | 0;
             i64toi32_i32$1 = 0;
             __wasm_intrinsics_temp_i64 = var$0 - Math_imul(var$2, var$3) | 0;
             __wasm_intrinsics_temp_i64$hi = i64toi32_i32$1;
             i64toi32_i32$1 = 0;
             i64toi32_i32$2 = var$2;
             i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
             return i64toi32_i32$2 | 0;
            }
            i64toi32_i32$2 = var$1$hi;
            i64toi32_i32$3 = var$1;
            i64toi32_i32$1 = 0;
            i64toi32_i32$0 = 32;
            i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
            if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
             i64toi32_i32$1 = 0;
             $39 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
            } else {
             i64toi32_i32$1 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
             $39 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$2 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$3 >>> i64toi32_i32$4 | 0) | 0;
            }
            var$3 = $39;
            i64toi32_i32$1 = var$0$hi;
            if (!var$0) {
             break label$7
            }
            if (!var$3) {
             break label$6
            }
            var$4 = var$3 + -1 | 0;
            if (var$4 & var$3 | 0) {
             break label$6
            }
            i64toi32_i32$1 = 0;
            i64toi32_i32$2 = var$4 & var$2 | 0;
            i64toi32_i32$3 = 0;
            i64toi32_i32$0 = 32;
            i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
            if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
             i64toi32_i32$3 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
             $40 = 0;
            } else {
             i64toi32_i32$3 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
             $40 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
            }
            $63$hi = i64toi32_i32$3;
            i64toi32_i32$3 = var$0$hi;
            i64toi32_i32$1 = var$0;
            i64toi32_i32$2 = 0;
            i64toi32_i32$0 = -1;
            i64toi32_i32$2 = i64toi32_i32$3 & i64toi32_i32$2 | 0;
            $65 = i64toi32_i32$1 & i64toi32_i32$0 | 0;
            $65$hi = i64toi32_i32$2;
            i64toi32_i32$2 = $63$hi;
            i64toi32_i32$3 = $40;
            i64toi32_i32$1 = $65$hi;
            i64toi32_i32$0 = $65;
            i64toi32_i32$1 = i64toi32_i32$2 | i64toi32_i32$1 | 0;
            __wasm_intrinsics_temp_i64 = i64toi32_i32$3 | i64toi32_i32$0 | 0;
            __wasm_intrinsics_temp_i64$hi = i64toi32_i32$1;
            i64toi32_i32$1 = 0;
            i64toi32_i32$3 = var$2 >>> ((__wasm_ctz_i32(var$3 | 0) | 0) & 31 | 0) | 0;
            i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
            return i64toi32_i32$3 | 0;
           }
          }
          var$4 = var$3 + -1 | 0;
          if (!(var$4 & var$3 | 0)) {
           break label$5
          }
          var$2 = (Math_clz32(var$3) + 33 | 0) - Math_clz32(var$2) | 0;
          var$3 = 0 - var$2 | 0;
          break label$3;
         }
         var$3 = 63 - var$2 | 0;
         var$2 = var$2 + 1 | 0;
         break label$3;
        }
        var$4 = (var$2 >>> 0) / (var$3 >>> 0) | 0;
        i64toi32_i32$3 = 0;
        i64toi32_i32$2 = var$2 - Math_imul(var$4, var$3) | 0;
        i64toi32_i32$1 = 0;
        i64toi32_i32$0 = 32;
        i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
         $41 = 0;
        } else {
         i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
         $41 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
        }
        __wasm_intrinsics_temp_i64 = $41;
        __wasm_intrinsics_temp_i64$hi = i64toi32_i32$1;
        i64toi32_i32$1 = 0;
        i64toi32_i32$2 = var$4;
        i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
        return i64toi32_i32$2 | 0;
       }
       var$2 = Math_clz32(var$3) - Math_clz32(var$2) | 0;
       if (var$2 >>> 0 < 31 >>> 0) {
        break label$4
       }
       break label$2;
      }
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$2 = 0;
      __wasm_intrinsics_temp_i64 = var$4 & var$0 | 0;
      __wasm_intrinsics_temp_i64$hi = i64toi32_i32$2;
      if ((var$3 | 0) == (1 | 0)) {
       break label$1
      }
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$2 = 0;
      $120$hi = i64toi32_i32$2;
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$3 = var$0;
      i64toi32_i32$1 = $120$hi;
      i64toi32_i32$0 = __wasm_ctz_i32(var$3 | 0) | 0;
      i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
      if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
       i64toi32_i32$1 = 0;
       $42 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
      } else {
       i64toi32_i32$1 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
       $42 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$2 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$3 >>> i64toi32_i32$4 | 0) | 0;
      }
      i64toi32_i32$3 = $42;
      i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
      return i64toi32_i32$3 | 0;
     }
     var$3 = 63 - var$2 | 0;
     var$2 = var$2 + 1 | 0;
    }
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$3 = 0;
    $129$hi = i64toi32_i32$3;
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$2 = var$0;
    i64toi32_i32$1 = $129$hi;
    i64toi32_i32$0 = var$2 & 63 | 0;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$1 = 0;
     $43 = i64toi32_i32$3 >>> i64toi32_i32$4 | 0;
    } else {
     i64toi32_i32$1 = i64toi32_i32$3 >>> i64toi32_i32$4 | 0;
     $43 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$3 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
    }
    var$5 = $43;
    var$5$hi = i64toi32_i32$1;
    i64toi32_i32$1 = var$0$hi;
    i64toi32_i32$1 = 0;
    $134$hi = i64toi32_i32$1;
    i64toi32_i32$1 = var$0$hi;
    i64toi32_i32$3 = var$0;
    i64toi32_i32$2 = $134$hi;
    i64toi32_i32$0 = var$3 & 63 | 0;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$2 = i64toi32_i32$3 << i64toi32_i32$4 | 0;
     $44 = 0;
    } else {
     i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$3 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
     $44 = i64toi32_i32$3 << i64toi32_i32$4 | 0;
    }
    var$0 = $44;
    var$0$hi = i64toi32_i32$2;
    label$13 : {
     if (var$2) {
      i64toi32_i32$2 = var$1$hi;
      i64toi32_i32$1 = var$1;
      i64toi32_i32$3 = -1;
      i64toi32_i32$0 = -1;
      i64toi32_i32$4 = i64toi32_i32$1 + i64toi32_i32$0 | 0;
      i64toi32_i32$5 = i64toi32_i32$2 + i64toi32_i32$3 | 0;
      if (i64toi32_i32$4 >>> 0 < i64toi32_i32$0 >>> 0) {
       i64toi32_i32$5 = i64toi32_i32$5 + 1 | 0
      }
      var$8 = i64toi32_i32$4;
      var$8$hi = i64toi32_i32$5;
      label$15 : while (1) {
       i64toi32_i32$5 = var$5$hi;
       i64toi32_i32$2 = var$5;
       i64toi32_i32$1 = 0;
       i64toi32_i32$0 = 1;
       i64toi32_i32$3 = i64toi32_i32$0 & 31 | 0;
       if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
        i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$3 | 0;
        $45 = 0;
       } else {
        i64toi32_i32$1 = ((1 << i64toi32_i32$3 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$3 | 0) | 0) | 0 | (i64toi32_i32$5 << i64toi32_i32$3 | 0) | 0;
        $45 = i64toi32_i32$2 << i64toi32_i32$3 | 0;
       }
       $140 = $45;
       $140$hi = i64toi32_i32$1;
       i64toi32_i32$1 = var$0$hi;
       i64toi32_i32$5 = var$0;
       i64toi32_i32$2 = 0;
       i64toi32_i32$0 = 63;
       i64toi32_i32$3 = i64toi32_i32$0 & 31 | 0;
       if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
        i64toi32_i32$2 = 0;
        $46 = i64toi32_i32$1 >>> i64toi32_i32$3 | 0;
       } else {
        i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$3 | 0;
        $46 = (((1 << i64toi32_i32$3 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$3 | 0) | 0 | (i64toi32_i32$5 >>> i64toi32_i32$3 | 0) | 0;
       }
       $142$hi = i64toi32_i32$2;
       i64toi32_i32$2 = $140$hi;
       i64toi32_i32$1 = $140;
       i64toi32_i32$5 = $142$hi;
       i64toi32_i32$0 = $46;
       i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
       var$5 = i64toi32_i32$1 | i64toi32_i32$0 | 0;
       var$5$hi = i64toi32_i32$5;
       $144 = var$5;
       $144$hi = i64toi32_i32$5;
       i64toi32_i32$5 = var$8$hi;
       i64toi32_i32$5 = var$5$hi;
       i64toi32_i32$5 = var$8$hi;
       i64toi32_i32$2 = var$8;
       i64toi32_i32$1 = var$5$hi;
       i64toi32_i32$0 = var$5;
       i64toi32_i32$3 = i64toi32_i32$2 - i64toi32_i32$0 | 0;
       i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$0 >>> 0;
       i64toi32_i32$4 = i64toi32_i32$6 + i64toi32_i32$1 | 0;
       i64toi32_i32$4 = i64toi32_i32$5 - i64toi32_i32$4 | 0;
       i64toi32_i32$5 = i64toi32_i32$3;
       i64toi32_i32$2 = 0;
       i64toi32_i32$0 = 63;
       i64toi32_i32$1 = i64toi32_i32$0 & 31 | 0;
       if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
        i64toi32_i32$2 = i64toi32_i32$4 >> 31 | 0;
        $47 = i64toi32_i32$4 >> i64toi32_i32$1 | 0;
       } else {
        i64toi32_i32$2 = i64toi32_i32$4 >> i64toi32_i32$1 | 0;
        $47 = (((1 << i64toi32_i32$1 | 0) - 1 | 0) & i64toi32_i32$4 | 0) << (32 - i64toi32_i32$1 | 0) | 0 | (i64toi32_i32$5 >>> i64toi32_i32$1 | 0) | 0;
       }
       var$6 = $47;
       var$6$hi = i64toi32_i32$2;
       i64toi32_i32$2 = var$1$hi;
       i64toi32_i32$2 = var$6$hi;
       i64toi32_i32$4 = var$6;
       i64toi32_i32$5 = var$1$hi;
       i64toi32_i32$0 = var$1;
       i64toi32_i32$5 = i64toi32_i32$2 & i64toi32_i32$5 | 0;
       $151 = i64toi32_i32$4 & i64toi32_i32$0 | 0;
       $151$hi = i64toi32_i32$5;
       i64toi32_i32$5 = $144$hi;
       i64toi32_i32$2 = $144;
       i64toi32_i32$4 = $151$hi;
       i64toi32_i32$0 = $151;
       i64toi32_i32$1 = i64toi32_i32$2 - i64toi32_i32$0 | 0;
       i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$0 >>> 0;
       i64toi32_i32$3 = i64toi32_i32$6 + i64toi32_i32$4 | 0;
       i64toi32_i32$3 = i64toi32_i32$5 - i64toi32_i32$3 | 0;
       var$5 = i64toi32_i32$1;
       var$5$hi = i64toi32_i32$3;
       i64toi32_i32$3 = var$0$hi;
       i64toi32_i32$5 = var$0;
       i64toi32_i32$2 = 0;
       i64toi32_i32$0 = 1;
       i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
       if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
        i64toi32_i32$2 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
        $48 = 0;
       } else {
        i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$5 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
        $48 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
       }
       $154$hi = i64toi32_i32$2;
       i64toi32_i32$2 = var$7$hi;
       i64toi32_i32$2 = $154$hi;
       i64toi32_i32$3 = $48;
       i64toi32_i32$5 = var$7$hi;
       i64toi32_i32$0 = var$7;
       i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
       var$0 = i64toi32_i32$3 | i64toi32_i32$0 | 0;
       var$0$hi = i64toi32_i32$5;
       i64toi32_i32$5 = var$6$hi;
       i64toi32_i32$2 = var$6;
       i64toi32_i32$3 = 0;
       i64toi32_i32$0 = 1;
       i64toi32_i32$3 = i64toi32_i32$5 & i64toi32_i32$3 | 0;
       var$6 = i64toi32_i32$2 & i64toi32_i32$0 | 0;
       var$6$hi = i64toi32_i32$3;
       var$7 = var$6;
       var$7$hi = i64toi32_i32$3;
       var$2 = var$2 + -1 | 0;
       if (var$2) {
        continue label$15
       }
       break label$15;
      };
      break label$13;
     }
    }
    i64toi32_i32$3 = var$5$hi;
    __wasm_intrinsics_temp_i64 = var$5;
    __wasm_intrinsics_temp_i64$hi = i64toi32_i32$3;
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$5 = var$0;
    i64toi32_i32$2 = 0;
    i64toi32_i32$0 = 1;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$2 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
     $49 = 0;
    } else {
     i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$5 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
     $49 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
    }
    $165$hi = i64toi32_i32$2;
    i64toi32_i32$2 = var$6$hi;
    i64toi32_i32$2 = $165$hi;
    i64toi32_i32$3 = $49;
    i64toi32_i32$5 = var$6$hi;
    i64toi32_i32$0 = var$6;
    i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
    i64toi32_i32$3 = i64toi32_i32$3 | i64toi32_i32$0 | 0;
    i64toi32_i32$HIGH_BITS = i64toi32_i32$5;
    return i64toi32_i32$3 | 0;
   }
   i64toi32_i32$3 = var$0$hi;
   __wasm_intrinsics_temp_i64 = var$0;
   __wasm_intrinsics_temp_i64$hi = i64toi32_i32$3;
   i64toi32_i32$3 = 0;
   var$0 = 0;
   var$0$hi = i64toi32_i32$3;
  }
  i64toi32_i32$3 = var$0$hi;
  i64toi32_i32$5 = var$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$3;
  return i64toi32_i32$5 | 0;
 }
 
 function __wasm_i64_mul(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function __wasm_i64_sdiv(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function __wasm_i64_srem(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int4sdiv3Mod4mod_17h2cbb7bbf36e41d68E(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function __wasm_i64_udiv(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function __wasm_i64_urem(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$0 = __wasm_intrinsics_temp_i64$hi;
  i64toi32_i32$1 = __wasm_intrinsics_temp_i64;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function __wasm_ctz_i32(var$0) {
  var$0 = var$0 | 0;
  if (var$0) {
   return 31 - Math_clz32((var$0 + -1 | 0) ^ var$0 | 0) | 0 | 0
  }
  return 32 | 0;
 }
 
 bufferView = HEAPU8;
 var FUNCTION_TABLE = [i32_t0, i32_t1, i64_t0, i64_t1, f32_t0, f32_t1, f64_t0, f64_t1];
 function __wasm_memory_size() {
  return buffer.byteLength / 65536 | 0;
 }
 
 function __wasm_memory_grow(pagesToAdd) {
  pagesToAdd = pagesToAdd | 0;
  var oldPages = __wasm_memory_size() | 0;
  var newPages = oldPages + pagesToAdd | 0;
  if ((oldPages < newPages) && (newPages < 65536)) {
   var newBuffer = new ArrayBuffer(Math_imul(newPages, 65536));
   var newHEAP8 = new Int8Array(newBuffer);
   newHEAP8.set(HEAP8);
   HEAP8 = new Int8Array(newBuffer);
   HEAP16 = new Int16Array(newBuffer);
   HEAP32 = new Int32Array(newBuffer);
   HEAPU8 = new Uint8Array(newBuffer);
   HEAPU16 = new Uint16Array(newBuffer);
   HEAPU32 = new Uint32Array(newBuffer);
   HEAPF32 = new Float32Array(newBuffer);
   HEAPF64 = new Float64Array(newBuffer);
   buffer = newBuffer;
   bufferView = HEAPU8;
  }
  return oldPages;
 }
 
 return {
  "i32_add": f0, 
  "i32_sub": f1, 
  "i32_mul": f2, 
  "i32_div_s": f3, 
  "i32_div_u": f4, 
  "i32_rem_s": f5, 
  "i32_rem_u": f6, 
  "i32_and": f7, 
  "i32_or": f8, 
  "i32_xor": f9, 
  "i32_shl": f10, 
  "i32_shr_u": f11, 
  "i32_shr_s": f12, 
  "i32_eq": f13, 
  "i32_ne": f14, 
  "i32_lt_s": f15, 
  "i32_le_s": f16, 
  "i32_lt_u": f17, 
  "i32_le_u": f18, 
  "i32_gt_s": f19, 
  "i32_ge_s": f20, 
  "i32_gt_u": f21, 
  "i32_ge_u": f22, 
  "i32_store": f23, 
  "i32_store8": f24, 
  "i32_store16": f25, 
  "i32_call": f26, 
  "i32_call_indirect": f27, 
  "i32_select": f28, 
  "i64_add": f29, 
  "i64_sub": f30, 
  "i64_mul": f31, 
  "i64_div_s": f32, 
  "i64_div_u": f33, 
  "i64_rem_s": f34, 
  "i64_rem_u": f35, 
  "i64_and": f36, 
  "i64_or": f37, 
  "i64_xor": f38, 
  "i64_shl": f39, 
  "i64_shr_u": f40, 
  "i64_shr_s": f41, 
  "i64_eq": f42, 
  "i64_ne": f43, 
  "i64_lt_s": f44, 
  "i64_le_s": f45, 
  "i64_lt_u": f46, 
  "i64_le_u": f47, 
  "i64_gt_s": f48, 
  "i64_ge_s": f49, 
  "i64_gt_u": f50, 
  "i64_ge_u": f51, 
  "i64_store": f52, 
  "i64_store8": f53, 
  "i64_store16": f54, 
  "i64_store32": f55, 
  "i64_call": f56, 
  "i64_call_indirect": f57, 
  "i64_select": f58, 
  "f32_add": f59, 
  "f32_sub": f60, 
  "f32_mul": f61, 
  "f32_div": f62, 
  "f32_copysign": f63, 
  "f32_eq": f64, 
  "f32_ne": f65, 
  "f32_lt": f66, 
  "f32_le": f67, 
  "f32_gt": f68, 
  "f32_ge": f69, 
  "f32_min": f70, 
  "f32_max": f71, 
  "f32_store": f72, 
  "f32_call": f73, 
  "f32_call_indirect": f74, 
  "f32_select": f75, 
  "f64_add": f76, 
  "f64_sub": f77, 
  "f64_mul": f78, 
  "f64_div": f79, 
  "f64_copysign": f80, 
  "f64_eq": f81, 
  "f64_ne": f82, 
  "f64_lt": f83, 
  "f64_le": f84, 
  "f64_gt": f85, 
  "f64_ge": f86, 
  "f64_min": f87, 
  "f64_max": f88, 
  "f64_store": f89, 
  "f64_call": f90, 
  "f64_call_indirect": f91, 
  "f64_select": f92, 
  "br_if": f93, 
  "br_table": f94
 };
}

var retasmFunc = asmFunc({
});
export var i32_add = retasmFunc.i32_add;
export var i32_sub = retasmFunc.i32_sub;
export var i32_mul = retasmFunc.i32_mul;
export var i32_div_s = retasmFunc.i32_div_s;
export var i32_div_u = retasmFunc.i32_div_u;
export var i32_rem_s = retasmFunc.i32_rem_s;
export var i32_rem_u = retasmFunc.i32_rem_u;
export var i32_and = retasmFunc.i32_and;
export var i32_or = retasmFunc.i32_or;
export var i32_xor = retasmFunc.i32_xor;
export var i32_shl = retasmFunc.i32_shl;
export var i32_shr_u = retasmFunc.i32_shr_u;
export var i32_shr_s = retasmFunc.i32_shr_s;
export var i32_eq = retasmFunc.i32_eq;
export var i32_ne = retasmFunc.i32_ne;
export var i32_lt_s = retasmFunc.i32_lt_s;
export var i32_le_s = retasmFunc.i32_le_s;
export var i32_lt_u = retasmFunc.i32_lt_u;
export var i32_le_u = retasmFunc.i32_le_u;
export var i32_gt_s = retasmFunc.i32_gt_s;
export var i32_ge_s = retasmFunc.i32_ge_s;
export var i32_gt_u = retasmFunc.i32_gt_u;
export var i32_ge_u = retasmFunc.i32_ge_u;
export var i32_store = retasmFunc.i32_store;
export var i32_store8 = retasmFunc.i32_store8;
export var i32_store16 = retasmFunc.i32_store16;
export var i32_call = retasmFunc.i32_call;
export var i32_call_indirect = retasmFunc.i32_call_indirect;
export var i32_select = retasmFunc.i32_select;
export var i64_add = retasmFunc.i64_add;
export var i64_sub = retasmFunc.i64_sub;
export var i64_mul = retasmFunc.i64_mul;
export var i64_div_s = retasmFunc.i64_div_s;
export var i64_div_u = retasmFunc.i64_div_u;
export var i64_rem_s = retasmFunc.i64_rem_s;
export var i64_rem_u = retasmFunc.i64_rem_u;
export var i64_and = retasmFunc.i64_and;
export var i64_or = retasmFunc.i64_or;
export var i64_xor = retasmFunc.i64_xor;
export var i64_shl = retasmFunc.i64_shl;
export var i64_shr_u = retasmFunc.i64_shr_u;
export var i64_shr_s = retasmFunc.i64_shr_s;
export var i64_eq = retasmFunc.i64_eq;
export var i64_ne = retasmFunc.i64_ne;
export var i64_lt_s = retasmFunc.i64_lt_s;
export var i64_le_s = retasmFunc.i64_le_s;
export var i64_lt_u = retasmFunc.i64_lt_u;
export var i64_le_u = retasmFunc.i64_le_u;
export var i64_gt_s = retasmFunc.i64_gt_s;
export var i64_ge_s = retasmFunc.i64_ge_s;
export var i64_gt_u = retasmFunc.i64_gt_u;
export var i64_ge_u = retasmFunc.i64_ge_u;
export var i64_store = retasmFunc.i64_store;
export var i64_store8 = retasmFunc.i64_store8;
export var i64_store16 = retasmFunc.i64_store16;
export var i64_store32 = retasmFunc.i64_store32;
export var i64_call = retasmFunc.i64_call;
export var i64_call_indirect = retasmFunc.i64_call_indirect;
export var i64_select = retasmFunc.i64_select;
export var f32_add = retasmFunc.f32_add;
export var f32_sub = retasmFunc.f32_sub;
export var f32_mul = retasmFunc.f32_mul;
export var f32_div = retasmFunc.f32_div;
export var f32_copysign = retasmFunc.f32_copysign;
export var f32_eq = retasmFunc.f32_eq;
export var f32_ne = retasmFunc.f32_ne;
export var f32_lt = retasmFunc.f32_lt;
export var f32_le = retasmFunc.f32_le;
export var f32_gt = retasmFunc.f32_gt;
export var f32_ge = retasmFunc.f32_ge;
export var f32_min = retasmFunc.f32_min;
export var f32_max = retasmFunc.f32_max;
export var f32_store = retasmFunc.f32_store;
export var f32_call = retasmFunc.f32_call;
export var f32_call_indirect = retasmFunc.f32_call_indirect;
export var f32_select = retasmFunc.f32_select;
export var f64_add = retasmFunc.f64_add;
export var f64_sub = retasmFunc.f64_sub;
export var f64_mul = retasmFunc.f64_mul;
export var f64_div = retasmFunc.f64_div;
export var f64_copysign = retasmFunc.f64_copysign;
export var f64_eq = retasmFunc.f64_eq;
export var f64_ne = retasmFunc.f64_ne;
export var f64_lt = retasmFunc.f64_lt;
export var f64_le = retasmFunc.f64_le;
export var f64_gt = retasmFunc.f64_gt;
export var f64_ge = retasmFunc.f64_ge;
export var f64_min = retasmFunc.f64_min;
export var f64_max = retasmFunc.f64_max;
export var f64_store = retasmFunc.f64_store;
export var f64_call = retasmFunc.f64_call;
export var f64_call_indirect = retasmFunc.f64_call_indirect;
export var f64_select = retasmFunc.f64_select;
export var br_if = retasmFunc.br_if;
export var br_table = retasmFunc.br_table;
