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
  HEAP8[11 | 0] = HEAPU8[10 | 0];
  HEAP8[10 | 0] = HEAPU8[9 | 0];
  HEAP8[9 | 0] = HEAPU8[8 | 0];
  HEAP8[8 | 0] = -3;
 }
 
 function i32_left() {
  bump();
  HEAP8[8 | 0] = 1;
  return 0;
 }
 
 function i32_right() {
  bump();
  HEAP8[8 | 0] = 2;
  return 1;
 }
 
 function i32_bool() {
  bump();
  HEAP8[8 | 0] = 5;
  return 0;
 }
 
 function i64_left() {
  bump();
  HEAP8[8 | 0] = 1;
  i64toi32_i32$HIGH_BITS = 0;
  return 0;
 }
 
 function i64_right() {
  bump();
  HEAP8[8 | 0] = 2;
  i64toi32_i32$HIGH_BITS = 0;
  return 1;
 }
 
 function f32_left() {
  bump();
  HEAP8[8 | 0] = 1;
  return Math_fround(0.0);
 }
 
 function f32_right() {
  bump();
  HEAP8[8 | 0] = 2;
  return Math_fround(1.0);
 }
 
 function f64_left() {
  bump();
  HEAP8[8 | 0] = 1;
  return 0.0;
 }
 
 function f64_right() {
  bump();
  HEAP8[8 | 0] = 2;
  return 1.0;
 }
 
 function $35() {
  reset();
  i32_left() + i32_right() | 0;
  return HEAP32[8 >> 2] | 0;
 }
 
 function $36() {
  reset();
  i32_left() - i32_right() | 0;
  return HEAP32[8 >> 2] | 0;
 }
 
 function $37() {
  reset();
  Math_imul(i32_left(), i32_right());
  return HEAP32[8 >> 2] | 0;
 }
 
 function $38() {
  reset();
  (i32_left() | 0) / (i32_right() | 0) | 0;
  return HEAP32[8 >> 2] | 0;
 }
 
 function $39() {
  reset();
  (i32_left() >>> 0) / (i32_right() >>> 0) | 0;
  return HEAP32[8 >> 2] | 0;
 }
 
 function $40() {
  reset();
  (i32_left() | 0) % (i32_right() | 0) | 0;
  return HEAP32[8 >> 2] | 0;
 }
 
 function $41() {
  reset();
  (i32_left() >>> 0) % (i32_right() >>> 0) | 0;
  return HEAP32[8 >> 2] | 0;
 }
 
 function $42() {
  reset();
  i32_left() & i32_right();
  return HEAP32[8 >> 2] | 0;
 }
 
 function $43() {
  reset();
  i32_left() | i32_right();
  return HEAP32[8 >> 2] | 0;
 }
 
 function $44() {
  reset();
  i32_left() ^ i32_right();
  return HEAP32[8 >> 2] | 0;
 }
 
 function $45() {
  reset();
  i32_left() << i32_right();
  return HEAP32[8 >> 2] | 0;
 }
 
 function $46() {
  reset();
  i32_left() >>> i32_right();
  return HEAP32[8 >> 2] | 0;
 }
 
 function $47() {
  reset();
  i32_left() >> i32_right();
  return HEAP32[8 >> 2] | 0;
 }
 
 function $48() {
  reset();
  (i32_left() | 0) == (i32_right() | 0);
  return HEAP32[8 >> 2] | 0;
 }
 
 function $49() {
  reset();
  (i32_left() | 0) != (i32_right() | 0);
  return HEAP32[8 >> 2] | 0;
 }
 
 function $50() {
  reset();
  (i32_left() | 0) < (i32_right() | 0);
  return HEAP32[8 >> 2] | 0;
 }
 
 function $51() {
  reset();
  (i32_left() | 0) <= (i32_right() | 0);
  return HEAP32[8 >> 2] | 0;
 }
 
 function $52() {
  reset();
  i32_left() >>> 0 < i32_right() >>> 0;
  return HEAP32[8 >> 2] | 0;
 }
 
 function $53() {
  reset();
  i32_left() >>> 0 <= i32_right() >>> 0;
  return HEAP32[8 >> 2] | 0;
 }
 
 function $54() {
  reset();
  (i32_left() | 0) > (i32_right() | 0);
  return HEAP32[8 >> 2] | 0;
 }
 
 function $55() {
  reset();
  (i32_left() | 0) >= (i32_right() | 0);
  return HEAP32[8 >> 2] | 0;
 }
 
 function $56() {
  reset();
  i32_left() >>> 0 > i32_right() >>> 0;
  return HEAP32[8 >> 2] | 0;
 }
 
 function $57() {
  reset();
  i32_left() >>> 0 >= i32_right() >>> 0;
  return HEAP32[8 >> 2] | 0;
 }
 
 function $58() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  reset();
  (wasm2js_i32$0 = i32_left(), wasm2js_i32$1 = i32_right()), HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
  return HEAP32[8 >> 2] | 0;
 }
 
 function $59() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  reset();
  (wasm2js_i32$0 = i32_left(), wasm2js_i32$1 = i32_right()), HEAP8[wasm2js_i32$0 | 0] = wasm2js_i32$1;
  return HEAP32[8 >> 2] | 0;
 }
 
 function $60() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  reset();
  (wasm2js_i32$0 = i32_left(), wasm2js_i32$1 = i32_right()), HEAP16[wasm2js_i32$0 >> 1] = wasm2js_i32$1;
  return HEAP32[8 >> 2] | 0;
 }
 
 function $61() {
  reset();
  i32_left();
  i32_right();
  return HEAP32[8 >> 2] | 0;
 }
 
 function $62() {
  var $0 = 0, $1 = 0;
  reset();
  $0 = i32_left();
  $1 = i32_right();
  bump();
  HEAP8[8 | 0] = 4;
  FUNCTION_TABLE[0]($0, $1) | 0;
  return HEAP32[8 >> 2] | 0;
 }
 
 function $63() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0;
  reset();
  wasm2js_i32$0 = i32_left(), wasm2js_i32$1 = i32_right(), wasm2js_i32$2 = i32_bool(), wasm2js_i32$2 ? wasm2js_i32$0 : wasm2js_i32$1;
  return HEAP32[8 >> 2] | 0;
 }
 
 function $64() {
  reset();
  i64_left() + i64_right() | 0;
  return HEAP32[8 >> 2] | 0;
 }
 
 function $65() {
  reset();
  i64_left() - i64_right() | 0;
  return HEAP32[8 >> 2] | 0;
 }
 
 function $66() {
  reset();
  _ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE(i64_left(), i64toi32_i32$HIGH_BITS, i64_right(), i64toi32_i32$HIGH_BITS);
  return HEAP32[8 >> 2] | 0;
 }
 
 function $67() {
  reset();
  _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E(i64_left(), i64toi32_i32$HIGH_BITS, i64_right(), i64toi32_i32$HIGH_BITS);
  return HEAP32[8 >> 2] | 0;
 }
 
 function $68() {
  reset();
  __wasm_i64_udiv(i64_left(), i64toi32_i32$HIGH_BITS, i64_right(), i64toi32_i32$HIGH_BITS);
  return HEAP32[8 >> 2] | 0;
 }
 
 function $69() {
  reset();
  _ZN17compiler_builtins3int4sdiv3Mod4mod_17h2cbb7bbf36e41d68E(i64_left(), i64toi32_i32$HIGH_BITS, i64_right(), i64toi32_i32$HIGH_BITS);
  return HEAP32[8 >> 2] | 0;
 }
 
 function $70() {
  reset();
  __wasm_i64_urem(i64_left(), i64toi32_i32$HIGH_BITS, i64_right(), i64toi32_i32$HIGH_BITS);
  return HEAP32[8 >> 2] | 0;
 }
 
 function $71() {
  reset();
  i64_left() & i64_right();
  return HEAP32[8 >> 2] | 0;
 }
 
 function $72() {
  reset();
  i64_left() | i64_right();
  return HEAP32[8 >> 2] | 0;
 }
 
 function $73() {
  reset();
  i64_left() ^ i64_right();
  return HEAP32[8 >> 2] | 0;
 }
 
 function $74() {
  reset();
  i64_left();
  i64_right();
  return HEAP32[8 >> 2] | 0;
 }
 
 function $87() {
  var $0 = 0, wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  reset();
  $0 = i32_left();
  (wasm2js_i32$0 = $0, wasm2js_i32$1 = i64_right()), HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
  HEAP32[$0 + 4 >> 2] = i64toi32_i32$HIGH_BITS;
  return HEAP32[8 >> 2] | 0;
 }
 
 function $88() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  reset();
  (wasm2js_i32$0 = i32_left(), wasm2js_i32$1 = i64_right()), HEAP8[wasm2js_i32$0 | 0] = wasm2js_i32$1;
  return HEAP32[8 >> 2] | 0;
 }
 
 function $89() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  reset();
  (wasm2js_i32$0 = i32_left(), wasm2js_i32$1 = i64_right()), HEAP16[wasm2js_i32$0 >> 1] = wasm2js_i32$1;
  return HEAP32[8 >> 2] | 0;
 }
 
 function $90() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  reset();
  (wasm2js_i32$0 = i32_left(), wasm2js_i32$1 = i64_right()), HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
  return HEAP32[8 >> 2] | 0;
 }
 
 function $92() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0;
  reset();
  $0 = i64_left();
  $1 = i64toi32_i32$HIGH_BITS;
  $2 = i64_right();
  $3 = i64toi32_i32$HIGH_BITS;
  bump();
  HEAP8[8 | 0] = 4;
  FUNCTION_TABLE[2]($0, $1, $2, $3) | 0;
  return HEAP32[8 >> 2] | 0;
 }
 
 function $93() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0;
  reset();
  wasm2js_i32$0 = i64_left(), wasm2js_i32$1 = i64_right(), wasm2js_i32$2 = i32_bool(), wasm2js_i32$2 ? wasm2js_i32$0 : wasm2js_i32$1;
  return HEAP32[8 >> 2] | 0;
 }
 
 function $94() {
  reset();
  Math_fround(f32_left() + f32_right());
  return HEAP32[8 >> 2] | 0;
 }
 
 function $95() {
  reset();
  Math_fround(f32_left() - f32_right());
  return HEAP32[8 >> 2] | 0;
 }
 
 function $96() {
  reset();
  Math_fround(f32_left() * f32_right());
  return HEAP32[8 >> 2] | 0;
 }
 
 function $97() {
  reset();
  Math_fround(f32_left() / f32_right());
  return HEAP32[8 >> 2] | 0;
 }
 
 function $98() {
  reset();
  (wasm2js_scratch_store_f32(f32_left()), wasm2js_scratch_load_i32(0)) & 2147483647 | (wasm2js_scratch_store_f32(f32_right()), wasm2js_scratch_load_i32(0)) & -2147483648;
  return HEAP32[8 >> 2] | 0;
 }
 
 function $99() {
  reset();
  f32_left() == f32_right();
  return HEAP32[8 >> 2] | 0;
 }
 
 function $100() {
  reset();
  f32_left() != f32_right();
  return HEAP32[8 >> 2] | 0;
 }
 
 function $101() {
  reset();
  f32_left() < f32_right();
  return HEAP32[8 >> 2] | 0;
 }
 
 function $102() {
  reset();
  f32_left() <= f32_right();
  return HEAP32[8 >> 2] | 0;
 }
 
 function $103() {
  reset();
  f32_left() > f32_right();
  return HEAP32[8 >> 2] | 0;
 }
 
 function $104() {
  reset();
  f32_left() >= f32_right();
  return HEAP32[8 >> 2] | 0;
 }
 
 function $105() {
  reset();
  Math_fround(Math_min(f32_left(), f32_right()));
  return HEAP32[8 >> 2] | 0;
 }
 
 function $106() {
  reset();
  Math_fround(Math_max(f32_left(), f32_right()));
  return HEAP32[8 >> 2] | 0;
 }
 
 function $107() {
  var wasm2js_i32$0 = 0, wasm2js_f32$0 = Math_fround(0);
  reset();
  (wasm2js_i32$0 = i32_left(), wasm2js_f32$0 = f32_right()), HEAPF32[wasm2js_i32$0 >> 2] = wasm2js_f32$0;
  return HEAP32[8 >> 2] | 0;
 }
 
 function $108() {
  reset();
  f32_left();
  f32_right();
  return HEAP32[8 >> 2] | 0;
 }
 
 function $109() {
  var $0 = Math_fround(0), $1 = Math_fround(0);
  reset();
  $0 = f32_left();
  $1 = f32_right();
  bump();
  HEAP8[8 | 0] = 4;
  FUNCTION_TABLE[4]($0, $1) | 0;
  return HEAP32[8 >> 2] | 0;
 }
 
 function $110() {
  var wasm2js_f32$0 = Math_fround(0), wasm2js_f32$1 = Math_fround(0), wasm2js_i32$0 = 0;
  reset();
  wasm2js_f32$0 = f32_left(), wasm2js_f32$1 = f32_right(), wasm2js_i32$0 = i32_bool(), wasm2js_i32$0 ? wasm2js_f32$0 : wasm2js_f32$1;
  return HEAP32[8 >> 2] | 0;
 }
 
 function $111() {
  reset();
  f64_left() + f64_right();
  return HEAP32[8 >> 2] | 0;
 }
 
 function $112() {
  reset();
  f64_left() - f64_right();
  return HEAP32[8 >> 2] | 0;
 }
 
 function $113() {
  reset();
  f64_left() * f64_right();
  return HEAP32[8 >> 2] | 0;
 }
 
 function $114() {
  reset();
  f64_left() / f64_right();
  return HEAP32[8 >> 2] | 0;
 }
 
 function $115() {
  var $0 = 0, $1 = 0, $2 = 0;
  reset();
  wasm2js_scratch_store_f64(+f64_left());
  $0 = wasm2js_scratch_load_i32(1 | 0) | 0;
  $1 = wasm2js_scratch_load_i32(0 | 0) | 0;
  wasm2js_scratch_store_f64(+f64_right());
  $2 = wasm2js_scratch_load_i32(1 | 0) | 0;
  wasm2js_scratch_store_i32(0 | 0, $1 | wasm2js_scratch_load_i32(0 | 0) & 0);
  wasm2js_scratch_store_i32(1 | 0, $0 & 2147483647 | $2 & -2147483648);
  +wasm2js_scratch_load_f64();
  return HEAP32[8 >> 2] | 0;
 }
 
 function $116() {
  reset();
  f64_left() == f64_right();
  return HEAP32[8 >> 2] | 0;
 }
 
 function $117() {
  reset();
  f64_left() != f64_right();
  return HEAP32[8 >> 2] | 0;
 }
 
 function $118() {
  reset();
  f64_left() < f64_right();
  return HEAP32[8 >> 2] | 0;
 }
 
 function $119() {
  reset();
  f64_left() <= f64_right();
  return HEAP32[8 >> 2] | 0;
 }
 
 function $120() {
  reset();
  f64_left() > f64_right();
  return HEAP32[8 >> 2] | 0;
 }
 
 function $121() {
  reset();
  f64_left() >= f64_right();
  return HEAP32[8 >> 2] | 0;
 }
 
 function $122() {
  reset();
  Math_min(f64_left(), f64_right());
  return HEAP32[8 >> 2] | 0;
 }
 
 function $123() {
  reset();
  Math_max(f64_left(), f64_right());
  return HEAP32[8 >> 2] | 0;
 }
 
 function $124() {
  var wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  reset();
  (wasm2js_i32$0 = i32_left(), wasm2js_f64$0 = f64_right()), HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  return HEAP32[8 >> 2] | 0;
 }
 
 function $125() {
  reset();
  f64_left();
  f64_right();
  return HEAP32[8 >> 2] | 0;
 }
 
 function $126() {
  var $0 = 0.0, $1 = 0.0;
  reset();
  $0 = f64_left();
  $1 = f64_right();
  bump();
  HEAP8[8 | 0] = 4;
  FUNCTION_TABLE[6]($0, $1) | 0;
  return HEAP32[8 >> 2] | 0;
 }
 
 function $127() {
  var wasm2js_f64$0 = 0.0, wasm2js_f64$1 = 0.0, wasm2js_i32$0 = 0;
  reset();
  wasm2js_f64$0 = f64_left(), wasm2js_f64$1 = f64_right(), wasm2js_i32$0 = i32_bool(), wasm2js_i32$0 ? wasm2js_f64$0 : wasm2js_f64$1;
  return HEAP32[8 >> 2] | 0;
 }
 
 function $129() {
  var $0 = 0, $1 = 0;
  reset();
  $1 = i32_left();
  if (i32_right()) {
   $0 = HEAP32[8 >> 2]
  } else {
   $0 = $1
  }
  return $0 | 0;
 }
 
 function legalfunc$wasm2js_scratch_load_i64() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0;
  $5 = legalimport$wasm2js_scratch_load_i64() | 0;
  $1 = getTempRet0() | 0;
  $3 = 32;
  $0 = $3 & 31;
  if (32 >>> 0 <= $3 >>> 0) {
   {
    $2 = $1 << $0;
    $4 = 0;
   }
  } else {
   {
    $2 = (1 << $0) - 1 & $1 >>> 32 - $0 | $2 << $0;
    $4 = $1 << $0;
   }
  }
  $0 = $5 | $4;
  i64toi32_i32$HIGH_BITS = $2 | $6;
  return $0;
 }
 
 function legalfunc$wasm2js_scratch_store_i64($0, $1) {
  var $2 = 0, $3 = 0;
  $2 = $0;
  $3 = 32;
  $0 = $3 & 31;
  legalimport$wasm2js_scratch_store_i64($2 | 0, (32 >>> 0 <= $3 >>> 0 ? $1 >>> $0 : ((1 << $0) - 1 & $1) << 32 - $0 | $2 >>> $0) | 0);
 }
 
 function _ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE($0, $1, $2, $3) {
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0;
  $5 = $2 >>> 16;
  $4 = $0 >>> 16;
  $8 = Math_imul($5, $4);
  $6 = $2 & 65535;
  $7 = $0 & 65535;
  $4 = (Math_imul($6, $7) >>> 16) + Math_imul($4, $6) | 0;
  $5 = ($4 & 65535) + Math_imul($5, $7) | 0;
  i64toi32_i32$HIGH_BITS = ((($8 + Math_imul($1, $2) | 0) + Math_imul($0, $3) | 0) + ($4 >>> 16) | 0) + ($5 >>> 16) | 0;
 }
 
 function _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E($0, $1, $2, $3) {
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0;
  $4 = $1;
  $5 = $4 >> 31;
  $4 = $4 >> 31;
  $0 = $0 ^ $4;
  $6 = $0 - $4 | 0;
  $7 = ($1 ^ $5) - (($0 >>> 0 < $4 >>> 0) + $5 | 0) | 0;
  $4 = $3;
  $5 = $4 >> 31;
  $4 = $4 >> 31;
  $0 = $2 ^ $4;
  $8 = __wasm_i64_udiv($6, $7, $0 - $4 | 0, ($3 ^ $5) - (($0 >>> 0 < $4 >>> 0) + $5 | 0) | 0);
  $1 = $1 ^ $3;
  $2 = $1 >> 31;
  $0 = $1 >> 31;
  $1 = $8 ^ $0;
  i64toi32_i32$HIGH_BITS = (i64toi32_i32$HIGH_BITS ^ $2) - (($1 >>> 0 < $0 >>> 0) + $2 | 0) | 0;
 }
 
 function _ZN17compiler_builtins3int4sdiv3Mod4mod_17h2cbb7bbf36e41d68E($0, $1, $2, $3) {
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0;
  $5 = $1 >> 31;
  $0 = $0 ^ $5;
  $7 = $0 - $5 | 0;
  $4 = $1 >> 31;
  $6 = $4;
  $8 = ($1 ^ $4) - (($0 >>> 0 < $5 >>> 0) + $4 | 0) | 0;
  $0 = $3;
  $4 = $0 >> 31;
  $1 = $0 >> 31;
  $0 = $2 ^ $1;
  $0 = __wasm_i64_urem($7, $8, $0 - $1 | 0, ($3 ^ $4) - (($0 >>> 0 < $1 >>> 0) + $4 | 0) | 0) ^ $5;
  i64toi32_i32$HIGH_BITS = ($6 ^ i64toi32_i32$HIGH_BITS) - (($0 >>> 0 < $5 >>> 0) + $6 | 0) | 0;
 }
 
 function _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0, $1, $2, $3) {
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0, $13 = 0, $14 = 0, $15 = 0, $16 = 0, $17 = 0, $18 = 0, $19 = 0, $20 = 0, $21 = 0, $22 = 0, $23 = 0, $24 = 0, $25 = 0, $26 = 0, $27 = 0, $28 = 0, $29 = 0;
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
            $4 = $1;
            $6 = $0;
            $9 = 32;
            $5 = $9 & 31;
            $6 = 32 >>> 0 <= $9 >>> 0 ? $4 >>> $5 : ((1 << $5) - 1 & $4) << 32 - $5 | $0 >>> $5;
            if ($6) {
             {
              $4 = $2;
              if (!$4) {
               break label$11
              }
              $5 = $3;
              $7 = $2;
              $8 = 32;
              $9 = $8 & 31;
              $5 = 32 >>> 0 <= $8 >>> 0 ? $5 >>> $9 : ((1 << $9) - 1 & $5) << 32 - $9 | $2 >>> $9;
              if (!$5) {
               break label$9
              }
              $4 = Math_clz32($5) - Math_clz32($6) | 0;
              if ($4 >>> 0 <= 31 >>> 0) {
               break label$8
              }
              break label$2;
             }
            }
            $4 = 1;
            if (($4 | 0) == ($3 | 0) & $2 >>> 0 >= 0 >>> 0 | $3 >>> 0 > $4 >>> 0) {
             break label$2
            }
            $1 = ($0 >>> 0) / ($2 >>> 0) | 0;
            legalfunc$wasm2js_scratch_store_i64($0 - Math_imul($2, $1) | 0, 0);
            i64toi32_i32$HIGH_BITS = 0;
            return $1;
           }
           $4 = $3;
           $9 = $2;
           $7 = 32;
           $5 = $7 & 31;
           $4 = 32 >>> 0 <= $7 >>> 0 ? $4 >>> $5 : ((1 << $5) - 1 & $4) << 32 - $5 | $2 >>> $5;
           if (!$0) {
            break label$7
           }
           if (!$4) {
            break label$6
           }
           $5 = $4 + -1 | 0;
           if ($4 & $5) {
            break label$6
           }
           $9 = 0;
           $3 = $5 & $6;
           $5 = 32;
           $2 = $5 & 31;
           if (32 >>> 0 <= $5 >>> 0) {
            {
             $5 = $3 << $2;
             $15 = 0;
            }
           } else {
            {
             $5 = (1 << $2) - 1 & $3 >>> 32 - $2 | $9 << $2;
             $15 = $3 << $2;
            }
           }
           legalfunc$wasm2js_scratch_store_i64($15 | $0, $5);
           $0 = $6 >>> (__wasm_ctz_i32($4) & 31);
           i64toi32_i32$HIGH_BITS = 0;
           return $0;
          }
          $5 = $4 + -1 | 0;
          if (!($4 & $5)) {
           break label$5
          }
          $10 = (Math_clz32($4) + 33 | 0) - Math_clz32($6) | 0;
          $14 = 0 - $10 | 0;
          break label$3;
         }
         $10 = $4 + 1 | 0;
         $14 = 63 - $4 | 0;
         break label$3;
        }
        $2 = 0;
        $3 = ($6 >>> 0) / ($4 >>> 0) | 0;
        $1 = $6 - Math_imul($4, $3) | 0;
        $4 = 32;
        $0 = $4 & 31;
        if (32 >>> 0 <= $4 >>> 0) {
         {
          $4 = $1 << $0;
          $16 = 0;
         }
        } else {
         {
          $4 = (1 << $0) - 1 & $1 >>> 32 - $0 | $2 << $0;
          $16 = $1 << $0;
         }
        }
        legalfunc$wasm2js_scratch_store_i64($16, $4);
        i64toi32_i32$HIGH_BITS = 0;
        return $3;
       }
       $4 = Math_clz32($4) - Math_clz32($6) | 0;
       if ($4 >>> 0 < 31 >>> 0) {
        break label$4
       }
       break label$2;
      }
      legalfunc$wasm2js_scratch_store_i64($0 & $5, 0);
      if (($4 | 0) == (1 | 0)) {
       break label$1
      }
      $2 = $0;
      $3 = __wasm_ctz_i32($4);
      $0 = $3 & 31;
      if (32 >>> 0 <= ($3 & 63) >>> 0) {
       {
        $4 = 0;
        $17 = $1 >>> $0;
       }
      } else {
       {
        $4 = $1 >>> $0;
        $17 = ((1 << $0) - 1 & $1) << 32 - $0 | $2 >>> $0;
       }
      }
      $0 = $17;
      i64toi32_i32$HIGH_BITS = $4;
      return $0;
     }
     $10 = $4 + 1 | 0;
     $14 = 63 - $4 | 0;
    }
    $9 = $14;
    $5 = $1;
    $7 = $0;
    $4 = $10 & 63;
    $6 = $4 & 31;
    if (32 >>> 0 <= ($4 & 63) >>> 0) {
     {
      $4 = 0;
      $18 = $5 >>> $6;
     }
    } else {
     {
      $4 = $5 >>> $6;
      $18 = ((1 << $6) - 1 & $5) << 32 - $6 | $7 >>> $6;
     }
    }
    $11 = $18;
    $5 = $4;
    $6 = $0;
    $4 = $9 & 63;
    $0 = $4 & 31;
    if (32 >>> 0 <= ($4 & 63) >>> 0) {
     {
      $4 = $6 << $0;
      $19 = 0;
     }
    } else {
     {
      $4 = (1 << $0) - 1 & $6 >>> 32 - $0 | $1 << $0;
      $19 = $6 << $0;
     }
    }
    $0 = $19;
    $1 = $4;
    if ($10) {
     {
      $4 = $3 + -1 | 0;
      $6 = -1;
      $9 = $6 + $2 | 0;
      if ($9 >>> 0 < $6 >>> 0) {
       $4 = $4 + 1 | 0
      }
      $6 = $9;
      $9 = $4;
      label$15 : while (1) {
       $8 = $11;
       $4 = 1;
       $7 = $4;
       if (32 >>> 0 <= $4 >>> 0) {
        {
         $4 = $8 << $7;
         $20 = 0;
        }
       } else {
        {
         $4 = (1 << $7) - 1 & $8 >>> 32 - $7 | $5 << $7;
         $20 = $8 << $7;
        }
       }
       $5 = $20;
       $7 = $4;
       $25 = $5;
       $5 = $1;
       $11 = $0;
       $4 = 63;
       $8 = $4 & 31;
       if (32 >>> 0 <= $4 >>> 0) {
        {
         $4 = 0;
         $21 = $5 >>> $8;
        }
       } else {
        {
         $4 = $5 >>> $8;
         $21 = ((1 << $8) - 1 & $5) << 32 - $8 | $11 >>> $8;
        }
       }
       $5 = $25 | $21;
       $8 = $5;
       $7 = $4 | $7;
       $13 = $7;
       $4 = $6;
       $11 = $4 - $5 | 0;
       $7 = $9 - (($4 >>> 0 < $5 >>> 0) + $7 | 0) | 0;
       $4 = 63;
       $5 = $4 & 31;
       $26 = $8;
       $27 = $2;
       if (32 >>> 0 <= $4 >>> 0) {
        {
         $4 = $7 >> 31;
         $22 = $7 >> $5;
        }
       } else {
        {
         $4 = $7 >> $5;
         $22 = ((1 << $5) - 1 & $7) << 32 - $5 | $11 >>> $5;
        }
       }
       $12 = $22;
       $5 = $27 & $12;
       $11 = $26 - $5 | 0;
       $7 = $4;
       $5 = $13 - (($3 & $4) + ($8 >>> 0 < $5 >>> 0) | 0) | 0;
       $8 = $0;
       $4 = 1;
       $0 = $4;
       if (32 >>> 0 <= $4 >>> 0) {
        {
         $4 = $8 << $0;
         $23 = 0;
        }
       } else {
        {
         $4 = (1 << $0) - 1 & $8 >>> 32 - $0 | $1 << $0;
         $23 = $8 << $0;
        }
       }
       $0 = $23 | $28;
       $1 = $4 | $29;
       $13 = $12 & 1;
       $28 = $13;
       $12 = 0;
       $29 = $12;
       $10 = $10 + -1 | 0;
       if ($10) {
        continue
       }
       break;
      };
     }
    }
    legalfunc$wasm2js_scratch_store_i64($11, $5);
    $2 = $0;
    $3 = 1;
    $0 = $3;
    if (32 >>> 0 <= $0 >>> 0) {
     {
      $4 = $2 << $0;
      $24 = 0;
     }
    } else {
     {
      $4 = (1 << $0) - 1 & $2 >>> 32 - $0 | $1 << $0;
      $24 = $2 << $0;
     }
    }
    $0 = $24 | $13;
    i64toi32_i32$HIGH_BITS = $4 | $12;
    return $0;
   }
   legalfunc$wasm2js_scratch_store_i64($0, $1);
   $0 = 0;
   $1 = 0;
  }
  i64toi32_i32$HIGH_BITS = $1;
  return $0;
 }
 
 function __wasm_i64_udiv($0, $1, $2, $3) {
  $0 = _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0, $1, $2, $3);
  return $0;
 }
 
 function __wasm_i64_urem($0, $1, $2, $3) {
  _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0, $1, $2, $3);
  $0 = legalfunc$wasm2js_scratch_load_i64();
  return $0;
 }
 
 function __wasm_ctz_i32($0) {
  if ($0) {
   return 31 - Math_clz32($0 ^ $0 + -1) | 0
  }
  return 32;
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
  "i64_shr_u": $74, 
  "i64_shr_s": $74, 
  "i64_eq": $74, 
  "i64_ne": $74, 
  "i64_lt_s": $74, 
  "i64_le_s": $74, 
  "i64_lt_u": $74, 
  "i64_le_u": $74, 
  "i64_gt_s": $74, 
  "i64_ge_s": $74, 
  "i64_gt_u": $74, 
  "i64_ge_u": $74, 
  "i64_store": $87, 
  "i64_store8": $88, 
  "i64_store16": $89, 
  "i64_store32": $90, 
  "i64_call": $74, 
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
  "br_if": $61, 
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
