function () {
  "use asm";

  var fr = global.Math.fround;

  function floats(f) {
    f = fr(f);
    var t = fr(0);
    return fr(t + f);
  }

  return { floats: floats };
}

