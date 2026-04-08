// interop_extra.mjs

let protoFactory = new Proxy({}, {
    get(target, prop, receiver) {
        // Always return a fresh, empty object.
        return {};
    }
});

let constructors = {};

let imports = {
    "protos": protoFactory,
    "env": {
        constructors,
        exact_func: (x) => x + 100,
    },
};

let compileOptions = { builtins: ["js-prototypes"] };

let buffer = readbuffer(arguments[0]);

let { module, instance } =
    await WebAssembly.instantiate(buffer, imports, compileOptions);

// Test exact function import
console.log("call_exact(5):", instance.exports.call_exact(5));

// Test A (no constructor, just methods on prototype)
let a = instance.exports.newA(10);
console.log("a.getA():", a.getA());
console.log("Object.getPrototypeOf(a) exists:", !!Object.getPrototypeOf(a));

// Test B (inherits from A)
let B = constructors.B;
let b = new B(20, 30);
console.log("b.getA():", b.getA());
console.log("b.getB():", b.getB());
console.log("b instanceof B:", b instanceof B);
console.log("b instanceof constructors.B:", b instanceof constructors.B);

// Test C (inherits from B)
let C = constructors.C;
let c = new C(40, 50, 60);
console.log("c.getA():", c.getA());
console.log("c.getB():", c.getB());
console.log("c.getC():", c.getC());
console.log("c instanceof C:", c instanceof C);
console.log("c instanceof B:", c instanceof B);
console.log("C.s1():", C.s1());
console.log("C.s2():", C.s2());

// Test Meta-descriptor
let Meta = constructors.Meta;
let m = new Meta(70);
console.log("m.getM():", m.getM());

let mDesc = instance.exports.get_meta_desc(m);
console.log("mDesc.getVal():", mDesc.getVal());
console.log("mDesc instanceof Object:", mDesc instanceof Object);
// The descriptor itself has a prototype configured!
console.log("mDesc.getVal inherited:", !!mDesc.getVal);

// Test NoProto (invalid prototype source in descriptor)
let noProto = instance.exports.newNoProto(80);
try {
  console.log("Object.getPrototypeOf(noProto):", Object.getPrototypeOf(noProto));
} catch (e) {
  console.log("Object.getPrototypeOf(noProto) threw:", e.name);
}

// Test cast instructions
let bVtable = instance.exports.get_B_vtable();
try {
  let castedB = instance.exports.test_cast_desc_eq(b, bVtable);
  console.log("test_cast_desc_eq(b, bVtable) succeeded:", !!castedB);
} catch (e) {
  console.log("test_cast_desc_eq(b, bVtable) failed:", e.name);
}

try {
  instance.exports.test_cast_desc_eq(a, bVtable);
  console.log("test_cast_desc_eq(a, bVtable) succeeded unexpectedly");
} catch (e) {
  console.log("test_cast_desc_eq(a, bVtable) failed as expected:", e.name);
}

console.log("test_br_on_cast_desc_eq_fail(b, bVtable):", instance.exports.test_br_on_cast_desc_eq_fail(b, bVtable));
console.log("test_br_on_cast_desc_eq_fail(a, bVtable):", instance.exports.test_br_on_cast_desc_eq_fail(a, bVtable));

// Test newDefault
let def = instance.exports.newDefault();
console.log("newDefault exists:", !!def);
