console.log("magic");
(function testMagic() {
  var block = binaryen.Block(42); // works without new
  assert(block instanceof binaryen.Expression);
  assert(block instanceof binaryen.Block);
  assert(block.constructor === binaryen.Block);
  assert(typeof binaryen.Block.getId === "function"); // proto
  assert(typeof binaryen.Block.getName === "function"); // own
  assert(typeof block.getId === "function"); // proto
  assert(typeof block.getName === "function"); // own
  assert(block.expr === 42);
  assert((block | 0) === 42); // via valueOf
})();

console.log("Block");
(function testBlock() {
  var module = new binaryen.Module();

  var blockRef = module.block(null, []);
  var block = binaryen.Block(blockRef);
  assert(block.id === binaryen.BlockId);
  assert(block.name === null);
  block.name ="theName";
  assert(block.name === "theName");
  assert(block.type === binaryen.none);
  block.type = binaryen.i32;
  assert(block.type === binaryen.i32);
  assert(block.numChildren === 0);
  var child1 = module.i32.const(1);
  block.appendChild(child1);
  assert(block.numChildren === 1);
  assert(block.getChildAt(0) === child1);
  var child2 = module.i32.const(2);
  block.insertChildAt(1, child2);
  assert(block.numChildren === 2);
  assert(block.getChildAt(0) === child1);
  assert(block.getChildAt(1) === child2);
  var child0 = module.i32.const(0);
  block.insertChildAt(0, child0);
  assert(block.numChildren === 3);
  assert(block.getChildAt(0) === child0);
  assert(block.getChildAt(1) === child1);
  assert(block.getChildAt(2) === child2);
  var newChild1 = module.i32.const(11);
  block.setChildAt(1, newChild1);
  assert(block.numChildren === 3);
  assert(block.getChildAt(0) === child0);
  assert(block.getChildAt(1) === newChild1);
  assert(block.getChildAt(2) === child2);
  block.removeChildAt(1);
  assert(block.numChildren === 2);
  assert(block.getChildAt(0) === child0);
  assert(block.getChildAt(1) === child2);
  block.removeChildAt(1);
  assert(block.numChildren === 1);
  assert(block.getChildAt(0) === child0);
  block.finalize();
  assert(
    block.toText()
    ==
    "(block $theName (result i32)\n (i32.const 0)\n)\n"
  );
  block.removeChildAt(0);
  assert(block.numChildren === 0);

  module.dispose();
})();

console.log("If");
(function testIf() {
  var module = new binaryen.Module();

  var conditionRef = module.i32.const(1);
  var ifTrueRef = module.i32.const(2);
  var ifFalseRef = module.i32.const(3);
  var ifRef = module.if(
    conditionRef,
    ifTrueRef,
    ifFalseRef
  );
  var if_ = binaryen.If(ifRef);
  assert(if_.id === binaryen.IfId);
  assert(if_.condition === conditionRef);
  assert(if_.ifTrue === ifTrueRef);
  assert(if_.ifFalse === ifFalseRef);
  var newCondition = module.i32.const(4);
  if_.condition = newCondition;
  assert(if_.condition === newCondition);
  var newIfTrue = module.i32.const(5);
  if_.ifTrue = newIfTrue;
  assert(if_.ifTrue === newIfTrue);
  var newIfFalse = module.i32.const(6);
  if_.ifFalse = newIfFalse;
  assert(if_.ifFalse === newIfFalse);
  if_.finalize();
  assert(
    if_.toText()
    ==
    "(if (result i32)\n (i32.const 4)\n (i32.const 5)\n (i32.const 6)\n)\n"
  );

  module.dispose();
})();

console.log("Loop");
(function testLoop() {
  var module = new binaryen.Module();

  var bodyRef = module.i32.const(1);
  var loopRef = module.loop(null, bodyRef);
  var loop = binaryen.Loop(loopRef);
  assert(loop.id === binaryen.LoopId);
  assert(loop.name === null);
  assert(loop.body === bodyRef);
  loop.name = "theName";
  assert(loop.name === "theName");
  var newBodyRef = module.i32.const(2);
  loop.body = newBodyRef;
  assert(loop.body === newBodyRef);
  loop.finalize();
  assert(
    loop.toText()
    ==
    "(loop $theName (result i32)\n (i32.const 2)\n)\n"
  );

  module.dispose();
})();
