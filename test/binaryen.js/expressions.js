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
  const module = new binaryen.Module();

  var target = module.i32.const(42);
  var params = binaryen.none;
  var results = binaryen.none;
  var operands = [
    module.i32.const(1),
    module.i32.const(2)
  ];
  const theCallIndirect = binaryen.CallIndirect(module.call_indirect(target, operands, params, results));
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
  const module = new binaryen.Module();

  var index = 1;
  var type = binaryen.i32;
  const theLocalGet = binaryen.LocalGet(module.local.get(index, type));
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
  const module = new binaryen.Module();

  var name = "a";
  var type = binaryen.i32;
  const theGlobalGet = binaryen.GlobalGet(module.global.get(name, type));
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
  const module = new binaryen.Module();

  var name = "a";
  var value = module.i32.const(1);
  const theGlobalSet = binaryen.GlobalSet(module.global.set(name, value));
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

console.log("# MemorySize");
(function testMemorySize() {
  const module = new binaryen.Module();

  var type = binaryen.i32;
  const theMemorySize = binaryen.MemorySize(module.memory.size());
  assert(theMemorySize instanceof binaryen.MemorySize);
  assert(theMemorySize instanceof binaryen.Expression);
  assert(theMemorySize.type === type);

  theMemorySize.type = type = binaryen.f64;
  assert(theMemorySize.type === type);
  theMemorySize.finalize();
  assert(theMemorySize.type === binaryen.i32);

  console.log(theMemorySize.toText());
  assert(
    theMemorySize.toText()
    ==
    "(memory.size)\n"
  );

  module.dispose();
})();

console.log("# MemoryGrow");
(function testMemoryGrow() {
  const module = new binaryen.Module();

  var type = binaryen.i32;
  var delta = module.i32.const(1);
  const theMemoryGrow = binaryen.MemoryGrow(module.memory.grow(delta));
  assert(theMemoryGrow instanceof binaryen.MemoryGrow);
  assert(theMemoryGrow instanceof binaryen.Expression);
  assert(theMemoryGrow.delta === delta);
  assert(theMemoryGrow.type === type);

  theMemoryGrow.delta = delta = module.i32.const(2);
  assert(theMemoryGrow.delta === delta);
  theMemoryGrow.type = type = binaryen.f64;
  assert(theMemoryGrow.type === type);
  theMemoryGrow.finalize();
  assert(theMemoryGrow.type === binaryen.i32);

  console.log(theMemoryGrow.toText());
  assert(
    theMemoryGrow.toText()
    ==
    "(memory.grow\n (i32.const 2)\n)\n"
  );

  module.dispose();
})();

console.log("# Load");
(function testLoad() {
  const module = new binaryen.Module();

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
  const module = new binaryen.Module();

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
  const module = new binaryen.Module();

  const theConst = binaryen.Const(module.i32.const(1));
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
  const module = new binaryen.Module();

  var op = binaryen.Operations.EqZInt32;
  var value = module.i32.const(1);
  const theUnary = binaryen.Unary(module.i32.eqz(value));
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
  const theSelect = binaryen.Select(module.select(condition, ifTrue, ifFalse));  assert(theSelect.ifTrue === ifTrue);
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
  const theDrop = binaryen.Drop(module.drop(value));
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
  const theReturn = binaryen.Return(module.return(value));
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

console.log("# AtomicRMW");
(function testAtomicRMW() {
  const module = new binaryen.Module();

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

  console.log(theAtomicRMW.toText());
  assert(
    theAtomicRMW.toText()
    ==
    "(i64.atomic.rmw16.sub_u offset=16\n (i32.const 4)\n (i64.const 5)\n)\n"
  );

  module.dispose();
})();

console.log("# AtomicCmpxchg");
(function testAtomicCmpxchg() {
  const module = new binaryen.Module();

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

  console.log(theAtomicCmpxchg.toText());
  assert(
    theAtomicCmpxchg.toText()
    ==
    "(i64.atomic.rmw16.cmpxchg_u offset=16\n (i32.const 5)\n (i64.const 6)\n (i64.const 7)\n)\n"
  );

  module.dispose();
})();

console.log("# AtomicWait");
(function testAtomicWait() {
  const module = new binaryen.Module();

  var ptr = module.i32.const(2);
  var expected = module.i32.const(3);
  var timeout = module.i64.const(4);
  const theAtomicWait = binaryen.AtomicWait(module.i32.atomic.wait(ptr, expected, timeout));
  assert(theAtomicWait instanceof binaryen.AtomicWait);
  assert(theAtomicWait instanceof binaryen.Expression);
  assert(theAtomicWait.ptr === ptr);
  assert(theAtomicWait.expected === expected);
  assert(theAtomicWait.expectedType === binaryen.i32);
  assert(theAtomicWait.timeout === timeout);
  assert(theAtomicWait.type === binaryen.i32);

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

  console.log(theAtomicWait.toText());
  assert(
    theAtomicWait.toText()
    ==
    "(i64.atomic.wait\n (i32.const 5)\n (i32.const 6)\n (i64.const 7)\n)\n"
  );

  module.dispose();
})();

console.log("# AtomicNotify");
(function testAtomicNotify() {
  const module = new binaryen.Module();

  var ptr = module.i32.const(1);
  var notifyCount = module.i32.const(2);
  const theAtomicNotify = binaryen.AtomicNotify(module.atomic.notify(ptr, notifyCount));
  assert(theAtomicNotify instanceof binaryen.AtomicNotify);
  assert(theAtomicNotify instanceof binaryen.Expression);
  assert(theAtomicNotify.ptr === ptr);
  assert(theAtomicNotify.notifyCount === notifyCount);
  assert(theAtomicNotify.type === binaryen.i32);

  theAtomicNotify.ptr = ptr = module.i32.const(3);
  assert(theAtomicNotify.ptr === ptr);
  theAtomicNotify.notifyCount = notifyCount = module.i32.const(4);
  assert(theAtomicNotify.notifyCount === notifyCount);
  theAtomicNotify.type = binaryen.f64;
  theAtomicNotify.finalize();
  assert(theAtomicNotify.type === binaryen.i32);

  console.log(theAtomicNotify.toText());
  assert(
    theAtomicNotify.toText()
    ==
    "(atomic.notify\n (i32.const 3)\n (i32.const 4)\n)\n"
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

  theAtomicFence.order = 1;
  assert(theAtomicFence.order === 1);
  theAtomicFence.type = binaryen.f64;
  theAtomicFence.finalize();
  assert(theAtomicFence.type === binaryen.none);

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

  theSIMDExtract.op = op = binaryen.Operations.ExtractLaneSVecI16x8;
  assert(theSIMDExtract.op === op);
  theSIMDExtract.vec = vec = module.v128.const([1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]);
  assert(theSIMDExtract.vec === vec);
  theSIMDExtract.index = index = 1;
  assert(theSIMDExtract.index === index);
  theSIMDExtract.type = binaryen.f64;
  theSIMDExtract.finalize();
  assert(theSIMDExtract.type === binaryen.i32);

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
  const theSIMDShuffle = binaryen.SIMDShuffle(module.v8x16.shuffle(left, right, mask));
  assert(theSIMDShuffle instanceof binaryen.SIMDShuffle);
  assert(theSIMDShuffle instanceof binaryen.Expression);
  assert(theSIMDShuffle.left === left);
  assert(theSIMDShuffle.right === right);
  assertDeepEqual(theSIMDShuffle.mask, mask);
  assert(theSIMDShuffle.type === binaryen.v128);

  theSIMDShuffle.left = left = module.v128.const([1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]);
  assert(theSIMDShuffle.left === left);
  theSIMDShuffle.right = right = module.v128.const([2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2]);
  assert(theSIMDShuffle.right === right);
  theSIMDShuffle.mask = mask = [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3];
  assertDeepEqual(theSIMDShuffle.mask, mask);
  theSIMDShuffle.type = binaryen.f64;
  theSIMDShuffle.finalize();
  assert(theSIMDShuffle.type === binaryen.v128);

  console.log(theSIMDShuffle.toText());
  assert(
    theSIMDShuffle.toText()
    ==
    "(v8x16.shuffle 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3\n (v128.const i32x4 0x01010101 0x01010101 0x01010101 0x01010101)\n (v128.const i32x4 0x02020202 0x02020202 0x02020202 0x02020202)\n)\n"
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

  theSIMDTernary.op = op = binaryen.Operations.QFMAVecF64x2;
  assert(theSIMDTernary.op === op);
  theSIMDTernary.a = a = module.v128.const([1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]);
  assert(theSIMDTernary.a === a);
  theSIMDTernary.b = b = module.v128.const([2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2]);
  assert(theSIMDTernary.b === b);
  theSIMDTernary.c = c = module.v128.const([3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3]);
  assert(theSIMDTernary.c === c);
  theSIMDTernary.type = binaryen.f64;
  theSIMDTernary.finalize();
  assert(theSIMDTernary.type === binaryen.v128);

  console.log(theSIMDTernary.toText());
  assert(
    theSIMDTernary.toText()
    ==
    "(f64x2.qfma\n (v128.const i32x4 0x01010101 0x01010101 0x01010101 0x01010101)\n (v128.const i32x4 0x02020202 0x02020202 0x02020202 0x02020202)\n (v128.const i32x4 0x03030303 0x03030303 0x03030303 0x03030303)\n)\n"
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

  theSIMDShift.op = op = binaryen.Operations.ShrSVecI8x16;
  assert(theSIMDShift.op === op);
  theSIMDShift.vec = vec = module.v128.const([1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]);
  assert(theSIMDShift.vec === vec);
  theSIMDShift.shift = shift = module.i32.const(2);
  assert(theSIMDShift.shift === shift);
  theSIMDShift.type = binaryen.f64;
  theSIMDShift.finalize();
  assert(theSIMDShift.type === binaryen.v128);

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

  var op = binaryen.Operations.LoadExtSVec8x8ToVecI16x8;
  var offset = 16;
  var align = 2;
  var ptr = module.i32.const(1);
  const theSIMDLoad = binaryen.SIMDLoad(module.i16x8.load8x8_s(offset, align, ptr));
  assert(theSIMDLoad instanceof binaryen.SIMDLoad);
  assert(theSIMDLoad instanceof binaryen.Expression);
  assert(theSIMDLoad.offset === offset);
  assert(theSIMDLoad.align === align);
  assert(theSIMDLoad.ptr === ptr);
  assert(theSIMDLoad.type === binaryen.v128);

  theSIMDLoad.op = op = binaryen.Operations.LoadSplatVec8x16;
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

  console.log(theSIMDLoad.toText());
  assert(
    theSIMDLoad.toText()
    ==
    "(v8x16.load_splat offset=32 align=4\n (i32.const 2)\n)\n"
  );

  module.dispose();
})();

console.log("# MemoryInit");
(function testMemoryInit() {
  const module = new binaryen.Module();

  var segment = 1;
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

  theMemoryInit.segment = segment = 5;
  assert(theMemoryInit.segment === 5);
  theMemoryInit.dest = dest = module.i32.const(6);
  assert(theMemoryInit.dest === dest);
  theMemoryInit.offset = offset = module.i32.const(7);
  assert(theMemoryInit.offset === offset);
  theMemoryInit.size = size = module.i32.const(8);
  assert(theMemoryInit.size === size);
  theMemoryInit.type = binaryen.f64;
  theMemoryInit.finalize();
  assert(theMemoryInit.type === binaryen.none);

  console.log(theMemoryInit.toText());
  assert(
    theMemoryInit.toText()
    ==
    "(memory.init 5\n (i32.const 6)\n (i32.const 7)\n (i32.const 8)\n)\n"
  );

  module.dispose();
})();

console.log("# DataDrop");
(function testDataDrop() {
  const module = new binaryen.Module();

  var segment = 1;
  const theDataDrop = binaryen.DataDrop(module.data.drop(segment));
  assert(theDataDrop instanceof binaryen.DataDrop);
  assert(theDataDrop instanceof binaryen.Expression);
  assert(theDataDrop.segment === segment);
  assert(theDataDrop.type === binaryen.none);

  theDataDrop.segment = segment = 2;
  assert(theDataDrop.segment === 2);
  theDataDrop.type = binaryen.f64;
  theDataDrop.finalize();
  assert(theDataDrop.type === binaryen.none);

  console.log(theDataDrop.toText());
  assert(
    theDataDrop.toText()
    ==
    "(data.drop 2)\n"
  );

  module.dispose();
})();

console.log("# MemoryCopy");
(function testMemoryCopy() {
  const module = new binaryen.Module();

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

  theMemoryCopy.dest = dest = module.i32.const(4);
  assert(theMemoryCopy.dest === dest);
  theMemoryCopy.source = source = module.i32.const(5);
  assert(theMemoryCopy.source === source);
  theMemoryCopy.size = size = module.i32.const(6);
  assert(theMemoryCopy.size === size);
  theMemoryCopy.type = binaryen.f64;
  theMemoryCopy.finalize();
  assert(theMemoryCopy.type === binaryen.none);

  console.log(theMemoryCopy.toText());
  assert(
    theMemoryCopy.toText()
    ==
    "(memory.copy\n (i32.const 4)\n (i32.const 5)\n (i32.const 6)\n)\n"
  );

  module.dispose();
})();

console.log("# MemoryFill");
(function testMemoryFill() {
  const module = new binaryen.Module();

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

  theMemoryFill.dest = dest = module.i32.const(4);
  assert(theMemoryFill.dest === dest);
  theMemoryFill.value = value = module.i32.const(5);
  assert(theMemoryFill.value === value);
  theMemoryFill.size = size = module.i32.const(6);
  assert(theMemoryFill.size === size);
  theMemoryFill.type = binaryen.f64;
  theMemoryFill.finalize();
  assert(theMemoryFill.type === binaryen.none);

  console.log(theMemoryFill.toText());
  assert(
    theMemoryFill.toText()
    ==
    "(memory.fill\n (i32.const 4)\n (i32.const 5)\n (i32.const 6)\n)\n"
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

  theRefIsNull.value = value = module.local.get(2, binaryen.externref);
  assert(theRefIsNull.value === value);
  theRefIsNull.type = binaryen.f64;
  theRefIsNull.finalize();
  assert(theRefIsNull.type === binaryen.i32);

  console.log(theRefIsNull.toText());
  assert(
    theRefIsNull.toText()
    ==
    "(ref.is_null\n (local.get $2)\n)\n"
  );

  module.dispose();
})();

console.log("# RefFunc");
(function testRefFunc() {
  const module = new binaryen.Module();

  var func = "a";
  const theRefFunc = binaryen.RefFunc(module.ref.func(func));
  assert(theRefFunc instanceof binaryen.RefFunc);
  assert(theRefFunc instanceof binaryen.Expression);
  assert(theRefFunc.func === func);
  assert(theRefFunc.type === binaryen.funcref);

  theRefFunc.func = func = "b";
  assert(theRefFunc.func === func);
  theRefFunc.type = binaryen.f64;
  theRefFunc.finalize();
  assert(theRefFunc.type === binaryen.funcref);

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

  theRefEq.left = left = module.local.get(2, binaryen.eqref);
  assert(theRefEq.left === left);
  theRefEq.right = right = module.local.get(3, binaryen.eqref);
  assert(theRefEq.right === right);
  theRefEq.type = binaryen.f64;
  theRefEq.finalize();
  assert(theRefEq.type === binaryen.i32);

  console.log(theRefEq.toText());
  assert(
    theRefEq.toText()
    ==
    "(ref.eq\n (local.get $2)\n (local.get $3)\n)\n"
  );

  module.dispose();
})();

console.log("# Try");
(function testTry() {
  const module = new binaryen.Module();

  var body = module.i32.const(1);
  var catchBody = module.i32.const(2);
  const theTry = binaryen.Try(module.try(body, catchBody));
  assert(theTry instanceof binaryen.Try);
  assert(theTry instanceof binaryen.Expression);
  assert(theTry.body === body);
  assert(theTry.catchBody === catchBody);
  assert(theTry.type === binaryen.i32);

  theTry.body = body = module.i32.const(3);
  assert(theTry.body === body);
  theTry.catchBody = catchBody = module.i32.const(4);
  assert(theTry.catchBody === catchBody);
  theTry.type = binaryen.f64;
  theTry.finalize();
  assert(theTry.type === binaryen.i32);

  console.log(theTry.toText());
  assert(
    theTry.toText()
    ==
    "(try (result i32)\n (do\n  (i32.const 3)\n )\n (catch\n  (i32.const 4)\n )\n)\n"
  );

  module.dispose();
})();

console.log("# Throw");
(function testThrow() {
  const module = new binaryen.Module();

  var event = "foo";
  var operands = [
    module.i32.const(1),
    module.i32.const(2)
  ];
  const theThrow = binaryen.Throw(module.throw(event, operands));
  assert(theThrow instanceof binaryen.Throw);
  assert(theThrow instanceof binaryen.Expression);
  assert(theThrow.event === event);
  assertDeepEqual(theThrow.operands, operands);
  assert(theThrow.type === binaryen.unreachable);

  theThrow.event = "bar";
  assert(theThrow.event === "bar");
  theThrow.operands = operands = [
    module.i32.const(3), // set
    module.i32.const(4), // set
    module.i32.const(5)  // append
  ];
  assertDeepEqual(theThrow.operands, operands);
  theThrow.operands = operands = [
    module.i32.const(6) // set
    // remove
    // remove
  ];
  assertDeepEqual(theThrow.operands, operands);
  theThrow.insertOperandAt(1, module.i32.const(7));
  theThrow.type = binaryen.f64;
  theThrow.finalize();
  assert(theThrow.type === binaryen.unreachable);

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

  var exnref = module.local.get(1, binaryen.exnref);
  const theRethrow = binaryen.Rethrow(module.rethrow(exnref));
  assert(theRethrow instanceof binaryen.Rethrow);
  assert(theRethrow instanceof binaryen.Expression);
  assert(theRethrow.exnref === exnref);
  assert(theRethrow.type === binaryen.unreachable);

  theRethrow.exnref = exnref = module.local.get(2, binaryen.exnref);
  assert(theRethrow.exnref === exnref);
  theRethrow.type = binaryen.f64;
  theRethrow.finalize();
  assert(theRethrow.type === binaryen.unreachable);

  console.log(theRethrow.toText());
  assert(
    theRethrow.toText()
    ==
    "(rethrow\n (local.get $2)\n)\n"
  );

  module.dispose();
})();

console.log("# BrOnExn");
(function testBrOnExn() {
  const module = new binaryen.Module();
  module.addEvent("event1", 0, binaryen.none, binaryen.none);
  module.addEvent("event2", 0, binaryen.none, binaryen.none);

  var name = "foo";
  var event = "event1";
  var exnref = module.local.get(1, binaryen.exnref);
  const theBrOnExn = binaryen.BrOnExn(module.br_on_exn(name, event, exnref));
  assert(theBrOnExn instanceof binaryen.BrOnExn);
  assert(theBrOnExn instanceof binaryen.Expression);
  assert(theBrOnExn.name === name);
  assert(theBrOnExn.event === event);
  assert(theBrOnExn.exnref === exnref);
  assert(theBrOnExn.type === binaryen.exnref);

  theBrOnExn.name = name = "bar";
  assert(theBrOnExn.name === name);
  theBrOnExn.event = event = "event2";
  assert(theBrOnExn.event === event);
  theBrOnExn.exnref = exnref = module.local.get(2, binaryen.exnref);
  assert(theBrOnExn.exnref === exnref);
  theBrOnExn.type = binaryen.f64;
  theBrOnExn.finalize();
  assert(theBrOnExn.type === binaryen.exnref);

  console.log(theBrOnExn.toText());
  assert(
    theBrOnExn.toText()
    ==
    "(br_on_exn $bar $event2\n (local.get $2)\n)\n"
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

  theTupleMake.operands = operands = [
    module.i32.const(3), // set
    module.i32.const(4), // set
    module.i32.const(5)  // append
  ];
  assertDeepEqual(theTupleMake.operands, operands);
  theTupleMake.operands = operands = [
    module.i32.const(6) // set
    // remove
    // remove
  ];
  assertDeepEqual(theTupleMake.operands, operands);
  theTupleMake.insertOperandAt(1, module.i32.const(7));
  theTupleMake.type = binaryen.f64;
  theTupleMake.finalize();
  assert(theTupleMake.type === type);

  console.log(theTupleMake.toText());
  assert(
    theTupleMake.toText()
    ==
    "(tuple.make\n (i32.const 6)\n (i32.const 7)\n)\n"
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

  console.log(theTupleExtract.toText());
  assert(
    theTupleExtract.toText()
    ==
    "(tuple.extract 0\n (tuple.make\n  (f64.const 3)\n  (f64.const 4)\n )\n)\n"
  );

  module.dispose();
})();

console.log("# I31New");
(function testI31New() {
  const module = new binaryen.Module();

  var value = module.local.get(1, binaryen.i32);
  const theI31New = binaryen.I31New(module.i31.new(value));
  assert(theI31New instanceof binaryen.I31New);
  assert(theI31New instanceof binaryen.Expression);
  assert(theI31New.value === value);
  assert(theI31New.type === binaryen.i31ref);

  theI31New.value = value = module.local.get(2, binaryen.i32);
  assert(theI31New.value === value);
  theI31New.type = binaryen.f64;
  theI31New.finalize();
  assert(theI31New.type === binaryen.i31ref);

  console.log(theI31New.toText());
  assert(
    theI31New.toText()
    ==
    "(i31.new\n (local.get $2)\n)\n"
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

  theI31Get.i31 = i31 = module.local.get(2, binaryen.i31ref);
  assert(theI31Get.i31 === i31);
  theI31Get.signed = false;
  assert(theI31Get.signed === false);
  theI31Get.type = binaryen.f64;
  theI31Get.finalize();
  assert(theI31Get.type === binaryen.i32);

  console.log(theI31Get.toText());
  assert(
    theI31Get.toText()
    ==
    "(i31.get_u\n (local.get $2)\n)\n"
  );

  module.dispose();
})();
