
function asmFunc(global, env, buffer) {
 "almost asm";
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
  return 1 | 0;
 }
 
 function $1() {
  var $0_1 = 0;
  cont : while (1) {
   $0_1 = $0_1 + 1 | 0;
   if (($0_1 | 0) != (5 | 0)) {
    continue
   }
   break;
  };
  return $0_1 | 0;
 }
 
 function $2() {
  var $0_1 = 0;
  cont : while (1) {
   $0_1 = $0_1 + 1 | 0;
   if (($0_1 | 0) == (5 | 0)) {
    continue
   }
   if (!(($0_1 | 0) == (8 | 0))) {
    {
     $0_1 = $0_1 + 1 | 0;
     continue;
    }
   }
   break;
  };
  return $0_1 | 0;
 }
 
 function $3() {
  var $0_1 = 0;
  exit : {
   $0_1 = 1;
   if (($0_1 | 0) == (5 | 0)) {
    break exit
   }
  }
  return $0_1 | 0;
 }
 
 function $4($0_1) {
  $0_1 = $0_1 | 0;
  var $1_1 = 0;
  $1_1 = 1;
  cont : while (1) {
   $1_1 = $1_1 + $1_1 | 0;
   if ($1_1 >>> 0 <= $0_1 >>> 0) {
    continue
   }
   break;
  };
  return $1_1 | 0;
 }
 
 function $5() {
  return 2 | 0;
 }
 
 function $6() {
  return 5 | 0;
 }
 
 function $8($0_1) {
  $0_1 = $0_1 | 0;
  var $1_1 = 0, $2_2 = 0;
  ret : {
   exit : {
    $0_2 : {
     $3_1 : {
      $2_1 : {
       switch ($0_1 - 1 | 0) {
       case 0:
       case 1:
        break $2_1;
       case 2:
        break $3_1;
       default:
        break $0_2;
       };
      }
      $1_1 = 2;
      break exit;
     }
     $2_2 = 3;
     break ret;
    }
    $1_1 = 5;
   }
   $2_2 = Math_imul($1_1, 10);
  }
  return $2_2 | 0;
 }
 
 function $9($0_1) {
  $0_1 = $0_1 | 0;
  if (!$0_1) {
   return 0 | 0
  }
  return 2 | 0;
 }
 
 function $10() {
  return 29 | 0;
 }
 
 function $13() {
  var $0_1 = 0;
  l0 : {
   $0_1 = 2;
   if ($0_1) {
    break l0
   }
  }
  return $0_1 | 0;
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
  "if2": $6, 
  "switch_": $8, 
  "return_": $9, 
  "br_if0": $10, 
  "br_if1": $0, 
  "br_if2": $0, 
  "br_if3": $13, 
  "br": $0, 
  "shadowing": $0, 
  "redefinition": $6
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
