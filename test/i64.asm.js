//
// Test i64 support in wasm-only builds. In this case, fastcomp emits code that is
// not asm.js, it will only ever run as wasm, and contains special intrinsics for
// asm2wasm that map LLVM IR into i64s.
//

function asm(global, env, buffer) {
  "use asm";

  var HEAP8 = new global.Int8Array(buffer);
  var HEAP16 = new global.Int16Array(buffer);
  var HEAP32 = new global.Int32Array(buffer);
  var HEAPU8 = new global.Uint8Array(buffer);
  var HEAPU16 = new global.Uint16Array(buffer);
  var HEAPU32 = new global.Uint32Array(buffer);
  var HEAPF32 = new global.Float32Array(buffer);
  var HEAPF64 = new global.Float64Array(buffer);

  function test() {
    var x = i64(), y = i64(); // define i64 variables using special intrinsic
    x = i64_const(100, 0); // i64 constant
    y = i64_const(17, 30);
    x = i64_add(x, y); // binaries
    x = i64_sub(x, y);
    x = i64_mul(x, y);
    x = i64_udiv(x, y);
    x = i64_sdiv(x, y);
    x = i64_urem(x, y);
    x = i64_srem(x, y);
    x = i64_and(x, y);
    x = i64_or(x, y);
    x = i64_xor(x, y);
    x = i64_shl(x, y);
    x = i64_ashr(x, y);
    x = i64_lshr(x, y);
    x = i64_load(120, 0); // load and store
    x = i64_load(120, 2);
    x = i64_load(120, 4);
    x = i64_load(120, 8);
    i64_store(120, x, 0);
    i64_store(120, x, 2);
    i64_store(120, x, 4);
    i64_store(120, x, 8);
  }

  return { test: test };
}

