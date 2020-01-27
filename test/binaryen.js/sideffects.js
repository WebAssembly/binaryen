console.log("SideEffects.None=" + binaryen.SideEffects.None);
console.log("SideEffects.Branches=" + binaryen.SideEffects.Branches);
console.log("SideEffects.Calls=" + binaryen.SideEffects.Calls);
console.log("SideEffects.ReadsLocal=" + binaryen.SideEffects.ReadsLocal);
console.log("SideEffects.WritesLocal=" + binaryen.SideEffects.WritesLocal);
console.log("SideEffects.ReadsGlobal=" + binaryen.SideEffects.ReadsGlobal);
console.log("SideEffects.WritesGlobal=" + binaryen.SideEffects.WritesGlobal);
console.log("SideEffects.ReadsMemory=" + binaryen.SideEffects.ReadsMemory);
console.log("SideEffects.WritesMemory=" + binaryen.SideEffects.WritesMemory);
console.log("SideEffects.ImplicitTrap=" + binaryen.SideEffects.ImplicitTrap);
console.log("SideEffects.IsAtomic=" + binaryen.SideEffects.IsAtomic);
console.log("SideEffects.MayThrow=" + binaryen.SideEffects.MayThrow);
console.log("SideEffects.Any=" + binaryen.SideEffects.Any);

var module = new binaryen.Module();
assert(
  binaryen.getSideEffects(
    module.i32.const(1)
  )
  ==
  binaryen.SideEffects.None
);
assert(
  binaryen.getSideEffects(
    module.br("test")
  )
  ==
  binaryen.SideEffects.Branches
);
assert(
  binaryen.getSideEffects(
    module.call("test", [], binaryen.i32)
  )
  ==
  binaryen.SideEffects.Calls
);
assert(
  binaryen.getSideEffects(
    module.local.get("test", binaryen.i32)
  )
  ==
  binaryen.SideEffects.ReadsLocal
);
assert(
  binaryen.getSideEffects(
    module.local.set("test",
      module.i32.const(1)
    )
  )
  ==
  binaryen.SideEffects.WritesLocal
);
assert(
  binaryen.getSideEffects(
    module.global.get("test", binaryen.i32)
  )
  ==
  binaryen.SideEffects.ReadsGlobal
);
assert(
  binaryen.getSideEffects(
    module.global.set("test", module.i32.const(1))
  )
  ==
  binaryen.SideEffects.WritesGlobal
);
assert(
  binaryen.getSideEffects(
    module.i32.load(0, 0,
      module.i32.const(0)
    )
  )
  ==
  binaryen.SideEffects.ReadsMemory | binaryen.SideEffects.ImplicitTrap
);
assert(
  binaryen.getSideEffects(
    module.i32.store(0, 0,
      module.i32.const(0),
      module.i32.const(1)
    )
  )
  ==
  binaryen.SideEffects.WritesMemory | binaryen.SideEffects.ImplicitTrap
);
assert(
  binaryen.getSideEffects(
    module.i32.div_s(
      module.i32.const(1),
      module.i32.const(0)
    )
  )
  ==
  binaryen.SideEffects.ImplicitTrap
);

// If exception handling feature is enabled, calls can throw
var module_all_features = new binaryen.Module();
module_all_features.setFeatures(binaryen.Features.All);
assert(
  binaryen.getSideEffects(
    module.call("test", [], binaryen.i32)
  )
  ==
  binaryen.SideEffects.Calls | binaryen.SideEffects.MayThrow
);
