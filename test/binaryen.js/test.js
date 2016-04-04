
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

var module = new Binaryen.AllocatingModule();
var parser = new Binaryen.SExpressionParser(input);
var builder = new Binaryen.SExpressionWasmBuilder(module, parser.get_root(), false);

var interface_ = new Binaryen.ShellExternalInterface();
var instance = new Binaryen.ModuleInstance(module, interface_);

var name = Binaryen.Name('add');

var args = new Binaryen.LiteralList();
args.push_back(new Binaryen.Literal(40));
args.push_back(new Binaryen.Literal(2));

console.log('answer is ' + instance.callExport(name, args).getf64() + '.');

