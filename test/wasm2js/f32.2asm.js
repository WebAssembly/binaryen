
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
  x = Math_fround(x);
  y = Math_fround(y);
  return Math_fround(Math_fround(x + y));
 }
 
 function f1(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return Math_fround(Math_fround(x - y));
 }
 
 function f2(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return Math_fround(Math_fround(x * y));
 }
 
 function f3(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return Math_fround(Math_fround(x / y));
 }
 
 function f4(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(Math_sqrt(x)));
 }
 
 function f5(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return Math_fround(Math_fround(Math_min(x, y)));
 }
 
 function f6(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return Math_fround(Math_fround(Math_max(x, y)));
 }
 
 function f7(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(Math_ceil(x)));
 }
 
 function f8(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(Math_floor(x)));
 }
 
 function f9(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(Math_trunc(x)));
 }
 
 function f10(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(__wasm_nearest_f32(Math_fround(x))));
 }
 
 function __wasm_nearest_f32(var$0) {
  var$0 = Math_fround(var$0);
  var var$1 = Math_fround(0), var$2 = Math_fround(0);
  var$1 = Math_fround(Math_floor(var$0));
  var$2 = Math_fround(var$0 - var$1);
  if (!(var$2 < Math_fround(.5))) {
   var$0 = Math_fround(Math_ceil(var$0));
   if (var$2 > Math_fround(.5)) {
    return Math_fround(var$0)
   }
   var$2 = Math_fround(var$1 * Math_fround(.5));
   var$1 = Math_fround(var$2 - Math_fround(Math_floor(var$2))) == Math_fround(0.0) ? var$1 : var$0;
  }
  return Math_fround(var$1);
 }
 
 return {
  "add": f0, 
  "sub": f1, 
  "mul": f2, 
  "div": f3, 
  "sqrt": f4, 
  "min": f5, 
  "max": f6, 
  "ceil": f7, 
  "floor": f8, 
  "trunc": f9, 
  "nearest": f10
 };
}

var retasmFunc = asmFunc({
});
export var add = retasmFunc.add;
export var sub = retasmFunc.sub;
export var mul = retasmFunc.mul;
export var div = retasmFunc.div;
export var sqrt = retasmFunc.sqrt;
export var min = retasmFunc.min;
export var max = retasmFunc.max;
export var ceil = retasmFunc.ceil;
export var floor = retasmFunc.floor;
export var trunc = retasmFunc.trunc;
export var nearest = retasmFunc.nearest;
