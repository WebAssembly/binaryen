
var module = Binaryen.parseText(
  `(module
    (type $0 (func (result i32)))
    (memory $0 1)
    (func $0 (; 0 ;) (type $0) (result i32)
     (memory.grow
      (i32.const 1)
     )
    )
   )`
);

var funcInfo = Binaryen.getFunctionInfo(module.getFunction('0'));
console.log("getFunctionInfo=" + JSON.stringify(funcInfo));
var expInfo = Binaryen.getExpressionInfo(funcInfo.body);
console.log("getExpressionInfo(body)=" + JSON.stringify(expInfo));
