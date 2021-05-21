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

// Lower GC instructions.
struct LowerGCCode : public WalkerPass<PostWalker<LowerGCCode>> {
  bool isFunctionParallel() override { return true; }

  Layouts* layouts;

  LowerGCCode* create() override { return new LowerGCCode(layouts); }

  LowerGCCode(Layouts* layouts) : layouts(layouts) {}

  void visitStructSet(StructSet* curr) {
    // TODO: ignore unreachable, or run dce before
    Builder builder(*getModule());
    auto type = curr->ref->type.getHeapType();
    auto& field = type.getStruct().fields[curr->index];
    auto loweredType = getLoweredType(field.type, getModule()->memory);
    replaceCurrent(
      builder.makeStore(
        loweredType.getByteSize(),
        (*layouts)[type].fieldOffsets[curr->index],
        loweredType.getByteSize(),
        curr->ref,
        curr->value,
        loweredType
      )
    );
  }

  void visitStructGet(StructGet* curr) {
    // TODO: ignore unreachable, or run dce before
    Builder builder(*getModule());
    auto type = curr->ref->type.getHeapType();
    auto& field = type.getStruct().fields[curr->index];
    auto loweredType = getLoweredType(field.type, getModule()->memory);
    replaceCurrent(
      builder.makeLoad(
        loweredType.getByteSize(),
        false, // TODO: signedness
        (*layouts)[type].fieldOffsets[curr->index],
        loweredType.getByteSize(),
        curr->ref,
        loweredType
      )
    );
  }
};

// Lower GC types on all instructions. For example, this turns a local.get from
// a reference to an i32. We must do this in a separate pass after LowerGCCode
// as we still need the heap types to be present while we lower instructions
// (because we use the heap types to figure out the layout of struct
// operations).
struct LowerGCTypes : public WalkerPass<PostWalker<LowerGCTypes, UnifiedExpressionVisitor<LowerGCTypes>>> {
  bool isFunctionParallel() override { return true; }

  LowerGCTypes* create() override { return new LowerGCTypes(); }

  void visitExpression(Expression* curr) {
    // Update the type.
    curr->type = lower(curr->type);
  }

  void visitFunction(Function* func) {
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
  }

private:
  Type lower(Type type) {
    return getLoweredType(type, getModule()->memory);
  }
};

} // anonymous namespace

struct LowerGC : public Pass {
  void run(PassRunner* runner, Module* module_) override {
    module = module_;
    addMemory();
    computeStructLayouts();
    lowerCode(runner);
  }

private:
  Module* module;

  // Layouts of all the structs in the module
  Layouts layouts;

  Address pointerSize;

  void addMemory() {
    module->memory.exists = true;

    // 16MB, arbitrarily for now.
    module->memory.initial = module->memory.max = 256;

    assert(!module->memory.is64());
    pointerSize = 4;
  }

  void computeStructLayouts() {
    // Collect all the heap types in order to analyze them and decide on their
    // layout in linear memory.
    std::vector<HeapType> types;
    std::unordered_map<HeapType, Index> typeIndices;
    ModuleUtils::collectHeapTypes(*module, types, typeIndices);
    for (auto type : types) {
      if (type.isStruct()) {
        computeLayout(type, layouts[type]);
      }
    }
  }

  void computeLayout(HeapType type, Layout& layout) {
    // A pointer to the RTT takes up the first bytes in the struct, so fields
    // start afterwards.
    Address nextField = pointerSize;
    auto& fields = type.getStruct().fields;
    for (auto& field : fields) {
      layout.fieldOffsets.push_back(nextField);
      // TODO: packed types? for now, always use i32 for them
      nextField = nextField + getLoweredType(field.type, module->memory).getByteSize();
    }
  }

  void lowerCode(PassRunner* runner) {
    PassRunner subRunner(runner);
    subRunner.add(std::unique_ptr<LowerGCCode>(LowerGCCode(&layouts).create()));
    subRunner.add(std::make_unique<LowerGCTypes>());
    subRunner.setIsNested(true);
    subRunner.run();

    LowerGCCode(&layouts).walkModuleCode(module);
    LowerGCTypes().walkModuleCode(module);
  }
};

Pass* createLowerGCPass() { return new LowerGC(); }

} // namespace wasm
