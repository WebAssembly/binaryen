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
  assert(theExpression.expr === 42);
  assert((theExpression | 0) === 42); // via valueOf
})();

console.log("# Block");
(function testBlock() {
  var module = new binaryen.Module();

  var theBlock = binaryen.Block(module.block(null, []));
  assert(theBlock instanceof binaryen.Block);
  assert(theBlock instanceof binaryen.Expression);
  assert(theBlock.id === binaryen.BlockId);
  assert(theBlock.name === null);
  assert(theBlock.type === binaryen.none);

  theBlock.name ="theName";
  assert(theBlock.name === "theName");
  theBlock.type = binaryen.i32;
  assert(theBlock.type === binaryen.i32);
  assert(theBlock.numChildren === 0);
  assertDeepEqual(theBlock.children, []);

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

  var condition = module.i32.const(1);
  var ifTrue = module.i32.const(2);
  var ifFalse = module.i32.const(3);
  var theIf = binaryen.If(module.if(condition, ifTrue, ifFalse));
  assert(theIf instanceof binaryen.If);
  assert(theIf instanceof binaryen.Expression);
  assert(theIf.id === binaryen.IfId);
  assert(theIf.condition === condition);
  assert(theIf.ifTrue === ifTrue);
  assert(theIf.ifFalse === ifFalse);
  assert(theIf.type == binaryen.i32);

  theIf.condition = condition = module.i32.const(4);
  assert(theIf.condition === condition);
  theIf.ifTrue = ifTrue = module.i32.const(5);
  assert(theIf.ifTrue === ifTrue);
  theIf.ifFalse = ifFalse = module.i32.const(6);
  assert(theIf.ifFalse === ifFalse);
  theIf.finalize();

  console.log(theIf.toText());
  assert(
    theIf.toText()
    ==
    "(if (result i32)\n (i32.const 4)\n (i32.const 5)\n (i32.const 6)\n)\n"
  );

  theIf.ifFalse = null;
  assert(!theIf.ifFalse);
  console.log(theIf.toText());
  assert(
    theIf.toText()
    ==
    "(if (result i32)\n (i32.const 4)\n (i32.const 5)\n)\n"
  );

  module.dispose();
})();

console.log("# Loop");
(function testLoop() {
  var module = new binaryen.Module();

  var name = null;
  var body = module.i32.const(1);
  var theLoop = binaryen.Loop(module.loop(name, body));
  assert(theLoop instanceof binaryen.Loop);
  assert(theLoop instanceof binaryen.Expression);
  assert(theLoop.id === binaryen.LoopId);
  assert(theLoop.name === name);
  assert(theLoop.body === body);
  assert(theLoop.type === binaryen.i32);

  theLoop.name = name = "theName";
  assert(theLoop.name === name);
  theLoop.body = body = module.drop(body);
  assert(theLoop.body === body);
  theLoop.finalize();
  assert(theLoop.type === binaryen.none);

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
  var module = new binaryen.Module();

  var name = "theName";
  var condition = module.i32.const(1);
  var value = module.i32.const(2);
  var theBreak = binaryen.Break(module.br(name, condition, value));
  assert(theBreak instanceof binaryen.Break);
  assert(theBreak instanceof binaryen.Expression);
  assert(theBreak.name === name);
  assert(theBreak.condition === condition);
  assert(theBreak.value === value);
  assert(theBreak.type === binaryen.i32);

  theBreak.name = name = "theNewName";
  assert(theBreak.name === "theNewName");
  theBreak.condition = condition = module.i32.const(3);
  assert(theBreak.condition === condition);
  theBreak.value = value = module.i32.const(4);
  assert(theBreak.value === value);
  theBreak.finalize();

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
  var module = new binaryen.Module();

  var names = ["a", "b"];
  var defaultName = "c";
  var condition = module.i32.const(1);
  var value = module.i32.const(2);
  var theSwitch = binaryen.Switch(module.switch(names, defaultName, condition, value));
  assert(theSwitch instanceof binaryen.Switch);
  assert(theSwitch instanceof binaryen.Expression);
  assert(theSwitch.numNames === 2);
  assertDeepEqual(theSwitch.names, names);
  assert(theSwitch.defaultName === defaultName);
  assert(theSwitch.condition === condition);
  assert(theSwitch.value === value);
  assert(theSwitch.type === binaryen.unreachable);

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
  theSwitch.condition = condition = module.i32.const(3);
  assert(theSwitch.condition === condition);
  theSwitch.value = value = module.i32.const(4);
  assert(theSwitch.value === value);
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
  assert(theCall instanceof binaryen.Call);
  assert(theCall instanceof binaryen.Expression);
  assert(theCall.target === target);
  assertDeepEqual(theCall.operands, operands);
  assert(theCall.return === false);
  assert(theCall.type === binaryen.i32);

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
  assert(theCallIndirect instanceof binaryen.CallIndirect);
  assert(theCallIndirect instanceof binaryen.Expression);
  assert(theCallIndirect.target === target);
  assertDeepEqual(theCallIndirect.operands, operands);
  assert(theCallIndirect.params === params);
  assert(theCallIndirect.results === results);
  assert(theCallIndirect.return === false);
  assert(theCallIndirect.type === theCallIndirect.results);

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
  assert(theLocalGet instanceof binaryen.LocalGet);
  assert(theLocalGet instanceof binaryen.Expression);
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
  assert(theLocalSet instanceof binaryen.LocalSet);
  assert(theLocalSet instanceof binaryen.Expression);
  assert(theLocalSet.index === index);
  assert(theLocalSet.value === value);
  assert(theLocalSet.tee === false);
  assert(theLocalSet.type == binaryen.none);

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
  );

  module.dispose();
})();

console.log("# GlobalGet");
(function testGlobalGet() {
  var module = new binaryen.Module();

  var name = "a";
  var type = binaryen.i32;
  var theGlobalGet = binaryen.GlobalGet(module.global.get(name, type));
  assert(theGlobalGet instanceof binaryen.GlobalGet);
  assert(theGlobalGet instanceof binaryen.Expression);
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
  assert(theGlobalSet instanceof binaryen.GlobalSet);
  assert(theGlobalSet instanceof binaryen.Expression);
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
  );

  module.dispose();
})();

console.log("# Host");
(function testHost() {
  var module = new binaryen.Module();

  var op = binaryen.Operations.MemorySize;
  var nameOp = null;
  var operands = [];
  var theHost = binaryen.Host(module.memory.size());
  assert(theHost instanceof binaryen.Host);
  assert(theHost instanceof binaryen.Expression);
  assert(theHost.op === op);
  assert(theHost.nameOperand === nameOp);
  assertDeepEqual(theHost.operands, operands);
  assert(theHost.type === binaryen.i32);

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
  assert(theLoad instanceof binaryen.Load);
  assert(theLoad instanceof binaryen.Expression);
  assert(theLoad.offset === offset);
  assert(theLoad.align === align);
  assert(theLoad.ptr === ptr);
  assert(theLoad.bytes === 4);
  assert(theLoad.signed === true);
  assert(theLoad.atomic === false);
  assert(theLoad.type == binaryen.i32);

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

  console.log(theLoad.toText());
  assert(
    theLoad.toText()
    ==
    "(i64.atomic.load offset=32 align=4\n (i32.const 128)\n)\n"
  );

  module.dispose();
})();

console.log("# Store");
(function testStore() {
  var module = new binaryen.Module();

  var offset = 16;
  var align = 2;
  var ptr = module.i32.const(64);
  var value = module.i32.const(1);
  var theStore = binaryen.Store(module.i32.store(offset, align, ptr, value));
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

  console.log(theStore.toText());
  assert(
    theStore.toText()
    ==
    "(i64.atomic.store offset=32 align=4\n (i32.const 128)\n (i32.const 2)\n)\n"
  );

  module.dispose();
})();

console.log("# Const");
(function testConst() {
  var module = new binaryen.Module();

  var theConst = binaryen.Const(module.i32.const(1));
  assert(theConst instanceof binaryen.Const);
  assert(theConst instanceof binaryen.Expression);
  assert(theConst.valueI32 === 1);
  theConst.valueI32 = 2;
  assert(theConst.valueI32 === 2);
  assert(theConst.type === binaryen.i32);

  theConst.valueI64Low = 3;
  assert(theConst.valueI64Low === 3);
  theConst.valueI64High = 4;
  assert(theConst.valueI64High === 4);
  theConst.finalize();
  assert(theConst.type == binaryen.i64);

  theConst.valueF32 = 5;
  assert(theConst.valueF32 === 5);
  theConst.finalize();
  assert(theConst.type === binaryen.f32);

  theConst.valueF64 = 6;
  assert(theConst.valueF64 === 6);
  theConst.finalize();
  assert(theConst.type === binaryen.f64);

  theConst.valueV128 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];
  assertDeepEqual(theConst.valueV128, [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]);
  theConst.finalize();
  assert(theConst.type === binaryen.v128);

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
  var module = new binaryen.Module();

  var op = binaryen.Operations.EqZInt32;
  var value = module.i32.const(1);
  var theUnary = binaryen.Unary(module.i32.eqz(value));
  assert(theUnary instanceof binaryen.Unary);
  assert(theUnary instanceof binaryen.Expression);
  assert(theUnary.op === op);
  assert(theUnary.value === value);
  assert(theUnary.type === binaryen.i32);

  theUnary.op = op = binaryen.Operations.EqZInt64;
  assert(theUnary.op === op);
  theUnary.value = value = module.i64.const(2);
  assert(theUnary.value === value);
  theUnary.type = binaryen.f32;
  theUnary.finalize();
  assert(theUnary.type === binaryen.i32);

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
  var module = new binaryen.Module();

  var op = binaryen.Operations.AddInt32;
  var left = module.i32.const(1);
  var right = module.i32.const(2);
  var theBinary = binaryen.Binary(module.i32.add(left, right));
  assert(theBinary instanceof binaryen.Binary);
  assert(theBinary instanceof binaryen.Expression);
  assert(theBinary.op === op);
  assert(theBinary.left === left);
  assert(theBinary.right === right);
  assert(theBinary.type === binaryen.i32);

  theBinary.op = op = binaryen.Operations.AddInt64;
  assert(theBinary.op === op);
  theBinary.left = left = module.i64.const(3);
  assert(theBinary.left === left);
  theBinary.right = right = module.i64.const(4);
  assert(theBinary.right === right);
  theBinary.type = binaryen.f32;
  theBinary.finalize();
  assert(theBinary.type === binaryen.i64);

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
  var theSelect = binaryen.Select(module.select(condition, ifTrue, ifFalse));  assert(theSelect.ifTrue === ifTrue);
  assert(theSelect instanceof binaryen.Select);
  assert(theSelect instanceof binaryen.Expression);
  assert(theSelect.condition === condition);
  assert(theSelect.ifTrue === ifTrue);
  assert(theSelect.ifFalse === ifFalse);
  assert(theSelect.type === binaryen.i32);

  theSelect.condition = condition = module.i32.const(4);
  assert(theSelect.condition === condition);
  theSelect.ifTrue = ifTrue = module.i64.const(5);
  assert(theSelect.ifTrue === ifTrue);
  theSelect.ifFalse = ifFalse = module.i64.const(6);
  assert(theSelect.ifFalse === ifFalse);
  theSelect.finalize();
  assert(theSelect.type === binaryen.i64);

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
  var theDrop = binaryen.Drop(module.drop(value));
  assert(theDrop instanceof binaryen.Drop);
  assert(theDrop instanceof binaryen.Expression);
  assert(theDrop.value === value);
  assert(theDrop.type === binaryen.none);

  theDrop.value = value = module.i32.const(2);
  assert(theDrop.value === value);

  theDrop.finalize();
  assert(theDrop.type === binaryen.none);

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
  var theReturn = binaryen.Return(module.return(value));
  assert(theReturn instanceof binaryen.Return);
  assert(theReturn instanceof binaryen.Expression);
  assert(theReturn.value === value);
  assert(theReturn.type === binaryen.unreachable);

  theReturn.value = value = module.i32.const(2);
  assert(theReturn.value === value);

  theReturn.finalize();
  assert(theReturn.type === binaryen.unreachable);

  console.log(theReturn.toText());
  assert(
    theReturn.toText()
    ==
    "(return\n (i32.const 2)\n)\n"
  );

  module.dispose();
})();

// TODO: Test for AtomicRMW

// TODO: Test for AtomicCmpxchg

// TODO: Test for Atomicwait

// TODO: Test for AtomicNotify

// TODO: Test for AtomicFence

// TODO: Test for SIMDExtract

// TODO: Test for SIMDReplace

// TODO: Test for SIMDShuffle

// TODO: Test for SIMDTernary

// TODO: Test for SIMDShift

// TODO: Test for SIMDLoad

// TODO: Test for MemoryInit

// TODO: Test for DataDrop

// TODO: Test for MemoryCopy

// TODO: Test for MemoryFill

// TODO: Test for RefIsNulll

// TODO: Test for RefFunc

// TODO: Test for Try

// TODO: Test for Throw

// TODO: Test for Rethrow

// TODO: Test for BrOnExn

// TODO: Test for TupleMake

// TODO: Test for TupleExtract
