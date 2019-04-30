
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
 var i64toi32_i32$HIGH_BITS = 0;
 function legalstub$1($0, $1, $2, $3, $4, $5) {
  return (__wasm_rotl_i64($0, $1, $2) | 0) == ($4 | 0) & ($5 | 0) == (i64toi32_i32$HIGH_BITS | 0);
 }
 
 function legalstub$2($0, $1, $2, $3, $4, $5) {
  return (__wasm_rotr_i64($0, $1, $2) | 0) == ($4 | 0) & ($5 | 0) == (i64toi32_i32$HIGH_BITS | 0);
 }
 
 function __wasm_rotl_i64($0, $1, $2) {
  var $3 = 0, $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0;
  $6 = $2 & 63;
  $5 = $6;
  $3 = $5 & 31;
  if (32 >>> 0 <= $5 >>> 0) {
   $7 = -1 >>> $3
  } else {
   {
    $4 = -1 >>> $3;
    $7 = (1 << $3) - 1 << 32 - $3 | -1 >>> $3;
   }
  }
  $5 = $7 & $0;
  $3 = $1 & $4;
  $4 = $6 & 31;
  if (32 >>> 0 <= $6 >>> 0) {
   {
    $3 = $5 << $4;
    $8 = 0;
   }
  } else {
   {
    $3 = (1 << $4) - 1 & $5 >>> 32 - $4 | $3 << $4;
    $8 = $5 << $4;
   }
  }
  $6 = $8;
  $5 = $3;
  $4 = 0 - $2 & 63;
  $3 = $4;
  $2 = $3 & 31;
  if (32 >>> 0 <= ($3 & 63) >>> 0) {
   {
    $3 = -1 << $2;
    $9 = 0;
   }
  } else {
   {
    $3 = (1 << $2) - 1 & -1 >>> 32 - $2 | -1 << $2;
    $9 = -1 << $2;
   }
  }
  $0 = $9 & $0;
  $3 = $1 & $3;
  $1 = $4 & 31;
  if (32 >>> 0 <= $4 >>> 0) {
   {
    $2 = 0;
    $10 = $3 >>> $1;
   }
  } else {
   {
    $2 = $3 >>> $1;
    $10 = ((1 << $1) - 1 & $3) << 32 - $1 | $0 >>> $1;
   }
  }
  $0 = $10 | $6;
  i64toi32_i32$HIGH_BITS = $2 | $5;
  return $0;
 }
 
 function __wasm_rotr_i64($0, $1, $2) {
  var $3 = 0, $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0;
  $6 = $2 & 63;
  $7 = $6;
  $3 = $6 & 31;
  if (32 >>> 0 <= $6 >>> 0) {
   {
    $4 = -1 << $3;
    $8 = 0;
   }
  } else {
   {
    $4 = (1 << $3) - 1 & -1 >>> 32 - $3 | -1 << $3;
    $8 = -1 << $3;
   }
  }
  $7 = $8 & $0;
  $3 = $1 & $4;
  $5 = $6 & 31;
  if (32 >>> 0 <= $6 >>> 0) {
   {
    $4 = 0;
    $9 = $3 >>> $5;
   }
  } else {
   {
    $4 = $3 >>> $5;
    $9 = ((1 << $5) - 1 & $3) << 32 - $5 | $7 >>> $5;
   }
  }
  $6 = $9;
  $7 = $4;
  $3 = 0 - $2 & 63;
  $2 = $3;
  $5 = $3 & 31;
  if (32 >>> 0 <= ($3 & 63) >>> 0) {
   {
    $4 = 0;
    $10 = -1 >>> $5;
   }
  } else {
   {
    $4 = -1 >>> $5;
    $10 = (1 << $5) - 1 << 32 - $5 | -1 >>> $5;
   }
  }
  $0 = $10 & $0;
  $1 = $1 & $4;
  $4 = $3 & 31;
  if (32 >>> 0 <= $3 >>> 0) {
   {
    $2 = $0 << $4;
    $11 = 0;
   }
  } else {
   {
    $2 = (1 << $4) - 1 & $0 >>> 32 - $4 | $1 << $4;
    $11 = $0 << $4;
   }
  }
  $0 = $11 | $6;
  i64toi32_i32$HIGH_BITS = $2 | $7;
  return $0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "rotl": legalstub$1, 
  "rotr": legalstub$2
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export var rotl = retasmFunc.rotl;
export var rotr = retasmFunc.rotr;
