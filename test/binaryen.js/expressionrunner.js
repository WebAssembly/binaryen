var Flags = binaryen.ExpressionRunner.Flags;
console.log("// ExpressionRunner.Flags.Default = " + Flags.Default);
console.log("// ExpressionRunner.Flags.PreserveSideeffects = " + Flags.PreserveSideeffects);

function assertDeepEqual(x, y) {
  if (typeof x === "object") {
    for (let i in x) assertDeepEqual(x[i], y[i]);
    for (let i in y) assertDeepEqual(x[i], y[i]);
  } else {
    assert(x === y);
  }
}

var module = new binaryen.Module();
module.addGlobal("aGlobal", binaryen.i32, true, module.i32.const(0));

// Should evaluate down to a constant
var runner = new binaryen.ExpressionRunner(module);
var expr = runner.runAndDispose(
  module.i32.add(
    module.i32.const(1),
    module.i32.const(2)
  )
);
assertDeepEqual(
  binaryen.getExpressionInfo(expr),
  {
    id: binaryen.ExpressionIds.Const,
    type: binaryen.i32,
    value: 3
  }
);

// Should traverse control structures
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
assertDeepEqual(
  binaryen.getExpressionInfo(expr),
  {
    id: binaryen.ExpressionIds.Const,
    type: binaryen.i32,
    value: 4
  }
);

// Should be unable to evaluate a local if not explicitly specified
runner = new binaryen.ExpressionRunner(module);
expr = runner.runAndDispose(
  module.i32.add(
    module.local.get(0, binaryen.i32),
    module.i32.const(1)
  )
);
assert(expr === 0);

// Should handle traps properly
runner = new binaryen.ExpressionRunner(module);
expr = runner.runAndDispose(
  module.unreachable()
);
assert(expr === 0);

// Should ignore `local.tee` side-effects if just evaluating the expression
runner = new binaryen.ExpressionRunner(module);
expr = runner.runAndDispose(
  module.i32.add(
    module.local.tee(0, module.i32.const(4), binaryen.i32),
    module.i32.const(1)
  )
);
assertDeepEqual(
  binaryen.getExpressionInfo(expr),
  {
    id: binaryen.ExpressionIds.Const,
    type: binaryen.i32,
    value: 5
  }
);

// Should preserve any side-effects if explicitly requested
runner = new binaryen.ExpressionRunner(module, Flags.PreserveSideeffects);
expr = runner.runAndDispose(
  module.i32.add(
    module.local.tee(0, module.i32.const(4), binaryen.i32),
    module.i32.const(1)
  )
);
assert(expr === 0);

// Should work with temporary values if just evaluating the expression
runner = new binaryen.ExpressionRunner(module);
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
assertDeepEqual(
  binaryen.getExpressionInfo(expr),
  {
    id: binaryen.ExpressionIds.Const,
    type: binaryen.i32,
    value: 6
  }
);

// Should pick up explicitly preset values
runner = new binaryen.ExpressionRunner(module, Flags.PreserveSideeffects);
assert(runner.setLocalValue(0, module.i32.const(3)));
assert(runner.setGlobalValue("aGlobal", module.i32.const(4)));
expr = runner.runAndDispose(
  module.i32.add(
    module.local.get(0, binaryen.i32),
    module.global.get("aGlobal", binaryen.i32)
  )
);
assertDeepEqual(
  binaryen.getExpressionInfo(expr),
  {
    id: binaryen.ExpressionIds.Const,
    type: binaryen.i32,
    value: 7
  }
);

// Should not attempt to traverse into functions
runner = new binaryen.ExpressionRunner(module);
expr = runner.runAndDispose(
  module.i32.add(
    module.i32.const(1),
    module.call("add", [
      module.i32.const(3),
      module.i32.const(4)
    ], binaryen.i32)
  )
);
assert(expr === 0);

// Should stop on maxDepth
runner = new binaryen.ExpressionRunner(module, Flags.Default, 1);
expr = runner.runAndDispose(
  module.block(null, [
    module.i32.const(1),
  ], binaryen.i32)
);
assert(expr === 0);

// Should not loop infinitely
runner = new binaryen.ExpressionRunner(module, Flags.Default, 50, 3);
expr = runner.runAndDispose(
  module.loop("theLoop",
    module.br("theLoop")
  )
);
assert(expr === 0);

module.dispose();
