
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
 var global0 = 655360;
 function $0() {
  return 42 | 0;
 }
 
 return {
  "HELLO": {
   get value() {
    return global0;
   }, 
   set value(_global0) {
    global0 = _global0;
   }
  }, 
  "helloWorld": $0
 };
}

var retasmFunc = asmFunc({
});
export var HELLO = retasmFunc.HELLO;
export var helloWorld = retasmFunc.helloWorld;
