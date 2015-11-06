
// unary
Module.print('clz');
Module.print(Module._clz(1));
Module.print(Module._clz(-1));
Module.print(Module._clz(8));

// binary
function testBinary(name, noSecondZero, noSecondBig) {
  Module.print(name);
  function doTest(x, y) {
    Module.print('  ' + [x, y] + ' ==> ' + Module['_' + name](x, y));
  }
  if (!noSecondZero) doTest(0, 0);
  doTest(0, 1);
  if (!noSecondZero) doTest(1, 0);
  doTest(1, 1);
  doTest(5, 6);
  doTest(6, 5);
  if (!noSecondBig) doTest(101, -12);
  if (!noSecondBig) doTest(-12, 101);
  doTest(-1, 5);
  if (!noSecondBig) doTest(5, -1);
  if (!noSecondBig) doTest(-1, -1);
}
testBinary('add');
testBinary('sub');
testBinary('mul');
testBinary('sdiv', true);
testBinary('udiv', true);
testBinary('srem', true);
testBinary('urem', true);
testBinary('and');
testBinary('or');
testBinary('xor');
testBinary('shl', false, true);
testBinary('sshr', false, true);
testBinary('ushr', false, true);

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

