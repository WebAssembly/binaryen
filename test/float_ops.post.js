
// unary
function testUnary(name) {
  Module.print(name);
  function doTest(x) {
    Module.print('  ' + [x] + ' ==> ' + Module['_' + name](x));
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
  doTest(-1 | 0);
  doTest((-1 | 0) + 1);
  doTest((-1 | 0) - 1);
  doTest((-1 >>> 0) + 1);
  doTest((-1 >>> 0) - 1);
  doTest((-1 | 0) + 2);
  doTest((-1 | 0) - 2);
  doTest((-1 >>> 0) + 2);
  doTest((-1 >>> 0) - 2);
}
testUnary('dfloor');

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
  doTest(0.12, 0.12);
  doTest(0.812, 1);
  doTest(1.821, 0);
  doTest(1, 1.212);
  doTest(5.543, 6);
  doTest(6, 5.121);
  doTest(101.001, -12);
  doTest(-12.001, 101);
  doTest(-1, 5.123);
  doTest(5, -1.123);
  doTest(-1, -1.123);
}
testBinary('dadd');
testBinary('dsub');
testBinary('dmul');
testBinary('ddiv');
//testBinary('dcopysign'); // TODO this uses tempDoublePtr, a global, which is not yet functional
testBinary('dmin');
testBinary('dmax');

// comparisons
testBinary('deq');
testBinary('dne');
testBinary('dlt');
testBinary('dle');
testBinary('dgt');
testBinary('dge');

// conversions
testUnary('int_to_double');
testUnary('uint_to_double');
testUnary('double_to_int');
testUnary('double_to_uint');
testUnary('int_to_float');
testUnary('uint_to_float');
testUnary('float_to_int');
testUnary('float_to_uint');

Module.print('done.');

