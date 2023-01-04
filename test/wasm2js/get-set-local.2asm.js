
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
 function $1($0, r, r$hi) {
  $0 = $0 | 0;
  r = r | 0;
  r$hi = r$hi | 0;
  var i64toi32_i32$0 = 0, $9$hi = 0;
  i64toi32_i32$0 = r$hi;
  i64toi32_i32$0 = 0;
  $9$hi = i64toi32_i32$0;
  i64toi32_i32$0 = r$hi;
  i64toi32_i32$0 = $9$hi;
  return ($0 | 0) == (r | 0) & (i64toi32_i32$0 | 0) == (r$hi | 0) | 0 | 0;
 }
 
 function legalstub$1($0, $1_1, $2) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  $2 = $2 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $12 = 0, $3 = 0, $5 = 0, $5$hi = 0, $8$hi = 0;
  $3 = $0;
  i64toi32_i32$0 = 0;
  $5 = $1_1;
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
  return $1($3 | 0, i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0 | 0;
 }
 
 return {
  "check_extend_ui32": legalstub$1
 };
}

var retasmFunc = asmFunc({
});
export var check_extend_ui32 = retasmFunc.check_extend_ui32;
