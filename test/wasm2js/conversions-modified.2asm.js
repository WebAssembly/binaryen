import { setTempRet0 } from 'env';


  var scratchBuffer = new ArrayBuffer(8);
  var i32ScratchView = new Int32Array(scratchBuffer);
  var f32ScratchView = new Float32Array(scratchBuffer);
  var f64ScratchView = new Float64Array(scratchBuffer);
  
  function wasm2js_scratch_load_i32(index) {
    return i32ScratchView[index];
  }
      
  function wasm2js_scratch_store_i32(index, value) {
    i32ScratchView[index] = value;
  }
      
  function wasm2js_scratch_load_f64() {
    return f64ScratchView[0];
  }
      
  function wasm2js_scratch_store_f64(value) {
    f64ScratchView[0] = value;
  }
      
  function wasm2js_scratch_load_f32() {
    return f32ScratchView[0];
  }
      
  function wasm2js_scratch_store_f32(value) {
    f32ScratchView[0] = value;
  }
      
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
 function $0($0_1) {
  $0_1 = $0_1 | 0;
  var $1_1 = 0;
  $1_1 = $0_1 >> 31 | 0;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $0_1 | 0;
 }
 
 function $1($0_1) {
  $0_1 = $0_1 | 0;
  var $1_1 = 0;
  $1_1 = 0;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $0_1 | 0;
 }
 
 function $2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  return $0_1 | 0;
 }
 
 function $3($0_1) {
  $0_1 = Math_fround($0_1);
  return ~~$0_1 | 0;
 }
 
 function $4($0_1) {
  $0_1 = Math_fround($0_1);
  return ~~$0_1 >>> 0 | 0;
 }
 
 function $5($0_1) {
  $0_1 = +$0_1;
  return ~~$0_1 | 0;
 }
 
 function $6($0_1) {
  $0_1 = +$0_1;
  return ~~$0_1 >>> 0 | 0;
 }
 
 function $7($0_1) {
  $0_1 = Math_fround($0_1);
  var $1_1 = 0, $2_1 = 0;
  if (Math_fround(Math_abs($0_1)) >= Math_fround(1.0)) {
   if ($0_1 > Math_fround(0.0)) {
    $1_1 = ~~Math_fround(Math_min(Math_fround(Math_floor(Math_fround($0_1 / Math_fround(4294967296.0)))), Math_fround(Math_fround(4294967296.0) - Math_fround(1.0)))) >>> 0
   } else {
    $1_1 = ~~Math_fround(Math_ceil(Math_fround(Math_fround($0_1 - Math_fround(~~$0_1 >>> 0 >>> 0)) / Math_fround(4294967296.0)))) >>> 0
   }
  } else {
   $1_1 = 0
  }
  $2_1 = ~~$0_1 >>> 0;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $2_1 | 0;
 }
 
 function $8($0_1) {
  $0_1 = Math_fround($0_1);
  var $1_1 = 0, $2_1 = 0;
  if (Math_fround(Math_abs($0_1)) >= Math_fround(1.0)) {
   if ($0_1 > Math_fround(0.0)) {
    $1_1 = ~~Math_fround(Math_min(Math_fround(Math_floor(Math_fround($0_1 / Math_fround(4294967296.0)))), Math_fround(Math_fround(4294967296.0) - Math_fround(1.0)))) >>> 0
   } else {
    $1_1 = ~~Math_fround(Math_ceil(Math_fround(Math_fround($0_1 - Math_fround(~~$0_1 >>> 0 >>> 0)) / Math_fround(4294967296.0)))) >>> 0
   }
  } else {
   $1_1 = 0
  }
  $2_1 = ~~$0_1 >>> 0;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $2_1 | 0;
 }
 
 function $9($0_1) {
  $0_1 = +$0_1;
  var $1_1 = 0, $2_1 = 0;
  if (Math_abs($0_1) >= 1.0) {
   if ($0_1 > 0.0) {
    $1_1 = ~~Math_min(Math_floor($0_1 / 4294967296.0), 4294967296.0 - 1.0) >>> 0
   } else {
    $1_1 = ~~Math_ceil(($0_1 - +(~~$0_1 >>> 0 >>> 0)) / 4294967296.0) >>> 0
   }
  } else {
   $1_1 = 0
  }
  $2_1 = ~~$0_1 >>> 0;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $2_1 | 0;
 }
 
 function $10($0_1) {
  $0_1 = +$0_1;
  var $1_1 = 0, $2_1 = 0;
  if (Math_abs($0_1) >= 1.0) {
   if ($0_1 > 0.0) {
    $1_1 = ~~Math_min(Math_floor($0_1 / 4294967296.0), 4294967296.0 - 1.0) >>> 0
   } else {
    $1_1 = ~~Math_ceil(($0_1 - +(~~$0_1 >>> 0 >>> 0)) / 4294967296.0) >>> 0
   }
  } else {
   $1_1 = 0
  }
  $2_1 = ~~$0_1 >>> 0;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $2_1 | 0;
 }
 
 function $11($0_1) {
  $0_1 = $0_1 | 0;
  return Math_fround(Math_fround($0_1 | 0));
 }
 
 function $12($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  return Math_fround(Math_fround(+($0_1 >>> 0) + 4294967296.0 * +($1_1 | 0)));
 }
 
 function $13($0_1) {
  $0_1 = $0_1 | 0;
  return +(+($0_1 | 0));
 }
 
 function $14($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  return +(+($0_1 >>> 0) + 4294967296.0 * +($1_1 | 0));
 }
 
 function $15($0_1) {
  $0_1 = $0_1 | 0;
  return Math_fround(Math_fround($0_1 >>> 0));
 }
 
 function $16($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  return Math_fround(Math_fround(+($0_1 >>> 0) + 4294967296.0 * +($1_1 >>> 0)));
 }
 
 function $17($0_1) {
  $0_1 = $0_1 | 0;
  return +(+($0_1 >>> 0));
 }
 
 function $18($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  return +(+($0_1 >>> 0) + 4294967296.0 * +($1_1 >>> 0));
 }
 
 function $19($0_1) {
  $0_1 = Math_fround($0_1);
  return +(+$0_1);
 }
 
 function $20($0_1) {
  $0_1 = +$0_1;
  return Math_fround(Math_fround($0_1));
 }
 
 function $21($0_1) {
  $0_1 = $0_1 | 0;
  return Math_fround((wasm2js_scratch_store_i32(0, $0_1), wasm2js_scratch_load_f32()));
 }
 
 function $22($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  wasm2js_scratch_store_i32(0 | 0, $0_1 | 0);
  wasm2js_scratch_store_i32(1 | 0, $1_1 | 0);
  return +(+wasm2js_scratch_load_f64());
 }
 
 function $23($0_1) {
  $0_1 = Math_fround($0_1);
  return (wasm2js_scratch_store_f32($0_1), wasm2js_scratch_load_i32(0)) | 0;
 }
 
 function $24($0_1) {
  $0_1 = +$0_1;
  var $1_1 = 0, $2_1 = 0;
  wasm2js_scratch_store_f64(+$0_1);
  $1_1 = wasm2js_scratch_load_i32(1 | 0) | 0;
  $2_1 = wasm2js_scratch_load_i32(0 | 0) | 0;
  i64toi32_i32$HIGH_BITS = $1_1;
  return $2_1 | 0;
 }
 
 function legalstub$0($0_1) {
  $0_1 = $0_1 | 0;
  var $1_1 = 0, $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0;
  $0_1 = $0($0_1 | 0) | 0;
  $2_1 = i64toi32_i32$HIGH_BITS;
  $4_1 = $0_1;
  $5_1 = $2_1;
  $3_1 = 32;
  $1_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   $0_1 = $2_1 >>> $1_1 | 0
  } else {
   $0_1 = (((1 << $1_1 | 0) - 1 | 0) & $2_1 | 0) << (32 - $1_1 | 0) | 0 | ($0_1 >>> $1_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $4_1 | 0;
 }
 
 function legalstub$1($0_1) {
  $0_1 = $0_1 | 0;
  var $1_1 = 0, $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0;
  $0_1 = $1($0_1 | 0) | 0;
  $2_1 = i64toi32_i32$HIGH_BITS;
  $4_1 = $0_1;
  $5_1 = $2_1;
  $3_1 = 32;
  $1_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   $0_1 = $2_1 >>> $1_1 | 0
  } else {
   $0_1 = (((1 << $1_1 | 0) - 1 | 0) & $2_1 | 0) << (32 - $1_1 | 0) | 0 | ($0_1 >>> $1_1 | 0) | 0
  }
  setTempRet0($0_1 | 0);
  return $4_1 | 0;
 }
 
 function legalstub$2($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0, $6_1 = 0;
  $2_1 = 0;
  $6_1 = $2_1;
  $2_1 = 0;
  $3_1 = 32;
  $4_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   {
    $5_1 = $1_1 << $4_1 | 0;
    $3_1 = 0;
   }
  } else {
   {
    $5_1 = ((1 << $4_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $4_1 | 0) | 0) | 0 | ($2_1 << $4_1 | 0) | 0;
    $3_1 = $1_1 << $4_1 | 0;
   }
  }
  $1_1 = $5_1;
  $5_1 = $6_1;
  $2_1 = $0_1;
  $1_1 = $5_1 | $1_1 | 0;
  return $2($2_1 | $3_1 | 0 | 0, $1_1 | 0) | 0 | 0;
 }
 
 function legalstub$7($0_1) {
  $0_1 = Math_fround($0_1);
  var $1_1 = 0, $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0, $6_1 = 0;
  $1_1 = $7(Math_fround($0_1)) | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  $5_1 = $1_1;
  $6_1 = $3_1;
  $4_1 = 32;
  $2_1 = $4_1 & 31 | 0;
  if (32 >>> 0 <= ($4_1 & 63 | 0) >>> 0) {
   $1_1 = $3_1 >>> $2_1 | 0
  } else {
   $1_1 = (((1 << $2_1 | 0) - 1 | 0) & $3_1 | 0) << (32 - $2_1 | 0) | 0 | ($1_1 >>> $2_1 | 0) | 0
  }
  setTempRet0($1_1 | 0);
  return $5_1 | 0;
 }
 
 function legalstub$8($0_1) {
  $0_1 = Math_fround($0_1);
  var $1_1 = 0, $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0, $6_1 = 0;
  $1_1 = $8(Math_fround($0_1)) | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  $5_1 = $1_1;
  $6_1 = $3_1;
  $4_1 = 32;
  $2_1 = $4_1 & 31 | 0;
  if (32 >>> 0 <= ($4_1 & 63 | 0) >>> 0) {
   $1_1 = $3_1 >>> $2_1 | 0
  } else {
   $1_1 = (((1 << $2_1 | 0) - 1 | 0) & $3_1 | 0) << (32 - $2_1 | 0) | 0 | ($1_1 >>> $2_1 | 0) | 0
  }
  setTempRet0($1_1 | 0);
  return $5_1 | 0;
 }
 
 function legalstub$9($0_1) {
  $0_1 = +$0_1;
  var $1_1 = 0, $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0, $6_1 = 0;
  $1_1 = $9(+$0_1) | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  $5_1 = $1_1;
  $6_1 = $3_1;
  $4_1 = 32;
  $2_1 = $4_1 & 31 | 0;
  if (32 >>> 0 <= ($4_1 & 63 | 0) >>> 0) {
   $1_1 = $3_1 >>> $2_1 | 0
  } else {
   $1_1 = (((1 << $2_1 | 0) - 1 | 0) & $3_1 | 0) << (32 - $2_1 | 0) | 0 | ($1_1 >>> $2_1 | 0) | 0
  }
  setTempRet0($1_1 | 0);
  return $5_1 | 0;
 }
 
 function legalstub$10($0_1) {
  $0_1 = +$0_1;
  var $1_1 = 0, $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0, $6_1 = 0;
  $1_1 = $10(+$0_1) | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  $5_1 = $1_1;
  $6_1 = $3_1;
  $4_1 = 32;
  $2_1 = $4_1 & 31 | 0;
  if (32 >>> 0 <= ($4_1 & 63 | 0) >>> 0) {
   $1_1 = $3_1 >>> $2_1 | 0
  } else {
   $1_1 = (((1 << $2_1 | 0) - 1 | 0) & $3_1 | 0) << (32 - $2_1 | 0) | 0 | ($1_1 >>> $2_1 | 0) | 0
  }
  setTempRet0($1_1 | 0);
  return $5_1 | 0;
 }
 
 function legalstub$12($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0, $6_1 = 0;
  $2_1 = 0;
  $6_1 = $2_1;
  $2_1 = 0;
  $3_1 = 32;
  $4_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   {
    $5_1 = $1_1 << $4_1 | 0;
    $3_1 = 0;
   }
  } else {
   {
    $5_1 = ((1 << $4_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $4_1 | 0) | 0) | 0 | ($2_1 << $4_1 | 0) | 0;
    $3_1 = $1_1 << $4_1 | 0;
   }
  }
  $1_1 = $5_1;
  $5_1 = $6_1;
  $2_1 = $0_1;
  $1_1 = $5_1 | $1_1 | 0;
  return Math_fround(Math_fround($12($2_1 | $3_1 | 0 | 0, $1_1 | 0)));
 }
 
 function legalstub$14($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0, $6_1 = 0;
  $2_1 = 0;
  $6_1 = $2_1;
  $2_1 = 0;
  $3_1 = 32;
  $4_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   {
    $5_1 = $1_1 << $4_1 | 0;
    $3_1 = 0;
   }
  } else {
   {
    $5_1 = ((1 << $4_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $4_1 | 0) | 0) | 0 | ($2_1 << $4_1 | 0) | 0;
    $3_1 = $1_1 << $4_1 | 0;
   }
  }
  $1_1 = $5_1;
  $5_1 = $6_1;
  $2_1 = $0_1;
  $1_1 = $5_1 | $1_1 | 0;
  return +(+$14($2_1 | $3_1 | 0 | 0, $1_1 | 0));
 }
 
 function legalstub$16($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0, $6_1 = 0;
  $2_1 = 0;
  $6_1 = $2_1;
  $2_1 = 0;
  $3_1 = 32;
  $4_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   {
    $5_1 = $1_1 << $4_1 | 0;
    $3_1 = 0;
   }
  } else {
   {
    $5_1 = ((1 << $4_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $4_1 | 0) | 0) | 0 | ($2_1 << $4_1 | 0) | 0;
    $3_1 = $1_1 << $4_1 | 0;
   }
  }
  $1_1 = $5_1;
  $5_1 = $6_1;
  $2_1 = $0_1;
  $1_1 = $5_1 | $1_1 | 0;
  return Math_fround(Math_fround($16($2_1 | $3_1 | 0 | 0, $1_1 | 0)));
 }
 
 function legalstub$18($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0, $6_1 = 0;
  $2_1 = 0;
  $6_1 = $2_1;
  $2_1 = 0;
  $3_1 = 32;
  $4_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   {
    $5_1 = $1_1 << $4_1 | 0;
    $3_1 = 0;
   }
  } else {
   {
    $5_1 = ((1 << $4_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $4_1 | 0) | 0) | 0 | ($2_1 << $4_1 | 0) | 0;
    $3_1 = $1_1 << $4_1 | 0;
   }
  }
  $1_1 = $5_1;
  $5_1 = $6_1;
  $2_1 = $0_1;
  $1_1 = $5_1 | $1_1 | 0;
  return +(+$18($2_1 | $3_1 | 0 | 0, $1_1 | 0));
 }
 
 function legalstub$22($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0, $6_1 = 0;
  $2_1 = 0;
  $6_1 = $2_1;
  $2_1 = 0;
  $3_1 = 32;
  $4_1 = $3_1 & 31 | 0;
  if (32 >>> 0 <= ($3_1 & 63 | 0) >>> 0) {
   {
    $5_1 = $1_1 << $4_1 | 0;
    $3_1 = 0;
   }
  } else {
   {
    $5_1 = ((1 << $4_1 | 0) - 1 | 0) & ($1_1 >>> (32 - $4_1 | 0) | 0) | 0 | ($2_1 << $4_1 | 0) | 0;
    $3_1 = $1_1 << $4_1 | 0;
   }
  }
  $1_1 = $5_1;
  $5_1 = $6_1;
  $2_1 = $0_1;
  $1_1 = $5_1 | $1_1 | 0;
  return +(+$22($2_1 | $3_1 | 0 | 0, $1_1 | 0));
 }
 
 function legalstub$24($0_1) {
  $0_1 = +$0_1;
  var $1_1 = 0, $2_1 = 0, $3_1 = 0, $4_1 = 0, $5_1 = 0, $6_1 = 0;
  $1_1 = $24(+$0_1) | 0;
  $3_1 = i64toi32_i32$HIGH_BITS;
  $5_1 = $1_1;
  $6_1 = $3_1;
  $4_1 = 32;
  $2_1 = $4_1 & 31 | 0;
  if (32 >>> 0 <= ($4_1 & 63 | 0) >>> 0) {
   $1_1 = $3_1 >>> $2_1 | 0
  } else {
   $1_1 = (((1 << $2_1 | 0) - 1 | 0) & $3_1 | 0) << (32 - $2_1 | 0) | 0 | ($1_1 >>> $2_1 | 0) | 0
  }
  setTempRet0($1_1 | 0);
  return $5_1 | 0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "i64_extend_s_i32": legalstub$0, 
  "i64_extend_u_i32": legalstub$1, 
  "i32_wrap_i64": legalstub$2, 
  "i32_trunc_s_f32": $3, 
  "i32_trunc_u_f32": $4, 
  "i32_trunc_s_f64": $5, 
  "i32_trunc_u_f64": $6, 
  "i64_trunc_s_f32": legalstub$7, 
  "i64_trunc_u_f32": legalstub$8, 
  "i64_trunc_s_f64": legalstub$9, 
  "i64_trunc_u_f64": legalstub$10, 
  "f32_convert_s_i32": $11, 
  "f32_convert_s_i64": legalstub$12, 
  "f64_convert_s_i32": $13, 
  "f64_convert_s_i64": legalstub$14, 
  "f32_convert_u_i32": $15, 
  "f32_convert_u_i64": legalstub$16, 
  "f64_convert_u_i32": $17, 
  "f64_convert_u_i64": legalstub$18, 
  "f64_promote_f32": $19, 
  "f32_demote_f64": $20, 
  "f32_reinterpret_i32": $21, 
  "f64_reinterpret_i64": legalstub$22, 
  "i32_reinterpret_f32": $23, 
  "i64_reinterpret_f64": legalstub$24
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0},memasmFunc);
export var i64_extend_s_i32 = retasmFunc.i64_extend_s_i32;
export var i64_extend_u_i32 = retasmFunc.i64_extend_u_i32;
export var i32_wrap_i64 = retasmFunc.i32_wrap_i64;
export var i32_trunc_s_f32 = retasmFunc.i32_trunc_s_f32;
export var i32_trunc_u_f32 = retasmFunc.i32_trunc_u_f32;
export var i32_trunc_s_f64 = retasmFunc.i32_trunc_s_f64;
export var i32_trunc_u_f64 = retasmFunc.i32_trunc_u_f64;
export var i64_trunc_s_f32 = retasmFunc.i64_trunc_s_f32;
export var i64_trunc_u_f32 = retasmFunc.i64_trunc_u_f32;
export var i64_trunc_s_f64 = retasmFunc.i64_trunc_s_f64;
export var i64_trunc_u_f64 = retasmFunc.i64_trunc_u_f64;
export var f32_convert_s_i32 = retasmFunc.f32_convert_s_i32;
export var f32_convert_s_i64 = retasmFunc.f32_convert_s_i64;
export var f64_convert_s_i32 = retasmFunc.f64_convert_s_i32;
export var f64_convert_s_i64 = retasmFunc.f64_convert_s_i64;
export var f32_convert_u_i32 = retasmFunc.f32_convert_u_i32;
export var f32_convert_u_i64 = retasmFunc.f32_convert_u_i64;
export var f64_convert_u_i32 = retasmFunc.f64_convert_u_i32;
export var f64_convert_u_i64 = retasmFunc.f64_convert_u_i64;
export var f64_promote_f32 = retasmFunc.f64_promote_f32;
export var f32_demote_f64 = retasmFunc.f32_demote_f64;
export var f32_reinterpret_i32 = retasmFunc.f32_reinterpret_i32;
export var f64_reinterpret_i64 = retasmFunc.f64_reinterpret_i64;
export var i32_reinterpret_f32 = retasmFunc.i32_reinterpret_f32;
export var i64_reinterpret_f64 = retasmFunc.i64_reinterpret_f64;
