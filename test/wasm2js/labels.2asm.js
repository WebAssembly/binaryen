
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
 function f0() {
  var $0 = 0;
  exit : {
   $0 = 1;
   break exit;
  }
  return $0 | 0;
 }
 
 function f1() {
  var i = 0, $6 = 0;
  i = 0;
  exit : {
   cont : while (1) {
    i = i + 1 | 0;
    if ((i | 0) == (5 | 0)) {
     $6 = i;
     break exit;
    }
    continue cont;
   };
  }
  return $6 | 0;
 }
 
 function f2() {
  var i = 0, $8 = 0;
  i = 0;
  exit : {
   cont : while (1) {
    i = i + 1 | 0;
    if ((i | 0) == (5 | 0)) {
     continue cont
    }
    if ((i | 0) == (8 | 0)) {
     $8 = i;
     break exit;
    }
    i = i + 1 | 0;
    continue cont;
   };
  }
  return $8 | 0;
 }
 
 function f3() {
  var i = 0, $6 = 0;
  i = 0;
  exit : {
   cont : while (1) {
    i = i + 1 | 0;
    if ((i | 0) == (5 | 0)) {
     $6 = i;
     break exit;
    }
    break cont;
   };
   $6 = i;
  }
  return $6 | 0;
 }
 
 function f4(max) {
  max = max | 0;
  var i = 0, $9 = 0;
  i = 1;
  exit : {
   cont : while (1) {
    i = i + i | 0;
    if (i >>> 0 > max >>> 0) {
     $9 = i;
     break exit;
    }
    continue cont;
   };
  }
  return $9 | 0;
 }
 
 function f5() {
  var $0 = 0;
  l : while (1) {
   $0 = 1;
   break l;
  };
  return $0 + 1 | 0 | 0;
 }
 
 function f6() {
  var $2 = 0;
  label : while (1) {
   if (0) {
    continue label
   }
   $2 = 3;
   break label;
  };
  return $2 | 0;
 }
 
 function f7() {
  var i = 0;
  i = 0;
  l : {
   break l;
  }
  i = i + 1 | 0;
  l0 : {
   break l0;
  }
  i = i + 1 | 0;
  l1 : {
   break l1;
  }
  i = i + 1 | 0;
  l2 : {
   break l2;
  }
  i = i + 1 | 0;
  l3 : {
   break l3;
  }
  i = i + 1 | 0;
  return i | 0;
 }
 
 function f8() {
  var i = 0;
  i = 0;
  label : {
   break label;
  }
  i = i + 1 | 0;
  label0 : {
   break label0;
  }
  i = i + 1 | 0;
  label1 : {
   break label1;
  }
  i = i + 1 | 0;
  label2 : {
   break label2;
  }
  i = i + 1 | 0;
  label3 : {
   break label3;
  }
  i = i + 1 | 0;
  return i | 0;
 }
 
 function f9($0) {
  $0 = $0 | 0;
  var $2 = 0, $3 = 0;
  ret : {
   exit : {
    $0 : {
     switch ($0 | 0) {
     case 1:
     case 2:
      $2 = 2;
      break exit;
     case 3:
      $3 = 3;
      break ret;
     default:
     case 0:
      break $0;
     };
    }
    $2 = 5;
   }
   $3 = Math_imul(10, $2);
  }
  return $3 | 0;
 }
 
 function f10($0) {
  $0 = $0 | 0;
  $1 : {
   switch ($0 | 0) {
   case 0:
    return 0 | 0;
   default:
    break $1;
   };
  }
  return 2 | 0;
 }
 
 function f11() {
  var i = 0, $10 = 0;
  i = 0;
  outer : {
   inner : {
    if (0) {
     break inner
    }
    i = i | 1 | 0;
    if (1) {
     break inner
    }
    i = i | 2 | 0;
   }
   i = i | 4 | 0;
   $10 = i;
   if (0) {
    break outer
   }
   i = i | 8 | 0;
   i = i | 16 | 0;
   $10 = i;
   if (1) {
    break outer
   }
   i = i | 32 | 0;
   $10 = i;
  }
  return $10 | 0;
 }
 
 function f12() {
  var $2 = 0, $0 = 0;
  l0 : {
   l1 : {
    $0 = 1;
    break l1;
   }
   $2 = $0;
   if (1) {
    break l0
   }
   $2 = 0;
  }
  return $2 | 0;
 }
 
 function f13() {
  var $2 = 0, $0 = 0;
  l0 : {
   l1 : {
    $0 = 1;
    break l1;
   }
   $2 = $0;
   if (1) {
    break l0
   }
   $2 = 0;
  }
  return $2 | 0;
 }
 
 function f14() {
  var i1 = 0, $7 = 0, $3 = 0;
  l0 : {
   i1 = 1;
   $3 = i1;
   i1 = 2;
   $7 = $3;
   if (i1) {
    break l0
   }
   $7 = 0;
  }
  return i1 | 0;
 }
 
 function f15() {
  var $2 = 0, $0 = 0, $3 = 0;
  l0 : {
   l1 : {
    $0 = 1;
    break l1;
   }
   $2 = $0;
   break l0;
  }
  return $2 | 0;
 }
 
 function f16() {
  var $0 = 0;
  l1 : {
   $0 = 1;
   break l1;
  }
  return $0 | 0;
 }
 
 function f17() {
  var $1 = 0, $2 = 0;
  l1 : {
   $1 = 2;
   l11 : {
    $2 = 3;
    break l11;
   }
  }
  return $1 + $2 | 0 | 0;
 }
 
 return {
  "block": f0, 
  "loop1": f1, 
  "loop2": f2, 
  "loop3": f3, 
  "loop4": f4, 
  "loop5": f5, 
  "loop6": f6, 
  "if_": f7, 
  "if2": f8, 
  "switch_": f9, 
  "return_": f10, 
  "br_if0": f11, 
  "br_if1": f12, 
  "br_if2": f13, 
  "br_if3": f14, 
  "br": f15, 
  "shadowing": f16, 
  "redefinition": f17
 };
}

var retasmFunc = asmFunc({
});
export var block = retasmFunc.block;
export var loop1 = retasmFunc.loop1;
export var loop2 = retasmFunc.loop2;
export var loop3 = retasmFunc.loop3;
export var loop4 = retasmFunc.loop4;
export var loop5 = retasmFunc.loop5;
export var loop6 = retasmFunc.loop6;
export var if_ = retasmFunc.if_;
export var if2 = retasmFunc.if2;
export var switch_ = retasmFunc.switch_;
export var return_ = retasmFunc.return_;
export var br_if0 = retasmFunc.br_if0;
export var br_if1 = retasmFunc.br_if1;
export var br_if2 = retasmFunc.br_if2;
export var br_if3 = retasmFunc.br_if3;
export var br = retasmFunc.br;
export var shadowing = retasmFunc.shadowing;
export var redefinition = retasmFunc.redefinition;
