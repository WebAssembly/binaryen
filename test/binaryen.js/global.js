function cleanInfo(info) {
  var ret = {};
  for (var x in info) {
    if (x !== 'name' && x !== 'body' && x !== 'type' && x !== 'init') {
      ret[x] = info[x];
    }
  }
  return ret;
}

var module = new Binaryen.Module();

var initExpr = module.i32.const(1);
var global = module.addGlobal("a-global", Binaryen.i32, false, initExpr);

var globalInfo = Binaryen.getGlobalInfo(global);
console.log("getGlobalInfo=" + JSON.stringify(cleanInfo(globalInfo)));

var initExpInfo = Binaryen.getExpressionInfo(globalInfo.init);
console.log("getExpressionInfo(init)=" + JSON.stringify(cleanInfo(initExpInfo)));
console.log(Binaryen.emitText(globalInfo.init));

module.addGlobalExport("a-global", "a-global-exp");
module.addGlobalImport("a-global-imp", "module", "base", Binaryen.i32);

module.validate();
console.log(module.emitText());

module.removeGlobal("a-global");
module.removeExport("a-global-exp");

module.validate();
console.log(module.emitText());
