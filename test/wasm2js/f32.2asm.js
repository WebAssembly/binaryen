

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
 function $0(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return Math_fround(Math_fround(x + y));
 }
 
 function $1(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return Math_fround(Math_fround(x - y));
 }
 
 function $2(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return Math_fround(Math_fround(x * y));
 }
 
 function $3(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return Math_fround(Math_fround(x / y));
 }
 
 function $4(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(Math_sqrt(x)));
 }
 
 function $5(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return Math_fround(Math_fround(Math_min(x, y)));
 }
 
 function $6(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return Math_fround(Math_fround(Math_max(x, y)));
 }
 
 function $7(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(Math_ceil(x)));
 }
 
 function $8(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(Math_floor(x)));
 }
 
 function $9(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(__wasm_trunc_f32(Math_fround(x))));
 }
 
 function $10(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(__wasm_nearest_f32(Math_fround(x))));
 }
 
 function $11(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(Math_abs(x)));
 }
 
 function $12(x) {
  x = Math_fround(x);
  return Math_fround(Math_fround(-x));
 }
 
 function $13(x, y) {
  x = Math_fround(x);
  y = Math_fround(y);
  return Math_fround((wasm2js_scratch_store_i32(0, (wasm2js_scratch_store_f32(x), wasm2js_scratch_load_i32(0)) & 2147483647 | 0 | ((wasm2js_scratch_store_f32(y), wasm2js_scratch_load_i32(0)) & 2147483648 | 0) | 0), wasm2js_scratch_load_f32()));
 }
 
 function legalstub$0($0_1, $1_1) {
  $0_1 = +$0_1;
  $1_1 = +$1_1;
  return +(+Math_fround($0(Math_fround(Math_fround($0_1)), Math_fround(Math_fround($1_1)))));
 }
 
 function legalstub$1($0_1, $1_1) {
  $0_1 = +$0_1;
  $1_1 = +$1_1;
  return +(+Math_fround($1(Math_fround(Math_fround($0_1)), Math_fround(Math_fround($1_1)))));
 }
 
 function legalstub$2($0_1, $1_1) {
  $0_1 = +$0_1;
  $1_1 = +$1_1;
  return +(+Math_fround($2(Math_fround(Math_fround($0_1)), Math_fround(Math_fround($1_1)))));
 }
 
 function legalstub$3($0_1, $1_1) {
  $0_1 = +$0_1;
  $1_1 = +$1_1;
  return +(+Math_fround($3(Math_fround(Math_fround($0_1)), Math_fround(Math_fround($1_1)))));
 }
 
 function legalstub$4($0_1) {
  $0_1 = +$0_1;
  return +(+Math_fround($4(Math_fround(Math_fround($0_1)))));
 }
 
 function legalstub$5($0_1, $1_1) {
  $0_1 = +$0_1;
  $1_1 = +$1_1;
  return +(+Math_fround($5(Math_fround(Math_fround($0_1)), Math_fround(Math_fround($1_1)))));
 }
 
 function legalstub$6($0_1, $1_1) {
  $0_1 = +$0_1;
  $1_1 = +$1_1;
  return +(+Math_fround($6(Math_fround(Math_fround($0_1)), Math_fround(Math_fround($1_1)))));
 }
 
 function legalstub$7($0_1) {
  $0_1 = +$0_1;
  return +(+Math_fround($7(Math_fround(Math_fround($0_1)))));
 }
 
 function legalstub$8($0_1) {
  $0_1 = +$0_1;
  return +(+Math_fround($8(Math_fround(Math_fround($0_1)))));
 }
 
 function legalstub$9($0_1) {
  $0_1 = +$0_1;
  return +(+Math_fround($9(Math_fround(Math_fround($0_1)))));
 }
 
 function legalstub$10($0_1) {
  $0_1 = +$0_1;
  return +(+Math_fround($10(Math_fround(Math_fround($0_1)))));
 }
 
 function legalstub$11($0_1) {
  $0_1 = +$0_1;
  return +(+Math_fround($11(Math_fround(Math_fround($0_1)))));
 }
 
 function legalstub$12($0_1) {
  $0_1 = +$0_1;
  return +(+Math_fround($12(Math_fround(Math_fround($0_1)))));
 }
 
 function legalstub$13($0_1, $1_1) {
  $0_1 = +$0_1;
  $1_1 = +$1_1;
  return +(+Math_fround($13(Math_fround(Math_fround($0_1)), Math_fround(Math_fround($1_1)))));
 }
 
 function __wasm_nearest_f32(var$0) {
  var$0 = Math_fround(var$0);
  var var$1 = Math_fround(0), var$2 = Math_fround(0), wasm2js_f32$0 = Math_fround(0), wasm2js_f32$1 = Math_fround(0), wasm2js_i32$0 = 0;
  var$1 = Math_fround(Math_floor(var$0));
  var$2 = Math_fround(var$0 - var$1);
  if ((var$2 < Math_fround(.5) | 0) == (0 | 0)) {
   block : {
    var$0 = Math_fround(Math_ceil(var$0));
    if (var$2 > Math_fround(.5)) {
     return Math_fround(var$0)
    }
    var$2 = Math_fround(var$1 * Math_fround(.5));
    var$1 = (wasm2js_f32$0 = var$1, wasm2js_f32$1 = var$0, wasm2js_i32$0 = Math_fround(var$2 - Math_fround(Math_floor(var$2))) == Math_fround(0.0), wasm2js_i32$0 ? wasm2js_f32$0 : wasm2js_f32$1);
   }
  }
  return Math_fround(var$1);
 }
 
 function __wasm_trunc_f32(var$0) {
  var$0 = Math_fround(var$0);
  var wasm2js_f32$0 = Math_fround(0), wasm2js_f32$1 = Math_fround(0), wasm2js_i32$0 = 0;
  return Math_fround((wasm2js_f32$0 = Math_fround(Math_ceil(var$0)), wasm2js_f32$1 = Math_fround(Math_floor(var$0)), wasm2js_i32$0 = var$0 < Math_fround(0.0), wasm2js_i32$0 ? wasm2js_f32$0 : wasm2js_f32$1));
 }
 
 var FUNCTION_TABLE = [];
 return {
  add: legalstub$0, 
  sub: legalstub$1, 
  mul: legalstub$2, 
  div: legalstub$3, 
  sqrt: legalstub$4, 
  min: legalstub$5, 
  max: legalstub$6, 
  ceil: legalstub$7, 
  floor: legalstub$8, 
  trunc: legalstub$9, 
  nearest: legalstub$10, 
  abs: legalstub$11, 
  neg: legalstub$12, 
  copysign: legalstub$13
 };
}

const memasmFunc = new ArrayBuffer(65536);
const retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },wasm2js_scratch_store_i32,wasm2js_scratch_load_f32,wasm2js_scratch_store_f32,wasm2js_scratch_load_i32},memasmFunc);
export const add = retasmFunc.add;
export const sub = retasmFunc.sub;
export const mul = retasmFunc.mul;
export const div = retasmFunc.div;
export const sqrt = retasmFunc.sqrt;
export const min = retasmFunc.min;
export const max = retasmFunc.max;
export const ceil = retasmFunc.ceil;
export const floor = retasmFunc.floor;
export const trunc = retasmFunc.trunc;
export const nearest = retasmFunc.nearest;
export const abs = retasmFunc.abs;
export const neg = retasmFunc.neg;
export const copysign = retasmFunc.copysign;
