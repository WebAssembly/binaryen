#include "ir/module-utils.h"
#include "pass.h"
#include "print-test.h"
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
