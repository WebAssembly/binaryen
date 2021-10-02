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

// The least upper bound of the types seen so far.
struct LUB {
  Type type = Type::unreachable;
  bool null = false;

  void note(Type otherType) {
    type = Type::getLeastUpperBound(type, otherType);
    applyNull();
  }

  void noteNull() {
    null = true;
    applyNull();
  }

  bool combine(const LUB& other) {
    auto beforeType = type;
    auto beforeNull = null;
    note(other.type);
    if (other.null) {
      noteNull();
    }
    return type != beforeType || null != beforeNull;
  }

private:
  void applyNull() {
    if (null && type.isRef() && !type.isNullable()) {
      type = Type(type.getHeapType(), Nullable);
    }
  }
};

using LUBStructValuesMap = StructValuesMap<LUB>;
using LUBFunctionStructValuesMap =
  FunctionStructValuesMap<LUB>;

struct LUBScanner : public Scanner<LUB> {
  Pass* create() override {
    return new LUBScanner(functionNewInfos, functionSetInfos);
  }

  LUBScanner(FunctionStructValuesMap<LUB>& functionNewInfos,
             FunctionStructValuesMap<LUB>& functionSetInfos)
    : Scanner<LUB>(functionNewInfos, functionSetInfos) {}

  virtual void noteExpression(
    Expression* expr,
    HeapType type,
    Index index,
    FunctionStructValuesMap<LUB>& valuesMap) override {
    auto& item = valuesMap[getFunction()][type][index];
    if (0 && expr->is<RefNull>()) {
      item.noteNull();
      return;
    }
    item.note(expr->type);
  }

  virtual void noteDefault(Type fieldType,
                           HeapType type,
                           Index index,
                           FunctionStructValuesMap<LUB>& valuesMap) override {
    auto& item = valuesMap[getFunction()][type][index];
    if (0 && fieldType.isRef()) {
      item.noteNull();
      return;
    }
    item.note(fieldType);
  }

  virtual void noteCopy(
    HeapType type,
    Index index,
    FunctionStructValuesMap<LUB>& valuesMap) override {
    // A copy does not introduce anything new in terms of types; ignore.
    // TODO: When we look at mutability, it will matter there.
  }
};

struct GlobalSubtyping : public Pass {
  void run(PassRunner* runner, Module* module) override {
    if (getTypeSystem() != TypeSystem::Nominal) {
      Fatal() << "GlobalSubtyping requires nominal typing";
    }

    // Find and analyze all writes inside each function.
    LUBFunctionStructValuesMap functionNewInfos(*module),
      functionSetInfos(*module);
    LUBScanner scanner(functionNewInfos, functionSetInfos);
    scanner.run(runner, module);
    scanner.walkModuleCode(module);

    // Combine the data from the functions.
    LUBStructValuesMap combinedNewInfos, combinedSetInfos;
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
    // By propagating V to U, we ensure that the LUB in A's field takes into
    // account B's field, as a result of which B's field is equal to A's or more
    // specific. (And likewise from C to B and A).
    StructValuePropagator<LUB> propagator(*module);
#if 0
    propagator.propagateToSuperTypes(combinedNewInfos);
    propagator.propagateToSuperTypes(combinedSetInfos);

    // Next, handle mutability. As mentioned before, if a field is mutable then
    // corresponding fields in substructs must be identical.
    // TODO: avoid repeated work here
    auto handleMutability = [&](LUBStructValuesMap& infos) {
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

        if (combinedSetInfos[type][i].type != Type::unreachable) {
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

    // We now know a set of valid types that we can apply, and can do so.

    // Update the types of operations on the field. We do this first so that type rewriting afterwards will
    // update them properly.
    struct AccessUpdater : public WalkerPass<PostWalker<AccessUpdater>> {
      bool isFunctionParallel() override { return true; }

      Pass* create() override { return new AccessUpdater(infos, canBecomeImmutable); }

      AccessUpdater(LUBStructValuesMap& infos, CanBecomeImmutable& canBecomeImmutable) : infos(infos), canBecomeImmutable(canBecomeImmutable) {}

      void visitStructNew(StructNew* curr) {
return;
        if (curr->type == Type::unreachable) {
          return;
        }

        auto type = curr->type.getHeapType();
        if (infos.count(type) == 0) {
          return;
        }

        for (Index i = 0; i < curr->operands.size(); i++) {
          auto observedFieldType = infos[type][i].type;
          if (observedFieldType != Type::unreachable &&
              curr->operands[i]->is<RefNull>()) {
            curr->operands[i]->type = observedFieldType;
          }
        }
      }

      void visitStructSet(StructSet* curr) {
return;
        if (curr->type == Type::unreachable) {
          return;
        }

        auto type = curr->ref->type.getHeapType();
        if (infos.count(type) == 0) {
          return;
        }

        auto i = curr->index;
        auto observedFieldType = infos[type][i].type;
        if (observedFieldType != Type::unreachable &&
            curr->value->is<RefNull>()) {
          curr->value->type = observedFieldType;
        }
      }

      void visitStructGet(StructGet* curr) {
return;
        if (curr->type == Type::unreachable) {
          return;
        }

        auto type = curr->ref->type.getHeapType();
        if (infos.count(type) == 0) {
          return;
        }

        auto index = curr->index;
        auto oldFieldType = type.getStruct().fields[index].type;
        auto observedFieldType = infos[type][index].type;
        // If we have more specialized type (and not if it's unreachable,
        // which means we've seen nothing at all), then we can optimize.
        if (observedFieldType != oldFieldType &&
            observedFieldType != Type::unreachable) {
          curr->type = observedFieldType;
        }
      }

    private:
      LUBStructValuesMap& infos;
      CanBecomeImmutable& canBecomeImmutable;
    };

    AccessUpdater(combinedInfos, canBecomeImmutable).run(runner, module);

    // The types are now generally correct, except for their internals, which we
    // rewrite now.
    class TypeUpdater : public GlobalTypeUpdater {
      LUBStructValuesMap& combinedInfos;
      CanBecomeImmutable& canBecomeImmutable;

    public:
      TypeUpdater(Module& wasm, LUBStructValuesMap& combinedInfos, CanBecomeImmutable& canBecomeImmutable) : GlobalTypeUpdater(wasm), combinedInfos(combinedInfos), canBecomeImmutable(canBecomeImmutable) {}

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
#if 0
        auto& oldFields = oldStructType.getStruct().fields;
        auto& observedFields = combinedInfos[oldStructType];
        for (Index i = 0; i < oldFields.size(); i++) {
          auto oldFieldType = oldFields[i].type;
          auto observedFieldType = observedFields[i].type;
          if (observedFieldType != oldFieldType &&
              observedFieldType != Type::unreachable) {
static int N = 0;
std::cout << "N: " << N++ << "\n";
            struct_.fields[i].type = getTempType(observedFieldType);
          }
        }
#endif
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
