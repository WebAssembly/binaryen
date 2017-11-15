//
// Test wasm-only builds. In this case, fastcomp emits code that is
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

  var STACKTOP = env.STACKTOP | 0;

  var fround = global.Math.fround;
  var Math_imul = global.Math.imul;

  var illegalImport = env.illegalImport;
  var illegalImportResult = env.illegalImportResult;

  var _fabsf = env._fabsf;
  var do_i64 = env.do_i64;
  var abort = env.abort;

  function test64() {
    var x = i64(), y = i64(), z = 0; // define i64 variables using special intrinsic
    var int32 = 0, float32 = fround(0), float64 = +0;
    i64_atomics_store(4656, i64_const(92, 0))|0;
    x = i64_atomics_load(4656);
    y = i64_atomics_add(int32, i64_const(26, 0))|0;
    x = i64_atomics_sub(1024, y)|0;
    y = i64_atomics_and(1024, x)|0;
    x = i64_atomics_or(1024, y)|0;
    y = i64_atomics_xor(1024, x)|0;
    x = i64_atomics_exchange(1024, y)|0;
    y = i64_atomics_compareExchange(1024, x, y)|0;
    return x;
  }

  return { test64: test64 };
}

