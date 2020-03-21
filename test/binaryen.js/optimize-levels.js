var wast = `
(module
 (type $i (func (param i32) (result i32)))
 (memory $0 0)
 (export "test" (func $test))
 (func $test (; 0 ;) (type $i) (param $0 i32) (result i32)
  (block (result i32)
   (if (result i32)
    (local.get $0)
    (local.get $0)
    (i32.const 0)
   )
  )
 )
)
`;

console.log("=== input wast ===" + wast);

function printOptions() {
  console.log("optimizeLevel=" + binaryen.getOptimizeLevel());
  console.log("shrinkLevel=" + binaryen.getShrinkLevel());
}

// Use defaults (should be equal to -Os below)
var module = binaryen.parseText(wast);

console.log("=== unoptimized ===");
assert(module.validate());
console.log(module.emitText());

module.optimize();
console.log("=== optimized using defaults ===");
printOptions();
assert(module.validate());
console.log(module.emitText());
module.dispose();

// Use -O0 (should remove the block)
module = binaryen.parseText(wast);

binaryen.setOptimizeLevel(0);
binaryen.setShrinkLevel(0);
module.optimize();
console.log("=== optimized with -O0 ===");
printOptions();
assert(module.validate());
console.log(module.emitText());
module.dispose();

// Use -Os (should remove the block and convert to a select)
module = binaryen.parseText(wast);

binaryen.setOptimizeLevel(2);
binaryen.setShrinkLevel(1);
module.optimize();
console.log("=== optimized with -Os ===");
printOptions();
assert(module.validate());
console.log(module.emitText());
module.dispose();
