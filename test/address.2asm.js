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
 var print = env.print;
 function good(i) {
  i = i | 0;
  var wasm2asm_i32$0 = 0;
  print(HEAPU8[i >> 0] | 0 | 0);
  print(HEAPU8[(i + 1 | 0) >> 0] | 0 | 0);
  print(HEAPU8[(i + 2 | 0) >> 0] | 0 | 0);
  print(HEAPU8[(i + 25 | 0) >> 0] | 0 | 0);
  print(HEAPU16[i >> 1] | 0 | 0);
  print((wasm2asm_i32$0 = i, HEAPU8[wasm2asm_i32$0 >> 0] | 0 | 0 | (HEAPU8[(wasm2asm_i32$0 + 1 | 0) >> 0] | 0 | 0) << 8) | 0);
  print((wasm2asm_i32$0 = i, HEAPU8[(wasm2asm_i32$0 + 1 | 0) >> 0] | 0 | 0 | (HEAPU8[(wasm2asm_i32$0 + 2 | 0) >> 0] | 0 | 0) << 8) | 0);
  print(HEAPU16[(i + 2 | 0) >> 1] | 0 | 0);
  print((wasm2asm_i32$0 = i, HEAPU8[(wasm2asm_i32$0 + 25 | 0) >> 0] | 0 | 0 | (HEAPU8[(wasm2asm_i32$0 + 26 | 0) >> 0] | 0 | 0) << 8) | 0);
  print(HEAPU32[i >> 2] | 0 | 0);
  print((wasm2asm_i32$0 = i, HEAPU8[(wasm2asm_i32$0 + 1 | 0) >> 0] | 0 | 0 | (HEAPU8[(wasm2asm_i32$0 + 2 | 0) >> 0] | 0 | 0) << 8 | (HEAPU8[(wasm2asm_i32$0 + 3 | 0) >> 0] | 0 | 0) << 16 | (HEAPU8[(wasm2asm_i32$0 + 4 | 0) >> 0] | 0 | 0) << 24) | 0);
  print((wasm2asm_i32$0 = i, HEAPU8[(wasm2asm_i32$0 + 2 | 0) >> 0] | 0 | 0 | (HEAPU8[(wasm2asm_i32$0 + 3 | 0) >> 0] | 0 | 0) << 8 | (HEAPU8[(wasm2asm_i32$0 + 4 | 0) >> 0] | 0 | 0) << 16 | (HEAPU8[(wasm2asm_i32$0 + 5 | 0) >> 0] | 0 | 0) << 24) | 0);
  print((wasm2asm_i32$0 = i, HEAPU8[(wasm2asm_i32$0 + 25 | 0) >> 0] | 0 | 0 | (HEAPU8[(wasm2asm_i32$0 + 26 | 0) >> 0] | 0 | 0) << 8 | (HEAPU8[(wasm2asm_i32$0 + 27 | 0) >> 0] | 0 | 0) << 16 | (HEAPU8[(wasm2asm_i32$0 + 28 | 0) >> 0] | 0 | 0) << 24) | 0);
 }
 
 function bad2(i) {
  i = i | 0;
  HEAPU32[(i + 4294967295 | 0) >> 2] | 0
 }
 
 return {
  good: good, 
  bad2: bad2
 };
}

