function (global, env, buffer) {
  "use asm";

  var c = new global.Int32Array(buffer);
  var g = new global.Float32Array(buffer);

  var fr = global.Math.fround;

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

  return { floats: floats };
}

