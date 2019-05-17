var module = new Binaryen.Module();

assert(module.getFeatures() == 0);
module.setFeature(Binaryen.Feature.SIMD, true);
assert(module.getFeatures() == Binaryen.Feature.SIMD);

var signature = module.addFunctionType("V", Binaryen.v128, []);
module.addFunction("main", signature, [], module.block("", [
  module.v128.const([1, 0, 0, 0, 2, 0, 0, 0, 3, 0, 0, 0, 4, 0, 0, 0])
], Binaryen.v128));

var validates = module.validate();
console.log(module.emitText());
if (!validates) throw 'did not validate :(';
