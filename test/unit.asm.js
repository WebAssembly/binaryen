function () {
  "use asm";

  var t = global.NaN, u = global.Infinity;
  var Int = 0;
  var Double = 0.0;
  var Math_fround = global.Math.fround;
  var Math_abs = global.Math.abs;

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
  function switcher(x) {
    x = x | 0;
    switch (x | 0) {
      case 1: return 1;
      case 2: return 2;
    }
    switch (x | 0) {
      case 12: return 121;
      case 5: return 51;
    }
    Lout: switch (x | 0) {
      case 12: break;
      case 10: break Lout;
      case 5: {
        while (1) {
          break;
        }
        break;
      }
      case 2: {
        while (1) {
          break Lout;
        }
        break;
      }
    }
    return 0;
  }
  function blocker() {
    L: {
      break L;
    }
  }
  function frem() {
    return +(5.5 % 1.2);
  }
  function big_uint_div_u() {
    var x = 0;
    x = (4294967295 / 2)&-1;
    return x | 0;
  }
  function fr(x) {
    x = Math_fround(x);
    var y = Math_fround(0), z = 0.0;
    Math_fround(z);
    Math_fround(y);
    Math_fround(5);
    Math_fround(0);
    Math_fround(5.0);
    Math_fround(0.0);
  }
  function negZero() {
    return +-0;
  }
  function abs() {
    var x = 0, y = 0.0, z = Math_fround(0);
    x = Math_abs(0) | 0;
    y = +Math_abs(0.0);
    z = Math_fround(Math_abs(Math_fround(0)));
  }
  function neg() {
    var x = Math_fround(0);
    x = -x;
    FUNCTION_TABLE_c[1 & 7](x);
  }
  function cneg(x) {
    x = Math_fround(x);
    FUNCTION_TABLE_c[1 & 7](x);
  }
  function ___syscall_ret() {
   var $0 = 0;
   ($0>>>0) > 4294963200; // -4096
  }
  function smallCompare() {
    var i = 0, j = 0;
    if ((i | 0) < (j | 0)) i = i + 1 | 0;
    if ((i >>> 0) < (j >>> 0)) i = i + 1 | 0;
    return i | 0;
  }
  function cneg_nosemicolon() {
    FUNCTION_TABLE_c[1 & 7](1) // no semicolon
  }

  function z() {
  }
  function w() {
  }

  var FUNCTION_TABLE_a = [ z, big_negative, z, z ];
  var FUNCTION_TABLE_b = [ w, w, importedDoubles, w ];
  var FUNCTION_TABLE_c = [ z, cneg ];

  return { big_negative: big_negative };
}

