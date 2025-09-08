assert(!binaryen.hasPassToSkip("thePass"));

binaryen.addPassToSkip("thePass");
assert(binaryen.hasPassToSkip("thePass"));

binaryen.clearPassesToSkip();
assert(!binaryen.hasPassToSkip("thePass"));
