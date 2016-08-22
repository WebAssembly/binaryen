function asm(global, env, buffer) {
  "use asm";

  var t = global.NaN, u = global.Infinity;
  var Int = 0;
  var Double = 0.0;
  var Math_fround = global.Math.fround;
  var Math_abs = global.Math.abs;
  var Math_ceil = global.Math.ceil;
  var tempDoublePtr = env.tempDoublePtr | 0;
  var n = env.gb | 0;
  var setTempRet0=env.setTempRet0;

  var abort = env.abort;
  var print = env.print;
  var h = env.h;

  var HEAP8 = new global.Int8Array(buffer);
  var HEAP16 = new global.Int16Array(buffer);
  var HEAP32 = new global.Int32Array(buffer);
  var HEAPU8 = new global.Uint8Array(buffer);
  var HEAPU16 = new global.Uint16Array(buffer);
  var HEAPU32 = new global.Uint32Array(buffer);
  var HEAPF32 = new global.Float32Array(buffer);
  var HEAPF64 = new global.Float64Array(buffer);

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
  function hexLiterals() {
    var i = 0;
    i = 0x0 + 0x12ABCdef + 0xFEDcba90;
  }
  function conversions() {
    var i = 0, d = 0.0, f = Math_fround(0);
    i = ~~d;
    i = ~~f;
    d = +(i | 0);
    d = +(i >>> 0);
  }
  function seq() {
    var J = 0.0;
    J = (0.1, 5.1) - (3.2, 4.2);
  }
  function switcher(x) {
    x = x | 0;
    var waka = 0;
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

    L1 : while (1) {
     L3 : while (1) switch (x) {
     case -1:
      {
       break L1;
       break;
      }
     case 116:
      {
       waka = 1;
       break;
      }
     case 110:
      {
       break L3;
       break;
      }
     default:
      {
       break L1;
      }
     }
     h(120);
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
  function forLoop() {
    var i = 0;
    for (i = 1; (i | 0) < 200; i = i + 1 | 0) {
      h(i | 0);
    }
  }
  function ceiling_32_64(u, B) {
    u = Math_fround(u);
    B = +B;
    var temp = Math_fround(0);
    temp = Math_fround(Math_ceil(B));
    temp = Math_fround(u * Math_fround(Math_ceil(Math_fround(B))));
  }
  function aborts() {
    abort();
    abort(55);
    abort();
    abort(12.34);
    abort(Math_fround(56.78));
  }
  function continues() {
    while (1) {
      print(1);
      do {
        print(5);
        if (0) continue;
      } while (0);
      print(2);
    }
  }
  function bitcasts(i, f) {
    i = i | 0;
    f = Math_fround(f);
    var d = 0.0;
    (HEAP32[tempDoublePtr >> 2] = i, Math_fround(HEAPF32[tempDoublePtr >> 2])); // i32->f32
    (HEAP32[tempDoublePtr >> 2] = i, +HEAPF32[tempDoublePtr >> 2]); // i32->f32, no fround
    (HEAPF32[tempDoublePtr >> 2] = f, HEAP32[tempDoublePtr >> 2] | 0); // f32->i32
    (HEAPF32[tempDoublePtr >> 2] = d, HEAP32[tempDoublePtr >> 2] | 0); // f64 with implict f32 conversion, ->i32
  }
  function recursiveBlockMerging(x) {
    x = x | 0;
    lb((1, x) + (2, 3) + (((4, 5), 6), 7) + (8, (9, (10, (11, 12))))) | 0;
    x = (lb(1) | 0, x) + (lb(2) | 0, lb(3) | 0) + (((lb(4) | 0, lb(5) | 0), lb(6) | 0), lb(7) | 0) + (lb(8) | 0, (lb(9) | 0, (lb(10) | 0, (lb(11) | 0, lb(12) | 0)))) | 0;
    return x | 0;
  }

  function lb(a) {
   a = a | 0;
   HEAP32[a >> 2] = n + 136 + 8;
   return 0;
  }

  function forgetMe() {
    123.456;
  }
  function exportMe() {
    -3.14159;
  }

  function zeroInit(x) {
    x = x | 0;
    var y = 0; // reusing this with x is dangerous - x has a value, and y needs to start at 0!
    if (lb(0) | 0) {
      if (lb(1) | 0) y = 3;
    } else {
      y = 3;
    }
    if ((y | 0) == 3) {
      lb(2) | 0;
    }
  }

  function phi() {
    var x = 0;
    do {
      if (lb(1) | 0) {
        x = 0;
        break;
      }
      x = 1;
    } while (0);
    return x | 0;
  }

  function smallIf() {
    do {
      if (2) {
        lb(3) | 0;
      } else {
        break;
      }
    } while (0);
  }

  function dropCall() {
    if (0) {
      phi(); // drop this
      setTempRet0(10); // this too
      zeroInit(setTempRet0(10) | 0);
    }
    return phi() | 0;
  }

  function useSetGlobal() {
    var x = 0;
    x = (Int = 10);
    Int = 20;
    return (Int = 30) | 0;
  }

  function usesSetGlobal2() {
    return (Int = 40, 50) | 0;
  }

  function z() {
  }
  function w() {
  }

  var FUNCTION_TABLE_a = [ z, big_negative, z, z ];
  var FUNCTION_TABLE_b = [ w, w, importedDoubles, w ];
  var FUNCTION_TABLE_c = [ z, cneg ];

  return { big_negative: big_negative, pick: forgetMe, pick: exportMe };
}

