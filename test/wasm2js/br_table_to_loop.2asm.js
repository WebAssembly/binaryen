
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
});
export var exp1 = retasmFunc.exp1;
export var exp2 = retasmFunc.exp2;
