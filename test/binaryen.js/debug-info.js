var wast = `
(module
 (type $v (func))
 (memory $0 0)
 (export "test" (func $test))
 (func $test (; 0 ;) (type $v))
)
`;

// Use defaults (should not emit debug info)
console.log("=== default ===");
console.log("debugInfo=" + binaryen.getDebugInfo());
var module = binaryen.parseText(wast);
var binary = module.emitBinary();
module.dispose();
module = binaryen.readBinary(binary);
console.log(module.emitText());
assert(module.validate());
module.dispose();

// With debug info
console.log("=== with debug info ===");
binaryen.setDebugInfo(true);
console.log("debugInfo=" + binaryen.getDebugInfo());
module = binaryen.parseText(wast);
binary = module.emitBinary();
module.dispose();
module = binaryen.readBinary(binary);
console.log(module.emitText());
assert(module.validate());
module.dispose();

// Without debug info
console.log("=== without debug info ===");
binaryen.setDebugInfo(false);
console.log("debugInfo=" + binaryen.getDebugInfo());
module = binaryen.parseText(wast);
binary = module.emitBinary();
module.dispose();
module = binaryen.readBinary(binary);
console.log(module.emitText());
assert(module.validate());
module.dispose();
