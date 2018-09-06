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
 var i64toi32_i32$HIGH_BITS = 0;
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
  };
  block1 : {
   dummy();
   dummy();
   dummy();
  };
  return 8 | 0;
 }
 
 function $4() {
  block : {
   dummy();
   dummy();
  };
  return 9 | 0;
 }
 
 function $5() {
  dummy();
  return 150 | 0;
 }
 
 function $6() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0;
  return (wasm2js_i32$0 = 1, wasm2js_i32$1 = 2, wasm2js_i32$2 = 3, wasm2js_i32$2 ? wasm2js_i32$0 : wasm2js_i32$1) | 0;
 }
 
 function $7() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0;
  return (wasm2js_i32$0 = 2, wasm2js_i32$1 = 1, wasm2js_i32$2 = 3, wasm2js_i32$2 ? wasm2js_i32$0 : wasm2js_i32$1) | 0;
 }
 
 function $8() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0;
  return (wasm2js_i32$0 = 2, wasm2js_i32$1 = 3, wasm2js_i32$2 = 1, wasm2js_i32$2 ? wasm2js_i32$0 : wasm2js_i32$1) | 0;
 }
 
 function $9() {
  var $4_1 = 0;
  loop_in : do {
   dummy();
   dummy();
   $4_1 = 1;
   break loop_in;
  } while (1);
  return $4_1 | 0;
 }
 
 function $10() {
  var $6_1 = 0;
  $6_1 = 1;
  return $6_1 | 0;
 }
 
 function $11() {
  var $6_1 = 0;
  $6_1 = 2;
  return $6_1 | 0;
 }
 
 function $12() {
  var $2_1 = 0;
  block : {
   $2_1 = 1;
   if (2) break block;
   $2_1 = $2_1;
  };
  return $2_1 | 0;
 }
 
 function $13() {
  var $2_1 = 0;
  block : {
   $2_1 = 2;
   if (1) break block;
   $2_1 = $2_1;
  };
  return $2_1 | 0;
 }
 
 function func($0, $1_1) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  return $0 | 0;
 }
 
 function $15() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0, wasm2js_i32$3 = 0;
  wasm2js_i32$2 = 1;
  wasm2js_i32$3 = 2;
  wasm2js_i32$1 = 0;
  wasm2js_i32$0 = FUNCTION_TABLE_iii[wasm2js_i32$1 & 0](wasm2js_i32$2 | 0, wasm2js_i32$3 | 0) | 0;
  return wasm2js_i32$0 | 0;
 }
 
 function $16() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0, wasm2js_i32$3 = 0;
  wasm2js_i32$2 = 2;
  wasm2js_i32$3 = 1;
  wasm2js_i32$1 = 0;
  wasm2js_i32$0 = FUNCTION_TABLE_iii[wasm2js_i32$1 & 0](wasm2js_i32$2 | 0, wasm2js_i32$3 | 0) | 0;
  return wasm2js_i32$0 | 0;
 }
 
 function $17() {
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0, wasm2js_i32$3 = 0;
  wasm2js_i32$2 = 1;
  wasm2js_i32$3 = 2;
  wasm2js_i32$1 = 0;
  wasm2js_i32$0 = FUNCTION_TABLE_iii[wasm2js_i32$1 & 0](wasm2js_i32$2 | 0, wasm2js_i32$3 | 0) | 0;
  return wasm2js_i32$0 | 0;
 }
 
 function $18() {
  return __wasm_memory_grow(1 | 0) | 0;
 }
 
 function f($0) {
  $0 = $0 | 0;
  return $0 | 0;
 }
 
 function $20() {
  return f(1 | 0) | 0 | 0;
 }
 
 function $21() {
  
 }
 
 function $22() {
  var $2_1 = 0;
  block : {
   $2_1 = 1;
   break block;
  };
  return $2_1 | 0;
 }
 
 function $23() {
  return 1 | 0;
 }
 
 function $24() {
  dummy();
  return __wasm_ctz_i32(13 | 0) | 0 | 0;
 }
 
 function $25() {
  dummy();
  dummy();
  return Math_imul(3, 4) | 0;
 }
 
 function $26() {
  dummy();
  return (13 | 0) == (0 | 0) | 0;
 }
 
 function $27() {
  dummy();
  dummy();
  return Math_fround(3.0) > Math_fround(3.0) | 0;
 }
 
 function $28() {
  block : {
   break block;
  };
  block50 : {
   if (1) break block50;
   abort();
  };
  block51 : {
   switch (0 | 0) {
   default:
    break block51;
   };
  };
  block52 : {
   switch (1 | 0) {
   case 0:
    break block52;
   case 1:
    break block52;
   default:
    break block52;
   };
  };
  return 19 | 0;
 }
 
 function $29() {
  var $0 = 0;
  block : {
   $0 = 18;
   break block;
  };
  return $0 | 0;
 }
 
 function $30() {
  var $0 = 0;
  block : {
   $0 = 18;
   break block;
  };
  return $0 | 0;
 }
 
 function $31() {
  var $0 = 0, $1_1 = 0, $2_1 = 0, $5_1 = 0, $9_1 = 0, $10_1 = 0, $13_1 = 0, $14 = 0;
  $0 = 0;
  $1_1 = $0;
  block : {
   block53 : {
    $2_1 = 1;
    break block;
   };
  };
  $0 = $1_1 + $2_1 | 0;
  $5_1 = $0;
  $0 = $5_1 + 2 | 0;
  $9_1 = $0;
  block56 : {
   $10_1 = 4;
   break block56;
  };
  $0 = $9_1 + $10_1 | 0;
  $13_1 = $0;
  block57 : {
   block58 : {
    $14 = 8;
    break block57;
   };
  };
  $0 = $13_1 + $14 | 0;
  return $0 | 0;
 }
 
 function $32() {
  var $0 = 0;
  block : {
   $0 = 1;
   $0 = Math_imul($0, 3);
   $0 = $0 - 5 | 0;
   $0 = Math_imul($0, 7);
   break block;
  };
  return ($0 | 0) == (4294967282 | 0) | 0;
 }
 
 function __wasm_ctz_i32(var$0) {
  var$0 = var$0 | 0;
  if (var$0) return 31 - Math_clz32((var$0 + 4294967295 | 0) ^ var$0 | 0) | 0 | 0;
  return 32 | 0;
 }
 
 var FUNCTION_TABLE_iii = [func];
 function __wasm_memory_grow(pagesToAdd) {
  pagesToAdd = pagesToAdd | 0;
  var oldPages = __wasm_memory_size() | 0;
  var newPages = oldPages + pagesToAdd | 0;
  if ((oldPages < newPages) && (newPages < 65535)) {
   var newBuffer = new ArrayBuffer(Math_imul(newPages, 65536));
   var newHEAP8 = new global.Int8Array(newBuffer);
   newHEAP8.set(HEAP8);
   HEAP8 = newHEAP8;
   HEAP16 = new global.Int16Array(newBuffer);
   HEAP32 = new global.Int32Array(newBuffer);
   HEAPU8 = new global.Uint8Array(newBuffer);
   HEAPU16 = new global.Uint16Array(newBuffer);
   HEAPU32 = new global.Uint32Array(newBuffer);
   HEAPF32 = new global.Float32Array(newBuffer);
   HEAPF64 = new global.Float64Array(newBuffer);
   buffer = newBuffer;
  }
  return oldPages;
 }
 
 function __wasm_memory_size() {
  return buffer.byteLength / 65536 | 0;
 }
 
 return {
  empty: $1, 
  singular: $2, 
  multi: $3, 
  nested: $4, 
  deep: $5, 
  as_select_first: $6, 
  as_select_mid: $7, 
  as_select_last: $8, 
  as_loop_last: $9, 
  as_if_then: $10, 
  as_if_else: $11, 
  as_br_if_first: $12, 
  as_br_if_last: $13, 
  as_call_indirect_first: $15, 
  as_call_indirect_mid: $16, 
  as_call_indirect_last: $17, 
  as_memory_grow_value: $18, 
  as_call_value: $20, 
  as_drop_operand: $21, 
  as_br_value: $22, 
  as_set_local_value: $23, 
  as_unary_operand: $24, 
  as_binary_operand: $25, 
  as_test_operand: $26, 
  as_compare_operand: $27, 
  break_bare: $28, 
  break_value: $29, 
  break_repeated: $30, 
  break_inner: $31, 
  effects: $32
 };
}

const memasmFunc = new ArrayBuffer(65536);
const retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export const empty = retasmFunc.empty;
export const singular = retasmFunc.singular;
export const multi = retasmFunc.multi;
export const nested = retasmFunc.nested;
export const deep = retasmFunc.deep;
export const as_select_first = retasmFunc.as_select_first;
export const as_select_mid = retasmFunc.as_select_mid;
export const as_select_last = retasmFunc.as_select_last;
export const as_loop_last = retasmFunc.as_loop_last;
export const as_if_then = retasmFunc.as_if_then;
export const as_if_else = retasmFunc.as_if_else;
export const as_br_if_first = retasmFunc.as_br_if_first;
export const as_br_if_last = retasmFunc.as_br_if_last;
export const as_call_indirect_first = retasmFunc.as_call_indirect_first;
export const as_call_indirect_mid = retasmFunc.as_call_indirect_mid;
export const as_call_indirect_last = retasmFunc.as_call_indirect_last;
export const as_memory_grow_value = retasmFunc.as_memory_grow_value;
export const as_call_value = retasmFunc.as_call_value;
export const as_drop_operand = retasmFunc.as_drop_operand;
export const as_br_value = retasmFunc.as_br_value;
export const as_set_local_value = retasmFunc.as_set_local_value;
export const as_unary_operand = retasmFunc.as_unary_operand;
export const as_binary_operand = retasmFunc.as_binary_operand;
export const as_test_operand = retasmFunc.as_test_operand;
export const as_compare_operand = retasmFunc.as_compare_operand;
export const break_bare = retasmFunc.break_bare;
export const break_value = retasmFunc.break_value;
export const break_repeated = retasmFunc.break_repeated;
export const break_inner = retasmFunc.break_inner;
export const effects = retasmFunc.effects;
