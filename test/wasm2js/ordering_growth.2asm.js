
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
 function main() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  FUNCTION_TABLE[foo(2)](1) | 0;
  FUNCTION_TABLE[4](foo(3)) | 0;
  (wasm2js_i32$1 = foo(5), wasm2js_i32$0 = bar(6)), FUNCTION_TABLE[wasm2js_i32$0](wasm2js_i32$1 | 0) | 0;
  FUNCTION_TABLE[8](7) | 0;
 }
 
 function foo($0) {
  $0 = $0 | 0;
  return 1 | 0;
 }
 
 function bar($0) {
  $0 = $0 | 0;
  return 2 | 0;
 }
 
 function tabled($0) {
  $0 = $0 | 0;
  return 3 | 0;
 }
 
 FUNCTION_TABLE[1] = foo;
 FUNCTION_TABLE[2] = bar;
 FUNCTION_TABLE[3] = tabled;
 return {
  "main": main
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export var main = retasmFunc.main;
