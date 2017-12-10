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

var info = Binaryen.getFunction(func);
console.log("getFunction=" + JSON.stringify(info));
console.log("getExpression=" + JSON.stringify(Binaryen.getExpression(info.body)));
console.log(Binaryen.emitText(info.body));

module.removeFunction("a-function");

module.addGlobal("a-global", Binaryen.i32, false, info.body);

module.validate();

console.log(module.emitText());
