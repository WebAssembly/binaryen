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
 function $0(x, y) {
  x = x | 0;
  y = y | 0;
  var $2 = 0, $3 = 0, $4 = 0, wasm2asm_i32$0 = 0;
  return x + y | 0 | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 function $1(x, y) {
  x = x | 0;
  y = y | 0;
  var $2 = 0, $3 = 0, $4 = 0, wasm2asm_i32$0 = 0;
  return x - y | 0 | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 function $2(x, y) {
  x = x | 0;
  y = y | 0;
  var $2 = 0, $3 = 0, $4 = 0, wasm2asm_i32$0 = 0;
  return Math_imul(x, y) | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 function $3(x, y) {
  x = x | 0;
  y = y | 0;
  var $2 = 0, $3 = 0, $4 = 0, wasm2asm_i32$0 = 0;
  return (x | 0) / (y | 0) | 0 | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 function $4(x, y) {
  x = x | 0;
  y = y | 0;
  var $2 = 0, $3 = 0, $4 = 0, wasm2asm_i32$0 = 0;
  return (x >>> 0) / (y >>> 0) | 0 | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 function $5(x, y) {
  x = x | 0;
  y = y | 0;
  var $2 = 0, $3 = 0, $4 = 0, wasm2asm_i32$0 = 0;
  return (x | 0) % (y | 0) | 0 | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 function $6(x, y) {
  x = x | 0;
  y = y | 0;
  var $2 = 0, $3 = 0, $4 = 0, wasm2asm_i32$0 = 0;
  return (x >>> 0) % (y >>> 0) | 0 | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 function $7(x, y) {
  x = x | 0;
  y = y | 0;
  var $2 = 0, $3 = 0, $4 = 0, wasm2asm_i32$0 = 0;
  return x & y | 0 | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 function $8(x, y) {
  x = x | 0;
  y = y | 0;
  var $2 = 0, $3 = 0, $4 = 0, wasm2asm_i32$0 = 0;
  return x | y | 0 | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 function $9(x, y) {
  x = x | 0;
  y = y | 0;
  var $2 = 0, $3 = 0, $4 = 0, wasm2asm_i32$0 = 0;
  return x ^ y | 0 | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 function $10(x, y) {
  x = x | 0;
  y = y | 0;
  var $2 = 0, $3 = 0, $4 = 0, wasm2asm_i32$0 = 0;
  return x << y | 0 | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 function $11(x, y) {
  x = x | 0;
  y = y | 0;
  var $2 = 0, $3 = 0, $4 = 0, wasm2asm_i32$0 = 0;
  return x >> y | 0 | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 function $12(x, y) {
  x = x | 0;
  y = y | 0;
  var $2 = 0, $3 = 0, $4 = 0, wasm2asm_i32$0 = 0;
  return x >>> y | 0 | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 function $13(x, y) {
  x = x | 0;
  y = y | 0;
  var $2 = 0, $3 = 0, $4 = 0, wasm2asm_i32$0 = 0;
  return __wasm_rotl_i32(x, y) | 0 | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 function $14(x, y) {
  x = x | 0;
  y = y | 0;
  var $2 = 0, $3 = 0, $4 = 0, wasm2asm_i32$0 = 0;
  return __wasm_rotr_i32(x, y) | 0 | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 function $15(x) {
  x = x | 0;
  var $1 = 0, $2 = 0, wasm2asm_i32$0 = 0;
  return Math_clz32(x) | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 function $16(x) {
  x = x | 0;
  var $1 = 0, $2 = 0, wasm2asm_i32$0 = 0;
  return __wasm_ctz_i32(x) | 0 | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 function $17(x) {
  x = x | 0;
  var $1 = 0, $2 = 0, wasm2asm_i32$0 = 0;
  return __wasm_popcnt_i32(x) | 0 | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 function $18(x) {
  x = x | 0;
  var $1 = 0, $2 = 0, wasm2asm_i32$0 = 0;
  return (x | 0) == (0 | 0) | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 function $19(x, y) {
  x = x | 0;
  y = y | 0;
  var $2 = 0, $3 = 0, $4 = 0, wasm2asm_i32$0 = 0;
  return (x | 0) == (y | 0) | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 function $20(x, y) {
  x = x | 0;
  y = y | 0;
  var $2 = 0, $3 = 0, $4 = 0, wasm2asm_i32$0 = 0;
  return (x | 0) != (y | 0) | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 function $21(x, y) {
  x = x | 0;
  y = y | 0;
  var $2 = 0, $3 = 0, $4 = 0, wasm2asm_i32$0 = 0;
  return (x | 0) < (y | 0) | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 function $22(x, y) {
  x = x | 0;
  y = y | 0;
  var $2 = 0, $3 = 0, $4 = 0, wasm2asm_i32$0 = 0;
  return x >>> 0 < y >>> 0 | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 function $23(x, y) {
  x = x | 0;
  y = y | 0;
  var $2 = 0, $3 = 0, $4 = 0, wasm2asm_i32$0 = 0;
  return (x | 0) <= (y | 0) | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 function $24(x, y) {
  x = x | 0;
  y = y | 0;
  var $2 = 0, $3 = 0, $4 = 0, wasm2asm_i32$0 = 0;
  return x >>> 0 <= y >>> 0 | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 function $25(x, y) {
  x = x | 0;
  y = y | 0;
  var $2 = 0, $3 = 0, $4 = 0, wasm2asm_i32$0 = 0;
  return (x | 0) > (y | 0) | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 function $26(x, y) {
  x = x | 0;
  y = y | 0;
  var $2 = 0, $3 = 0, $4 = 0, wasm2asm_i32$0 = 0;
  return x >>> 0 > y >>> 0 | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 function $27(x, y) {
  x = x | 0;
  y = y | 0;
  var $2 = 0, $3 = 0, $4 = 0, wasm2asm_i32$0 = 0;
  return (x | 0) >= (y | 0) | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 function $28(x, y) {
  x = x | 0;
  y = y | 0;
  var $2 = 0, $3 = 0, $4 = 0, wasm2asm_i32$0 = 0;
  return x >>> 0 >= y >>> 0 | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 function __wasm_ctz_i32(x) {
  x = x | 0;
  var $1 = 0, $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0;
  if ((x | 0) == (0 | 0)) $9 = 32; else $9 = 31 - Math_clz32(x ^ (x - 1 | 0) | 0) | 0;
  return $9 | 0;
 }
 
 function __wasm_popcnt_i32(x) {
  x = x | 0;
  var count = 0, $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0, $13 = 0, $14 = 0, $15 = 0;
  count = 0;
  b : {
   l : do {
    $5 = count;
    if ((x | 0) == (0 | 0)) break b;
    x = x & (x - 1 | 0) | 0;
    count = count + 1 | 0;
    continue l;
    break l;
   } while (1);
  };
  return $5 | 0;
 }
 
 function __wasm_rotl_i32(x, k) {
  x = x | 0;
  k = k | 0;
  var $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0, $13 = 0, $14 = 0, $15 = 0, $16 = 0, $17 = 0, $18 = 0, $19 = 0, $20 = 0, wasm2asm_i32$0 = 0;
  return ((4294967295 >>> (k & 31 | 0) | 0) & x | 0) << (k & 31 | 0) | 0 | (((4294967295 << (32 - (k & 31 | 0) | 0) | 0) & x | 0) >>> (32 - (k & 31 | 0) | 0) | 0) | 0 | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 function __wasm_rotr_i32(x, k) {
  x = x | 0;
  k = k | 0;
  var $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0, $13 = 0, $14 = 0, $15 = 0, $16 = 0, $17 = 0, $18 = 0, $19 = 0, $20 = 0, wasm2asm_i32$0 = 0;
  return ((4294967295 << (k & 31 | 0) | 0) & x | 0) >>> (k & 31 | 0) | 0 | (((4294967295 >>> (32 - (k & 31 | 0) | 0) | 0) & x | 0) << (32 - (k & 31 | 0) | 0) | 0) | 0 | 0;
  return wasm2asm_i32$0 | 0;
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

