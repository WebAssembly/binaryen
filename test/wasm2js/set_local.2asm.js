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
  
 }
 
 function $4($0_1) {
  $0_1 = $0_1 | 0;
 }
 
 function $6($0_1) {
  $0_1 = Math_fround($0_1);
 }
 
 function $7($0_1) {
  $0_1 = +$0_1;
 }
 
 function $9($0_1, $1, $2) {
  $0_1 = $0_1 | 0;
  $1 = $1 | 0;
  $2 = +$2;
  var $3 = 0, $4_1 = 0;
  $2 = +($0_1 >>> 0) + 4294967296.0 * +($1 >>> 0) + (-.30000001192092896 + ($2 + 52.5));
  $0_1 = ~~$2 >>> 0;
  if (Math_abs($2) >= 1.0) {
   {
    if ($2 > 0.0) {
     $3 = ~~Math_min(Math_floor($2 / 4294967296.0), 4294967295.0) >>> 0
    } else {
     $3 = ~~Math_ceil(($2 - +(~~$2 >>> 0 >>> 0)) / 4294967296.0) >>> 0
    }
    $4_1 = $3;
   }
  } else {
   $4_1 = 0
  }
  i64toi32_i32$HIGH_BITS = $4_1;
  return $0_1 | 0;
 }
 
 function legalstub$5($0_1, $1) {
  
 }
 
 function legalstub$8($0_1, $1, $2, $3, $4_1, $5) {
  
 }
 
 function legalstub$9($0_1, $1, $2, $3, $4_1, $5) {
  var $6_1 = 0, $7_1 = 0, $8 = 0, $9_1 = 0, $10 = 0;
  $9_1 = $0_1;
  $7_1 = 32;
  $0_1 = $7_1 & 31;
  if (32 >>> 0 <= $7_1 >>> 0) {
   {
    $6_1 = $1 << $0_1;
    $8 = 0;
   }
  } else {
   {
    $6_1 = (1 << $0_1) - 1 & $1 >>> 32 - $0_1 | $6_1 << $0_1;
    $8 = $1 << $0_1;
   }
  }
  $1 = $9($9_1 | $8, $6_1 | $10, $3);
  $4_1 = i64toi32_i32$HIGH_BITS;
  $6_1 = 32;
  $0_1 = $6_1 & 31;
  setTempRet0((32 >>> 0 <= $6_1 >>> 0 ? $4_1 >>> $0_1 : ((1 << $0_1) - 1 & $4_1) << 32 - $0_1 | $1 >>> $0_1) | 0);
  return $1;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "type_local_i32": $0, 
  "type_local_i64": $0, 
  "type_local_f32": $0, 
  "type_local_f64": $0, 
  "type_param_i32": $4, 
  "type_param_i64": legalstub$5, 
  "type_param_f32": $6, 
  "type_param_f64": $7, 
  "type_mixed": legalstub$8, 
  "write": legalstub$9
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
