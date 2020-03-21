binaryen.setAPITracing(true);

var module = new binaryen.Module();
module.addGlobal("aGlobal", binaryen.i32, true, module.i32.const(0));
var Mode = binaryen.ExpressionRunner.Mode;

// Should evaluate down to a constant
var runner = new binaryen.ExpressionRunner(module, Mode.Evaluate);
var expr = runner.runAndDispose(
  module.i32.add(
    module.i32.const(1),
    module.i32.const(2)
  )
);
assert(JSON.stringify(binaryen.getExpressionInfo(expr)) === '{"id":14,"type":2,"value":3}');

// Should traverse control structures
runner = new binaryen.ExpressionRunner(module, Mode.Evaluate);
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

// Should be unable to evaluate a local if not explicitly specified
runner = new binaryen.ExpressionRunner(module, Mode.Evaluate);
expr = runner.runAndDispose(
  module.i32.add(
    module.local.get(0, binaryen.i32),
    module.i32.const(1)
  )
);
assert(expr === 0);

// Should handle traps properly
runner = new binaryen.ExpressionRunner(module, Mode.Evaluate);
expr = runner.runAndDispose(
  module.unreachable()
);
assert(expr === 0);

// Should ignore `local.tee` side-effects if just evaluating the expression
runner = new binaryen.ExpressionRunner(module, Mode.Evaluate);
expr = runner.runAndDispose(
  module.i32.add(
    module.local.tee(0, module.i32.const(4), binaryen.i32),
    module.i32.const(1)
  )
);
assert(JSON.stringify(binaryen.getExpressionInfo(expr)) === '{"id":14,"type":2,"value":5}');

// Should keep all side-effects if we are going to replace the expression
runner = new binaryen.ExpressionRunner(module, Mode.Replace);
expr = runner.runAndDispose(
  module.i32.add(
    module.local.tee(0, module.i32.const(4), binaryen.i32),
    module.i32.const(1)
  )
);
assert(expr === 0);

// Should work with temporary values if just evaluating the expression
runner = new binaryen.ExpressionRunner(module, Mode.Evaluate);
expr = runner.runAndDispose(
  module.i32.add(
    module.block(null, [
      module.local.set(0, module.i32.const(2)),
      module.local.get(0, binaryen.i32)
    ], binaryen.i32),
    module.block(null, [
      module.global.set("aGlobal", module.i32.const(4)),
      module.global.get("aGlobal", binaryen.i32)
    ], binaryen.i32)
  )
);
assert(JSON.stringify(binaryen.getExpressionInfo(expr)) === '{"id":14,"type":2,"value":6}');

// Should pick up explicitly preset values
runner = new binaryen.ExpressionRunner(module, Mode.Replace);
assert(runner.setLocalValue(0, module.i32.const(3)));
assert(runner.setGlobalValue("aGlobal", module.i32.const(4)));
expr = runner.runAndDispose(
  module.i32.add(
    module.local.get(0, binaryen.i32),
    module.global.get("aGlobal", binaryen.i32)
  )
);
assert(JSON.stringify(binaryen.getExpressionInfo(expr)) === '{"id":14,"type":2,"value":7}');

// Should traverse into simple functions
runner = new binaryen.ExpressionRunner(module, Mode.Evaluate);
module.addFunction("add", binaryen.createType([ binaryen.i32, binaryen.i32 ]), binaryen.i32, [],
  module.block(null, [
    module.i32.add(
      module.local.get(0, binaryen.i32),
      module.local.get(1, binaryen.i32)
    )
  ], binaryen.i32)
);
expr = runner.runAndDispose(
  module.i32.add(
    module.i32.const(1),
    module.call("add", [
      module.i32.const(3),
      module.i32.const(4)
    ], binaryen.i32)
  )
);
assert(JSON.stringify(binaryen.getExpressionInfo(expr)) === '{"id":14,"type":2,"value":8}');

binaryen.setAPITracing(false);
