var module = new binaryen.Module();

module.addFunction("main", binaryen.i32, binaryen.i32, [], module.local.get(0, binaryen.i32));

module.addFunctionExport("main", "main");

assert(module.validate()); // should validate before calling emitAsmjs

console.log(module.emitAsmjs());
