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

struct LowerGC : public Pass {
  // The layout of a struct in linear memory.
  struct Layout {
    // The total size of the struct.
    Address size;
    // The offsets of fields. Note that the first field's offset may not be 0,
    // as we need room for the rtt.
    SmallVector<Address, 4> fieldOffsets;
  };

  void run(PassRunner* runner, Module* module_) override {
    module = module_;
    addMemory();
    computeStructLayouts();
  }

private:
  Module* module;

  // Layouts of all the structs in the module
  std::unordered_map<HeapType, Layout> layouts;

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
      nextField = nextField + getLoweredByteSize(field.type);
    }
  }

  // Get the size of a type after lowering it.
  // TODO: packed types? for now, always use i32 for them
  Address getLoweredByteSize(Type type) {
    // References and Rtts are pointers.
    if (type.isRef() || type.isRtt()) {
      return pointerSize;
    }
    return type.getByteSize();
  }
};

Pass* createLowerGCPass() { return new LowerGC(); }

} // namespace wasm
