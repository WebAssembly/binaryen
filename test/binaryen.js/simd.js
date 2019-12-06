function test() {
  var module = new Binaryen.Module();

  var expr = module.v128.const([1, 0, 0, 0, 2, 0, 0, 0, 3, 0, 0, 0, 4, 0, 0, 0]);
  var info = Binaryen.getExpressionInfo(expr);
  console.log("v128.const i8x16 0x" + info.value.map(b => b.toString(16)).join(" 0x"));
}

Binaryen.ready.then(test);
