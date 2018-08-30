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
 
 function complex($0, $1_1, x, x$hi, $3) {
  $0 = $0 | 0;
  $1_1 = Math_fround($1_1);
  x = x | 0;
  x$hi = x$hi | 0;
  $3 = $3 | 0;
  return abort() | 0;
 }
 
 function complex_sig() {
  abort();
 }
 
 function $23() {
  var $0 = 0;
  return $0 | 0;
 }
 
 function $24() {
  var i64toi32_i32$0 = 0, $0$hi = 0, $0 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return $0 | 0;
 }
 
 function $25() {
  var $0 = Math_fround(0);
  return Math_fround($0);
 }
 
 function $26() {
  var $0 = 0.0;
  return +$0;
 }
 
 function $27() {
  var $1_1 = 0;
  return $1_1 | 0;
 }
 
 function $28() {
  var i64toi32_i32$0 = 0, $1$hi = 0, $1_1 = 0;
  i64toi32_i32$0 = $1$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return $1_1 | 0;
 }
 
 function $29() {
  var $1_1 = Math_fround(0);
  return Math_fround($1_1);
 }
 
 function $30() {
  var $1_1 = 0.0;
  return +$1_1;
 }
 
 function $31() {
  var i64toi32_i32$0 = 0, $4 = 0.0, $0 = Math_fround(0), x = 0, $2$hi = 0, $2_1 = 0, $3 = 0, $5_1 = 0;
  i64toi32_i32$0 = $2$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  return +$4;
 }
 
 function $32($0, $1_1) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  return $0 | 0;
 }
 
 function $33($0, $0$hi, $1_1, $1$hi) {
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
 
 function $34($0, $1_1) {
  $0 = Math_fround($0);
  $1_1 = Math_fround($1_1);
  return Math_fround($0);
 }
 
 function $35($0, $1_1) {
  $0 = +$0;
  $1_1 = +$1_1;
  return +$0;
 }
 
 function $36($0, $1_1) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  return $1_1 | 0;
 }
 
 function $37($0, $0$hi, $1_1, $1$hi) {
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
 
 function $38($0, $1_1) {
  $0 = Math_fround($0);
  $1_1 = Math_fround($1_1);
  return Math_fround($1_1);
 }
 
 function $39($0, $1_1) {
  $0 = +$0;
  $1_1 = +$1_1;
  return +$1_1;
 }
 
 function $40($0, $1_1, x, x$hi, $3, $4, $5_1) {
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
 
 function $41() {
  
 }
 
 function $42() {
  dummy();
 }
 
 function $43() {
  return 77 | 0;
 }
 
 function $44() {
  i64toi32_i32$HIGH_BITS = 0;
  return 7777 | 0;
 }
 
 function $45() {
  return Math_fround(Math_fround(77.69999694824219));
 }
 
 function $46() {
  return +(77.77);
 }
 
 function $47() {
  block : {
   dummy();
   dummy();
  };
 }
 
 function $48() {
  dummy();
  return 77 | 0;
 }
 
 function $49() {
  return;
 }
 
 function $50() {
  return 78 | 0;
 }
 
 function $51() {
  i64toi32_i32$HIGH_BITS = 0;
  return 7878 | 0;
 }
 
 function $52() {
  return Math_fround(Math_fround(78.69999694824219));
 }
 
 function $53() {
  return +(78.78);
 }
 
 function $54() {
  dummy();
  return 77 | 0;
 }
 
 function $55() {
  
 }
 
 function $56() {
  var $0 = 0;
  fake_return_waka123 : {
   $0 = 79;
   break fake_return_waka123;
  };
  return $0 | 0;
 }
 
 function $57() {
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
 
 function $58() {
  var $0 = Math_fround(0);
  fake_return_waka123 : {
   $0 = Math_fround(79.9000015258789);
   break fake_return_waka123;
  };
  return Math_fround($0);
 }
 
 function $59() {
  var $0 = 0.0;
  fake_return_waka123 : {
   $0 = 79.79;
   break fake_return_waka123;
  };
  return +$0;
 }
 
 function $60() {
  var $2_1 = 0;
  fake_return_waka123 : {
   dummy();
   $2_1 = 77;
   break fake_return_waka123;
  };
  return $2_1 | 0;
 }
 
 function $61($0) {
  $0 = $0 | 0;
 }
 
 function $62($0) {
  $0 = $0 | 0;
  var $2_1 = 0;
  fake_return_waka123 : {
   $2_1 = 50;
   if ($0) break fake_return_waka123;
   $2_1 = 51;
  };
  return $2_1 | 0;
 }
 
 function $63($0) {
  $0 = $0 | 0;
 }
 
 function $64($0) {
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
 
 function $65($0) {
  $0 = $0 | 0;
 }
 
 function $66($0) {
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
 
 function $67() {
  var $0 = 0;
  return $0 | 0;
 }
 
 function $68() {
  var i64toi32_i32$0 = 0, $0$hi = 0, $0 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return $0 | 0;
 }
 
 function $69() {
  var $0 = Math_fround(0);
  return Math_fround($0);
 }
 
 function $70() {
  var $0 = 0.0;
  return +$0;
 }
 
 function empty_sig_1() {
  
 }
 
 function complex_sig_1($0, $1_1, $1$hi, $2_1, $3, $3$hi, $4, $5_1, $5$hi, $6_1, $7_1) {
  $0 = +$0;
  $1_1 = $1_1 | 0;
  $1$hi = $1$hi | 0;
  $2_1 = +$2_1;
  $3 = $3 | 0;
  $3$hi = $3$hi | 0;
  $4 = +$4;
  $5_1 = $5_1 | 0;
  $5$hi = $5$hi | 0;
  $6_1 = Math_fround($6_1);
  $7_1 = $7_1 | 0;
 }
 
 function empty_sig_2() {
  
 }
 
 function complex_sig_2($0, $1_1, $1$hi, $2_1, $3, $3$hi, $4, $5_1, $5$hi, $6_1, $7_1) {
  $0 = +$0;
  $1_1 = $1_1 | 0;
  $1$hi = $1$hi | 0;
  $2_1 = +$2_1;
  $3 = $3 | 0;
  $3$hi = $3$hi | 0;
  $4 = +$4;
  $5_1 = $5_1 | 0;
  $5$hi = $5$hi | 0;
  $6_1 = Math_fround($6_1);
  $7_1 = $7_1 | 0;
 }
 
 function complex_sig_3($0, $1_1, $1$hi, $2_1, $3, $3$hi, $4, $5_1, $5$hi, $6_1, $7_1) {
  $0 = +$0;
  $1_1 = $1_1 | 0;
  $1$hi = $1$hi | 0;
  $2_1 = +$2_1;
  $3 = $3 | 0;
  $3$hi = $3$hi | 0;
  $4 = +$4;
  $5_1 = $5_1 | 0;
  $5$hi = $5$hi | 0;
  $6_1 = Math_fround($6_1);
  $7_1 = $7_1 | 0;
 }
 
 function $76() {
  var wasm2js_i32$0 = 0;
  wasm2js_i32$0 = 1;
  FUNCTION_TABLE_v[wasm2js_i32$0 & 7]();
  wasm2js_i32$0 = 4;
  FUNCTION_TABLE_v[wasm2js_i32$0 & 7]();
 }
 
 function $77() {
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$2 = 0, wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0, wasm2js_f64$1 = 0.0, wasm2js_i32$3 = 0, wasm2js_i32$4 = 0, wasm2js_f64$2 = 0.0, wasm2js_i32$5 = 0, wasm2js_i32$6 = 0, wasm2js_f32$0 = Math_fround(0), wasm2js_i32$7 = 0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$2 = 0;
  wasm2js_f64$0 = 0.0;
  wasm2js_i32$1 = 0;
  wasm2js_i32$2 = i64toi32_i32$0;
  wasm2js_f64$1 = 0.0;
  wasm2js_i32$3 = 0;
  wasm2js_i32$4 = i64toi32_i32$1;
  wasm2js_f64$2 = 0.0;
  wasm2js_i32$5 = 0;
  wasm2js_i32$6 = i64toi32_i32$2;
  wasm2js_f32$0 = Math_fround(0.0);
  wasm2js_i32$7 = 0;
  wasm2js_i32$0 = 0;
  FUNCTION_TABLE_vdiidiidiifi[wasm2js_i32$0 & 7](+wasm2js_f64$0, wasm2js_i32$1 | 0, wasm2js_i32$2 | 0, +wasm2js_f64$1, wasm2js_i32$3 | 0, wasm2js_i32$4 | 0, +wasm2js_f64$2, wasm2js_i32$5 | 0, wasm2js_i32$6 | 0, Math_fround(wasm2js_f32$0), wasm2js_i32$7 | 0);
  i64toi32_i32$2 = 0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$0 = 0;
  wasm2js_f64$2 = 0.0;
  wasm2js_i32$7 = 0;
  wasm2js_i32$6 = i64toi32_i32$2;
  wasm2js_f64$1 = 0.0;
  wasm2js_i32$5 = 0;
  wasm2js_i32$4 = i64toi32_i32$1;
  wasm2js_f64$0 = 0.0;
  wasm2js_i32$3 = 0;
  wasm2js_i32$2 = i64toi32_i32$0;
  wasm2js_f32$0 = Math_fround(0.0);
  wasm2js_i32$1 = 0;
  wasm2js_i32$0 = 2;
  FUNCTION_TABLE_vdiidiidiifi[wasm2js_i32$0 & 7](+wasm2js_f64$2, wasm2js_i32$7 | 0, wasm2js_i32$6 | 0, +wasm2js_f64$1, wasm2js_i32$5 | 0, wasm2js_i32$4 | 0, +wasm2js_f64$0, wasm2js_i32$3 | 0, wasm2js_i32$2 | 0, Math_fround(wasm2js_f32$0), wasm2js_i32$1 | 0);
  i64toi32_i32$0 = 0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$2 = 0;
  wasm2js_f64$0 = 0.0;
  wasm2js_i32$1 = 0;
  wasm2js_i32$2 = i64toi32_i32$0;
  wasm2js_f64$1 = 0.0;
  wasm2js_i32$3 = 0;
  wasm2js_i32$4 = i64toi32_i32$1;
  wasm2js_f64$2 = 0.0;
  wasm2js_i32$5 = 0;
  wasm2js_i32$6 = i64toi32_i32$2;
  wasm2js_f32$0 = Math_fround(0.0);
  wasm2js_i32$7 = 0;
  wasm2js_i32$0 = 3;
  FUNCTION_TABLE_vdiidiidiifi[wasm2js_i32$0 & 7](+wasm2js_f64$0, wasm2js_i32$1 | 0, wasm2js_i32$2 | 0, +wasm2js_f64$1, wasm2js_i32$3 | 0, wasm2js_i32$4 | 0, +wasm2js_f64$2, wasm2js_i32$5 | 0, wasm2js_i32$6 | 0, Math_fround(wasm2js_f32$0), wasm2js_i32$7 | 0);
 }
 
 function $78() {
  var wasm2js_i32$0 = 0;
  wasm2js_i32$0 = 1;
  FUNCTION_TABLE_v[wasm2js_i32$0 & 7]();
 }
 
 function $79() {
  var wasm2js_i32$0 = 0, wasm2js_f64$0 = 0.0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0, wasm2js_f64$1 = 0.0, wasm2js_i32$3 = 0, wasm2js_i32$4 = 0, wasm2js_f64$2 = 0.0, wasm2js_i32$5 = 0, wasm2js_i32$6 = 0, wasm2js_f32$0 = Math_fround(0), wasm2js_i32$7 = 0;
  wasm2js_f64$0 = 0.0;
  wasm2js_i32$1 = 0;
  wasm2js_i32$2 = 0;
  wasm2js_f64$1 = 0.0;
  wasm2js_i32$3 = 0;
  wasm2js_i32$4 = 0;
  wasm2js_f64$2 = 0.0;
  wasm2js_i32$5 = 0;
  wasm2js_i32$6 = 0;
  wasm2js_f32$0 = Math_fround(0.0);
  wasm2js_i32$7 = 0;
  wasm2js_i32$0 = 0;
  FUNCTION_TABLE_vdiidiidiifi[wasm2js_i32$0 & 7](+wasm2js_f64$0, wasm2js_i32$1 | 0, wasm2js_i32$2 | 0, +wasm2js_f64$1, wasm2js_i32$3 | 0, wasm2js_i32$4 | 0, +wasm2js_f64$2, wasm2js_i32$5 | 0, wasm2js_i32$6 | 0, Math_fround(wasm2js_f32$0), wasm2js_i32$7 | 0);
 }
 
 var FUNCTION_TABLE_v = [empty_sig_2, empty_sig_2, empty_sig_2, empty_sig_2, empty_sig_1, empty_sig_2, empty_sig_2, empty_sig_2];
 var FUNCTION_TABLE_vdiidiidiifi = [complex_sig_3, complex_sig_3, complex_sig_1, complex_sig_3, complex_sig_3, complex_sig_3, complex_sig_3, complex_sig_3];
 return {
  f: $2, 
  g: h, 
  local_first_i32: $23, 
  local_first_i64: $24, 
  local_first_f32: $25, 
  local_first_f64: $26, 
  local_second_i32: $27, 
  local_second_i64: $28, 
  local_second_f32: $29, 
  local_second_f64: $30, 
  local_mixed: $31, 
  param_first_i32: $32, 
  param_first_i64: $33, 
  param_first_f32: $34, 
  param_first_f64: $35, 
  param_second_i32: $36, 
  param_second_i64: $37, 
  param_second_f32: $38, 
  param_second_f64: $39, 
  param_mixed: $40, 
  empty: $41, 
  value_void: $42, 
  value_i32: $43, 
  value_i64: $44, 
  value_f32: $45, 
  value_f64: $46, 
  value_block_void: $47, 
  value_block_i32: $48, 
  return_empty: $49, 
  return_i32: $50, 
  return_i64: $51, 
  return_f32: $52, 
  return_f64: $53, 
  return_block_i32: $54, 
  break_empty: $55, 
  break_i32: $56, 
  break_i64: $57, 
  break_f32: $58, 
  break_f64: $59, 
  break_block_i32: $60, 
  break_br_if_empty: $61, 
  break_br_if_num: $62, 
  break_br_table_empty: $63, 
  break_br_table_num: $64, 
  break_br_table_nested_empty: $65, 
  break_br_table_nested_num: $66, 
  init_local_i32: $67, 
  init_local_i64: $68, 
  init_local_f32: $69, 
  init_local_f64: $70, 
  signature_explicit_reused: $76, 
  signature_implicit_reused: $77, 
  signature_explicit_duplicate: $78, 
  signature_implicit_duplicate: $79
 };
}

const memasmFunc = new ArrayBuffer(65536);
const retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export const f = retasmFunc.f;
export const g = retasmFunc.g;
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
export const signature_explicit_reused = retasmFunc.signature_explicit_reused;
export const signature_implicit_reused = retasmFunc.signature_implicit_reused;
export const signature_explicit_duplicate = retasmFunc.signature_explicit_duplicate;
export const signature_implicit_duplicate = retasmFunc.signature_implicit_duplicate;
