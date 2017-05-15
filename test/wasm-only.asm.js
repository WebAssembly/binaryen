//
// Test wasm-only builds. In this case, fastcomp emits code that is
// not asm.js, it will only ever run as wasm, and contains special intrinsics for
// asm2wasm that map LLVM IR into i64s.
//

function asm(global, env, buffer) {
  "use asm";

  var HEAP8 = new global.Int8Array(buffer);
  var HEAP16 = new global.Int16Array(buffer);
  var HEAP32 = new global.Int32Array(buffer);
  var HEAPU8 = new global.Uint8Array(buffer);
  var HEAPU16 = new global.Uint16Array(buffer);
  var HEAPU32 = new global.Uint32Array(buffer);
  var HEAPF32 = new global.Float32Array(buffer);
  var HEAPF64 = new global.Float64Array(buffer);

  var STACKTOP = env.STACKTOP | 0;

  var fround = global.Math.fround;
  var Math_imul = global.Math.imul;

  var illegalImport = env.illegalImport;
  var illegalImportResult = env.illegalImportResult;

  var _fabsf = env._fabsf;
  var do_i64 = env.do_i64;

  function loads() {
    var i = 0, f = fround(0), d = +0;
    i = load1(100);
    i = load1(101, 0);
    i = load2(102);
    i = load2(103, 0);
    i = load2(104, 1);
    i = load2(105, 2);
    i = load4(106);
    i = load4(107, 0);
    i = load4(108, 1);
    i = load4(109, 2);
    i = load4(110, 4);
    f = loadf(111);
    f = loadf(112, 0);
    f = loadf(113, 1);
    f = loadf(114, 2);
    f = loadf(115, 4);
    d = loadd(116);
    d = loadd(117, 0);
    d = loadd(118, 1);
    d = loadd(119, 2);
    d = loadd(120, 4);
    d = loadd(121, 8);
  }

  function stores() {
    var i = 0, f = fround(0), d = +0;
    store1(100, i);
    store1(101, i, 0);
    store2(102, i);
    store2(103, i, 0);
    store2(104, i, 1);
    store2(105, i, 2);
    store4(106, i);
    store4(107, i, 0);
    store4(108, i, 1);
    store4(109, i, 2);
    store4(110, i, 4);
    storef(111, f);
    storef(112, f, 0);
    storef(113, f, 1);
    storef(114, f, 2);
    storef(115, f, 4);
    stored(116, d);
    stored(117, d, 0);
    stored(118, d, 1);
    stored(119, d, 2);
    stored(120, d, 4);
    stored(121, d, 8);
  }

  function test() {
    var i = 0, j = i64(), f = fround(0), f1 = fround(0), f2 = fround(0), d1 = +0, d2 = +0;
    // bitcasts
    i = i32_bc2i(f);
    f = i32_bc2f(i);
    i = i32_cttz(i);
    i = i32_ctpop(i);
    j = i64_ctpop(j);
    f1 = f32_copysign(f1, f2);
    d1 = f64_copysign(d1, d2);
  }

  function test64() {
    var x = i64(), y = i64(), z = 0; // define i64 variables using special intrinsic
    var int32 = 0, float32 = fround(0), float64 = +0;
    x = i64_const(100, 0); // i64 constant
    y = i64_const(17, 30);
    x = i64_add(x, y); // binaries
    x = i64_sub(x, y);
    x = i64_mul(x, y);
    x = i64_udiv(x, y);
    x = i64_sdiv(x, y);
    x = i64_urem(x, y);
    x = i64_srem(x, y);
    x = i64_and(x, y);
    x = i64_or(x, y);
    x = i64_xor(x, y);
    x = i64_shl(x, y);
    x = i64_ashr(x, y);
    x = i64_lshr(x, y);
    x = load8(120, 0); // load and store
    x = load8(120);
    x = load8(120, 2);
    x = load8(120, 4);
    x = load8(120, 8);
    store8(120, x, 0);
    store8(120, x);
    store8(120, x, 2);
    store8(120, x, 4);
    store8(120, x, 8);
    // comps
    z = i64_eq(x, y);
    z = i64_ne(x, y);
    z = i64_ule(x, y);
    z = i64_sle(x, y);
    z = i64_uge(x, y);
    z = i64_sge(x, y);
    z = i64_ult(x, y);
    z = i64_slt(x, y);
    z = i64_ugt(x, y);
    z = i64_sgt(x, y);
    // convs
    int32 = i64_trunc(x);
    x = i64_sext(int32);
    x = i64_zext(int32);
    float32 = i64_s2f(x);
    float64 = i64_s2d(x);
    float32 = i64_u2f(x);
    float64 = i64_u2d(x);
    x = i64_f2s(float32);
    x = i64_d2s(float64);
    x = i64_f2u(float32);
    x = i64_d2u(float64);
    // bitcasts
    x = i64_bc2i(float64);
    float64 = i64_bc2d(x);
    // intrinsics
    x = i64_ctlz(y);
    y = i64_cttz(x);
  }
  function imports() {
    illegalImport(-3.13159, i64_const(11, 22), -33); // this call must be legalized
    return i64(illegalImportResult());
  }
  function arg(x) { // illegal param, but not exported
    x = i64(x);
    store8(100, x, 0);
    arg(i64(x)); // "coercion"/"cast"
  }
  function illegalParam(a, x, c) {
    a = 0;
    x = i64(x);
    b = +0;
    store8(100, x, 0);
    illegalParam(0, i64(x), 12.34); // "coercion"/"cast"
  }
  function result() { // illegal result, but not exported
    return i64_const(1, 2);
  }
  function illegalResult() { // illegal result, exported
    return i64_const(1, 2);
  }
  function call1(x) {
    x = i64(x);
    var y = i64();
    y = i64(call1(x));
    return i64(y); // return i64 with a "cast"
  }
  function call2(x) {
    x = i64(x);
    i64(call2(i64(call2(x))));
    return i64_const(591726473, 57073); // return an i64 const
  }
  function returnCastConst() {
     return i64(0);
  }
  function ifValue64($4, $6) {
   $4 = i64($4);
   $6 = i64($6);
   var $$0 = i64(), $9 = i64(), $10 = i64();
   if ($6) {
     $9 = i64(call2($4));
     $$0 = $9;
   } else {
     $10 = i64(call2($4));
     $$0 = $10;
   }
   return i64($$0);
  }
  function ifValue32($4, $6) {
   $4 = $4 | 0;
   $6 = $6 | 0;
   var $$0 = 0, $9 = 0, $10 = 0;
   if ($6) {
     $9 = ifValue32($4 | 0, $6 | 0) | 0;
     $$0 = $9;
   } else {
     $10 = ifValue32($4 | 0, $6 | 0) | 0;
     $$0 = $10;
   }
   return $$0 | 0;
  }
  function switch64($a444) {
    $a444 = i64($a444);
    var $waka = 0;
    switch (i64($a444)) {
     case i64_const(7,10):  {
      $waka = 11000;
      break;
     }
     case i64_const(5,10):  {
      $waka = 10;
      break;
     }
     default: {
      $waka = 1;
     }
    }
    return $waka | 0;
  }
  function unreachable_leftovers($0,$1,$2) {
   $0 = $0|0;
   $1 = $1|0;
   $2 = $2|0;
   var label = 0;
   L1: do {
    if ($1) {
     label = 10;
    } else {
     if ($2) {
      break L1;
      return;
     }
     store4($0,-2);
     return;
    }
   } while(0);
   if ((label|0) == 10) {
    store4($0,-1);
   }
   return;
  }
  function switch64TOOMUCH($a444) {
    $a444 = i64($a444);
    var $waka = 0;
    switch (i64($a444)) {
     case i64_const(0,1073741824): // spread is huge here, we should not make a jump table!
     case i64_const(0,2147483648):  {
      return 40;
     }
     default: {
      $waka = 1;
     }
    }
    switch (100) {
     case 107374182: // similar, but 32-bit
     case 214748364:  {
      return 41;
     }
     default: {
      $waka = 1001;
     }
    }
    // no defaults
    switch (i64($a444)) {
     case i64_const(0,1073741824): // spread is huge here, we should not make a jump table!
     case i64_const(0,2147483648):  {
      return 42;
     }
    }
    switch (100) {
     case 107374182: // similar, but 32-bit
     case 214748364:  {
      return 43;
     }
    }
    return 44;
  }
  function _memchr($src,$c,$n) {
   $src = $src|0;
   $c = $c|0;
   $n = $n|0;
   var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0, $7 = 0, $and = 0, $and15 = 0, $and16 = 0, $and39 = 0, $cmp = 0, $cmp11 = 0, $cmp1132 = 0, $cmp28 = 0, $cmp8 = 0, $cond = 0, $conv1 = 0, $dec = 0;
   var $dec34 = 0, $incdec$ptr = 0, $incdec$ptr21 = 0, $incdec$ptr33 = 0, $lnot = 0, $mul = 0, $n$addr$0$lcssa = 0, $n$addr$0$lcssa52 = 0, $n$addr$043 = 0, $n$addr$1$lcssa = 0, $n$addr$133 = 0, $n$addr$227 = 0, $n$addr$3 = 0, $neg = 0, $or$cond = 0, $or$cond42 = 0, $s$0$lcssa = 0, $s$0$lcssa53 = 0, $s$044 = 0, $s$128 = 0;
   var $s$2 = 0, $sub = 0, $sub22 = 0, $tobool = 0, $tobool2 = 0, $tobool2$lcssa = 0, $tobool241 = 0, $tobool25 = 0, $tobool2526 = 0, $tobool36 = 0, $tobool40 = 0, $w$0$lcssa = 0, $w$034 = 0, $xor = 0, label = 0, sp = 0;
   sp = STACKTOP;
   $conv1 = $c & 255;
   $0 = $src;
   $and39 = $0 & 3;
   $tobool40 = ($and39|0)!=(0);
   $tobool241 = ($n|0)!=(0);
   $or$cond42 = $tobool241 & $tobool40;
   L1: do {
    if ($or$cond42) {
     $1 = $c&255;
     $n$addr$043 = $n;$s$044 = $src;
     while(1) {
      $2 = load1($s$044);
      $cmp = ($2<<24>>24)==($1<<24>>24);
      if ($cmp) {
       $n$addr$0$lcssa52 = $n$addr$043;$s$0$lcssa53 = $s$044;
       label = 6;
       break L1;
      }
      $incdec$ptr = ((($s$044)) + 1|0);
      $dec = (($n$addr$043) + -1)|0;
      $3 = $incdec$ptr;
      $and = $3 & 3;
      $tobool = ($and|0)!=(0);
      $tobool2 = ($dec|0)!=(0);
      $or$cond = $tobool2 & $tobool;
      if ($or$cond) {
       $n$addr$043 = $dec;$s$044 = $incdec$ptr;
      } else {
       $n$addr$0$lcssa = $dec;$s$0$lcssa = $incdec$ptr;$tobool2$lcssa = $tobool2;
       label = 5;
       break;
      }
     }
    } else {
     $n$addr$0$lcssa = $n;$s$0$lcssa = $src;$tobool2$lcssa = $tobool241;
     label = 5;
    }
   } while(0);
   if ((label|0) == 5) {
    if ($tobool2$lcssa) {
     $n$addr$0$lcssa52 = $n$addr$0$lcssa;$s$0$lcssa53 = $s$0$lcssa;
     label = 6;
    } else {
     $n$addr$3 = 0;$s$2 = $s$0$lcssa;
    }
   }
   L8: do {
    if ((label|0) == 6) {
     $4 = load1($s$0$lcssa53);
     $5 = $c&255;
     $cmp8 = ($4<<24>>24)==($5<<24>>24);
     if ($cmp8) {
      $n$addr$3 = $n$addr$0$lcssa52;$s$2 = $s$0$lcssa53;
     } else {
      $mul = Math_imul($conv1, 16843009)|0;
      $cmp1132 = ($n$addr$0$lcssa52>>>0)>(3);
      L11: do {
       if ($cmp1132) {
        $n$addr$133 = $n$addr$0$lcssa52;$w$034 = $s$0$lcssa53;
        while(1) {
         $6 = load4($w$034);
         $xor = $6 ^ $mul;
         $sub = (($xor) + -16843009)|0;
         $neg = $xor & -2139062144;
         $and15 = $neg ^ -2139062144;
         $and16 = $and15 & $sub;
         $lnot = ($and16|0)==(0);
         if (!($lnot)) {
          break;
         }
         $incdec$ptr21 = ((($w$034)) + 4|0);
         $sub22 = (($n$addr$133) + -4)|0;
         $cmp11 = ($sub22>>>0)>(3);
         if ($cmp11) {
          $n$addr$133 = $sub22;$w$034 = $incdec$ptr21;
         } else {
          $n$addr$1$lcssa = $sub22;$w$0$lcssa = $incdec$ptr21;
          label = 11;
          break L11;
         }
        }
        $n$addr$227 = $n$addr$133;$s$128 = $w$034;
       } else {
        $n$addr$1$lcssa = $n$addr$0$lcssa52;$w$0$lcssa = $s$0$lcssa53;
        label = 11;
       }
      } while(0);
      if ((label|0) == 11) {
       $tobool2526 = ($n$addr$1$lcssa|0)==(0);
       if ($tobool2526) {
        $n$addr$3 = 0;$s$2 = $w$0$lcssa;
        break;
       } else {
        $n$addr$227 = $n$addr$1$lcssa;$s$128 = $w$0$lcssa;
       }
      }
      while(1) {
       $7 = load1($s$128);
       $cmp28 = ($7<<24>>24)==($5<<24>>24);
       if ($cmp28) {
        $n$addr$3 = $n$addr$227;$s$2 = $s$128;
        break L8;
       }
       $incdec$ptr33 = ((($s$128)) + 1|0);
       $dec34 = (($n$addr$227) + -1)|0;
       $tobool25 = ($dec34|0)==(0);
       if ($tobool25) {
        $n$addr$3 = 0;$s$2 = $incdec$ptr33;
        break;
       } else {
        $n$addr$227 = $dec34;$s$128 = $incdec$ptr33;
       }
      }
     }
    }
   } while(0);
   $tobool36 = ($n$addr$3|0)!=(0);
   $cond = $tobool36 ? $s$2 : 0;
   return ($cond|0);
  }

  function keepAlive() {
    loads();
    stores();
    test();
    i64(imports());
    arg(i64(0));
    i64(call1(i64(0)));
    i64(call2(i64(0)));
    i64(returnCastConst());
    i64(ifValue64(i64(0), i64(0)));
    ifValue32(0, 0) | 0;
    switch64(i64(0)) | 0;
    unreachable_leftovers(0, 0, 0);
    _memchr(0, 0, 0) | 0;
    switch64TOOMUCH(i64(0)) | 0;
  }

  function __emscripten_dceable_type_decls() { // dce-able, but this defines the type of fabsf which has no other use
    fround(_fabsf(fround(0.0)));
    i64(do_i64());
  }

  var FUNCTION_TABLE_X = [illegalImport, _fabsf, do_i64]; // must stay ok in the table, not legalized, as it will be called internally by the true type

  return { test64: test64, illegalParam : illegalParam, illegalResult: illegalResult, keepAlive: keepAlive };
}

