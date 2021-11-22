function instantiate(asmLibraryArg) {
  var bufferView;
  var base64ReverseLookup = new Uint8Array(123/*'z'+1*/);
  for (var i = 25; i >= 0; --i) {
    base64ReverseLookup[48+i] = 52+i; // '0-9'
    base64ReverseLookup[65+i] = i; // 'A-Z'
    base64ReverseLookup[97+i] = 26+i; // 'a-z'
  }
  base64ReverseLookup[43] = 62; // '+'
  base64ReverseLookup[47] = 63; // '/'
  /** @noinline Inlining this function would mean expanding the base64 string 4x times in the source code, which Closure seems to be happy to do. */
  function base64DecodeToExistingUint8Array(uint8Array, offset, b64) {
    var b1, b2, i = 0, j = offset, bLength = b64.length, end = offset + (bLength*3>>2) - (b64[bLength-2] == '=') - (b64[bLength-1] == '=');
    for (; i < bLength; i += 4) {
      b1 = base64ReverseLookup[b64.charCodeAt(i+1)];
      b2 = base64ReverseLookup[b64.charCodeAt(i+2)];
      uint8Array[j++] = base64ReverseLookup[b64.charCodeAt(i)] << 2 | b1 >> 4;
      if (j < end) uint8Array[j++] = b1 << 4 | b2 >> 2;
      if (j < end) uint8Array[j++] = b2 << 6 | base64ReverseLookup[b64.charCodeAt(i+3)];
    }
    return uint8Array;
  }
function initActiveSegments(imports) {
  base64DecodeToExistingUint8Array(bufferView, 1024, "aGVsbG8sIHdvcmxkIQoAAJwMAAAtKyAgIDBYMHgAKG51bGwpAAAAAAAAAAAAAAAAEQAKABEREQAAAAAFAAAAAAAACQAAAAALAAAAAAAAAAARAA8KERERAwoHAAETCQsLAAAJBgsAAAsABhEAAAAREREAAAAAAAAAAAAAAAAAAAAACwAAAAAAAAAAEQAKChEREQAKAAACAAkLAAAACQALAAALAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAwAAAAAAAAAAAAAAAwAAAAADAAAAAAJDAAAAAAADAAADAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAOAAAAAAAAAAAAAAANAAAABA0AAAAACQ4AAAAAAA4AAA4AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEAAAAAAAAAAAAAAADwAAAAAPAAAAAAkQAAAAAAAQAAAQAAASAAAAEhISAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABIAAAASEhIAAAAAAAAJAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALAAAAAAAAAAAAAAAKAAAAAAoAAAAACQsAAAAAAAsAAAsAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADAAAAAAAAAAAAAAADAAAAAAMAAAAAAkMAAAAAAAMAAAMAAAwMTIzNDU2Nzg5QUJDREVGLTBYKzBYIDBYLTB4KzB4IDB4AGluZgBJTkYAbmFuAE5BTgAuAA==");
  base64DecodeToExistingUint8Array(bufferView, 1600, "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=");
}
function asmFunc(env) {
 var buffer = new ArrayBuffer(16777216);
 var FUNCTION_TABLE = env.table;
 var HEAP8 = new Int8Array(buffer);
 var HEAP16 = new Int16Array(buffer);
 var HEAP32 = new Int32Array(buffer);
 var HEAPU8 = new Uint8Array(buffer);
 var HEAPU16 = new Uint16Array(buffer);
 var HEAPU32 = new Uint32Array(buffer);
 var HEAPF32 = new Float32Array(buffer);
 var HEAPF64 = new Float64Array(buffer);
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
 var syscall$6 = env.__syscall6;
 var syscall$54 = env.__syscall54;
 // EMSCRIPTEN_START_FUNCS
;
 function main() {
  syscall$6(1 | 0, 2 | 0) | 0;
  syscall$54(3 | 0, 4 | 0) | 0;
  FUNCTION_TABLE[HEAP32[(0 + 1030 | 0) >> 2] | 0 | 0]();
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
 
 // EMSCRIPTEN_END_FUNCS
;
 bufferView = HEAPU8;
 initActiveSegments(env);
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

  return asmFunc(asmLibraryArg);
}
