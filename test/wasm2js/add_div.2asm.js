
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
 function foo($0) {
  $0 = $0 | 0;
  return (($0 >>> 0) / (100 >>> 0) | 0) + (($0 | 0) / (-100 | 0) | 0) | 0 | 0;
 }
 
 return {
  "foo": foo
 };
}

var retasmFunc = asmFunc(  { abort: function() { throw new Error('abort'); }
  });
export var foo = retasmFunc.foo;
