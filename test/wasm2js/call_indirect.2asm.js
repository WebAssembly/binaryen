import { setTempRet0 } from 'env';

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
 var setTempRet0 = env.setTempRet0;
 var i64toi32_i32$HIGH_BITS = 0;
 function const_i32() {
  return 306 | 0;
 }
 
 function const_i64() {
  i64toi32_i32$HIGH_BITS = 0;
  return 356 | 0;
 }
 
 function const_f32() {
  return Math_fround(Math_fround(3890.0));
 }
 
 function const_f64() {
  return +(3940.0);
 }
 
 function id_i32($0) {
  $0 = $0 | 0;
  return $0 | 0;
 }
 
 function id_i64($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  i64toi32_i32$HIGH_BITS = $1;
  return $0 | 0;
 }
 
 function id_f32($0) {
  $0 = Math_fround($0);
  return Math_fround($0);
 }
 
 function id_f64($0) {
  $0 = +$0;
  return +$0;
 }
 
 function i32_i64($0, $1, $2) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2 = $2 | 0;
  i64toi32_i32$HIGH_BITS = $2;
  return $1 | 0;
 }
 
 function i64_f64($0, $1, $2) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2 = +$2;
  return +$2;
 }
 
 function f32_i32($0, $1) {
  $0 = Math_fround($0);
  $1 = $1 | 0;
  return $1 | 0;
 }
 
 function f64_f32($0, $1) {
  $0 = +$0;
  $1 = Math_fround($1);
  return Math_fround($1);
 }
 
 function over_i32_duplicate($0) {
  $0 = $0 | 0;
  return $0 | 0;
 }
 
 function over_i64_duplicate($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  i64toi32_i32$HIGH_BITS = $1;
  return $0 | 0;
 }
 
 function over_f32_duplicate($0) {
  $0 = Math_fround($0);
  return Math_fround($0);
 }
 
 function over_f64_duplicate($0) {
  $0 = +$0;
  return +$0;
 }
 
 function $16() {
  return FUNCTION_TABLE[0]() | 0 | 0;
 }
 
 function $17() {
  var $0 = 0, $1 = 0;
  $0 = FUNCTION_TABLE[1]() | 0;
  $1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1;
  return $0 | 0;
 }
 
 function $18() {
  return Math_fround(Math_fround(FUNCTION_TABLE[2]()));
 }
 
 function $19() {
  return +(+FUNCTION_TABLE[3]());
 }
 
 function $20() {
  var $0 = 0, $1 = 0;
  $0 = 0;
  $0 = FUNCTION_TABLE[5](100, $0) | 0;
  $1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1;
  return $0 | 0;
 }
 
 function $21() {
  return FUNCTION_TABLE[4](32) | 0 | 0;
 }
 
 function $22() {
  var $0 = 0, $1 = 0;
  $0 = 0;
  $0 = FUNCTION_TABLE[5](64, $0) | 0;
  $1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1;
  return $0 | 0;
 }
 
 function $23() {
  return Math_fround(Math_fround(FUNCTION_TABLE[6](Math_fround(1.3200000524520874))));
 }
 
 function $24() {
  return +(+FUNCTION_TABLE[7](1.64));
 }
 
 function $25() {
  return FUNCTION_TABLE[8](Math_fround(32.099998474121094), 32) | 0 | 0;
 }
 
 function $26() {
  var $0 = 0, $1 = 0;
  $0 = 0;
  $0 = FUNCTION_TABLE[9](32, 64, $0) | 0;
  $1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1;
  return $0 | 0;
 }
 
 function $27() {
  return Math_fround(Math_fround(FUNCTION_TABLE[10](64.0, Math_fround(32.0))));
 }
 
 function $28() {
  return +(+FUNCTION_TABLE[11](64, 0, 64.1));
 }
 
 function $29($0, $1, $2) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2 = $2 | 0;
  $2 = FUNCTION_TABLE[$0]($1, $2) | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $0;
  return $2 | 0;
 }
 
 function $30($0) {
  $0 = $0 | 0;
  var $1 = 0;
  $1 = 0;
  $1 = FUNCTION_TABLE[$0](9, $1) | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $0;
  return $1 | 0;
 }
 
 function fac($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var $2 = 0, $3 = 0, $4 = 0;
  $3 = $1;
  if (!($0 | $3 | 0)) {
   {
    $3 = 0;
    $2 = 1;
    $1 = $3;
   }
  } else {
   {
    $3 = $1;
    $1 = $0;
    $4 = 1;
    $2 = ($1 >>> 0 < $4 >>> 0) + 0 | 0;
    $2 = $3 - $2 | 0;
    $2 = FUNCTION_TABLE[12]($1 - $4 | 0, $2) | 0;
    $1 = i64toi32_i32$HIGH_BITS;
    $4 = $2;
    $2 = $1;
    $2 = __wasm_i64_mul($0 | 0, $3 | 0, $4 | 0, $2 | 0) | 0;
    $1 = i64toi32_i32$HIGH_BITS;
   }
  }
  i64toi32_i32$HIGH_BITS = $1;
  return $2 | 0;
 }
 
 function fib($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0;
  $5 = $1;
  $3 = $0;
  $2 = 0;
  $4 = 1;
  if ($5 >>> 0 < $2 >>> 0 | (($5 | 0) == ($2 | 0) & $3 >>> 0 <= $4 >>> 0 | 0) | 0) {
   {
    $3 = 0;
    $1 = 1;
    $5 = $3;
   }
  } else {
   {
    $3 = $1;
    $4 = $0;
    $5 = 0;
    $2 = 2;
    $6 = $4 - $2 | 0;
    $2 = $4 >>> 0 < $2 >>> 0;
    $1 = $2 + $5 | 0;
    $1 = $3 - $1 | 0;
    $1 = FUNCTION_TABLE[13]($6, $1) | 0;
    $4 = i64toi32_i32$HIGH_BITS;
    $7 = $1;
    $8 = $4;
    $4 = $3;
    $3 = $0;
    $1 = 0;
    $2 = 1;
    $5 = $3 - $2 | 0;
    $2 = $3 >>> 0 < $2 >>> 0;
    $6 = $2 + $1 | 0;
    $6 = $4 - $6 | 0;
    $6 = FUNCTION_TABLE[13]($5, $6) | 0;
    $3 = i64toi32_i32$HIGH_BITS;
    $0 = $6;
    $6 = $3;
    $3 = $8;
    $4 = $7;
    $2 = $0;
    $1 = $4 + $2 | 0;
    $5 = $3 + $6 | 0;
    if ($1 >>> 0 < $2 >>> 0) {
     $5 = $5 + 1 | 0
    }
   }
  }
  $4 = $1;
  i64toi32_i32$HIGH_BITS = $5;
  return $4 | 0;
 }
 
 function even($0) {
  $0 = $0 | 0;
  if (!$0) {
   $0 = 44
  } else {
   $0 = FUNCTION_TABLE[15]($0 - 1 | 0) | 0
  }
  return $0 | 0;
 }
 
 function odd($0) {
  $0 = $0 | 0;
  if (!$0) {
   $0 = 99
  } else {
   $0 = FUNCTION_TABLE[14]($0 - 1 | 0) | 0
  }
  return $0 | 0;
 }
 
 function runaway() {
  FUNCTION_TABLE[16]();
 }
 
 function mutual_runaway1() {
  FUNCTION_TABLE[18]();
 }
 
 function mutual_runaway2() {
  FUNCTION_TABLE[17]();
 }
 
 function legalstub$17() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0, $5 = 0;
  $0 = $17() | 0;
  $2 = i64toi32_i32$HIGH_BITS;
  $4 = $0;
  $5 = $2;
  $3 = 32;
  $1 = $3 & 31 | 0;
  if (32 >>> 0 <= ($3 & 63 | 0) >>> 0) {
   $0 = $2 >>> $1 | 0
  } else {
   $0 = (((1 << $1 | 0) - 1 | 0) & $2 | 0) << (32 - $1 | 0) | 0 | ($0 >>> $1 | 0) | 0
  }
  setTempRet0($0 | 0);
  return $4 | 0;
 }
 
 function legalstub$20() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0, $5 = 0;
  $0 = $20() | 0;
  $2 = i64toi32_i32$HIGH_BITS;
  $4 = $0;
  $5 = $2;
  $3 = 32;
  $1 = $3 & 31 | 0;
  if (32 >>> 0 <= ($3 & 63 | 0) >>> 0) {
   $0 = $2 >>> $1 | 0
  } else {
   $0 = (((1 << $1 | 0) - 1 | 0) & $2 | 0) << (32 - $1 | 0) | 0 | ($0 >>> $1 | 0) | 0
  }
  setTempRet0($0 | 0);
  return $4 | 0;
 }
 
 function legalstub$22() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0, $5 = 0;
  $0 = $22() | 0;
  $2 = i64toi32_i32$HIGH_BITS;
  $4 = $0;
  $5 = $2;
  $3 = 32;
  $1 = $3 & 31 | 0;
  if (32 >>> 0 <= ($3 & 63 | 0) >>> 0) {
   $0 = $2 >>> $1 | 0
  } else {
   $0 = (((1 << $1 | 0) - 1 | 0) & $2 | 0) << (32 - $1 | 0) | 0 | ($0 >>> $1 | 0) | 0
  }
  setTempRet0($0 | 0);
  return $4 | 0;
 }
 
 function legalstub$26() {
  var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0, $5 = 0;
  $0 = $26() | 0;
  $2 = i64toi32_i32$HIGH_BITS;
  $4 = $0;
  $5 = $2;
  $3 = 32;
  $1 = $3 & 31 | 0;
  if (32 >>> 0 <= ($3 & 63 | 0) >>> 0) {
   $0 = $2 >>> $1 | 0
  } else {
   $0 = (((1 << $1 | 0) - 1 | 0) & $2 | 0) << (32 - $1 | 0) | 0 | ($0 >>> $1 | 0) | 0
  }
  setTempRet0($0 | 0);
  return $4 | 0;
 }
 
 function legalstub$29($0, $1, $2) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2 = $2 | 0;
  var $3 = 0, $4 = 0, $5 = 0, $6 = 0, $7 = 0;
  $7 = $0;
  $0 = 0;
  $5 = $1;
  $6 = $0;
  $0 = 0;
  $4 = 32;
  $3 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $1 = $2 << $3 | 0;
    $4 = 0;
   }
  } else {
   {
    $1 = ((1 << $3 | 0) - 1 | 0) & ($2 >>> (32 - $3 | 0) | 0) | 0 | ($0 << $3 | 0) | 0;
    $4 = $2 << $3 | 0;
   }
  }
  $2 = $1;
  $1 = $6;
  $0 = $5;
  $2 = $1 | $2 | 0;
  $2 = $29($7 | 0, $0 | $4 | 0 | 0, $2 | 0) | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  $6 = $2;
  $5 = $0;
  $1 = $2;
  $4 = 32;
  $3 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0 = $0 >>> $3 | 0
  } else {
   $0 = (((1 << $3 | 0) - 1 | 0) & $0 | 0) << (32 - $3 | 0) | 0 | ($1 >>> $3 | 0) | 0
  }
  setTempRet0($0 | 0);
  return $6 | 0;
 }
 
 function legalstub$30($0) {
  $0 = $0 | 0;
  var $1 = 0, $2 = 0, $3 = 0, $4 = 0, $5 = 0;
  $0 = $30($0 | 0) | 0;
  $2 = i64toi32_i32$HIGH_BITS;
  $4 = $0;
  $5 = $2;
  $3 = 32;
  $1 = $3 & 31 | 0;
  if (32 >>> 0 <= ($3 & 63 | 0) >>> 0) {
   $0 = $2 >>> $1 | 0
  } else {
   $0 = (((1 << $1 | 0) - 1 | 0) & $2 | 0) << (32 - $1 | 0) | 0 | ($0 >>> $1 | 0) | 0
  }
  setTempRet0($0 | 0);
  return $4 | 0;
 }
 
 function legalstub$fac($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0;
  $3 = 0;
  $5 = $0;
  $6 = $3;
  $3 = 0;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0 = $1 << $2 | 0;
    $4 = 0;
   }
  } else {
   {
    $0 = ((1 << $2 | 0) - 1 | 0) & ($1 >>> (32 - $2 | 0) | 0) | 0 | ($3 << $2 | 0) | 0;
    $4 = $1 << $2 | 0;
   }
  }
  $1 = $0;
  $0 = $6;
  $3 = $5;
  $1 = $0 | $1 | 0;
  $1 = fac($3 | $4 | 0 | 0, $1 | 0) | 0;
  $3 = i64toi32_i32$HIGH_BITS;
  $6 = $1;
  $5 = $3;
  $0 = $1;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0 = $3 >>> $2 | 0
  } else {
   $0 = (((1 << $2 | 0) - 1 | 0) & $3 | 0) << (32 - $2 | 0) | 0 | ($0 >>> $2 | 0) | 0
  }
  setTempRet0($0 | 0);
  return $6 | 0;
 }
 
 function legalstub$fib($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0;
  $3 = 0;
  $5 = $0;
  $6 = $3;
  $3 = 0;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0 = $1 << $2 | 0;
    $4 = 0;
   }
  } else {
   {
    $0 = ((1 << $2 | 0) - 1 | 0) & ($1 >>> (32 - $2 | 0) | 0) | 0 | ($3 << $2 | 0) | 0;
    $4 = $1 << $2 | 0;
   }
  }
  $1 = $0;
  $0 = $6;
  $3 = $5;
  $1 = $0 | $1 | 0;
  $1 = fib($3 | $4 | 0 | 0, $1 | 0) | 0;
  $3 = i64toi32_i32$HIGH_BITS;
  $6 = $1;
  $5 = $3;
  $0 = $1;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0 = $3 >>> $2 | 0
  } else {
   $0 = (((1 << $2 | 0) - 1 | 0) & $3 | 0) << (32 - $2 | 0) | 0 | ($0 >>> $2 | 0) | 0
  }
  setTempRet0($0 | 0);
  return $6 | 0;
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
 
 var FUNCTION_TABLE = [const_i32, const_i64, const_f32, const_f64, id_i32, id_i64, id_f32, id_f64, f32_i32, i32_i64, f64_f32, i64_f64, fac, fib, even, odd, runaway, mutual_runaway1, mutual_runaway2, over_i32_duplicate, over_i64_duplicate, over_f32_duplicate, over_f64_duplicate];
 return {
  "type_i32": $16, 
  "type_i64": legalstub$17, 
  "type_f32": $18, 
  "type_f64": $19, 
  "type_index": legalstub$20, 
  "type_first_i32": $21, 
  "type_first_i64": legalstub$22, 
  "type_first_f32": $23, 
  "type_first_f64": $24, 
  "type_second_i32": $25, 
  "type_second_i64": legalstub$26, 
  "type_second_f32": $27, 
  "type_second_f64": $28, 
  "dispatch": legalstub$29, 
  "dispatch_structural": legalstub$30, 
  "fac": legalstub$fac, 
  "fib": legalstub$fib, 
  "even": even, 
  "odd": odd, 
  "runaway": runaway, 
  "mutual_runaway": mutual_runaway1
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0},memasmFunc);
export var type_i32 = retasmFunc.type_i32;
export var type_i64 = retasmFunc.type_i64;
export var type_f32 = retasmFunc.type_f32;
export var type_f64 = retasmFunc.type_f64;
export var type_index = retasmFunc.type_index;
export var type_first_i32 = retasmFunc.type_first_i32;
export var type_first_i64 = retasmFunc.type_first_i64;
export var type_first_f32 = retasmFunc.type_first_f32;
export var type_first_f64 = retasmFunc.type_first_f64;
export var type_second_i32 = retasmFunc.type_second_i32;
export var type_second_i64 = retasmFunc.type_second_i64;
export var type_second_f32 = retasmFunc.type_second_f32;
export var type_second_f64 = retasmFunc.type_second_f64;
export var dispatch = retasmFunc.dispatch;
export var dispatch_structural = retasmFunc.dispatch_structural;
export var fac = retasmFunc.fac;
export var fib = retasmFunc.fib;
export var even = retasmFunc.even;
export var odd = retasmFunc.odd;
export var runaway = retasmFunc.runaway;
export var mutual_runaway = retasmFunc.mutual_runaway;
