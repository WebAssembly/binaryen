import { getTempRet0 } from 'env';


  var scratchBuffer = new ArrayBuffer(8);
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
      
  function legalimport$wasm2js_scratch_load_i64() {
    if (typeof setTempRet0 === 'function') setTempRet0(i32ScratchView[1]);
    return i32ScratchView[0];
  }
      
  function legalimport$wasm2js_scratch_store_i64(low, high) {
    i32ScratchView[0] = low;
    i32ScratchView[1] = high;
  }
      
  function wasm2js_scratch_store_f32(value) {
    f32ScratchView[0] = value;
  }
      
function asmFunc(global, env, buffer) {
 "almost asm";
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
 var getTempRet0 = env.getTempRet0;
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
 
 function i64_t0($0, $1, $2, $3) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2 = $2 | 0;
  $3 = $3 | 0;
  return -1 | 0;
 }
 
 function i64_t1($0, $1, $2, $3) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2 = $2 | 0;
  $3 = $3 | 0;
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
  var $0 = 0;
  bump();
  HEAP8[8 >> 0] = 1;
  $0 = 0;
  i64toi32_i32$HIGH_BITS = $0;
  return 0 | 0;
 }
 
 function i64_right() {
  var $0 = 0;
  bump();
  HEAP8[8 >> 0] = 2;
  $0 = 0;
  i64toi32_i32$HIGH_BITS = $0;
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
 
 function i64_dummy($0, $1, $2, $3) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2 = $2 | 0;
  $3 = $3 | 0;
 }
 
 function f32_dummy($0, $1) {
  $0 = Math_fround($0);
  $1 = Math_fround($1);
 }
 
 function f64_dummy($0, $1) {
  $0 = +$0;
  $1 = +$1;
 }
 
 function $35() {
  reset();
  (i32_left() | 0) + (i32_right() | 0) | 0;
  return get() | 0 | 0;
 }
 
 function $36() {
  reset();
  (i32_left() | 0) - (i32_right() | 0) | 0;
  return get() | 0 | 0;
 }
 
 function $37() {
  reset();
  Math_imul(i32_left() | 0, i32_right() | 0);
  return get() | 0 | 0;
 }
 
 function $38() {
  reset();
  (i32_left() | 0 | 0) / (i32_right() | 0 | 0) | 0;
  return get() | 0 | 0;
 }
 
 function $39() {
  reset();
  ((i32_left() | 0) >>> 0) / ((i32_right() | 0) >>> 0) | 0;
  return get() | 0 | 0;
 }
 
 function $40() {
  reset();
  (i32_left() | 0 | 0) % (i32_right() | 0 | 0) | 0;
  return get() | 0 | 0;
 }
 
 function $41() {
  reset();
  ((i32_left() | 0) >>> 0) % ((i32_right() | 0) >>> 0) | 0;
  return get() | 0 | 0;
 }
 
 function $42() {
  reset();
  (i32_left() | 0) & (i32_right() | 0) | 0;
  return get() | 0 | 0;
 }
 
 function $43() {
  reset();
  i32_left() | 0 | (i32_right() | 0) | 0;
  return get() | 0 | 0;
 }
 
 function $44() {
  reset();
  (i32_left() | 0) ^ (i32_right() | 0) | 0;
  return get() | 0 | 0;
 }
 
 function $45() {
  reset();
  (i32_left() | 0) << (i32_right() | 0) | 0;
  return get() | 0 | 0;
 }
 
 function $46() {
  reset();
  (i32_left() | 0) >>> (i32_right() | 0) | 0;
  return get() | 0 | 0;
 }
 
 function $47() {
  reset();
  (i32_left() | 0) >> (i32_right() | 0) | 0;
  return get() | 0 | 0;
 }
 
 function $48() {
  reset();
  (i32_left() | 0 | 0) == (i32_right() | 0 | 0);
  return get() | 0 | 0;
 }
 
 function $49() {
  reset();
  (i32_left() | 0 | 0) != (i32_right() | 0 | 0);
  return get() | 0 | 0;
 }
 
 function $50() {
  reset();
  (i32_left() | 0 | 0) < (i32_right() | 0 | 0);
  return get() | 0 | 0;
 }
 
 function $51() {
  reset();
  (i32_left() | 0 | 0) <= (i32_right() | 0 | 0);
  return get() | 0 | 0;
 }
 
 function $52() {
  reset();
  (i32_left() | 0) >>> 0 < (i32_right() | 0) >>> 0;
  return get() | 0 | 0;
 }
 
 function $53() {
  reset();
  (i32_left() | 0) >>> 0 <= (i32_right() | 0) >>> 0;
  return get() | 0 | 0;
 }
 
 function $54() {
  reset();
  (i32_left() | 0 | 0) > (i32_right() | 0 | 0);
  return get() | 0 | 0;
 }
 
 function $55() {
  reset();
  (i32_left() | 0 | 0) >= (i32_right() | 0 | 0);
  return get() | 0 | 0;
 }
 
 function $56() {
  reset();
  (i32_left() | 0) >>> 0 > (i32_right() | 0) >>> 0;
  return get() | 0 | 0;
 }
 
 function $57() {
  reset();
  (i32_left() | 0) >>> 0 >= (i32_right() | 0) >>> 0;
  return get() | 0 | 0;
 }
 
 function $58() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  reset();
  (wasm2js_i32$0 = i32_left() | 0, wasm2js_i32$1 = i32_right() | 0), HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
  return get() | 0 | 0;
 }
 
 function $59() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  reset();
  (wasm2js_i32$0 = i32_left() | 0, wasm2js_i32$1 = i32_right() | 0), HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
  return get() | 0 | 0;
 }
 
 function $60() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  reset();
  (wasm2js_i32$0 = i32_left() | 0, wasm2js_i32$1 = i32_right() | 0), HEAP16[wasm2js_i32$0 >> 1] = wasm2js_i32$1;
  return get() | 0 | 0;
 }
 
 function $61() {
  reset();
  i32_dummy(i32_left() | 0 | 0, i32_right() | 0 | 0);
  return get() | 0 | 0;
 }
 
 function $62() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0;
  reset();
  ((wasm2js_i32$1 = i32_left() | 0, wasm2js_i32$2 = i32_right() | 0), wasm2js_i32$0 = i32_callee() | 0), FUNCTION_TABLE[wasm2js_i32$0](wasm2js_i32$1 | 0, wasm2js_i32$2 | 0) | 0;
  return get() | 0 | 0;
 }
 
 function $63() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0;
  reset();
  wasm2js_i32$0 = i32_left() | 0, wasm2js_i32$1 = i32_right() | 0, wasm2js_i32$2 = i32_bool() | 0, wasm2js_i32$2 ? wasm2js_i32$0 : wasm2js_i32$1;
  return get() | 0 | 0;
 }
 
 function $64() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0;
  reset();
  $0 = i64_left() | 0;
  $1 = i64toi32_i32$HIGH_BITS;
  $4 = $0;
  $2 = $1;
  $1 = i64_right() | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  $3 = $1;
  $1 = $0;
  $0 = $2;
  $2 = $4 + $3 | 0;
  $0 = $0 + $1 | 0;
  $2 >>> 0 < $3 >>> 0;
  return get() | 0 | 0;
 }
 
 function $65() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0;
  reset();
  $1 = i64_left() | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  $2 = $1;
  $4 = $0;
  $0 = i64_right() | 0;
  $1 = i64toi32_i32$HIGH_BITS;
  $3 = $0;
  $0 = $1;
  $1 = $4;
  $0 = ($2 >>> 0 < $3 >>> 0) + $0 | 0;
  return get() | 0 | 0;
 }
 
 function $66() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0;
  reset();
  $1 = i64_left() | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  $2 = $1;
  $3 = $0;
  $0 = i64_right() | 0;
  $1 = i64toi32_i32$HIGH_BITS;
  $4 = $0;
  $0 = $1;
  $1 = $3;
  $0 = __wasm_i64_mul($2 | 0, $1 | 0, $4 | 0, $0 | 0) | 0;
  return get() | 0 | 0;
 }
 
 function $67() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0;
  reset();
  $1 = i64_left() | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  $2 = $1;
  $3 = $0;
  $0 = i64_right() | 0;
  $1 = i64toi32_i32$HIGH_BITS;
  $4 = $0;
  $0 = $1;
  $1 = $3;
  $0 = __wasm_i64_sdiv($2 | 0, $1 | 0, $4 | 0, $0 | 0) | 0;
  return get() | 0 | 0;
 }
 
 function $68() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0;
  reset();
  $1 = i64_left() | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  $2 = $1;
  $3 = $0;
  $0 = i64_right() | 0;
  $1 = i64toi32_i32$HIGH_BITS;
  $4 = $0;
  $0 = $1;
  $1 = $3;
  $0 = __wasm_i64_udiv($2 | 0, $1 | 0, $4 | 0, $0 | 0) | 0;
  return get() | 0 | 0;
 }
 
 function $69() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0;
  reset();
  $1 = i64_left() | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  $2 = $1;
  $3 = $0;
  $0 = i64_right() | 0;
  $1 = i64toi32_i32$HIGH_BITS;
  $4 = $0;
  $0 = $1;
  $1 = $3;
  $0 = __wasm_i64_srem($2 | 0, $1 | 0, $4 | 0, $0 | 0) | 0;
  return get() | 0 | 0;
 }
 
 function $70() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0;
  reset();
  $1 = i64_left() | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  $2 = $1;
  $3 = $0;
  $0 = i64_right() | 0;
  $1 = i64toi32_i32$HIGH_BITS;
  $4 = $0;
  $0 = $1;
  $1 = $3;
  $0 = __wasm_i64_urem($2 | 0, $1 | 0, $4 | 0, $0 | 0) | 0;
  return get() | 0 | 0;
 }
 
 function $71() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0;
  reset();
  $0 = i64_left() | 0;
  $1 = i64toi32_i32$HIGH_BITS;
  $2 = $0;
  $3 = $1;
  $1 = i64_right() | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  $4 = $1;
  $1 = $0;
  $0 = $3;
  return get() | 0 | 0;
 }
 
 function $72() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0;
  reset();
  $0 = i64_left() | 0;
  $1 = i64toi32_i32$HIGH_BITS;
  $2 = $0;
  $3 = $1;
  $1 = i64_right() | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  $4 = $1;
  $1 = $0;
  $0 = $3;
  return get() | 0 | 0;
 }
 
 function $73() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0;
  reset();
  $0 = i64_left() | 0;
  $1 = i64toi32_i32$HIGH_BITS;
  $2 = $0;
  $3 = $1;
  $1 = i64_right() | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  $4 = $1;
  $1 = $0;
  $0 = $3;
  return get() | 0 | 0;
 }
 
 function $74() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0;
  reset();
  $0 = i64_left() | 0;
  $2 = i64toi32_i32$HIGH_BITS;
  $3 = $0;
  $1 = $2;
  $2 = i64_right() | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  $4 = $0;
  $0 = $1;
  $1 = $2 & 31 | 0;
  if (32 >>> 0 <= ($2 & 63 | 0) >>> 0) {
   $0 = 0
  } else {
   $0 = $3 << $1 | 0
  }
  return get() | 0 | 0;
 }
 
 function $75() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0;
  reset();
  $0 = i64_left() | 0;
  $2 = i64toi32_i32$HIGH_BITS;
  $3 = $0;
  $1 = $2;
  $2 = i64_right() | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  $4 = $0;
  $0 = $1;
  $1 = $2 & 31 | 0;
  if (32 >>> 0 <= ($2 & 63 | 0) >>> 0) {
   $0 = $0 >>> $1 | 0
  } else {
   $0 = (((1 << $1 | 0) - 1 | 0) & $0 | 0) << (32 - $1 | 0) | 0 | ($3 >>> $1 | 0) | 0
  }
  return get() | 0 | 0;
 }
 
 function $76() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0;
  reset();
  $0 = i64_left() | 0;
  $2 = i64toi32_i32$HIGH_BITS;
  $3 = $0;
  $1 = $2;
  $2 = i64_right() | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  $4 = $0;
  $0 = $1;
  $1 = $2 & 31 | 0;
  if (32 >>> 0 <= ($2 & 63 | 0) >>> 0) {
   $0 = $0 >> $1 | 0
  } else {
   $0 = (((1 << $1 | 0) - 1 | 0) & $0 | 0) << (32 - $1 | 0) | 0 | ($3 >>> $1 | 0) | 0
  }
  return get() | 0 | 0;
 }
 
 function $77() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0;
  reset();
  $0 = i64_left() | 0;
  $1 = i64toi32_i32$HIGH_BITS;
  $2 = $0;
  $3 = $1;
  $1 = i64_right() | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  $4 = $1;
  $1 = $0;
  $0 = $3;
  return get() | 0 | 0;
 }
 
 function $78() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0;
  reset();
  $0 = i64_left() | 0;
  $1 = i64toi32_i32$HIGH_BITS;
  $2 = $0;
  $3 = $1;
  $1 = i64_right() | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  $4 = $1;
  $1 = $0;
  $0 = $3;
  return get() | 0 | 0;
 }
 
 function $79() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0;
  reset();
  $0 = i64_left() | 0;
  $1 = i64toi32_i32$HIGH_BITS;
  $2 = $0;
  $3 = $1;
  $1 = i64_right() | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  $4 = $1;
  $1 = $0;
  $0 = $3;
  if (($0 | 0) < ($1 | 0)) {
   $0 = 1
  } else {
   if (($0 | 0) <= ($1 | 0)) {
    if ($2 >>> 0 >= $4 >>> 0) {
     $0 = 0
    } else {
     $0 = 1
    }
   } else {
    $0 = 0
   }
  }
  return get() | 0 | 0;
 }
 
 function $80() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0;
  reset();
  $0 = i64_left() | 0;
  $1 = i64toi32_i32$HIGH_BITS;
  $2 = $0;
  $3 = $1;
  $1 = i64_right() | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  $4 = $1;
  $1 = $0;
  $0 = $3;
  if (($0 | 0) < ($1 | 0)) {
   $0 = 1
  } else {
   if (($0 | 0) <= ($1 | 0)) {
    if ($2 >>> 0 > $4 >>> 0) {
     $0 = 0
    } else {
     $0 = 1
    }
   } else {
    $0 = 0
   }
  }
  return get() | 0 | 0;
 }
 
 function $81() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0;
  reset();
  $0 = i64_left() | 0;
  $1 = i64toi32_i32$HIGH_BITS;
  $2 = $0;
  $3 = $1;
  $1 = i64_right() | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  $4 = $1;
  $1 = $0;
  $0 = $3;
  return get() | 0 | 0;
 }
 
 function $82() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0;
  reset();
  $0 = i64_left() | 0;
  $1 = i64toi32_i32$HIGH_BITS;
  $2 = $0;
  $3 = $1;
  $1 = i64_right() | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  $4 = $1;
  $1 = $0;
  $0 = $3;
  return get() | 0 | 0;
 }
 
 function $83() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0;
  reset();
  $0 = i64_left() | 0;
  $1 = i64toi32_i32$HIGH_BITS;
  $2 = $0;
  $3 = $1;
  $1 = i64_right() | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  $4 = $1;
  $1 = $0;
  $0 = $3;
  if (($0 | 0) > ($1 | 0)) {
   $0 = 1
  } else {
   if (($0 | 0) >= ($1 | 0)) {
    if ($2 >>> 0 <= $4 >>> 0) {
     $0 = 0
    } else {
     $0 = 1
    }
   } else {
    $0 = 0
   }
  }
  return get() | 0 | 0;
 }
 
 function $84() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0;
  reset();
  $0 = i64_left() | 0;
  $1 = i64toi32_i32$HIGH_BITS;
  $2 = $0;
  $3 = $1;
  $1 = i64_right() | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  $4 = $1;
  $1 = $0;
  $0 = $3;
  if (($0 | 0) > ($1 | 0)) {
   $0 = 1
  } else {
   if (($0 | 0) >= ($1 | 0)) {
    if ($2 >>> 0 < $4 >>> 0) {
     $0 = 0
    } else {
     $0 = 1
    }
   } else {
    $0 = 0
   }
  }
  return get() | 0 | 0;
 }
 
 function $85() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0;
  reset();
  $0 = i64_left() | 0;
  $1 = i64toi32_i32$HIGH_BITS;
  $2 = $0;
  $3 = $1;
  $1 = i64_right() | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  $4 = $1;
  $1 = $0;
  $0 = $3;
  return get() | 0 | 0;
 }
 
 function $86() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0;
  reset();
  $0 = i64_left() | 0;
  $1 = i64toi32_i32$HIGH_BITS;
  $2 = $0;
  $3 = $1;
  $1 = i64_right() | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  $4 = $1;
  $1 = $0;
  $0 = $3;
  return get() | 0 | 0;
 }
 
 function $87() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0;
  reset();
  $1 = i32_left() | 0;
  $0 = i64_right() | 0;
  $2 = i64toi32_i32$HIGH_BITS;
  $3 = $0;
  $0 = $1;
  HEAP32[$0 >> 2] = $3;
  HEAP32[($0 + 4 | 0) >> 2] = $2;
  return get() | 0 | 0;
 }
 
 function $88() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  reset();
  (wasm2js_i32$0 = i32_left() | 0, wasm2js_i32$1 = i64_right() | 0), HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
  return get() | 0 | 0;
 }
 
 function $89() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  reset();
  (wasm2js_i32$0 = i32_left() | 0, wasm2js_i32$1 = i64_right() | 0), HEAP16[wasm2js_i32$0 >> 1] = wasm2js_i32$1;
  return get() | 0 | 0;
 }
 
 function $90() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  reset();
  (wasm2js_i32$0 = i32_left() | 0, wasm2js_i32$1 = i64_right() | 0), HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
  return get() | 0 | 0;
 }
 
 function $91() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0;
  reset();
  $0 = i64_left() | 0;
  $1 = i64toi32_i32$HIGH_BITS;
  $2 = $0;
  $3 = $1;
  $1 = i64_right() | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  $4 = $1;
  $1 = $0;
  $0 = $3;
  i64_dummy($2 | 0, $0 | 0, $4 | 0, $1 | 0);
  return get() | 0 | 0;
 }
 
 function $92() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0;
  reset();
  $0 = i64_left() | 0;
  $1 = i64toi32_i32$HIGH_BITS;
  $2 = $0;
  $3 = $1;
  $1 = i64_right() | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  $4 = $1;
  $1 = $0;
  $0 = $3;
  FUNCTION_TABLE[i64_callee() | 0]($2, $0, $4, $1) | 0;
  return get() | 0 | 0;
 }
 
 function $93() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0;
  reset();
  $0 = i64_left() | 0;
  $1 = i64toi32_i32$HIGH_BITS;
  $2 = $0;
  $3 = $1;
  $1 = i64_right() | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  $4 = i64_bool() | 0;
  return get() | 0 | 0;
 }
 
 function $94() {
  reset();
  Math_fround(Math_fround(f32_left()) + Math_fround(f32_right()));
  return get() | 0 | 0;
 }
 
 function $95() {
  reset();
  Math_fround(Math_fround(f32_left()) - Math_fround(f32_right()));
  return get() | 0 | 0;
 }
 
 function $96() {
  reset();
  Math_fround(Math_fround(f32_left()) * Math_fround(f32_right()));
  return get() | 0 | 0;
 }
 
 function $97() {
  reset();
  Math_fround(Math_fround(f32_left()) / Math_fround(f32_right()));
  return get() | 0 | 0;
 }
 
 function $98() {
  reset();
  (wasm2js_scratch_store_f32(Math_fround(f32_left())), wasm2js_scratch_load_i32(0)) & 2147483647 | 0 | ((wasm2js_scratch_store_f32(Math_fround(f32_right())), wasm2js_scratch_load_i32(0)) & -2147483648 | 0) | 0;
  return get() | 0 | 0;
 }
 
 function $99() {
  reset();
  Math_fround(f32_left()) == Math_fround(f32_right());
  return get() | 0 | 0;
 }
 
 function $100() {
  reset();
  Math_fround(f32_left()) != Math_fround(f32_right());
  return get() | 0 | 0;
 }
 
 function $101() {
  reset();
  Math_fround(f32_left()) < Math_fround(f32_right());
  return get() | 0 | 0;
 }
 
 function $102() {
  reset();
  Math_fround(f32_left()) <= Math_fround(f32_right());
  return get() | 0 | 0;
 }
 
 function $103() {
  reset();
  Math_fround(f32_left()) > Math_fround(f32_right());
  return get() | 0 | 0;
 }
 
 function $104() {
  reset();
  Math_fround(f32_left()) >= Math_fround(f32_right());
  return get() | 0 | 0;
 }
 
 function $105() {
  reset();
  Math_fround(Math_min(Math_fround(f32_left()), Math_fround(f32_right())));
  return get() | 0 | 0;
 }
 
 function $106() {
  reset();
  Math_fround(Math_max(Math_fround(f32_left()), Math_fround(f32_right())));
  return get() | 0 | 0;
 }
 
 function $107() {
  var wasm2js_i32$0 = 0, wasm2js_f32$0 = Math_fround(0);
  reset();
  (wasm2js_i32$0 = i32_left() | 0, wasm2js_f32$0 = Math_fround(f32_right())), HEAPF32[wasm2js_i32$0 >> 2] = wasm2js_f32$0;
  return get() | 0 | 0;
 }
 
 function $108() {
  reset();
  f32_dummy(Math_fround(Math_fround(f32_left())), Math_fround(Math_fround(f32_right())));
  return get() | 0 | 0;
 }
 
 function $109() {
  var wasm2js_i32$0 = 0, wasm2js_f32$0 = Math_fround(0), wasm2js_f32$1 = Math_fround(0);
  reset();
  ((wasm2js_f32$0 = Math_fround(f32_left()), wasm2js_f32$1 = Math_fround(f32_right())), wasm2js_i32$0 = f32_callee() | 0), FUNCTION_TABLE[wasm2js_i32$0](Math_fround(wasm2js_f32$0), Math_fround(wasm2js_f32$1)) | 0;
  return get() | 0 | 0;
 }
 
 function $110() {
  var wasm2js_f32$0 = Math_fround(0), wasm2js_f32$1 = Math_fround(0), wasm2js_i32$0 = 0;
  reset();
  wasm2js_f32$0 = Math_fround(f32_left()), wasm2js_f32$1 = Math_fround(f32_right()), wasm2js_i32$0 = f32_bool() | 0, wasm2js_i32$0 ? wasm2js_f32$0 : wasm2js_f32$1;
  return get() | 0 | 0;
 }
 
 function $111() {
  reset();
  +f64_left() + +f64_right();
  return get() | 0 | 0;
 }
 
 function $112() {
  reset();
  +f64_left() - +f64_right();
  return get() | 0 | 0;
 }
 
 function $113() {
  reset();
  +f64_left() * +f64_right();
  return get() | 0 | 0;
 }
 
 function $114() {
  reset();
  +f64_left() / +f64_right();
  return get() | 0 | 0;
 }
 
 function $115() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0, $5 = 0;
  reset();
  wasm2js_scratch_store_f64(+(+f64_left()));
  $0 = wasm2js_scratch_load_i32(1 | 0) | 0;
  $1 = wasm2js_scratch_load_i32(0 | 0) | 0;
  $2 = 2147483647;
  $3 = -1;
  $2 = $0 & $2 | 0;
  $4 = $1 & $3 | 0;
  $5 = $2;
  wasm2js_scratch_store_f64(+(+f64_right()));
  $2 = wasm2js_scratch_load_i32(1 | 0) | 0;
  $0 = wasm2js_scratch_load_i32(0 | 0) | 0;
  $1 = -2147483648;
  $3 = 0;
  $1 = $2 & $1 | 0;
  $3 = $0 & $3 | 0;
  $0 = $1;
  $1 = $5;
  $2 = $4;
  $0 = $1 | $0 | 0;
  wasm2js_scratch_store_i32(0 | 0, $2 | $3 | 0 | 0);
  wasm2js_scratch_store_i32(1 | 0, $0 | 0);
  +wasm2js_scratch_load_f64();
  return get() | 0 | 0;
 }
 
 function $116() {
  reset();
  +f64_left() == +f64_right();
  return get() | 0 | 0;
 }
 
 function $117() {
  reset();
  +f64_left() != +f64_right();
  return get() | 0 | 0;
 }
 
 function $118() {
  reset();
  +f64_left() < +f64_right();
  return get() | 0 | 0;
 }
 
 function $119() {
  reset();
  +f64_left() <= +f64_right();
  return get() | 0 | 0;
 }
 
 function $120() {
  reset();
  +f64_left() > +f64_right();
  return get() | 0 | 0;
 }
 
 function $121() {
  reset();
  +f64_left() >= +f64_right();
  return get() | 0 | 0;
 }
 
 function $122() {
  reset();
  Math_min(+f64_left(), +f64_right());
  return get() | 0 | 0;
 }
 
 function $123() {
  reset();
  Math_max(+f64_left(), +f64_right());
  return get() | 0 | 0;
 }
 
 function $124() {
  var wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  reset();
  (wasm2js_i32$0 = i32_left() | 0, wasm2js_f64$0 = +f64_right()), HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  return get() | 0 | 0;
 }
 
 function $125() {
  reset();
  f64_dummy(+(+f64_left()), +(+f64_right()));
  return get() | 0 | 0;
 }
 
 function $126() {
  var wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0, wasm2js_f64$1 = 0.0;
  reset();
  ((wasm2js_f64$0 = +f64_left(), wasm2js_f64$1 = +f64_right()), wasm2js_i32$0 = f64_callee() | 0), FUNCTION_TABLE[wasm2js_i32$0](+wasm2js_f64$0, +wasm2js_f64$1) | 0;
  return get() | 0 | 0;
 }
 
 function $127() {
  var wasm2js_f64$0 = 0.0, wasm2js_f64$1 = 0.0, wasm2js_i32$0 = 0;
  reset();
  wasm2js_f64$0 = +f64_left(), wasm2js_f64$1 = +f64_right(), wasm2js_i32$0 = f64_bool() | 0, wasm2js_i32$0 ? wasm2js_f64$0 : wasm2js_f64$1;
  return get() | 0 | 0;
 }
 
 function $128() {
  var $0 = 0;
  reset();
  $0 = i32_left() | 0;
  block : {
   if ((i32_right() | 0) & 0 | 0) {
    break block
   }
   $0 = get() | 0;
  }
  return $0 | 0;
 }
 
 function $129() {
  var $0 = 0, $1 = 0;
  reset();
  a : {
   b : {
    $0 = i32_left() | 0;
    $1 = $0;
    switch (i32_right() | 0 | 0) {
    case 0:
     break a;
    default:
     break b;
    };
   }
   $1 = get() | 0;
  }
  return $1 | 0;
 }
 
 function legalfunc$wasm2js_scratch_load_i64() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0;
  $0 = 0;
  $5 = legalimport$wasm2js_scratch_load_i64() | 0;
  $6 = $0;
  $0 = 0;
  $1 = getTempRet0() | 0;
  $2 = 32;
  $3 = $2 & 31 | 0;
  if (32 >>> 0 <= ($2 & 63 | 0) >>> 0) {
   {
    $4 = $1 << $3 | 0;
    $2 = 0;
   }
  } else {
   {
    $4 = ((1 << $3 | 0) - 1 | 0) & ($1 >>> (32 - $3 | 0) | 0) | 0 | ($0 << $3 | 0) | 0;
    $2 = $1 << $3 | 0;
   }
  }
  $1 = $4;
  $4 = $6;
  $0 = $5;
  $1 = $4 | $1 | 0;
  $0 = $0 | $2 | 0;
  i64toi32_i32$HIGH_BITS = $1;
  return $0 | 0;
 }
 
 function legalfunc$wasm2js_scratch_store_i64($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var $2 = 0, $3 = 0, $4 = 0;
  $4 = $0;
  $3 = 32;
  $2 = $3 & 31 | 0;
  if (32 >>> 0 <= ($3 & 63 | 0) >>> 0) {
   $0 = $1 >>> $2 | 0
  } else {
   $0 = (((1 << $2 | 0) - 1 | 0) & $1 | 0) << (32 - $2 | 0) | 0 | ($0 >>> $2 | 0) | 0
  }
  legalimport$wasm2js_scratch_store_i64($4 | 0, $0 | 0);
 }
 
 function _ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE($0, $1, $2, $3) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2 = $2 | 0;
  $3 = $3 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0;
  $5 = $2;
  $9 = $5 >>> 16 | 0;
  $10 = $0 >>> 16 | 0;
  $11 = Math_imul($9, $10);
  $8 = $5;
  $6 = $0;
  $7 = 32;
  $4 = $7 & 31 | 0;
  if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
   $1 = $1 >>> $4 | 0
  } else {
   $1 = (((1 << $4 | 0) - 1 | 0) & $1 | 0) << (32 - $4 | 0) | 0 | ($6 >>> $4 | 0) | 0
  }
  $6 = $11 + Math_imul($8, $1) | 0;
  $1 = $2;
  $7 = 32;
  $4 = $7 & 31 | 0;
  if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
   $1 = $3 >>> $4 | 0
  } else {
   $1 = (((1 << $4 | 0) - 1 | 0) & $3 | 0) << (32 - $4 | 0) | 0 | ($1 >>> $4 | 0) | 0
  }
  $1 = $6 + Math_imul($1, $0) | 0;
  $5 = $5 & 65535 | 0;
  $0 = $0 & 65535 | 0;
  $8 = Math_imul($5, $0);
  $5 = ($8 >>> 16 | 0) + Math_imul($5, $10) | 0;
  $1 = $1 + ($5 >>> 16 | 0) | 0;
  $5 = ($5 & 65535 | 0) + Math_imul($9, $0) | 0;
  $6 = 0;
  $3 = $1 + ($5 >>> 16 | 0) | 0;
  $7 = 32;
  $4 = $7 & 31 | 0;
  if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
   {
    $1 = $3 << $4 | 0;
    $6 = 0;
   }
  } else {
   {
    $1 = ((1 << $4 | 0) - 1 | 0) & ($3 >>> (32 - $4 | 0) | 0) | 0 | ($6 << $4 | 0) | 0;
    $6 = $3 << $4 | 0;
   }
  }
  $0 = $1;
  $1 = 0;
  $2 = $1;
  $1 = $0;
  $3 = $2;
  $7 = $5 << 16 | 0 | ($8 & 65535 | 0) | 0;
  $3 = $1 | $3 | 0;
  $6 = $6 | $7 | 0;
  i64toi32_i32$HIGH_BITS = $3;
  return $6 | 0;
 }
 
 function _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E($0, $1, $2, $3) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2 = $2 | 0;
  $3 = $3 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0;
  $8 = $1;
  $7 = $0;
  $6 = 63;
  $5 = $6 & 31 | 0;
  if (32 >>> 0 <= ($6 & 63 | 0) >>> 0) {
   {
    $4 = $8 >> 31 | 0;
    $5 = $8 >> $5 | 0;
   }
  } else {
   {
    $4 = $8 >> $5 | 0;
    $5 = (((1 << $5 | 0) - 1 | 0) & $8 | 0) << (32 - $5 | 0) | 0 | ($7 >>> $5 | 0) | 0;
   }
  }
  $10 = $4;
  $4 = $10;
  $8 = $5;
  $7 = $1;
  $6 = $0;
  $7 = $4 ^ $7 | 0;
  $4 = $8 ^ $6 | 0;
  $8 = $10;
  $6 = $5;
  $5 = $4 - $6 | 0;
  $10 = $4 >>> 0 < $6 >>> 0;
  $9 = $10 + $8 | 0;
  $9 = $7 - $9 | 0;
  $11 = $5;
  $12 = $9;
  $9 = $3;
  $7 = $2;
  $6 = 63;
  $8 = $6 & 31 | 0;
  if (32 >>> 0 <= ($6 & 63 | 0) >>> 0) {
   {
    $4 = $9 >> 31 | 0;
    $5 = $9 >> $8 | 0;
   }
  } else {
   {
    $4 = $9 >> $8 | 0;
    $5 = (((1 << $8 | 0) - 1 | 0) & $9 | 0) << (32 - $8 | 0) | 0 | ($7 >>> $8 | 0) | 0;
   }
  }
  $10 = $4;
  $4 = $10;
  $9 = $5;
  $7 = $3;
  $6 = $2;
  $7 = $4 ^ $7 | 0;
  $4 = $9 ^ $6 | 0;
  $9 = $10;
  $6 = $5;
  $8 = $4 - $6 | 0;
  $10 = $4 >>> 0 < $6 >>> 0;
  $5 = $10 + $9 | 0;
  $5 = $7 - $5 | 0;
  $4 = $5;
  $5 = $12;
  $4 = __wasm_i64_udiv($11 | 0, $5 | 0, $8 | 0, $4 | 0) | 0;
  $5 = i64toi32_i32$HIGH_BITS;
  $10 = $4;
  $8 = $5;
  $5 = $3;
  $7 = $2;
  $4 = $1;
  $6 = $0;
  $4 = $5 ^ $4 | 0;
  $5 = $7 ^ $6 | 0;
  $6 = 63;
  $9 = $6 & 31 | 0;
  if (32 >>> 0 <= ($6 & 63 | 0) >>> 0) {
   {
    $7 = $4 >> 31 | 0;
    $0 = $4 >> $9 | 0;
   }
  } else {
   {
    $7 = $4 >> $9 | 0;
    $0 = (((1 << $9 | 0) - 1 | 0) & $4 | 0) << (32 - $9 | 0) | 0 | ($5 >>> $9 | 0) | 0;
   }
  }
  $1 = $7;
  $7 = $8;
  $4 = $10;
  $5 = $1;
  $6 = $0;
  $5 = $7 ^ $5 | 0;
  $7 = $4 ^ $6 | 0;
  $4 = $1;
  $9 = $7 - $6 | 0;
  $10 = $7 >>> 0 < $6 >>> 0;
  $8 = $10 + $4 | 0;
  $8 = $5 - $8 | 0;
  $7 = $9;
  i64toi32_i32$HIGH_BITS = $8;
  return $7 | 0;
 }
 
 function _ZN17compiler_builtins3int4sdiv3Mod4mod_17h2cbb7bbf36e41d68E($0, $1, $2, $3) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2 = $2 | 0;
  $3 = $3 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0, $13 = 0;
  $5 = $1;
  $8 = $0;
  $7 = 63;
  $6 = $7 & 31 | 0;
  if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
   {
    $4 = $5 >> 31 | 0;
    $11 = $5 >> $6 | 0;
   }
  } else {
   {
    $4 = $5 >> $6 | 0;
    $11 = (((1 << $6 | 0) - 1 | 0) & $5 | 0) << (32 - $6 | 0) | 0 | ($8 >>> $6 | 0) | 0;
   }
  }
  $10 = $4;
  $4 = $10;
  $5 = $11;
  $8 = $1;
  $7 = $0;
  $8 = $4 ^ $8 | 0;
  $4 = $5 ^ $7 | 0;
  $5 = $10;
  $7 = $11;
  $6 = $4 - $7 | 0;
  $0 = $4 >>> 0 < $7 >>> 0;
  $9 = $0 + $5 | 0;
  $9 = $8 - $9 | 0;
  $12 = $6;
  $13 = $9;
  $9 = $3;
  $8 = $2;
  $7 = 63;
  $5 = $7 & 31 | 0;
  if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
   {
    $4 = $9 >> 31 | 0;
    $0 = $9 >> $5 | 0;
   }
  } else {
   {
    $4 = $9 >> $5 | 0;
    $0 = (((1 << $5 | 0) - 1 | 0) & $9 | 0) << (32 - $5 | 0) | 0 | ($8 >>> $5 | 0) | 0;
   }
  }
  $1 = $4;
  $4 = $1;
  $9 = $0;
  $8 = $3;
  $7 = $2;
  $8 = $4 ^ $8 | 0;
  $4 = $9 ^ $7 | 0;
  $9 = $1;
  $7 = $0;
  $5 = $4 - $7 | 0;
  $0 = $4 >>> 0 < $7 >>> 0;
  $6 = $0 + $9 | 0;
  $6 = $8 - $6 | 0;
  $4 = $6;
  $6 = $13;
  $4 = __wasm_i64_urem($12 | 0, $6 | 0, $5 | 0, $4 | 0) | 0;
  $6 = i64toi32_i32$HIGH_BITS;
  $8 = $4;
  $4 = $10;
  $7 = $11;
  $4 = $6 ^ $4 | 0;
  $6 = $8 ^ $7 | 0;
  $8 = $10;
  $9 = $6 - $7 | 0;
  $0 = $6 >>> 0 < $7 >>> 0;
  $5 = $0 + $8 | 0;
  $5 = $4 - $5 | 0;
  $6 = $9;
  i64toi32_i32$HIGH_BITS = $5;
  return $6 | 0;
 }
 
 function _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0, $1, $2, $3) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2 = $2 | 0;
  $3 = $3 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0, $13 = 0, $14 = 0, $15 = 0, $16 = 0, $17 = 0, $18 = 0, $19 = 0, $20 = 0;
  label$1 : {
   label$2 : {
    label$3 : {
     label$4 : {
      label$5 : {
       label$6 : {
        label$7 : {
         label$8 : {
          label$9 : {
           label$11 : {
            $7 = $1;
            $5 = $0;
            $4 = 32;
            $6 = $4 & 31 | 0;
            if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
             $10 = $7 >>> $6 | 0
            } else {
             $10 = (((1 << $6 | 0) - 1 | 0) & $7 | 0) << (32 - $6 | 0) | 0 | ($5 >>> $6 | 0) | 0
            }
            if ($10) {
             {
              $8 = $2;
              if (!$8) {
               break label$11
              }
              $9 = $3;
              $7 = $2;
              $4 = 32;
              $6 = $4 & 31 | 0;
              if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
               $11 = $9 >>> $6 | 0
              } else {
               $11 = (((1 << $6 | 0) - 1 | 0) & $9 | 0) << (32 - $6 | 0) | 0 | ($7 >>> $6 | 0) | 0
              }
              if (!$11) {
               break label$9
              }
              $10 = Math_clz32($11) - Math_clz32($10) | 0;
              if ($10 >>> 0 <= 31 >>> 0) {
               break label$8
              }
              break label$2;
             }
            }
            $5 = $3;
            $9 = $2;
            $7 = 1;
            $4 = 0;
            if ($5 >>> 0 > $7 >>> 0 | (($5 | 0) == ($7 | 0) & $9 >>> 0 >= $4 >>> 0 | 0) | 0) {
             break label$2
            }
            $10 = $0;
            $8 = $2;
            $10 = ($10 >>> 0) / ($8 >>> 0) | 0;
            $9 = 0;
            legalfunc$wasm2js_scratch_store_i64($0 - Math_imul($10, $8) | 0 | 0, $9 | 0);
            $9 = 0;
            $5 = $10;
            i64toi32_i32$HIGH_BITS = $9;
            return $5 | 0;
           }
           $5 = $3;
           $4 = $2;
           $7 = 32;
           $6 = $7 & 31 | 0;
           if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
            $8 = $5 >>> $6 | 0
           } else {
            $8 = (((1 << $6 | 0) - 1 | 0) & $5 | 0) << (32 - $6 | 0) | 0 | ($4 >>> $6 | 0) | 0
           }
           if (!$0) {
            break label$7
           }
           if (!$8) {
            break label$6
           }
           $11 = $8 + -1 | 0;
           if ($11 & $8 | 0) {
            break label$6
           }
           $9 = 0;
           $5 = $11 & $10 | 0;
           $7 = 32;
           $6 = $7 & 31 | 0;
           if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
            {
             $4 = $5 << $6 | 0;
             $3 = 0;
            }
           } else {
            {
             $4 = ((1 << $6 | 0) - 1 | 0) & ($5 >>> (32 - $6 | 0) | 0) | 0 | ($9 << $6 | 0) | 0;
             $3 = $5 << $6 | 0;
            }
           }
           $2 = $4;
           $4 = $1;
           $9 = $0;
           $5 = 0;
           $7 = -1;
           $5 = $4 & $5 | 0;
           $7 = $9 & $7 | 0;
           $9 = $5;
           $5 = $2;
           $4 = $3;
           $9 = $5 | $9 | 0;
           legalfunc$wasm2js_scratch_store_i64($4 | $7 | 0 | 0, $9 | 0);
           $9 = 0;
           $4 = $10 >>> ((__wasm_ctz_i32($8 | 0) | 0) & 31 | 0) | 0;
           i64toi32_i32$HIGH_BITS = $9;
           return $4 | 0;
          }
          $11 = $8 + -1 | 0;
          if (!($11 & $8 | 0)) {
           break label$5
          }
          $10 = (Math_clz32($8) + 33 | 0) - Math_clz32($10) | 0;
          $8 = 0 - $10 | 0;
          break label$3;
         }
         $8 = 63 - $10 | 0;
         $10 = $10 + 1 | 0;
         break label$3;
        }
        $11 = ($10 >>> 0) / ($8 >>> 0) | 0;
        $4 = 0;
        $5 = $10 - Math_imul($11, $8) | 0;
        $7 = 32;
        $6 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $9 = $5 << $6 | 0;
          $0 = 0;
         }
        } else {
         {
          $9 = ((1 << $6 | 0) - 1 | 0) & ($5 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
          $0 = $5 << $6 | 0;
         }
        }
        legalfunc$wasm2js_scratch_store_i64($0 | 0, $9 | 0);
        $9 = 0;
        $5 = $11;
        i64toi32_i32$HIGH_BITS = $9;
        return $5 | 0;
       }
       $10 = Math_clz32($8) - Math_clz32($10) | 0;
       if ($10 >>> 0 < 31 >>> 0) {
        break label$4
       }
       break label$2;
      }
      $5 = 0;
      legalfunc$wasm2js_scratch_store_i64($11 & $0 | 0 | 0, $5 | 0);
      if (($8 | 0) == (1 | 0)) {
       break label$1
      }
      $5 = 0;
      $9 = $5;
      $5 = $1;
      $4 = $0;
      $7 = __wasm_ctz_i32($8 | 0) | 0;
      $6 = $7 & 31 | 0;
      if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
       {
        $9 = 0;
        $4 = $5 >>> $6 | 0;
       }
      } else {
       {
        $9 = $5 >>> $6 | 0;
        $4 = (((1 << $6 | 0) - 1 | 0) & $5 | 0) << (32 - $6 | 0) | 0 | ($4 >>> $6 | 0) | 0;
       }
      }
      i64toi32_i32$HIGH_BITS = $9;
      return $4 | 0;
     }
     $8 = 63 - $10 | 0;
     $10 = $10 + 1 | 0;
    }
    $4 = 0;
    $9 = $4;
    $4 = $1;
    $5 = $0;
    $7 = $10 & 63 | 0;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $9 = 0;
      $13 = $4 >>> $6 | 0;
     }
    } else {
     {
      $9 = $4 >>> $6 | 0;
      $13 = (((1 << $6 | 0) - 1 | 0) & $4 | 0) << (32 - $6 | 0) | 0 | ($5 >>> $6 | 0) | 0;
     }
    }
    $11 = $9;
    $9 = 0;
    $5 = $9;
    $9 = $1;
    $4 = $0;
    $7 = $8 & 63 | 0;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $5 = $4 << $6 | 0;
      $0 = 0;
     }
    } else {
     {
      $5 = ((1 << $6 | 0) - 1 | 0) & ($4 >>> (32 - $6 | 0) | 0) | 0 | ($9 << $6 | 0) | 0;
      $0 = $4 << $6 | 0;
     }
    }
    $1 = $5;
    label$13 : {
     if ($10) {
      {
       $5 = $3;
       $9 = $2;
       $4 = -1;
       $7 = -1;
       $6 = $9 + $7 | 0;
       $8 = $5 + $4 | 0;
       if ($6 >>> 0 < $7 >>> 0) {
        $8 = $8 + 1 | 0
       }
       $17 = $6;
       $15 = $8;
       label$15 : while (1) {
        $8 = $11;
        $5 = $13;
        $7 = 1;
        $4 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $9 = $5 << $4 | 0;
          $12 = 0;
         }
        } else {
         {
          $9 = ((1 << $4 | 0) - 1 | 0) & ($5 >>> (32 - $4 | 0) | 0) | 0 | ($8 << $4 | 0) | 0;
          $12 = $5 << $4 | 0;
         }
        }
        $11 = $9;
        $9 = $1;
        $8 = $0;
        $7 = 63;
        $4 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = 0;
          $7 = $9 >>> $4 | 0;
         }
        } else {
         {
          $5 = $9 >>> $4 | 0;
          $7 = (((1 << $4 | 0) - 1 | 0) & $9 | 0) << (32 - $4 | 0) | 0 | ($8 >>> $4 | 0) | 0;
         }
        }
        $8 = $5;
        $5 = $11;
        $9 = $12;
        $8 = $5 | $8 | 0;
        $13 = $9 | $7 | 0;
        $11 = $8;
        $18 = $13;
        $19 = $8;
        $8 = $15;
        $5 = $17;
        $9 = $11;
        $7 = $13;
        $4 = $5 - $7 | 0;
        $5 = $5 >>> 0 < $7 >>> 0;
        $6 = $5 + $9 | 0;
        $6 = $8 - $6 | 0;
        $8 = $4;
        $7 = 63;
        $9 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = $6 >> 31 | 0;
          $14 = $6 >> $9 | 0;
         }
        } else {
         {
          $5 = $6 >> $9 | 0;
          $14 = (((1 << $9 | 0) - 1 | 0) & $6 | 0) << (32 - $9 | 0) | 0 | ($8 >>> $9 | 0) | 0;
         }
        }
        $12 = $5;
        $5 = $12;
        $6 = $14;
        $8 = $3;
        $7 = $2;
        $8 = $5 & $8 | 0;
        $7 = $6 & $7 | 0;
        $6 = $8;
        $8 = $19;
        $5 = $18;
        $9 = $5 - $7 | 0;
        $5 = $5 >>> 0 < $7 >>> 0;
        $4 = $5 + $6 | 0;
        $4 = $8 - $4 | 0;
        $13 = $9;
        $11 = $4;
        $4 = $1;
        $8 = $0;
        $7 = 1;
        $6 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = $8 << $6 | 0;
          $4 = 0;
         }
        } else {
         {
          $5 = ((1 << $6 | 0) - 1 | 0) & ($8 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
          $4 = $8 << $6 | 0;
         }
        }
        $8 = $16;
        $7 = $20;
        $8 = $5 | $8 | 0;
        $0 = $4 | $7 | 0;
        $1 = $8;
        $8 = $12;
        $5 = $14;
        $4 = 0;
        $7 = 1;
        $4 = $8 & $4 | 0;
        $14 = $5 & $7 | 0;
        $12 = $4;
        $20 = $14;
        $16 = $4;
        $10 = $10 + -1 | 0;
        if ($10) {
         continue label$15
        }
        break label$15;
       };
       break label$13;
      }
     }
    }
    $4 = $11;
    legalfunc$wasm2js_scratch_store_i64($13 | 0, $4 | 0);
    $4 = $1;
    $8 = $0;
    $7 = 1;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $5 = $8 << $6 | 0;
      $4 = 0;
     }
    } else {
     {
      $5 = ((1 << $6 | 0) - 1 | 0) & ($8 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
      $4 = $8 << $6 | 0;
     }
    }
    $8 = $12;
    $7 = $14;
    $8 = $5 | $8 | 0;
    $4 = $4 | $7 | 0;
    i64toi32_i32$HIGH_BITS = $8;
    return $4 | 0;
   }
   $4 = $1;
   legalfunc$wasm2js_scratch_store_i64($0 | 0, $4 | 0);
   $4 = 0;
   $0 = 0;
   $1 = $4;
  }
  $4 = $1;
  $8 = $0;
  i64toi32_i32$HIGH_BITS = $4;
  return $8 | 0;
 }
 
 function __wasm_i64_mul($0, $1, $2, $3) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2 = $2 | 0;
  $3 = $3 | 0;
  $3 = _ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE($0 | 0, $1 | 0, $2 | 0, $3 | 0) | 0;
  $1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1;
  return $3 | 0;
 }
 
 function __wasm_i64_sdiv($0, $1, $2, $3) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2 = $2 | 0;
  $3 = $3 | 0;
  $3 = _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E($0 | 0, $1 | 0, $2 | 0, $3 | 0) | 0;
  $1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1;
  return $3 | 0;
 }
 
 function __wasm_i64_srem($0, $1, $2, $3) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2 = $2 | 0;
  $3 = $3 | 0;
  $3 = _ZN17compiler_builtins3int4sdiv3Mod4mod_17h2cbb7bbf36e41d68E($0 | 0, $1 | 0, $2 | 0, $3 | 0) | 0;
  $1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1;
  return $3 | 0;
 }
 
 function __wasm_i64_udiv($0, $1, $2, $3) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2 = $2 | 0;
  $3 = $3 | 0;
  $3 = _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0 | 0, $1 | 0, $2 | 0, $3 | 0) | 0;
  $1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1;
  return $3 | 0;
 }
 
 function __wasm_i64_urem($0, $1, $2, $3) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2 = $2 | 0;
  $3 = $3 | 0;
  $3 = _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0 | 0, $1 | 0, $2 | 0, $3 | 0) | 0;
  $1 = legalfunc$wasm2js_scratch_load_i64() | 0;
  $3 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $3;
  return $1 | 0;
 }
 
 function __wasm_ctz_i32($0) {
  $0 = $0 | 0;
  if ($0) {
   return 31 - Math_clz32(($0 + -1 | 0) ^ $0 | 0) | 0 | 0
  }
  return 32 | 0;
 }
 
 var FUNCTION_TABLE = [i32_t0, i32_t1, i64_t0, i64_t1, f32_t0, f32_t1, f64_t0, f64_t1];
 function __wasm_grow_memory(pagesToAdd) {
  pagesToAdd = pagesToAdd | 0;
  var oldPages = __wasm_current_memory() | 0;
  var newPages = oldPages + pagesToAdd | 0;
  if ((oldPages < newPages) && (newPages < 65536)) {
   {
    var newBuffer = new ArrayBuffer(Math_imul(newPages, 65536));
    var newHEAP8 = new global.Int8Array(newBuffer);
    newHEAP8.set(HEAP8);
    HEAP8 = newHEAP8;
    HEAP16 = new global.Int16Array(newBuffer);
    HEAP32 = new global.Int32Array(newBuffer);
    HEAPU8 = new global.Uint8Array(newBuffer);
    HEAPU16 = new global.Uint16Array(newBuffer);
    HEAPU32 = new global.Uint32Array(newBuffer);
    HEAPF32 = new global.Float32Array(newBuffer);
    HEAPF64 = new global.Float64Array(newBuffer);
    buffer = newBuffer;
   }
  }
  return oldPages;
 }
 
 function __wasm_current_memory() {
  return buffer.byteLength / 65536 | 0;
 }
 
 return {
  "i32_add": $35, 
  "i32_sub": $36, 
  "i32_mul": $37, 
  "i32_div_s": $38, 
  "i32_div_u": $39, 
  "i32_rem_s": $40, 
  "i32_rem_u": $41, 
  "i32_and": $42, 
  "i32_or": $43, 
  "i32_xor": $44, 
  "i32_shl": $45, 
  "i32_shr_u": $46, 
  "i32_shr_s": $47, 
  "i32_eq": $48, 
  "i32_ne": $49, 
  "i32_lt_s": $50, 
  "i32_le_s": $51, 
  "i32_lt_u": $52, 
  "i32_le_u": $53, 
  "i32_gt_s": $54, 
  "i32_ge_s": $55, 
  "i32_gt_u": $56, 
  "i32_ge_u": $57, 
  "i32_store": $58, 
  "i32_store8": $59, 
  "i32_store16": $60, 
  "i32_call": $61, 
  "i32_call_indirect": $62, 
  "i32_select": $63, 
  "i64_add": $64, 
  "i64_sub": $65, 
  "i64_mul": $66, 
  "i64_div_s": $67, 
  "i64_div_u": $68, 
  "i64_rem_s": $69, 
  "i64_rem_u": $70, 
  "i64_and": $71, 
  "i64_or": $72, 
  "i64_xor": $73, 
  "i64_shl": $74, 
  "i64_shr_u": $75, 
  "i64_shr_s": $76, 
  "i64_eq": $77, 
  "i64_ne": $78, 
  "i64_lt_s": $79, 
  "i64_le_s": $80, 
  "i64_lt_u": $81, 
  "i64_le_u": $82, 
  "i64_gt_s": $83, 
  "i64_ge_s": $84, 
  "i64_gt_u": $85, 
  "i64_ge_u": $86, 
  "i64_store": $87, 
  "i64_store8": $88, 
  "i64_store16": $89, 
  "i64_store32": $90, 
  "i64_call": $91, 
  "i64_call_indirect": $92, 
  "i64_select": $93, 
  "f32_add": $94, 
  "f32_sub": $95, 
  "f32_mul": $96, 
  "f32_div": $97, 
  "f32_copysign": $98, 
  "f32_eq": $99, 
  "f32_ne": $100, 
  "f32_lt": $101, 
  "f32_le": $102, 
  "f32_gt": $103, 
  "f32_ge": $104, 
  "f32_min": $105, 
  "f32_max": $106, 
  "f32_store": $107, 
  "f32_call": $108, 
  "f32_call_indirect": $109, 
  "f32_select": $110, 
  "f64_add": $111, 
  "f64_sub": $112, 
  "f64_mul": $113, 
  "f64_div": $114, 
  "f64_copysign": $115, 
  "f64_eq": $116, 
  "f64_ne": $117, 
  "f64_lt": $118, 
  "f64_le": $119, 
  "f64_gt": $120, 
  "f64_ge": $121, 
  "f64_min": $122, 
  "f64_max": $123, 
  "f64_store": $124, 
  "f64_call": $125, 
  "f64_call_indirect": $126, 
  "f64_select": $127, 
  "br_if": $128, 
  "br_table": $129
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },getTempRet0},memasmFunc);
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
