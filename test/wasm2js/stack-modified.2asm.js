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
 function $0(var$0, var$0$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$2 = 0, i64toi32_i32$5 = 0, i64toi32_i32$3 = 0, var$1$hi = 0, var$1 = 0, var$2$hi = 0, i64toi32_i32$1 = 0, var$2 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  var$1 = var$0;
  var$1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  var$2 = 1;
  var$2$hi = i64toi32_i32$0;
  label$1 : {
   label$2 : do {
    i64toi32_i32$0 = var$1$hi;
    i64toi32_i32$0 = i64toi32_i32$0;
    i64toi32_i32$2 = var$1;
    i64toi32_i32$1 = 0;
    i64toi32_i32$3 = 0;
    if ((i64toi32_i32$2 | 0) == (i64toi32_i32$3 | 0) & (i64toi32_i32$0 | 0) == (i64toi32_i32$1 | 0) | 0) break label$1; else label$5 : {
     i64toi32_i32$2 = var$1$hi;
     i64toi32_i32$2 = var$2$hi;
     i64toi32_i32$2 = var$1$hi;
     i64toi32_i32$0 = var$2$hi;
     i64toi32_i32$0 = __wasm_i64_mul(var$1 | 0, i64toi32_i32$2 | 0, var$2 | 0, i64toi32_i32$0 | 0) | 0;
     i64toi32_i32$2 = i64toi32_i32$HIGH_BITS;
     i64toi32_i32$2 = i64toi32_i32$2;
     var$2 = i64toi32_i32$0;
     var$2$hi = i64toi32_i32$2;
     i64toi32_i32$2 = var$1$hi;
     i64toi32_i32$2 = i64toi32_i32$2;
     i64toi32_i32$3 = var$1;
     i64toi32_i32$0 = 0;
     i64toi32_i32$1 = 1;
     i64toi32_i32$5 = (i64toi32_i32$3 >>> 0 < i64toi32_i32$1 >>> 0) + i64toi32_i32$0 | 0;
     i64toi32_i32$5 = i64toi32_i32$2 - i64toi32_i32$5 | 0;
     i64toi32_i32$5 = i64toi32_i32$5;
     var$1 = i64toi32_i32$3 - i64toi32_i32$1 | 0;
     var$1$hi = i64toi32_i32$5;
    };
    continue label$2;
    break label$2;
   } while (1);
  };
  i64toi32_i32$5 = var$2$hi;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$5;
  return i64toi32_i32$3 | 0;
 }
 
 function $1(var$0, var$0$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$2 = 0, i64toi32_i32$5 = 0, i64toi32_i32$3 = 0, var$1$hi = 0, var$1 = 0, var$2$hi = 0, i64toi32_i32$1 = 0, var$2 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  var$1 = var$0;
  var$1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  var$2 = 1;
  var$2$hi = i64toi32_i32$0;
  label$1 : {
   label$2 : do {
    i64toi32_i32$0 = var$1$hi;
    i64toi32_i32$0 = i64toi32_i32$0;
    i64toi32_i32$2 = var$1;
    i64toi32_i32$1 = 0;
    i64toi32_i32$3 = 0;
    if ((i64toi32_i32$2 | 0) == (i64toi32_i32$3 | 0) & (i64toi32_i32$0 | 0) == (i64toi32_i32$1 | 0) | 0) break label$1; else block : {
     i64toi32_i32$2 = var$1$hi;
     i64toi32_i32$2 = var$2$hi;
     i64toi32_i32$2 = var$1$hi;
     i64toi32_i32$0 = var$2$hi;
     i64toi32_i32$0 = __wasm_i64_mul(var$1 | 0, i64toi32_i32$2 | 0, var$2 | 0, i64toi32_i32$0 | 0) | 0;
     i64toi32_i32$2 = i64toi32_i32$HIGH_BITS;
     i64toi32_i32$2 = i64toi32_i32$2;
     var$2 = i64toi32_i32$0;
     var$2$hi = i64toi32_i32$2;
     i64toi32_i32$2 = var$1$hi;
     i64toi32_i32$2 = i64toi32_i32$2;
     i64toi32_i32$3 = var$1;
     i64toi32_i32$0 = 0;
     i64toi32_i32$1 = 1;
     i64toi32_i32$5 = (i64toi32_i32$3 >>> 0 < i64toi32_i32$1 >>> 0) + i64toi32_i32$0 | 0;
     i64toi32_i32$5 = i64toi32_i32$2 - i64toi32_i32$5 | 0;
     i64toi32_i32$5 = i64toi32_i32$5;
     var$1 = i64toi32_i32$3 - i64toi32_i32$1 | 0;
     var$1$hi = i64toi32_i32$5;
    };
    continue label$2;
    break label$2;
   } while (1);
  };
  i64toi32_i32$5 = var$2$hi;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$5;
  return i64toi32_i32$3 | 0;
 }
 
 function $2(var$0, var$0$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$2 = 0, i64toi32_i32$5 = 0, i64toi32_i32$3 = 0, var$1$hi = 0, var$1 = 0, var$2$hi = 0, i64toi32_i32$1 = 0, var$2 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  var$1 = var$0;
  var$1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  var$2 = 1;
  var$2$hi = i64toi32_i32$0;
  label$1 : {
   label$2 : do {
    i64toi32_i32$0 = var$1$hi;
    i64toi32_i32$0 = i64toi32_i32$0;
    i64toi32_i32$2 = var$1;
    i64toi32_i32$1 = 0;
    i64toi32_i32$3 = 0;
    if ((i64toi32_i32$2 | 0) == (i64toi32_i32$3 | 0) & (i64toi32_i32$0 | 0) == (i64toi32_i32$1 | 0) | 0) break label$1; else block : {
     i64toi32_i32$2 = var$1$hi;
     i64toi32_i32$2 = var$2$hi;
     i64toi32_i32$2 = var$1$hi;
     i64toi32_i32$0 = var$2$hi;
     i64toi32_i32$0 = __wasm_i64_mul(var$1 | 0, i64toi32_i32$2 | 0, var$2 | 0, i64toi32_i32$0 | 0) | 0;
     i64toi32_i32$2 = i64toi32_i32$HIGH_BITS;
     i64toi32_i32$2 = i64toi32_i32$2;
     var$2 = i64toi32_i32$0;
     var$2$hi = i64toi32_i32$2;
     i64toi32_i32$2 = var$1$hi;
     i64toi32_i32$2 = i64toi32_i32$2;
     i64toi32_i32$3 = var$1;
     i64toi32_i32$0 = 0;
     i64toi32_i32$1 = 1;
     i64toi32_i32$5 = (i64toi32_i32$3 >>> 0 < i64toi32_i32$1 >>> 0) + i64toi32_i32$0 | 0;
     i64toi32_i32$5 = i64toi32_i32$2 - i64toi32_i32$5 | 0;
     i64toi32_i32$5 = i64toi32_i32$5;
     var$1 = i64toi32_i32$3 - i64toi32_i32$1 | 0;
     var$1$hi = i64toi32_i32$5;
    };
    continue label$2;
    break label$2;
   } while (1);
  };
  i64toi32_i32$5 = var$2$hi;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$5;
  return i64toi32_i32$3 | 0;
 }
 
 function $3(var$0, var$0$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$2 = 0, i64toi32_i32$5 = 0, i64toi32_i32$3 = 0, var$1$hi = 0, var$1 = 0, var$2$hi = 0, i64toi32_i32$1 = 0, var$2 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  var$1 = var$0;
  var$1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  var$2 = 1;
  var$2$hi = i64toi32_i32$0;
  label$1 : {
   label$2 : do {
    i64toi32_i32$0 = var$1$hi;
    i64toi32_i32$0 = i64toi32_i32$0;
    i64toi32_i32$2 = var$1;
    i64toi32_i32$1 = 0;
    i64toi32_i32$3 = 0;
    if ((i64toi32_i32$2 | 0) == (i64toi32_i32$3 | 0) & (i64toi32_i32$0 | 0) == (i64toi32_i32$1 | 0) | 0) break label$1; else block : {
     i64toi32_i32$2 = var$1$hi;
     i64toi32_i32$2 = var$2$hi;
     i64toi32_i32$2 = var$1$hi;
     i64toi32_i32$0 = var$2$hi;
     i64toi32_i32$0 = __wasm_i64_mul(var$1 | 0, i64toi32_i32$2 | 0, var$2 | 0, i64toi32_i32$0 | 0) | 0;
     i64toi32_i32$2 = i64toi32_i32$HIGH_BITS;
     i64toi32_i32$2 = i64toi32_i32$2;
     var$2 = i64toi32_i32$0;
     var$2$hi = i64toi32_i32$2;
     i64toi32_i32$2 = var$1$hi;
     i64toi32_i32$2 = i64toi32_i32$2;
     i64toi32_i32$3 = var$1;
     i64toi32_i32$0 = 0;
     i64toi32_i32$1 = 1;
     i64toi32_i32$5 = (i64toi32_i32$3 >>> 0 < i64toi32_i32$1 >>> 0) + i64toi32_i32$0 | 0;
     i64toi32_i32$5 = i64toi32_i32$2 - i64toi32_i32$5 | 0;
     i64toi32_i32$5 = i64toi32_i32$5;
     var$1 = i64toi32_i32$3 - i64toi32_i32$1 | 0;
     var$1$hi = i64toi32_i32$5;
    };
    continue label$2;
    break label$2;
   } while (1);
  };
  i64toi32_i32$5 = var$2$hi;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$5;
  return i64toi32_i32$3 | 0;
 }
 
 function $4(var$0, var$0$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$2 = 0, i64toi32_i32$5 = 0, i64toi32_i32$3 = 0, var$1$hi = 0, var$1 = 0, var$2$hi = 0, i64toi32_i32$1 = 0, var$2 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  var$1 = var$0;
  var$1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  var$2 = 1;
  var$2$hi = i64toi32_i32$0;
  label$1 : {
   label$2 : do {
    i64toi32_i32$0 = var$1$hi;
    i64toi32_i32$0 = i64toi32_i32$0;
    i64toi32_i32$2 = var$1;
    i64toi32_i32$1 = 0;
    i64toi32_i32$3 = 0;
    if ((i64toi32_i32$2 | 0) == (i64toi32_i32$3 | 0) & (i64toi32_i32$0 | 0) == (i64toi32_i32$1 | 0) | 0) break label$1; else block : {
     i64toi32_i32$2 = var$1$hi;
     i64toi32_i32$2 = var$2$hi;
     i64toi32_i32$2 = var$1$hi;
     i64toi32_i32$0 = var$2$hi;
     i64toi32_i32$0 = __wasm_i64_mul(var$1 | 0, i64toi32_i32$2 | 0, var$2 | 0, i64toi32_i32$0 | 0) | 0;
     i64toi32_i32$2 = i64toi32_i32$HIGH_BITS;
     i64toi32_i32$2 = i64toi32_i32$2;
     var$2 = i64toi32_i32$0;
     var$2$hi = i64toi32_i32$2;
     i64toi32_i32$2 = var$1$hi;
     i64toi32_i32$2 = i64toi32_i32$2;
     i64toi32_i32$3 = var$1;
     i64toi32_i32$0 = 0;
     i64toi32_i32$1 = 1;
     i64toi32_i32$5 = (i64toi32_i32$3 >>> 0 < i64toi32_i32$1 >>> 0) + i64toi32_i32$0 | 0;
     i64toi32_i32$5 = i64toi32_i32$2 - i64toi32_i32$5 | 0;
     i64toi32_i32$5 = i64toi32_i32$5;
     var$1 = i64toi32_i32$3 - i64toi32_i32$1 | 0;
     var$1$hi = i64toi32_i32$5;
    };
    continue label$2;
    break label$2;
   } while (1);
  };
  i64toi32_i32$5 = var$2$hi;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$3 = var$2;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$5;
  return i64toi32_i32$3 | 0;
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
  fac_expr: $0, 
  fac_stack: $1, 
  fac_stack_raw: $2, 
  fac_mixed: $3, 
  fac_mixed_raw: $4
 };
}

const memasmFunc = new ArrayBuffer(65536);
const retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export const fac_expr = retasmFunc.fac_expr;
export const fac_stack = retasmFunc.fac_stack;
export const fac_stack_raw = retasmFunc.fac_stack_raw;
export const fac_mixed = retasmFunc.fac_mixed;
export const fac_mixed_raw = retasmFunc.fac_mixed_raw;
