const assert = require('node:assert');
const argv = require('node:process');

const binaryen_js_path = argv.argv[2];

const binaryenFactory = require(binaryen_js_path);

binaryenFactory().then((binaryen) => {
  // Basic smoke test that something got exposed at all.
  assert.ok(binaryen.Builder, 'the Builder class must be exposed');

  // Create a Module.
  var module = new binaryen.Module();

  // Check it prints out as empty.
  assert.equal(binaryen.stringify(module),
`(module
)
`
  );

  console.log('success.');
});

