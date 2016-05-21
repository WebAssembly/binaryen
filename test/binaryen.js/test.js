
Binaryen = Binaryen(); // instantiate the module

var input =
  '(module\n' +
  '  (export "sub" $sub)\n' +
  '  (func $sub (param $x i64) (param $y i64) (result i64)\n' +
  '    (i64.sub\n' +
  '      (get_local $x)\n' +
  '      (get_local $y)\n' +
  '    )\n' +
  '  )\n' +
  ')\n';

console.log('input:');
console.log(input);
console.log('================');

var module = new Binaryen.Module();
var parser = new Binaryen.SExpressionParser(input);

console.log('s-expr dump:');
parser.get_root().dump();
var s_module = parser.get_root().getChild(0);
console.log('================');

var builder = new Binaryen.SExpressionWasmBuilder(module, s_module);

console.log('module:');
Binaryen.WasmPrinter.prototype.printModule(module);
console.log('================');

var interface_ = new Binaryen.ShellExternalInterface();
var instance = new Binaryen.ModuleInstance(module, interface_);

var name = new Binaryen.Name('sub');
console.log('name: ' + name.c_str());

var args = new Binaryen.LiteralList();
args.push_back(new Binaryen.I64Literal(40, 5145));
args.push_back(new Binaryen.I64Literal(-2, 5144));

var result = Binaryen.castObject(instance.callExport(name, args), Binaryen.I64Literal);
console.log('answer is ' + (result.geti64Low() + result.geti64High()) + '.');

