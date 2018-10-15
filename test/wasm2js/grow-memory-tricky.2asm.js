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
 var i64toi32_i32$HIGH_BITS = 0;
 function $0() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  wasm2js_i32$0 = 0;
  wasm2js_i32$1 = __wasm_grow_memory(1 | 0);
  HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
  return HEAPU32[0 >> 2] | 0 | 0;
 }
 
 function $1() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  wasm2js_i32$0 = 0;
  wasm2js_i32$1 = grow() | 0;
  HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
  return HEAPU32[0 >> 2] | 0 | 0;
 }
 
 function grow() {
  return __wasm_grow_memory(1 | 0) | 0;
 }
 
 function __wasm_grow_memory(pagesToAdd) {
  pagesToAdd = pagesToAdd | 0;
  var oldPages = __wasm_current_memory() | 0;
  var newPages = oldPages + pagesToAdd | 0;
  if ((oldPages < newPages) && (newPages < 65536)) {
   var newBuffer = new ArrayBuffer(Math_imul(newPages, 65536));
   var newHEAP8 = new global.Int8Array(newBuffer);
   newHEAP8.set(HEAP8);
   HEAP8 = newHEAP8;
   HEAP16 = new global.Int16Array(newBuffer);
   HEAP32 = new global.Int32Array(newBuffer);
   HEAPU8 = new global.Uint8Array(newBuffer);
   HEAPU16 = new global.Uint16Array(newBuffer);
   HEAPU32 = new global.Uint32Array(newBuffer);
   HEAPF32 = new global.Float32Array(newBuffer);
   HEAPF64 = new global.Float64Array(newBuffer);
   buffer = newBuffer;
  }
  return oldPages;
 }
 
 function __wasm_current_memory() {
  return buffer.byteLength / 65536 | 0;
 }
 
 return {
  memory: Object.create(Object.prototype, {
   grow: {
    value: __wasm_grow_memory
   }, 
   buffer: {
    get: function () {
     return buffer;
    }
    
   }
  }), 
  f1: $0, 
  f2: $1
 };
}

const memasmFunc = new ArrayBuffer(65536);
const retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export const memory = retasmFunc.memory;
export const f1 = retasmFunc.f1;
export const f2 = retasmFunc.f2;
