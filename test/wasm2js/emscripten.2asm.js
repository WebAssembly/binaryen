function instantiate(asmLibraryArg, wasmMemory, wasmTable) {

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
 var syscall$6 = env.__syscall6;
 var syscall$54 = env.__syscall54;
 var global$0 = 5243904;
 var i64toi32_i32$HIGH_BITS = 0;
 // EMSCRIPTEN_START_FUNCS;
 function main() {
  var wasm2js_i32$0 = 0;
  syscall$6(1 | 0, 2 | 0) | 0;
  syscall$54(3 | 0, 4 | 0) | 0;
  wasm2js_i32$0 = HEAP32[(0 + 1030 | 0) >> 2] | 0;
  FUNCTION_TABLE_v[wasm2js_i32$0 & 3]();
 }
 
 function other() {
  main();
 }
 
 function foo() {
  abort();
 }
 
 function bar() {
  
 }
 
 // EMSCRIPTEN_END_FUNCS;
 var FUNCTION_TABLE_v = [foo, foo, bar, foo];
 return {
  main: main, 
  other: other
 };
}

return asmFunc(
  {
    'env': asmLibraryArg,
    'global': {
      'Int8Array': Int8Array,
      'Int16Array': Int16Array,
      'Int32Array': Int32Array,
      'Uint8Array': Uint8Array,
      'Uint16Array': Uint16Array,
      'Uint32Array': Uint32Array,
      'Float32Array': Float32Array,
      'Float64Array': Float64Array,
      'NaN': NaN,
      'Infinity': Infinity,
      'Math': Math
    }
  },
  wasmMemory.buffer
)

}