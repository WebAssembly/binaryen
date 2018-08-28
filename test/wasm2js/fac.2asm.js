function asmFunc(global, env, buffer) {
 "use asm";
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
 var i64toi32_i32$HIGH_BITS = 0;
 function $0($0_1, $0$hi) {
  $0_1 = $0_1 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$3 = 0, i64toi32_i32$5 = 0, i64toi32_i32$1 = 0, $8 = 0, $8$hi = 0, $6 = 0, $6$hi = 0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 0;
  if (($0_1 | 0) == (i64toi32_i32$3 | 0) & ($0$hi | 0) == (i64toi32_i32$1 | 0) | 0) {
   $8 = 1;
   $8$hi = 0;
  } else {
   i64toi32_i32$3 = $0_1;
   i64toi32_i32$1 = 1;
   i64toi32_i32$5 = (i64toi32_i32$3 >>> 0 < i64toi32_i32$1 >>> 0) + 0 | 0;
   i64toi32_i32$5 = $0$hi - i64toi32_i32$5 | 0;
   i64toi32_i32$5 = i64toi32_i32$5;
   i64toi32_i32$5 = $0(i64toi32_i32$3 - i64toi32_i32$1 | 0 | 0, i64toi32_i32$5 | 0) | 0;
   i64toi32_i32$3 = i64toi32_i32$HIGH_BITS;
   $6 = i64toi32_i32$5;
   $6$hi = i64toi32_i32$3;
   i64toi32_i32$3 = $0$hi;
   i64toi32_i32$5 = $6$hi;
   i64toi32_i32$5 = __wasm_i64_mul($0_1 | 0, $0$hi | 0, $6 | 0, i64toi32_i32$5 | 0) | 0;
   i64toi32_i32$3 = i64toi32_i32$HIGH_BITS;
   i64toi32_i32$3 = i64toi32_i32$3;
   $8 = i64toi32_i32$5;
   $8$hi = i64toi32_i32$3;
  }
  i64toi32_i32$3 = $8$hi;
  i64toi32_i32$3 = i64toi32_i32$3;
  i64toi32_i32$5 = $8;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$3;
  return i64toi32_i32$5 | 0;
 }
 
 function fac_rec_named(n, n$hi) {
  n = n | 0;
  n$hi = n$hi | 0;
  var i64toi32_i32$3 = 0, i64toi32_i32$5 = 0, i64toi32_i32$1 = 0, $8 = 0, $8$hi = 0, $6 = 0, $6$hi = 0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 0;
  if ((n | 0) == (i64toi32_i32$3 | 0) & (n$hi | 0) == (i64toi32_i32$1 | 0) | 0) {
   $8 = 1;
   $8$hi = 0;
  } else {
   i64toi32_i32$3 = n;
   i64toi32_i32$1 = 1;
   i64toi32_i32$5 = (i64toi32_i32$3 >>> 0 < i64toi32_i32$1 >>> 0) + 0 | 0;
   i64toi32_i32$5 = n$hi - i64toi32_i32$5 | 0;
   i64toi32_i32$5 = i64toi32_i32$5;
   i64toi32_i32$5 = fac_rec_named(i64toi32_i32$3 - i64toi32_i32$1 | 0 | 0, i64toi32_i32$5 | 0) | 0;
   i64toi32_i32$3 = i64toi32_i32$HIGH_BITS;
   $6 = i64toi32_i32$5;
   $6$hi = i64toi32_i32$3;
   i64toi32_i32$3 = n$hi;
   i64toi32_i32$5 = $6$hi;
   i64toi32_i32$5 = __wasm_i64_mul(n | 0, n$hi | 0, $6 | 0, i64toi32_i32$5 | 0) | 0;
   i64toi32_i32$3 = i64toi32_i32$HIGH_BITS;
   i64toi32_i32$3 = i64toi32_i32$3;
   $8 = i64toi32_i32$5;
   $8$hi = i64toi32_i32$3;
  }
  i64toi32_i32$3 = $8$hi;
  i64toi32_i32$3 = i64toi32_i32$3;
  i64toi32_i32$5 = $8;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$3;
  return i64toi32_i32$5 | 0;
 }
 
 function $2($0_1, $0$hi) {
  $0_1 = $0_1 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$2 = 0, i64toi32_i32$5 = 0, i64toi32_i32$3 = 0, $1$hi = 0, $1 = 0, $2$hi = 0, i64toi32_i32$1 = 0, $2_1 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  $1 = $0_1;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  $2_1 = 1;
  $2$hi = i64toi32_i32$0;
  block : {
   loop_in : do {
    i64toi32_i32$0 = $1$hi;
    i64toi32_i32$0 = i64toi32_i32$0;
    i64toi32_i32$2 = $1;
    i64toi32_i32$1 = 0;
    i64toi32_i32$3 = 0;
    if ((i64toi32_i32$2 | 0) == (i64toi32_i32$3 | 0) & (i64toi32_i32$0 | 0) == (i64toi32_i32$1 | 0) | 0) break block; else block0 : {
     i64toi32_i32$2 = $1$hi;
     i64toi32_i32$2 = $2$hi;
     i64toi32_i32$2 = $1$hi;
     i64toi32_i32$0 = $2$hi;
     i64toi32_i32$0 = __wasm_i64_mul($1 | 0, i64toi32_i32$2 | 0, $2_1 | 0, i64toi32_i32$0 | 0) | 0;
     i64toi32_i32$2 = i64toi32_i32$HIGH_BITS;
     i64toi32_i32$2 = i64toi32_i32$2;
     $2_1 = i64toi32_i32$0;
     $2$hi = i64toi32_i32$2;
     i64toi32_i32$2 = $1$hi;
     i64toi32_i32$2 = i64toi32_i32$2;
     i64toi32_i32$3 = $1;
     i64toi32_i32$0 = 0;
     i64toi32_i32$1 = 1;
     i64toi32_i32$5 = (i64toi32_i32$3 >>> 0 < i64toi32_i32$1 >>> 0) + i64toi32_i32$0 | 0;
     i64toi32_i32$5 = i64toi32_i32$2 - i64toi32_i32$5 | 0;
     i64toi32_i32$5 = i64toi32_i32$5;
     $1 = i64toi32_i32$3 - i64toi32_i32$1 | 0;
     $1$hi = i64toi32_i32$5;
    };
    continue loop_in;
    break loop_in;
   } while (1);
  };
  i64toi32_i32$5 = $2$hi;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$3 = $2_1;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$5;
  return i64toi32_i32$3 | 0;
 }
 
 function $3(n, n$hi) {
  n = n | 0;
  n$hi = n$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$2 = 0, i64toi32_i32$5 = 0, i64toi32_i32$3 = 0, i$hi = 0, i = 0, res$hi = 0, i64toi32_i32$1 = 0, res = 0;
  i64toi32_i32$0 = n$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i = n;
  i$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  res = 1;
  res$hi = i64toi32_i32$0;
  done : {
   loop : do {
    i64toi32_i32$0 = i$hi;
    i64toi32_i32$0 = i64toi32_i32$0;
    i64toi32_i32$2 = i;
    i64toi32_i32$1 = 0;
    i64toi32_i32$3 = 0;
    if ((i64toi32_i32$2 | 0) == (i64toi32_i32$3 | 0) & (i64toi32_i32$0 | 0) == (i64toi32_i32$1 | 0) | 0) break done; else block : {
     i64toi32_i32$2 = i$hi;
     i64toi32_i32$2 = res$hi;
     i64toi32_i32$2 = i$hi;
     i64toi32_i32$0 = res$hi;
     i64toi32_i32$0 = __wasm_i64_mul(i | 0, i64toi32_i32$2 | 0, res | 0, i64toi32_i32$0 | 0) | 0;
     i64toi32_i32$2 = i64toi32_i32$HIGH_BITS;
     i64toi32_i32$2 = i64toi32_i32$2;
     res = i64toi32_i32$0;
     res$hi = i64toi32_i32$2;
     i64toi32_i32$2 = i$hi;
     i64toi32_i32$2 = i64toi32_i32$2;
     i64toi32_i32$3 = i;
     i64toi32_i32$0 = 0;
     i64toi32_i32$1 = 1;
     i64toi32_i32$5 = (i64toi32_i32$3 >>> 0 < i64toi32_i32$1 >>> 0) + i64toi32_i32$0 | 0;
     i64toi32_i32$5 = i64toi32_i32$2 - i64toi32_i32$5 | 0;
     i64toi32_i32$5 = i64toi32_i32$5;
     i = i64toi32_i32$3 - i64toi32_i32$1 | 0;
     i$hi = i64toi32_i32$5;
    };
    continue loop;
    break loop;
   } while (1);
  };
  i64toi32_i32$5 = res$hi;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$3 = res;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$5;
  return i64toi32_i32$3 | 0;
 }
 
 function $4($0_1, $0$hi) {
  $0_1 = $0_1 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$5 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $1$hi = 0, $1 = 0, $10 = 0, $11 = 0, $12 = 0, i64toi32_i32$4 = 0, $13 = 0, $14 = 0, $15 = 0;
  i64toi32_i32$0 = 0;
  $1 = 1;
  $1$hi = i64toi32_i32$0;
  block : {
   i64toi32_i32$0 = $0$hi;
   i64toi32_i32$0 = i64toi32_i32$0;
   i64toi32_i32$2 = $0_1;
   i64toi32_i32$1 = 0;
   i64toi32_i32$3 = 2;
   if ((i64toi32_i32$0 | 0) < (i64toi32_i32$1 | 0)) $10 = 1; else {
    if ((i64toi32_i32$0 | 0) <= (i64toi32_i32$1 | 0)) {
     if (i64toi32_i32$2 >>> 0 >= i64toi32_i32$3 >>> 0) $11 = 0; else $11 = 1;
     $12 = $11;
    } else $12 = 0;
    $10 = $12;
   }
   if ($10) break block;
   loop_in : do {
    i64toi32_i32$2 = $1$hi;
    i64toi32_i32$2 = $0$hi;
    i64toi32_i32$2 = $1$hi;
    i64toi32_i32$0 = $0$hi;
    i64toi32_i32$0 = __wasm_i64_mul($1 | 0, i64toi32_i32$2 | 0, $0_1 | 0, i64toi32_i32$0 | 0) | 0;
    i64toi32_i32$2 = i64toi32_i32$HIGH_BITS;
    i64toi32_i32$2 = i64toi32_i32$2;
    $1 = i64toi32_i32$0;
    $1$hi = i64toi32_i32$2;
    i64toi32_i32$2 = $0$hi;
    i64toi32_i32$2 = i64toi32_i32$2;
    i64toi32_i32$3 = $0_1;
    i64toi32_i32$0 = 4294967295;
    i64toi32_i32$1 = 4294967295;
    i64toi32_i32$4 = $0_1 + i64toi32_i32$1 | 0;
    i64toi32_i32$5 = i64toi32_i32$2 + i64toi32_i32$0 | 0;
    if (i64toi32_i32$4 >>> 0 < i64toi32_i32$1 >>> 0) i64toi32_i32$5 = i64toi32_i32$5 + 1 | 0;
    i64toi32_i32$5 = i64toi32_i32$5;
    $0_1 = i64toi32_i32$4;
    $0$hi = i64toi32_i32$5;
    i64toi32_i32$5 = i64toi32_i32$5;
    i64toi32_i32$5 = i64toi32_i32$5;
    i64toi32_i32$2 = $0_1;
    i64toi32_i32$3 = 0;
    i64toi32_i32$1 = 1;
    if ((i64toi32_i32$5 | 0) > (i64toi32_i32$3 | 0)) $13 = 1; else {
     if ((i64toi32_i32$5 | 0) >= (i64toi32_i32$3 | 0)) {
      if (i64toi32_i32$2 >>> 0 <= i64toi32_i32$1 >>> 0) $14 = 0; else $14 = 1;
      $15 = $14;
     } else $15 = 0;
     $13 = $15;
    }
    if ($13) continue loop_in;
    break loop_in;
   } while (1);
  };
  i64toi32_i32$2 = $1$hi;
  i64toi32_i32$2 = i64toi32_i32$2;
  i64toi32_i32$2 = i64toi32_i32$2;
  i64toi32_i32$2 = i64toi32_i32$2;
  i64toi32_i32$5 = $1;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$2;
  return i64toi32_i32$5 | 0;
 }
 
 function _ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$2 = 0, var$2 = 0, i64toi32_i32$3 = 0, var$3 = 0, var$4 = 0, var$5 = 0, $21 = 0, $22 = 0, var$6 = 0, $24 = 0, $17 = 0, $18 = 0, $23 = 0, $29 = 0, $45 = 0, $56$hi = 0, $62$hi = 0;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  var$2 = var$1;
  var$4 = var$2 >>> 16 | 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  var$3 = var$0;
  var$5 = var$3 >>> 16 | 0;
  $17 = Math_imul(var$4, var$5);
  $18 = var$2;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$2 = var$3;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = 0;
   $21 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $21 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  i64toi32_i32$1 = i64toi32_i32$1;
  $23 = $17 + Math_imul($18, $21) | 0;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$0 = var$1;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $22 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $22 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$0 >>> i64toi32_i32$4 | 0) | 0;
  }
  i64toi32_i32$2 = i64toi32_i32$2;
  $29 = $23 + Math_imul($22, var$3) | 0;
  var$2 = var$2 & 65535 | 0;
  var$3 = var$3 & 65535 | 0;
  var$6 = Math_imul(var$2, var$3);
  var$2 = (var$6 >>> 16 | 0) + Math_imul(var$2, var$5) | 0;
  $45 = $29 + (var$2 >>> 16 | 0) | 0;
  var$2 = (var$2 & 65535 | 0) + Math_imul(var$4, var$3) | 0;
  i64toi32_i32$2 = 0;
  i64toi32_i32$2 = i64toi32_i32$2;
  i64toi32_i32$1 = $45 + (var$2 >>> 16 | 0) | 0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = i64toi32_i32$1 << i64toi32_i32$4 | 0;
   $24 = 0;
  } else {
   i64toi32_i32$0 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$1 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$2 << i64toi32_i32$4 | 0) | 0;
   $24 = i64toi32_i32$1 << i64toi32_i32$4 | 0;
  }
  $56$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  $62$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $56$hi;
  i64toi32_i32$2 = $24;
  i64toi32_i32$1 = $62$hi;
  i64toi32_i32$3 = var$2 << 16 | 0 | (var$6 & 65535 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$0 | i64toi32_i32$1 | 0;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$2 | i64toi32_i32$3 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$2 | 0;
 }
 
 function __wasm_i64_mul(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 return {
  fac_rec: $0, 
  fac_rec_named: fac_rec_named, 
  fac_iter: $2, 
  fac_iter_named: $3, 
  fac_opt: $4
 };
}

const memasmFunc = new ArrayBuffer(65536);
const retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export const fac_rec = retasmFunc.fac_rec;
export const fac_rec_named = retasmFunc.fac_rec_named;
export const fac_iter = retasmFunc.fac_iter;
export const fac_iter_named = retasmFunc.fac_iter_named;
export const fac_opt = retasmFunc.fac_opt;
