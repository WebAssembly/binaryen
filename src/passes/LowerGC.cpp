/*
 * Copyright 2021 WebAssembly Community Group participants
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//
// Lowers Wasm GC to linear memory.
//
// Layouts:
//   Struct:
//     u32 rtt
//     fields...
//   Array:
//     u32 rtt
//     u32 size
//     fields...
//

#include "ir/module-utils.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

Type getLoweredType(Type type, Memory& memory) {
  // References and Rtts are pointers.
  if (type.isRef() || type.isRtt()) {
    return memory.indexType;
  }
  return type;
}

// The layout of a struct in linear memory.
struct Layout {
  // The total size of the struct.
  Address size;
  // The offsets of fields. Note that the first field's offset may not be 0,
  // as we need room for the rtt.
  SmallVector<Address, 4> fieldOffsets;
};

using Layouts = std::unordered_map<HeapType, Layout>;

struct LoweringInfo {
  Layouts layouts;

  Name malloc;

  Address pointerSize;
  Type pointerType;
};

// Lower GC instructions.
struct LowerGCCode
  : public WalkerPass<
      PostWalker<LowerGCCode, UnifiedExpressionVisitor<LowerGCCode>>> {
  bool isFunctionParallel() override { return true; }

  LoweringInfo* loweringInfo;

  using Parent =
    WalkerPass<PostWalker<LowerGCCode, UnifiedExpressionVisitor<LowerGCCode>>>;

  LowerGCCode* create() override { return new LowerGCCode(loweringInfo); }

  LowerGCCode(LoweringInfo* loweringInfo) : loweringInfo(loweringInfo) {}

  void visitExpression(Expression* curr) {
    // Update the type. This helps things like local.get, control flow
    // structures, etc.
    curr->type = lower(curr->type);
  }

  void visitRefNull(RefNull* curr) {
    replaceCurrent(LiteralUtils::makeZero(lower(curr->type), *getModule()));
  }

  void visitStructNew(StructNew* curr) {
    Builder builder(*getModule());
    auto type = relevantHeapTypes[curr];
    std::vector<Expression*> list;
    auto local = builder.addVar(getFunction(), loweringInfo->pointerType);
    // Malloc space for our struct.
    list.push_back(builder.makeLocalSet(
      local,
      builder.makeCall(
        loweringInfo->malloc,
        {builder.makeConst(int32_t(loweringInfo->layouts[type].size))},
        loweringInfo->pointerType)));
    // Store the rtt.
    list.push_back(
      builder.makeStore(loweringInfo->pointerSize,
                        0,
                        loweringInfo->pointerSize,
                        builder.makeLocalGet(local, loweringInfo->pointerType),
                        curr->rtt,
                        loweringInfo->pointerType));
    // Store the values, by representing them as StructSets.
    auto& fields = type.getStruct().fields;
    StructSet set(getModule()->allocator);
    set.ref = builder.makeLocalGet(local, loweringInfo->pointerType);
    for (Index i = 0; i < fields.size(); i++) {
      set.index = i;
      if (curr->isWithDefault()) {
        set.value = LiteralUtils::makeZero(fields[i].type, *getModule());
      } else {
        set.value = curr->operands[i];
      }
      list.push_back(lower(&set, type));
    }
    // Return the pointer.
    list.push_back(builder.makeLocalGet(local, loweringInfo->pointerType));
    replaceCurrent(builder.makeBlock(list));
  }

  void visitStructSet(StructSet* curr) { replaceCurrent(lower(curr)); }

  // Lower a StructSet. If a type is given, then we use that, otherwise we will
  // look up the type using relevantHeapTypes (which were computed by first
  // scanning all the code).
  Expression* lower(StructSet* curr, HeapType type = HeapType::any) {
    // TODO: ignore unreachable, or run dce before
    Builder builder(*getModule());
    if (type == HeapType::any) {
      type = relevantHeapTypes[curr];
    }
    auto& field = type.getStruct().fields[curr->index];
    auto loweredType = getLoweredType(field.type, getModule()->memory);
    return builder.makeStore(
      loweredType.getByteSize(),
      loweringInfo->layouts[type].fieldOffsets[curr->index],
      loweredType.getByteSize(),
      curr->ref,
      curr->value,
      loweredType);
  }

  void visitStructGet(StructGet* curr) { replaceCurrent(lower(curr)); }

  Expression* lower(StructGet* curr) {
    // TODO: ignore unreachable, or run dce before
    Builder builder(*getModule());
    auto type = relevantHeapTypes[curr];
    auto& field = type.getStruct().fields[curr->index];
    auto loweredType = getLoweredType(field.type, getModule()->memory);
    return builder.makeLoad(
      loweredType.getByteSize(),
      false, // TODO: signedness
      loweringInfo->layouts[type].fieldOffsets[curr->index],
      loweredType.getByteSize(),
      curr->ref,
      loweredType);
  }

  void visitArrayNew(ArrayNew* curr) {
    Builder builder(*getModule());
    auto type = relevantHeapTypes[curr];

    auto element = type.getArray().element;
    auto loweredElementType = getLoweredType(element.type, getModule()->memory);

    std::vector<Expression*> list;
    // Capture the inputs into locals.
    auto rttLocal = builder.addVar(getFunction(), Type::i32);
    auto sizeLocal = builder.addVar(getFunction(), Type::i32);
    auto initLocal = builder.addVar(getFunction(), Type::i32);
    list.push_back(builder.makeLocalSet(rttLocal, curr->rtt));
    list.push_back(builder.makeLocalSet(sizeLocal, curr->size));
    list.push_back(builder.makeLocalSet(initLocal, curr->init));
    // Compute the size of the array.
    auto* linearSize = builder.makeBinary(
      AddInt32,
      builder.makeBinary(
        MulInt32,
        builder.makeConst(int32_t(loweredElementType.getByteSize())),
        curr->size),
      // Room for the rtt and size.
      builder.makeConst(int32_t(8)));
    // Malloc space for our array.
    auto refLocal = builder.addVar(getFunction(), loweringInfo->pointerType);
    list.push_back(builder.makeLocalSet(
      refLocal,
      builder.makeCall(
        loweringInfo->malloc, {linearSize}, loweringInfo->pointerType)));
    // Store the rtt.
    list.push_back(builder.makeStore(
      loweringInfo->pointerSize,
      0,
      loweringInfo->pointerSize,
      builder.makeLocalGet(refLocal, loweringInfo->pointerType),
      curr->rtt,
      loweringInfo->pointerType));
    // Store the values, by representing them as ArraySets.
    auto counterLocal = builder.addVar(getFunction(), Type::i32);
    ArraySet setInitialValue(getModule()->allocator);
    setInitialValue.ref =
      builder.makeLocalGet(refLocal, loweringInfo->pointerType);
    if (!curr->isWithDefault()) {
      list.push_back(builder.makeLocalSet(initLocal, curr->init));
      setInitialValue.value =
        builder.makeLocalGet(initLocal, loweredElementType);
    } else {
      setInitialValue.value =
        LiteralUtils::makeZero(loweredElementType, *getModule());
    }
    Name loopName("loop");
    Name blockName("block");
    list.push_back(builder.makeLoop(
      loopName,
      builder.makeBlock(
        blockName,
        {builder.makeBreak(
           loopName,
           nullptr,
           builder.makeUnary(EqZInt32,
                             builder.makeLocalGet(counterLocal, Type::i32))),
         &setInitialValue,
         builder.makeLocalSet(
           counterLocal,
           builder.makeBinary(SubInt32,
                              builder.makeLocalGet(counterLocal, Type::i32),
                              builder.makeConst(int32_t(1)))),
         builder.makeBreak(loopName)})));
    // Return the pointer.
    list.push_back(builder.makeLocalGet(refLocal, loweringInfo->pointerType));
    replaceCurrent(builder.makeBlock(list));
  }

  void visitArraySet(ArraySet* curr) { replaceCurrent(lower(curr)); }

  // Lower a ArraySet. If a type is given, then we use that, otherwise we will
  // look up the type using relevantHeapTypes (which were computed by first
  // scanning all the code).
  Expression* lower(ArraySet* curr, HeapType type = HeapType::any) {
    // TODO: ignore unreachable, or run dce before
    Builder builder(*getModule());
    if (type == HeapType::any) {
      type = relevantHeapTypes[curr];
    }
    auto element = type.getArray().element;
    auto loweredType = getLoweredType(element.type, getModule()->memory);
    // Note that we carefully keep the inputs in the same order as we use them,
    // so we do not need to save them to locals first.
    return builder.makeStore(
      loweredType.getByteSize(),
      0,
      loweredType.getByteSize(),
      makeArrayAddress(curr->ref, curr->index, loweredType),
      curr->value,
      loweredType);
  }

  void visitArrayGet(ArrayGet* curr) { replaceCurrent(lower(curr)); }

  Expression* lower(ArrayGet* curr) {
    // TODO: ignore unreachable, or run dce before
    Builder builder(*getModule());
    auto type = relevantHeapTypes[curr];
    auto element = type.getArray().element;
    auto loweredType = getLoweredType(element.type, getModule()->memory);
    // Note that we carefully keep the inputs in the same order as we use them,
    // so we do not need to save them to locals first.
    return builder.makeLoad(
      loweredType.getByteSize(),
      false, // TODO: signedness
      0,
      loweredType.getByteSize(),
      makeArrayAddress(curr->ref, curr->index, loweredType),
      loweredType);
  }

  void visitRttCanon(RttCanon* curr) {
    // FIXME actual rtt allocations and values
    replaceCurrent(LiteralUtils::makeZero(lower(curr->type), *getModule()));
  }

  void doWalkFunction(Function* func) {
    // Lower the types on the function itself.
    std::vector<Type> params;
    for (auto t : func->sig.params) {
      params.push_back(lower(t));
    }
    std::vector<Type> results;
    for (auto t : func->sig.results) {
      results.push_back(lower(t));
    }
    func->sig = Signature(Type(params), Type(results));
    for (auto& t : func->vars) {
      t = lower(t);
    }

    // Scan the function for types we will need later. We cannot do this in a
    // single pass, as we cannot e.g. lower the rtt a struct operation receives
    // before we process the struct (if we did, the struct would not receive the
    // heap type, and we would not know what to lower).
    struct Scanner : public PostWalker<Scanner> {
      std::unordered_map<Expression*, HeapType> relevantHeapTypes;

      void visitStructNew(StructNew* curr) {
        relevantHeapTypes[curr] = curr->rtt->type.getHeapType();
      }
      void visitStructGet(StructGet* curr) {
        relevantHeapTypes[curr] = curr->ref->type.getHeapType();
      }
      void visitStructSet(StructSet* curr) {
        relevantHeapTypes[curr] = curr->ref->type.getHeapType();
      }

      void visitArrayNew(ArrayNew* curr) {
        relevantHeapTypes[curr] = curr->rtt->type.getHeapType();
      }
      void visitArrayGet(ArrayGet* curr) {
        relevantHeapTypes[curr] = curr->ref->type.getHeapType();
      }
      void visitArraySet(ArraySet* curr) {
        relevantHeapTypes[curr] = curr->ref->type.getHeapType();
      }
    } scanner;
    scanner.walk(func->body);
    relevantHeapTypes = std::move(scanner.relevantHeapTypes);

    // Lower all the code.
    Parent::doWalkFunction(func);

    // Ensure unique names for the loops that we created.
    UniqueNameMapper::uniquify(func->body);
  }

private:
  std::unordered_map<Expression*, HeapType> relevantHeapTypes;

  Type lower(Type type) { return getLoweredType(type, getModule()->memory); }

  Expression* makeArrayAddress(Expression* ref, Expression* index, Type loweredType) {
    Builder builder(*getModule());
    return builder.makeBinary(
      AddInt32,
      builder.makeBinary(AddInt32, ref, builder.makeConst(int32_t(8))),
      builder.makeBinary(
        MulInt32,
        builder.makeConst(int32_t(loweredType.getByteSize())),
        index)
    );
  }
};

} // anonymous namespace

struct LowerGC : public Pass {
  void run(PassRunner* runner, Module* module_) override {
    module = module_;
    std::cout << "add mem\n";
    addMemory();
    std::cout << "add run\n";
    addRuntime();
    std::cout << "comp layouts\n";
    computeStructLayouts();
    std::cout << "lower code\n";
    lowerCode(runner);
  }

private:
  Module* module;

  LoweringInfo loweringInfo;

  void addMemory() {
    module->memory.exists = true;

    // 16MB, arbitrarily for now.
    module->memory.initial = module->memory.max = 256;

    assert(!module->memory.is64());
    loweringInfo.pointerSize = 4;
    loweringInfo.pointerType = module->memory.indexType;
  }

  void addRuntime() {
    Builder builder(*module);
    auto* nextMalloc =
      module->addGlobal(builder.makeGlobal("nextMalloc",
                                           Type::i32,
                                           builder.makeConst(int32_t(0)),
                                           Builder::Mutable));
    loweringInfo.malloc = "malloc";
    // TODO: more than a simple bump allocator that never frees or collects.
    module->addFunction(builder.makeFunction(
      "malloc",
      {Type::i32, Type::i32},
      {},
      builder.makeSequence(
        builder.makeGlobalSet(
          nextMalloc->name,
          builder.makeBinary(AddInt32,
                             builder.makeGlobalGet(nextMalloc->name, Type::i32),
                             builder.makeLocalGet(0, Type::i32))),
        builder.makeBinary(SubInt32,
                           builder.makeGlobalGet(nextMalloc->name, Type::i32),
                           builder.makeLocalGet(0, Type::i32)))));
  }

  void computeStructLayouts() {
    // Collect all the heap types in order to analyze them and decide on their
    // layout in linear memory.
    std::vector<HeapType> types;
    std::unordered_map<HeapType, Index> typeIndices;
    ModuleUtils::collectHeapTypes(*module, types, typeIndices);
    for (auto type : types) {
      if (type.isStruct()) {
        computeLayout(type, loweringInfo.layouts[type]);
      }
    }
  }

  void computeLayout(HeapType type, Layout& layout) {
    // A pointer to the RTT takes up the first bytes in the struct, so fields
    // start afterwards.
    Address nextField = loweringInfo.pointerSize;
    auto& fields = type.getStruct().fields;
    for (auto& field : fields) {
      layout.fieldOffsets.push_back(nextField);
      // TODO: packed types? for now, always use i32 for them
      nextField =
        nextField + getLoweredType(field.type, module->memory).getByteSize();
    }
    layout.size = nextField;
  }

  void lowerCode(PassRunner* runner) {
    PassRunner subRunner(runner);
    subRunner.add(
      std::unique_ptr<LowerGCCode>(LowerGCCode(&loweringInfo).create()));
    subRunner.setIsNested(true);
    subRunner.run();

    LowerGCCode(&loweringInfo).walkModuleCode(module);
  }
};

Pass* createLowerGCPass() { return new LowerGC(); }

} // namespace wasm
