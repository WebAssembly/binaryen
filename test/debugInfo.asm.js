function () {
  "use asm";
  var STACKTOP = 0;
  function add(x, y) {
    x = x | 0;
    y = y | 0;
    x = x; //@line 5 "tests/hello_world.c"
    y = y; //@line 6 "tests/hello_world.c"
    x = y; //@line 314159 "tests/other_file.cpp"
    return x + y | 0;
  }
  function ret(x) {
    x = x | 0;
    x = x << 1; //@line 50 "return.cpp"
    return x + 1 | 0; //@line 100 "return.cpp"
  }
  function opts(x, y) {
    x = x | 0;
    y = y | 0;
    x = (x + y) | 0; //@line 1 "even-opted.cpp"
    y = y >> x; //@line 2 "even-opted.cpp"
    x = (x | 0) % (y | 0); //@line 3 "even-opted.cpp"
    return x + y | 0;
  }
  function fib($0) {
   $0 = $0|0;
   var $$0$lcssa = 0, $$01518 = 0, $$01518$phi = 0, $$01617 = 0, $$019 = 0, $1 = 0, $2 = 0, $3 = 0, $exitcond = 0, label = 0, sp = 0;
   sp = STACKTOP;
   $1 = ($0|0)>(0); //@line 3 "fib.c"
   if ($1) {
    $$01518 = 0;$$01617 = 0;$$019 = 1;
   } else {
    $$0$lcssa = 1;
    return ($$0$lcssa|0); //@line 8 "fib.c"
   }
   while(1) {
    $2 = (($$019) + ($$01518))|0; //@line 4 "fib.c"
    $3 = (($$01617) + 1)|0; //@line 3 "fib.c"
    $exitcond = ($3|0)==($0|0); //@line 3 "fib.c"
    if ($exitcond) {
     $$0$lcssa = $2;
     break;
    } else {
     $$01518$phi = $$019;$$01617 = $3;$$019 = $2;$$01518 = $$01518$phi;
    }
   }
   return ($$0$lcssa|0); //@line 8 "fib.c"
  }
  function switch_reach($p) {
   $p = $p|0;
   var $0 = 0, $call = 0, $magic = 0, $rc$0 = 0, $switch$split2D = 0, label = 0, sp = 0;
   sp = STACKTOP;
   $magic = ((($p)) + 52|0);
   $0 = $magic;
   $switch$split2D = ($0|0)<(1369188723);
   if ($switch$split2D) {
    switch ($0|0) {
    case -1108210269:  {
     label = 2;
     break;
    }
    default: {
     $rc$0 = 0;
    }
    }
   } else {
    switch ($0|0) {
    case 1369188723:  {
     label = 2;
     break;
    }
    default: {
     $rc$0 = 0;
    }
    }
   }
   if ((label|0) == 2) {
    $call = switch_reach($p) | 0;
    $rc$0 = $call;
   }
   switch_reach($p) | 0;
   return ($rc$0|0); //@line 59950 "/tmp/emscripten_test_binaryen2_28hnAe/src.c"
  }
  function nofile() {
    nofile(); //@line 1337
  }
  return { add: add, ret: ret, opts: opts, fib: fib, switch_reach: switch_reach, nofile: nofile };
}

