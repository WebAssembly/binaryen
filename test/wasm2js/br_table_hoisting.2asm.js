
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
 
 return {
  "foo1": $1, 
  "foo2": $2, 
  "foo3": $3, 
  "foo4": $4
 };
}

var retasmFunc = asmFunc({
});
export var foo1 = retasmFunc.foo1;
export var foo2 = retasmFunc.foo2;
export var foo3 = retasmFunc.foo3;
export var foo4 = retasmFunc.foo4;
