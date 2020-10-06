Module["asm"] =  (function(global,env,buffer) {

  'use asm';
  
  
  var HEAP8 = new global.Int8Array(buffer);
  var HEAP16 = new global.Int16Array(buffer);
  var HEAP32 = new global.Int32Array(buffer);
  var HEAPU8 = new global.Uint8Array(buffer);
  var HEAPU16 = new global.Uint16Array(buffer);
  var HEAPU32 = new global.Uint32Array(buffer);
  var HEAPF32 = new global.Float32Array(buffer);
  var HEAPF64 = new global.Float64Array(buffer);


  var STACKTOP=env.STACKTOP|0;
  var STACK_MAX=env.STACK_MAX|0;
  var tempDoublePtr=env.tempDoublePtr|0;
  var ABORT=env.ABORT|0;

  var __THREW__ = 0;
  var threwValue = 0;
  var setjmpId = 0;
  var undef = 0;
  var nan = global.NaN, inf = global.Infinity;
  var tempInt = 0, tempBigInt = 0, tempBigIntP = 0, tempBigIntS = 0, tempBigIntR = 0.0, tempBigIntI = 0, tempBigIntD = 0, tempValue = 0, tempDouble = 0.0;

  var tempRet0 = 0;
  var tempRet1 = 0;
  var tempRet2 = 0;
  var tempRet3 = 0;
  var tempRet4 = 0;
  var tempRet5 = 0;
  var tempRet6 = 0;
  var tempRet7 = 0;
  var tempRet8 = 0;
  var tempRet9 = 0;
  var Math_floor=global.Math.floor;
  var Math_abs=global.Math.abs;
  var Math_sqrt=global.Math.sqrt;
  var Math_pow=global.Math.pow;
  var Math_cos=global.Math.cos;
  var Math_sin=global.Math.sin;
  var Math_tan=global.Math.tan;
  var Math_acos=global.Math.acos;
  var Math_asin=global.Math.asin;
  var Math_atan=global.Math.atan;
  var Math_atan2=global.Math.atan2;
  var Math_exp=global.Math.exp;
  var Math_log=global.Math.log;
  var Math_ceil=global.Math.ceil;
  var Math_imul=global.Math.imul;
  var Math_min=global.Math.min;
  var Math_clz32=global.Math.clz32;
  var abort=env.abort;
  var assert=env.assert;
  var invoke_ii=env.invoke_ii;
  var invoke_iiii=env.invoke_iiii;
  var invoke_vi=env.invoke_vi;
  var _pthread_cleanup_pop=env._pthread_cleanup_pop;
  var _pthread_self=env._pthread_self;
  var _sysconf=env._sysconf;
  var ___lock=env.___lock;
  var ___syscall6=env.___syscall6;
  var ___setErrNo=env.___setErrNo;
  var _abort=env._abort;
  var _sbrk=env._sbrk;
  var _time=env._time;
  var _pthread_cleanup_push=env._pthread_cleanup_push;
  var _emscripten_memcpy_big=env._emscripten_memcpy_big;
  var ___syscall54=env.___syscall54;
  var ___unlock=env.___unlock;
  var ___syscall140=env.___syscall140;
  var _emscripten_set_main_loop_timing=env._emscripten_set_main_loop_timing;
  var _emscripten_set_main_loop=env._emscripten_set_main_loop;
  var ___syscall146=env.___syscall146;
  var tempFloat = 0.0;

// EMSCRIPTEN_START_FUNCS

function _malloc(i1) {
 i1 = i1 | 0;
 var i2 = 0, i3 = 0, i4 = 0, i5 = 0, i6 = 0, i7 = 0, i8 = 0, i9 = 0, i10 = 0, i11 = 0, i12 = 0, i13 = 0, i14 = 0, i15 = 0, i16 = 0, i17 = 0, i18 = 0, i19 = 0, i20 = 0, i21 = 0, i22 = 0, i23 = 0, i24 = 0, i25 = 0, i26 = 0, i27 = 0, i28 = 0, i29 = 0, i30 = 0, i31 = 0, i32 = 0, i33 = 0, i34 = 0, i35 = 0, i36 = 0, i37 = 0, i38 = 0, i39 = 0, i40 = 0, i41 = 0, i42 = 0, i43 = 0, i44 = 0, i45 = 0, i46 = 0, i47 = 0, i48 = 0, i49 = 0, i50 = 0, i51 = 0, i52 = 0, i53 = 0, i54 = 0, i55 = 0, i56 = 0, i57 = 0, i58 = 0, i59 = 0, i60 = 0, i61 = 0, i62 = 0, i63 = 0, i64 = 0, i65 = 0, i66 = 0, i67 = 0, i68 = 0, i69 = 0, i70 = 0, i71 = 0, i72 = 0, i73 = 0, i74 = 0, i75 = 0, i76 = 0, i77 = 0, i78 = 0, i79 = 0, i80 = 0, i81 = 0, i82 = 0, i83 = 0, i84 = 0, i85 = 0, i86 = 0, i87 = 0, i88 = 0, i89 = 0, i90 = 0, i91 = 0, i92 = 0;
 do if (i1 >>> 0 < 245) {
  i2 = i1 >>> 0 < 11 ? 16 : i1 + 11 & -8;
  i3 = i2 >>> 3;
  i4 = HEAP32[44] | 0;
  i5 = i4 >>> i3;
  if (i5 & 3) {
   i6 = (i5 & 1 ^ 1) + i3 | 0;
   i7 = 216 + (i6 << 1 << 2) | 0;
   i8 = i7 + 8 | 0;
   i9 = HEAP32[i8 >> 2] | 0;
   i10 = i9 + 8 | 0;
   i11 = HEAP32[i10 >> 2] | 0;
   do if ((i7 | 0) != (i11 | 0)) {
    if (i11 >>> 0 < (HEAP32[48] | 0) >>> 0) _abort();
    i12 = i11 + 12 | 0;
    if ((HEAP32[i12 >> 2] | 0) == (i9 | 0)) {
     HEAP32[i12 >> 2] = i7;
     HEAP32[i8 >> 2] = i11;
     break;
    } else _abort();
   } else HEAP32[44] = i4 & ~(1 << i6); while (0);
   i11 = i6 << 3;
   HEAP32[i9 + 4 >> 2] = i11 | 3;
   i8 = i9 + i11 + 4 | 0;
   HEAP32[i8 >> 2] = HEAP32[i8 >> 2] | 1;
   i13 = i10;
   return i13 | 0;
  }
  i8 = HEAP32[46] | 0;
  if (i2 >>> 0 > i8 >>> 0) {
   if (i5) {
    i11 = 2 << i3;
    i7 = i5 << i3 & (i11 | 0 - i11);
    i11 = (i7 & 0 - i7) + -1 | 0;
    i7 = i11 >>> 12 & 16;
    i12 = i11 >>> i7;
    i11 = i12 >>> 5 & 8;
    i14 = i12 >>> i11;
    i12 = i14 >>> 2 & 4;
    i15 = i14 >>> i12;
    i14 = i15 >>> 1 & 2;
    i16 = i15 >>> i14;
    i15 = i16 >>> 1 & 1;
    i17 = (i11 | i7 | i12 | i14 | i15) + (i16 >>> i15) | 0;
    i15 = 216 + (i17 << 1 << 2) | 0;
    i16 = i15 + 8 | 0;
    i14 = HEAP32[i16 >> 2] | 0;
    i12 = i14 + 8 | 0;
    i7 = HEAP32[i12 >> 2] | 0;
    do if ((i15 | 0) != (i7 | 0)) {
     if (i7 >>> 0 < (HEAP32[48] | 0) >>> 0) _abort();
     i11 = i7 + 12 | 0;
     if ((HEAP32[i11 >> 2] | 0) == (i14 | 0)) {
      HEAP32[i11 >> 2] = i15;
      HEAP32[i16 >> 2] = i7;
      i18 = HEAP32[46] | 0;
      break;
     } else _abort();
    } else {
     HEAP32[44] = i4 & ~(1 << i17);
     i18 = i8;
    } while (0);
    i8 = (i17 << 3) - i2 | 0;
    HEAP32[i14 + 4 >> 2] = i2 | 3;
    i4 = i14 + i2 | 0;
    HEAP32[i4 + 4 >> 2] = i8 | 1;
    HEAP32[i4 + i8 >> 2] = i8;
    if (i18) {
     i7 = HEAP32[49] | 0;
     i16 = i18 >>> 3;
     i15 = 216 + (i16 << 1 << 2) | 0;
     i3 = HEAP32[44] | 0;
     i5 = 1 << i16;
     if (i3 & i5) {
      i16 = i15 + 8 | 0;
      i10 = HEAP32[i16 >> 2] | 0;
      if (i10 >>> 0 < (HEAP32[48] | 0) >>> 0) _abort(); else {
       i19 = i16;
       i20 = i10;
      }
     } else {
      HEAP32[44] = i3 | i5;
      i19 = i15 + 8 | 0;
      i20 = i15;
     }
     HEAP32[i19 >> 2] = i7;
     HEAP32[i20 + 12 >> 2] = i7;
     HEAP32[i7 + 8 >> 2] = i20;
     HEAP32[i7 + 12 >> 2] = i15;
    }
    HEAP32[46] = i8;
    HEAP32[49] = i4;
    i13 = i12;
    return i13 | 0;
   }
   i4 = HEAP32[45] | 0;
   if (i4) {
    i8 = (i4 & 0 - i4) + -1 | 0;
    i4 = i8 >>> 12 & 16;
    i15 = i8 >>> i4;
    i8 = i15 >>> 5 & 8;
    i7 = i15 >>> i8;
    i15 = i7 >>> 2 & 4;
    i5 = i7 >>> i15;
    i7 = i5 >>> 1 & 2;
    i3 = i5 >>> i7;
    i5 = i3 >>> 1 & 1;
    i10 = HEAP32[480 + ((i8 | i4 | i15 | i7 | i5) + (i3 >>> i5) << 2) >> 2] | 0;
    i5 = (HEAP32[i10 + 4 >> 2] & -8) - i2 | 0;
    i3 = i10;
    i7 = i10;
    while (1) {
     i10 = HEAP32[i3 + 16 >> 2] | 0;
     if (!i10) {
      i15 = HEAP32[i3 + 20 >> 2] | 0;
      if (!i15) {
       i21 = i5;
       i22 = i7;
       break;
      } else i23 = i15;
     } else i23 = i10;
     i10 = (HEAP32[i23 + 4 >> 2] & -8) - i2 | 0;
     i15 = i10 >>> 0 < i5 >>> 0;
     i5 = i15 ? i10 : i5;
     i3 = i23;
     i7 = i15 ? i23 : i7;
    }
    i7 = HEAP32[48] | 0;
    if (i22 >>> 0 < i7 >>> 0) _abort();
    i3 = i22 + i2 | 0;
    if (i22 >>> 0 >= i3 >>> 0) _abort();
    i5 = HEAP32[i22 + 24 >> 2] | 0;
    i12 = HEAP32[i22 + 12 >> 2] | 0;
    do if ((i12 | 0) == (i22 | 0)) {
     i14 = i22 + 20 | 0;
     i17 = HEAP32[i14 >> 2] | 0;
     if (!i17) {
      i15 = i22 + 16 | 0;
      i10 = HEAP32[i15 >> 2] | 0;
      if (!i10) {
       i24 = 0;
       break;
      } else {
       i25 = i10;
       i26 = i15;
      }
     } else {
      i25 = i17;
      i26 = i14;
     }
     while (1) {
      i14 = i25 + 20 | 0;
      i17 = HEAP32[i14 >> 2] | 0;
      if (i17) {
       i25 = i17;
       i26 = i14;
       continue;
      }
      i14 = i25 + 16 | 0;
      i17 = HEAP32[i14 >> 2] | 0;
      if (!i17) {
       i27 = i25;
       i28 = i26;
       break;
      } else {
       i25 = i17;
       i26 = i14;
      }
     }
     if (i28 >>> 0 < i7 >>> 0) _abort(); else {
      HEAP32[i28 >> 2] = 0;
      i24 = i27;
      break;
     }
    } else {
     i14 = HEAP32[i22 + 8 >> 2] | 0;
     if (i14 >>> 0 < i7 >>> 0) _abort();
     i17 = i14 + 12 | 0;
     if ((HEAP32[i17 >> 2] | 0) != (i22 | 0)) _abort();
     i15 = i12 + 8 | 0;
     if ((HEAP32[i15 >> 2] | 0) == (i22 | 0)) {
      HEAP32[i17 >> 2] = i12;
      HEAP32[i15 >> 2] = i14;
      i24 = i12;
      break;
     } else _abort();
    } while (0);
    do if (i5) {
     i12 = HEAP32[i22 + 28 >> 2] | 0;
     i7 = 480 + (i12 << 2) | 0;
     if ((i22 | 0) == (HEAP32[i7 >> 2] | 0)) {
      HEAP32[i7 >> 2] = i24;
      if (!i24) {
       HEAP32[45] = HEAP32[45] & ~(1 << i12);
       break;
      }
     } else {
      if (i5 >>> 0 < (HEAP32[48] | 0) >>> 0) _abort();
      i12 = i5 + 16 | 0;
      if ((HEAP32[i12 >> 2] | 0) == (i22 | 0)) HEAP32[i12 >> 2] = i24; else HEAP32[i5 + 20 >> 2] = i24;
      if (!i24) break;
     }
     i12 = HEAP32[48] | 0;
     if (i24 >>> 0 < i12 >>> 0) _abort();
     HEAP32[i24 + 24 >> 2] = i5;
     i7 = HEAP32[i22 + 16 >> 2] | 0;
     do if (i7) if (i7 >>> 0 < i12 >>> 0) _abort(); else {
      HEAP32[i24 + 16 >> 2] = i7;
      HEAP32[i7 + 24 >> 2] = i24;
      break;
     } while (0);
     i7 = HEAP32[i22 + 20 >> 2] | 0;
     if (i7) if (i7 >>> 0 < (HEAP32[48] | 0) >>> 0) _abort(); else {
      HEAP32[i24 + 20 >> 2] = i7;
      HEAP32[i7 + 24 >> 2] = i24;
      break;
     }
    } while (0);
    if (i21 >>> 0 < 16) {
     i5 = i21 + i2 | 0;
     HEAP32[i22 + 4 >> 2] = i5 | 3;
     i7 = i22 + i5 + 4 | 0;
     HEAP32[i7 >> 2] = HEAP32[i7 >> 2] | 1;
    } else {
     HEAP32[i22 + 4 >> 2] = i2 | 3;
     HEAP32[i3 + 4 >> 2] = i21 | 1;
     HEAP32[i3 + i21 >> 2] = i21;
     i7 = HEAP32[46] | 0;
     if (i7) {
      i5 = HEAP32[49] | 0;
      i12 = i7 >>> 3;
      i7 = 216 + (i12 << 1 << 2) | 0;
      i14 = HEAP32[44] | 0;
      i15 = 1 << i12;
      if (i14 & i15) {
       i12 = i7 + 8 | 0;
       i17 = HEAP32[i12 >> 2] | 0;
       if (i17 >>> 0 < (HEAP32[48] | 0) >>> 0) _abort(); else {
        i29 = i12;
        i30 = i17;
       }
      } else {
       HEAP32[44] = i14 | i15;
       i29 = i7 + 8 | 0;
       i30 = i7;
      }
      HEAP32[i29 >> 2] = i5;
      HEAP32[i30 + 12 >> 2] = i5;
      HEAP32[i5 + 8 >> 2] = i30;
      HEAP32[i5 + 12 >> 2] = i7;
     }
     HEAP32[46] = i21;
     HEAP32[49] = i3;
    }
    i13 = i22 + 8 | 0;
    return i13 | 0;
   } else i31 = i2;
  } else i31 = i2;
 } else if (i1 >>> 0 <= 4294967231) {
  i7 = i1 + 11 | 0;
  i5 = i7 & -8;
  i15 = HEAP32[45] | 0;
  if (i15) {
   i14 = 0 - i5 | 0;
   i17 = i7 >>> 8;
   if (i17) if (i5 >>> 0 > 16777215) i32 = 31; else {
    i7 = (i17 + 1048320 | 0) >>> 16 & 8;
    i12 = i17 << i7;
    i17 = (i12 + 520192 | 0) >>> 16 & 4;
    i10 = i12 << i17;
    i12 = (i10 + 245760 | 0) >>> 16 & 2;
    i4 = 14 - (i17 | i7 | i12) + (i10 << i12 >>> 15) | 0;
    i32 = i5 >>> (i4 + 7 | 0) & 1 | i4 << 1;
   } else i32 = 0;
   i4 = HEAP32[480 + (i32 << 2) >> 2] | 0;
   L123 : do if (!i4) {
    i33 = i14;
    i34 = 0;
    i35 = 0;
    i36 = 86;
   } else {
    i12 = i14;
    i10 = 0;
    i7 = i5 << ((i32 | 0) == 31 ? 0 : 25 - (i32 >>> 1) | 0);
    i17 = i4;
    i8 = 0;
    while (1) {
     i16 = HEAP32[i17 + 4 >> 2] & -8;
     i9 = i16 - i5 | 0;
     if (i9 >>> 0 < i12 >>> 0) if ((i16 | 0) == (i5 | 0)) {
      i37 = i9;
      i38 = i17;
      i39 = i17;
      i36 = 90;
      break L123;
     } else {
      i40 = i9;
      i41 = i17;
     } else {
      i40 = i12;
      i41 = i8;
     }
     i9 = HEAP32[i17 + 20 >> 2] | 0;
     i17 = HEAP32[i17 + 16 + (i7 >>> 31 << 2) >> 2] | 0;
     i16 = (i9 | 0) == 0 | (i9 | 0) == (i17 | 0) ? i10 : i9;
     i9 = (i17 | 0) == 0;
     if (i9) {
      i33 = i40;
      i34 = i16;
      i35 = i41;
      i36 = 86;
      break;
     } else {
      i12 = i40;
      i10 = i16;
      i7 = i7 << (i9 & 1 ^ 1);
      i8 = i41;
     }
    }
   } while (0);
   if ((i36 | 0) == 86) {
    if ((i34 | 0) == 0 & (i35 | 0) == 0) {
     i4 = 2 << i32;
     i14 = i15 & (i4 | 0 - i4);
     if (!i14) {
      i31 = i5;
      break;
     }
     i4 = (i14 & 0 - i14) + -1 | 0;
     i14 = i4 >>> 12 & 16;
     i2 = i4 >>> i14;
     i4 = i2 >>> 5 & 8;
     i3 = i2 >>> i4;
     i2 = i3 >>> 2 & 4;
     i8 = i3 >>> i2;
     i3 = i8 >>> 1 & 2;
     i7 = i8 >>> i3;
     i8 = i7 >>> 1 & 1;
     i42 = HEAP32[480 + ((i4 | i14 | i2 | i3 | i8) + (i7 >>> i8) << 2) >> 2] | 0;
    } else i42 = i34;
    if (!i42) {
     i43 = i33;
     i44 = i35;
    } else {
     i37 = i33;
     i38 = i42;
     i39 = i35;
     i36 = 90;
    }
   }
   if ((i36 | 0) == 90) while (1) {
    i36 = 0;
    i8 = (HEAP32[i38 + 4 >> 2] & -8) - i5 | 0;
    i7 = i8 >>> 0 < i37 >>> 0;
    i3 = i7 ? i8 : i37;
    i8 = i7 ? i38 : i39;
    i7 = HEAP32[i38 + 16 >> 2] | 0;
    if (i7) {
     i37 = i3;
     i38 = i7;
     i39 = i8;
     i36 = 90;
     continue;
    }
    i38 = HEAP32[i38 + 20 >> 2] | 0;
    if (!i38) {
     i43 = i3;
     i44 = i8;
     break;
    } else {
     i37 = i3;
     i39 = i8;
     i36 = 90;
    }
   }
   if ((i44 | 0) != 0 ? i43 >>> 0 < ((HEAP32[46] | 0) - i5 | 0) >>> 0 : 0) {
    i15 = HEAP32[48] | 0;
    if (i44 >>> 0 < i15 >>> 0) _abort();
    i8 = i44 + i5 | 0;
    if (i44 >>> 0 >= i8 >>> 0) _abort();
    i3 = HEAP32[i44 + 24 >> 2] | 0;
    i7 = HEAP32[i44 + 12 >> 2] | 0;
    do if ((i7 | 0) == (i44 | 0)) {
     i2 = i44 + 20 | 0;
     i14 = HEAP32[i2 >> 2] | 0;
     if (!i14) {
      i4 = i44 + 16 | 0;
      i10 = HEAP32[i4 >> 2] | 0;
      if (!i10) {
       i45 = 0;
       break;
      } else {
       i46 = i10;
       i47 = i4;
      }
     } else {
      i46 = i14;
      i47 = i2;
     }
     while (1) {
      i2 = i46 + 20 | 0;
      i14 = HEAP32[i2 >> 2] | 0;
      if (i14) {
       i46 = i14;
       i47 = i2;
       continue;
      }
      i2 = i46 + 16 | 0;
      i14 = HEAP32[i2 >> 2] | 0;
      if (!i14) {
       i48 = i46;
       i49 = i47;
       break;
      } else {
       i46 = i14;
       i47 = i2;
      }
     }
     if (i49 >>> 0 < i15 >>> 0) _abort(); else {
      HEAP32[i49 >> 2] = 0;
      i45 = i48;
      break;
     }
    } else {
     i2 = HEAP32[i44 + 8 >> 2] | 0;
     if (i2 >>> 0 < i15 >>> 0) _abort();
     i14 = i2 + 12 | 0;
     if ((HEAP32[i14 >> 2] | 0) != (i44 | 0)) _abort();
     i4 = i7 + 8 | 0;
     if ((HEAP32[i4 >> 2] | 0) == (i44 | 0)) {
      HEAP32[i14 >> 2] = i7;
      HEAP32[i4 >> 2] = i2;
      i45 = i7;
      break;
     } else _abort();
    } while (0);
    do if (i3) {
     i7 = HEAP32[i44 + 28 >> 2] | 0;
     i15 = 480 + (i7 << 2) | 0;
     if ((i44 | 0) == (HEAP32[i15 >> 2] | 0)) {
      HEAP32[i15 >> 2] = i45;
      if (!i45) {
       HEAP32[45] = HEAP32[45] & ~(1 << i7);
       break;
      }
     } else {
      if (i3 >>> 0 < (HEAP32[48] | 0) >>> 0) _abort();
      i7 = i3 + 16 | 0;
      if ((HEAP32[i7 >> 2] | 0) == (i44 | 0)) HEAP32[i7 >> 2] = i45; else HEAP32[i3 + 20 >> 2] = i45;
      if (!i45) break;
     }
     i7 = HEAP32[48] | 0;
     if (i45 >>> 0 < i7 >>> 0) _abort();
     HEAP32[i45 + 24 >> 2] = i3;
     i15 = HEAP32[i44 + 16 >> 2] | 0;
     do if (i15) if (i15 >>> 0 < i7 >>> 0) _abort(); else {
      HEAP32[i45 + 16 >> 2] = i15;
      HEAP32[i15 + 24 >> 2] = i45;
      break;
     } while (0);
     i15 = HEAP32[i44 + 20 >> 2] | 0;
     if (i15) if (i15 >>> 0 < (HEAP32[48] | 0) >>> 0) _abort(); else {
      HEAP32[i45 + 20 >> 2] = i15;
      HEAP32[i15 + 24 >> 2] = i45;
      break;
     }
    } while (0);
    do if (i43 >>> 0 >= 16) {
     HEAP32[i44 + 4 >> 2] = i5 | 3;
     HEAP32[i8 + 4 >> 2] = i43 | 1;
     HEAP32[i8 + i43 >> 2] = i43;
     i3 = i43 >>> 3;
     if (i43 >>> 0 < 256) {
      i15 = 216 + (i3 << 1 << 2) | 0;
      i7 = HEAP32[44] | 0;
      i2 = 1 << i3;
      if (i7 & i2) {
       i3 = i15 + 8 | 0;
       i4 = HEAP32[i3 >> 2] | 0;
       if (i4 >>> 0 < (HEAP32[48] | 0) >>> 0) _abort(); else {
        i50 = i3;
        i51 = i4;
       }
      } else {
       HEAP32[44] = i7 | i2;
       i50 = i15 + 8 | 0;
       i51 = i15;
      }
      HEAP32[i50 >> 2] = i8;
      HEAP32[i51 + 12 >> 2] = i8;
      HEAP32[i8 + 8 >> 2] = i51;
      HEAP32[i8 + 12 >> 2] = i15;
      break;
     }
     i15 = i43 >>> 8;
     if (i15) if (i43 >>> 0 > 16777215) i52 = 31; else {
      i2 = (i15 + 1048320 | 0) >>> 16 & 8;
      i7 = i15 << i2;
      i15 = (i7 + 520192 | 0) >>> 16 & 4;
      i4 = i7 << i15;
      i7 = (i4 + 245760 | 0) >>> 16 & 2;
      i3 = 14 - (i15 | i2 | i7) + (i4 << i7 >>> 15) | 0;
      i52 = i43 >>> (i3 + 7 | 0) & 1 | i3 << 1;
     } else i52 = 0;
     i3 = 480 + (i52 << 2) | 0;
     HEAP32[i8 + 28 >> 2] = i52;
     i7 = i8 + 16 | 0;
     HEAP32[i7 + 4 >> 2] = 0;
     HEAP32[i7 >> 2] = 0;
     i7 = HEAP32[45] | 0;
     i4 = 1 << i52;
     if (!(i7 & i4)) {
      HEAP32[45] = i7 | i4;
      HEAP32[i3 >> 2] = i8;
      HEAP32[i8 + 24 >> 2] = i3;
      HEAP32[i8 + 12 >> 2] = i8;
      HEAP32[i8 + 8 >> 2] = i8;
      break;
     }
     i4 = i43 << ((i52 | 0) == 31 ? 0 : 25 - (i52 >>> 1) | 0);
     i7 = HEAP32[i3 >> 2] | 0;
     while (1) {
      if ((HEAP32[i7 + 4 >> 2] & -8 | 0) == (i43 | 0)) {
       i53 = i7;
       i36 = 148;
       break;
      }
      i3 = i7 + 16 + (i4 >>> 31 << 2) | 0;
      i2 = HEAP32[i3 >> 2] | 0;
      if (!i2) {
       i54 = i3;
       i55 = i7;
       i36 = 145;
       break;
      } else {
       i4 = i4 << 1;
       i7 = i2;
      }
     }
     if ((i36 | 0) == 145) if (i54 >>> 0 < (HEAP32[48] | 0) >>> 0) _abort(); else {
      HEAP32[i54 >> 2] = i8;
      HEAP32[i8 + 24 >> 2] = i55;
      HEAP32[i8 + 12 >> 2] = i8;
      HEAP32[i8 + 8 >> 2] = i8;
      break;
     } else if ((i36 | 0) == 148) {
      i7 = i53 + 8 | 0;
      i4 = HEAP32[i7 >> 2] | 0;
      i2 = HEAP32[48] | 0;
      if (i4 >>> 0 >= i2 >>> 0 & i53 >>> 0 >= i2 >>> 0) {
       HEAP32[i4 + 12 >> 2] = i8;
       HEAP32[i7 >> 2] = i8;
       HEAP32[i8 + 8 >> 2] = i4;
       HEAP32[i8 + 12 >> 2] = i53;
       HEAP32[i8 + 24 >> 2] = 0;
       break;
      } else _abort();
     }
    } else {
     i4 = i43 + i5 | 0;
     HEAP32[i44 + 4 >> 2] = i4 | 3;
     i7 = i44 + i4 + 4 | 0;
     HEAP32[i7 >> 2] = HEAP32[i7 >> 2] | 1;
    } while (0);
    i13 = i44 + 8 | 0;
    return i13 | 0;
   } else i31 = i5;
  } else i31 = i5;
 } else i31 = -1; while (0);
 i44 = HEAP32[46] | 0;
 if (i44 >>> 0 >= i31 >>> 0) {
  i43 = i44 - i31 | 0;
  i53 = HEAP32[49] | 0;
  if (i43 >>> 0 > 15) {
   i55 = i53 + i31 | 0;
   HEAP32[49] = i55;
   HEAP32[46] = i43;
   HEAP32[i55 + 4 >> 2] = i43 | 1;
   HEAP32[i55 + i43 >> 2] = i43;
   HEAP32[i53 + 4 >> 2] = i31 | 3;
  } else {
   HEAP32[46] = 0;
   HEAP32[49] = 0;
   HEAP32[i53 + 4 >> 2] = i44 | 3;
   i43 = i53 + i44 + 4 | 0;
   HEAP32[i43 >> 2] = HEAP32[i43 >> 2] | 1;
  }
  i13 = i53 + 8 | 0;
  return i13 | 0;
 }
 i53 = HEAP32[47] | 0;
 if (i53 >>> 0 > i31 >>> 0) {
  i43 = i53 - i31 | 0;
  HEAP32[47] = i43;
  i53 = HEAP32[50] | 0;
  i44 = i53 + i31 | 0;
  HEAP32[50] = i44;
  HEAP32[i44 + 4 >> 2] = i43 | 1;
  HEAP32[i53 + 4 >> 2] = i31 | 3;
  i13 = i53 + 8 | 0;
  return i13 | 0;
 }
 do if (!(HEAP32[162] | 0)) {
  i53 = _sysconf(30) | 0;
  if (!(i53 + -1 & i53)) {
   HEAP32[164] = i53;
   HEAP32[163] = i53;
   HEAP32[165] = -1;
   HEAP32[166] = -1;
   HEAP32[167] = 0;
   HEAP32[155] = 0;
   HEAP32[162] = (_time(0) | 0) & -16 ^ 1431655768;
   break;
  } else _abort();
 } while (0);
 i53 = i31 + 48 | 0;
 i43 = HEAP32[164] | 0;
 i44 = i31 + 47 | 0;
 i55 = i43 + i44 | 0;
 i54 = 0 - i43 | 0;
 i43 = i55 & i54;
 if (i43 >>> 0 <= i31 >>> 0) {
  i13 = 0;
  return i13 | 0;
 }
 i52 = HEAP32[154] | 0;
 if ((i52 | 0) != 0 ? (i51 = HEAP32[152] | 0, i50 = i51 + i43 | 0, i50 >>> 0 <= i51 >>> 0 | i50 >>> 0 > i52 >>> 0) : 0) {
  i13 = 0;
  return i13 | 0;
 }
 L257 : do if (!(HEAP32[155] & 4)) {
  i52 = HEAP32[50] | 0;
  L259 : do if (i52) {
   i50 = 624;
   while (1) {
    i51 = HEAP32[i50 >> 2] | 0;
    if (i51 >>> 0 <= i52 >>> 0 ? (i45 = i50 + 4 | 0, (i51 + (HEAP32[i45 >> 2] | 0) | 0) >>> 0 > i52 >>> 0) : 0) {
     i56 = i50;
     i57 = i45;
     break;
    }
    i50 = HEAP32[i50 + 8 >> 2] | 0;
    if (!i50) {
     i36 = 173;
     break L259;
    }
   }
   i50 = i55 - (HEAP32[47] | 0) & i54;
   if (i50 >>> 0 < 2147483647) {
    i45 = _sbrk(i50 | 0) | 0;
    if ((i45 | 0) == ((HEAP32[i56 >> 2] | 0) + (HEAP32[i57 >> 2] | 0) | 0)) {
     if ((i45 | 0) != (-1 | 0)) {
      i58 = i45;
      i59 = i50;
      i36 = 193;
      break L257;
     }
    } else {
     i60 = i45;
     i61 = i50;
     i36 = 183;
    }
   }
  } else i36 = 173; while (0);
  do if ((i36 | 0) == 173 ? (i52 = _sbrk(0) | 0, (i52 | 0) != (-1 | 0)) : 0) {
   i5 = i52;
   i50 = HEAP32[163] | 0;
   i45 = i50 + -1 | 0;
   if (!(i45 & i5)) i62 = i43; else i62 = i43 - i5 + (i45 + i5 & 0 - i50) | 0;
   i50 = HEAP32[152] | 0;
   i5 = i50 + i62 | 0;
   if (i62 >>> 0 > i31 >>> 0 & i62 >>> 0 < 2147483647) {
    i45 = HEAP32[154] | 0;
    if ((i45 | 0) != 0 ? i5 >>> 0 <= i50 >>> 0 | i5 >>> 0 > i45 >>> 0 : 0) break;
    i45 = _sbrk(i62 | 0) | 0;
    if ((i45 | 0) == (i52 | 0)) {
     i58 = i52;
     i59 = i62;
     i36 = 193;
     break L257;
    } else {
     i60 = i45;
     i61 = i62;
     i36 = 183;
    }
   }
  } while (0);
  L279 : do if ((i36 | 0) == 183) {
   i45 = 0 - i61 | 0;
   do if (i53 >>> 0 > i61 >>> 0 & (i61 >>> 0 < 2147483647 & (i60 | 0) != (-1 | 0)) ? (i52 = HEAP32[164] | 0, i5 = i44 - i61 + i52 & 0 - i52, i5 >>> 0 < 2147483647) : 0) if ((_sbrk(i5 | 0) | 0) == (-1 | 0)) {
    _sbrk(i45 | 0) | 0;
    break L279;
   } else {
    i63 = i5 + i61 | 0;
    break;
   } else i63 = i61; while (0);
   if ((i60 | 0) != (-1 | 0)) {
    i58 = i60;
    i59 = i63;
    i36 = 193;
    break L257;
   }
  } while (0);
  HEAP32[155] = HEAP32[155] | 4;
  i36 = 190;
 } else i36 = 190; while (0);
 if ((((i36 | 0) == 190 ? i43 >>> 0 < 2147483647 : 0) ? (i63 = _sbrk(i43 | 0) | 0, i43 = _sbrk(0) | 0, i63 >>> 0 < i43 >>> 0 & ((i63 | 0) != (-1 | 0) & (i43 | 0) != (-1 | 0))) : 0) ? (i60 = i43 - i63 | 0, i60 >>> 0 > (i31 + 40 | 0) >>> 0) : 0) {
  i58 = i63;
  i59 = i60;
  i36 = 193;
 }
 if ((i36 | 0) == 193) {
  i60 = (HEAP32[152] | 0) + i59 | 0;
  HEAP32[152] = i60;
  if (i60 >>> 0 > (HEAP32[153] | 0) >>> 0) HEAP32[153] = i60;
  i60 = HEAP32[50] | 0;
  do if (i60) {
   i63 = 624;
   do {
    i43 = HEAP32[i63 >> 2] | 0;
    i61 = i63 + 4 | 0;
    i44 = HEAP32[i61 >> 2] | 0;
    if ((i58 | 0) == (i43 + i44 | 0)) {
     i64 = i43;
     i65 = i61;
     i66 = i44;
     i67 = i63;
     i36 = 203;
     break;
    }
    i63 = HEAP32[i63 + 8 >> 2] | 0;
   } while ((i63 | 0) != 0);
   if (((i36 | 0) == 203 ? (HEAP32[i67 + 12 >> 2] & 8 | 0) == 0 : 0) ? i60 >>> 0 < i58 >>> 0 & i60 >>> 0 >= i64 >>> 0 : 0) {
    HEAP32[i65 >> 2] = i66 + i59;
    i63 = i60 + 8 | 0;
    i44 = (i63 & 7 | 0) == 0 ? 0 : 0 - i63 & 7;
    i63 = i60 + i44 | 0;
    i61 = i59 - i44 + (HEAP32[47] | 0) | 0;
    HEAP32[50] = i63;
    HEAP32[47] = i61;
    HEAP32[i63 + 4 >> 2] = i61 | 1;
    HEAP32[i63 + i61 + 4 >> 2] = 40;
    HEAP32[51] = HEAP32[166];
    break;
   }
   i61 = HEAP32[48] | 0;
   if (i58 >>> 0 < i61 >>> 0) {
    HEAP32[48] = i58;
    i68 = i58;
   } else i68 = i61;
   i61 = i58 + i59 | 0;
   i63 = 624;
   while (1) {
    if ((HEAP32[i63 >> 2] | 0) == (i61 | 0)) {
     i69 = i63;
     i70 = i63;
     i36 = 211;
     break;
    }
    i63 = HEAP32[i63 + 8 >> 2] | 0;
    if (!i63) {
     i71 = 624;
     break;
    }
   }
   if ((i36 | 0) == 211) if (!(HEAP32[i70 + 12 >> 2] & 8)) {
    HEAP32[i69 >> 2] = i58;
    i63 = i70 + 4 | 0;
    HEAP32[i63 >> 2] = (HEAP32[i63 >> 2] | 0) + i59;
    i63 = i58 + 8 | 0;
    i44 = i58 + ((i63 & 7 | 0) == 0 ? 0 : 0 - i63 & 7) | 0;
    i63 = i61 + 8 | 0;
    i43 = i61 + ((i63 & 7 | 0) == 0 ? 0 : 0 - i63 & 7) | 0;
    i63 = i44 + i31 | 0;
    i53 = i43 - i44 - i31 | 0;
    HEAP32[i44 + 4 >> 2] = i31 | 3;
    do if ((i43 | 0) != (i60 | 0)) {
     if ((i43 | 0) == (HEAP32[49] | 0)) {
      i62 = (HEAP32[46] | 0) + i53 | 0;
      HEAP32[46] = i62;
      HEAP32[49] = i63;
      HEAP32[i63 + 4 >> 2] = i62 | 1;
      HEAP32[i63 + i62 >> 2] = i62;
      break;
     }
     i62 = HEAP32[i43 + 4 >> 2] | 0;
     if ((i62 & 3 | 0) == 1) {
      i57 = i62 & -8;
      i56 = i62 >>> 3;
      L331 : do if (i62 >>> 0 >= 256) {
       i54 = HEAP32[i43 + 24 >> 2] | 0;
       i55 = HEAP32[i43 + 12 >> 2] | 0;
       do if ((i55 | 0) == (i43 | 0)) {
        i45 = i43 + 16 | 0;
        i5 = i45 + 4 | 0;
        i52 = HEAP32[i5 >> 2] | 0;
        if (!i52) {
         i50 = HEAP32[i45 >> 2] | 0;
         if (!i50) {
          i72 = 0;
          break;
         } else {
          i73 = i50;
          i74 = i45;
         }
        } else {
         i73 = i52;
         i74 = i5;
        }
        while (1) {
         i5 = i73 + 20 | 0;
         i52 = HEAP32[i5 >> 2] | 0;
         if (i52) {
          i73 = i52;
          i74 = i5;
          continue;
         }
         i5 = i73 + 16 | 0;
         i52 = HEAP32[i5 >> 2] | 0;
         if (!i52) {
          i75 = i73;
          i76 = i74;
          break;
         } else {
          i73 = i52;
          i74 = i5;
         }
        }
        if (i76 >>> 0 < i68 >>> 0) _abort(); else {
         HEAP32[i76 >> 2] = 0;
         i72 = i75;
         break;
        }
       } else {
        i5 = HEAP32[i43 + 8 >> 2] | 0;
        if (i5 >>> 0 < i68 >>> 0) _abort();
        i52 = i5 + 12 | 0;
        if ((HEAP32[i52 >> 2] | 0) != (i43 | 0)) _abort();
        i45 = i55 + 8 | 0;
        if ((HEAP32[i45 >> 2] | 0) == (i43 | 0)) {
         HEAP32[i52 >> 2] = i55;
         HEAP32[i45 >> 2] = i5;
         i72 = i55;
         break;
        } else _abort();
       } while (0);
       if (!i54) break;
       i55 = HEAP32[i43 + 28 >> 2] | 0;
       i5 = 480 + (i55 << 2) | 0;
       do if ((i43 | 0) != (HEAP32[i5 >> 2] | 0)) {
        if (i54 >>> 0 < (HEAP32[48] | 0) >>> 0) _abort();
        i45 = i54 + 16 | 0;
        if ((HEAP32[i45 >> 2] | 0) == (i43 | 0)) HEAP32[i45 >> 2] = i72; else HEAP32[i54 + 20 >> 2] = i72;
        if (!i72) break L331;
       } else {
        HEAP32[i5 >> 2] = i72;
        if (i72) break;
        HEAP32[45] = HEAP32[45] & ~(1 << i55);
        break L331;
       } while (0);
       i55 = HEAP32[48] | 0;
       if (i72 >>> 0 < i55 >>> 0) _abort();
       HEAP32[i72 + 24 >> 2] = i54;
       i5 = i43 + 16 | 0;
       i45 = HEAP32[i5 >> 2] | 0;
       do if (i45) if (i45 >>> 0 < i55 >>> 0) _abort(); else {
        HEAP32[i72 + 16 >> 2] = i45;
        HEAP32[i45 + 24 >> 2] = i72;
        break;
       } while (0);
       i45 = HEAP32[i5 + 4 >> 2] | 0;
       if (!i45) break;
       if (i45 >>> 0 < (HEAP32[48] | 0) >>> 0) _abort(); else {
        HEAP32[i72 + 20 >> 2] = i45;
        HEAP32[i45 + 24 >> 2] = i72;
        break;
       }
      } else {
       i45 = HEAP32[i43 + 8 >> 2] | 0;
       i55 = HEAP32[i43 + 12 >> 2] | 0;
       i54 = 216 + (i56 << 1 << 2) | 0;
       do if ((i45 | 0) != (i54 | 0)) {
        if (i45 >>> 0 < i68 >>> 0) _abort();
        if ((HEAP32[i45 + 12 >> 2] | 0) == (i43 | 0)) break;
        _abort();
       } while (0);
       if ((i55 | 0) == (i45 | 0)) {
        HEAP32[44] = HEAP32[44] & ~(1 << i56);
        break;
       }
       do if ((i55 | 0) == (i54 | 0)) i77 = i55 + 8 | 0; else {
        if (i55 >>> 0 < i68 >>> 0) _abort();
        i5 = i55 + 8 | 0;
        if ((HEAP32[i5 >> 2] | 0) == (i43 | 0)) {
         i77 = i5;
         break;
        }
        _abort();
       } while (0);
       HEAP32[i45 + 12 >> 2] = i55;
       HEAP32[i77 >> 2] = i45;
      } while (0);
      i78 = i43 + i57 | 0;
      i79 = i57 + i53 | 0;
     } else {
      i78 = i43;
      i79 = i53;
     }
     i56 = i78 + 4 | 0;
     HEAP32[i56 >> 2] = HEAP32[i56 >> 2] & -2;
     HEAP32[i63 + 4 >> 2] = i79 | 1;
     HEAP32[i63 + i79 >> 2] = i79;
     i56 = i79 >>> 3;
     if (i79 >>> 0 < 256) {
      i62 = 216 + (i56 << 1 << 2) | 0;
      i54 = HEAP32[44] | 0;
      i5 = 1 << i56;
      do if (!(i54 & i5)) {
       HEAP32[44] = i54 | i5;
       i80 = i62 + 8 | 0;
       i81 = i62;
      } else {
       i56 = i62 + 8 | 0;
       i52 = HEAP32[i56 >> 2] | 0;
       if (i52 >>> 0 >= (HEAP32[48] | 0) >>> 0) {
        i80 = i56;
        i81 = i52;
        break;
       }
       _abort();
      } while (0);
      HEAP32[i80 >> 2] = i63;
      HEAP32[i81 + 12 >> 2] = i63;
      HEAP32[i63 + 8 >> 2] = i81;
      HEAP32[i63 + 12 >> 2] = i62;
      break;
     }
     i5 = i79 >>> 8;
     do if (!i5) i82 = 0; else {
      if (i79 >>> 0 > 16777215) {
       i82 = 31;
       break;
      }
      i54 = (i5 + 1048320 | 0) >>> 16 & 8;
      i57 = i5 << i54;
      i52 = (i57 + 520192 | 0) >>> 16 & 4;
      i56 = i57 << i52;
      i57 = (i56 + 245760 | 0) >>> 16 & 2;
      i50 = 14 - (i52 | i54 | i57) + (i56 << i57 >>> 15) | 0;
      i82 = i79 >>> (i50 + 7 | 0) & 1 | i50 << 1;
     } while (0);
     i5 = 480 + (i82 << 2) | 0;
     HEAP32[i63 + 28 >> 2] = i82;
     i62 = i63 + 16 | 0;
     HEAP32[i62 + 4 >> 2] = 0;
     HEAP32[i62 >> 2] = 0;
     i62 = HEAP32[45] | 0;
     i50 = 1 << i82;
     if (!(i62 & i50)) {
      HEAP32[45] = i62 | i50;
      HEAP32[i5 >> 2] = i63;
      HEAP32[i63 + 24 >> 2] = i5;
      HEAP32[i63 + 12 >> 2] = i63;
      HEAP32[i63 + 8 >> 2] = i63;
      break;
     }
     i50 = i79 << ((i82 | 0) == 31 ? 0 : 25 - (i82 >>> 1) | 0);
     i62 = HEAP32[i5 >> 2] | 0;
     while (1) {
      if ((HEAP32[i62 + 4 >> 2] & -8 | 0) == (i79 | 0)) {
       i83 = i62;
       i36 = 281;
       break;
      }
      i5 = i62 + 16 + (i50 >>> 31 << 2) | 0;
      i57 = HEAP32[i5 >> 2] | 0;
      if (!i57) {
       i84 = i5;
       i85 = i62;
       i36 = 278;
       break;
      } else {
       i50 = i50 << 1;
       i62 = i57;
      }
     }
     if ((i36 | 0) == 278) if (i84 >>> 0 < (HEAP32[48] | 0) >>> 0) _abort(); else {
      HEAP32[i84 >> 2] = i63;
      HEAP32[i63 + 24 >> 2] = i85;
      HEAP32[i63 + 12 >> 2] = i63;
      HEAP32[i63 + 8 >> 2] = i63;
      break;
     } else if ((i36 | 0) == 281) {
      i62 = i83 + 8 | 0;
      i50 = HEAP32[i62 >> 2] | 0;
      i57 = HEAP32[48] | 0;
      if (i50 >>> 0 >= i57 >>> 0 & i83 >>> 0 >= i57 >>> 0) {
       HEAP32[i50 + 12 >> 2] = i63;
       HEAP32[i62 >> 2] = i63;
       HEAP32[i63 + 8 >> 2] = i50;
       HEAP32[i63 + 12 >> 2] = i83;
       HEAP32[i63 + 24 >> 2] = 0;
       break;
      } else _abort();
     }
    } else {
     i50 = (HEAP32[47] | 0) + i53 | 0;
     HEAP32[47] = i50;
     HEAP32[50] = i63;
     HEAP32[i63 + 4 >> 2] = i50 | 1;
    } while (0);
    i13 = i44 + 8 | 0;
    return i13 | 0;
   } else i71 = 624;
   while (1) {
    i63 = HEAP32[i71 >> 2] | 0;
    if (i63 >>> 0 <= i60 >>> 0 ? (i53 = i63 + (HEAP32[i71 + 4 >> 2] | 0) | 0, i53 >>> 0 > i60 >>> 0) : 0) {
     i86 = i53;
     break;
    }
    i71 = HEAP32[i71 + 8 >> 2] | 0;
   }
   i44 = i86 + -47 | 0;
   i53 = i44 + 8 | 0;
   i63 = i44 + ((i53 & 7 | 0) == 0 ? 0 : 0 - i53 & 7) | 0;
   i53 = i60 + 16 | 0;
   i44 = i63 >>> 0 < i53 >>> 0 ? i60 : i63;
   i63 = i44 + 8 | 0;
   i43 = i58 + 8 | 0;
   i61 = (i43 & 7 | 0) == 0 ? 0 : 0 - i43 & 7;
   i43 = i58 + i61 | 0;
   i50 = i59 + -40 - i61 | 0;
   HEAP32[50] = i43;
   HEAP32[47] = i50;
   HEAP32[i43 + 4 >> 2] = i50 | 1;
   HEAP32[i43 + i50 + 4 >> 2] = 40;
   HEAP32[51] = HEAP32[166];
   i50 = i44 + 4 | 0;
   HEAP32[i50 >> 2] = 27;
   HEAP32[i63 >> 2] = HEAP32[156];
   HEAP32[i63 + 4 >> 2] = HEAP32[157];
   HEAP32[i63 + 8 >> 2] = HEAP32[158];
   HEAP32[i63 + 12 >> 2] = HEAP32[159];
   HEAP32[156] = i58;
   HEAP32[157] = i59;
   HEAP32[159] = 0;
   HEAP32[158] = i63;
   i63 = i44 + 24 | 0;
   do {
    i63 = i63 + 4 | 0;
    HEAP32[i63 >> 2] = 7;
   } while ((i63 + 4 | 0) >>> 0 < i86 >>> 0);
   if ((i44 | 0) != (i60 | 0)) {
    i63 = i44 - i60 | 0;
    HEAP32[i50 >> 2] = HEAP32[i50 >> 2] & -2;
    HEAP32[i60 + 4 >> 2] = i63 | 1;
    HEAP32[i44 >> 2] = i63;
    i43 = i63 >>> 3;
    if (i63 >>> 0 < 256) {
     i61 = 216 + (i43 << 1 << 2) | 0;
     i62 = HEAP32[44] | 0;
     i57 = 1 << i43;
     if (i62 & i57) {
      i43 = i61 + 8 | 0;
      i5 = HEAP32[i43 >> 2] | 0;
      if (i5 >>> 0 < (HEAP32[48] | 0) >>> 0) _abort(); else {
       i87 = i43;
       i88 = i5;
      }
     } else {
      HEAP32[44] = i62 | i57;
      i87 = i61 + 8 | 0;
      i88 = i61;
     }
     HEAP32[i87 >> 2] = i60;
     HEAP32[i88 + 12 >> 2] = i60;
     HEAP32[i60 + 8 >> 2] = i88;
     HEAP32[i60 + 12 >> 2] = i61;
     break;
    }
    i61 = i63 >>> 8;
    if (i61) if (i63 >>> 0 > 16777215) i89 = 31; else {
     i57 = (i61 + 1048320 | 0) >>> 16 & 8;
     i62 = i61 << i57;
     i61 = (i62 + 520192 | 0) >>> 16 & 4;
     i5 = i62 << i61;
     i62 = (i5 + 245760 | 0) >>> 16 & 2;
     i43 = 14 - (i61 | i57 | i62) + (i5 << i62 >>> 15) | 0;
     i89 = i63 >>> (i43 + 7 | 0) & 1 | i43 << 1;
    } else i89 = 0;
    i43 = 480 + (i89 << 2) | 0;
    HEAP32[i60 + 28 >> 2] = i89;
    HEAP32[i60 + 20 >> 2] = 0;
    HEAP32[i53 >> 2] = 0;
    i62 = HEAP32[45] | 0;
    i5 = 1 << i89;
    if (!(i62 & i5)) {
     HEAP32[45] = i62 | i5;
     HEAP32[i43 >> 2] = i60;
     HEAP32[i60 + 24 >> 2] = i43;
     HEAP32[i60 + 12 >> 2] = i60;
     HEAP32[i60 + 8 >> 2] = i60;
     break;
    }
    i5 = i63 << ((i89 | 0) == 31 ? 0 : 25 - (i89 >>> 1) | 0);
    i62 = HEAP32[i43 >> 2] | 0;
    while (1) {
     if ((HEAP32[i62 + 4 >> 2] & -8 | 0) == (i63 | 0)) {
      i90 = i62;
      i36 = 307;
      break;
     }
     i43 = i62 + 16 + (i5 >>> 31 << 2) | 0;
     i57 = HEAP32[i43 >> 2] | 0;
     if (!i57) {
      i91 = i43;
      i92 = i62;
      i36 = 304;
      break;
     } else {
      i5 = i5 << 1;
      i62 = i57;
     }
    }
    if ((i36 | 0) == 304) if (i91 >>> 0 < (HEAP32[48] | 0) >>> 0) _abort(); else {
     HEAP32[i91 >> 2] = i60;
     HEAP32[i60 + 24 >> 2] = i92;
     HEAP32[i60 + 12 >> 2] = i60;
     HEAP32[i60 + 8 >> 2] = i60;
     break;
    } else if ((i36 | 0) == 307) {
     i62 = i90 + 8 | 0;
     i5 = HEAP32[i62 >> 2] | 0;
     i63 = HEAP32[48] | 0;
     if (i5 >>> 0 >= i63 >>> 0 & i90 >>> 0 >= i63 >>> 0) {
      HEAP32[i5 + 12 >> 2] = i60;
      HEAP32[i62 >> 2] = i60;
      HEAP32[i60 + 8 >> 2] = i5;
      HEAP32[i60 + 12 >> 2] = i90;
      HEAP32[i60 + 24 >> 2] = 0;
      break;
     } else _abort();
    }
   }
  } else {
   i5 = HEAP32[48] | 0;
   if ((i5 | 0) == 0 | i58 >>> 0 < i5 >>> 0) HEAP32[48] = i58;
   HEAP32[156] = i58;
   HEAP32[157] = i59;
   HEAP32[159] = 0;
   HEAP32[53] = HEAP32[162];
   HEAP32[52] = -1;
   i5 = 0;
   do {
    i62 = 216 + (i5 << 1 << 2) | 0;
    HEAP32[i62 + 12 >> 2] = i62;
    HEAP32[i62 + 8 >> 2] = i62;
    i5 = i5 + 1 | 0;
   } while ((i5 | 0) != 32);
   i5 = i58 + 8 | 0;
   i62 = (i5 & 7 | 0) == 0 ? 0 : 0 - i5 & 7;
   i5 = i58 + i62 | 0;
   i63 = i59 + -40 - i62 | 0;
   HEAP32[50] = i5;
   HEAP32[47] = i63;
   HEAP32[i5 + 4 >> 2] = i63 | 1;
   HEAP32[i5 + i63 + 4 >> 2] = 40;
   HEAP32[51] = HEAP32[166];
  } while (0);
  i59 = HEAP32[47] | 0;
  if (i59 >>> 0 > i31 >>> 0) {
   i58 = i59 - i31 | 0;
   HEAP32[47] = i58;
   i59 = HEAP32[50] | 0;
   i60 = i59 + i31 | 0;
   HEAP32[50] = i60;
   HEAP32[i60 + 4 >> 2] = i58 | 1;
   HEAP32[i59 + 4 >> 2] = i31 | 3;
   i13 = i59 + 8 | 0;
   return i13 | 0;
  }
 }
 HEAP32[(___errno_location() | 0) >> 2] = 12;
 i13 = 0;
 return i13 | 0;
}

function _free(i1) {
 i1 = i1 | 0;
 var i2 = 0, i3 = 0, i4 = 0, i5 = 0, i6 = 0, i7 = 0, i8 = 0, i9 = 0, i10 = 0, i11 = 0, i12 = 0, i13 = 0, i14 = 0, i15 = 0, i16 = 0, i17 = 0, i18 = 0, i19 = 0, i20 = 0, i21 = 0, i22 = 0, i23 = 0, i24 = 0, i25 = 0, i26 = 0, i27 = 0, i28 = 0, i29 = 0, i30 = 0, i31 = 0, i32 = 0, i33 = 0, i34 = 0, i35 = 0, i36 = 0, i37 = 0;
 if (!i1) return;
 i2 = i1 + -8 | 0;
 i3 = HEAP32[48] | 0;
 if (i2 >>> 0 < i3 >>> 0) _abort();
 i4 = HEAP32[i1 + -4 >> 2] | 0;
 i1 = i4 & 3;
 if ((i1 | 0) == 1) _abort();
 i5 = i4 & -8;
 i6 = i2 + i5 | 0;
 do if (!(i4 & 1)) {
  i7 = HEAP32[i2 >> 2] | 0;
  if (!i1) return;
  i8 = i2 + (0 - i7) | 0;
  i9 = i7 + i5 | 0;
  if (i8 >>> 0 < i3 >>> 0) _abort();
  if ((i8 | 0) == (HEAP32[49] | 0)) {
   i10 = i6 + 4 | 0;
   i11 = HEAP32[i10 >> 2] | 0;
   if ((i11 & 3 | 0) != 3) {
    i12 = i8;
    i13 = i9;
    break;
   }
   HEAP32[46] = i9;
   HEAP32[i10 >> 2] = i11 & -2;
   HEAP32[i8 + 4 >> 2] = i9 | 1;
   HEAP32[i8 + i9 >> 2] = i9;
   return;
  }
  i11 = i7 >>> 3;
  if (i7 >>> 0 < 256) {
   i7 = HEAP32[i8 + 8 >> 2] | 0;
   i10 = HEAP32[i8 + 12 >> 2] | 0;
   i14 = 216 + (i11 << 1 << 2) | 0;
   if ((i7 | 0) != (i14 | 0)) {
    if (i7 >>> 0 < i3 >>> 0) _abort();
    if ((HEAP32[i7 + 12 >> 2] | 0) != (i8 | 0)) _abort();
   }
   if ((i10 | 0) == (i7 | 0)) {
    HEAP32[44] = HEAP32[44] & ~(1 << i11);
    i12 = i8;
    i13 = i9;
    break;
   }
   if ((i10 | 0) != (i14 | 0)) {
    if (i10 >>> 0 < i3 >>> 0) _abort();
    i14 = i10 + 8 | 0;
    if ((HEAP32[i14 >> 2] | 0) == (i8 | 0)) i15 = i14; else _abort();
   } else i15 = i10 + 8 | 0;
   HEAP32[i7 + 12 >> 2] = i10;
   HEAP32[i15 >> 2] = i7;
   i12 = i8;
   i13 = i9;
   break;
  }
  i7 = HEAP32[i8 + 24 >> 2] | 0;
  i10 = HEAP32[i8 + 12 >> 2] | 0;
  do if ((i10 | 0) == (i8 | 0)) {
   i14 = i8 + 16 | 0;
   i11 = i14 + 4 | 0;
   i16 = HEAP32[i11 >> 2] | 0;
   if (!i16) {
    i17 = HEAP32[i14 >> 2] | 0;
    if (!i17) {
     i18 = 0;
     break;
    } else {
     i19 = i17;
     i20 = i14;
    }
   } else {
    i19 = i16;
    i20 = i11;
   }
   while (1) {
    i11 = i19 + 20 | 0;
    i16 = HEAP32[i11 >> 2] | 0;
    if (i16) {
     i19 = i16;
     i20 = i11;
     continue;
    }
    i11 = i19 + 16 | 0;
    i16 = HEAP32[i11 >> 2] | 0;
    if (!i16) {
     i21 = i19;
     i22 = i20;
     break;
    } else {
     i19 = i16;
     i20 = i11;
    }
   }
   if (i22 >>> 0 < i3 >>> 0) _abort(); else {
    HEAP32[i22 >> 2] = 0;
    i18 = i21;
    break;
   }
  } else {
   i11 = HEAP32[i8 + 8 >> 2] | 0;
   if (i11 >>> 0 < i3 >>> 0) _abort();
   i16 = i11 + 12 | 0;
   if ((HEAP32[i16 >> 2] | 0) != (i8 | 0)) _abort();
   i14 = i10 + 8 | 0;
   if ((HEAP32[i14 >> 2] | 0) == (i8 | 0)) {
    HEAP32[i16 >> 2] = i10;
    HEAP32[i14 >> 2] = i11;
    i18 = i10;
    break;
   } else _abort();
  } while (0);
  if (i7) {
   i10 = HEAP32[i8 + 28 >> 2] | 0;
   i11 = 480 + (i10 << 2) | 0;
   if ((i8 | 0) == (HEAP32[i11 >> 2] | 0)) {
    HEAP32[i11 >> 2] = i18;
    if (!i18) {
     HEAP32[45] = HEAP32[45] & ~(1 << i10);
     i12 = i8;
     i13 = i9;
     break;
    }
   } else {
    if (i7 >>> 0 < (HEAP32[48] | 0) >>> 0) _abort();
    i10 = i7 + 16 | 0;
    if ((HEAP32[i10 >> 2] | 0) == (i8 | 0)) HEAP32[i10 >> 2] = i18; else HEAP32[i7 + 20 >> 2] = i18;
    if (!i18) {
     i12 = i8;
     i13 = i9;
     break;
    }
   }
   i10 = HEAP32[48] | 0;
   if (i18 >>> 0 < i10 >>> 0) _abort();
   HEAP32[i18 + 24 >> 2] = i7;
   i11 = i8 + 16 | 0;
   i14 = HEAP32[i11 >> 2] | 0;
   do if (i14) if (i14 >>> 0 < i10 >>> 0) _abort(); else {
    HEAP32[i18 + 16 >> 2] = i14;
    HEAP32[i14 + 24 >> 2] = i18;
    break;
   } while (0);
   i14 = HEAP32[i11 + 4 >> 2] | 0;
   if (i14) if (i14 >>> 0 < (HEAP32[48] | 0) >>> 0) _abort(); else {
    HEAP32[i18 + 20 >> 2] = i14;
    HEAP32[i14 + 24 >> 2] = i18;
    i12 = i8;
    i13 = i9;
    break;
   } else {
    i12 = i8;
    i13 = i9;
   }
  } else {
   i12 = i8;
   i13 = i9;
  }
 } else {
  i12 = i2;
  i13 = i5;
 } while (0);
 if (i12 >>> 0 >= i6 >>> 0) _abort();
 i5 = i6 + 4 | 0;
 i2 = HEAP32[i5 >> 2] | 0;
 if (!(i2 & 1)) _abort();
 if (!(i2 & 2)) {
  if ((i6 | 0) == (HEAP32[50] | 0)) {
   i18 = (HEAP32[47] | 0) + i13 | 0;
   HEAP32[47] = i18;
   HEAP32[50] = i12;
   HEAP32[i12 + 4 >> 2] = i18 | 1;
   if ((i12 | 0) != (HEAP32[49] | 0)) return;
   HEAP32[49] = 0;
   HEAP32[46] = 0;
   return;
  }
  if ((i6 | 0) == (HEAP32[49] | 0)) {
   i18 = (HEAP32[46] | 0) + i13 | 0;
   HEAP32[46] = i18;
   HEAP32[49] = i12;
   HEAP32[i12 + 4 >> 2] = i18 | 1;
   HEAP32[i12 + i18 >> 2] = i18;
   return;
  }
  i18 = (i2 & -8) + i13 | 0;
  i3 = i2 >>> 3;
  do if (i2 >>> 0 >= 256) {
   i21 = HEAP32[i6 + 24 >> 2] | 0;
   i22 = HEAP32[i6 + 12 >> 2] | 0;
   do if ((i22 | 0) == (i6 | 0)) {
    i20 = i6 + 16 | 0;
    i19 = i20 + 4 | 0;
    i15 = HEAP32[i19 >> 2] | 0;
    if (!i15) {
     i1 = HEAP32[i20 >> 2] | 0;
     if (!i1) {
      i23 = 0;
      break;
     } else {
      i24 = i1;
      i25 = i20;
     }
    } else {
     i24 = i15;
     i25 = i19;
    }
    while (1) {
     i19 = i24 + 20 | 0;
     i15 = HEAP32[i19 >> 2] | 0;
     if (i15) {
      i24 = i15;
      i25 = i19;
      continue;
     }
     i19 = i24 + 16 | 0;
     i15 = HEAP32[i19 >> 2] | 0;
     if (!i15) {
      i26 = i24;
      i27 = i25;
      break;
     } else {
      i24 = i15;
      i25 = i19;
     }
    }
    if (i27 >>> 0 < (HEAP32[48] | 0) >>> 0) _abort(); else {
     HEAP32[i27 >> 2] = 0;
     i23 = i26;
     break;
    }
   } else {
    i19 = HEAP32[i6 + 8 >> 2] | 0;
    if (i19 >>> 0 < (HEAP32[48] | 0) >>> 0) _abort();
    i15 = i19 + 12 | 0;
    if ((HEAP32[i15 >> 2] | 0) != (i6 | 0)) _abort();
    i20 = i22 + 8 | 0;
    if ((HEAP32[i20 >> 2] | 0) == (i6 | 0)) {
     HEAP32[i15 >> 2] = i22;
     HEAP32[i20 >> 2] = i19;
     i23 = i22;
     break;
    } else _abort();
   } while (0);
   if (i21) {
    i22 = HEAP32[i6 + 28 >> 2] | 0;
    i9 = 480 + (i22 << 2) | 0;
    if ((i6 | 0) == (HEAP32[i9 >> 2] | 0)) {
     HEAP32[i9 >> 2] = i23;
     if (!i23) {
      HEAP32[45] = HEAP32[45] & ~(1 << i22);
      break;
     }
    } else {
     if (i21 >>> 0 < (HEAP32[48] | 0) >>> 0) _abort();
     i22 = i21 + 16 | 0;
     if ((HEAP32[i22 >> 2] | 0) == (i6 | 0)) HEAP32[i22 >> 2] = i23; else HEAP32[i21 + 20 >> 2] = i23;
     if (!i23) break;
    }
    i22 = HEAP32[48] | 0;
    if (i23 >>> 0 < i22 >>> 0) _abort();
    HEAP32[i23 + 24 >> 2] = i21;
    i9 = i6 + 16 | 0;
    i8 = HEAP32[i9 >> 2] | 0;
    do if (i8) if (i8 >>> 0 < i22 >>> 0) _abort(); else {
     HEAP32[i23 + 16 >> 2] = i8;
     HEAP32[i8 + 24 >> 2] = i23;
     break;
    } while (0);
    i8 = HEAP32[i9 + 4 >> 2] | 0;
    if (i8) if (i8 >>> 0 < (HEAP32[48] | 0) >>> 0) _abort(); else {
     HEAP32[i23 + 20 >> 2] = i8;
     HEAP32[i8 + 24 >> 2] = i23;
     break;
    }
   }
  } else {
   i8 = HEAP32[i6 + 8 >> 2] | 0;
   i22 = HEAP32[i6 + 12 >> 2] | 0;
   i21 = 216 + (i3 << 1 << 2) | 0;
   if ((i8 | 0) != (i21 | 0)) {
    if (i8 >>> 0 < (HEAP32[48] | 0) >>> 0) _abort();
    if ((HEAP32[i8 + 12 >> 2] | 0) != (i6 | 0)) _abort();
   }
   if ((i22 | 0) == (i8 | 0)) {
    HEAP32[44] = HEAP32[44] & ~(1 << i3);
    break;
   }
   if ((i22 | 0) != (i21 | 0)) {
    if (i22 >>> 0 < (HEAP32[48] | 0) >>> 0) _abort();
    i21 = i22 + 8 | 0;
    if ((HEAP32[i21 >> 2] | 0) == (i6 | 0)) i28 = i21; else _abort();
   } else i28 = i22 + 8 | 0;
   HEAP32[i8 + 12 >> 2] = i22;
   HEAP32[i28 >> 2] = i8;
  } while (0);
  HEAP32[i12 + 4 >> 2] = i18 | 1;
  HEAP32[i12 + i18 >> 2] = i18;
  if ((i12 | 0) == (HEAP32[49] | 0)) {
   HEAP32[46] = i18;
   return;
  } else i29 = i18;
 } else {
  HEAP32[i5 >> 2] = i2 & -2;
  HEAP32[i12 + 4 >> 2] = i13 | 1;
  HEAP32[i12 + i13 >> 2] = i13;
  i29 = i13;
 }
 i13 = i29 >>> 3;
 if (i29 >>> 0 < 256) {
  i2 = 216 + (i13 << 1 << 2) | 0;
  i5 = HEAP32[44] | 0;
  i18 = 1 << i13;
  if (i5 & i18) {
   i13 = i2 + 8 | 0;
   i28 = HEAP32[i13 >> 2] | 0;
   if (i28 >>> 0 < (HEAP32[48] | 0) >>> 0) _abort(); else {
    i30 = i13;
    i31 = i28;
   }
  } else {
   HEAP32[44] = i5 | i18;
   i30 = i2 + 8 | 0;
   i31 = i2;
  }
  HEAP32[i30 >> 2] = i12;
  HEAP32[i31 + 12 >> 2] = i12;
  HEAP32[i12 + 8 >> 2] = i31;
  HEAP32[i12 + 12 >> 2] = i2;
  return;
 }
 i2 = i29 >>> 8;
 if (i2) if (i29 >>> 0 > 16777215) i32 = 31; else {
  i31 = (i2 + 1048320 | 0) >>> 16 & 8;
  i30 = i2 << i31;
  i2 = (i30 + 520192 | 0) >>> 16 & 4;
  i18 = i30 << i2;
  i30 = (i18 + 245760 | 0) >>> 16 & 2;
  i5 = 14 - (i2 | i31 | i30) + (i18 << i30 >>> 15) | 0;
  i32 = i29 >>> (i5 + 7 | 0) & 1 | i5 << 1;
 } else i32 = 0;
 i5 = 480 + (i32 << 2) | 0;
 HEAP32[i12 + 28 >> 2] = i32;
 HEAP32[i12 + 20 >> 2] = 0;
 HEAP32[i12 + 16 >> 2] = 0;
 i30 = HEAP32[45] | 0;
 i18 = 1 << i32;
 do if (i30 & i18) {
  i31 = i29 << ((i32 | 0) == 31 ? 0 : 25 - (i32 >>> 1) | 0);
  i2 = HEAP32[i5 >> 2] | 0;
  while (1) {
   if ((HEAP32[i2 + 4 >> 2] & -8 | 0) == (i29 | 0)) {
    i33 = i2;
    i34 = 130;
    break;
   }
   i28 = i2 + 16 + (i31 >>> 31 << 2) | 0;
   i13 = HEAP32[i28 >> 2] | 0;
   if (!i13) {
    i35 = i28;
    i36 = i2;
    i34 = 127;
    break;
   } else {
    i31 = i31 << 1;
    i2 = i13;
   }
  }
  if ((i34 | 0) == 127) if (i35 >>> 0 < (HEAP32[48] | 0) >>> 0) _abort(); else {
   HEAP32[i35 >> 2] = i12;
   HEAP32[i12 + 24 >> 2] = i36;
   HEAP32[i12 + 12 >> 2] = i12;
   HEAP32[i12 + 8 >> 2] = i12;
   break;
  } else if ((i34 | 0) == 130) {
   i2 = i33 + 8 | 0;
   i31 = HEAP32[i2 >> 2] | 0;
   i9 = HEAP32[48] | 0;
   if (i31 >>> 0 >= i9 >>> 0 & i33 >>> 0 >= i9 >>> 0) {
    HEAP32[i31 + 12 >> 2] = i12;
    HEAP32[i2 >> 2] = i12;
    HEAP32[i12 + 8 >> 2] = i31;
    HEAP32[i12 + 12 >> 2] = i33;
    HEAP32[i12 + 24 >> 2] = 0;
    break;
   } else _abort();
  }
 } else {
  HEAP32[45] = i30 | i18;
  HEAP32[i5 >> 2] = i12;
  HEAP32[i12 + 24 >> 2] = i5;
  HEAP32[i12 + 12 >> 2] = i12;
  HEAP32[i12 + 8 >> 2] = i12;
 } while (0);
 i12 = (HEAP32[52] | 0) + -1 | 0;
 HEAP32[52] = i12;
 if (!i12) i37 = 632; else return;
 while (1) {
  i12 = HEAP32[i37 >> 2] | 0;
  if (!i12) break; else i37 = i12 + 8 | 0;
 }
 HEAP32[52] = -1;
 return;
}

function ___stdio_write(i1, i2, i3) {
 i1 = i1 | 0;
 i2 = i2 | 0;
 i3 = i3 | 0;
 var i4 = 0, i5 = 0, i6 = 0, i7 = 0, i8 = 0, i9 = 0, i10 = 0, i11 = 0, i12 = 0, i13 = 0, i14 = 0, i15 = 0, i16 = 0, i17 = 0, i18 = 0, i19 = 0, i20 = 0, i21 = 0, i22 = 0, i23 = 0, i24 = 0;
 i4 = STACKTOP;
 STACKTOP = STACKTOP + 48 | 0;
 i5 = i4 + 16 | 0;
 i6 = i4;
 i7 = i4 + 32 | 0;
 i8 = i1 + 28 | 0;
 i9 = HEAP32[i8 >> 2] | 0;
 HEAP32[i7 >> 2] = i9;
 i10 = i1 + 20 | 0;
 i11 = (HEAP32[i10 >> 2] | 0) - i9 | 0;
 HEAP32[i7 + 4 >> 2] = i11;
 HEAP32[i7 + 8 >> 2] = i2;
 HEAP32[i7 + 12 >> 2] = i3;
 i2 = i1 + 60 | 0;
 i9 = i1 + 44 | 0;
 i12 = i7;
 i7 = 2;
 i13 = i11 + i3 | 0;
 while (1) {
  if (!(HEAP32[2] | 0)) {
   HEAP32[i5 >> 2] = HEAP32[i2 >> 2];
   HEAP32[i5 + 4 >> 2] = i12;
   HEAP32[i5 + 8 >> 2] = i7;
   i14 = ___syscall_ret(___syscall146(146, i5 | 0) | 0) | 0;
  } else {
   _pthread_cleanup_push(4, i1 | 0);
   HEAP32[i6 >> 2] = HEAP32[i2 >> 2];
   HEAP32[i6 + 4 >> 2] = i12;
   HEAP32[i6 + 8 >> 2] = i7;
   i11 = ___syscall_ret(___syscall146(146, i6 | 0) | 0) | 0;
   _pthread_cleanup_pop(0);
   i14 = i11;
  }
  if ((i13 | 0) == (i14 | 0)) {
   i15 = 6;
   break;
  }
  if ((i14 | 0) < 0) {
   i16 = i12;
   i17 = i7;
   i15 = 8;
   break;
  }
  i11 = i13 - i14 | 0;
  i18 = HEAP32[i12 + 4 >> 2] | 0;
  if (i14 >>> 0 <= i18 >>> 0) if ((i7 | 0) == 2) {
   HEAP32[i8 >> 2] = (HEAP32[i8 >> 2] | 0) + i14;
   i19 = i18;
   i20 = i14;
   i21 = i12;
   i22 = 2;
  } else {
   i19 = i18;
   i20 = i14;
   i21 = i12;
   i22 = i7;
  } else {
   i23 = HEAP32[i9 >> 2] | 0;
   HEAP32[i8 >> 2] = i23;
   HEAP32[i10 >> 2] = i23;
   i19 = HEAP32[i12 + 12 >> 2] | 0;
   i20 = i14 - i18 | 0;
   i21 = i12 + 8 | 0;
   i22 = i7 + -1 | 0;
  }
  HEAP32[i21 >> 2] = (HEAP32[i21 >> 2] | 0) + i20;
  HEAP32[i21 + 4 >> 2] = i19 - i20;
  i12 = i21;
  i7 = i22;
  i13 = i11;
 }
 if ((i15 | 0) == 6) {
  i13 = HEAP32[i9 >> 2] | 0;
  HEAP32[i1 + 16 >> 2] = i13 + (HEAP32[i1 + 48 >> 2] | 0);
  i9 = i13;
  HEAP32[i8 >> 2] = i9;
  HEAP32[i10 >> 2] = i9;
  i24 = i3;
 } else if ((i15 | 0) == 8) {
  HEAP32[i1 + 16 >> 2] = 0;
  HEAP32[i8 >> 2] = 0;
  HEAP32[i10 >> 2] = 0;
  HEAP32[i1 >> 2] = HEAP32[i1 >> 2] | 32;
  if ((i17 | 0) == 2) i24 = 0; else i24 = i3 - (HEAP32[i16 + 4 >> 2] | 0) | 0;
 }
 STACKTOP = i4;
 return i24 | 0;
}

function ___fwritex(i1, i2, i3) {
 i1 = i1 | 0;
 i2 = i2 | 0;
 i3 = i3 | 0;
 var i4 = 0, i5 = 0, i6 = 0, i7 = 0, i8 = 0, i9 = 0, i10 = 0, i11 = 0, i12 = 0, i13 = 0, i14 = 0, i15 = 0;
 i4 = i3 + 16 | 0;
 i5 = HEAP32[i4 >> 2] | 0;
 if (!i5) if (!(___towrite(i3) | 0)) {
  i6 = HEAP32[i4 >> 2] | 0;
  i7 = 5;
 } else i8 = 0; else {
  i6 = i5;
  i7 = 5;
 }
 L5 : do if ((i7 | 0) == 5) {
  i5 = i3 + 20 | 0;
  i4 = HEAP32[i5 >> 2] | 0;
  i9 = i4;
  if ((i6 - i4 | 0) >>> 0 < i2 >>> 0) {
   i8 = FUNCTION_TABLE_iiii[HEAP32[i3 + 36 >> 2] & 7](i3, i1, i2) | 0;
   break;
  }
  L10 : do if ((HEAP8[i3 + 75 >> 0] | 0) > -1) {
   i4 = i2;
   while (1) {
    if (!i4) {
     i10 = i2;
     i11 = i1;
     i12 = i9;
     i13 = 0;
     break L10;
    }
    i14 = i4 + -1 | 0;
    if ((HEAP8[i1 + i14 >> 0] | 0) == 10) {
     i15 = i4;
     break;
    } else i4 = i14;
   }
   if ((FUNCTION_TABLE_iiii[HEAP32[i3 + 36 >> 2] & 7](i3, i1, i15) | 0) >>> 0 < i15 >>> 0) {
    i8 = i15;
    break L5;
   }
   i10 = i2 - i15 | 0;
   i11 = i1 + i15 | 0;
   i12 = HEAP32[i5 >> 2] | 0;
   i13 = i15;
  } else {
   i10 = i2;
   i11 = i1;
   i12 = i9;
   i13 = 0;
  } while (0);
  _memcpy(i12 | 0, i11 | 0, i10 | 0) | 0;
  HEAP32[i5 >> 2] = (HEAP32[i5 >> 2] | 0) + i10;
  i8 = i13 + i10 | 0;
 } while (0);
 return i8 | 0;
}

function _fflush(i1) {
 i1 = i1 | 0;
 var i2 = 0, i3 = 0, i4 = 0, i5 = 0, i6 = 0, i7 = 0, i8 = 0;
 do if (i1) {
  if ((HEAP32[i1 + 76 >> 2] | 0) <= -1) {
   i2 = ___fflush_unlocked(i1) | 0;
   break;
  }
  i3 = (___lockfile(i1) | 0) == 0;
  i4 = ___fflush_unlocked(i1) | 0;
  if (i3) i2 = i4; else {
   ___unlockfile(i1);
   i2 = i4;
  }
 } else {
  if (!(HEAP32[14] | 0)) i5 = 0; else i5 = _fflush(HEAP32[14] | 0) | 0;
  ___lock(36);
  i4 = HEAP32[8] | 0;
  if (!i4) i6 = i5; else {
   i3 = i4;
   i4 = i5;
   while (1) {
    if ((HEAP32[i3 + 76 >> 2] | 0) > -1) i7 = ___lockfile(i3) | 0; else i7 = 0;
    if ((HEAP32[i3 + 20 >> 2] | 0) >>> 0 > (HEAP32[i3 + 28 >> 2] | 0) >>> 0) i8 = ___fflush_unlocked(i3) | 0 | i4; else i8 = i4;
    if (i7) ___unlockfile(i3);
    i3 = HEAP32[i3 + 56 >> 2] | 0;
    if (!i3) {
     i6 = i8;
     break;
    } else i4 = i8;
   }
  }
  ___unlock(36);
  i2 = i6;
 } while (0);
 return i2 | 0;
}

function _strlen(i1) {
 i1 = i1 | 0;
 var i2 = 0, i3 = 0, i4 = 0, i5 = 0, i6 = 0, i7 = 0, i8 = 0, i9 = 0, i10 = 0, i11 = 0;
 i2 = i1;
 L1 : do if (!(i2 & 3)) {
  i3 = i1;
  i4 = 4;
 } else {
  i5 = i1;
  i6 = i2;
  while (1) {
   if (!(HEAP8[i5 >> 0] | 0)) {
    i7 = i6;
    break L1;
   }
   i8 = i5 + 1 | 0;
   i6 = i8;
   if (!(i6 & 3)) {
    i3 = i8;
    i4 = 4;
    break;
   } else i5 = i8;
  }
 } while (0);
 if ((i4 | 0) == 4) {
  i4 = i3;
  while (1) {
   i3 = HEAP32[i4 >> 2] | 0;
   if (!((i3 & -2139062144 ^ -2139062144) & i3 + -16843009)) i4 = i4 + 4 | 0; else {
    i9 = i3;
    i10 = i4;
    break;
   }
  }
  if (!((i9 & 255) << 24 >> 24)) i11 = i10; else {
   i9 = i10;
   while (1) {
    i10 = i9 + 1 | 0;
    if (!(HEAP8[i10 >> 0] | 0)) {
     i11 = i10;
     break;
    } else i9 = i10;
   }
  }
  i7 = i11;
 }
 return i7 - i2 | 0;
}

function ___overflow(i1, i2) {
 i1 = i1 | 0;
 i2 = i2 | 0;
 var i3 = 0, i4 = 0, i5 = 0, i6 = 0, i7 = 0, i8 = 0, i9 = 0, i10 = 0, i11 = 0;
 i3 = STACKTOP;
 STACKTOP = STACKTOP + 16 | 0;
 i4 = i3;
 i5 = i2 & 255;
 HEAP8[i4 >> 0] = i5;
 i6 = i1 + 16 | 0;
 i7 = HEAP32[i6 >> 2] | 0;
 if (!i7) if (!(___towrite(i1) | 0)) {
  i8 = HEAP32[i6 >> 2] | 0;
  i9 = 4;
 } else i10 = -1; else {
  i8 = i7;
  i9 = 4;
 }
 do if ((i9 | 0) == 4) {
  i7 = i1 + 20 | 0;
  i6 = HEAP32[i7 >> 2] | 0;
  if (i6 >>> 0 < i8 >>> 0 ? (i11 = i2 & 255, (i11 | 0) != (HEAP8[i1 + 75 >> 0] | 0)) : 0) {
   HEAP32[i7 >> 2] = i6 + 1;
   HEAP8[i6 >> 0] = i5;
   i10 = i11;
   break;
  }
  if ((FUNCTION_TABLE_iiii[HEAP32[i1 + 36 >> 2] & 7](i1, i4, 1) | 0) == 1) i10 = HEAPU8[i4 >> 0] | 0; else i10 = -1;
 } while (0);
 STACKTOP = i3;
 return i10 | 0;
}

function ___fflush_unlocked(i1) {
 i1 = i1 | 0;
 var i2 = 0, i3 = 0, i4 = 0, i5 = 0, i6 = 0, i7 = 0, i8 = 0;
 i2 = i1 + 20 | 0;
 i3 = i1 + 28 | 0;
 if ((HEAP32[i2 >> 2] | 0) >>> 0 > (HEAP32[i3 >> 2] | 0) >>> 0 ? (FUNCTION_TABLE_iiii[HEAP32[i1 + 36 >> 2] & 7](i1, 0, 0) | 0, (HEAP32[i2 >> 2] | 0) == 0) : 0) i4 = -1; else {
  i5 = i1 + 4 | 0;
  i6 = HEAP32[i5 >> 2] | 0;
  i7 = i1 + 8 | 0;
  i8 = HEAP32[i7 >> 2] | 0;
  if (i6 >>> 0 < i8 >>> 0) FUNCTION_TABLE_iiii[HEAP32[i1 + 40 >> 2] & 7](i1, i6 - i8 | 0, 1) | 0;
  HEAP32[i1 + 16 >> 2] = 0;
  HEAP32[i3 >> 2] = 0;
  HEAP32[i2 >> 2] = 0;
  HEAP32[i7 >> 2] = 0;
  HEAP32[i5 >> 2] = 0;
  i4 = 0;
 }
 return i4 | 0;
}

function _memcpy(i1, i2, i3) {
 i1 = i1 | 0;
 i2 = i2 | 0;
 i3 = i3 | 0;
 var i4 = 0;
 if ((i3 | 0) >= 4096) return _emscripten_memcpy_big(i1 | 0, i2 | 0, i3 | 0) | 0;
 i4 = i1 | 0;
 if ((i1 & 3) == (i2 & 3)) {
  while (i1 & 3) {
   if (!i3) return i4 | 0;
   HEAP8[i1 >> 0] = HEAP8[i2 >> 0] | 0;
   i1 = i1 + 1 | 0;
   i2 = i2 + 1 | 0;
   i3 = i3 - 1 | 0;
  }
  while ((i3 | 0) >= 4) {
   HEAP32[i1 >> 2] = HEAP32[i2 >> 2];
   i1 = i1 + 4 | 0;
   i2 = i2 + 4 | 0;
   i3 = i3 - 4 | 0;
  }
 }
 while ((i3 | 0) > 0) {
  HEAP8[i1 >> 0] = HEAP8[i2 >> 0] | 0;
  i1 = i1 + 1 | 0;
  i2 = i2 + 1 | 0;
  i3 = i3 - 1 | 0;
 }
 return i4 | 0;
}

function runPostSets() {}
function _memset(i1, i2, i3) {
 i1 = i1 | 0;
 i2 = i2 | 0;
 i3 = i3 | 0;
 var i4 = 0, i5 = 0, i6 = 0, i7 = 0;
 i4 = i1 + i3 | 0;
 if ((i3 | 0) >= 20) {
  i2 = i2 & 255;
  i5 = i1 & 3;
  i6 = i2 | i2 << 8 | i2 << 16 | i2 << 24;
  i7 = i4 & ~3;
  if (i5) {
   i5 = i1 + 4 - i5 | 0;
   while ((i1 | 0) < (i5 | 0)) {
    HEAP8[i1 >> 0] = i2;
    i1 = i1 + 1 | 0;
   }
  }
  while ((i1 | 0) < (i7 | 0)) {
   HEAP32[i1 >> 2] = i6;
   i1 = i1 + 4 | 0;
  }
 }
 while ((i1 | 0) < (i4 | 0)) {
  HEAP8[i1 >> 0] = i2;
  i1 = i1 + 1 | 0;
 }
 return i1 - i3 | 0;
}

function _puts(i1) {
 i1 = i1 | 0;
 var i2 = 0, i3 = 0, i4 = 0, i5 = 0, i6 = 0;
 i2 = HEAP32[13] | 0;
 if ((HEAP32[i2 + 76 >> 2] | 0) > -1) i3 = ___lockfile(i2) | 0; else i3 = 0;
 do if ((_fputs(i1, i2) | 0) < 0) i4 = 1; else {
  if ((HEAP8[i2 + 75 >> 0] | 0) != 10 ? (i5 = i2 + 20 | 0, i6 = HEAP32[i5 >> 2] | 0, i6 >>> 0 < (HEAP32[i2 + 16 >> 2] | 0) >>> 0) : 0) {
   HEAP32[i5 >> 2] = i6 + 1;
   HEAP8[i6 >> 0] = 10;
   i4 = 0;
   break;
  }
  i4 = (___overflow(i2, 10) | 0) < 0;
 } while (0);
 if (i3) ___unlockfile(i2);
 return i4 << 31 >> 31 | 0;
}

function ___stdio_seek(i1, i2, i3) {
 i1 = i1 | 0;
 i2 = i2 | 0;
 i3 = i3 | 0;
 var i4 = 0, i5 = 0, i6 = 0, i7 = 0;
 i4 = STACKTOP;
 STACKTOP = STACKTOP + 32 | 0;
 i5 = i4;
 i6 = i4 + 20 | 0;
 HEAP32[i5 >> 2] = HEAP32[i1 + 60 >> 2];
 HEAP32[i5 + 4 >> 2] = 0;
 HEAP32[i5 + 8 >> 2] = i2;
 HEAP32[i5 + 12 >> 2] = i6;
 HEAP32[i5 + 16 >> 2] = i3;
 if ((___syscall_ret(___syscall140(140, i5 | 0) | 0) | 0) < 0) {
  HEAP32[i6 >> 2] = -1;
  i7 = -1;
 } else i7 = HEAP32[i6 >> 2] | 0;
 STACKTOP = i4;
 return i7 | 0;
}

function ___towrite(i1) {
 i1 = i1 | 0;
 var i2 = 0, i3 = 0, i4 = 0;
 i2 = i1 + 74 | 0;
 i3 = HEAP8[i2 >> 0] | 0;
 HEAP8[i2 >> 0] = i3 + 255 | i3;
 i3 = HEAP32[i1 >> 2] | 0;
 if (!(i3 & 8)) {
  HEAP32[i1 + 8 >> 2] = 0;
  HEAP32[i1 + 4 >> 2] = 0;
  i2 = HEAP32[i1 + 44 >> 2] | 0;
  HEAP32[i1 + 28 >> 2] = i2;
  HEAP32[i1 + 20 >> 2] = i2;
  HEAP32[i1 + 16 >> 2] = i2 + (HEAP32[i1 + 48 >> 2] | 0);
  i4 = 0;
 } else {
  HEAP32[i1 >> 2] = i3 | 32;
  i4 = -1;
 }
 return i4 | 0;
}

function _fwrite(i1, i2, i3, i4) {
 i1 = i1 | 0;
 i2 = i2 | 0;
 i3 = i3 | 0;
 i4 = i4 | 0;
 var i5 = 0, i6 = 0, i7 = 0, i8 = 0, i9 = 0;
 i5 = Math_imul(i3, i2) | 0;
 if ((HEAP32[i4 + 76 >> 2] | 0) > -1) {
  i6 = (___lockfile(i4) | 0) == 0;
  i7 = ___fwritex(i1, i5, i4) | 0;
  if (i6) i8 = i7; else {
   ___unlockfile(i4);
   i8 = i7;
  }
 } else i8 = ___fwritex(i1, i5, i4) | 0;
 if ((i8 | 0) == (i5 | 0)) i9 = i3; else i9 = (i8 >>> 0) / (i2 >>> 0) | 0;
 return i9 | 0;
}

function ___stdout_write(i1, i2, i3) {
 i1 = i1 | 0;
 i2 = i2 | 0;
 i3 = i3 | 0;
 var i4 = 0, i5 = 0;
 i4 = STACKTOP;
 STACKTOP = STACKTOP + 80 | 0;
 i5 = i4;
 HEAP32[i1 + 36 >> 2] = 5;
 if ((HEAP32[i1 >> 2] & 64 | 0) == 0 ? (HEAP32[i5 >> 2] = HEAP32[i1 + 60 >> 2], HEAP32[i5 + 4 >> 2] = 21505, HEAP32[i5 + 8 >> 2] = i4 + 12, (___syscall54(54, i5 | 0) | 0) != 0) : 0) HEAP8[i1 + 75 >> 0] = -1;
 i5 = ___stdio_write(i1, i2, i3) | 0;
 STACKTOP = i4;
 return i5 | 0;
}

function copyTempDouble(i1) {
 i1 = i1 | 0;
 HEAP8[tempDoublePtr >> 0] = HEAP8[i1 >> 0];
 HEAP8[tempDoublePtr + 1 >> 0] = HEAP8[i1 + 1 >> 0];
 HEAP8[tempDoublePtr + 2 >> 0] = HEAP8[i1 + 2 >> 0];
 HEAP8[tempDoublePtr + 3 >> 0] = HEAP8[i1 + 3 >> 0];
 HEAP8[tempDoublePtr + 4 >> 0] = HEAP8[i1 + 4 >> 0];
 HEAP8[tempDoublePtr + 5 >> 0] = HEAP8[i1 + 5 >> 0];
 HEAP8[tempDoublePtr + 6 >> 0] = HEAP8[i1 + 6 >> 0];
 HEAP8[tempDoublePtr + 7 >> 0] = HEAP8[i1 + 7 >> 0];
}

function ___stdio_close(i1) {
 i1 = i1 | 0;
 var i2 = 0, i3 = 0;
 i2 = STACKTOP;
 STACKTOP = STACKTOP + 16 | 0;
 i3 = i2;
 HEAP32[i3 >> 2] = HEAP32[i1 + 60 >> 2];
 i1 = ___syscall_ret(___syscall6(6, i3 | 0) | 0) | 0;
 STACKTOP = i2;
 return i1 | 0;
}

function copyTempFloat(i1) {
 i1 = i1 | 0;
 HEAP8[tempDoublePtr >> 0] = HEAP8[i1 >> 0];
 HEAP8[tempDoublePtr + 1 >> 0] = HEAP8[i1 + 1 >> 0];
 HEAP8[tempDoublePtr + 2 >> 0] = HEAP8[i1 + 2 >> 0];
 HEAP8[tempDoublePtr + 3 >> 0] = HEAP8[i1 + 3 >> 0];
}

function ___syscall_ret(i1) {
 i1 = i1 | 0;
 var i2 = 0;
 if (i1 >>> 0 > 4294963200) {
  HEAP32[(___errno_location() | 0) >> 2] = 0 - i1;
  i2 = -1;
 } else i2 = i1;
 return i2 | 0;
}

function dynCall_iiii(i1, i2, i3, i4) {
 i1 = i1 | 0;
 i2 = i2 | 0;
 i3 = i3 | 0;
 i4 = i4 | 0;
 return FUNCTION_TABLE_iiii[i1 & 7](i2 | 0, i3 | 0, i4 | 0) | 0;
}
function stackAlloc(i1) {
 i1 = i1 | 0;
 var i2 = 0;
 i2 = STACKTOP;
 STACKTOP = STACKTOP + i1 | 0;
 STACKTOP = STACKTOP + 15 & -16;
 return i2 | 0;
}

function ___errno_location() {
 var i1 = 0;
 if (!(HEAP32[2] | 0)) i1 = 60; else i1 = HEAP32[(_pthread_self() | 0) + 60 >> 2] | 0;
 return i1 | 0;
}

function setThrew(i1, i2) {
 i1 = i1 | 0;
 i2 = i2 | 0;
 if (!__THREW__) {
  __THREW__ = i1;
  threwValue = i2;
 }
}

function _fputs(i1, i2) {
 i1 = i1 | 0;
 i2 = i2 | 0;
 return (_fwrite(i1, _strlen(i1) | 0, 1, i2) | 0) + -1 | 0;
}

function dynCall_ii(i1, i2) {
 i1 = i1 | 0;
 i2 = i2 | 0;
 return FUNCTION_TABLE_ii[i1 & 1](i2 | 0) | 0;
}

function _cleanup_418(i1) {
 i1 = i1 | 0;
 if (!(HEAP32[i1 + 68 >> 2] | 0)) ___unlockfile(i1);
 return;
}

function establishStackSpace(i1, i2) {
 i1 = i1 | 0;
 i2 = i2 | 0;
 STACKTOP = i1;
 STACK_MAX = i2;
}

function dynCall_vi(i1, i2) {
 i1 = i1 | 0;
 i2 = i2 | 0;
 FUNCTION_TABLE_vi[i1 & 7](i2 | 0);
}

function b1(i1, i2, i3) {
 i1 = i1 | 0;
 i2 = i2 | 0;
 i3 = i3 | 0;
 abort(1);
 return 0;
}

function stackRestore(i1) {
 i1 = i1 | 0;
 STACKTOP = i1;
}

function setTempRet0(i1) {
 i1 = i1 | 0;
 tempRet0 = i1;
}

function b0(i1) {
 i1 = i1 | 0;
 abort(0);
 return 0;
}

function ___unlockfile(i1) {
 i1 = i1 | 0;
 return;
}

function ___lockfile(i1) {
 i1 = i1 | 0;
 return 0;
}

function getTempRet0() {
 return tempRet0 | 0;
}

function _main() {
 _puts(672) | 0;
 return 0;
}

function stackSave() {
 return STACKTOP | 0;
}

function b2(i1) {
 i1 = i1 | 0;
 abort(2);
}

// EMSCRIPTEN_END_FUNCS
var FUNCTION_TABLE_ii = [b0,___stdio_close];
var FUNCTION_TABLE_iiii = [b1,b1,___stdout_write,___stdio_seek,b1,___stdio_write,b1,b1];
var FUNCTION_TABLE_vi = [b2,b2,b2,b2,_cleanup_418,b2,b2,b2];

  return { _free: _free, _main: _main, _memset: _memset, _malloc: _malloc, _memcpy: _memcpy, _fflush: _fflush, ___errno_location: ___errno_location, runPostSets: runPostSets, stackAlloc: stackAlloc, stackSave: stackSave, stackRestore: stackRestore, establishStackSpace: establishStackSpace, setThrew: setThrew, setTempRet0: setTempRet0, getTempRet0: getTempRet0, dynCall_ii: dynCall_ii, dynCall_iiii: dynCall_iiii, dynCall_vi: dynCall_vi };
})
;