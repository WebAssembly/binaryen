// exhaustive.mjs

let protoFactory = new Proxy({}, {
    get(target, prop, receiver) {
        // Always return a fresh, empty object.
        return {};
    }
});

let constructors = {};

let imports = {
    "protos": protoFactory,
    "env": { constructors },
};

let compileOptions = { builtins: ["js-prototypes"] };

let buffer = readbuffer(arguments[0]);

let { module, instance } =
    await WebAssembly.instantiate(buffer, imports, compileOptions);

let Base = constructors.Base;
let Derived = constructors.Derived;

// Test Base
console.log("Testing Base...");
let b = new Base(10);
console.log("b.getValue():", b.getValue()); // 10
console.log("b.value getter:", b.value); // 10
b.value = 20;
console.log("b.value after setter:", b.getValue()); // 20
console.log("b instanceof Base:", b instanceof Base); // true
console.log("b instanceof Derived:", b instanceof Derived); // false

// Test Derived
console.log("\nTesting Derived...");
let d = new Derived(100, 500);
console.log("d.getValue() (inherited):", d.getValue()); // 100
console.log("d.getExtra():", d.getExtra()); // 500
console.log("d.value getter (inherited):", d.value); // 100
d.value = 150;
console.log("d.value after setter (inherited):", d.getValue()); // 150
console.log("d instanceof Derived:", d instanceof Derived); // true
console.log("d instanceof Base (inheritance):", d instanceof Base); // true
console.log("Derived.staticMethod():", Derived.staticMethod()); // 42

// Test Wasm-side descriptor checks
console.log("\nTesting Wasm-side descriptor checks...");
console.log("checkDesc(b):", instance.exports.checkDesc(b)); // 1
console.log("checkDesc(d):", instance.exports.checkDesc(d)); // 2
console.log("isDerived(b):", instance.exports.isDerived(b)); // 0
console.log("isDerived(d):", instance.exports.isDerived(d)); // 1

// Test cross-checks
console.log("\nTesting cross-checks...");
console.log("get_base_val(d):", instance.exports.get_base_val(d)); // 150
