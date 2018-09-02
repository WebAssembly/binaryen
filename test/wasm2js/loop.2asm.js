function asmFunc(global, env, buffer) {
 "almost asm";
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
 var i64toi32_i32$HIGH_BITS = 0;
 function dummy() {
  
 }
 
 function $1() {
  
 }
 
 function $2() {
  var $0 = 0;
  loop_in0 : do {
   $0 = 7;
   break loop_in0;
  } while (1);
  return $0 | 0;
 }
 
 function $3() {
  var $2_1 = 0;
  loop_in : do {
   dummy();
   dummy();
   dummy();
   dummy();
   break loop_in;
  } while (1);
  loop_in1 : do {
   dummy();
   dummy();
   dummy();
   $2_1 = 8;
   break loop_in1;
  } while (1);
  return $2_1 | 0;
 }
 
 function $4() {
  var $2_1 = 0;
  loop_in : do {
   loop_in2 : do {
    dummy();
    break loop_in2;
   } while (1);
   loop_in3 : do {
    dummy();
    $2_1 = 9;
    break loop_in3;
   } while (1);
   break loop_in;
  } while (1);
  return $2_1 | 0;
 }
 
 function $5() {
  var $74 = 0, $2_1 = 0, $6_1 = 0, $10_1 = 0, $14_1 = 0, $18 = 0, $22_1 = 0, $26_1 = 0, $30_1 = 0, $34_1 = 0, $38 = 0, $42 = 0, $46 = 0, $50 = 0, $54 = 0, $58 = 0, $62 = 0, $66 = 0, $70 = 0;
  loop_in : do {
   loop_in4 : do {
    loop_in6 : do {
     loop_in8 : do {
      loop_in10 : do {
       loop_in12 : do {
        loop_in14 : do {
         loop_in16 : do {
          loop_in18 : do {
           loop_in20 : do {
            loop_in22 : do {
             loop_in24 : do {
              loop_in26 : do {
               loop_in28 : do {
                loop_in30 : do {
                 loop_in32 : do {
                  loop_in34 : do {
                   loop_in36 : do {
                    loop_in38 : do {
                     loop_in40 : do {
                      dummy();
                      $2_1 = 150;
                      break loop_in40;
                     } while (1);
                     $6_1 = $2_1;
                     break loop_in38;
                    } while (1);
                    $10_1 = $6_1;
                    break loop_in36;
                   } while (1);
                   $14_1 = $10_1;
                   break loop_in34;
                  } while (1);
                  $18 = $14_1;
                  break loop_in32;
                 } while (1);
                 $22_1 = $18;
                 break loop_in30;
                } while (1);
                $26_1 = $22_1;
                break loop_in28;
               } while (1);
               $30_1 = $26_1;
               break loop_in26;
              } while (1);
              $34_1 = $30_1;
              break loop_in24;
             } while (1);
             $38 = $34_1;
             break loop_in22;
            } while (1);
            $42 = $38;
            break loop_in20;
           } while (1);
           $46 = $42;
           break loop_in18;
          } while (1);
          $50 = $46;
          break loop_in16;
         } while (1);
         $54 = $50;
         break loop_in14;
        } while (1);
        $58 = $54;
        break loop_in12;
       } while (1);
       $62 = $58;
       break loop_in10;
      } while (1);
      $66 = $62;
      break loop_in8;
     } while (1);
     $70 = $66;
     break loop_in6;
    } while (1);
    $74 = $70;
    break loop_in4;
   } while (1);
   break loop_in;
  } while (1);
  return $74 | 0;
 }
 
 function $6() {
  var $0 = 0, wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0;
  loop_in : do {
   $0 = 1;
   break loop_in;
  } while (1);
  return (wasm2js_i32$0 = $0, wasm2js_i32$1 = 2, wasm2js_i32$2 = 3, wasm2js_i32$2 ? wasm2js_i32$0 : wasm2js_i32$1) | 0;
 }
 
 function $7() {
  var $0 = 0, wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0;
  loop_in : do {
   $0 = 1;
   break loop_in;
  } while (1);
  return (wasm2js_i32$0 = 2, wasm2js_i32$1 = $0, wasm2js_i32$2 = 3, wasm2js_i32$2 ? wasm2js_i32$0 : wasm2js_i32$1) | 0;
 }
 
 function $8() {
  var $0 = 0, wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0;
  loop_in : do {
   $0 = 1;
   break loop_in;
  } while (1);
  return (wasm2js_i32$0 = 2, wasm2js_i32$1 = 3, wasm2js_i32$2 = $0, wasm2js_i32$2 ? wasm2js_i32$0 : wasm2js_i32$1) | 0;
 }
 
 function $9() {
  var $6_1 = 0, $0 = 0;
  loop_in : do {
   $0 = 1;
   break loop_in;
  } while (1);
  $6_1 = $0;
  return $6_1 | 0;
 }
 
 function $10() {
  var $6_1 = 0, $2_1 = 0;
  $6_1 = 2;
  return $6_1 | 0;
 }
 
 function $11() {
  var $2_1 = 0, $0 = 0;
  block : {
   loop_in : do {
    $0 = 1;
    break loop_in;
   } while (1);
   $2_1 = $0;
   if (2) break block;
   $2_1 = $2_1;
  };
  return $2_1 | 0;
 }
 
 function $12() {
  var $2_1 = 0, $0 = 0;
  block : {
   loop_in : do {
    $0 = 1;
    break loop_in;
   } while (1);
   $2_1 = 2;
   if ($0) break block;
   $2_1 = $2_1;
  };
  return $2_1 | 0;
 }
 
 function func($0, $1_1) {
  $0 = $0 | 0;
  $1_1 = $1_1 | 0;
  return $0 | 0;
 }
 
 function $14() {
  var $0 = 0, wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0, wasm2js_i32$3 = 0;
  loop_in : do {
   $0 = 1;
   break loop_in;
  } while (1);
  wasm2js_i32$2 = $0;
  wasm2js_i32$3 = 2;
  wasm2js_i32$1 = 0;
  wasm2js_i32$0 = FUNCTION_TABLE_iii[wasm2js_i32$1 & 0](wasm2js_i32$2 | 0, wasm2js_i32$3 | 0) | 0;
  return wasm2js_i32$0 | 0;
 }
 
 function $15() {
  var $0 = 0, wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0, wasm2js_i32$3 = 0;
  loop_in : do {
   $0 = 1;
   break loop_in;
  } while (1);
  wasm2js_i32$2 = 2;
  wasm2js_i32$3 = $0;
  wasm2js_i32$1 = 0;
  wasm2js_i32$0 = FUNCTION_TABLE_iii[wasm2js_i32$1 & 0](wasm2js_i32$2 | 0, wasm2js_i32$3 | 0) | 0;
  return wasm2js_i32$0 | 0;
 }
 
 function $16() {
  var $0 = 0, wasm2js_i32$0 = 0, wasm2js_i32$1 = 0, wasm2js_i32$2 = 0, wasm2js_i32$3 = 0;
  loop_in : do {
   $0 = 0;
   break loop_in;
  } while (1);
  wasm2js_i32$2 = 1;
  wasm2js_i32$3 = 2;
  wasm2js_i32$1 = $0;
  wasm2js_i32$0 = FUNCTION_TABLE_iii[wasm2js_i32$1 & 0](wasm2js_i32$2 | 0, wasm2js_i32$3 | 0) | 0;
  return wasm2js_i32$0 | 0;
 }
 
 function $17() {
  var $0 = 0;
  loop_in : do {
   $0 = 1;
   break loop_in;
  } while (1);
  return __wasm_memory_grow($0 | 0) | 0;
 }
 
 function f($0) {
  $0 = $0 | 0;
  return $0 | 0;
 }
 
 function $19() {
  var $0 = 0;
  loop_in : do {
   $0 = 1;
   break loop_in;
  } while (1);
  return f($0 | 0) | 0 | 0;
 }
 
 function $20() {
  var $0 = 0;
  loop_in : do {
   $0 = 1;
   break loop_in;
  } while (1);
 }
 
 function $21() {
  var $0 = 0, $2_1 = 0;
  block : {
   loop_in : do {
    $0 = 1;
    break loop_in;
   } while (1);
   $2_1 = $0;
   break block;
  };
  return $2_1 | 0;
 }
 
 function $22() {
  var $1_1 = 0;
  loop_in : do {
   $1_1 = 1;
   break loop_in;
  } while (1);
  return $1_1 | 0;
 }
 
 function $23() {
  var $0 = 0;
  loop_in : do {
   $0 = 1;
   break loop_in;
  } while (1);
  return HEAPU32[$0 >> 2] | 0 | 0;
 }
 
 function $24() {
  var $2_1 = 0;
  loop_in : do {
   dummy();
   $2_1 = 13;
   break loop_in;
  } while (1);
  return __wasm_ctz_i32($2_1 | 0) | 0 | 0;
 }
 
 function $25() {
  var $2_1 = 0, $3_1 = 0, $6_1 = 0;
  loop_in : do {
   dummy();
   $2_1 = 3;
   break loop_in;
  } while (1);
  $3_1 = $2_1;
  loop_in42 : do {
   dummy();
   $6_1 = 4;
   break loop_in42;
  } while (1);
  return Math_imul($3_1, $6_1) | 0;
 }
 
 function $26() {
  var $2_1 = 0;
  loop_in : do {
   dummy();
   $2_1 = 13;
   break loop_in;
  } while (1);
  return ($2_1 | 0) == (0 | 0) | 0;
 }
 
 function $27() {
  var $2_1 = Math_fround(0), $3_1 = Math_fround(0), $6_1 = Math_fround(0);
  loop_in : do {
   dummy();
   $2_1 = Math_fround(3.0);
   break loop_in;
  } while (1);
  $3_1 = $2_1;
  loop_in43 : do {
   dummy();
   $6_1 = Math_fround(3.0);
   break loop_in43;
  } while (1);
  return $3_1 > $6_1 | 0;
 }
 
 function $28() {
  block : {
   loop_in : do {
    break block;
    break loop_in;
   } while (1);
  };
  block44 : {
   loop_in45 : do {
    if (1) break block44;
    abort();
    break loop_in45;
   } while (1);
  };
  block46 : {
   loop_in47 : do {
    switch (0 | 0) {
    default:
     break block46;
    };
    break loop_in47;
   } while (1);
  };
  block48 : {
   loop_in49 : do {
    switch (1 | 0) {
    case 0:
     break block48;
    case 1:
     break block48;
    default:
     break block48;
    };
    break loop_in49;
   } while (1);
  };
  return 19 | 0;
 }
 
 function $29() {
  var $0 = 0, $1_1 = 0, $3_1 = 0;
  block : {
   loop_in : do {
    $0 = 18;
    break block;
    break loop_in;
   } while (1);
  };
  return $0 | 0;
 }
 
 function $30() {
  var $0 = 0, $5_1 = 0, $7_1 = 0;
  block : {
   loop_in : do {
    $0 = 18;
    break block;
    break loop_in;
   } while (1);
  };
  return $0 | 0;
 }
 
 function $31() {
  var $0 = 0, $1_1 = 0, $2_1 = 0, $5_1 = 0, $6_1 = 0, $9_1 = 0, $10_1 = 0, $12_1 = 0, $17_1 = 0, $18 = 0, $21_1 = 0, $22_1 = 0;
  $0 = 0;
  $1_1 = $0;
  block : {
   loop_in : do {
    block50 : {
     $2_1 = 1;
     break block;
    };
    break loop_in;
   } while (1);
  };
  $0 = $1_1 + $2_1 | 0;
  $5_1 = $0;
  block51 : {
   loop_in52 : do {
    loop_in53 : do {
     $6_1 = 2;
     break block51;
     break loop_in53;
    } while (1);
    break loop_in52;
   } while (1);
  };
  $0 = $5_1 + $6_1 | 0;
  $9_1 = $0;
  loop_in55 : do {
   block56 : {
    loop_in57 : do {
     $10_1 = 4;
     break block56;
     break loop_in57;
    } while (1);
   };
   $12_1 = $10_1;
   break loop_in55;
  } while (1);
  $0 = $9_1 + $12_1 | 0;
  $17_1 = $0;
  block58 : {
   loop_in59 : do {
    $18 = 8;
    break block58;
    break loop_in59;
   } while (1);
  };
  $0 = $17_1 + $18 | 0;
  $21_1 = $0;
  block60 : {
   loop_in61 : do {
    loop_in62 : do {
     $22_1 = 16;
     break block60;
     break loop_in62;
    } while (1);
    break loop_in61;
   } while (1);
  };
  $0 = $21_1 + $22_1 | 0;
  return $0 | 0;
 }
 
 function $32() {
  var $0 = 0, $1_1 = 0, $6_1 = 0, $2_1 = 0, $7_1 = 0, $3_1 = 0, $8_1 = 0, $5_1 = 0, wasm2js_i32$0 = 0;
  $0 = 0;
  $1_1 = $0;
  loop_in : do {
   loop_in63 : do {
    continue loop_in;
    break loop_in63;
   } while (1);
   break loop_in;
  } while (1);
  return wasm2js_i32$0 | 0;
 }
 
 function fx() {
  var $0 = 0;
  block : {
   loop_in : do {
    $0 = 1;
    $0 = Math_imul($0, 3);
    $0 = $0 - 5 | 0;
    $0 = Math_imul($0, 7);
    break block;
    break loop_in;
   } while (1);
  };
  return ($0 | 0) == (4294967282 | 0) | 0;
 }
 
 function $34($0, $0$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$5 = 0, $1$hi = 0, $1_1 = 0, i64toi32_i32$1 = 0, i64toi32_i32$3 = 0;
  i64toi32_i32$0 = 0;
  $1_1 = 1;
  $1$hi = i64toi32_i32$0;
  block : {
   loop_in : do {
    i64toi32_i32$0 = $0$hi;
    i64toi32_i32$0 = i64toi32_i32$0;
    if (($0 | i64toi32_i32$0 | 0 | 0) == (0 | 0)) break block;
    i64toi32_i32$0 = $0$hi;
    i64toi32_i32$0 = $1$hi;
    i64toi32_i32$0 = $0$hi;
    i64toi32_i32$1 = $1$hi;
    i64toi32_i32$1 = __wasm_i64_mul($0 | 0, i64toi32_i32$0 | 0, $1_1 | 0, $1$hi | 0) | 0;
    i64toi32_i32$0 = i64toi32_i32$HIGH_BITS;
    i64toi32_i32$0 = i64toi32_i32$0;
    $1_1 = i64toi32_i32$1;
    $1$hi = i64toi32_i32$0;
    i64toi32_i32$0 = $0$hi;
    i64toi32_i32$0 = i64toi32_i32$0;
    i64toi32_i32$1 = 0;
    i64toi32_i32$3 = 1;
    i64toi32_i32$5 = ($0 >>> 0 < i64toi32_i32$3 >>> 0) + i64toi32_i32$1 | 0;
    i64toi32_i32$5 = i64toi32_i32$0 - i64toi32_i32$5 | 0;
    i64toi32_i32$5 = i64toi32_i32$5;
    $0 = $0 - i64toi32_i32$3 | 0;
    $0$hi = i64toi32_i32$5;
    continue loop_in;
    break loop_in;
   } while (1);
  };
  i64toi32_i32$5 = $1$hi;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$5;
  return $1_1 | 0;
 }
 
 function $35($0, $0$hi) {
  $0 = $0 | 0;
  $0$hi = $0$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$2 = 0, i64toi32_i32$5 = 0, $2$hi = 0, $2_1 = 0, i64toi32_i32$1 = 0, $1_1 = 0, $1$hi = 0, i64toi32_i32$4 = 0;
  i64toi32_i32$0 = 0;
  $1_1 = 1;
  $1$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  $2_1 = 2;
  $2$hi = i64toi32_i32$0;
  block : {
   loop_in : do {
    i64toi32_i32$0 = $2$hi;
    i64toi32_i32$0 = $0$hi;
    i64toi32_i32$0 = $2$hi;
    i64toi32_i32$2 = $2_1;
    i64toi32_i32$1 = $0$hi;
    if (i64toi32_i32$0 >>> 0 > i64toi32_i32$1 >>> 0 | ((i64toi32_i32$0 | 0) == (i64toi32_i32$1 | 0) & i64toi32_i32$2 >>> 0 > $0 >>> 0 | 0) | 0) break block;
    i64toi32_i32$2 = $1$hi;
    i64toi32_i32$2 = $2$hi;
    i64toi32_i32$2 = $1$hi;
    i64toi32_i32$0 = $2$hi;
    i64toi32_i32$0 = __wasm_i64_mul($1_1 | 0, i64toi32_i32$2 | 0, $2_1 | 0, i64toi32_i32$0 | 0) | 0;
    i64toi32_i32$2 = i64toi32_i32$HIGH_BITS;
    i64toi32_i32$2 = i64toi32_i32$2;
    $1_1 = i64toi32_i32$0;
    $1$hi = i64toi32_i32$2;
    i64toi32_i32$2 = $2$hi;
    i64toi32_i32$2 = i64toi32_i32$2;
    i64toi32_i32$0 = 0;
    i64toi32_i32$1 = 1;
    i64toi32_i32$4 = $2_1 + i64toi32_i32$1 | 0;
    i64toi32_i32$5 = i64toi32_i32$2 + i64toi32_i32$0 | 0;
    if (i64toi32_i32$4 >>> 0 < i64toi32_i32$1 >>> 0) i64toi32_i32$5 = i64toi32_i32$5 + 1 | 0;
    i64toi32_i32$5 = i64toi32_i32$5;
    $2_1 = i64toi32_i32$4;
    $2$hi = i64toi32_i32$5;
    continue loop_in;
    break loop_in;
   } while (1);
  };
  i64toi32_i32$5 = $1$hi;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$5 = i64toi32_i32$5;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$5;
  return $1_1 | 0;
 }
 
 function $36($0, $1_1) {
  $0 = Math_fround($0);
  $1_1 = Math_fround($1_1);
  var $2_1 = Math_fround(0), $3_1 = Math_fround(0);
  block : {
   loop_in : do {
    if ($0 == Math_fround(0.0)) break block;
    $2_1 = $1_1;
    block67 : {
     loop_in68 : do {
      if ($2_1 == Math_fround(0.0)) break block67;
      if ($2_1 < Math_fround(0.0)) break block;
      $3_1 = Math_fround($3_1 + $2_1);
      $2_1 = Math_fround($2_1 - Math_fround(2.0));
      continue loop_in68;
      break loop_in68;
     } while (1);
    };
    $3_1 = Math_fround($3_1 / $0);
    $0 = Math_fround($0 - Math_fround(1.0));
    continue loop_in;
    break loop_in;
   } while (1);
  };
  return Math_fround($3_1);
 }
 
 function _ZN17compiler_builtins3int3mul3Mul3mul17h070e9a1c69faec5bE(var$0, var$0$hi, var$1, var$1$hi) {
  var$0 = var$0 | 0;
  var$0$hi = var$0$hi | 0;
  var$1 = var$1 | 0;
  var$1$hi = var$1$hi | 0;
  var i64toi32_i32$0 = 0, i64toi32_i32$1 = 0, i64toi32_i32$4 = 0, i64toi32_i32$2 = 0, var$2 = 0, i64toi32_i32$3 = 0, var$3 = 0, var$4 = 0, var$5 = 0, $21_1 = 0, $22_1 = 0, var$6 = 0, $24_1 = 0, $17_1 = 0, $18 = 0, $23_1 = 0, $29_1 = 0, $45 = 0, $56$hi = 0, $62$hi = 0;
  i64toi32_i32$0 = var$1$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  var$2 = var$1;
  var$4 = var$2 >>> 16 | 0;
  i64toi32_i32$0 = var$0$hi;
  i64toi32_i32$0 = i64toi32_i32$0;
  var$3 = var$0;
  var$5 = var$3 >>> 16 | 0;
  $17_1 = Math_imul(var$4, var$5);
  $18 = var$2;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$2 = var$3;
  i64toi32_i32$1 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$1 = 0;
   $21_1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$1 = i64toi32_i32$0 >>> i64toi32_i32$4 | 0;
   $21_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$0 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$2 >>> i64toi32_i32$4 | 0) | 0;
  }
  i64toi32_i32$1 = i64toi32_i32$1;
  $23_1 = $17_1 + Math_imul($18, $21_1) | 0;
  i64toi32_i32$1 = var$1$hi;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$0 = var$1;
  i64toi32_i32$2 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$2 = 0;
   $22_1 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
  } else {
   i64toi32_i32$2 = i64toi32_i32$1 >>> i64toi32_i32$4 | 0;
   $22_1 = (((1 << i64toi32_i32$4 | 0) - 1 | 0) & i64toi32_i32$1 | 0) << (32 - i64toi32_i32$4 | 0) | 0 | (i64toi32_i32$0 >>> i64toi32_i32$4 | 0) | 0;
  }
  i64toi32_i32$2 = i64toi32_i32$2;
  $29_1 = $23_1 + Math_imul($22_1, var$3) | 0;
  var$2 = var$2 & 65535 | 0;
  var$3 = var$3 & 65535 | 0;
  var$6 = Math_imul(var$2, var$3);
  var$2 = (var$6 >>> 16 | 0) + Math_imul(var$2, var$5) | 0;
  $45 = $29_1 + (var$2 >>> 16 | 0) | 0;
  var$2 = (var$2 & 65535 | 0) + Math_imul(var$4, var$3) | 0;
  i64toi32_i32$2 = 0;
  i64toi32_i32$2 = i64toi32_i32$2;
  i64toi32_i32$1 = $45 + (var$2 >>> 16 | 0) | 0;
  i64toi32_i32$0 = 0;
  i64toi32_i32$3 = 32;
  i64toi32_i32$4 = i64toi32_i32$3 & 31 | 0;
  if (32 >>> 0 <= (i64toi32_i32$3 & 63 | 0) >>> 0) {
   i64toi32_i32$0 = i64toi32_i32$1 << i64toi32_i32$4 | 0;
   $24_1 = 0;
  } else {
   i64toi32_i32$0 = ((1 << i64toi32_i32$4 | 0) - 1 | 0) & (i64toi32_i32$1 >>> (32 - i64toi32_i32$4 | 0) | 0) | 0 | (i64toi32_i32$2 << i64toi32_i32$4 | 0) | 0;
   $24_1 = i64toi32_i32$1 << i64toi32_i32$4 | 0;
  }
  $56$hi = i64toi32_i32$0;
  i64toi32_i32$0 = 0;
  $62$hi = i64toi32_i32$0;
  i64toi32_i32$0 = $56$hi;
  i64toi32_i32$2 = $24_1;
  i64toi32_i32$1 = $62$hi;
  i64toi32_i32$3 = var$2 << 16 | 0 | (var$6 & 65535 | 0) | 0;
  i64toi32_i32$1 = i64toi32_i32$0 | i64toi32_i32$1 | 0;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$2 = i64toi32_i32$2 | i64toi32_i32$3 | 0;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$1;
  return i64toi32_i32$2 | 0;
 }
 
 function __wasm_ctz_i32(var$0) {
  var$0 = var$0 | 0;
  if (var$0) return 31 - Math_clz32((var$0 + 4294967295 | 0) ^ var$0 | 0) | 0 | 0;
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
  i64toi32_i32$0 = i64toi32_i32$0;
  i64toi32_i32$1 = i64toi32_i32$1;
  i64toi32_i32$HIGH_BITS = i64toi32_i32$0;
  return i64toi32_i32$1 | 0;
 }
 
 var FUNCTION_TABLE_iii = [func];
 function __wasm_memory_grow(pagesToAdd) {
  pagesToAdd = pagesToAdd | 0;
  var oldPages = __wasm_memory_size() | 0;
  var newPages = oldPages + pagesToAdd | 0;
  if ((oldPages < newPages) && (newPages < 65535)) {
   var newBuffer = new ArrayBuffer(Math_imul(newPages, 65536));
   var newHEAP8 = new global.Int8Array(newBuffer);
   newHEAP8.set(HEAP8);
   HEAP8 = newHEAP8;
   HEAP16 = new global.Int16Array(newBuffer);
   HEAP32 = new global.Int32Array(newBuffer);
   HEAPU8 = new global.Uint8Array(newBuffer);
   HEAPU16 = new global.Uint16Array(newBuffer);
   HEAPU32 = new global.Uint32Array(newBuffer);
   HEAPF32 = new global.Float32Array(newBuffer);
   HEAPF64 = new global.Float64Array(newBuffer);
   buffer = newBuffer;
  }
  return oldPages;
 }
 
 function __wasm_memory_size() {
  return buffer.byteLength / 65536 | 0;
 }
 
 return {
  empty: $1, 
  singular: $2, 
  multi: $3, 
  nested: $4, 
  deep: $5, 
  as_select_first: $6, 
  as_select_mid: $7, 
  as_select_last: $8, 
  as_if_then: $9, 
  as_if_else: $10, 
  as_br_if_first: $11, 
  as_br_if_last: $12, 
  as_call_indirect_first: $14, 
  as_call_indirect_mid: $15, 
  as_call_indirect_last: $16, 
  as_memory_grow_value: $17, 
  as_call_value: $19, 
  as_drop_operand: $20, 
  as_br_value: $21, 
  as_set_local_value: $22, 
  as_load_operand: $23, 
  as_unary_operand: $24, 
  as_binary_operand: $25, 
  as_test_operand: $26, 
  as_compare_operand: $27, 
  break_bare: $28, 
  break_value: $29, 
  break_repeated: $30, 
  break_inner: $31, 
  cont_inner: $32, 
  effects: fx, 
  while_: $34, 
  for_: $35, 
  nesting: $36
 };
}

const memasmFunc = new ArrayBuffer(65536);
const retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); }},memasmFunc);
export const empty = retasmFunc.empty;
export const singular = retasmFunc.singular;
export const multi = retasmFunc.multi;
export const nested = retasmFunc.nested;
export const deep = retasmFunc.deep;
export const as_select_first = retasmFunc.as_select_first;
export const as_select_mid = retasmFunc.as_select_mid;
export const as_select_last = retasmFunc.as_select_last;
export const as_if_then = retasmFunc.as_if_then;
export const as_if_else = retasmFunc.as_if_else;
export const as_br_if_first = retasmFunc.as_br_if_first;
export const as_br_if_last = retasmFunc.as_br_if_last;
export const as_call_indirect_first = retasmFunc.as_call_indirect_first;
export const as_call_indirect_mid = retasmFunc.as_call_indirect_mid;
export const as_call_indirect_last = retasmFunc.as_call_indirect_last;
export const as_memory_grow_value = retasmFunc.as_memory_grow_value;
export const as_call_value = retasmFunc.as_call_value;
export const as_drop_operand = retasmFunc.as_drop_operand;
export const as_br_value = retasmFunc.as_br_value;
export const as_set_local_value = retasmFunc.as_set_local_value;
export const as_load_operand = retasmFunc.as_load_operand;
export const as_unary_operand = retasmFunc.as_unary_operand;
export const as_binary_operand = retasmFunc.as_binary_operand;
export const as_test_operand = retasmFunc.as_test_operand;
export const as_compare_operand = retasmFunc.as_compare_operand;
export const break_bare = retasmFunc.break_bare;
export const break_value = retasmFunc.break_value;
export const break_repeated = retasmFunc.break_repeated;
export const break_inner = retasmFunc.break_inner;
export const cont_inner = retasmFunc.cont_inner;
export const effects = retasmFunc.effects;
export const while_ = retasmFunc.while_;
export const for_ = retasmFunc.for_;
export const nesting = retasmFunc.nesting;
