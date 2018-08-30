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
 function $0() {
  return 0 | 0;
 }
 
 function $1() {
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return 0 | 0;
 }
 
 function $2() {
  return Math_fround(Math_fround(0.0));
 }
 
 function $3() {
  return +(0.0);
 }
 
 function $4($0_1) {
  $0_1 = $0_1 | 0;
  return 10 | 0;
 }
 
 function $5($0_1, $0$hi) {
  $0_1 = $0_1 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return 11 | 0;
 }
 
 function $6($0_1) {
  $0_1 = Math_fround($0_1);
  return Math_fround(Math_fround(11.100000381469727));
 }
 
 function $7($0_1) {
  $0_1 = +$0_1;
  return +(12.2);
 }
 
 function $8($0_1, $0$hi, $1_1, $2_1, $3_1, $4_1) {
  $0_1 = $0_1 | 0;
  $0$hi = $0$hi | 0;
  $1_1 = Math_fround($1_1);
  $2_1 = +$2_1;
  $3_1 = $3_1 | 0;
  $4_1 = $4_1 | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = i64toi32_i32$0;
 }
 
 function $9($0_1, $0$hi, $1_1, $2_1, $3_1, $4_1) {
  $0_1 = $0_1 | 0;
  $0$hi = $0$hi | 0;
  $1_1 = Math_fround($1_1);
  $2_1 = +$2_1;
  $3_1 = $3_1 | 0;
  $4_1 = $4_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0.0, $5_1 = Math_fround(0), $6_1 = 0, $8_1 = 0.0, $17 = 0, $18 = 0, $6$hi = 0, $16 = 0.0, $27 = 0.0, $7$hi = 0, $7_1 = 0;
  $1_1 = Math_fround(-.30000001192092896);
  $3_1 = 40;
  $4_1 = 4294967289;
  $5_1 = Math_fround(5.5);
  i64toi32_i32$0 = 0;
  $6_1 = 6;
  $6$hi = i64toi32_i32$0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = i64toi32_i32$0;
  $8_1 = 8.0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = $0_1;
  $16 = +(i64toi32_i32$1 >>> 0) + 4294967296.0 * +(i64toi32_i32$0 >>> 0);
  i64toi32_i32$0 = $6$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = $6_1;
  $27 = +(i64toi32_i32$1 >>> 0) + 4294967296.0 * +(i64toi32_i32$0 >>> 0);
  i64toi32_i32$0 = $7$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = $7_1;
  i64toi32_i32$3 = $16 + (+$1_1 + ($2_1 + (+($3_1 >>> 0) + (+($4_1 | 0) + (+$5_1 + ($27 + (+(i64toi32_i32$1 >>> 0) + 4294967296.0 * +(i64toi32_i32$0 >>> 0) + $8_1)))))));
  if (Math_abs(i64toi32_i32$3) >= 1.0) {
   if (i64toi32_i32$3 > 0.0) $17 = ~~Math_min(Math_floor(i64toi32_i32$3 / 4294967296.0), 4294967296.0 - 1.0) >>> 0; else $17 = ~~Math_ceil((i64toi32_i32$3 - +(~~i64toi32_i32$3 >>> 0 >>> 0)) / 4294967296.0) >>> 0;
   $18 = $17;
  } else $18 = 0;
  i64toi32_i32$0 = $18;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = ~~i64toi32_i32$3 >>> 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $10($0_1, $0$hi, $1_1, $2_1, $3_1, $4_1) {
  $0_1 = $0_1 | 0;
  $0$hi = $0$hi | 0;
  $1_1 = Math_fround($1_1);
  $2_1 = +$2_1;
  $3_1 = $3_1 | 0;
  $4_1 = $4_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, $10_1 = 0.0, $21 = 0.0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = 1;
  $10_1 = +(i64toi32_i32$1 >>> 0) + 4294967296.0 * +(i64toi32_i32$0 >>> 0);
  i64toi32_i32$0 = 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = 6;
  $21 = +(i64toi32_i32$1 >>> 0) + 4294967296.0 * +(i64toi32_i32$0 >>> 0);
  i64toi32_i32$0 = 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = 0;
  return +($10_1 + (+Math_fround(2.0) + (3.3 + (+(4 >>> 0) + (+(5 | 0) + (+Math_fround(5.5) + ($21 + (+(i64toi32_i32$1 >>> 0) + 4294967296.0 * +(i64toi32_i32$0 >>> 0) + 8.0))))))));
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
  write: $9, 
  result: $10
 };
}

const memasmFunc = new ArrayBuffer(65536);
const retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export const type_local_i32 = retasmFunc.type_local_i32;
export const type_local_i64 = retasmFunc.type_local_i64;
export const type_local_f32 = retasmFunc.type_local_f32;
export const type_local_f64 = retasmFunc.type_local_f64;
export const type_param_i32 = retasmFunc.type_param_i32;
export const type_param_i64 = retasmFunc.type_param_i64;
export const type_param_f32 = retasmFunc.type_param_f32;
export const type_param_f64 = retasmFunc.type_param_f64;
export const type_mixed = retasmFunc.type_mixed;
export const write = retasmFunc.write;
export const result = retasmFunc.result;
