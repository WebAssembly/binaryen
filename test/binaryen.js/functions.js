function cleanInfo(info) {
  var ret = {};
  for (var x in info) {
    if (x !== 'name' && x !== 'body' && x !== 'type') {
      ret[x] = info[x];
    }
  }
  return ret;
}

var module = new binaryen.Module();

var func = module.addFunction("a-function", binaryen.none, binaryen.i32, [],
  module.i32.add(
    module.i32.const(1),
    module.i32.const(2)
  )
);

console.log("GetFunction is equal: " + (func === module.getFunction("a-function")));

module.runPassesOnFunction(func, ["precompute"]);

var funcInfo = binaryen.getFunctionInfo(func);
console.log("getFunctionInfo=" + JSON.stringify(cleanInfo(funcInfo)));
var expInfo = binaryen.getExpressionInfo(funcInfo.body);
console.log("getExpressionInfo(body)=" + JSON.stringify(cleanInfo(expInfo)));
console.log(binaryen.emitText(funcInfo.body));

module.removeFunction("a-function");

assert(module.validate());

console.log(module.emitText());
