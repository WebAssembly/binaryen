
function asmFunc(env) {
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
 function even(n) {
  n = n | 0;
  var $10 = 0;
  if ((n | 0) == (0 | 0)) {
   $10 = 1
  } else {
   $10 = odd(n - 1 | 0 | 0) | 0
  }
  return $10 | 0;
 }
 
 function odd(n) {
  n = n | 0;
  var $10 = 0;
  if ((n | 0) == (0 | 0)) {
   $10 = 0
  } else {
   $10 = even(n - 1 | 0 | 0) | 0
  }
  return $10 | 0;
 }
 
 return {
  "even": even, 
  "odd": odd
 };
}

var retasmFunc = asmFunc(  { abort: function() { throw new Error('abort'); }
  });
export var even = retasmFunc.even;
export var odd = retasmFunc.odd;
