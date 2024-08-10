import * as env from 'env';


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
 var env = imports.env;
 var setTempRet0 = env.setTempRet0;
 var i64toi32_i32$HIGH_BITS = 0;
 function f0(x) {
  x = x | 0;
  var i64toi32_i32$1 = 0, i64toi32_i32$0 = 0;
  i64toi32_i32$1 = x;
  i64toi32_i32$0 = i64toi32_i32$1 >> 31 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function f1(x) {
  x = x | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return x | 0;
 }
 
 function f2(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  return x | 0;
 }
 
 function f3(x) {
  x = Math_fround(x);
  return ~~x | 0;
 }
 
 function f4(x) {
  x = Math_fround(x);
  return ~~x >>> 0 | 0;
 }
 
 function f5(x) {
  x = +x;
  return ~~x | 0;
 }
 
 function f6(x) {
  x = +x;
  return ~~x >>> 0 | 0;
 }
 
 function f7(x) {
  x = Math_fround(x);
  var i64toi32_i32$0 = Math_fround(0), $4 = 0, $5 = 0, i64toi32_i32$1 = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = x;
  if (Math_fround(Math_abs(i64toi32_i32$0)) >= Math_fround(1.0)) {
   if (i64toi32_i32$0 > Math_fround(0.0)) {
    $4 = ~~Math_fround(Math_min(Math_fround(Math_floor(Math_fround(i64toi32_i32$0 / Math_fround(4294967296.0)))), Math_fround(Math_fround(4294967296.0) - Math_fround(1.0)))) >>> 0
   } else {
    $4 = ~~Math_fround(Math_ceil(Math_fround(Math_fround(i64toi32_i32$0 - Math_fround(~~i64toi32_i32$0 >>> 0 >>> 0)) / Math_fround(4294967296.0)))) >>> 0
   }
   $5 = $4;
  } else {
   $5 = 0
  }
  i64toi32_i32$1 = $5;
  i64toi32_i32$2 = ~~i64toi32_i32$0 >>> 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$2 | 0;
 }
 
 function f8(x) {
  x = Math_fround(x);
  var i64toi32_i32$0 = Math_fround(0), $4 = 0, $5 = 0, i64toi32_i32$1 = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = x;
  if (Math_fround(Math_abs(i64toi32_i32$0)) >= Math_fround(1.0)) {
   if (i64toi32_i32$0 > Math_fround(0.0)) {
    $4 = ~~Math_fround(Math_min(Math_fround(Math_floor(Math_fround(i64toi32_i32$0 / Math_fround(4294967296.0)))), Math_fround(Math_fround(4294967296.0) - Math_fround(1.0)))) >>> 0
   } else {
    $4 = ~~Math_fround(Math_ceil(Math_fround(Math_fround(i64toi32_i32$0 - Math_fround(~~i64toi32_i32$0 >>> 0 >>> 0)) / Math_fround(4294967296.0)))) >>> 0
   }
   $5 = $4;
  } else {
   $5 = 0
  }
  i64toi32_i32$1 = $5;
  i64toi32_i32$2 = ~~i64toi32_i32$0 >>> 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$2 | 0;
 }
 
 function f9(x) {
  x = +x;
  var i64toi32_i32$0 = 0.0, $4 = 0, $5 = 0, i64toi32_i32$1 = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = x;
  if (Math_abs(i64toi32_i32$0) >= 1.0) {
   if (i64toi32_i32$0 > 0.0) {
    $4 = ~~Math_min(Math_floor(i64toi32_i32$0 / 4294967296.0), 4294967296.0 - 1.0) >>> 0
   } else {
    $4 = ~~Math_ceil((i64toi32_i32$0 - +(~~i64toi32_i32$0 >>> 0 >>> 0)) / 4294967296.0) >>> 0
   }
   $5 = $4;
  } else {
   $5 = 0
  }
  i64toi32_i32$1 = $5;
  i64toi32_i32$2 = ~~i64toi32_i32$0 >>> 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$2 | 0;
 }
 
 function f10(x) {
  x = +x;
  var i64toi32_i32$0 = 0.0, $4 = 0, $5 = 0, i64toi32_i32$1 = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = x;
  if (Math_abs(i64toi32_i32$0) >= 1.0) {
   if (i64toi32_i32$0 > 0.0) {
    $4 = ~~Math_min(Math_floor(i64toi32_i32$0 / 4294967296.0), 4294967296.0 - 1.0) >>> 0
   } else {
    $4 = ~~Math_ceil((i64toi32_i32$0 - +(~~i64toi32_i32$0 >>> 0 >>> 0)) / 4294967296.0) >>> 0
   }
   $5 = $4;
  } else {
   $5 = 0
  }
  i64toi32_i32$1 = $5;
  i64toi32_i32$2 = ~~i64toi32_i32$0 >>> 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$2 | 0;
 }
 
 function f11(x) {
  x = x | 0;
  return Math_fround(Math_fround(x | 0));
 }
 
 function f12(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = x$hi;
  return Math_fround(Math_fround(+(x >>> 0) + 4294967296.0 * +(i64toi32_i32$0 | 0)));
 }
 
 function f13(x) {
  x = x | 0;
  return +(+(x | 0));
 }
 
 function f14(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = x$hi;
  return +(+(x >>> 0) + 4294967296.0 * +(i64toi32_i32$0 | 0));
 }
 
 function f15(x) {
  x = x | 0;
  return Math_fround(Math_fround(x >>> 0));
 }
 
 function f16(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = x$hi;
  return Math_fround(Math_fround(+(x >>> 0) + 4294967296.0 * +(i64toi32_i32$0 >>> 0)));
 }
 
 function f17(x) {
  x = x | 0;
  return +(+(x >>> 0));
 }
 
 function f18(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = x$hi;
  return +(+(x >>> 0) + 4294967296.0 * +(i64toi32_i32$0 >>> 0));
 }
 
 function f19(x) {
  x = Math_fround(x);
  return +(+x);
 }
 
 function f20(x) {
  x = +x;
  return Math_fround(Math_fround(x));
 }
 
 function f21(x) {
  x = x | 0;
  return Math_fround((wasm2js_scratch_store_i32(2, x), wasm2js_scratch_load_f32()));
 }
 
 function f22(x, x$hi) {
  x = x | 0;
  x$hi = x$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = x$hi;
  wasm2js_scratch_store_i32(0 | 0, x | 0);
  wasm2js_scratch_store_i32(1 | 0, i64toi32_i32$0 | 0);
  return +(+wasm2js_scratch_load_f64());
 }
 
 function f23(x) {
  x = Math_fround(x);
  return (wasm2js_scratch_store_f32(x), wasm2js_scratch_load_i32(2)) | 0;
 }
 
 function f24(x) {
  x = +x;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  wasm2js_scratch_store_f64(+x);
  i64toi32_i32$0 = wasm2js_scratch_load_i32(1 | 0) | 0;
  i64toi32_i32$1 = wasm2js_scratch_load_i32(0 | 0) | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 function legalstub$f0($0) {
  $0 = $0 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8 = 0, $1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = f0($0 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1 | 0;
 }
 
 function legalstub$f1($0) {
  $0 = $0 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8 = 0, $1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = f1($0 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1 | 0;
 }
 
 function legalstub$f2($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $10 = 0, $3 = 0, $3$hi = 0, $6$hi = 0;
  i64toi32_i32$0 = 0;
  $3 = $0;
  $3$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1;
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
  return f2(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0 | 0;
 }
 
 function legalstub$f7($0) {
  $0 = Math_fround($0);
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8 = 0, $1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = f7(Math_fround($0)) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1 | 0;
 }
 
 function legalstub$f8($0) {
  $0 = Math_fround($0);
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8 = 0, $1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = f8(Math_fround($0)) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1 | 0;
 }
 
 function legalstub$f9($0) {
  $0 = +$0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8 = 0, $1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = f9(+$0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1 | 0;
 }
 
 function legalstub$f10($0) {
  $0 = +$0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8 = 0, $1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = f10(+$0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1 | 0;
 }
 
 function legalstub$f12($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $10 = 0, $3 = 0, $3$hi = 0, $6$hi = 0;
  i64toi32_i32$0 = 0;
  $3 = $0;
  $3$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1;
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
  return Math_fround(Math_fround(f12(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0)));
 }
 
 function legalstub$f14($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $10 = 0, $3 = 0, $3$hi = 0, $6$hi = 0;
  i64toi32_i32$0 = 0;
  $3 = $0;
  $3$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1;
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
  return +(+f14(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0));
 }
 
 function legalstub$f16($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $10 = 0, $3 = 0, $3$hi = 0, $6$hi = 0;
  i64toi32_i32$0 = 0;
  $3 = $0;
  $3$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1;
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
  return Math_fround(Math_fround(f16(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0)));
 }
 
 function legalstub$f18($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $10 = 0, $3 = 0, $3$hi = 0, $6$hi = 0;
  i64toi32_i32$0 = 0;
  $3 = $0;
  $3$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1;
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
  return +(+f18(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0));
 }
 
 function legalstub$f22($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $10 = 0, $3 = 0, $3$hi = 0, $6$hi = 0;
  i64toi32_i32$0 = 0;
  $3 = $0;
  $3$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1;
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
  return +(+f22(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0));
 }
 
 function legalstub$f24($0) {
  $0 = +$0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8 = 0, $1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = f24(+$0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1 | 0;
 }
 
 return {
  "i64_extend_s_i32": legalstub$f0, 
  "i64_extend_u_i32": legalstub$f1, 
  "i32_wrap_i64": legalstub$f2, 
  "i32_trunc_s_f32": f3, 
  "i32_trunc_u_f32": f4, 
  "i32_trunc_s_f64": f5, 
  "i32_trunc_u_f64": f6, 
  "i64_trunc_s_f32": legalstub$f7, 
  "i64_trunc_u_f32": legalstub$f8, 
  "i64_trunc_s_f64": legalstub$f9, 
  "i64_trunc_u_f64": legalstub$f10, 
  "f32_convert_s_i32": f11, 
  "f32_convert_s_i64": legalstub$f12, 
  "f64_convert_s_i32": f13, 
  "f64_convert_s_i64": legalstub$f14, 
  "f32_convert_u_i32": f15, 
  "f32_convert_u_i64": legalstub$f16, 
  "f64_convert_u_i32": f17, 
  "f64_convert_u_i64": legalstub$f18, 
  "f64_promote_f32": f19, 
  "f32_demote_f64": f20, 
  "f32_reinterpret_i32": f21, 
  "f64_reinterpret_i64": legalstub$f22, 
  "i32_reinterpret_f32": f23, 
  "i64_reinterpret_f64": legalstub$f24
 };
}

var retasmFunc = asmFunc({
  "env": env,
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
