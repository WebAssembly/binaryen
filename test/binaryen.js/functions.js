function assert(x) {
  if (!x) throw 'error!';
}

function cleanInfo(info) {
  var ret = {};
  for (var x in info) {
    if (x !== 'name' && x !== 'body' && x !== 'type') {
      ret[x] = info[x];
    }
  }
  return ret;
}

function test() {
  var module = new Binaryen.Module();

  var func = module.addFunction("a-function", Binaryen.none, Binaryen.i32, [],
    module.i32.add(
      module.i32.const(1),
      module.i32.const(2)
    )
  );

  console.log("GetFunction is equal: " + (func === module.getFunction("a-function")));

  module.runPassesOnFunction(func, ["precompute"]);

  var funcInfo = Binaryen.getFunctionInfo(func);
  console.log("getFunctionInfo=" + JSON.stringify(cleanInfo(funcInfo)));
  var expInfo = Binaryen.getExpressionInfo(funcInfo.body);
  console.log("getExpressionInfo(body)=" + JSON.stringify(cleanInfo(expInfo)));
  console.log(Binaryen.emitText(funcInfo.body));

  module.removeFunction("a-function");

  assert(module.validate());

  console.log(module.emitText());
}

Binaryen.ready.then(test);
