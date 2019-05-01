function instantiate(asmLibraryArg, wasmMemory, FUNCTION_TABLE) {

function asmFunc(global, env, buffer) {
 "almost asm";
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
 }
 
 function __growWasmMemory($0) {
  $0 = $0 | 0;
  return abort() | 0;
 }
 
 function internal($0) {
  $0 = $0 | 0;
  return $0 | 0;
 }
 
 function tabled($0) {
  $0 = $0 | 0;
  return $0 | 0;
 }
 
 function exported($0) {
  $0 = $0 | 0;
  return $0 | 0;
 }
 
 function sub_zero($0) {
  $0 = $0 | 0;
  return $0 - -5 | 0 | 0;
 }
 
 // EMSCRIPTEN_END_FUNCS;
 FUNCTION_TABLE[1] = foo;
 FUNCTION_TABLE[2] = bar;
 FUNCTION_TABLE[3] = tabled;
 return {
  "main": main, 
  "other": other, 
  "__growWasmMemory": __growWasmMemory, 
  "exported": exported, 
  "sub_zero": sub_zero
 };
}

var writeSegment = (
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