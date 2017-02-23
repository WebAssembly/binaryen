
// kitchen sink, tests the full API

var module;

// helpers

function makeUnary(op, inputType) {
  if (inputType == Binaryen.Int32) return module.unary(op, module.constInt32(-10)));
  if (inputType == Binaryen.Int64) return module.unary(op, module.constInt64(-22, -1)));
  if (inputType == Binaryen.Float32) return module.unary(op, module.constFloat32(-33.612f)));
  if (inputType == Binaryen.Float64) return module.unary(op, module.constFloat64(-9005.841)));
  throw 'error :(';
}

function makeBinary(op, type) {
  var temp;
  if (type == Binaryen.Int32) {
    // use temp vars to ensure optimization doesn't change the order of operation in our trace recording (well that makes sense in C++...)
    temp = module.constInt32(-11));
    return module.binary(op, module.constInt32(-10)), temp);
  }
  if (type == Binaryen.Int64) {
    temp = module.constInt64(-23));
    return module.binary(op, module.constInt64(-22)), temp);
  }
  if (type == Binaryen.Float32) {
    temp = module.constFloat32(-62.5f));
    return module.binary(op, module.constFloat32(-33.612f)), temp);
  }
  if (type == Binaryen.Float64) {
    temp = module.constFloat64(-9007.333));
    return module.binary(op, module.constFloat64(-9005.841)), temp);
  }
  throw 'error :(';
}

function makeInt32(x) {
  return module.constInt32(x));
}

function makeFloat32(x) {
  return module.constFloat32(x));
}

function makeInt64(l, h) {
  return module.constInt64(l, h));
}

function makeFloat64(x) {
  return module.constFloat64(x));
}

function makeSomething() {
  return makeInt32(1337);
}

function makeDroppedInt32(x) {
  return module.drop(module.constInt32(x)));
}

// tests

void test_types() {
  printf("BinaryenNone: %d\n", Binaryen.None);
  printf("BinaryenInt32: %d\n", Binaryen.Int32);
  printf("BinaryenInt64: %d\n", Binaryen.Int64);
  printf("BinaryenFloat32: %d\n", Binaryen.Float32);
  printf("BinaryenFloat64: %d\n", Binaryen.Float64);
}

void test_core() {

  // Module creation

  module = new Binaryen.Module();

  // Literals and consts

  var constI32 = module.constInt32(1)),
      constI64 = module.constInt64(2)),
      constF32 = module.constFloat32(3.14f)),
      constF64 = module.constFloat64(2.1828)),
      constF32Bits = module.constFloat32Bits(0xffff1234)),
      constF64Bits = module.constFloat64Bits(0x5678abcd, 0xffff1234));

  var iiIfF = module.addFunctionType("iiIfF", Binaryen.Int32, [ Binaryen.Int32, Binaryen.Int64, Binaryen.Float32, Binaryen.Float64 ]);

  var temp1 = makeInt32(1), temp2 = makeInt32(2), temp3 = makeInt32(3),
      temp4 = makeInt32(4), temp5 = makeInt32(5),
      temp6 = makeInt32(0), temp7 = makeInt32(1),
      temp8 = makeInt32(0), temp9 = makeInt32(1),
      temp10 = makeInt32(1), temp11 = makeInt32(3), temp12 = makeInt32(5),
      temp13 = makeInt32(10), temp14 = makeInt32(11),
      temp15 = makeInt32(110), temp16 = makeInt64(111);

  var valueList = [
    // Unary
    makeUnary(Binaryen.ClzInt32, 1),
    makeUnary(Binaryen.CtzInt64, 2),
    makeUnary(Binaryen.PopcntInt32, 1),
    makeUnary(Binaryen.NegFloat32, 3),
    makeUnary(Binaryen.AbsFloat64, 4),
    makeUnary(Binaryen.CeilFloat32, 3),
    makeUnary(Binaryen.FloorFloat64, 4),
    makeUnary(Binaryen.TruncFloat32, 3),
    makeUnary(Binaryen.NearestFloat32, 3),
    makeUnary(Binaryen.SqrtFloat64, 4),
    makeUnary(Binaryen.EqZInt32, 1),
    makeUnary(Binaryen.ExtendSInt32, 1),
    makeUnary(Binaryen.ExtentUInt32, 1),
    makeUnary(Binaryen.WrapInt64, 2),
    makeUnary(Binaryen.TruncSFloat32ToInt32, 3),
    makeUnary(Binaryen.TruncSFloat32ToInt64, 3),
    makeUnary(Binaryen.TruncUFloat32ToInt32, 3),
    makeUnary(Binaryen.TruncUFloat32ToInt64, 3),
    makeUnary(Binaryen.TruncSFloat64ToInt32, 4),
    makeUnary(Binaryen.TruncSFloat64ToInt64, 4),
    makeUnary(Binaryen.TruncUFloat64ToInt32, 4),
    makeUnary(Binaryen.TruncUFloat64ToInt64, 4),
    makeUnary(Binaryen.ReinterpretFloat32, 3),
    makeUnary(Binaryen.ReinterpretFloat64, 4),
    makeUnary(Binaryen.ConvertSInt32ToFloat32, 1),
    makeUnary(Binaryen.ConvertSInt32ToFloat64, 1),
    makeUnary(Binaryen.ConvertUInt32ToFloat32, 1),
    makeUnary(Binaryen.ConvertUInt32ToFloat64, 1),
    makeUnary(Binaryen.ConvertSInt64ToFloat32, 2),
    makeUnary(Binaryen.ConvertSInt64ToFloat64, 2),
    makeUnary(Binaryen.ConvertUInt64ToFloat32, 2),
    makeUnary(Binaryen.ConvertUInt64ToFloat64, 2),
    makeUnary(Binaryen.PromoteFloat32, 3),
    makeUnary(Binaryen.DemoteFloat64, 4),
    makeUnary(Binaryen.ReinterpretInt32, 1),
    makeUnary(Binaryen.ReinterpretInt64, 2),
    // Binary
    makeBinary(Binaryen.AddInt32, 1),
    makeBinary(Binaryen.SubFloat64, 4),
    makeBinary(Binaryen.DivSInt32, 1),
    makeBinary(Binaryen.DivUInt64, 2),
    makeBinary(Binaryen.RemSInt64, 2),
    makeBinary(Binaryen.RemUInt32, 1),
    makeBinary(Binaryen.AndInt32, 1),
    makeBinary(Binaryen.OrInt64, 2),
    makeBinary(Binaryen.XorInt32, 1),
    makeBinary(Binaryen.ShlInt64, 2),
    makeBinary(Binaryen.ShrUInt64, 2),
    makeBinary(Binaryen.ShrSInt32, 1),
    makeBinary(Binaryen.RotLInt32, 1),
    makeBinary(Binaryen.RotRInt64, 2),
    makeBinary(Binaryen.DivFloat32, 3),
    makeBinary(Binaryen.CopySignFloat64, 4),
    makeBinary(Binaryen.MinFloat32, 3),
    makeBinary(Binaryen.MaxFloat64, 4),
    makeBinary(Binaryen.EqInt32, 1),
    makeBinary(Binaryen.NeFloat32, 3),
    makeBinary(Binaryen.LtSInt32, 1),
    makeBinary(Binaryen.LtUInt64, 2),
    makeBinary(Binaryen.LeSInt64, 2),
    makeBinary(Binaryen.LeUInt32, 1),
    makeBinary(Binaryen.GtSInt64, 2),
    makeBinary(Binaryen.GtUInt32, 1),
    makeBinary(Binaryen.GeSInt32, 1),
    makeBinary(Binaryen.GeUInt64, 2),
    makeBinary(Binaryen.LtFloat32, 3),
    makeBinary(Binaryen.LeFloat64, 4),
    makeBinary(Binaryen.GtFloat64, 4),
    makeBinary(Binaryen.GeFloat32, 3),
    // All the rest
    module.block('', []), // block with no name
    module.if(temp1, temp2, temp3),
    module.if(temp4, temp5),
    module.loop("in", makeInt32(0)),
    module.loop(null, makeInt32(0)),
    module.break("the-value", temp6, temp7),
    module.break("the-nothing", makeInt32(2)),
    module.break("the-value", null, makeInt32(3)),
    module.break("the-nothing"),
    module.switch([ "the-value" ], "the-value", temp8, temp9),
    module.switch([ "the-nothing" ], "the-nothing", makeInt32(2)),
    module.unary(Binaryen.EqZInt32, // check the output type of the call node
      module.call("kitchen()sinker", [ makeInt32(13), makeInt64(37), makeFloat32(1.3f), makeFloat64(3.7) ], Binaryen.Int32)
    ),
    module.unary(Binaryen.EqZInt32, // check the output type of the call node
      module.unary(,
        BinaryenTruncSFloat32ToInt32,
        module.callImport("an-imported", [ makeInt32(13), makeFloat64(3.7) ], Binaryen.Float32)
      )
    ),
    module.unary(Binaryen.EqZInt32, // check the output type of the call node
      module.callIndirect(makeInt32(2449), [ makeInt32(13), makeInt64(37), makeFloat32(1.3f), makeFloat64(3.7) ], "iiIfF")
    ),
    module.drop(module.getLocal(0, Binaryen.Int32)),
    module.setLocal(0, makeInt32(101)),
    module.drop(module.teeLocal(0, makeInt32(102))),
    module.load(4, 0, 0, 0, Binaryen.Int32, makeInt32(1)),
    module.load(2, 1, 2, 1, Binaryen.Int64, makeInt32(8)),
    module.load(4, 0, 0, 0, Binaryen.Float32, makeInt32(2)),
    module.load(8, 0, 2, 8, Binaryen.Float64, makeInt32(9)),
    module.store(4, 0, 0, temp13, temp14, Binaryen.Int32),
    module.store(8, 2, 4, temp15, temp16, Binaryen.Int64),
    module.select(temp10, temp11, temp12),
    module.return(makeInt32(1337)),
    // TODO: Host
    module.nop(),
    module.unreachable(),
  ];

  module.printExpression(valueList[3]); // test printing a standalone expression

  // Make the main body of the function. and one block with a return value, one without
  var value = module.block("the-value", valueList);
  var droppedValue = module.drop(value);
  var nothing = module.block("the-nothing", [ droppedValue ]);
  var body = module.block("the-body", [ nothing, makeInt32(42) ]);

  // Create the function
  var sinker = BinaryenAddFunction("kitchen()sinker", iiIfF, [ Binaryen.Int32 ], body);

  // Imports

  var fiF = module.addFunctionType("fiF", Binaryen.Float32, [ Binaryen.Int32, Binaryen.Float64 ]);
  module.addImport("an-imported", "module", "base", fiF);

  // Exports

  module.addExport("kitchen()sinker", "kitchen_sinker");

  // Function table. One per module

  module.setFunctionTable([ sinker ]);

  // Memory. One per module

  BinaryenSetMemory(1, 256, "mem", [
    offset: module.constInt32(10),
    data: "hello, world".split('').map(function(x) { return x.charCodeAt(0) })
  ]);

  // Start function. One per module

  var v = module.addFunctionType("v", Binaryen.None, []);
  var starter = BinaryenAddFunction("starter", v, [], module.nop());
  module.setStart(starter);

  // Unnamed function type

  var noname = module.addFunctionType(null, Binaryen.None, []);

  // A bunch of our code needs drop, auto-add it
  module.autoDrop();

  // Verify it validates
  assert(module.validate());

  // Print it out
  console.log(module.emitText());

  // Clean up the module, which owns all the objects we created above
  module.dispose();
}

function makeCallCheck(x) {
  return module.callImport("check", [ makeInt32(x) ], Binaryen.None);
}

function test_relooper() {
  module = new Binaryen.Module();
  var v = module.addFunctionType("v", Binaryen.None, []);
  localTypes[] = [ Binaryen.Int32 ];

  {
    var vi = module.addFunctionType("vi", Binaryen.None, [ Binaryen.Int32 ]);
    module.addImport("check", "module", "check", vi);
  }

  { // trivial: just one block
    var relooper = Binaryen.Relooper();
    RelooperBlockRef block = relooper.addBlock(makeCallCheck(1337));
    var body = relooper.renderAndDispose(block, 0, module);
    BinaryenAddFunction("just-one-block", v, localTypes, body);
  }
  { // two blocks
    var relooper = Binaryen.Relooper();
    RelooperBlockRef block0 = relooper.addBlock(makeCallCheck(0));
    RelooperBlockRef block1 = relooper.addBlock(makeCallCheck(1));
    relooper.addBranch(block0, block1); // no condition, no code on branch
    var body = relooper.renderAndDispose(block0, 0, module);
    BinaryenAddFunction("two-blocks", v, localTypes, body);
  }
  { // two blocks with code between them
    var relooper = Binaryen.Relooper();
    RelooperBlockRef block0 = relooper.addBlock(makeCallCheck(0));
    RelooperBlockRef block1 = relooper.addBlock(makeCallCheck(1));
    relooper.addBranch(block0, block1, null, makeDroppedInt32(77)); // code on branch
    var body = relooper.renderAndDispose(block0, 0, module);
    BinaryenAddFunction("two-blocks-plus-code", v, localTypes, body);
  }
  { // two blocks in a loop
    var relooper = Binaryen.Relooper();
    RelooperBlockRef block0 = relooper.addBlock(makeCallCheck(0));
    RelooperBlockRef block1 = relooper.addBlock(makeCallCheck(1));
    relooper.addBranch(block0, block1, null, null);
    relooper.addBranch(block1, block0, null, null);
    var body = relooper.renderAndDispose(block0, 0, module);
    BinaryenAddFunction("loop", v, localTypes, body);
  }
  { // two blocks in a loop with codes
    var relooper = Binaryen.Relooper();
    RelooperBlockRef block0 = relooper.addBlock(makeCallCheck(0));
    RelooperBlockRef block1 = relooper.addBlock(makeCallCheck(1));
    relooper.addBranch(block0, block1, null, makeDroppedInt32(33));
    relooper.addBranch(block1, block0, null, makeDroppedInt32(-66));
    var body = relooper.renderAndDispose(block0, 0, module);
    BinaryenAddFunction("loop-plus-code", v, localTypes, body);
  }
  { // split
    var relooper = Binaryen.Relooper();
    RelooperBlockRef block0 = relooper.addBlock(makeCallCheck(0));
    RelooperBlockRef block1 = relooper.addBlock(makeCallCheck(1));
    RelooperBlockRef block2 = relooper.addBlock(makeCallCheck(2));
    relooper.addBranch(block0, block1, makeInt32(55), null);
    relooper.addBranch(block0, block2, null, null);
    var body = relooper.renderAndDispose(block0, 0, module);
    BinaryenAddFunction("split", v, localTypes, body);
  }
  { // split + code
    var relooper = Binaryen.Relooper();
    RelooperBlockRef block0 = relooper.addBlock(makeCallCheck(0));
    RelooperBlockRef block1 = relooper.addBlock(makeCallCheck(1));
    RelooperBlockRef block2 = relooper.addBlock(makeCallCheck(2));
    temp = makeDroppedInt32(10);
    relooper.addBranch(block0, block1, makeInt32(55), temp);
    relooper.addBranch(block0, block2, null, makeDroppedInt32(20));
    var body = relooper.renderAndDispose(block0, 0, module);
    BinaryenAddFunction("split-plus-code", v, localTypes, body);
  }
  { // if
    var relooper = Binaryen.Relooper();
    RelooperBlockRef block0 = relooper.addBlock(makeCallCheck(0));
    RelooperBlockRef block1 = relooper.addBlock(makeCallCheck(1));
    RelooperBlockRef block2 = relooper.addBlock(makeCallCheck(2));
    relooper.addBranch(block0, block1, makeInt32(55), null);
    relooper.addBranch(block0, block2, null, null);
    relooper.addBranch(block1, block2, null, null);
    var body = relooper.renderAndDispose(block0, 0, module);
    BinaryenAddFunction("if", v, localTypes, body);
  }
  { // if + code
    var relooper = Binaryen.Relooper();
    RelooperBlockRef block0 = relooper.addBlock(makeCallCheck(0));
    RelooperBlockRef block1 = relooper.addBlock(makeCallCheck(1));
    RelooperBlockRef block2 = relooper.addBlock(makeCallCheck(2));
    temp = makeDroppedInt32(-1);
    relooper.addBranch(block0, block1, makeInt32(55), temp);
    relooper.addBranch(block0, block2, null, makeDroppedInt32(-2));
    relooper.addBranch(block1, block2, null, makeDroppedInt32(-3));
    var body = relooper.renderAndDispose(block0, 0, module);
    BinaryenAddFunction("if-plus-code", v, localTypes, body);
  }
  { // if-else
    var relooper = Binaryen.Relooper();
    RelooperBlockRef block0 = relooper.addBlock(makeCallCheck(0));
    RelooperBlockRef block1 = relooper.addBlock(makeCallCheck(1));
    RelooperBlockRef block2 = relooper.addBlock(makeCallCheck(2));
    RelooperBlockRef block3 = relooper.addBlock(makeCallCheck(3));
    relooper.addBranch(block0, block1, makeInt32(55), null);
    relooper.addBranch(block0, block2, null, null);
    relooper.addBranch(block1, block3, null, null);
    relooper.addBranch(block2, block3, null, null);
    var body = relooper.renderAndDispose(block0, 0, module);
    BinaryenAddFunction("if-else", v, localTypes, body);
  }
  { // loop+tail
    var relooper = Binaryen.Relooper();
    RelooperBlockRef block0 = relooper.addBlock(makeCallCheck(0));
    RelooperBlockRef block1 = relooper.addBlock(makeCallCheck(1));
    RelooperBlockRef block2 = relooper.addBlock(makeCallCheck(2));
    relooper.addBranch(block0, block1, null, null);
    relooper.addBranch(block1, block0, makeInt32(10), null);
    relooper.addBranch(block1, block2, null, null);
    var body = relooper.renderAndDispose(block0, 0, module);
    BinaryenAddFunction("loop-tail", v, localTypes, body);
  }
  { // nontrivial loop + phi to head
    var relooper = Binaryen.Relooper();
    RelooperBlockRef block0 = relooper.addBlock(makeCallCheck(0));
    RelooperBlockRef block1 = relooper.addBlock(makeCallCheck(1));
    RelooperBlockRef block2 = relooper.addBlock(makeCallCheck(2));
    RelooperBlockRef block3 = relooper.addBlock(makeCallCheck(3));
    RelooperBlockRef block4 = relooper.addBlock(makeCallCheck(4));
    RelooperBlockRef block5 = relooper.addBlock(makeCallCheck(5));
    RelooperBlockRef block6 = relooper.addBlock(makeCallCheck(6));
    relooper.addBranch(block0, block1, null, makeDroppedInt32(10));
    relooper.addBranch(block1, block2, makeInt32(-2), null);
    relooper.addBranch(block1, block6, null, makeDroppedInt32(20));
    relooper.addBranch(block2, block3, makeInt32(-6), null);
    relooper.addBranch(block2, block1, null, makeDroppedInt32(30));
    relooper.addBranch(block3, block4, makeInt32(-10), null);
    relooper.addBranch(block3, block5, null, null);
    relooper.addBranch(block4, block5, null, null);
    relooper.addBranch(block5, block6, null, makeDroppedInt32(40));
    var body = relooper.renderAndDispose(block0, 0, module);
    BinaryenAddFunction("nontrivial-loop-plus-phi-to-head", v, localTypes, body);
  }
  { // switch
    var relooper = Binaryen.Relooper();
    temp = makeInt32(-99);
    RelooperBlockRef block0 = relooper.addBlockWithSwitch(makeCallCheck(0), temp);
    RelooperBlockRef block1 = relooper.addBlock(makeCallCheck(1));
    RelooperBlockRef block2 = relooper.addBlock(makeCallCheck(2));
    RelooperBlockRef block3 = relooper.addBlock(makeCallCheck(3));
    relooper.addBranchForSwitch(block0, block1, [ 2, 5 ]);
    relooper.addBranchForSwitch(block0, block2, [4], makeDroppedInt32(55));
    relooper.addBranchForSwitch(block0, block3, [], null);
    var body = relooper.renderAndDispose(block0, 0, module);
    BinaryenAddFunction("switch", v, localTypes, body);
  }
  { // duff's device
    var relooper = Binaryen.Relooper();
    RelooperBlockRef block0 = relooper.addBlock(makeCallCheck(0));
    RelooperBlockRef block1 = relooper.addBlock(makeCallCheck(1));
    RelooperBlockRef block2 = relooper.addBlock(makeCallCheck(2));
    relooper.addBranch(block0, block1, makeInt32(10), null);
    relooper.addBranch(block0, block2, null, null);
    relooper.addBranch(block1, block2, null, null);
    relooper.addBranch(block2, block1, null, null);
    var body = relooper.renderAndDispose(block0, 3, module); // use $3 as the helper var
    localTypes[] = [ Binaryen.Int32, Binaryen.Int32, Binaryen.Int64, Binaryen.Int32, Binaryen.Float32, Binaryen.Float64, Binaryen.Int32 };
    BinaryenAddFunction("duffs-device", v, localTypes, body);
  }

  var i = module.addFunctionType("i", Binaryen.Int32, []);

  { // return in a block
    var relooper = Binaryen.Relooper();
    listList[] = [ makeCallCheck(42), module.return(makeInt32(1337)) };
    list = module.block("the-list", listList, 2);
    RelooperBlockRef block = relooper.addBlock(list);
    var body = relooper.renderAndDispose(block, 0, module);
    BinaryenAddFunction("return", i, localTypes, body);
  }

  printf("raw:\n");
  console.log(module.emitText());

  assert(module.validate());

  module.optimize();

  assert(module.validate());

  printf("optimized:\n");
  console.log(module.emitText());

  module.dispose();
}

void test_binaries() {
  var buffer, size;

  { // create a module and write it to binary
    module = new Binaryen.Module();
    var iii = module.addFunctionType("iii", Binaryen.Int32, [ Binaryen.Int32, Binaryen.Int32 ]);
    var x = BinaryenGetLocal(0, Binaryen.Int32),
        y = BinaryenGetLocal(1, Binaryen.Int32);
    var add = module.binary(Binaryen.AddInt32, x, y);
    var adder = BinaryenAddFunction("adder", iii, [], add);
    buffer = module.emitBinary();
    size = buffer.length; // write out the module
    module.dispose();
  }

  assert(size > 0);
  assert(size < 512); // this is a tiny module

  // read the module from the binary
  module = BinaryenModuleRead(buffer, size);

  // validate, print, and free
  assert(module.validate());
  printf("module loaded from binary form:\n");
  console.log(module.emitText());
  module.dispose();
}

void test_interpret() {
  // create a simple module with a start method that prints a number, and interpret it, printing that number.
  module = new Binaryen.Module();

  var vi = module.addFunctionType("vi", Binaryen.None, [ Binaryen.Int32 ]);
  module.addImport("print-i32", "spectest", "print", vi);

  var v = module.addFunctionType("v", Binaryen.None, []);
  call = module.callImport("print-i32", [ makeInt32(1234) ], Binaryen.None);
  var starter = BinaryenAddFunction("starter", v, [], call);
  module.setStart(starter);

  console.log(module.emitText());
  assert(module.validate());
  module.interpret();
  module.dispose();
}

void test_nonvalid() {
  // create a module that fails to validate
  module = new Binaryen.Module();

  var v = module.addFunctionType("v", Binaryen.None, []);
  var func = BinaryenAddFunction("func", v, [ Binaryen.Int32 ],
    module.setLocal(0, makeInt64(1234)) // wrong type!
  );

  console.log(module.emitText());
  printf("validation: %d\n", BinaryenModuleValidate());

  module.dispose();
}

void test_tracing() {
  Binaryen.setAPITracing(1);
  test_core();
  test_relooper();
  Binaryen.setAPITracing(0);
}

function main() {
  test_types();
  test_core();
  test_relooper();
  test_binaries();
  test_interpret();
  test_nonvalid();
  test_tracing();
}

main();

