var module = new binaryen.Module();

// memory with offset

module.addGlobalImport("memory_base", "env", "memory_base", binaryen.i32, false);
module.setMemory(1, -1, null, [
  {
    offset: module.global.get("memory_base", binaryen.i32),
    data: "data data".split('').map(function(x) { return x.charCodeAt(0) })
  }
]);

// table with offset

var func = module.addFunction("func", binaryen.none, binaryen.none, [], module.nop());

module.addGlobalImport("table_base", "env", "table_base", binaryen.i32, false);
module.setFunctionTable(1, -1, [ "func", "func" ], module.global.get("table_base", binaryen.i32));

assert(module.validate());
console.log(module.emitText());
