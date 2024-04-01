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
  var module = new binaryen.Module();

  // Check it prints out as empty.
  normEqual(binaryen.stringify(module),
            `
             (module
             )
            `);

  console.log('success.');
});

