function () {
  "use asm";
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
  return { add: add, ret: ret, opts: opts };
}

