
// "hello world" type example: create a function that adds two i32s and
// returns the result

// Create a module to work on
var module = new Binaryen.Module();

// Create a function type for  i32 (i32, i32)  (i.e., return i32, pass two
// i32 params)
var iii = module.addFunctionType('iii', Binaryen.i32, [Binaryen.i32, Binaryen.i32]);

// Start to create the function, starting with the contents: Get the 0 and
// 1 arguments, and add them, then return them
var left = module.getLocal(0, Binaryen.i32);
var right = module.getLocal(1, Binaryen.i32);
var add = module.i32.add(left, right);
var ret = module.return(add);

// Create the add function
// Note: no additional local variables (that's the [])
module.addFunction('adder', iii, [], ret);

// Export the function, so we can call it later (for simplicity we
// export it as the same name as it has internally)
module.addFunctionExport('adder', 'adder');

// Print out the text
console.log(module.emitText());

// Optimize the module! This removes the 'return', since the
// output of the add can just fall through
module.optimize();

// Print out the optimized module's text
console.log('optimized:\n\n' + module.emitText());

// Get the binary in typed array form
var binary = module.emitBinary();
console.log('binary size: ' + binary.length);
console.log();

// We don't need the Binaryen module anymore, so we can tell it to
// clean itself up
module.dispose();

// Compile the binary and create an instance
var wasm = new WebAssembly.Instance(new WebAssembly.Module(binary), {})
console.log("exports: " + Object.keys(wasm.exports).sort().join(","));
console.log();

// Call the code!
console.log('an addition: ' + wasm.exports.adder(40, 2));

