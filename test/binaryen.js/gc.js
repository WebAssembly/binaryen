var builder = new binaryen.TypeBuilder(4);
builder.setSignatureType(0, binaryen.createType([binaryen.i32]), binaryen.none);
builder.setStructType(1, [
  { type: binaryen.i32, packedType: binaryen.i16, mutable: true },
  { type: binaryen.f64, packedType: binaryen.notPacked, mutable: true }
]);
builder.setArrayType(2, binaryen.i32, binaryen.i8, true);
builder.setArrayType(3, binaryen.funcref, binaryen.notPacked, true);
var [
  signatureHeapType,
  structHeapType,
  arrayHeapType,
  funcArrayHeapType
] = builder.buildAndDispose();

var signatureType = binaryen.getTypeFromHeapType(signatureHeapType, true);
var structType = binaryen.getTypeFromHeapType(structHeapType, true);
var arrayType = binaryen.getTypeFromHeapType(arrayHeapType, true);
var funcArrayType = binaryen.getTypeFromHeapType(funcArrayHeapType, true);

var module = new binaryen.Module();
module.setFeatures(binaryen.Features.ReferenceTypes | binaryen.Features.BulkMemory | binaryen.Features.GC);

module.addFunction("add", binaryen.createType([binaryen.i32, binaryen.i32]), binaryen.i32, [],
  module.i32.add(
    module.local.get("0", binaryen.i32),
    module.local.get("1", binaryen.i32)
  )
);

module.setMemory(1, -1, null, [
  { offset: module.i32.const(0), data: [4, 3, 2, 1] }
]);

module.addTable("0", 1, -1);
module.addActiveElementSegment("0", "0", ["add"]);

module.addGlobal("struct-global",
  structType,
  true,
  module.struct.new_default(
    binaryen.getHeapType(structType)
  )
);

module.addGlobal("array-global",
  arrayType,
  true,
  module.array.new_default(
    binaryen.getHeapType(arrayType),
    module.i32.const(4)
  )
);

module.addGlobal("funcArray-global",
  funcArrayType,
  true,
  module.array.new_default(
    binaryen.getHeapType(funcArrayType),
    module.i32.const(4)
  )
);

var valueList = [
  // ref

  // struct
  module.struct.new(
    [
      module.i32.const(1),
      module.f64.const(2.3)
    ],
    binaryen.getHeapType(structType)
  ),
  module.struct.new_default(
    binaryen.getHeapType(structType)
  ),
  module.struct.get(
    0,
    module.global.get("struct-global", structType),
    binaryen.i32,
    true
  ),
  module.struct.set(
    1,
    module.global.get("struct-global", structType),
    module.f64.const(1.23)
  ),

  // array
  module.array.new(
    binaryen.getHeapType(arrayType),
    module.i32.const(1),
    module.i32.const(0)
  ),
  module.array.new_default(
    binaryen.getHeapType(arrayType),
    module.i32.const(1)
  ),
  module.array.new_fixed(
    binaryen.getHeapType(arrayType),
    [
      module.i32.const(1),
      module.i32.const(2),
      module.i32.const(3)
    ]
  ),
  module.array.new_data(
    binaryen.getHeapType(arrayType),
    "0",
    module.i32.const(0),
    module.i32.const(4)
  ),
  module.array.new_elem(
    binaryen.getHeapType(funcArrayType),
    "0",
    module.i32.const(0),
    module.i32.const(1)
  ),
  module.array.get(
    module.global.get("array-global", arrayType),
    module.i32.const(0),
    binaryen.i32,
    true
  ),
  module.array.set(
    module.global.get("array-global", arrayType),
    module.i32.const(1),
    module.i32.const(2)
  ),
  module.array.len(
    module.global.get("array-global", arrayType)
  ),
  module.array.fill(
    module.global.get("array-global", arrayType),
    module.i32.const(0),
    module.i32.const(1),
    module.i32.const(2)
  ),
  module.array.copy(
    module.global.get("array-global", arrayType),
    module.i32.const(0),
    module.global.get("array-global", arrayType),
    module.i32.const(1),
    module.i32.const(2)
  ),
  module.array.init_data(
    "0",
    module.global.get("array-global", arrayType),
    module.i32.const(0),
    module.i32.const(1),
    module.i32.const(2)
  ),
  module.array.init_elem(
    "0",
    module.global.get("funcArray-global", funcArrayType),
    module.i32.const(0),
    module.i32.const(1),
    module.i32.const(2)
  )
];
module.addFunction("main", binaryen.none, binaryen.none, [],
  module.block(
    null,
    valueList.map(value => {
      var type = binaryen.getExpressionType(value);
      if (type === binaryen.none || type === binaryen.unreachable)
        return value;
      else
        return module.drop(value);
    }),
    binaryen.none
  )
);

assert(module.validate());

console.log(module.emitText());
