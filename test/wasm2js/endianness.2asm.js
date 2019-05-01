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
      
  function wasm2js_scratch_store_f32(value) {
    f32ScratchView[0] = value;
  }
      
  function wasm2js_scratch_load_f32() {
    return f32ScratchView[0];
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
 function i16_store_little($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  HEAP8[$0 >> 0] = $1;
  HEAP8[($0 + 1 | 0) >> 0] = $1 >>> 8 | 0;
 }
 
 function i32_store_little($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  i16_store_little($0 | 0, $1 | 0);
  i16_store_little($0 + 2 | 0 | 0, $1 >>> 16 | 0 | 0);
 }
 
 function i64_store_little($0, $1, $2) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2 = $2 | 0;
  var $3 = 0, $4 = 0;
  i32_store_little($0 | 0, $1 | 0);
  $0 = $0 + 4 | 0;
  $4 = 32;
  $3 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $1 = $2 >>> $3 | 0
  } else {
   $1 = (((1 << $3 | 0) - 1 | 0) & $2 | 0) << (32 - $3 | 0) | 0 | ($1 >>> $3 | 0) | 0
  }
  i32_store_little($0 | 0, $1 | 0);
 }
 
 function i16_load_little($0) {
  $0 = $0 | 0;
  return HEAPU8[$0 >> 0] | 0 | ((HEAPU8[($0 + 1 | 0) >> 0] | 0) << 8 | 0) | 0 | 0;
 }
 
 function i32_load_little($0) {
  $0 = $0 | 0;
  return i16_load_little($0 | 0) | 0 | ((i16_load_little($0 + 2 | 0 | 0) | 0) << 16 | 0) | 0 | 0;
 }
 
 function i64_load_little($0) {
  $0 = $0 | 0;
  var $1 = 0, $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6_1 = 0;
  $1 = 0;
  $5 = i32_load_little($0 | 0) | 0;
  $6_1 = $1;
  $1 = 0;
  $0 = i32_load_little($0 + 4 | 0 | 0) | 0;
  $2 = 32;
  $3 = $2 & 31 | 0;
  if (32 >>> 0 <= ($2 & 63 | 0) >>> 0) {
   {
    $4 = $0 << $3 | 0;
    $2 = 0;
   }
  } else {
   {
    $4 = ((1 << $3 | 0) - 1 | 0) & ($0 >>> (32 - $3 | 0) | 0) | 0 | ($1 << $3 | 0) | 0;
    $2 = $0 << $3 | 0;
   }
  }
  $0 = $4;
  $4 = $6_1;
  $1 = $5;
  $0 = $4 | $0 | 0;
  $1 = $1 | $2 | 0;
  i64toi32_i32$HIGH_BITS = $0;
  return $1 | 0;
 }
 
 function $6($0) {
  $0 = $0 | 0;
  i16_store_little(0 | 0, $0 | 0);
  return HEAP16[0 >> 1] | 0 | 0;
 }
 
 function $7($0) {
  $0 = $0 | 0;
  i16_store_little(0 | 0, $0 | 0);
  return HEAPU16[0 >> 1] | 0 | 0;
 }
 
 function $8($0) {
  $0 = $0 | 0;
  i32_store_little(0 | 0, $0 | 0);
  return HEAP32[0 >> 2] | 0 | 0;
 }
 
 function $9($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  i16_store_little(0 | 0, $0 | 0);
  $1 = HEAP16[0 >> 1] | 0;
  $0 = $1 >> 31 | 0;
  i64toi32_i32$HIGH_BITS = $0;
  return $1 | 0;
 }
 
 function $10($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  i16_store_little(0 | 0, $0 | 0);
  $1 = HEAPU16[0 >> 1] | 0;
  $0 = 0;
  i64toi32_i32$HIGH_BITS = $0;
  return $1 | 0;
 }
 
 function $11($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  i32_store_little(0 | 0, $0 | 0);
  $1 = HEAP32[0 >> 2] | 0;
  $0 = $1 >> 31 | 0;
  i64toi32_i32$HIGH_BITS = $0;
  return $1 | 0;
 }
 
 function $12($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  i32_store_little(0 | 0, $0 | 0);
  $1 = HEAP32[0 >> 2] | 0;
  $0 = 0;
  i64toi32_i32$HIGH_BITS = $0;
  return $1 | 0;
 }
 
 function $13($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  i64_store_little(0 | 0, $0 | 0, $1 | 0);
  $0 = 0;
  $1 = HEAP32[$0 >> 2] | 0;
  $0 = HEAP32[($0 + 4 | 0) >> 2] | 0;
  i64toi32_i32$HIGH_BITS = $0;
  return $1 | 0;
 }
 
 function $14($0) {
  $0 = Math_fround($0);
  i32_store_little(0 | 0, (wasm2js_scratch_store_f32($0), wasm2js_scratch_load_i32(0)) | 0);
  return Math_fround(Math_fround(HEAPF32[0 >> 2]));
 }
 
 function $15($0) {
  $0 = +$0;
  var $1 = 0;
  wasm2js_scratch_store_f64(+$0);
  $1 = wasm2js_scratch_load_i32(1 | 0) | 0;
  i64_store_little(0 | 0, wasm2js_scratch_load_i32(0 | 0) | 0 | 0, $1 | 0);
  return +(+HEAPF64[0 >> 3]);
 }
 
 function $16($0) {
  $0 = $0 | 0;
  HEAP16[0 >> 1] = $0;
  return i16_load_little(0 | 0) | 0 | 0;
 }
 
 function $17($0) {
  $0 = $0 | 0;
  HEAP32[0 >> 2] = $0;
  return i32_load_little(0 | 0) | 0 | 0;
 }
 
 function $18($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  HEAP16[0 >> 1] = $0;
  $1 = 0;
  $0 = i16_load_little(0 | 0) | 0;
  i64toi32_i32$HIGH_BITS = $1;
  return $0 | 0;
 }
 
 function $19($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  HEAP32[0 >> 2] = $0;
  $1 = 0;
  $0 = i32_load_little(0 | 0) | 0;
  i64toi32_i32$HIGH_BITS = $1;
  return $0 | 0;
 }
 
 function $20($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var $2 = 0;
  $2 = 0;
  HEAP32[$2 >> 2] = $0;
  HEAP32[($2 + 4 | 0) >> 2] = $1;
  $1 = i64_load_little(0 | 0) | 0;
  $2 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = $2;
  return $1 | 0;
 }
 
 function $21($0) {
  $0 = Math_fround($0);
  HEAPF32[0 >> 2] = $0;
  return Math_fround((wasm2js_scratch_store_i32(0, i32_load_little(0 | 0) | 0), wasm2js_scratch_load_f32()));
 }
 
 function $22($0) {
  $0 = +$0;
  var $1 = 0, $2 = 0;
  HEAPF64[0 >> 3] = $0;
  $1 = i64_load_little(0 | 0) | 0;
  $2 = i64toi32_i32$HIGH_BITS;
  wasm2js_scratch_store_i32(0 | 0, $1 | 0);
  wasm2js_scratch_store_i32(1 | 0, $2 | 0);
  return +(+wasm2js_scratch_load_f64());
 }
 
 function legalstub$9($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6_1 = 0;
  $3 = 0;
  $5 = $0;
  $6_1 = $3;
  $3 = 0;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0 = $1 << $2 | 0;
    $4 = 0;
   }
  } else {
   {
    $0 = ((1 << $2 | 0) - 1 | 0) & ($1 >>> (32 - $2 | 0) | 0) | 0 | ($3 << $2 | 0) | 0;
    $4 = $1 << $2 | 0;
   }
  }
  $1 = $0;
  $0 = $6_1;
  $3 = $5;
  $1 = $0 | $1 | 0;
  $1 = $9($3 | $4 | 0 | 0, $1 | 0) | 0;
  $3 = i64toi32_i32$HIGH_BITS;
  $6_1 = $1;
  $5 = $3;
  $0 = $1;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0 = $3 >>> $2 | 0
  } else {
   $0 = (((1 << $2 | 0) - 1 | 0) & $3 | 0) << (32 - $2 | 0) | 0 | ($0 >>> $2 | 0) | 0
  }
  setTempRet0($0 | 0);
  return $6_1 | 0;
 }
 
 function legalstub$10($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6_1 = 0;
  $3 = 0;
  $5 = $0;
  $6_1 = $3;
  $3 = 0;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0 = $1 << $2 | 0;
    $4 = 0;
   }
  } else {
   {
    $0 = ((1 << $2 | 0) - 1 | 0) & ($1 >>> (32 - $2 | 0) | 0) | 0 | ($3 << $2 | 0) | 0;
    $4 = $1 << $2 | 0;
   }
  }
  $1 = $0;
  $0 = $6_1;
  $3 = $5;
  $1 = $0 | $1 | 0;
  $1 = $10($3 | $4 | 0 | 0, $1 | 0) | 0;
  $3 = i64toi32_i32$HIGH_BITS;
  $6_1 = $1;
  $5 = $3;
  $0 = $1;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0 = $3 >>> $2 | 0
  } else {
   $0 = (((1 << $2 | 0) - 1 | 0) & $3 | 0) << (32 - $2 | 0) | 0 | ($0 >>> $2 | 0) | 0
  }
  setTempRet0($0 | 0);
  return $6_1 | 0;
 }
 
 function legalstub$11($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6_1 = 0;
  $3 = 0;
  $5 = $0;
  $6_1 = $3;
  $3 = 0;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0 = $1 << $2 | 0;
    $4 = 0;
   }
  } else {
   {
    $0 = ((1 << $2 | 0) - 1 | 0) & ($1 >>> (32 - $2 | 0) | 0) | 0 | ($3 << $2 | 0) | 0;
    $4 = $1 << $2 | 0;
   }
  }
  $1 = $0;
  $0 = $6_1;
  $3 = $5;
  $1 = $0 | $1 | 0;
  $1 = $11($3 | $4 | 0 | 0, $1 | 0) | 0;
  $3 = i64toi32_i32$HIGH_BITS;
  $6_1 = $1;
  $5 = $3;
  $0 = $1;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0 = $3 >>> $2 | 0
  } else {
   $0 = (((1 << $2 | 0) - 1 | 0) & $3 | 0) << (32 - $2 | 0) | 0 | ($0 >>> $2 | 0) | 0
  }
  setTempRet0($0 | 0);
  return $6_1 | 0;
 }
 
 function legalstub$12($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6_1 = 0;
  $3 = 0;
  $5 = $0;
  $6_1 = $3;
  $3 = 0;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0 = $1 << $2 | 0;
    $4 = 0;
   }
  } else {
   {
    $0 = ((1 << $2 | 0) - 1 | 0) & ($1 >>> (32 - $2 | 0) | 0) | 0 | ($3 << $2 | 0) | 0;
    $4 = $1 << $2 | 0;
   }
  }
  $1 = $0;
  $0 = $6_1;
  $3 = $5;
  $1 = $0 | $1 | 0;
  $1 = $12($3 | $4 | 0 | 0, $1 | 0) | 0;
  $3 = i64toi32_i32$HIGH_BITS;
  $6_1 = $1;
  $5 = $3;
  $0 = $1;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0 = $3 >>> $2 | 0
  } else {
   $0 = (((1 << $2 | 0) - 1 | 0) & $3 | 0) << (32 - $2 | 0) | 0 | ($0 >>> $2 | 0) | 0
  }
  setTempRet0($0 | 0);
  return $6_1 | 0;
 }
 
 function legalstub$13($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6_1 = 0;
  $3 = 0;
  $5 = $0;
  $6_1 = $3;
  $3 = 0;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0 = $1 << $2 | 0;
    $4 = 0;
   }
  } else {
   {
    $0 = ((1 << $2 | 0) - 1 | 0) & ($1 >>> (32 - $2 | 0) | 0) | 0 | ($3 << $2 | 0) | 0;
    $4 = $1 << $2 | 0;
   }
  }
  $1 = $0;
  $0 = $6_1;
  $3 = $5;
  $1 = $0 | $1 | 0;
  $1 = $13($3 | $4 | 0 | 0, $1 | 0) | 0;
  $3 = i64toi32_i32$HIGH_BITS;
  $6_1 = $1;
  $5 = $3;
  $0 = $1;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0 = $3 >>> $2 | 0
  } else {
   $0 = (((1 << $2 | 0) - 1 | 0) & $3 | 0) << (32 - $2 | 0) | 0 | ($0 >>> $2 | 0) | 0
  }
  setTempRet0($0 | 0);
  return $6_1 | 0;
 }
 
 function legalstub$18($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6_1 = 0;
  $3 = 0;
  $5 = $0;
  $6_1 = $3;
  $3 = 0;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0 = $1 << $2 | 0;
    $4 = 0;
   }
  } else {
   {
    $0 = ((1 << $2 | 0) - 1 | 0) & ($1 >>> (32 - $2 | 0) | 0) | 0 | ($3 << $2 | 0) | 0;
    $4 = $1 << $2 | 0;
   }
  }
  $1 = $0;
  $0 = $6_1;
  $3 = $5;
  $1 = $0 | $1 | 0;
  $1 = $18($3 | $4 | 0 | 0, $1 | 0) | 0;
  $3 = i64toi32_i32$HIGH_BITS;
  $6_1 = $1;
  $5 = $3;
  $0 = $1;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0 = $3 >>> $2 | 0
  } else {
   $0 = (((1 << $2 | 0) - 1 | 0) & $3 | 0) << (32 - $2 | 0) | 0 | ($0 >>> $2 | 0) | 0
  }
  setTempRet0($0 | 0);
  return $6_1 | 0;
 }
 
 function legalstub$19($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6_1 = 0;
  $3 = 0;
  $5 = $0;
  $6_1 = $3;
  $3 = 0;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0 = $1 << $2 | 0;
    $4 = 0;
   }
  } else {
   {
    $0 = ((1 << $2 | 0) - 1 | 0) & ($1 >>> (32 - $2 | 0) | 0) | 0 | ($3 << $2 | 0) | 0;
    $4 = $1 << $2 | 0;
   }
  }
  $1 = $0;
  $0 = $6_1;
  $3 = $5;
  $1 = $0 | $1 | 0;
  $1 = $19($3 | $4 | 0 | 0, $1 | 0) | 0;
  $3 = i64toi32_i32$HIGH_BITS;
  $6_1 = $1;
  $5 = $3;
  $0 = $1;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0 = $3 >>> $2 | 0
  } else {
   $0 = (((1 << $2 | 0) - 1 | 0) & $3 | 0) << (32 - $2 | 0) | 0 | ($0 >>> $2 | 0) | 0
  }
  setTempRet0($0 | 0);
  return $6_1 | 0;
 }
 
 function legalstub$20($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6_1 = 0;
  $3 = 0;
  $5 = $0;
  $6_1 = $3;
  $3 = 0;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   {
    $0 = $1 << $2 | 0;
    $4 = 0;
   }
  } else {
   {
    $0 = ((1 << $2 | 0) - 1 | 0) & ($1 >>> (32 - $2 | 0) | 0) | 0 | ($3 << $2 | 0) | 0;
    $4 = $1 << $2 | 0;
   }
  }
  $1 = $0;
  $0 = $6_1;
  $3 = $5;
  $1 = $0 | $1 | 0;
  $1 = $20($3 | $4 | 0 | 0, $1 | 0) | 0;
  $3 = i64toi32_i32$HIGH_BITS;
  $6_1 = $1;
  $5 = $3;
  $0 = $1;
  $4 = 32;
  $2 = $4 & 31 | 0;
  if (32 >>> 0 <= ($4 & 63 | 0) >>> 0) {
   $0 = $3 >>> $2 | 0
  } else {
   $0 = (((1 << $2 | 0) - 1 | 0) & $3 | 0) << (32 - $2 | 0) | 0 | ($0 >>> $2 | 0) | 0
  }
  setTempRet0($0 | 0);
  return $6_1 | 0;
 }
 
 var FUNCTION_TABLE = [];
 function __wasm_grow_memory(pagesToAdd) {
  pagesToAdd = pagesToAdd | 0;
  var oldPages = __wasm_current_memory() | 0;
  var newPages = oldPages + pagesToAdd | 0;
  if ((oldPages < newPages) && (newPages < 65536)) {
   {
    var newBuffer = new ArrayBuffer(Math_imul(newPages, 65536));
    var newHEAP8 = new global.Int8Array(newBuffer);
    newHEAP8.set(HEAP8);
    HEAP8 = newHEAP8;
    HEAP16 = new global.Int16Array(newBuffer);
    HEAP32 = new global.Int32Array(newBuffer);
    HEAPU8 = new global.Uint8Array(newBuffer);
    HEAPU16 = new global.Uint16Array(newBuffer);
    HEAPU32 = new global.Uint32Array(newBuffer);
    HEAPF32 = new global.Float32Array(newBuffer);
    HEAPF64 = new global.Float64Array(newBuffer);
    buffer = newBuffer;
   }
  }
  return oldPages;
 }
 
 function __wasm_current_memory() {
  return buffer.byteLength / 65536 | 0;
 }
 
 return {
  "i32_load16_s": $6, 
  "i32_load16_u": $7, 
  "i32_load": $8, 
  "i64_load16_s": legalstub$9, 
  "i64_load16_u": legalstub$10, 
  "i64_load32_s": legalstub$11, 
  "i64_load32_u": legalstub$12, 
  "i64_load": legalstub$13, 
  "f32_load": $14, 
  "f64_load": $15, 
  "i32_store16": $16, 
  "i32_store": $17, 
  "i64_store16": legalstub$18, 
  "i64_store32": legalstub$19, 
  "i64_store": legalstub$20, 
  "f32_store": $21, 
  "f64_store": $22
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0},memasmFunc);
export var i32_load16_s = retasmFunc.i32_load16_s;
export var i32_load16_u = retasmFunc.i32_load16_u;
export var i32_load = retasmFunc.i32_load;
export var i64_load16_s = retasmFunc.i64_load16_s;
export var i64_load16_u = retasmFunc.i64_load16_u;
export var i64_load32_s = retasmFunc.i64_load32_s;
export var i64_load32_u = retasmFunc.i64_load32_u;
export var i64_load = retasmFunc.i64_load;
export var f32_load = retasmFunc.f32_load;
export var f64_load = retasmFunc.f64_load;
export var i32_store16 = retasmFunc.i32_store16;
export var i32_store = retasmFunc.i32_store;
export var i64_store16 = retasmFunc.i64_store16;
export var i64_store32 = retasmFunc.i64_store32;
export var i64_store = retasmFunc.i64_store;
export var f32_store = retasmFunc.f32_store;
export var f64_store = retasmFunc.f64_store;
