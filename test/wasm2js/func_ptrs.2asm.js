import { print_i32 } from 'spectest';

function asmFunc(env) {
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
 var abort = env.abort;
 var nan = NaN;
 var infinity = Infinity;
 var print = env.print_i32;
 function $3() {
  return 13 | 0;
 }
 
 function $4($0) {
  $0 = $0 | 0;
  return $0 + 1 | 0 | 0;
 }
 
 function $5(a) {
  a = a | 0;
  return a - 2 | 0 | 0;
 }
 
 function $6($0) {
  $0 = $0 | 0;
  print($0 | 0);
 }
 
 return {
  "one": $3, 
  "two": $4, 
  "three": $5, 
  "four": $6
 };
}

var retasmFunc = asmFunc({ abort() { throw new Error('abort'); },
    print_i32 });
export var one = retasmFunc.one;
export var two = retasmFunc.two;
export var three = retasmFunc.three;
export var four = retasmFunc.four;

function asmFunc(env) {
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
 var abort = env.abort;
 var nan = NaN;
 var infinity = Infinity;
 function t1() {
  return 1 | 0;
 }
 
 function t2() {
  return 2 | 0;
 }
 
 function t3() {
  return 3 | 0;
 }
 
 function u1() {
  return 4 | 0;
 }
 
 function u2() {
  return 5 | 0;
 }
 
 function $5(i) {
  i = i | 0;
  return FUNCTION_TABLE[i | 0]() | 0 | 0;
 }
 
 function $6(i) {
  i = i | 0;
  return FUNCTION_TABLE[i | 0]() | 0 | 0;
 }
 
 var FUNCTION_TABLE = [t1, t2, t3, u1, u2, t1, t3];
 return {
  "callt": $5, 
  "callu": $6
 };
}

var retasmFunc = asmFunc({ abort() { throw new Error('abort'); } });
export var callt = retasmFunc.callt;
export var callu = retasmFunc.callu;

function asmFunc(env) {
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
 var abort = env.abort;
 var nan = NaN;
 var infinity = Infinity;
 function t1() {
  return 1 | 0;
 }
 
 function t2() {
  return 2 | 0;
 }
 
 function $2(i) {
  i = i | 0;
  return FUNCTION_TABLE[i | 0]() | 0 | 0;
 }
 
 var FUNCTION_TABLE = [t1, t2];
 return {
  "callt": $2
 };
}

var retasmFunc = asmFunc({ abort() { throw new Error('abort'); } });
export var callt = retasmFunc.callt;
