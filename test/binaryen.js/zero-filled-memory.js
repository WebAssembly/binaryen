var wast = String.raw`
(module
 (import "env" "memory" (memory $0 1))
 (data (i32.const 1024) "\00\00\00\00")
 (export "memory" (memory $0))
)
`;

console.log("=== input wast ===" + wast);

var module = binaryen.parseText(wast);

console.log("=== unoptimized ===");
assert(module.validate());
console.log(module.emitText());

console.log("=== optimized, zeroFilledMemory=" + binaryen.getZeroFilledMemory() + " ===");
module.optimize();
assert(module.validate());
console.log(module.emitText());

binaryen.setZeroFilledMemory(true);
assert(binaryen.getZeroFilledMemory());
console.log();

console.log("=== optimized, zeroFilledMemory=" + binaryen.getZeroFilledMemory() + " ===");
module.optimize();
assert(module.validate());
console.log(module.emitText());

module.dispose();
