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
 var i64toi32_i32$HIGH_BITS = 0;
 function dummy() {
  
 }
 
 function $1($0, $1) {
  $0 = Math_fround($0);
  $1 = Math_fround($1);
  return Math_fround(Math_fround($0 + $1));
 }
 
 function $2($0, $1) {
  $0 = Math_fround($0);
  $1 = Math_fround($1);
  return Math_fround(Math_fround($0 - $1));
 }
 
 function $3($0, $1) {
  $0 = Math_fround($0);
  $1 = Math_fround($1);
  return Math_fround(Math_fround($0 * $1));
 }
 
 function $4($0, $1) {
  $0 = Math_fround($0);
  $1 = Math_fround($1);
  return Math_fround(Math_fround($0 / $1));
 }
 
 function $5($0, $1) {
  $0 = +$0;
  $1 = +$1;
  return +($0 + $1);
 }
 
 function $6($0, $1) {
  $0 = +$0;
  $1 = +$1;
  return +($0 - $1);
 }
 
 function $7($0, $1) {
  $0 = +$0;
  $1 = +$1;
  return +($0 * $1);
 }
 
 function $8($0, $1) {
  $0 = +$0;
  $1 = +$1;
  return +($0 / $1);
 }
 
 function $9($0, $1) {
  $0 = Math_fround($0);
  $1 = Math_fround($1);
  return $0 == $1 | 0;
 }
 
 function $10($0, $1) {
  $0 = Math_fround($0);
  $1 = Math_fround($1);
  return $0 != $1 | 0;
 }
 
 function $11($0, $1) {
  $0 = Math_fround($0);
  $1 = Math_fround($1);
  return $0 >= $1 | 0;
 }
 
 function $12($0, $1) {
  $0 = Math_fround($0);
  $1 = Math_fround($1);
  return $0 > $1 | 0;
 }
 
 function $13($0, $1) {
  $0 = Math_fround($0);
  $1 = Math_fround($1);
  return $0 <= $1 | 0;
 }
 
 function $14($0, $1) {
  $0 = Math_fround($0);
  $1 = Math_fround($1);
  return $0 < $1 | 0;
 }
 
 function $15($0, $1) {
  $0 = +$0;
  $1 = +$1;
  return $0 == $1 | 0;
 }
 
 function $16($0, $1) {
  $0 = +$0;
  $1 = +$1;
  return $0 != $1 | 0;
 }
 
 function $17($0, $1) {
  $0 = +$0;
  $1 = +$1;
  return $0 >= $1 | 0;
 }
 
 function $18($0, $1) {
  $0 = +$0;
  $1 = +$1;
  return $0 > $1 | 0;
 }
 
 function $19($0, $1) {
  $0 = +$0;
  $1 = +$1;
  return $0 <= $1 | 0;
 }
 
 function $20($0, $1) {
  $0 = +$0;
  $1 = +$1;
  return $0 < $1 | 0;
 }
 
 function $21($0, $1) {
  $0 = Math_fround($0);
  $1 = Math_fround($1);
  return Math_fround(Math_fround(Math_min($0, $1)));
 }
 
 function $22($0, $1) {
  $0 = Math_fround($0);
  $1 = Math_fround($1);
  return Math_fround(Math_fround(Math_max($0, $1)));
 }
 
 function $23($0, $1) {
  $0 = +$0;
  $1 = +$1;
  return +Math_min($0, $1);
 }
 
 function $24($0, $1) {
  $0 = +$0;
  $1 = +$1;
  return +Math_max($0, $1);
 }
 
 function $25($0) {
  $0 = Math_fround($0);
  return +(+$0);
 }
 
 function $26($0) {
  $0 = +$0;
  return Math_fround(Math_fround($0));
 }
 
 function $27($0) {
  $0 = Math_fround($0);
  return Math_fround(Math_fround(Math_floor($0)));
 }
 
 function $28($0) {
  $0 = Math_fround($0);
  return Math_fround(Math_fround(Math_ceil($0)));
 }
 
 function $29($0) {
  $0 = +$0;
  return +Math_floor($0);
 }
 
 function $30($0) {
  $0 = +$0;
  return +Math_ceil($0);
 }
 
 function $31($0) {
  $0 = Math_fround($0);
  return Math_fround(Math_fround(Math_sqrt($0)));
 }
 
 function $32($0) {
  $0 = +$0;
  return +Math_sqrt($0);
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
  f32_add: $1, 
  f32_sub: $2, 
  f32_mul: $3, 
  f32_div: $4, 
  f64_add: $5, 
  f64_sub: $6, 
  f64_mul: $7, 
  f64_div: $8, 
  f32_eq: $9, 
  f32_ne: $10, 
  f32_ge: $11, 
  f32_gt: $12, 
  f32_le: $13, 
  f32_lt: $14, 
  f64_eq: $15, 
  f64_ne: $16, 
  f64_ge: $17, 
  f64_gt: $18, 
  f64_le: $19, 
  f64_lt: $20, 
  f32_min: $21, 
  f32_max: $22, 
  f64_min: $23, 
  f64_max: $24, 
  f64_promote: $25, 
  f32_demote: $26, 
  f32_floor: $27, 
  f32_ceil: $28, 
  f64_floor: $29, 
  f64_ceil: $30, 
  f32_sqrt: $31, 
  f64_sqrt: $32
 };
}

