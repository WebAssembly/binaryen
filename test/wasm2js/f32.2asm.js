

  var scratchBuffer = new ArrayBuffer(8);
  var i32ScratchView = new Int32Array(scratchBuffer);
  var f32ScratchView = new Float32Array(scratchBuffer);
  var f64ScratchView = new Float64Array(scratchBuffer);
  
  function wasm2js_scratch_store_i32(index, value) {
    i32ScratchView[index] = value;
  }
      
  function wasm2js_scratch_load_f32() {
    return f32ScratchView[0];
  }
      
  function wasm2js_scratch_store_f32(value) {
    f32ScratchView[0] = value;
  }
      
  function wasm2js_scratch_load_i32(index) {
    return i32ScratchView[index];
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
 function $0($0_1, $1_1) {
  $0_1 = Math_fround($0_1);
  $1_1 = Math_fround($1_1);
  return Math_fround(Math_fround($0_1 + $1_1));
 }
 
 function $1($0_1, $1_1) {
  $0_1 = Math_fround($0_1);
  $1_1 = Math_fround($1_1);
  return Math_fround(Math_fround($0_1 - $1_1));
 }
 
 function $2($0_1, $1_1) {
  $0_1 = Math_fround($0_1);
  $1_1 = Math_fround($1_1);
  return Math_fround(Math_fround($0_1 * $1_1));
 }
 
 function $3($0_1, $1_1) {
  $0_1 = Math_fround($0_1);
  $1_1 = Math_fround($1_1);
  return Math_fround(Math_fround($0_1 / $1_1));
 }
 
 function $4($0_1) {
  $0_1 = Math_fround($0_1);
  return Math_fround(Math_fround(Math_sqrt($0_1)));
 }
 
 function $5($0_1, $1_1) {
  $0_1 = Math_fround($0_1);
  $1_1 = Math_fround($1_1);
  return Math_fround(Math_fround(Math_min($0_1, $1_1)));
 }
 
 function $6($0_1, $1_1) {
  $0_1 = Math_fround($0_1);
  $1_1 = Math_fround($1_1);
  return Math_fround(Math_fround(Math_max($0_1, $1_1)));
 }
 
 function $7($0_1) {
  $0_1 = Math_fround($0_1);
  return Math_fround(Math_fround(Math_ceil($0_1)));
 }
 
 function $8($0_1) {
  $0_1 = Math_fround($0_1);
  return Math_fround(Math_fround(Math_floor($0_1)));
 }
 
 function $9($0_1) {
  $0_1 = Math_fround($0_1);
  return Math_fround(Math_fround(__wasm_trunc_f32(Math_fround($0_1))));
 }
 
 function $10($0_1) {
  $0_1 = Math_fround($0_1);
  return Math_fround(Math_fround(__wasm_nearest_f32(Math_fround($0_1))));
 }
 
 function $11($0_1) {
  $0_1 = Math_fround($0_1);
  return Math_fround(Math_fround(Math_abs($0_1)));
 }
 
 function $12($0_1) {
  $0_1 = Math_fround($0_1);
  return Math_fround(Math_fround(-$0_1));
 }
 
 function $13($0_1, $1_1) {
  $0_1 = Math_fround($0_1);
  $1_1 = Math_fround($1_1);
  return Math_fround((wasm2js_scratch_store_i32(0, (wasm2js_scratch_store_f32($0_1), wasm2js_scratch_load_i32(0)) & 2147483647 | 0 | ((wasm2js_scratch_store_f32($1_1), wasm2js_scratch_load_i32(0)) & -2147483648 | 0) | 0), wasm2js_scratch_load_f32()));
 }
 
 function __wasm_nearest_f32($0_1) {
  $0_1 = Math_fround($0_1);
  var $1_1 = Math_fround(0), $2_1 = Math_fround(0);
  $1_1 = Math_fround(Math_floor($0_1));
  $2_1 = Math_fround($0_1 - $1_1);
  if (!($2_1 < Math_fround(.5))) {
   {
    $0_1 = Math_fround(Math_ceil($0_1));
    if ($2_1 > Math_fround(.5)) {
     return Math_fround($0_1)
    }
    $2_1 = Math_fround($1_1 * Math_fround(.5));
    $1_1 = Math_fround($2_1 - Math_fround(Math_floor($2_1))) == Math_fround(0.0) ? $1_1 : $0_1;
   }
  }
  return Math_fround($1_1);
 }
 
 function __wasm_trunc_f32($0_1) {
  $0_1 = Math_fround($0_1);
  return Math_fround($0_1 < Math_fround(0.0) ? Math_fround(Math_ceil($0_1)) : Math_fround(Math_floor($0_1)));
 }
 
 var FUNCTION_TABLE = [];
 return {
  "add": $0, 
  "sub": $1, 
  "mul": $2, 
  "div": $3, 
  "sqrt": $4, 
  "min": $5, 
  "max": $6, 
  "ceil": $7, 
  "floor": $8, 
  "trunc": $9, 
  "nearest": $10, 
  "abs": $11, 
  "neg": $12, 
  "copysign": $13
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export var add = retasmFunc.add;
export var sub = retasmFunc.sub;
export var mul = retasmFunc.mul;
export var div = retasmFunc.div;
export var sqrt = retasmFunc.sqrt;
export var min = retasmFunc.min;
export var max = retasmFunc.max;
export var ceil = retasmFunc.ceil;
export var floor = retasmFunc.floor;
export var trunc = retasmFunc.trunc;
export var nearest = retasmFunc.nearest;
export var abs = retasmFunc.abs;
export var neg = retasmFunc.neg;
export var copysign = retasmFunc.copysign;
