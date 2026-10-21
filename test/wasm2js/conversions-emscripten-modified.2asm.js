function instantiate(info) {
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
 // EMSCRIPTEN_START_FUNCS
;
 function $0(x) {
  x = Math_fround(x);
  return ~~x | 0;
 }
 
 function $1(x) {
  x = Math_fround(x);
  return ~~x >>> 0 | 0;
 }
 
 function $2(x) {
  x = +x;
  return ~~x | 0;
 }
 
 function $3(x) {
  x = +x;
  return ~~x >>> 0 | 0;
 }
 
 function $4(x) {
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
 
 function $5(x) {
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
 
 function $6(x) {
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
 
 function $7(x) {
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
 
 function legalstub$4($0_1) {
  $0_1 = Math_fround($0_1);
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $4(Math_fround($0_1)) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
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
  return $1_1 | 0;
 }
 
 function legalstub$5($0_1) {
  $0_1 = Math_fround($0_1);
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $5(Math_fround($0_1)) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
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
  return $1_1 | 0;
 }
 
 function legalstub$6($0_1) {
  $0_1 = +$0_1;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $6(+$0_1) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
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
  return $1_1 | 0;
 }
 
 function legalstub$7($0_1) {
  $0_1 = +$0_1;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $7(+$0_1) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
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
  return $1_1 | 0;
 }
 
 // EMSCRIPTEN_END_FUNCS
;
 return {
  "i32_trunc_sat_f32_s": $0, 
  "i32_trunc_sat_f32_u": $1, 
  "i32_trunc_sat_f64_s": $2, 
  "i32_trunc_sat_f64_u": $3, 
  "i64_trunc_sat_f32_s": legalstub$4, 
  "i64_trunc_sat_f32_u": legalstub$5, 
  "i64_trunc_sat_f64_s": legalstub$6, 
  "i64_trunc_sat_f64_u": legalstub$7
 };
}

  return asmFunc(info);
}
