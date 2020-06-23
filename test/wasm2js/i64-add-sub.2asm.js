
function asmFunc(global, env, buffer) {
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
 function $1($0, $0$hi, $1_1, $1$hi, r, r$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  $1_1 = $1_1 | 0;
  $1$hi = $1$hi | 0;
  r = r | 0;
  r$hi = r$hi | 0;
  var i64toi32_i32$5 = 0, i64toi32_i32$3 = 0, i64toi32_i32$4 = 0, $5$hi = 0;
  i64toi32_i32$3 = $1_1;
  i64toi32_i32$4 = $0 + i64toi32_i32$3 | 0;
  i64toi32_i32$5 = $0$hi + $1$hi | 0;
  if (i64toi32_i32$4 >>> 0 < i64toi32_i32$3 >>> 0) {
   i64toi32_i32$5 = i64toi32_i32$5 + 1 | 0
  }
  $5$hi = i64toi32_i32$5;
  i64toi32_i32$5 = r$hi;
  i64toi32_i32$5 = $5$hi;
  i64toi32_i32$3 = r;
  return (i64toi32_i32$4 | 0) == (i64toi32_i32$3 | 0) & (i64toi32_i32$5 | 0) == (r$hi | 0) | 0 | 0;
 }
 
 function $2($0, $0$hi, $1_1, $1$hi, r, r$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  $1_1 = $1_1 | 0;
  $1$hi = $1$hi | 0;
  r = r | 0;
  r$hi = r$hi | 0;
  var i64toi32_i32$5 = 0, i64toi32_i32$0 = 0, i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, $5$hi = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = $1$hi;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$2 = $0;
  i64toi32_i32$3 = $1_1;
  i64toi32_i32$5 = (i64toi32_i32$2 >>> 0 < i64toi32_i32$3 >>> 0) + $1$hi | 0;
  i64toi32_i32$5 = i64toi32_i32$0 - i64toi32_i32$5 | 0;
  $5$hi = i64toi32_i32$5;
  i64toi32_i32$5 = r$hi;
  i64toi32_i32$5 = $5$hi;
  i64toi32_i32$0 = i64toi32_i32$2 - i64toi32_i32$3 | 0;
  i64toi32_i32$2 = r$hi;
  i64toi32_i32$3 = r;
  return (i64toi32_i32$0 | 0) == (i64toi32_i32$3 | 0) & (i64toi32_i32$5 | 0) == (i64toi32_i32$2 | 0) | 0 | 0;
 }
 
 function legalstub$1($0, $1_1, $2_1, $3, $4, $5) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3 = $3 | 0;
  $4 = $4 | 0;
  $5 = $5 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$2 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $26 = 0, $27 = 0, $28 = 0, $7 = 0, $7$hi = 0, $10$hi = 0, $11 = 0, $11$hi = 0, $13 = 0, $13$hi = 0, $16$hi = 0, $17 = 0, $17$hi = 0, $19 = 0, $19$hi = 0, $22$hi = 0, $23 = 0, $23$hi = 0;
  i64toi32_i32$0 = 0;
  $7 = $0;
  $7$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $26 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $26 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $10$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $7$hi;
  i64toi32_i32$0 = $7;
  i64toi32_i32$2 = $10$hi;
  i64toi32_i32$3 = $26;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  $11 = i64toi32_i32$0 | i64toi32_i32$3 | 0;
  $11$hi = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  $13 = $2_1;
  $13$hi = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$1 = $3;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = i64toi32_i32$1 << i64toi32_i32$4 | 0;
   $27 = 0;
  } else {
   i64toi32_i32$0 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$1 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$2 << i64toi32_i32$4 | 0) | 0;
   $27 = i64toi32_i32$1 << i64toi32_i32$4 | 0;
  }
  $16$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $13$hi;
  i64toi32_i32$2 = $13;
  i64toi32_i32$1 = $16$hi;
  i64toi32_i32$3 = $27;
  i64toi32_i32$1 = i64toi32_i32$0 | i64toi32_i32$1 | 0;
  $17 = i64toi32_i32$2 | i64toi32_i32$3 | 0;
  $17$hi = i64toi32_i32$1;
  i64toi32_i32$1 = 0;
  $19 = $4;
  $19$hi = i64toi32_i32$1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$0 = $5;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = i64toi32_i32$0 << i64toi32_i32$4 | 0;
   $28 = 0;
  } else {
   i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$0 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
   $28 = i64toi32_i32$0 << i64toi32_i32$4 | 0;
  }
  $22$hi = i64toi32_i32$2;
  i64toi32_i32$2 = $19$hi;
  i64toi32_i32$1 = $19;
  i64toi32_i32$0 = $22$hi;
  i64toi32_i32$3 = $28;
  i64toi32_i32$0 = i64toi32_i32$2 | i64toi32_i32$0 | 0;
  $23 = i64toi32_i32$1 | i64toi32_i32$3 | 0;
  $23$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $11$hi;
  i64toi32_i32$1 = $17$hi;
  i64toi32_i32$2 = $23$hi;
  return $1($11 | 0, i64toi32_i32$0 | 0, $17 | 0, i64toi32_i32$1 | 0, $23 | 0, i64toi32_i32$2 | 0) | 0 | 0;
 }
 
 function legalstub$2($0, $1_1, $2_1, $3, $4, $5) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3 = $3 | 0;
  $4 = $4 | 0;
  $5 = $5 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$2 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $26 = 0, $27 = 0, $28 = 0, $7 = 0, $7$hi = 0, $10$hi = 0, $11 = 0, $11$hi = 0, $13 = 0, $13$hi = 0, $16$hi = 0, $17 = 0, $17$hi = 0, $19 = 0, $19$hi = 0, $22$hi = 0, $23 = 0, $23$hi = 0;
  i64toi32_i32$0 = 0;
  $7 = $0;
  $7$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $26 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $26 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $10$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $7$hi;
  i64toi32_i32$0 = $7;
  i64toi32_i32$2 = $10$hi;
  i64toi32_i32$3 = $26;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  $11 = i64toi32_i32$0 | i64toi32_i32$3 | 0;
  $11$hi = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  $13 = $2_1;
  $13$hi = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$1 = $3;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = i64toi32_i32$1 << i64toi32_i32$4 | 0;
   $27 = 0;
  } else {
   i64toi32_i32$0 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$1 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$2 << i64toi32_i32$4 | 0) | 0;
   $27 = i64toi32_i32$1 << i64toi32_i32$4 | 0;
  }
  $16$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $13$hi;
  i64toi32_i32$2 = $13;
  i64toi32_i32$1 = $16$hi;
  i64toi32_i32$3 = $27;
  i64toi32_i32$1 = i64toi32_i32$0 | i64toi32_i32$1 | 0;
  $17 = i64toi32_i32$2 | i64toi32_i32$3 | 0;
  $17$hi = i64toi32_i32$1;
  i64toi32_i32$1 = 0;
  $19 = $4;
  $19$hi = i64toi32_i32$1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$0 = $5;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = i64toi32_i32$0 << i64toi32_i32$4 | 0;
   $28 = 0;
  } else {
   i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$0 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
   $28 = i64toi32_i32$0 << i64toi32_i32$4 | 0;
  }
  $22$hi = i64toi32_i32$2;
  i64toi32_i32$2 = $19$hi;
  i64toi32_i32$1 = $19;
  i64toi32_i32$0 = $22$hi;
  i64toi32_i32$3 = $28;
  i64toi32_i32$0 = i64toi32_i32$2 | i64toi32_i32$0 | 0;
  $23 = i64toi32_i32$1 | i64toi32_i32$3 | 0;
  $23$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $11$hi;
  i64toi32_i32$1 = $17$hi;
  i64toi32_i32$2 = $23$hi;
  return $2($11 | 0, i64toi32_i32$0 | 0, $17 | 0, i64toi32_i32$1 | 0, $23 | 0, i64toi32_i32$2 | 0) | 0 | 0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "check_add_i64": legalstub$1, 
  "check_sub_i64": legalstub$2
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export var check_add_i64 = retasmFunc.check_add_i64;
export var check_sub_i64 = retasmFunc.check_sub_i64;
