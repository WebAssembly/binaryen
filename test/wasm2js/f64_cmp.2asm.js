
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
  x = +x;
  y = +y;
  return x == y | 0;
 }
 
 function f1(x, y) {
  x = +x;
  y = +y;
  return x != y | 0;
 }
 
 function f2(x, y) {
  x = +x;
  y = +y;
  return x < y | 0;
 }
 
 function f3(x, y) {
  x = +x;
  y = +y;
  return x <= y | 0;
 }
 
 function f4(x, y) {
  x = +x;
  y = +y;
  return x > y | 0;
 }
 
 function f5(x, y) {
  x = +x;
  y = +y;
  return x >= y | 0;
 }
 
 return {
  "eq": f0, 
  "ne": f1, 
  "lt": f2, 
  "le": f3, 
  "gt": f4, 
  "ge": f5
 };
}

var retasmFunc = asmFunc({
});
export var eq = retasmFunc.eq;
export var ne = retasmFunc.ne;
export var lt = retasmFunc.lt;
export var le = retasmFunc.le;
export var gt = retasmFunc.gt;
export var ge = retasmFunc.ge;
