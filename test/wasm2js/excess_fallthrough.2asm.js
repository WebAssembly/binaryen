
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
 function bar() {
  
 }
 
 function foo($0) {
  $0 = $0 | 0;
  label$4 : while (1) {
   label$5 : {
    bar();
    block : {
     switch (123 | 0) {
     case 0:
      bar();
      break;
     default:
      break label$5;
     };
    }
    return;
   }
   abort();
  };
 }
 
 return {
  "foo": foo
 };
}

var retasmFunc = asmFunc(  { abort: function() { throw new Error('abort'); }
  });
export var foo = retasmFunc.foo;
