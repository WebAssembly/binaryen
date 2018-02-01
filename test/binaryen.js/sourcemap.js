var module = new Binaryen.Module();

var signature = module.addFunctionType("i", Binaryen.i32, []);

var fileIndex = module.addDebugInfoFileName("module.c");

console.log(module.getDebugInfoFileName(fileIndex));
console.log();

var expr = module.i32.const(1);
var body = module.block("", [
  expr
], Binaryen.i32);

var func = module.addFunction("main", signature, [], body);

module.setDebugLocation(func, expr, fileIndex, 1, 2);
module.setDebugLocation(func, body, fileIndex, 0, 3);

var output = module.emitBinary("module.wasm.map");

function dumpBinary(buffer) {
  var hex = [], o, b, h;
  for (var i = 0; i < buffer.length; ++i) {
    o = i.toString(16);
    while (o.length < 3) o = "0" + o;
    if ((i & 15) === 0) hex.push((i ? "\n" : "") + o + ":");
    if ((b = buffer[i]) >= 0x21 && b <= 0x7e)
      h = String.fromCharCode(b) + ' ';
    else if ((h = b.toString(16)).length < 2)
      h = "0" + h;
    hex.push(h);
  }
  console.log(hex.join(" "));
}

dumpBinary(output.binary);
console.log();
console.log(output.sourceMap);
