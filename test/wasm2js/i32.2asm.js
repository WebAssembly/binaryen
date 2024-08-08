
function asmFunc(imports) {
 var Math_imul = Math.imul;
 var Math_fround = Math.fround;
 var Math_abs = Math.abs;
 var Math_clz32 = Math.clz32;
 var Math_min = Math.min;
 var Math_max = Math.max;
 var Math_floor = Math.floor;
 var Math_ceil = Math.ceil;
 var Math_trunc = Math.trunc;
 var Math_sqrt = Math.sqrt;
 function f0(x, y) {
  x = x | 0;
  y = y | 0;
  return x + y | 0 | 0;
 }
 
 function f1(x, y) {
  x = x | 0;
  y = y | 0;
  return x - y | 0 | 0;
 }
 
 function f2(x, y) {
  x = x | 0;
  y = y | 0;
  return Math_imul(x, y) | 0;
 }
 
 function f3(x, y) {
  x = x | 0;
  y = y | 0;
  return (x | 0) / (y | 0) | 0 | 0;
 }
 
 function f4(x, y) {
  x = x | 0;
  y = y | 0;
  return (x >>> 0) / (y >>> 0) | 0 | 0;
 }
 
 function f5(x, y) {
  x = x | 0;
  y = y | 0;
  return (x | 0) % (y | 0) | 0 | 0;
 }
 
 function f6(x, y) {
  x = x | 0;
  y = y | 0;
  return (x >>> 0) % (y >>> 0) | 0 | 0;
 }
 
 function f7(x, y) {
  x = x | 0;
  y = y | 0;
  return x & y | 0 | 0;
 }
 
 function f8(x, y) {
  x = x | 0;
  y = y | 0;
  return x | y | 0 | 0;
 }
 
 function f9(x, y) {
  x = x | 0;
  y = y | 0;
  return x ^ y | 0 | 0;
 }
 
 function f10(x, y) {
  x = x | 0;
  y = y | 0;
  return x << y | 0 | 0;
 }
 
 function f11(x, y) {
  x = x | 0;
  y = y | 0;
  return x >> y | 0 | 0;
 }
 
 function f12(x, y) {
  x = x | 0;
  y = y | 0;
  return x >>> y | 0 | 0;
 }
 
 function f13(x, y) {
  x = x | 0;
  y = y | 0;
  return __wasm_rotl_i32(x | 0, y | 0) | 0 | 0;
 }
 
 function f14(x, y) {
  x = x | 0;
  y = y | 0;
  return __wasm_rotr_i32(x | 0, y | 0) | 0 | 0;
 }
 
 function f15(x) {
  x = x | 0;
  return Math_clz32(x) | 0;
 }
 
 function f16(x) {
  x = x | 0;
  return __wasm_ctz_i32(x | 0) | 0 | 0;
 }
 
 function f17(x) {
  x = x | 0;
  return __wasm_popcnt_i32(x | 0) | 0 | 0;
 }
 
 function f18(x) {
  x = x | 0;
  return !x | 0;
 }
 
 function f19(x, y) {
  x = x | 0;
  y = y | 0;
  return (x | 0) == (y | 0) | 0;
 }
 
 function f20(x, y) {
  x = x | 0;
  y = y | 0;
  return (x | 0) != (y | 0) | 0;
 }
 
 function f21(x, y) {
  x = x | 0;
  y = y | 0;
  return (x | 0) < (y | 0) | 0;
 }
 
 function f22(x, y) {
  x = x | 0;
  y = y | 0;
  return x >>> 0 < y >>> 0 | 0;
 }
 
 function f23(x, y) {
  x = x | 0;
  y = y | 0;
  return (x | 0) <= (y | 0) | 0;
 }
 
 function f24(x, y) {
  x = x | 0;
  y = y | 0;
  return x >>> 0 <= y >>> 0 | 0;
 }
 
 function f25(x, y) {
  x = x | 0;
  y = y | 0;
  return (x | 0) > (y | 0) | 0;
 }
 
 function f26(x, y) {
  x = x | 0;
  y = y | 0;
  return x >>> 0 > y >>> 0 | 0;
 }
 
 function f27(x, y) {
  x = x | 0;
  y = y | 0;
  return (x | 0) >= (y | 0) | 0;
 }
 
 function f28(x, y) {
  x = x | 0;
  y = y | 0;
  return x >>> 0 >= y >>> 0 | 0;
 }
 
 function __wasm_ctz_i32(var$0) {
  var$0 = var$0 | 0;
  if (var$0) {
   return 31 - Math_clz32((var$0 + -1 | 0) ^ var$0 | 0) | 0 | 0
  }
  return 32 | 0;
 }
 
 function __wasm_popcnt_i32(var$0) {
  var$0 = var$0 | 0;
  var var$1 = 0, $5 = 0;
  label$1 : {
   label$2 : while (1) {
    $5 = var$1;
    if (!var$0) {
     break label$1
    }
    var$0 = var$0 & (var$0 - 1 | 0) | 0;
    var$1 = var$1 + 1 | 0;
    continue label$2;
   };
  }
  return $5 | 0;
 }
 
 function __wasm_rotl_i32(var$0, var$1) {
  var$0 = var$0 | 0;
  var$1 = var$1 | 0;
  var var$2 = 0;
  var$2 = var$1 & 31 | 0;
  var$1 = (0 - var$1 | 0) & 31 | 0;
  return ((-1 >>> var$2 | 0) & var$0 | 0) << var$2 | 0 | (((-1 << var$1 | 0) & var$0 | 0) >>> var$1 | 0) | 0 | 0;
 }
 
 function __wasm_rotr_i32(var$0, var$1) {
  var$0 = var$0 | 0;
  var$1 = var$1 | 0;
  var var$2 = 0;
  var$2 = var$1 & 31 | 0;
  var$1 = (0 - var$1 | 0) & 31 | 0;
  return ((-1 << var$2 | 0) & var$0 | 0) >>> var$2 | 0 | (((-1 >>> var$1 | 0) & var$0 | 0) << var$1 | 0) | 0 | 0;
 }
 
 return {
  "add": f0, 
  "sub": f1, 
  "mul": f2, 
  "div_s": f3, 
  "div_u": f4, 
  "rem_s": f5, 
  "rem_u": f6, 
  "and": f7, 
  "or": f8, 
  "xor": f9, 
  "shl": f10, 
  "shr_s": f11, 
  "shr_u": f12, 
  "rotl": f13, 
  "rotr": f14, 
  "clz": f15, 
  "ctz": f16, 
  "popcnt": f17, 
  "eqz": f18, 
  "eq": f19, 
  "ne": f20, 
  "lt_s": f21, 
  "lt_u": f22, 
  "le_s": f23, 
  "le_u": f24, 
  "gt_s": f25, 
  "gt_u": f26, 
  "ge_s": f27, 
  "ge_u": f28
 };
}

var retasmFunc = asmFunc({
});
export var add = retasmFunc.add;
export var sub = retasmFunc.sub;
export var mul = retasmFunc.mul;
export var div_s = retasmFunc.div_s;
export var div_u = retasmFunc.div_u;
export var rem_s = retasmFunc.rem_s;
export var rem_u = retasmFunc.rem_u;
export var and = retasmFunc.and;
export var or = retasmFunc.or;
export var xor = retasmFunc.xor;
export var shl = retasmFunc.shl;
export var shr_s = retasmFunc.shr_s;
export var shr_u = retasmFunc.shr_u;
export var rotl = retasmFunc.rotl;
export var rotr = retasmFunc.rotr;
export var clz = retasmFunc.clz;
export var ctz = retasmFunc.ctz;
export var popcnt = retasmFunc.popcnt;
export var eqz = retasmFunc.eqz;
export var eq = retasmFunc.eq;
export var ne = retasmFunc.ne;
export var lt_s = retasmFunc.lt_s;
export var lt_u = retasmFunc.lt_u;
export var le_s = retasmFunc.le_s;
export var le_u = retasmFunc.le_u;
export var gt_s = retasmFunc.gt_s;
export var gt_u = retasmFunc.gt_u;
export var ge_s = retasmFunc.ge_s;
export var ge_u = retasmFunc.ge_u;
