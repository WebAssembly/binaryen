Binaryen.ready.then(main, function(err) { throw err; });

function testMissingGlobal() {
  var mod = new Binaryen.Module();
  var funcType = mod.addFunctionType("v", Binaryen.void, []);
  var func = mod.addFunction("test", funcType, [],
    mod.block("", [
      mod.drop(
        mod.getGlobal("missing", Binaryen.i32)
      )
    ])
  );
  mod.addExport("test", func);
  console.log(mod.validate())
}

function testMissingLocal() {
  var mod = new Binaryen.Module();
  var funcType = mod.addFunctionType("v", Binaryen.void, []);
  var func = mod.addFunction("test", funcType, [],
    mod.block("", [
      mod.drop(
        mod.getLocal(0, Binaryen.i32)
      )
    ])
  );
  mod.addFunctionExport("test", "test", func);
  console.log(mod.validate())
}

function main() {
  testMissingGlobal();
  testMissingLocal();
}
