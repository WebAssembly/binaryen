function assertDeepEqual(x, y) {
  if (typeof x === "object") {
    for (let i in x) assertDeepEqual(x[i], y[i]);
    for (let i in y) assertDeepEqual(x[i], y[i]);
  } else {
    assert(x === y);
  }
}

console.log("# Expression");
(function testWrapper() {
  var theExpression = binaryen.Block(42); // works without new
  assert(theExpression instanceof binaryen.Expression);
  assert(theExpression instanceof binaryen.Block);
  assert(theExpression.constructor === binaryen.Block);
  assert(typeof binaryen.Block.getId === "function"); // proto
  assert(typeof binaryen.Block.getName === "function"); // own
  assert(typeof theExpression.getId === "function"); // proto
  assert(typeof theExpression.getName === "function"); // own
  assert(theExpression.expr === 42);
  assert((theExpression | 0) === 42); // via valueOf
})();

console.log("# Block");
(function testBlock() {
  var module = new binaryen.Module();

  var theBlock = binaryen.Block(module.block(null, []));
  assert(theBlock.id === binaryen.BlockId);
  assert(theBlock.name === null);
  theBlock.name ="theName";
  assert(theBlock.name === "theName");
  assert(theBlock.type === binaryen.none);
  theBlock.type = binaryen.i32;
  assert(theBlock.type === binaryen.i32);
  assert(theBlock.numChildren === 0);
  var child1 = module.i32.const(1);
  theBlock.appendChild(child1);
  assert(theBlock.numChildren === 1);
  assert(theBlock.getChildAt(0) === child1);
  var child2 = module.i32.const(2);
  theBlock.insertChildAt(1, child2);
  assert(theBlock.numChildren === 2);
  assert(theBlock.getChildAt(0) === child1);
  assert(theBlock.getChildAt(1) === child2);
  var child0 = module.i32.const(0);
  theBlock.insertChildAt(0, child0);
  assert(theBlock.numChildren === 3);
  assert(theBlock.getChildAt(0) === child0);
  assert(theBlock.getChildAt(1) === child1);
  assert(theBlock.getChildAt(2) === child2);
  var newChild1 = module.i32.const(11);
  theBlock.setChildAt(1, newChild1);
  assert(theBlock.numChildren === 3);
  assert(theBlock.getChildAt(0) === child0);
  assert(theBlock.getChildAt(1) === newChild1);
  assert(theBlock.getChildAt(2) === child2);
  theBlock.removeChildAt(1);
  assert(theBlock.numChildren === 2);
  assert(theBlock.getChildAt(0) === child0);
  assert(theBlock.getChildAt(1) === child2);
  theBlock.removeChildAt(1);
  assert(theBlock.numChildren === 1);
  assert(theBlock.getChildAt(0) === child0);
  theBlock.finalize();
  console.log(theBlock.toText());
  assert(
    theBlock.toText()
    ==
    "(block $theName (result i32)\n (i32.const 0)\n)\n"
  );
  theBlock.removeChildAt(0);
  assert(theBlock.numChildren === 0);

  module.dispose();
})();

console.log("# If");
(function testIf() {
  var module = new binaryen.Module();

  var conditionRef = module.i32.const(1);
  var ifTrueRef = module.i32.const(2);
  var ifFalseRef = module.i32.const(3);
  var theIf = binaryen.If(module.if(conditionRef, ifTrueRef, ifFalseRef));
  assert(theIf.id === binaryen.IfId);
  assert(theIf.condition === conditionRef);
  assert(theIf.ifTrue === ifTrueRef);
  assert(theIf.ifFalse === ifFalseRef);
  var newCondition = module.i32.const(4);
  theIf.condition = newCondition;
  assert(theIf.condition === newCondition);
  var newIfTrue = module.i32.const(5);
  theIf.ifTrue = newIfTrue;
  assert(theIf.ifTrue === newIfTrue);
  var newIfFalse = module.i32.const(6);
  theIf.ifFalse = newIfFalse;
  assert(theIf.ifFalse === newIfFalse);
  theIf.finalize();
  console.log(theIf.toText());
  assert(
    theIf.toText()
    ==
    "(if (result i32)\n (i32.const 4)\n (i32.const 5)\n (i32.const 6)\n)\n"
  );

  module.dispose();
})();

console.log("# Loop");
(function testLoop() {
  var module = new binaryen.Module();

  var bodyRef = module.i32.const(1);
  var theLoop = binaryen.Loop(module.loop(null, bodyRef));
  assert(theLoop.id === binaryen.LoopId);
  assert(theLoop.name === null);
  assert(theLoop.body === bodyRef);
  theLoop.name = "theName";
  assert(theLoop.name === "theName");
  var newBodyRef = module.i32.const(2);
  theLoop.body = newBodyRef;
  assert(theLoop.body === newBodyRef);
  theLoop.finalize();
  console.log(theLoop.toText());
  assert(
    theLoop.toText()
    ==
    "(loop $theName (result i32)\n (i32.const 2)\n)\n"
  );

  module.dispose();
})();

console.log("# Break");
(function testBreak() {
  var module = new binaryen.Module();

  var conditionRef = module.i32.const(1);
  var valueRef = module.i32.const(2);
  var theBreak = binaryen.Break(module.br("theName", conditionRef, valueRef));
  assert(theBreak.name === "theName");
  assert(theBreak.condition === conditionRef);
  assert(theBreak.value === valueRef);
  theBreak.name = "theName2";
  theBreak.condition = conditionRef = module.i32.const(3);
  theBreak.value = valueRef = module.i32.const(4);
  assert(theBreak.name === "theName2");
  assert(theBreak.condition === conditionRef);
  assert(theBreak.value === valueRef);
  theBreak.finalize();
  console.log(theBreak.toText());
  assert(
    theBreak.toText()
    ==
    "(br_if $theName2\n (i32.const 4)\n (i32.const 3)\n)\n"
  );

  module.dispose();
})();

console.log("# Switch");
(function testSwitch() {
  var module = new binaryen.Module();

  var names = ["a", "b"];
  var defaultName = "c";
  var conditionRef = module.i32.const(1);
  var valueRef = module.i32.const(2);
  var theSwitch = binaryen.Switch(module.switch(names, defaultName, conditionRef, valueRef));
  assert(theSwitch.numNames === 2);
  assert(theSwitch.names.length === 2);
  assertDeepEqual(theSwitch.names, names);
  assert(theSwitch.defaultName === defaultName);
  assert(theSwitch.condition === conditionRef);
  assert(theSwitch.value === valueRef);
  theSwitch.names = names = [
    "1", // set
    "2", // set
    "3"  // append
  ];
  assertDeepEqual(theSwitch.names, names);
  theSwitch.names = names = [
    "x", // set
    // remove
    // remove
  ];
  assertDeepEqual(theSwitch.names, names);
  theSwitch.insertNameAt(1, "y");
  theSwitch.condition = conditionRef = module.i32.const(3);
  assert(theSwitch.condition === conditionRef);
  theSwitch.value = valueRef = module.i32.const(4);
  assert(theSwitch.value === valueRef);
  theSwitch.finalize();
  console.log(theSwitch.toText());
  assert(
    theSwitch.toText()
    ==
    "(br_table $x $y $c\n (i32.const 4)\n (i32.const 3)\n)\n"
  );

  module.dispose();
})();

console.log("# Call");
(function testCall() {
  var module = new binaryen.Module();

  var target = "foo";
  var operands = [
    module.i32.const(1),
    module.i32.const(2)
  ];
  var theCall = binaryen.Call(module.call(target, operands, binaryen.i32));
  assert(theCall.target === target);
  assertDeepEqual(theCall.operands, operands);
  assert(theCall.type === binaryen.i32);
  assert(theCall.return === false);
  theCall.target = "bar";
  assert(theCall.target === "bar");
  theCall.operands = operands = [
    module.i32.const(3), // set
    module.i32.const(4), // set
    module.i32.const(5)  // append
  ];
  assertDeepEqual(theCall.operands, operands);
  theCall.operands = operands = [
    module.i32.const(6) // set
    // remove
    // remove
  ];
  assertDeepEqual(theCall.operands, operands);
  theCall.insertOperandAt(0, module.i32.const(7));
  theCall.return = true;
  assert(theCall.return === true);
  theCall.finalize();
  assert(theCall.type === binaryen.unreachable); // finalized tail call
  theCall.return = false;
  theCall.type = binaryen.i32;
  theCall.finalize();
  assert(theCall.type === binaryen.i32); // finalized call
  console.log(theCall.toText());
  assert(
    theCall.toText()
    ==
    "(call $bar\n (i32.const 7)\n (i32.const 6)\n)\n"
  );

  module.dispose();
})();

console.log("# CallIndirect");
(function testCallIndirect() {
  var module = new binaryen.Module();

  var target = module.i32.const(42);
  var params = binaryen.none;
  var results = binaryen.none;
  var operands = [
    module.i32.const(1),
    module.i32.const(2)
  ];
  var theCallIndirect = binaryen.CallIndirect(module.call_indirect(target, operands, params, results));
  assert(theCallIndirect.target === target);
  assertDeepEqual(theCallIndirect.operands, operands);
  assert(theCallIndirect.params === params);
  assert(theCallIndirect.results === results);
  assert(theCallIndirect.type === theCallIndirect.results);
  assert(theCallIndirect.return === false);
  theCallIndirect.target = target = module.i32.const(9000);
  assert(theCallIndirect.target === target);
  theCallIndirect.operands = operands = [
    module.i32.const(3), // set
    module.i32.const(4), // set
    module.i32.const(5)  // append
  ];
  assertDeepEqual(theCallIndirect.operands, operands);
  theCallIndirect.operands = operands = [
    module.i32.const(6) // set
    // remove
    // remove
  ];
  assertDeepEqual(theCallIndirect.operands, operands);
  theCallIndirect.insertOperandAt(0, module.i32.const(7));
  theCallIndirect.return = true;
  assert(theCallIndirect.return === true);
  theCallIndirect.params = params = binaryen.createType([ binaryen.i32, binaryen.i32 ]);
  assert(theCallIndirect.params === params);
  theCallIndirect.results = results = binaryen.i32;
  assert(theCallIndirect.results === results);
  theCallIndirect.finalize();
  assert(theCallIndirect.type === binaryen.unreachable); // finalized tail call
  theCallIndirect.return = false;
  theCallIndirect.finalize();
  assert(theCallIndirect.type === results); // finalized call
  console.log(theCallIndirect.toText());
  assert(
    theCallIndirect.toText()
    ==
    "(call_indirect (type $i32_i32_=>_i32)\n (i32.const 7)\n (i32.const 6)\n (i32.const 9000)\n)\n"
  );

  module.dispose();
})();

console.log("# LocalGet");
(function testLocalGet() {
  var module = new binaryen.Module();

  var index = 1;
  var type = binaryen.i32;
  var theLocalGet = binaryen.LocalGet(module.local.get(index, type));
  assert(theLocalGet.index === index);
  assert(theLocalGet.type === type);
  theLocalGet.index = index = 2;
  assert(theLocalGet.index === index);
  theLocalGet.type = type = binaryen.f64;
  assert(theLocalGet.type === type);
  theLocalGet.finalize();
  console.log(theLocalGet.toText());
  assert(
    theLocalGet.toText()
    ==
    "(local.get $2)\n"
  );

  module.dispose();
})();

console.log("# LocalSet");
(function testLocalSet() {
  var module = new binaryen.Module();

  var index = 1;
  var value = module.i32.const(1);
  var theLocalSet = binaryen.LocalSet(module.local.set(index, value));
  assert(theLocalSet.index === index);
  assert(theLocalSet.value === value);
  assert(theLocalSet.tee === false);
  theLocalSet.index = index = 2;
  assert(theLocalSet.index === index);
  theLocalSet.value = value = module.i32.const(3);
  assert(theLocalSet.value === value);
  theLocalSet.type = binaryen.i32;
  assert(theLocalSet.type === binaryen.i32);
  assert(theLocalSet.tee === true);
  theLocalSet.type = binaryen.none;
  theLocalSet.finalize();
  console.log(theLocalSet.toText());
  assert(
    theLocalSet.toText()
    ==
    "(local.set $2\n (i32.const 3)\n)\n"
  )

  module.dispose();
})();

console.log("# GlobalGet");
(function testGlobalGet() {
  var module = new binaryen.Module();

  var name = "a";
  var type = binaryen.i32;
  var theGlobalGet = binaryen.GlobalGet(module.global.get(name, type));
  assert(theGlobalGet.name === name);
  assert(theGlobalGet.type === type);
  theGlobalGet.name = name = "b";
  assert(theGlobalGet.name === name);
  theGlobalGet.type = type = binaryen.f64;
  assert(theGlobalGet.type === type);
  theGlobalGet.finalize();
  console.log(theGlobalGet.toText());
  assert(
    theGlobalGet.toText()
    ==
    "(global.get $b)\n"
  );

  module.dispose();
})();

console.log("# GlobalSet");
(function testGlobalSet() {
  var module = new binaryen.Module();

  var name = "a";
  var value = module.i32.const(1);
  var theGlobalSet = binaryen.GlobalSet(module.global.set(name, value));
  assert(theGlobalSet.name === name);
  assert(theGlobalSet.value === value);
  assert(theGlobalSet.type == binaryen.none);
  theGlobalSet.name = name = "b";
  assert(theGlobalSet.name === name);
  theGlobalSet.value = value = module.f64.const(3);
  assert(theGlobalSet.value === value);
  theGlobalSet.finalize();
  console.log(theGlobalSet.toText());
  assert(
    theGlobalSet.toText()
    ==
    "(global.set $b\n (f64.const 3)\n)\n"
  )

  module.dispose();
})();

console.log("# Host");
(function testHost() {
  var module = new binaryen.Module();

  var op = binaryen.Operations.MemorySize;
  var nameOp = null;
  var operands = [];
  var theHost = binaryen.Host(module.memory.size());
  assert(theHost.op === op);
  assert(theHost.nameOperand === nameOp);
  assertDeepEqual(theHost.operands, operands);
  theHost.op = op = binaryen.Operations.MemoryGrow;
  assert(theHost.op === op);
  theHost.nameOperand = nameOp = "a";
  assert(theHost.nameOperand === nameOp);
  theHost.nameOperand = null;
  theHost.operands = operands = [
    module.i32.const(1)
  ];
  assertDeepEqual(theHost.operands, operands);
  theHost.type = binaryen.f64;
  theHost.finalize();
  assert(theHost.type === binaryen.i32);
  console.log(theHost.toText());
  assert(
    theHost.toText()
    ==
    "(memory.grow\n (i32.const 1)\n)\n"
  );

  module.dispose();
})();

console.log("# Load");
(function testLoad() {
  var module = new binaryen.Module();

  var offset = 16;
  var align = 2;
  var ptr = module.i32.const(64);
  var theLoad = binaryen.Load(module.i32.load(offset, align, ptr));
  assert(theLoad.offset === offset);
  assert(theLoad.align === align);
  assert(theLoad.ptr === ptr);
  assert(theLoad.bytes === 4);
  assert(theLoad.atomic === false);
  theLoad.offset = offset = 32;
  assert(theLoad.offset === offset);
  theLoad.align = align = 4;
  assert(theLoad.align === align);
  theLoad.ptr = ptr = module.i32.const(128);
  assert(theLoad.ptr === ptr);
  assert(theLoad.signed === true);
  assert(theLoad.type == binaryen.i32);
  theLoad.type = binaryen.i64;
  assert(theLoad.type === binaryen.i64);
  theLoad.signed = false;
  assert(theLoad.signed === false);
  theLoad.bytes = 8;
  assert(theLoad.bytes === 8);
  theLoad.atomic = true;
  assert(theLoad.atomic === true);
  theLoad.finalize();
  assert(theLoad.align === 4);
  console.log(theLoad.toText());
  assert(
    theLoad.toText()
    ==
    "(i64.atomic.load offset=32 align=4\n (i32.const 128)\n)\n"
  );

  module.dispose();
})();
