// https://github.com/WebAssembly/custom-descriptors/blob/main/proposals/custom-descriptors/Overview.md

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

let buffer = readbuffer(arguments[0]); // XXX modified to read the wasm filename

let { module, instance } =
    await WebAssembly.instantiate(buffer, imports, compileOptions);

let Counter = constructors.Counter;

let count = new Counter(0);

console.log(count.get());
count.inc();
console.log(count.get());

console.log(count instanceof Counter);
