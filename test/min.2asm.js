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
 function floats(f) {
  f = Math_fround(f);
  var t = Math_fround(0);
  return Math_fround(Math_fround(t + f));
 }
 
 function neg(k, p) {
  k = k | 0;
  p = p | 0;
  var n = Math_fround(0), wasm2asm_f32$1 = Math_fround(0), wasm2asm_f32$0 = Math_fround(0);
  block0 : {
   HEAP32[k >> 2] = p;
   wasm2asm_f32$1 = Math_fround(HEAPF32[k >> 2]);
  }
  wasm2asm_f32$0 = Math_fround(-wasm2asm_f32$1);
  n = wasm2asm_f32$0;
  return Math_fround(wasm2asm_f32$0);
 }
 
 function littleswitch(x) {
  x = x | 0;
  var wasm2asm_i32$0 = 0;
  topmost : {
   switch$0 : {
    switch (x - 1 | 0) {
    case 1:
     wasm2asm_i32$0 = 2;
     break topmost;
    default:
     wasm2asm_i32$0 = 1;
     break topmost;
    }
   }
   wasm2asm_i32$0 = 0;
  }
  return wasm2asm_i32$0 | 0;
 }
 
 function f1(i1, i2, i3) {
  i1 = i1 | 0;
  i2 = i2 | 0;
  i3 = i3 | 0;
  var wasm2asm_i32$0 = 0;
  topmost : {
   wasm2asm_i32$0 = i3;
  }
  return wasm2asm_i32$0 | 0;
 }
 
 return {
  floats: floats
 };
}

