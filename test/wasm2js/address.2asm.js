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
 function $0(i) {
  i = i | 0;
  return HEAPU8[i >> 0] | 0 | 0;
 }
 
 function $1(i) {
  i = i | 0;
  return HEAPU8[i >> 0] | 0 | 0;
 }
 
 function $2(i) {
  i = i | 0;
  return HEAPU8[(i + 1 | 0) >> 0] | 0 | 0;
 }
 
 function $3(i) {
  i = i | 0;
  return HEAPU8[(i + 2 | 0) >> 0] | 0 | 0;
 }
 
 function $4(i) {
  i = i | 0;
  return HEAPU8[(i + 25 | 0) >> 0] | 0 | 0;
 }
 
 function $5(i) {
  i = i | 0;
  return HEAP8[i >> 0] | 0 | 0;
 }
 
 function $6(i) {
  i = i | 0;
  return HEAP8[i >> 0] | 0 | 0;
 }
 
 function $7(i) {
  i = i | 0;
  return HEAP8[(i + 1 | 0) >> 0] | 0 | 0;
 }
 
 function $8(i) {
  i = i | 0;
  return HEAP8[(i + 2 | 0) >> 0] | 0 | 0;
 }
 
 function $9(i) {
  i = i | 0;
  return HEAP8[(i + 25 | 0) >> 0] | 0 | 0;
 }
 
 function $10(i) {
  i = i | 0;
  return HEAPU16[i >> 1] | 0 | 0;
 }
 
 function $11(i) {
  i = i | 0;
  var wasm2js_i32$0 = 0;
  return (wasm2js_i32$0 = i, HEAPU8[wasm2js_i32$0 >> 0] | 0 | 0 | (HEAPU8[(wasm2js_i32$0 + 1 | 0) >> 0] | 0 | 0) << 8) | 0;
 }
 
 function $12(i) {
  i = i | 0;
  var wasm2js_i32$0 = 0;
  return (wasm2js_i32$0 = i, HEAPU8[(wasm2js_i32$0 + 1 | 0) >> 0] | 0 | 0 | (HEAPU8[(wasm2js_i32$0 + 2 | 0) >> 0] | 0 | 0) << 8) | 0;
 }
 
 function $13(i) {
  i = i | 0;
  return HEAPU16[(i + 2 | 0) >> 1] | 0 | 0;
 }
 
 function $14(i) {
  i = i | 0;
  return HEAPU16[(i + 25 | 0) >> 1] | 0 | 0;
 }
 
 function $15(i) {
  i = i | 0;
  return HEAP16[i >> 1] | 0 | 0;
 }
 
 function $16(i) {
  i = i | 0;
  var wasm2js_i32$0 = 0;
  return (wasm2js_i32$0 = i, HEAP8[wasm2js_i32$0 >> 0] | 0 | 0 | (HEAP8[(wasm2js_i32$0 + 1 | 0) >> 0] | 0 | 0) << 8) | 0;
 }
 
 function $17(i) {
  i = i | 0;
  var wasm2js_i32$0 = 0;
  return (wasm2js_i32$0 = i, HEAP8[(wasm2js_i32$0 + 1 | 0) >> 0] | 0 | 0 | (HEAP8[(wasm2js_i32$0 + 2 | 0) >> 0] | 0 | 0) << 8) | 0;
 }
 
 function $18(i) {
  i = i | 0;
  return HEAP16[(i + 2 | 0) >> 1] | 0 | 0;
 }
 
 function $19(i) {
  i = i | 0;
  return HEAP16[(i + 25 | 0) >> 1] | 0 | 0;
 }
 
 function $20(i) {
  i = i | 0;
  return HEAPU32[i >> 2] | 0 | 0;
 }
 
 function $21(i) {
  i = i | 0;
  var wasm2js_i32$0 = 0;
  return (wasm2js_i32$0 = i, HEAPU8[wasm2js_i32$0 >> 0] | 0 | 0 | (HEAPU8[(wasm2js_i32$0 + 1 | 0) >> 0] | 0 | 0) << 8 | (HEAPU8[(wasm2js_i32$0 + 2 | 0) >> 0] | 0 | 0) << 16 | (HEAPU8[(wasm2js_i32$0 + 3 | 0) >> 0] | 0 | 0) << 24) | 0;
 }
 
 function $22(i) {
  i = i | 0;
  var wasm2js_i32$0 = 0;
  return (wasm2js_i32$0 = i, HEAPU8[(wasm2js_i32$0 + 1 | 0) >> 0] | 0 | 0 | (HEAPU8[(wasm2js_i32$0 + 2 | 0) >> 0] | 0 | 0) << 8 | (HEAPU8[(wasm2js_i32$0 + 3 | 0) >> 0] | 0 | 0) << 16 | (HEAPU8[(wasm2js_i32$0 + 4 | 0) >> 0] | 0 | 0) << 24) | 0;
 }
 
 function $23(i) {
  i = i | 0;
  var wasm2js_i32$0 = 0;
  return (wasm2js_i32$0 = i, HEAPU8[(wasm2js_i32$0 + 2 | 0) >> 0] | 0 | 0 | (HEAPU8[(wasm2js_i32$0 + 3 | 0) >> 0] | 0 | 0) << 8 | (HEAPU8[(wasm2js_i32$0 + 4 | 0) >> 0] | 0 | 0) << 16 | (HEAPU8[(wasm2js_i32$0 + 5 | 0) >> 0] | 0 | 0) << 24) | 0;
 }
 
 function $24(i) {
  i = i | 0;
  return HEAPU32[(i + 25 | 0) >> 2] | 0 | 0;
 }
 
 function $25(i) {
  i = i | 0;
  HEAPU8[(i + 4294967295 | 0) >> 0] | 0;
 }
 
 function $26(i) {
  i = i | 0;
  HEAP8[(i + 4294967295 | 0) >> 0] | 0;
 }
 
 function $27(i) {
  i = i | 0;
  HEAPU16[(i + 4294967295 | 0) >> 1] | 0;
 }
 
 function $28(i) {
  i = i | 0;
  HEAP16[(i + 4294967295 | 0) >> 1] | 0;
 }
 
 function $29(i) {
  i = i | 0;
  HEAPU32[(i + 4294967295 | 0) >> 2] | 0;
 }
 
 return {
  $8u_good1: $0, 
  $8u_good2: $1, 
  $8u_good3: $2, 
  $8u_good4: $3, 
  $8u_good5: $4, 
  $8s_good1: $5, 
  $8s_good2: $6, 
  $8s_good3: $7, 
  $8s_good4: $8, 
  $8s_good5: $9, 
  $16u_good1: $10, 
  $16u_good2: $11, 
  $16u_good3: $12, 
  $16u_good4: $13, 
  $16u_good5: $14, 
  $16s_good1: $15, 
  $16s_good2: $16, 
  $16s_good3: $17, 
  $16s_good4: $18, 
  $16s_good5: $19, 
  $32_good1: $20, 
  $32_good2: $21, 
  $32_good3: $22, 
  $32_good4: $23, 
  $32_good5: $24, 
  $8u_bad: $25, 
  $8s_bad: $26, 
  $16u_bad: $27, 
  $16s_bad: $28, 
  $32_bad: $29
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
const retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export const $8u_good1 = retasmFunc.$8u_good1;
export const $8u_good2 = retasmFunc.$8u_good2;
export const $8u_good3 = retasmFunc.$8u_good3;
export const $8u_good4 = retasmFunc.$8u_good4;
export const $8u_good5 = retasmFunc.$8u_good5;
export const $8s_good1 = retasmFunc.$8s_good1;
export const $8s_good2 = retasmFunc.$8s_good2;
export const $8s_good3 = retasmFunc.$8s_good3;
export const $8s_good4 = retasmFunc.$8s_good4;
export const $8s_good5 = retasmFunc.$8s_good5;
export const $16u_good1 = retasmFunc.$16u_good1;
export const $16u_good2 = retasmFunc.$16u_good2;
export const $16u_good3 = retasmFunc.$16u_good3;
export const $16u_good4 = retasmFunc.$16u_good4;
export const $16u_good5 = retasmFunc.$16u_good5;
export const $16s_good1 = retasmFunc.$16s_good1;
export const $16s_good2 = retasmFunc.$16s_good2;
export const $16s_good3 = retasmFunc.$16s_good3;
export const $16s_good4 = retasmFunc.$16s_good4;
export const $16s_good5 = retasmFunc.$16s_good5;
export const $32_good1 = retasmFunc.$32_good1;
export const $32_good2 = retasmFunc.$32_good2;
export const $32_good3 = retasmFunc.$32_good3;
export const $32_good4 = retasmFunc.$32_good4;
export const $32_good5 = retasmFunc.$32_good5;
export const $8u_bad = retasmFunc.$8u_bad;
export const $8s_bad = retasmFunc.$8s_bad;
export const $16u_bad = retasmFunc.$16u_bad;
export const $16s_bad = retasmFunc.$16s_bad;
export const $32_bad = retasmFunc.$32_bad;
