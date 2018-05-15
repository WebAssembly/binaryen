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
 function dummy() {
  
 }
 
 function $1($0, $0$hi, $1, $1$hi, $2, $2$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  $1 = $1 | 0;
  $1$hi = $1$hi | 0;
  $2 = $2 | 0;
  $2$hi = $2$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, i64toi32_i32$4 = 0, $5$hi = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = $1$hi;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$1 = $1$hi;
  i64toi32_i32$3 = $1;
  i64toi32_i32$4 = __wasm_rotl_i64($0 | 0, i64toi32_i32$0 | 0, i64toi32_i32$3 & 63 | 0 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $5$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $2$hi;
  i64toi32_i32$1 = $5$hi;
  i64toi32_i32$0 = i64toi32_i32$4;
  i64toi32_i32$3 = $2;
  return (i64toi32_i32$0 | 0) == (i64toi32_i32$3 | 0) & (i64toi32_i32$1 | 0) == ($2$hi | 0) | 0 | 0;
 }
 
 function $2($0, $0$hi, $1, $1$hi, $2, $2$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  $1 = $1 | 0;
  $1$hi = $1$hi | 0;
  $2 = $2 | 0;
  $2$hi = $2$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, i64toi32_i32$4 = 0, $5$hi = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = $1$hi;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$1 = $1$hi;
  i64toi32_i32$3 = $1;
  i64toi32_i32$4 = __wasm_rotr_i64($0 | 0, i64toi32_i32$0 | 0, i64toi32_i32$3 & 63 | 0 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $5$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $2$hi;
  i64toi32_i32$1 = $5$hi;
  i64toi32_i32$0 = i64toi32_i32$4;
  i64toi32_i32$3 = $2;
  return (i64toi32_i32$0 | 0) == (i64toi32_i32$3 | 0) & (i64toi32_i32$1 | 0) == ($2$hi | 0) | 0 | 0;
 }
 
 function __wasm_rotl_i64($0, $1, $2) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2 = $2 | 0;
  var $3 = 0, $4 = 0, $5 = 0;
  if (($2 | 0) == (32 | 0)) {
   i64toi32_i32$HIGH_BITS = $0;
   $4 = $1;
  } else {
   if ($2 >>> 0 >= 32 >>> 0) {
    $2 = $2 - 32 | 0;
    $3 = 32 - $2 | 0;
    i64toi32_i32$HIGH_BITS = $0 << $2 | 0 | ($1 >>> $3 | 0) | 0;
    $5 = $1 << $2 | 0 | ($0 >>> $3 | 0) | 0;
   } else {
    $3 = 32 - $2 | 0;
    i64toi32_i32$HIGH_BITS = $1 << $2 | 0 | ($0 >>> $3 | 0) | 0;
    $5 = $0 << $2 | 0 | ($1 >>> $3 | 0) | 0;
   }
   $4 = $5;
  }
  return $4 | 0;
 }
 
 function __wasm_rotr_i64($0, $1, $2) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2 = $2 | 0;
  var $3 = 0, $4 = 0, $5 = 0;
  if (($2 | 0) == (32 | 0)) {
   i64toi32_i32$HIGH_BITS = $0;
   $4 = $1;
  } else {
   if ($2 >>> 0 >= 32 >>> 0) {
    $2 = $2 - 32 | 0;
    $3 = 32 - $2 | 0;
    i64toi32_i32$HIGH_BITS = $0 >>> $2 | 0 | ($1 << $3 | 0) | 0;
    $5 = $1 >>> $2 | 0 | ($0 << $3 | 0) | 0;
   } else {
    $3 = 32 - $2 | 0;
    i64toi32_i32$HIGH_BITS = $1 >>> $2 | 0 | ($0 << $3 | 0) | 0;
    $5 = $0 >>> $2 | 0 | ($1 << $3 | 0) | 0;
   }
   $4 = $5;
  }
  return $4 | 0;
 }
 
 return {
  rotl: $1, 
  rotr: $2
 };
}

