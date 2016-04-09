Module["asm"] =  (function(global, env, buffer) {
  'almost asm';
  
  
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
  var cttz_i8=env.cttz_i8|0;

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
  var nullFunc_ii=env.nullFunc_ii;
  var nullFunc_iiii=env.nullFunc_iiii;
  var nullFunc_vi=env.nullFunc_vi;
  var invoke_ii=env.invoke_ii;
  var invoke_iiii=env.invoke_iiii;
  var invoke_vi=env.invoke_vi;
  var _pthread_cleanup_pop=env._pthread_cleanup_pop;
  var ___lock=env.___lock;
  var _emscripten_set_main_loop=env._emscripten_set_main_loop;
  var _pthread_self=env._pthread_self;
  var _abort=env._abort;
  var _emscripten_set_main_loop_timing=env._emscripten_set_main_loop_timing;
  var ___syscall6=env.___syscall6;
  var _sbrk=env._sbrk;
  var _time=env._time;
  var ___setErrNo=env.___setErrNo;
  var _emscripten_memcpy_big=env._emscripten_memcpy_big;
  var ___syscall54=env.___syscall54;
  var ___unlock=env.___unlock;
  var ___syscall140=env.___syscall140;
  var _pthread_cleanup_push=env._pthread_cleanup_push;
  var _sysconf=env._sysconf;
  var ___syscall146=env.___syscall146;
  var _llvm_cttz_i32=env._llvm_cttz_i32;
  var tempFloat = 0.0;

// EMSCRIPTEN_START_FUNCS
function stackAlloc(size) {
  size = size|0;
  var ret = 0;
  ret = STACKTOP;
  STACKTOP = (STACKTOP + size)|0;
  STACKTOP = (STACKTOP + 15)&-16;
if ((STACKTOP|0) >= (STACK_MAX|0)) abort();

  return ret|0;
}
function stackSave() {
  return STACKTOP|0;
}
function stackRestore(top) {
  top = top|0;
  STACKTOP = top;
}
function establishStackSpace(stackBase, stackMax) {
  stackBase = stackBase|0;
  stackMax = stackMax|0;
  STACKTOP = stackBase;
  STACK_MAX = stackMax;
}

function setThrew(threw, value) {
  threw = threw|0;
  value = value|0;
  if ((__THREW__|0) == 0) {
    __THREW__ = threw;
    threwValue = value;
  }
}
function copyTempFloat(ptr) {
  ptr = ptr|0;
  HEAP8[tempDoublePtr>>0] = HEAP8[ptr>>0];
  HEAP8[tempDoublePtr+1>>0] = HEAP8[ptr+1>>0];
  HEAP8[tempDoublePtr+2>>0] = HEAP8[ptr+2>>0];
  HEAP8[tempDoublePtr+3>>0] = HEAP8[ptr+3>>0];
}
function copyTempDouble(ptr) {
  ptr = ptr|0;
  HEAP8[tempDoublePtr>>0] = HEAP8[ptr>>0];
  HEAP8[tempDoublePtr+1>>0] = HEAP8[ptr+1>>0];
  HEAP8[tempDoublePtr+2>>0] = HEAP8[ptr+2>>0];
  HEAP8[tempDoublePtr+3>>0] = HEAP8[ptr+3>>0];
  HEAP8[tempDoublePtr+4>>0] = HEAP8[ptr+4>>0];
  HEAP8[tempDoublePtr+5>>0] = HEAP8[ptr+5>>0];
  HEAP8[tempDoublePtr+6>>0] = HEAP8[ptr+6>>0];
  HEAP8[tempDoublePtr+7>>0] = HEAP8[ptr+7>>0];
}

function setTempRet0(value) {
  value = value|0;
  tempRet0 = value;
}
function getTempRet0() {
  return tempRet0|0;
}

function _main() {
 var $retval = 0, $vararg_buffer = 0, label = 0, sp = 0;
 sp = STACKTOP;
 STACKTOP = STACKTOP + 16|0; if ((STACKTOP|0) >= (STACK_MAX|0)) abort();
 $vararg_buffer = sp;
 $retval = 0;
 (_printf(672,$vararg_buffer)|0);
 STACKTOP = sp;return 0;
}
function _frexp($x,$e) {
 $x = +$x;
 $e = $e|0;
 var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0, $7 = 0.0, $call = 0.0, $conv = 0, $mul = 0.0, $retval$0 = 0.0, $storemerge = 0, $sub = 0, $sub8 = 0, $tobool1 = 0, $x$addr$0 = 0.0, label = 0, sp = 0;
 sp = STACKTOP;
 HEAPF64[tempDoublePtr>>3] = $x;$0 = HEAP32[tempDoublePtr>>2]|0;
 $1 = HEAP32[tempDoublePtr+4>>2]|0;
 $2 = (_bitshift64Lshr(($0|0),($1|0),52)|0);
 $3 = tempRet0;
 $conv = $2 & 2047;
 switch ($conv|0) {
 case 0:  {
  $tobool1 = $x != 0.0;
  if ($tobool1) {
   $mul = $x * 1.8446744073709552E+19;
   $call = (+_frexp($mul,$e));
   $4 = HEAP32[$e>>2]|0;
   $sub = (($4) + -64)|0;
   $storemerge = $sub;$x$addr$0 = $call;
  } else {
   $storemerge = 0;$x$addr$0 = $x;
  }
  HEAP32[$e>>2] = $storemerge;
  $retval$0 = $x$addr$0;
  break;
 }
 case 2047:  {
  $retval$0 = $x;
  break;
 }
 default: {
  $sub8 = (($conv) + -1022)|0;
  HEAP32[$e>>2] = $sub8;
  $5 = $1 & -2146435073;
  $6 = $5 | 1071644672;
  HEAP32[tempDoublePtr>>2] = $0;HEAP32[tempDoublePtr+4>>2] = $6;$7 = +HEAPF64[tempDoublePtr>>3];
  $retval$0 = $7;
 }
 }
 return (+$retval$0);
}
function _frexpl($x,$e) {
 $x = +$x;
 $e = $e|0;
 var $call = 0.0, label = 0, sp = 0;
 sp = STACKTOP;
 $call = (+_frexp($x,$e));
 return (+$call);
}
function _strerror($e) {
 $e = $e|0;
 var $0 = 0, $1 = 0, $arrayidx = 0, $cmp = 0, $conv = 0, $dec = 0, $i$012 = 0, $i$012$lcssa = 0, $i$111 = 0, $inc = 0, $incdec$ptr = 0, $incdec$ptr$lcssa = 0, $s$0$lcssa = 0, $s$010 = 0, $s$1 = 0, $tobool = 0, $tobool5 = 0, $tobool5$9 = 0, $tobool8 = 0, label = 0;
 var sp = 0;
 sp = STACKTOP;
 $i$012 = 0;
 while(1) {
  $arrayidx = (687 + ($i$012)|0);
  $0 = HEAP8[$arrayidx>>0]|0;
  $conv = $0&255;
  $cmp = ($conv|0)==($e|0);
  if ($cmp) {
   $i$012$lcssa = $i$012;
   label = 2;
   break;
  }
  $inc = (($i$012) + 1)|0;
  $tobool = ($inc|0)==(87);
  if ($tobool) {
   $i$111 = 87;$s$010 = 775;
   label = 5;
   break;
  } else {
   $i$012 = $inc;
  }
 }
 if ((label|0) == 2) {
  $tobool5$9 = ($i$012$lcssa|0)==(0);
  if ($tobool5$9) {
   $s$0$lcssa = 775;
  } else {
   $i$111 = $i$012$lcssa;$s$010 = 775;
   label = 5;
  }
 }
 if ((label|0) == 5) {
  while(1) {
   label = 0;
   $s$1 = $s$010;
   while(1) {
    $1 = HEAP8[$s$1>>0]|0;
    $tobool8 = ($1<<24>>24)==(0);
    $incdec$ptr = ((($s$1)) + 1|0);
    if ($tobool8) {
     $incdec$ptr$lcssa = $incdec$ptr;
     break;
    } else {
     $s$1 = $incdec$ptr;
    }
   }
   $dec = (($i$111) + -1)|0;
   $tobool5 = ($dec|0)==(0);
   if ($tobool5) {
    $s$0$lcssa = $incdec$ptr$lcssa;
    break;
   } else {
    $i$111 = $dec;$s$010 = $incdec$ptr$lcssa;
    label = 5;
   }
  }
 }
 return ($s$0$lcssa|0);
}
function ___errno_location() {
 var $0 = 0, $1 = 0, $call$i = 0, $errno_ptr = 0, $retval$0 = 0, $tobool = 0, label = 0, sp = 0;
 sp = STACKTOP;
 $0 = HEAP32[4]|0;
 $tobool = ($0|0)==(0|0);
 if ($tobool) {
  $retval$0 = 60;
 } else {
  $call$i = (_pthread_self()|0);
  $errno_ptr = ((($call$i)) + 60|0);
  $1 = HEAP32[$errno_ptr>>2]|0;
  $retval$0 = $1;
 }
 return ($retval$0|0);
}
function ___stdio_close($f) {
 $f = $f|0;
 var $0 = 0, $call = 0, $call1 = 0, $fd = 0, $vararg_buffer = 0, label = 0, sp = 0;
 sp = STACKTOP;
 STACKTOP = STACKTOP + 16|0; if ((STACKTOP|0) >= (STACK_MAX|0)) abort();
 $vararg_buffer = sp;
 $fd = ((($f)) + 60|0);
 $0 = HEAP32[$fd>>2]|0;
 HEAP32[$vararg_buffer>>2] = $0;
 $call = (___syscall6(6,($vararg_buffer|0))|0);
 $call1 = (___syscall_ret($call)|0);
 STACKTOP = sp;return ($call1|0);
}
function ___stdout_write($f,$buf,$len) {
 $f = $f|0;
 $buf = $buf|0;
 $len = $len|0;
 var $0 = 0, $1 = 0, $and = 0, $call = 0, $call3 = 0, $fd = 0, $lbf = 0, $tio = 0, $tobool = 0, $tobool2 = 0, $vararg_buffer = 0, $vararg_ptr1 = 0, $vararg_ptr2 = 0, $write = 0, label = 0, sp = 0;
 sp = STACKTOP;
 STACKTOP = STACKTOP + 80|0; if ((STACKTOP|0) >= (STACK_MAX|0)) abort();
 $vararg_buffer = sp;
 $tio = sp + 12|0;
 $write = ((($f)) + 36|0);
 HEAP32[$write>>2] = 4;
 $0 = HEAP32[$f>>2]|0;
 $and = $0 & 64;
 $tobool = ($and|0)==(0);
 if ($tobool) {
  $fd = ((($f)) + 60|0);
  $1 = HEAP32[$fd>>2]|0;
  HEAP32[$vararg_buffer>>2] = $1;
  $vararg_ptr1 = ((($vararg_buffer)) + 4|0);
  HEAP32[$vararg_ptr1>>2] = 21505;
  $vararg_ptr2 = ((($vararg_buffer)) + 8|0);
  HEAP32[$vararg_ptr2>>2] = $tio;
  $call = (___syscall54(54,($vararg_buffer|0))|0);
  $tobool2 = ($call|0)==(0);
  if (!($tobool2)) {
   $lbf = ((($f)) + 75|0);
   HEAP8[$lbf>>0] = -1;
  }
 }
 $call3 = (___stdio_write($f,$buf,$len)|0);
 STACKTOP = sp;return ($call3|0);
}
function ___stdio_seek($f,$off,$whence) {
 $f = $f|0;
 $off = $off|0;
 $whence = $whence|0;
 var $$pre = 0, $0 = 0, $1 = 0, $call = 0, $call1 = 0, $cmp = 0, $fd = 0, $ret = 0, $vararg_buffer = 0, $vararg_ptr1 = 0, $vararg_ptr2 = 0, $vararg_ptr3 = 0, $vararg_ptr4 = 0, label = 0, sp = 0;
 sp = STACKTOP;
 STACKTOP = STACKTOP + 32|0; if ((STACKTOP|0) >= (STACK_MAX|0)) abort();
 $vararg_buffer = sp;
 $ret = sp + 20|0;
 $fd = ((($f)) + 60|0);
 $0 = HEAP32[$fd>>2]|0;
 HEAP32[$vararg_buffer>>2] = $0;
 $vararg_ptr1 = ((($vararg_buffer)) + 4|0);
 HEAP32[$vararg_ptr1>>2] = 0;
 $vararg_ptr2 = ((($vararg_buffer)) + 8|0);
 HEAP32[$vararg_ptr2>>2] = $off;
 $vararg_ptr3 = ((($vararg_buffer)) + 12|0);
 HEAP32[$vararg_ptr3>>2] = $ret;
 $vararg_ptr4 = ((($vararg_buffer)) + 16|0);
 HEAP32[$vararg_ptr4>>2] = $whence;
 $call = (___syscall140(140,($vararg_buffer|0))|0);
 $call1 = (___syscall_ret($call)|0);
 $cmp = ($call1|0)<(0);
 if ($cmp) {
  HEAP32[$ret>>2] = -1;
  $1 = -1;
 } else {
  $$pre = HEAP32[$ret>>2]|0;
  $1 = $$pre;
 }
 STACKTOP = sp;return ($1|0);
}
function _fflush($f) {
 $f = $f|0;
 var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0, $5 = 0, $call = 0, $call1 = 0, $call1$18 = 0, $call16 = 0, $call22 = 0, $call7 = 0, $cmp = 0, $cmp14 = 0, $cmp20 = 0, $cond10 = 0, $cond19 = 0, $f$addr$0 = 0, $f$addr$0$19 = 0, $f$addr$022 = 0;
 var $lock = 0, $lock13 = 0, $next = 0, $or = 0, $phitmp = 0, $r$0$lcssa = 0, $r$021 = 0, $r$1 = 0, $retval$0 = 0, $tobool = 0, $tobool11 = 0, $tobool11$20 = 0, $tobool24 = 0, $tobool5 = 0, $wbase = 0, $wpos = 0, label = 0, sp = 0;
 sp = STACKTOP;
 $tobool = ($f|0)==(0|0);
 do {
  if ($tobool) {
   $1 = HEAP32[3]|0;
   $tobool5 = ($1|0)==(0|0);
   if ($tobool5) {
    $cond10 = 0;
   } else {
    $2 = HEAP32[3]|0;
    $call7 = (_fflush($2)|0);
    $cond10 = $call7;
   }
   ___lock(((44)|0));
   $f$addr$0$19 = HEAP32[(40)>>2]|0;
   $tobool11$20 = ($f$addr$0$19|0)==(0|0);
   if ($tobool11$20) {
    $r$0$lcssa = $cond10;
   } else {
    $f$addr$022 = $f$addr$0$19;$r$021 = $cond10;
    while(1) {
     $lock13 = ((($f$addr$022)) + 76|0);
     $3 = HEAP32[$lock13>>2]|0;
     $cmp14 = ($3|0)>(-1);
     if ($cmp14) {
      $call16 = (___lockfile($f$addr$022)|0);
      $cond19 = $call16;
     } else {
      $cond19 = 0;
     }
     $wpos = ((($f$addr$022)) + 20|0);
     $4 = HEAP32[$wpos>>2]|0;
     $wbase = ((($f$addr$022)) + 28|0);
     $5 = HEAP32[$wbase>>2]|0;
     $cmp20 = ($4>>>0)>($5>>>0);
     if ($cmp20) {
      $call22 = (___fflush_unlocked($f$addr$022)|0);
      $or = $call22 | $r$021;
      $r$1 = $or;
     } else {
      $r$1 = $r$021;
     }
     $tobool24 = ($cond19|0)==(0);
     if (!($tobool24)) {
      ___unlockfile($f$addr$022);
     }
     $next = ((($f$addr$022)) + 56|0);
     $f$addr$0 = HEAP32[$next>>2]|0;
     $tobool11 = ($f$addr$0|0)==(0|0);
     if ($tobool11) {
      $r$0$lcssa = $r$1;
      break;
     } else {
      $f$addr$022 = $f$addr$0;$r$021 = $r$1;
     }
    }
   }
   ___unlock(((44)|0));
   $retval$0 = $r$0$lcssa;
  } else {
   $lock = ((($f)) + 76|0);
   $0 = HEAP32[$lock>>2]|0;
   $cmp = ($0|0)>(-1);
   if (!($cmp)) {
    $call1$18 = (___fflush_unlocked($f)|0);
    $retval$0 = $call1$18;
    break;
   }
   $call = (___lockfile($f)|0);
   $phitmp = ($call|0)==(0);
   $call1 = (___fflush_unlocked($f)|0);
   if ($phitmp) {
    $retval$0 = $call1;
   } else {
    ___unlockfile($f);
    $retval$0 = $call1;
   }
  }
 } while(0);
 return ($retval$0|0);
}
function _printf($fmt,$varargs) {
 $fmt = $fmt|0;
 $varargs = $varargs|0;
 var $0 = 0, $ap = 0, $call = 0, label = 0, sp = 0;
 sp = STACKTOP;
 STACKTOP = STACKTOP + 16|0; if ((STACKTOP|0) >= (STACK_MAX|0)) abort();
 $ap = sp;
 HEAP32[$ap>>2] = $varargs;
 $0 = HEAP32[2]|0;
 $call = (_vfprintf($0,$fmt,$ap)|0);
 STACKTOP = sp;return ($call|0);
}
function ___lockfile($f) {
 $f = $f|0;
 var label = 0, sp = 0;
 sp = STACKTOP;
 return 0;
}
function ___unlockfile($f) {
 $f = $f|0;
 var label = 0, sp = 0;
 sp = STACKTOP;
 return;
}
function ___stdio_write($f,$buf,$len) {
 $f = $f|0;
 $buf = $buf|0;
 $len = $len|0;
 var $$pre = 0, $0 = 0, $1 = 0, $10 = 0, $11 = 0, $12 = 0, $13 = 0, $14 = 0, $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $add = 0, $add$ptr = 0, $add$ptr41 = 0, $add$ptr46 = 0;
 var $buf31 = 0, $buf_size = 0, $call = 0, $call10 = 0, $call7 = 0, $call9 = 0, $cmp = 0, $cmp17 = 0, $cmp22 = 0, $cmp29 = 0, $cmp38 = 0, $cnt$0 = 0, $cnt$1 = 0, $dec = 0, $fd8 = 0, $incdec$ptr = 0, $iov$0 = 0, $iov$0$lcssa57 = 0, $iov$1 = 0, $iov_base2 = 0;
 var $iov_len = 0, $iov_len24 = 0, $iov_len28 = 0, $iov_len3 = 0, $iov_len50 = 0, $iov_len50$phi$trans$insert = 0, $iovcnt$0 = 0, $iovcnt$0$lcssa58 = 0, $iovcnt$1 = 0, $iovs = 0, $or = 0, $rem$0 = 0, $retval$0 = 0, $sub = 0, $sub$ptr$sub = 0, $sub26 = 0, $sub36 = 0, $sub51 = 0, $tobool = 0, $vararg_buffer = 0;
 var $vararg_buffer3 = 0, $vararg_ptr1 = 0, $vararg_ptr2 = 0, $vararg_ptr6 = 0, $vararg_ptr7 = 0, $wbase = 0, $wend = 0, $wend19 = 0, $wpos = 0, label = 0, sp = 0;
 sp = STACKTOP;
 STACKTOP = STACKTOP + 48|0; if ((STACKTOP|0) >= (STACK_MAX|0)) abort();
 $vararg_buffer3 = sp + 16|0;
 $vararg_buffer = sp;
 $iovs = sp + 32|0;
 $wbase = ((($f)) + 28|0);
 $0 = HEAP32[$wbase>>2]|0;
 HEAP32[$iovs>>2] = $0;
 $iov_len = ((($iovs)) + 4|0);
 $wpos = ((($f)) + 20|0);
 $1 = HEAP32[$wpos>>2]|0;
 $sub$ptr$sub = (($1) - ($0))|0;
 HEAP32[$iov_len>>2] = $sub$ptr$sub;
 $iov_base2 = ((($iovs)) + 8|0);
 HEAP32[$iov_base2>>2] = $buf;
 $iov_len3 = ((($iovs)) + 12|0);
 HEAP32[$iov_len3>>2] = $len;
 $add = (($sub$ptr$sub) + ($len))|0;
 $fd8 = ((($f)) + 60|0);
 $buf31 = ((($f)) + 44|0);
 $iov$0 = $iovs;$iovcnt$0 = 2;$rem$0 = $add;
 while(1) {
  $2 = HEAP32[4]|0;
  $tobool = ($2|0)==(0|0);
  if ($tobool) {
   $4 = HEAP32[$fd8>>2]|0;
   HEAP32[$vararg_buffer3>>2] = $4;
   $vararg_ptr6 = ((($vararg_buffer3)) + 4|0);
   HEAP32[$vararg_ptr6>>2] = $iov$0;
   $vararg_ptr7 = ((($vararg_buffer3)) + 8|0);
   HEAP32[$vararg_ptr7>>2] = $iovcnt$0;
   $call9 = (___syscall146(146,($vararg_buffer3|0))|0);
   $call10 = (___syscall_ret($call9)|0);
   $cnt$0 = $call10;
  } else {
   _pthread_cleanup_push((5|0),($f|0));
   $3 = HEAP32[$fd8>>2]|0;
   HEAP32[$vararg_buffer>>2] = $3;
   $vararg_ptr1 = ((($vararg_buffer)) + 4|0);
   HEAP32[$vararg_ptr1>>2] = $iov$0;
   $vararg_ptr2 = ((($vararg_buffer)) + 8|0);
   HEAP32[$vararg_ptr2>>2] = $iovcnt$0;
   $call = (___syscall146(146,($vararg_buffer|0))|0);
   $call7 = (___syscall_ret($call)|0);
   _pthread_cleanup_pop(0);
   $cnt$0 = $call7;
  }
  $cmp = ($rem$0|0)==($cnt$0|0);
  if ($cmp) {
   label = 6;
   break;
  }
  $cmp17 = ($cnt$0|0)<(0);
  if ($cmp17) {
   $iov$0$lcssa57 = $iov$0;$iovcnt$0$lcssa58 = $iovcnt$0;
   label = 8;
   break;
  }
  $sub26 = (($rem$0) - ($cnt$0))|0;
  $iov_len28 = ((($iov$0)) + 4|0);
  $10 = HEAP32[$iov_len28>>2]|0;
  $cmp29 = ($cnt$0>>>0)>($10>>>0);
  if ($cmp29) {
   $11 = HEAP32[$buf31>>2]|0;
   HEAP32[$wbase>>2] = $11;
   HEAP32[$wpos>>2] = $11;
   $sub36 = (($cnt$0) - ($10))|0;
   $incdec$ptr = ((($iov$0)) + 8|0);
   $dec = (($iovcnt$0) + -1)|0;
   $iov_len50$phi$trans$insert = ((($iov$0)) + 12|0);
   $$pre = HEAP32[$iov_len50$phi$trans$insert>>2]|0;
   $14 = $$pre;$cnt$1 = $sub36;$iov$1 = $incdec$ptr;$iovcnt$1 = $dec;
  } else {
   $cmp38 = ($iovcnt$0|0)==(2);
   if ($cmp38) {
    $12 = HEAP32[$wbase>>2]|0;
    $add$ptr41 = (($12) + ($cnt$0)|0);
    HEAP32[$wbase>>2] = $add$ptr41;
    $14 = $10;$cnt$1 = $cnt$0;$iov$1 = $iov$0;$iovcnt$1 = 2;
   } else {
    $14 = $10;$cnt$1 = $cnt$0;$iov$1 = $iov$0;$iovcnt$1 = $iovcnt$0;
   }
  }
  $13 = HEAP32[$iov$1>>2]|0;
  $add$ptr46 = (($13) + ($cnt$1)|0);
  HEAP32[$iov$1>>2] = $add$ptr46;
  $iov_len50 = ((($iov$1)) + 4|0);
  $sub51 = (($14) - ($cnt$1))|0;
  HEAP32[$iov_len50>>2] = $sub51;
  $iov$0 = $iov$1;$iovcnt$0 = $iovcnt$1;$rem$0 = $sub26;
 }
 if ((label|0) == 6) {
  $5 = HEAP32[$buf31>>2]|0;
  $buf_size = ((($f)) + 48|0);
  $6 = HEAP32[$buf_size>>2]|0;
  $add$ptr = (($5) + ($6)|0);
  $wend = ((($f)) + 16|0);
  HEAP32[$wend>>2] = $add$ptr;
  $7 = $5;
  HEAP32[$wbase>>2] = $7;
  HEAP32[$wpos>>2] = $7;
  $retval$0 = $len;
 }
 else if ((label|0) == 8) {
  $wend19 = ((($f)) + 16|0);
  HEAP32[$wend19>>2] = 0;
  HEAP32[$wbase>>2] = 0;
  HEAP32[$wpos>>2] = 0;
  $8 = HEAP32[$f>>2]|0;
  $or = $8 | 32;
  HEAP32[$f>>2] = $or;
  $cmp22 = ($iovcnt$0$lcssa58|0)==(2);
  if ($cmp22) {
   $retval$0 = 0;
  } else {
   $iov_len24 = ((($iov$0$lcssa57)) + 4|0);
   $9 = HEAP32[$iov_len24>>2]|0;
   $sub = (($len) - ($9))|0;
   $retval$0 = $sub;
  }
 }
 STACKTOP = sp;return ($retval$0|0);
}
function _vfprintf($f,$fmt,$ap) {
 $f = $f|0;
 $fmt = $fmt|0;
 $ap = $ap|0;
 var $$call21 = 0, $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0, $7 = 0, $add$ptr = 0, $and = 0, $and11 = 0, $and36 = 0, $ap2 = 0, $buf = 0, $buf_size = 0, $call = 0, $call21 = 0, $call21$30 = 0, $call6 = 0;
 var $cmp = 0, $cmp5 = 0, $cmp7 = 0, $cond = 0, $internal_buf = 0, $lock = 0, $mode = 0, $nl_arg = 0, $nl_type = 0, $or = 0, $ret$1 = 0, $ret$1$ = 0, $retval$0 = 0, $tobool = 0, $tobool22 = 0, $tobool26 = 0, $tobool37 = 0, $tobool41 = 0, $vacopy_currentptr = 0, $wbase = 0;
 var $wend = 0, $wpos = 0, $write = 0, dest = 0, label = 0, sp = 0, stop = 0;
 sp = STACKTOP;
 STACKTOP = STACKTOP + 224|0; if ((STACKTOP|0) >= (STACK_MAX|0)) abort();
 $ap2 = sp + 120|0;
 $nl_type = sp + 80|0;
 $nl_arg = sp;
 $internal_buf = sp + 136|0;
 dest=$nl_type; stop=dest+40|0; do { HEAP32[dest>>2]=0|0; dest=dest+4|0; } while ((dest|0) < (stop|0));
 $vacopy_currentptr = HEAP32[$ap>>2]|0;
 HEAP32[$ap2>>2] = $vacopy_currentptr;
 $call = (_printf_core(0,$fmt,$ap2,$nl_arg,$nl_type)|0);
 $cmp = ($call|0)<(0);
 if ($cmp) {
  $retval$0 = -1;
 } else {
  $lock = ((($f)) + 76|0);
  $0 = HEAP32[$lock>>2]|0;
  $cmp5 = ($0|0)>(-1);
  if ($cmp5) {
   $call6 = (___lockfile($f)|0);
   $cond = $call6;
  } else {
   $cond = 0;
  }
  $1 = HEAP32[$f>>2]|0;
  $and = $1 & 32;
  $mode = ((($f)) + 74|0);
  $2 = HEAP8[$mode>>0]|0;
  $cmp7 = ($2<<24>>24)<(1);
  if ($cmp7) {
   $and11 = $1 & -33;
   HEAP32[$f>>2] = $and11;
  }
  $buf_size = ((($f)) + 48|0);
  $3 = HEAP32[$buf_size>>2]|0;
  $tobool = ($3|0)==(0);
  if ($tobool) {
   $buf = ((($f)) + 44|0);
   $4 = HEAP32[$buf>>2]|0;
   HEAP32[$buf>>2] = $internal_buf;
   $wbase = ((($f)) + 28|0);
   HEAP32[$wbase>>2] = $internal_buf;
   $wpos = ((($f)) + 20|0);
   HEAP32[$wpos>>2] = $internal_buf;
   HEAP32[$buf_size>>2] = 80;
   $add$ptr = ((($internal_buf)) + 80|0);
   $wend = ((($f)) + 16|0);
   HEAP32[$wend>>2] = $add$ptr;
   $call21 = (_printf_core($f,$fmt,$ap2,$nl_arg,$nl_type)|0);
   $tobool22 = ($4|0)==(0|0);
   if ($tobool22) {
    $ret$1 = $call21;
   } else {
    $write = ((($f)) + 36|0);
    $5 = HEAP32[$write>>2]|0;
    (FUNCTION_TABLE_iiii[$5 & 7]($f,0,0)|0);
    $6 = HEAP32[$wpos>>2]|0;
    $tobool26 = ($6|0)==(0|0);
    $$call21 = $tobool26 ? -1 : $call21;
    HEAP32[$buf>>2] = $4;
    HEAP32[$buf_size>>2] = 0;
    HEAP32[$wend>>2] = 0;
    HEAP32[$wbase>>2] = 0;
    HEAP32[$wpos>>2] = 0;
    $ret$1 = $$call21;
   }
  } else {
   $call21$30 = (_printf_core($f,$fmt,$ap2,$nl_arg,$nl_type)|0);
   $ret$1 = $call21$30;
  }
  $7 = HEAP32[$f>>2]|0;
  $and36 = $7 & 32;
  $tobool37 = ($and36|0)==(0);
  $ret$1$ = $tobool37 ? $ret$1 : -1;
  $or = $7 | $and;
  HEAP32[$f>>2] = $or;
  $tobool41 = ($cond|0)==(0);
  if (!($tobool41)) {
   ___unlockfile($f);
  }
  $retval$0 = $ret$1$;
 }
 STACKTOP = sp;return ($retval$0|0);
}
function ___fwritex($s,$l,$f) {
 $s = $s|0;
 $l = $l|0;
 $f = $f|0;
 var $$pre = 0, $$pre31 = 0, $0 = 0, $1 = 0, $10 = 0, $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0, $9 = 0, $add = 0, $add$ptr = 0, $add$ptr26 = 0, $arrayidx = 0, $call = 0, $call16 = 0, $call4 = 0;
 var $cmp = 0, $cmp11 = 0, $cmp17 = 0, $cmp6 = 0, $i$0 = 0, $i$0$lcssa36 = 0, $i$1 = 0, $l$addr$0 = 0, $lbf = 0, $retval$0 = 0, $s$addr$0 = 0, $sub = 0, $sub$ptr$sub = 0, $sub21 = 0, $tobool = 0, $tobool1 = 0, $tobool9 = 0, $wend = 0, $wpos = 0, $write = 0;
 var $write15 = 0, label = 0, sp = 0;
 sp = STACKTOP;
 $wend = ((($f)) + 16|0);
 $0 = HEAP32[$wend>>2]|0;
 $tobool = ($0|0)==(0|0);
 if ($tobool) {
  $call = (___towrite($f)|0);
  $tobool1 = ($call|0)==(0);
  if ($tobool1) {
   $$pre = HEAP32[$wend>>2]|0;
   $3 = $$pre;
   label = 5;
  } else {
   $retval$0 = 0;
  }
 } else {
  $1 = $0;
  $3 = $1;
  label = 5;
 }
 L5: do {
  if ((label|0) == 5) {
   $wpos = ((($f)) + 20|0);
   $2 = HEAP32[$wpos>>2]|0;
   $sub$ptr$sub = (($3) - ($2))|0;
   $cmp = ($sub$ptr$sub>>>0)<($l>>>0);
   $4 = $2;
   if ($cmp) {
    $write = ((($f)) + 36|0);
    $5 = HEAP32[$write>>2]|0;
    $call4 = (FUNCTION_TABLE_iiii[$5 & 7]($f,$s,$l)|0);
    $retval$0 = $call4;
    break;
   }
   $lbf = ((($f)) + 75|0);
   $6 = HEAP8[$lbf>>0]|0;
   $cmp6 = ($6<<24>>24)>(-1);
   L10: do {
    if ($cmp6) {
     $i$0 = $l;
     while(1) {
      $tobool9 = ($i$0|0)==(0);
      if ($tobool9) {
       $9 = $4;$i$1 = 0;$l$addr$0 = $l;$s$addr$0 = $s;
       break L10;
      }
      $sub = (($i$0) + -1)|0;
      $arrayidx = (($s) + ($sub)|0);
      $7 = HEAP8[$arrayidx>>0]|0;
      $cmp11 = ($7<<24>>24)==(10);
      if ($cmp11) {
       $i$0$lcssa36 = $i$0;
       break;
      } else {
       $i$0 = $sub;
      }
     }
     $write15 = ((($f)) + 36|0);
     $8 = HEAP32[$write15>>2]|0;
     $call16 = (FUNCTION_TABLE_iiii[$8 & 7]($f,$s,$i$0$lcssa36)|0);
     $cmp17 = ($call16>>>0)<($i$0$lcssa36>>>0);
     if ($cmp17) {
      $retval$0 = $i$0$lcssa36;
      break L5;
     }
     $add$ptr = (($s) + ($i$0$lcssa36)|0);
     $sub21 = (($l) - ($i$0$lcssa36))|0;
     $$pre31 = HEAP32[$wpos>>2]|0;
     $9 = $$pre31;$i$1 = $i$0$lcssa36;$l$addr$0 = $sub21;$s$addr$0 = $add$ptr;
    } else {
     $9 = $4;$i$1 = 0;$l$addr$0 = $l;$s$addr$0 = $s;
    }
   } while(0);
   _memcpy(($9|0),($s$addr$0|0),($l$addr$0|0))|0;
   $10 = HEAP32[$wpos>>2]|0;
   $add$ptr26 = (($10) + ($l$addr$0)|0);
   HEAP32[$wpos>>2] = $add$ptr26;
   $add = (($i$1) + ($l$addr$0))|0;
   $retval$0 = $add;
  }
 } while(0);
 return ($retval$0|0);
}
function ___towrite($f) {
 $f = $f|0;
 var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0, $add$ptr = 0, $and = 0, $buf = 0, $buf_size = 0, $conv = 0, $conv3 = 0, $mode = 0, $or = 0, $or5 = 0, $rend = 0, $retval$0 = 0, $rpos = 0, $sub = 0, $tobool = 0, $wbase = 0;
 var $wend = 0, $wpos = 0, label = 0, sp = 0;
 sp = STACKTOP;
 $mode = ((($f)) + 74|0);
 $0 = HEAP8[$mode>>0]|0;
 $conv = $0 << 24 >> 24;
 $sub = (($conv) + 255)|0;
 $or = $sub | $conv;
 $conv3 = $or&255;
 HEAP8[$mode>>0] = $conv3;
 $1 = HEAP32[$f>>2]|0;
 $and = $1 & 8;
 $tobool = ($and|0)==(0);
 if ($tobool) {
  $rend = ((($f)) + 8|0);
  HEAP32[$rend>>2] = 0;
  $rpos = ((($f)) + 4|0);
  HEAP32[$rpos>>2] = 0;
  $buf = ((($f)) + 44|0);
  $2 = HEAP32[$buf>>2]|0;
  $wbase = ((($f)) + 28|0);
  HEAP32[$wbase>>2] = $2;
  $wpos = ((($f)) + 20|0);
  HEAP32[$wpos>>2] = $2;
  $3 = $2;
  $buf_size = ((($f)) + 48|0);
  $4 = HEAP32[$buf_size>>2]|0;
  $add$ptr = (($3) + ($4)|0);
  $wend = ((($f)) + 16|0);
  HEAP32[$wend>>2] = $add$ptr;
  $retval$0 = 0;
 } else {
  $or5 = $1 | 32;
  HEAP32[$f>>2] = $or5;
  $retval$0 = -1;
 }
 return ($retval$0|0);
}
function _wcrtomb($s,$wc,$st) {
 $s = $s|0;
 $wc = $wc|0;
 $st = $st|0;
 var $0 = 0, $and = 0, $and19 = 0, $and23 = 0, $and36 = 0, $and41 = 0, $and45 = 0, $call = 0, $cmp = 0, $cmp11 = 0, $cmp2 = 0, $cmp28 = 0, $cmp9 = 0, $conv = 0, $conv16 = 0, $conv21 = 0, $conv25 = 0, $conv33 = 0, $conv38 = 0, $conv43 = 0;
 var $conv47 = 0, $conv5 = 0, $conv7 = 0, $incdec$ptr = 0, $incdec$ptr17 = 0, $incdec$ptr22 = 0, $incdec$ptr34 = 0, $incdec$ptr39 = 0, $incdec$ptr44 = 0, $or = 0, $or$cond = 0, $or15 = 0, $or20 = 0, $or24 = 0, $or32 = 0, $or37 = 0, $or42 = 0, $or46 = 0, $or6 = 0, $retval$0 = 0;
 var $shr$28 = 0, $shr14$26 = 0, $shr18$27 = 0, $shr31$23 = 0, $shr35$24 = 0, $shr40$25 = 0, $sub27 = 0, $tobool = 0, label = 0, sp = 0;
 sp = STACKTOP;
 $tobool = ($s|0)==(0|0);
 do {
  if ($tobool) {
   $retval$0 = 1;
  } else {
   $cmp = ($wc>>>0)<(128);
   if ($cmp) {
    $conv = $wc&255;
    HEAP8[$s>>0] = $conv;
    $retval$0 = 1;
    break;
   }
   $cmp2 = ($wc>>>0)<(2048);
   if ($cmp2) {
    $shr$28 = $wc >>> 6;
    $or = $shr$28 | 192;
    $conv5 = $or&255;
    $incdec$ptr = ((($s)) + 1|0);
    HEAP8[$s>>0] = $conv5;
    $and = $wc & 63;
    $or6 = $and | 128;
    $conv7 = $or6&255;
    HEAP8[$incdec$ptr>>0] = $conv7;
    $retval$0 = 2;
    break;
   }
   $cmp9 = ($wc>>>0)<(55296);
   $0 = $wc & -8192;
   $cmp11 = ($0|0)==(57344);
   $or$cond = $cmp9 | $cmp11;
   if ($or$cond) {
    $shr14$26 = $wc >>> 12;
    $or15 = $shr14$26 | 224;
    $conv16 = $or15&255;
    $incdec$ptr17 = ((($s)) + 1|0);
    HEAP8[$s>>0] = $conv16;
    $shr18$27 = $wc >>> 6;
    $and19 = $shr18$27 & 63;
    $or20 = $and19 | 128;
    $conv21 = $or20&255;
    $incdec$ptr22 = ((($s)) + 2|0);
    HEAP8[$incdec$ptr17>>0] = $conv21;
    $and23 = $wc & 63;
    $or24 = $and23 | 128;
    $conv25 = $or24&255;
    HEAP8[$incdec$ptr22>>0] = $conv25;
    $retval$0 = 3;
    break;
   }
   $sub27 = (($wc) + -65536)|0;
   $cmp28 = ($sub27>>>0)<(1048576);
   if ($cmp28) {
    $shr31$23 = $wc >>> 18;
    $or32 = $shr31$23 | 240;
    $conv33 = $or32&255;
    $incdec$ptr34 = ((($s)) + 1|0);
    HEAP8[$s>>0] = $conv33;
    $shr35$24 = $wc >>> 12;
    $and36 = $shr35$24 & 63;
    $or37 = $and36 | 128;
    $conv38 = $or37&255;
    $incdec$ptr39 = ((($s)) + 2|0);
    HEAP8[$incdec$ptr34>>0] = $conv38;
    $shr40$25 = $wc >>> 6;
    $and41 = $shr40$25 & 63;
    $or42 = $and41 | 128;
    $conv43 = $or42&255;
    $incdec$ptr44 = ((($s)) + 3|0);
    HEAP8[$incdec$ptr39>>0] = $conv43;
    $and45 = $wc & 63;
    $or46 = $and45 | 128;
    $conv47 = $or46&255;
    HEAP8[$incdec$ptr44>>0] = $conv47;
    $retval$0 = 4;
    break;
   } else {
    $call = (___errno_location()|0);
    HEAP32[$call>>2] = 84;
    $retval$0 = -1;
    break;
   }
  }
 } while(0);
 return ($retval$0|0);
}
function _wctomb($s,$wc) {
 $s = $s|0;
 $wc = $wc|0;
 var $call = 0, $retval$0 = 0, $tobool = 0, label = 0, sp = 0;
 sp = STACKTOP;
 $tobool = ($s|0)==(0|0);
 if ($tobool) {
  $retval$0 = 0;
 } else {
  $call = (_wcrtomb($s,$wc,0)|0);
  $retval$0 = $call;
 }
 return ($retval$0|0);
}
function _memchr($src,$c,$n) {
 $src = $src|0;
 $c = $c|0;
 $n = $n|0;
 var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0, $7 = 0, $and = 0, $and$39 = 0, $and15 = 0, $and16 = 0, $cmp = 0, $cmp11 = 0, $cmp11$32 = 0, $cmp28 = 0, $cmp8 = 0, $cond = 0, $conv1 = 0, $dec = 0;
 var $dec34 = 0, $incdec$ptr = 0, $incdec$ptr21 = 0, $incdec$ptr33 = 0, $lnot = 0, $mul = 0, $n$addr$0$lcssa = 0, $n$addr$0$lcssa61 = 0, $n$addr$043 = 0, $n$addr$1$lcssa = 0, $n$addr$133 = 0, $n$addr$133$lcssa = 0, $n$addr$227 = 0, $n$addr$3 = 0, $neg = 0, $or$cond = 0, $or$cond$42 = 0, $s$0$lcssa = 0, $s$0$lcssa60 = 0, $s$044 = 0;
 var $s$128 = 0, $s$2 = 0, $sub = 0, $sub22 = 0, $tobool = 0, $tobool$40 = 0, $tobool2 = 0, $tobool2$41 = 0, $tobool2$lcssa = 0, $tobool25 = 0, $tobool25$26 = 0, $tobool36 = 0, $w$0$lcssa = 0, $w$034 = 0, $w$034$lcssa = 0, $xor = 0, label = 0, sp = 0;
 sp = STACKTOP;
 $conv1 = $c & 255;
 $0 = $src;
 $and$39 = $0 & 3;
 $tobool$40 = ($and$39|0)!=(0);
 $tobool2$41 = ($n|0)!=(0);
 $or$cond$42 = $tobool2$41 & $tobool$40;
 L1: do {
  if ($or$cond$42) {
   $1 = $c&255;
   $n$addr$043 = $n;$s$044 = $src;
   while(1) {
    $2 = HEAP8[$s$044>>0]|0;
    $cmp = ($2<<24>>24)==($1<<24>>24);
    if ($cmp) {
     $n$addr$0$lcssa61 = $n$addr$043;$s$0$lcssa60 = $s$044;
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
   $n$addr$0$lcssa = $n;$s$0$lcssa = $src;$tobool2$lcssa = $tobool2$41;
   label = 5;
  }
 } while(0);
 if ((label|0) == 5) {
  if ($tobool2$lcssa) {
   $n$addr$0$lcssa61 = $n$addr$0$lcssa;$s$0$lcssa60 = $s$0$lcssa;
   label = 6;
  } else {
   $n$addr$3 = 0;$s$2 = $s$0$lcssa;
  }
 }
 L8: do {
  if ((label|0) == 6) {
   $4 = HEAP8[$s$0$lcssa60>>0]|0;
   $5 = $c&255;
   $cmp8 = ($4<<24>>24)==($5<<24>>24);
   if ($cmp8) {
    $n$addr$3 = $n$addr$0$lcssa61;$s$2 = $s$0$lcssa60;
   } else {
    $mul = Math_imul($conv1, 16843009)|0;
    $cmp11$32 = ($n$addr$0$lcssa61>>>0)>(3);
    L11: do {
     if ($cmp11$32) {
      $n$addr$133 = $n$addr$0$lcssa61;$w$034 = $s$0$lcssa60;
      while(1) {
       $6 = HEAP32[$w$034>>2]|0;
       $xor = $6 ^ $mul;
       $sub = (($xor) + -16843009)|0;
       $neg = $xor & -2139062144;
       $and15 = $neg ^ -2139062144;
       $and16 = $and15 & $sub;
       $lnot = ($and16|0)==(0);
       if (!($lnot)) {
        $n$addr$133$lcssa = $n$addr$133;$w$034$lcssa = $w$034;
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
      $n$addr$227 = $n$addr$133$lcssa;$s$128 = $w$034$lcssa;
     } else {
      $n$addr$1$lcssa = $n$addr$0$lcssa61;$w$0$lcssa = $s$0$lcssa60;
      label = 11;
     }
    } while(0);
    if ((label|0) == 11) {
     $tobool25$26 = ($n$addr$1$lcssa|0)==(0);
     if ($tobool25$26) {
      $n$addr$3 = 0;$s$2 = $w$0$lcssa;
      break;
     } else {
      $n$addr$227 = $n$addr$1$lcssa;$s$128 = $w$0$lcssa;
     }
    }
    while(1) {
     $7 = HEAP8[$s$128>>0]|0;
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
function ___syscall_ret($r) {
 $r = $r|0;
 var $call = 0, $cmp = 0, $retval$0 = 0, $sub = 0, label = 0, sp = 0;
 sp = STACKTOP;
 $cmp = ($r>>>0)>(4294963200);
 if ($cmp) {
  $sub = (0 - ($r))|0;
  $call = (___errno_location()|0);
  HEAP32[$call>>2] = $sub;
  $retval$0 = -1;
 } else {
  $retval$0 = $r;
 }
 return ($retval$0|0);
}
function ___fflush_unlocked($f) {
 $f = $f|0;
 var $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0, $cmp = 0, $cmp4 = 0, $rend = 0, $retval$0 = 0, $rpos = 0, $seek = 0, $sub$ptr$lhs$cast = 0, $sub$ptr$rhs$cast = 0, $sub$ptr$sub = 0, $tobool = 0, $wbase = 0, $wend = 0, $wpos = 0;
 var $write = 0, label = 0, sp = 0;
 sp = STACKTOP;
 $wpos = ((($f)) + 20|0);
 $0 = HEAP32[$wpos>>2]|0;
 $wbase = ((($f)) + 28|0);
 $1 = HEAP32[$wbase>>2]|0;
 $cmp = ($0>>>0)>($1>>>0);
 if ($cmp) {
  $write = ((($f)) + 36|0);
  $2 = HEAP32[$write>>2]|0;
  (FUNCTION_TABLE_iiii[$2 & 7]($f,0,0)|0);
  $3 = HEAP32[$wpos>>2]|0;
  $tobool = ($3|0)==(0|0);
  if ($tobool) {
   $retval$0 = -1;
  } else {
   label = 3;
  }
 } else {
  label = 3;
 }
 if ((label|0) == 3) {
  $rpos = ((($f)) + 4|0);
  $4 = HEAP32[$rpos>>2]|0;
  $rend = ((($f)) + 8|0);
  $5 = HEAP32[$rend>>2]|0;
  $cmp4 = ($4>>>0)<($5>>>0);
  if ($cmp4) {
   $seek = ((($f)) + 40|0);
   $6 = HEAP32[$seek>>2]|0;
   $sub$ptr$lhs$cast = $4;
   $sub$ptr$rhs$cast = $5;
   $sub$ptr$sub = (($sub$ptr$lhs$cast) - ($sub$ptr$rhs$cast))|0;
   (FUNCTION_TABLE_iiii[$6 & 7]($f,$sub$ptr$sub,1)|0);
  }
  $wend = ((($f)) + 16|0);
  HEAP32[$wend>>2] = 0;
  HEAP32[$wbase>>2] = 0;
  HEAP32[$wpos>>2] = 0;
  HEAP32[$rend>>2] = 0;
  HEAP32[$rpos>>2] = 0;
  $retval$0 = 0;
 }
 return ($retval$0|0);
}
function _cleanup($p) {
 $p = $p|0;
 var $0 = 0, $lockcount = 0, $tobool = 0, label = 0, sp = 0;
 sp = STACKTOP;
 $lockcount = ((($p)) + 68|0);
 $0 = HEAP32[$lockcount>>2]|0;
 $tobool = ($0|0)==(0);
 if ($tobool) {
  ___unlockfile($p);
 }
 return;
}
function _printf_core($f,$fmt,$ap,$nl_arg,$nl_type) {
 $f = $f|0;
 $fmt = $fmt|0;
 $ap = $ap|0;
 $nl_arg = $nl_arg|0;
 $nl_type = $nl_type|0;
 var $$ = 0, $$$i = 0, $$396$i = 0.0, $$404$i = 0.0, $$l10n$0 = 0, $$lcssa = 0, $$p$i = 0, $$p$inc468$i = 0, $$pr$i = 0, $$pr477$i = 0, $$pre = 0, $$pre$i = 0, $$pre357 = 0, $$pre564$i = 0, $$pre566$i = 0, $$pre567$i = 0, $$sub514$i = 0, $$sub562$i = 0, $0 = 0, $1 = 0;
 var $10 = 0, $100 = 0, $101 = 0, $102 = 0, $103 = 0, $104 = 0, $105 = 0, $106 = 0, $107 = 0, $108 = 0, $109 = 0, $11 = 0, $110 = 0, $111 = 0, $112 = 0, $113 = 0, $114 = 0, $115 = 0, $116 = 0, $117 = 0;
 var $118 = 0, $119 = 0, $12 = 0, $120 = 0, $121 = 0, $122 = 0, $123 = 0, $124 = 0, $125 = 0, $126 = 0, $127 = 0, $128 = 0, $129 = 0, $13 = 0, $130 = 0, $131 = 0, $132 = 0, $133 = 0, $134 = 0, $135 = 0;
 var $136 = 0, $137 = 0, $138 = 0, $139 = 0, $14 = 0, $140 = 0, $141 = 0, $142 = 0, $143 = 0, $144 = 0, $145 = 0, $146 = 0, $147 = 0, $148 = 0, $149 = 0, $15 = 0, $150 = 0, $151 = 0, $152 = 0, $153 = 0;
 var $154 = 0, $155 = 0, $156 = 0, $157 = 0, $158 = 0, $159 = 0, $16 = 0, $160 = 0, $161 = 0, $162 = 0, $163 = 0, $164 = 0, $165 = 0, $166 = 0, $167 = 0, $168 = 0, $169 = 0, $17 = 0, $170 = 0, $171 = 0;
 var $172 = 0, $173 = 0, $174 = 0, $175 = 0, $176 = 0, $177 = 0, $178 = 0, $179 = 0, $18 = 0, $180 = 0, $181 = 0.0, $182 = 0, $183 = 0, $184 = 0, $185 = 0, $186 = 0, $187 = 0, $188 = 0, $189 = 0, $19 = 0;
 var $190 = 0, $191 = 0, $192 = 0, $193 = 0, $194 = 0, $195 = 0, $196 = 0, $197 = 0, $198 = 0, $199 = 0, $2 = 0, $20 = 0, $200 = 0, $201 = 0, $202 = 0, $203 = 0, $204 = 0, $205 = 0, $206 = 0, $207 = 0;
 var $208 = 0, $209 = 0, $21 = 0, $210 = 0, $211 = 0, $212 = 0, $213 = 0, $214 = 0, $215 = 0, $216 = 0, $217 = 0, $218 = 0, $219 = 0, $22 = 0, $220 = 0, $221 = 0, $222 = 0, $223 = 0, $224 = 0, $225 = 0;
 var $226 = 0, $227 = 0, $228 = 0, $229 = 0, $23 = 0, $230 = 0, $231 = 0, $232 = 0, $233 = 0, $234 = 0, $235 = 0, $236 = 0, $237 = 0, $238 = 0, $239 = 0, $24 = 0, $240 = 0, $241 = 0, $242 = 0, $243 = 0;
 var $244 = 0, $245 = 0, $246 = 0, $247 = 0, $248 = 0, $249 = 0, $25 = 0, $250 = 0, $251 = 0, $252 = 0, $253 = 0, $254 = 0, $255 = 0, $256 = 0, $257 = 0, $258 = 0, $259 = 0, $26 = 0, $260 = 0, $261 = 0;
 var $262 = 0, $263 = 0, $264 = 0, $265 = 0, $266 = 0, $267 = 0, $268 = 0, $27 = 0, $28 = 0, $29 = 0, $3 = 0, $30 = 0, $31 = 0, $32 = 0, $33 = 0, $34 = 0, $35 = 0, $36 = 0, $37 = 0, $38 = 0;
 var $39 = 0, $4 = 0, $40 = 0, $41 = 0, $42 = 0, $43 = 0, $44 = 0, $45 = 0, $46 = 0, $47 = 0, $48 = 0, $49 = 0, $5 = 0, $50 = 0, $51 = 0, $52 = 0, $53 = 0, $54 = 0, $55 = 0, $56 = 0;
 var $57 = 0, $58 = 0, $59 = 0, $6 = 0, $60 = 0, $61 = 0, $62 = 0, $63 = 0, $64 = 0, $65 = 0, $66 = 0, $67 = 0, $68 = 0, $69 = 0, $7 = 0, $70 = 0, $71 = 0, $72 = 0, $73 = 0, $74 = 0;
 var $75 = 0, $76 = 0, $77 = 0, $78 = 0, $79 = 0, $8 = 0, $80 = 0, $81 = 0, $82 = 0, $83 = 0, $84 = 0, $85 = 0, $86 = 0, $87 = 0, $88 = 0, $89 = 0, $9 = 0, $90 = 0, $91 = 0, $92 = 0;
 var $93 = 0, $94 = 0, $95 = 0, $96 = 0, $97 = 0, $98 = 0, $99 = 0, $a$0 = 0, $a$1 = 0, $a$1$lcssa$i = 0, $a$1549$i = 0, $a$2 = 0, $a$2$ph$i = 0, $a$3$lcssa$i = 0, $a$3539$i = 0, $a$5$lcssa$i = 0, $a$5521$i = 0, $a$6$i = 0, $a$8$i = 0, $a$9$ph$i = 0;
 var $add = 0, $add$i = 0, $add$i$203 = 0, $add$i$239 = 0, $add$i$lcssa = 0, $add$ptr = 0, $add$ptr139 = 0, $add$ptr205 = 0, $add$ptr213$i = 0, $add$ptr257 = 0, $add$ptr311$i = 0, $add$ptr311$z$4$i = 0, $add$ptr340 = 0, $add$ptr354$i = 0, $add$ptr358$i = 0, $add$ptr359 = 0, $add$ptr373$i = 0, $add$ptr43 = 0, $add$ptr43$arrayidx31 = 0, $add$ptr442$i = 0;
 var $add$ptr442$z$3$i = 0, $add$ptr473 = 0, $add$ptr65$i = 0, $add$ptr671$i = 0, $add$ptr742$i = 0, $add$ptr88 = 0, $add113$i = 0, $add150$i = 0, $add154$i = 0, $add163$i = 0, $add165$i = 0, $add269 = 0, $add269$p$0 = 0, $add273$i = 0, $add275$i = 0, $add284$i = 0, $add313$i = 0, $add322 = 0, $add355$i = 0, $add395 = 0;
 var $add410$i = 0.0, $add412 = 0, $add414$i = 0, $add441 = 0, $add477$neg$i = 0, $add561$i = 0, $add608$i = 0, $add612$i = 0, $add620$i = 0, $add653$i = 0, $add67$i = 0, $add737$i = 0, $add810$i = 0, $add87$i = 0.0, $add90$i = 0.0, $and = 0, $and$i = 0, $and$i$216 = 0, $and$i$231 = 0, $and$i$238 = 0;
 var $and$i$244 = 0, $and$i$406$i = 0, $and$i$412$i = 0, $and$i$418$i = 0, $and$i$424$i = 0, $and$i$430$i = 0, $and$i$436$i = 0, $and$i$442$i = 0, $and$i$448$i = 0, $and$i$454$i = 0, $and$i$460$i = 0, $and$i$466$i = 0, $and$i$472$i = 0, $and$i$i = 0, $and12$i = 0, $and134$i = 0, $and210 = 0, $and214 = 0, $and216 = 0, $and219 = 0;
 var $and249 = 0, $and254 = 0, $and263 = 0, $and282$i = 0, $and289 = 0, $and294 = 0, $and309 = 0, $and309$fl$4 = 0, $and36$i = 0, $and379$i = 0, $and483$i = 0, $and610$pre$phi$iZ2D = 0, $and62$i = 0, $arg = 0, $arglist_current = 0, $arglist_current2 = 0, $arglist_next = 0, $arglist_next3 = 0, $argpos$0 = 0, $arraydecay208$add$ptr213$i = 0;
 var $arrayidx$i = 0, $arrayidx$i$236 = 0, $arrayidx114 = 0, $arrayidx117$i = 0, $arrayidx119 = 0, $arrayidx124 = 0, $arrayidx132 = 0, $arrayidx16 = 0, $arrayidx173 = 0, $arrayidx192 = 0, $arrayidx251$i = 0, $arrayidx31 = 0, $arrayidx35 = 0, $arrayidx370 = 0, $arrayidx453$i = 0, $arrayidx469 = 0, $arrayidx481 = 0, $arrayidx489$i = 0, $arrayidx68 = 0, $arrayidx73 = 0;
 var $arrayidx81 = 0, $big$i = 0, $buf = 0, $buf$i = 0, $call = 0, $call344 = 0, $call345 = 0, $call356 = 0, $call384 = 0, $call411 = 0, $call55$i = 0.0, $carry$0544$i = 0, $carry262$0535$i = 0, $cmp = 0, $cmp1 = 0, $cmp103$i = 0, $cmp105 = 0, $cmp111 = 0, $cmp116 = 0, $cmp126 = 0;
 var $cmp127$i = 0, $cmp13 = 0, $cmp147$i = 0, $cmp165 = 0, $cmp176 = 0, $cmp18 = 0, $cmp181 = 0, $cmp184 = 0, $cmp188$i = 0, $cmp196$i = 0, $cmp205$i = 0, $cmp211 = 0, $cmp225$547$i = 0, $cmp225$i = 0, $cmp228$i = 0, $cmp235$543$i = 0, $cmp235$i = 0, $cmp240 = 0, $cmp249$i = 0, $cmp259$537$i = 0;
 var $cmp259$i = 0, $cmp265$i = 0, $cmp270 = 0, $cmp277$533$i = 0, $cmp277$i = 0, $cmp299$i = 0, $cmp306 = 0, $cmp308$i = 0, $cmp315$i = 0, $cmp323 = 0, $cmp324$529$i = 0, $cmp324$i = 0, $cmp333$i = 0, $cmp338$i = 0, $cmp350$i = 0, $cmp363$525$i = 0, $cmp37 = 0, $cmp374$i = 0, $cmp377 = 0, $cmp377$314 = 0;
 var $cmp38$i = 0, $cmp385 = 0, $cmp385$i = 0, $cmp390 = 0, $cmp390$i = 0, $cmp397 = 0, $cmp403$i = 0, $cmp404 = 0, $cmp404$324 = 0, $cmp411$i = 0, $cmp413 = 0, $cmp416$519$i = 0, $cmp416$i = 0, $cmp420$i = 0, $cmp421 = 0, $cmp433$515$i = 0, $cmp433$i = 0, $cmp434 = 0, $cmp442 = 0, $cmp443$i = 0;
 var $cmp450$i = 0, $cmp450$lcssa$i = 0, $cmp466 = 0, $cmp470$i = 0, $cmp473$i = 0, $cmp478 = 0, $cmp478$295 = 0, $cmp48$i = 0, $cmp495$511$i = 0, $cmp495$i = 0, $cmp50 = 0, $cmp50$308 = 0, $cmp505$i = 0, $cmp515$i = 0, $cmp528$i = 0, $cmp563$i = 0, $cmp577$i = 0, $cmp59$i = 0, $cmp614$i = 0, $cmp617$i = 0;
 var $cmp623$i = 0, $cmp636$506$i = 0, $cmp636$i = 0, $cmp65 = 0, $cmp660$i = 0, $cmp665$i = 0, $cmp673$i = 0, $cmp678$491$i = 0, $cmp678$i = 0, $cmp686$i = 0, $cmp707$486$i = 0, $cmp707$i = 0, $cmp710$487$i = 0, $cmp710$i = 0, $cmp722$483$i = 0, $cmp722$i = 0, $cmp727$i = 0, $cmp745$i = 0, $cmp748$499$i = 0, $cmp748$i = 0;
 var $cmp75 = 0, $cmp760$i = 0, $cmp765$i = 0, $cmp770$495$i = 0, $cmp770$i = 0, $cmp777$i = 0, $cmp790$i = 0, $cmp818$i = 0, $cmp82$i = 0, $cmp94$i = 0, $cmp97 = 0, $cnt$0 = 0, $cnt$1 = 0, $cnt$1$lcssa = 0, $cond$i = 0, $cond100$i = 0, $cond233$i = 0, $cond245 = 0, $cond271$i = 0, $cond304$i = 0;
 var $cond354 = 0, $cond426 = 0, $cond43$i = 0, $cond53$i = 0, $cond629$i = 0, $cond732$i = 0, $cond800$i = 0, $conv$4$i = 0, $conv$4$i$197 = 0, $conv$4$i$211 = 0, $conv$i = 0, $conv$i$205 = 0, $conv1$i = 0, $conv111$i = 0, $conv114$i = 0, $conv116$i = 0, $conv118$393$i = 0, $conv120 = 0, $conv121$i = 0, $conv123$i = 0.0;
 var $conv134 = 0, $conv163 = 0, $conv174 = 0, $conv174$lcssa = 0, $conv207 = 0, $conv216$i = 0, $conv218$i = 0.0, $conv229 = 0, $conv232 = 0, $conv242$i$lcssa = 0, $conv32 = 0, $conv48 = 0, $conv48$307 = 0, $conv48311 = 0, $conv58 = 0, $conv644$i = 0, $conv646$i = 0, $conv69 = 0, $conv83 = 0, $d$0$542$i = 0;
 var $d$0$i = 0, $d$0545$i = 0, $d$1534$i = 0, $d$2$lcssa$i = 0, $d$2520$i = 0, $d$4$i = 0, $d$5494$i = 0, $d$6488$i = 0, $d$7500$i = 0, $dec$i = 0, $dec476$i = 0, $dec481$i = 0, $dec78$i = 0, $div274$i = 0, $div356$i = 0, $div378$i = 0, $div384$i = 0, $e$0531$i = 0, $e$1$i = 0, $e$2517$i = 0;
 var $e$4$i = 0, $e$5$ph$i = 0, $e2$i = 0, $ebuf0$i = 0, $estr$0$i = 0, $estr$1$lcssa$i = 0, $estr$1507$i = 0, $estr$2$i = 0, $exitcond$i = 0, $expanded = 0, $expanded10 = 0, $expanded11 = 0, $expanded13 = 0, $expanded14 = 0, $expanded15 = 0, $expanded4 = 0, $expanded6 = 0, $expanded7 = 0, $expanded8 = 0, $fl$0284 = 0;
 var $fl$0310 = 0, $fl$1 = 0, $fl$1$and219 = 0, $fl$3 = 0, $fl$4 = 0, $fl$6 = 0, $i$0$lcssa = 0, $i$0$lcssa368 = 0, $i$0316 = 0, $i$0530$i = 0, $i$07$i = 0, $i$07$i$201 = 0, $i$1$lcssa$i = 0, $i$1325 = 0, $i$1526$i = 0, $i$2299 = 0, $i$2299$lcssa = 0, $i$2516$i = 0, $i$3296 = 0, $i$3512$i = 0;
 var $i137 = 0, $i86 = 0, $idxprom$i = 0, $inc = 0, $inc$i = 0, $inc425$i = 0, $inc438$i = 0, $inc468$i = 0, $inc488 = 0, $inc500$i = 0, $incdec$ptr = 0, $incdec$ptr$i = 0, $incdec$ptr$i$204 = 0, $incdec$ptr$i$212 = 0, $incdec$ptr$i$212$lcssa = 0, $incdec$ptr$i$225 = 0, $incdec$ptr$i$lcssa = 0, $incdec$ptr106$i = 0, $incdec$ptr112$i = 0, $incdec$ptr115$i = 0;
 var $incdec$ptr122$i = 0, $incdec$ptr137$i = 0, $incdec$ptr169 = 0, $incdec$ptr169$lcssa = 0, $incdec$ptr169269 = 0, $incdec$ptr169271 = 0, $incdec$ptr169271$lcssa414 = 0, $incdec$ptr169272 = 0, $incdec$ptr169274 = 0, $incdec$ptr169275 = 0, $incdec$ptr169276$lcssa = 0, $incdec$ptr169276301 = 0, $incdec$ptr217$i = 0, $incdec$ptr217$i$lcssa = 0, $incdec$ptr23 = 0, $incdec$ptr246$i = 0, $incdec$ptr288$i = 0, $incdec$ptr292$570$i = 0, $incdec$ptr292$a$3$571$i = 0, $incdec$ptr292$a$3$i = 0;
 var $incdec$ptr292$a$3573$i = 0, $incdec$ptr292$i = 0, $incdec$ptr296$i = 0, $incdec$ptr383 = 0, $incdec$ptr410 = 0, $incdec$ptr419$i = 0, $incdec$ptr423$i = 0, $incdec$ptr62 = 0, $incdec$ptr639$i = 0, $incdec$ptr645$i = 0, $incdec$ptr647$i = 0, $incdec$ptr681$i = 0, $incdec$ptr689$i = 0, $incdec$ptr698$i = 0, $incdec$ptr698$i$lcssa = 0, $incdec$ptr725$i = 0, $incdec$ptr734$i = 0, $incdec$ptr773$i = 0, $incdec$ptr776$i = 0, $incdec$ptr808$i = 0;
 var $isdigit = 0, $isdigit$6$i = 0, $isdigit$6$i$199 = 0, $isdigit$i = 0, $isdigit$i$207 = 0, $isdigit188 = 0, $isdigit190 = 0, $isdigittmp = 0, $isdigittmp$ = 0, $isdigittmp$5$i = 0, $isdigittmp$5$i$198 = 0, $isdigittmp$i = 0, $isdigittmp$i$206 = 0, $isdigittmp187 = 0, $isdigittmp189 = 0, $isdigittmp8$i = 0, $isdigittmp8$i$200 = 0, $j$0$524$i = 0, $j$0$i = 0, $j$0527$i = 0;
 var $j$1513$i = 0, $j$2$i = 0, $l$0 = 0, $l$0$i = 0, $l$1$i = 0, $l$1315 = 0, $l$2 = 0, $l10n$0 = 0, $l10n$0$lcssa = 0, $l10n$0$phi = 0, $l10n$1 = 0, $l10n$2 = 0, $l10n$3 = 0, $land$ext$neg$i = 0, $lnot$ext = 0, $lnot$i = 0, $lnot455$i = 0, $lnot483 = 0, $lor$ext$i = 0, $mb = 0;
 var $mul$i = 0, $mul$i$202 = 0, $mul$i$240 = 0.0, $mul125$i = 0.0, $mul202$i = 0.0, $mul220$i = 0.0, $mul286$i = 0, $mul286$i$lcssa = 0, $mul322$i = 0, $mul328$i = 0, $mul335$i = 0, $mul349$i = 0, $mul367$i = 0, $mul406$i = 0.0, $mul407$i = 0.0, $mul431$i = 0, $mul437$i = 0, $mul499$i = 0, $mul513$i = 0, $mul80$i = 0.0;
 var $mul80$i$lcssa = 0.0, $notlhs$i = 0, $notrhs$i = 0, $or = 0, $or$cond = 0, $or$cond$i = 0, $or$cond1$not$i = 0, $or$cond192 = 0, $or$cond193 = 0, $or$cond195 = 0, $or$cond2$i = 0, $or$cond384 = 0, $or$cond395$i = 0, $or$cond397$i = 0, $or$cond401$i = 0, $or$i = 0, $or$i$241 = 0, $or100 = 0, $or120$i = 0, $or246 = 0;
 var $or504$i = 0, $or613$i = 0, $p$0 = 0, $p$1 = 0, $p$2 = 0, $p$2$add322 = 0, $p$3 = 0, $p$4365 = 0, $p$5 = 0, $p$addr$2$$sub514398$i = 0, $p$addr$2$$sub562399$i = 0, $p$addr$2$i = 0, $p$addr$3$i = 0, $p$addr$4$lcssa$i = 0, $p$addr$4489$i = 0, $p$addr$5$lcssa$i = 0, $p$addr$5501$i = 0, $pl$0 = 0, $pl$0$i = 0, $pl$1 = 0;
 var $pl$1$i = 0, $pl$2 = 0, $prefix$0 = 0, $prefix$0$add$ptr65$i = 0, $prefix$0$i = 0, $prefix$1 = 0, $prefix$2 = 0, $r$0$a$9$i = 0, $re$1482$i = 0, $rem360$i = 0, $rem370$i = 0, $rem494$510$i = 0, $rem494$i = 0, $retval$0 = 0, $retval$0$i = 0, $round$0481$i = 0.0, $round377$1$i = 0.0, $s$0$i = 0, $s$1$i = 0, $s$1$i$lcssa = 0;
 var $s$addr$0$lcssa$i$229 = 0, $s$addr$06$i = 0, $s$addr$06$i$221 = 0, $s35$0$i = 0, $s668$0492$i = 0, $s668$1$i = 0, $s715$0$lcssa$i = 0, $s715$0484$i = 0, $s753$0$i = 0, $s753$1496$i = 0, $s753$2$i = 0, $shl = 0, $shl280$i = 0, $shl60 = 0, $shr = 0, $shr283$i = 0, $shr285$i = 0, $small$0$i = 0.0, $small$1$i = 0.0, $st$0 = 0;
 var $st$0$lcssa415 = 0, $storemerge = 0, $storemerge$186282 = 0, $storemerge$186309 = 0, $storemerge$191 = 0, $sub = 0, $sub$i = 0.0, $sub$ptr$div$i = 0, $sub$ptr$div321$i = 0, $sub$ptr$div347$i = 0, $sub$ptr$div430$i = 0, $sub$ptr$div511$i = 0, $sub$ptr$lhs$cast = 0, $sub$ptr$lhs$cast$i = 0, $sub$ptr$lhs$cast160$i = 0, $sub$ptr$lhs$cast305$i = 0, $sub$ptr$lhs$cast317 = 0, $sub$ptr$lhs$cast344$i = 0, $sub$ptr$lhs$cast361 = 0, $sub$ptr$lhs$cast431 = 0;
 var $sub$ptr$lhs$cast508$i = 0, $sub$ptr$lhs$cast694$i = 0, $sub$ptr$rhs$cast = 0, $sub$ptr$rhs$cast$i = 0, $sub$ptr$rhs$cast152$i = 0, $sub$ptr$rhs$cast161$i = 0, $sub$ptr$rhs$cast174$i = 0, $sub$ptr$rhs$cast267 = 0, $sub$ptr$rhs$cast306$i = 0, $sub$ptr$rhs$cast318 = 0, $sub$ptr$rhs$cast319$i = 0, $sub$ptr$rhs$cast345$i = 0, $sub$ptr$rhs$cast362 = 0, $sub$ptr$rhs$cast428$i = 0, $sub$ptr$rhs$cast432 = 0, $sub$ptr$rhs$cast634$504$i = 0, $sub$ptr$rhs$cast634$i = 0, $sub$ptr$rhs$cast649$i = 0, $sub$ptr$rhs$cast695$i = 0, $sub$ptr$rhs$cast788$i = 0;
 var $sub$ptr$rhs$cast812$i = 0, $sub$ptr$sub = 0, $sub$ptr$sub$i = 0, $sub$ptr$sub145$i = 0, $sub$ptr$sub153$i = 0, $sub$ptr$sub159$i = 0, $sub$ptr$sub162$i = 0, $sub$ptr$sub172$i = 0, $sub$ptr$sub175$i = 0, $sub$ptr$sub268 = 0, $sub$ptr$sub307$i = 0, $sub$ptr$sub319 = 0, $sub$ptr$sub320$i = 0, $sub$ptr$sub346$i = 0, $sub$ptr$sub363 = 0, $sub$ptr$sub429$i = 0, $sub$ptr$sub433 = 0, $sub$ptr$sub433$p$5 = 0, $sub$ptr$sub510$i = 0, $sub$ptr$sub635$505$i = 0;
 var $sub$ptr$sub635$i = 0, $sub$ptr$sub650$i = 0, $sub$ptr$sub650$pn$i = 0, $sub$ptr$sub696$i = 0, $sub$ptr$sub789$i = 0, $sub$ptr$sub813$i = 0, $sub101 = 0, $sub124$i = 0.0, $sub135 = 0, $sub146$i = 0, $sub164 = 0, $sub175 = 0, $sub181$i = 0, $sub203$i = 0, $sub219$i = 0.0, $sub256$i = 0, $sub264$i = 0, $sub281$i = 0, $sub336$i = 0, $sub343$i = 0;
 var $sub357$i = 0, $sub389 = 0, $sub409$i = 0, $sub478$i = 0, $sub480$i = 0, $sub514$i = 0, $sub54 = 0, $sub562$i = 0, $sub59 = 0, $sub626$le$i = 0, $sub735$i = 0, $sub74$i = 0, $sub806$i = 0, $sub84 = 0, $sub85$i = 0.0, $sub86$i = 0.0, $sub88$i = 0.0, $sub91$i = 0.0, $sub97$i = 0, $sum = 0;
 var $t$0 = 0, $t$1 = 0, $t$addr$0$i = 0, $t$addr$1$i = 0, $tobool = 0, $tobool$i = 0, $tobool$i$217 = 0, $tobool$i$232 = 0, $tobool$i$245 = 0, $tobool$i$407$i = 0, $tobool$i$413$i = 0, $tobool$i$419$i = 0, $tobool$i$425$i = 0, $tobool$i$431$i = 0, $tobool$i$437$i = 0, $tobool$i$443$i = 0, $tobool$i$449$i = 0, $tobool$i$455$i = 0, $tobool$i$461$i = 0, $tobool$i$467$i = 0;
 var $tobool$i$473$i = 0, $tobool$i$i = 0, $tobool13$i = 0, $tobool135$i = 0, $tobool139$i = 0, $tobool140$i = 0, $tobool141 = 0, $tobool178 = 0, $tobool208 = 0, $tobool217 = 0, $tobool222$i = 0, $tobool244$i = 0, $tobool25 = 0, $tobool255 = 0, $tobool264 = 0, $tobool28 = 0, $tobool290 = 0, $tobool290$569$i = 0, $tobool290$i = 0, $tobool294$i = 0;
 var $tobool295 = 0, $tobool314 = 0, $tobool341$i = 0, $tobool349 = 0, $tobool357 = 0, $tobool37$i = 0, $tobool371$i = 0, $tobool380 = 0, $tobool380$i = 0, $tobool400$i = 0, $tobool407 = 0, $tobool459 = 0, $tobool462 = 0, $tobool470 = 0, $tobool484$i = 0, $tobool490$i = 0, $tobool55 = 0, $tobool56$i = 0, $tobool63$i = 0, $tobool76$i = 0;
 var $tobool76552$i = 0, $tobool781$i = 0, $tobool79$i = 0, $tobool9$i = 0, $tobool90 = 0, $w$0 = 0, $w$1 = 0, $w$2 = 0, $w$add165$i = 0, $w$add653$i = 0, $wc = 0, $ws$0317 = 0, $ws$1326 = 0, $xor = 0, $xor$i = 0, $xor167$i = 0, $xor186$i = 0, $xor449 = 0, $xor457 = 0, $xor655$i = 0;
 var $xor816$i = 0, $y$addr$0$i = 0.0, $y$addr$1$i = 0.0, $y$addr$2$i = 0.0, $y$addr$3$i = 0.0, $y$addr$4$i = 0.0, $z$0$i = 0, $z$0$lcssa = 0, $z$0302 = 0, $z$1 = 0, $z$1$lcssa$i = 0, $z$1548$i = 0, $z$2 = 0, $z$2$i = 0, $z$2$i$lcssa = 0, $z$3$lcssa$i = 0, $z$3538$i = 0, $z$4$i = 0, $z$7$add$ptr742$i = 0, $z$7$i = 0;
 var $z$7$i$lcssa = 0, $z$7$ph$i = 0, label = 0, sp = 0;
 sp = STACKTOP;
 STACKTOP = STACKTOP + 624|0; if ((STACKTOP|0) >= (STACK_MAX|0)) abort();
 $big$i = sp + 24|0;
 $e2$i = sp + 16|0;
 $buf$i = sp + 588|0;
 $ebuf0$i = sp + 576|0;
 $arg = sp;
 $buf = sp + 536|0;
 $wc = sp + 8|0;
 $mb = sp + 528|0;
 $tobool25 = ($f|0)!=(0|0);
 $add$ptr205 = ((($buf)) + 40|0);
 $sub$ptr$lhs$cast317 = $add$ptr205;
 $add$ptr340 = ((($buf)) + 39|0);
 $arrayidx370 = ((($wc)) + 4|0);
 $arrayidx$i$236 = ((($ebuf0$i)) + 12|0);
 $incdec$ptr106$i = ((($ebuf0$i)) + 11|0);
 $sub$ptr$rhs$cast$i = $buf$i;
 $sub$ptr$lhs$cast160$i = $arrayidx$i$236;
 $sub$ptr$sub159$i = (($sub$ptr$lhs$cast160$i) - ($sub$ptr$rhs$cast$i))|0;
 $sub$ptr$sub145$i = (-2 - ($sub$ptr$rhs$cast$i))|0;
 $sub$ptr$sub153$i = (($sub$ptr$lhs$cast160$i) + 2)|0;
 $add$ptr213$i = ((($big$i)) + 288|0);
 $add$ptr671$i = ((($buf$i)) + 9|0);
 $sub$ptr$lhs$cast694$i = $add$ptr671$i;
 $incdec$ptr689$i = ((($buf$i)) + 8|0);
 $cnt$0 = 0;$incdec$ptr169275 = $fmt;$l$0 = 0;$l10n$0 = 0;
 L1: while(1) {
  $cmp = ($cnt$0|0)>(-1);
  do {
   if ($cmp) {
    $sub = (2147483647 - ($cnt$0))|0;
    $cmp1 = ($l$0|0)>($sub|0);
    if ($cmp1) {
     $call = (___errno_location()|0);
     HEAP32[$call>>2] = 75;
     $cnt$1 = -1;
     break;
    } else {
     $add = (($l$0) + ($cnt$0))|0;
     $cnt$1 = $add;
     break;
    }
   } else {
    $cnt$1 = $cnt$0;
   }
  } while(0);
  $0 = HEAP8[$incdec$ptr169275>>0]|0;
  $tobool = ($0<<24>>24)==(0);
  if ($tobool) {
   $cnt$1$lcssa = $cnt$1;$l10n$0$lcssa = $l10n$0;
   label = 242;
   break;
  } else {
   $1 = $0;$incdec$ptr169274 = $incdec$ptr169275;
  }
  L9: while(1) {
   switch ($1<<24>>24) {
   case 37:  {
    $incdec$ptr169276301 = $incdec$ptr169274;$z$0302 = $incdec$ptr169274;
    label = 9;
    break L9;
    break;
   }
   case 0:  {
    $incdec$ptr169276$lcssa = $incdec$ptr169274;$z$0$lcssa = $incdec$ptr169274;
    break L9;
    break;
   }
   default: {
   }
   }
   $incdec$ptr = ((($incdec$ptr169274)) + 1|0);
   $$pre = HEAP8[$incdec$ptr>>0]|0;
   $1 = $$pre;$incdec$ptr169274 = $incdec$ptr;
  }
  L12: do {
   if ((label|0) == 9) {
    while(1) {
     label = 0;
     $arrayidx16 = ((($incdec$ptr169276301)) + 1|0);
     $2 = HEAP8[$arrayidx16>>0]|0;
     $cmp18 = ($2<<24>>24)==(37);
     if (!($cmp18)) {
      $incdec$ptr169276$lcssa = $incdec$ptr169276301;$z$0$lcssa = $z$0302;
      break L12;
     }
     $incdec$ptr23 = ((($z$0302)) + 1|0);
     $add$ptr = ((($incdec$ptr169276301)) + 2|0);
     $3 = HEAP8[$add$ptr>>0]|0;
     $cmp13 = ($3<<24>>24)==(37);
     if ($cmp13) {
      $incdec$ptr169276301 = $add$ptr;$z$0302 = $incdec$ptr23;
      label = 9;
     } else {
      $incdec$ptr169276$lcssa = $add$ptr;$z$0$lcssa = $incdec$ptr23;
      break;
     }
    }
   }
  } while(0);
  $sub$ptr$lhs$cast = $z$0$lcssa;
  $sub$ptr$rhs$cast = $incdec$ptr169275;
  $sub$ptr$sub = (($sub$ptr$lhs$cast) - ($sub$ptr$rhs$cast))|0;
  if ($tobool25) {
   $4 = HEAP32[$f>>2]|0;
   $and$i = $4 & 32;
   $tobool$i = ($and$i|0)==(0);
   if ($tobool$i) {
    (___fwritex($incdec$ptr169275,$sub$ptr$sub,$f)|0);
   }
  }
  $tobool28 = ($z$0$lcssa|0)==($incdec$ptr169275|0);
  if (!($tobool28)) {
   $l10n$0$phi = $l10n$0;$cnt$0 = $cnt$1;$incdec$ptr169275 = $incdec$ptr169276$lcssa;$l$0 = $sub$ptr$sub;$l10n$0 = $l10n$0$phi;
   continue;
  }
  $arrayidx31 = ((($incdec$ptr169276$lcssa)) + 1|0);
  $5 = HEAP8[$arrayidx31>>0]|0;
  $conv32 = $5 << 24 >> 24;
  $isdigittmp = (($conv32) + -48)|0;
  $isdigit = ($isdigittmp>>>0)<(10);
  if ($isdigit) {
   $arrayidx35 = ((($incdec$ptr169276$lcssa)) + 2|0);
   $6 = HEAP8[$arrayidx35>>0]|0;
   $cmp37 = ($6<<24>>24)==(36);
   $add$ptr43 = ((($incdec$ptr169276$lcssa)) + 3|0);
   $add$ptr43$arrayidx31 = $cmp37 ? $add$ptr43 : $arrayidx31;
   $$l10n$0 = $cmp37 ? 1 : $l10n$0;
   $isdigittmp$ = $cmp37 ? $isdigittmp : -1;
   $$pre357 = HEAP8[$add$ptr43$arrayidx31>>0]|0;
   $7 = $$pre357;$argpos$0 = $isdigittmp$;$l10n$1 = $$l10n$0;$storemerge = $add$ptr43$arrayidx31;
  } else {
   $7 = $5;$argpos$0 = -1;$l10n$1 = $l10n$0;$storemerge = $arrayidx31;
  }
  $conv48$307 = $7 << 24 >> 24;
  $8 = $conv48$307 & -32;
  $cmp50$308 = ($8|0)==(32);
  L25: do {
   if ($cmp50$308) {
    $9 = $7;$conv48311 = $conv48$307;$fl$0310 = 0;$storemerge$186309 = $storemerge;
    while(1) {
     $sub54 = (($conv48311) + -32)|0;
     $shl = 1 << $sub54;
     $and = $shl & 75913;
     $tobool55 = ($and|0)==(0);
     if ($tobool55) {
      $12 = $9;$fl$0284 = $fl$0310;$storemerge$186282 = $storemerge$186309;
      break L25;
     }
     $conv58 = $9 << 24 >> 24;
     $sub59 = (($conv58) + -32)|0;
     $shl60 = 1 << $sub59;
     $or = $shl60 | $fl$0310;
     $incdec$ptr62 = ((($storemerge$186309)) + 1|0);
     $10 = HEAP8[$incdec$ptr62>>0]|0;
     $conv48 = $10 << 24 >> 24;
     $11 = $conv48 & -32;
     $cmp50 = ($11|0)==(32);
     if ($cmp50) {
      $9 = $10;$conv48311 = $conv48;$fl$0310 = $or;$storemerge$186309 = $incdec$ptr62;
     } else {
      $12 = $10;$fl$0284 = $or;$storemerge$186282 = $incdec$ptr62;
      break;
     }
    }
   } else {
    $12 = $7;$fl$0284 = 0;$storemerge$186282 = $storemerge;
   }
  } while(0);
  $cmp65 = ($12<<24>>24)==(42);
  do {
   if ($cmp65) {
    $arrayidx68 = ((($storemerge$186282)) + 1|0);
    $13 = HEAP8[$arrayidx68>>0]|0;
    $conv69 = $13 << 24 >> 24;
    $isdigittmp189 = (($conv69) + -48)|0;
    $isdigit190 = ($isdigittmp189>>>0)<(10);
    if ($isdigit190) {
     $arrayidx73 = ((($storemerge$186282)) + 2|0);
     $14 = HEAP8[$arrayidx73>>0]|0;
     $cmp75 = ($14<<24>>24)==(36);
     if ($cmp75) {
      $arrayidx81 = (($nl_type) + ($isdigittmp189<<2)|0);
      HEAP32[$arrayidx81>>2] = 10;
      $15 = HEAP8[$arrayidx68>>0]|0;
      $conv83 = $15 << 24 >> 24;
      $sub84 = (($conv83) + -48)|0;
      $i86 = (($nl_arg) + ($sub84<<3)|0);
      $16 = $i86;
      $17 = $16;
      $18 = HEAP32[$17>>2]|0;
      $19 = (($16) + 4)|0;
      $20 = $19;
      $21 = HEAP32[$20>>2]|0;
      $add$ptr88 = ((($storemerge$186282)) + 3|0);
      $l10n$2 = 1;$storemerge$191 = $add$ptr88;$w$0 = $18;
     } else {
      label = 24;
     }
    } else {
     label = 24;
    }
    if ((label|0) == 24) {
     label = 0;
     $tobool90 = ($l10n$1|0)==(0);
     if (!($tobool90)) {
      $retval$0 = -1;
      break L1;
     }
     if (!($tobool25)) {
      $fl$1 = $fl$0284;$incdec$ptr169269 = $arrayidx68;$l10n$3 = 0;$w$1 = 0;
      break;
     }
     $arglist_current = HEAP32[$ap>>2]|0;
     $22 = $arglist_current;
     $23 = ((0) + 4|0);
     $expanded4 = $23;
     $expanded = (($expanded4) - 1)|0;
     $24 = (($22) + ($expanded))|0;
     $25 = ((0) + 4|0);
     $expanded8 = $25;
     $expanded7 = (($expanded8) - 1)|0;
     $expanded6 = $expanded7 ^ -1;
     $26 = $24 & $expanded6;
     $27 = $26;
     $28 = HEAP32[$27>>2]|0;
     $arglist_next = ((($27)) + 4|0);
     HEAP32[$ap>>2] = $arglist_next;
     $l10n$2 = 0;$storemerge$191 = $arrayidx68;$w$0 = $28;
    }
    $cmp97 = ($w$0|0)<(0);
    if ($cmp97) {
     $or100 = $fl$0284 | 8192;
     $sub101 = (0 - ($w$0))|0;
     $fl$1 = $or100;$incdec$ptr169269 = $storemerge$191;$l10n$3 = $l10n$2;$w$1 = $sub101;
    } else {
     $fl$1 = $fl$0284;$incdec$ptr169269 = $storemerge$191;$l10n$3 = $l10n$2;$w$1 = $w$0;
    }
   } else {
    $conv$4$i = $12 << 24 >> 24;
    $isdigittmp$5$i = (($conv$4$i) + -48)|0;
    $isdigit$6$i = ($isdigittmp$5$i>>>0)<(10);
    if ($isdigit$6$i) {
     $29 = $storemerge$186282;$i$07$i = 0;$isdigittmp8$i = $isdigittmp$5$i;
     while(1) {
      $mul$i = ($i$07$i*10)|0;
      $add$i = (($mul$i) + ($isdigittmp8$i))|0;
      $incdec$ptr$i = ((($29)) + 1|0);
      $30 = HEAP8[$incdec$ptr$i>>0]|0;
      $conv$i = $30 << 24 >> 24;
      $isdigittmp$i = (($conv$i) + -48)|0;
      $isdigit$i = ($isdigittmp$i>>>0)<(10);
      if ($isdigit$i) {
       $29 = $incdec$ptr$i;$i$07$i = $add$i;$isdigittmp8$i = $isdigittmp$i;
      } else {
       $add$i$lcssa = $add$i;$incdec$ptr$i$lcssa = $incdec$ptr$i;
       break;
      }
     }
     $cmp105 = ($add$i$lcssa|0)<(0);
     if ($cmp105) {
      $retval$0 = -1;
      break L1;
     } else {
      $fl$1 = $fl$0284;$incdec$ptr169269 = $incdec$ptr$i$lcssa;$l10n$3 = $l10n$1;$w$1 = $add$i$lcssa;
     }
    } else {
     $fl$1 = $fl$0284;$incdec$ptr169269 = $storemerge$186282;$l10n$3 = $l10n$1;$w$1 = 0;
    }
   }
  } while(0);
  $31 = HEAP8[$incdec$ptr169269>>0]|0;
  $cmp111 = ($31<<24>>24)==(46);
  L46: do {
   if ($cmp111) {
    $arrayidx114 = ((($incdec$ptr169269)) + 1|0);
    $32 = HEAP8[$arrayidx114>>0]|0;
    $cmp116 = ($32<<24>>24)==(42);
    if (!($cmp116)) {
     $conv$4$i$197 = $32 << 24 >> 24;
     $isdigittmp$5$i$198 = (($conv$4$i$197) + -48)|0;
     $isdigit$6$i$199 = ($isdigittmp$5$i$198>>>0)<(10);
     if ($isdigit$6$i$199) {
      $49 = $arrayidx114;$i$07$i$201 = 0;$isdigittmp8$i$200 = $isdigittmp$5$i$198;
     } else {
      $incdec$ptr169272 = $arrayidx114;$p$0 = 0;
      break;
     }
     while(1) {
      $mul$i$202 = ($i$07$i$201*10)|0;
      $add$i$203 = (($mul$i$202) + ($isdigittmp8$i$200))|0;
      $incdec$ptr$i$204 = ((($49)) + 1|0);
      $50 = HEAP8[$incdec$ptr$i$204>>0]|0;
      $conv$i$205 = $50 << 24 >> 24;
      $isdigittmp$i$206 = (($conv$i$205) + -48)|0;
      $isdigit$i$207 = ($isdigittmp$i$206>>>0)<(10);
      if ($isdigit$i$207) {
       $49 = $incdec$ptr$i$204;$i$07$i$201 = $add$i$203;$isdigittmp8$i$200 = $isdigittmp$i$206;
      } else {
       $incdec$ptr169272 = $incdec$ptr$i$204;$p$0 = $add$i$203;
       break L46;
      }
     }
    }
    $arrayidx119 = ((($incdec$ptr169269)) + 2|0);
    $33 = HEAP8[$arrayidx119>>0]|0;
    $conv120 = $33 << 24 >> 24;
    $isdigittmp187 = (($conv120) + -48)|0;
    $isdigit188 = ($isdigittmp187>>>0)<(10);
    if ($isdigit188) {
     $arrayidx124 = ((($incdec$ptr169269)) + 3|0);
     $34 = HEAP8[$arrayidx124>>0]|0;
     $cmp126 = ($34<<24>>24)==(36);
     if ($cmp126) {
      $arrayidx132 = (($nl_type) + ($isdigittmp187<<2)|0);
      HEAP32[$arrayidx132>>2] = 10;
      $35 = HEAP8[$arrayidx119>>0]|0;
      $conv134 = $35 << 24 >> 24;
      $sub135 = (($conv134) + -48)|0;
      $i137 = (($nl_arg) + ($sub135<<3)|0);
      $36 = $i137;
      $37 = $36;
      $38 = HEAP32[$37>>2]|0;
      $39 = (($36) + 4)|0;
      $40 = $39;
      $41 = HEAP32[$40>>2]|0;
      $add$ptr139 = ((($incdec$ptr169269)) + 4|0);
      $incdec$ptr169272 = $add$ptr139;$p$0 = $38;
      break;
     }
    }
    $tobool141 = ($l10n$3|0)==(0);
    if (!($tobool141)) {
     $retval$0 = -1;
     break L1;
    }
    if ($tobool25) {
     $arglist_current2 = HEAP32[$ap>>2]|0;
     $42 = $arglist_current2;
     $43 = ((0) + 4|0);
     $expanded11 = $43;
     $expanded10 = (($expanded11) - 1)|0;
     $44 = (($42) + ($expanded10))|0;
     $45 = ((0) + 4|0);
     $expanded15 = $45;
     $expanded14 = (($expanded15) - 1)|0;
     $expanded13 = $expanded14 ^ -1;
     $46 = $44 & $expanded13;
     $47 = $46;
     $48 = HEAP32[$47>>2]|0;
     $arglist_next3 = ((($47)) + 4|0);
     HEAP32[$ap>>2] = $arglist_next3;
     $incdec$ptr169272 = $arrayidx119;$p$0 = $48;
    } else {
     $incdec$ptr169272 = $arrayidx119;$p$0 = 0;
    }
   } else {
    $incdec$ptr169272 = $incdec$ptr169269;$p$0 = -1;
   }
  } while(0);
  $incdec$ptr169271 = $incdec$ptr169272;$st$0 = 0;
  while(1) {
   $51 = HEAP8[$incdec$ptr169271>>0]|0;
   $conv163 = $51 << 24 >> 24;
   $sub164 = (($conv163) + -65)|0;
   $cmp165 = ($sub164>>>0)>(57);
   if ($cmp165) {
    $retval$0 = -1;
    break L1;
   }
   $incdec$ptr169 = ((($incdec$ptr169271)) + 1|0);
   $arrayidx173 = ((3611 + (($st$0*58)|0)|0) + ($sub164)|0);
   $52 = HEAP8[$arrayidx173>>0]|0;
   $conv174 = $52&255;
   $sub175 = (($conv174) + -1)|0;
   $cmp176 = ($sub175>>>0)<(8);
   if ($cmp176) {
    $incdec$ptr169271 = $incdec$ptr169;$st$0 = $conv174;
   } else {
    $$lcssa = $52;$conv174$lcssa = $conv174;$incdec$ptr169$lcssa = $incdec$ptr169;$incdec$ptr169271$lcssa414 = $incdec$ptr169271;$st$0$lcssa415 = $st$0;
    break;
   }
  }
  $tobool178 = ($$lcssa<<24>>24)==(0);
  if ($tobool178) {
   $retval$0 = -1;
   break;
  }
  $cmp181 = ($$lcssa<<24>>24)==(19);
  $cmp184 = ($argpos$0|0)>(-1);
  do {
   if ($cmp181) {
    if ($cmp184) {
     $retval$0 = -1;
     break L1;
    } else {
     label = 52;
    }
   } else {
    if ($cmp184) {
     $arrayidx192 = (($nl_type) + ($argpos$0<<2)|0);
     HEAP32[$arrayidx192>>2] = $conv174$lcssa;
     $53 = (($nl_arg) + ($argpos$0<<3)|0);
     $54 = $53;
     $55 = $54;
     $56 = HEAP32[$55>>2]|0;
     $57 = (($54) + 4)|0;
     $58 = $57;
     $59 = HEAP32[$58>>2]|0;
     $60 = $arg;
     $61 = $60;
     HEAP32[$61>>2] = $56;
     $62 = (($60) + 4)|0;
     $63 = $62;
     HEAP32[$63>>2] = $59;
     label = 52;
     break;
    }
    if (!($tobool25)) {
     $retval$0 = 0;
     break L1;
    }
    _pop_arg_336($arg,$conv174$lcssa,$ap);
   }
  } while(0);
  if ((label|0) == 52) {
   label = 0;
   if (!($tobool25)) {
    $cnt$0 = $cnt$1;$incdec$ptr169275 = $incdec$ptr169$lcssa;$l$0 = $sub$ptr$sub;$l10n$0 = $l10n$3;
    continue;
   }
  }
  $64 = HEAP8[$incdec$ptr169271$lcssa414>>0]|0;
  $conv207 = $64 << 24 >> 24;
  $tobool208 = ($st$0$lcssa415|0)!=(0);
  $and210 = $conv207 & 15;
  $cmp211 = ($and210|0)==(3);
  $or$cond192 = $tobool208 & $cmp211;
  $and214 = $conv207 & -33;
  $t$0 = $or$cond192 ? $and214 : $conv207;
  $and216 = $fl$1 & 8192;
  $tobool217 = ($and216|0)==(0);
  $and219 = $fl$1 & -65537;
  $fl$1$and219 = $tobool217 ? $fl$1 : $and219;
  L75: do {
   switch ($t$0|0) {
   case 110:  {
    switch ($st$0$lcssa415|0) {
    case 0:  {
     $71 = HEAP32[$arg>>2]|0;
     HEAP32[$71>>2] = $cnt$1;
     $cnt$0 = $cnt$1;$incdec$ptr169275 = $incdec$ptr169$lcssa;$l$0 = $sub$ptr$sub;$l10n$0 = $l10n$3;
     continue L1;
     break;
    }
    case 1:  {
     $72 = HEAP32[$arg>>2]|0;
     HEAP32[$72>>2] = $cnt$1;
     $cnt$0 = $cnt$1;$incdec$ptr169275 = $incdec$ptr169$lcssa;$l$0 = $sub$ptr$sub;$l10n$0 = $l10n$3;
     continue L1;
     break;
    }
    case 2:  {
     $73 = ($cnt$1|0)<(0);
     $74 = $73 << 31 >> 31;
     $75 = HEAP32[$arg>>2]|0;
     $76 = $75;
     $77 = $76;
     HEAP32[$77>>2] = $cnt$1;
     $78 = (($76) + 4)|0;
     $79 = $78;
     HEAP32[$79>>2] = $74;
     $cnt$0 = $cnt$1;$incdec$ptr169275 = $incdec$ptr169$lcssa;$l$0 = $sub$ptr$sub;$l10n$0 = $l10n$3;
     continue L1;
     break;
    }
    case 3:  {
     $conv229 = $cnt$1&65535;
     $80 = HEAP32[$arg>>2]|0;
     HEAP16[$80>>1] = $conv229;
     $cnt$0 = $cnt$1;$incdec$ptr169275 = $incdec$ptr169$lcssa;$l$0 = $sub$ptr$sub;$l10n$0 = $l10n$3;
     continue L1;
     break;
    }
    case 4:  {
     $conv232 = $cnt$1&255;
     $81 = HEAP32[$arg>>2]|0;
     HEAP8[$81>>0] = $conv232;
     $cnt$0 = $cnt$1;$incdec$ptr169275 = $incdec$ptr169$lcssa;$l$0 = $sub$ptr$sub;$l10n$0 = $l10n$3;
     continue L1;
     break;
    }
    case 6:  {
     $82 = HEAP32[$arg>>2]|0;
     HEAP32[$82>>2] = $cnt$1;
     $cnt$0 = $cnt$1;$incdec$ptr169275 = $incdec$ptr169$lcssa;$l$0 = $sub$ptr$sub;$l10n$0 = $l10n$3;
     continue L1;
     break;
    }
    case 7:  {
     $83 = ($cnt$1|0)<(0);
     $84 = $83 << 31 >> 31;
     $85 = HEAP32[$arg>>2]|0;
     $86 = $85;
     $87 = $86;
     HEAP32[$87>>2] = $cnt$1;
     $88 = (($86) + 4)|0;
     $89 = $88;
     HEAP32[$89>>2] = $84;
     $cnt$0 = $cnt$1;$incdec$ptr169275 = $incdec$ptr169$lcssa;$l$0 = $sub$ptr$sub;$l10n$0 = $l10n$3;
     continue L1;
     break;
    }
    default: {
     $cnt$0 = $cnt$1;$incdec$ptr169275 = $incdec$ptr169$lcssa;$l$0 = $sub$ptr$sub;$l10n$0 = $l10n$3;
     continue L1;
    }
    }
    break;
   }
   case 112:  {
    $cmp240 = ($p$0>>>0)>(8);
    $cond245 = $cmp240 ? $p$0 : 8;
    $or246 = $fl$1$and219 | 8;
    $fl$3 = $or246;$p$1 = $cond245;$t$1 = 120;
    label = 64;
    break;
   }
   case 88: case 120:  {
    $fl$3 = $fl$1$and219;$p$1 = $p$0;$t$1 = $t$0;
    label = 64;
    break;
   }
   case 111:  {
    $116 = $arg;
    $117 = $116;
    $118 = HEAP32[$117>>2]|0;
    $119 = (($116) + 4)|0;
    $120 = $119;
    $121 = HEAP32[$120>>2]|0;
    $122 = ($118|0)==(0);
    $123 = ($121|0)==(0);
    $124 = $122 & $123;
    if ($124) {
     $s$addr$0$lcssa$i$229 = $add$ptr205;
    } else {
     $126 = $118;$129 = $121;$s$addr$06$i$221 = $add$ptr205;
     while(1) {
      $125 = $126 & 7;
      $127 = $125 | 48;
      $128 = $127&255;
      $incdec$ptr$i$225 = ((($s$addr$06$i$221)) + -1|0);
      HEAP8[$incdec$ptr$i$225>>0] = $128;
      $130 = (_bitshift64Lshr(($126|0),($129|0),3)|0);
      $131 = tempRet0;
      $132 = ($130|0)==(0);
      $133 = ($131|0)==(0);
      $134 = $132 & $133;
      if ($134) {
       $s$addr$0$lcssa$i$229 = $incdec$ptr$i$225;
       break;
      } else {
       $126 = $130;$129 = $131;$s$addr$06$i$221 = $incdec$ptr$i$225;
      }
     }
    }
    $and263 = $fl$1$and219 & 8;
    $tobool264 = ($and263|0)==(0);
    if ($tobool264) {
     $a$0 = $s$addr$0$lcssa$i$229;$fl$4 = $fl$1$and219;$p$2 = $p$0;$pl$1 = 0;$prefix$1 = 4091;
     label = 77;
    } else {
     $sub$ptr$rhs$cast267 = $s$addr$0$lcssa$i$229;
     $sub$ptr$sub268 = (($sub$ptr$lhs$cast317) - ($sub$ptr$rhs$cast267))|0;
     $add269 = (($sub$ptr$sub268) + 1)|0;
     $cmp270 = ($p$0|0)<($add269|0);
     $add269$p$0 = $cmp270 ? $add269 : $p$0;
     $a$0 = $s$addr$0$lcssa$i$229;$fl$4 = $fl$1$and219;$p$2 = $add269$p$0;$pl$1 = 0;$prefix$1 = 4091;
     label = 77;
    }
    break;
   }
   case 105: case 100:  {
    $135 = $arg;
    $136 = $135;
    $137 = HEAP32[$136>>2]|0;
    $138 = (($135) + 4)|0;
    $139 = $138;
    $140 = HEAP32[$139>>2]|0;
    $141 = ($140|0)<(0);
    if ($141) {
     $142 = (_i64Subtract(0,0,($137|0),($140|0))|0);
     $143 = tempRet0;
     $144 = $arg;
     $145 = $144;
     HEAP32[$145>>2] = $142;
     $146 = (($144) + 4)|0;
     $147 = $146;
     HEAP32[$147>>2] = $143;
     $148 = $142;$149 = $143;$pl$0 = 1;$prefix$0 = 4091;
     label = 76;
     break L75;
    }
    $and289 = $fl$1$and219 & 2048;
    $tobool290 = ($and289|0)==(0);
    if ($tobool290) {
     $and294 = $fl$1$and219 & 1;
     $tobool295 = ($and294|0)==(0);
     $$ = $tobool295 ? 4091 : (4093);
     $148 = $137;$149 = $140;$pl$0 = $and294;$prefix$0 = $$;
     label = 76;
    } else {
     $148 = $137;$149 = $140;$pl$0 = 1;$prefix$0 = (4092);
     label = 76;
    }
    break;
   }
   case 117:  {
    $65 = $arg;
    $66 = $65;
    $67 = HEAP32[$66>>2]|0;
    $68 = (($65) + 4)|0;
    $69 = $68;
    $70 = HEAP32[$69>>2]|0;
    $148 = $67;$149 = $70;$pl$0 = 0;$prefix$0 = 4091;
    label = 76;
    break;
   }
   case 99:  {
    $161 = $arg;
    $162 = $161;
    $163 = HEAP32[$162>>2]|0;
    $164 = (($161) + 4)|0;
    $165 = $164;
    $166 = HEAP32[$165>>2]|0;
    $167 = $163&255;
    HEAP8[$add$ptr340>>0] = $167;
    $a$2 = $add$ptr340;$fl$6 = $and219;$p$5 = 1;$pl$2 = 0;$prefix$2 = 4091;$z$2 = $add$ptr205;
    break;
   }
   case 109:  {
    $call344 = (___errno_location()|0);
    $168 = HEAP32[$call344>>2]|0;
    $call345 = (_strerror($168)|0);
    $a$1 = $call345;
    label = 82;
    break;
   }
   case 115:  {
    $169 = HEAP32[$arg>>2]|0;
    $tobool349 = ($169|0)!=(0|0);
    $cond354 = $tobool349 ? $169 : 4101;
    $a$1 = $cond354;
    label = 82;
    break;
   }
   case 67:  {
    $170 = $arg;
    $171 = $170;
    $172 = HEAP32[$171>>2]|0;
    $173 = (($170) + 4)|0;
    $174 = $173;
    $175 = HEAP32[$174>>2]|0;
    HEAP32[$wc>>2] = $172;
    HEAP32[$arrayidx370>>2] = 0;
    HEAP32[$arg>>2] = $wc;
    $p$4365 = -1;
    label = 86;
    break;
   }
   case 83:  {
    $cmp377$314 = ($p$0|0)==(0);
    if ($cmp377$314) {
     _pad($f,32,$w$1,0,$fl$1$and219);
     $i$0$lcssa368 = 0;
     label = 98;
    } else {
     $p$4365 = $p$0;
     label = 86;
    }
    break;
   }
   case 65: case 71: case 70: case 69: case 97: case 103: case 102: case 101:  {
    $181 = +HEAPF64[$arg>>3];
    HEAP32[$e2$i>>2] = 0;
    HEAPF64[tempDoublePtr>>3] = $181;$182 = HEAP32[tempDoublePtr>>2]|0;
    $183 = HEAP32[tempDoublePtr+4>>2]|0;
    $184 = ($183|0)<(0);
    if ($184) {
     $sub$i = -$181;
     $pl$0$i = 1;$prefix$0$i = 4108;$y$addr$0$i = $sub$i;
    } else {
     $and$i$238 = $fl$1$and219 & 2048;
     $tobool9$i = ($and$i$238|0)==(0);
     if ($tobool9$i) {
      $and12$i = $fl$1$and219 & 1;
      $tobool13$i = ($and12$i|0)==(0);
      $$$i = $tobool13$i ? (4109) : (4114);
      $pl$0$i = $and12$i;$prefix$0$i = $$$i;$y$addr$0$i = $181;
     } else {
      $pl$0$i = 1;$prefix$0$i = (4111);$y$addr$0$i = $181;
     }
    }
    HEAPF64[tempDoublePtr>>3] = $y$addr$0$i;$185 = HEAP32[tempDoublePtr>>2]|0;
    $186 = HEAP32[tempDoublePtr+4>>2]|0;
    $187 = $186 & 2146435072;
    $188 = ($187>>>0)<(2146435072);
    $189 = (0)<(0);
    $190 = ($187|0)==(2146435072);
    $191 = $190 & $189;
    $192 = $188 | $191;
    do {
     if ($192) {
      $call55$i = (+_frexpl($y$addr$0$i,$e2$i));
      $mul$i$240 = $call55$i * 2.0;
      $tobool56$i = $mul$i$240 != 0.0;
      if ($tobool56$i) {
       $195 = HEAP32[$e2$i>>2]|0;
       $dec$i = (($195) + -1)|0;
       HEAP32[$e2$i>>2] = $dec$i;
      }
      $or$i$241 = $t$0 | 32;
      $cmp59$i = ($or$i$241|0)==(97);
      if ($cmp59$i) {
       $and62$i = $t$0 & 32;
       $tobool63$i = ($and62$i|0)==(0);
       $add$ptr65$i = ((($prefix$0$i)) + 9|0);
       $prefix$0$add$ptr65$i = $tobool63$i ? $prefix$0$i : $add$ptr65$i;
       $add67$i = $pl$0$i | 2;
       $196 = ($p$0>>>0)>(11);
       $sub74$i = (12 - ($p$0))|0;
       $tobool76552$i = ($sub74$i|0)==(0);
       $tobool76$i = $196 | $tobool76552$i;
       do {
        if ($tobool76$i) {
         $y$addr$1$i = $mul$i$240;
        } else {
         $re$1482$i = $sub74$i;$round$0481$i = 8.0;
         while(1) {
          $dec78$i = (($re$1482$i) + -1)|0;
          $mul80$i = $round$0481$i * 16.0;
          $tobool79$i = ($dec78$i|0)==(0);
          if ($tobool79$i) {
           $mul80$i$lcssa = $mul80$i;
           break;
          } else {
           $re$1482$i = $dec78$i;$round$0481$i = $mul80$i;
          }
         }
         $197 = HEAP8[$prefix$0$add$ptr65$i>>0]|0;
         $cmp82$i = ($197<<24>>24)==(45);
         if ($cmp82$i) {
          $sub85$i = -$mul$i$240;
          $sub86$i = $sub85$i - $mul80$i$lcssa;
          $add87$i = $mul80$i$lcssa + $sub86$i;
          $sub88$i = -$add87$i;
          $y$addr$1$i = $sub88$i;
          break;
         } else {
          $add90$i = $mul$i$240 + $mul80$i$lcssa;
          $sub91$i = $add90$i - $mul80$i$lcssa;
          $y$addr$1$i = $sub91$i;
          break;
         }
        }
       } while(0);
       $198 = HEAP32[$e2$i>>2]|0;
       $cmp94$i = ($198|0)<(0);
       $sub97$i = (0 - ($198))|0;
       $cond100$i = $cmp94$i ? $sub97$i : $198;
       $199 = ($cond100$i|0)<(0);
       $200 = $199 << 31 >> 31;
       $201 = (_fmt_u($cond100$i,$200,$arrayidx$i$236)|0);
       $cmp103$i = ($201|0)==($arrayidx$i$236|0);
       if ($cmp103$i) {
        HEAP8[$incdec$ptr106$i>>0] = 48;
        $estr$0$i = $incdec$ptr106$i;
       } else {
        $estr$0$i = $201;
       }
       $202 = $198 >> 31;
       $203 = $202 & 2;
       $204 = (($203) + 43)|0;
       $conv111$i = $204&255;
       $incdec$ptr112$i = ((($estr$0$i)) + -1|0);
       HEAP8[$incdec$ptr112$i>>0] = $conv111$i;
       $add113$i = (($t$0) + 15)|0;
       $conv114$i = $add113$i&255;
       $incdec$ptr115$i = ((($estr$0$i)) + -2|0);
       HEAP8[$incdec$ptr115$i>>0] = $conv114$i;
       $notrhs$i = ($p$0|0)<(1);
       $and134$i = $fl$1$and219 & 8;
       $tobool135$i = ($and134$i|0)==(0);
       $s$0$i = $buf$i;$y$addr$2$i = $y$addr$1$i;
       while(1) {
        $conv116$i = (~~(($y$addr$2$i)));
        $arrayidx117$i = (4075 + ($conv116$i)|0);
        $205 = HEAP8[$arrayidx117$i>>0]|0;
        $conv118$393$i = $205&255;
        $or120$i = $conv118$393$i | $and62$i;
        $conv121$i = $or120$i&255;
        $incdec$ptr122$i = ((($s$0$i)) + 1|0);
        HEAP8[$s$0$i>>0] = $conv121$i;
        $conv123$i = (+($conv116$i|0));
        $sub124$i = $y$addr$2$i - $conv123$i;
        $mul125$i = $sub124$i * 16.0;
        $sub$ptr$lhs$cast$i = $incdec$ptr122$i;
        $sub$ptr$sub$i = (($sub$ptr$lhs$cast$i) - ($sub$ptr$rhs$cast$i))|0;
        $cmp127$i = ($sub$ptr$sub$i|0)==(1);
        do {
         if ($cmp127$i) {
          $notlhs$i = $mul125$i == 0.0;
          $or$cond1$not$i = $notrhs$i & $notlhs$i;
          $or$cond$i = $tobool135$i & $or$cond1$not$i;
          if ($or$cond$i) {
           $s$1$i = $incdec$ptr122$i;
           break;
          }
          $incdec$ptr137$i = ((($s$0$i)) + 2|0);
          HEAP8[$incdec$ptr122$i>>0] = 46;
          $s$1$i = $incdec$ptr137$i;
         } else {
          $s$1$i = $incdec$ptr122$i;
         }
        } while(0);
        $tobool139$i = $mul125$i != 0.0;
        if ($tobool139$i) {
         $s$0$i = $s$1$i;$y$addr$2$i = $mul125$i;
        } else {
         $s$1$i$lcssa = $s$1$i;
         break;
        }
       }
       $tobool140$i = ($p$0|0)!=(0);
       $$pre566$i = $s$1$i$lcssa;
       $sub146$i = (($sub$ptr$sub145$i) + ($$pre566$i))|0;
       $cmp147$i = ($sub146$i|0)<($p$0|0);
       $or$cond384 = $tobool140$i & $cmp147$i;
       $sub$ptr$rhs$cast152$i = $incdec$ptr115$i;
       $add150$i = (($sub$ptr$sub153$i) + ($p$0))|0;
       $add154$i = (($add150$i) - ($sub$ptr$rhs$cast152$i))|0;
       $sub$ptr$rhs$cast161$i = $incdec$ptr115$i;
       $sub$ptr$sub162$i = (($sub$ptr$sub159$i) - ($sub$ptr$rhs$cast161$i))|0;
       $add163$i = (($sub$ptr$sub162$i) + ($$pre566$i))|0;
       $l$0$i = $or$cond384 ? $add154$i : $add163$i;
       $add165$i = (($l$0$i) + ($add67$i))|0;
       _pad($f,32,$w$1,$add165$i,$fl$1$and219);
       $206 = HEAP32[$f>>2]|0;
       $and$i$418$i = $206 & 32;
       $tobool$i$419$i = ($and$i$418$i|0)==(0);
       if ($tobool$i$419$i) {
        (___fwritex($prefix$0$add$ptr65$i,$add67$i,$f)|0);
       }
       $xor167$i = $fl$1$and219 ^ 65536;
       _pad($f,48,$w$1,$add165$i,$xor167$i);
       $sub$ptr$sub172$i = (($$pre566$i) - ($sub$ptr$rhs$cast$i))|0;
       $207 = HEAP32[$f>>2]|0;
       $and$i$424$i = $207 & 32;
       $tobool$i$425$i = ($and$i$424$i|0)==(0);
       if ($tobool$i$425$i) {
        (___fwritex($buf$i,$sub$ptr$sub172$i,$f)|0);
       }
       $sub$ptr$rhs$cast174$i = $incdec$ptr115$i;
       $sub$ptr$sub175$i = (($sub$ptr$lhs$cast160$i) - ($sub$ptr$rhs$cast174$i))|0;
       $sum = (($sub$ptr$sub172$i) + ($sub$ptr$sub175$i))|0;
       $sub181$i = (($l$0$i) - ($sum))|0;
       _pad($f,48,$sub181$i,0,0);
       $208 = HEAP32[$f>>2]|0;
       $and$i$430$i = $208 & 32;
       $tobool$i$431$i = ($and$i$430$i|0)==(0);
       if ($tobool$i$431$i) {
        (___fwritex($incdec$ptr115$i,$sub$ptr$sub175$i,$f)|0);
       }
       $xor186$i = $fl$1$and219 ^ 8192;
       _pad($f,32,$w$1,$add165$i,$xor186$i);
       $cmp188$i = ($add165$i|0)<($w$1|0);
       $w$add165$i = $cmp188$i ? $w$1 : $add165$i;
       $retval$0$i = $w$add165$i;
       break;
      }
      $cmp196$i = ($p$0|0)<(0);
      $$p$i = $cmp196$i ? 6 : $p$0;
      if ($tobool56$i) {
       $mul202$i = $mul$i$240 * 268435456.0;
       $209 = HEAP32[$e2$i>>2]|0;
       $sub203$i = (($209) + -28)|0;
       HEAP32[$e2$i>>2] = $sub203$i;
       $210 = $sub203$i;$y$addr$3$i = $mul202$i;
      } else {
       $$pre564$i = HEAP32[$e2$i>>2]|0;
       $210 = $$pre564$i;$y$addr$3$i = $mul$i$240;
      }
      $cmp205$i = ($210|0)<(0);
      $arraydecay208$add$ptr213$i = $cmp205$i ? $big$i : $add$ptr213$i;
      $sub$ptr$rhs$cast345$i = $arraydecay208$add$ptr213$i;
      $y$addr$4$i = $y$addr$3$i;$z$0$i = $arraydecay208$add$ptr213$i;
      while(1) {
       $conv216$i = (~~(($y$addr$4$i))>>>0);
       HEAP32[$z$0$i>>2] = $conv216$i;
       $incdec$ptr217$i = ((($z$0$i)) + 4|0);
       $conv218$i = (+($conv216$i>>>0));
       $sub219$i = $y$addr$4$i - $conv218$i;
       $mul220$i = $sub219$i * 1.0E+9;
       $tobool222$i = $mul220$i != 0.0;
       if ($tobool222$i) {
        $y$addr$4$i = $mul220$i;$z$0$i = $incdec$ptr217$i;
       } else {
        $incdec$ptr217$i$lcssa = $incdec$ptr217$i;
        break;
       }
      }
      $$pr$i = HEAP32[$e2$i>>2]|0;
      $cmp225$547$i = ($$pr$i|0)>(0);
      if ($cmp225$547$i) {
       $211 = $$pr$i;$a$1549$i = $arraydecay208$add$ptr213$i;$z$1548$i = $incdec$ptr217$i$lcssa;
       while(1) {
        $cmp228$i = ($211|0)>(29);
        $cond233$i = $cmp228$i ? 29 : $211;
        $d$0$542$i = ((($z$1548$i)) + -4|0);
        $cmp235$543$i = ($d$0$542$i>>>0)<($a$1549$i>>>0);
        do {
         if ($cmp235$543$i) {
          $a$2$ph$i = $a$1549$i;
         } else {
          $carry$0544$i = 0;$d$0545$i = $d$0$542$i;
          while(1) {
           $212 = HEAP32[$d$0545$i>>2]|0;
           $213 = (_bitshift64Shl(($212|0),0,($cond233$i|0))|0);
           $214 = tempRet0;
           $215 = (_i64Add(($213|0),($214|0),($carry$0544$i|0),0)|0);
           $216 = tempRet0;
           $217 = (___uremdi3(($215|0),($216|0),1000000000,0)|0);
           $218 = tempRet0;
           HEAP32[$d$0545$i>>2] = $217;
           $219 = (___udivdi3(($215|0),($216|0),1000000000,0)|0);
           $220 = tempRet0;
           $d$0$i = ((($d$0545$i)) + -4|0);
           $cmp235$i = ($d$0$i>>>0)<($a$1549$i>>>0);
           if ($cmp235$i) {
            $conv242$i$lcssa = $219;
            break;
           } else {
            $carry$0544$i = $219;$d$0545$i = $d$0$i;
           }
          }
          $tobool244$i = ($conv242$i$lcssa|0)==(0);
          if ($tobool244$i) {
           $a$2$ph$i = $a$1549$i;
           break;
          }
          $incdec$ptr246$i = ((($a$1549$i)) + -4|0);
          HEAP32[$incdec$ptr246$i>>2] = $conv242$i$lcssa;
          $a$2$ph$i = $incdec$ptr246$i;
         }
        } while(0);
        $z$2$i = $z$1548$i;
        while(1) {
         $cmp249$i = ($z$2$i>>>0)>($a$2$ph$i>>>0);
         if (!($cmp249$i)) {
          $z$2$i$lcssa = $z$2$i;
          break;
         }
         $arrayidx251$i = ((($z$2$i)) + -4|0);
         $221 = HEAP32[$arrayidx251$i>>2]|0;
         $lnot$i = ($221|0)==(0);
         if ($lnot$i) {
          $z$2$i = $arrayidx251$i;
         } else {
          $z$2$i$lcssa = $z$2$i;
          break;
         }
        }
        $222 = HEAP32[$e2$i>>2]|0;
        $sub256$i = (($222) - ($cond233$i))|0;
        HEAP32[$e2$i>>2] = $sub256$i;
        $cmp225$i = ($sub256$i|0)>(0);
        if ($cmp225$i) {
         $211 = $sub256$i;$a$1549$i = $a$2$ph$i;$z$1548$i = $z$2$i$lcssa;
        } else {
         $$pr477$i = $sub256$i;$a$1$lcssa$i = $a$2$ph$i;$z$1$lcssa$i = $z$2$i$lcssa;
         break;
        }
       }
      } else {
       $$pr477$i = $$pr$i;$a$1$lcssa$i = $arraydecay208$add$ptr213$i;$z$1$lcssa$i = $incdec$ptr217$i$lcssa;
      }
      $cmp259$537$i = ($$pr477$i|0)<(0);
      if ($cmp259$537$i) {
       $add273$i = (($$p$i) + 25)|0;
       $div274$i = (($add273$i|0) / 9)&-1;
       $add275$i = (($div274$i) + 1)|0;
       $cmp299$i = ($or$i$241|0)==(102);
       $223 = $$pr477$i;$a$3539$i = $a$1$lcssa$i;$z$3538$i = $z$1$lcssa$i;
       while(1) {
        $sub264$i = (0 - ($223))|0;
        $cmp265$i = ($sub264$i|0)>(9);
        $cond271$i = $cmp265$i ? 9 : $sub264$i;
        $cmp277$533$i = ($a$3539$i>>>0)<($z$3538$i>>>0);
        do {
         if ($cmp277$533$i) {
          $shl280$i = 1 << $cond271$i;
          $sub281$i = (($shl280$i) + -1)|0;
          $shr285$i = 1000000000 >>> $cond271$i;
          $carry262$0535$i = 0;$d$1534$i = $a$3539$i;
          while(1) {
           $225 = HEAP32[$d$1534$i>>2]|0;
           $and282$i = $225 & $sub281$i;
           $shr283$i = $225 >>> $cond271$i;
           $add284$i = (($shr283$i) + ($carry262$0535$i))|0;
           HEAP32[$d$1534$i>>2] = $add284$i;
           $mul286$i = Math_imul($and282$i, $shr285$i)|0;
           $incdec$ptr288$i = ((($d$1534$i)) + 4|0);
           $cmp277$i = ($incdec$ptr288$i>>>0)<($z$3538$i>>>0);
           if ($cmp277$i) {
            $carry262$0535$i = $mul286$i;$d$1534$i = $incdec$ptr288$i;
           } else {
            $mul286$i$lcssa = $mul286$i;
            break;
           }
          }
          $226 = HEAP32[$a$3539$i>>2]|0;
          $tobool290$i = ($226|0)==(0);
          $incdec$ptr292$i = ((($a$3539$i)) + 4|0);
          $incdec$ptr292$a$3$i = $tobool290$i ? $incdec$ptr292$i : $a$3539$i;
          $tobool294$i = ($mul286$i$lcssa|0)==(0);
          if ($tobool294$i) {
           $incdec$ptr292$a$3573$i = $incdec$ptr292$a$3$i;$z$4$i = $z$3538$i;
           break;
          }
          $incdec$ptr296$i = ((($z$3538$i)) + 4|0);
          HEAP32[$z$3538$i>>2] = $mul286$i$lcssa;
          $incdec$ptr292$a$3573$i = $incdec$ptr292$a$3$i;$z$4$i = $incdec$ptr296$i;
         } else {
          $224 = HEAP32[$a$3539$i>>2]|0;
          $tobool290$569$i = ($224|0)==(0);
          $incdec$ptr292$570$i = ((($a$3539$i)) + 4|0);
          $incdec$ptr292$a$3$571$i = $tobool290$569$i ? $incdec$ptr292$570$i : $a$3539$i;
          $incdec$ptr292$a$3573$i = $incdec$ptr292$a$3$571$i;$z$4$i = $z$3538$i;
         }
        } while(0);
        $cond304$i = $cmp299$i ? $arraydecay208$add$ptr213$i : $incdec$ptr292$a$3573$i;
        $sub$ptr$lhs$cast305$i = $z$4$i;
        $sub$ptr$rhs$cast306$i = $cond304$i;
        $sub$ptr$sub307$i = (($sub$ptr$lhs$cast305$i) - ($sub$ptr$rhs$cast306$i))|0;
        $sub$ptr$div$i = $sub$ptr$sub307$i >> 2;
        $cmp308$i = ($sub$ptr$div$i|0)>($add275$i|0);
        $add$ptr311$i = (($cond304$i) + ($add275$i<<2)|0);
        $add$ptr311$z$4$i = $cmp308$i ? $add$ptr311$i : $z$4$i;
        $227 = HEAP32[$e2$i>>2]|0;
        $add313$i = (($227) + ($cond271$i))|0;
        HEAP32[$e2$i>>2] = $add313$i;
        $cmp259$i = ($add313$i|0)<(0);
        if ($cmp259$i) {
         $223 = $add313$i;$a$3539$i = $incdec$ptr292$a$3573$i;$z$3538$i = $add$ptr311$z$4$i;
        } else {
         $a$3$lcssa$i = $incdec$ptr292$a$3573$i;$z$3$lcssa$i = $add$ptr311$z$4$i;
         break;
        }
       }
      } else {
       $a$3$lcssa$i = $a$1$lcssa$i;$z$3$lcssa$i = $z$1$lcssa$i;
      }
      $cmp315$i = ($a$3$lcssa$i>>>0)<($z$3$lcssa$i>>>0);
      do {
       if ($cmp315$i) {
        $sub$ptr$rhs$cast319$i = $a$3$lcssa$i;
        $sub$ptr$sub320$i = (($sub$ptr$rhs$cast345$i) - ($sub$ptr$rhs$cast319$i))|0;
        $sub$ptr$div321$i = $sub$ptr$sub320$i >> 2;
        $mul322$i = ($sub$ptr$div321$i*9)|0;
        $228 = HEAP32[$a$3$lcssa$i>>2]|0;
        $cmp324$529$i = ($228>>>0)<(10);
        if ($cmp324$529$i) {
         $e$1$i = $mul322$i;
         break;
        } else {
         $e$0531$i = $mul322$i;$i$0530$i = 10;
        }
        while(1) {
         $mul328$i = ($i$0530$i*10)|0;
         $inc$i = (($e$0531$i) + 1)|0;
         $cmp324$i = ($228>>>0)<($mul328$i>>>0);
         if ($cmp324$i) {
          $e$1$i = $inc$i;
          break;
         } else {
          $e$0531$i = $inc$i;$i$0530$i = $mul328$i;
         }
        }
       } else {
        $e$1$i = 0;
       }
      } while(0);
      $cmp333$i = ($or$i$241|0)!=(102);
      $mul335$i = $cmp333$i ? $e$1$i : 0;
      $sub336$i = (($$p$i) - ($mul335$i))|0;
      $cmp338$i = ($or$i$241|0)==(103);
      $tobool341$i = ($$p$i|0)!=(0);
      $229 = $tobool341$i & $cmp338$i;
      $land$ext$neg$i = $229 << 31 >> 31;
      $sub343$i = (($sub336$i) + ($land$ext$neg$i))|0;
      $sub$ptr$lhs$cast344$i = $z$3$lcssa$i;
      $sub$ptr$sub346$i = (($sub$ptr$lhs$cast344$i) - ($sub$ptr$rhs$cast345$i))|0;
      $sub$ptr$div347$i = $sub$ptr$sub346$i >> 2;
      $230 = ($sub$ptr$div347$i*9)|0;
      $mul349$i = (($230) + -9)|0;
      $cmp350$i = ($sub343$i|0)<($mul349$i|0);
      if ($cmp350$i) {
       $add$ptr354$i = ((($arraydecay208$add$ptr213$i)) + 4|0);
       $add355$i = (($sub343$i) + 9216)|0;
       $div356$i = (($add355$i|0) / 9)&-1;
       $sub357$i = (($div356$i) + -1024)|0;
       $add$ptr358$i = (($add$ptr354$i) + ($sub357$i<<2)|0);
       $rem360$i = (($add355$i|0) % 9)&-1;
       $j$0$524$i = (($rem360$i) + 1)|0;
       $cmp363$525$i = ($j$0$524$i|0)<(9);
       if ($cmp363$525$i) {
        $i$1526$i = 10;$j$0527$i = $j$0$524$i;
        while(1) {
         $mul367$i = ($i$1526$i*10)|0;
         $j$0$i = (($j$0527$i) + 1)|0;
         $exitcond$i = ($j$0$i|0)==(9);
         if ($exitcond$i) {
          $i$1$lcssa$i = $mul367$i;
          break;
         } else {
          $i$1526$i = $mul367$i;$j$0527$i = $j$0$i;
         }
        }
       } else {
        $i$1$lcssa$i = 10;
       }
       $231 = HEAP32[$add$ptr358$i>>2]|0;
       $rem370$i = (($231>>>0) % ($i$1$lcssa$i>>>0))&-1;
       $tobool371$i = ($rem370$i|0)==(0);
       $add$ptr373$i = ((($add$ptr358$i)) + 4|0);
       $cmp374$i = ($add$ptr373$i|0)==($z$3$lcssa$i|0);
       $or$cond395$i = $cmp374$i & $tobool371$i;
       do {
        if ($or$cond395$i) {
         $a$8$i = $a$3$lcssa$i;$d$4$i = $add$ptr358$i;$e$4$i = $e$1$i;
        } else {
         $div378$i = (($231>>>0) / ($i$1$lcssa$i>>>0))&-1;
         $and379$i = $div378$i & 1;
         $tobool380$i = ($and379$i|0)==(0);
         $$396$i = $tobool380$i ? 9007199254740992.0 : 9007199254740994.0;
         $div384$i = (($i$1$lcssa$i|0) / 2)&-1;
         $cmp385$i = ($rem370$i>>>0)<($div384$i>>>0);
         if ($cmp385$i) {
          $small$0$i = 0.5;
         } else {
          $cmp390$i = ($rem370$i|0)==($div384$i|0);
          $or$cond397$i = $cmp374$i & $cmp390$i;
          $$404$i = $or$cond397$i ? 1.0 : 1.5;
          $small$0$i = $$404$i;
         }
         $tobool400$i = ($pl$0$i|0)==(0);
         do {
          if ($tobool400$i) {
           $round377$1$i = $$396$i;$small$1$i = $small$0$i;
          } else {
           $232 = HEAP8[$prefix$0$i>>0]|0;
           $cmp403$i = ($232<<24>>24)==(45);
           if (!($cmp403$i)) {
            $round377$1$i = $$396$i;$small$1$i = $small$0$i;
            break;
           }
           $mul406$i = -$$396$i;
           $mul407$i = -$small$0$i;
           $round377$1$i = $mul406$i;$small$1$i = $mul407$i;
          }
         } while(0);
         $sub409$i = (($231) - ($rem370$i))|0;
         HEAP32[$add$ptr358$i>>2] = $sub409$i;
         $add410$i = $round377$1$i + $small$1$i;
         $cmp411$i = $add410$i != $round377$1$i;
         if (!($cmp411$i)) {
          $a$8$i = $a$3$lcssa$i;$d$4$i = $add$ptr358$i;$e$4$i = $e$1$i;
          break;
         }
         $add414$i = (($sub409$i) + ($i$1$lcssa$i))|0;
         HEAP32[$add$ptr358$i>>2] = $add414$i;
         $cmp416$519$i = ($add414$i>>>0)>(999999999);
         if ($cmp416$519$i) {
          $a$5521$i = $a$3$lcssa$i;$d$2520$i = $add$ptr358$i;
          while(1) {
           $incdec$ptr419$i = ((($d$2520$i)) + -4|0);
           HEAP32[$d$2520$i>>2] = 0;
           $cmp420$i = ($incdec$ptr419$i>>>0)<($a$5521$i>>>0);
           if ($cmp420$i) {
            $incdec$ptr423$i = ((($a$5521$i)) + -4|0);
            HEAP32[$incdec$ptr423$i>>2] = 0;
            $a$6$i = $incdec$ptr423$i;
           } else {
            $a$6$i = $a$5521$i;
           }
           $233 = HEAP32[$incdec$ptr419$i>>2]|0;
           $inc425$i = (($233) + 1)|0;
           HEAP32[$incdec$ptr419$i>>2] = $inc425$i;
           $cmp416$i = ($inc425$i>>>0)>(999999999);
           if ($cmp416$i) {
            $a$5521$i = $a$6$i;$d$2520$i = $incdec$ptr419$i;
           } else {
            $a$5$lcssa$i = $a$6$i;$d$2$lcssa$i = $incdec$ptr419$i;
            break;
           }
          }
         } else {
          $a$5$lcssa$i = $a$3$lcssa$i;$d$2$lcssa$i = $add$ptr358$i;
         }
         $sub$ptr$rhs$cast428$i = $a$5$lcssa$i;
         $sub$ptr$sub429$i = (($sub$ptr$rhs$cast345$i) - ($sub$ptr$rhs$cast428$i))|0;
         $sub$ptr$div430$i = $sub$ptr$sub429$i >> 2;
         $mul431$i = ($sub$ptr$div430$i*9)|0;
         $234 = HEAP32[$a$5$lcssa$i>>2]|0;
         $cmp433$515$i = ($234>>>0)<(10);
         if ($cmp433$515$i) {
          $a$8$i = $a$5$lcssa$i;$d$4$i = $d$2$lcssa$i;$e$4$i = $mul431$i;
          break;
         } else {
          $e$2517$i = $mul431$i;$i$2516$i = 10;
         }
         while(1) {
          $mul437$i = ($i$2516$i*10)|0;
          $inc438$i = (($e$2517$i) + 1)|0;
          $cmp433$i = ($234>>>0)<($mul437$i>>>0);
          if ($cmp433$i) {
           $a$8$i = $a$5$lcssa$i;$d$4$i = $d$2$lcssa$i;$e$4$i = $inc438$i;
           break;
          } else {
           $e$2517$i = $inc438$i;$i$2516$i = $mul437$i;
          }
         }
        }
       } while(0);
       $add$ptr442$i = ((($d$4$i)) + 4|0);
       $cmp443$i = ($z$3$lcssa$i>>>0)>($add$ptr442$i>>>0);
       $add$ptr442$z$3$i = $cmp443$i ? $add$ptr442$i : $z$3$lcssa$i;
       $a$9$ph$i = $a$8$i;$e$5$ph$i = $e$4$i;$z$7$ph$i = $add$ptr442$z$3$i;
      } else {
       $a$9$ph$i = $a$3$lcssa$i;$e$5$ph$i = $e$1$i;$z$7$ph$i = $z$3$lcssa$i;
      }
      $sub626$le$i = (0 - ($e$5$ph$i))|0;
      $z$7$i = $z$7$ph$i;
      while(1) {
       $cmp450$i = ($z$7$i>>>0)>($a$9$ph$i>>>0);
       if (!($cmp450$i)) {
        $cmp450$lcssa$i = 0;$z$7$i$lcssa = $z$7$i;
        break;
       }
       $arrayidx453$i = ((($z$7$i)) + -4|0);
       $235 = HEAP32[$arrayidx453$i>>2]|0;
       $lnot455$i = ($235|0)==(0);
       if ($lnot455$i) {
        $z$7$i = $arrayidx453$i;
       } else {
        $cmp450$lcssa$i = 1;$z$7$i$lcssa = $z$7$i;
        break;
       }
      }
      do {
       if ($cmp338$i) {
        $236 = $tobool341$i&1;
        $inc468$i = $236 ^ 1;
        $$p$inc468$i = (($inc468$i) + ($$p$i))|0;
        $cmp470$i = ($$p$inc468$i|0)>($e$5$ph$i|0);
        $cmp473$i = ($e$5$ph$i|0)>(-5);
        $or$cond2$i = $cmp470$i & $cmp473$i;
        if ($or$cond2$i) {
         $dec476$i = (($t$0) + -1)|0;
         $add477$neg$i = (($$p$inc468$i) + -1)|0;
         $sub478$i = (($add477$neg$i) - ($e$5$ph$i))|0;
         $p$addr$2$i = $sub478$i;$t$addr$0$i = $dec476$i;
        } else {
         $sub480$i = (($t$0) + -2)|0;
         $dec481$i = (($$p$inc468$i) + -1)|0;
         $p$addr$2$i = $dec481$i;$t$addr$0$i = $sub480$i;
        }
        $and483$i = $fl$1$and219 & 8;
        $tobool484$i = ($and483$i|0)==(0);
        if (!($tobool484$i)) {
         $and610$pre$phi$iZ2D = $and483$i;$p$addr$3$i = $p$addr$2$i;$t$addr$1$i = $t$addr$0$i;
         break;
        }
        do {
         if ($cmp450$lcssa$i) {
          $arrayidx489$i = ((($z$7$i$lcssa)) + -4|0);
          $237 = HEAP32[$arrayidx489$i>>2]|0;
          $tobool490$i = ($237|0)==(0);
          if ($tobool490$i) {
           $j$2$i = 9;
           break;
          }
          $rem494$510$i = (($237>>>0) % 10)&-1;
          $cmp495$511$i = ($rem494$510$i|0)==(0);
          if ($cmp495$511$i) {
           $i$3512$i = 10;$j$1513$i = 0;
          } else {
           $j$2$i = 0;
           break;
          }
          while(1) {
           $mul499$i = ($i$3512$i*10)|0;
           $inc500$i = (($j$1513$i) + 1)|0;
           $rem494$i = (($237>>>0) % ($mul499$i>>>0))&-1;
           $cmp495$i = ($rem494$i|0)==(0);
           if ($cmp495$i) {
            $i$3512$i = $mul499$i;$j$1513$i = $inc500$i;
           } else {
            $j$2$i = $inc500$i;
            break;
           }
          }
         } else {
          $j$2$i = 9;
         }
        } while(0);
        $or504$i = $t$addr$0$i | 32;
        $cmp505$i = ($or504$i|0)==(102);
        $sub$ptr$lhs$cast508$i = $z$7$i$lcssa;
        $sub$ptr$sub510$i = (($sub$ptr$lhs$cast508$i) - ($sub$ptr$rhs$cast345$i))|0;
        $sub$ptr$div511$i = $sub$ptr$sub510$i >> 2;
        $238 = ($sub$ptr$div511$i*9)|0;
        $mul513$i = (($238) + -9)|0;
        if ($cmp505$i) {
         $sub514$i = (($mul513$i) - ($j$2$i))|0;
         $cmp515$i = ($sub514$i|0)<(0);
         $$sub514$i = $cmp515$i ? 0 : $sub514$i;
         $cmp528$i = ($p$addr$2$i|0)<($$sub514$i|0);
         $p$addr$2$$sub514398$i = $cmp528$i ? $p$addr$2$i : $$sub514$i;
         $and610$pre$phi$iZ2D = 0;$p$addr$3$i = $p$addr$2$$sub514398$i;$t$addr$1$i = $t$addr$0$i;
         break;
        } else {
         $add561$i = (($mul513$i) + ($e$5$ph$i))|0;
         $sub562$i = (($add561$i) - ($j$2$i))|0;
         $cmp563$i = ($sub562$i|0)<(0);
         $$sub562$i = $cmp563$i ? 0 : $sub562$i;
         $cmp577$i = ($p$addr$2$i|0)<($$sub562$i|0);
         $p$addr$2$$sub562399$i = $cmp577$i ? $p$addr$2$i : $$sub562$i;
         $and610$pre$phi$iZ2D = 0;$p$addr$3$i = $p$addr$2$$sub562399$i;$t$addr$1$i = $t$addr$0$i;
         break;
        }
       } else {
        $$pre567$i = $fl$1$and219 & 8;
        $and610$pre$phi$iZ2D = $$pre567$i;$p$addr$3$i = $$p$i;$t$addr$1$i = $t$0;
       }
      } while(0);
      $239 = $p$addr$3$i | $and610$pre$phi$iZ2D;
      $240 = ($239|0)!=(0);
      $lor$ext$i = $240&1;
      $or613$i = $t$addr$1$i | 32;
      $cmp614$i = ($or613$i|0)==(102);
      if ($cmp614$i) {
       $cmp617$i = ($e$5$ph$i|0)>(0);
       $add620$i = $cmp617$i ? $e$5$ph$i : 0;
       $estr$2$i = 0;$sub$ptr$sub650$pn$i = $add620$i;
      } else {
       $cmp623$i = ($e$5$ph$i|0)<(0);
       $cond629$i = $cmp623$i ? $sub626$le$i : $e$5$ph$i;
       $241 = ($cond629$i|0)<(0);
       $242 = $241 << 31 >> 31;
       $243 = (_fmt_u($cond629$i,$242,$arrayidx$i$236)|0);
       $sub$ptr$rhs$cast634$504$i = $243;
       $sub$ptr$sub635$505$i = (($sub$ptr$lhs$cast160$i) - ($sub$ptr$rhs$cast634$504$i))|0;
       $cmp636$506$i = ($sub$ptr$sub635$505$i|0)<(2);
       if ($cmp636$506$i) {
        $estr$1507$i = $243;
        while(1) {
         $incdec$ptr639$i = ((($estr$1507$i)) + -1|0);
         HEAP8[$incdec$ptr639$i>>0] = 48;
         $sub$ptr$rhs$cast634$i = $incdec$ptr639$i;
         $sub$ptr$sub635$i = (($sub$ptr$lhs$cast160$i) - ($sub$ptr$rhs$cast634$i))|0;
         $cmp636$i = ($sub$ptr$sub635$i|0)<(2);
         if ($cmp636$i) {
          $estr$1507$i = $incdec$ptr639$i;
         } else {
          $estr$1$lcssa$i = $incdec$ptr639$i;
          break;
         }
        }
       } else {
        $estr$1$lcssa$i = $243;
       }
       $244 = $e$5$ph$i >> 31;
       $245 = $244 & 2;
       $246 = (($245) + 43)|0;
       $conv644$i = $246&255;
       $incdec$ptr645$i = ((($estr$1$lcssa$i)) + -1|0);
       HEAP8[$incdec$ptr645$i>>0] = $conv644$i;
       $conv646$i = $t$addr$1$i&255;
       $incdec$ptr647$i = ((($estr$1$lcssa$i)) + -2|0);
       HEAP8[$incdec$ptr647$i>>0] = $conv646$i;
       $sub$ptr$rhs$cast649$i = $incdec$ptr647$i;
       $sub$ptr$sub650$i = (($sub$ptr$lhs$cast160$i) - ($sub$ptr$rhs$cast649$i))|0;
       $estr$2$i = $incdec$ptr647$i;$sub$ptr$sub650$pn$i = $sub$ptr$sub650$i;
      }
      $add608$i = (($pl$0$i) + 1)|0;
      $add612$i = (($add608$i) + ($p$addr$3$i))|0;
      $l$1$i = (($add612$i) + ($lor$ext$i))|0;
      $add653$i = (($l$1$i) + ($sub$ptr$sub650$pn$i))|0;
      _pad($f,32,$w$1,$add653$i,$fl$1$and219);
      $247 = HEAP32[$f>>2]|0;
      $and$i$436$i = $247 & 32;
      $tobool$i$437$i = ($and$i$436$i|0)==(0);
      if ($tobool$i$437$i) {
       (___fwritex($prefix$0$i,$pl$0$i,$f)|0);
      }
      $xor655$i = $fl$1$and219 ^ 65536;
      _pad($f,48,$w$1,$add653$i,$xor655$i);
      do {
       if ($cmp614$i) {
        $cmp660$i = ($a$9$ph$i>>>0)>($arraydecay208$add$ptr213$i>>>0);
        $r$0$a$9$i = $cmp660$i ? $arraydecay208$add$ptr213$i : $a$9$ph$i;
        $d$5494$i = $r$0$a$9$i;
        while(1) {
         $248 = HEAP32[$d$5494$i>>2]|0;
         $249 = (_fmt_u($248,0,$add$ptr671$i)|0);
         $cmp673$i = ($d$5494$i|0)==($r$0$a$9$i|0);
         do {
          if ($cmp673$i) {
           $cmp686$i = ($249|0)==($add$ptr671$i|0);
           if (!($cmp686$i)) {
            $s668$1$i = $249;
            break;
           }
           HEAP8[$incdec$ptr689$i>>0] = 48;
           $s668$1$i = $incdec$ptr689$i;
          } else {
           $cmp678$491$i = ($249>>>0)>($buf$i>>>0);
           if ($cmp678$491$i) {
            $s668$0492$i = $249;
           } else {
            $s668$1$i = $249;
            break;
           }
           while(1) {
            $incdec$ptr681$i = ((($s668$0492$i)) + -1|0);
            HEAP8[$incdec$ptr681$i>>0] = 48;
            $cmp678$i = ($incdec$ptr681$i>>>0)>($buf$i>>>0);
            if ($cmp678$i) {
             $s668$0492$i = $incdec$ptr681$i;
            } else {
             $s668$1$i = $incdec$ptr681$i;
             break;
            }
           }
          }
         } while(0);
         $250 = HEAP32[$f>>2]|0;
         $and$i$442$i = $250 & 32;
         $tobool$i$443$i = ($and$i$442$i|0)==(0);
         if ($tobool$i$443$i) {
          $sub$ptr$rhs$cast695$i = $s668$1$i;
          $sub$ptr$sub696$i = (($sub$ptr$lhs$cast694$i) - ($sub$ptr$rhs$cast695$i))|0;
          (___fwritex($s668$1$i,$sub$ptr$sub696$i,$f)|0);
         }
         $incdec$ptr698$i = ((($d$5494$i)) + 4|0);
         $cmp665$i = ($incdec$ptr698$i>>>0)>($arraydecay208$add$ptr213$i>>>0);
         if ($cmp665$i) {
          $incdec$ptr698$i$lcssa = $incdec$ptr698$i;
          break;
         } else {
          $d$5494$i = $incdec$ptr698$i;
         }
        }
        $251 = ($239|0)==(0);
        do {
         if (!($251)) {
          $252 = HEAP32[$f>>2]|0;
          $and$i$448$i = $252 & 32;
          $tobool$i$449$i = ($and$i$448$i|0)==(0);
          if (!($tobool$i$449$i)) {
           break;
          }
          (___fwritex(4143,1,$f)|0);
         }
        } while(0);
        $cmp707$486$i = ($incdec$ptr698$i$lcssa>>>0)<($z$7$i$lcssa>>>0);
        $cmp710$487$i = ($p$addr$3$i|0)>(0);
        $253 = $cmp710$487$i & $cmp707$486$i;
        if ($253) {
         $d$6488$i = $incdec$ptr698$i$lcssa;$p$addr$4489$i = $p$addr$3$i;
         while(1) {
          $254 = HEAP32[$d$6488$i>>2]|0;
          $255 = (_fmt_u($254,0,$add$ptr671$i)|0);
          $cmp722$483$i = ($255>>>0)>($buf$i>>>0);
          if ($cmp722$483$i) {
           $s715$0484$i = $255;
           while(1) {
            $incdec$ptr725$i = ((($s715$0484$i)) + -1|0);
            HEAP8[$incdec$ptr725$i>>0] = 48;
            $cmp722$i = ($incdec$ptr725$i>>>0)>($buf$i>>>0);
            if ($cmp722$i) {
             $s715$0484$i = $incdec$ptr725$i;
            } else {
             $s715$0$lcssa$i = $incdec$ptr725$i;
             break;
            }
           }
          } else {
           $s715$0$lcssa$i = $255;
          }
          $256 = HEAP32[$f>>2]|0;
          $and$i$454$i = $256 & 32;
          $tobool$i$455$i = ($and$i$454$i|0)==(0);
          if ($tobool$i$455$i) {
           $cmp727$i = ($p$addr$4489$i|0)>(9);
           $cond732$i = $cmp727$i ? 9 : $p$addr$4489$i;
           (___fwritex($s715$0$lcssa$i,$cond732$i,$f)|0);
          }
          $incdec$ptr734$i = ((($d$6488$i)) + 4|0);
          $sub735$i = (($p$addr$4489$i) + -9)|0;
          $cmp707$i = ($incdec$ptr734$i>>>0)<($z$7$i$lcssa>>>0);
          $cmp710$i = ($p$addr$4489$i|0)>(9);
          $257 = $cmp710$i & $cmp707$i;
          if ($257) {
           $d$6488$i = $incdec$ptr734$i;$p$addr$4489$i = $sub735$i;
          } else {
           $p$addr$4$lcssa$i = $sub735$i;
           break;
          }
         }
        } else {
         $p$addr$4$lcssa$i = $p$addr$3$i;
        }
        $add737$i = (($p$addr$4$lcssa$i) + 9)|0;
        _pad($f,48,$add737$i,9,0);
       } else {
        $add$ptr742$i = ((($a$9$ph$i)) + 4|0);
        $z$7$add$ptr742$i = $cmp450$lcssa$i ? $z$7$i$lcssa : $add$ptr742$i;
        $cmp748$499$i = ($p$addr$3$i|0)>(-1);
        if ($cmp748$499$i) {
         $tobool781$i = ($and610$pre$phi$iZ2D|0)==(0);
         $d$7500$i = $a$9$ph$i;$p$addr$5501$i = $p$addr$3$i;
         while(1) {
          $258 = HEAP32[$d$7500$i>>2]|0;
          $259 = (_fmt_u($258,0,$add$ptr671$i)|0);
          $cmp760$i = ($259|0)==($add$ptr671$i|0);
          if ($cmp760$i) {
           HEAP8[$incdec$ptr689$i>>0] = 48;
           $s753$0$i = $incdec$ptr689$i;
          } else {
           $s753$0$i = $259;
          }
          $cmp765$i = ($d$7500$i|0)==($a$9$ph$i|0);
          do {
           if ($cmp765$i) {
            $incdec$ptr776$i = ((($s753$0$i)) + 1|0);
            $260 = HEAP32[$f>>2]|0;
            $and$i$460$i = $260 & 32;
            $tobool$i$461$i = ($and$i$460$i|0)==(0);
            if ($tobool$i$461$i) {
             (___fwritex($s753$0$i,1,$f)|0);
            }
            $cmp777$i = ($p$addr$5501$i|0)<(1);
            $or$cond401$i = $tobool781$i & $cmp777$i;
            if ($or$cond401$i) {
             $s753$2$i = $incdec$ptr776$i;
             break;
            }
            $261 = HEAP32[$f>>2]|0;
            $and$i$466$i = $261 & 32;
            $tobool$i$467$i = ($and$i$466$i|0)==(0);
            if (!($tobool$i$467$i)) {
             $s753$2$i = $incdec$ptr776$i;
             break;
            }
            (___fwritex(4143,1,$f)|0);
            $s753$2$i = $incdec$ptr776$i;
           } else {
            $cmp770$495$i = ($s753$0$i>>>0)>($buf$i>>>0);
            if ($cmp770$495$i) {
             $s753$1496$i = $s753$0$i;
            } else {
             $s753$2$i = $s753$0$i;
             break;
            }
            while(1) {
             $incdec$ptr773$i = ((($s753$1496$i)) + -1|0);
             HEAP8[$incdec$ptr773$i>>0] = 48;
             $cmp770$i = ($incdec$ptr773$i>>>0)>($buf$i>>>0);
             if ($cmp770$i) {
              $s753$1496$i = $incdec$ptr773$i;
             } else {
              $s753$2$i = $incdec$ptr773$i;
              break;
             }
            }
           }
          } while(0);
          $sub$ptr$rhs$cast788$i = $s753$2$i;
          $sub$ptr$sub789$i = (($sub$ptr$lhs$cast694$i) - ($sub$ptr$rhs$cast788$i))|0;
          $262 = HEAP32[$f>>2]|0;
          $and$i$472$i = $262 & 32;
          $tobool$i$473$i = ($and$i$472$i|0)==(0);
          if ($tobool$i$473$i) {
           $cmp790$i = ($p$addr$5501$i|0)>($sub$ptr$sub789$i|0);
           $cond800$i = $cmp790$i ? $sub$ptr$sub789$i : $p$addr$5501$i;
           (___fwritex($s753$2$i,$cond800$i,$f)|0);
          }
          $sub806$i = (($p$addr$5501$i) - ($sub$ptr$sub789$i))|0;
          $incdec$ptr808$i = ((($d$7500$i)) + 4|0);
          $cmp745$i = ($incdec$ptr808$i>>>0)<($z$7$add$ptr742$i>>>0);
          $cmp748$i = ($sub806$i|0)>(-1);
          $263 = $cmp745$i & $cmp748$i;
          if ($263) {
           $d$7500$i = $incdec$ptr808$i;$p$addr$5501$i = $sub806$i;
          } else {
           $p$addr$5$lcssa$i = $sub806$i;
           break;
          }
         }
        } else {
         $p$addr$5$lcssa$i = $p$addr$3$i;
        }
        $add810$i = (($p$addr$5$lcssa$i) + 18)|0;
        _pad($f,48,$add810$i,18,0);
        $264 = HEAP32[$f>>2]|0;
        $and$i$i = $264 & 32;
        $tobool$i$i = ($and$i$i|0)==(0);
        if (!($tobool$i$i)) {
         break;
        }
        $sub$ptr$rhs$cast812$i = $estr$2$i;
        $sub$ptr$sub813$i = (($sub$ptr$lhs$cast160$i) - ($sub$ptr$rhs$cast812$i))|0;
        (___fwritex($estr$2$i,$sub$ptr$sub813$i,$f)|0);
       }
      } while(0);
      $xor816$i = $fl$1$and219 ^ 8192;
      _pad($f,32,$w$1,$add653$i,$xor816$i);
      $cmp818$i = ($add653$i|0)<($w$1|0);
      $w$add653$i = $cmp818$i ? $w$1 : $add653$i;
      $retval$0$i = $w$add653$i;
     } else {
      $and36$i = $t$0 & 32;
      $tobool37$i = ($and36$i|0)!=(0);
      $cond$i = $tobool37$i ? 4127 : 4131;
      $cmp38$i = ($y$addr$0$i != $y$addr$0$i) | (0.0 != 0.0);
      $cond43$i = $tobool37$i ? 4135 : 4139;
      $pl$1$i = $cmp38$i ? 0 : $pl$0$i;
      $s35$0$i = $cmp38$i ? $cond43$i : $cond$i;
      $add$i$239 = (($pl$1$i) + 3)|0;
      _pad($f,32,$w$1,$add$i$239,$and219);
      $193 = HEAP32[$f>>2]|0;
      $and$i$406$i = $193 & 32;
      $tobool$i$407$i = ($and$i$406$i|0)==(0);
      if ($tobool$i$407$i) {
       (___fwritex($prefix$0$i,$pl$1$i,$f)|0);
       $$pre$i = HEAP32[$f>>2]|0;
       $194 = $$pre$i;
      } else {
       $194 = $193;
      }
      $and$i$412$i = $194 & 32;
      $tobool$i$413$i = ($and$i$412$i|0)==(0);
      if ($tobool$i$413$i) {
       (___fwritex($s35$0$i,3,$f)|0);
      }
      $xor$i = $fl$1$and219 ^ 8192;
      _pad($f,32,$w$1,$add$i$239,$xor$i);
      $cmp48$i = ($add$i$239|0)<($w$1|0);
      $cond53$i = $cmp48$i ? $w$1 : $add$i$239;
      $retval$0$i = $cond53$i;
     }
    } while(0);
    $cnt$0 = $cnt$1;$incdec$ptr169275 = $incdec$ptr169$lcssa;$l$0 = $retval$0$i;$l10n$0 = $l10n$3;
    continue L1;
    break;
   }
   default: {
    $a$2 = $incdec$ptr169275;$fl$6 = $fl$1$and219;$p$5 = $p$0;$pl$2 = 0;$prefix$2 = 4091;$z$2 = $add$ptr205;
   }
   }
  } while(0);
  L308: do {
   if ((label|0) == 64) {
    label = 0;
    $90 = $arg;
    $91 = $90;
    $92 = HEAP32[$91>>2]|0;
    $93 = (($90) + 4)|0;
    $94 = $93;
    $95 = HEAP32[$94>>2]|0;
    $and249 = $t$1 & 32;
    $96 = ($92|0)==(0);
    $97 = ($95|0)==(0);
    $98 = $96 & $97;
    if ($98) {
     $a$0 = $add$ptr205;$fl$4 = $fl$3;$p$2 = $p$1;$pl$1 = 0;$prefix$1 = 4091;
     label = 77;
    } else {
     $101 = $95;$99 = $92;$s$addr$06$i = $add$ptr205;
     while(1) {
      $idxprom$i = $99 & 15;
      $arrayidx$i = (4075 + ($idxprom$i)|0);
      $100 = HEAP8[$arrayidx$i>>0]|0;
      $conv$4$i$211 = $100&255;
      $or$i = $conv$4$i$211 | $and249;
      $conv1$i = $or$i&255;
      $incdec$ptr$i$212 = ((($s$addr$06$i)) + -1|0);
      HEAP8[$incdec$ptr$i$212>>0] = $conv1$i;
      $102 = (_bitshift64Lshr(($99|0),($101|0),4)|0);
      $103 = tempRet0;
      $104 = ($102|0)==(0);
      $105 = ($103|0)==(0);
      $106 = $104 & $105;
      if ($106) {
       $incdec$ptr$i$212$lcssa = $incdec$ptr$i$212;
       break;
      } else {
       $101 = $103;$99 = $102;$s$addr$06$i = $incdec$ptr$i$212;
      }
     }
     $107 = $arg;
     $108 = $107;
     $109 = HEAP32[$108>>2]|0;
     $110 = (($107) + 4)|0;
     $111 = $110;
     $112 = HEAP32[$111>>2]|0;
     $113 = ($109|0)==(0);
     $114 = ($112|0)==(0);
     $115 = $113 & $114;
     $and254 = $fl$3 & 8;
     $tobool255 = ($and254|0)==(0);
     $or$cond193 = $tobool255 | $115;
     if ($or$cond193) {
      $a$0 = $incdec$ptr$i$212$lcssa;$fl$4 = $fl$3;$p$2 = $p$1;$pl$1 = 0;$prefix$1 = 4091;
      label = 77;
     } else {
      $shr = $t$1 >> 4;
      $add$ptr257 = (4091 + ($shr)|0);
      $a$0 = $incdec$ptr$i$212$lcssa;$fl$4 = $fl$3;$p$2 = $p$1;$pl$1 = 2;$prefix$1 = $add$ptr257;
      label = 77;
     }
    }
   }
   else if ((label|0) == 76) {
    label = 0;
    $150 = (_fmt_u($148,$149,$add$ptr205)|0);
    $a$0 = $150;$fl$4 = $fl$1$and219;$p$2 = $p$0;$pl$1 = $pl$0;$prefix$1 = $prefix$0;
    label = 77;
   }
   else if ((label|0) == 82) {
    label = 0;
    $call356 = (_memchr($a$1,0,$p$0)|0);
    $tobool357 = ($call356|0)==(0|0);
    $sub$ptr$lhs$cast361 = $call356;
    $sub$ptr$rhs$cast362 = $a$1;
    $sub$ptr$sub363 = (($sub$ptr$lhs$cast361) - ($sub$ptr$rhs$cast362))|0;
    $add$ptr359 = (($a$1) + ($p$0)|0);
    $z$1 = $tobool357 ? $add$ptr359 : $call356;
    $p$3 = $tobool357 ? $p$0 : $sub$ptr$sub363;
    $a$2 = $a$1;$fl$6 = $and219;$p$5 = $p$3;$pl$2 = 0;$prefix$2 = 4091;$z$2 = $z$1;
   }
   else if ((label|0) == 86) {
    label = 0;
    $176 = HEAP32[$arg>>2]|0;
    $i$0316 = 0;$l$1315 = 0;$ws$0317 = $176;
    while(1) {
     $177 = HEAP32[$ws$0317>>2]|0;
     $tobool380 = ($177|0)==(0);
     if ($tobool380) {
      $i$0$lcssa = $i$0316;$l$2 = $l$1315;
      break;
     }
     $call384 = (_wctomb($mb,$177)|0);
     $cmp385 = ($call384|0)<(0);
     $sub389 = (($p$4365) - ($i$0316))|0;
     $cmp390 = ($call384>>>0)>($sub389>>>0);
     $or$cond195 = $cmp385 | $cmp390;
     if ($or$cond195) {
      $i$0$lcssa = $i$0316;$l$2 = $call384;
      break;
     }
     $incdec$ptr383 = ((($ws$0317)) + 4|0);
     $add395 = (($call384) + ($i$0316))|0;
     $cmp377 = ($p$4365>>>0)>($add395>>>0);
     if ($cmp377) {
      $i$0316 = $add395;$l$1315 = $call384;$ws$0317 = $incdec$ptr383;
     } else {
      $i$0$lcssa = $add395;$l$2 = $call384;
      break;
     }
    }
    $cmp397 = ($l$2|0)<(0);
    if ($cmp397) {
     $retval$0 = -1;
     break L1;
    }
    _pad($f,32,$w$1,$i$0$lcssa,$fl$1$and219);
    $cmp404$324 = ($i$0$lcssa|0)==(0);
    if ($cmp404$324) {
     $i$0$lcssa368 = 0;
     label = 98;
    } else {
     $178 = HEAP32[$arg>>2]|0;
     $i$1325 = 0;$ws$1326 = $178;
     while(1) {
      $179 = HEAP32[$ws$1326>>2]|0;
      $tobool407 = ($179|0)==(0);
      if ($tobool407) {
       $i$0$lcssa368 = $i$0$lcssa;
       label = 98;
       break L308;
      }
      $incdec$ptr410 = ((($ws$1326)) + 4|0);
      $call411 = (_wctomb($mb,$179)|0);
      $add412 = (($call411) + ($i$1325))|0;
      $cmp413 = ($add412|0)>($i$0$lcssa|0);
      if ($cmp413) {
       $i$0$lcssa368 = $i$0$lcssa;
       label = 98;
       break L308;
      }
      $180 = HEAP32[$f>>2]|0;
      $and$i$231 = $180 & 32;
      $tobool$i$232 = ($and$i$231|0)==(0);
      if ($tobool$i$232) {
       (___fwritex($mb,$call411,$f)|0);
      }
      $cmp404 = ($add412>>>0)<($i$0$lcssa>>>0);
      if ($cmp404) {
       $i$1325 = $add412;$ws$1326 = $incdec$ptr410;
      } else {
       $i$0$lcssa368 = $i$0$lcssa;
       label = 98;
       break;
      }
     }
    }
   }
  } while(0);
  if ((label|0) == 98) {
   label = 0;
   $xor = $fl$1$and219 ^ 8192;
   _pad($f,32,$w$1,$i$0$lcssa368,$xor);
   $cmp421 = ($w$1|0)>($i$0$lcssa368|0);
   $cond426 = $cmp421 ? $w$1 : $i$0$lcssa368;
   $cnt$0 = $cnt$1;$incdec$ptr169275 = $incdec$ptr169$lcssa;$l$0 = $cond426;$l10n$0 = $l10n$3;
   continue;
  }
  if ((label|0) == 77) {
   label = 0;
   $cmp306 = ($p$2|0)>(-1);
   $and309 = $fl$4 & -65537;
   $and309$fl$4 = $cmp306 ? $and309 : $fl$4;
   $151 = $arg;
   $152 = $151;
   $153 = HEAP32[$152>>2]|0;
   $154 = (($151) + 4)|0;
   $155 = $154;
   $156 = HEAP32[$155>>2]|0;
   $157 = ($153|0)!=(0);
   $158 = ($156|0)!=(0);
   $159 = $157 | $158;
   $tobool314 = ($p$2|0)!=(0);
   $or$cond = $tobool314 | $159;
   if ($or$cond) {
    $sub$ptr$rhs$cast318 = $a$0;
    $sub$ptr$sub319 = (($sub$ptr$lhs$cast317) - ($sub$ptr$rhs$cast318))|0;
    $160 = $159&1;
    $lnot$ext = $160 ^ 1;
    $add322 = (($lnot$ext) + ($sub$ptr$sub319))|0;
    $cmp323 = ($p$2|0)>($add322|0);
    $p$2$add322 = $cmp323 ? $p$2 : $add322;
    $a$2 = $a$0;$fl$6 = $and309$fl$4;$p$5 = $p$2$add322;$pl$2 = $pl$1;$prefix$2 = $prefix$1;$z$2 = $add$ptr205;
   } else {
    $a$2 = $add$ptr205;$fl$6 = $and309$fl$4;$p$5 = 0;$pl$2 = $pl$1;$prefix$2 = $prefix$1;$z$2 = $add$ptr205;
   }
  }
  $sub$ptr$lhs$cast431 = $z$2;
  $sub$ptr$rhs$cast432 = $a$2;
  $sub$ptr$sub433 = (($sub$ptr$lhs$cast431) - ($sub$ptr$rhs$cast432))|0;
  $cmp434 = ($p$5|0)<($sub$ptr$sub433|0);
  $sub$ptr$sub433$p$5 = $cmp434 ? $sub$ptr$sub433 : $p$5;
  $add441 = (($pl$2) + ($sub$ptr$sub433$p$5))|0;
  $cmp442 = ($w$1|0)<($add441|0);
  $w$2 = $cmp442 ? $add441 : $w$1;
  _pad($f,32,$w$2,$add441,$fl$6);
  $265 = HEAP32[$f>>2]|0;
  $and$i$244 = $265 & 32;
  $tobool$i$245 = ($and$i$244|0)==(0);
  if ($tobool$i$245) {
   (___fwritex($prefix$2,$pl$2,$f)|0);
  }
  $xor449 = $fl$6 ^ 65536;
  _pad($f,48,$w$2,$add441,$xor449);
  _pad($f,48,$sub$ptr$sub433$p$5,$sub$ptr$sub433,0);
  $266 = HEAP32[$f>>2]|0;
  $and$i$216 = $266 & 32;
  $tobool$i$217 = ($and$i$216|0)==(0);
  if ($tobool$i$217) {
   (___fwritex($a$2,$sub$ptr$sub433,$f)|0);
  }
  $xor457 = $fl$6 ^ 8192;
  _pad($f,32,$w$2,$add441,$xor457);
  $cnt$0 = $cnt$1;$incdec$ptr169275 = $incdec$ptr169$lcssa;$l$0 = $w$2;$l10n$0 = $l10n$3;
 }
 L343: do {
  if ((label|0) == 242) {
   $tobool459 = ($f|0)==(0|0);
   if ($tobool459) {
    $tobool462 = ($l10n$0$lcssa|0)==(0);
    if ($tobool462) {
     $retval$0 = 0;
    } else {
     $i$2299 = 1;
     while(1) {
      $arrayidx469 = (($nl_type) + ($i$2299<<2)|0);
      $267 = HEAP32[$arrayidx469>>2]|0;
      $tobool470 = ($267|0)==(0);
      if ($tobool470) {
       $i$2299$lcssa = $i$2299;
       break;
      }
      $add$ptr473 = (($nl_arg) + ($i$2299<<3)|0);
      _pop_arg_336($add$ptr473,$267,$ap);
      $inc = (($i$2299) + 1)|0;
      $cmp466 = ($inc|0)<(10);
      if ($cmp466) {
       $i$2299 = $inc;
      } else {
       $retval$0 = 1;
       break L343;
      }
     }
     $cmp478$295 = ($i$2299$lcssa|0)<(10);
     if ($cmp478$295) {
      $i$3296 = $i$2299$lcssa;
      while(1) {
       $arrayidx481 = (($nl_type) + ($i$3296<<2)|0);
       $268 = HEAP32[$arrayidx481>>2]|0;
       $lnot483 = ($268|0)==(0);
       $inc488 = (($i$3296) + 1)|0;
       if (!($lnot483)) {
        $retval$0 = -1;
        break L343;
       }
       $cmp478 = ($inc488|0)<(10);
       if ($cmp478) {
        $i$3296 = $inc488;
       } else {
        $retval$0 = 1;
        break;
       }
      }
     } else {
      $retval$0 = 1;
     }
    }
   } else {
    $retval$0 = $cnt$1$lcssa;
   }
  }
 } while(0);
 STACKTOP = sp;return ($retval$0|0);
}
function _pop_arg_336($arg,$type,$ap) {
 $arg = $arg|0;
 $type = $type|0;
 $ap = $ap|0;
 var $0 = 0, $1 = 0, $10 = 0, $100 = 0, $101 = 0, $102 = 0, $103 = 0.0, $104 = 0, $105 = 0, $106 = 0, $107 = 0, $108 = 0, $109 = 0, $11 = 0, $110 = 0.0, $12 = 0, $13 = 0, $14 = 0, $15 = 0, $16 = 0;
 var $17 = 0, $18 = 0, $19 = 0, $2 = 0, $20 = 0, $21 = 0, $22 = 0, $23 = 0, $24 = 0, $25 = 0, $26 = 0, $27 = 0, $28 = 0, $29 = 0, $3 = 0, $30 = 0, $31 = 0, $32 = 0, $33 = 0, $34 = 0;
 var $35 = 0, $36 = 0, $37 = 0, $38 = 0, $39 = 0, $4 = 0, $40 = 0, $41 = 0, $42 = 0, $43 = 0, $44 = 0, $45 = 0, $46 = 0, $47 = 0, $48 = 0, $49 = 0, $5 = 0, $50 = 0, $51 = 0, $52 = 0;
 var $53 = 0, $54 = 0, $55 = 0, $56 = 0, $57 = 0, $58 = 0, $59 = 0, $6 = 0, $60 = 0, $61 = 0, $62 = 0, $63 = 0, $64 = 0, $65 = 0, $66 = 0, $67 = 0, $68 = 0, $69 = 0, $7 = 0, $70 = 0;
 var $71 = 0, $72 = 0, $73 = 0, $74 = 0, $75 = 0, $76 = 0, $77 = 0, $78 = 0, $79 = 0, $8 = 0, $80 = 0, $81 = 0, $82 = 0, $83 = 0, $84 = 0, $85 = 0, $86 = 0, $87 = 0, $88 = 0, $89 = 0;
 var $9 = 0, $90 = 0, $91 = 0, $92 = 0, $93 = 0, $94 = 0, $95 = 0, $96 = 0, $97 = 0, $98 = 0, $99 = 0, $arglist_current = 0, $arglist_current11 = 0, $arglist_current14 = 0, $arglist_current17 = 0, $arglist_current2 = 0, $arglist_current20 = 0, $arglist_current23 = 0, $arglist_current26 = 0, $arglist_current5 = 0;
 var $arglist_current8 = 0, $arglist_next = 0, $arglist_next12 = 0, $arglist_next15 = 0, $arglist_next18 = 0, $arglist_next21 = 0, $arglist_next24 = 0, $arglist_next27 = 0, $arglist_next3 = 0, $arglist_next6 = 0, $arglist_next9 = 0, $cmp = 0, $conv12 = 0, $conv17$mask = 0, $conv22 = 0, $conv27$mask = 0, $expanded = 0, $expanded28 = 0, $expanded30 = 0, $expanded31 = 0;
 var $expanded32 = 0, $expanded34 = 0, $expanded35 = 0, $expanded37 = 0, $expanded38 = 0, $expanded39 = 0, $expanded41 = 0, $expanded42 = 0, $expanded44 = 0, $expanded45 = 0, $expanded46 = 0, $expanded48 = 0, $expanded49 = 0, $expanded51 = 0, $expanded52 = 0, $expanded53 = 0, $expanded55 = 0, $expanded56 = 0, $expanded58 = 0, $expanded59 = 0;
 var $expanded60 = 0, $expanded62 = 0, $expanded63 = 0, $expanded65 = 0, $expanded66 = 0, $expanded67 = 0, $expanded69 = 0, $expanded70 = 0, $expanded72 = 0, $expanded73 = 0, $expanded74 = 0, $expanded76 = 0, $expanded77 = 0, $expanded79 = 0, $expanded80 = 0, $expanded81 = 0, $expanded83 = 0, $expanded84 = 0, $expanded86 = 0, $expanded87 = 0;
 var $expanded88 = 0, $expanded90 = 0, $expanded91 = 0, $expanded93 = 0, $expanded94 = 0, $expanded95 = 0, label = 0, sp = 0;
 sp = STACKTOP;
 $cmp = ($type>>>0)>(20);
 L1: do {
  if (!($cmp)) {
   do {
    switch ($type|0) {
    case 9:  {
     $arglist_current = HEAP32[$ap>>2]|0;
     $0 = $arglist_current;
     $1 = ((0) + 4|0);
     $expanded28 = $1;
     $expanded = (($expanded28) - 1)|0;
     $2 = (($0) + ($expanded))|0;
     $3 = ((0) + 4|0);
     $expanded32 = $3;
     $expanded31 = (($expanded32) - 1)|0;
     $expanded30 = $expanded31 ^ -1;
     $4 = $2 & $expanded30;
     $5 = $4;
     $6 = HEAP32[$5>>2]|0;
     $arglist_next = ((($5)) + 4|0);
     HEAP32[$ap>>2] = $arglist_next;
     HEAP32[$arg>>2] = $6;
     break L1;
     break;
    }
    case 10:  {
     $arglist_current2 = HEAP32[$ap>>2]|0;
     $7 = $arglist_current2;
     $8 = ((0) + 4|0);
     $expanded35 = $8;
     $expanded34 = (($expanded35) - 1)|0;
     $9 = (($7) + ($expanded34))|0;
     $10 = ((0) + 4|0);
     $expanded39 = $10;
     $expanded38 = (($expanded39) - 1)|0;
     $expanded37 = $expanded38 ^ -1;
     $11 = $9 & $expanded37;
     $12 = $11;
     $13 = HEAP32[$12>>2]|0;
     $arglist_next3 = ((($12)) + 4|0);
     HEAP32[$ap>>2] = $arglist_next3;
     $14 = ($13|0)<(0);
     $15 = $14 << 31 >> 31;
     $16 = $arg;
     $17 = $16;
     HEAP32[$17>>2] = $13;
     $18 = (($16) + 4)|0;
     $19 = $18;
     HEAP32[$19>>2] = $15;
     break L1;
     break;
    }
    case 11:  {
     $arglist_current5 = HEAP32[$ap>>2]|0;
     $20 = $arglist_current5;
     $21 = ((0) + 4|0);
     $expanded42 = $21;
     $expanded41 = (($expanded42) - 1)|0;
     $22 = (($20) + ($expanded41))|0;
     $23 = ((0) + 4|0);
     $expanded46 = $23;
     $expanded45 = (($expanded46) - 1)|0;
     $expanded44 = $expanded45 ^ -1;
     $24 = $22 & $expanded44;
     $25 = $24;
     $26 = HEAP32[$25>>2]|0;
     $arglist_next6 = ((($25)) + 4|0);
     HEAP32[$ap>>2] = $arglist_next6;
     $27 = $arg;
     $28 = $27;
     HEAP32[$28>>2] = $26;
     $29 = (($27) + 4)|0;
     $30 = $29;
     HEAP32[$30>>2] = 0;
     break L1;
     break;
    }
    case 12:  {
     $arglist_current8 = HEAP32[$ap>>2]|0;
     $31 = $arglist_current8;
     $32 = ((0) + 8|0);
     $expanded49 = $32;
     $expanded48 = (($expanded49) - 1)|0;
     $33 = (($31) + ($expanded48))|0;
     $34 = ((0) + 8|0);
     $expanded53 = $34;
     $expanded52 = (($expanded53) - 1)|0;
     $expanded51 = $expanded52 ^ -1;
     $35 = $33 & $expanded51;
     $36 = $35;
     $37 = $36;
     $38 = $37;
     $39 = HEAP32[$38>>2]|0;
     $40 = (($37) + 4)|0;
     $41 = $40;
     $42 = HEAP32[$41>>2]|0;
     $arglist_next9 = ((($36)) + 8|0);
     HEAP32[$ap>>2] = $arglist_next9;
     $43 = $arg;
     $44 = $43;
     HEAP32[$44>>2] = $39;
     $45 = (($43) + 4)|0;
     $46 = $45;
     HEAP32[$46>>2] = $42;
     break L1;
     break;
    }
    case 13:  {
     $arglist_current11 = HEAP32[$ap>>2]|0;
     $47 = $arglist_current11;
     $48 = ((0) + 4|0);
     $expanded56 = $48;
     $expanded55 = (($expanded56) - 1)|0;
     $49 = (($47) + ($expanded55))|0;
     $50 = ((0) + 4|0);
     $expanded60 = $50;
     $expanded59 = (($expanded60) - 1)|0;
     $expanded58 = $expanded59 ^ -1;
     $51 = $49 & $expanded58;
     $52 = $51;
     $53 = HEAP32[$52>>2]|0;
     $arglist_next12 = ((($52)) + 4|0);
     HEAP32[$ap>>2] = $arglist_next12;
     $conv12 = $53&65535;
     $54 = $conv12 << 16 >> 16;
     $55 = ($54|0)<(0);
     $56 = $55 << 31 >> 31;
     $57 = $arg;
     $58 = $57;
     HEAP32[$58>>2] = $54;
     $59 = (($57) + 4)|0;
     $60 = $59;
     HEAP32[$60>>2] = $56;
     break L1;
     break;
    }
    case 14:  {
     $arglist_current14 = HEAP32[$ap>>2]|0;
     $61 = $arglist_current14;
     $62 = ((0) + 4|0);
     $expanded63 = $62;
     $expanded62 = (($expanded63) - 1)|0;
     $63 = (($61) + ($expanded62))|0;
     $64 = ((0) + 4|0);
     $expanded67 = $64;
     $expanded66 = (($expanded67) - 1)|0;
     $expanded65 = $expanded66 ^ -1;
     $65 = $63 & $expanded65;
     $66 = $65;
     $67 = HEAP32[$66>>2]|0;
     $arglist_next15 = ((($66)) + 4|0);
     HEAP32[$ap>>2] = $arglist_next15;
     $conv17$mask = $67 & 65535;
     $68 = $arg;
     $69 = $68;
     HEAP32[$69>>2] = $conv17$mask;
     $70 = (($68) + 4)|0;
     $71 = $70;
     HEAP32[$71>>2] = 0;
     break L1;
     break;
    }
    case 15:  {
     $arglist_current17 = HEAP32[$ap>>2]|0;
     $72 = $arglist_current17;
     $73 = ((0) + 4|0);
     $expanded70 = $73;
     $expanded69 = (($expanded70) - 1)|0;
     $74 = (($72) + ($expanded69))|0;
     $75 = ((0) + 4|0);
     $expanded74 = $75;
     $expanded73 = (($expanded74) - 1)|0;
     $expanded72 = $expanded73 ^ -1;
     $76 = $74 & $expanded72;
     $77 = $76;
     $78 = HEAP32[$77>>2]|0;
     $arglist_next18 = ((($77)) + 4|0);
     HEAP32[$ap>>2] = $arglist_next18;
     $conv22 = $78&255;
     $79 = $conv22 << 24 >> 24;
     $80 = ($79|0)<(0);
     $81 = $80 << 31 >> 31;
     $82 = $arg;
     $83 = $82;
     HEAP32[$83>>2] = $79;
     $84 = (($82) + 4)|0;
     $85 = $84;
     HEAP32[$85>>2] = $81;
     break L1;
     break;
    }
    case 16:  {
     $arglist_current20 = HEAP32[$ap>>2]|0;
     $86 = $arglist_current20;
     $87 = ((0) + 4|0);
     $expanded77 = $87;
     $expanded76 = (($expanded77) - 1)|0;
     $88 = (($86) + ($expanded76))|0;
     $89 = ((0) + 4|0);
     $expanded81 = $89;
     $expanded80 = (($expanded81) - 1)|0;
     $expanded79 = $expanded80 ^ -1;
     $90 = $88 & $expanded79;
     $91 = $90;
     $92 = HEAP32[$91>>2]|0;
     $arglist_next21 = ((($91)) + 4|0);
     HEAP32[$ap>>2] = $arglist_next21;
     $conv27$mask = $92 & 255;
     $93 = $arg;
     $94 = $93;
     HEAP32[$94>>2] = $conv27$mask;
     $95 = (($93) + 4)|0;
     $96 = $95;
     HEAP32[$96>>2] = 0;
     break L1;
     break;
    }
    case 17:  {
     $arglist_current23 = HEAP32[$ap>>2]|0;
     $97 = $arglist_current23;
     $98 = ((0) + 8|0);
     $expanded84 = $98;
     $expanded83 = (($expanded84) - 1)|0;
     $99 = (($97) + ($expanded83))|0;
     $100 = ((0) + 8|0);
     $expanded88 = $100;
     $expanded87 = (($expanded88) - 1)|0;
     $expanded86 = $expanded87 ^ -1;
     $101 = $99 & $expanded86;
     $102 = $101;
     $103 = +HEAPF64[$102>>3];
     $arglist_next24 = ((($102)) + 8|0);
     HEAP32[$ap>>2] = $arglist_next24;
     HEAPF64[$arg>>3] = $103;
     break L1;
     break;
    }
    case 18:  {
     $arglist_current26 = HEAP32[$ap>>2]|0;
     $104 = $arglist_current26;
     $105 = ((0) + 8|0);
     $expanded91 = $105;
     $expanded90 = (($expanded91) - 1)|0;
     $106 = (($104) + ($expanded90))|0;
     $107 = ((0) + 8|0);
     $expanded95 = $107;
     $expanded94 = (($expanded95) - 1)|0;
     $expanded93 = $expanded94 ^ -1;
     $108 = $106 & $expanded93;
     $109 = $108;
     $110 = +HEAPF64[$109>>3];
     $arglist_next27 = ((($109)) + 8|0);
     HEAP32[$ap>>2] = $arglist_next27;
     HEAPF64[$arg>>3] = $110;
     break L1;
     break;
    }
    default: {
     break L1;
    }
    }
   } while(0);
  }
 } while(0);
 return;
}
function _fmt_u($0,$1,$s) {
 $0 = $0|0;
 $1 = $1|0;
 $s = $s|0;
 var $10 = 0, $11 = 0, $12 = 0, $13 = 0, $14 = 0, $15 = 0, $16 = 0, $17 = 0, $18 = 0, $19 = 0, $2 = 0, $20 = 0, $21 = 0, $22 = 0, $3 = 0, $4 = 0, $5 = 0, $6 = 0, $7 = 0, $8 = 0;
 var $9 = 0, $add5 = 0, $conv6 = 0, $div9 = 0, $incdec$ptr = 0, $incdec$ptr$lcssa = 0, $incdec$ptr7 = 0, $rem4 = 0, $s$addr$0$lcssa = 0, $s$addr$013 = 0, $s$addr$1$lcssa = 0, $s$addr$19 = 0, $tobool$8 = 0, $x$addr$0$lcssa$off0 = 0, $y$010 = 0, label = 0, sp = 0;
 sp = STACKTOP;
 $2 = ($1>>>0)>(0);
 $3 = ($0>>>0)>(4294967295);
 $4 = ($1|0)==(0);
 $5 = $4 & $3;
 $6 = $2 | $5;
 if ($6) {
  $7 = $0;$8 = $1;$s$addr$013 = $s;
  while(1) {
   $9 = (___uremdi3(($7|0),($8|0),10,0)|0);
   $10 = tempRet0;
   $11 = $9 | 48;
   $12 = $11&255;
   $incdec$ptr = ((($s$addr$013)) + -1|0);
   HEAP8[$incdec$ptr>>0] = $12;
   $13 = (___udivdi3(($7|0),($8|0),10,0)|0);
   $14 = tempRet0;
   $15 = ($8>>>0)>(9);
   $16 = ($7>>>0)>(4294967295);
   $17 = ($8|0)==(9);
   $18 = $17 & $16;
   $19 = $15 | $18;
   if ($19) {
    $7 = $13;$8 = $14;$s$addr$013 = $incdec$ptr;
   } else {
    $21 = $13;$22 = $14;$incdec$ptr$lcssa = $incdec$ptr;
    break;
   }
  }
  $s$addr$0$lcssa = $incdec$ptr$lcssa;$x$addr$0$lcssa$off0 = $21;
 } else {
  $s$addr$0$lcssa = $s;$x$addr$0$lcssa$off0 = $0;
 }
 $tobool$8 = ($x$addr$0$lcssa$off0|0)==(0);
 if ($tobool$8) {
  $s$addr$1$lcssa = $s$addr$0$lcssa;
 } else {
  $s$addr$19 = $s$addr$0$lcssa;$y$010 = $x$addr$0$lcssa$off0;
  while(1) {
   $rem4 = (($y$010>>>0) % 10)&-1;
   $add5 = $rem4 | 48;
   $conv6 = $add5&255;
   $incdec$ptr7 = ((($s$addr$19)) + -1|0);
   HEAP8[$incdec$ptr7>>0] = $conv6;
   $div9 = (($y$010>>>0) / 10)&-1;
   $20 = ($y$010>>>0)<(10);
   if ($20) {
    $s$addr$1$lcssa = $incdec$ptr7;
    break;
   } else {
    $s$addr$19 = $incdec$ptr7;$y$010 = $div9;
   }
  }
 }
 return ($s$addr$1$lcssa|0);
}
function _pad($f,$c,$w,$l,$fl) {
 $f = $f|0;
 $c = $c|0;
 $w = $w|0;
 $l = $l|0;
 $fl = $fl|0;
 var $$pre = 0, $0 = 0, $1 = 0, $2 = 0, $3 = 0, $4 = 0, $and = 0, $and$i = 0, $and$i$15 = 0, $cmp = 0, $cmp1 = 0, $cmp3 = 0, $cmp3$14 = 0, $cond = 0, $l$addr$0$lcssa21 = 0, $l$addr$017 = 0, $or$cond = 0, $pad = 0, $sub = 0, $sub5 = 0;
 var $tobool = 0, $tobool$i = 0, $tobool$i$16 = 0, $tobool$i18 = 0, label = 0, sp = 0;
 sp = STACKTOP;
 STACKTOP = STACKTOP + 256|0; if ((STACKTOP|0) >= (STACK_MAX|0)) abort();
 $pad = sp;
 $and = $fl & 73728;
 $tobool = ($and|0)==(0);
 $cmp = ($w|0)>($l|0);
 $or$cond = $cmp & $tobool;
 do {
  if ($or$cond) {
   $sub = (($w) - ($l))|0;
   $cmp1 = ($sub>>>0)>(256);
   $cond = $cmp1 ? 256 : $sub;
   _memset(($pad|0),($c|0),($cond|0))|0;
   $cmp3$14 = ($sub>>>0)>(255);
   $0 = HEAP32[$f>>2]|0;
   $and$i$15 = $0 & 32;
   $tobool$i$16 = ($and$i$15|0)==(0);
   if ($cmp3$14) {
    $1 = (($w) - ($l))|0;
    $4 = $0;$l$addr$017 = $sub;$tobool$i18 = $tobool$i$16;
    while(1) {
     if ($tobool$i18) {
      (___fwritex($pad,256,$f)|0);
      $$pre = HEAP32[$f>>2]|0;
      $2 = $$pre;
     } else {
      $2 = $4;
     }
     $sub5 = (($l$addr$017) + -256)|0;
     $cmp3 = ($sub5>>>0)>(255);
     $and$i = $2 & 32;
     $tobool$i = ($and$i|0)==(0);
     if ($cmp3) {
      $4 = $2;$l$addr$017 = $sub5;$tobool$i18 = $tobool$i;
     } else {
      break;
     }
    }
    $3 = $1 & 255;
    if ($tobool$i) {
     $l$addr$0$lcssa21 = $3;
    } else {
     break;
    }
   } else {
    if ($tobool$i$16) {
     $l$addr$0$lcssa21 = $sub;
    } else {
     break;
    }
   }
   (___fwritex($pad,$l$addr$0$lcssa21,$f)|0);
  }
 } while(0);
 STACKTOP = sp;return;
}
function _malloc($bytes) {
 $bytes = $bytes|0;
 var $$lcssa = 0, $$lcssa290 = 0, $$pre = 0, $$pre$i = 0, $$pre$i$177 = 0, $$pre$i$56$i = 0, $$pre$i$i = 0, $$pre$phi$i$178Z2D = 0, $$pre$phi$i$57$iZ2D = 0, $$pre$phi$i$iZ2D = 0, $$pre$phi$iZ2D = 0, $$pre$phiZ2D = 0, $$pre241 = 0, $$pre5$i$i = 0, $0 = 0, $1 = 0, $10 = 0, $100 = 0, $101 = 0, $102 = 0;
 var $103 = 0, $104 = 0, $105 = 0, $106 = 0, $107 = 0, $108 = 0, $109 = 0, $11 = 0, $110 = 0, $111 = 0, $112 = 0, $113 = 0, $114 = 0, $115 = 0, $116 = 0, $117 = 0, $118 = 0, $119 = 0, $12 = 0, $120 = 0;
 var $121 = 0, $122 = 0, $123 = 0, $124 = 0, $125 = 0, $126 = 0, $127 = 0, $128 = 0, $129 = 0, $13 = 0, $130 = 0, $131 = 0, $132 = 0, $133 = 0, $134 = 0, $135 = 0, $136 = 0, $137 = 0, $138 = 0, $139 = 0;
 var $14 = 0, $140 = 0, $141 = 0, $142 = 0, $143 = 0, $144 = 0, $145 = 0, $146 = 0, $147 = 0, $148 = 0, $149 = 0, $15 = 0, $150 = 0, $151 = 0, $152 = 0, $153 = 0, $154 = 0, $155 = 0, $156 = 0, $157 = 0;
 var $158 = 0, $159 = 0, $16 = 0, $160 = 0, $161 = 0, $162 = 0, $163 = 0, $164 = 0, $165 = 0, $166 = 0, $167 = 0, $168 = 0, $169 = 0, $17 = 0, $170 = 0, $171 = 0, $172 = 0, $173 = 0, $174 = 0, $175 = 0;
 var $176 = 0, $177 = 0, $178 = 0, $179 = 0, $18 = 0, $180 = 0, $181 = 0, $182 = 0, $183 = 0, $184 = 0, $185 = 0, $186 = 0, $187 = 0, $188 = 0, $189 = 0, $19 = 0, $190 = 0, $191 = 0, $192 = 0, $193 = 0;
 var $194 = 0, $195 = 0, $196 = 0, $197 = 0, $198 = 0, $199 = 0, $2 = 0, $20 = 0, $200 = 0, $201 = 0, $202 = 0, $203 = 0, $204 = 0, $205 = 0, $206 = 0, $207 = 0, $208 = 0, $21 = 0, $22 = 0, $23 = 0;
 var $24 = 0, $25 = 0, $26 = 0, $27 = 0, $28 = 0, $29 = 0, $3 = 0, $30 = 0, $31 = 0, $32 = 0, $33 = 0, $34 = 0, $35 = 0, $36 = 0, $37 = 0, $38 = 0, $39 = 0, $4 = 0, $40 = 0, $41 = 0;
 var $42 = 0, $43 = 0, $44 = 0, $45 = 0, $46 = 0, $47 = 0, $48 = 0, $49 = 0, $5 = 0, $50 = 0, $51 = 0, $52 = 0, $53 = 0, $54 = 0, $55 = 0, $56 = 0, $57 = 0, $58 = 0, $59 = 0, $6 = 0;
 var $60 = 0, $61 = 0, $62 = 0, $63 = 0, $64 = 0, $65 = 0, $66 = 0, $67 = 0, $68 = 0, $69 = 0, $7 = 0, $70 = 0, $71 = 0, $72 = 0, $73 = 0, $74 = 0, $75 = 0, $76 = 0, $77 = 0, $78 = 0;
 var $79 = 0, $8 = 0, $80 = 0, $81 = 0, $82 = 0, $83 = 0, $84 = 0, $85 = 0, $86 = 0, $87 = 0, $88 = 0, $89 = 0, $9 = 0, $90 = 0, $91 = 0, $92 = 0, $93 = 0, $94 = 0, $95 = 0, $96 = 0;
 var $97 = 0, $98 = 0, $99 = 0, $F$0$i$i = 0, $F104$0 = 0, $F197$0$i = 0, $F224$0$i$i = 0, $F290$0$i = 0, $I252$0$i$i = 0, $I316$0$i = 0, $I57$0$i$i = 0, $K105$0$i$i = 0, $K305$0$i$i = 0, $K373$0$i = 0, $R$1$i = 0, $R$1$i$168 = 0, $R$1$i$168$lcssa = 0, $R$1$i$i = 0, $R$1$i$i$lcssa = 0, $R$1$i$lcssa = 0;
 var $R$3$i = 0, $R$3$i$171 = 0, $R$3$i$i = 0, $RP$1$i = 0, $RP$1$i$167 = 0, $RP$1$i$167$lcssa = 0, $RP$1$i$i = 0, $RP$1$i$i$lcssa = 0, $RP$1$i$lcssa = 0, $T$0$i = 0, $T$0$i$58$i = 0, $T$0$i$58$i$lcssa = 0, $T$0$i$58$i$lcssa283 = 0, $T$0$i$i = 0, $T$0$i$i$lcssa = 0, $T$0$i$i$lcssa284 = 0, $T$0$i$lcssa = 0, $T$0$i$lcssa293 = 0, $add$i = 0, $add$i$146 = 0;
 var $add$i$180 = 0, $add$i$i = 0, $add$ptr = 0, $add$ptr$i = 0, $add$ptr$i$1$i$i = 0, $add$ptr$i$11$i = 0, $add$ptr$i$161 = 0, $add$ptr$i$193 = 0, $add$ptr$i$21$i = 0, $add$ptr$i$32$i = 0, $add$ptr$i$i = 0, $add$ptr$i$i$i = 0, $add$ptr$i$i$i$lcssa = 0, $add$ptr14$i$i = 0, $add$ptr15$i$i = 0, $add$ptr16$i$i = 0, $add$ptr166 = 0, $add$ptr169 = 0, $add$ptr17$i$i = 0, $add$ptr178 = 0;
 var $add$ptr181$i = 0, $add$ptr182 = 0, $add$ptr189$i = 0, $add$ptr190$i = 0, $add$ptr193 = 0, $add$ptr199 = 0, $add$ptr2$i$i = 0, $add$ptr205$i$i = 0, $add$ptr212$i$i = 0, $add$ptr225$i = 0, $add$ptr227$i = 0, $add$ptr24$i$i = 0, $add$ptr262$i = 0, $add$ptr269$i = 0, $add$ptr273$i = 0, $add$ptr282$i = 0, $add$ptr3$i$i = 0, $add$ptr30$i$i = 0, $add$ptr369$i$i = 0, $add$ptr4$i$26$i = 0;
 var $add$ptr4$i$37$i = 0, $add$ptr4$i$i = 0, $add$ptr4$i$i$i = 0, $add$ptr441$i = 0, $add$ptr5$i$i = 0, $add$ptr6$i$30$i = 0, $add$ptr6$i$i = 0, $add$ptr6$i$i$i = 0, $add$ptr7$i$i = 0, $add$ptr8$i122$i = 0, $add$ptr95 = 0, $add$ptr98 = 0, $add10$i = 0, $add101$i = 0, $add110$i = 0, $add13$i = 0, $add14$i = 0, $add140$i = 0, $add144 = 0, $add150$i = 0;
 var $add17$i = 0, $add17$i$183 = 0, $add177$i = 0, $add18$i = 0, $add19$i = 0, $add2 = 0, $add20$i = 0, $add206$i$i = 0, $add212$i = 0, $add215$i = 0, $add22$i = 0, $add246$i = 0, $add26$i$i = 0, $add268$i = 0, $add269$i$i = 0, $add274$i$i = 0, $add278$i$i = 0, $add280$i$i = 0, $add283$i$i = 0, $add337$i = 0;
 var $add342$i = 0, $add346$i = 0, $add348$i = 0, $add351$i = 0, $add46$i = 0, $add50 = 0, $add51$i = 0, $add54 = 0, $add54$i = 0, $add58 = 0, $add62 = 0, $add64 = 0, $add74$i$i = 0, $add77$i = 0, $add78$i = 0, $add79$i$i = 0, $add8 = 0, $add82$i = 0, $add83$i$i = 0, $add85$i$i = 0;
 var $add86$i = 0, $add88$i$i = 0, $add9$i = 0, $add90$i = 0, $add92$i = 0, $and = 0, $and$i = 0, $and$i$12$i = 0, $and$i$14$i = 0, $and$i$143 = 0, $and$i$22$i = 0, $and$i$33$i = 0, $and$i$i = 0, $and$i$i$i = 0, $and100$i = 0, $and103$i = 0, $and104$i = 0, $and106 = 0, $and11$i = 0, $and119$i$i = 0;
 var $and12$i = 0, $and13$i = 0, $and13$i$i = 0, $and133$i$i = 0, $and14 = 0, $and145 = 0, $and17$i = 0, $and194$i = 0, $and194$i$204 = 0, $and199$i = 0, $and209$i$i = 0, $and21$i = 0, $and21$i$149 = 0, $and227$i$i = 0, $and236$i = 0, $and264$i$i = 0, $and268$i$i = 0, $and273$i$i = 0, $and282$i$i = 0, $and29$i = 0;
 var $and292$i = 0, $and295$i$i = 0, $and3$i = 0, $and3$i$24$i = 0, $and3$i$35$i = 0, $and3$i$i = 0, $and3$i$i$i = 0, $and30$i = 0, $and318$i$i = 0, $and32$i = 0, $and32$i$i = 0, $and33$i$i = 0, $and331$i = 0, $and336$i = 0, $and341$i = 0, $and350$i = 0, $and363$i = 0, $and37$i$i = 0, $and387$i = 0, $and4 = 0;
 var $and40$i$i = 0, $and41 = 0, $and42$i = 0, $and43 = 0, $and46 = 0, $and49 = 0, $and49$i = 0, $and49$i$i = 0, $and53 = 0, $and57 = 0, $and6$i = 0, $and6$i$38$i = 0, $and6$i$i = 0, $and61 = 0, $and64$i = 0, $and68$i = 0, $and69$i$i = 0, $and7 = 0, $and7$i$i = 0, $and73$i = 0;
 var $and73$i$i = 0, $and74 = 0, $and77$i = 0, $and78$i$i = 0, $and8$i = 0, $and80$i = 0, $and81$i = 0, $and85$i = 0, $and87$i$i = 0, $and89$i = 0, $and9$i = 0, $and96$i$i = 0, $arrayidx = 0, $arrayidx$i = 0, $arrayidx$i$150 = 0, $arrayidx$i$20$i = 0, $arrayidx$i$48$i = 0, $arrayidx$i$i = 0, $arrayidx103 = 0, $arrayidx103$i$i = 0;
 var $arrayidx106$i = 0, $arrayidx107$i$i = 0, $arrayidx113$i = 0, $arrayidx113$i$159 = 0, $arrayidx121$i = 0, $arrayidx123$i$i = 0, $arrayidx126$i$i = 0, $arrayidx126$i$i$lcssa = 0, $arrayidx137$i = 0, $arrayidx143$i$i = 0, $arrayidx148$i = 0, $arrayidx151$i = 0, $arrayidx151$i$i = 0, $arrayidx154$i = 0, $arrayidx155$i = 0, $arrayidx161$i = 0, $arrayidx165$i = 0, $arrayidx165$i$169 = 0, $arrayidx178$i$i = 0, $arrayidx184$i = 0;
 var $arrayidx184$i$i = 0, $arrayidx195$i$i = 0, $arrayidx196$i = 0, $arrayidx204$i = 0, $arrayidx212$i = 0, $arrayidx223$i$i = 0, $arrayidx228$i = 0, $arrayidx23$i = 0, $arrayidx239$i = 0, $arrayidx245$i = 0, $arrayidx256$i = 0, $arrayidx27$i = 0, $arrayidx287$i$i = 0, $arrayidx289$i = 0, $arrayidx290$i$i = 0, $arrayidx325$i$i = 0, $arrayidx325$i$i$lcssa = 0, $arrayidx355$i = 0, $arrayidx358$i = 0, $arrayidx394$i = 0;
 var $arrayidx394$i$lcssa = 0, $arrayidx40$i = 0, $arrayidx44$i = 0, $arrayidx61$i = 0, $arrayidx65$i = 0, $arrayidx66 = 0, $arrayidx71$i = 0, $arrayidx75$i = 0, $arrayidx91$i$i = 0, $arrayidx92$i$i = 0, $arrayidx94$i = 0, $arrayidx94$i$156 = 0, $arrayidx96$i$i = 0, $base$i$i$lcssa = 0, $base226$i$lcssa = 0, $bk = 0, $bk$i = 0, $bk$i$163 = 0, $bk$i$46$i = 0, $bk$i$i = 0;
 var $bk102$i$i = 0, $bk122 = 0, $bk124 = 0, $bk136$i = 0, $bk139$i$i = 0, $bk158$i$i = 0, $bk161$i$i = 0, $bk218$i = 0, $bk220$i = 0, $bk246$i$i = 0, $bk248$i$i = 0, $bk302$i$i = 0, $bk311$i = 0, $bk313$i = 0, $bk338$i$i = 0, $bk357$i$i = 0, $bk360$i$i = 0, $bk370$i = 0, $bk407$i = 0, $bk429$i = 0;
 var $bk43$i$i = 0, $bk432$i = 0, $bk47$i = 0, $bk55$i$i = 0, $bk67$i$i = 0, $bk74$i$i = 0, $bk78 = 0, $bk82$i$i = 0, $br$2$ph$i = 0, $call$i$i = 0, $call107$i = 0, $call131$i = 0, $call132$i = 0, $call275$i = 0, $call37$i = 0, $call6$i$i = 0, $call68$i = 0, $call83$i = 0, $child$i$i = 0, $child166$i$i = 0;
 var $child289$i$i = 0, $child357$i = 0, $cmp = 0, $cmp$i = 0, $cmp$i$13$i = 0, $cmp$i$140 = 0, $cmp$i$15$i = 0, $cmp$i$179 = 0, $cmp$i$2$i$i = 0, $cmp$i$23$i = 0, $cmp$i$34$i = 0, $cmp$i$9$i = 0, $cmp$i$i$i = 0, $cmp1 = 0, $cmp1$i = 0, $cmp1$i$i = 0, $cmp10 = 0, $cmp100$i$i = 0, $cmp102$i = 0, $cmp104$i$i = 0;
 var $cmp105$i = 0, $cmp106$i$i = 0, $cmp107$i = 0, $cmp107$i$157 = 0, $cmp108$i = 0, $cmp108$i$i = 0, $cmp112$i$i = 0, $cmp113 = 0, $cmp114$i = 0, $cmp116$i = 0, $cmp118$i = 0, $cmp119$i = 0, $cmp12$i = 0, $cmp120$i$53$i = 0, $cmp120$i$i = 0, $cmp121$i = 0, $cmp123$i = 0, $cmp124$i$i = 0, $cmp126$i = 0, $cmp127$i = 0;
 var $cmp128 = 0, $cmp128$i = 0, $cmp128$i$i = 0, $cmp130$i = 0, $cmp133$i = 0, $cmp133$i$196 = 0, $cmp133$i$i = 0, $cmp135$i = 0, $cmp137$i = 0, $cmp137$i$197 = 0, $cmp137$i$i = 0, $cmp138$i = 0, $cmp139 = 0, $cmp140$i = 0, $cmp141$not$i = 0, $cmp142$i = 0, $cmp144$i$i = 0, $cmp146 = 0, $cmp15 = 0, $cmp15$i = 0;
 var $cmp151$i = 0, $cmp152$i = 0, $cmp153$i$i = 0, $cmp155$i = 0, $cmp156 = 0, $cmp156$i = 0, $cmp156$i$i = 0, $cmp157$i = 0, $cmp159$i = 0, $cmp159$i$199 = 0, $cmp16 = 0, $cmp160$i$i = 0, $cmp162 = 0, $cmp162$i = 0, $cmp162$i$200 = 0, $cmp166$i = 0, $cmp168$i$i = 0, $cmp171$i = 0, $cmp172$i$i = 0, $cmp174$i = 0;
 var $cmp180$i = 0, $cmp185$i = 0, $cmp185$i$i = 0, $cmp186 = 0, $cmp186$i = 0, $cmp189$i$i = 0, $cmp19$i = 0, $cmp190$i = 0, $cmp191$i = 0, $cmp198$i = 0, $cmp2$i$i = 0, $cmp2$i$i$i = 0, $cmp20$i$i = 0, $cmp203$i = 0, $cmp205$i = 0, $cmp208$i = 0, $cmp209$i = 0, $cmp21$i = 0, $cmp215$i$i = 0, $cmp217$i = 0;
 var $cmp218$i = 0, $cmp221$i = 0, $cmp224$i = 0, $cmp228$i = 0, $cmp229$i = 0, $cmp233$i = 0, $cmp236$i$i = 0, $cmp24$i = 0, $cmp24$i$i = 0, $cmp246$i = 0, $cmp250$i = 0, $cmp254$i$i = 0, $cmp257$i = 0, $cmp258$i$i = 0, $cmp26$i = 0, $cmp265$i = 0, $cmp27$i$i = 0, $cmp28$i = 0, $cmp28$i$i = 0, $cmp284$i = 0;
 var $cmp29 = 0, $cmp3$i$i = 0, $cmp301$i = 0, $cmp306$i$i = 0, $cmp31 = 0, $cmp319$i = 0, $cmp319$i$i = 0, $cmp32$i = 0, $cmp32$i$185 = 0, $cmp323$i = 0, $cmp327$i$i = 0, $cmp33$i = 0, $cmp332$i$i = 0, $cmp34$i = 0, $cmp34$i$i = 0, $cmp35$i = 0, $cmp350$i$i = 0, $cmp36$i = 0, $cmp36$i$i = 0, $cmp374$i = 0;
 var $cmp38$i = 0, $cmp38$i$i = 0, $cmp388$i = 0, $cmp396$i = 0, $cmp40$i = 0, $cmp401$i = 0, $cmp41$i$i = 0, $cmp42$i$i = 0, $cmp422$i = 0, $cmp43$i = 0, $cmp44$i$i = 0, $cmp45$i = 0, $cmp45$i$155 = 0, $cmp46$i = 0, $cmp46$i$49$i = 0, $cmp46$i$i = 0, $cmp48$i = 0, $cmp49$i = 0, $cmp5 = 0, $cmp51$i = 0;
 var $cmp54$i$i = 0, $cmp55$i = 0, $cmp55$i$187 = 0, $cmp57$i = 0, $cmp57$i$188 = 0, $cmp57$i$i = 0, $cmp59$i$i = 0, $cmp60$i = 0, $cmp60$i$i = 0, $cmp62$i = 0, $cmp63$i = 0, $cmp63$i$i = 0, $cmp65$i = 0, $cmp66$i = 0, $cmp66$i$190 = 0, $cmp69$i = 0, $cmp7$i$i = 0, $cmp70 = 0, $cmp72$i = 0, $cmp75$i$i = 0;
 var $cmp76 = 0, $cmp76$i = 0, $cmp79 = 0, $cmp81$i = 0, $cmp81$i$191 = 0, $cmp81$i$i = 0, $cmp83$i$i = 0, $cmp85$i = 0, $cmp86$i$i = 0, $cmp89$i = 0, $cmp9$i$i = 0, $cmp90$i = 0, $cmp91$i = 0, $cmp93$i = 0, $cmp95$i = 0, $cmp96$i = 0, $cmp97$7$i = 0, $cmp97$i = 0, $cmp97$i$i = 0, $cmp99 = 0;
 var $cond = 0, $cond$i = 0, $cond$i$16$i = 0, $cond$i$25$i = 0, $cond$i$36$i = 0, $cond$i$i = 0, $cond$i$i$i = 0, $cond$v$0$i = 0, $cond115$i$i = 0, $cond13$i$i = 0, $cond15$i$i = 0, $cond2$i = 0, $cond2$i$i = 0, $cond3$i = 0, $cond315$i$i = 0, $cond383$i = 0, $cond4$i = 0, $exitcond$i$i = 0, $fd$i = 0, $fd$i$164 = 0;
 var $fd$i$i = 0, $fd103$i$i = 0, $fd123 = 0, $fd139$i = 0, $fd140$i$i = 0, $fd148$i$i = 0, $fd160$i$i = 0, $fd219$i = 0, $fd247$i$i = 0, $fd303$i$i = 0, $fd312$i = 0, $fd339$i$i = 0, $fd344$i$i = 0, $fd359$i$i = 0, $fd371$i = 0, $fd408$i = 0, $fd416$i = 0, $fd431$i = 0, $fd50$i = 0, $fd54$i$i = 0;
 var $fd59$i$i = 0, $fd68$pre$phi$i$iZ2D = 0, $fd69 = 0, $fd78$i$i = 0, $fd85$i$i = 0, $fd9 = 0, $head = 0, $head$i = 0, $head$i$154 = 0, $head$i$17$i = 0, $head$i$29$i = 0, $head$i$42$i = 0, $head$i$i = 0, $head$i$i$i = 0, $head118$i$i = 0, $head168 = 0, $head173 = 0, $head177 = 0, $head179 = 0, $head179$i = 0;
 var $head182$i = 0, $head187$i = 0, $head189$i = 0, $head195 = 0, $head198 = 0, $head208$i$i = 0, $head211$i$i = 0, $head23$i$i = 0, $head25 = 0, $head265$i = 0, $head268$i = 0, $head271$i = 0, $head274$i = 0, $head279$i = 0, $head281$i = 0, $head29$i = 0, $head29$i$i = 0, $head317$i$i = 0, $head32$i$i = 0, $head34$i$i = 0;
 var $head386$i = 0, $head7$i$31$i = 0, $head7$i$i = 0, $head7$i$i$i = 0, $head94 = 0, $head97 = 0, $head99$i = 0, $i$01$i$i = 0, $idx$0$i = 0, $inc$i$i = 0, $index$i = 0, $index$i$172 = 0, $index$i$54$i = 0, $index$i$i = 0, $index288$i$i = 0, $index356$i = 0, $nb$0 = 0, $neg = 0, $neg$i = 0, $neg$i$173 = 0;
 var $neg$i$182 = 0, $neg$i$i = 0, $neg103$i = 0, $neg13 = 0, $neg132$i$i = 0, $neg48$i = 0, $neg73 = 0, $next$i = 0, $next$i$i = 0, $next$i$i$i = 0, $next231$i = 0, $not$cmp150$i$i = 0, $not$cmp346$i$i = 0, $not$cmp418$i = 0, $oldfirst$0$i$i = 0, $or$cond$i = 0, $or$cond$i$189 = 0, $or$cond1$i = 0, $or$cond1$i$184 = 0, $or$cond2$i = 0;
 var $or$cond3$i = 0, $or$cond4$i = 0, $or$cond5$i = 0, $or$cond7$i = 0, $or$cond8$i = 0, $or$cond98$i = 0, $or$i = 0, $or$i$195 = 0, $or$i$28$i = 0, $or$i$i = 0, $or$i$i$i = 0, $or101$i$i = 0, $or110 = 0, $or167 = 0, $or172 = 0, $or176 = 0, $or178$i = 0, $or180 = 0, $or183$i = 0, $or186$i = 0;
 var $or188$i = 0, $or19$i$i = 0, $or194 = 0, $or197 = 0, $or204$i = 0, $or210$i$i = 0, $or22$i$i = 0, $or23 = 0, $or232$i$i = 0, $or26 = 0, $or264$i = 0, $or267$i = 0, $or270$i = 0, $or275$i = 0, $or278$i = 0, $or28$i$i = 0, $or280$i = 0, $or297$i = 0, $or300$i$i = 0, $or33$i$i = 0;
 var $or368$i = 0, $or40 = 0, $or44$i$i = 0, $or93 = 0, $or96 = 0, $p$0$i$i = 0, $parent$i = 0, $parent$i$162 = 0, $parent$i$51$i = 0, $parent$i$i = 0, $parent135$i = 0, $parent138$i$i = 0, $parent149$i = 0, $parent162$i$i = 0, $parent165$i$i = 0, $parent166$i = 0, $parent179$i$i = 0, $parent196$i$i = 0, $parent226$i = 0, $parent240$i = 0;
 var $parent257$i = 0, $parent301$i$i = 0, $parent337$i$i = 0, $parent361$i$i = 0, $parent369$i = 0, $parent406$i = 0, $parent433$i = 0, $qsize$0$i$i = 0, $retval$0 = 0, $rsize$0$i = 0, $rsize$0$i$152 = 0, $rsize$0$i$lcssa = 0, $rsize$1$i = 0, $rsize$3$i = 0, $rsize$4$lcssa$i = 0, $rsize$49$i = 0, $rst$0$i = 0, $rst$1$i = 0, $sflags193$i = 0, $sflags235$i = 0;
 var $shl = 0, $shl$i = 0, $shl$i$144 = 0, $shl$i$19$i = 0, $shl$i$47$i = 0, $shl$i$i = 0, $shl102 = 0, $shl105 = 0, $shl116$i$i = 0, $shl12 = 0, $shl127$i$i = 0, $shl131$i$i = 0, $shl15$i = 0, $shl18$i = 0, $shl192$i = 0, $shl195$i = 0, $shl198$i = 0, $shl22 = 0, $shl221$i$i = 0, $shl226$i$i = 0;
 var $shl265$i$i = 0, $shl270$i$i = 0, $shl276$i$i = 0, $shl279$i$i = 0, $shl288$i = 0, $shl291$i = 0, $shl294$i$i = 0, $shl31$i = 0, $shl316$i$i = 0, $shl326$i$i = 0, $shl333$i = 0, $shl338$i = 0, $shl344$i = 0, $shl347$i = 0, $shl35 = 0, $shl362$i = 0, $shl37 = 0, $shl384$i = 0, $shl39$i$i = 0, $shl395$i = 0;
 var $shl48$i$i = 0, $shl52$i = 0, $shl60$i = 0, $shl65 = 0, $shl70$i$i = 0, $shl72 = 0, $shl75$i$i = 0, $shl81$i$i = 0, $shl84$i$i = 0, $shl9$i = 0, $shl90 = 0, $shl95$i$i = 0, $shr = 0, $shr$i = 0, $shr$i$139 = 0, $shr$i$45$i = 0, $shr$i$i = 0, $shr101 = 0, $shr11$i = 0, $shr11$i$147 = 0;
 var $shr110$i$i = 0, $shr12$i = 0, $shr123$i$i = 0, $shr15$i = 0, $shr16$i = 0, $shr16$i$148 = 0, $shr19$i = 0, $shr194$i = 0, $shr20$i = 0, $shr214$i$i = 0, $shr253$i$i = 0, $shr263$i$i = 0, $shr267$i$i = 0, $shr27$i = 0, $shr272$i$i = 0, $shr277$i$i = 0, $shr281$i$i = 0, $shr283$i = 0, $shr3 = 0, $shr310$i$i = 0;
 var $shr318$i = 0, $shr322$i$i = 0, $shr330$i = 0, $shr335$i = 0, $shr340$i = 0, $shr345$i = 0, $shr349$i = 0, $shr378$i = 0, $shr391$i = 0, $shr4$i = 0, $shr41$i = 0, $shr45 = 0, $shr47 = 0, $shr48 = 0, $shr5$i = 0, $shr5$i$142 = 0, $shr51 = 0, $shr52 = 0, $shr55 = 0, $shr56 = 0;
 var $shr58$i$i = 0, $shr59 = 0, $shr60 = 0, $shr63 = 0, $shr68$i$i = 0, $shr7$i = 0, $shr7$i$145 = 0, $shr72$i = 0, $shr72$i$i = 0, $shr75$i = 0, $shr76$i = 0, $shr77$i$i = 0, $shr79$i = 0, $shr8$i = 0, $shr80$i = 0, $shr82$i$i = 0, $shr83$i = 0, $shr84$i = 0, $shr86$i$i = 0, $shr87$i = 0;
 var $shr88$i = 0, $shr91$i = 0, $size$i$i = 0, $size$i$i$i = 0, $size$i$i$lcssa = 0, $size188$i = 0, $size188$i$lcssa = 0, $size245$i = 0, $sizebits$0$i = 0, $sizebits$0$shl52$i = 0, $sp$0$i$i = 0, $sp$0$i$i$i = 0, $sp$0108$i = 0, $sp$0108$i$lcssa = 0, $sp$1107$i = 0, $sp$1107$i$lcssa = 0, $ssize$0$i = 0, $ssize$2$ph$i = 0, $ssize$5$i = 0, $sub = 0;
 var $sub$i = 0, $sub$i$138 = 0, $sub$i$181 = 0, $sub$i$i = 0, $sub$ptr$lhs$cast$i = 0, $sub$ptr$lhs$cast$i$39$i = 0, $sub$ptr$lhs$cast$i$i = 0, $sub$ptr$rhs$cast$i = 0, $sub$ptr$rhs$cast$i$40$i = 0, $sub$ptr$rhs$cast$i$i = 0, $sub$ptr$sub$i = 0, $sub$ptr$sub$i$41$i = 0, $sub$ptr$sub$i$i = 0, $sub10$i = 0, $sub101$i = 0, $sub101$rsize$4$i = 0, $sub112$i = 0, $sub113$i$i = 0, $sub118$i = 0, $sub14$i = 0;
 var $sub16$i$i = 0, $sub160 = 0, $sub172$i = 0, $sub18$i$i = 0, $sub190 = 0, $sub2$i = 0, $sub22$i = 0, $sub260$i = 0, $sub262$i$i = 0, $sub266$i$i = 0, $sub271$i$i = 0, $sub275$i$i = 0, $sub30$i = 0, $sub31$i = 0, $sub31$rsize$0$i = 0, $sub313$i$i = 0, $sub329$i = 0, $sub33$i = 0, $sub334$i = 0, $sub339$i = 0;
 var $sub343$i = 0, $sub381$i = 0, $sub4$i = 0, $sub41$i = 0, $sub42 = 0, $sub44 = 0, $sub5$i$27$i = 0, $sub5$i$i = 0, $sub5$i$i$i = 0, $sub50$i = 0, $sub6$i = 0, $sub63$i = 0, $sub67$i = 0, $sub67$i$i = 0, $sub70$i = 0, $sub71$i$i = 0, $sub76$i$i = 0, $sub80$i$i = 0, $sub91 = 0, $sub99$i = 0;
 var $t$0$i = 0, $t$0$i$151 = 0, $t$2$i = 0, $t$4$ph$i = 0, $t$4$v$4$i = 0, $t$48$i = 0, $tbase$796$i = 0, $tobool$i$i = 0, $tobool107 = 0, $tobool195$i = 0, $tobool200$i = 0, $tobool228$i$i = 0, $tobool237$i = 0, $tobool293$i = 0, $tobool296$i$i = 0, $tobool30$i = 0, $tobool364$i = 0, $tobool97$i$i = 0, $tsize$795$i = 0, $v$0$i = 0;
 var $v$0$i$153 = 0, $v$0$i$lcssa = 0, $v$1$i = 0, $v$3$i = 0, $v$4$lcssa$i = 0, $v$410$i = 0, $xor$i$i = 0, label = 0, sp = 0;
 sp = STACKTOP;
 $cmp = ($bytes>>>0)<(245);
 do {
  if ($cmp) {
   $cmp1 = ($bytes>>>0)<(11);
   $add2 = (($bytes) + 11)|0;
   $and = $add2 & -8;
   $cond = $cmp1 ? 16 : $and;
   $shr = $cond >>> 3;
   $0 = HEAP32[44]|0;
   $shr3 = $0 >>> $shr;
   $and4 = $shr3 & 3;
   $cmp5 = ($and4|0)==(0);
   if (!($cmp5)) {
    $neg = $shr3 & 1;
    $and7 = $neg ^ 1;
    $add8 = (($and7) + ($shr))|0;
    $shl = $add8 << 1;
    $arrayidx = (216 + ($shl<<2)|0);
    $1 = ((($arrayidx)) + 8|0);
    $2 = HEAP32[$1>>2]|0;
    $fd9 = ((($2)) + 8|0);
    $3 = HEAP32[$fd9>>2]|0;
    $cmp10 = ($arrayidx|0)==($3|0);
    do {
     if ($cmp10) {
      $shl12 = 1 << $add8;
      $neg13 = $shl12 ^ -1;
      $and14 = $0 & $neg13;
      HEAP32[44] = $and14;
     } else {
      $4 = HEAP32[(192)>>2]|0;
      $cmp15 = ($3>>>0)<($4>>>0);
      if ($cmp15) {
       _abort();
       // unreachable;
      }
      $bk = ((($3)) + 12|0);
      $5 = HEAP32[$bk>>2]|0;
      $cmp16 = ($5|0)==($2|0);
      if ($cmp16) {
       HEAP32[$bk>>2] = $arrayidx;
       HEAP32[$1>>2] = $3;
       break;
      } else {
       _abort();
       // unreachable;
      }
     }
    } while(0);
    $shl22 = $add8 << 3;
    $or23 = $shl22 | 3;
    $head = ((($2)) + 4|0);
    HEAP32[$head>>2] = $or23;
    $add$ptr = (($2) + ($shl22)|0);
    $head25 = ((($add$ptr)) + 4|0);
    $6 = HEAP32[$head25>>2]|0;
    $or26 = $6 | 1;
    HEAP32[$head25>>2] = $or26;
    $retval$0 = $fd9;
    return ($retval$0|0);
   }
   $7 = HEAP32[(184)>>2]|0;
   $cmp29 = ($cond>>>0)>($7>>>0);
   if ($cmp29) {
    $cmp31 = ($shr3|0)==(0);
    if (!($cmp31)) {
     $shl35 = $shr3 << $shr;
     $shl37 = 2 << $shr;
     $sub = (0 - ($shl37))|0;
     $or40 = $shl37 | $sub;
     $and41 = $shl35 & $or40;
     $sub42 = (0 - ($and41))|0;
     $and43 = $and41 & $sub42;
     $sub44 = (($and43) + -1)|0;
     $shr45 = $sub44 >>> 12;
     $and46 = $shr45 & 16;
     $shr47 = $sub44 >>> $and46;
     $shr48 = $shr47 >>> 5;
     $and49 = $shr48 & 8;
     $add50 = $and49 | $and46;
     $shr51 = $shr47 >>> $and49;
     $shr52 = $shr51 >>> 2;
     $and53 = $shr52 & 4;
     $add54 = $add50 | $and53;
     $shr55 = $shr51 >>> $and53;
     $shr56 = $shr55 >>> 1;
     $and57 = $shr56 & 2;
     $add58 = $add54 | $and57;
     $shr59 = $shr55 >>> $and57;
     $shr60 = $shr59 >>> 1;
     $and61 = $shr60 & 1;
     $add62 = $add58 | $and61;
     $shr63 = $shr59 >>> $and61;
     $add64 = (($add62) + ($shr63))|0;
     $shl65 = $add64 << 1;
     $arrayidx66 = (216 + ($shl65<<2)|0);
     $8 = ((($arrayidx66)) + 8|0);
     $9 = HEAP32[$8>>2]|0;
     $fd69 = ((($9)) + 8|0);
     $10 = HEAP32[$fd69>>2]|0;
     $cmp70 = ($arrayidx66|0)==($10|0);
     do {
      if ($cmp70) {
       $shl72 = 1 << $add64;
       $neg73 = $shl72 ^ -1;
       $and74 = $0 & $neg73;
       HEAP32[44] = $and74;
       $13 = $7;
      } else {
       $11 = HEAP32[(192)>>2]|0;
       $cmp76 = ($10>>>0)<($11>>>0);
       if ($cmp76) {
        _abort();
        // unreachable;
       }
       $bk78 = ((($10)) + 12|0);
       $12 = HEAP32[$bk78>>2]|0;
       $cmp79 = ($12|0)==($9|0);
       if ($cmp79) {
        HEAP32[$bk78>>2] = $arrayidx66;
        HEAP32[$8>>2] = $10;
        $$pre = HEAP32[(184)>>2]|0;
        $13 = $$pre;
        break;
       } else {
        _abort();
        // unreachable;
       }
      }
     } while(0);
     $shl90 = $add64 << 3;
     $sub91 = (($shl90) - ($cond))|0;
     $or93 = $cond | 3;
     $head94 = ((($9)) + 4|0);
     HEAP32[$head94>>2] = $or93;
     $add$ptr95 = (($9) + ($cond)|0);
     $or96 = $sub91 | 1;
     $head97 = ((($add$ptr95)) + 4|0);
     HEAP32[$head97>>2] = $or96;
     $add$ptr98 = (($add$ptr95) + ($sub91)|0);
     HEAP32[$add$ptr98>>2] = $sub91;
     $cmp99 = ($13|0)==(0);
     if (!($cmp99)) {
      $14 = HEAP32[(196)>>2]|0;
      $shr101 = $13 >>> 3;
      $shl102 = $shr101 << 1;
      $arrayidx103 = (216 + ($shl102<<2)|0);
      $15 = HEAP32[44]|0;
      $shl105 = 1 << $shr101;
      $and106 = $15 & $shl105;
      $tobool107 = ($and106|0)==(0);
      if ($tobool107) {
       $or110 = $15 | $shl105;
       HEAP32[44] = $or110;
       $$pre241 = ((($arrayidx103)) + 8|0);
       $$pre$phiZ2D = $$pre241;$F104$0 = $arrayidx103;
      } else {
       $16 = ((($arrayidx103)) + 8|0);
       $17 = HEAP32[$16>>2]|0;
       $18 = HEAP32[(192)>>2]|0;
       $cmp113 = ($17>>>0)<($18>>>0);
       if ($cmp113) {
        _abort();
        // unreachable;
       } else {
        $$pre$phiZ2D = $16;$F104$0 = $17;
       }
      }
      HEAP32[$$pre$phiZ2D>>2] = $14;
      $bk122 = ((($F104$0)) + 12|0);
      HEAP32[$bk122>>2] = $14;
      $fd123 = ((($14)) + 8|0);
      HEAP32[$fd123>>2] = $F104$0;
      $bk124 = ((($14)) + 12|0);
      HEAP32[$bk124>>2] = $arrayidx103;
     }
     HEAP32[(184)>>2] = $sub91;
     HEAP32[(196)>>2] = $add$ptr95;
     $retval$0 = $fd69;
     return ($retval$0|0);
    }
    $19 = HEAP32[(180)>>2]|0;
    $cmp128 = ($19|0)==(0);
    if ($cmp128) {
     $nb$0 = $cond;
    } else {
     $sub$i = (0 - ($19))|0;
     $and$i = $19 & $sub$i;
     $sub2$i = (($and$i) + -1)|0;
     $shr$i = $sub2$i >>> 12;
     $and3$i = $shr$i & 16;
     $shr4$i = $sub2$i >>> $and3$i;
     $shr5$i = $shr4$i >>> 5;
     $and6$i = $shr5$i & 8;
     $add$i = $and6$i | $and3$i;
     $shr7$i = $shr4$i >>> $and6$i;
     $shr8$i = $shr7$i >>> 2;
     $and9$i = $shr8$i & 4;
     $add10$i = $add$i | $and9$i;
     $shr11$i = $shr7$i >>> $and9$i;
     $shr12$i = $shr11$i >>> 1;
     $and13$i = $shr12$i & 2;
     $add14$i = $add10$i | $and13$i;
     $shr15$i = $shr11$i >>> $and13$i;
     $shr16$i = $shr15$i >>> 1;
     $and17$i = $shr16$i & 1;
     $add18$i = $add14$i | $and17$i;
     $shr19$i = $shr15$i >>> $and17$i;
     $add20$i = (($add18$i) + ($shr19$i))|0;
     $arrayidx$i = (480 + ($add20$i<<2)|0);
     $20 = HEAP32[$arrayidx$i>>2]|0;
     $head$i = ((($20)) + 4|0);
     $21 = HEAP32[$head$i>>2]|0;
     $and21$i = $21 & -8;
     $sub22$i = (($and21$i) - ($cond))|0;
     $rsize$0$i = $sub22$i;$t$0$i = $20;$v$0$i = $20;
     while(1) {
      $arrayidx23$i = ((($t$0$i)) + 16|0);
      $22 = HEAP32[$arrayidx23$i>>2]|0;
      $cmp$i = ($22|0)==(0|0);
      if ($cmp$i) {
       $arrayidx27$i = ((($t$0$i)) + 20|0);
       $23 = HEAP32[$arrayidx27$i>>2]|0;
       $cmp28$i = ($23|0)==(0|0);
       if ($cmp28$i) {
        $rsize$0$i$lcssa = $rsize$0$i;$v$0$i$lcssa = $v$0$i;
        break;
       } else {
        $cond4$i = $23;
       }
      } else {
       $cond4$i = $22;
      }
      $head29$i = ((($cond4$i)) + 4|0);
      $24 = HEAP32[$head29$i>>2]|0;
      $and30$i = $24 & -8;
      $sub31$i = (($and30$i) - ($cond))|0;
      $cmp32$i = ($sub31$i>>>0)<($rsize$0$i>>>0);
      $sub31$rsize$0$i = $cmp32$i ? $sub31$i : $rsize$0$i;
      $cond$v$0$i = $cmp32$i ? $cond4$i : $v$0$i;
      $rsize$0$i = $sub31$rsize$0$i;$t$0$i = $cond4$i;$v$0$i = $cond$v$0$i;
     }
     $25 = HEAP32[(192)>>2]|0;
     $cmp33$i = ($v$0$i$lcssa>>>0)<($25>>>0);
     if ($cmp33$i) {
      _abort();
      // unreachable;
     }
     $add$ptr$i = (($v$0$i$lcssa) + ($cond)|0);
     $cmp35$i = ($v$0$i$lcssa>>>0)<($add$ptr$i>>>0);
     if (!($cmp35$i)) {
      _abort();
      // unreachable;
     }
     $parent$i = ((($v$0$i$lcssa)) + 24|0);
     $26 = HEAP32[$parent$i>>2]|0;
     $bk$i = ((($v$0$i$lcssa)) + 12|0);
     $27 = HEAP32[$bk$i>>2]|0;
     $cmp40$i = ($27|0)==($v$0$i$lcssa|0);
     do {
      if ($cmp40$i) {
       $arrayidx61$i = ((($v$0$i$lcssa)) + 20|0);
       $31 = HEAP32[$arrayidx61$i>>2]|0;
       $cmp62$i = ($31|0)==(0|0);
       if ($cmp62$i) {
        $arrayidx65$i = ((($v$0$i$lcssa)) + 16|0);
        $32 = HEAP32[$arrayidx65$i>>2]|0;
        $cmp66$i = ($32|0)==(0|0);
        if ($cmp66$i) {
         $R$3$i = 0;
         break;
        } else {
         $R$1$i = $32;$RP$1$i = $arrayidx65$i;
        }
       } else {
        $R$1$i = $31;$RP$1$i = $arrayidx61$i;
       }
       while(1) {
        $arrayidx71$i = ((($R$1$i)) + 20|0);
        $33 = HEAP32[$arrayidx71$i>>2]|0;
        $cmp72$i = ($33|0)==(0|0);
        if (!($cmp72$i)) {
         $R$1$i = $33;$RP$1$i = $arrayidx71$i;
         continue;
        }
        $arrayidx75$i = ((($R$1$i)) + 16|0);
        $34 = HEAP32[$arrayidx75$i>>2]|0;
        $cmp76$i = ($34|0)==(0|0);
        if ($cmp76$i) {
         $R$1$i$lcssa = $R$1$i;$RP$1$i$lcssa = $RP$1$i;
         break;
        } else {
         $R$1$i = $34;$RP$1$i = $arrayidx75$i;
        }
       }
       $cmp81$i = ($RP$1$i$lcssa>>>0)<($25>>>0);
       if ($cmp81$i) {
        _abort();
        // unreachable;
       } else {
        HEAP32[$RP$1$i$lcssa>>2] = 0;
        $R$3$i = $R$1$i$lcssa;
        break;
       }
      } else {
       $fd$i = ((($v$0$i$lcssa)) + 8|0);
       $28 = HEAP32[$fd$i>>2]|0;
       $cmp45$i = ($28>>>0)<($25>>>0);
       if ($cmp45$i) {
        _abort();
        // unreachable;
       }
       $bk47$i = ((($28)) + 12|0);
       $29 = HEAP32[$bk47$i>>2]|0;
       $cmp48$i = ($29|0)==($v$0$i$lcssa|0);
       if (!($cmp48$i)) {
        _abort();
        // unreachable;
       }
       $fd50$i = ((($27)) + 8|0);
       $30 = HEAP32[$fd50$i>>2]|0;
       $cmp51$i = ($30|0)==($v$0$i$lcssa|0);
       if ($cmp51$i) {
        HEAP32[$bk47$i>>2] = $27;
        HEAP32[$fd50$i>>2] = $28;
        $R$3$i = $27;
        break;
       } else {
        _abort();
        // unreachable;
       }
      }
     } while(0);
     $cmp90$i = ($26|0)==(0|0);
     do {
      if (!($cmp90$i)) {
       $index$i = ((($v$0$i$lcssa)) + 28|0);
       $35 = HEAP32[$index$i>>2]|0;
       $arrayidx94$i = (480 + ($35<<2)|0);
       $36 = HEAP32[$arrayidx94$i>>2]|0;
       $cmp95$i = ($v$0$i$lcssa|0)==($36|0);
       if ($cmp95$i) {
        HEAP32[$arrayidx94$i>>2] = $R$3$i;
        $cond2$i = ($R$3$i|0)==(0|0);
        if ($cond2$i) {
         $shl$i = 1 << $35;
         $neg$i = $shl$i ^ -1;
         $37 = HEAP32[(180)>>2]|0;
         $and103$i = $37 & $neg$i;
         HEAP32[(180)>>2] = $and103$i;
         break;
        }
       } else {
        $38 = HEAP32[(192)>>2]|0;
        $cmp107$i = ($26>>>0)<($38>>>0);
        if ($cmp107$i) {
         _abort();
         // unreachable;
        }
        $arrayidx113$i = ((($26)) + 16|0);
        $39 = HEAP32[$arrayidx113$i>>2]|0;
        $cmp114$i = ($39|0)==($v$0$i$lcssa|0);
        if ($cmp114$i) {
         HEAP32[$arrayidx113$i>>2] = $R$3$i;
        } else {
         $arrayidx121$i = ((($26)) + 20|0);
         HEAP32[$arrayidx121$i>>2] = $R$3$i;
        }
        $cmp126$i = ($R$3$i|0)==(0|0);
        if ($cmp126$i) {
         break;
        }
       }
       $40 = HEAP32[(192)>>2]|0;
       $cmp130$i = ($R$3$i>>>0)<($40>>>0);
       if ($cmp130$i) {
        _abort();
        // unreachable;
       }
       $parent135$i = ((($R$3$i)) + 24|0);
       HEAP32[$parent135$i>>2] = $26;
       $arrayidx137$i = ((($v$0$i$lcssa)) + 16|0);
       $41 = HEAP32[$arrayidx137$i>>2]|0;
       $cmp138$i = ($41|0)==(0|0);
       do {
        if (!($cmp138$i)) {
         $cmp142$i = ($41>>>0)<($40>>>0);
         if ($cmp142$i) {
          _abort();
          // unreachable;
         } else {
          $arrayidx148$i = ((($R$3$i)) + 16|0);
          HEAP32[$arrayidx148$i>>2] = $41;
          $parent149$i = ((($41)) + 24|0);
          HEAP32[$parent149$i>>2] = $R$3$i;
          break;
         }
        }
       } while(0);
       $arrayidx154$i = ((($v$0$i$lcssa)) + 20|0);
       $42 = HEAP32[$arrayidx154$i>>2]|0;
       $cmp155$i = ($42|0)==(0|0);
       if (!($cmp155$i)) {
        $43 = HEAP32[(192)>>2]|0;
        $cmp159$i = ($42>>>0)<($43>>>0);
        if ($cmp159$i) {
         _abort();
         // unreachable;
        } else {
         $arrayidx165$i = ((($R$3$i)) + 20|0);
         HEAP32[$arrayidx165$i>>2] = $42;
         $parent166$i = ((($42)) + 24|0);
         HEAP32[$parent166$i>>2] = $R$3$i;
         break;
        }
       }
      }
     } while(0);
     $cmp174$i = ($rsize$0$i$lcssa>>>0)<(16);
     if ($cmp174$i) {
      $add177$i = (($rsize$0$i$lcssa) + ($cond))|0;
      $or178$i = $add177$i | 3;
      $head179$i = ((($v$0$i$lcssa)) + 4|0);
      HEAP32[$head179$i>>2] = $or178$i;
      $add$ptr181$i = (($v$0$i$lcssa) + ($add177$i)|0);
      $head182$i = ((($add$ptr181$i)) + 4|0);
      $44 = HEAP32[$head182$i>>2]|0;
      $or183$i = $44 | 1;
      HEAP32[$head182$i>>2] = $or183$i;
     } else {
      $or186$i = $cond | 3;
      $head187$i = ((($v$0$i$lcssa)) + 4|0);
      HEAP32[$head187$i>>2] = $or186$i;
      $or188$i = $rsize$0$i$lcssa | 1;
      $head189$i = ((($add$ptr$i)) + 4|0);
      HEAP32[$head189$i>>2] = $or188$i;
      $add$ptr190$i = (($add$ptr$i) + ($rsize$0$i$lcssa)|0);
      HEAP32[$add$ptr190$i>>2] = $rsize$0$i$lcssa;
      $45 = HEAP32[(184)>>2]|0;
      $cmp191$i = ($45|0)==(0);
      if (!($cmp191$i)) {
       $46 = HEAP32[(196)>>2]|0;
       $shr194$i = $45 >>> 3;
       $shl195$i = $shr194$i << 1;
       $arrayidx196$i = (216 + ($shl195$i<<2)|0);
       $47 = HEAP32[44]|0;
       $shl198$i = 1 << $shr194$i;
       $and199$i = $47 & $shl198$i;
       $tobool200$i = ($and199$i|0)==(0);
       if ($tobool200$i) {
        $or204$i = $47 | $shl198$i;
        HEAP32[44] = $or204$i;
        $$pre$i = ((($arrayidx196$i)) + 8|0);
        $$pre$phi$iZ2D = $$pre$i;$F197$0$i = $arrayidx196$i;
       } else {
        $48 = ((($arrayidx196$i)) + 8|0);
        $49 = HEAP32[$48>>2]|0;
        $50 = HEAP32[(192)>>2]|0;
        $cmp208$i = ($49>>>0)<($50>>>0);
        if ($cmp208$i) {
         _abort();
         // unreachable;
        } else {
         $$pre$phi$iZ2D = $48;$F197$0$i = $49;
        }
       }
       HEAP32[$$pre$phi$iZ2D>>2] = $46;
       $bk218$i = ((($F197$0$i)) + 12|0);
       HEAP32[$bk218$i>>2] = $46;
       $fd219$i = ((($46)) + 8|0);
       HEAP32[$fd219$i>>2] = $F197$0$i;
       $bk220$i = ((($46)) + 12|0);
       HEAP32[$bk220$i>>2] = $arrayidx196$i;
      }
      HEAP32[(184)>>2] = $rsize$0$i$lcssa;
      HEAP32[(196)>>2] = $add$ptr$i;
     }
     $add$ptr225$i = ((($v$0$i$lcssa)) + 8|0);
     $retval$0 = $add$ptr225$i;
     return ($retval$0|0);
    }
   } else {
    $nb$0 = $cond;
   }
  } else {
   $cmp139 = ($bytes>>>0)>(4294967231);
   if ($cmp139) {
    $nb$0 = -1;
   } else {
    $add144 = (($bytes) + 11)|0;
    $and145 = $add144 & -8;
    $51 = HEAP32[(180)>>2]|0;
    $cmp146 = ($51|0)==(0);
    if ($cmp146) {
     $nb$0 = $and145;
    } else {
     $sub$i$138 = (0 - ($and145))|0;
     $shr$i$139 = $add144 >>> 8;
     $cmp$i$140 = ($shr$i$139|0)==(0);
     if ($cmp$i$140) {
      $idx$0$i = 0;
     } else {
      $cmp1$i = ($and145>>>0)>(16777215);
      if ($cmp1$i) {
       $idx$0$i = 31;
      } else {
       $sub4$i = (($shr$i$139) + 1048320)|0;
       $shr5$i$142 = $sub4$i >>> 16;
       $and$i$143 = $shr5$i$142 & 8;
       $shl$i$144 = $shr$i$139 << $and$i$143;
       $sub6$i = (($shl$i$144) + 520192)|0;
       $shr7$i$145 = $sub6$i >>> 16;
       $and8$i = $shr7$i$145 & 4;
       $add$i$146 = $and8$i | $and$i$143;
       $shl9$i = $shl$i$144 << $and8$i;
       $sub10$i = (($shl9$i) + 245760)|0;
       $shr11$i$147 = $sub10$i >>> 16;
       $and12$i = $shr11$i$147 & 2;
       $add13$i = $add$i$146 | $and12$i;
       $sub14$i = (14 - ($add13$i))|0;
       $shl15$i = $shl9$i << $and12$i;
       $shr16$i$148 = $shl15$i >>> 15;
       $add17$i = (($sub14$i) + ($shr16$i$148))|0;
       $shl18$i = $add17$i << 1;
       $add19$i = (($add17$i) + 7)|0;
       $shr20$i = $and145 >>> $add19$i;
       $and21$i$149 = $shr20$i & 1;
       $add22$i = $and21$i$149 | $shl18$i;
       $idx$0$i = $add22$i;
      }
     }
     $arrayidx$i$150 = (480 + ($idx$0$i<<2)|0);
     $52 = HEAP32[$arrayidx$i$150>>2]|0;
     $cmp24$i = ($52|0)==(0|0);
     L123: do {
      if ($cmp24$i) {
       $rsize$3$i = $sub$i$138;$t$2$i = 0;$v$3$i = 0;
       label = 86;
      } else {
       $cmp26$i = ($idx$0$i|0)==(31);
       $shr27$i = $idx$0$i >>> 1;
       $sub30$i = (25 - ($shr27$i))|0;
       $cond$i = $cmp26$i ? 0 : $sub30$i;
       $shl31$i = $and145 << $cond$i;
       $rsize$0$i$152 = $sub$i$138;$rst$0$i = 0;$sizebits$0$i = $shl31$i;$t$0$i$151 = $52;$v$0$i$153 = 0;
       while(1) {
        $head$i$154 = ((($t$0$i$151)) + 4|0);
        $53 = HEAP32[$head$i$154>>2]|0;
        $and32$i = $53 & -8;
        $sub33$i = (($and32$i) - ($and145))|0;
        $cmp34$i = ($sub33$i>>>0)<($rsize$0$i$152>>>0);
        if ($cmp34$i) {
         $cmp36$i = ($and32$i|0)==($and145|0);
         if ($cmp36$i) {
          $rsize$49$i = $sub33$i;$t$48$i = $t$0$i$151;$v$410$i = $t$0$i$151;
          label = 90;
          break L123;
         } else {
          $rsize$1$i = $sub33$i;$v$1$i = $t$0$i$151;
         }
        } else {
         $rsize$1$i = $rsize$0$i$152;$v$1$i = $v$0$i$153;
        }
        $arrayidx40$i = ((($t$0$i$151)) + 20|0);
        $54 = HEAP32[$arrayidx40$i>>2]|0;
        $shr41$i = $sizebits$0$i >>> 31;
        $arrayidx44$i = (((($t$0$i$151)) + 16|0) + ($shr41$i<<2)|0);
        $55 = HEAP32[$arrayidx44$i>>2]|0;
        $cmp45$i$155 = ($54|0)==(0|0);
        $cmp46$i = ($54|0)==($55|0);
        $or$cond1$i = $cmp45$i$155 | $cmp46$i;
        $rst$1$i = $or$cond1$i ? $rst$0$i : $54;
        $cmp49$i = ($55|0)==(0|0);
        $56 = $cmp49$i&1;
        $shl52$i = $56 ^ 1;
        $sizebits$0$shl52$i = $sizebits$0$i << $shl52$i;
        if ($cmp49$i) {
         $rsize$3$i = $rsize$1$i;$t$2$i = $rst$1$i;$v$3$i = $v$1$i;
         label = 86;
         break;
        } else {
         $rsize$0$i$152 = $rsize$1$i;$rst$0$i = $rst$1$i;$sizebits$0$i = $sizebits$0$shl52$i;$t$0$i$151 = $55;$v$0$i$153 = $v$1$i;
        }
       }
      }
     } while(0);
     if ((label|0) == 86) {
      $cmp55$i = ($t$2$i|0)==(0|0);
      $cmp57$i = ($v$3$i|0)==(0|0);
      $or$cond$i = $cmp55$i & $cmp57$i;
      if ($or$cond$i) {
       $shl60$i = 2 << $idx$0$i;
       $sub63$i = (0 - ($shl60$i))|0;
       $or$i = $shl60$i | $sub63$i;
       $and64$i = $51 & $or$i;
       $cmp65$i = ($and64$i|0)==(0);
       if ($cmp65$i) {
        $nb$0 = $and145;
        break;
       }
       $sub67$i = (0 - ($and64$i))|0;
       $and68$i = $and64$i & $sub67$i;
       $sub70$i = (($and68$i) + -1)|0;
       $shr72$i = $sub70$i >>> 12;
       $and73$i = $shr72$i & 16;
       $shr75$i = $sub70$i >>> $and73$i;
       $shr76$i = $shr75$i >>> 5;
       $and77$i = $shr76$i & 8;
       $add78$i = $and77$i | $and73$i;
       $shr79$i = $shr75$i >>> $and77$i;
       $shr80$i = $shr79$i >>> 2;
       $and81$i = $shr80$i & 4;
       $add82$i = $add78$i | $and81$i;
       $shr83$i = $shr79$i >>> $and81$i;
       $shr84$i = $shr83$i >>> 1;
       $and85$i = $shr84$i & 2;
       $add86$i = $add82$i | $and85$i;
       $shr87$i = $shr83$i >>> $and85$i;
       $shr88$i = $shr87$i >>> 1;
       $and89$i = $shr88$i & 1;
       $add90$i = $add86$i | $and89$i;
       $shr91$i = $shr87$i >>> $and89$i;
       $add92$i = (($add90$i) + ($shr91$i))|0;
       $arrayidx94$i$156 = (480 + ($add92$i<<2)|0);
       $57 = HEAP32[$arrayidx94$i$156>>2]|0;
       $t$4$ph$i = $57;
      } else {
       $t$4$ph$i = $t$2$i;
      }
      $cmp97$7$i = ($t$4$ph$i|0)==(0|0);
      if ($cmp97$7$i) {
       $rsize$4$lcssa$i = $rsize$3$i;$v$4$lcssa$i = $v$3$i;
      } else {
       $rsize$49$i = $rsize$3$i;$t$48$i = $t$4$ph$i;$v$410$i = $v$3$i;
       label = 90;
      }
     }
     if ((label|0) == 90) {
      while(1) {
       label = 0;
       $head99$i = ((($t$48$i)) + 4|0);
       $58 = HEAP32[$head99$i>>2]|0;
       $and100$i = $58 & -8;
       $sub101$i = (($and100$i) - ($and145))|0;
       $cmp102$i = ($sub101$i>>>0)<($rsize$49$i>>>0);
       $sub101$rsize$4$i = $cmp102$i ? $sub101$i : $rsize$49$i;
       $t$4$v$4$i = $cmp102$i ? $t$48$i : $v$410$i;
       $arrayidx106$i = ((($t$48$i)) + 16|0);
       $59 = HEAP32[$arrayidx106$i>>2]|0;
       $cmp107$i$157 = ($59|0)==(0|0);
       if (!($cmp107$i$157)) {
        $rsize$49$i = $sub101$rsize$4$i;$t$48$i = $59;$v$410$i = $t$4$v$4$i;
        label = 90;
        continue;
       }
       $arrayidx113$i$159 = ((($t$48$i)) + 20|0);
       $60 = HEAP32[$arrayidx113$i$159>>2]|0;
       $cmp97$i = ($60|0)==(0|0);
       if ($cmp97$i) {
        $rsize$4$lcssa$i = $sub101$rsize$4$i;$v$4$lcssa$i = $t$4$v$4$i;
        break;
       } else {
        $rsize$49$i = $sub101$rsize$4$i;$t$48$i = $60;$v$410$i = $t$4$v$4$i;
        label = 90;
       }
      }
     }
     $cmp116$i = ($v$4$lcssa$i|0)==(0|0);
     if ($cmp116$i) {
      $nb$0 = $and145;
     } else {
      $61 = HEAP32[(184)>>2]|0;
      $sub118$i = (($61) - ($and145))|0;
      $cmp119$i = ($rsize$4$lcssa$i>>>0)<($sub118$i>>>0);
      if ($cmp119$i) {
       $62 = HEAP32[(192)>>2]|0;
       $cmp121$i = ($v$4$lcssa$i>>>0)<($62>>>0);
       if ($cmp121$i) {
        _abort();
        // unreachable;
       }
       $add$ptr$i$161 = (($v$4$lcssa$i) + ($and145)|0);
       $cmp123$i = ($v$4$lcssa$i>>>0)<($add$ptr$i$161>>>0);
       if (!($cmp123$i)) {
        _abort();
        // unreachable;
       }
       $parent$i$162 = ((($v$4$lcssa$i)) + 24|0);
       $63 = HEAP32[$parent$i$162>>2]|0;
       $bk$i$163 = ((($v$4$lcssa$i)) + 12|0);
       $64 = HEAP32[$bk$i$163>>2]|0;
       $cmp128$i = ($64|0)==($v$4$lcssa$i|0);
       do {
        if ($cmp128$i) {
         $arrayidx151$i = ((($v$4$lcssa$i)) + 20|0);
         $68 = HEAP32[$arrayidx151$i>>2]|0;
         $cmp152$i = ($68|0)==(0|0);
         if ($cmp152$i) {
          $arrayidx155$i = ((($v$4$lcssa$i)) + 16|0);
          $69 = HEAP32[$arrayidx155$i>>2]|0;
          $cmp156$i = ($69|0)==(0|0);
          if ($cmp156$i) {
           $R$3$i$171 = 0;
           break;
          } else {
           $R$1$i$168 = $69;$RP$1$i$167 = $arrayidx155$i;
          }
         } else {
          $R$1$i$168 = $68;$RP$1$i$167 = $arrayidx151$i;
         }
         while(1) {
          $arrayidx161$i = ((($R$1$i$168)) + 20|0);
          $70 = HEAP32[$arrayidx161$i>>2]|0;
          $cmp162$i = ($70|0)==(0|0);
          if (!($cmp162$i)) {
           $R$1$i$168 = $70;$RP$1$i$167 = $arrayidx161$i;
           continue;
          }
          $arrayidx165$i$169 = ((($R$1$i$168)) + 16|0);
          $71 = HEAP32[$arrayidx165$i$169>>2]|0;
          $cmp166$i = ($71|0)==(0|0);
          if ($cmp166$i) {
           $R$1$i$168$lcssa = $R$1$i$168;$RP$1$i$167$lcssa = $RP$1$i$167;
           break;
          } else {
           $R$1$i$168 = $71;$RP$1$i$167 = $arrayidx165$i$169;
          }
         }
         $cmp171$i = ($RP$1$i$167$lcssa>>>0)<($62>>>0);
         if ($cmp171$i) {
          _abort();
          // unreachable;
         } else {
          HEAP32[$RP$1$i$167$lcssa>>2] = 0;
          $R$3$i$171 = $R$1$i$168$lcssa;
          break;
         }
        } else {
         $fd$i$164 = ((($v$4$lcssa$i)) + 8|0);
         $65 = HEAP32[$fd$i$164>>2]|0;
         $cmp133$i = ($65>>>0)<($62>>>0);
         if ($cmp133$i) {
          _abort();
          // unreachable;
         }
         $bk136$i = ((($65)) + 12|0);
         $66 = HEAP32[$bk136$i>>2]|0;
         $cmp137$i = ($66|0)==($v$4$lcssa$i|0);
         if (!($cmp137$i)) {
          _abort();
          // unreachable;
         }
         $fd139$i = ((($64)) + 8|0);
         $67 = HEAP32[$fd139$i>>2]|0;
         $cmp140$i = ($67|0)==($v$4$lcssa$i|0);
         if ($cmp140$i) {
          HEAP32[$bk136$i>>2] = $64;
          HEAP32[$fd139$i>>2] = $65;
          $R$3$i$171 = $64;
          break;
         } else {
          _abort();
          // unreachable;
         }
        }
       } while(0);
       $cmp180$i = ($63|0)==(0|0);
       do {
        if (!($cmp180$i)) {
         $index$i$172 = ((($v$4$lcssa$i)) + 28|0);
         $72 = HEAP32[$index$i$172>>2]|0;
         $arrayidx184$i = (480 + ($72<<2)|0);
         $73 = HEAP32[$arrayidx184$i>>2]|0;
         $cmp185$i = ($v$4$lcssa$i|0)==($73|0);
         if ($cmp185$i) {
          HEAP32[$arrayidx184$i>>2] = $R$3$i$171;
          $cond3$i = ($R$3$i$171|0)==(0|0);
          if ($cond3$i) {
           $shl192$i = 1 << $72;
           $neg$i$173 = $shl192$i ^ -1;
           $74 = HEAP32[(180)>>2]|0;
           $and194$i = $74 & $neg$i$173;
           HEAP32[(180)>>2] = $and194$i;
           break;
          }
         } else {
          $75 = HEAP32[(192)>>2]|0;
          $cmp198$i = ($63>>>0)<($75>>>0);
          if ($cmp198$i) {
           _abort();
           // unreachable;
          }
          $arrayidx204$i = ((($63)) + 16|0);
          $76 = HEAP32[$arrayidx204$i>>2]|0;
          $cmp205$i = ($76|0)==($v$4$lcssa$i|0);
          if ($cmp205$i) {
           HEAP32[$arrayidx204$i>>2] = $R$3$i$171;
          } else {
           $arrayidx212$i = ((($63)) + 20|0);
           HEAP32[$arrayidx212$i>>2] = $R$3$i$171;
          }
          $cmp217$i = ($R$3$i$171|0)==(0|0);
          if ($cmp217$i) {
           break;
          }
         }
         $77 = HEAP32[(192)>>2]|0;
         $cmp221$i = ($R$3$i$171>>>0)<($77>>>0);
         if ($cmp221$i) {
          _abort();
          // unreachable;
         }
         $parent226$i = ((($R$3$i$171)) + 24|0);
         HEAP32[$parent226$i>>2] = $63;
         $arrayidx228$i = ((($v$4$lcssa$i)) + 16|0);
         $78 = HEAP32[$arrayidx228$i>>2]|0;
         $cmp229$i = ($78|0)==(0|0);
         do {
          if (!($cmp229$i)) {
           $cmp233$i = ($78>>>0)<($77>>>0);
           if ($cmp233$i) {
            _abort();
            // unreachable;
           } else {
            $arrayidx239$i = ((($R$3$i$171)) + 16|0);
            HEAP32[$arrayidx239$i>>2] = $78;
            $parent240$i = ((($78)) + 24|0);
            HEAP32[$parent240$i>>2] = $R$3$i$171;
            break;
           }
          }
         } while(0);
         $arrayidx245$i = ((($v$4$lcssa$i)) + 20|0);
         $79 = HEAP32[$arrayidx245$i>>2]|0;
         $cmp246$i = ($79|0)==(0|0);
         if (!($cmp246$i)) {
          $80 = HEAP32[(192)>>2]|0;
          $cmp250$i = ($79>>>0)<($80>>>0);
          if ($cmp250$i) {
           _abort();
           // unreachable;
          } else {
           $arrayidx256$i = ((($R$3$i$171)) + 20|0);
           HEAP32[$arrayidx256$i>>2] = $79;
           $parent257$i = ((($79)) + 24|0);
           HEAP32[$parent257$i>>2] = $R$3$i$171;
           break;
          }
         }
        }
       } while(0);
       $cmp265$i = ($rsize$4$lcssa$i>>>0)<(16);
       do {
        if ($cmp265$i) {
         $add268$i = (($rsize$4$lcssa$i) + ($and145))|0;
         $or270$i = $add268$i | 3;
         $head271$i = ((($v$4$lcssa$i)) + 4|0);
         HEAP32[$head271$i>>2] = $or270$i;
         $add$ptr273$i = (($v$4$lcssa$i) + ($add268$i)|0);
         $head274$i = ((($add$ptr273$i)) + 4|0);
         $81 = HEAP32[$head274$i>>2]|0;
         $or275$i = $81 | 1;
         HEAP32[$head274$i>>2] = $or275$i;
        } else {
         $or278$i = $and145 | 3;
         $head279$i = ((($v$4$lcssa$i)) + 4|0);
         HEAP32[$head279$i>>2] = $or278$i;
         $or280$i = $rsize$4$lcssa$i | 1;
         $head281$i = ((($add$ptr$i$161)) + 4|0);
         HEAP32[$head281$i>>2] = $or280$i;
         $add$ptr282$i = (($add$ptr$i$161) + ($rsize$4$lcssa$i)|0);
         HEAP32[$add$ptr282$i>>2] = $rsize$4$lcssa$i;
         $shr283$i = $rsize$4$lcssa$i >>> 3;
         $cmp284$i = ($rsize$4$lcssa$i>>>0)<(256);
         if ($cmp284$i) {
          $shl288$i = $shr283$i << 1;
          $arrayidx289$i = (216 + ($shl288$i<<2)|0);
          $82 = HEAP32[44]|0;
          $shl291$i = 1 << $shr283$i;
          $and292$i = $82 & $shl291$i;
          $tobool293$i = ($and292$i|0)==(0);
          if ($tobool293$i) {
           $or297$i = $82 | $shl291$i;
           HEAP32[44] = $or297$i;
           $$pre$i$177 = ((($arrayidx289$i)) + 8|0);
           $$pre$phi$i$178Z2D = $$pre$i$177;$F290$0$i = $arrayidx289$i;
          } else {
           $83 = ((($arrayidx289$i)) + 8|0);
           $84 = HEAP32[$83>>2]|0;
           $85 = HEAP32[(192)>>2]|0;
           $cmp301$i = ($84>>>0)<($85>>>0);
           if ($cmp301$i) {
            _abort();
            // unreachable;
           } else {
            $$pre$phi$i$178Z2D = $83;$F290$0$i = $84;
           }
          }
          HEAP32[$$pre$phi$i$178Z2D>>2] = $add$ptr$i$161;
          $bk311$i = ((($F290$0$i)) + 12|0);
          HEAP32[$bk311$i>>2] = $add$ptr$i$161;
          $fd312$i = ((($add$ptr$i$161)) + 8|0);
          HEAP32[$fd312$i>>2] = $F290$0$i;
          $bk313$i = ((($add$ptr$i$161)) + 12|0);
          HEAP32[$bk313$i>>2] = $arrayidx289$i;
          break;
         }
         $shr318$i = $rsize$4$lcssa$i >>> 8;
         $cmp319$i = ($shr318$i|0)==(0);
         if ($cmp319$i) {
          $I316$0$i = 0;
         } else {
          $cmp323$i = ($rsize$4$lcssa$i>>>0)>(16777215);
          if ($cmp323$i) {
           $I316$0$i = 31;
          } else {
           $sub329$i = (($shr318$i) + 1048320)|0;
           $shr330$i = $sub329$i >>> 16;
           $and331$i = $shr330$i & 8;
           $shl333$i = $shr318$i << $and331$i;
           $sub334$i = (($shl333$i) + 520192)|0;
           $shr335$i = $sub334$i >>> 16;
           $and336$i = $shr335$i & 4;
           $add337$i = $and336$i | $and331$i;
           $shl338$i = $shl333$i << $and336$i;
           $sub339$i = (($shl338$i) + 245760)|0;
           $shr340$i = $sub339$i >>> 16;
           $and341$i = $shr340$i & 2;
           $add342$i = $add337$i | $and341$i;
           $sub343$i = (14 - ($add342$i))|0;
           $shl344$i = $shl338$i << $and341$i;
           $shr345$i = $shl344$i >>> 15;
           $add346$i = (($sub343$i) + ($shr345$i))|0;
           $shl347$i = $add346$i << 1;
           $add348$i = (($add346$i) + 7)|0;
           $shr349$i = $rsize$4$lcssa$i >>> $add348$i;
           $and350$i = $shr349$i & 1;
           $add351$i = $and350$i | $shl347$i;
           $I316$0$i = $add351$i;
          }
         }
         $arrayidx355$i = (480 + ($I316$0$i<<2)|0);
         $index356$i = ((($add$ptr$i$161)) + 28|0);
         HEAP32[$index356$i>>2] = $I316$0$i;
         $child357$i = ((($add$ptr$i$161)) + 16|0);
         $arrayidx358$i = ((($child357$i)) + 4|0);
         HEAP32[$arrayidx358$i>>2] = 0;
         HEAP32[$child357$i>>2] = 0;
         $86 = HEAP32[(180)>>2]|0;
         $shl362$i = 1 << $I316$0$i;
         $and363$i = $86 & $shl362$i;
         $tobool364$i = ($and363$i|0)==(0);
         if ($tobool364$i) {
          $or368$i = $86 | $shl362$i;
          HEAP32[(180)>>2] = $or368$i;
          HEAP32[$arrayidx355$i>>2] = $add$ptr$i$161;
          $parent369$i = ((($add$ptr$i$161)) + 24|0);
          HEAP32[$parent369$i>>2] = $arrayidx355$i;
          $bk370$i = ((($add$ptr$i$161)) + 12|0);
          HEAP32[$bk370$i>>2] = $add$ptr$i$161;
          $fd371$i = ((($add$ptr$i$161)) + 8|0);
          HEAP32[$fd371$i>>2] = $add$ptr$i$161;
          break;
         }
         $87 = HEAP32[$arrayidx355$i>>2]|0;
         $cmp374$i = ($I316$0$i|0)==(31);
         $shr378$i = $I316$0$i >>> 1;
         $sub381$i = (25 - ($shr378$i))|0;
         $cond383$i = $cmp374$i ? 0 : $sub381$i;
         $shl384$i = $rsize$4$lcssa$i << $cond383$i;
         $K373$0$i = $shl384$i;$T$0$i = $87;
         while(1) {
          $head386$i = ((($T$0$i)) + 4|0);
          $88 = HEAP32[$head386$i>>2]|0;
          $and387$i = $88 & -8;
          $cmp388$i = ($and387$i|0)==($rsize$4$lcssa$i|0);
          if ($cmp388$i) {
           $T$0$i$lcssa = $T$0$i;
           label = 148;
           break;
          }
          $shr391$i = $K373$0$i >>> 31;
          $arrayidx394$i = (((($T$0$i)) + 16|0) + ($shr391$i<<2)|0);
          $shl395$i = $K373$0$i << 1;
          $89 = HEAP32[$arrayidx394$i>>2]|0;
          $cmp396$i = ($89|0)==(0|0);
          if ($cmp396$i) {
           $T$0$i$lcssa293 = $T$0$i;$arrayidx394$i$lcssa = $arrayidx394$i;
           label = 145;
           break;
          } else {
           $K373$0$i = $shl395$i;$T$0$i = $89;
          }
         }
         if ((label|0) == 145) {
          $90 = HEAP32[(192)>>2]|0;
          $cmp401$i = ($arrayidx394$i$lcssa>>>0)<($90>>>0);
          if ($cmp401$i) {
           _abort();
           // unreachable;
          } else {
           HEAP32[$arrayidx394$i$lcssa>>2] = $add$ptr$i$161;
           $parent406$i = ((($add$ptr$i$161)) + 24|0);
           HEAP32[$parent406$i>>2] = $T$0$i$lcssa293;
           $bk407$i = ((($add$ptr$i$161)) + 12|0);
           HEAP32[$bk407$i>>2] = $add$ptr$i$161;
           $fd408$i = ((($add$ptr$i$161)) + 8|0);
           HEAP32[$fd408$i>>2] = $add$ptr$i$161;
           break;
          }
         }
         else if ((label|0) == 148) {
          $fd416$i = ((($T$0$i$lcssa)) + 8|0);
          $91 = HEAP32[$fd416$i>>2]|0;
          $92 = HEAP32[(192)>>2]|0;
          $cmp422$i = ($91>>>0)>=($92>>>0);
          $not$cmp418$i = ($T$0$i$lcssa>>>0)>=($92>>>0);
          $93 = $cmp422$i & $not$cmp418$i;
          if ($93) {
           $bk429$i = ((($91)) + 12|0);
           HEAP32[$bk429$i>>2] = $add$ptr$i$161;
           HEAP32[$fd416$i>>2] = $add$ptr$i$161;
           $fd431$i = ((($add$ptr$i$161)) + 8|0);
           HEAP32[$fd431$i>>2] = $91;
           $bk432$i = ((($add$ptr$i$161)) + 12|0);
           HEAP32[$bk432$i>>2] = $T$0$i$lcssa;
           $parent433$i = ((($add$ptr$i$161)) + 24|0);
           HEAP32[$parent433$i>>2] = 0;
           break;
          } else {
           _abort();
           // unreachable;
          }
         }
        }
       } while(0);
       $add$ptr441$i = ((($v$4$lcssa$i)) + 8|0);
       $retval$0 = $add$ptr441$i;
       return ($retval$0|0);
      } else {
       $nb$0 = $and145;
      }
     }
    }
   }
  }
 } while(0);
 $94 = HEAP32[(184)>>2]|0;
 $cmp156 = ($94>>>0)<($nb$0>>>0);
 if (!($cmp156)) {
  $sub160 = (($94) - ($nb$0))|0;
  $95 = HEAP32[(196)>>2]|0;
  $cmp162 = ($sub160>>>0)>(15);
  if ($cmp162) {
   $add$ptr166 = (($95) + ($nb$0)|0);
   HEAP32[(196)>>2] = $add$ptr166;
   HEAP32[(184)>>2] = $sub160;
   $or167 = $sub160 | 1;
   $head168 = ((($add$ptr166)) + 4|0);
   HEAP32[$head168>>2] = $or167;
   $add$ptr169 = (($add$ptr166) + ($sub160)|0);
   HEAP32[$add$ptr169>>2] = $sub160;
   $or172 = $nb$0 | 3;
   $head173 = ((($95)) + 4|0);
   HEAP32[$head173>>2] = $or172;
  } else {
   HEAP32[(184)>>2] = 0;
   HEAP32[(196)>>2] = 0;
   $or176 = $94 | 3;
   $head177 = ((($95)) + 4|0);
   HEAP32[$head177>>2] = $or176;
   $add$ptr178 = (($95) + ($94)|0);
   $head179 = ((($add$ptr178)) + 4|0);
   $96 = HEAP32[$head179>>2]|0;
   $or180 = $96 | 1;
   HEAP32[$head179>>2] = $or180;
  }
  $add$ptr182 = ((($95)) + 8|0);
  $retval$0 = $add$ptr182;
  return ($retval$0|0);
 }
 $97 = HEAP32[(188)>>2]|0;
 $cmp186 = ($97>>>0)>($nb$0>>>0);
 if ($cmp186) {
  $sub190 = (($97) - ($nb$0))|0;
  HEAP32[(188)>>2] = $sub190;
  $98 = HEAP32[(200)>>2]|0;
  $add$ptr193 = (($98) + ($nb$0)|0);
  HEAP32[(200)>>2] = $add$ptr193;
  $or194 = $sub190 | 1;
  $head195 = ((($add$ptr193)) + 4|0);
  HEAP32[$head195>>2] = $or194;
  $or197 = $nb$0 | 3;
  $head198 = ((($98)) + 4|0);
  HEAP32[$head198>>2] = $or197;
  $add$ptr199 = ((($98)) + 8|0);
  $retval$0 = $add$ptr199;
  return ($retval$0|0);
 }
 $99 = HEAP32[162]|0;
 $cmp$i$179 = ($99|0)==(0);
 do {
  if ($cmp$i$179) {
   $call$i$i = (_sysconf(30)|0);
   $sub$i$i = (($call$i$i) + -1)|0;
   $and$i$i = $sub$i$i & $call$i$i;
   $cmp1$i$i = ($and$i$i|0)==(0);
   if ($cmp1$i$i) {
    HEAP32[(656)>>2] = $call$i$i;
    HEAP32[(652)>>2] = $call$i$i;
    HEAP32[(660)>>2] = -1;
    HEAP32[(664)>>2] = -1;
    HEAP32[(668)>>2] = 0;
    HEAP32[(620)>>2] = 0;
    $call6$i$i = (_time((0|0))|0);
    $xor$i$i = $call6$i$i & -16;
    $and7$i$i = $xor$i$i ^ 1431655768;
    HEAP32[162] = $and7$i$i;
    break;
   } else {
    _abort();
    // unreachable;
   }
  }
 } while(0);
 $add$i$180 = (($nb$0) + 48)|0;
 $100 = HEAP32[(656)>>2]|0;
 $sub$i$181 = (($nb$0) + 47)|0;
 $add9$i = (($100) + ($sub$i$181))|0;
 $neg$i$182 = (0 - ($100))|0;
 $and11$i = $add9$i & $neg$i$182;
 $cmp12$i = ($and11$i>>>0)>($nb$0>>>0);
 if (!($cmp12$i)) {
  $retval$0 = 0;
  return ($retval$0|0);
 }
 $101 = HEAP32[(616)>>2]|0;
 $cmp15$i = ($101|0)==(0);
 if (!($cmp15$i)) {
  $102 = HEAP32[(608)>>2]|0;
  $add17$i$183 = (($102) + ($and11$i))|0;
  $cmp19$i = ($add17$i$183>>>0)<=($102>>>0);
  $cmp21$i = ($add17$i$183>>>0)>($101>>>0);
  $or$cond1$i$184 = $cmp19$i | $cmp21$i;
  if ($or$cond1$i$184) {
   $retval$0 = 0;
   return ($retval$0|0);
  }
 }
 $103 = HEAP32[(620)>>2]|0;
 $and29$i = $103 & 4;
 $tobool30$i = ($and29$i|0)==(0);
 L257: do {
  if ($tobool30$i) {
   $104 = HEAP32[(200)>>2]|0;
   $cmp32$i$185 = ($104|0)==(0|0);
   L259: do {
    if ($cmp32$i$185) {
     label = 173;
    } else {
     $sp$0$i$i = (624);
     while(1) {
      $105 = HEAP32[$sp$0$i$i>>2]|0;
      $cmp$i$9$i = ($105>>>0)>($104>>>0);
      if (!($cmp$i$9$i)) {
       $size$i$i = ((($sp$0$i$i)) + 4|0);
       $106 = HEAP32[$size$i$i>>2]|0;
       $add$ptr$i$i = (($105) + ($106)|0);
       $cmp2$i$i = ($add$ptr$i$i>>>0)>($104>>>0);
       if ($cmp2$i$i) {
        $base$i$i$lcssa = $sp$0$i$i;$size$i$i$lcssa = $size$i$i;
        break;
       }
      }
      $next$i$i = ((($sp$0$i$i)) + 8|0);
      $107 = HEAP32[$next$i$i>>2]|0;
      $cmp3$i$i = ($107|0)==(0|0);
      if ($cmp3$i$i) {
       label = 173;
       break L259;
      } else {
       $sp$0$i$i = $107;
      }
     }
     $112 = HEAP32[(188)>>2]|0;
     $add77$i = (($add9$i) - ($112))|0;
     $and80$i = $add77$i & $neg$i$182;
     $cmp81$i$191 = ($and80$i>>>0)<(2147483647);
     if ($cmp81$i$191) {
      $call83$i = (_sbrk(($and80$i|0))|0);
      $113 = HEAP32[$base$i$i$lcssa>>2]|0;
      $114 = HEAP32[$size$i$i$lcssa>>2]|0;
      $add$ptr$i$193 = (($113) + ($114)|0);
      $cmp85$i = ($call83$i|0)==($add$ptr$i$193|0);
      if ($cmp85$i) {
       $cmp89$i = ($call83$i|0)==((-1)|0);
       if (!($cmp89$i)) {
        $tbase$796$i = $call83$i;$tsize$795$i = $and80$i;
        label = 193;
        break L257;
       }
      } else {
       $br$2$ph$i = $call83$i;$ssize$2$ph$i = $and80$i;
       label = 183;
      }
     }
    }
   } while(0);
   do {
    if ((label|0) == 173) {
     $call37$i = (_sbrk(0)|0);
     $cmp38$i = ($call37$i|0)==((-1)|0);
     if (!($cmp38$i)) {
      $108 = $call37$i;
      $109 = HEAP32[(652)>>2]|0;
      $sub41$i = (($109) + -1)|0;
      $and42$i = $sub41$i & $108;
      $cmp43$i = ($and42$i|0)==(0);
      if ($cmp43$i) {
       $ssize$0$i = $and11$i;
      } else {
       $add46$i = (($sub41$i) + ($108))|0;
       $neg48$i = (0 - ($109))|0;
       $and49$i = $add46$i & $neg48$i;
       $sub50$i = (($and11$i) - ($108))|0;
       $add51$i = (($sub50$i) + ($and49$i))|0;
       $ssize$0$i = $add51$i;
      }
      $110 = HEAP32[(608)>>2]|0;
      $add54$i = (($110) + ($ssize$0$i))|0;
      $cmp55$i$187 = ($ssize$0$i>>>0)>($nb$0>>>0);
      $cmp57$i$188 = ($ssize$0$i>>>0)<(2147483647);
      $or$cond$i$189 = $cmp55$i$187 & $cmp57$i$188;
      if ($or$cond$i$189) {
       $111 = HEAP32[(616)>>2]|0;
       $cmp60$i = ($111|0)==(0);
       if (!($cmp60$i)) {
        $cmp63$i = ($add54$i>>>0)<=($110>>>0);
        $cmp66$i$190 = ($add54$i>>>0)>($111>>>0);
        $or$cond2$i = $cmp63$i | $cmp66$i$190;
        if ($or$cond2$i) {
         break;
        }
       }
       $call68$i = (_sbrk(($ssize$0$i|0))|0);
       $cmp69$i = ($call68$i|0)==($call37$i|0);
       if ($cmp69$i) {
        $tbase$796$i = $call37$i;$tsize$795$i = $ssize$0$i;
        label = 193;
        break L257;
       } else {
        $br$2$ph$i = $call68$i;$ssize$2$ph$i = $ssize$0$i;
        label = 183;
       }
      }
     }
    }
   } while(0);
   L279: do {
    if ((label|0) == 183) {
     $sub112$i = (0 - ($ssize$2$ph$i))|0;
     $cmp91$i = ($br$2$ph$i|0)!=((-1)|0);
     $cmp93$i = ($ssize$2$ph$i>>>0)<(2147483647);
     $or$cond5$i = $cmp93$i & $cmp91$i;
     $cmp96$i = ($add$i$180>>>0)>($ssize$2$ph$i>>>0);
     $or$cond3$i = $cmp96$i & $or$cond5$i;
     do {
      if ($or$cond3$i) {
       $115 = HEAP32[(656)>>2]|0;
       $sub99$i = (($sub$i$181) - ($ssize$2$ph$i))|0;
       $add101$i = (($sub99$i) + ($115))|0;
       $neg103$i = (0 - ($115))|0;
       $and104$i = $add101$i & $neg103$i;
       $cmp105$i = ($and104$i>>>0)<(2147483647);
       if ($cmp105$i) {
        $call107$i = (_sbrk(($and104$i|0))|0);
        $cmp108$i = ($call107$i|0)==((-1)|0);
        if ($cmp108$i) {
         (_sbrk(($sub112$i|0))|0);
         break L279;
        } else {
         $add110$i = (($and104$i) + ($ssize$2$ph$i))|0;
         $ssize$5$i = $add110$i;
         break;
        }
       } else {
        $ssize$5$i = $ssize$2$ph$i;
       }
      } else {
       $ssize$5$i = $ssize$2$ph$i;
      }
     } while(0);
     $cmp118$i = ($br$2$ph$i|0)==((-1)|0);
     if (!($cmp118$i)) {
      $tbase$796$i = $br$2$ph$i;$tsize$795$i = $ssize$5$i;
      label = 193;
      break L257;
     }
    }
   } while(0);
   $116 = HEAP32[(620)>>2]|0;
   $or$i$195 = $116 | 4;
   HEAP32[(620)>>2] = $or$i$195;
   label = 190;
  } else {
   label = 190;
  }
 } while(0);
 if ((label|0) == 190) {
  $cmp127$i = ($and11$i>>>0)<(2147483647);
  if ($cmp127$i) {
   $call131$i = (_sbrk(($and11$i|0))|0);
   $call132$i = (_sbrk(0)|0);
   $cmp133$i$196 = ($call131$i|0)!=((-1)|0);
   $cmp135$i = ($call132$i|0)!=((-1)|0);
   $or$cond4$i = $cmp133$i$196 & $cmp135$i;
   $cmp137$i$197 = ($call131$i>>>0)<($call132$i>>>0);
   $or$cond7$i = $cmp137$i$197 & $or$cond4$i;
   if ($or$cond7$i) {
    $sub$ptr$lhs$cast$i = $call132$i;
    $sub$ptr$rhs$cast$i = $call131$i;
    $sub$ptr$sub$i = (($sub$ptr$lhs$cast$i) - ($sub$ptr$rhs$cast$i))|0;
    $add140$i = (($nb$0) + 40)|0;
    $cmp141$not$i = ($sub$ptr$sub$i>>>0)>($add140$i>>>0);
    if ($cmp141$not$i) {
     $tbase$796$i = $call131$i;$tsize$795$i = $sub$ptr$sub$i;
     label = 193;
    }
   }
  }
 }
 if ((label|0) == 193) {
  $117 = HEAP32[(608)>>2]|0;
  $add150$i = (($117) + ($tsize$795$i))|0;
  HEAP32[(608)>>2] = $add150$i;
  $118 = HEAP32[(612)>>2]|0;
  $cmp151$i = ($add150$i>>>0)>($118>>>0);
  if ($cmp151$i) {
   HEAP32[(612)>>2] = $add150$i;
  }
  $119 = HEAP32[(200)>>2]|0;
  $cmp157$i = ($119|0)==(0|0);
  do {
   if ($cmp157$i) {
    $120 = HEAP32[(192)>>2]|0;
    $cmp159$i$199 = ($120|0)==(0|0);
    $cmp162$i$200 = ($tbase$796$i>>>0)<($120>>>0);
    $or$cond8$i = $cmp159$i$199 | $cmp162$i$200;
    if ($or$cond8$i) {
     HEAP32[(192)>>2] = $tbase$796$i;
    }
    HEAP32[(624)>>2] = $tbase$796$i;
    HEAP32[(628)>>2] = $tsize$795$i;
    HEAP32[(636)>>2] = 0;
    $121 = HEAP32[162]|0;
    HEAP32[(212)>>2] = $121;
    HEAP32[(208)>>2] = -1;
    $i$01$i$i = 0;
    while(1) {
     $shl$i$i = $i$01$i$i << 1;
     $arrayidx$i$i = (216 + ($shl$i$i<<2)|0);
     $122 = ((($arrayidx$i$i)) + 12|0);
     HEAP32[$122>>2] = $arrayidx$i$i;
     $123 = ((($arrayidx$i$i)) + 8|0);
     HEAP32[$123>>2] = $arrayidx$i$i;
     $inc$i$i = (($i$01$i$i) + 1)|0;
     $exitcond$i$i = ($inc$i$i|0)==(32);
     if ($exitcond$i$i) {
      break;
     } else {
      $i$01$i$i = $inc$i$i;
     }
    }
    $sub172$i = (($tsize$795$i) + -40)|0;
    $add$ptr$i$11$i = ((($tbase$796$i)) + 8|0);
    $124 = $add$ptr$i$11$i;
    $and$i$12$i = $124 & 7;
    $cmp$i$13$i = ($and$i$12$i|0)==(0);
    $125 = (0 - ($124))|0;
    $and3$i$i = $125 & 7;
    $cond$i$i = $cmp$i$13$i ? 0 : $and3$i$i;
    $add$ptr4$i$i = (($tbase$796$i) + ($cond$i$i)|0);
    $sub5$i$i = (($sub172$i) - ($cond$i$i))|0;
    HEAP32[(200)>>2] = $add$ptr4$i$i;
    HEAP32[(188)>>2] = $sub5$i$i;
    $or$i$i = $sub5$i$i | 1;
    $head$i$i = ((($add$ptr4$i$i)) + 4|0);
    HEAP32[$head$i$i>>2] = $or$i$i;
    $add$ptr6$i$i = (($add$ptr4$i$i) + ($sub5$i$i)|0);
    $head7$i$i = ((($add$ptr6$i$i)) + 4|0);
    HEAP32[$head7$i$i>>2] = 40;
    $126 = HEAP32[(664)>>2]|0;
    HEAP32[(204)>>2] = $126;
   } else {
    $sp$0108$i = (624);
    while(1) {
     $127 = HEAP32[$sp$0108$i>>2]|0;
     $size188$i = ((($sp$0108$i)) + 4|0);
     $128 = HEAP32[$size188$i>>2]|0;
     $add$ptr189$i = (($127) + ($128)|0);
     $cmp190$i = ($tbase$796$i|0)==($add$ptr189$i|0);
     if ($cmp190$i) {
      $$lcssa = $127;$$lcssa290 = $128;$size188$i$lcssa = $size188$i;$sp$0108$i$lcssa = $sp$0108$i;
      label = 203;
      break;
     }
     $next$i = ((($sp$0108$i)) + 8|0);
     $129 = HEAP32[$next$i>>2]|0;
     $cmp186$i = ($129|0)==(0|0);
     if ($cmp186$i) {
      break;
     } else {
      $sp$0108$i = $129;
     }
    }
    if ((label|0) == 203) {
     $sflags193$i = ((($sp$0108$i$lcssa)) + 12|0);
     $130 = HEAP32[$sflags193$i>>2]|0;
     $and194$i$204 = $130 & 8;
     $tobool195$i = ($and194$i$204|0)==(0);
     if ($tobool195$i) {
      $cmp203$i = ($119>>>0)>=($$lcssa>>>0);
      $cmp209$i = ($119>>>0)<($tbase$796$i>>>0);
      $or$cond98$i = $cmp209$i & $cmp203$i;
      if ($or$cond98$i) {
       $add212$i = (($$lcssa290) + ($tsize$795$i))|0;
       HEAP32[$size188$i$lcssa>>2] = $add212$i;
       $131 = HEAP32[(188)>>2]|0;
       $add$ptr$i$21$i = ((($119)) + 8|0);
       $132 = $add$ptr$i$21$i;
       $and$i$22$i = $132 & 7;
       $cmp$i$23$i = ($and$i$22$i|0)==(0);
       $133 = (0 - ($132))|0;
       $and3$i$24$i = $133 & 7;
       $cond$i$25$i = $cmp$i$23$i ? 0 : $and3$i$24$i;
       $add$ptr4$i$26$i = (($119) + ($cond$i$25$i)|0);
       $add215$i = (($tsize$795$i) - ($cond$i$25$i))|0;
       $sub5$i$27$i = (($add215$i) + ($131))|0;
       HEAP32[(200)>>2] = $add$ptr4$i$26$i;
       HEAP32[(188)>>2] = $sub5$i$27$i;
       $or$i$28$i = $sub5$i$27$i | 1;
       $head$i$29$i = ((($add$ptr4$i$26$i)) + 4|0);
       HEAP32[$head$i$29$i>>2] = $or$i$28$i;
       $add$ptr6$i$30$i = (($add$ptr4$i$26$i) + ($sub5$i$27$i)|0);
       $head7$i$31$i = ((($add$ptr6$i$30$i)) + 4|0);
       HEAP32[$head7$i$31$i>>2] = 40;
       $134 = HEAP32[(664)>>2]|0;
       HEAP32[(204)>>2] = $134;
       break;
      }
     }
    }
    $135 = HEAP32[(192)>>2]|0;
    $cmp218$i = ($tbase$796$i>>>0)<($135>>>0);
    if ($cmp218$i) {
     HEAP32[(192)>>2] = $tbase$796$i;
     $150 = $tbase$796$i;
    } else {
     $150 = $135;
    }
    $add$ptr227$i = (($tbase$796$i) + ($tsize$795$i)|0);
    $sp$1107$i = (624);
    while(1) {
     $136 = HEAP32[$sp$1107$i>>2]|0;
     $cmp228$i = ($136|0)==($add$ptr227$i|0);
     if ($cmp228$i) {
      $base226$i$lcssa = $sp$1107$i;$sp$1107$i$lcssa = $sp$1107$i;
      label = 211;
      break;
     }
     $next231$i = ((($sp$1107$i)) + 8|0);
     $137 = HEAP32[$next231$i>>2]|0;
     $cmp224$i = ($137|0)==(0|0);
     if ($cmp224$i) {
      $sp$0$i$i$i = (624);
      break;
     } else {
      $sp$1107$i = $137;
     }
    }
    if ((label|0) == 211) {
     $sflags235$i = ((($sp$1107$i$lcssa)) + 12|0);
     $138 = HEAP32[$sflags235$i>>2]|0;
     $and236$i = $138 & 8;
     $tobool237$i = ($and236$i|0)==(0);
     if ($tobool237$i) {
      HEAP32[$base226$i$lcssa>>2] = $tbase$796$i;
      $size245$i = ((($sp$1107$i$lcssa)) + 4|0);
      $139 = HEAP32[$size245$i>>2]|0;
      $add246$i = (($139) + ($tsize$795$i))|0;
      HEAP32[$size245$i>>2] = $add246$i;
      $add$ptr$i$32$i = ((($tbase$796$i)) + 8|0);
      $140 = $add$ptr$i$32$i;
      $and$i$33$i = $140 & 7;
      $cmp$i$34$i = ($and$i$33$i|0)==(0);
      $141 = (0 - ($140))|0;
      $and3$i$35$i = $141 & 7;
      $cond$i$36$i = $cmp$i$34$i ? 0 : $and3$i$35$i;
      $add$ptr4$i$37$i = (($tbase$796$i) + ($cond$i$36$i)|0);
      $add$ptr5$i$i = ((($add$ptr227$i)) + 8|0);
      $142 = $add$ptr5$i$i;
      $and6$i$38$i = $142 & 7;
      $cmp7$i$i = ($and6$i$38$i|0)==(0);
      $143 = (0 - ($142))|0;
      $and13$i$i = $143 & 7;
      $cond15$i$i = $cmp7$i$i ? 0 : $and13$i$i;
      $add$ptr16$i$i = (($add$ptr227$i) + ($cond15$i$i)|0);
      $sub$ptr$lhs$cast$i$39$i = $add$ptr16$i$i;
      $sub$ptr$rhs$cast$i$40$i = $add$ptr4$i$37$i;
      $sub$ptr$sub$i$41$i = (($sub$ptr$lhs$cast$i$39$i) - ($sub$ptr$rhs$cast$i$40$i))|0;
      $add$ptr17$i$i = (($add$ptr4$i$37$i) + ($nb$0)|0);
      $sub18$i$i = (($sub$ptr$sub$i$41$i) - ($nb$0))|0;
      $or19$i$i = $nb$0 | 3;
      $head$i$42$i = ((($add$ptr4$i$37$i)) + 4|0);
      HEAP32[$head$i$42$i>>2] = $or19$i$i;
      $cmp20$i$i = ($add$ptr16$i$i|0)==($119|0);
      do {
       if ($cmp20$i$i) {
        $144 = HEAP32[(188)>>2]|0;
        $add$i$i = (($144) + ($sub18$i$i))|0;
        HEAP32[(188)>>2] = $add$i$i;
        HEAP32[(200)>>2] = $add$ptr17$i$i;
        $or22$i$i = $add$i$i | 1;
        $head23$i$i = ((($add$ptr17$i$i)) + 4|0);
        HEAP32[$head23$i$i>>2] = $or22$i$i;
       } else {
        $145 = HEAP32[(196)>>2]|0;
        $cmp24$i$i = ($add$ptr16$i$i|0)==($145|0);
        if ($cmp24$i$i) {
         $146 = HEAP32[(184)>>2]|0;
         $add26$i$i = (($146) + ($sub18$i$i))|0;
         HEAP32[(184)>>2] = $add26$i$i;
         HEAP32[(196)>>2] = $add$ptr17$i$i;
         $or28$i$i = $add26$i$i | 1;
         $head29$i$i = ((($add$ptr17$i$i)) + 4|0);
         HEAP32[$head29$i$i>>2] = $or28$i$i;
         $add$ptr30$i$i = (($add$ptr17$i$i) + ($add26$i$i)|0);
         HEAP32[$add$ptr30$i$i>>2] = $add26$i$i;
         break;
        }
        $head32$i$i = ((($add$ptr16$i$i)) + 4|0);
        $147 = HEAP32[$head32$i$i>>2]|0;
        $and33$i$i = $147 & 3;
        $cmp34$i$i = ($and33$i$i|0)==(1);
        if ($cmp34$i$i) {
         $and37$i$i = $147 & -8;
         $shr$i$45$i = $147 >>> 3;
         $cmp38$i$i = ($147>>>0)<(256);
         L331: do {
          if ($cmp38$i$i) {
           $fd$i$i = ((($add$ptr16$i$i)) + 8|0);
           $148 = HEAP32[$fd$i$i>>2]|0;
           $bk$i$46$i = ((($add$ptr16$i$i)) + 12|0);
           $149 = HEAP32[$bk$i$46$i>>2]|0;
           $shl$i$47$i = $shr$i$45$i << 1;
           $arrayidx$i$48$i = (216 + ($shl$i$47$i<<2)|0);
           $cmp41$i$i = ($148|0)==($arrayidx$i$48$i|0);
           do {
            if (!($cmp41$i$i)) {
             $cmp42$i$i = ($148>>>0)<($150>>>0);
             if ($cmp42$i$i) {
              _abort();
              // unreachable;
             }
             $bk43$i$i = ((($148)) + 12|0);
             $151 = HEAP32[$bk43$i$i>>2]|0;
             $cmp44$i$i = ($151|0)==($add$ptr16$i$i|0);
             if ($cmp44$i$i) {
              break;
             }
             _abort();
             // unreachable;
            }
           } while(0);
           $cmp46$i$49$i = ($149|0)==($148|0);
           if ($cmp46$i$49$i) {
            $shl48$i$i = 1 << $shr$i$45$i;
            $neg$i$i = $shl48$i$i ^ -1;
            $152 = HEAP32[44]|0;
            $and49$i$i = $152 & $neg$i$i;
            HEAP32[44] = $and49$i$i;
            break;
           }
           $cmp54$i$i = ($149|0)==($arrayidx$i$48$i|0);
           do {
            if ($cmp54$i$i) {
             $$pre5$i$i = ((($149)) + 8|0);
             $fd68$pre$phi$i$iZ2D = $$pre5$i$i;
            } else {
             $cmp57$i$i = ($149>>>0)<($150>>>0);
             if ($cmp57$i$i) {
              _abort();
              // unreachable;
             }
             $fd59$i$i = ((($149)) + 8|0);
             $153 = HEAP32[$fd59$i$i>>2]|0;
             $cmp60$i$i = ($153|0)==($add$ptr16$i$i|0);
             if ($cmp60$i$i) {
              $fd68$pre$phi$i$iZ2D = $fd59$i$i;
              break;
             }
             _abort();
             // unreachable;
            }
           } while(0);
           $bk67$i$i = ((($148)) + 12|0);
           HEAP32[$bk67$i$i>>2] = $149;
           HEAP32[$fd68$pre$phi$i$iZ2D>>2] = $148;
          } else {
           $parent$i$51$i = ((($add$ptr16$i$i)) + 24|0);
           $154 = HEAP32[$parent$i$51$i>>2]|0;
           $bk74$i$i = ((($add$ptr16$i$i)) + 12|0);
           $155 = HEAP32[$bk74$i$i>>2]|0;
           $cmp75$i$i = ($155|0)==($add$ptr16$i$i|0);
           do {
            if ($cmp75$i$i) {
             $child$i$i = ((($add$ptr16$i$i)) + 16|0);
             $arrayidx96$i$i = ((($child$i$i)) + 4|0);
             $159 = HEAP32[$arrayidx96$i$i>>2]|0;
             $cmp97$i$i = ($159|0)==(0|0);
             if ($cmp97$i$i) {
              $160 = HEAP32[$child$i$i>>2]|0;
              $cmp100$i$i = ($160|0)==(0|0);
              if ($cmp100$i$i) {
               $R$3$i$i = 0;
               break;
              } else {
               $R$1$i$i = $160;$RP$1$i$i = $child$i$i;
              }
             } else {
              $R$1$i$i = $159;$RP$1$i$i = $arrayidx96$i$i;
             }
             while(1) {
              $arrayidx103$i$i = ((($R$1$i$i)) + 20|0);
              $161 = HEAP32[$arrayidx103$i$i>>2]|0;
              $cmp104$i$i = ($161|0)==(0|0);
              if (!($cmp104$i$i)) {
               $R$1$i$i = $161;$RP$1$i$i = $arrayidx103$i$i;
               continue;
              }
              $arrayidx107$i$i = ((($R$1$i$i)) + 16|0);
              $162 = HEAP32[$arrayidx107$i$i>>2]|0;
              $cmp108$i$i = ($162|0)==(0|0);
              if ($cmp108$i$i) {
               $R$1$i$i$lcssa = $R$1$i$i;$RP$1$i$i$lcssa = $RP$1$i$i;
               break;
              } else {
               $R$1$i$i = $162;$RP$1$i$i = $arrayidx107$i$i;
              }
             }
             $cmp112$i$i = ($RP$1$i$i$lcssa>>>0)<($150>>>0);
             if ($cmp112$i$i) {
              _abort();
              // unreachable;
             } else {
              HEAP32[$RP$1$i$i$lcssa>>2] = 0;
              $R$3$i$i = $R$1$i$i$lcssa;
              break;
             }
            } else {
             $fd78$i$i = ((($add$ptr16$i$i)) + 8|0);
             $156 = HEAP32[$fd78$i$i>>2]|0;
             $cmp81$i$i = ($156>>>0)<($150>>>0);
             if ($cmp81$i$i) {
              _abort();
              // unreachable;
             }
             $bk82$i$i = ((($156)) + 12|0);
             $157 = HEAP32[$bk82$i$i>>2]|0;
             $cmp83$i$i = ($157|0)==($add$ptr16$i$i|0);
             if (!($cmp83$i$i)) {
              _abort();
              // unreachable;
             }
             $fd85$i$i = ((($155)) + 8|0);
             $158 = HEAP32[$fd85$i$i>>2]|0;
             $cmp86$i$i = ($158|0)==($add$ptr16$i$i|0);
             if ($cmp86$i$i) {
              HEAP32[$bk82$i$i>>2] = $155;
              HEAP32[$fd85$i$i>>2] = $156;
              $R$3$i$i = $155;
              break;
             } else {
              _abort();
              // unreachable;
             }
            }
           } while(0);
           $cmp120$i$53$i = ($154|0)==(0|0);
           if ($cmp120$i$53$i) {
            break;
           }
           $index$i$54$i = ((($add$ptr16$i$i)) + 28|0);
           $163 = HEAP32[$index$i$54$i>>2]|0;
           $arrayidx123$i$i = (480 + ($163<<2)|0);
           $164 = HEAP32[$arrayidx123$i$i>>2]|0;
           $cmp124$i$i = ($add$ptr16$i$i|0)==($164|0);
           do {
            if ($cmp124$i$i) {
             HEAP32[$arrayidx123$i$i>>2] = $R$3$i$i;
             $cond2$i$i = ($R$3$i$i|0)==(0|0);
             if (!($cond2$i$i)) {
              break;
             }
             $shl131$i$i = 1 << $163;
             $neg132$i$i = $shl131$i$i ^ -1;
             $165 = HEAP32[(180)>>2]|0;
             $and133$i$i = $165 & $neg132$i$i;
             HEAP32[(180)>>2] = $and133$i$i;
             break L331;
            } else {
             $166 = HEAP32[(192)>>2]|0;
             $cmp137$i$i = ($154>>>0)<($166>>>0);
             if ($cmp137$i$i) {
              _abort();
              // unreachable;
             }
             $arrayidx143$i$i = ((($154)) + 16|0);
             $167 = HEAP32[$arrayidx143$i$i>>2]|0;
             $cmp144$i$i = ($167|0)==($add$ptr16$i$i|0);
             if ($cmp144$i$i) {
              HEAP32[$arrayidx143$i$i>>2] = $R$3$i$i;
             } else {
              $arrayidx151$i$i = ((($154)) + 20|0);
              HEAP32[$arrayidx151$i$i>>2] = $R$3$i$i;
             }
             $cmp156$i$i = ($R$3$i$i|0)==(0|0);
             if ($cmp156$i$i) {
              break L331;
             }
            }
           } while(0);
           $168 = HEAP32[(192)>>2]|0;
           $cmp160$i$i = ($R$3$i$i>>>0)<($168>>>0);
           if ($cmp160$i$i) {
            _abort();
            // unreachable;
           }
           $parent165$i$i = ((($R$3$i$i)) + 24|0);
           HEAP32[$parent165$i$i>>2] = $154;
           $child166$i$i = ((($add$ptr16$i$i)) + 16|0);
           $169 = HEAP32[$child166$i$i>>2]|0;
           $cmp168$i$i = ($169|0)==(0|0);
           do {
            if (!($cmp168$i$i)) {
             $cmp172$i$i = ($169>>>0)<($168>>>0);
             if ($cmp172$i$i) {
              _abort();
              // unreachable;
             } else {
              $arrayidx178$i$i = ((($R$3$i$i)) + 16|0);
              HEAP32[$arrayidx178$i$i>>2] = $169;
              $parent179$i$i = ((($169)) + 24|0);
              HEAP32[$parent179$i$i>>2] = $R$3$i$i;
              break;
             }
            }
           } while(0);
           $arrayidx184$i$i = ((($child166$i$i)) + 4|0);
           $170 = HEAP32[$arrayidx184$i$i>>2]|0;
           $cmp185$i$i = ($170|0)==(0|0);
           if ($cmp185$i$i) {
            break;
           }
           $171 = HEAP32[(192)>>2]|0;
           $cmp189$i$i = ($170>>>0)<($171>>>0);
           if ($cmp189$i$i) {
            _abort();
            // unreachable;
           } else {
            $arrayidx195$i$i = ((($R$3$i$i)) + 20|0);
            HEAP32[$arrayidx195$i$i>>2] = $170;
            $parent196$i$i = ((($170)) + 24|0);
            HEAP32[$parent196$i$i>>2] = $R$3$i$i;
            break;
           }
          }
         } while(0);
         $add$ptr205$i$i = (($add$ptr16$i$i) + ($and37$i$i)|0);
         $add206$i$i = (($and37$i$i) + ($sub18$i$i))|0;
         $oldfirst$0$i$i = $add$ptr205$i$i;$qsize$0$i$i = $add206$i$i;
        } else {
         $oldfirst$0$i$i = $add$ptr16$i$i;$qsize$0$i$i = $sub18$i$i;
        }
        $head208$i$i = ((($oldfirst$0$i$i)) + 4|0);
        $172 = HEAP32[$head208$i$i>>2]|0;
        $and209$i$i = $172 & -2;
        HEAP32[$head208$i$i>>2] = $and209$i$i;
        $or210$i$i = $qsize$0$i$i | 1;
        $head211$i$i = ((($add$ptr17$i$i)) + 4|0);
        HEAP32[$head211$i$i>>2] = $or210$i$i;
        $add$ptr212$i$i = (($add$ptr17$i$i) + ($qsize$0$i$i)|0);
        HEAP32[$add$ptr212$i$i>>2] = $qsize$0$i$i;
        $shr214$i$i = $qsize$0$i$i >>> 3;
        $cmp215$i$i = ($qsize$0$i$i>>>0)<(256);
        if ($cmp215$i$i) {
         $shl221$i$i = $shr214$i$i << 1;
         $arrayidx223$i$i = (216 + ($shl221$i$i<<2)|0);
         $173 = HEAP32[44]|0;
         $shl226$i$i = 1 << $shr214$i$i;
         $and227$i$i = $173 & $shl226$i$i;
         $tobool228$i$i = ($and227$i$i|0)==(0);
         do {
          if ($tobool228$i$i) {
           $or232$i$i = $173 | $shl226$i$i;
           HEAP32[44] = $or232$i$i;
           $$pre$i$56$i = ((($arrayidx223$i$i)) + 8|0);
           $$pre$phi$i$57$iZ2D = $$pre$i$56$i;$F224$0$i$i = $arrayidx223$i$i;
          } else {
           $174 = ((($arrayidx223$i$i)) + 8|0);
           $175 = HEAP32[$174>>2]|0;
           $176 = HEAP32[(192)>>2]|0;
           $cmp236$i$i = ($175>>>0)<($176>>>0);
           if (!($cmp236$i$i)) {
            $$pre$phi$i$57$iZ2D = $174;$F224$0$i$i = $175;
            break;
           }
           _abort();
           // unreachable;
          }
         } while(0);
         HEAP32[$$pre$phi$i$57$iZ2D>>2] = $add$ptr17$i$i;
         $bk246$i$i = ((($F224$0$i$i)) + 12|0);
         HEAP32[$bk246$i$i>>2] = $add$ptr17$i$i;
         $fd247$i$i = ((($add$ptr17$i$i)) + 8|0);
         HEAP32[$fd247$i$i>>2] = $F224$0$i$i;
         $bk248$i$i = ((($add$ptr17$i$i)) + 12|0);
         HEAP32[$bk248$i$i>>2] = $arrayidx223$i$i;
         break;
        }
        $shr253$i$i = $qsize$0$i$i >>> 8;
        $cmp254$i$i = ($shr253$i$i|0)==(0);
        do {
         if ($cmp254$i$i) {
          $I252$0$i$i = 0;
         } else {
          $cmp258$i$i = ($qsize$0$i$i>>>0)>(16777215);
          if ($cmp258$i$i) {
           $I252$0$i$i = 31;
           break;
          }
          $sub262$i$i = (($shr253$i$i) + 1048320)|0;
          $shr263$i$i = $sub262$i$i >>> 16;
          $and264$i$i = $shr263$i$i & 8;
          $shl265$i$i = $shr253$i$i << $and264$i$i;
          $sub266$i$i = (($shl265$i$i) + 520192)|0;
          $shr267$i$i = $sub266$i$i >>> 16;
          $and268$i$i = $shr267$i$i & 4;
          $add269$i$i = $and268$i$i | $and264$i$i;
          $shl270$i$i = $shl265$i$i << $and268$i$i;
          $sub271$i$i = (($shl270$i$i) + 245760)|0;
          $shr272$i$i = $sub271$i$i >>> 16;
          $and273$i$i = $shr272$i$i & 2;
          $add274$i$i = $add269$i$i | $and273$i$i;
          $sub275$i$i = (14 - ($add274$i$i))|0;
          $shl276$i$i = $shl270$i$i << $and273$i$i;
          $shr277$i$i = $shl276$i$i >>> 15;
          $add278$i$i = (($sub275$i$i) + ($shr277$i$i))|0;
          $shl279$i$i = $add278$i$i << 1;
          $add280$i$i = (($add278$i$i) + 7)|0;
          $shr281$i$i = $qsize$0$i$i >>> $add280$i$i;
          $and282$i$i = $shr281$i$i & 1;
          $add283$i$i = $and282$i$i | $shl279$i$i;
          $I252$0$i$i = $add283$i$i;
         }
        } while(0);
        $arrayidx287$i$i = (480 + ($I252$0$i$i<<2)|0);
        $index288$i$i = ((($add$ptr17$i$i)) + 28|0);
        HEAP32[$index288$i$i>>2] = $I252$0$i$i;
        $child289$i$i = ((($add$ptr17$i$i)) + 16|0);
        $arrayidx290$i$i = ((($child289$i$i)) + 4|0);
        HEAP32[$arrayidx290$i$i>>2] = 0;
        HEAP32[$child289$i$i>>2] = 0;
        $177 = HEAP32[(180)>>2]|0;
        $shl294$i$i = 1 << $I252$0$i$i;
        $and295$i$i = $177 & $shl294$i$i;
        $tobool296$i$i = ($and295$i$i|0)==(0);
        if ($tobool296$i$i) {
         $or300$i$i = $177 | $shl294$i$i;
         HEAP32[(180)>>2] = $or300$i$i;
         HEAP32[$arrayidx287$i$i>>2] = $add$ptr17$i$i;
         $parent301$i$i = ((($add$ptr17$i$i)) + 24|0);
         HEAP32[$parent301$i$i>>2] = $arrayidx287$i$i;
         $bk302$i$i = ((($add$ptr17$i$i)) + 12|0);
         HEAP32[$bk302$i$i>>2] = $add$ptr17$i$i;
         $fd303$i$i = ((($add$ptr17$i$i)) + 8|0);
         HEAP32[$fd303$i$i>>2] = $add$ptr17$i$i;
         break;
        }
        $178 = HEAP32[$arrayidx287$i$i>>2]|0;
        $cmp306$i$i = ($I252$0$i$i|0)==(31);
        $shr310$i$i = $I252$0$i$i >>> 1;
        $sub313$i$i = (25 - ($shr310$i$i))|0;
        $cond315$i$i = $cmp306$i$i ? 0 : $sub313$i$i;
        $shl316$i$i = $qsize$0$i$i << $cond315$i$i;
        $K305$0$i$i = $shl316$i$i;$T$0$i$58$i = $178;
        while(1) {
         $head317$i$i = ((($T$0$i$58$i)) + 4|0);
         $179 = HEAP32[$head317$i$i>>2]|0;
         $and318$i$i = $179 & -8;
         $cmp319$i$i = ($and318$i$i|0)==($qsize$0$i$i|0);
         if ($cmp319$i$i) {
          $T$0$i$58$i$lcssa = $T$0$i$58$i;
          label = 281;
          break;
         }
         $shr322$i$i = $K305$0$i$i >>> 31;
         $arrayidx325$i$i = (((($T$0$i$58$i)) + 16|0) + ($shr322$i$i<<2)|0);
         $shl326$i$i = $K305$0$i$i << 1;
         $180 = HEAP32[$arrayidx325$i$i>>2]|0;
         $cmp327$i$i = ($180|0)==(0|0);
         if ($cmp327$i$i) {
          $T$0$i$58$i$lcssa283 = $T$0$i$58$i;$arrayidx325$i$i$lcssa = $arrayidx325$i$i;
          label = 278;
          break;
         } else {
          $K305$0$i$i = $shl326$i$i;$T$0$i$58$i = $180;
         }
        }
        if ((label|0) == 278) {
         $181 = HEAP32[(192)>>2]|0;
         $cmp332$i$i = ($arrayidx325$i$i$lcssa>>>0)<($181>>>0);
         if ($cmp332$i$i) {
          _abort();
          // unreachable;
         } else {
          HEAP32[$arrayidx325$i$i$lcssa>>2] = $add$ptr17$i$i;
          $parent337$i$i = ((($add$ptr17$i$i)) + 24|0);
          HEAP32[$parent337$i$i>>2] = $T$0$i$58$i$lcssa283;
          $bk338$i$i = ((($add$ptr17$i$i)) + 12|0);
          HEAP32[$bk338$i$i>>2] = $add$ptr17$i$i;
          $fd339$i$i = ((($add$ptr17$i$i)) + 8|0);
          HEAP32[$fd339$i$i>>2] = $add$ptr17$i$i;
          break;
         }
        }
        else if ((label|0) == 281) {
         $fd344$i$i = ((($T$0$i$58$i$lcssa)) + 8|0);
         $182 = HEAP32[$fd344$i$i>>2]|0;
         $183 = HEAP32[(192)>>2]|0;
         $cmp350$i$i = ($182>>>0)>=($183>>>0);
         $not$cmp346$i$i = ($T$0$i$58$i$lcssa>>>0)>=($183>>>0);
         $184 = $cmp350$i$i & $not$cmp346$i$i;
         if ($184) {
          $bk357$i$i = ((($182)) + 12|0);
          HEAP32[$bk357$i$i>>2] = $add$ptr17$i$i;
          HEAP32[$fd344$i$i>>2] = $add$ptr17$i$i;
          $fd359$i$i = ((($add$ptr17$i$i)) + 8|0);
          HEAP32[$fd359$i$i>>2] = $182;
          $bk360$i$i = ((($add$ptr17$i$i)) + 12|0);
          HEAP32[$bk360$i$i>>2] = $T$0$i$58$i$lcssa;
          $parent361$i$i = ((($add$ptr17$i$i)) + 24|0);
          HEAP32[$parent361$i$i>>2] = 0;
          break;
         } else {
          _abort();
          // unreachable;
         }
        }
       }
      } while(0);
      $add$ptr369$i$i = ((($add$ptr4$i$37$i)) + 8|0);
      $retval$0 = $add$ptr369$i$i;
      return ($retval$0|0);
     } else {
      $sp$0$i$i$i = (624);
     }
    }
    while(1) {
     $185 = HEAP32[$sp$0$i$i$i>>2]|0;
     $cmp$i$i$i = ($185>>>0)>($119>>>0);
     if (!($cmp$i$i$i)) {
      $size$i$i$i = ((($sp$0$i$i$i)) + 4|0);
      $186 = HEAP32[$size$i$i$i>>2]|0;
      $add$ptr$i$i$i = (($185) + ($186)|0);
      $cmp2$i$i$i = ($add$ptr$i$i$i>>>0)>($119>>>0);
      if ($cmp2$i$i$i) {
       $add$ptr$i$i$i$lcssa = $add$ptr$i$i$i;
       break;
      }
     }
     $next$i$i$i = ((($sp$0$i$i$i)) + 8|0);
     $187 = HEAP32[$next$i$i$i>>2]|0;
     $sp$0$i$i$i = $187;
    }
    $add$ptr2$i$i = ((($add$ptr$i$i$i$lcssa)) + -47|0);
    $add$ptr3$i$i = ((($add$ptr2$i$i)) + 8|0);
    $188 = $add$ptr3$i$i;
    $and$i$14$i = $188 & 7;
    $cmp$i$15$i = ($and$i$14$i|0)==(0);
    $189 = (0 - ($188))|0;
    $and6$i$i = $189 & 7;
    $cond$i$16$i = $cmp$i$15$i ? 0 : $and6$i$i;
    $add$ptr7$i$i = (($add$ptr2$i$i) + ($cond$i$16$i)|0);
    $add$ptr8$i122$i = ((($119)) + 16|0);
    $cmp9$i$i = ($add$ptr7$i$i>>>0)<($add$ptr8$i122$i>>>0);
    $cond13$i$i = $cmp9$i$i ? $119 : $add$ptr7$i$i;
    $add$ptr14$i$i = ((($cond13$i$i)) + 8|0);
    $add$ptr15$i$i = ((($cond13$i$i)) + 24|0);
    $sub16$i$i = (($tsize$795$i) + -40)|0;
    $add$ptr$i$1$i$i = ((($tbase$796$i)) + 8|0);
    $190 = $add$ptr$i$1$i$i;
    $and$i$i$i = $190 & 7;
    $cmp$i$2$i$i = ($and$i$i$i|0)==(0);
    $191 = (0 - ($190))|0;
    $and3$i$i$i = $191 & 7;
    $cond$i$i$i = $cmp$i$2$i$i ? 0 : $and3$i$i$i;
    $add$ptr4$i$i$i = (($tbase$796$i) + ($cond$i$i$i)|0);
    $sub5$i$i$i = (($sub16$i$i) - ($cond$i$i$i))|0;
    HEAP32[(200)>>2] = $add$ptr4$i$i$i;
    HEAP32[(188)>>2] = $sub5$i$i$i;
    $or$i$i$i = $sub5$i$i$i | 1;
    $head$i$i$i = ((($add$ptr4$i$i$i)) + 4|0);
    HEAP32[$head$i$i$i>>2] = $or$i$i$i;
    $add$ptr6$i$i$i = (($add$ptr4$i$i$i) + ($sub5$i$i$i)|0);
    $head7$i$i$i = ((($add$ptr6$i$i$i)) + 4|0);
    HEAP32[$head7$i$i$i>>2] = 40;
    $192 = HEAP32[(664)>>2]|0;
    HEAP32[(204)>>2] = $192;
    $head$i$17$i = ((($cond13$i$i)) + 4|0);
    HEAP32[$head$i$17$i>>2] = 27;
    ;HEAP32[$add$ptr14$i$i>>2]=HEAP32[(624)>>2]|0;HEAP32[$add$ptr14$i$i+4>>2]=HEAP32[(624)+4>>2]|0;HEAP32[$add$ptr14$i$i+8>>2]=HEAP32[(624)+8>>2]|0;HEAP32[$add$ptr14$i$i+12>>2]=HEAP32[(624)+12>>2]|0;
    HEAP32[(624)>>2] = $tbase$796$i;
    HEAP32[(628)>>2] = $tsize$795$i;
    HEAP32[(636)>>2] = 0;
    HEAP32[(632)>>2] = $add$ptr14$i$i;
    $p$0$i$i = $add$ptr15$i$i;
    while(1) {
     $add$ptr24$i$i = ((($p$0$i$i)) + 4|0);
     HEAP32[$add$ptr24$i$i>>2] = 7;
     $193 = ((($add$ptr24$i$i)) + 4|0);
     $cmp27$i$i = ($193>>>0)<($add$ptr$i$i$i$lcssa>>>0);
     if ($cmp27$i$i) {
      $p$0$i$i = $add$ptr24$i$i;
     } else {
      break;
     }
    }
    $cmp28$i$i = ($cond13$i$i|0)==($119|0);
    if (!($cmp28$i$i)) {
     $sub$ptr$lhs$cast$i$i = $cond13$i$i;
     $sub$ptr$rhs$cast$i$i = $119;
     $sub$ptr$sub$i$i = (($sub$ptr$lhs$cast$i$i) - ($sub$ptr$rhs$cast$i$i))|0;
     $194 = HEAP32[$head$i$17$i>>2]|0;
     $and32$i$i = $194 & -2;
     HEAP32[$head$i$17$i>>2] = $and32$i$i;
     $or33$i$i = $sub$ptr$sub$i$i | 1;
     $head34$i$i = ((($119)) + 4|0);
     HEAP32[$head34$i$i>>2] = $or33$i$i;
     HEAP32[$cond13$i$i>>2] = $sub$ptr$sub$i$i;
     $shr$i$i = $sub$ptr$sub$i$i >>> 3;
     $cmp36$i$i = ($sub$ptr$sub$i$i>>>0)<(256);
     if ($cmp36$i$i) {
      $shl$i$19$i = $shr$i$i << 1;
      $arrayidx$i$20$i = (216 + ($shl$i$19$i<<2)|0);
      $195 = HEAP32[44]|0;
      $shl39$i$i = 1 << $shr$i$i;
      $and40$i$i = $195 & $shl39$i$i;
      $tobool$i$i = ($and40$i$i|0)==(0);
      if ($tobool$i$i) {
       $or44$i$i = $195 | $shl39$i$i;
       HEAP32[44] = $or44$i$i;
       $$pre$i$i = ((($arrayidx$i$20$i)) + 8|0);
       $$pre$phi$i$iZ2D = $$pre$i$i;$F$0$i$i = $arrayidx$i$20$i;
      } else {
       $196 = ((($arrayidx$i$20$i)) + 8|0);
       $197 = HEAP32[$196>>2]|0;
       $198 = HEAP32[(192)>>2]|0;
       $cmp46$i$i = ($197>>>0)<($198>>>0);
       if ($cmp46$i$i) {
        _abort();
        // unreachable;
       } else {
        $$pre$phi$i$iZ2D = $196;$F$0$i$i = $197;
       }
      }
      HEAP32[$$pre$phi$i$iZ2D>>2] = $119;
      $bk$i$i = ((($F$0$i$i)) + 12|0);
      HEAP32[$bk$i$i>>2] = $119;
      $fd54$i$i = ((($119)) + 8|0);
      HEAP32[$fd54$i$i>>2] = $F$0$i$i;
      $bk55$i$i = ((($119)) + 12|0);
      HEAP32[$bk55$i$i>>2] = $arrayidx$i$20$i;
      break;
     }
     $shr58$i$i = $sub$ptr$sub$i$i >>> 8;
     $cmp59$i$i = ($shr58$i$i|0)==(0);
     if ($cmp59$i$i) {
      $I57$0$i$i = 0;
     } else {
      $cmp63$i$i = ($sub$ptr$sub$i$i>>>0)>(16777215);
      if ($cmp63$i$i) {
       $I57$0$i$i = 31;
      } else {
       $sub67$i$i = (($shr58$i$i) + 1048320)|0;
       $shr68$i$i = $sub67$i$i >>> 16;
       $and69$i$i = $shr68$i$i & 8;
       $shl70$i$i = $shr58$i$i << $and69$i$i;
       $sub71$i$i = (($shl70$i$i) + 520192)|0;
       $shr72$i$i = $sub71$i$i >>> 16;
       $and73$i$i = $shr72$i$i & 4;
       $add74$i$i = $and73$i$i | $and69$i$i;
       $shl75$i$i = $shl70$i$i << $and73$i$i;
       $sub76$i$i = (($shl75$i$i) + 245760)|0;
       $shr77$i$i = $sub76$i$i >>> 16;
       $and78$i$i = $shr77$i$i & 2;
       $add79$i$i = $add74$i$i | $and78$i$i;
       $sub80$i$i = (14 - ($add79$i$i))|0;
       $shl81$i$i = $shl75$i$i << $and78$i$i;
       $shr82$i$i = $shl81$i$i >>> 15;
       $add83$i$i = (($sub80$i$i) + ($shr82$i$i))|0;
       $shl84$i$i = $add83$i$i << 1;
       $add85$i$i = (($add83$i$i) + 7)|0;
       $shr86$i$i = $sub$ptr$sub$i$i >>> $add85$i$i;
       $and87$i$i = $shr86$i$i & 1;
       $add88$i$i = $and87$i$i | $shl84$i$i;
       $I57$0$i$i = $add88$i$i;
      }
     }
     $arrayidx91$i$i = (480 + ($I57$0$i$i<<2)|0);
     $index$i$i = ((($119)) + 28|0);
     HEAP32[$index$i$i>>2] = $I57$0$i$i;
     $arrayidx92$i$i = ((($119)) + 20|0);
     HEAP32[$arrayidx92$i$i>>2] = 0;
     HEAP32[$add$ptr8$i122$i>>2] = 0;
     $199 = HEAP32[(180)>>2]|0;
     $shl95$i$i = 1 << $I57$0$i$i;
     $and96$i$i = $199 & $shl95$i$i;
     $tobool97$i$i = ($and96$i$i|0)==(0);
     if ($tobool97$i$i) {
      $or101$i$i = $199 | $shl95$i$i;
      HEAP32[(180)>>2] = $or101$i$i;
      HEAP32[$arrayidx91$i$i>>2] = $119;
      $parent$i$i = ((($119)) + 24|0);
      HEAP32[$parent$i$i>>2] = $arrayidx91$i$i;
      $bk102$i$i = ((($119)) + 12|0);
      HEAP32[$bk102$i$i>>2] = $119;
      $fd103$i$i = ((($119)) + 8|0);
      HEAP32[$fd103$i$i>>2] = $119;
      break;
     }
     $200 = HEAP32[$arrayidx91$i$i>>2]|0;
     $cmp106$i$i = ($I57$0$i$i|0)==(31);
     $shr110$i$i = $I57$0$i$i >>> 1;
     $sub113$i$i = (25 - ($shr110$i$i))|0;
     $cond115$i$i = $cmp106$i$i ? 0 : $sub113$i$i;
     $shl116$i$i = $sub$ptr$sub$i$i << $cond115$i$i;
     $K105$0$i$i = $shl116$i$i;$T$0$i$i = $200;
     while(1) {
      $head118$i$i = ((($T$0$i$i)) + 4|0);
      $201 = HEAP32[$head118$i$i>>2]|0;
      $and119$i$i = $201 & -8;
      $cmp120$i$i = ($and119$i$i|0)==($sub$ptr$sub$i$i|0);
      if ($cmp120$i$i) {
       $T$0$i$i$lcssa = $T$0$i$i;
       label = 307;
       break;
      }
      $shr123$i$i = $K105$0$i$i >>> 31;
      $arrayidx126$i$i = (((($T$0$i$i)) + 16|0) + ($shr123$i$i<<2)|0);
      $shl127$i$i = $K105$0$i$i << 1;
      $202 = HEAP32[$arrayidx126$i$i>>2]|0;
      $cmp128$i$i = ($202|0)==(0|0);
      if ($cmp128$i$i) {
       $T$0$i$i$lcssa284 = $T$0$i$i;$arrayidx126$i$i$lcssa = $arrayidx126$i$i;
       label = 304;
       break;
      } else {
       $K105$0$i$i = $shl127$i$i;$T$0$i$i = $202;
      }
     }
     if ((label|0) == 304) {
      $203 = HEAP32[(192)>>2]|0;
      $cmp133$i$i = ($arrayidx126$i$i$lcssa>>>0)<($203>>>0);
      if ($cmp133$i$i) {
       _abort();
       // unreachable;
      } else {
       HEAP32[$arrayidx126$i$i$lcssa>>2] = $119;
       $parent138$i$i = ((($119)) + 24|0);
       HEAP32[$parent138$i$i>>2] = $T$0$i$i$lcssa284;
       $bk139$i$i = ((($119)) + 12|0);
       HEAP32[$bk139$i$i>>2] = $119;
       $fd140$i$i = ((($119)) + 8|0);
       HEAP32[$fd140$i$i>>2] = $119;
       break;
      }
     }
     else if ((label|0) == 307) {
      $fd148$i$i = ((($T$0$i$i$lcssa)) + 8|0);
      $204 = HEAP32[$fd148$i$i>>2]|0;
      $205 = HEAP32[(192)>>2]|0;
      $cmp153$i$i = ($204>>>0)>=($205>>>0);
      $not$cmp150$i$i = ($T$0$i$i$lcssa>>>0)>=($205>>>0);
      $206 = $cmp153$i$i & $not$cmp150$i$i;
      if ($206) {
       $bk158$i$i = ((($204)) + 12|0);
       HEAP32[$bk158$i$i>>2] = $119;
       HEAP32[$fd148$i$i>>2] = $119;
       $fd160$i$i = ((($119)) + 8|0);
       HEAP32[$fd160$i$i>>2] = $204;
       $bk161$i$i = ((($119)) + 12|0);
       HEAP32[$bk161$i$i>>2] = $T$0$i$i$lcssa;
       $parent162$i$i = ((($119)) + 24|0);
       HEAP32[$parent162$i$i>>2] = 0;
       break;
      } else {
       _abort();
       // unreachable;
      }
     }
    }
   }
  } while(0);
  $207 = HEAP32[(188)>>2]|0;
  $cmp257$i = ($207>>>0)>($nb$0>>>0);
  if ($cmp257$i) {
   $sub260$i = (($207) - ($nb$0))|0;
   HEAP32[(188)>>2] = $sub260$i;
   $208 = HEAP32[(200)>>2]|0;
   $add$ptr262$i = (($208) + ($nb$0)|0);
   HEAP32[(200)>>2] = $add$ptr262$i;
   $or264$i = $sub260$i | 1;
   $head265$i = ((($add$ptr262$i)) + 4|0);
   HEAP32[$head265$i>>2] = $or264$i;
   $or267$i = $nb$0 | 3;
   $head268$i = ((($208)) + 4|0);
   HEAP32[$head268$i>>2] = $or267$i;
   $add$ptr269$i = ((($208)) + 8|0);
   $retval$0 = $add$ptr269$i;
   return ($retval$0|0);
  }
 }
 $call275$i = (___errno_location()|0);
 HEAP32[$call275$i>>2] = 12;
 $retval$0 = 0;
 return ($retval$0|0);
}
function _free($mem) {
 $mem = $mem|0;
 var $$pre = 0, $$pre$phiZ2D = 0, $$pre312 = 0, $$pre313 = 0, $0 = 0, $1 = 0, $10 = 0, $11 = 0, $12 = 0, $13 = 0, $14 = 0, $15 = 0, $16 = 0, $17 = 0, $18 = 0, $19 = 0, $2 = 0, $20 = 0, $21 = 0, $22 = 0;
 var $23 = 0, $24 = 0, $25 = 0, $26 = 0, $27 = 0, $28 = 0, $29 = 0, $3 = 0, $30 = 0, $31 = 0, $32 = 0, $33 = 0, $34 = 0, $35 = 0, $36 = 0, $37 = 0, $38 = 0, $39 = 0, $4 = 0, $40 = 0;
 var $41 = 0, $42 = 0, $43 = 0, $44 = 0, $45 = 0, $46 = 0, $47 = 0, $48 = 0, $49 = 0, $5 = 0, $50 = 0, $51 = 0, $52 = 0, $53 = 0, $54 = 0, $55 = 0, $56 = 0, $57 = 0, $58 = 0, $59 = 0;
 var $6 = 0, $60 = 0, $61 = 0, $62 = 0, $63 = 0, $64 = 0, $65 = 0, $66 = 0, $67 = 0, $68 = 0, $69 = 0, $7 = 0, $70 = 0, $71 = 0, $72 = 0, $73 = 0, $74 = 0, $8 = 0, $9 = 0, $F510$0 = 0;
 var $I534$0 = 0, $K583$0 = 0, $R$1 = 0, $R$1$lcssa = 0, $R$3 = 0, $R332$1 = 0, $R332$1$lcssa = 0, $R332$3 = 0, $RP$1 = 0, $RP$1$lcssa = 0, $RP360$1 = 0, $RP360$1$lcssa = 0, $T$0 = 0, $T$0$lcssa = 0, $T$0$lcssa319 = 0, $add$ptr = 0, $add$ptr16 = 0, $add$ptr217 = 0, $add$ptr261 = 0, $add$ptr482 = 0;
 var $add$ptr498 = 0, $add$ptr6 = 0, $add17 = 0, $add246 = 0, $add258 = 0, $add267 = 0, $add550 = 0, $add555 = 0, $add559 = 0, $add561 = 0, $add564 = 0, $and = 0, $and140 = 0, $and210 = 0, $and215 = 0, $and232 = 0, $and240 = 0, $and266 = 0, $and301 = 0, $and410 = 0;
 var $and46 = 0, $and495 = 0, $and5 = 0, $and512 = 0, $and545 = 0, $and549 = 0, $and554 = 0, $and563 = 0, $and574 = 0, $and592 = 0, $and8 = 0, $arrayidx = 0, $arrayidx108 = 0, $arrayidx113 = 0, $arrayidx130 = 0, $arrayidx149 = 0, $arrayidx157 = 0, $arrayidx182 = 0, $arrayidx188 = 0, $arrayidx198 = 0;
 var $arrayidx279 = 0, $arrayidx362 = 0, $arrayidx374 = 0, $arrayidx379 = 0, $arrayidx400 = 0, $arrayidx419 = 0, $arrayidx427 = 0, $arrayidx454 = 0, $arrayidx460 = 0, $arrayidx470 = 0, $arrayidx509 = 0, $arrayidx567 = 0, $arrayidx570 = 0, $arrayidx599 = 0, $arrayidx599$lcssa = 0, $arrayidx99 = 0, $bk = 0, $bk275 = 0, $bk286 = 0, $bk321 = 0;
 var $bk333 = 0, $bk34 = 0, $bk343 = 0, $bk529 = 0, $bk531 = 0, $bk580 = 0, $bk611 = 0, $bk631 = 0, $bk634 = 0, $bk66 = 0, $bk73 = 0, $bk82 = 0, $child = 0, $child171 = 0, $child361 = 0, $child443 = 0, $child569 = 0, $cmp = 0, $cmp$i = 0, $cmp1 = 0;
 var $cmp100 = 0, $cmp104 = 0, $cmp109 = 0, $cmp114 = 0, $cmp118 = 0, $cmp127 = 0, $cmp13 = 0, $cmp131 = 0, $cmp143 = 0, $cmp150 = 0, $cmp162 = 0, $cmp165 = 0, $cmp173 = 0, $cmp176 = 0, $cmp18 = 0, $cmp189 = 0, $cmp192 = 0, $cmp2 = 0, $cmp211 = 0, $cmp22 = 0;
 var $cmp228 = 0, $cmp243 = 0, $cmp249 = 0, $cmp25 = 0, $cmp255 = 0, $cmp269 = 0, $cmp280 = 0, $cmp283 = 0, $cmp287 = 0, $cmp29 = 0, $cmp296 = 0, $cmp305 = 0, $cmp308 = 0, $cmp31 = 0, $cmp312 = 0, $cmp334 = 0, $cmp340 = 0, $cmp344 = 0, $cmp348 = 0, $cmp35 = 0;
 var $cmp363 = 0, $cmp368 = 0, $cmp375 = 0, $cmp380 = 0, $cmp386 = 0, $cmp395 = 0, $cmp401 = 0, $cmp413 = 0, $cmp42 = 0, $cmp420 = 0, $cmp432 = 0, $cmp435 = 0, $cmp445 = 0, $cmp448 = 0, $cmp461 = 0, $cmp464 = 0, $cmp484 = 0, $cmp50 = 0, $cmp502 = 0, $cmp519 = 0;
 var $cmp53 = 0, $cmp536 = 0, $cmp540 = 0, $cmp57 = 0, $cmp584 = 0, $cmp593 = 0, $cmp601 = 0, $cmp605 = 0, $cmp624 = 0, $cmp640 = 0, $cmp74 = 0, $cmp80 = 0, $cmp83 = 0, $cmp87 = 0, $cond = 0, $cond291 = 0, $cond292 = 0, $dec = 0, $fd = 0, $fd273 = 0;
 var $fd311 = 0, $fd322$pre$phiZ2D = 0, $fd338 = 0, $fd347 = 0, $fd530 = 0, $fd56 = 0, $fd581 = 0, $fd612 = 0, $fd620 = 0, $fd633 = 0, $fd67$pre$phiZ2D = 0, $fd78 = 0, $fd86 = 0, $head = 0, $head209 = 0, $head216 = 0, $head231 = 0, $head248 = 0, $head260 = 0, $head481 = 0;
 var $head497 = 0, $head591 = 0, $idx$neg = 0, $index = 0, $index399 = 0, $index568 = 0, $neg = 0, $neg139 = 0, $neg300 = 0, $neg409 = 0, $next4$i = 0, $not$cmp621 = 0, $or = 0, $or247 = 0, $or259 = 0, $or480 = 0, $or496 = 0, $or516 = 0, $or578 = 0, $p$1 = 0;
 var $parent = 0, $parent170 = 0, $parent183 = 0, $parent199 = 0, $parent331 = 0, $parent442 = 0, $parent455 = 0, $parent471 = 0, $parent579 = 0, $parent610 = 0, $parent635 = 0, $psize$1 = 0, $psize$2 = 0, $shl = 0, $shl138 = 0, $shl278 = 0, $shl299 = 0, $shl408 = 0, $shl45 = 0, $shl508 = 0;
 var $shl511 = 0, $shl546 = 0, $shl551 = 0, $shl557 = 0, $shl560 = 0, $shl573 = 0, $shl590 = 0, $shl600 = 0, $shr = 0, $shr268 = 0, $shr501 = 0, $shr535 = 0, $shr544 = 0, $shr548 = 0, $shr553 = 0, $shr558 = 0, $shr562 = 0, $shr586 = 0, $shr596 = 0, $sp$0$i = 0;
 var $sp$0$in$i = 0, $sub = 0, $sub547 = 0, $sub552 = 0, $sub556 = 0, $sub589 = 0, $tobool233 = 0, $tobool241 = 0, $tobool513 = 0, $tobool575 = 0, $tobool9 = 0, label = 0, sp = 0;
 sp = STACKTOP;
 $cmp = ($mem|0)==(0|0);
 if ($cmp) {
  return;
 }
 $add$ptr = ((($mem)) + -8|0);
 $0 = HEAP32[(192)>>2]|0;
 $cmp1 = ($add$ptr>>>0)<($0>>>0);
 if ($cmp1) {
  _abort();
  // unreachable;
 }
 $head = ((($mem)) + -4|0);
 $1 = HEAP32[$head>>2]|0;
 $and = $1 & 3;
 $cmp2 = ($and|0)==(1);
 if ($cmp2) {
  _abort();
  // unreachable;
 }
 $and5 = $1 & -8;
 $add$ptr6 = (($add$ptr) + ($and5)|0);
 $and8 = $1 & 1;
 $tobool9 = ($and8|0)==(0);
 do {
  if ($tobool9) {
   $2 = HEAP32[$add$ptr>>2]|0;
   $cmp13 = ($and|0)==(0);
   if ($cmp13) {
    return;
   }
   $idx$neg = (0 - ($2))|0;
   $add$ptr16 = (($add$ptr) + ($idx$neg)|0);
   $add17 = (($2) + ($and5))|0;
   $cmp18 = ($add$ptr16>>>0)<($0>>>0);
   if ($cmp18) {
    _abort();
    // unreachable;
   }
   $3 = HEAP32[(196)>>2]|0;
   $cmp22 = ($add$ptr16|0)==($3|0);
   if ($cmp22) {
    $head209 = ((($add$ptr6)) + 4|0);
    $27 = HEAP32[$head209>>2]|0;
    $and210 = $27 & 3;
    $cmp211 = ($and210|0)==(3);
    if (!($cmp211)) {
     $p$1 = $add$ptr16;$psize$1 = $add17;
     break;
    }
    HEAP32[(184)>>2] = $add17;
    $and215 = $27 & -2;
    HEAP32[$head209>>2] = $and215;
    $or = $add17 | 1;
    $head216 = ((($add$ptr16)) + 4|0);
    HEAP32[$head216>>2] = $or;
    $add$ptr217 = (($add$ptr16) + ($add17)|0);
    HEAP32[$add$ptr217>>2] = $add17;
    return;
   }
   $shr = $2 >>> 3;
   $cmp25 = ($2>>>0)<(256);
   if ($cmp25) {
    $fd = ((($add$ptr16)) + 8|0);
    $4 = HEAP32[$fd>>2]|0;
    $bk = ((($add$ptr16)) + 12|0);
    $5 = HEAP32[$bk>>2]|0;
    $shl = $shr << 1;
    $arrayidx = (216 + ($shl<<2)|0);
    $cmp29 = ($4|0)==($arrayidx|0);
    if (!($cmp29)) {
     $cmp31 = ($4>>>0)<($0>>>0);
     if ($cmp31) {
      _abort();
      // unreachable;
     }
     $bk34 = ((($4)) + 12|0);
     $6 = HEAP32[$bk34>>2]|0;
     $cmp35 = ($6|0)==($add$ptr16|0);
     if (!($cmp35)) {
      _abort();
      // unreachable;
     }
    }
    $cmp42 = ($5|0)==($4|0);
    if ($cmp42) {
     $shl45 = 1 << $shr;
     $neg = $shl45 ^ -1;
     $7 = HEAP32[44]|0;
     $and46 = $7 & $neg;
     HEAP32[44] = $and46;
     $p$1 = $add$ptr16;$psize$1 = $add17;
     break;
    }
    $cmp50 = ($5|0)==($arrayidx|0);
    if ($cmp50) {
     $$pre313 = ((($5)) + 8|0);
     $fd67$pre$phiZ2D = $$pre313;
    } else {
     $cmp53 = ($5>>>0)<($0>>>0);
     if ($cmp53) {
      _abort();
      // unreachable;
     }
     $fd56 = ((($5)) + 8|0);
     $8 = HEAP32[$fd56>>2]|0;
     $cmp57 = ($8|0)==($add$ptr16|0);
     if ($cmp57) {
      $fd67$pre$phiZ2D = $fd56;
     } else {
      _abort();
      // unreachable;
     }
    }
    $bk66 = ((($4)) + 12|0);
    HEAP32[$bk66>>2] = $5;
    HEAP32[$fd67$pre$phiZ2D>>2] = $4;
    $p$1 = $add$ptr16;$psize$1 = $add17;
    break;
   }
   $parent = ((($add$ptr16)) + 24|0);
   $9 = HEAP32[$parent>>2]|0;
   $bk73 = ((($add$ptr16)) + 12|0);
   $10 = HEAP32[$bk73>>2]|0;
   $cmp74 = ($10|0)==($add$ptr16|0);
   do {
    if ($cmp74) {
     $child = ((($add$ptr16)) + 16|0);
     $arrayidx99 = ((($child)) + 4|0);
     $14 = HEAP32[$arrayidx99>>2]|0;
     $cmp100 = ($14|0)==(0|0);
     if ($cmp100) {
      $15 = HEAP32[$child>>2]|0;
      $cmp104 = ($15|0)==(0|0);
      if ($cmp104) {
       $R$3 = 0;
       break;
      } else {
       $R$1 = $15;$RP$1 = $child;
      }
     } else {
      $R$1 = $14;$RP$1 = $arrayidx99;
     }
     while(1) {
      $arrayidx108 = ((($R$1)) + 20|0);
      $16 = HEAP32[$arrayidx108>>2]|0;
      $cmp109 = ($16|0)==(0|0);
      if (!($cmp109)) {
       $R$1 = $16;$RP$1 = $arrayidx108;
       continue;
      }
      $arrayidx113 = ((($R$1)) + 16|0);
      $17 = HEAP32[$arrayidx113>>2]|0;
      $cmp114 = ($17|0)==(0|0);
      if ($cmp114) {
       $R$1$lcssa = $R$1;$RP$1$lcssa = $RP$1;
       break;
      } else {
       $R$1 = $17;$RP$1 = $arrayidx113;
      }
     }
     $cmp118 = ($RP$1$lcssa>>>0)<($0>>>0);
     if ($cmp118) {
      _abort();
      // unreachable;
     } else {
      HEAP32[$RP$1$lcssa>>2] = 0;
      $R$3 = $R$1$lcssa;
      break;
     }
    } else {
     $fd78 = ((($add$ptr16)) + 8|0);
     $11 = HEAP32[$fd78>>2]|0;
     $cmp80 = ($11>>>0)<($0>>>0);
     if ($cmp80) {
      _abort();
      // unreachable;
     }
     $bk82 = ((($11)) + 12|0);
     $12 = HEAP32[$bk82>>2]|0;
     $cmp83 = ($12|0)==($add$ptr16|0);
     if (!($cmp83)) {
      _abort();
      // unreachable;
     }
     $fd86 = ((($10)) + 8|0);
     $13 = HEAP32[$fd86>>2]|0;
     $cmp87 = ($13|0)==($add$ptr16|0);
     if ($cmp87) {
      HEAP32[$bk82>>2] = $10;
      HEAP32[$fd86>>2] = $11;
      $R$3 = $10;
      break;
     } else {
      _abort();
      // unreachable;
     }
    }
   } while(0);
   $cmp127 = ($9|0)==(0|0);
   if ($cmp127) {
    $p$1 = $add$ptr16;$psize$1 = $add17;
   } else {
    $index = ((($add$ptr16)) + 28|0);
    $18 = HEAP32[$index>>2]|0;
    $arrayidx130 = (480 + ($18<<2)|0);
    $19 = HEAP32[$arrayidx130>>2]|0;
    $cmp131 = ($add$ptr16|0)==($19|0);
    if ($cmp131) {
     HEAP32[$arrayidx130>>2] = $R$3;
     $cond291 = ($R$3|0)==(0|0);
     if ($cond291) {
      $shl138 = 1 << $18;
      $neg139 = $shl138 ^ -1;
      $20 = HEAP32[(180)>>2]|0;
      $and140 = $20 & $neg139;
      HEAP32[(180)>>2] = $and140;
      $p$1 = $add$ptr16;$psize$1 = $add17;
      break;
     }
    } else {
     $21 = HEAP32[(192)>>2]|0;
     $cmp143 = ($9>>>0)<($21>>>0);
     if ($cmp143) {
      _abort();
      // unreachable;
     }
     $arrayidx149 = ((($9)) + 16|0);
     $22 = HEAP32[$arrayidx149>>2]|0;
     $cmp150 = ($22|0)==($add$ptr16|0);
     if ($cmp150) {
      HEAP32[$arrayidx149>>2] = $R$3;
     } else {
      $arrayidx157 = ((($9)) + 20|0);
      HEAP32[$arrayidx157>>2] = $R$3;
     }
     $cmp162 = ($R$3|0)==(0|0);
     if ($cmp162) {
      $p$1 = $add$ptr16;$psize$1 = $add17;
      break;
     }
    }
    $23 = HEAP32[(192)>>2]|0;
    $cmp165 = ($R$3>>>0)<($23>>>0);
    if ($cmp165) {
     _abort();
     // unreachable;
    }
    $parent170 = ((($R$3)) + 24|0);
    HEAP32[$parent170>>2] = $9;
    $child171 = ((($add$ptr16)) + 16|0);
    $24 = HEAP32[$child171>>2]|0;
    $cmp173 = ($24|0)==(0|0);
    do {
     if (!($cmp173)) {
      $cmp176 = ($24>>>0)<($23>>>0);
      if ($cmp176) {
       _abort();
       // unreachable;
      } else {
       $arrayidx182 = ((($R$3)) + 16|0);
       HEAP32[$arrayidx182>>2] = $24;
       $parent183 = ((($24)) + 24|0);
       HEAP32[$parent183>>2] = $R$3;
       break;
      }
     }
    } while(0);
    $arrayidx188 = ((($child171)) + 4|0);
    $25 = HEAP32[$arrayidx188>>2]|0;
    $cmp189 = ($25|0)==(0|0);
    if ($cmp189) {
     $p$1 = $add$ptr16;$psize$1 = $add17;
    } else {
     $26 = HEAP32[(192)>>2]|0;
     $cmp192 = ($25>>>0)<($26>>>0);
     if ($cmp192) {
      _abort();
      // unreachable;
     } else {
      $arrayidx198 = ((($R$3)) + 20|0);
      HEAP32[$arrayidx198>>2] = $25;
      $parent199 = ((($25)) + 24|0);
      HEAP32[$parent199>>2] = $R$3;
      $p$1 = $add$ptr16;$psize$1 = $add17;
      break;
     }
    }
   }
  } else {
   $p$1 = $add$ptr;$psize$1 = $and5;
  }
 } while(0);
 $cmp228 = ($p$1>>>0)<($add$ptr6>>>0);
 if (!($cmp228)) {
  _abort();
  // unreachable;
 }
 $head231 = ((($add$ptr6)) + 4|0);
 $28 = HEAP32[$head231>>2]|0;
 $and232 = $28 & 1;
 $tobool233 = ($and232|0)==(0);
 if ($tobool233) {
  _abort();
  // unreachable;
 }
 $and240 = $28 & 2;
 $tobool241 = ($and240|0)==(0);
 if ($tobool241) {
  $29 = HEAP32[(200)>>2]|0;
  $cmp243 = ($add$ptr6|0)==($29|0);
  if ($cmp243) {
   $30 = HEAP32[(188)>>2]|0;
   $add246 = (($30) + ($psize$1))|0;
   HEAP32[(188)>>2] = $add246;
   HEAP32[(200)>>2] = $p$1;
   $or247 = $add246 | 1;
   $head248 = ((($p$1)) + 4|0);
   HEAP32[$head248>>2] = $or247;
   $31 = HEAP32[(196)>>2]|0;
   $cmp249 = ($p$1|0)==($31|0);
   if (!($cmp249)) {
    return;
   }
   HEAP32[(196)>>2] = 0;
   HEAP32[(184)>>2] = 0;
   return;
  }
  $32 = HEAP32[(196)>>2]|0;
  $cmp255 = ($add$ptr6|0)==($32|0);
  if ($cmp255) {
   $33 = HEAP32[(184)>>2]|0;
   $add258 = (($33) + ($psize$1))|0;
   HEAP32[(184)>>2] = $add258;
   HEAP32[(196)>>2] = $p$1;
   $or259 = $add258 | 1;
   $head260 = ((($p$1)) + 4|0);
   HEAP32[$head260>>2] = $or259;
   $add$ptr261 = (($p$1) + ($add258)|0);
   HEAP32[$add$ptr261>>2] = $add258;
   return;
  }
  $and266 = $28 & -8;
  $add267 = (($and266) + ($psize$1))|0;
  $shr268 = $28 >>> 3;
  $cmp269 = ($28>>>0)<(256);
  do {
   if ($cmp269) {
    $fd273 = ((($add$ptr6)) + 8|0);
    $34 = HEAP32[$fd273>>2]|0;
    $bk275 = ((($add$ptr6)) + 12|0);
    $35 = HEAP32[$bk275>>2]|0;
    $shl278 = $shr268 << 1;
    $arrayidx279 = (216 + ($shl278<<2)|0);
    $cmp280 = ($34|0)==($arrayidx279|0);
    if (!($cmp280)) {
     $36 = HEAP32[(192)>>2]|0;
     $cmp283 = ($34>>>0)<($36>>>0);
     if ($cmp283) {
      _abort();
      // unreachable;
     }
     $bk286 = ((($34)) + 12|0);
     $37 = HEAP32[$bk286>>2]|0;
     $cmp287 = ($37|0)==($add$ptr6|0);
     if (!($cmp287)) {
      _abort();
      // unreachable;
     }
    }
    $cmp296 = ($35|0)==($34|0);
    if ($cmp296) {
     $shl299 = 1 << $shr268;
     $neg300 = $shl299 ^ -1;
     $38 = HEAP32[44]|0;
     $and301 = $38 & $neg300;
     HEAP32[44] = $and301;
     break;
    }
    $cmp305 = ($35|0)==($arrayidx279|0);
    if ($cmp305) {
     $$pre312 = ((($35)) + 8|0);
     $fd322$pre$phiZ2D = $$pre312;
    } else {
     $39 = HEAP32[(192)>>2]|0;
     $cmp308 = ($35>>>0)<($39>>>0);
     if ($cmp308) {
      _abort();
      // unreachable;
     }
     $fd311 = ((($35)) + 8|0);
     $40 = HEAP32[$fd311>>2]|0;
     $cmp312 = ($40|0)==($add$ptr6|0);
     if ($cmp312) {
      $fd322$pre$phiZ2D = $fd311;
     } else {
      _abort();
      // unreachable;
     }
    }
    $bk321 = ((($34)) + 12|0);
    HEAP32[$bk321>>2] = $35;
    HEAP32[$fd322$pre$phiZ2D>>2] = $34;
   } else {
    $parent331 = ((($add$ptr6)) + 24|0);
    $41 = HEAP32[$parent331>>2]|0;
    $bk333 = ((($add$ptr6)) + 12|0);
    $42 = HEAP32[$bk333>>2]|0;
    $cmp334 = ($42|0)==($add$ptr6|0);
    do {
     if ($cmp334) {
      $child361 = ((($add$ptr6)) + 16|0);
      $arrayidx362 = ((($child361)) + 4|0);
      $47 = HEAP32[$arrayidx362>>2]|0;
      $cmp363 = ($47|0)==(0|0);
      if ($cmp363) {
       $48 = HEAP32[$child361>>2]|0;
       $cmp368 = ($48|0)==(0|0);
       if ($cmp368) {
        $R332$3 = 0;
        break;
       } else {
        $R332$1 = $48;$RP360$1 = $child361;
       }
      } else {
       $R332$1 = $47;$RP360$1 = $arrayidx362;
      }
      while(1) {
       $arrayidx374 = ((($R332$1)) + 20|0);
       $49 = HEAP32[$arrayidx374>>2]|0;
       $cmp375 = ($49|0)==(0|0);
       if (!($cmp375)) {
        $R332$1 = $49;$RP360$1 = $arrayidx374;
        continue;
       }
       $arrayidx379 = ((($R332$1)) + 16|0);
       $50 = HEAP32[$arrayidx379>>2]|0;
       $cmp380 = ($50|0)==(0|0);
       if ($cmp380) {
        $R332$1$lcssa = $R332$1;$RP360$1$lcssa = $RP360$1;
        break;
       } else {
        $R332$1 = $50;$RP360$1 = $arrayidx379;
       }
      }
      $51 = HEAP32[(192)>>2]|0;
      $cmp386 = ($RP360$1$lcssa>>>0)<($51>>>0);
      if ($cmp386) {
       _abort();
       // unreachable;
      } else {
       HEAP32[$RP360$1$lcssa>>2] = 0;
       $R332$3 = $R332$1$lcssa;
       break;
      }
     } else {
      $fd338 = ((($add$ptr6)) + 8|0);
      $43 = HEAP32[$fd338>>2]|0;
      $44 = HEAP32[(192)>>2]|0;
      $cmp340 = ($43>>>0)<($44>>>0);
      if ($cmp340) {
       _abort();
       // unreachable;
      }
      $bk343 = ((($43)) + 12|0);
      $45 = HEAP32[$bk343>>2]|0;
      $cmp344 = ($45|0)==($add$ptr6|0);
      if (!($cmp344)) {
       _abort();
       // unreachable;
      }
      $fd347 = ((($42)) + 8|0);
      $46 = HEAP32[$fd347>>2]|0;
      $cmp348 = ($46|0)==($add$ptr6|0);
      if ($cmp348) {
       HEAP32[$bk343>>2] = $42;
       HEAP32[$fd347>>2] = $43;
       $R332$3 = $42;
       break;
      } else {
       _abort();
       // unreachable;
      }
     }
    } while(0);
    $cmp395 = ($41|0)==(0|0);
    if (!($cmp395)) {
     $index399 = ((($add$ptr6)) + 28|0);
     $52 = HEAP32[$index399>>2]|0;
     $arrayidx400 = (480 + ($52<<2)|0);
     $53 = HEAP32[$arrayidx400>>2]|0;
     $cmp401 = ($add$ptr6|0)==($53|0);
     if ($cmp401) {
      HEAP32[$arrayidx400>>2] = $R332$3;
      $cond292 = ($R332$3|0)==(0|0);
      if ($cond292) {
       $shl408 = 1 << $52;
       $neg409 = $shl408 ^ -1;
       $54 = HEAP32[(180)>>2]|0;
       $and410 = $54 & $neg409;
       HEAP32[(180)>>2] = $and410;
       break;
      }
     } else {
      $55 = HEAP32[(192)>>2]|0;
      $cmp413 = ($41>>>0)<($55>>>0);
      if ($cmp413) {
       _abort();
       // unreachable;
      }
      $arrayidx419 = ((($41)) + 16|0);
      $56 = HEAP32[$arrayidx419>>2]|0;
      $cmp420 = ($56|0)==($add$ptr6|0);
      if ($cmp420) {
       HEAP32[$arrayidx419>>2] = $R332$3;
      } else {
       $arrayidx427 = ((($41)) + 20|0);
       HEAP32[$arrayidx427>>2] = $R332$3;
      }
      $cmp432 = ($R332$3|0)==(0|0);
      if ($cmp432) {
       break;
      }
     }
     $57 = HEAP32[(192)>>2]|0;
     $cmp435 = ($R332$3>>>0)<($57>>>0);
     if ($cmp435) {
      _abort();
      // unreachable;
     }
     $parent442 = ((($R332$3)) + 24|0);
     HEAP32[$parent442>>2] = $41;
     $child443 = ((($add$ptr6)) + 16|0);
     $58 = HEAP32[$child443>>2]|0;
     $cmp445 = ($58|0)==(0|0);
     do {
      if (!($cmp445)) {
       $cmp448 = ($58>>>0)<($57>>>0);
       if ($cmp448) {
        _abort();
        // unreachable;
       } else {
        $arrayidx454 = ((($R332$3)) + 16|0);
        HEAP32[$arrayidx454>>2] = $58;
        $parent455 = ((($58)) + 24|0);
        HEAP32[$parent455>>2] = $R332$3;
        break;
       }
      }
     } while(0);
     $arrayidx460 = ((($child443)) + 4|0);
     $59 = HEAP32[$arrayidx460>>2]|0;
     $cmp461 = ($59|0)==(0|0);
     if (!($cmp461)) {
      $60 = HEAP32[(192)>>2]|0;
      $cmp464 = ($59>>>0)<($60>>>0);
      if ($cmp464) {
       _abort();
       // unreachable;
      } else {
       $arrayidx470 = ((($R332$3)) + 20|0);
       HEAP32[$arrayidx470>>2] = $59;
       $parent471 = ((($59)) + 24|0);
       HEAP32[$parent471>>2] = $R332$3;
       break;
      }
     }
    }
   }
  } while(0);
  $or480 = $add267 | 1;
  $head481 = ((($p$1)) + 4|0);
  HEAP32[$head481>>2] = $or480;
  $add$ptr482 = (($p$1) + ($add267)|0);
  HEAP32[$add$ptr482>>2] = $add267;
  $61 = HEAP32[(196)>>2]|0;
  $cmp484 = ($p$1|0)==($61|0);
  if ($cmp484) {
   HEAP32[(184)>>2] = $add267;
   return;
  } else {
   $psize$2 = $add267;
  }
 } else {
  $and495 = $28 & -2;
  HEAP32[$head231>>2] = $and495;
  $or496 = $psize$1 | 1;
  $head497 = ((($p$1)) + 4|0);
  HEAP32[$head497>>2] = $or496;
  $add$ptr498 = (($p$1) + ($psize$1)|0);
  HEAP32[$add$ptr498>>2] = $psize$1;
  $psize$2 = $psize$1;
 }
 $shr501 = $psize$2 >>> 3;
 $cmp502 = ($psize$2>>>0)<(256);
 if ($cmp502) {
  $shl508 = $shr501 << 1;
  $arrayidx509 = (216 + ($shl508<<2)|0);
  $62 = HEAP32[44]|0;
  $shl511 = 1 << $shr501;
  $and512 = $62 & $shl511;
  $tobool513 = ($and512|0)==(0);
  if ($tobool513) {
   $or516 = $62 | $shl511;
   HEAP32[44] = $or516;
   $$pre = ((($arrayidx509)) + 8|0);
   $$pre$phiZ2D = $$pre;$F510$0 = $arrayidx509;
  } else {
   $63 = ((($arrayidx509)) + 8|0);
   $64 = HEAP32[$63>>2]|0;
   $65 = HEAP32[(192)>>2]|0;
   $cmp519 = ($64>>>0)<($65>>>0);
   if ($cmp519) {
    _abort();
    // unreachable;
   } else {
    $$pre$phiZ2D = $63;$F510$0 = $64;
   }
  }
  HEAP32[$$pre$phiZ2D>>2] = $p$1;
  $bk529 = ((($F510$0)) + 12|0);
  HEAP32[$bk529>>2] = $p$1;
  $fd530 = ((($p$1)) + 8|0);
  HEAP32[$fd530>>2] = $F510$0;
  $bk531 = ((($p$1)) + 12|0);
  HEAP32[$bk531>>2] = $arrayidx509;
  return;
 }
 $shr535 = $psize$2 >>> 8;
 $cmp536 = ($shr535|0)==(0);
 if ($cmp536) {
  $I534$0 = 0;
 } else {
  $cmp540 = ($psize$2>>>0)>(16777215);
  if ($cmp540) {
   $I534$0 = 31;
  } else {
   $sub = (($shr535) + 1048320)|0;
   $shr544 = $sub >>> 16;
   $and545 = $shr544 & 8;
   $shl546 = $shr535 << $and545;
   $sub547 = (($shl546) + 520192)|0;
   $shr548 = $sub547 >>> 16;
   $and549 = $shr548 & 4;
   $add550 = $and549 | $and545;
   $shl551 = $shl546 << $and549;
   $sub552 = (($shl551) + 245760)|0;
   $shr553 = $sub552 >>> 16;
   $and554 = $shr553 & 2;
   $add555 = $add550 | $and554;
   $sub556 = (14 - ($add555))|0;
   $shl557 = $shl551 << $and554;
   $shr558 = $shl557 >>> 15;
   $add559 = (($sub556) + ($shr558))|0;
   $shl560 = $add559 << 1;
   $add561 = (($add559) + 7)|0;
   $shr562 = $psize$2 >>> $add561;
   $and563 = $shr562 & 1;
   $add564 = $and563 | $shl560;
   $I534$0 = $add564;
  }
 }
 $arrayidx567 = (480 + ($I534$0<<2)|0);
 $index568 = ((($p$1)) + 28|0);
 HEAP32[$index568>>2] = $I534$0;
 $child569 = ((($p$1)) + 16|0);
 $arrayidx570 = ((($p$1)) + 20|0);
 HEAP32[$arrayidx570>>2] = 0;
 HEAP32[$child569>>2] = 0;
 $66 = HEAP32[(180)>>2]|0;
 $shl573 = 1 << $I534$0;
 $and574 = $66 & $shl573;
 $tobool575 = ($and574|0)==(0);
 do {
  if ($tobool575) {
   $or578 = $66 | $shl573;
   HEAP32[(180)>>2] = $or578;
   HEAP32[$arrayidx567>>2] = $p$1;
   $parent579 = ((($p$1)) + 24|0);
   HEAP32[$parent579>>2] = $arrayidx567;
   $bk580 = ((($p$1)) + 12|0);
   HEAP32[$bk580>>2] = $p$1;
   $fd581 = ((($p$1)) + 8|0);
   HEAP32[$fd581>>2] = $p$1;
  } else {
   $67 = HEAP32[$arrayidx567>>2]|0;
   $cmp584 = ($I534$0|0)==(31);
   $shr586 = $I534$0 >>> 1;
   $sub589 = (25 - ($shr586))|0;
   $cond = $cmp584 ? 0 : $sub589;
   $shl590 = $psize$2 << $cond;
   $K583$0 = $shl590;$T$0 = $67;
   while(1) {
    $head591 = ((($T$0)) + 4|0);
    $68 = HEAP32[$head591>>2]|0;
    $and592 = $68 & -8;
    $cmp593 = ($and592|0)==($psize$2|0);
    if ($cmp593) {
     $T$0$lcssa = $T$0;
     label = 130;
     break;
    }
    $shr596 = $K583$0 >>> 31;
    $arrayidx599 = (((($T$0)) + 16|0) + ($shr596<<2)|0);
    $shl600 = $K583$0 << 1;
    $69 = HEAP32[$arrayidx599>>2]|0;
    $cmp601 = ($69|0)==(0|0);
    if ($cmp601) {
     $T$0$lcssa319 = $T$0;$arrayidx599$lcssa = $arrayidx599;
     label = 127;
     break;
    } else {
     $K583$0 = $shl600;$T$0 = $69;
    }
   }
   if ((label|0) == 127) {
    $70 = HEAP32[(192)>>2]|0;
    $cmp605 = ($arrayidx599$lcssa>>>0)<($70>>>0);
    if ($cmp605) {
     _abort();
     // unreachable;
    } else {
     HEAP32[$arrayidx599$lcssa>>2] = $p$1;
     $parent610 = ((($p$1)) + 24|0);
     HEAP32[$parent610>>2] = $T$0$lcssa319;
     $bk611 = ((($p$1)) + 12|0);
     HEAP32[$bk611>>2] = $p$1;
     $fd612 = ((($p$1)) + 8|0);
     HEAP32[$fd612>>2] = $p$1;
     break;
    }
   }
   else if ((label|0) == 130) {
    $fd620 = ((($T$0$lcssa)) + 8|0);
    $71 = HEAP32[$fd620>>2]|0;
    $72 = HEAP32[(192)>>2]|0;
    $cmp624 = ($71>>>0)>=($72>>>0);
    $not$cmp621 = ($T$0$lcssa>>>0)>=($72>>>0);
    $73 = $cmp624 & $not$cmp621;
    if ($73) {
     $bk631 = ((($71)) + 12|0);
     HEAP32[$bk631>>2] = $p$1;
     HEAP32[$fd620>>2] = $p$1;
     $fd633 = ((($p$1)) + 8|0);
     HEAP32[$fd633>>2] = $71;
     $bk634 = ((($p$1)) + 12|0);
     HEAP32[$bk634>>2] = $T$0$lcssa;
     $parent635 = ((($p$1)) + 24|0);
     HEAP32[$parent635>>2] = 0;
     break;
    } else {
     _abort();
     // unreachable;
    }
   }
  }
 } while(0);
 $74 = HEAP32[(208)>>2]|0;
 $dec = (($74) + -1)|0;
 HEAP32[(208)>>2] = $dec;
 $cmp640 = ($dec|0)==(0);
 if ($cmp640) {
  $sp$0$in$i = (632);
 } else {
  return;
 }
 while(1) {
  $sp$0$i = HEAP32[$sp$0$in$i>>2]|0;
  $cmp$i = ($sp$0$i|0)==(0|0);
  $next4$i = ((($sp$0$i)) + 8|0);
  if ($cmp$i) {
   break;
  } else {
   $sp$0$in$i = $next4$i;
  }
 }
 HEAP32[(208)>>2] = -1;
 return;
}
function runPostSets() {
}
function _i64Subtract(a, b, c, d) {
    a = a|0; b = b|0; c = c|0; d = d|0;
    var l = 0, h = 0;
    l = (a - c)>>>0;
    h = (b - d)>>>0;
    h = (b - d - (((c>>>0) > (a>>>0))|0))>>>0; // Borrow one from high word to low word on underflow.
    return ((tempRet0 = h,l|0)|0);
}
function _i64Add(a, b, c, d) {
    /*
      x = a + b*2^32
      y = c + d*2^32
      result = l + h*2^32
    */
    a = a|0; b = b|0; c = c|0; d = d|0;
    var l = 0, h = 0;
    l = (a + c)>>>0;
    h = (b + d + (((l>>>0) < (a>>>0))|0))>>>0; // Add carry from low word to high word on overflow.
    return ((tempRet0 = h,l|0)|0);
}
function _memset(ptr, value, num) {
    ptr = ptr|0; value = value|0; num = num|0;
    var stop = 0, value4 = 0, stop4 = 0, unaligned = 0;
    stop = (ptr + num)|0;
    if ((num|0) >= 20) {
      // This is unaligned, but quite large, so work hard to get to aligned settings
      value = value & 0xff;
      unaligned = ptr & 3;
      value4 = value | (value << 8) | (value << 16) | (value << 24);
      stop4 = stop & ~3;
      if (unaligned) {
        unaligned = (ptr + 4 - unaligned)|0;
        while ((ptr|0) < (unaligned|0)) { // no need to check for stop, since we have large num
          HEAP8[((ptr)>>0)]=value;
          ptr = (ptr+1)|0;
        }
      }
      while ((ptr|0) < (stop4|0)) {
        HEAP32[((ptr)>>2)]=value4;
        ptr = (ptr+4)|0;
      }
    }
    while ((ptr|0) < (stop|0)) {
      HEAP8[((ptr)>>0)]=value;
      ptr = (ptr+1)|0;
    }
    return (ptr-num)|0;
}
function _bitshift64Lshr(low, high, bits) {
    low = low|0; high = high|0; bits = bits|0;
    var ander = 0;
    if ((bits|0) < 32) {
      ander = ((1 << bits) - 1)|0;
      tempRet0 = high >>> bits;
      return (low >>> bits) | ((high&ander) << (32 - bits));
    }
    tempRet0 = 0;
    return (high >>> (bits - 32))|0;
}
function _bitshift64Shl(low, high, bits) {
    low = low|0; high = high|0; bits = bits|0;
    var ander = 0;
    if ((bits|0) < 32) {
      ander = ((1 << bits) - 1)|0;
      tempRet0 = (high << bits) | ((low&(ander << (32 - bits))) >>> (32 - bits));
      return low << bits;
    }
    tempRet0 = low << (bits - 32);
    return 0;
}
function _memcpy(dest, src, num) {
    dest = dest|0; src = src|0; num = num|0;
    var ret = 0;
    if ((num|0) >= 4096) return _emscripten_memcpy_big(dest|0, src|0, num|0)|0;
    ret = dest|0;
    if ((dest&3) == (src&3)) {
      while (dest & 3) {
        if ((num|0) == 0) return ret|0;
        HEAP8[((dest)>>0)]=((HEAP8[((src)>>0)])|0);
        dest = (dest+1)|0;
        src = (src+1)|0;
        num = (num-1)|0;
      }
      while ((num|0) >= 4) {
        HEAP32[((dest)>>2)]=((HEAP32[((src)>>2)])|0);
        dest = (dest+4)|0;
        src = (src+4)|0;
        num = (num-4)|0;
      }
    }
    while ((num|0) > 0) {
      HEAP8[((dest)>>0)]=((HEAP8[((src)>>0)])|0);
      dest = (dest+1)|0;
      src = (src+1)|0;
      num = (num-1)|0;
    }
    return ret|0;
}
function _bitshift64Ashr(low, high, bits) {
    low = low|0; high = high|0; bits = bits|0;
    var ander = 0;
    if ((bits|0) < 32) {
      ander = ((1 << bits) - 1)|0;
      tempRet0 = high >> bits;
      return (low >>> bits) | ((high&ander) << (32 - bits));
    }
    tempRet0 = (high|0) < 0 ? -1 : 0;
    return (high >> (bits - 32))|0;
  }

// ======== compiled code from system/lib/compiler-rt , see readme therein
function ___muldsi3($a, $b) {
  $a = $a | 0;
  $b = $b | 0;
  var $1 = 0, $2 = 0, $3 = 0, $6 = 0, $8 = 0, $11 = 0, $12 = 0;
  $1 = $a & 65535;
  $2 = $b & 65535;
  $3 = Math_imul($2, $1) | 0;
  $6 = $a >>> 16;
  $8 = ($3 >>> 16) + (Math_imul($2, $6) | 0) | 0;
  $11 = $b >>> 16;
  $12 = Math_imul($11, $1) | 0;
  return (tempRet0 = (($8 >>> 16) + (Math_imul($11, $6) | 0) | 0) + ((($8 & 65535) + $12 | 0) >>> 16) | 0, 0 | ($8 + $12 << 16 | $3 & 65535)) | 0;
}
function ___divdi3($a$0, $a$1, $b$0, $b$1) {
  $a$0 = $a$0 | 0;
  $a$1 = $a$1 | 0;
  $b$0 = $b$0 | 0;
  $b$1 = $b$1 | 0;
  var $1$0 = 0, $1$1 = 0, $2$0 = 0, $2$1 = 0, $4$0 = 0, $4$1 = 0, $6$0 = 0, $7$0 = 0, $7$1 = 0, $8$0 = 0, $10$0 = 0;
  $1$0 = $a$1 >> 31 | (($a$1 | 0) < 0 ? -1 : 0) << 1;
  $1$1 = (($a$1 | 0) < 0 ? -1 : 0) >> 31 | (($a$1 | 0) < 0 ? -1 : 0) << 1;
  $2$0 = $b$1 >> 31 | (($b$1 | 0) < 0 ? -1 : 0) << 1;
  $2$1 = (($b$1 | 0) < 0 ? -1 : 0) >> 31 | (($b$1 | 0) < 0 ? -1 : 0) << 1;
  $4$0 = _i64Subtract($1$0 ^ $a$0, $1$1 ^ $a$1, $1$0, $1$1) | 0;
  $4$1 = tempRet0;
  $6$0 = _i64Subtract($2$0 ^ $b$0, $2$1 ^ $b$1, $2$0, $2$1) | 0;
  $7$0 = $2$0 ^ $1$0;
  $7$1 = $2$1 ^ $1$1;
  $8$0 = ___udivmoddi4($4$0, $4$1, $6$0, tempRet0, 0) | 0;
  $10$0 = _i64Subtract($8$0 ^ $7$0, tempRet0 ^ $7$1, $7$0, $7$1) | 0;
  return $10$0 | 0;
}
function ___remdi3($a$0, $a$1, $b$0, $b$1) {
  $a$0 = $a$0 | 0;
  $a$1 = $a$1 | 0;
  $b$0 = $b$0 | 0;
  $b$1 = $b$1 | 0;
  var $rem = 0, $1$0 = 0, $1$1 = 0, $2$0 = 0, $2$1 = 0, $4$0 = 0, $4$1 = 0, $6$0 = 0, $10$0 = 0, $10$1 = 0, __stackBase__ = 0;
  __stackBase__ = STACKTOP;
  STACKTOP = STACKTOP + 16 | 0;
  $rem = __stackBase__ | 0;
  $1$0 = $a$1 >> 31 | (($a$1 | 0) < 0 ? -1 : 0) << 1;
  $1$1 = (($a$1 | 0) < 0 ? -1 : 0) >> 31 | (($a$1 | 0) < 0 ? -1 : 0) << 1;
  $2$0 = $b$1 >> 31 | (($b$1 | 0) < 0 ? -1 : 0) << 1;
  $2$1 = (($b$1 | 0) < 0 ? -1 : 0) >> 31 | (($b$1 | 0) < 0 ? -1 : 0) << 1;
  $4$0 = _i64Subtract($1$0 ^ $a$0, $1$1 ^ $a$1, $1$0, $1$1) | 0;
  $4$1 = tempRet0;
  $6$0 = _i64Subtract($2$0 ^ $b$0, $2$1 ^ $b$1, $2$0, $2$1) | 0;
  ___udivmoddi4($4$0, $4$1, $6$0, tempRet0, $rem) | 0;
  $10$0 = _i64Subtract(HEAP32[$rem >> 2] ^ $1$0, HEAP32[$rem + 4 >> 2] ^ $1$1, $1$0, $1$1) | 0;
  $10$1 = tempRet0;
  STACKTOP = __stackBase__;
  return (tempRet0 = $10$1, $10$0) | 0;
}
function ___muldi3($a$0, $a$1, $b$0, $b$1) {
  $a$0 = $a$0 | 0;
  $a$1 = $a$1 | 0;
  $b$0 = $b$0 | 0;
  $b$1 = $b$1 | 0;
  var $x_sroa_0_0_extract_trunc = 0, $y_sroa_0_0_extract_trunc = 0, $1$0 = 0, $1$1 = 0, $2 = 0;
  $x_sroa_0_0_extract_trunc = $a$0;
  $y_sroa_0_0_extract_trunc = $b$0;
  $1$0 = ___muldsi3($x_sroa_0_0_extract_trunc, $y_sroa_0_0_extract_trunc) | 0;
  $1$1 = tempRet0;
  $2 = Math_imul($a$1, $y_sroa_0_0_extract_trunc) | 0;
  return (tempRet0 = ((Math_imul($b$1, $x_sroa_0_0_extract_trunc) | 0) + $2 | 0) + $1$1 | $1$1 & 0, 0 | $1$0 & -1) | 0;
}
function ___udivdi3($a$0, $a$1, $b$0, $b$1) {
  $a$0 = $a$0 | 0;
  $a$1 = $a$1 | 0;
  $b$0 = $b$0 | 0;
  $b$1 = $b$1 | 0;
  var $1$0 = 0;
  $1$0 = ___udivmoddi4($a$0, $a$1, $b$0, $b$1, 0) | 0;
  return $1$0 | 0;
}
function ___uremdi3($a$0, $a$1, $b$0, $b$1) {
  $a$0 = $a$0 | 0;
  $a$1 = $a$1 | 0;
  $b$0 = $b$0 | 0;
  $b$1 = $b$1 | 0;
  var $rem = 0, __stackBase__ = 0;
  __stackBase__ = STACKTOP;
  STACKTOP = STACKTOP + 16 | 0;
  $rem = __stackBase__ | 0;
  ___udivmoddi4($a$0, $a$1, $b$0, $b$1, $rem) | 0;
  STACKTOP = __stackBase__;
  return (tempRet0 = HEAP32[$rem + 4 >> 2] | 0, HEAP32[$rem >> 2] | 0) | 0;
}
function ___udivmoddi4($a$0, $a$1, $b$0, $b$1, $rem) {
  $a$0 = $a$0 | 0;
  $a$1 = $a$1 | 0;
  $b$0 = $b$0 | 0;
  $b$1 = $b$1 | 0;
  $rem = $rem | 0;
  var $n_sroa_0_0_extract_trunc = 0, $n_sroa_1_4_extract_shift$0 = 0, $n_sroa_1_4_extract_trunc = 0, $d_sroa_0_0_extract_trunc = 0, $d_sroa_1_4_extract_shift$0 = 0, $d_sroa_1_4_extract_trunc = 0, $4 = 0, $17 = 0, $37 = 0, $49 = 0, $51 = 0, $57 = 0, $58 = 0, $66 = 0, $78 = 0, $86 = 0, $88 = 0, $89 = 0, $91 = 0, $92 = 0, $95 = 0, $105 = 0, $117 = 0, $119 = 0, $125 = 0, $126 = 0, $130 = 0, $q_sroa_1_1_ph = 0, $q_sroa_0_1_ph = 0, $r_sroa_1_1_ph = 0, $r_sroa_0_1_ph = 0, $sr_1_ph = 0, $d_sroa_0_0_insert_insert99$0 = 0, $d_sroa_0_0_insert_insert99$1 = 0, $137$0 = 0, $137$1 = 0, $carry_0203 = 0, $sr_1202 = 0, $r_sroa_0_1201 = 0, $r_sroa_1_1200 = 0, $q_sroa_0_1199 = 0, $q_sroa_1_1198 = 0, $147 = 0, $149 = 0, $r_sroa_0_0_insert_insert42$0 = 0, $r_sroa_0_0_insert_insert42$1 = 0, $150$1 = 0, $151$0 = 0, $152 = 0, $154$0 = 0, $r_sroa_0_0_extract_trunc = 0, $r_sroa_1_4_extract_trunc = 0, $155 = 0, $carry_0_lcssa$0 = 0, $carry_0_lcssa$1 = 0, $r_sroa_0_1_lcssa = 0, $r_sroa_1_1_lcssa = 0, $q_sroa_0_1_lcssa = 0, $q_sroa_1_1_lcssa = 0, $q_sroa_0_0_insert_ext75$0 = 0, $q_sroa_0_0_insert_ext75$1 = 0, $q_sroa_0_0_insert_insert77$1 = 0, $_0$0 = 0, $_0$1 = 0;
  $n_sroa_0_0_extract_trunc = $a$0;
  $n_sroa_1_4_extract_shift$0 = $a$1;
  $n_sroa_1_4_extract_trunc = $n_sroa_1_4_extract_shift$0;
  $d_sroa_0_0_extract_trunc = $b$0;
  $d_sroa_1_4_extract_shift$0 = $b$1;
  $d_sroa_1_4_extract_trunc = $d_sroa_1_4_extract_shift$0;
  if (($n_sroa_1_4_extract_trunc | 0) == 0) {
    $4 = ($rem | 0) != 0;
    if (($d_sroa_1_4_extract_trunc | 0) == 0) {
      if ($4) {
        HEAP32[$rem >> 2] = ($n_sroa_0_0_extract_trunc >>> 0) % ($d_sroa_0_0_extract_trunc >>> 0);
        HEAP32[$rem + 4 >> 2] = 0;
      }
      $_0$1 = 0;
      $_0$0 = ($n_sroa_0_0_extract_trunc >>> 0) / ($d_sroa_0_0_extract_trunc >>> 0) >>> 0;
      return (tempRet0 = $_0$1, $_0$0) | 0;
    } else {
      if (!$4) {
        $_0$1 = 0;
        $_0$0 = 0;
        return (tempRet0 = $_0$1, $_0$0) | 0;
      }
      HEAP32[$rem >> 2] = $a$0 & -1;
      HEAP32[$rem + 4 >> 2] = $a$1 & 0;
      $_0$1 = 0;
      $_0$0 = 0;
      return (tempRet0 = $_0$1, $_0$0) | 0;
    }
  }
  $17 = ($d_sroa_1_4_extract_trunc | 0) == 0;
  do {
    if (($d_sroa_0_0_extract_trunc | 0) == 0) {
      if ($17) {
        if (($rem | 0) != 0) {
          HEAP32[$rem >> 2] = ($n_sroa_1_4_extract_trunc >>> 0) % ($d_sroa_0_0_extract_trunc >>> 0);
          HEAP32[$rem + 4 >> 2] = 0;
        }
        $_0$1 = 0;
        $_0$0 = ($n_sroa_1_4_extract_trunc >>> 0) / ($d_sroa_0_0_extract_trunc >>> 0) >>> 0;
        return (tempRet0 = $_0$1, $_0$0) | 0;
      }
      if (($n_sroa_0_0_extract_trunc | 0) == 0) {
        if (($rem | 0) != 0) {
          HEAP32[$rem >> 2] = 0;
          HEAP32[$rem + 4 >> 2] = ($n_sroa_1_4_extract_trunc >>> 0) % ($d_sroa_1_4_extract_trunc >>> 0);
        }
        $_0$1 = 0;
        $_0$0 = ($n_sroa_1_4_extract_trunc >>> 0) / ($d_sroa_1_4_extract_trunc >>> 0) >>> 0;
        return (tempRet0 = $_0$1, $_0$0) | 0;
      }
      $37 = $d_sroa_1_4_extract_trunc - 1 | 0;
      if (($37 & $d_sroa_1_4_extract_trunc | 0) == 0) {
        if (($rem | 0) != 0) {
          HEAP32[$rem >> 2] = 0 | $a$0 & -1;
          HEAP32[$rem + 4 >> 2] = $37 & $n_sroa_1_4_extract_trunc | $a$1 & 0;
        }
        $_0$1 = 0;
        $_0$0 = $n_sroa_1_4_extract_trunc >>> ((_llvm_cttz_i32($d_sroa_1_4_extract_trunc | 0) | 0) >>> 0);
        return (tempRet0 = $_0$1, $_0$0) | 0;
      }
      $49 = Math_clz32($d_sroa_1_4_extract_trunc | 0) | 0;
      $51 = $49 - (Math_clz32($n_sroa_1_4_extract_trunc | 0) | 0) | 0;
      if ($51 >>> 0 <= 30) {
        $57 = $51 + 1 | 0;
        $58 = 31 - $51 | 0;
        $sr_1_ph = $57;
        $r_sroa_0_1_ph = $n_sroa_1_4_extract_trunc << $58 | $n_sroa_0_0_extract_trunc >>> ($57 >>> 0);
        $r_sroa_1_1_ph = $n_sroa_1_4_extract_trunc >>> ($57 >>> 0);
        $q_sroa_0_1_ph = 0;
        $q_sroa_1_1_ph = $n_sroa_0_0_extract_trunc << $58;
        break;
      }
      if (($rem | 0) == 0) {
        $_0$1 = 0;
        $_0$0 = 0;
        return (tempRet0 = $_0$1, $_0$0) | 0;
      }
      HEAP32[$rem >> 2] = 0 | $a$0 & -1;
      HEAP32[$rem + 4 >> 2] = $n_sroa_1_4_extract_shift$0 | $a$1 & 0;
      $_0$1 = 0;
      $_0$0 = 0;
      return (tempRet0 = $_0$1, $_0$0) | 0;
    } else {
      if (!$17) {
        $117 = Math_clz32($d_sroa_1_4_extract_trunc | 0) | 0;
        $119 = $117 - (Math_clz32($n_sroa_1_4_extract_trunc | 0) | 0) | 0;
        if ($119 >>> 0 <= 31) {
          $125 = $119 + 1 | 0;
          $126 = 31 - $119 | 0;
          $130 = $119 - 31 >> 31;
          $sr_1_ph = $125;
          $r_sroa_0_1_ph = $n_sroa_0_0_extract_trunc >>> ($125 >>> 0) & $130 | $n_sroa_1_4_extract_trunc << $126;
          $r_sroa_1_1_ph = $n_sroa_1_4_extract_trunc >>> ($125 >>> 0) & $130;
          $q_sroa_0_1_ph = 0;
          $q_sroa_1_1_ph = $n_sroa_0_0_extract_trunc << $126;
          break;
        }
        if (($rem | 0) == 0) {
          $_0$1 = 0;
          $_0$0 = 0;
          return (tempRet0 = $_0$1, $_0$0) | 0;
        }
        HEAP32[$rem >> 2] = 0 | $a$0 & -1;
        HEAP32[$rem + 4 >> 2] = $n_sroa_1_4_extract_shift$0 | $a$1 & 0;
        $_0$1 = 0;
        $_0$0 = 0;
        return (tempRet0 = $_0$1, $_0$0) | 0;
      }
      $66 = $d_sroa_0_0_extract_trunc - 1 | 0;
      if (($66 & $d_sroa_0_0_extract_trunc | 0) != 0) {
        $86 = (Math_clz32($d_sroa_0_0_extract_trunc | 0) | 0) + 33 | 0;
        $88 = $86 - (Math_clz32($n_sroa_1_4_extract_trunc | 0) | 0) | 0;
        $89 = 64 - $88 | 0;
        $91 = 32 - $88 | 0;
        $92 = $91 >> 31;
        $95 = $88 - 32 | 0;
        $105 = $95 >> 31;
        $sr_1_ph = $88;
        $r_sroa_0_1_ph = $91 - 1 >> 31 & $n_sroa_1_4_extract_trunc >>> ($95 >>> 0) | ($n_sroa_1_4_extract_trunc << $91 | $n_sroa_0_0_extract_trunc >>> ($88 >>> 0)) & $105;
        $r_sroa_1_1_ph = $105 & $n_sroa_1_4_extract_trunc >>> ($88 >>> 0);
        $q_sroa_0_1_ph = $n_sroa_0_0_extract_trunc << $89 & $92;
        $q_sroa_1_1_ph = ($n_sroa_1_4_extract_trunc << $89 | $n_sroa_0_0_extract_trunc >>> ($95 >>> 0)) & $92 | $n_sroa_0_0_extract_trunc << $91 & $88 - 33 >> 31;
        break;
      }
      if (($rem | 0) != 0) {
        HEAP32[$rem >> 2] = $66 & $n_sroa_0_0_extract_trunc;
        HEAP32[$rem + 4 >> 2] = 0;
      }
      if (($d_sroa_0_0_extract_trunc | 0) == 1) {
        $_0$1 = $n_sroa_1_4_extract_shift$0 | $a$1 & 0;
        $_0$0 = 0 | $a$0 & -1;
        return (tempRet0 = $_0$1, $_0$0) | 0;
      } else {
        $78 = _llvm_cttz_i32($d_sroa_0_0_extract_trunc | 0) | 0;
        $_0$1 = 0 | $n_sroa_1_4_extract_trunc >>> ($78 >>> 0);
        $_0$0 = $n_sroa_1_4_extract_trunc << 32 - $78 | $n_sroa_0_0_extract_trunc >>> ($78 >>> 0) | 0;
        return (tempRet0 = $_0$1, $_0$0) | 0;
      }
    }
  } while (0);
  if (($sr_1_ph | 0) == 0) {
    $q_sroa_1_1_lcssa = $q_sroa_1_1_ph;
    $q_sroa_0_1_lcssa = $q_sroa_0_1_ph;
    $r_sroa_1_1_lcssa = $r_sroa_1_1_ph;
    $r_sroa_0_1_lcssa = $r_sroa_0_1_ph;
    $carry_0_lcssa$1 = 0;
    $carry_0_lcssa$0 = 0;
  } else {
    $d_sroa_0_0_insert_insert99$0 = 0 | $b$0 & -1;
    $d_sroa_0_0_insert_insert99$1 = $d_sroa_1_4_extract_shift$0 | $b$1 & 0;
    $137$0 = _i64Add($d_sroa_0_0_insert_insert99$0 | 0, $d_sroa_0_0_insert_insert99$1 | 0, -1, -1) | 0;
    $137$1 = tempRet0;
    $q_sroa_1_1198 = $q_sroa_1_1_ph;
    $q_sroa_0_1199 = $q_sroa_0_1_ph;
    $r_sroa_1_1200 = $r_sroa_1_1_ph;
    $r_sroa_0_1201 = $r_sroa_0_1_ph;
    $sr_1202 = $sr_1_ph;
    $carry_0203 = 0;
    while (1) {
      $147 = $q_sroa_0_1199 >>> 31 | $q_sroa_1_1198 << 1;
      $149 = $carry_0203 | $q_sroa_0_1199 << 1;
      $r_sroa_0_0_insert_insert42$0 = 0 | ($r_sroa_0_1201 << 1 | $q_sroa_1_1198 >>> 31);
      $r_sroa_0_0_insert_insert42$1 = $r_sroa_0_1201 >>> 31 | $r_sroa_1_1200 << 1 | 0;
      _i64Subtract($137$0, $137$1, $r_sroa_0_0_insert_insert42$0, $r_sroa_0_0_insert_insert42$1) | 0;
      $150$1 = tempRet0;
      $151$0 = $150$1 >> 31 | (($150$1 | 0) < 0 ? -1 : 0) << 1;
      $152 = $151$0 & 1;
      $154$0 = _i64Subtract($r_sroa_0_0_insert_insert42$0, $r_sroa_0_0_insert_insert42$1, $151$0 & $d_sroa_0_0_insert_insert99$0, ((($150$1 | 0) < 0 ? -1 : 0) >> 31 | (($150$1 | 0) < 0 ? -1 : 0) << 1) & $d_sroa_0_0_insert_insert99$1) | 0;
      $r_sroa_0_0_extract_trunc = $154$0;
      $r_sroa_1_4_extract_trunc = tempRet0;
      $155 = $sr_1202 - 1 | 0;
      if (($155 | 0) == 0) {
        break;
      } else {
        $q_sroa_1_1198 = $147;
        $q_sroa_0_1199 = $149;
        $r_sroa_1_1200 = $r_sroa_1_4_extract_trunc;
        $r_sroa_0_1201 = $r_sroa_0_0_extract_trunc;
        $sr_1202 = $155;
        $carry_0203 = $152;
      }
    }
    $q_sroa_1_1_lcssa = $147;
    $q_sroa_0_1_lcssa = $149;
    $r_sroa_1_1_lcssa = $r_sroa_1_4_extract_trunc;
    $r_sroa_0_1_lcssa = $r_sroa_0_0_extract_trunc;
    $carry_0_lcssa$1 = 0;
    $carry_0_lcssa$0 = $152;
  }
  $q_sroa_0_0_insert_ext75$0 = $q_sroa_0_1_lcssa;
  $q_sroa_0_0_insert_ext75$1 = 0;
  $q_sroa_0_0_insert_insert77$1 = $q_sroa_1_1_lcssa | $q_sroa_0_0_insert_ext75$1;
  if (($rem | 0) != 0) {
    HEAP32[$rem >> 2] = 0 | $r_sroa_0_1_lcssa;
    HEAP32[$rem + 4 >> 2] = $r_sroa_1_1_lcssa | 0;
  }
  $_0$1 = (0 | $q_sroa_0_0_insert_ext75$0) >>> 31 | $q_sroa_0_0_insert_insert77$1 << 1 | ($q_sroa_0_0_insert_ext75$1 << 1 | $q_sroa_0_0_insert_ext75$0 >>> 31) & 0 | $carry_0_lcssa$1;
  $_0$0 = ($q_sroa_0_0_insert_ext75$0 << 1 | 0 >>> 31) & -2 | $carry_0_lcssa$0;
  return (tempRet0 = $_0$1, $_0$0) | 0;
}
// =======================================================================



  
function dynCall_ii(index,a1) {
  index = index|0;
  a1=a1|0;
  return FUNCTION_TABLE_ii[index&1](a1|0)|0;
}


function dynCall_iiii(index,a1,a2,a3) {
  index = index|0;
  a1=a1|0; a2=a2|0; a3=a3|0;
  return FUNCTION_TABLE_iiii[index&7](a1|0,a2|0,a3|0)|0;
}


function dynCall_vi(index,a1) {
  index = index|0;
  a1=a1|0;
  FUNCTION_TABLE_vi[index&7](a1|0);
}

function b0(p0) {
 p0 = p0|0; nullFunc_ii(0);return 0;
}
function b1(p0,p1,p2) {
 p0 = p0|0;p1 = p1|0;p2 = p2|0; nullFunc_iiii(1);return 0;
}
function b2(p0) {
 p0 = p0|0; nullFunc_vi(2);
}

// EMSCRIPTEN_END_FUNCS
var FUNCTION_TABLE_ii = [b0,___stdio_close];
var FUNCTION_TABLE_iiii = [b1,b1,___stdout_write,___stdio_seek,___stdio_write,b1,b1,b1];
var FUNCTION_TABLE_vi = [b2,b2,b2,b2,b2,_cleanup,b2,b2];

  return { _i64Subtract: _i64Subtract, _free: _free, _main: _main, _i64Add: _i64Add, _memset: _memset, _malloc: _malloc, _memcpy: _memcpy, _bitshift64Lshr: _bitshift64Lshr, _fflush: _fflush, ___errno_location: ___errno_location, _bitshift64Shl: _bitshift64Shl, runPostSets: runPostSets, stackAlloc: stackAlloc, stackSave: stackSave, stackRestore: stackRestore, establishStackSpace: establishStackSpace, setThrew: setThrew, setTempRet0: setTempRet0, getTempRet0: getTempRet0, dynCall_ii: dynCall_ii, dynCall_iiii: dynCall_iiii, dynCall_vi: dynCall_vi, ___udivmoddi4: ___udivmoddi4 };
})
;
