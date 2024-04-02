const assert = require('node:assert');
const argv = require('node:process');

const binaryen_js_path = argv.argv[2];

// Compare after normalizing text by removing extra indentation.
function normEqual(x, y) {
  function norm(a) {
    a = a.replace(/^\n */g, '');
    a = a.replace(/\n +/g, '\n');
    return a;
  }
  assert.equal(norm(x), norm(y));
}

const binaryenFactory = require(binaryen_js_path);

binaryenFactory().then((binaryen) => {
  // Create a Module.
  const module = new binaryen.Module();

  // Check it prints out as empty.
  normEqual(binaryen.stringify(module),
            `
             (module
             )
            `);

  const builder = new binaryen.Builder(module);

  // Generate a function and everything we need for that.
  const i32 = new binaryen.Type(binaryen.BasicType.i32);
  const sig = {
    params: i32,
    results: i32
  };
  const func_ii = new binaryen.HeapType(sig);
  const vars = new binaryen.TypeVec();
  const func = binaryen.Builder.makeFunction(
    new binaryen.Name("foo"),
    func_ii,
    vars,
    builder.makeNop()
  );
  module.addFunction(func);

  // Check the function prints out ok.
  normEqual(binaryen.stringify(module),
            `
             (module
              (type $0 (func (param i32) (result i32)))
              (func $foo (param $0 i32) (result i32)
               (nop)
              )
             )
            `);

  // Clean up. XXX new HeapType etc. are all unneeded and also leaked!
  module.delete();

  console.log('success.');
});

