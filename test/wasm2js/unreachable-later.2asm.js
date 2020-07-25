
function asmFunc(global, env, buffer) {
 var HEAP8 = new Int8Array(buffer);
 var HEAP16 = new Int16Array(buffer);
 var HEAP32 = new Int32Array(buffer);
 var HEAPU8 = new Uint8Array(buffer);
 var HEAPU16 = new Uint16Array(buffer);
 var HEAPU32 = new Uint32Array(buffer);
 var HEAPF32 = new Float32Array(buffer);
 var HEAPF64 = new Float64Array(buffer);
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

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({}, {abort() { throw new Error('abort'); }},memasmFunc);
export var func_50 = retasmFunc.func_50;
