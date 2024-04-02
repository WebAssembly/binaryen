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
  const params = new binaryen.NameTypeVec();
  params.push_back(new binaryen.NameType(new binaryen.Name("p0"), i32));
  const vars = new binaryen.NameTypeVec();
  const func = builder.makeFunction(
    "foo",
    params,
    func_ii,
    vars
  );
  console.log('success.');
});

