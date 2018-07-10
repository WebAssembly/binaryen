var wasm = new Binaryen.Module()
wasm.addFunctionType("vI", Binaryen.i32, []);
// It will cause a fatal error to try to add the same name a second time
wasm.addFunctionType("vI", Binaryen.i32, []);
