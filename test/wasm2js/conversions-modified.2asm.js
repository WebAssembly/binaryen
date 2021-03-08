import { setTempRet0 } from 'env';


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
      
  function wasm2js_scratch_load_f32() {
    return f32ScratchView[2];
  }
      
  function wasm2js_scratch_store_f32(value) {
    f32ScratchView[2] = value;
  }
      
function asmFunc(env) {
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
 var abort = env.abort;
 var nan = NaN;
 var infinity = Infinity;
 var setTempRet0 = env.setTempRet0;
 var i64toi32_i32$HIGH_BITS = 0;
 function $0(x) {
  x = x | 0;
  var i64toi32_i32$1 = 0, i64toi32_i32$0 = 0;
  i64toi32_i32$1 = x;
  i64toi32_i32$0 = i64toi32_i32$1 >> 31 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function $1(x) {
  x = x | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return x | 0;
 }
 
 function $2(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  return x | 0;
 }
 
 function $3(x) {
  x = Math_fround(x);
  return ~~x | 0;
 }
 
 function $4(x) {
  x = Math_fround(x);
  return ~~x >>> 0 | 0;
 }
 
 function $5(x) {
  x = +x;
  return ~~x | 0;
 }
 
 function $6(x) {
  x = +x;
  return ~~x >>> 0 | 0;
 }
 
 function $7(x) {
  x = Math_fround(x);
  var i64toi32_i32$0 = Math_fround(0), $4_1 = 0, $5_1 = 0, i64toi32_i32$1 = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = x;
  if (Math_fround(Math_abs(i64toi32_i32$0)) >= Math_fround(1.0)) {
   if (i64toi32_i32$0 > Math_fround(0.0)) {
    $4_1 = ~~Math_fround(Math_min(Math_fround(Math_floor(Math_fround(i64toi32_i32$0 / Math_fround(4294967296.0)))), Math_fround(Math_fround(4294967296.0) - Math_fround(1.0)))) >>> 0
   } else {
    $4_1 = ~~Math_fround(Math_ceil(Math_fround(Math_fround(i64toi32_i32$0 - Math_fround(~~i64toi32_i32$0 >>> 0 >>> 0)) / Math_fround(4294967296.0)))) >>> 0
   }
   $5_1 = $4_1;
  } else {
   $5_1 = 0
  }
  i64toi32_i32$1 = $5_1;
  i64toi32_i32$2 = ~~i64toi32_i32$0 >>> 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$2 | 0;
 }
 
 function $8(x) {
  x = Math_fround(x);
  var i64toi32_i32$0 = Math_fround(0), $4_1 = 0, $5_1 = 0, i64toi32_i32$1 = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = x;
  if (Math_fround(Math_abs(i64toi32_i32$0)) >= Math_fround(1.0)) {
   if (i64toi32_i32$0 > Math_fround(0.0)) {
    $4_1 = ~~Math_fround(Math_min(Math_fround(Math_floor(Math_fround(i64toi32_i32$0 / Math_fround(4294967296.0)))), Math_fround(Math_fround(4294967296.0) - Math_fround(1.0)))) >>> 0
   } else {
    $4_1 = ~~Math_fround(Math_ceil(Math_fround(Math_fround(i64toi32_i32$0 - Math_fround(~~i64toi32_i32$0 >>> 0 >>> 0)) / Math_fround(4294967296.0)))) >>> 0
   }
   $5_1 = $4_1;
  } else {
   $5_1 = 0
  }
  i64toi32_i32$1 = $5_1;
  i64toi32_i32$2 = ~~i64toi32_i32$0 >>> 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$2 | 0;
 }
 
 function $9(x) {
  x = +x;
  var i64toi32_i32$0 = 0.0, $4_1 = 0, $5_1 = 0, i64toi32_i32$1 = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = x;
  if (Math_abs(i64toi32_i32$0) >= 1.0) {
   if (i64toi32_i32$0 > 0.0) {
    $4_1 = ~~Math_min(Math_floor(i64toi32_i32$0 / 4294967296.0), 4294967296.0 - 1.0) >>> 0
   } else {
    $4_1 = ~~Math_ceil((i64toi32_i32$0 - +(~~i64toi32_i32$0 >>> 0 >>> 0)) / 4294967296.0) >>> 0
   }
   $5_1 = $4_1;
  } else {
   $5_1 = 0
  }
  i64toi32_i32$1 = $5_1;
  i64toi32_i32$2 = ~~i64toi32_i32$0 >>> 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$2 | 0;
 }
 
 function $10(x) {
  x = +x;
  var i64toi32_i32$0 = 0.0, $4_1 = 0, $5_1 = 0, i64toi32_i32$1 = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = x;
  if (Math_abs(i64toi32_i32$0) >= 1.0) {
   if (i64toi32_i32$0 > 0.0) {
    $4_1 = ~~Math_min(Math_floor(i64toi32_i32$0 / 4294967296.0), 4294967296.0 - 1.0) >>> 0
   } else {
    $4_1 = ~~Math_ceil((i64toi32_i32$0 - +(~~i64toi32_i32$0 >>> 0 >>> 0)) / 4294967296.0) >>> 0
   }
   $5_1 = $4_1;
  } else {
   $5_1 = 0
  }
  i64toi32_i32$1 = $5_1;
  i64toi32_i32$2 = ~~i64toi32_i32$0 >>> 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$2 | 0;
 }
 
 function $11(x) {
  x = x | 0;
  return Math_fround(Math_fround(x | 0));
 }
 
 function $12(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = x$hi;
  return Math_fround(Math_fround(+(x >>> 0) + 4294967296.0 * +(i64toi32_i32$0 | 0)));
 }
 
 function $13(x) {
  x = x | 0;
  return +(+(x | 0));
 }
 
 function $14(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = x$hi;
  return +(+(x >>> 0) + 4294967296.0 * +(i64toi32_i32$0 | 0));
 }
 
 function $15(x) {
  x = x | 0;
  return Math_fround(Math_fround(x >>> 0));
 }
 
 function $16(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = x$hi;
  return Math_fround(Math_fround(+(x >>> 0) + 4294967296.0 * +(i64toi32_i32$0 >>> 0)));
 }
 
 function $17(x) {
  x = x | 0;
  return +(+(x >>> 0));
 }
 
 function $18(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = x$hi;
  return +(+(x >>> 0) + 4294967296.0 * +(i64toi32_i32$0 >>> 0));
 }
 
 function $19(x) {
  x = Math_fround(x);
  return +(+x);
 }
 
 function $20(x) {
  x = +x;
  return Math_fround(Math_fround(x));
 }
 
 function $21(x) {
  x = x | 0;
  return Math_fround((wasm2js_scratch_store_i32(2, x), wasm2js_scratch_load_f32()));
 }
 
 function $22(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = x$hi;
  wasm2js_scratch_store_i32(0 | 0, x | 0);
  wasm2js_scratch_store_i32(1 | 0, i64toi32_i32$0 | 0);
  return +(+wasm2js_scratch_load_f64());
 }
 
 function $23(x) {
  x = Math_fround(x);
  return (wasm2js_scratch_store_f32(x), wasm2js_scratch_load_i32(2)) | 0;
 }
 
 function $24(x) {
  x = +x;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  wasm2js_scratch_store_f64(+x);
  i64toi32_i32$0 = wasm2js_scratch_load_i32(1 | 0) | 0;
  i64toi32_i32$1 = wasm2js_scratch_load_i32(0 | 0) | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function legalstub$0($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $0($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$1($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $1($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $10_1 = 0, $3_1 = 0, $3$hi = 0, $6$hi = 0;
  i64toi32_i32$0 = 0;
  $3_1 = $0_1;
  $3$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $10_1 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $10_1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $6$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $3$hi;
  i64toi32_i32$0 = $3_1;
  i64toi32_i32$2 = $6$hi;
  i64toi32_i32$3 = $10_1;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  return $2(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0 | 0;
 }
 
 function legalstub$7($0_1) {
  $0_1 = Math_fround($0_1);
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $7(Math_fround($0_1)) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$8($0_1) {
  $0_1 = Math_fround($0_1);
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $8(Math_fround($0_1)) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$9($0_1) {
  $0_1 = +$0_1;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $9(+$0_1) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$10($0_1) {
  $0_1 = +$0_1;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $10(+$0_1) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$12($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $10_1 = 0, $3_1 = 0, $3$hi = 0, $6$hi = 0;
  i64toi32_i32$0 = 0;
  $3_1 = $0_1;
  $3$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $10_1 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $10_1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $6$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $3$hi;
  i64toi32_i32$0 = $3_1;
  i64toi32_i32$2 = $6$hi;
  i64toi32_i32$3 = $10_1;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  return Math_fround(Math_fround($12(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0)));
 }
 
 function legalstub$14($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $10_1 = 0, $3_1 = 0, $3$hi = 0, $6$hi = 0;
  i64toi32_i32$0 = 0;
  $3_1 = $0_1;
  $3$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $10_1 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $10_1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $6$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $3$hi;
  i64toi32_i32$0 = $3_1;
  i64toi32_i32$2 = $6$hi;
  i64toi32_i32$3 = $10_1;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  return +(+$14(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0));
 }
 
 function legalstub$16($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $10_1 = 0, $3_1 = 0, $3$hi = 0, $6$hi = 0;
  i64toi32_i32$0 = 0;
  $3_1 = $0_1;
  $3$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $10_1 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $10_1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $6$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $3$hi;
  i64toi32_i32$0 = $3_1;
  i64toi32_i32$2 = $6$hi;
  i64toi32_i32$3 = $10_1;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  return Math_fround(Math_fround($16(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0)));
 }
 
 function legalstub$18($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $10_1 = 0, $3_1 = 0, $3$hi = 0, $6$hi = 0;
  i64toi32_i32$0 = 0;
  $3_1 = $0_1;
  $3$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $10_1 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $10_1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $6$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $3$hi;
  i64toi32_i32$0 = $3_1;
  i64toi32_i32$2 = $6$hi;
  i64toi32_i32$3 = $10_1;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  return +(+$18(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0));
 }
 
 function legalstub$22($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $10_1 = 0, $3_1 = 0, $3$hi = 0, $6$hi = 0;
  i64toi32_i32$0 = 0;
  $3_1 = $0_1;
  $3$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $10_1 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $10_1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $6$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $3$hi;
  i64toi32_i32$0 = $3_1;
  i64toi32_i32$2 = $6$hi;
  i64toi32_i32$3 = $10_1;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  return +(+$22(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0));
 }
 
 function legalstub$24($0_1) {
  $0_1 = +$0_1;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $24(+$0_1) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 return {
  "i64_extend_s_i32": legalstub$0, 
  "i64_extend_u_i32": legalstub$1, 
  "i32_wrap_i64": legalstub$2, 
  "i32_trunc_s_f32": $3, 
  "i32_trunc_u_f32": $4, 
  "i32_trunc_s_f64": $5, 
  "i32_trunc_u_f64": $6, 
  "i64_trunc_s_f32": legalstub$7, 
  "i64_trunc_u_f32": legalstub$8, 
  "i64_trunc_s_f64": legalstub$9, 
  "i64_trunc_u_f64": legalstub$10, 
  "f32_convert_s_i32": $11, 
  "f32_convert_s_i64": legalstub$12, 
  "f64_convert_s_i32": $13, 
  "f64_convert_s_i64": legalstub$14, 
  "f32_convert_u_i32": $15, 
  "f32_convert_u_i64": legalstub$16, 
  "f64_convert_u_i32": $17, 
  "f64_convert_u_i64": legalstub$18, 
  "f64_promote_f32": $19, 
  "f32_demote_f64": $20, 
  "f32_reinterpret_i32": $21, 
  "f64_reinterpret_i64": legalstub$22, 
  "i32_reinterpret_f32": $23, 
  "i64_reinterpret_f64": legalstub$24
 };
}

var retasmFunc = asmFunc(  { abort: function() { throw new Error('abort'); },
    setTempRet0
  });
export var i64_extend_s_i32 = retasmFunc.i64_extend_s_i32;
export var i64_extend_u_i32 = retasmFunc.i64_extend_u_i32;
export var i32_wrap_i64 = retasmFunc.i32_wrap_i64;
export var i32_trunc_s_f32 = retasmFunc.i32_trunc_s_f32;
export var i32_trunc_u_f32 = retasmFunc.i32_trunc_u_f32;
export var i32_trunc_s_f64 = retasmFunc.i32_trunc_s_f64;
export var i32_trunc_u_f64 = retasmFunc.i32_trunc_u_f64;
export var i64_trunc_s_f32 = retasmFunc.i64_trunc_s_f32;
export var i64_trunc_u_f32 = retasmFunc.i64_trunc_u_f32;
export var i64_trunc_s_f64 = retasmFunc.i64_trunc_s_f64;
export var i64_trunc_u_f64 = retasmFunc.i64_trunc_u_f64;
export var f32_convert_s_i32 = retasmFunc.f32_convert_s_i32;
export var f32_convert_s_i64 = retasmFunc.f32_convert_s_i64;
export var f64_convert_s_i32 = retasmFunc.f64_convert_s_i32;
export var f64_convert_s_i64 = retasmFunc.f64_convert_s_i64;
export var f32_convert_u_i32 = retasmFunc.f32_convert_u_i32;
export var f32_convert_u_i64 = retasmFunc.f32_convert_u_i64;
export var f64_convert_u_i32 = retasmFunc.f64_convert_u_i32;
export var f64_convert_u_i64 = retasmFunc.f64_convert_u_i64;
export var f64_promote_f32 = retasmFunc.f64_promote_f32;
export var f32_demote_f64 = retasmFunc.f32_demote_f64;
export var f32_reinterpret_i32 = retasmFunc.f32_reinterpret_i32;
export var f64_reinterpret_i64 = retasmFunc.f64_reinterpret_i64;
export var i32_reinterpret_f32 = retasmFunc.i32_reinterpret_f32;
export var i64_reinterpret_f64 = retasmFunc.i64_reinterpret_f64;
