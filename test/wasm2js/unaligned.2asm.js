import { setTempRet0 } from 'env';

  var bufferView;

  var scratchBuffer = new ArrayBuffer(16);
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
    return f32ScratchView[2];
  }
      
  function wasm2js_scratch_store_f32(value) {
    f32ScratchView[2] = value;
  }
      
function asmFunc(env) {
 var buffer = new ArrayBuffer(65536);
 var HEAP8 = new Int8Array(buffer);
 var HEAP16 = new Int16Array(buffer);
 var HEAP32 = new Int32Array(buffer);
 var HEAPU8 = new Uint8Array(buffer);
 var HEAPU16 = new Uint16Array(buffer);
 var HEAPU32 = new Uint32Array(buffer);
 var HEAPF32 = new Float32Array(buffer);
 var HEAPF64 = new Float64Array(buffer);
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
 var abort = env.abort;
 var nan = NaN;
 var infinity = Infinity;
 var setTempRet0 = env.setTempRet0;
 var i64toi32_i32$HIGH_BITS = 0;
 function $0() {
  var $0_1 = 0;
  $0_1 = 0;
  return HEAPU8[$0_1 >> 0] | 0 | ((HEAPU8[($0_1 + 1 | 0) >> 0] | 0) << 8 | 0) | 0 | ((HEAPU8[($0_1 + 2 | 0) >> 0] | 0) << 16 | 0 | ((HEAPU8[($0_1 + 3 | 0) >> 0] | 0) << 24 | 0) | 0) | 0 | 0;
 }
 
 function $1() {
  var $2_1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  $2_1 = 0;
  i64toi32_i32$0 = HEAPU8[$2_1 >> 0] | 0 | ((HEAPU8[($2_1 + 1 | 0) >> 0] | 0) << 8 | 0) | 0 | ((HEAPU8[($2_1 + 2 | 0) >> 0] | 0) << 16 | 0 | ((HEAPU8[($2_1 + 3 | 0) >> 0] | 0) << 24 | 0) | 0) | 0;
  i64toi32_i32$1 = HEAPU8[($2_1 + 4 | 0) >> 0] | 0 | ((HEAPU8[($2_1 + 5 | 0) >> 0] | 0) << 8 | 0) | 0 | ((HEAPU8[($2_1 + 6 | 0) >> 0] | 0) << 16 | 0 | ((HEAPU8[($2_1 + 7 | 0) >> 0] | 0) << 24 | 0) | 0) | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $2() {
  var $0_1 = 0;
  $0_1 = 0;
  return Math_fround((wasm2js_scratch_store_i32(2, HEAPU8[$0_1 >> 0] | 0 | ((HEAPU8[($0_1 + 1 | 0) >> 0] | 0) << 8 | 0) | 0 | ((HEAPU8[($0_1 + 2 | 0) >> 0] | 0) << 16 | 0 | ((HEAPU8[($0_1 + 3 | 0) >> 0] | 0) << 24 | 0) | 0) | 0), wasm2js_scratch_load_f32()));
 }
 
 function $3() {
  var $1_1 = 0, i64toi32_i32$1 = 0;
  $1_1 = 0;
  i64toi32_i32$1 = HEAPU8[($1_1 + 4 | 0) >> 0] | 0 | ((HEAPU8[($1_1 + 5 | 0) >> 0] | 0) << 8 | 0) | 0 | ((HEAPU8[($1_1 + 6 | 0) >> 0] | 0) << 16 | 0 | ((HEAPU8[($1_1 + 7 | 0) >> 0] | 0) << 24 | 0) | 0) | 0;
  wasm2js_scratch_store_i32(0 | 0, HEAPU8[$1_1 >> 0] | 0 | ((HEAPU8[($1_1 + 1 | 0) >> 0] | 0) << 8 | 0) | 0 | ((HEAPU8[($1_1 + 2 | 0) >> 0] | 0) << 16 | 0 | ((HEAPU8[($1_1 + 3 | 0) >> 0] | 0) << 24 | 0) | 0) | 0 | 0);
  wasm2js_scratch_store_i32(1 | 0, i64toi32_i32$1 | 0);
  return +(+wasm2js_scratch_load_f64());
 }
 
 function $4() {
  var $0_1 = 0, $1_1 = 0;
  $0_1 = 0;
  $1_1 = 0;
  HEAP8[$0_1 >> 0] = $1_1;
  HEAP8[($0_1 + 1 | 0) >> 0] = $1_1 >>> 8 | 0;
  HEAP8[($0_1 + 2 | 0) >> 0] = $1_1 >>> 16 | 0;
  HEAP8[($0_1 + 3 | 0) >> 0] = $1_1 >>> 24 | 0;
 }
 
 function $5() {
  var $0_1 = 0, $1_1 = 0, $2_1 = 0;
  $0_1 = 0;
  $1_1 = 0;
  HEAP8[$0_1 >> 0] = $1_1;
  HEAP8[($0_1 + 1 | 0) >> 0] = $1_1 >>> 8 | 0;
  HEAP8[($0_1 + 2 | 0) >> 0] = $1_1 >>> 16 | 0;
  HEAP8[($0_1 + 3 | 0) >> 0] = $1_1 >>> 24 | 0;
  $2_1 = 0;
  HEAP8[($0_1 + 4 | 0) >> 0] = $2_1;
  HEAP8[($0_1 + 5 | 0) >> 0] = $2_1 >>> 8 | 0;
  HEAP8[($0_1 + 6 | 0) >> 0] = $2_1 >>> 16 | 0;
  HEAP8[($0_1 + 7 | 0) >> 0] = $2_1 >>> 24 | 0;
 }
 
 function $6() {
  var $0_1 = 0, $1_1 = 0;
  $0_1 = 0;
  $1_1 = (wasm2js_scratch_store_f32(Math_fround(0.0)), wasm2js_scratch_load_i32(2));
  HEAP8[$0_1 >> 0] = $1_1;
  HEAP8[($0_1 + 1 | 0) >> 0] = $1_1 >>> 8 | 0;
  HEAP8[($0_1 + 2 | 0) >> 0] = $1_1 >>> 16 | 0;
  HEAP8[($0_1 + 3 | 0) >> 0] = $1_1 >>> 24 | 0;
 }
 
 function $7() {
  var $1_1 = 0, $2_1 = 0, $3_1 = 0, i64toi32_i32$0 = 0;
  wasm2js_scratch_store_f64(+(0.0));
  i64toi32_i32$0 = wasm2js_scratch_load_i32(1 | 0) | 0;
  $1_1 = 0;
  $2_1 = wasm2js_scratch_load_i32(0 | 0) | 0;
  HEAP8[$1_1 >> 0] = $2_1;
  HEAP8[($1_1 + 1 | 0) >> 0] = $2_1 >>> 8 | 0;
  HEAP8[($1_1 + 2 | 0) >> 0] = $2_1 >>> 16 | 0;
  HEAP8[($1_1 + 3 | 0) >> 0] = $2_1 >>> 24 | 0;
  $3_1 = i64toi32_i32$0;
  HEAP8[($1_1 + 4 | 0) >> 0] = $3_1;
  HEAP8[($1_1 + 5 | 0) >> 0] = $3_1 >>> 8 | 0;
  HEAP8[($1_1 + 6 | 0) >> 0] = $3_1 >>> 16 | 0;
  HEAP8[($1_1 + 7 | 0) >> 0] = $3_1 >>> 24 | 0;
 }
 
 function legalstub$1() {
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $7_1 = 0, $0_1 = 0, $0$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $1() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0_1 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $7_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $7_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($7_1 | 0);
  i64toi32_i32$0 = $0$hi;
  return $0_1 | 0;
 }
 
 bufferView = HEAPU8;
 function __wasm_memory_size() {
  return buffer.byteLength / 65536 | 0;
 }
 
 return {
  "i32_load": $0, 
  "i64_load": legalstub$1, 
  "f32_load": $2, 
  "f64_load": $3, 
  "i32_store": $4, 
  "i64_store": $5, 
  "f32_store": $6, 
  "f64_store": $7
 };
}

var retasmFunc = asmFunc(  { abort: function() { throw new Error('abort'); },
    setTempRet0
  });
export var i32_load = retasmFunc.i32_load;
export var i64_load = retasmFunc.i64_load;
export var f32_load = retasmFunc.f32_load;
export var f64_load = retasmFunc.f64_load;
export var i32_store = retasmFunc.i32_store;
export var i64_store = retasmFunc.i64_store;
export var f32_store = retasmFunc.f32_store;
export var f64_store = retasmFunc.f64_store;
