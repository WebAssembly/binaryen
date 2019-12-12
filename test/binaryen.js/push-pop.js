function assert(x) {
  if (!x) throw 'error!';
}

function cleanInfo(info) {
  var ret = {};
  for (var x in info) {
    if (x !== 'value') {
      ret[x] = info[x];
    }
  }
  return ret;
}

function stringify(expr) {
  return JSON.stringify(cleanInfo(Binaryen.getExpressionInfo(expr)));
}

var module = new Binaryen.Module();

var func = module.addFunction("func", Binaryen.none, Binaryen.none, [],
  module.block(null, [
    module.push(module.i32.pop()),
    module.push(module.i64.pop()),
    module.push(module.f32.pop()),
    module.push(module.f64.pop()),
    module.push(module.v128.pop()),
    module.push(module.anyref.pop()),
    module.push(module.exnref.pop())
  ]
 )
)

assert(module.validate());
console.log(module.emitText());

console.log("getExpressionInfo(i32.pop) = " + stringify(module.i32.pop()));
console.log("getExpressionInfo(i64.pop) = " + stringify(module.i64.pop()));
console.log("getExpressionInfo(f32.pop) = " + stringify(module.f32.pop()));
console.log("getExpressionInfo(f64.pop) = " + stringify(module.f64.pop()));
console.log("getExpressionInfo(v128.pop) = " + stringify(module.v128.pop()));
console.log("getExpressionInfo(anyref.pop) = " + stringify(module.anyref.pop()));
console.log("getExpressionInfo(exnref.pop) = " + stringify(module.exnref.pop()));
console.log("getExpressionInfo(push) = " + stringify(module.push(module.i32.const(0))));
