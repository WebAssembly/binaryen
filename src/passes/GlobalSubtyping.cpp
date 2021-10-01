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
// Specializes types at the global level, altering fields etc. on the set of
// heap types defined in the module.
//

//#include "ir/subtypes.h" // Needed?
#include <ir/utils.h>
#include <pass.h>
#include <support/small_set.h>
#include <wasm.h>
#include <wasm-type.h>
#include <wasm-builder.h>

using namespace std;

namespace wasm {

namespace {

// A vector of the types of fields in a struct.
struct FieldTypes : public SmallVector<Type, 5> {
  void update(HeapType structType, Index fieldIndex, Type writtenType) {
    if (writtenType == Type::none) {
      // No information is present here.
      return;
    }
    resize(structType.getStruct().fields.size());
    if ((*this)[i] == Type::none) {
      // This is the first time we see this field.
      (*this)[i] = operand->type;
    } else {
      // TODO: unreachability. Or run DCE first?
      (*this)[i] = Type::getLeastUpperBound((*this)[i], operand->type);
    }
  }
};

// A map of all structs to their field types.
using AllFieldTypes = std::unordered_map<HeapType, FieldTypes>;

struct GlobalSubtyping : public Pass {
  // A map of functions to the information we collect in them in parallel.
  std::unordered_map<Function*, AllFieldTypes> functionInfo;

  // The information after we combine it across all functions.
  AllFieldTypes combinedInfo;

  void run(PassRunner* runner, Module* module) override {
    collectFunctionData(module);
    combineFunctionData();
  }

  void collectFunctionData(Module* module) {
    // Prepare the data structure for parallel operation.
    for (auto& func : module->functions) {
      functionInfo[func.get()];
    }

    struct CodeScanner
      : public WalkerPass<PostWalker<CodeScanner>> {
      bool isFunctionParallel() override { return true; }

      GlobalSubtyping& parent;

      CodeScanner(GlobalSubtyping& parent) : parent(parent) {}

      CodeScanner* create() override {
        return new CodeScanner(parent);
      }

      void visitStructNew(StructNew* curr) {
        // TODO: unreachability. Or run DCE first?
        auto heapType = curr->ref->type.getHeapType();
        for (Index i = 0; i < curr->operands.size(); i++) {
          update(heapType, i, curr->operands[i]->type);
        }
      }

      void visitStructSet(StructSet* curr) {
        // TODO: unreachability. Or run DCE first?
        update(curr->ref->type.getHeapType(), curr->index, curr->value->type);
      }

      void update(HeapType structType, Index fieldIndex, Type writtenType) {
        auto& funcInfo = parent.functionInfo[getFunction()];
        auto& fieldTypes = funcInfo[structType];
        fieldTypes.update(structType, fieldIndex, writtenType);
      }
    };

    CodeScanner updater(*this);
    updater.run(runner, module);
    updater.walkModuleCode(module);
  }

  void combineFunctionData() {
    for (auto& kv : functionInfo) {
      auto& allFieldTypes = kv.second;
      for (auto& kv : allFieldTypes) {
        auto heapType = kv.first;
        auto& fieldTypes = kv.second;

        auto& combinedFieldTypes = combinedInfo[heapType];

        for (Index i = 0; i < fieldTypes; i++) {
          combinedFieldTypes.update(heapType, i, fieldTypes[i]);
        }
      }
    }
  }
};

} // anonymous namespace

Pass* createGlobalSubtypingPass() { return new GlobalSubtyping(); }

} // namespace wasm
