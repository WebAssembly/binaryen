function assert(x) {
  if (!x) throw 'error!';
}

function test() {
  var module = new Binaryen.Module();

  // Block
  var blockRef = module.block(null, []);
  var block = Binaryen.Block(blockRef);
  assert(block.id === Binaryen.BlockId);
  assert(block.name === null);
  block.name ="theName";
  assert(block.name === "theName");
  assert(block.type === Binaryen.none);
  block.type = Binaryen.i32;
  assert(block.type === Binaryen.i32);
  assert(block.size === 0);
  var child1 = module.i32.const(1);
  block.appendChild(child1);
  assert(block.size === 1);
  assert(block.getChildAt(0) === child1);
  var child2 = module.i32.const(2);
  block.insertChildAt(1, child2);
  assert(block.size === 2);
  assert(block.getChildAt(0) === child1);
  assert(block.getChildAt(1) === child2);
  var child0 = module.i32.const(0);
  block.insertChildAt(0, child0);
  assert(block.size === 3);
  assert(block.getChildAt(0) === child0);
  assert(block.getChildAt(1) === child1);
  assert(block.getChildAt(2) === child2);
  var newChild1 = module.i32.const(11);
  block.setChildAt(1, newChild1);
  assert(block.size === 3);
  assert(block.getChildAt(0) === child0);
  assert(block.getChildAt(1) === newChild1);
  assert(block.getChildAt(2) === child2);
  block.removeChildAt(1);
  assert(block.size === 2);
  assert(block.getChildAt(0) === child0);
  assert(block.getChildAt(1) === child2);
  block.removeChildAt(1);
  assert(block.size === 1);
  assert(block.getChildAt(0) === child0);
  assert(
    block.toText()
    ==
    "(block $theName (result i32)\n (i32.const 0)\n)\n"
  );
  block.removeChildAt(0);
  assert(block.size === 0);
  assert(block == blockRef);
  assert(Binaryen.getExpressionId(block) == Binaryen.BlockId);
}

Binaryen.ready.then(test);
