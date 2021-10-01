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

#include "ir/subtypes.h"
#include "ir/type-updating.h"
#include <ir/utils.h>
#include <pass.h>
#include <support/small_set.h>
#include <wasm.h>
#include <wasm-type.h>
#include <wasm-builder.h>

using namespace std;

namespace wasm {

namespace {

// Find the LUB of two types, but also when considering none to be "no
// information".
Type mergeNonNoneTypes(Type a, Type b) {
  if (a == Type::none) {
    return b;
  }
  if (b == Type::none) {
    return a;
  }
  return Type::getLeastUpperBound(a, b);
}

// A vector of the types of fields in a struct.
struct FieldTypes : public SmallVector<Type, 5> {
  void update(HeapType structType, Index i, Type writtenType) {
    resize(structType.getStruct().fields.size());
    (*this)[i] = mergeNonNoneTypes((*this)[i], writtenType);
  }
};

// A map of all structs to their field types.
using AllFieldTypes = std::unordered_map<HeapType, FieldTypes>;

struct GlobalSubtyping : public Pass {
  // A map of functions to the information we collect in them in parallel.
  std::unordered_map<Function*, AllFieldTypes> functionInfo;

  // The information after we combine it across all functions.
  AllFieldTypes combinedInfo;

  Module* module;

  void run(PassRunner* runner, Module* module_) override {
    if (getTypeSystem() != TypeSystem::Nominal) {
      Fatal() << "ConstantFieldPropagation requires nominal typing";
    }

    module = module_;

    collectFunctionData(module);
    combineFunctionData();
    optimize(module);
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
        auto heapType = curr->type.getHeapType();
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
    PassRunner runner(module);
    updater.run(&runner, module);
    updater.walkModuleCode(module);
  }

  void combineFunctionData() {
    for (auto& kv : functionInfo) {
      auto& allFieldTypes = kv.second;
      for (auto& kv : allFieldTypes) {
        auto heapType = kv.first;
        auto& fieldTypes = kv.second;

        auto& combinedFieldTypes = combinedInfo[heapType];

        for (Index i = 0; i < fieldTypes.size(); i++) {
          combinedFieldTypes.update(heapType, i, fieldTypes[i]);
        }
      }
    }
  }

  void optimize(Module* module) {
    class Updater : public GlobalTypeUpdater {
      GlobalSubtyping& parent;
      SubTypes subTypes;

    public:
      Updater(GlobalSubtyping& parent) : GlobalTypeUpdater(*parent.module), parent(parent), subTypes(*parent.module) {}

      virtual void modifyStruct(HeapType oldStructType, Struct& struct_) {
std::cout << "mS " << oldStructType << "\n";
        auto& oldFields = oldStructType.getStruct().fields;
        auto& observedFieldTypes = parent.combinedInfo[oldStructType];
        for (Index i = 0; i < oldFields.size(); i++) {
          // The relevant observed type is what has been written to us, but also
          // to all of our supertypes that have this field, as if one of them
          // specializes the type then we must as well.
          // TODO: this is quadratic overall
          auto observedType = observedFieldTypes[i];
          auto curr = oldStructType;
          while (1) {
            HeapType super;
            if (!curr.getSuperType(super)) {
              break;
            }
            if (i >= super.getStruct().fields.size()) {
              break;
            }
#if 0
            auto& superField = super.getStruct().fields[i];
            if (superField.mutable_ == Mutable) {
              // Mutable fields cannot be subtypes, unless they are 100%
              // identical, so we cannot make any changes there.
              abort();
            }
#endif
            observedType = mergeNonNoneTypes(observedType, parent.combinedInfo[super][i]);
            curr = super;
          }

          auto oldType = oldFields[i].type;
          if (observedType == Type::none || observedType == oldType) {
            continue;
          }
          assert(Type::isSubType(observedType, oldFields[i].type));

          // We must also preseve the property that subtypes of us have fields
          // that are subtypes of this new type.
          // TODO: this is quadratic overall

#if 0
auto* frist = parent.module->functions[0].get();
auto param = frist->getLocalType(0);
std::cout << "param: " << param << " : " << oldStructType << " : " << (param == oldStructType) << '\n';
#endif
          auto work = subTypes.getSubTypes(oldStructType);
std::cout << "look at subtypes\n";
          while (!work.empty()) {
std::cout << "  iter\n";
            auto iter = work.begin();
            auto currSubType = *iter;
            work.erase(iter);
            auto& currFields = parent.combinedInfo[currSubType];
            auto currType = currFields[i];
            if (currType != Type::none) {
              observedType = Type::getLeastUpperBound(observedType, currType);
              if (observedType == oldType) {
                // We failed to specialize.
                break;
              }
            }
            for (auto subType : subTypes.getSubTypes(currSubType)) {
              work.insert(subType);
            }
          }
          if (observedType == oldType) {
            continue;
          }

          // Success! Apply the new observed type in this field.
          struct_.fields[i].type = getTempType(observedType);
        }
      }
    };

    Updater(*this).update();
  }
};

} // anonymous namespace

Pass* createGlobalSubtypingPass() { return new GlobalSubtyping(); }

} // namespace wasm
