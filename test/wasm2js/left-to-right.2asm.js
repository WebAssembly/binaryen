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
 function i32_t0($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  return 4294967295 | 0;
 }
 
 function i32_t1($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  return 4294967294 | 0;
 }
 
 function i64_t0($0, $0$hi, $1, $1$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  $1 = $1 | 0;
  $1$hi = $1$hi | 0;
  return 4294967295 | 0;
 }
 
 function i64_t1($0, $0$hi, $1, $1$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  $1 = $1 | 0;
  $1$hi = $1$hi | 0;
  return 4294967294 | 0;
 }
 
 function f32_t0($0, $1) {
  $0 = Math_fround($0);
  $1 = Math_fround($1);
  return 4294967295 | 0;
 }
 
 function f32_t1($0, $1) {
  $0 = Math_fround($0);
  $1 = Math_fround($1);
  return 4294967294 | 0;
 }
 
 function f64_t0($0, $1) {
  $0 = +$0;
  $1 = +$1;
  return 4294967295 | 0;
 }
 
 function f64_t1($0, $1) {
  $0 = +$0;
  $1 = +$1;
  return 4294967294 | 0;
 }
 
 function reset() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  wasm2js_i32$0 = 8;
  wasm2js_i32$1 = 0;
  HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
 }
 
 function bump() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  wasm2js_i32$0 = 11;
  wasm2js_i32$1 = HEAPU8[10 >> 0] | 0;
  HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
  wasm2js_i32$0 = 10;
  wasm2js_i32$1 = HEAPU8[9 >> 0] | 0;
  HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
  wasm2js_i32$0 = 9;
  wasm2js_i32$1 = HEAPU8[8 >> 0] | 0;
  HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
  wasm2js_i32$0 = 8;
  wasm2js_i32$1 = 4294967293;
  HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
 }
 
 function get() {
  return HEAPU32[8 >> 2] | 0 | 0;
 }
 
 function i32_left() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  bump();
  wasm2js_i32$0 = 8;
  wasm2js_i32$1 = 1;
  HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
  return 0 | 0;
 }
 
 function i32_right() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  bump();
  wasm2js_i32$0 = 8;
  wasm2js_i32$1 = 2;
  HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
  return 1 | 0;
 }
 
 function i32_another() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  bump();
  wasm2js_i32$0 = 8;
  wasm2js_i32$1 = 3;
  HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
  return 1 | 0;
 }
 
 function i32_callee() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  bump();
  wasm2js_i32$0 = 8;
  wasm2js_i32$1 = 4;
  HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
  return 0 | 0;
 }
 
 function i32_bool() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  bump();
  wasm2js_i32$0 = 8;
  wasm2js_i32$1 = 5;
  HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
  return 0 | 0;
 }
 
 function i64_left() {
  var i64toi32_i32$0 = 0, wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  bump();
  wasm2js_i32$0 = 8;
  wasm2js_i32$1 = 1;
  HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
  i64toi32_i32$0 = 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return 0 | 0;
 }
 
 function i64_right() {
  var i64toi32_i32$0 = 0, wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  bump();
  wasm2js_i32$0 = 8;
  wasm2js_i32$1 = 2;
  HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
  i64toi32_i32$0 = 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return 1 | 0;
 }
 
 function i64_another() {
  var i64toi32_i32$0 = 0, wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  bump();
  wasm2js_i32$0 = 8;
  wasm2js_i32$1 = 3;
  HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
  i64toi32_i32$0 = 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return 1 | 0;
 }
 
 function i64_callee() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  bump();
  wasm2js_i32$0 = 8;
  wasm2js_i32$1 = 4;
  HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
  return 2 | 0;
 }
 
 function i64_bool() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  bump();
  wasm2js_i32$0 = 8;
  wasm2js_i32$1 = 5;
  HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
  return 0 | 0;
 }
 
 function f32_left() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  bump();
  wasm2js_i32$0 = 8;
  wasm2js_i32$1 = 1;
  HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
  return Math_fround(Math_fround(0.0));
 }
 
 function f32_right() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  bump();
  wasm2js_i32$0 = 8;
  wasm2js_i32$1 = 2;
  HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
  return Math_fround(Math_fround(1.0));
 }
 
 function f32_another() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  bump();
  wasm2js_i32$0 = 8;
  wasm2js_i32$1 = 3;
  HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
  return Math_fround(Math_fround(1.0));
 }
 
 function f32_callee() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  bump();
  wasm2js_i32$0 = 8;
  wasm2js_i32$1 = 4;
  HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
  return 4 | 0;
 }
 
 function f32_bool() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  bump();
  wasm2js_i32$0 = 8;
  wasm2js_i32$1 = 5;
  HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
  return 0 | 0;
 }
 
 function f64_left() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  bump();
  wasm2js_i32$0 = 8;
  wasm2js_i32$1 = 1;
  HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
  return +(0.0);
 }
 
 function f64_right() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  bump();
  wasm2js_i32$0 = 8;
  wasm2js_i32$1 = 2;
  HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
  return +(1.0);
 }
 
 function f64_another() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  bump();
  wasm2js_i32$0 = 8;
  wasm2js_i32$1 = 3;
  HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
  return +(1.0);
 }
 
 function f64_callee() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  bump();
  wasm2js_i32$0 = 8;
  wasm2js_i32$1 = 4;
  HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
  return 6 | 0;
 }
 
 function f64_bool() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  bump();
  wasm2js_i32$0 = 8;
  wasm2js_i32$1 = 5;
  HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
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
  wasm2js_i32$0 = i32_left() | 0;
  wasm2js_i32$1 = i32_right() | 0;
  HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
  return get() | 0 | 0;
 }
 
 function $59() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  reset();
  wasm2js_i32$0 = i32_left() | 0;
  wasm2js_i32$1 = i32_right() | 0;
  HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
  return get() | 0 | 0;
 }
 
 function $60() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  reset();
  wasm2js_i32$0 = i32_left() | 0;
  wasm2js_i32$1 = i32_right() | 0;
  HEAP16[wasm2js_i32$0 >> 1] = wasm2js_i32$1;
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
  wasm2js_i32$1 = i32_left() | 0;
  wasm2js_i32$2 = i32_right() | 0;
  wasm2js_i32$0 = i32_callee() | 0;
  FUNCTION_TABLE_iii[wasm2js_i32$0 & 7](wasm2js_i32$1 | 0, wasm2js_i32$2 | 0) | 0;
  return get() | 0 | 0;
 }
 
 function $63() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0;
  reset();
  wasm2js_i32$0 = i32_left() | 0, wasm2js_i32$1 = i32_right() | 0, wasm2js_i32$2 = i32_bool() | 0, wasm2js_i32$2 ? wasm2js_i32$0 : wasm2js_i32$1;
  return get() | 0 | 0;
 }
 
 function $64() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$5 = 0, i64toi32_i32$3 = 0, i64toi32_i32$4 = 0, $0 = 0, $0$hi = 0, $1 = 0, $1$hi = 0;
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
  if (i64toi32_i32$4 >>> 0 < i64toi32_i32$3 >>> 0) i64toi32_i32$5 = i64toi32_i32$5 + 1 | 0;
  i64toi32_i32$5 = i64toi32_i32$5;
  return get() | 0 | 0;
 }
 
 function $65() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$5 = 0, i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, $0 = 0, $0$hi = 0, $1 = 0, $1$hi = 0;
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
  i64toi32_i32$5 = i64toi32_i32$5;
  return get() | 0 | 0;
 }
 
 function $66() {
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
  i64toi32_i32$1 = __wasm_i64_mul($0 | 0, i64toi32_i32$0 | 0, $1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$0 = i64toi32_i32$0;
  return get() | 0 | 0;
 }
 
 function $67() {
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
  i64toi32_i32$1 = __wasm_i64_sdiv($0 | 0, i64toi32_i32$0 | 0, $1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$0 = i64toi32_i32$0;
  return get() | 0 | 0;
 }
 
 function $68() {
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
  i64toi32_i32$1 = __wasm_i64_udiv($0 | 0, i64toi32_i32$0 | 0, $1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$0 = i64toi32_i32$0;
  return get() | 0 | 0;
 }
 
 function $69() {
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
  i64toi32_i32$1 = __wasm_i64_srem($0 | 0, i64toi32_i32$0 | 0, $1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$0 = i64toi32_i32$0;
  return get() | 0 | 0;
 }
 
 function $70() {
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
  i64toi32_i32$1 = __wasm_i64_urem($0 | 0, i64toi32_i32$0 | 0, $1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$0 = i64toi32_i32$0;
  return get() | 0 | 0;
 }
 
 function $71() {
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
  i64toi32_i32$1 = i64toi32_i32$1;
  return get() | 0 | 0;
 }
 
 function $72() {
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
  i64toi32_i32$1 = i64toi32_i32$1;
  return get() | 0 | 0;
 }
 
 function $73() {
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
  i64toi32_i32$1 = i64toi32_i32$1;
  return get() | 0 | 0;
 }
 
 function $74() {
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
  i64toi32_i32$1 = i64toi32_i32$1;
  return get() | 0 | 0;
 }
 
 function $75() {
  var i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $9 = 0, $0 = 0, $0$hi = 0, $1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
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
  i64toi32_i32$1 = i64toi32_i32$1;
  return get() | 0 | 0;
 }
 
 function $76() {
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
  i64toi32_i32$1 = i64toi32_i32$1;
  return get() | 0 | 0;
 }
 
 function $77() {
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
 
 function $78() {
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
 
 function $79() {
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
  if ((i64toi32_i32$0 | 0) < (i64toi32_i32$1 | 0)) $8 = 1; else {
   if ((i64toi32_i32$0 | 0) <= (i64toi32_i32$1 | 0)) {
    if (i64toi32_i32$2 >>> 0 >= i64toi32_i32$3 >>> 0) $9 = 0; else $9 = 1;
    $10 = $9;
   } else $10 = 0;
   $8 = $10;
  }
  return get() | 0 | 0;
 }
 
 function $80() {
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
  if ((i64toi32_i32$0 | 0) < (i64toi32_i32$1 | 0)) $8 = 1; else {
   if ((i64toi32_i32$0 | 0) <= (i64toi32_i32$1 | 0)) {
    if (i64toi32_i32$2 >>> 0 > i64toi32_i32$3 >>> 0) $9 = 0; else $9 = 1;
    $10 = $9;
   } else $10 = 0;
   $8 = $10;
  }
  return get() | 0 | 0;
 }
 
 function $81() {
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
 
 function $82() {
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
 
 function $83() {
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
  if ((i64toi32_i32$0 | 0) > (i64toi32_i32$1 | 0)) $8 = 1; else {
   if ((i64toi32_i32$0 | 0) >= (i64toi32_i32$1 | 0)) {
    if (i64toi32_i32$2 >>> 0 <= i64toi32_i32$3 >>> 0) $9 = 0; else $9 = 1;
    $10 = $9;
   } else $10 = 0;
   $8 = $10;
  }
  return get() | 0 | 0;
 }
 
 function $84() {
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
  if ((i64toi32_i32$0 | 0) > (i64toi32_i32$1 | 0)) $8 = 1; else {
   if ((i64toi32_i32$0 | 0) >= (i64toi32_i32$1 | 0)) {
    if (i64toi32_i32$2 >>> 0 < i64toi32_i32$3 >>> 0) $9 = 0; else $9 = 1;
    $10 = $9;
   } else $10 = 0;
   $8 = $10;
  }
  return get() | 0 | 0;
 }
 
 function $85() {
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
 
 function $86() {
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
 
 function $87() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, $0 = 0, $1 = 0, wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0, wasm2js_i32$3 = 0;
  reset();
  $0 = i32_left() | 0;
  i64toi32_i32$0 = i64_right() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$0;
  i64toi32_i32$0 = $0;
  i64toi32_i32$1 = i64toi32_i32$1;
  wasm2js_i32$0 = i64toi32_i32$0;
  wasm2js_i32$1 = $1;
  HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
  wasm2js_i32$0 = i64toi32_i32$0;
  wasm2js_i32$1 = i64toi32_i32$1;
  (wasm2js_i32$2 = wasm2js_i32$0, wasm2js_i32$3 = wasm2js_i32$1), ((HEAP8[(wasm2js_i32$2 + 4 | 0) >> 0] = wasm2js_i32$3 & 255 | 0, HEAP8[(wasm2js_i32$2 + 5 | 0) >> 0] = (wasm2js_i32$3 >>> 8 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 6 | 0) >> 0] = (wasm2js_i32$3 >>> 16 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 7 | 0) >> 0] = (wasm2js_i32$3 >>> 24 | 0) & 255 | 0;
  return get() | 0 | 0;
 }
 
 function $88() {
  var $0 = 0, i64toi32_i32$0 = 0, wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  reset();
  $0 = i32_left() | 0;
  i64toi32_i32$0 = i64_right() | 0;
  wasm2js_i32$0 = $0;
  wasm2js_i32$1 = i64toi32_i32$0;
  HEAP8[wasm2js_i32$0 >> 0] = wasm2js_i32$1;
  return get() | 0 | 0;
 }
 
 function $89() {
  var $0 = 0, i64toi32_i32$0 = 0, wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  reset();
  $0 = i32_left() | 0;
  i64toi32_i32$0 = i64_right() | 0;
  wasm2js_i32$0 = $0;
  wasm2js_i32$1 = i64toi32_i32$0;
  HEAP16[wasm2js_i32$0 >> 1] = wasm2js_i32$1;
  return get() | 0 | 0;
 }
 
 function $90() {
  var $0 = 0, i64toi32_i32$0 = 0, wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  reset();
  $0 = i32_left() | 0;
  i64toi32_i32$0 = i64_right() | 0;
  wasm2js_i32$0 = $0;
  wasm2js_i32$1 = i64toi32_i32$0;
  HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
  return get() | 0 | 0;
 }
 
 function $91() {
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
 
 function $92() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, $0 = 0, $0$hi = 0, $1 = 0, $1$hi = 0, wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0, wasm2js_i32$3 = 0, wasm2js_i32$4 = 0;
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
  wasm2js_i32$1 = $0;
  wasm2js_i32$2 = i64toi32_i32$0;
  wasm2js_i32$3 = $1;
  wasm2js_i32$4 = i64toi32_i32$1;
  wasm2js_i32$0 = i64_callee() | 0;
  FUNCTION_TABLE_iiiii[wasm2js_i32$0 & 7](wasm2js_i32$1 | 0, wasm2js_i32$2 | 0, wasm2js_i32$3 | 0, wasm2js_i32$4 | 0) | 0;
  return get() | 0 | 0;
 }
 
 function $93() {
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
  i64toi32_i32$0 = i64toi32_i32$1;
  i64toi32_i32$0 = i64toi32_i32$1;
  i64_bool() | 0;
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
  (HEAPF32[0] = Math_fround(f32_left()), HEAP32[0] | 0) & 2147483647 | 0 | ((HEAPF32[0] = Math_fround(f32_right()), HEAP32[0] | 0) & 2147483648 | 0) | 0;
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
  wasm2js_i32$0 = i32_left() | 0;
  wasm2js_f32$0 = Math_fround(f32_right());
  HEAPF32[wasm2js_i32$0 >> 2] = wasm2js_f32$0;
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
  wasm2js_f32$0 = Math_fround(f32_left());
  wasm2js_f32$1 = Math_fround(f32_right());
  wasm2js_i32$0 = f32_callee() | 0;
  FUNCTION_TABLE_iff[wasm2js_i32$0 & 7](Math_fround(wasm2js_f32$0), Math_fround(wasm2js_f32$1)) | 0;
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
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, $2 = 0, $2$hi = 0, $5 = 0, $5$hi = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0, wasm2js_i32$1 = 0;
  reset();
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = +f64_left();
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$2 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$1 = 2147483647;
  i64toi32_i32$3 = 4294967295;
  i64toi32_i32$1 = i64toi32_i32$0 & i64toi32_i32$1 | 0;
  $2 = i64toi32_i32$2 & i64toi32_i32$3 | 0;
  $2$hi = i64toi32_i32$1;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = +f64_right();
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$1 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$0 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$2 = 2147483648;
  i64toi32_i32$3 = 0;
  i64toi32_i32$2 = i64toi32_i32$1 & i64toi32_i32$2 | 0;
  $5 = i64toi32_i32$0 & i64toi32_i32$3 | 0;
  $5$hi = i64toi32_i32$2;
  i64toi32_i32$2 = $2$hi;
  i64toi32_i32$1 = $2;
  i64toi32_i32$0 = $5$hi;
  i64toi32_i32$3 = $5;
  i64toi32_i32$0 = i64toi32_i32$2 | i64toi32_i32$0 | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  wasm2js_i32$0 = 0;
  wasm2js_i32$1 = i64toi32_i32$1 | i64toi32_i32$3 | 0;
  HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
  wasm2js_i32$0 = 0;
  wasm2js_i32$1 = i64toi32_i32$0;
  HEAP32[(wasm2js_i32$0 + 4 | 0) >> 2] = wasm2js_i32$1;
  +HEAPF64[0 >> 3];
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
  wasm2js_i32$0 = i32_left() | 0;
  wasm2js_f64$0 = +f64_right();
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
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
  wasm2js_f64$0 = +f64_left();
  wasm2js_f64$1 = +f64_right();
  wasm2js_i32$0 = f64_callee() | 0;
  FUNCTION_TABLE_idd[wasm2js_i32$0 & 7](+wasm2js_f64$0, +wasm2js_f64$1) | 0;
  return get() | 0 | 0;
 }
 
 function $127() {
  var wasm2js_f64$0 = 0.0, wasm2js_f64$1 = 0.0, wasm2js_i32$0 = 0;
  reset();
  wasm2js_f64$0 = +f64_left(), wasm2js_f64$1 = +f64_right(), wasm2js_i32$0 = f64_bool() | 0, wasm2js_i32$0 ? wasm2js_f64$0 : wasm2js_f64$1;
  return get() | 0 | 0;
 }
 
 function $128() {
  var $3 = 0;
  block : {
   reset();
   $3 = i32_left() | 0;
   if ((i32_right() | 0) & 0 | 0) break block;
   $3 = get() | 0;
  };
  return $3 | 0;
 }
 
 function $129() {
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
   };
   $3 = get() | 0;
  };
  return $3 | 0;
 }
 
 function _ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$2 = 0, var$2 = 0, i64toi32_i32$3 = 0, var$3 = 0, var$4 = 0, var$5 = 0, $21 = 0, $22 = 0, var$6 = 0, $24 = 0, $17 = 0, $18 = 0, $23 = 0, $29 = 0, $45_1 = 0, $56$hi = 0, $62$hi = 0;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  var$2 = var$1;
  var$4 = var$2 >>> 16 | 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  var$3 = var$0;
  var$5 = var$3 >>> 16 | 0;
  $17 = Math_imul(var$4, var$5);
  $18 = var$2;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = i64toi32_i32$0;
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
  i64toi32_i32$1 = i64toi32_i32$1;
  $23 = $17 + Math_imul($18, $21) | 0;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = i64toi32_i32$1;
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
  i64toi32_i32$2 = i64toi32_i32$2;
  $29 = $23 + Math_imul($22, var$3) | 0;
  var$2 = var$2 & 65535 | 0;
  var$3 = var$3 & 65535 | 0;
  var$6 = Math_imul(var$2, var$3);
  var$2 = (var$6 >>> 16 | 0) + Math_imul(var$2, var$5) | 0;
  $45_1 = $29 + (var$2 >>> 16 | 0) | 0;
  var$2 = (var$2 & 65535 | 0) + Math_imul(var$4, var$3) | 0;
  i64toi32_i32$2 = 0;
  i64toi32_i32$2 = i64toi32_i32$2;
  i64toi32_i32$1 = $45_1 + (var$2 >>> 16 | 0) | 0;
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
  i64toi32_i32$1 = i64toi32_i32$1;
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
  i64toi32_i32$0 = i64toi32_i32$0;
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
  i64toi32_i32$1 = i64toi32_i32$1;
  var$2 = $21;
  var$2$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64toi32_i32$1;
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
  i64toi32_i32$5 = i64toi32_i32$5;
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
  i64toi32_i32$1 = i64toi32_i32$1;
  var$2 = $22;
  var$2$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64toi32_i32$1;
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
  i64toi32_i32$1 = i64toi32_i32$1;
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
  i64toi32_i32$2 = i64toi32_i32$2;
  var$0 = $23;
  var$0$hi = i64toi32_i32$2;
  i64toi32_i32$2 = i64toi32_i32$2;
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
  i64toi32_i32$3 = i64toi32_i32$3;
  i64toi32_i32$5 = i64toi32_i32$2 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$0 = i64toi32_i32$6 + i64toi32_i32$1 | 0;
  i64toi32_i32$0 = i64toi32_i32$4 - i64toi32_i32$0 | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$2 = i64toi32_i32$5;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$2 | 0;
 }
 
 function _ZN17compiler_builtins3int4sdiv3Mod4mod_17h2cbb7bbf36e41d68E(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, i64toi32_i32$5 = 0, var$2$hi = 0, i64toi32_i32$6 = 0, var$2 = 0, $20 = 0, $21 = 0, $7$hi = 0, $9 = 0, $9$hi = 0, $14$hi = 0, $16$hi = 0, $17$hi = 0, $19$hi = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
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
  i64toi32_i32$1 = i64toi32_i32$1;
  var$2 = $20;
  var$2$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64toi32_i32$1;
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
  i64toi32_i32$5 = i64toi32_i32$5;
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
  i64toi32_i32$1 = i64toi32_i32$1;
  var$0 = $21;
  var$0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64toi32_i32$1;
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
  i64toi32_i32$3 = i64toi32_i32$3;
  i64toi32_i32$5 = i64toi32_i32$4 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$4 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$0 = i64toi32_i32$6 + i64toi32_i32$2 | 0;
  i64toi32_i32$0 = i64toi32_i32$1 - i64toi32_i32$0 | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$4 = i64toi32_i32$5;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$4 | 0;
 }
 
 function _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$5 = 0, var$2 = 0, var$3 = 0, var$4 = 0, var$5 = 0, var$5$hi = 0, var$6 = 0, var$6$hi = 0, i64toi32_i32$6 = 0, $38_1 = 0, $39_1 = 0, $40_1 = 0, $41_1 = 0, $42_1 = 0, $43_1 = 0, $44_1 = 0, $45_1 = 0, var$8$hi = 0, $46_1 = 0, $47_1 = 0, $48_1 = 0, $49_1 = 0, var$7$hi = 0, $50_1 = 0, $63$hi = 0, $65_1 = 0, $65$hi = 0, $66_1 = 0, $120$hi = 0, $129$hi = 0, $134$hi = 0, var$8 = 0, $140 = 0, $140$hi = 0, $142$hi = 0, $144 = 0, $144$hi = 0, $151 = 0, $151$hi = 0, $154$hi = 0, var$7 = 0, $165$hi = 0, wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0, wasm2js_i32$3 = 0;
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
             i64toi32_i32$0 = i64toi32_i32$0;
             i64toi32_i32$2 = var$0;
             i64toi32_i32$1 = 0;
             i64toi32_i32$3 = 32;
             i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
             if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
              i64toi32_i32$1 = 0;
              $38_1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
             } else {
              i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
              $38_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
             }
             i64toi32_i32$1 = i64toi32_i32$1;
             var$2 = $38_1;
             if (var$2) block : {
              i64toi32_i32$1 = var$1$hi;
              i64toi32_i32$1 = i64toi32_i32$1;
              var$3 = var$1;
              if ((var$3 | 0) == (0 | 0)) break label$11;
              i64toi32_i32$1 = var$1$hi;
              i64toi32_i32$1 = i64toi32_i32$1;
              i64toi32_i32$0 = var$1;
              i64toi32_i32$2 = 0;
              i64toi32_i32$3 = 32;
              i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
              if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
               i64toi32_i32$2 = 0;
               $39_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
              } else {
               i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
               $39_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$0 >>> i64toi32_i32$4 | 0) | 0;
              }
              i64toi32_i32$2 = i64toi32_i32$2;
              var$4 = $39_1;
              if ((var$4 | 0) == (0 | 0)) break label$9;
              var$2 = Math_clz32(var$4) - Math_clz32(var$2) | 0;
              if (var$2 >>> 0 <= 31 >>> 0) break label$8;
              break label$2;
             };
             i64toi32_i32$2 = var$1$hi;
             i64toi32_i32$2 = i64toi32_i32$2;
             i64toi32_i32$1 = var$1;
             i64toi32_i32$0 = 1;
             i64toi32_i32$3 = 0;
             if (i64toi32_i32$2 >>> 0 > i64toi32_i32$0 >>> 0 | ((i64toi32_i32$2 | 0) == (i64toi32_i32$0 | 0) & i64toi32_i32$1 >>> 0 >= i64toi32_i32$3 >>> 0 | 0) | 0) break label$2;
             i64toi32_i32$1 = var$0$hi;
             i64toi32_i32$1 = i64toi32_i32$1;
             var$2 = var$0;
             i64toi32_i32$1 = var$1$hi;
             i64toi32_i32$1 = i64toi32_i32$1;
             var$3 = var$1;
             var$2 = (var$2 >>> 0) / (var$3 >>> 0) | 0;
             i64toi32_i32$1 = 0;
             i64toi32_i32$2 = 1024;
             i64toi32_i32$1 = i64toi32_i32$1;
             wasm2js_i32$0 = i64toi32_i32$2;
             wasm2js_i32$1 = var$0 - Math_imul(var$2, var$3) | 0;
             HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
             wasm2js_i32$0 = i64toi32_i32$2;
             wasm2js_i32$1 = i64toi32_i32$1;
             (wasm2js_i32$2 = wasm2js_i32$0, wasm2js_i32$3 = wasm2js_i32$1), ((HEAP8[(wasm2js_i32$2 + 4 | 0) >> 0] = wasm2js_i32$3 & 255 | 0, HEAP8[(wasm2js_i32$2 + 5 | 0) >> 0] = (wasm2js_i32$3 >>> 8 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 6 | 0) >> 0] = (wasm2js_i32$3 >>> 16 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 7 | 0) >> 0] = (wasm2js_i32$3 >>> 24 | 0) & 255 | 0;
             i64toi32_i32$1 = 0;
             i64toi32_i32$1 = i64toi32_i32$1;
             i64toi32_i32$2 = var$2;
             i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
             return i64toi32_i32$2 | 0;
            };
            i64toi32_i32$2 = var$1$hi;
            i64toi32_i32$2 = i64toi32_i32$2;
            i64toi32_i32$3 = var$1;
            i64toi32_i32$1 = 0;
            i64toi32_i32$0 = 32;
            i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
            if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
             i64toi32_i32$1 = 0;
             $40_1 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
            } else {
             i64toi32_i32$1 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
             $40_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$2 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$3 >>> i64toi32_i32$4 | 0) | 0;
            }
            i64toi32_i32$1 = i64toi32_i32$1;
            var$3 = $40_1;
            i64toi32_i32$1 = var$0$hi;
            i64toi32_i32$1 = i64toi32_i32$1;
            if ((var$0 | 0) == (0 | 0)) break label$7;
            if ((var$3 | 0) == (0 | 0)) break label$6;
            var$4 = var$3 + 4294967295 | 0;
            if (var$4 & var$3 | 0) break label$6;
            i64toi32_i32$1 = 0;
            i64toi32_i32$1 = i64toi32_i32$1;
            i64toi32_i32$2 = var$4 & var$2 | 0;
            i64toi32_i32$3 = 0;
            i64toi32_i32$0 = 32;
            i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
            if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
             i64toi32_i32$3 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
             $41_1 = 0;
            } else {
             i64toi32_i32$3 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
             $41_1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
            }
            $63$hi = i64toi32_i32$3;
            i64toi32_i32$3 = var$0$hi;
            i64toi32_i32$3 = i64toi32_i32$3;
            i64toi32_i32$1 = var$0;
            i64toi32_i32$2 = 0;
            i64toi32_i32$0 = 4294967295;
            i64toi32_i32$2 = i64toi32_i32$3 & i64toi32_i32$2 | 0;
            $65_1 = i64toi32_i32$1 & i64toi32_i32$0 | 0;
            $65$hi = i64toi32_i32$2;
            i64toi32_i32$2 = $63$hi;
            i64toi32_i32$3 = $41_1;
            i64toi32_i32$1 = $65$hi;
            i64toi32_i32$0 = $65_1;
            i64toi32_i32$1 = i64toi32_i32$2 | i64toi32_i32$1 | 0;
            $66_1 = i64toi32_i32$3 | i64toi32_i32$0 | 0;
            i64toi32_i32$3 = 1024;
            i64toi32_i32$1 = i64toi32_i32$1;
            wasm2js_i32$0 = i64toi32_i32$3;
            wasm2js_i32$1 = $66_1;
            HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
            wasm2js_i32$0 = i64toi32_i32$3;
            wasm2js_i32$1 = i64toi32_i32$1;
            (wasm2js_i32$2 = wasm2js_i32$0, wasm2js_i32$3 = wasm2js_i32$1), ((HEAP8[(wasm2js_i32$2 + 4 | 0) >> 0] = wasm2js_i32$3 & 255 | 0, HEAP8[(wasm2js_i32$2 + 5 | 0) >> 0] = (wasm2js_i32$3 >>> 8 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 6 | 0) >> 0] = (wasm2js_i32$3 >>> 16 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 7 | 0) >> 0] = (wasm2js_i32$3 >>> 24 | 0) & 255 | 0;
            i64toi32_i32$1 = 0;
            i64toi32_i32$1 = i64toi32_i32$1;
            i64toi32_i32$3 = var$2 >>> ((__wasm_ctz_i32(var$3 | 0) | 0) & 31 | 0) | 0;
            i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
            return i64toi32_i32$3 | 0;
           };
          };
          var$4 = var$3 + 4294967295 | 0;
          if ((var$4 & var$3 | 0 | 0) == (0 | 0)) break label$5;
          var$2 = (Math_clz32(var$3) + 33 | 0) - Math_clz32(var$2) | 0;
          var$3 = 0 - var$2 | 0;
          break label$3;
         };
         var$3 = 63 - var$2 | 0;
         var$2 = var$2 + 1 | 0;
         break label$3;
        };
        var$4 = (var$2 >>> 0) / (var$3 >>> 0) | 0;
        i64toi32_i32$3 = 0;
        i64toi32_i32$3 = i64toi32_i32$3;
        i64toi32_i32$2 = var$2 - Math_imul(var$4, var$3) | 0;
        i64toi32_i32$1 = 0;
        i64toi32_i32$0 = 32;
        i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
         $42_1 = 0;
        } else {
         i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
         $42_1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
        }
        i64toi32_i32$2 = 1024;
        i64toi32_i32$1 = i64toi32_i32$1;
        wasm2js_i32$0 = i64toi32_i32$2;
        wasm2js_i32$1 = $42_1;
        HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
        wasm2js_i32$0 = i64toi32_i32$2;
        wasm2js_i32$1 = i64toi32_i32$1;
        (wasm2js_i32$2 = wasm2js_i32$0, wasm2js_i32$3 = wasm2js_i32$1), ((HEAP8[(wasm2js_i32$2 + 4 | 0) >> 0] = wasm2js_i32$3 & 255 | 0, HEAP8[(wasm2js_i32$2 + 5 | 0) >> 0] = (wasm2js_i32$3 >>> 8 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 6 | 0) >> 0] = (wasm2js_i32$3 >>> 16 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 7 | 0) >> 0] = (wasm2js_i32$3 >>> 24 | 0) & 255 | 0;
        i64toi32_i32$1 = 0;
        i64toi32_i32$1 = i64toi32_i32$1;
        i64toi32_i32$2 = var$4;
        i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
        return i64toi32_i32$2 | 0;
       };
       var$2 = Math_clz32(var$3) - Math_clz32(var$2) | 0;
       if (var$2 >>> 0 < 31 >>> 0) break label$4;
       break label$2;
      };
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$2 = i64toi32_i32$2;
      i64toi32_i32$2 = 0;
      i64toi32_i32$1 = 1024;
      i64toi32_i32$2 = i64toi32_i32$2;
      wasm2js_i32$0 = i64toi32_i32$1;
      wasm2js_i32$1 = var$4 & var$0 | 0;
      HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
      wasm2js_i32$0 = i64toi32_i32$1;
      wasm2js_i32$1 = i64toi32_i32$2;
      (wasm2js_i32$2 = wasm2js_i32$0, wasm2js_i32$3 = wasm2js_i32$1), ((HEAP8[(wasm2js_i32$2 + 4 | 0) >> 0] = wasm2js_i32$3 & 255 | 0, HEAP8[(wasm2js_i32$2 + 5 | 0) >> 0] = (wasm2js_i32$3 >>> 8 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 6 | 0) >> 0] = (wasm2js_i32$3 >>> 16 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 7 | 0) >> 0] = (wasm2js_i32$3 >>> 24 | 0) & 255 | 0;
      if ((var$3 | 0) == (1 | 0)) break label$1;
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
       $43_1 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
      } else {
       i64toi32_i32$1 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
       $43_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$2 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$3 >>> i64toi32_i32$4 | 0) | 0;
      }
      i64toi32_i32$1 = i64toi32_i32$1;
      i64toi32_i32$3 = $43_1;
      i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
      return i64toi32_i32$3 | 0;
     };
     var$3 = 63 - var$2 | 0;
     var$2 = var$2 + 1 | 0;
    };
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
     $44_1 = i64toi32_i32$3 >>> i64toi32_i32$4 | 0;
    } else {
     i64toi32_i32$1 = i64toi32_i32$3 >>> i64toi32_i32$4 | 0;
     $44_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$3 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
    }
    i64toi32_i32$1 = i64toi32_i32$1;
    var$5 = $44_1;
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
     $45_1 = 0;
    } else {
     i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$3 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
     $45_1 = i64toi32_i32$3 << i64toi32_i32$4 | 0;
    }
    i64toi32_i32$2 = i64toi32_i32$2;
    var$0 = $45_1;
    var$0$hi = i64toi32_i32$2;
    label$13 : {
     if (var$2) block3 : {
      i64toi32_i32$2 = var$1$hi;
      i64toi32_i32$2 = i64toi32_i32$2;
      i64toi32_i32$1 = var$1;
      i64toi32_i32$3 = 4294967295;
      i64toi32_i32$0 = 4294967295;
      i64toi32_i32$4 = i64toi32_i32$1 + i64toi32_i32$0 | 0;
      i64toi32_i32$5 = i64toi32_i32$2 + i64toi32_i32$3 | 0;
      if (i64toi32_i32$4 >>> 0 < i64toi32_i32$0 >>> 0) i64toi32_i32$5 = i64toi32_i32$5 + 1 | 0;
      i64toi32_i32$5 = i64toi32_i32$5;
      var$8 = i64toi32_i32$4;
      var$8$hi = i64toi32_i32$5;
      label$15 : do {
       i64toi32_i32$5 = var$5$hi;
       i64toi32_i32$5 = i64toi32_i32$5;
       i64toi32_i32$2 = var$5;
       i64toi32_i32$1 = 0;
       i64toi32_i32$0 = 1;
       i64toi32_i32$3 = i64toi32_i32$0 & 31 | 0;
       if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
        i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$3 | 0;
        $46_1 = 0;
       } else {
        i64toi32_i32$1 = ((1 << i64toi32_i32$3 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$3 | 0) | 0) | 0 | (i64toi32_i32$5 << i64toi32_i32$3 | 0) | 0;
        $46_1 = i64toi32_i32$2 << i64toi32_i32$3 | 0;
       }
       $140 = $46_1;
       $140$hi = i64toi32_i32$1;
       i64toi32_i32$1 = var$0$hi;
       i64toi32_i32$1 = i64toi32_i32$1;
       i64toi32_i32$5 = var$0;
       i64toi32_i32$2 = 0;
       i64toi32_i32$0 = 63;
       i64toi32_i32$3 = i64toi32_i32$0 & 31 | 0;
       if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
        i64toi32_i32$2 = 0;
        $47_1 = i64toi32_i32$1 >>> i64toi32_i32$3 | 0;
       } else {
        i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$3 | 0;
        $47_1 = (((1 << i64toi32_i32$3 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$3 | 0) | 0 | (i64toi32_i32$5 >>> i64toi32_i32$3 | 0) | 0;
       }
       $142$hi = i64toi32_i32$2;
       i64toi32_i32$2 = $140$hi;
       i64toi32_i32$1 = $140;
       i64toi32_i32$5 = $142$hi;
       i64toi32_i32$0 = $47_1;
       i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
       i64toi32_i32$5 = i64toi32_i32$5;
       var$5 = i64toi32_i32$1 | i64toi32_i32$0 | 0;
       var$5$hi = i64toi32_i32$5;
       i64toi32_i32$5 = i64toi32_i32$5;
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
       i64toi32_i32$4 = i64toi32_i32$4;
       i64toi32_i32$5 = i64toi32_i32$3;
       i64toi32_i32$2 = 0;
       i64toi32_i32$0 = 63;
       i64toi32_i32$1 = i64toi32_i32$0 & 31 | 0;
       if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
        i64toi32_i32$2 = i64toi32_i32$4 >> 31 | 0;
        $48_1 = i64toi32_i32$4 >> i64toi32_i32$1 | 0;
       } else {
        i64toi32_i32$2 = i64toi32_i32$4 >> i64toi32_i32$1 | 0;
        $48_1 = (((1 << i64toi32_i32$1 | 0) - 1 | 0) & i64toi32_i32$4 | 0) << (32 - i64toi32_i32$1 | 0) | 0 | (i64toi32_i32$5 >>> i64toi32_i32$1 | 0) | 0;
       }
       i64toi32_i32$2 = i64toi32_i32$2;
       var$6 = $48_1;
       var$6$hi = i64toi32_i32$2;
       i64toi32_i32$2 = i64toi32_i32$2;
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
       i64toi32_i32$3 = i64toi32_i32$3;
       var$5 = i64toi32_i32$1;
       var$5$hi = i64toi32_i32$3;
       i64toi32_i32$3 = var$0$hi;
       i64toi32_i32$3 = i64toi32_i32$3;
       i64toi32_i32$5 = var$0;
       i64toi32_i32$2 = 0;
       i64toi32_i32$0 = 1;
       i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
       if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
        i64toi32_i32$2 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
        $49_1 = 0;
       } else {
        i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$5 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
        $49_1 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
       }
       $154$hi = i64toi32_i32$2;
       i64toi32_i32$2 = var$7$hi;
       i64toi32_i32$2 = $154$hi;
       i64toi32_i32$3 = $49_1;
       i64toi32_i32$5 = var$7$hi;
       i64toi32_i32$0 = var$7;
       i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
       i64toi32_i32$5 = i64toi32_i32$5;
       var$0 = i64toi32_i32$3 | i64toi32_i32$0 | 0;
       var$0$hi = i64toi32_i32$5;
       i64toi32_i32$5 = var$6$hi;
       i64toi32_i32$5 = i64toi32_i32$5;
       i64toi32_i32$2 = var$6;
       i64toi32_i32$3 = 0;
       i64toi32_i32$0 = 1;
       i64toi32_i32$3 = i64toi32_i32$5 & i64toi32_i32$3 | 0;
       i64toi32_i32$3 = i64toi32_i32$3;
       var$6 = i64toi32_i32$2 & i64toi32_i32$0 | 0;
       var$6$hi = i64toi32_i32$3;
       i64toi32_i32$3 = i64toi32_i32$3;
       i64toi32_i32$3 = i64toi32_i32$3;
       var$7 = var$6;
       var$7$hi = i64toi32_i32$3;
       var$2 = var$2 + 4294967295 | 0;
       if (var$2) continue label$15;
       break label$15;
      } while (1);
      break label$13;
     };
    };
    i64toi32_i32$3 = var$5$hi;
    i64toi32_i32$2 = 1024;
    i64toi32_i32$3 = i64toi32_i32$3;
    wasm2js_i32$0 = i64toi32_i32$2;
    wasm2js_i32$1 = var$5;
    HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
    wasm2js_i32$0 = i64toi32_i32$2;
    wasm2js_i32$1 = i64toi32_i32$3;
    (wasm2js_i32$2 = wasm2js_i32$0, wasm2js_i32$3 = wasm2js_i32$1), ((HEAP8[(wasm2js_i32$2 + 4 | 0) >> 0] = wasm2js_i32$3 & 255 | 0, HEAP8[(wasm2js_i32$2 + 5 | 0) >> 0] = (wasm2js_i32$3 >>> 8 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 6 | 0) >> 0] = (wasm2js_i32$3 >>> 16 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 7 | 0) >> 0] = (wasm2js_i32$3 >>> 24 | 0) & 255 | 0;
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$3 = i64toi32_i32$3;
    i64toi32_i32$5 = var$0;
    i64toi32_i32$2 = 0;
    i64toi32_i32$0 = 1;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$2 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
     $50_1 = 0;
    } else {
     i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$5 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
     $50_1 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
    }
    $165$hi = i64toi32_i32$2;
    i64toi32_i32$2 = var$6$hi;
    i64toi32_i32$2 = $165$hi;
    i64toi32_i32$3 = $50_1;
    i64toi32_i32$5 = var$6$hi;
    i64toi32_i32$0 = var$6;
    i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
    i64toi32_i32$5 = i64toi32_i32$5;
    i64toi32_i32$3 = i64toi32_i32$3 | i64toi32_i32$0 | 0;
    i64toi32_i32$HIGH_BITS = i64toi32_i32$5;
    return i64toi32_i32$3 | 0;
   };
   i64toi32_i32$3 = var$0$hi;
   i64toi32_i32$5 = 1024;
   i64toi32_i32$3 = i64toi32_i32$3;
   wasm2js_i32$0 = i64toi32_i32$5;
   wasm2js_i32$1 = var$0;
   HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
   wasm2js_i32$0 = i64toi32_i32$5;
   wasm2js_i32$1 = i64toi32_i32$3;
   (wasm2js_i32$2 = wasm2js_i32$0, wasm2js_i32$3 = wasm2js_i32$1), ((HEAP8[(wasm2js_i32$2 + 4 | 0) >> 0] = wasm2js_i32$3 & 255 | 0, HEAP8[(wasm2js_i32$2 + 5 | 0) >> 0] = (wasm2js_i32$3 >>> 8 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 6 | 0) >> 0] = (wasm2js_i32$3 >>> 16 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 7 | 0) >> 0] = (wasm2js_i32$3 >>> 24 | 0) & 255 | 0;
   i64toi32_i32$3 = 0;
   var$0 = 0;
   var$0$hi = i64toi32_i32$3;
  };
  i64toi32_i32$3 = var$0$hi;
  i64toi32_i32$3 = i64toi32_i32$3;
  i64toi32_i32$3 = i64toi32_i32$3;
  i64toi32_i32$3 = i64toi32_i32$3;
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
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$1;
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
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$1;
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
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$1;
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
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function __wasm_i64_urem(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$2 = 0, wasm2js_i32$0 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$2 = 1024;
  i64toi32_i32$0 = HEAPU32[i64toi32_i32$2 >> 2] | 0;
  i64toi32_i32$1 = (wasm2js_i32$0 = i64toi32_i32$2, HEAPU8[(wasm2js_i32$0 + 4 | 0) >> 0] | 0 | 0 | (HEAPU8[(wasm2js_i32$0 + 5 | 0) >> 0] | 0 | 0) << 8 | (HEAPU8[(wasm2js_i32$0 + 6 | 0) >> 0] | 0 | 0) << 16 | (HEAPU8[(wasm2js_i32$0 + 7 | 0) >> 0] | 0 | 0) << 24);
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function __wasm_ctz_i32(var$0) {
  var$0 = var$0 | 0;
  if (var$0) return 31 - Math_clz32((var$0 + 4294967295 | 0) ^ var$0 | 0) | 0 | 0;
  return 32 | 0;
 }
 
 var FUNCTION_TABLE_idd = [f64_t0, f64_t0, f64_t0, f64_t0, f64_t0, f64_t0, f64_t0, f64_t1];
 var FUNCTION_TABLE_iff = [f32_t0, f32_t0, f32_t0, f32_t0, f32_t0, f32_t1, f32_t0, f32_t0];
 var FUNCTION_TABLE_iii = [i32_t0, i32_t1, i32_t0, i32_t0, i32_t0, i32_t0, i32_t0, i32_t0];
 var FUNCTION_TABLE_iiiii = [i64_t0, i64_t0, i64_t0, i64_t1, i64_t0, i64_t0, i64_t0, i64_t0];
 return {
  i32_add: $35, 
  i32_sub: $36, 
  i32_mul: $37, 
  i32_div_s: $38, 
  i32_div_u: $39, 
  i32_rem_s: $40, 
  i32_rem_u: $41, 
  i32_and: $42, 
  i32_or: $43, 
  i32_xor: $44, 
  i32_shl: $45, 
  i32_shr_u: $46, 
  i32_shr_s: $47, 
  i32_eq: $48, 
  i32_ne: $49, 
  i32_lt_s: $50, 
  i32_le_s: $51, 
  i32_lt_u: $52, 
  i32_le_u: $53, 
  i32_gt_s: $54, 
  i32_ge_s: $55, 
  i32_gt_u: $56, 
  i32_ge_u: $57, 
  i32_store: $58, 
  i32_store8: $59, 
  i32_store16: $60, 
  i32_call: $61, 
  i32_call_indirect: $62, 
  i32_select: $63, 
  i64_add: $64, 
  i64_sub: $65, 
  i64_mul: $66, 
  i64_div_s: $67, 
  i64_div_u: $68, 
  i64_rem_s: $69, 
  i64_rem_u: $70, 
  i64_and: $71, 
  i64_or: $72, 
  i64_xor: $73, 
  i64_shl: $74, 
  i64_shr_u: $75, 
  i64_shr_s: $76, 
  i64_eq: $77, 
  i64_ne: $78, 
  i64_lt_s: $79, 
  i64_le_s: $80, 
  i64_lt_u: $81, 
  i64_le_u: $82, 
  i64_gt_s: $83, 
  i64_ge_s: $84, 
  i64_gt_u: $85, 
  i64_ge_u: $86, 
  i64_store: $87, 
  i64_store8: $88, 
  i64_store16: $89, 
  i64_store32: $90, 
  i64_call: $91, 
  i64_call_indirect: $92, 
  i64_select: $93, 
  f32_add: $94, 
  f32_sub: $95, 
  f32_mul: $96, 
  f32_div: $97, 
  f32_copysign: $98, 
  f32_eq: $99, 
  f32_ne: $100, 
  f32_lt: $101, 
  f32_le: $102, 
  f32_gt: $103, 
  f32_ge: $104, 
  f32_min: $105, 
  f32_max: $106, 
  f32_store: $107, 
  f32_call: $108, 
  f32_call_indirect: $109, 
  f32_select: $110, 
  f64_add: $111, 
  f64_sub: $112, 
  f64_mul: $113, 
  f64_div: $114, 
  f64_copysign: $115, 
  f64_eq: $116, 
  f64_ne: $117, 
  f64_lt: $118, 
  f64_le: $119, 
  f64_gt: $120, 
  f64_ge: $121, 
  f64_min: $122, 
  f64_max: $123, 
  f64_store: $124, 
  f64_call: $125, 
  f64_call_indirect: $126, 
  f64_select: $127, 
  br_if: $128, 
  br_table: $129
 };
}

const memasmFunc = new ArrayBuffer(65536);
const retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export const i32_add = retasmFunc.i32_add;
export const i32_sub = retasmFunc.i32_sub;
export const i32_mul = retasmFunc.i32_mul;
export const i32_div_s = retasmFunc.i32_div_s;
export const i32_div_u = retasmFunc.i32_div_u;
export const i32_rem_s = retasmFunc.i32_rem_s;
export const i32_rem_u = retasmFunc.i32_rem_u;
export const i32_and = retasmFunc.i32_and;
export const i32_or = retasmFunc.i32_or;
export const i32_xor = retasmFunc.i32_xor;
export const i32_shl = retasmFunc.i32_shl;
export const i32_shr_u = retasmFunc.i32_shr_u;
export const i32_shr_s = retasmFunc.i32_shr_s;
export const i32_eq = retasmFunc.i32_eq;
export const i32_ne = retasmFunc.i32_ne;
export const i32_lt_s = retasmFunc.i32_lt_s;
export const i32_le_s = retasmFunc.i32_le_s;
export const i32_lt_u = retasmFunc.i32_lt_u;
export const i32_le_u = retasmFunc.i32_le_u;
export const i32_gt_s = retasmFunc.i32_gt_s;
export const i32_ge_s = retasmFunc.i32_ge_s;
export const i32_gt_u = retasmFunc.i32_gt_u;
export const i32_ge_u = retasmFunc.i32_ge_u;
export const i32_store = retasmFunc.i32_store;
export const i32_store8 = retasmFunc.i32_store8;
export const i32_store16 = retasmFunc.i32_store16;
export const i32_call = retasmFunc.i32_call;
export const i32_call_indirect = retasmFunc.i32_call_indirect;
export const i32_select = retasmFunc.i32_select;
export const i64_add = retasmFunc.i64_add;
export const i64_sub = retasmFunc.i64_sub;
export const i64_mul = retasmFunc.i64_mul;
export const i64_div_s = retasmFunc.i64_div_s;
export const i64_div_u = retasmFunc.i64_div_u;
export const i64_rem_s = retasmFunc.i64_rem_s;
export const i64_rem_u = retasmFunc.i64_rem_u;
export const i64_and = retasmFunc.i64_and;
export const i64_or = retasmFunc.i64_or;
export const i64_xor = retasmFunc.i64_xor;
export const i64_shl = retasmFunc.i64_shl;
export const i64_shr_u = retasmFunc.i64_shr_u;
export const i64_shr_s = retasmFunc.i64_shr_s;
export const i64_eq = retasmFunc.i64_eq;
export const i64_ne = retasmFunc.i64_ne;
export const i64_lt_s = retasmFunc.i64_lt_s;
export const i64_le_s = retasmFunc.i64_le_s;
export const i64_lt_u = retasmFunc.i64_lt_u;
export const i64_le_u = retasmFunc.i64_le_u;
export const i64_gt_s = retasmFunc.i64_gt_s;
export const i64_ge_s = retasmFunc.i64_ge_s;
export const i64_gt_u = retasmFunc.i64_gt_u;
export const i64_ge_u = retasmFunc.i64_ge_u;
export const i64_store = retasmFunc.i64_store;
export const i64_store8 = retasmFunc.i64_store8;
export const i64_store16 = retasmFunc.i64_store16;
export const i64_store32 = retasmFunc.i64_store32;
export const i64_call = retasmFunc.i64_call;
export const i64_call_indirect = retasmFunc.i64_call_indirect;
export const i64_select = retasmFunc.i64_select;
export const f32_add = retasmFunc.f32_add;
export const f32_sub = retasmFunc.f32_sub;
export const f32_mul = retasmFunc.f32_mul;
export const f32_div = retasmFunc.f32_div;
export const f32_copysign = retasmFunc.f32_copysign;
export const f32_eq = retasmFunc.f32_eq;
export const f32_ne = retasmFunc.f32_ne;
export const f32_lt = retasmFunc.f32_lt;
export const f32_le = retasmFunc.f32_le;
export const f32_gt = retasmFunc.f32_gt;
export const f32_ge = retasmFunc.f32_ge;
export const f32_min = retasmFunc.f32_min;
export const f32_max = retasmFunc.f32_max;
export const f32_store = retasmFunc.f32_store;
export const f32_call = retasmFunc.f32_call;
export const f32_call_indirect = retasmFunc.f32_call_indirect;
export const f32_select = retasmFunc.f32_select;
export const f64_add = retasmFunc.f64_add;
export const f64_sub = retasmFunc.f64_sub;
export const f64_mul = retasmFunc.f64_mul;
export const f64_div = retasmFunc.f64_div;
export const f64_copysign = retasmFunc.f64_copysign;
export const f64_eq = retasmFunc.f64_eq;
export const f64_ne = retasmFunc.f64_ne;
export const f64_lt = retasmFunc.f64_lt;
export const f64_le = retasmFunc.f64_le;
export const f64_gt = retasmFunc.f64_gt;
export const f64_ge = retasmFunc.f64_ge;
export const f64_min = retasmFunc.f64_min;
export const f64_max = retasmFunc.f64_max;
export const f64_store = retasmFunc.f64_store;
export const f64_call = retasmFunc.f64_call;
export const f64_call_indirect = retasmFunc.f64_call_indirect;
export const f64_select = retasmFunc.f64_select;
export const br_if = retasmFunc.br_if;
export const br_table = retasmFunc.br_table;
