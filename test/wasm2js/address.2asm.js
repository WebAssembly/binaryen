import { print } from 'spectest';
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
 var print = env.print;
 var i64toi32_i32$HIGH_BITS = 0;
 function $0(i) {
  i = i | 0;
  var wasm2js_i32$0 = 0;
  print(HEAPU8[i >> 0] | 0 | 0);
  print(HEAPU8[(i + 1 | 0) >> 0] | 0 | 0);
  print(HEAPU8[(i + 2 | 0) >> 0] | 0 | 0);
  print(HEAPU8[(i + 25 | 0) >> 0] | 0 | 0);
  print(HEAPU16[i >> 1] | 0 | 0);
  print((wasm2js_i32$0 = i, HEAPU8[wasm2js_i32$0 >> 0] | 0 | 0 | (HEAPU8[(wasm2js_i32$0 + 1 | 0) >> 0] | 0 | 0) << 8) | 0);
  print((wasm2js_i32$0 = i, HEAPU8[(wasm2js_i32$0 + 1 | 0) >> 0] | 0 | 0 | (HEAPU8[(wasm2js_i32$0 + 2 | 0) >> 0] | 0 | 0) << 8) | 0);
  print(HEAPU16[(i + 2 | 0) >> 1] | 0 | 0);
  print((wasm2js_i32$0 = i, HEAPU8[(wasm2js_i32$0 + 25 | 0) >> 0] | 0 | 0 | (HEAPU8[(wasm2js_i32$0 + 26 | 0) >> 0] | 0 | 0) << 8) | 0);
  print(HEAPU32[i >> 2] | 0 | 0);
  print((wasm2js_i32$0 = i, HEAPU8[(wasm2js_i32$0 + 1 | 0) >> 0] | 0 | 0 | (HEAPU8[(wasm2js_i32$0 + 2 | 0) >> 0] | 0 | 0) << 8 | (HEAPU8[(wasm2js_i32$0 + 3 | 0) >> 0] | 0 | 0) << 16 | (HEAPU8[(wasm2js_i32$0 + 4 | 0) >> 0] | 0 | 0) << 24) | 0);
  print((wasm2js_i32$0 = i, HEAPU8[(wasm2js_i32$0 + 2 | 0) >> 0] | 0 | 0 | (HEAPU8[(wasm2js_i32$0 + 3 | 0) >> 0] | 0 | 0) << 8 | (HEAPU8[(wasm2js_i32$0 + 4 | 0) >> 0] | 0 | 0) << 16 | (HEAPU8[(wasm2js_i32$0 + 5 | 0) >> 0] | 0 | 0) << 24) | 0);
  print((wasm2js_i32$0 = i, HEAPU8[(wasm2js_i32$0 + 25 | 0) >> 0] | 0 | 0 | (HEAPU8[(wasm2js_i32$0 + 26 | 0) >> 0] | 0 | 0) << 8 | (HEAPU8[(wasm2js_i32$0 + 27 | 0) >> 0] | 0 | 0) << 16 | (HEAPU8[(wasm2js_i32$0 + 28 | 0) >> 0] | 0 | 0) << 24) | 0);
 }
 
 function $1(i) {
  i = i | 0;
  HEAPU32[(i + 4294967295 | 0) >> 2] | 0;
 }
 
 return {
  good: $0, 
  bad: $1
 };
}

const memasmFunc = new ArrayBuffer(65536);
const assignasmFunc = (
      function(mem) {
        const _mem = new Uint8Array(mem);
        return function(offset, s) {
          if (typeof Buffer === 'undefined') {
            const bytes = atob(s);
            for (let i = 0; i < bytes.length; i++)
              _mem[offset + i] = bytes.charCodeAt(i);
          } else {
            const bytes = Buffer.from(s, 'base64');
            for (let i = 0; i < bytes.length; i++)
              _mem[offset + i] = bytes[i];
          }
        }
      }
    )(memasmFunc);
assignasmFunc(0, "YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXo=");
const retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },print},memasmFunc);
export const good = retasmFunc.good;
export const bad = retasmFunc.bad;
