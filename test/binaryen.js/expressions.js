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
  assert(theExpression instanceof binaryen.Block);
  assert(theExpression instanceof binaryen.Expression);
  assert(theExpression.constructor === binaryen.Block);
  assert(typeof binaryen.Block.getId === "function"); // proto
  assert(typeof binaryen.Block.getName === "function"); // own
  assert(typeof theExpression.getId === "function"); // proto
  assert(typeof theExpression.getName === "function"); // own
  assert((theExpression | 0) === 42); // via valueOf
})();

console.log("# Block");
(function testBlock() {
  const module = new binaryen.Module();

  const theBlock = binaryen.Block(module.block(null, []));
  assert(theBlock instanceof binaryen.Block);
  assert(theBlock instanceof binaryen.Expression);
  assert(theBlock.id === binaryen.BlockId);
  assert(theBlock.name === null);
  assert(theBlock.type === binaryen.none);
  
  var info = binaryen.getExpressionInfo(theBlock);
  assert(info.id === theBlock.id);
  assert(info.type === theBlock.type);
  assert(info.name === theBlock.name);
  assertDeepEqual(info.children, theBlock.children);

  theBlock.name ="theName";
  assert(theBlock.name === "theName");
  theBlock.type = binaryen.i32;
  assert(theBlock.type === binaryen.i32);
  assert(theBlock.numChildren === 0);
  assertDeepEqual(theBlock.children, []);
  assertDeepEqual(theBlock.getChildren(), []);

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

  info = binaryen.getExpressionInfo(theBlock);
  assert(info.name === theBlock.name);
  assertDeepEqual(info.children, theBlock.children);

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
  const module = new binaryen.Module();

  var condition = module.i32.const(1);
  var ifTrue = module.i32.const(2);
  var ifFalse = module.i32.const(3);
  const theIf = binaryen.If(module.if(condition, ifTrue, ifFalse));
  assert(theIf instanceof binaryen.If);
  assert(theIf instanceof binaryen.Expression);
  assert(theIf.id === binaryen.IfId);
  assert(theIf.condition === condition);
  assert(theIf.ifTrue === ifTrue);
  assert(theIf.ifFalse === ifFalse);
  assert(theIf.type == binaryen.i32);

  var info = binaryen.getExpressionInfo(theIf);
  assert(info.id === theIf.id);
  assert(info.type === theIf.type);
  assert(info.condition === theIf.condition);
  assert(info.ifTrue === theIf.ifTrue);
  assert(info.ifFalse === theIf.ifFalse);

  theIf.condition = condition = module.i32.const(4);
  assert(theIf.condition === condition);
  theIf.ifTrue = ifTrue = module.i32.const(5);
  assert(theIf.ifTrue === ifTrue);
  theIf.ifFalse = ifFalse = module.i32.const(6);
  assert(theIf.ifFalse === ifFalse);
  theIf.finalize();

  info = binaryen.getExpressionInfo(theIf);
  assert(info.condition === theIf.condition);
  assert(info.ifTrue === theIf.ifTrue);
  assert(info.ifFalse === theIf.ifFalse);

  console.log(theIf.toText());
  assert(
    theIf.toText()
    ==
        "(if (result i32)\n (i32.const 4)\n (then\n  (i32.const 5)\n )\n (else\n  (i32.const 6)\n )\n)\n"
  );

  theIf.ifFalse = null;
  assert(!theIf.ifFalse);

  info = binaryen.getExpressionInfo(theIf);
  assert(info.ifFalse === theIf.ifFalse);

  console.log(theIf.toText());
  assert(
    theIf.toText()
    ==
        "(if (result i32)\n (i32.const 4)\n (then\n  (i32.const 5)\n )\n)\n"
  );

  module.dispose();
})();

console.log("# Loop");
(function testLoop() {
  const module = new binaryen.Module();

  var name = null;
  var body = module.i32.const(1);
  const theLoop = binaryen.Loop(module.loop(name, body));
  assert(theLoop instanceof binaryen.Loop);
  assert(theLoop instanceof binaryen.Expression);
  assert(theLoop.id === binaryen.LoopId);
  assert(theLoop.name === name);
  assert(theLoop.body === body);
  assert(theLoop.type === binaryen.i32);

  var info = binaryen.getExpressionInfo(theLoop);
  assert(info.id === theLoop.id);
  assert(info.type === theLoop.type);
  assert(info.name === theLoop.name);
  assert(info.body === theLoop.body);

  theLoop.name = name = "theName";
  assert(theLoop.name === name);
  theLoop.body = body = module.drop(body);
  assert(theLoop.body === body);
  theLoop.finalize();
  assert(theLoop.type === binaryen.none);

  info = binaryen.getExpressionInfo(theLoop);
  assert(info.type === theLoop.type);
  assert(info.name === theLoop.name);
  assert(info.body === theLoop.body);

  console.log(theLoop.toText());
  assert(
    theLoop.toText()
    ==
    "(loop $theName\n (drop\n  (i32.const 1)\n )\n)\n"
  );

  module.dispose();
})();

console.log("# Break");
(function testBreak() {
  const module = new binaryen.Module();

  var name = "theName";
  var condition = module.i32.const(1);
  var value = module.i32.const(2);
  const theBreak = binaryen.Break(module.br(name, condition, value));
  assert(theBreak instanceof binaryen.Break);
  assert(theBreak instanceof binaryen.Expression);
  assert(theBreak.name === name);
  assert(theBreak.condition === condition);
  assert(theBreak.value === value);
  assert(theBreak.type === binaryen.i32);

  var info = binaryen.getExpressionInfo(theBreak);
  assert(info.id === theBreak.id);
  assert(info.type === theBreak.type);
  assert(info.name === theBreak.name);
  assert(info.condition === theBreak.condition);
  assert(info.value === theBreak.value);

  theBreak.name = name = "theNewName";
  assert(theBreak.name === "theNewName");
  theBreak.condition = condition = module.i32.const(3);
  assert(theBreak.condition === condition);
  theBreak.value = value = module.i32.const(4);
  assert(theBreak.value === value);
  theBreak.finalize();

  info = binaryen.getExpressionInfo(theBreak);
  assert(info.name === theBreak.name);
  assert(info.condition === theBreak.condition);
  assert(info.value === theBreak.value);

  console.log(theBreak.toText());
  assert(
    theBreak.toText()
    ==
    "(br_if $theNewName\n (i32.const 4)\n (i32.const 3)\n)\n"
  );

  module.dispose();
})();

console.log("# Switch");
(function testSwitch() {
  const module = new binaryen.Module();

  var names = ["a", "b"];
  var defaultName = "c";
  var condition = module.i32.const(1);
  var value = module.i32.const(2);
  const theSwitch = binaryen.Switch(module.switch(names, defaultName, condition, value));
  assert(theSwitch instanceof binaryen.Switch);
  assert(theSwitch instanceof binaryen.Expression);
  assert(theSwitch.numNames === 2);
  assertDeepEqual(theSwitch.names, names);
  assert(theSwitch.defaultName === defaultName);
  assert(theSwitch.condition === condition);
  assert(theSwitch.value === value);
  assert(theSwitch.type === binaryen.unreachable);

  var info = binaryen.getExpressionInfo(theSwitch);
  assert(info.id === theSwitch.id);
  assert(info.type === theSwitch.type);
  assertDeepEqual(info.names, theSwitch.names);
  assert(info.defaultName === theSwitch.defaultName);
  assert(info.condition === theSwitch.condition);
  assert(info.value === theSwitch.value);

  names = [
    "1", // set
    "2", //set
    "3" // append
  ]
  theSwitch.setNames(names);
  assertDeepEqual(theSwitch.names, names);
  theSwitch.names = names = [
    "x", // set
    // remove
    // remove
  ];
  assertDeepEqual(theSwitch.names, names);
  assertDeepEqual(theSwitch.getNames(), names);
  theSwitch.insertNameAt(1, "y");
  theSwitch.condition = condition = module.i32.const(3);
  assert(theSwitch.condition === condition);
  theSwitch.value = value = module.i32.const(4);
  assert(theSwitch.value === value);
  theSwitch.finalize();

  info = binaryen.getExpressionInfo(theSwitch);
  assertDeepEqual(info.names, theSwitch.names);
  assert(info.defaultName === theSwitch.defaultName);
  assert(info.condition === theSwitch.condition);
  assert(info.value === theSwitch.value);

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
  const module = new binaryen.Module();

  var target = "foo";
  var operands = [
    module.i32.const(1),
    module.i32.const(2)
  ];
  const theCall = binaryen.Call(module.call(target, operands, binaryen.i32));
  assert(theCall instanceof binaryen.Call);
  assert(theCall instanceof binaryen.Expression);
  assert(theCall.target === target);
  assertDeepEqual(theCall.operands, operands);
  assertDeepEqual(theCall.getOperands(), operands);
  assert(theCall.return === false);
  assert(theCall.type === binaryen.i32);

  var info = binaryen.getExpressionInfo(theCall);
  assert(info.id === theCall.id);
  assert(info.type === theCall.type);
  assert(info.target === theCall.target);
  assertDeepEqual(info.operands, theCall.operands);
  assert(info.isReturn === theCall.return);

  theCall.target = "bar";
  assert(theCall.target === "bar");
  theCall.operands = operands = [
    module.i32.const(3), // set
    module.i32.const(4), // set
    module.i32.const(5)  // append
  ];
  assertDeepEqual(theCall.operands, operands);
  operands = [
    module.i32.const(6) // set
    // remove
    // remove
  ];
  theCall.setOperands(operands);
  assertDeepEqual(theCall.operands, operands);
  theCall.insertOperandAt(0, module.i32.const(7));
  theCall.return = true;
  assert(theCall.return === true);
  theCall.finalize();
  assert(theCall.type === binaryen.unreachable); // finalized tail call

  info = binaryen.getExpressionInfo(theCall);
  assert(info.type === theCall.type);
  assert(info.target === theCall.target);
  assertDeepEqual(info.operands, theCall.operands);
  assert(info.isReturn === theCall.return);

  theCall.return = false;
  theCall.type = binaryen.i32;
  theCall.finalize();
  assert(theCall.type === binaryen.i32); // finalized call

  info = binaryen.getExpressionInfo(theCall);
  assert(info.type === theCall.type);
  assert(info.isReturn === theCall.return);

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
  const module = new binaryen.Module();

  var table = "0";
  var target = module.i32.const(42);
  var params = binaryen.none;
  var results = binaryen.none;
  var operands = [
    module.i32.const(1),
    module.i32.const(2)
  ];
  const theCallIndirect = binaryen.CallIndirect(module.call_indirect(table, target, operands, params, results));
  assert(theCallIndirect instanceof binaryen.CallIndirect);
  assert(theCallIndirect instanceof binaryen.Expression);
  assert(theCallIndirect.table === table);
  assert(theCallIndirect.target === target);
  assertDeepEqual(theCallIndirect.operands, operands);
  assert(theCallIndirect.params === params);
  assert(theCallIndirect.results === results);
  assert(theCallIndirect.return === false);
  assert(theCallIndirect.type === theCallIndirect.results);

  var info = binaryen.getExpressionInfo(theCallIndirect);
  assert(info.id === theCallIndirect.id);
  assert(info.type === theCallIndirect.type);
  assert(info.table === theCallIndirect.table);
  assert(info.target === theCallIndirect.target);
  assertDeepEqual(info.operands, theCallIndirect.operands);
  assert(info.params === theCallIndirect.params);
  assert(info.results === theCallIndirect.results);
  assert(info.isReturn === theCallIndirect.return);

  theCallIndirect.target = target = module.i32.const(9000);
  assert(theCallIndirect.target === target);
  theCallIndirect.operands = operands = [
    module.i32.const(3), // set
    module.i32.const(4), // set
    module.i32.const(5)  // append
  ];
  assertDeepEqual(theCallIndirect.operands, operands);
  operands = [
    module.i32.const(6) // set
    // remove
    // remove
  ];
  theCallIndirect.setOperands(operands);
  assertDeepEqual(theCallIndirect.operands, operands);
  assertDeepEqual(theCallIndirect.getOperands(), operands);
  theCallIndirect.insertOperandAt(0, module.i32.const(7));
  theCallIndirect.return = true;
  assert(theCallIndirect.return === true);
  theCallIndirect.params = params = binaryen.createType([ binaryen.i32, binaryen.i32 ]);
  assert(theCallIndirect.params === params);
  theCallIndirect.results = results = binaryen.i32;
  assert(theCallIndirect.results === results);
  theCallIndirect.finalize();
  assert(theCallIndirect.type === binaryen.unreachable); // finalized tail call

  info = binaryen.getExpressionInfo(theCallIndirect);
  assert(info.type === theCallIndirect.type);
  assert(info.target === theCallIndirect.target);
  assertDeepEqual(info.operands, theCallIndirect.operands);
  assert(info.params === theCallIndirect.params);
  assert(info.results === theCallIndirect.results);
  assert(info.isReturn === theCallIndirect.return);

  theCallIndirect.return = false;
  theCallIndirect.finalize();
  assert(theCallIndirect.type === results); // finalized call

  info = binaryen.getExpressionInfo(theCallIndirect);
  assert(info.isReturn === theCallIndirect.return);

  console.log(theCallIndirect.toText());
  assert(
    theCallIndirect.toText()
    ==
    "(call_indirect $0 (type $func.0)\n (i32.const 7)\n (i32.const 6)\n (i32.const 9000)\n)\n"
  );

  module.dispose();
})();

console.log("# LocalGet");
(function testLocalGet() {
  const module = new binaryen.Module();

  var index = 1;
  var type = binaryen.i32;
  const theLocalGet = binaryen.LocalGet(module.local.get(index, type));
  assert(theLocalGet instanceof binaryen.LocalGet);
  assert(theLocalGet instanceof binaryen.Expression);
  assert(theLocalGet.index === index);
  assert(theLocalGet.type === type);

  var info = binaryen.getExpressionInfo(theLocalGet);
  assert(info.id === theLocalGet.id);
  assert(info.type === theLocalGet.type);
  assert(info.index === theLocalGet.index);

  theLocalGet.index = index = 2;
  assert(theLocalGet.index === index);
  theLocalGet.type = type = binaryen.f64;
  assert(theLocalGet.type === type);
  theLocalGet.finalize();

  info = binaryen.getExpressionInfo(theLocalGet);
  assert(info.type === theLocalGet.type);
  assert(info.index === theLocalGet.index);

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
  const module = new binaryen.Module();

  var index = 1;
  var value = module.i32.const(1);
  const theLocalSet = binaryen.LocalSet(module.local.set(index, value));
  assert(theLocalSet instanceof binaryen.LocalSet);
  assert(theLocalSet instanceof binaryen.Expression);
  assert(theLocalSet.index === index);
  assert(theLocalSet.value === value);
  assert(theLocalSet.tee === false);
  assert(theLocalSet.type == binaryen.none);

  var info = binaryen.getExpressionInfo(theLocalSet);
  assert(info.id === theLocalSet.id);
  assert(info.type === theLocalSet.type);
  assert(info.index === theLocalSet.index);
  assert(info.value === theLocalSet.value);
  assert(info.isTee === theLocalSet.tee)

  theLocalSet.index = index = 2;
  assert(theLocalSet.index === index);
  theLocalSet.value = value = module.i32.const(3);
  assert(theLocalSet.value === value);
  theLocalSet.type = binaryen.i32;
  assert(theLocalSet.type === binaryen.i32);
  assert(theLocalSet.tee === true);
  theLocalSet.type = binaryen.none;
  theLocalSet.finalize();

  info = binaryen.getExpressionInfo(theLocalSet);
  assert(info.type === theLocalSet.type);
  assert(info.index === theLocalSet.index);
  assert(info.value === theLocalSet.value);
  assert(info.isTee === theLocalSet.tee)

  console.log(theLocalSet.toText());
  assert(
    theLocalSet.toText()
    ==
    "(local.set $2\n (i32.const 3)\n)\n"
  );

  module.dispose();
})();

console.log("# GlobalGet");
(function testGlobalGet() {
  const module = new binaryen.Module();

  var name = "a";
  var type = binaryen.i32;
  const theGlobalGet = binaryen.GlobalGet(module.global.get(name, type));
  assert(theGlobalGet instanceof binaryen.GlobalGet);
  assert(theGlobalGet instanceof binaryen.Expression);
  assert(theGlobalGet.name === name);
  assert(theGlobalGet.type === type);

  var info = binaryen.getExpressionInfo(theGlobalGet);
  assert(info.id === theGlobalGet.id);
  assert(info.type === theGlobalGet.type);
  assert(info.name === theGlobalGet.name);

  theGlobalGet.name = name = "b";
  assert(theGlobalGet.name === name);
  theGlobalGet.type = type = binaryen.f64;
  assert(theGlobalGet.type === type);
  theGlobalGet.finalize();

  info = binaryen.getExpressionInfo(theGlobalGet);
  assert(info.type === theGlobalGet.type);
  assert(info.name === theGlobalGet.name);

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
  const module = new binaryen.Module();

  var name = "a";
  var value = module.i32.const(1);
  const theGlobalSet = binaryen.GlobalSet(module.global.set(name, value));
  assert(theGlobalSet instanceof binaryen.GlobalSet);
  assert(theGlobalSet instanceof binaryen.Expression);
  assert(theGlobalSet.name === name);
  assert(theGlobalSet.value === value);
  assert(theGlobalSet.type == binaryen.none);

  var info = binaryen.getExpressionInfo(theGlobalSet);
  assert(info.id === theGlobalSet.id);
  assert(info.type === theGlobalSet.type);
  assert(info.name === theGlobalSet.name);
  assert(info.value === theGlobalSet.value);

  theGlobalSet.name = name = "b";
  assert(theGlobalSet.name === name);
  theGlobalSet.value = value = module.f64.const(3);
  assert(theGlobalSet.value === value);
  theGlobalSet.finalize();

  info = binaryen.getExpressionInfo(theGlobalSet);
  assert(info.name === theGlobalSet.name);
  assert(info.value === theGlobalSet.value);

  console.log(theGlobalSet.toText());
  assert(
    theGlobalSet.toText()
    ==
    "(global.set $b\n (f64.const 3)\n)\n"
  );

  module.dispose();
})();

console.log("# MemorySize");
(function testMemorySize() {
  const module = new binaryen.Module();
  module.setMemory(1, 1, null);
  var type = binaryen.i32;
  const theMemorySize = binaryen.MemorySize(module.memory.size());
  assert(theMemorySize instanceof binaryen.MemorySize);
  assert(theMemorySize instanceof binaryen.Expression);
  assert(theMemorySize.type === type);
  theMemorySize.finalize();

  var info = binaryen.getExpressionInfo(theMemorySize);
  assert(info.id === theMemorySize.id);
  assert(info.type === theMemorySize.type);

  console.log(theMemorySize.toText());
  assert(
    theMemorySize.toText()
    ==
    "(memory.size $0)\n"
  );

  module.dispose();
})();

console.log("# MemoryGrow");
(function testMemoryGrow() {
  const module = new binaryen.Module();
  module.setMemory(1, 1, null);

  var type = binaryen.i32;
  var delta = module.i32.const(1);
  const theMemoryGrow = binaryen.MemoryGrow(module.memory.grow(delta));
  assert(theMemoryGrow instanceof binaryen.MemoryGrow);
  assert(theMemoryGrow instanceof binaryen.Expression);
  assert(theMemoryGrow.delta === delta);
  assert(theMemoryGrow.type === type);

  var info = binaryen.getExpressionInfo(theMemoryGrow);
  assert(info.id === theMemoryGrow.id);
  assert(info.type === theMemoryGrow.type);
  assert(info.delta === theMemoryGrow.delta);

  theMemoryGrow.delta = delta = module.i32.const(2);
  assert(theMemoryGrow.delta === delta);
  theMemoryGrow.finalize();

  info = binaryen.getExpressionInfo(theMemoryGrow);
  assert(info.delta === theMemoryGrow.delta);

  console.log(theMemoryGrow.toText());
  assert(
    theMemoryGrow.toText()
    ==
    "(memory.grow $0\n (i32.const 2)\n)\n"
  );

  module.dispose();
})();

console.log("# Load");
(function testLoad() {
  const module = new binaryen.Module();
  module.setMemory(1, 1, null);

  var offset = 16;
  var align = 2;
  var ptr = module.i32.const(64);
  const theLoad = binaryen.Load(module.i32.load(offset, align, ptr));
  assert(theLoad instanceof binaryen.Load);
  assert(theLoad instanceof binaryen.Expression);
  assert(theLoad.offset === offset);
  assert(theLoad.align === align);
  assert(theLoad.ptr === ptr);
  assert(theLoad.bytes === 4);
  assert(theLoad.signed === true);
  assert(theLoad.atomic === false);
  assert(theLoad.type == binaryen.i32);

  var info = binaryen.getExpressionInfo(theLoad);
  assert(info.id === theLoad.id);
  assert(info.type === theLoad.type);
  assert(info.offset === theLoad.offset);
  assert(info.align === theLoad.align);
  assert(info.ptr === theLoad.ptr);
  assert(info.bytes === theLoad.bytes);
  assert(info.isSigned === theLoad.signed);
  assert(info.isAtomic === theLoad.atomic);

  theLoad.offset = offset = 32;
  assert(theLoad.offset === offset);
  theLoad.align = align = 4;
  assert(theLoad.align === align);
  theLoad.ptr = ptr = module.i32.const(128);
  assert(theLoad.ptr === ptr);
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

  info = binaryen.getExpressionInfo(theLoad);
  assert(info.offset === theLoad.offset);
  assert(info.align === theLoad.align);
  assert(info.ptr === theLoad.ptr);
  assert(info.bytes === theLoad.bytes);
  assert(info.isSigned === theLoad.signed);
  assert(info.isAtomic === theLoad.atomic);

  console.log(theLoad.toText());
  assert(
    theLoad.toText()
    ==
    "(i64.atomic.load $0 offset=32 align=4\n (i32.const 128)\n)\n"
  );

  module.dispose();
})();

console.log("# Store");
(function testStore() {
  const module = new binaryen.Module();
  module.setMemory(1, 1, null);

  var offset = 16;
  var align = 2;
  var ptr = module.i32.const(64);
  var value = module.i32.const(1);
  const theStore = binaryen.Store(module.i32.store(offset, align, ptr, value));
  assert(theStore instanceof binaryen.Store);
  assert(theStore instanceof binaryen.Expression);
  assert(theStore.offset === offset);
  assert(theStore.align === align);
  assert(theStore.ptr === ptr);
  assert(theStore.value === value);
  assert(theStore.bytes === 4);
  assert(theStore.atomic === false);
  assert(theStore.valueType === binaryen.i32);
  assert(theStore.type === binaryen.none);

  var info = binaryen.getExpressionInfo(theStore);
  assert(info.id === theStore.id);
  assert(info.type === theStore.type);
  assert(info.offset === theStore.offset);
  assert(info.align === theStore.align);
  assert(info.ptr === theStore.ptr);
  assert(info.value === theStore.value);
  assert(info.bytes === theStore.bytes);
  assert(info.isAtomic === theStore.atomic);
  assert(info.valueType === theStore.valueType);

  theStore.offset = offset = 32;
  assert(theStore.offset === offset);
  theStore.align = align = 4;
  assert(theStore.align === align);
  theStore.ptr = ptr = module.i32.const(128);
  assert(theStore.ptr === ptr);
  theStore.value = value = module.i32.const(2);
  assert(theStore.value === value);
  theStore.signed = false;
  assert(theStore.signed === false);
  theStore.valueType = binaryen.i64;
  assert(theStore.valueType === binaryen.i64);
  theStore.bytes = 8;
  assert(theStore.bytes === 8);
  theStore.atomic = true;
  assert(theStore.atomic === true);
  theStore.finalize();
  assert(theStore.align === 4);

  info = binaryen.getExpressionInfo(theStore);
  assert(info.offset === theStore.offset);
  assert(info.align === theStore.align);
  assert(info.ptr === theStore.ptr);
  assert(info.value === theStore.value);
  assert(info.bytes === theStore.bytes);
  assert(info.isAtomic === theStore.atomic);
  assert(info.valueType === theStore.valueType);

  console.log(theStore.toText());
  assert(
    theStore.toText()
    ==
    "(i64.atomic.store $0 offset=32 align=4\n (i32.const 128)\n (i32.const 2)\n)\n"
  );

  module.dispose();
})();

console.log("# Const");
(function testConst() {
  const module = new binaryen.Module();

  const theConst = binaryen.Const(module.i32.const(1));
  assert(theConst instanceof binaryen.Const);
  assert(theConst instanceof binaryen.Expression);
  assert(theConst.valueI32 === 1);
  theConst.valueI32 = 2;
  assert(theConst.valueI32 === 2);
  assert(theConst.type === binaryen.i32);

  var info = binaryen.getExpressionInfo(theConst);
  assert(info.id === theConst.id);
  assert(info.type === theConst.type);
  assert(info.value === theConst.valueI32);

  theConst.valueI64Low = 3;
  assert(theConst.valueI64Low === 3);
  theConst.valueI64High = 4;
  assert(theConst.valueI64High === 4);
  theConst.finalize();
  assert(theConst.type == binaryen.i64);

  info = binaryen.getExpressionInfo(theConst);
  assert(info.type === theConst.type);
  assert(info.value.low === theConst.valueI64Low);
  assert(info.value.high === theConst.valueI64High);

  theConst.valueF32 = 5;
  assert(theConst.valueF32 === 5);
  theConst.finalize();
  assert(theConst.type === binaryen.f32);

  info = binaryen.getExpressionInfo(theConst);
  assert(info.type === theConst.type);
  assert(info.value === theConst.valueF32);

  theConst.valueF64 = 6;
  assert(theConst.valueF64 === 6);
  theConst.finalize();
  assert(theConst.type === binaryen.f64);

  info = binaryen.getExpressionInfo(theConst);
  assert(info.type === theConst.type);
  assert(info.value === theConst.valueF64);

  theConst.valueV128 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];
  assertDeepEqual(theConst.valueV128, [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]);
  theConst.finalize();
  assert(theConst.type === binaryen.v128);

  info = binaryen.getExpressionInfo(theConst);
  assert(info.type === theConst.type);
  assertDeepEqual(info.value, theConst.valueV128);

  console.log(theConst.toText());
  assert(
    theConst.toText()
    ==
    "(v128.const i32x4 0x04030201 0x08070605 0x0c0b0a09 0x100f0e0d)\n"
  );

  module.dispose();
})();

console.log("# Unary");
(function testUnary() {
  const module = new binaryen.Module();

  var op = binaryen.Operations.EqZInt32;
  var value = module.i32.const(1);
  const theUnary = binaryen.Unary(module.i32.eqz(value));
  assert(theUnary instanceof binaryen.Unary);
  assert(theUnary instanceof binaryen.Expression);
  assert(theUnary.op === op);
  assert(theUnary.value === value);
  assert(theUnary.type === binaryen.i32);

  var info = binaryen.getExpressionInfo(theUnary);
  assert(info.id === theUnary.id);
  assert(info.type === theUnary.type);
  assert(info.op === theUnary.op);
  assert(info.value === theUnary.value);

  theUnary.op = op = binaryen.Operations.EqZInt64;
  assert(theUnary.op === op);
  theUnary.value = value = module.i64.const(2);
  assert(theUnary.value === value);
  theUnary.type = binaryen.f32;
  theUnary.finalize();
  assert(theUnary.type === binaryen.i32);

  info = binaryen.getExpressionInfo(theUnary);
  assert(info.type === theUnary.type);
  assert(info.op === theUnary.op);
  assert(info.value === theUnary.value);

  console.log(theUnary.toText());
  assert(
    theUnary.toText()
    ==
    "(i64.eqz\n (i64.const 2)\n)\n"
  );

  module.dispose();
})();

console.log("# Binary");
(function testBinary() {
  const module = new binaryen.Module();

  var op = binaryen.Operations.AddInt32;
  var left = module.i32.const(1);
  var right = module.i32.const(2);
  const theBinary = binaryen.Binary(module.i32.add(left, right));
  assert(theBinary instanceof binaryen.Binary);
  assert(theBinary instanceof binaryen.Expression);
  assert(theBinary.op === op);
  assert(theBinary.left === left);
  assert(theBinary.right === right);
  assert(theBinary.type === binaryen.i32)

  var info = binaryen.getExpressionInfo(theBinary);
  assert(info.id === theBinary.id);
  assert(info.type === theBinary.type);
  assert(info.op === theBinary.op);
  assert(info.left === theBinary.left);
  assert(info.right === theBinary.right);

  theBinary.op = op = binaryen.Operations.AddInt64;
  assert(theBinary.op === op);
  theBinary.left = left = module.i64.const(3);
  assert(theBinary.left === left);
  theBinary.right = right = module.i64.const(4);
  assert(theBinary.right === right);
  theBinary.type = binaryen.f32;
  theBinary.finalize();
  assert(theBinary.type === binaryen.i64);

  info = binaryen.getExpressionInfo(theBinary);
  assert(info.type === theBinary.type);
  assert(info.op === theBinary.op);
  assert(info.left === theBinary.left);
  assert(info.right === theBinary.right);

  console.log(theBinary.toText());
  assert(
    theBinary.toText()
    ==
    "(i64.add\n (i64.const 3)\n (i64.const 4)\n)\n"
  );

  module.dispose();
})();

console.log("# Select");
(function testSelect() {
  const module = new binaryen.Module();

  var condition = module.i32.const(1);
  var ifTrue = module.i32.const(2);
  var ifFalse = module.i32.const(3);
  const theSelect = binaryen.Select(module.select(condition, ifTrue, ifFalse));  assert(theSelect.ifTrue === ifTrue);
  assert(theSelect instanceof binaryen.Select);
  assert(theSelect instanceof binaryen.Expression);
  assert(theSelect.condition === condition);
  assert(theSelect.ifTrue === ifTrue);
  assert(theSelect.ifFalse === ifFalse);
  assert(theSelect.type === binaryen.i32);

  var info = binaryen.getExpressionInfo(theSelect);
  assert(info.id === theSelect.id);
  assert(info.type === theSelect.type);
  assert(info.condition === theSelect.condition);
  assert(info.ifTrue === theSelect.ifTrue);
  assert(info.ifFalse === theSelect.ifFalse);

  theSelect.condition = condition = module.i32.const(4);
  assert(theSelect.condition === condition);
  theSelect.ifTrue = ifTrue = module.i64.const(5);
  assert(theSelect.ifTrue === ifTrue);
  theSelect.ifFalse = ifFalse = module.i64.const(6);
  assert(theSelect.ifFalse === ifFalse);
  theSelect.finalize();
  assert(theSelect.type === binaryen.i64);

  info = binaryen.getExpressionInfo(theSelect);
  assert(info.type === theSelect.type);
  assert(info.condition === theSelect.condition);
  assert(info.ifTrue === theSelect.ifTrue);
  assert(info.ifFalse === theSelect.ifFalse);

  console.log(theSelect.toText());
  assert(
    theSelect.toText()
    ==
    "(select\n (i64.const 5)\n (i64.const 6)\n (i32.const 4)\n)\n"
  );

  module.dispose();
})();

console.log("# Drop");
(function testDrop() {
  const module = new binaryen.Module();

  var value = module.i32.const(1);
  const theDrop = binaryen.Drop(module.drop(value));
  assert(theDrop instanceof binaryen.Drop);
  assert(theDrop instanceof binaryen.Expression);
  assert(theDrop.value === value);
  assert(theDrop.type === binaryen.none);

  var info = binaryen.getExpressionInfo(theDrop);
  assert(info.id === theDrop.id);
  assert(info.type === theDrop.type);
  assert(info.value === theDrop.value);

  theDrop.value = value = module.i32.const(2);
  assert(theDrop.value === value);

  theDrop.finalize();
  assert(theDrop.type === binaryen.none);

  info = binaryen.getExpressionInfo(theDrop);
  assert(info.type === theDrop.type);
  assert(info.value === theDrop.value);

  console.log(theDrop.toText());
  assert(
    theDrop.toText()
    ==
    "(drop\n (i32.const 2)\n)\n"
  );

  module.dispose();
})();

console.log("# Return");
(function testReturn() {
  const module = new binaryen.Module();

  var value = module.i32.const(1);
  const theReturn = binaryen.Return(module.return(value));
  assert(theReturn instanceof binaryen.Return);
  assert(theReturn instanceof binaryen.Expression);
  assert(theReturn.value === value);
  assert(theReturn.type === binaryen.unreachable);

  var info = binaryen.getExpressionInfo(theReturn);
  assert(info.id === theReturn.id);
  assert(info.type === theReturn.type);
  assert(info.value === theReturn.value);

  theReturn.value = value = module.i32.const(2);
  assert(theReturn.value === value);

  theReturn.finalize();
  assert(theReturn.type === binaryen.unreachable);

  info = binaryen.getExpressionInfo(theReturn);
  assert(info.type === theReturn.type);
  assert(info.value === theReturn.value);

  console.log(theReturn.toText());
  assert(
    theReturn.toText()
    ==
    "(return\n (i32.const 2)\n)\n"
  );

  module.dispose();
})();

console.log("# AtomicRMW");
(function testAtomicRMW() {
  const module = new binaryen.Module();
  module.setMemory(1, 1, null);

  var op = binaryen.Operations.AtomicRMWAdd;
  var offset = 8;
  var ptr = module.i32.const(2);
  var value = module.i32.const(3);
  const theAtomicRMW = binaryen.AtomicRMW(module.i32.atomic.rmw.add(offset, ptr, value));
  assert(theAtomicRMW instanceof binaryen.AtomicRMW);
  assert(theAtomicRMW instanceof binaryen.Expression);
  assert(theAtomicRMW.op === op);
  assert(theAtomicRMW.bytes === 4);
  assert(theAtomicRMW.offset === offset);
  assert(theAtomicRMW.ptr === ptr);
  assert(theAtomicRMW.value === value);
  assert(theAtomicRMW.type === binaryen.i32);

  var info = binaryen.getExpressionInfo(theAtomicRMW);
  assert(info.id === theAtomicRMW.id);
  assert(info.type === theAtomicRMW.type);
  assert(info.op === theAtomicRMW.op);
  assert(info.bytes === theAtomicRMW.bytes);
  assert(info.offset === theAtomicRMW.offset);
  assert(info.ptr === theAtomicRMW.ptr);
  assert(info.value === theAtomicRMW.value);

  theAtomicRMW.op = op = binaryen.Operations.AtomicRMWSub;
  assert(theAtomicRMW.op === op);
  theAtomicRMW.bytes = 2;
  assert(theAtomicRMW.bytes === 2);
  theAtomicRMW.offset = offset = 16;
  assert(theAtomicRMW.offset === offset);
  theAtomicRMW.ptr = ptr = module.i32.const(4);
  assert(theAtomicRMW.ptr === ptr);
  theAtomicRMW.value = value = module.i64.const(5);
  assert(theAtomicRMW.value === value);
  theAtomicRMW.type = binaryen.i64;
  theAtomicRMW.finalize();
  assert(theAtomicRMW.type === binaryen.i64);

  info = binaryen.getExpressionInfo(theAtomicRMW);
  assert(info.type === theAtomicRMW.type);
  assert(info.op === theAtomicRMW.op);
  assert(info.bytes === theAtomicRMW.bytes);
  assert(info.offset === theAtomicRMW.offset);
  assert(info.ptr === theAtomicRMW.ptr);
  assert(info.value === theAtomicRMW.value);

  console.log(theAtomicRMW.toText());
  assert(
    theAtomicRMW.toText()
    ==
    "(i64.atomic.rmw16.sub_u $0 offset=16\n (i32.const 4)\n (i64.const 5)\n)\n"
  );

  module.dispose();
})();

console.log("# AtomicCmpxchg");
(function testAtomicCmpxchg() {
  const module = new binaryen.Module();
  module.setMemory(1, 1, null);

  var offset = 8;
  var ptr = module.i32.const(2);
  var expected = module.i32.const(3);
  var replacement = module.i32.const(4);
  const theAtomicCmpxchg = binaryen.AtomicCmpxchg(module.i32.atomic.rmw.cmpxchg(offset, ptr, expected, replacement));
  assert(theAtomicCmpxchg instanceof binaryen.AtomicCmpxchg);
  assert(theAtomicCmpxchg instanceof binaryen.Expression);
  assert(theAtomicCmpxchg.bytes === 4);
  assert(theAtomicCmpxchg.offset === offset);
  assert(theAtomicCmpxchg.ptr === ptr);
  assert(theAtomicCmpxchg.expected === expected);
  assert(theAtomicCmpxchg.replacement === replacement);
  assert(theAtomicCmpxchg.type === binaryen.i32);

  var info = binaryen.getExpressionInfo(theAtomicCmpxchg);
  assert(info.id === theAtomicCmpxchg.id);
  assert(info.type === theAtomicCmpxchg.type);
  assert(info.bytes === theAtomicCmpxchg.bytes);
  assert(info.offset === theAtomicCmpxchg.offset);
  assert(info.ptr === theAtomicCmpxchg.ptr);
  assert(info.expected === theAtomicCmpxchg.expected);
  assert(info.replacement === theAtomicCmpxchg.replacement);

  theAtomicCmpxchg.bytes = 2;
  assert(theAtomicCmpxchg.bytes === 2);
  theAtomicCmpxchg.offset = offset = 16;
  assert(theAtomicCmpxchg.offset === offset);
  theAtomicCmpxchg.ptr = ptr = module.i32.const(5);
  assert(theAtomicCmpxchg.ptr === ptr);
  theAtomicCmpxchg.expected = expected = module.i64.const(6);
  assert(theAtomicCmpxchg.expected === expected);
  theAtomicCmpxchg.replacement = replacement = module.i64.const(7);
  assert(theAtomicCmpxchg.replacement === replacement);
  theAtomicCmpxchg.type = binaryen.i64;
  theAtomicCmpxchg.finalize();
  assert(theAtomicCmpxchg.type === binaryen.i64);

  info = binaryen.getExpressionInfo(theAtomicCmpxchg);
  assert(info.type === theAtomicCmpxchg.type);
  assert(info.bytes === theAtomicCmpxchg.bytes);
  assert(info.offset === theAtomicCmpxchg.offset);
  assert(info.ptr === theAtomicCmpxchg.ptr);
  assert(info.expected === theAtomicCmpxchg.expected);
  assert(info.replacement === theAtomicCmpxchg.replacement);

  console.log(theAtomicCmpxchg.toText());
  assert(
    theAtomicCmpxchg.toText()
    ==
    "(i64.atomic.rmw16.cmpxchg_u $0 offset=16\n (i32.const 5)\n (i64.const 6)\n (i64.const 7)\n)\n"
  );

  module.dispose();
})();

console.log("# AtomicWait");
(function testAtomicWait() {
  const module = new binaryen.Module();
  module.setMemory(1, 1, null);

  var ptr = module.i32.const(2);
  var expected = module.i32.const(3);
  var timeout = module.i64.const(4);
  const theAtomicWait = binaryen.AtomicWait(module.memory.atomic.wait32(ptr, expected, timeout));
  assert(theAtomicWait instanceof binaryen.AtomicWait);
  assert(theAtomicWait instanceof binaryen.Expression);
  assert(theAtomicWait.ptr === ptr);
  assert(theAtomicWait.expected === expected);
  assert(theAtomicWait.expectedType === binaryen.i32);
  assert(theAtomicWait.timeout === timeout);
  assert(theAtomicWait.type === binaryen.i32);

  var info = binaryen.getExpressionInfo(theAtomicWait);
  assert(info.id === theAtomicWait.id);
  assert(info.type === theAtomicWait.type);
  assert(info.ptr === theAtomicWait.ptr);
  assert(info.expected === theAtomicWait.expected);
  assert(info.expectedType === theAtomicWait.expectedType);
  assert(info.timeout === theAtomicWait.timeout);

  theAtomicWait.ptr = ptr = module.i32.const(5);
  assert(theAtomicWait.ptr === ptr);
  theAtomicWait.expected = expected = module.i32.const(6);
  assert(theAtomicWait.expected === expected);
  theAtomicWait.expectedType = binaryen.i64;
  assert(theAtomicWait.expectedType === binaryen.i64);
  theAtomicWait.timeout = timeout = module.i64.const(7);
  assert(theAtomicWait.timeout === timeout);
  theAtomicWait.type = binaryen.f64;
  theAtomicWait.finalize();
  assert(theAtomicWait.type === binaryen.i32);

  info = binaryen.getExpressionInfo(theAtomicWait);
  assert(info.type === theAtomicWait.type);
  assert(info.ptr === theAtomicWait.ptr);
  assert(info.expected === theAtomicWait.expected);
  assert(info.expectedType === theAtomicWait.expectedType);
  assert(info.timeout === theAtomicWait.timeout);

  console.log(theAtomicWait.toText());
  assert(
    theAtomicWait.toText()
    ==
    "(memory.atomic.wait64 $0\n (i32.const 5)\n (i32.const 6)\n (i64.const 7)\n)\n"
  );

  module.dispose();
})();

console.log("# AtomicNotify");
(function testAtomicNotify() {
  const module = new binaryen.Module();
  module.setMemory(1, 1, null);

  var ptr = module.i32.const(1);
  var notifyCount = module.i32.const(2);
  const theAtomicNotify = binaryen.AtomicNotify(module.memory.atomic.notify(ptr, notifyCount));
  assert(theAtomicNotify instanceof binaryen.AtomicNotify);
  assert(theAtomicNotify instanceof binaryen.Expression);
  assert(theAtomicNotify.ptr === ptr);
  assert(theAtomicNotify.notifyCount === notifyCount);
  assert(theAtomicNotify.type === binaryen.i32);

  var info = binaryen.getExpressionInfo(theAtomicNotify);
  assert(info.id === theAtomicNotify.id);
  assert(info.type === theAtomicNotify.type);
  assert(info.ptr === theAtomicNotify.ptr);
  assert(info.notifyCount === theAtomicNotify.notifyCount);

  theAtomicNotify.ptr = ptr = module.i32.const(3);
  assert(theAtomicNotify.ptr === ptr);
  theAtomicNotify.notifyCount = notifyCount = module.i32.const(4);
  assert(theAtomicNotify.notifyCount === notifyCount);
  theAtomicNotify.type = binaryen.f64;
  theAtomicNotify.finalize();
  assert(theAtomicNotify.type === binaryen.i32);

  info = binaryen.getExpressionInfo(theAtomicNotify);
  assert(info.type === theAtomicNotify.type);
  assert(info.ptr === theAtomicNotify.ptr);
  assert(info.notifyCount === theAtomicNotify.notifyCount);

  console.log(theAtomicNotify.toText());
  assert(
    theAtomicNotify.toText()
    ==
    "(memory.atomic.notify $0\n (i32.const 3)\n (i32.const 4)\n)\n"
  );

  module.dispose();
})();

console.log("# AtomicFence");
(function testAtomicFence() {
  const module = new binaryen.Module();

  const theAtomicFence = binaryen.AtomicFence(module.atomic.fence());
  assert(theAtomicFence instanceof binaryen.AtomicFence);
  assert(theAtomicFence instanceof binaryen.Expression);
  assert(theAtomicFence.order === 0); // reserved, not yet used
  assert(theAtomicFence.type === binaryen.none);

  var info = binaryen.getExpressionInfo(theAtomicFence);
  assert(info.id === theAtomicFence.id);
  assert(info.type === theAtomicFence.type);
  assert(info.order === theAtomicFence.order);

  theAtomicFence.order = 1;
  assert(theAtomicFence.order === 1);
  theAtomicFence.type = binaryen.f64;
  theAtomicFence.finalize();
  assert(theAtomicFence.type === binaryen.none);

  info = binaryen.getExpressionInfo(theAtomicFence);
  assert(info.type === theAtomicFence.type);
  assert(info.order === theAtomicFence.order);

  console.log(theAtomicFence.toText());
  assert(
    theAtomicFence.toText()
    ==
    "(atomic.fence)\n"
  );

  module.dispose();
})();

console.log("# SIMDExtract");
(function testSIMDExtract() {
  const module = new binaryen.Module();

  var op = binaryen.Operations.ExtractLaneSVecI8x16;
  var vec = module.v128.const([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]);
  var index = 0;
  const theSIMDExtract = binaryen.SIMDExtract(module.i8x16.extract_lane_s(vec, index));
  assert(theSIMDExtract instanceof binaryen.SIMDExtract);
  assert(theSIMDExtract instanceof binaryen.Expression);
  assert(theSIMDExtract.op === op);
  assert(theSIMDExtract.vec === vec);
  assert(theSIMDExtract.index === index);
  assert(theSIMDExtract.type === binaryen.i32);

  var info = binaryen.getExpressionInfo(theSIMDExtract);
  assert(info.id === theSIMDExtract.id);
  assert(info.type === theSIMDExtract.type);
  assert(info.op === theSIMDExtract.op);
  assert(info.vec === theSIMDExtract.vec);
  assert(info.index === theSIMDExtract.index);

  theSIMDExtract.op = op = binaryen.Operations.ExtractLaneSVecI16x8;
  assert(theSIMDExtract.op === op);
  theSIMDExtract.vec = vec = module.v128.const([1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]);
  assert(theSIMDExtract.vec === vec);
  theSIMDExtract.index = index = 1;
  assert(theSIMDExtract.index === index);
  theSIMDExtract.type = binaryen.f64;
  theSIMDExtract.finalize();
  assert(theSIMDExtract.type === binaryen.i32);
  
  info = binaryen.getExpressionInfo(theSIMDExtract);
  assert(info.type === theSIMDExtract.type);
  assert(info.op === theSIMDExtract.op);
  assert(info.vec === theSIMDExtract.vec);
  assert(info.index === theSIMDExtract.index);

  console.log(theSIMDExtract.toText());
  assert(
    theSIMDExtract.toText()
    ==
    "(i16x8.extract_lane_s 1\n (v128.const i32x4 0x01010101 0x01010101 0x01010101 0x01010101)\n)\n"
  );

  module.dispose();
})();

console.log("# SIMDReplace");
(function testSIMDReplace() {
  const module = new binaryen.Module();

  var op = binaryen.Operations.ReplaceLaneVecI8x16;
  var vec = module.v128.const([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]);
  var index = 0;
  var value = module.i32.const(1);
  const theSIMDReplace = binaryen.SIMDReplace(module.i8x16.replace_lane(vec, index, value));
  assert(theSIMDReplace instanceof binaryen.SIMDReplace);
  assert(theSIMDReplace instanceof binaryen.Expression);
  assert(theSIMDReplace.op === op);
  assert(theSIMDReplace.vec === vec);
  assert(theSIMDReplace.index === index);
  assert(theSIMDReplace.value === value);
  assert(theSIMDReplace.type === binaryen.v128);

  var info = binaryen.getExpressionInfo(theSIMDReplace);
  assert(info.id === theSIMDReplace.id);
  assert(info.type === theSIMDReplace.type);
  assert(info.op === theSIMDReplace.op);
  assert(info.vec === theSIMDReplace.vec);
  assert(info.index === theSIMDReplace.index);
  assert(info.value === theSIMDReplace.value);

  theSIMDReplace.op = op = binaryen.Operations.ReplaceLaneVecI16x8;
  assert(theSIMDReplace.op === op);
  theSIMDReplace.vec = vec = module.v128.const([1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]);
  assert(theSIMDReplace.vec === vec);
  theSIMDReplace.index = index = 1;
  assert(theSIMDReplace.index === index);
  theSIMDReplace.value = value = module.i32.const(2);
  assert(theSIMDReplace.value === value);
  theSIMDReplace.type = binaryen.f64;
  theSIMDReplace.finalize();
  assert(theSIMDReplace.type === binaryen.v128);

  info = binaryen.getExpressionInfo(theSIMDReplace);
  assert(info.type === theSIMDReplace.type);
  assert(info.op === theSIMDReplace.op);
  assert(info.vec === theSIMDReplace.vec);
  assert(info.index === theSIMDReplace.index);
  assert(info.value === theSIMDReplace.value);

  console.log(theSIMDReplace.toText());
  assert(
    theSIMDReplace.toText()
    ==
    "(i16x8.replace_lane 1\n (v128.const i32x4 0x01010101 0x01010101 0x01010101 0x01010101)\n (i32.const 2)\n)\n"
  );

  module.dispose();
})();

console.log("# SIMDShuffle");
(function testSIMDShuffle() {
  const module = new binaryen.Module();

  var left = module.v128.const([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]);
  var right = module.v128.const([2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]);
  var mask = [3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18];
  const theSIMDShuffle = binaryen.SIMDShuffle(module.i8x16.shuffle(left, right, mask));
  assert(theSIMDShuffle instanceof binaryen.SIMDShuffle);
  assert(theSIMDShuffle instanceof binaryen.Expression);
  assert(theSIMDShuffle.left === left);
  assert(theSIMDShuffle.right === right);
  assertDeepEqual(theSIMDShuffle.mask, mask);
  assert(theSIMDShuffle.type === binaryen.v128);

  var info = binaryen.getExpressionInfo(theSIMDShuffle);
  assert(info.id === theSIMDShuffle.id);
  assert(info.type === theSIMDShuffle.type);
  assert(info.left === theSIMDShuffle.left);
  assert(info.right === theSIMDShuffle.right);
  assertDeepEqual(info.mask, theSIMDShuffle.mask);

  theSIMDShuffle.left = left = module.v128.const([1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]);
  assert(theSIMDShuffle.left === left);
  theSIMDShuffle.right = right = module.v128.const([2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2]);
  assert(theSIMDShuffle.right === right);
  theSIMDShuffle.mask = mask = [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3];
  assertDeepEqual(theSIMDShuffle.mask, mask);
  theSIMDShuffle.type = binaryen.f64;
  theSIMDShuffle.finalize();
  assert(theSIMDShuffle.type === binaryen.v128);

  info = binaryen.getExpressionInfo(theSIMDShuffle);
  assert(info.type === theSIMDShuffle.type);
  assert(info.left === theSIMDShuffle.left);
  assert(info.right === theSIMDShuffle.right);
  assertDeepEqual(info.mask, theSIMDShuffle.mask);

  console.log(theSIMDShuffle.toText());
  assert(
    theSIMDShuffle.toText()
    ==
    "(i8x16.shuffle 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3\n (v128.const i32x4 0x01010101 0x01010101 0x01010101 0x01010101)\n (v128.const i32x4 0x02020202 0x02020202 0x02020202 0x02020202)\n)\n"
  );

  module.dispose();
})();

console.log("# SIMDTernary");
(function testSIMDTernary() {
  const module = new binaryen.Module();

  var op = binaryen.Operations.BitselectVec128;
  var a = module.v128.const([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]);
  var b = module.v128.const([2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17]);
  var c = module.v128.const([3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18]);
  const theSIMDTernary = binaryen.SIMDTernary(module.v128.bitselect(a, b, c));
  assert(theSIMDTernary instanceof binaryen.SIMDTernary);
  assert(theSIMDTernary instanceof binaryen.Expression);
  assert(theSIMDTernary.op === op);
  assert(theSIMDTernary.a === a);
  assert(theSIMDTernary.b === b);
  assert(theSIMDTernary.c === c);
  assert(theSIMDTernary.type === binaryen.v128);

  var info = binaryen.getExpressionInfo(theSIMDTernary);
  assert(info.id === theSIMDTernary.id);
  assert(info.type === theSIMDTernary.type);
  assert(info.op === theSIMDTernary.op);
  assert(info.a === theSIMDTernary.a);
  assert(info.b === theSIMDTernary.b);
  assert(info.c === theSIMDTernary.c);

  console.log(theSIMDTernary.toText() + "\n");
  assert(
    theSIMDTernary.toText()
    ==
    "(v128.bitselect\n (v128.const i32x4 0x04030201 0x08070605 0x0c0b0a09 0x100f0e0d)\n (v128.const i32x4 0x05040302 0x09080706 0x0d0c0b0a 0x11100f0e)\n (v128.const i32x4 0x06050403 0x0a090807 0x0e0d0c0b 0x1211100f)\n)\n"
  );

  module.dispose();
})();

console.log("# SIMDShift");
(function testSIMDShift() {
  const module = new binaryen.Module();

  var op = binaryen.Operations.BitselectVec128;
  var vec = module.v128.const([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]);
  var shift = module.i32.const(1);
  const theSIMDShift = binaryen.SIMDShift(module.i8x16.shl(vec, shift));
  assert(theSIMDShift instanceof binaryen.SIMDShift);
  assert(theSIMDShift instanceof binaryen.Expression);
  assert(theSIMDShift.op === op);
  assert(theSIMDShift.vec === vec);
  assert(theSIMDShift.shift === shift);
  assert(theSIMDShift.type === binaryen.v128);

  var info = binaryen.getExpressionInfo(theSIMDShift);
  assert(info.id === theSIMDShift.id);
  assert(info.type === theSIMDShift.type);
  assert(info.op === theSIMDShift.op);
  assert(info.vec === theSIMDShift.vec);
  assert(info.shift === theSIMDShift.shift);

  theSIMDShift.op = op = binaryen.Operations.ShrSVecI8x16;
  assert(theSIMDShift.op === op);
  theSIMDShift.vec = vec = module.v128.const([1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]);
  assert(theSIMDShift.vec === vec);
  theSIMDShift.shift = shift = module.i32.const(2);
  assert(theSIMDShift.shift === shift);
  theSIMDShift.type = binaryen.f64;
  theSIMDShift.finalize();
  assert(theSIMDShift.type === binaryen.v128);

  info = binaryen.getExpressionInfo(theSIMDShift);
  assert(info.type === theSIMDShift.type);
  assert(info.op === theSIMDShift.op);
  assert(info.vec === theSIMDShift.vec);
  assert(info.shift === theSIMDShift.shift);

  console.log(theSIMDShift.toText());
  assert(
    theSIMDShift.toText()
    ==
    "(i8x16.shr_s\n (v128.const i32x4 0x01010101 0x01010101 0x01010101 0x01010101)\n (i32.const 2)\n)\n"
  );

  module.dispose();
})();

console.log("# SIMDLoad");
(function testSIMDLoad() {
  const module = new binaryen.Module();
  module.setMemory(1, 1, null);

  var op = binaryen.Operations.Load8x8SVec128;
  var offset = 16;
  var align = 2;
  var ptr = module.i32.const(1);
  const theSIMDLoad = binaryen.SIMDLoad(module.v128.load8x8_s(offset, align, ptr));
  assert(theSIMDLoad instanceof binaryen.SIMDLoad);
  assert(theSIMDLoad instanceof binaryen.Expression);
  assert(theSIMDLoad.offset === offset);
  assert(theSIMDLoad.align === align);
  assert(theSIMDLoad.ptr === ptr);
  assert(theSIMDLoad.type === binaryen.v128);

  var info = binaryen.getExpressionInfo(theSIMDLoad);
  assert(info.id === theSIMDLoad.id);
  assert(info.type === theSIMDLoad.type);
  assert(info.offset === theSIMDLoad.offset);
  assert(info.align === theSIMDLoad.align);
  assert(info.ptr === theSIMDLoad.ptr);

  theSIMDLoad.op = op = binaryen.Operations.Load8SplatVec128;
  assert(theSIMDLoad.op === op);
  theSIMDLoad.offset = offset = 32;
  assert(theSIMDLoad.offset === offset);
  theSIMDLoad.align = align = 4;
  assert(theSIMDLoad.align === align);
  theSIMDLoad.ptr = ptr = module.i32.const(2);
  assert(theSIMDLoad.ptr === ptr);
  theSIMDLoad.type = binaryen.f64;
  theSIMDLoad.finalize();
  assert(theSIMDLoad.type === binaryen.v128);

  info = binaryen.getExpressionInfo(theSIMDLoad);
  assert(info.type === theSIMDLoad.type);
  assert(info.offset === theSIMDLoad.offset);
  assert(info.align === theSIMDLoad.align);
  assert(info.ptr === theSIMDLoad.ptr);

  console.log(theSIMDLoad.toText());
  assert(
    theSIMDLoad.toText()
    ==
    "(v128.load8_splat $0 offset=32 align=4\n (i32.const 2)\n)\n"
  );

  module.dispose();
})();

console.log("# SIMDLoadStoreLane");
(function testSIMDLoadStoreLane() {
  const module = new binaryen.Module();
  module.setMemory(1, 1, null);

  var op = binaryen.Operations.Load8LaneVec128;
  var offset = 16;
  var index = 1;
  var align = 1;
  var ptr = module.i32.const(1);
  var vec = module.v128.const([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]);
  const theSIMDLoadStoreLane = binaryen.SIMDLoadStoreLane(module.v128.load8_lane(offset, align, index, ptr, vec));
  assert(theSIMDLoadStoreLane instanceof binaryen.SIMDLoadStoreLane);
  assert(theSIMDLoadStoreLane instanceof binaryen.Expression);
  assert(theSIMDLoadStoreLane.op === op);
  assert(theSIMDLoadStoreLane.offset === offset);
  assert(theSIMDLoadStoreLane.align === align);
  assert(theSIMDLoadStoreLane.index === index);
  assert(theSIMDLoadStoreLane.ptr === ptr);
  assert(theSIMDLoadStoreLane.vec === vec);
  assert(theSIMDLoadStoreLane.type === binaryen.v128);
  assert(theSIMDLoadStoreLane.store === false);

  var info = binaryen.getExpressionInfo(theSIMDLoadStoreLane);
  assert(info.id === theSIMDLoadStoreLane.id);
  assert(info.type === theSIMDLoadStoreLane.type);
  assert(info.op === theSIMDLoadStoreLane.op);
  assert(info.offset === theSIMDLoadStoreLane.offset);
  assert(info.align === theSIMDLoadStoreLane.align);
  assert(info.index === theSIMDLoadStoreLane.index);
  assert(info.ptr === theSIMDLoadStoreLane.ptr);
  assert(info.vec === theSIMDLoadStoreLane.vec);
  assert(info.isStore === theSIMDLoadStoreLane.store);

  theSIMDLoadStoreLane.op = op = binaryen.Operations.Load16LaneVec128;
  assert(theSIMDLoadStoreLane.op === op);
  theSIMDLoadStoreLane.offset = offset = 32;
  assert(theSIMDLoadStoreLane.offset === offset);
  theSIMDLoadStoreLane.align = align = 2;
  assert(theSIMDLoadStoreLane.align === align);
  theSIMDLoadStoreLane.index = index = 2;
  assert(theSIMDLoadStoreLane.index === index);
  theSIMDLoadStoreLane.ptr = ptr = module.i32.const(2);
  assert(theSIMDLoadStoreLane.ptr === ptr);
  theSIMDLoadStoreLane.vec = vec = module.v128.const([1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]);
  assert(theSIMDLoadStoreLane.vec === vec);
  theSIMDLoadStoreLane.type = binaryen.f64;
  theSIMDLoadStoreLane.finalize();
  assert(theSIMDLoadStoreLane.type === binaryen.v128);

  info = binaryen.getExpressionInfo(theSIMDLoadStoreLane);
  assert(info.type === theSIMDLoadStoreLane.type);
  assert(info.op === theSIMDLoadStoreLane.op);
  assert(info.offset === theSIMDLoadStoreLane.offset);
  assert(info.align === theSIMDLoadStoreLane.align);
  assert(info.index === theSIMDLoadStoreLane.index);
  assert(info.ptr === theSIMDLoadStoreLane.ptr);
  assert(info.vec === theSIMDLoadStoreLane.vec);

  console.log(theSIMDLoadStoreLane.toText());
  assert(
    theSIMDLoadStoreLane.toText()
    ==
    "(v128.load16_lane $0 offset=32 2\n (i32.const 2)\n (v128.const i32x4 0x01010101 0x01010101 0x01010101 0x01010101)\n)\n"
  );

  theSIMDLoadStoreLane.op = op = binaryen.Operations.Store16LaneVec128;
  assert(theSIMDLoadStoreLane.op === op);
  theSIMDLoadStoreLane.type = binaryen.f64;
  assert(theSIMDLoadStoreLane.store === true);
  theSIMDLoadStoreLane.finalize();
  assert(theSIMDLoadStoreLane.type === binaryen.none);

  info = binaryen.getExpressionInfo(theSIMDLoadStoreLane);
  assert(info.type === theSIMDLoadStoreLane.type);
  assert(info.op === theSIMDLoadStoreLane.op);
  assert(info.isStore === theSIMDLoadStoreLane.store);

  console.log(theSIMDLoadStoreLane.toText());
  assert(
    theSIMDLoadStoreLane.toText()
    ==
    "(v128.store16_lane $0 offset=32 2\n (i32.const 2)\n (v128.const i32x4 0x01010101 0x01010101 0x01010101 0x01010101)\n)\n"
  );

  module.dispose();
})();

console.log("# MemoryInit");
(function testMemoryInit() {
  const module = new binaryen.Module();
  module.setMemory(1, 1, null);

  var segment = "1";
  var dest = module.i32.const(2);
  var offset = module.i32.const(3);
  var size = module.i32.const(4);
  const theMemoryInit = binaryen.MemoryInit(module.memory.init(segment, dest, offset, size));
  assert(theMemoryInit instanceof binaryen.MemoryInit);
  assert(theMemoryInit instanceof binaryen.Expression);
  assert(theMemoryInit.segment === segment);
  assert(theMemoryInit.dest === dest);
  assert(theMemoryInit.offset === offset);
  assert(theMemoryInit.size === size);
  assert(theMemoryInit.type === binaryen.none);

  var info = binaryen.getExpressionInfo(theMemoryInit);
  assert(info.id === theMemoryInit.id);
  assert(info.type === theMemoryInit.type);
  assert(info.segment === theMemoryInit.segment);
  assert(info.dest === theMemoryInit.dest);
  assert(info.offset === theMemoryInit.offset);
  assert(info.size === theMemoryInit.size);

  theMemoryInit.segment = segment = "5";
  assert(theMemoryInit.segment === "5");
  theMemoryInit.dest = dest = module.i32.const(6);
  assert(theMemoryInit.dest === dest);
  theMemoryInit.offset = offset = module.i32.const(7);
  assert(theMemoryInit.offset === offset);
  theMemoryInit.size = size = module.i32.const(8);
  assert(theMemoryInit.size === size);
  theMemoryInit.type = binaryen.f64;
  theMemoryInit.finalize();
  assert(theMemoryInit.type === binaryen.none);

  info = binaryen.getExpressionInfo(theMemoryInit);
  assert(info.type === theMemoryInit.type);
  assert(info.segment === theMemoryInit.segment);
  assert(info.dest === theMemoryInit.dest);
  assert(info.offset === theMemoryInit.offset);
  assert(info.size === theMemoryInit.size);

  console.log(theMemoryInit.toText());
  assert(
    theMemoryInit.toText()
    ==
    "(memory.init $0 $5\n (i32.const 6)\n (i32.const 7)\n (i32.const 8)\n)\n"
  );

  module.dispose();
})();

console.log("# DataDrop");
(function testDataDrop() {
  const module = new binaryen.Module();

  var segment = "1";
  const theDataDrop = binaryen.DataDrop(module.data.drop(segment));
  assert(theDataDrop instanceof binaryen.DataDrop);
  assert(theDataDrop instanceof binaryen.Expression);
  assert(theDataDrop.segment === segment);
  assert(theDataDrop.type === binaryen.none);

  var info = binaryen.getExpressionInfo(theDataDrop);
  assert(info.id === theDataDrop.id);
  assert(info.type === theDataDrop.type);
  assert(info.segment === theDataDrop.segment);

  theDataDrop.segment = segment = "2";
  assert(theDataDrop.segment === "2");
  theDataDrop.type = binaryen.f64;
  theDataDrop.finalize();
  assert(theDataDrop.type === binaryen.none);

  info = binaryen.getExpressionInfo(theDataDrop);
  assert(info.type === theDataDrop.type);
  assert(info.segment === theDataDrop.segment);

  console.log(theDataDrop.toText());
  assert(
    theDataDrop.toText()
    ==
    "(data.drop $2)\n"
  );

  module.dispose();
})();

console.log("# MemoryCopy");
(function testMemoryCopy() {
  const module = new binaryen.Module();
  module.setMemory(1, 1, null);

  var dest = module.i32.const(1);
  var source = module.i32.const(2);
  var size = module.i32.const(3);
  const theMemoryCopy = binaryen.MemoryCopy(module.memory.copy(dest, source, size));
  assert(theMemoryCopy instanceof binaryen.MemoryCopy);
  assert(theMemoryCopy instanceof binaryen.Expression);
  assert(theMemoryCopy.dest === dest);
  assert(theMemoryCopy.source === source);
  assert(theMemoryCopy.size === size);
  assert(theMemoryCopy.type === binaryen.none);

  var info = binaryen.getExpressionInfo(theMemoryCopy);
  assert(info.id === theMemoryCopy.id);
  assert(info.type === theMemoryCopy.type);
  assert(info.dest === theMemoryCopy.dest);
  assert(info.source === theMemoryCopy.source);
  assert(info.size === theMemoryCopy.size);

  theMemoryCopy.dest = dest = module.i32.const(4);
  assert(theMemoryCopy.dest === dest);
  theMemoryCopy.source = source = module.i32.const(5);
  assert(theMemoryCopy.source === source);
  theMemoryCopy.size = size = module.i32.const(6);
  assert(theMemoryCopy.size === size);
  theMemoryCopy.type = binaryen.f64;
  theMemoryCopy.finalize();
  assert(theMemoryCopy.type === binaryen.none);

  info = binaryen.getExpressionInfo(theMemoryCopy);
  assert(info.type === theMemoryCopy.type);
  assert(info.dest === theMemoryCopy.dest);
  assert(info.source === theMemoryCopy.source);
  assert(info.size === theMemoryCopy.size);

  console.log(theMemoryCopy.toText());
  assert(
    theMemoryCopy.toText()
    ==
    "(memory.copy $0 $0\n (i32.const 4)\n (i32.const 5)\n (i32.const 6)\n)\n"
  );

  module.dispose();
})();

console.log("# MemoryFill");
(function testMemoryFill() {
  const module = new binaryen.Module();
  module.setMemory(1, 1, null);

  var dest = module.i32.const(1);
  var value = module.i32.const(2);
  var size = module.i32.const(3);
  const theMemoryFill = binaryen.MemoryFill(module.memory.fill(dest, value, size));
  assert(theMemoryFill instanceof binaryen.MemoryFill);
  assert(theMemoryFill instanceof binaryen.Expression);
  assert(theMemoryFill.dest === dest);
  assert(theMemoryFill.value === value);
  assert(theMemoryFill.size === size);
  assert(theMemoryFill.type === binaryen.none);

  var info = binaryen.getExpressionInfo(theMemoryFill);
  assert(info.id === theMemoryFill.id);
  assert(info.type === theMemoryFill.type);
  assert(info.dest === theMemoryFill.dest);
  assert(info.value === theMemoryFill.value);
  assert(info.size === theMemoryFill.size);

  theMemoryFill.dest = dest = module.i32.const(4);
  assert(theMemoryFill.dest === dest);
  theMemoryFill.value = value = module.i32.const(5);
  assert(theMemoryFill.value === value);
  theMemoryFill.size = size = module.i32.const(6);
  assert(theMemoryFill.size === size);
  theMemoryFill.type = binaryen.f64;
  theMemoryFill.finalize();
  assert(theMemoryFill.type === binaryen.none);

  info = binaryen.getExpressionInfo(theMemoryFill);
  assert(info.type === theMemoryFill.type);
  assert(info.dest === theMemoryFill.dest);
  assert(info.value === theMemoryFill.value);
  assert(info.size === theMemoryFill.size);

  console.log(theMemoryFill.toText());
  assert(
    theMemoryFill.toText()
    ==
    "(memory.fill $0\n (i32.const 4)\n (i32.const 5)\n (i32.const 6)\n)\n"
  );

  module.dispose();
})();

console.log("# RefIsNull");
(function testRefIsNull() {
  const module = new binaryen.Module();

  var value = module.local.get(1, binaryen.externref);
  const theRefIsNull = binaryen.RefIsNull(module.ref.is_null(value));
  assert(theRefIsNull instanceof binaryen.RefIsNull);
  assert(theRefIsNull instanceof binaryen.Expression);
  assert(theRefIsNull.value === value);
  assert(theRefIsNull.type === binaryen.i32);

  var info = binaryen.getExpressionInfo(theRefIsNull);
  assert(info.id === theRefIsNull.id);
  assert(info.type === theRefIsNull.type);
  assert(info.value === theRefIsNull.value);

  theRefIsNull.value = value = module.local.get(2, binaryen.externref);
  assert(theRefIsNull.value === value);
  theRefIsNull.type = binaryen.f64;
  theRefIsNull.finalize();
  assert(theRefIsNull.type === binaryen.i32);

  info = binaryen.getExpressionInfo(theRefIsNull);
  assert(info.type === theRefIsNull.type);
  assert(info.value === theRefIsNull.value);

  console.log(theRefIsNull.toText());
  assert(
    theRefIsNull.toText()
    ==
    "(ref.is_null\n (local.get $2)\n)\n"
  );

  module.dispose();
})();

console.log("# RefAs");
(function testRefAs() {
  const module = new binaryen.Module();

  var op = binaryen.Operations.RefAsNonNull;
  var value = module.local.get(1, binaryen.anyref);
  var externref = module.local.get(3, binaryen.externref);
  const theRefAs = binaryen.RefAs(module.ref.as_non_null(value));
  assert(theRefAs instanceof binaryen.RefAs);
  assert(theRefAs instanceof binaryen.Expression);
  assert(theRefAs.op === op);
  assert(theRefAs.value === value);
  assert(theRefAs.type !== binaryen.i32); // TODO: === (ref any)

  var info = binaryen.getExpressionInfo(theRefAs);
  assert(info.id === theRefAs.id);
  assert(info.type === theRefAs.type);
  assert(info.op === theRefAs.op);
  assert(info.value === theRefAs.value);

  theRefAs.op = op = binaryen.Operations.RefAsExternConvertAny;
  assert(theRefAs.op === op);
  theRefAs.op = op = binaryen.Operations.RefAsNonNull;
  theRefAs.value = value = module.local.get(2, binaryen.anyref);
  assert(theRefAs.value === value);
  theRefAs.type = binaryen.f64;
  theRefAs.finalize();
  assert(theRefAs.type !== binaryen.f64); // TODO: === (ref any)

  info = binaryen.getExpressionInfo(theRefAs);
  assert(info.type === theRefAs.type);
  assert(info.op === theRefAs.op);
  assert(info.value === theRefAs.value);

  console.log(theRefAs.toText());
  assert(
    theRefAs.toText()
    ==
    "(ref.as_non_null\n (local.get $2)\n)\n"
  );

  // TODO: extern.convert_any and any.convert_extern

  module.dispose();
})();

console.log("# RefFunc");
(function testRefFunc() {
  const module = new binaryen.Module();
  module.addFunction("a", binaryen.none, binaryen.none, [], module.nop());
  var type = binaryen.Function(module.getFunction("a")).type;

  var func = "a";
  const theRefFunc = binaryen.RefFunc(module.ref.func(func, type));
  assert(theRefFunc instanceof binaryen.RefFunc);
  assert(theRefFunc instanceof binaryen.Expression);
  assert(theRefFunc.func === func);
  assert(theRefFunc.type === type);

  var info = binaryen.getExpressionInfo(theRefFunc);
  assert(info.id === theRefFunc.id);
  assert(info.type === theRefFunc.type);
  assert(info.func === theRefFunc.func);

  theRefFunc.func = func = "b";
  assert(theRefFunc.func === func);
  theRefFunc.finalize();
  assert(theRefFunc.type === type);

  info = binaryen.getExpressionInfo(theRefFunc);
  assert(info.type === theRefFunc.type);
  assert(info.func === theRefFunc.func);

  console.log(theRefFunc.toText());
  assert(
    theRefFunc.toText()
    ==
    "(ref.func $b)\n"
  );

  module.dispose();
})();

console.log("# RefEq");
(function testRefEq() {
  const module = new binaryen.Module();

  var left = module.local.get(0, binaryen.eqref);
  var right = module.local.get(1, binaryen.eqref);
  const theRefEq = binaryen.RefEq(module.ref.eq(left, right));
  assert(theRefEq instanceof binaryen.RefEq);
  assert(theRefEq instanceof binaryen.Expression);
  assert(theRefEq.left === left);
  assert(theRefEq.right === right);
  assert(theRefEq.type === binaryen.i32);

  var info = binaryen.getExpressionInfo(theRefEq);
  assert(info.id === theRefEq.id);
  assert(info.type === theRefEq.type);
  assert(info.left === theRefEq.left);
  assert(info.right === theRefEq.right);

  theRefEq.left = left = module.local.get(2, binaryen.eqref);
  assert(theRefEq.left === left);
  theRefEq.right = right = module.local.get(3, binaryen.eqref);
  assert(theRefEq.right === right);
  theRefEq.type = binaryen.f64;
  theRefEq.finalize();
  assert(theRefEq.type === binaryen.i32);

  info = binaryen.getExpressionInfo(theRefEq);
  assert(info.type === theRefEq.type);
  assert(info.left === theRefEq.left);
  assert(info.right === theRefEq.right);

  console.log(theRefEq.toText());
  assert(
    theRefEq.toText()
    ==
    "(ref.eq\n (local.get $2)\n (local.get $3)\n)\n"
  );

  module.dispose();
})();

console.log("# RefTest");
(function testRefTest() {
  const module = new binaryen.Module();

  var ref = module.local.get(0, binaryen.anyref);
  var castType = binaryen.anyref;
  const theRefTest = binaryen.RefTest(module.ref.test(ref, castType));
  assert(theRefTest instanceof binaryen.RefTest);
  assert(theRefTest instanceof binaryen.Expression);
  assert(theRefTest.ref === ref);
  assert(theRefTest.castType === castType);
  assert(theRefTest.type === binaryen.i32);

  var info = binaryen.getExpressionInfo(theRefTest);
  assert(info.id === theRefTest.id);
  assert(info.type === theRefTest.type);
  assert(info.ref === theRefTest.ref);
  assert(info.castType === theRefTest.castType);

  theRefTest.ref = ref = module.local.get(2, binaryen.externref);
  assert(theRefTest.ref === ref);
  theRefTest.castType = castType = binaryen.externref;
  assert(theRefTest.castType === castType);
  theRefTest.type = binaryen.f64;
  theRefTest.finalize();
  assert(theRefTest.type === binaryen.i32);

  info = binaryen.getExpressionInfo(theRefTest);
  assert(info.type === theRefTest.type);
  assert(info.ref === theRefTest.ref);
  assert(info.castType === theRefTest.castType);

  console.log(theRefTest.toText());
  assert(
    theRefTest.toText()
    ==
    "(ref.test externref\n (local.get $2)\n)\n"
  );

  module.dispose();
})();

console.log("# RefCast");
(function testRefCast() {
  const module = new binaryen.Module();

  var ref = module.local.get(0, binaryen.anyref);
  var type = binaryen.anyref;
  const theRefCast = binaryen.RefCast(module.ref.cast(ref, type));
  assert(theRefCast instanceof binaryen.RefCast);
  assert(theRefCast instanceof binaryen.Expression);
  assert(theRefCast.ref === ref);
  assert(theRefCast.type === type);

  var info = binaryen.getExpressionInfo(theRefCast);
  assert(info.id === theRefCast.id);
  assert(info.type === theRefCast.type);
  assert(info.ref === theRefCast.ref);

  theRefCast.ref = ref = module.local.get(2, binaryen.externref);
  assert(theRefCast.ref === ref);
  theRefCast.type = type = binaryen.externref;
  theRefCast.finalize();
  assert(theRefCast.type === type);

  info = binaryen.getExpressionInfo(theRefCast);
  assert(info.type === theRefCast.type);
  assert(info.ref === theRefCast.ref);

  console.log(theRefCast.toText());
  assert(
    theRefCast.toText()
    ==
    "(ref.cast externref\n (local.get $2)\n)\n"
  );

  module.dispose();
})();

console.log("# BrOn");
(function testBrOn() {
  const module = new binaryen.Module();

  var name = "br";
  var ref = module.local.get(0, binaryen.externref);
  var op = binaryen.Operations.BrOnNull;
  var castType = binaryen.unreachable;
  const theBrOn = binaryen.BrOn(module.br_on_null(name, ref));
  assert(theBrOn instanceof binaryen.BrOn);
  assert(theBrOn instanceof binaryen.Expression);
  assert(theBrOn.name === name);
  assert(theBrOn.ref === ref);
  assert(theBrOn.op === op);
  assert(theBrOn.castType === castType);

  // TODO: What should theBrOn.type be equal to?

  var info = binaryen.getExpressionInfo(theBrOn);
  assert(info.id === theBrOn.id);
  assert(info.type === theBrOn.type);
  assert(info.name === theBrOn.name);
  assert(info.ref === theBrOn.ref);
  assert(info.op === theBrOn.op);
  assert(info.castType === theBrOn.castType);

  theBrOn.name = name = "br2";
  assert(theBrOn.name === name);
  theBrOn.ref = ref = module.local.get(1, binaryen.anyref);
  assert(theBrOn.ref === ref);
  theBrOn.op = op = binaryen.Operations.BrOnCast;
  assert(theBrOn.op === op);
  theBrOn.castType = castType = binaryen.i31ref;
  assert(theBrOn.castType === castType);
  theBrOn.finalize();

  info = binaryen.getExpressionInfo(theBrOn);
  assert(info.name === theBrOn.name);
  assert(info.ref === theBrOn.ref);
  assert(info.op === theBrOn.op);
  assert(info.castType === theBrOn.castType);

  console.log(theBrOn.toText());
  assert(
    theBrOn.toText()
    ==
    "(br_on_cast $br2 anyref i31ref\n (local.get $1)\n)\n"
  );

  module.dispose();
})();

console.log("# StructNew");
(function testStructNew() {
  const builder = new binaryen.TypeBuilder(2);
  builder.setStructType(0, [
    { type: binaryen.i32, packedType: binaryen.notPacked, mutable: true },
  ]);
  builder.setStructType(1, [
    { type: binaryen.i32, packedType: binaryen.i16, mutable: true },
    { type: binaryen.i64, packedType: binaryen.notPacked, mutable: true }
  ]);
  var [
    struct0Type,
    struct1Type
  ] = builder.buildAndDispose();

  const module = new binaryen.Module();

  var operands = [
    module.i32.const(1),
    module.i32.const(2)
  ];
  var type = struct0Type;
  const theStructNew = binaryen.StructNew(module.struct.new(operands, type));
  assert(theStructNew instanceof binaryen.StructNew);
  assert(theStructNew instanceof binaryen.Expression);
  assertDeepEqual(theStructNew.operands, operands);
  assertDeepEqual(theStructNew.getOperands(), operands);
  assert(theStructNew.type === type);

  var info = binaryen.getExpressionInfo(theStructNew);
  assert(info.id === theStructNew.id);
  assert(info.type === theStructNew.type);
  assertDeepEqual(info.operands, theStructNew.operands);

  theStructNew.operands = operands = [
    module.i32.const(3), // set
    module.i32.const(4), // set
    module.i32.const(5)  // append
  ];
  assertDeepEqual(theStructNew.operands, operands);
  operands = [
    module.i32.const(6) // set
    // remove
    // remove
  ];
  theStructNew.setOperands(operands);
  assertDeepEqual(theStructNew.operands, operands);
  theStructNew.insertOperandAt(0, module.i32.const(7));
  theStructNew.type = type = struct1Type;
  theStructNew.finalize();
  assert(theStructNew.type === type);

  info = binaryen.getExpressionInfo(theStructNew);
  assert(info.type === theStructNew.type);
  assertDeepEqual(info.operands, theStructNew.operands);

  console.log(theStructNew.toText());
  assert(
    theStructNew.toText()
    ==
    "(struct.new $struct.0\n (i32.const 7)\n (i32.const 6)\n)\n"
  );

  module.dispose();
})();

console.log("# StructGet");
(function testStructGet() {
  const builder = new binaryen.TypeBuilder(2);
  builder.setStructType(0, [
    { type: binaryen.i32, packedType: binaryen.notPacked, mutable: true },
  ]);
  builder.setStructType(1, [
    { type: binaryen.i32, packedType: binaryen.i16, mutable: true },
    { type: binaryen.i64, packedType: binaryen.notPacked, mutable: true }
  ]);
  var [
    struct0Type,
    struct1Type
  ] = builder.buildAndDispose();

  const module = new binaryen.Module();

  var index = 0;
  var ref = module.local.get(0, struct0Type);
  var type = binaryen.i32;
  var signed = false;
  const theStructGet = binaryen.StructGet(module.struct.get(index, ref, type, signed));
  assert(theStructGet instanceof binaryen.StructGet);
  assert(theStructGet instanceof binaryen.Expression);
  assert(theStructGet.index === index);
  assert(theStructGet.ref === ref);
  assert(theStructGet.signed === signed);
  assert(theStructGet.type === type);

  var info = binaryen.getExpressionInfo(theStructGet);
  assert(info.id === theStructGet.id);
  assert(info.type === theStructGet.type);
  assert(info.index === theStructGet.index);
  assert(info.ref === theStructGet.ref);
  assert(info.isSigned === theStructGet.signed);

  theStructGet.index = index = 1;
  assert(theStructGet.index === index);
  theStructGet.ref = ref = module.local.get(1, struct1Type);
  assert(theStructGet.ref === ref);
  theStructGet.signed = signed = true;
  assert(theStructGet.signed === signed);
  theStructGet.type = type = binaryen.i64;
  theStructGet.finalize();
  assert(theStructGet.type === type);

  info = binaryen.getExpressionInfo(theStructGet);
  assert(info.type === theStructGet.type);
  assert(info.index === theStructGet.index);
  assert(info.ref === theStructGet.ref);
  assert(info.isSigned === theStructGet.signed);

  console.log(theStructGet.toText());
  assert(
    theStructGet.toText()
    ==
    "(struct.get $struct.0 1\n (local.get $1)\n)\n"
  );

  module.dispose();
})();

console.log("# StructSet");
(function testStructSet() {
  const builder = new binaryen.TypeBuilder(2);
  builder.setStructType(0, [
    { type: binaryen.i32, packedType: binaryen.notPacked, mutable: true },
  ]);
  builder.setStructType(1, [
    { type: binaryen.i32, packedType: binaryen.i16, mutable: true },
    { type: binaryen.i64, packedType: binaryen.notPacked, mutable: true }
  ]);
  var [
    struct0Type,
    struct1Type
  ] = builder.buildAndDispose();

  const module = new binaryen.Module();

  var index = 0;
  var ref = module.local.get(0, struct0Type);
  var value = module.local.get(1, binaryen.i32);
  const theStructSet = binaryen.StructSet(module.struct.set(index, ref, value));
  assert(theStructSet instanceof binaryen.StructSet);
  assert(theStructSet instanceof binaryen.Expression);
  assert(theStructSet.index === index);
  assert(theStructSet.ref === ref);
  assert(theStructSet.value === value);
  assert(theStructSet.type === binaryen.none);

  var info = binaryen.getExpressionInfo(theStructSet);
  assert(info.id === theStructSet.id);
  assert(info.type === theStructSet.type);
  assert(info.index === theStructSet.index);
  assert(info.ref === theStructSet.ref);
  assert(info.value === theStructSet.value);

  theStructSet.index = index = 1;
  assert(theStructSet.index === index);
  theStructSet.ref = ref = module.local.get(2, struct1Type);
  assert(theStructSet.ref === ref);
  theStructSet.value = value = module.local.get(3, binaryen.i64);
  assert(theStructSet.value === value);
  theStructSet.type = binaryen.f64;
  theStructSet.finalize();
  assert(theStructSet.type === binaryen.none);

  info = binaryen.getExpressionInfo(theStructSet);
  assert(info.type === theStructSet.type);
  assert(info.index === theStructSet.index);
  assert(info.ref === theStructSet.ref);
  assert(info.value === theStructSet.value);

  console.log(theStructSet.toText());
  assert(
    theStructSet.toText()
    ==
    "(struct.set $struct.0 1\n (local.get $2)\n (local.get $3)\n)\n"
  );

  module.dispose();
})();

console.log("# ArrayNew");
(function testArrayNew() {
  const builder = new binaryen.TypeBuilder(2);
  builder.setArrayType(0, binaryen.i32, binaryen.i16, true);
  builder.setArrayType(1, binaryen.i32, binaryen.notPacked, true);
  var [
    array0Type,
    array1Type
  ] = builder.buildAndDispose();

  const module = new binaryen.Module();

  var type = array0Type;
  var size = module.i32.const(2);
  var init = module.i32.const(1);
  const theArrayNew = binaryen.ArrayNew(module.array.new(type, size, init));
  assert(theArrayNew instanceof binaryen.ArrayNew);
  assert(theArrayNew instanceof binaryen.Expression);
  assert(theArrayNew.size === size);
  assert(theArrayNew.init === init);
  assert(theArrayNew.type === type);

  var info = binaryen.getExpressionInfo(theArrayNew);
  assert(info.id === theArrayNew.id);
  assert(info.type === theArrayNew.type);
  assert(info.size === theArrayNew.size);
  assert(info.init === theArrayNew.init);

  theArrayNew.size = size = module.i32.const(4);
  assert(theArrayNew.size === size);
  theArrayNew.init = init = module.i32.const(3);
  assert(theArrayNew.init === init);
  theArrayNew.type = type = array1Type;
  theArrayNew.finalize();
  assert(theArrayNew.type === type);

  info = binaryen.getExpressionInfo(theArrayNew);
  assert(info.type === theArrayNew.type);
  assert(info.size === theArrayNew.size);
  assert(info.init === theArrayNew.init);

  console.log(theArrayNew.toText());
  assert(
    theArrayNew.toText()
    ==
    "(array.new $array.0\n (i32.const 3)\n (i32.const 4)\n)\n"
  );

  module.dispose();
})();

console.log("# ArrayNewFixed");
(function testArrayNewFixed() {
  const builder = new binaryen.TypeBuilder(2);
  builder.setArrayType(0, binaryen.i32, binaryen.i16, true);
  builder.setArrayType(1, binaryen.i32, binaryen.notPacked, true);
  var [
    array0Type,
    array1Type
  ] = builder.buildAndDispose();

  const module = new binaryen.Module();

  var type = array0Type;
  var values = [
    module.i32.const(1),
    module.i32.const(2)
  ];
  const theArrayNewFixed = binaryen.ArrayNewFixed(module.array.new_fixed(type, values));
  assert(theArrayNewFixed instanceof binaryen.ArrayNewFixed);
  assert(theArrayNewFixed instanceof binaryen.Expression);
  assertDeepEqual(theArrayNewFixed.values, values);
  assertDeepEqual(theArrayNewFixed.getValues(), values);
  assert(theArrayNewFixed.type === type);

  var info = binaryen.getExpressionInfo(theArrayNewFixed);
  assert(info.id === theArrayNewFixed.id);
  assert(info.type === theArrayNewFixed.type);
  assertDeepEqual(info.values, theArrayNewFixed.values);

  theArrayNewFixed.values = values = [
    module.i32.const(3), // set
    module.i32.const(4), // set
    module.i32.const(5)  // append
  ];
  assertDeepEqual(theArrayNewFixed.values, values);
  values = [
    module.i32.const(6) // set
    // remove
    // remove
  ];
  theArrayNewFixed.setValues(values);
  assertDeepEqual(theArrayNewFixed.values, values);
  theArrayNewFixed.insertValueAt(0, module.i32.const(7));
  theArrayNewFixed.type = type = array1Type;
  theArrayNewFixed.finalize();
  assert(theArrayNewFixed.type === type);

  info = binaryen.getExpressionInfo(theArrayNewFixed);
  assert(info.type === theArrayNewFixed.type);
  assertDeepEqual(info.values, theArrayNewFixed.values);

  console.log(theArrayNewFixed.toText());
  assert(
    theArrayNewFixed.toText()
    ==
    "(array.new_fixed $array.0 2\n (i32.const 7)\n (i32.const 6)\n)\n"
  );

  module.dispose();
})();

console.log("# ArrayNewData");
(function testArrayNewData() {
  const builder = new binaryen.TypeBuilder(2);
  builder.setArrayType(0, binaryen.i32, binaryen.i16, true);
  builder.setArrayType(1, binaryen.i32, binaryen.notPacked, true);
  var [
    array0Type,
    array1Type
  ] = builder.buildAndDispose();

  const module = new binaryen.Module();

  var type = array0Type;
  var segment = "0";
  var offset = module.i32.const(1);
  var size = module.i32.const(2);
  const theArrayNewData = binaryen.ArrayNewData(module.array.new_data(type, segment, offset, size));
  assert(theArrayNewData instanceof binaryen.ArrayNewData);
  assert(theArrayNewData instanceof binaryen.Expression);
  assert(theArrayNewData.segment === segment);
  assert(theArrayNewData.offset === offset);
  assert(theArrayNewData.size === size);
  assert(theArrayNewData.type === type);

  var info = binaryen.getExpressionInfo(theArrayNewData);
  assert(info.id === theArrayNewData.id);
  assert(info.type === theArrayNewData.type);
  assert(info.segment === theArrayNewData.segment);
  assert(info.offset === theArrayNewData.offset);
  assert(info.size === theArrayNewData.size);

  theArrayNewData.segment = segment = "3";
  assert(theArrayNewData.segment === segment);
  theArrayNewData.offset = offset = module.i32.const(4);
  assert(theArrayNewData.offset === offset);
  theArrayNewData.size = size = module.i32.const(5);
  assert(theArrayNewData.size === size);
  theArrayNewData.type = type = array1Type;
  theArrayNewData.finalize();
  assert(theArrayNewData.type === type);

  info = binaryen.getExpressionInfo(theArrayNewData);
  assert(info.type === theArrayNewData.type);
  assert(info.segment === theArrayNewData.segment);
  assert(info.offset === theArrayNewData.offset);
  assert(info.size === theArrayNewData.size);

  console.log(theArrayNewData.toText());
  assert(
    theArrayNewData.toText()
    ==
    "(array.new_data $array.0 $3\n (i32.const 4)\n (i32.const 5)\n)\n"
  );

  module.dispose();
})();

console.log("# ArrayNewElem");
(function testArrayNewElem() {
  const builder = new binaryen.TypeBuilder(2);
  builder.setArrayType(0, binaryen.i32, binaryen.i16, true);
  builder.setArrayType(1, binaryen.i32, binaryen.notPacked, true);
  var [
    array0Type,
    array1Type
  ] = builder.buildAndDispose();

  const module = new binaryen.Module();

  var type = array0Type;
  var segment = "0";
  var offset = module.i32.const(1);
  var size = module.i32.const(2);
  const theArrayNewElem = binaryen.ArrayNewElem(module.array.new_elem(type, segment, offset, size));
  assert(theArrayNewElem instanceof binaryen.ArrayNewElem);
  assert(theArrayNewElem instanceof binaryen.Expression);
  assert(theArrayNewElem.segment === segment);
  assert(theArrayNewElem.offset === offset);
  assert(theArrayNewElem.size === size);
  assert(theArrayNewElem.type === type);

  var info = binaryen.getExpressionInfo(theArrayNewElem);
  assert(info.id === theArrayNewElem.id);
  assert(info.type === theArrayNewElem.type);
  assert(info.segment === theArrayNewElem.segment);
  assert(info.offset === theArrayNewElem.offset);
  assert(info.size === theArrayNewElem.size);

  theArrayNewElem.segment = segment = "3";
  assert(theArrayNewElem.segment === segment);
  theArrayNewElem.offset = offset = module.i32.const(4);
  assert(theArrayNewElem.offset === offset);
  theArrayNewElem.size = size = module.i32.const(5);
  assert(theArrayNewElem.size === size);
  theArrayNewElem.type = type = array1Type;
  theArrayNewElem.finalize();
  assert(theArrayNewElem.type === type);

  info = binaryen.getExpressionInfo(theArrayNewElem);
  assert(info.id === theArrayNewElem.id);
  assert(info.type === theArrayNewElem.type);
  assert(info.segment === theArrayNewElem.segment);
  assert(info.offset === theArrayNewElem.offset);
  assert(info.size === theArrayNewElem.size);

  console.log(theArrayNewElem.toText());
  assert(
    theArrayNewElem.toText()
    ==
    "(array.new_elem $array.0 $3\n (i32.const 4)\n (i32.const 5)\n)\n"
  );

  module.dispose();
})();

console.log("# ArrayGet");
(function testArrayGet() {
  const builder = new binaryen.TypeBuilder(2);
  builder.setArrayType(0, binaryen.i32, binaryen.i16, true);
  builder.setArrayType(1, binaryen.i64, binaryen.notPacked, true);
  var [
    array0Type,
    array1Type
  ] = builder.buildAndDispose();

  const module = new binaryen.Module();

  var ref = module.local.get(0, array0Type);
  var index = module.i32.const(0);
  var type = binaryen.i32;
  var signed = false;
  const theArrayGet = binaryen.ArrayGet(module.array.get(ref, index, type, signed));
  assert(theArrayGet instanceof binaryen.ArrayGet);
  assert(theArrayGet instanceof binaryen.Expression);
  assert(theArrayGet.ref === ref);
  assert(theArrayGet.index === index);
  assert(theArrayGet.signed === signed);
  assert(theArrayGet.type === type);

  var info = binaryen.getExpressionInfo(theArrayGet);
  assert(info.id === theArrayGet.id);
  assert(info.type === theArrayGet.type);
  assert(info.ref === theArrayGet.ref);
  assert(info.index === theArrayGet.index);
  assert(info.isSigned === theArrayGet.signed);

  theArrayGet.ref = ref = module.local.get(1, array1Type);
  assert(theArrayGet.ref === ref);
  theArrayGet.index = index = module.i32.const(1);
  assert(theArrayGet.index === index);
  theArrayGet.signed = signed = true;
  assert(theArrayGet.signed === signed);
  theArrayGet.type = type = binaryen.i64;
  theArrayGet.finalize();
  assert(theArrayGet.type === type);

  info = binaryen.getExpressionInfo(theArrayGet);
  assert(info.type === theArrayGet.type);
  assert(info.ref === theArrayGet.ref);
  assert(info.index === theArrayGet.index);
  assert(info.isSigned === theArrayGet.signed);

  console.log(theArrayGet.toText());
  assert(
    theArrayGet.toText()
    ==
    "(array.get $array.0\n (local.get $1)\n (i32.const 1)\n)\n"
  );

  module.dispose();
})();

console.log("# ArraySet");
(function testArraySet() {
  const builder = new binaryen.TypeBuilder(2);
  builder.setArrayType(0, binaryen.i32, binaryen.i16, true);
  builder.setArrayType(1, binaryen.i64, binaryen.notPacked, true);
  var [
    array0Type,
    array1Type
  ] = builder.buildAndDispose();

  const module = new binaryen.Module();

  var ref = module.local.get(0, array0Type);
  var index = module.i32.const(0);
  var value = module.local.get(1, binaryen.i32);
  const theArraySet = binaryen.ArraySet(module.array.set(ref, index, value));
  assert(theArraySet instanceof binaryen.ArraySet);
  assert(theArraySet instanceof binaryen.Expression);
  assert(theArraySet.ref === ref);
  assert(theArraySet.index === index);
  assert(theArraySet.value === value);
  assert(theArraySet.type === binaryen.none);

  var info = binaryen.getExpressionInfo(theArraySet);
  assert(info.id === theArraySet.id);
  assert(info.type === theArraySet.type);
  assert(info.ref === theArraySet.ref);
  assert(info.index === theArraySet.index);
  assert(info.value === theArraySet.value);

  theArraySet.ref = ref = module.local.get(2, array1Type);
  assert(theArraySet.ref === ref);
  theArraySet.index = index = module.i32.const(1);
  assert(theArraySet.index === index);
  theArraySet.value = value = module.local.get(3, binaryen.i64);
  assert(theArraySet.value === value);
  theArraySet.type = binaryen.i64;
  theArraySet.finalize();
  assert(theArraySet.type === binaryen.none);

  info = binaryen.getExpressionInfo(theArraySet);
  assert(info.type === theArraySet.type);
  assert(info.ref === theArraySet.ref);
  assert(info.index === theArraySet.index);
  assert(info.value === theArraySet.value);

  console.log(theArraySet.toText());
  assert(
    theArraySet.toText()
    ==
    "(array.set $array.0\n (local.get $2)\n (i32.const 1)\n (local.get $3)\n)\n"
  );

  module.dispose();
})();

console.log("# ArrayLen");
(function testArrayLen() {
  const builder = new binaryen.TypeBuilder(2);
  builder.setArrayType(0, binaryen.i32, binaryen.i16, true);
  builder.setArrayType(1, binaryen.i64, binaryen.notPacked, true);
  var [
    array0Type,
    array1Type
  ] = builder.buildAndDispose();

  const module = new binaryen.Module();

  var ref = module.local.get(0, array0Type);
  const theArrayLen = binaryen.ArrayLen(module.array.len(ref));
  assert(theArrayLen instanceof binaryen.ArrayLen);
  assert(theArrayLen instanceof binaryen.Expression);
  assert(theArrayLen.ref === ref);
  assert(theArrayLen.type === binaryen.i32);

  var info = binaryen.getExpressionInfo(theArrayLen);
  assert(info.id === theArrayLen.id);
  assert(info.type === theArrayLen.type);
  assert(info.ref === theArrayLen.ref);

  theArrayLen.ref = ref = module.local.get(1, array1Type);
  assert(theArrayLen.ref === ref);
  theArrayLen.type = binaryen.i64;
  theArrayLen.finalize();
  assert(theArrayLen.type === binaryen.i32);

  info = binaryen.getExpressionInfo(theArrayLen);
  assert(info.type === theArrayLen.type);
  assert(info.ref === theArrayLen.ref);

  console.log(theArrayLen.toText());
  assert(
    theArrayLen.toText()
    ==
    "(array.len\n (local.get $1)\n)\n"
  );

  module.dispose();
})();

console.log("# ArrayFill");
(function testArrayFill() {
  const builder = new binaryen.TypeBuilder(2);
  builder.setArrayType(0, binaryen.i32, binaryen.i16, true);
  builder.setArrayType(1, binaryen.i64, binaryen.notPacked, true);
  var [
    array0Type,
    array1Type
  ] = builder.buildAndDispose();

  const module = new binaryen.Module();

  var ref = module.local.get(0, array0Type);
  var index = module.i32.const(0);
  var value = module.local.get(1, binaryen.i32);
  var size = module.i32.const(1);
  const theArrayFill = binaryen.ArrayFill(module.array.fill(ref, index, value, size));
  assert(theArrayFill instanceof binaryen.ArrayFill);
  assert(theArrayFill instanceof binaryen.Expression);
  assert(theArrayFill.ref === ref);
  assert(theArrayFill.index === index);
  assert(theArrayFill.value === value);
  assert(theArrayFill.size === size);
  assert(theArrayFill.type === binaryen.none);

  var info = binaryen.getExpressionInfo(theArrayFill);
  assert(info.id === theArrayFill.id);
  assert(info.type === theArrayFill.type);
  assert(info.ref === theArrayFill.ref);
  assert(info.index === theArrayFill.index);
  assert(info.value === theArrayFill.value);
  assert(info.size === theArrayFill.size);

  theArrayFill.ref = ref = module.local.get(2, array1Type);
  assert(theArrayFill.ref === ref);
  theArrayFill.index = index = module.i32.const(2);
  assert(theArrayFill.index === index);
  theArrayFill.value = value = module.local.get(3, binaryen.i64);
  assert(theArrayFill.value = value);
  theArrayFill.size = size = module.i32.const(3);
  assert(theArrayFill.size === size);
  theArrayFill.type = binaryen.i64;
  theArrayFill.finalize();
  assert(theArrayFill.type === binaryen.none);

  info = binaryen.getExpressionInfo(theArrayFill);
  assert(info.type === theArrayFill.type);
  assert(info.ref === theArrayFill.ref);
  assert(info.index === theArrayFill.index);
  assert(info.value === theArrayFill.value);
  assert(info.size === theArrayFill.size);

  console.log(theArrayFill.toText());
  assert(
    theArrayFill.toText()
    ==
    "(array.fill $array.0\n (local.get $2)\n (i32.const 2)\n (local.get $3)\n (i32.const 3)\n)\n"
  );

  module.dispose();
})();

console.log("# ArrayCopy");
(function testArrayCopy() {
  const builder = new binaryen.TypeBuilder(2);
  builder.setArrayType(0, binaryen.i32, binaryen.i16, true);
  builder.setArrayType(1, binaryen.i64, binaryen.notPacked, true);
  var [
    array0Type,
    array1Type
  ] = builder.buildAndDispose();

  const module = new binaryen.Module();

  var destRef = module.local.get(0, array0Type);
  var destIndex = module.i32.const(0);
  var srcRef = module.local.get(1, array0Type);
  var srcIndex = module.i32.const(1);
  var length = module.i32.const(1);
  const theArrayCopy = binaryen.ArrayCopy(module.array.copy(destRef, destIndex, srcRef, srcIndex, length));
  assert(theArrayCopy instanceof binaryen.ArrayCopy);
  assert(theArrayCopy instanceof binaryen.Expression);
  assert(theArrayCopy.destRef === destRef);
  assert(theArrayCopy.destIndex === destIndex);
  assert(theArrayCopy.srcRef === srcRef);
  assert(theArrayCopy.srcIndex === srcIndex);
  assert(theArrayCopy.length === length);
  assert(theArrayCopy.type === binaryen.none);

  var info = binaryen.getExpressionInfo(theArrayCopy);
  assert(info.id === theArrayCopy.id);
  assert(info.type === theArrayCopy.type);
  assert(info.destRef === theArrayCopy.destRef);
  assert(info.destIndex === theArrayCopy.destIndex);
  assert(info.srcRef === theArrayCopy.srcRef);
  assert(info.srcIndex === theArrayCopy.srcIndex);
  assert(info.length === theArrayCopy.length);

  theArrayCopy.destRef = destRef = module.local.get(2, array1Type);
  assert(theArrayCopy.destRef === destRef);
  theArrayCopy.destIndex = destIndex = module.i32.const(2);
  assert(theArrayCopy.destIndex === destIndex);
  theArrayCopy.srcRef = srcRef = module.local.get(3, array1Type);
  assert(theArrayCopy.srcRef === srcRef);
  theArrayCopy.srcIndex = srcIndex = module.i32.const(3);
  assert(theArrayCopy.srcIndex === srcIndex);
  theArrayCopy.length = length = module.i32.const(2);
  assert(theArrayCopy.length === length);
  theArrayCopy.type = binaryen.i64;
  theArrayCopy.finalize();
  assert(theArrayCopy.type === binaryen.none);

  info = binaryen.getExpressionInfo(theArrayCopy);
  assert(info.type === theArrayCopy.type);
  assert(info.destRef === theArrayCopy.destRef);
  assert(info.destIndex === theArrayCopy.destIndex);
  assert(info.srcRef === theArrayCopy.srcRef);
  assert(info.srcIndex === theArrayCopy.srcIndex);
  assert(info.length === theArrayCopy.length);

  console.log(theArrayCopy.toText());
  assert(
    theArrayCopy.toText()
    ==
    "(array.copy $array.0 $array.0\n (local.get $2)\n (i32.const 2)\n (local.get $3)\n (i32.const 3)\n (i32.const 2)\n)\n"
  );

  module.dispose();
})();

console.log("# ArrayInitData");
(function testArrayInitData() {
  const builder = new binaryen.TypeBuilder(2);
  builder.setArrayType(0, binaryen.i32, binaryen.i16, true);
  builder.setArrayType(1, binaryen.i32, binaryen.notPacked, true);
  var [
    array0Type,
    array1Type
  ] = builder.buildAndDispose();

  const module = new binaryen.Module();

  var segment = "0";
  var ref = module.local.get(0, array0Type);
  var index = module.i32.const(0);
  var offset = module.i32.const(1);
  var size = module.i32.const(2);
  const theArrayInitData = binaryen.ArrayInitData(module.array.init_data(segment, ref, index, offset, size));
  assert(theArrayInitData instanceof binaryen.ArrayInitData);
  assert(theArrayInitData instanceof binaryen.Expression);
  assert(theArrayInitData.segment === segment);
  assert(theArrayInitData.ref === ref);
  assert(theArrayInitData.index === index);
  assert(theArrayInitData.offset === offset);
  assert(theArrayInitData.size === size);
  assert(theArrayInitData.type === binaryen.none);
  
  var info = binaryen.getExpressionInfo(theArrayInitData);
  assert(info.id === theArrayInitData.id);
  assert(info.type === theArrayInitData.type);
  assert(info.segment === theArrayInitData.segment);
  assert(info.ref === theArrayInitData.ref);
  assert(info.index === theArrayInitData.index);
  assert(info.offset === theArrayInitData.offset);
  assert(info.size === theArrayInitData.size);

  theArrayInitData.segment = segment = "1";
  assert(theArrayInitData.segment === segment);
  theArrayInitData.ref = ref = module.local.get(1, array1Type);
  assert(theArrayInitData.ref === ref);
  theArrayInitData.index = index = module.i32.const(3);
  assert(theArrayInitData.index === index);
  theArrayInitData.offset = offset = module.i32.const(4);
  assert(theArrayInitData.offset === offset);
  theArrayInitData.size = size = module.i32.const(5);
  assert(theArrayInitData.size === size);
  theArrayInitData.type = binaryen.i64;
  theArrayInitData.finalize();
  assert(theArrayInitData.type === binaryen.none);

  info = binaryen.getExpressionInfo(theArrayInitData);
  assert(info.type === theArrayInitData.type);
  assert(info.segment === theArrayInitData.segment);
  assert(info.ref === theArrayInitData.ref);
  assert(info.index === theArrayInitData.index);
  assert(info.offset === theArrayInitData.offset);
  assert(info.size === theArrayInitData.size);

  console.log(theArrayInitData.toText());
  assert(
    theArrayInitData.toText()
    ==
    "(array.init_data $array.0 $1\n (local.get $1)\n (i32.const 3)\n (i32.const 4)\n (i32.const 5)\n)\n"
  );

  module.dispose();
})();

console.log("# ArrayInitElem");
(function testArrayInitElem() {
  const builder = new binaryen.TypeBuilder(2);
  builder.setArrayType(0, binaryen.i32, binaryen.i16, true);
  builder.setArrayType(1, binaryen.i32, binaryen.notPacked, true);
  var [
    array0Type,
    array1Type
  ] = builder.buildAndDispose();

  const module = new binaryen.Module();

  var segment = "0";
  var ref = module.local.get(0, array0Type);
  var index = module.i32.const(0);
  var offset = module.i32.const(1);
  var size = module.i32.const(2);
  const theArrayInitElem = binaryen.ArrayInitElem(module.array.init_elem(segment, ref, index, offset, size));
  assert(theArrayInitElem instanceof binaryen.ArrayInitElem);
  assert(theArrayInitElem instanceof binaryen.Expression);
  assert(theArrayInitElem.segment === segment);
  assert(theArrayInitElem.ref === ref);
  assert(theArrayInitElem.index === index);
  assert(theArrayInitElem.offset === offset);
  assert(theArrayInitElem.size === size);
  assert(theArrayInitElem.type === binaryen.none);

  var info = binaryen.getExpressionInfo(theArrayInitElem);
  assert(info.id === theArrayInitElem.id);
  assert(info.type === theArrayInitElem.type);
  assert(info.segment === theArrayInitElem.segment);
  assert(info.ref === theArrayInitElem.ref);
  assert(info.index === theArrayInitElem.index);
  assert(info.offset === theArrayInitElem.offset);
  assert(info.size === theArrayInitElem.size);

  theArrayInitElem.segment = segment = "1";
  assert(theArrayInitElem.segment === segment);
  theArrayInitElem.ref = ref = module.local.get(1, array1Type);
  assert(theArrayInitElem.ref === ref);
  theArrayInitElem.index = index = module.i32.const(3);
  assert(theArrayInitElem.index === index);
  theArrayInitElem.offset = offset = module.i32.const(4);
  assert(theArrayInitElem.offset === offset);
  theArrayInitElem.size = size = module.i32.const(5);
  assert(theArrayInitElem.size === size);
  theArrayInitElem.type = binaryen.i64;
  theArrayInitElem.finalize();
  assert(theArrayInitElem.type === binaryen.none);

  info = binaryen.getExpressionInfo(theArrayInitElem);
  assert(info.type === theArrayInitElem.type);
  assert(info.segment === theArrayInitElem.segment);
  assert(info.ref === theArrayInitElem.ref);
  assert(info.index === theArrayInitElem.index);
  assert(info.offset === theArrayInitElem.offset);
  assert(info.size === theArrayInitElem.size);

  console.log(theArrayInitElem.toText());
  assert(
    theArrayInitElem.toText()
    ==
    "(array.init_elem $array.0 $1\n (local.get $1)\n (i32.const 3)\n (i32.const 4)\n (i32.const 5)\n)\n"
  );

  module.dispose();
})();

console.log("# Try");
(function testTry() {
  const module = new binaryen.Module();
  module.addTag("tag1", 0, binaryen.none, binaryen.none);
  module.addTag("tag2", 0, binaryen.none, binaryen.none);
  module.addTag("tag3", 0, binaryen.none, binaryen.none);

  var body = module.i32.const(1);
  var catchBodies = [
    module.i32.const(2),
    module.i32.const(3)
  ];
  const theTry = binaryen.Try(module.try('', body, ["tag1"], catchBodies, ''));
  assert(theTry instanceof binaryen.Try);
  assert(theTry instanceof binaryen.Expression);
  assert(theTry.body === body);
  assertDeepEqual(theTry.catchBodies, catchBodies);
  assert(theTry.type === binaryen.i32);
  assert(theTry.getNumCatchTags() == 1);
  assert(theTry.getNumCatchBodies() == 2);
  assert(theTry.hasCatchAll() == 1);
  console.log(theTry.toText());

  var info = binaryen.getExpressionInfo(theTry);
  assert(info.id === theTry.id);
  assert(info.type === theTry.type);
  assert(info.name === theTry.name);
  assert(info.body === theTry.body);
  assertDeepEqual(info.catchTags, theTry.catchTags);
  assertDeepEqual(info.catchBodies, theTry.catchBodies);
  assert(info.hasCatchAll === theTry.hasCatchAll());
  assert(info.delegateTarget === theTry.delegateTarget);
  assert(info.isDelegate === theTry.delegate);

  theTry.body = body = module.i32.const(4);
  assert(theTry.body === body);
  catchBodies = [
    module.i32.const(5) // set
    //remove
  ];
  theTry.setCatchBodies(catchBodies);
  assertDeepEqual(theTry.catchBodies, catchBodies);
  assertDeepEqual(theTry.getCatchBodies(), catchBodies);
  console.log(theTry.toText());

  theTry.insertCatchTagAt(1, "tag2");
  theTry.insertCatchBodyAt(0, module.i32.const(6));
  assert(theTry.getNumCatchTags() == 2);
  assert(theTry.getNumCatchBodies() == 2);
  assert(theTry.hasCatchAll() == 0);
  console.log(theTry.toText());

  assert(theTry.removeCatchTagAt(1) == "tag2");
  theTry.removeCatchBodyAt(1);
  assert(theTry.getNumCatchTags() == 1);
  assert(theTry.getNumCatchBodies() == 1);
  console.log(theTry.toText());

  theTry.appendCatchTag("tag3");
  theTry.appendCatchBody(module.drop(module.i32.const(7)));
  assert(theTry.getCatchTagAt(0) == "tag1");
  assert(theTry.getCatchTagAt(1) == "tag3");
  theTry.setCatchTags(["tag2", "tag3"]);
  assertDeepEqual(theTry.getCatchTags(), ["tag2", "tag3"]);
  theTry.setCatchBodies([module.i32.const(8), module.i32.const(9)]);
  assert(theTry.getCatchTagAt(0) == "tag2");
  assert(theTry.getCatchTagAt(1) == "tag3");
  theTry.setCatchTagAt(1, "tag1");
  theTry.setCatchBodyAt(1, module.i32.const(10));
  assert(theTry.getCatchTagAt(1) == "tag1");
  console.log(theTry.toText());

  theTry.type = binaryen.f64;
  theTry.finalize();
  assert(theTry.type === binaryen.i32);

  info = binaryen.getExpressionInfo(theTry);
  assert(info.id === theTry.id);
  assert(info.type === theTry.type);
  assert(info.name === theTry.name);
  assert(info.body === theTry.body);
  assertDeepEqual(info.catchTags, theTry.catchTags);
  assertDeepEqual(info.catchBodies, theTry.catchBodies);
  assert(info.hasCatchAll === theTry.hasCatchAll());
  assert(info.delegateTarget === theTry.delegateTarget);
  assert(info.isDelegate === theTry.delegate);

  console.log(theTry.toText());

  const tryDelegate = binaryen.Try(module.try('', body, [], [], "try_blah"));
  assert(tryDelegate.isDelegate() == 1);
  assert(tryDelegate.getDelegateTarget() == "try_blah");
  tryDelegate.setDelegateTarget("try_outer");
  assert(tryDelegate.getDelegateTarget() == "try_outer");

  info = binaryen.getExpressionInfo(tryDelegate);
  assert(info.delegateTarget === tryDelegate.delegateTarget);
  assert(info.isDelegate === tryDelegate.delegate);

  console.log(tryDelegate.toText());

  module.dispose();
})();

console.log("# Throw");
(function testThrow() {
  const module = new binaryen.Module();

  var tag = "foo";
  var operands = [
    module.i32.const(1),
    module.i32.const(2)
  ];
  const theThrow = binaryen.Throw(module.throw(tag, operands));
  assert(theThrow instanceof binaryen.Throw);
  assert(theThrow instanceof binaryen.Expression);
  assert(theThrow.tag === tag);
  assertDeepEqual(theThrow.operands, operands);
  assert(theThrow.type === binaryen.unreachable);

  var info = binaryen.getExpressionInfo(theThrow);
  assert(info.id === theThrow.id);
  assert(info.type === theThrow.type);
  assert(info.tag === theThrow.tag);
  assertDeepEqual(info.operands, theThrow.operands);

  theThrow.tag = "bar";
  assert(theThrow.tag === "bar");
  theThrow.operands = operands = [
    module.i32.const(3), // set
    module.i32.const(4), // set
    module.i32.const(5)  // append
  ];
  assertDeepEqual(theThrow.operands, operands);
  assertDeepEqual(theThrow.getOperands(), operands);
  operands = [
    module.i32.const(6) // set
    // remove
    // remove
  ];
  theThrow.setOperands(operands);
  assertDeepEqual(theThrow.operands, operands);
  theThrow.insertOperandAt(1, module.i32.const(7));
  theThrow.type = binaryen.f64;
  theThrow.finalize();
  assert(theThrow.type === binaryen.unreachable);

  info = binaryen.getExpressionInfo(theThrow);
  assert(info.type === theThrow.type);
  assert(info.tag === theThrow.tag);
  assertDeepEqual(info.operands, theThrow.operands);

  console.log(theThrow.toText());
  assert(
    theThrow.toText()
    ==
    "(throw $bar\n (i32.const 6)\n (i32.const 7)\n)\n"
  );

  module.dispose();
})();

console.log("# Rethrow");
(function testRethrow() {
  const module = new binaryen.Module();

  const theRethrow = binaryen.Rethrow(module.rethrow("l0"));
  assert(theRethrow instanceof binaryen.Rethrow);
  assert(theRethrow instanceof binaryen.Expression);
  assert(theRethrow.target === "l0");
  assert(theRethrow.type === binaryen.unreachable);

  var info = binaryen.getExpressionInfo(theRethrow);
  assert(info.id === theRethrow.id);
  assert(info.type === theRethrow.type);
  assert(info.target === theRethrow.target);

  theRethrow.target = "l1";
  assert(theRethrow.target === "l1");
  theRethrow.type = binaryen.f64;
  theRethrow.finalize();
  assert(theRethrow.type === binaryen.unreachable);

  info = binaryen.getExpressionInfo(theRethrow);
  assert(info.type === theRethrow.type);
  assert(info.target === theRethrow.target);

  console.log(theRethrow.toText());
  assert(
    theRethrow.toText()
    ==
    "(rethrow $l1)\n"
  );

  module.dispose();
})();

console.log("# TupleMake");
(function testTupleMake() {
  const module = new binaryen.Module();

  var operands = [
    module.i32.const(1),
    module.i32.const(2)
  ];
  var type = binaryen.createType([ binaryen.i32, binaryen.i32 ]);
  const theTupleMake = binaryen.TupleMake(module.tuple.make(operands));
  assert(theTupleMake instanceof binaryen.TupleMake);
  assert(theTupleMake instanceof binaryen.Expression);
  assertDeepEqual(theTupleMake.operands, operands);
  assert(theTupleMake.type === type);

  var info = binaryen.getExpressionInfo(theTupleMake);
  assert(info.id === theTupleMake.id);
  assert(info.type === theTupleMake.type);
  assertDeepEqual(info.operands, theTupleMake.operands);

  theTupleMake.operands = operands = [
    module.i32.const(3), // set
    module.i32.const(4), // set
    module.i32.const(5)  // append
  ];
  assertDeepEqual(theTupleMake.operands, operands);
  operands = [
    module.i32.const(6) // set
    // remove
    // remove
  ];
  theTupleMake.setOperands(operands);
  assertDeepEqual(theTupleMake.operands, operands);
  assertDeepEqual(theTupleMake.getOperands(), operands);
  theTupleMake.insertOperandAt(1, module.i32.const(7));
  theTupleMake.type = binaryen.f64;
  theTupleMake.finalize();
  assert(theTupleMake.type === type);

  info = binaryen.getExpressionInfo(theTupleMake);
  assert(info.type === theTupleMake.type);
  assertDeepEqual(info.operands, theTupleMake.operands);

  console.log(theTupleMake.toText());
  assert(
    theTupleMake.toText()
    ==
    "(tuple.make 2\n (i32.const 6)\n (i32.const 7)\n)\n"
  );

  module.dispose();
})();

console.log("# TupleExtract");
(function testTupleExtract() {
  const module = new binaryen.Module();

  var tuple = module.tuple.make([
    module.i32.const(1),
    module.i32.const(2)
  ]);
  var index = 1;
  const theTupleExtract = binaryen.TupleExtract(module.tuple.extract(tuple, index));
  assert(theTupleExtract instanceof binaryen.TupleExtract);
  assert(theTupleExtract instanceof binaryen.Expression);
  assert(theTupleExtract.tuple === tuple);
  assert(theTupleExtract.index === index);
  assert(theTupleExtract.type === binaryen.i32);

  var info = binaryen.getExpressionInfo(theTupleExtract);
  assert(info.id === theTupleExtract.id);
  assert(info.type === theTupleExtract.type);
  assert(info.tuple === theTupleExtract.tuple);
  assert(info.index === theTupleExtract.index);

  theTupleExtract.tuple = tuple = module.tuple.make([
    module.f64.const(3),
    module.f64.const(4)
  ]);
  assert(theTupleExtract.tuple === tuple);
  theTupleExtract.index = index = 0;
  assert(theTupleExtract.index === index);
  theTupleExtract.type = binaryen.i32;
  theTupleExtract.finalize();
  assert(theTupleExtract.type === binaryen.f64);

  info = binaryen.getExpressionInfo(theTupleExtract);
  assert(info.type === theTupleExtract.type);
  assert(info.tuple === theTupleExtract.tuple);
  assert(info.index === theTupleExtract.index);

  console.log(theTupleExtract.toText());
  assert(
    theTupleExtract.toText()
    ==
    "(tuple.extract 2 0\n (tuple.make 2\n  (f64.const 3)\n  (f64.const 4)\n )\n)\n"
  );

  module.dispose();
})();

console.log("# RefI31");
(function testRefI31() {
  const module = new binaryen.Module();

  var value = module.local.get(1, binaryen.i32);
  const theRefI31 = binaryen.RefI31(module.ref.i31(value));
  assert(theRefI31 instanceof binaryen.RefI31);
  assert(theRefI31 instanceof binaryen.Expression);
  assert(theRefI31.value === value);
  // assert(theRefI31.type === binaryen.?); // TODO: (ref i31)

  var info = binaryen.getExpressionInfo(theRefI31);
  assert(info.id === theRefI31.id);
  assert(info.type === theRefI31.type);
  assert(info.value === theRefI31.value);

  theRefI31.value = value = module.local.get(2, binaryen.i32);
  assert(theRefI31.value === value);

  info = binaryen.getExpressionInfo(theRefI31);
  assert(info.value === theRefI31.value);

  console.log(theRefI31.toText());
  assert(
    theRefI31.toText()
    ==
    "(ref.i31\n (local.get $2)\n)\n"
  );

  module.dispose();
})();

console.log("# I31Get");
(function testI31Get() {
  const module = new binaryen.Module();

  var i31 = module.local.get(1, binaryen.i31ref);
  const theI31Get = binaryen.I31Get(module.i31.get_s(i31));
  assert(theI31Get instanceof binaryen.I31Get);
  assert(theI31Get instanceof binaryen.Expression);
  assert(theI31Get.i31 === i31);
  assert(theI31Get.signed === true);
  assert(theI31Get.type === binaryen.i32);

  var info = binaryen.getExpressionInfo(theI31Get);
  assert(info.id === theI31Get.id);
  assert(info.type === theI31Get.type);
  assert(info.i31 === theI31Get.i31);
  assert(info.isSigned === theI31Get.signed);

  theI31Get.i31 = i31 = module.local.get(2, binaryen.i31ref);
  assert(theI31Get.i31 === i31);
  theI31Get.signed = false;
  assert(theI31Get.signed === false);
  theI31Get.type = binaryen.f64;
  theI31Get.finalize();
  assert(theI31Get.type === binaryen.i32);

  info = binaryen.getExpressionInfo(theI31Get);
  assert(info.type === theI31Get.type);
  assert(info.i31 === theI31Get.i31);
  assert(info.isSigned === theI31Get.signed);

  console.log(theI31Get.toText());
  assert(
    theI31Get.toText()
    ==
    "(i31.get_u\n (local.get $2)\n)\n"
  );

  module.dispose();
})();
