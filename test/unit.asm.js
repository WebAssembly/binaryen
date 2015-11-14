function () {
  "use asm";

  var t = global.NaN, u = global.Infinity;
  var Int = 0;
  var Double = 0.0;

  function big_negative() {
    var temp = 0.0;
    temp = +-2147483648;
    temp = -2147483648.0;
    temp = -21474836480.0;
    temp = 0.039625;
    temp = -0.039625;
  }
  function importedDoubles() {
    var temp = 0.0;
    temp = t + u + (-u) + (-t);
    if (Int > 0) return -3.4;
    if (Double > 0.0) return 5.6;
    return 1.2;
  }
  function doubleCompares(x, y) {
    x = +x;
    y = +y;
    var t = +0;
    var Int = 0.0, Double = 0; // confusing with globals
    if (x > 0.0) return 1.2;
    if (Int > 0.0) return -3.4;
    if (Double > 0) return 5.6;
    if (x < y) return +x;
    return +y;
  }
  function intOps() {
    var x = 0;
    return !x;
  }
  function conversions() {
    var i = 0, d = 0.0;
    i = ~~d;
    d = +(i | 0);
    d = +(i >>> 0);
  }
  function seq() {
    var J = 0.0;
    J = (0.1, 5.1) - (3.2, 4.2);
  }

  function z() {
  }
  function w() {
  }

  var FUNCTION_TABLE_a = [ z, big_negative, z, z ];
  var FUNCTION_TABLE_b = [ w, w, importedDoubles, w ];

  return { big_negative: big_negative };
}

