function cleanInfo(info) {
  var ret = {};
  for (var x in info) {
    if (x !== 'name' && x !== 'body' && x !== 'type' && x !== 'init') {
      ret[x] = info[x];
    }
  }
  return ret;
}

var module = new binaryen.Module();
module.setFeatures(binaryen.Features.MVP | binaryen.Features.MutableGlobals);

var initExpr = module.i32.const(1);
var global = module.addGlobal("a-global", binaryen.i32, false, initExpr);

console.log("GetGlobal is equal: " + (global === module.getGlobal("a-global")));

var globalInfo = binaryen.getGlobalInfo(global);
console.log("getGlobalInfo=" + JSON.stringify(cleanInfo(globalInfo)));

var initExpInfo = binaryen.getExpressionInfo(globalInfo.init);
console.log("getExpressionInfo(init)=" + JSON.stringify(cleanInfo(initExpInfo)));
console.log(binaryen.emitText(globalInfo.init));

module.addGlobalExport("a-global", "a-global-exp");
module.addGlobalImport("a-global-imp", "module", "base", binaryen.i32, false);
module.addGlobalImport("a-mut-global-imp", "module", "base", binaryen.i32, true);

assert(module.validate());
console.log(module.emitText());

module.removeGlobal("a-global");
module.removeExport("a-global-exp");

assert(module.validate());
console.log(module.emitText());
