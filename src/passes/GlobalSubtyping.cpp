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
// Apply more specific subtypes to type fields where possible, where all the
// writes to that field in the entire program allow doing so.
//

#include "ir/effects.h"
#include "ir/localize.h"
#include "ir/struct-utils.h"
#include "ir/subtypes.h"
#include "ir/type-updating.h"
#include "ir/utils.h"
#include "pass.h"
#include "support/small_set.h"
#include "wasm-builder.h"
#include "wasm-type.h"
#include "wasm.h"

using namespace std;

namespace wasm {

namespace {

// We use a LUBFinder to track field info. A LUBFinder keeps track of the best
// possible LUB so far, as well as the list of nulls that might be updated in
// order to get a better LUB overall at the end.
using FieldInfo = LUBFinder;

struct FieldInfoScanner : public Scanner<FieldInfo, FieldInfoScanner> {
  Pass* create() override {
    return new FieldInfoScanner(functionNewInfos, functionSetGetInfos);
  }

  FieldInfoScanner(FunctionStructValuesMap<FieldInfo>& functionNewInfos,
                   FunctionStructValuesMap<FieldInfo>& functionSetGetInfos)
    : Scanner<FieldInfo, FieldInfoScanner>(functionNewInfos,
                                           functionSetGetInfos) {}

  void noteExpression(Expression* expr,
                      HeapType type,
                      Index index,
                      FieldInfo& info) {
    info.note(expr);
  }

  void
  noteDefault(Type fieldType, HeapType type, Index index, FieldInfo& info) {
    // Default values do not affect what the type of a field can be turned into,
    // as they are nullable, and we can ignore nulls there (LUBFinder will even
    // modify them, but here there isn't even anything to modify).
  }

  void noteCopy(HeapType type, Index index, FieldInfo& info) {
    // Copies do not add any type requirements at all: the type will always be
    // perfect.
  }

  void noteRead(HeapType type, Index index, FieldInfo& info) {
    // Nothing to do for a read, we just care about written values.
  }
};

struct GlobalSubtyping : public Pass {
  StructValuesMap<FieldInfo> finalInfos;

  void run(PassRunner* runner, Module* module) override {
    if (getTypeSystem() != TypeSystem::Nominal) {
      Fatal() << "GlobalSubtyping requires nominal typing";
    }

    // Find and analyze struct operations inside each function.
    FunctionStructValuesMap<FieldInfo> functionNewInfos(*module),
      functionSetGetInfos(*module);
    FieldInfoScanner scanner(functionNewInfos, functionSetGetInfos);
    scanner.run(runner, module);
    scanner.runOnModuleCode(runner, module);

    // Combine the data from the functions.
    StructValuesMap<FieldInfo> combinedNewInfos;
    StructValuesMap<FieldInfo> combinedSetGetInfos;
    functionNewInfos.combineInto(combinedNewInfos);
    functionSetGetInfos.combineInto(combinedSetGetInfos);

    // Propagate things written during new to subtypes, as they must also be
    // able to contain that type. Propagate things written using set to super-
    // types as well, as the reference might be to a supertype if the field is
    // present there.
    TypeHierarchyPropagator<FieldInfo> propagator(*module);
    propagator.propagateToSubTypes(combinedNewInfos);
    propagator.propagateToSuperAndSubTypes(combinedSetGetInfos);

    // Combine everything together.
    combinedNewInfos.combineInto(finalInfos);
    combinedSetGetInfos.combineInto(finalInfos);

    // Check if we found anything to improve.
    bool found = false;
    for (auto type : propagator.subTypes.types) {
      if (!type.isStruct()) {
        continue;
      }
      auto& fields = type.getStruct().fields;
      auto& infos = finalInfos[type];

      for (Index i = 0; i < fields.size(); i++) {
        auto oldType = fields[i].type;
        auto newType = finalInfos[type][i].get();
        if (newType != Type::unreachable && newType != oldType) {
          found = true;
          break;
        }
      }
      if (found) {
        break;
      }
    }
    if (found) {
      updateTypes(*module);
    }
  }

  void updateTypes(Module& wasm) {
    class TypeRewriter : public GlobalTypeRewriter {
      GlobalSubtyping& parent;

    public:
      TypeRewriter(Module& wasm, GlobalSubtyping& parent)
        : GlobalTypeRewriter(wasm), parent(parent) {}

      virtual void modifyStruct(HeapType oldStructType, Struct& struct_) {
        auto& newFields = struct_.fields;

        for (Index i = 0; i < newFields.size(); i++) {
          auto newType = newFields[i].type;
          if (newType.isRef() && newType.getHeapType().isStruct()) {
            newFields[i].type = getTempType(parent.finalInfos[oldStructType][i].get());
          }
        }
      }
    };

    TypeRewriter(wasm, *this).update();
  }
};

} // anonymous namespace

Pass* createGlobalSubtypingPass() {
  return new GlobalSubtyping();
}

} // namespace wasm
