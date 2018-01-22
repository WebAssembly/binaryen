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
console.log("debugInfo=" + Binaryen.getDebugInfo());
var module = Binaryen.parseText(wast);
var binary = module.emitBinary();
module.dispose();
module = Binaryen.readBinary(binary);
console.log(module.emitText());
module.dispose();

// With debug info
console.log("=== with debug info ===");
Binaryen.setDebugInfo(true);
console.log("debugInfo=" + Binaryen.getDebugInfo());
module = Binaryen.parseText(wast);
binary = module.emitBinary();
module.dispose();
module = Binaryen.readBinary(binary);
console.log(module.emitText());
module.dispose();

// Without debug info
console.log("=== without debug info ===");
Binaryen.setDebugInfo(false);
console.log("debugInfo=" + Binaryen.getDebugInfo());
module = Binaryen.parseText(wast);
binary = module.emitBinary();
module.dispose();
module = Binaryen.readBinary(binary);
console.log(module.emitText());
module.dispose();
