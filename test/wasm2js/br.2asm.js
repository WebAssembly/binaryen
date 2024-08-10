import * as env from 'env';

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
 var env = imports.env;
 var setTempRet0 = env.setTempRet0;
 var i64toi32_i32$HIGH_BITS = 0;
 function dummy() {
  
 }
 
 function f0() {
  
 }
 
 function f1() {
  
 }
 
 function f2() {
  
 }
 
 function f3() {
  
 }
 
 function f4() {
  var $0 = 0;
  block : {
   $0 = 1;
   break block;
  }
  return $0 | 0;
 }
 
 function f5() {
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
 
 function f6() {
  var $0 = Math_fround(0);
  block : {
   $0 = Math_fround(3.0);
   break block;
  }
  return Math_fround($0);
 }
 
 function f7() {
  var $0 = 0.0;
  block : {
   $0 = 4.0;
   break block;
  }
  return +$0;
 }
 
 function f8() {
  
 }
 
 function f9() {
  block : {
   dummy();
   break block;
  }
 }
 
 function f10() {
  block : {
   dummy();
   break block;
  }
 }
 
 function f11() {
  var $0 = 0;
  block : {
   dummy();
   $0 = 2;
   break block;
  }
  return $0 | 0;
 }
 
 function f12() {
  var $0 = 0, $1 = 0, $3 = 0;
  block : {
   $null_Name_ : while (1) {
    $0 = 3;
    break block;
   };
  }
  return $0 | 0;
 }
 
 function f13() {
  var $0 = 0, $1 = 0, $3 = 0;
  block : {
   $null_Name_ : while (1) {
    dummy();
    $0 = 4;
    break block;
   };
  }
  return $0 | 0;
 }
 
 function f14() {
  var $0 = 0;
  block : {
   $null_Name_ : while (1) {
    dummy();
    $0 = 5;
    break block;
   };
  }
  return $0 | 0;
 }
 
 function f15() {
  var $0 = 0;
  block : {
   $0 = 9;
   break block;
  }
  return $0 | 0;
 }
 
 function f16() {
  
 }
 
 function f17() {
  var $0 = 0;
  block : {
   $0 = 8;
   break block;
  }
  return $0 | 0;
 }
 
 function f18() {
  var $0 = 0;
  block : {
   $0 = 9;
   break block;
  }
  return $0 | 0;
 }
 
 function f19() {
  
 }
 
 function f20() {
  var $0 = 0;
  block : {
   $0 = 10;
   break block;
  }
  return $0 | 0;
 }
 
 function f21() {
  var $0 = 0;
  block : {
   $0 = 11;
   break block;
  }
  return $0 | 0;
 }
 
 function f22() {
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
 
 function f23() {
  var $0 = 0, $1 = 0;
  block : {
   $0 = 2;
   break block;
  }
  return $0 | 0;
 }
 
 function f24($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var $3 = 0, $5 = 0;
  block : {
   if ($0) {
    $3 = 3;
    break block;
   } else {
    $5 = $1
   }
   $3 = $5;
  }
  return $3 | 0;
 }
 
 function f25($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var $4 = 0, $5 = 0;
  block : {
   if ($0) {
    $5 = $1
   } else {
    $4 = 4;
    break block;
   }
   $4 = $5;
  }
  return $4 | 0;
 }
 
 function f26($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var $2 = 0, $3 = 0, $4 = 0;
  block : {
   $2 = 5;
   break block;
  }
  return $2 | 0;
 }
 
 function f27($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var $2 = 0, $3 = 0, $4 = 0;
  block : {
   $2 = $0;
   $3 = 6;
   break block;
  }
  return $3 | 0;
 }
 
 function f28() {
  var $0 = 0;
  block : {
   $0 = 7;
   break block;
  }
  return $0 | 0;
 }
 
 function f($0, $1, $2) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2 = $2 | 0;
  return -1 | 0;
 }
 
 function f29() {
  var $0 = 0;
  block : {
   $0 = 12;
   break block;
  }
  return $0 | 0;
 }
 
 function f30() {
  var $0 = 0;
  block : {
   $0 = 13;
   break block;
  }
  return $0 | 0;
 }
 
 function f31() {
  var $0 = 0;
  block : {
   $0 = 14;
   break block;
  }
  return $0 | 0;
 }
 
 function f32() {
  var $0 = 0;
  block : {
   $0 = 20;
   break block;
  }
  return $0 | 0;
 }
 
 function f33() {
  var $0 = 0;
  block : {
   $0 = 21;
   break block;
  }
  return $0 | 0;
 }
 
 function f34() {
  var $0 = 0;
  block : {
   $0 = 22;
   break block;
  }
  return $0 | 0;
 }
 
 function f35() {
  var $0 = 0;
  block : {
   $0 = 23;
   break block;
  }
  return $0 | 0;
 }
 
 function f36() {
  var $1 = 0;
  block : {
   $1 = 17;
   break block;
  }
  return $1 | 0;
 }
 
 function f37() {
  var $1 = 0;
  block : {
   $1 = 1;
   break block;
  }
  return $1 | 0;
 }
 
 function f38() {
  var $0 = 0;
  block : {
   $0 = 1;
   break block;
  }
  return $0 | 0;
 }
 
 function f39() {
  var $0 = Math_fround(0);
  block : {
   $0 = Math_fround(1.7000000476837158);
   break block;
  }
  return Math_fround($0);
 }
 
 function f40() {
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
 
 function f41() {
  var $0 = 0;
  block : {
   $0 = 30;
   break block;
  }
  return $0 | 0;
 }
 
 function f42() {
  var $0 = 0;
  block : {
   $0 = 31;
   break block;
  }
  return $0 | 0;
 }
 
 function f43() {
  var $0 = 0;
  block : {
   $0 = 32;
   break block;
  }
  return $0 | 0;
 }
 
 function f44() {
  var $0 = 0;
  block : {
   $0 = 33;
   break block;
  }
  return $0 | 0;
 }
 
 function f45() {
  var $0 = Math_fround(0);
  block : {
   $0 = Math_fround(3.4000000953674316);
   break block;
  }
  return Math_fround($0);
 }
 
 function f46() {
  var $0 = 0;
  block : {
   $0 = 3;
   break block;
  }
  return $0 | 0;
 }
 
 function f47() {
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
 
 function f48() {
  var $0 = 0;
  block : {
   $0 = 44;
   break block;
  }
  return $0 | 0;
 }
 
 function f49() {
  var $0 = 0;
  block : {
   $0 = 43;
   break block;
  }
  return $0 | 0;
 }
 
 function f50() {
  var $0 = 0;
  block : {
   $0 = 42;
   break block;
  }
  return $0 | 0;
 }
 
 function f51() {
  var $0 = 0;
  block : {
   $0 = 41;
   break block;
  }
  return $0 | 0;
 }
 
 function f52() {
  var $0 = 0;
  block : {
   $0 = 40;
   break block;
  }
  return $0 | 0;
 }
 
 function f53() {
  var $0 = 0;
  block : {
   dummy();
   $0 = 8;
   break block;
  }
  return 1 + $0 | 0 | 0;
 }
 
 function f54() {
  var $0 = 0;
  block : {
   block0 : {
    $0 = 8;
    break block;
   }
  }
  return 1 + $0 | 0 | 0;
 }
 
 function f55() {
  var $0 = 0, $1 = 0;
  block : {
   $0 = 8;
   break block;
  }
  return 1 + $0 | 0 | 0;
 }
 
 function f56() {
  var $0 = 0;
  block : {
   $0 = 8;
   break block;
  }
  return 1 + $0 | 0 | 0;
 }
 
 function f57() {
  var $0 = 0;
  block : {
   $0 = 8;
   break block;
  }
  return 1 + $0 | 0 | 0;
 }
 
 function f58() {
  var $0 = 0;
  block : {
   $0 = 8;
   break block;
  }
  return 1 + $0 | 0 | 0;
 }
 
 function legalstub$f5() {
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $7 = 0, $0 = 0, $0$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = f5() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $7 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $7 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($7 | 0);
  i64toi32_i32$0 = $0$hi;
  return $0 | 0;
 }
 
 function legalstub$f22() {
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $7 = 0, $0 = 0, $0$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = f22() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $7 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $7 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($7 | 0);
  i64toi32_i32$0 = $0$hi;
  return $0 | 0;
 }
 
 function legalstub$f40() {
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $7 = 0, $0 = 0, $0$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = f40() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $7 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $7 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($7 | 0);
  i64toi32_i32$0 = $0$hi;
  return $0 | 0;
 }
 
 function legalstub$f47() {
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $7 = 0, $0 = 0, $0$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = f47() | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $0 = i64toi32_i32$0;
  $0$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $7 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $7 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($7 | 0);
  i64toi32_i32$0 = $0$hi;
  return $0 | 0;
 }
 
 return {
  "type_i32": f0, 
  "type_i64": f1, 
  "type_f32": f2, 
  "type_f64": f3, 
  "type_i32_value": f4, 
  "type_i64_value": legalstub$f5, 
  "type_f32_value": f6, 
  "type_f64_value": f7, 
  "as_block_first": f8, 
  "as_block_mid": f9, 
  "as_block_last": f10, 
  "as_block_value": f11, 
  "as_loop_first": f12, 
  "as_loop_mid": f13, 
  "as_loop_last": f14, 
  "as_br_value": f15, 
  "as_br_if_cond": f16, 
  "as_br_if_value": f17, 
  "as_br_if_value_cond": f18, 
  "as_br_table_index": f19, 
  "as_br_table_value": f20, 
  "as_br_table_value_index": f21, 
  "as_return_value": legalstub$f22, 
  "as_if_cond": f23, 
  "as_if_then": f24, 
  "as_if_else": f25, 
  "as_select_first": f26, 
  "as_select_second": f27, 
  "as_select_cond": f28, 
  "as_call_first": f29, 
  "as_call_mid": f30, 
  "as_call_last": f31, 
  "as_call_indirect_func": f32, 
  "as_call_indirect_first": f33, 
  "as_call_indirect_mid": f34, 
  "as_call_indirect_last": f35, 
  "as_local_set_value": f36, 
  "as_local_tee_value": f37, 
  "as_global_set_value": f38, 
  "as_load_address": f39, 
  "as_loadN_address": legalstub$f40, 
  "as_store_address": f41, 
  "as_store_value": f42, 
  "as_storeN_address": f43, 
  "as_storeN_value": f44, 
  "as_unary_operand": f45, 
  "as_binary_left": f46, 
  "as_binary_right": legalstub$f47, 
  "as_test_operand": f48, 
  "as_compare_left": f49, 
  "as_compare_right": f50, 
  "as_convert_operand": f51, 
  "as_memory_grow_size": f52, 
  "nested_block_value": f53, 
  "nested_br_value": f54, 
  "nested_br_if_value": f55, 
  "nested_br_if_value_cond": f56, 
  "nested_br_table_value": f57, 
  "nested_br_table_value_index": f58
 };
}

var retasmFunc = asmFunc({
  "env": env,
});
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
export var as_local_tee_value = retasmFunc.as_local_tee_value;
export var as_global_set_value = retasmFunc.as_global_set_value;
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
export var as_memory_grow_size = retasmFunc.as_memory_grow_size;
export var nested_block_value = retasmFunc.nested_block_value;
export var nested_br_value = retasmFunc.nested_br_value;
export var nested_br_if_value = retasmFunc.nested_br_if_value;
export var nested_br_if_value_cond = retasmFunc.nested_br_if_value_cond;
export var nested_br_table_value = retasmFunc.nested_br_table_value;
export var nested_br_table_value_index = retasmFunc.nested_br_table_value_index;
