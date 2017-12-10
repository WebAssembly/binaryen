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

console.log("getFunctionTypeInfo=" + JSON.stringify(Binaryen.getFunctionTypeInfo(signature)));
var info = Binaryen.getFunctionInfo(func);
console.log("getFunctionInfo=" + JSON.stringify(info));
console.log("getExpressionInfo(body)=" + JSON.stringify(Binaryen.getExpressionInfo(info.body)));
console.log(Binaryen.emitText(info.body));

module.removeFunction("a-function");

module.addGlobal("a-global", Binaryen.i32, false, info.body);

module.validate();

console.log(module.emitText());
