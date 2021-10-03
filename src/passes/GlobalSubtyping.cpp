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
// TODO: Specialize field types.
// TODO: Remove unused fields.
//

#include "ir/struct-utils.h"
#include "ir/subtypes.h"
#include "ir/type-updating.h"
#include "ir/utils.h"
#include "pass.h"
#include "support/small_set.h"
#include "wasm.h"
#include "wasm-type.h"
#include "wasm-builder.h"

using namespace std;

namespace wasm {

namespace {

// Information about usage of a field.
struct FieldInfo {
  bool hasWrite = false;

  void noteWrite() {
    hasWrite = true;
  }

  bool combine(const FieldInfo& other) {
    if (!hasWrite && other.hasWrite) {
      hasWrite = true;
      return true;
    }
    return false;
  }
};

using FieldInfoStructValuesMap = StructValuesMap<FieldInfo>;
using FieldInfoFunctionStructValuesMap =
  FunctionStructValuesMap<FieldInfo>;

struct FieldInfoScanner : public Scanner<FieldInfo> {
  Pass* create() override {
    return new FieldInfoScanner(functionNewInfos, functionSetInfos);
  }

  FieldInfoScanner(FunctionStructValuesMap<FieldInfo>& functionNewInfos,
             FunctionStructValuesMap<FieldInfo>& functionSetInfos)
    : Scanner<FieldInfo>(functionNewInfos, functionSetInfos) {}

  virtual void noteExpression(
    Expression* expr,
    HeapType type,
    Index index,
    FieldInfo& info) override {
    info.noteWrite();
  }

  virtual void noteDefault(Type fieldType,
                           HeapType type,
                           Index index,
                           FieldInfo& info) override {
    info.noteWrite();
  }

  virtual void noteCopy(
    HeapType type,
    Index index,
    FieldInfo& info) override {
    info.noteWrite();
  }
};

struct GlobalSubtyping : public Pass {
  void run(PassRunner* runner, Module* module) override {
    if (getTypeSystem() != TypeSystem::Nominal) {
      Fatal() << "GlobalSubtyping requires nominal typing";
    }

    // Find and analyze all writes inside each function.
    FieldInfoFunctionStructValuesMap functionNewInfos(*module),
      functionSetInfos(*module);
    FieldInfoScanner scanner(functionNewInfos, functionSetInfos);
    scanner.run(runner, module);
    scanner.walkModuleCode(module);

    // Combine the data from the functions.
    FieldInfoStructValuesMap combinedNewInfos, combinedSetInfos;
    functionNewInfos.combineInto(combinedNewInfos);
    functionSetInfos.combineInto(combinedSetInfos);

    // Reason about what we can optimize. In general, if a field in a struct is
    // has type T, and we see that all values written to it are subtypes of T'
    // where T' is more specific than T, then we would like to specialize the
    // field's type. But, we cannot do so if it breaks subtyping. In particular,
    // we must maintain that all current subtypes of the struct remain subtypes,
    // which means:
    //
    //  * We cannot specialize a field beyond the type it has in subtypes of the
    //    struct.
    //  * If the field is mutable, wasm requires that all subtypes of the struct
    //    are completely identical. (That is, only immutable fields can be
    //    different in a subtype of the struct.)
    //
    // To identify the proper opportunities, propagate types to supertypes. That
    // is, if we have
    //
    //  struct A     { type U }
    //  struct B : A { type V }
    //  struct C : B { type W }
    //
    // By propagating V to U, we ensure that the FieldInfo in A's field takes into
    // account B's field, as a result of which B's field is equal to A's or more
    // specific. (And likewise from C to B and A).
    StructValuePropagator<FieldInfo> propagator(*module);
#if 0
    propagator.propagateToSuperTypes(combinedNewInfos);
    propagator.propagateToSuperTypes(combinedSetInfos);

    // Next, handle mutability. As mentioned before, if a field is mutable then
    // corresponding fields in substructs must be identical.
    // TODO: avoid repeated work here
    auto handleMutability = [&](FieldInfoStructValuesMap& infos) {
      // Avoid iterating on infos while modifying it.
      std::vector<HeapType> heapTypes;
      for (auto& kv : infos) {
        heapTypes.push_back(kv.first);
      }
      for (auto heapType : heapTypes) {
        auto& fields = heapType.getStruct().fields;
        for (Index i = 0; i < fields.size(); i++) {
          auto& field = fields[i];
          if (field.mutable_ == Mutable) {
            // We must force all subtypes to match us on this field.
            auto forced = infos[heapType][i];
            auto work = propagator.subTypes.getSubTypes(heapType);
            while (!work.empty()) {
              auto iter = work.begin();
              auto subType = *iter;
              work.erase(iter);
              infos[subType][i] = forced;
              for (auto next : propagator.subTypes.getSubTypes(subType)) {
                work.push_back(next);
              }
            }
          }
        }
      }
    };
    handleMutability(combinedNewInfos);
    handleMutability(combinedSetInfos);
#endif

    // Find which fields are immutable in all super- and sub-classes. To see
    // that, propagate sets in both directions.
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

    // TODO: do we ever care about the difference between sets and news?
    auto combinedInfos = std::move(combinedNewInfos);
    combinedSetInfos.combineInto(combinedInfos);

    // The types are now generally correct, except for their internals, which we
    // rewrite now.
    class TypeUpdater : public GlobalTypeRewriter {
      FieldInfoStructValuesMap& combinedInfos;
      CanBecomeImmutable& canBecomeImmutable;

    public:
      TypeUpdater(Module& wasm, FieldInfoStructValuesMap& combinedInfos, CanBecomeImmutable& canBecomeImmutable) : GlobalTypeRewriter(wasm), combinedInfos(combinedInfos), canBecomeImmutable(canBecomeImmutable) {}

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

    TypeUpdater(*module, combinedInfos, canBecomeImmutable).update();

    // Finally, do a refinalize to propagate the new struct.get types outwards.
    // This may not be strictly necessary?
    ReFinalize().run(runner, module);
  }
};

} // anonymous namespace

Pass* createGlobalSubtypingPass() { return new GlobalSubtyping(); }

} // namespace wasm
