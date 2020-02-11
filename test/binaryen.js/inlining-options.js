binaryen.setAPITracing(true);

console.log("// alwaysInlineMaxSize=" + binaryen.getAlwaysInlineMaxSize());
binaryen.setAlwaysInlineMaxSize(11);
assert(binaryen.getAlwaysInlineMaxSize() == 11);

console.log("// flexibleInlineMaxSize=" + binaryen.getFlexibleInlineMaxSize());
binaryen.setFlexibleInlineMaxSize(22);
assert(binaryen.getFlexibleInlineMaxSize() == 22);

console.log("// oneCallerInlineMaxSize=" + binaryen.getOneCallerInlineMaxSize());
binaryen.setOneCallerInlineMaxSize(33);
assert(binaryen.getOneCallerInlineMaxSize() == 33);

binaryen.setAPITracing(false);
