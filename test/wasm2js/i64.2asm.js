function asmFunc(global, env, buffer) {
 "use asm";
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
 function $0(x, x$hi, y, y$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  y = y | 0;
  y$hi = y$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$5 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = y$hi;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$3 = y;
  i64toi32_i32$4 = x + i64toi32_i32$3 | 0;
  i64toi32_i32$5 = i64toi32_i32$0 + y$hi | 0;
  if (i64toi32_i32$4 >>> 0 < i64toi32_i32$3 >>> 0) i64toi32_i32$5 = i64toi32_i32$5 + 1 | 0;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$5;
  return i64toi32_i32$4 | 0;
 }
 
 function $1(x, x$hi, y, y$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  y = y | 0;
  y$hi = y$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$5 = 0, i64toi32_i32$2 = 0, i64toi32_i32$3 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = y$hi;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$2 = x;
  i64toi32_i32$3 = y;
  i64toi32_i32$5 = (i64toi32_i32$2 >>> 0 < i64toi32_i32$3 >>> 0) + y$hi | 0;
  i64toi32_i32$5 = i64toi32_i32$0 - i64toi32_i32$5 | 0;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$2 = i64toi32_i32$2 - i64toi32_i32$3 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$5;
  return i64toi32_i32$2 | 0;
 }
 
 function $2(x, x$hi, y, y$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  y = y | 0;
  y$hi = y$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = y$hi;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$1 = y$hi;
  i64toi32_i32$1 = __wasm_i64_mul(x | 0, i64toi32_i32$0 | 0, y | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $3(x, x$hi, y, y$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  y = y | 0;
  y$hi = y$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = y$hi;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$1 = y$hi;
  i64toi32_i32$1 = __wasm_i64_sdiv(x | 0, i64toi32_i32$0 | 0, y | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $4(x, x$hi, y, y$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  y = y | 0;
  y$hi = y$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = y$hi;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$1 = y$hi;
  i64toi32_i32$1 = __wasm_i64_udiv(x | 0, i64toi32_i32$0 | 0, y | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $5(x, x$hi, y, y$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  y = y | 0;
  y$hi = y$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = y$hi;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$1 = y$hi;
  i64toi32_i32$1 = __wasm_i64_srem(x | 0, i64toi32_i32$0 | 0, y | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $6(x, x$hi, y, y$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  y = y | 0;
  y$hi = y$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = y$hi;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$1 = y$hi;
  i64toi32_i32$1 = __wasm_i64_urem(x | 0, i64toi32_i32$0 | 0, y | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $7(x, x$hi, y, y$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  y = y | 0;
  y$hi = y$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = y$hi;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$2 = x;
  i64toi32_i32$1 = y$hi;
  i64toi32_i32$1 = i64toi32_i32$0 & i64toi32_i32$1 | 0;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$2 & y | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$2 | 0;
 }
 
 function $8(x, x$hi, y, y$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  y = y | 0;
  y$hi = y$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = y$hi;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$2 = x;
  i64toi32_i32$1 = y$hi;
  i64toi32_i32$1 = i64toi32_i32$0 | i64toi32_i32$1 | 0;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$2 | y | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$2 | 0;
 }
 
 function $9(x, x$hi, y, y$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  y = y | 0;
  y$hi = y$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = y$hi;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$2 = x;
  i64toi32_i32$1 = y$hi;
  i64toi32_i32$1 = i64toi32_i32$0 ^ i64toi32_i32$1 | 0;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$2 ^ y | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$2 | 0;
 }
 
 function $10(x, x$hi, y, y$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  y = y | 0;
  y$hi = y$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$2 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $9_1 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = y$hi;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$2 = x;
  i64toi32_i32$1 = y$hi;
  i64toi32_i32$3 = y;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $9_1 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $9_1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$2 = $9_1;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$2 | 0;
 }
 
 function $11(x, x$hi, y, y$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  y = y | 0;
  y$hi = y$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, $9_1 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = y$hi;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$2 = x;
  i64toi32_i32$1 = y$hi;
  i64toi32_i32$3 = y;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
   $9_1 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
   $9_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$2 = $9_1;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$2 | 0;
 }
 
 function $12(x, x$hi, y, y$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  y = y | 0;
  y$hi = y$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, $9_1 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = y$hi;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$2 = x;
  i64toi32_i32$1 = y$hi;
  i64toi32_i32$3 = y;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = 0;
   $9_1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $9_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$2 = $9_1;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$2 | 0;
 }
 
 function $13(x, x$hi, y, y$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  y = y | 0;
  y$hi = y$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = y$hi;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$1 = y$hi;
  i64toi32_i32$1 = __wasm_rotl_i64(x | 0, i64toi32_i32$0 | 0, y | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $14(x, x$hi, y, y$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  y = y | 0;
  y$hi = y$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = y$hi;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$1 = y$hi;
  i64toi32_i32$1 = __wasm_rotr_i64(x | 0, i64toi32_i32$0 | 0, y | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $15(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, $6_1 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = x;
  i64toi32_i32$3 = Math_clz32(i64toi32_i32$0);
  i64toi32_i32$2 = 0;
  if ((i64toi32_i32$3 | 0) == (32 | 0)) $6_1 = Math_clz32(i64toi32_i32$1) + 32 | 0; else $6_1 = i64toi32_i32$3;
  i64toi32_i32$2 = i64toi32_i32$2;
  i64toi32_i32$0 = $6_1;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$2;
  return i64toi32_i32$0 | 0;
 }
 
 function $16(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = __wasm_ctz_i64(x | 0, i64toi32_i32$0 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $17(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = __wasm_popcnt_i64(x | 0, i64toi32_i32$0 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $18(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  return (x | i64toi32_i32$0 | 0 | 0) == (0 | 0) | 0;
 }
 
 function $19(x, x$hi, y, y$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  y = y | 0;
  y$hi = y$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = y$hi;
  i64toi32_i32$0 = x$hi;
  return (x | 0) == (y | 0) & (i64toi32_i32$0 | 0) == (y$hi | 0) | 0 | 0;
 }
 
 function $20(x, x$hi, y, y$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  y = y | 0;
  y$hi = y$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = y$hi;
  i64toi32_i32$0 = x$hi;
  return (x | 0) != (y | 0) | (i64toi32_i32$0 | 0) != (y$hi | 0) | 0 | 0;
 }
 
 function $21(x, x$hi, y, y$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  y = y | 0;
  y$hi = y$hi | 0;
  var i64toi32_i32$0 = 0, $8_1 = 0, $9_1 = 0, $10_1 = 0, i64toi32_i32$2 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = y$hi;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$2 = x;
  i64toi32_i32$1 = y$hi;
  i64toi32_i32$3 = y;
  if ((i64toi32_i32$0 | 0) < (y$hi | 0)) $8_1 = 1; else {
   if ((i64toi32_i32$0 | 0) <= (i64toi32_i32$1 | 0)) {
    if (i64toi32_i32$2 >>> 0 >= i64toi32_i32$3 >>> 0) $9_1 = 0; else $9_1 = 1;
    $10_1 = $9_1;
   } else $10_1 = 0;
   $8_1 = $10_1;
  }
  return $8_1 | 0;
 }
 
 function $22(x, x$hi, y, y$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  y = y | 0;
  y$hi = y$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = y$hi;
  i64toi32_i32$0 = x$hi;
  return i64toi32_i32$0 >>> 0 < y$hi >>> 0 | ((i64toi32_i32$0 | 0) == (y$hi | 0) & x >>> 0 < y >>> 0 | 0) | 0 | 0;
 }
 
 function $23(x, x$hi, y, y$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  y = y | 0;
  y$hi = y$hi | 0;
  var i64toi32_i32$0 = 0, $8_1 = 0, $9_1 = 0, $10_1 = 0, i64toi32_i32$2 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = y$hi;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$2 = x;
  i64toi32_i32$1 = y$hi;
  i64toi32_i32$3 = y;
  if ((i64toi32_i32$0 | 0) < (y$hi | 0)) $8_1 = 1; else {
   if ((i64toi32_i32$0 | 0) <= (i64toi32_i32$1 | 0)) {
    if (i64toi32_i32$2 >>> 0 > i64toi32_i32$3 >>> 0) $9_1 = 0; else $9_1 = 1;
    $10_1 = $9_1;
   } else $10_1 = 0;
   $8_1 = $10_1;
  }
  return $8_1 | 0;
 }
 
 function $24(x, x$hi, y, y$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  y = y | 0;
  y$hi = y$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = y$hi;
  i64toi32_i32$0 = x$hi;
  return i64toi32_i32$0 >>> 0 < y$hi >>> 0 | ((i64toi32_i32$0 | 0) == (y$hi | 0) & x >>> 0 <= y >>> 0 | 0) | 0 | 0;
 }
 
 function $25(x, x$hi, y, y$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  y = y | 0;
  y$hi = y$hi | 0;
  var i64toi32_i32$0 = 0, $8_1 = 0, $9_1 = 0, $10_1 = 0, i64toi32_i32$2 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = y$hi;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$2 = x;
  i64toi32_i32$1 = y$hi;
  i64toi32_i32$3 = y;
  if ((i64toi32_i32$0 | 0) > (y$hi | 0)) $8_1 = 1; else {
   if ((i64toi32_i32$0 | 0) >= (i64toi32_i32$1 | 0)) {
    if (i64toi32_i32$2 >>> 0 <= i64toi32_i32$3 >>> 0) $9_1 = 0; else $9_1 = 1;
    $10_1 = $9_1;
   } else $10_1 = 0;
   $8_1 = $10_1;
  }
  return $8_1 | 0;
 }
 
 function $26(x, x$hi, y, y$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  y = y | 0;
  y$hi = y$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = y$hi;
  i64toi32_i32$0 = x$hi;
  return i64toi32_i32$0 >>> 0 > y$hi >>> 0 | ((i64toi32_i32$0 | 0) == (y$hi | 0) & x >>> 0 > y >>> 0 | 0) | 0 | 0;
 }
 
 function $27(x, x$hi, y, y$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  y = y | 0;
  y$hi = y$hi | 0;
  var i64toi32_i32$0 = 0, $8_1 = 0, $9_1 = 0, $10_1 = 0, i64toi32_i32$2 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = y$hi;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$2 = x;
  i64toi32_i32$1 = y$hi;
  i64toi32_i32$3 = y;
  if ((i64toi32_i32$0 | 0) > (y$hi | 0)) $8_1 = 1; else {
   if ((i64toi32_i32$0 | 0) >= (i64toi32_i32$1 | 0)) {
    if (i64toi32_i32$2 >>> 0 < i64toi32_i32$3 >>> 0) $9_1 = 0; else $9_1 = 1;
    $10_1 = $9_1;
   } else $10_1 = 0;
   $8_1 = $10_1;
  }
  return $8_1 | 0;
 }
 
 function $28(x, x$hi, y, y$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  y = y | 0;
  y$hi = y$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = y$hi;
  i64toi32_i32$0 = x$hi;
  return i64toi32_i32$0 >>> 0 > y$hi >>> 0 | ((i64toi32_i32$0 | 0) == (y$hi | 0) & x >>> 0 >= y >>> 0 | 0) | 0 | 0;
 }
 
 function _ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$2 = 0, var$2 = 0, i64toi32_i32$3 = 0, var$3 = 0, var$4 = 0, var$5 = 0, $21_1 = 0, $22_1 = 0, var$6 = 0, $24_1 = 0, $17_1 = 0, $18_1 = 0, $23_1 = 0, $29 = 0, $45 = 0, $56$hi = 0, $62$hi = 0;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  var$2 = var$1;
  var$4 = var$2 >>> 16 | 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  var$3 = var$0;
  var$5 = var$3 >>> 16 | 0;
  $17_1 = Math_imul(var$4, var$5);
  $18_1 = var$2;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$2 = var$3;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = 0;
   $21_1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $21_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  i64toi32_i32$1 = i64toi32_i32$1;
  $23_1 = $17_1 + Math_imul($18_1, $21_1) | 0;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$0 = var$1;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $22_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $22_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$0 >>> i64toi32_i32$4 | 0) | 0;
  }
  i64toi32_i32$2 = i64toi32_i32$2;
  $29 = $23_1 + Math_imul($22_1, var$3) | 0;
  var$2 = var$2 & 65535 | 0;
  var$3 = var$3 & 65535 | 0;
  var$6 = Math_imul(var$2, var$3);
  var$2 = (var$6 >>> 16 | 0) + Math_imul(var$2, var$5) | 0;
  $45 = $29 + (var$2 >>> 16 | 0) | 0;
  var$2 = (var$2 & 65535 | 0) + Math_imul(var$4, var$3) | 0;
  i64toi32_i32$2 = 0;
  i64toi32_i32$2 = i64toi32_i32$2;
  i64toi32_i32$1 = $45 + (var$2 >>> 16 | 0) | 0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = i64toi32_i32$1 << i64toi32_i32$4 | 0;
   $24_1 = 0;
  } else {
   i64toi32_i32$0 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$1 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$2 << i64toi32_i32$4 | 0) | 0;
   $24_1 = i64toi32_i32$1 << i64toi32_i32$4 | 0;
  }
  $56$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  $62$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $56$hi;
  i64toi32_i32$2 = $24_1;
  i64toi32_i32$1 = $62$hi;
  i64toi32_i32$3 = var$2 << 16 | 0 | (var$6 & 65535 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$0 | i64toi32_i32$1 | 0;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$2 | i64toi32_i32$3 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$2 | 0;
 }
 
 function _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$1 = 0, i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, i64toi32_i32$0 = 0, i64toi32_i32$5 = 0, var$2 = 0, var$2$hi = 0, i64toi32_i32$6 = 0, $21_1 = 0, $22_1 = 0, $23_1 = 0, $7$hi = 0, $9_1 = 0, $9$hi = 0, $14$hi = 0, $16$hi = 0, $17_1 = 0, $17$hi = 0, $23$hi = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$2 = var$0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
   $21_1 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
   $21_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  i64toi32_i32$1 = i64toi32_i32$1;
  var$2 = $21_1;
  var$2$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64toi32_i32$1;
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
  $9_1 = i64toi32_i32$4;
  $9$hi = i64toi32_i32$5;
  i64toi32_i32$5 = var$1$hi;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$2 = var$1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$0 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$5 >> 31 | 0;
   $22_1 = i64toi32_i32$5 >> i64toi32_i32$0 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$5 >> i64toi32_i32$0 | 0;
   $22_1 = (((1 << i64toi32_i32$0 | 0) - 1 | 0) & i64toi32_i32$5 | 0) << (32 - i64toi32_i32$0 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$0 | 0) | 0;
  }
  i64toi32_i32$1 = i64toi32_i32$1;
  var$2 = $22_1;
  var$2$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64toi32_i32$1;
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
  i64toi32_i32$1 = __wasm_i64_udiv($9_1 | 0, i64toi32_i32$4 | 0, i64toi32_i32$0 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$4 = i64toi32_i32$HIGH_BITS;
  $17_1 = i64toi32_i32$1;
  $17$hi = i64toi32_i32$4;
  i64toi32_i32$4 = var$1$hi;
  i64toi32_i32$4 = var$0$hi;
  i64toi32_i32$4 = var$1$hi;
  i64toi32_i32$2 = var$1;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$1 = i64toi32_i32$4 ^ i64toi32_i32$1 | 0;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$4 = i64toi32_i32$2 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$5 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = i64toi32_i32$1 >> 31 | 0;
   $23_1 = i64toi32_i32$1 >> i64toi32_i32$5 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$1 >> i64toi32_i32$5 | 0;
   $23_1 = (((1 << i64toi32_i32$5 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$5 | 0) | 0 | (i64toi32_i32$4 >>> i64toi32_i32$5 | 0) | 0;
  }
  i64toi32_i32$2 = i64toi32_i32$2;
  var$0 = $23_1;
  var$0$hi = i64toi32_i32$2;
  i64toi32_i32$2 = i64toi32_i32$2;
  i64toi32_i32$2 = $17$hi;
  i64toi32_i32$1 = $17_1;
  i64toi32_i32$4 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$4 = i64toi32_i32$2 ^ i64toi32_i32$4 | 0;
  $23$hi = i64toi32_i32$4;
  i64toi32_i32$4 = var$0$hi;
  i64toi32_i32$4 = $23$hi;
  i64toi32_i32$2 = i64toi32_i32$1 ^ i64toi32_i32$3 | 0;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$3 = i64toi32_i32$3;
  i64toi32_i32$5 = i64toi32_i32$2 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$0 = i64toi32_i32$6 + i64toi32_i32$1 | 0;
  i64toi32_i32$0 = i64toi32_i32$4 - i64toi32_i32$0 | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$2 = i64toi32_i32$5;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$2 | 0;
 }
 
 function _ZN17compiler_builtins3int4sdiv3Mod4mod_17h2cbb7bbf36e41d68E(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, i64toi32_i32$5 = 0, var$2$hi = 0, i64toi32_i32$6 = 0, var$2 = 0, $20_1 = 0, $21_1 = 0, $7$hi = 0, $9_1 = 0, $9$hi = 0, $14$hi = 0, $16$hi = 0, $17$hi = 0, $19$hi = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$2 = var$0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
   $20_1 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >> i64toi32_i32$4 | 0;
   $20_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  i64toi32_i32$1 = i64toi32_i32$1;
  var$2 = $20_1;
  var$2$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64toi32_i32$1;
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
  $9_1 = i64toi32_i32$4;
  $9$hi = i64toi32_i32$5;
  i64toi32_i32$5 = var$1$hi;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$2 = var$1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$0 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$5 >> 31 | 0;
   $21_1 = i64toi32_i32$5 >> i64toi32_i32$0 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$5 >> i64toi32_i32$0 | 0;
   $21_1 = (((1 << i64toi32_i32$0 | 0) - 1 | 0) & i64toi32_i32$5 | 0) << (32 - i64toi32_i32$0 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$0 | 0) | 0;
  }
  i64toi32_i32$1 = i64toi32_i32$1;
  var$0 = $21_1;
  var$0$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64toi32_i32$1;
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
  i64toi32_i32$1 = __wasm_i64_urem($9_1 | 0, i64toi32_i32$4 | 0, i64toi32_i32$0 | 0, i64toi32_i32$1 | 0) | 0;
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
  i64toi32_i32$3 = i64toi32_i32$3;
  i64toi32_i32$5 = i64toi32_i32$4 - i64toi32_i32$3 | 0;
  i64toi32_i32$6 = i64toi32_i32$4 >>> 0 < i64toi32_i32$3 >>> 0;
  i64toi32_i32$0 = i64toi32_i32$6 + i64toi32_i32$2 | 0;
  i64toi32_i32$0 = i64toi32_i32$1 - i64toi32_i32$0 | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$4 = i64toi32_i32$5;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$4 | 0;
 }
 
 function _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$5 = 0, var$2 = 0, var$3 = 0, var$4 = 0, var$5 = 0, var$5$hi = 0, var$6 = 0, var$6$hi = 0, i64toi32_i32$6 = 0, $38 = 0, $39 = 0, $40 = 0, $41 = 0, $42 = 0, $43 = 0, $44 = 0, $45 = 0, var$8$hi = 0, $46 = 0, $47 = 0, $48 = 0, $49 = 0, var$7$hi = 0, $50 = 0, $63$hi = 0, $65 = 0, $65$hi = 0, $66 = 0, $120$hi = 0, $129$hi = 0, $134$hi = 0, var$8 = 0, $140 = 0, $140$hi = 0, $142$hi = 0, $144 = 0, $144$hi = 0, $151 = 0, $151$hi = 0, $154$hi = 0, var$7 = 0, $165$hi = 0, wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0, wasm2js_i32$3 = 0;
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
             i64toi32_i32$0 = i64toi32_i32$0;
             i64toi32_i32$2 = var$0;
             i64toi32_i32$1 = 0;
             i64toi32_i32$3 = 32;
             i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
             if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
              i64toi32_i32$1 = 0;
              $38 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
             } else {
              i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
              $38 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
             }
             i64toi32_i32$1 = i64toi32_i32$1;
             var$2 = $38;
             if (var$2) block : {
              i64toi32_i32$1 = var$1$hi;
              i64toi32_i32$1 = i64toi32_i32$1;
              var$3 = var$1;
              if ((var$3 | 0) == (0 | 0)) break label$11;
              i64toi32_i32$1 = var$1$hi;
              i64toi32_i32$1 = i64toi32_i32$1;
              i64toi32_i32$0 = var$1;
              i64toi32_i32$2 = 0;
              i64toi32_i32$3 = 32;
              i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
              if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
               i64toi32_i32$2 = 0;
               $39 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
              } else {
               i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
               $39 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$0 >>> i64toi32_i32$4 | 0) | 0;
              }
              i64toi32_i32$2 = i64toi32_i32$2;
              var$4 = $39;
              if ((var$4 | 0) == (0 | 0)) break label$9;
              var$2 = Math_clz32(var$4) - Math_clz32(var$2) | 0;
              if (var$2 >>> 0 <= 31 >>> 0) break label$8;
              break label$2;
             };
             i64toi32_i32$2 = var$1$hi;
             i64toi32_i32$2 = i64toi32_i32$2;
             i64toi32_i32$1 = var$1;
             i64toi32_i32$0 = 1;
             i64toi32_i32$3 = 0;
             if (i64toi32_i32$2 >>> 0 > i64toi32_i32$0 >>> 0 | ((i64toi32_i32$2 | 0) == (i64toi32_i32$0 | 0) & i64toi32_i32$1 >>> 0 >= i64toi32_i32$3 >>> 0 | 0) | 0) break label$2;
             i64toi32_i32$1 = var$0$hi;
             i64toi32_i32$1 = i64toi32_i32$1;
             var$2 = var$0;
             i64toi32_i32$1 = var$1$hi;
             i64toi32_i32$1 = i64toi32_i32$1;
             var$3 = var$1;
             var$2 = (var$2 >>> 0) / (var$3 >>> 0) | 0;
             i64toi32_i32$1 = 0;
             i64toi32_i32$2 = 1024;
             i64toi32_i32$1 = i64toi32_i32$1;
             wasm2js_i32$0 = i64toi32_i32$2;
             wasm2js_i32$1 = var$0 - Math_imul(var$2, var$3) | 0;
             HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
             wasm2js_i32$0 = i64toi32_i32$2;
             wasm2js_i32$1 = i64toi32_i32$1;
             (wasm2js_i32$2 = wasm2js_i32$0, wasm2js_i32$3 = wasm2js_i32$1), ((HEAP8[(wasm2js_i32$2 + 4 | 0) >> 0] = wasm2js_i32$3 & 255 | 0, HEAP8[(wasm2js_i32$2 + 5 | 0) >> 0] = (wasm2js_i32$3 >>> 8 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 6 | 0) >> 0] = (wasm2js_i32$3 >>> 16 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 7 | 0) >> 0] = (wasm2js_i32$3 >>> 24 | 0) & 255 | 0;
             i64toi32_i32$1 = 0;
             i64toi32_i32$1 = i64toi32_i32$1;
             i64toi32_i32$2 = var$2;
             i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
             return i64toi32_i32$2 | 0;
            };
            i64toi32_i32$2 = var$1$hi;
            i64toi32_i32$2 = i64toi32_i32$2;
            i64toi32_i32$3 = var$1;
            i64toi32_i32$1 = 0;
            i64toi32_i32$0 = 32;
            i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
            if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
             i64toi32_i32$1 = 0;
             $40 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
            } else {
             i64toi32_i32$1 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
             $40 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$2 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$3 >>> i64toi32_i32$4 | 0) | 0;
            }
            i64toi32_i32$1 = i64toi32_i32$1;
            var$3 = $40;
            i64toi32_i32$1 = var$0$hi;
            i64toi32_i32$1 = i64toi32_i32$1;
            if ((var$0 | 0) == (0 | 0)) break label$7;
            if ((var$3 | 0) == (0 | 0)) break label$6;
            var$4 = var$3 + 4294967295 | 0;
            if (var$4 & var$3 | 0) break label$6;
            i64toi32_i32$1 = 0;
            i64toi32_i32$1 = i64toi32_i32$1;
            i64toi32_i32$2 = var$4 & var$2 | 0;
            i64toi32_i32$3 = 0;
            i64toi32_i32$0 = 32;
            i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
            if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
             i64toi32_i32$3 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
             $41 = 0;
            } else {
             i64toi32_i32$3 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
             $41 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
            }
            $63$hi = i64toi32_i32$3;
            i64toi32_i32$3 = var$0$hi;
            i64toi32_i32$3 = i64toi32_i32$3;
            i64toi32_i32$1 = var$0;
            i64toi32_i32$2 = 0;
            i64toi32_i32$0 = 4294967295;
            i64toi32_i32$2 = i64toi32_i32$3 & i64toi32_i32$2 | 0;
            $65 = i64toi32_i32$1 & i64toi32_i32$0 | 0;
            $65$hi = i64toi32_i32$2;
            i64toi32_i32$2 = $63$hi;
            i64toi32_i32$3 = $41;
            i64toi32_i32$1 = $65$hi;
            i64toi32_i32$0 = $65;
            i64toi32_i32$1 = i64toi32_i32$2 | i64toi32_i32$1 | 0;
            $66 = i64toi32_i32$3 | i64toi32_i32$0 | 0;
            i64toi32_i32$3 = 1024;
            i64toi32_i32$1 = i64toi32_i32$1;
            wasm2js_i32$0 = i64toi32_i32$3;
            wasm2js_i32$1 = $66;
            HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
            wasm2js_i32$0 = i64toi32_i32$3;
            wasm2js_i32$1 = i64toi32_i32$1;
            (wasm2js_i32$2 = wasm2js_i32$0, wasm2js_i32$3 = wasm2js_i32$1), ((HEAP8[(wasm2js_i32$2 + 4 | 0) >> 0] = wasm2js_i32$3 & 255 | 0, HEAP8[(wasm2js_i32$2 + 5 | 0) >> 0] = (wasm2js_i32$3 >>> 8 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 6 | 0) >> 0] = (wasm2js_i32$3 >>> 16 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 7 | 0) >> 0] = (wasm2js_i32$3 >>> 24 | 0) & 255 | 0;
            i64toi32_i32$1 = 0;
            i64toi32_i32$1 = i64toi32_i32$1;
            i64toi32_i32$3 = var$2 >>> ((__wasm_ctz_i32(var$3 | 0) | 0) & 31 | 0) | 0;
            i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
            return i64toi32_i32$3 | 0;
           };
          };
          var$4 = var$3 + 4294967295 | 0;
          if ((var$4 & var$3 | 0 | 0) == (0 | 0)) break label$5;
          var$2 = (Math_clz32(var$3) + 33 | 0) - Math_clz32(var$2) | 0;
          var$3 = 0 - var$2 | 0;
          break label$3;
         };
         var$3 = 63 - var$2 | 0;
         var$2 = var$2 + 1 | 0;
         break label$3;
        };
        var$4 = (var$2 >>> 0) / (var$3 >>> 0) | 0;
        i64toi32_i32$3 = 0;
        i64toi32_i32$3 = i64toi32_i32$3;
        i64toi32_i32$2 = var$2 - Math_imul(var$4, var$3) | 0;
        i64toi32_i32$1 = 0;
        i64toi32_i32$0 = 32;
        i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
        if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
         i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
         $42 = 0;
        } else {
         i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
         $42 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
        }
        i64toi32_i32$2 = 1024;
        i64toi32_i32$1 = i64toi32_i32$1;
        wasm2js_i32$0 = i64toi32_i32$2;
        wasm2js_i32$1 = $42;
        HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
        wasm2js_i32$0 = i64toi32_i32$2;
        wasm2js_i32$1 = i64toi32_i32$1;
        (wasm2js_i32$2 = wasm2js_i32$0, wasm2js_i32$3 = wasm2js_i32$1), ((HEAP8[(wasm2js_i32$2 + 4 | 0) >> 0] = wasm2js_i32$3 & 255 | 0, HEAP8[(wasm2js_i32$2 + 5 | 0) >> 0] = (wasm2js_i32$3 >>> 8 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 6 | 0) >> 0] = (wasm2js_i32$3 >>> 16 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 7 | 0) >> 0] = (wasm2js_i32$3 >>> 24 | 0) & 255 | 0;
        i64toi32_i32$1 = 0;
        i64toi32_i32$1 = i64toi32_i32$1;
        i64toi32_i32$2 = var$4;
        i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
        return i64toi32_i32$2 | 0;
       };
       var$2 = Math_clz32(var$3) - Math_clz32(var$2) | 0;
       if (var$2 >>> 0 < 31 >>> 0) break label$4;
       break label$2;
      };
      i64toi32_i32$2 = var$0$hi;
      i64toi32_i32$2 = i64toi32_i32$2;
      i64toi32_i32$2 = 0;
      i64toi32_i32$1 = 1024;
      i64toi32_i32$2 = i64toi32_i32$2;
      wasm2js_i32$0 = i64toi32_i32$1;
      wasm2js_i32$1 = var$4 & var$0 | 0;
      HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
      wasm2js_i32$0 = i64toi32_i32$1;
      wasm2js_i32$1 = i64toi32_i32$2;
      (wasm2js_i32$2 = wasm2js_i32$0, wasm2js_i32$3 = wasm2js_i32$1), ((HEAP8[(wasm2js_i32$2 + 4 | 0) >> 0] = wasm2js_i32$3 & 255 | 0, HEAP8[(wasm2js_i32$2 + 5 | 0) >> 0] = (wasm2js_i32$3 >>> 8 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 6 | 0) >> 0] = (wasm2js_i32$3 >>> 16 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 7 | 0) >> 0] = (wasm2js_i32$3 >>> 24 | 0) & 255 | 0;
      if ((var$3 | 0) == (1 | 0)) break label$1;
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
       $43 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
      } else {
       i64toi32_i32$1 = i64toi32_i32$2 >>> i64toi32_i32$4 | 0;
       $43 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$2 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$3 >>> i64toi32_i32$4 | 0) | 0;
      }
      i64toi32_i32$1 = i64toi32_i32$1;
      i64toi32_i32$3 = $43;
      i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
      return i64toi32_i32$3 | 0;
     };
     var$3 = 63 - var$2 | 0;
     var$2 = var$2 + 1 | 0;
    };
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
     $44 = i64toi32_i32$3 >>> i64toi32_i32$4 | 0;
    } else {
     i64toi32_i32$1 = i64toi32_i32$3 >>> i64toi32_i32$4 | 0;
     $44 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$3 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
    }
    i64toi32_i32$1 = i64toi32_i32$1;
    var$5 = $44;
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
     $45 = 0;
    } else {
     i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$3 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
     $45 = i64toi32_i32$3 << i64toi32_i32$4 | 0;
    }
    i64toi32_i32$2 = i64toi32_i32$2;
    var$0 = $45;
    var$0$hi = i64toi32_i32$2;
    label$13 : {
     if (var$2) block3 : {
      i64toi32_i32$2 = var$1$hi;
      i64toi32_i32$2 = i64toi32_i32$2;
      i64toi32_i32$1 = var$1;
      i64toi32_i32$3 = 4294967295;
      i64toi32_i32$0 = 4294967295;
      i64toi32_i32$4 = i64toi32_i32$1 + i64toi32_i32$0 | 0;
      i64toi32_i32$5 = i64toi32_i32$2 + i64toi32_i32$3 | 0;
      if (i64toi32_i32$4 >>> 0 < i64toi32_i32$0 >>> 0) i64toi32_i32$5 = i64toi32_i32$5 + 1 | 0;
      i64toi32_i32$5 = i64toi32_i32$5;
      var$8 = i64toi32_i32$4;
      var$8$hi = i64toi32_i32$5;
      label$15 : do {
       i64toi32_i32$5 = var$5$hi;
       i64toi32_i32$5 = i64toi32_i32$5;
       i64toi32_i32$2 = var$5;
       i64toi32_i32$1 = 0;
       i64toi32_i32$0 = 1;
       i64toi32_i32$3 = i64toi32_i32$0 & 31 | 0;
       if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
        i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$3 | 0;
        $46 = 0;
       } else {
        i64toi32_i32$1 = ((1 << i64toi32_i32$3 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$3 | 0) | 0) | 0 | (i64toi32_i32$5 << i64toi32_i32$3 | 0) | 0;
        $46 = i64toi32_i32$2 << i64toi32_i32$3 | 0;
       }
       $140 = $46;
       $140$hi = i64toi32_i32$1;
       i64toi32_i32$1 = var$0$hi;
       i64toi32_i32$1 = i64toi32_i32$1;
       i64toi32_i32$5 = var$0;
       i64toi32_i32$2 = 0;
       i64toi32_i32$0 = 63;
       i64toi32_i32$3 = i64toi32_i32$0 & 31 | 0;
       if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
        i64toi32_i32$2 = 0;
        $47 = i64toi32_i32$1 >>> i64toi32_i32$3 | 0;
       } else {
        i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$3 | 0;
        $47 = (((1 << i64toi32_i32$3 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$3 | 0) | 0 | (i64toi32_i32$5 >>> i64toi32_i32$3 | 0) | 0;
       }
       $142$hi = i64toi32_i32$2;
       i64toi32_i32$2 = $140$hi;
       i64toi32_i32$1 = $140;
       i64toi32_i32$5 = $142$hi;
       i64toi32_i32$0 = $47;
       i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
       i64toi32_i32$5 = i64toi32_i32$5;
       var$5 = i64toi32_i32$1 | i64toi32_i32$0 | 0;
       var$5$hi = i64toi32_i32$5;
       i64toi32_i32$5 = i64toi32_i32$5;
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
       i64toi32_i32$4 = i64toi32_i32$4;
       i64toi32_i32$5 = i64toi32_i32$3;
       i64toi32_i32$2 = 0;
       i64toi32_i32$0 = 63;
       i64toi32_i32$1 = i64toi32_i32$0 & 31 | 0;
       if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
        i64toi32_i32$2 = i64toi32_i32$4 >> 31 | 0;
        $48 = i64toi32_i32$4 >> i64toi32_i32$1 | 0;
       } else {
        i64toi32_i32$2 = i64toi32_i32$4 >> i64toi32_i32$1 | 0;
        $48 = (((1 << i64toi32_i32$1 | 0) - 1 | 0) & i64toi32_i32$4 | 0) << (32 - i64toi32_i32$1 | 0) | 0 | (i64toi32_i32$5 >>> i64toi32_i32$1 | 0) | 0;
       }
       i64toi32_i32$2 = i64toi32_i32$2;
       var$6 = $48;
       var$6$hi = i64toi32_i32$2;
       i64toi32_i32$2 = i64toi32_i32$2;
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
       i64toi32_i32$3 = i64toi32_i32$3;
       var$5 = i64toi32_i32$1;
       var$5$hi = i64toi32_i32$3;
       i64toi32_i32$3 = var$0$hi;
       i64toi32_i32$3 = i64toi32_i32$3;
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
       $154$hi = i64toi32_i32$2;
       i64toi32_i32$2 = var$7$hi;
       i64toi32_i32$2 = $154$hi;
       i64toi32_i32$3 = $49;
       i64toi32_i32$5 = var$7$hi;
       i64toi32_i32$0 = var$7;
       i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
       i64toi32_i32$5 = i64toi32_i32$5;
       var$0 = i64toi32_i32$3 | i64toi32_i32$0 | 0;
       var$0$hi = i64toi32_i32$5;
       i64toi32_i32$5 = var$6$hi;
       i64toi32_i32$5 = i64toi32_i32$5;
       i64toi32_i32$2 = var$6;
       i64toi32_i32$3 = 0;
       i64toi32_i32$0 = 1;
       i64toi32_i32$3 = i64toi32_i32$5 & i64toi32_i32$3 | 0;
       i64toi32_i32$3 = i64toi32_i32$3;
       var$6 = i64toi32_i32$2 & i64toi32_i32$0 | 0;
       var$6$hi = i64toi32_i32$3;
       i64toi32_i32$3 = i64toi32_i32$3;
       i64toi32_i32$3 = i64toi32_i32$3;
       var$7 = var$6;
       var$7$hi = i64toi32_i32$3;
       var$2 = var$2 + 4294967295 | 0;
       if (var$2) continue label$15;
       break label$15;
      } while (1);
      break label$13;
     };
    };
    i64toi32_i32$3 = var$5$hi;
    i64toi32_i32$2 = 1024;
    i64toi32_i32$3 = i64toi32_i32$3;
    wasm2js_i32$0 = i64toi32_i32$2;
    wasm2js_i32$1 = var$5;
    HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
    wasm2js_i32$0 = i64toi32_i32$2;
    wasm2js_i32$1 = i64toi32_i32$3;
    (wasm2js_i32$2 = wasm2js_i32$0, wasm2js_i32$3 = wasm2js_i32$1), ((HEAP8[(wasm2js_i32$2 + 4 | 0) >> 0] = wasm2js_i32$3 & 255 | 0, HEAP8[(wasm2js_i32$2 + 5 | 0) >> 0] = (wasm2js_i32$3 >>> 8 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 6 | 0) >> 0] = (wasm2js_i32$3 >>> 16 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 7 | 0) >> 0] = (wasm2js_i32$3 >>> 24 | 0) & 255 | 0;
    i64toi32_i32$3 = var$0$hi;
    i64toi32_i32$3 = i64toi32_i32$3;
    i64toi32_i32$5 = var$0;
    i64toi32_i32$2 = 0;
    i64toi32_i32$0 = 1;
    i64toi32_i32$4 = i64toi32_i32$0 & 31 | 0;
    if (32 >>> 0 <= (i64toi32_i32$0 & 63 | 0) >>> 0) {
     i64toi32_i32$2 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
     $50 = 0;
    } else {
     i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$5 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$3 << i64toi32_i32$4 | 0) | 0;
     $50 = i64toi32_i32$5 << i64toi32_i32$4 | 0;
    }
    $165$hi = i64toi32_i32$2;
    i64toi32_i32$2 = var$6$hi;
    i64toi32_i32$2 = $165$hi;
    i64toi32_i32$3 = $50;
    i64toi32_i32$5 = var$6$hi;
    i64toi32_i32$0 = var$6;
    i64toi32_i32$5 = i64toi32_i32$2 | i64toi32_i32$5 | 0;
    i64toi32_i32$5 = i64toi32_i32$5;
    i64toi32_i32$3 = i64toi32_i32$3 | i64toi32_i32$0 | 0;
    i64toi32_i32$HIGH_BITS = i64toi32_i32$5;
    return i64toi32_i32$3 | 0;
   };
   i64toi32_i32$3 = var$0$hi;
   i64toi32_i32$5 = 1024;
   i64toi32_i32$3 = i64toi32_i32$3;
   wasm2js_i32$0 = i64toi32_i32$5;
   wasm2js_i32$1 = var$0;
   HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
   wasm2js_i32$0 = i64toi32_i32$5;
   wasm2js_i32$1 = i64toi32_i32$3;
   (wasm2js_i32$2 = wasm2js_i32$0, wasm2js_i32$3 = wasm2js_i32$1), ((HEAP8[(wasm2js_i32$2 + 4 | 0) >> 0] = wasm2js_i32$3 & 255 | 0, HEAP8[(wasm2js_i32$2 + 5 | 0) >> 0] = (wasm2js_i32$3 >>> 8 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 6 | 0) >> 0] = (wasm2js_i32$3 >>> 16 | 0) & 255 | 0), HEAP8[(wasm2js_i32$2 + 7 | 0) >> 0] = (wasm2js_i32$3 >>> 24 | 0) & 255 | 0;
   i64toi32_i32$3 = 0;
   var$0 = 0;
   var$0$hi = i64toi32_i32$3;
  };
  i64toi32_i32$3 = var$0$hi;
  i64toi32_i32$3 = i64toi32_i32$3;
  i64toi32_i32$3 = i64toi32_i32$3;
  i64toi32_i32$3 = i64toi32_i32$3;
  i64toi32_i32$5 = var$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$3;
  return i64toi32_i32$5 | 0;
 }
 
 function __wasm_ctz_i64(var$0, var$0$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$5 = 0, i64toi32_i32$3 = 0, i64toi32_i32$4 = 0, i64toi32_i32$2 = 0, i64toi32_i32$1 = 0, $10_1 = 0, $5$hi = 0, $8$hi = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  if (((var$0 | i64toi32_i32$0 | 0 | 0) == (0 | 0) | 0) == (0 | 0)) {
   i64toi32_i32$0 = var$0$hi;
   i64toi32_i32$0 = i64toi32_i32$0;
   i64toi32_i32$2 = var$0;
   i64toi32_i32$1 = 4294967295;
   i64toi32_i32$3 = 4294967295;
   i64toi32_i32$4 = i64toi32_i32$2 + i64toi32_i32$3 | 0;
   i64toi32_i32$5 = i64toi32_i32$0 + i64toi32_i32$1 | 0;
   if (i64toi32_i32$4 >>> 0 < i64toi32_i32$3 >>> 0) i64toi32_i32$5 = i64toi32_i32$5 + 1 | 0;
   $5$hi = i64toi32_i32$5;
   i64toi32_i32$5 = var$0$hi;
   i64toi32_i32$5 = $5$hi;
   i64toi32_i32$0 = i64toi32_i32$4;
   i64toi32_i32$2 = var$0$hi;
   i64toi32_i32$3 = var$0;
   i64toi32_i32$2 = i64toi32_i32$5 ^ i64toi32_i32$2 | 0;
   i64toi32_i32$2 = i64toi32_i32$2;
   i64toi32_i32$0 = i64toi32_i32$0 ^ i64toi32_i32$3 | 0;
   i64toi32_i32$3 = Math_clz32(i64toi32_i32$2);
   i64toi32_i32$5 = 0;
   if ((i64toi32_i32$3 | 0) == (32 | 0)) $10_1 = Math_clz32(i64toi32_i32$0) + 32 | 0; else $10_1 = i64toi32_i32$3;
   $8$hi = i64toi32_i32$5;
   i64toi32_i32$5 = 0;
   i64toi32_i32$0 = 63;
   i64toi32_i32$2 = $8$hi;
   i64toi32_i32$3 = $10_1;
   i64toi32_i32$1 = i64toi32_i32$0 - i64toi32_i32$3 | 0;
   i64toi32_i32$4 = (i64toi32_i32$0 >>> 0 < i64toi32_i32$3 >>> 0) + i64toi32_i32$2 | 0;
   i64toi32_i32$4 = i64toi32_i32$5 - i64toi32_i32$4 | 0;
   i64toi32_i32$4 = i64toi32_i32$4;
   i64toi32_i32$0 = i64toi32_i32$1;
   i64toi32_i32$HIGH_BITS = i64toi32_i32$4;
   return i64toi32_i32$0 | 0;
  }
  i64toi32_i32$0 = 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$4 = 64;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$4 | 0;
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
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$1;
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
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
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
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$1;
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
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function __wasm_i64_urem(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$2 = 0, wasm2js_i32$0 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$2 = 1024;
  i64toi32_i32$0 = HEAPU32[i64toi32_i32$2 >> 2] | 0;
  i64toi32_i32$1 = (wasm2js_i32$0 = i64toi32_i32$2, HEAPU8[(wasm2js_i32$0 + 4 | 0) >> 0] | 0 | 0 | (HEAPU8[(wasm2js_i32$0 + 5 | 0) >> 0] | 0 | 0) << 8 | (HEAPU8[(wasm2js_i32$0 + 6 | 0) >> 0] | 0 | 0) << 16 | (HEAPU8[(wasm2js_i32$0 + 7 | 0) >> 0] | 0 | 0) << 24);
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function __wasm_popcnt_i64(var$0, var$0$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$5 = 0, i64toi32_i32$3 = 0, i64toi32_i32$1 = 0, var$1$hi = 0, var$1 = 0, $5_1 = 0, $5$hi = 0, $4_1 = 0, $9$hi = 0;
  label$1 : {
   label$2 : do {
    i64toi32_i32$0 = var$1$hi;
    i64toi32_i32$0 = var$0$hi;
    i64toi32_i32$0 = i64toi32_i32$0;
    $4_1 = (var$0 | i64toi32_i32$0 | 0 | 0) == (0 | 0);
    i64toi32_i32$0 = var$1$hi;
    $5_1 = var$1;
    $5$hi = i64toi32_i32$0;
    if ($4_1) break label$1;
    i64toi32_i32$0 = $5$hi;
    i64toi32_i32$0 = i64toi32_i32$0;
    i64toi32_i32$0 = var$0$hi;
    i64toi32_i32$0 = i64toi32_i32$0;
    i64toi32_i32$0 = i64toi32_i32$0;
    i64toi32_i32$2 = var$0;
    i64toi32_i32$1 = 0;
    i64toi32_i32$3 = 1;
    i64toi32_i32$4 = i64toi32_i32$2 - i64toi32_i32$3 | 0;
    i64toi32_i32$5 = (i64toi32_i32$2 >>> 0 < i64toi32_i32$3 >>> 0) + i64toi32_i32$1 | 0;
    i64toi32_i32$5 = i64toi32_i32$0 - i64toi32_i32$5 | 0;
    $9$hi = i64toi32_i32$5;
    i64toi32_i32$5 = i64toi32_i32$0;
    i64toi32_i32$0 = i64toi32_i32$2;
    i64toi32_i32$2 = $9$hi;
    i64toi32_i32$3 = i64toi32_i32$4;
    i64toi32_i32$2 = i64toi32_i32$5 & i64toi32_i32$2 | 0;
    i64toi32_i32$2 = i64toi32_i32$2;
    var$0 = i64toi32_i32$0 & i64toi32_i32$4 | 0;
    var$0$hi = i64toi32_i32$2;
    i64toi32_i32$2 = var$1$hi;
    i64toi32_i32$2 = i64toi32_i32$2;
    i64toi32_i32$5 = var$1;
    i64toi32_i32$0 = 0;
    i64toi32_i32$3 = 1;
    i64toi32_i32$1 = i64toi32_i32$5 + i64toi32_i32$3 | 0;
    i64toi32_i32$4 = i64toi32_i32$2 + i64toi32_i32$0 | 0;
    if (i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0) i64toi32_i32$4 = i64toi32_i32$4 + 1 | 0;
    i64toi32_i32$4 = i64toi32_i32$4;
    var$1 = i64toi32_i32$1;
    var$1$hi = i64toi32_i32$4;
    continue label$2;
    break label$2;
   } while (1);
  };
  i64toi32_i32$4 = $5$hi;
  i64toi32_i32$4 = i64toi32_i32$4;
  i64toi32_i32$5 = $5_1;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$4;
  return i64toi32_i32$5 | 0;
 }
 
 function __wasm_rotl_i64(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, i64toi32_i32$5 = 0, i64toi32_i32$4 = 0, var$2$hi = 0, var$2 = 0, $19_1 = 0, $20_1 = 0, $21_1 = 0, $22_1 = 0, $6$hi = 0, $8$hi = 0, $10_1 = 0, $10$hi = 0, $15$hi = 0, $17$hi = 0, $19$hi = 0;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$2 = var$1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$1 = i64toi32_i32$0 & i64toi32_i32$1 | 0;
  i64toi32_i32$1 = i64toi32_i32$1;
  var$2 = i64toi32_i32$2 & i64toi32_i32$3 | 0;
  var$2$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$1 = 4294967295;
  i64toi32_i32$0 = 4294967295;
  i64toi32_i32$2 = var$2$hi;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $19_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $19_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$0 >>> i64toi32_i32$4 | 0) | 0;
  }
  $6$hi = i64toi32_i32$2;
  i64toi32_i32$2 = var$0$hi;
  i64toi32_i32$2 = $6$hi;
  i64toi32_i32$1 = $19_1;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$0 = i64toi32_i32$2 & i64toi32_i32$0 | 0;
  $8$hi = i64toi32_i32$0;
  i64toi32_i32$0 = var$2$hi;
  i64toi32_i32$0 = $8$hi;
  i64toi32_i32$2 = i64toi32_i32$1 & i64toi32_i32$3 | 0;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $20_1 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $20_1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $10_1 = $20_1;
  $10$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = 0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = var$1$hi;
  i64toi32_i32$3 = var$1;
  i64toi32_i32$4 = i64toi32_i32$0 - i64toi32_i32$3 | 0;
  i64toi32_i32$5 = (i64toi32_i32$0 >>> 0 < i64toi32_i32$3 >>> 0) + i64toi32_i32$2 | 0;
  i64toi32_i32$5 = i64toi32_i32$1 - i64toi32_i32$5 | 0;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$1 = i64toi32_i32$4;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$0 = i64toi32_i32$5 & i64toi32_i32$0 | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  var$1 = i64toi32_i32$1 & i64toi32_i32$3 | 0;
  var$1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = 4294967295;
  i64toi32_i32$5 = 4294967295;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$3 = var$1;
  i64toi32_i32$2 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$5 << i64toi32_i32$2 | 0;
   $21_1 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$2 | 0) - 1 | 0) & (i64toi32_i32$5 >>> (32 - i64toi32_i32$2 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$2 | 0) | 0;
   $21_1 = i64toi32_i32$5 << i64toi32_i32$2 | 0;
  }
  $15$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$1 = $15$hi;
  i64toi32_i32$0 = $21_1;
  i64toi32_i32$5 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$5 = i64toi32_i32$1 & i64toi32_i32$5 | 0;
  $17$hi = i64toi32_i32$5;
  i64toi32_i32$5 = var$1$hi;
  i64toi32_i32$5 = $17$hi;
  i64toi32_i32$1 = i64toi32_i32$0 & i64toi32_i32$3 | 0;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$3 = var$1;
  i64toi32_i32$2 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $22_1 = i64toi32_i32$5 >>> i64toi32_i32$2 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$5 >>> i64toi32_i32$2 | 0;
   $22_1 = (((1 << i64toi32_i32$2 | 0) - 1 | 0) & i64toi32_i32$5 | 0) << (32 - i64toi32_i32$2 | 0) | 0 | (i64toi32_i32$1 >>> i64toi32_i32$2 | 0) | 0;
  }
  $19$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $10$hi;
  i64toi32_i32$5 = $10_1;
  i64toi32_i32$1 = $19$hi;
  i64toi32_i32$3 = $22_1;
  i64toi32_i32$1 = i64toi32_i32$0 | i64toi32_i32$1 | 0;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$5 = i64toi32_i32$5 | i64toi32_i32$3 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$5 | 0;
 }
 
 function __wasm_rotr_i64(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, i64toi32_i32$5 = 0, i64toi32_i32$4 = 0, var$2$hi = 0, var$2 = 0, $19_1 = 0, $20_1 = 0, $21_1 = 0, $22_1 = 0, $6$hi = 0, $8$hi = 0, $10_1 = 0, $10$hi = 0, $15$hi = 0, $17$hi = 0, $19$hi = 0;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$2 = var$1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$1 = i64toi32_i32$0 & i64toi32_i32$1 | 0;
  i64toi32_i32$1 = i64toi32_i32$1;
  var$2 = i64toi32_i32$2 & i64toi32_i32$3 | 0;
  var$2$hi = i64toi32_i32$1;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$1 = 4294967295;
  i64toi32_i32$0 = 4294967295;
  i64toi32_i32$2 = var$2$hi;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = i64toi32_i32$0 << i64toi32_i32$4 | 0;
   $19_1 = 0;
  } else {
   i64toi32_i32$2 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$0 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$1 << i64toi32_i32$4 | 0) | 0;
   $19_1 = i64toi32_i32$0 << i64toi32_i32$4 | 0;
  }
  $6$hi = i64toi32_i32$2;
  i64toi32_i32$2 = var$0$hi;
  i64toi32_i32$2 = $6$hi;
  i64toi32_i32$1 = $19_1;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$0 = i64toi32_i32$2 & i64toi32_i32$0 | 0;
  $8$hi = i64toi32_i32$0;
  i64toi32_i32$0 = var$2$hi;
  i64toi32_i32$0 = $8$hi;
  i64toi32_i32$2 = i64toi32_i32$1 & i64toi32_i32$3 | 0;
  i64toi32_i32$1 = var$2$hi;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = 0;
   $20_1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $20_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  $10_1 = $20_1;
  $10$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = 0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = var$1$hi;
  i64toi32_i32$3 = var$1;
  i64toi32_i32$4 = i64toi32_i32$0 - i64toi32_i32$3 | 0;
  i64toi32_i32$5 = (i64toi32_i32$0 >>> 0 < i64toi32_i32$3 >>> 0) + i64toi32_i32$2 | 0;
  i64toi32_i32$5 = i64toi32_i32$1 - i64toi32_i32$5 | 0;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$1 = i64toi32_i32$4;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 63;
  i64toi32_i32$0 = i64toi32_i32$5 & i64toi32_i32$0 | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  var$1 = i64toi32_i32$1 & i64toi32_i32$3 | 0;
  var$1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = 4294967295;
  i64toi32_i32$5 = 4294967295;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$3 = var$1;
  i64toi32_i32$2 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = 0;
   $21_1 = i64toi32_i32$0 >>> i64toi32_i32$2 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$2 | 0;
   $21_1 = (((1 << i64toi32_i32$2 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$2 | 0) | 0 | (i64toi32_i32$5 >>> i64toi32_i32$2 | 0) | 0;
  }
  $15$hi = i64toi32_i32$1;
  i64toi32_i32$1 = var$0$hi;
  i64toi32_i32$1 = $15$hi;
  i64toi32_i32$0 = $21_1;
  i64toi32_i32$5 = var$0$hi;
  i64toi32_i32$3 = var$0;
  i64toi32_i32$5 = i64toi32_i32$1 & i64toi32_i32$5 | 0;
  $17$hi = i64toi32_i32$5;
  i64toi32_i32$5 = var$1$hi;
  i64toi32_i32$5 = $17$hi;
  i64toi32_i32$1 = i64toi32_i32$0 & i64toi32_i32$3 | 0;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$3 = var$1;
  i64toi32_i32$2 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = i64toi32_i32$1 << i64toi32_i32$2 | 0;
   $22_1 = 0;
  } else {
   i64toi32_i32$0 = ((1 << i64toi32_i32$2 | 0) - 1 | 0) & (i64toi32_i32$1 >>> (32 - i64toi32_i32$2 | 0) | 0) | 0 | (i64toi32_i32$5 << i64toi32_i32$2 | 0) | 0;
   $22_1 = i64toi32_i32$1 << i64toi32_i32$2 | 0;
  }
  $19$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $10$hi;
  i64toi32_i32$5 = $10_1;
  i64toi32_i32$1 = $19$hi;
  i64toi32_i32$3 = $22_1;
  i64toi32_i32$1 = i64toi32_i32$0 | i64toi32_i32$1 | 0;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$5 = i64toi32_i32$5 | i64toi32_i32$3 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$5 | 0;
 }
 
 function __wasm_ctz_i32(var$0) {
  var$0 = var$0 | 0;
  if (var$0) return 31 - Math_clz32((var$0 + 4294967295 | 0) ^ var$0 | 0) | 0 | 0;
  return 32 | 0;
 }
 
 return {
  add: $0, 
  sub: $1, 
  mul: $2, 
  div_s: $3, 
  div_u: $4, 
  rem_s: $5, 
  rem_u: $6, 
  and: $7, 
  or: $8, 
  xor: $9, 
  shl: $10, 
  shr_s: $11, 
  shr_u: $12, 
  rotl: $13, 
  rotr: $14, 
  clz: $15, 
  ctz: $16, 
  popcnt: $17, 
  eqz: $18, 
  eq: $19, 
  ne: $20, 
  lt_s: $21, 
  lt_u: $22, 
  le_s: $23, 
  le_u: $24, 
  gt_s: $25, 
  gt_u: $26, 
  ge_s: $27, 
  ge_u: $28
 };
}

const memasmFunc = new ArrayBuffer(65536);
const retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export const add = retasmFunc.add;
export const sub = retasmFunc.sub;
export const mul = retasmFunc.mul;
export const div_s = retasmFunc.div_s;
export const div_u = retasmFunc.div_u;
export const rem_s = retasmFunc.rem_s;
export const rem_u = retasmFunc.rem_u;
export const and = retasmFunc.and;
export const or = retasmFunc.or;
export const xor = retasmFunc.xor;
export const shl = retasmFunc.shl;
export const shr_s = retasmFunc.shr_s;
export const shr_u = retasmFunc.shr_u;
export const rotl = retasmFunc.rotl;
export const rotr = retasmFunc.rotr;
export const clz = retasmFunc.clz;
export const ctz = retasmFunc.ctz;
export const popcnt = retasmFunc.popcnt;
export const eqz = retasmFunc.eqz;
export const eq = retasmFunc.eq;
export const ne = retasmFunc.ne;
export const lt_s = retasmFunc.lt_s;
export const lt_u = retasmFunc.lt_u;
export const le_s = retasmFunc.le_s;
export const le_u = retasmFunc.le_u;
export const gt_s = retasmFunc.gt_s;
export const gt_u = retasmFunc.gt_u;
export const ge_s = retasmFunc.ge_s;
export const ge_u = retasmFunc.ge_u;
