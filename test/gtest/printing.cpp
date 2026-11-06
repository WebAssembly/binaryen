#include "ir/module-utils.h"
#include "pass.h"
#include "print-test.h"
#include "wasm-binary.h"
#include "wasm-stack.h"
#include "wasm.h"

using namespace wasm;

using PrintingTest = PrintTest;

TEST_F(PrintingTest, Print) {
  auto moduleText = R"wasm(
    (module
      (func $a (result i32)
        (i32.const 10)
      )
      (func $b
        (drop
          (i32.const 20)
        )
      )
    )
  )wasm";

  Module wasm;
  parseWast(wasm, moduleText);

  {
    std::stringstream ss;
    ss << *wasm.getFunction("a");
    EXPECT_EQ(ss.str(), R"print((func $a (result i32)
 (i32.const 10)
)
)print");
  }
  {
    std::stringstream ss;
    ss << *wasm.getFunction("b");
    EXPECT_EQ(ss.str(), R"print((func $b
 (drop
  (i32.const 20)
 )
)
)print");
  }
}

TEST_F(PrintingTest, StackIRParams) {
  auto moduleText = R"wasm(
    (module
      (func $f (param $p i32) (result i32)
        (local $x i32)
        (block $b (result i32)
          (loop $l
            (try $t
              (do
                (try_table (catch_all $b)
                  (br_if $l (local.get $p))
                )
              )
              (catch_all
                (nop)
              )
            )
          )
          (if (result i32)
            (local.get $p)
            (then
              (i32.const 1)
            )
            (else
              (i32.const 2)
            )
          )
        )
      )
    )
  )wasm";

  Module wasm;
  wasm.features = FeatureSet::All;
  parseWast(wasm, moduleText);

  PassOptions options;
  ModuleStackIR moduleStackIR(wasm, options);
  auto* func = wasm.getFunction("f");
  auto* stackIR = moduleStackIR.getStackIROrNull(func);
  ASSERT_NE(stackIR, nullptr);

  TypeBuilder builder(1);
  builder[0] = Struct({Field(Type::i32, Mutable)});
  auto built = builder.build();
  ASSERT_TRUE(built);
  HeapType structType = (*built)[0];
  Type structRef(structType, Nullable);

  for (auto* inst : *stackIR) {
    if (!inst) {
      continue;
    }
    switch (inst->op) {
      case StackInst::BlockBegin: {
        inst->params = structRef;
        std::stringstream ss;
        ss << *inst;
        EXPECT_EQ(ss.str(),
                  "block $b (param (ref null $struct.0)) (result i32)");
        break;
      }
      case StackInst::LoopBegin: {
        inst->params = Type::i64;
        std::stringstream ss;
        ss << *inst;
        EXPECT_EQ(ss.str(), "loop $l (param i64)");
        break;
      }
      case StackInst::TryBegin: {
        inst->params = Type::f32;
        std::stringstream ss;
        ss << *inst;
        EXPECT_EQ(ss.str(), "try $t (param f32)");
        break;
      }
      case StackInst::TryTableBegin: {
        inst->params = Type::i32;
        std::stringstream ss;
        ss << *inst;
        EXPECT_EQ(ss.str(), "try_table (param i32) (catch_all $b)");
        break;
      }
      case StackInst::IfBegin: {
        inst->params = Type({Type::i32, Type::f64});
        std::stringstream ss;
        ss << *inst;
        EXPECT_EQ(ss.str(), "if (param i32 f64) (result i32)");
        break;
      }
      default:
        break;
    }
  }

  // Verify that getOptimizedIndexedHeapTypes collects control flow signatures
  // from StackIR as well as child heap types only referenced in
  // StackInst::params.
  auto indexedTypes =
    ModuleUtils::getOptimizedIndexedHeapTypes(wasm, &moduleStackIR);
  EXPECT_TRUE(indexedTypes.indices.contains(Signature(structRef, Type::i32)));
  EXPECT_TRUE(indexedTypes.indices.contains(structType));
  EXPECT_TRUE(indexedTypes.indices.contains(Signature(Type::i64, Type::none)));
  EXPECT_TRUE(indexedTypes.indices.contains(Signature(Type::f32, Type::none)));
  EXPECT_TRUE(indexedTypes.indices.contains(Signature(Type::i32, Type::none)));
  EXPECT_TRUE(indexedTypes.indices.contains(
    Signature(Type({Type::i32, Type::f64}), Type::i32)));
}

TEST_F(PrintingTest, StackIRParamBinaryAndOptimizer) {
  auto moduleText = R"wasm(
    (module
      (func $id (param $x i32) (result i32)
        (local $tmp i32)
        (local.set $tmp (local.get $x))
        (block $b (result i32)
          (i32.add
            (local.get $tmp)
            (i32.const 1)
          )
        )
      )
    )
  )wasm";

  Module wasm;
  wasm.features = FeatureSet::All;
  parseWast(wasm, moduleText);

  PassOptions options;
  options.optimizeLevel = 3;
  ModuleStackIR moduleStackIR(wasm, options);
  auto* func = wasm.getFunction("id");
  auto* stackIR = moduleStackIR.getStackIROrNull(func);
  ASSERT_NE(stackIR, nullptr);

  // Build a StackIR sequence where $b takes an i32 param from the stack and
  // adds it to a local.get inside the block:
  //   local.get $x
  //   local.set $tmp
  //   i32.const 10       ;; consumed as block param
  //   block $b (param i32) (result i32)
  //     local.get $tmp
  //     i32.add          ;; consumes block param + $tmp
  //     i32.const 0
  //     br_if $b
  //   end
  Builder irBuilder(wasm);
  auto* getX = irBuilder.makeLocalGet(0, Type::i32);
  auto* setTmp = irBuilder.makeLocalSet(1, getX);
  auto* c10 = irBuilder.makeConst(Literal(int32_t(10)));
  auto* getTmp = irBuilder.makeLocalGet(1, Type::i32);
  auto* add = irBuilder.makeBinary(AddInt32, c10, getTmp);
  auto* c0 = irBuilder.makeConst(Literal(int32_t(0)));
  auto* brIf = irBuilder.makeBreak("b", add, c0);
  auto* block = irBuilder.makeBlock("b", {brIf}, Type::i32);
  func->body = irBuilder.makeSequence(setTmp, block);

  auto makeInst = [&](StackInst::Op op, Expression* origin) {
    auto* inst = wasm.allocator.alloc<StackInst>();
    inst->op = op;
    inst->origin = origin;
    inst->type = origin->type;
    return inst;
  };

  auto* blockBegin = makeInst(StackInst::BlockBegin, block);
  blockBegin->params = Type::i32;
  auto* blockEnd = makeInst(StackInst::BlockEnd, block);

  *stackIR = {
    makeInst(StackInst::Basic, getX),
    makeInst(StackInst::Basic, setTmp),
    makeInst(StackInst::Basic, c10),
    blockBegin,
    makeInst(StackInst::Basic, getTmp),
    makeInst(StackInst::Basic, add),
    makeInst(StackInst::Basic, c0),
    makeInst(StackInst::Basic, brIf),
    blockEnd,
  };

  // Run StackIROptimizer: local2Stack must see that blockBegin consumes c10 and
  // pushes 1 parameter inside the block, so setTmp/getTmp cannot be eliminated
  // across the block boundary, and i32.add consumes both the block param and
  // getTmp without stack underflow.
  StackIROptimizer optimizer(func, *stackIR, options, wasm.features);
  optimizer.run();
  EXPECT_NE((*stackIR)[1], nullptr);
  EXPECT_NE((*stackIR)[4], nullptr);

  // Also test binary emission via StackIRToBinaryWriter: the block header must
  // emit the signature index for (param i32) (result i32).
  BufferWithRandomAccess moduleBuf;
  WasmBinaryWriter binaryWriter(&wasm, moduleBuf, options);
  BufferWithRandomAccess funcBuf;
  StackIRToBinaryWriter stackWriter(binaryWriter, funcBuf, func, *stackIR);
  stackWriter.write();

  // Verify the emitted bytes contain BinaryConsts::Block followed by the
  // signature index of (param i32) (result i32).
  auto sigIndex =
    binaryWriter.getSignatureIndex(Signature(Type::i32, Type::i32));
  bool foundParameterizedBlock = false;
  for (size_t i = 0; i + 1 < funcBuf.size(); ++i) {
    if (funcBuf[i] == uint8_t(BinaryConsts::Block) &&
        funcBuf[i + 1] == uint8_t(sigIndex)) {
      foundParameterizedBlock = true;
      break;
    }
  }
  EXPECT_TRUE(foundParameterizedBlock);
}
