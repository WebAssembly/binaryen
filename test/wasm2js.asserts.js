
    var nan = NaN;
    var infinity = Infinity;
  
    function f32Equal(a, b) {
       var i = new Int32Array(1);
       var f = new Float32Array(i.buffer);
       f[0] = a;
       var ai = f[0];
       f[0] = b;
       var bi = f[0];

       return (isNaN(a) && isNaN(b)) || a == b;
    }

    function f64Equal(a, b) {
       var i = new Int32Array(2);
       var f = new Float64Array(i.buffer);
       f[0] = a;
       var ai1 = i[0];
       var ai2 = i[1];
       f[0] = b;
       var bi1 = i[0];
       var bi2 = i[1];

       return (isNaN(a) && isNaN(b)) || (ai1 == bi1 && ai2 == bi2);
    }

    function i64Equal(actual_lo, actual_hi, expected_lo, expected_hi) {
       return (actual_lo | 0) == (expected_lo | 0) && (actual_hi | 0) == (expected_hi | 0);
    }
  
function asmFunc0(global, env, buffer) {
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
 function $0() {
  
 }
 
 function $1(x, y) {
  x = x | 0;
  y = y | 0;
  return x + y | 0 | 0;
 }
 
 function $2(x, y) {
  x = x | 0;
  y = y | 0;
  return (x | 0) / (y | 0) | 0 | 0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "empty": $0, 
  "add": $1, 
  "div_s": $2
 };
}

var memasmFunc0 = new ArrayBuffer(65536);
var retasmFunc0 = asmFunc0({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc0);
function check1() {
 retasmFunc0.empty();
 return 1 | 0;
}

if (!check1()) throw 'assertion failed: ( assert_return ( call empty ) )';
function check2() {
 return (retasmFunc0.add(1 | 0, 1 | 0) | 0 | 0) == (2 | 0) | 0;
}

if (!check2()) throw 'assertion failed: ( assert_return ( call add ( i32.const 1 ) ( i32.const 1 ) ) ( i32.const 2 ) )';
