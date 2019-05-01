import { setTempRet0 } from 'env';

function asmFunc(global, env, buffer) {
 "almost asm";
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
 var setTempRet0 = env.setTempRet0;
 var i64toi32_i32$HIGH_BITS = 0;
 function dummy() {
  
 }
 
 function $2() {
  
 }
 
 function h() {
  
 }
 
 function $23() {
  var $0 = 0;
  return $0 | 0;
 }
 
 function $24() {
  var $0 = 0, $1 = 0;
  i64toi32_i32$HIGH_BITS = $0;
  return $1 | 0;
 }
 
 function $25() {
  var $0 = Math_fround(0);
  return Math_fround($0);
 }
 
 function $26() {
  var $0 = 0.0;
  return +$0;
 }
 
 function $27() {
  var $0 = 0;
  return $0 | 0;
 }
 
 function $28() {
  var $0 = 0, $1 = 0;
  i64toi32_i32$HIGH_BITS = $0;
  return $1 | 0;
 }
 
 function $29() {
  var $0 = Math_fround(0);
  return Math_fround($0);
 }
 
 function $30() {
  var $0 = 0.0;
  return +$0;
 }
 
 function $31() {
  var $0 = 0.0, $1 = Math_fround(0), $2_1 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0;
  return +$0;
 }
 
 function $32($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  return $0 | 0;
 }
 
 function $33($0, $1, $2_1, $3) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2_1 = $2_1 | 0;
  $3 = $3 | 0;
  i64toi32_i32$HIGH_BITS = $1;
  return $0 | 0;
 }
 
 function $34($0, $1) {
  $0 = Math_fround($0);
  $1 = Math_fround($1);
  return Math_fround($0);
 }
 
 function $35($0, $1) {
  $0 = +$0;
  $1 = +$1;
  return +$0;
 }
 
 function $36($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  return $1 | 0;
 }
 
 function $37($0, $1, $2_1, $3) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2_1 = $2_1 | 0;
  $3 = $3 | 0;
  i64toi32_i32$HIGH_BITS = $3;
  return $2_1 | 0;
 }
 
 function $38($0, $1) {
  $0 = Math_fround($0);
  $1 = Math_fround($1);
  return Math_fround($1);
 }
 
 function $39($0, $1) {
  $0 = +$0;
  $1 = +$1;
  return +$1;
 }
 
 function $40($0, $1, $2_1, $3, $4, $5, $6) {
  $0 = Math_fround($0);
  $1 = $1 | 0;
  $2_1 = $2_1 | 0;
  $3 = $3 | 0;
  $4 = $4 | 0;
  $5 = +$5;
  $6 = $6 | 0;
  return +$5;
 }
 
 function $41() {
  
 }
 
 function $42() {
  dummy();
 }
 
 function $43() {
  return 77 | 0;
 }
 
 function $44() {
  i64toi32_i32$HIGH_BITS = 0;
  return 7777 | 0;
 }
 
 function $45() {
  return Math_fround(Math_fround(77.69999694824219));
 }
 
 function $46() {
  return +(77.77);
 }
 
 function $47() {
  dummy();
  dummy();
 }
 
 function $48() {
  dummy();
  return 77 | 0;
 }
 
 function $49() {
  return;
 }
 
 function $50() {
  return 78 | 0;
 }
 
 function $51() {
  i64toi32_i32$HIGH_BITS = 0;
  return 7878 | 0;
 }
 
 function $52() {
  return Math_fround(Math_fround(78.69999694824219));
 }
 
 function $53() {
  return +(78.78);
 }
 
 function $54() {
  dummy();
  return 77 | 0;
 }
 
 function $55() {
  
 }
 
 function $56() {
  var $0 = 0;
  fake_return_waka123 : {
   $0 = 79;
   break fake_return_waka123;
  }
  return $0 | 0;
 }
 
 function $57() {
  var $0 = 0, $1 = 0;
  fake_return_waka123 : {
   $0 = 0;
   $1 = 7979;
   break fake_return_waka123;
  }
  i64toi32_i32$HIGH_BITS = $0;
  return $1 | 0;
 }
 
 function $58() {
  var $0 = Math_fround(0);
  fake_return_waka123 : {
   $0 = Math_fround(79.9000015258789);
   break fake_return_waka123;
  }
  return Math_fround($0);
 }
 
 function $59() {
  var $0 = 0.0;
  fake_return_waka123 : {
   $0 = 79.79;
   break fake_return_waka123;
  }
  return +$0;
 }
 
 function $60() {
  var $0 = 0;
  fake_return_waka123 : {
   dummy();
   $0 = 77;
   break fake_return_waka123;
  }
  return $0 | 0;
 }
 
 function $61($0) {
  $0 = $0 | 0;
 }
 
 function $62($0) {
  $0 = $0 | 0;
  var $1 = 0;
  $1 = 50;
  fake_return_waka123 : {
   if ($0) {
    break fake_return_waka123
   }
   $1 = 51;
  }
  return $1 | 0;
 }
 
 function $63($0) {
  $0 = $0 | 0;
 }
 
 function $64($0) {
  $0 = $0 | 0;
  var $1 = 0;
  fake_return_waka123 : {
   $1 = 50;
   switch ($0 | 0) {
   default:
    break fake_return_waka123;
   };
  }
  return $1 | 0;
 }
 
 function $65($0) {
  $0 = $0 | 0;
 }
 
 function $66($0) {
  $0 = $0 | 0;
  var $1 = 0, $2_1 = 0;
  fake_return_waka123 : {
   block : {
    $1 = 50;
    $2_1 = $1;
    switch ($0 | 0) {
    case 1:
     break fake_return_waka123;
    default:
     break block;
    };
   }
   $1 = $2_1 + 2 | 0;
  }
  return $1 | 0;
 }
 
 function $67() {
  var $0 = 0;
  return $0 | 0;
 }
 
 function $68() {
  var $0 = 0, $1 = 0;
  i64toi32_i32$HIGH_BITS = $0;
  return $1 | 0;
 }
 
 function $69() {
  var $0 = Math_fround(0);
  return Math_fround($0);
 }
 
 function $70() {
  var $0 = 0.0;
  return +$0;
 }
 
 function empty_sig_1() {
  
 }
 
 function complex_sig_1($0, $1, $2_1, $3, $4, $5, $6, $7, $8, $9, $10) {
  $0 = +$0;
  $1 = $1 | 0;
  $2_1 = $2_1 | 0;
  $3 = +$3;
  $4 = $4 | 0;
  $5 = $5 | 0;
  $6 = +$6;
  $7 = $7 | 0;
  $8 = $8 | 0;
  $9 = Math_fround($9);
  $10 = $10 | 0;
 }
 
 function empty_sig_2() {
  
 }
 
 function complex_sig_3($0, $1, $2_1, $3, $4, $5, $6, $7, $8, $9, $10) {
  $0 = +$0;
  $1 = $1 | 0;
  $2_1 = $2_1 | 0;
  $3 = +$3;
  $4 = $4 | 0;
  $5 = $5 | 0;
  $6 = +$6;
  $7 = $7 | 0;
  $8 = $8 | 0;
  $9 = Math_fround($9);
  $10 = $10 | 0;
 }
 
 function $76() {
  FUNCTION_TABLE[1]();
  FUNCTION_TABLE[4]();
 }
 
 function $77() {
  var $0 = 0, $1 = 0, $2_1 = 0;
  $0 = 0;
  $1 = 0;
  $2_1 = 0;
  FUNCTION_TABLE[0](0.0, 0, $0, 0.0, 0, $1, 0.0, 0, $2_1, Math_fround(0.0), 0);
  $2_1 = 0;
  $1 = 0;
  $0 = 0;
  FUNCTION_TABLE[2](0.0, 0, $2_1, 0.0, 0, $1, 0.0, 0, $0, Math_fround(0.0), 0);
  $0 = 0;
  $1 = 0;
  $2_1 = 0;
  FUNCTION_TABLE[3](0.0, 0, $0, 0.0, 0, $1, 0.0, 0, $2_1, Math_fround(0.0), 0);
 }
 
 function $78() {
  FUNCTION_TABLE[1]();
 }
 
 function $79() {
  FUNCTION_TABLE[0](0.0, 0, 0, 0.0, 0, 0, 0.0, 0, 0, Math_fround(0.0), 0);
 }
 
 function legalstub$24() {
  var $0 = 0, $1 = 0, $2_1 = 0, $3 = 0, $4 = 0, $5 = 0;
  $0 = $24() | 0;
  $2_1 = i64toi32_i32$HIGH_BITS;
  $4 = $0;
  $5 = $2_1;
  $3 = 32;
  $1 = $3 & 31 | 0;
  if (32 >>> 0 <= ($3 & 63 | 0) >>> 0) {
   $0 = $2_1 >>> $1 | 0
  } else {
   $0 = (((1 << $1 | 0) - 1 | 0) & $2_1 | 0) << (32 - $1 | 0) | 0 | ($0 >>> $1 | 0) | 0
  }
  setTempRet0($0 | 0);
  return $4 | 0;
 }
 
 function legalstub$28() {
  var $0 = 0, $1 = 0, $2_1 = 0, $3 = 0, $4 = 0, $5 = 0;
  $0 = $28() | 0;
  $2_1 = i64toi32_i32$HIGH_BITS;
  $4 = $0;
  $5 = $2_1;
  $3 = 32;
  $1 = $3 & 31 | 0;
  if (32 >>> 0 <= ($3 & 63 | 0) >>> 0) {
   $0 = $2_1 >>> $1 | 0
  } else {
   $0 = (((1 << $1 | 0) - 1 | 0) & $2_1 | 0) << (32 - $1 | 0) | 0 | ($0 >>> $1 | 0) | 0
  }
  setTempRet0($0 | 0);
  return $4 | 0;
 }
 
 function legalstub$33($0, $1, $2_1, $3) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2_1 = $2_1 | 0;
  $3 = $3 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0;
  $6 = 0;
  $7 = $0;
  $8 = $6;
  $6 = 0;
  $5 = 32;
  $4 = $5 & 31 | 0;
  if (32 >>> 0 <= ($5 & 63 | 0) >>> 0) {
   {
    $0 = $1 << $4 | 0;
    $5 = 0;
   }
  } else {
   {
    $0 = ((1 << $4 | 0) - 1 | 0) & ($1 >>> (32 - $4 | 0) | 0) | 0 | ($6 << $4 | 0) | 0;
    $5 = $1 << $4 | 0;
   }
  }
  $1 = $0;
  $0 = $8;
  $6 = $7;
  $1 = $0 | $1 | 0;
  $9 = $6 | $5 | 0;
  $7 = $1;
  $1 = 0;
  $8 = $1;
  $1 = 0;
  $0 = $3;
  $5 = 32;
  $4 = $5 & 31 | 0;
  if (32 >>> 0 <= ($5 & 63 | 0) >>> 0) {
   {
    $6 = $0 << $4 | 0;
    $5 = 0;
   }
  } else {
   {
    $6 = ((1 << $4 | 0) - 1 | 0) & ($0 >>> (32 - $4 | 0) | 0) | 0 | ($1 << $4 | 0) | 0;
    $5 = $0 << $4 | 0;
   }
  }
  $0 = $6;
  $6 = $8;
  $1 = $2_1;
  $0 = $6 | $0 | 0;
  $2_1 = $1 | $5 | 0;
  $1 = $0;
  $0 = $7;
  $1 = $33($9 | 0, $0 | 0, $2_1 | 0, $1 | 0) | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  $3 = $1;
  $2_1 = $0;
  $6 = $1;
  $5 = 32;
  $4 = $5 & 31 | 0;
  if (32 >>> 0 <= ($5 & 63 | 0) >>> 0) {
   $0 = $0 >>> $4 | 0
  } else {
   $0 = (((1 << $4 | 0) - 1 | 0) & $0 | 0) << (32 - $4 | 0) | 0 | ($6 >>> $4 | 0) | 0
  }
  setTempRet0($0 | 0);
  return $3 | 0;
 }
 
 function legalstub$37($0, $1, $2_1, $3) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2_1 = $2_1 | 0;
  $3 = $3 | 0;
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0;
  $6 = 0;
  $7 = $0;
  $8 = $6;
  $6 = 0;
  $5 = 32;
  $4 = $5 & 31 | 0;
  if (32 >>> 0 <= ($5 & 63 | 0) >>> 0) {
   {
    $0 = $1 << $4 | 0;
    $5 = 0;
   }
  } else {
   {
    $0 = ((1 << $4 | 0) - 1 | 0) & ($1 >>> (32 - $4 | 0) | 0) | 0 | ($6 << $4 | 0) | 0;
    $5 = $1 << $4 | 0;
   }
  }
  $1 = $0;
  $0 = $8;
  $6 = $7;
  $1 = $0 | $1 | 0;
  $9 = $6 | $5 | 0;
  $7 = $1;
  $1 = 0;
  $8 = $1;
  $1 = 0;
  $0 = $3;
  $5 = 32;
  $4 = $5 & 31 | 0;
  if (32 >>> 0 <= ($5 & 63 | 0) >>> 0) {
   {
    $6 = $0 << $4 | 0;
    $5 = 0;
   }
  } else {
   {
    $6 = ((1 << $4 | 0) - 1 | 0) & ($0 >>> (32 - $4 | 0) | 0) | 0 | ($1 << $4 | 0) | 0;
    $5 = $0 << $4 | 0;
   }
  }
  $0 = $6;
  $6 = $8;
  $1 = $2_1;
  $0 = $6 | $0 | 0;
  $2_1 = $1 | $5 | 0;
  $1 = $0;
  $0 = $7;
  $1 = $37($9 | 0, $0 | 0, $2_1 | 0, $1 | 0) | 0;
  $0 = i64toi32_i32$HIGH_BITS;
  $3 = $1;
  $2_1 = $0;
  $6 = $1;
  $5 = 32;
  $4 = $5 & 31 | 0;
  if (32 >>> 0 <= ($5 & 63 | 0) >>> 0) {
   $0 = $0 >>> $4 | 0
  } else {
   $0 = (((1 << $4 | 0) - 1 | 0) & $0 | 0) << (32 - $4 | 0) | 0 | ($6 >>> $4 | 0) | 0
  }
  setTempRet0($0 | 0);
  return $3 | 0;
 }
 
 function legalstub$40($0, $1, $2_1, $3, $4, $5, $6) {
  $0 = Math_fround($0);
  $1 = $1 | 0;
  $2_1 = $2_1 | 0;
  $3 = $3 | 0;
  $4 = $4 | 0;
  $5 = +$5;
  $6 = $6 | 0;
  var $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0;
  $11 = $1;
  $7 = 0;
  $1 = $7;
  $7 = 0;
  $8 = 32;
  $9 = $8 & 31 | 0;
  if (32 >>> 0 <= ($8 & 63 | 0) >>> 0) {
   {
    $10 = $3 << $9 | 0;
    $8 = 0;
   }
  } else {
   {
    $10 = ((1 << $9 | 0) - 1 | 0) & ($3 >>> (32 - $9 | 0) | 0) | 0 | ($7 << $9 | 0) | 0;
    $8 = $3 << $9 | 0;
   }
  }
  $3 = $10;
  $10 = $1;
  $7 = $2_1;
  $3 = $10 | $3 | 0;
  return +(+$40(Math_fround($0), $11 | 0, $7 | $8 | 0 | 0, $3 | 0, $4 | 0, +$5, $6 | 0));
 }
 
 function legalstub$44() {
  var $0 = 0, $1 = 0, $2_1 = 0, $3 = 0, $4 = 0, $5 = 0;
  $0 = $44() | 0;
  $2_1 = i64toi32_i32$HIGH_BITS;
  $4 = $0;
  $5 = $2_1;
  $3 = 32;
  $1 = $3 & 31 | 0;
  if (32 >>> 0 <= ($3 & 63 | 0) >>> 0) {
   $0 = $2_1 >>> $1 | 0
  } else {
   $0 = (((1 << $1 | 0) - 1 | 0) & $2_1 | 0) << (32 - $1 | 0) | 0 | ($0 >>> $1 | 0) | 0
  }
  setTempRet0($0 | 0);
  return $4 | 0;
 }
 
 function legalstub$51() {
  var $0 = 0, $1 = 0, $2_1 = 0, $3 = 0, $4 = 0, $5 = 0;
  $0 = $51() | 0;
  $2_1 = i64toi32_i32$HIGH_BITS;
  $4 = $0;
  $5 = $2_1;
  $3 = 32;
  $1 = $3 & 31 | 0;
  if (32 >>> 0 <= ($3 & 63 | 0) >>> 0) {
   $0 = $2_1 >>> $1 | 0
  } else {
   $0 = (((1 << $1 | 0) - 1 | 0) & $2_1 | 0) << (32 - $1 | 0) | 0 | ($0 >>> $1 | 0) | 0
  }
  setTempRet0($0 | 0);
  return $4 | 0;
 }
 
 function legalstub$57() {
  var $0 = 0, $1 = 0, $2_1 = 0, $3 = 0, $4 = 0, $5 = 0;
  $0 = $57() | 0;
  $2_1 = i64toi32_i32$HIGH_BITS;
  $4 = $0;
  $5 = $2_1;
  $3 = 32;
  $1 = $3 & 31 | 0;
  if (32 >>> 0 <= ($3 & 63 | 0) >>> 0) {
   $0 = $2_1 >>> $1 | 0
  } else {
   $0 = (((1 << $1 | 0) - 1 | 0) & $2_1 | 0) << (32 - $1 | 0) | 0 | ($0 >>> $1 | 0) | 0
  }
  setTempRet0($0 | 0);
  return $4 | 0;
 }
 
 function legalstub$68() {
  var $0 = 0, $1 = 0, $2_1 = 0, $3 = 0, $4 = 0, $5 = 0;
  $0 = $68() | 0;
  $2_1 = i64toi32_i32$HIGH_BITS;
  $4 = $0;
  $5 = $2_1;
  $3 = 32;
  $1 = $3 & 31 | 0;
  if (32 >>> 0 <= ($3 & 63 | 0) >>> 0) {
   $0 = $2_1 >>> $1 | 0
  } else {
   $0 = (((1 << $1 | 0) - 1 | 0) & $2_1 | 0) << (32 - $1 | 0) | 0 | ($0 >>> $1 | 0) | 0
  }
  setTempRet0($0 | 0);
  return $4 | 0;
 }
 
 var FUNCTION_TABLE = [complex_sig_3, empty_sig_2, complex_sig_1, complex_sig_3, empty_sig_1];
 return {
  "f": $2, 
  "g": h, 
  "local_first_i32": $23, 
  "local_first_i64": legalstub$24, 
  "local_first_f32": $25, 
  "local_first_f64": $26, 
  "local_second_i32": $27, 
  "local_second_i64": legalstub$28, 
  "local_second_f32": $29, 
  "local_second_f64": $30, 
  "local_mixed": $31, 
  "param_first_i32": $32, 
  "param_first_i64": legalstub$33, 
  "param_first_f32": $34, 
  "param_first_f64": $35, 
  "param_second_i32": $36, 
  "param_second_i64": legalstub$37, 
  "param_second_f32": $38, 
  "param_second_f64": $39, 
  "param_mixed": legalstub$40, 
  "empty": $41, 
  "value_void": $42, 
  "value_i32": $43, 
  "value_i64": legalstub$44, 
  "value_f32": $45, 
  "value_f64": $46, 
  "value_block_void": $47, 
  "value_block_i32": $48, 
  "return_empty": $49, 
  "return_i32": $50, 
  "return_i64": legalstub$51, 
  "return_f32": $52, 
  "return_f64": $53, 
  "return_block_i32": $54, 
  "break_empty": $55, 
  "break_i32": $56, 
  "break_i64": legalstub$57, 
  "break_f32": $58, 
  "break_f64": $59, 
  "break_block_i32": $60, 
  "break_br_if_empty": $61, 
  "break_br_if_num": $62, 
  "break_br_table_empty": $63, 
  "break_br_table_num": $64, 
  "break_br_table_nested_empty": $65, 
  "break_br_table_nested_num": $66, 
  "init_local_i32": $67, 
  "init_local_i64": legalstub$68, 
  "init_local_f32": $69, 
  "init_local_f64": $70, 
  "signature_explicit_reused": $76, 
  "signature_implicit_reused": $77, 
  "signature_explicit_duplicate": $78, 
  "signature_implicit_duplicate": $79
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0},memasmFunc);
export var f = retasmFunc.f;
export var g = retasmFunc.g;
export var local_first_i32 = retasmFunc.local_first_i32;
export var local_first_i64 = retasmFunc.local_first_i64;
export var local_first_f32 = retasmFunc.local_first_f32;
export var local_first_f64 = retasmFunc.local_first_f64;
export var local_second_i32 = retasmFunc.local_second_i32;
export var local_second_i64 = retasmFunc.local_second_i64;
export var local_second_f32 = retasmFunc.local_second_f32;
export var local_second_f64 = retasmFunc.local_second_f64;
export var local_mixed = retasmFunc.local_mixed;
export var param_first_i32 = retasmFunc.param_first_i32;
export var param_first_i64 = retasmFunc.param_first_i64;
export var param_first_f32 = retasmFunc.param_first_f32;
export var param_first_f64 = retasmFunc.param_first_f64;
export var param_second_i32 = retasmFunc.param_second_i32;
export var param_second_i64 = retasmFunc.param_second_i64;
export var param_second_f32 = retasmFunc.param_second_f32;
export var param_second_f64 = retasmFunc.param_second_f64;
export var param_mixed = retasmFunc.param_mixed;
export var empty = retasmFunc.empty;
export var value_void = retasmFunc.value_void;
export var value_i32 = retasmFunc.value_i32;
export var value_i64 = retasmFunc.value_i64;
export var value_f32 = retasmFunc.value_f32;
export var value_f64 = retasmFunc.value_f64;
export var value_block_void = retasmFunc.value_block_void;
export var value_block_i32 = retasmFunc.value_block_i32;
export var return_empty = retasmFunc.return_empty;
export var return_i32 = retasmFunc.return_i32;
export var return_i64 = retasmFunc.return_i64;
export var return_f32 = retasmFunc.return_f32;
export var return_f64 = retasmFunc.return_f64;
export var return_block_i32 = retasmFunc.return_block_i32;
export var break_empty = retasmFunc.break_empty;
export var break_i32 = retasmFunc.break_i32;
export var break_i64 = retasmFunc.break_i64;
export var break_f32 = retasmFunc.break_f32;
export var break_f64 = retasmFunc.break_f64;
export var break_block_i32 = retasmFunc.break_block_i32;
export var break_br_if_empty = retasmFunc.break_br_if_empty;
export var break_br_if_num = retasmFunc.break_br_if_num;
export var break_br_table_empty = retasmFunc.break_br_table_empty;
export var break_br_table_num = retasmFunc.break_br_table_num;
export var break_br_table_nested_empty = retasmFunc.break_br_table_nested_empty;
export var break_br_table_nested_num = retasmFunc.break_br_table_nested_num;
export var init_local_i32 = retasmFunc.init_local_i32;
export var init_local_i64 = retasmFunc.init_local_i64;
export var init_local_f32 = retasmFunc.init_local_f32;
export var init_local_f64 = retasmFunc.init_local_f64;
export var signature_explicit_reused = retasmFunc.signature_explicit_reused;
export var signature_implicit_reused = retasmFunc.signature_implicit_reused;
export var signature_explicit_duplicate = retasmFunc.signature_explicit_duplicate;
export var signature_implicit_duplicate = retasmFunc.signature_implicit_duplicate;
