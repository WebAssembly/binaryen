var module = new binaryen.Module();

module.addCustomSection("hello", [119, 111, 114, 108, 100]);

assert(module.validate());
console.log(module.emitText());
