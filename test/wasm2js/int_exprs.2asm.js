
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
 function $0($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  return ($0_1 + 1 | 0 | 0) < ($1_1 + 1 | 0 | 0) | 0;
 }
 
 function $1($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  return ($0_1 + 1 | 0) >>> 0 < ($1_1 + 1 | 0) >>> 0 | 0;
 }
 
 function $2($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0;
  $6 = 0;
  $4 = 1;
  $0_1 = $0_1 + $4 | 0;
  $5 = $1_1 + $6 | 0;
  if ($0_1 >>> 0 < $4 >>> 0) {
   $5 = $5 + 1 | 0
  }
  $7 = $0_1;
  $8 = $5;
  $5 = $3_1;
  $1_1 = $2_1;
  $0_1 = 0;
  $4 = 1;
  $6 = $1_1 + $4 | 0;
  $0_1 = $5 + $0_1 | 0;
  if ($6 >>> 0 < $4 >>> 0) {
   $0_1 = $0_1 + 1 | 0
  }
  $1_1 = $0_1;
  $0_1 = $8;
  $5 = $7;
  $4 = $6;
  if (($0_1 | 0) < ($1_1 | 0)) {
   $0_1 = 1
  } else {
   if (($0_1 | 0) <= ($1_1 | 0)) {
    if ($5 >>> 0 >= $4 >>> 0) {
     $0_1 = 0
    } else {
     $0_1 = 1
    }
   } else {
    $0_1 = 0
   }
  }
  return $0_1 | 0;
 }
 
 function $3($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0;
  $6 = 0;
  $4 = 1;
  $0_1 = $0_1 + $4 | 0;
  $5 = $1_1 + $6 | 0;
  if ($0_1 >>> 0 < $4 >>> 0) {
   $5 = $5 + 1 | 0
  }
  $7 = $0_1;
  $8 = $5;
  $5 = $3_1;
  $1_1 = $2_1;
  $0_1 = 0;
  $4 = 1;
  $6 = $1_1 + $4 | 0;
  $0_1 = $5 + $0_1 | 0;
  if ($6 >>> 0 < $4 >>> 0) {
   $0_1 = $0_1 + 1 | 0
  }
  $1_1 = $0_1;
  $0_1 = $8;
  $5 = $7;
  $4 = $6;
  return $0_1 >>> 0 < $1_1 >>> 0 | (($0_1 | 0) == ($1_1 | 0) & $5 >>> 0 < $4 >>> 0 | 0) | 0 | 0;
 }
 
 function legalstub$2($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0;
  $6 = 0;
  $7 = $0_1;
  $8 = $6;
  $6 = 0;
  $4 = 32;
  $5 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0_1 = $1_1 << $5 | 0;
    $4 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $5 | 0) - 1 | 0) & ($1_1 >>> (32 - $5 | 0) | 0) | 0 | ($6 << $5 | 0) | 0;
    $4 = $1_1 << $5 | 0;
   }
  }
  $1_1 = $0_1;
  $0_1 = $8;
  $6 = $7;
  $1_1 = $0_1 | $1_1 | 0;
  $9 = $6 | $4 | 0;
  $7 = $1_1;
  $1_1 = 0;
  $8 = $1_1;
  $1_1 = 0;
  $0_1 = $3_1;
  $4 = 32;
  $5 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $6 = $0_1 << $5 | 0;
    $4 = 0;
   }
  } else {
   {
    $6 = ((1 << $5 | 0) - 1 | 0) & ($0_1 >>> (32 - $5 | 0) | 0) | 0 | ($1_1 << $5 | 0) | 0;
    $4 = $0_1 << $5 | 0;
   }
  }
  $0_1 = $6;
  $6 = $8;
  $1_1 = $2_1;
  $0_1 = $6 | $0_1 | 0;
  $2_1 = $1_1 | $4 | 0;
  $1_1 = $0_1;
  $0_1 = $7;
  return $2($9 | 0, $0_1 | 0, $2_1 | 0, $1_1 | 0) | 0 | 0;
 }
 
 function legalstub$3($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0;
  $6 = 0;
  $7 = $0_1;
  $8 = $6;
  $6 = 0;
  $4 = 32;
  $5 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0_1 = $1_1 << $5 | 0;
    $4 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $5 | 0) - 1 | 0) & ($1_1 >>> (32 - $5 | 0) | 0) | 0 | ($6 << $5 | 0) | 0;
    $4 = $1_1 << $5 | 0;
   }
  }
  $1_1 = $0_1;
  $0_1 = $8;
  $6 = $7;
  $1_1 = $0_1 | $1_1 | 0;
  $9 = $6 | $4 | 0;
  $7 = $1_1;
  $1_1 = 0;
  $8 = $1_1;
  $1_1 = 0;
  $0_1 = $3_1;
  $4 = 32;
  $5 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $6 = $0_1 << $5 | 0;
    $4 = 0;
   }
  } else {
   {
    $6 = ((1 << $5 | 0) - 1 | 0) & ($0_1 >>> (32 - $5 | 0) | 0) | 0 | ($1_1 << $5 | 0) | 0;
    $4 = $0_1 << $5 | 0;
   }
  }
  $0_1 = $6;
  $6 = $8;
  $1_1 = $2_1;
  $0_1 = $6 | $0_1 | 0;
  $2_1 = $1_1 | $4 | 0;
  $1_1 = $0_1;
  $0_1 = $7;
  return $3($9 | 0, $0_1 | 0, $2_1 | 0, $1_1 | 0) | 0 | 0;
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
 function $0($0_1, $1) {
  $0_1 = $0_1 | 0;
  $1 = $1 | 0;
  $1 = $0_1 >> 31 | 0;
  i64toi32_i32$HIGH_BITS = $1;
  return $0_1 | 0;
 }
 
 function legalstub$0($0_1, $1) {
  $0_1 = $0_1 | 0;
  $1 = $1 | 0;
  var $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0;
  $3 = 0;
  $5 = $0_1;
  $6 = $3;
  $3 = 0;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0_1 = $1 << $2 | 0;
    $4 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $2 | 0) - 1 | 0) & ($1 >>> (32 - $2 | 0) | 0) | 0 | ($3 << $2 | 0) | 0;
    $4 = $1 << $2 | 0;
   }
  }
  $1 = $0_1;
  $0_1 = $6;
  $3 = $5;
  $1 = $0_1 | $1 | 0;
  $1 = $0($3 | $4 | 0 | 0, $1 | 0) | 0;
  $3 = i64toi32_i32$HIGH_BITS;
  $6 = $1;
  $5 = $3;
  $0_1 = $1;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0_1 = $3 >>> $2 | 0
  } else {
   $0_1 = (((1 << $2 | 0) - 1 | 0) & $3 | 0) << (32 - $2 | 0) | 0 | ($0_1 >>> $2 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $6 | 0;
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
 function $0($0_1, $1) {
  $0_1 = $0_1 | 0;
  $1 = $1 | 0;
  $1 = 0;
  i64toi32_i32$HIGH_BITS = $1;
  return $0_1 | 0;
 }
 
 function legalstub$0($0_1, $1) {
  $0_1 = $0_1 | 0;
  $1 = $1 | 0;
  var $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0;
  $3 = 0;
  $5 = $0_1;
  $6 = $3;
  $3 = 0;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0_1 = $1 << $2 | 0;
    $4 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $2 | 0) - 1 | 0) & ($1 >>> (32 - $2 | 0) | 0) | 0 | ($3 << $2 | 0) | 0;
    $4 = $1 << $2 | 0;
   }
  }
  $1 = $0_1;
  $0_1 = $6;
  $3 = $5;
  $1 = $0_1 | $1 | 0;
  $1 = $0($3 | $4 | 0 | 0, $1 | 0) | 0;
  $3 = i64toi32_i32$HIGH_BITS;
  $6 = $1;
  $5 = $3;
  $0_1 = $1;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0_1 = $3 >>> $2 | 0
  } else {
   $0_1 = (((1 << $2 | 0) - 1 | 0) & $3 | 0) << (32 - $2 | 0) | 0 | ($0_1 >>> $2 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $6 | 0;
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
 function $0($0_1) {
  $0_1 = $0_1 | 0;
  return ($0_1 << 1 | 0) >> 1 | 0 | 0;
 }
 
 function $1($0_1) {
  $0_1 = $0_1 | 0;
  return ($0_1 << 1 | 0) >>> 1 | 0 | 0;
 }
 
 function $2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0;
  $3_1 = 1;
  $2_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   {
    $4 = $0_1 << $2_1 | 0;
    $1_1 = 0;
   }
  } else {
   {
    $4 = ((1 << $2_1 | 0) - 1 | 0) & ($0_1 >>> (32 - $2_1 | 0) | 0) | 0 | ($1_1 << $2_1 | 0) | 0;
    $1_1 = $0_1 << $2_1 | 0;
   }
  }
  $3_1 = 1;
  $2_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   {
    $0_1 = $4 >> 31 | 0;
    $1_1 = $4 >> $2_1 | 0;
   }
  } else {
   {
    $0_1 = $4 >> $2_1 | 0;
    $1_1 = (((1 << $2_1 | 0) - 1 | 0) & $4 | 0) << (32 - $2_1 | 0) | 0 | ($1_1 >>> $2_1 | 0) | 0;
   }
  }
  i64toi32_i32$HIGH_BITS = $0_1;
  return $1_1 | 0;
 }
 
 function $3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0;
  $3_1 = 1;
  $2_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   {
    $4 = $0_1 << $2_1 | 0;
    $1_1 = 0;
   }
  } else {
   {
    $4 = ((1 << $2_1 | 0) - 1 | 0) & ($0_1 >>> (32 - $2_1 | 0) | 0) | 0 | ($1_1 << $2_1 | 0) | 0;
    $1_1 = $0_1 << $2_1 | 0;
   }
  }
  $3_1 = 1;
  $2_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   {
    $0_1 = 0;
    $1_1 = $4 >>> $2_1 | 0;
   }
  } else {
   {
    $0_1 = $4 >>> $2_1 | 0;
    $1_1 = (((1 << $2_1 | 0) - 1 | 0) & $4 | 0) << (32 - $2_1 | 0) | 0 | ($1_1 >>> $2_1 | 0) | 0;
   }
  }
  i64toi32_i32$HIGH_BITS = $0_1;
  return $1_1 | 0;
 }
 
 function legalstub$2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0, $5 = 0, $6 = 0;
  $3_1 = 0;
  $5 = $0_1;
  $6 = $3_1;
  $3_1 = 0;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0_1 = $1_1 << $2_1 | 0;
    $4 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $2_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $2_1 | 0) | 0) | 0 | ($3_1 << $2_1 | 0) | 0;
    $4 = $1_1 << $2_1 | 0;
   }
  }
  $1_1 = $0_1;
  $0_1 = $6;
  $3_1 = $5;
  $1_1 = $0_1 | $1_1 | 0;
  $1_1 = $2($3_1 | $4 | 0 | 0, $1_1 | 0) | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  $6 = $1_1;
  $5 = $3_1;
  $0_1 = $1_1;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0_1 = $3_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $3_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $6 | 0;
 }
 
 function legalstub$3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0, $5 = 0, $6 = 0;
  $3_1 = 0;
  $5 = $0_1;
  $6 = $3_1;
  $3_1 = 0;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0_1 = $1_1 << $2_1 | 0;
    $4 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $2_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $2_1 | 0) | 0) | 0 | ($3_1 << $2_1 | 0) | 0;
    $4 = $1_1 << $2_1 | 0;
   }
  }
  $1_1 = $0_1;
  $0_1 = $6;
  $3_1 = $5;
  $1_1 = $0_1 | $1_1 | 0;
  $1_1 = $3($3_1 | $4 | 0 | 0, $1_1 | 0) | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  $6 = $1_1;
  $5 = $3_1;
  $0_1 = $1_1;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0_1 = $3_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $3_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $6 | 0;
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
 function $0($0_1) {
  $0_1 = $0_1 | 0;
  return ($0_1 >> 1 | 0) << 1 | 0 | 0;
 }
 
 function $1($0_1) {
  $0_1 = $0_1 | 0;
  return ($0_1 >>> 1 | 0) << 1 | 0 | 0;
 }
 
 function $2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0;
  $3_1 = 1;
  $2_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   {
    $4 = $1_1 >> 31 | 0;
    $1_1 = $1_1 >> $2_1 | 0;
   }
  } else {
   {
    $4 = $1_1 >> $2_1 | 0;
    $1_1 = (((1 << $2_1 | 0) - 1 | 0) & $1_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0;
   }
  }
  $3_1 = 1;
  $2_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   {
    $0_1 = $1_1 << $2_1 | 0;
    $1_1 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $2_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $2_1 | 0) | 0) | 0 | ($4 << $2_1 | 0) | 0;
    $1_1 = $1_1 << $2_1 | 0;
   }
  }
  i64toi32_i32$HIGH_BITS = $0_1;
  return $1_1 | 0;
 }
 
 function $3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0;
  $3_1 = 1;
  $2_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   {
    $4 = 0;
    $1_1 = $1_1 >>> $2_1 | 0;
   }
  } else {
   {
    $4 = $1_1 >>> $2_1 | 0;
    $1_1 = (((1 << $2_1 | 0) - 1 | 0) & $1_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0;
   }
  }
  $3_1 = 1;
  $2_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   {
    $0_1 = $1_1 << $2_1 | 0;
    $1_1 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $2_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $2_1 | 0) | 0) | 0 | ($4 << $2_1 | 0) | 0;
    $1_1 = $1_1 << $2_1 | 0;
   }
  }
  i64toi32_i32$HIGH_BITS = $0_1;
  return $1_1 | 0;
 }
 
 function legalstub$2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0, $5 = 0, $6 = 0;
  $3_1 = 0;
  $5 = $0_1;
  $6 = $3_1;
  $3_1 = 0;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0_1 = $1_1 << $2_1 | 0;
    $4 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $2_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $2_1 | 0) | 0) | 0 | ($3_1 << $2_1 | 0) | 0;
    $4 = $1_1 << $2_1 | 0;
   }
  }
  $1_1 = $0_1;
  $0_1 = $6;
  $3_1 = $5;
  $1_1 = $0_1 | $1_1 | 0;
  $1_1 = $2($3_1 | $4 | 0 | 0, $1_1 | 0) | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  $6 = $1_1;
  $5 = $3_1;
  $0_1 = $1_1;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0_1 = $3_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $3_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $6 | 0;
 }
 
 function legalstub$3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0, $5 = 0, $6 = 0;
  $3_1 = 0;
  $5 = $0_1;
  $6 = $3_1;
  $3_1 = 0;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0_1 = $1_1 << $2_1 | 0;
    $4 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $2_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $2_1 | 0) | 0) | 0 | ($3_1 << $2_1 | 0) | 0;
    $4 = $1_1 << $2_1 | 0;
   }
  }
  $1_1 = $0_1;
  $0_1 = $6;
  $3_1 = $5;
  $1_1 = $0_1 | $1_1 | 0;
  $1_1 = $3($3_1 | $4 | 0 | 0, $1_1 | 0) | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  $6 = $1_1;
  $5 = $3_1;
  $0_1 = $1_1;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0_1 = $3_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $3_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $6 | 0;
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
 function $0($0_1) {
  $0_1 = $0_1 | 0;
  return Math_imul(($0_1 | 0) / (6 | 0) | 0, 6) | 0;
 }
 
 function $1($0_1) {
  $0_1 = $0_1 | 0;
  return Math_imul(($0_1 >>> 0) / (6 >>> 0) | 0, 6) | 0;
 }
 
 function $2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0;
  $2_1 = 0;
  $2_1 = __wasm_i64_sdiv($0_1 | 0, $1_1 | 0, 6 | 0, $2_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  $0_1 = $2_1;
  $2_1 = 0;
  $2_1 = __wasm_i64_mul($0_1 | 0, $1_1 | 0, 6 | 0, $2_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $2_1 | 0;
 }
 
 function $3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0;
  $2_1 = 0;
  $2_1 = __wasm_i64_udiv($0_1 | 0, $1_1 | 0, 6 | 0, $2_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  $0_1 = $2_1;
  $2_1 = 0;
  $2_1 = __wasm_i64_mul($0_1 | 0, $1_1 | 0, 6 | 0, $2_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $2_1 | 0;
 }
 
 function legalstub$2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0, $5 = 0, $6 = 0;
  $3_1 = 0;
  $5 = $0_1;
  $6 = $3_1;
  $3_1 = 0;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0_1 = $1_1 << $2_1 | 0;
    $4 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $2_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $2_1 | 0) | 0) | 0 | ($3_1 << $2_1 | 0) | 0;
    $4 = $1_1 << $2_1 | 0;
   }
  }
  $1_1 = $0_1;
  $0_1 = $6;
  $3_1 = $5;
  $1_1 = $0_1 | $1_1 | 0;
  $1_1 = $2($3_1 | $4 | 0 | 0, $1_1 | 0) | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  $6 = $1_1;
  $5 = $3_1;
  $0_1 = $1_1;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0_1 = $3_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $3_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $6 | 0;
 }
 
 function legalstub$3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0, $5 = 0, $6 = 0;
  $3_1 = 0;
  $5 = $0_1;
  $6 = $3_1;
  $3_1 = 0;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0_1 = $1_1 << $2_1 | 0;
    $4 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $2_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $2_1 | 0) | 0) | 0 | ($3_1 << $2_1 | 0) | 0;
    $4 = $1_1 << $2_1 | 0;
   }
  }
  $1_1 = $0_1;
  $0_1 = $6;
  $3_1 = $5;
  $1_1 = $0_1 | $1_1 | 0;
  $1_1 = $3($3_1 | $4 | 0 | 0, $1_1 | 0) | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  $6 = $1_1;
  $5 = $3_1;
  $0_1 = $1_1;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0_1 = $3_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $3_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $6 | 0;
 }
 
 function legalfunc$wasm2js_scratch_store_i64($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0;
  $4 = $0_1;
  $3_1 = 32;
  $2_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   $0_1 = $1_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $1_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  legalimport$wasm2js_scratch_store_i64($4 | 0, $0_1 | 0);
 }
 
 function _ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0;
  $5 = $2_1;
  $9 = $5 >>> 16 | 0;
  $10 = $0_1 >>> 16 | 0;
  $11 = Math_imul($9, $10);
  $8 = $5;
  $6 = $0_1;
  $7 = 32;
  $4 = $7 & 31 | 0;
  if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
   $1_1 = $1_1 >>> $4 | 0
  } else {
   $1_1 = (((1 << $4 | 0) - 1 | 0) & $1_1 | 0) << (32 - $4 | 0) | 0 | ($6 >>> $4 | 0) | 0
  }
  $6 = $11 + Math_imul($8, $1_1) | 0;
  $1_1 = $2_1;
  $7 = 32;
  $4 = $7 & 31 | 0;
  if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
   $1_1 = $3_1 >>> $4 | 0
  } else {
   $1_1 = (((1 << $4 | 0) - 1 | 0) & $3_1 | 0) << (32 - $4 | 0) | 0 | ($1_1 >>> $4 | 0) | 0
  }
  $1_1 = $6 + Math_imul($1_1, $0_1) | 0;
  $5 = $5 & 65535 | 0;
  $0_1 = $0_1 & 65535 | 0;
  $8 = Math_imul($5, $0_1);
  $5 = ($8 >>> 16 | 0) + Math_imul($5, $10) | 0;
  $1_1 = $1_1 + ($5 >>> 16 | 0) | 0;
  $5 = ($5 & 65535 | 0) + Math_imul($9, $0_1) | 0;
  $6 = 0;
  $3_1 = $1_1 + ($5 >>> 16 | 0) | 0;
  $7 = 32;
  $4 = $7 & 31 | 0;
  if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
   {
    $1_1 = $3_1 << $4 | 0;
    $6 = 0;
   }
  } else {
   {
    $1_1 = ((1 << $4 | 0) - 1 | 0) & ($3_1 >>> (32 - $4 | 0) | 0) | 0 | ($6 << $4 | 0) | 0;
    $6 = $3_1 << $4 | 0;
   }
  }
  $0_1 = $1_1;
  $1_1 = 0;
  $2_1 = $1_1;
  $1_1 = $0_1;
  $3_1 = $2_1;
  $7 = $5 << 16 | 0 | ($8 & 65535 | 0) | 0;
  $3_1 = $1_1 | $3_1 | 0;
  $6 = $6 | $7 | 0;
  i64toi32_i32$HIGH_BITS = $3_1;
  return $6 | 0;
 }
 
 function _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0;
  $8 = $1_1;
  $7 = $0_1;
  $6 = 63;
  $5 = $6 & 31 | 0;
  if (32 >>> 0 <= ($6 & 63 | 0) >>> 0) {
   {
    $4 = $8 >> 31 | 0;
    $5 = $8 >> $5 | 0;
   }
  } else {
   {
    $4 = $8 >> $5 | 0;
    $5 = (((1 << $5 | 0) - 1 | 0) & $8 | 0) << (32 - $5 | 0) | 0 | ($7 >>> $5 | 0) | 0;
   }
  }
  $10 = $4;
  $4 = $10;
  $8 = $5;
  $7 = $1_1;
  $6 = $0_1;
  $7 = $4 ^ $7 | 0;
  $4 = $8 ^ $6 | 0;
  $8 = $10;
  $6 = $5;
  $5 = $4 - $6 | 0;
  $10 = $4 >>> 0 < $6 >>> 0;
  $9 = $10 + $8 | 0;
  $9 = $7 - $9 | 0;
  $11 = $5;
  $12 = $9;
  $9 = $3_1;
  $7 = $2_1;
  $6 = 63;
  $8 = $6 & 31 | 0;
  if (32 >>> 0 <= ($6 & 63 | 0) >>> 0) {
   {
    $4 = $9 >> 31 | 0;
    $5 = $9 >> $8 | 0;
   }
  } else {
   {
    $4 = $9 >> $8 | 0;
    $5 = (((1 << $8 | 0) - 1 | 0) & $9 | 0) << (32 - $8 | 0) | 0 | ($7 >>> $8 | 0) | 0;
   }
  }
  $10 = $4;
  $4 = $10;
  $9 = $5;
  $7 = $3_1;
  $6 = $2_1;
  $7 = $4 ^ $7 | 0;
  $4 = $9 ^ $6 | 0;
  $9 = $10;
  $6 = $5;
  $8 = $4 - $6 | 0;
  $10 = $4 >>> 0 < $6 >>> 0;
  $5 = $10 + $9 | 0;
  $5 = $7 - $5 | 0;
  $4 = $5;
  $5 = $12;
  $4 = __wasm_i64_udiv($11 | 0, $5 | 0, $8 | 0, $4 | 0) | 0;
  $5 = i64toi32_i32$HIGH_BITS;
  $10 = $4;
  $8 = $5;
  $5 = $3_1;
  $7 = $2_1;
  $4 = $1_1;
  $6 = $0_1;
  $4 = $5 ^ $4 | 0;
  $5 = $7 ^ $6 | 0;
  $6 = 63;
  $9 = $6 & 31 | 0;
  if (32 >>> 0 <= ($6 & 63 | 0) >>> 0) {
   {
    $7 = $4 >> 31 | 0;
    $0_1 = $4 >> $9 | 0;
   }
  } else {
   {
    $7 = $4 >> $9 | 0;
    $0_1 = (((1 << $9 | 0) - 1 | 0) & $4 | 0) << (32 - $9 | 0) | 0 | ($5 >>> $9 | 0) | 0;
   }
  }
  $1_1 = $7;
  $7 = $8;
  $4 = $10;
  $5 = $1_1;
  $6 = $0_1;
  $5 = $7 ^ $5 | 0;
  $7 = $4 ^ $6 | 0;
  $4 = $1_1;
  $9 = $7 - $6 | 0;
  $10 = $7 >>> 0 < $6 >>> 0;
  $8 = $10 + $4 | 0;
  $8 = $5 - $8 | 0;
  $7 = $9;
  i64toi32_i32$HIGH_BITS = $8;
  return $7 | 0;
 }
 
 function _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0, $13 = 0, $14 = 0, $15 = 0, $16 = 0, $17 = 0, $18 = 0, $19 = 0, $20 = 0;
  label$1 : {
   label$2 : {
    label$3 : {
     label$4 : {
      label$5 : {
       label$6 : {
        label$7 : {
         label$8 : {
          label$9 : {
           label$11 : {
            $7 = $1_1;
            $5 = $0_1;
            $4 = 32;
            $6 = $4 & 31 | 0;
            if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
             $10 = $7 >>> $6 | 0
            } else {
             $10 = (((1 << $6 | 0) - 1 | 0) & $7 | 0) << (32 - $6 | 0) | 0 | ($5 >>> $6 | 0) | 0
            }
            if ($10) {
             {
              $8 = $2_1;
              if (!$8) {
               break label$11
              }
              $9 = $3_1;
              $7 = $2_1;
              $4 = 32;
              $6 = $4 & 31 | 0;
              if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
               $11 = $9 >>> $6 | 0
              } else {
               $11 = (((1 << $6 | 0) - 1 | 0) & $9 | 0) << (32 - $6 | 0) | 0 | ($7 >>> $6 | 0) | 0
              }
              if (!$11) {
               break label$9
              }
              $10 = Math_clz32($11) - Math_clz32($10) | 0;
              if ($10 >>> 0 <= 31 >>> 0) {
               break label$8
              }
              break label$2;
             }
            }
            $5 = $3_1;
            $9 = $2_1;
            $7 = 1;
            $4 = 0;
            if ($5 >>> 0 > $7 >>> 0 | (($5 | 0) == ($7 | 0) & $9 >>> 0 >= $4 >>> 0 | 0) | 0) {
             break label$2
            }
            $10 = $0_1;
            $8 = $2_1;
            $10 = ($10 >>> 0) / ($8 >>> 0) | 0;
            $9 = 0;
            legalfunc$wasm2js_scratch_store_i64($0_1 - Math_imul($10, $8) | 0 | 0, $9 | 0);
            $9 = 0;
            $5 = $10;
            i64toi32_i32$HIGH_BITS = $9;
            return $5 | 0;
           }
           $5 = $3_1;
           $4 = $2_1;
           $7 = 32;
           $6 = $7 & 31 | 0;
           if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
            $8 = $5 >>> $6 | 0
           } else {
            $8 = (((1 << $6 | 0) - 1 | 0) & $5 | 0) << (32 - $6 | 0) | 0 | ($4 >>> $6 | 0) | 0
           }
           if (!$0_1) {
            break label$7
           }
           if (!$8) {
            break label$6
           }
           $11 = $8 + -1 | 0;
           if ($11 & $8 | 0) {
            break label$6
           }
           $9 = 0;
           $5 = $11 & $10 | 0;
           $7 = 32;
           $6 = $7 & 31 | 0;
           if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
            {
             $4 = $5 << $6 | 0;
             $3_1 = 0;
            }
           } else {
            {
             $4 = ((1 << $6 | 0) - 1 | 0) & ($5 >>> (32 - $6 | 0) | 0) | 0 | ($9 << $6 | 0) | 0;
             $3_1 = $5 << $6 | 0;
            }
           }
           $2_1 = $4;
           $4 = $1_1;
           $9 = $0_1;
           $5 = 0;
           $7 = -1;
           $5 = $4 & $5 | 0;
           $7 = $9 & $7 | 0;
           $9 = $5;
           $5 = $2_1;
           $4 = $3_1;
           $9 = $5 | $9 | 0;
           legalfunc$wasm2js_scratch_store_i64($4 | $7 | 0 | 0, $9 | 0);
           $9 = 0;
           $4 = $10 >>> ((__wasm_ctz_i32($8 | 0) | 0) & 31 | 0) | 0;
           i64toi32_i32$HIGH_BITS = $9;
           return $4 | 0;
          }
          $11 = $8 + -1 | 0;
          if (!($11 & $8 | 0)) {
           break label$5
          }
          $10 = (Math_clz32($8) + 33 | 0) - Math_clz32($10) | 0;
          $8 = 0 - $10 | 0;
          break label$3;
         }
         $8 = 63 - $10 | 0;
         $10 = $10 + 1 | 0;
         break label$3;
        }
        $11 = ($10 >>> 0) / ($8 >>> 0) | 0;
        $4 = 0;
        $5 = $10 - Math_imul($11, $8) | 0;
        $7 = 32;
        $6 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $9 = $5 << $6 | 0;
          $0_1 = 0;
         }
        } else {
         {
          $9 = ((1 << $6 | 0) - 1 | 0) & ($5 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
          $0_1 = $5 << $6 | 0;
         }
        }
        legalfunc$wasm2js_scratch_store_i64($0_1 | 0, $9 | 0);
        $9 = 0;
        $5 = $11;
        i64toi32_i32$HIGH_BITS = $9;
        return $5 | 0;
       }
       $10 = Math_clz32($8) - Math_clz32($10) | 0;
       if ($10 >>> 0 < 31 >>> 0) {
        break label$4
       }
       break label$2;
      }
      $5 = 0;
      legalfunc$wasm2js_scratch_store_i64($11 & $0_1 | 0 | 0, $5 | 0);
      if (($8 | 0) == (1 | 0)) {
       break label$1
      }
      $5 = 0;
      $9 = $5;
      $5 = $1_1;
      $4 = $0_1;
      $7 = __wasm_ctz_i32($8 | 0) | 0;
      $6 = $7 & 31 | 0;
      if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
       {
        $9 = 0;
        $4 = $5 >>> $6 | 0;
       }
      } else {
       {
        $9 = $5 >>> $6 | 0;
        $4 = (((1 << $6 | 0) - 1 | 0) & $5 | 0) << (32 - $6 | 0) | 0 | ($4 >>> $6 | 0) | 0;
       }
      }
      i64toi32_i32$HIGH_BITS = $9;
      return $4 | 0;
     }
     $8 = 63 - $10 | 0;
     $10 = $10 + 1 | 0;
    }
    $4 = 0;
    $9 = $4;
    $4 = $1_1;
    $5 = $0_1;
    $7 = $10 & 63 | 0;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $9 = 0;
      $13 = $4 >>> $6 | 0;
     }
    } else {
     {
      $9 = $4 >>> $6 | 0;
      $13 = (((1 << $6 | 0) - 1 | 0) & $4 | 0) << (32 - $6 | 0) | 0 | ($5 >>> $6 | 0) | 0;
     }
    }
    $11 = $9;
    $9 = 0;
    $5 = $9;
    $9 = $1_1;
    $4 = $0_1;
    $7 = $8 & 63 | 0;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $5 = $4 << $6 | 0;
      $0_1 = 0;
     }
    } else {
     {
      $5 = ((1 << $6 | 0) - 1 | 0) & ($4 >>> (32 - $6 | 0) | 0) | 0 | ($9 << $6 | 0) | 0;
      $0_1 = $4 << $6 | 0;
     }
    }
    $1_1 = $5;
    label$13 : {
     if ($10) {
      {
       $5 = $3_1;
       $9 = $2_1;
       $4 = -1;
       $7 = -1;
       $6 = $9 + $7 | 0;
       $8 = $5 + $4 | 0;
       if ($6 >>> 0 < $7 >>> 0) {
        $8 = $8 + 1 | 0
       }
       $17 = $6;
       $15 = $8;
       label$15 : while (1) {
        $8 = $11;
        $5 = $13;
        $7 = 1;
        $4 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $9 = $5 << $4 | 0;
          $12 = 0;
         }
        } else {
         {
          $9 = ((1 << $4 | 0) - 1 | 0) & ($5 >>> (32 - $4 | 0) | 0) | 0 | ($8 << $4 | 0) | 0;
          $12 = $5 << $4 | 0;
         }
        }
        $11 = $9;
        $9 = $1_1;
        $8 = $0_1;
        $7 = 63;
        $4 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = 0;
          $7 = $9 >>> $4 | 0;
         }
        } else {
         {
          $5 = $9 >>> $4 | 0;
          $7 = (((1 << $4 | 0) - 1 | 0) & $9 | 0) << (32 - $4 | 0) | 0 | ($8 >>> $4 | 0) | 0;
         }
        }
        $8 = $5;
        $5 = $11;
        $9 = $12;
        $8 = $5 | $8 | 0;
        $13 = $9 | $7 | 0;
        $11 = $8;
        $18 = $13;
        $19 = $8;
        $8 = $15;
        $5 = $17;
        $9 = $11;
        $7 = $13;
        $4 = $5 - $7 | 0;
        $5 = $5 >>> 0 < $7 >>> 0;
        $6 = $5 + $9 | 0;
        $6 = $8 - $6 | 0;
        $8 = $4;
        $7 = 63;
        $9 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = $6 >> 31 | 0;
          $14 = $6 >> $9 | 0;
         }
        } else {
         {
          $5 = $6 >> $9 | 0;
          $14 = (((1 << $9 | 0) - 1 | 0) & $6 | 0) << (32 - $9 | 0) | 0 | ($8 >>> $9 | 0) | 0;
         }
        }
        $12 = $5;
        $5 = $12;
        $6 = $14;
        $8 = $3_1;
        $7 = $2_1;
        $8 = $5 & $8 | 0;
        $7 = $6 & $7 | 0;
        $6 = $8;
        $8 = $19;
        $5 = $18;
        $9 = $5 - $7 | 0;
        $5 = $5 >>> 0 < $7 >>> 0;
        $4 = $5 + $6 | 0;
        $4 = $8 - $4 | 0;
        $13 = $9;
        $11 = $4;
        $4 = $1_1;
        $8 = $0_1;
        $7 = 1;
        $6 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = $8 << $6 | 0;
          $4 = 0;
         }
        } else {
         {
          $5 = ((1 << $6 | 0) - 1 | 0) & ($8 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
          $4 = $8 << $6 | 0;
         }
        }
        $8 = $16;
        $7 = $20;
        $8 = $5 | $8 | 0;
        $0_1 = $4 | $7 | 0;
        $1_1 = $8;
        $8 = $12;
        $5 = $14;
        $4 = 0;
        $7 = 1;
        $4 = $8 & $4 | 0;
        $14 = $5 & $7 | 0;
        $12 = $4;
        $20 = $14;
        $16 = $4;
        $10 = $10 + -1 | 0;
        if ($10) {
         continue label$15
        }
        break label$15;
       };
       break label$13;
      }
     }
    }
    $4 = $11;
    legalfunc$wasm2js_scratch_store_i64($13 | 0, $4 | 0);
    $4 = $1_1;
    $8 = $0_1;
    $7 = 1;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $5 = $8 << $6 | 0;
      $4 = 0;
     }
    } else {
     {
      $5 = ((1 << $6 | 0) - 1 | 0) & ($8 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
      $4 = $8 << $6 | 0;
     }
    }
    $8 = $12;
    $7 = $14;
    $8 = $5 | $8 | 0;
    $4 = $4 | $7 | 0;
    i64toi32_i32$HIGH_BITS = $8;
    return $4 | 0;
   }
   $4 = $1_1;
   legalfunc$wasm2js_scratch_store_i64($0_1 | 0, $4 | 0);
   $4 = 0;
   $0_1 = 0;
   $1_1 = $4;
  }
  $4 = $1_1;
  $8 = $0_1;
  i64toi32_i32$HIGH_BITS = $4;
  return $8 | 0;
 }
 
 function __wasm_i64_mul($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  $3_1 = _ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE($0_1 | 0, $1_1 | 0, $2_1 | 0, $3_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $3_1 | 0;
 }
 
 function __wasm_i64_sdiv($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  $3_1 = _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E($0_1 | 0, $1_1 | 0, $2_1 | 0, $3_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $3_1 | 0;
 }
 
 function __wasm_i64_udiv($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  $3_1 = _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0_1 | 0, $1_1 | 0, $2_1 | 0, $3_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $3_1 | 0;
 }
 
 function __wasm_ctz_i32($0_1) {
  $0_1 = $0_1 | 0;
  if ($0_1) {
   return 31 - Math_clz32(($0_1 + -1 | 0) ^ $0_1 | 0) | 0 | 0
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
 function $0($0_1) {
  $0_1 = $0_1 | 0;
  return (Math_imul($0_1, 6) | 0) / (6 | 0) | 0 | 0;
 }
 
 function $1($0_1) {
  $0_1 = $0_1 | 0;
  return (Math_imul($0_1, 6) >>> 0) / (6 >>> 0) | 0 | 0;
 }
 
 function $2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0;
  $2_1 = 0;
  $2_1 = __wasm_i64_mul($0_1 | 0, $1_1 | 0, 6 | 0, $2_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  $0_1 = $2_1;
  $2_1 = 0;
  $2_1 = __wasm_i64_sdiv($0_1 | 0, $1_1 | 0, 6 | 0, $2_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $2_1 | 0;
 }
 
 function $3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0;
  $2_1 = 0;
  $2_1 = __wasm_i64_mul($0_1 | 0, $1_1 | 0, 6 | 0, $2_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  $0_1 = $2_1;
  $2_1 = 0;
  $2_1 = __wasm_i64_udiv($0_1 | 0, $1_1 | 0, 6 | 0, $2_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $2_1 | 0;
 }
 
 function legalstub$2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0, $5 = 0, $6 = 0;
  $3_1 = 0;
  $5 = $0_1;
  $6 = $3_1;
  $3_1 = 0;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0_1 = $1_1 << $2_1 | 0;
    $4 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $2_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $2_1 | 0) | 0) | 0 | ($3_1 << $2_1 | 0) | 0;
    $4 = $1_1 << $2_1 | 0;
   }
  }
  $1_1 = $0_1;
  $0_1 = $6;
  $3_1 = $5;
  $1_1 = $0_1 | $1_1 | 0;
  $1_1 = $2($3_1 | $4 | 0 | 0, $1_1 | 0) | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  $6 = $1_1;
  $5 = $3_1;
  $0_1 = $1_1;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0_1 = $3_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $3_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $6 | 0;
 }
 
 function legalstub$3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0, $5 = 0, $6 = 0;
  $3_1 = 0;
  $5 = $0_1;
  $6 = $3_1;
  $3_1 = 0;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0_1 = $1_1 << $2_1 | 0;
    $4 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $2_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $2_1 | 0) | 0) | 0 | ($3_1 << $2_1 | 0) | 0;
    $4 = $1_1 << $2_1 | 0;
   }
  }
  $1_1 = $0_1;
  $0_1 = $6;
  $3_1 = $5;
  $1_1 = $0_1 | $1_1 | 0;
  $1_1 = $3($3_1 | $4 | 0 | 0, $1_1 | 0) | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  $6 = $1_1;
  $5 = $3_1;
  $0_1 = $1_1;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0_1 = $3_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $3_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $6 | 0;
 }
 
 function legalfunc$wasm2js_scratch_store_i64($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0;
  $4 = $0_1;
  $3_1 = 32;
  $2_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   $0_1 = $1_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $1_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  legalimport$wasm2js_scratch_store_i64($4 | 0, $0_1 | 0);
 }
 
 function _ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0;
  $5 = $2_1;
  $9 = $5 >>> 16 | 0;
  $10 = $0_1 >>> 16 | 0;
  $11 = Math_imul($9, $10);
  $8 = $5;
  $6 = $0_1;
  $7 = 32;
  $4 = $7 & 31 | 0;
  if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
   $1_1 = $1_1 >>> $4 | 0
  } else {
   $1_1 = (((1 << $4 | 0) - 1 | 0) & $1_1 | 0) << (32 - $4 | 0) | 0 | ($6 >>> $4 | 0) | 0
  }
  $6 = $11 + Math_imul($8, $1_1) | 0;
  $1_1 = $2_1;
  $7 = 32;
  $4 = $7 & 31 | 0;
  if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
   $1_1 = $3_1 >>> $4 | 0
  } else {
   $1_1 = (((1 << $4 | 0) - 1 | 0) & $3_1 | 0) << (32 - $4 | 0) | 0 | ($1_1 >>> $4 | 0) | 0
  }
  $1_1 = $6 + Math_imul($1_1, $0_1) | 0;
  $5 = $5 & 65535 | 0;
  $0_1 = $0_1 & 65535 | 0;
  $8 = Math_imul($5, $0_1);
  $5 = ($8 >>> 16 | 0) + Math_imul($5, $10) | 0;
  $1_1 = $1_1 + ($5 >>> 16 | 0) | 0;
  $5 = ($5 & 65535 | 0) + Math_imul($9, $0_1) | 0;
  $6 = 0;
  $3_1 = $1_1 + ($5 >>> 16 | 0) | 0;
  $7 = 32;
  $4 = $7 & 31 | 0;
  if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
   {
    $1_1 = $3_1 << $4 | 0;
    $6 = 0;
   }
  } else {
   {
    $1_1 = ((1 << $4 | 0) - 1 | 0) & ($3_1 >>> (32 - $4 | 0) | 0) | 0 | ($6 << $4 | 0) | 0;
    $6 = $3_1 << $4 | 0;
   }
  }
  $0_1 = $1_1;
  $1_1 = 0;
  $2_1 = $1_1;
  $1_1 = $0_1;
  $3_1 = $2_1;
  $7 = $5 << 16 | 0 | ($8 & 65535 | 0) | 0;
  $3_1 = $1_1 | $3_1 | 0;
  $6 = $6 | $7 | 0;
  i64toi32_i32$HIGH_BITS = $3_1;
  return $6 | 0;
 }
 
 function _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0;
  $8 = $1_1;
  $7 = $0_1;
  $6 = 63;
  $5 = $6 & 31 | 0;
  if (32 >>> 0 <= ($6 & 63 | 0) >>> 0) {
   {
    $4 = $8 >> 31 | 0;
    $5 = $8 >> $5 | 0;
   }
  } else {
   {
    $4 = $8 >> $5 | 0;
    $5 = (((1 << $5 | 0) - 1 | 0) & $8 | 0) << (32 - $5 | 0) | 0 | ($7 >>> $5 | 0) | 0;
   }
  }
  $10 = $4;
  $4 = $10;
  $8 = $5;
  $7 = $1_1;
  $6 = $0_1;
  $7 = $4 ^ $7 | 0;
  $4 = $8 ^ $6 | 0;
  $8 = $10;
  $6 = $5;
  $5 = $4 - $6 | 0;
  $10 = $4 >>> 0 < $6 >>> 0;
  $9 = $10 + $8 | 0;
  $9 = $7 - $9 | 0;
  $11 = $5;
  $12 = $9;
  $9 = $3_1;
  $7 = $2_1;
  $6 = 63;
  $8 = $6 & 31 | 0;
  if (32 >>> 0 <= ($6 & 63 | 0) >>> 0) {
   {
    $4 = $9 >> 31 | 0;
    $5 = $9 >> $8 | 0;
   }
  } else {
   {
    $4 = $9 >> $8 | 0;
    $5 = (((1 << $8 | 0) - 1 | 0) & $9 | 0) << (32 - $8 | 0) | 0 | ($7 >>> $8 | 0) | 0;
   }
  }
  $10 = $4;
  $4 = $10;
  $9 = $5;
  $7 = $3_1;
  $6 = $2_1;
  $7 = $4 ^ $7 | 0;
  $4 = $9 ^ $6 | 0;
  $9 = $10;
  $6 = $5;
  $8 = $4 - $6 | 0;
  $10 = $4 >>> 0 < $6 >>> 0;
  $5 = $10 + $9 | 0;
  $5 = $7 - $5 | 0;
  $4 = $5;
  $5 = $12;
  $4 = __wasm_i64_udiv($11 | 0, $5 | 0, $8 | 0, $4 | 0) | 0;
  $5 = i64toi32_i32$HIGH_BITS;
  $10 = $4;
  $8 = $5;
  $5 = $3_1;
  $7 = $2_1;
  $4 = $1_1;
  $6 = $0_1;
  $4 = $5 ^ $4 | 0;
  $5 = $7 ^ $6 | 0;
  $6 = 63;
  $9 = $6 & 31 | 0;
  if (32 >>> 0 <= ($6 & 63 | 0) >>> 0) {
   {
    $7 = $4 >> 31 | 0;
    $0_1 = $4 >> $9 | 0;
   }
  } else {
   {
    $7 = $4 >> $9 | 0;
    $0_1 = (((1 << $9 | 0) - 1 | 0) & $4 | 0) << (32 - $9 | 0) | 0 | ($5 >>> $9 | 0) | 0;
   }
  }
  $1_1 = $7;
  $7 = $8;
  $4 = $10;
  $5 = $1_1;
  $6 = $0_1;
  $5 = $7 ^ $5 | 0;
  $7 = $4 ^ $6 | 0;
  $4 = $1_1;
  $9 = $7 - $6 | 0;
  $10 = $7 >>> 0 < $6 >>> 0;
  $8 = $10 + $4 | 0;
  $8 = $5 - $8 | 0;
  $7 = $9;
  i64toi32_i32$HIGH_BITS = $8;
  return $7 | 0;
 }
 
 function _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0, $13 = 0, $14 = 0, $15 = 0, $16 = 0, $17 = 0, $18 = 0, $19 = 0, $20 = 0;
  label$1 : {
   label$2 : {
    label$3 : {
     label$4 : {
      label$5 : {
       label$6 : {
        label$7 : {
         label$8 : {
          label$9 : {
           label$11 : {
            $7 = $1_1;
            $5 = $0_1;
            $4 = 32;
            $6 = $4 & 31 | 0;
            if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
             $10 = $7 >>> $6 | 0
            } else {
             $10 = (((1 << $6 | 0) - 1 | 0) & $7 | 0) << (32 - $6 | 0) | 0 | ($5 >>> $6 | 0) | 0
            }
            if ($10) {
             {
              $8 = $2_1;
              if (!$8) {
               break label$11
              }
              $9 = $3_1;
              $7 = $2_1;
              $4 = 32;
              $6 = $4 & 31 | 0;
              if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
               $11 = $9 >>> $6 | 0
              } else {
               $11 = (((1 << $6 | 0) - 1 | 0) & $9 | 0) << (32 - $6 | 0) | 0 | ($7 >>> $6 | 0) | 0
              }
              if (!$11) {
               break label$9
              }
              $10 = Math_clz32($11) - Math_clz32($10) | 0;
              if ($10 >>> 0 <= 31 >>> 0) {
               break label$8
              }
              break label$2;
             }
            }
            $5 = $3_1;
            $9 = $2_1;
            $7 = 1;
            $4 = 0;
            if ($5 >>> 0 > $7 >>> 0 | (($5 | 0) == ($7 | 0) & $9 >>> 0 >= $4 >>> 0 | 0) | 0) {
             break label$2
            }
            $10 = $0_1;
            $8 = $2_1;
            $10 = ($10 >>> 0) / ($8 >>> 0) | 0;
            $9 = 0;
            legalfunc$wasm2js_scratch_store_i64($0_1 - Math_imul($10, $8) | 0 | 0, $9 | 0);
            $9 = 0;
            $5 = $10;
            i64toi32_i32$HIGH_BITS = $9;
            return $5 | 0;
           }
           $5 = $3_1;
           $4 = $2_1;
           $7 = 32;
           $6 = $7 & 31 | 0;
           if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
            $8 = $5 >>> $6 | 0
           } else {
            $8 = (((1 << $6 | 0) - 1 | 0) & $5 | 0) << (32 - $6 | 0) | 0 | ($4 >>> $6 | 0) | 0
           }
           if (!$0_1) {
            break label$7
           }
           if (!$8) {
            break label$6
           }
           $11 = $8 + -1 | 0;
           if ($11 & $8 | 0) {
            break label$6
           }
           $9 = 0;
           $5 = $11 & $10 | 0;
           $7 = 32;
           $6 = $7 & 31 | 0;
           if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
            {
             $4 = $5 << $6 | 0;
             $3_1 = 0;
            }
           } else {
            {
             $4 = ((1 << $6 | 0) - 1 | 0) & ($5 >>> (32 - $6 | 0) | 0) | 0 | ($9 << $6 | 0) | 0;
             $3_1 = $5 << $6 | 0;
            }
           }
           $2_1 = $4;
           $4 = $1_1;
           $9 = $0_1;
           $5 = 0;
           $7 = -1;
           $5 = $4 & $5 | 0;
           $7 = $9 & $7 | 0;
           $9 = $5;
           $5 = $2_1;
           $4 = $3_1;
           $9 = $5 | $9 | 0;
           legalfunc$wasm2js_scratch_store_i64($4 | $7 | 0 | 0, $9 | 0);
           $9 = 0;
           $4 = $10 >>> ((__wasm_ctz_i32($8 | 0) | 0) & 31 | 0) | 0;
           i64toi32_i32$HIGH_BITS = $9;
           return $4 | 0;
          }
          $11 = $8 + -1 | 0;
          if (!($11 & $8 | 0)) {
           break label$5
          }
          $10 = (Math_clz32($8) + 33 | 0) - Math_clz32($10) | 0;
          $8 = 0 - $10 | 0;
          break label$3;
         }
         $8 = 63 - $10 | 0;
         $10 = $10 + 1 | 0;
         break label$3;
        }
        $11 = ($10 >>> 0) / ($8 >>> 0) | 0;
        $4 = 0;
        $5 = $10 - Math_imul($11, $8) | 0;
        $7 = 32;
        $6 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $9 = $5 << $6 | 0;
          $0_1 = 0;
         }
        } else {
         {
          $9 = ((1 << $6 | 0) - 1 | 0) & ($5 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
          $0_1 = $5 << $6 | 0;
         }
        }
        legalfunc$wasm2js_scratch_store_i64($0_1 | 0, $9 | 0);
        $9 = 0;
        $5 = $11;
        i64toi32_i32$HIGH_BITS = $9;
        return $5 | 0;
       }
       $10 = Math_clz32($8) - Math_clz32($10) | 0;
       if ($10 >>> 0 < 31 >>> 0) {
        break label$4
       }
       break label$2;
      }
      $5 = 0;
      legalfunc$wasm2js_scratch_store_i64($11 & $0_1 | 0 | 0, $5 | 0);
      if (($8 | 0) == (1 | 0)) {
       break label$1
      }
      $5 = 0;
      $9 = $5;
      $5 = $1_1;
      $4 = $0_1;
      $7 = __wasm_ctz_i32($8 | 0) | 0;
      $6 = $7 & 31 | 0;
      if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
       {
        $9 = 0;
        $4 = $5 >>> $6 | 0;
       }
      } else {
       {
        $9 = $5 >>> $6 | 0;
        $4 = (((1 << $6 | 0) - 1 | 0) & $5 | 0) << (32 - $6 | 0) | 0 | ($4 >>> $6 | 0) | 0;
       }
      }
      i64toi32_i32$HIGH_BITS = $9;
      return $4 | 0;
     }
     $8 = 63 - $10 | 0;
     $10 = $10 + 1 | 0;
    }
    $4 = 0;
    $9 = $4;
    $4 = $1_1;
    $5 = $0_1;
    $7 = $10 & 63 | 0;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $9 = 0;
      $13 = $4 >>> $6 | 0;
     }
    } else {
     {
      $9 = $4 >>> $6 | 0;
      $13 = (((1 << $6 | 0) - 1 | 0) & $4 | 0) << (32 - $6 | 0) | 0 | ($5 >>> $6 | 0) | 0;
     }
    }
    $11 = $9;
    $9 = 0;
    $5 = $9;
    $9 = $1_1;
    $4 = $0_1;
    $7 = $8 & 63 | 0;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $5 = $4 << $6 | 0;
      $0_1 = 0;
     }
    } else {
     {
      $5 = ((1 << $6 | 0) - 1 | 0) & ($4 >>> (32 - $6 | 0) | 0) | 0 | ($9 << $6 | 0) | 0;
      $0_1 = $4 << $6 | 0;
     }
    }
    $1_1 = $5;
    label$13 : {
     if ($10) {
      {
       $5 = $3_1;
       $9 = $2_1;
       $4 = -1;
       $7 = -1;
       $6 = $9 + $7 | 0;
       $8 = $5 + $4 | 0;
       if ($6 >>> 0 < $7 >>> 0) {
        $8 = $8 + 1 | 0
       }
       $17 = $6;
       $15 = $8;
       label$15 : while (1) {
        $8 = $11;
        $5 = $13;
        $7 = 1;
        $4 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $9 = $5 << $4 | 0;
          $12 = 0;
         }
        } else {
         {
          $9 = ((1 << $4 | 0) - 1 | 0) & ($5 >>> (32 - $4 | 0) | 0) | 0 | ($8 << $4 | 0) | 0;
          $12 = $5 << $4 | 0;
         }
        }
        $11 = $9;
        $9 = $1_1;
        $8 = $0_1;
        $7 = 63;
        $4 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = 0;
          $7 = $9 >>> $4 | 0;
         }
        } else {
         {
          $5 = $9 >>> $4 | 0;
          $7 = (((1 << $4 | 0) - 1 | 0) & $9 | 0) << (32 - $4 | 0) | 0 | ($8 >>> $4 | 0) | 0;
         }
        }
        $8 = $5;
        $5 = $11;
        $9 = $12;
        $8 = $5 | $8 | 0;
        $13 = $9 | $7 | 0;
        $11 = $8;
        $18 = $13;
        $19 = $8;
        $8 = $15;
        $5 = $17;
        $9 = $11;
        $7 = $13;
        $4 = $5 - $7 | 0;
        $5 = $5 >>> 0 < $7 >>> 0;
        $6 = $5 + $9 | 0;
        $6 = $8 - $6 | 0;
        $8 = $4;
        $7 = 63;
        $9 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = $6 >> 31 | 0;
          $14 = $6 >> $9 | 0;
         }
        } else {
         {
          $5 = $6 >> $9 | 0;
          $14 = (((1 << $9 | 0) - 1 | 0) & $6 | 0) << (32 - $9 | 0) | 0 | ($8 >>> $9 | 0) | 0;
         }
        }
        $12 = $5;
        $5 = $12;
        $6 = $14;
        $8 = $3_1;
        $7 = $2_1;
        $8 = $5 & $8 | 0;
        $7 = $6 & $7 | 0;
        $6 = $8;
        $8 = $19;
        $5 = $18;
        $9 = $5 - $7 | 0;
        $5 = $5 >>> 0 < $7 >>> 0;
        $4 = $5 + $6 | 0;
        $4 = $8 - $4 | 0;
        $13 = $9;
        $11 = $4;
        $4 = $1_1;
        $8 = $0_1;
        $7 = 1;
        $6 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = $8 << $6 | 0;
          $4 = 0;
         }
        } else {
         {
          $5 = ((1 << $6 | 0) - 1 | 0) & ($8 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
          $4 = $8 << $6 | 0;
         }
        }
        $8 = $16;
        $7 = $20;
        $8 = $5 | $8 | 0;
        $0_1 = $4 | $7 | 0;
        $1_1 = $8;
        $8 = $12;
        $5 = $14;
        $4 = 0;
        $7 = 1;
        $4 = $8 & $4 | 0;
        $14 = $5 & $7 | 0;
        $12 = $4;
        $20 = $14;
        $16 = $4;
        $10 = $10 + -1 | 0;
        if ($10) {
         continue label$15
        }
        break label$15;
       };
       break label$13;
      }
     }
    }
    $4 = $11;
    legalfunc$wasm2js_scratch_store_i64($13 | 0, $4 | 0);
    $4 = $1_1;
    $8 = $0_1;
    $7 = 1;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $5 = $8 << $6 | 0;
      $4 = 0;
     }
    } else {
     {
      $5 = ((1 << $6 | 0) - 1 | 0) & ($8 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
      $4 = $8 << $6 | 0;
     }
    }
    $8 = $12;
    $7 = $14;
    $8 = $5 | $8 | 0;
    $4 = $4 | $7 | 0;
    i64toi32_i32$HIGH_BITS = $8;
    return $4 | 0;
   }
   $4 = $1_1;
   legalfunc$wasm2js_scratch_store_i64($0_1 | 0, $4 | 0);
   $4 = 0;
   $0_1 = 0;
   $1_1 = $4;
  }
  $4 = $1_1;
  $8 = $0_1;
  i64toi32_i32$HIGH_BITS = $4;
  return $8 | 0;
 }
 
 function __wasm_i64_mul($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  $3_1 = _ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE($0_1 | 0, $1_1 | 0, $2_1 | 0, $3_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $3_1 | 0;
 }
 
 function __wasm_i64_sdiv($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  $3_1 = _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E($0_1 | 0, $1_1 | 0, $2_1 | 0, $3_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $3_1 | 0;
 }
 
 function __wasm_i64_udiv($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  $3_1 = _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0_1 | 0, $1_1 | 0, $2_1 | 0, $3_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $3_1 | 0;
 }
 
 function __wasm_ctz_i32($0_1) {
  $0_1 = $0_1 | 0;
  if ($0_1) {
   return 31 - Math_clz32(($0_1 + -1 | 0) ^ $0_1 | 0) | 0 | 0
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
 function $0($0_1) {
  $0_1 = $0_1 | 0;
  return ($0_1 | 0) / (2 | 0) | 0 | 0;
 }
 
 function $1($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2 = 0;
  $2 = 0;
  $2 = __wasm_i64_sdiv($0_1 | 0, $1_1 | 0, 2 | 0, $2 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $2 | 0;
 }
 
 function legalstub$1($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0;
  $3 = 0;
  $5 = $0_1;
  $6 = $3;
  $3 = 0;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0_1 = $1_1 << $2 | 0;
    $4 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $2 | 0) - 1 | 0) & ($1_1 >>> (32 - $2 | 0) | 0) | 0 | ($3 << $2 | 0) | 0;
    $4 = $1_1 << $2 | 0;
   }
  }
  $1_1 = $0_1;
  $0_1 = $6;
  $3 = $5;
  $1_1 = $0_1 | $1_1 | 0;
  $1_1 = $1($3 | $4 | 0 | 0, $1_1 | 0) | 0;
  $3 = i64toi32_i32$HIGH_BITS;
  $6 = $1_1;
  $5 = $3;
  $0_1 = $1_1;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0_1 = $3 >>> $2 | 0
  } else {
   $0_1 = (((1 << $2 | 0) - 1 | 0) & $3 | 0) << (32 - $2 | 0) | 0 | ($0_1 >>> $2 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $6 | 0;
 }
 
 function legalfunc$wasm2js_scratch_store_i64($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2 = 0, $3 = 0, $4 = 0;
  $4 = $0_1;
  $3 = 32;
  $2 = $3 & 31 | 0;
  if (32 >>> 0 <= ($3 & 63 | 0) >>> 0) {
   $0_1 = $1_1 >>> $2 | 0
  } else {
   $0_1 = (((1 << $2 | 0) - 1 | 0) & $1_1 | 0) << (32 - $2 | 0) | 0 | ($0_1 >>> $2 | 0) | 0
  }
  legalimport$wasm2js_scratch_store_i64($4 | 0, $0_1 | 0);
 }
 
 function _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E($0_1, $1_1, $2, $3) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2 = $2 | 0;
  $3 = $3 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0;
  $8 = $1_1;
  $7 = $0_1;
  $6 = 63;
  $5 = $6 & 31 | 0;
  if (32 >>> 0 <= ($6 & 63 | 0) >>> 0) {
   {
    $4 = $8 >> 31 | 0;
    $5 = $8 >> $5 | 0;
   }
  } else {
   {
    $4 = $8 >> $5 | 0;
    $5 = (((1 << $5 | 0) - 1 | 0) & $8 | 0) << (32 - $5 | 0) | 0 | ($7 >>> $5 | 0) | 0;
   }
  }
  $10 = $4;
  $4 = $10;
  $8 = $5;
  $7 = $1_1;
  $6 = $0_1;
  $7 = $4 ^ $7 | 0;
  $4 = $8 ^ $6 | 0;
  $8 = $10;
  $6 = $5;
  $5 = $4 - $6 | 0;
  $10 = $4 >>> 0 < $6 >>> 0;
  $9 = $10 + $8 | 0;
  $9 = $7 - $9 | 0;
  $11 = $5;
  $12 = $9;
  $9 = $3;
  $7 = $2;
  $6 = 63;
  $8 = $6 & 31 | 0;
  if (32 >>> 0 <= ($6 & 63 | 0) >>> 0) {
   {
    $4 = $9 >> 31 | 0;
    $5 = $9 >> $8 | 0;
   }
  } else {
   {
    $4 = $9 >> $8 | 0;
    $5 = (((1 << $8 | 0) - 1 | 0) & $9 | 0) << (32 - $8 | 0) | 0 | ($7 >>> $8 | 0) | 0;
   }
  }
  $10 = $4;
  $4 = $10;
  $9 = $5;
  $7 = $3;
  $6 = $2;
  $7 = $4 ^ $7 | 0;
  $4 = $9 ^ $6 | 0;
  $9 = $10;
  $6 = $5;
  $8 = $4 - $6 | 0;
  $10 = $4 >>> 0 < $6 >>> 0;
  $5 = $10 + $9 | 0;
  $5 = $7 - $5 | 0;
  $4 = $5;
  $5 = $12;
  $4 = __wasm_i64_udiv($11 | 0, $5 | 0, $8 | 0, $4 | 0) | 0;
  $5 = i64toi32_i32$HIGH_BITS;
  $10 = $4;
  $8 = $5;
  $5 = $3;
  $7 = $2;
  $4 = $1_1;
  $6 = $0_1;
  $4 = $5 ^ $4 | 0;
  $5 = $7 ^ $6 | 0;
  $6 = 63;
  $9 = $6 & 31 | 0;
  if (32 >>> 0 <= ($6 & 63 | 0) >>> 0) {
   {
    $7 = $4 >> 31 | 0;
    $0_1 = $4 >> $9 | 0;
   }
  } else {
   {
    $7 = $4 >> $9 | 0;
    $0_1 = (((1 << $9 | 0) - 1 | 0) & $4 | 0) << (32 - $9 | 0) | 0 | ($5 >>> $9 | 0) | 0;
   }
  }
  $1_1 = $7;
  $7 = $8;
  $4 = $10;
  $5 = $1_1;
  $6 = $0_1;
  $5 = $7 ^ $5 | 0;
  $7 = $4 ^ $6 | 0;
  $4 = $1_1;
  $9 = $7 - $6 | 0;
  $10 = $7 >>> 0 < $6 >>> 0;
  $8 = $10 + $4 | 0;
  $8 = $5 - $8 | 0;
  $7 = $9;
  i64toi32_i32$HIGH_BITS = $8;
  return $7 | 0;
 }
 
 function __wasm_i64_sdiv($0_1, $1_1, $2, $3) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2 = $2 | 0;
  $3 = $3 | 0;
  $3 = _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E($0_1 | 0, $1_1 | 0, $2 | 0, $3 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $3 | 0;
 }
 
 function _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0_1, $1_1, $2, $3) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2 = $2 | 0;
  $3 = $3 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0, $13 = 0, $14 = 0, $15 = 0, $16 = 0, $17 = 0, $18 = 0, $19 = 0, $20 = 0;
  label$1 : {
   label$2 : {
    label$3 : {
     label$4 : {
      label$5 : {
       label$6 : {
        label$7 : {
         label$8 : {
          label$9 : {
           label$11 : {
            $7 = $1_1;
            $5 = $0_1;
            $4 = 32;
            $6 = $4 & 31 | 0;
            if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
             $10 = $7 >>> $6 | 0
            } else {
             $10 = (((1 << $6 | 0) - 1 | 0) & $7 | 0) << (32 - $6 | 0) | 0 | ($5 >>> $6 | 0) | 0
            }
            if ($10) {
             {
              $8 = $2;
              if (!$8) {
               break label$11
              }
              $9 = $3;
              $7 = $2;
              $4 = 32;
              $6 = $4 & 31 | 0;
              if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
               $11 = $9 >>> $6 | 0
              } else {
               $11 = (((1 << $6 | 0) - 1 | 0) & $9 | 0) << (32 - $6 | 0) | 0 | ($7 >>> $6 | 0) | 0
              }
              if (!$11) {
               break label$9
              }
              $10 = Math_clz32($11) - Math_clz32($10) | 0;
              if ($10 >>> 0 <= 31 >>> 0) {
               break label$8
              }
              break label$2;
             }
            }
            $5 = $3;
            $9 = $2;
            $7 = 1;
            $4 = 0;
            if ($5 >>> 0 > $7 >>> 0 | (($5 | 0) == ($7 | 0) & $9 >>> 0 >= $4 >>> 0 | 0) | 0) {
             break label$2
            }
            $10 = $0_1;
            $8 = $2;
            $10 = ($10 >>> 0) / ($8 >>> 0) | 0;
            $9 = 0;
            legalfunc$wasm2js_scratch_store_i64($0_1 - Math_imul($10, $8) | 0 | 0, $9 | 0);
            $9 = 0;
            $5 = $10;
            i64toi32_i32$HIGH_BITS = $9;
            return $5 | 0;
           }
           $5 = $3;
           $4 = $2;
           $7 = 32;
           $6 = $7 & 31 | 0;
           if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
            $8 = $5 >>> $6 | 0
           } else {
            $8 = (((1 << $6 | 0) - 1 | 0) & $5 | 0) << (32 - $6 | 0) | 0 | ($4 >>> $6 | 0) | 0
           }
           if (!$0_1) {
            break label$7
           }
           if (!$8) {
            break label$6
           }
           $11 = $8 + -1 | 0;
           if ($11 & $8 | 0) {
            break label$6
           }
           $9 = 0;
           $5 = $11 & $10 | 0;
           $7 = 32;
           $6 = $7 & 31 | 0;
           if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
            {
             $4 = $5 << $6 | 0;
             $3 = 0;
            }
           } else {
            {
             $4 = ((1 << $6 | 0) - 1 | 0) & ($5 >>> (32 - $6 | 0) | 0) | 0 | ($9 << $6 | 0) | 0;
             $3 = $5 << $6 | 0;
            }
           }
           $2 = $4;
           $4 = $1_1;
           $9 = $0_1;
           $5 = 0;
           $7 = -1;
           $5 = $4 & $5 | 0;
           $7 = $9 & $7 | 0;
           $9 = $5;
           $5 = $2;
           $4 = $3;
           $9 = $5 | $9 | 0;
           legalfunc$wasm2js_scratch_store_i64($4 | $7 | 0 | 0, $9 | 0);
           $9 = 0;
           $4 = $10 >>> ((__wasm_ctz_i32($8 | 0) | 0) & 31 | 0) | 0;
           i64toi32_i32$HIGH_BITS = $9;
           return $4 | 0;
          }
          $11 = $8 + -1 | 0;
          if (!($11 & $8 | 0)) {
           break label$5
          }
          $10 = (Math_clz32($8) + 33 | 0) - Math_clz32($10) | 0;
          $8 = 0 - $10 | 0;
          break label$3;
         }
         $8 = 63 - $10 | 0;
         $10 = $10 + 1 | 0;
         break label$3;
        }
        $11 = ($10 >>> 0) / ($8 >>> 0) | 0;
        $4 = 0;
        $5 = $10 - Math_imul($11, $8) | 0;
        $7 = 32;
        $6 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $9 = $5 << $6 | 0;
          $0_1 = 0;
         }
        } else {
         {
          $9 = ((1 << $6 | 0) - 1 | 0) & ($5 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
          $0_1 = $5 << $6 | 0;
         }
        }
        legalfunc$wasm2js_scratch_store_i64($0_1 | 0, $9 | 0);
        $9 = 0;
        $5 = $11;
        i64toi32_i32$HIGH_BITS = $9;
        return $5 | 0;
       }
       $10 = Math_clz32($8) - Math_clz32($10) | 0;
       if ($10 >>> 0 < 31 >>> 0) {
        break label$4
       }
       break label$2;
      }
      $5 = 0;
      legalfunc$wasm2js_scratch_store_i64($11 & $0_1 | 0 | 0, $5 | 0);
      if (($8 | 0) == (1 | 0)) {
       break label$1
      }
      $5 = 0;
      $9 = $5;
      $5 = $1_1;
      $4 = $0_1;
      $7 = __wasm_ctz_i32($8 | 0) | 0;
      $6 = $7 & 31 | 0;
      if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
       {
        $9 = 0;
        $4 = $5 >>> $6 | 0;
       }
      } else {
       {
        $9 = $5 >>> $6 | 0;
        $4 = (((1 << $6 | 0) - 1 | 0) & $5 | 0) << (32 - $6 | 0) | 0 | ($4 >>> $6 | 0) | 0;
       }
      }
      i64toi32_i32$HIGH_BITS = $9;
      return $4 | 0;
     }
     $8 = 63 - $10 | 0;
     $10 = $10 + 1 | 0;
    }
    $4 = 0;
    $9 = $4;
    $4 = $1_1;
    $5 = $0_1;
    $7 = $10 & 63 | 0;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $9 = 0;
      $13 = $4 >>> $6 | 0;
     }
    } else {
     {
      $9 = $4 >>> $6 | 0;
      $13 = (((1 << $6 | 0) - 1 | 0) & $4 | 0) << (32 - $6 | 0) | 0 | ($5 >>> $6 | 0) | 0;
     }
    }
    $11 = $9;
    $9 = 0;
    $5 = $9;
    $9 = $1_1;
    $4 = $0_1;
    $7 = $8 & 63 | 0;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $5 = $4 << $6 | 0;
      $0_1 = 0;
     }
    } else {
     {
      $5 = ((1 << $6 | 0) - 1 | 0) & ($4 >>> (32 - $6 | 0) | 0) | 0 | ($9 << $6 | 0) | 0;
      $0_1 = $4 << $6 | 0;
     }
    }
    $1_1 = $5;
    label$13 : {
     if ($10) {
      {
       $5 = $3;
       $9 = $2;
       $4 = -1;
       $7 = -1;
       $6 = $9 + $7 | 0;
       $8 = $5 + $4 | 0;
       if ($6 >>> 0 < $7 >>> 0) {
        $8 = $8 + 1 | 0
       }
       $17 = $6;
       $15 = $8;
       label$15 : while (1) {
        $8 = $11;
        $5 = $13;
        $7 = 1;
        $4 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $9 = $5 << $4 | 0;
          $12 = 0;
         }
        } else {
         {
          $9 = ((1 << $4 | 0) - 1 | 0) & ($5 >>> (32 - $4 | 0) | 0) | 0 | ($8 << $4 | 0) | 0;
          $12 = $5 << $4 | 0;
         }
        }
        $11 = $9;
        $9 = $1_1;
        $8 = $0_1;
        $7 = 63;
        $4 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = 0;
          $7 = $9 >>> $4 | 0;
         }
        } else {
         {
          $5 = $9 >>> $4 | 0;
          $7 = (((1 << $4 | 0) - 1 | 0) & $9 | 0) << (32 - $4 | 0) | 0 | ($8 >>> $4 | 0) | 0;
         }
        }
        $8 = $5;
        $5 = $11;
        $9 = $12;
        $8 = $5 | $8 | 0;
        $13 = $9 | $7 | 0;
        $11 = $8;
        $18 = $13;
        $19 = $8;
        $8 = $15;
        $5 = $17;
        $9 = $11;
        $7 = $13;
        $4 = $5 - $7 | 0;
        $5 = $5 >>> 0 < $7 >>> 0;
        $6 = $5 + $9 | 0;
        $6 = $8 - $6 | 0;
        $8 = $4;
        $7 = 63;
        $9 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = $6 >> 31 | 0;
          $14 = $6 >> $9 | 0;
         }
        } else {
         {
          $5 = $6 >> $9 | 0;
          $14 = (((1 << $9 | 0) - 1 | 0) & $6 | 0) << (32 - $9 | 0) | 0 | ($8 >>> $9 | 0) | 0;
         }
        }
        $12 = $5;
        $5 = $12;
        $6 = $14;
        $8 = $3;
        $7 = $2;
        $8 = $5 & $8 | 0;
        $7 = $6 & $7 | 0;
        $6 = $8;
        $8 = $19;
        $5 = $18;
        $9 = $5 - $7 | 0;
        $5 = $5 >>> 0 < $7 >>> 0;
        $4 = $5 + $6 | 0;
        $4 = $8 - $4 | 0;
        $13 = $9;
        $11 = $4;
        $4 = $1_1;
        $8 = $0_1;
        $7 = 1;
        $6 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = $8 << $6 | 0;
          $4 = 0;
         }
        } else {
         {
          $5 = ((1 << $6 | 0) - 1 | 0) & ($8 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
          $4 = $8 << $6 | 0;
         }
        }
        $8 = $16;
        $7 = $20;
        $8 = $5 | $8 | 0;
        $0_1 = $4 | $7 | 0;
        $1_1 = $8;
        $8 = $12;
        $5 = $14;
        $4 = 0;
        $7 = 1;
        $4 = $8 & $4 | 0;
        $14 = $5 & $7 | 0;
        $12 = $4;
        $20 = $14;
        $16 = $4;
        $10 = $10 + -1 | 0;
        if ($10) {
         continue label$15
        }
        break label$15;
       };
       break label$13;
      }
     }
    }
    $4 = $11;
    legalfunc$wasm2js_scratch_store_i64($13 | 0, $4 | 0);
    $4 = $1_1;
    $8 = $0_1;
    $7 = 1;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $5 = $8 << $6 | 0;
      $4 = 0;
     }
    } else {
     {
      $5 = ((1 << $6 | 0) - 1 | 0) & ($8 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
      $4 = $8 << $6 | 0;
     }
    }
    $8 = $12;
    $7 = $14;
    $8 = $5 | $8 | 0;
    $4 = $4 | $7 | 0;
    i64toi32_i32$HIGH_BITS = $8;
    return $4 | 0;
   }
   $4 = $1_1;
   legalfunc$wasm2js_scratch_store_i64($0_1 | 0, $4 | 0);
   $4 = 0;
   $0_1 = 0;
   $1_1 = $4;
  }
  $4 = $1_1;
  $8 = $0_1;
  i64toi32_i32$HIGH_BITS = $4;
  return $8 | 0;
 }
 
 function __wasm_i64_udiv($0_1, $1_1, $2, $3) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2 = $2 | 0;
  $3 = $3 | 0;
  $3 = _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0_1 | 0, $1_1 | 0, $2 | 0, $3 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $3 | 0;
 }
 
 function __wasm_ctz_i32($0_1) {
  $0_1 = $0_1 | 0;
  if ($0_1) {
   return 31 - Math_clz32(($0_1 + -1 | 0) ^ $0_1 | 0) | 0 | 0
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
 var getTempRet0 = env.getTempRet0;
 var i64toi32_i32$HIGH_BITS = 0;
 function $0($0_1) {
  $0_1 = $0_1 | 0;
  return ($0_1 | 0) % (2 | 0) | 0 | 0;
 }
 
 function $1($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2 = 0;
  $2 = 0;
  $2 = __wasm_i64_srem($0_1 | 0, $1_1 | 0, 2 | 0, $2 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $2 | 0;
 }
 
 function legalstub$1($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0;
  $3 = 0;
  $5 = $0_1;
  $6 = $3;
  $3 = 0;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0_1 = $1_1 << $2 | 0;
    $4 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $2 | 0) - 1 | 0) & ($1_1 >>> (32 - $2 | 0) | 0) | 0 | ($3 << $2 | 0) | 0;
    $4 = $1_1 << $2 | 0;
   }
  }
  $1_1 = $0_1;
  $0_1 = $6;
  $3 = $5;
  $1_1 = $0_1 | $1_1 | 0;
  $1_1 = $1($3 | $4 | 0 | 0, $1_1 | 0) | 0;
  $3 = i64toi32_i32$HIGH_BITS;
  $6 = $1_1;
  $5 = $3;
  $0_1 = $1_1;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0_1 = $3 >>> $2 | 0
  } else {
   $0_1 = (((1 << $2 | 0) - 1 | 0) & $3 | 0) << (32 - $2 | 0) | 0 | ($0_1 >>> $2 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $6 | 0;
 }
 
 function legalfunc$wasm2js_scratch_load_i64() {
  var $0_1 = 0, $1_1 = 0, $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0;
  $0_1 = 0;
  $5 = legalimport$wasm2js_scratch_load_i64() | 0;
  $6 = $0_1;
  $0_1 = 0;
  $1_1 = getTempRet0() | 0;
  $2 = 32;
  $3 = $2 & 31 | 0;
  if (32 >>> 0 <= ($2 & 63 | 0) >>> 0) {
   {
    $4 = $1_1 << $3 | 0;
    $2 = 0;
   }
  } else {
   {
    $4 = ((1 << $3 | 0) - 1 | 0) & ($1_1 >>> (32 - $3 | 0) | 0) | 0 | ($0_1 << $3 | 0) | 0;
    $2 = $1_1 << $3 | 0;
   }
  }
  $1_1 = $4;
  $4 = $6;
  $0_1 = $5;
  $1_1 = $4 | $1_1 | 0;
  $0_1 = $0_1 | $2 | 0;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $0_1 | 0;
 }
 
 function legalfunc$wasm2js_scratch_store_i64($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2 = 0, $3 = 0, $4 = 0;
  $4 = $0_1;
  $3 = 32;
  $2 = $3 & 31 | 0;
  if (32 >>> 0 <= ($3 & 63 | 0) >>> 0) {
   $0_1 = $1_1 >>> $2 | 0
  } else {
   $0_1 = (((1 << $2 | 0) - 1 | 0) & $1_1 | 0) << (32 - $2 | 0) | 0 | ($0_1 >>> $2 | 0) | 0
  }
  legalimport$wasm2js_scratch_store_i64($4 | 0, $0_1 | 0);
 }
 
 function _ZN17compiler_builtins3int4sdiv3Mod4mod_17h2cbb7bbf36e41d68E($0_1, $1_1, $2, $3) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2 = $2 | 0;
  $3 = $3 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0, $13 = 0;
  $5 = $1_1;
  $8 = $0_1;
  $7 = 63;
  $6 = $7 & 31 | 0;
  if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
   {
    $4 = $5 >> 31 | 0;
    $11 = $5 >> $6 | 0;
   }
  } else {
   {
    $4 = $5 >> $6 | 0;
    $11 = (((1 << $6 | 0) - 1 | 0) & $5 | 0) << (32 - $6 | 0) | 0 | ($8 >>> $6 | 0) | 0;
   }
  }
  $10 = $4;
  $4 = $10;
  $5 = $11;
  $8 = $1_1;
  $7 = $0_1;
  $8 = $4 ^ $8 | 0;
  $4 = $5 ^ $7 | 0;
  $5 = $10;
  $7 = $11;
  $6 = $4 - $7 | 0;
  $0_1 = $4 >>> 0 < $7 >>> 0;
  $9 = $0_1 + $5 | 0;
  $9 = $8 - $9 | 0;
  $12 = $6;
  $13 = $9;
  $9 = $3;
  $8 = $2;
  $7 = 63;
  $5 = $7 & 31 | 0;
  if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
   {
    $4 = $9 >> 31 | 0;
    $0_1 = $9 >> $5 | 0;
   }
  } else {
   {
    $4 = $9 >> $5 | 0;
    $0_1 = (((1 << $5 | 0) - 1 | 0) & $9 | 0) << (32 - $5 | 0) | 0 | ($8 >>> $5 | 0) | 0;
   }
  }
  $1_1 = $4;
  $4 = $1_1;
  $9 = $0_1;
  $8 = $3;
  $7 = $2;
  $8 = $4 ^ $8 | 0;
  $4 = $9 ^ $7 | 0;
  $9 = $1_1;
  $7 = $0_1;
  $5 = $4 - $7 | 0;
  $0_1 = $4 >>> 0 < $7 >>> 0;
  $6 = $0_1 + $9 | 0;
  $6 = $8 - $6 | 0;
  $4 = $6;
  $6 = $13;
  $4 = __wasm_i64_urem($12 | 0, $6 | 0, $5 | 0, $4 | 0) | 0;
  $6 = i64toi32_i32$HIGH_BITS;
  $8 = $4;
  $4 = $10;
  $7 = $11;
  $4 = $6 ^ $4 | 0;
  $6 = $8 ^ $7 | 0;
  $8 = $10;
  $9 = $6 - $7 | 0;
  $0_1 = $6 >>> 0 < $7 >>> 0;
  $5 = $0_1 + $8 | 0;
  $5 = $4 - $5 | 0;
  $6 = $9;
  i64toi32_i32$HIGH_BITS = $5;
  return $6 | 0;
 }
 
 function __wasm_i64_srem($0_1, $1_1, $2, $3) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2 = $2 | 0;
  $3 = $3 | 0;
  $3 = _ZN17compiler_builtins3int4sdiv3Mod4mod_17h2cbb7bbf36e41d68E($0_1 | 0, $1_1 | 0, $2 | 0, $3 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $3 | 0;
 }
 
 function _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0_1, $1_1, $2, $3) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2 = $2 | 0;
  $3 = $3 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0, $13 = 0, $14 = 0, $15 = 0, $16 = 0, $17 = 0, $18 = 0, $19 = 0, $20 = 0;
  label$1 : {
   label$2 : {
    label$3 : {
     label$4 : {
      label$5 : {
       label$6 : {
        label$7 : {
         label$8 : {
          label$9 : {
           label$11 : {
            $7 = $1_1;
            $5 = $0_1;
            $4 = 32;
            $6 = $4 & 31 | 0;
            if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
             $10 = $7 >>> $6 | 0
            } else {
             $10 = (((1 << $6 | 0) - 1 | 0) & $7 | 0) << (32 - $6 | 0) | 0 | ($5 >>> $6 | 0) | 0
            }
            if ($10) {
             {
              $8 = $2;
              if (!$8) {
               break label$11
              }
              $9 = $3;
              $7 = $2;
              $4 = 32;
              $6 = $4 & 31 | 0;
              if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
               $11 = $9 >>> $6 | 0
              } else {
               $11 = (((1 << $6 | 0) - 1 | 0) & $9 | 0) << (32 - $6 | 0) | 0 | ($7 >>> $6 | 0) | 0
              }
              if (!$11) {
               break label$9
              }
              $10 = Math_clz32($11) - Math_clz32($10) | 0;
              if ($10 >>> 0 <= 31 >>> 0) {
               break label$8
              }
              break label$2;
             }
            }
            $5 = $3;
            $9 = $2;
            $7 = 1;
            $4 = 0;
            if ($5 >>> 0 > $7 >>> 0 | (($5 | 0) == ($7 | 0) & $9 >>> 0 >= $4 >>> 0 | 0) | 0) {
             break label$2
            }
            $10 = $0_1;
            $8 = $2;
            $10 = ($10 >>> 0) / ($8 >>> 0) | 0;
            $9 = 0;
            legalfunc$wasm2js_scratch_store_i64($0_1 - Math_imul($10, $8) | 0 | 0, $9 | 0);
            $9 = 0;
            $5 = $10;
            i64toi32_i32$HIGH_BITS = $9;
            return $5 | 0;
           }
           $5 = $3;
           $4 = $2;
           $7 = 32;
           $6 = $7 & 31 | 0;
           if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
            $8 = $5 >>> $6 | 0
           } else {
            $8 = (((1 << $6 | 0) - 1 | 0) & $5 | 0) << (32 - $6 | 0) | 0 | ($4 >>> $6 | 0) | 0
           }
           if (!$0_1) {
            break label$7
           }
           if (!$8) {
            break label$6
           }
           $11 = $8 + -1 | 0;
           if ($11 & $8 | 0) {
            break label$6
           }
           $9 = 0;
           $5 = $11 & $10 | 0;
           $7 = 32;
           $6 = $7 & 31 | 0;
           if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
            {
             $4 = $5 << $6 | 0;
             $3 = 0;
            }
           } else {
            {
             $4 = ((1 << $6 | 0) - 1 | 0) & ($5 >>> (32 - $6 | 0) | 0) | 0 | ($9 << $6 | 0) | 0;
             $3 = $5 << $6 | 0;
            }
           }
           $2 = $4;
           $4 = $1_1;
           $9 = $0_1;
           $5 = 0;
           $7 = -1;
           $5 = $4 & $5 | 0;
           $7 = $9 & $7 | 0;
           $9 = $5;
           $5 = $2;
           $4 = $3;
           $9 = $5 | $9 | 0;
           legalfunc$wasm2js_scratch_store_i64($4 | $7 | 0 | 0, $9 | 0);
           $9 = 0;
           $4 = $10 >>> ((__wasm_ctz_i32($8 | 0) | 0) & 31 | 0) | 0;
           i64toi32_i32$HIGH_BITS = $9;
           return $4 | 0;
          }
          $11 = $8 + -1 | 0;
          if (!($11 & $8 | 0)) {
           break label$5
          }
          $10 = (Math_clz32($8) + 33 | 0) - Math_clz32($10) | 0;
          $8 = 0 - $10 | 0;
          break label$3;
         }
         $8 = 63 - $10 | 0;
         $10 = $10 + 1 | 0;
         break label$3;
        }
        $11 = ($10 >>> 0) / ($8 >>> 0) | 0;
        $4 = 0;
        $5 = $10 - Math_imul($11, $8) | 0;
        $7 = 32;
        $6 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $9 = $5 << $6 | 0;
          $0_1 = 0;
         }
        } else {
         {
          $9 = ((1 << $6 | 0) - 1 | 0) & ($5 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
          $0_1 = $5 << $6 | 0;
         }
        }
        legalfunc$wasm2js_scratch_store_i64($0_1 | 0, $9 | 0);
        $9 = 0;
        $5 = $11;
        i64toi32_i32$HIGH_BITS = $9;
        return $5 | 0;
       }
       $10 = Math_clz32($8) - Math_clz32($10) | 0;
       if ($10 >>> 0 < 31 >>> 0) {
        break label$4
       }
       break label$2;
      }
      $5 = 0;
      legalfunc$wasm2js_scratch_store_i64($11 & $0_1 | 0 | 0, $5 | 0);
      if (($8 | 0) == (1 | 0)) {
       break label$1
      }
      $5 = 0;
      $9 = $5;
      $5 = $1_1;
      $4 = $0_1;
      $7 = __wasm_ctz_i32($8 | 0) | 0;
      $6 = $7 & 31 | 0;
      if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
       {
        $9 = 0;
        $4 = $5 >>> $6 | 0;
       }
      } else {
       {
        $9 = $5 >>> $6 | 0;
        $4 = (((1 << $6 | 0) - 1 | 0) & $5 | 0) << (32 - $6 | 0) | 0 | ($4 >>> $6 | 0) | 0;
       }
      }
      i64toi32_i32$HIGH_BITS = $9;
      return $4 | 0;
     }
     $8 = 63 - $10 | 0;
     $10 = $10 + 1 | 0;
    }
    $4 = 0;
    $9 = $4;
    $4 = $1_1;
    $5 = $0_1;
    $7 = $10 & 63 | 0;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $9 = 0;
      $13 = $4 >>> $6 | 0;
     }
    } else {
     {
      $9 = $4 >>> $6 | 0;
      $13 = (((1 << $6 | 0) - 1 | 0) & $4 | 0) << (32 - $6 | 0) | 0 | ($5 >>> $6 | 0) | 0;
     }
    }
    $11 = $9;
    $9 = 0;
    $5 = $9;
    $9 = $1_1;
    $4 = $0_1;
    $7 = $8 & 63 | 0;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $5 = $4 << $6 | 0;
      $0_1 = 0;
     }
    } else {
     {
      $5 = ((1 << $6 | 0) - 1 | 0) & ($4 >>> (32 - $6 | 0) | 0) | 0 | ($9 << $6 | 0) | 0;
      $0_1 = $4 << $6 | 0;
     }
    }
    $1_1 = $5;
    label$13 : {
     if ($10) {
      {
       $5 = $3;
       $9 = $2;
       $4 = -1;
       $7 = -1;
       $6 = $9 + $7 | 0;
       $8 = $5 + $4 | 0;
       if ($6 >>> 0 < $7 >>> 0) {
        $8 = $8 + 1 | 0
       }
       $17 = $6;
       $15 = $8;
       label$15 : while (1) {
        $8 = $11;
        $5 = $13;
        $7 = 1;
        $4 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $9 = $5 << $4 | 0;
          $12 = 0;
         }
        } else {
         {
          $9 = ((1 << $4 | 0) - 1 | 0) & ($5 >>> (32 - $4 | 0) | 0) | 0 | ($8 << $4 | 0) | 0;
          $12 = $5 << $4 | 0;
         }
        }
        $11 = $9;
        $9 = $1_1;
        $8 = $0_1;
        $7 = 63;
        $4 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = 0;
          $7 = $9 >>> $4 | 0;
         }
        } else {
         {
          $5 = $9 >>> $4 | 0;
          $7 = (((1 << $4 | 0) - 1 | 0) & $9 | 0) << (32 - $4 | 0) | 0 | ($8 >>> $4 | 0) | 0;
         }
        }
        $8 = $5;
        $5 = $11;
        $9 = $12;
        $8 = $5 | $8 | 0;
        $13 = $9 | $7 | 0;
        $11 = $8;
        $18 = $13;
        $19 = $8;
        $8 = $15;
        $5 = $17;
        $9 = $11;
        $7 = $13;
        $4 = $5 - $7 | 0;
        $5 = $5 >>> 0 < $7 >>> 0;
        $6 = $5 + $9 | 0;
        $6 = $8 - $6 | 0;
        $8 = $4;
        $7 = 63;
        $9 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = $6 >> 31 | 0;
          $14 = $6 >> $9 | 0;
         }
        } else {
         {
          $5 = $6 >> $9 | 0;
          $14 = (((1 << $9 | 0) - 1 | 0) & $6 | 0) << (32 - $9 | 0) | 0 | ($8 >>> $9 | 0) | 0;
         }
        }
        $12 = $5;
        $5 = $12;
        $6 = $14;
        $8 = $3;
        $7 = $2;
        $8 = $5 & $8 | 0;
        $7 = $6 & $7 | 0;
        $6 = $8;
        $8 = $19;
        $5 = $18;
        $9 = $5 - $7 | 0;
        $5 = $5 >>> 0 < $7 >>> 0;
        $4 = $5 + $6 | 0;
        $4 = $8 - $4 | 0;
        $13 = $9;
        $11 = $4;
        $4 = $1_1;
        $8 = $0_1;
        $7 = 1;
        $6 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = $8 << $6 | 0;
          $4 = 0;
         }
        } else {
         {
          $5 = ((1 << $6 | 0) - 1 | 0) & ($8 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
          $4 = $8 << $6 | 0;
         }
        }
        $8 = $16;
        $7 = $20;
        $8 = $5 | $8 | 0;
        $0_1 = $4 | $7 | 0;
        $1_1 = $8;
        $8 = $12;
        $5 = $14;
        $4 = 0;
        $7 = 1;
        $4 = $8 & $4 | 0;
        $14 = $5 & $7 | 0;
        $12 = $4;
        $20 = $14;
        $16 = $4;
        $10 = $10 + -1 | 0;
        if ($10) {
         continue label$15
        }
        break label$15;
       };
       break label$13;
      }
     }
    }
    $4 = $11;
    legalfunc$wasm2js_scratch_store_i64($13 | 0, $4 | 0);
    $4 = $1_1;
    $8 = $0_1;
    $7 = 1;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $5 = $8 << $6 | 0;
      $4 = 0;
     }
    } else {
     {
      $5 = ((1 << $6 | 0) - 1 | 0) & ($8 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
      $4 = $8 << $6 | 0;
     }
    }
    $8 = $12;
    $7 = $14;
    $8 = $5 | $8 | 0;
    $4 = $4 | $7 | 0;
    i64toi32_i32$HIGH_BITS = $8;
    return $4 | 0;
   }
   $4 = $1_1;
   legalfunc$wasm2js_scratch_store_i64($0_1 | 0, $4 | 0);
   $4 = 0;
   $0_1 = 0;
   $1_1 = $4;
  }
  $4 = $1_1;
  $8 = $0_1;
  i64toi32_i32$HIGH_BITS = $4;
  return $8 | 0;
 }
 
 function __wasm_i64_urem($0_1, $1_1, $2, $3) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2 = $2 | 0;
  $3 = $3 | 0;
  $3 = _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0_1 | 0, $1_1 | 0, $2 | 0, $3 | 0) | 0;
  $1_1 = legalfunc$wasm2js_scratch_load_i64() | 0;
  $3 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $3;
  return $1_1 | 0;
 }
 
 function __wasm_ctz_i32($0_1) {
  $0_1 = $0_1 | 0;
  if ($0_1) {
   return 31 - Math_clz32(($0_1 + -1 | 0) ^ $0_1 | 0) | 0 | 0
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
 function $0($0_1) {
  $0_1 = $0_1 | 0;
  return ($0_1 | 0) / (0 | 0) | 0 | 0;
 }
 
 function $1($0_1) {
  $0_1 = $0_1 | 0;
  return ($0_1 >>> 0) / (0 >>> 0) | 0 | 0;
 }
 
 function $2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0;
  $2_1 = 0;
  $2_1 = __wasm_i64_sdiv($0_1 | 0, $1_1 | 0, 0 | 0, $2_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $2_1 | 0;
 }
 
 function $3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0;
  $2_1 = 0;
  $2_1 = __wasm_i64_udiv($0_1 | 0, $1_1 | 0, 0 | 0, $2_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $2_1 | 0;
 }
 
 function legalstub$2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0, $5 = 0, $6 = 0;
  $3_1 = 0;
  $5 = $0_1;
  $6 = $3_1;
  $3_1 = 0;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0_1 = $1_1 << $2_1 | 0;
    $4 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $2_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $2_1 | 0) | 0) | 0 | ($3_1 << $2_1 | 0) | 0;
    $4 = $1_1 << $2_1 | 0;
   }
  }
  $1_1 = $0_1;
  $0_1 = $6;
  $3_1 = $5;
  $1_1 = $0_1 | $1_1 | 0;
  $1_1 = $2($3_1 | $4 | 0 | 0, $1_1 | 0) | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  $6 = $1_1;
  $5 = $3_1;
  $0_1 = $1_1;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0_1 = $3_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $3_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $6 | 0;
 }
 
 function legalstub$3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0, $5 = 0, $6 = 0;
  $3_1 = 0;
  $5 = $0_1;
  $6 = $3_1;
  $3_1 = 0;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0_1 = $1_1 << $2_1 | 0;
    $4 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $2_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $2_1 | 0) | 0) | 0 | ($3_1 << $2_1 | 0) | 0;
    $4 = $1_1 << $2_1 | 0;
   }
  }
  $1_1 = $0_1;
  $0_1 = $6;
  $3_1 = $5;
  $1_1 = $0_1 | $1_1 | 0;
  $1_1 = $3($3_1 | $4 | 0 | 0, $1_1 | 0) | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  $6 = $1_1;
  $5 = $3_1;
  $0_1 = $1_1;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0_1 = $3_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $3_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $6 | 0;
 }
 
 function legalfunc$wasm2js_scratch_store_i64($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0;
  $4 = $0_1;
  $3_1 = 32;
  $2_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   $0_1 = $1_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $1_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  legalimport$wasm2js_scratch_store_i64($4 | 0, $0_1 | 0);
 }
 
 function _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0;
  $8 = $1_1;
  $7 = $0_1;
  $6 = 63;
  $5 = $6 & 31 | 0;
  if (32 >>> 0 <= ($6 & 63 | 0) >>> 0) {
   {
    $4 = $8 >> 31 | 0;
    $5 = $8 >> $5 | 0;
   }
  } else {
   {
    $4 = $8 >> $5 | 0;
    $5 = (((1 << $5 | 0) - 1 | 0) & $8 | 0) << (32 - $5 | 0) | 0 | ($7 >>> $5 | 0) | 0;
   }
  }
  $10 = $4;
  $4 = $10;
  $8 = $5;
  $7 = $1_1;
  $6 = $0_1;
  $7 = $4 ^ $7 | 0;
  $4 = $8 ^ $6 | 0;
  $8 = $10;
  $6 = $5;
  $5 = $4 - $6 | 0;
  $10 = $4 >>> 0 < $6 >>> 0;
  $9 = $10 + $8 | 0;
  $9 = $7 - $9 | 0;
  $11 = $5;
  $12 = $9;
  $9 = $3_1;
  $7 = $2_1;
  $6 = 63;
  $8 = $6 & 31 | 0;
  if (32 >>> 0 <= ($6 & 63 | 0) >>> 0) {
   {
    $4 = $9 >> 31 | 0;
    $5 = $9 >> $8 | 0;
   }
  } else {
   {
    $4 = $9 >> $8 | 0;
    $5 = (((1 << $8 | 0) - 1 | 0) & $9 | 0) << (32 - $8 | 0) | 0 | ($7 >>> $8 | 0) | 0;
   }
  }
  $10 = $4;
  $4 = $10;
  $9 = $5;
  $7 = $3_1;
  $6 = $2_1;
  $7 = $4 ^ $7 | 0;
  $4 = $9 ^ $6 | 0;
  $9 = $10;
  $6 = $5;
  $8 = $4 - $6 | 0;
  $10 = $4 >>> 0 < $6 >>> 0;
  $5 = $10 + $9 | 0;
  $5 = $7 - $5 | 0;
  $4 = $5;
  $5 = $12;
  $4 = __wasm_i64_udiv($11 | 0, $5 | 0, $8 | 0, $4 | 0) | 0;
  $5 = i64toi32_i32$HIGH_BITS;
  $10 = $4;
  $8 = $5;
  $5 = $3_1;
  $7 = $2_1;
  $4 = $1_1;
  $6 = $0_1;
  $4 = $5 ^ $4 | 0;
  $5 = $7 ^ $6 | 0;
  $6 = 63;
  $9 = $6 & 31 | 0;
  if (32 >>> 0 <= ($6 & 63 | 0) >>> 0) {
   {
    $7 = $4 >> 31 | 0;
    $0_1 = $4 >> $9 | 0;
   }
  } else {
   {
    $7 = $4 >> $9 | 0;
    $0_1 = (((1 << $9 | 0) - 1 | 0) & $4 | 0) << (32 - $9 | 0) | 0 | ($5 >>> $9 | 0) | 0;
   }
  }
  $1_1 = $7;
  $7 = $8;
  $4 = $10;
  $5 = $1_1;
  $6 = $0_1;
  $5 = $7 ^ $5 | 0;
  $7 = $4 ^ $6 | 0;
  $4 = $1_1;
  $9 = $7 - $6 | 0;
  $10 = $7 >>> 0 < $6 >>> 0;
  $8 = $10 + $4 | 0;
  $8 = $5 - $8 | 0;
  $7 = $9;
  i64toi32_i32$HIGH_BITS = $8;
  return $7 | 0;
 }
 
 function _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0, $13 = 0, $14 = 0, $15 = 0, $16 = 0, $17 = 0, $18 = 0, $19 = 0, $20 = 0;
  label$1 : {
   label$2 : {
    label$3 : {
     label$4 : {
      label$5 : {
       label$6 : {
        label$7 : {
         label$8 : {
          label$9 : {
           label$11 : {
            $7 = $1_1;
            $5 = $0_1;
            $4 = 32;
            $6 = $4 & 31 | 0;
            if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
             $10 = $7 >>> $6 | 0
            } else {
             $10 = (((1 << $6 | 0) - 1 | 0) & $7 | 0) << (32 - $6 | 0) | 0 | ($5 >>> $6 | 0) | 0
            }
            if ($10) {
             {
              $8 = $2_1;
              if (!$8) {
               break label$11
              }
              $9 = $3_1;
              $7 = $2_1;
              $4 = 32;
              $6 = $4 & 31 | 0;
              if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
               $11 = $9 >>> $6 | 0
              } else {
               $11 = (((1 << $6 | 0) - 1 | 0) & $9 | 0) << (32 - $6 | 0) | 0 | ($7 >>> $6 | 0) | 0
              }
              if (!$11) {
               break label$9
              }
              $10 = Math_clz32($11) - Math_clz32($10) | 0;
              if ($10 >>> 0 <= 31 >>> 0) {
               break label$8
              }
              break label$2;
             }
            }
            $5 = $3_1;
            $9 = $2_1;
            $7 = 1;
            $4 = 0;
            if ($5 >>> 0 > $7 >>> 0 | (($5 | 0) == ($7 | 0) & $9 >>> 0 >= $4 >>> 0 | 0) | 0) {
             break label$2
            }
            $10 = $0_1;
            $8 = $2_1;
            $10 = ($10 >>> 0) / ($8 >>> 0) | 0;
            $9 = 0;
            legalfunc$wasm2js_scratch_store_i64($0_1 - Math_imul($10, $8) | 0 | 0, $9 | 0);
            $9 = 0;
            $5 = $10;
            i64toi32_i32$HIGH_BITS = $9;
            return $5 | 0;
           }
           $5 = $3_1;
           $4 = $2_1;
           $7 = 32;
           $6 = $7 & 31 | 0;
           if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
            $8 = $5 >>> $6 | 0
           } else {
            $8 = (((1 << $6 | 0) - 1 | 0) & $5 | 0) << (32 - $6 | 0) | 0 | ($4 >>> $6 | 0) | 0
           }
           if (!$0_1) {
            break label$7
           }
           if (!$8) {
            break label$6
           }
           $11 = $8 + -1 | 0;
           if ($11 & $8 | 0) {
            break label$6
           }
           $9 = 0;
           $5 = $11 & $10 | 0;
           $7 = 32;
           $6 = $7 & 31 | 0;
           if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
            {
             $4 = $5 << $6 | 0;
             $3_1 = 0;
            }
           } else {
            {
             $4 = ((1 << $6 | 0) - 1 | 0) & ($5 >>> (32 - $6 | 0) | 0) | 0 | ($9 << $6 | 0) | 0;
             $3_1 = $5 << $6 | 0;
            }
           }
           $2_1 = $4;
           $4 = $1_1;
           $9 = $0_1;
           $5 = 0;
           $7 = -1;
           $5 = $4 & $5 | 0;
           $7 = $9 & $7 | 0;
           $9 = $5;
           $5 = $2_1;
           $4 = $3_1;
           $9 = $5 | $9 | 0;
           legalfunc$wasm2js_scratch_store_i64($4 | $7 | 0 | 0, $9 | 0);
           $9 = 0;
           $4 = $10 >>> ((__wasm_ctz_i32($8 | 0) | 0) & 31 | 0) | 0;
           i64toi32_i32$HIGH_BITS = $9;
           return $4 | 0;
          }
          $11 = $8 + -1 | 0;
          if (!($11 & $8 | 0)) {
           break label$5
          }
          $10 = (Math_clz32($8) + 33 | 0) - Math_clz32($10) | 0;
          $8 = 0 - $10 | 0;
          break label$3;
         }
         $8 = 63 - $10 | 0;
         $10 = $10 + 1 | 0;
         break label$3;
        }
        $11 = ($10 >>> 0) / ($8 >>> 0) | 0;
        $4 = 0;
        $5 = $10 - Math_imul($11, $8) | 0;
        $7 = 32;
        $6 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $9 = $5 << $6 | 0;
          $0_1 = 0;
         }
        } else {
         {
          $9 = ((1 << $6 | 0) - 1 | 0) & ($5 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
          $0_1 = $5 << $6 | 0;
         }
        }
        legalfunc$wasm2js_scratch_store_i64($0_1 | 0, $9 | 0);
        $9 = 0;
        $5 = $11;
        i64toi32_i32$HIGH_BITS = $9;
        return $5 | 0;
       }
       $10 = Math_clz32($8) - Math_clz32($10) | 0;
       if ($10 >>> 0 < 31 >>> 0) {
        break label$4
       }
       break label$2;
      }
      $5 = 0;
      legalfunc$wasm2js_scratch_store_i64($11 & $0_1 | 0 | 0, $5 | 0);
      if (($8 | 0) == (1 | 0)) {
       break label$1
      }
      $5 = 0;
      $9 = $5;
      $5 = $1_1;
      $4 = $0_1;
      $7 = __wasm_ctz_i32($8 | 0) | 0;
      $6 = $7 & 31 | 0;
      if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
       {
        $9 = 0;
        $4 = $5 >>> $6 | 0;
       }
      } else {
       {
        $9 = $5 >>> $6 | 0;
        $4 = (((1 << $6 | 0) - 1 | 0) & $5 | 0) << (32 - $6 | 0) | 0 | ($4 >>> $6 | 0) | 0;
       }
      }
      i64toi32_i32$HIGH_BITS = $9;
      return $4 | 0;
     }
     $8 = 63 - $10 | 0;
     $10 = $10 + 1 | 0;
    }
    $4 = 0;
    $9 = $4;
    $4 = $1_1;
    $5 = $0_1;
    $7 = $10 & 63 | 0;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $9 = 0;
      $13 = $4 >>> $6 | 0;
     }
    } else {
     {
      $9 = $4 >>> $6 | 0;
      $13 = (((1 << $6 | 0) - 1 | 0) & $4 | 0) << (32 - $6 | 0) | 0 | ($5 >>> $6 | 0) | 0;
     }
    }
    $11 = $9;
    $9 = 0;
    $5 = $9;
    $9 = $1_1;
    $4 = $0_1;
    $7 = $8 & 63 | 0;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $5 = $4 << $6 | 0;
      $0_1 = 0;
     }
    } else {
     {
      $5 = ((1 << $6 | 0) - 1 | 0) & ($4 >>> (32 - $6 | 0) | 0) | 0 | ($9 << $6 | 0) | 0;
      $0_1 = $4 << $6 | 0;
     }
    }
    $1_1 = $5;
    label$13 : {
     if ($10) {
      {
       $5 = $3_1;
       $9 = $2_1;
       $4 = -1;
       $7 = -1;
       $6 = $9 + $7 | 0;
       $8 = $5 + $4 | 0;
       if ($6 >>> 0 < $7 >>> 0) {
        $8 = $8 + 1 | 0
       }
       $17 = $6;
       $15 = $8;
       label$15 : while (1) {
        $8 = $11;
        $5 = $13;
        $7 = 1;
        $4 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $9 = $5 << $4 | 0;
          $12 = 0;
         }
        } else {
         {
          $9 = ((1 << $4 | 0) - 1 | 0) & ($5 >>> (32 - $4 | 0) | 0) | 0 | ($8 << $4 | 0) | 0;
          $12 = $5 << $4 | 0;
         }
        }
        $11 = $9;
        $9 = $1_1;
        $8 = $0_1;
        $7 = 63;
        $4 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = 0;
          $7 = $9 >>> $4 | 0;
         }
        } else {
         {
          $5 = $9 >>> $4 | 0;
          $7 = (((1 << $4 | 0) - 1 | 0) & $9 | 0) << (32 - $4 | 0) | 0 | ($8 >>> $4 | 0) | 0;
         }
        }
        $8 = $5;
        $5 = $11;
        $9 = $12;
        $8 = $5 | $8 | 0;
        $13 = $9 | $7 | 0;
        $11 = $8;
        $18 = $13;
        $19 = $8;
        $8 = $15;
        $5 = $17;
        $9 = $11;
        $7 = $13;
        $4 = $5 - $7 | 0;
        $5 = $5 >>> 0 < $7 >>> 0;
        $6 = $5 + $9 | 0;
        $6 = $8 - $6 | 0;
        $8 = $4;
        $7 = 63;
        $9 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = $6 >> 31 | 0;
          $14 = $6 >> $9 | 0;
         }
        } else {
         {
          $5 = $6 >> $9 | 0;
          $14 = (((1 << $9 | 0) - 1 | 0) & $6 | 0) << (32 - $9 | 0) | 0 | ($8 >>> $9 | 0) | 0;
         }
        }
        $12 = $5;
        $5 = $12;
        $6 = $14;
        $8 = $3_1;
        $7 = $2_1;
        $8 = $5 & $8 | 0;
        $7 = $6 & $7 | 0;
        $6 = $8;
        $8 = $19;
        $5 = $18;
        $9 = $5 - $7 | 0;
        $5 = $5 >>> 0 < $7 >>> 0;
        $4 = $5 + $6 | 0;
        $4 = $8 - $4 | 0;
        $13 = $9;
        $11 = $4;
        $4 = $1_1;
        $8 = $0_1;
        $7 = 1;
        $6 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = $8 << $6 | 0;
          $4 = 0;
         }
        } else {
         {
          $5 = ((1 << $6 | 0) - 1 | 0) & ($8 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
          $4 = $8 << $6 | 0;
         }
        }
        $8 = $16;
        $7 = $20;
        $8 = $5 | $8 | 0;
        $0_1 = $4 | $7 | 0;
        $1_1 = $8;
        $8 = $12;
        $5 = $14;
        $4 = 0;
        $7 = 1;
        $4 = $8 & $4 | 0;
        $14 = $5 & $7 | 0;
        $12 = $4;
        $20 = $14;
        $16 = $4;
        $10 = $10 + -1 | 0;
        if ($10) {
         continue label$15
        }
        break label$15;
       };
       break label$13;
      }
     }
    }
    $4 = $11;
    legalfunc$wasm2js_scratch_store_i64($13 | 0, $4 | 0);
    $4 = $1_1;
    $8 = $0_1;
    $7 = 1;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $5 = $8 << $6 | 0;
      $4 = 0;
     }
    } else {
     {
      $5 = ((1 << $6 | 0) - 1 | 0) & ($8 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
      $4 = $8 << $6 | 0;
     }
    }
    $8 = $12;
    $7 = $14;
    $8 = $5 | $8 | 0;
    $4 = $4 | $7 | 0;
    i64toi32_i32$HIGH_BITS = $8;
    return $4 | 0;
   }
   $4 = $1_1;
   legalfunc$wasm2js_scratch_store_i64($0_1 | 0, $4 | 0);
   $4 = 0;
   $0_1 = 0;
   $1_1 = $4;
  }
  $4 = $1_1;
  $8 = $0_1;
  i64toi32_i32$HIGH_BITS = $4;
  return $8 | 0;
 }
 
 function __wasm_i64_sdiv($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  $3_1 = _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E($0_1 | 0, $1_1 | 0, $2_1 | 0, $3_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $3_1 | 0;
 }
 
 function __wasm_i64_udiv($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  $3_1 = _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0_1 | 0, $1_1 | 0, $2_1 | 0, $3_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $3_1 | 0;
 }
 
 function __wasm_ctz_i32($0_1) {
  $0_1 = $0_1 | 0;
  if ($0_1) {
   return 31 - Math_clz32(($0_1 + -1 | 0) ^ $0_1 | 0) | 0 | 0
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
 function $0($0_1) {
  $0_1 = $0_1 | 0;
  return ($0_1 | 0) / (3 | 0) | 0 | 0;
 }
 
 function $1($0_1) {
  $0_1 = $0_1 | 0;
  return ($0_1 >>> 0) / (3 >>> 0) | 0 | 0;
 }
 
 function $2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0;
  $2_1 = 0;
  $2_1 = __wasm_i64_sdiv($0_1 | 0, $1_1 | 0, 3 | 0, $2_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $2_1 | 0;
 }
 
 function $3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0;
  $2_1 = 0;
  $2_1 = __wasm_i64_udiv($0_1 | 0, $1_1 | 0, 3 | 0, $2_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $2_1 | 0;
 }
 
 function legalstub$2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0, $5 = 0, $6 = 0;
  $3_1 = 0;
  $5 = $0_1;
  $6 = $3_1;
  $3_1 = 0;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0_1 = $1_1 << $2_1 | 0;
    $4 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $2_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $2_1 | 0) | 0) | 0 | ($3_1 << $2_1 | 0) | 0;
    $4 = $1_1 << $2_1 | 0;
   }
  }
  $1_1 = $0_1;
  $0_1 = $6;
  $3_1 = $5;
  $1_1 = $0_1 | $1_1 | 0;
  $1_1 = $2($3_1 | $4 | 0 | 0, $1_1 | 0) | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  $6 = $1_1;
  $5 = $3_1;
  $0_1 = $1_1;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0_1 = $3_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $3_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $6 | 0;
 }
 
 function legalstub$3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0, $5 = 0, $6 = 0;
  $3_1 = 0;
  $5 = $0_1;
  $6 = $3_1;
  $3_1 = 0;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0_1 = $1_1 << $2_1 | 0;
    $4 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $2_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $2_1 | 0) | 0) | 0 | ($3_1 << $2_1 | 0) | 0;
    $4 = $1_1 << $2_1 | 0;
   }
  }
  $1_1 = $0_1;
  $0_1 = $6;
  $3_1 = $5;
  $1_1 = $0_1 | $1_1 | 0;
  $1_1 = $3($3_1 | $4 | 0 | 0, $1_1 | 0) | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  $6 = $1_1;
  $5 = $3_1;
  $0_1 = $1_1;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0_1 = $3_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $3_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $6 | 0;
 }
 
 function legalfunc$wasm2js_scratch_store_i64($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0;
  $4 = $0_1;
  $3_1 = 32;
  $2_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   $0_1 = $1_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $1_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  legalimport$wasm2js_scratch_store_i64($4 | 0, $0_1 | 0);
 }
 
 function _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0;
  $8 = $1_1;
  $7 = $0_1;
  $6 = 63;
  $5 = $6 & 31 | 0;
  if (32 >>> 0 <= ($6 & 63 | 0) >>> 0) {
   {
    $4 = $8 >> 31 | 0;
    $5 = $8 >> $5 | 0;
   }
  } else {
   {
    $4 = $8 >> $5 | 0;
    $5 = (((1 << $5 | 0) - 1 | 0) & $8 | 0) << (32 - $5 | 0) | 0 | ($7 >>> $5 | 0) | 0;
   }
  }
  $10 = $4;
  $4 = $10;
  $8 = $5;
  $7 = $1_1;
  $6 = $0_1;
  $7 = $4 ^ $7 | 0;
  $4 = $8 ^ $6 | 0;
  $8 = $10;
  $6 = $5;
  $5 = $4 - $6 | 0;
  $10 = $4 >>> 0 < $6 >>> 0;
  $9 = $10 + $8 | 0;
  $9 = $7 - $9 | 0;
  $11 = $5;
  $12 = $9;
  $9 = $3_1;
  $7 = $2_1;
  $6 = 63;
  $8 = $6 & 31 | 0;
  if (32 >>> 0 <= ($6 & 63 | 0) >>> 0) {
   {
    $4 = $9 >> 31 | 0;
    $5 = $9 >> $8 | 0;
   }
  } else {
   {
    $4 = $9 >> $8 | 0;
    $5 = (((1 << $8 | 0) - 1 | 0) & $9 | 0) << (32 - $8 | 0) | 0 | ($7 >>> $8 | 0) | 0;
   }
  }
  $10 = $4;
  $4 = $10;
  $9 = $5;
  $7 = $3_1;
  $6 = $2_1;
  $7 = $4 ^ $7 | 0;
  $4 = $9 ^ $6 | 0;
  $9 = $10;
  $6 = $5;
  $8 = $4 - $6 | 0;
  $10 = $4 >>> 0 < $6 >>> 0;
  $5 = $10 + $9 | 0;
  $5 = $7 - $5 | 0;
  $4 = $5;
  $5 = $12;
  $4 = __wasm_i64_udiv($11 | 0, $5 | 0, $8 | 0, $4 | 0) | 0;
  $5 = i64toi32_i32$HIGH_BITS;
  $10 = $4;
  $8 = $5;
  $5 = $3_1;
  $7 = $2_1;
  $4 = $1_1;
  $6 = $0_1;
  $4 = $5 ^ $4 | 0;
  $5 = $7 ^ $6 | 0;
  $6 = 63;
  $9 = $6 & 31 | 0;
  if (32 >>> 0 <= ($6 & 63 | 0) >>> 0) {
   {
    $7 = $4 >> 31 | 0;
    $0_1 = $4 >> $9 | 0;
   }
  } else {
   {
    $7 = $4 >> $9 | 0;
    $0_1 = (((1 << $9 | 0) - 1 | 0) & $4 | 0) << (32 - $9 | 0) | 0 | ($5 >>> $9 | 0) | 0;
   }
  }
  $1_1 = $7;
  $7 = $8;
  $4 = $10;
  $5 = $1_1;
  $6 = $0_1;
  $5 = $7 ^ $5 | 0;
  $7 = $4 ^ $6 | 0;
  $4 = $1_1;
  $9 = $7 - $6 | 0;
  $10 = $7 >>> 0 < $6 >>> 0;
  $8 = $10 + $4 | 0;
  $8 = $5 - $8 | 0;
  $7 = $9;
  i64toi32_i32$HIGH_BITS = $8;
  return $7 | 0;
 }
 
 function _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0, $13 = 0, $14 = 0, $15 = 0, $16 = 0, $17 = 0, $18 = 0, $19 = 0, $20 = 0;
  label$1 : {
   label$2 : {
    label$3 : {
     label$4 : {
      label$5 : {
       label$6 : {
        label$7 : {
         label$8 : {
          label$9 : {
           label$11 : {
            $7 = $1_1;
            $5 = $0_1;
            $4 = 32;
            $6 = $4 & 31 | 0;
            if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
             $10 = $7 >>> $6 | 0
            } else {
             $10 = (((1 << $6 | 0) - 1 | 0) & $7 | 0) << (32 - $6 | 0) | 0 | ($5 >>> $6 | 0) | 0
            }
            if ($10) {
             {
              $8 = $2_1;
              if (!$8) {
               break label$11
              }
              $9 = $3_1;
              $7 = $2_1;
              $4 = 32;
              $6 = $4 & 31 | 0;
              if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
               $11 = $9 >>> $6 | 0
              } else {
               $11 = (((1 << $6 | 0) - 1 | 0) & $9 | 0) << (32 - $6 | 0) | 0 | ($7 >>> $6 | 0) | 0
              }
              if (!$11) {
               break label$9
              }
              $10 = Math_clz32($11) - Math_clz32($10) | 0;
              if ($10 >>> 0 <= 31 >>> 0) {
               break label$8
              }
              break label$2;
             }
            }
            $5 = $3_1;
            $9 = $2_1;
            $7 = 1;
            $4 = 0;
            if ($5 >>> 0 > $7 >>> 0 | (($5 | 0) == ($7 | 0) & $9 >>> 0 >= $4 >>> 0 | 0) | 0) {
             break label$2
            }
            $10 = $0_1;
            $8 = $2_1;
            $10 = ($10 >>> 0) / ($8 >>> 0) | 0;
            $9 = 0;
            legalfunc$wasm2js_scratch_store_i64($0_1 - Math_imul($10, $8) | 0 | 0, $9 | 0);
            $9 = 0;
            $5 = $10;
            i64toi32_i32$HIGH_BITS = $9;
            return $5 | 0;
           }
           $5 = $3_1;
           $4 = $2_1;
           $7 = 32;
           $6 = $7 & 31 | 0;
           if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
            $8 = $5 >>> $6 | 0
           } else {
            $8 = (((1 << $6 | 0) - 1 | 0) & $5 | 0) << (32 - $6 | 0) | 0 | ($4 >>> $6 | 0) | 0
           }
           if (!$0_1) {
            break label$7
           }
           if (!$8) {
            break label$6
           }
           $11 = $8 + -1 | 0;
           if ($11 & $8 | 0) {
            break label$6
           }
           $9 = 0;
           $5 = $11 & $10 | 0;
           $7 = 32;
           $6 = $7 & 31 | 0;
           if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
            {
             $4 = $5 << $6 | 0;
             $3_1 = 0;
            }
           } else {
            {
             $4 = ((1 << $6 | 0) - 1 | 0) & ($5 >>> (32 - $6 | 0) | 0) | 0 | ($9 << $6 | 0) | 0;
             $3_1 = $5 << $6 | 0;
            }
           }
           $2_1 = $4;
           $4 = $1_1;
           $9 = $0_1;
           $5 = 0;
           $7 = -1;
           $5 = $4 & $5 | 0;
           $7 = $9 & $7 | 0;
           $9 = $5;
           $5 = $2_1;
           $4 = $3_1;
           $9 = $5 | $9 | 0;
           legalfunc$wasm2js_scratch_store_i64($4 | $7 | 0 | 0, $9 | 0);
           $9 = 0;
           $4 = $10 >>> ((__wasm_ctz_i32($8 | 0) | 0) & 31 | 0) | 0;
           i64toi32_i32$HIGH_BITS = $9;
           return $4 | 0;
          }
          $11 = $8 + -1 | 0;
          if (!($11 & $8 | 0)) {
           break label$5
          }
          $10 = (Math_clz32($8) + 33 | 0) - Math_clz32($10) | 0;
          $8 = 0 - $10 | 0;
          break label$3;
         }
         $8 = 63 - $10 | 0;
         $10 = $10 + 1 | 0;
         break label$3;
        }
        $11 = ($10 >>> 0) / ($8 >>> 0) | 0;
        $4 = 0;
        $5 = $10 - Math_imul($11, $8) | 0;
        $7 = 32;
        $6 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $9 = $5 << $6 | 0;
          $0_1 = 0;
         }
        } else {
         {
          $9 = ((1 << $6 | 0) - 1 | 0) & ($5 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
          $0_1 = $5 << $6 | 0;
         }
        }
        legalfunc$wasm2js_scratch_store_i64($0_1 | 0, $9 | 0);
        $9 = 0;
        $5 = $11;
        i64toi32_i32$HIGH_BITS = $9;
        return $5 | 0;
       }
       $10 = Math_clz32($8) - Math_clz32($10) | 0;
       if ($10 >>> 0 < 31 >>> 0) {
        break label$4
       }
       break label$2;
      }
      $5 = 0;
      legalfunc$wasm2js_scratch_store_i64($11 & $0_1 | 0 | 0, $5 | 0);
      if (($8 | 0) == (1 | 0)) {
       break label$1
      }
      $5 = 0;
      $9 = $5;
      $5 = $1_1;
      $4 = $0_1;
      $7 = __wasm_ctz_i32($8 | 0) | 0;
      $6 = $7 & 31 | 0;
      if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
       {
        $9 = 0;
        $4 = $5 >>> $6 | 0;
       }
      } else {
       {
        $9 = $5 >>> $6 | 0;
        $4 = (((1 << $6 | 0) - 1 | 0) & $5 | 0) << (32 - $6 | 0) | 0 | ($4 >>> $6 | 0) | 0;
       }
      }
      i64toi32_i32$HIGH_BITS = $9;
      return $4 | 0;
     }
     $8 = 63 - $10 | 0;
     $10 = $10 + 1 | 0;
    }
    $4 = 0;
    $9 = $4;
    $4 = $1_1;
    $5 = $0_1;
    $7 = $10 & 63 | 0;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $9 = 0;
      $13 = $4 >>> $6 | 0;
     }
    } else {
     {
      $9 = $4 >>> $6 | 0;
      $13 = (((1 << $6 | 0) - 1 | 0) & $4 | 0) << (32 - $6 | 0) | 0 | ($5 >>> $6 | 0) | 0;
     }
    }
    $11 = $9;
    $9 = 0;
    $5 = $9;
    $9 = $1_1;
    $4 = $0_1;
    $7 = $8 & 63 | 0;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $5 = $4 << $6 | 0;
      $0_1 = 0;
     }
    } else {
     {
      $5 = ((1 << $6 | 0) - 1 | 0) & ($4 >>> (32 - $6 | 0) | 0) | 0 | ($9 << $6 | 0) | 0;
      $0_1 = $4 << $6 | 0;
     }
    }
    $1_1 = $5;
    label$13 : {
     if ($10) {
      {
       $5 = $3_1;
       $9 = $2_1;
       $4 = -1;
       $7 = -1;
       $6 = $9 + $7 | 0;
       $8 = $5 + $4 | 0;
       if ($6 >>> 0 < $7 >>> 0) {
        $8 = $8 + 1 | 0
       }
       $17 = $6;
       $15 = $8;
       label$15 : while (1) {
        $8 = $11;
        $5 = $13;
        $7 = 1;
        $4 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $9 = $5 << $4 | 0;
          $12 = 0;
         }
        } else {
         {
          $9 = ((1 << $4 | 0) - 1 | 0) & ($5 >>> (32 - $4 | 0) | 0) | 0 | ($8 << $4 | 0) | 0;
          $12 = $5 << $4 | 0;
         }
        }
        $11 = $9;
        $9 = $1_1;
        $8 = $0_1;
        $7 = 63;
        $4 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = 0;
          $7 = $9 >>> $4 | 0;
         }
        } else {
         {
          $5 = $9 >>> $4 | 0;
          $7 = (((1 << $4 | 0) - 1 | 0) & $9 | 0) << (32 - $4 | 0) | 0 | ($8 >>> $4 | 0) | 0;
         }
        }
        $8 = $5;
        $5 = $11;
        $9 = $12;
        $8 = $5 | $8 | 0;
        $13 = $9 | $7 | 0;
        $11 = $8;
        $18 = $13;
        $19 = $8;
        $8 = $15;
        $5 = $17;
        $9 = $11;
        $7 = $13;
        $4 = $5 - $7 | 0;
        $5 = $5 >>> 0 < $7 >>> 0;
        $6 = $5 + $9 | 0;
        $6 = $8 - $6 | 0;
        $8 = $4;
        $7 = 63;
        $9 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = $6 >> 31 | 0;
          $14 = $6 >> $9 | 0;
         }
        } else {
         {
          $5 = $6 >> $9 | 0;
          $14 = (((1 << $9 | 0) - 1 | 0) & $6 | 0) << (32 - $9 | 0) | 0 | ($8 >>> $9 | 0) | 0;
         }
        }
        $12 = $5;
        $5 = $12;
        $6 = $14;
        $8 = $3_1;
        $7 = $2_1;
        $8 = $5 & $8 | 0;
        $7 = $6 & $7 | 0;
        $6 = $8;
        $8 = $19;
        $5 = $18;
        $9 = $5 - $7 | 0;
        $5 = $5 >>> 0 < $7 >>> 0;
        $4 = $5 + $6 | 0;
        $4 = $8 - $4 | 0;
        $13 = $9;
        $11 = $4;
        $4 = $1_1;
        $8 = $0_1;
        $7 = 1;
        $6 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = $8 << $6 | 0;
          $4 = 0;
         }
        } else {
         {
          $5 = ((1 << $6 | 0) - 1 | 0) & ($8 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
          $4 = $8 << $6 | 0;
         }
        }
        $8 = $16;
        $7 = $20;
        $8 = $5 | $8 | 0;
        $0_1 = $4 | $7 | 0;
        $1_1 = $8;
        $8 = $12;
        $5 = $14;
        $4 = 0;
        $7 = 1;
        $4 = $8 & $4 | 0;
        $14 = $5 & $7 | 0;
        $12 = $4;
        $20 = $14;
        $16 = $4;
        $10 = $10 + -1 | 0;
        if ($10) {
         continue label$15
        }
        break label$15;
       };
       break label$13;
      }
     }
    }
    $4 = $11;
    legalfunc$wasm2js_scratch_store_i64($13 | 0, $4 | 0);
    $4 = $1_1;
    $8 = $0_1;
    $7 = 1;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $5 = $8 << $6 | 0;
      $4 = 0;
     }
    } else {
     {
      $5 = ((1 << $6 | 0) - 1 | 0) & ($8 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
      $4 = $8 << $6 | 0;
     }
    }
    $8 = $12;
    $7 = $14;
    $8 = $5 | $8 | 0;
    $4 = $4 | $7 | 0;
    i64toi32_i32$HIGH_BITS = $8;
    return $4 | 0;
   }
   $4 = $1_1;
   legalfunc$wasm2js_scratch_store_i64($0_1 | 0, $4 | 0);
   $4 = 0;
   $0_1 = 0;
   $1_1 = $4;
  }
  $4 = $1_1;
  $8 = $0_1;
  i64toi32_i32$HIGH_BITS = $4;
  return $8 | 0;
 }
 
 function __wasm_i64_sdiv($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  $3_1 = _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E($0_1 | 0, $1_1 | 0, $2_1 | 0, $3_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $3_1 | 0;
 }
 
 function __wasm_i64_udiv($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  $3_1 = _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0_1 | 0, $1_1 | 0, $2_1 | 0, $3_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $3_1 | 0;
 }
 
 function __wasm_ctz_i32($0_1) {
  $0_1 = $0_1 | 0;
  if ($0_1) {
   return 31 - Math_clz32(($0_1 + -1 | 0) ^ $0_1 | 0) | 0 | 0
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
 function $0($0_1) {
  $0_1 = $0_1 | 0;
  return ($0_1 | 0) / (5 | 0) | 0 | 0;
 }
 
 function $1($0_1) {
  $0_1 = $0_1 | 0;
  return ($0_1 >>> 0) / (5 >>> 0) | 0 | 0;
 }
 
 function $2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0;
  $2_1 = 0;
  $2_1 = __wasm_i64_sdiv($0_1 | 0, $1_1 | 0, 5 | 0, $2_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $2_1 | 0;
 }
 
 function $3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0;
  $2_1 = 0;
  $2_1 = __wasm_i64_udiv($0_1 | 0, $1_1 | 0, 5 | 0, $2_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $2_1 | 0;
 }
 
 function legalstub$2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0, $5 = 0, $6 = 0;
  $3_1 = 0;
  $5 = $0_1;
  $6 = $3_1;
  $3_1 = 0;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0_1 = $1_1 << $2_1 | 0;
    $4 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $2_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $2_1 | 0) | 0) | 0 | ($3_1 << $2_1 | 0) | 0;
    $4 = $1_1 << $2_1 | 0;
   }
  }
  $1_1 = $0_1;
  $0_1 = $6;
  $3_1 = $5;
  $1_1 = $0_1 | $1_1 | 0;
  $1_1 = $2($3_1 | $4 | 0 | 0, $1_1 | 0) | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  $6 = $1_1;
  $5 = $3_1;
  $0_1 = $1_1;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0_1 = $3_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $3_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $6 | 0;
 }
 
 function legalstub$3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0, $5 = 0, $6 = 0;
  $3_1 = 0;
  $5 = $0_1;
  $6 = $3_1;
  $3_1 = 0;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0_1 = $1_1 << $2_1 | 0;
    $4 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $2_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $2_1 | 0) | 0) | 0 | ($3_1 << $2_1 | 0) | 0;
    $4 = $1_1 << $2_1 | 0;
   }
  }
  $1_1 = $0_1;
  $0_1 = $6;
  $3_1 = $5;
  $1_1 = $0_1 | $1_1 | 0;
  $1_1 = $3($3_1 | $4 | 0 | 0, $1_1 | 0) | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  $6 = $1_1;
  $5 = $3_1;
  $0_1 = $1_1;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0_1 = $3_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $3_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $6 | 0;
 }
 
 function legalfunc$wasm2js_scratch_store_i64($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0;
  $4 = $0_1;
  $3_1 = 32;
  $2_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   $0_1 = $1_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $1_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  legalimport$wasm2js_scratch_store_i64($4 | 0, $0_1 | 0);
 }
 
 function _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0;
  $8 = $1_1;
  $7 = $0_1;
  $6 = 63;
  $5 = $6 & 31 | 0;
  if (32 >>> 0 <= ($6 & 63 | 0) >>> 0) {
   {
    $4 = $8 >> 31 | 0;
    $5 = $8 >> $5 | 0;
   }
  } else {
   {
    $4 = $8 >> $5 | 0;
    $5 = (((1 << $5 | 0) - 1 | 0) & $8 | 0) << (32 - $5 | 0) | 0 | ($7 >>> $5 | 0) | 0;
   }
  }
  $10 = $4;
  $4 = $10;
  $8 = $5;
  $7 = $1_1;
  $6 = $0_1;
  $7 = $4 ^ $7 | 0;
  $4 = $8 ^ $6 | 0;
  $8 = $10;
  $6 = $5;
  $5 = $4 - $6 | 0;
  $10 = $4 >>> 0 < $6 >>> 0;
  $9 = $10 + $8 | 0;
  $9 = $7 - $9 | 0;
  $11 = $5;
  $12 = $9;
  $9 = $3_1;
  $7 = $2_1;
  $6 = 63;
  $8 = $6 & 31 | 0;
  if (32 >>> 0 <= ($6 & 63 | 0) >>> 0) {
   {
    $4 = $9 >> 31 | 0;
    $5 = $9 >> $8 | 0;
   }
  } else {
   {
    $4 = $9 >> $8 | 0;
    $5 = (((1 << $8 | 0) - 1 | 0) & $9 | 0) << (32 - $8 | 0) | 0 | ($7 >>> $8 | 0) | 0;
   }
  }
  $10 = $4;
  $4 = $10;
  $9 = $5;
  $7 = $3_1;
  $6 = $2_1;
  $7 = $4 ^ $7 | 0;
  $4 = $9 ^ $6 | 0;
  $9 = $10;
  $6 = $5;
  $8 = $4 - $6 | 0;
  $10 = $4 >>> 0 < $6 >>> 0;
  $5 = $10 + $9 | 0;
  $5 = $7 - $5 | 0;
  $4 = $5;
  $5 = $12;
  $4 = __wasm_i64_udiv($11 | 0, $5 | 0, $8 | 0, $4 | 0) | 0;
  $5 = i64toi32_i32$HIGH_BITS;
  $10 = $4;
  $8 = $5;
  $5 = $3_1;
  $7 = $2_1;
  $4 = $1_1;
  $6 = $0_1;
  $4 = $5 ^ $4 | 0;
  $5 = $7 ^ $6 | 0;
  $6 = 63;
  $9 = $6 & 31 | 0;
  if (32 >>> 0 <= ($6 & 63 | 0) >>> 0) {
   {
    $7 = $4 >> 31 | 0;
    $0_1 = $4 >> $9 | 0;
   }
  } else {
   {
    $7 = $4 >> $9 | 0;
    $0_1 = (((1 << $9 | 0) - 1 | 0) & $4 | 0) << (32 - $9 | 0) | 0 | ($5 >>> $9 | 0) | 0;
   }
  }
  $1_1 = $7;
  $7 = $8;
  $4 = $10;
  $5 = $1_1;
  $6 = $0_1;
  $5 = $7 ^ $5 | 0;
  $7 = $4 ^ $6 | 0;
  $4 = $1_1;
  $9 = $7 - $6 | 0;
  $10 = $7 >>> 0 < $6 >>> 0;
  $8 = $10 + $4 | 0;
  $8 = $5 - $8 | 0;
  $7 = $9;
  i64toi32_i32$HIGH_BITS = $8;
  return $7 | 0;
 }
 
 function _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0, $13 = 0, $14 = 0, $15 = 0, $16 = 0, $17 = 0, $18 = 0, $19 = 0, $20 = 0;
  label$1 : {
   label$2 : {
    label$3 : {
     label$4 : {
      label$5 : {
       label$6 : {
        label$7 : {
         label$8 : {
          label$9 : {
           label$11 : {
            $7 = $1_1;
            $5 = $0_1;
            $4 = 32;
            $6 = $4 & 31 | 0;
            if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
             $10 = $7 >>> $6 | 0
            } else {
             $10 = (((1 << $6 | 0) - 1 | 0) & $7 | 0) << (32 - $6 | 0) | 0 | ($5 >>> $6 | 0) | 0
            }
            if ($10) {
             {
              $8 = $2_1;
              if (!$8) {
               break label$11
              }
              $9 = $3_1;
              $7 = $2_1;
              $4 = 32;
              $6 = $4 & 31 | 0;
              if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
               $11 = $9 >>> $6 | 0
              } else {
               $11 = (((1 << $6 | 0) - 1 | 0) & $9 | 0) << (32 - $6 | 0) | 0 | ($7 >>> $6 | 0) | 0
              }
              if (!$11) {
               break label$9
              }
              $10 = Math_clz32($11) - Math_clz32($10) | 0;
              if ($10 >>> 0 <= 31 >>> 0) {
               break label$8
              }
              break label$2;
             }
            }
            $5 = $3_1;
            $9 = $2_1;
            $7 = 1;
            $4 = 0;
            if ($5 >>> 0 > $7 >>> 0 | (($5 | 0) == ($7 | 0) & $9 >>> 0 >= $4 >>> 0 | 0) | 0) {
             break label$2
            }
            $10 = $0_1;
            $8 = $2_1;
            $10 = ($10 >>> 0) / ($8 >>> 0) | 0;
            $9 = 0;
            legalfunc$wasm2js_scratch_store_i64($0_1 - Math_imul($10, $8) | 0 | 0, $9 | 0);
            $9 = 0;
            $5 = $10;
            i64toi32_i32$HIGH_BITS = $9;
            return $5 | 0;
           }
           $5 = $3_1;
           $4 = $2_1;
           $7 = 32;
           $6 = $7 & 31 | 0;
           if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
            $8 = $5 >>> $6 | 0
           } else {
            $8 = (((1 << $6 | 0) - 1 | 0) & $5 | 0) << (32 - $6 | 0) | 0 | ($4 >>> $6 | 0) | 0
           }
           if (!$0_1) {
            break label$7
           }
           if (!$8) {
            break label$6
           }
           $11 = $8 + -1 | 0;
           if ($11 & $8 | 0) {
            break label$6
           }
           $9 = 0;
           $5 = $11 & $10 | 0;
           $7 = 32;
           $6 = $7 & 31 | 0;
           if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
            {
             $4 = $5 << $6 | 0;
             $3_1 = 0;
            }
           } else {
            {
             $4 = ((1 << $6 | 0) - 1 | 0) & ($5 >>> (32 - $6 | 0) | 0) | 0 | ($9 << $6 | 0) | 0;
             $3_1 = $5 << $6 | 0;
            }
           }
           $2_1 = $4;
           $4 = $1_1;
           $9 = $0_1;
           $5 = 0;
           $7 = -1;
           $5 = $4 & $5 | 0;
           $7 = $9 & $7 | 0;
           $9 = $5;
           $5 = $2_1;
           $4 = $3_1;
           $9 = $5 | $9 | 0;
           legalfunc$wasm2js_scratch_store_i64($4 | $7 | 0 | 0, $9 | 0);
           $9 = 0;
           $4 = $10 >>> ((__wasm_ctz_i32($8 | 0) | 0) & 31 | 0) | 0;
           i64toi32_i32$HIGH_BITS = $9;
           return $4 | 0;
          }
          $11 = $8 + -1 | 0;
          if (!($11 & $8 | 0)) {
           break label$5
          }
          $10 = (Math_clz32($8) + 33 | 0) - Math_clz32($10) | 0;
          $8 = 0 - $10 | 0;
          break label$3;
         }
         $8 = 63 - $10 | 0;
         $10 = $10 + 1 | 0;
         break label$3;
        }
        $11 = ($10 >>> 0) / ($8 >>> 0) | 0;
        $4 = 0;
        $5 = $10 - Math_imul($11, $8) | 0;
        $7 = 32;
        $6 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $9 = $5 << $6 | 0;
          $0_1 = 0;
         }
        } else {
         {
          $9 = ((1 << $6 | 0) - 1 | 0) & ($5 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
          $0_1 = $5 << $6 | 0;
         }
        }
        legalfunc$wasm2js_scratch_store_i64($0_1 | 0, $9 | 0);
        $9 = 0;
        $5 = $11;
        i64toi32_i32$HIGH_BITS = $9;
        return $5 | 0;
       }
       $10 = Math_clz32($8) - Math_clz32($10) | 0;
       if ($10 >>> 0 < 31 >>> 0) {
        break label$4
       }
       break label$2;
      }
      $5 = 0;
      legalfunc$wasm2js_scratch_store_i64($11 & $0_1 | 0 | 0, $5 | 0);
      if (($8 | 0) == (1 | 0)) {
       break label$1
      }
      $5 = 0;
      $9 = $5;
      $5 = $1_1;
      $4 = $0_1;
      $7 = __wasm_ctz_i32($8 | 0) | 0;
      $6 = $7 & 31 | 0;
      if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
       {
        $9 = 0;
        $4 = $5 >>> $6 | 0;
       }
      } else {
       {
        $9 = $5 >>> $6 | 0;
        $4 = (((1 << $6 | 0) - 1 | 0) & $5 | 0) << (32 - $6 | 0) | 0 | ($4 >>> $6 | 0) | 0;
       }
      }
      i64toi32_i32$HIGH_BITS = $9;
      return $4 | 0;
     }
     $8 = 63 - $10 | 0;
     $10 = $10 + 1 | 0;
    }
    $4 = 0;
    $9 = $4;
    $4 = $1_1;
    $5 = $0_1;
    $7 = $10 & 63 | 0;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $9 = 0;
      $13 = $4 >>> $6 | 0;
     }
    } else {
     {
      $9 = $4 >>> $6 | 0;
      $13 = (((1 << $6 | 0) - 1 | 0) & $4 | 0) << (32 - $6 | 0) | 0 | ($5 >>> $6 | 0) | 0;
     }
    }
    $11 = $9;
    $9 = 0;
    $5 = $9;
    $9 = $1_1;
    $4 = $0_1;
    $7 = $8 & 63 | 0;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $5 = $4 << $6 | 0;
      $0_1 = 0;
     }
    } else {
     {
      $5 = ((1 << $6 | 0) - 1 | 0) & ($4 >>> (32 - $6 | 0) | 0) | 0 | ($9 << $6 | 0) | 0;
      $0_1 = $4 << $6 | 0;
     }
    }
    $1_1 = $5;
    label$13 : {
     if ($10) {
      {
       $5 = $3_1;
       $9 = $2_1;
       $4 = -1;
       $7 = -1;
       $6 = $9 + $7 | 0;
       $8 = $5 + $4 | 0;
       if ($6 >>> 0 < $7 >>> 0) {
        $8 = $8 + 1 | 0
       }
       $17 = $6;
       $15 = $8;
       label$15 : while (1) {
        $8 = $11;
        $5 = $13;
        $7 = 1;
        $4 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $9 = $5 << $4 | 0;
          $12 = 0;
         }
        } else {
         {
          $9 = ((1 << $4 | 0) - 1 | 0) & ($5 >>> (32 - $4 | 0) | 0) | 0 | ($8 << $4 | 0) | 0;
          $12 = $5 << $4 | 0;
         }
        }
        $11 = $9;
        $9 = $1_1;
        $8 = $0_1;
        $7 = 63;
        $4 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = 0;
          $7 = $9 >>> $4 | 0;
         }
        } else {
         {
          $5 = $9 >>> $4 | 0;
          $7 = (((1 << $4 | 0) - 1 | 0) & $9 | 0) << (32 - $4 | 0) | 0 | ($8 >>> $4 | 0) | 0;
         }
        }
        $8 = $5;
        $5 = $11;
        $9 = $12;
        $8 = $5 | $8 | 0;
        $13 = $9 | $7 | 0;
        $11 = $8;
        $18 = $13;
        $19 = $8;
        $8 = $15;
        $5 = $17;
        $9 = $11;
        $7 = $13;
        $4 = $5 - $7 | 0;
        $5 = $5 >>> 0 < $7 >>> 0;
        $6 = $5 + $9 | 0;
        $6 = $8 - $6 | 0;
        $8 = $4;
        $7 = 63;
        $9 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = $6 >> 31 | 0;
          $14 = $6 >> $9 | 0;
         }
        } else {
         {
          $5 = $6 >> $9 | 0;
          $14 = (((1 << $9 | 0) - 1 | 0) & $6 | 0) << (32 - $9 | 0) | 0 | ($8 >>> $9 | 0) | 0;
         }
        }
        $12 = $5;
        $5 = $12;
        $6 = $14;
        $8 = $3_1;
        $7 = $2_1;
        $8 = $5 & $8 | 0;
        $7 = $6 & $7 | 0;
        $6 = $8;
        $8 = $19;
        $5 = $18;
        $9 = $5 - $7 | 0;
        $5 = $5 >>> 0 < $7 >>> 0;
        $4 = $5 + $6 | 0;
        $4 = $8 - $4 | 0;
        $13 = $9;
        $11 = $4;
        $4 = $1_1;
        $8 = $0_1;
        $7 = 1;
        $6 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = $8 << $6 | 0;
          $4 = 0;
         }
        } else {
         {
          $5 = ((1 << $6 | 0) - 1 | 0) & ($8 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
          $4 = $8 << $6 | 0;
         }
        }
        $8 = $16;
        $7 = $20;
        $8 = $5 | $8 | 0;
        $0_1 = $4 | $7 | 0;
        $1_1 = $8;
        $8 = $12;
        $5 = $14;
        $4 = 0;
        $7 = 1;
        $4 = $8 & $4 | 0;
        $14 = $5 & $7 | 0;
        $12 = $4;
        $20 = $14;
        $16 = $4;
        $10 = $10 + -1 | 0;
        if ($10) {
         continue label$15
        }
        break label$15;
       };
       break label$13;
      }
     }
    }
    $4 = $11;
    legalfunc$wasm2js_scratch_store_i64($13 | 0, $4 | 0);
    $4 = $1_1;
    $8 = $0_1;
    $7 = 1;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $5 = $8 << $6 | 0;
      $4 = 0;
     }
    } else {
     {
      $5 = ((1 << $6 | 0) - 1 | 0) & ($8 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
      $4 = $8 << $6 | 0;
     }
    }
    $8 = $12;
    $7 = $14;
    $8 = $5 | $8 | 0;
    $4 = $4 | $7 | 0;
    i64toi32_i32$HIGH_BITS = $8;
    return $4 | 0;
   }
   $4 = $1_1;
   legalfunc$wasm2js_scratch_store_i64($0_1 | 0, $4 | 0);
   $4 = 0;
   $0_1 = 0;
   $1_1 = $4;
  }
  $4 = $1_1;
  $8 = $0_1;
  i64toi32_i32$HIGH_BITS = $4;
  return $8 | 0;
 }
 
 function __wasm_i64_sdiv($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  $3_1 = _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E($0_1 | 0, $1_1 | 0, $2_1 | 0, $3_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $3_1 | 0;
 }
 
 function __wasm_i64_udiv($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  $3_1 = _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0_1 | 0, $1_1 | 0, $2_1 | 0, $3_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $3_1 | 0;
 }
 
 function __wasm_ctz_i32($0_1) {
  $0_1 = $0_1 | 0;
  if ($0_1) {
   return 31 - Math_clz32(($0_1 + -1 | 0) ^ $0_1 | 0) | 0 | 0
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
 function $0($0_1) {
  $0_1 = $0_1 | 0;
  return ($0_1 | 0) / (7 | 0) | 0 | 0;
 }
 
 function $1($0_1) {
  $0_1 = $0_1 | 0;
  return ($0_1 >>> 0) / (7 >>> 0) | 0 | 0;
 }
 
 function $2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0;
  $2_1 = 0;
  $2_1 = __wasm_i64_sdiv($0_1 | 0, $1_1 | 0, 7 | 0, $2_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $2_1 | 0;
 }
 
 function $3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0;
  $2_1 = 0;
  $2_1 = __wasm_i64_udiv($0_1 | 0, $1_1 | 0, 7 | 0, $2_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $2_1 | 0;
 }
 
 function legalstub$2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0, $5 = 0, $6 = 0;
  $3_1 = 0;
  $5 = $0_1;
  $6 = $3_1;
  $3_1 = 0;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0_1 = $1_1 << $2_1 | 0;
    $4 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $2_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $2_1 | 0) | 0) | 0 | ($3_1 << $2_1 | 0) | 0;
    $4 = $1_1 << $2_1 | 0;
   }
  }
  $1_1 = $0_1;
  $0_1 = $6;
  $3_1 = $5;
  $1_1 = $0_1 | $1_1 | 0;
  $1_1 = $2($3_1 | $4 | 0 | 0, $1_1 | 0) | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  $6 = $1_1;
  $5 = $3_1;
  $0_1 = $1_1;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0_1 = $3_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $3_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $6 | 0;
 }
 
 function legalstub$3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0, $5 = 0, $6 = 0;
  $3_1 = 0;
  $5 = $0_1;
  $6 = $3_1;
  $3_1 = 0;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0_1 = $1_1 << $2_1 | 0;
    $4 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $2_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $2_1 | 0) | 0) | 0 | ($3_1 << $2_1 | 0) | 0;
    $4 = $1_1 << $2_1 | 0;
   }
  }
  $1_1 = $0_1;
  $0_1 = $6;
  $3_1 = $5;
  $1_1 = $0_1 | $1_1 | 0;
  $1_1 = $3($3_1 | $4 | 0 | 0, $1_1 | 0) | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  $6 = $1_1;
  $5 = $3_1;
  $0_1 = $1_1;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0_1 = $3_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $3_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $6 | 0;
 }
 
 function legalfunc$wasm2js_scratch_store_i64($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0;
  $4 = $0_1;
  $3_1 = 32;
  $2_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   $0_1 = $1_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $1_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  legalimport$wasm2js_scratch_store_i64($4 | 0, $0_1 | 0);
 }
 
 function _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0;
  $8 = $1_1;
  $7 = $0_1;
  $6 = 63;
  $5 = $6 & 31 | 0;
  if (32 >>> 0 <= ($6 & 63 | 0) >>> 0) {
   {
    $4 = $8 >> 31 | 0;
    $5 = $8 >> $5 | 0;
   }
  } else {
   {
    $4 = $8 >> $5 | 0;
    $5 = (((1 << $5 | 0) - 1 | 0) & $8 | 0) << (32 - $5 | 0) | 0 | ($7 >>> $5 | 0) | 0;
   }
  }
  $10 = $4;
  $4 = $10;
  $8 = $5;
  $7 = $1_1;
  $6 = $0_1;
  $7 = $4 ^ $7 | 0;
  $4 = $8 ^ $6 | 0;
  $8 = $10;
  $6 = $5;
  $5 = $4 - $6 | 0;
  $10 = $4 >>> 0 < $6 >>> 0;
  $9 = $10 + $8 | 0;
  $9 = $7 - $9 | 0;
  $11 = $5;
  $12 = $9;
  $9 = $3_1;
  $7 = $2_1;
  $6 = 63;
  $8 = $6 & 31 | 0;
  if (32 >>> 0 <= ($6 & 63 | 0) >>> 0) {
   {
    $4 = $9 >> 31 | 0;
    $5 = $9 >> $8 | 0;
   }
  } else {
   {
    $4 = $9 >> $8 | 0;
    $5 = (((1 << $8 | 0) - 1 | 0) & $9 | 0) << (32 - $8 | 0) | 0 | ($7 >>> $8 | 0) | 0;
   }
  }
  $10 = $4;
  $4 = $10;
  $9 = $5;
  $7 = $3_1;
  $6 = $2_1;
  $7 = $4 ^ $7 | 0;
  $4 = $9 ^ $6 | 0;
  $9 = $10;
  $6 = $5;
  $8 = $4 - $6 | 0;
  $10 = $4 >>> 0 < $6 >>> 0;
  $5 = $10 + $9 | 0;
  $5 = $7 - $5 | 0;
  $4 = $5;
  $5 = $12;
  $4 = __wasm_i64_udiv($11 | 0, $5 | 0, $8 | 0, $4 | 0) | 0;
  $5 = i64toi32_i32$HIGH_BITS;
  $10 = $4;
  $8 = $5;
  $5 = $3_1;
  $7 = $2_1;
  $4 = $1_1;
  $6 = $0_1;
  $4 = $5 ^ $4 | 0;
  $5 = $7 ^ $6 | 0;
  $6 = 63;
  $9 = $6 & 31 | 0;
  if (32 >>> 0 <= ($6 & 63 | 0) >>> 0) {
   {
    $7 = $4 >> 31 | 0;
    $0_1 = $4 >> $9 | 0;
   }
  } else {
   {
    $7 = $4 >> $9 | 0;
    $0_1 = (((1 << $9 | 0) - 1 | 0) & $4 | 0) << (32 - $9 | 0) | 0 | ($5 >>> $9 | 0) | 0;
   }
  }
  $1_1 = $7;
  $7 = $8;
  $4 = $10;
  $5 = $1_1;
  $6 = $0_1;
  $5 = $7 ^ $5 | 0;
  $7 = $4 ^ $6 | 0;
  $4 = $1_1;
  $9 = $7 - $6 | 0;
  $10 = $7 >>> 0 < $6 >>> 0;
  $8 = $10 + $4 | 0;
  $8 = $5 - $8 | 0;
  $7 = $9;
  i64toi32_i32$HIGH_BITS = $8;
  return $7 | 0;
 }
 
 function _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0, $13 = 0, $14 = 0, $15 = 0, $16 = 0, $17 = 0, $18 = 0, $19 = 0, $20 = 0;
  label$1 : {
   label$2 : {
    label$3 : {
     label$4 : {
      label$5 : {
       label$6 : {
        label$7 : {
         label$8 : {
          label$9 : {
           label$11 : {
            $7 = $1_1;
            $5 = $0_1;
            $4 = 32;
            $6 = $4 & 31 | 0;
            if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
             $10 = $7 >>> $6 | 0
            } else {
             $10 = (((1 << $6 | 0) - 1 | 0) & $7 | 0) << (32 - $6 | 0) | 0 | ($5 >>> $6 | 0) | 0
            }
            if ($10) {
             {
              $8 = $2_1;
              if (!$8) {
               break label$11
              }
              $9 = $3_1;
              $7 = $2_1;
              $4 = 32;
              $6 = $4 & 31 | 0;
              if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
               $11 = $9 >>> $6 | 0
              } else {
               $11 = (((1 << $6 | 0) - 1 | 0) & $9 | 0) << (32 - $6 | 0) | 0 | ($7 >>> $6 | 0) | 0
              }
              if (!$11) {
               break label$9
              }
              $10 = Math_clz32($11) - Math_clz32($10) | 0;
              if ($10 >>> 0 <= 31 >>> 0) {
               break label$8
              }
              break label$2;
             }
            }
            $5 = $3_1;
            $9 = $2_1;
            $7 = 1;
            $4 = 0;
            if ($5 >>> 0 > $7 >>> 0 | (($5 | 0) == ($7 | 0) & $9 >>> 0 >= $4 >>> 0 | 0) | 0) {
             break label$2
            }
            $10 = $0_1;
            $8 = $2_1;
            $10 = ($10 >>> 0) / ($8 >>> 0) | 0;
            $9 = 0;
            legalfunc$wasm2js_scratch_store_i64($0_1 - Math_imul($10, $8) | 0 | 0, $9 | 0);
            $9 = 0;
            $5 = $10;
            i64toi32_i32$HIGH_BITS = $9;
            return $5 | 0;
           }
           $5 = $3_1;
           $4 = $2_1;
           $7 = 32;
           $6 = $7 & 31 | 0;
           if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
            $8 = $5 >>> $6 | 0
           } else {
            $8 = (((1 << $6 | 0) - 1 | 0) & $5 | 0) << (32 - $6 | 0) | 0 | ($4 >>> $6 | 0) | 0
           }
           if (!$0_1) {
            break label$7
           }
           if (!$8) {
            break label$6
           }
           $11 = $8 + -1 | 0;
           if ($11 & $8 | 0) {
            break label$6
           }
           $9 = 0;
           $5 = $11 & $10 | 0;
           $7 = 32;
           $6 = $7 & 31 | 0;
           if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
            {
             $4 = $5 << $6 | 0;
             $3_1 = 0;
            }
           } else {
            {
             $4 = ((1 << $6 | 0) - 1 | 0) & ($5 >>> (32 - $6 | 0) | 0) | 0 | ($9 << $6 | 0) | 0;
             $3_1 = $5 << $6 | 0;
            }
           }
           $2_1 = $4;
           $4 = $1_1;
           $9 = $0_1;
           $5 = 0;
           $7 = -1;
           $5 = $4 & $5 | 0;
           $7 = $9 & $7 | 0;
           $9 = $5;
           $5 = $2_1;
           $4 = $3_1;
           $9 = $5 | $9 | 0;
           legalfunc$wasm2js_scratch_store_i64($4 | $7 | 0 | 0, $9 | 0);
           $9 = 0;
           $4 = $10 >>> ((__wasm_ctz_i32($8 | 0) | 0) & 31 | 0) | 0;
           i64toi32_i32$HIGH_BITS = $9;
           return $4 | 0;
          }
          $11 = $8 + -1 | 0;
          if (!($11 & $8 | 0)) {
           break label$5
          }
          $10 = (Math_clz32($8) + 33 | 0) - Math_clz32($10) | 0;
          $8 = 0 - $10 | 0;
          break label$3;
         }
         $8 = 63 - $10 | 0;
         $10 = $10 + 1 | 0;
         break label$3;
        }
        $11 = ($10 >>> 0) / ($8 >>> 0) | 0;
        $4 = 0;
        $5 = $10 - Math_imul($11, $8) | 0;
        $7 = 32;
        $6 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $9 = $5 << $6 | 0;
          $0_1 = 0;
         }
        } else {
         {
          $9 = ((1 << $6 | 0) - 1 | 0) & ($5 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
          $0_1 = $5 << $6 | 0;
         }
        }
        legalfunc$wasm2js_scratch_store_i64($0_1 | 0, $9 | 0);
        $9 = 0;
        $5 = $11;
        i64toi32_i32$HIGH_BITS = $9;
        return $5 | 0;
       }
       $10 = Math_clz32($8) - Math_clz32($10) | 0;
       if ($10 >>> 0 < 31 >>> 0) {
        break label$4
       }
       break label$2;
      }
      $5 = 0;
      legalfunc$wasm2js_scratch_store_i64($11 & $0_1 | 0 | 0, $5 | 0);
      if (($8 | 0) == (1 | 0)) {
       break label$1
      }
      $5 = 0;
      $9 = $5;
      $5 = $1_1;
      $4 = $0_1;
      $7 = __wasm_ctz_i32($8 | 0) | 0;
      $6 = $7 & 31 | 0;
      if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
       {
        $9 = 0;
        $4 = $5 >>> $6 | 0;
       }
      } else {
       {
        $9 = $5 >>> $6 | 0;
        $4 = (((1 << $6 | 0) - 1 | 0) & $5 | 0) << (32 - $6 | 0) | 0 | ($4 >>> $6 | 0) | 0;
       }
      }
      i64toi32_i32$HIGH_BITS = $9;
      return $4 | 0;
     }
     $8 = 63 - $10 | 0;
     $10 = $10 + 1 | 0;
    }
    $4 = 0;
    $9 = $4;
    $4 = $1_1;
    $5 = $0_1;
    $7 = $10 & 63 | 0;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $9 = 0;
      $13 = $4 >>> $6 | 0;
     }
    } else {
     {
      $9 = $4 >>> $6 | 0;
      $13 = (((1 << $6 | 0) - 1 | 0) & $4 | 0) << (32 - $6 | 0) | 0 | ($5 >>> $6 | 0) | 0;
     }
    }
    $11 = $9;
    $9 = 0;
    $5 = $9;
    $9 = $1_1;
    $4 = $0_1;
    $7 = $8 & 63 | 0;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $5 = $4 << $6 | 0;
      $0_1 = 0;
     }
    } else {
     {
      $5 = ((1 << $6 | 0) - 1 | 0) & ($4 >>> (32 - $6 | 0) | 0) | 0 | ($9 << $6 | 0) | 0;
      $0_1 = $4 << $6 | 0;
     }
    }
    $1_1 = $5;
    label$13 : {
     if ($10) {
      {
       $5 = $3_1;
       $9 = $2_1;
       $4 = -1;
       $7 = -1;
       $6 = $9 + $7 | 0;
       $8 = $5 + $4 | 0;
       if ($6 >>> 0 < $7 >>> 0) {
        $8 = $8 + 1 | 0
       }
       $17 = $6;
       $15 = $8;
       label$15 : while (1) {
        $8 = $11;
        $5 = $13;
        $7 = 1;
        $4 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $9 = $5 << $4 | 0;
          $12 = 0;
         }
        } else {
         {
          $9 = ((1 << $4 | 0) - 1 | 0) & ($5 >>> (32 - $4 | 0) | 0) | 0 | ($8 << $4 | 0) | 0;
          $12 = $5 << $4 | 0;
         }
        }
        $11 = $9;
        $9 = $1_1;
        $8 = $0_1;
        $7 = 63;
        $4 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = 0;
          $7 = $9 >>> $4 | 0;
         }
        } else {
         {
          $5 = $9 >>> $4 | 0;
          $7 = (((1 << $4 | 0) - 1 | 0) & $9 | 0) << (32 - $4 | 0) | 0 | ($8 >>> $4 | 0) | 0;
         }
        }
        $8 = $5;
        $5 = $11;
        $9 = $12;
        $8 = $5 | $8 | 0;
        $13 = $9 | $7 | 0;
        $11 = $8;
        $18 = $13;
        $19 = $8;
        $8 = $15;
        $5 = $17;
        $9 = $11;
        $7 = $13;
        $4 = $5 - $7 | 0;
        $5 = $5 >>> 0 < $7 >>> 0;
        $6 = $5 + $9 | 0;
        $6 = $8 - $6 | 0;
        $8 = $4;
        $7 = 63;
        $9 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = $6 >> 31 | 0;
          $14 = $6 >> $9 | 0;
         }
        } else {
         {
          $5 = $6 >> $9 | 0;
          $14 = (((1 << $9 | 0) - 1 | 0) & $6 | 0) << (32 - $9 | 0) | 0 | ($8 >>> $9 | 0) | 0;
         }
        }
        $12 = $5;
        $5 = $12;
        $6 = $14;
        $8 = $3_1;
        $7 = $2_1;
        $8 = $5 & $8 | 0;
        $7 = $6 & $7 | 0;
        $6 = $8;
        $8 = $19;
        $5 = $18;
        $9 = $5 - $7 | 0;
        $5 = $5 >>> 0 < $7 >>> 0;
        $4 = $5 + $6 | 0;
        $4 = $8 - $4 | 0;
        $13 = $9;
        $11 = $4;
        $4 = $1_1;
        $8 = $0_1;
        $7 = 1;
        $6 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = $8 << $6 | 0;
          $4 = 0;
         }
        } else {
         {
          $5 = ((1 << $6 | 0) - 1 | 0) & ($8 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
          $4 = $8 << $6 | 0;
         }
        }
        $8 = $16;
        $7 = $20;
        $8 = $5 | $8 | 0;
        $0_1 = $4 | $7 | 0;
        $1_1 = $8;
        $8 = $12;
        $5 = $14;
        $4 = 0;
        $7 = 1;
        $4 = $8 & $4 | 0;
        $14 = $5 & $7 | 0;
        $12 = $4;
        $20 = $14;
        $16 = $4;
        $10 = $10 + -1 | 0;
        if ($10) {
         continue label$15
        }
        break label$15;
       };
       break label$13;
      }
     }
    }
    $4 = $11;
    legalfunc$wasm2js_scratch_store_i64($13 | 0, $4 | 0);
    $4 = $1_1;
    $8 = $0_1;
    $7 = 1;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $5 = $8 << $6 | 0;
      $4 = 0;
     }
    } else {
     {
      $5 = ((1 << $6 | 0) - 1 | 0) & ($8 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
      $4 = $8 << $6 | 0;
     }
    }
    $8 = $12;
    $7 = $14;
    $8 = $5 | $8 | 0;
    $4 = $4 | $7 | 0;
    i64toi32_i32$HIGH_BITS = $8;
    return $4 | 0;
   }
   $4 = $1_1;
   legalfunc$wasm2js_scratch_store_i64($0_1 | 0, $4 | 0);
   $4 = 0;
   $0_1 = 0;
   $1_1 = $4;
  }
  $4 = $1_1;
  $8 = $0_1;
  i64toi32_i32$HIGH_BITS = $4;
  return $8 | 0;
 }
 
 function __wasm_i64_sdiv($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  $3_1 = _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E($0_1 | 0, $1_1 | 0, $2_1 | 0, $3_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $3_1 | 0;
 }
 
 function __wasm_i64_udiv($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  $3_1 = _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0_1 | 0, $1_1 | 0, $2_1 | 0, $3_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $3_1 | 0;
 }
 
 function __wasm_ctz_i32($0_1) {
  $0_1 = $0_1 | 0;
  if ($0_1) {
   return 31 - Math_clz32(($0_1 + -1 | 0) ^ $0_1 | 0) | 0 | 0
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
 var getTempRet0 = env.getTempRet0;
 var i64toi32_i32$HIGH_BITS = 0;
 function $0($0_1) {
  $0_1 = $0_1 | 0;
  return ($0_1 | 0) % (3 | 0) | 0 | 0;
 }
 
 function $1($0_1) {
  $0_1 = $0_1 | 0;
  return ($0_1 >>> 0) % (3 >>> 0) | 0 | 0;
 }
 
 function $2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0;
  $2_1 = 0;
  $2_1 = __wasm_i64_srem($0_1 | 0, $1_1 | 0, 3 | 0, $2_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $2_1 | 0;
 }
 
 function $3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0;
  $2_1 = 0;
  $2_1 = __wasm_i64_urem($0_1 | 0, $1_1 | 0, 3 | 0, $2_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $2_1 | 0;
 }
 
 function legalstub$2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0, $5 = 0, $6 = 0;
  $3_1 = 0;
  $5 = $0_1;
  $6 = $3_1;
  $3_1 = 0;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0_1 = $1_1 << $2_1 | 0;
    $4 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $2_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $2_1 | 0) | 0) | 0 | ($3_1 << $2_1 | 0) | 0;
    $4 = $1_1 << $2_1 | 0;
   }
  }
  $1_1 = $0_1;
  $0_1 = $6;
  $3_1 = $5;
  $1_1 = $0_1 | $1_1 | 0;
  $1_1 = $2($3_1 | $4 | 0 | 0, $1_1 | 0) | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  $6 = $1_1;
  $5 = $3_1;
  $0_1 = $1_1;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0_1 = $3_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $3_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $6 | 0;
 }
 
 function legalstub$3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0, $5 = 0, $6 = 0;
  $3_1 = 0;
  $5 = $0_1;
  $6 = $3_1;
  $3_1 = 0;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0_1 = $1_1 << $2_1 | 0;
    $4 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $2_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $2_1 | 0) | 0) | 0 | ($3_1 << $2_1 | 0) | 0;
    $4 = $1_1 << $2_1 | 0;
   }
  }
  $1_1 = $0_1;
  $0_1 = $6;
  $3_1 = $5;
  $1_1 = $0_1 | $1_1 | 0;
  $1_1 = $3($3_1 | $4 | 0 | 0, $1_1 | 0) | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  $6 = $1_1;
  $5 = $3_1;
  $0_1 = $1_1;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0_1 = $3_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $3_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $6 | 0;
 }
 
 function legalfunc$wasm2js_scratch_load_i64() {
  var $0_1 = 0, $1_1 = 0, $2_1 = 0, $3_1 = 0, $4 = 0, $5 = 0, $6 = 0;
  $0_1 = 0;
  $5 = legalimport$wasm2js_scratch_load_i64() | 0;
  $6 = $0_1;
  $0_1 = 0;
  $1_1 = getTempRet0() | 0;
  $2_1 = 32;
  $3_1 = $2_1 & 31 | 0;
  if (32 >>> 0 <= ($2_1 & 63 | 0) >>> 0) {
   {
    $4 = $1_1 << $3_1 | 0;
    $2_1 = 0;
   }
  } else {
   {
    $4 = ((1 << $3_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $3_1 | 0) | 0) | 0 | ($0_1 << $3_1 | 0) | 0;
    $2_1 = $1_1 << $3_1 | 0;
   }
  }
  $1_1 = $4;
  $4 = $6;
  $0_1 = $5;
  $1_1 = $4 | $1_1 | 0;
  $0_1 = $0_1 | $2_1 | 0;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $0_1 | 0;
 }
 
 function legalfunc$wasm2js_scratch_store_i64($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0;
  $4 = $0_1;
  $3_1 = 32;
  $2_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   $0_1 = $1_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $1_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  legalimport$wasm2js_scratch_store_i64($4 | 0, $0_1 | 0);
 }
 
 function _ZN17compiler_builtins3int4sdiv3Mod4mod_17h2cbb7bbf36e41d68E($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0, $13 = 0;
  $5 = $1_1;
  $8 = $0_1;
  $7 = 63;
  $6 = $7 & 31 | 0;
  if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
   {
    $4 = $5 >> 31 | 0;
    $11 = $5 >> $6 | 0;
   }
  } else {
   {
    $4 = $5 >> $6 | 0;
    $11 = (((1 << $6 | 0) - 1 | 0) & $5 | 0) << (32 - $6 | 0) | 0 | ($8 >>> $6 | 0) | 0;
   }
  }
  $10 = $4;
  $4 = $10;
  $5 = $11;
  $8 = $1_1;
  $7 = $0_1;
  $8 = $4 ^ $8 | 0;
  $4 = $5 ^ $7 | 0;
  $5 = $10;
  $7 = $11;
  $6 = $4 - $7 | 0;
  $0_1 = $4 >>> 0 < $7 >>> 0;
  $9 = $0_1 + $5 | 0;
  $9 = $8 - $9 | 0;
  $12 = $6;
  $13 = $9;
  $9 = $3_1;
  $8 = $2_1;
  $7 = 63;
  $5 = $7 & 31 | 0;
  if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
   {
    $4 = $9 >> 31 | 0;
    $0_1 = $9 >> $5 | 0;
   }
  } else {
   {
    $4 = $9 >> $5 | 0;
    $0_1 = (((1 << $5 | 0) - 1 | 0) & $9 | 0) << (32 - $5 | 0) | 0 | ($8 >>> $5 | 0) | 0;
   }
  }
  $1_1 = $4;
  $4 = $1_1;
  $9 = $0_1;
  $8 = $3_1;
  $7 = $2_1;
  $8 = $4 ^ $8 | 0;
  $4 = $9 ^ $7 | 0;
  $9 = $1_1;
  $7 = $0_1;
  $5 = $4 - $7 | 0;
  $0_1 = $4 >>> 0 < $7 >>> 0;
  $6 = $0_1 + $9 | 0;
  $6 = $8 - $6 | 0;
  $4 = $6;
  $6 = $13;
  $4 = __wasm_i64_urem($12 | 0, $6 | 0, $5 | 0, $4 | 0) | 0;
  $6 = i64toi32_i32$HIGH_BITS;
  $8 = $4;
  $4 = $10;
  $7 = $11;
  $4 = $6 ^ $4 | 0;
  $6 = $8 ^ $7 | 0;
  $8 = $10;
  $9 = $6 - $7 | 0;
  $0_1 = $6 >>> 0 < $7 >>> 0;
  $5 = $0_1 + $8 | 0;
  $5 = $4 - $5 | 0;
  $6 = $9;
  i64toi32_i32$HIGH_BITS = $5;
  return $6 | 0;
 }
 
 function _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0, $13 = 0, $14 = 0, $15 = 0, $16 = 0, $17 = 0, $18 = 0, $19 = 0, $20 = 0;
  label$1 : {
   label$2 : {
    label$3 : {
     label$4 : {
      label$5 : {
       label$6 : {
        label$7 : {
         label$8 : {
          label$9 : {
           label$11 : {
            $7 = $1_1;
            $5 = $0_1;
            $4 = 32;
            $6 = $4 & 31 | 0;
            if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
             $10 = $7 >>> $6 | 0
            } else {
             $10 = (((1 << $6 | 0) - 1 | 0) & $7 | 0) << (32 - $6 | 0) | 0 | ($5 >>> $6 | 0) | 0
            }
            if ($10) {
             {
              $8 = $2_1;
              if (!$8) {
               break label$11
              }
              $9 = $3_1;
              $7 = $2_1;
              $4 = 32;
              $6 = $4 & 31 | 0;
              if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
               $11 = $9 >>> $6 | 0
              } else {
               $11 = (((1 << $6 | 0) - 1 | 0) & $9 | 0) << (32 - $6 | 0) | 0 | ($7 >>> $6 | 0) | 0
              }
              if (!$11) {
               break label$9
              }
              $10 = Math_clz32($11) - Math_clz32($10) | 0;
              if ($10 >>> 0 <= 31 >>> 0) {
               break label$8
              }
              break label$2;
             }
            }
            $5 = $3_1;
            $9 = $2_1;
            $7 = 1;
            $4 = 0;
            if ($5 >>> 0 > $7 >>> 0 | (($5 | 0) == ($7 | 0) & $9 >>> 0 >= $4 >>> 0 | 0) | 0) {
             break label$2
            }
            $10 = $0_1;
            $8 = $2_1;
            $10 = ($10 >>> 0) / ($8 >>> 0) | 0;
            $9 = 0;
            legalfunc$wasm2js_scratch_store_i64($0_1 - Math_imul($10, $8) | 0 | 0, $9 | 0);
            $9 = 0;
            $5 = $10;
            i64toi32_i32$HIGH_BITS = $9;
            return $5 | 0;
           }
           $5 = $3_1;
           $4 = $2_1;
           $7 = 32;
           $6 = $7 & 31 | 0;
           if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
            $8 = $5 >>> $6 | 0
           } else {
            $8 = (((1 << $6 | 0) - 1 | 0) & $5 | 0) << (32 - $6 | 0) | 0 | ($4 >>> $6 | 0) | 0
           }
           if (!$0_1) {
            break label$7
           }
           if (!$8) {
            break label$6
           }
           $11 = $8 + -1 | 0;
           if ($11 & $8 | 0) {
            break label$6
           }
           $9 = 0;
           $5 = $11 & $10 | 0;
           $7 = 32;
           $6 = $7 & 31 | 0;
           if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
            {
             $4 = $5 << $6 | 0;
             $3_1 = 0;
            }
           } else {
            {
             $4 = ((1 << $6 | 0) - 1 | 0) & ($5 >>> (32 - $6 | 0) | 0) | 0 | ($9 << $6 | 0) | 0;
             $3_1 = $5 << $6 | 0;
            }
           }
           $2_1 = $4;
           $4 = $1_1;
           $9 = $0_1;
           $5 = 0;
           $7 = -1;
           $5 = $4 & $5 | 0;
           $7 = $9 & $7 | 0;
           $9 = $5;
           $5 = $2_1;
           $4 = $3_1;
           $9 = $5 | $9 | 0;
           legalfunc$wasm2js_scratch_store_i64($4 | $7 | 0 | 0, $9 | 0);
           $9 = 0;
           $4 = $10 >>> ((__wasm_ctz_i32($8 | 0) | 0) & 31 | 0) | 0;
           i64toi32_i32$HIGH_BITS = $9;
           return $4 | 0;
          }
          $11 = $8 + -1 | 0;
          if (!($11 & $8 | 0)) {
           break label$5
          }
          $10 = (Math_clz32($8) + 33 | 0) - Math_clz32($10) | 0;
          $8 = 0 - $10 | 0;
          break label$3;
         }
         $8 = 63 - $10 | 0;
         $10 = $10 + 1 | 0;
         break label$3;
        }
        $11 = ($10 >>> 0) / ($8 >>> 0) | 0;
        $4 = 0;
        $5 = $10 - Math_imul($11, $8) | 0;
        $7 = 32;
        $6 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $9 = $5 << $6 | 0;
          $0_1 = 0;
         }
        } else {
         {
          $9 = ((1 << $6 | 0) - 1 | 0) & ($5 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
          $0_1 = $5 << $6 | 0;
         }
        }
        legalfunc$wasm2js_scratch_store_i64($0_1 | 0, $9 | 0);
        $9 = 0;
        $5 = $11;
        i64toi32_i32$HIGH_BITS = $9;
        return $5 | 0;
       }
       $10 = Math_clz32($8) - Math_clz32($10) | 0;
       if ($10 >>> 0 < 31 >>> 0) {
        break label$4
       }
       break label$2;
      }
      $5 = 0;
      legalfunc$wasm2js_scratch_store_i64($11 & $0_1 | 0 | 0, $5 | 0);
      if (($8 | 0) == (1 | 0)) {
       break label$1
      }
      $5 = 0;
      $9 = $5;
      $5 = $1_1;
      $4 = $0_1;
      $7 = __wasm_ctz_i32($8 | 0) | 0;
      $6 = $7 & 31 | 0;
      if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
       {
        $9 = 0;
        $4 = $5 >>> $6 | 0;
       }
      } else {
       {
        $9 = $5 >>> $6 | 0;
        $4 = (((1 << $6 | 0) - 1 | 0) & $5 | 0) << (32 - $6 | 0) | 0 | ($4 >>> $6 | 0) | 0;
       }
      }
      i64toi32_i32$HIGH_BITS = $9;
      return $4 | 0;
     }
     $8 = 63 - $10 | 0;
     $10 = $10 + 1 | 0;
    }
    $4 = 0;
    $9 = $4;
    $4 = $1_1;
    $5 = $0_1;
    $7 = $10 & 63 | 0;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $9 = 0;
      $13 = $4 >>> $6 | 0;
     }
    } else {
     {
      $9 = $4 >>> $6 | 0;
      $13 = (((1 << $6 | 0) - 1 | 0) & $4 | 0) << (32 - $6 | 0) | 0 | ($5 >>> $6 | 0) | 0;
     }
    }
    $11 = $9;
    $9 = 0;
    $5 = $9;
    $9 = $1_1;
    $4 = $0_1;
    $7 = $8 & 63 | 0;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $5 = $4 << $6 | 0;
      $0_1 = 0;
     }
    } else {
     {
      $5 = ((1 << $6 | 0) - 1 | 0) & ($4 >>> (32 - $6 | 0) | 0) | 0 | ($9 << $6 | 0) | 0;
      $0_1 = $4 << $6 | 0;
     }
    }
    $1_1 = $5;
    label$13 : {
     if ($10) {
      {
       $5 = $3_1;
       $9 = $2_1;
       $4 = -1;
       $7 = -1;
       $6 = $9 + $7 | 0;
       $8 = $5 + $4 | 0;
       if ($6 >>> 0 < $7 >>> 0) {
        $8 = $8 + 1 | 0
       }
       $17 = $6;
       $15 = $8;
       label$15 : while (1) {
        $8 = $11;
        $5 = $13;
        $7 = 1;
        $4 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $9 = $5 << $4 | 0;
          $12 = 0;
         }
        } else {
         {
          $9 = ((1 << $4 | 0) - 1 | 0) & ($5 >>> (32 - $4 | 0) | 0) | 0 | ($8 << $4 | 0) | 0;
          $12 = $5 << $4 | 0;
         }
        }
        $11 = $9;
        $9 = $1_1;
        $8 = $0_1;
        $7 = 63;
        $4 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = 0;
          $7 = $9 >>> $4 | 0;
         }
        } else {
         {
          $5 = $9 >>> $4 | 0;
          $7 = (((1 << $4 | 0) - 1 | 0) & $9 | 0) << (32 - $4 | 0) | 0 | ($8 >>> $4 | 0) | 0;
         }
        }
        $8 = $5;
        $5 = $11;
        $9 = $12;
        $8 = $5 | $8 | 0;
        $13 = $9 | $7 | 0;
        $11 = $8;
        $18 = $13;
        $19 = $8;
        $8 = $15;
        $5 = $17;
        $9 = $11;
        $7 = $13;
        $4 = $5 - $7 | 0;
        $5 = $5 >>> 0 < $7 >>> 0;
        $6 = $5 + $9 | 0;
        $6 = $8 - $6 | 0;
        $8 = $4;
        $7 = 63;
        $9 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = $6 >> 31 | 0;
          $14 = $6 >> $9 | 0;
         }
        } else {
         {
          $5 = $6 >> $9 | 0;
          $14 = (((1 << $9 | 0) - 1 | 0) & $6 | 0) << (32 - $9 | 0) | 0 | ($8 >>> $9 | 0) | 0;
         }
        }
        $12 = $5;
        $5 = $12;
        $6 = $14;
        $8 = $3_1;
        $7 = $2_1;
        $8 = $5 & $8 | 0;
        $7 = $6 & $7 | 0;
        $6 = $8;
        $8 = $19;
        $5 = $18;
        $9 = $5 - $7 | 0;
        $5 = $5 >>> 0 < $7 >>> 0;
        $4 = $5 + $6 | 0;
        $4 = $8 - $4 | 0;
        $13 = $9;
        $11 = $4;
        $4 = $1_1;
        $8 = $0_1;
        $7 = 1;
        $6 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = $8 << $6 | 0;
          $4 = 0;
         }
        } else {
         {
          $5 = ((1 << $6 | 0) - 1 | 0) & ($8 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
          $4 = $8 << $6 | 0;
         }
        }
        $8 = $16;
        $7 = $20;
        $8 = $5 | $8 | 0;
        $0_1 = $4 | $7 | 0;
        $1_1 = $8;
        $8 = $12;
        $5 = $14;
        $4 = 0;
        $7 = 1;
        $4 = $8 & $4 | 0;
        $14 = $5 & $7 | 0;
        $12 = $4;
        $20 = $14;
        $16 = $4;
        $10 = $10 + -1 | 0;
        if ($10) {
         continue label$15
        }
        break label$15;
       };
       break label$13;
      }
     }
    }
    $4 = $11;
    legalfunc$wasm2js_scratch_store_i64($13 | 0, $4 | 0);
    $4 = $1_1;
    $8 = $0_1;
    $7 = 1;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $5 = $8 << $6 | 0;
      $4 = 0;
     }
    } else {
     {
      $5 = ((1 << $6 | 0) - 1 | 0) & ($8 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
      $4 = $8 << $6 | 0;
     }
    }
    $8 = $12;
    $7 = $14;
    $8 = $5 | $8 | 0;
    $4 = $4 | $7 | 0;
    i64toi32_i32$HIGH_BITS = $8;
    return $4 | 0;
   }
   $4 = $1_1;
   legalfunc$wasm2js_scratch_store_i64($0_1 | 0, $4 | 0);
   $4 = 0;
   $0_1 = 0;
   $1_1 = $4;
  }
  $4 = $1_1;
  $8 = $0_1;
  i64toi32_i32$HIGH_BITS = $4;
  return $8 | 0;
 }
 
 function __wasm_i64_srem($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  $3_1 = _ZN17compiler_builtins3int4sdiv3Mod4mod_17h2cbb7bbf36e41d68E($0_1 | 0, $1_1 | 0, $2_1 | 0, $3_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $3_1 | 0;
 }
 
 function __wasm_i64_urem($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  $3_1 = _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0_1 | 0, $1_1 | 0, $2_1 | 0, $3_1 | 0) | 0;
  $1_1 = legalfunc$wasm2js_scratch_load_i64() | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $3_1;
  return $1_1 | 0;
 }
 
 function __wasm_ctz_i32($0_1) {
  $0_1 = $0_1 | 0;
  if ($0_1) {
   return 31 - Math_clz32(($0_1 + -1 | 0) ^ $0_1 | 0) | 0 | 0
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
 var getTempRet0 = env.getTempRet0;
 var i64toi32_i32$HIGH_BITS = 0;
 function $0($0_1) {
  $0_1 = $0_1 | 0;
  return ($0_1 | 0) % (5 | 0) | 0 | 0;
 }
 
 function $1($0_1) {
  $0_1 = $0_1 | 0;
  return ($0_1 >>> 0) % (5 >>> 0) | 0 | 0;
 }
 
 function $2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0;
  $2_1 = 0;
  $2_1 = __wasm_i64_srem($0_1 | 0, $1_1 | 0, 5 | 0, $2_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $2_1 | 0;
 }
 
 function $3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0;
  $2_1 = 0;
  $2_1 = __wasm_i64_urem($0_1 | 0, $1_1 | 0, 5 | 0, $2_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $2_1 | 0;
 }
 
 function legalstub$2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0, $5 = 0, $6 = 0;
  $3_1 = 0;
  $5 = $0_1;
  $6 = $3_1;
  $3_1 = 0;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0_1 = $1_1 << $2_1 | 0;
    $4 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $2_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $2_1 | 0) | 0) | 0 | ($3_1 << $2_1 | 0) | 0;
    $4 = $1_1 << $2_1 | 0;
   }
  }
  $1_1 = $0_1;
  $0_1 = $6;
  $3_1 = $5;
  $1_1 = $0_1 | $1_1 | 0;
  $1_1 = $2($3_1 | $4 | 0 | 0, $1_1 | 0) | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  $6 = $1_1;
  $5 = $3_1;
  $0_1 = $1_1;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0_1 = $3_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $3_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $6 | 0;
 }
 
 function legalstub$3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0, $5 = 0, $6 = 0;
  $3_1 = 0;
  $5 = $0_1;
  $6 = $3_1;
  $3_1 = 0;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0_1 = $1_1 << $2_1 | 0;
    $4 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $2_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $2_1 | 0) | 0) | 0 | ($3_1 << $2_1 | 0) | 0;
    $4 = $1_1 << $2_1 | 0;
   }
  }
  $1_1 = $0_1;
  $0_1 = $6;
  $3_1 = $5;
  $1_1 = $0_1 | $1_1 | 0;
  $1_1 = $3($3_1 | $4 | 0 | 0, $1_1 | 0) | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  $6 = $1_1;
  $5 = $3_1;
  $0_1 = $1_1;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0_1 = $3_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $3_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $6 | 0;
 }
 
 function legalfunc$wasm2js_scratch_load_i64() {
  var $0_1 = 0, $1_1 = 0, $2_1 = 0, $3_1 = 0, $4 = 0, $5 = 0, $6 = 0;
  $0_1 = 0;
  $5 = legalimport$wasm2js_scratch_load_i64() | 0;
  $6 = $0_1;
  $0_1 = 0;
  $1_1 = getTempRet0() | 0;
  $2_1 = 32;
  $3_1 = $2_1 & 31 | 0;
  if (32 >>> 0 <= ($2_1 & 63 | 0) >>> 0) {
   {
    $4 = $1_1 << $3_1 | 0;
    $2_1 = 0;
   }
  } else {
   {
    $4 = ((1 << $3_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $3_1 | 0) | 0) | 0 | ($0_1 << $3_1 | 0) | 0;
    $2_1 = $1_1 << $3_1 | 0;
   }
  }
  $1_1 = $4;
  $4 = $6;
  $0_1 = $5;
  $1_1 = $4 | $1_1 | 0;
  $0_1 = $0_1 | $2_1 | 0;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $0_1 | 0;
 }
 
 function legalfunc$wasm2js_scratch_store_i64($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0;
  $4 = $0_1;
  $3_1 = 32;
  $2_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   $0_1 = $1_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $1_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  legalimport$wasm2js_scratch_store_i64($4 | 0, $0_1 | 0);
 }
 
 function _ZN17compiler_builtins3int4sdiv3Mod4mod_17h2cbb7bbf36e41d68E($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0, $13 = 0;
  $5 = $1_1;
  $8 = $0_1;
  $7 = 63;
  $6 = $7 & 31 | 0;
  if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
   {
    $4 = $5 >> 31 | 0;
    $11 = $5 >> $6 | 0;
   }
  } else {
   {
    $4 = $5 >> $6 | 0;
    $11 = (((1 << $6 | 0) - 1 | 0) & $5 | 0) << (32 - $6 | 0) | 0 | ($8 >>> $6 | 0) | 0;
   }
  }
  $10 = $4;
  $4 = $10;
  $5 = $11;
  $8 = $1_1;
  $7 = $0_1;
  $8 = $4 ^ $8 | 0;
  $4 = $5 ^ $7 | 0;
  $5 = $10;
  $7 = $11;
  $6 = $4 - $7 | 0;
  $0_1 = $4 >>> 0 < $7 >>> 0;
  $9 = $0_1 + $5 | 0;
  $9 = $8 - $9 | 0;
  $12 = $6;
  $13 = $9;
  $9 = $3_1;
  $8 = $2_1;
  $7 = 63;
  $5 = $7 & 31 | 0;
  if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
   {
    $4 = $9 >> 31 | 0;
    $0_1 = $9 >> $5 | 0;
   }
  } else {
   {
    $4 = $9 >> $5 | 0;
    $0_1 = (((1 << $5 | 0) - 1 | 0) & $9 | 0) << (32 - $5 | 0) | 0 | ($8 >>> $5 | 0) | 0;
   }
  }
  $1_1 = $4;
  $4 = $1_1;
  $9 = $0_1;
  $8 = $3_1;
  $7 = $2_1;
  $8 = $4 ^ $8 | 0;
  $4 = $9 ^ $7 | 0;
  $9 = $1_1;
  $7 = $0_1;
  $5 = $4 - $7 | 0;
  $0_1 = $4 >>> 0 < $7 >>> 0;
  $6 = $0_1 + $9 | 0;
  $6 = $8 - $6 | 0;
  $4 = $6;
  $6 = $13;
  $4 = __wasm_i64_urem($12 | 0, $6 | 0, $5 | 0, $4 | 0) | 0;
  $6 = i64toi32_i32$HIGH_BITS;
  $8 = $4;
  $4 = $10;
  $7 = $11;
  $4 = $6 ^ $4 | 0;
  $6 = $8 ^ $7 | 0;
  $8 = $10;
  $9 = $6 - $7 | 0;
  $0_1 = $6 >>> 0 < $7 >>> 0;
  $5 = $0_1 + $8 | 0;
  $5 = $4 - $5 | 0;
  $6 = $9;
  i64toi32_i32$HIGH_BITS = $5;
  return $6 | 0;
 }
 
 function _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0, $13 = 0, $14 = 0, $15 = 0, $16 = 0, $17 = 0, $18 = 0, $19 = 0, $20 = 0;
  label$1 : {
   label$2 : {
    label$3 : {
     label$4 : {
      label$5 : {
       label$6 : {
        label$7 : {
         label$8 : {
          label$9 : {
           label$11 : {
            $7 = $1_1;
            $5 = $0_1;
            $4 = 32;
            $6 = $4 & 31 | 0;
            if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
             $10 = $7 >>> $6 | 0
            } else {
             $10 = (((1 << $6 | 0) - 1 | 0) & $7 | 0) << (32 - $6 | 0) | 0 | ($5 >>> $6 | 0) | 0
            }
            if ($10) {
             {
              $8 = $2_1;
              if (!$8) {
               break label$11
              }
              $9 = $3_1;
              $7 = $2_1;
              $4 = 32;
              $6 = $4 & 31 | 0;
              if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
               $11 = $9 >>> $6 | 0
              } else {
               $11 = (((1 << $6 | 0) - 1 | 0) & $9 | 0) << (32 - $6 | 0) | 0 | ($7 >>> $6 | 0) | 0
              }
              if (!$11) {
               break label$9
              }
              $10 = Math_clz32($11) - Math_clz32($10) | 0;
              if ($10 >>> 0 <= 31 >>> 0) {
               break label$8
              }
              break label$2;
             }
            }
            $5 = $3_1;
            $9 = $2_1;
            $7 = 1;
            $4 = 0;
            if ($5 >>> 0 > $7 >>> 0 | (($5 | 0) == ($7 | 0) & $9 >>> 0 >= $4 >>> 0 | 0) | 0) {
             break label$2
            }
            $10 = $0_1;
            $8 = $2_1;
            $10 = ($10 >>> 0) / ($8 >>> 0) | 0;
            $9 = 0;
            legalfunc$wasm2js_scratch_store_i64($0_1 - Math_imul($10, $8) | 0 | 0, $9 | 0);
            $9 = 0;
            $5 = $10;
            i64toi32_i32$HIGH_BITS = $9;
            return $5 | 0;
           }
           $5 = $3_1;
           $4 = $2_1;
           $7 = 32;
           $6 = $7 & 31 | 0;
           if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
            $8 = $5 >>> $6 | 0
           } else {
            $8 = (((1 << $6 | 0) - 1 | 0) & $5 | 0) << (32 - $6 | 0) | 0 | ($4 >>> $6 | 0) | 0
           }
           if (!$0_1) {
            break label$7
           }
           if (!$8) {
            break label$6
           }
           $11 = $8 + -1 | 0;
           if ($11 & $8 | 0) {
            break label$6
           }
           $9 = 0;
           $5 = $11 & $10 | 0;
           $7 = 32;
           $6 = $7 & 31 | 0;
           if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
            {
             $4 = $5 << $6 | 0;
             $3_1 = 0;
            }
           } else {
            {
             $4 = ((1 << $6 | 0) - 1 | 0) & ($5 >>> (32 - $6 | 0) | 0) | 0 | ($9 << $6 | 0) | 0;
             $3_1 = $5 << $6 | 0;
            }
           }
           $2_1 = $4;
           $4 = $1_1;
           $9 = $0_1;
           $5 = 0;
           $7 = -1;
           $5 = $4 & $5 | 0;
           $7 = $9 & $7 | 0;
           $9 = $5;
           $5 = $2_1;
           $4 = $3_1;
           $9 = $5 | $9 | 0;
           legalfunc$wasm2js_scratch_store_i64($4 | $7 | 0 | 0, $9 | 0);
           $9 = 0;
           $4 = $10 >>> ((__wasm_ctz_i32($8 | 0) | 0) & 31 | 0) | 0;
           i64toi32_i32$HIGH_BITS = $9;
           return $4 | 0;
          }
          $11 = $8 + -1 | 0;
          if (!($11 & $8 | 0)) {
           break label$5
          }
          $10 = (Math_clz32($8) + 33 | 0) - Math_clz32($10) | 0;
          $8 = 0 - $10 | 0;
          break label$3;
         }
         $8 = 63 - $10 | 0;
         $10 = $10 + 1 | 0;
         break label$3;
        }
        $11 = ($10 >>> 0) / ($8 >>> 0) | 0;
        $4 = 0;
        $5 = $10 - Math_imul($11, $8) | 0;
        $7 = 32;
        $6 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $9 = $5 << $6 | 0;
          $0_1 = 0;
         }
        } else {
         {
          $9 = ((1 << $6 | 0) - 1 | 0) & ($5 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
          $0_1 = $5 << $6 | 0;
         }
        }
        legalfunc$wasm2js_scratch_store_i64($0_1 | 0, $9 | 0);
        $9 = 0;
        $5 = $11;
        i64toi32_i32$HIGH_BITS = $9;
        return $5 | 0;
       }
       $10 = Math_clz32($8) - Math_clz32($10) | 0;
       if ($10 >>> 0 < 31 >>> 0) {
        break label$4
       }
       break label$2;
      }
      $5 = 0;
      legalfunc$wasm2js_scratch_store_i64($11 & $0_1 | 0 | 0, $5 | 0);
      if (($8 | 0) == (1 | 0)) {
       break label$1
      }
      $5 = 0;
      $9 = $5;
      $5 = $1_1;
      $4 = $0_1;
      $7 = __wasm_ctz_i32($8 | 0) | 0;
      $6 = $7 & 31 | 0;
      if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
       {
        $9 = 0;
        $4 = $5 >>> $6 | 0;
       }
      } else {
       {
        $9 = $5 >>> $6 | 0;
        $4 = (((1 << $6 | 0) - 1 | 0) & $5 | 0) << (32 - $6 | 0) | 0 | ($4 >>> $6 | 0) | 0;
       }
      }
      i64toi32_i32$HIGH_BITS = $9;
      return $4 | 0;
     }
     $8 = 63 - $10 | 0;
     $10 = $10 + 1 | 0;
    }
    $4 = 0;
    $9 = $4;
    $4 = $1_1;
    $5 = $0_1;
    $7 = $10 & 63 | 0;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $9 = 0;
      $13 = $4 >>> $6 | 0;
     }
    } else {
     {
      $9 = $4 >>> $6 | 0;
      $13 = (((1 << $6 | 0) - 1 | 0) & $4 | 0) << (32 - $6 | 0) | 0 | ($5 >>> $6 | 0) | 0;
     }
    }
    $11 = $9;
    $9 = 0;
    $5 = $9;
    $9 = $1_1;
    $4 = $0_1;
    $7 = $8 & 63 | 0;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $5 = $4 << $6 | 0;
      $0_1 = 0;
     }
    } else {
     {
      $5 = ((1 << $6 | 0) - 1 | 0) & ($4 >>> (32 - $6 | 0) | 0) | 0 | ($9 << $6 | 0) | 0;
      $0_1 = $4 << $6 | 0;
     }
    }
    $1_1 = $5;
    label$13 : {
     if ($10) {
      {
       $5 = $3_1;
       $9 = $2_1;
       $4 = -1;
       $7 = -1;
       $6 = $9 + $7 | 0;
       $8 = $5 + $4 | 0;
       if ($6 >>> 0 < $7 >>> 0) {
        $8 = $8 + 1 | 0
       }
       $17 = $6;
       $15 = $8;
       label$15 : while (1) {
        $8 = $11;
        $5 = $13;
        $7 = 1;
        $4 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $9 = $5 << $4 | 0;
          $12 = 0;
         }
        } else {
         {
          $9 = ((1 << $4 | 0) - 1 | 0) & ($5 >>> (32 - $4 | 0) | 0) | 0 | ($8 << $4 | 0) | 0;
          $12 = $5 << $4 | 0;
         }
        }
        $11 = $9;
        $9 = $1_1;
        $8 = $0_1;
        $7 = 63;
        $4 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = 0;
          $7 = $9 >>> $4 | 0;
         }
        } else {
         {
          $5 = $9 >>> $4 | 0;
          $7 = (((1 << $4 | 0) - 1 | 0) & $9 | 0) << (32 - $4 | 0) | 0 | ($8 >>> $4 | 0) | 0;
         }
        }
        $8 = $5;
        $5 = $11;
        $9 = $12;
        $8 = $5 | $8 | 0;
        $13 = $9 | $7 | 0;
        $11 = $8;
        $18 = $13;
        $19 = $8;
        $8 = $15;
        $5 = $17;
        $9 = $11;
        $7 = $13;
        $4 = $5 - $7 | 0;
        $5 = $5 >>> 0 < $7 >>> 0;
        $6 = $5 + $9 | 0;
        $6 = $8 - $6 | 0;
        $8 = $4;
        $7 = 63;
        $9 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = $6 >> 31 | 0;
          $14 = $6 >> $9 | 0;
         }
        } else {
         {
          $5 = $6 >> $9 | 0;
          $14 = (((1 << $9 | 0) - 1 | 0) & $6 | 0) << (32 - $9 | 0) | 0 | ($8 >>> $9 | 0) | 0;
         }
        }
        $12 = $5;
        $5 = $12;
        $6 = $14;
        $8 = $3_1;
        $7 = $2_1;
        $8 = $5 & $8 | 0;
        $7 = $6 & $7 | 0;
        $6 = $8;
        $8 = $19;
        $5 = $18;
        $9 = $5 - $7 | 0;
        $5 = $5 >>> 0 < $7 >>> 0;
        $4 = $5 + $6 | 0;
        $4 = $8 - $4 | 0;
        $13 = $9;
        $11 = $4;
        $4 = $1_1;
        $8 = $0_1;
        $7 = 1;
        $6 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = $8 << $6 | 0;
          $4 = 0;
         }
        } else {
         {
          $5 = ((1 << $6 | 0) - 1 | 0) & ($8 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
          $4 = $8 << $6 | 0;
         }
        }
        $8 = $16;
        $7 = $20;
        $8 = $5 | $8 | 0;
        $0_1 = $4 | $7 | 0;
        $1_1 = $8;
        $8 = $12;
        $5 = $14;
        $4 = 0;
        $7 = 1;
        $4 = $8 & $4 | 0;
        $14 = $5 & $7 | 0;
        $12 = $4;
        $20 = $14;
        $16 = $4;
        $10 = $10 + -1 | 0;
        if ($10) {
         continue label$15
        }
        break label$15;
       };
       break label$13;
      }
     }
    }
    $4 = $11;
    legalfunc$wasm2js_scratch_store_i64($13 | 0, $4 | 0);
    $4 = $1_1;
    $8 = $0_1;
    $7 = 1;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $5 = $8 << $6 | 0;
      $4 = 0;
     }
    } else {
     {
      $5 = ((1 << $6 | 0) - 1 | 0) & ($8 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
      $4 = $8 << $6 | 0;
     }
    }
    $8 = $12;
    $7 = $14;
    $8 = $5 | $8 | 0;
    $4 = $4 | $7 | 0;
    i64toi32_i32$HIGH_BITS = $8;
    return $4 | 0;
   }
   $4 = $1_1;
   legalfunc$wasm2js_scratch_store_i64($0_1 | 0, $4 | 0);
   $4 = 0;
   $0_1 = 0;
   $1_1 = $4;
  }
  $4 = $1_1;
  $8 = $0_1;
  i64toi32_i32$HIGH_BITS = $4;
  return $8 | 0;
 }
 
 function __wasm_i64_srem($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  $3_1 = _ZN17compiler_builtins3int4sdiv3Mod4mod_17h2cbb7bbf36e41d68E($0_1 | 0, $1_1 | 0, $2_1 | 0, $3_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $3_1 | 0;
 }
 
 function __wasm_i64_urem($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  $3_1 = _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0_1 | 0, $1_1 | 0, $2_1 | 0, $3_1 | 0) | 0;
  $1_1 = legalfunc$wasm2js_scratch_load_i64() | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $3_1;
  return $1_1 | 0;
 }
 
 function __wasm_ctz_i32($0_1) {
  $0_1 = $0_1 | 0;
  if ($0_1) {
   return 31 - Math_clz32(($0_1 + -1 | 0) ^ $0_1 | 0) | 0 | 0
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
 var getTempRet0 = env.getTempRet0;
 var i64toi32_i32$HIGH_BITS = 0;
 function $0($0_1) {
  $0_1 = $0_1 | 0;
  return ($0_1 | 0) % (7 | 0) | 0 | 0;
 }
 
 function $1($0_1) {
  $0_1 = $0_1 | 0;
  return ($0_1 >>> 0) % (7 >>> 0) | 0 | 0;
 }
 
 function $2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0;
  $2_1 = 0;
  $2_1 = __wasm_i64_srem($0_1 | 0, $1_1 | 0, 7 | 0, $2_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $2_1 | 0;
 }
 
 function $3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0;
  $2_1 = 0;
  $2_1 = __wasm_i64_urem($0_1 | 0, $1_1 | 0, 7 | 0, $2_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $2_1 | 0;
 }
 
 function legalstub$2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0, $5 = 0, $6 = 0;
  $3_1 = 0;
  $5 = $0_1;
  $6 = $3_1;
  $3_1 = 0;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0_1 = $1_1 << $2_1 | 0;
    $4 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $2_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $2_1 | 0) | 0) | 0 | ($3_1 << $2_1 | 0) | 0;
    $4 = $1_1 << $2_1 | 0;
   }
  }
  $1_1 = $0_1;
  $0_1 = $6;
  $3_1 = $5;
  $1_1 = $0_1 | $1_1 | 0;
  $1_1 = $2($3_1 | $4 | 0 | 0, $1_1 | 0) | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  $6 = $1_1;
  $5 = $3_1;
  $0_1 = $1_1;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0_1 = $3_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $3_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $6 | 0;
 }
 
 function legalstub$3($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0, $5 = 0, $6 = 0;
  $3_1 = 0;
  $5 = $0_1;
  $6 = $3_1;
  $3_1 = 0;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0_1 = $1_1 << $2_1 | 0;
    $4 = 0;
   }
  } else {
   {
    $0_1 = ((1 << $2_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $2_1 | 0) | 0) | 0 | ($3_1 << $2_1 | 0) | 0;
    $4 = $1_1 << $2_1 | 0;
   }
  }
  $1_1 = $0_1;
  $0_1 = $6;
  $3_1 = $5;
  $1_1 = $0_1 | $1_1 | 0;
  $1_1 = $3($3_1 | $4 | 0 | 0, $1_1 | 0) | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  $6 = $1_1;
  $5 = $3_1;
  $0_1 = $1_1;
  $4 = 32;
  $2_1 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0_1 = $3_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $3_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $6 | 0;
 }
 
 function legalfunc$wasm2js_scratch_load_i64() {
  var $0_1 = 0, $1_1 = 0, $2_1 = 0, $3_1 = 0, $4 = 0, $5 = 0, $6 = 0;
  $0_1 = 0;
  $5 = legalimport$wasm2js_scratch_load_i64() | 0;
  $6 = $0_1;
  $0_1 = 0;
  $1_1 = getTempRet0() | 0;
  $2_1 = 32;
  $3_1 = $2_1 & 31 | 0;
  if (32 >>> 0 <= ($2_1 & 63 | 0) >>> 0) {
   {
    $4 = $1_1 << $3_1 | 0;
    $2_1 = 0;
   }
  } else {
   {
    $4 = ((1 << $3_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $3_1 | 0) | 0) | 0 | ($0_1 << $3_1 | 0) | 0;
    $2_1 = $1_1 << $3_1 | 0;
   }
  }
  $1_1 = $4;
  $4 = $6;
  $0_1 = $5;
  $1_1 = $4 | $1_1 | 0;
  $0_1 = $0_1 | $2_1 | 0;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $0_1 | 0;
 }
 
 function legalfunc$wasm2js_scratch_store_i64($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4 = 0;
  $4 = $0_1;
  $3_1 = 32;
  $2_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   $0_1 = $1_1 >>> $2_1 | 0
  } else {
   $0_1 = (((1 << $2_1 | 0) - 1 | 0) & $1_1 | 0) << (32 - $2_1 | 0) | 0 | ($0_1 >>> $2_1 | 0) | 0
  }
  legalimport$wasm2js_scratch_store_i64($4 | 0, $0_1 | 0);
 }
 
 function _ZN17compiler_builtins3int4sdiv3Mod4mod_17h2cbb7bbf36e41d68E($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0, $13 = 0;
  $5 = $1_1;
  $8 = $0_1;
  $7 = 63;
  $6 = $7 & 31 | 0;
  if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
   {
    $4 = $5 >> 31 | 0;
    $11 = $5 >> $6 | 0;
   }
  } else {
   {
    $4 = $5 >> $6 | 0;
    $11 = (((1 << $6 | 0) - 1 | 0) & $5 | 0) << (32 - $6 | 0) | 0 | ($8 >>> $6 | 0) | 0;
   }
  }
  $10 = $4;
  $4 = $10;
  $5 = $11;
  $8 = $1_1;
  $7 = $0_1;
  $8 = $4 ^ $8 | 0;
  $4 = $5 ^ $7 | 0;
  $5 = $10;
  $7 = $11;
  $6 = $4 - $7 | 0;
  $0_1 = $4 >>> 0 < $7 >>> 0;
  $9 = $0_1 + $5 | 0;
  $9 = $8 - $9 | 0;
  $12 = $6;
  $13 = $9;
  $9 = $3_1;
  $8 = $2_1;
  $7 = 63;
  $5 = $7 & 31 | 0;
  if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
   {
    $4 = $9 >> 31 | 0;
    $0_1 = $9 >> $5 | 0;
   }
  } else {
   {
    $4 = $9 >> $5 | 0;
    $0_1 = (((1 << $5 | 0) - 1 | 0) & $9 | 0) << (32 - $5 | 0) | 0 | ($8 >>> $5 | 0) | 0;
   }
  }
  $1_1 = $4;
  $4 = $1_1;
  $9 = $0_1;
  $8 = $3_1;
  $7 = $2_1;
  $8 = $4 ^ $8 | 0;
  $4 = $9 ^ $7 | 0;
  $9 = $1_1;
  $7 = $0_1;
  $5 = $4 - $7 | 0;
  $0_1 = $4 >>> 0 < $7 >>> 0;
  $6 = $0_1 + $9 | 0;
  $6 = $8 - $6 | 0;
  $4 = $6;
  $6 = $13;
  $4 = __wasm_i64_urem($12 | 0, $6 | 0, $5 | 0, $4 | 0) | 0;
  $6 = i64toi32_i32$HIGH_BITS;
  $8 = $4;
  $4 = $10;
  $7 = $11;
  $4 = $6 ^ $4 | 0;
  $6 = $8 ^ $7 | 0;
  $8 = $10;
  $9 = $6 - $7 | 0;
  $0_1 = $6 >>> 0 < $7 >>> 0;
  $5 = $0_1 + $8 | 0;
  $5 = $4 - $5 | 0;
  $6 = $9;
  i64toi32_i32$HIGH_BITS = $5;
  return $6 | 0;
 }
 
 function _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0, $13 = 0, $14 = 0, $15 = 0, $16 = 0, $17 = 0, $18 = 0, $19 = 0, $20 = 0;
  label$1 : {
   label$2 : {
    label$3 : {
     label$4 : {
      label$5 : {
       label$6 : {
        label$7 : {
         label$8 : {
          label$9 : {
           label$11 : {
            $7 = $1_1;
            $5 = $0_1;
            $4 = 32;
            $6 = $4 & 31 | 0;
            if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
             $10 = $7 >>> $6 | 0
            } else {
             $10 = (((1 << $6 | 0) - 1 | 0) & $7 | 0) << (32 - $6 | 0) | 0 | ($5 >>> $6 | 0) | 0
            }
            if ($10) {
             {
              $8 = $2_1;
              if (!$8) {
               break label$11
              }
              $9 = $3_1;
              $7 = $2_1;
              $4 = 32;
              $6 = $4 & 31 | 0;
              if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
               $11 = $9 >>> $6 | 0
              } else {
               $11 = (((1 << $6 | 0) - 1 | 0) & $9 | 0) << (32 - $6 | 0) | 0 | ($7 >>> $6 | 0) | 0
              }
              if (!$11) {
               break label$9
              }
              $10 = Math_clz32($11) - Math_clz32($10) | 0;
              if ($10 >>> 0 <= 31 >>> 0) {
               break label$8
              }
              break label$2;
             }
            }
            $5 = $3_1;
            $9 = $2_1;
            $7 = 1;
            $4 = 0;
            if ($5 >>> 0 > $7 >>> 0 | (($5 | 0) == ($7 | 0) & $9 >>> 0 >= $4 >>> 0 | 0) | 0) {
             break label$2
            }
            $10 = $0_1;
            $8 = $2_1;
            $10 = ($10 >>> 0) / ($8 >>> 0) | 0;
            $9 = 0;
            legalfunc$wasm2js_scratch_store_i64($0_1 - Math_imul($10, $8) | 0 | 0, $9 | 0);
            $9 = 0;
            $5 = $10;
            i64toi32_i32$HIGH_BITS = $9;
            return $5 | 0;
           }
           $5 = $3_1;
           $4 = $2_1;
           $7 = 32;
           $6 = $7 & 31 | 0;
           if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
            $8 = $5 >>> $6 | 0
           } else {
            $8 = (((1 << $6 | 0) - 1 | 0) & $5 | 0) << (32 - $6 | 0) | 0 | ($4 >>> $6 | 0) | 0
           }
           if (!$0_1) {
            break label$7
           }
           if (!$8) {
            break label$6
           }
           $11 = $8 + -1 | 0;
           if ($11 & $8 | 0) {
            break label$6
           }
           $9 = 0;
           $5 = $11 & $10 | 0;
           $7 = 32;
           $6 = $7 & 31 | 0;
           if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
            {
             $4 = $5 << $6 | 0;
             $3_1 = 0;
            }
           } else {
            {
             $4 = ((1 << $6 | 0) - 1 | 0) & ($5 >>> (32 - $6 | 0) | 0) | 0 | ($9 << $6 | 0) | 0;
             $3_1 = $5 << $6 | 0;
            }
           }
           $2_1 = $4;
           $4 = $1_1;
           $9 = $0_1;
           $5 = 0;
           $7 = -1;
           $5 = $4 & $5 | 0;
           $7 = $9 & $7 | 0;
           $9 = $5;
           $5 = $2_1;
           $4 = $3_1;
           $9 = $5 | $9 | 0;
           legalfunc$wasm2js_scratch_store_i64($4 | $7 | 0 | 0, $9 | 0);
           $9 = 0;
           $4 = $10 >>> ((__wasm_ctz_i32($8 | 0) | 0) & 31 | 0) | 0;
           i64toi32_i32$HIGH_BITS = $9;
           return $4 | 0;
          }
          $11 = $8 + -1 | 0;
          if (!($11 & $8 | 0)) {
           break label$5
          }
          $10 = (Math_clz32($8) + 33 | 0) - Math_clz32($10) | 0;
          $8 = 0 - $10 | 0;
          break label$3;
         }
         $8 = 63 - $10 | 0;
         $10 = $10 + 1 | 0;
         break label$3;
        }
        $11 = ($10 >>> 0) / ($8 >>> 0) | 0;
        $4 = 0;
        $5 = $10 - Math_imul($11, $8) | 0;
        $7 = 32;
        $6 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $9 = $5 << $6 | 0;
          $0_1 = 0;
         }
        } else {
         {
          $9 = ((1 << $6 | 0) - 1 | 0) & ($5 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
          $0_1 = $5 << $6 | 0;
         }
        }
        legalfunc$wasm2js_scratch_store_i64($0_1 | 0, $9 | 0);
        $9 = 0;
        $5 = $11;
        i64toi32_i32$HIGH_BITS = $9;
        return $5 | 0;
       }
       $10 = Math_clz32($8) - Math_clz32($10) | 0;
       if ($10 >>> 0 < 31 >>> 0) {
        break label$4
       }
       break label$2;
      }
      $5 = 0;
      legalfunc$wasm2js_scratch_store_i64($11 & $0_1 | 0 | 0, $5 | 0);
      if (($8 | 0) == (1 | 0)) {
       break label$1
      }
      $5 = 0;
      $9 = $5;
      $5 = $1_1;
      $4 = $0_1;
      $7 = __wasm_ctz_i32($8 | 0) | 0;
      $6 = $7 & 31 | 0;
      if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
       {
        $9 = 0;
        $4 = $5 >>> $6 | 0;
       }
      } else {
       {
        $9 = $5 >>> $6 | 0;
        $4 = (((1 << $6 | 0) - 1 | 0) & $5 | 0) << (32 - $6 | 0) | 0 | ($4 >>> $6 | 0) | 0;
       }
      }
      i64toi32_i32$HIGH_BITS = $9;
      return $4 | 0;
     }
     $8 = 63 - $10 | 0;
     $10 = $10 + 1 | 0;
    }
    $4 = 0;
    $9 = $4;
    $4 = $1_1;
    $5 = $0_1;
    $7 = $10 & 63 | 0;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $9 = 0;
      $13 = $4 >>> $6 | 0;
     }
    } else {
     {
      $9 = $4 >>> $6 | 0;
      $13 = (((1 << $6 | 0) - 1 | 0) & $4 | 0) << (32 - $6 | 0) | 0 | ($5 >>> $6 | 0) | 0;
     }
    }
    $11 = $9;
    $9 = 0;
    $5 = $9;
    $9 = $1_1;
    $4 = $0_1;
    $7 = $8 & 63 | 0;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $5 = $4 << $6 | 0;
      $0_1 = 0;
     }
    } else {
     {
      $5 = ((1 << $6 | 0) - 1 | 0) & ($4 >>> (32 - $6 | 0) | 0) | 0 | ($9 << $6 | 0) | 0;
      $0_1 = $4 << $6 | 0;
     }
    }
    $1_1 = $5;
    label$13 : {
     if ($10) {
      {
       $5 = $3_1;
       $9 = $2_1;
       $4 = -1;
       $7 = -1;
       $6 = $9 + $7 | 0;
       $8 = $5 + $4 | 0;
       if ($6 >>> 0 < $7 >>> 0) {
        $8 = $8 + 1 | 0
       }
       $17 = $6;
       $15 = $8;
       label$15 : while (1) {
        $8 = $11;
        $5 = $13;
        $7 = 1;
        $4 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $9 = $5 << $4 | 0;
          $12 = 0;
         }
        } else {
         {
          $9 = ((1 << $4 | 0) - 1 | 0) & ($5 >>> (32 - $4 | 0) | 0) | 0 | ($8 << $4 | 0) | 0;
          $12 = $5 << $4 | 0;
         }
        }
        $11 = $9;
        $9 = $1_1;
        $8 = $0_1;
        $7 = 63;
        $4 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = 0;
          $7 = $9 >>> $4 | 0;
         }
        } else {
         {
          $5 = $9 >>> $4 | 0;
          $7 = (((1 << $4 | 0) - 1 | 0) & $9 | 0) << (32 - $4 | 0) | 0 | ($8 >>> $4 | 0) | 0;
         }
        }
        $8 = $5;
        $5 = $11;
        $9 = $12;
        $8 = $5 | $8 | 0;
        $13 = $9 | $7 | 0;
        $11 = $8;
        $18 = $13;
        $19 = $8;
        $8 = $15;
        $5 = $17;
        $9 = $11;
        $7 = $13;
        $4 = $5 - $7 | 0;
        $5 = $5 >>> 0 < $7 >>> 0;
        $6 = $5 + $9 | 0;
        $6 = $8 - $6 | 0;
        $8 = $4;
        $7 = 63;
        $9 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = $6 >> 31 | 0;
          $14 = $6 >> $9 | 0;
         }
        } else {
         {
          $5 = $6 >> $9 | 0;
          $14 = (((1 << $9 | 0) - 1 | 0) & $6 | 0) << (32 - $9 | 0) | 0 | ($8 >>> $9 | 0) | 0;
         }
        }
        $12 = $5;
        $5 = $12;
        $6 = $14;
        $8 = $3_1;
        $7 = $2_1;
        $8 = $5 & $8 | 0;
        $7 = $6 & $7 | 0;
        $6 = $8;
        $8 = $19;
        $5 = $18;
        $9 = $5 - $7 | 0;
        $5 = $5 >>> 0 < $7 >>> 0;
        $4 = $5 + $6 | 0;
        $4 = $8 - $4 | 0;
        $13 = $9;
        $11 = $4;
        $4 = $1_1;
        $8 = $0_1;
        $7 = 1;
        $6 = $7 & 31 | 0;
        if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
         {
          $5 = $8 << $6 | 0;
          $4 = 0;
         }
        } else {
         {
          $5 = ((1 << $6 | 0) - 1 | 0) & ($8 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
          $4 = $8 << $6 | 0;
         }
        }
        $8 = $16;
        $7 = $20;
        $8 = $5 | $8 | 0;
        $0_1 = $4 | $7 | 0;
        $1_1 = $8;
        $8 = $12;
        $5 = $14;
        $4 = 0;
        $7 = 1;
        $4 = $8 & $4 | 0;
        $14 = $5 & $7 | 0;
        $12 = $4;
        $20 = $14;
        $16 = $4;
        $10 = $10 + -1 | 0;
        if ($10) {
         continue label$15
        }
        break label$15;
       };
       break label$13;
      }
     }
    }
    $4 = $11;
    legalfunc$wasm2js_scratch_store_i64($13 | 0, $4 | 0);
    $4 = $1_1;
    $8 = $0_1;
    $7 = 1;
    $6 = $7 & 31 | 0;
    if (32 >>> 0 <= ($7 & 63 | 0) >>> 0) {
     {
      $5 = $8 << $6 | 0;
      $4 = 0;
     }
    } else {
     {
      $5 = ((1 << $6 | 0) - 1 | 0) & ($8 >>> (32 - $6 | 0) | 0) | 0 | ($4 << $6 | 0) | 0;
      $4 = $8 << $6 | 0;
     }
    }
    $8 = $12;
    $7 = $14;
    $8 = $5 | $8 | 0;
    $4 = $4 | $7 | 0;
    i64toi32_i32$HIGH_BITS = $8;
    return $4 | 0;
   }
   $4 = $1_1;
   legalfunc$wasm2js_scratch_store_i64($0_1 | 0, $4 | 0);
   $4 = 0;
   $0_1 = 0;
   $1_1 = $4;
  }
  $4 = $1_1;
  $8 = $0_1;
  i64toi32_i32$HIGH_BITS = $4;
  return $8 | 0;
 }
 
 function __wasm_i64_srem($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  $3_1 = _ZN17compiler_builtins3int4sdiv3Mod4mod_17h2cbb7bbf36e41d68E($0_1 | 0, $1_1 | 0, $2_1 | 0, $3_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $3_1 | 0;
 }
 
 function __wasm_i64_urem($0_1, $1_1, $2_1, $3_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  $3_1 = _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0_1 | 0, $1_1 | 0, $2_1 | 0, $3_1 | 0) | 0;
  $1_1 = legalfunc$wasm2js_scratch_load_i64() | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $3_1;
  return $1_1 | 0;
 }
 
 function __wasm_ctz_i32($0_1) {
  $0_1 = $0_1 | 0;
  if ($0_1) {
   return 31 - Math_clz32(($0_1 + -1 | 0) ^ $0_1 | 0) | 0 | 0
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
