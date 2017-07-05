var module = new Binaryen.Module();

var signature = module.addFunctionType("v", Binaryen.none, []);
module.addImport("fn", "env", "fn", signature);

module.addFunction("main", signature, [], module.block("", [
  module.call("fn", [], Binaryen.none) // should be callImport
]));
module.addExport("main", "main");

console.log(module.emitText());

module.validate(); // fails
