binaryen.setAPITracing(true);

var module = new binaryen.Module();

// Create an expression and copy it
var original = module.block(null, [
  module.if(
    module.local.get(0, binaryen.i32),
    module.i32.const(1),
    module.i32.const(2)
  )
], binaryen.i32);
var copy = module.copyExpression(original);

// Check that the expression incl. sub-expressions are copies
assert(original !== copy);
var originalIf = binaryen._BinaryenBlockGetChild(original, 0);
var copyIf = binaryen._BinaryenBlockGetChild(copy, 0);
assert(originalIf !== copyIf);
assert(binaryen._BinaryenIfGetCondition(originalIf) !== binaryen._BinaryenIfGetCondition(copyIf));
assert(binaryen._BinaryenIfGetIfTrue(originalIf) !== binaryen._BinaryenIfGetIfTrue(copyIf));
assert(binaryen._BinaryenIfGetIfFalse(originalIf) !== binaryen._BinaryenIfGetIfFalse(copyIf));

binaryen.setAPITracing(false);

// Check that both are otherwise identical, but do it after tracing so
// emitText and tracing output don't conflict on stdout
assert(binaryen.emitText(original) === binaryen.emitText(copy));
