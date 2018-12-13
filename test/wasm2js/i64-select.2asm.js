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
 function p(i) {
  i = i | 0;
  return i | 0;
 }
 
 function $1($0) {
  $0 = $0 | 0;
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0;
  return (wasm2js_i32$0 = p(4294967295 | 0) | 0, wasm2js_i32$1 = p(0 | 0) | 0, wasm2js_i32$2 = 1, wasm2js_i32$2 ? wasm2js_i32$0 : wasm2js_i32$1) | 0;
 }
 
 function $2() {
  var i64toi32_i32$3 = 0, i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0;
  i64toi32_i32$4 = 1;
  i64toi32_i32$3 = (wasm2js_i32$0 = 4294967295, wasm2js_i32$1 = 0, wasm2js_i32$2 = i64toi32_i32$4, wasm2js_i32$2 ? wasm2js_i32$0 : wasm2js_i32$1);
  i64toi32_i32$2 = (wasm2js_i32$0 = 4294967295, wasm2js_i32$1 = 0, wasm2js_i32$2 = i64toi32_i32$4, wasm2js_i32$2 ? wasm2js_i32$0 : wasm2js_i32$1);
  i64toi32_i32$2 = i64toi32_i32$2;
  i64toi32_i32$3 = i64toi32_i32$3;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$2;
  return i64toi32_i32$3 | 0;
 }
 
 return {
  
 };
}

const memasmFunc = new ArrayBuffer(65536);
const retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
