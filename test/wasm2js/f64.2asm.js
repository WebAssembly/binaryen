
function asmFunc(global, env, buffer) {
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
  x = +x;
  y = +y;
  return +(x + y);
 }
 
 function $1(x, y) {
  x = +x;
  y = +y;
  return +(x - y);
 }
 
 function $2(x, y) {
  x = +x;
  y = +y;
  return +(x * y);
 }
 
 function $3(x, y) {
  x = +x;
  y = +y;
  return +(x / y);
 }
 
 function $4(x) {
  x = +x;
  return +Math_sqrt(x);
 }
 
 function $5(x, y) {
  x = +x;
  y = +y;
  return +Math_min(x, y);
 }
 
 function $6(x, y) {
  x = +x;
  y = +y;
  return +Math_max(x, y);
 }
 
 function $7(x) {
  x = +x;
  return +Math_ceil(x);
 }
 
 function $8(x) {
  x = +x;
  return +Math_floor(x);
 }
 
 function $9(x) {
  x = +x;
  return +(+__wasm_trunc_f64(+x));
 }
 
 function $10(x) {
  x = +x;
  return +(+__wasm_nearest_f64(+x));
 }
 
 function __wasm_nearest_f64(var$0) {
  var$0 = +var$0;
  var var$1 = 0.0, var$2 = 0.0;
  var$1 = Math_floor(var$0);
  var$2 = var$0 - var$1;
  if (!(var$2 < .5)) {
   block : {
    var$0 = Math_ceil(var$0);
    if (var$2 > .5) {
     return +var$0
    }
    var$2 = var$1 * .5;
    var$1 = var$2 - Math_floor(var$2) == 0.0 ? var$1 : var$0;
   }
  }
  return +var$1;
 }
 
 function __wasm_trunc_f64(var$0) {
  var$0 = +var$0;
  return +(var$0 < 0.0 ? Math_ceil(var$0) : Math_floor(var$0));
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
  "nearest": $10
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
