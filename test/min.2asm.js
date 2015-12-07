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
 function floats(f) {
  f = Math_fround(f);
  var t = Math_fround(0);
  return Math_fround(t + f);
 }
 
 function neg(k, p) {
  k = k | 0;
  p = p | 0;
  var n = Math_fround(0), wasm2asm_f32$1 = Math_fround(0), wasm2asm_f32$0 = Math_fround(0);
  HEAP32[k >> 2] = p;
  wasm2asm_f32$1 = Math_fround(HEAPF32[k >> 2]);
  wasm2asm_f32$0 = Math_fround(-wasm2asm_f32$1);
  n = wasm2asm_f32$0;
 }
 
}

