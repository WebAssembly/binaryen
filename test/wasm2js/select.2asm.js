import { setTempRet0 } from 'env';

function asmFunc(global, env, buffer) {
 "almost asm";
 var HEAP8 = new global.Int8Array(buffer);
 var HEAP16 = new global.Int16Array(buffer);
 var HEAP32 = new global.Int32Array(buffer);
 var HEAPU8 = new global.Uint8Array(buffer);
 var HEAPU16 = new global.Uint16Array(buffer);
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
 function $0(lhs, rhs, cond) {
  lhs = lhs | 0;
  rhs = rhs | 0;
  cond = cond | 0;
  return (cond ? lhs : rhs) | 0;
 }
 
 function $1(lhs, lhs$hi, rhs, rhs$hi, cond) {
  lhs = lhs | 0;
  lhs$hi = lhs$hi | 0;
  rhs = rhs | 0;
  rhs$hi = rhs$hi | 0;
  cond = cond | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = lhs$hi;
  i64toi32_i32$0 = rhs$hi;
  i64toi32_i32$4 = cond;
  i64toi32_i32$0 = lhs$hi;
  i64toi32_i32$3 = i64toi32_i32$4 ? lhs : rhs;
  i64toi32_i32$2 = i64toi32_i32$4 ? i64toi32_i32$0 : rhs$hi;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$2;
  return i64toi32_i32$3 | 0;
 }
 
 function $2(lhs, rhs, cond) {
  lhs = Math_fround(lhs);
  rhs = Math_fround(rhs);
  cond = cond | 0;
  return Math_fround(cond ? lhs : rhs);
 }
 
 function $3(lhs, rhs, cond) {
  lhs = +lhs;
  rhs = +rhs;
  cond = cond | 0;
  return +(cond ? lhs : rhs);
 }
 
 function $4(cond) {
  cond = cond | 0;
  var $1_1 = 0;
  abort();
 }
 
 function $5(cond) {
  cond = cond | 0;
  var $1_1 = 0;
  abort();
 }
 
 function legalstub$1($0_1, $1_1, $2_1, $3_1, $4_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  $4_1 = $4_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$3 = 0, $22 = 0, $23 = 0, $24 = 0, $7 = 0, $7$hi = 0, $10$hi = 0, $11 = 0, $11$hi = 0, $13 = 0, $13$hi = 0, $16$hi = 0, $17 = 0, $17$hi = 0, $5_1 = 0, $5$hi = 0;
  i64toi32_i32$0 = 0;
  $7 = $0_1;
  $7$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $22 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $22 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $10$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $7$hi;
  i64toi32_i32$0 = $7;
  i64toi32_i32$2 = $10$hi;
  i64toi32_i32$3 = $22;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  $11 = i64toi32_i32$0 | i64toi32_i32$3 | 0;
  $11$hi = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  $13 = $2_1;
  $13$hi = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$1 = $3_1;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = i64toi32_i32$1 << i64toi32_i32$4 | 0;
   $23 = 0;
  } else {
   i64toi32_i32$0 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$1 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$2 << i64toi32_i32$4 | 0) | 0;
   $23 = i64toi32_i32$1 << i64toi32_i32$4 | 0;
  }
  $16$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $13$hi;
  i64toi32_i32$2 = $13;
  i64toi32_i32$1 = $16$hi;
  i64toi32_i32$3 = $23;
  i64toi32_i32$1 = i64toi32_i32$0 | i64toi32_i32$1 | 0;
  $17 = i64toi32_i32$2 | i64toi32_i32$3 | 0;
  $17$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $11$hi;
  i64toi32_i32$2 = $17$hi;
  i64toi32_i32$2 = $1($11 | 0, i64toi32_i32$1 | 0, $17 | 0, i64toi32_i32$2 | 0, $4_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $5_1 = i64toi32_i32$2;
  $5$hi = i64toi32_i32$1;
  i64toi32_i32$0 = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $24 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $24 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$0 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($24 | 0);
  i64toi32_i32$2 = $5$hi;
  return $5_1 | 0;
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
