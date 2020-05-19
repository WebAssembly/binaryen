var wast = `
(module
 (memory $0 1)
 (export "test" (func $test))
 (func $test (param $0 i32) (result i32)
  (i32.load
    (i32.add
      (local.get $0)
      (i32.const 128)
    )
  )
 )
)
`;

console.log("=== input wast ===" + wast);

var module = binaryen.parseText(wast);

console.log("=== unoptimized ===");
assert(module.validate());
console.log(module.emitText());

console.log("=== optimized, lowMemoryUnused=" + binaryen.getLowMemoryUnused() + " ===");
module.optimize();
assert(module.validate());
console.log(module.emitText());

module = binaryen.parseText(wast);
binaryen.setLowMemoryUnused(true);
assert(binaryen.getLowMemoryUnused());
console.log();

console.log("=== optimized, lowMemoryUnused=" + binaryen.getLowMemoryUnused() + " ===");
module.optimize();
assert(module.validate());
console.log(module.emitText());

module.dispose();
