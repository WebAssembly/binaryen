
function asmFunc(imports) {
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
 function even(n) {
  n = n | 0;
  var $6 = 0;
  if ((n | 0) == (0 | 0)) {
   $6 = 1
  } else {
   $6 = odd(n - 1 | 0 | 0) | 0
  }
  return $6 | 0;
 }
 
 function odd(n) {
  n = n | 0;
  var $6 = 0;
  if ((n | 0) == (0 | 0)) {
   $6 = 0
  } else {
   $6 = even(n - 1 | 0 | 0) | 0
  }
  return $6 | 0;
 }
 
 return {
  "even": even, 
  "odd": odd
 };
}

var retasmFunc = asmFunc({
});
export var even = retasmFunc.even;
export var odd = retasmFunc.odd;
