function assert(x) {
  if (!x) throw 'error!';
}

var module = new Binaryen.Module();

module.addFunction("main", Binaryen.i32, Binaryen.i32, [], module.local.get(0, Binaryen.i32));

module.addFunctionExport("main", "main");

assert(module.validate()); // should validate before calling emitAsmjs

console.log(module.emitAsmjs());
