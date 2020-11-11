
function asmFunc(env) {
 var buffer = new ArrayBuffer(65536);
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
 var Math_trunc = Math.trunc;
 var Math_sqrt = Math.sqrt;
 var abort = env.abort;
 var nan = NaN;
 var infinity = Infinity;
 function $0() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  (wasm2js_i32$0 = 0, wasm2js_i32$1 = __wasm_memory_grow(1 | 0)), HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
  return HEAP32[0 >> 2] | 0 | 0;
 }
 
 function $1() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0;
  (wasm2js_i32$0 = 0, wasm2js_i32$1 = grow() | 0), HEAP32[wasm2js_i32$0 >> 2] = wasm2js_i32$1;
  return HEAP32[0 >> 2] | 0 | 0;
 }
 
 function grow() {
  return __wasm_memory_grow(1 | 0) | 0;
 }
 
 function __wasm_memory_size() {
  return buffer.byteLength / 65536 | 0;
 }
 
 function __wasm_memory_grow(pagesToAdd) {
  pagesToAdd = pagesToAdd | 0;
  var oldPages = __wasm_memory_size() | 0;
  var newPages = oldPages + pagesToAdd | 0;
  if ((oldPages < newPages) && (newPages < 65536)) {
   var newBuffer = new ArrayBuffer(Math_imul(newPages, 65536));
   var newHEAP8 = new Int8Array(newBuffer);
   newHEAP8.set(HEAP8);
   HEAP8 = new Int8Array(newBuffer);
   HEAP16 = new Int16Array(newBuffer);
   HEAP32 = new Int32Array(newBuffer);
   HEAPU8 = new Uint8Array(newBuffer);
   HEAPU16 = new Uint16Array(newBuffer);
   HEAPU32 = new Uint32Array(newBuffer);
   HEAPF32 = new Float32Array(newBuffer);
   HEAPF64 = new Float64Array(newBuffer);
   buffer = newBuffer;
  }
  return oldPages;
 }
 
 return {
  "memory": Object.create(Object.prototype, {
   "grow": {
    "value": __wasm_memory_grow
   }, 
   "buffer": {
    "get": function () {
     return buffer;
    }
    
   }
  }), 
  "f1": $0, 
  "f2": $1
 };
}

var retasmFunc = asmFunc(  { abort: function() { throw new Error('abort'); }
  });
export var memory = retasmFunc.memory;
export var f1 = retasmFunc.f1;
export var f2 = retasmFunc.f2;
