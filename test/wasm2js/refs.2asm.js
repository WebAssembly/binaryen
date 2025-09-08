
function wasm2js_trap() { throw new Error('abort'); }

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
 var global = null;
 var global_ref = use_global_ref;
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
 
 function ref_as(x) {
  return x || wasm2js_trap();
 }
 
 function use_global(x) {
  var temp = null;
  temp = global;
  global = x;
  return temp;
 }
 
 function use_global_ref(x) {
  var temp = null;
  temp = global_ref;
  global_ref = x;
  return temp;
 }
 
 function funcref_temps($0, $1) {
  $1 = +$1;
  var $2 = null, $3 = null;
  $2 = $0;
  loop : while (1) {
   $3 = funcref_temps;
   break loop;
  };
  funcref_temps(funcref_temps, +(+((0 ? $2 : $3) == null | 0)));
 }
 
 function named_type_temps() {
  var $0 = null, wasm2js__ref_null__exact_$func_0__$0_1 = null, wasm2js__ref_null__exact_$func_0__$1_1 = null, wasm2js_i32$0 = 0;
  $0 = named_type_temps;
  return wasm2js__ref_null__exact_$func_0__$0 = null, wasm2js__ref_null__exact_$func_0__$1 = $0 || wasm2js_trap(), wasm2js_i32$0 = 0, wasm2js_i32$0 ? wasm2js__ref_null__exact_$func_0__$0 : wasm2js__ref_null__exact_$func_0__$1;
 }
 
 return {
  "null_": null_, 
  "is_null": is_null, 
  "ref_func": ref_func, 
  "ref_eq": ref_eq, 
  "ref_as": ref_as, 
  "use_global": use_global, 
  "use_global_ref": use_global_ref, 
  "funcref_temps": funcref_temps, 
  "named_type_temps": named_type_temps
 };
}

var retasmFunc = asmFunc({
});
export var null_ = retasmFunc.null_;
export var is_null = retasmFunc.is_null;
export var ref_func = retasmFunc.ref_func;
export var ref_eq = retasmFunc.ref_eq;
export var ref_as = retasmFunc.ref_as;
export var use_global = retasmFunc.use_global;
export var use_global_ref = retasmFunc.use_global_ref;
export var funcref_temps = retasmFunc.funcref_temps;
export var named_type_temps = retasmFunc.named_type_temps;
