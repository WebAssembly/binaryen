
function asmFunc(global, env, buffer) {
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
  var $1_1 = 0;
  $1_1 = i;
  return HEAPU8[$1_1 >> 0] | 0 | ((HEAPU8[($1_1 + 1 | 0) >> 0] | 0) << 8 | 0) | 0 | 0;
 }
 
 function $12(i) {
  i = i | 0;
  var $1_1 = 0;
  $1_1 = i;
  return HEAPU8[($1_1 + 1 | 0) >> 0] | 0 | ((HEAPU8[($1_1 + 2 | 0) >> 0] | 0) << 8 | 0) | 0 | 0;
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
  var $1_1 = 0;
  $1_1 = i;
  return ((HEAPU8[$1_1 >> 0] | 0 | ((HEAPU8[($1_1 + 1 | 0) >> 0] | 0) << 8 | 0) | 0) << 16 | 0) >> 16 | 0 | 0;
 }
 
 function $17(i) {
  i = i | 0;
  var $1_1 = 0;
  $1_1 = i;
  return ((HEAPU8[($1_1 + 1 | 0) >> 0] | 0 | ((HEAPU8[($1_1 + 2 | 0) >> 0] | 0) << 8 | 0) | 0) << 16 | 0) >> 16 | 0 | 0;
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
  return HEAP32[i >> 2] | 0 | 0;
 }
 
 function $21(i) {
  i = i | 0;
  var $1_1 = 0;
  $1_1 = i;
  return HEAPU8[$1_1 >> 0] | 0 | ((HEAPU8[($1_1 + 1 | 0) >> 0] | 0) << 8 | 0) | 0 | ((HEAPU8[($1_1 + 2 | 0) >> 0] | 0) << 16 | 0 | ((HEAPU8[($1_1 + 3 | 0) >> 0] | 0) << 24 | 0) | 0) | 0 | 0;
 }
 
 function $22(i) {
  i = i | 0;
  var $1_1 = 0;
  $1_1 = i;
  return HEAPU8[($1_1 + 1 | 0) >> 0] | 0 | ((HEAPU8[($1_1 + 2 | 0) >> 0] | 0) << 8 | 0) | 0 | ((HEAPU8[($1_1 + 3 | 0) >> 0] | 0) << 16 | 0 | ((HEAPU8[($1_1 + 4 | 0) >> 0] | 0) << 24 | 0) | 0) | 0 | 0;
 }
 
 function $23(i) {
  i = i | 0;
  var $1_1 = 0;
  $1_1 = i;
  return HEAPU16[($1_1 + 2 | 0) >> 1] | 0 | ((HEAPU16[($1_1 + 4 | 0) >> 1] | 0) << 16 | 0) | 0 | 0;
 }
 
 function $24(i) {
  i = i | 0;
  return HEAP32[(i + 25 | 0) >> 2] | 0 | 0;
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
  HEAP32[(i + 4294967295 | 0) >> 2] | 0;
 }
 
 var FUNCTION_TABLE = [];
 function __wasm_memory_size() {
  return buffer.byteLength / 65536 | 0;
 }
 
 function __wasm_memory_grow(pagesToAdd) {
  pagesToAdd = pagesToAdd | 0;
  var oldPages = __wasm_memory_size() | 0;
  var newPages = oldPages + pagesToAdd | 0;
  if ((oldPages < newPages) && (newPages < 65536)) {
   var newBuffer = new ArrayBuffer(Math_imul(newPages, 65536));
   var newHEAP8 = new global.Int8Array(newBuffer);
   newHEAP8.set(HEAP8);
   HEAP8 = newHEAP8;
   HEAP8 = new global.Int8Array(newBuffer);
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
 
 return {
  "$8u_good1": $0, 
  "$8u_good2": $1, 
  "$8u_good3": $2, 
  "$8u_good4": $3, 
  "$8u_good5": $4, 
  "$8s_good1": $5, 
  "$8s_good2": $6, 
  "$8s_good3": $7, 
  "$8s_good4": $8, 
  "$8s_good5": $9, 
  "$16u_good1": $10, 
  "$16u_good2": $11, 
  "$16u_good3": $12, 
  "$16u_good4": $13, 
  "$16u_good5": $14, 
  "$16s_good1": $15, 
  "$16s_good2": $16, 
  "$16s_good3": $17, 
  "$16s_good4": $18, 
  "$16s_good5": $19, 
  "$32_good1": $20, 
  "$32_good2": $21, 
  "$32_good3": $22, 
  "$32_good4": $23, 
  "$32_good5": $24, 
  "$8u_bad": $25, 
  "$8s_bad": $26, 
  "$16u_bad": $27, 
  "$16s_bad": $28, 
  "$32_bad": $29
 };
}

var memasmFunc = new ArrayBuffer(65536);
var assignasmFunc = (
    function(mem) {
      var _mem = new Uint8Array(mem);
      return function(offset, s) {
        var bytes, i;
        if (typeof Buffer === 'undefined') {
          bytes = atob(s);
          for (i = 0; i < bytes.length; i++)
            _mem[offset + i] = bytes.charCodeAt(i);
        } else {
          bytes = Buffer.from(s, 'base64');
          for (i = 0; i < bytes.length; i++)
            _mem[offset + i] = bytes[i];
        }
      }
    }
  )(memasmFunc);
assignasmFunc(0, "YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXo=");
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export var $8u_good1 = retasmFunc.$8u_good1;
export var $8u_good2 = retasmFunc.$8u_good2;
export var $8u_good3 = retasmFunc.$8u_good3;
export var $8u_good4 = retasmFunc.$8u_good4;
export var $8u_good5 = retasmFunc.$8u_good5;
export var $8s_good1 = retasmFunc.$8s_good1;
export var $8s_good2 = retasmFunc.$8s_good2;
export var $8s_good3 = retasmFunc.$8s_good3;
export var $8s_good4 = retasmFunc.$8s_good4;
export var $8s_good5 = retasmFunc.$8s_good5;
export var $16u_good1 = retasmFunc.$16u_good1;
export var $16u_good2 = retasmFunc.$16u_good2;
export var $16u_good3 = retasmFunc.$16u_good3;
export var $16u_good4 = retasmFunc.$16u_good4;
export var $16u_good5 = retasmFunc.$16u_good5;
export var $16s_good1 = retasmFunc.$16s_good1;
export var $16s_good2 = retasmFunc.$16s_good2;
export var $16s_good3 = retasmFunc.$16s_good3;
export var $16s_good4 = retasmFunc.$16s_good4;
export var $16s_good5 = retasmFunc.$16s_good5;
export var $32_good1 = retasmFunc.$32_good1;
export var $32_good2 = retasmFunc.$32_good2;
export var $32_good3 = retasmFunc.$32_good3;
export var $32_good4 = retasmFunc.$32_good4;
export var $32_good5 = retasmFunc.$32_good5;
export var $8u_bad = retasmFunc.$8u_bad;
export var $8s_bad = retasmFunc.$8s_bad;
export var $16u_bad = retasmFunc.$16u_bad;
export var $16s_bad = retasmFunc.$16s_bad;
export var $32_bad = retasmFunc.$32_bad;
import { setTempRet0 } from 'env';

function asmFunc(global, env, buffer) {
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
 var setTempRet0 = env.setTempRet0;
 var i64toi32_i32$HIGH_BITS = 0;
 function $0(i) {
  i = i | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = HEAPU8[i >> 0] | 0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $1(i) {
  i = i | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = HEAPU8[i >> 0] | 0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $2(i) {
  i = i | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = HEAPU8[(i + 1 | 0) >> 0] | 0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $3(i) {
  i = i | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = HEAPU8[(i + 2 | 0) >> 0] | 0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $4(i) {
  i = i | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = HEAPU8[(i + 25 | 0) >> 0] | 0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $5(i) {
  i = i | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = HEAP8[i >> 0] | 0;
  i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $6(i) {
  i = i | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = HEAP8[i >> 0] | 0;
  i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $7(i) {
  i = i | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = HEAP8[(i + 1 | 0) >> 0] | 0;
  i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $8(i) {
  i = i | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = HEAP8[(i + 2 | 0) >> 0] | 0;
  i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $9(i) {
  i = i | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = HEAP8[(i + 25 | 0) >> 0] | 0;
  i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $10(i) {
  i = i | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = HEAPU16[i >> 1] | 0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $11(i) {
  i = i | 0;
  var $3_1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  $3_1 = i;
  i64toi32_i32$0 = HEAPU8[$3_1 >> 0] | 0 | ((HEAPU8[($3_1 + 1 | 0) >> 0] | 0) << 8 | 0) | 0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $12(i) {
  i = i | 0;
  var $3_1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  $3_1 = i;
  i64toi32_i32$0 = HEAPU8[($3_1 + 1 | 0) >> 0] | 0 | ((HEAPU8[($3_1 + 2 | 0) >> 0] | 0) << 8 | 0) | 0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $13(i) {
  i = i | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = HEAPU16[(i + 2 | 0) >> 1] | 0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $14(i) {
  i = i | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = HEAPU16[(i + 25 | 0) >> 1] | 0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $15(i) {
  i = i | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = HEAP16[i >> 1] | 0;
  i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $16(i) {
  i = i | 0;
  var $3_1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  $3_1 = i;
  i64toi32_i32$0 = ((HEAPU8[$3_1 >> 0] | 0 | ((HEAPU8[($3_1 + 1 | 0) >> 0] | 0) << 8 | 0) | 0) << 16 | 0) >> 16 | 0;
  i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $17(i) {
  i = i | 0;
  var $3_1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  $3_1 = i;
  i64toi32_i32$0 = ((HEAPU8[($3_1 + 1 | 0) >> 0] | 0 | ((HEAPU8[($3_1 + 2 | 0) >> 0] | 0) << 8 | 0) | 0) << 16 | 0) >> 16 | 0;
  i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $18(i) {
  i = i | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = HEAP16[(i + 2 | 0) >> 1] | 0;
  i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $19(i) {
  i = i | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = HEAP16[(i + 25 | 0) >> 1] | 0;
  i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $20(i) {
  i = i | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = HEAP32[i >> 2] | 0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $21(i) {
  i = i | 0;
  var $3_1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  $3_1 = i;
  i64toi32_i32$0 = HEAPU8[$3_1 >> 0] | 0 | ((HEAPU8[($3_1 + 1 | 0) >> 0] | 0) << 8 | 0) | 0 | ((HEAPU8[($3_1 + 2 | 0) >> 0] | 0) << 16 | 0 | ((HEAPU8[($3_1 + 3 | 0) >> 0] | 0) << 24 | 0) | 0) | 0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $22(i) {
  i = i | 0;
  var $3_1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  $3_1 = i;
  i64toi32_i32$0 = HEAPU8[($3_1 + 1 | 0) >> 0] | 0 | ((HEAPU8[($3_1 + 2 | 0) >> 0] | 0) << 8 | 0) | 0 | ((HEAPU8[($3_1 + 3 | 0) >> 0] | 0) << 16 | 0 | ((HEAPU8[($3_1 + 4 | 0) >> 0] | 0) << 24 | 0) | 0) | 0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $23(i) {
  i = i | 0;
  var $3_1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  $3_1 = i;
  i64toi32_i32$0 = HEAPU16[($3_1 + 2 | 0) >> 1] | 0 | ((HEAPU16[($3_1 + 4 | 0) >> 1] | 0) << 16 | 0) | 0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $24(i) {
  i = i | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = HEAP32[(i + 25 | 0) >> 2] | 0;
  i64toi32_i32$1 = 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $25(i) {
  i = i | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = HEAP32[i >> 2] | 0;
  i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $26(i) {
  i = i | 0;
  var $3_1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  $3_1 = i;
  i64toi32_i32$0 = HEAPU8[$3_1 >> 0] | 0 | ((HEAPU8[($3_1 + 1 | 0) >> 0] | 0) << 8 | 0) | 0 | ((HEAPU8[($3_1 + 2 | 0) >> 0] | 0) << 16 | 0 | ((HEAPU8[($3_1 + 3 | 0) >> 0] | 0) << 24 | 0) | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $27(i) {
  i = i | 0;
  var $3_1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  $3_1 = i;
  i64toi32_i32$0 = HEAPU8[($3_1 + 1 | 0) >> 0] | 0 | ((HEAPU8[($3_1 + 2 | 0) >> 0] | 0) << 8 | 0) | 0 | ((HEAPU8[($3_1 + 3 | 0) >> 0] | 0) << 16 | 0 | ((HEAPU8[($3_1 + 4 | 0) >> 0] | 0) << 24 | 0) | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $28(i) {
  i = i | 0;
  var $3_1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  $3_1 = i;
  i64toi32_i32$0 = HEAPU16[($3_1 + 2 | 0) >> 1] | 0 | ((HEAPU16[($3_1 + 4 | 0) >> 1] | 0) << 16 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $29(i) {
  i = i | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = HEAP32[(i + 25 | 0) >> 2] | 0;
  i64toi32_i32$1 = i64toi32_i32$0 >> 31 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $30(i) {
  i = i | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$2 = i;
  i64toi32_i32$0 = HEAP32[i64toi32_i32$2 >> 2] | 0;
  i64toi32_i32$1 = HEAP32[(i64toi32_i32$2 + 4 | 0) >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $31(i) {
  i = i | 0;
  var $3_1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  $3_1 = i;
  i64toi32_i32$0 = HEAPU8[$3_1 >> 0] | 0 | ((HEAPU8[($3_1 + 1 | 0) >> 0] | 0) << 8 | 0) | 0 | ((HEAPU8[($3_1 + 2 | 0) >> 0] | 0) << 16 | 0 | ((HEAPU8[($3_1 + 3 | 0) >> 0] | 0) << 24 | 0) | 0) | 0;
  i64toi32_i32$1 = HEAPU8[($3_1 + 4 | 0) >> 0] | 0 | ((HEAPU8[($3_1 + 5 | 0) >> 0] | 0) << 8 | 0) | 0 | ((HEAPU8[($3_1 + 6 | 0) >> 0] | 0) << 16 | 0 | ((HEAPU8[($3_1 + 7 | 0) >> 0] | 0) << 24 | 0) | 0) | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $32(i) {
  i = i | 0;
  var $3_1 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  $3_1 = i;
  i64toi32_i32$0 = HEAPU8[($3_1 + 1 | 0) >> 0] | 0 | ((HEAPU8[($3_1 + 2 | 0) >> 0] | 0) << 8 | 0) | 0 | ((HEAPU8[($3_1 + 3 | 0) >> 0] | 0) << 16 | 0 | ((HEAPU8[($3_1 + 4 | 0) >> 0] | 0) << 24 | 0) | 0) | 0;
  i64toi32_i32$1 = HEAPU8[($3_1 + 5 | 0) >> 0] | 0 | ((HEAPU8[($3_1 + 6 | 0) >> 0] | 0) << 8 | 0) | 0 | ((HEAPU8[($3_1 + 7 | 0) >> 0] | 0) << 16 | 0 | ((HEAPU8[($3_1 + 8 | 0) >> 0] | 0) << 24 | 0) | 0) | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $33(i) {
  i = i | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$2 = i;
  i64toi32_i32$0 = HEAPU16[(i64toi32_i32$2 + 2 | 0) >> 1] | 0 | ((HEAPU16[(i64toi32_i32$2 + 4 | 0) >> 1] | 0) << 16 | 0) | 0;
  i64toi32_i32$1 = HEAPU16[(i64toi32_i32$2 + 6 | 0) >> 1] | 0 | ((HEAPU16[(i64toi32_i32$2 + 8 | 0) >> 1] | 0) << 16 | 0) | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $34(i) {
  i = i | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$2 = i;
  i64toi32_i32$0 = HEAP32[(i64toi32_i32$2 + 25 | 0) >> 2] | 0;
  i64toi32_i32$1 = HEAP32[(i64toi32_i32$2 + 29 | 0) >> 2] | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$0 | 0;
 }
 
 function $35(i) {
  i = i | 0;
  HEAPU8[(i + 4294967295 | 0) >> 0] | 0;
 }
 
 function $36(i) {
  i = i | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = HEAP8[(i + 4294967295 | 0) >> 0] | 0;
 }
 
 function $37(i) {
  i = i | 0;
  HEAPU16[(i + 4294967295 | 0) >> 1] | 0;
 }
 
 function $38(i) {
  i = i | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = HEAP16[(i + 4294967295 | 0) >> 1] | 0;
 }
 
 function $39(i) {
  i = i | 0;
  HEAP32[(i + 4294967295 | 0) >> 2] | 0;
 }
 
 function $40(i) {
  i = i | 0;
  var i64toi32_i32$0 = 0;
  i64toi32_i32$0 = HEAP32[(i + 4294967295 | 0) >> 2] | 0;
 }
 
 function $41(i) {
  i = i | 0;
  var i64toi32_i32$2 = 0;
  i64toi32_i32$2 = i;
  HEAP32[(i64toi32_i32$2 + 3 | 0) >> 2] | 0;
  HEAP32[(i64toi32_i32$2 + 4294967295 | 0) >> 2] | 0;
 }
 
 function legalstub$0($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $0($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$1($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $1($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$2($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $2($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$3($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $3($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$4($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $4($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$5($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $5($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$6($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $6($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$7($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $7($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$8($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $8($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$9($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $9($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$10($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $10($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$11($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $11($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$12($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $12($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$13($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $13($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$14($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $14($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$15($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $15($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$16($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $16($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$17($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $17($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$18($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $18($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$19($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $19($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$20($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $20($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$21($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $21($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$22($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $22($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$23($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $23($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$24($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $24($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$25($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $25($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$26($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $26($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$27($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $27($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$28($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $28($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$29($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $29($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$30($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $30($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$31($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $31($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$32($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $32($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$33($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $33($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 function legalstub$34($0_1) {
  $0_1 = $0_1 | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$4 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $8_1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$2 = 0;
  i64toi32_i32$0 = $34($0_1 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$HIGH_BITS;
  $1_1 = i64toi32_i32$0;
  $1$hi = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = 0;
   $8_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$0 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $8_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($8_1 | 0);
  i64toi32_i32$0 = $1$hi;
  return $1_1 | 0;
 }
 
 var FUNCTION_TABLE = [];
 function __wasm_memory_size() {
  return buffer.byteLength / 65536 | 0;
 }
 
 function __wasm_memory_grow(pagesToAdd) {
  pagesToAdd = pagesToAdd | 0;
  var oldPages = __wasm_memory_size() | 0;
  var newPages = oldPages + pagesToAdd | 0;
  if ((oldPages < newPages) && (newPages < 65536)) {
   var newBuffer = new ArrayBuffer(Math_imul(newPages, 65536));
   var newHEAP8 = new global.Int8Array(newBuffer);
   newHEAP8.set(HEAP8);
   HEAP8 = newHEAP8;
   HEAP8 = new global.Int8Array(newBuffer);
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
 
 return {
  "$8u_good1": legalstub$0, 
  "$8u_good2": legalstub$1, 
  "$8u_good3": legalstub$2, 
  "$8u_good4": legalstub$3, 
  "$8u_good5": legalstub$4, 
  "$8s_good1": legalstub$5, 
  "$8s_good2": legalstub$6, 
  "$8s_good3": legalstub$7, 
  "$8s_good4": legalstub$8, 
  "$8s_good5": legalstub$9, 
  "$16u_good1": legalstub$10, 
  "$16u_good2": legalstub$11, 
  "$16u_good3": legalstub$12, 
  "$16u_good4": legalstub$13, 
  "$16u_good5": legalstub$14, 
  "$16s_good1": legalstub$15, 
  "$16s_good2": legalstub$16, 
  "$16s_good3": legalstub$17, 
  "$16s_good4": legalstub$18, 
  "$16s_good5": legalstub$19, 
  "$32u_good1": legalstub$20, 
  "$32u_good2": legalstub$21, 
  "$32u_good3": legalstub$22, 
  "$32u_good4": legalstub$23, 
  "$32u_good5": legalstub$24, 
  "$32s_good1": legalstub$25, 
  "$32s_good2": legalstub$26, 
  "$32s_good3": legalstub$27, 
  "$32s_good4": legalstub$28, 
  "$32s_good5": legalstub$29, 
  "$64_good1": legalstub$30, 
  "$64_good2": legalstub$31, 
  "$64_good3": legalstub$32, 
  "$64_good4": legalstub$33, 
  "$64_good5": legalstub$34, 
  "$8u_bad": $35, 
  "$8s_bad": $36, 
  "$16u_bad": $37, 
  "$16s_bad": $38, 
  "$32u_bad": $39, 
  "$32s_bad": $40, 
  "$64_bad": $41
 };
}

var memasmFunc = new ArrayBuffer(65536);
var assignasmFunc = (
    function(mem) {
      var _mem = new Uint8Array(mem);
      return function(offset, s) {
        var bytes, i;
        if (typeof Buffer === 'undefined') {
          bytes = atob(s);
          for (i = 0; i < bytes.length; i++)
            _mem[offset + i] = bytes.charCodeAt(i);
        } else {
          bytes = Buffer.from(s, 'base64');
          for (i = 0; i < bytes.length; i++)
            _mem[offset + i] = bytes[i];
        }
      }
    }
  )(memasmFunc);
assignasmFunc(0, "YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXo=");
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0},memasmFunc);
export var $8u_good1 = retasmFunc.$8u_good1;
export var $8u_good2 = retasmFunc.$8u_good2;
export var $8u_good3 = retasmFunc.$8u_good3;
export var $8u_good4 = retasmFunc.$8u_good4;
export var $8u_good5 = retasmFunc.$8u_good5;
export var $8s_good1 = retasmFunc.$8s_good1;
export var $8s_good2 = retasmFunc.$8s_good2;
export var $8s_good3 = retasmFunc.$8s_good3;
export var $8s_good4 = retasmFunc.$8s_good4;
export var $8s_good5 = retasmFunc.$8s_good5;
export var $16u_good1 = retasmFunc.$16u_good1;
export var $16u_good2 = retasmFunc.$16u_good2;
export var $16u_good3 = retasmFunc.$16u_good3;
export var $16u_good4 = retasmFunc.$16u_good4;
export var $16u_good5 = retasmFunc.$16u_good5;
export var $16s_good1 = retasmFunc.$16s_good1;
export var $16s_good2 = retasmFunc.$16s_good2;
export var $16s_good3 = retasmFunc.$16s_good3;
export var $16s_good4 = retasmFunc.$16s_good4;
export var $16s_good5 = retasmFunc.$16s_good5;
export var $32u_good1 = retasmFunc.$32u_good1;
export var $32u_good2 = retasmFunc.$32u_good2;
export var $32u_good3 = retasmFunc.$32u_good3;
export var $32u_good4 = retasmFunc.$32u_good4;
export var $32u_good5 = retasmFunc.$32u_good5;
export var $32s_good1 = retasmFunc.$32s_good1;
export var $32s_good2 = retasmFunc.$32s_good2;
export var $32s_good3 = retasmFunc.$32s_good3;
export var $32s_good4 = retasmFunc.$32s_good4;
export var $32s_good5 = retasmFunc.$32s_good5;
export var $64_good1 = retasmFunc.$64_good1;
export var $64_good2 = retasmFunc.$64_good2;
export var $64_good3 = retasmFunc.$64_good3;
export var $64_good4 = retasmFunc.$64_good4;
export var $64_good5 = retasmFunc.$64_good5;
export var $8u_bad = retasmFunc.$8u_bad;
export var $8s_bad = retasmFunc.$8s_bad;
export var $16u_bad = retasmFunc.$16u_bad;
export var $16s_bad = retasmFunc.$16s_bad;
export var $32u_bad = retasmFunc.$32u_bad;
export var $32s_bad = retasmFunc.$32s_bad;
export var $64_bad = retasmFunc.$64_bad;


  var scratchBuffer = new ArrayBuffer(8);
  var i32ScratchView = new Int32Array(scratchBuffer);
  var f32ScratchView = new Float32Array(scratchBuffer);
  var f64ScratchView = new Float64Array(scratchBuffer);
  
  function wasm2js_scratch_store_i32(index, value) {
    i32ScratchView[index] = value;
  }
      
  function wasm2js_scratch_load_f32() {
    return f32ScratchView[0];
  }
      
function asmFunc(global, env, buffer) {
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
 function $0(i) {
  i = i | 0;
  return Math_fround(Math_fround(HEAPF32[i >> 2]));
 }
 
 function $1(i) {
  i = i | 0;
  var $1_1 = 0;
  $1_1 = i;
  return Math_fround((wasm2js_scratch_store_i32(0, HEAPU8[$1_1 >> 0] | 0 | ((HEAPU8[($1_1 + 1 | 0) >> 0] | 0) << 8 | 0) | 0 | ((HEAPU8[($1_1 + 2 | 0) >> 0] | 0) << 16 | 0 | ((HEAPU8[($1_1 + 3 | 0) >> 0] | 0) << 24 | 0) | 0) | 0), wasm2js_scratch_load_f32()));
 }
 
 function $2(i) {
  i = i | 0;
  var $1_1 = 0;
  $1_1 = i;
  return Math_fround((wasm2js_scratch_store_i32(0, HEAPU8[($1_1 + 1 | 0) >> 0] | 0 | ((HEAPU8[($1_1 + 2 | 0) >> 0] | 0) << 8 | 0) | 0 | ((HEAPU8[($1_1 + 3 | 0) >> 0] | 0) << 16 | 0 | ((HEAPU8[($1_1 + 4 | 0) >> 0] | 0) << 24 | 0) | 0) | 0), wasm2js_scratch_load_f32()));
 }
 
 function $3(i) {
  i = i | 0;
  var $1_1 = 0;
  $1_1 = i;
  return Math_fround((wasm2js_scratch_store_i32(0, HEAPU16[($1_1 + 2 | 0) >> 1] | 0 | ((HEAPU16[($1_1 + 4 | 0) >> 1] | 0) << 16 | 0) | 0), wasm2js_scratch_load_f32()));
 }
 
 function $4(i) {
  i = i | 0;
  return Math_fround(Math_fround(HEAPF32[(i + 8 | 0) >> 2]));
 }
 
 function $5(i) {
  i = i | 0;
  Math_fround(HEAPF32[(i + 4294967295 | 0) >> 2]);
 }
 
 var FUNCTION_TABLE = [];
 function __wasm_memory_size() {
  return buffer.byteLength / 65536 | 0;
 }
 
 function __wasm_memory_grow(pagesToAdd) {
  pagesToAdd = pagesToAdd | 0;
  var oldPages = __wasm_memory_size() | 0;
  var newPages = oldPages + pagesToAdd | 0;
  if ((oldPages < newPages) && (newPages < 65536)) {
   var newBuffer = new ArrayBuffer(Math_imul(newPages, 65536));
   var newHEAP8 = new global.Int8Array(newBuffer);
   newHEAP8.set(HEAP8);
   HEAP8 = newHEAP8;
   HEAP8 = new global.Int8Array(newBuffer);
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
 
 return {
  "$32_good1": $0, 
  "$32_good2": $1, 
  "$32_good3": $2, 
  "$32_good4": $3, 
  "$32_good5": $4, 
  "$32_bad": $5
 };
}

var memasmFunc = new ArrayBuffer(65536);
var assignasmFunc = (
    function(mem) {
      var _mem = new Uint8Array(mem);
      return function(offset, s) {
        var bytes, i;
        if (typeof Buffer === 'undefined') {
          bytes = atob(s);
          for (i = 0; i < bytes.length; i++)
            _mem[offset + i] = bytes.charCodeAt(i);
        } else {
          bytes = Buffer.from(s, 'base64');
          for (i = 0; i < bytes.length; i++)
            _mem[offset + i] = bytes[i];
        }
      }
    }
  )(memasmFunc);
assignasmFunc(0, "AAAAAAAAoH8BANB/");
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export var $32_good1 = retasmFunc.$32_good1;
export var $32_good2 = retasmFunc.$32_good2;
export var $32_good3 = retasmFunc.$32_good3;
export var $32_good4 = retasmFunc.$32_good4;
export var $32_good5 = retasmFunc.$32_good5;
export var $32_bad = retasmFunc.$32_bad;


  var scratchBuffer = new ArrayBuffer(8);
  var i32ScratchView = new Int32Array(scratchBuffer);
  var f32ScratchView = new Float32Array(scratchBuffer);
  var f64ScratchView = new Float64Array(scratchBuffer);
  
  function wasm2js_scratch_store_i32(index, value) {
    i32ScratchView[index] = value;
  }
      
  function wasm2js_scratch_load_f64() {
    return f64ScratchView[0];
  }
      
function asmFunc(global, env, buffer) {
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
 function $0(i) {
  i = i | 0;
  return +(+HEAPF64[i >> 3]);
 }
 
 function $1(i) {
  i = i | 0;
  var $2_1 = 0, i64toi32_i32$1 = 0;
  $2_1 = i;
  i64toi32_i32$1 = HEAPU8[($2_1 + 4 | 0) >> 0] | 0 | ((HEAPU8[($2_1 + 5 | 0) >> 0] | 0) << 8 | 0) | 0 | ((HEAPU8[($2_1 + 6 | 0) >> 0] | 0) << 16 | 0 | ((HEAPU8[($2_1 + 7 | 0) >> 0] | 0) << 24 | 0) | 0) | 0;
  wasm2js_scratch_store_i32(0 | 0, HEAPU8[$2_1 >> 0] | 0 | ((HEAPU8[($2_1 + 1 | 0) >> 0] | 0) << 8 | 0) | 0 | ((HEAPU8[($2_1 + 2 | 0) >> 0] | 0) << 16 | 0 | ((HEAPU8[($2_1 + 3 | 0) >> 0] | 0) << 24 | 0) | 0) | 0 | 0);
  wasm2js_scratch_store_i32(1 | 0, i64toi32_i32$1 | 0);
  return +(+wasm2js_scratch_load_f64());
 }
 
 function $2(i) {
  i = i | 0;
  var $2_1 = 0, i64toi32_i32$1 = 0;
  $2_1 = i;
  i64toi32_i32$1 = HEAPU8[($2_1 + 5 | 0) >> 0] | 0 | ((HEAPU8[($2_1 + 6 | 0) >> 0] | 0) << 8 | 0) | 0 | ((HEAPU8[($2_1 + 7 | 0) >> 0] | 0) << 16 | 0 | ((HEAPU8[($2_1 + 8 | 0) >> 0] | 0) << 24 | 0) | 0) | 0;
  wasm2js_scratch_store_i32(0 | 0, HEAPU8[($2_1 + 1 | 0) >> 0] | 0 | ((HEAPU8[($2_1 + 2 | 0) >> 0] | 0) << 8 | 0) | 0 | ((HEAPU8[($2_1 + 3 | 0) >> 0] | 0) << 16 | 0 | ((HEAPU8[($2_1 + 4 | 0) >> 0] | 0) << 24 | 0) | 0) | 0 | 0);
  wasm2js_scratch_store_i32(1 | 0, i64toi32_i32$1 | 0);
  return +(+wasm2js_scratch_load_f64());
 }
 
 function $3(i) {
  i = i | 0;
  var $2_1 = 0, i64toi32_i32$1 = 0;
  $2_1 = i;
  i64toi32_i32$1 = HEAPU16[($2_1 + 6 | 0) >> 1] | 0 | ((HEAPU16[($2_1 + 8 | 0) >> 1] | 0) << 16 | 0) | 0;
  wasm2js_scratch_store_i32(0 | 0, HEAPU16[($2_1 + 2 | 0) >> 1] | 0 | ((HEAPU16[($2_1 + 4 | 0) >> 1] | 0) << 16 | 0) | 0 | 0);
  wasm2js_scratch_store_i32(1 | 0, i64toi32_i32$1 | 0);
  return +(+wasm2js_scratch_load_f64());
 }
 
 function $4(i) {
  i = i | 0;
  return +(+HEAPF64[(i + 18 | 0) >> 3]);
 }
 
 function $5(i) {
  i = i | 0;
  +HEAPF64[(i + 4294967295 | 0) >> 3];
 }
 
 var FUNCTION_TABLE = [];
 function __wasm_memory_size() {
  return buffer.byteLength / 65536 | 0;
 }
 
 function __wasm_memory_grow(pagesToAdd) {
  pagesToAdd = pagesToAdd | 0;
  var oldPages = __wasm_memory_size() | 0;
  var newPages = oldPages + pagesToAdd | 0;
  if ((oldPages < newPages) && (newPages < 65536)) {
   var newBuffer = new ArrayBuffer(Math_imul(newPages, 65536));
   var newHEAP8 = new global.Int8Array(newBuffer);
   newHEAP8.set(HEAP8);
   HEAP8 = newHEAP8;
   HEAP8 = new global.Int8Array(newBuffer);
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
 
 return {
  "$64_good1": $0, 
  "$64_good2": $1, 
  "$64_good3": $2, 
  "$64_good4": $3, 
  "$64_good5": $4, 
  "$64_bad": $5
 };
}

var memasmFunc = new ArrayBuffer(65536);
var assignasmFunc = (
    function(mem) {
      var _mem = new Uint8Array(mem);
      return function(offset, s) {
        var bytes, i;
        if (typeof Buffer === 'undefined') {
          bytes = atob(s);
          for (i = 0; i < bytes.length; i++)
            _mem[offset + i] = bytes.charCodeAt(i);
        } else {
          bytes = Buffer.from(s, 'base64');
          for (i = 0; i < bytes.length; i++)
            _mem[offset + i] = bytes[i];
        }
      }
    }
  )(memasmFunc);
assignasmFunc(0, "AAAAAAAAAAAAAAAAAAAAAPR/AQAAAAAA/H8=");
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export var $64_good1 = retasmFunc.$64_good1;
export var $64_good2 = retasmFunc.$64_good2;
export var $64_good3 = retasmFunc.$64_good3;
export var $64_good4 = retasmFunc.$64_good4;
export var $64_good5 = retasmFunc.$64_good5;
export var $64_bad = retasmFunc.$64_bad;
