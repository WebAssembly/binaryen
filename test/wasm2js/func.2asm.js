function asmFunc(global, env, buffer) {
 "use asm";
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
 var i64toi32_i32$HIGH_BITS = 0;
 function dummy() {
  
 }
 
 function $1() {
  
 }
 
 function $2() {
  
 }
 
 function f() {
  
 }
 
 function h() {
  
 }
 
 function $5() {
  
 }
 
 function $6() {
  
 }
 
 function $7() {
  
 }
 
 function $8() {
  
 }
 
 function $9() {
  
 }
 
 function $10() {
  
 }
 
 function $11() {
  
 }
 
 function $12() {
  
 }
 
 function $13() {
  
 }
 
 function $14($0) {
  $0 = $0 | 0;
 }
 
 function $15(x) {
  x = x | 0;
 }
 
 function $16($0, $1_1, $2_1, $2$hi) {
  $0 = $0 | 0;
  $1_1 = +$1_1;
  $2_1 = $2_1 | 0;
  $2$hi = $2$hi | 0;
 }
 
 function $17($0, $1_1) {
  $0 = $0 | 0;
  $1_1 = +$1_1;
 }
 
 function $18($0, $1_1, x, x$hi, $3, $4) {
  $0 = $0 | 0;
  $1_1 = Math_fround($1_1);
  x = x | 0;
  x$hi = x$hi | 0;
  $3 = $3 | 0;
  $4 = +$4;
 }
 
 function $19() {
  return abort() | 0;
 }
 
 function $20() {
  
 }
 
 function $21() {
  return 0 | 0;
 }
 
 function $22($0, $1_1, $2_1) {
  $0 = $0 | 0;
  $1_1 = +$1_1;
  $2_1 = $2_1 | 0;
  return 0 | 0;
 }
 
 function $23() {
  return 0 | 0;
 }
 
 function $24($0, $1_1, $2_1) {
  $0 = $0 | 0;
  $1_1 = +$1_1;
  $2_1 = $2_1 | 0;
  return 0 | 0;
 }
 
 function $25() {
  
 }
 
 function complex($0, $1_1, x, x$hi, $3) {
  $0 = $0 | 0;
  $1_1 = Math_fround($1_1);
  x = x | 0;
  x$hi = x$hi | 0;
  $3 = $3 | 0;
  abort();
 }
 
 function complex_sig() {
  abort();
 }
 
 function $28() {
  var $0 = 0;
  return $0 | 0;
 }
 
 function $29() {
  var i64toi32_i32$0 = 0, $0$hi = 0, $0 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return $0 | 0;
 }
 
 function $30() {
  var $0 = Math_fround(0);
  return Math_fround($0);
 }
 
 function $31() {
  var $0 = 0.0;
  return +$0;
 }
 
 function $32() {
  var $1_1 = 0;
  return $1_1 | 0;
 }
 
 function $33() {
  var i64toi32_i32$0 = 0, $1$hi = 0, $1_1 = 0;
  i64toi32_i32$0 = $1$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return $1_1 | 0;
 }
 
 function $34() {
  var $1_1 = Math_fround(0);
  return Math_fround($1_1);
 }
 
 function $35() {
  var $1_1 = 0.0;
  return +$1_1;
 }
 
 function $36() {
  var i64toi32_i32$0 = 0, $4 = 0.0, $0 = Math_fround(0), x = 0, $2$hi = 0, $2_1 = 0, $3 = 0, $5_1 = 0;
  i64toi32_i32$0 = $2$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  return +$4;
 }
 
 function $37($0, $1_1) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  return $0 | 0;
 }
 
 function $38($0, $0$hi, $1_1, $1$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  $1_1 = $1_1 | 0;
  $1$hi = $1$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return $0 | 0;
 }
 
 function $39($0, $1_1) {
  $0 = Math_fround($0);
  $1_1 = Math_fround($1_1);
  return Math_fround($0);
 }
 
 function $40($0, $1_1) {
  $0 = +$0;
  $1_1 = +$1_1;
  return +$0;
 }
 
 function $41($0, $1_1) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  return $1_1 | 0;
 }
 
 function $42($0, $0$hi, $1_1, $1$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  $1_1 = $1_1 | 0;
  $1$hi = $1$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = $1$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return $1_1 | 0;
 }
 
 function $43($0, $1_1) {
  $0 = Math_fround($0);
  $1_1 = Math_fround($1_1);
  return Math_fround($1_1);
 }
 
 function $44($0, $1_1) {
  $0 = +$0;
  $1_1 = +$1_1;
  return +$1_1;
 }
 
 function $45($0, $1_1, x, x$hi, $3, $4, $5_1) {
  $0 = Math_fround($0);
  $1_1 = $1_1 | 0;
  x = x | 0;
  x$hi = x$hi | 0;
  $3 = $3 | 0;
  $4 = +$4;
  $5_1 = $5_1 | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = x$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  return +$4;
 }
 
 function $46() {
  
 }
 
 function $47() {
  dummy();
 }
 
 function $48() {
  return 77 | 0;
 }
 
 function $49() {
  i64toi32_i32$HIGH_BITS = 0;
  return 7777 | 0;
 }
 
 function $50() {
  return Math_fround(Math_fround(77.69999694824219));
 }
 
 function $51() {
  return +(77.77);
 }
 
 function $52() {
  block : {
   dummy();
   dummy();
  };
 }
 
 function $53() {
  dummy();
  return 77 | 0;
 }
 
 function $54() {
  return;
 }
 
 function $55() {
  return 78 | 0;
 }
 
 function $56() {
  i64toi32_i32$HIGH_BITS = 0;
  return 7878 | 0;
 }
 
 function $57() {
  return Math_fround(Math_fround(78.69999694824219));
 }
 
 function $58() {
  return +(78.78);
 }
 
 function $59() {
  dummy();
  return 77 | 0;
 }
 
 function $60() {
  
 }
 
 function $61() {
  var $0 = 0;
  fake_return_waka123 : {
   $0 = 79;
   break fake_return_waka123;
  };
  return $0 | 0;
 }
 
 function $62() {
  var i64toi32_i32$0 = 0, $0 = 0, $0$hi = 0;
  fake_return_waka123 : {
   i64toi32_i32$0 = 0;
   $0 = 7979;
   $0$hi = i64toi32_i32$0;
   break fake_return_waka123;
  };
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return $0 | 0;
 }
 
 function $63() {
  var $0 = Math_fround(0);
  fake_return_waka123 : {
   $0 = Math_fround(79.9000015258789);
   break fake_return_waka123;
  };
  return Math_fround($0);
 }
 
 function $64() {
  var $0 = 0.0;
  fake_return_waka123 : {
   $0 = 79.79;
   break fake_return_waka123;
  };
  return +$0;
 }
 
 function $65() {
  var $2_1 = 0;
  fake_return_waka123 : {
   dummy();
   $2_1 = 77;
   break fake_return_waka123;
  };
  return $2_1 | 0;
 }
 
 function $66($0) {
  $0 = $0 | 0;
 }
 
 function $67($0) {
  $0 = $0 | 0;
  var $2_1 = 0;
  fake_return_waka123 : {
   $2_1 = 50;
   if ($0) break fake_return_waka123;
   $2_1 = 51;
  };
  return $2_1 | 0;
 }
 
 function $68($0) {
  $0 = $0 | 0;
 }
 
 function $69($0) {
  $0 = $0 | 0;
  var $3 = 0;
  fake_return_waka123 : {
   $3 = 50;
   switch ($0 | 0) {
   case 0:
    break fake_return_waka123;
   default:
    break fake_return_waka123;
   };
  };
  return $3 | 0;
 }
 
 function $70($0) {
  $0 = $0 | 0;
 }
 
 function $71($0) {
  $0 = $0 | 0;
  var $2_1 = 0, $3 = 0, $4 = 0;
  fake_return_waka123 : {
   block : {
    $2_1 = 50;
    $3 = $2_1;
    $4 = $2_1;
    switch ($0 | 0) {
    case 0:
     break block;
    case 1:
     break fake_return_waka123;
    default:
     break block;
    };
   };
   $4 = $3 + 2 | 0;
  };
  return $4 | 0;
 }
 
 function $72() {
  var $0 = 0;
  return $0 | 0;
 }
 
 function $73() {
  var i64toi32_i32$0 = 0, $0$hi = 0, $0 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return $0 | 0;
 }
 
 function $74() {
  var $0 = Math_fround(0);
  return Math_fround($0);
 }
 
 function $75() {
  var $0 = 0.0;
  return +$0;
 }
 
 return {
  f: $2, 
  g: h, 
  type_use_1: $20, 
  type_use_2: $21, 
  type_use_4: $22, 
  type_use_5: $23, 
  type_use_7: $24, 
  local_first_i32: $28, 
  local_first_i64: $29, 
  local_first_f32: $30, 
  local_first_f64: $31, 
  local_second_i32: $32, 
  local_second_i64: $33, 
  local_second_f32: $34, 
  local_second_f64: $35, 
  local_mixed: $36, 
  param_first_i32: $37, 
  param_first_i64: $38, 
  param_first_f32: $39, 
  param_first_f64: $40, 
  param_second_i32: $41, 
  param_second_i64: $42, 
  param_second_f32: $43, 
  param_second_f64: $44, 
  param_mixed: $45, 
  empty: $46, 
  value_void: $47, 
  value_i32: $48, 
  value_i64: $49, 
  value_f32: $50, 
  value_f64: $51, 
  value_block_void: $52, 
  value_block_i32: $53, 
  return_empty: $54, 
  return_i32: $55, 
  return_i64: $56, 
  return_f32: $57, 
  return_f64: $58, 
  return_block_i32: $59, 
  break_empty: $60, 
  break_i32: $61, 
  break_i64: $62, 
  break_f32: $63, 
  break_f64: $64, 
  break_block_i32: $65, 
  break_br_if_empty: $66, 
  break_br_if_num: $67, 
  break_br_table_empty: $68, 
  break_br_table_num: $69, 
  break_br_table_nested_empty: $70, 
  break_br_table_nested_num: $71, 
  init_local_i32: $72, 
  init_local_i64: $73, 
  init_local_f32: $74, 
  init_local_f64: $75
 };
}

const memasmFunc = new ArrayBuffer(65536);
const retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export const f = retasmFunc.f;
export const g = retasmFunc.g;
export const type_use_1 = retasmFunc.type_use_1;
export const type_use_2 = retasmFunc.type_use_2;
export const type_use_4 = retasmFunc.type_use_4;
export const type_use_5 = retasmFunc.type_use_5;
export const type_use_7 = retasmFunc.type_use_7;
export const local_first_i32 = retasmFunc.local_first_i32;
export const local_first_i64 = retasmFunc.local_first_i64;
export const local_first_f32 = retasmFunc.local_first_f32;
export const local_first_f64 = retasmFunc.local_first_f64;
export const local_second_i32 = retasmFunc.local_second_i32;
export const local_second_i64 = retasmFunc.local_second_i64;
export const local_second_f32 = retasmFunc.local_second_f32;
export const local_second_f64 = retasmFunc.local_second_f64;
export const local_mixed = retasmFunc.local_mixed;
export const param_first_i32 = retasmFunc.param_first_i32;
export const param_first_i64 = retasmFunc.param_first_i64;
export const param_first_f32 = retasmFunc.param_first_f32;
export const param_first_f64 = retasmFunc.param_first_f64;
export const param_second_i32 = retasmFunc.param_second_i32;
export const param_second_i64 = retasmFunc.param_second_i64;
export const param_second_f32 = retasmFunc.param_second_f32;
export const param_second_f64 = retasmFunc.param_second_f64;
export const param_mixed = retasmFunc.param_mixed;
export const empty = retasmFunc.empty;
export const value_void = retasmFunc.value_void;
export const value_i32 = retasmFunc.value_i32;
export const value_i64 = retasmFunc.value_i64;
export const value_f32 = retasmFunc.value_f32;
export const value_f64 = retasmFunc.value_f64;
export const value_block_void = retasmFunc.value_block_void;
export const value_block_i32 = retasmFunc.value_block_i32;
export const return_empty = retasmFunc.return_empty;
export const return_i32 = retasmFunc.return_i32;
export const return_i64 = retasmFunc.return_i64;
export const return_f32 = retasmFunc.return_f32;
export const return_f64 = retasmFunc.return_f64;
export const return_block_i32 = retasmFunc.return_block_i32;
export const break_empty = retasmFunc.break_empty;
export const break_i32 = retasmFunc.break_i32;
export const break_i64 = retasmFunc.break_i64;
export const break_f32 = retasmFunc.break_f32;
export const break_f64 = retasmFunc.break_f64;
export const break_block_i32 = retasmFunc.break_block_i32;
export const break_br_if_empty = retasmFunc.break_br_if_empty;
export const break_br_if_num = retasmFunc.break_br_if_num;
export const break_br_table_empty = retasmFunc.break_br_table_empty;
export const break_br_table_num = retasmFunc.break_br_table_num;
export const break_br_table_nested_empty = retasmFunc.break_br_table_nested_empty;
export const break_br_table_nested_num = retasmFunc.break_br_table_nested_num;
export const init_local_i32 = retasmFunc.init_local_i32;
export const init_local_i64 = retasmFunc.init_local_i64;
export const init_local_f32 = retasmFunc.init_local_f32;
export const init_local_f64 = retasmFunc.init_local_f64;
