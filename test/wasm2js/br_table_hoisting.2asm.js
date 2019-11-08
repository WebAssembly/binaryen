
function asmFunc(global, env, buffer) {
 var HEAP8 = new global.Int8Array(buffer);
 var HEAP16 = new global.Int16Array(buffer);
 var HEAP32 = new global.Int32Array(buffer);
 var HEAPU8 = new global.Uint8Array(buffer);
 var HEAPU16 = new global.Uint16Array(buffer);
 var HEAPU32 = new global.Uint32Array(buffer);
 var HEAPF32 = new global.Float32Array(buffer);
 var HEAPF64 = new global.Float64Array(buffer);
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
 function zed($0) {
  $0 = $0 | 0;
  zed($0 | 0);
 }
 
 function $1(x) {
  x = x | 0;
  a : {
   b : {
    switch (x | 0) {
    default:
     zed(-1 | 0);
     zed(-2 | 0);
    case 3:
     zed(-3 | 0);
     zed(-4 | 0);
    case 2:
     zed(-5 | 0);
     zed(-6 | 0);
     break a;
    case 0:
     break a;
    case 1:
     break b;
    };
   }
   zed(-7 | 0);
   zed(-8 | 0);
   break a;
  }
  zed(-9 | 0);
  zed(-10 | 0);
 }
 
 function $2(x) {
  x = x | 0;
  a : {
   b : {
    c : {
     d : {
      switch (x | 0) {
      default:
       zed(-1 | 0);
       zed(-2 | 0);
       break c;
      case 0:
       break a;
      case 1:
       break b;
      case 2:
       break c;
      case 3:
       break d;
      };
     }
     zed(-3 | 0);
     zed(-4 | 0);
     break c;
    }
    zed(-5 | 0);
    zed(-6 | 0);
    break a;
   }
   zed(-7 | 0);
   zed(-8 | 0);
   break a;
  }
  zed(-9 | 0);
  zed(-10 | 0);
 }
 
 function $3(x) {
  x = x | 0;
  a : {
   b : {
    c : {
     d : {
      switch (x | 0) {
      default:
       if (x) {
        break c
       }
       zed(-1 | 0);
       zed(-2 | 0);
       break;
      case 0:
       break a;
      case 1:
       break b;
      case 2:
       break c;
      case 3:
       break d;
      };
     }
     zed(-3 | 0);
     zed(-4 | 0);
     break c;
    }
    zed(-5 | 0);
    zed(-6 | 0);
    break a;
   }
   zed(-7 | 0);
   zed(-8 | 0);
   break a;
  }
  zed(-9 | 0);
  zed(-10 | 0);
 }
 
 function $4(x) {
  x = x | 0;
  a : {
   b : {
    c : {
     d : {
      if (x) {
       break c
      }
      e : {
       switch (x | 0) {
       case 0:
        break a;
       case 1:
        break b;
       case 2:
        break c;
       case 3:
        break d;
       default:
        break e;
       };
      }
      if (x) {
       break c
      }
      zed(-1 | 0);
      zed(-2 | 0);
     }
     zed(-3 | 0);
     zed(-4 | 0);
     break c;
    }
    zed(-5 | 0);
    zed(-6 | 0);
    break a;
   }
   zed(-7 | 0);
   zed(-8 | 0);
   break a;
  }
  zed(-9 | 0);
  zed(-10 | 0);
 }
 
 var FUNCTION_TABLE = [];
 return {
  "foo1": $1, 
  "foo2": $2, 
  "foo3": $3, 
  "foo4": $4
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export var foo1 = retasmFunc.foo1;
export var foo2 = retasmFunc.foo2;
export var foo3 = retasmFunc.foo3;
export var foo4 = retasmFunc.foo4;
