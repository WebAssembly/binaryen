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
 function $0(lhs, rhs, cond) {
  lhs = lhs | 0;
  rhs = rhs | 0;
  cond = cond | 0;
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0;
  return (wasm2js_i32$0 = lhs, wasm2js_i32$1 = rhs, wasm2js_i32$2 = cond, wasm2js_i32$2 ? wasm2js_i32$0 : wasm2js_i32$1) | 0;
 }
 
 function $1(lhs, lhs$hi, rhs, rhs$hi, cond) {
  lhs = lhs | 0;
  lhs$hi = lhs$hi | 0;
  rhs = rhs | 0;
  rhs$hi = rhs$hi | 0;
  cond = cond | 0;
  var i64toi32_i32$0 = 0, wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0;
  i64toi32_i32$0 = lhs$hi;
  i64toi32_i32$0 = rhs$hi;
  i64toi32_i32$0 = lhs$hi;
  i64toi32_i32$0 = rhs$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return (wasm2js_i32$0 = lhs, wasm2js_i32$1 = rhs, wasm2js_i32$2 = cond, wasm2js_i32$2 ? wasm2js_i32$0 : wasm2js_i32$1) | 0;
 }
 
 function $2(lhs, rhs, cond) {
  lhs = Math_fround(lhs);
  rhs = Math_fround(rhs);
  cond = cond | 0;
  var wasm2js_f32$0 = Math_fround(0), wasm2js_f32$1 = Math_fround(0), wasm2js_i32$0 = 0;
  return Math_fround((wasm2js_f32$0 = lhs, wasm2js_f32$1 = rhs, wasm2js_i32$0 = cond, wasm2js_i32$0 ? wasm2js_f32$0 : wasm2js_f32$1));
 }
 
 function $3(lhs, rhs, cond) {
  lhs = +lhs;
  rhs = +rhs;
  cond = cond | 0;
  var wasm2js_f64$0 = 0.0, wasm2js_f64$1 = 0.0, wasm2js_i32$0 = 0;
  return +(wasm2js_f64$0 = lhs, wasm2js_f64$1 = rhs, wasm2js_i32$0 = cond, wasm2js_i32$0 ? wasm2js_f64$0 : wasm2js_f64$1);
 }
 
 function $4(cond) {
  cond = cond | 0;
  var $1_1 = 0, $2_1 = 0;
  return abort() | 0;
 }
 
 function $5(cond) {
  cond = cond | 0;
  var $1_1 = 0, $2_1 = 0;
  return abort() | 0;
 }
 
 return {
  select_i32: $0, 
  select_i64: $1, 
  select_f32: $2, 
  select_f64: $3, 
  select_trap_l: $4, 
  select_trap_r: $5
 };
}

const memasmFunc = new ArrayBuffer(65536);
const retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export const select_i32 = retasmFunc.select_i32;
export const select_i64 = retasmFunc.select_i64;
export const select_f32 = retasmFunc.select_f32;
export const select_f64 = retasmFunc.select_f64;
export const select_trap_l = retasmFunc.select_trap_l;
export const select_trap_r = retasmFunc.select_trap_r;
