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
 function $0($0_1, $1, $2_1) {
  $0_1 = $0_1 | 0;
  $1 = $1 | 0;
  $2_1 = $2_1 | 0;
  return ($2_1 ? $0_1 : $1) | 0;
 }
 
 function $2($0_1, $1, $2_1) {
  $0_1 = Math_fround($0_1);
  $1 = Math_fround($1);
  $2_1 = $2_1 | 0;
  return Math_fround($2_1 ? $0_1 : $1);
 }
 
 function $3($0_1, $1, $2_1) {
  $0_1 = +$0_1;
  $1 = +$1;
  $2_1 = $2_1 | 0;
  return +($2_1 ? $0_1 : $1);
 }
 
 function $4($0_1) {
  $0_1 = $0_1 | 0;
  abort();
 }
 
 function legalstub$1($0_1, $1, $2_1, $3_1, $4_1) {
  var $5 = 0;
  $5 = $2_1;
  $2_1 = $3_1;
  $3_1 = $5 | 0;
  i64toi32_i32$HIGH_BITS = $4_1 ? $1 : $2_1;
  $0_1 = $4_1 ? $0_1 : $3_1;
  setTempRet0(i64toi32_i32$HIGH_BITS | 0);
  return $0_1;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "select_i32": $0, 
  "select_i64": legalstub$1, 
  "select_f32": $2, 
  "select_f64": $3, 
  "select_trap_l": $4, 
  "select_trap_r": $4
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
