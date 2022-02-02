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
#include "ir/module-utils.h"
#include "ir/utils.h"
#include "wasm-type.h"
#include "wasm.h"

namespace wasm {

GlobalTypeRewriter::GlobalTypeRewriter(Module& wasm) : wasm(wasm) {}

void GlobalTypeRewriter::update() {
  indexedTypes = ModuleUtils::getOptimizedIndexedHeapTypes(wasm);
  if (indexedTypes.types.empty()) {
    return;
  }
  typeBuilder.grow(indexedTypes.types.size());

  // Create the temporary heap types.
  for (Index i = 0; i < indexedTypes.types.size(); i++) {
    auto type = indexedTypes.types[i];
    if (type.isSignature()) {
      auto sig = type.getSignature();
      TypeList newParams, newResults;
      for (auto t : sig.params) {
        newParams.push_back(getTempType(t));
      }
      for (auto t : sig.results) {
        newResults.push_back(getTempType(t));
      }
      Signature newSig(typeBuilder.getTempTupleType(newParams),
                       typeBuilder.getTempTupleType(newResults));
      modifySignature(indexedTypes.types[i], newSig);
      typeBuilder.setHeapType(i, newSig);
    } else if (type.isStruct()) {
      auto struct_ = type.getStruct();
      // Start with a copy to get mutability/packing/etc.
      auto newStruct = struct_;
      for (auto& field : newStruct.fields) {
        field.type = getTempType(field.type);
      }
      modifyStruct(indexedTypes.types[i], newStruct);
      typeBuilder.setHeapType(i, newStruct);
    } else if (type.isArray()) {
      auto array = type.getArray();
      // Start with a copy to get mutability/packing/etc.
      auto newArray = array;
      newArray.element.type = getTempType(newArray.element.type);
      modifyArray(indexedTypes.types[i], newArray);
      typeBuilder.setHeapType(i, newArray);
    } else {
      WASM_UNREACHABLE("bad type");
    }

    // Apply a super, if there is one
    if (auto super = type.getSuperType()) {
      typeBuilder.setSubType(i, indexedTypes.indices[*super]);
    }
  }

  auto buildResults = typeBuilder.build();
  auto& newTypes = *buildResults;

  // Map the old types to the new ones. This uses the fact that type indices
  // are the same in the old and new types, that is, we have not added or
  // removed types, just modified them.
  using OldToNewTypes = std::unordered_map<HeapType, HeapType>;
  OldToNewTypes oldToNewTypes;
  for (Index i = 0; i < indexedTypes.types.size(); i++) {
    oldToNewTypes[indexedTypes.types[i]] = newTypes[i];
  }

  // Replace all the old types in the module with the new ones.
  struct CodeUpdater
    : public WalkerPass<
        PostWalker<CodeUpdater, UnifiedExpressionVisitor<CodeUpdater>>> {
    bool isFunctionParallel() override { return true; }

    OldToNewTypes& oldToNewTypes;

    CodeUpdater(OldToNewTypes& oldToNewTypes) : oldToNewTypes(oldToNewTypes) {}

    CodeUpdater* create() override { return new CodeUpdater(oldToNewTypes); }

    Type getNew(Type type) {
      if (type.isRef()) {
        return Type(getNew(type.getHeapType()), type.getNullability());
      }
      if (type.isRtt()) {
        return Type(Rtt(type.getRtt().depth, getNew(type.getHeapType())));
      }
      if (type.isTuple()) {
        auto tuple = type.getTuple();
        for (auto& t : tuple.types) {
          t = getNew(t);
        }
        return Type(tuple);
      }
      return type;
    }

    HeapType getNew(HeapType type) {
      if (type.isBasic()) {
        return type;
      }
      if (type.isFunction() || type.isData()) {
        assert(oldToNewTypes.count(type));
        return oldToNewTypes[type];
      }
      return type;
    }

    Signature getNew(Signature sig) {
      return Signature(getNew(sig.params), getNew(sig.results));
    }

    void visitExpression(Expression* curr) {
      // Update the type to the new one.
      curr->type = getNew(curr->type);

      // Update any other type fields as well.

#define DELEGATE_ID curr->_id

#define DELEGATE_START(id)                                                     \
  auto* cast = curr->cast<id>();                                               \
  WASM_UNUSED(cast);

#define DELEGATE_GET_FIELD(id, field) cast->field

#define DELEGATE_FIELD_TYPE(id, field) cast->field = getNew(cast->field);

#define DELEGATE_FIELD_HEAPTYPE(id, field) cast->field = getNew(cast->field);

#define DELEGATE_FIELD_CHILD(id, field)
#define DELEGATE_FIELD_OPTIONAL_CHILD(id, field)
#define DELEGATE_FIELD_INT(id, field)
#define DELEGATE_FIELD_INT_ARRAY(id, field)
#define DELEGATE_FIELD_LITERAL(id, field)
#define DELEGATE_FIELD_NAME(id, field)
#define DELEGATE_FIELD_NAME_VECTOR(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_USE(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_USE_VECTOR(id, field)
#define DELEGATE_FIELD_ADDRESS(id, field)

#include "wasm-delegations-fields.def"
    }
  };

  CodeUpdater updater(oldToNewTypes);
  PassRunner runner(&wasm);
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
  for (auto& func : wasm.functions) {
    func->type = updater.getNew(func->type);
    for (auto& var : func->vars) {
      var = updater.getNew(var);
    }
  }
  for (auto& tag : wasm.tags) {
    tag->sig = updater.getNew(tag->sig);
  }

  // Update type names.
  for (auto& [old, new_] : oldToNewTypes) {
    if (wasm.typeNames.count(old)) {
      wasm.typeNames[new_] = wasm.typeNames[old];
    }
  }
}

Type GlobalTypeRewriter::getTempType(Type type) {
  if (type.isBasic()) {
    return type;
  }
  if (type.isRef()) {
    auto heapType = type.getHeapType();
    if (!indexedTypes.indices.count(heapType)) {
      // This type was not present in the module, but is now being used when
      // defining new types. That is fine; just use it.
      return type;
    }
    return typeBuilder.getTempRefType(
      typeBuilder.getTempHeapType(indexedTypes.indices[heapType]),
      type.getNullability());
  }
  if (type.isRtt()) {
    auto rtt = type.getRtt();
    auto newRtt = rtt;
    auto heapType = type.getHeapType();
    if (!indexedTypes.indices.count(heapType)) {
      // See above with references.
      return type;
    }
    newRtt.heapType =
      typeBuilder.getTempHeapType(indexedTypes.indices[heapType]);
    return typeBuilder.getTempRttType(newRtt);
  }
  if (type.isTuple()) {
    auto& tuple = type.getTuple();
    auto newTuple = tuple;
    for (auto& t : newTuple.types) {
      t = getTempType(t);
    }
    return typeBuilder.getTempTupleType(newTuple);
  }
  WASM_UNREACHABLE("bad type");
}

namespace TypeUpdating {

bool canHandleAsLocal(Type type) {
  // Defaultable types are always ok. For non-nullable types, we can handle them
  // using defaultable ones + ref.as_non_nulls.
  return type.isDefaultable() || type.isRef();
}

void handleNonDefaultableLocals(Function* func, Module& wasm) {
  // Check if this is an issue.
  if (wasm.features.hasGCNNLocals()) {
    return;
  }
  bool hasNonNullable = false;
  for (auto type : func->vars) {
    if (type.isNonNullable()) {
      hasNonNullable = true;
      break;
    }
  }
  if (!hasNonNullable) {
    return;
  }

  // Rewrite the local.gets.
  Builder builder(wasm);
  for (auto** getp : FindAllPointers<LocalGet>(func->body).list) {
    auto* get = (*getp)->cast<LocalGet>();
    if (!func->isVar(get->index)) {
      // We do not need to process params, which can legally be non-nullable.
      continue;
    }
    *getp = fixLocalGet(get, wasm);
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
    auto type = func->getLocalType(set->index);
    if (type.isNonNullable()) {
      set->type = Type(type.getHeapType(), Nullable);
      *setp = builder.makeRefAs(RefAsNonNull, set);
    }
  }

  // Rewrite the types of the function's vars (which we can do now, after we
  // are done using them to know which local.gets etc to fix).
  for (auto& type : func->vars) {
    type = getValidLocalType(type, wasm.features);
  }
}

Type getValidLocalType(Type type, FeatureSet features) {
  assert(canHandleAsLocal(type));
  if (type.isNonNullable() && !features.hasGCNNLocals()) {
    type = Type(type.getHeapType(), Nullable);
  }
  return type;
}

Expression* fixLocalGet(LocalGet* get, Module& wasm) {
  if (get->type.isNonNullable() && !wasm.features.hasGCNNLocals()) {
    // The get should now return a nullable value, and a ref.as_non_null
    // fixes that up.
    get->type = getValidLocalType(get->type, wasm.features);
    return Builder(wasm).makeRefAs(RefAsNonNull, get);
  }
  return get;
}

void updateParamTypes(Function* func,
                      const std::vector<Type>& newParamTypes,
                      Module& wasm) {
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
          fixup, builder.makeLocalGet(index, newParamTypes[index])));
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

  // Propagate the new get and set types outwards.
  ReFinalize().walkFunctionInModule(func, &wasm);

  if (!paramFixups.empty()) {
    // We have added locals, and must handle non-nullability of them.
    TypeUpdating::handleNonDefaultableLocals(func, wasm);
  }
}

} // namespace TypeUpdating

} // namespace wasm
