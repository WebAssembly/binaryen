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
// Optimize types at the global level, altering fields etc. on the set of heap
// types defined in the module.
//
//  * Immutability: If a field has no struct.set, it can become immutable.
//
// TODO: Specialize field types.
// TODO: Remove unused fields.
//

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

// Information about usage of a field.
struct FieldInfo {
  bool hasWrite = false;

  void noteWrite() { hasWrite = true; }

  bool combine(const FieldInfo& other) {
    if (!hasWrite && other.hasWrite) {
      hasWrite = true;
      return true;
    }
    return false;
  }
};

struct FieldInfoScanner : public Scanner<FieldInfo, FieldInfoScanner> {
  Pass* create() override {
    return new FieldInfoScanner(functionNewInfos, functionSetInfos);
  }

  FieldInfoScanner(FunctionStructValuesMap<FieldInfo>& functionNewInfos,
                   FunctionStructValuesMap<FieldInfo>& functionSetInfos)
    : Scanner<FieldInfo, FieldInfoScanner>(functionNewInfos, functionSetInfos) {
  }

  void noteExpression(Expression* expr,
                      HeapType type,
                      Index index,
                      FieldInfo& info) {
    info.noteWrite();
  }

  void
  noteDefault(Type fieldType, HeapType type, Index index, FieldInfo& info) {
    info.noteWrite();
  }

  void noteCopy(HeapType type, Index index, FieldInfo& info) {
    info.noteWrite();
  }
};

struct GlobalTypeOptimization : public Pass {
  void run(PassRunner* runner, Module* module) override {
    if (getTypeSystem() != TypeSystem::Nominal) {
      Fatal() << "GlobalTypeOptimization requires nominal typing";
    }

    // Find and analyze struct operations inside each function.
    FunctionStructValuesMap<FieldInfo> functionNewInfos(*module),
      functionSetInfos(*module);
    FieldInfoScanner scanner(functionNewInfos, functionSetInfos);
    scanner.run(runner, module);
    scanner.runOnModuleCode(runner, module);

    // Combine the data from the functions.
    StructValuesMap<FieldInfo> combinedNewInfos, combinedSetInfos;
    functionSetInfos.combineInto(combinedSetInfos);
    // TODO: combine newInfos as well, once we have a need for that (we will
    //       when we do things like subtyping).

    // Find which fields are immutable in all super- and sub-classes. To see
    // that, propagate sets in both directions. This is necessary because we
    // cannot have a supertype's field be immutable while a subtype's is not -
    // they must match for us to preserve subtyping.
    //
    // Note that we do not need to care about types here: If the fields were
    // mutable before, then they must have had identical types for them to be
    // subtypes (as wasm only allows the type to differ if the fields are
    // immutable). Note that by making more things immutable we therefore make
    // it possible to apply more specific subtypes in subtype fields.
    TypeHierarchyPropagator<FieldInfo> propagator(*module);
    propagator.propagateToSuperAndSubTypes(combinedSetInfos);

    // Maps types to a vector of booleans that indicate if we can turn the
    // field immutable. To avoid eager allocation of memory, the vectors are
    // only resized when we actually have a true to place in them (which is
    // rare).
    using CanBecomeImmutable = std::unordered_map<HeapType, std::vector<bool>>;
    CanBecomeImmutable canBecomeImmutable;

    for (auto type : propagator.subTypes.types) {
      if (!type.isStruct()) {
        continue;
      }

      auto& fields = type.getStruct().fields;
      for (Index i = 0; i < fields.size(); i++) {
        if (fields[i].mutable_ == Immutable) {
          // Already immutable; nothing to do.
          continue;
        }

        if (combinedSetInfos[type][i].hasWrite) {
          // A set exists.
          continue;
        }

        // No set exists. Mark it as something we can make immutable.
        auto& vec = canBecomeImmutable[type];
        vec.resize(i + 1);
        vec[i] = true;
      }
    }

    // The types are now generally correct, except for their internals, which we
    // rewrite now.
    class TypeRewriter : public GlobalTypeRewriter {
      CanBecomeImmutable& canBecomeImmutable;

    public:
      TypeRewriter(Module& wasm, CanBecomeImmutable& canBecomeImmutable)
        : GlobalTypeRewriter(wasm), canBecomeImmutable(canBecomeImmutable) {}

      virtual void modifyStruct(HeapType oldStructType, Struct& struct_) {
        if (!canBecomeImmutable.count(oldStructType)) {
          return;
        }

        auto& newFields = struct_.fields;
        auto& immutableVec = canBecomeImmutable[oldStructType];
        for (Index i = 0; i < immutableVec.size(); i++) {
          if (immutableVec[i]) {
            newFields[i].mutable_ = Immutable;
          }
        }
      }
    };

    TypeRewriter(*module, canBecomeImmutable).update();
  }
};

} // anonymous namespace

Pass* createGlobalTypeOptimizationPass() {
  return new GlobalTypeOptimization();
}

} // namespace wasm
