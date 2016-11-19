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
  var STACKTOP = env.STACKTOP | 0;
  var setTempRet0=env.setTempRet0;

  var abort = env.abort;
  var print = env.print;
  var h = env.h;
  var return_int = env.return_int;

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
    if ((Int | 0) > 0) return -3.4;
    if (Double > 0.0) return 5.6;
    return 1.2;
  }
  function doubleCompares(x, y) {
    x = +x;
    y = +y;
    var t = 0.0;
    var Int = 0.0, Double = 0; // confusing with globals
    if (x > 0.0) return 1.2;
    if (Int > 0.0) return -3.4;
    if ((Double|0) > 0) return 5.6;
    if (x < y) return +x;
    return +y;
  }
  function intOps() {
    var x = 0;
    return (!x) | 0;
  }
  function hexLiterals() {
    var i = 0;
    i = 0x0 + 0x12ABCdef + 0xFEDcba90 | 0;
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
     L3 : while (1) switch (x | 0) {
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
    x = Math_fround(-x);
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
    FUNCTION_TABLE_vi[1 & 7](1) // no semicolon
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
    abort(+Math_fround(56.78));
  }
  function continues() {
    while (1) {
      print(1);
      do {
        print(5);
        if (return_int() | 0) continue;
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
    lb((1, x) + (2, 3) + (((4, 5), 6), 7) + (8, (9, (10, (11, 12)))) | 0) | 0;
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
      if (return_int() | 0) {
        lb(3) | 0;
      } else {
        break;
      }
    } while (0);
  }

  function dropCall() {
    if (return_int() | 0) {
      phi() | 0; // drop this
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

  function breakThroughMany($s) {
   $s = $s|0;
   L1: do {
    if ($s) {
     while(1) {
      if (!($s)) {
       break L1;
      }
      zeroInit(0);
     }
    } else {
     1337;
    }
   } while(0);
  }

  function ifChainEmpty(label) {
    label = label | 0;
    if ((label|0) == 4) {
      return 0;
    }
    else if ((label|0) == 7) {
      // unreachable;
    }
    return 0;
  }

  function heap8NoShift(x) {
    x = x | 0;
    return HEAP8[x | 0] | 0;
  }

  function conditionalTypeFun() {
    var x = 0, y = 0.0;
    x = return_int() | 0 ? abort(5) | 0 : 2;
    y = return_int() | 0 ? +abort(7) : 4.5;
  }

  function loadSigned(x) {
    x = x | 0;
    loadSigned(HEAP8[x >> 0] << 24 >> 24);
    loadSigned(HEAPU8[x >> 0] << 24 >> 24);
    loadSigned(HEAP16[x >> 1] << 16 >> 16);
    loadSigned(HEAPU16[x >> 1] << 16 >> 16);
    loadSigned(HEAP8[x >> 0] << 24 >> 16);
    loadSigned(HEAPU8[x >> 0] << 16 >> 24);
    loadSigned(HEAP16[x >> 1] << 16 >> 24);
    loadSigned(HEAPU16[x >> 1] << 24 >> 16);
  }

  function z(x) {
    x = Math_fround(x);
  }
  function w() {
    return 0.0;
  }

  function globalOpts() {
    var x = 0, y = 0.0;
    x = Int;
    y = Double;
    HEAP8[13] = HEAP32[3]; // access memory, should not confuse the global writes
    Double = y;
    Int = x;
    globalOpts();
    x = Int;
    if (return_int() | 0) Int = 20; // but this does interfere
    Int = x;
    globalOpts();
    x = Int;
    globalOpts(); // this too
    Int = x;
  }

  function dropCallImport() {
    if (return_int() | 0) return_int() | 0;
  }

  function loophi(x, y) {
   x = x | 0;
   y = y | 0;
   var temp = 0, inc = 0, loopvar = 0; // this order matters
   loopvar = x;
   while(1) {
    loophi(loopvar | 0, 0);
    temp = loopvar;
    if (temp) {
     if (temp) {
      break;
     }
    }
    inc = loopvar + 1 | 0;
    if ((inc|0) == (y|0)) {
     loopvar = inc;
    } else {
     break;
    }
   }
  }

  function loophi2() {
   var jnc = 0, i = 0, i$lcssa = 0, temp = 0, j = 0;
   i = 0;
   L7: while(1) {
    j = 0;
    while(1) {
     temp = j;
     if (return_int() | 0) {
      if (temp) {
       i$lcssa = i;
       break L7;
      }
     }
     jnc = j + 1 | 0;
     if (jnc) {
      j = jnc;
     } else {
      break;
     }
    }
   }
   return i$lcssa | 0
  }

  function relooperJumpThreading(x) {
   x = x | 0;
   var label = 0;
   // from if
   if (x) {
    h(0);
    label = 1;
   }
   if ((label|0) == 1) {
    h(1);
   }
   h(-1);
   // from loop
   while (1) {
    x = x + 1 | 0;
    if (x) {
     h(2);
     label = 2;
     break;
    }
   }
   if ((label|0) == 2) {
    h(3);
   }
   h(-2);
   // if-else afterward
   if (x) {
    h(4);
    if ((x|0) == 3) {
     label = 3;
    } else {
     label = 4;
    }
   }
   if ((label|0) == 3) {
    h(5);
   } else if ((label|0) == 4) {
    h(6);
   }
   h(-3);
   // two ifs afterward
   if (x) {
    h(7);
    if ((x|0) == 5) {
     label = 5;
    } else {
     label = 6;
    }
   }
   if ((label|0) == 5) {
    h(8);
    if ((x|0) == 6) {
     label = 6;
    }
   }
   if ((label|0) == 6) {
    h(9);
   }
   h(-4);
   // labeled if after
   if (x) {
    h(10);
    label = 7;
   }
   L1: do {
    if ((label|0) == 7) {
     h(11);
     break L1;
    }
   } while (0);
   h(-5);
   // labeled if after normal if
   if (x) {
    h(12);
    if ((x|0) == 8) {
      label = 8;
    } else {
      label = 9;
    }
   }
   if ((label|0) == 8) {
    h(13);
    if (x) label = 9;
   }
   L1: do {
    if ((label|0) == 9) {
     h(14);
     break L1;
    }
   } while (0);
   h(-6);
   // TODO
   // labeled if after a first if
   // do-enclosed if after (?)
   // test multiple labels, some should be ignored initially by JumpUpdater
   return x | 0;
  }

  function relooperJumpThreading__ZN4game14preloadweaponsEv() {
   var $12 = 0, $14 = 0, $or$cond8 = 0, $or$cond6 = 0, $vararg_ptr5 = 0, $11 = 0, $exitcond = 0, label = 0;
   while(1) {
    if ($14) {
     if ($or$cond8) {
      label = 7;
     } else {
      label = 8;
     }
    } else {
     if ($or$cond6) {
      label = 7;
     } else {
      label = 8;
     }
    }
    if ((label|0) == 7) {
     label = 0;
    }
    else if ((label|0) == 8) {
     label = 0;
     HEAP32[$vararg_ptr5>>2] = $11;
    }
   }
  }

  function relooperJumpThreading_irreducible(x) {
   x = x | 0;
   var label = 0;
   if ((x|0) == 100) {
    label = 1;
   } else {
    label = 10;
   }
   if ((label|0) == 1) {
    while (1) {
     relooperJumpThreading_irreducible(1337);
     label = 1; // this is ok - the if means the body of the if begins with the block for 1. so a setting inside the body of the if must return to the top of the if
    }
   }
   // too many settings, we just look one back, so this one will not be optimized
   if ((x|0) == 200) {
    label = 2;
   } else {
    label = 10;
   }
   if ((x|0) == 300) {
    label = 2;
   }
   if ((label|0) == 2) {
    relooperJumpThreading_irreducible(1448);
   }
   if ((label|0) == 10) {
    relooperJumpThreading_irreducible(2000);
   }
  }

  function __Z12multi_varargiz($0) {
   $0 = $0|0;
   var $2 = 0, $$06$i4 = 0, $exitcond$i6 = 0, $12 = 0, $20 = 0;
   if ($2) {
    while(1) {
     $12 = $$06$i4;
     if ($exitcond$i6) {
      break;
     } else {
      $$06$i4 = $20;
     }
    }
   } else {
    lb(1) | 0; // returns a value, and the while is unreachable
   }
  }

  function jumpThreadDrop() {
    var label = 0, temp = 0;
    temp = return_int() | 0;
    while (1) {
      label = 14;
      break;
    }
    if ((label | 0) == 10) {
    } else if ((label | 0) == 12) {
      return_int() | 0; // drop in the middle of an if-else chain for threading
    } else if ((label | 0) == 14) {
    }
    return temp | 0;
  }

  function dropIgnoredImportInIf($0,$1,$2) {
   $0 = $0|0;
   $1 = $1|0;
   $2 = $2|0;
   do {
    if ($0) {
     $0 = 1;
     lb($2 | 0) | 0;
    } else {
     break;
    }
   } while(0);
   return;
  }

  function big_fround() {
    return Math_fround(4294967295);
  }

  function dropIgnoredImportsInIf($0,$1,$2) {
   $0 = $0|0;
   $1 = $1|0;
   $2 = $2|0;
   do {
    if ($0) {
     lb($1 | 0) | 0;
    } else {
     lb($2 | 0) | 0;
    }
   } while(0);
   return;
  }

  function f32_ucast(x) {
    x = x | 0;
    return Math_fround(x>>>0);
  }
  function f32_scast(x) {
    x = x | 0;
    return Math_fround(x|0);
  }

  function store_fround(x) {
    x = x | 0;
    HEAPF64[10] = Math_fround(x|0);
  }

  function relocatableAndModules() {
    ftCall_v(10); // function table call
    mftCall_v(20); // possible inter-module function table call
    return ftCall_idi(30, 1.5, 200) | 0; // with args
  }

  function v() {
  }
  function vi(x) {
    x = x | 0;
  }

  var FUNCTION_TABLE_a = [ v, big_negative, v, v ];
  var FUNCTION_TABLE_b = [ w, w, importedDoubles, w ];
  var FUNCTION_TABLE_c = [ z, cneg, z, z, z, z, z, z ];
  var FUNCTION_TABLE_vi = [ vi, vi, vi, vi, vi, vi, vi, vi ];

  return { big_negative: big_negative, pick: forgetMe, pick: exportMe, doubleCompares: doubleCompares, intOps: intOps, conversions: conversions, switcher: switcher, frem: frem, big_uint_div_u: big_uint_div_u, fr: fr, negZero: negZero, neg: neg, smallCompare: smallCompare, cneg_nosemicolon: cneg_nosemicolon, forLoop: forLoop, ceiling_32_64: ceiling_32_64, aborts: aborts, continues: continues, bitcasts: bitcasts, recursiveBlockMerging: recursiveBlockMerging, lb: lb, zeroInit: zeroInit, phi: phi, smallIf: smallIf, dropCall: dropCall, useSetGlobal: useSetGlobal, usesSetGlobal2: usesSetGlobal2, breakThroughMany: breakThroughMany, ifChainEmpty: ifChainEmpty, heap8NoShift: heap8NoShift, conditionalTypeFun: conditionalTypeFun, loadSigned: loadSigned, globalOpts: globalOpts, dropCallImport: dropCallImport, loophi: loophi, loophi2: loophi2, relooperJumpThreading: relooperJumpThreading, relooperJumpThreading__ZN4game14preloadweaponsEv: relooperJumpThreading__ZN4game14preloadweaponsEv, __Z12multi_varargiz: __Z12multi_varargiz, jumpThreadDrop: jumpThreadDrop, dropIgnoredImportInIf: dropIgnoredImportInIf, dropIgnoredImportsInIf: dropIgnoredImportsInIf, relooperJumpThreading_irreducible: relooperJumpThreading_irreducible, store_fround: store_fround, exportedNumber: 42, relocatableAndModules: relocatableAndModules };
}

