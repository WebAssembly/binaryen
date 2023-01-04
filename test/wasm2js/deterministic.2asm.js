
  var bufferView;
function wasm2js_trap() { throw new Error('abort'); }

function asmFunc(imports) {
 var env = imports.env;
 var memory = env.memory;
 var buffer = memory.buffer;
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
 var global$0 = -44;
 function $0() {
  if ((global$0 >>> 0) / ((HEAP32[0 >> 2] | 0) >>> 0) | 0) {
   wasm2js_trap()
  }
  return 1 | 0;
 }
 
 bufferView = HEAPU8;
 function __wasm_memory_size() {
  return buffer.byteLength / 65536 | 0;
 }
 
 return {
  "foo": $0
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({
  "env": {
    memory: { buffer : memasmFunc }
  },
});
export var foo = retasmFunc.foo;
