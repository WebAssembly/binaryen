
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
 function $0() {
  var $0_1 = 0;
  exit : {
   $0_1 = 1;
   break exit;
  }
  return $0_1 | 0;
 }
 
 function $1() {
  var i = 0, $6_1 = 0;
  i = 0;
  exit : {
   cont : while (1) {
    i = i + 1 | 0;
    if ((i | 0) == (5 | 0)) {
     $6_1 = i;
     break exit;
    }
    continue cont;
   };
  }
  return $6_1 | 0;
 }
 
 function $2() {
  var i = 0, $8_1 = 0;
  i = 0;
  exit : {
   cont : while (1) {
    i = i + 1 | 0;
    if ((i | 0) == (5 | 0)) {
     continue cont
    }
    if ((i | 0) == (8 | 0)) {
     $8_1 = i;
     break exit;
    }
    i = i + 1 | 0;
    continue cont;
   };
  }
  return $8_1 | 0;
 }
 
 function $3() {
  var i = 0, $6_1 = 0;
  i = 0;
  exit : {
   cont : while (1) {
    i = i + 1 | 0;
    if ((i | 0) == (5 | 0)) {
     $6_1 = i;
     break exit;
    }
    break cont;
   };
   $6_1 = i;
  }
  return $6_1 | 0;
 }
 
 function $4(max) {
  max = max | 0;
  var i = 0, $9_1 = 0;
  i = 1;
  exit : {
   cont : while (1) {
    i = i + i | 0;
    if (i >>> 0 > max >>> 0) {
     $9_1 = i;
     break exit;
    }
    continue cont;
   };
  }
  return $9_1 | 0;
 }
 
 function $5() {
  var $0_1 = 0;
  l : while (1) {
   $0_1 = 1;
   break l;
  };
  return $0_1 + 1 | 0 | 0;
 }
 
 function $6() {
  var i = 0;
  i = 0;
  block_1 : {
   l : {
    break l;
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
   l4 : {
    break l4;
   }
   i = i + 1 | 0;
  }
  return i | 0;
 }
 
 function $7() {
  var i = 0;
  i = 0;
  block_1 : {
   if_1 : {
    break if_1;
   }
   i = i + 1 | 0;
   if5 : {
    break if5;
   }
   i = i + 1 | 0;
   if6 : {
    break if6;
   }
   i = i + 1 | 0;
   if7 : {
    break if7;
   }
   i = i + 1 | 0;
   if8 : {
    break if8;
   }
   i = i + 1 | 0;
  }
  return i | 0;
 }
 
 function $8($0_1) {
  $0_1 = $0_1 | 0;
  var $2_1 = 0, $3_1 = 0;
  ret : {
   exit : {
    $0_2 : {
     switch ($0_1 | 0) {
     case 1:
     case 2:
      $2_1 = 2;
      break exit;
     case 3:
      $3_1 = 3;
      break ret;
     default:
     case 0:
      break $0_2;
     };
    }
    $2_1 = 5;
   }
   $3_1 = Math_imul(10, $2_1);
  }
  return $3_1 | 0;
 }
 
 function $9($0_1) {
  $0_1 = $0_1 | 0;
  $1_1 : {
   switch ($0_1 | 0) {
   case 0:
    return 0 | 0;
   default:
    break $1_1;
   };
  }
  return 2 | 0;
 }
 
 function $10() {
  var i = 0, $10_1 = 0;
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
   $10_1 = i;
   if (0) {
    break outer
   }
   i = i | 8 | 0;
   i = i | 16 | 0;
   $10_1 = i;
   if (1) {
    break outer
   }
   i = i | 32 | 0;
   $10_1 = i;
  }
  return $10_1 | 0;
 }
 
 function $11() {
  var $2_1 = 0, $0_1 = 0;
  l0 : {
   l1 : {
    $0_1 = 1;
    break l1;
   }
   $2_1 = $0_1;
   if (1) {
    break l0
   }
   $2_1 = 1;
  }
  return $2_1 | 0;
 }
 
 function $12() {
  var $2_1 = 0, $0_1 = 0;
  l0 : {
   l1 : {
    $0_1 = 1;
    break l1;
   }
   $2_1 = $0_1;
   break l0;
  }
  return $2_1 | 0;
 }
 
 function $13() {
  var i1 = 0, $7_1 = 0, $3_1 = 0;
  l0 : {
   i1 = 1;
   $3_1 = i1;
   i1 = 2;
   $7_1 = $3_1;
   if (i1) {
    break l0
   }
   $7_1 = 0;
  }
  return i1 | 0;
 }
 
 function $14() {
  var $2_1 = 0, $0_1 = 0, $3_1 = 0;
  l0 : {
   l1 : {
    $0_1 = 1;
    break l1;
   }
   $2_1 = $0_1;
   break l0;
  }
  return $2_1 | 0;
 }
 
 function $15() {
  var $0_1 = 0;
  l1 : {
   $0_1 = 1;
   break l1;
  }
  return $0_1 | 0;
 }
 
 function $16() {
  var $1_2 = 0, $2_1 = 0;
  l1 : {
   $1_2 = 2;
   l113 : {
    $2_1 = 3;
    break l113;
   }
  }
  return $1_2 + $2_1 | 0 | 0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "block": $0, 
  "loop1": $1, 
  "loop2": $2, 
  "loop3": $3, 
  "loop4": $4, 
  "loop5": $5, 
  "if_": $6, 
  "if2": $7, 
  "switch_": $8, 
  "return_": $9, 
  "br_if0": $10, 
  "br_if1": $11, 
  "br_if2": $12, 
  "br_if3": $13, 
  "br": $14, 
  "shadowing": $15, 
  "redefinition": $16
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export var block = retasmFunc.block;
export var loop1 = retasmFunc.loop1;
export var loop2 = retasmFunc.loop2;
export var loop3 = retasmFunc.loop3;
export var loop4 = retasmFunc.loop4;
export var loop5 = retasmFunc.loop5;
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
