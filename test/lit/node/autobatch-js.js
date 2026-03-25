let argv = process.argv.slice(2);

let binary = require('fs').readFileSync(argv[0]);

var module = new WebAssembly.Module(binary);

var imports = {
};

var instance = new WebAssembly.Instance(module, imports);

for (var export in instance.exports) {
  console.log('calling ${export}');
  console.log(instance.exports[export]);
}

