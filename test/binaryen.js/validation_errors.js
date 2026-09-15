(function() {
  var mod = new binaryen.Module();
  var func = mod.addFunction("test", binaryen.void, binaryen.void, [],
    mod.block("", [
      mod.drop(
        mod.global.get("missing", binaryen.i32)
      )
    ])
  );
  mod.addExport("test", "test");
  console.log(mod.validate())
})();

(function() {
  var mod = new binaryen.Module();
  var func = mod.addFunction("test", binaryen.void, binaryen.void, [],
    mod.block("", [
      mod.drop(
        mod.local.get(0, binaryen.i32)
      )
    ])
  );
  mod.addFunctionExport("test", "test");
  console.log(mod.validate())
})();
