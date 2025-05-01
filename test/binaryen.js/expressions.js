function assertEq(x, y) {
  if (typeof x === "object") {
    if (x instanceof binaryen.Expression)
      return +x === +y;
    for (let i in x) assertEq(x[i], y[i]);
    for (let i in y) assertEq(x[i], y[i]);
  } else {
    assert(x === y);
  }
}

console.log("# Expression");
(function testWrapper() {
  const module = new binaryen.Module();

  const ptr = module.block(null, []);

  var theExpression = ptr;
  assert(theExpression instanceof binaryen.Block);
  assert(theExpression instanceof binaryen.Expression);
  assert(theExpression.constructor === binaryen.Block);
  assert(typeof binaryen.Block.getId === "function"); // proto
  assert(typeof binaryen.Block.getName === "function"); // own
  assert(typeof theExpression.getId === "function"); // proto
  assert(typeof theExpression.getName === "function"); // own

  module.dispose();
})();

console.log("# Block");
(function testBlock() {
  const module = new binaryen.Module();

  const theBlock = module.block(null, []);
  assert(theBlock instanceof binaryen.Block);
  assert(theBlock instanceof binaryen.Expression);
  assertEq(theBlock.id, binaryen.BlockId);
  assertEq(theBlock.name, null);
  assertEq(theBlock.type, binaryen.none);
  
  var info = binaryen.getExpressionInfo(theBlock);
  assertEq(info.id, theBlock.id);
  assertEq(info.type, theBlock.type);
  assertEq(info.name, theBlock.name);
  assertEq(info.children, theBlock.children);

  theBlock.name ="theName";
  assertEq(theBlock.name, "theName");
  theBlock.type = binaryen.i32;
  assertEq(theBlock.type, binaryen.i32);
  assertEq(theBlock.numChildren, 0);
  assertEq(theBlock.children, []);
  assertEq(theBlock.getChildren(), []);

  var child1 = module.i32.const(1);
  theBlock.appendChild(child1);
  assertEq(theBlock.numChildren, 1);
  assertEq(theBlock.getChildAt(0), child1);
  var child2 = module.i32.const(2);
  theBlock.insertChildAt(1, child2);
  assertEq(theBlock.numChildren, 2);
  assertEq(theBlock.getChildAt(0), child1);
  assertEq(theBlock.getChildAt(1), child2);
  var child0 = module.i32.const(0);
  theBlock.insertChildAt(0, child0);
  assertEq(theBlock.numChildren, 3);
  assertEq(theBlock.getChildAt(0), child0);
  assertEq(theBlock.getChildAt(1), child1);
  assertEq(theBlock.getChildAt(2), child2);
  var newChild1 = module.i32.const(11);
  theBlock.setChildAt(1, newChild1);
  assertEq(theBlock.numChildren, 3);
  assertEq(theBlock.getChildAt(0), child0);
  assertEq(theBlock.getChildAt(1), newChild1);
  assertEq(theBlock.getChildAt(2), child2);
  theBlock.removeChildAt(1);
  assertEq(theBlock.numChildren, 2);
  assertEq(theBlock.getChildAt(0), child0);
  assertEq(theBlock.getChildAt(1), child2);
  theBlock.removeChildAt(1);
  assertEq(theBlock.numChildren, 1);
  assertEq(theBlock.getChildAt(0), child0);
  theBlock.finalize();

  info = binaryen.getExpressionInfo(theBlock);
  assertEq(info.name, theBlock.name);
  assertEq(info.children, theBlock.children);

  console.log(theBlock.toText());
  assert(
    theBlock.toText()
    ==
    "(block $theName (result i32)\n (i32.const 0)\n)\n"
  );
  theBlock.removeChildAt(0);
  assertEq(theBlock.numChildren, 0);

  module.dispose();
})();

console.log("# If");
(function testIf() {
  const module = new binaryen.Module();

  var condition = module.i32.const(1);
  var ifTrue = module.i32.const(2);
  var ifFalse = module.i32.const(3);
  const theIf = module.if(condition, ifTrue, ifFalse);
  assert(theIf instanceof binaryen.If);
  assert(theIf instanceof binaryen.Expression);
  assertEq(theIf.id, binaryen.IfId);
  assertEq(theIf.condition, condition);
  assertEq(theIf.ifTrue, ifTrue);
  assertEq(theIf.ifFalse, ifFalse);
  assert(theIf.type == binaryen.i32);

  var info = binaryen.getExpressionInfo(theIf);
  assertEq(info.id, theIf.id);
  assertEq(info.type, theIf.type);
  assertEq(info.condition, theIf.condition);
  assertEq(info.ifTrue, theIf.ifTrue);
  assertEq(info.ifFalse, theIf.ifFalse);

  theIf.condition = condition = module.i32.const(4);
  assertEq(theIf.condition, condition);
  theIf.ifTrue = ifTrue = module.i32.const(5);
  assertEq(theIf.ifTrue, ifTrue);
  theIf.ifFalse = ifFalse = module.i32.const(6);
  assertEq(theIf.ifFalse, ifFalse);
  theIf.finalize();

  info = binaryen.getExpressionInfo(theIf);
  assertEq(info.condition, theIf.condition);
  assertEq(info.ifTrue, theIf.ifTrue);
  assertEq(info.ifFalse, theIf.ifFalse);

  console.log(theIf.toText());
  assert(
    theIf.toText()
    ==
        "(if (result i32)\n (i32.const 4)\n (then\n  (i32.const 5)\n )\n (else\n  (i32.const 6)\n )\n)\n"
  );

  theIf.ifFalse = null;
  assert(!theIf.ifFalse);

  info = binaryen.getExpressionInfo(theIf);
  assertEq(info.ifFalse, theIf.ifFalse);

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
  const theLoop = module.loop(name, body);
  assert(theLoop instanceof binaryen.Loop);
  assert(theLoop instanceof binaryen.Expression);
  assertEq(theLoop.id, binaryen.LoopId);
  assertEq(theLoop.name, name);
  assertEq(theLoop.body, body);
  assertEq(theLoop.type, binaryen.i32);

  var info = binaryen.getExpressionInfo(theLoop);
  assertEq(info.id, theLoop.id);
  assertEq(info.type, theLoop.type);
  assertEq(info.name, theLoop.name);
  assertEq(info.body, theLoop.body);

  theLoop.name = name = "theName";
  assertEq(theLoop.name, name);
  theLoop.body = body = module.drop(body);
  assertEq(theLoop.body, body);
  theLoop.finalize();
  console.log(theLoop.type === binaryen.i32);
  assertEq(theLoop.type, binaryen.none);

  info = binaryen.getExpressionInfo(theLoop);
  assertEq(info.type, theLoop.type);
  assertEq(info.name, theLoop.name);
  assertEq(info.body, theLoop.body);

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
  const theBreak = module.br(name, condition, value);
  assert(theBreak instanceof binaryen.Break);
  assert(theBreak instanceof binaryen.Expression);
  assertEq(theBreak.name, name);
  assertEq(theBreak.condition, condition);
  assertEq(theBreak.value, value);
  assertEq(theBreak.type, binaryen.i32);

  var info = binaryen.getExpressionInfo(theBreak);
  assertEq(info.id, theBreak.id);
  assertEq(info.type, theBreak.type);
  assertEq(info.name, theBreak.name);
  assertEq(info.condition, theBreak.condition);
  assertEq(info.value, theBreak.value);

  theBreak.name = name = "theNewName";
  assertEq(theBreak.name, "theNewName");
  theBreak.condition = condition = module.i32.const(3);
  assertEq(theBreak.condition, condition);
  theBreak.value = value = module.i32.const(4);
  assertEq(theBreak.value, value);
  theBreak.finalize();

  info = binaryen.getExpressionInfo(theBreak);
  assertEq(info.name, theBreak.name);
  assertEq(info.condition, theBreak.condition);
  assertEq(info.value, theBreak.value);

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
  const theSwitch = module.switch(names, defaultName, condition, value);
  assert(theSwitch instanceof binaryen.Switch);
  assert(theSwitch instanceof binaryen.Expression);
  assertEq(theSwitch.numNames, 2);
  assertEq(theSwitch.names, names);
  assertEq(theSwitch.defaultName, defaultName);
  assertEq(theSwitch.condition, condition);
  assertEq(theSwitch.value, value);
  assertEq(theSwitch.type, binaryen.unreachable);

  var info = binaryen.getExpressionInfo(theSwitch);
  assertEq(info.id, theSwitch.id);
  assertEq(info.type, theSwitch.type);
  assertEq(info.names, theSwitch.names);
  assertEq(info.defaultName, theSwitch.defaultName);
  assertEq(info.condition, theSwitch.condition);
  assertEq(info.value, theSwitch.value);

  names = [
    "1", // set
    "2", //set
    "3" // append
  ]
  theSwitch.setNames(names);
  assertEq(theSwitch.names, names);
  theSwitch.names = names = [
    "x", // set
    // remove
    // remove
  ];
  assertEq(theSwitch.names, names);
  assertEq(theSwitch.getNames(), names);
  theSwitch.insertNameAt(1, "y");
  theSwitch.condition = condition = module.i32.const(3);
  assertEq(theSwitch.condition, condition);
  theSwitch.value = value = module.i32.const(4);
  assertEq(theSwitch.value, value);
  theSwitch.finalize();

  info = binaryen.getExpressionInfo(theSwitch);
  assertEq(info.names, theSwitch.names);
  assertEq(info.defaultName, theSwitch.defaultName);
  assertEq(info.condition, theSwitch.condition);
  assertEq(info.value, theSwitch.value);

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
  const theCall = module.call(target, operands, binaryen.i32);
  assert(theCall instanceof binaryen.Call);
  assert(theCall instanceof binaryen.Expression);
  assertEq(theCall.target, target);
  assertEq(theCall.operands, operands);
  assertEq(theCall.getOperands(), operands);
  assertEq(theCall.return, false);
  assertEq(theCall.type, binaryen.i32);

  var info = binaryen.getExpressionInfo(theCall);
  assertEq(info.id, theCall.id);
  assertEq(info.type, theCall.type);
  assertEq(info.target, theCall.target);
  assertEq(info.operands, theCall.operands);
  assertEq(info.isReturn, theCall.return);

  theCall.target = "bar";
  assertEq(theCall.target, "bar");
  theCall.operands = operands = [
    module.i32.const(3), // set
    module.i32.const(4), // set
    module.i32.const(5)  // append
  ];
  assertEq(theCall.operands, operands);
  operands = [
    module.i32.const(6) // set
    // remove
    // remove
  ];
  theCall.setOperands(operands);
  assertEq(theCall.operands, operands);
  theCall.insertOperandAt(0, module.i32.const(7));
  theCall.return = true;
  assertEq(theCall.return, true);
  theCall.finalize();
  assertEq(theCall.type, binaryen.unreachable); // finalized tail call

  info = binaryen.getExpressionInfo(theCall);
  assertEq(info.type, theCall.type);
  assertEq(info.target, theCall.target);
  assertEq(info.operands, theCall.operands);
  assertEq(info.isReturn, theCall.return);

  theCall.return = false;
  theCall.type = binaryen.i32;
  theCall.finalize();
  assertEq(theCall.type, binaryen.i32); // finalized call

  info = binaryen.getExpressionInfo(theCall);
  assertEq(info.type, theCall.type);
  assertEq(info.isReturn, theCall.return);

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
  const theCallIndirect = module.call_indirect(table, target, operands, params, results);
  assert(theCallIndirect instanceof binaryen.CallIndirect);
  assert(theCallIndirect instanceof binaryen.Expression);
  assertEq(theCallIndirect.table, table);
  assertEq(theCallIndirect.target, target);
  assertEq(theCallIndirect.operands, operands);
  assertEq(theCallIndirect.params, params);
  assertEq(theCallIndirect.results, results);
  assertEq(theCallIndirect.return, false);
  assertEq(theCallIndirect.type, theCallIndirect.results);

  var info = binaryen.getExpressionInfo(theCallIndirect);
  assertEq(info.id, theCallIndirect.id);
  assertEq(info.type, theCallIndirect.type);
  assertEq(info.table, theCallIndirect.table);
  assertEq(info.target, theCallIndirect.target);
  assertEq(info.operands, theCallIndirect.operands);
  assertEq(info.params, theCallIndirect.params);
  assertEq(info.results, theCallIndirect.results);
  assertEq(info.isReturn, theCallIndirect.return);

  theCallIndirect.target = target = module.i32.const(9000);
  assertEq(theCallIndirect.target, target);
  theCallIndirect.operands = operands = [
    module.i32.const(3), // set
    module.i32.const(4), // set
    module.i32.const(5)  // append
  ];
  assertEq(theCallIndirect.operands, operands);
  operands = [
    module.i32.const(6) // set
    // remove
    // remove
  ];
  theCallIndirect.setOperands(operands);
  assertEq(theCallIndirect.operands, operands);
  assertEq(theCallIndirect.getOperands(), operands);
  theCallIndirect.insertOperandAt(0, module.i32.const(7));
  theCallIndirect.return = true;
  assertEq(theCallIndirect.return, true);
  theCallIndirect.params = params = binaryen.createType([ binaryen.i32, binaryen.i32 ]);
  assertEq(theCallIndirect.params, params);
  theCallIndirect.results = results = binaryen.i32;
  assertEq(theCallIndirect.results, results);
  theCallIndirect.finalize();
  assertEq(theCallIndirect.type, binaryen.unreachable); // finalized tail call

  info = binaryen.getExpressionInfo(theCallIndirect);
  assertEq(info.type, theCallIndirect.type);
  assertEq(info.target, theCallIndirect.target);
  assertEq(info.operands, theCallIndirect.operands);
  assertEq(info.params, theCallIndirect.params);
  assertEq(info.results, theCallIndirect.results);
  assertEq(info.isReturn, theCallIndirect.return);

  theCallIndirect.return = false;
  theCallIndirect.finalize();
  assertEq(theCallIndirect.type, results); // finalized call

  info = binaryen.getExpressionInfo(theCallIndirect);
  assertEq(info.isReturn, theCallIndirect.return);

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
  const theLocalGet = module.local.get(index, type);
  assert(theLocalGet instanceof binaryen.LocalGet);
  assert(theLocalGet instanceof binaryen.Expression);
  assertEq(theLocalGet.index, index);
  assertEq(theLocalGet.type, type);

  var info = binaryen.getExpressionInfo(theLocalGet);
  assertEq(info.id, theLocalGet.id);
  assertEq(info.type, theLocalGet.type);
  assertEq(info.index, theLocalGet.index);

  theLocalGet.index = index = 2;
  assertEq(theLocalGet.index, index);
  theLocalGet.type = type = binaryen.f64;
  assertEq(theLocalGet.type, type);
  theLocalGet.finalize();

  info = binaryen.getExpressionInfo(theLocalGet);
  assertEq(info.type, theLocalGet.type);
  assertEq(info.index, theLocalGet.index);

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
  const theLocalSet = module.local.set(index, value);
  assert(theLocalSet instanceof binaryen.LocalSet);
  assert(theLocalSet instanceof binaryen.Expression);
  assertEq(theLocalSet.index, index);
  assertEq(theLocalSet.value, value);
  assertEq(theLocalSet.tee, false);
  assert(theLocalSet.type == binaryen.none);

  var info = binaryen.getExpressionInfo(theLocalSet);
  assertEq(info.id, theLocalSet.id);
  assertEq(info.type, theLocalSet.type);
  assertEq(info.index, theLocalSet.index);
  assertEq(info.value, theLocalSet.value);
  assertEq(info.isTee, theLocalSet.tee)

  theLocalSet.index = index = 2;
  assertEq(theLocalSet.index, index);
  theLocalSet.value = value = module.i32.const(3);
  assertEq(theLocalSet.value, value);
  theLocalSet.type = binaryen.i32;
  assertEq(theLocalSet.type, binaryen.i32);
  assertEq(theLocalSet.tee, true);
  theLocalSet.type = binaryen.none;
  theLocalSet.finalize();

  info = binaryen.getExpressionInfo(theLocalSet);
  assertEq(info.type, theLocalSet.type);
  assertEq(info.index, theLocalSet.index);
  assertEq(info.value, theLocalSet.value);
  assertEq(info.isTee, theLocalSet.tee)

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
  const theGlobalGet = module.global.get(name, type);
  assert(theGlobalGet instanceof binaryen.GlobalGet);
  assert(theGlobalGet instanceof binaryen.Expression);
  assertEq(theGlobalGet.name, name);
  assertEq(theGlobalGet.type, type);

  var info = binaryen.getExpressionInfo(theGlobalGet);
  assertEq(info.id, theGlobalGet.id);
  assertEq(info.type, theGlobalGet.type);
  assertEq(info.name, theGlobalGet.name);

  theGlobalGet.name = name = "b";
  assertEq(theGlobalGet.name, name);
  theGlobalGet.type = type = binaryen.f64;
  assertEq(theGlobalGet.type, type);
  theGlobalGet.finalize();

  info = binaryen.getExpressionInfo(theGlobalGet);
  assertEq(info.type, theGlobalGet.type);
  assertEq(info.name, theGlobalGet.name);

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
  const theGlobalSet = module.global.set(name, value);
  assert(theGlobalSet instanceof binaryen.GlobalSet);
  assert(theGlobalSet instanceof binaryen.Expression);
  assertEq(theGlobalSet.name, name);
  assertEq(theGlobalSet.value, value);
  assert(theGlobalSet.type == binaryen.none);

  var info = binaryen.getExpressionInfo(theGlobalSet);
  assertEq(info.id, theGlobalSet.id);
  assertEq(info.type, theGlobalSet.type);
  assertEq(info.name, theGlobalSet.name);
  assertEq(info.value, theGlobalSet.value);

  theGlobalSet.name = name = "b";
  assertEq(theGlobalSet.name, name);
  theGlobalSet.value = value = module.f64.const(3);
  assertEq(theGlobalSet.value, value);
  theGlobalSet.finalize();

  info = binaryen.getExpressionInfo(theGlobalSet);
  assertEq(info.name, theGlobalSet.name);
  assertEq(info.value, theGlobalSet.value);

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
  const theMemorySize = module.memory.size();
  assert(theMemorySize instanceof binaryen.MemorySize);
  assert(theMemorySize instanceof binaryen.Expression);
  assertEq(theMemorySize.type, type);
  theMemorySize.finalize();

  var info = binaryen.getExpressionInfo(theMemorySize);
  assertEq(info.id, theMemorySize.id);
  assertEq(info.type, theMemorySize.type);

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
  const theMemoryGrow = module.memory.grow(delta);
  assert(theMemoryGrow instanceof binaryen.MemoryGrow);
  assert(theMemoryGrow instanceof binaryen.Expression);
  assertEq(theMemoryGrow.delta, delta);
  assertEq(theMemoryGrow.type, type);

  var info = binaryen.getExpressionInfo(theMemoryGrow);
  assertEq(info.id, theMemoryGrow.id);
  assertEq(info.type, theMemoryGrow.type);
  assertEq(info.delta, theMemoryGrow.delta);

  theMemoryGrow.delta = delta = module.i32.const(2);
  assertEq(theMemoryGrow.delta, delta);
  theMemoryGrow.finalize();

  info = binaryen.getExpressionInfo(theMemoryGrow);
  assertEq(info.delta, theMemoryGrow.delta);

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
  const theLoad = module.i32.load(offset, align, ptr);
  assert(theLoad instanceof binaryen.Load);
  assert(theLoad instanceof binaryen.Expression);
  assertEq(theLoad.offset, offset);
  assertEq(theLoad.align, align);
  assertEq(theLoad.ptr, ptr);
  assertEq(theLoad.bytes, 4);
  assertEq(theLoad.signed, true);
  assertEq(theLoad.atomic, false);
  assert(theLoad.type == binaryen.i32);

  var info = binaryen.getExpressionInfo(theLoad);
  assertEq(info.id, theLoad.id);
  assertEq(info.type, theLoad.type);
  assertEq(info.offset, theLoad.offset);
  assertEq(info.align, theLoad.align);
  assertEq(info.ptr, theLoad.ptr);
  assertEq(info.bytes, theLoad.bytes);
  assertEq(info.isSigned, theLoad.signed);
  assertEq(info.isAtomic, theLoad.atomic);

  theLoad.offset = offset = 32;
  assertEq(theLoad.offset, offset);
  theLoad.align = align = 4;
  assertEq(theLoad.align, align);
  theLoad.ptr = ptr = module.i32.const(128);
  assertEq(theLoad.ptr, ptr);
  theLoad.type = binaryen.i64;
  assertEq(theLoad.type, binaryen.i64);
  theLoad.signed = false;
  assertEq(theLoad.signed, false);
  theLoad.bytes = 8;
  assertEq(theLoad.bytes, 8);
  theLoad.atomic = true;
  assertEq(theLoad.atomic, true);
  theLoad.finalize();
  assertEq(theLoad.align, 4);

  info = binaryen.getExpressionInfo(theLoad);
  assertEq(info.offset, theLoad.offset);
  assertEq(info.align, theLoad.align);
  assertEq(info.ptr, theLoad.ptr);
  assertEq(info.bytes, theLoad.bytes);
  assertEq(info.isSigned, theLoad.signed);
  assertEq(info.isAtomic, theLoad.atomic);

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
  const theStore = module.i32.store(offset, align, ptr, value);
  assert(theStore instanceof binaryen.Store);
  assert(theStore instanceof binaryen.Expression);
  assertEq(theStore.offset, offset);
  assertEq(theStore.align, align);
  assertEq(theStore.ptr, ptr);
  assertEq(theStore.value, value);
  assertEq(theStore.bytes, 4);
  assertEq(theStore.atomic, false);
  assertEq(theStore.valueType, binaryen.i32);
  assertEq(theStore.type, binaryen.none);

  var info = binaryen.getExpressionInfo(theStore);
  assertEq(info.id, theStore.id);
  assertEq(info.type, theStore.type);
  assertEq(info.offset, theStore.offset);
  assertEq(info.align, theStore.align);
  assertEq(info.ptr, theStore.ptr);
  assertEq(info.value, theStore.value);
  assertEq(info.bytes, theStore.bytes);
  assertEq(info.isAtomic, theStore.atomic);
  assertEq(info.valueType, theStore.valueType);

  theStore.offset = offset = 32;
  assertEq(theStore.offset, offset);
  theStore.align = align = 4;
  assertEq(theStore.align, align);
  theStore.ptr = ptr = module.i32.const(128);
  assertEq(theStore.ptr, ptr);
  theStore.value = value = module.i32.const(2);
  assertEq(theStore.value, value);
  theStore.signed = false;
  assertEq(theStore.signed, false);
  theStore.valueType = binaryen.i64;
  assertEq(theStore.valueType, binaryen.i64);
  theStore.bytes = 8;
  assertEq(theStore.bytes, 8);
  theStore.atomic = true;
  assertEq(theStore.atomic, true);
  theStore.finalize();
  assertEq(theStore.align, 4);

  info = binaryen.getExpressionInfo(theStore);
  assertEq(info.offset, theStore.offset);
  assertEq(info.align, theStore.align);
  assertEq(info.ptr, theStore.ptr);
  assertEq(info.value, theStore.value);
  assertEq(info.bytes, theStore.bytes);
  assertEq(info.isAtomic, theStore.atomic);
  assertEq(info.valueType, theStore.valueType);

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

  const theConst = module.i32.const(1);
  assert(theConst instanceof binaryen.Const);
  assert(theConst instanceof binaryen.Expression);
  assertEq(theConst.valueI32, 1);
  theConst.valueI32 = 2;
  assertEq(theConst.valueI32, 2);
  assertEq(theConst.type, binaryen.i32);

  var info = binaryen.getExpressionInfo(theConst);
  assertEq(info.id, theConst.id);
  assertEq(info.type, theConst.type);
  assertEq(info.value, theConst.valueI32);

  theConst.valueI64Low = 3;
  assertEq(theConst.valueI64Low, 3);
  theConst.valueI64High = 4;
  assertEq(theConst.valueI64High, 4);
  theConst.finalize();
  assert(theConst.type == binaryen.i64);

  info = binaryen.getExpressionInfo(theConst);
  assertEq(info.type, theConst.type);
  assertEq(info.value.low, theConst.valueI64Low);
  assertEq(info.value.high, theConst.valueI64High);

  theConst.valueF32 = 5;
  assertEq(theConst.valueF32, 5);
  theConst.finalize();
  assertEq(theConst.type, binaryen.f32);

  info = binaryen.getExpressionInfo(theConst);
  assertEq(info.type, theConst.type);
  assertEq(info.value, theConst.valueF32);

  theConst.valueF64 = 6;
  assertEq(theConst.valueF64, 6);
  theConst.finalize();
  assertEq(theConst.type, binaryen.f64);

  info = binaryen.getExpressionInfo(theConst);
  assertEq(info.type, theConst.type);
  assertEq(info.value, theConst.valueF64);

  theConst.valueV128 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];
  assertEq(theConst.valueV128, [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]);
  theConst.finalize();
  assertEq(theConst.type, binaryen.v128);

  info = binaryen.getExpressionInfo(theConst);
  assertEq(info.type, theConst.type);
  assertEq(info.value, theConst.valueV128);

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
  const theUnary = module.i32.eqz(value);
  assert(theUnary instanceof binaryen.Unary);
  assert(theUnary instanceof binaryen.Expression);
  assertEq(theUnary.op, op);
  assertEq(theUnary.value, value);
  assertEq(theUnary.type, binaryen.i32);

  var info = binaryen.getExpressionInfo(theUnary);
  assertEq(info.id, theUnary.id);
  assertEq(info.type, theUnary.type);
  assertEq(info.op, theUnary.op);
  assertEq(info.value, theUnary.value);

  theUnary.op = op = binaryen.Operations.EqZInt64;
  assertEq(theUnary.op, op);
  theUnary.value = value = module.i64.const(2);
  assertEq(theUnary.value, value);
  theUnary.type = binaryen.f32;
  theUnary.finalize();
  assertEq(theUnary.type, binaryen.i32);

  info = binaryen.getExpressionInfo(theUnary);
  assertEq(info.type, theUnary.type);
  assertEq(info.op, theUnary.op);
  assertEq(info.value, theUnary.value);

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
  const theBinary = module.i32.add(left, right);
  assert(theBinary instanceof binaryen.Binary);
  assert(theBinary instanceof binaryen.Expression);
  assertEq(theBinary.op, op);
  assertEq(theBinary.left, left);
  assertEq(theBinary.right, right);
  assertEq(theBinary.type, binaryen.i32)

  var info = binaryen.getExpressionInfo(theBinary);
  assertEq(info.id, theBinary.id);
  assertEq(info.type, theBinary.type);
  assertEq(info.op, theBinary.op);
  assertEq(info.left, theBinary.left);
  assertEq(info.right, theBinary.right);

  theBinary.op = op = binaryen.Operations.AddInt64;
  assertEq(theBinary.op, op);
  theBinary.left = left = module.i64.const(3);
  assertEq(theBinary.left, left);
  theBinary.right = right = module.i64.const(4);
  assertEq(theBinary.right, right);
  theBinary.type = binaryen.f32;
  theBinary.finalize();
  assertEq(theBinary.type, binaryen.i64);

  info = binaryen.getExpressionInfo(theBinary);
  assertEq(info.type, theBinary.type);
  assertEq(info.op, theBinary.op);
  assertEq(info.left, theBinary.left);
  assertEq(info.right, theBinary.right);

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
  const theSelect = module.select(condition, ifTrue, ifFalse);
  assert(theSelect instanceof binaryen.Select);
  assert(theSelect instanceof binaryen.Expression);
  assertEq(theSelect.condition, condition);
  assertEq(theSelect.ifTrue, ifTrue);
  assertEq(theSelect.ifFalse, ifFalse);
  assertEq(theSelect.type, binaryen.i32);

  var info = binaryen.getExpressionInfo(theSelect);
  assertEq(info.id, theSelect.id);
  assertEq(info.type, theSelect.type);
  assertEq(info.condition, theSelect.condition);
  assertEq(info.ifTrue, theSelect.ifTrue);
  assertEq(info.ifFalse, theSelect.ifFalse);

  theSelect.condition = condition = module.i32.const(4);
  assertEq(theSelect.condition, condition);
  theSelect.ifTrue = ifTrue = module.i64.const(5);
  assertEq(theSelect.ifTrue, ifTrue);
  theSelect.ifFalse = ifFalse = module.i64.const(6);
  assertEq(theSelect.ifFalse, ifFalse);
  theSelect.finalize();
  assertEq(theSelect.type, binaryen.i64);

  info = binaryen.getExpressionInfo(theSelect);
  assertEq(info.type, theSelect.type);
  assertEq(info.condition, theSelect.condition);
  assertEq(info.ifTrue, theSelect.ifTrue);
  assertEq(info.ifFalse, theSelect.ifFalse);

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
  const theDrop = module.drop(value);
  assert(theDrop instanceof binaryen.Drop);
  assert(theDrop instanceof binaryen.Expression);
  assertEq(theDrop.value, value);
  assertEq(theDrop.type, binaryen.none);

  var info = binaryen.getExpressionInfo(theDrop);
  assertEq(info.id, theDrop.id);
  assertEq(info.type, theDrop.type);
  assertEq(info.value, theDrop.value);

  theDrop.value = value = module.i32.const(2);
  assertEq(theDrop.value, value);

  theDrop.finalize();
  assertEq(theDrop.type, binaryen.none);

  info = binaryen.getExpressionInfo(theDrop);
  assertEq(info.type, theDrop.type);
  assertEq(info.value, theDrop.value);

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
  const theReturn = module.return(value);
  assert(theReturn instanceof binaryen.Return);
  assert(theReturn instanceof binaryen.Expression);
  assertEq(theReturn.value, value);
  assertEq(theReturn.type, binaryen.unreachable);

  var info = binaryen.getExpressionInfo(theReturn);
  assertEq(info.id, theReturn.id);
  assertEq(info.type, theReturn.type);
  assertEq(info.value, theReturn.value);

  theReturn.value = value = module.i32.const(2);
  assertEq(theReturn.value, value);

  theReturn.finalize();
  assertEq(theReturn.type, binaryen.unreachable);

  info = binaryen.getExpressionInfo(theReturn);
  assertEq(info.type, theReturn.type);
  assertEq(info.value, theReturn.value);

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
  const theAtomicRMW = module.i32.atomic.rmw.add(offset, ptr, value);
  assert(theAtomicRMW instanceof binaryen.AtomicRMW);
  assert(theAtomicRMW instanceof binaryen.Expression);
  assertEq(theAtomicRMW.op, op);
  assertEq(theAtomicRMW.bytes, 4);
  assertEq(theAtomicRMW.offset, offset);
  assertEq(theAtomicRMW.ptr, ptr);
  assertEq(theAtomicRMW.value, value);
  assertEq(theAtomicRMW.type, binaryen.i32);

  var info = binaryen.getExpressionInfo(theAtomicRMW);
  assertEq(info.id, theAtomicRMW.id);
  assertEq(info.type, theAtomicRMW.type);
  assertEq(info.op, theAtomicRMW.op);
  assertEq(info.bytes, theAtomicRMW.bytes);
  assertEq(info.offset, theAtomicRMW.offset);
  assertEq(info.ptr, theAtomicRMW.ptr);
  assertEq(info.value, theAtomicRMW.value);

  theAtomicRMW.op = op = binaryen.Operations.AtomicRMWSub;
  assertEq(theAtomicRMW.op, op);
  theAtomicRMW.bytes = 2;
  assertEq(theAtomicRMW.bytes, 2);
  theAtomicRMW.offset = offset = 16;
  assertEq(theAtomicRMW.offset, offset);
  theAtomicRMW.ptr = ptr = module.i32.const(4);
  assertEq(theAtomicRMW.ptr, ptr);
  theAtomicRMW.value = value = module.i64.const(5);
  assertEq(theAtomicRMW.value, value);
  theAtomicRMW.type = binaryen.i64;
  theAtomicRMW.finalize();
  assertEq(theAtomicRMW.type, binaryen.i64);

  info = binaryen.getExpressionInfo(theAtomicRMW);
  assertEq(info.type, theAtomicRMW.type);
  assertEq(info.op, theAtomicRMW.op);
  assertEq(info.bytes, theAtomicRMW.bytes);
  assertEq(info.offset, theAtomicRMW.offset);
  assertEq(info.ptr, theAtomicRMW.ptr);
  assertEq(info.value, theAtomicRMW.value);

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
  const theAtomicCmpxchg = module.i32.atomic.rmw.cmpxchg(offset, ptr, expected, replacement);
  assert(theAtomicCmpxchg instanceof binaryen.AtomicCmpxchg);
  assert(theAtomicCmpxchg instanceof binaryen.Expression);
  assertEq(theAtomicCmpxchg.bytes, 4);
  assertEq(theAtomicCmpxchg.offset, offset);
  assertEq(theAtomicCmpxchg.ptr, ptr);
  assertEq(theAtomicCmpxchg.expected, expected);
  assertEq(theAtomicCmpxchg.replacement, replacement);
  assertEq(theAtomicCmpxchg.type, binaryen.i32);

  var info = binaryen.getExpressionInfo(theAtomicCmpxchg);
  assertEq(info.id, theAtomicCmpxchg.id);
  assertEq(info.type, theAtomicCmpxchg.type);
  assertEq(info.bytes, theAtomicCmpxchg.bytes);
  assertEq(info.offset, theAtomicCmpxchg.offset);
  assertEq(info.ptr, theAtomicCmpxchg.ptr);
  assertEq(info.expected, theAtomicCmpxchg.expected);
  assertEq(info.replacement, theAtomicCmpxchg.replacement);

  theAtomicCmpxchg.bytes = 2;
  assertEq(theAtomicCmpxchg.bytes, 2);
  theAtomicCmpxchg.offset = offset = 16;
  assertEq(theAtomicCmpxchg.offset, offset);
  theAtomicCmpxchg.ptr = ptr = module.i32.const(5);
  assertEq(theAtomicCmpxchg.ptr, ptr);
  theAtomicCmpxchg.expected = expected = module.i64.const(6);
  assertEq(theAtomicCmpxchg.expected, expected);
  theAtomicCmpxchg.replacement = replacement = module.i64.const(7);
  assertEq(theAtomicCmpxchg.replacement, replacement);
  theAtomicCmpxchg.type = binaryen.i64;
  theAtomicCmpxchg.finalize();
  assertEq(theAtomicCmpxchg.type, binaryen.i64);

  info = binaryen.getExpressionInfo(theAtomicCmpxchg);
  assertEq(info.type, theAtomicCmpxchg.type);
  assertEq(info.bytes, theAtomicCmpxchg.bytes);
  assertEq(info.offset, theAtomicCmpxchg.offset);
  assertEq(info.ptr, theAtomicCmpxchg.ptr);
  assertEq(info.expected, theAtomicCmpxchg.expected);
  assertEq(info.replacement, theAtomicCmpxchg.replacement);

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
  const theAtomicWait = module.memory.atomic.wait32(ptr, expected, timeout);
  assert(theAtomicWait instanceof binaryen.AtomicWait);
  assert(theAtomicWait instanceof binaryen.Expression);
  assertEq(theAtomicWait.ptr, ptr);
  assertEq(theAtomicWait.expected, expected);
  assertEq(theAtomicWait.expectedType, binaryen.i32);
  assertEq(theAtomicWait.timeout, timeout);
  assertEq(theAtomicWait.type, binaryen.i32);

  var info = binaryen.getExpressionInfo(theAtomicWait);
  assertEq(info.id, theAtomicWait.id);
  assertEq(info.type, theAtomicWait.type);
  assertEq(info.ptr, theAtomicWait.ptr);
  assertEq(info.expected, theAtomicWait.expected);
  assertEq(info.expectedType, theAtomicWait.expectedType);
  assertEq(info.timeout, theAtomicWait.timeout);

  theAtomicWait.ptr = ptr = module.i32.const(5);
  assertEq(theAtomicWait.ptr, ptr);
  theAtomicWait.expected = expected = module.i32.const(6);
  assertEq(theAtomicWait.expected, expected);
  theAtomicWait.expectedType = binaryen.i64;
  assertEq(theAtomicWait.expectedType, binaryen.i64);
  theAtomicWait.timeout = timeout = module.i64.const(7);
  assertEq(theAtomicWait.timeout, timeout);
  theAtomicWait.type = binaryen.f64;
  theAtomicWait.finalize();
  assertEq(theAtomicWait.type, binaryen.i32);

  info = binaryen.getExpressionInfo(theAtomicWait);
  assertEq(info.type, theAtomicWait.type);
  assertEq(info.ptr, theAtomicWait.ptr);
  assertEq(info.expected, theAtomicWait.expected);
  assertEq(info.expectedType, theAtomicWait.expectedType);
  assertEq(info.timeout, theAtomicWait.timeout);

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
  const theAtomicNotify = module.memory.atomic.notify(ptr, notifyCount);
  assert(theAtomicNotify instanceof binaryen.AtomicNotify);
  assert(theAtomicNotify instanceof binaryen.Expression);
  assertEq(theAtomicNotify.ptr, ptr);
  assertEq(theAtomicNotify.notifyCount, notifyCount);
  assertEq(theAtomicNotify.type, binaryen.i32);

  var info = binaryen.getExpressionInfo(theAtomicNotify);
  assertEq(info.id, theAtomicNotify.id);
  assertEq(info.type, theAtomicNotify.type);
  assertEq(info.ptr, theAtomicNotify.ptr);
  assertEq(info.notifyCount, theAtomicNotify.notifyCount);

  theAtomicNotify.ptr = ptr = module.i32.const(3);
  assertEq(theAtomicNotify.ptr, ptr);
  theAtomicNotify.notifyCount = notifyCount = module.i32.const(4);
  assertEq(theAtomicNotify.notifyCount, notifyCount);
  theAtomicNotify.type = binaryen.f64;
  theAtomicNotify.finalize();
  assertEq(theAtomicNotify.type, binaryen.i32);

  info = binaryen.getExpressionInfo(theAtomicNotify);
  assertEq(info.type, theAtomicNotify.type);
  assertEq(info.ptr, theAtomicNotify.ptr);
  assertEq(info.notifyCount, theAtomicNotify.notifyCount);

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

  const theAtomicFence = module.atomic.fence();
  assert(theAtomicFence instanceof binaryen.AtomicFence);
  assert(theAtomicFence instanceof binaryen.Expression);
  assertEq(theAtomicFence.order, 0); // reserved, not yet used
  assertEq(theAtomicFence.type, binaryen.none);

  var info = binaryen.getExpressionInfo(theAtomicFence);
  assertEq(info.id, theAtomicFence.id);
  assertEq(info.type, theAtomicFence.type);
  assertEq(info.order, theAtomicFence.order);

  theAtomicFence.order = 1;
  assertEq(theAtomicFence.order, 1);
  theAtomicFence.type = binaryen.f64;
  theAtomicFence.finalize();
  assertEq(theAtomicFence.type, binaryen.none);

  info = binaryen.getExpressionInfo(theAtomicFence);
  assertEq(info.type, theAtomicFence.type);
  assertEq(info.order, theAtomicFence.order);

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
  const theSIMDExtract = module.i8x16.extract_lane_s(vec, index);
  assert(theSIMDExtract instanceof binaryen.SIMDExtract);
  assert(theSIMDExtract instanceof binaryen.Expression);
  assertEq(theSIMDExtract.op, op);
  assertEq(theSIMDExtract.vec, vec);
  assertEq(theSIMDExtract.index, index);
  assertEq(theSIMDExtract.type, binaryen.i32);

  var info = binaryen.getExpressionInfo(theSIMDExtract);
  assertEq(info.id, theSIMDExtract.id);
  assertEq(info.type, theSIMDExtract.type);
  assertEq(info.op, theSIMDExtract.op);
  assertEq(info.vec, theSIMDExtract.vec);
  assertEq(info.index, theSIMDExtract.index);

  theSIMDExtract.op = op = binaryen.Operations.ExtractLaneSVecI16x8;
  assertEq(theSIMDExtract.op, op);
  theSIMDExtract.vec = vec = module.v128.const([1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]);
  assertEq(theSIMDExtract.vec, vec);
  theSIMDExtract.index = index = 1;
  assertEq(theSIMDExtract.index, index);
  theSIMDExtract.type = binaryen.f64;
  theSIMDExtract.finalize();
  assertEq(theSIMDExtract.type, binaryen.i32);
  
  info = binaryen.getExpressionInfo(theSIMDExtract);
  assertEq(info.type, theSIMDExtract.type);
  assertEq(info.op, theSIMDExtract.op);
  assertEq(info.vec, theSIMDExtract.vec);
  assertEq(info.index, theSIMDExtract.index);

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
  const theSIMDReplace = module.i8x16.replace_lane(vec, index, value);
  assert(theSIMDReplace instanceof binaryen.SIMDReplace);
  assert(theSIMDReplace instanceof binaryen.Expression);
  assertEq(theSIMDReplace.op, op);
  assertEq(theSIMDReplace.vec, vec);
  assertEq(theSIMDReplace.index, index);
  assertEq(theSIMDReplace.value, value);
  assertEq(theSIMDReplace.type, binaryen.v128);

  var info = binaryen.getExpressionInfo(theSIMDReplace);
  assertEq(info.id, theSIMDReplace.id);
  assertEq(info.type, theSIMDReplace.type);
  assertEq(info.op, theSIMDReplace.op);
  assertEq(info.vec, theSIMDReplace.vec);
  assertEq(info.index, theSIMDReplace.index);
  assertEq(info.value, theSIMDReplace.value);

  theSIMDReplace.op = op = binaryen.Operations.ReplaceLaneVecI16x8;
  assertEq(theSIMDReplace.op, op);
  theSIMDReplace.vec = vec = module.v128.const([1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]);
  assertEq(theSIMDReplace.vec, vec);
  theSIMDReplace.index = index = 1;
  assertEq(theSIMDReplace.index, index);
  theSIMDReplace.value = value = module.i32.const(2);
  assertEq(theSIMDReplace.value, value);
  theSIMDReplace.type = binaryen.f64;
  theSIMDReplace.finalize();
  assertEq(theSIMDReplace.type, binaryen.v128);

  info = binaryen.getExpressionInfo(theSIMDReplace);
  assertEq(info.type, theSIMDReplace.type);
  assertEq(info.op, theSIMDReplace.op);
  assertEq(info.vec, theSIMDReplace.vec);
  assertEq(info.index, theSIMDReplace.index);
  assertEq(info.value, theSIMDReplace.value);

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
  const theSIMDShuffle = module.i8x16.shuffle(left, right, mask);
  assert(theSIMDShuffle instanceof binaryen.SIMDShuffle);
  assert(theSIMDShuffle instanceof binaryen.Expression);
  assertEq(theSIMDShuffle.left, left);
  assertEq(theSIMDShuffle.right, right);
  assertEq(theSIMDShuffle.mask, mask);
  assertEq(theSIMDShuffle.type, binaryen.v128);

  var info = binaryen.getExpressionInfo(theSIMDShuffle);
  assertEq(info.id, theSIMDShuffle.id);
  assertEq(info.type, theSIMDShuffle.type);
  assertEq(info.left, theSIMDShuffle.left);
  assertEq(info.right, theSIMDShuffle.right);
  assertEq(info.mask, theSIMDShuffle.mask);

  theSIMDShuffle.left = left = module.v128.const([1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]);
  assertEq(theSIMDShuffle.left, left);
  theSIMDShuffle.right = right = module.v128.const([2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2]);
  assertEq(theSIMDShuffle.right, right);
  theSIMDShuffle.mask = mask = [3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3];
  assertEq(theSIMDShuffle.mask, mask);
  theSIMDShuffle.type = binaryen.f64;
  theSIMDShuffle.finalize();
  assertEq(theSIMDShuffle.type, binaryen.v128);

  info = binaryen.getExpressionInfo(theSIMDShuffle);
  assertEq(info.type, theSIMDShuffle.type);
  assertEq(info.left, theSIMDShuffle.left);
  assertEq(info.right, theSIMDShuffle.right);
  assertEq(info.mask, theSIMDShuffle.mask);

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
  const theSIMDTernary = module.v128.bitselect(a, b, c);
  assert(theSIMDTernary instanceof binaryen.SIMDTernary);
  assert(theSIMDTernary instanceof binaryen.Expression);
  assertEq(theSIMDTernary.op, op);
  assertEq(theSIMDTernary.a, a);
  assertEq(theSIMDTernary.b, b);
  assertEq(theSIMDTernary.c, c);
  assertEq(theSIMDTernary.type, binaryen.v128);

  var info = binaryen.getExpressionInfo(theSIMDTernary);
  assertEq(info.id, theSIMDTernary.id);
  assertEq(info.type, theSIMDTernary.type);
  assertEq(info.op, theSIMDTernary.op);
  assertEq(info.a, theSIMDTernary.a);
  assertEq(info.b, theSIMDTernary.b);
  assertEq(info.c, theSIMDTernary.c);

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
  const theSIMDShift = module.i8x16.shl(vec, shift);
  assert(theSIMDShift instanceof binaryen.SIMDShift);
  assert(theSIMDShift instanceof binaryen.Expression);
  assertEq(theSIMDShift.op, op);
  assertEq(theSIMDShift.vec, vec);
  assertEq(theSIMDShift.shift, shift);
  assertEq(theSIMDShift.type, binaryen.v128);

  var info = binaryen.getExpressionInfo(theSIMDShift);
  assertEq(info.id, theSIMDShift.id);
  assertEq(info.type, theSIMDShift.type);
  assertEq(info.op, theSIMDShift.op);
  assertEq(info.vec, theSIMDShift.vec);
  assertEq(info.shift, theSIMDShift.shift);

  theSIMDShift.op = op = binaryen.Operations.ShrSVecI8x16;
  assertEq(theSIMDShift.op, op);
  theSIMDShift.vec = vec = module.v128.const([1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]);
  assertEq(theSIMDShift.vec, vec);
  theSIMDShift.shift = shift = module.i32.const(2);
  assertEq(theSIMDShift.shift, shift);
  theSIMDShift.type = binaryen.f64;
  theSIMDShift.finalize();
  assertEq(theSIMDShift.type, binaryen.v128);

  info = binaryen.getExpressionInfo(theSIMDShift);
  assertEq(info.type, theSIMDShift.type);
  assertEq(info.op, theSIMDShift.op);
  assertEq(info.vec, theSIMDShift.vec);
  assertEq(info.shift, theSIMDShift.shift);

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
  const theSIMDLoad = module.v128.load8x8_s(offset, align, ptr);
  assert(theSIMDLoad instanceof binaryen.SIMDLoad);
  assert(theSIMDLoad instanceof binaryen.Expression);
  assertEq(theSIMDLoad.offset, offset);
  assertEq(theSIMDLoad.align, align);
  assertEq(theSIMDLoad.ptr, ptr);
  assertEq(theSIMDLoad.type, binaryen.v128);

  var info = binaryen.getExpressionInfo(theSIMDLoad);
  assertEq(info.id, theSIMDLoad.id);
  assertEq(info.type, theSIMDLoad.type);
  assertEq(info.offset, theSIMDLoad.offset);
  assertEq(info.align, theSIMDLoad.align);
  assertEq(info.ptr, theSIMDLoad.ptr);

  theSIMDLoad.op = op = binaryen.Operations.Load8SplatVec128;
  assertEq(theSIMDLoad.op, op);
  theSIMDLoad.offset = offset = 32;
  assertEq(theSIMDLoad.offset, offset);
  theSIMDLoad.align = align = 4;
  assertEq(theSIMDLoad.align, align);
  theSIMDLoad.ptr = ptr = module.i32.const(2);
  assertEq(theSIMDLoad.ptr, ptr);
  theSIMDLoad.type = binaryen.f64;
  theSIMDLoad.finalize();
  assertEq(theSIMDLoad.type, binaryen.v128);

  info = binaryen.getExpressionInfo(theSIMDLoad);
  assertEq(info.type, theSIMDLoad.type);
  assertEq(info.offset, theSIMDLoad.offset);
  assertEq(info.align, theSIMDLoad.align);
  assertEq(info.ptr, theSIMDLoad.ptr);

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
  const theSIMDLoadStoreLane = module.v128.load8_lane(offset, align, index, ptr, vec);
  assert(theSIMDLoadStoreLane instanceof binaryen.SIMDLoadStoreLane);
  assert(theSIMDLoadStoreLane instanceof binaryen.Expression);
  assertEq(theSIMDLoadStoreLane.op, op);
  assertEq(theSIMDLoadStoreLane.offset, offset);
  assertEq(theSIMDLoadStoreLane.align, align);
  assertEq(theSIMDLoadStoreLane.index, index);
  assertEq(theSIMDLoadStoreLane.ptr, ptr);
  assertEq(theSIMDLoadStoreLane.vec, vec);
  assertEq(theSIMDLoadStoreLane.type, binaryen.v128);
  assertEq(theSIMDLoadStoreLane.store, false);

  var info = binaryen.getExpressionInfo(theSIMDLoadStoreLane);
  assertEq(info.id, theSIMDLoadStoreLane.id);
  assertEq(info.type, theSIMDLoadStoreLane.type);
  assertEq(info.op, theSIMDLoadStoreLane.op);
  assertEq(info.offset, theSIMDLoadStoreLane.offset);
  assertEq(info.align, theSIMDLoadStoreLane.align);
  assertEq(info.index, theSIMDLoadStoreLane.index);
  assertEq(info.ptr, theSIMDLoadStoreLane.ptr);
  assertEq(info.vec, theSIMDLoadStoreLane.vec);
  assertEq(info.isStore, theSIMDLoadStoreLane.store);

  theSIMDLoadStoreLane.op = op = binaryen.Operations.Load16LaneVec128;
  assertEq(theSIMDLoadStoreLane.op, op);
  theSIMDLoadStoreLane.offset = offset = 32;
  assertEq(theSIMDLoadStoreLane.offset, offset);
  theSIMDLoadStoreLane.align = align = 2;
  assertEq(theSIMDLoadStoreLane.align, align);
  theSIMDLoadStoreLane.index = index = 2;
  assertEq(theSIMDLoadStoreLane.index, index);
  theSIMDLoadStoreLane.ptr = ptr = module.i32.const(2);
  assertEq(theSIMDLoadStoreLane.ptr, ptr);
  theSIMDLoadStoreLane.vec = vec = module.v128.const([1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]);
  assertEq(theSIMDLoadStoreLane.vec, vec);
  theSIMDLoadStoreLane.type = binaryen.f64;
  theSIMDLoadStoreLane.finalize();
  assertEq(theSIMDLoadStoreLane.type, binaryen.v128);

  info = binaryen.getExpressionInfo(theSIMDLoadStoreLane);
  assertEq(info.type, theSIMDLoadStoreLane.type);
  assertEq(info.op, theSIMDLoadStoreLane.op);
  assertEq(info.offset, theSIMDLoadStoreLane.offset);
  assertEq(info.align, theSIMDLoadStoreLane.align);
  assertEq(info.index, theSIMDLoadStoreLane.index);
  assertEq(info.ptr, theSIMDLoadStoreLane.ptr);
  assertEq(info.vec, theSIMDLoadStoreLane.vec);

  console.log(theSIMDLoadStoreLane.toText());
  assert(
    theSIMDLoadStoreLane.toText()
    ==
    "(v128.load16_lane $0 offset=32 2\n (i32.const 2)\n (v128.const i32x4 0x01010101 0x01010101 0x01010101 0x01010101)\n)\n"
  );

  theSIMDLoadStoreLane.op = op = binaryen.Operations.Store16LaneVec128;
  assertEq(theSIMDLoadStoreLane.op, op);
  theSIMDLoadStoreLane.type = binaryen.f64;
  assertEq(theSIMDLoadStoreLane.store, true);
  theSIMDLoadStoreLane.finalize();
  assertEq(theSIMDLoadStoreLane.type, binaryen.none);

  info = binaryen.getExpressionInfo(theSIMDLoadStoreLane);
  assertEq(info.type, theSIMDLoadStoreLane.type);
  assertEq(info.op, theSIMDLoadStoreLane.op);
  assertEq(info.isStore, theSIMDLoadStoreLane.store);

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
  const theMemoryInit = module.memory.init(segment, dest, offset, size);
  assert(theMemoryInit instanceof binaryen.MemoryInit);
  assert(theMemoryInit instanceof binaryen.Expression);
  assertEq(theMemoryInit.segment, segment);
  assertEq(theMemoryInit.dest, dest);
  assertEq(theMemoryInit.offset, offset);
  assertEq(theMemoryInit.size, size);
  assertEq(theMemoryInit.type, binaryen.none);

  var info = binaryen.getExpressionInfo(theMemoryInit);
  assertEq(info.id, theMemoryInit.id);
  assertEq(info.type, theMemoryInit.type);
  assertEq(info.segment, theMemoryInit.segment);
  assertEq(info.dest, theMemoryInit.dest);
  assertEq(info.offset, theMemoryInit.offset);
  assertEq(info.size, theMemoryInit.size);

  theMemoryInit.segment = segment = "5";
  assertEq(theMemoryInit.segment, "5");
  theMemoryInit.dest = dest = module.i32.const(6);
  assertEq(theMemoryInit.dest, dest);
  theMemoryInit.offset = offset = module.i32.const(7);
  assertEq(theMemoryInit.offset, offset);
  theMemoryInit.size = size = module.i32.const(8);
  assertEq(theMemoryInit.size, size);
  theMemoryInit.type = binaryen.f64;
  theMemoryInit.finalize();
  assertEq(theMemoryInit.type, binaryen.none);

  info = binaryen.getExpressionInfo(theMemoryInit);
  assertEq(info.type, theMemoryInit.type);
  assertEq(info.segment, theMemoryInit.segment);
  assertEq(info.dest, theMemoryInit.dest);
  assertEq(info.offset, theMemoryInit.offset);
  assertEq(info.size, theMemoryInit.size);

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
  const theDataDrop = module.data.drop(segment);
  assert(theDataDrop instanceof binaryen.DataDrop);
  assert(theDataDrop instanceof binaryen.Expression);
  assertEq(theDataDrop.segment, segment);
  assertEq(theDataDrop.type, binaryen.none);

  var info = binaryen.getExpressionInfo(theDataDrop);
  assertEq(info.id, theDataDrop.id);
  assertEq(info.type, theDataDrop.type);
  assertEq(info.segment, theDataDrop.segment);

  theDataDrop.segment = segment = "2";
  assertEq(theDataDrop.segment, "2");
  theDataDrop.type = binaryen.f64;
  theDataDrop.finalize();
  assertEq(theDataDrop.type, binaryen.none);

  info = binaryen.getExpressionInfo(theDataDrop);
  assertEq(info.type, theDataDrop.type);
  assertEq(info.segment, theDataDrop.segment);

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
  const theMemoryCopy = module.memory.copy(dest, source, size);
  assert(theMemoryCopy instanceof binaryen.MemoryCopy);
  assert(theMemoryCopy instanceof binaryen.Expression);
  assertEq(theMemoryCopy.dest, dest);
  assertEq(theMemoryCopy.source, source);
  assertEq(theMemoryCopy.size, size);
  assertEq(theMemoryCopy.type, binaryen.none);

  var info = binaryen.getExpressionInfo(theMemoryCopy);
  assertEq(info.id, theMemoryCopy.id);
  assertEq(info.type, theMemoryCopy.type);
  assertEq(info.dest, theMemoryCopy.dest);
  assertEq(info.source, theMemoryCopy.source);
  assertEq(info.size, theMemoryCopy.size);

  theMemoryCopy.dest = dest = module.i32.const(4);
  assertEq(theMemoryCopy.dest, dest);
  theMemoryCopy.source = source = module.i32.const(5);
  assertEq(theMemoryCopy.source, source);
  theMemoryCopy.size = size = module.i32.const(6);
  assertEq(theMemoryCopy.size, size);
  theMemoryCopy.type = binaryen.f64;
  theMemoryCopy.finalize();
  assertEq(theMemoryCopy.type, binaryen.none);

  info = binaryen.getExpressionInfo(theMemoryCopy);
  assertEq(info.type, theMemoryCopy.type);
  assertEq(info.dest, theMemoryCopy.dest);
  assertEq(info.source, theMemoryCopy.source);
  assertEq(info.size, theMemoryCopy.size);

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
  const theMemoryFill = module.memory.fill(dest, value, size);
  assert(theMemoryFill instanceof binaryen.MemoryFill);
  assert(theMemoryFill instanceof binaryen.Expression);
  assertEq(theMemoryFill.dest, dest);
  assertEq(theMemoryFill.value, value);
  assertEq(theMemoryFill.size, size);
  assertEq(theMemoryFill.type, binaryen.none);

  var info = binaryen.getExpressionInfo(theMemoryFill);
  assertEq(info.id, theMemoryFill.id);
  assertEq(info.type, theMemoryFill.type);
  assertEq(info.dest, theMemoryFill.dest);
  assertEq(info.value, theMemoryFill.value);
  assertEq(info.size, theMemoryFill.size);

  theMemoryFill.dest = dest = module.i32.const(4);
  assertEq(theMemoryFill.dest, dest);
  theMemoryFill.value = value = module.i32.const(5);
  assertEq(theMemoryFill.value, value);
  theMemoryFill.size = size = module.i32.const(6);
  assertEq(theMemoryFill.size, size);
  theMemoryFill.type = binaryen.f64;
  theMemoryFill.finalize();
  assertEq(theMemoryFill.type, binaryen.none);

  info = binaryen.getExpressionInfo(theMemoryFill);
  assertEq(info.type, theMemoryFill.type);
  assertEq(info.dest, theMemoryFill.dest);
  assertEq(info.value, theMemoryFill.value);
  assertEq(info.size, theMemoryFill.size);

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
  const theRefIsNull = module.ref.is_null(value);
  assert(theRefIsNull instanceof binaryen.RefIsNull);
  assert(theRefIsNull instanceof binaryen.Expression);
  assertEq(theRefIsNull.value, value);
  assertEq(theRefIsNull.type, binaryen.i32);

  var info = binaryen.getExpressionInfo(theRefIsNull);
  assertEq(info.id, theRefIsNull.id);
  assertEq(info.type, theRefIsNull.type);
  assertEq(info.value, theRefIsNull.value);

  theRefIsNull.value = value = module.local.get(2, binaryen.externref);
  assertEq(theRefIsNull.value, value);
  theRefIsNull.type = binaryen.f64;
  theRefIsNull.finalize();
  assertEq(theRefIsNull.type, binaryen.i32);

  info = binaryen.getExpressionInfo(theRefIsNull);
  assertEq(info.type, theRefIsNull.type);
  assertEq(info.value, theRefIsNull.value);

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
  const theRefAs = module.ref.as_non_null(value);
  assert(theRefAs instanceof binaryen.RefAs);
  assert(theRefAs instanceof binaryen.Expression);
  assertEq(theRefAs.op, op);
  assertEq(theRefAs.value, value);
  assert(theRefAs.type !== binaryen.i32); // TODO: === (ref any)

  var info = binaryen.getExpressionInfo(theRefAs);
  assertEq(info.id, theRefAs.id);
  assertEq(info.type, theRefAs.type);
  assertEq(info.op, theRefAs.op);
  assertEq(info.value, theRefAs.value);

  theRefAs.op = op = binaryen.Operations.RefAsExternConvertAny;
  assertEq(theRefAs.op, op);
  theRefAs.op = op = binaryen.Operations.RefAsNonNull;
  theRefAs.value = value = module.local.get(2, binaryen.anyref);
  assertEq(theRefAs.value, value);
  theRefAs.type = binaryen.f64;
  theRefAs.finalize();
  assert(theRefAs.type !== binaryen.f64); // TODO: === (ref any)

  info = binaryen.getExpressionInfo(theRefAs);
  assertEq(info.type, theRefAs.type);
  assertEq(info.op, theRefAs.op);
  assertEq(info.value, theRefAs.value);

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
  const theRefFunc = module.ref.func(func, type);
  assert(theRefFunc instanceof binaryen.RefFunc);
  assert(theRefFunc instanceof binaryen.Expression);
  assertEq(theRefFunc.func, func);
  assertEq(theRefFunc.type, type);

  var info = binaryen.getExpressionInfo(theRefFunc);
  assertEq(info.id, theRefFunc.id);
  assertEq(info.type, theRefFunc.type);
  assertEq(info.func, theRefFunc.func);

  theRefFunc.func = func = "b";
  assertEq(theRefFunc.func, func);
  theRefFunc.finalize();
  assertEq(theRefFunc.type, type);

  info = binaryen.getExpressionInfo(theRefFunc);
  assertEq(info.type, theRefFunc.type);
  assertEq(info.func, theRefFunc.func);

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
  const theRefEq = module.ref.eq(left, right);
  assert(theRefEq instanceof binaryen.RefEq);
  assert(theRefEq instanceof binaryen.Expression);
  assertEq(theRefEq.left, left);
  assertEq(theRefEq.right, right);
  assertEq(theRefEq.type, binaryen.i32);

  var info = binaryen.getExpressionInfo(theRefEq);
  assertEq(info.id, theRefEq.id);
  assertEq(info.type, theRefEq.type);
  assertEq(info.left, theRefEq.left);
  assertEq(info.right, theRefEq.right);

  theRefEq.left = left = module.local.get(2, binaryen.eqref);
  assertEq(theRefEq.left, left);
  theRefEq.right = right = module.local.get(3, binaryen.eqref);
  assertEq(theRefEq.right, right);
  theRefEq.type = binaryen.f64;
  theRefEq.finalize();
  assertEq(theRefEq.type, binaryen.i32);

  info = binaryen.getExpressionInfo(theRefEq);
  assertEq(info.type, theRefEq.type);
  assertEq(info.left, theRefEq.left);
  assertEq(info.right, theRefEq.right);

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
  const theRefTest = module.ref.test(ref, castType);
  assert(theRefTest instanceof binaryen.RefTest);
  assert(theRefTest instanceof binaryen.Expression);
  assertEq(theRefTest.ref, ref);
  assertEq(theRefTest.castType, castType);
  assertEq(theRefTest.type, binaryen.i32);

  var info = binaryen.getExpressionInfo(theRefTest);
  assertEq(info.id, theRefTest.id);
  assertEq(info.type, theRefTest.type);
  assertEq(info.ref, theRefTest.ref);
  assertEq(info.castType, theRefTest.castType);

  theRefTest.ref = ref = module.local.get(2, binaryen.externref);
  assertEq(theRefTest.ref, ref);
  theRefTest.castType = castType = binaryen.externref;
  assertEq(theRefTest.castType, castType);
  theRefTest.type = binaryen.f64;
  theRefTest.finalize();
  assertEq(theRefTest.type, binaryen.i32);

  info = binaryen.getExpressionInfo(theRefTest);
  assertEq(info.type, theRefTest.type);
  assertEq(info.ref, theRefTest.ref);
  assertEq(info.castType, theRefTest.castType);

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
  const theRefCast = module.ref.cast(ref, type);
  assert(theRefCast instanceof binaryen.RefCast);
  assert(theRefCast instanceof binaryen.Expression);
  assertEq(theRefCast.ref, ref);
  assertEq(theRefCast.type, type);

  var info = binaryen.getExpressionInfo(theRefCast);
  assertEq(info.id, theRefCast.id);
  assertEq(info.type, theRefCast.type);
  assertEq(info.ref, theRefCast.ref);

  theRefCast.ref = ref = module.local.get(2, binaryen.externref);
  assertEq(theRefCast.ref, ref);
  theRefCast.type = type = binaryen.externref;
  theRefCast.finalize();
  assertEq(theRefCast.type, type);

  info = binaryen.getExpressionInfo(theRefCast);
  assertEq(info.type, theRefCast.type);
  assertEq(info.ref, theRefCast.ref);

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
  const theBrOn = module.br_on_null(name, ref);
  assert(theBrOn instanceof binaryen.BrOn);
  assert(theBrOn instanceof binaryen.Expression);
  assertEq(theBrOn.name, name);
  assertEq(theBrOn.ref, ref);
  assertEq(theBrOn.op, op);
  assertEq(theBrOn.castType, castType);

  // TODO: What should theBrOn.type be equal to?

  var info = binaryen.getExpressionInfo(theBrOn);
  assertEq(info.id, theBrOn.id);
  assertEq(info.type, theBrOn.type);
  assertEq(info.name, theBrOn.name);
  assertEq(info.ref, theBrOn.ref);
  assertEq(info.op, theBrOn.op);
  assertEq(info.castType, theBrOn.castType);

  theBrOn.name = name = "br2";
  assertEq(theBrOn.name, name);
  theBrOn.ref = ref = module.local.get(1, binaryen.anyref);
  assertEq(theBrOn.ref, ref);
  theBrOn.op = op = binaryen.Operations.BrOnCast;
  assertEq(theBrOn.op, op);
  theBrOn.castType = castType = binaryen.i31ref;
  assertEq(theBrOn.castType, castType);
  theBrOn.finalize();

  info = binaryen.getExpressionInfo(theBrOn);
  assertEq(info.name, theBrOn.name);
  assertEq(info.ref, theBrOn.ref);
  assertEq(info.op, theBrOn.op);
  assertEq(info.castType, theBrOn.castType);

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
  const theStructNew = module.struct.new(operands, type);
  assert(theStructNew instanceof binaryen.StructNew);
  assert(theStructNew instanceof binaryen.Expression);
  assertEq(theStructNew.operands, operands);
  assertEq(theStructNew.getOperands(), operands);
  assertEq(theStructNew.type, type);

  var info = binaryen.getExpressionInfo(theStructNew);
  assertEq(info.id, theStructNew.id);
  assertEq(info.type, theStructNew.type);
  assertEq(info.operands, theStructNew.operands);

  theStructNew.operands = operands = [
    module.i32.const(3), // set
    module.i32.const(4), // set
    module.i32.const(5)  // append
  ];
  assertEq(theStructNew.operands, operands);
  operands = [
    module.i32.const(6) // set
    // remove
    // remove
  ];
  theStructNew.setOperands(operands);
  assertEq(theStructNew.operands, operands);
  theStructNew.insertOperandAt(0, module.i32.const(7));
  theStructNew.type = type = struct1Type;
  theStructNew.finalize();
  assertEq(theStructNew.type, type);

  info = binaryen.getExpressionInfo(theStructNew);
  assertEq(info.type, theStructNew.type);
  assertEq(info.operands, theStructNew.operands);

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
  const theStructGet = module.struct.get(index, ref, type, signed);
  assert(theStructGet instanceof binaryen.StructGet);
  assert(theStructGet instanceof binaryen.Expression);
  assertEq(theStructGet.index, index);
  assertEq(theStructGet.ref, ref);
  assertEq(theStructGet.signed, signed);
  assertEq(theStructGet.type, type);

  var info = binaryen.getExpressionInfo(theStructGet);
  assertEq(info.id, theStructGet.id);
  assertEq(info.type, theStructGet.type);
  assertEq(info.index, theStructGet.index);
  assertEq(info.ref, theStructGet.ref);
  assertEq(info.isSigned, theStructGet.signed);

  theStructGet.index = index = 1;
  assertEq(theStructGet.index, index);
  theStructGet.ref = ref = module.local.get(1, struct1Type);
  assertEq(theStructGet.ref, ref);
  theStructGet.signed = signed = true;
  assertEq(theStructGet.signed, signed);
  theStructGet.type = type = binaryen.i64;
  theStructGet.finalize();
  assertEq(theStructGet.type, type);

  info = binaryen.getExpressionInfo(theStructGet);
  assertEq(info.type, theStructGet.type);
  assertEq(info.index, theStructGet.index);
  assertEq(info.ref, theStructGet.ref);
  assertEq(info.isSigned, theStructGet.signed);

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
  const theStructSet = module.struct.set(index, ref, value);
  assert(theStructSet instanceof binaryen.StructSet);
  assert(theStructSet instanceof binaryen.Expression);
  assertEq(theStructSet.index, index);
  assertEq(theStructSet.ref, ref);
  assertEq(theStructSet.value, value);
  assertEq(theStructSet.type, binaryen.none);

  var info = binaryen.getExpressionInfo(theStructSet);
  assertEq(info.id, theStructSet.id);
  assertEq(info.type, theStructSet.type);
  assertEq(info.index, theStructSet.index);
  assertEq(info.ref, theStructSet.ref);
  assertEq(info.value, theStructSet.value);

  theStructSet.index = index = 1;
  assertEq(theStructSet.index, index);
  theStructSet.ref = ref = module.local.get(2, struct1Type);
  assertEq(theStructSet.ref, ref);
  theStructSet.value = value = module.local.get(3, binaryen.i64);
  assertEq(theStructSet.value, value);
  theStructSet.type = binaryen.f64;
  theStructSet.finalize();
  assertEq(theStructSet.type, binaryen.none);

  info = binaryen.getExpressionInfo(theStructSet);
  assertEq(info.type, theStructSet.type);
  assertEq(info.index, theStructSet.index);
  assertEq(info.ref, theStructSet.ref);
  assertEq(info.value, theStructSet.value);

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
  const theArrayNew = module.array.new(type, size, init);
  assert(theArrayNew instanceof binaryen.ArrayNew);
  assert(theArrayNew instanceof binaryen.Expression);
  assertEq(theArrayNew.size, size);
  assertEq(theArrayNew.init, init);
  assertEq(theArrayNew.type, type);

  var info = binaryen.getExpressionInfo(theArrayNew);
  assertEq(info.id, theArrayNew.id);
  assertEq(info.type, theArrayNew.type);
  assertEq(info.size, theArrayNew.size);
  assertEq(info.init, theArrayNew.init);

  theArrayNew.size = size = module.i32.const(4);
  assertEq(theArrayNew.size, size);
  theArrayNew.init = init = module.i32.const(3);
  assertEq(theArrayNew.init, init);
  theArrayNew.type = type = array1Type;
  theArrayNew.finalize();
  assertEq(theArrayNew.type, type);

  info = binaryen.getExpressionInfo(theArrayNew);
  assertEq(info.type, theArrayNew.type);
  assertEq(info.size, theArrayNew.size);
  assertEq(info.init, theArrayNew.init);

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
  const theArrayNewFixed = module.array.new_fixed(type, values);
  assert(theArrayNewFixed instanceof binaryen.ArrayNewFixed);
  assert(theArrayNewFixed instanceof binaryen.Expression);
  assertEq(theArrayNewFixed.values, values);
  assertEq(theArrayNewFixed.getValues(), values);
  assertEq(theArrayNewFixed.type, type);

  var info = binaryen.getExpressionInfo(theArrayNewFixed);
  assertEq(info.id, theArrayNewFixed.id);
  assertEq(info.type, theArrayNewFixed.type);
  assertEq(info.values, theArrayNewFixed.values);

  theArrayNewFixed.values = values = [
    module.i32.const(3), // set
    module.i32.const(4), // set
    module.i32.const(5)  // append
  ];
  assertEq(theArrayNewFixed.values, values);
  values = [
    module.i32.const(6) // set
    // remove
    // remove
  ];
  theArrayNewFixed.setValues(values);
  assertEq(theArrayNewFixed.values, values);
  theArrayNewFixed.insertValueAt(0, module.i32.const(7));
  theArrayNewFixed.type = type = array1Type;
  theArrayNewFixed.finalize();
  assertEq(theArrayNewFixed.type, type);

  info = binaryen.getExpressionInfo(theArrayNewFixed);
  assertEq(info.type, theArrayNewFixed.type);
  assertEq(info.values, theArrayNewFixed.values);

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
  const theArrayNewData = module.array.new_data(type, segment, offset, size);
  assert(theArrayNewData instanceof binaryen.ArrayNewData);
  assert(theArrayNewData instanceof binaryen.Expression);
  assertEq(theArrayNewData.segment, segment);
  assertEq(theArrayNewData.offset, offset);
  assertEq(theArrayNewData.size, size);
  assertEq(theArrayNewData.type, type);

  var info = binaryen.getExpressionInfo(theArrayNewData);
  assertEq(info.id, theArrayNewData.id);
  assertEq(info.type, theArrayNewData.type);
  assertEq(info.segment, theArrayNewData.segment);
  assertEq(info.offset, theArrayNewData.offset);
  assertEq(info.size, theArrayNewData.size);

  theArrayNewData.segment = segment = "3";
  assertEq(theArrayNewData.segment, segment);
  theArrayNewData.offset = offset = module.i32.const(4);
  assertEq(theArrayNewData.offset, offset);
  theArrayNewData.size = size = module.i32.const(5);
  assertEq(theArrayNewData.size, size);
  theArrayNewData.type = type = array1Type;
  theArrayNewData.finalize();
  assertEq(theArrayNewData.type, type);

  info = binaryen.getExpressionInfo(theArrayNewData);
  assertEq(info.type, theArrayNewData.type);
  assertEq(info.segment, theArrayNewData.segment);
  assertEq(info.offset, theArrayNewData.offset);
  assertEq(info.size, theArrayNewData.size);

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
  const theArrayNewElem = module.array.new_elem(type, segment, offset, size);
  assert(theArrayNewElem instanceof binaryen.ArrayNewElem);
  assert(theArrayNewElem instanceof binaryen.Expression);
  assertEq(theArrayNewElem.segment, segment);
  assertEq(theArrayNewElem.offset, offset);
  assertEq(theArrayNewElem.size, size);
  assertEq(theArrayNewElem.type, type);

  var info = binaryen.getExpressionInfo(theArrayNewElem);
  assertEq(info.id, theArrayNewElem.id);
  assertEq(info.type, theArrayNewElem.type);
  assertEq(info.segment, theArrayNewElem.segment);
  assertEq(info.offset, theArrayNewElem.offset);
  assertEq(info.size, theArrayNewElem.size);

  theArrayNewElem.segment = segment = "3";
  assertEq(theArrayNewElem.segment, segment);
  theArrayNewElem.offset = offset = module.i32.const(4);
  assertEq(theArrayNewElem.offset, offset);
  theArrayNewElem.size = size = module.i32.const(5);
  assertEq(theArrayNewElem.size, size);
  theArrayNewElem.type = type = array1Type;
  theArrayNewElem.finalize();
  assertEq(theArrayNewElem.type, type);

  info = binaryen.getExpressionInfo(theArrayNewElem);
  assertEq(info.id, theArrayNewElem.id);
  assertEq(info.type, theArrayNewElem.type);
  assertEq(info.segment, theArrayNewElem.segment);
  assertEq(info.offset, theArrayNewElem.offset);
  assertEq(info.size, theArrayNewElem.size);

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
  const theArrayGet = module.array.get(ref, index, type, signed);
  assert(theArrayGet instanceof binaryen.ArrayGet);
  assert(theArrayGet instanceof binaryen.Expression);
  assertEq(theArrayGet.ref, ref);
  assertEq(theArrayGet.index, index);
  assertEq(theArrayGet.signed, signed);
  assertEq(theArrayGet.type, type);

  var info = binaryen.getExpressionInfo(theArrayGet);
  assertEq(info.id, theArrayGet.id);
  assertEq(info.type, theArrayGet.type);
  assertEq(info.ref, theArrayGet.ref);
  assertEq(info.index, theArrayGet.index);
  assertEq(info.isSigned, theArrayGet.signed);

  theArrayGet.ref = ref = module.local.get(1, array1Type);
  assertEq(theArrayGet.ref, ref);
  theArrayGet.index = index = module.i32.const(1);
  assertEq(theArrayGet.index, index);
  theArrayGet.signed = signed = true;
  assertEq(theArrayGet.signed, signed);
  theArrayGet.type = type = binaryen.i64;
  theArrayGet.finalize();
  assertEq(theArrayGet.type, type);

  info = binaryen.getExpressionInfo(theArrayGet);
  assertEq(info.type, theArrayGet.type);
  assertEq(info.ref, theArrayGet.ref);
  assertEq(info.index, theArrayGet.index);
  assertEq(info.isSigned, theArrayGet.signed);

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
  const theArraySet = module.array.set(ref, index, value);
  assert(theArraySet instanceof binaryen.ArraySet);
  assert(theArraySet instanceof binaryen.Expression);
  assertEq(theArraySet.ref, ref);
  assertEq(theArraySet.index, index);
  assertEq(theArraySet.value, value);
  assertEq(theArraySet.type, binaryen.none);

  var info = binaryen.getExpressionInfo(theArraySet);
  assertEq(info.id, theArraySet.id);
  assertEq(info.type, theArraySet.type);
  assertEq(info.ref, theArraySet.ref);
  assertEq(info.index, theArraySet.index);
  assertEq(info.value, theArraySet.value);

  theArraySet.ref = ref = module.local.get(2, array1Type);
  assertEq(theArraySet.ref, ref);
  theArraySet.index = index = module.i32.const(1);
  assertEq(theArraySet.index, index);
  theArraySet.value = value = module.local.get(3, binaryen.i64);
  assertEq(theArraySet.value, value);
  theArraySet.type = binaryen.i64;
  theArraySet.finalize();
  assertEq(theArraySet.type, binaryen.none);

  info = binaryen.getExpressionInfo(theArraySet);
  assertEq(info.type, theArraySet.type);
  assertEq(info.ref, theArraySet.ref);
  assertEq(info.index, theArraySet.index);
  assertEq(info.value, theArraySet.value);

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
  const theArrayLen = module.array.len(ref);
  assert(theArrayLen instanceof binaryen.ArrayLen);
  assert(theArrayLen instanceof binaryen.Expression);
  assertEq(theArrayLen.ref, ref);
  assertEq(theArrayLen.type, binaryen.i32);

  var info = binaryen.getExpressionInfo(theArrayLen);
  assertEq(info.id, theArrayLen.id);
  assertEq(info.type, theArrayLen.type);
  assertEq(info.ref, theArrayLen.ref);

  theArrayLen.ref = ref = module.local.get(1, array1Type);
  assertEq(theArrayLen.ref, ref);
  theArrayLen.type = binaryen.i64;
  theArrayLen.finalize();
  assertEq(theArrayLen.type, binaryen.i32);

  info = binaryen.getExpressionInfo(theArrayLen);
  assertEq(info.type, theArrayLen.type);
  assertEq(info.ref, theArrayLen.ref);

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
  const theArrayFill = module.array.fill(ref, index, value, size);
  assert(theArrayFill instanceof binaryen.ArrayFill);
  assert(theArrayFill instanceof binaryen.Expression);
  assertEq(theArrayFill.ref, ref);
  assertEq(theArrayFill.index, index);
  assertEq(theArrayFill.value, value);
  assertEq(theArrayFill.size, size);
  assertEq(theArrayFill.type, binaryen.none);

  var info = binaryen.getExpressionInfo(theArrayFill);
  assertEq(info.id, theArrayFill.id);
  assertEq(info.type, theArrayFill.type);
  assertEq(info.ref, theArrayFill.ref);
  assertEq(info.index, theArrayFill.index);
  assertEq(info.value, theArrayFill.value);
  assertEq(info.size, theArrayFill.size);

  theArrayFill.ref = ref = module.local.get(2, array1Type);
  assertEq(theArrayFill.ref, ref);
  theArrayFill.index = index = module.i32.const(2);
  assertEq(theArrayFill.index, index);
  theArrayFill.value = value = module.local.get(3, binaryen.i64);
  assert(theArrayFill.value = value);
  theArrayFill.size = size = module.i32.const(3);
  assertEq(theArrayFill.size, size);
  theArrayFill.type = binaryen.i64;
  theArrayFill.finalize();
  assertEq(theArrayFill.type, binaryen.none);

  info = binaryen.getExpressionInfo(theArrayFill);
  assertEq(info.type, theArrayFill.type);
  assertEq(info.ref, theArrayFill.ref);
  assertEq(info.index, theArrayFill.index);
  assertEq(info.value, theArrayFill.value);
  assertEq(info.size, theArrayFill.size);

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
  const theArrayCopy = module.array.copy(destRef, destIndex, srcRef, srcIndex, length);
  assert(theArrayCopy instanceof binaryen.ArrayCopy);
  assert(theArrayCopy instanceof binaryen.Expression);
  assertEq(theArrayCopy.destRef, destRef);
  assertEq(theArrayCopy.destIndex, destIndex);
  assertEq(theArrayCopy.srcRef, srcRef);
  assertEq(theArrayCopy.srcIndex, srcIndex);
  assertEq(theArrayCopy.length, length);
  assertEq(theArrayCopy.type, binaryen.none);

  var info = binaryen.getExpressionInfo(theArrayCopy);
  assertEq(info.id, theArrayCopy.id);
  assertEq(info.type, theArrayCopy.type);
  assertEq(info.destRef, theArrayCopy.destRef);
  assertEq(info.destIndex, theArrayCopy.destIndex);
  assertEq(info.srcRef, theArrayCopy.srcRef);
  assertEq(info.srcIndex, theArrayCopy.srcIndex);
  assertEq(info.length, theArrayCopy.length);

  theArrayCopy.destRef = destRef = module.local.get(2, array1Type);
  assertEq(theArrayCopy.destRef, destRef);
  theArrayCopy.destIndex = destIndex = module.i32.const(2);
  assertEq(theArrayCopy.destIndex, destIndex);
  theArrayCopy.srcRef = srcRef = module.local.get(3, array1Type);
  assertEq(theArrayCopy.srcRef, srcRef);
  theArrayCopy.srcIndex = srcIndex = module.i32.const(3);
  assertEq(theArrayCopy.srcIndex, srcIndex);
  theArrayCopy.length = length = module.i32.const(2);
  assertEq(theArrayCopy.length, length);
  theArrayCopy.type = binaryen.i64;
  theArrayCopy.finalize();
  assertEq(theArrayCopy.type, binaryen.none);

  info = binaryen.getExpressionInfo(theArrayCopy);
  assertEq(info.type, theArrayCopy.type);
  assertEq(info.destRef, theArrayCopy.destRef);
  assertEq(info.destIndex, theArrayCopy.destIndex);
  assertEq(info.srcRef, theArrayCopy.srcRef);
  assertEq(info.srcIndex, theArrayCopy.srcIndex);
  assertEq(info.length, theArrayCopy.length);

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
  const theArrayInitData = module.array.init_data(segment, ref, index, offset, size);
  assert(theArrayInitData instanceof binaryen.ArrayInitData);
  assert(theArrayInitData instanceof binaryen.Expression);
  assertEq(theArrayInitData.segment, segment);
  assertEq(theArrayInitData.ref, ref);
  assertEq(theArrayInitData.index, index);
  assertEq(theArrayInitData.offset, offset);
  assertEq(theArrayInitData.size, size);
  assertEq(theArrayInitData.type, binaryen.none);
  
  var info = binaryen.getExpressionInfo(theArrayInitData);
  assertEq(info.id, theArrayInitData.id);
  assertEq(info.type, theArrayInitData.type);
  assertEq(info.segment, theArrayInitData.segment);
  assertEq(info.ref, theArrayInitData.ref);
  assertEq(info.index, theArrayInitData.index);
  assertEq(info.offset, theArrayInitData.offset);
  assertEq(info.size, theArrayInitData.size);

  theArrayInitData.segment = segment = "1";
  assertEq(theArrayInitData.segment, segment);
  theArrayInitData.ref = ref = module.local.get(1, array1Type);
  assertEq(theArrayInitData.ref, ref);
  theArrayInitData.index = index = module.i32.const(3);
  assertEq(theArrayInitData.index, index);
  theArrayInitData.offset = offset = module.i32.const(4);
  assertEq(theArrayInitData.offset, offset);
  theArrayInitData.size = size = module.i32.const(5);
  assertEq(theArrayInitData.size, size);
  theArrayInitData.type = binaryen.i64;
  theArrayInitData.finalize();
  assertEq(theArrayInitData.type, binaryen.none);

  info = binaryen.getExpressionInfo(theArrayInitData);
  assertEq(info.type, theArrayInitData.type);
  assertEq(info.segment, theArrayInitData.segment);
  assertEq(info.ref, theArrayInitData.ref);
  assertEq(info.index, theArrayInitData.index);
  assertEq(info.offset, theArrayInitData.offset);
  assertEq(info.size, theArrayInitData.size);

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
  const theArrayInitElem = module.array.init_elem(segment, ref, index, offset, size);
  assert(theArrayInitElem instanceof binaryen.ArrayInitElem);
  assert(theArrayInitElem instanceof binaryen.Expression);
  assertEq(theArrayInitElem.segment, segment);
  assertEq(theArrayInitElem.ref, ref);
  assertEq(theArrayInitElem.index, index);
  assertEq(theArrayInitElem.offset, offset);
  assertEq(theArrayInitElem.size, size);
  assertEq(theArrayInitElem.type, binaryen.none);

  var info = binaryen.getExpressionInfo(theArrayInitElem);
  assertEq(info.id, theArrayInitElem.id);
  assertEq(info.type, theArrayInitElem.type);
  assertEq(info.segment, theArrayInitElem.segment);
  assertEq(info.ref, theArrayInitElem.ref);
  assertEq(info.index, theArrayInitElem.index);
  assertEq(info.offset, theArrayInitElem.offset);
  assertEq(info.size, theArrayInitElem.size);

  theArrayInitElem.segment = segment = "1";
  assertEq(theArrayInitElem.segment, segment);
  theArrayInitElem.ref = ref = module.local.get(1, array1Type);
  assertEq(theArrayInitElem.ref, ref);
  theArrayInitElem.index = index = module.i32.const(3);
  assertEq(theArrayInitElem.index, index);
  theArrayInitElem.offset = offset = module.i32.const(4);
  assertEq(theArrayInitElem.offset, offset);
  theArrayInitElem.size = size = module.i32.const(5);
  assertEq(theArrayInitElem.size, size);
  theArrayInitElem.type = binaryen.i64;
  theArrayInitElem.finalize();
  assertEq(theArrayInitElem.type, binaryen.none);

  info = binaryen.getExpressionInfo(theArrayInitElem);
  assertEq(info.type, theArrayInitElem.type);
  assertEq(info.segment, theArrayInitElem.segment);
  assertEq(info.ref, theArrayInitElem.ref);
  assertEq(info.index, theArrayInitElem.index);
  assertEq(info.offset, theArrayInitElem.offset);
  assertEq(info.size, theArrayInitElem.size);

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
  const theTry = module.try('', body, ["tag1"], catchBodies, '');
  assert(theTry instanceof binaryen.Try);
  assert(theTry instanceof binaryen.Expression);
  assertEq(theTry.body, body);
  assertEq(theTry.catchBodies, catchBodies);
  assertEq(theTry.type, binaryen.i32);
  assert(theTry.getNumCatchTags() == 1);
  assert(theTry.getNumCatchBodies() == 2);
  assert(theTry.hasCatchAll() == 1);
  console.log(theTry.toText());

  var info = binaryen.getExpressionInfo(theTry);
  assertEq(info.id, theTry.id);
  assertEq(info.type, theTry.type);
  assertEq(info.name, theTry.name);
  assertEq(info.body, theTry.body);
  assertEq(info.catchTags, theTry.catchTags);
  assertEq(info.catchBodies, theTry.catchBodies);
  assertEq(info.hasCatchAll, theTry.hasCatchAll());
  assertEq(info.delegateTarget, theTry.delegateTarget);
  assertEq(info.isDelegate, theTry.delegate);

  theTry.body = body = module.i32.const(4);
  assertEq(theTry.body, body);
  catchBodies = [
    module.i32.const(5) // set
    //remove
  ];
  theTry.setCatchBodies(catchBodies);
  assertEq(theTry.catchBodies, catchBodies);
  assertEq(theTry.getCatchBodies(), catchBodies);
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
  assertEq(theTry.getCatchTags(), ["tag2", "tag3"]);
  theTry.setCatchBodies([module.i32.const(8), module.i32.const(9)]);
  assert(theTry.getCatchTagAt(0) == "tag2");
  assert(theTry.getCatchTagAt(1) == "tag3");
  theTry.setCatchTagAt(1, "tag1");
  theTry.setCatchBodyAt(1, module.i32.const(10));
  assert(theTry.getCatchTagAt(1) == "tag1");
  console.log(theTry.toText());

  theTry.type = binaryen.f64;
  theTry.finalize();
  assertEq(theTry.type, binaryen.i32);

  info = binaryen.getExpressionInfo(theTry);
  assertEq(info.id, theTry.id);
  assertEq(info.type, theTry.type);
  assertEq(info.name, theTry.name);
  assertEq(info.body, theTry.body);
  assertEq(info.catchTags, theTry.catchTags);
  assertEq(info.catchBodies, theTry.catchBodies);
  assertEq(info.hasCatchAll, theTry.hasCatchAll());
  assertEq(info.delegateTarget, theTry.delegateTarget);
  assertEq(info.isDelegate, theTry.delegate);

  console.log(theTry.toText());

  const tryDelegate = module.try('', body, [], [], "try_blah");
  assert(tryDelegate.isDelegate() == 1);
  assert(tryDelegate.getDelegateTarget() == "try_blah");
  tryDelegate.setDelegateTarget("try_outer");
  assert(tryDelegate.getDelegateTarget() == "try_outer");

  info = binaryen.getExpressionInfo(tryDelegate);
  assertEq(info.delegateTarget, tryDelegate.delegateTarget);
  assertEq(info.isDelegate, tryDelegate.delegate);

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
  const theThrow = module.throw(tag, operands);
  assert(theThrow instanceof binaryen.Throw);
  assert(theThrow instanceof binaryen.Expression);
  assertEq(theThrow.tag, tag);
  assertEq(theThrow.operands, operands);
  assertEq(theThrow.type, binaryen.unreachable);

  var info = binaryen.getExpressionInfo(theThrow);
  assertEq(info.id, theThrow.id);
  assertEq(info.type, theThrow.type);
  assertEq(info.tag, theThrow.tag);
  assertEq(info.operands, theThrow.operands);

  theThrow.tag = "bar";
  assertEq(theThrow.tag, "bar");
  theThrow.operands = operands = [
    module.i32.const(3), // set
    module.i32.const(4), // set
    module.i32.const(5)  // append
  ];
  assertEq(theThrow.operands, operands);
  assertEq(theThrow.getOperands(), operands);
  operands = [
    module.i32.const(6) // set
    // remove
    // remove
  ];
  theThrow.setOperands(operands);
  assertEq(theThrow.operands, operands);
  theThrow.insertOperandAt(1, module.i32.const(7));
  theThrow.type = binaryen.f64;
  theThrow.finalize();
  assertEq(theThrow.type, binaryen.unreachable);

  info = binaryen.getExpressionInfo(theThrow);
  assertEq(info.type, theThrow.type);
  assertEq(info.tag, theThrow.tag);
  assertEq(info.operands, theThrow.operands);

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

  const theRethrow = module.rethrow("l0");
  assert(theRethrow instanceof binaryen.Rethrow);
  assert(theRethrow instanceof binaryen.Expression);
  assertEq(theRethrow.target, "l0");
  assertEq(theRethrow.type, binaryen.unreachable);

  var info = binaryen.getExpressionInfo(theRethrow);
  assertEq(info.id, theRethrow.id);
  assertEq(info.type, theRethrow.type);
  assertEq(info.target, theRethrow.target);

  theRethrow.target = "l1";
  assertEq(theRethrow.target, "l1");
  theRethrow.type = binaryen.f64;
  theRethrow.finalize();
  assertEq(theRethrow.type, binaryen.unreachable);

  info = binaryen.getExpressionInfo(theRethrow);
  assertEq(info.type, theRethrow.type);
  assertEq(info.target, theRethrow.target);

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
  const theTupleMake = module.tuple.make(operands);
  assert(theTupleMake instanceof binaryen.TupleMake);
  assert(theTupleMake instanceof binaryen.Expression);
  assertEq(theTupleMake.operands, operands);
  assertEq(theTupleMake.type, type);

  var info = binaryen.getExpressionInfo(theTupleMake);
  assertEq(info.id, theTupleMake.id);
  assertEq(info.type, theTupleMake.type);
  assertEq(info.operands, theTupleMake.operands);

  theTupleMake.operands = operands = [
    module.i32.const(3), // set
    module.i32.const(4), // set
    module.i32.const(5)  // append
  ];
  assertEq(theTupleMake.operands, operands);
  operands = [
    module.i32.const(6) // set
    // remove
    // remove
  ];
  theTupleMake.setOperands(operands);
  assertEq(theTupleMake.operands, operands);
  assertEq(theTupleMake.getOperands(), operands);
  theTupleMake.insertOperandAt(1, module.i32.const(7));
  theTupleMake.type = binaryen.f64;
  theTupleMake.finalize();
  assertEq(theTupleMake.type, type);

  info = binaryen.getExpressionInfo(theTupleMake);
  assertEq(info.type, theTupleMake.type);
  assertEq(info.operands, theTupleMake.operands);

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
  const theTupleExtract = module.tuple.extract(tuple, index);
  assert(theTupleExtract instanceof binaryen.TupleExtract);
  assert(theTupleExtract instanceof binaryen.Expression);
  assertEq(theTupleExtract.tuple, tuple);
  assertEq(theTupleExtract.index, index);
  assertEq(theTupleExtract.type, binaryen.i32);

  var info = binaryen.getExpressionInfo(theTupleExtract);
  assertEq(info.id, theTupleExtract.id);
  assertEq(info.type, theTupleExtract.type);
  assertEq(info.tuple, theTupleExtract.tuple);
  assertEq(info.index, theTupleExtract.index);

  theTupleExtract.tuple = tuple = module.tuple.make([
    module.f64.const(3),
    module.f64.const(4)
  ]);
  assertEq(theTupleExtract.tuple, tuple);
  theTupleExtract.index = index = 0;
  assertEq(theTupleExtract.index, index);
  theTupleExtract.type = binaryen.i32;
  theTupleExtract.finalize();
  assertEq(theTupleExtract.type, binaryen.f64);

  info = binaryen.getExpressionInfo(theTupleExtract);
  assertEq(info.type, theTupleExtract.type);
  assertEq(info.tuple, theTupleExtract.tuple);
  assertEq(info.index, theTupleExtract.index);

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
  const theRefI31 = module.ref.i31(value);
  assert(theRefI31 instanceof binaryen.RefI31);
  assert(theRefI31 instanceof binaryen.Expression);
  assertEq(theRefI31.value, value);
  // assertEq(theRefI31.type, binaryen.?); // TODO: (ref i31)

  var info = binaryen.getExpressionInfo(theRefI31);
  assertEq(info.id, theRefI31.id);
  assertEq(info.type, theRefI31.type);
  assertEq(info.value, theRefI31.value);

  theRefI31.value = value = module.local.get(2, binaryen.i32);
  assertEq(theRefI31.value, value);

  info = binaryen.getExpressionInfo(theRefI31);
  assertEq(info.value, theRefI31.value);

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
  const theI31Get = module.i31.get_s(i31);
  assert(theI31Get instanceof binaryen.I31Get);
  assert(theI31Get instanceof binaryen.Expression);
  assertEq(theI31Get.i31, i31);
  assertEq(theI31Get.signed, true);
  assertEq(theI31Get.type, binaryen.i32);

  var info = binaryen.getExpressionInfo(theI31Get);
  assertEq(info.id, theI31Get.id);
  assertEq(info.type, theI31Get.type);
  assertEq(info.i31, theI31Get.i31);
  assertEq(info.isSigned, theI31Get.signed);

  theI31Get.i31 = i31 = module.local.get(2, binaryen.i31ref);
  assertEq(theI31Get.i31, i31);
  theI31Get.signed = false;
  assertEq(theI31Get.signed, false);
  theI31Get.type = binaryen.f64;
  theI31Get.finalize();
  assertEq(theI31Get.type, binaryen.i32);

  info = binaryen.getExpressionInfo(theI31Get);
  assertEq(info.type, theI31Get.type);
  assertEq(info.i31, theI31Get.i31);
  assertEq(info.isSigned, theI31Get.signed);

  console.log(theI31Get.toText());
  assert(
    theI31Get.toText()
    ==
    "(i31.get_u\n (local.get $2)\n)\n"
  );

  module.dispose();
})();
