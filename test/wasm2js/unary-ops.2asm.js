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
 
 function $1($0) {
  $0 = $0 | 0;
  return __wasm_popcnt_i32($0 | 0) | 0 | 0;
 }
 
 function $2($0, $0$hi, r, r$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  r = r | 0;
  r$hi = r$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, $3$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = __wasm_popcnt_i64($0 | 0, i64toi32_i32$0 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $3$hi = i64toi32_i32$1;
  i64toi32_i32$1 = r$hi;
  i64toi32_i32$1 = $3$hi;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = r$hi;
  return (i64toi32_i32$2 | 0) == (r | 0) & (i64toi32_i32$1 | 0) == (i64toi32_i32$0 | 0) | 0 | 0;
 }
 
 function $3($0, r, r$hi) {
  $0 = $0 | 0;
  r = r | 0;
  r$hi = r$hi | 0;
  var i64toi32_i32$0 = 0, $3$hi = 0;
  i64toi32_i32$0 = 0;
  $3$hi = i64toi32_i32$0;
  i64toi32_i32$0 = r$hi;
  i64toi32_i32$0 = $3$hi;
  return ($0 | 0) == (r | 0) & (i64toi32_i32$0 | 0) == (r$hi | 0) | 0 | 0;
 }
 
 function $4($0, r, r$hi) {
  $0 = $0 | 0;
  r = r | 0;
  r$hi = r$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, $3$hi = 0;
  i64toi32_i32$1 = $0;
  i64toi32_i32$0 = i64toi32_i32$1 >> 31 | 0;
  $3$hi = i64toi32_i32$0;
  i64toi32_i32$0 = r$hi;
  i64toi32_i32$0 = $3$hi;
  i64toi32_i32$1 = r$hi;
  return ($0 | 0) == (r | 0) & (i64toi32_i32$0 | 0) == (i64toi32_i32$1 | 0) | 0 | 0;
 }
 
 function $5($0, $0$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  return ($0 | i64toi32_i32$0 | 0 | 0) == (0 | 0) | 0;
 }
 
 function $6($0) {
  $0 = $0 | 0;
  return Math_clz32($0) | 0;
 }
 
 function $7($0) {
  $0 = $0 | 0;
  return __wasm_ctz_i32($0 | 0) | 0 | 0;
 }
 
 function $8($0, $0$hi, r, r$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  r = r | 0;
  r$hi = r$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, i64toi32_i32$1 = 0, $9_1 = 0, $3$hi = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = $0;
  i64toi32_i32$3 = Math_clz32(i64toi32_i32$0);
  i64toi32_i32$2 = 0;
  if ((i64toi32_i32$3 | 0) == (32 | 0)) $9_1 = Math_clz32(i64toi32_i32$1) + 32 | 0; else $9_1 = i64toi32_i32$3;
  $3$hi = i64toi32_i32$2;
  i64toi32_i32$2 = r$hi;
  i64toi32_i32$2 = $3$hi;
  i64toi32_i32$1 = $9_1;
  i64toi32_i32$0 = r$hi;
  i64toi32_i32$3 = r;
  return (i64toi32_i32$1 | 0) == (i64toi32_i32$3 | 0) & (i64toi32_i32$2 | 0) == (i64toi32_i32$0 | 0) | 0 | 0;
 }
 
 function $9($0, $0$hi, r, r$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  r = r | 0;
  r$hi = r$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, $3$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = __wasm_ctz_i64($0 | 0, i64toi32_i32$0 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $3$hi = i64toi32_i32$1;
  i64toi32_i32$1 = r$hi;
  i64toi32_i32$1 = $3$hi;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = r$hi;
  return (i64toi32_i32$2 | 0) == (r | 0) & (i64toi32_i32$1 | 0) == (i64toi32_i32$0 | 0) | 0 | 0;
 }
 
 function __wasm_ctz_i32(var$0) {
  var$0 = var$0 | 0;
  if (var$0) return 31 - Math_clz32((var$0 + 4294967295 | 0) ^ var$0 | 0) | 0 | 0;
  return 32 | 0;
 }
 
 function __wasm_ctz_i64(var$0, var$0$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$5 = 0, i64toi32_i32$3 = 0, i64toi32_i32$4 = 0, i64toi32_i32$2 = 0, i64toi32_i32$1 = 0, $10 = 0, $5$hi = 0, $8$hi = 0;
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
   if ((i64toi32_i32$3 | 0) == (32 | 0)) $10 = Math_clz32(i64toi32_i32$0) + 32 | 0; else $10 = i64toi32_i32$3;
   $8$hi = i64toi32_i32$5;
   i64toi32_i32$5 = 0;
   i64toi32_i32$0 = 63;
   i64toi32_i32$2 = $8$hi;
   i64toi32_i32$3 = $10;
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
 
 function __wasm_popcnt_i32(var$0) {
  var$0 = var$0 | 0;
  var var$1 = 0, $5_1 = 0;
  label$1 : {
   label$2 : do {
    $5_1 = var$1;
    if ((var$0 | 0) == (0 | 0)) break label$1;
    var$0 = var$0 & (var$0 - 1 | 0) | 0;
    var$1 = var$1 + 1 | 0;
    continue label$2;
    break label$2;
   } while (1);
  };
  return $5_1 | 0;
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
 
 return {
  i32_popcnt: $1, 
  check_popcnt_i64: $2, 
  check_extend_ui32: $3, 
  check_extend_si32: $4, 
  check_eqz_i64: $5, 
  i32_clz: $6, 
  i32_ctz: $7, 
  check_clz_i64: $8, 
  check_ctz_i64: $9
 };
}

const memasmFunc = new ArrayBuffer(65536);
const retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export const i32_popcnt = retasmFunc.i32_popcnt;
export const check_popcnt_i64 = retasmFunc.check_popcnt_i64;
export const check_extend_ui32 = retasmFunc.check_extend_ui32;
export const check_extend_si32 = retasmFunc.check_extend_si32;
export const check_eqz_i64 = retasmFunc.check_eqz_i64;
export const i32_clz = retasmFunc.i32_clz;
export const i32_ctz = retasmFunc.i32_ctz;
export const check_clz_i64 = retasmFunc.check_clz_i64;
export const check_ctz_i64 = retasmFunc.check_ctz_i64;
