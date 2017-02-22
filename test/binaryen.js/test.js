
// "hello world" type example: create a function that adds two i32s and
// returns the result

var module = new Binaryen.Module();

// Create a function type for  i32 (i32, i32)  (i.e., return i32, pass two
// i32 params)
var iii = module.addFunctionType('iii', Binaryen.Int32, [Binaryen.Int32, Binaryen.Int32]);

// Start to create the function, starting with the contents: Get the 0 and
// 1 arguments, and add them
var left = module.getLocal(0, Binaryen.Int32);
var right = module.getLocal(1, Binaryen.Int32);
var add = module.binary(module, Binaryen.AddInt32, left, right);

// Create the add function
// Note: no additional local variables (that's the [])
module.addFunction("adder", iii, [], add);

// Print it out
module.print(module);

// Clean up the module, which owns all the objects we created above
module.dispose();

