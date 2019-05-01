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
 function $0($0_1, $1_1, $2_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  return ($2_1 ? $0_1 : $1_1) | 0;
 }
 
 function $1($0_1, $1_1, $2_1, $3_1, $4_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  $4_1 = $4_1 | 0;
  $2_1 = $4_1 ? $0_1 : $2_1;
  $0_1 = $4_1 ? $1_1 : $3_1;
  i64toi32_i32$HIGH_BITS = $0_1;
  return $2_1 | 0;
 }
 
 function $2($0_1, $1_1, $2_1) {
  $0_1 = Math_fround($0_1);
  $1_1 = Math_fround($1_1);
  $2_1 = $2_1 | 0;
  return Math_fround($2_1 ? $0_1 : $1_1);
 }
 
 function $3($0_1, $1_1, $2_1) {
  $0_1 = +$0_1;
  $1_1 = +$1_1;
  $2_1 = $2_1 | 0;
  return +($2_1 ? $0_1 : $1_1);
 }
 
 function $4($0_1) {
  $0_1 = $0_1 | 0;
  abort();
 }
 
 function $5($0_1) {
  $0_1 = $0_1 | 0;
  abort();
 }
 
 function legalstub$1($0_1, $1_1, $2_1, $3_1, $4_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  $4_1 = $4_1 | 0;
  var $5_1 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0;
  $7 = 0;
  $8 = $0_1;
  $9 = $7;
  $7 = 0;
  $6 = 32;
  $5_1 = $6 & 31 | 0;
  if (32 >>> 0 <= ($6 & 63 | 0) >>> 0) {
   {
    $0_1 = $1_1 << $5_1 | 0;
    $6 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $5_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $5_1 | 0) | 0) | 0 | ($7 << $5_1 | 0) | 0;
    $6 = $1_1 << $5_1 | 0;
   }
  }
  $1_1 = $0_1;
  $0_1 = $9;
  $7 = $8;
  $1_1 = $0_1 | $1_1 | 0;
  $10 = $7 | $6 | 0;
  $8 = $1_1;
  $1_1 = 0;
  $9 = $1_1;
  $1_1 = 0;
  $0_1 = $3_1;
  $6 = 32;
  $5_1 = $6 & 31 | 0;
  if (32 >>> 0 <= ($6 & 63 | 0) >>> 0) {
   {
    $7 = $0_1 << $5_1 | 0;
    $6 = 0;
   }
  } else {
   {
    $7 = ((1 << $5_1 | 0) - 1 | 0) & ($0_1 >>> (32 - $5_1 | 0) | 0) | 0 | ($1_1 << $5_1 | 0) | 0;
    $6 = $0_1 << $5_1 | 0;
   }
  }
  $0_1 = $7;
  $7 = $9;
  $1_1 = $2_1;
  $0_1 = $7 | $0_1 | 0;
  $2_1 = $1_1 | $6 | 0;
  $1_1 = $0_1;
  $0_1 = $8;
  $1_1 = $1($10 | 0, $0_1 | 0, $2_1 | 0, $1_1 | 0, $4_1 | 0) | 0;
  $0_1 = i64toi32_i32$HIGH_BITS;
  $3_1 = $1_1;
  $2_1 = $0_1;
  $7 = $1_1;
  $6 = 32;
  $5_1 = $6 & 31 | 0;
  if (32 >>> 0 <= ($6 & 63 | 0) >>> 0) {
   $0_1 = $0_1 >>> $5_1 | 0
  } else {
   $0_1 = (((1 << $5_1 | 0) - 1 | 0) & $0_1 | 0) << (32 - $5_1 | 0) | 0 | ($7 >>> $5_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $3_1 | 0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "select_i32": $0, 
  "select_i64": legalstub$1, 
  "select_f32": $2, 
  "select_f64": $3, 
  "select_trap_l": $4, 
  "select_trap_r": $5
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0},memasmFunc);
export var select_i32 = retasmFunc.select_i32;
export var select_i64 = retasmFunc.select_i64;
export var select_f32 = retasmFunc.select_f32;
export var select_f64 = retasmFunc.select_f64;
export var select_trap_l = retasmFunc.select_trap_l;
export var select_trap_r = retasmFunc.select_trap_r;
