
Binaryen = Binaryen(); // instantiate the module

var input =
  '(module\n' +
  '  (export "add" $add)\n' +
  '  (func $add (param $x f32) (param $y f64) (result i32)\n' +
  '    (i32.add\n' +
  '      (i32.trunc_s/f32 (get_local $x))\n' +
  '      (i32.trunc_s/f64 (get_local $y))\n' +
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

var name = new Binaryen.Name('add');
console.log('name: ' + name.c_str());

var args = new Binaryen.LiteralList();
args.push_back(new Binaryen.F32Literal(40));
args.push_back(new Binaryen.F64Literal(2));

console.log('answer is ' + instance.callExport(name, args).geti32() + '.');

