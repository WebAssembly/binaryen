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
  console.warn(binaryen.BasicType);
  console.warn(binaryen.BasicType.i32);
  console.warn(typeof binaryen.BasicType.i32);
  assert.equal(binaryen.BasicType.i32, 2);

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
  const sig = new binaryen.Signature();
  //const func = builder.makeFunction("foo", 
  console.log('success.');
});

