import { setTempRet0 } from 'env';

function asmFunc(global, env, buffer) {
 var HEAP8 = new global.Int8Array(buffer);
 var HEAP16 = new global.Int16Array(buffer);
 var HEAP32 = new global.Int32Array(buffer);
 var HEAPU8 = new global.Uint8Array(buffer);
 var HEAPU16 = new global.Uint16Array(buffer);
 var HEAPU32 = new global.Uint32Array(buffer);
 var HEAPF32 = new global.Float32Array(buffer);
 var HEAPF64 = new global.Float64Array(buffer);
 var Math_imul = global.Math.imul;
 var Math_fround = global.Math.fround;
 var Math_abs = global.Math.abs;
 var Math_clz32 = global.Math.clz32;
 var Math_min = global.Math.min;
 var Math_max = global.Math.max;
 var Math_floor = global.Math.floor;
 var Math_ceil = global.Math.ceil;
 var Math_sqrt = global.Math.sqrt;
 var abort = env.abort;
 var nan = global.NaN;
 var infinity = global.Infinity;
 var setTempRet0 = env.setTempRet0;
 var i64toi32_i32$HIGH_BITS = 0;
 function dummy() {
  
 }
 
 function $1() {
  
 }
 
 function $2() {
  var $0 = 0;
  loop_in0 : while (1) {
   $0 = 7;
   break loop_in0;
  };
  return $0 | 0;
 }
 
 function $3() {
  var $2_1 = 0;
  loop_in : while (1) {
   dummy();
   dummy();
   dummy();
   dummy();
   break loop_in;
  };
  loop_in1 : while (1) {
   dummy();
   dummy();
   dummy();
   $2_1 = 8;
   break loop_in1;
  };
  return $2_1 | 0;
 }
 
 function $4() {
  var $2_1 = 0;
  loop_in : while (1) {
   loop_in2 : while (1) {
    dummy();
    break loop_in2;
   };
   loop_in3 : while (1) {
    dummy();
    $2_1 = 9;
    break loop_in3;
   };
   break loop_in;
  };
  return $2_1 | 0;
 }
 
 function $5() {
  var $2_1 = 0, $6_1 = 0, $10_1 = 0, $14_1 = 0, $18_1 = 0, $22 = 0, $26 = 0, $30 = 0, $34 = 0, $38 = 0, $42 = 0, $46 = 0, $50 = 0, $54 = 0, $58 = 0, $62 = 0, $66 = 0, $70 = 0, $74 = 0, $78 = 0, $82 = 0;
  loop_in : while (1) {
   loop_in4 : while (1) {
    loop_in6 : while (1) {
     loop_in8 : while (1) {
      loop_in10 : while (1) {
       loop_in12 : while (1) {
        loop_in14 : while (1) {
         loop_in16 : while (1) {
          loop_in18 : while (1) {
           loop_in20 : while (1) {
            loop_in22 : while (1) {
             loop_in24 : while (1) {
              loop_in26 : while (1) {
               loop_in28 : while (1) {
                loop_in30 : while (1) {
                 loop_in32 : while (1) {
                  loop_in34 : while (1) {
                   loop_in36 : while (1) {
                    loop_in38 : while (1) {
                     loop_in40 : while (1) {
                      loop_in42 : while (1) {
                       loop_in44 : while (1) {
                        dummy();
                        $2_1 = 150;
                        break loop_in44;
                       };
                       $6_1 = $2_1;
                       break loop_in42;
                      };
                      $10_1 = $6_1;
                      break loop_in40;
                     };
                     $14_1 = $10_1;
                     break loop_in38;
                    };
                    $18_1 = $14_1;
                    break loop_in36;
                   };
                   $22 = $18_1;
                   break loop_in34;
                  };
                  $26 = $22;
                  break loop_in32;
                 };
                 $30 = $26;
                 break loop_in30;
                };
                $34 = $30;
                break loop_in28;
               };
               $38 = $34;
               break loop_in26;
              };
              $42 = $38;
              break loop_in24;
             };
             $46 = $42;
             break loop_in22;
            };
            $50 = $46;
            break loop_in20;
           };
           $54 = $50;
           break loop_in18;
          };
          $58 = $54;
          break loop_in16;
         };
         $62 = $58;
         break loop_in14;
        };
        $66 = $62;
        break loop_in12;
       };
       $70 = $66;
       break loop_in10;
      };
      $74 = $70;
      break loop_in8;
     };
     $78 = $74;
     break loop_in6;
    };
    $82 = $78;
    break loop_in4;
   };
   break loop_in;
  };
  return $82 | 0;
 }
 
 function $6() {
  var $2_1 = 0;
  loop_in : while (1) {
   dummy();
   $2_1 = 13;
   break loop_in;
  };
  return __wasm_ctz_i32($2_1 | 0) | 0 | 0;
 }
 
 function $7() {
  var $2_1 = 0, $3_1 = 0, $6_1 = 0;
  loop_in : while (1) {
   dummy();
   $2_1 = 3;
   break loop_in;
  };
  $3_1 = $2_1;
  loop_in46 : while (1) {
   dummy();
   $6_1 = 4;
   break loop_in46;
  };
  return Math_imul($3_1, $6_1) | 0;
 }
 
 function $8() {
  var $2_1 = 0;
  loop_in : while (1) {
   dummy();
   $2_1 = 13;
   break loop_in;
  };
  return !$2_1 | 0;
 }
 
 function $9() {
  var $2_1 = Math_fround(0), $3_1 = Math_fround(0), $6_1 = Math_fround(0);
  loop_in : while (1) {
   dummy();
   $2_1 = Math_fround(3.0);
   break loop_in;
  };
  $3_1 = $2_1;
  loop_in47 : while (1) {
   dummy();
   $6_1 = Math_fround(3.0);
   break loop_in47;
  };
  return $3_1 > $6_1 | 0;
 }
 
 function $10() {
  block : {
   loop_in : while (1) break block;
  }
  block48 : {
   loop_in49 : while (1) {
    if (1) {
     break block48
    }
    abort();
   };
  }
  block50 : {
   loop_in51 : while (1) switch (0 | 0) {
   default:
    break block50;
   };
  }
  block52 : {
   loop_in53 : while (1) switch (1 | 0) {
   default:
    break block52;
   };
  }
  return 19 | 0;
 }
 
 function $11() {
  var $0 = 0, $1_1 = 0, $3_1 = 0;
  block : {
   loop_in : while (1) {
    $0 = 18;
    break block;
   };
  }
  return $0 | 0;
 }
 
 function $12() {
  var $0 = 0, $5_1 = 0, $7_1 = 0;
  block : {
   loop_in : while (1) {
    $0 = 18;
    break block;
   };
  }
  return $0 | 0;
 }
 
 function $13() {
  var $0 = 0, $1_1 = 0, $2_1 = 0, $5_1 = 0, $6_1 = 0, $9_1 = 0, $10_1 = 0, $12_1 = 0, $17_1 = 0, $18_1 = 0, $21 = 0, $22 = 0;
  $0 = 0;
  $1_1 = $0;
  block : {
   loop_in : while (1) block54 : {
    $2_1 = 1;
    break block;
   };
  }
  $0 = $1_1 + $2_1 | 0;
  $5_1 = $0;
  block55 : {
   loop_in56 : while (1) loop_in57 : while (1) {
    $6_1 = 2;
    break block55;
   };
  }
  $0 = $5_1 + $6_1 | 0;
  $9_1 = $0;
  loop_in59 : while (1) {
   block60 : {
    loop_in61 : while (1) {
     $10_1 = 4;
     break block60;
    };
   }
   $12_1 = $10_1;
   break loop_in59;
  };
  $0 = $9_1 + $12_1 | 0;
  $17_1 = $0;
  block62 : {
   loop_in63 : while (1) {
    $18_1 = 8;
    break block62;
   };
  }
  $0 = $17_1 + $18_1 | 0;
  $21 = $0;
  block64 : {
   loop_in65 : while (1) loop_in66 : while (1) {
    $22 = 16;
    break block64;
   };
  }
  $0 = $21 + $22 | 0;
  return $0 | 0;
 }
 
 function $14() {
  var $0 = 0, $1_1 = 0, $2_1 = 0, $3_1 = 0, $5_1 = 0;
  $0 = 0;
  $1_1 = $0;
  loop_in : while (1) loop_in67 : while (1) continue loop_in;
 }
 
 function fx() {
  var $0 = 0;
  block : {
   loop_in : while (1) {
    $0 = 1;
    $0 = Math_imul($0, 3);
    $0 = $0 - 5 | 0;
    $0 = Math_imul($0, 7);
    break block;
   };
  }
  return ($0 | 0) == (-14 | 0) | 0;
 }
 
 function $16($0, $0$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$0 = 0, $1$hi = 0, i64toi32_i32$5 = 0, i64toi32_i32$1 = 0, $1_1 = 0, i64toi32_i32$3 = 0;
  i64toi32_i32$0 = 0;
  $1_1 = 1;
  $1$hi = i64toi32_i32$0;
  block : {
   loop_in : while (1) {
    i64toi32_i32$0 = $0$hi;
    if (!($0 | i64toi32_i32$0 | 0)) {
     break block
    }
    i64toi32_i32$0 = $0$hi;
    i64toi32_i32$0 = $1$hi;
    i64toi32_i32$0 = $0$hi;
    i64toi32_i32$1 = $1$hi;
    i64toi32_i32$1 = __wasm_i64_mul($0 | 0, i64toi32_i32$0 | 0, $1_1 | 0, $1$hi | 0) | 0;
    i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
    $1_1 = i64toi32_i32$1;
    $1$hi = i64toi32_i32$0;
    i64toi32_i32$0 = $0$hi;
    i64toi32_i32$1 = 0;
    i64toi32_i32$3 = 1;
    i64toi32_i32$5 = ($0 >>> 0 < i64toi32_i32$3 >>> 0) + i64toi32_i32$1 | 0;
    i64toi32_i32$5 = i64toi32_i32$0 - i64toi32_i32$5 | 0;
    $0 = $0 - i64toi32_i32$3 | 0;
    $0$hi = i64toi32_i32$5;
    continue loop_in;
   };
  }
  i64toi32_i32$5 = $1$hi;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$5;
  return $1_1 | 0;
 }
 
 function $17($0, $0$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$0 = 0, $1$hi = 0, $2$hi = 0, i64toi32_i32$1 = 0, $2_1 = 0, i64toi32_i32$5 = 0, $1_1 = 0, i64toi32_i32$4 = 0;
  i64toi32_i32$0 = 0;
  $1_1 = 1;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  $2_1 = 2;
  $2$hi = i64toi32_i32$0;
  block : {
   loop_in : while (1) {
    i64toi32_i32$0 = $2$hi;
    i64toi32_i32$0 = $0$hi;
    i64toi32_i32$0 = $2$hi;
    i64toi32_i32$1 = $0$hi;
    if (i64toi32_i32$0 >>> 0 > i64toi32_i32$1 >>> 0 | ((i64toi32_i32$0 | 0) == (i64toi32_i32$1 | 0) & $2_1 >>> 0 > $0 >>> 0 | 0) | 0) {
     break block
    }
    i64toi32_i32$0 = $2$hi;
    i64toi32_i32$0 = __wasm_i64_mul($1_1 | 0, $1$hi | 0, $2_1 | 0, i64toi32_i32$0 | 0) | 0;
    $1_1 = i64toi32_i32$0;
    $1$hi = i64toi32_i32$HIGH_BITS;
    i64toi32_i32$0 = 0;
    i64toi32_i32$1 = 1;
    i64toi32_i32$4 = $2_1 + i64toi32_i32$1 | 0;
    i64toi32_i32$5 = $2$hi + i64toi32_i32$0 | 0;
    if (i64toi32_i32$4 >>> 0 < i64toi32_i32$1 >>> 0) {
     i64toi32_i32$5 = i64toi32_i32$5 + 1 | 0
    }
    $2_1 = i64toi32_i32$4;
    $2$hi = i64toi32_i32$5;
    continue loop_in;
   };
  }
  i64toi32_i32$5 = $1$hi;
  i64toi32_i32$HIGH_BITS = $1$hi;
  return $1_1 | 0;
 }
 
 function $18($0, $1_1) {
  $0 = Math_fround($0);
  $1_1 = Math_fround($1_1);
  var $2_1 = Math_fround(0), $3_1 = Math_fround(0);
  block : {
   loop_in : while (1) {
    if ($0 == Math_fround(0.0)) {
     break block
    }
    $2_1 = $1_1;
    block71 : {
     loop_in72 : while (1) {
      if ($2_1 == Math_fround(0.0)) {
       break block71
      }
      if ($2_1 < Math_fround(0.0)) {
       break block
      }
      $3_1 = Math_fround($3_1 + $2_1);
      $2_1 = Math_fround($2_1 - Math_fround(2.0));
      continue loop_in72;
     };
    }
    $3_1 = Math_fround($3_1 / $0);
    $0 = Math_fround($0 - Math_fround(1.0));
    continue loop_in;
   };
  }
  return Math_fround($3_1);
 }
 
 function legalstub$16($0, $1_1) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $12_1 = 0, $13_1 = 0, $4_1 = 0, $4$hi = 0, $7$hi = 0, $2_1 = 0, $2$hi = 0;
  i64toi32_i32$0 = 0;
  $4_1 = $0;
  $4$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $12_1 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $12_1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $7$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $4$hi;
  i64toi32_i32$0 = $4_1;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$3 = $12_1;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$2 = $16(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $2_1 = i64toi32_i32$2;
  $2$hi = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $13_1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $13_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$1 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($13_1 | 0);
  i64toi32_i32$2 = $2$hi;
  return $2_1 | 0;
 }
 
 function legalstub$17($0, $1_1) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  var i64toi32_i32$2 = 0, i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0, $12_1 = 0, $13_1 = 0, $4_1 = 0, $4$hi = 0, $7$hi = 0, $2_1 = 0, $2$hi = 0;
  i64toi32_i32$0 = 0;
  $4_1 = $0;
  $4$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$2 = $1_1;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
   $12_1 = 0;
  } else {
   i64toi32_i32$1 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$2 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$0 << i64toi32_i32$4 | 0) | 0;
   $12_1 = i64toi32_i32$2 << i64toi32_i32$4 | 0;
  }
  $7$hi = i64toi32_i32$1;
  i64toi32_i32$1 = $4$hi;
  i64toi32_i32$0 = $4_1;
  i64toi32_i32$2 = $7$hi;
  i64toi32_i32$3 = $12_1;
  i64toi32_i32$2 = i64toi32_i32$1 | i64toi32_i32$2 | 0;
  i64toi32_i32$2 = $17(i64toi32_i32$0 | i64toi32_i32$3 | 0 | 0, i64toi32_i32$2 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  $2_1 = i64toi32_i32$2;
  $2$hi = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$2;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $13_1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $13_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$1 >>> i64toi32_i32$4 | 0) | 0;
  }
  setTempRet0($13_1 | 0);
  i64toi32_i32$2 = $2$hi;
  return $2_1 | 0;
 }
 
 function _ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$4 = 0, i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, var$2 = 0, i64toi32_i32$2 = 0, i64toi32_i32$3 = 0, var$3 = 0, var$4 = 0, var$5 = 0, $21 = 0, $22 = 0, var$6 = 0, $24 = 0, $17_1 = 0, $18_1 = 0, $23 = 0, $29 = 0, $45 = 0, $56$hi = 0, $62$hi = 0;
  i64toi32_i32$0 = var$1$hi;
  var$2 = var$1;
  var$4 = var$2 >>> 16 | 0;
  i64toi32_i32$0 = var$0$hi;
  var$3 = var$0;
  var$5 = var$3 >>> 16 | 0;
  $17_1 = Math_imul(var$4, var$5);
  $18_1 = var$2;
  i64toi32_i32$2 = var$3;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = 0;
   $21 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $21 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  $23 = $17_1 + Math_imul($18_1, $21) | 0;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$0 = var$1;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $22 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $22 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$0 >>> i64toi32_i32$4 | 0) | 0;
  }
  $29 = $23 + Math_imul($22, var$3) | 0;
  var$2 = var$2 & 65535 | 0;
  var$3 = var$3 & 65535 | 0;
  var$6 = Math_imul(var$2, var$3);
  var$2 = (var$6 >>> 16 | 0) + Math_imul(var$2, var$5) | 0;
  $45 = $29 + (var$2 >>> 16 | 0) | 0;
  var$2 = (var$2 & 65535 | 0) + Math_imul(var$4, var$3) | 0;
  i64toi32_i32$2 = 0;
  i64toi32_i32$1 = $45 + (var$2 >>> 16 | 0) | 0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = i64toi32_i32$1 << i64toi32_i32$4 | 0;
   $24 = 0;
  } else {
   i64toi32_i32$0 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$1 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$2 << i64toi32_i32$4 | 0) | 0;
   $24 = i64toi32_i32$1 << i64toi32_i32$4 | 0;
  }
  $56$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  $62$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $56$hi;
  i64toi32_i32$2 = $24;
  i64toi32_i32$1 = $62$hi;
  i64toi32_i32$3 = var$2 << 16 | 0 | (var$6 & 65535 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$0 | i64toi32_i32$1 | 0;
  i64toi32_i32$2 = i64toi32_i32$2 | i64toi32_i32$3 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$2 | 0;
 }
 
 function __wasm_ctz_i32(var$0) {
  var$0 = var$0 | 0;
  if (var$0) {
   return 31 - Math_clz32((var$0 + -1 | 0) ^ var$0 | 0) | 0 | 0
  }
  return 32 | 0;
 }
 
 function __wasm_i64_mul(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = _ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE(var$0 | 0, i64toi32_i32$0 | 0, var$1 | 0, i64toi32_i32$1 | 0) | 0;
  i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "empty": $1, 
  "singular": $2, 
  "multi": $3, 
  "nested": $4, 
  "deep": $5, 
  "as_unary_operand": $6, 
  "as_binary_operand": $7, 
  "as_test_operand": $8, 
  "as_compare_operand": $9, 
  "break_bare": $10, 
  "break_value": $11, 
  "break_repeated": $12, 
  "break_inner": $13, 
  "cont_inner": $14, 
  "effects": fx, 
  "while_": legalstub$16, 
  "for_": legalstub$17, 
  "nesting": $18
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0},memasmFunc);
export var empty = retasmFunc.empty;
export var singular = retasmFunc.singular;
export var multi = retasmFunc.multi;
export var nested = retasmFunc.nested;
export var deep = retasmFunc.deep;
export var as_unary_operand = retasmFunc.as_unary_operand;
export var as_binary_operand = retasmFunc.as_binary_operand;
export var as_test_operand = retasmFunc.as_test_operand;
export var as_compare_operand = retasmFunc.as_compare_operand;
export var break_bare = retasmFunc.break_bare;
export var break_value = retasmFunc.break_value;
export var break_repeated = retasmFunc.break_repeated;
export var break_inner = retasmFunc.break_inner;
export var cont_inner = retasmFunc.cont_inner;
export var effects = retasmFunc.effects;
export var while_ = retasmFunc.while_;
export var for_ = retasmFunc.for_;
export var nesting = retasmFunc.nesting;
