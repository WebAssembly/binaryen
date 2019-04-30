import { setTempRet0 } from 'env';

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
 var setTempRet0 = env.setTempRet0;
 var i64toi32_i32$HIGH_BITS = 0;
 function $1() {
  
 }
 
 function $5() {
  return 1 | 0;
 }
 
 function $7() {
  return Math_fround(Math_fround(3.0));
 }
 
 function $8() {
  return 4.0;
 }
 
 function $12() {
  return 2 | 0;
 }
 
 function $13() {
  return 3 | 0;
 }
 
 function $14() {
  return 4 | 0;
 }
 
 function $15() {
  return 5 | 0;
 }
 
 function $16() {
  return 9 | 0;
 }
 
 function $18() {
  return 8 | 0;
 }
 
 function $21() {
  return 10 | 0;
 }
 
 function $22() {
  return 11 | 0;
 }
 
 function $25($0, $1_1) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  if ($0) {
   $1_1 = 3
  }
  return $1_1 | 0;
 }
 
 function $26($0, $1_1) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  if (!$0) {
   $1_1 = 4
  }
  return $1_1 | 0;
 }
 
 function $27($0, $1_1) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  return 5 | 0;
 }
 
 function $28($0, $1_1) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  return 6 | 0;
 }
 
 function $29() {
  return 7 | 0;
 }
 
 function $31() {
  return 12 | 0;
 }
 
 function $32() {
  return 13 | 0;
 }
 
 function $33() {
  return 14 | 0;
 }
 
 function $34() {
  return 20 | 0;
 }
 
 function $35() {
  return 21 | 0;
 }
 
 function $36() {
  return 22 | 0;
 }
 
 function $37() {
  return 23 | 0;
 }
 
 function $38() {
  return 17 | 0;
 }
 
 function $39() {
  return Math_fround(Math_fround(1.7000000476837158));
 }
 
 function $41() {
  return 30 | 0;
 }
 
 function $42() {
  return 31 | 0;
 }
 
 function $43() {
  return 32 | 0;
 }
 
 function $44() {
  return 33 | 0;
 }
 
 function $45() {
  return Math_fround(Math_fround(3.4000000953674316));
 }
 
 function $48() {
  return 44 | 0;
 }
 
 function $49() {
  return 43 | 0;
 }
 
 function $50() {
  return 42 | 0;
 }
 
 function $51() {
  return 41 | 0;
 }
 
 function $52() {
  return 40 | 0;
 }
 
 function legalstub$6() {
  i64toi32_i32$HIGH_BITS = 0;
  setTempRet0(i64toi32_i32$HIGH_BITS | 0);
  return 2;
 }
 
 function legalstub$23() {
  i64toi32_i32$HIGH_BITS = 0;
  setTempRet0(i64toi32_i32$HIGH_BITS | 0);
  return 7;
 }
 
 function legalstub$40() {
  i64toi32_i32$HIGH_BITS = 0;
  setTempRet0(i64toi32_i32$HIGH_BITS | 0);
  return 30;
 }
 
 function legalstub$47() {
  i64toi32_i32$HIGH_BITS = 0;
  setTempRet0(i64toi32_i32$HIGH_BITS | 0);
  return 45;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "type_i32": $1, 
  "type_i64": $1, 
  "type_f32": $1, 
  "type_f64": $1, 
  "type_i32_value": $5, 
  "type_i64_value": legalstub$6, 
  "type_f32_value": $7, 
  "type_f64_value": $8, 
  "as_block_first": $1, 
  "as_block_mid": $1, 
  "as_block_last": $1, 
  "as_block_value": $12, 
  "as_loop_first": $13, 
  "as_loop_mid": $14, 
  "as_loop_last": $15, 
  "as_br_value": $16, 
  "as_br_if_cond": $1, 
  "as_br_if_value": $18, 
  "as_br_if_value_cond": $16, 
  "as_br_table_index": $1, 
  "as_br_table_value": $21, 
  "as_br_table_value_index": $22, 
  "as_return_value": legalstub$23, 
  "as_if_cond": $12, 
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
  "as_binary_left": $13, 
  "as_binary_right": legalstub$47, 
  "as_test_operand": $48, 
  "as_compare_left": $49, 
  "as_compare_right": $50, 
  "as_convert_operand": $51, 
  "as_grow_memory_size": $52, 
  "nested_block_value": $16, 
  "nested_br_value": $16, 
  "nested_br_if_value": $16, 
  "nested_br_if_value_cond": $16, 
  "nested_br_table_value": $16, 
  "nested_br_table_value_index": $16
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
 var FUNCTION_TABLE = [];
 return {
  
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
