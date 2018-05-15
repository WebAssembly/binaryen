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
  x = +x;
  y = +y;
  return +(x + y);
 }
 
 function $1(x, y) {
  x = +x;
  y = +y;
  return +(x - y);
 }
 
 function $2(x, y) {
  x = +x;
  y = +y;
  return +(x * y);
 }
 
 function $3(x, y) {
  x = +x;
  y = +y;
  return +(x / y);
 }
 
 function $4(x) {
  x = +x;
  return +Math_sqrt(x);
 }
 
 function $5(x, y) {
  x = +x;
  y = +y;
  return +Math_min(x, y);
 }
 
 function $6(x, y) {
  x = +x;
  y = +y;
  return +Math_max(x, y);
 }
 
 function $7(x) {
  x = +x;
  return +Math_ceil(x);
 }
 
 function $8(x) {
  x = +x;
  return +Math_floor(x);
 }
 
 function $9(x) {
  x = +x;
  return +(+__wasm_trunc_f64(+x));
 }
 
 function $10(x) {
  x = +x;
  return +(+__wasm_nearest_f64(+x));
 }
 
 function $11(x) {
  x = +x;
  return +Math_abs(x);
 }
 
 function $12(x) {
  x = +x;
  return +-x;
 }
 
 function $13(x, y) {
  x = +x;
  y = +y;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, $4 = 0, $4$hi = 0, $7 = 0, $7$hi = 0;
  HEAPF64[0 >> 3] = x;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$2 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$1 = 2147483647;
  i64toi32_i32$3 = 4294967295;
  i64toi32_i32$1 = i64toi32_i32$0 & i64toi32_i32$1 | 0;
  $4 = i64toi32_i32$2 & i64toi32_i32$3 | 0;
  $4$hi = i64toi32_i32$1;
  HEAPF64[0 >> 3] = y;
  i64toi32_i32$1 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$0 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$2 = 2147483648;
  i64toi32_i32$3 = 0;
  i64toi32_i32$2 = i64toi32_i32$1 & i64toi32_i32$2 | 0;
  $7 = i64toi32_i32$0 & i64toi32_i32$3 | 0;
  $7$hi = i64toi32_i32$2;
  i64toi32_i32$2 = $4$hi;
  i64toi32_i32$1 = $4;
  i64toi32_i32$0 = $7$hi;
  i64toi32_i32$3 = $7;
  i64toi32_i32$0 = i64toi32_i32$2 | i64toi32_i32$0 | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  HEAP32[0 >> 2] = i64toi32_i32$1 | i64toi32_i32$3 | 0;
  HEAP32[(0 + 4 | 0) >> 2] = i64toi32_i32$0;
  return +(+HEAPF64[0 >> 3]);
 }
 
 function __wasm_nearest_f64($0) {
  $0 = +$0;
  var $2 = 0.0, $1 = 0.0, $3 = 0.0, $34 = 0.0, $32 = 0.0, $4 = 0.0, $28 = 0.0;
  $1 = Math_ceil($0);
  $2 = Math_floor($0);
  $3 = $0 - $2;
  if ($3 < .5) $34 = $2; else {
   if ($3 > .5) $32 = $1; else {
    $4 = $2 / 2.0;
    if ($4 - Math_floor($4) == 0.0) $28 = $2; else $28 = $1;
    $32 = $28;
   }
   $34 = $32;
  }
  return +$34;
 }
 
 function __wasm_trunc_f64($0) {
  $0 = +$0;
  var $7 = 0.0;
  if ($0 < 0.0) $7 = Math_ceil($0); else $7 = Math_floor($0);
  return +$7;
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

