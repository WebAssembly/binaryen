
Binaryen = Binaryen(); // instantiate the module

var input =
  '(module\n' +
  '  (export "add" $add)\n' +
  '  (func $add (param $x f64) (param $y f64) (result f64)\n' +
  '    (f64.add\n' +
  '      (get_local $x)\n' +
  '      (get_local $y)\n' +
  '    )\n' +
  '  )\n' +
  ')\n';

console.log('input:');
console.log(input);
console.log('================');

var module = new Binaryen.AllocatingModule();
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

var name = Binaryen.Name('add');

var args = new Binaryen.LiteralList();
args.push_back(new Binaryen.Literal(40));
args.push_back(new Binaryen.Literal(2));

console.log('answer is ' + instance.callExport(name, args).getf64() + '.');

