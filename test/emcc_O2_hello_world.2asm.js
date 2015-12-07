function asmFunc(global, env, buffer) {
 "use asm";
 var HEAP8 = new global.Int8Array(buffer);
 var HEAP16 = new global.Int16Array(buffer);
 var HEAP32 = new global.Int32Array(buffer);
 var HEAPU8 = new global.Uint8Array(buffer);
 var HEAPU16 = new global.Uint16Array(buffer);
 var HEAPU32 = new global.Uint32Array(buffer);
 var HEAPF32 = new global.Float32Array(buffer);
 var HEAPF64 = new global.Float64Array(buffer);
 function _malloc(i1) {
  i1 = i1 | 0;
  var i2 = 0, i3 = 0, i4 = 0, i5 = 0, i6 = 0, i7 = 0, i8 = 0, i9 = 0, i10 = 0, i11 = 0, i12 = 0, i13 = 0, i14 = 0, i15 = 0, i16 = 0, i17 = 0, i18 = 0, i19 = 0, i20 = 0, i21 = 0, i22 = 0, i23 = 0, i24 = 0, i25 = 0, i26 = 0, i27 = 0, i28 = 0, i29 = 0, i30 = 0, i31 = 0, i32 = 0, i33 = 0, i34 = 0, i35 = 0, i36 = 0, i37 = 0, i38 = 0, i39 = 0, i40 = 0, i41 = 0, i42 = 0, i43 = 0, i44 = 0, i45 = 0, i46 = 0, i47 = 0, i48 = 0, i49 = 0, i50 = 0, i51 = 0, i52 = 0, i53 = 0, i54 = 0, i55 = 0, i56 = 0, i57 = 0, i58 = 0, i59 = 0, i60 = 0, i61 = 0, i62 = 0, i63 = 0, i64 = 0, i65 = 0, i66 = 0, i67 = 0, i68 = 0, i69 = 0, i70 = 0, i71 = 0, i72 = 0, i73 = 0, i74 = 0, i75 = 0, i76 = 0, i77 = 0, i78 = 0, i79 = 0, i80 = 0, i81 = 0, i82 = 0, i83 = 0, i84 = 0, i85 = 0, i86 = 0, i87 = 0, i88 = 0, i89 = 0, i90 = 0, i91 = 0, i92 = 0, wasm2asm_i32$3 = 0, wasm2asm_i32$2 = 0, wasm2asm_i32$1 = 0, wasm2asm_i32$0 = 0;
  topmost : {
   do_once$0 : {
    if ((i1 >>> 0 | 0) >>> 0 < 245 >>> 0) {
     if ((i1 >>> 0 | 0) >>> 0 < 11 >>> 0) wasm2asm_i32$1 = 16; else wasm2asm_i32$1 = (i1 + 11 | 0) & 4294967288 | 0;
     i2 = wasm2asm_i32$1;
     i3 = i2 >>> 3 | 0;
     i4 = HEAPU32[176 >> 2] | 0;
     i5 = i4 >>> i3 | 0;
     if (i5 & 3 | 0) {
      i6 = ((i5 & 1 | 0) ^ 1 | 0) + i3 | 0;
      i7 = 216 + ((i6 << 1 | 0) << 2 | 0) | 0;
      i8 = i7 + 8 | 0;
      i9 = HEAPU32[i8 >> 2] | 0;
      i10 = i9 + 8 | 0;
      i11 = HEAPU32[i10 >> 2] | 0;
      do_once$1 : {
       if (i7 != i11) {
        if ((i11 >>> 0 | 0) >>> 0 < ((HEAPU32[192 >> 2] | 0) >>> 0 | 0) >>> 0) _abort();
        i12 = i11 + 12 | 0;
        if ((HEAPU32[i12 >> 2] | 0) == i9) {
         HEAP32[i12 >> 2] = i7;
         HEAP32[i8 >> 2] = i11;
         break do_once$1;
        } else _abort();
       } else HEAP32[176 >> 2] = i4 & ((1 << i6 | 0) ^ 4294967295 | 0) | 0;
      }
      i11 = i6 << 3 | 0;
      HEAP32[(i9 + 4 | 0) >> 2] = i11 | 3 | 0;
      i8 = (i9 + i11 | 0) + 4 | 0;
      HEAP32[i8 >> 2] = HEAPU32[i8 >> 2] | 0 | 1 | 0;
      i13 = i10;
      wasm2asm_i32$0 = i13;
      break topmost;
     }
     i8 = HEAPU32[184 >> 2] | 0;
     if ((i2 >>> 0 | 0) >>> 0 > (i8 >>> 0 | 0) >>> 0) {
      if (i5) {
       i11 = 2 << i3 | 0;
       i7 = (i5 << i3 | 0) & (i11 | (0 - i11 | 0) | 0) | 0;
       i11 = (i7 & (0 - i7 | 0) | 0) + 4294967295 | 0;
       i7 = (i11 >>> 12 | 0) & 16 | 0;
       i12 = i11 >>> i7 | 0;
       i11 = (i12 >>> 5 | 0) & 8 | 0;
       i14 = i12 >>> i11 | 0;
       i12 = (i14 >>> 2 | 0) & 4 | 0;
       i15 = i14 >>> i12 | 0;
       i14 = (i15 >>> 1 | 0) & 2 | 0;
       i16 = i15 >>> i14 | 0;
       i15 = (i16 >>> 1 | 0) & 1 | 0;
       i17 = (i11 | i7 | 0 | i12 | 0 | i14 | 0 | i15 | 0) + (i16 >>> i15 | 0) | 0;
       i15 = 216 + ((i17 << 1 | 0) << 2 | 0) | 0;
       i16 = i15 + 8 | 0;
       i14 = HEAPU32[i16 >> 2] | 0;
       i12 = i14 + 8 | 0;
       i7 = HEAPU32[i12 >> 2] | 0;
       do_once$2 : {
        if (i15 != i7) {
         if ((i7 >>> 0 | 0) >>> 0 < ((HEAPU32[192 >> 2] | 0) >>> 0 | 0) >>> 0) _abort();
         i11 = i7 + 12 | 0;
         if ((HEAPU32[i11 >> 2] | 0) == i14) {
          HEAP32[i11 >> 2] = i15;
          HEAP32[i16 >> 2] = i7;
          i18 = HEAPU32[184 >> 2] | 0;
          break do_once$2;
         } else _abort();
        } else {
         HEAP32[176 >> 2] = i4 & ((1 << i17 | 0) ^ 4294967295 | 0) | 0;
         i18 = i8;
        }
       }
       i8 = (i17 << 3 | 0) - i2 | 0;
       HEAP32[(i14 + 4 | 0) >> 2] = i2 | 3 | 0;
       i4 = i14 + i2 | 0;
       HEAP32[(i4 + 4 | 0) >> 2] = i8 | 1 | 0;
       HEAP32[(i4 + i8 | 0) >> 2] = i8;
       if (i18) {
        i7 = HEAPU32[196 >> 2] | 0;
        i16 = i18 >>> 3 | 0;
        i15 = 216 + ((i16 << 1 | 0) << 2 | 0) | 0;
        i3 = HEAPU32[176 >> 2] | 0;
        i5 = 1 << i16 | 0;
        if (i3 & i5 | 0) {
         i16 = i15 + 8 | 0;
         i10 = HEAPU32[i16 >> 2] | 0;
         if ((i10 >>> 0 | 0) >>> 0 < ((HEAPU32[192 >> 2] | 0) >>> 0 | 0) >>> 0) _abort(); else {
          i19 = i16;
          i20 = i10;
         }
        } else {
         HEAP32[176 >> 2] = i3 | i5 | 0;
         i19 = i15 + 8 | 0;
         i20 = i15;
        }
        HEAP32[i19 >> 2] = i7;
        HEAP32[(i20 + 12 | 0) >> 2] = i7;
        HEAP32[(i7 + 8 | 0) >> 2] = i20;
        HEAP32[(i7 + 12 | 0) >> 2] = i15;
       }
       HEAP32[184 >> 2] = i8;
       HEAP32[196 >> 2] = i4;
       i13 = i12;
       wasm2asm_i32$0 = i13;
       break topmost;
      }
      i4 = HEAPU32[180 >> 2] | 0;
      if (i4) {
       i8 = (i4 & (0 - i4 | 0) | 0) + 4294967295 | 0;
       i4 = (i8 >>> 12 | 0) & 16 | 0;
       i15 = i8 >>> i4 | 0;
       i8 = (i15 >>> 5 | 0) & 8 | 0;
       i7 = i15 >>> i8 | 0;
       i15 = (i7 >>> 2 | 0) & 4 | 0;
       i5 = i7 >>> i15 | 0;
       i7 = (i5 >>> 1 | 0) & 2 | 0;
       i3 = i5 >>> i7 | 0;
       i5 = (i3 >>> 1 | 0) & 1 | 0;
       i10 = HEAPU32[(480 + (((i8 | i4 | 0 | i15 | 0 | i7 | 0 | i5 | 0) + (i3 >>> i5 | 0) | 0) << 2 | 0) | 0) >> 2] | 0;
       i5 = ((HEAPU32[(i10 + 4 | 0) >> 2] | 0) & 4294967288 | 0) - i2 | 0;
       i3 = i10;
       i7 = i10;
       while_out$3 : do {
        i10 = HEAPU32[(i3 + 16 | 0) >> 2] | 0;
        if (i10 == 0) {
         i15 = HEAPU32[(i3 + 20 | 0) >> 2] | 0;
         if (i15 == 0) {
          i21 = i5;
          i22 = i7;
          break while_out$3;
         } else i23 = i15;
        } else i23 = i10;
        i10 = ((HEAPU32[(i23 + 4 | 0) >> 2] | 0) & 4294967288 | 0) - i2 | 0;
        i15 = (i10 >>> 0 | 0) >>> 0 < (i5 >>> 0 | 0) >>> 0;
        if (i15) wasm2asm_i32$1 = i10; else wasm2asm_i32$1 = i5;
        i5 = wasm2asm_i32$1;
        i3 = i23;
        if (i15) wasm2asm_i32$1 = i23; else wasm2asm_i32$1 = i7;
        i7 = wasm2asm_i32$1;
        continue while_out$3;
       } while (0);
       i7 = HEAPU32[192 >> 2] | 0;
       if ((i22 >>> 0 | 0) >>> 0 < (i7 >>> 0 | 0) >>> 0) _abort();
       i3 = i22 + i2 | 0;
       if ((i22 >>> 0 | 0) >>> 0 >= (i3 >>> 0 | 0) >>> 0) _abort();
       i5 = HEAPU32[(i22 + 24 | 0) >> 2] | 0;
       i12 = HEAPU32[(i22 + 12 | 0) >> 2] | 0;
       do_once$5 : {
        if (i12 == i22) {
         i14 = i22 + 20 | 0;
         i17 = HEAPU32[i14 >> 2] | 0;
         if (i17 == 0) {
          i15 = i22 + 16 | 0;
          i10 = HEAPU32[i15 >> 2] | 0;
          if (i10 == 0) {
           i24 = 0;
           break do_once$5;
          } else {
           i25 = i10;
           i26 = i15;
          }
         } else {
          i25 = i17;
          i26 = i14;
         }
         while_out$6 : do {
          i14 = i25 + 20 | 0;
          i17 = HEAPU32[i14 >> 2] | 0;
          if (i17) {
           i25 = i17;
           i26 = i14;
           continue while_out$6;
          }
          i14 = i25 + 16 | 0;
          i17 = HEAPU32[i14 >> 2] | 0;
          if (i17 == 0) {
           i27 = i25;
           i28 = i26;
           break while_out$6;
          } else {
           i25 = i17;
           i26 = i14;
          }
          continue while_out$6;
         } while (0);
         if ((i28 >>> 0 | 0) >>> 0 < (i7 >>> 0 | 0) >>> 0) _abort(); else {
          HEAP32[i28 >> 2] = 0;
          i24 = i27;
          break do_once$5;
         }
        } else {
         i14 = HEAPU32[(i22 + 8 | 0) >> 2] | 0;
         if ((i14 >>> 0 | 0) >>> 0 < (i7 >>> 0 | 0) >>> 0) _abort();
         i17 = i14 + 12 | 0;
         if ((HEAPU32[i17 >> 2] | 0) != i22) _abort();
         i15 = i12 + 8 | 0;
         if ((HEAPU32[i15 >> 2] | 0) == i22) {
          HEAP32[i17 >> 2] = i12;
          HEAP32[i15 >> 2] = i14;
          i24 = i12;
          break do_once$5;
         } else _abort();
        }
       }
       do_once$8 : {
        if (i5) {
         i12 = HEAPU32[(i22 + 28 | 0) >> 2] | 0;
         i7 = 480 + (i12 << 2 | 0) | 0;
         if (i22 == (HEAPU32[i7 >> 2] | 0)) {
          HEAP32[i7 >> 2] = i24;
          if (i24 == 0) {
           HEAP32[180 >> 2] = (HEAPU32[180 >> 2] | 0) & ((1 << i12 | 0) ^ 4294967295 | 0) | 0;
           break do_once$8;
          }
         } else {
          if ((i5 >>> 0 | 0) >>> 0 < ((HEAPU32[192 >> 2] | 0) >>> 0 | 0) >>> 0) _abort();
          i12 = i5 + 16 | 0;
          if ((HEAPU32[i12 >> 2] | 0) == i22) HEAP32[i12 >> 2] = i24; else HEAP32[(i5 + 20 | 0) >> 2] = i24;
          if (i24 == 0) break do_once$8;
         }
         i12 = HEAPU32[192 >> 2] | 0;
         if ((i24 >>> 0 | 0) >>> 0 < (i12 >>> 0 | 0) >>> 0) _abort();
         HEAP32[(i24 + 24 | 0) >> 2] = i5;
         i7 = HEAPU32[(i22 + 16 | 0) >> 2] | 0;
         do_once$9 : {
          if (i7) if ((i7 >>> 0 | 0) >>> 0 < (i12 >>> 0 | 0) >>> 0) _abort(); else {
           HEAP32[(i24 + 16 | 0) >> 2] = i7;
           HEAP32[(i7 + 24 | 0) >> 2] = i24;
           break do_once$9;
          }
         }
         i7 = HEAPU32[(i22 + 20 | 0) >> 2] | 0;
         if (i7) if ((i7 >>> 0 | 0) >>> 0 < ((HEAPU32[192 >> 2] | 0) >>> 0 | 0) >>> 0) _abort(); else {
          HEAP32[(i24 + 20 | 0) >> 2] = i7;
          HEAP32[(i7 + 24 | 0) >> 2] = i24;
          break do_once$8;
         }
        }
       }
       if ((i21 >>> 0 | 0) >>> 0 < 16 >>> 0) {
        i5 = i21 + i2 | 0;
        HEAP32[(i22 + 4 | 0) >> 2] = i5 | 3 | 0;
        i7 = (i22 + i5 | 0) + 4 | 0;
        HEAP32[i7 >> 2] = HEAPU32[i7 >> 2] | 0 | 1 | 0;
       } else {
        HEAP32[(i22 + 4 | 0) >> 2] = i2 | 3 | 0;
        HEAP32[(i3 + 4 | 0) >> 2] = i21 | 1 | 0;
        HEAP32[(i3 + i21 | 0) >> 2] = i21;
        i7 = HEAPU32[184 >> 2] | 0;
        if (i7) {
         i5 = HEAPU32[196 >> 2] | 0;
         i12 = i7 >>> 3 | 0;
         i7 = 216 + ((i12 << 1 | 0) << 2 | 0) | 0;
         i14 = HEAPU32[176 >> 2] | 0;
         i15 = 1 << i12 | 0;
         if (i14 & i15 | 0) {
          i12 = i7 + 8 | 0;
          i17 = HEAPU32[i12 >> 2] | 0;
          if ((i17 >>> 0 | 0) >>> 0 < ((HEAPU32[192 >> 2] | 0) >>> 0 | 0) >>> 0) _abort(); else {
           i29 = i12;
           i30 = i17;
          }
         } else {
          HEAP32[176 >> 2] = i14 | i15 | 0;
          i29 = i7 + 8 | 0;
          i30 = i7;
         }
         HEAP32[i29 >> 2] = i5;
         HEAP32[(i30 + 12 | 0) >> 2] = i5;
         HEAP32[(i5 + 8 | 0) >> 2] = i30;
         HEAP32[(i5 + 12 | 0) >> 2] = i7;
        }
        HEAP32[184 >> 2] = i21;
        HEAP32[196 >> 2] = i3;
       }
       i13 = i22 + 8 | 0;
       wasm2asm_i32$0 = i13;
       break topmost;
      } else i31 = i2;
     } else i31 = i2;
    } else if ((i1 >>> 0 | 0) >>> 0 <= 4294967231 >>> 0) {
     i7 = i1 + 11 | 0;
     i5 = i7 & 4294967288 | 0;
     i15 = HEAPU32[180 >> 2] | 0;
     if (i15) {
      i14 = 0 - i5 | 0;
      i17 = i7 >>> 8 | 0;
      if (i17) if ((i5 >>> 0 | 0) >>> 0 > 16777215 >>> 0) i32 = 31; else {
       i7 = ((i17 + 1048320 | 0) >>> 16 | 0) & 8 | 0;
       i12 = i17 << i7 | 0;
       i17 = ((i12 + 520192 | 0) >>> 16 | 0) & 4 | 0;
       i10 = i12 << i17 | 0;
       i12 = ((i10 + 245760 | 0) >>> 16 | 0) & 2 | 0;
       i4 = (14 - (i17 | i7 | 0 | i12 | 0) | 0) + ((i10 << i12 | 0) >>> 15 | 0) | 0;
       i32 = (i5 >>> (i4 + 7 | 0) | 0) & 1 | 0 | (i4 << 1 | 0) | 0;
      } else i32 = 0;
      i4 = HEAPU32[(480 + (i32 << 2 | 0) | 0) >> 2] | 0;
      label$break$L123 : {
       if (i4 == 0) {
        i33 = i14;
        i34 = 0;
        i35 = 0;
        i36 = 86;
       } else {
        i12 = i14;
        i10 = 0;
        wasm2asm_i32$2 = i5;
        if (i32 == 31) wasm2asm_i32$3 = 0; else wasm2asm_i32$3 = 25 - (i32 >>> 1 | 0) | 0;
        wasm2asm_i32$1 = wasm2asm_i32$2 << wasm2asm_i32$3 | 0;
        i7 = wasm2asm_i32$1;
        i17 = i4;
        i8 = 0;
        while_out$10 : do {
         i16 = (HEAPU32[(i17 + 4 | 0) >> 2] | 0) & 4294967288 | 0;
         i9 = i16 - i5 | 0;
         if ((i9 >>> 0 | 0) >>> 0 < (i12 >>> 0 | 0) >>> 0) if (i16 == i5) {
          i37 = i9;
          i38 = i17;
          i39 = i17;
          i36 = 90;
          break label$break$L123;
         } else {
          i40 = i9;
          i41 = i17;
         } else {
          i40 = i12;
          i41 = i8;
         }
         i9 = HEAPU32[(i17 + 20 | 0) >> 2] | 0;
         i17 = HEAPU32[((i17 + 16 | 0) + ((i7 >>> 31 | 0) << 2 | 0) | 0) >> 2] | 0;
         if (i9 == 0 | i9 == i17 | 0) wasm2asm_i32$1 = i10; else wasm2asm_i32$1 = i9;
         i16 = wasm2asm_i32$1;
         i9 = i17 == 0;
         if (i9) {
          i33 = i40;
          i34 = i16;
          i35 = i41;
          i36 = 86;
          break while_out$10;
         } else {
          i12 = i40;
          i10 = i16;
          i7 = i7 << ((i9 & 1 | 0) ^ 1 | 0) | 0;
          i8 = i41;
         }
         continue while_out$10;
        } while (0);
       }
      }
      if (i36 == 86) {
       if (i34 == 0 & i35 == 0 | 0) {
        i4 = 2 << i32 | 0;
        i14 = i15 & (i4 | (0 - i4 | 0) | 0) | 0;
        if (i14 == 0) {
         i31 = i5;
         break do_once$0;
        }
        i4 = (i14 & (0 - i14 | 0) | 0) + 4294967295 | 0;
        i14 = (i4 >>> 12 | 0) & 16 | 0;
        i2 = i4 >>> i14 | 0;
        i4 = (i2 >>> 5 | 0) & 8 | 0;
        i3 = i2 >>> i4 | 0;
        i2 = (i3 >>> 2 | 0) & 4 | 0;
        i8 = i3 >>> i2 | 0;
        i3 = (i8 >>> 1 | 0) & 2 | 0;
        i7 = i8 >>> i3 | 0;
        i8 = (i7 >>> 1 | 0) & 1 | 0;
        i42 = HEAPU32[(480 + (((i4 | i14 | 0 | i2 | 0 | i3 | 0 | i8 | 0) + (i7 >>> i8 | 0) | 0) << 2 | 0) | 0) >> 2] | 0;
       } else i42 = i34;
       if (i42 == 0) {
        i43 = i33;
        i44 = i35;
       } else {
        i37 = i33;
        i38 = i42;
        i39 = i35;
        i36 = 90;
       }
      }
      if (i36 == 90) while_out$12 : do {
       i36 = 0;
       i8 = ((HEAPU32[(i38 + 4 | 0) >> 2] | 0) & 4294967288 | 0) - i5 | 0;
       i7 = (i8 >>> 0 | 0) >>> 0 < (i37 >>> 0 | 0) >>> 0;
       if (i7) wasm2asm_i32$1 = i8; else wasm2asm_i32$1 = i37;
       i3 = wasm2asm_i32$1;
       if (i7) wasm2asm_i32$1 = i38; else wasm2asm_i32$1 = i39;
       i8 = wasm2asm_i32$1;
       i7 = HEAPU32[(i38 + 16 | 0) >> 2] | 0;
       if (i7) {
        i37 = i3;
        i38 = i7;
        i39 = i8;
        i36 = 90;
        continue while_out$12;
       }
       i38 = HEAPU32[(i38 + 20 | 0) >> 2] | 0;
       if (i38 == 0) {
        i43 = i3;
        i44 = i8;
        break while_out$12;
       } else {
        i37 = i3;
        i39 = i8;
        i36 = 90;
       }
       continue while_out$12;
      } while (0);
      if (i44 != 0) wasm2asm_i32$1 = (i43 >>> 0 | 0) >>> 0 < (((HEAPU32[184 >> 2] | 0) - i5 | 0) >>> 0 | 0) >>> 0; else wasm2asm_i32$1 = 0;
      if (wasm2asm_i32$1) {
       i15 = HEAPU32[192 >> 2] | 0;
       if ((i44 >>> 0 | 0) >>> 0 < (i15 >>> 0 | 0) >>> 0) _abort();
       i8 = i44 + i5 | 0;
       if ((i44 >>> 0 | 0) >>> 0 >= (i8 >>> 0 | 0) >>> 0) _abort();
       i3 = HEAPU32[(i44 + 24 | 0) >> 2] | 0;
       i7 = HEAPU32[(i44 + 12 | 0) >> 2] | 0;
       do_once$14 : {
        if (i7 == i44) {
         i2 = i44 + 20 | 0;
         i14 = HEAPU32[i2 >> 2] | 0;
         if (i14 == 0) {
          i4 = i44 + 16 | 0;
          i10 = HEAPU32[i4 >> 2] | 0;
          if (i10 == 0) {
           i45 = 0;
           break do_once$14;
          } else {
           i46 = i10;
           i47 = i4;
          }
         } else {
          i46 = i14;
          i47 = i2;
         }
         while_out$15 : do {
          i2 = i46 + 20 | 0;
          i14 = HEAPU32[i2 >> 2] | 0;
          if (i14) {
           i46 = i14;
           i47 = i2;
           continue while_out$15;
          }
          i2 = i46 + 16 | 0;
          i14 = HEAPU32[i2 >> 2] | 0;
          if (i14 == 0) {
           i48 = i46;
           i49 = i47;
           break while_out$15;
          } else {
           i46 = i14;
           i47 = i2;
          }
          continue while_out$15;
         } while (0);
         if ((i49 >>> 0 | 0) >>> 0 < (i15 >>> 0 | 0) >>> 0) _abort(); else {
          HEAP32[i49 >> 2] = 0;
          i45 = i48;
          break do_once$14;
         }
        } else {
         i2 = HEAPU32[(i44 + 8 | 0) >> 2] | 0;
         if ((i2 >>> 0 | 0) >>> 0 < (i15 >>> 0 | 0) >>> 0) _abort();
         i14 = i2 + 12 | 0;
         if ((HEAPU32[i14 >> 2] | 0) != i44) _abort();
         i4 = i7 + 8 | 0;
         if ((HEAPU32[i4 >> 2] | 0) == i44) {
          HEAP32[i14 >> 2] = i7;
          HEAP32[i4 >> 2] = i2;
          i45 = i7;
          break do_once$14;
         } else _abort();
        }
       }
       do_once$17 : {
        if (i3) {
         i7 = HEAPU32[(i44 + 28 | 0) >> 2] | 0;
         i15 = 480 + (i7 << 2 | 0) | 0;
         if (i44 == (HEAPU32[i15 >> 2] | 0)) {
          HEAP32[i15 >> 2] = i45;
          if (i45 == 0) {
           HEAP32[180 >> 2] = (HEAPU32[180 >> 2] | 0) & ((1 << i7 | 0) ^ 4294967295 | 0) | 0;
           break do_once$17;
          }
         } else {
          if ((i3 >>> 0 | 0) >>> 0 < ((HEAPU32[192 >> 2] | 0) >>> 0 | 0) >>> 0) _abort();
          i7 = i3 + 16 | 0;
          if ((HEAPU32[i7 >> 2] | 0) == i44) HEAP32[i7 >> 2] = i45; else HEAP32[(i3 + 20 | 0) >> 2] = i45;
          if (i45 == 0) break do_once$17;
         }
         i7 = HEAPU32[192 >> 2] | 0;
         if ((i45 >>> 0 | 0) >>> 0 < (i7 >>> 0 | 0) >>> 0) _abort();
         HEAP32[(i45 + 24 | 0) >> 2] = i3;
         i15 = HEAPU32[(i44 + 16 | 0) >> 2] | 0;
         do_once$18 : {
          if (i15) if ((i15 >>> 0 | 0) >>> 0 < (i7 >>> 0 | 0) >>> 0) _abort(); else {
           HEAP32[(i45 + 16 | 0) >> 2] = i15;
           HEAP32[(i15 + 24 | 0) >> 2] = i45;
           break do_once$18;
          }
         }
         i15 = HEAPU32[(i44 + 20 | 0) >> 2] | 0;
         if (i15) if ((i15 >>> 0 | 0) >>> 0 < ((HEAPU32[192 >> 2] | 0) >>> 0 | 0) >>> 0) _abort(); else {
          HEAP32[(i45 + 20 | 0) >> 2] = i15;
          HEAP32[(i15 + 24 | 0) >> 2] = i45;
          break do_once$17;
         }
        }
       }
       do_once$19 : {
        if ((i43 >>> 0 | 0) >>> 0 >= 16 >>> 0) {
         HEAP32[(i44 + 4 | 0) >> 2] = i5 | 3 | 0;
         HEAP32[(i8 + 4 | 0) >> 2] = i43 | 1 | 0;
         HEAP32[(i8 + i43 | 0) >> 2] = i43;
         i3 = i43 >>> 3 | 0;
         if ((i43 >>> 0 | 0) >>> 0 < 256 >>> 0) {
          i15 = 216 + ((i3 << 1 | 0) << 2 | 0) | 0;
          i7 = HEAPU32[176 >> 2] | 0;
          i2 = 1 << i3 | 0;
          if (i7 & i2 | 0) {
           i3 = i15 + 8 | 0;
           i4 = HEAPU32[i3 >> 2] | 0;
           if ((i4 >>> 0 | 0) >>> 0 < ((HEAPU32[192 >> 2] | 0) >>> 0 | 0) >>> 0) _abort(); else {
            i50 = i3;
            i51 = i4;
           }
          } else {
           HEAP32[176 >> 2] = i7 | i2 | 0;
           i50 = i15 + 8 | 0;
           i51 = i15;
          }
          HEAP32[i50 >> 2] = i8;
          HEAP32[(i51 + 12 | 0) >> 2] = i8;
          HEAP32[(i8 + 8 | 0) >> 2] = i51;
          HEAP32[(i8 + 12 | 0) >> 2] = i15;
          break do_once$19;
         }
         i15 = i43 >>> 8 | 0;
         if (i15) if ((i43 >>> 0 | 0) >>> 0 > 16777215 >>> 0) i52 = 31; else {
          i2 = ((i15 + 1048320 | 0) >>> 16 | 0) & 8 | 0;
          i7 = i15 << i2 | 0;
          i15 = ((i7 + 520192 | 0) >>> 16 | 0) & 4 | 0;
          i4 = i7 << i15 | 0;
          i7 = ((i4 + 245760 | 0) >>> 16 | 0) & 2 | 0;
          i3 = (14 - (i15 | i2 | 0 | i7 | 0) | 0) + ((i4 << i7 | 0) >>> 15 | 0) | 0;
          i52 = (i43 >>> (i3 + 7 | 0) | 0) & 1 | 0 | (i3 << 1 | 0) | 0;
         } else i52 = 0;
         i3 = 480 + (i52 << 2 | 0) | 0;
         HEAP32[(i8 + 28 | 0) >> 2] = i52;
         i7 = i8 + 16 | 0;
         HEAP32[(i7 + 4 | 0) >> 2] = 0;
         HEAP32[i7 >> 2] = 0;
         i7 = HEAPU32[180 >> 2] | 0;
         i4 = 1 << i52 | 0;
         if ((i7 & i4 | 0) == 0) {
          HEAP32[180 >> 2] = i7 | i4 | 0;
          HEAP32[i3 >> 2] = i8;
          HEAP32[(i8 + 24 | 0) >> 2] = i3;
          HEAP32[(i8 + 12 | 0) >> 2] = i8;
          HEAP32[(i8 + 8 | 0) >> 2] = i8;
          break do_once$19;
         }
         wasm2asm_i32$2 = i43;
         if (i52 == 31) wasm2asm_i32$3 = 0; else wasm2asm_i32$3 = 25 - (i52 >>> 1 | 0) | 0;
         wasm2asm_i32$1 = wasm2asm_i32$2 << wasm2asm_i32$3 | 0;
         i4 = wasm2asm_i32$1;
         i7 = HEAPU32[i3 >> 2] | 0;
         while_out$20 : do {
          if (((HEAPU32[(i7 + 4 | 0) >> 2] | 0) & 4294967288 | 0) == i43) {
           i53 = i7;
           i36 = 148;
           break while_out$20;
          }
          i3 = (i7 + 16 | 0) + ((i4 >>> 31 | 0) << 2 | 0) | 0;
          i2 = HEAPU32[i3 >> 2] | 0;
          if (i2 == 0) {
           i54 = i3;
           i55 = i7;
           i36 = 145;
           break while_out$20;
          } else {
           i4 = i4 << 1 | 0;
           i7 = i2;
          }
          continue while_out$20;
         } while (0);
         if (i36 == 145) if ((i54 >>> 0 | 0) >>> 0 < ((HEAPU32[192 >> 2] | 0) >>> 0 | 0) >>> 0) _abort(); else {
          HEAP32[i54 >> 2] = i8;
          HEAP32[(i8 + 24 | 0) >> 2] = i55;
          HEAP32[(i8 + 12 | 0) >> 2] = i8;
          HEAP32[(i8 + 8 | 0) >> 2] = i8;
          break do_once$19;
         } else if (i36 == 148) {
          i7 = i53 + 8 | 0;
          i4 = HEAPU32[i7 >> 2] | 0;
          i2 = HEAPU32[192 >> 2] | 0;
          if ((i4 >>> 0 | 0) >>> 0 >= (i2 >>> 0 | 0) >>> 0 & (i53 >>> 0 | 0) >>> 0 >= (i2 >>> 0 | 0) >>> 0 | 0) {
           HEAP32[(i4 + 12 | 0) >> 2] = i8;
           HEAP32[i7 >> 2] = i8;
           HEAP32[(i8 + 8 | 0) >> 2] = i4;
           HEAP32[(i8 + 12 | 0) >> 2] = i53;
           HEAP32[(i8 + 24 | 0) >> 2] = 0;
           break do_once$19;
          } else _abort();
         }
        } else {
         i4 = i43 + i5 | 0;
         HEAP32[(i44 + 4 | 0) >> 2] = i4 | 3 | 0;
         i7 = (i44 + i4 | 0) + 4 | 0;
         HEAP32[i7 >> 2] = HEAPU32[i7 >> 2] | 0 | 1 | 0;
        }
       }
       i13 = i44 + 8 | 0;
       wasm2asm_i32$0 = i13;
       break topmost;
      } else i31 = i5;
     } else i31 = i5;
    } else i31 = 4294967295;
   }
   i44 = HEAPU32[184 >> 2] | 0;
   if ((i44 >>> 0 | 0) >>> 0 >= (i31 >>> 0 | 0) >>> 0) {
    i43 = i44 - i31 | 0;
    i53 = HEAPU32[196 >> 2] | 0;
    if ((i43 >>> 0 | 0) >>> 0 > 15 >>> 0) {
     i55 = i53 + i31 | 0;
     HEAP32[196 >> 2] = i55;
     HEAP32[184 >> 2] = i43;
     HEAP32[(i55 + 4 | 0) >> 2] = i43 | 1 | 0;
     HEAP32[(i55 + i43 | 0) >> 2] = i43;
     HEAP32[(i53 + 4 | 0) >> 2] = i31 | 3 | 0;
    } else {
     HEAP32[184 >> 2] = 0;
     HEAP32[196 >> 2] = 0;
     HEAP32[(i53 + 4 | 0) >> 2] = i44 | 3 | 0;
     i43 = (i53 + i44 | 0) + 4 | 0;
     HEAP32[i43 >> 2] = HEAPU32[i43 >> 2] | 0 | 1 | 0;
    }
    i13 = i53 + 8 | 0;
    wasm2asm_i32$0 = i13;
    break topmost;
   }
   i53 = HEAPU32[188 >> 2] | 0;
   if ((i53 >>> 0 | 0) >>> 0 > (i31 >>> 0 | 0) >>> 0) {
    i43 = i53 - i31 | 0;
    HEAP32[188 >> 2] = i43;
    i53 = HEAPU32[200 >> 2] | 0;
    i44 = i53 + i31 | 0;
    HEAP32[200 >> 2] = i44;
    HEAP32[(i44 + 4 | 0) >> 2] = i43 | 1 | 0;
    HEAP32[(i53 + 4 | 0) >> 2] = i31 | 3 | 0;
    i13 = i53 + 8 | 0;
    wasm2asm_i32$0 = i13;
    break topmost;
   }
   do_once$22 : {
    if ((HEAPU32[648 >> 2] | 0) == 0) {
     i53 = _sysconf(30 | 0) | 0;
     if (((i53 + 4294967295 | 0) & i53 | 0) == 0) {
      HEAP32[656 >> 2] = i53;
      HEAP32[652 >> 2] = i53;
      HEAP32[660 >> 2] = 4294967295;
      HEAP32[664 >> 2] = 4294967295;
      HEAP32[668 >> 2] = 0;
      HEAP32[620 >> 2] = 0;
      HEAP32[648 >> 2] = ((_time(0 | 0) | 0) & 4294967280 | 0) ^ 1431655768 | 0;
      break do_once$22;
     } else _abort();
    }
   }
   i53 = i31 + 48 | 0;
   i43 = HEAPU32[656 >> 2] | 0;
   i44 = i31 + 47 | 0;
   i55 = i43 + i44 | 0;
   i54 = 0 - i43 | 0;
   i43 = i55 & i54 | 0;
   if ((i43 >>> 0 | 0) >>> 0 <= (i31 >>> 0 | 0) >>> 0) {
    i13 = 0;
    wasm2asm_i32$0 = i13;
    break topmost;
   }
   i52 = HEAPU32[616 >> 2] | 0;
   if (i52 != 0) {
    i51 = HEAPU32[608 >> 2] | 0;
    i50 = i51 + i43 | 0;
    wasm2asm_i32$1 = (i50 >>> 0 | 0) >>> 0 <= (i51 >>> 0 | 0) >>> 0 | (i50 >>> 0 | 0) >>> 0 > (i52 >>> 0 | 0) >>> 0 | 0;
   } else wasm2asm_i32$1 = 0;
   if (wasm2asm_i32$1) {
    i13 = 0;
    wasm2asm_i32$0 = i13;
    break topmost;
   }
   label$break$L257 : {
    if (((HEAPU32[620 >> 2] | 0) & 4 | 0) == 0) {
     i52 = HEAPU32[200 >> 2] | 0;
     label$break$L259 : {
      if (i52) {
       i50 = 624;
       while_out$23 : do {
        i51 = HEAPU32[i50 >> 2] | 0;
        if ((i51 >>> 0 | 0) >>> 0 <= (i52 >>> 0 | 0) >>> 0) {
         i45 = i50 + 4 | 0;
         wasm2asm_i32$1 = ((i51 + (HEAPU32[i45 >> 2] | 0) | 0) >>> 0 | 0) >>> 0 > (i52 >>> 0 | 0) >>> 0;
        } else wasm2asm_i32$1 = 0;
        if (wasm2asm_i32$1) {
         i56 = i50;
         i57 = i45;
         break while_out$23;
        }
        i50 = HEAPU32[(i50 + 8 | 0) >> 2] | 0;
        if (i50 == 0) {
         i36 = 173;
         break label$break$L259;
        }
        continue while_out$23;
       } while (0);
       i50 = (i55 - (HEAPU32[188 >> 2] | 0) | 0) & i54 | 0;
       if ((i50 >>> 0 | 0) >>> 0 < 2147483647 >>> 0) {
        i45 = _sbrk(i50 | 0) | 0;
        if (i45 == ((HEAPU32[i56 >> 2] | 0) + (HEAPU32[i57 >> 2] | 0) | 0)) {
         if (i45 != 4294967295) {
          i58 = i45;
          i59 = i50;
          i36 = 193;
          break label$break$L257;
         }
        } else {
         i60 = i45;
         i61 = i50;
         i36 = 183;
        }
       }
      } else i36 = 173;
     }
     do_once$25 : {
      if (i36 == 173) {
       i52 = _sbrk(0 | 0) | 0;
       wasm2asm_i32$1 = i52 != 4294967295;
      } else wasm2asm_i32$1 = 0;
      if (wasm2asm_i32$1) {
       i5 = i52;
       i50 = HEAPU32[652 >> 2] | 0;
       i45 = i50 + 4294967295 | 0;
       if ((i45 & i5 | 0) == 0) i62 = i43; else i62 = (i43 - i5 | 0) + ((i45 + i5 | 0) & (0 - i50 | 0) | 0) | 0;
       i50 = HEAPU32[608 >> 2] | 0;
       i5 = i50 + i62 | 0;
       if ((i62 >>> 0 | 0) >>> 0 > (i31 >>> 0 | 0) >>> 0 & (i62 >>> 0 | 0) >>> 0 < 2147483647 >>> 0 | 0) {
        i45 = HEAPU32[616 >> 2] | 0;
        if (i45 != 0) wasm2asm_i32$1 = (i5 >>> 0 | 0) >>> 0 <= (i50 >>> 0 | 0) >>> 0 | (i5 >>> 0 | 0) >>> 0 > (i45 >>> 0 | 0) >>> 0 | 0; else wasm2asm_i32$1 = 0;
        if (wasm2asm_i32$1) break do_once$25;
        i45 = _sbrk(i62 | 0) | 0;
        if (i45 == i52) {
         i58 = i52;
         i59 = i62;
         i36 = 193;
         break label$break$L257;
        } else {
         i60 = i45;
         i61 = i62;
         i36 = 183;
        }
       }
      }
     }
     label$break$L279 : {
      if (i36 == 183) {
       i45 = 0 - i61 | 0;
       do_once$26 : {
        if ((i53 >>> 0 | 0) >>> 0 > (i61 >>> 0 | 0) >>> 0 & ((i61 >>> 0 | 0) >>> 0 < 2147483647 >>> 0 & i60 != 4294967295 | 0) | 0) {
         i52 = HEAPU32[656 >> 2] | 0;
         i5 = ((i44 - i61 | 0) + i52 | 0) & (0 - i52 | 0) | 0;
         wasm2asm_i32$1 = (i5 >>> 0 | 0) >>> 0 < 2147483647 >>> 0;
        } else wasm2asm_i32$1 = 0;
        if (wasm2asm_i32$1) if ((_sbrk(i5 | 0) | 0) == 4294967295) {
         _sbrk(i45 | 0) | 0;
         break label$break$L279;
        } else {
         i63 = i5 + i61 | 0;
         break do_once$26;
        } else i63 = i61;
       }
       if (i60 != 4294967295) {
        i58 = i60;
        i59 = i63;
        i36 = 193;
        break label$break$L257;
       }
      }
     }
     HEAP32[620 >> 2] = HEAPU32[620 >> 2] | 0 | 4 | 0;
     i36 = 190;
    } else i36 = 190;
   }
   if (i36 == 190) wasm2asm_i32$3 = (i43 >>> 0 | 0) >>> 0 < 2147483647 >>> 0; else wasm2asm_i32$3 = 0;
   if (wasm2asm_i32$3) {
    i63 = _sbrk(i43 | 0) | 0;
    i43 = _sbrk(0 | 0) | 0;
    wasm2asm_i32$2 = (i63 >>> 0 | 0) >>> 0 < (i43 >>> 0 | 0) >>> 0 & (i63 != 4294967295 & i43 != 4294967295 | 0) | 0;
   } else wasm2asm_i32$2 = 0;
   if (wasm2asm_i32$2) {
    i60 = i43 - i63 | 0;
    wasm2asm_i32$1 = (i60 >>> 0 | 0) >>> 0 > ((i31 + 40 | 0) >>> 0 | 0) >>> 0;
   } else wasm2asm_i32$1 = 0;
   if (wasm2asm_i32$1) {
    i58 = i63;
    i59 = i60;
    i36 = 193;
   }
   if (i36 == 193) {
    i60 = (HEAPU32[608 >> 2] | 0) + i59 | 0;
    HEAP32[608 >> 2] = i60;
    if ((i60 >>> 0 | 0) >>> 0 > ((HEAPU32[612 >> 2] | 0) >>> 0 | 0) >>> 0) HEAP32[612 >> 2] = i60;
    i60 = HEAPU32[200 >> 2] | 0;
    do_once$27 : {
     if (i60) {
      i63 = 624;
      do_out$28 : do {
       i43 = HEAPU32[i63 >> 2] | 0;
       i61 = i63 + 4 | 0;
       i44 = HEAPU32[i61 >> 2] | 0;
       if (i58 == (i43 + i44 | 0)) {
        i64 = i43;
        i65 = i61;
        i66 = i44;
        i67 = i63;
        i36 = 203;
        break do_out$28;
       }
       i63 = HEAPU32[(i63 + 8 | 0) >> 2] | 0;
       if (i63 != 0) continue do_out$28;
      } while (0);
      if (i36 == 203) wasm2asm_i32$2 = ((HEAPU32[(i67 + 12 | 0) >> 2] | 0) & 8 | 0) == 0; else wasm2asm_i32$2 = 0;
      if (wasm2asm_i32$2) wasm2asm_i32$1 = (i60 >>> 0 | 0) >>> 0 < (i58 >>> 0 | 0) >>> 0 & (i60 >>> 0 | 0) >>> 0 >= (i64 >>> 0 | 0) >>> 0 | 0; else wasm2asm_i32$1 = 0;
      if (wasm2asm_i32$1) {
       HEAP32[i65 >> 2] = i66 + i59 | 0;
       i63 = i60 + 8 | 0;
       if ((i63 & 7 | 0) == 0) wasm2asm_i32$1 = 0; else wasm2asm_i32$1 = (0 - i63 | 0) & 7 | 0;
       i44 = wasm2asm_i32$1;
       i63 = i60 + i44 | 0;
       i61 = (i59 - i44 | 0) + (HEAPU32[188 >> 2] | 0) | 0;
       HEAP32[200 >> 2] = i63;
       HEAP32[188 >> 2] = i61;
       HEAP32[(i63 + 4 | 0) >> 2] = i61 | 1 | 0;
       HEAP32[((i63 + i61 | 0) + 4 | 0) >> 2] = 40;
       HEAP32[204 >> 2] = HEAPU32[664 >> 2] | 0;
       break do_once$27;
      }
      i61 = HEAPU32[192 >> 2] | 0;
      if ((i58 >>> 0 | 0) >>> 0 < (i61 >>> 0 | 0) >>> 0) {
       HEAP32[192 >> 2] = i58;
       i68 = i58;
      } else i68 = i61;
      i61 = i58 + i59 | 0;
      i63 = 624;
      while_out$30 : do {
       if ((HEAPU32[i63 >> 2] | 0) == i61) {
        i69 = i63;
        i70 = i63;
        i36 = 211;
        break while_out$30;
       }
       i63 = HEAPU32[(i63 + 8 | 0) >> 2] | 0;
       if (i63 == 0) {
        i71 = 624;
        break while_out$30;
       }
       continue while_out$30;
      } while (0);
      if (i36 == 211) if (((HEAPU32[(i70 + 12 | 0) >> 2] | 0) & 8 | 0) == 0) {
       HEAP32[i69 >> 2] = i58;
       i63 = i70 + 4 | 0;
       HEAP32[i63 >> 2] = (HEAPU32[i63 >> 2] | 0) + i59 | 0;
       i63 = i58 + 8 | 0;
       wasm2asm_i32$2 = i58;
       if ((i63 & 7 | 0) == 0) wasm2asm_i32$3 = 0; else wasm2asm_i32$3 = (0 - i63 | 0) & 7 | 0;
       wasm2asm_i32$1 = wasm2asm_i32$2 + wasm2asm_i32$3 | 0;
       i44 = wasm2asm_i32$1;
       i63 = i61 + 8 | 0;
       wasm2asm_i32$2 = i61;
       if ((i63 & 7 | 0) == 0) wasm2asm_i32$3 = 0; else wasm2asm_i32$3 = (0 - i63 | 0) & 7 | 0;
       wasm2asm_i32$1 = wasm2asm_i32$2 + wasm2asm_i32$3 | 0;
       i43 = wasm2asm_i32$1;
       i63 = i44 + i31 | 0;
       i53 = (i43 - i44 | 0) - i31 | 0;
       HEAP32[(i44 + 4 | 0) >> 2] = i31 | 3 | 0;
       do_once$32 : {
        if (i43 != i60) {
         if (i43 == (HEAPU32[196 >> 2] | 0)) {
          i62 = (HEAPU32[184 >> 2] | 0) + i53 | 0;
          HEAP32[184 >> 2] = i62;
          HEAP32[196 >> 2] = i63;
          HEAP32[(i63 + 4 | 0) >> 2] = i62 | 1 | 0;
          HEAP32[(i63 + i62 | 0) >> 2] = i62;
          break do_once$32;
         }
         i62 = HEAPU32[(i43 + 4 | 0) >> 2] | 0;
         if ((i62 & 3 | 0) == 1) {
          i57 = i62 & 4294967288 | 0;
          i56 = i62 >>> 3 | 0;
          label$break$L331 : {
           if ((i62 >>> 0 | 0) >>> 0 >= 256 >>> 0) {
            i54 = HEAPU32[(i43 + 24 | 0) >> 2] | 0;
            i55 = HEAPU32[(i43 + 12 | 0) >> 2] | 0;
            do_once$33 : {
             if (i55 == i43) {
              i45 = i43 + 16 | 0;
              i5 = i45 + 4 | 0;
              i52 = HEAPU32[i5 >> 2] | 0;
              if (i52 == 0) {
               i50 = HEAPU32[i45 >> 2] | 0;
               if (i50 == 0) {
                i72 = 0;
                break do_once$33;
               } else {
                i73 = i50;
                i74 = i45;
               }
              } else {
               i73 = i52;
               i74 = i5;
              }
              while_out$34 : do {
               i5 = i73 + 20 | 0;
               i52 = HEAPU32[i5 >> 2] | 0;
               if (i52) {
                i73 = i52;
                i74 = i5;
                continue while_out$34;
               }
               i5 = i73 + 16 | 0;
               i52 = HEAPU32[i5 >> 2] | 0;
               if (i52 == 0) {
                i75 = i73;
                i76 = i74;
                break while_out$34;
               } else {
                i73 = i52;
                i74 = i5;
               }
               continue while_out$34;
              } while (0);
              if ((i76 >>> 0 | 0) >>> 0 < (i68 >>> 0 | 0) >>> 0) _abort(); else {
               HEAP32[i76 >> 2] = 0;
               i72 = i75;
               break do_once$33;
              }
             } else {
              i5 = HEAPU32[(i43 + 8 | 0) >> 2] | 0;
              if ((i5 >>> 0 | 0) >>> 0 < (i68 >>> 0 | 0) >>> 0) _abort();
              i52 = i5 + 12 | 0;
              if ((HEAPU32[i52 >> 2] | 0) != i43) _abort();
              i45 = i55 + 8 | 0;
              if ((HEAPU32[i45 >> 2] | 0) == i43) {
               HEAP32[i52 >> 2] = i55;
               HEAP32[i45 >> 2] = i5;
               i72 = i55;
               break do_once$33;
              } else _abort();
             }
            }
            if (i54 == 0) break label$break$L331;
            i55 = HEAPU32[(i43 + 28 | 0) >> 2] | 0;
            i5 = 480 + (i55 << 2 | 0) | 0;
            do_once$36 : {
             if (i43 != (HEAPU32[i5 >> 2] | 0)) {
              if ((i54 >>> 0 | 0) >>> 0 < ((HEAPU32[192 >> 2] | 0) >>> 0 | 0) >>> 0) _abort();
              i45 = i54 + 16 | 0;
              if ((HEAPU32[i45 >> 2] | 0) == i43) HEAP32[i45 >> 2] = i72; else HEAP32[(i54 + 20 | 0) >> 2] = i72;
              if (i72 == 0) break label$break$L331;
             } else {
              HEAP32[i5 >> 2] = i72;
              if (i72) break do_once$36;
              HEAP32[180 >> 2] = (HEAPU32[180 >> 2] | 0) & ((1 << i55 | 0) ^ 4294967295 | 0) | 0;
              break label$break$L331;
             }
            }
            i55 = HEAPU32[192 >> 2] | 0;
            if ((i72 >>> 0 | 0) >>> 0 < (i55 >>> 0 | 0) >>> 0) _abort();
            HEAP32[(i72 + 24 | 0) >> 2] = i54;
            i5 = i43 + 16 | 0;
            i45 = HEAPU32[i5 >> 2] | 0;
            do_once$37 : {
             if (i45) if ((i45 >>> 0 | 0) >>> 0 < (i55 >>> 0 | 0) >>> 0) _abort(); else {
              HEAP32[(i72 + 16 | 0) >> 2] = i45;
              HEAP32[(i45 + 24 | 0) >> 2] = i72;
              break do_once$37;
             }
            }
            i45 = HEAPU32[(i5 + 4 | 0) >> 2] | 0;
            if (i45 == 0) break label$break$L331;
            if ((i45 >>> 0 | 0) >>> 0 < ((HEAPU32[192 >> 2] | 0) >>> 0 | 0) >>> 0) _abort(); else {
             HEAP32[(i72 + 20 | 0) >> 2] = i45;
             HEAP32[(i45 + 24 | 0) >> 2] = i72;
             break label$break$L331;
            }
           } else {
            i45 = HEAPU32[(i43 + 8 | 0) >> 2] | 0;
            i55 = HEAPU32[(i43 + 12 | 0) >> 2] | 0;
            i54 = 216 + ((i56 << 1 | 0) << 2 | 0) | 0;
            do_once$38 : {
             if (i45 != i54) {
              if ((i45 >>> 0 | 0) >>> 0 < (i68 >>> 0 | 0) >>> 0) _abort();
              if ((HEAPU32[(i45 + 12 | 0) >> 2] | 0) == i43) break do_once$38;
              _abort();
             }
            }
            if (i55 == i45) {
             HEAP32[176 >> 2] = (HEAPU32[176 >> 2] | 0) & ((1 << i56 | 0) ^ 4294967295 | 0) | 0;
             break label$break$L331;
            }
            do_once$39 : {
             if (i55 == i54) i77 = i55 + 8 | 0; else {
              if ((i55 >>> 0 | 0) >>> 0 < (i68 >>> 0 | 0) >>> 0) _abort();
              i5 = i55 + 8 | 0;
              if ((HEAPU32[i5 >> 2] | 0) == i43) {
               i77 = i5;
               break do_once$39;
              }
              _abort();
             }
            }
            HEAP32[(i45 + 12 | 0) >> 2] = i55;
            HEAP32[i77 >> 2] = i45;
           }
          }
          i78 = i43 + i57 | 0;
          i79 = i57 + i53 | 0;
         } else {
          i78 = i43;
          i79 = i53;
         }
         i56 = i78 + 4 | 0;
         HEAP32[i56 >> 2] = (HEAPU32[i56 >> 2] | 0) & 4294967294 | 0;
         HEAP32[(i63 + 4 | 0) >> 2] = i79 | 1 | 0;
         HEAP32[(i63 + i79 | 0) >> 2] = i79;
         i56 = i79 >>> 3 | 0;
         if ((i79 >>> 0 | 0) >>> 0 < 256 >>> 0) {
          i62 = 216 + ((i56 << 1 | 0) << 2 | 0) | 0;
          i54 = HEAPU32[176 >> 2] | 0;
          i5 = 1 << i56 | 0;
          do_once$40 : {
           if ((i54 & i5 | 0) == 0) {
            HEAP32[176 >> 2] = i54 | i5 | 0;
            i80 = i62 + 8 | 0;
            i81 = i62;
           } else {
            i56 = i62 + 8 | 0;
            i52 = HEAPU32[i56 >> 2] | 0;
            if ((i52 >>> 0 | 0) >>> 0 >= ((HEAPU32[192 >> 2] | 0) >>> 0 | 0) >>> 0) {
             i80 = i56;
             i81 = i52;
             break do_once$40;
            }
            _abort();
           }
          }
          HEAP32[i80 >> 2] = i63;
          HEAP32[(i81 + 12 | 0) >> 2] = i63;
          HEAP32[(i63 + 8 | 0) >> 2] = i81;
          HEAP32[(i63 + 12 | 0) >> 2] = i62;
          break do_once$32;
         }
         i5 = i79 >>> 8 | 0;
         do_once$41 : {
          if (i5 == 0) i82 = 0; else {
           if ((i79 >>> 0 | 0) >>> 0 > 16777215 >>> 0) {
            i82 = 31;
            break do_once$41;
           }
           i54 = ((i5 + 1048320 | 0) >>> 16 | 0) & 8 | 0;
           i57 = i5 << i54 | 0;
           i52 = ((i57 + 520192 | 0) >>> 16 | 0) & 4 | 0;
           i56 = i57 << i52 | 0;
           i57 = ((i56 + 245760 | 0) >>> 16 | 0) & 2 | 0;
           i50 = (14 - (i52 | i54 | 0 | i57 | 0) | 0) + ((i56 << i57 | 0) >>> 15 | 0) | 0;
           i82 = (i79 >>> (i50 + 7 | 0) | 0) & 1 | 0 | (i50 << 1 | 0) | 0;
          }
         }
         i5 = 480 + (i82 << 2 | 0) | 0;
         HEAP32[(i63 + 28 | 0) >> 2] = i82;
         i62 = i63 + 16 | 0;
         HEAP32[(i62 + 4 | 0) >> 2] = 0;
         HEAP32[i62 >> 2] = 0;
         i62 = HEAPU32[180 >> 2] | 0;
         i50 = 1 << i82 | 0;
         if ((i62 & i50 | 0) == 0) {
          HEAP32[180 >> 2] = i62 | i50 | 0;
          HEAP32[i5 >> 2] = i63;
          HEAP32[(i63 + 24 | 0) >> 2] = i5;
          HEAP32[(i63 + 12 | 0) >> 2] = i63;
          HEAP32[(i63 + 8 | 0) >> 2] = i63;
          break do_once$32;
         }
         wasm2asm_i32$2 = i79;
         if (i82 == 31) wasm2asm_i32$3 = 0; else wasm2asm_i32$3 = 25 - (i82 >>> 1 | 0) | 0;
         wasm2asm_i32$1 = wasm2asm_i32$2 << wasm2asm_i32$3 | 0;
         i50 = wasm2asm_i32$1;
         i62 = HEAPU32[i5 >> 2] | 0;
         while_out$42 : do {
          if (((HEAPU32[(i62 + 4 | 0) >> 2] | 0) & 4294967288 | 0) == i79) {
           i83 = i62;
           i36 = 281;
           break while_out$42;
          }
          i5 = (i62 + 16 | 0) + ((i50 >>> 31 | 0) << 2 | 0) | 0;
          i57 = HEAPU32[i5 >> 2] | 0;
          if (i57 == 0) {
           i84 = i5;
           i85 = i62;
           i36 = 278;
           break while_out$42;
          } else {
           i50 = i50 << 1 | 0;
           i62 = i57;
          }
          continue while_out$42;
         } while (0);
         if (i36 == 278) if ((i84 >>> 0 | 0) >>> 0 < ((HEAPU32[192 >> 2] | 0) >>> 0 | 0) >>> 0) _abort(); else {
          HEAP32[i84 >> 2] = i63;
          HEAP32[(i63 + 24 | 0) >> 2] = i85;
          HEAP32[(i63 + 12 | 0) >> 2] = i63;
          HEAP32[(i63 + 8 | 0) >> 2] = i63;
          break do_once$32;
         } else if (i36 == 281) {
          i62 = i83 + 8 | 0;
          i50 = HEAPU32[i62 >> 2] | 0;
          i57 = HEAPU32[192 >> 2] | 0;
          if ((i50 >>> 0 | 0) >>> 0 >= (i57 >>> 0 | 0) >>> 0 & (i83 >>> 0 | 0) >>> 0 >= (i57 >>> 0 | 0) >>> 0 | 0) {
           HEAP32[(i50 + 12 | 0) >> 2] = i63;
           HEAP32[i62 >> 2] = i63;
           HEAP32[(i63 + 8 | 0) >> 2] = i50;
           HEAP32[(i63 + 12 | 0) >> 2] = i83;
           HEAP32[(i63 + 24 | 0) >> 2] = 0;
           break do_once$32;
          } else _abort();
         }
        } else {
         i50 = (HEAPU32[188 >> 2] | 0) + i53 | 0;
         HEAP32[188 >> 2] = i50;
         HEAP32[200 >> 2] = i63;
         HEAP32[(i63 + 4 | 0) >> 2] = i50 | 1 | 0;
        }
       }
       i13 = i44 + 8 | 0;
       wasm2asm_i32$0 = i13;
       break topmost;
      } else i71 = 624;
      while_out$44 : do {
       i63 = HEAPU32[i71 >> 2] | 0;
       if ((i63 >>> 0 | 0) >>> 0 <= (i60 >>> 0 | 0) >>> 0) {
        i53 = i63 + (HEAPU32[(i71 + 4 | 0) >> 2] | 0) | 0;
        wasm2asm_i32$1 = (i53 >>> 0 | 0) >>> 0 > (i60 >>> 0 | 0) >>> 0;
       } else wasm2asm_i32$1 = 0;
       if (wasm2asm_i32$1) {
        i86 = i53;
        break while_out$44;
       }
       i71 = HEAPU32[(i71 + 8 | 0) >> 2] | 0;
       continue while_out$44;
      } while (0);
      i44 = i86 + 4294967249 | 0;
      i53 = i44 + 8 | 0;
      wasm2asm_i32$2 = i44;
      if ((i53 & 7 | 0) == 0) wasm2asm_i32$3 = 0; else wasm2asm_i32$3 = (0 - i53 | 0) & 7 | 0;
      wasm2asm_i32$1 = wasm2asm_i32$2 + wasm2asm_i32$3 | 0;
      i63 = wasm2asm_i32$1;
      i53 = i60 + 16 | 0;
      if ((i63 >>> 0 | 0) >>> 0 < (i53 >>> 0 | 0) >>> 0) wasm2asm_i32$1 = i60; else wasm2asm_i32$1 = i63;
      i44 = wasm2asm_i32$1;
      i63 = i44 + 8 | 0;
      i43 = i58 + 8 | 0;
      if ((i43 & 7 | 0) == 0) wasm2asm_i32$1 = 0; else wasm2asm_i32$1 = (0 - i43 | 0) & 7 | 0;
      i61 = wasm2asm_i32$1;
      i43 = i58 + i61 | 0;
      i50 = (i59 + 4294967256 | 0) - i61 | 0;
      HEAP32[200 >> 2] = i43;
      HEAP32[188 >> 2] = i50;
      HEAP32[(i43 + 4 | 0) >> 2] = i50 | 1 | 0;
      HEAP32[((i43 + i50 | 0) + 4 | 0) >> 2] = 40;
      HEAP32[204 >> 2] = HEAPU32[664 >> 2] | 0;
      i50 = i44 + 4 | 0;
      HEAP32[i50 >> 2] = 27;
      HEAP32[i63 >> 2] = HEAPU32[624 >> 2] | 0;
      HEAP32[(i63 + 4 | 0) >> 2] = HEAPU32[628 >> 2] | 0;
      HEAP32[(i63 + 8 | 0) >> 2] = HEAPU32[632 >> 2] | 0;
      HEAP32[(i63 + 12 | 0) >> 2] = HEAPU32[636 >> 2] | 0;
      HEAP32[624 >> 2] = i58;
      HEAP32[628 >> 2] = i59;
      HEAP32[636 >> 2] = 0;
      HEAP32[632 >> 2] = i63;
      i63 = i44 + 24 | 0;
      do_out$46 : do {
       i63 = i63 + 4 | 0;
       HEAP32[i63 >> 2] = 7;
       if (((i63 + 4 | 0) >>> 0 | 0) >>> 0 < (i86 >>> 0 | 0) >>> 0) continue do_out$46;
      } while (0);
      if (i44 != i60) {
       i63 = i44 - i60 | 0;
       HEAP32[i50 >> 2] = (HEAPU32[i50 >> 2] | 0) & 4294967294 | 0;
       HEAP32[(i60 + 4 | 0) >> 2] = i63 | 1 | 0;
       HEAP32[i44 >> 2] = i63;
       i43 = i63 >>> 3 | 0;
       if ((i63 >>> 0 | 0) >>> 0 < 256 >>> 0) {
        i61 = 216 + ((i43 << 1 | 0) << 2 | 0) | 0;
        i62 = HEAPU32[176 >> 2] | 0;
        i57 = 1 << i43 | 0;
        if (i62 & i57 | 0) {
         i43 = i61 + 8 | 0;
         i5 = HEAPU32[i43 >> 2] | 0;
         if ((i5 >>> 0 | 0) >>> 0 < ((HEAPU32[192 >> 2] | 0) >>> 0 | 0) >>> 0) _abort(); else {
          i87 = i43;
          i88 = i5;
         }
        } else {
         HEAP32[176 >> 2] = i62 | i57 | 0;
         i87 = i61 + 8 | 0;
         i88 = i61;
        }
        HEAP32[i87 >> 2] = i60;
        HEAP32[(i88 + 12 | 0) >> 2] = i60;
        HEAP32[(i60 + 8 | 0) >> 2] = i88;
        HEAP32[(i60 + 12 | 0) >> 2] = i61;
        break do_once$27;
       }
       i61 = i63 >>> 8 | 0;
       if (i61) if ((i63 >>> 0 | 0) >>> 0 > 16777215 >>> 0) i89 = 31; else {
        i57 = ((i61 + 1048320 | 0) >>> 16 | 0) & 8 | 0;
        i62 = i61 << i57 | 0;
        i61 = ((i62 + 520192 | 0) >>> 16 | 0) & 4 | 0;
        i5 = i62 << i61 | 0;
        i62 = ((i5 + 245760 | 0) >>> 16 | 0) & 2 | 0;
        i43 = (14 - (i61 | i57 | 0 | i62 | 0) | 0) + ((i5 << i62 | 0) >>> 15 | 0) | 0;
        i89 = (i63 >>> (i43 + 7 | 0) | 0) & 1 | 0 | (i43 << 1 | 0) | 0;
       } else i89 = 0;
       i43 = 480 + (i89 << 2 | 0) | 0;
       HEAP32[(i60 + 28 | 0) >> 2] = i89;
       HEAP32[(i60 + 20 | 0) >> 2] = 0;
       HEAP32[i53 >> 2] = 0;
       i62 = HEAPU32[180 >> 2] | 0;
       i5 = 1 << i89 | 0;
       if ((i62 & i5 | 0) == 0) {
        HEAP32[180 >> 2] = i62 | i5 | 0;
        HEAP32[i43 >> 2] = i60;
        HEAP32[(i60 + 24 | 0) >> 2] = i43;
        HEAP32[(i60 + 12 | 0) >> 2] = i60;
        HEAP32[(i60 + 8 | 0) >> 2] = i60;
        break do_once$27;
       }
       wasm2asm_i32$2 = i63;
       if (i89 == 31) wasm2asm_i32$3 = 0; else wasm2asm_i32$3 = 25 - (i89 >>> 1 | 0) | 0;
       wasm2asm_i32$1 = wasm2asm_i32$2 << wasm2asm_i32$3 | 0;
       i5 = wasm2asm_i32$1;
       i62 = HEAPU32[i43 >> 2] | 0;
       while_out$48 : do {
        if (((HEAPU32[(i62 + 4 | 0) >> 2] | 0) & 4294967288 | 0) == i63) {
         i90 = i62;
         i36 = 307;
         break while_out$48;
        }
        i43 = (i62 + 16 | 0) + ((i5 >>> 31 | 0) << 2 | 0) | 0;
        i57 = HEAPU32[i43 >> 2] | 0;
        if (i57 == 0) {
         i91 = i43;
         i92 = i62;
         i36 = 304;
         break while_out$48;
        } else {
         i5 = i5 << 1 | 0;
         i62 = i57;
        }
        continue while_out$48;
       } while (0);
       if (i36 == 304) if ((i91 >>> 0 | 0) >>> 0 < ((HEAPU32[192 >> 2] | 0) >>> 0 | 0) >>> 0) _abort(); else {
        HEAP32[i91 >> 2] = i60;
        HEAP32[(i60 + 24 | 0) >> 2] = i92;
        HEAP32[(i60 + 12 | 0) >> 2] = i60;
        HEAP32[(i60 + 8 | 0) >> 2] = i60;
        break do_once$27;
       } else if (i36 == 307) {
        i62 = i90 + 8 | 0;
        i5 = HEAPU32[i62 >> 2] | 0;
        i63 = HEAPU32[192 >> 2] | 0;
        if ((i5 >>> 0 | 0) >>> 0 >= (i63 >>> 0 | 0) >>> 0 & (i90 >>> 0 | 0) >>> 0 >= (i63 >>> 0 | 0) >>> 0 | 0) {
         HEAP32[(i5 + 12 | 0) >> 2] = i60;
         HEAP32[i62 >> 2] = i60;
         HEAP32[(i60 + 8 | 0) >> 2] = i5;
         HEAP32[(i60 + 12 | 0) >> 2] = i90;
         HEAP32[(i60 + 24 | 0) >> 2] = 0;
         break do_once$27;
        } else _abort();
       }
      }
     } else {
      i5 = HEAPU32[192 >> 2] | 0;
      if (i5 == 0 | (i58 >>> 0 | 0) >>> 0 < (i5 >>> 0 | 0) >>> 0 | 0) HEAP32[192 >> 2] = i58;
      HEAP32[624 >> 2] = i58;
      HEAP32[628 >> 2] = i59;
      HEAP32[636 >> 2] = 0;
      HEAP32[212 >> 2] = HEAPU32[648 >> 2] | 0;
      HEAP32[208 >> 2] = 4294967295;
      i5 = 0;
      do_out$50 : do {
       i62 = 216 + ((i5 << 1 | 0) << 2 | 0) | 0;
       HEAP32[(i62 + 12 | 0) >> 2] = i62;
       HEAP32[(i62 + 8 | 0) >> 2] = i62;
       i5 = i5 + 1 | 0;
       if (i5 != 32) continue do_out$50;
      } while (0);
      i5 = i58 + 8 | 0;
      if ((i5 & 7 | 0) == 0) wasm2asm_i32$1 = 0; else wasm2asm_i32$1 = (0 - i5 | 0) & 7 | 0;
      i62 = wasm2asm_i32$1;
      i5 = i58 + i62 | 0;
      i63 = (i59 + 4294967256 | 0) - i62 | 0;
      HEAP32[200 >> 2] = i5;
      HEAP32[188 >> 2] = i63;
      HEAP32[(i5 + 4 | 0) >> 2] = i63 | 1 | 0;
      HEAP32[((i5 + i63 | 0) + 4 | 0) >> 2] = 40;
      HEAP32[204 >> 2] = HEAPU32[664 >> 2] | 0;
     }
    }
    i59 = HEAPU32[188 >> 2] | 0;
    if ((i59 >>> 0 | 0) >>> 0 > (i31 >>> 0 | 0) >>> 0) {
     i58 = i59 - i31 | 0;
     HEAP32[188 >> 2] = i58;
     i59 = HEAPU32[200 >> 2] | 0;
     i60 = i59 + i31 | 0;
     HEAP32[200 >> 2] = i60;
     HEAP32[(i60 + 4 | 0) >> 2] = i58 | 1 | 0;
     HEAP32[(i59 + 4 | 0) >> 2] = i31 | 3 | 0;
     i13 = i59 + 8 | 0;
     wasm2asm_i32$0 = i13;
     break topmost;
    }
   }
   HEAP32[(___errno_location() | 0) >> 2] = 12;
   i13 = 0;
   wasm2asm_i32$0 = i13;
  }
  return wasm2asm_i32$0;
 }
 
 function _free(i1) {
  i1 = i1 | 0;
  var i2 = 0, i3 = 0, i4 = 0, i5 = 0, i6 = 0, i7 = 0, i8 = 0, i9 = 0, i10 = 0, i11 = 0, i12 = 0, i13 = 0, i14 = 0, i15 = 0, i16 = 0, i17 = 0, i18 = 0, i19 = 0, i20 = 0, i21 = 0, i22 = 0, i23 = 0, i24 = 0, i25 = 0, i26 = 0, i27 = 0, i28 = 0, i29 = 0, i30 = 0, i31 = 0, i32 = 0, i33 = 0, i34 = 0, i35 = 0, i36 = 0, i37 = 0, wasm2asm_i32$2 = 0, wasm2asm_i32$1 = 0, wasm2asm_i32$0 = 0;
  topmost : {
   if (i1 == 0) break topmost;
   i2 = i1 + 4294967288 | 0;
   i3 = HEAPU32[192 >> 2] | 0;
   if ((i2 >>> 0 | 0) >>> 0 < (i3 >>> 0 | 0) >>> 0) _abort();
   i4 = HEAPU32[(i1 + 4294967292 | 0) >> 2] | 0;
   i1 = i4 & 3 | 0;
   if (i1 == 1) _abort();
   i5 = i4 & 4294967288 | 0;
   i6 = i2 + i5 | 0;
   do_once$0 : {
    if ((i4 & 1 | 0) == 0) {
     i7 = HEAPU32[i2 >> 2] | 0;
     if (i1 == 0) break topmost;
     i8 = i2 + (0 - i7 | 0) | 0;
     i9 = i7 + i5 | 0;
     if ((i8 >>> 0 | 0) >>> 0 < (i3 >>> 0 | 0) >>> 0) _abort();
     if (i8 == (HEAPU32[196 >> 2] | 0)) {
      i10 = i6 + 4 | 0;
      i11 = HEAPU32[i10 >> 2] | 0;
      if ((i11 & 3 | 0) != 3) {
       i12 = i8;
       i13 = i9;
       break do_once$0;
      }
      HEAP32[184 >> 2] = i9;
      HEAP32[i10 >> 2] = i11 & 4294967294 | 0;
      HEAP32[(i8 + 4 | 0) >> 2] = i9 | 1 | 0;
      HEAP32[(i8 + i9 | 0) >> 2] = i9;
      break topmost;
     }
     i11 = i7 >>> 3 | 0;
     if ((i7 >>> 0 | 0) >>> 0 < 256 >>> 0) {
      i7 = HEAPU32[(i8 + 8 | 0) >> 2] | 0;
      i10 = HEAPU32[(i8 + 12 | 0) >> 2] | 0;
      i14 = 216 + ((i11 << 1 | 0) << 2 | 0) | 0;
      if (i7 != i14) {
       if ((i7 >>> 0 | 0) >>> 0 < (i3 >>> 0 | 0) >>> 0) _abort();
       if ((HEAPU32[(i7 + 12 | 0) >> 2] | 0) != i8) _abort();
      }
      if (i10 == i7) {
       HEAP32[176 >> 2] = (HEAPU32[176 >> 2] | 0) & ((1 << i11 | 0) ^ 4294967295 | 0) | 0;
       i12 = i8;
       i13 = i9;
       break do_once$0;
      }
      if (i10 != i14) {
       if ((i10 >>> 0 | 0) >>> 0 < (i3 >>> 0 | 0) >>> 0) _abort();
       i14 = i10 + 8 | 0;
       if ((HEAPU32[i14 >> 2] | 0) == i8) i15 = i14; else _abort();
      } else i15 = i10 + 8 | 0;
      HEAP32[(i7 + 12 | 0) >> 2] = i10;
      HEAP32[i15 >> 2] = i7;
      i12 = i8;
      i13 = i9;
      break do_once$0;
     }
     i7 = HEAPU32[(i8 + 24 | 0) >> 2] | 0;
     i10 = HEAPU32[(i8 + 12 | 0) >> 2] | 0;
     do_once$1 : {
      if (i10 == i8) {
       i14 = i8 + 16 | 0;
       i11 = i14 + 4 | 0;
       i16 = HEAPU32[i11 >> 2] | 0;
       if (i16 == 0) {
        i17 = HEAPU32[i14 >> 2] | 0;
        if (i17 == 0) {
         i18 = 0;
         break do_once$1;
        } else {
         i19 = i17;
         i20 = i14;
        }
       } else {
        i19 = i16;
        i20 = i11;
       }
       while_out$2 : do {
        i11 = i19 + 20 | 0;
        i16 = HEAPU32[i11 >> 2] | 0;
        if (i16) {
         i19 = i16;
         i20 = i11;
         continue while_out$2;
        }
        i11 = i19 + 16 | 0;
        i16 = HEAPU32[i11 >> 2] | 0;
        if (i16 == 0) {
         i21 = i19;
         i22 = i20;
         break while_out$2;
        } else {
         i19 = i16;
         i20 = i11;
        }
        continue while_out$2;
       } while (0);
       if ((i22 >>> 0 | 0) >>> 0 < (i3 >>> 0 | 0) >>> 0) _abort(); else {
        HEAP32[i22 >> 2] = 0;
        i18 = i21;
        break do_once$1;
       }
      } else {
       i11 = HEAPU32[(i8 + 8 | 0) >> 2] | 0;
       if ((i11 >>> 0 | 0) >>> 0 < (i3 >>> 0 | 0) >>> 0) _abort();
       i16 = i11 + 12 | 0;
       if ((HEAPU32[i16 >> 2] | 0) != i8) _abort();
       i14 = i10 + 8 | 0;
       if ((HEAPU32[i14 >> 2] | 0) == i8) {
        HEAP32[i16 >> 2] = i10;
        HEAP32[i14 >> 2] = i11;
        i18 = i10;
        break do_once$1;
       } else _abort();
      }
     }
     if (i7) {
      i10 = HEAPU32[(i8 + 28 | 0) >> 2] | 0;
      i11 = 480 + (i10 << 2 | 0) | 0;
      if (i8 == (HEAPU32[i11 >> 2] | 0)) {
       HEAP32[i11 >> 2] = i18;
       if (i18 == 0) {
        HEAP32[180 >> 2] = (HEAPU32[180 >> 2] | 0) & ((1 << i10 | 0) ^ 4294967295 | 0) | 0;
        i12 = i8;
        i13 = i9;
        break do_once$0;
       }
      } else {
       if ((i7 >>> 0 | 0) >>> 0 < ((HEAPU32[192 >> 2] | 0) >>> 0 | 0) >>> 0) _abort();
       i10 = i7 + 16 | 0;
       if ((HEAPU32[i10 >> 2] | 0) == i8) HEAP32[i10 >> 2] = i18; else HEAP32[(i7 + 20 | 0) >> 2] = i18;
       if (i18 == 0) {
        i12 = i8;
        i13 = i9;
        break do_once$0;
       }
      }
      i10 = HEAPU32[192 >> 2] | 0;
      if ((i18 >>> 0 | 0) >>> 0 < (i10 >>> 0 | 0) >>> 0) _abort();
      HEAP32[(i18 + 24 | 0) >> 2] = i7;
      i11 = i8 + 16 | 0;
      i14 = HEAPU32[i11 >> 2] | 0;
      do_once$4 : {
       if (i14) if ((i14 >>> 0 | 0) >>> 0 < (i10 >>> 0 | 0) >>> 0) _abort(); else {
        HEAP32[(i18 + 16 | 0) >> 2] = i14;
        HEAP32[(i14 + 24 | 0) >> 2] = i18;
        break do_once$4;
       }
      }
      i14 = HEAPU32[(i11 + 4 | 0) >> 2] | 0;
      if (i14) if ((i14 >>> 0 | 0) >>> 0 < ((HEAPU32[192 >> 2] | 0) >>> 0 | 0) >>> 0) _abort(); else {
       HEAP32[(i18 + 20 | 0) >> 2] = i14;
       HEAP32[(i14 + 24 | 0) >> 2] = i18;
       i12 = i8;
       i13 = i9;
       break do_once$0;
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
    }
   }
   if ((i12 >>> 0 | 0) >>> 0 >= (i6 >>> 0 | 0) >>> 0) _abort();
   i5 = i6 + 4 | 0;
   i2 = HEAPU32[i5 >> 2] | 0;
   if ((i2 & 1 | 0) == 0) _abort();
   if ((i2 & 2 | 0) == 0) {
    if (i6 == (HEAPU32[200 >> 2] | 0)) {
     i18 = (HEAPU32[188 >> 2] | 0) + i13 | 0;
     HEAP32[188 >> 2] = i18;
     HEAP32[200 >> 2] = i12;
     HEAP32[(i12 + 4 | 0) >> 2] = i18 | 1 | 0;
     if (i12 != (HEAPU32[196 >> 2] | 0)) break topmost;
     HEAP32[196 >> 2] = 0;
     HEAP32[184 >> 2] = 0;
     break topmost;
    }
    if (i6 == (HEAPU32[196 >> 2] | 0)) {
     i18 = (HEAPU32[184 >> 2] | 0) + i13 | 0;
     HEAP32[184 >> 2] = i18;
     HEAP32[196 >> 2] = i12;
     HEAP32[(i12 + 4 | 0) >> 2] = i18 | 1 | 0;
     HEAP32[(i12 + i18 | 0) >> 2] = i18;
     break topmost;
    }
    i18 = (i2 & 4294967288 | 0) + i13 | 0;
    i3 = i2 >>> 3 | 0;
    do_once$5 : {
     if ((i2 >>> 0 | 0) >>> 0 >= 256 >>> 0) {
      i21 = HEAPU32[(i6 + 24 | 0) >> 2] | 0;
      i22 = HEAPU32[(i6 + 12 | 0) >> 2] | 0;
      do_once$6 : {
       if (i22 == i6) {
        i20 = i6 + 16 | 0;
        i19 = i20 + 4 | 0;
        i15 = HEAPU32[i19 >> 2] | 0;
        if (i15 == 0) {
         i1 = HEAPU32[i20 >> 2] | 0;
         if (i1 == 0) {
          i23 = 0;
          break do_once$6;
         } else {
          i24 = i1;
          i25 = i20;
         }
        } else {
         i24 = i15;
         i25 = i19;
        }
        while_out$7 : do {
         i19 = i24 + 20 | 0;
         i15 = HEAPU32[i19 >> 2] | 0;
         if (i15) {
          i24 = i15;
          i25 = i19;
          continue while_out$7;
         }
         i19 = i24 + 16 | 0;
         i15 = HEAPU32[i19 >> 2] | 0;
         if (i15 == 0) {
          i26 = i24;
          i27 = i25;
          break while_out$7;
         } else {
          i24 = i15;
          i25 = i19;
         }
         continue while_out$7;
        } while (0);
        if ((i27 >>> 0 | 0) >>> 0 < ((HEAPU32[192 >> 2] | 0) >>> 0 | 0) >>> 0) _abort(); else {
         HEAP32[i27 >> 2] = 0;
         i23 = i26;
         break do_once$6;
        }
       } else {
        i19 = HEAPU32[(i6 + 8 | 0) >> 2] | 0;
        if ((i19 >>> 0 | 0) >>> 0 < ((HEAPU32[192 >> 2] | 0) >>> 0 | 0) >>> 0) _abort();
        i15 = i19 + 12 | 0;
        if ((HEAPU32[i15 >> 2] | 0) != i6) _abort();
        i20 = i22 + 8 | 0;
        if ((HEAPU32[i20 >> 2] | 0) == i6) {
         HEAP32[i15 >> 2] = i22;
         HEAP32[i20 >> 2] = i19;
         i23 = i22;
         break do_once$6;
        } else _abort();
       }
      }
      if (i21) {
       i22 = HEAPU32[(i6 + 28 | 0) >> 2] | 0;
       i9 = 480 + (i22 << 2 | 0) | 0;
       if (i6 == (HEAPU32[i9 >> 2] | 0)) {
        HEAP32[i9 >> 2] = i23;
        if (i23 == 0) {
         HEAP32[180 >> 2] = (HEAPU32[180 >> 2] | 0) & ((1 << i22 | 0) ^ 4294967295 | 0) | 0;
         break do_once$5;
        }
       } else {
        if ((i21 >>> 0 | 0) >>> 0 < ((HEAPU32[192 >> 2] | 0) >>> 0 | 0) >>> 0) _abort();
        i22 = i21 + 16 | 0;
        if ((HEAPU32[i22 >> 2] | 0) == i6) HEAP32[i22 >> 2] = i23; else HEAP32[(i21 + 20 | 0) >> 2] = i23;
        if (i23 == 0) break do_once$5;
       }
       i22 = HEAPU32[192 >> 2] | 0;
       if ((i23 >>> 0 | 0) >>> 0 < (i22 >>> 0 | 0) >>> 0) _abort();
       HEAP32[(i23 + 24 | 0) >> 2] = i21;
       i9 = i6 + 16 | 0;
       i8 = HEAPU32[i9 >> 2] | 0;
       do_once$9 : {
        if (i8) if ((i8 >>> 0 | 0) >>> 0 < (i22 >>> 0 | 0) >>> 0) _abort(); else {
         HEAP32[(i23 + 16 | 0) >> 2] = i8;
         HEAP32[(i8 + 24 | 0) >> 2] = i23;
         break do_once$9;
        }
       }
       i8 = HEAPU32[(i9 + 4 | 0) >> 2] | 0;
       if (i8) if ((i8 >>> 0 | 0) >>> 0 < ((HEAPU32[192 >> 2] | 0) >>> 0 | 0) >>> 0) _abort(); else {
        HEAP32[(i23 + 20 | 0) >> 2] = i8;
        HEAP32[(i8 + 24 | 0) >> 2] = i23;
        break do_once$5;
       }
      }
     } else {
      i8 = HEAPU32[(i6 + 8 | 0) >> 2] | 0;
      i22 = HEAPU32[(i6 + 12 | 0) >> 2] | 0;
      i21 = 216 + ((i3 << 1 | 0) << 2 | 0) | 0;
      if (i8 != i21) {
       if ((i8 >>> 0 | 0) >>> 0 < ((HEAPU32[192 >> 2] | 0) >>> 0 | 0) >>> 0) _abort();
       if ((HEAPU32[(i8 + 12 | 0) >> 2] | 0) != i6) _abort();
      }
      if (i22 == i8) {
       HEAP32[176 >> 2] = (HEAPU32[176 >> 2] | 0) & ((1 << i3 | 0) ^ 4294967295 | 0) | 0;
       break do_once$5;
      }
      if (i22 != i21) {
       if ((i22 >>> 0 | 0) >>> 0 < ((HEAPU32[192 >> 2] | 0) >>> 0 | 0) >>> 0) _abort();
       i21 = i22 + 8 | 0;
       if ((HEAPU32[i21 >> 2] | 0) == i6) i28 = i21; else _abort();
      } else i28 = i22 + 8 | 0;
      HEAP32[(i8 + 12 | 0) >> 2] = i22;
      HEAP32[i28 >> 2] = i8;
     }
    }
    HEAP32[(i12 + 4 | 0) >> 2] = i18 | 1 | 0;
    HEAP32[(i12 + i18 | 0) >> 2] = i18;
    if (i12 == (HEAPU32[196 >> 2] | 0)) {
     HEAP32[184 >> 2] = i18;
     break topmost;
    } else i29 = i18;
   } else {
    HEAP32[i5 >> 2] = i2 & 4294967294 | 0;
    HEAP32[(i12 + 4 | 0) >> 2] = i13 | 1 | 0;
    HEAP32[(i12 + i13 | 0) >> 2] = i13;
    i29 = i13;
   }
   i13 = i29 >>> 3 | 0;
   if ((i29 >>> 0 | 0) >>> 0 < 256 >>> 0) {
    i2 = 216 + ((i13 << 1 | 0) << 2 | 0) | 0;
    i5 = HEAPU32[176 >> 2] | 0;
    i18 = 1 << i13 | 0;
    if (i5 & i18 | 0) {
     i13 = i2 + 8 | 0;
     i28 = HEAPU32[i13 >> 2] | 0;
     if ((i28 >>> 0 | 0) >>> 0 < ((HEAPU32[192 >> 2] | 0) >>> 0 | 0) >>> 0) _abort(); else {
      i30 = i13;
      i31 = i28;
     }
    } else {
     HEAP32[176 >> 2] = i5 | i18 | 0;
     i30 = i2 + 8 | 0;
     i31 = i2;
    }
    HEAP32[i30 >> 2] = i12;
    HEAP32[(i31 + 12 | 0) >> 2] = i12;
    HEAP32[(i12 + 8 | 0) >> 2] = i31;
    HEAP32[(i12 + 12 | 0) >> 2] = i2;
    break topmost;
   }
   i2 = i29 >>> 8 | 0;
   if (i2) if ((i29 >>> 0 | 0) >>> 0 > 16777215 >>> 0) i32 = 31; else {
    i31 = ((i2 + 1048320 | 0) >>> 16 | 0) & 8 | 0;
    i30 = i2 << i31 | 0;
    i2 = ((i30 + 520192 | 0) >>> 16 | 0) & 4 | 0;
    i18 = i30 << i2 | 0;
    i30 = ((i18 + 245760 | 0) >>> 16 | 0) & 2 | 0;
    i5 = (14 - (i2 | i31 | 0 | i30 | 0) | 0) + ((i18 << i30 | 0) >>> 15 | 0) | 0;
    i32 = (i29 >>> (i5 + 7 | 0) | 0) & 1 | 0 | (i5 << 1 | 0) | 0;
   } else i32 = 0;
   i5 = 480 + (i32 << 2 | 0) | 0;
   HEAP32[(i12 + 28 | 0) >> 2] = i32;
   HEAP32[(i12 + 20 | 0) >> 2] = 0;
   HEAP32[(i12 + 16 | 0) >> 2] = 0;
   i30 = HEAPU32[180 >> 2] | 0;
   i18 = 1 << i32 | 0;
   do_once$10 : {
    if (i30 & i18 | 0) {
     wasm2asm_i32$1 = i29;
     if (i32 == 31) wasm2asm_i32$2 = 0; else wasm2asm_i32$2 = 25 - (i32 >>> 1 | 0) | 0;
     wasm2asm_i32$0 = wasm2asm_i32$1 << wasm2asm_i32$2 | 0;
     i31 = wasm2asm_i32$0;
     i2 = HEAPU32[i5 >> 2] | 0;
     while_out$11 : do {
      if (((HEAPU32[(i2 + 4 | 0) >> 2] | 0) & 4294967288 | 0) == i29) {
       i33 = i2;
       i34 = 130;
       break while_out$11;
      }
      i28 = (i2 + 16 | 0) + ((i31 >>> 31 | 0) << 2 | 0) | 0;
      i13 = HEAPU32[i28 >> 2] | 0;
      if (i13 == 0) {
       i35 = i28;
       i36 = i2;
       i34 = 127;
       break while_out$11;
      } else {
       i31 = i31 << 1 | 0;
       i2 = i13;
      }
      continue while_out$11;
     } while (0);
     if (i34 == 127) if ((i35 >>> 0 | 0) >>> 0 < ((HEAPU32[192 >> 2] | 0) >>> 0 | 0) >>> 0) _abort(); else {
      HEAP32[i35 >> 2] = i12;
      HEAP32[(i12 + 24 | 0) >> 2] = i36;
      HEAP32[(i12 + 12 | 0) >> 2] = i12;
      HEAP32[(i12 + 8 | 0) >> 2] = i12;
      break do_once$10;
     } else if (i34 == 130) {
      i2 = i33 + 8 | 0;
      i31 = HEAPU32[i2 >> 2] | 0;
      i9 = HEAPU32[192 >> 2] | 0;
      if ((i31 >>> 0 | 0) >>> 0 >= (i9 >>> 0 | 0) >>> 0 & (i33 >>> 0 | 0) >>> 0 >= (i9 >>> 0 | 0) >>> 0 | 0) {
       HEAP32[(i31 + 12 | 0) >> 2] = i12;
       HEAP32[i2 >> 2] = i12;
       HEAP32[(i12 + 8 | 0) >> 2] = i31;
       HEAP32[(i12 + 12 | 0) >> 2] = i33;
       HEAP32[(i12 + 24 | 0) >> 2] = 0;
       break do_once$10;
      } else _abort();
     }
    } else {
     HEAP32[180 >> 2] = i30 | i18 | 0;
     HEAP32[i5 >> 2] = i12;
     HEAP32[(i12 + 24 | 0) >> 2] = i5;
     HEAP32[(i12 + 12 | 0) >> 2] = i12;
     HEAP32[(i12 + 8 | 0) >> 2] = i12;
    }
   }
   i12 = (HEAPU32[208 >> 2] | 0) + 4294967295 | 0;
   HEAP32[208 >> 2] = i12;
   if (i12 == 0) i37 = 632; else break topmost;
   while_out$13 : do {
    i12 = HEAPU32[i37 >> 2] | 0;
    if (i12 == 0) break while_out$13; else i37 = i12 + 8 | 0;
    continue while_out$13;
   } while (0);
   HEAP32[208 >> 2] = 4294967295;
   break topmost;
  }
 }
 
 function ___stdio_write(i1, i2, i3) {
  i1 = i1 | 0;
  i2 = i2 | 0;
  i3 = i3 | 0;
  var i4 = 0, i5 = 0, i6 = 0, i7 = 0, i8 = 0, i9 = 0, i10 = 0, i11 = 0, i12 = 0, i13 = 0, i14 = 0, i15 = 0, i16 = 0, i17 = 0, i18 = 0, i19 = 0, i20 = 0, i21 = 0, i22 = 0, i23 = 0, i24 = 0, wasm2asm_i32$0 = 0;
  topmost : {
   i4 = HEAPU32[8 >> 2] | 0;
   HEAP32[8 >> 2] = (HEAPU32[8 >> 2] | 0) + 48 | 0;
   i5 = i4 + 16 | 0;
   i6 = i4;
   i7 = i4 + 32 | 0;
   i8 = i1 + 28 | 0;
   i9 = HEAPU32[i8 >> 2] | 0;
   HEAP32[i7 >> 2] = i9;
   i10 = i1 + 20 | 0;
   i11 = (HEAPU32[i10 >> 2] | 0) - i9 | 0;
   HEAP32[(i7 + 4 | 0) >> 2] = i11;
   HEAP32[(i7 + 8 | 0) >> 2] = i2;
   HEAP32[(i7 + 12 | 0) >> 2] = i3;
   i2 = i1 + 60 | 0;
   i9 = i1 + 44 | 0;
   i12 = i7;
   i7 = 2;
   i13 = i11 + i3 | 0;
   while_out$0 : do {
    if ((HEAPU32[8 >> 2] | 0) == 0) {
     HEAP32[i5 >> 2] = HEAPU32[i2 >> 2] | 0;
     HEAP32[(i5 + 4 | 0) >> 2] = i12;
     HEAP32[(i5 + 8 | 0) >> 2] = i7;
     i14 = ___syscall_ret(___syscall146(146 | 0, i5 | 0) | 0 | 0) | 0;
    } else {
     _pthread_cleanup_push(4 | 0, i1 | 0);
     HEAP32[i6 >> 2] = HEAPU32[i2 >> 2] | 0;
     HEAP32[(i6 + 4 | 0) >> 2] = i12;
     HEAP32[(i6 + 8 | 0) >> 2] = i7;
     i11 = ___syscall_ret(___syscall146(146 | 0, i6 | 0) | 0 | 0) | 0;
     _pthread_cleanup_pop(0 | 0);
     i14 = i11;
    }
    if (i13 == i14) {
     i15 = 6;
     break while_out$0;
    }
    if ((i14 | 0) < (0 | 0)) {
     i16 = i12;
     i17 = i7;
     i15 = 8;
     break while_out$0;
    }
    i11 = i13 - i14 | 0;
    i18 = HEAPU32[(i12 + 4 | 0) >> 2] | 0;
    if ((i14 >>> 0 | 0) >>> 0 <= (i18 >>> 0 | 0) >>> 0) if (i7 == 2) {
     HEAP32[i8 >> 2] = (HEAPU32[i8 >> 2] | 0) + i14 | 0;
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
     i23 = HEAPU32[i9 >> 2] | 0;
     HEAP32[i8 >> 2] = i23;
     HEAP32[i10 >> 2] = i23;
     i19 = HEAPU32[(i12 + 12 | 0) >> 2] | 0;
     i20 = i14 - i18 | 0;
     i21 = i12 + 8 | 0;
     i22 = i7 + 4294967295 | 0;
    }
    HEAP32[i21 >> 2] = (HEAPU32[i21 >> 2] | 0) + i20 | 0;
    HEAP32[(i21 + 4 | 0) >> 2] = i19 - i20 | 0;
    i12 = i21;
    i7 = i22;
    i13 = i11;
    continue while_out$0;
   } while (0);
   if (i15 == 6) {
    i13 = HEAPU32[i9 >> 2] | 0;
    HEAP32[(i1 + 16 | 0) >> 2] = i13 + (HEAPU32[(i1 + 48 | 0) >> 2] | 0) | 0;
    i9 = i13;
    HEAP32[i8 >> 2] = i9;
    HEAP32[i10 >> 2] = i9;
    i24 = i3;
   } else if (i15 == 8) {
    HEAP32[(i1 + 16 | 0) >> 2] = 0;
    HEAP32[i8 >> 2] = 0;
    HEAP32[i10 >> 2] = 0;
    HEAP32[i1 >> 2] = HEAPU32[i1 >> 2] | 0 | 32 | 0;
    if (i17 == 2) i24 = 0; else i24 = i3 - (HEAPU32[(i16 + 4 | 0) >> 2] | 0) | 0;
   }
   HEAP32[8 >> 2] = i4;
   wasm2asm_i32$0 = i24;
  }
  return wasm2asm_i32$0;
 }
 
 function ___fwritex(i1, i2, i3) {
  i1 = i1 | 0;
  i2 = i2 | 0;
  i3 = i3 | 0;
  var i4 = 0, i5 = 0, i6 = 0, i7 = 0, i8 = 0, i9 = 0, i10 = 0, i11 = 0, i12 = 0, i13 = 0, i14 = 0, i15 = 0, wasm2asm_i32$0 = 0;
  topmost : {
   i4 = i3 + 16 | 0;
   i5 = HEAPU32[i4 >> 2] | 0;
   if (i5 == 0) if ((___towrite(i3 | 0) | 0) == 0) {
    i6 = HEAPU32[i4 >> 2] | 0;
    i7 = 5;
   } else i8 = 0; else {
    i6 = i5;
    i7 = 5;
   }
   label$break$L5 : {
    if (i7 == 5) {
     i5 = i3 + 20 | 0;
     i4 = HEAPU32[i5 >> 2] | 0;
     i9 = i4;
     if (((i6 - i4 | 0) >>> 0 | 0) >>> 0 < (i2 >>> 0 | 0) >>> 0) {
      i8 = FUNCTION_TABLE[((HEAPU32[(i3 + 36 | 0) >> 2] | 0) & 7 | 0) + 2 | 0](i3 | 0, i1 | 0, i2 | 0) | 0;
      break label$break$L5;
     }
     label$break$L10 : {
      if ((HEAP8[(i3 + 75 | 0) >> 0] | 0 | 0) > (4294967295 | 0)) {
       i4 = i2;
       while_out$0 : do {
        if (i4 == 0) {
         i10 = i2;
         i11 = i1;
         i12 = i9;
         i13 = 0;
         break label$break$L10;
        }
        i14 = i4 + 4294967295 | 0;
        if ((HEAP8[(i1 + i14 | 0) >> 0] | 0) == 10) {
         i15 = i4;
         break while_out$0;
        } else i4 = i14;
        continue while_out$0;
       } while (0);
       if (((FUNCTION_TABLE[((HEAPU32[(i3 + 36 | 0) >> 2] | 0) & 7 | 0) + 2 | 0](i3 | 0, i1 | 0, i15 | 0) | 0) >>> 0 | 0) >>> 0 < (i15 >>> 0 | 0) >>> 0) {
        i8 = i15;
        break label$break$L5;
       }
       i10 = i2 - i15 | 0;
       i11 = i1 + i15 | 0;
       i12 = HEAPU32[i5 >> 2] | 0;
       i13 = i15;
      } else {
       i10 = i2;
       i11 = i1;
       i12 = i9;
       i13 = 0;
      }
     }
     _memcpy(i12 | 0, i11 | 0, i10 | 0) | 0;
     HEAP32[i5 >> 2] = (HEAPU32[i5 >> 2] | 0) + i10 | 0;
     i8 = i13 + i10 | 0;
    }
   }
   wasm2asm_i32$0 = i8;
  }
  return wasm2asm_i32$0;
 }
 
 function _fflush(i1) {
  i1 = i1 | 0;
  var i2 = 0, i3 = 0, i4 = 0, i5 = 0, i6 = 0, i7 = 0, i8 = 0, wasm2asm_i32$0 = 0;
  topmost : {
   do_once$0 : {
    if (i1) {
     if ((HEAPU32[(i1 + 76 | 0) >> 2] | 0 | 0) <= (4294967295 | 0)) {
      i2 = ___fflush_unlocked(i1 | 0) | 0;
      break do_once$0;
     }
     i3 = (___lockfile(i1 | 0) | 0) == 0;
     i4 = ___fflush_unlocked(i1 | 0) | 0;
     if (i3) i2 = i4; else {
      ___unlockfile(i1 | 0);
      i2 = i4;
     }
    } else {
     if ((HEAPU32[56 >> 2] | 0) == 0) i5 = 0; else i5 = _fflush(HEAPU32[56 >> 2] | 0 | 0) | 0;
     ___lock(36 | 0);
     i4 = HEAPU32[32 >> 2] | 0;
     if (i4 == 0) i6 = i5; else {
      i3 = i4;
      i4 = i5;
      while_out$1 : do {
       if ((HEAPU32[(i3 + 76 | 0) >> 2] | 0 | 0) > (4294967295 | 0)) i7 = ___lockfile(i3 | 0) | 0; else i7 = 0;
       if (((HEAPU32[(i3 + 20 | 0) >> 2] | 0) >>> 0 | 0) >>> 0 > ((HEAPU32[(i3 + 28 | 0) >> 2] | 0) >>> 0 | 0) >>> 0) i8 = ___fflush_unlocked(i3 | 0) | 0 | i4 | 0; else i8 = i4;
       if (i7) ___unlockfile(i3 | 0);
       i3 = HEAPU32[(i3 + 56 | 0) >> 2] | 0;
       if (i3 == 0) {
        i6 = i8;
        break while_out$1;
       } else i4 = i8;
       continue while_out$1;
      } while (0);
     }
     ___unlock(36 | 0);
     i2 = i6;
    }
   }
   wasm2asm_i32$0 = i2;
  }
  return wasm2asm_i32$0;
 }
 
 function _strlen(i1) {
  i1 = i1 | 0;
  var i2 = 0, i3 = 0, i4 = 0, i5 = 0, i6 = 0, i7 = 0, i8 = 0, i9 = 0, i10 = 0, i11 = 0, wasm2asm_i32$0 = 0;
  topmost : {
   i2 = i1;
   label$break$L1 : {
    if ((i2 & 3 | 0) == 0) {
     i3 = i1;
     i4 = 4;
    } else {
     i5 = i1;
     i6 = i2;
     while_out$0 : do {
      if ((HEAP8[i5 >> 0] | 0) == 0) {
       i7 = i6;
       break label$break$L1;
      }
      i8 = i5 + 1 | 0;
      i6 = i8;
      if ((i6 & 3 | 0) == 0) {
       i3 = i8;
       i4 = 4;
       break while_out$0;
      } else i5 = i8;
      continue while_out$0;
     } while (0);
    }
   }
   if (i4 == 4) {
    i4 = i3;
    while_out$2 : do {
     i3 = HEAPU32[i4 >> 2] | 0;
     if ((((i3 & 2155905152 | 0) ^ 2155905152 | 0) & (i3 + 4278124287 | 0) | 0) == 0) i4 = i4 + 4 | 0; else {
      i9 = i3;
      i10 = i4;
      break while_out$2;
     }
     continue while_out$2;
    } while (0);
    if ((((i9 & 255 | 0) << 24 | 0) >> 24 | 0) == 0) i11 = i10; else {
     i9 = i10;
     while_out$4 : do {
      i10 = i9 + 1 | 0;
      if ((HEAP8[i10 >> 0] | 0) == 0) {
       i11 = i10;
       break while_out$4;
      } else i9 = i10;
      continue while_out$4;
     } while (0);
    }
    i7 = i11;
   }
   wasm2asm_i32$0 = i7 - i2 | 0;
  }
  return wasm2asm_i32$0;
 }
 
 function ___overflow(i1, i2) {
  i1 = i1 | 0;
  i2 = i2 | 0;
  var i3 = 0, i4 = 0, i5 = 0, i6 = 0, i7 = 0, i8 = 0, i9 = 0, i10 = 0, i11 = 0, wasm2asm_i32$1 = 0, wasm2asm_i32$0 = 0;
  topmost : {
   i3 = HEAPU32[8 >> 2] | 0;
   HEAP32[8 >> 2] = (HEAPU32[8 >> 2] | 0) + 16 | 0;
   i4 = i3;
   i5 = i2 & 255 | 0;
   HEAP8[i4 >> 0] = i5;
   i6 = i1 + 16 | 0;
   i7 = HEAPU32[i6 >> 2] | 0;
   if (i7 == 0) if ((___towrite(i1 | 0) | 0) == 0) {
    i8 = HEAPU32[i6 >> 2] | 0;
    i9 = 4;
   } else i10 = 4294967295; else {
    i8 = i7;
    i9 = 4;
   }
   do_once$0 : {
    if (i9 == 4) {
     i7 = i1 + 20 | 0;
     i6 = HEAPU32[i7 >> 2] | 0;
     if ((i6 >>> 0 | 0) >>> 0 < (i8 >>> 0 | 0) >>> 0) {
      i11 = i2 & 255 | 0;
      wasm2asm_i32$1 = i11 != (HEAP8[(i1 + 75 | 0) >> 0] | 0);
     } else wasm2asm_i32$1 = 0;
     if (wasm2asm_i32$1) {
      HEAP32[i7 >> 2] = i6 + 1 | 0;
      HEAP8[i6 >> 0] = i5;
      i10 = i11;
      break do_once$0;
     }
     if ((FUNCTION_TABLE[((HEAPU32[(i1 + 36 | 0) >> 2] | 0) & 7 | 0) + 2 | 0](i1 | 0, i4 | 0, 1 | 0) | 0) == 1) i10 = HEAPU8[i4 >> 0] | 0; else i10 = 4294967295;
    }
   }
   HEAP32[8 >> 2] = i3;
   wasm2asm_i32$0 = i10;
  }
  return wasm2asm_i32$0;
 }
 
 function ___fflush_unlocked(i1) {
  i1 = i1 | 0;
  var i2 = 0, i3 = 0, i4 = 0, i5 = 0, i6 = 0, i7 = 0, i8 = 0, wasm2asm_i32$1 = 0, wasm2asm_i32$0 = 0;
  topmost : {
   i2 = i1 + 20 | 0;
   i3 = i1 + 28 | 0;
   if (((HEAPU32[i2 >> 2] | 0) >>> 0 | 0) >>> 0 > ((HEAPU32[i3 >> 2] | 0) >>> 0 | 0) >>> 0) {
    FUNCTION_TABLE[((HEAPU32[(i1 + 36 | 0) >> 2] | 0) & 7 | 0) + 2 | 0](i1 | 0, 0 | 0, 0 | 0) | 0;
    wasm2asm_i32$1 = (HEAPU32[i2 >> 2] | 0) == 0;
   } else wasm2asm_i32$1 = 0;
   if (wasm2asm_i32$1) i4 = 4294967295; else {
    i5 = i1 + 4 | 0;
    i6 = HEAPU32[i5 >> 2] | 0;
    i7 = i1 + 8 | 0;
    i8 = HEAPU32[i7 >> 2] | 0;
    if ((i6 >>> 0 | 0) >>> 0 < (i8 >>> 0 | 0) >>> 0) FUNCTION_TABLE[((HEAPU32[(i1 + 40 | 0) >> 2] | 0) & 7 | 0) + 2 | 0](i1 | 0, i6 - i8 | 0 | 0, 1 | 0) | 0;
    HEAP32[(i1 + 16 | 0) >> 2] = 0;
    HEAP32[i3 >> 2] = 0;
    HEAP32[i2 >> 2] = 0;
    HEAP32[i7 >> 2] = 0;
    HEAP32[i5 >> 2] = 0;
    i4 = 0;
   }
   wasm2asm_i32$0 = i4;
  }
  return wasm2asm_i32$0;
 }
 
 function _memcpy(i1, i2, i3) {
  i1 = i1 | 0;
  i2 = i2 | 0;
  i3 = i3 | 0;
  var i4 = 0, wasm2asm_i32$0 = 0;
  topmost : {
   if ((i3 | 0) >= (4096 | 0)) {
    wasm2asm_i32$0 = _emscripten_memcpy_big(i1 | 0, i2 | 0, i3 | 0) | 0;
    break topmost;
   }
   i4 = i1;
   if ((i1 & 3 | 0) == (i2 & 3 | 0)) {
    while_out$0 : do {
     if (i1 & 3 | 0) {} else break while_out$0;
     if (i3 == 0) {
      wasm2asm_i32$0 = i4;
      break topmost;
     }
     HEAP8[i1 >> 0] = HEAP8[i2 >> 0] | 0;
     i1 = i1 + 1 | 0;
     i2 = i2 + 1 | 0;
     i3 = i3 - 1 | 0;
     continue while_out$0;
    } while (0);
    while_out$2 : do {
     if ((i3 | 0) >= (4 | 0)) {} else break while_out$2;
     HEAP32[i1 >> 2] = HEAPU32[i2 >> 2] | 0;
     i1 = i1 + 4 | 0;
     i2 = i2 + 4 | 0;
     i3 = i3 - 4 | 0;
     continue while_out$2;
    } while (0);
   }
   while_out$4 : do {
    if ((i3 | 0) > (0 | 0)) {} else break while_out$4;
    HEAP8[i1 >> 0] = HEAP8[i2 >> 0] | 0;
    i1 = i1 + 1 | 0;
    i2 = i2 + 1 | 0;
    i3 = i3 - 1 | 0;
    continue while_out$4;
   } while (0);
   wasm2asm_i32$0 = i4;
  }
  return wasm2asm_i32$0;
 }
 
 function runPostSets() {
  
 }
 
 function _memset(i1, i2, i3) {
  i1 = i1 | 0;
  i2 = i2 | 0;
  i3 = i3 | 0;
  var i4 = 0, i5 = 0, i6 = 0, i7 = 0, wasm2asm_i32$0 = 0;
  topmost : {
   i4 = i1 + i3 | 0;
   if ((i3 | 0) >= (20 | 0)) {
    i2 = i2 & 255 | 0;
    i5 = i1 & 3 | 0;
    i6 = i2 | (i2 << 8 | 0) | 0 | (i2 << 16 | 0) | 0 | (i2 << 24 | 0) | 0;
    i7 = i4 & (3 ^ 4294967295 | 0) | 0;
    if (i5) {
     i5 = (i1 + 4 | 0) - i5 | 0;
     while_out$0 : do {
      if ((i1 | 0) < (i5 | 0)) {} else break while_out$0;
      HEAP8[i1 >> 0] = i2;
      i1 = i1 + 1 | 0;
      continue while_out$0;
     } while (0);
    }
    while_out$2 : do {
     if ((i1 | 0) < (i7 | 0)) {} else break while_out$2;
     HEAP32[i1 >> 2] = i6;
     i1 = i1 + 4 | 0;
     continue while_out$2;
    } while (0);
   }
   while_out$4 : do {
    if ((i1 | 0) < (i4 | 0)) {} else break while_out$4;
    HEAP8[i1 >> 0] = i2;
    i1 = i1 + 1 | 0;
    continue while_out$4;
   } while (0);
   wasm2asm_i32$0 = i1 - i3 | 0;
  }
  return wasm2asm_i32$0;
 }
 
 function _puts(i1) {
  i1 = i1 | 0;
  var i2 = 0, i3 = 0, i4 = 0, i5 = 0, i6 = 0, wasm2asm_i32$1 = 0, wasm2asm_i32$0 = 0;
  topmost : {
   i2 = HEAPU32[52 >> 2] | 0;
   if ((HEAPU32[(i2 + 76 | 0) >> 2] | 0 | 0) > (4294967295 | 0)) i3 = ___lockfile(i2 | 0) | 0; else i3 = 0;
   do_once$0 : {
    if ((_fputs(i1 | 0, i2 | 0) | 0 | 0) < (0 | 0)) i4 = 1; else {
     if ((HEAP8[(i2 + 75 | 0) >> 0] | 0) != 10) {
      i5 = i2 + 20 | 0;
      i6 = HEAPU32[i5 >> 2] | 0;
      wasm2asm_i32$1 = (i6 >>> 0 | 0) >>> 0 < ((HEAPU32[(i2 + 16 | 0) >> 2] | 0) >>> 0 | 0) >>> 0;
     } else wasm2asm_i32$1 = 0;
     if (wasm2asm_i32$1) {
      HEAP32[i5 >> 2] = i6 + 1 | 0;
      HEAP8[i6 >> 0] = 10;
      i4 = 0;
      break do_once$0;
     }
     i4 = (___overflow(i2 | 0, 10 | 0) | 0 | 0) < (0 | 0);
    }
   }
   if (i3) ___unlockfile(i2 | 0);
   wasm2asm_i32$0 = (i4 << 31 | 0) >> 31 | 0;
  }
  return wasm2asm_i32$0;
 }
 
 function ___stdio_seek(i1, i2, i3) {
  i1 = i1 | 0;
  i2 = i2 | 0;
  i3 = i3 | 0;
  var i4 = 0, i5 = 0, i6 = 0, i7 = 0, wasm2asm_i32$0 = 0;
  topmost : {
   i4 = HEAPU32[8 >> 2] | 0;
   HEAP32[8 >> 2] = (HEAPU32[8 >> 2] | 0) + 32 | 0;
   i5 = i4;
   i6 = i4 + 20 | 0;
   HEAP32[i5 >> 2] = HEAPU32[(i1 + 60 | 0) >> 2] | 0;
   HEAP32[(i5 + 4 | 0) >> 2] = 0;
   HEAP32[(i5 + 8 | 0) >> 2] = i2;
   HEAP32[(i5 + 12 | 0) >> 2] = i6;
   HEAP32[(i5 + 16 | 0) >> 2] = i3;
   if ((___syscall_ret(___syscall140(140 | 0, i5 | 0) | 0 | 0) | 0 | 0) < (0 | 0)) {
    HEAP32[i6 >> 2] = 4294967295;
    i7 = 4294967295;
   } else i7 = HEAPU32[i6 >> 2] | 0;
   HEAP32[8 >> 2] = i4;
   wasm2asm_i32$0 = i7;
  }
  return wasm2asm_i32$0;
 }
 
 function ___towrite(i1) {
  i1 = i1 | 0;
  var i2 = 0, i3 = 0, i4 = 0, wasm2asm_i32$0 = 0;
  topmost : {
   i2 = i1 + 74 | 0;
   i3 = HEAP8[i2 >> 0] | 0;
   HEAP8[i2 >> 0] = i3 + 255 | 0 | i3 | 0;
   i3 = HEAPU32[i1 >> 2] | 0;
   if ((i3 & 8 | 0) == 0) {
    HEAP32[(i1 + 8 | 0) >> 2] = 0;
    HEAP32[(i1 + 4 | 0) >> 2] = 0;
    i2 = HEAPU32[(i1 + 44 | 0) >> 2] | 0;
    HEAP32[(i1 + 28 | 0) >> 2] = i2;
    HEAP32[(i1 + 20 | 0) >> 2] = i2;
    HEAP32[(i1 + 16 | 0) >> 2] = i2 + (HEAPU32[(i1 + 48 | 0) >> 2] | 0) | 0;
    i4 = 0;
   } else {
    HEAP32[i1 >> 2] = i3 | 32 | 0;
    i4 = 4294967295;
   }
   wasm2asm_i32$0 = i4;
  }
  return wasm2asm_i32$0;
 }
 
 function _fwrite(i1, i2, i3, i4) {
  i1 = i1 | 0;
  i2 = i2 | 0;
  i3 = i3 | 0;
  i4 = i4 | 0;
  var i5 = 0, i6 = 0, i7 = 0, i8 = 0, i9 = 0, wasm2asm_i32$0 = 0;
  topmost : {
   i5 = i3 * i2 | 0;
   if ((HEAPU32[(i4 + 76 | 0) >> 2] | 0 | 0) > (4294967295 | 0)) {
    i6 = (___lockfile(i4 | 0) | 0) == 0;
    i7 = ___fwritex(i1 | 0, i5 | 0, i4 | 0) | 0;
    if (i6) i8 = i7; else {
     ___unlockfile(i4 | 0);
     i8 = i7;
    }
   } else i8 = ___fwritex(i1 | 0, i5 | 0, i4 | 0) | 0;
   if (i8 == i5) i9 = i3; else i9 = (i8 >>> 0 | 0) / (i2 >>> 0 | 0) | 0;
   wasm2asm_i32$0 = i9;
  }
  return wasm2asm_i32$0;
 }
 
 function ___stdout_write(i1, i2, i3) {
  i1 = i1 | 0;
  i2 = i2 | 0;
  i3 = i3 | 0;
  var i4 = 0, i5 = 0, wasm2asm_i32$1 = 0, wasm2asm_i32$0 = 0;
  topmost : {
   i4 = HEAPU32[8 >> 2] | 0;
   HEAP32[8 >> 2] = (HEAPU32[8 >> 2] | 0) + 80 | 0;
   i5 = i4;
   HEAP32[(i1 + 36 | 0) >> 2] = 5;
   if (((HEAPU32[i1 >> 2] | 0) & 64 | 0) == 0) {
    HEAP32[i5 >> 2] = HEAPU32[(i1 + 60 | 0) >> 2] | 0;
    HEAP32[(i5 + 4 | 0) >> 2] = 21505;
    HEAP32[(i5 + 8 | 0) >> 2] = i4 + 12 | 0;
    wasm2asm_i32$1 = (___syscall54(54 | 0, i5 | 0) | 0) != 0;
   } else wasm2asm_i32$1 = 0;
   if (wasm2asm_i32$1) HEAP8[(i1 + 75 | 0) >> 0] = 4294967295;
   i5 = ___stdio_write(i1 | 0, i2 | 0, i3 | 0) | 0;
   HEAP32[8 >> 2] = i4;
   wasm2asm_i32$0 = i5;
  }
  return wasm2asm_i32$0;
 }
 
 function copyTempDouble(i1) {
  i1 = i1 | 0;
  HEAP8[(HEAPU32[24 >> 2] | 0) >> 0] = HEAP8[i1 >> 0] | 0;
  HEAP8[((HEAPU32[24 >> 2] | 0) + 1 | 0) >> 0] = HEAP8[(i1 + 1 | 0) >> 0] | 0;
  HEAP8[((HEAPU32[24 >> 2] | 0) + 2 | 0) >> 0] = HEAP8[(i1 + 2 | 0) >> 0] | 0;
  HEAP8[((HEAPU32[24 >> 2] | 0) + 3 | 0) >> 0] = HEAP8[(i1 + 3 | 0) >> 0] | 0;
  HEAP8[((HEAPU32[24 >> 2] | 0) + 4 | 0) >> 0] = HEAP8[(i1 + 4 | 0) >> 0] | 0;
  HEAP8[((HEAPU32[24 >> 2] | 0) + 5 | 0) >> 0] = HEAP8[(i1 + 5 | 0) >> 0] | 0;
  HEAP8[((HEAPU32[24 >> 2] | 0) + 6 | 0) >> 0] = HEAP8[(i1 + 6 | 0) >> 0] | 0;
  HEAP8[((HEAPU32[24 >> 2] | 0) + 7 | 0) >> 0] = HEAP8[(i1 + 7 | 0) >> 0] | 0;
 }
 
 function ___stdio_close(i1) {
  i1 = i1 | 0;
  var i2 = 0, i3 = 0, wasm2asm_i32$0 = 0;
  topmost : {
   i2 = HEAPU32[8 >> 2] | 0;
   HEAP32[8 >> 2] = (HEAPU32[8 >> 2] | 0) + 16 | 0;
   i3 = i2;
   HEAP32[i3 >> 2] = HEAPU32[(i1 + 60 | 0) >> 2] | 0;
   i1 = ___syscall_ret(___syscall6(6 | 0, i3 | 0) | 0 | 0) | 0;
   HEAP32[8 >> 2] = i2;
   wasm2asm_i32$0 = i1;
  }
  return wasm2asm_i32$0;
 }
 
 function copyTempFloat(i1) {
  i1 = i1 | 0;
  HEAP8[(HEAPU32[24 >> 2] | 0) >> 0] = HEAP8[i1 >> 0] | 0;
  HEAP8[((HEAPU32[24 >> 2] | 0) + 1 | 0) >> 0] = HEAP8[(i1 + 1 | 0) >> 0] | 0;
  HEAP8[((HEAPU32[24 >> 2] | 0) + 2 | 0) >> 0] = HEAP8[(i1 + 2 | 0) >> 0] | 0;
  HEAP8[((HEAPU32[24 >> 2] | 0) + 3 | 0) >> 0] = HEAP8[(i1 + 3 | 0) >> 0] | 0;
 }
 
 function ___syscall_ret(i1) {
  i1 = i1 | 0;
  var i2 = 0, wasm2asm_i32$0 = 0;
  topmost : {
   if ((i1 >>> 0 | 0) >>> 0 > 4294963200 >>> 0) {
    HEAP32[(___errno_location() | 0) >> 2] = 0 - i1 | 0;
    i2 = 4294967295;
   } else i2 = i1;
   wasm2asm_i32$0 = i2;
  }
  return wasm2asm_i32$0;
 }
 
 function dynCall_iiii(i1, i2, i3, i4) {
  i1 = i1 | 0;
  i2 = i2 | 0;
  i3 = i3 | 0;
  i4 = i4 | 0;
  return FUNCTION_TABLE[(i1 & 7 | 0) + 2 | 0](i2 | 0, i3 | 0, i4 | 0) | 0;
 }
 
 function stackAlloc(i1) {
  i1 = i1 | 0;
  var i2 = 0, wasm2asm_i32$0 = 0;
  topmost : {
   i2 = HEAPU32[8 >> 2] | 0;
   HEAP32[8 >> 2] = (HEAPU32[8 >> 2] | 0) + i1 | 0;
   HEAP32[8 >> 2] = ((HEAPU32[8 >> 2] | 0) + 15 | 0) & 4294967280 | 0;
   wasm2asm_i32$0 = i2;
  }
  return wasm2asm_i32$0;
 }
 
 function ___errno_location() {
  var i1 = 0, wasm2asm_i32$0 = 0;
  topmost : {
   if ((HEAPU32[8 >> 2] | 0) == 0) i1 = 60; else i1 = HEAPU32[((_pthread_self() | 0) + 60 | 0) >> 2] | 0;
   wasm2asm_i32$0 = i1;
  }
  return wasm2asm_i32$0;
 }
 
 function setThrew(i1, i2) {
  i1 = i1 | 0;
  i2 = i2 | 0;
  if ((HEAPU32[40 >> 2] | 0) == 0) {
   HEAP32[40 >> 2] = i1;
   HEAP32[48 >> 2] = i2;
  }
 }
 
 function _fputs(i1, i2) {
  i1 = i1 | 0;
  i2 = i2 | 0;
  return (_fwrite(i1 | 0, _strlen(i1 | 0) | 0 | 0, 1 | 0, i2 | 0) | 0) + 4294967295 | 0;
 }
 
 function dynCall_ii(i1, i2) {
  i1 = i1 | 0;
  i2 = i2 | 0;
  return FUNCTION_TABLE[(i1 & 1 | 0) + 0 | 0](i2 | 0) | 0;
 }
 
 function _cleanup_418(i1) {
  i1 = i1 | 0;
  topmost : {
   if ((HEAPU32[(i1 + 68 | 0) >> 2] | 0) == 0) ___unlockfile(i1 | 0);
   break topmost;
  }
 }
 
 function establishStackSpace(i1, i2) {
  i1 = i1 | 0;
  i2 = i2 | 0;
  HEAP32[8 >> 2] = i1;
  HEAP32[16 >> 2] = i2;
 }
 
 function dynCall_vi(i1, i2) {
  i1 = i1 | 0;
  i2 = i2 | 0;
  FUNCTION_TABLE[(i1 & 7 | 0) + 10 | 0](i2 | 0)
 }
 
 function b1(i1, i2, i3) {
  i1 = i1 | 0;
  i2 = i2 | 0;
  i3 = i3 | 0;
  var wasm2asm_i32$0 = 0;
  topmost : {
   abort(1 | 0);
   wasm2asm_i32$0 = 0;
  }
  return wasm2asm_i32$0;
 }
 
 function stackRestore(i1) {
  i1 = i1 | 0;
  HEAP32[8 >> 2] = i1
 }
 
 function setTempRet0(i1) {
  i1 = i1 | 0;
  HEAP32[160 >> 2] = i1
 }
 
 function b0(i1) {
  i1 = i1 | 0;
  var wasm2asm_i32$0 = 0;
  topmost : {
   abort(0 | 0);
   wasm2asm_i32$0 = 0;
  }
  return wasm2asm_i32$0;
 }
 
 function ___unlockfile(i1) {
  i1 = i1 | 0;
  topmost : {
   break topmost;
  }
 }
 
 function ___lockfile(i1) {
  i1 = i1 | 0;
  return 0;
 }
 
 function getTempRet0() {
  return HEAPU32[160 >> 2] | 0;
 }
 
 function _main() {
  var wasm2asm_i32$0 = 0;
  topmost : {
   _puts(672 | 0) | 0;
   wasm2asm_i32$0 = 0;
  }
  return wasm2asm_i32$0;
 }
 
 function stackSave() {
  return HEAPU32[8 >> 2] | 0;
 }
 
 function b2(i1) {
  i1 = i1 | 0;
  abort(2 | 0)
 }
 
}

