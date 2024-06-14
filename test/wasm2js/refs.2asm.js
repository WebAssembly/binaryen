import * as fuzzing_support from 'fuzzing-support';

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
 var fuzzing_support = imports["fuzzing-support"];
 var log = fuzzing_support["log-f64"];
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
 
 function funcref_temps($0) {
  var $1 = null, $2 = null, wasm2js_funcref$0 = null, wasm2js_funcref$1 = null, wasm2js_i32$0 = 0;
  $1 = $0;
  loop : while (1) {
   $2 = funcref_temps;
   break loop;
  };
  log(+(+((wasm2js_funcref$0 = $1, wasm2js_funcref$1 = $2 || wasm2js_trap(), wasm2js_i32$0 = 0, wasm2js_i32$0 ? wasm2js_funcref$0 : wasm2js_funcref$1) == null | 0)));
 }
 
 return {
  "null_": null_, 
  "is_null": is_null, 
  "ref_func": ref_func, 
  "ref_eq": ref_eq, 
  "ref_as": ref_as, 
  "use_global": use_global, 
  "use_global_ref": use_global_ref, 
  "funcref_temps": funcref_temps
 };
}

var retasmFunc = asmFunc({
  "fuzzing-support": fuzzing_support,
});
export var null_ = retasmFunc.null_;
export var is_null = retasmFunc.is_null;
export var ref_func = retasmFunc.ref_func;
export var ref_eq = retasmFunc.ref_eq;
export var ref_as = retasmFunc.ref_as;
export var use_global = retasmFunc.use_global;
export var use_global_ref = retasmFunc.use_global_ref;
export var funcref_temps = retasmFunc.funcref_temps;
