var module = new binaryen.Module();

module.setFeatures(binaryen.Features.TailCall);

module.addTableImport("0", "env", "table");

var foo = module.addFunction(
  "foo",
  binaryen.void,
  binaryen.void,
  [],
  module.return_call("foo", [], binaryen.void, binaryen.void)
);

var bar = module.addFunction(
  "bar",
  binaryen.void,
  binaryen.void,
  [],
  module.return_call_indirect(
    "0",
    module.i32.const(0),
    [],
    binaryen.void,
    binaryen.void
  )
);

assert(module.validate());

console.log(
  binaryen.getExpressionInfo(binaryen.getFunctionInfo(foo).body).isReturn
);

console.log(
  binaryen.getExpressionInfo(binaryen.getFunctionInfo(bar).body).isReturn
);
