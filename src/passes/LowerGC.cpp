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
    // Update the type.
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
      list.push_back(lower(&set));
    }
    // Return the pointer.
    list.push_back(builder.makeLocalGet(local, loweringInfo->pointerType));
    replaceCurrent(builder.makeBlock(list));
  }

  void visitStructSet(StructSet* curr) { replaceCurrent(lower(curr)); }

  Expression* lower(StructSet* curr) {
    // TODO: ignore unreachable, or run dce before
    Builder builder(*getModule());
    auto type = relevantHeapTypes[curr];
    auto& field = type.getStruct().fields[curr->index];
    auto loweredType = getLoweredType(field.type, getModule()->memory);
std::cout << "maek store " << *curr->ref << " : " << *curr->value << " : " << loweredType << '\n';
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
    } scanner;
    scanner.walk(func->body);
    relevantHeapTypes = std::move(scanner.relevantHeapTypes);

    // Lower all the code.
    Parent::doWalkFunction(func);
  }

private:
  std::unordered_map<Expression*, HeapType> relevantHeapTypes;

  Type lower(Type type) { return getLoweredType(type, getModule()->memory); }
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
    loweringInfo.malloc = "malloc";
    /*
    auto* malloc = module->addFunction(builder.makeFunction(
      "malloc", { Type::i32, Type::i32 }, {},
      builder.makeSequence(
        builder.makeGlobalSet(
        builder.makeBinary(
        ),
        builder.makeBinary(
        ),
      )
      ));
    */
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
