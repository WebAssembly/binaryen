let argv = process.argv.slice(2);

let binary = require('fs').readFileSync(argv[0]);

var module = new WebAssembly.Module(binary);

var imports = {
  outside: {
    foo1: (x, y) => {
      console.log('foo1: ${x} ${y})');
    },
    foo2: (x, y) => {
      console.log('foo1: ${x} ${y})');
    },
    foo3: (x, y) => {
      console.log('foo1: ${x} ${y})');
    },
    bar: () => {
      console.log('bar');
      return 42;
    },
  },
};

var instance = new WebAssembly.Instance(module, imports);

for (var export in instance.exports) {
  console.log('calling ${export}');
  console.log(instance.exports[export]);
}

console.log('test complete.');
