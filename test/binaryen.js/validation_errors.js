function test() {
  (function() {
    var mod = new Binaryen.Module();
    var func = mod.addFunction("test", Binaryen.none, Binaryen.none, [],
      mod.block("", [
        mod.drop(
          mod.global.get("missing", Binaryen.i32)
        )
      ])
    );
    mod.addExport("test", func);
    console.log(mod.validate())
  })();

  (function() {
    var mod = new Binaryen.Module();
    var func = mod.addFunction("test", Binaryen.none, Binaryen.none, [],
      mod.block("", [
        mod.drop(
          mod.local.get(0, Binaryen.i32)
        )
      ])
    );
    mod.addFunctionExport("test", "test", func);
    console.log(mod.validate())
  })();
}

Binaryen.ready.then(test);
