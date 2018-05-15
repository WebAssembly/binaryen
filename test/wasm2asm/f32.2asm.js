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
 var i64toi32_i32$HIGH_BITS = 0;
 function $0(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return Math_fround(Math_fround(x + y));
 }
 
 function $1(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return Math_fround(Math_fround(x - y));
 }
 
 function $2(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return Math_fround(Math_fround(x * y));
 }
 
 function $3(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return Math_fround(Math_fround(x / y));
 }
 
 function $4(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(Math_sqrt(x)));
 }
 
 function $5(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return Math_fround(Math_fround(Math_min(x, y)));
 }
 
 function $6(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return Math_fround(Math_fround(Math_max(x, y)));
 }
 
 function $7(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(Math_ceil(x)));
 }
 
 function $8(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(Math_floor(x)));
 }
 
 function $9(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(__wasm_trunc_f32(Math_fround(x))));
 }
 
 function $10(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(__wasm_nearest_f32(Math_fround(x))));
 }
 
 function $11(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(Math_abs(x)));
 }
 
 function $12(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(-x));
 }
 
 function $13(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return Math_fround((HEAP32[0] = (HEAPF32[0] = x, HEAP32[0]) & 2147483647 | 0 | ((HEAPF32[0] = y, HEAP32[0]) & 2147483648 | 0) | 0, HEAPF32[0]));
 }
 
 function __wasm_nearest_f32($0) {
  $0 = Math_fround($0);
  var $2 = Math_fround(0), $1 = Math_fround(0), $3 = Math_fround(0), $34 = Math_fround(0), $32 = Math_fround(0), $4 = Math_fround(0), $28 = Math_fround(0);
  $1 = Math_fround(Math_ceil($0));
  $2 = Math_fround(Math_floor($0));
  $3 = Math_fround($0 - $2);
  if ($3 < Math_fround(.5)) $34 = $2; else {
   if ($3 > Math_fround(.5)) $32 = $1; else {
    $4 = Math_fround($2 / Math_fround(2.0));
    if (Math_fround($4 - Math_fround(Math_floor($4))) == Math_fround(0.0)) $28 = $2; else $28 = $1;
    $32 = $28;
   }
   $34 = $32;
  }
  return Math_fround($34);
 }
 
 function __wasm_trunc_f32($0) {
  $0 = Math_fround($0);
  var $7 = Math_fround(0);
  if ($0 < Math_fround(0.0)) $7 = Math_fround(Math_ceil($0)); else $7 = Math_fround(Math_floor($0));
  return Math_fround($7);
 }
 
 return {
  add: $0, 
  sub: $1, 
  mul: $2, 
  div: $3, 
  sqrt: $4, 
  min: $5, 
  max: $6, 
  ceil: $7, 
  floor: $8, 
  trunc: $9, 
  nearest: $10, 
  abs: $11, 
  neg: $12, 
  copysign: $13
 };
}

