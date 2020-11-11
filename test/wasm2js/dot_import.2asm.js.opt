import { ba_se } from 'mod.ule';

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
 var base = env.ba_se;
 function $0() {
  base();
 }
 
 return {
  "exported": $0
 };
}

var retasmFunc = asmFunc({ abort() { throw new Error('abort'); },
    ba_se });
export var exported = retasmFunc.exported;
