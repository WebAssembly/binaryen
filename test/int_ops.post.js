
// unary
Module.print('clz');
Module.print(Module._clz(1));
Module.print(Module._clz(-1));
Module.print(Module._clz(8));

// binary
function testBinary(name) {
  Module.print(name);
  Module.print(Module['_' + name](0, 0));
  Module.print(Module['_' + name](0, 1));
  Module.print(Module['_' + name](1, 0));
  Module.print(Module['_' + name](1, 1));
  Module.print(Module['_' + name](5, 6));
  Module.print(Module['_' + name](6, 5));
  Module.print(Module['_' + name](101, -12));
  Module.print(Module['_' + name](-12, 101));
  Module.print(Module['_' + name](-1, 5));
  Module.print(Module['_' + name](5, -1));
  Module.print(Module['_' + name](-1, -1));
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

