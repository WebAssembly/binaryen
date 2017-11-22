var module = new Binaryen.Module();

var signature = module.addFunctionType("i", Binaryen.i32, []);

var func = module.addFunction("a-function", signature, [],
  module.i32.add(
    module.i32.const(1),
    module.i32.const(2)
  )
);

console.log("GetFunction is equal: " + (func === module.getFunction("a-function")));

module.runPassesOnFunction(func, ["precompute"]);

var body = Binaryen.getFunctionBody(func);

console.log("ExpressionId=" + Binaryen.getExpressionId(body));
console.log("ExpressionType=" + Binaryen.getExpressionType(body));
console.log(Binaryen.emitText(body));

module.removeFunction("a-function");

module.addGlobal("a-global", Binaryen.i32, false, body);

module.validate();

console.log(module.emitText());
