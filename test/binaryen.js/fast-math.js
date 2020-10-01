console.log("// fastMath=" + Boolean(binaryen.getFastMath()));
binaryen.setFastMath(true);
assert(binaryen.getFastMath() == true);
