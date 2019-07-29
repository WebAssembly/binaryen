function assert(x) {
  if (!x) throw 'error!';
}

var module = new Binaryen.Module();

var signature = module.addFunctionType("ii", Binaryen.i32, [ Binaryen.i32 ]);

module.addFunction("main", signature, [], module.local.get(0, Binaryen.i32));

module.addFunctionExport("main", "main");

assert(module.validate()); // should validate before calling emitAsmjs

console.log(module.emitAsmjs());
