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
 
 function copysign64($0, $1) {
  $0 = +$0;
  $1 = +$1;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, $4 = 0, $4$hi = 0, $7 = 0, $7$hi = 0;
  HEAPF64[0 >> 3] = $0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$2 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$1 = 2147483647;
  i64toi32_i32$3 = 4294967295;
  i64toi32_i32$1 = i64toi32_i32$0 & i64toi32_i32$1 | 0;
  $4 = i64toi32_i32$2 & i64toi32_i32$3 | 0;
  $4$hi = i64toi32_i32$1;
  HEAPF64[0 >> 3] = $1;
  i64toi32_i32$1 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$0 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$2 = 2147483648;
  i64toi32_i32$3 = 0;
  i64toi32_i32$2 = i64toi32_i32$1 & i64toi32_i32$2 | 0;
  $7 = i64toi32_i32$0 & i64toi32_i32$3 | 0;
  $7$hi = i64toi32_i32$2;
  i64toi32_i32$2 = $4$hi;
  i64toi32_i32$1 = $4;
  i64toi32_i32$0 = $7$hi;
  i64toi32_i32$3 = $7;
  i64toi32_i32$0 = i64toi32_i32$2 | i64toi32_i32$0 | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  HEAP32[0 >> 2] = i64toi32_i32$1 | i64toi32_i32$3 | 0;
  HEAP32[(0 + 4 | 0) >> 2] = i64toi32_i32$0;
  return +(+HEAPF64[0 >> 3]);
 }
 
 function copysign32($0, $1) {
  $0 = Math_fround($0);
  $1 = Math_fround($1);
  return Math_fround((HEAP32[0] = (HEAPF32[0] = $0, HEAP32[0]) & 2147483647 | 0 | ((HEAPF32[0] = $1, HEAP32[0]) & 2147483648 | 0) | 0, HEAPF32[0]));
 }
 
 function $35($0) {
  $0 = $0 | 0;
  return Math_fround(Math_fround($0 | 0));
 }
 
 function $36($0) {
  $0 = $0 | 0;
  return +(+($0 | 0));
 }
 
 function $37($0) {
  $0 = $0 | 0;
  return Math_fround(Math_fround($0 >>> 0));
 }
 
 function $38($0) {
  $0 = $0 | 0;
  return +(+($0 >>> 0));
 }
 
 function $39($0) {
  $0 = Math_fround($0);
  return ~~$0 | 0;
 }
 
 function $40($0) {
  $0 = +$0;
  return ~~$0 | 0;
 }
 
 function $41($0) {
  $0 = Math_fround($0);
  return ~~$0 >>> 0 | 0;
 }
 
 function $42($0) {
  $0 = +$0;
  return ~~$0 >>> 0 | 0;
 }
 
 function $43($0, $0$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  return Math_fround(Math_fround(+($0 >>> 0) + 4294967296.0 * +(i64toi32_i32$0 | 0)));
 }
 
 function $44($0, $0$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  return +(+($0 >>> 0) + 4294967296.0 * +(i64toi32_i32$0 | 0));
 }
 
 function $45($0, $0$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  return Math_fround(Math_fround(+($0 >>> 0) + 4294967296.0 * +(i64toi32_i32$0 >>> 0)));
 }
 
 function $46($0, $0$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  return +(+($0 >>> 0) + 4294967296.0 * +(i64toi32_i32$0 >>> 0));
 }
 
 function $47($0) {
  $0 = Math_fround($0);
  var i64toi32_i32$0 = Math_fround(0), i64toi32_i32$1 = 0, $3 = 0, $4 = 0;
  i64toi32_i32$0 = $0;
  if (Math_fround(Math_abs(i64toi32_i32$0)) >= Math_fround(1.0)) {
   if (i64toi32_i32$0 > Math_fround(0.0)) $3 = ~~Math_fround(Math_min(Math_fround(Math_floor(Math_fround(i64toi32_i32$0 / Math_fround(4294967296.0)))), Math_fround(Math_fround(4294967296.0) - Math_fround(1.0)))) >>> 0; else $3 = ~~Math_fround(Math_ceil(Math_fround(Math_fround(i64toi32_i32$0 - Math_fround(~~i64toi32_i32$0 >>> 0 >>> 0)) / Math_fround(4294967296.0)))) >>> 0;
   $4 = $3;
  } else $4 = 0;
  i64toi32_i32$1 = $4;
  i64toi32_i32$1 = i64toi32_i32$1;
  return (~~i64toi32_i32$0 >>> 0 | 0) == (0 | 0) & (i64toi32_i32$1 | 0) == (0 | 0) | 0 | 0;
 }
 
 function $48($0) {
  $0 = +$0;
  var i64toi32_i32$0 = 0.0, i64toi32_i32$1 = 0, $3 = 0, $4 = 0;
  i64toi32_i32$0 = $0;
  if (Math_abs(i64toi32_i32$0) >= 1.0) {
   if (i64toi32_i32$0 > 0.0) $3 = ~~Math_min(Math_floor(i64toi32_i32$0 / 4294967296.0), 4294967296.0 - 1.0) >>> 0; else $3 = ~~Math_ceil((i64toi32_i32$0 - +(~~i64toi32_i32$0 >>> 0 >>> 0)) / 4294967296.0) >>> 0;
   $4 = $3;
  } else $4 = 0;
  i64toi32_i32$1 = $4;
  i64toi32_i32$1 = i64toi32_i32$1;
  return (~~i64toi32_i32$0 >>> 0 | 0) == (0 | 0) & (i64toi32_i32$1 | 0) == (0 | 0) | 0 | 0;
 }
 
 function $49($0) {
  $0 = Math_fround($0);
  var i64toi32_i32$0 = Math_fround(0), i64toi32_i32$1 = 0, $3 = 0, $4 = 0;
  i64toi32_i32$0 = $0;
  if (Math_fround(Math_abs(i64toi32_i32$0)) >= Math_fround(1.0)) {
   if (i64toi32_i32$0 > Math_fround(0.0)) $3 = ~~Math_fround(Math_min(Math_fround(Math_floor(Math_fround(i64toi32_i32$0 / Math_fround(4294967296.0)))), Math_fround(Math_fround(4294967296.0) - Math_fround(1.0)))) >>> 0; else $3 = ~~Math_fround(Math_ceil(Math_fround(Math_fround(i64toi32_i32$0 - Math_fround(~~i64toi32_i32$0 >>> 0 >>> 0)) / Math_fround(4294967296.0)))) >>> 0;
   $4 = $3;
  } else $4 = 0;
  i64toi32_i32$1 = $4;
  i64toi32_i32$1 = i64toi32_i32$1;
  return (~~i64toi32_i32$0 >>> 0 | 0) == (0 | 0) & (i64toi32_i32$1 | 0) == (0 | 0) | 0 | 0;
 }
 
 function $50($0) {
  $0 = +$0;
  var i64toi32_i32$0 = 0.0, i64toi32_i32$1 = 0, $3 = 0, $4 = 0;
  i64toi32_i32$0 = $0;
  if (Math_abs(i64toi32_i32$0) >= 1.0) {
   if (i64toi32_i32$0 > 0.0) $3 = ~~Math_min(Math_floor(i64toi32_i32$0 / 4294967296.0), 4294967296.0 - 1.0) >>> 0; else $3 = ~~Math_ceil((i64toi32_i32$0 - +(~~i64toi32_i32$0 >>> 0 >>> 0)) / 4294967296.0) >>> 0;
   $4 = $3;
  } else $4 = 0;
  i64toi32_i32$1 = $4;
  i64toi32_i32$1 = i64toi32_i32$1;
  return (~~i64toi32_i32$0 >>> 0 | 0) == (0 | 0) & (i64toi32_i32$1 | 0) == (0 | 0) | 0 | 0;
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
  f64_sqrt: $32, 
  i32_to_f32: $35, 
  i32_to_f64: $36, 
  u32_to_f32: $37, 
  u32_to_f64: $38, 
  f32_to_i32: $39, 
  f64_to_i32: $40, 
  f32_to_u32: $41, 
  f64_to_u32: $42, 
  i64_to_f32: $43, 
  i64_to_f64: $44, 
  u64_to_f32: $45, 
  u64_to_f64: $46, 
  f32_to_i64: $47, 
  f64_to_i64: $48, 
  f32_to_u64: $49, 
  f64_to_u64: $50
 };
}

