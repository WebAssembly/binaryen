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
 var f64_to_int = env.f64_to_int;
 var f64_rem = env.f64_rem;
 function big_negative() {
  var temp = 0.0;
  temp = -2147483648.0;
  temp = -2147483648.0;
  temp = -21474836480.0;
  temp = .039625;
  temp = -.039625;
 }
 
 function importedDoubles() {
  var temp = 0.0, wasm2asm_f64$0 = 0.0;
  topmost : {
   temp = +(+(+(+HEAPF64[8 >> 3] + +HEAPF64[16 >> 3]) + -+HEAPF64[16 >> 3]) + -+HEAPF64[8 >> 3]);
   if ((HEAPU32[24 >> 2] | 0 | 0) > (0 | 0)) {
    wasm2asm_f64$0 = -3.4;
    break topmost;
   }
   if (+HEAPF64[32 >> 3] > 0.0) {
    wasm2asm_f64$0 = 5.6;
    break topmost;
   }
   wasm2asm_f64$0 = 1.2;
  }
  return +wasm2asm_f64$0;
 }
 
 function doubleCompares(x, y) {
  x = +x;
  y = +y;
  var t = 0.0, Int = 0.0, Double = 0, wasm2asm_f64$0 = 0.0;
  topmost : {
   if (x > 0.0) {
    wasm2asm_f64$0 = 1.2;
    break topmost;
   }
   if (Int > 0.0) {
    wasm2asm_f64$0 = -3.4;
    break topmost;
   }
   if ((Double | 0) > (0 | 0)) {
    wasm2asm_f64$0 = 5.6;
    break topmost;
   }
   if (x < y) {
    wasm2asm_f64$0 = x;
    break topmost;
   }
   wasm2asm_f64$0 = y;
  }
  return +wasm2asm_f64$0;
 }
 
 function intOps() {
  var x = 0;
  return (x | 0) == (0 | 0) | 0;
 }
 
 function conversions() {
  var i = 0, d = 0.0;
  i = f64_to_int(+d) | 0;
  d = +(i | 0);
  d = +((i >>> 0 | 0) >>> 0);
 }
 
 function seq() {
  var J = 0.0, wasm2asm_f64$2 = 0.0, wasm2asm_f64$1 = 0.0, wasm2asm_f64$0 = 0.0;
  .1;
  wasm2asm_f64$1 = 5.1;
  3.2;
  wasm2asm_f64$2 = 4.2;
  wasm2asm_f64$0 = +(wasm2asm_f64$1 - wasm2asm_f64$2);
  J = wasm2asm_f64$0;
 }
 
 function switcher(x) {
  x = x | 0;
  var wasm2asm_i32$0 = 0;
  topmost : {
   switch$0 : {
    switch (x - 1 | 0) {
    case 0:
     wasm2asm_i32$0 = 1;
     break topmost;
    case 1:
     wasm2asm_i32$0 = 2;
     break topmost;
    default:
    }
   }
   switch$4 : {
    switch (x - 5 | 0) {
    case 7:
     wasm2asm_i32$0 = 121;
     break topmost;
    case 0:
     wasm2asm_i32$0 = 51;
     break topmost;
    case 1:
    case 2:
    case 3:
    case 4:
    case 5:
    case 6:
    default:
    }
   }
   label$break$Lout : {
    switch (x - 2 | 0) {
    case 10:
     break label$break$Lout;
    case 8:
     break label$break$Lout;
    case 3:
     while_out$10 : do {
      break while_out$10;
      continue while_out$10;
     } while (0);
     break label$break$Lout;
    case 0:
     while_out$13 : do {
      break label$break$Lout;
      continue while_out$13;
     } while (0);
     break label$break$Lout;
    case 1:
    case 2:
    case 4:
    case 5:
    case 6:
    case 7:
    case 9:
    default:
    }
   }
   wasm2asm_i32$0 = 0;
  }
  return wasm2asm_i32$0 | 0;
 }
 
 function blocker() {
  label$break$L : {
   break label$break$L;
  }
 }
 
 function frem() {
  return +(+f64_rem(+(5.5), +(1.2)));
 }
 
 function big_uint_div_u() {
  var x = 0, wasm2asm_i32$0 = 0;
  topmost : {
   x = (4294967295 / 2 | 0) & 4294967295 | 0;
   wasm2asm_i32$0 = x;
  }
  return wasm2asm_i32$0 | 0;
 }
 
 function fr(x) {
  x = Math_fround(x);
  var y = Math_fround(0), z = 0.0;
  Math_fround(z);
  y;
  Math_fround(5.0);
  Math_fround(0.0);
  Math_fround(5.0);
  Math_fround(0.0);
 }
 
 function negZero() {
  return +(-0.0);
 }
 
 function abs() {
  var x = 0, y = 0.0, z = Math_fround(0), asm2wasm_i32_temp = 0, wasm2asm_i32$3 = 0, wasm2asm_i32$2 = 0, wasm2asm_i32$1 = 0, wasm2asm_i32$0 = 0;
  asm2wasm_i32_temp = 0;
  wasm2asm_i32$0 = (wasm2asm_i32$1 = (asm2wasm_i32_temp | 0) < (0 | 0), wasm2asm_i32$2 = 0 - asm2wasm_i32_temp | 0, wasm2asm_i32$3 = asm2wasm_i32_temp, wasm2asm_i32$1 ? wasm2asm_i32$2 : wasm2asm_i32$3);
  x = wasm2asm_i32$0;
  y = Math_abs(0.0);
  z = Math_fround(Math_abs(Math_fround(0.0)));
 }
 
 function neg() {
  var x = Math_fround(0);
  x = Math_fround(-x);
  FUNCTION_TABLE_vf[((1 & 7 | 0) + 8 | 0) & 15](Math_fround(x));
 }
 
 function ___syscall_ret() {
  var $0 = 0;
  ($0 >>> 0 | 0) >>> 0 > 4294963200 >>> 0
 }
 
 function z() {
  
 }
 
 function w() {
  
 }
 
 var FUNCTION_TABLE_d = [importedDoubles, importedDoubles, importedDoubles, importedDoubles, importedDoubles, importedDoubles, importedDoubles, importedDoubles, importedDoubles, importedDoubles, importedDoubles, importedDoubles, importedDoubles, importedDoubles, importedDoubles, importedDoubles];
 var FUNCTION_TABLE_v = [z, big_negative, z, z, w, w, z, w, z, neg, z, z, z, z, z, z];
 return {
  big_negative: big_negative
 };
}

