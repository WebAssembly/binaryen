binaryen.setAPITracing(true);

var module = new binaryen.Module();

var runner = new binaryen.ExpressionRunner(module);
var expr = runner.runAndDispose(
  module.i32.add(
    module.i32.const(1),
    module.i32.const(2)
  )
);
assert(JSON.stringify(binaryen.getExpressionInfo(expr)) === '{"id":14,"type":2,"value":3}');

runner = new binaryen.ExpressionRunner(module);
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

runner = new binaryen.ExpressionRunner(module);
expr = runner.runAndDispose(
  module.i32.add(
    module.local.get(0, binaryen.i32),
    module.i32.const(1)
  )
);
assert(expr === 0);

binaryen.setAPITracing(false);
