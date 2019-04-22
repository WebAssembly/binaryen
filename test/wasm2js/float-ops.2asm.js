
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
 function $1($0, $1_1) {
  $0 = Math_fround($0);
  $1_1 = Math_fround($1_1);
  return Math_fround(Math_fround($0 + $1_1));
 }
 
 function $2($0, $1_1) {
  $0 = Math_fround($0);
  $1_1 = Math_fround($1_1);
  return Math_fround(Math_fround($0 - $1_1));
 }
 
 function $3($0, $1_1) {
  $0 = Math_fround($0);
  $1_1 = Math_fround($1_1);
  return Math_fround(Math_fround($0 * $1_1));
 }
 
 function $4($0, $1_1) {
  $0 = Math_fround($0);
  $1_1 = Math_fround($1_1);
  return Math_fround(Math_fround($0 / $1_1));
 }
 
 function $5($0, $1_1) {
  $0 = +$0;
  $1_1 = +$1_1;
  return +($0 + $1_1);
 }
 
 function $6($0, $1_1) {
  $0 = +$0;
  $1_1 = +$1_1;
  return +($0 - $1_1);
 }
 
 function $7($0, $1_1) {
  $0 = +$0;
  $1_1 = +$1_1;
  return +($0 * $1_1);
 }
 
 function $8($0, $1_1) {
  $0 = +$0;
  $1_1 = +$1_1;
  return +($0 / $1_1);
 }
 
 function $9($0, $1_1) {
  $0 = Math_fround($0);
  $1_1 = Math_fround($1_1);
  return $0 == $1_1 | 0;
 }
 
 function $10($0, $1_1) {
  $0 = Math_fround($0);
  $1_1 = Math_fround($1_1);
  return $0 != $1_1 | 0;
 }
 
 function $11($0, $1_1) {
  $0 = Math_fround($0);
  $1_1 = Math_fround($1_1);
  return $0 >= $1_1 | 0;
 }
 
 function $12($0, $1_1) {
  $0 = Math_fround($0);
  $1_1 = Math_fround($1_1);
  return $0 > $1_1 | 0;
 }
 
 function $13($0, $1_1) {
  $0 = Math_fround($0);
  $1_1 = Math_fround($1_1);
  return $0 <= $1_1 | 0;
 }
 
 function $14($0, $1_1) {
  $0 = Math_fround($0);
  $1_1 = Math_fround($1_1);
  return $0 < $1_1 | 0;
 }
 
 function $15($0, $1_1) {
  $0 = +$0;
  $1_1 = +$1_1;
  return $0 == $1_1 | 0;
 }
 
 function $16($0, $1_1) {
  $0 = +$0;
  $1_1 = +$1_1;
  return $0 != $1_1 | 0;
 }
 
 function $17($0, $1_1) {
  $0 = +$0;
  $1_1 = +$1_1;
  return $0 >= $1_1 | 0;
 }
 
 function $18($0, $1_1) {
  $0 = +$0;
  $1_1 = +$1_1;
  return $0 > $1_1 | 0;
 }
 
 function $19($0, $1_1) {
  $0 = +$0;
  $1_1 = +$1_1;
  return $0 <= $1_1 | 0;
 }
 
 function $20($0, $1_1) {
  $0 = +$0;
  $1_1 = +$1_1;
  return $0 < $1_1 | 0;
 }
 
 function $21($0, $1_1) {
  $0 = Math_fround($0);
  $1_1 = Math_fround($1_1);
  return Math_fround(Math_fround(Math_min($0, $1_1)));
 }
 
 function $22($0, $1_1) {
  $0 = Math_fround($0);
  $1_1 = Math_fround($1_1);
  return Math_fround(Math_fround(Math_max($0, $1_1)));
 }
 
 function $23($0, $1_1) {
  $0 = +$0;
  $1_1 = +$1_1;
  return +Math_min($0, $1_1);
 }
 
 function $24($0, $1_1) {
  $0 = +$0;
  $1_1 = +$1_1;
  return +Math_max($0, $1_1);
 }
 
 function $25($0) {
  $0 = Math_fround($0);
  return +(+$0);
 }
 
 function $26($0) {
  $0 = +$0;
  return Math_fround(Math_fround($0));
 }
 
 function $27($0) {
  $0 = Math_fround($0);
  return Math_fround(Math_fround(Math_floor($0)));
 }
 
 function $28($0) {
  $0 = Math_fround($0);
  return Math_fround(Math_fround(Math_ceil($0)));
 }
 
 function $29($0) {
  $0 = +$0;
  return +Math_floor($0);
 }
 
 function $30($0) {
  $0 = +$0;
  return +Math_ceil($0);
 }
 
 function $31($0) {
  $0 = Math_fround($0);
  return Math_fround(Math_fround(Math_sqrt($0)));
 }
 
 function $32($0) {
  $0 = +$0;
  return +Math_sqrt($0);
 }
 
 function $35($0) {
  $0 = $0 | 0;
  return Math_fround(Math_fround($0 | 0));
 }
 
 function $36($0) {
  $0 = $0 | 0;
  return +(+($0 | 0));
 }
 
 function $37($0) {
  $0 = $0 | 0;
  return Math_fround(Math_fround($0 >>> 0));
 }
 
 function $38($0) {
  $0 = $0 | 0;
  return +(+($0 >>> 0));
 }
 
 function $39($0) {
  $0 = Math_fround($0);
  return ~~$0 | 0;
 }
 
 function $40($0) {
  $0 = +$0;
  return ~~$0 | 0;
 }
 
 function $41($0) {
  $0 = Math_fround($0);
  return ~~$0 >>> 0 | 0;
 }
 
 function $42($0) {
  $0 = +$0;
  return ~~$0 >>> 0 | 0;
 }
 
 function $43($0, $0$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = $0$hi;
  return Math_fround(Math_fround(+($0 >>> 0) + 4294967296.0 * +(i64toi32_i32$0 | 0)));
 }
 
 function $44($0, $0$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = $0$hi;
  return +(+($0 >>> 0) + 4294967296.0 * +(i64toi32_i32$0 | 0));
 }
 
 function $45($0, $0$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = $0$hi;
  return Math_fround(Math_fround(+($0 >>> 0) + 4294967296.0 * +(i64toi32_i32$0 >>> 0)));
 }
 
 function $46($0, $0$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = $0$hi;
  return +(+($0 >>> 0) + 4294967296.0 * +(i64toi32_i32$0 >>> 0));
 }
 
 function $47($0) {
  $0 = Math_fround($0);
  var i64toi32_i32$0 = Math_fround(0), $3_1 = 0, $4_1 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = $0;
  if (Math_fround(Math_abs(i64toi32_i32$0)) >= Math_fround(1.0)) {
   {
    if (i64toi32_i32$0 > Math_fround(0.0)) {
     $3_1 = ~~Math_fround(Math_min(Math_fround(Math_floor(Math_fround(i64toi32_i32$0 / Math_fround(4294967296.0)))), Math_fround(Math_fround(4294967296.0) - Math_fround(1.0)))) >>> 0
    } else {
     $3_1 = ~~Math_fround(Math_ceil(Math_fround(Math_fround(i64toi32_i32$0 - Math_fround(~~i64toi32_i32$0 >>> 0 >>> 0)) / Math_fround(4294967296.0)))) >>> 0
    }
    $4_1 = $3_1;
   }
  } else {
   $4_1 = 0
  }
  i64toi32_i32$1 = $4_1;
  return (~~i64toi32_i32$0 >>> 0 | 0) == (0 | 0) & (i64toi32_i32$1 | 0) == (0 | 0) | 0 | 0;
 }
 
 function $48($0) {
  $0 = +$0;
  var i64toi32_i32$0 = 0.0, $3_1 = 0, $4_1 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = $0;
  if (Math_abs(i64toi32_i32$0) >= 1.0) {
   {
    if (i64toi32_i32$0 > 0.0) {
     $3_1 = ~~Math_min(Math_floor(i64toi32_i32$0 / 4294967296.0), 4294967296.0 - 1.0) >>> 0
    } else {
     $3_1 = ~~Math_ceil((i64toi32_i32$0 - +(~~i64toi32_i32$0 >>> 0 >>> 0)) / 4294967296.0) >>> 0
    }
    $4_1 = $3_1;
   }
  } else {
   $4_1 = 0
  }
  i64toi32_i32$1 = $4_1;
  return (~~i64toi32_i32$0 >>> 0 | 0) == (0 | 0) & (i64toi32_i32$1 | 0) == (0 | 0) | 0 | 0;
 }
 
 function $49($0) {
  $0 = Math_fround($0);
  var i64toi32_i32$0 = Math_fround(0), $3_1 = 0, $4_1 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = $0;
  if (Math_fround(Math_abs(i64toi32_i32$0)) >= Math_fround(1.0)) {
   {
    if (i64toi32_i32$0 > Math_fround(0.0)) {
     $3_1 = ~~Math_fround(Math_min(Math_fround(Math_floor(Math_fround(i64toi32_i32$0 / Math_fround(4294967296.0)))), Math_fround(Math_fround(4294967296.0) - Math_fround(1.0)))) >>> 0
    } else {
     $3_1 = ~~Math_fround(Math_ceil(Math_fround(Math_fround(i64toi32_i32$0 - Math_fround(~~i64toi32_i32$0 >>> 0 >>> 0)) / Math_fround(4294967296.0)))) >>> 0
    }
    $4_1 = $3_1;
   }
  } else {
   $4_1 = 0
  }
  i64toi32_i32$1 = $4_1;
  return (~~i64toi32_i32$0 >>> 0 | 0) == (0 | 0) & (i64toi32_i32$1 | 0) == (0 | 0) | 0 | 0;
 }
 
 function $50($0) {
  $0 = +$0;
  var i64toi32_i32$0 = 0.0, $3_1 = 0, $4_1 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = $0;
  if (Math_abs(i64toi32_i32$0) >= 1.0) {
   {
    if (i64toi32_i32$0 > 0.0) {
     $3_1 = ~~Math_min(Math_floor(i64toi32_i32$0 / 4294967296.0), 4294967296.0 - 1.0) >>> 0
    } else {
     $3_1 = ~~Math_ceil((i64toi32_i32$0 - +(~~i64toi32_i32$0 >>> 0 >>> 0)) / 4294967296.0) >>> 0
    }
    $4_1 = $3_1;
   }
  } else {
   $4_1 = 0
  }
  i64toi32_i32$1 = $4_1;
  return (~~i64toi32_i32$0 >>> 0 | 0) == (0 | 0) & (i64toi32_i32$1 | 0) == (0 | 0) | 0 | 0;
 }
 
 function legalstub$1($0, $1_1) {
  $0 = +$0;
  $1_1 = +$1_1;
  return +(+Math_fround($1(Math_fround(Math_fround($0)), Math_fround(Math_fround($1_1)))));
 }
 
 function legalstub$2($0, $1_1) {
  $0 = +$0;
  $1_1 = +$1_1;
  return +(+Math_fround($2(Math_fround(Math_fround($0)), Math_fround(Math_fround($1_1)))));
 }
 
 function legalstub$3($0, $1_1) {
  $0 = +$0;
  $1_1 = +$1_1;
  return +(+Math_fround($3(Math_fround(Math_fround($0)), Math_fround(Math_fround($1_1)))));
 }
 
 function legalstub$4($0, $1_1) {
  $0 = +$0;
  $1_1 = +$1_1;
  return +(+Math_fround($4(Math_fround(Math_fround($0)), Math_fround(Math_fround($1_1)))));
 }
 
 function legalstub$9($0, $1_1) {
  $0 = +$0;
  $1_1 = +$1_1;
  return $9(Math_fround(Math_fround($0)), Math_fround(Math_fround($1_1))) | 0 | 0;
 }
 
 function legalstub$10($0, $1_1) {
  $0 = +$0;
  $1_1 = +$1_1;
  return $10(Math_fround(Math_fround($0)), Math_fround(Math_fround($1_1))) | 0 | 0;
 }
 
 function legalstub$11($0, $1_1) {
  $0 = +$0;
  $1_1 = +$1_1;
  return $11(Math_fround(Math_fround($0)), Math_fround(Math_fround($1_1))) | 0 | 0;
 }
 
 function legalstub$12($0, $1_1) {
  $0 = +$0;
  $1_1 = +$1_1;
  return $12(Math_fround(Math_fround($0)), Math_fround(Math_fround($1_1))) | 0 | 0;
 }
 
 function legalstub$13($0, $1_1) {
  $0 = +$0;
  $1_1 = +$1_1;
  return $13(Math_fround(Math_fround($0)), Math_fround(Math_fround($1_1))) | 0 | 0;
 }
 
 function legalstub$14($0, $1_1) {
  $0 = +$0;
  $1_1 = +$1_1;
  return $14(Math_fround(Math_fround($0)), Math_fround(Math_fround($1_1))) | 0 | 0;
 }
 
 function legalstub$21($0, $1_1) {
  $0 = +$0;
  $1_1 = +$1_1;
  return +(+Math_fround($21(Math_fround(Math_fround($0)), Math_fround(Math_fround($1_1)))));
 }
 
 function legalstub$22($0, $1_1) {
  $0 = +$0;
  $1_1 = +$1_1;
  return +(+Math_fround($22(Math_fround(Math_fround($0)), Math_fround(Math_fround($1_1)))));
 }
 
 function legalstub$25($0) {
  $0 = +$0;
  return +(+$25(Math_fround(Math_fround($0))));
 }
 
 function legalstub$26($0) {
  $0 = +$0;
  return +(+Math_fround($26(+$0)));
 }
 
 function legalstub$27($0) {
  $0 = +$0;
  return +(+Math_fround($27(Math_fround(Math_fround($0)))));
 }
 
 function legalstub$28($0) {
  $0 = +$0;
  return +(+Math_fround($28(Math_fround(Math_fround($0)))));
 }
 
 function legalstub$31($0) {
  $0 = +$0;
  return +(+Math_fround($31(Math_fround(Math_fround($0)))));
 }
 
 function legalstub$35($0) {
  $0 = $0 | 0;
  return +(+Math_fround($35($0 | 0)));
 }
 
 function legalstub$37($0) {
  $0 = $0 | 0;
  return +(+Math_fround($37($0 | 0)));
 }
 
 function legalstub$39($0) {
  $0 = +$0;
  return $39(Math_fround(Math_fround($0))) | 0 | 0;
 }
 
 function legalstub$41($0) {
  $0 = +$0;
  return $41(Math_fround(Math_fround($0))) | 0 | 0;
 }
 
 function legalstub$43($0, $1_1) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $10_1 = 0, $3_1 = 0, $3$hi = 0, $6$hi = 0;
  i64toi32_i32$0 = 0;
  $3_1 = $0;
  $3$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   {
    i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
    $10_1 = 0;
   }
  } else {
   {
    i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
    $10_1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   }
  }
  $6$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $3$hi;
  i64toi32_i32$0 = $3_1;
  i64toi32_i32$2 = $6$hi;
  i64toi32_i32$3 = $10_1;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  return +(+Math_fround($43(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0)));
 }
 
 function legalstub$44($0, $1_1) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $10_1 = 0, $3_1 = 0, $3$hi = 0, $6$hi = 0;
  i64toi32_i32$0 = 0;
  $3_1 = $0;
  $3$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   {
    i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
    $10_1 = 0;
   }
  } else {
   {
    i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
    $10_1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   }
  }
  $6$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $3$hi;
  i64toi32_i32$0 = $3_1;
  i64toi32_i32$2 = $6$hi;
  i64toi32_i32$3 = $10_1;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  return +(+$44(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0));
 }
 
 function legalstub$45($0, $1_1) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $10_1 = 0, $3_1 = 0, $3$hi = 0, $6$hi = 0;
  i64toi32_i32$0 = 0;
  $3_1 = $0;
  $3$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   {
    i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
    $10_1 = 0;
   }
  } else {
   {
    i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
    $10_1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   }
  }
  $6$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $3$hi;
  i64toi32_i32$0 = $3_1;
  i64toi32_i32$2 = $6$hi;
  i64toi32_i32$3 = $10_1;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  return +(+Math_fround($45(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0)));
 }
 
 function legalstub$46($0, $1_1) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $10_1 = 0, $3_1 = 0, $3$hi = 0, $6$hi = 0;
  i64toi32_i32$0 = 0;
  $3_1 = $0;
  $3$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   {
    i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
    $10_1 = 0;
   }
  } else {
   {
    i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
    $10_1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   }
  }
  $6$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $3$hi;
  i64toi32_i32$0 = $3_1;
  i64toi32_i32$2 = $6$hi;
  i64toi32_i32$3 = $10_1;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  return +(+$46(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0));
 }
 
 function legalstub$47($0) {
  $0 = +$0;
  return $47(Math_fround(Math_fround($0))) | 0 | 0;
 }
 
 function legalstub$49($0) {
  $0 = +$0;
  return $49(Math_fround(Math_fround($0))) | 0 | 0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  f32_add: legalstub$1, 
  f32_sub: legalstub$2, 
  f32_mul: legalstub$3, 
  f32_div: legalstub$4, 
  f64_add: $5, 
  f64_sub: $6, 
  f64_mul: $7, 
  f64_div: $8, 
  f32_eq: legalstub$9, 
  f32_ne: legalstub$10, 
  f32_ge: legalstub$11, 
  f32_gt: legalstub$12, 
  f32_le: legalstub$13, 
  f32_lt: legalstub$14, 
  f64_eq: $15, 
  f64_ne: $16, 
  f64_ge: $17, 
  f64_gt: $18, 
  f64_le: $19, 
  f64_lt: $20, 
  f32_min: legalstub$21, 
  f32_max: legalstub$22, 
  f64_min: $23, 
  f64_max: $24, 
  f64_promote: legalstub$25, 
  f32_demote: legalstub$26, 
  f32_floor: legalstub$27, 
  f32_ceil: legalstub$28, 
  f64_floor: $29, 
  f64_ceil: $30, 
  f32_sqrt: legalstub$31, 
  f64_sqrt: $32, 
  i32_to_f32: legalstub$35, 
  i32_to_f64: $36, 
  u32_to_f32: legalstub$37, 
  u32_to_f64: $38, 
  f32_to_i32: legalstub$39, 
  f64_to_i32: $40, 
  f32_to_u32: legalstub$41, 
  f64_to_u32: $42, 
  i64_to_f32: legalstub$43, 
  i64_to_f64: legalstub$44, 
  u64_to_f32: legalstub$45, 
  u64_to_f64: legalstub$46, 
  f32_to_i64: legalstub$47, 
  f64_to_i64: $48, 
  f32_to_u64: legalstub$49, 
  f64_to_u64: $50
 };
}

const memasmFunc = new ArrayBuffer(65536);
const retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export const f32_add = retasmFunc.f32_add;
export const f32_sub = retasmFunc.f32_sub;
export const f32_mul = retasmFunc.f32_mul;
export const f32_div = retasmFunc.f32_div;
export const f64_add = retasmFunc.f64_add;
export const f64_sub = retasmFunc.f64_sub;
export const f64_mul = retasmFunc.f64_mul;
export const f64_div = retasmFunc.f64_div;
export const f32_eq = retasmFunc.f32_eq;
export const f32_ne = retasmFunc.f32_ne;
export const f32_ge = retasmFunc.f32_ge;
export const f32_gt = retasmFunc.f32_gt;
export const f32_le = retasmFunc.f32_le;
export const f32_lt = retasmFunc.f32_lt;
export const f64_eq = retasmFunc.f64_eq;
export const f64_ne = retasmFunc.f64_ne;
export const f64_ge = retasmFunc.f64_ge;
export const f64_gt = retasmFunc.f64_gt;
export const f64_le = retasmFunc.f64_le;
export const f64_lt = retasmFunc.f64_lt;
export const f32_min = retasmFunc.f32_min;
export const f32_max = retasmFunc.f32_max;
export const f64_min = retasmFunc.f64_min;
export const f64_max = retasmFunc.f64_max;
export const f64_promote = retasmFunc.f64_promote;
export const f32_demote = retasmFunc.f32_demote;
export const f32_floor = retasmFunc.f32_floor;
export const f32_ceil = retasmFunc.f32_ceil;
export const f64_floor = retasmFunc.f64_floor;
export const f64_ceil = retasmFunc.f64_ceil;
export const f32_sqrt = retasmFunc.f32_sqrt;
export const f64_sqrt = retasmFunc.f64_sqrt;
export const i32_to_f32 = retasmFunc.i32_to_f32;
export const i32_to_f64 = retasmFunc.i32_to_f64;
export const u32_to_f32 = retasmFunc.u32_to_f32;
export const u32_to_f64 = retasmFunc.u32_to_f64;
export const f32_to_i32 = retasmFunc.f32_to_i32;
export const f64_to_i32 = retasmFunc.f64_to_i32;
export const f32_to_u32 = retasmFunc.f32_to_u32;
export const f64_to_u32 = retasmFunc.f64_to_u32;
export const i64_to_f32 = retasmFunc.i64_to_f32;
export const i64_to_f64 = retasmFunc.i64_to_f64;
export const u64_to_f32 = retasmFunc.u64_to_f32;
export const u64_to_f64 = retasmFunc.u64_to_f64;
export const f32_to_i64 = retasmFunc.f32_to_i64;
export const f64_to_i64 = retasmFunc.f64_to_i64;
export const f32_to_u64 = retasmFunc.f32_to_u64;
export const f64_to_u64 = retasmFunc.f64_to_u64;
