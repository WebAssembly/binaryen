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
 function $0(i) {
  i = i | 0;
  print(HEAPU8[i >> 0] | 0 | 0);
  print(HEAPU8[(i + 1 | 0) >> 0] | 0 | 0);
  print(HEAPU8[(i + 2 | 0) >> 0] | 0 | 0);
  print(HEAPU8[(i + 25 | 0) >> 0] | 0 | 0);
  print(HEAPU16[i >> 1] | 0 | 0);
  print(HEAPU8[i >> 0] | 0 | ((HEAPU8[(i + 1 | 0) >> 0] | 0) << 8 | 0) | 0 | 0);
  print(HEAPU8[(i + 1 | 0) >> 0] | 0 | ((HEAPU8[(i + 2 | 0) >> 0] | 0) << 8 | 0) | 0 | 0);
  print(HEAPU16[(i + 2 | 0) >> 1] | 0 | 0);
  print(HEAPU8[(i + 25 | 0) >> 0] | 0 | ((HEAPU8[(i + 26 | 0) >> 0] | 0) << 8 | 0) | 0 | 0);
  print(HEAP32[i >> 2] | 0 | 0);
  print(HEAPU8[(i + 1 | 0) >> 0] | 0 | ((HEAPU8[(i + 2 | 0) >> 0] | 0) << 8 | 0) | 0 | ((HEAPU8[(i + 3 | 0) >> 0] | 0) << 16 | 0 | ((HEAPU8[(i + 4 | 0) >> 0] | 0) << 24 | 0) | 0) | 0 | 0);
  print(HEAPU16[(i + 2 | 0) >> 1] | 0 | ((HEAPU16[(i + 4 | 0) >> 1] | 0) << 16 | 0) | 0 | 0);
  print(HEAPU8[(i + 25 | 0) >> 0] | 0 | ((HEAPU8[(i + 26 | 0) >> 0] | 0) << 8 | 0) | 0 | ((HEAPU8[(i + 27 | 0) >> 0] | 0) << 16 | 0 | ((HEAPU8[(i + 28 | 0) >> 0] | 0) << 24 | 0) | 0) | 0 | 0);
 }
 
 function $1(i) {
  i = i | 0;
  HEAP32[(i + 4294967295 | 0) >> 2] | 0;
 }
 
 var FUNCTION_TABLE = [];
 function __wasm_grow_memory(pagesToAdd) {
  pagesToAdd = pagesToAdd | 0;
  var oldPages = __wasm_current_memory() | 0;
  var newPages = oldPages + pagesToAdd | 0;
  if ((oldPages < newPages) && (newPages < 65536)) {
   var newBuffer = new ArrayBuffer(Math_imul(newPages, 65536));
   var newHEAP8 = new global.Int8Array(newBuffer);
   newHEAP8.set(HEAP8);
   HEAP8 = newHEAP8;
   HEAP16 = new global.Int16Array(newBuffer);
   HEAP32 = new global.Int32Array(newBuffer);
   HEAPU8 = new global.Uint8Array(newBuffer);
   HEAPU16 = new global.Uint16Array(newBuffer);
   HEAPF32 = new global.Float32Array(newBuffer);
   HEAPF64 = new global.Float64Array(newBuffer);
   buffer = newBuffer;
  }
  return oldPages;
 }
 
 function __wasm_current_memory() {
  return buffer.byteLength / 65536 | 0;
 }
 
 return {
  "good": $0, 
  "bad": $1
 };
}

var memasmFunc = new ArrayBuffer(65536);
var assignasmFunc = (
    function(mem) {
      var _mem = new Uint8Array(mem);
      return function(offset, s) {
        if (typeof Buffer === 'undefined') {
          var bytes = atob(s);
          for (var i = 0; i < bytes.length; i++)
            _mem[offset + i] = bytes.charCodeAt(i);
        } else {
          var bytes = Buffer.from(s, 'base64');
          for (var i = 0; i < bytes.length; i++)
            _mem[offset + i] = bytes[i];
        }
      }
    }
  )(memasmFunc);
assignasmFunc(0, "YWJjZGVmZ2hpamtsbW5vcHFyc3R1dnd4eXo=");
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },print},memasmFunc);
export var good = retasmFunc.good;
export var bad = retasmFunc.bad;
