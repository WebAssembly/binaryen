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
 function dummy() {
  
 }
 
 function $1($0, $0$hi, $1_1, $1$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  $1_1 = $1_1 | 0;
  $1$hi = $1$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = $1$hi;
  i64toi32_i32$0 = $0$hi;
  return ($0 | 0) == ($1_1 | 0) & (i64toi32_i32$0 | 0) == ($1$hi | 0) | 0 | 0;
 }
 
 function $2($0, $0$hi, $1_1, $1$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  $1_1 = $1_1 | 0;
  $1$hi = $1$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = $1$hi;
  i64toi32_i32$0 = $0$hi;
  return ($0 | 0) != ($1_1 | 0) | (i64toi32_i32$0 | 0) != ($1$hi | 0) | 0 | 0;
 }
 
 function $3($0, $0$hi, $1_1, $1$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  $1_1 = $1_1 | 0;
  $1$hi = $1$hi | 0;
  var i64toi32_i32$0 = 0, $8_1 = 0, $9_1 = 0, $10_1 = 0, i64toi32_i32$2 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = $1$hi;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$2 = $0;
  i64toi32_i32$1 = $1$hi;
  i64toi32_i32$3 = $1_1;
  if ((i64toi32_i32$0 | 0) > ($1$hi | 0)) $8_1 = 1; else {
   if ((i64toi32_i32$0 | 0) >= (i64toi32_i32$1 | 0)) {
    if (i64toi32_i32$2 >>> 0 < i64toi32_i32$3 >>> 0) $9_1 = 0; else $9_1 = 1;
    $10_1 = $9_1;
   } else $10_1 = 0;
   $8_1 = $10_1;
  }
  return $8_1 | 0;
 }
 
 function $4($0, $0$hi, $1_1, $1$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  $1_1 = $1_1 | 0;
  $1$hi = $1$hi | 0;
  var i64toi32_i32$0 = 0, $8_1 = 0, $9_1 = 0, $10_1 = 0, i64toi32_i32$2 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = $1$hi;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$2 = $0;
  i64toi32_i32$1 = $1$hi;
  i64toi32_i32$3 = $1_1;
  if ((i64toi32_i32$0 | 0) > ($1$hi | 0)) $8_1 = 1; else {
   if ((i64toi32_i32$0 | 0) >= (i64toi32_i32$1 | 0)) {
    if (i64toi32_i32$2 >>> 0 <= i64toi32_i32$3 >>> 0) $9_1 = 0; else $9_1 = 1;
    $10_1 = $9_1;
   } else $10_1 = 0;
   $8_1 = $10_1;
  }
  return $8_1 | 0;
 }
 
 function $5($0, $0$hi, $1_1, $1$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  $1_1 = $1_1 | 0;
  $1$hi = $1$hi | 0;
  var i64toi32_i32$0 = 0, $8_1 = 0, $9_1 = 0, $10_1 = 0, i64toi32_i32$2 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = $1$hi;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$2 = $0;
  i64toi32_i32$1 = $1$hi;
  i64toi32_i32$3 = $1_1;
  if ((i64toi32_i32$0 | 0) < ($1$hi | 0)) $8_1 = 1; else {
   if ((i64toi32_i32$0 | 0) <= (i64toi32_i32$1 | 0)) {
    if (i64toi32_i32$2 >>> 0 > i64toi32_i32$3 >>> 0) $9_1 = 0; else $9_1 = 1;
    $10_1 = $9_1;
   } else $10_1 = 0;
   $8_1 = $10_1;
  }
  return $8_1 | 0;
 }
 
 function $6($0, $0$hi, $1_1, $1$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  $1_1 = $1_1 | 0;
  $1$hi = $1$hi | 0;
  var i64toi32_i32$0 = 0, $8_1 = 0, $9_1 = 0, $10_1 = 0, i64toi32_i32$2 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = $1$hi;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$2 = $0;
  i64toi32_i32$1 = $1$hi;
  i64toi32_i32$3 = $1_1;
  if ((i64toi32_i32$0 | 0) < ($1$hi | 0)) $8_1 = 1; else {
   if ((i64toi32_i32$0 | 0) <= (i64toi32_i32$1 | 0)) {
    if (i64toi32_i32$2 >>> 0 >= i64toi32_i32$3 >>> 0) $9_1 = 0; else $9_1 = 1;
    $10_1 = $9_1;
   } else $10_1 = 0;
   $8_1 = $10_1;
  }
  return $8_1 | 0;
 }
 
 function $7($0, $0$hi, $1_1, $1$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  $1_1 = $1_1 | 0;
  $1$hi = $1$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = $1$hi;
  i64toi32_i32$0 = $0$hi;
  return i64toi32_i32$0 >>> 0 > $1$hi >>> 0 | ((i64toi32_i32$0 | 0) == ($1$hi | 0) & $0 >>> 0 >= $1_1 >>> 0 | 0) | 0 | 0;
 }
 
 function $8($0, $0$hi, $1_1, $1$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  $1_1 = $1_1 | 0;
  $1$hi = $1$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = $1$hi;
  i64toi32_i32$0 = $0$hi;
  return i64toi32_i32$0 >>> 0 > $1$hi >>> 0 | ((i64toi32_i32$0 | 0) == ($1$hi | 0) & $0 >>> 0 > $1_1 >>> 0 | 0) | 0 | 0;
 }
 
 function $9($0, $0$hi, $1_1, $1$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  $1_1 = $1_1 | 0;
  $1$hi = $1$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = $1$hi;
  i64toi32_i32$0 = $0$hi;
  return i64toi32_i32$0 >>> 0 < $1$hi >>> 0 | ((i64toi32_i32$0 | 0) == ($1$hi | 0) & $0 >>> 0 <= $1_1 >>> 0 | 0) | 0 | 0;
 }
 
 function $10($0, $0$hi, $1_1, $1$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  $1_1 = $1_1 | 0;
  $1$hi = $1$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = $1$hi;
  i64toi32_i32$0 = $0$hi;
  return i64toi32_i32$0 >>> 0 < $1$hi >>> 0 | ((i64toi32_i32$0 | 0) == ($1$hi | 0) & $0 >>> 0 < $1_1 >>> 0 | 0) | 0 | 0;
 }
 
 return {
  eq_i64: $1, 
  ne_i64: $2, 
  ge_s_i64: $3, 
  gt_s_i64: $4, 
  le_s_i64: $5, 
  lt_s_i64: $6, 
  ge_u_i64: $7, 
  gt_u_i64: $8, 
  le_u_i64: $9, 
  lt_u_i64: $10
 };
}

const memasmFunc = new ArrayBuffer(65536);
const retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export const eq_i64 = retasmFunc.eq_i64;
export const ne_i64 = retasmFunc.ne_i64;
export const ge_s_i64 = retasmFunc.ge_s_i64;
export const gt_s_i64 = retasmFunc.gt_s_i64;
export const le_s_i64 = retasmFunc.le_s_i64;
export const lt_s_i64 = retasmFunc.lt_s_i64;
export const ge_u_i64 = retasmFunc.ge_u_i64;
export const gt_u_i64 = retasmFunc.gt_u_i64;
export const le_u_i64 = retasmFunc.le_u_i64;
export const lt_u_i64 = retasmFunc.lt_u_i64;
