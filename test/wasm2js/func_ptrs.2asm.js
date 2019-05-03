import { print } from 'spectest';

function asmFunc(global, env, buffer) {
 "almost asm";
 var HEAP8 = new global.Int8Array(buffer);
 var HEAP16 = new global.Int16Array(buffer);
 var HEAP32 = new global.Int32Array(buffer);
 var HEAPU8 = new global.Uint8Array(buffer);
 var HEAPU16 = new global.Uint16Array(buffer);
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
 var print = env.print;
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
 
 var FUNCTION_TABLE = [];
 return {
  "one": $3, 
  "two": $4, 
  "three": $5, 
  "four": $6
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },print},memasmFunc);
export var one = retasmFunc.one;
export var two = retasmFunc.two;
export var three = retasmFunc.three;
export var four = retasmFunc.four;

function asmFunc(global, env, buffer) {
 "almost asm";
 var HEAP8 = new global.Int8Array(buffer);
 var HEAP16 = new global.Int16Array(buffer);
 var HEAP32 = new global.Int32Array(buffer);
 var HEAPU8 = new global.Uint8Array(buffer);
 var HEAPU16 = new global.Uint16Array(buffer);
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
  return FUNCTION_TABLE[i]() | 0 | 0;
 }
 
 function $6(i) {
  i = i | 0;
  return FUNCTION_TABLE[i]() | 0 | 0;
 }
 
 var FUNCTION_TABLE = [t1, t2, t3, u1, u2, t1, t3];
 return {
  "callt": $5, 
  "callu": $6
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export var callt = retasmFunc.callt;
export var callu = retasmFunc.callu;

function asmFunc(global, env, buffer) {
 "almost asm";
 var HEAP8 = new global.Int8Array(buffer);
 var HEAP16 = new global.Int16Array(buffer);
 var HEAP32 = new global.Int32Array(buffer);
 var HEAPU8 = new global.Uint8Array(buffer);
 var HEAPU16 = new global.Uint16Array(buffer);
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
 function t1() {
  return 1 | 0;
 }
 
 function t2() {
  return 2 | 0;
 }
 
 function $2(i) {
  i = i | 0;
  return FUNCTION_TABLE[i]() | 0 | 0;
 }
 
 var FUNCTION_TABLE = [t1, t2];
 return {
  "callt": $2
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export var callt = retasmFunc.callt;
