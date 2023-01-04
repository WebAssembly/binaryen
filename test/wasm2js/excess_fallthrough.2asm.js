
function wasm2js_trap() { throw new Error('abort'); }

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
 function bar() {
  
 }
 
 function foo($0) {
  $0 = $0 | 0;
  label$4 : while (1) {
   label$5 : {
    bar();
    label$7 : {
     switch (123 | 0) {
     case 0:
      break label$7;
     default:
      break label$5;
     };
    }
    bar();
    return;
   }
   wasm2js_trap();
  };
 }
 
 return {
  "foo": foo
 };
}

var retasmFunc = asmFunc({
});
export var foo = retasmFunc.foo;
