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
  var $2_1 = 0, $3 = 0;
  if ($0_1 | $1) {
   {
    $2_1 = 1;
    $0_1 = __wasm_i64_mul($0_1, $1, $0($0_1 - $2_1 | 0, $1 - ($0_1 >>> 0 < $2_1 >>> 0) | 0), i64toi32_i32$HIGH_BITS);
    $3 = i64toi32_i32$HIGH_BITS;
   }
  } else {
   {
    $0_1 = 1;
    $3 = 0;
   }
  }
  i64toi32_i32$HIGH_BITS = $3;
  return $0_1 | 0;
 }
 
 function fac_rec_named($0_1, $1) {
  $0_1 = $0_1 | 0;
  $1 = $1 | 0;
  var $2_1 = 0, $3 = 0;
  if ($0_1 | $1) {
   {
    $2_1 = 1;
    $0_1 = __wasm_i64_mul($0_1, $1, fac_rec_named($0_1 - $2_1 | 0, $1 - ($0_1 >>> 0 < $2_1 >>> 0) | 0), i64toi32_i32$HIGH_BITS);
    $3 = i64toi32_i32$HIGH_BITS;
   }
  } else {
   {
    $0_1 = 1;
    $3 = 0;
   }
  }
  i64toi32_i32$HIGH_BITS = $3;
  return $0_1 | 0;
 }
 
 function $2($0_1, $1) {
  $0_1 = $0_1 | 0;
  $1 = $1 | 0;
  var $2_1 = 0, $3 = 0, $4_1 = 0, $5 = 0;
  $2_1 = $1;
  $3 = 1;
  loop_in : while (1) {
   if ($0_1 | $2_1) {
    {
     $3 = __wasm_i64_mul($0_1, $2_1, $3, $4_1);
     $4_1 = i64toi32_i32$HIGH_BITS;
     $1 = $0_1;
     $5 = 1;
     $0_1 = $0_1 - $5 | 0;
     $2_1 = $2_1 - ($1 >>> 0 < $5 >>> 0) | 0;
     continue;
    }
   }
   break;
  };
  i64toi32_i32$HIGH_BITS = $4_1;
  return $3 | 0;
 }
 
 function $4($0_1, $1) {
  $0_1 = $0_1 | 0;
  $1 = $1 | 0;
  var $2_1 = 0, $3 = 0, $4_1 = 0, $5 = 0;
  $3 = 1;
  if (!(($1 | 0) < ($2_1 | 0) ? 1 : ($1 | 0) <= (0 | 0) ? ($0_1 >>> 0 >= 2 >>> 0 ? 0 : 1) : 0)) {
   loop_in : while (1) {
    $3 = __wasm_i64_mul($3, $4_1, $0_1, $1);
    $4_1 = i64toi32_i32$HIGH_BITS;
    $1 = $1 + -1 | 0;
    $5 = $0_1;
    $0_1 = -1;
    $2_1 = $5 + $0_1 | 0;
    if ($2_1 >>> 0 < $0_1 >>> 0) {
     $1 = $1 + 1 | 0
    }
    $0_1 = $2_1;
    $2_1 = 0;
    if (($1 | 0) > ($2_1 | 0) ? 1 : ($1 | 0) >= ($2_1 | 0) ? ($0_1 >>> 0 <= 1 >>> 0 ? 0 : 1) : 0) {
     continue
    }
    break;
   }
  }
  i64toi32_i32$HIGH_BITS = $4_1;
  return $3 | 0;
 }
 
 function legalstub$0($0_1, $1) {
  var $2_1 = 0, $3 = 0, $4_1 = 0, $5 = 0, $6 = 0;
  $5 = $0_1;
  $3 = 32;
  $0_1 = $3 & 31;
  if (32 >>> 0 <= $3 >>> 0) {
   {
    $2_1 = $1 << $0_1;
    $4_1 = 0;
   }
  } else {
   {
    $2_1 = (1 << $0_1) - 1 & $1 >>> 32 - $0_1 | $2_1 << $0_1;
    $4_1 = $1 << $0_1;
   }
  }
  $1 = $0($5 | $4_1, $2_1 | $6);
  $6 = $1;
  $2_1 = i64toi32_i32$HIGH_BITS;
  $0_1 = 32 & 31;
  setTempRet0((32 >>> 0 <= $3 >>> 0 ? $2_1 >>> $0_1 : ((1 << $0_1) - 1 & $2_1) << 32 - $0_1 | $1 >>> $0_1) | 0);
  return $1;
 }
 
 function legalstub$fac_rec_named($0_1, $1) {
  var $2_1 = 0, $3 = 0, $4_1 = 0, $5 = 0, $6 = 0;
  $5 = $0_1;
  $3 = 32;
  $0_1 = $3 & 31;
  if (32 >>> 0 <= $3 >>> 0) {
   {
    $2_1 = $1 << $0_1;
    $4_1 = 0;
   }
  } else {
   {
    $2_1 = (1 << $0_1) - 1 & $1 >>> 32 - $0_1 | $2_1 << $0_1;
    $4_1 = $1 << $0_1;
   }
  }
  $1 = fac_rec_named($5 | $4_1, $2_1 | $6);
  $6 = $1;
  $2_1 = i64toi32_i32$HIGH_BITS;
  $0_1 = 32 & 31;
  setTempRet0((32 >>> 0 <= $3 >>> 0 ? $2_1 >>> $0_1 : ((1 << $0_1) - 1 & $2_1) << 32 - $0_1 | $1 >>> $0_1) | 0);
  return $1;
 }
 
 function legalstub$2($0_1, $1) {
  var $2_1 = 0, $3 = 0, $4_1 = 0, $5 = 0, $6 = 0;
  $5 = $0_1;
  $3 = 32;
  $0_1 = $3 & 31;
  if (32 >>> 0 <= $3 >>> 0) {
   {
    $2_1 = $1 << $0_1;
    $4_1 = 0;
   }
  } else {
   {
    $2_1 = (1 << $0_1) - 1 & $1 >>> 32 - $0_1 | $2_1 << $0_1;
    $4_1 = $1 << $0_1;
   }
  }
  $1 = $2($5 | $4_1, $2_1 | $6);
  $6 = $1;
  $2_1 = i64toi32_i32$HIGH_BITS;
  $0_1 = 32 & 31;
  setTempRet0((32 >>> 0 <= $3 >>> 0 ? $2_1 >>> $0_1 : ((1 << $0_1) - 1 & $2_1) << 32 - $0_1 | $1 >>> $0_1) | 0);
  return $1;
 }
 
 function legalstub$4($0_1, $1) {
  var $2_1 = 0, $3 = 0, $4_1 = 0, $5 = 0, $6 = 0;
  $5 = $0_1;
  $3 = 32;
  $0_1 = $3 & 31;
  if (32 >>> 0 <= $3 >>> 0) {
   {
    $2_1 = $1 << $0_1;
    $4_1 = 0;
   }
  } else {
   {
    $2_1 = (1 << $0_1) - 1 & $1 >>> 32 - $0_1 | $2_1 << $0_1;
    $4_1 = $1 << $0_1;
   }
  }
  $1 = $4($5 | $4_1, $2_1 | $6);
  $6 = $1;
  $2_1 = i64toi32_i32$HIGH_BITS;
  $0_1 = 32 & 31;
  setTempRet0((32 >>> 0 <= $3 >>> 0 ? $2_1 >>> $0_1 : ((1 << $0_1) - 1 & $2_1) << 32 - $0_1 | $1 >>> $0_1) | 0);
  return $1;
 }
 
 function _ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE($0_1, $1, $2_1, $3) {
  var $4_1 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0;
  $4_1 = $2_1 >>> 16;
  $5 = $0_1 >>> 16;
  $7 = Math_imul($4_1, $5);
  $8 = $2_1 & 65535;
  $6 = $0_1 & 65535;
  $9 = Math_imul($8, $6);
  $5 = ($9 >>> 16) + Math_imul($5, $8) | 0;
  $4_1 = ($5 & 65535) + Math_imul($4_1, $6) | 0;
  $8 = 0;
  $11 = $7;
  $6 = $0_1;
  $7 = 32;
  $0_1 = $7 & 31;
  $12 = $11 + Math_imul(32 >>> 0 <= $7 >>> 0 ? $1 >>> $0_1 : ((1 << $0_1) - 1 & $1) << 32 - $0_1 | $6 >>> $0_1, $2_1) | 0;
  $1 = $2_1;
  $2_1 = 32;
  $0_1 = $2_1 & 31;
  $1 = (($12 + Math_imul($6, 32 >>> 0 <= $2_1 >>> 0 ? $3 >>> $0_1 : ((1 << $0_1) - 1 & $3) << 32 - $0_1 | $1 >>> $0_1) | 0) + ($5 >>> 16) | 0) + ($4_1 >>> 16) | 0;
  $0_1 = 32 & 31;
  if (32 >>> 0 <= $2_1 >>> 0) {
   {
    $2_1 = $1 << $0_1;
    $10 = 0;
   }
  } else {
   {
    $2_1 = (1 << $0_1) - 1 & $1 >>> 32 - $0_1 | $8 << $0_1;
    $10 = $1 << $0_1;
   }
  }
  $0_1 = $10 | ($9 & 65535 | $4_1 << 16);
  i64toi32_i32$HIGH_BITS = $2_1;
  return $0_1;
 }
 
 function __wasm_i64_mul($0_1, $1, $2_1, $3) {
  $0_1 = _ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE($0_1, $1, $2_1, $3);
  return $0_1;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "fac_rec": legalstub$0, 
  "fac_rec_named": legalstub$fac_rec_named, 
  "fac_iter": legalstub$2, 
  "fac_iter_named": legalstub$2, 
  "fac_opt": legalstub$4
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0},memasmFunc);
export var fac_rec = retasmFunc.fac_rec;
export var fac_rec_named = retasmFunc.fac_rec_named;
export var fac_iter = retasmFunc.fac_iter;
export var fac_iter_named = retasmFunc.fac_iter_named;
export var fac_opt = retasmFunc.fac_opt;
