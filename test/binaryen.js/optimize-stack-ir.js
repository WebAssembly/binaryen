console.log("// optimizeStackIR=" + binaryen.getOptimizeStackIR());
binaryen.setOptimizeStackIR(true);
assert(binaryen.getOptimizeStackIR() == true);
