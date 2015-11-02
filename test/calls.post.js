
function test(name) {
  Module.print(name);
  function doTest(x) {
    Module.print('  ' + [x] + ' ==> ' + Module['_' + name](x));
  }
  doTest(1);
  doTest(2);
  doTest(3);
  doTest(4);
  doTest(7);
}

test('simple');
test('fibo');

Module.print('run_script');
Module.print(Module['_run_script']());

Module.print('too many/few arguments');
Module.print(Module['_simple']());
Module.print(Module['_simple'](10, 20));

