var module = Binaryen.parseText(`
(module
  (memory $0 (shared 1 1))
)
`);

var signature = module.addFunctionType("v", Binaryen.none, []);

// i32/i64.atomic.load/store
module.addFunction("main", signature, [], module.block("", [
  // i32
  module.i32.atomic.store(0,
    module.i32.const(0),
    module.i32.atomic.load(0,
      module.i32.const(0)
    )
  ),
  // i32 as u8
  module.i32.atomic.store8(0,
    module.i32.const(0),
    module.i32.atomic.load8_u(0,
      module.i32.const(0)
    )
  ),
  // i32 as u16
  module.i32.atomic.store16(0,
    module.i32.const(0),
    module.i32.atomic.load16_u(0,
      module.i32.const(0)
    )
  ),
  // i64
  module.i64.atomic.store(0,
    module.i32.const(0),
    module.i64.atomic.load(0,
      module.i32.const(0)
    )
  ),
  // i64 as u8
  module.i64.atomic.store8(0,
    module.i32.const(0),
    module.i64.atomic.load8_u(0,
      module.i32.const(0)
    )
  ),
  // i64 as u16
  module.i64.atomic.store16(0,
    module.i32.const(0),
    module.i64.atomic.load16_u(0,
      module.i32.const(0)
    )
  ),
  // i64 as u32
  module.i64.atomic.store32(0,
    module.i32.const(0),
    module.i64.atomic.load32_u(0,
      module.i32.const(0)
    )
  )
]));

module.validate();
console.log(module.emitText());
