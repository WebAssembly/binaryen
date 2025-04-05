var builder = new binaryen.TypeBuilder(1);
builder.setSignatureType(0, binaryen.i32, binaryen.notPacked, true);
builder.setStructType(1, binaryen.i32, binaryen.notPacked, true);
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
module.setFeatures(binaryen.Features.ReferenceTypes | binaryen.Features.GC);

module.setMemory(1, -1, null, [
  { offset: 0, data: [4, 3, 2, 1] }
]);

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

module.addGlobal("global-array.new_data",
  arrayType,
  true,
  module.array.new_data(
    binaryen.getHeapType(arrayType),
    "0",
    module.i32.const(0),
    module.i32.const(4)
  )
);

module.addFunction("main", binaryen.none, binaryen.none, [],
  module.block(null, [
    // ...
  ], binaryen.none)
);

console.log(module.emitText());
