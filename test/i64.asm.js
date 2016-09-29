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

  var fround = global.Math.fround;

  var illegalImport = env.illegalImport;

  function test() {
    var x = i64(), y = i64(), z = 0; // define i64 variables using special intrinsic
    var int32 = 0, float32 = fround(0), float64 = +0;
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
    // comps
    z = i64_eq(x, y);
    z = i64_ne(x, y);
    z = i64_ule(x, y);
    z = i64_sle(x, y);
    z = i64_uge(x, y);
    z = i64_sge(x, y);
    z = i64_ult(x, y);
    z = i64_slt(x, y);
    z = i64_ugt(x, y);
    z = i64_sgt(x, y);
    // convs
    int32 = i64_trunc(x);
    x = i64_sext(int32);
    x = i64_zext(int32);
    float32 = i64_s2f(x);
    float64 = i64_s2d(x);
    float32 = i64_u2f(x);
    float64 = i64_u2d(x);
    x = i64_f2s(float32);
    x = i64_d2s(float64);
    x = i64_f2u(float32);
    x = i64_d2u(float64);
    // bitcasts
    x = i64_bc2i(float64);
    float64 = i64_bc2d(x);
  }
  function imports() {
    illegalImport(-3.13159, i64_const(11, 22), -33); // this call must be legalized
  }
  function arg(x) { // illegal param, but not exported
    x = i64(x);
    i64_store(100, x, 0);
    arg(i64(x)); // "coercion"/"cast"
  }
  function illegalParam(a, x, c) {
    a = 0;
    x = i64(x);
    b = +0;
    i64_store(100, x, 0);
    illegalParam(0, i64(x), 12.34); // "coercion"/"cast"
  }
/*
  function result() { // illegal result, but not exported
    return i64_const(1, 2);
  }
  function illegalResult() { // illegal result, but not exported
    return i64_const(1, 2);
  }
*/
  function call1(x) {
    x = i64(x);
    var y = i64();
    y = call1(x);
    return i64(y); // return i64 with a "cast"
  }
  function call2(x) {
    x = i64(x);
    call2(call2(x));
    return i64_const(591726473, 57073); // return an i64 const
  }

  return { test: test, illegalParam : illegalParam, /* illegalResult: illegalResult */ };
}

