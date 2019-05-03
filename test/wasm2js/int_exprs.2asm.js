
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
 function $0(x, y) {
  x = x | 0;
  y = y | 0;
  return (x + 1 | 0 | 0) < (y + 1 | 0 | 0) | 0;
 }
 
 function $1(x, y) {
  x = x | 0;
  y = y | 0;
  return (x + 1 | 0) >>> 0 < (y + 1 | 0) >>> 0 | 0;
 }
 
 function $2(x, x$hi, y, y$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  y = y | 0;
  y$hi = y$hi | 0;
  var i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, i64toi32_i32$5 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$2 = 0, $13 = 0, $14 = 0, $15 = 0, $3_1 = 0, $3$hi = 0, $5$hi = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$2 = x;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 1;
  i64toi32_i32$4 = i64toi32_i32$2 + i64toi32_i32$3 | 0;
  i64toi32_i32$5 = i64toi32_i32$0 + i64toi32_i32$1 | 0;
  if (i64toi32_i32$4 >>> 0 < i64toi32_i32$3 >>> 0) {
   i64toi32_i32$5 = i64toi32_i32$5 + 1 | 0
  }
  $3_1 = i64toi32_i32$4;
  $3$hi = i64toi32_i32$5;
  i64toi32_i32$5 = y$hi;
  i64toi32_i32$0 = y;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 1;
  i64toi32_i32$1 = i64toi32_i32$0 + i64toi32_i32$3 | 0;
  i64toi32_i32$4 = i64toi32_i32$5 + i64toi32_i32$2 | 0;
  if (i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0) {
   i64toi32_i32$4 = i64toi32_i32$4 + 1 | 0
  }
  $5$hi = i64toi32_i32$4;
  i64toi32_i32$4 = $3$hi;
  i64toi32_i32$5 = $3_1;
  i64toi32_i32$0 = $5$hi;
  i64toi32_i32$3 = i64toi32_i32$1;
  if ((i64toi32_i32$4 | 0) < (i64toi32_i32$0 | 0)) {
   $13 = 1
  } else {
   if ((i64toi32_i32$4 | 0) <= (i64toi32_i32$0 | 0)) {
    if (i64toi32_i32$5 >>> 0 >= i64toi32_i32$3 >>> 0) {
     $14 = 0
    } else {
     $14 = 1
    }
    $15 = $14;
   } else {
    $15 = 0
   }
   $13 = $15;
  }
  return $13 | 0;
 }
 
 function $3(x, x$hi, y, y$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  y = y | 0;
  y$hi = y$hi | 0;
  var i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, i64toi32_i32$5 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$2 = 0, $3_1 = 0, $3$hi = 0, $5$hi = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$2 = x;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 1;
  i64toi32_i32$4 = i64toi32_i32$2 + i64toi32_i32$3 | 0;
  i64toi32_i32$5 = i64toi32_i32$0 + i64toi32_i32$1 | 0;
  if (i64toi32_i32$4 >>> 0 < i64toi32_i32$3 >>> 0) {
   i64toi32_i32$5 = i64toi32_i32$5 + 1 | 0
  }
  $3_1 = i64toi32_i32$4;
  $3$hi = i64toi32_i32$5;
  i64toi32_i32$5 = y$hi;
  i64toi32_i32$0 = y;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 1;
  i64toi32_i32$1 = i64toi32_i32$0 + i64toi32_i32$3 | 0;
  i64toi32_i32$4 = i64toi32_i32$5 + i64toi32_i32$2 | 0;
  if (i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0) {
   i64toi32_i32$4 = i64toi32_i32$4 + 1 | 0
  }
  $5$hi = i64toi32_i32$4;
  i64toi32_i32$4 = $3$hi;
  i64toi32_i32$5 = $3_1;
  i64toi32_i32$0 = $5$hi;
  i64toi32_i32$3 = i64toi32_i32$1;
  return i64toi32_i32$4 >>> 0 < i64toi32_i32$0 >>> 0 | ((i64toi32_i32$4 | 0) == (i64toi32_i32$0 | 0) & i64toi32_i32$5 >>> 0 < i64toi32_i32$3 >>> 0 | 0) | 0 | 0;
 }
 
 function legalstub$2($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $19 = 0, $20 = 0, $5 = 0, $5$hi = 0, $8$hi = 0, $9 = 0, $9$hi = 0, $11 = 0, $11$hi = 0, $14$hi = 0, $15 = 0, $15$hi = 0;
  i64toi32_i32$0 = 0;
  $5 = $0_1;
  $5$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $19 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $19 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $8$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $5$hi;
  i64toi32_i32$0 = $5;
  i64toi32_i32$2 = $8$hi;
  i64toi32_i32$3 = $19;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  $9 = i64toi32_i32$0 | i64toi32_i32$3 | 0;
  $9$hi = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  $11 = $2_1;
  $11$hi = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$1 = $3_1;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = i64toi32_i32$1 << i64toi32_i32$4 | 0;
   $20 = 0;
  } else {
   i64toi32_i32$0 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$1 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$2 << i64toi32_i32$4 | 0) | 0;
   $20 = i64toi32_i32$1 << i64toi32_i32$4 | 0;
  }
  $14$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $11$hi;
  i64toi32_i32$2 = $11;
  i64toi32_i32$1 = $14$hi;
  i64toi32_i32$3 = $20;
  i64toi32_i32$1 = i64toi32_i32$0 | i64toi32_i32$1 | 0;
  $15 = i64toi32_i32$2 | i64toi32_i32$3 | 0;
  $15$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $9$hi;
  i64toi32_i32$2 = $15$hi;
  return $2($9 | 0, i64toi32_i32$1 | 0, $15 | 0, i64toi32_i32$2 | 0) | 0 | 0;
 }
 
 function legalstub$3($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $19 = 0, $20 = 0, $5 = 0, $5$hi = 0, $8$hi = 0, $9 = 0, $9$hi = 0, $11 = 0, $11$hi = 0, $14$hi = 0, $15 = 0, $15$hi = 0;
  i64toi32_i32$0 = 0;
  $5 = $0_1;
  $5$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $19 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $19 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $8$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $5$hi;
  i64toi32_i32$0 = $5;
  i64toi32_i32$2 = $8$hi;
  i64toi32_i32$3 = $19;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  $9 = i64toi32_i32$0 | i64toi32_i32$3 | 0;
  $9$hi = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  $11 = $2_1;
  $11$hi = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$1 = $3_1;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = i64toi32_i32$1 << i64toi32_i32$4 | 0;
   $20 = 0;
  } else {
   i64toi32_i32$0 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$1 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$2 << i64toi32_i32$4 | 0) | 0;
   $20 = i64toi32_i32$1 << i64toi32_i32$4 | 0;
  }
  $14$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $11$hi;
  i64toi32_i32$2 = $11;
  i64toi32_i32$1 = $14$hi;
  i64toi32_i32$3 = $20;
  i64toi32_i32$1 = i64toi32_i32$0 | i64toi32_i32$1 | 0;
  $15 = i64toi32_i32$2 | i64toi32_i32$3 | 0;
  $15$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $9$hi;
  i64toi32_i32$2 = $15$hi;
  return $3($9 | 0, i64toi32_i32$1 | 0, $15 | 0, i64toi32_i32$2 | 0) | 0 | 0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "i32_no_fold_cmp_s_offset": $0, 
  "i32_no_fold_cmp_u_offset": $1, 
  "i64_no_fold_cmp_s_offset": legalstub$2, 
  "i64_no_fold_cmp_u_offset": legalstub$3
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export var i32_no_fold_cmp_s_offset = retasmFunc.i32_no_fold_cmp_s_offset;
export var i32_no_fold_cmp_u_offset = retasmFunc.i32_no_fold_cmp_u_offset;
export var i64_no_fold_cmp_s_offset = retasmFunc.i64_no_fold_cmp_s_offset;
export var i64_no_fold_cmp_u_offset = retasmFunc.i64_no_fold_cmp_u_offset;
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
 function $0(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$1 = x;
  i64toi32_i32$0 = i64toi32_i32$1 >> 31 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function legalstub$0($0_1, $1) {
  $0_1 = $0_1 | 0;
  $1 = $1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $12 = 0, $13 = 0, $4 = 0, $4$hi = 0, $7$hi = 0, $2 = 0, $2$hi = 0;
  i64toi32_i32$0 = 0;
  $4 = $0_1;
  $4$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $12 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $12 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $7$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $4$hi;
  i64toi32_i32$0 = $4;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$3 = $12;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$2 = $0(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $2 = i64toi32_i32$2;
  $2$hi = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $13 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $13 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$1 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($13 | 0);
  i64toi32_i32$2 = $2$hi;
  return $2 | 0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "i64_no_fold_wrap_extend_s": legalstub$0
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0},memasmFunc);
export var i64_no_fold_wrap_extend_s = retasmFunc.i64_no_fold_wrap_extend_s;
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
 function $0(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return x | 0;
 }
 
 function legalstub$0($0_1, $1) {
  $0_1 = $0_1 | 0;
  $1 = $1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $12 = 0, $13 = 0, $4 = 0, $4$hi = 0, $7$hi = 0, $2 = 0, $2$hi = 0;
  i64toi32_i32$0 = 0;
  $4 = $0_1;
  $4$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $12 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $12 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $7$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $4$hi;
  i64toi32_i32$0 = $4;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$3 = $12;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$2 = $0(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $2 = i64toi32_i32$2;
  $2$hi = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $13 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $13 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$1 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($13 | 0);
  i64toi32_i32$2 = $2$hi;
  return $2 | 0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "i64_no_fold_wrap_extend_u": legalstub$0
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0},memasmFunc);
export var i64_no_fold_wrap_extend_u = retasmFunc.i64_no_fold_wrap_extend_u;
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
 function $0(x) {
  x = x | 0;
  return (x << 1 | 0) >> 1 | 0 | 0;
 }
 
 function $1(x) {
  x = x | 0;
  return (x << 1 | 0) >>> 1 | 0 | 0;
 }
 
 function $2(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$4 = 0, i64toi32_i32$2 = 0, i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$3 = 0, $7 = 0, $8 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$2 = x;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 1;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $7 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $7 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  i64toi32_i32$0 = $7;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 1;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = i64toi32_i32$1 >> 31 | 0;
   $8 = i64toi32_i32$1 >> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$1 >> i64toi32_i32$4 | 0;
   $8 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$0 >>> i64toi32_i32$4 | 0) | 0;
  }
  i64toi32_i32$0 = $8;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$2;
  return i64toi32_i32$0 | 0;
 }
 
 function $3(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$4 = 0, i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $7 = 0, $8 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$2 = x;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 1;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $7 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $7 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  i64toi32_i32$0 = $7;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 1;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $8 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$0 >>> i64toi32_i32$4 | 0) | 0;
  }
  i64toi32_i32$0 = $8;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$2;
  return i64toi32_i32$0 | 0;
 }
 
 function legalstub$2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $12 = 0, $13 = 0, $4 = 0, $4$hi = 0, $7$hi = 0, $2_1 = 0, $2$hi = 0;
  i64toi32_i32$0 = 0;
  $4 = $0_1;
  $4$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $12 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $12 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $7$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $4$hi;
  i64toi32_i32$0 = $4;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$3 = $12;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$2 = $2(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $2_1 = i64toi32_i32$2;
  $2$hi = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $13 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $13 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$1 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($13 | 0);
  i64toi32_i32$2 = $2$hi;
  return $2_1 | 0;
 }
 
 function legalstub$3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $12 = 0, $13 = 0, $4 = 0, $4$hi = 0, $7$hi = 0, $2_1 = 0, $2$hi = 0;
  i64toi32_i32$0 = 0;
  $4 = $0_1;
  $4$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $12 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $12 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $7$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $4$hi;
  i64toi32_i32$0 = $4;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$3 = $12;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$2 = $3(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $2_1 = i64toi32_i32$2;
  $2$hi = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $13 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $13 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$1 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($13 | 0);
  i64toi32_i32$2 = $2$hi;
  return $2_1 | 0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "i32_no_fold_shl_shr_s": $0, 
  "i32_no_fold_shl_shr_u": $1, 
  "i64_no_fold_shl_shr_s": legalstub$2, 
  "i64_no_fold_shl_shr_u": legalstub$3
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0},memasmFunc);
export var i32_no_fold_shl_shr_s = retasmFunc.i32_no_fold_shl_shr_s;
export var i32_no_fold_shl_shr_u = retasmFunc.i32_no_fold_shl_shr_u;
export var i64_no_fold_shl_shr_s = retasmFunc.i64_no_fold_shl_shr_s;
export var i64_no_fold_shl_shr_u = retasmFunc.i64_no_fold_shl_shr_u;
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
 function $0(x) {
  x = x | 0;
  return (x >> 1 | 0) << 1 | 0 | 0;
 }
 
 function $1(x) {
  x = x | 0;
  return (x >>> 1 | 0) << 1 | 0 | 0;
 }
 
 function $2(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, i64toi32_i32$1 = 0, $7 = 0, $8 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$2 = x;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 1;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
   $7 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
   $7 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  i64toi32_i32$0 = $7;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 1;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = i64toi32_i32$0 << i64toi32_i32$4 | 0;
   $8 = 0;
  } else {
   i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$0 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
   $8 = i64toi32_i32$0 << i64toi32_i32$4 | 0;
  }
  i64toi32_i32$0 = $8;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$2;
  return i64toi32_i32$0 | 0;
 }
 
 function $3(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, i64toi32_i32$1 = 0, $7 = 0, $8 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$2 = x;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 1;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = 0;
   $7 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $7 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  i64toi32_i32$0 = $7;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 1;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = i64toi32_i32$0 << i64toi32_i32$4 | 0;
   $8 = 0;
  } else {
   i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$0 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
   $8 = i64toi32_i32$0 << i64toi32_i32$4 | 0;
  }
  i64toi32_i32$0 = $8;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$2;
  return i64toi32_i32$0 | 0;
 }
 
 function legalstub$2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $12 = 0, $13 = 0, $4 = 0, $4$hi = 0, $7$hi = 0, $2_1 = 0, $2$hi = 0;
  i64toi32_i32$0 = 0;
  $4 = $0_1;
  $4$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $12 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $12 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $7$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $4$hi;
  i64toi32_i32$0 = $4;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$3 = $12;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$2 = $2(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $2_1 = i64toi32_i32$2;
  $2$hi = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $13 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $13 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$1 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($13 | 0);
  i64toi32_i32$2 = $2$hi;
  return $2_1 | 0;
 }
 
 function legalstub$3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $12 = 0, $13 = 0, $4 = 0, $4$hi = 0, $7$hi = 0, $2_1 = 0, $2$hi = 0;
  i64toi32_i32$0 = 0;
  $4 = $0_1;
  $4$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $12 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $12 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $7$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $4$hi;
  i64toi32_i32$0 = $4;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$3 = $12;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$2 = $3(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $2_1 = i64toi32_i32$2;
  $2$hi = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $13 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $13 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$1 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($13 | 0);
  i64toi32_i32$2 = $2$hi;
  return $2_1 | 0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "i32_no_fold_shr_s_shl": $0, 
  "i32_no_fold_shr_u_shl": $1, 
  "i64_no_fold_shr_s_shl": legalstub$2, 
  "i64_no_fold_shr_u_shl": legalstub$3
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0},memasmFunc);
export var i32_no_fold_shr_s_shl = retasmFunc.i32_no_fold_shr_s_shl;
export var i32_no_fold_shr_u_shl = retasmFunc.i32_no_fold_shr_u_shl;
export var i64_no_fold_shr_s_shl = retasmFunc.i64_no_fold_shr_s_shl;
export var i64_no_fold_shr_u_shl = retasmFunc.i64_no_fold_shr_u_shl;
import { setTempRet0 } from 'env';


  var scratchBuffer = new ArrayBuffer(8);
  var i32ScratchView = new Int32Array(scratchBuffer);
  var f32ScratchView = new Float32Array(scratchBuffer);
  var f64ScratchView = new Float64Array(scratchBuffer);
  
  function legalimport$wasm2js_scratch_store_i64(low, high) {
    i32ScratchView[0] = low;
    i32ScratchView[1] = high;
  }
      
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
 function $0(x) {
  x = x | 0;
  return Math_imul((x | 0) / (6 | 0) | 0, 6) | 0;
 }
 
 function $1(x) {
  x = x | 0;
  return Math_imul((x >>> 0) / (6 >>> 0) | 0, 6) | 0;
 }
 
 function $2(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, $4 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$1 = 0;
  i64toi32_i32$1 = __wasm_i64_sdiv(x | 0, i64toi32_i32$0 | 0, 6 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $4 = i64toi32_i32$1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$1 = __wasm_i64_mul($4 | 0, i64toi32_i32$0 | 0, 6 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $3(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, $4 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$1 = 0;
  i64toi32_i32$1 = __wasm_i64_udiv(x | 0, i64toi32_i32$0 | 0, 6 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $4 = i64toi32_i32$1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$1 = __wasm_i64_mul($4 | 0, i64toi32_i32$0 | 0, 6 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function legalstub$2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $12 = 0, $13 = 0, $4 = 0, $4$hi = 0, $7$hi = 0, $2_1 = 0, $2$hi = 0;
  i64toi32_i32$0 = 0;
  $4 = $0_1;
  $4$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $12 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $12 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $7$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $4$hi;
  i64toi32_i32$0 = $4;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$3 = $12;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$2 = $2(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $2_1 = i64toi32_i32$2;
  $2$hi = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $13 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $13 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$1 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($13 | 0);
  i64toi32_i32$2 = $2$hi;
  return $2_1 | 0;
 }
 
 function legalstub$3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $12 = 0, $13 = 0, $4 = 0, $4$hi = 0, $7$hi = 0, $2_1 = 0, $2$hi = 0;
  i64toi32_i32$0 = 0;
  $4 = $0_1;
  $4$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $12 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $12 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $7$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $4$hi;
  i64toi32_i32$0 = $4;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$3 = $12;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$2 = $3(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $2_1 = i64toi32_i32$2;
  $2$hi = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $13 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $13 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$1 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($13 | 0);
  i64toi32_i32$2 = $2$hi;
  return $2_1 | 0;
 }
 
 function legalfunc$wasm2js_scratch_store_i64($0_1, $0$hi) {
  $0_1 = $0_1 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8 = 0, $2_1 = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $0$hi;
  $2_1 = $0_1;
  i64toi32_i32$2 = $0_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = 0;
   $8 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $8 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  legalimport$wasm2js_scratch_store_i64($2_1 | 0, $8 | 0);
 }
 
 function _ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, var$2 = 0, i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, var$3 = 0, var$4 = 0, var$5 = 0, $21 = 0, $22 = 0, var$6 = 0, $24 = 0, $17 = 0, $18 = 0, $23 = 0, $29 = 0, $45 = 0, $56$hi = 0, $62$hi = 0;
  i64toi32_i32$0 = var$1$hi;
  var$2 = var$1;
  var$4 = var$2 >>> 16 | 0;
  i64toi32_i32$0 = var$0$hi;
  var$3 = var$0;
  var$5 = var$3 >>> 16 | 0;
  $17 = Math_imul(var$4, var$5);
  $18 = var$2;
  i64toi32_i32$2 = var$3;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = 0;
   $21 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $21 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  $23 = $17 + Math_imul($18, $21) | 0;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$0 = var$1;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $22 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $22 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$0 >>> i64toi32_i32$4 | 0) | 0;
  }
  $29 = $23 + Math_imul($22, var$3) | 0;
  var$2 = var$2 & 65535 | 0;
  var$3 = var$3 & 65535 | 0;
  var$6 = Math_imul(var$2, var$3);
  var$2 = (var$6 >>> 16 | 0) + Math_imul(var$2, var$5) | 0;
  $45 = $29 + (var$2 >>> 16 | 0) | 0;
  var$2 = (var$2 & 65535 | 0) + Math_imul(var$4, var$3) | 0;
  i64toi32_i32$2 = 0;
  i64toi32_i32$1 = $45 + (var$2 >>> 16 | 0) | 0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = i64toi32_i32$1 << i64toi32_i32$4 | 0;
   $24 = 0;
  } else {
   i64toi32_i32$0 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$1 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$2 << i64toi32_i32$4 | 0) | 0;
   $24 = i64toi32_i32$1 << i64toi32_i32$4 | 0;
  }
  $56$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  $62$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $56$hi;
  i64toi32_i32$2 = $24;
  i64toi32_i32$1 = $62$hi;
  i64toi32_i32$3 = var$2 << 16 | 0 | (var$6 & 65535 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$0 | i64toi32_i32$1 | 0;
  i64toi32_i32$2 = i64toi32_i32$2 | i64toi32_i32$3 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$2 | 0;
 }
 
 function _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$1 = 0, i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, i64toi32_i32$0 = 0, i64toi32_i32$5 = 0, var$2 = 0, var$2$hi = 0, i64toi32_i32$6 = 0, $21 = 0, $22 = 0, $23 = 0, $7$hi = 0, $9 = 0, $9$hi = 0, $14$hi = 0, $16$hi = 0, $17 = 0, $17$hi = 0, $23$hi = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$2 = var$0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
   $21 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
   $21 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  var$2 = $21;
  var$2$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$0 = var$2;
  i64toi32_i32$2 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$2 | 0;
  $7$hi = i64toi32_i32$2;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$1 = i64toi32_i32$0 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$0 = var$2$hi;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$4 = i64toi32_i32$1 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$5 = i64toi32_i32$6 + i64toi32_i32$0 | 0;
  i64toi32_i32$5 = i64toi32_i32$2 - i64toi32_i32$5 | 0;
  $9 = i64toi32_i32$4;
  $9$hi = i64toi32_i32$5;
  i64toi32_i32$5 = var$1$hi;
  i64toi32_i32$2 = var$1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$0 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$5 >> 31 | 0;
   $22 = i64toi32_i32$5 >> i64toi32_i32$0 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$5 >> i64toi32_i32$0 | 0;
   $22 = (((1 << i64toi32_i32$0 | 0) - 1 | 0) & i64toi32_i32$5 | 0) << (32 - i64toi32_i32$0 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$0 | 0) | 0;
  }
  var$2 = $22;
  var$2$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$5 = var$2;
  i64toi32_i32$2 = var$1$hi;
  i64toi32_i32$3 = var$1;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$2 | 0;
  $14$hi = i64toi32_i32$2;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$2 = $14$hi;
  i64toi32_i32$1 = i64toi32_i32$5 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$5 = var$2$hi;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$0 = i64toi32_i32$1 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$4 = i64toi32_i32$6 + i64toi32_i32$5 | 0;
  i64toi32_i32$4 = i64toi32_i32$2 - i64toi32_i32$4 | 0;
  $16$hi = i64toi32_i32$4;
  i64toi32_i32$4 = $9$hi;
  i64toi32_i32$1 = $16$hi;
  i64toi32_i32$1 = __wasm_i64_udiv($9 | 0, i64toi32_i32$4 | 0, i64toi32_i32$0 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$4 = i64toi32_i32$HIGH_BITS;
  $17 = i64toi32_i32$1;
  $17$hi = i64toi32_i32$4;
  i64toi32_i32$4 = var$1$hi;
  i64toi32_i32$4 = var$0$hi;
  i64toi32_i32$4 = var$1$hi;
  i64toi32_i32$2 = var$1;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$1 = i64toi32_i32$4 ^ i64toi32_i32$1 | 0;
  i64toi32_i32$4 = i64toi32_i32$2 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$5 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = i64toi32_i32$1 >> 31 | 0;
   $23 = i64toi32_i32$1 >> i64toi32_i32$5 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$1 >> i64toi32_i32$5 | 0;
   $23 = (((1 << i64toi32_i32$5 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$5 | 0) | 0 | (i64toi32_i32$4 >>> i64toi32_i32$5 | 0) | 0;
  }
  var$0 = $23;
  var$0$hi = i64toi32_i32$2;
  i64toi32_i32$2 = $17$hi;
  i64toi32_i32$1 = $17;
  i64toi32_i32$4 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$4 = i64toi32_i32$2 ^ i64toi32_i32$4 | 0;
  $23$hi = i64toi32_i32$4;
  i64toi32_i32$4 = var$0$hi;
  i64toi32_i32$4 = $23$hi;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$5 = i64toi32_i32$2 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$0 = i64toi32_i32$6 + i64toi32_i32$1 | 0;
  i64toi32_i32$0 = i64toi32_i32$4 - i64toi32_i32$0 | 0;
  i64toi32_i32$2 = i64toi32_i32$5;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$2 | 0;
 }
 
 function _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$5 = 0, var$2 = 0, var$3 = 0, var$4 = 0, var$5 = 0, var$5$hi = 0, var$6 = 0, var$6$hi = 0, i64toi32_i32$6 = 0, $37 = 0, $38 = 0, $39 = 0, $40 = 0, $41 = 0, $42 = 0, $43 = 0, $44 = 0, var$8$hi = 0, $45 = 0, $46 = 0, $47 = 0, $48 = 0, var$7$hi = 0, $49 = 0, $63$hi = 0, $65 = 0, $65$hi = 0, $120$hi = 0, $129$hi = 0, $134$hi = 0, var$8 = 0, $140 = 0, $140$hi = 0, $142$hi = 0, $144 = 0, $144$hi = 0, $151 = 0, $151$hi = 0, $154$hi = 0, var$7 = 0, $165$hi = 0;
  label$1 : {
   label$2 : {
    label$3 : {
     label$4 : {
      label$5 : {
       label$6 : {
        label$7 : {
         label$8 : {
          label$9 : {
           label$10 : {
            label$11 : {
             i64toi32_i32$0 = var$0$hi;
             i64toi32_i32$2 = var$0;
             i64toi32_i32$1 = 0;
             i64toi32_i32$3 = 32;
             i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
             if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
              i64toi32_i32$1 = 0;
              $37 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
             } else {
              i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
              $37 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
             }
             var$2 = $37;
             if (var$2) {
              block : {
               i64toi32_i32$1 = var$1$hi;
               var$3 = var$1;
               if (!var$3) {
                break label$11
               }
               i64toi32_i32$1 = var$1$hi;
               i64toi32_i32$0 = var$1;
               i64toi32_i32$2 = 0;
               i64toi32_i32$3 = 32;
               i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
               if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
                i64toi32_i32$2 = 0;
                $38 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
               } else {
                i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
                $38 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$0 >>> i64toi32_i32$4 | 0) | 0;
               }
               var$4 = $38;
               if (!var$4) {
                break label$9
               }
               var$2 = Math_clz32(var$4) - Math_clz32(var$2) | 0;
               if (var$2 >>> 0 <= 31 >>> 0) {
                break label$8
               }
               break label$2;
              }
             }
             i64toi32_i32$2 = var$1$hi;
             i64toi32_i32$1 = var$1;
             i64toi32_i32$0 = 1;
             i64toi32_i32$3 = 0;
             if (i64toi32_i32$2 >>> 0 > i64toi32_i32$0 >>> 0 | ((i64toi32_i32$2 | 0) == (i64toi32_i32$0 | 0) & i64toi32_i32$1 >>> 0 >= i64toi32_i32$3 >>> 0 | 0) | 0) {
              break label$2
             }
             i64toi32_i32$1 = var$0$hi;
             var$2 = var$0;
             i64toi32_i32$1 = var$1$hi;
             var$3 = var$1;
             var$2 = (var$2 >>> 0) / (var$3 >>> 0) | 0;
             i64toi32_i32$1 = 0;
             legalfunc$wasm2js_scratch_store_i64(var$0 - Math_imul(var$2, var$3) | 0 | 0, i64toi32_i32$1 | 0);
             i64toi32_i32$1 = 0;
             i64toi32_i32$2 = var$2;
             i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
             return i64toi32_i32$2 | 0;
            }
            i64toi32_i32$2 = var$1$hi;
            i64toi32_i32$3 = var$1;
            i64toi32_i32$1 = 0;
            i64toi32_i32$0 = 32;
            i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
            if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
             i64toi32_i32$1 = 0;
             $39 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
            } else {
             i64toi32_i32$1 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
             $39 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$2 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$3 >>> i64toi32_i32$4 | 0) | 0;
            }
            var$3 = $39;
            i64toi32_i32$1 = var$0$hi;
            if (!var$0) {
             break label$7
            }
            if (!var$3) {
             break label$6
            }
            var$4 = var$3 + -1 | 0;
            if (var$4 & var$3 | 0) {
             break label$6
            }
            i64toi32_i32$1 = 0;
            i64toi32_i32$2 = var$4 & var$2 | 0;
            i64toi32_i32$3 = 0;
            i64toi32_i32$0 = 32;
            i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
            if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
             i64toi32_i32$3 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
             $40 = 0;
            } else {
             i64toi32_i32$3 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
             $40 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
            }
            $63$hi = i64toi32_i32$3;
            i64toi32_i32$3 = var$0$hi;
            i64toi32_i32$1 = var$0;
            i64toi32_i32$2 = 0;
            i64toi32_i32$0 = -1;
            i64toi32_i32$2 = i64toi32_i32$3 & i64toi32_i32$2 | 0;
            $65 = i64toi32_i32$1 & i64toi32_i32$0 | 0;
            $65$hi = i64toi32_i32$2;
            i64toi32_i32$2 = $63$hi;
            i64toi32_i32$3 = $40;
            i64toi32_i32$1 = $65$hi;
            i64toi32_i32$0 = $65;
            i64toi32_i32$1 = i64toi32_i32$2 | i64toi32_i32$1 | 0;
            legalfunc$wasm2js_scratch_store_i64(i64toi32_i32$3 | i64toi32_i32$0 | 0 | 0, i64toi32_i32$1 | 0);
            i64toi32_i32$1 = 0;
            i64toi32_i32$3 = var$2 >>> ((__wasm_ctz_i32(var$3 | 0) | 0) & 31 | 0) | 0;
            i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
            return i64toi32_i32$3 | 0;
           }
          }
          var$4 = var$3 + -1 | 0;
          if (!(var$4 & var$3 | 0)) {
           break label$5
          }
          var$2 = (Math_clz32(var$3) + 33 | 0) - Math_clz32(var$2) | 0;
          var$3 = 0 - var$2 | 0;
          break label$3;
         }
         var$3 = 63 - var$2 | 0;
         var$2 = var$2 + 1 | 0;
         break label$3;
        }
        var$4 = (var$2 >>> 0) / (var$3 >>> 0) | 0;
        i64toi32_i32$3 = 0;
        i64toi32_i32$2 = var$2 - Math_imul(var$4, var$3) | 0;
        i64toi32_i32$1 = 0;
        i64toi32_i32$0 = 32;
        i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
         $41 = 0;
        } else {
         i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
         $41 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
        }
        legalfunc$wasm2js_scratch_store_i64($41 | 0, i64toi32_i32$1 | 0);
        i64toi32_i32$1 = 0;
        i64toi32_i32$2 = var$4;
        i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
        return i64toi32_i32$2 | 0;
       }
       var$2 = Math_clz32(var$3) - Math_clz32(var$2) | 0;
       if (var$2 >>> 0 < 31 >>> 0) {
        break label$4
       }
       break label$2;
      }
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$2 = 0;
      legalfunc$wasm2js_scratch_store_i64(var$4 & var$0 | 0 | 0, i64toi32_i32$2 | 0);
      if ((var$3 | 0) == (1 | 0)) {
       break label$1
      }
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$2 = 0;
      $120$hi = i64toi32_i32$2;
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$3 = var$0;
      i64toi32_i32$1 = $120$hi;
      i64toi32_i32$0 = __wasm_ctz_i32(var$3 | 0) | 0;
      i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
      if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
       i64toi32_i32$1 = 0;
       $42 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
      } else {
       i64toi32_i32$1 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
       $42 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$2 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$3 >>> i64toi32_i32$4 | 0) | 0;
      }
      i64toi32_i32$3 = $42;
      i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
      return i64toi32_i32$3 | 0;
     }
     var$3 = 63 - var$2 | 0;
     var$2 = var$2 + 1 | 0;
    }
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$3 = 0;
    $129$hi = i64toi32_i32$3;
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$2 = var$0;
    i64toi32_i32$1 = $129$hi;
    i64toi32_i32$0 = var$2 & 63 | 0;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$1 = 0;
     $43 = i64toi32_i32$3 >>> i64toi32_i32$4 | 0;
    } else {
     i64toi32_i32$1 = i64toi32_i32$3 >>> i64toi32_i32$4 | 0;
     $43 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$3 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
    }
    var$5 = $43;
    var$5$hi = i64toi32_i32$1;
    i64toi32_i32$1 = var$0$hi;
    i64toi32_i32$1 = 0;
    $134$hi = i64toi32_i32$1;
    i64toi32_i32$1 = var$0$hi;
    i64toi32_i32$3 = var$0;
    i64toi32_i32$2 = $134$hi;
    i64toi32_i32$0 = var$3 & 63 | 0;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$2 = i64toi32_i32$3 << i64toi32_i32$4 | 0;
     $44 = 0;
    } else {
     i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$3 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
     $44 = i64toi32_i32$3 << i64toi32_i32$4 | 0;
    }
    var$0 = $44;
    var$0$hi = i64toi32_i32$2;
    label$13 : {
     if (var$2) {
      block3 : {
       i64toi32_i32$2 = var$1$hi;
       i64toi32_i32$1 = var$1;
       i64toi32_i32$3 = -1;
       i64toi32_i32$0 = -1;
       i64toi32_i32$4 = i64toi32_i32$1 + i64toi32_i32$0 | 0;
       i64toi32_i32$5 = i64toi32_i32$2 + i64toi32_i32$3 | 0;
       if (i64toi32_i32$4 >>> 0 < i64toi32_i32$0 >>> 0) {
        i64toi32_i32$5 = i64toi32_i32$5 + 1 | 0
       }
       var$8 = i64toi32_i32$4;
       var$8$hi = i64toi32_i32$5;
       label$15 : while (1) {
        i64toi32_i32$5 = var$5$hi;
        i64toi32_i32$2 = var$5;
        i64toi32_i32$1 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$3 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$3 | 0;
         $45 = 0;
        } else {
         i64toi32_i32$1 = ((1 << i64toi32_i32$3 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$3 | 0) | 0) | 0 | (i64toi32_i32$5 << i64toi32_i32$3 | 0) | 0;
         $45 = i64toi32_i32$2 << i64toi32_i32$3 | 0;
        }
        $140 = $45;
        $140$hi = i64toi32_i32$1;
        i64toi32_i32$1 = var$0$hi;
        i64toi32_i32$5 = var$0;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 63;
        i64toi32_i32$3 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = 0;
         $46 = i64toi32_i32$1 >>> i64toi32_i32$3 | 0;
        } else {
         i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$3 | 0;
         $46 = (((1 << i64toi32_i32$3 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$3 | 0) | 0 | (i64toi32_i32$5 >>> i64toi32_i32$3 | 0) | 0;
        }
        $142$hi = i64toi32_i32$2;
        i64toi32_i32$2 = $140$hi;
        i64toi32_i32$1 = $140;
        i64toi32_i32$5 = $142$hi;
        i64toi32_i32$0 = $46;
        i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
        var$5 = i64toi32_i32$1 | i64toi32_i32$0 | 0;
        var$5$hi = i64toi32_i32$5;
        $144 = var$5;
        $144$hi = i64toi32_i32$5;
        i64toi32_i32$5 = var$8$hi;
        i64toi32_i32$5 = var$5$hi;
        i64toi32_i32$5 = var$8$hi;
        i64toi32_i32$2 = var$8;
        i64toi32_i32$1 = var$5$hi;
        i64toi32_i32$0 = var$5;
        i64toi32_i32$3 = i64toi32_i32$2 - i64toi32_i32$0 | 0;
        i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$0 >>> 0;
        i64toi32_i32$4 = i64toi32_i32$6 + i64toi32_i32$1 | 0;
        i64toi32_i32$4 = i64toi32_i32$5 - i64toi32_i32$4 | 0;
        i64toi32_i32$5 = i64toi32_i32$3;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 63;
        i64toi32_i32$1 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = i64toi32_i32$4 >> 31 | 0;
         $47 = i64toi32_i32$4 >> i64toi32_i32$1 | 0;
        } else {
         i64toi32_i32$2 = i64toi32_i32$4 >> i64toi32_i32$1 | 0;
         $47 = (((1 << i64toi32_i32$1 | 0) - 1 | 0) & i64toi32_i32$4 | 0) << (32 - i64toi32_i32$1 | 0) | 0 | (i64toi32_i32$5 >>> i64toi32_i32$1 | 0) | 0;
        }
        var$6 = $47;
        var$6$hi = i64toi32_i32$2;
        i64toi32_i32$2 = var$1$hi;
        i64toi32_i32$2 = var$6$hi;
        i64toi32_i32$4 = var$6;
        i64toi32_i32$5 = var$1$hi;
        i64toi32_i32$0 = var$1;
        i64toi32_i32$5 = i64toi32_i32$2 & i64toi32_i32$5 | 0;
        $151 = i64toi32_i32$4 & i64toi32_i32$0 | 0;
        $151$hi = i64toi32_i32$5;
        i64toi32_i32$5 = $144$hi;
        i64toi32_i32$2 = $144;
        i64toi32_i32$4 = $151$hi;
        i64toi32_i32$0 = $151;
        i64toi32_i32$1 = i64toi32_i32$2 - i64toi32_i32$0 | 0;
        i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$0 >>> 0;
        i64toi32_i32$3 = i64toi32_i32$6 + i64toi32_i32$4 | 0;
        i64toi32_i32$3 = i64toi32_i32$5 - i64toi32_i32$3 | 0;
        var$5 = i64toi32_i32$1;
        var$5$hi = i64toi32_i32$3;
        i64toi32_i32$3 = var$0$hi;
        i64toi32_i32$5 = var$0;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
         $48 = 0;
        } else {
         i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$5 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
         $48 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
        }
        $154$hi = i64toi32_i32$2;
        i64toi32_i32$2 = var$7$hi;
        i64toi32_i32$2 = $154$hi;
        i64toi32_i32$3 = $48;
        i64toi32_i32$5 = var$7$hi;
        i64toi32_i32$0 = var$7;
        i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
        var$0 = i64toi32_i32$3 | i64toi32_i32$0 | 0;
        var$0$hi = i64toi32_i32$5;
        i64toi32_i32$5 = var$6$hi;
        i64toi32_i32$2 = var$6;
        i64toi32_i32$3 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$3 = i64toi32_i32$5 & i64toi32_i32$3 | 0;
        var$6 = i64toi32_i32$2 & i64toi32_i32$0 | 0;
        var$6$hi = i64toi32_i32$3;
        var$7 = var$6;
        var$7$hi = i64toi32_i32$3;
        var$2 = var$2 + -1 | 0;
        if (var$2) {
         continue label$15
        }
        break label$15;
       };
       break label$13;
      }
     }
    }
    i64toi32_i32$3 = var$5$hi;
    legalfunc$wasm2js_scratch_store_i64(var$5 | 0, i64toi32_i32$3 | 0);
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$5 = var$0;
    i64toi32_i32$2 = 0;
    i64toi32_i32$0 = 1;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$2 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
     $49 = 0;
    } else {
     i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$5 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
     $49 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
    }
    $165$hi = i64toi32_i32$2;
    i64toi32_i32$2 = var$6$hi;
    i64toi32_i32$2 = $165$hi;
    i64toi32_i32$3 = $49;
    i64toi32_i32$5 = var$6$hi;
    i64toi32_i32$0 = var$6;
    i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
    i64toi32_i32$3 = i64toi32_i32$3 | i64toi32_i32$0 | 0;
    i64toi32_i32$HIGH_BITS = i64toi32_i32$5;
    return i64toi32_i32$3 | 0;
   }
   i64toi32_i32$3 = var$0$hi;
   legalfunc$wasm2js_scratch_store_i64(var$0 | 0, i64toi32_i32$3 | 0);
   i64toi32_i32$3 = 0;
   var$0 = 0;
   var$0$hi = i64toi32_i32$3;
  }
  i64toi32_i32$3 = var$0$hi;
  i64toi32_i32$5 = var$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$3;
  return i64toi32_i32$5 | 0;
 }
 
 function __wasm_i64_mul(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function __wasm_i64_sdiv(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function __wasm_i64_udiv(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function __wasm_ctz_i32(var$0) {
  var$0 = var$0 | 0;
  if (var$0) {
   return 31 - Math_clz32((var$0 + -1 | 0) ^ var$0 | 0) | 0 | 0
  }
  return 32 | 0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "i32_no_fold_div_s_mul": $0, 
  "i32_no_fold_div_u_mul": $1, 
  "i64_no_fold_div_s_mul": legalstub$2, 
  "i64_no_fold_div_u_mul": legalstub$3
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0},memasmFunc);
export var i32_no_fold_div_s_mul = retasmFunc.i32_no_fold_div_s_mul;
export var i32_no_fold_div_u_mul = retasmFunc.i32_no_fold_div_u_mul;
export var i64_no_fold_div_s_mul = retasmFunc.i64_no_fold_div_s_mul;
export var i64_no_fold_div_u_mul = retasmFunc.i64_no_fold_div_u_mul;
import { setTempRet0 } from 'env';


  var scratchBuffer = new ArrayBuffer(8);
  var i32ScratchView = new Int32Array(scratchBuffer);
  var f32ScratchView = new Float32Array(scratchBuffer);
  var f64ScratchView = new Float64Array(scratchBuffer);
  
  function legalimport$wasm2js_scratch_store_i64(low, high) {
    i32ScratchView[0] = low;
    i32ScratchView[1] = high;
  }
      
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
 function $0(x) {
  x = x | 0;
  return (Math_imul(x, 6) | 0) / (6 | 0) | 0 | 0;
 }
 
 function $1(x) {
  x = x | 0;
  return (Math_imul(x, 6) >>> 0) / (6 >>> 0) | 0 | 0;
 }
 
 function $2(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, $4 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$1 = 0;
  i64toi32_i32$1 = __wasm_i64_mul(x | 0, i64toi32_i32$0 | 0, 6 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $4 = i64toi32_i32$1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$1 = __wasm_i64_sdiv($4 | 0, i64toi32_i32$0 | 0, 6 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $3(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, $4 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$1 = 0;
  i64toi32_i32$1 = __wasm_i64_mul(x | 0, i64toi32_i32$0 | 0, 6 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $4 = i64toi32_i32$1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$1 = __wasm_i64_udiv($4 | 0, i64toi32_i32$0 | 0, 6 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function legalstub$2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $12 = 0, $13 = 0, $4 = 0, $4$hi = 0, $7$hi = 0, $2_1 = 0, $2$hi = 0;
  i64toi32_i32$0 = 0;
  $4 = $0_1;
  $4$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $12 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $12 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $7$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $4$hi;
  i64toi32_i32$0 = $4;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$3 = $12;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$2 = $2(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $2_1 = i64toi32_i32$2;
  $2$hi = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $13 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $13 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$1 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($13 | 0);
  i64toi32_i32$2 = $2$hi;
  return $2_1 | 0;
 }
 
 function legalstub$3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $12 = 0, $13 = 0, $4 = 0, $4$hi = 0, $7$hi = 0, $2_1 = 0, $2$hi = 0;
  i64toi32_i32$0 = 0;
  $4 = $0_1;
  $4$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $12 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $12 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $7$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $4$hi;
  i64toi32_i32$0 = $4;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$3 = $12;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$2 = $3(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $2_1 = i64toi32_i32$2;
  $2$hi = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $13 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $13 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$1 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($13 | 0);
  i64toi32_i32$2 = $2$hi;
  return $2_1 | 0;
 }
 
 function legalfunc$wasm2js_scratch_store_i64($0_1, $0$hi) {
  $0_1 = $0_1 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8 = 0, $2_1 = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $0$hi;
  $2_1 = $0_1;
  i64toi32_i32$2 = $0_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = 0;
   $8 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $8 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  legalimport$wasm2js_scratch_store_i64($2_1 | 0, $8 | 0);
 }
 
 function _ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, var$2 = 0, i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, var$3 = 0, var$4 = 0, var$5 = 0, $21 = 0, $22 = 0, var$6 = 0, $24 = 0, $17 = 0, $18 = 0, $23 = 0, $29 = 0, $45 = 0, $56$hi = 0, $62$hi = 0;
  i64toi32_i32$0 = var$1$hi;
  var$2 = var$1;
  var$4 = var$2 >>> 16 | 0;
  i64toi32_i32$0 = var$0$hi;
  var$3 = var$0;
  var$5 = var$3 >>> 16 | 0;
  $17 = Math_imul(var$4, var$5);
  $18 = var$2;
  i64toi32_i32$2 = var$3;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = 0;
   $21 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $21 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  $23 = $17 + Math_imul($18, $21) | 0;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$0 = var$1;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $22 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $22 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$0 >>> i64toi32_i32$4 | 0) | 0;
  }
  $29 = $23 + Math_imul($22, var$3) | 0;
  var$2 = var$2 & 65535 | 0;
  var$3 = var$3 & 65535 | 0;
  var$6 = Math_imul(var$2, var$3);
  var$2 = (var$6 >>> 16 | 0) + Math_imul(var$2, var$5) | 0;
  $45 = $29 + (var$2 >>> 16 | 0) | 0;
  var$2 = (var$2 & 65535 | 0) + Math_imul(var$4, var$3) | 0;
  i64toi32_i32$2 = 0;
  i64toi32_i32$1 = $45 + (var$2 >>> 16 | 0) | 0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = i64toi32_i32$1 << i64toi32_i32$4 | 0;
   $24 = 0;
  } else {
   i64toi32_i32$0 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$1 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$2 << i64toi32_i32$4 | 0) | 0;
   $24 = i64toi32_i32$1 << i64toi32_i32$4 | 0;
  }
  $56$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  $62$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $56$hi;
  i64toi32_i32$2 = $24;
  i64toi32_i32$1 = $62$hi;
  i64toi32_i32$3 = var$2 << 16 | 0 | (var$6 & 65535 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$0 | i64toi32_i32$1 | 0;
  i64toi32_i32$2 = i64toi32_i32$2 | i64toi32_i32$3 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$2 | 0;
 }
 
 function _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$1 = 0, i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, i64toi32_i32$0 = 0, i64toi32_i32$5 = 0, var$2 = 0, var$2$hi = 0, i64toi32_i32$6 = 0, $21 = 0, $22 = 0, $23 = 0, $7$hi = 0, $9 = 0, $9$hi = 0, $14$hi = 0, $16$hi = 0, $17 = 0, $17$hi = 0, $23$hi = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$2 = var$0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
   $21 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
   $21 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  var$2 = $21;
  var$2$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$0 = var$2;
  i64toi32_i32$2 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$2 | 0;
  $7$hi = i64toi32_i32$2;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$1 = i64toi32_i32$0 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$0 = var$2$hi;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$4 = i64toi32_i32$1 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$5 = i64toi32_i32$6 + i64toi32_i32$0 | 0;
  i64toi32_i32$5 = i64toi32_i32$2 - i64toi32_i32$5 | 0;
  $9 = i64toi32_i32$4;
  $9$hi = i64toi32_i32$5;
  i64toi32_i32$5 = var$1$hi;
  i64toi32_i32$2 = var$1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$0 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$5 >> 31 | 0;
   $22 = i64toi32_i32$5 >> i64toi32_i32$0 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$5 >> i64toi32_i32$0 | 0;
   $22 = (((1 << i64toi32_i32$0 | 0) - 1 | 0) & i64toi32_i32$5 | 0) << (32 - i64toi32_i32$0 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$0 | 0) | 0;
  }
  var$2 = $22;
  var$2$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$5 = var$2;
  i64toi32_i32$2 = var$1$hi;
  i64toi32_i32$3 = var$1;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$2 | 0;
  $14$hi = i64toi32_i32$2;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$2 = $14$hi;
  i64toi32_i32$1 = i64toi32_i32$5 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$5 = var$2$hi;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$0 = i64toi32_i32$1 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$4 = i64toi32_i32$6 + i64toi32_i32$5 | 0;
  i64toi32_i32$4 = i64toi32_i32$2 - i64toi32_i32$4 | 0;
  $16$hi = i64toi32_i32$4;
  i64toi32_i32$4 = $9$hi;
  i64toi32_i32$1 = $16$hi;
  i64toi32_i32$1 = __wasm_i64_udiv($9 | 0, i64toi32_i32$4 | 0, i64toi32_i32$0 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$4 = i64toi32_i32$HIGH_BITS;
  $17 = i64toi32_i32$1;
  $17$hi = i64toi32_i32$4;
  i64toi32_i32$4 = var$1$hi;
  i64toi32_i32$4 = var$0$hi;
  i64toi32_i32$4 = var$1$hi;
  i64toi32_i32$2 = var$1;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$1 = i64toi32_i32$4 ^ i64toi32_i32$1 | 0;
  i64toi32_i32$4 = i64toi32_i32$2 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$5 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = i64toi32_i32$1 >> 31 | 0;
   $23 = i64toi32_i32$1 >> i64toi32_i32$5 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$1 >> i64toi32_i32$5 | 0;
   $23 = (((1 << i64toi32_i32$5 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$5 | 0) | 0 | (i64toi32_i32$4 >>> i64toi32_i32$5 | 0) | 0;
  }
  var$0 = $23;
  var$0$hi = i64toi32_i32$2;
  i64toi32_i32$2 = $17$hi;
  i64toi32_i32$1 = $17;
  i64toi32_i32$4 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$4 = i64toi32_i32$2 ^ i64toi32_i32$4 | 0;
  $23$hi = i64toi32_i32$4;
  i64toi32_i32$4 = var$0$hi;
  i64toi32_i32$4 = $23$hi;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$5 = i64toi32_i32$2 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$0 = i64toi32_i32$6 + i64toi32_i32$1 | 0;
  i64toi32_i32$0 = i64toi32_i32$4 - i64toi32_i32$0 | 0;
  i64toi32_i32$2 = i64toi32_i32$5;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$2 | 0;
 }
 
 function _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$5 = 0, var$2 = 0, var$3 = 0, var$4 = 0, var$5 = 0, var$5$hi = 0, var$6 = 0, var$6$hi = 0, i64toi32_i32$6 = 0, $37 = 0, $38 = 0, $39 = 0, $40 = 0, $41 = 0, $42 = 0, $43 = 0, $44 = 0, var$8$hi = 0, $45 = 0, $46 = 0, $47 = 0, $48 = 0, var$7$hi = 0, $49 = 0, $63$hi = 0, $65 = 0, $65$hi = 0, $120$hi = 0, $129$hi = 0, $134$hi = 0, var$8 = 0, $140 = 0, $140$hi = 0, $142$hi = 0, $144 = 0, $144$hi = 0, $151 = 0, $151$hi = 0, $154$hi = 0, var$7 = 0, $165$hi = 0;
  label$1 : {
   label$2 : {
    label$3 : {
     label$4 : {
      label$5 : {
       label$6 : {
        label$7 : {
         label$8 : {
          label$9 : {
           label$10 : {
            label$11 : {
             i64toi32_i32$0 = var$0$hi;
             i64toi32_i32$2 = var$0;
             i64toi32_i32$1 = 0;
             i64toi32_i32$3 = 32;
             i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
             if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
              i64toi32_i32$1 = 0;
              $37 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
             } else {
              i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
              $37 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
             }
             var$2 = $37;
             if (var$2) {
              block : {
               i64toi32_i32$1 = var$1$hi;
               var$3 = var$1;
               if (!var$3) {
                break label$11
               }
               i64toi32_i32$1 = var$1$hi;
               i64toi32_i32$0 = var$1;
               i64toi32_i32$2 = 0;
               i64toi32_i32$3 = 32;
               i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
               if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
                i64toi32_i32$2 = 0;
                $38 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
               } else {
                i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
                $38 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$0 >>> i64toi32_i32$4 | 0) | 0;
               }
               var$4 = $38;
               if (!var$4) {
                break label$9
               }
               var$2 = Math_clz32(var$4) - Math_clz32(var$2) | 0;
               if (var$2 >>> 0 <= 31 >>> 0) {
                break label$8
               }
               break label$2;
              }
             }
             i64toi32_i32$2 = var$1$hi;
             i64toi32_i32$1 = var$1;
             i64toi32_i32$0 = 1;
             i64toi32_i32$3 = 0;
             if (i64toi32_i32$2 >>> 0 > i64toi32_i32$0 >>> 0 | ((i64toi32_i32$2 | 0) == (i64toi32_i32$0 | 0) & i64toi32_i32$1 >>> 0 >= i64toi32_i32$3 >>> 0 | 0) | 0) {
              break label$2
             }
             i64toi32_i32$1 = var$0$hi;
             var$2 = var$0;
             i64toi32_i32$1 = var$1$hi;
             var$3 = var$1;
             var$2 = (var$2 >>> 0) / (var$3 >>> 0) | 0;
             i64toi32_i32$1 = 0;
             legalfunc$wasm2js_scratch_store_i64(var$0 - Math_imul(var$2, var$3) | 0 | 0, i64toi32_i32$1 | 0);
             i64toi32_i32$1 = 0;
             i64toi32_i32$2 = var$2;
             i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
             return i64toi32_i32$2 | 0;
            }
            i64toi32_i32$2 = var$1$hi;
            i64toi32_i32$3 = var$1;
            i64toi32_i32$1 = 0;
            i64toi32_i32$0 = 32;
            i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
            if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
             i64toi32_i32$1 = 0;
             $39 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
            } else {
             i64toi32_i32$1 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
             $39 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$2 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$3 >>> i64toi32_i32$4 | 0) | 0;
            }
            var$3 = $39;
            i64toi32_i32$1 = var$0$hi;
            if (!var$0) {
             break label$7
            }
            if (!var$3) {
             break label$6
            }
            var$4 = var$3 + -1 | 0;
            if (var$4 & var$3 | 0) {
             break label$6
            }
            i64toi32_i32$1 = 0;
            i64toi32_i32$2 = var$4 & var$2 | 0;
            i64toi32_i32$3 = 0;
            i64toi32_i32$0 = 32;
            i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
            if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
             i64toi32_i32$3 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
             $40 = 0;
            } else {
             i64toi32_i32$3 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
             $40 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
            }
            $63$hi = i64toi32_i32$3;
            i64toi32_i32$3 = var$0$hi;
            i64toi32_i32$1 = var$0;
            i64toi32_i32$2 = 0;
            i64toi32_i32$0 = -1;
            i64toi32_i32$2 = i64toi32_i32$3 & i64toi32_i32$2 | 0;
            $65 = i64toi32_i32$1 & i64toi32_i32$0 | 0;
            $65$hi = i64toi32_i32$2;
            i64toi32_i32$2 = $63$hi;
            i64toi32_i32$3 = $40;
            i64toi32_i32$1 = $65$hi;
            i64toi32_i32$0 = $65;
            i64toi32_i32$1 = i64toi32_i32$2 | i64toi32_i32$1 | 0;
            legalfunc$wasm2js_scratch_store_i64(i64toi32_i32$3 | i64toi32_i32$0 | 0 | 0, i64toi32_i32$1 | 0);
            i64toi32_i32$1 = 0;
            i64toi32_i32$3 = var$2 >>> ((__wasm_ctz_i32(var$3 | 0) | 0) & 31 | 0) | 0;
            i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
            return i64toi32_i32$3 | 0;
           }
          }
          var$4 = var$3 + -1 | 0;
          if (!(var$4 & var$3 | 0)) {
           break label$5
          }
          var$2 = (Math_clz32(var$3) + 33 | 0) - Math_clz32(var$2) | 0;
          var$3 = 0 - var$2 | 0;
          break label$3;
         }
         var$3 = 63 - var$2 | 0;
         var$2 = var$2 + 1 | 0;
         break label$3;
        }
        var$4 = (var$2 >>> 0) / (var$3 >>> 0) | 0;
        i64toi32_i32$3 = 0;
        i64toi32_i32$2 = var$2 - Math_imul(var$4, var$3) | 0;
        i64toi32_i32$1 = 0;
        i64toi32_i32$0 = 32;
        i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
         $41 = 0;
        } else {
         i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
         $41 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
        }
        legalfunc$wasm2js_scratch_store_i64($41 | 0, i64toi32_i32$1 | 0);
        i64toi32_i32$1 = 0;
        i64toi32_i32$2 = var$4;
        i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
        return i64toi32_i32$2 | 0;
       }
       var$2 = Math_clz32(var$3) - Math_clz32(var$2) | 0;
       if (var$2 >>> 0 < 31 >>> 0) {
        break label$4
       }
       break label$2;
      }
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$2 = 0;
      legalfunc$wasm2js_scratch_store_i64(var$4 & var$0 | 0 | 0, i64toi32_i32$2 | 0);
      if ((var$3 | 0) == (1 | 0)) {
       break label$1
      }
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$2 = 0;
      $120$hi = i64toi32_i32$2;
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$3 = var$0;
      i64toi32_i32$1 = $120$hi;
      i64toi32_i32$0 = __wasm_ctz_i32(var$3 | 0) | 0;
      i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
      if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
       i64toi32_i32$1 = 0;
       $42 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
      } else {
       i64toi32_i32$1 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
       $42 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$2 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$3 >>> i64toi32_i32$4 | 0) | 0;
      }
      i64toi32_i32$3 = $42;
      i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
      return i64toi32_i32$3 | 0;
     }
     var$3 = 63 - var$2 | 0;
     var$2 = var$2 + 1 | 0;
    }
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$3 = 0;
    $129$hi = i64toi32_i32$3;
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$2 = var$0;
    i64toi32_i32$1 = $129$hi;
    i64toi32_i32$0 = var$2 & 63 | 0;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$1 = 0;
     $43 = i64toi32_i32$3 >>> i64toi32_i32$4 | 0;
    } else {
     i64toi32_i32$1 = i64toi32_i32$3 >>> i64toi32_i32$4 | 0;
     $43 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$3 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
    }
    var$5 = $43;
    var$5$hi = i64toi32_i32$1;
    i64toi32_i32$1 = var$0$hi;
    i64toi32_i32$1 = 0;
    $134$hi = i64toi32_i32$1;
    i64toi32_i32$1 = var$0$hi;
    i64toi32_i32$3 = var$0;
    i64toi32_i32$2 = $134$hi;
    i64toi32_i32$0 = var$3 & 63 | 0;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$2 = i64toi32_i32$3 << i64toi32_i32$4 | 0;
     $44 = 0;
    } else {
     i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$3 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
     $44 = i64toi32_i32$3 << i64toi32_i32$4 | 0;
    }
    var$0 = $44;
    var$0$hi = i64toi32_i32$2;
    label$13 : {
     if (var$2) {
      block3 : {
       i64toi32_i32$2 = var$1$hi;
       i64toi32_i32$1 = var$1;
       i64toi32_i32$3 = -1;
       i64toi32_i32$0 = -1;
       i64toi32_i32$4 = i64toi32_i32$1 + i64toi32_i32$0 | 0;
       i64toi32_i32$5 = i64toi32_i32$2 + i64toi32_i32$3 | 0;
       if (i64toi32_i32$4 >>> 0 < i64toi32_i32$0 >>> 0) {
        i64toi32_i32$5 = i64toi32_i32$5 + 1 | 0
       }
       var$8 = i64toi32_i32$4;
       var$8$hi = i64toi32_i32$5;
       label$15 : while (1) {
        i64toi32_i32$5 = var$5$hi;
        i64toi32_i32$2 = var$5;
        i64toi32_i32$1 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$3 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$3 | 0;
         $45 = 0;
        } else {
         i64toi32_i32$1 = ((1 << i64toi32_i32$3 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$3 | 0) | 0) | 0 | (i64toi32_i32$5 << i64toi32_i32$3 | 0) | 0;
         $45 = i64toi32_i32$2 << i64toi32_i32$3 | 0;
        }
        $140 = $45;
        $140$hi = i64toi32_i32$1;
        i64toi32_i32$1 = var$0$hi;
        i64toi32_i32$5 = var$0;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 63;
        i64toi32_i32$3 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = 0;
         $46 = i64toi32_i32$1 >>> i64toi32_i32$3 | 0;
        } else {
         i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$3 | 0;
         $46 = (((1 << i64toi32_i32$3 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$3 | 0) | 0 | (i64toi32_i32$5 >>> i64toi32_i32$3 | 0) | 0;
        }
        $142$hi = i64toi32_i32$2;
        i64toi32_i32$2 = $140$hi;
        i64toi32_i32$1 = $140;
        i64toi32_i32$5 = $142$hi;
        i64toi32_i32$0 = $46;
        i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
        var$5 = i64toi32_i32$1 | i64toi32_i32$0 | 0;
        var$5$hi = i64toi32_i32$5;
        $144 = var$5;
        $144$hi = i64toi32_i32$5;
        i64toi32_i32$5 = var$8$hi;
        i64toi32_i32$5 = var$5$hi;
        i64toi32_i32$5 = var$8$hi;
        i64toi32_i32$2 = var$8;
        i64toi32_i32$1 = var$5$hi;
        i64toi32_i32$0 = var$5;
        i64toi32_i32$3 = i64toi32_i32$2 - i64toi32_i32$0 | 0;
        i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$0 >>> 0;
        i64toi32_i32$4 = i64toi32_i32$6 + i64toi32_i32$1 | 0;
        i64toi32_i32$4 = i64toi32_i32$5 - i64toi32_i32$4 | 0;
        i64toi32_i32$5 = i64toi32_i32$3;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 63;
        i64toi32_i32$1 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = i64toi32_i32$4 >> 31 | 0;
         $47 = i64toi32_i32$4 >> i64toi32_i32$1 | 0;
        } else {
         i64toi32_i32$2 = i64toi32_i32$4 >> i64toi32_i32$1 | 0;
         $47 = (((1 << i64toi32_i32$1 | 0) - 1 | 0) & i64toi32_i32$4 | 0) << (32 - i64toi32_i32$1 | 0) | 0 | (i64toi32_i32$5 >>> i64toi32_i32$1 | 0) | 0;
        }
        var$6 = $47;
        var$6$hi = i64toi32_i32$2;
        i64toi32_i32$2 = var$1$hi;
        i64toi32_i32$2 = var$6$hi;
        i64toi32_i32$4 = var$6;
        i64toi32_i32$5 = var$1$hi;
        i64toi32_i32$0 = var$1;
        i64toi32_i32$5 = i64toi32_i32$2 & i64toi32_i32$5 | 0;
        $151 = i64toi32_i32$4 & i64toi32_i32$0 | 0;
        $151$hi = i64toi32_i32$5;
        i64toi32_i32$5 = $144$hi;
        i64toi32_i32$2 = $144;
        i64toi32_i32$4 = $151$hi;
        i64toi32_i32$0 = $151;
        i64toi32_i32$1 = i64toi32_i32$2 - i64toi32_i32$0 | 0;
        i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$0 >>> 0;
        i64toi32_i32$3 = i64toi32_i32$6 + i64toi32_i32$4 | 0;
        i64toi32_i32$3 = i64toi32_i32$5 - i64toi32_i32$3 | 0;
        var$5 = i64toi32_i32$1;
        var$5$hi = i64toi32_i32$3;
        i64toi32_i32$3 = var$0$hi;
        i64toi32_i32$5 = var$0;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
         $48 = 0;
        } else {
         i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$5 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
         $48 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
        }
        $154$hi = i64toi32_i32$2;
        i64toi32_i32$2 = var$7$hi;
        i64toi32_i32$2 = $154$hi;
        i64toi32_i32$3 = $48;
        i64toi32_i32$5 = var$7$hi;
        i64toi32_i32$0 = var$7;
        i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
        var$0 = i64toi32_i32$3 | i64toi32_i32$0 | 0;
        var$0$hi = i64toi32_i32$5;
        i64toi32_i32$5 = var$6$hi;
        i64toi32_i32$2 = var$6;
        i64toi32_i32$3 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$3 = i64toi32_i32$5 & i64toi32_i32$3 | 0;
        var$6 = i64toi32_i32$2 & i64toi32_i32$0 | 0;
        var$6$hi = i64toi32_i32$3;
        var$7 = var$6;
        var$7$hi = i64toi32_i32$3;
        var$2 = var$2 + -1 | 0;
        if (var$2) {
         continue label$15
        }
        break label$15;
       };
       break label$13;
      }
     }
    }
    i64toi32_i32$3 = var$5$hi;
    legalfunc$wasm2js_scratch_store_i64(var$5 | 0, i64toi32_i32$3 | 0);
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$5 = var$0;
    i64toi32_i32$2 = 0;
    i64toi32_i32$0 = 1;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$2 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
     $49 = 0;
    } else {
     i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$5 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
     $49 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
    }
    $165$hi = i64toi32_i32$2;
    i64toi32_i32$2 = var$6$hi;
    i64toi32_i32$2 = $165$hi;
    i64toi32_i32$3 = $49;
    i64toi32_i32$5 = var$6$hi;
    i64toi32_i32$0 = var$6;
    i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
    i64toi32_i32$3 = i64toi32_i32$3 | i64toi32_i32$0 | 0;
    i64toi32_i32$HIGH_BITS = i64toi32_i32$5;
    return i64toi32_i32$3 | 0;
   }
   i64toi32_i32$3 = var$0$hi;
   legalfunc$wasm2js_scratch_store_i64(var$0 | 0, i64toi32_i32$3 | 0);
   i64toi32_i32$3 = 0;
   var$0 = 0;
   var$0$hi = i64toi32_i32$3;
  }
  i64toi32_i32$3 = var$0$hi;
  i64toi32_i32$5 = var$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$3;
  return i64toi32_i32$5 | 0;
 }
 
 function __wasm_i64_mul(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function __wasm_i64_sdiv(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function __wasm_i64_udiv(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function __wasm_ctz_i32(var$0) {
  var$0 = var$0 | 0;
  if (var$0) {
   return 31 - Math_clz32((var$0 + -1 | 0) ^ var$0 | 0) | 0 | 0
  }
  return 32 | 0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "i32_no_fold_mul_div_s": $0, 
  "i32_no_fold_mul_div_u": $1, 
  "i64_no_fold_mul_div_s": legalstub$2, 
  "i64_no_fold_mul_div_u": legalstub$3
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0},memasmFunc);
export var i32_no_fold_mul_div_s = retasmFunc.i32_no_fold_mul_div_s;
export var i32_no_fold_mul_div_u = retasmFunc.i32_no_fold_mul_div_u;
export var i64_no_fold_mul_div_s = retasmFunc.i64_no_fold_mul_div_s;
export var i64_no_fold_mul_div_u = retasmFunc.i64_no_fold_mul_div_u;
import { setTempRet0 } from 'env';


  var scratchBuffer = new ArrayBuffer(8);
  var i32ScratchView = new Int32Array(scratchBuffer);
  var f32ScratchView = new Float32Array(scratchBuffer);
  var f64ScratchView = new Float64Array(scratchBuffer);
  
  function legalimport$wasm2js_scratch_store_i64(low, high) {
    i32ScratchView[0] = low;
    i32ScratchView[1] = high;
  }
      
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
 function $0(x) {
  x = x | 0;
  return (x | 0) / (2 | 0) | 0 | 0;
 }
 
 function $1(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$1 = 0;
  i64toi32_i32$1 = __wasm_i64_sdiv(x | 0, i64toi32_i32$0 | 0, 2 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function legalstub$1($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $12 = 0, $13 = 0, $4 = 0, $4$hi = 0, $7$hi = 0, $2 = 0, $2$hi = 0;
  i64toi32_i32$0 = 0;
  $4 = $0_1;
  $4$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $12 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $12 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $7$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $4$hi;
  i64toi32_i32$0 = $4;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$3 = $12;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$2 = $1(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $2 = i64toi32_i32$2;
  $2$hi = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $13 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $13 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$1 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($13 | 0);
  i64toi32_i32$2 = $2$hi;
  return $2 | 0;
 }
 
 function legalfunc$wasm2js_scratch_store_i64($0_1, $0$hi) {
  $0_1 = $0_1 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8 = 0, $2 = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $0$hi;
  $2 = $0_1;
  i64toi32_i32$2 = $0_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = 0;
   $8 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $8 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  legalimport$wasm2js_scratch_store_i64($2 | 0, $8 | 0);
 }
 
 function _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$1 = 0, i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, i64toi32_i32$0 = 0, i64toi32_i32$5 = 0, var$2 = 0, var$2$hi = 0, i64toi32_i32$6 = 0, $21 = 0, $22 = 0, $23 = 0, $7$hi = 0, $9 = 0, $9$hi = 0, $14$hi = 0, $16$hi = 0, $17 = 0, $17$hi = 0, $23$hi = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$2 = var$0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
   $21 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
   $21 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  var$2 = $21;
  var$2$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$0 = var$2;
  i64toi32_i32$2 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$2 | 0;
  $7$hi = i64toi32_i32$2;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$1 = i64toi32_i32$0 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$0 = var$2$hi;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$4 = i64toi32_i32$1 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$5 = i64toi32_i32$6 + i64toi32_i32$0 | 0;
  i64toi32_i32$5 = i64toi32_i32$2 - i64toi32_i32$5 | 0;
  $9 = i64toi32_i32$4;
  $9$hi = i64toi32_i32$5;
  i64toi32_i32$5 = var$1$hi;
  i64toi32_i32$2 = var$1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$0 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$5 >> 31 | 0;
   $22 = i64toi32_i32$5 >> i64toi32_i32$0 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$5 >> i64toi32_i32$0 | 0;
   $22 = (((1 << i64toi32_i32$0 | 0) - 1 | 0) & i64toi32_i32$5 | 0) << (32 - i64toi32_i32$0 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$0 | 0) | 0;
  }
  var$2 = $22;
  var$2$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$5 = var$2;
  i64toi32_i32$2 = var$1$hi;
  i64toi32_i32$3 = var$1;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$2 | 0;
  $14$hi = i64toi32_i32$2;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$2 = $14$hi;
  i64toi32_i32$1 = i64toi32_i32$5 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$5 = var$2$hi;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$0 = i64toi32_i32$1 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$4 = i64toi32_i32$6 + i64toi32_i32$5 | 0;
  i64toi32_i32$4 = i64toi32_i32$2 - i64toi32_i32$4 | 0;
  $16$hi = i64toi32_i32$4;
  i64toi32_i32$4 = $9$hi;
  i64toi32_i32$1 = $16$hi;
  i64toi32_i32$1 = __wasm_i64_udiv($9 | 0, i64toi32_i32$4 | 0, i64toi32_i32$0 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$4 = i64toi32_i32$HIGH_BITS;
  $17 = i64toi32_i32$1;
  $17$hi = i64toi32_i32$4;
  i64toi32_i32$4 = var$1$hi;
  i64toi32_i32$4 = var$0$hi;
  i64toi32_i32$4 = var$1$hi;
  i64toi32_i32$2 = var$1;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$1 = i64toi32_i32$4 ^ i64toi32_i32$1 | 0;
  i64toi32_i32$4 = i64toi32_i32$2 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$5 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = i64toi32_i32$1 >> 31 | 0;
   $23 = i64toi32_i32$1 >> i64toi32_i32$5 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$1 >> i64toi32_i32$5 | 0;
   $23 = (((1 << i64toi32_i32$5 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$5 | 0) | 0 | (i64toi32_i32$4 >>> i64toi32_i32$5 | 0) | 0;
  }
  var$0 = $23;
  var$0$hi = i64toi32_i32$2;
  i64toi32_i32$2 = $17$hi;
  i64toi32_i32$1 = $17;
  i64toi32_i32$4 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$4 = i64toi32_i32$2 ^ i64toi32_i32$4 | 0;
  $23$hi = i64toi32_i32$4;
  i64toi32_i32$4 = var$0$hi;
  i64toi32_i32$4 = $23$hi;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$5 = i64toi32_i32$2 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$0 = i64toi32_i32$6 + i64toi32_i32$1 | 0;
  i64toi32_i32$0 = i64toi32_i32$4 - i64toi32_i32$0 | 0;
  i64toi32_i32$2 = i64toi32_i32$5;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$2 | 0;
 }
 
 function __wasm_i64_sdiv(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$5 = 0, var$2 = 0, var$3 = 0, var$4 = 0, var$5 = 0, var$5$hi = 0, var$6 = 0, var$6$hi = 0, i64toi32_i32$6 = 0, $37 = 0, $38 = 0, $39 = 0, $40 = 0, $41 = 0, $42 = 0, $43 = 0, $44 = 0, var$8$hi = 0, $45 = 0, $46 = 0, $47 = 0, $48 = 0, var$7$hi = 0, $49 = 0, $63$hi = 0, $65 = 0, $65$hi = 0, $120$hi = 0, $129$hi = 0, $134$hi = 0, var$8 = 0, $140 = 0, $140$hi = 0, $142$hi = 0, $144 = 0, $144$hi = 0, $151 = 0, $151$hi = 0, $154$hi = 0, var$7 = 0, $165$hi = 0;
  label$1 : {
   label$2 : {
    label$3 : {
     label$4 : {
      label$5 : {
       label$6 : {
        label$7 : {
         label$8 : {
          label$9 : {
           label$10 : {
            label$11 : {
             i64toi32_i32$0 = var$0$hi;
             i64toi32_i32$2 = var$0;
             i64toi32_i32$1 = 0;
             i64toi32_i32$3 = 32;
             i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
             if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
              i64toi32_i32$1 = 0;
              $37 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
             } else {
              i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
              $37 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
             }
             var$2 = $37;
             if (var$2) {
              block : {
               i64toi32_i32$1 = var$1$hi;
               var$3 = var$1;
               if (!var$3) {
                break label$11
               }
               i64toi32_i32$1 = var$1$hi;
               i64toi32_i32$0 = var$1;
               i64toi32_i32$2 = 0;
               i64toi32_i32$3 = 32;
               i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
               if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
                i64toi32_i32$2 = 0;
                $38 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
               } else {
                i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
                $38 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$0 >>> i64toi32_i32$4 | 0) | 0;
               }
               var$4 = $38;
               if (!var$4) {
                break label$9
               }
               var$2 = Math_clz32(var$4) - Math_clz32(var$2) | 0;
               if (var$2 >>> 0 <= 31 >>> 0) {
                break label$8
               }
               break label$2;
              }
             }
             i64toi32_i32$2 = var$1$hi;
             i64toi32_i32$1 = var$1;
             i64toi32_i32$0 = 1;
             i64toi32_i32$3 = 0;
             if (i64toi32_i32$2 >>> 0 > i64toi32_i32$0 >>> 0 | ((i64toi32_i32$2 | 0) == (i64toi32_i32$0 | 0) & i64toi32_i32$1 >>> 0 >= i64toi32_i32$3 >>> 0 | 0) | 0) {
              break label$2
             }
             i64toi32_i32$1 = var$0$hi;
             var$2 = var$0;
             i64toi32_i32$1 = var$1$hi;
             var$3 = var$1;
             var$2 = (var$2 >>> 0) / (var$3 >>> 0) | 0;
             i64toi32_i32$1 = 0;
             legalfunc$wasm2js_scratch_store_i64(var$0 - Math_imul(var$2, var$3) | 0 | 0, i64toi32_i32$1 | 0);
             i64toi32_i32$1 = 0;
             i64toi32_i32$2 = var$2;
             i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
             return i64toi32_i32$2 | 0;
            }
            i64toi32_i32$2 = var$1$hi;
            i64toi32_i32$3 = var$1;
            i64toi32_i32$1 = 0;
            i64toi32_i32$0 = 32;
            i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
            if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
             i64toi32_i32$1 = 0;
             $39 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
            } else {
             i64toi32_i32$1 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
             $39 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$2 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$3 >>> i64toi32_i32$4 | 0) | 0;
            }
            var$3 = $39;
            i64toi32_i32$1 = var$0$hi;
            if (!var$0) {
             break label$7
            }
            if (!var$3) {
             break label$6
            }
            var$4 = var$3 + -1 | 0;
            if (var$4 & var$3 | 0) {
             break label$6
            }
            i64toi32_i32$1 = 0;
            i64toi32_i32$2 = var$4 & var$2 | 0;
            i64toi32_i32$3 = 0;
            i64toi32_i32$0 = 32;
            i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
            if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
             i64toi32_i32$3 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
             $40 = 0;
            } else {
             i64toi32_i32$3 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
             $40 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
            }
            $63$hi = i64toi32_i32$3;
            i64toi32_i32$3 = var$0$hi;
            i64toi32_i32$1 = var$0;
            i64toi32_i32$2 = 0;
            i64toi32_i32$0 = -1;
            i64toi32_i32$2 = i64toi32_i32$3 & i64toi32_i32$2 | 0;
            $65 = i64toi32_i32$1 & i64toi32_i32$0 | 0;
            $65$hi = i64toi32_i32$2;
            i64toi32_i32$2 = $63$hi;
            i64toi32_i32$3 = $40;
            i64toi32_i32$1 = $65$hi;
            i64toi32_i32$0 = $65;
            i64toi32_i32$1 = i64toi32_i32$2 | i64toi32_i32$1 | 0;
            legalfunc$wasm2js_scratch_store_i64(i64toi32_i32$3 | i64toi32_i32$0 | 0 | 0, i64toi32_i32$1 | 0);
            i64toi32_i32$1 = 0;
            i64toi32_i32$3 = var$2 >>> ((__wasm_ctz_i32(var$3 | 0) | 0) & 31 | 0) | 0;
            i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
            return i64toi32_i32$3 | 0;
           }
          }
          var$4 = var$3 + -1 | 0;
          if (!(var$4 & var$3 | 0)) {
           break label$5
          }
          var$2 = (Math_clz32(var$3) + 33 | 0) - Math_clz32(var$2) | 0;
          var$3 = 0 - var$2 | 0;
          break label$3;
         }
         var$3 = 63 - var$2 | 0;
         var$2 = var$2 + 1 | 0;
         break label$3;
        }
        var$4 = (var$2 >>> 0) / (var$3 >>> 0) | 0;
        i64toi32_i32$3 = 0;
        i64toi32_i32$2 = var$2 - Math_imul(var$4, var$3) | 0;
        i64toi32_i32$1 = 0;
        i64toi32_i32$0 = 32;
        i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
         $41 = 0;
        } else {
         i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
         $41 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
        }
        legalfunc$wasm2js_scratch_store_i64($41 | 0, i64toi32_i32$1 | 0);
        i64toi32_i32$1 = 0;
        i64toi32_i32$2 = var$4;
        i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
        return i64toi32_i32$2 | 0;
       }
       var$2 = Math_clz32(var$3) - Math_clz32(var$2) | 0;
       if (var$2 >>> 0 < 31 >>> 0) {
        break label$4
       }
       break label$2;
      }
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$2 = 0;
      legalfunc$wasm2js_scratch_store_i64(var$4 & var$0 | 0 | 0, i64toi32_i32$2 | 0);
      if ((var$3 | 0) == (1 | 0)) {
       break label$1
      }
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$2 = 0;
      $120$hi = i64toi32_i32$2;
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$3 = var$0;
      i64toi32_i32$1 = $120$hi;
      i64toi32_i32$0 = __wasm_ctz_i32(var$3 | 0) | 0;
      i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
      if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
       i64toi32_i32$1 = 0;
       $42 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
      } else {
       i64toi32_i32$1 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
       $42 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$2 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$3 >>> i64toi32_i32$4 | 0) | 0;
      }
      i64toi32_i32$3 = $42;
      i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
      return i64toi32_i32$3 | 0;
     }
     var$3 = 63 - var$2 | 0;
     var$2 = var$2 + 1 | 0;
    }
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$3 = 0;
    $129$hi = i64toi32_i32$3;
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$2 = var$0;
    i64toi32_i32$1 = $129$hi;
    i64toi32_i32$0 = var$2 & 63 | 0;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$1 = 0;
     $43 = i64toi32_i32$3 >>> i64toi32_i32$4 | 0;
    } else {
     i64toi32_i32$1 = i64toi32_i32$3 >>> i64toi32_i32$4 | 0;
     $43 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$3 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
    }
    var$5 = $43;
    var$5$hi = i64toi32_i32$1;
    i64toi32_i32$1 = var$0$hi;
    i64toi32_i32$1 = 0;
    $134$hi = i64toi32_i32$1;
    i64toi32_i32$1 = var$0$hi;
    i64toi32_i32$3 = var$0;
    i64toi32_i32$2 = $134$hi;
    i64toi32_i32$0 = var$3 & 63 | 0;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$2 = i64toi32_i32$3 << i64toi32_i32$4 | 0;
     $44 = 0;
    } else {
     i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$3 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
     $44 = i64toi32_i32$3 << i64toi32_i32$4 | 0;
    }
    var$0 = $44;
    var$0$hi = i64toi32_i32$2;
    label$13 : {
     if (var$2) {
      block3 : {
       i64toi32_i32$2 = var$1$hi;
       i64toi32_i32$1 = var$1;
       i64toi32_i32$3 = -1;
       i64toi32_i32$0 = -1;
       i64toi32_i32$4 = i64toi32_i32$1 + i64toi32_i32$0 | 0;
       i64toi32_i32$5 = i64toi32_i32$2 + i64toi32_i32$3 | 0;
       if (i64toi32_i32$4 >>> 0 < i64toi32_i32$0 >>> 0) {
        i64toi32_i32$5 = i64toi32_i32$5 + 1 | 0
       }
       var$8 = i64toi32_i32$4;
       var$8$hi = i64toi32_i32$5;
       label$15 : while (1) {
        i64toi32_i32$5 = var$5$hi;
        i64toi32_i32$2 = var$5;
        i64toi32_i32$1 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$3 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$3 | 0;
         $45 = 0;
        } else {
         i64toi32_i32$1 = ((1 << i64toi32_i32$3 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$3 | 0) | 0) | 0 | (i64toi32_i32$5 << i64toi32_i32$3 | 0) | 0;
         $45 = i64toi32_i32$2 << i64toi32_i32$3 | 0;
        }
        $140 = $45;
        $140$hi = i64toi32_i32$1;
        i64toi32_i32$1 = var$0$hi;
        i64toi32_i32$5 = var$0;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 63;
        i64toi32_i32$3 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = 0;
         $46 = i64toi32_i32$1 >>> i64toi32_i32$3 | 0;
        } else {
         i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$3 | 0;
         $46 = (((1 << i64toi32_i32$3 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$3 | 0) | 0 | (i64toi32_i32$5 >>> i64toi32_i32$3 | 0) | 0;
        }
        $142$hi = i64toi32_i32$2;
        i64toi32_i32$2 = $140$hi;
        i64toi32_i32$1 = $140;
        i64toi32_i32$5 = $142$hi;
        i64toi32_i32$0 = $46;
        i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
        var$5 = i64toi32_i32$1 | i64toi32_i32$0 | 0;
        var$5$hi = i64toi32_i32$5;
        $144 = var$5;
        $144$hi = i64toi32_i32$5;
        i64toi32_i32$5 = var$8$hi;
        i64toi32_i32$5 = var$5$hi;
        i64toi32_i32$5 = var$8$hi;
        i64toi32_i32$2 = var$8;
        i64toi32_i32$1 = var$5$hi;
        i64toi32_i32$0 = var$5;
        i64toi32_i32$3 = i64toi32_i32$2 - i64toi32_i32$0 | 0;
        i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$0 >>> 0;
        i64toi32_i32$4 = i64toi32_i32$6 + i64toi32_i32$1 | 0;
        i64toi32_i32$4 = i64toi32_i32$5 - i64toi32_i32$4 | 0;
        i64toi32_i32$5 = i64toi32_i32$3;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 63;
        i64toi32_i32$1 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = i64toi32_i32$4 >> 31 | 0;
         $47 = i64toi32_i32$4 >> i64toi32_i32$1 | 0;
        } else {
         i64toi32_i32$2 = i64toi32_i32$4 >> i64toi32_i32$1 | 0;
         $47 = (((1 << i64toi32_i32$1 | 0) - 1 | 0) & i64toi32_i32$4 | 0) << (32 - i64toi32_i32$1 | 0) | 0 | (i64toi32_i32$5 >>> i64toi32_i32$1 | 0) | 0;
        }
        var$6 = $47;
        var$6$hi = i64toi32_i32$2;
        i64toi32_i32$2 = var$1$hi;
        i64toi32_i32$2 = var$6$hi;
        i64toi32_i32$4 = var$6;
        i64toi32_i32$5 = var$1$hi;
        i64toi32_i32$0 = var$1;
        i64toi32_i32$5 = i64toi32_i32$2 & i64toi32_i32$5 | 0;
        $151 = i64toi32_i32$4 & i64toi32_i32$0 | 0;
        $151$hi = i64toi32_i32$5;
        i64toi32_i32$5 = $144$hi;
        i64toi32_i32$2 = $144;
        i64toi32_i32$4 = $151$hi;
        i64toi32_i32$0 = $151;
        i64toi32_i32$1 = i64toi32_i32$2 - i64toi32_i32$0 | 0;
        i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$0 >>> 0;
        i64toi32_i32$3 = i64toi32_i32$6 + i64toi32_i32$4 | 0;
        i64toi32_i32$3 = i64toi32_i32$5 - i64toi32_i32$3 | 0;
        var$5 = i64toi32_i32$1;
        var$5$hi = i64toi32_i32$3;
        i64toi32_i32$3 = var$0$hi;
        i64toi32_i32$5 = var$0;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
         $48 = 0;
        } else {
         i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$5 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
         $48 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
        }
        $154$hi = i64toi32_i32$2;
        i64toi32_i32$2 = var$7$hi;
        i64toi32_i32$2 = $154$hi;
        i64toi32_i32$3 = $48;
        i64toi32_i32$5 = var$7$hi;
        i64toi32_i32$0 = var$7;
        i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
        var$0 = i64toi32_i32$3 | i64toi32_i32$0 | 0;
        var$0$hi = i64toi32_i32$5;
        i64toi32_i32$5 = var$6$hi;
        i64toi32_i32$2 = var$6;
        i64toi32_i32$3 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$3 = i64toi32_i32$5 & i64toi32_i32$3 | 0;
        var$6 = i64toi32_i32$2 & i64toi32_i32$0 | 0;
        var$6$hi = i64toi32_i32$3;
        var$7 = var$6;
        var$7$hi = i64toi32_i32$3;
        var$2 = var$2 + -1 | 0;
        if (var$2) {
         continue label$15
        }
        break label$15;
       };
       break label$13;
      }
     }
    }
    i64toi32_i32$3 = var$5$hi;
    legalfunc$wasm2js_scratch_store_i64(var$5 | 0, i64toi32_i32$3 | 0);
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$5 = var$0;
    i64toi32_i32$2 = 0;
    i64toi32_i32$0 = 1;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$2 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
     $49 = 0;
    } else {
     i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$5 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
     $49 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
    }
    $165$hi = i64toi32_i32$2;
    i64toi32_i32$2 = var$6$hi;
    i64toi32_i32$2 = $165$hi;
    i64toi32_i32$3 = $49;
    i64toi32_i32$5 = var$6$hi;
    i64toi32_i32$0 = var$6;
    i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
    i64toi32_i32$3 = i64toi32_i32$3 | i64toi32_i32$0 | 0;
    i64toi32_i32$HIGH_BITS = i64toi32_i32$5;
    return i64toi32_i32$3 | 0;
   }
   i64toi32_i32$3 = var$0$hi;
   legalfunc$wasm2js_scratch_store_i64(var$0 | 0, i64toi32_i32$3 | 0);
   i64toi32_i32$3 = 0;
   var$0 = 0;
   var$0$hi = i64toi32_i32$3;
  }
  i64toi32_i32$3 = var$0$hi;
  i64toi32_i32$5 = var$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$3;
  return i64toi32_i32$5 | 0;
 }
 
 function __wasm_i64_udiv(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function __wasm_ctz_i32(var$0) {
  var$0 = var$0 | 0;
  if (var$0) {
   return 31 - Math_clz32((var$0 + -1 | 0) ^ var$0 | 0) | 0 | 0
  }
  return 32 | 0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "i32_no_fold_div_s_2": $0, 
  "i64_no_fold_div_s_2": legalstub$1
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0},memasmFunc);
export var i32_no_fold_div_s_2 = retasmFunc.i32_no_fold_div_s_2;
export var i64_no_fold_div_s_2 = retasmFunc.i64_no_fold_div_s_2;
import { setTempRet0 } from 'env';
import { getTempRet0 } from 'env';


  var scratchBuffer = new ArrayBuffer(8);
  var i32ScratchView = new Int32Array(scratchBuffer);
  var f32ScratchView = new Float32Array(scratchBuffer);
  var f64ScratchView = new Float64Array(scratchBuffer);
  
  function legalimport$wasm2js_scratch_load_i64() {
    if (typeof setTempRet0 === 'function') setTempRet0(i32ScratchView[1]);
    return i32ScratchView[0];
  }
      
  function legalimport$wasm2js_scratch_store_i64(low, high) {
    i32ScratchView[0] = low;
    i32ScratchView[1] = high;
  }
      
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
 var getTempRet0 = env.getTempRet0;
 var i64toi32_i32$HIGH_BITS = 0;
 function $0(x) {
  x = x | 0;
  return (x | 0) % (2 | 0) | 0 | 0;
 }
 
 function $1(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$1 = 0;
  i64toi32_i32$1 = __wasm_i64_srem(x | 0, i64toi32_i32$0 | 0, 2 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function legalstub$1($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $12 = 0, $13 = 0, $4 = 0, $4$hi = 0, $7$hi = 0, $2 = 0, $2$hi = 0;
  i64toi32_i32$0 = 0;
  $4 = $0_1;
  $4$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $12 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $12 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $7$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $4$hi;
  i64toi32_i32$0 = $4;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$3 = $12;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$2 = $1(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $2 = i64toi32_i32$2;
  $2$hi = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $13 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $13 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$1 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($13 | 0);
  i64toi32_i32$2 = $2$hi;
  return $2 | 0;
 }
 
 function legalfunc$wasm2js_scratch_load_i64() {
  var i64toi32_i32$0 = 0, i64toi32_i32$2 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $8 = 0, $1_1 = 0, $1$hi = 0, $4$hi = 0;
  i64toi32_i32$0 = 0;
  $1_1 = legalimport$wasm2js_scratch_load_i64() | 0;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = getTempRet0() | 0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $8 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $8 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $4$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $1$hi;
  i64toi32_i32$0 = $1_1;
  i64toi32_i32$2 = $4$hi;
  i64toi32_i32$3 = $8;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$0 = i64toi32_i32$0 | i64toi32_i32$3 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$2;
  return i64toi32_i32$0 | 0;
 }
 
 function legalfunc$wasm2js_scratch_store_i64($0_1, $0$hi) {
  $0_1 = $0_1 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8 = 0, $2 = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $0$hi;
  $2 = $0_1;
  i64toi32_i32$2 = $0_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = 0;
   $8 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $8 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  legalimport$wasm2js_scratch_store_i64($2 | 0, $8 | 0);
 }
 
 function _ZN17compiler_builtins3int4sdiv3Mod4mod_17h2cbb7bbf36e41d68E(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$3 = 0, i64toi32_i32$5 = 0, var$2$hi = 0, i64toi32_i32$6 = 0, var$2 = 0, $20 = 0, $21 = 0, $7$hi = 0, $9 = 0, $9$hi = 0, $14$hi = 0, $16$hi = 0, $17$hi = 0, $19$hi = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$2 = var$0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
   $20 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
   $20 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  var$2 = $20;
  var$2$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$0 = var$2;
  i64toi32_i32$2 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$2 | 0;
  $7$hi = i64toi32_i32$2;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$1 = i64toi32_i32$0 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$0 = var$2$hi;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$4 = i64toi32_i32$1 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$5 = i64toi32_i32$6 + i64toi32_i32$0 | 0;
  i64toi32_i32$5 = i64toi32_i32$2 - i64toi32_i32$5 | 0;
  $9 = i64toi32_i32$4;
  $9$hi = i64toi32_i32$5;
  i64toi32_i32$5 = var$1$hi;
  i64toi32_i32$2 = var$1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$0 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$5 >> 31 | 0;
   $21 = i64toi32_i32$5 >> i64toi32_i32$0 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$5 >> i64toi32_i32$0 | 0;
   $21 = (((1 << i64toi32_i32$0 | 0) - 1 | 0) & i64toi32_i32$5 | 0) << (32 - i64toi32_i32$0 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$0 | 0) | 0;
  }
  var$0 = $21;
  var$0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$5 = var$0;
  i64toi32_i32$2 = var$1$hi;
  i64toi32_i32$3 = var$1;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$2 | 0;
  $14$hi = i64toi32_i32$2;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$2 = $14$hi;
  i64toi32_i32$1 = i64toi32_i32$5 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$5 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$0 = i64toi32_i32$1 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$4 = i64toi32_i32$6 + i64toi32_i32$5 | 0;
  i64toi32_i32$4 = i64toi32_i32$2 - i64toi32_i32$4 | 0;
  $16$hi = i64toi32_i32$4;
  i64toi32_i32$4 = $9$hi;
  i64toi32_i32$1 = $16$hi;
  i64toi32_i32$1 = __wasm_i64_urem($9 | 0, i64toi32_i32$4 | 0, i64toi32_i32$0 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$4 = i64toi32_i32$HIGH_BITS;
  $17$hi = i64toi32_i32$4;
  i64toi32_i32$4 = var$2$hi;
  i64toi32_i32$4 = $17$hi;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$1 = i64toi32_i32$4 ^ i64toi32_i32$1 | 0;
  $19$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$1 = $19$hi;
  i64toi32_i32$4 = i64toi32_i32$2 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$2 = var$2$hi;
  i64toi32_i32$5 = i64toi32_i32$4 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$4 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$0 = i64toi32_i32$6 + i64toi32_i32$2 | 0;
  i64toi32_i32$0 = i64toi32_i32$1 - i64toi32_i32$0 | 0;
  i64toi32_i32$4 = i64toi32_i32$5;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$4 | 0;
 }
 
 function __wasm_i64_srem(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int4sdiv3Mod4mod_17h2cbb7bbf36e41d68E(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$5 = 0, var$2 = 0, var$3 = 0, var$4 = 0, var$5 = 0, var$5$hi = 0, var$6 = 0, var$6$hi = 0, i64toi32_i32$6 = 0, $37 = 0, $38 = 0, $39 = 0, $40 = 0, $41 = 0, $42 = 0, $43 = 0, $44 = 0, var$8$hi = 0, $45 = 0, $46 = 0, $47 = 0, $48 = 0, var$7$hi = 0, $49 = 0, $63$hi = 0, $65 = 0, $65$hi = 0, $120$hi = 0, $129$hi = 0, $134$hi = 0, var$8 = 0, $140 = 0, $140$hi = 0, $142$hi = 0, $144 = 0, $144$hi = 0, $151 = 0, $151$hi = 0, $154$hi = 0, var$7 = 0, $165$hi = 0;
  label$1 : {
   label$2 : {
    label$3 : {
     label$4 : {
      label$5 : {
       label$6 : {
        label$7 : {
         label$8 : {
          label$9 : {
           label$10 : {
            label$11 : {
             i64toi32_i32$0 = var$0$hi;
             i64toi32_i32$2 = var$0;
             i64toi32_i32$1 = 0;
             i64toi32_i32$3 = 32;
             i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
             if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
              i64toi32_i32$1 = 0;
              $37 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
             } else {
              i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
              $37 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
             }
             var$2 = $37;
             if (var$2) {
              block : {
               i64toi32_i32$1 = var$1$hi;
               var$3 = var$1;
               if (!var$3) {
                break label$11
               }
               i64toi32_i32$1 = var$1$hi;
               i64toi32_i32$0 = var$1;
               i64toi32_i32$2 = 0;
               i64toi32_i32$3 = 32;
               i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
               if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
                i64toi32_i32$2 = 0;
                $38 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
               } else {
                i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
                $38 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$0 >>> i64toi32_i32$4 | 0) | 0;
               }
               var$4 = $38;
               if (!var$4) {
                break label$9
               }
               var$2 = Math_clz32(var$4) - Math_clz32(var$2) | 0;
               if (var$2 >>> 0 <= 31 >>> 0) {
                break label$8
               }
               break label$2;
              }
             }
             i64toi32_i32$2 = var$1$hi;
             i64toi32_i32$1 = var$1;
             i64toi32_i32$0 = 1;
             i64toi32_i32$3 = 0;
             if (i64toi32_i32$2 >>> 0 > i64toi32_i32$0 >>> 0 | ((i64toi32_i32$2 | 0) == (i64toi32_i32$0 | 0) & i64toi32_i32$1 >>> 0 >= i64toi32_i32$3 >>> 0 | 0) | 0) {
              break label$2
             }
             i64toi32_i32$1 = var$0$hi;
             var$2 = var$0;
             i64toi32_i32$1 = var$1$hi;
             var$3 = var$1;
             var$2 = (var$2 >>> 0) / (var$3 >>> 0) | 0;
             i64toi32_i32$1 = 0;
             legalfunc$wasm2js_scratch_store_i64(var$0 - Math_imul(var$2, var$3) | 0 | 0, i64toi32_i32$1 | 0);
             i64toi32_i32$1 = 0;
             i64toi32_i32$2 = var$2;
             i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
             return i64toi32_i32$2 | 0;
            }
            i64toi32_i32$2 = var$1$hi;
            i64toi32_i32$3 = var$1;
            i64toi32_i32$1 = 0;
            i64toi32_i32$0 = 32;
            i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
            if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
             i64toi32_i32$1 = 0;
             $39 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
            } else {
             i64toi32_i32$1 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
             $39 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$2 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$3 >>> i64toi32_i32$4 | 0) | 0;
            }
            var$3 = $39;
            i64toi32_i32$1 = var$0$hi;
            if (!var$0) {
             break label$7
            }
            if (!var$3) {
             break label$6
            }
            var$4 = var$3 + -1 | 0;
            if (var$4 & var$3 | 0) {
             break label$6
            }
            i64toi32_i32$1 = 0;
            i64toi32_i32$2 = var$4 & var$2 | 0;
            i64toi32_i32$3 = 0;
            i64toi32_i32$0 = 32;
            i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
            if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
             i64toi32_i32$3 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
             $40 = 0;
            } else {
             i64toi32_i32$3 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
             $40 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
            }
            $63$hi = i64toi32_i32$3;
            i64toi32_i32$3 = var$0$hi;
            i64toi32_i32$1 = var$0;
            i64toi32_i32$2 = 0;
            i64toi32_i32$0 = -1;
            i64toi32_i32$2 = i64toi32_i32$3 & i64toi32_i32$2 | 0;
            $65 = i64toi32_i32$1 & i64toi32_i32$0 | 0;
            $65$hi = i64toi32_i32$2;
            i64toi32_i32$2 = $63$hi;
            i64toi32_i32$3 = $40;
            i64toi32_i32$1 = $65$hi;
            i64toi32_i32$0 = $65;
            i64toi32_i32$1 = i64toi32_i32$2 | i64toi32_i32$1 | 0;
            legalfunc$wasm2js_scratch_store_i64(i64toi32_i32$3 | i64toi32_i32$0 | 0 | 0, i64toi32_i32$1 | 0);
            i64toi32_i32$1 = 0;
            i64toi32_i32$3 = var$2 >>> ((__wasm_ctz_i32(var$3 | 0) | 0) & 31 | 0) | 0;
            i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
            return i64toi32_i32$3 | 0;
           }
          }
          var$4 = var$3 + -1 | 0;
          if (!(var$4 & var$3 | 0)) {
           break label$5
          }
          var$2 = (Math_clz32(var$3) + 33 | 0) - Math_clz32(var$2) | 0;
          var$3 = 0 - var$2 | 0;
          break label$3;
         }
         var$3 = 63 - var$2 | 0;
         var$2 = var$2 + 1 | 0;
         break label$3;
        }
        var$4 = (var$2 >>> 0) / (var$3 >>> 0) | 0;
        i64toi32_i32$3 = 0;
        i64toi32_i32$2 = var$2 - Math_imul(var$4, var$3) | 0;
        i64toi32_i32$1 = 0;
        i64toi32_i32$0 = 32;
        i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
         $41 = 0;
        } else {
         i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
         $41 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
        }
        legalfunc$wasm2js_scratch_store_i64($41 | 0, i64toi32_i32$1 | 0);
        i64toi32_i32$1 = 0;
        i64toi32_i32$2 = var$4;
        i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
        return i64toi32_i32$2 | 0;
       }
       var$2 = Math_clz32(var$3) - Math_clz32(var$2) | 0;
       if (var$2 >>> 0 < 31 >>> 0) {
        break label$4
       }
       break label$2;
      }
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$2 = 0;
      legalfunc$wasm2js_scratch_store_i64(var$4 & var$0 | 0 | 0, i64toi32_i32$2 | 0);
      if ((var$3 | 0) == (1 | 0)) {
       break label$1
      }
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$2 = 0;
      $120$hi = i64toi32_i32$2;
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$3 = var$0;
      i64toi32_i32$1 = $120$hi;
      i64toi32_i32$0 = __wasm_ctz_i32(var$3 | 0) | 0;
      i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
      if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
       i64toi32_i32$1 = 0;
       $42 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
      } else {
       i64toi32_i32$1 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
       $42 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$2 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$3 >>> i64toi32_i32$4 | 0) | 0;
      }
      i64toi32_i32$3 = $42;
      i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
      return i64toi32_i32$3 | 0;
     }
     var$3 = 63 - var$2 | 0;
     var$2 = var$2 + 1 | 0;
    }
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$3 = 0;
    $129$hi = i64toi32_i32$3;
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$2 = var$0;
    i64toi32_i32$1 = $129$hi;
    i64toi32_i32$0 = var$2 & 63 | 0;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$1 = 0;
     $43 = i64toi32_i32$3 >>> i64toi32_i32$4 | 0;
    } else {
     i64toi32_i32$1 = i64toi32_i32$3 >>> i64toi32_i32$4 | 0;
     $43 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$3 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
    }
    var$5 = $43;
    var$5$hi = i64toi32_i32$1;
    i64toi32_i32$1 = var$0$hi;
    i64toi32_i32$1 = 0;
    $134$hi = i64toi32_i32$1;
    i64toi32_i32$1 = var$0$hi;
    i64toi32_i32$3 = var$0;
    i64toi32_i32$2 = $134$hi;
    i64toi32_i32$0 = var$3 & 63 | 0;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$2 = i64toi32_i32$3 << i64toi32_i32$4 | 0;
     $44 = 0;
    } else {
     i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$3 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
     $44 = i64toi32_i32$3 << i64toi32_i32$4 | 0;
    }
    var$0 = $44;
    var$0$hi = i64toi32_i32$2;
    label$13 : {
     if (var$2) {
      block3 : {
       i64toi32_i32$2 = var$1$hi;
       i64toi32_i32$1 = var$1;
       i64toi32_i32$3 = -1;
       i64toi32_i32$0 = -1;
       i64toi32_i32$4 = i64toi32_i32$1 + i64toi32_i32$0 | 0;
       i64toi32_i32$5 = i64toi32_i32$2 + i64toi32_i32$3 | 0;
       if (i64toi32_i32$4 >>> 0 < i64toi32_i32$0 >>> 0) {
        i64toi32_i32$5 = i64toi32_i32$5 + 1 | 0
       }
       var$8 = i64toi32_i32$4;
       var$8$hi = i64toi32_i32$5;
       label$15 : while (1) {
        i64toi32_i32$5 = var$5$hi;
        i64toi32_i32$2 = var$5;
        i64toi32_i32$1 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$3 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$3 | 0;
         $45 = 0;
        } else {
         i64toi32_i32$1 = ((1 << i64toi32_i32$3 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$3 | 0) | 0) | 0 | (i64toi32_i32$5 << i64toi32_i32$3 | 0) | 0;
         $45 = i64toi32_i32$2 << i64toi32_i32$3 | 0;
        }
        $140 = $45;
        $140$hi = i64toi32_i32$1;
        i64toi32_i32$1 = var$0$hi;
        i64toi32_i32$5 = var$0;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 63;
        i64toi32_i32$3 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = 0;
         $46 = i64toi32_i32$1 >>> i64toi32_i32$3 | 0;
        } else {
         i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$3 | 0;
         $46 = (((1 << i64toi32_i32$3 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$3 | 0) | 0 | (i64toi32_i32$5 >>> i64toi32_i32$3 | 0) | 0;
        }
        $142$hi = i64toi32_i32$2;
        i64toi32_i32$2 = $140$hi;
        i64toi32_i32$1 = $140;
        i64toi32_i32$5 = $142$hi;
        i64toi32_i32$0 = $46;
        i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
        var$5 = i64toi32_i32$1 | i64toi32_i32$0 | 0;
        var$5$hi = i64toi32_i32$5;
        $144 = var$5;
        $144$hi = i64toi32_i32$5;
        i64toi32_i32$5 = var$8$hi;
        i64toi32_i32$5 = var$5$hi;
        i64toi32_i32$5 = var$8$hi;
        i64toi32_i32$2 = var$8;
        i64toi32_i32$1 = var$5$hi;
        i64toi32_i32$0 = var$5;
        i64toi32_i32$3 = i64toi32_i32$2 - i64toi32_i32$0 | 0;
        i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$0 >>> 0;
        i64toi32_i32$4 = i64toi32_i32$6 + i64toi32_i32$1 | 0;
        i64toi32_i32$4 = i64toi32_i32$5 - i64toi32_i32$4 | 0;
        i64toi32_i32$5 = i64toi32_i32$3;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 63;
        i64toi32_i32$1 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = i64toi32_i32$4 >> 31 | 0;
         $47 = i64toi32_i32$4 >> i64toi32_i32$1 | 0;
        } else {
         i64toi32_i32$2 = i64toi32_i32$4 >> i64toi32_i32$1 | 0;
         $47 = (((1 << i64toi32_i32$1 | 0) - 1 | 0) & i64toi32_i32$4 | 0) << (32 - i64toi32_i32$1 | 0) | 0 | (i64toi32_i32$5 >>> i64toi32_i32$1 | 0) | 0;
        }
        var$6 = $47;
        var$6$hi = i64toi32_i32$2;
        i64toi32_i32$2 = var$1$hi;
        i64toi32_i32$2 = var$6$hi;
        i64toi32_i32$4 = var$6;
        i64toi32_i32$5 = var$1$hi;
        i64toi32_i32$0 = var$1;
        i64toi32_i32$5 = i64toi32_i32$2 & i64toi32_i32$5 | 0;
        $151 = i64toi32_i32$4 & i64toi32_i32$0 | 0;
        $151$hi = i64toi32_i32$5;
        i64toi32_i32$5 = $144$hi;
        i64toi32_i32$2 = $144;
        i64toi32_i32$4 = $151$hi;
        i64toi32_i32$0 = $151;
        i64toi32_i32$1 = i64toi32_i32$2 - i64toi32_i32$0 | 0;
        i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$0 >>> 0;
        i64toi32_i32$3 = i64toi32_i32$6 + i64toi32_i32$4 | 0;
        i64toi32_i32$3 = i64toi32_i32$5 - i64toi32_i32$3 | 0;
        var$5 = i64toi32_i32$1;
        var$5$hi = i64toi32_i32$3;
        i64toi32_i32$3 = var$0$hi;
        i64toi32_i32$5 = var$0;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
         $48 = 0;
        } else {
         i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$5 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
         $48 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
        }
        $154$hi = i64toi32_i32$2;
        i64toi32_i32$2 = var$7$hi;
        i64toi32_i32$2 = $154$hi;
        i64toi32_i32$3 = $48;
        i64toi32_i32$5 = var$7$hi;
        i64toi32_i32$0 = var$7;
        i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
        var$0 = i64toi32_i32$3 | i64toi32_i32$0 | 0;
        var$0$hi = i64toi32_i32$5;
        i64toi32_i32$5 = var$6$hi;
        i64toi32_i32$2 = var$6;
        i64toi32_i32$3 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$3 = i64toi32_i32$5 & i64toi32_i32$3 | 0;
        var$6 = i64toi32_i32$2 & i64toi32_i32$0 | 0;
        var$6$hi = i64toi32_i32$3;
        var$7 = var$6;
        var$7$hi = i64toi32_i32$3;
        var$2 = var$2 + -1 | 0;
        if (var$2) {
         continue label$15
        }
        break label$15;
       };
       break label$13;
      }
     }
    }
    i64toi32_i32$3 = var$5$hi;
    legalfunc$wasm2js_scratch_store_i64(var$5 | 0, i64toi32_i32$3 | 0);
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$5 = var$0;
    i64toi32_i32$2 = 0;
    i64toi32_i32$0 = 1;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$2 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
     $49 = 0;
    } else {
     i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$5 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
     $49 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
    }
    $165$hi = i64toi32_i32$2;
    i64toi32_i32$2 = var$6$hi;
    i64toi32_i32$2 = $165$hi;
    i64toi32_i32$3 = $49;
    i64toi32_i32$5 = var$6$hi;
    i64toi32_i32$0 = var$6;
    i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
    i64toi32_i32$3 = i64toi32_i32$3 | i64toi32_i32$0 | 0;
    i64toi32_i32$HIGH_BITS = i64toi32_i32$5;
    return i64toi32_i32$3 | 0;
   }
   i64toi32_i32$3 = var$0$hi;
   legalfunc$wasm2js_scratch_store_i64(var$0 | 0, i64toi32_i32$3 | 0);
   i64toi32_i32$3 = 0;
   var$0 = 0;
   var$0$hi = i64toi32_i32$3;
  }
  i64toi32_i32$3 = var$0$hi;
  i64toi32_i32$5 = var$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$3;
  return i64toi32_i32$5 | 0;
 }
 
 function __wasm_i64_urem(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$0 = legalfunc$wasm2js_scratch_load_i64() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function __wasm_ctz_i32(var$0) {
  var$0 = var$0 | 0;
  if (var$0) {
   return 31 - Math_clz32((var$0 + -1 | 0) ^ var$0 | 0) | 0 | 0
  }
  return 32 | 0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "i32_no_fold_rem_s_2": $0, 
  "i64_no_fold_rem_s_2": legalstub$1
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0,getTempRet0},memasmFunc);
export var i32_no_fold_rem_s_2 = retasmFunc.i32_no_fold_rem_s_2;
export var i64_no_fold_rem_s_2 = retasmFunc.i64_no_fold_rem_s_2;
import { setTempRet0 } from 'env';


  var scratchBuffer = new ArrayBuffer(8);
  var i32ScratchView = new Int32Array(scratchBuffer);
  var f32ScratchView = new Float32Array(scratchBuffer);
  var f64ScratchView = new Float64Array(scratchBuffer);
  
  function legalimport$wasm2js_scratch_store_i64(low, high) {
    i32ScratchView[0] = low;
    i32ScratchView[1] = high;
  }
      
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
 function $0(x) {
  x = x | 0;
  return (x | 0) / (0 | 0) | 0 | 0;
 }
 
 function $1(x) {
  x = x | 0;
  return (x >>> 0) / (0 >>> 0) | 0 | 0;
 }
 
 function $2(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$1 = 0;
  i64toi32_i32$1 = __wasm_i64_sdiv(x | 0, i64toi32_i32$0 | 0, 0 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $3(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$1 = 0;
  i64toi32_i32$1 = __wasm_i64_udiv(x | 0, i64toi32_i32$0 | 0, 0 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function legalstub$2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $12 = 0, $13 = 0, $4 = 0, $4$hi = 0, $7$hi = 0, $2_1 = 0, $2$hi = 0;
  i64toi32_i32$0 = 0;
  $4 = $0_1;
  $4$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $12 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $12 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $7$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $4$hi;
  i64toi32_i32$0 = $4;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$3 = $12;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$2 = $2(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $2_1 = i64toi32_i32$2;
  $2$hi = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $13 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $13 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$1 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($13 | 0);
  i64toi32_i32$2 = $2$hi;
  return $2_1 | 0;
 }
 
 function legalstub$3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $12 = 0, $13 = 0, $4 = 0, $4$hi = 0, $7$hi = 0, $2_1 = 0, $2$hi = 0;
  i64toi32_i32$0 = 0;
  $4 = $0_1;
  $4$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $12 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $12 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $7$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $4$hi;
  i64toi32_i32$0 = $4;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$3 = $12;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$2 = $3(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $2_1 = i64toi32_i32$2;
  $2$hi = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $13 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $13 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$1 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($13 | 0);
  i64toi32_i32$2 = $2$hi;
  return $2_1 | 0;
 }
 
 function legalfunc$wasm2js_scratch_store_i64($0_1, $0$hi) {
  $0_1 = $0_1 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8 = 0, $2_1 = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $0$hi;
  $2_1 = $0_1;
  i64toi32_i32$2 = $0_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = 0;
   $8 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $8 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  legalimport$wasm2js_scratch_store_i64($2_1 | 0, $8 | 0);
 }
 
 function _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$1 = 0, i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, i64toi32_i32$0 = 0, i64toi32_i32$5 = 0, var$2 = 0, var$2$hi = 0, i64toi32_i32$6 = 0, $21 = 0, $22 = 0, $23 = 0, $7$hi = 0, $9 = 0, $9$hi = 0, $14$hi = 0, $16$hi = 0, $17 = 0, $17$hi = 0, $23$hi = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$2 = var$0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
   $21 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
   $21 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  var$2 = $21;
  var$2$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$0 = var$2;
  i64toi32_i32$2 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$2 | 0;
  $7$hi = i64toi32_i32$2;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$1 = i64toi32_i32$0 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$0 = var$2$hi;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$4 = i64toi32_i32$1 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$5 = i64toi32_i32$6 + i64toi32_i32$0 | 0;
  i64toi32_i32$5 = i64toi32_i32$2 - i64toi32_i32$5 | 0;
  $9 = i64toi32_i32$4;
  $9$hi = i64toi32_i32$5;
  i64toi32_i32$5 = var$1$hi;
  i64toi32_i32$2 = var$1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$0 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$5 >> 31 | 0;
   $22 = i64toi32_i32$5 >> i64toi32_i32$0 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$5 >> i64toi32_i32$0 | 0;
   $22 = (((1 << i64toi32_i32$0 | 0) - 1 | 0) & i64toi32_i32$5 | 0) << (32 - i64toi32_i32$0 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$0 | 0) | 0;
  }
  var$2 = $22;
  var$2$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$5 = var$2;
  i64toi32_i32$2 = var$1$hi;
  i64toi32_i32$3 = var$1;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$2 | 0;
  $14$hi = i64toi32_i32$2;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$2 = $14$hi;
  i64toi32_i32$1 = i64toi32_i32$5 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$5 = var$2$hi;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$0 = i64toi32_i32$1 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$4 = i64toi32_i32$6 + i64toi32_i32$5 | 0;
  i64toi32_i32$4 = i64toi32_i32$2 - i64toi32_i32$4 | 0;
  $16$hi = i64toi32_i32$4;
  i64toi32_i32$4 = $9$hi;
  i64toi32_i32$1 = $16$hi;
  i64toi32_i32$1 = __wasm_i64_udiv($9 | 0, i64toi32_i32$4 | 0, i64toi32_i32$0 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$4 = i64toi32_i32$HIGH_BITS;
  $17 = i64toi32_i32$1;
  $17$hi = i64toi32_i32$4;
  i64toi32_i32$4 = var$1$hi;
  i64toi32_i32$4 = var$0$hi;
  i64toi32_i32$4 = var$1$hi;
  i64toi32_i32$2 = var$1;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$1 = i64toi32_i32$4 ^ i64toi32_i32$1 | 0;
  i64toi32_i32$4 = i64toi32_i32$2 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$5 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = i64toi32_i32$1 >> 31 | 0;
   $23 = i64toi32_i32$1 >> i64toi32_i32$5 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$1 >> i64toi32_i32$5 | 0;
   $23 = (((1 << i64toi32_i32$5 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$5 | 0) | 0 | (i64toi32_i32$4 >>> i64toi32_i32$5 | 0) | 0;
  }
  var$0 = $23;
  var$0$hi = i64toi32_i32$2;
  i64toi32_i32$2 = $17$hi;
  i64toi32_i32$1 = $17;
  i64toi32_i32$4 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$4 = i64toi32_i32$2 ^ i64toi32_i32$4 | 0;
  $23$hi = i64toi32_i32$4;
  i64toi32_i32$4 = var$0$hi;
  i64toi32_i32$4 = $23$hi;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$5 = i64toi32_i32$2 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$0 = i64toi32_i32$6 + i64toi32_i32$1 | 0;
  i64toi32_i32$0 = i64toi32_i32$4 - i64toi32_i32$0 | 0;
  i64toi32_i32$2 = i64toi32_i32$5;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$2 | 0;
 }
 
 function _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$5 = 0, var$2 = 0, var$3 = 0, var$4 = 0, var$5 = 0, var$5$hi = 0, var$6 = 0, var$6$hi = 0, i64toi32_i32$6 = 0, $37 = 0, $38 = 0, $39 = 0, $40 = 0, $41 = 0, $42 = 0, $43 = 0, $44 = 0, var$8$hi = 0, $45 = 0, $46 = 0, $47 = 0, $48 = 0, var$7$hi = 0, $49 = 0, $63$hi = 0, $65 = 0, $65$hi = 0, $120$hi = 0, $129$hi = 0, $134$hi = 0, var$8 = 0, $140 = 0, $140$hi = 0, $142$hi = 0, $144 = 0, $144$hi = 0, $151 = 0, $151$hi = 0, $154$hi = 0, var$7 = 0, $165$hi = 0;
  label$1 : {
   label$2 : {
    label$3 : {
     label$4 : {
      label$5 : {
       label$6 : {
        label$7 : {
         label$8 : {
          label$9 : {
           label$10 : {
            label$11 : {
             i64toi32_i32$0 = var$0$hi;
             i64toi32_i32$2 = var$0;
             i64toi32_i32$1 = 0;
             i64toi32_i32$3 = 32;
             i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
             if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
              i64toi32_i32$1 = 0;
              $37 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
             } else {
              i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
              $37 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
             }
             var$2 = $37;
             if (var$2) {
              block : {
               i64toi32_i32$1 = var$1$hi;
               var$3 = var$1;
               if (!var$3) {
                break label$11
               }
               i64toi32_i32$1 = var$1$hi;
               i64toi32_i32$0 = var$1;
               i64toi32_i32$2 = 0;
               i64toi32_i32$3 = 32;
               i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
               if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
                i64toi32_i32$2 = 0;
                $38 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
               } else {
                i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
                $38 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$0 >>> i64toi32_i32$4 | 0) | 0;
               }
               var$4 = $38;
               if (!var$4) {
                break label$9
               }
               var$2 = Math_clz32(var$4) - Math_clz32(var$2) | 0;
               if (var$2 >>> 0 <= 31 >>> 0) {
                break label$8
               }
               break label$2;
              }
             }
             i64toi32_i32$2 = var$1$hi;
             i64toi32_i32$1 = var$1;
             i64toi32_i32$0 = 1;
             i64toi32_i32$3 = 0;
             if (i64toi32_i32$2 >>> 0 > i64toi32_i32$0 >>> 0 | ((i64toi32_i32$2 | 0) == (i64toi32_i32$0 | 0) & i64toi32_i32$1 >>> 0 >= i64toi32_i32$3 >>> 0 | 0) | 0) {
              break label$2
             }
             i64toi32_i32$1 = var$0$hi;
             var$2 = var$0;
             i64toi32_i32$1 = var$1$hi;
             var$3 = var$1;
             var$2 = (var$2 >>> 0) / (var$3 >>> 0) | 0;
             i64toi32_i32$1 = 0;
             legalfunc$wasm2js_scratch_store_i64(var$0 - Math_imul(var$2, var$3) | 0 | 0, i64toi32_i32$1 | 0);
             i64toi32_i32$1 = 0;
             i64toi32_i32$2 = var$2;
             i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
             return i64toi32_i32$2 | 0;
            }
            i64toi32_i32$2 = var$1$hi;
            i64toi32_i32$3 = var$1;
            i64toi32_i32$1 = 0;
            i64toi32_i32$0 = 32;
            i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
            if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
             i64toi32_i32$1 = 0;
             $39 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
            } else {
             i64toi32_i32$1 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
             $39 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$2 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$3 >>> i64toi32_i32$4 | 0) | 0;
            }
            var$3 = $39;
            i64toi32_i32$1 = var$0$hi;
            if (!var$0) {
             break label$7
            }
            if (!var$3) {
             break label$6
            }
            var$4 = var$3 + -1 | 0;
            if (var$4 & var$3 | 0) {
             break label$6
            }
            i64toi32_i32$1 = 0;
            i64toi32_i32$2 = var$4 & var$2 | 0;
            i64toi32_i32$3 = 0;
            i64toi32_i32$0 = 32;
            i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
            if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
             i64toi32_i32$3 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
             $40 = 0;
            } else {
             i64toi32_i32$3 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
             $40 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
            }
            $63$hi = i64toi32_i32$3;
            i64toi32_i32$3 = var$0$hi;
            i64toi32_i32$1 = var$0;
            i64toi32_i32$2 = 0;
            i64toi32_i32$0 = -1;
            i64toi32_i32$2 = i64toi32_i32$3 & i64toi32_i32$2 | 0;
            $65 = i64toi32_i32$1 & i64toi32_i32$0 | 0;
            $65$hi = i64toi32_i32$2;
            i64toi32_i32$2 = $63$hi;
            i64toi32_i32$3 = $40;
            i64toi32_i32$1 = $65$hi;
            i64toi32_i32$0 = $65;
            i64toi32_i32$1 = i64toi32_i32$2 | i64toi32_i32$1 | 0;
            legalfunc$wasm2js_scratch_store_i64(i64toi32_i32$3 | i64toi32_i32$0 | 0 | 0, i64toi32_i32$1 | 0);
            i64toi32_i32$1 = 0;
            i64toi32_i32$3 = var$2 >>> ((__wasm_ctz_i32(var$3 | 0) | 0) & 31 | 0) | 0;
            i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
            return i64toi32_i32$3 | 0;
           }
          }
          var$4 = var$3 + -1 | 0;
          if (!(var$4 & var$3 | 0)) {
           break label$5
          }
          var$2 = (Math_clz32(var$3) + 33 | 0) - Math_clz32(var$2) | 0;
          var$3 = 0 - var$2 | 0;
          break label$3;
         }
         var$3 = 63 - var$2 | 0;
         var$2 = var$2 + 1 | 0;
         break label$3;
        }
        var$4 = (var$2 >>> 0) / (var$3 >>> 0) | 0;
        i64toi32_i32$3 = 0;
        i64toi32_i32$2 = var$2 - Math_imul(var$4, var$3) | 0;
        i64toi32_i32$1 = 0;
        i64toi32_i32$0 = 32;
        i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
         $41 = 0;
        } else {
         i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
         $41 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
        }
        legalfunc$wasm2js_scratch_store_i64($41 | 0, i64toi32_i32$1 | 0);
        i64toi32_i32$1 = 0;
        i64toi32_i32$2 = var$4;
        i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
        return i64toi32_i32$2 | 0;
       }
       var$2 = Math_clz32(var$3) - Math_clz32(var$2) | 0;
       if (var$2 >>> 0 < 31 >>> 0) {
        break label$4
       }
       break label$2;
      }
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$2 = 0;
      legalfunc$wasm2js_scratch_store_i64(var$4 & var$0 | 0 | 0, i64toi32_i32$2 | 0);
      if ((var$3 | 0) == (1 | 0)) {
       break label$1
      }
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$2 = 0;
      $120$hi = i64toi32_i32$2;
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$3 = var$0;
      i64toi32_i32$1 = $120$hi;
      i64toi32_i32$0 = __wasm_ctz_i32(var$3 | 0) | 0;
      i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
      if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
       i64toi32_i32$1 = 0;
       $42 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
      } else {
       i64toi32_i32$1 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
       $42 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$2 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$3 >>> i64toi32_i32$4 | 0) | 0;
      }
      i64toi32_i32$3 = $42;
      i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
      return i64toi32_i32$3 | 0;
     }
     var$3 = 63 - var$2 | 0;
     var$2 = var$2 + 1 | 0;
    }
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$3 = 0;
    $129$hi = i64toi32_i32$3;
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$2 = var$0;
    i64toi32_i32$1 = $129$hi;
    i64toi32_i32$0 = var$2 & 63 | 0;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$1 = 0;
     $43 = i64toi32_i32$3 >>> i64toi32_i32$4 | 0;
    } else {
     i64toi32_i32$1 = i64toi32_i32$3 >>> i64toi32_i32$4 | 0;
     $43 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$3 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
    }
    var$5 = $43;
    var$5$hi = i64toi32_i32$1;
    i64toi32_i32$1 = var$0$hi;
    i64toi32_i32$1 = 0;
    $134$hi = i64toi32_i32$1;
    i64toi32_i32$1 = var$0$hi;
    i64toi32_i32$3 = var$0;
    i64toi32_i32$2 = $134$hi;
    i64toi32_i32$0 = var$3 & 63 | 0;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$2 = i64toi32_i32$3 << i64toi32_i32$4 | 0;
     $44 = 0;
    } else {
     i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$3 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
     $44 = i64toi32_i32$3 << i64toi32_i32$4 | 0;
    }
    var$0 = $44;
    var$0$hi = i64toi32_i32$2;
    label$13 : {
     if (var$2) {
      block3 : {
       i64toi32_i32$2 = var$1$hi;
       i64toi32_i32$1 = var$1;
       i64toi32_i32$3 = -1;
       i64toi32_i32$0 = -1;
       i64toi32_i32$4 = i64toi32_i32$1 + i64toi32_i32$0 | 0;
       i64toi32_i32$5 = i64toi32_i32$2 + i64toi32_i32$3 | 0;
       if (i64toi32_i32$4 >>> 0 < i64toi32_i32$0 >>> 0) {
        i64toi32_i32$5 = i64toi32_i32$5 + 1 | 0
       }
       var$8 = i64toi32_i32$4;
       var$8$hi = i64toi32_i32$5;
       label$15 : while (1) {
        i64toi32_i32$5 = var$5$hi;
        i64toi32_i32$2 = var$5;
        i64toi32_i32$1 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$3 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$3 | 0;
         $45 = 0;
        } else {
         i64toi32_i32$1 = ((1 << i64toi32_i32$3 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$3 | 0) | 0) | 0 | (i64toi32_i32$5 << i64toi32_i32$3 | 0) | 0;
         $45 = i64toi32_i32$2 << i64toi32_i32$3 | 0;
        }
        $140 = $45;
        $140$hi = i64toi32_i32$1;
        i64toi32_i32$1 = var$0$hi;
        i64toi32_i32$5 = var$0;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 63;
        i64toi32_i32$3 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = 0;
         $46 = i64toi32_i32$1 >>> i64toi32_i32$3 | 0;
        } else {
         i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$3 | 0;
         $46 = (((1 << i64toi32_i32$3 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$3 | 0) | 0 | (i64toi32_i32$5 >>> i64toi32_i32$3 | 0) | 0;
        }
        $142$hi = i64toi32_i32$2;
        i64toi32_i32$2 = $140$hi;
        i64toi32_i32$1 = $140;
        i64toi32_i32$5 = $142$hi;
        i64toi32_i32$0 = $46;
        i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
        var$5 = i64toi32_i32$1 | i64toi32_i32$0 | 0;
        var$5$hi = i64toi32_i32$5;
        $144 = var$5;
        $144$hi = i64toi32_i32$5;
        i64toi32_i32$5 = var$8$hi;
        i64toi32_i32$5 = var$5$hi;
        i64toi32_i32$5 = var$8$hi;
        i64toi32_i32$2 = var$8;
        i64toi32_i32$1 = var$5$hi;
        i64toi32_i32$0 = var$5;
        i64toi32_i32$3 = i64toi32_i32$2 - i64toi32_i32$0 | 0;
        i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$0 >>> 0;
        i64toi32_i32$4 = i64toi32_i32$6 + i64toi32_i32$1 | 0;
        i64toi32_i32$4 = i64toi32_i32$5 - i64toi32_i32$4 | 0;
        i64toi32_i32$5 = i64toi32_i32$3;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 63;
        i64toi32_i32$1 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = i64toi32_i32$4 >> 31 | 0;
         $47 = i64toi32_i32$4 >> i64toi32_i32$1 | 0;
        } else {
         i64toi32_i32$2 = i64toi32_i32$4 >> i64toi32_i32$1 | 0;
         $47 = (((1 << i64toi32_i32$1 | 0) - 1 | 0) & i64toi32_i32$4 | 0) << (32 - i64toi32_i32$1 | 0) | 0 | (i64toi32_i32$5 >>> i64toi32_i32$1 | 0) | 0;
        }
        var$6 = $47;
        var$6$hi = i64toi32_i32$2;
        i64toi32_i32$2 = var$1$hi;
        i64toi32_i32$2 = var$6$hi;
        i64toi32_i32$4 = var$6;
        i64toi32_i32$5 = var$1$hi;
        i64toi32_i32$0 = var$1;
        i64toi32_i32$5 = i64toi32_i32$2 & i64toi32_i32$5 | 0;
        $151 = i64toi32_i32$4 & i64toi32_i32$0 | 0;
        $151$hi = i64toi32_i32$5;
        i64toi32_i32$5 = $144$hi;
        i64toi32_i32$2 = $144;
        i64toi32_i32$4 = $151$hi;
        i64toi32_i32$0 = $151;
        i64toi32_i32$1 = i64toi32_i32$2 - i64toi32_i32$0 | 0;
        i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$0 >>> 0;
        i64toi32_i32$3 = i64toi32_i32$6 + i64toi32_i32$4 | 0;
        i64toi32_i32$3 = i64toi32_i32$5 - i64toi32_i32$3 | 0;
        var$5 = i64toi32_i32$1;
        var$5$hi = i64toi32_i32$3;
        i64toi32_i32$3 = var$0$hi;
        i64toi32_i32$5 = var$0;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
         $48 = 0;
        } else {
         i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$5 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
         $48 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
        }
        $154$hi = i64toi32_i32$2;
        i64toi32_i32$2 = var$7$hi;
        i64toi32_i32$2 = $154$hi;
        i64toi32_i32$3 = $48;
        i64toi32_i32$5 = var$7$hi;
        i64toi32_i32$0 = var$7;
        i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
        var$0 = i64toi32_i32$3 | i64toi32_i32$0 | 0;
        var$0$hi = i64toi32_i32$5;
        i64toi32_i32$5 = var$6$hi;
        i64toi32_i32$2 = var$6;
        i64toi32_i32$3 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$3 = i64toi32_i32$5 & i64toi32_i32$3 | 0;
        var$6 = i64toi32_i32$2 & i64toi32_i32$0 | 0;
        var$6$hi = i64toi32_i32$3;
        var$7 = var$6;
        var$7$hi = i64toi32_i32$3;
        var$2 = var$2 + -1 | 0;
        if (var$2) {
         continue label$15
        }
        break label$15;
       };
       break label$13;
      }
     }
    }
    i64toi32_i32$3 = var$5$hi;
    legalfunc$wasm2js_scratch_store_i64(var$5 | 0, i64toi32_i32$3 | 0);
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$5 = var$0;
    i64toi32_i32$2 = 0;
    i64toi32_i32$0 = 1;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$2 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
     $49 = 0;
    } else {
     i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$5 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
     $49 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
    }
    $165$hi = i64toi32_i32$2;
    i64toi32_i32$2 = var$6$hi;
    i64toi32_i32$2 = $165$hi;
    i64toi32_i32$3 = $49;
    i64toi32_i32$5 = var$6$hi;
    i64toi32_i32$0 = var$6;
    i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
    i64toi32_i32$3 = i64toi32_i32$3 | i64toi32_i32$0 | 0;
    i64toi32_i32$HIGH_BITS = i64toi32_i32$5;
    return i64toi32_i32$3 | 0;
   }
   i64toi32_i32$3 = var$0$hi;
   legalfunc$wasm2js_scratch_store_i64(var$0 | 0, i64toi32_i32$3 | 0);
   i64toi32_i32$3 = 0;
   var$0 = 0;
   var$0$hi = i64toi32_i32$3;
  }
  i64toi32_i32$3 = var$0$hi;
  i64toi32_i32$5 = var$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$3;
  return i64toi32_i32$5 | 0;
 }
 
 function __wasm_i64_sdiv(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function __wasm_i64_udiv(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function __wasm_ctz_i32(var$0) {
  var$0 = var$0 | 0;
  if (var$0) {
   return 31 - Math_clz32((var$0 + -1 | 0) ^ var$0 | 0) | 0 | 0
  }
  return 32 | 0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "i32_div_s_3": $0, 
  "i32_div_u_3": $1, 
  "i64_div_s_3": legalstub$2, 
  "i64_div_u_3": legalstub$3
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0},memasmFunc);
export var i32_div_s_3 = retasmFunc.i32_div_s_3;
export var i32_div_u_3 = retasmFunc.i32_div_u_3;
export var i64_div_s_3 = retasmFunc.i64_div_s_3;
export var i64_div_u_3 = retasmFunc.i64_div_u_3;
import { setTempRet0 } from 'env';


  var scratchBuffer = new ArrayBuffer(8);
  var i32ScratchView = new Int32Array(scratchBuffer);
  var f32ScratchView = new Float32Array(scratchBuffer);
  var f64ScratchView = new Float64Array(scratchBuffer);
  
  function legalimport$wasm2js_scratch_store_i64(low, high) {
    i32ScratchView[0] = low;
    i32ScratchView[1] = high;
  }
      
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
 function $0(x) {
  x = x | 0;
  return (x | 0) / (3 | 0) | 0 | 0;
 }
 
 function $1(x) {
  x = x | 0;
  return (x >>> 0) / (3 >>> 0) | 0 | 0;
 }
 
 function $2(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$1 = 0;
  i64toi32_i32$1 = __wasm_i64_sdiv(x | 0, i64toi32_i32$0 | 0, 3 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $3(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$1 = 0;
  i64toi32_i32$1 = __wasm_i64_udiv(x | 0, i64toi32_i32$0 | 0, 3 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function legalstub$2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $12 = 0, $13 = 0, $4 = 0, $4$hi = 0, $7$hi = 0, $2_1 = 0, $2$hi = 0;
  i64toi32_i32$0 = 0;
  $4 = $0_1;
  $4$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $12 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $12 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $7$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $4$hi;
  i64toi32_i32$0 = $4;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$3 = $12;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$2 = $2(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $2_1 = i64toi32_i32$2;
  $2$hi = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $13 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $13 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$1 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($13 | 0);
  i64toi32_i32$2 = $2$hi;
  return $2_1 | 0;
 }
 
 function legalstub$3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $12 = 0, $13 = 0, $4 = 0, $4$hi = 0, $7$hi = 0, $2_1 = 0, $2$hi = 0;
  i64toi32_i32$0 = 0;
  $4 = $0_1;
  $4$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $12 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $12 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $7$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $4$hi;
  i64toi32_i32$0 = $4;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$3 = $12;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$2 = $3(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $2_1 = i64toi32_i32$2;
  $2$hi = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $13 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $13 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$1 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($13 | 0);
  i64toi32_i32$2 = $2$hi;
  return $2_1 | 0;
 }
 
 function legalfunc$wasm2js_scratch_store_i64($0_1, $0$hi) {
  $0_1 = $0_1 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8 = 0, $2_1 = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $0$hi;
  $2_1 = $0_1;
  i64toi32_i32$2 = $0_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = 0;
   $8 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $8 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  legalimport$wasm2js_scratch_store_i64($2_1 | 0, $8 | 0);
 }
 
 function _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$1 = 0, i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, i64toi32_i32$0 = 0, i64toi32_i32$5 = 0, var$2 = 0, var$2$hi = 0, i64toi32_i32$6 = 0, $21 = 0, $22 = 0, $23 = 0, $7$hi = 0, $9 = 0, $9$hi = 0, $14$hi = 0, $16$hi = 0, $17 = 0, $17$hi = 0, $23$hi = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$2 = var$0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
   $21 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
   $21 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  var$2 = $21;
  var$2$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$0 = var$2;
  i64toi32_i32$2 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$2 | 0;
  $7$hi = i64toi32_i32$2;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$1 = i64toi32_i32$0 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$0 = var$2$hi;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$4 = i64toi32_i32$1 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$5 = i64toi32_i32$6 + i64toi32_i32$0 | 0;
  i64toi32_i32$5 = i64toi32_i32$2 - i64toi32_i32$5 | 0;
  $9 = i64toi32_i32$4;
  $9$hi = i64toi32_i32$5;
  i64toi32_i32$5 = var$1$hi;
  i64toi32_i32$2 = var$1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$0 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$5 >> 31 | 0;
   $22 = i64toi32_i32$5 >> i64toi32_i32$0 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$5 >> i64toi32_i32$0 | 0;
   $22 = (((1 << i64toi32_i32$0 | 0) - 1 | 0) & i64toi32_i32$5 | 0) << (32 - i64toi32_i32$0 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$0 | 0) | 0;
  }
  var$2 = $22;
  var$2$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$5 = var$2;
  i64toi32_i32$2 = var$1$hi;
  i64toi32_i32$3 = var$1;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$2 | 0;
  $14$hi = i64toi32_i32$2;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$2 = $14$hi;
  i64toi32_i32$1 = i64toi32_i32$5 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$5 = var$2$hi;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$0 = i64toi32_i32$1 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$4 = i64toi32_i32$6 + i64toi32_i32$5 | 0;
  i64toi32_i32$4 = i64toi32_i32$2 - i64toi32_i32$4 | 0;
  $16$hi = i64toi32_i32$4;
  i64toi32_i32$4 = $9$hi;
  i64toi32_i32$1 = $16$hi;
  i64toi32_i32$1 = __wasm_i64_udiv($9 | 0, i64toi32_i32$4 | 0, i64toi32_i32$0 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$4 = i64toi32_i32$HIGH_BITS;
  $17 = i64toi32_i32$1;
  $17$hi = i64toi32_i32$4;
  i64toi32_i32$4 = var$1$hi;
  i64toi32_i32$4 = var$0$hi;
  i64toi32_i32$4 = var$1$hi;
  i64toi32_i32$2 = var$1;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$1 = i64toi32_i32$4 ^ i64toi32_i32$1 | 0;
  i64toi32_i32$4 = i64toi32_i32$2 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$5 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = i64toi32_i32$1 >> 31 | 0;
   $23 = i64toi32_i32$1 >> i64toi32_i32$5 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$1 >> i64toi32_i32$5 | 0;
   $23 = (((1 << i64toi32_i32$5 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$5 | 0) | 0 | (i64toi32_i32$4 >>> i64toi32_i32$5 | 0) | 0;
  }
  var$0 = $23;
  var$0$hi = i64toi32_i32$2;
  i64toi32_i32$2 = $17$hi;
  i64toi32_i32$1 = $17;
  i64toi32_i32$4 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$4 = i64toi32_i32$2 ^ i64toi32_i32$4 | 0;
  $23$hi = i64toi32_i32$4;
  i64toi32_i32$4 = var$0$hi;
  i64toi32_i32$4 = $23$hi;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$5 = i64toi32_i32$2 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$0 = i64toi32_i32$6 + i64toi32_i32$1 | 0;
  i64toi32_i32$0 = i64toi32_i32$4 - i64toi32_i32$0 | 0;
  i64toi32_i32$2 = i64toi32_i32$5;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$2 | 0;
 }
 
 function _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$5 = 0, var$2 = 0, var$3 = 0, var$4 = 0, var$5 = 0, var$5$hi = 0, var$6 = 0, var$6$hi = 0, i64toi32_i32$6 = 0, $37 = 0, $38 = 0, $39 = 0, $40 = 0, $41 = 0, $42 = 0, $43 = 0, $44 = 0, var$8$hi = 0, $45 = 0, $46 = 0, $47 = 0, $48 = 0, var$7$hi = 0, $49 = 0, $63$hi = 0, $65 = 0, $65$hi = 0, $120$hi = 0, $129$hi = 0, $134$hi = 0, var$8 = 0, $140 = 0, $140$hi = 0, $142$hi = 0, $144 = 0, $144$hi = 0, $151 = 0, $151$hi = 0, $154$hi = 0, var$7 = 0, $165$hi = 0;
  label$1 : {
   label$2 : {
    label$3 : {
     label$4 : {
      label$5 : {
       label$6 : {
        label$7 : {
         label$8 : {
          label$9 : {
           label$10 : {
            label$11 : {
             i64toi32_i32$0 = var$0$hi;
             i64toi32_i32$2 = var$0;
             i64toi32_i32$1 = 0;
             i64toi32_i32$3 = 32;
             i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
             if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
              i64toi32_i32$1 = 0;
              $37 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
             } else {
              i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
              $37 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
             }
             var$2 = $37;
             if (var$2) {
              block : {
               i64toi32_i32$1 = var$1$hi;
               var$3 = var$1;
               if (!var$3) {
                break label$11
               }
               i64toi32_i32$1 = var$1$hi;
               i64toi32_i32$0 = var$1;
               i64toi32_i32$2 = 0;
               i64toi32_i32$3 = 32;
               i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
               if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
                i64toi32_i32$2 = 0;
                $38 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
               } else {
                i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
                $38 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$0 >>> i64toi32_i32$4 | 0) | 0;
               }
               var$4 = $38;
               if (!var$4) {
                break label$9
               }
               var$2 = Math_clz32(var$4) - Math_clz32(var$2) | 0;
               if (var$2 >>> 0 <= 31 >>> 0) {
                break label$8
               }
               break label$2;
              }
             }
             i64toi32_i32$2 = var$1$hi;
             i64toi32_i32$1 = var$1;
             i64toi32_i32$0 = 1;
             i64toi32_i32$3 = 0;
             if (i64toi32_i32$2 >>> 0 > i64toi32_i32$0 >>> 0 | ((i64toi32_i32$2 | 0) == (i64toi32_i32$0 | 0) & i64toi32_i32$1 >>> 0 >= i64toi32_i32$3 >>> 0 | 0) | 0) {
              break label$2
             }
             i64toi32_i32$1 = var$0$hi;
             var$2 = var$0;
             i64toi32_i32$1 = var$1$hi;
             var$3 = var$1;
             var$2 = (var$2 >>> 0) / (var$3 >>> 0) | 0;
             i64toi32_i32$1 = 0;
             legalfunc$wasm2js_scratch_store_i64(var$0 - Math_imul(var$2, var$3) | 0 | 0, i64toi32_i32$1 | 0);
             i64toi32_i32$1 = 0;
             i64toi32_i32$2 = var$2;
             i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
             return i64toi32_i32$2 | 0;
            }
            i64toi32_i32$2 = var$1$hi;
            i64toi32_i32$3 = var$1;
            i64toi32_i32$1 = 0;
            i64toi32_i32$0 = 32;
            i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
            if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
             i64toi32_i32$1 = 0;
             $39 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
            } else {
             i64toi32_i32$1 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
             $39 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$2 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$3 >>> i64toi32_i32$4 | 0) | 0;
            }
            var$3 = $39;
            i64toi32_i32$1 = var$0$hi;
            if (!var$0) {
             break label$7
            }
            if (!var$3) {
             break label$6
            }
            var$4 = var$3 + -1 | 0;
            if (var$4 & var$3 | 0) {
             break label$6
            }
            i64toi32_i32$1 = 0;
            i64toi32_i32$2 = var$4 & var$2 | 0;
            i64toi32_i32$3 = 0;
            i64toi32_i32$0 = 32;
            i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
            if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
             i64toi32_i32$3 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
             $40 = 0;
            } else {
             i64toi32_i32$3 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
             $40 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
            }
            $63$hi = i64toi32_i32$3;
            i64toi32_i32$3 = var$0$hi;
            i64toi32_i32$1 = var$0;
            i64toi32_i32$2 = 0;
            i64toi32_i32$0 = -1;
            i64toi32_i32$2 = i64toi32_i32$3 & i64toi32_i32$2 | 0;
            $65 = i64toi32_i32$1 & i64toi32_i32$0 | 0;
            $65$hi = i64toi32_i32$2;
            i64toi32_i32$2 = $63$hi;
            i64toi32_i32$3 = $40;
            i64toi32_i32$1 = $65$hi;
            i64toi32_i32$0 = $65;
            i64toi32_i32$1 = i64toi32_i32$2 | i64toi32_i32$1 | 0;
            legalfunc$wasm2js_scratch_store_i64(i64toi32_i32$3 | i64toi32_i32$0 | 0 | 0, i64toi32_i32$1 | 0);
            i64toi32_i32$1 = 0;
            i64toi32_i32$3 = var$2 >>> ((__wasm_ctz_i32(var$3 | 0) | 0) & 31 | 0) | 0;
            i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
            return i64toi32_i32$3 | 0;
           }
          }
          var$4 = var$3 + -1 | 0;
          if (!(var$4 & var$3 | 0)) {
           break label$5
          }
          var$2 = (Math_clz32(var$3) + 33 | 0) - Math_clz32(var$2) | 0;
          var$3 = 0 - var$2 | 0;
          break label$3;
         }
         var$3 = 63 - var$2 | 0;
         var$2 = var$2 + 1 | 0;
         break label$3;
        }
        var$4 = (var$2 >>> 0) / (var$3 >>> 0) | 0;
        i64toi32_i32$3 = 0;
        i64toi32_i32$2 = var$2 - Math_imul(var$4, var$3) | 0;
        i64toi32_i32$1 = 0;
        i64toi32_i32$0 = 32;
        i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
         $41 = 0;
        } else {
         i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
         $41 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
        }
        legalfunc$wasm2js_scratch_store_i64($41 | 0, i64toi32_i32$1 | 0);
        i64toi32_i32$1 = 0;
        i64toi32_i32$2 = var$4;
        i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
        return i64toi32_i32$2 | 0;
       }
       var$2 = Math_clz32(var$3) - Math_clz32(var$2) | 0;
       if (var$2 >>> 0 < 31 >>> 0) {
        break label$4
       }
       break label$2;
      }
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$2 = 0;
      legalfunc$wasm2js_scratch_store_i64(var$4 & var$0 | 0 | 0, i64toi32_i32$2 | 0);
      if ((var$3 | 0) == (1 | 0)) {
       break label$1
      }
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$2 = 0;
      $120$hi = i64toi32_i32$2;
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$3 = var$0;
      i64toi32_i32$1 = $120$hi;
      i64toi32_i32$0 = __wasm_ctz_i32(var$3 | 0) | 0;
      i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
      if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
       i64toi32_i32$1 = 0;
       $42 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
      } else {
       i64toi32_i32$1 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
       $42 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$2 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$3 >>> i64toi32_i32$4 | 0) | 0;
      }
      i64toi32_i32$3 = $42;
      i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
      return i64toi32_i32$3 | 0;
     }
     var$3 = 63 - var$2 | 0;
     var$2 = var$2 + 1 | 0;
    }
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$3 = 0;
    $129$hi = i64toi32_i32$3;
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$2 = var$0;
    i64toi32_i32$1 = $129$hi;
    i64toi32_i32$0 = var$2 & 63 | 0;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$1 = 0;
     $43 = i64toi32_i32$3 >>> i64toi32_i32$4 | 0;
    } else {
     i64toi32_i32$1 = i64toi32_i32$3 >>> i64toi32_i32$4 | 0;
     $43 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$3 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
    }
    var$5 = $43;
    var$5$hi = i64toi32_i32$1;
    i64toi32_i32$1 = var$0$hi;
    i64toi32_i32$1 = 0;
    $134$hi = i64toi32_i32$1;
    i64toi32_i32$1 = var$0$hi;
    i64toi32_i32$3 = var$0;
    i64toi32_i32$2 = $134$hi;
    i64toi32_i32$0 = var$3 & 63 | 0;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$2 = i64toi32_i32$3 << i64toi32_i32$4 | 0;
     $44 = 0;
    } else {
     i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$3 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
     $44 = i64toi32_i32$3 << i64toi32_i32$4 | 0;
    }
    var$0 = $44;
    var$0$hi = i64toi32_i32$2;
    label$13 : {
     if (var$2) {
      block3 : {
       i64toi32_i32$2 = var$1$hi;
       i64toi32_i32$1 = var$1;
       i64toi32_i32$3 = -1;
       i64toi32_i32$0 = -1;
       i64toi32_i32$4 = i64toi32_i32$1 + i64toi32_i32$0 | 0;
       i64toi32_i32$5 = i64toi32_i32$2 + i64toi32_i32$3 | 0;
       if (i64toi32_i32$4 >>> 0 < i64toi32_i32$0 >>> 0) {
        i64toi32_i32$5 = i64toi32_i32$5 + 1 | 0
       }
       var$8 = i64toi32_i32$4;
       var$8$hi = i64toi32_i32$5;
       label$15 : while (1) {
        i64toi32_i32$5 = var$5$hi;
        i64toi32_i32$2 = var$5;
        i64toi32_i32$1 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$3 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$3 | 0;
         $45 = 0;
        } else {
         i64toi32_i32$1 = ((1 << i64toi32_i32$3 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$3 | 0) | 0) | 0 | (i64toi32_i32$5 << i64toi32_i32$3 | 0) | 0;
         $45 = i64toi32_i32$2 << i64toi32_i32$3 | 0;
        }
        $140 = $45;
        $140$hi = i64toi32_i32$1;
        i64toi32_i32$1 = var$0$hi;
        i64toi32_i32$5 = var$0;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 63;
        i64toi32_i32$3 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = 0;
         $46 = i64toi32_i32$1 >>> i64toi32_i32$3 | 0;
        } else {
         i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$3 | 0;
         $46 = (((1 << i64toi32_i32$3 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$3 | 0) | 0 | (i64toi32_i32$5 >>> i64toi32_i32$3 | 0) | 0;
        }
        $142$hi = i64toi32_i32$2;
        i64toi32_i32$2 = $140$hi;
        i64toi32_i32$1 = $140;
        i64toi32_i32$5 = $142$hi;
        i64toi32_i32$0 = $46;
        i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
        var$5 = i64toi32_i32$1 | i64toi32_i32$0 | 0;
        var$5$hi = i64toi32_i32$5;
        $144 = var$5;
        $144$hi = i64toi32_i32$5;
        i64toi32_i32$5 = var$8$hi;
        i64toi32_i32$5 = var$5$hi;
        i64toi32_i32$5 = var$8$hi;
        i64toi32_i32$2 = var$8;
        i64toi32_i32$1 = var$5$hi;
        i64toi32_i32$0 = var$5;
        i64toi32_i32$3 = i64toi32_i32$2 - i64toi32_i32$0 | 0;
        i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$0 >>> 0;
        i64toi32_i32$4 = i64toi32_i32$6 + i64toi32_i32$1 | 0;
        i64toi32_i32$4 = i64toi32_i32$5 - i64toi32_i32$4 | 0;
        i64toi32_i32$5 = i64toi32_i32$3;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 63;
        i64toi32_i32$1 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = i64toi32_i32$4 >> 31 | 0;
         $47 = i64toi32_i32$4 >> i64toi32_i32$1 | 0;
        } else {
         i64toi32_i32$2 = i64toi32_i32$4 >> i64toi32_i32$1 | 0;
         $47 = (((1 << i64toi32_i32$1 | 0) - 1 | 0) & i64toi32_i32$4 | 0) << (32 - i64toi32_i32$1 | 0) | 0 | (i64toi32_i32$5 >>> i64toi32_i32$1 | 0) | 0;
        }
        var$6 = $47;
        var$6$hi = i64toi32_i32$2;
        i64toi32_i32$2 = var$1$hi;
        i64toi32_i32$2 = var$6$hi;
        i64toi32_i32$4 = var$6;
        i64toi32_i32$5 = var$1$hi;
        i64toi32_i32$0 = var$1;
        i64toi32_i32$5 = i64toi32_i32$2 & i64toi32_i32$5 | 0;
        $151 = i64toi32_i32$4 & i64toi32_i32$0 | 0;
        $151$hi = i64toi32_i32$5;
        i64toi32_i32$5 = $144$hi;
        i64toi32_i32$2 = $144;
        i64toi32_i32$4 = $151$hi;
        i64toi32_i32$0 = $151;
        i64toi32_i32$1 = i64toi32_i32$2 - i64toi32_i32$0 | 0;
        i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$0 >>> 0;
        i64toi32_i32$3 = i64toi32_i32$6 + i64toi32_i32$4 | 0;
        i64toi32_i32$3 = i64toi32_i32$5 - i64toi32_i32$3 | 0;
        var$5 = i64toi32_i32$1;
        var$5$hi = i64toi32_i32$3;
        i64toi32_i32$3 = var$0$hi;
        i64toi32_i32$5 = var$0;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
         $48 = 0;
        } else {
         i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$5 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
         $48 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
        }
        $154$hi = i64toi32_i32$2;
        i64toi32_i32$2 = var$7$hi;
        i64toi32_i32$2 = $154$hi;
        i64toi32_i32$3 = $48;
        i64toi32_i32$5 = var$7$hi;
        i64toi32_i32$0 = var$7;
        i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
        var$0 = i64toi32_i32$3 | i64toi32_i32$0 | 0;
        var$0$hi = i64toi32_i32$5;
        i64toi32_i32$5 = var$6$hi;
        i64toi32_i32$2 = var$6;
        i64toi32_i32$3 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$3 = i64toi32_i32$5 & i64toi32_i32$3 | 0;
        var$6 = i64toi32_i32$2 & i64toi32_i32$0 | 0;
        var$6$hi = i64toi32_i32$3;
        var$7 = var$6;
        var$7$hi = i64toi32_i32$3;
        var$2 = var$2 + -1 | 0;
        if (var$2) {
         continue label$15
        }
        break label$15;
       };
       break label$13;
      }
     }
    }
    i64toi32_i32$3 = var$5$hi;
    legalfunc$wasm2js_scratch_store_i64(var$5 | 0, i64toi32_i32$3 | 0);
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$5 = var$0;
    i64toi32_i32$2 = 0;
    i64toi32_i32$0 = 1;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$2 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
     $49 = 0;
    } else {
     i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$5 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
     $49 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
    }
    $165$hi = i64toi32_i32$2;
    i64toi32_i32$2 = var$6$hi;
    i64toi32_i32$2 = $165$hi;
    i64toi32_i32$3 = $49;
    i64toi32_i32$5 = var$6$hi;
    i64toi32_i32$0 = var$6;
    i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
    i64toi32_i32$3 = i64toi32_i32$3 | i64toi32_i32$0 | 0;
    i64toi32_i32$HIGH_BITS = i64toi32_i32$5;
    return i64toi32_i32$3 | 0;
   }
   i64toi32_i32$3 = var$0$hi;
   legalfunc$wasm2js_scratch_store_i64(var$0 | 0, i64toi32_i32$3 | 0);
   i64toi32_i32$3 = 0;
   var$0 = 0;
   var$0$hi = i64toi32_i32$3;
  }
  i64toi32_i32$3 = var$0$hi;
  i64toi32_i32$5 = var$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$3;
  return i64toi32_i32$5 | 0;
 }
 
 function __wasm_i64_sdiv(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function __wasm_i64_udiv(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function __wasm_ctz_i32(var$0) {
  var$0 = var$0 | 0;
  if (var$0) {
   return 31 - Math_clz32((var$0 + -1 | 0) ^ var$0 | 0) | 0 | 0
  }
  return 32 | 0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "i32_div_s_3": $0, 
  "i32_div_u_3": $1, 
  "i64_div_s_3": legalstub$2, 
  "i64_div_u_3": legalstub$3
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0},memasmFunc);
export var i32_div_s_3 = retasmFunc.i32_div_s_3;
export var i32_div_u_3 = retasmFunc.i32_div_u_3;
export var i64_div_s_3 = retasmFunc.i64_div_s_3;
export var i64_div_u_3 = retasmFunc.i64_div_u_3;
import { setTempRet0 } from 'env';


  var scratchBuffer = new ArrayBuffer(8);
  var i32ScratchView = new Int32Array(scratchBuffer);
  var f32ScratchView = new Float32Array(scratchBuffer);
  var f64ScratchView = new Float64Array(scratchBuffer);
  
  function legalimport$wasm2js_scratch_store_i64(low, high) {
    i32ScratchView[0] = low;
    i32ScratchView[1] = high;
  }
      
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
 function $0(x) {
  x = x | 0;
  return (x | 0) / (5 | 0) | 0 | 0;
 }
 
 function $1(x) {
  x = x | 0;
  return (x >>> 0) / (5 >>> 0) | 0 | 0;
 }
 
 function $2(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$1 = 0;
  i64toi32_i32$1 = __wasm_i64_sdiv(x | 0, i64toi32_i32$0 | 0, 5 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $3(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$1 = 0;
  i64toi32_i32$1 = __wasm_i64_udiv(x | 0, i64toi32_i32$0 | 0, 5 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function legalstub$2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $12 = 0, $13 = 0, $4 = 0, $4$hi = 0, $7$hi = 0, $2_1 = 0, $2$hi = 0;
  i64toi32_i32$0 = 0;
  $4 = $0_1;
  $4$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $12 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $12 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $7$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $4$hi;
  i64toi32_i32$0 = $4;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$3 = $12;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$2 = $2(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $2_1 = i64toi32_i32$2;
  $2$hi = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $13 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $13 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$1 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($13 | 0);
  i64toi32_i32$2 = $2$hi;
  return $2_1 | 0;
 }
 
 function legalstub$3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $12 = 0, $13 = 0, $4 = 0, $4$hi = 0, $7$hi = 0, $2_1 = 0, $2$hi = 0;
  i64toi32_i32$0 = 0;
  $4 = $0_1;
  $4$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $12 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $12 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $7$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $4$hi;
  i64toi32_i32$0 = $4;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$3 = $12;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$2 = $3(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $2_1 = i64toi32_i32$2;
  $2$hi = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $13 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $13 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$1 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($13 | 0);
  i64toi32_i32$2 = $2$hi;
  return $2_1 | 0;
 }
 
 function legalfunc$wasm2js_scratch_store_i64($0_1, $0$hi) {
  $0_1 = $0_1 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8 = 0, $2_1 = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $0$hi;
  $2_1 = $0_1;
  i64toi32_i32$2 = $0_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = 0;
   $8 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $8 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  legalimport$wasm2js_scratch_store_i64($2_1 | 0, $8 | 0);
 }
 
 function _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$1 = 0, i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, i64toi32_i32$0 = 0, i64toi32_i32$5 = 0, var$2 = 0, var$2$hi = 0, i64toi32_i32$6 = 0, $21 = 0, $22 = 0, $23 = 0, $7$hi = 0, $9 = 0, $9$hi = 0, $14$hi = 0, $16$hi = 0, $17 = 0, $17$hi = 0, $23$hi = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$2 = var$0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
   $21 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
   $21 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  var$2 = $21;
  var$2$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$0 = var$2;
  i64toi32_i32$2 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$2 | 0;
  $7$hi = i64toi32_i32$2;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$1 = i64toi32_i32$0 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$0 = var$2$hi;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$4 = i64toi32_i32$1 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$5 = i64toi32_i32$6 + i64toi32_i32$0 | 0;
  i64toi32_i32$5 = i64toi32_i32$2 - i64toi32_i32$5 | 0;
  $9 = i64toi32_i32$4;
  $9$hi = i64toi32_i32$5;
  i64toi32_i32$5 = var$1$hi;
  i64toi32_i32$2 = var$1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$0 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$5 >> 31 | 0;
   $22 = i64toi32_i32$5 >> i64toi32_i32$0 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$5 >> i64toi32_i32$0 | 0;
   $22 = (((1 << i64toi32_i32$0 | 0) - 1 | 0) & i64toi32_i32$5 | 0) << (32 - i64toi32_i32$0 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$0 | 0) | 0;
  }
  var$2 = $22;
  var$2$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$5 = var$2;
  i64toi32_i32$2 = var$1$hi;
  i64toi32_i32$3 = var$1;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$2 | 0;
  $14$hi = i64toi32_i32$2;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$2 = $14$hi;
  i64toi32_i32$1 = i64toi32_i32$5 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$5 = var$2$hi;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$0 = i64toi32_i32$1 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$4 = i64toi32_i32$6 + i64toi32_i32$5 | 0;
  i64toi32_i32$4 = i64toi32_i32$2 - i64toi32_i32$4 | 0;
  $16$hi = i64toi32_i32$4;
  i64toi32_i32$4 = $9$hi;
  i64toi32_i32$1 = $16$hi;
  i64toi32_i32$1 = __wasm_i64_udiv($9 | 0, i64toi32_i32$4 | 0, i64toi32_i32$0 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$4 = i64toi32_i32$HIGH_BITS;
  $17 = i64toi32_i32$1;
  $17$hi = i64toi32_i32$4;
  i64toi32_i32$4 = var$1$hi;
  i64toi32_i32$4 = var$0$hi;
  i64toi32_i32$4 = var$1$hi;
  i64toi32_i32$2 = var$1;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$1 = i64toi32_i32$4 ^ i64toi32_i32$1 | 0;
  i64toi32_i32$4 = i64toi32_i32$2 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$5 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = i64toi32_i32$1 >> 31 | 0;
   $23 = i64toi32_i32$1 >> i64toi32_i32$5 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$1 >> i64toi32_i32$5 | 0;
   $23 = (((1 << i64toi32_i32$5 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$5 | 0) | 0 | (i64toi32_i32$4 >>> i64toi32_i32$5 | 0) | 0;
  }
  var$0 = $23;
  var$0$hi = i64toi32_i32$2;
  i64toi32_i32$2 = $17$hi;
  i64toi32_i32$1 = $17;
  i64toi32_i32$4 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$4 = i64toi32_i32$2 ^ i64toi32_i32$4 | 0;
  $23$hi = i64toi32_i32$4;
  i64toi32_i32$4 = var$0$hi;
  i64toi32_i32$4 = $23$hi;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$5 = i64toi32_i32$2 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$0 = i64toi32_i32$6 + i64toi32_i32$1 | 0;
  i64toi32_i32$0 = i64toi32_i32$4 - i64toi32_i32$0 | 0;
  i64toi32_i32$2 = i64toi32_i32$5;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$2 | 0;
 }
 
 function _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$5 = 0, var$2 = 0, var$3 = 0, var$4 = 0, var$5 = 0, var$5$hi = 0, var$6 = 0, var$6$hi = 0, i64toi32_i32$6 = 0, $37 = 0, $38 = 0, $39 = 0, $40 = 0, $41 = 0, $42 = 0, $43 = 0, $44 = 0, var$8$hi = 0, $45 = 0, $46 = 0, $47 = 0, $48 = 0, var$7$hi = 0, $49 = 0, $63$hi = 0, $65 = 0, $65$hi = 0, $120$hi = 0, $129$hi = 0, $134$hi = 0, var$8 = 0, $140 = 0, $140$hi = 0, $142$hi = 0, $144 = 0, $144$hi = 0, $151 = 0, $151$hi = 0, $154$hi = 0, var$7 = 0, $165$hi = 0;
  label$1 : {
   label$2 : {
    label$3 : {
     label$4 : {
      label$5 : {
       label$6 : {
        label$7 : {
         label$8 : {
          label$9 : {
           label$10 : {
            label$11 : {
             i64toi32_i32$0 = var$0$hi;
             i64toi32_i32$2 = var$0;
             i64toi32_i32$1 = 0;
             i64toi32_i32$3 = 32;
             i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
             if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
              i64toi32_i32$1 = 0;
              $37 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
             } else {
              i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
              $37 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
             }
             var$2 = $37;
             if (var$2) {
              block : {
               i64toi32_i32$1 = var$1$hi;
               var$3 = var$1;
               if (!var$3) {
                break label$11
               }
               i64toi32_i32$1 = var$1$hi;
               i64toi32_i32$0 = var$1;
               i64toi32_i32$2 = 0;
               i64toi32_i32$3 = 32;
               i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
               if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
                i64toi32_i32$2 = 0;
                $38 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
               } else {
                i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
                $38 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$0 >>> i64toi32_i32$4 | 0) | 0;
               }
               var$4 = $38;
               if (!var$4) {
                break label$9
               }
               var$2 = Math_clz32(var$4) - Math_clz32(var$2) | 0;
               if (var$2 >>> 0 <= 31 >>> 0) {
                break label$8
               }
               break label$2;
              }
             }
             i64toi32_i32$2 = var$1$hi;
             i64toi32_i32$1 = var$1;
             i64toi32_i32$0 = 1;
             i64toi32_i32$3 = 0;
             if (i64toi32_i32$2 >>> 0 > i64toi32_i32$0 >>> 0 | ((i64toi32_i32$2 | 0) == (i64toi32_i32$0 | 0) & i64toi32_i32$1 >>> 0 >= i64toi32_i32$3 >>> 0 | 0) | 0) {
              break label$2
             }
             i64toi32_i32$1 = var$0$hi;
             var$2 = var$0;
             i64toi32_i32$1 = var$1$hi;
             var$3 = var$1;
             var$2 = (var$2 >>> 0) / (var$3 >>> 0) | 0;
             i64toi32_i32$1 = 0;
             legalfunc$wasm2js_scratch_store_i64(var$0 - Math_imul(var$2, var$3) | 0 | 0, i64toi32_i32$1 | 0);
             i64toi32_i32$1 = 0;
             i64toi32_i32$2 = var$2;
             i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
             return i64toi32_i32$2 | 0;
            }
            i64toi32_i32$2 = var$1$hi;
            i64toi32_i32$3 = var$1;
            i64toi32_i32$1 = 0;
            i64toi32_i32$0 = 32;
            i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
            if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
             i64toi32_i32$1 = 0;
             $39 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
            } else {
             i64toi32_i32$1 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
             $39 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$2 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$3 >>> i64toi32_i32$4 | 0) | 0;
            }
            var$3 = $39;
            i64toi32_i32$1 = var$0$hi;
            if (!var$0) {
             break label$7
            }
            if (!var$3) {
             break label$6
            }
            var$4 = var$3 + -1 | 0;
            if (var$4 & var$3 | 0) {
             break label$6
            }
            i64toi32_i32$1 = 0;
            i64toi32_i32$2 = var$4 & var$2 | 0;
            i64toi32_i32$3 = 0;
            i64toi32_i32$0 = 32;
            i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
            if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
             i64toi32_i32$3 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
             $40 = 0;
            } else {
             i64toi32_i32$3 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
             $40 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
            }
            $63$hi = i64toi32_i32$3;
            i64toi32_i32$3 = var$0$hi;
            i64toi32_i32$1 = var$0;
            i64toi32_i32$2 = 0;
            i64toi32_i32$0 = -1;
            i64toi32_i32$2 = i64toi32_i32$3 & i64toi32_i32$2 | 0;
            $65 = i64toi32_i32$1 & i64toi32_i32$0 | 0;
            $65$hi = i64toi32_i32$2;
            i64toi32_i32$2 = $63$hi;
            i64toi32_i32$3 = $40;
            i64toi32_i32$1 = $65$hi;
            i64toi32_i32$0 = $65;
            i64toi32_i32$1 = i64toi32_i32$2 | i64toi32_i32$1 | 0;
            legalfunc$wasm2js_scratch_store_i64(i64toi32_i32$3 | i64toi32_i32$0 | 0 | 0, i64toi32_i32$1 | 0);
            i64toi32_i32$1 = 0;
            i64toi32_i32$3 = var$2 >>> ((__wasm_ctz_i32(var$3 | 0) | 0) & 31 | 0) | 0;
            i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
            return i64toi32_i32$3 | 0;
           }
          }
          var$4 = var$3 + -1 | 0;
          if (!(var$4 & var$3 | 0)) {
           break label$5
          }
          var$2 = (Math_clz32(var$3) + 33 | 0) - Math_clz32(var$2) | 0;
          var$3 = 0 - var$2 | 0;
          break label$3;
         }
         var$3 = 63 - var$2 | 0;
         var$2 = var$2 + 1 | 0;
         break label$3;
        }
        var$4 = (var$2 >>> 0) / (var$3 >>> 0) | 0;
        i64toi32_i32$3 = 0;
        i64toi32_i32$2 = var$2 - Math_imul(var$4, var$3) | 0;
        i64toi32_i32$1 = 0;
        i64toi32_i32$0 = 32;
        i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
         $41 = 0;
        } else {
         i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
         $41 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
        }
        legalfunc$wasm2js_scratch_store_i64($41 | 0, i64toi32_i32$1 | 0);
        i64toi32_i32$1 = 0;
        i64toi32_i32$2 = var$4;
        i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
        return i64toi32_i32$2 | 0;
       }
       var$2 = Math_clz32(var$3) - Math_clz32(var$2) | 0;
       if (var$2 >>> 0 < 31 >>> 0) {
        break label$4
       }
       break label$2;
      }
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$2 = 0;
      legalfunc$wasm2js_scratch_store_i64(var$4 & var$0 | 0 | 0, i64toi32_i32$2 | 0);
      if ((var$3 | 0) == (1 | 0)) {
       break label$1
      }
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$2 = 0;
      $120$hi = i64toi32_i32$2;
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$3 = var$0;
      i64toi32_i32$1 = $120$hi;
      i64toi32_i32$0 = __wasm_ctz_i32(var$3 | 0) | 0;
      i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
      if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
       i64toi32_i32$1 = 0;
       $42 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
      } else {
       i64toi32_i32$1 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
       $42 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$2 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$3 >>> i64toi32_i32$4 | 0) | 0;
      }
      i64toi32_i32$3 = $42;
      i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
      return i64toi32_i32$3 | 0;
     }
     var$3 = 63 - var$2 | 0;
     var$2 = var$2 + 1 | 0;
    }
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$3 = 0;
    $129$hi = i64toi32_i32$3;
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$2 = var$0;
    i64toi32_i32$1 = $129$hi;
    i64toi32_i32$0 = var$2 & 63 | 0;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$1 = 0;
     $43 = i64toi32_i32$3 >>> i64toi32_i32$4 | 0;
    } else {
     i64toi32_i32$1 = i64toi32_i32$3 >>> i64toi32_i32$4 | 0;
     $43 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$3 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
    }
    var$5 = $43;
    var$5$hi = i64toi32_i32$1;
    i64toi32_i32$1 = var$0$hi;
    i64toi32_i32$1 = 0;
    $134$hi = i64toi32_i32$1;
    i64toi32_i32$1 = var$0$hi;
    i64toi32_i32$3 = var$0;
    i64toi32_i32$2 = $134$hi;
    i64toi32_i32$0 = var$3 & 63 | 0;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$2 = i64toi32_i32$3 << i64toi32_i32$4 | 0;
     $44 = 0;
    } else {
     i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$3 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
     $44 = i64toi32_i32$3 << i64toi32_i32$4 | 0;
    }
    var$0 = $44;
    var$0$hi = i64toi32_i32$2;
    label$13 : {
     if (var$2) {
      block3 : {
       i64toi32_i32$2 = var$1$hi;
       i64toi32_i32$1 = var$1;
       i64toi32_i32$3 = -1;
       i64toi32_i32$0 = -1;
       i64toi32_i32$4 = i64toi32_i32$1 + i64toi32_i32$0 | 0;
       i64toi32_i32$5 = i64toi32_i32$2 + i64toi32_i32$3 | 0;
       if (i64toi32_i32$4 >>> 0 < i64toi32_i32$0 >>> 0) {
        i64toi32_i32$5 = i64toi32_i32$5 + 1 | 0
       }
       var$8 = i64toi32_i32$4;
       var$8$hi = i64toi32_i32$5;
       label$15 : while (1) {
        i64toi32_i32$5 = var$5$hi;
        i64toi32_i32$2 = var$5;
        i64toi32_i32$1 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$3 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$3 | 0;
         $45 = 0;
        } else {
         i64toi32_i32$1 = ((1 << i64toi32_i32$3 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$3 | 0) | 0) | 0 | (i64toi32_i32$5 << i64toi32_i32$3 | 0) | 0;
         $45 = i64toi32_i32$2 << i64toi32_i32$3 | 0;
        }
        $140 = $45;
        $140$hi = i64toi32_i32$1;
        i64toi32_i32$1 = var$0$hi;
        i64toi32_i32$5 = var$0;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 63;
        i64toi32_i32$3 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = 0;
         $46 = i64toi32_i32$1 >>> i64toi32_i32$3 | 0;
        } else {
         i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$3 | 0;
         $46 = (((1 << i64toi32_i32$3 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$3 | 0) | 0 | (i64toi32_i32$5 >>> i64toi32_i32$3 | 0) | 0;
        }
        $142$hi = i64toi32_i32$2;
        i64toi32_i32$2 = $140$hi;
        i64toi32_i32$1 = $140;
        i64toi32_i32$5 = $142$hi;
        i64toi32_i32$0 = $46;
        i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
        var$5 = i64toi32_i32$1 | i64toi32_i32$0 | 0;
        var$5$hi = i64toi32_i32$5;
        $144 = var$5;
        $144$hi = i64toi32_i32$5;
        i64toi32_i32$5 = var$8$hi;
        i64toi32_i32$5 = var$5$hi;
        i64toi32_i32$5 = var$8$hi;
        i64toi32_i32$2 = var$8;
        i64toi32_i32$1 = var$5$hi;
        i64toi32_i32$0 = var$5;
        i64toi32_i32$3 = i64toi32_i32$2 - i64toi32_i32$0 | 0;
        i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$0 >>> 0;
        i64toi32_i32$4 = i64toi32_i32$6 + i64toi32_i32$1 | 0;
        i64toi32_i32$4 = i64toi32_i32$5 - i64toi32_i32$4 | 0;
        i64toi32_i32$5 = i64toi32_i32$3;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 63;
        i64toi32_i32$1 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = i64toi32_i32$4 >> 31 | 0;
         $47 = i64toi32_i32$4 >> i64toi32_i32$1 | 0;
        } else {
         i64toi32_i32$2 = i64toi32_i32$4 >> i64toi32_i32$1 | 0;
         $47 = (((1 << i64toi32_i32$1 | 0) - 1 | 0) & i64toi32_i32$4 | 0) << (32 - i64toi32_i32$1 | 0) | 0 | (i64toi32_i32$5 >>> i64toi32_i32$1 | 0) | 0;
        }
        var$6 = $47;
        var$6$hi = i64toi32_i32$2;
        i64toi32_i32$2 = var$1$hi;
        i64toi32_i32$2 = var$6$hi;
        i64toi32_i32$4 = var$6;
        i64toi32_i32$5 = var$1$hi;
        i64toi32_i32$0 = var$1;
        i64toi32_i32$5 = i64toi32_i32$2 & i64toi32_i32$5 | 0;
        $151 = i64toi32_i32$4 & i64toi32_i32$0 | 0;
        $151$hi = i64toi32_i32$5;
        i64toi32_i32$5 = $144$hi;
        i64toi32_i32$2 = $144;
        i64toi32_i32$4 = $151$hi;
        i64toi32_i32$0 = $151;
        i64toi32_i32$1 = i64toi32_i32$2 - i64toi32_i32$0 | 0;
        i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$0 >>> 0;
        i64toi32_i32$3 = i64toi32_i32$6 + i64toi32_i32$4 | 0;
        i64toi32_i32$3 = i64toi32_i32$5 - i64toi32_i32$3 | 0;
        var$5 = i64toi32_i32$1;
        var$5$hi = i64toi32_i32$3;
        i64toi32_i32$3 = var$0$hi;
        i64toi32_i32$5 = var$0;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
         $48 = 0;
        } else {
         i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$5 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
         $48 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
        }
        $154$hi = i64toi32_i32$2;
        i64toi32_i32$2 = var$7$hi;
        i64toi32_i32$2 = $154$hi;
        i64toi32_i32$3 = $48;
        i64toi32_i32$5 = var$7$hi;
        i64toi32_i32$0 = var$7;
        i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
        var$0 = i64toi32_i32$3 | i64toi32_i32$0 | 0;
        var$0$hi = i64toi32_i32$5;
        i64toi32_i32$5 = var$6$hi;
        i64toi32_i32$2 = var$6;
        i64toi32_i32$3 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$3 = i64toi32_i32$5 & i64toi32_i32$3 | 0;
        var$6 = i64toi32_i32$2 & i64toi32_i32$0 | 0;
        var$6$hi = i64toi32_i32$3;
        var$7 = var$6;
        var$7$hi = i64toi32_i32$3;
        var$2 = var$2 + -1 | 0;
        if (var$2) {
         continue label$15
        }
        break label$15;
       };
       break label$13;
      }
     }
    }
    i64toi32_i32$3 = var$5$hi;
    legalfunc$wasm2js_scratch_store_i64(var$5 | 0, i64toi32_i32$3 | 0);
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$5 = var$0;
    i64toi32_i32$2 = 0;
    i64toi32_i32$0 = 1;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$2 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
     $49 = 0;
    } else {
     i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$5 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
     $49 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
    }
    $165$hi = i64toi32_i32$2;
    i64toi32_i32$2 = var$6$hi;
    i64toi32_i32$2 = $165$hi;
    i64toi32_i32$3 = $49;
    i64toi32_i32$5 = var$6$hi;
    i64toi32_i32$0 = var$6;
    i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
    i64toi32_i32$3 = i64toi32_i32$3 | i64toi32_i32$0 | 0;
    i64toi32_i32$HIGH_BITS = i64toi32_i32$5;
    return i64toi32_i32$3 | 0;
   }
   i64toi32_i32$3 = var$0$hi;
   legalfunc$wasm2js_scratch_store_i64(var$0 | 0, i64toi32_i32$3 | 0);
   i64toi32_i32$3 = 0;
   var$0 = 0;
   var$0$hi = i64toi32_i32$3;
  }
  i64toi32_i32$3 = var$0$hi;
  i64toi32_i32$5 = var$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$3;
  return i64toi32_i32$5 | 0;
 }
 
 function __wasm_i64_sdiv(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function __wasm_i64_udiv(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function __wasm_ctz_i32(var$0) {
  var$0 = var$0 | 0;
  if (var$0) {
   return 31 - Math_clz32((var$0 + -1 | 0) ^ var$0 | 0) | 0 | 0
  }
  return 32 | 0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "i32_div_s_5": $0, 
  "i32_div_u_5": $1, 
  "i64_div_s_5": legalstub$2, 
  "i64_div_u_5": legalstub$3
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0},memasmFunc);
export var i32_div_s_5 = retasmFunc.i32_div_s_5;
export var i32_div_u_5 = retasmFunc.i32_div_u_5;
export var i64_div_s_5 = retasmFunc.i64_div_s_5;
export var i64_div_u_5 = retasmFunc.i64_div_u_5;
import { setTempRet0 } from 'env';


  var scratchBuffer = new ArrayBuffer(8);
  var i32ScratchView = new Int32Array(scratchBuffer);
  var f32ScratchView = new Float32Array(scratchBuffer);
  var f64ScratchView = new Float64Array(scratchBuffer);
  
  function legalimport$wasm2js_scratch_store_i64(low, high) {
    i32ScratchView[0] = low;
    i32ScratchView[1] = high;
  }
      
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
 function $0(x) {
  x = x | 0;
  return (x | 0) / (7 | 0) | 0 | 0;
 }
 
 function $1(x) {
  x = x | 0;
  return (x >>> 0) / (7 >>> 0) | 0 | 0;
 }
 
 function $2(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$1 = 0;
  i64toi32_i32$1 = __wasm_i64_sdiv(x | 0, i64toi32_i32$0 | 0, 7 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $3(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$1 = 0;
  i64toi32_i32$1 = __wasm_i64_udiv(x | 0, i64toi32_i32$0 | 0, 7 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function legalstub$2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $12 = 0, $13 = 0, $4 = 0, $4$hi = 0, $7$hi = 0, $2_1 = 0, $2$hi = 0;
  i64toi32_i32$0 = 0;
  $4 = $0_1;
  $4$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $12 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $12 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $7$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $4$hi;
  i64toi32_i32$0 = $4;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$3 = $12;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$2 = $2(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $2_1 = i64toi32_i32$2;
  $2$hi = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $13 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $13 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$1 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($13 | 0);
  i64toi32_i32$2 = $2$hi;
  return $2_1 | 0;
 }
 
 function legalstub$3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $12 = 0, $13 = 0, $4 = 0, $4$hi = 0, $7$hi = 0, $2_1 = 0, $2$hi = 0;
  i64toi32_i32$0 = 0;
  $4 = $0_1;
  $4$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $12 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $12 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $7$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $4$hi;
  i64toi32_i32$0 = $4;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$3 = $12;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$2 = $3(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $2_1 = i64toi32_i32$2;
  $2$hi = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $13 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $13 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$1 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($13 | 0);
  i64toi32_i32$2 = $2$hi;
  return $2_1 | 0;
 }
 
 function legalfunc$wasm2js_scratch_store_i64($0_1, $0$hi) {
  $0_1 = $0_1 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8 = 0, $2_1 = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $0$hi;
  $2_1 = $0_1;
  i64toi32_i32$2 = $0_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = 0;
   $8 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $8 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  legalimport$wasm2js_scratch_store_i64($2_1 | 0, $8 | 0);
 }
 
 function _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$1 = 0, i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, i64toi32_i32$0 = 0, i64toi32_i32$5 = 0, var$2 = 0, var$2$hi = 0, i64toi32_i32$6 = 0, $21 = 0, $22 = 0, $23 = 0, $7$hi = 0, $9 = 0, $9$hi = 0, $14$hi = 0, $16$hi = 0, $17 = 0, $17$hi = 0, $23$hi = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$2 = var$0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
   $21 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
   $21 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  var$2 = $21;
  var$2$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$0 = var$2;
  i64toi32_i32$2 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$2 | 0;
  $7$hi = i64toi32_i32$2;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$1 = i64toi32_i32$0 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$0 = var$2$hi;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$4 = i64toi32_i32$1 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$5 = i64toi32_i32$6 + i64toi32_i32$0 | 0;
  i64toi32_i32$5 = i64toi32_i32$2 - i64toi32_i32$5 | 0;
  $9 = i64toi32_i32$4;
  $9$hi = i64toi32_i32$5;
  i64toi32_i32$5 = var$1$hi;
  i64toi32_i32$2 = var$1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$0 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$5 >> 31 | 0;
   $22 = i64toi32_i32$5 >> i64toi32_i32$0 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$5 >> i64toi32_i32$0 | 0;
   $22 = (((1 << i64toi32_i32$0 | 0) - 1 | 0) & i64toi32_i32$5 | 0) << (32 - i64toi32_i32$0 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$0 | 0) | 0;
  }
  var$2 = $22;
  var$2$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$5 = var$2;
  i64toi32_i32$2 = var$1$hi;
  i64toi32_i32$3 = var$1;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$2 | 0;
  $14$hi = i64toi32_i32$2;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$2 = $14$hi;
  i64toi32_i32$1 = i64toi32_i32$5 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$5 = var$2$hi;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$0 = i64toi32_i32$1 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$4 = i64toi32_i32$6 + i64toi32_i32$5 | 0;
  i64toi32_i32$4 = i64toi32_i32$2 - i64toi32_i32$4 | 0;
  $16$hi = i64toi32_i32$4;
  i64toi32_i32$4 = $9$hi;
  i64toi32_i32$1 = $16$hi;
  i64toi32_i32$1 = __wasm_i64_udiv($9 | 0, i64toi32_i32$4 | 0, i64toi32_i32$0 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$4 = i64toi32_i32$HIGH_BITS;
  $17 = i64toi32_i32$1;
  $17$hi = i64toi32_i32$4;
  i64toi32_i32$4 = var$1$hi;
  i64toi32_i32$4 = var$0$hi;
  i64toi32_i32$4 = var$1$hi;
  i64toi32_i32$2 = var$1;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$1 = i64toi32_i32$4 ^ i64toi32_i32$1 | 0;
  i64toi32_i32$4 = i64toi32_i32$2 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$5 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = i64toi32_i32$1 >> 31 | 0;
   $23 = i64toi32_i32$1 >> i64toi32_i32$5 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$1 >> i64toi32_i32$5 | 0;
   $23 = (((1 << i64toi32_i32$5 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$5 | 0) | 0 | (i64toi32_i32$4 >>> i64toi32_i32$5 | 0) | 0;
  }
  var$0 = $23;
  var$0$hi = i64toi32_i32$2;
  i64toi32_i32$2 = $17$hi;
  i64toi32_i32$1 = $17;
  i64toi32_i32$4 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$4 = i64toi32_i32$2 ^ i64toi32_i32$4 | 0;
  $23$hi = i64toi32_i32$4;
  i64toi32_i32$4 = var$0$hi;
  i64toi32_i32$4 = $23$hi;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$5 = i64toi32_i32$2 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$0 = i64toi32_i32$6 + i64toi32_i32$1 | 0;
  i64toi32_i32$0 = i64toi32_i32$4 - i64toi32_i32$0 | 0;
  i64toi32_i32$2 = i64toi32_i32$5;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$2 | 0;
 }
 
 function _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$5 = 0, var$2 = 0, var$3 = 0, var$4 = 0, var$5 = 0, var$5$hi = 0, var$6 = 0, var$6$hi = 0, i64toi32_i32$6 = 0, $37 = 0, $38 = 0, $39 = 0, $40 = 0, $41 = 0, $42 = 0, $43 = 0, $44 = 0, var$8$hi = 0, $45 = 0, $46 = 0, $47 = 0, $48 = 0, var$7$hi = 0, $49 = 0, $63$hi = 0, $65 = 0, $65$hi = 0, $120$hi = 0, $129$hi = 0, $134$hi = 0, var$8 = 0, $140 = 0, $140$hi = 0, $142$hi = 0, $144 = 0, $144$hi = 0, $151 = 0, $151$hi = 0, $154$hi = 0, var$7 = 0, $165$hi = 0;
  label$1 : {
   label$2 : {
    label$3 : {
     label$4 : {
      label$5 : {
       label$6 : {
        label$7 : {
         label$8 : {
          label$9 : {
           label$10 : {
            label$11 : {
             i64toi32_i32$0 = var$0$hi;
             i64toi32_i32$2 = var$0;
             i64toi32_i32$1 = 0;
             i64toi32_i32$3 = 32;
             i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
             if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
              i64toi32_i32$1 = 0;
              $37 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
             } else {
              i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
              $37 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
             }
             var$2 = $37;
             if (var$2) {
              block : {
               i64toi32_i32$1 = var$1$hi;
               var$3 = var$1;
               if (!var$3) {
                break label$11
               }
               i64toi32_i32$1 = var$1$hi;
               i64toi32_i32$0 = var$1;
               i64toi32_i32$2 = 0;
               i64toi32_i32$3 = 32;
               i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
               if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
                i64toi32_i32$2 = 0;
                $38 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
               } else {
                i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
                $38 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$0 >>> i64toi32_i32$4 | 0) | 0;
               }
               var$4 = $38;
               if (!var$4) {
                break label$9
               }
               var$2 = Math_clz32(var$4) - Math_clz32(var$2) | 0;
               if (var$2 >>> 0 <= 31 >>> 0) {
                break label$8
               }
               break label$2;
              }
             }
             i64toi32_i32$2 = var$1$hi;
             i64toi32_i32$1 = var$1;
             i64toi32_i32$0 = 1;
             i64toi32_i32$3 = 0;
             if (i64toi32_i32$2 >>> 0 > i64toi32_i32$0 >>> 0 | ((i64toi32_i32$2 | 0) == (i64toi32_i32$0 | 0) & i64toi32_i32$1 >>> 0 >= i64toi32_i32$3 >>> 0 | 0) | 0) {
              break label$2
             }
             i64toi32_i32$1 = var$0$hi;
             var$2 = var$0;
             i64toi32_i32$1 = var$1$hi;
             var$3 = var$1;
             var$2 = (var$2 >>> 0) / (var$3 >>> 0) | 0;
             i64toi32_i32$1 = 0;
             legalfunc$wasm2js_scratch_store_i64(var$0 - Math_imul(var$2, var$3) | 0 | 0, i64toi32_i32$1 | 0);
             i64toi32_i32$1 = 0;
             i64toi32_i32$2 = var$2;
             i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
             return i64toi32_i32$2 | 0;
            }
            i64toi32_i32$2 = var$1$hi;
            i64toi32_i32$3 = var$1;
            i64toi32_i32$1 = 0;
            i64toi32_i32$0 = 32;
            i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
            if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
             i64toi32_i32$1 = 0;
             $39 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
            } else {
             i64toi32_i32$1 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
             $39 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$2 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$3 >>> i64toi32_i32$4 | 0) | 0;
            }
            var$3 = $39;
            i64toi32_i32$1 = var$0$hi;
            if (!var$0) {
             break label$7
            }
            if (!var$3) {
             break label$6
            }
            var$4 = var$3 + -1 | 0;
            if (var$4 & var$3 | 0) {
             break label$6
            }
            i64toi32_i32$1 = 0;
            i64toi32_i32$2 = var$4 & var$2 | 0;
            i64toi32_i32$3 = 0;
            i64toi32_i32$0 = 32;
            i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
            if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
             i64toi32_i32$3 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
             $40 = 0;
            } else {
             i64toi32_i32$3 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
             $40 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
            }
            $63$hi = i64toi32_i32$3;
            i64toi32_i32$3 = var$0$hi;
            i64toi32_i32$1 = var$0;
            i64toi32_i32$2 = 0;
            i64toi32_i32$0 = -1;
            i64toi32_i32$2 = i64toi32_i32$3 & i64toi32_i32$2 | 0;
            $65 = i64toi32_i32$1 & i64toi32_i32$0 | 0;
            $65$hi = i64toi32_i32$2;
            i64toi32_i32$2 = $63$hi;
            i64toi32_i32$3 = $40;
            i64toi32_i32$1 = $65$hi;
            i64toi32_i32$0 = $65;
            i64toi32_i32$1 = i64toi32_i32$2 | i64toi32_i32$1 | 0;
            legalfunc$wasm2js_scratch_store_i64(i64toi32_i32$3 | i64toi32_i32$0 | 0 | 0, i64toi32_i32$1 | 0);
            i64toi32_i32$1 = 0;
            i64toi32_i32$3 = var$2 >>> ((__wasm_ctz_i32(var$3 | 0) | 0) & 31 | 0) | 0;
            i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
            return i64toi32_i32$3 | 0;
           }
          }
          var$4 = var$3 + -1 | 0;
          if (!(var$4 & var$3 | 0)) {
           break label$5
          }
          var$2 = (Math_clz32(var$3) + 33 | 0) - Math_clz32(var$2) | 0;
          var$3 = 0 - var$2 | 0;
          break label$3;
         }
         var$3 = 63 - var$2 | 0;
         var$2 = var$2 + 1 | 0;
         break label$3;
        }
        var$4 = (var$2 >>> 0) / (var$3 >>> 0) | 0;
        i64toi32_i32$3 = 0;
        i64toi32_i32$2 = var$2 - Math_imul(var$4, var$3) | 0;
        i64toi32_i32$1 = 0;
        i64toi32_i32$0 = 32;
        i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
         $41 = 0;
        } else {
         i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
         $41 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
        }
        legalfunc$wasm2js_scratch_store_i64($41 | 0, i64toi32_i32$1 | 0);
        i64toi32_i32$1 = 0;
        i64toi32_i32$2 = var$4;
        i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
        return i64toi32_i32$2 | 0;
       }
       var$2 = Math_clz32(var$3) - Math_clz32(var$2) | 0;
       if (var$2 >>> 0 < 31 >>> 0) {
        break label$4
       }
       break label$2;
      }
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$2 = 0;
      legalfunc$wasm2js_scratch_store_i64(var$4 & var$0 | 0 | 0, i64toi32_i32$2 | 0);
      if ((var$3 | 0) == (1 | 0)) {
       break label$1
      }
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$2 = 0;
      $120$hi = i64toi32_i32$2;
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$3 = var$0;
      i64toi32_i32$1 = $120$hi;
      i64toi32_i32$0 = __wasm_ctz_i32(var$3 | 0) | 0;
      i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
      if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
       i64toi32_i32$1 = 0;
       $42 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
      } else {
       i64toi32_i32$1 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
       $42 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$2 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$3 >>> i64toi32_i32$4 | 0) | 0;
      }
      i64toi32_i32$3 = $42;
      i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
      return i64toi32_i32$3 | 0;
     }
     var$3 = 63 - var$2 | 0;
     var$2 = var$2 + 1 | 0;
    }
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$3 = 0;
    $129$hi = i64toi32_i32$3;
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$2 = var$0;
    i64toi32_i32$1 = $129$hi;
    i64toi32_i32$0 = var$2 & 63 | 0;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$1 = 0;
     $43 = i64toi32_i32$3 >>> i64toi32_i32$4 | 0;
    } else {
     i64toi32_i32$1 = i64toi32_i32$3 >>> i64toi32_i32$4 | 0;
     $43 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$3 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
    }
    var$5 = $43;
    var$5$hi = i64toi32_i32$1;
    i64toi32_i32$1 = var$0$hi;
    i64toi32_i32$1 = 0;
    $134$hi = i64toi32_i32$1;
    i64toi32_i32$1 = var$0$hi;
    i64toi32_i32$3 = var$0;
    i64toi32_i32$2 = $134$hi;
    i64toi32_i32$0 = var$3 & 63 | 0;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$2 = i64toi32_i32$3 << i64toi32_i32$4 | 0;
     $44 = 0;
    } else {
     i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$3 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
     $44 = i64toi32_i32$3 << i64toi32_i32$4 | 0;
    }
    var$0 = $44;
    var$0$hi = i64toi32_i32$2;
    label$13 : {
     if (var$2) {
      block3 : {
       i64toi32_i32$2 = var$1$hi;
       i64toi32_i32$1 = var$1;
       i64toi32_i32$3 = -1;
       i64toi32_i32$0 = -1;
       i64toi32_i32$4 = i64toi32_i32$1 + i64toi32_i32$0 | 0;
       i64toi32_i32$5 = i64toi32_i32$2 + i64toi32_i32$3 | 0;
       if (i64toi32_i32$4 >>> 0 < i64toi32_i32$0 >>> 0) {
        i64toi32_i32$5 = i64toi32_i32$5 + 1 | 0
       }
       var$8 = i64toi32_i32$4;
       var$8$hi = i64toi32_i32$5;
       label$15 : while (1) {
        i64toi32_i32$5 = var$5$hi;
        i64toi32_i32$2 = var$5;
        i64toi32_i32$1 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$3 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$3 | 0;
         $45 = 0;
        } else {
         i64toi32_i32$1 = ((1 << i64toi32_i32$3 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$3 | 0) | 0) | 0 | (i64toi32_i32$5 << i64toi32_i32$3 | 0) | 0;
         $45 = i64toi32_i32$2 << i64toi32_i32$3 | 0;
        }
        $140 = $45;
        $140$hi = i64toi32_i32$1;
        i64toi32_i32$1 = var$0$hi;
        i64toi32_i32$5 = var$0;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 63;
        i64toi32_i32$3 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = 0;
         $46 = i64toi32_i32$1 >>> i64toi32_i32$3 | 0;
        } else {
         i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$3 | 0;
         $46 = (((1 << i64toi32_i32$3 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$3 | 0) | 0 | (i64toi32_i32$5 >>> i64toi32_i32$3 | 0) | 0;
        }
        $142$hi = i64toi32_i32$2;
        i64toi32_i32$2 = $140$hi;
        i64toi32_i32$1 = $140;
        i64toi32_i32$5 = $142$hi;
        i64toi32_i32$0 = $46;
        i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
        var$5 = i64toi32_i32$1 | i64toi32_i32$0 | 0;
        var$5$hi = i64toi32_i32$5;
        $144 = var$5;
        $144$hi = i64toi32_i32$5;
        i64toi32_i32$5 = var$8$hi;
        i64toi32_i32$5 = var$5$hi;
        i64toi32_i32$5 = var$8$hi;
        i64toi32_i32$2 = var$8;
        i64toi32_i32$1 = var$5$hi;
        i64toi32_i32$0 = var$5;
        i64toi32_i32$3 = i64toi32_i32$2 - i64toi32_i32$0 | 0;
        i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$0 >>> 0;
        i64toi32_i32$4 = i64toi32_i32$6 + i64toi32_i32$1 | 0;
        i64toi32_i32$4 = i64toi32_i32$5 - i64toi32_i32$4 | 0;
        i64toi32_i32$5 = i64toi32_i32$3;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 63;
        i64toi32_i32$1 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = i64toi32_i32$4 >> 31 | 0;
         $47 = i64toi32_i32$4 >> i64toi32_i32$1 | 0;
        } else {
         i64toi32_i32$2 = i64toi32_i32$4 >> i64toi32_i32$1 | 0;
         $47 = (((1 << i64toi32_i32$1 | 0) - 1 | 0) & i64toi32_i32$4 | 0) << (32 - i64toi32_i32$1 | 0) | 0 | (i64toi32_i32$5 >>> i64toi32_i32$1 | 0) | 0;
        }
        var$6 = $47;
        var$6$hi = i64toi32_i32$2;
        i64toi32_i32$2 = var$1$hi;
        i64toi32_i32$2 = var$6$hi;
        i64toi32_i32$4 = var$6;
        i64toi32_i32$5 = var$1$hi;
        i64toi32_i32$0 = var$1;
        i64toi32_i32$5 = i64toi32_i32$2 & i64toi32_i32$5 | 0;
        $151 = i64toi32_i32$4 & i64toi32_i32$0 | 0;
        $151$hi = i64toi32_i32$5;
        i64toi32_i32$5 = $144$hi;
        i64toi32_i32$2 = $144;
        i64toi32_i32$4 = $151$hi;
        i64toi32_i32$0 = $151;
        i64toi32_i32$1 = i64toi32_i32$2 - i64toi32_i32$0 | 0;
        i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$0 >>> 0;
        i64toi32_i32$3 = i64toi32_i32$6 + i64toi32_i32$4 | 0;
        i64toi32_i32$3 = i64toi32_i32$5 - i64toi32_i32$3 | 0;
        var$5 = i64toi32_i32$1;
        var$5$hi = i64toi32_i32$3;
        i64toi32_i32$3 = var$0$hi;
        i64toi32_i32$5 = var$0;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
         $48 = 0;
        } else {
         i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$5 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
         $48 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
        }
        $154$hi = i64toi32_i32$2;
        i64toi32_i32$2 = var$7$hi;
        i64toi32_i32$2 = $154$hi;
        i64toi32_i32$3 = $48;
        i64toi32_i32$5 = var$7$hi;
        i64toi32_i32$0 = var$7;
        i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
        var$0 = i64toi32_i32$3 | i64toi32_i32$0 | 0;
        var$0$hi = i64toi32_i32$5;
        i64toi32_i32$5 = var$6$hi;
        i64toi32_i32$2 = var$6;
        i64toi32_i32$3 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$3 = i64toi32_i32$5 & i64toi32_i32$3 | 0;
        var$6 = i64toi32_i32$2 & i64toi32_i32$0 | 0;
        var$6$hi = i64toi32_i32$3;
        var$7 = var$6;
        var$7$hi = i64toi32_i32$3;
        var$2 = var$2 + -1 | 0;
        if (var$2) {
         continue label$15
        }
        break label$15;
       };
       break label$13;
      }
     }
    }
    i64toi32_i32$3 = var$5$hi;
    legalfunc$wasm2js_scratch_store_i64(var$5 | 0, i64toi32_i32$3 | 0);
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$5 = var$0;
    i64toi32_i32$2 = 0;
    i64toi32_i32$0 = 1;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$2 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
     $49 = 0;
    } else {
     i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$5 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
     $49 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
    }
    $165$hi = i64toi32_i32$2;
    i64toi32_i32$2 = var$6$hi;
    i64toi32_i32$2 = $165$hi;
    i64toi32_i32$3 = $49;
    i64toi32_i32$5 = var$6$hi;
    i64toi32_i32$0 = var$6;
    i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
    i64toi32_i32$3 = i64toi32_i32$3 | i64toi32_i32$0 | 0;
    i64toi32_i32$HIGH_BITS = i64toi32_i32$5;
    return i64toi32_i32$3 | 0;
   }
   i64toi32_i32$3 = var$0$hi;
   legalfunc$wasm2js_scratch_store_i64(var$0 | 0, i64toi32_i32$3 | 0);
   i64toi32_i32$3 = 0;
   var$0 = 0;
   var$0$hi = i64toi32_i32$3;
  }
  i64toi32_i32$3 = var$0$hi;
  i64toi32_i32$5 = var$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$3;
  return i64toi32_i32$5 | 0;
 }
 
 function __wasm_i64_sdiv(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function __wasm_i64_udiv(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function __wasm_ctz_i32(var$0) {
  var$0 = var$0 | 0;
  if (var$0) {
   return 31 - Math_clz32((var$0 + -1 | 0) ^ var$0 | 0) | 0 | 0
  }
  return 32 | 0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "i32_div_s_7": $0, 
  "i32_div_u_7": $1, 
  "i64_div_s_7": legalstub$2, 
  "i64_div_u_7": legalstub$3
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0},memasmFunc);
export var i32_div_s_7 = retasmFunc.i32_div_s_7;
export var i32_div_u_7 = retasmFunc.i32_div_u_7;
export var i64_div_s_7 = retasmFunc.i64_div_s_7;
export var i64_div_u_7 = retasmFunc.i64_div_u_7;
import { setTempRet0 } from 'env';
import { getTempRet0 } from 'env';


  var scratchBuffer = new ArrayBuffer(8);
  var i32ScratchView = new Int32Array(scratchBuffer);
  var f32ScratchView = new Float32Array(scratchBuffer);
  var f64ScratchView = new Float64Array(scratchBuffer);
  
  function legalimport$wasm2js_scratch_load_i64() {
    if (typeof setTempRet0 === 'function') setTempRet0(i32ScratchView[1]);
    return i32ScratchView[0];
  }
      
  function legalimport$wasm2js_scratch_store_i64(low, high) {
    i32ScratchView[0] = low;
    i32ScratchView[1] = high;
  }
      
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
 var getTempRet0 = env.getTempRet0;
 var i64toi32_i32$HIGH_BITS = 0;
 function $0(x) {
  x = x | 0;
  return (x | 0) % (3 | 0) | 0 | 0;
 }
 
 function $1(x) {
  x = x | 0;
  return (x >>> 0) % (3 >>> 0) | 0 | 0;
 }
 
 function $2(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$1 = 0;
  i64toi32_i32$1 = __wasm_i64_srem(x | 0, i64toi32_i32$0 | 0, 3 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $3(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$1 = 0;
  i64toi32_i32$1 = __wasm_i64_urem(x | 0, i64toi32_i32$0 | 0, 3 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function legalstub$2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $12 = 0, $13 = 0, $4 = 0, $4$hi = 0, $7$hi = 0, $2_1 = 0, $2$hi = 0;
  i64toi32_i32$0 = 0;
  $4 = $0_1;
  $4$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $12 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $12 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $7$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $4$hi;
  i64toi32_i32$0 = $4;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$3 = $12;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$2 = $2(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $2_1 = i64toi32_i32$2;
  $2$hi = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $13 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $13 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$1 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($13 | 0);
  i64toi32_i32$2 = $2$hi;
  return $2_1 | 0;
 }
 
 function legalstub$3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $12 = 0, $13 = 0, $4 = 0, $4$hi = 0, $7$hi = 0, $2_1 = 0, $2$hi = 0;
  i64toi32_i32$0 = 0;
  $4 = $0_1;
  $4$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $12 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $12 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $7$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $4$hi;
  i64toi32_i32$0 = $4;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$3 = $12;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$2 = $3(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $2_1 = i64toi32_i32$2;
  $2$hi = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $13 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $13 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$1 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($13 | 0);
  i64toi32_i32$2 = $2$hi;
  return $2_1 | 0;
 }
 
 function legalfunc$wasm2js_scratch_load_i64() {
  var i64toi32_i32$0 = 0, i64toi32_i32$2 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $8 = 0, $1_1 = 0, $1$hi = 0, $4$hi = 0;
  i64toi32_i32$0 = 0;
  $1_1 = legalimport$wasm2js_scratch_load_i64() | 0;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = getTempRet0() | 0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $8 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $8 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $4$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $1$hi;
  i64toi32_i32$0 = $1_1;
  i64toi32_i32$2 = $4$hi;
  i64toi32_i32$3 = $8;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$0 = i64toi32_i32$0 | i64toi32_i32$3 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$2;
  return i64toi32_i32$0 | 0;
 }
 
 function legalfunc$wasm2js_scratch_store_i64($0_1, $0$hi) {
  $0_1 = $0_1 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8 = 0, $2_1 = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $0$hi;
  $2_1 = $0_1;
  i64toi32_i32$2 = $0_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = 0;
   $8 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $8 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  legalimport$wasm2js_scratch_store_i64($2_1 | 0, $8 | 0);
 }
 
 function _ZN17compiler_builtins3int4sdiv3Mod4mod_17h2cbb7bbf36e41d68E(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$3 = 0, i64toi32_i32$5 = 0, var$2$hi = 0, i64toi32_i32$6 = 0, var$2 = 0, $20 = 0, $21 = 0, $7$hi = 0, $9 = 0, $9$hi = 0, $14$hi = 0, $16$hi = 0, $17$hi = 0, $19$hi = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$2 = var$0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
   $20 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
   $20 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  var$2 = $20;
  var$2$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$0 = var$2;
  i64toi32_i32$2 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$2 | 0;
  $7$hi = i64toi32_i32$2;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$1 = i64toi32_i32$0 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$0 = var$2$hi;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$4 = i64toi32_i32$1 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$5 = i64toi32_i32$6 + i64toi32_i32$0 | 0;
  i64toi32_i32$5 = i64toi32_i32$2 - i64toi32_i32$5 | 0;
  $9 = i64toi32_i32$4;
  $9$hi = i64toi32_i32$5;
  i64toi32_i32$5 = var$1$hi;
  i64toi32_i32$2 = var$1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$0 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$5 >> 31 | 0;
   $21 = i64toi32_i32$5 >> i64toi32_i32$0 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$5 >> i64toi32_i32$0 | 0;
   $21 = (((1 << i64toi32_i32$0 | 0) - 1 | 0) & i64toi32_i32$5 | 0) << (32 - i64toi32_i32$0 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$0 | 0) | 0;
  }
  var$0 = $21;
  var$0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$5 = var$0;
  i64toi32_i32$2 = var$1$hi;
  i64toi32_i32$3 = var$1;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$2 | 0;
  $14$hi = i64toi32_i32$2;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$2 = $14$hi;
  i64toi32_i32$1 = i64toi32_i32$5 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$5 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$0 = i64toi32_i32$1 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$4 = i64toi32_i32$6 + i64toi32_i32$5 | 0;
  i64toi32_i32$4 = i64toi32_i32$2 - i64toi32_i32$4 | 0;
  $16$hi = i64toi32_i32$4;
  i64toi32_i32$4 = $9$hi;
  i64toi32_i32$1 = $16$hi;
  i64toi32_i32$1 = __wasm_i64_urem($9 | 0, i64toi32_i32$4 | 0, i64toi32_i32$0 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$4 = i64toi32_i32$HIGH_BITS;
  $17$hi = i64toi32_i32$4;
  i64toi32_i32$4 = var$2$hi;
  i64toi32_i32$4 = $17$hi;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$1 = i64toi32_i32$4 ^ i64toi32_i32$1 | 0;
  $19$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$1 = $19$hi;
  i64toi32_i32$4 = i64toi32_i32$2 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$2 = var$2$hi;
  i64toi32_i32$5 = i64toi32_i32$4 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$4 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$0 = i64toi32_i32$6 + i64toi32_i32$2 | 0;
  i64toi32_i32$0 = i64toi32_i32$1 - i64toi32_i32$0 | 0;
  i64toi32_i32$4 = i64toi32_i32$5;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$4 | 0;
 }
 
 function _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$5 = 0, var$2 = 0, var$3 = 0, var$4 = 0, var$5 = 0, var$5$hi = 0, var$6 = 0, var$6$hi = 0, i64toi32_i32$6 = 0, $37 = 0, $38 = 0, $39 = 0, $40 = 0, $41 = 0, $42 = 0, $43 = 0, $44 = 0, var$8$hi = 0, $45 = 0, $46 = 0, $47 = 0, $48 = 0, var$7$hi = 0, $49 = 0, $63$hi = 0, $65 = 0, $65$hi = 0, $120$hi = 0, $129$hi = 0, $134$hi = 0, var$8 = 0, $140 = 0, $140$hi = 0, $142$hi = 0, $144 = 0, $144$hi = 0, $151 = 0, $151$hi = 0, $154$hi = 0, var$7 = 0, $165$hi = 0;
  label$1 : {
   label$2 : {
    label$3 : {
     label$4 : {
      label$5 : {
       label$6 : {
        label$7 : {
         label$8 : {
          label$9 : {
           label$10 : {
            label$11 : {
             i64toi32_i32$0 = var$0$hi;
             i64toi32_i32$2 = var$0;
             i64toi32_i32$1 = 0;
             i64toi32_i32$3 = 32;
             i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
             if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
              i64toi32_i32$1 = 0;
              $37 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
             } else {
              i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
              $37 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
             }
             var$2 = $37;
             if (var$2) {
              block : {
               i64toi32_i32$1 = var$1$hi;
               var$3 = var$1;
               if (!var$3) {
                break label$11
               }
               i64toi32_i32$1 = var$1$hi;
               i64toi32_i32$0 = var$1;
               i64toi32_i32$2 = 0;
               i64toi32_i32$3 = 32;
               i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
               if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
                i64toi32_i32$2 = 0;
                $38 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
               } else {
                i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
                $38 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$0 >>> i64toi32_i32$4 | 0) | 0;
               }
               var$4 = $38;
               if (!var$4) {
                break label$9
               }
               var$2 = Math_clz32(var$4) - Math_clz32(var$2) | 0;
               if (var$2 >>> 0 <= 31 >>> 0) {
                break label$8
               }
               break label$2;
              }
             }
             i64toi32_i32$2 = var$1$hi;
             i64toi32_i32$1 = var$1;
             i64toi32_i32$0 = 1;
             i64toi32_i32$3 = 0;
             if (i64toi32_i32$2 >>> 0 > i64toi32_i32$0 >>> 0 | ((i64toi32_i32$2 | 0) == (i64toi32_i32$0 | 0) & i64toi32_i32$1 >>> 0 >= i64toi32_i32$3 >>> 0 | 0) | 0) {
              break label$2
             }
             i64toi32_i32$1 = var$0$hi;
             var$2 = var$0;
             i64toi32_i32$1 = var$1$hi;
             var$3 = var$1;
             var$2 = (var$2 >>> 0) / (var$3 >>> 0) | 0;
             i64toi32_i32$1 = 0;
             legalfunc$wasm2js_scratch_store_i64(var$0 - Math_imul(var$2, var$3) | 0 | 0, i64toi32_i32$1 | 0);
             i64toi32_i32$1 = 0;
             i64toi32_i32$2 = var$2;
             i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
             return i64toi32_i32$2 | 0;
            }
            i64toi32_i32$2 = var$1$hi;
            i64toi32_i32$3 = var$1;
            i64toi32_i32$1 = 0;
            i64toi32_i32$0 = 32;
            i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
            if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
             i64toi32_i32$1 = 0;
             $39 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
            } else {
             i64toi32_i32$1 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
             $39 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$2 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$3 >>> i64toi32_i32$4 | 0) | 0;
            }
            var$3 = $39;
            i64toi32_i32$1 = var$0$hi;
            if (!var$0) {
             break label$7
            }
            if (!var$3) {
             break label$6
            }
            var$4 = var$3 + -1 | 0;
            if (var$4 & var$3 | 0) {
             break label$6
            }
            i64toi32_i32$1 = 0;
            i64toi32_i32$2 = var$4 & var$2 | 0;
            i64toi32_i32$3 = 0;
            i64toi32_i32$0 = 32;
            i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
            if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
             i64toi32_i32$3 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
             $40 = 0;
            } else {
             i64toi32_i32$3 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
             $40 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
            }
            $63$hi = i64toi32_i32$3;
            i64toi32_i32$3 = var$0$hi;
            i64toi32_i32$1 = var$0;
            i64toi32_i32$2 = 0;
            i64toi32_i32$0 = -1;
            i64toi32_i32$2 = i64toi32_i32$3 & i64toi32_i32$2 | 0;
            $65 = i64toi32_i32$1 & i64toi32_i32$0 | 0;
            $65$hi = i64toi32_i32$2;
            i64toi32_i32$2 = $63$hi;
            i64toi32_i32$3 = $40;
            i64toi32_i32$1 = $65$hi;
            i64toi32_i32$0 = $65;
            i64toi32_i32$1 = i64toi32_i32$2 | i64toi32_i32$1 | 0;
            legalfunc$wasm2js_scratch_store_i64(i64toi32_i32$3 | i64toi32_i32$0 | 0 | 0, i64toi32_i32$1 | 0);
            i64toi32_i32$1 = 0;
            i64toi32_i32$3 = var$2 >>> ((__wasm_ctz_i32(var$3 | 0) | 0) & 31 | 0) | 0;
            i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
            return i64toi32_i32$3 | 0;
           }
          }
          var$4 = var$3 + -1 | 0;
          if (!(var$4 & var$3 | 0)) {
           break label$5
          }
          var$2 = (Math_clz32(var$3) + 33 | 0) - Math_clz32(var$2) | 0;
          var$3 = 0 - var$2 | 0;
          break label$3;
         }
         var$3 = 63 - var$2 | 0;
         var$2 = var$2 + 1 | 0;
         break label$3;
        }
        var$4 = (var$2 >>> 0) / (var$3 >>> 0) | 0;
        i64toi32_i32$3 = 0;
        i64toi32_i32$2 = var$2 - Math_imul(var$4, var$3) | 0;
        i64toi32_i32$1 = 0;
        i64toi32_i32$0 = 32;
        i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
         $41 = 0;
        } else {
         i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
         $41 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
        }
        legalfunc$wasm2js_scratch_store_i64($41 | 0, i64toi32_i32$1 | 0);
        i64toi32_i32$1 = 0;
        i64toi32_i32$2 = var$4;
        i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
        return i64toi32_i32$2 | 0;
       }
       var$2 = Math_clz32(var$3) - Math_clz32(var$2) | 0;
       if (var$2 >>> 0 < 31 >>> 0) {
        break label$4
       }
       break label$2;
      }
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$2 = 0;
      legalfunc$wasm2js_scratch_store_i64(var$4 & var$0 | 0 | 0, i64toi32_i32$2 | 0);
      if ((var$3 | 0) == (1 | 0)) {
       break label$1
      }
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$2 = 0;
      $120$hi = i64toi32_i32$2;
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$3 = var$0;
      i64toi32_i32$1 = $120$hi;
      i64toi32_i32$0 = __wasm_ctz_i32(var$3 | 0) | 0;
      i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
      if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
       i64toi32_i32$1 = 0;
       $42 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
      } else {
       i64toi32_i32$1 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
       $42 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$2 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$3 >>> i64toi32_i32$4 | 0) | 0;
      }
      i64toi32_i32$3 = $42;
      i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
      return i64toi32_i32$3 | 0;
     }
     var$3 = 63 - var$2 | 0;
     var$2 = var$2 + 1 | 0;
    }
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$3 = 0;
    $129$hi = i64toi32_i32$3;
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$2 = var$0;
    i64toi32_i32$1 = $129$hi;
    i64toi32_i32$0 = var$2 & 63 | 0;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$1 = 0;
     $43 = i64toi32_i32$3 >>> i64toi32_i32$4 | 0;
    } else {
     i64toi32_i32$1 = i64toi32_i32$3 >>> i64toi32_i32$4 | 0;
     $43 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$3 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
    }
    var$5 = $43;
    var$5$hi = i64toi32_i32$1;
    i64toi32_i32$1 = var$0$hi;
    i64toi32_i32$1 = 0;
    $134$hi = i64toi32_i32$1;
    i64toi32_i32$1 = var$0$hi;
    i64toi32_i32$3 = var$0;
    i64toi32_i32$2 = $134$hi;
    i64toi32_i32$0 = var$3 & 63 | 0;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$2 = i64toi32_i32$3 << i64toi32_i32$4 | 0;
     $44 = 0;
    } else {
     i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$3 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
     $44 = i64toi32_i32$3 << i64toi32_i32$4 | 0;
    }
    var$0 = $44;
    var$0$hi = i64toi32_i32$2;
    label$13 : {
     if (var$2) {
      block3 : {
       i64toi32_i32$2 = var$1$hi;
       i64toi32_i32$1 = var$1;
       i64toi32_i32$3 = -1;
       i64toi32_i32$0 = -1;
       i64toi32_i32$4 = i64toi32_i32$1 + i64toi32_i32$0 | 0;
       i64toi32_i32$5 = i64toi32_i32$2 + i64toi32_i32$3 | 0;
       if (i64toi32_i32$4 >>> 0 < i64toi32_i32$0 >>> 0) {
        i64toi32_i32$5 = i64toi32_i32$5 + 1 | 0
       }
       var$8 = i64toi32_i32$4;
       var$8$hi = i64toi32_i32$5;
       label$15 : while (1) {
        i64toi32_i32$5 = var$5$hi;
        i64toi32_i32$2 = var$5;
        i64toi32_i32$1 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$3 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$3 | 0;
         $45 = 0;
        } else {
         i64toi32_i32$1 = ((1 << i64toi32_i32$3 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$3 | 0) | 0) | 0 | (i64toi32_i32$5 << i64toi32_i32$3 | 0) | 0;
         $45 = i64toi32_i32$2 << i64toi32_i32$3 | 0;
        }
        $140 = $45;
        $140$hi = i64toi32_i32$1;
        i64toi32_i32$1 = var$0$hi;
        i64toi32_i32$5 = var$0;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 63;
        i64toi32_i32$3 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = 0;
         $46 = i64toi32_i32$1 >>> i64toi32_i32$3 | 0;
        } else {
         i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$3 | 0;
         $46 = (((1 << i64toi32_i32$3 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$3 | 0) | 0 | (i64toi32_i32$5 >>> i64toi32_i32$3 | 0) | 0;
        }
        $142$hi = i64toi32_i32$2;
        i64toi32_i32$2 = $140$hi;
        i64toi32_i32$1 = $140;
        i64toi32_i32$5 = $142$hi;
        i64toi32_i32$0 = $46;
        i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
        var$5 = i64toi32_i32$1 | i64toi32_i32$0 | 0;
        var$5$hi = i64toi32_i32$5;
        $144 = var$5;
        $144$hi = i64toi32_i32$5;
        i64toi32_i32$5 = var$8$hi;
        i64toi32_i32$5 = var$5$hi;
        i64toi32_i32$5 = var$8$hi;
        i64toi32_i32$2 = var$8;
        i64toi32_i32$1 = var$5$hi;
        i64toi32_i32$0 = var$5;
        i64toi32_i32$3 = i64toi32_i32$2 - i64toi32_i32$0 | 0;
        i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$0 >>> 0;
        i64toi32_i32$4 = i64toi32_i32$6 + i64toi32_i32$1 | 0;
        i64toi32_i32$4 = i64toi32_i32$5 - i64toi32_i32$4 | 0;
        i64toi32_i32$5 = i64toi32_i32$3;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 63;
        i64toi32_i32$1 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = i64toi32_i32$4 >> 31 | 0;
         $47 = i64toi32_i32$4 >> i64toi32_i32$1 | 0;
        } else {
         i64toi32_i32$2 = i64toi32_i32$4 >> i64toi32_i32$1 | 0;
         $47 = (((1 << i64toi32_i32$1 | 0) - 1 | 0) & i64toi32_i32$4 | 0) << (32 - i64toi32_i32$1 | 0) | 0 | (i64toi32_i32$5 >>> i64toi32_i32$1 | 0) | 0;
        }
        var$6 = $47;
        var$6$hi = i64toi32_i32$2;
        i64toi32_i32$2 = var$1$hi;
        i64toi32_i32$2 = var$6$hi;
        i64toi32_i32$4 = var$6;
        i64toi32_i32$5 = var$1$hi;
        i64toi32_i32$0 = var$1;
        i64toi32_i32$5 = i64toi32_i32$2 & i64toi32_i32$5 | 0;
        $151 = i64toi32_i32$4 & i64toi32_i32$0 | 0;
        $151$hi = i64toi32_i32$5;
        i64toi32_i32$5 = $144$hi;
        i64toi32_i32$2 = $144;
        i64toi32_i32$4 = $151$hi;
        i64toi32_i32$0 = $151;
        i64toi32_i32$1 = i64toi32_i32$2 - i64toi32_i32$0 | 0;
        i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$0 >>> 0;
        i64toi32_i32$3 = i64toi32_i32$6 + i64toi32_i32$4 | 0;
        i64toi32_i32$3 = i64toi32_i32$5 - i64toi32_i32$3 | 0;
        var$5 = i64toi32_i32$1;
        var$5$hi = i64toi32_i32$3;
        i64toi32_i32$3 = var$0$hi;
        i64toi32_i32$5 = var$0;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
         $48 = 0;
        } else {
         i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$5 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
         $48 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
        }
        $154$hi = i64toi32_i32$2;
        i64toi32_i32$2 = var$7$hi;
        i64toi32_i32$2 = $154$hi;
        i64toi32_i32$3 = $48;
        i64toi32_i32$5 = var$7$hi;
        i64toi32_i32$0 = var$7;
        i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
        var$0 = i64toi32_i32$3 | i64toi32_i32$0 | 0;
        var$0$hi = i64toi32_i32$5;
        i64toi32_i32$5 = var$6$hi;
        i64toi32_i32$2 = var$6;
        i64toi32_i32$3 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$3 = i64toi32_i32$5 & i64toi32_i32$3 | 0;
        var$6 = i64toi32_i32$2 & i64toi32_i32$0 | 0;
        var$6$hi = i64toi32_i32$3;
        var$7 = var$6;
        var$7$hi = i64toi32_i32$3;
        var$2 = var$2 + -1 | 0;
        if (var$2) {
         continue label$15
        }
        break label$15;
       };
       break label$13;
      }
     }
    }
    i64toi32_i32$3 = var$5$hi;
    legalfunc$wasm2js_scratch_store_i64(var$5 | 0, i64toi32_i32$3 | 0);
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$5 = var$0;
    i64toi32_i32$2 = 0;
    i64toi32_i32$0 = 1;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$2 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
     $49 = 0;
    } else {
     i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$5 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
     $49 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
    }
    $165$hi = i64toi32_i32$2;
    i64toi32_i32$2 = var$6$hi;
    i64toi32_i32$2 = $165$hi;
    i64toi32_i32$3 = $49;
    i64toi32_i32$5 = var$6$hi;
    i64toi32_i32$0 = var$6;
    i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
    i64toi32_i32$3 = i64toi32_i32$3 | i64toi32_i32$0 | 0;
    i64toi32_i32$HIGH_BITS = i64toi32_i32$5;
    return i64toi32_i32$3 | 0;
   }
   i64toi32_i32$3 = var$0$hi;
   legalfunc$wasm2js_scratch_store_i64(var$0 | 0, i64toi32_i32$3 | 0);
   i64toi32_i32$3 = 0;
   var$0 = 0;
   var$0$hi = i64toi32_i32$3;
  }
  i64toi32_i32$3 = var$0$hi;
  i64toi32_i32$5 = var$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$3;
  return i64toi32_i32$5 | 0;
 }
 
 function __wasm_i64_srem(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int4sdiv3Mod4mod_17h2cbb7bbf36e41d68E(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function __wasm_i64_urem(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$0 = legalfunc$wasm2js_scratch_load_i64() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function __wasm_ctz_i32(var$0) {
  var$0 = var$0 | 0;
  if (var$0) {
   return 31 - Math_clz32((var$0 + -1 | 0) ^ var$0 | 0) | 0 | 0
  }
  return 32 | 0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "i32_rem_s_3": $0, 
  "i32_rem_u_3": $1, 
  "i64_rem_s_3": legalstub$2, 
  "i64_rem_u_3": legalstub$3
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0,getTempRet0},memasmFunc);
export var i32_rem_s_3 = retasmFunc.i32_rem_s_3;
export var i32_rem_u_3 = retasmFunc.i32_rem_u_3;
export var i64_rem_s_3 = retasmFunc.i64_rem_s_3;
export var i64_rem_u_3 = retasmFunc.i64_rem_u_3;
import { setTempRet0 } from 'env';
import { getTempRet0 } from 'env';


  var scratchBuffer = new ArrayBuffer(8);
  var i32ScratchView = new Int32Array(scratchBuffer);
  var f32ScratchView = new Float32Array(scratchBuffer);
  var f64ScratchView = new Float64Array(scratchBuffer);
  
  function legalimport$wasm2js_scratch_load_i64() {
    if (typeof setTempRet0 === 'function') setTempRet0(i32ScratchView[1]);
    return i32ScratchView[0];
  }
      
  function legalimport$wasm2js_scratch_store_i64(low, high) {
    i32ScratchView[0] = low;
    i32ScratchView[1] = high;
  }
      
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
 var getTempRet0 = env.getTempRet0;
 var i64toi32_i32$HIGH_BITS = 0;
 function $0(x) {
  x = x | 0;
  return (x | 0) % (5 | 0) | 0 | 0;
 }
 
 function $1(x) {
  x = x | 0;
  return (x >>> 0) % (5 >>> 0) | 0 | 0;
 }
 
 function $2(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$1 = 0;
  i64toi32_i32$1 = __wasm_i64_srem(x | 0, i64toi32_i32$0 | 0, 5 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $3(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$1 = 0;
  i64toi32_i32$1 = __wasm_i64_urem(x | 0, i64toi32_i32$0 | 0, 5 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function legalstub$2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $12 = 0, $13 = 0, $4 = 0, $4$hi = 0, $7$hi = 0, $2_1 = 0, $2$hi = 0;
  i64toi32_i32$0 = 0;
  $4 = $0_1;
  $4$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $12 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $12 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $7$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $4$hi;
  i64toi32_i32$0 = $4;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$3 = $12;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$2 = $2(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $2_1 = i64toi32_i32$2;
  $2$hi = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $13 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $13 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$1 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($13 | 0);
  i64toi32_i32$2 = $2$hi;
  return $2_1 | 0;
 }
 
 function legalstub$3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $12 = 0, $13 = 0, $4 = 0, $4$hi = 0, $7$hi = 0, $2_1 = 0, $2$hi = 0;
  i64toi32_i32$0 = 0;
  $4 = $0_1;
  $4$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $12 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $12 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $7$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $4$hi;
  i64toi32_i32$0 = $4;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$3 = $12;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$2 = $3(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $2_1 = i64toi32_i32$2;
  $2$hi = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $13 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $13 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$1 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($13 | 0);
  i64toi32_i32$2 = $2$hi;
  return $2_1 | 0;
 }
 
 function legalfunc$wasm2js_scratch_load_i64() {
  var i64toi32_i32$0 = 0, i64toi32_i32$2 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $8 = 0, $1_1 = 0, $1$hi = 0, $4$hi = 0;
  i64toi32_i32$0 = 0;
  $1_1 = legalimport$wasm2js_scratch_load_i64() | 0;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = getTempRet0() | 0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $8 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $8 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $4$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $1$hi;
  i64toi32_i32$0 = $1_1;
  i64toi32_i32$2 = $4$hi;
  i64toi32_i32$3 = $8;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$0 = i64toi32_i32$0 | i64toi32_i32$3 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$2;
  return i64toi32_i32$0 | 0;
 }
 
 function legalfunc$wasm2js_scratch_store_i64($0_1, $0$hi) {
  $0_1 = $0_1 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8 = 0, $2_1 = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $0$hi;
  $2_1 = $0_1;
  i64toi32_i32$2 = $0_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = 0;
   $8 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $8 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  legalimport$wasm2js_scratch_store_i64($2_1 | 0, $8 | 0);
 }
 
 function _ZN17compiler_builtins3int4sdiv3Mod4mod_17h2cbb7bbf36e41d68E(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$3 = 0, i64toi32_i32$5 = 0, var$2$hi = 0, i64toi32_i32$6 = 0, var$2 = 0, $20 = 0, $21 = 0, $7$hi = 0, $9 = 0, $9$hi = 0, $14$hi = 0, $16$hi = 0, $17$hi = 0, $19$hi = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$2 = var$0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
   $20 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
   $20 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  var$2 = $20;
  var$2$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$0 = var$2;
  i64toi32_i32$2 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$2 | 0;
  $7$hi = i64toi32_i32$2;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$1 = i64toi32_i32$0 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$0 = var$2$hi;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$4 = i64toi32_i32$1 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$5 = i64toi32_i32$6 + i64toi32_i32$0 | 0;
  i64toi32_i32$5 = i64toi32_i32$2 - i64toi32_i32$5 | 0;
  $9 = i64toi32_i32$4;
  $9$hi = i64toi32_i32$5;
  i64toi32_i32$5 = var$1$hi;
  i64toi32_i32$2 = var$1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$0 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$5 >> 31 | 0;
   $21 = i64toi32_i32$5 >> i64toi32_i32$0 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$5 >> i64toi32_i32$0 | 0;
   $21 = (((1 << i64toi32_i32$0 | 0) - 1 | 0) & i64toi32_i32$5 | 0) << (32 - i64toi32_i32$0 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$0 | 0) | 0;
  }
  var$0 = $21;
  var$0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$5 = var$0;
  i64toi32_i32$2 = var$1$hi;
  i64toi32_i32$3 = var$1;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$2 | 0;
  $14$hi = i64toi32_i32$2;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$2 = $14$hi;
  i64toi32_i32$1 = i64toi32_i32$5 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$5 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$0 = i64toi32_i32$1 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$4 = i64toi32_i32$6 + i64toi32_i32$5 | 0;
  i64toi32_i32$4 = i64toi32_i32$2 - i64toi32_i32$4 | 0;
  $16$hi = i64toi32_i32$4;
  i64toi32_i32$4 = $9$hi;
  i64toi32_i32$1 = $16$hi;
  i64toi32_i32$1 = __wasm_i64_urem($9 | 0, i64toi32_i32$4 | 0, i64toi32_i32$0 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$4 = i64toi32_i32$HIGH_BITS;
  $17$hi = i64toi32_i32$4;
  i64toi32_i32$4 = var$2$hi;
  i64toi32_i32$4 = $17$hi;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$1 = i64toi32_i32$4 ^ i64toi32_i32$1 | 0;
  $19$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$1 = $19$hi;
  i64toi32_i32$4 = i64toi32_i32$2 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$2 = var$2$hi;
  i64toi32_i32$5 = i64toi32_i32$4 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$4 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$0 = i64toi32_i32$6 + i64toi32_i32$2 | 0;
  i64toi32_i32$0 = i64toi32_i32$1 - i64toi32_i32$0 | 0;
  i64toi32_i32$4 = i64toi32_i32$5;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$4 | 0;
 }
 
 function _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$5 = 0, var$2 = 0, var$3 = 0, var$4 = 0, var$5 = 0, var$5$hi = 0, var$6 = 0, var$6$hi = 0, i64toi32_i32$6 = 0, $37 = 0, $38 = 0, $39 = 0, $40 = 0, $41 = 0, $42 = 0, $43 = 0, $44 = 0, var$8$hi = 0, $45 = 0, $46 = 0, $47 = 0, $48 = 0, var$7$hi = 0, $49 = 0, $63$hi = 0, $65 = 0, $65$hi = 0, $120$hi = 0, $129$hi = 0, $134$hi = 0, var$8 = 0, $140 = 0, $140$hi = 0, $142$hi = 0, $144 = 0, $144$hi = 0, $151 = 0, $151$hi = 0, $154$hi = 0, var$7 = 0, $165$hi = 0;
  label$1 : {
   label$2 : {
    label$3 : {
     label$4 : {
      label$5 : {
       label$6 : {
        label$7 : {
         label$8 : {
          label$9 : {
           label$10 : {
            label$11 : {
             i64toi32_i32$0 = var$0$hi;
             i64toi32_i32$2 = var$0;
             i64toi32_i32$1 = 0;
             i64toi32_i32$3 = 32;
             i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
             if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
              i64toi32_i32$1 = 0;
              $37 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
             } else {
              i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
              $37 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
             }
             var$2 = $37;
             if (var$2) {
              block : {
               i64toi32_i32$1 = var$1$hi;
               var$3 = var$1;
               if (!var$3) {
                break label$11
               }
               i64toi32_i32$1 = var$1$hi;
               i64toi32_i32$0 = var$1;
               i64toi32_i32$2 = 0;
               i64toi32_i32$3 = 32;
               i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
               if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
                i64toi32_i32$2 = 0;
                $38 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
               } else {
                i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
                $38 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$0 >>> i64toi32_i32$4 | 0) | 0;
               }
               var$4 = $38;
               if (!var$4) {
                break label$9
               }
               var$2 = Math_clz32(var$4) - Math_clz32(var$2) | 0;
               if (var$2 >>> 0 <= 31 >>> 0) {
                break label$8
               }
               break label$2;
              }
             }
             i64toi32_i32$2 = var$1$hi;
             i64toi32_i32$1 = var$1;
             i64toi32_i32$0 = 1;
             i64toi32_i32$3 = 0;
             if (i64toi32_i32$2 >>> 0 > i64toi32_i32$0 >>> 0 | ((i64toi32_i32$2 | 0) == (i64toi32_i32$0 | 0) & i64toi32_i32$1 >>> 0 >= i64toi32_i32$3 >>> 0 | 0) | 0) {
              break label$2
             }
             i64toi32_i32$1 = var$0$hi;
             var$2 = var$0;
             i64toi32_i32$1 = var$1$hi;
             var$3 = var$1;
             var$2 = (var$2 >>> 0) / (var$3 >>> 0) | 0;
             i64toi32_i32$1 = 0;
             legalfunc$wasm2js_scratch_store_i64(var$0 - Math_imul(var$2, var$3) | 0 | 0, i64toi32_i32$1 | 0);
             i64toi32_i32$1 = 0;
             i64toi32_i32$2 = var$2;
             i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
             return i64toi32_i32$2 | 0;
            }
            i64toi32_i32$2 = var$1$hi;
            i64toi32_i32$3 = var$1;
            i64toi32_i32$1 = 0;
            i64toi32_i32$0 = 32;
            i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
            if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
             i64toi32_i32$1 = 0;
             $39 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
            } else {
             i64toi32_i32$1 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
             $39 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$2 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$3 >>> i64toi32_i32$4 | 0) | 0;
            }
            var$3 = $39;
            i64toi32_i32$1 = var$0$hi;
            if (!var$0) {
             break label$7
            }
            if (!var$3) {
             break label$6
            }
            var$4 = var$3 + -1 | 0;
            if (var$4 & var$3 | 0) {
             break label$6
            }
            i64toi32_i32$1 = 0;
            i64toi32_i32$2 = var$4 & var$2 | 0;
            i64toi32_i32$3 = 0;
            i64toi32_i32$0 = 32;
            i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
            if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
             i64toi32_i32$3 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
             $40 = 0;
            } else {
             i64toi32_i32$3 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
             $40 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
            }
            $63$hi = i64toi32_i32$3;
            i64toi32_i32$3 = var$0$hi;
            i64toi32_i32$1 = var$0;
            i64toi32_i32$2 = 0;
            i64toi32_i32$0 = -1;
            i64toi32_i32$2 = i64toi32_i32$3 & i64toi32_i32$2 | 0;
            $65 = i64toi32_i32$1 & i64toi32_i32$0 | 0;
            $65$hi = i64toi32_i32$2;
            i64toi32_i32$2 = $63$hi;
            i64toi32_i32$3 = $40;
            i64toi32_i32$1 = $65$hi;
            i64toi32_i32$0 = $65;
            i64toi32_i32$1 = i64toi32_i32$2 | i64toi32_i32$1 | 0;
            legalfunc$wasm2js_scratch_store_i64(i64toi32_i32$3 | i64toi32_i32$0 | 0 | 0, i64toi32_i32$1 | 0);
            i64toi32_i32$1 = 0;
            i64toi32_i32$3 = var$2 >>> ((__wasm_ctz_i32(var$3 | 0) | 0) & 31 | 0) | 0;
            i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
            return i64toi32_i32$3 | 0;
           }
          }
          var$4 = var$3 + -1 | 0;
          if (!(var$4 & var$3 | 0)) {
           break label$5
          }
          var$2 = (Math_clz32(var$3) + 33 | 0) - Math_clz32(var$2) | 0;
          var$3 = 0 - var$2 | 0;
          break label$3;
         }
         var$3 = 63 - var$2 | 0;
         var$2 = var$2 + 1 | 0;
         break label$3;
        }
        var$4 = (var$2 >>> 0) / (var$3 >>> 0) | 0;
        i64toi32_i32$3 = 0;
        i64toi32_i32$2 = var$2 - Math_imul(var$4, var$3) | 0;
        i64toi32_i32$1 = 0;
        i64toi32_i32$0 = 32;
        i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
         $41 = 0;
        } else {
         i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
         $41 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
        }
        legalfunc$wasm2js_scratch_store_i64($41 | 0, i64toi32_i32$1 | 0);
        i64toi32_i32$1 = 0;
        i64toi32_i32$2 = var$4;
        i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
        return i64toi32_i32$2 | 0;
       }
       var$2 = Math_clz32(var$3) - Math_clz32(var$2) | 0;
       if (var$2 >>> 0 < 31 >>> 0) {
        break label$4
       }
       break label$2;
      }
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$2 = 0;
      legalfunc$wasm2js_scratch_store_i64(var$4 & var$0 | 0 | 0, i64toi32_i32$2 | 0);
      if ((var$3 | 0) == (1 | 0)) {
       break label$1
      }
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$2 = 0;
      $120$hi = i64toi32_i32$2;
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$3 = var$0;
      i64toi32_i32$1 = $120$hi;
      i64toi32_i32$0 = __wasm_ctz_i32(var$3 | 0) | 0;
      i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
      if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
       i64toi32_i32$1 = 0;
       $42 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
      } else {
       i64toi32_i32$1 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
       $42 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$2 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$3 >>> i64toi32_i32$4 | 0) | 0;
      }
      i64toi32_i32$3 = $42;
      i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
      return i64toi32_i32$3 | 0;
     }
     var$3 = 63 - var$2 | 0;
     var$2 = var$2 + 1 | 0;
    }
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$3 = 0;
    $129$hi = i64toi32_i32$3;
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$2 = var$0;
    i64toi32_i32$1 = $129$hi;
    i64toi32_i32$0 = var$2 & 63 | 0;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$1 = 0;
     $43 = i64toi32_i32$3 >>> i64toi32_i32$4 | 0;
    } else {
     i64toi32_i32$1 = i64toi32_i32$3 >>> i64toi32_i32$4 | 0;
     $43 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$3 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
    }
    var$5 = $43;
    var$5$hi = i64toi32_i32$1;
    i64toi32_i32$1 = var$0$hi;
    i64toi32_i32$1 = 0;
    $134$hi = i64toi32_i32$1;
    i64toi32_i32$1 = var$0$hi;
    i64toi32_i32$3 = var$0;
    i64toi32_i32$2 = $134$hi;
    i64toi32_i32$0 = var$3 & 63 | 0;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$2 = i64toi32_i32$3 << i64toi32_i32$4 | 0;
     $44 = 0;
    } else {
     i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$3 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
     $44 = i64toi32_i32$3 << i64toi32_i32$4 | 0;
    }
    var$0 = $44;
    var$0$hi = i64toi32_i32$2;
    label$13 : {
     if (var$2) {
      block3 : {
       i64toi32_i32$2 = var$1$hi;
       i64toi32_i32$1 = var$1;
       i64toi32_i32$3 = -1;
       i64toi32_i32$0 = -1;
       i64toi32_i32$4 = i64toi32_i32$1 + i64toi32_i32$0 | 0;
       i64toi32_i32$5 = i64toi32_i32$2 + i64toi32_i32$3 | 0;
       if (i64toi32_i32$4 >>> 0 < i64toi32_i32$0 >>> 0) {
        i64toi32_i32$5 = i64toi32_i32$5 + 1 | 0
       }
       var$8 = i64toi32_i32$4;
       var$8$hi = i64toi32_i32$5;
       label$15 : while (1) {
        i64toi32_i32$5 = var$5$hi;
        i64toi32_i32$2 = var$5;
        i64toi32_i32$1 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$3 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$3 | 0;
         $45 = 0;
        } else {
         i64toi32_i32$1 = ((1 << i64toi32_i32$3 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$3 | 0) | 0) | 0 | (i64toi32_i32$5 << i64toi32_i32$3 | 0) | 0;
         $45 = i64toi32_i32$2 << i64toi32_i32$3 | 0;
        }
        $140 = $45;
        $140$hi = i64toi32_i32$1;
        i64toi32_i32$1 = var$0$hi;
        i64toi32_i32$5 = var$0;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 63;
        i64toi32_i32$3 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = 0;
         $46 = i64toi32_i32$1 >>> i64toi32_i32$3 | 0;
        } else {
         i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$3 | 0;
         $46 = (((1 << i64toi32_i32$3 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$3 | 0) | 0 | (i64toi32_i32$5 >>> i64toi32_i32$3 | 0) | 0;
        }
        $142$hi = i64toi32_i32$2;
        i64toi32_i32$2 = $140$hi;
        i64toi32_i32$1 = $140;
        i64toi32_i32$5 = $142$hi;
        i64toi32_i32$0 = $46;
        i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
        var$5 = i64toi32_i32$1 | i64toi32_i32$0 | 0;
        var$5$hi = i64toi32_i32$5;
        $144 = var$5;
        $144$hi = i64toi32_i32$5;
        i64toi32_i32$5 = var$8$hi;
        i64toi32_i32$5 = var$5$hi;
        i64toi32_i32$5 = var$8$hi;
        i64toi32_i32$2 = var$8;
        i64toi32_i32$1 = var$5$hi;
        i64toi32_i32$0 = var$5;
        i64toi32_i32$3 = i64toi32_i32$2 - i64toi32_i32$0 | 0;
        i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$0 >>> 0;
        i64toi32_i32$4 = i64toi32_i32$6 + i64toi32_i32$1 | 0;
        i64toi32_i32$4 = i64toi32_i32$5 - i64toi32_i32$4 | 0;
        i64toi32_i32$5 = i64toi32_i32$3;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 63;
        i64toi32_i32$1 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = i64toi32_i32$4 >> 31 | 0;
         $47 = i64toi32_i32$4 >> i64toi32_i32$1 | 0;
        } else {
         i64toi32_i32$2 = i64toi32_i32$4 >> i64toi32_i32$1 | 0;
         $47 = (((1 << i64toi32_i32$1 | 0) - 1 | 0) & i64toi32_i32$4 | 0) << (32 - i64toi32_i32$1 | 0) | 0 | (i64toi32_i32$5 >>> i64toi32_i32$1 | 0) | 0;
        }
        var$6 = $47;
        var$6$hi = i64toi32_i32$2;
        i64toi32_i32$2 = var$1$hi;
        i64toi32_i32$2 = var$6$hi;
        i64toi32_i32$4 = var$6;
        i64toi32_i32$5 = var$1$hi;
        i64toi32_i32$0 = var$1;
        i64toi32_i32$5 = i64toi32_i32$2 & i64toi32_i32$5 | 0;
        $151 = i64toi32_i32$4 & i64toi32_i32$0 | 0;
        $151$hi = i64toi32_i32$5;
        i64toi32_i32$5 = $144$hi;
        i64toi32_i32$2 = $144;
        i64toi32_i32$4 = $151$hi;
        i64toi32_i32$0 = $151;
        i64toi32_i32$1 = i64toi32_i32$2 - i64toi32_i32$0 | 0;
        i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$0 >>> 0;
        i64toi32_i32$3 = i64toi32_i32$6 + i64toi32_i32$4 | 0;
        i64toi32_i32$3 = i64toi32_i32$5 - i64toi32_i32$3 | 0;
        var$5 = i64toi32_i32$1;
        var$5$hi = i64toi32_i32$3;
        i64toi32_i32$3 = var$0$hi;
        i64toi32_i32$5 = var$0;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
         $48 = 0;
        } else {
         i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$5 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
         $48 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
        }
        $154$hi = i64toi32_i32$2;
        i64toi32_i32$2 = var$7$hi;
        i64toi32_i32$2 = $154$hi;
        i64toi32_i32$3 = $48;
        i64toi32_i32$5 = var$7$hi;
        i64toi32_i32$0 = var$7;
        i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
        var$0 = i64toi32_i32$3 | i64toi32_i32$0 | 0;
        var$0$hi = i64toi32_i32$5;
        i64toi32_i32$5 = var$6$hi;
        i64toi32_i32$2 = var$6;
        i64toi32_i32$3 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$3 = i64toi32_i32$5 & i64toi32_i32$3 | 0;
        var$6 = i64toi32_i32$2 & i64toi32_i32$0 | 0;
        var$6$hi = i64toi32_i32$3;
        var$7 = var$6;
        var$7$hi = i64toi32_i32$3;
        var$2 = var$2 + -1 | 0;
        if (var$2) {
         continue label$15
        }
        break label$15;
       };
       break label$13;
      }
     }
    }
    i64toi32_i32$3 = var$5$hi;
    legalfunc$wasm2js_scratch_store_i64(var$5 | 0, i64toi32_i32$3 | 0);
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$5 = var$0;
    i64toi32_i32$2 = 0;
    i64toi32_i32$0 = 1;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$2 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
     $49 = 0;
    } else {
     i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$5 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
     $49 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
    }
    $165$hi = i64toi32_i32$2;
    i64toi32_i32$2 = var$6$hi;
    i64toi32_i32$2 = $165$hi;
    i64toi32_i32$3 = $49;
    i64toi32_i32$5 = var$6$hi;
    i64toi32_i32$0 = var$6;
    i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
    i64toi32_i32$3 = i64toi32_i32$3 | i64toi32_i32$0 | 0;
    i64toi32_i32$HIGH_BITS = i64toi32_i32$5;
    return i64toi32_i32$3 | 0;
   }
   i64toi32_i32$3 = var$0$hi;
   legalfunc$wasm2js_scratch_store_i64(var$0 | 0, i64toi32_i32$3 | 0);
   i64toi32_i32$3 = 0;
   var$0 = 0;
   var$0$hi = i64toi32_i32$3;
  }
  i64toi32_i32$3 = var$0$hi;
  i64toi32_i32$5 = var$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$3;
  return i64toi32_i32$5 | 0;
 }
 
 function __wasm_i64_srem(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int4sdiv3Mod4mod_17h2cbb7bbf36e41d68E(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function __wasm_i64_urem(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$0 = legalfunc$wasm2js_scratch_load_i64() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function __wasm_ctz_i32(var$0) {
  var$0 = var$0 | 0;
  if (var$0) {
   return 31 - Math_clz32((var$0 + -1 | 0) ^ var$0 | 0) | 0 | 0
  }
  return 32 | 0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "i32_rem_s_5": $0, 
  "i32_rem_u_5": $1, 
  "i64_rem_s_5": legalstub$2, 
  "i64_rem_u_5": legalstub$3
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0,getTempRet0},memasmFunc);
export var i32_rem_s_5 = retasmFunc.i32_rem_s_5;
export var i32_rem_u_5 = retasmFunc.i32_rem_u_5;
export var i64_rem_s_5 = retasmFunc.i64_rem_s_5;
export var i64_rem_u_5 = retasmFunc.i64_rem_u_5;
import { setTempRet0 } from 'env';
import { getTempRet0 } from 'env';


  var scratchBuffer = new ArrayBuffer(8);
  var i32ScratchView = new Int32Array(scratchBuffer);
  var f32ScratchView = new Float32Array(scratchBuffer);
  var f64ScratchView = new Float64Array(scratchBuffer);
  
  function legalimport$wasm2js_scratch_load_i64() {
    if (typeof setTempRet0 === 'function') setTempRet0(i32ScratchView[1]);
    return i32ScratchView[0];
  }
      
  function legalimport$wasm2js_scratch_store_i64(low, high) {
    i32ScratchView[0] = low;
    i32ScratchView[1] = high;
  }
      
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
 var getTempRet0 = env.getTempRet0;
 var i64toi32_i32$HIGH_BITS = 0;
 function $0(x) {
  x = x | 0;
  return (x | 0) % (7 | 0) | 0 | 0;
 }
 
 function $1(x) {
  x = x | 0;
  return (x >>> 0) % (7 >>> 0) | 0 | 0;
 }
 
 function $2(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$1 = 0;
  i64toi32_i32$1 = __wasm_i64_srem(x | 0, i64toi32_i32$0 | 0, 7 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $3(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$1 = 0;
  i64toi32_i32$1 = __wasm_i64_urem(x | 0, i64toi32_i32$0 | 0, 7 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function legalstub$2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $12 = 0, $13 = 0, $4 = 0, $4$hi = 0, $7$hi = 0, $2_1 = 0, $2$hi = 0;
  i64toi32_i32$0 = 0;
  $4 = $0_1;
  $4$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $12 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $12 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $7$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $4$hi;
  i64toi32_i32$0 = $4;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$3 = $12;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$2 = $2(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $2_1 = i64toi32_i32$2;
  $2$hi = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $13 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $13 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$1 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($13 | 0);
  i64toi32_i32$2 = $2$hi;
  return $2_1 | 0;
 }
 
 function legalstub$3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $12 = 0, $13 = 0, $4 = 0, $4$hi = 0, $7$hi = 0, $2_1 = 0, $2$hi = 0;
  i64toi32_i32$0 = 0;
  $4 = $0_1;
  $4$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $12 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $12 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $7$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $4$hi;
  i64toi32_i32$0 = $4;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$3 = $12;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$2 = $3(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $2_1 = i64toi32_i32$2;
  $2$hi = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $13 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $13 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$1 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($13 | 0);
  i64toi32_i32$2 = $2$hi;
  return $2_1 | 0;
 }
 
 function legalfunc$wasm2js_scratch_load_i64() {
  var i64toi32_i32$0 = 0, i64toi32_i32$2 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $8 = 0, $1_1 = 0, $1$hi = 0, $4$hi = 0;
  i64toi32_i32$0 = 0;
  $1_1 = legalimport$wasm2js_scratch_load_i64() | 0;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = getTempRet0() | 0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $8 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $8 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $4$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $1$hi;
  i64toi32_i32$0 = $1_1;
  i64toi32_i32$2 = $4$hi;
  i64toi32_i32$3 = $8;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$0 = i64toi32_i32$0 | i64toi32_i32$3 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$2;
  return i64toi32_i32$0 | 0;
 }
 
 function legalfunc$wasm2js_scratch_store_i64($0_1, $0$hi) {
  $0_1 = $0_1 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8 = 0, $2_1 = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $0$hi;
  $2_1 = $0_1;
  i64toi32_i32$2 = $0_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = 0;
   $8 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $8 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  legalimport$wasm2js_scratch_store_i64($2_1 | 0, $8 | 0);
 }
 
 function _ZN17compiler_builtins3int4sdiv3Mod4mod_17h2cbb7bbf36e41d68E(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$3 = 0, i64toi32_i32$5 = 0, var$2$hi = 0, i64toi32_i32$6 = 0, var$2 = 0, $20 = 0, $21 = 0, $7$hi = 0, $9 = 0, $9$hi = 0, $14$hi = 0, $16$hi = 0, $17$hi = 0, $19$hi = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$2 = var$0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
   $20 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
   $20 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  var$2 = $20;
  var$2$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$0 = var$2;
  i64toi32_i32$2 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$2 | 0;
  $7$hi = i64toi32_i32$2;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$1 = i64toi32_i32$0 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$0 = var$2$hi;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$4 = i64toi32_i32$1 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$5 = i64toi32_i32$6 + i64toi32_i32$0 | 0;
  i64toi32_i32$5 = i64toi32_i32$2 - i64toi32_i32$5 | 0;
  $9 = i64toi32_i32$4;
  $9$hi = i64toi32_i32$5;
  i64toi32_i32$5 = var$1$hi;
  i64toi32_i32$2 = var$1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$0 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$5 >> 31 | 0;
   $21 = i64toi32_i32$5 >> i64toi32_i32$0 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$5 >> i64toi32_i32$0 | 0;
   $21 = (((1 << i64toi32_i32$0 | 0) - 1 | 0) & i64toi32_i32$5 | 0) << (32 - i64toi32_i32$0 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$0 | 0) | 0;
  }
  var$0 = $21;
  var$0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$5 = var$0;
  i64toi32_i32$2 = var$1$hi;
  i64toi32_i32$3 = var$1;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$2 | 0;
  $14$hi = i64toi32_i32$2;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$2 = $14$hi;
  i64toi32_i32$1 = i64toi32_i32$5 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$5 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$0 = i64toi32_i32$1 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$4 = i64toi32_i32$6 + i64toi32_i32$5 | 0;
  i64toi32_i32$4 = i64toi32_i32$2 - i64toi32_i32$4 | 0;
  $16$hi = i64toi32_i32$4;
  i64toi32_i32$4 = $9$hi;
  i64toi32_i32$1 = $16$hi;
  i64toi32_i32$1 = __wasm_i64_urem($9 | 0, i64toi32_i32$4 | 0, i64toi32_i32$0 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$4 = i64toi32_i32$HIGH_BITS;
  $17$hi = i64toi32_i32$4;
  i64toi32_i32$4 = var$2$hi;
  i64toi32_i32$4 = $17$hi;
  i64toi32_i32$2 = i64toi32_i32$1;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$1 = i64toi32_i32$4 ^ i64toi32_i32$1 | 0;
  $19$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$1 = $19$hi;
  i64toi32_i32$4 = i64toi32_i32$2 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$2 = var$2$hi;
  i64toi32_i32$5 = i64toi32_i32$4 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$4 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$0 = i64toi32_i32$6 + i64toi32_i32$2 | 0;
  i64toi32_i32$0 = i64toi32_i32$1 - i64toi32_i32$0 | 0;
  i64toi32_i32$4 = i64toi32_i32$5;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$4 | 0;
 }
 
 function _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$5 = 0, var$2 = 0, var$3 = 0, var$4 = 0, var$5 = 0, var$5$hi = 0, var$6 = 0, var$6$hi = 0, i64toi32_i32$6 = 0, $37 = 0, $38 = 0, $39 = 0, $40 = 0, $41 = 0, $42 = 0, $43 = 0, $44 = 0, var$8$hi = 0, $45 = 0, $46 = 0, $47 = 0, $48 = 0, var$7$hi = 0, $49 = 0, $63$hi = 0, $65 = 0, $65$hi = 0, $120$hi = 0, $129$hi = 0, $134$hi = 0, var$8 = 0, $140 = 0, $140$hi = 0, $142$hi = 0, $144 = 0, $144$hi = 0, $151 = 0, $151$hi = 0, $154$hi = 0, var$7 = 0, $165$hi = 0;
  label$1 : {
   label$2 : {
    label$3 : {
     label$4 : {
      label$5 : {
       label$6 : {
        label$7 : {
         label$8 : {
          label$9 : {
           label$10 : {
            label$11 : {
             i64toi32_i32$0 = var$0$hi;
             i64toi32_i32$2 = var$0;
             i64toi32_i32$1 = 0;
             i64toi32_i32$3 = 32;
             i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
             if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
              i64toi32_i32$1 = 0;
              $37 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
             } else {
              i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
              $37 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
             }
             var$2 = $37;
             if (var$2) {
              block : {
               i64toi32_i32$1 = var$1$hi;
               var$3 = var$1;
               if (!var$3) {
                break label$11
               }
               i64toi32_i32$1 = var$1$hi;
               i64toi32_i32$0 = var$1;
               i64toi32_i32$2 = 0;
               i64toi32_i32$3 = 32;
               i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
               if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
                i64toi32_i32$2 = 0;
                $38 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
               } else {
                i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
                $38 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$0 >>> i64toi32_i32$4 | 0) | 0;
               }
               var$4 = $38;
               if (!var$4) {
                break label$9
               }
               var$2 = Math_clz32(var$4) - Math_clz32(var$2) | 0;
               if (var$2 >>> 0 <= 31 >>> 0) {
                break label$8
               }
               break label$2;
              }
             }
             i64toi32_i32$2 = var$1$hi;
             i64toi32_i32$1 = var$1;
             i64toi32_i32$0 = 1;
             i64toi32_i32$3 = 0;
             if (i64toi32_i32$2 >>> 0 > i64toi32_i32$0 >>> 0 | ((i64toi32_i32$2 | 0) == (i64toi32_i32$0 | 0) & i64toi32_i32$1 >>> 0 >= i64toi32_i32$3 >>> 0 | 0) | 0) {
              break label$2
             }
             i64toi32_i32$1 = var$0$hi;
             var$2 = var$0;
             i64toi32_i32$1 = var$1$hi;
             var$3 = var$1;
             var$2 = (var$2 >>> 0) / (var$3 >>> 0) | 0;
             i64toi32_i32$1 = 0;
             legalfunc$wasm2js_scratch_store_i64(var$0 - Math_imul(var$2, var$3) | 0 | 0, i64toi32_i32$1 | 0);
             i64toi32_i32$1 = 0;
             i64toi32_i32$2 = var$2;
             i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
             return i64toi32_i32$2 | 0;
            }
            i64toi32_i32$2 = var$1$hi;
            i64toi32_i32$3 = var$1;
            i64toi32_i32$1 = 0;
            i64toi32_i32$0 = 32;
            i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
            if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
             i64toi32_i32$1 = 0;
             $39 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
            } else {
             i64toi32_i32$1 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
             $39 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$2 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$3 >>> i64toi32_i32$4 | 0) | 0;
            }
            var$3 = $39;
            i64toi32_i32$1 = var$0$hi;
            if (!var$0) {
             break label$7
            }
            if (!var$3) {
             break label$6
            }
            var$4 = var$3 + -1 | 0;
            if (var$4 & var$3 | 0) {
             break label$6
            }
            i64toi32_i32$1 = 0;
            i64toi32_i32$2 = var$4 & var$2 | 0;
            i64toi32_i32$3 = 0;
            i64toi32_i32$0 = 32;
            i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
            if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
             i64toi32_i32$3 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
             $40 = 0;
            } else {
             i64toi32_i32$3 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
             $40 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
            }
            $63$hi = i64toi32_i32$3;
            i64toi32_i32$3 = var$0$hi;
            i64toi32_i32$1 = var$0;
            i64toi32_i32$2 = 0;
            i64toi32_i32$0 = -1;
            i64toi32_i32$2 = i64toi32_i32$3 & i64toi32_i32$2 | 0;
            $65 = i64toi32_i32$1 & i64toi32_i32$0 | 0;
            $65$hi = i64toi32_i32$2;
            i64toi32_i32$2 = $63$hi;
            i64toi32_i32$3 = $40;
            i64toi32_i32$1 = $65$hi;
            i64toi32_i32$0 = $65;
            i64toi32_i32$1 = i64toi32_i32$2 | i64toi32_i32$1 | 0;
            legalfunc$wasm2js_scratch_store_i64(i64toi32_i32$3 | i64toi32_i32$0 | 0 | 0, i64toi32_i32$1 | 0);
            i64toi32_i32$1 = 0;
            i64toi32_i32$3 = var$2 >>> ((__wasm_ctz_i32(var$3 | 0) | 0) & 31 | 0) | 0;
            i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
            return i64toi32_i32$3 | 0;
           }
          }
          var$4 = var$3 + -1 | 0;
          if (!(var$4 & var$3 | 0)) {
           break label$5
          }
          var$2 = (Math_clz32(var$3) + 33 | 0) - Math_clz32(var$2) | 0;
          var$3 = 0 - var$2 | 0;
          break label$3;
         }
         var$3 = 63 - var$2 | 0;
         var$2 = var$2 + 1 | 0;
         break label$3;
        }
        var$4 = (var$2 >>> 0) / (var$3 >>> 0) | 0;
        i64toi32_i32$3 = 0;
        i64toi32_i32$2 = var$2 - Math_imul(var$4, var$3) | 0;
        i64toi32_i32$1 = 0;
        i64toi32_i32$0 = 32;
        i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
         $41 = 0;
        } else {
         i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
         $41 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
        }
        legalfunc$wasm2js_scratch_store_i64($41 | 0, i64toi32_i32$1 | 0);
        i64toi32_i32$1 = 0;
        i64toi32_i32$2 = var$4;
        i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
        return i64toi32_i32$2 | 0;
       }
       var$2 = Math_clz32(var$3) - Math_clz32(var$2) | 0;
       if (var$2 >>> 0 < 31 >>> 0) {
        break label$4
       }
       break label$2;
      }
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$2 = 0;
      legalfunc$wasm2js_scratch_store_i64(var$4 & var$0 | 0 | 0, i64toi32_i32$2 | 0);
      if ((var$3 | 0) == (1 | 0)) {
       break label$1
      }
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$2 = 0;
      $120$hi = i64toi32_i32$2;
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$3 = var$0;
      i64toi32_i32$1 = $120$hi;
      i64toi32_i32$0 = __wasm_ctz_i32(var$3 | 0) | 0;
      i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
      if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
       i64toi32_i32$1 = 0;
       $42 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
      } else {
       i64toi32_i32$1 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
       $42 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$2 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$3 >>> i64toi32_i32$4 | 0) | 0;
      }
      i64toi32_i32$3 = $42;
      i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
      return i64toi32_i32$3 | 0;
     }
     var$3 = 63 - var$2 | 0;
     var$2 = var$2 + 1 | 0;
    }
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$3 = 0;
    $129$hi = i64toi32_i32$3;
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$2 = var$0;
    i64toi32_i32$1 = $129$hi;
    i64toi32_i32$0 = var$2 & 63 | 0;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$1 = 0;
     $43 = i64toi32_i32$3 >>> i64toi32_i32$4 | 0;
    } else {
     i64toi32_i32$1 = i64toi32_i32$3 >>> i64toi32_i32$4 | 0;
     $43 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$3 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
    }
    var$5 = $43;
    var$5$hi = i64toi32_i32$1;
    i64toi32_i32$1 = var$0$hi;
    i64toi32_i32$1 = 0;
    $134$hi = i64toi32_i32$1;
    i64toi32_i32$1 = var$0$hi;
    i64toi32_i32$3 = var$0;
    i64toi32_i32$2 = $134$hi;
    i64toi32_i32$0 = var$3 & 63 | 0;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$2 = i64toi32_i32$3 << i64toi32_i32$4 | 0;
     $44 = 0;
    } else {
     i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$3 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
     $44 = i64toi32_i32$3 << i64toi32_i32$4 | 0;
    }
    var$0 = $44;
    var$0$hi = i64toi32_i32$2;
    label$13 : {
     if (var$2) {
      block3 : {
       i64toi32_i32$2 = var$1$hi;
       i64toi32_i32$1 = var$1;
       i64toi32_i32$3 = -1;
       i64toi32_i32$0 = -1;
       i64toi32_i32$4 = i64toi32_i32$1 + i64toi32_i32$0 | 0;
       i64toi32_i32$5 = i64toi32_i32$2 + i64toi32_i32$3 | 0;
       if (i64toi32_i32$4 >>> 0 < i64toi32_i32$0 >>> 0) {
        i64toi32_i32$5 = i64toi32_i32$5 + 1 | 0
       }
       var$8 = i64toi32_i32$4;
       var$8$hi = i64toi32_i32$5;
       label$15 : while (1) {
        i64toi32_i32$5 = var$5$hi;
        i64toi32_i32$2 = var$5;
        i64toi32_i32$1 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$3 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$3 | 0;
         $45 = 0;
        } else {
         i64toi32_i32$1 = ((1 << i64toi32_i32$3 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$3 | 0) | 0) | 0 | (i64toi32_i32$5 << i64toi32_i32$3 | 0) | 0;
         $45 = i64toi32_i32$2 << i64toi32_i32$3 | 0;
        }
        $140 = $45;
        $140$hi = i64toi32_i32$1;
        i64toi32_i32$1 = var$0$hi;
        i64toi32_i32$5 = var$0;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 63;
        i64toi32_i32$3 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = 0;
         $46 = i64toi32_i32$1 >>> i64toi32_i32$3 | 0;
        } else {
         i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$3 | 0;
         $46 = (((1 << i64toi32_i32$3 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$3 | 0) | 0 | (i64toi32_i32$5 >>> i64toi32_i32$3 | 0) | 0;
        }
        $142$hi = i64toi32_i32$2;
        i64toi32_i32$2 = $140$hi;
        i64toi32_i32$1 = $140;
        i64toi32_i32$5 = $142$hi;
        i64toi32_i32$0 = $46;
        i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
        var$5 = i64toi32_i32$1 | i64toi32_i32$0 | 0;
        var$5$hi = i64toi32_i32$5;
        $144 = var$5;
        $144$hi = i64toi32_i32$5;
        i64toi32_i32$5 = var$8$hi;
        i64toi32_i32$5 = var$5$hi;
        i64toi32_i32$5 = var$8$hi;
        i64toi32_i32$2 = var$8;
        i64toi32_i32$1 = var$5$hi;
        i64toi32_i32$0 = var$5;
        i64toi32_i32$3 = i64toi32_i32$2 - i64toi32_i32$0 | 0;
        i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$0 >>> 0;
        i64toi32_i32$4 = i64toi32_i32$6 + i64toi32_i32$1 | 0;
        i64toi32_i32$4 = i64toi32_i32$5 - i64toi32_i32$4 | 0;
        i64toi32_i32$5 = i64toi32_i32$3;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 63;
        i64toi32_i32$1 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = i64toi32_i32$4 >> 31 | 0;
         $47 = i64toi32_i32$4 >> i64toi32_i32$1 | 0;
        } else {
         i64toi32_i32$2 = i64toi32_i32$4 >> i64toi32_i32$1 | 0;
         $47 = (((1 << i64toi32_i32$1 | 0) - 1 | 0) & i64toi32_i32$4 | 0) << (32 - i64toi32_i32$1 | 0) | 0 | (i64toi32_i32$5 >>> i64toi32_i32$1 | 0) | 0;
        }
        var$6 = $47;
        var$6$hi = i64toi32_i32$2;
        i64toi32_i32$2 = var$1$hi;
        i64toi32_i32$2 = var$6$hi;
        i64toi32_i32$4 = var$6;
        i64toi32_i32$5 = var$1$hi;
        i64toi32_i32$0 = var$1;
        i64toi32_i32$5 = i64toi32_i32$2 & i64toi32_i32$5 | 0;
        $151 = i64toi32_i32$4 & i64toi32_i32$0 | 0;
        $151$hi = i64toi32_i32$5;
        i64toi32_i32$5 = $144$hi;
        i64toi32_i32$2 = $144;
        i64toi32_i32$4 = $151$hi;
        i64toi32_i32$0 = $151;
        i64toi32_i32$1 = i64toi32_i32$2 - i64toi32_i32$0 | 0;
        i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$0 >>> 0;
        i64toi32_i32$3 = i64toi32_i32$6 + i64toi32_i32$4 | 0;
        i64toi32_i32$3 = i64toi32_i32$5 - i64toi32_i32$3 | 0;
        var$5 = i64toi32_i32$1;
        var$5$hi = i64toi32_i32$3;
        i64toi32_i32$3 = var$0$hi;
        i64toi32_i32$5 = var$0;
        i64toi32_i32$2 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$2 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
         $48 = 0;
        } else {
         i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$5 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
         $48 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
        }
        $154$hi = i64toi32_i32$2;
        i64toi32_i32$2 = var$7$hi;
        i64toi32_i32$2 = $154$hi;
        i64toi32_i32$3 = $48;
        i64toi32_i32$5 = var$7$hi;
        i64toi32_i32$0 = var$7;
        i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
        var$0 = i64toi32_i32$3 | i64toi32_i32$0 | 0;
        var$0$hi = i64toi32_i32$5;
        i64toi32_i32$5 = var$6$hi;
        i64toi32_i32$2 = var$6;
        i64toi32_i32$3 = 0;
        i64toi32_i32$0 = 1;
        i64toi32_i32$3 = i64toi32_i32$5 & i64toi32_i32$3 | 0;
        var$6 = i64toi32_i32$2 & i64toi32_i32$0 | 0;
        var$6$hi = i64toi32_i32$3;
        var$7 = var$6;
        var$7$hi = i64toi32_i32$3;
        var$2 = var$2 + -1 | 0;
        if (var$2) {
         continue label$15
        }
        break label$15;
       };
       break label$13;
      }
     }
    }
    i64toi32_i32$3 = var$5$hi;
    legalfunc$wasm2js_scratch_store_i64(var$5 | 0, i64toi32_i32$3 | 0);
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$5 = var$0;
    i64toi32_i32$2 = 0;
    i64toi32_i32$0 = 1;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$2 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
     $49 = 0;
    } else {
     i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$5 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
     $49 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
    }
    $165$hi = i64toi32_i32$2;
    i64toi32_i32$2 = var$6$hi;
    i64toi32_i32$2 = $165$hi;
    i64toi32_i32$3 = $49;
    i64toi32_i32$5 = var$6$hi;
    i64toi32_i32$0 = var$6;
    i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
    i64toi32_i32$3 = i64toi32_i32$3 | i64toi32_i32$0 | 0;
    i64toi32_i32$HIGH_BITS = i64toi32_i32$5;
    return i64toi32_i32$3 | 0;
   }
   i64toi32_i32$3 = var$0$hi;
   legalfunc$wasm2js_scratch_store_i64(var$0 | 0, i64toi32_i32$3 | 0);
   i64toi32_i32$3 = 0;
   var$0 = 0;
   var$0$hi = i64toi32_i32$3;
  }
  i64toi32_i32$3 = var$0$hi;
  i64toi32_i32$5 = var$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$3;
  return i64toi32_i32$5 | 0;
 }
 
 function __wasm_i64_srem(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int4sdiv3Mod4mod_17h2cbb7bbf36e41d68E(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function __wasm_i64_urem(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$0 = legalfunc$wasm2js_scratch_load_i64() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function __wasm_ctz_i32(var$0) {
  var$0 = var$0 | 0;
  if (var$0) {
   return 31 - Math_clz32((var$0 + -1 | 0) ^ var$0 | 0) | 0 | 0
  }
  return 32 | 0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "i32_rem_s_7": $0, 
  "i32_rem_u_7": $1, 
  "i64_rem_s_7": legalstub$2, 
  "i64_rem_u_7": legalstub$3
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0,getTempRet0},memasmFunc);
export var i32_rem_s_7 = retasmFunc.i32_rem_s_7;
export var i32_rem_u_7 = retasmFunc.i32_rem_u_7;
export var i64_rem_s_7 = retasmFunc.i64_rem_s_7;
export var i64_rem_u_7 = retasmFunc.i64_rem_u_7;
