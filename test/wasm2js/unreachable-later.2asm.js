
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
 var global$0 = 10;
 function $0($0_1) {
  $0_1 = $0_1 | 0;
  var $15 = Math_fround(0), $21 = 0, $29 = 0, $26 = 0;
  if (global$0) {
   return $0_1 | 0
  }
  if (global$0) {
   return $0_1 | 0
  }
  global$0 = 0;
  label$3 : while (1) {
   label$4 : {
    if (global$0) {
     return $0_1 | 0
    }
    if (global$0) {
     return $0_1 | 0
    }
    if (global$0) {
     return $0_1 | 0
    }
    $15 = Math_fround(0.0);
    if (global$0) {
     return $0_1 | 0
    }
   }
   $21 = 32;
   if (!$21) {
    continue label$3
   }
   $26 = 1;
   break label$3;
  };
  if (!$26) {
   $29 = 0
  } else {
   $29 = 1
  }
  if (!$29) {
   return -255 | 0
  } else {
   abort()
  }
 }
 
 return {
  "func_50": $0
 };
}

var retasmFunc = asmFunc(  { abort: function() { throw new Error('abort'); }
  });
export var func_50 = retasmFunc.func_50;
