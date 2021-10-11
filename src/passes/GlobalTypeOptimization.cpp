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

#include "ir/effects.h"
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
  bool hasRead = false;

  void noteWrite() { hasWrite = true; }
  void noteRead() { hasRead = true; }

  bool combine(const FieldInfo& other) {
    bool changed = false;
    if (!hasWrite && other.hasWrite) {
      hasWrite = true;
      changed = true;
    }
    if (!hasRead && other.hasRead) {
      hasRead = true;
      changed = true;
    }
    return changed;
  }
};

struct FieldInfoScanner : public Scanner<FieldInfo, FieldInfoScanner> {
  Pass* create() override {
    return new FieldInfoScanner(functionNewInfos, functionSetInfos);
  }

  FieldInfoScanner(FunctionStructValuesMap<FieldInfo>& functionNewInfos,
                   FunctionStructValuesMap<FieldInfo>& functionSetGetInfos)
    : Scanner<FieldInfo, FieldInfoScanner>(functionNewInfos, functionSetGetInfos) {
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

  void noteRead(HeapType type, Index index, FieldInfo& info) {
std::cout << "read!\n";
    info.noteRead();
  }
};

struct GlobalTypeOptimization : public Pass {
  StructValuesMap<FieldInfo> combinedSetGetInfos;

  // Maps types to a vector of booleans that indicate whether a field can
  // become immutable. To avoid eager allocation of memory, the vectors are
  // only resized when we actually have a true to place in them (which is
  // rare).
  std::unordered_map<HeapType, std::vector<bool>> canBecomeImmutable;

  // Maps each field to its new index after field removals. That is, this
  // takes into account that fields before this one may have been removed,
  // which would then reduce this field's index. If a field itself is removed,
  // it has the special value |RemovedField|.
  static const Index RemovedField = Index(-1);
  std::unordered_map<HeapType, std::vector<Index>> indexesAfterRemovals;


  void run(PassRunner* runner, Module* module) override {
    if (getTypeSystem() != TypeSystem::Nominal) {
      Fatal() << "GlobalTypeOptimization requires nominal typing";
    }

    // Find and analyze struct operations inside each function.
    FunctionStructValuesMap<FieldInfo> functionNewInfos(*module),
      functionSetGetInfos(*module);
    FieldInfoScanner scanner(functionNewInfos, functionSetGetInfos);
    scanner.run(runner, module);
    scanner.walkModuleCode(module);

    // Combine the data from the functions.
    functionSetGetInfos.combineInto(combinedSetGetInfos);
    // TODO: combine newInfos as well, once we have a need for that (we will
    //       when we do things like subtyping).

    // TODO: we need to propagate in both directions for no-read as well, update commentttt

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
    propagator.propagateToSuperAndSubTypes(combinedSetGetInfos);

    for (auto type : propagator.subTypes.types) {
      if (!type.isStruct()) {
        continue;
      }
      auto& fields = type.getStruct().fields;

      // Process immutability.
      for (Index i = 0; i < fields.size(); i++) {
        if (fields[i].mutable_ == Immutable) {
          // Already immutable; nothing to do.
          continue;
        }

        if (combinedSetGetInfos[type][i].hasWrite) {
          // A set exists.
          continue;
        }

        // No set exists. Mark it as something we can make immutable.
        auto& vec = canBecomeImmutable[type];
        vec.resize(i + 1);
        vec[i] = true;
      }

      // Process removability. First, see if we can remove anything before we
      // start to allocate info for that.
      bool canRemove = false;
      for (Index i = 0; i < fields.size(); i++) {
        if (!combinedSetGetInfos[type][i].hasRead) {
          canRemove = true;
          break;
        }
      }
      if (canRemove) {
        auto& indexesAfterRemoval = indexesAfterRemovals[type];
        indexesAfterRemoval.resize(fields.size());
        Index skip = 0;
        for (Index i = 0; i < fields.size(); i++) {
          if (combinedSetGetInfos[type][i].hasRead) {
            indexesAfterRemoval[i] = i - skip;
          } else {
            indexesAfterRemoval[i] = RemovedField;
std::cout << "plan to remove\n";
            skip++;
          }
        }
      }
    }

    // If we found fields that can be removed, remove them from instructions.
    // (Note that we must do this first, while we still have the old heap types
    // that we can identify, and only after this should be update all the types
    // throughout the module.)
    if (!indexesAfterRemovals.empty()) {
      removeFieldsInInstructions(runner, *module);
    }

    // Update the types in the entire module.
    updateTypes(*module);
  }

  void updateTypes(Module& wasm) {
    class TypeRewriter : public GlobalTypeRewriter {
      GlobalTypeOptimization& parent;

    public:
      TypeRewriter(Module& wasm, GlobalTypeOptimization& parent)
        : GlobalTypeRewriter(wasm), parent(parent) {}

      virtual void modifyStruct(HeapType oldStructType, Struct& struct_) {
        auto& newFields = struct_.fields;

        if (parent.canBecomeImmutable.count(oldStructType)) {
          auto& immutableVec = parent.canBecomeImmutable[oldStructType];
          for (Index i = 0; i < immutableVec.size(); i++) {
            if (immutableVec[i]) {
              newFields[i].mutable_ = Immutable;
            }
          }
        }

        if (parent.indexesAfterRemovals.count(oldStructType)) {
          auto& indexesAfterRemoval = parent.indexesAfterRemovals[oldStructType];
          Index skip = 0;
          for (Index i = 0; i < newFields.size(); i++) {
            auto newIndex = indexesAfterRemoval[i];
            if (newIndex != RemovedField) {
              newFields[newIndex] = newFields[i];
            } else {
std::cout << "remove from type\n";
              skip++;
            }
          }
          newFields.resize(newFields.size() - skip);

          // Update field names as well. The Type Rewriter cannot do this for
          // us, as it does not know which old fields map to which new ones (it
          // just keeps the names in sequence).
          auto iter = wasm.typeNames.find(oldStructType);
          if (iter != wasm.typeNames.end()) {
            auto& nameInfo = iter->second;
            auto& fieldNames = nameInfo.fieldNames;

            // TODO: templated helper for all theses?
            for (Index i = 0; i < fieldNames.size(); i++) {
              auto newIndex = indexesAfterRemoval[i];
              if (newIndex != RemovedField) {
                if (fieldNames.count(i)) {
                  fieldNames[newIndex] = fieldNames[i];
                }
              } else {
                fieldNames.erase(i);
              }
            }
          }
        }
      }
    };

    TypeRewriter(wasm, *this).update();
  }

  // After updating the types to remove certain fields, we must also remove
  // them from struct instructions.
  void removeFieldsInInstructions(PassRunner* runner, Module& wasm) {
    struct FieldRemover
      : public WalkerPass<PostWalker<FieldRemover>> {
      bool isFunctionParallel() override { return true; }

      GlobalTypeOptimization& parent;

      FieldRemover(GlobalTypeOptimization& parent) : parent(parent) {}

      FieldRemover* create() override {
        return new FieldRemover(parent);
      }

      void visitStructNew(StructNew* curr) {
        if (curr->type == Type::unreachable) {
          return;
        }
        if (curr->isWithDefault()) {
          // Nothing to do, a default was written and will no longer be.
          return;
        }

        auto iter = parent.indexesAfterRemovals.find(curr->type.getHeapType());
        if (iter == parent.indexesAfterRemovals.end()) {
          return;
        }
        auto& indexesAfterRemoval = iter->second;

        auto& operands = curr->operands;
        Index skip = 0;
        for (Index i = 0; i < operands.size(); i++) {
          auto newIndex = indexesAfterRemoval[i];
          if (newIndex != RemovedField) {
            operands[newIndex] = operands[i];
          } else {
std::cout << "remove from new\n";
            if (EffectAnalyzer(getPassOptions(), *getModule(), operands[i]).hasUnremovableSideEffects()) {
              Fatal() << "TODO: handle side effects in field removal (impossible in global locations?)";
            }
            skip++;
          }
        }
        operands.resize(operands.size() - skip);
      }

      void visitStructSet(StructSet* curr) {
        if (curr->ref->type == Type::unreachable) {
          return;
        }

        auto newIndex = getNewIndex(curr->ref->type.getHeapType(), curr->index);
        if (newIndex != RemovedField) {
std::cout << "keep (maybe update) in set\n";
          curr->index = newIndex;
        } else {
std::cout << "remove from set\n";
          Builder builder(*getModule());
          replaceCurrent(
            builder.makeSequence(
              builder.makeDrop(curr->ref),
              builder.makeDrop(curr->value)
            )
          );
        }
      }

      void visitStructGet(StructGet* curr) {
        if (curr->ref->type == Type::unreachable) {
          return;
        }

        auto newIndex = getNewIndex(curr->ref->type.getHeapType(), curr->index);
        // We can't remove a field that is read from.
        assert(newIndex != RemovedField);
        curr->index = newIndex;
      }

      Index getNewIndex(HeapType type, Index index) {
        auto iter = parent.indexesAfterRemovals.find(type);
        if (iter == parent.indexesAfterRemovals.end()) {
std::cout << "no indexes after removals to readdd\n";
          return index;
        }
        auto& indexesAfterRemoval = iter->second;
std::cout << "yes indexes after removals to read " << index << " : " << indexesAfterRemoval[index] << "\n";
        return indexesAfterRemoval[index];
      }
    };

    FieldRemover scanner(*this);
    scanner.run(runner, &wasm);
    scanner.walkModuleCode(&wasm);
  }
};

} // anonymous namespace

Pass* createGlobalTypeOptimizationPass() {
  return new GlobalTypeOptimization();
}

} // namespace wasm
