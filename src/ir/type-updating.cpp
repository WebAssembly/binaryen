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

#include "type-updating.h"
#include "find_all.h"
#include "ir/local-structural-dominance.h"
#include "ir/module-utils.h"
#include "ir/names.h"
#include "ir/utils.h"
#include "support/topological_sort.h"
#include "wasm-type-ordering.h"
#include "wasm-type.h"
#include "wasm.h"

namespace wasm {

GlobalTypeRewriter::GlobalTypeRewriter(Module& wasm) : wasm(wasm) {}

void GlobalTypeRewriter::update(
  const std::vector<HeapType>& additionalPrivateTypes) {
  mapTypes(rebuildTypes(additionalPrivateTypes));
}

GlobalTypeRewriter::TypeMap GlobalTypeRewriter::rebuildTypes(
  const std::vector<HeapType>& additionalPrivateTypes) {
  // Find the heap types that are not publicly observable. Even in a closed
  // world scenario, don't modify public types because we assume that they may
  // be reflected on or used for linking. Figure out where each private type
  // will be located in the builder. Sort the private types so that supertypes
  // come before their subtypes.
  Index i = 0;
  auto privateTypes = ModuleUtils::getPrivateHeapTypes(wasm);

  if (!additionalPrivateTypes.empty()) {
    // Only add additional private types that are not already in the list.
    std::unordered_set<HeapType> privateTypesSet(privateTypes.begin(),
                                                 privateTypes.end());

    for (auto t : additionalPrivateTypes) {
      if (!privateTypesSet.count(t)) {
        privateTypes.push_back(t);
        privateTypesSet.insert(t);
      }
    }
  }

  // Topological sort to have supertypes first, but we have to account for the
  // fact that we may be replacing the supertypes to get the order correct.
  struct SupertypesFirst
    : HeapTypeOrdering::SupertypesFirstBase<SupertypesFirst> {
    GlobalTypeRewriter& parent;

    SupertypesFirst(GlobalTypeRewriter& parent) : parent(parent) {}
    std::optional<HeapType> getDeclaredSuperType(HeapType type) {
      return parent.getDeclaredSuperType(type);
    }
  };

  SupertypesFirst sortedTypes(*this);
  for (auto type : sortedTypes.sort(privateTypes)) {
    typeIndices[type] = i++;
  }

  if (typeIndices.size() == 0) {
    return {};
  }
  typeBuilder.grow(typeIndices.size());

  // All the input types are distinct, so we need to make sure the output types
  // are distinct as well. Further, the new types may have more recursions than
  // the original types, so the old recursion groups may not be sufficient any
  // more. Both of these problems are solved by putting all the new types into a
  // single large recursion group.
  typeBuilder.createRecGroup(0, typeBuilder.size());

  // Create the temporary heap types.
  i = 0;
  auto map = [&](HeapType type) -> HeapType {
    if (auto it = typeIndices.find(type); it != typeIndices.end()) {
      return typeBuilder[it->second];
    }
    return type;
  };
  for (auto [type, _] : typeIndices) {
    typeBuilder[i].copy(type, map);
    switch (type.getKind()) {
      case HeapTypeKind::Func: {
        auto newSig = HeapType(typeBuilder[i]).getSignature();
        modifySignature(type, newSig);
        typeBuilder[i] = newSig;
        break;
      }
      case HeapTypeKind::Struct: {
        auto newStruct = HeapType(typeBuilder[i]).getStruct();
        modifyStruct(type, newStruct);
        typeBuilder[i] = newStruct;
        break;
      }
      case HeapTypeKind::Array: {
        auto newArray = HeapType(typeBuilder[i]).getArray();
        modifyArray(type, newArray);
        typeBuilder[i] = newArray;
        break;
      }
      case HeapTypeKind::Cont:
        WASM_UNREACHABLE("TODO: cont");
      case HeapTypeKind::Basic:
        WASM_UNREACHABLE("unexpected kind");
    }

    if (auto super = getDeclaredSuperType(type)) {
      typeBuilder[i].subTypeOf(map(*super));
    } else {
      typeBuilder[i].subTypeOf(std::nullopt);
    }

    modifyTypeBuilderEntry(typeBuilder, i, type);
    ++i;
  }

  auto buildResults = typeBuilder.build();
#ifndef NDEBUG
  if (auto* err = buildResults.getError()) {
    Fatal() << "Internal GlobalTypeRewriter build error: " << err->reason
            << " at index " << err->index;
  }
#endif
  auto& newTypes = *buildResults;

  // Map the old types to the new ones.
  TypeMap oldToNewTypes;
  for (auto [type, index] : typeIndices) {
    oldToNewTypes[type] = newTypes[index];
  }
  mapTypeNames(oldToNewTypes);
  return oldToNewTypes;
}

void GlobalTypeRewriter::mapTypes(const TypeMap& oldToNewTypes) {
  // Replace all the old types in the module with the new ones.
  struct CodeUpdater
    : public WalkerPass<
        PostWalker<CodeUpdater, UnifiedExpressionVisitor<CodeUpdater>>> {
    bool isFunctionParallel() override { return true; }

    const TypeMap& oldToNewTypes;

    CodeUpdater(const TypeMap& oldToNewTypes) : oldToNewTypes(oldToNewTypes) {}

    std::unique_ptr<Pass> create() override {
      return std::make_unique<CodeUpdater>(oldToNewTypes);
    }

    Type getNew(Type type) {
      if (type.isRef()) {
        return Type(getNew(type.getHeapType()), type.getNullability());
      }
      if (type.isTuple()) {
        auto tuple = type.getTuple();
        for (auto& t : tuple) {
          t = getNew(t);
        }
        return Type(tuple);
      }
      return type;
    }

    HeapType getNew(HeapType type) {
      auto iter = oldToNewTypes.find(type);
      if (iter != oldToNewTypes.end()) {
        return iter->second;
      }
      return type;
    }

    Signature getNew(Signature sig) {
      return Signature(getNew(sig.params), getNew(sig.results));
    }

    void visitExpression(Expression* curr) {
      // local.get and local.tee are special in that their type is tied to the
      // type of the local in the function, which is tied to the signature. That
      // means we must update it based on the signature, and not on the old type
      // in the local.
      //
      // We have already updated function signatures by the time we get here,
      // which means we can just apply the current local type that we see (there
      // is no need to call getNew(), which we already did on the function's
      // signature itself).
      if (auto* get = curr->dynCast<LocalGet>()) {
        curr->type = getFunction()->getLocalType(get->index);
        return;
      } else if (auto* tee = curr->dynCast<LocalSet>()) {
        // Rule out a local.set and unreachable code.
        if (tee->type != Type::none && tee->type != Type::unreachable) {
          curr->type = getFunction()->getLocalType(tee->index);
        }
        return;
      }

      // Update the type to the new one.
      curr->type = getNew(curr->type);

      // Update any other type fields as well.

#define DELEGATE_ID curr->_id

#define DELEGATE_START(id) [[maybe_unused]] auto* cast = curr->cast<id>();

#define DELEGATE_GET_FIELD(id, field) cast->field

#define DELEGATE_FIELD_TYPE(id, field) cast->field = getNew(cast->field);

#define DELEGATE_FIELD_HEAPTYPE(id, field) cast->field = getNew(cast->field);

#define DELEGATE_FIELD_CHILD(id, field)
#define DELEGATE_FIELD_OPTIONAL_CHILD(id, field)
#define DELEGATE_FIELD_INT(id, field)
#define DELEGATE_FIELD_LITERAL(id, field)
#define DELEGATE_FIELD_NAME(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_USE(id, field)
#define DELEGATE_FIELD_ADDRESS(id, field)

#include "wasm-delegations-fields.def"
    }
  };

  CodeUpdater updater(oldToNewTypes);
  PassRunner runner(&wasm);

  // Update functions first, so that we see the updated types for locals (which
  // can change if the function signature changes).
  for (auto& func : wasm.functions) {
    func->type = updater.getNew(func->type);
    for (auto& var : func->vars) {
      var = updater.getNew(var);
    }
  }

  updater.run(&runner, &wasm);
  updater.walkModuleCode(&wasm);

  // Update global locations that refer to types.
  for (auto& table : wasm.tables) {
    table->type = updater.getNew(table->type);
  }
  for (auto& elementSegment : wasm.elementSegments) {
    elementSegment->type = updater.getNew(elementSegment->type);
  }
  for (auto& global : wasm.globals) {
    global->type = updater.getNew(global->type);
  }
  for (auto& tag : wasm.tags) {
    tag->sig = updater.getNew(tag->sig);
  }
}

void GlobalTypeRewriter::mapTypeNames(const TypeMap& oldToNewTypes) {
  // Update type names to avoid duplicates.
  std::unordered_set<Name> typeNames;
  for (auto& [type, info] : wasm.typeNames) {
    typeNames.insert(info.name);
  }
  for (auto& [old, new_] : oldToNewTypes) {
    if (old == new_) {
      // The type is being mapped to itself; no need to rename anything.
      continue;
    }

    if (auto it = wasm.typeNames.find(old); it != wasm.typeNames.end()) {
      wasm.typeNames[new_] = wasm.typeNames[old];
      // Use the existing name in the new type, as usually it completely
      // replaces the old. Rename the old name in a unique way to avoid
      // confusion in the case that it remains used.
      auto deduped =
        Names::getValidName(wasm.typeNames[old].name,
                            [&](Name test) { return !typeNames.count(test); });
      wasm.typeNames[old].name = deduped;
      typeNames.insert(deduped);
    }
  }
}

Type GlobalTypeRewriter::getTempType(Type type) {
  if (type.isBasic()) {
    return type;
  }
  if (type.isRef()) {
    auto heapType = type.getHeapType();
    if (auto it = typeIndices.find(heapType); it != typeIndices.end()) {
      return typeBuilder.getTempRefType(typeBuilder[it->second],
                                        type.getNullability());
    }
    // This type is not one that is eligible for optimizing. That is fine; just
    // use it unmodified.
    return type;
  }
  if (type.isTuple()) {
    auto newTuple = type.getTuple();
    for (auto& t : newTuple) {
      t = getTempType(t);
    }
    return typeBuilder.getTempTupleType(newTuple);
  }
  WASM_UNREACHABLE("bad type");
}

Type GlobalTypeRewriter::getTempTupleType(Tuple tuple) {
  return typeBuilder.getTempTupleType(tuple);
}

namespace TypeUpdating {

bool canHandleAsLocal(Type type) {
  // TODO: Inline this into its callers.
  return type.isConcrete();
}

void handleNonDefaultableLocals(Function* func, Module& wasm) {
  if (!wasm.features.hasReferenceTypes()) {
    // No references, so no non-nullable ones at all.
    return;
  }
  bool hasNonNullable = false;
  for (auto varType : func->vars) {
    for (auto type : varType) {
      if (type.isNonNullable()) {
        hasNonNullable = true;
        break;
      }
    }
  }
  if (!hasNonNullable) {
    // No non-nullable types exist in practice.
    return;
  }

  // Non-nullable locals exist, which we may need to fix up. See if they
  // validate as they are, that is, if they fall within the validation rules of
  // the wasm spec. We do not need to modify such locals.
  LocalStructuralDominance info(
    func, wasm, LocalStructuralDominance::NonNullableOnly);
  std::unordered_set<Index> badIndexes;
  for (auto index : info.nonDominatingIndices) {
    badIndexes.insert(index);

    // LocalStructuralDominance should have only looked at non-nullable indexes
    // since we told it to ignore nullable ones. Also, params always dominate
    // and should not appear here.
    assert(func->getLocalType(index).isNonNullable() ||
           func->getLocalType(index).isTuple());
    assert(!func->isParam(index));
  }
  if (badIndexes.empty()) {
    return;
  }

  // Rewrite the local.gets.
  Builder builder(wasm);
  for (auto** getp : FindAllPointers<LocalGet>(func->body).list) {
    auto* get = (*getp)->cast<LocalGet>();
    if (badIndexes.count(get->index)) {
      *getp = fixLocalGet(get, wasm);
    }
  }

  // Update tees, whose type must match the local (if the wasm spec changes for
  // the type to be that of the value, then this can be removed).
  for (auto** setp : FindAllPointers<LocalSet>(func->body).list) {
    auto* set = (*setp)->cast<LocalSet>();
    if (!func->isVar(set->index)) {
      // We do not need to process params, which can legally be non-nullable.
      continue;
    }
    // Non-tees do not change, and unreachable tees can be ignored here as their
    // type is unreachable anyhow.
    if (!set->isTee() || set->type == Type::unreachable) {
      continue;
    }
    if (badIndexes.count(set->index)) {
      auto type = func->getLocalType(set->index);
      auto validType = getValidLocalType(type, wasm.features);
      if (type.isRef()) {
        set->type = validType;
        *setp = builder.makeRefAs(RefAsNonNull, set);
      } else {
        assert(type.isTuple());
        set->makeSet();
        std::vector<Expression*> elems(type.size());
        for (size_t i = 0, size = type.size(); i < size; ++i) {
          elems[i] = builder.makeTupleExtract(
            builder.makeLocalGet(set->index, validType), i);
          if (type[i].isNonNullable()) {
            elems[i] = builder.makeRefAs(RefAsNonNull, elems[i]);
          }
        }
        *setp =
          builder.makeSequence(set, builder.makeTupleMake(std::move(elems)));
      }
    }
  }

  // Rewrite the types of the function's vars (which we can do now, after we
  // are done using them to know which local.gets etc to fix).
  for (auto index : badIndexes) {
    func->vars[index - func->getNumParams()] =
      getValidLocalType(func->getLocalType(index), wasm.features);
  }
}

Type getValidLocalType(Type type, FeatureSet features) {
  assert(type.isConcrete());
  if (type.isNonNullable()) {
    return Type(type.getHeapType(), Nullable);
  }
  if (type.isTuple()) {
    std::vector<Type> elems(type.size());
    for (size_t i = 0, size = type.size(); i < size; ++i) {
      elems[i] = getValidLocalType(type[i], features);
    }
    return Type(std::move(elems));
  }
  return type;
}

Expression* fixLocalGet(LocalGet* get, Module& wasm) {
  if (get->type.isNonNullable()) {
    // The get should now return a nullable value, and a ref.as_non_null
    // fixes that up.
    get->type = getValidLocalType(get->type, wasm.features);
    return Builder(wasm).makeRefAs(RefAsNonNull, get);
  }
  if (get->type.isTuple()) {
    auto type = get->type;
    get->type = getValidLocalType(type, wasm.features);
    std::vector<Expression*> elems(type.size());
    Builder builder(wasm);
    for (Index i = 0, size = type.size(); i < size; ++i) {
      auto* elemGet =
        i == 0 ? get : builder.makeLocalGet(get->index, get->type);
      elems[i] = builder.makeTupleExtract(elemGet, i);
      if (type[i].isNonNullable()) {
        elems[i] = builder.makeRefAs(RefAsNonNull, elems[i]);
      }
    }
    return builder.makeTupleMake(std::move(elems));
  }
  return get;
}

void updateParamTypes(Function* func,
                      const std::vector<Type>& newParamTypes,
                      Module& wasm,
                      LocalUpdatingMode localUpdating) {
  // Before making this update, we must be careful if the param was "reused",
  // specifically, if it is assigned a less-specific type in the body then
  // we'd get a validation error when we refine it. To handle that, if a less-
  // specific type is assigned simply switch to a new local, that is, we can
  // do a fixup like this:
  //
  // function foo(x : oldType) {
  //   ..
  //   x = (oldType)val;
  //
  // =>
  //
  // function foo(x : newType) {
  //   var x_oldType = x; // assign the param immediately to a fixup var
  //   ..
  //   x_oldType = (oldType)val; // fixup var is used throughout the body
  //
  // Later optimization passes may be able to remove the extra var, and can
  // take advantage of the refined argument type while doing so.

  // A map of params that need a fixup to the new fixup var used for it.
  std::unordered_map<Index, Index> paramFixups;

  FindAll<LocalSet> sets(func->body);

  for (auto* set : sets.list) {
    auto index = set->index;
    if (func->isParam(index) && !paramFixups.count(index) &&
        !Type::isSubType(set->value->type, newParamTypes[index])) {
      paramFixups[index] = Builder::addVar(func, func->getLocalType(index));
    }
  }

  FindAll<LocalGet> gets(func->body);

  // Apply the fixups we identified that we need.
  if (!paramFixups.empty()) {
    // Write the params immediately to the fixups.
    Builder builder(wasm);
    std::vector<Expression*> contents;
    for (Index index = 0; index < func->getNumParams(); index++) {
      auto iter = paramFixups.find(index);
      if (iter != paramFixups.end()) {
        auto fixup = iter->second;
        contents.push_back(builder.makeLocalSet(
          fixup,
          builder.makeLocalGet(index,
                               localUpdating == Update
                                 ? newParamTypes[index]
                                 : func->getLocalType(index))));
      }
    }
    contents.push_back(func->body);
    func->body = builder.makeBlock(contents);

    // Update gets and sets using the param to use the fixup.
    for (auto* get : gets.list) {
      auto iter = paramFixups.find(get->index);
      if (iter != paramFixups.end()) {
        get->index = iter->second;
      }
    }
    for (auto* set : sets.list) {
      auto iter = paramFixups.find(set->index);
      if (iter != paramFixups.end()) {
        set->index = iter->second;
      }
    }
  }

  // Update local.get/local.tee operations that use the modified param type.
  if (localUpdating == Update) {
    for (auto* get : gets.list) {
      auto index = get->index;
      if (func->isParam(index)) {
        get->type = newParamTypes[index];
      }
    }
    for (auto* set : sets.list) {
      auto index = set->index;
      if (func->isParam(index) && set->isTee()) {
        set->type = newParamTypes[index];
        set->finalize();
      }
    }
  }

  // Propagate the new get and set types outwards.
  ReFinalize().walkFunctionInModule(func, &wasm);

  if (!paramFixups.empty()) {
    // We have added locals, and must handle non-nullability of them.
    TypeUpdating::handleNonDefaultableLocals(func, wasm);
  }
}

} // namespace TypeUpdating

} // namespace wasm
