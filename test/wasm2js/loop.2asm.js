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
 function $1() {
  
 }
 
 function $2() {
  return 7 | 0;
 }
 
 function $3() {
  return 8 | 0;
 }
 
 function $4() {
  return 9 | 0;
 }
 
 function $5() {
  return 150 | 0;
 }
 
 function $6() {
  return 0 | 0;
 }
 
 function $7() {
  return 12 | 0;
 }
 
 function $10() {
  return 19 | 0;
 }
 
 function $11() {
  return 18 | 0;
 }
 
 function $13() {
  return 31 | 0;
 }
 
 function $14() {
  loop_in : while (1) continue;
 }
 
 function fx() {
  return 1 | 0;
 }
 
 function $16($0, $1_1) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0;
  $2_1 = 1;
  loop_in : while (1) {
   if ($0 | $1_1) {
    {
     $2_1 = __wasm_i64_mul($0, $1_1, $2_1, $3_1);
     $3_1 = i64toi32_i32$HIGH_BITS;
     $5_1 = $0;
     $4_1 = 1;
     $0 = $0 - $4_1 | 0;
     $1_1 = $1_1 - ($5_1 >>> 0 < $4_1 >>> 0) | 0;
     continue;
    }
   }
   break;
  };
  i64toi32_i32$HIGH_BITS = $3_1;
  return $2_1 | 0;
 }
 
 function $17($0, $1_1) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0, $6_1 = 0;
  $4_1 = 1;
  $2_1 = 2;
  loop_in : while (1) {
   if (!(($1_1 | 0) == ($3_1 | 0) & $2_1 >>> 0 > $0 >>> 0 | $3_1 >>> 0 > $1_1 >>> 0)) {
    {
     $4_1 = __wasm_i64_mul($4_1, $5_1, $2_1, $3_1);
     $5_1 = i64toi32_i32$HIGH_BITS;
     $6_1 = 1;
     $2_1 = $6_1 + $2_1 | 0;
     if ($2_1 >>> 0 < $6_1 >>> 0) {
      $3_1 = $3_1 + 1 | 0
     }
     continue;
    }
   }
   break;
  };
  i64toi32_i32$HIGH_BITS = $5_1;
  return $4_1 | 0;
 }
 
 function $18($0, $1_1) {
  $0 = Math_fround($0);
  $1_1 = Math_fround($1_1);
  var $2_1 = Math_fround(0), $3_1 = Math_fround(0);
  loop_in : while (1) {
   block : {
    if ($0 == Math_fround(0.0)) {
     break block
    }
    $2_1 = $1_1;
    loop_in72 : while (1) {
     if ($2_1 != Math_fround(0.0)) {
      {
       if ($2_1 < Math_fround(0.0)) {
        break block
       }
       $3_1 = Math_fround($3_1 + $2_1);
       $2_1 = Math_fround($2_1 - Math_fround(2.0));
       continue;
      }
     }
     break;
    };
    $3_1 = Math_fround($3_1 / $0);
    $0 = Math_fround($0 - Math_fround(1.0));
    continue;
   }
   break;
  };
  return Math_fround($3_1);
 }
 
 function legalstub$16($0, $1_1) {
  var $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0, $6_1 = 0;
  $5_1 = $0;
  $3_1 = 32;
  $0 = $3_1 & 31;
  if (32 >>> 0 <= $3_1 >>> 0) {
   {
    $2_1 = $1_1 << $0;
    $4_1 = 0;
   }
  } else {
   {
    $2_1 = (1 << $0) - 1 & $1_1 >>> 32 - $0 | $2_1 << $0;
    $4_1 = $1_1 << $0;
   }
  }
  $1_1 = $16($5_1 | $4_1, $2_1 | $6_1);
  $6_1 = $1_1;
  $2_1 = i64toi32_i32$HIGH_BITS;
  $0 = 32 & 31;
  setTempRet0((32 >>> 0 <= $3_1 >>> 0 ? $2_1 >>> $0 : ((1 << $0) - 1 & $2_1) << 32 - $0 | $1_1 >>> $0) | 0);
  return $1_1;
 }
 
 function legalstub$17($0, $1_1) {
  var $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0, $6_1 = 0;
  $5_1 = $0;
  $3_1 = 32;
  $0 = $3_1 & 31;
  if (32 >>> 0 <= $3_1 >>> 0) {
   {
    $2_1 = $1_1 << $0;
    $4_1 = 0;
   }
  } else {
   {
    $2_1 = (1 << $0) - 1 & $1_1 >>> 32 - $0 | $2_1 << $0;
    $4_1 = $1_1 << $0;
   }
  }
  $1_1 = $17($5_1 | $4_1, $2_1 | $6_1);
  $6_1 = $1_1;
  $2_1 = i64toi32_i32$HIGH_BITS;
  $0 = 32 & 31;
  setTempRet0((32 >>> 0 <= $3_1 >>> 0 ? $2_1 >>> $0 : ((1 << $0) - 1 & $2_1) << 32 - $0 | $1_1 >>> $0) | 0);
  return $1_1;
 }
 
 function _ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE($0, $1_1, $2_1, $3_1) {
  var $4_1 = 0, $5_1 = 0, $6_1 = 0, $7_1 = 0, $8 = 0, $9 = 0, $10_1 = 0, $11_1 = 0, $12 = 0;
  $4_1 = $2_1 >>> 16;
  $5_1 = $0 >>> 16;
  $7_1 = Math_imul($4_1, $5_1);
  $8 = $2_1 & 65535;
  $6_1 = $0 & 65535;
  $9 = Math_imul($8, $6_1);
  $5_1 = ($9 >>> 16) + Math_imul($5_1, $8) | 0;
  $4_1 = ($5_1 & 65535) + Math_imul($4_1, $6_1) | 0;
  $8 = 0;
  $11_1 = $7_1;
  $6_1 = $0;
  $7_1 = 32;
  $0 = $7_1 & 31;
  $12 = $11_1 + Math_imul(32 >>> 0 <= $7_1 >>> 0 ? $1_1 >>> $0 : ((1 << $0) - 1 & $1_1) << 32 - $0 | $6_1 >>> $0, $2_1) | 0;
  $1_1 = $2_1;
  $2_1 = 32;
  $0 = $2_1 & 31;
  $1_1 = (($12 + Math_imul($6_1, 32 >>> 0 <= $2_1 >>> 0 ? $3_1 >>> $0 : ((1 << $0) - 1 & $3_1) << 32 - $0 | $1_1 >>> $0) | 0) + ($5_1 >>> 16) | 0) + ($4_1 >>> 16) | 0;
  $0 = 32 & 31;
  if (32 >>> 0 <= $2_1 >>> 0) {
   {
    $2_1 = $1_1 << $0;
    $10_1 = 0;
   }
  } else {
   {
    $2_1 = (1 << $0) - 1 & $1_1 >>> 32 - $0 | $8 << $0;
    $10_1 = $1_1 << $0;
   }
  }
  $0 = $10_1 | ($9 & 65535 | $4_1 << 16);
  i64toi32_i32$HIGH_BITS = $2_1;
  return $0;
 }
 
 function __wasm_i64_mul($0, $1_1, $2_1, $3_1) {
  $0 = _ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE($0, $1_1, $2_1, $3_1);
  return $0;
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
  "as_test_operand": $6, 
  "as_compare_operand": $6, 
  "break_bare": $10, 
  "break_value": $11, 
  "break_repeated": $11, 
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
