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

// Test wrapper

func = module.addFunction("b-function",
  binaryen.createType([binaryen.i32, binaryen.i32]),
  binaryen.i32,
  [ binaryen.i32, binaryen.f64 ],
  module.local.tee(2,
    module.i32.add(
      module.local.get(0, binaryen.i32),
      module.local.get(1, binaryen.i32)
    ),
    binaryen.i32
  )
);
binaryen.Function.setLocalName(func, 0, "a");
binaryen.Function.setLocalName(func, 1, "b");
binaryen.Function.setLocalName(func, 2, "ret");
binaryen.Function.setLocalName(func, 3, "unused");

var theFunc = binaryen.Function(func);
assert(theFunc.name === "b-function");
assert(theFunc.params === binaryen.createType([binaryen.i32, binaryen.i32]));
assert(theFunc.results === binaryen.i32);
assert(theFunc.numVars === 2);
assert(theFunc.getVar(0) === binaryen.i32);
assert(theFunc.getVar(1) === binaryen.f64);
assert(theFunc.numLocals === 4);
assert(theFunc.getLocalName(0) === "a");
assert(theFunc.getLocalName(1) === "b");
assert(theFunc.getLocalName(2) === "ret");
assert(theFunc.getLocalName(3) === "unused");
theFunc.setLocalName(2, "res");
assert(theFunc.getLocalName(2) === "res");
assert((theFunc | 0) === func);

assert(module.validate());

console.log(module.emitText());

module.dispose();
