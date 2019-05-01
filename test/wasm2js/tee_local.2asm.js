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
  return 0 | 0;
 }
 
 function $1() {
  var $0_1 = 0;
  $0_1 = 0;
  i64toi32_i32$HIGH_BITS = $0_1;
  return 0 | 0;
 }
 
 function $2() {
  return Math_fround(Math_fround(0.0));
 }
 
 function $3() {
  return +(0.0);
 }
 
 function $4($0_1) {
  $0_1 = $0_1 | 0;
  return 10 | 0;
 }
 
 function $5($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $0_1 = 0;
  i64toi32_i32$HIGH_BITS = $0_1;
  return 11 | 0;
 }
 
 function $6($0_1) {
  $0_1 = Math_fround($0_1);
  return Math_fround(Math_fround(11.100000381469727));
 }
 
 function $7($0_1) {
  $0_1 = +$0_1;
  return +(12.2);
 }
 
 function $8($0_1, $1_1, $2_1, $3_1, $4_1, $5_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = Math_fround($2_1);
  $3_1 = +$3_1;
  $4_1 = $4_1 | 0;
  $5_1 = $5_1 | 0;
  $0_1 = 0;
  $0_1 = 0;
  $0_1 = 0;
 }
 
 function $9($0_1, $1_1, $2_1, $3_1, $4_1, $5_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = Math_fround($2_1);
  $3_1 = +$3_1;
  $4_1 = $4_1 | 0;
  $5_1 = $5_1 | 0;
  var $6_1 = 0, $7_1 = Math_fround(0), $8_1 = 0, $9_1 = 0.0, $10_1 = 0, $11 = 0.0, $12 = 0.0, $13 = 0, $14 = 0;
  $2_1 = Math_fround(-.30000001192092896);
  $4_1 = 40;
  $5_1 = -7;
  $7_1 = Math_fround(5.5);
  $6_1 = 0;
  $8_1 = 6;
  $10_1 = $6_1;
  $9_1 = 8.0;
  $6_1 = $1_1;
  $11 = +($0_1 >>> 0) + 4294967296.0 * +($6_1 >>> 0);
  $6_1 = $10_1;
  $0_1 = $8_1;
  $12 = +($0_1 >>> 0) + 4294967296.0 * +($6_1 >>> 0);
  $6_1 = $13;
  $0_1 = $14;
  $3_1 = $11 + (+$2_1 + ($3_1 + (+($4_1 >>> 0) + (+($5_1 | 0) + (+$7_1 + ($12 + (+($0_1 >>> 0) + 4294967296.0 * +($6_1 >>> 0) + $9_1)))))));
  if (Math_abs($3_1) >= 1.0) {
   if ($3_1 > 0.0) {
    $6_1 = ~~Math_min(Math_floor($3_1 / 4294967296.0), 4294967296.0 - 1.0) >>> 0
   } else {
    $6_1 = ~~Math_ceil(($3_1 - +(~~$3_1 >>> 0 >>> 0)) / 4294967296.0) >>> 0
   }
  } else {
   $6_1 = 0
  }
  $0_1 = ~~$3_1 >>> 0;
  i64toi32_i32$HIGH_BITS = $6_1;
  return $0_1 | 0;
 }
 
 function $10($0_1, $1_1, $2_1, $3_1, $4_1, $5_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = Math_fround($2_1);
  $3_1 = +$3_1;
  $4_1 = $4_1 | 0;
  $5_1 = $5_1 | 0;
  var $6_1 = 0.0;
  $0_1 = 0;
  $1_1 = 1;
  $3_1 = +($1_1 >>> 0) + 4294967296.0 * +($0_1 >>> 0);
  $0_1 = 0;
  $1_1 = 6;
  $6_1 = +($1_1 >>> 0) + 4294967296.0 * +($0_1 >>> 0);
  $0_1 = 0;
  $1_1 = 0;
  return +($3_1 + (+Math_fround(2.0) + (3.3 + (+(4 >>> 0) + (+(5 | 0) + (+Math_fround(5.5) + ($6_1 + (+($1_1 >>> 0) + 4294967296.0 * +($0_1 >>> 0) + 8.0))))))));
 }
 
 function legalstub$1() {
  var $0_1 = 0, $1_1 = 0, $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0;
  $0_1 = $1() | 0;
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
 
 function legalstub$5($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0, $6_1 = 0;
  $3_1 = 0;
  $5_1 = $0_1;
  $6_1 = $3_1;
  $3_1 = 0;
  $4_1 = 32;
  $2_1 = $4_1 & 31 | 0;
  if (32 >>> 0 <= ($4_1 & 63 | 0) >>> 0) {
   {
    $0_1 = $1_1 << $2_1 | 0;
    $4_1 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $2_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $2_1 | 0) | 0) | 0 | ($3_1 << $2_1 | 0) | 0;
    $4_1 = $1_1 << $2_1 | 0;
   }
  }
  $1_1 = $0_1;
  $0_1 = $6_1;
  $3_1 = $5_1;
  $1_1 = $0_1 | $1_1 | 0;
  $1_1 = $5($3_1 | $4_1 | 0 | 0, $1_1 | 0) | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  $6_1 = $1_1;
  $5_1 = $3_1;
  $0_1 = $1_1;
  $4_1 = 32;
  $2_1 = $4_1 & 31 | 0;
  if (32 >>> 0 <= ($4_1 & 63 | 0) >>> 0) {
   $0_1 = $3_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $3_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $6_1 | 0;
 }
 
 function legalstub$8($0_1, $1_1, $2_1, $3_1, $4_1, $5_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = Math_fround($2_1);
  $3_1 = +$3_1;
  $4_1 = $4_1 | 0;
  $5_1 = $5_1 | 0;
  var $6_1 = 0, $7_1 = 0, $8_1 = 0, $9_1 = 0, $10_1 = 0;
  $6_1 = 0;
  $10_1 = $6_1;
  $6_1 = 0;
  $7_1 = 32;
  $8_1 = $7_1 & 31 | 0;
  if (32 >>> 0 <= ($7_1 & 63 | 0) >>> 0) {
   {
    $9_1 = $1_1 << $8_1 | 0;
    $7_1 = 0;
   }
  } else {
   {
    $9_1 = ((1 << $8_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $8_1 | 0) | 0) | 0 | ($6_1 << $8_1 | 0) | 0;
    $7_1 = $1_1 << $8_1 | 0;
   }
  }
  $1_1 = $9_1;
  $9_1 = $10_1;
  $6_1 = $0_1;
  $1_1 = $9_1 | $1_1 | 0;
  $8($6_1 | $7_1 | 0 | 0, $1_1 | 0, Math_fround($2_1), +$3_1, $4_1 | 0, $5_1 | 0);
 }
 
 function legalstub$9($0_1, $1_1, $2_1, $3_1, $4_1, $5_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = Math_fround($2_1);
  $3_1 = +$3_1;
  $4_1 = $4_1 | 0;
  $5_1 = $5_1 | 0;
  var $6_1 = 0, $7_1 = 0, $8_1 = 0, $9_1 = 0, $10_1 = 0;
  $7_1 = 0;
  $9_1 = $0_1;
  $10_1 = $7_1;
  $7_1 = 0;
  $8_1 = 32;
  $6_1 = $8_1 & 31 | 0;
  if (32 >>> 0 <= ($8_1 & 63 | 0) >>> 0) {
   {
    $0_1 = $1_1 << $6_1 | 0;
    $8_1 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $6_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $6_1 | 0) | 0) | 0 | ($7_1 << $6_1 | 0) | 0;
    $8_1 = $1_1 << $6_1 | 0;
   }
  }
  $1_1 = $0_1;
  $0_1 = $10_1;
  $7_1 = $9_1;
  $1_1 = $0_1 | $1_1 | 0;
  $1_1 = $9($7_1 | $8_1 | 0 | 0, $1_1 | 0, Math_fround($2_1), +$3_1, $4_1 | 0, $5_1 | 0) | 0;
  $7_1 = i64toi32_i32$HIGH_BITS;
  $5_1 = $1_1;
  $4_1 = $7_1;
  $0_1 = $1_1;
  $8_1 = 32;
  $6_1 = $8_1 & 31 | 0;
  if (32 >>> 0 <= ($8_1 & 63 | 0) >>> 0) {
   $0_1 = $7_1 >>> $6_1 | 0
  } else {
   $0_1 = (((1 << $6_1 | 0) - 1 | 0) & $7_1 | 0) << (32 - $6_1 | 0) | 0 | ($0_1 >>> $6_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $5_1 | 0;
 }
 
 function legalstub$10($0_1, $1_1, $2_1, $3_1, $4_1, $5_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = Math_fround($2_1);
  $3_1 = +$3_1;
  $4_1 = $4_1 | 0;
  $5_1 = $5_1 | 0;
  var $6_1 = 0, $7_1 = 0, $8_1 = 0, $9_1 = 0, $10_1 = 0;
  $6_1 = 0;
  $10_1 = $6_1;
  $6_1 = 0;
  $7_1 = 32;
  $8_1 = $7_1 & 31 | 0;
  if (32 >>> 0 <= ($7_1 & 63 | 0) >>> 0) {
   {
    $9_1 = $1_1 << $8_1 | 0;
    $7_1 = 0;
   }
  } else {
   {
    $9_1 = ((1 << $8_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $8_1 | 0) | 0) | 0 | ($6_1 << $8_1 | 0) | 0;
    $7_1 = $1_1 << $8_1 | 0;
   }
  }
  $1_1 = $9_1;
  $9_1 = $10_1;
  $6_1 = $0_1;
  $1_1 = $9_1 | $1_1 | 0;
  return +(+$10($6_1 | $7_1 | 0 | 0, $1_1 | 0, Math_fround($2_1), +$3_1, $4_1 | 0, $5_1 | 0));
 }
 
 var FUNCTION_TABLE = [];
 return {
  "type_local_i32": $0, 
  "type_local_i64": legalstub$1, 
  "type_local_f32": $2, 
  "type_local_f64": $3, 
  "type_param_i32": $4, 
  "type_param_i64": legalstub$5, 
  "type_param_f32": $6, 
  "type_param_f64": $7, 
  "type_mixed": legalstub$8, 
  "write": legalstub$9, 
  "result": legalstub$10
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0},memasmFunc);
export var type_local_i32 = retasmFunc.type_local_i32;
export var type_local_i64 = retasmFunc.type_local_i64;
export var type_local_f32 = retasmFunc.type_local_f32;
export var type_local_f64 = retasmFunc.type_local_f64;
export var type_param_i32 = retasmFunc.type_param_i32;
export var type_param_i64 = retasmFunc.type_param_i64;
export var type_param_f32 = retasmFunc.type_param_f32;
export var type_param_f64 = retasmFunc.type_param_f64;
export var type_mixed = retasmFunc.type_mixed;
export var write = retasmFunc.write;
export var result = retasmFunc.result;
