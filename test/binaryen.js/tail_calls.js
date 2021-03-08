var module = new binaryen.Module();

module.setFeatures(binaryen.Features.TailCall);

module.addTableImport("0", "env", "table");

var foo = module.addFunction(
  "foo",
  binaryen.none,
  binaryen.none,
  [],
  module.return_call("foo", [], binaryen.none, binaryen.none)
);

var bar = module.addFunction(
  "bar",
  binaryen.none,
  binaryen.none,
  [],
  module.return_call_indirect(
    "0",
    module.i32.const(0),
    [],
    binaryen.none,
    binaryen.none
  )
);

assert(module.validate());

console.log(
  binaryen.getExpressionInfo(binaryen.getFunctionInfo(foo).body).isReturn
);

console.log(
  binaryen.getExpressionInfo(binaryen.getFunctionInfo(bar).body).isReturn
);
