function instantiate(asmLibraryArg, wasmMemory, wasmTable) {

function asmFunc(global, env, buffer) {
 var memory = env.memory;
 var FUNCTION_TABLE = wasmTable;
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
 var syscall$6 = env.__syscall6;
 var syscall$54 = env.__syscall54;
 // EMSCRIPTEN_START_FUNCS;
 function main() {
  syscall$6(1 | 0, 2 | 0) | 0;
  syscall$54(3 | 0, 4 | 0) | 0;
  FUNCTION_TABLE[HEAP32[(0 + 1030 | 0) >> 2] | 0]();
  internal(1 | 0) | 0;
  tabled(1 | 0) | 0;
  exported(1 | 0) | 0;
 }
 
 function other() {
  main();
 }
 
 function foo() {
  abort();
 }
 
 function bar() {
  HEAPU8[128 >> 0] | 0;
  HEAP8[128 >> 0] | 0;
  HEAPU16[128 >> 1] | 0;
  HEAP16[128 >> 1] | 0;
  HEAP32[16 >> 2] = 1 + 2 | 0;
  HEAPF32[16 >> 2] = Math_fround(Math_fround(3.0) + Math_fround(4.0));
  HEAPF64[16 >> 3] = 5.0 + 6.0;
  HEAP8[16 >> 0] = 7 + 8 | 0;
  HEAP16[16 >> 1] = 9 + 10 | 0;
  if ((HEAP32[100 >> 2] | 0 | 0) == (1 | 0)) {
   bar()
  }
  if ((HEAP32[104 >> 2] | 0 | 0) < (2 | 0)) {
   bar()
  }
  if ((HEAP32[108 >> 2] | 0) >>> 0 < 3 >>> 0) {
   bar()
  }
  if ((HEAP16[112 >> 1] | 0 | 0) == (1 | 0)) {
   bar()
  }
  if ((HEAP16[116 >> 1] | 0 | 0) < (2 | 0)) {
   bar()
  }
  if ((HEAPU16[120 >> 1] | 0 | 0) < (2 | 0)) {
   bar()
  }
  if ((HEAP16[124 >> 1] | 0) >>> 0 < 3 >>> 0) {
   bar()
  }
  if ((HEAPU16[128 >> 1] | 0) >>> 0 < 3 >>> 0) {
   bar()
  }
  if ((HEAP8[132 >> 0] | 0 | 0) < (2 | 0)) {
   bar()
  }
  if ((HEAPU8[136 >> 0] | 0 | 0) < (2 | 0)) {
   bar()
  }
  if ((HEAP8[140 >> 0] | 0) >>> 0 < 3 >>> 0) {
   bar()
  }
  if ((HEAPU8[144 >> 0] | 0) >>> 0 < 3 >>> 0) {
   bar()
  }
  if ((bools(314159 | 0) | 0) >>> 7 | 0) {
   bar()
  }
  if ((bools(314159 | 0) | 0) >> 8 | 0) {
   bar()
  }
  if (~~Math_fround(getf32()) >>> 0) {
   bar()
  }
  if (~~Math_fround(getf32())) {
   bar()
  }
  if (~~+getf64() >>> 0) {
   bar()
  }
  if (~~+getf64()) {
   bar()
  }
  if (((geti32() | 0) + (geti32() | 0) | 0) + (geti32() | 0) | 0) {
   bar()
  }
  if ((geti32() | 0) + ((geti32() | 0) + (geti32() | 0) | 0) | 0) {
   bar()
  }
  if (((geti32() | 0) + (geti32() | 0) | 0) + ((geti32() | 0) + (geti32() | 0) | 0) | 0) {
   bar()
  }
  if ((((geti32() | 0) + (geti32() | 0) | 0) + ((geti32() | 0) + (geti32() | 0) | 0) | 0) + (((geti32() | 0) + (geti32() | 0) | 0) + ((geti32() | 0) + (geti32() | 0) | 0) | 0) | 0) {
   bar()
  }
 }
 
 function geti32() {
  return geti32() | 0 | 0;
 }
 
 function getf32() {
  return Math_fround(Math_fround(getf32()));
 }
 
 function getf64() {
  return +(+getf64());
 }
 
 function __growWasmMemory($0) {
  $0 = $0 | 0;
  return abort() | 0;
 }
 
 function internal(x) {
  x = x | 0;
  return x | 0;
 }
 
 function tabled(x) {
  x = x | 0;
  return x | 0;
 }
 
 function exported(x) {
  x = x | 0;
  return x | 0;
 }
 
 function sub_zero(x) {
  x = x | 0;
  return x - -5 | 0 | 0;
 }
 
 function select(x) {
  x = x | 0;
  var wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0;
  return (wasm2js_i32$0 = x, wasm2js_i32$1 = HEAP32[16 >> 2] | 0, wasm2js_i32$2 = x, wasm2js_i32$2 ? wasm2js_i32$0 : wasm2js_i32$1) | 0;
 }
 
 function bools(x) {
  x = x | 0;
  bools((HEAPU8[0 >> 0] | 0) & 1 | 0 | 0) | 0;
  bools((HEAP8[0 >> 0] | 0) & 1 | 0 | 0) | 0;
  bools((HEAPU16[0 >> 1] | 0) & 1 | 0 | 0) | 0;
  bools((HEAP16[0 >> 1] | 0) & 1 | 0 | 0) | 0;
  bools((HEAP32[0 >> 2] | 0) & 1 | 0 | 0) | 0;
  bools((HEAPU8[0 >> 0] | 0) & 2 | 0 | 0) | 0;
  bools(x ^ 1 | 0 | 0) | 0;
  if (x ^ 1 | 0) {
   bools(2 | 0) | 0
  }
  if (x ^ 2 | 0) {
   bools(2 | 0) | 0
  }
  bools(!(x ^ 1 | 0) | 0) | 0;
  abort();
 }
 
 // EMSCRIPTEN_END_FUNCS;
 FUNCTION_TABLE[1] = foo;
 FUNCTION_TABLE[2] = bar;
 FUNCTION_TABLE[3] = tabled;
 function __wasm_memory_size() {
  return buffer.byteLength / 65536 | 0;
 }
 
 return {
  "main": main, 
  "other": other, 
  "__growWasmMemory": __growWasmMemory, 
  "exported": exported, 
  "sub_zero": sub_zero, 
  "select": select, 
  "bools": bools
 };
}

var writeSegment = (
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
  )(wasmMemory.buffer);
writeSegment(1024, "aGVsbG8sIHdvcmxkIQoAAJwMAAAtKyAgIDBYMHgAKG51bGwpAAAAAAAAAAAAAAAAEQAKABEREQAAAAAFAAAAAAAACQAAAAALAAAAAAAAAAARAA8KERERAwoHAAETCQsLAAAJBgsAAAsABhEAAAAREREAAAAAAAAAAAAAAAAAAAAACwAAAAAAAAAAEQAKChEREQAKAAACAAkLAAAACQALAAALAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwAAAAAAAAAAAAAAAwAAAAADAAAAAAJDAAAAAAADAAADAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOAAAAAAAAAAAAAAANAAAABA0AAAAACQ4AAAAAAA4AAA4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAADwAAAAAPAAAAAAkQAAAAAAAQAAAQAAASAAAAEhISAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABIAAAASEhIAAAAAAAAJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALAAAAAAAAAAAAAAAKAAAAAAoAAAAACQsAAAAAAAsAAAsAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADAAAAAAAAAAAAAAADAAAAAAMAAAAAAkMAAAAAAAMAAAMAAAwMTIzNDU2Nzg5QUJDREVGLTBYKzBYIDBYLTB4KzB4IDB4AGluZgBJTkYAbmFuAE5BTgAuAA==");
writeSegment(1600, "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=");
return asmFunc({
    'Int8Array': Int8Array,
    'Int16Array': Int16Array,
    'Int32Array': Int32Array,
    'Uint8Array': Uint8Array,
    'Uint16Array': Uint16Array,
    'Uint32Array': Uint32Array,
    'Float32Array': Float32Array,
    'Float64Array': Float64Array,
    'NaN': NaN,
    'Infinity': Infinity,
    'Math': Math
  },
  asmLibraryArg,
  wasmMemory.buffer
)

}