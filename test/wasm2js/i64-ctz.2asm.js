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
 function popcnt64($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $1 = __wasm_popcnt_i64($0 | 0, $1 | 0) | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $0;
  return $1 | 0;
 }
 
 function ctz64($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $1 = __wasm_ctz_i64($0 | 0, $1 | 0) | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $0;
  return $1 | 0;
 }
 
 function legalstub$popcnt64($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0;
  $3 = 0;
  $5 = $0;
  $6 = $3;
  $3 = 0;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0 = $1 << $2 | 0;
    $4 = 0;
   }
  } else {
   {
    $0 = ((1 << $2 | 0) - 1 | 0) & ($1 >>> (32 - $2 | 0) | 0) | 0 | ($3 << $2 | 0) | 0;
    $4 = $1 << $2 | 0;
   }
  }
  $1 = $0;
  $0 = $6;
  $3 = $5;
  $1 = $0 | $1 | 0;
  $1 = popcnt64($3 | $4 | 0 | 0, $1 | 0) | 0;
  $3 = i64toi32_i32$HIGH_BITS;
  $6 = $1;
  $5 = $3;
  $0 = $1;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0 = $3 >>> $2 | 0
  } else {
   $0 = (((1 << $2 | 0) - 1 | 0) & $3 | 0) << (32 - $2 | 0) | 0 | ($0 >>> $2 | 0) | 0
  }
  setTempRet0($0 | 0);
  return $6 | 0;
 }
 
 function legalstub$ctz64($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0;
  $3 = 0;
  $5 = $0;
  $6 = $3;
  $3 = 0;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0 = $1 << $2 | 0;
    $4 = 0;
   }
  } else {
   {
    $0 = ((1 << $2 | 0) - 1 | 0) & ($1 >>> (32 - $2 | 0) | 0) | 0 | ($3 << $2 | 0) | 0;
    $4 = $1 << $2 | 0;
   }
  }
  $1 = $0;
  $0 = $6;
  $3 = $5;
  $1 = $0 | $1 | 0;
  $1 = ctz64($3 | $4 | 0 | 0, $1 | 0) | 0;
  $3 = i64toi32_i32$HIGH_BITS;
  $6 = $1;
  $5 = $3;
  $0 = $1;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0 = $3 >>> $2 | 0
  } else {
   $0 = (((1 << $2 | 0) - 1 | 0) & $3 | 0) << (32 - $2 | 0) | 0 | ($0 >>> $2 | 0) | 0
  }
  setTempRet0($0 | 0);
  return $6 | 0;
 }
 
 function __wasm_ctz_i64($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0;
  $3 = $1;
  if (!!($0 | $3 | 0)) {
   {
    $3 = $1;
    $2 = $0;
    $6 = -1;
    $4 = -1;
    $2 = $2 + $4 | 0;
    $5 = $3 + $6 | 0;
    if ($2 >>> 0 < $4 >>> 0) {
     $5 = $5 + 1 | 0
    }
    $3 = $2;
    $2 = $1;
    $4 = $0;
    $2 = $5 ^ $2 | 0;
    $3 = $3 ^ $4 | 0;
    $4 = Math_clz32($2);
    $5 = 0;
    if (($4 | 0) == (32 | 0)) {
     $4 = Math_clz32($3) + 32 | 0
    }
    $2 = $5;
    $5 = 0;
    $3 = 63;
    $6 = $3 - $4 | 0;
    $2 = ($3 >>> 0 < $4 >>> 0) + $2 | 0;
    $2 = $5 - $2 | 0;
    $3 = $6;
    i64toi32_i32$HIGH_BITS = $2;
    return $3 | 0;
   }
  }
  $3 = 0;
  $2 = 64;
  i64toi32_i32$HIGH_BITS = $3;
  return $2 | 0;
 }
 
 function __wasm_popcnt_i64($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0;
  label$1 : {
   label$2 : while (1) {
    $4 = $1;
    $3 = !($0 | $4 | 0);
    $4 = $7;
    $2 = $8;
    if ($3) {
     break label$1
    }
    $4 = $1;
    $3 = $0;
    $2 = 0;
    $6 = 1;
    $5 = $3 - $6 | 0;
    $2 = ($3 >>> 0 < $6 >>> 0) + $2 | 0;
    $2 = $4 - $2 | 0;
    $0 = $2;
    $2 = $4;
    $4 = $3;
    $3 = $0;
    $3 = $2 & $3 | 0;
    $0 = $4 & $5 | 0;
    $1 = $3;
    $3 = $7;
    $2 = $8;
    $4 = 0;
    $6 = 1;
    $2 = $2 + $6 | 0;
    $5 = $3 + $4 | 0;
    if ($2 >>> 0 < $6 >>> 0) {
     $5 = $5 + 1 | 0
    }
    $8 = $2;
    $7 = $5;
    continue label$2;
   };
  }
  $5 = $4;
  i64toi32_i32$HIGH_BITS = $5;
  return $2 | 0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "a": legalstub$popcnt64, 
  "b": legalstub$ctz64
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0},memasmFunc);
export var a = retasmFunc.a;
export var b = retasmFunc.b;
