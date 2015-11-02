
function test(name) {
  Module.print(name);
  function doTest(x) {
    Module.print('  ' + [x] + ' ==> ' + Module['_check_' + name](x));
  }
  doTest(1);
  doTest(2);
  doTest(3);
  doTest(4);
  doTest(11);
  doTest(90);
}

test('if');
test('loop');
test('loop_break');
test('loop_continue');
test('do_loop');
test('do_once');
test('while_forever');
test('switch');
test('switch_nodefault');
test('switch_rdefault');
test('switch_fallthrough');

