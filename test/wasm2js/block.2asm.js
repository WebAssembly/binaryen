
function asmFunc(global, env, buffer) {
 "almost asm";
 var HEAP8 = new global.Int8Array(buffer);
 var HEAP16 = new global.Int16Array(buffer);
 var HEAP32 = new global.Int32Array(buffer);
 var HEAPU8 = new global.Uint8Array(buffer);
 var HEAPU16 = new global.Uint16Array(buffer);
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
 function dummy() {
  
 }
 
 function $1() {
  
 }
 
 function $2() {
  return 7 | 0;
 }
 
 function $3() {
  block : {
   dummy();
   dummy();
   dummy();
   dummy();
  }
  block1 : {
   dummy();
   dummy();
   dummy();
  }
  return 8 | 0;
 }
 
 function $4() {
  block : {
   dummy();
   dummy();
  }
  return 9 | 0;
 }
 
 function $5() {
  dummy();
  return 150 | 0;
 }
 
 function $6() {
  dummy();
  return __wasm_ctz_i32(13 | 0) | 0 | 0;
 }
 
 function $7() {
  dummy();
  dummy();
  return Math_imul(3, 4) | 0;
 }
 
 function $8() {
  dummy();
  return !13 | 0;
 }
 
 function $9() {
  dummy();
  dummy();
  return Math_fround(3.0) > Math_fround(3.0) | 0;
 }
 
 function $10() {
  block : {
   break block;
  }
  block44 : {
   if (1) {
    break block44
   }
   abort();
  }
  block45 : {
   switch (0 | 0) {
   default:
    break block45;
   };
  }
  block46 : {
   switch (1 | 0) {
   default:
    break block46;
   };
  }
  return 19 | 0;
 }
 
 function $11() {
  var $0 = 0;
  block : {
   $0 = 18;
   break block;
  }
  return $0 | 0;
 }
 
 function $12() {
  var $0 = 0;
  block : {
   $0 = 18;
   break block;
  }
  return $0 | 0;
 }
 
 function $13() {
  var $0 = 0, $1_1 = 0, $2_1 = 0, $5_1 = 0, $9_1 = 0, $10_1 = 0, $13_1 = 0, $14_1 = 0;
  $0 = 0;
  $1_1 = $0;
  block : {
   block47 : {
    $2_1 = 1;
    break block;
   }
  }
  $0 = $1_1 + $2_1 | 0;
  $5_1 = $0;
  $0 = $5_1 + 2 | 0;
  $9_1 = $0;
  block50 : {
   $10_1 = 4;
   break block50;
  }
  $0 = $9_1 + $10_1 | 0;
  $13_1 = $0;
  block51 : {
   block52 : {
    $14_1 = 8;
    break block51;
   }
  }
  $0 = $13_1 + $14_1 | 0;
  return $0 | 0;
 }
 
 function $14() {
  var $0 = 0;
  block : {
   $0 = 1;
   $0 = Math_imul($0, 3);
   $0 = $0 - 5 | 0;
   $0 = Math_imul($0, 7);
   break block;
  }
  return ($0 | 0) == (-14 | 0) | 0;
 }
 
 function __wasm_ctz_i32(var$0) {
  var$0 = var$0 | 0;
  if (var$0) {
   return 31 - Math_clz32((var$0 + -1 | 0) ^ var$0 | 0) | 0 | 0
  }
  return 32 | 0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "empty": $1, 
  "singular": $2, 
  "multi": $3, 
  "nested": $4, 
  "deep": $5, 
  "as_unary_operand": $6, 
  "as_binary_operand": $7, 
  "as_test_operand": $8, 
  "as_compare_operand": $9, 
  "break_bare": $10, 
  "break_value": $11, 
  "break_repeated": $12, 
  "break_inner": $13, 
  "effects": $14
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export var empty = retasmFunc.empty;
export var singular = retasmFunc.singular;
export var multi = retasmFunc.multi;
export var nested = retasmFunc.nested;
export var deep = retasmFunc.deep;
export var as_unary_operand = retasmFunc.as_unary_operand;
export var as_binary_operand = retasmFunc.as_binary_operand;
export var as_test_operand = retasmFunc.as_test_operand;
export var as_compare_operand = retasmFunc.as_compare_operand;
export var break_bare = retasmFunc.break_bare;
export var break_value = retasmFunc.break_value;
export var break_repeated = retasmFunc.break_repeated;
export var break_inner = retasmFunc.break_inner;
export var effects = retasmFunc.effects;
