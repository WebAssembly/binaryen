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

#include "ir/lubs.h"
#include "ir/struct-utils.h"
#include "ir/type-updating.h"
#include "ir/utils.h"
#include "pass.h"
#include "support/unique_deferring_queue.h"
#include "wasm-type.h"
#include "wasm.h"

namespace wasm {

namespace {

// We use a LUBFinder to track field info. A LUBFinder keeps track of the best
// possible LUB so far. The only extra functionality we need here is whether
// there is a default null value (which would force us to keep the type
// nullable).
using FieldInfo = LUBFinder;

struct FieldInfoScanner
  : public StructUtils::StructScanner<FieldInfo, FieldInfoScanner> {
  Pass* create() override {
    return new FieldInfoScanner(functionNewInfos, functionSetGetInfos);
  }

  FieldInfoScanner(
    StructUtils::FunctionStructValuesMap<FieldInfo>& functionNewInfos,
    StructUtils::FunctionStructValuesMap<FieldInfo>& functionSetGetInfos)
    : StructUtils::StructScanner<FieldInfo, FieldInfoScanner>(
        functionNewInfos, functionSetGetInfos) {}

  void noteExpression(Expression* expr,
                      HeapType type,
                      Index index,
                      FieldInfo& info) {
    info.noteUpdatableExpression(expr);
  }

  void
  noteDefault(Type fieldType, HeapType type, Index index, FieldInfo& info) {
    // Default values do not affect what the heap type of a field can be turned
    // into. Note them, however, as they force us to keep the type nullable.
    if (fieldType.isRef()) {
      info.noteNullDefault();
    }
  }

  void noteCopy(HeapType type, Index index, FieldInfo& info) {
    // Copies do not add any type requirements at all: the type will always be
    // read and written to a place with the same type.
  }

  void noteRead(HeapType type, Index index, FieldInfo& info) {
    // Nothing to do for a read, we just care about written values.
  }
};

struct TypeRefining : public Pass {
  StructUtils::StructValuesMap<FieldInfo> finalInfos;

  void run(PassRunner* runner, Module* module) override {
    if (getTypeSystem() != TypeSystem::Nominal) {
      Fatal() << "TypeRefining requires nominal typing";
    }

    // Find and analyze struct operations inside each function.
    StructUtils::FunctionStructValuesMap<FieldInfo> functionNewInfos(*module),
      functionSetGetInfos(*module);
    FieldInfoScanner scanner(functionNewInfos, functionSetGetInfos);
    scanner.run(runner, module);
    scanner.runOnModuleCode(runner, module);

    // Combine the data from the functions.
    StructUtils::StructValuesMap<FieldInfo> combinedNewInfos;
    StructUtils::StructValuesMap<FieldInfo> combinedSetGetInfos;
    functionNewInfos.combineInto(combinedNewInfos);
    functionSetGetInfos.combineInto(combinedSetGetInfos);

    // Propagate things written during new to supertypes, as they must also be
    // able to contain that type. Propagate things written using set to subtypes
    // as well, as the reference might be to a supertype if the field is present
    // there.
    StructUtils::TypeHierarchyPropagator<FieldInfo> propagator(*module);
    propagator.propagateToSuperTypes(combinedNewInfos);
    propagator.propagateToSuperAndSubTypes(combinedSetGetInfos);

    // Combine everything together.
    combinedNewInfos.combineInto(finalInfos);
    combinedSetGetInfos.combineInto(finalInfos);

    // While we do the following work, see if we have anything to optimize, so
    // that we can avoid wasteful work later if not.
    bool canOptimize = false;

    // We have combined all the information we have about writes to the fields,
    // but we still need to make sure that the new types makes sense. In
    // particular, subtyping cares about things like mutability, and we also
    // need to handle the case where we have no writes to a type but do have
    // them to subtypes or supertypes; in all these cases, we must preserve
    // that a field is always a subtype of the parent field. To do so, we go
    // through all the types downward from supertypes to subtypes, ensuring the
    // subtypes are suitable.
    auto& subTypes = propagator.subTypes;
    UniqueDeferredQueue<HeapType> work;
    for (auto type : subTypes.types) {
      if (type.isStruct() && !type.getSuperType()) {
        work.push(type);
      }
    }
    while (!work.empty()) {
      auto type = work.pop();

      // First, find fields that have nothing written to them at all, and set
      // their value to their old type. We must pick some type for the field,
      // and we have nothing better to go on. (If we have a super, and it does
      // have writes, then we may further update this type later, see the
      // isSubType check in the loop after this.)
      auto& fields = type.getStruct().fields;
      for (Index i = 0; i < fields.size(); i++) {
        auto oldType = fields[i].type;
        auto& info = finalInfos[type][i];
        if (!info.noted()) {
          info = LUBFinder(oldType);
        }
      }

      // Next ensure proper subtyping of this struct's fields versus its super.
      if (auto super = type.getSuperType()) {
        auto& superFields = super->getStruct().fields;
        for (Index i = 0; i < superFields.size(); i++) {
          auto newSuperType = finalInfos[*super][i].getBestPossible();
          auto& info = finalInfos[type][i];
          auto newType = info.getBestPossible();
          if (!Type::isSubType(newType, newSuperType)) {
            // To ensure we are a subtype of the super's field, simply copy that
            // value, which is more specific than us.
            //
            // This situation cannot happen normally, but if a type is not used
            // then it can. For example, imagine that $B and $C are subtypes of
            // $A, and that $C is never created anywhere. A struct.new of $B
            // propagates info to $A (forcing $A's type to take it into account
            // and not be more specific than it), but that does not reach $C
            // (struct.new propagates only up, not down; if it propagated down
            // then we could never specialize a subtype more than its super). If
            // $C had some value written to it then that value would force the
            // LUB of $A to take it into account, but as here $C is never even
            // created, that does not happen. And then if we update $A's type
            // to something more specific than $C's old type, we end up with the
            // problem that this code path fixes: we just need to get $C's type
            // to be identical to its super so that validation works.
            info = LUBFinder(newSuperType);
          } else if (fields[i].mutable_ == Mutable) {
            // Mutable fields must have identical types, so we cannot
            // specialize.
            // TODO: Perhaps we should be using a new Field::isSubType() method
            //       here? This entire analysis might be done on fields, and not
            //       types, which would also handle more things added to fields
            //       in the future.
            info = LUBFinder(newSuperType);
          }
        }
      }

      // After all those decisions, see if we found anything to optimize.
      for (Index i = 0; i < fields.size(); i++) {
        auto oldType = fields[i].type;
        auto& lub = finalInfos[type][i];
        auto newType = lub.getBestPossible();
        if (newType != oldType) {
          canOptimize = true;
          lub.updateNulls();
        }
      }

      for (auto subType : subTypes.getSubTypes(type)) {
        work.push(subType);
      }
    }

    if (canOptimize) {
      updateTypes(*module, runner);
    }
  }

  void updateTypes(Module& wasm, PassRunner* runner) {
    class TypeRewriter : public GlobalTypeRewriter {
      TypeRefining& parent;

    public:
      TypeRewriter(Module& wasm, TypeRefining& parent)
        : GlobalTypeRewriter(wasm), parent(parent) {}

      void modifyStruct(HeapType oldStructType, Struct& struct_) override {
        const auto& oldFields = oldStructType.getStruct().fields;
        auto& newFields = struct_.fields;

        for (Index i = 0; i < newFields.size(); i++) {
          auto oldType = oldFields[i].type;
          if (!oldType.isRef()) {
            continue;
          }
          auto newType = parent.finalInfos[oldStructType][i].getBestPossible();
          newFields[i].type = getTempType(newType);
        }
      }
    };

    TypeRewriter(wasm, *this).update();

    ReFinalize().run(runner, &wasm);
  }
};

} // anonymous namespace

Pass* createTypeRefiningPass() { return new TypeRefining(); }

} // namespace wasm
