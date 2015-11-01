
// unary
Module.print('clz');
Module.print(Module._clz(1));
Module.print(Module._clz(-1));
Module.print(Module._clz(8));

// binary
function testBinary(name) {
  Module.print(name);
  function doTest(x, y) {
    Module.print('  ' + [x, y] + ' ==> ' + Module['_' + name](x, y));
  }
  doTest(0, 0);
  doTest(0, 1);
  doTest(1, 0);
  doTest(1, 1);
  doTest(5, 6);
  doTest(6, 5);
  doTest(101, -12);
  doTest(-12, 101);
  doTest(-1, 5);
  doTest(5, -1);
  doTest(-1, -1);
}
testBinary('add');
testBinary('sub');
testBinary('mul');
testBinary('sdiv');
testBinary('udiv');
testBinary('srem');
testBinary('urem');
testBinary('and');
testBinary('or');
testBinary('xor');
testBinary('shl');
testBinary('sshr');
testBinary('ushr');

// comparisons
testBinary('eq');
testBinary('ne');
testBinary('lts');
testBinary('ltu');
testBinary('les');
testBinary('leu');
testBinary('gts');
testBinary('gtu');
testBinary('ges');
testBinary('geu');

Module.print('done.');

