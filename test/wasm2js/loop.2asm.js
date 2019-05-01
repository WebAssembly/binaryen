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
 
 function $1() {
  
 }
 
 function $2() {
  return 7 | 0;
 }
 
 function $3() {
  dummy();
  dummy();
  dummy();
  dummy();
  dummy();
  dummy();
  dummy();
  return 8 | 0;
 }
 
 function $4() {
  dummy();
  dummy();
  return 9 | 0;
 }
 
 function $5() {
  dummy();
  return 150 | 0;
 }
 
 function $6() {
  dummy();
  return __wasm_ctz_i32(13 | 0) | 0 | 0;
 }
 
 function $7() {
  dummy();
  dummy();
  return Math_imul(3, 4) | 0;
 }
 
 function $8() {
  dummy();
  return !13 | 0;
 }
 
 function $9() {
  dummy();
  dummy();
  return Math_fround(3.0) > Math_fround(3.0) | 0;
 }
 
 function $10() {
  block : {
   loop_in : while (1) break block;
  }
  block48 : {
   if (1) {
    break block48
   }
   abort();
  }
  block50 : {
   switch (0 | 0) {
   default:
    break block50;
   };
  }
  block52 : {
   switch (1 | 0) {
   default:
    break block52;
   };
  }
  return 19 | 0;
 }
 
 function $11() {
  var $0 = 0;
  block : {
   loop_in : while (1) {
    $0 = 18;
    break block;
   };
  }
  return $0 | 0;
 }
 
 function $12() {
  var $0 = 0;
  block : {
   $0 = 18;
   break block;
  }
  return $0 | 0;
 }
 
 function $13() {
  var $0 = 0, $1_1 = 0;
  $0 = 0;
  block : {
   $1_1 = 1;
   break block;
  }
  $0 = $0 + $1_1 | 0;
  block55 : {
   $1_1 = 2;
   break block55;
  }
  $0 = $0 + $1_1 | 0;
  block60 : {
   $1_1 = 4;
   break block60;
  }
  $0 = $0 + $1_1 | 0;
  block62 : {
   $1_1 = 8;
   break block62;
  }
  $0 = $0 + $1_1 | 0;
  block64 : {
   $1_1 = 16;
   break block64;
  }
  $0 = $0 + $1_1 | 0;
  return $0 | 0;
 }
 
 function $14() {
  var $0 = 0;
  $0 = 0;
  loop_in : while (1) continue loop_in;
 }
 
 function fx() {
  var $0 = 0;
  block : {
   $0 = 1;
   $0 = Math_imul($0, 3);
   $0 = $0 - 5 | 0;
   $0 = Math_imul($0, 7);
   break block;
  }
  return ($0 | 0) == (-14 | 0) | 0;
 }
 
 function $16($0, $1_1) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0, $6_1 = 0;
  $2_1 = 0;
  $4_1 = 1;
  $3_1 = $2_1;
  block : {
   loop_in : while (1) {
    $2_1 = $1_1;
    if (!($0 | $2_1 | 0)) {
     break block
    }
    $2_1 = $1_1;
    $5_1 = __wasm_i64_mul($0 | 0, $2_1 | 0, $4_1 | 0, $3_1 | 0) | 0;
    $2_1 = i64toi32_i32$HIGH_BITS;
    $4_1 = $5_1;
    $3_1 = $2_1;
    $2_1 = $1_1;
    $5_1 = 0;
    $6_1 = 1;
    $1_1 = ($0 >>> 0 < $6_1 >>> 0) + $5_1 | 0;
    $1_1 = $2_1 - $1_1 | 0;
    $0 = $0 - $6_1 | 0;
    continue loop_in;
   };
  }
  $1_1 = $3_1;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $4_1 | 0;
 }
 
 function $17($0, $1_1) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0, $6_1 = 0, $7_1 = 0;
  $2_1 = 0;
  $7_1 = 1;
  $4_1 = $2_1;
  $2_1 = 0;
  $5_1 = 2;
  $3_1 = $2_1;
  block : {
   loop_in : while (1) {
    $2_1 = $3_1;
    $6_1 = $1_1;
    if ($2_1 >>> 0 > $6_1 >>> 0 | (($2_1 | 0) == ($6_1 | 0) & $5_1 >>> 0 > $0 >>> 0 | 0) | 0) {
     break block
    }
    $2_1 = $3_1;
    $2_1 = __wasm_i64_mul($7_1 | 0, $4_1 | 0, $5_1 | 0, $2_1 | 0) | 0;
    $7_1 = $2_1;
    $4_1 = i64toi32_i32$HIGH_BITS;
    $2_1 = 0;
    $6_1 = 1;
    $5_1 = $5_1 + $6_1 | 0;
    $3_1 = $3_1 + $2_1 | 0;
    if ($5_1 >>> 0 < $6_1 >>> 0) {
     $3_1 = $3_1 + 1 | 0
    }
    continue loop_in;
   };
  }
  i64toi32_i32$HIGH_BITS = $4_1;
  return $7_1 | 0;
 }
 
 function $18($0, $1_1) {
  $0 = Math_fround($0);
  $1_1 = Math_fround($1_1);
  var $2_1 = Math_fround(0), $3_1 = Math_fround(0);
  block : {
   loop_in : while (1) {
    if ($0 == Math_fround(0.0)) {
     break block
    }
    $2_1 = $1_1;
    block71 : {
     loop_in72 : while (1) {
      if ($2_1 == Math_fround(0.0)) {
       break block71
      }
      if ($2_1 < Math_fround(0.0)) {
       break block
      }
      $3_1 = Math_fround($3_1 + $2_1);
      $2_1 = Math_fround($2_1 - Math_fround(2.0));
      continue loop_in72;
     };
    }
    $3_1 = Math_fround($3_1 / $0);
    $0 = Math_fround($0 - Math_fround(1.0));
    continue loop_in;
   };
  }
  return Math_fround($3_1);
 }
 
 function legalstub$16($0, $1_1) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0, $6_1 = 0;
  $3_1 = 0;
  $5_1 = $0;
  $6_1 = $3_1;
  $3_1 = 0;
  $4_1 = 32;
  $2_1 = $4_1 & 31 | 0;
  if (32 >>> 0 <= ($4_1 & 63 | 0) >>> 0) {
   {
    $0 = $1_1 << $2_1 | 0;
    $4_1 = 0;
   }
  } else {
   {
    $0 = ((1 << $2_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $2_1 | 0) | 0) | 0 | ($3_1 << $2_1 | 0) | 0;
    $4_1 = $1_1 << $2_1 | 0;
   }
  }
  $1_1 = $0;
  $0 = $6_1;
  $3_1 = $5_1;
  $1_1 = $0 | $1_1 | 0;
  $1_1 = $16($3_1 | $4_1 | 0 | 0, $1_1 | 0) | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  $6_1 = $1_1;
  $5_1 = $3_1;
  $0 = $1_1;
  $4_1 = 32;
  $2_1 = $4_1 & 31 | 0;
  if (32 >>> 0 <= ($4_1 & 63 | 0) >>> 0) {
   $0 = $3_1 >>> $2_1 | 0
  } else {
   $0 = (((1 << $2_1 | 0) - 1 | 0) & $3_1 | 0) << (32 - $2_1 | 0) | 0 | ($0 >>> $2_1 | 0) | 0
  }
  setTempRet0($0 | 0);
  return $6_1 | 0;
 }
 
 function legalstub$17($0, $1_1) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0, $6_1 = 0;
  $3_1 = 0;
  $5_1 = $0;
  $6_1 = $3_1;
  $3_1 = 0;
  $4_1 = 32;
  $2_1 = $4_1 & 31 | 0;
  if (32 >>> 0 <= ($4_1 & 63 | 0) >>> 0) {
   {
    $0 = $1_1 << $2_1 | 0;
    $4_1 = 0;
   }
  } else {
   {
    $0 = ((1 << $2_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $2_1 | 0) | 0) | 0 | ($3_1 << $2_1 | 0) | 0;
    $4_1 = $1_1 << $2_1 | 0;
   }
  }
  $1_1 = $0;
  $0 = $6_1;
  $3_1 = $5_1;
  $1_1 = $0 | $1_1 | 0;
  $1_1 = $17($3_1 | $4_1 | 0 | 0, $1_1 | 0) | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  $6_1 = $1_1;
  $5_1 = $3_1;
  $0 = $1_1;
  $4_1 = 32;
  $2_1 = $4_1 & 31 | 0;
  if (32 >>> 0 <= ($4_1 & 63 | 0) >>> 0) {
   $0 = $3_1 >>> $2_1 | 0
  } else {
   $0 = (((1 << $2_1 | 0) - 1 | 0) & $3_1 | 0) << (32 - $2_1 | 0) | 0 | ($0 >>> $2_1 | 0) | 0
  }
  setTempRet0($0 | 0);
  return $6_1 | 0;
 }
 
 function _ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE($0, $1_1, $2_1, $3_1) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  var $4_1 = 0, $5_1 = 0, $6_1 = 0, $7_1 = 0, $8_1 = 0, $9_1 = 0, $10_1 = 0, $11_1 = 0;
  $5_1 = $2_1;
  $9_1 = $5_1 >>> 16 | 0;
  $10_1 = $0 >>> 16 | 0;
  $11_1 = Math_imul($9_1, $10_1);
  $8_1 = $5_1;
  $6_1 = $0;
  $7_1 = 32;
  $4_1 = $7_1 & 31 | 0;
  if (32 >>> 0 <= ($7_1 & 63 | 0) >>> 0) {
   $1_1 = $1_1 >>> $4_1 | 0
  } else {
   $1_1 = (((1 << $4_1 | 0) - 1 | 0) & $1_1 | 0) << (32 - $4_1 | 0) | 0 | ($6_1 >>> $4_1 | 0) | 0
  }
  $6_1 = $11_1 + Math_imul($8_1, $1_1) | 0;
  $1_1 = $2_1;
  $7_1 = 32;
  $4_1 = $7_1 & 31 | 0;
  if (32 >>> 0 <= ($7_1 & 63 | 0) >>> 0) {
   $1_1 = $3_1 >>> $4_1 | 0
  } else {
   $1_1 = (((1 << $4_1 | 0) - 1 | 0) & $3_1 | 0) << (32 - $4_1 | 0) | 0 | ($1_1 >>> $4_1 | 0) | 0
  }
  $1_1 = $6_1 + Math_imul($1_1, $0) | 0;
  $5_1 = $5_1 & 65535 | 0;
  $0 = $0 & 65535 | 0;
  $8_1 = Math_imul($5_1, $0);
  $5_1 = ($8_1 >>> 16 | 0) + Math_imul($5_1, $10_1) | 0;
  $1_1 = $1_1 + ($5_1 >>> 16 | 0) | 0;
  $5_1 = ($5_1 & 65535 | 0) + Math_imul($9_1, $0) | 0;
  $6_1 = 0;
  $3_1 = $1_1 + ($5_1 >>> 16 | 0) | 0;
  $7_1 = 32;
  $4_1 = $7_1 & 31 | 0;
  if (32 >>> 0 <= ($7_1 & 63 | 0) >>> 0) {
   {
    $1_1 = $3_1 << $4_1 | 0;
    $6_1 = 0;
   }
  } else {
   {
    $1_1 = ((1 << $4_1 | 0) - 1 | 0) & ($3_1 >>> (32 - $4_1 | 0) | 0) | 0 | ($6_1 << $4_1 | 0) | 0;
    $6_1 = $3_1 << $4_1 | 0;
   }
  }
  $0 = $1_1;
  $1_1 = 0;
  $2_1 = $1_1;
  $1_1 = $0;
  $3_1 = $2_1;
  $7_1 = $5_1 << 16 | 0 | ($8_1 & 65535 | 0) | 0;
  $3_1 = $1_1 | $3_1 | 0;
  $6_1 = $6_1 | $7_1 | 0;
  i64toi32_i32$HIGH_BITS = $3_1;
  return $6_1 | 0;
 }
 
 function __wasm_ctz_i32($0) {
  $0 = $0 | 0;
  if ($0) {
   return 31 - Math_clz32(($0 + -1 | 0) ^ $0 | 0) | 0 | 0
  }
  return 32 | 0;
 }
 
 function __wasm_i64_mul($0, $1_1, $2_1, $3_1) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  $3_1 = $3_1 | 0;
  $3_1 = _ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE($0 | 0, $1_1 | 0, $2_1 | 0, $3_1 | 0) | 0;
  $1_1 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $3_1 | 0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "empty": $1, 
  "singular": $2, 
  "multi": $3, 
  "nested": $4, 
  "deep": $5, 
  "as_unary_operand": $6, 
  "as_binary_operand": $7, 
  "as_test_operand": $8, 
  "as_compare_operand": $9, 
  "break_bare": $10, 
  "break_value": $11, 
  "break_repeated": $12, 
  "break_inner": $13, 
  "cont_inner": $14, 
  "effects": fx, 
  "while_": legalstub$16, 
  "for_": legalstub$17, 
  "nesting": $18
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0},memasmFunc);
export var empty = retasmFunc.empty;
export var singular = retasmFunc.singular;
export var multi = retasmFunc.multi;
export var nested = retasmFunc.nested;
export var deep = retasmFunc.deep;
export var as_unary_operand = retasmFunc.as_unary_operand;
export var as_binary_operand = retasmFunc.as_binary_operand;
export var as_test_operand = retasmFunc.as_test_operand;
export var as_compare_operand = retasmFunc.as_compare_operand;
export var break_bare = retasmFunc.break_bare;
export var break_value = retasmFunc.break_value;
export var break_repeated = retasmFunc.break_repeated;
export var break_inner = retasmFunc.break_inner;
export var cont_inner = retasmFunc.cont_inner;
export var effects = retasmFunc.effects;
export var while_ = retasmFunc.while_;
export var for_ = retasmFunc.for_;
export var nesting = retasmFunc.nesting;
