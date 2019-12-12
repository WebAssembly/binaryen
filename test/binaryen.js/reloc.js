function assert(x) {
  if (!x) throw 'error!';
}

var module = new Binaryen.Module();

// memory with offset

module.addGlobalImport("memory_base", "env", "memory_base", Binaryen.i32, false);
module.setMemory(1, -1, null, [
  {
    offset: module.global.get("memory_base", Binaryen.i32),
    data: "data data".split('').map(function(x) { return x.charCodeAt(0) })
  }
]);

// table with offset

var func = module.addFunction("func", Binaryen.none, Binaryen.none, [], module.nop());

module.addGlobalImport("table_base", "env", "table_base", Binaryen.i32, false);
module.setFunctionTable(1, -1, [ "func", "func" ], module.global.get("table_base", Binaryen.i32));

assert(module.validate());
console.log(module.emitText());
