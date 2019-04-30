import { setTempRet0 } from 'env';


  var scratchBuffer = new ArrayBuffer(8);
  var i32ScratchView = new Int32Array(scratchBuffer);
  var f32ScratchView = new Float32Array(scratchBuffer);
  var f64ScratchView = new Float64Array(scratchBuffer);
  
  function legalimport$wasm2js_scratch_store_i64(low, high) {
    i32ScratchView[0] = low;
    i32ScratchView[1] = high;
  }
      
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
 var setTempRet0 = env.setTempRet0;
 var i64toi32_i32$HIGH_BITS = 0;
 function $0($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  return ($0_1 | 0) / ($1_1 | 0) | 0;
 }
 
 function $1($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  return ($0_1 >>> 0) / ($1_1 >>> 0) | 0;
 }
 
 function legalstub$2($0_1, $1_1, $2, $3) {
  $0_1 = _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E($0_1, $1_1, $2, $3);
  setTempRet0(i64toi32_i32$HIGH_BITS | 0);
  return $0_1;
 }
 
 function legalstub$3($0_1, $1_1, $2, $3) {
  $0_1 = __wasm_i64_udiv($0_1, $1_1, $2, $3);
  setTempRet0(i64toi32_i32$HIGH_BITS | 0);
  return $0_1;
 }
 
 function legalfunc$wasm2js_scratch_store_i64($0_1, $1_1) {
  var $2 = 0, $3 = 0;
  $2 = $0_1;
  $3 = 32;
  $0_1 = $3 & 31;
  legalimport$wasm2js_scratch_store_i64($2 | 0, (32 >>> 0 <= $3 >>> 0 ? $1_1 >>> $0_1 : ((1 << $0_1) - 1 & $1_1) << 32 - $0_1 | $2 >>> $0_1) | 0);
 }
 
 function _ZN17compiler_builtins3int4sdiv3Div3div17he78fc483e41d7ec7E($0_1, $1_1, $2, $3) {
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0, $13 = 0, $14 = 0;
  $4 = $1_1;
  $7 = $0_1;
  $6 = 63;
  $5 = $6 & 31;
  $11 = $0_1;
  if (32 >>> 0 <= $6 >>> 0) {
   {
    $6 = $4 >> 31;
    $8 = $4 >> $5;
   }
  } else {
   {
    $6 = $4 >> $5;
    $8 = ((1 << $5) - 1 & $4) << 32 - $5 | $7 >>> $5;
   }
  }
  $4 = $8;
  $5 = $11 ^ $4;
  $12 = $5 - $4 | 0;
  $13 = ($1_1 ^ $6) - (($5 >>> 0 < $4 >>> 0) + $6 | 0) | 0;
  $4 = $3;
  $7 = $2;
  $6 = 63;
  $5 = $6 & 31;
  $14 = $2;
  if (32 >>> 0 <= $6 >>> 0) {
   {
    $6 = $4 >> 31;
    $9 = $4 >> $5;
   }
  } else {
   {
    $6 = $4 >> $5;
    $9 = ((1 << $5) - 1 & $4) << 32 - $5 | $7 >>> $5;
   }
  }
  $4 = $9;
  $5 = $14 ^ $4;
  $4 = __wasm_i64_udiv($12, $13, $5 - $4 | 0, ($3 ^ $6) - (($5 >>> 0 < $4 >>> 0) + $6 | 0) | 0);
  $6 = i64toi32_i32$HIGH_BITS;
  $1_1 = $1_1 ^ $3;
  $3 = $0_1 ^ $2;
  $2 = 63;
  $0_1 = $2 & 31;
  if (32 >>> 0 <= $2 >>> 0) {
   {
    $2 = $1_1 >> 31;
    $10 = $1_1 >> $0_1;
   }
  } else {
   {
    $2 = $1_1 >> $0_1;
    $10 = ((1 << $0_1) - 1 & $1_1) << 32 - $0_1 | $3 >>> $0_1;
   }
  }
  $0_1 = $10;
  $1_1 = $0_1 ^ $4;
  $3 = $1_1 - $0_1 | 0;
  i64toi32_i32$HIGH_BITS = ($2 ^ $6) - (($1_1 >>> 0 < $0_1 >>> 0) + $2 | 0) | 0;
  return $3;
 }
 
 function _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0_1, $1_1, $2, $3) {
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0, $13 = 0, $14 = 0, $15 = 0, $16 = 0, $17 = 0, $18 = 0, $19 = 0, $20 = 0, $21 = 0, $22 = 0, $23 = 0, $24 = 0, $25 = 0, $26 = 0, $27 = 0, $28 = 0, $29 = 0;
  label$1 : {
   label$2 : {
    label$3 : {
     label$4 : {
      label$5 : {
       label$6 : {
        label$7 : {
         label$8 : {
          label$9 : {
           label$11 : {
            $4 = $1_1;
            $6 = $0_1;
            $9 = 32;
            $5 = $9 & 31;
            $6 = 32 >>> 0 <= $9 >>> 0 ? $4 >>> $5 : ((1 << $5) - 1 & $4) << 32 - $5 | $0_1 >>> $5;
            if ($6) {
             {
              $4 = $2;
              if (!$4) {
               break label$11
              }
              $5 = $3;
              $7 = $2;
              $8 = 32;
              $9 = $8 & 31;
              $5 = 32 >>> 0 <= $8 >>> 0 ? $5 >>> $9 : ((1 << $9) - 1 & $5) << 32 - $9 | $2 >>> $9;
              if (!$5) {
               break label$9
              }
              $4 = Math_clz32($5) - Math_clz32($6) | 0;
              if ($4 >>> 0 <= 31 >>> 0) {
               break label$8
              }
              break label$2;
             }
            }
            $4 = 1;
            if (($4 | 0) == ($3 | 0) & $2 >>> 0 >= 0 >>> 0 | $3 >>> 0 > $4 >>> 0) {
             break label$2
            }
            $1_1 = ($0_1 >>> 0) / ($2 >>> 0) | 0;
            legalfunc$wasm2js_scratch_store_i64($0_1 - Math_imul($2, $1_1) | 0, 0);
            i64toi32_i32$HIGH_BITS = 0;
            return $1_1;
           }
           $4 = $3;
           $9 = $2;
           $7 = 32;
           $5 = $7 & 31;
           $4 = 32 >>> 0 <= $7 >>> 0 ? $4 >>> $5 : ((1 << $5) - 1 & $4) << 32 - $5 | $2 >>> $5;
           if (!$0_1) {
            break label$7
           }
           if (!$4) {
            break label$6
           }
           $5 = $4 + -1 | 0;
           if ($4 & $5) {
            break label$6
           }
           $9 = 0;
           $3 = $5 & $6;
           $5 = 32;
           $2 = $5 & 31;
           if (32 >>> 0 <= $5 >>> 0) {
            {
             $5 = $3 << $2;
             $15 = 0;
            }
           } else {
            {
             $5 = (1 << $2) - 1 & $3 >>> 32 - $2 | $9 << $2;
             $15 = $3 << $2;
            }
           }
           legalfunc$wasm2js_scratch_store_i64($15 | $0_1, $5);
           $0_1 = $6 >>> (__wasm_ctz_i32($4) & 31);
           i64toi32_i32$HIGH_BITS = 0;
           return $0_1;
          }
          $5 = $4 + -1 | 0;
          if (!($4 & $5)) {
           break label$5
          }
          $10 = (Math_clz32($4) + 33 | 0) - Math_clz32($6) | 0;
          $14 = 0 - $10 | 0;
          break label$3;
         }
         $10 = $4 + 1 | 0;
         $14 = 63 - $4 | 0;
         break label$3;
        }
        $2 = 0;
        $3 = ($6 >>> 0) / ($4 >>> 0) | 0;
        $1_1 = $6 - Math_imul($4, $3) | 0;
        $4 = 32;
        $0_1 = $4 & 31;
        if (32 >>> 0 <= $4 >>> 0) {
         {
          $4 = $1_1 << $0_1;
          $16 = 0;
         }
        } else {
         {
          $4 = (1 << $0_1) - 1 & $1_1 >>> 32 - $0_1 | $2 << $0_1;
          $16 = $1_1 << $0_1;
         }
        }
        legalfunc$wasm2js_scratch_store_i64($16, $4);
        i64toi32_i32$HIGH_BITS = 0;
        return $3;
       }
       $4 = Math_clz32($4) - Math_clz32($6) | 0;
       if ($4 >>> 0 < 31 >>> 0) {
        break label$4
       }
       break label$2;
      }
      legalfunc$wasm2js_scratch_store_i64($0_1 & $5, 0);
      if (($4 | 0) == (1 | 0)) {
       break label$1
      }
      $2 = $0_1;
      $3 = __wasm_ctz_i32($4);
      $0_1 = $3 & 31;
      if (32 >>> 0 <= ($3 & 63) >>> 0) {
       {
        $4 = 0;
        $17 = $1_1 >>> $0_1;
       }
      } else {
       {
        $4 = $1_1 >>> $0_1;
        $17 = ((1 << $0_1) - 1 & $1_1) << 32 - $0_1 | $2 >>> $0_1;
       }
      }
      $0_1 = $17;
      i64toi32_i32$HIGH_BITS = $4;
      return $0_1;
     }
     $10 = $4 + 1 | 0;
     $14 = 63 - $4 | 0;
    }
    $9 = $14;
    $5 = $1_1;
    $7 = $0_1;
    $4 = $10 & 63;
    $6 = $4 & 31;
    if (32 >>> 0 <= ($4 & 63) >>> 0) {
     {
      $4 = 0;
      $18 = $5 >>> $6;
     }
    } else {
     {
      $4 = $5 >>> $6;
      $18 = ((1 << $6) - 1 & $5) << 32 - $6 | $7 >>> $6;
     }
    }
    $11 = $18;
    $5 = $4;
    $6 = $0_1;
    $4 = $9 & 63;
    $0_1 = $4 & 31;
    if (32 >>> 0 <= ($4 & 63) >>> 0) {
     {
      $4 = $6 << $0_1;
      $19 = 0;
     }
    } else {
     {
      $4 = (1 << $0_1) - 1 & $6 >>> 32 - $0_1 | $1_1 << $0_1;
      $19 = $6 << $0_1;
     }
    }
    $0_1 = $19;
    $1_1 = $4;
    if ($10) {
     {
      $4 = $3 + -1 | 0;
      $6 = -1;
      $9 = $6 + $2 | 0;
      if ($9 >>> 0 < $6 >>> 0) {
       $4 = $4 + 1 | 0
      }
      $6 = $9;
      $9 = $4;
      label$15 : while (1) {
       $8 = $11;
       $4 = 1;
       $7 = $4;
       if (32 >>> 0 <= $4 >>> 0) {
        {
         $4 = $8 << $7;
         $20 = 0;
        }
       } else {
        {
         $4 = (1 << $7) - 1 & $8 >>> 32 - $7 | $5 << $7;
         $20 = $8 << $7;
        }
       }
       $5 = $20;
       $7 = $4;
       $25 = $5;
       $5 = $1_1;
       $11 = $0_1;
       $4 = 63;
       $8 = $4 & 31;
       if (32 >>> 0 <= $4 >>> 0) {
        {
         $4 = 0;
         $21 = $5 >>> $8;
        }
       } else {
        {
         $4 = $5 >>> $8;
         $21 = ((1 << $8) - 1 & $5) << 32 - $8 | $11 >>> $8;
        }
       }
       $5 = $25 | $21;
       $8 = $5;
       $7 = $4 | $7;
       $13 = $7;
       $4 = $6;
       $11 = $4 - $5 | 0;
       $7 = $9 - (($4 >>> 0 < $5 >>> 0) + $7 | 0) | 0;
       $4 = 63;
       $5 = $4 & 31;
       $26 = $8;
       $27 = $2;
       if (32 >>> 0 <= $4 >>> 0) {
        {
         $4 = $7 >> 31;
         $22 = $7 >> $5;
        }
       } else {
        {
         $4 = $7 >> $5;
         $22 = ((1 << $5) - 1 & $7) << 32 - $5 | $11 >>> $5;
        }
       }
       $12 = $22;
       $5 = $27 & $12;
       $11 = $26 - $5 | 0;
       $7 = $4;
       $5 = $13 - (($3 & $4) + ($8 >>> 0 < $5 >>> 0) | 0) | 0;
       $8 = $0_1;
       $4 = 1;
       $0_1 = $4;
       if (32 >>> 0 <= $4 >>> 0) {
        {
         $4 = $8 << $0_1;
         $23 = 0;
        }
       } else {
        {
         $4 = (1 << $0_1) - 1 & $8 >>> 32 - $0_1 | $1_1 << $0_1;
         $23 = $8 << $0_1;
        }
       }
       $0_1 = $23 | $28;
       $1_1 = $4 | $29;
       $13 = $12 & 1;
       $28 = $13;
       $12 = 0;
       $29 = $12;
       $10 = $10 + -1 | 0;
       if ($10) {
        continue
       }
       break;
      };
     }
    }
    legalfunc$wasm2js_scratch_store_i64($11, $5);
    $2 = $0_1;
    $3 = 1;
    $0_1 = $3;
    if (32 >>> 0 <= $0_1 >>> 0) {
     {
      $4 = $2 << $0_1;
      $24 = 0;
     }
    } else {
     {
      $4 = (1 << $0_1) - 1 & $2 >>> 32 - $0_1 | $1_1 << $0_1;
      $24 = $2 << $0_1;
     }
    }
    $0_1 = $24 | $13;
    i64toi32_i32$HIGH_BITS = $4 | $12;
    return $0_1;
   }
   legalfunc$wasm2js_scratch_store_i64($0_1, $1_1);
   $0_1 = 0;
   $1_1 = 0;
  }
  i64toi32_i32$HIGH_BITS = $1_1;
  return $0_1;
 }
 
 function __wasm_i64_udiv($0_1, $1_1, $2, $3) {
  $0_1 = _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0_1, $1_1, $2, $3);
  return $0_1;
 }
 
 function __wasm_ctz_i32($0_1) {
  if ($0_1) {
   return 31 - Math_clz32($0_1 ^ $0_1 + -1) | 0
  }
  return 32;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "no_dce_i32_div_s": $0, 
  "no_dce_i32_div_u": $1, 
  "no_dce_i64_div_s": legalstub$2, 
  "no_dce_i64_div_u": legalstub$3
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0},memasmFunc);
export var no_dce_i32_div_s = retasmFunc.no_dce_i32_div_s;
export var no_dce_i32_div_u = retasmFunc.no_dce_i32_div_u;
export var no_dce_i64_div_s = retasmFunc.no_dce_i64_div_s;
export var no_dce_i64_div_u = retasmFunc.no_dce_i64_div_u;
import { setTempRet0 } from 'env';
import { getTempRet0 } from 'env';


  var scratchBuffer = new ArrayBuffer(8);
  var i32ScratchView = new Int32Array(scratchBuffer);
  var f32ScratchView = new Float32Array(scratchBuffer);
  var f64ScratchView = new Float64Array(scratchBuffer);
  
  function legalimport$wasm2js_scratch_load_i64() {
    if (typeof setTempRet0 === 'function') setTempRet0(i32ScratchView[1]);
    return i32ScratchView[0];
  }
      
  function legalimport$wasm2js_scratch_store_i64(low, high) {
    i32ScratchView[0] = low;
    i32ScratchView[1] = high;
  }
      
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
 var setTempRet0 = env.setTempRet0;
 var getTempRet0 = env.getTempRet0;
 var i64toi32_i32$HIGH_BITS = 0;
 function $0($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  return ($0_1 | 0) % ($1_1 | 0) | 0;
 }
 
 function $1($0_1, $1_1) {
  $0_1 = $0_1 | 0;
  $1_1 = $1_1 | 0;
  return ($0_1 >>> 0) % ($1_1 >>> 0) | 0;
 }
 
 function legalstub$2($0_1, $1_1, $2, $3) {
  $0_1 = _ZN17compiler_builtins3int4sdiv3Mod4mod_17h2cbb7bbf36e41d68E($0_1, $1_1, $2, $3);
  setTempRet0(i64toi32_i32$HIGH_BITS | 0);
  return $0_1;
 }
 
 function legalstub$3($0_1, $1_1, $2, $3) {
  $0_1 = __wasm_i64_urem($0_1, $1_1, $2, $3);
  setTempRet0(i64toi32_i32$HIGH_BITS | 0);
  return $0_1;
 }
 
 function legalfunc$wasm2js_scratch_load_i64() {
  var $0_1 = 0, $1_1 = 0, $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0;
  $5 = legalimport$wasm2js_scratch_load_i64() | 0;
  $1_1 = getTempRet0() | 0;
  $3 = 32;
  $0_1 = $3 & 31;
  if (32 >>> 0 <= $3 >>> 0) {
   {
    $2 = $1_1 << $0_1;
    $4 = 0;
   }
  } else {
   {
    $2 = (1 << $0_1) - 1 & $1_1 >>> 32 - $0_1 | $2 << $0_1;
    $4 = $1_1 << $0_1;
   }
  }
  $0_1 = $5 | $4;
  i64toi32_i32$HIGH_BITS = $2 | $6;
  return $0_1;
 }
 
 function legalfunc$wasm2js_scratch_store_i64($0_1, $1_1) {
  var $2 = 0, $3 = 0;
  $2 = $0_1;
  $3 = 32;
  $0_1 = $3 & 31;
  legalimport$wasm2js_scratch_store_i64($2 | 0, (32 >>> 0 <= $3 >>> 0 ? $1_1 >>> $0_1 : ((1 << $0_1) - 1 & $1_1) << 32 - $0_1 | $2 >>> $0_1) | 0);
 }
 
 function _ZN17compiler_builtins3int4sdiv3Mod4mod_17h2cbb7bbf36e41d68E($0_1, $1_1, $2, $3) {
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0, $13 = 0;
  $5 = $1_1;
  $7 = $0_1;
  $4 = 63;
  $6 = $4 & 31;
  $10 = $0_1;
  if (32 >>> 0 <= $4 >>> 0) {
   {
    $4 = $5 >> 31;
    $8 = $5 >> $6;
   }
  } else {
   {
    $4 = $5 >> $6;
    $8 = ((1 << $6) - 1 & $5) << 32 - $6 | $7 >>> $6;
   }
  }
  $5 = $8;
  $7 = $10 ^ $5;
  $0_1 = $5;
  $11 = $7 - $0_1 | 0;
  $6 = $4;
  $12 = ($1_1 ^ $6) - (($7 >>> 0 < $0_1 >>> 0) + $6 | 0) | 0;
  $0_1 = $3;
  $7 = $2;
  $4 = 63;
  $1_1 = $4 & 31;
  $13 = $7;
  if (32 >>> 0 <= $4 >>> 0) {
   {
    $4 = $0_1 >> 31;
    $9 = $0_1 >> $1_1;
   }
  } else {
   {
    $4 = $0_1 >> $1_1;
    $9 = ((1 << $1_1) - 1 & $0_1) << 32 - $1_1 | $7 >>> $1_1;
   }
  }
  $0_1 = $9;
  $1_1 = $13 ^ $0_1;
  $0_1 = __wasm_i64_urem($11, $12, $1_1 - $0_1 | 0, ($3 ^ $4) - (($1_1 >>> 0 < $0_1 >>> 0) + $4 | 0) | 0) ^ $5;
  $1_1 = $0_1 - $5 | 0;
  i64toi32_i32$HIGH_BITS = ($6 ^ i64toi32_i32$HIGH_BITS) - (($0_1 >>> 0 < $5 >>> 0) + $6 | 0) | 0;
  return $1_1;
 }
 
 function _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0_1, $1_1, $2, $3) {
  var $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $10 = 0, $11 = 0, $12 = 0, $13 = 0, $14 = 0, $15 = 0, $16 = 0, $17 = 0;
  label$1 : {
   label$2 : {
    label$3 : {
     label$4 : {
      label$5 : {
       label$6 : {
        label$7 : {
         label$8 : {
          label$9 : {
           label$11 : {
            $4 = $1_1;
            if ($4) {
             {
              $5 = $2;
              if (!$5) {
               break label$11
              }
              $6 = $3;
              if (!$6) {
               break label$9
              }
              $4 = Math_clz32($6) - Math_clz32($4) | 0;
              if ($4 >>> 0 <= 31 >>> 0) {
               break label$8
              }
              break label$2;
             }
            }
            if (($3 | 0) == (1 | 0) & $2 >>> 0 >= 0 >>> 0 | $3 >>> 0 > 1 >>> 0) {
             break label$2
            }
            legalfunc$wasm2js_scratch_store_i64($0_1 - Math_imul($2, ($0_1 >>> 0) / ($2 >>> 0) | 0) | 0, 0);
            i64toi32_i32$HIGH_BITS = 0;
            return;
           }
           $6 = $3;
           if (!$0_1) {
            break label$7
           }
           if (!$6) {
            break label$6
           }
           $5 = $6 + -1 | 0;
           if ($6 & $5) {
            break label$6
           }
           legalfunc$wasm2js_scratch_store_i64($0_1, $4 & $5);
           __wasm_ctz_i32($6);
           i64toi32_i32$HIGH_BITS = 0;
           return;
          }
          $6 = $5 + -1 | 0;
          if (!($5 & $6)) {
           break label$5
          }
          $8 = (Math_clz32($5) + 33 | 0) - Math_clz32($4) | 0;
          $9 = 0 - $8 | 0;
          break label$3;
         }
         $8 = $4 + 1 | 0;
         $9 = 63 - $4 | 0;
         break label$3;
        }
        legalfunc$wasm2js_scratch_store_i64(0, $4 - Math_imul($6, ($4 >>> 0) / ($6 >>> 0) | 0) | 0);
        i64toi32_i32$HIGH_BITS = 0;
        return;
       }
       $4 = Math_clz32($6) - Math_clz32($4) | 0;
       if ($4 >>> 0 < 31 >>> 0) {
        break label$4
       }
       break label$2;
      }
      legalfunc$wasm2js_scratch_store_i64($0_1 & $6, 0);
      if (($5 | 0) == (1 | 0)) {
       break label$1
      }
      $3 = __wasm_ctz_i32($5);
      $2 = $3 & 31;
      if (32 >>> 0 <= ($3 & 63) >>> 0) {
       $4 = 0
      } else {
       $4 = $1_1 >>> $2
      }
      i64toi32_i32$HIGH_BITS = $4;
      return;
     }
     $8 = $4 + 1 | 0;
     $9 = 63 - $4 | 0;
    }
    $10 = $9;
    $5 = $1_1;
    $6 = $0_1;
    $4 = $8 & 63;
    $7 = $4 & 31;
    if (32 >>> 0 <= $4 >>> 0) {
     {
      $4 = 0;
      $12 = $5 >>> $7;
     }
    } else {
     {
      $4 = $5 >>> $7;
      $12 = ((1 << $7) - 1 & $5) << 32 - $7 | $6 >>> $7;
     }
    }
    $6 = $12;
    $5 = $4;
    $4 = $10 & 63;
    $7 = $4 & 31;
    if (32 >>> 0 <= $4 >>> 0) {
     {
      $4 = $0_1 << $7;
      $13 = 0;
     }
    } else {
     {
      $4 = (1 << $7) - 1 & $0_1 >>> 32 - $7 | $1_1 << $7;
      $13 = $0_1 << $7;
     }
    }
    $0_1 = $13;
    $1_1 = $4;
    if ($8) {
     {
      $4 = $3 + -1 | 0;
      $7 = $2 + -1 | 0;
      if ($7 >>> 0 < -1 >>> 0) {
       $14 = $4 + 1 | 0
      } else {
       $14 = $4
      }
      $10 = $14;
      label$15 : while (1) {
       $11 = $6 << 1;
       $5 = $5 << 1 | $6 >>> 31;
       $6 = $11 | $1_1 >>> 31;
       $11 = $6;
       $4 = $5;
       $16 = $4;
       $5 = $10 - (($7 >>> 0 < $6 >>> 0) + $4 | 0) | 0;
       $4 = $5 >> 31;
       $15 = $5 >> 31;
       $5 = $2 & $15;
       $6 = $6 - $5 | 0;
       $5 = $16 - (($3 & $4) + ($11 >>> 0 < $5 >>> 0) | 0) | 0;
       $4 = $1_1 << 1 | $0_1 >>> 31;
       $0_1 = $17 | $0_1 << 1;
       $1_1 = $4;
       $17 = $15 & 1;
       $8 = $8 + -1 | 0;
       if ($8) {
        continue
       }
       break;
      };
     }
    }
    legalfunc$wasm2js_scratch_store_i64($6, $5);
    i64toi32_i32$HIGH_BITS = $1_1 << 1 | $0_1 >>> 31;
    return;
   }
   legalfunc$wasm2js_scratch_store_i64($0_1, $1_1);
   $1_1 = 0;
  }
  i64toi32_i32$HIGH_BITS = $1_1;
 }
 
 function __wasm_i64_urem($0_1, $1_1, $2, $3) {
  _ZN17compiler_builtins3int4udiv10divmod_u6417h6026910b5ed08e40E($0_1, $1_1, $2, $3);
  $0_1 = legalfunc$wasm2js_scratch_load_i64();
  return $0_1;
 }
 
 function __wasm_ctz_i32($0_1) {
  if ($0_1) {
   return 31 - Math_clz32($0_1 ^ $0_1 + -1) | 0
  }
  return 32;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "no_dce_i32_rem_s": $0, 
  "no_dce_i32_rem_u": $1, 
  "no_dce_i64_rem_s": legalstub$2, 
  "no_dce_i64_rem_u": legalstub$3
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0,getTempRet0},memasmFunc);
export var no_dce_i32_rem_s = retasmFunc.no_dce_i32_rem_s;
export var no_dce_i32_rem_u = retasmFunc.no_dce_i32_rem_u;
export var no_dce_i64_rem_s = retasmFunc.no_dce_i64_rem_s;
export var no_dce_i64_rem_u = retasmFunc.no_dce_i64_rem_u;
import { setTempRet0 } from 'env';

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
 var setTempRet0 = env.setTempRet0;
 var i64toi32_i32$HIGH_BITS = 0;
 function $0($0_1) {
  $0_1 = Math_fround($0_1);
  return ~~$0_1 | 0;
 }
 
 function $1($0_1) {
  $0_1 = Math_fround($0_1);
  return ~~$0_1 >>> 0;
 }
 
 function $2($0_1) {
  $0_1 = +$0_1;
  return ~~$0_1 | 0;
 }
 
 function $3($0_1) {
  $0_1 = +$0_1;
  return ~~$0_1 >>> 0;
 }
 
 function $4($0_1) {
  $0_1 = Math_fround($0_1);
  var $1_1 = 0, $2_1 = 0, $3_1 = 0;
  $3_1 = ~~$0_1 >>> 0;
  if (Math_fround(Math_abs($0_1)) >= Math_fround(1.0)) {
   {
    if ($0_1 > Math_fround(0.0)) {
     $1_1 = ~~Math_fround(Math_min(Math_fround(Math_floor(Math_fround($0_1 / Math_fround(4294967296.0)))), Math_fround(4294967296.0))) >>> 0
    } else {
     $1_1 = ~~Math_fround(Math_ceil(Math_fround(Math_fround($0_1 - Math_fround(~~$0_1 >>> 0 >>> 0)) / Math_fround(4294967296.0)))) >>> 0
    }
    $2_1 = $1_1;
   }
  } else {
   $2_1 = 0
  }
  i64toi32_i32$HIGH_BITS = $2_1;
  return $3_1 | 0;
 }
 
 function $6($0_1) {
  $0_1 = +$0_1;
  var $1_1 = 0, $2_1 = 0, $3_1 = 0;
  $3_1 = ~~$0_1 >>> 0;
  if (Math_abs($0_1) >= 1.0) {
   {
    if ($0_1 > 0.0) {
     $1_1 = ~~Math_min(Math_floor($0_1 / 4294967296.0), 4294967295.0) >>> 0
    } else {
     $1_1 = ~~Math_ceil(($0_1 - +(~~$0_1 >>> 0 >>> 0)) / 4294967296.0) >>> 0
    }
    $2_1 = $1_1;
   }
  } else {
   $2_1 = 0
  }
  i64toi32_i32$HIGH_BITS = $2_1;
  return $3_1 | 0;
 }
 
 function legalstub$4($0_1) {
  var $1_1 = 0, $2_1 = 0, $3_1 = 0, $4_1 = 0;
  $2_1 = $4($0_1);
  $3_1 = i64toi32_i32$HIGH_BITS;
  $4_1 = 32;
  $1_1 = $4_1 & 31;
  setTempRet0((32 >>> 0 <= $4_1 >>> 0 ? $3_1 >>> $1_1 : ((1 << $1_1) - 1 & $3_1) << 32 - $1_1 | $2_1 >>> $1_1) | 0);
  return $2_1;
 }
 
 function legalstub$6($0_1) {
  var $1_1 = 0, $2_1 = 0, $3_1 = 0, $4_1 = 0;
  $2_1 = $6($0_1);
  $3_1 = i64toi32_i32$HIGH_BITS;
  $4_1 = 32;
  $1_1 = $4_1 & 31;
  setTempRet0((32 >>> 0 <= $4_1 >>> 0 ? $3_1 >>> $1_1 : ((1 << $1_1) - 1 & $3_1) << 32 - $1_1 | $2_1 >>> $1_1) | 0);
  return $2_1;
 }
 
 var FUNCTION_TABLE = [];
 return {
  "no_dce_i32_trunc_s_f32": $0, 
  "no_dce_i32_trunc_u_f32": $1, 
  "no_dce_i32_trunc_s_f64": $2, 
  "no_dce_i32_trunc_u_f64": $3, 
  "no_dce_i64_trunc_s_f32": legalstub$4, 
  "no_dce_i64_trunc_u_f32": legalstub$4, 
  "no_dce_i64_trunc_s_f64": legalstub$6, 
  "no_dce_i64_trunc_u_f64": legalstub$6
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0},memasmFunc);
export var no_dce_i32_trunc_s_f32 = retasmFunc.no_dce_i32_trunc_s_f32;
export var no_dce_i32_trunc_u_f32 = retasmFunc.no_dce_i32_trunc_u_f32;
export var no_dce_i32_trunc_s_f64 = retasmFunc.no_dce_i32_trunc_s_f64;
export var no_dce_i32_trunc_u_f64 = retasmFunc.no_dce_i32_trunc_u_f64;
export var no_dce_i64_trunc_s_f32 = retasmFunc.no_dce_i64_trunc_s_f32;
export var no_dce_i64_trunc_u_f32 = retasmFunc.no_dce_i64_trunc_u_f32;
export var no_dce_i64_trunc_s_f64 = retasmFunc.no_dce_i64_trunc_s_f64;
export var no_dce_i64_trunc_u_f64 = retasmFunc.no_dce_i64_trunc_u_f64;
import { setTempRet0 } from 'env';

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
 var setTempRet0 = env.setTempRet0;
 var i64toi32_i32$HIGH_BITS = 0;
 function $0($0_1) {
  $0_1 = $0_1 | 0;
  return HEAP32[$0_1 >> 2] | 0;
 }
 
 function $2($0_1) {
  $0_1 = $0_1 | 0;
  return Math_fround(HEAPF32[$0_1 >> 2]);
 }
 
 function $3($0_1) {
  $0_1 = $0_1 | 0;
  return +HEAPF64[$0_1 >> 3];
 }
 
 function legalstub$1($0_1) {
  var $1 = 0;
  $1 = HEAP32[$0_1 >> 2];
  i64toi32_i32$HIGH_BITS = HEAP32[$0_1 + 4 >> 2];
  $0_1 = $1;
  setTempRet0(i64toi32_i32$HIGH_BITS | 0);
  return $0_1;
 }
 
 var FUNCTION_TABLE = [];
 function __wasm_grow_memory(pagesToAdd) {
  pagesToAdd = pagesToAdd | 0;
  var oldPages = __wasm_current_memory() | 0;
  var newPages = oldPages + pagesToAdd | 0;
  if ((oldPages < newPages) && (newPages < 65536)) {
   {
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
  }
  return oldPages;
 }
 
 function __wasm_current_memory() {
  return buffer.byteLength / 65536 | 0;
 }
 
 return {
  "no_dce_i32_load": $0, 
  "no_dce_i64_load": legalstub$1, 
  "no_dce_f32_load": $2, 
  "no_dce_f64_load": $3
 };
}

var memasmFunc = new ArrayBuffer(65536);
var retasmFunc = asmFunc({Math,Int8Array,Uint8Array,Int16Array,Uint16Array,Int32Array,Uint32Array,Float32Array,Float64Array,NaN,Infinity}, {abort:function() { throw new Error('abort'); },setTempRet0},memasmFunc);
export var no_dce_i32_load = retasmFunc.no_dce_i32_load;
export var no_dce_i64_load = retasmFunc.no_dce_i64_load;
export var no_dce_f32_load = retasmFunc.no_dce_f32_load;
export var no_dce_f64_load = retasmFunc.no_dce_f64_load;
