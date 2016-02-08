
function test(name) {
  Module.print(name);
  function doTest(x) {
    // write to 0, as 0-8 is normally unused anyhow
    Module['_store' + name](0, x);
    Module.print('  ' + [x] + ' ==> ' + Module['_load' + name](0));
  }
  doTest(0);
  doTest(1);
  doTest(-1);
  doTest(0.5);
  doTest(-0.5);
  doTest(1.4);
  doTest(-1.4);
  doTest(1.6);
  doTest(-1.6);
  doTest(5.1);
  doTest(5.3);
  doTest(5.7);
  doTest(5.9);
  doTest(1 << 10);
  doTest(1 << 20);
  doTest(-1 | 0);
  doTest((-1 | 0) + 1);
  doTest((-1 | 0) - 1);
  doTest(-1 >>> 0);
  doTest((-1 >>> 0) + 1);
  doTest((-1 >>> 0) - 1);

  Module.print('  pre  ==> ' + Module['_load' + name](0));
  HEAPU8[0] = 10;
  HEAPU8[1] = 20;
  HEAPU8[2] = 30;
  HEAPU8[3] = 40;
  HEAPU8[4] = 50;
  HEAPU8[5] = 99;
  HEAPU8[6] = 125;
  HEAPU8[7] = 250;
  Module.print('  post ==> ' + Module['_load' + name](0));
}

test('i8');
test('i16');
test('i32');
test('u8');
test('u16');
test('u32');
test('f32');
test('f64');

Module.print('stack: ' + (Module['_get_stack']() > 8));

