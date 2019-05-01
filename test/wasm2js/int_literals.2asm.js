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
 function $0() {
  return 195940365 | 0;
 }
 
 function $1() {
  return -1 | 0;
 }
 
 function $2() {
  return 2147483647 | 0;
 }
 
 function $3() {
  return -2147483647 | 0;
 }
 
 function $4() {
  return -2147483648 | 0;
 }
 
 function $5() {
  return -2147483648 | 0;
 }
 
 function $6() {
  return -2147483648 + 1 | 0 | 0;
 }
 
 function $7() {
  return 0 | 0;
 }
 
 function $8() {
  return 10 | 0;
 }
 
 function $9() {
  return -1 | 0;
 }
 
 function $10() {
  return 42 | 0;
 }
 
 function $11() {
  i64toi32_i32$HIGH_BITS = 212580974;
  return 195455598 | 0;
 }
 
 function $12() {
  i64toi32_i32$HIGH_BITS = -1;
  return -1 | 0;
 }
 
 function $13() {
  i64toi32_i32$HIGH_BITS = 2147483647;
  return -1 | 0;
 }
 
 function $14() {
  i64toi32_i32$HIGH_BITS = -2147483648;
  return 1 | 0;
 }
 
 function $15() {
  i64toi32_i32$HIGH_BITS = -2147483648;
  return 0 | 0;
 }
 
 function $16() {
  i64toi32_i32$HIGH_BITS = -2147483648;
  return 0 | 0;
 }
 
 function $17() {
  var $0_1 = 0, $1_1 = 0, $2_1 = 0;
  $1_1 = 1;
  $2_1 = 0 + $1_1 | 0;
  $0_1 = -2147483648 + 0 | 0;
  if ($2_1 >>> 0 < $1_1 >>> 0) {
   $0_1 = $0_1 + 1 | 0
  }
  i64toi32_i32$HIGH_BITS = $0_1;
  return $2_1 | 0;
 }
 
 function $18() {
  i64toi32_i32$HIGH_BITS = 0;
  return 0 | 0;
 }
 
 function $19() {
  i64toi32_i32$HIGH_BITS = 0;
  return 10 | 0;
 }
 
 function $20() {
  i64toi32_i32$HIGH_BITS = -1;
  return -1 | 0;
 }
 
 function $21() {
  i64toi32_i32$HIGH_BITS = 0;
  return 42 | 0;
 }
 
 function legalstub$11() {
  var $0_1 = 0, $1_1 = 0, $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0;
  $0_1 = $11() | 0;
  $2_1 = i64toi32_i32$HIGH_BITS;
  $4_1 = $0_1;
  $5_1 = $2_1;
  $3_1 = 32;
  $1_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   $0_1 = $2_1 >>> $1_1 | 0
  } else {
   $0_1 = (((1 << $1_1 | 0) - 1 | 0) & $2_1 | 0) << (32 - $1_1 | 0) | 0 | ($0_1 >>> $1_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $4_1 | 0;
 }
 
 function legalstub$12() {
  var $0_1 = 0, $1_1 = 0, $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0;
  $0_1 = $12() | 0;
  $2_1 = i64toi32_i32$HIGH_BITS;
  $4_1 = $0_1;
  $5_1 = $2_1;
  $3_1 = 32;
  $1_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   $0_1 = $2_1 >>> $1_1 | 0
  } else {
   $0_1 = (((1 << $1_1 | 0) - 1 | 0) & $2_1 | 0) << (32 - $1_1 | 0) | 0 | ($0_1 >>> $1_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $4_1 | 0;
 }
 
 function legalstub$13() {
  var $0_1 = 0, $1_1 = 0, $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0;
  $0_1 = $13() | 0;
  $2_1 = i64toi32_i32$HIGH_BITS;
  $4_1 = $0_1;
  $5_1 = $2_1;
  $3_1 = 32;
  $1_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   $0_1 = $2_1 >>> $1_1 | 0
  } else {
   $0_1 = (((1 << $1_1 | 0) - 1 | 0) & $2_1 | 0) << (32 - $1_1 | 0) | 0 | ($0_1 >>> $1_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $4_1 | 0;
 }
 
 function legalstub$14() {
  var $0_1 = 0, $1_1 = 0, $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0;
  $0_1 = $14() | 0;
  $2_1 = i64toi32_i32$HIGH_BITS;
  $4_1 = $0_1;
  $5_1 = $2_1;
  $3_1 = 32;
  $1_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   $0_1 = $2_1 >>> $1_1 | 0
  } else {
   $0_1 = (((1 << $1_1 | 0) - 1 | 0) & $2_1 | 0) << (32 - $1_1 | 0) | 0 | ($0_1 >>> $1_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $4_1 | 0;
 }
 
 function legalstub$15() {
  var $0_1 = 0, $1_1 = 0, $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0;
  $0_1 = $15() | 0;
  $2_1 = i64toi32_i32$HIGH_BITS;
  $4_1 = $0_1;
  $5_1 = $2_1;
  $3_1 = 32;
  $1_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   $0_1 = $2_1 >>> $1_1 | 0
  } else {
   $0_1 = (((1 << $1_1 | 0) - 1 | 0) & $2_1 | 0) << (32 - $1_1 | 0) | 0 | ($0_1 >>> $1_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $4_1 | 0;
 }
 
 function legalstub$16() {
  var $0_1 = 0, $1_1 = 0, $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0;
  $0_1 = $16() | 0;
  $2_1 = i64toi32_i32$HIGH_BITS;
  $4_1 = $0_1;
  $5_1 = $2_1;
  $3_1 = 32;
  $1_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   $0_1 = $2_1 >>> $1_1 | 0
  } else {
   $0_1 = (((1 << $1_1 | 0) - 1 | 0) & $2_1 | 0) << (32 - $1_1 | 0) | 0 | ($0_1 >>> $1_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $4_1 | 0;
 }
 
 function legalstub$17() {
  var $0_1 = 0, $1_1 = 0, $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0;
  $0_1 = $17() | 0;
  $2_1 = i64toi32_i32$HIGH_BITS;
  $4_1 = $0_1;
  $5_1 = $2_1;
  $3_1 = 32;
  $1_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   $0_1 = $2_1 >>> $1_1 | 0
  } else {
   $0_1 = (((1 << $1_1 | 0) - 1 | 0) & $2_1 | 0) << (32 - $1_1 | 0) | 0 | ($0_1 >>> $1_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $4_1 | 0;
 }
 
 function legalstub$18() {
  var $0_1 = 0, $1_1 = 0, $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0;
  $0_1 = $18() | 0;
  $2_1 = i64toi32_i32$HIGH_BITS;
  $4_1 = $0_1;
  $5_1 = $2_1;
  $3_1 = 32;
  $1_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   $0_1 = $2_1 >>> $1_1 | 0
  } else {
   $0_1 = (((1 << $1_1 | 0) - 1 | 0) & $2_1 | 0) << (32 - $1_1 | 0) | 0 | ($0_1 >>> $1_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $4_1 | 0;
 }
 
 function legalstub$19() {
  var $0_1 = 0, $1_1 = 0, $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0;
  $0_1 = $19() | 0;
  $2_1 = i64toi32_i32$HIGH_BITS;
  $4_1 = $0_1;
  $5_1 = $2_1;
  $3_1 = 32;
  $1_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   $0_1 = $2_1 >>> $1_1 | 0
  } else {
   $0_1 = (((1 << $1_1 | 0) - 1 | 0) & $2_1 | 0) << (32 - $1_1 | 0) | 0 | ($0_1 >>> $1_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $4_1 | 0;
 }
 
 function legalstub$20() {
  var $0_1 = 0, $1_1 = 0, $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0;
  $0_1 = $20() | 0;
  $2_1 = i64toi32_i32$HIGH_BITS;
  $4_1 = $0_1;
  $5_1 = $2_1;
  $3_1 = 32;
  $1_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   $0_1 = $2_1 >>> $1_1 | 0
  } else {
   $0_1 = (((1 << $1_1 | 0) - 1 | 0) & $2_1 | 0) << (32 - $1_1 | 0) | 0 | ($0_1 >>> $1_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $4_1 | 0;
 }
 
 function legalstub$21() {
  var $0_1 = 0, $1_1 = 0, $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0;
  $0_1 = $21() | 0;
  $2_1 = i64toi32_i32$HIGH_BITS;
  $4_1 = $0_1;
  $5_1 = $2_1;
  $3_1 = 32;
  $1_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   $0_1 = $2_1 >>> $1_1 | 0
  } else {
   $0_1 = (((1 << $1_1 | 0) - 1 | 0) & $2_1 | 0) << (32 - $1_1 | 0) | 0 | ($0_1 >>> $1_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $4_1 | 0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "i32_test": $0, 
  "i32_umax": $1, 
  "i32_smax": $2, 
  "i32_neg_smax": $3, 
  "i32_smin": $4, 
  "i32_alt_smin": $5, 
  "i32_inc_smin": $6, 
  "i32_neg_zero": $7, 
  "i32_not_octal": $8, 
  "i32_unsigned_decimal": $9, 
  "i32_plus_sign": $10, 
  "i64_test": legalstub$11, 
  "i64_umax": legalstub$12, 
  "i64_smax": legalstub$13, 
  "i64_neg_smax": legalstub$14, 
  "i64_smin": legalstub$15, 
  "i64_alt_smin": legalstub$16, 
  "i64_inc_smin": legalstub$17, 
  "i64_neg_zero": legalstub$18, 
  "i64_not_octal": legalstub$19, 
  "i64_unsigned_decimal": legalstub$20, 
  "i64_plus_sign": legalstub$21
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0},memasmFunc);
export var i32_test = retasmFunc.i32_test;
export var i32_umax = retasmFunc.i32_umax;
export var i32_smax = retasmFunc.i32_smax;
export var i32_neg_smax = retasmFunc.i32_neg_smax;
export var i32_smin = retasmFunc.i32_smin;
export var i32_alt_smin = retasmFunc.i32_alt_smin;
export var i32_inc_smin = retasmFunc.i32_inc_smin;
export var i32_neg_zero = retasmFunc.i32_neg_zero;
export var i32_not_octal = retasmFunc.i32_not_octal;
export var i32_unsigned_decimal = retasmFunc.i32_unsigned_decimal;
export var i32_plus_sign = retasmFunc.i32_plus_sign;
export var i64_test = retasmFunc.i64_test;
export var i64_umax = retasmFunc.i64_umax;
export var i64_smax = retasmFunc.i64_smax;
export var i64_neg_smax = retasmFunc.i64_neg_smax;
export var i64_smin = retasmFunc.i64_smin;
export var i64_alt_smin = retasmFunc.i64_alt_smin;
export var i64_inc_smin = retasmFunc.i64_inc_smin;
export var i64_neg_zero = retasmFunc.i64_neg_zero;
export var i64_not_octal = retasmFunc.i64_not_octal;
export var i64_unsigned_decimal = retasmFunc.i64_unsigned_decimal;
export var i64_plus_sign = retasmFunc.i64_plus_sign;
