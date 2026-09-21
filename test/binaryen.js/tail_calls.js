var module = new binaryen.Module();

module.setFeatures(binaryen.Features.TailCall);

module.addTableImport("0", "env", "table");

var foo = module.addFunction(
  "foo",
  binaryen.Type.none,
  binaryen.Type.none,
  [],
  module.return_call("foo", [], binaryen.Type.none, binaryen.Type.none)
);

var bar = module.addFunction(
  "bar",
  binaryen.Type.none,
  binaryen.Type.none,
  [],
  module.return_call_indirect(
    "0",
    module.i32.const(0),
    [],
    binaryen.Type.none,
    binaryen.Type.none
  )
);

assert(module.validate());

console.log(
  binaryen.getExpressionInfo(binaryen.getFunctionInfo(foo).body).isReturn
);

console.log(
  binaryen.getExpressionInfo(binaryen.getFunctionInfo(bar).body).isReturn
);
