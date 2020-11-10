import { setTempRet0 } from 'env';

function asmFunc(env) {
 var Math_imul = Math.imul;
 var Math_fround = Math.fround;
 var Math_abs = Math.abs;
 var Math_clz32 = Math.clz32;
 var Math_min = Math.min;
 var Math_max = Math.max;
 var Math_floor = Math.floor;
 var Math_ceil = Math.ceil;
 var Math_sqrt = Math.sqrt;
 var abort = env.abort;
 var nan = NaN;
 var infinity = Infinity;
 var setTempRet0 = env.setTempRet0;
 var i64toi32_i32$HIGH_BITS = 0;
 function $0(i) {
  i = i | 0;
  var j = 0;
  j = 100;
  switch_ : {
   $7 : {
    switch (i | 0) {
    case 0:
     return i | 0;
    case 1:
    case 2:
    case 3:
     j = 0 - i | 0;
     break switch_;
    case 4:
     break switch_;
    case 5:
     j = 101;
     break switch_;
    case 6:
     j = 101;
    default:
     j = 102;
     break;
    case 7:
     break $7;
    };
   }
  }
  return j | 0;
 }
 
 function $1(i, i$hi) {
  i = i | 0;
  i$hi = i$hi | 0;
  var i64toi32_i32$5 = 0, i64toi32_i32$2 = 0, $7 = 0, $7$hi = 0, j = 0, j$hi = 0;
  j = 100;
  j$hi = 0;
  switch_ : {
   $7 : {
    switch (i | 0) {
    case 0:
     i64toi32_i32$HIGH_BITS = i$hi;
     return i | 0;
    case 1:
    case 2:
    case 3:
     i64toi32_i32$2 = 0;
     i64toi32_i32$5 = (i64toi32_i32$2 >>> 0 < i >>> 0) + i$hi | 0;
     i64toi32_i32$5 = 0 - i64toi32_i32$5 | 0;
     $7 = i64toi32_i32$2 - i | 0;
     $7$hi = i64toi32_i32$5;
     break switch_;
    case 6:
     i64toi32_i32$5 = 0;
     j = 101;
     j$hi = i64toi32_i32$5;
    case 5:
    case 4:
    default:
     i64toi32_i32$5 = j$hi;
     $7 = j;
     $7$hi = i64toi32_i32$5;
     break switch_;
    case 7:
     break $7;
    };
   }
   i64toi32_i32$5 = -1;
   $7 = -5;
   $7$hi = i64toi32_i32$5;
  }
  i64toi32_i32$5 = $7$hi;
  i64toi32_i32$2 = $7;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$5;
  return i64toi32_i32$2 | 0;
 }
 
 function $2(i) {
  i = i | 0;
  var $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0;
  $2 : {
   $1 : {
    $0 : {
     default_ : {
      $5 = Math_imul(2, i);
      $6 = $5;
      $7 = $5;
      $8 = $5;
      $9 = $5;
      switch (3 & i | 0 | 0) {
      case 0:
       break $0;
      case 1:
       break $1;
      case 2:
       break $2;
      default:
       break default_;
      };
     }
     $6 = 1e3 + $9 | 0;
    }
    $7 = 100 + $6 | 0;
   }
   $8 = 10 + $7 | 0;
  }
  return $8 | 0;
 }
 
 function $3() {
  return 1 | 0;
 }
 
 function legalstub$1($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $12 = 0, $13 = 0, $4 = 0, $4$hi = 0, $7$hi = 0, $2_1 = 0, $2$hi = 0;
  i64toi32_i32$0 = 0;
  $4 = $0_1;
  $4$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
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
  $7$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $4$hi;
  i64toi32_i32$0 = $4;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$3 = $12;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$2 = $1(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $2_1 = i64toi32_i32$2;
  $2$hi = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $13 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $13 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$1 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($13 | 0);
  i64toi32_i32$2 = $2$hi;
  return $2_1 | 0;
 }
 
 return {
  "stmt": $0, 
  "expr": legalstub$1, 
  "arg": $2, 
  "corner": $3
 };
}

var retasmFunc = asmFunc(  { abort: function() { throw new Error('abort'); },
    setTempRet0
  });
export var stmt = retasmFunc.stmt;
export var expr = retasmFunc.expr;
export var arg = retasmFunc.arg;
export var corner = retasmFunc.corner;
