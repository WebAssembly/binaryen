import { memoryBase } from 'env';
import { tableBase } from 'env';

function asmFunc(global, env, buffer) {
 var memory = env.memory;
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
 var import$memoryBase = env.memoryBase | 0;
 var import$tableBase = env.tableBase | 0;
 function foo() {
  
 }
 
 function bar() {
  
 }
 
 function baz() {
  
 }
 
 var FUNCTION_TABLE = [];
 FUNCTION_TABLE[import$tableBase + 0] = foo;
 FUNCTION_TABLE[import$tableBase + 1] = bar;
 function __wasm_memory_size() {
  return buffer.byteLength / 65536 | 0;
 }
 
 return {
  "baz": baz
 };
}

var memasmFunc = new ArrayBuffer(16777216);
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
assignasmFunc(memoryBase, "ZHluYW1pYyBkYXRh");
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export var baz = retasmFunc.baz;
