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
 function f0() {
  var $0 = 0;
  return $0 | 0;
 }
 
 function f1() {
  var i64toi32_i32$0 = 0, $0$hi = 0, $0 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return $0 | 0;
 }
 
 function f2() {
  var $0 = Math_fround(0);
  return Math_fround($0);
 }
 
 function f3() {
  var $0 = 0.0;
  return +$0;
 }
 
 function f4($0) {
  $0 = $0 | 0;
  return $0 | 0;
 }
 
 function f5($0, $0$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return $0 | 0;
 }
 
 function f6($0) {
  $0 = Math_fround($0);
  return Math_fround($0);
 }
 
 function f7($0) {
  $0 = +$0;
  return +$0;
 }
 
 function f8($0, $0$hi, $1, $2, $3, $4) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  $1 = Math_fround($1);
  $2 = +$2;
  $3 = $3 | 0;
  $4 = $4 | 0;
  var i64toi32_i32$0 = 0, $5 = Math_fround(0), $6$hi = 0, $6 = 0, $7$hi = 0, $7 = 0, $8 = 0.0;
 }
 
 function f9($0, $0$hi, $1, $2, $3, $4) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  $1 = Math_fround($1);
  $2 = +$2;
  $3 = $3 | 0;
  $4 = $4 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, $6$hi = 0, $10 = 0.0, $21 = 0.0, $7$hi = 0, $7 = 0;
  i64toi32_i32$0 = 0;
  $6$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $0$hi;
  i64toi32_i32$1 = $0;
  $10 = +(i64toi32_i32$1 >>> 0) + 4294967296.0 * +(i64toi32_i32$0 >>> 0);
  i64toi32_i32$0 = $6$hi;
  i64toi32_i32$1 = 6;
  $21 = +(i64toi32_i32$1 >>> 0) + 4294967296.0 * +(i64toi32_i32$0 >>> 0);
  i64toi32_i32$0 = $7$hi;
  i64toi32_i32$1 = $7;
  return +($10 + (+$1 + ($2 + (+($3 >>> 0) + (+($4 | 0) + (+Math_fround(5.5) + ($21 + (+(i64toi32_i32$1 >>> 0) + 4294967296.0 * +(i64toi32_i32$0 >>> 0) + 8.0))))))));
 }
 
 function legalstub$f1() {
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $7 = 0, $0 = 0, $0$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = f1() | 0;
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
 
 function legalstub$f5($0, $1) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $12 = 0, $13 = 0, $4 = 0, $4$hi = 0, $7$hi = 0, $2 = 0, $2$hi = 0;
  i64toi32_i32$0 = 0;
  $4 = $0;
  $4$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $12 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $12 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $7$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $4$hi;
  i64toi32_i32$0 = $4;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$3 = $12;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$2 = f5(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $2 = i64toi32_i32$2;
  $2$hi = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $13 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $13 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$1 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($13 | 0);
  i64toi32_i32$2 = $2$hi;
  return $2 | 0;
 }
 
 function legalstub$f8($0, $1, $2, $3, $4, $5) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2 = Math_fround($2);
  $3 = +$3;
  $4 = $4 | 0;
  $5 = $5 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $14 = 0, $7 = 0, $7$hi = 0, $10$hi = 0;
  i64toi32_i32$0 = 0;
  $7 = $0;
  $7$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $14 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $14 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $10$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $7$hi;
  i64toi32_i32$0 = $7;
  i64toi32_i32$2 = $10$hi;
  i64toi32_i32$3 = $14;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  f8(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0, Math_fround($2), +$3, $4 | 0, $5 | 0);
 }
 
 function legalstub$f9($0, $1, $2, $3, $4, $5) {
  $0 = $0 | 0;
  $1 = $1 | 0;
  $2 = Math_fround($2);
  $3 = +$3;
  $4 = $4 | 0;
  $5 = $5 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$3 = 0, $14 = 0, $7 = 0, $7$hi = 0, $10$hi = 0;
  i64toi32_i32$0 = 0;
  $7 = $0;
  $7$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $14 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $14 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $10$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $7$hi;
  i64toi32_i32$0 = $7;
  i64toi32_i32$2 = $10$hi;
  i64toi32_i32$3 = $14;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  return +(+f9(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0, Math_fround($2), +$3, $4 | 0, $5 | 0));
 }
 
 return {
  "type_local_i32": f0, 
  "type_local_i64": legalstub$f1, 
  "type_local_f32": f2, 
  "type_local_f64": f3, 
  "type_param_i32": f4, 
  "type_param_i64": legalstub$f5, 
  "type_param_f32": f6, 
  "type_param_f64": f7, 
  "type_mixed": legalstub$f8, 
  "read": legalstub$f9
 };
}

var retasmFunc = asmFunc({
  "env": env,
});
export var type_local_i32 = retasmFunc.type_local_i32;
export var type_local_i64 = retasmFunc.type_local_i64;
export var type_local_f32 = retasmFunc.type_local_f32;
export var type_local_f64 = retasmFunc.type_local_f64;
export var type_param_i32 = retasmFunc.type_param_i32;
export var type_param_i64 = retasmFunc.type_param_i64;
export var type_param_f32 = retasmFunc.type_param_f32;
export var type_param_f64 = retasmFunc.type_param_f64;
export var type_mixed = retasmFunc.type_mixed;
export var read = retasmFunc.read;
