
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
 function $2() {
  abort();
 }
 
 function $4() {
  abort();
 }
 
 function $8() {
  abort();
 }
 
 function $14() {
  return 1 | 0;
 }
 
 function $28($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  if ($0) {
   abort()
  }
  return $1 | 0;
 }
 
 function $29($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  if (!$0) {
   abort()
  }
  return $1 | 0;
 }
 
 function $30($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  abort();
 }
 
 function $41() {
  abort();
 }
 
 function legalstub$26() {
  abort();
 }
 
 var FUNCTION_TABLE = [];
 return {
  "type_i32": $2, 
  "type_i64": $2, 
  "type_f32": $4, 
  "type_f64": $4, 
  "as_func_first": $2, 
  "as_func_mid": $2, 
  "as_func_last": $8, 
  "as_func_value": $2, 
  "as_block_first": $2, 
  "as_block_mid": $2, 
  "as_block_last": $8, 
  "as_block_value": $2, 
  "as_block_broke": $14, 
  "as_loop_first": $2, 
  "as_loop_mid": $2, 
  "as_loop_last": $8, 
  "as_loop_broke": $14, 
  "as_br_value": $2, 
  "as_br_if_cond": $8, 
  "as_br_if_value": $2, 
  "as_br_if_value_cond": $2, 
  "as_br_table_index": $8, 
  "as_br_table_value": $2, 
  "as_br_table_value_index": $2, 
  "as_return_value": legalstub$26, 
  "as_if_cond": $2, 
  "as_if_then": $28, 
  "as_if_else": $29, 
  "as_select_first": $30, 
  "as_select_second": $30, 
  "as_select_cond": $2, 
  "as_call_first": $8, 
  "as_call_mid": $8, 
  "as_call_last": $8, 
  "as_call_indirect_func": $8, 
  "as_call_indirect_first": $8, 
  "as_call_indirect_mid": $8, 
  "as_call_indirect_last": $8, 
  "as_local_set_value": $8, 
  "as_load_address": $41, 
  "as_loadN_address": legalstub$26, 
  "as_store_address": $8, 
  "as_store_value": $8, 
  "as_storeN_address": $8, 
  "as_storeN_value": $8, 
  "as_unary_operand": $41, 
  "as_binary_left": $2, 
  "as_binary_right": legalstub$26, 
  "as_test_operand": $2, 
  "as_compare_left": $2, 
  "as_compare_right": $2, 
  "as_convert_operand": $2, 
  "as_grow_memory_size": $2
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
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
