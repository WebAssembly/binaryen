(function() {
  var mod = new Binaryen.Module();
  var funcType = mod.addFunctionType("v", Binaryen.void, []);
  var func = mod.addFunction("test", funcType, [],
    mod.block("", [
      mod.drop(
        mod.globalGet("missing", Binaryen.i32)
      )
    ])
  );
  mod.addExport("test", func);
  console.log(mod.validate())
})();

(function() {
  var mod = new Binaryen.Module();
  var funcType = mod.addFunctionType("v", Binaryen.void, []);
  var func = mod.addFunction("test", funcType, [],
    mod.block("", [
      mod.drop(
        mod.localGet(0, Binaryen.i32)
      )
    ])
  );
  mod.addFunctionExport("test", "test", func);
  console.log(mod.validate())
})();

