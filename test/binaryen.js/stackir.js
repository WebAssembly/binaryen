var wast = `
(module
 (type $i (func (param i32) (result i32)))
 (memory $0 0)
 (export "test" (func $test))
 (func $test (; 0 ;) (type $i) (param $0 i32) (result i32)
  (block (result i32)
   (block (result i32)
    (if (result i32)
     (get_local $0)
     (get_local $0)
     (i32.const 0)
    )
   )
  )
 )
)
`;
console.log("=== input wast ===" + wast);

var module = Binaryen.parseText(wast);

console.log("=== default ===");
console.log(module.emitStackIR());

console.log("=== optimize ==="); // should omit the second block
console.log(module.emitStackIR(true));
