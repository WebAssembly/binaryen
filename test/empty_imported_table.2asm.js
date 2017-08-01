function asmFunc(global, env, buffer) {
 "use asm"
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
 var import$table$0 = env.table;
 function __ctz__i32(x) {
  x = x | 0
  var wasm2asm_i32$0 = 0;
  if ((x | 0) == (0 | 0)) wasm2asm_i32$0 = 32; else wasm2asm_i32$0 = 31 - Math_clz32(x ^ (x - 1 | 0) | 0) | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 return {
  
 };
}

