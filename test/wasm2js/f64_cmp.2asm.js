
function asmFunc(global, env, buffer) {
 "almost asm";
 var HEAP8 = new global.Int8Array(buffer);
 var HEAP16 = new global.Int16Array(buffer);
 var HEAP32 = new global.Int32Array(buffer);
 var HEAPU8 = new global.Uint8Array(buffer);
 var HEAPU16 = new global.Uint16Array(buffer);
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
 function $0(x, y) {
  x = +x;
  y = +y;
  return x == y | 0;
 }
 
 function $1(x, y) {
  x = +x;
  y = +y;
  return x != y | 0;
 }
 
 function $2(x, y) {
  x = +x;
  y = +y;
  return x < y | 0;
 }
 
 function $3(x, y) {
  x = +x;
  y = +y;
  return x <= y | 0;
 }
 
 function $4(x, y) {
  x = +x;
  y = +y;
  return x > y | 0;
 }
 
 function $5(x, y) {
  x = +x;
  y = +y;
  return x >= y | 0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "eq": $0, 
  "ne": $1, 
  "lt": $2, 
  "le": $3, 
  "gt": $4, 
  "ge": $5
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export var eq = retasmFunc.eq;
export var ne = retasmFunc.ne;
export var lt = retasmFunc.lt;
export var le = retasmFunc.le;
export var gt = retasmFunc.gt;
export var ge = retasmFunc.ge;
