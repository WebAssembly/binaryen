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
 function const_i32() {
  return 306 | 0;
 }
 
 function const_i64() {
  i64toi32_i32$HIGH_BITS = 0;
  return 356 | 0;
 }
 
 function const_f32() {
  return Math_fround(Math_fround(3890.0));
 }
 
 function const_f64() {
  return +(3940.0);
 }
 
 function id_i32($0) {
  $0 = $0 | 0;
  return $0 | 0;
 }
 
 function id_i64($0, $0$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return $0 | 0;
 }
 
 function id_f32($0) {
  $0 = Math_fround($0);
  return Math_fround($0);
 }
 
 function id_f64($0) {
  $0 = +$0;
  return +$0;
 }
 
 function f32_i32($0, $1) {
  $0 = Math_fround($0);
  $1 = $1 | 0;
  return $1 | 0;
 }
 
 function i32_i64($0, $1, $1$hi) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $1$hi = $1$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = $1$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return $1 | 0;
 }
 
 function f64_f32($0, $1) {
  $0 = +$0;
  $1 = Math_fround($1);
  return Math_fround($1);
 }
 
 function i64_f64($0, $0$hi, $1) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  $1 = +$1;
  return +$1;
 }
 
 function $12() {
  return const_i32() | 0 | 0;
 }
 
 function $13() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = const_i64() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $14() {
  return Math_fround(Math_fround(const_f32()));
 }
 
 function $15() {
  return +(+const_f64());
 }
 
 function $16() {
  return id_i32(32 | 0) | 0 | 0;
 }
 
 function $17() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$0 = id_i64(64 | 0, i64toi32_i32$0 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $18() {
  return Math_fround(Math_fround(id_f32(Math_fround(Math_fround(1.3200000524520874)))));
 }
 
 function $19() {
  return +(+id_f64(+(1.64)));
 }
 
 function $20() {
  return f32_i32(Math_fround(Math_fround(32.099998474121094)), 32 | 0) | 0 | 0;
 }
 
 function $21() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$0 = i32_i64(32 | 0, 64 | 0, i64toi32_i32$0 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $22() {
  return Math_fround(Math_fround(f64_f32(+(64.0), Math_fround(Math_fround(32.0)))));
 }
 
 function $23() {
  return +(+i64_f64(64 | 0, 0 | 0, +(64.1)));
 }
 
 function fac($0, $0$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$2 = 0, i64toi32_i32$5 = 0, $8 = 0, $8$hi = 0, i64toi32_i32$3 = 0, $6 = 0, $6$hi = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  if (($0 | i64toi32_i32$0 | 0 | 0) == (0 | 0)) {
   i64toi32_i32$0 = 0;
   $8 = 1;
   $8$hi = i64toi32_i32$0;
  } else {
   i64toi32_i32$0 = $0$hi;
   i64toi32_i32$0 = i64toi32_i32$0;
   i64toi32_i32$0 = i64toi32_i32$0;
   i64toi32_i32$2 = $0;
   i64toi32_i32$3 = 1;
   i64toi32_i32$5 = (i64toi32_i32$2 >>> 0 < i64toi32_i32$3 >>> 0) + 0 | 0;
   i64toi32_i32$5 = i64toi32_i32$0 - i64toi32_i32$5 | 0;
   i64toi32_i32$5 = i64toi32_i32$5;
   i64toi32_i32$5 = fac(i64toi32_i32$2 - i64toi32_i32$3 | 0 | 0, i64toi32_i32$5 | 0) | 0;
   i64toi32_i32$2 = i64toi32_i32$HIGH_BITS;
   $6 = i64toi32_i32$5;
   $6$hi = i64toi32_i32$2;
   i64toi32_i32$2 = i64toi32_i32$0;
   i64toi32_i32$5 = $6$hi;
   i64toi32_i32$5 = __wasm_i64_mul($0 | 0, i64toi32_i32$0 | 0, $6 | 0, i64toi32_i32$5 | 0) | 0;
   i64toi32_i32$2 = i64toi32_i32$HIGH_BITS;
   i64toi32_i32$2 = i64toi32_i32$2;
   $8 = i64toi32_i32$5;
   $8$hi = i64toi32_i32$2;
  }
  i64toi32_i32$2 = $8$hi;
  i64toi32_i32$2 = i64toi32_i32$2;
  i64toi32_i32$5 = $8;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$2;
  return i64toi32_i32$5 | 0;
 }
 
 function fac_acc($0, $0$hi, $1, $1$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  $1 = $1 | 0;
  $1$hi = $1$hi | 0;
  var i64toi32_i32$5 = 0, i64toi32_i32$0 = 0, i64toi32_i32$2 = 0, $11 = 0, $11$hi = 0, i64toi32_i32$3 = 0, $6 = 0, $6$hi = 0, $9 = 0, $9$hi = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  if (($0 | i64toi32_i32$0 | 0 | 0) == (0 | 0)) {
   i64toi32_i32$0 = $1$hi;
   i64toi32_i32$0 = i64toi32_i32$0;
   $11 = $1;
   $11$hi = i64toi32_i32$0;
  } else {
   i64toi32_i32$0 = $0$hi;
   i64toi32_i32$0 = i64toi32_i32$0;
   i64toi32_i32$2 = $0;
   i64toi32_i32$3 = 1;
   i64toi32_i32$5 = (i64toi32_i32$2 >>> 0 < i64toi32_i32$3 >>> 0) + 0 | 0;
   i64toi32_i32$5 = i64toi32_i32$0 - i64toi32_i32$5 | 0;
   $6 = i64toi32_i32$2 - i64toi32_i32$3 | 0;
   $6$hi = i64toi32_i32$5;
   i64toi32_i32$5 = i64toi32_i32$0;
   i64toi32_i32$5 = $1$hi;
   i64toi32_i32$5 = i64toi32_i32$0;
   i64toi32_i32$2 = $1$hi;
   i64toi32_i32$2 = __wasm_i64_mul($0 | 0, i64toi32_i32$5 | 0, $1 | 0, i64toi32_i32$2 | 0) | 0;
   i64toi32_i32$5 = i64toi32_i32$HIGH_BITS;
   $9 = i64toi32_i32$2;
   $9$hi = i64toi32_i32$5;
   i64toi32_i32$5 = $6$hi;
   i64toi32_i32$2 = $9$hi;
   i64toi32_i32$2 = fac_acc($6 | 0, i64toi32_i32$5 | 0, $9 | 0, i64toi32_i32$2 | 0) | 0;
   i64toi32_i32$5 = i64toi32_i32$HIGH_BITS;
   i64toi32_i32$5 = i64toi32_i32$5;
   $11 = i64toi32_i32$2;
   $11$hi = i64toi32_i32$5;
  }
  i64toi32_i32$5 = $11$hi;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$2 = $11;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$5;
  return i64toi32_i32$2 | 0;
 }
 
 function fib($0, $0$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, i64toi32_i32$5 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$6 = 0, $10 = 0, $10$hi = 0, $5 = 0, $5$hi = 0, $8 = 0, $8$hi = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$2 = $0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 1;
  if (i64toi32_i32$0 >>> 0 < i64toi32_i32$1 >>> 0 | ((i64toi32_i32$0 | 0) == (i64toi32_i32$1 | 0) & i64toi32_i32$2 >>> 0 <= i64toi32_i32$3 >>> 0 | 0) | 0) {
   i64toi32_i32$2 = 0;
   $10 = 1;
   $10$hi = i64toi32_i32$2;
  } else {
   i64toi32_i32$2 = $0$hi;
   i64toi32_i32$2 = i64toi32_i32$2;
   i64toi32_i32$3 = $0;
   i64toi32_i32$0 = 0;
   i64toi32_i32$1 = 2;
   i64toi32_i32$4 = i64toi32_i32$3 - i64toi32_i32$1 | 0;
   i64toi32_i32$6 = i64toi32_i32$3 >>> 0 < i64toi32_i32$1 >>> 0;
   i64toi32_i32$5 = i64toi32_i32$6 + i64toi32_i32$0 | 0;
   i64toi32_i32$5 = i64toi32_i32$2 - i64toi32_i32$5 | 0;
   i64toi32_i32$5 = i64toi32_i32$5;
   i64toi32_i32$5 = fib(i64toi32_i32$4 | 0, i64toi32_i32$5 | 0) | 0;
   i64toi32_i32$3 = i64toi32_i32$HIGH_BITS;
   $5 = i64toi32_i32$5;
   $5$hi = i64toi32_i32$3;
   i64toi32_i32$3 = i64toi32_i32$2;
   i64toi32_i32$3 = i64toi32_i32$2;
   i64toi32_i32$2 = $0;
   i64toi32_i32$5 = 0;
   i64toi32_i32$1 = 1;
   i64toi32_i32$0 = i64toi32_i32$2 - i64toi32_i32$1 | 0;
   i64toi32_i32$6 = i64toi32_i32$2 >>> 0 < i64toi32_i32$1 >>> 0;
   i64toi32_i32$4 = i64toi32_i32$6 + i64toi32_i32$5 | 0;
   i64toi32_i32$4 = i64toi32_i32$3 - i64toi32_i32$4 | 0;
   i64toi32_i32$4 = i64toi32_i32$4;
   i64toi32_i32$4 = fib(i64toi32_i32$0 | 0, i64toi32_i32$4 | 0) | 0;
   i64toi32_i32$2 = i64toi32_i32$HIGH_BITS;
   $8 = i64toi32_i32$4;
   $8$hi = i64toi32_i32$2;
   i64toi32_i32$2 = $5$hi;
   i64toi32_i32$3 = $5;
   i64toi32_i32$4 = $8$hi;
   i64toi32_i32$1 = $8;
   i64toi32_i32$5 = i64toi32_i32$3 + i64toi32_i32$1 | 0;
   i64toi32_i32$0 = i64toi32_i32$2 + i64toi32_i32$4 | 0;
   if (i64toi32_i32$5 >>> 0 < i64toi32_i32$1 >>> 0) i64toi32_i32$0 = i64toi32_i32$0 + 1 | 0;
   i64toi32_i32$0 = i64toi32_i32$0;
   $10 = i64toi32_i32$5;
   $10$hi = i64toi32_i32$0;
  }
  i64toi32_i32$0 = $10$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$3 = $10;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$3 | 0;
 }
 
 function even($0, $0$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$5 = 0, $6 = 0, i64toi32_i32$3 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  if (($0 | i64toi32_i32$0 | 0 | 0) == (0 | 0)) $6 = 44; else {
   i64toi32_i32$0 = $0$hi;
   i64toi32_i32$0 = i64toi32_i32$0;
   i64toi32_i32$3 = 1;
   i64toi32_i32$5 = ($0 >>> 0 < i64toi32_i32$3 >>> 0) + 0 | 0;
   i64toi32_i32$5 = i64toi32_i32$0 - i64toi32_i32$5 | 0;
   i64toi32_i32$5 = i64toi32_i32$5;
   $6 = odd($0 - i64toi32_i32$3 | 0 | 0, i64toi32_i32$5 | 0) | 0;
  }
  return $6 | 0;
 }
 
 function odd($0, $0$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$5 = 0, $6 = 0, i64toi32_i32$3 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  if (($0 | i64toi32_i32$0 | 0 | 0) == (0 | 0)) $6 = 99; else {
   i64toi32_i32$0 = $0$hi;
   i64toi32_i32$0 = i64toi32_i32$0;
   i64toi32_i32$3 = 1;
   i64toi32_i32$5 = ($0 >>> 0 < i64toi32_i32$3 >>> 0) + 0 | 0;
   i64toi32_i32$5 = i64toi32_i32$0 - i64toi32_i32$5 | 0;
   i64toi32_i32$5 = i64toi32_i32$5;
   $6 = even($0 - i64toi32_i32$3 | 0 | 0, i64toi32_i32$5 | 0) | 0;
  }
  return $6 | 0;
 }
 
 function runaway() {
  runaway();
 }
 
 function mutual_runaway1() {
  mutual_runaway2();
 }
 
 function mutual_runaway2() {
  mutual_runaway1();
 }
 
 function _ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$2 = 0, var$2 = 0, i64toi32_i32$3 = 0, var$3 = 0, var$4 = 0, var$5 = 0, $21_1 = 0, $22_1 = 0, var$6 = 0, $24 = 0, $17_1 = 0, $18_1 = 0, $23_1 = 0, $29 = 0, $45 = 0, $56$hi = 0, $62$hi = 0;
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
   $24 = 0;
  } else {
   i64toi32_i32$0 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$1 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$2 << i64toi32_i32$4 | 0) | 0;
   $24 = i64toi32_i32$1 << i64toi32_i32$4 | 0;
  }
  $56$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  $62$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $56$hi;
  i64toi32_i32$2 = $24;
  i64toi32_i32$1 = $62$hi;
  i64toi32_i32$3 = var$2 << 16 | 0 | (var$6 & 65535 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$0 | i64toi32_i32$1 | 0;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$2 | i64toi32_i32$3 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$2 | 0;
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
 
 return {
  type_i32: $12, 
  type_i64: $13, 
  type_f32: $14, 
  type_f64: $15, 
  type_first_i32: $16, 
  type_first_i64: $17, 
  type_first_f32: $18, 
  type_first_f64: $19, 
  type_second_i32: $20, 
  type_second_i64: $21, 
  type_second_f32: $22, 
  type_second_f64: $23, 
  fac: fac, 
  fac_acc: fac_acc, 
  fib: fib, 
  even: even, 
  odd: odd, 
  runaway: runaway, 
  mutual_runaway: mutual_runaway1
 };
}

const memasmFunc = new ArrayBuffer(65536);
const retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export const type_i32 = retasmFunc.type_i32;
export const type_i64 = retasmFunc.type_i64;
export const type_f32 = retasmFunc.type_f32;
export const type_f64 = retasmFunc.type_f64;
export const type_first_i32 = retasmFunc.type_first_i32;
export const type_first_i64 = retasmFunc.type_first_i64;
export const type_first_f32 = retasmFunc.type_first_f32;
export const type_first_f64 = retasmFunc.type_first_f64;
export const type_second_i32 = retasmFunc.type_second_i32;
export const type_second_i64 = retasmFunc.type_second_i64;
export const type_second_f32 = retasmFunc.type_second_f32;
export const type_second_f64 = retasmFunc.type_second_f64;
export const fac = retasmFunc.fac;
export const fac_acc = retasmFunc.fac_acc;
export const fib = retasmFunc.fib;
export const even = retasmFunc.even;
export const odd = retasmFunc.odd;
export const runaway = retasmFunc.runaway;
export const mutual_runaway = retasmFunc.mutual_runaway;
