function (global, env, buffer) {
  "use asm";

  var c = new global.Int32Array(buffer);
  var g = new global.Float32Array(buffer);

  var fr = global.Math.fround;

  var tDP = env.tempDoublePtr | 0;
  var ctz32 = env._llvm_cttz_i32;

  var h8 = new global.Int8Array(buffer);
  var h16 = new global.Int16Array(buffer);
  var h32 = new global.Int32Array(buffer);
  var hU8 = new global.Uint8Array(buffer);
  var hU16 = new global.Uint16Array(buffer);
  var hU32 = new global.Uint32Array(buffer);
  var hF32 = new global.Float32Array(buffer);
  var hF64 = new global.Float64Array(buffer);

  var M = 0; // tempRet

  function floats(f) {
    f = fr(f);
    var t = fr(0);
    return fr(t + f);
  }
  function neg(k, p) {
    k = k | 0;
    p = p | 0;
    var n = fr(0);
    n = fr(-(c[k >> 2] = p, fr(g[k >> 2])));
    return n;
  }
  function bitcasts(i, f) {
    i = i | 0;
    f = Math_fround(f);
    (h32[tDP >> 2] = i, fr(hF32[tDP >> 2])); // i32->f32
    (h32[tDP >> 2] = i, +hF32[tDP >> 2]); // i32->f32, no fround
    (hF32[tDP >> 2] = f, h32[tDP >> 2] | 0); // f32->i32
  }
  function ctzzzz() {
    return ctz32(0x1234) | 0;
  }
  function ub() {
    ub(); // emterpreter assertions mode might add some code here
    return M | 0;
  }

  return { floats: floats, getTempRet0: ub, neg: neg, bitcasts: bitcasts, ctzzzz: ctzzzz };
}

