
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
 var f = -1412567121;
 var f$hi = 305419896;
 function call($0, $0$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
 }
 
 function $1() {
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = f$hi;
  call(f | 0, i64toi32_i32$0 | 0);
  i64toi32_i32$0 = 287454020;
  f = 1432778632;
  f$hi = i64toi32_i32$0;
 }
 
 return {
  "exp": $1
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({}, {abort() { throw new Error('abort'); }},memasmFunc);
export var exp = retasmFunc.exp;
