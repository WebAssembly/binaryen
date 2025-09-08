console.log("// generateStackIR=" + binaryen.getGenerateStackIR());
binaryen.setGenerateStackIR(true);
assert(binaryen.getGenerateStackIR() == true);
