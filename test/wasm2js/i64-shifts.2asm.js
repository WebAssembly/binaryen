
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
 function $1($0, $1_1, $2_1, $3, $4) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3 = $3 | 0;
  $4 = $4 | 0;
  var $5 = 0, $6 = 0;
  $5 = $2_1 & 31;
  if (32 >>> 0 <= ($2_1 & 63) >>> 0) {
   {
    $1_1 = $0 << $5;
    $6 = 0;
   }
  } else {
   {
    $1_1 = (1 << $5) - 1 & $0 >>> 32 - $5 | $1_1 << $5;
    $6 = $0 << $5;
   }
  }
  return ($6 | 0) == ($3 | 0) & ($1_1 | 0) == ($4 | 0);
 }
 
 function $2($0, $1_1, $2_1, $3, $4) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3 = $3 | 0;
  $4 = $4 | 0;
  var $5 = 0, $6 = 0;
  $5 = $2_1 & 31;
  if (32 >>> 0 <= ($2_1 & 63) >>> 0) {
   {
    $2_1 = $1_1 >> 31;
    $6 = $1_1 >> $5;
   }
  } else {
   {
    $2_1 = $1_1 >> $5;
    $6 = ((1 << $5) - 1 & $1_1) << 32 - $5 | $0 >>> $5;
   }
  }
  return ($6 | 0) == ($3 | 0) & ($2_1 | 0) == ($4 | 0);
 }
 
 function legalstub$1($0, $1_1, $2_1, $3, $4, $5) {
  var $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0, $13 = 0, $14 = 0, $15 = 0, $16 = 0, $17 = 0;
  $11 = $0;
  $7 = 32;
  $0 = $7 & 31;
  if (32 >>> 0 <= $7 >>> 0) {
   {
    $6 = $1_1 << $0;
    $8 = 0;
   }
  } else {
   {
    $6 = (1 << $0) - 1 & $1_1 >>> 32 - $0 | $6 << $0;
    $8 = $1_1 << $0;
   }
  }
  $12 = $11 | $8;
  $13 = $6 | $16;
  $14 = $2_1;
  $2_1 = 0;
  $1_1 = $3;
  $3 = 32;
  $0 = $3 & 31;
  if (32 >>> 0 <= $3 >>> 0) {
   {
    $2_1 = $1_1 << $0;
    $9 = 0;
   }
  } else {
   {
    $2_1 = (1 << $0) - 1 & $1_1 >>> 32 - $0 | $2_1 << $0;
    $9 = $1_1 << $0;
   }
  }
  $15 = $14 | $9;
  $2_1 = 0;
  $1_1 = $5;
  $0 = 32 & 31;
  if (32 >>> 0 <= $3 >>> 0) {
   {
    $2_1 = $1_1 << $0;
    $10 = 0;
   }
  } else {
   {
    $2_1 = (1 << $0) - 1 & $1_1 >>> 32 - $0 | $2_1 << $0;
    $10 = $1_1 << $0;
   }
  }
  return $1($12, $13, $15, $10 | $4, $2_1 | $17);
 }
 
 function legalstub$2($0, $1_1, $2_1, $3, $4, $5) {
  var $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0, $13 = 0, $14 = 0, $15 = 0, $16 = 0, $17 = 0;
  $11 = $0;
  $7 = 32;
  $0 = $7 & 31;
  if (32 >>> 0 <= $7 >>> 0) {
   {
    $6 = $1_1 << $0;
    $8 = 0;
   }
  } else {
   {
    $6 = (1 << $0) - 1 & $1_1 >>> 32 - $0 | $6 << $0;
    $8 = $1_1 << $0;
   }
  }
  $12 = $11 | $8;
  $13 = $6 | $16;
  $14 = $2_1;
  $2_1 = 0;
  $1_1 = $3;
  $3 = 32;
  $0 = $3 & 31;
  if (32 >>> 0 <= $3 >>> 0) {
   {
    $2_1 = $1_1 << $0;
    $9 = 0;
   }
  } else {
   {
    $2_1 = (1 << $0) - 1 & $1_1 >>> 32 - $0 | $2_1 << $0;
    $9 = $1_1 << $0;
   }
  }
  $15 = $14 | $9;
  $2_1 = 0;
  $1_1 = $5;
  $0 = 32 & 31;
  if (32 >>> 0 <= $3 >>> 0) {
   {
    $2_1 = $1_1 << $0;
    $10 = 0;
   }
  } else {
   {
    $2_1 = (1 << $0) - 1 & $1_1 >>> 32 - $0 | $2_1 << $0;
    $10 = $1_1 << $0;
   }
  }
  return $2($12, $13, $15, $10 | $4, $2_1 | $17);
 }
 
 var FUNCTION_TABLE = [];
 return {
  "shl_i64": legalstub$1, 
  "shr_i64": legalstub$2
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export var shl_i64 = retasmFunc.shl_i64;
export var shr_i64 = retasmFunc.shr_i64;
