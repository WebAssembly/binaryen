var module = new Binaryen.Module();
var signature = module.addFunctionType("i", Binaryen.i32, []);

var theCall;

var outer = module.addFunction("outer", signature, [],
  theCall = module.call("inner", [], Binaryen.i32),
);

var inner = module.addFunction("inner", signature, [],
  module.i32.const(42)
);

console.log("=== before ===");
module.validate();
console.log(module.emitText());

if (module.forceInline(outer, theCall)) {
  module.removeFunction("inner");
}

console.log("=== after ===");
module.validate();
console.log(module.emitText());
