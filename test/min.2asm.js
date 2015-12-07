function asmFunc() {
 "use asm";
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
  wasm2asm_f32$1 = HEAPF32[k >> 2];
  wasm2asm_f32$0 = Math_fround(-wasm2asm_f32$1);
  n = wasm2asm_f32$0;
 }
 
}

