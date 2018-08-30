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
 var i64toi32_i32$HIGH_BITS = 0;
 function $0() {
  return (HEAPF32[0] = Math_fround(nan), HEAP32[0] | 0) | 0;
 }
 
 function $1() {
  return (HEAPF32[0] = Math_fround(nan), HEAP32[0] | 0) | 0;
 }
 
 function $2() {
  return (HEAPF32[0] = Math_fround(-nan), HEAP32[0] | 0) | 0;
 }
 
 function $3() {
  return (HEAPF32[0] = Math_fround(nan), HEAP32[0] | 0) | 0;
 }
 
 function $4() {
  return (HEAPF32[0] = Math_fround(nan), HEAP32[0] | 0) | 0;
 }
 
 function $5() {
  return (HEAPF32[0] = Math_fround(-nan), HEAP32[0] | 0) | 0;
 }
 
 function $6() {
  return (HEAPF32[0] = Math_fround(nan), HEAP32[0] | 0) | 0;
 }
 
 function $7() {
  return (HEAPF32[0] = Math_fround(nan), HEAP32[0] | 0) | 0;
 }
 
 function $8() {
  return (HEAPF32[0] = Math_fround(-nan), HEAP32[0] | 0) | 0;
 }
 
 function $9() {
  return (HEAPF32[0] = Math_fround(infinity), HEAP32[0] | 0) | 0;
 }
 
 function $10() {
  return (HEAPF32[0] = Math_fround(infinity), HEAP32[0] | 0) | 0;
 }
 
 function $11() {
  return (HEAPF32[0] = Math_fround(-infinity), HEAP32[0] | 0) | 0;
 }
 
 function $12() {
  return (HEAPF32[0] = Math_fround(0.0), HEAP32[0] | 0) | 0;
 }
 
 function $13() {
  return (HEAPF32[0] = Math_fround(0.0), HEAP32[0] | 0) | 0;
 }
 
 function $14() {
  return (HEAPF32[0] = Math_fround(-0.0), HEAP32[0] | 0) | 0;
 }
 
 function $15() {
  return (HEAPF32[0] = Math_fround(6.2831854820251465), HEAP32[0] | 0) | 0;
 }
 
 function $16() {
  return (HEAPF32[0] = Math_fround(1.401298464324817e-45), HEAP32[0] | 0) | 0;
 }
 
 function $17() {
  return (HEAPF32[0] = Math_fround(1.1754943508222875e-38), HEAP32[0] | 0) | 0;
 }
 
 function $18() {
  return (HEAPF32[0] = Math_fround(3402823466385288598117041.0e14), HEAP32[0] | 0) | 0;
 }
 
 function $19() {
  return (HEAPF32[0] = Math_fround(1.1754942106924411e-38), HEAP32[0] | 0) | 0;
 }
 
 function $20() {
  return (HEAPF32[0] = Math_fround(1024.0), HEAP32[0] | 0) | 0;
 }
 
 function $21() {
  return (HEAPF32[0] = Math_fround(0.0), HEAP32[0] | 0) | 0;
 }
 
 function $22() {
  return (HEAPF32[0] = Math_fround(0.0), HEAP32[0] | 0) | 0;
 }
 
 function $23() {
  return (HEAPF32[0] = Math_fround(-0.0), HEAP32[0] | 0) | 0;
 }
 
 function $24() {
  return (HEAPF32[0] = Math_fround(6.2831854820251465), HEAP32[0] | 0) | 0;
 }
 
 function $25() {
  return (HEAPF32[0] = Math_fround(1.401298464324817e-45), HEAP32[0] | 0) | 0;
 }
 
 function $26() {
  return (HEAPF32[0] = Math_fround(1.1754943508222875e-38), HEAP32[0] | 0) | 0;
 }
 
 function $27() {
  return (HEAPF32[0] = Math_fround(1.1754942106924411e-38), HEAP32[0] | 0) | 0;
 }
 
 function $28() {
  return (HEAPF32[0] = Math_fround(3402823466385288598117041.0e14), HEAP32[0] | 0) | 0;
 }
 
 function $29() {
  return (HEAPF32[0] = Math_fround(1.0e10), HEAP32[0] | 0) | 0;
 }
 
 function $30() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = nan;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $31() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = nan;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $32() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = -nan;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $33() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = nan;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $34() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = nan;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $35() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = -nan;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $36() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = nan;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $37() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = nan;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $38() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = -nan;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $39() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = infinity;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $40() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = infinity;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $41() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = -infinity;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $42() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = 0.0;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $43() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = 0.0;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $44() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = -0.0;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $45() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = 6.283185307179586;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $46() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = 5.0e-324;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $47() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = 2.2250738585072014e-308;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $48() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = 2.225073858507201e-308;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $49() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = 1797693134862315708145274.0e284;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $50() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = 1267650600228229401496703.0e6;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $51() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = 0.0;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $52() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = 0.0;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $53() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = -0.0;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $54() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = 6.283185307179586;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $55() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = 5.0e-324;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $56() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = 2.2250738585072014e-308;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $57() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = 2.225073858507201e-308;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $58() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = 1797693134862315708145274.0e284;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $59() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0;
  wasm2js_i32$0 = 0;
  wasm2js_f64$0 = 1.e+100;
  HEAPF64[wasm2js_i32$0 >> 3] = wasm2js_f64$0;
  i64toi32_i32$0 = HEAP32[(0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = HEAP32[0 >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 return {
  f32_nan: $0, 
  f32_positive_nan: $1, 
  f32_negative_nan: $2, 
  f32_plain_nan: $3, 
  f32_informally_known_as_plain_snan: $4, 
  f32_all_ones_nan: $5, 
  f32_misc_nan: $6, 
  f32_misc_positive_nan: $7, 
  f32_misc_negative_nan: $8, 
  f32_infinity: $9, 
  f32_positive_infinity: $10, 
  f32_negative_infinity: $11, 
  f32_zero: $12, 
  f32_positive_zero: $13, 
  f32_negative_zero: $14, 
  f32_misc: $15, 
  f32_min_positive: $16, 
  f32_min_normal: $17, 
  f32_max_finite: $18, 
  f32_max_subnormal: $19, 
  f32_trailing_dot: $20, 
  f32_dec_zero: $21, 
  f32_dec_positive_zero: $22, 
  f32_dec_negative_zero: $23, 
  f32_dec_misc: $24, 
  f32_dec_min_positive: $25, 
  f32_dec_min_normal: $26, 
  f32_dec_max_subnormal: $27, 
  f32_dec_max_finite: $28, 
  f32_dec_trailing_dot: $29, 
  f64_nan: $30, 
  f64_positive_nan: $31, 
  f64_negative_nan: $32, 
  f64_plain_nan: $33, 
  f64_informally_known_as_plain_snan: $34, 
  f64_all_ones_nan: $35, 
  f64_misc_nan: $36, 
  f64_misc_positive_nan: $37, 
  f64_misc_negative_nan: $38, 
  f64_infinity: $39, 
  f64_positive_infinity: $40, 
  f64_negative_infinity: $41, 
  f64_zero: $42, 
  f64_positive_zero: $43, 
  f64_negative_zero: $44, 
  f64_misc: $45, 
  f64_min_positive: $46, 
  f64_min_normal: $47, 
  f64_max_subnormal: $48, 
  f64_max_finite: $49, 
  f64_trailing_dot: $50, 
  f64_dec_zero: $51, 
  f64_dec_positive_zero: $52, 
  f64_dec_negative_zero: $53, 
  f64_dec_misc: $54, 
  f64_dec_min_positive: $55, 
  f64_dec_min_normal: $56, 
  f64_dec_max_subnormal: $57, 
  f64_dec_max_finite: $58, 
  f64_dec_trailing_dot: $59
 };
}

const memasmFunc = new ArrayBuffer(65536);
const retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export const f32_nan = retasmFunc.f32_nan;
export const f32_positive_nan = retasmFunc.f32_positive_nan;
export const f32_negative_nan = retasmFunc.f32_negative_nan;
export const f32_plain_nan = retasmFunc.f32_plain_nan;
export const f32_informally_known_as_plain_snan = retasmFunc.f32_informally_known_as_plain_snan;
export const f32_all_ones_nan = retasmFunc.f32_all_ones_nan;
export const f32_misc_nan = retasmFunc.f32_misc_nan;
export const f32_misc_positive_nan = retasmFunc.f32_misc_positive_nan;
export const f32_misc_negative_nan = retasmFunc.f32_misc_negative_nan;
export const f32_infinity = retasmFunc.f32_infinity;
export const f32_positive_infinity = retasmFunc.f32_positive_infinity;
export const f32_negative_infinity = retasmFunc.f32_negative_infinity;
export const f32_zero = retasmFunc.f32_zero;
export const f32_positive_zero = retasmFunc.f32_positive_zero;
export const f32_negative_zero = retasmFunc.f32_negative_zero;
export const f32_misc = retasmFunc.f32_misc;
export const f32_min_positive = retasmFunc.f32_min_positive;
export const f32_min_normal = retasmFunc.f32_min_normal;
export const f32_max_finite = retasmFunc.f32_max_finite;
export const f32_max_subnormal = retasmFunc.f32_max_subnormal;
export const f32_trailing_dot = retasmFunc.f32_trailing_dot;
export const f32_dec_zero = retasmFunc.f32_dec_zero;
export const f32_dec_positive_zero = retasmFunc.f32_dec_positive_zero;
export const f32_dec_negative_zero = retasmFunc.f32_dec_negative_zero;
export const f32_dec_misc = retasmFunc.f32_dec_misc;
export const f32_dec_min_positive = retasmFunc.f32_dec_min_positive;
export const f32_dec_min_normal = retasmFunc.f32_dec_min_normal;
export const f32_dec_max_subnormal = retasmFunc.f32_dec_max_subnormal;
export const f32_dec_max_finite = retasmFunc.f32_dec_max_finite;
export const f32_dec_trailing_dot = retasmFunc.f32_dec_trailing_dot;
export const f64_nan = retasmFunc.f64_nan;
export const f64_positive_nan = retasmFunc.f64_positive_nan;
export const f64_negative_nan = retasmFunc.f64_negative_nan;
export const f64_plain_nan = retasmFunc.f64_plain_nan;
export const f64_informally_known_as_plain_snan = retasmFunc.f64_informally_known_as_plain_snan;
export const f64_all_ones_nan = retasmFunc.f64_all_ones_nan;
export const f64_misc_nan = retasmFunc.f64_misc_nan;
export const f64_misc_positive_nan = retasmFunc.f64_misc_positive_nan;
export const f64_misc_negative_nan = retasmFunc.f64_misc_negative_nan;
export const f64_infinity = retasmFunc.f64_infinity;
export const f64_positive_infinity = retasmFunc.f64_positive_infinity;
export const f64_negative_infinity = retasmFunc.f64_negative_infinity;
export const f64_zero = retasmFunc.f64_zero;
export const f64_positive_zero = retasmFunc.f64_positive_zero;
export const f64_negative_zero = retasmFunc.f64_negative_zero;
export const f64_misc = retasmFunc.f64_misc;
export const f64_min_positive = retasmFunc.f64_min_positive;
export const f64_min_normal = retasmFunc.f64_min_normal;
export const f64_max_subnormal = retasmFunc.f64_max_subnormal;
export const f64_max_finite = retasmFunc.f64_max_finite;
export const f64_trailing_dot = retasmFunc.f64_trailing_dot;
export const f64_dec_zero = retasmFunc.f64_dec_zero;
export const f64_dec_positive_zero = retasmFunc.f64_dec_positive_zero;
export const f64_dec_negative_zero = retasmFunc.f64_dec_negative_zero;
export const f64_dec_misc = retasmFunc.f64_dec_misc;
export const f64_dec_min_positive = retasmFunc.f64_dec_min_positive;
export const f64_dec_min_normal = retasmFunc.f64_dec_min_normal;
export const f64_dec_max_subnormal = retasmFunc.f64_dec_max_subnormal;
export const f64_dec_max_finite = retasmFunc.f64_dec_max_finite;
export const f64_dec_trailing_dot = retasmFunc.f64_dec_trailing_dot;
