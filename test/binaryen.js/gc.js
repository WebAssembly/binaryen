var module = new binaryen.Module();

var builder = new binaryen.TypeBuilder(1);
builder.setArrayType(0, binaryen.i32);
var [arrayHeapType] = builder.buildAndDispose();

var arrayType = binaryen.getTypeFromHeapType(arrayHeapType);

module.addGlobal("global-array",
    arrayType,
    true,
    module.array.new_default(
        binaryen.getHeapType(arrayType),
        module.i32.const(4)
    )
);

console.log(module.emitText());
