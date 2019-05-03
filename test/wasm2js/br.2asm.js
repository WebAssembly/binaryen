import { setTempRet0 } from 'env';

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
 var setTempRet0 = env.setTempRet0;
 var i64toi32_i32$HIGH_BITS = 0;
 function dummy() {
  
 }
 
 function $1() {
  
 }
 
 function $2() {
  
 }
 
 function $3() {
  
 }
 
 function $4() {
  
 }
 
 function $5() {
  var $0 = 0;
  block : {
   $0 = 1;
   break block;
  }
  return $0 | 0;
 }
 
 function $6() {
  var i64toi32_i32$0 = 0, $0 = 0, $0$hi = 0;
  block : {
   i64toi32_i32$0 = 0;
   $0 = 2;
   $0$hi = i64toi32_i32$0;
   break block;
  }
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return $0 | 0;
 }
 
 function $7() {
  var $0 = Math_fround(0);
  block : {
   $0 = Math_fround(3.0);
   break block;
  }
  return Math_fround($0);
 }
 
 function $8() {
  var $0 = 0.0;
  block : {
   $0 = 4.0;
   break block;
  }
  return +$0;
 }
 
 function $9() {
  
 }
 
 function $10() {
  block : {
   dummy();
   break block;
  }
 }
 
 function $11() {
  block : {
   dummy();
   break block;
  }
 }
 
 function $12() {
  var $0 = 0;
  block : {
   dummy();
   $0 = 2;
   break block;
  }
  return $0 | 0;
 }
 
 function $13() {
  var $0 = 0, $1_1 = 0, $3_1 = 0;
  block : {
   loop_in : while (1) {
    $0 = 3;
    break block;
   };
  }
  return $0 | 0;
 }
 
 function $14() {
  var $0 = 0, $1_1 = 0, $3_1 = 0;
  block : {
   loop_in : while (1) {
    dummy();
    $0 = 4;
    break block;
   };
  }
  return $0 | 0;
 }
 
 function $15() {
  var $0 = 0;
  block : {
   loop_in : while (1) {
    dummy();
    $0 = 5;
    break block;
   };
  }
  return $0 | 0;
 }
 
 function $16() {
  var $0 = 0;
  block : {
   $0 = 9;
   break block;
  }
  return $0 | 0;
 }
 
 function $17() {
  
 }
 
 function $18() {
  var $0 = 0;
  block : {
   $0 = 8;
   break block;
  }
  return $0 | 0;
 }
 
 function $19() {
  var $0 = 0;
  block : {
   $0 = 9;
   break block;
  }
  return $0 | 0;
 }
 
 function $20() {
  
 }
 
 function $21() {
  var $0 = 0;
  block : {
   $0 = 10;
   break block;
  }
  return $0 | 0;
 }
 
 function $22() {
  var $0 = 0;
  block : {
   $0 = 11;
   break block;
  }
  return $0 | 0;
 }
 
 function $23() {
  var i64toi32_i32$0 = 0, $0 = 0, $0$hi = 0;
  block : {
   i64toi32_i32$0 = 0;
   $0 = 7;
   $0$hi = i64toi32_i32$0;
   break block;
  }
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return $0 | 0;
 }
 
 function $24() {
  var $0 = 0, $1_1 = 0;
  if_ : {
   $0 = 2;
   break if_;
  }
  return $0 | 0;
 }
 
 function $25($0, $1_1) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  var $3_1 = 0, $5_1 = 0;
  block : {
   if ($0) {
    $3_1 = 3;
    break block;
   } else {
    $5_1 = $1_1
   }
   $3_1 = $5_1;
  }
  return $3_1 | 0;
 }
 
 function $26($0, $1_1) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  var $4_1 = 0, $5_1 = 0;
  block : {
   if ($0) {
    $5_1 = $1_1
   } else {
    $4_1 = 4;
    break block;
   }
   $4_1 = $5_1;
  }
  return $4_1 | 0;
 }
 
 function $27($0, $1_1) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4_1 = 0;
  block : {
   $2_1 = 5;
   break block;
  }
  return $2_1 | 0;
 }
 
 function $28($0, $1_1) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  var $2_1 = 0, $3_1 = 0, $4_1 = 0;
  block : {
   $2_1 = $0;
   $3_1 = 6;
   break block;
  }
  return $3_1 | 0;
 }
 
 function $29() {
  var $0 = 0;
  block : {
   $0 = 7;
   break block;
  }
  return $0 | 0;
 }
 
 function f($0, $1_1, $2_1) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  $2_1 = $2_1 | 0;
  return -1 | 0;
 }
 
 function $31() {
  var $0 = 0;
  block : {
   $0 = 12;
   break block;
  }
  return $0 | 0;
 }
 
 function $32() {
  var $0 = 0;
  block : {
   $0 = 13;
   break block;
  }
  return $0 | 0;
 }
 
 function $33() {
  var $0 = 0;
  block : {
   $0 = 14;
   break block;
  }
  return $0 | 0;
 }
 
 function $34() {
  var $0 = 0;
  block : {
   $0 = 20;
   break block;
  }
  return $0 | 0;
 }
 
 function $35() {
  var $0 = 0;
  block : {
   $0 = 21;
   break block;
  }
  return $0 | 0;
 }
 
 function $36() {
  var $0 = 0;
  block : {
   $0 = 22;
   break block;
  }
  return $0 | 0;
 }
 
 function $37() {
  var $0 = 0;
  block : {
   $0 = 23;
   break block;
  }
  return $0 | 0;
 }
 
 function $38() {
  var $1_1 = 0;
  block : {
   $1_1 = 17;
   break block;
  }
  return $1_1 | 0;
 }
 
 function $39() {
  var $0 = Math_fround(0);
  block : {
   $0 = Math_fround(1.7000000476837158);
   break block;
  }
  return Math_fround($0);
 }
 
 function $40() {
  var i64toi32_i32$0 = 0, $0 = 0, $0$hi = 0;
  block : {
   i64toi32_i32$0 = 0;
   $0 = 30;
   $0$hi = i64toi32_i32$0;
   break block;
  }
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return $0 | 0;
 }
 
 function $41() {
  var $0 = 0;
  block : {
   $0 = 30;
   break block;
  }
  return $0 | 0;
 }
 
 function $42() {
  var $0 = 0;
  block : {
   $0 = 31;
   break block;
  }
  return $0 | 0;
 }
 
 function $43() {
  var $0 = 0;
  block : {
   $0 = 32;
   break block;
  }
  return $0 | 0;
 }
 
 function $44() {
  var $0 = 0;
  block : {
   $0 = 33;
   break block;
  }
  return $0 | 0;
 }
 
 function $45() {
  var $0 = Math_fround(0);
  block : {
   $0 = Math_fround(3.4000000953674316);
   break block;
  }
  return Math_fround($0);
 }
 
 function $46() {
  var $0 = 0;
  block : {
   $0 = 3;
   break block;
  }
  return $0 | 0;
 }
 
 function $47() {
  var $0 = 0, $0$hi = 0, i64toi32_i32$1 = 0;
  block : {
   $0 = 45;
   $0$hi = 0;
   break block;
  }
  i64toi32_i32$1 = $0$hi;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return $0 | 0;
 }
 
 function $48() {
  var $0 = 0;
  block : {
   $0 = 44;
   break block;
  }
  return $0 | 0;
 }
 
 function $49() {
  var $0 = 0;
  block : {
   $0 = 43;
   break block;
  }
  return $0 | 0;
 }
 
 function $50() {
  var $0 = 0;
  block : {
   $0 = 42;
   break block;
  }
  return $0 | 0;
 }
 
 function $51() {
  var $0 = 0;
  block : {
   $0 = 41;
   break block;
  }
  return $0 | 0;
 }
 
 function $52() {
  var $0 = 0;
  block : {
   $0 = 40;
   break block;
  }
  return $0 | 0;
 }
 
 function $53() {
  var $0 = 0;
  block : {
   dummy();
   $0 = 8;
   break block;
  }
  return 1 + $0 | 0 | 0;
 }
 
 function $54() {
  var $0 = 0;
  block : {
   block0 : {
    $0 = 8;
    break block;
   }
  }
  return 1 + $0 | 0 | 0;
 }
 
 function $55() {
  var $0 = 0, $1_1 = 0;
  block : {
   $0 = 8;
   break block;
  }
  return 1 + $0 | 0 | 0;
 }
 
 function $56() {
  var $0 = 0;
  block : {
   $0 = 8;
   break block;
  }
  return 1 + $0 | 0 | 0;
 }
 
 function $57() {
  var $0 = 0;
  block : {
   $0 = 8;
   break block;
  }
  return 1 + $0 | 0 | 0;
 }
 
 function $58() {
  var $0 = 0;
  block : {
   $0 = 8;
   break block;
  }
  return 1 + $0 | 0 | 0;
 }
 
 function legalstub$6() {
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $7_1 = 0, $0 = 0, $0$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $6() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $7_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $7_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($7_1 | 0);
  i64toi32_i32$0 = $0$hi;
  return $0 | 0;
 }
 
 function legalstub$23() {
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $7_1 = 0, $0 = 0, $0$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $23() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $7_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $7_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($7_1 | 0);
  i64toi32_i32$0 = $0$hi;
  return $0 | 0;
 }
 
 function legalstub$40() {
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $7_1 = 0, $0 = 0, $0$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $40() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $7_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $7_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($7_1 | 0);
  i64toi32_i32$0 = $0$hi;
  return $0 | 0;
 }
 
 function legalstub$47() {
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $7_1 = 0, $0 = 0, $0$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $47() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $7_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $7_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($7_1 | 0);
  i64toi32_i32$0 = $0$hi;
  return $0 | 0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "type_i32": $1, 
  "type_i64": $2, 
  "type_f32": $3, 
  "type_f64": $4, 
  "type_i32_value": $5, 
  "type_i64_value": legalstub$6, 
  "type_f32_value": $7, 
  "type_f64_value": $8, 
  "as_block_first": $9, 
  "as_block_mid": $10, 
  "as_block_last": $11, 
  "as_block_value": $12, 
  "as_loop_first": $13, 
  "as_loop_mid": $14, 
  "as_loop_last": $15, 
  "as_br_value": $16, 
  "as_br_if_cond": $17, 
  "as_br_if_value": $18, 
  "as_br_if_value_cond": $19, 
  "as_br_table_index": $20, 
  "as_br_table_value": $21, 
  "as_br_table_value_index": $22, 
  "as_return_value": legalstub$23, 
  "as_if_cond": $24, 
  "as_if_then": $25, 
  "as_if_else": $26, 
  "as_select_first": $27, 
  "as_select_second": $28, 
  "as_select_cond": $29, 
  "as_call_first": $31, 
  "as_call_mid": $32, 
  "as_call_last": $33, 
  "as_call_indirect_func": $34, 
  "as_call_indirect_first": $35, 
  "as_call_indirect_mid": $36, 
  "as_call_indirect_last": $37, 
  "as_local_set_value": $38, 
  "as_load_address": $39, 
  "as_loadN_address": legalstub$40, 
  "as_store_address": $41, 
  "as_store_value": $42, 
  "as_storeN_address": $43, 
  "as_storeN_value": $44, 
  "as_unary_operand": $45, 
  "as_binary_left": $46, 
  "as_binary_right": legalstub$47, 
  "as_test_operand": $48, 
  "as_compare_left": $49, 
  "as_compare_right": $50, 
  "as_convert_operand": $51, 
  "as_grow_memory_size": $52, 
  "nested_block_value": $53, 
  "nested_br_value": $54, 
  "nested_br_if_value": $55, 
  "nested_br_if_value_cond": $56, 
  "nested_br_table_value": $57, 
  "nested_br_table_value_index": $58
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0},memasmFunc);
export var type_i32 = retasmFunc.type_i32;
export var type_i64 = retasmFunc.type_i64;
export var type_f32 = retasmFunc.type_f32;
export var type_f64 = retasmFunc.type_f64;
export var type_i32_value = retasmFunc.type_i32_value;
export var type_i64_value = retasmFunc.type_i64_value;
export var type_f32_value = retasmFunc.type_f32_value;
export var type_f64_value = retasmFunc.type_f64_value;
export var as_block_first = retasmFunc.as_block_first;
export var as_block_mid = retasmFunc.as_block_mid;
export var as_block_last = retasmFunc.as_block_last;
export var as_block_value = retasmFunc.as_block_value;
export var as_loop_first = retasmFunc.as_loop_first;
export var as_loop_mid = retasmFunc.as_loop_mid;
export var as_loop_last = retasmFunc.as_loop_last;
export var as_br_value = retasmFunc.as_br_value;
export var as_br_if_cond = retasmFunc.as_br_if_cond;
export var as_br_if_value = retasmFunc.as_br_if_value;
export var as_br_if_value_cond = retasmFunc.as_br_if_value_cond;
export var as_br_table_index = retasmFunc.as_br_table_index;
export var as_br_table_value = retasmFunc.as_br_table_value;
export var as_br_table_value_index = retasmFunc.as_br_table_value_index;
export var as_return_value = retasmFunc.as_return_value;
export var as_if_cond = retasmFunc.as_if_cond;
export var as_if_then = retasmFunc.as_if_then;
export var as_if_else = retasmFunc.as_if_else;
export var as_select_first = retasmFunc.as_select_first;
export var as_select_second = retasmFunc.as_select_second;
export var as_select_cond = retasmFunc.as_select_cond;
export var as_call_first = retasmFunc.as_call_first;
export var as_call_mid = retasmFunc.as_call_mid;
export var as_call_last = retasmFunc.as_call_last;
export var as_call_indirect_func = retasmFunc.as_call_indirect_func;
export var as_call_indirect_first = retasmFunc.as_call_indirect_first;
export var as_call_indirect_mid = retasmFunc.as_call_indirect_mid;
export var as_call_indirect_last = retasmFunc.as_call_indirect_last;
export var as_local_set_value = retasmFunc.as_local_set_value;
export var as_load_address = retasmFunc.as_load_address;
export var as_loadN_address = retasmFunc.as_loadN_address;
export var as_store_address = retasmFunc.as_store_address;
export var as_store_value = retasmFunc.as_store_value;
export var as_storeN_address = retasmFunc.as_storeN_address;
export var as_storeN_value = retasmFunc.as_storeN_value;
export var as_unary_operand = retasmFunc.as_unary_operand;
export var as_binary_left = retasmFunc.as_binary_left;
export var as_binary_right = retasmFunc.as_binary_right;
export var as_test_operand = retasmFunc.as_test_operand;
export var as_compare_left = retasmFunc.as_compare_left;
export var as_compare_right = retasmFunc.as_compare_right;
export var as_convert_operand = retasmFunc.as_convert_operand;
export var as_grow_memory_size = retasmFunc.as_grow_memory_size;
export var nested_block_value = retasmFunc.nested_block_value;
export var nested_br_value = retasmFunc.nested_br_value;
export var nested_br_if_value = retasmFunc.nested_br_if_value;
export var nested_br_if_value_cond = retasmFunc.nested_br_if_value_cond;
export var nested_br_table_value = retasmFunc.nested_br_table_value;
export var nested_br_table_value_index = retasmFunc.nested_br_table_value_index;

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
 var FUNCTION_TABLE = [];
 return {
  
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
