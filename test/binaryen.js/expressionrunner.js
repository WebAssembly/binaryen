binaryen.setAPITracing(true);

var module = new binaryen.Module();
var Intent = binaryen.ExpressionRunner.Intent;

// Should evaluate down to a constant
var runner = new binaryen.ExpressionRunner(module, Intent.Evaluate);
var expr = runner.runAndDispose(
  module.i32.add(
    module.i32.const(1),
    module.i32.const(2)
  )
);
assert(JSON.stringify(binaryen.getExpressionInfo(expr)) === '{"id":14,"type":2,"value":3}');

// Should traverse control structures
runner = new binaryen.ExpressionRunner(module, Intent.Evaluate);
expr = runner.runAndDispose(
  module.i32.add(
    module.i32.const(1),
    module.if(
      module.i32.const(0),
      module.i32.const(0),
      module.i32.const(3)
    )
  ),
);
assert(JSON.stringify(binaryen.getExpressionInfo(expr)) === '{"id":14,"type":2,"value":4}');

// Should be unable to evaluate a local
runner = new binaryen.ExpressionRunner(module, Intent.Evaluate);
expr = runner.runAndDispose(
  module.i32.add(
    module.local.get(0, binaryen.i32),
    module.i32.const(1)
  )
);
assert(expr === 0);

// Should handle traps
runner = new binaryen.ExpressionRunner(module, Intent.Evaluate);
expr = runner.runAndDispose(
  module.unreachable()
);
assert(expr === 0);

// Should ignore some side-effects if the intent is to evaluate the expression
runner = new binaryen.ExpressionRunner(module, Intent.Evaluate);
expr = runner.runAndDispose(
  module.i32.add(
    module.local.tee(0, module.i32.const(4), binaryen.i32),
    module.i32.const(1)
  )
);
assert(JSON.stringify(binaryen.getExpressionInfo(expr)) === '{"id":14,"type":2,"value":5}');

// Should keep side-effects if the intent is to replace the expression
runner = new binaryen.ExpressionRunner(module, Intent.ReplaceExpression);
expr = runner.runAndDispose(
  module.i32.add(
    module.local.tee(0, module.i32.const(4), binaryen.i32),
    module.i32.const(1)
  )
);
assert(expr === 0);

binaryen.setAPITracing(false);
