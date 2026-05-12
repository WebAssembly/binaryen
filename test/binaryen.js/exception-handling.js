function cleanInfo(info) {
  var ret = {};
  for (var x in info) {
    // Filter out address pointers and only print meaningful info
    if (x == 'id' || x == 'type' || x == 'name' || x == 'tag' ||
        x == 'target' || x == 'hasCatchAll' || x == 'delegateTarget' ||
        x == 'isDelegate' || x == 'numCatches' || x == 'catches' ||
        x == 'catchTags') {
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

module.addTag("e", binaryen.i32, binaryen.none);

// (try $l0
//   (do
//     (throw $e (i32.const 0))
//   )
//   (catch
//     (drop (pop i32))
//     (rethrow $l0)
//   )
// )
var throw_ = module.throw("e", [module.i32.const(0)]);
var rethrow = module.rethrow("l0");
var try_catch = module.try(
  "l0",
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
//         (throw $a-tag (i32.const 0))
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

// (block $catch_all_dest
//   (try_table (catch_all $catch_all_dest)
//     (throw $e (i32.const 0))
//   )
// )
var try_table = module.try_table(
  module.throw("e", [module.i32.const(0)]),
  [{ tag: null, dest: "catch_all_dest", ref: false }]
);
var try_table_block = module.block("catch_all_dest", [try_table], binaryen.none);

// (throw_ref (ref.null noexn))
var throw_ref = module.throw_ref(module.ref.null(binaryen.noexn));

var body = module.block('', [try_catch, try_delegate, try_table_block, throw_ref])
var func = module.addFunction("test", binaryen.none, binaryen.none, [], body);

console.log(module.emitText());
assert(module.validate());

console.log("getExpressionInfo(throw) = " + stringify(throw_));
console.log("getExpressionInfo(rethrow) = " + stringify(rethrow));
console.log("getExpressionInfo(try_catch) = " + stringify(try_catch));
console.log("getExpressionInfo(try_delegate) = " + stringify(try_delegate));
console.log("getExpressionInfo(try_table) = " + stringify(try_table));
console.log("getExpressionInfo(throw_ref) = " + stringify(throw_ref));
