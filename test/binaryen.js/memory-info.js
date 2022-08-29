var module = new binaryen.Module();
assert(module.validate());
console.log(JSON.stringify(module.hasMemory()));

var initial = 1, maximum = 64;

// Not shared
module = new binaryen.Module();
module.setMemory(initial, maximum, '');
assert(module.validate());
console.log(JSON.stringify(module.hasMemory()));
console.log(JSON.stringify(module.getMemoryInfo()));

// Shared
module = new binaryen.Module();
module.setFeatures(binaryen.Features.MVP | binaryen.Features.Atomics);
module.setMemory(initial, maximum, '', [], true);
assert(module.validate());
console.log(JSON.stringify(module.hasMemory()));
console.log(JSON.stringify(module.getMemoryInfo()));

// Imported, not shared
module = new binaryen.Module();
module.addMemoryImport('my_mem', 'env', 'memory', false);
assert(module.validate());
console.log(JSON.stringify(module.hasMemory()));
console.log(JSON.stringify(module.getMemoryInfo()));

// Imported, shared
module = new binaryen.Module();
module.setFeatures(binaryen.Features.MVP | binaryen.Features.Atomics);
module.addMemoryImport('my_mem', 'env', 'memory', true);
assert(module.validate());
console.log(JSON.stringify(module.hasMemory()));
console.log(JSON.stringify(module.getMemoryInfo()));
