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

#include "find_all.h"
#include "ir/module-utils.h"
#include "type-updating.h"
#include "wasm-type.h"
#include "wasm.h"

namespace wasm {

GlobalTypeUpdater::GlobalTypeUpdater(Module& wasm) : wasm(wasm) {}

void GlobalTypeUpdater::update() {
  ModuleUtils::collectHeapTypes(wasm, types, typeIndices);
  typeBuilder.grow(types.size());

  // Create the temporary heap types.
  for (Index i = 0; i < types.size(); i++) {
    auto type = types[i];
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
      modifySignature(types[i], newSig);
      typeBuilder.setHeapType(i, newSig);
    } else if (type.isStruct()) {
      auto struct_ = type.getStruct();
      // Start with a copy to get mutability/packing/etc.
      auto newStruct = struct_;
      for (auto& field : newStruct.fields) {
        field.type = getTempType(field.type);
      }
      modifyStruct(types[i], newStruct);
      typeBuilder.setHeapType(i, newStruct);
    } else if (type.isArray()) {
      auto array = type.getArray();
      // Start with a copy to get mutability/packing/etc.
      auto newArray = array;
      newArray.element.type = getTempType(newArray.element.type);
      modifyArray(types[i], newArray);
      typeBuilder.setHeapType(i, newArray);
    } else {
      WASM_UNREACHABLE("bad type");
    }

    // Apply a super, if there is one
    HeapType super;
    if (type.getSuperType(super)) {
      typeBuilder.setSubType(i, typeIndices[super]);
    }
  }
  auto newTypes = typeBuilder.build();

  // Creating the oldToNewTypes of old to new types.

  using OldToNewTypes = std::unordered_map<HeapType, HeapType>;

  OldToNewTypes oldToNewTypes;

  for (Index i = 0; i < types.size(); i++) {
    oldToNewTypes[types[i]] = newTypes[i];
  }

  // Replace all the types in the module.
  struct CodeUpdater
    : public WalkerPass<PostWalker<CodeUpdater, UnifiedExpressionVisitor<CodeUpdater>>> {
    bool isFunctionParallel() override { return true; }

    OldToNewTypes& oldToNewTypes;

    CodeUpdater(OldToNewTypes& oldToNewTypes) : oldToNewTypes(oldToNewTypes) {}

    CodeUpdater* create() override {
      return new CodeUpdater(oldToNewTypes);
    }

    Type update(Type type) {
      if (type.isRef()) {
        return Type(update(type.getHeapType()), type.getNullability());
      }
      if (type.isRtt()) {
        return Type(Rtt(type.getRtt().depth, update(type.getHeapType())));
      }
      return type;
    }

    HeapType update(HeapType type) {
      if (type.isBasic()) {
        return type;
      }
      if (type.isFunction() || type.isData()) {
        assert(oldToNewTypes.count(type));
        return oldToNewTypes[type];
      }
      return type;
    }

    Signature update(Signature sig) {
      return Signature(update(sig.params), update(sig.results));
    }

    // Generic visitor. Specific things were overridden earlier.
    void visitExpression(Expression* curr) {
      // Update the type to the new one.
      curr->type = update(curr->type);

      // Update any other type fields as well.

#define DELEGATE_ID curr->_id

#define DELEGATE_START(id)                                                     \
auto* cast = curr->cast<id>();                                               \
WASM_UNUSED(cast);

#define DELEGATE_GET_FIELD(id, name) cast->name

#define DELEGATE_FIELD_TYPE(id, name) \
cast->name = update(cast->name);

#define DELEGATE_FIELD_HEAPTYPE(id, name) \
cast->name = update(cast->name);

#define DELEGATE_FIELD_SIGNATURE(id, name) \
cast->name = update(cast->name);

#define DELEGATE_FIELD_CHILD(id, name)
#define DELEGATE_FIELD_OPTIONAL_CHILD(id, name)
#define DELEGATE_FIELD_INT(id, name)
#define DELEGATE_FIELD_INT_ARRAY(id, name)
#define DELEGATE_FIELD_LITERAL(id, name)
#define DELEGATE_FIELD_NAME(id, name)
#define DELEGATE_FIELD_NAME_VECTOR(id, name)
#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, name)
#define DELEGATE_FIELD_SCOPE_NAME_USE(id, name)
#define DELEGATE_FIELD_SCOPE_NAME_USE_VECTOR(id, name)
#define DELEGATE_FIELD_ADDRESS(id, name)

#include "wasm-delegations-fields.def"
    }
  };

  CodeUpdater updater(oldToNewTypes);
  PassRunner runner(&wasm);
  updater.run(&runner, &wasm);
  updater.walkModuleCode(&wasm);

  // Update global locations that refer to types.
  for (auto& table : wasm.tables) {
    table->type = updater.update(table->type);
  }
  for (auto& elementSegment : wasm.elementSegments) {
    elementSegment->type = updater.update(elementSegment->type);
  }
  for (auto& global : wasm.globals) {
    global->type = updater.update(global->type);
  }
  for (auto& func : wasm.functions) {
    func->type = updater.update(func->type);
  }

  for (auto& kv : oldToNewTypes) {
    auto old = kv.first;
    auto new_ = kv.second;
    if (wasm.typeNames.count(old)) {
      wasm.typeNames[new_] = wasm.typeNames[old];
    }
  }
}

Type GlobalTypeUpdater::getTempType(Type type) {
  if (type.isBasic()) {
    return type;
  }
  if (type.isRef()) {
    auto heapType = type.getHeapType();
    if (!typeIndices.count(heapType)) {
      // This type was not present in the module, but is now being used when
      // defining new types. That is fine; just use it.
      return type;
    }
    return typeBuilder.getTempRefType(
      typeBuilder.getTempHeapType(typeIndices[heapType]),
      type.getNullability()
    );
  }
  if (type.isRtt()) {
    auto rtt = type.getRtt();
    auto newRtt = rtt;
    auto heapType = type.getHeapType();
    assert(typeIndices.count(heapType));
    newRtt.heapType = typeBuilder.getTempHeapType(typeIndices[heapType]);
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

} // namespace TypeUpdating

} // namespace wasm
