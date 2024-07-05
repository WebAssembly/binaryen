assert(!binaryen.testPassToSkip("thePass"));

binaryen.addPassToSkip("thePass");
assert(binaryen.testPassToSkip("thePass"));

binaryen.clearPassesToSkip();
assert(!binaryen.testPassToSkip("thePass"));
