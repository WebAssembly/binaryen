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
 function $0(x, y) {
  x = x | 0;
  y = y | 0;
  return (x + 1 | 0 | 0) < (y + 1 | 0 | 0) | 0;
 }
 
 function $1(x, y) {
  x = x | 0;
  y = y | 0;
  return (x + 1 | 0) >>> 0 < (y + 1 | 0) >>> 0 | 0;
 }
 
 function $2(x, x$hi, y, y$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  y = y | 0;
  y$hi = y$hi | 0;
  var i64toi32_i32$4 = 0, i64toi32_i32$5 = 0, i64toi32_i32$0 = 0, i64toi32_i32$3 = 0, i64toi32_i32$1 = 0, i64toi32_i32$2 = 0, $13 = 0, $14 = 0, $15 = 0, $3_1 = 0, $3$hi = 0, $5$hi = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$2 = x;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 1;
  i64toi32_i32$4 = i64toi32_i32$2 + i64toi32_i32$3 | 0;
  i64toi32_i32$5 = i64toi32_i32$0 + i64toi32_i32$1 | 0;
  if (i64toi32_i32$4 >>> 0 < i64toi32_i32$3 >>> 0) i64toi32_i32$5 = i64toi32_i32$5 + 1 | 0;
  $3_1 = i64toi32_i32$4;
  $3$hi = i64toi32_i32$5;
  i64toi32_i32$5 = y$hi;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$0 = y;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 1;
  i64toi32_i32$1 = i64toi32_i32$0 + i64toi32_i32$3 | 0;
  i64toi32_i32$4 = i64toi32_i32$5 + i64toi32_i32$2 | 0;
  if (i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0) i64toi32_i32$4 = i64toi32_i32$4 + 1 | 0;
  $5$hi = i64toi32_i32$4;
  i64toi32_i32$4 = $3$hi;
  i64toi32_i32$5 = $3_1;
  i64toi32_i32$0 = $5$hi;
  i64toi32_i32$3 = i64toi32_i32$1;
  if ((i64toi32_i32$4 | 0) < (i64toi32_i32$0 | 0)) $13 = 1; else {
   if ((i64toi32_i32$4 | 0) <= (i64toi32_i32$0 | 0)) {
    if (i64toi32_i32$5 >>> 0 >= i64toi32_i32$3 >>> 0) $14 = 0; else $14 = 1;
    $15 = $14;
   } else $15 = 0;
   $13 = $15;
  }
  return $13 | 0;
 }
 
 function $3(x, x$hi, y, y$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  y = y | 0;
  y$hi = y$hi | 0;
  var i64toi32_i32$4 = 0, i64toi32_i32$5 = 0, i64toi32_i32$0 = 0, i64toi32_i32$3 = 0, i64toi32_i32$1 = 0, i64toi32_i32$2 = 0, $3_1 = 0, $3$hi = 0, $5$hi = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$2 = x;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 1;
  i64toi32_i32$4 = i64toi32_i32$2 + i64toi32_i32$3 | 0;
  i64toi32_i32$5 = i64toi32_i32$0 + i64toi32_i32$1 | 0;
  if (i64toi32_i32$4 >>> 0 < i64toi32_i32$3 >>> 0) i64toi32_i32$5 = i64toi32_i32$5 + 1 | 0;
  $3_1 = i64toi32_i32$4;
  $3$hi = i64toi32_i32$5;
  i64toi32_i32$5 = y$hi;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$0 = y;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 1;
  i64toi32_i32$1 = i64toi32_i32$0 + i64toi32_i32$3 | 0;
  i64toi32_i32$4 = i64toi32_i32$5 + i64toi32_i32$2 | 0;
  if (i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0) i64toi32_i32$4 = i64toi32_i32$4 + 1 | 0;
  $5$hi = i64toi32_i32$4;
  i64toi32_i32$4 = $3$hi;
  i64toi32_i32$5 = $3_1;
  i64toi32_i32$0 = $5$hi;
  i64toi32_i32$3 = i64toi32_i32$1;
  return i64toi32_i32$4 >>> 0 < i64toi32_i32$0 >>> 0 | ((i64toi32_i32$4 | 0) == (i64toi32_i32$0 | 0) & i64toi32_i32$5 >>> 0 < i64toi32_i32$3 >>> 0 | 0) | 0 | 0;
 }
 
 return {
  i32_no_fold_cmp_s_offset: $0, 
  i32_no_fold_cmp_u_offset: $1, 
  i64_no_fold_cmp_s_offset: $2, 
  i64_no_fold_cmp_u_offset: $3
 };
}

const memasmFunc = new ArrayBuffer(65536);
const retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export const i32_no_fold_cmp_s_offset = retasmFunc.i32_no_fold_cmp_s_offset;
export const i32_no_fold_cmp_u_offset = retasmFunc.i32_no_fold_cmp_u_offset;
export const i64_no_fold_cmp_s_offset = retasmFunc.i64_no_fold_cmp_s_offset;
export const i64_no_fold_cmp_u_offset = retasmFunc.i64_no_fold_cmp_u_offset;
