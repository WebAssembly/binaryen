function assert(x) {
  if (!x) throw 'error!';
}

function test(Binaryen) {
  Binaryen.setAPITracing(true);
  var module = new Binaryen.Module();

  module.addCustomSection("hello", [119, 111, 114, 108, 100]);

  assert(module.validate());
  console.log(module.emitText());
}

(async () => test(await Binaryen.ready))();
