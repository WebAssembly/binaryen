function cleanInfo(info) {
  var ret = {};
  for (var x in info) {
    // Filter out address pointers and only print meaningful info
    if (x == 'id' || x == 'type' || x == 'name' || x == 'event' ||
        x == 'depth' || x == 'hasCatchAll' || x == 'delegateTarget' ||
        x == 'isDelegate') {
      ret[x] = info[x];
    }
  }
  return ret;
}

function stringify(expr) {
  return JSON.stringify(cleanInfo(binaryen.getExpressionInfo(expr)));
}

var module = new binaryen.Module();
module.setFeatures(binaryen.Features.ReferenceTypes |
                   binaryen.Features.ExceptionHandling);

var event_ = module.addEvent("e", 0, binaryen.i32, binaryen.none);

// (try
//   (do
//     (throw $e (i32.const 0))
//   )
//   (catch
//     (drop (pop i32))
//     (rethrow 0)
//   )
// )
var throw_ = module.throw("e", [module.i32.const(0)]);
var rethrow = module.rethrow(0);
var try_catch = module.try(
  '',
  throw_,
  ["e"],
  [
    module.block(null,
      [
        module.drop(module.i32.pop()),
        rethrow
      ],
      binaryen.none
    )
  ],
  ''
);

// (try $try_outer
//   (do
//     (try
//       (do
//         (throw $a-event (i32.const 0))
//       )
//       (delegate $try_outer)
//     )
//   )
//   (catch_all)
// )
var try_delegate = module.try(
  'try_outer',
  module.try(
    '',
    throw_,
    [],
    [],
    'try_outer'
  ),
  [],
  [module.nop()],
  ''
);

var body = module.block('', [try_catch, try_delegate])
var func = module.addFunction("test", binaryen.none, binaryen.none, [], body);

console.log(module.emitText());
assert(module.validate());

console.log("getExpressionInfo(throw) = " + stringify(throw_));
console.log("getExpressionInfo(rethrow) = " + stringify(rethrow));
console.log("getExpressionInfo(try_catch) = " + stringify(try_catch));
console.log("getExpressionInfo(try_delegate) = " + stringify(try_delegate));
