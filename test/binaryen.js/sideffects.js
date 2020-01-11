function assert(x) {
  if (!x) throw 'error!';
}

function test() {

  console.log("SideEffects.None=" + Binaryen.SideEffects.None);
  console.log("SideEffects.Branches=" + Binaryen.SideEffects.Branches);
  console.log("SideEffects.Calls=" + Binaryen.SideEffects.Calls);
  console.log("SideEffects.ReadsLocal=" + Binaryen.SideEffects.ReadsLocal);
  console.log("SideEffects.WritesLocal=" + Binaryen.SideEffects.WritesLocal);
  console.log("SideEffects.ReadsGlobal=" + Binaryen.SideEffects.ReadsGlobal);
  console.log("SideEffects.WritesGlobal=" + Binaryen.SideEffects.WritesGlobal);
  console.log("SideEffects.ReadsMemory=" + Binaryen.SideEffects.ReadsMemory);
  console.log("SideEffects.WritesMemory=" + Binaryen.SideEffects.WritesMemory);
  console.log("SideEffects.ImplicitTrap=" + Binaryen.SideEffects.ImplicitTrap);
  console.log("SideEffects.IsAtomic=" + Binaryen.SideEffects.IsAtomic);
  console.log("SideEffects.Any=" + Binaryen.SideEffects.Any);

  var module = new Binaryen.Module();
  assert(
    Binaryen.getSideEffects(
      module.i32.const(1)
    )
    ==
    Binaryen.SideEffects.None
  );
  assert(
    Binaryen.getSideEffects(
      module.br("test")
    )
    ==
    Binaryen.SideEffects.Branches
  );
  assert(
    Binaryen.getSideEffects(
      module.call("test", [], Binaryen.i32)
    )
    ==
    Binaryen.SideEffects.Calls
  );
  assert(
    Binaryen.getSideEffects(
      module.local.get("test", Binaryen.i32)
    )
    ==
    Binaryen.SideEffects.ReadsLocal
  );
  assert(
    Binaryen.getSideEffects(
      module.local.set("test",
        module.i32.const(1)
      )
    )
    ==
    Binaryen.SideEffects.WritesLocal
  );
  assert(
    Binaryen.getSideEffects(
      module.global.get("test", Binaryen.i32)
    )
    ==
    Binaryen.SideEffects.ReadsGlobal
  );
  assert(
    Binaryen.getSideEffects(
      module.global.set("test", module.i32.const(1))
    )
    ==
    Binaryen.SideEffects.WritesGlobal
  );
  assert(
    Binaryen.getSideEffects(
      module.i32.load(0, 0,
        module.i32.const(0)
      )
    )
    ==
    Binaryen.SideEffects.ReadsMemory | Binaryen.SideEffects.ImplicitTrap
  );
  assert(
    Binaryen.getSideEffects(
      module.i32.store(0, 0,
        module.i32.const(0),
        module.i32.const(1)
      )
    )
    ==
    Binaryen.SideEffects.WritesMemory | Binaryen.SideEffects.ImplicitTrap
  );
  assert(
    Binaryen.getSideEffects(
      module.i32.div_s(
        module.i32.const(1),
        module.i32.const(0)
      )
    )
    ==
    Binaryen.SideEffects.ImplicitTrap
  );
}

Binaryen.ready.then(test);
