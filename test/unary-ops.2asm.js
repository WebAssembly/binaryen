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
 var i64toi32_i32$HIGH_BITS = 0;
 function dummy() {
  
 }
 
 function $1($0) {
  $0 = $0 | 0;
  return __wasm_popcnt_i32($0) | 0 | 0;
 }
 
 function $2($0, $0$hi, r, r$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  r = r | 0;
  r$hi = r$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$1 = $0;
  i64toi32_i32$1 = (__wasm_popcnt_i32(i64toi32_i32$0) | 0) + (__wasm_popcnt_i32(i64toi32_i32$1) | 0) | 0;
  i64toi32_i32$0 = r$hi;
  return (i64toi32_i32$1 | 0) == (r | 0) & (0 | 0) == (i64toi32_i32$0 | 0) | 0 | 0;
 }
 
 function $3($0, r, r$hi) {
  $0 = $0 | 0;
  r = r | 0;
  r$hi = r$hi | 0;
  return ($0 | 0) == (r | 0) & (0 | 0) == (r$hi | 0) | 0 | 0;
 }
 
 function $4($0, r, r$hi) {
  $0 = $0 | 0;
  r = r | 0;
  r$hi = r$hi | 0;
  var i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$1 = $0;
  i64toi32_i32$0 = i64toi32_i32$1 >> 31 | 0;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$1 = r$hi;
  return (i64toi32_i32$2 | 0) == (r | 0) & (i64toi32_i32$0 | 0) == (i64toi32_i32$1 | 0) | 0 | 0;
 }
 
 function $5($0, $0$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  return ($0 | $0$hi | 0 | 0) == (0 | 0) | 0;
 }
 
 function $6($0) {
  $0 = $0 | 0;
  return Math_clz32($0) | 0;
 }
 
 function $7($0) {
  $0 = $0 | 0;
  return __wasm_ctz_i32($0) | 0 | 0;
 }
 
 function $8($0, $0$hi, r, r$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  r = r | 0;
  r$hi = r$hi | 0;
  var i64toi32_i32$3 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, $7 = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$1 = $0;
  i64toi32_i32$3 = Math_clz32(i64toi32_i32$0);
  i64toi32_i32$2 = 0;
  if ((i64toi32_i32$3 | 0) == (32 | 0)) $7 = Math_clz32(i64toi32_i32$1) + 32 | 0; else $7 = i64toi32_i32$3;
  i64toi32_i32$1 = $7;
  i64toi32_i32$0 = r$hi;
  i64toi32_i32$3 = r;
  return (i64toi32_i32$1 | 0) == (i64toi32_i32$3 | 0) & (i64toi32_i32$2 | 0) == (i64toi32_i32$0 | 0) | 0 | 0;
 }
 
 function $9($0, $0$hi, r, r$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  r = r | 0;
  r$hi = r$hi | 0;
  var i64toi32_i32$3 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, $7 = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$1 = $0;
  i64toi32_i32$3 = __wasm_ctz_i32(i64toi32_i32$1) | 0;
  i64toi32_i32$2 = 0;
  if ((i64toi32_i32$3 | 0) == (32 | 0)) $7 = (__wasm_ctz_i32(i64toi32_i32$0) | 0) + 32 | 0; else $7 = i64toi32_i32$3;
  i64toi32_i32$1 = $7;
  i64toi32_i32$0 = r$hi;
  i64toi32_i32$3 = r;
  return (i64toi32_i32$1 | 0) == (i64toi32_i32$3 | 0) & (i64toi32_i32$2 | 0) == (i64toi32_i32$0 | 0) | 0 | 0;
 }
 
 function __wasm_ctz_i32(x) {
  x = x | 0;
  var $1 = 0;
  if ((x | 0) == (0 | 0)) $1 = 32; else $1 = 31 - Math_clz32(x ^ (x - 1 | 0) | 0) | 0;
  return $1 | 0;
 }
 
 function __wasm_popcnt_i32(x) {
  x = x | 0;
  var count = 0, $2 = 0;
  count = 0;
  b : {
   l : do {
    $2 = count;
    if ((x | 0) == (0 | 0)) break b;
    x = x & (x - 1 | 0) | 0;
    count = count + 1 | 0;
    continue l;
    break l;
   } while (1);
  };
  return $2 | 0;
 }
 
 function __wasm_rotl_i32(x, k) {
  x = x | 0;
  k = k | 0;
  return ((4294967295 >>> (k & 31 | 0) | 0) & x | 0) << (k & 31 | 0) | 0 | (((4294967295 << (32 - (k & 31 | 0) | 0) | 0) & x | 0) >>> (32 - (k & 31 | 0) | 0) | 0) | 0 | 0;
 }
 
 function __wasm_rotr_i32(x, k) {
  x = x | 0;
  k = k | 0;
  return ((4294967295 << (k & 31 | 0) | 0) & x | 0) >>> (k & 31 | 0) | 0 | (((4294967295 >>> (32 - (k & 31 | 0) | 0) | 0) & x | 0) << (32 - (k & 31 | 0) | 0) | 0) | 0 | 0;
 }
 
 return {
  i32_popcnt: $1, 
  check_popcnt_i64: $2, 
  check_extend_ui32: $3, 
  check_extend_si32: $4, 
  check_eqz_i64: $5, 
  i32_clz: $6, 
  i32_ctz: $7, 
  check_clz_i64: $8, 
  check_ctz_i64: $9
 };
}

