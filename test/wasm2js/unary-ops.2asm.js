
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
 var i64toi32_i32$HIGH_BITS = 0;
 function f0($0) {
  $0 = $0 | 0;
  return __wasm_popcnt_i32($0 | 0) | 0 | 0;
 }
 
 function f1($0, $0$hi, r, r$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  r = r | 0;
  r$hi = r$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, $3$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = __wasm_popcnt_i64($0 | 0, i64toi32_i32$0 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $3$hi = i64toi32_i32$1;
  i64toi32_i32$1 = r$hi;
  i64toi32_i32$1 = $3$hi;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = r$hi;
  return (i64toi32_i32$2 | 0) == (r | 0) & (i64toi32_i32$1 | 0) == (i64toi32_i32$0 | 0) | 0 | 0;
 }
 
 function f2($0, r, r$hi) {
  $0 = $0 | 0;
  r = r | 0;
  r$hi = r$hi | 0;
  var i64toi32_i32$0 = 0, $3$hi = 0;
  i64toi32_i32$0 = 0;
  $3$hi = i64toi32_i32$0;
  i64toi32_i32$0 = r$hi;
  i64toi32_i32$0 = $3$hi;
  return ($0 | 0) == (r | 0) & (i64toi32_i32$0 | 0) == (r$hi | 0) | 0 | 0;
 }
 
 function f3($0, r, r$hi) {
  $0 = $0 | 0;
  r = r | 0;
  r$hi = r$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, $3$hi = 0;
  i64toi32_i32$1 = $0;
  i64toi32_i32$0 = i64toi32_i32$1 >> 31 | 0;
  $3$hi = i64toi32_i32$0;
  i64toi32_i32$0 = r$hi;
  i64toi32_i32$0 = $3$hi;
  i64toi32_i32$1 = r$hi;
  return ($0 | 0) == (r | 0) & (i64toi32_i32$0 | 0) == (i64toi32_i32$1 | 0) | 0 | 0;
 }
 
 function f4($0, $0$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = $0$hi;
  return !($0 | i64toi32_i32$0 | 0) | 0;
 }
 
 function f5($0) {
  $0 = $0 | 0;
  return Math_clz32($0) | 0;
 }
 
 function f6($0) {
  $0 = $0 | 0;
  return __wasm_ctz_i32($0 | 0) | 0 | 0;
 }
 
 function f7($0, $0$hi, r, r$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  r = r | 0;
  r$hi = r$hi | 0;
  var i64toi32_i32$3 = 0, i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, $9 = 0, $3$hi = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$1 = $0;
  i64toi32_i32$3 = Math_clz32(i64toi32_i32$0);
  i64toi32_i32$2 = 0;
  if ((i64toi32_i32$3 | 0) == (32 | 0)) {
   $9 = Math_clz32(i64toi32_i32$1) + 32 | 0
  } else {
   $9 = i64toi32_i32$3
  }
  $3$hi = i64toi32_i32$2;
  i64toi32_i32$2 = r$hi;
  i64toi32_i32$2 = $3$hi;
  i64toi32_i32$1 = $9;
  i64toi32_i32$0 = r$hi;
  i64toi32_i32$3 = r;
  return (i64toi32_i32$1 | 0) == (i64toi32_i32$3 | 0) & (i64toi32_i32$2 | 0) == (i64toi32_i32$0 | 0) | 0 | 0;
 }
 
 function f8($0, $0$hi, r, r$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  r = r | 0;
  r$hi = r$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, $3$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = __wasm_ctz_i64($0 | 0, i64toi32_i32$0 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $3$hi = i64toi32_i32$1;
  i64toi32_i32$1 = r$hi;
  i64toi32_i32$1 = $3$hi;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = r$hi;
  return (i64toi32_i32$2 | 0) == (r | 0) & (i64toi32_i32$1 | 0) == (i64toi32_i32$0 | 0) | 0 | 0;
 }
 
 function legalstub$f1($0, $1, $2, $3) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2 = $2 | 0;
  $3 = $3 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $19 = 0, $20 = 0, $5 = 0, $5$hi = 0, $8$hi = 0, $9 = 0, $9$hi = 0, $11 = 0, $11$hi = 0, $14$hi = 0, $15 = 0, $15$hi = 0;
  i64toi32_i32$0 = 0;
  $5 = $0;
  $5$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $19 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $19 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $8$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $5$hi;
  i64toi32_i32$0 = $5;
  i64toi32_i32$2 = $8$hi;
  i64toi32_i32$3 = $19;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  $9 = i64toi32_i32$0 | i64toi32_i32$3 | 0;
  $9$hi = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  $11 = $2;
  $11$hi = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$1 = $3;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = i64toi32_i32$1 << i64toi32_i32$4 | 0;
   $20 = 0;
  } else {
   i64toi32_i32$0 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$1 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$2 << i64toi32_i32$4 | 0) | 0;
   $20 = i64toi32_i32$1 << i64toi32_i32$4 | 0;
  }
  $14$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $11$hi;
  i64toi32_i32$2 = $11;
  i64toi32_i32$1 = $14$hi;
  i64toi32_i32$3 = $20;
  i64toi32_i32$1 = i64toi32_i32$0 | i64toi32_i32$1 | 0;
  $15 = i64toi32_i32$2 | i64toi32_i32$3 | 0;
  $15$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $9$hi;
  i64toi32_i32$2 = $15$hi;
  return f1($9 | 0, i64toi32_i32$1 | 0, $15 | 0, i64toi32_i32$2 | 0) | 0 | 0;
 }
 
 function legalstub$f2($0, $1, $2) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2 = $2 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $12 = 0, $3 = 0, $5 = 0, $5$hi = 0, $8$hi = 0;
  $3 = $0;
  i64toi32_i32$0 = 0;
  $5 = $1;
  $5$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $2;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $12 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $12 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $8$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $5$hi;
  i64toi32_i32$0 = $5;
  i64toi32_i32$2 = $8$hi;
  i64toi32_i32$3 = $12;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  return f2($3 | 0, i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0 | 0;
 }
 
 function legalstub$f3($0, $1, $2) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2 = $2 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $12 = 0, $3 = 0, $5 = 0, $5$hi = 0, $8$hi = 0;
  $3 = $0;
  i64toi32_i32$0 = 0;
  $5 = $1;
  $5$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $2;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $12 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $12 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $8$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $5$hi;
  i64toi32_i32$0 = $5;
  i64toi32_i32$2 = $8$hi;
  i64toi32_i32$3 = $12;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  return f3($3 | 0, i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0 | 0;
 }
 
 function legalstub$f4($0, $1) {
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
  return f4(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0 | 0;
 }
 
 function legalstub$f7($0, $1, $2, $3) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2 = $2 | 0;
  $3 = $3 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $19 = 0, $20 = 0, $5 = 0, $5$hi = 0, $8$hi = 0, $9 = 0, $9$hi = 0, $11 = 0, $11$hi = 0, $14$hi = 0, $15 = 0, $15$hi = 0;
  i64toi32_i32$0 = 0;
  $5 = $0;
  $5$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $19 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $19 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $8$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $5$hi;
  i64toi32_i32$0 = $5;
  i64toi32_i32$2 = $8$hi;
  i64toi32_i32$3 = $19;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  $9 = i64toi32_i32$0 | i64toi32_i32$3 | 0;
  $9$hi = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  $11 = $2;
  $11$hi = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$1 = $3;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = i64toi32_i32$1 << i64toi32_i32$4 | 0;
   $20 = 0;
  } else {
   i64toi32_i32$0 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$1 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$2 << i64toi32_i32$4 | 0) | 0;
   $20 = i64toi32_i32$1 << i64toi32_i32$4 | 0;
  }
  $14$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $11$hi;
  i64toi32_i32$2 = $11;
  i64toi32_i32$1 = $14$hi;
  i64toi32_i32$3 = $20;
  i64toi32_i32$1 = i64toi32_i32$0 | i64toi32_i32$1 | 0;
  $15 = i64toi32_i32$2 | i64toi32_i32$3 | 0;
  $15$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $9$hi;
  i64toi32_i32$2 = $15$hi;
  return f7($9 | 0, i64toi32_i32$1 | 0, $15 | 0, i64toi32_i32$2 | 0) | 0 | 0;
 }
 
 function legalstub$f8($0, $1, $2, $3) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2 = $2 | 0;
  $3 = $3 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $19 = 0, $20 = 0, $5 = 0, $5$hi = 0, $8$hi = 0, $9 = 0, $9$hi = 0, $11 = 0, $11$hi = 0, $14$hi = 0, $15 = 0, $15$hi = 0;
  i64toi32_i32$0 = 0;
  $5 = $0;
  $5$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $19 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $19 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $8$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $5$hi;
  i64toi32_i32$0 = $5;
  i64toi32_i32$2 = $8$hi;
  i64toi32_i32$3 = $19;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  $9 = i64toi32_i32$0 | i64toi32_i32$3 | 0;
  $9$hi = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  $11 = $2;
  $11$hi = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$1 = $3;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = i64toi32_i32$1 << i64toi32_i32$4 | 0;
   $20 = 0;
  } else {
   i64toi32_i32$0 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$1 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$2 << i64toi32_i32$4 | 0) | 0;
   $20 = i64toi32_i32$1 << i64toi32_i32$4 | 0;
  }
  $14$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $11$hi;
  i64toi32_i32$2 = $11;
  i64toi32_i32$1 = $14$hi;
  i64toi32_i32$3 = $20;
  i64toi32_i32$1 = i64toi32_i32$0 | i64toi32_i32$1 | 0;
  $15 = i64toi32_i32$2 | i64toi32_i32$3 | 0;
  $15$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $9$hi;
  i64toi32_i32$2 = $15$hi;
  return f8($9 | 0, i64toi32_i32$1 | 0, $15 | 0, i64toi32_i32$2 | 0) | 0 | 0;
 }
 
 function __wasm_ctz_i32(var$0) {
  var$0 = var$0 | 0;
  if (var$0) {
   return 31 - Math_clz32((var$0 + -1 | 0) ^ var$0 | 0) | 0 | 0
  }
  return 32 | 0;
 }
 
 function __wasm_ctz_i64(var$0, var$0$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$3 = 0, i64toi32_i32$5 = 0, i64toi32_i32$4 = 0, i64toi32_i32$2 = 0, i64toi32_i32$1 = 0, $10 = 0, $5$hi = 0, $8$hi = 0;
  i64toi32_i32$0 = var$0$hi;
  if (!!(var$0 | i64toi32_i32$0 | 0)) {
   i64toi32_i32$2 = var$0;
   i64toi32_i32$1 = -1;
   i64toi32_i32$3 = -1;
   i64toi32_i32$4 = i64toi32_i32$2 + i64toi32_i32$3 | 0;
   i64toi32_i32$5 = i64toi32_i32$0 + i64toi32_i32$1 | 0;
   if (i64toi32_i32$4 >>> 0 < i64toi32_i32$3 >>> 0) {
    i64toi32_i32$5 = i64toi32_i32$5 + 1 | 0
   }
   $5$hi = i64toi32_i32$5;
   i64toi32_i32$5 = var$0$hi;
   i64toi32_i32$5 = $5$hi;
   i64toi32_i32$0 = i64toi32_i32$4;
   i64toi32_i32$2 = var$0$hi;
   i64toi32_i32$3 = var$0;
   i64toi32_i32$2 = i64toi32_i32$5 ^ i64toi32_i32$2 | 0;
   i64toi32_i32$0 = i64toi32_i32$0 ^ i64toi32_i32$3 | 0;
   i64toi32_i32$3 = Math_clz32(i64toi32_i32$2);
   i64toi32_i32$5 = 0;
   if ((i64toi32_i32$3 | 0) == (32 | 0)) {
    $10 = Math_clz32(i64toi32_i32$0) + 32 | 0
   } else {
    $10 = i64toi32_i32$3
   }
   $8$hi = i64toi32_i32$5;
   i64toi32_i32$5 = 0;
   i64toi32_i32$0 = 63;
   i64toi32_i32$2 = $8$hi;
   i64toi32_i32$3 = $10;
   i64toi32_i32$1 = i64toi32_i32$0 - i64toi32_i32$3 | 0;
   i64toi32_i32$4 = (i64toi32_i32$0 >>> 0 < i64toi32_i32$3 >>> 0) + i64toi32_i32$2 | 0;
   i64toi32_i32$4 = i64toi32_i32$5 - i64toi32_i32$4 | 0;
   i64toi32_i32$0 = i64toi32_i32$1;
   i64toi32_i32$HIGH_BITS = i64toi32_i32$4;
   return i64toi32_i32$0 | 0;
  }
  i64toi32_i32$0 = 0;
  i64toi32_i32$4 = 64;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$4 | 0;
 }
 
 function __wasm_popcnt_i32(var$0) {
  var$0 = var$0 | 0;
  var var$1 = 0, $5 = 0;
  label$1 : {
   label$2 : while (1) {
    $5 = var$1;
    if (!var$0) {
     break label$1
    }
    var$0 = var$0 & (var$0 - 1 | 0) | 0;
    var$1 = var$1 + 1 | 0;
    continue label$2;
   };
  }
  return $5 | 0;
 }
 
 function __wasm_popcnt_i64(var$0, var$0$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$2 = 0, i64toi32_i32$5 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, i64toi32_i32$1 = 0, var$1$hi = 0, var$1 = 0, $4 = 0, $5 = 0, $5$hi = 0, $9$hi = 0;
  label$1 : {
   label$2 : while (1) {
    i64toi32_i32$0 = var$1$hi;
    i64toi32_i32$0 = var$0$hi;
    $4 = !(var$0 | i64toi32_i32$0 | 0);
    i64toi32_i32$0 = var$1$hi;
    $5 = var$1;
    $5$hi = i64toi32_i32$0;
    if ($4) {
     break label$1
    }
    i64toi32_i32$0 = var$0$hi;
    i64toi32_i32$2 = var$0;
    i64toi32_i32$1 = 0;
    i64toi32_i32$3 = 1;
    i64toi32_i32$4 = i64toi32_i32$2 - i64toi32_i32$3 | 0;
    i64toi32_i32$5 = (i64toi32_i32$2 >>> 0 < i64toi32_i32$3 >>> 0) + i64toi32_i32$1 | 0;
    i64toi32_i32$5 = i64toi32_i32$0 - i64toi32_i32$5 | 0;
    $9$hi = i64toi32_i32$5;
    i64toi32_i32$5 = i64toi32_i32$0;
    i64toi32_i32$0 = i64toi32_i32$2;
    i64toi32_i32$2 = $9$hi;
    i64toi32_i32$3 = i64toi32_i32$4;
    i64toi32_i32$2 = i64toi32_i32$5 & i64toi32_i32$2 | 0;
    var$0 = i64toi32_i32$0 & i64toi32_i32$4 | 0;
    var$0$hi = i64toi32_i32$2;
    i64toi32_i32$2 = var$1$hi;
    i64toi32_i32$5 = var$1;
    i64toi32_i32$0 = 0;
    i64toi32_i32$3 = 1;
    i64toi32_i32$1 = i64toi32_i32$5 + i64toi32_i32$3 | 0;
    i64toi32_i32$4 = i64toi32_i32$2 + i64toi32_i32$0 | 0;
    if (i64toi32_i32$1 >>> 0 < i64toi32_i32$3 >>> 0) {
     i64toi32_i32$4 = i64toi32_i32$4 + 1 | 0
    }
    var$1 = i64toi32_i32$1;
    var$1$hi = i64toi32_i32$4;
    continue label$2;
   };
  }
  i64toi32_i32$4 = $5$hi;
  i64toi32_i32$5 = $5;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$4;
  return i64toi32_i32$5 | 0;
 }
 
 return {
  "i32_popcnt": f0, 
  "check_popcnt_i64": legalstub$f1, 
  "check_extend_ui32": legalstub$f2, 
  "check_extend_si32": legalstub$f3, 
  "check_eqz_i64": legalstub$f4, 
  "i32_clz": f5, 
  "i32_ctz": f6, 
  "check_clz_i64": legalstub$f7, 
  "check_ctz_i64": legalstub$f8
 };
}

var retasmFunc = asmFunc({
});
export var i32_popcnt = retasmFunc.i32_popcnt;
export var check_popcnt_i64 = retasmFunc.check_popcnt_i64;
export var check_extend_ui32 = retasmFunc.check_extend_ui32;
export var check_extend_si32 = retasmFunc.check_extend_si32;
export var check_eqz_i64 = retasmFunc.check_eqz_i64;
export var i32_clz = retasmFunc.i32_clz;
export var i32_ctz = retasmFunc.i32_ctz;
export var check_clz_i64 = retasmFunc.check_clz_i64;
export var check_ctz_i64 = retasmFunc.check_ctz_i64;
