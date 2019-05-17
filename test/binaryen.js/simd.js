var module = new Binaryen.Module();

module.enableFeature(Binaryen.FeatureSIMD);

var signature = module.addFunctionType("V", Binaryen.v128, []);
module.addFunction("main", signature, [], module.block("", [
  module.v128.const([1, 0, 0, 0, 2, 0, 0, 0, 3, 0, 0, 0, 4, 0, 0, 0])
], Binaryen.v128));

if (!module.validate()) throw 'did not validate :(';
console.log(module.emitText());
