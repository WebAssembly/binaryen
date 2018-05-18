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
 var i64toi32_i32$HIGH_BITS = 0;
 function $0() {
  var $0 = 0;
  exit : {
   $0 = 1;
   break exit;
  };
  return $0 | 0;
 }
 
 function $1() {
  var i = 0, $6 = 0;
  i = 0;
  exit : {
   cont : do {
    i = i + 1 | 0;
    if ((i | 0) == (5 | 0)) {
     $6 = i;
     break exit;
    }
    continue cont;
    break cont;
   } while (1);
  };
  return $6 | 0;
 }
 
 function $2() {
  var i = 0, $8 = 0;
  i = 0;
  exit : {
   cont : do {
    i = i + 1 | 0;
    if ((i | 0) == (5 | 0)) continue cont;
    if ((i | 0) == (8 | 0)) {
     $8 = i;
     break exit;
    }
    i = i + 1 | 0;
    continue cont;
    break cont;
   } while (1);
  };
  return $8 | 0;
 }
 
 function $3() {
  var i = 0, $6 = 0;
  i = 0;
  exit : {
   cont : do {
    i = i + 1 | 0;
    if ((i | 0) == (5 | 0)) {
     $6 = i;
     break exit;
    }
    break cont;
   } while (1);
   $6 = i;
  };
  return $6 | 0;
 }
 
 function $4(max) {
  max = max | 0;
  var i = 0, $9 = 0;
  i = 1;
  exit : {
   cont : do {
    i = i + i | 0;
    if (i >>> 0 > max >>> 0) {
     $9 = i;
     break exit;
    }
    continue cont;
    break cont;
   } while (1);
  };
  return $9 | 0;
 }
 
 function $5() {
  var $0 = 0;
  l : do {
   $0 = 1;
   break l;
  } while (1);
  return $0 + 1 | 0 | 0;
 }
 
 function $6() {
  var i = 0;
  i = 0;
  block : {
   l : {
    break l;
   };
   i = i + 1 | 0;
   l1 : {
    break l1;
   };
   i = i + 1 | 0;
   l2 : {
    break l2;
   };
   i = i + 1 | 0;
   l3 : {
    break l3;
   };
   i = i + 1 | 0;
   l4 : {
    break l4;
   };
   i = i + 1 | 0;
  };
  return i | 0;
 }
 
 function $7() {
  var i = 0;
  i = 0;
  block : {
   if_ : {
    break if_;
   };
   i = i + 1 | 0;
   if5 : {
    break if5;
   };
   i = i + 1 | 0;
   if6 : {
    break if6;
   };
   i = i + 1 | 0;
   if7 : {
    break if7;
   };
   i = i + 1 | 0;
   if8 : {
    break if8;
   };
   i = i + 1 | 0;
  };
  return i | 0;
 }
 
 function $8($0) {
  $0 = $0 | 0;
  var $2 = 0, $3 = 0;
  ret : {
   exit : {
    $0 : {
     default_ : {
      $3 : {
       $2 : {
        $1 : {
         switch ($0 | 0) {
         case 0:
          break $0;
         case 1:
          break $1;
         case 2:
          break $2;
         case 3:
          break $3;
         default:
          break default_;
         };
        };
       };
       $2 = 2;
       break exit;
      };
      $3 = 3;
      break ret;
     };
    };
    $2 = 5;
   };
   $3 = Math_imul(10, $2);
  };
  return $3 | 0;
 }
 
 function $9($0) {
  $0 = $0 | 0;
  $1 : {
   $0 : {
    switch ($0 | 0) {
    case 0:
     break $0;
    default:
     break $1;
    };
   };
   return 0 | 0;
  };
  return 2 | 0;
 }
 
 function $10() {
  var i = 0, $10 = 0;
  i = 0;
  outer : {
   inner : {
    if (0) break inner;
    i = i | 1 | 0;
    if (1) break inner;
    i = i | 2 | 0;
   };
   i = i | 4 | 0;
   $10 = i;
   if (0) break outer;
   i = i | 8 | 0;
   i = i | 16 | 0;
   $10 = i;
   if (1) break outer;
   i = i | 32 | 0;
   $10 = i;
  };
  return $10 | 0;
 }
 
 function $11() {
  var $2 = 0, $0 = 0;
  l0 : {
   l1 : {
    $0 = 1;
    break l1;
   };
   $2 = $0;
   if (1) break l0;
   $2 = 1;
  };
  return $2 | 0;
 }
 
 function $12() {
  var $2 = 0, $0 = 0;
  l0 : {
   l1 : {
    $0 = 1;
    break l1;
   };
   $2 = $0;
   break l0;
  };
  return $2 | 0;
 }
 
 function $13() {
  var i1 = 0, $7 = 0, $3 = 0;
  l0 : {
   i1 = 1;
   $3 = i1;
   i1 = 2;
   $7 = $3;
   if (i1) break l0;
   $7 = 0;
  };
  return i1 | 0;
 }
 
 function $14() {
  var $2 = 0, $0 = 0, $3 = 0;
  l0 : {
   l1 : {
    $0 = 1;
    break l1;
   };
   $2 = $0;
   break l0;
  };
  return $2 | 0;
 }
 
 function $15() {
  var $0 = 0;
  l1 : {
   $0 = 1;
   break l1;
  };
  return $0 | 0;
 }
 
 function $16() {
  var $1 = 0, $2 = 0;
  l1 : {
   $1 = 2;
   l113 : {
    $2 = 3;
    break l113;
   };
  };
  return $1 + $2 | 0 | 0;
 }
 
 return {
  block: $0, 
  loop1: $1, 
  loop2: $2, 
  loop3: $3, 
  loop4: $4, 
  loop5: $5, 
  if_: $6, 
  if2: $7, 
  switch_: $8, 
  return_: $9, 
  br_if0: $10, 
  br_if1: $11, 
  br_if2: $12, 
  br_if3: $13, 
  br: $14, 
  shadowing: $15, 
  redefinition: $16
 };
}

