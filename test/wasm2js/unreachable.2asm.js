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
 
 function dummy3($0, $1, $2_1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2_1 = $2_1 | 0;
 }
 
 function $2() {
  abort();
 }
 
 function $3() {
  abort();
 }
 
 function $4() {
  abort();
 }
 
 function $5() {
  abort();
 }
 
 function $6() {
  var $0 = 0;
  abort();
 }
 
 function $7() {
  var $0 = 0;
  dummy();
  abort();
 }
 
 function $8() {
  dummy();
  abort();
 }
 
 function $9() {
  dummy();
  abort();
 }
 
 function $10() {
  var $0 = 0;
  abort();
 }
 
 function $11() {
  var $0 = 0;
  block : {
   dummy();
   abort();
  }
 }
 
 function $12() {
  block : {
   dummy();
   abort();
  }
 }
 
 function $13() {
  block : {
   dummy();
   abort();
  }
 }
 
 function $14() {
  var $0 = 0;
  block : {
   dummy();
   $0 = 1;
   break block;
  }
  return $0 | 0;
 }
 
 function $15() {
  var $0 = 0, $2_1 = 0;
  loop_in : while (1) abort();
 }
 
 function $16() {
  var $0 = 0, $2_1 = 0;
  loop_in : while (1) {
   dummy();
   abort();
  };
 }
 
 function $17() {
  loop_in : while (1) {
   dummy();
   abort();
  };
 }
 
 function $18() {
  var $0 = 0;
  block : {
   loop_in : while (1) {
    dummy();
    $0 = 1;
    break block;
   };
  }
  return $0 | 0;
 }
 
 function $19() {
  abort();
 }
 
 function $20() {
  abort();
 }
 
 function $21() {
  var $0 = 0;
  abort();
 }
 
 function $22() {
  var $0 = 0;
  abort();
 }
 
 function $23() {
  abort();
 }
 
 function $24() {
  var $0 = 0;
  abort();
 }
 
 function $25() {
  var $1 = 0;
  abort();
 }
 
 function $26() {
  abort();
 }
 
 function $27() {
  var $0 = 0;
  abort();
 }
 
 function $28($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var $4_1 = 0;
  if ($0) {
   abort()
  } else {
   $4_1 = $1
  }
  return $4_1 | 0;
 }
 
 function $29($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var $4_1 = 0;
  if ($0) {
   $4_1 = $1
  } else {
   abort()
  }
  return $4_1 | 0;
 }
 
 function $30($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var $2_1 = 0, $3_1 = 0;
  abort();
 }
 
 function $31($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var $2_1 = 0, $3_1 = 0;
  $2_1 = $0;
  abort();
 }
 
 function $32() {
  abort();
 }
 
 function $33() {
  abort();
 }
 
 function $34() {
  abort();
 }
 
 function $35() {
  abort();
 }
 
 function $36() {
  abort();
 }
 
 function $37() {
  abort();
 }
 
 function $38() {
  abort();
 }
 
 function $39() {
  abort();
 }
 
 function $40() {
  abort();
 }
 
 function $41() {
  abort();
 }
 
 function $42() {
  abort();
 }
 
 function $43() {
  abort();
 }
 
 function $44() {
  abort();
 }
 
 function $45() {
  abort();
 }
 
 function $46() {
  abort();
 }
 
 function $47() {
  abort();
 }
 
 function $48() {
  abort();
 }
 
 function $49() {
  abort();
 }
 
 function $50() {
  abort();
 }
 
 function $51() {
  abort();
 }
 
 function $52() {
  abort();
 }
 
 function $53() {
  abort();
 }
 
 function $54() {
  abort();
 }
 
 function legalstub$26() {
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $7_1 = 0, $0 = 0, $0$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $26() | 0;
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
 
 function legalstub$42() {
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $7_1 = 0, $0 = 0, $0$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $42() | 0;
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
 
 function legalstub$49() {
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $7_1 = 0, $0 = 0, $0$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $49() | 0;
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
  "type_i32": $2, 
  "type_i64": $3, 
  "type_f32": $4, 
  "type_f64": $5, 
  "as_func_first": $6, 
  "as_func_mid": $7, 
  "as_func_last": $8, 
  "as_func_value": $9, 
  "as_block_first": $10, 
  "as_block_mid": $11, 
  "as_block_last": $12, 
  "as_block_value": $13, 
  "as_block_broke": $14, 
  "as_loop_first": $15, 
  "as_loop_mid": $16, 
  "as_loop_last": $17, 
  "as_loop_broke": $18, 
  "as_br_value": $19, 
  "as_br_if_cond": $20, 
  "as_br_if_value": $21, 
  "as_br_if_value_cond": $22, 
  "as_br_table_index": $23, 
  "as_br_table_value": $24, 
  "as_br_table_value_index": $25, 
  "as_return_value": legalstub$26, 
  "as_if_cond": $27, 
  "as_if_then": $28, 
  "as_if_else": $29, 
  "as_select_first": $30, 
  "as_select_second": $31, 
  "as_select_cond": $32, 
  "as_call_first": $33, 
  "as_call_mid": $34, 
  "as_call_last": $35, 
  "as_call_indirect_func": $36, 
  "as_call_indirect_first": $37, 
  "as_call_indirect_mid": $38, 
  "as_call_indirect_last": $39, 
  "as_local_set_value": $40, 
  "as_load_address": $41, 
  "as_loadN_address": legalstub$42, 
  "as_store_address": $43, 
  "as_store_value": $44, 
  "as_storeN_address": $45, 
  "as_storeN_value": $46, 
  "as_unary_operand": $47, 
  "as_binary_left": $48, 
  "as_binary_right": legalstub$49, 
  "as_test_operand": $50, 
  "as_compare_left": $51, 
  "as_compare_right": $52, 
  "as_convert_operand": $53, 
  "as_grow_memory_size": $54
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0},memasmFunc);
export var type_i32 = retasmFunc.type_i32;
export var type_i64 = retasmFunc.type_i64;
export var type_f32 = retasmFunc.type_f32;
export var type_f64 = retasmFunc.type_f64;
export var as_func_first = retasmFunc.as_func_first;
export var as_func_mid = retasmFunc.as_func_mid;
export var as_func_last = retasmFunc.as_func_last;
export var as_func_value = retasmFunc.as_func_value;
export var as_block_first = retasmFunc.as_block_first;
export var as_block_mid = retasmFunc.as_block_mid;
export var as_block_last = retasmFunc.as_block_last;
export var as_block_value = retasmFunc.as_block_value;
export var as_block_broke = retasmFunc.as_block_broke;
export var as_loop_first = retasmFunc.as_loop_first;
export var as_loop_mid = retasmFunc.as_loop_mid;
export var as_loop_last = retasmFunc.as_loop_last;
export var as_loop_broke = retasmFunc.as_loop_broke;
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
