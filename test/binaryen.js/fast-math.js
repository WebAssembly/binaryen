console.log("// fastMath=" + binaryen.getFastMath());
binaryen.setFastMath(true);
assert(binaryen.getFastMath() == true);
