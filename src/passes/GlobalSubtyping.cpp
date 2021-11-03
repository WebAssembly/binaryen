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

struct GlobalTypeOptimization : public Pass {
  StructValuesMap<FieldInfo> combinedNewInfos;
  StructValuesMap<FieldInfo> combinedSetGetInfos;

  void run(PassRunner* runner, Module* module) override {
    if (getTypeSystem() != TypeSystem::Nominal) {
      Fatal() << "GlobalTypeOptimization requires nominal typing";
    }

    // Find and analyze struct operations inside each function.
    FunctionStructValuesMap<FieldInfo> functionNewInfos(*module),
      functionSetGetInfos(*module);
    FieldInfoScanner scanner(functionNewInfos, functionSetGetInfos);
    scanner.run(runner, module);
    scanner.runOnModuleCode(runner, module);

    // Combine the data from the functions.
    functionNewInfos.combineInto(combinedNewInfos);
    functionSetGetInfos.combineInto(combinedSetGetInfos);

    TypeHierarchyPropagator<FieldInfo> propagator(*module);
    propagator.propagateToSubTypes(combinedNewInfos);
    propagator.propagateToSuperAndSubTypes(combinedSetGetInfos);

    // Process the propagated info.
    for (auto type : propagator.subTypes.types) {
      if (!type.isStruct()) {
        continue;
      }
      auto& fields = type.getStruct().fields;
      auto& infos = combinedSetGetInfos[type];

      // Process immutability.
      for (Index i = 0; i < fields.size(); i++) {
        if (fields[i].mutable_ == Immutable) {
          // Already immutable; nothing to do.
          continue;
        }

        if (infos[i].hasWrite) {
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
      if (std::any_of(infos.begin(), infos.end(), [&](const FieldInfo& info) {
            return !info.hasRead;
          })) {
        auto& indexesAfterRemoval = indexesAfterRemovals[type];
        indexesAfterRemoval.resize(fields.size());
        Index skip = 0;
        for (Index i = 0; i < fields.size(); i++) {
          if (infos[i].hasRead) {
            indexesAfterRemoval[i] = i - skip;
          } else {
            indexesAfterRemoval[i] = RemovedField;
            skip++;
          }
        }
      }
    }

    // If we found fields that can be removed, remove them from instructions.
    // (Note that we must do this first, while we still have the old heap types
    // that we can identify, and only after this should we update all the types
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

        // Adjust immutability.
        auto immIter = parent.canBecomeImmutable.find(oldStructType);
        if (immIter != parent.canBecomeImmutable.end()) {
          auto& immutableVec = immIter->second;
          for (Index i = 0; i < immutableVec.size(); i++) {
            if (immutableVec[i]) {
              newFields[i].mutable_ = Immutable;
            }
          }
        }

        // Remove fields where we can.
        auto remIter = parent.indexesAfterRemovals.find(oldStructType);
        if (remIter != parent.indexesAfterRemovals.end()) {
          auto& indexesAfterRemoval = remIter->second;
          Index removed = 0;
          for (Index i = 0; i < newFields.size(); i++) {
            auto newIndex = indexesAfterRemoval[i];
            if (newIndex != RemovedField) {
              newFields[newIndex] = newFields[i];
            } else {
              removed++;
            }
          }
          newFields.resize(newFields.size() - removed);

          // Update field names as well. The Type Rewriter cannot do this for
          // us, as it does not know which old fields map to which new ones (it
          // just keeps the names in sequence).
          auto iter = wasm.typeNames.find(oldStructType);
          if (iter != wasm.typeNames.end()) {
            auto& nameInfo = iter->second;

            // Make a copy of the old ones to base ourselves off of as we do so.
            auto oldFieldNames = nameInfo.fieldNames;

            // Clear the old names and write the new ones.
            nameInfo.fieldNames.clear();
            for (Index i = 0; i < oldFieldNames.size(); i++) {
              auto newIndex = indexesAfterRemoval[i];
              if (newIndex != RemovedField && oldFieldNames.count(i)) {
                assert(oldFieldNames[i].is());
                nameInfo.fieldNames[newIndex] = oldFieldNames[i];
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
    struct FieldRemover : public WalkerPass<PostWalker<FieldRemover>> {
      bool isFunctionParallel() override { return true; }

      GlobalTypeOptimization& parent;

      FieldRemover(GlobalTypeOptimization& parent) : parent(parent) {}

      FieldRemover* create() override { return new FieldRemover(parent); }

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
        assert(indexesAfterRemoval.size() == operands.size());

        // Check for side effects in removed fields. If there are any, we must
        // use locals to save the values (while keeping them in order).
        bool useLocals = false;
        for (Index i = 0; i < operands.size(); i++) {
          auto newIndex = indexesAfterRemoval[i];
          if (newIndex == RemovedField &&
              EffectAnalyzer(getPassOptions(), *getModule(), operands[i])
                .hasUnremovableSideEffects()) {
            useLocals = true;
            break;
          }
        }
        if (useLocals) {
          auto* func = getFunction();
          if (!func) {
            Fatal() << "TODO: side effects in removed fields in globals\n";
          }
          auto* block = Builder(*getModule()).makeBlock();
          auto sets =
            ChildLocalizer(curr, func, getModule(), getPassOptions()).sets;
          block->list.set(sets);
          block->list.push_back(curr);
          block->finalize(curr->type);
          replaceCurrent(block);
          addedLocals = true;
        }

        // Remove the unneeded operands.
        Index removed = 0;
        for (Index i = 0; i < operands.size(); i++) {
          auto newIndex = indexesAfterRemoval[i];
          if (newIndex != RemovedField) {
            assert(newIndex < operands.size());
            operands[newIndex] = operands[i];
          } else {
            removed++;
          }
        }
        operands.resize(operands.size() - removed);
      }

      void visitStructSet(StructSet* curr) {
        if (curr->ref->type == Type::unreachable) {
          return;
        }

        auto newIndex = getNewIndex(curr->ref->type.getHeapType(), curr->index);
        if (newIndex != RemovedField) {
          // Map to the new index.
          curr->index = newIndex;
        } else {
          // This field was removed, so just emit drops of our children.
          Builder builder(*getModule());
          replaceCurrent(builder.makeSequence(builder.makeDrop(curr->ref),
                                              builder.makeDrop(curr->value)));
        }
      }

      void visitStructGet(StructGet* curr) {
        if (curr->ref->type == Type::unreachable) {
          return;
        }

        auto newIndex = getNewIndex(curr->ref->type.getHeapType(), curr->index);
        // We must not remove a field that is read from.
        assert(newIndex != RemovedField);
        curr->index = newIndex;
      }

      void visitFunction(Function* curr) {
        if (addedLocals) {
          TypeUpdating::handleNonDefaultableLocals(curr, *getModule());
        }
      }

    private:
      bool addedLocals = false;

      Index getNewIndex(HeapType type, Index index) {
        auto iter = parent.indexesAfterRemovals.find(type);
        if (iter == parent.indexesAfterRemovals.end()) {
          return index;
        }
        auto& indexesAfterRemoval = iter->second;
        auto newIndex = indexesAfterRemoval[index];
        assert(newIndex < indexesAfterRemoval.size() ||
               newIndex == RemovedField);
        return newIndex;
      }
    };

    FieldRemover remover(*this);
    remover.run(runner, &wasm);
    remover.runOnModuleCode(runner, &wasm);
  }
};

} // anonymous namespace

Pass* createGlobalTypeOptimizationPass() {
  return new GlobalTypeOptimization();
}

} // namespace wasm
