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

var originalInfo = binaryen.getExpressionInfo(original);
assert(originalInfo.children.length === 1);

var copyInfo = binaryen.getExpressionInfo(copy);
assert(originalInfo.children.length === copyInfo.children.length);
assert(originalInfo.children[0] !== copyInfo.children[0]);

var originalIfInfo = binaryen.getExpressionInfo(originalInfo.children[0]);
var copyIfInfo = binaryen.getExpressionInfo(copyInfo.children[0]);

assert(originalIfInfo.condition !== copyIfInfo.condition);
assert(originalIfInfo.ifTrue !== copyIfInfo.ifTrue);
assert(originalIfInfo.ifFalse !== copyIfInfo.ifFalse);

// Check that both are otherwise identical
assert(binaryen.emitText(original) === binaryen.emitText(copy));
