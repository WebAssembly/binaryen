const assert = require('node:assert');
const argv = require('node:process');

const binaryen_js_path = argv.argv[2];

const factory = require(binaryen_js_path);

factory().then((Module) => {
  assert.ok(Module.Builder, 'the Builder class must be exposed');

  console.log('success.');
});

