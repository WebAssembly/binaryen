
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
 function null_() {
  return null;
 }
 
 function is_null(ref) {
  return ref == null | 0;
 }
 
 function ref_func() {
  var ref_func_1 = 0;
  ref_func_1 = ref_func_1 + 1 | 0;
  return ref_func;
 }
 
 function ref_eq(x, y) {
  return x == y | 0;
 }
 
 return {
  "null_": null_, 
  "is_null": is_null, 
  "ref_func": ref_func, 
  "ref_eq": ref_eq
 };
}

var retasmFunc = asmFunc({
});
export var null_ = retasmFunc.null_;
export var is_null = retasmFunc.is_null;
export var ref_func = retasmFunc.ref_func;
export var ref_eq = retasmFunc.ref_eq;
