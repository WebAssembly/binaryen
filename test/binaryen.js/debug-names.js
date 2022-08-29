var wast = `
(module $hel
 (memory $lo 0 0)
 (table $wor 0 0 funcref)
 (global $ld i32 (i32.const 0))
 (func $of (param $wasm i32)
  (local $!#$%&'*+-./:<=>?@\\^_\`|~ f64)
 )
)
`;

console.log("=== input wast ===" + wast);

var module = binaryen.parseText(wast);

console.log("=== parsed wast ===\n" + module.emitText());

var func = binaryen.Function(module.getFunction("of"));
assert(func.numLocals === 2);
assert(func.hasLocalName(0) === true);
assert(func.getLocalName(0) === "wasm");
assert(func.hasLocalName(1) === true);
assert(func.getLocalName(1) === "!#$%&'*+-./:<=>?@\\^_\`|~");
assert(func.hasLocalName(2) === false);
func.setLocalName(0, "js");
assert(func.getLocalName(0) === "js");

binaryen.setDebugInfo(true);

var module2 = binaryen.readBinary(module.emitBinary());

module.dispose();

console.log("=== roundtripped ===\n" + module2.emitText());

var module3 = binaryen.readBinary(module2.emitBinary());

module2.dispose();

console.log("=== roundtripped again ===\n" + module3.emitText());

module3.dispose();
