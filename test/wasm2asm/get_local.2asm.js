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
 var i64toi32_i32$HIGH_BITS = 0;
 function $0() {
  var $0 = 0;
  return $0 | 0;
 }
 
 function $1() {
  var i64toi32_i32$0 = 0, $0$hi = 0, $0 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return $0 | 0;
 }
 
 function $2() {
  var $0 = Math_fround(0);
  return Math_fround($0);
 }
 
 function $3() {
  var $0 = 0.0;
  return +$0;
 }
 
 function $4($0) {
  $0 = $0 | 0;
  return $0 | 0;
 }
 
 function $5($0, $0$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return $0 | 0;
 }
 
 function $6($0) {
  $0 = Math_fround($0);
  return Math_fround($0);
 }
 
 function $7($0) {
  $0 = +$0;
  return +$0;
 }
 
 function $8($0, $0$hi, $1, $2, $3, $4) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  $1 = Math_fround($1);
  $2 = +$2;
  $3 = $3 | 0;
  $4 = $4 | 0;
  var i64toi32_i32$0 = 0, $5 = Math_fround(0), $6$hi = 0, $6 = 0, $7$hi = 0, $7 = 0, $8 = 0.0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = $6$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = $7$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
 }
 
 function $9($0, $0$hi, $1, $2, $3, $4) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  $1 = Math_fround($1);
  $2 = +$2;
  $3 = $3 | 0;
  $4 = $4 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, $6$hi = 0, $10 = 0.0, $21 = 0.0, $7$hi = 0, $7 = 0;
  i64toi32_i32$0 = 0;
  $6$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = $0;
  $10 = +(i64toi32_i32$1 >>> 0) + 4294967296.0 * +(i64toi32_i32$0 >>> 0);
  i64toi32_i32$0 = $6$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = 6;
  $21 = +(i64toi32_i32$1 >>> 0) + 4294967296.0 * +(i64toi32_i32$0 >>> 0);
  i64toi32_i32$0 = $7$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = $7;
  return +($10 + (+$1 + ($2 + (+($3 >>> 0) + (+($4 | 0) + (+Math_fround(5.5) + ($21 + (+(i64toi32_i32$1 >>> 0) + 4294967296.0 * +(i64toi32_i32$0 >>> 0) + 8.0))))))));
 }
 
 return {
  type_local_i32: $0, 
  type_local_i64: $1, 
  type_local_f32: $2, 
  type_local_f64: $3, 
  type_param_i32: $4, 
  type_param_i64: $5, 
  type_param_f32: $6, 
  type_param_f64: $7, 
  type_mixed: $8, 
  read: $9
 };
}

