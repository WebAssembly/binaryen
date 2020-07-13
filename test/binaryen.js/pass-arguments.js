assert(binaryen.getPassArgument("theKey") === null);

binaryen.setPassArgument("theKey", "theValue");
assert(binaryen.getPassArgument("theKey") === "theValue");

binaryen.setPassArgument("theKey", null);
assert(binaryen.getPassArgument("theKey") === null);

binaryen.setPassArgument("theKey", "theValue2");
assert(binaryen.getPassArgument("theKey") === "theValue2");

binaryen.clearPassArguments();
assert(binaryen.getPassArgument("theKey") === null);
