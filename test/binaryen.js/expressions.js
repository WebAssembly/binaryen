// TODO: remove this
if (typeof Binaryen === "undefined") {
  Binaryen = require("../../embuild/bin/binaryen");
}

function assert(x) {
  if (!x) throw 'error!';
}

function testBlock() {
  var module = new Binaryen.Module();

  var blockRef = module.block(null, []);
  var block = Binaryen.Block(blockRef);
  assert(block.id === Binaryen.BlockId);
  assert(block.name === null);
  block.name ="theName";
  assert(block.name === "theName");
  assert(block.type === Binaryen.none);
  block.type = Binaryen.i32;
  assert(block.type === Binaryen.i32);
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
  assert(
    block.toText()
    ==
    "(block $theName (result i32)\n (i32.const 0)\n)\n"
  );
  block.removeChildAt(0);
  assert(block.numChildren === 0);
  assert(block == blockRef);

  module.dispose();
}

function testIf() {
  var module = new Binaryen.Module();

  var conditionRef = module.i32.const(1);
  var ifTrueRef = module.i32.const(2);
  var ifFalseRef = module.i32.const(3);
  var ifRef = module.if(
    conditionRef,
    ifTrueRef,
    ifFalseRef
  );
  var if_ = Binaryen.If(ifRef);
  assert(if_.id === Binaryen.IfId);
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
  assert(
    if_.toText()
    ==
    "(if (result i32)\n (i32.const 4)\n (i32.const 5)\n (i32.const 6)\n)\n"
  );
  assert(if_ == ifRef);

  module.dispose();
}

function testLoop() {
  var module = new Binaryen.Module();

  var bodyRef = module.i32.const(1);
  var loopRef = module.loop(null, bodyRef);
  var loop = Binaryen.Loop(loopRef);
  assert(loop.id === Binaryen.LoopId);
  assert(loop.name === null);
  assert(loop.body === bodyRef);
  loop.name = "theName";
  assert(loop.name === "theName");
  var newBodyRef = module.i32.const(2);
  loop.body = newBodyRef;
  assert(loop.body === newBodyRef);
  assert(
    loop.toText()
    ==
    "(loop $theName (result i32)\n (i32.const 2)\n)\n"
  );
  assert(loop == loopRef);

  module.dispose();
}

Binaryen.ready.then(function() {
  console.log("block");
  testBlock();
  console.log("if");
  testIf();
  console.log("loop");
  testLoop();
});
