
  var bufferView;
  var memorySegments = {};
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
memorySegments[0] = base64DecodeToExistingUint8Array(new Uint8Array(6), 0, "aGVsbG8s");
memorySegments[1] = base64DecodeToExistingUint8Array(new Uint8Array(6), 0, "d29ybGQh");

  function wasm2js_atomic_wait_i32(ptr, expected, timeoutLow, timeoutHigh) {
    var timeout = Infinity;
    if (timeoutHigh >= 0) {
      // Convert from nanoseconds to milliseconds
      // Taken from convertI32PairToI53 in emscripten's library_int53.js
      timeout = ((timeoutLow >>> 0) / 1e6) + timeoutHigh * (4294967296 / 1e6);
    }
    var view = new Int32Array(bufferView.buffer); // TODO cache
    var result = Atomics.wait(view, ptr >> 2, expected, timeout);
    if (result == 'ok') return 0;
    if (result == 'not-equal') return 1;
    if (result == 'timed-out') return 2;
    throw 'bad result ' + result;
  }
      
  function wasm2js_atomic_rmw_i64(op, bytes, offset, ptr, valueLow, valueHigh) {
    // TODO: support bytes=1, 2, 4 as well as 8.
    var view = new BigInt64Array(bufferView.buffer); // TODO cache
    ptr = (ptr + offset) >> 3;
    var value = BigInt(valueLow >>> 0) | (BigInt(valueHigh >>> 0) << BigInt(32));
    var result;
    switch (op) {
      case 0: { // Add
        result = Atomics.add(view, ptr, value);
        break;
      }
      case 1: { // Sub
        result = Atomics.sub(view, ptr, value);
        break;
      }
      case 2: { // And
        result = Atomics.and(view, ptr, value);
        break;
      }
      case 3: { // Or
        result = Atomics.or(view, ptr, value);
        break;
      }
      case 4: { // Xor
        result = Atomics.xor(view, ptr, value);
        break;
      }
      case 5: { // Xchg
        result = Atomics.exchange(view, ptr, value);
        break;
      }
      default: throw 'bad op';
    }
    var low = Number(result & BigInt(0xffffffff)) | 0;
    var high = Number((result >> BigInt(32)) & BigInt(0xffffffff)) | 0;
    stashedBits = high;
    return low;
  }
      
  var stashedBits = 0;

  function wasm2js_get_stashed_bits() {
    return stashedBits;
  }
      
  function wasm2js_memory_init(segment, dest, offset, size) {
    // TODO: traps on invalid things
    bufferView.set(memorySegments[segment].subarray(offset, offset + size), dest);
  }
      
function asmFunc(imports) {
 var buffer = new ArrayBuffer(16777216);
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
 var nan = NaN;
 var infinity = Infinity;
 function $0() {
  var i64toi32_i32$0 = 0, i64toi32_i32$2 = 0, i64toi32_i32$1 = 0;
  Atomics.compareExchange(HEAP8, 1024, 1, 2) | 0;
  Atomics.compareExchange(HEAP16, 1024 >> 1, 1, 2) | 0;
  Atomics.compareExchange(HEAP32, 1024 >> 2, 1, 2) | 0;
  Atomics.load(HEAPU8, 1028 >> 0) | 0;
  Atomics.load(HEAPU16, 1028 >> 1) | 0;
  Atomics.load(HEAP32, 1028 >> 2) | 0;
  Atomics.store(HEAP32, 100 >> 2, 200);
  i64toi32_i32$0 = -1;
  wasm2js_atomic_wait_i32(4 | 0, 8 | 0, -1 | 0, i64toi32_i32$0 | 0) | 0;
  wasm2js_memory_init(0, 512, 0, 4);
  wasm2js_memory_init(1, 1024, 4, 2);
  Atomics.notify(HEAP32, 4 >> 2, 2);
  Atomics.notify(HEAP32, (4 + 20 | 0) >> 2, 2);
  Atomics.add(HEAP32, 8 >> 2, 12);
  Atomics.sub(HEAP32, 8 >> 2, 12);
  Atomics.and(HEAP32, 8 >> 2, 12);
  Atomics.or(HEAP32, 8 >> 2, 12);
  Atomics.xor(HEAP32, 8 >> 2, 12);
  Atomics.exchange(HEAP32, 8 >> 2, 12);
  Atomics.add(HEAP8, 8, 12);
  Atomics.sub(HEAP16, 8 >> 1, 12);
  i64toi32_i32$0 = 0;
  i64toi32_i32$1 = wasm2js_atomic_rmw_i64(0 | 0, 8 | 0, 0 | 0, 8 | 0, 16 | 0, i64toi32_i32$0 | 0) | 0;
  i64toi32_i32$2 = wasm2js_get_stashed_bits() | 0;
  i64toi32_i32$2 = -1;
  i64toi32_i32$1 = wasm2js_atomic_rmw_i64(4 | 0, 8 | 0, 32 | 0, 8 | 0, -1 | 0, i64toi32_i32$2 | 0) | 0;
  i64toi32_i32$0 = wasm2js_get_stashed_bits() | 0;
 }
 
 bufferView = HEAPU8;
 function __wasm_memory_size() {
  return buffer.byteLength / 65536 | 0;
 }
 
 return {
  "test": $0
 };
}

var retasmFunc = asmFunc({
});
export var test = retasmFunc.test;
