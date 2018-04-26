function cleanInfo(info) {
  var ret = {};
  for (var x in info) {
    if (x !== 'name' && x !== 'body' && x !== 'type') {
      ret[x] = info[x];
    }
  }
  return ret;
}

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

var sigInfo = Binaryen.getFunctionTypeInfo(signature);
console.log("getFunctionTypeInfo=" + JSON.stringify(cleanInfo(sigInfo)));
var funcInfo = Binaryen.getFunctionInfo(func);
console.log("getFunctionInfo=" + JSON.stringify(cleanInfo(funcInfo)));
var expInfo = Binaryen.getExpressionInfo(funcInfo.body);
console.log("getExpressionInfo(body)=" + JSON.stringify(cleanInfo(expInfo)));
console.log(Binaryen.emitText(funcInfo.body));

module.removeFunction("a-function");

module.addGlobal("a-global", Binaryen.i32, false, funcInfo.body);

module.validate();

console.log(module.emitText());
