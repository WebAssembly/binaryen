
function asmFunc(global, env) {
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
  block : {
   loop : while (1) switch (1 | 0) {
   case 1:
    continue loop;
   default:
    break block;
   };
  }
 }
 
 function $1() {
  block : {
   loop : while (1) switch (1 | 0) {
   case 1:
    break block;
   default:
    continue loop;
   };
  }
 }
 
 return {
  "exp1": $0, 
  "exp2": $1
 };
}

var retasmFunc = asmFunc({
    Math,
    Int8Array,
    Uint8Array,
    Int16Array,
    Uint16Array,
    Int32Array,
    Uint32Array,
    Float32Array,
    Float64Array,
    NaN,
    Infinity
  }, {
    abort: function() { throw new Error('abort'); }
  });
export var exp1 = retasmFunc.exp1;
export var exp2 = retasmFunc.exp2;
