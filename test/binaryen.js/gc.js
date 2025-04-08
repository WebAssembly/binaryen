var builder = new binaryen.TypeBuilder(3);
builder.setSignatureType(0, binaryen.createType([binaryen.i32]), binaryen.none);
builder.setStructType(1, [
  { type: binaryen.i32, packedType: binaryen.notPacked, mutable: true },
  { type: binaryen.f64, packedType: binaryen.notPacked, mutable: true }
]);
builder.setArrayType(2, binaryen.i32, binaryen.notPacked, true);
var [
  signatureHeapType,
  structHeapType,
  arrayHeapType
] = builder.buildAndDispose();

var signatureType = binaryen.getTypeFromHeapType(signatureHeapType);
var structType = binaryen.getTypeFromHeapType(structHeapType);
var arrayType = binaryen.getTypeFromHeapType(arrayHeapType);

var module = new binaryen.Module();
module.setFeatures(binaryen.Features.ReferenceTypes | binaryen.Features.BulkMemory | binaryen.Features.GC);

module.setMemory(1, -1, null, [
  { offset: module.i32.const(0), data: [4, 3, 2, 1] }
]);

module.addGlobal("global-struct.new",
  structType,
  true,
  module.struct.new(
    [
      module.i32.const(123),
      module.f64.const(123.456)
    ],
    binaryen.getHeapType(structType)
  )
);

module.addGlobal("global-struct.new_default",
  structType,
  true,
  module.struct.new_default(
    binaryen.getHeapType(structType)
  )
);

module.addGlobal("global-array.new",
  arrayType,
  true,
  module.array.new(
    binaryen.getHeapType(arrayType),
    module.i32.const(4),
    module.i32.const(123)
  )
);

module.addGlobal("global-array.new_default",
  arrayType,
  true,
  module.array.new_default(
    binaryen.getHeapType(arrayType),
    module.i32.const(4)
  )
);

module.addGlobal("global-array.new_fixed",
  arrayType,
  true,
  module.array.new_fixed(
    binaryen.getHeapType(arrayType),
    [
      module.i32.const(1),
      module.i32.const(2),
      module.i32.const(3),
      module.i32.const(4)
    ]
  )
);

module.addFunction("main", binaryen.none, binaryen.none, [binaryen.i32, binaryen.f64],
  module.block(null, [
    module.global.set("global-array.new_default",
      module.array.new_data(
        binaryen.getHeapType(arrayType),
        "0",
        module.i32.const(0),
        module.i32.const(4)
      )
    ),
    
    module.array.copy(
      module.global.get("global-array.new_fixed", arrayType),
      module.i32.const(0),
      module.global.get("global-array.new_default", arrayType),
      module.i32.const(0),
      module.array.len(
        module.global.get("global-array.new_default", arrayType)
      )
    ),
    module.array.set(
      module.global.get("global-array.new", arrayType),
      module.i32.const(2),
      module.array.get(
        module.global.get("global-array.new_default", arrayType),
        module.i32.const(0),
        binaryen.i32,
        false
      )
    ),

    module.local.set(0, module.struct.get(0, module.global.get("global-struct.new", structType), false)),
    module.struct.set(
      1,
      module.global.get("global-struct.new_default", structType),
      module.f64.convert_u.i32(
        module.local.get(0, binaryen.i32)
      )
    )
  ], binaryen.none)
);

assert(module.validate());

console.log(module.emitText());
