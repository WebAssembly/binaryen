
function asmFunc(env) {
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
 var nan = NaN;
 var infinity = Infinity;
 function $0(x) {
  x = x | 0;
  return x << 24 >> 24 | 0;
 }
 
 function $1(x) {
  x = x | 0;
  return x << 16 >> 16 | 0;
 }
 
 return {
  "test8": $0, 
  "test16": $1
 };
}

var retasmFunc = asmFunc(  { abort: function() { throw new Error('abort'); }
  });
export var test8 = retasmFunc.test8;
export var test16 = retasmFunc.test16;
