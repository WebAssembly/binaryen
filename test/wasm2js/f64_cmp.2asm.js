
function asmFunc(global, env, buffer) {
 var HEAP8 = new Int8Array(buffer);
 var HEAP16 = new Int16Array(buffer);
 var HEAP32 = new Int32Array(buffer);
 var HEAPU8 = new Uint8Array(buffer);
 var HEAPU16 = new Uint16Array(buffer);
 var HEAPU32 = new Uint32Array(buffer);
 var HEAPF32 = new Float32Array(buffer);
 var HEAPF64 = new Float64Array(buffer);
 var Math_imul = Math.imul;
 var Math_fround = Math.fround;
 var Math_abs = Math.abs;
 var Math_clz32 = Math.clz32;
 var Math_min = Math.min;
 var Math_max = Math.max;
 var Math_floor = Math.floor;
 var Math_ceil = Math.ceil;
 var Math_sqrt = Math.sqrt;
 var abort = env.abort;
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
var retasmFunc = asmFunc({}, {abort() { throw new Error('abort'); }},memasmFunc);
export var eq = retasmFunc.eq;
export var ne = retasmFunc.ne;
export var lt = retasmFunc.lt;
export var le = retasmFunc.le;
export var gt = retasmFunc.gt;
export var ge = retasmFunc.ge;
