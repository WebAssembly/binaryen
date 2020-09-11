var wast = `
(module $hello
 (global $world i32 (i32.const 0))
 (func $of
  (local $wasm i32)
  (local $!#$%&'*+-./:<=>?@\\^_\`|~ f64)
 )
)
`;
// Note that global names are not yet covered by the name section, so it is
// expected that the global's name is lost after roundtripping.

console.log("=== input wast ===" + wast);

var module = binaryen.parseText(wast);

console.log("=== parsed wast ===\n" + module.emitText());

binaryen.setDebugInfo(true);

var module2 = binaryen.readBinary(module.emitBinary());

module.dispose();

console.log("=== roundtripped ===\n" + module2.emitText());

module2.dispose();
