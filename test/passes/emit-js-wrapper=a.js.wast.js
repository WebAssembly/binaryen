// the variable 'binary' must exist and contain the wasm file
var instance = new WebAssembly.Instance(new WebAssembly.Module(binary), {})
console.log(instance.add(0, 0));
instance.no_return(0);
instance.types2(0, 0, 0);
