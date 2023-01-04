

  var scratchBuffer = new ArrayBuffer(16);
  var i32ScratchView = new Int32Array(scratchBuffer);
  var f32ScratchView = new Float32Array(scratchBuffer);
  var f64ScratchView = new Float64Array(scratchBuffer);
  
  function wasm2js_scratch_load_i32(index) {
    return i32ScratchView[index];
  }
      
  function wasm2js_scratch_store_i32(index, value) {
    i32ScratchView[index] = value;
  }
      
  function wasm2js_scratch_load_f64() {
    return f64ScratchView[0];
  }
      
  function wasm2js_scratch_store_f64(value) {
    f64ScratchView[0] = value;
  }
      
  function wasm2js_scratch_store_f32(value) {
    f32ScratchView[2] = value;
  }
      
  function wasm2js_scratch_load_f32() {
    return f32ScratchView[2];
  }
      
function asmFunc(imports) {
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
 function $1($0) {
  $0 = $0 | 0;
  return ((wasm2js_scratch_store_f32((wasm2js_scratch_store_i32(2, $0), wasm2js_scratch_load_f32())), wasm2js_scratch_load_i32(2)) | 0) == ($0 | 0) | 0;
 }
 
 function $2($0, $0$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$0 = 0, $3$hi = 0;
  i64toi32_i32$0 = $0$hi;
  wasm2js_scratch_store_i32(0 | 0, $0 | 0);
  wasm2js_scratch_store_i32(1 | 0, i64toi32_i32$0 | 0);
  wasm2js_scratch_store_f64(+(+wasm2js_scratch_load_f64()));
  i64toi32_i32$0 = wasm2js_scratch_load_i32(1 | 0) | 0;
  $3$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = $3$hi;
  return (wasm2js_scratch_load_i32(0 | 0) | 0 | 0) == ($0 | 0) & (i64toi32_i32$0 | 0) == ($0$hi | 0) | 0 | 0;
 }
 
 function legalstub$2($0, $1_1) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $10 = 0, $3 = 0, $3$hi = 0, $6$hi = 0;
  i64toi32_i32$0 = 0;
  $3 = $0;
  $3$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $10 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $10 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $6$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $3$hi;
  i64toi32_i32$0 = $3;
  i64toi32_i32$2 = $6$hi;
  i64toi32_i32$3 = $10;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  return $2(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0 | 0;
 }
 
 return {
  "i32_roundtrip": $1, 
  "i64_roundtrip": legalstub$2
 };
}

var retasmFunc = asmFunc({
});
export var i32_roundtrip = retasmFunc.i32_roundtrip;
export var i64_roundtrip = retasmFunc.i64_roundtrip;
