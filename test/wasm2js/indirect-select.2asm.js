import { table } from 'env';

function asmFunc(env) {
 var FUNCTION_TABLE = env.table;
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
  return FUNCTION_TABLE[(x ? 1 : 0) | 0]() | 0 | 0;
 }
 
 function $1(x) {
  x = x | 0;
  return FUNCTION_TABLE[(x ? 0 : 1) | 0]() | 0 | 0;
 }
 
 return {
  "foo_true": $0, 
  "foo_false": $1
 };
}

var retasmFunc = asmFunc(  { abort: function() { throw new Error('abort'); },
    table
  });
export var foo_true = retasmFunc.foo_true;
export var foo_false = retasmFunc.foo_false;
