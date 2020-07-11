
function asmFunc(global, env, buffer) {
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
 var Math_sqrt = Math.sqrt;
 var abort = env.abort;
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
var retasmFunc = asmFunc({}, {abort() { throw new Error('abort'); }},memasmFunc);
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
