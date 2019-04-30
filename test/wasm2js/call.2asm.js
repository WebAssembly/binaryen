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
 function $12() {
  return 306 | 0;
 }
 
 function $14() {
  return Math_fround(Math_fround(3890.0));
 }
 
 function $15() {
  return 3940.0;
 }
 
 function $16() {
  return 32 | 0;
 }
 
 function $18() {
  return Math_fround(Math_fround(1.3200000524520874));
 }
 
 function $19() {
  return 1.64;
 }
 
 function $22() {
  return Math_fround(Math_fround(32.0));
 }
 
 function $23() {
  return 64.1;
 }
 
 function fac($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var $2 = 0, $3 = 0;
  if ($0 | $1) {
   {
    $2 = 1;
    $0 = __wasm_i64_mul($0, $1, fac($0 - $2 | 0, $1 - ($0 >>> 0 < $2 >>> 0) | 0), i64toi32_i32$HIGH_BITS);
    $3 = i64toi32_i32$HIGH_BITS;
   }
  } else {
   {
    $0 = 1;
    $3 = 0;
   }
  }
  i64toi32_i32$HIGH_BITS = $3;
  return $0 | 0;
 }
 
 function fac_acc($0, $1, $2, $3) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2 = $2 | 0;
  $3 = $3 | 0;
  var $4 = 0;
  if ($0 | $1) {
   {
    $4 = 1;
    $2 = fac_acc($0 - $4 | 0, $1 - ($0 >>> 0 < $4 >>> 0) | 0, __wasm_i64_mul($0, $1, $2, $3), i64toi32_i32$HIGH_BITS);
    $3 = i64toi32_i32$HIGH_BITS;
   }
  }
  i64toi32_i32$HIGH_BITS = $3;
  return $2 | 0;
 }
 
 function fib($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var $2 = 0, $3 = 0, $4 = 0, $5 = 0;
  if ((0 | 0) == ($1 | 0) & $0 >>> 0 <= 1 >>> 0 | $1 >>> 0 < $2 >>> 0) {
   {
    $0 = 0;
    $4 = 1;
   }
  } else {
   {
    $3 = 2;
    $2 = fib($0 - $3 | 0, $1 - ($0 >>> 0 < $3 >>> 0) | 0);
    $3 = i64toi32_i32$HIGH_BITS;
    $5 = $2;
    $2 = 1;
    $2 = fib($0 - $2 | 0, $1 - ($0 >>> 0 < $2 >>> 0) | 0);
    $1 = $5 + $2 | 0;
    $0 = i64toi32_i32$HIGH_BITS + $3 | 0;
    $0 = $1 >>> 0 < $2 >>> 0 ? $0 + 1 | 0 : $0;
    $4 = $1;
   }
  }
  $1 = $4;
  i64toi32_i32$HIGH_BITS = $0;
  return $1 | 0;
 }
 
 function even($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var $2 = 0, $3 = 0;
  if ($0 | $1) {
   {
    $2 = 1;
    $3 = odd($0 - $2 | 0, $1 - ($0 >>> 0 < $2 >>> 0) | 0);
   }
  } else {
   $3 = 44
  }
  return $3 | 0;
 }
 
 function odd($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var $2 = 0, $3 = 0;
  if ($0 | $1) {
   {
    $2 = 1;
    $3 = even($0 - $2 | 0, $1 - ($0 >>> 0 < $2 >>> 0) | 0);
   }
  } else {
   $3 = 99
  }
  return $3 | 0;
 }
 
 function runaway() {
  runaway();
 }
 
 function mutual_runaway1() {
  mutual_runaway1();
 }
 
 function legalstub$13() {
  i64toi32_i32$HIGH_BITS = 0;
  setTempRet0(i64toi32_i32$HIGH_BITS | 0);
  return 356;
 }
 
 function legalstub$17() {
  i64toi32_i32$HIGH_BITS = 0;
  setTempRet0(i64toi32_i32$HIGH_BITS | 0);
  return 64;
 }
 
 function legalstub$fac($0, $1) {
  var $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0;
  $5 = $0;
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
  $1 = fac($5 | $4, $2 | $6);
  $6 = $1;
  $2 = i64toi32_i32$HIGH_BITS;
  $0 = 32 & 31;
  setTempRet0((32 >>> 0 <= $3 >>> 0 ? $2 >>> $0 : ((1 << $0) - 1 & $2) << 32 - $0 | $1 >>> $0) | 0);
  return $1;
 }
 
 function legalstub$fac_acc($0, $1, $2, $3) {
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12_1 = 0, $13 = 0;
  $8 = $0;
  $5 = 32;
  $0 = $5 & 31;
  if (32 >>> 0 <= $5 >>> 0) {
   {
    $4 = $1 << $0;
    $6 = 0;
   }
  } else {
   {
    $4 = (1 << $0) - 1 & $1 >>> 32 - $0 | $4 << $0;
    $6 = $1 << $0;
   }
  }
  $9 = $8 | $6;
  $10 = $4 | $12_1;
  $11 = $2;
  $2 = 0;
  $1 = $3;
  $3 = 32;
  $0 = $3 & 31;
  if (32 >>> 0 <= $3 >>> 0) {
   {
    $2 = $1 << $0;
    $7 = 0;
   }
  } else {
   {
    $2 = (1 << $0) - 1 & $1 >>> 32 - $0 | $2 << $0;
    $7 = $1 << $0;
   }
  }
  $1 = fac_acc($9, $10, $11 | $7, $2 | $13);
  $3 = $1;
  $2 = i64toi32_i32$HIGH_BITS;
  $4 = 32;
  $0 = $4 & 31;
  setTempRet0((32 >>> 0 <= $4 >>> 0 ? $2 >>> $0 : ((1 << $0) - 1 & $2) << 32 - $0 | $1 >>> $0) | 0);
  return $1;
 }
 
 function legalstub$fib($0, $1) {
  var $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0;
  $5 = $0;
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
  $1 = fib($5 | $4, $2 | $6);
  $6 = $1;
  $2 = i64toi32_i32$HIGH_BITS;
  $0 = 32 & 31;
  setTempRet0((32 >>> 0 <= $3 >>> 0 ? $2 >>> $0 : ((1 << $0) - 1 & $2) << 32 - $0 | $1 >>> $0) | 0);
  return $1;
 }
 
 function legalstub$even($0, $1) {
  var $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0;
  $5 = $0;
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
  return even($5 | $4, $2 | $6);
 }
 
 function legalstub$odd($0, $1) {
  var $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0;
  $5 = $0;
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
  return odd($5 | $4, $2 | $6);
 }
 
 function _ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE($0, $1, $2, $3) {
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12_1 = 0;
  $4 = $2 >>> 16;
  $5 = $0 >>> 16;
  $7 = Math_imul($4, $5);
  $8 = $2 & 65535;
  $6 = $0 & 65535;
  $9 = Math_imul($8, $6);
  $5 = ($9 >>> 16) + Math_imul($5, $8) | 0;
  $4 = ($5 & 65535) + Math_imul($4, $6) | 0;
  $8 = 0;
  $11 = $7;
  $6 = $0;
  $7 = 32;
  $0 = $7 & 31;
  $12_1 = $11 + Math_imul(32 >>> 0 <= $7 >>> 0 ? $1 >>> $0 : ((1 << $0) - 1 & $1) << 32 - $0 | $6 >>> $0, $2) | 0;
  $1 = $2;
  $2 = 32;
  $0 = $2 & 31;
  $1 = (($12_1 + Math_imul($6, 32 >>> 0 <= $2 >>> 0 ? $3 >>> $0 : ((1 << $0) - 1 & $3) << 32 - $0 | $1 >>> $0) | 0) + ($5 >>> 16) | 0) + ($4 >>> 16) | 0;
  $0 = 32 & 31;
  if (32 >>> 0 <= $2 >>> 0) {
   {
    $2 = $1 << $0;
    $10 = 0;
   }
  } else {
   {
    $2 = (1 << $0) - 1 & $1 >>> 32 - $0 | $8 << $0;
    $10 = $1 << $0;
   }
  }
  $0 = $10 | ($9 & 65535 | $4 << 16);
  i64toi32_i32$HIGH_BITS = $2;
  return $0;
 }
 
 function __wasm_i64_mul($0, $1, $2, $3) {
  $0 = _ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE($0, $1, $2, $3);
  return $0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "type_i32": $12, 
  "type_i64": legalstub$13, 
  "type_f32": $14, 
  "type_f64": $15, 
  "type_first_i32": $16, 
  "type_first_i64": legalstub$17, 
  "type_first_f32": $18, 
  "type_first_f64": $19, 
  "type_second_i32": $16, 
  "type_second_i64": legalstub$17, 
  "type_second_f32": $22, 
  "type_second_f64": $23, 
  "fac": legalstub$fac, 
  "fac_acc": legalstub$fac_acc, 
  "fib": legalstub$fib, 
  "even": legalstub$even, 
  "odd": legalstub$odd, 
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
export var type_first_i32 = retasmFunc.type_first_i32;
export var type_first_i64 = retasmFunc.type_first_i64;
export var type_first_f32 = retasmFunc.type_first_f32;
export var type_first_f64 = retasmFunc.type_first_f64;
export var type_second_i32 = retasmFunc.type_second_i32;
export var type_second_i64 = retasmFunc.type_second_i64;
export var type_second_f32 = retasmFunc.type_second_f32;
export var type_second_f64 = retasmFunc.type_second_f64;
export var fac = retasmFunc.fac;
export var fac_acc = retasmFunc.fac_acc;
export var fib = retasmFunc.fib;
export var even = retasmFunc.even;
export var odd = retasmFunc.odd;
export var runaway = retasmFunc.runaway;
export var mutual_runaway = retasmFunc.mutual_runaway;
