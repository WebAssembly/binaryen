(function() {
  var mod = new binaryen.Module();
  var func = mod.addFunction("test", binaryen.none, binaryen.none, [],
    mod.block("", [
      mod.drop(
        mod.global.get("missing", binaryen.i32)
      )
    ])
  );
  mod.addExport("test", func);
  console.log(mod.validate())
})();

(function() {
  var mod = new binaryen.Module();
  var func = mod.addFunction("test", binaryen.none, binaryen.none, [],
    mod.block("", [
      mod.drop(
        mod.local.get(0, binaryen.i32)
      )
    ])
  );
  mod.addFunctionExport("test", "test", func);
  console.log(mod.validate())
})();
