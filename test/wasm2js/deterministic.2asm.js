
function asmFunc(global, env, buffer) {
 var memory = env.memory;
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
 var global$0 = -44;
 function $0() {
  if ((global$0 >>> 0) / ((HEAP32[0 >> 2] | 0) >>> 0) | 0) {
   abort()
  }
  return 1 | 0;
 }
 
 function __wasm_memory_size() {
  return buffer.byteLength >>> 16 | 0;
 }
 
 return {
  "foo": $0
 };
}

var memasmFunc = new ArrayBuffer(65536);
var bufferView = new Uint8Array(memasmFunc);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array}, {abort() { throw new Error('abort'); }},memasmFunc);
export var foo = retasmFunc.foo;
