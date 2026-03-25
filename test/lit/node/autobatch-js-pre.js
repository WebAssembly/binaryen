// Code that goes before the flush() function that autobatch generates. This
// loads the binary and prepares the imports and other globals.

let argv = process.argv.slice(2);

let binary = require('fs').readFileSync(argv[0]);

let mod = new WebAssembly.Module(binary);

let imports = {
  outside: {
    foo1: (x, y) => {
      console.log(`foo1: ${x} ${y}`);
    },
    foo2: (x, y) => {
      console.log(`foo2: ${x} ${y}`);
    },
    foo3: (x, y) => {
      console.log(`foo3: ${x} ${y}`);
    },
    bar: () => {
      console.log('bar');
      return 42;
    },
  },
};

let HEAP32, HEAP64, HEAPF32, HEAPF64;

