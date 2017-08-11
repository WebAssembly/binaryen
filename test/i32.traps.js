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
 function $$0(x, y) {
  x = x | 0;
  y = y | 0;
  return x + y | 0 | 0;
 }
 
 function $$1(x, y) {
  x = x | 0;
  y = y | 0;
  return x - y | 0 | 0;
 }
 
 function $$2(x, y) {
  x = x | 0;
  y = y | 0;
  return Math_imul(x, y) | 0;
 }
 
 function $$3(x, y) {
  x = x | 0;
  y = y | 0;
  return (x | 0) / (y | 0) | 0 | 0;
 }
 
 function $$4(x, y) {
  x = x | 0;
  y = y | 0;
  return (x >>> 0) / (y >>> 0) | 0 | 0;
 }
 
 function $$5(x, y) {
  x = x | 0;
  y = y | 0;
  return (x | 0) % (y | 0) | 0 | 0;
 }
 
 function $$6(x, y) {
  x = x | 0;
  y = y | 0;
  return (x >>> 0) % (y >>> 0) | 0 | 0;
 }
 
 function $$7(x, y) {
  x = x | 0;
  y = y | 0;
  return x & y | 0 | 0;
 }
 
 function $$8(x, y) {
  x = x | 0;
  y = y | 0;
  return x | y | 0 | 0;
 }
 
 function $$9(x, y) {
  x = x | 0;
  y = y | 0;
  return x ^ y | 0 | 0;
 }
 
 function $$10(x, y) {
  x = x | 0;
  y = y | 0;
  return x << y | 0 | 0;
 }
 
 function $$11(x, y) {
  x = x | 0;
  y = y | 0;
  return x >> y | 0 | 0;
 }
 
 function $$12(x, y) {
  x = x | 0;
  y = y | 0;
  return x >>> y | 0 | 0;
 }
 
 function $$13(x, y) {
  x = x | 0;
  y = y | 0;
  return __wasm_rotl_i32(x, y) | 0;
 }
 
 function $$14(x, y) {
  x = x | 0;
  y = y | 0;
  return __wasm_rotr_i32(x, y) | 0;
 }
 
 function $$15(x) {
  x = x | 0;
  return Math_clz32(x) | 0;
 }
 
 function $$16(x) {
  x = x | 0;
  return __wasm_ctz_i32(x) | 0;
 }
 
 function $$17(x) {
  x = x | 0;
  return __wasm_popcnt_i32(x) | 0;
 }
 
 function $$18(x) {
  x = x | 0;
  return (x | 0) == (0 | 0) | 0;
 }
 
 function $$19(x, y) {
  x = x | 0;
  y = y | 0;
  return (x | 0) == (y | 0) | 0;
 }
 
 function $$20(x, y) {
  x = x | 0;
  y = y | 0;
  return (x | 0) != (y | 0) | 0;
 }
 
 function $$21(x, y) {
  x = x | 0;
  y = y | 0;
  return (x | 0) < (y | 0) | 0;
 }
 
 function $$22(x, y) {
  x = x | 0;
  y = y | 0;
  return x >>> 0 < y >>> 0 | 0;
 }
 
 function $$23(x, y) {
  x = x | 0;
  y = y | 0;
  return (x | 0) <= (y | 0) | 0;
 }
 
 function $$24(x, y) {
  x = x | 0;
  y = y | 0;
  return x >>> 0 <= y >>> 0 | 0;
 }
 
 function $$25(x, y) {
  x = x | 0;
  y = y | 0;
  return (x | 0) > (y | 0) | 0;
 }
 
 function $$26(x, y) {
  x = x | 0;
  y = y | 0;
  return x >>> 0 > y >>> 0 | 0;
 }
 
 function $$27(x, y) {
  x = x | 0;
  y = y | 0;
  return (x | 0) >= (y | 0) | 0;
 }
 
 function $$28(x, y) {
  x = x | 0;
  y = y | 0;
  return x >>> 0 >= y >>> 0 | 0;
 }
 
 function __wasm_ctz_i32(x) {
  x = x | 0;
  var wasm2asm_i32$0 = 0;
  if ((x | 0) == (0 | 0)) wasm2asm_i32$0 = 32; else wasm2asm_i32$0 = 31 - Math_clz32(x ^ (x - 1 | 0) | 0) | 0;
  return wasm2asm_i32$0 | 0;
 }
 
 function __wasm_popcnt_i32(x) {
  x = x | 0;
  var count = 0, wasm2asm_i32$0 = 0;
  count = 0;
  b : {
   l : do {
    if ((x | 0) == (0 | 0)) {
     wasm2asm_i32$0 = count;
     break b;
    }
    x = x & (x - 1 | 0) | 0;
    count = count + 1 | 0;
    continue l;
    break l;
   } while (1);
  };
  return wasm2asm_i32$0 | 0;
 }
 
 function __wasm_rotl_i32(x, k) {
  x = x | 0;
  k = k | 0;
  return ((4294967295 >>> (k & 31 | 0) | 0) & x | 0) << (k & 31 | 0) | 0 | (((4294967295 << (32 - (k & 31 | 0) | 0) | 0) & x | 0) >>> (32 - (k & 31 | 0) | 0) | 0) | 0 | 0;
 }
 
 function __wasm_rotr_i32(x, k) {
  x = x | 0;
  k = k | 0;
  return ((4294967295 << (k & 31 | 0) | 0) & x | 0) >>> (k & 31 | 0) | 0 | (((4294967295 >>> (32 - (k & 31 | 0) | 0) | 0) & x | 0) << (32 - (k & 31 | 0) | 0) | 0) | 0 | 0;
 }
 
 return {
  add: $$0, 
  sub: $$1, 
  mul: $$2, 
  div_s: $$3, 
  div_u: $$4, 
  rem_s: $$5, 
  rem_u: $$6, 
  and: $$7, 
  or: $$8, 
  xor: $$9, 
  shl: $$10, 
  shr_s: $$11, 
  shr_u: $$12, 
  rotl: $$13, 
  rotr: $$14, 
  clz: $$15, 
  ctz: $$16, 
  popcnt: $$17, 
  eqz: $$18, 
  eq: $$19, 
  ne: $$20, 
  lt_s: $$21, 
  lt_u: $$22, 
  le_s: $$23, 
  le_u: $$24, 
  gt_s: $$25, 
  gt_u: $$26, 
  ge_s: $$27, 
  ge_u: $$28
 };
}

var asmModule = asmFunc({
 Math: Math, 
 Int8Array: Int8Array, 
 Int16Array: Int16Array, 
 Int32Array: Int32Array, 
 Uint8Array: Uint8Array, 
 Uint16Array: Uint16Array, 
 Uint32Array: Uint32Array, 
 Float32Array: Float32Array, 
 Float64Array: Float64Array
}, {
 
}, new ArrayBuffer(65536));
function check1() {
 return (asmModule.add(1 | 0, 1 | 0) | 0 | 0) == (2 | 0) | 0;
}

if (!check1()) fail1();
function check2() {
 return (asmModule.add(1 | 0, 0 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check2()) fail2();
function check3() {
 return (asmModule.add(4294967295 | 0, 4294967295 | 0) | 0 | 0) == (4294967294 | 0) | 0;
}

if (!check3()) fail3();
function check4() {
 return (asmModule.add(4294967295 | 0, 1 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check4()) fail4();
function check5() {
 return (asmModule.add(2147483647 | 0, 1 | 0) | 0 | 0) == (2147483648 | 0) | 0;
}

if (!check5()) fail5();
function check6() {
 return (asmModule.add(2147483648 | 0, 4294967295 | 0) | 0 | 0) == (2147483647 | 0) | 0;
}

if (!check6()) fail6();
function check7() {
 return (asmModule.add(2147483648 | 0, 2147483648 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check7()) fail7();
function check8() {
 return (asmModule.add(1073741823 | 0, 1 | 0) | 0 | 0) == (1073741824 | 0) | 0;
}

if (!check8()) fail8();
function check9() {
 return (asmModule.sub(1 | 0, 1 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check9()) fail9();
function check10() {
 return (asmModule.sub(1 | 0, 0 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check10()) fail10();
function check11() {
 return (asmModule.sub(4294967295 | 0, 4294967295 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check11()) fail11();
function check12() {
 return (asmModule.sub(2147483647 | 0, 4294967295 | 0) | 0 | 0) == (2147483648 | 0) | 0;
}

if (!check12()) fail12();
function check13() {
 return (asmModule.sub(2147483648 | 0, 1 | 0) | 0 | 0) == (2147483647 | 0) | 0;
}

if (!check13()) fail13();
function check14() {
 return (asmModule.sub(2147483648 | 0, 2147483648 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check14()) fail14();
function check15() {
 return (asmModule.sub(1073741823 | 0, 4294967295 | 0) | 0 | 0) == (1073741824 | 0) | 0;
}

if (!check15()) fail15();
function check16() {
 return (asmModule.mul(1 | 0, 1 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check16()) fail16();
function check17() {
 return (asmModule.mul(1 | 0, 0 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check17()) fail17();
function check18() {
 return (asmModule.mul(4294967295 | 0, 4294967295 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check18()) fail18();
function check19() {
 return (asmModule.mul(268435456 | 0, 4096 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check19()) fail19();
function check20() {
 return (asmModule.mul(2147483648 | 0, 0 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check20()) fail20();
function check21() {
 return (asmModule.mul(2147483648 | 0, 4294967295 | 0) | 0 | 0) == (2147483648 | 0) | 0;
}

if (!check21()) fail21();
function check22() {
 return (asmModule.mul(2147483647 | 0, 4294967295 | 0) | 0 | 0) == (2147483649 | 0) | 0;
}

if (!check22()) fail22();
function check23() {
 return (asmModule.mul(19088743 | 0, 1985229328 | 0) | 0 | 0) == (898528368 | 0) | 0;
}

if (!check23()) fail23();
function check24() {
 function f() {
  div_s(1 | 0, 0 | 0);
 }
 
 try {
  f();
 } catch (e) {
  return e.message.includes("integer divide by zero");
 };
 return 0;
}

if (!check24()) fail24();
function check25() {
 function f() {
  div_s(0 | 0, 0 | 0);
 }
 
 try {
  f();
 } catch (e) {
  return e.message.includes("integer divide by zero");
 };
 return 0;
}

if (!check25()) fail25();
function check26() {
 function f() {
  div_s(2147483648 | 0, 4294967295 | 0);
 }
 
 try {
  f();
 } catch (e) {
  return e.message.includes("integer overflow");
 };
 return 0;
}

if (!check26()) fail26();
function check27() {
 return (asmModule.div_s(1 | 0, 1 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check27()) fail27();
function check28() {
 return (asmModule.div_s(0 | 0, 1 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check28()) fail28();
function check29() {
 return (asmModule.div_s(4294967295 | 0, 4294967295 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check29()) fail29();
function check30() {
 return (asmModule.div_s(2147483648 | 0, 2 | 0) | 0 | 0) == (3221225472 | 0) | 0;
}

if (!check30()) fail30();
function check31() {
 return (asmModule.div_s(2147483649 | 0, 1e3 | 0) | 0 | 0) == (4292819813 | 0) | 0;
}

if (!check31()) fail31();
function check32() {
 return (asmModule.div_s(5 | 0, 2 | 0) | 0 | 0) == (2 | 0) | 0;
}

if (!check32()) fail32();
function check33() {
 return (asmModule.div_s(4294967291 | 0, 2 | 0) | 0 | 0) == (4294967294 | 0) | 0;
}

if (!check33()) fail33();
function check34() {
 return (asmModule.div_s(5 | 0, 4294967294 | 0) | 0 | 0) == (4294967294 | 0) | 0;
}

if (!check34()) fail34();
function check35() {
 return (asmModule.div_s(4294967291 | 0, 4294967294 | 0) | 0 | 0) == (2 | 0) | 0;
}

if (!check35()) fail35();
function check36() {
 return (asmModule.div_s(7 | 0, 3 | 0) | 0 | 0) == (2 | 0) | 0;
}

if (!check36()) fail36();
function check37() {
 return (asmModule.div_s(4294967289 | 0, 3 | 0) | 0 | 0) == (4294967294 | 0) | 0;
}

if (!check37()) fail37();
function check38() {
 return (asmModule.div_s(7 | 0, 4294967293 | 0) | 0 | 0) == (4294967294 | 0) | 0;
}

if (!check38()) fail38();
function check39() {
 return (asmModule.div_s(4294967289 | 0, 4294967293 | 0) | 0 | 0) == (2 | 0) | 0;
}

if (!check39()) fail39();
function check40() {
 return (asmModule.div_s(11 | 0, 5 | 0) | 0 | 0) == (2 | 0) | 0;
}

if (!check40()) fail40();
function check41() {
 return (asmModule.div_s(17 | 0, 7 | 0) | 0 | 0) == (2 | 0) | 0;
}

if (!check41()) fail41();
function check42() {
 function f() {
  div_u(1 | 0, 0 | 0);
 }
 
 try {
  f();
 } catch (e) {
  return e.message.includes("integer divide by zero");
 };
 return 0;
}

if (!check42()) fail42();
function check43() {
 function f() {
  div_u(0 | 0, 0 | 0);
 }
 
 try {
  f();
 } catch (e) {
  return e.message.includes("integer divide by zero");
 };
 return 0;
}

if (!check43()) fail43();
function check44() {
 return (asmModule.div_u(1 | 0, 1 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check44()) fail44();
function check45() {
 return (asmModule.div_u(0 | 0, 1 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check45()) fail45();
function check46() {
 return (asmModule.div_u(4294967295 | 0, 4294967295 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check46()) fail46();
function check47() {
 return (asmModule.div_u(2147483648 | 0, 4294967295 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check47()) fail47();
function check48() {
 return (asmModule.div_u(2147483648 | 0, 2 | 0) | 0 | 0) == (1073741824 | 0) | 0;
}

if (!check48()) fail48();
function check49() {
 return (asmModule.div_u(2414874608 | 0, 65537 | 0) | 0 | 0) == (36847 | 0) | 0;
}

if (!check49()) fail49();
function check50() {
 return (asmModule.div_u(2147483649 | 0, 1e3 | 0) | 0 | 0) == (2147483 | 0) | 0;
}

if (!check50()) fail50();
function check51() {
 return (asmModule.div_u(5 | 0, 2 | 0) | 0 | 0) == (2 | 0) | 0;
}

if (!check51()) fail51();
function check52() {
 return (asmModule.div_u(4294967291 | 0, 2 | 0) | 0 | 0) == (2147483645 | 0) | 0;
}

if (!check52()) fail52();
function check53() {
 return (asmModule.div_u(5 | 0, 4294967294 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check53()) fail53();
function check54() {
 return (asmModule.div_u(4294967291 | 0, 4294967294 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check54()) fail54();
function check55() {
 return (asmModule.div_u(7 | 0, 3 | 0) | 0 | 0) == (2 | 0) | 0;
}

if (!check55()) fail55();
function check56() {
 return (asmModule.div_u(11 | 0, 5 | 0) | 0 | 0) == (2 | 0) | 0;
}

if (!check56()) fail56();
function check57() {
 return (asmModule.div_u(17 | 0, 7 | 0) | 0 | 0) == (2 | 0) | 0;
}

if (!check57()) fail57();
function check58() {
 function f() {
  rem_s(1 | 0, 0 | 0);
 }
 
 try {
  f();
 } catch (e) {
  return e.message.includes("integer divide by zero");
 };
 return 0;
}

if (!check58()) fail58();
function check59() {
 function f() {
  rem_s(0 | 0, 0 | 0);
 }
 
 try {
  f();
 } catch (e) {
  return e.message.includes("integer divide by zero");
 };
 return 0;
}

if (!check59()) fail59();
function check60() {
 return (asmModule.rem_s(2147483647 | 0, 4294967295 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check60()) fail60();
function check61() {
 return (asmModule.rem_s(1 | 0, 1 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check61()) fail61();
function check62() {
 return (asmModule.rem_s(0 | 0, 1 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check62()) fail62();
function check63() {
 return (asmModule.rem_s(4294967295 | 0, 4294967295 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check63()) fail63();
function check64() {
 return (asmModule.rem_s(2147483648 | 0, 4294967295 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check64()) fail64();
function check65() {
 return (asmModule.rem_s(2147483648 | 0, 2 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check65()) fail65();
function check66() {
 return (asmModule.rem_s(2147483649 | 0, 1e3 | 0) | 0 | 0) == (4294966649 | 0) | 0;
}

if (!check66()) fail66();
function check67() {
 return (asmModule.rem_s(5 | 0, 2 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check67()) fail67();
function check68() {
 return (asmModule.rem_s(4294967291 | 0, 2 | 0) | 0 | 0) == (4294967295 | 0) | 0;
}

if (!check68()) fail68();
function check69() {
 return (asmModule.rem_s(5 | 0, 4294967294 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check69()) fail69();
function check70() {
 return (asmModule.rem_s(4294967291 | 0, 4294967294 | 0) | 0 | 0) == (4294967295 | 0) | 0;
}

if (!check70()) fail70();
function check71() {
 return (asmModule.rem_s(7 | 0, 3 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check71()) fail71();
function check72() {
 return (asmModule.rem_s(4294967289 | 0, 3 | 0) | 0 | 0) == (4294967295 | 0) | 0;
}

if (!check72()) fail72();
function check73() {
 return (asmModule.rem_s(7 | 0, 4294967293 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check73()) fail73();
function check74() {
 return (asmModule.rem_s(4294967289 | 0, 4294967293 | 0) | 0 | 0) == (4294967295 | 0) | 0;
}

if (!check74()) fail74();
function check75() {
 return (asmModule.rem_s(11 | 0, 5 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check75()) fail75();
function check76() {
 return (asmModule.rem_s(17 | 0, 7 | 0) | 0 | 0) == (3 | 0) | 0;
}

if (!check76()) fail76();
function check77() {
 function f() {
  rem_u(1 | 0, 0 | 0);
 }
 
 try {
  f();
 } catch (e) {
  return e.message.includes("integer divide by zero");
 };
 return 0;
}

if (!check77()) fail77();
function check78() {
 function f() {
  rem_u(0 | 0, 0 | 0);
 }
 
 try {
  f();
 } catch (e) {
  return e.message.includes("integer divide by zero");
 };
 return 0;
}

if (!check78()) fail78();
function check79() {
 return (asmModule.rem_u(1 | 0, 1 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check79()) fail79();
function check80() {
 return (asmModule.rem_u(0 | 0, 1 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check80()) fail80();
function check81() {
 return (asmModule.rem_u(4294967295 | 0, 4294967295 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check81()) fail81();
function check82() {
 return (asmModule.rem_u(2147483648 | 0, 4294967295 | 0) | 0 | 0) == (2147483648 | 0) | 0;
}

if (!check82()) fail82();
function check83() {
 return (asmModule.rem_u(2147483648 | 0, 2 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check83()) fail83();
function check84() {
 return (asmModule.rem_u(2414874608 | 0, 65537 | 0) | 0 | 0) == (32769 | 0) | 0;
}

if (!check84()) fail84();
function check85() {
 return (asmModule.rem_u(2147483649 | 0, 1e3 | 0) | 0 | 0) == (649 | 0) | 0;
}

if (!check85()) fail85();
function check86() {
 return (asmModule.rem_u(5 | 0, 2 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check86()) fail86();
function check87() {
 return (asmModule.rem_u(4294967291 | 0, 2 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check87()) fail87();
function check88() {
 return (asmModule.rem_u(5 | 0, 4294967294 | 0) | 0 | 0) == (5 | 0) | 0;
}

if (!check88()) fail88();
function check89() {
 return (asmModule.rem_u(4294967291 | 0, 4294967294 | 0) | 0 | 0) == (4294967291 | 0) | 0;
}

if (!check89()) fail89();
function check90() {
 return (asmModule.rem_u(7 | 0, 3 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check90()) fail90();
function check91() {
 return (asmModule.rem_u(11 | 0, 5 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check91()) fail91();
function check92() {
 return (asmModule.rem_u(17 | 0, 7 | 0) | 0 | 0) == (3 | 0) | 0;
}

if (!check92()) fail92();
function check93() {
 return (asmModule.and(1 | 0, 0 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check93()) fail93();
function check94() {
 return (asmModule.and(0 | 0, 1 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check94()) fail94();
function check95() {
 return (asmModule.and(1 | 0, 1 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check95()) fail95();
function check96() {
 return (asmModule.and(0 | 0, 0 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check96()) fail96();
function check97() {
 return (asmModule.and(2147483647 | 0, 2147483648 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check97()) fail97();
function check98() {
 return (asmModule.and(2147483647 | 0, 4294967295 | 0) | 0 | 0) == (2147483647 | 0) | 0;
}

if (!check98()) fail98();
function check99() {
 return (asmModule.and(4042326015 | 0, 4294963440 | 0) | 0 | 0) == (4042322160 | 0) | 0;
}

if (!check99()) fail99();
function check100() {
 return (asmModule.and(4294967295 | 0, 4294967295 | 0) | 0 | 0) == (4294967295 | 0) | 0;
}

if (!check100()) fail100();
function check101() {
 return (asmModule.or(1 | 0, 0 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check101()) fail101();
function check102() {
 return (asmModule.or(0 | 0, 1 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check102()) fail102();
function check103() {
 return (asmModule.or(1 | 0, 1 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check103()) fail103();
function check104() {
 return (asmModule.or(0 | 0, 0 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check104()) fail104();
function check105() {
 return (asmModule.or(2147483647 | 0, 2147483648 | 0) | 0 | 0) == (4294967295 | 0) | 0;
}

if (!check105()) fail105();
function check106() {
 return (asmModule.or(2147483648 | 0, 0 | 0) | 0 | 0) == (2147483648 | 0) | 0;
}

if (!check106()) fail106();
function check107() {
 return (asmModule.or(4042326015 | 0, 4294963440 | 0) | 0 | 0) == (4294967295 | 0) | 0;
}

if (!check107()) fail107();
function check108() {
 return (asmModule.or(4294967295 | 0, 4294967295 | 0) | 0 | 0) == (4294967295 | 0) | 0;
}

if (!check108()) fail108();
function check109() {
 return (asmModule.xor(1 | 0, 0 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check109()) fail109();
function check110() {
 return (asmModule.xor(0 | 0, 1 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check110()) fail110();
function check111() {
 return (asmModule.xor(1 | 0, 1 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check111()) fail111();
function check112() {
 return (asmModule.xor(0 | 0, 0 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check112()) fail112();
function check113() {
 return (asmModule.xor(2147483647 | 0, 2147483648 | 0) | 0 | 0) == (4294967295 | 0) | 0;
}

if (!check113()) fail113();
function check114() {
 return (asmModule.xor(2147483648 | 0, 0 | 0) | 0 | 0) == (2147483648 | 0) | 0;
}

if (!check114()) fail114();
function check115() {
 return (asmModule.xor(4294967295 | 0, 2147483648 | 0) | 0 | 0) == (2147483647 | 0) | 0;
}

if (!check115()) fail115();
function check116() {
 return (asmModule.xor(4294967295 | 0, 2147483647 | 0) | 0 | 0) == (2147483648 | 0) | 0;
}

if (!check116()) fail116();
function check117() {
 return (asmModule.xor(4042326015 | 0, 4294963440 | 0) | 0 | 0) == (252645135 | 0) | 0;
}

if (!check117()) fail117();
function check118() {
 return (asmModule.xor(4294967295 | 0, 4294967295 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check118()) fail118();
function check119() {
 return (asmModule.shl(1 | 0, 1 | 0) | 0 | 0) == (2 | 0) | 0;
}

if (!check119()) fail119();
function check120() {
 return (asmModule.shl(1 | 0, 0 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check120()) fail120();
function check121() {
 return (asmModule.shl(2147483647 | 0, 1 | 0) | 0 | 0) == (4294967294 | 0) | 0;
}

if (!check121()) fail121();
function check122() {
 return (asmModule.shl(4294967295 | 0, 1 | 0) | 0 | 0) == (4294967294 | 0) | 0;
}

if (!check122()) fail122();
function check123() {
 return (asmModule.shl(2147483648 | 0, 1 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check123()) fail123();
function check124() {
 return (asmModule.shl(1073741824 | 0, 1 | 0) | 0 | 0) == (2147483648 | 0) | 0;
}

if (!check124()) fail124();
function check125() {
 return (asmModule.shl(1 | 0, 31 | 0) | 0 | 0) == (2147483648 | 0) | 0;
}

if (!check125()) fail125();
function check126() {
 return (asmModule.shl(1 | 0, 32 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check126()) fail126();
function check127() {
 return (asmModule.shl(1 | 0, 33 | 0) | 0 | 0) == (2 | 0) | 0;
}

if (!check127()) fail127();
function check128() {
 return (asmModule.shl(1 | 0, 4294967295 | 0) | 0 | 0) == (2147483648 | 0) | 0;
}

if (!check128()) fail128();
function check129() {
 return (asmModule.shl(1 | 0, 2147483647 | 0) | 0 | 0) == (2147483648 | 0) | 0;
}

if (!check129()) fail129();
function check130() {
 return (asmModule.shr_s(1 | 0, 1 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check130()) fail130();
function check131() {
 return (asmModule.shr_s(1 | 0, 0 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check131()) fail131();
function check132() {
 return (asmModule.shr_s(4294967295 | 0, 1 | 0) | 0 | 0) == (4294967295 | 0) | 0;
}

if (!check132()) fail132();
function check133() {
 return (asmModule.shr_s(2147483647 | 0, 1 | 0) | 0 | 0) == (1073741823 | 0) | 0;
}

if (!check133()) fail133();
function check134() {
 return (asmModule.shr_s(2147483648 | 0, 1 | 0) | 0 | 0) == (3221225472 | 0) | 0;
}

if (!check134()) fail134();
function check135() {
 return (asmModule.shr_s(1073741824 | 0, 1 | 0) | 0 | 0) == (536870912 | 0) | 0;
}

if (!check135()) fail135();
function check136() {
 return (asmModule.shr_s(1 | 0, 32 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check136()) fail136();
function check137() {
 return (asmModule.shr_s(1 | 0, 33 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check137()) fail137();
function check138() {
 return (asmModule.shr_s(1 | 0, 4294967295 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check138()) fail138();
function check139() {
 return (asmModule.shr_s(1 | 0, 2147483647 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check139()) fail139();
function check140() {
 return (asmModule.shr_s(1 | 0, 2147483648 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check140()) fail140();
function check141() {
 return (asmModule.shr_s(2147483648 | 0, 31 | 0) | 0 | 0) == (4294967295 | 0) | 0;
}

if (!check141()) fail141();
function check142() {
 return (asmModule.shr_s(4294967295 | 0, 32 | 0) | 0 | 0) == (4294967295 | 0) | 0;
}

if (!check142()) fail142();
function check143() {
 return (asmModule.shr_s(4294967295 | 0, 33 | 0) | 0 | 0) == (4294967295 | 0) | 0;
}

if (!check143()) fail143();
function check144() {
 return (asmModule.shr_s(4294967295 | 0, 4294967295 | 0) | 0 | 0) == (4294967295 | 0) | 0;
}

if (!check144()) fail144();
function check145() {
 return (asmModule.shr_s(4294967295 | 0, 2147483647 | 0) | 0 | 0) == (4294967295 | 0) | 0;
}

if (!check145()) fail145();
function check146() {
 return (asmModule.shr_s(4294967295 | 0, 2147483648 | 0) | 0 | 0) == (4294967295 | 0) | 0;
}

if (!check146()) fail146();
function check147() {
 return (asmModule.shr_u(1 | 0, 1 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check147()) fail147();
function check148() {
 return (asmModule.shr_u(1 | 0, 0 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check148()) fail148();
function check149() {
 return (asmModule.shr_u(4294967295 | 0, 1 | 0) | 0 | 0) == (2147483647 | 0) | 0;
}

if (!check149()) fail149();
function check150() {
 return (asmModule.shr_u(2147483647 | 0, 1 | 0) | 0 | 0) == (1073741823 | 0) | 0;
}

if (!check150()) fail150();
function check151() {
 return (asmModule.shr_u(2147483648 | 0, 1 | 0) | 0 | 0) == (1073741824 | 0) | 0;
}

if (!check151()) fail151();
function check152() {
 return (asmModule.shr_u(1073741824 | 0, 1 | 0) | 0 | 0) == (536870912 | 0) | 0;
}

if (!check152()) fail152();
function check153() {
 return (asmModule.shr_u(1 | 0, 32 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check153()) fail153();
function check154() {
 return (asmModule.shr_u(1 | 0, 33 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check154()) fail154();
function check155() {
 return (asmModule.shr_u(1 | 0, 4294967295 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check155()) fail155();
function check156() {
 return (asmModule.shr_u(1 | 0, 2147483647 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check156()) fail156();
function check157() {
 return (asmModule.shr_u(1 | 0, 2147483648 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check157()) fail157();
function check158() {
 return (asmModule.shr_u(2147483648 | 0, 31 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check158()) fail158();
function check159() {
 return (asmModule.shr_u(4294967295 | 0, 32 | 0) | 0 | 0) == (4294967295 | 0) | 0;
}

if (!check159()) fail159();
function check160() {
 return (asmModule.shr_u(4294967295 | 0, 33 | 0) | 0 | 0) == (2147483647 | 0) | 0;
}

if (!check160()) fail160();
function check161() {
 return (asmModule.shr_u(4294967295 | 0, 4294967295 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check161()) fail161();
function check162() {
 return (asmModule.shr_u(4294967295 | 0, 2147483647 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check162()) fail162();
function check163() {
 return (asmModule.shr_u(4294967295 | 0, 2147483648 | 0) | 0 | 0) == (4294967295 | 0) | 0;
}

if (!check163()) fail163();
function check164() {
 return (asmModule.rotl(4261469184 | 0, 4 | 0) | 0 | 0) == (3758997519 | 0) | 0;
}

if (!check164()) fail164();
function check165() {
 return (asmModule.rotl(2882377846 | 0, 1 | 0) | 0 | 0) == (1469788397 | 0) | 0;
}

if (!check165()) fail165();
function check166() {
 return (asmModule.rotl(32768 | 0, 37 | 0) | 0 | 0) == (1048576 | 0) | 0;
}

if (!check166()) fail166();
function check167() {
 return (asmModule.rotl(1989852383 | 0, 2147483661 | 0) | 0 | 0) == (1469837011 | 0) | 0;
}

if (!check167()) fail167();
function check168() {
 return (asmModule.rotl(1 | 0, 31 | 0) | 0 | 0) == (2147483648 | 0) | 0;
}

if (!check168()) fail168();
function check169() {
 return (asmModule.rotl(2147483648 | 0, 1 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check169()) fail169();
function check170() {
 return (asmModule.rotr(2965492451 | 0, 5 | 0) | 0 | 0) == (495324823 | 0) | 0;
}

if (!check170()) fail170();
function check171() {
 return (asmModule.rotr(2965492451 | 0, 65285 | 0) | 0 | 0) == (495324823 | 0) | 0;
}

if (!check171()) fail171();
function check172() {
 return (asmModule.rotr(4278242304 | 0, 1 | 0) | 0 | 0) == (2139121152 | 0) | 0;
}

if (!check172()) fail172();
function check173() {
 return (asmModule.rotr(524288 | 0, 4 | 0) | 0 | 0) == (32768 | 0) | 0;
}

if (!check173()) fail173();
function check174() {
 return (asmModule.rotr(1989852383 | 0, 4294967277 | 0) | 0 | 0) == (3875255509 | 0) | 0;
}

if (!check174()) fail174();
function check175() {
 return (asmModule.rotr(1 | 0, 1 | 0) | 0 | 0) == (2147483648 | 0) | 0;
}

if (!check175()) fail175();
function check176() {
 return (asmModule.rotr(2147483648 | 0, 31 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check176()) fail176();
function check177() {
 return (asmModule.clz(4294967295 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check177()) fail177();
function check178() {
 return (asmModule.clz(0 | 0) | 0 | 0) == (32 | 0) | 0;
}

if (!check178()) fail178();
function check179() {
 return (asmModule.clz(32768 | 0) | 0 | 0) == (16 | 0) | 0;
}

if (!check179()) fail179();
function check180() {
 return (asmModule.clz(255 | 0) | 0 | 0) == (24 | 0) | 0;
}

if (!check180()) fail180();
function check181() {
 return (asmModule.clz(2147483648 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check181()) fail181();
function check182() {
 return (asmModule.clz(1 | 0) | 0 | 0) == (31 | 0) | 0;
}

if (!check182()) fail182();
function check183() {
 return (asmModule.clz(2 | 0) | 0 | 0) == (30 | 0) | 0;
}

if (!check183()) fail183();
function check184() {
 return (asmModule.clz(2147483647 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check184()) fail184();
function check185() {
 return (asmModule.ctz(4294967295 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check185()) fail185();
function check186() {
 return (asmModule.ctz(0 | 0) | 0 | 0) == (32 | 0) | 0;
}

if (!check186()) fail186();
function check187() {
 return (asmModule.ctz(32768 | 0) | 0 | 0) == (15 | 0) | 0;
}

if (!check187()) fail187();
function check188() {
 return (asmModule.ctz(65536 | 0) | 0 | 0) == (16 | 0) | 0;
}

if (!check188()) fail188();
function check189() {
 return (asmModule.ctz(2147483648 | 0) | 0 | 0) == (31 | 0) | 0;
}

if (!check189()) fail189();
function check190() {
 return (asmModule.ctz(2147483647 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check190()) fail190();
function check191() {
 return (asmModule.popcnt(4294967295 | 0) | 0 | 0) == (32 | 0) | 0;
}

if (!check191()) fail191();
function check192() {
 return (asmModule.popcnt(0 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check192()) fail192();
function check193() {
 return (asmModule.popcnt(32768 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check193()) fail193();
function check194() {
 return (asmModule.popcnt(2147516416 | 0) | 0 | 0) == (2 | 0) | 0;
}

if (!check194()) fail194();
function check195() {
 return (asmModule.popcnt(2147483647 | 0) | 0 | 0) == (31 | 0) | 0;
}

if (!check195()) fail195();
function check196() {
 return (asmModule.popcnt(2863311530 | 0) | 0 | 0) == (16 | 0) | 0;
}

if (!check196()) fail196();
function check197() {
 return (asmModule.popcnt(1431655765 | 0) | 0 | 0) == (16 | 0) | 0;
}

if (!check197()) fail197();
function check198() {
 return (asmModule.popcnt(3735928559 | 0) | 0 | 0) == (24 | 0) | 0;
}

if (!check198()) fail198();
function check199() {
 return (asmModule.eqz(0 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check199()) fail199();
function check200() {
 return (asmModule.eqz(1 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check200()) fail200();
function check201() {
 return (asmModule.eqz(2147483648 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check201()) fail201();
function check202() {
 return (asmModule.eqz(2147483647 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check202()) fail202();
function check203() {
 return (asmModule.eq(0 | 0, 0 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check203()) fail203();
function check204() {
 return (asmModule.eq(1 | 0, 1 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check204()) fail204();
function check205() {
 return (asmModule.eq(4294967295 | 0, 1 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check205()) fail205();
function check206() {
 return (asmModule.eq(2147483648 | 0, 2147483648 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check206()) fail206();
function check207() {
 return (asmModule.eq(2147483647 | 0, 2147483647 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check207()) fail207();
function check208() {
 return (asmModule.eq(4294967295 | 0, 4294967295 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check208()) fail208();
function check209() {
 return (asmModule.eq(1 | 0, 0 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check209()) fail209();
function check210() {
 return (asmModule.eq(0 | 0, 1 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check210()) fail210();
function check211() {
 return (asmModule.eq(2147483648 | 0, 0 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check211()) fail211();
function check212() {
 return (asmModule.eq(0 | 0, 2147483648 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check212()) fail212();
function check213() {
 return (asmModule.eq(2147483648 | 0, 4294967295 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check213()) fail213();
function check214() {
 return (asmModule.eq(4294967295 | 0, 2147483648 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check214()) fail214();
function check215() {
 return (asmModule.eq(2147483648 | 0, 2147483647 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check215()) fail215();
function check216() {
 return (asmModule.eq(2147483647 | 0, 2147483648 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check216()) fail216();
function check217() {
 return (asmModule.ne(0 | 0, 0 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check217()) fail217();
function check218() {
 return (asmModule.ne(1 | 0, 1 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check218()) fail218();
function check219() {
 return (asmModule.ne(4294967295 | 0, 1 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check219()) fail219();
function check220() {
 return (asmModule.ne(2147483648 | 0, 2147483648 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check220()) fail220();
function check221() {
 return (asmModule.ne(2147483647 | 0, 2147483647 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check221()) fail221();
function check222() {
 return (asmModule.ne(4294967295 | 0, 4294967295 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check222()) fail222();
function check223() {
 return (asmModule.ne(1 | 0, 0 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check223()) fail223();
function check224() {
 return (asmModule.ne(0 | 0, 1 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check224()) fail224();
function check225() {
 return (asmModule.ne(2147483648 | 0, 0 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check225()) fail225();
function check226() {
 return (asmModule.ne(0 | 0, 2147483648 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check226()) fail226();
function check227() {
 return (asmModule.ne(2147483648 | 0, 4294967295 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check227()) fail227();
function check228() {
 return (asmModule.ne(4294967295 | 0, 2147483648 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check228()) fail228();
function check229() {
 return (asmModule.ne(2147483648 | 0, 2147483647 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check229()) fail229();
function check230() {
 return (asmModule.ne(2147483647 | 0, 2147483648 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check230()) fail230();
function check231() {
 return (asmModule.lt_s(0 | 0, 0 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check231()) fail231();
function check232() {
 return (asmModule.lt_s(1 | 0, 1 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check232()) fail232();
function check233() {
 return (asmModule.lt_s(4294967295 | 0, 1 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check233()) fail233();
function check234() {
 return (asmModule.lt_s(2147483648 | 0, 2147483648 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check234()) fail234();
function check235() {
 return (asmModule.lt_s(2147483647 | 0, 2147483647 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check235()) fail235();
function check236() {
 return (asmModule.lt_s(4294967295 | 0, 4294967295 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check236()) fail236();
function check237() {
 return (asmModule.lt_s(1 | 0, 0 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check237()) fail237();
function check238() {
 return (asmModule.lt_s(0 | 0, 1 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check238()) fail238();
function check239() {
 return (asmModule.lt_s(2147483648 | 0, 0 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check239()) fail239();
function check240() {
 return (asmModule.lt_s(0 | 0, 2147483648 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check240()) fail240();
function check241() {
 return (asmModule.lt_s(2147483648 | 0, 4294967295 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check241()) fail241();
function check242() {
 return (asmModule.lt_s(4294967295 | 0, 2147483648 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check242()) fail242();
function check243() {
 return (asmModule.lt_s(2147483648 | 0, 2147483647 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check243()) fail243();
function check244() {
 return (asmModule.lt_s(2147483647 | 0, 2147483648 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check244()) fail244();
function check245() {
 return (asmModule.lt_u(0 | 0, 0 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check245()) fail245();
function check246() {
 return (asmModule.lt_u(1 | 0, 1 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check246()) fail246();
function check247() {
 return (asmModule.lt_u(4294967295 | 0, 1 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check247()) fail247();
function check248() {
 return (asmModule.lt_u(2147483648 | 0, 2147483648 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check248()) fail248();
function check249() {
 return (asmModule.lt_u(2147483647 | 0, 2147483647 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check249()) fail249();
function check250() {
 return (asmModule.lt_u(4294967295 | 0, 4294967295 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check250()) fail250();
function check251() {
 return (asmModule.lt_u(1 | 0, 0 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check251()) fail251();
function check252() {
 return (asmModule.lt_u(0 | 0, 1 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check252()) fail252();
function check253() {
 return (asmModule.lt_u(2147483648 | 0, 0 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check253()) fail253();
function check254() {
 return (asmModule.lt_u(0 | 0, 2147483648 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check254()) fail254();
function check255() {
 return (asmModule.lt_u(2147483648 | 0, 4294967295 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check255()) fail255();
function check256() {
 return (asmModule.lt_u(4294967295 | 0, 2147483648 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check256()) fail256();
function check257() {
 return (asmModule.lt_u(2147483648 | 0, 2147483647 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check257()) fail257();
function check258() {
 return (asmModule.lt_u(2147483647 | 0, 2147483648 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check258()) fail258();
function check259() {
 return (asmModule.le_s(0 | 0, 0 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check259()) fail259();
function check260() {
 return (asmModule.le_s(1 | 0, 1 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check260()) fail260();
function check261() {
 return (asmModule.le_s(4294967295 | 0, 1 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check261()) fail261();
function check262() {
 return (asmModule.le_s(2147483648 | 0, 2147483648 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check262()) fail262();
function check263() {
 return (asmModule.le_s(2147483647 | 0, 2147483647 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check263()) fail263();
function check264() {
 return (asmModule.le_s(4294967295 | 0, 4294967295 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check264()) fail264();
function check265() {
 return (asmModule.le_s(1 | 0, 0 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check265()) fail265();
function check266() {
 return (asmModule.le_s(0 | 0, 1 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check266()) fail266();
function check267() {
 return (asmModule.le_s(2147483648 | 0, 0 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check267()) fail267();
function check268() {
 return (asmModule.le_s(0 | 0, 2147483648 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check268()) fail268();
function check269() {
 return (asmModule.le_s(2147483648 | 0, 4294967295 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check269()) fail269();
function check270() {
 return (asmModule.le_s(4294967295 | 0, 2147483648 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check270()) fail270();
function check271() {
 return (asmModule.le_s(2147483648 | 0, 2147483647 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check271()) fail271();
function check272() {
 return (asmModule.le_s(2147483647 | 0, 2147483648 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check272()) fail272();
function check273() {
 return (asmModule.le_u(0 | 0, 0 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check273()) fail273();
function check274() {
 return (asmModule.le_u(1 | 0, 1 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check274()) fail274();
function check275() {
 return (asmModule.le_u(4294967295 | 0, 1 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check275()) fail275();
function check276() {
 return (asmModule.le_u(2147483648 | 0, 2147483648 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check276()) fail276();
function check277() {
 return (asmModule.le_u(2147483647 | 0, 2147483647 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check277()) fail277();
function check278() {
 return (asmModule.le_u(4294967295 | 0, 4294967295 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check278()) fail278();
function check279() {
 return (asmModule.le_u(1 | 0, 0 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check279()) fail279();
function check280() {
 return (asmModule.le_u(0 | 0, 1 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check280()) fail280();
function check281() {
 return (asmModule.le_u(2147483648 | 0, 0 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check281()) fail281();
function check282() {
 return (asmModule.le_u(0 | 0, 2147483648 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check282()) fail282();
function check283() {
 return (asmModule.le_u(2147483648 | 0, 4294967295 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check283()) fail283();
function check284() {
 return (asmModule.le_u(4294967295 | 0, 2147483648 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check284()) fail284();
function check285() {
 return (asmModule.le_u(2147483648 | 0, 2147483647 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check285()) fail285();
function check286() {
 return (asmModule.le_u(2147483647 | 0, 2147483648 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check286()) fail286();
function check287() {
 return (asmModule.gt_s(0 | 0, 0 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check287()) fail287();
function check288() {
 return (asmModule.gt_s(1 | 0, 1 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check288()) fail288();
function check289() {
 return (asmModule.gt_s(4294967295 | 0, 1 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check289()) fail289();
function check290() {
 return (asmModule.gt_s(2147483648 | 0, 2147483648 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check290()) fail290();
function check291() {
 return (asmModule.gt_s(2147483647 | 0, 2147483647 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check291()) fail291();
function check292() {
 return (asmModule.gt_s(4294967295 | 0, 4294967295 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check292()) fail292();
function check293() {
 return (asmModule.gt_s(1 | 0, 0 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check293()) fail293();
function check294() {
 return (asmModule.gt_s(0 | 0, 1 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check294()) fail294();
function check295() {
 return (asmModule.gt_s(2147483648 | 0, 0 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check295()) fail295();
function check296() {
 return (asmModule.gt_s(0 | 0, 2147483648 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check296()) fail296();
function check297() {
 return (asmModule.gt_s(2147483648 | 0, 4294967295 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check297()) fail297();
function check298() {
 return (asmModule.gt_s(4294967295 | 0, 2147483648 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check298()) fail298();
function check299() {
 return (asmModule.gt_s(2147483648 | 0, 2147483647 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check299()) fail299();
function check300() {
 return (asmModule.gt_s(2147483647 | 0, 2147483648 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check300()) fail300();
function check301() {
 return (asmModule.gt_u(0 | 0, 0 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check301()) fail301();
function check302() {
 return (asmModule.gt_u(1 | 0, 1 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check302()) fail302();
function check303() {
 return (asmModule.gt_u(4294967295 | 0, 1 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check303()) fail303();
function check304() {
 return (asmModule.gt_u(2147483648 | 0, 2147483648 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check304()) fail304();
function check305() {
 return (asmModule.gt_u(2147483647 | 0, 2147483647 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check305()) fail305();
function check306() {
 return (asmModule.gt_u(4294967295 | 0, 4294967295 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check306()) fail306();
function check307() {
 return (asmModule.gt_u(1 | 0, 0 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check307()) fail307();
function check308() {
 return (asmModule.gt_u(0 | 0, 1 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check308()) fail308();
function check309() {
 return (asmModule.gt_u(2147483648 | 0, 0 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check309()) fail309();
function check310() {
 return (asmModule.gt_u(0 | 0, 2147483648 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check310()) fail310();
function check311() {
 return (asmModule.gt_u(2147483648 | 0, 4294967295 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check311()) fail311();
function check312() {
 return (asmModule.gt_u(4294967295 | 0, 2147483648 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check312()) fail312();
function check313() {
 return (asmModule.gt_u(2147483648 | 0, 2147483647 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check313()) fail313();
function check314() {
 return (asmModule.gt_u(2147483647 | 0, 2147483648 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check314()) fail314();
function check315() {
 return (asmModule.ge_s(0 | 0, 0 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check315()) fail315();
function check316() {
 return (asmModule.ge_s(1 | 0, 1 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check316()) fail316();
function check317() {
 return (asmModule.ge_s(4294967295 | 0, 1 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check317()) fail317();
function check318() {
 return (asmModule.ge_s(2147483648 | 0, 2147483648 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check318()) fail318();
function check319() {
 return (asmModule.ge_s(2147483647 | 0, 2147483647 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check319()) fail319();
function check320() {
 return (asmModule.ge_s(4294967295 | 0, 4294967295 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check320()) fail320();
function check321() {
 return (asmModule.ge_s(1 | 0, 0 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check321()) fail321();
function check322() {
 return (asmModule.ge_s(0 | 0, 1 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check322()) fail322();
function check323() {
 return (asmModule.ge_s(2147483648 | 0, 0 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check323()) fail323();
function check324() {
 return (asmModule.ge_s(0 | 0, 2147483648 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check324()) fail324();
function check325() {
 return (asmModule.ge_s(2147483648 | 0, 4294967295 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check325()) fail325();
function check326() {
 return (asmModule.ge_s(4294967295 | 0, 2147483648 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check326()) fail326();
function check327() {
 return (asmModule.ge_s(2147483648 | 0, 2147483647 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check327()) fail327();
function check328() {
 return (asmModule.ge_s(2147483647 | 0, 2147483648 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check328()) fail328();
function check329() {
 return (asmModule.ge_u(0 | 0, 0 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check329()) fail329();
function check330() {
 return (asmModule.ge_u(1 | 0, 1 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check330()) fail330();
function check331() {
 return (asmModule.ge_u(4294967295 | 0, 1 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check331()) fail331();
function check332() {
 return (asmModule.ge_u(2147483648 | 0, 2147483648 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check332()) fail332();
function check333() {
 return (asmModule.ge_u(2147483647 | 0, 2147483647 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check333()) fail333();
function check334() {
 return (asmModule.ge_u(4294967295 | 0, 4294967295 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check334()) fail334();
function check335() {
 return (asmModule.ge_u(1 | 0, 0 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check335()) fail335();
function check336() {
 return (asmModule.ge_u(0 | 0, 1 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check336()) fail336();
function check337() {
 return (asmModule.ge_u(2147483648 | 0, 0 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check337()) fail337();
function check338() {
 return (asmModule.ge_u(0 | 0, 2147483648 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check338()) fail338();
function check339() {
 return (asmModule.ge_u(2147483648 | 0, 4294967295 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check339()) fail339();
function check340() {
 return (asmModule.ge_u(4294967295 | 0, 2147483648 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check340()) fail340();
function check341() {
 return (asmModule.ge_u(2147483648 | 0, 2147483647 | 0) | 0 | 0) == (1 | 0) | 0;
}

if (!check341()) fail341();
function check342() {
 return (asmModule.ge_u(2147483647 | 0, 2147483648 | 0) | 0 | 0) == (0 | 0) | 0;
}

if (!check342()) fail342();
