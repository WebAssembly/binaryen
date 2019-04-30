
function asmFunc(global, env, buffer) {
 "almost asm";
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
 function $1() {
  
 }
 
 function $2() {
  return 7 | 0;
 }
 
 function $3() {
  return 8 | 0;
 }
 
 function $4() {
  return 9 | 0;
 }
 
 function $5() {
  return 150 | 0;
 }
 
 function $6() {
  return 0 | 0;
 }
 
 function $7() {
  return 12 | 0;
 }
 
 function $10() {
  return 19 | 0;
 }
 
 function $11() {
  return 18 | 0;
 }
 
 function $13() {
  return 15 | 0;
 }
 
 function $14() {
  return 1 | 0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "empty": $1, 
  "singular": $2, 
  "multi": $3, 
  "nested": $4, 
  "deep": $5, 
  "as_unary_operand": $6, 
  "as_binary_operand": $7, 
  "as_test_operand": $6, 
  "as_compare_operand": $6, 
  "break_bare": $10, 
  "break_value": $11, 
  "break_repeated": $11, 
  "break_inner": $13, 
  "effects": $14
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export var empty = retasmFunc.empty;
export var singular = retasmFunc.singular;
export var multi = retasmFunc.multi;
export var nested = retasmFunc.nested;
export var deep = retasmFunc.deep;
export var as_unary_operand = retasmFunc.as_unary_operand;
export var as_binary_operand = retasmFunc.as_binary_operand;
export var as_test_operand = retasmFunc.as_test_operand;
export var as_compare_operand = retasmFunc.as_compare_operand;
export var break_bare = retasmFunc.break_bare;
export var break_value = retasmFunc.break_value;
export var break_repeated = retasmFunc.break_repeated;
export var break_inner = retasmFunc.break_inner;
export var effects = retasmFunc.effects;
