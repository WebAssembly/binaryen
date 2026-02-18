// Parse invalid text and get a JS exception.
var caughtAsExpected = false;
try {
  console.log('parsing invalid text...');
  binaryen.parseText(`(module
    ;; error on next line
    (func $foo (param__error $x i32))
  )`)
  console.log('no error - invalid');
} catch (e) {
  assert(e.message === '3:16: error: unrecognized instruction');
  caughtAsExpected = true;
}
assert(caughtAsExpected, 'no exception caught');

console.log('success.');

