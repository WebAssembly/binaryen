var wast = `
(module $hello
 (global $world i32 (i32.const 0))
 (func $of (param $wasm i32)
  (local $!#$%&'*+-./:<=>?@\\^_\`|~ f64)
 )
)
`;
// Note that global names are not yet covered by the name section, so it is
// expected that the global's name is lost after roundtripping.

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

module2.dispose();
