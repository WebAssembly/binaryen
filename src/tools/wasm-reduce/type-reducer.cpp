/*
 * Copyright 2025 WebAssembly Community Group participants
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

#include "tools/wasm-reduce/type-reducer.h"
#include "ir/localize.h"
#include "ir/module-utils.h"
#include "ir/type-updating.h"
#include "ir/utils.h"
#include "wasm-traversal.h"
#include "wasm-validator.h"
#include "wasm.h"

namespace wasm {

namespace {

void removeNulls(std::vector<Expression**>& ptrs) {
  auto it = std::remove(ptrs.begin(), ptrs.end(), nullptr);
  ptrs.erase(it, ptrs.end());
}

struct TypeInfoCollector : PostWalker<TypeInfoCollector> {
  TypeReducer::TypeInfoMap& info;

  TypeInfoCollector(TypeReducer::TypeInfoMap& info) : info(info) {}

  TypeReducer::TypeInfo& getInfo(HeapType type) {
    auto [it, inserted] = info.insert({type, {}});
    if (inserted) {
      it->second.fieldExpressions.resize(type.getStruct().fields.size());
    }
    return it->second;
  }

  void visitStructNew(StructNew* curr) {
    if (!curr->type.isStruct()) {
      return;
    }
    if (curr->isWithDefault()) {
      // We will not make a defaultable field non-defaultable, so this
      // expression will remain valid no matter what fields we try to reduce.
      return;
    }
    auto type = curr->type.getHeapType();
    getInfo(type).allocations.push_back(getCurrentPointer());
  }

  template<typename T> void visitAccessor(T* curr) {
    if (!curr->ref->type.isStruct()) {
      return;
    }
    auto type = curr->ref->type.getHeapType();
    getInfo(type).fieldExpressions[curr->index].push_back(getCurrentPointer());
  }

  void visitStructGet(StructGet* curr) { visitAccessor(curr); }
  void visitStructSet(StructSet* curr) { visitAccessor(curr); }
  void visitStructRMW(StructRMW* curr) { visitAccessor(curr); }
  void visitStructCmpxchg(StructCmpxchg* curr) { visitAccessor(curr); }
};

} // anonymous namespace

void TypeReducer::collectTypeInfo() {
  typeInfo.clear();
  ModuleUtils::
    ParallelFunctionAnalysis<TypeInfoMap, Immutable, InsertOrderedMap>
      analysis(wasm, [&](Function* func, TypeInfoMap& info) {
        if (!func->imported()) {
          TypeInfoCollector{info}.walkFunction(func);
        }
      });
  for (auto& [func, infos] : analysis.map) {
    for (auto& [type, info] : infos) {
      typeInfo[type][func] = std::move(info);
    }
  }
  TypeInfoMap moduleInfo;
  TypeInfoCollector{moduleInfo}.walkModuleCode(&wasm);
  for (auto& [type, info] : moduleInfo) {
    typeInfo[type][nullptr] = std::move(info);
  }

  totalFields = 0;
  for (auto& [type, _] : typeInfo) {
    totalFields += type.getStruct().fields.size();
  }

  subtypes = SubTypes(wasm);
}

void TypeReducer::resetTypeInfo() {
  // Reload the type information and advance back to the current index.
  collectTypeInfo();
  // We may have fewer fields than before, in which case we wrap around.
  Index targetIndex = index % totalFields;
  index = 0;
  typeIt = typeInfo.begin();
  currField = 0;
  while (index < targetIndex) {
    advance();
  }
}

void TypeReducer::reloadAndReset() {
  // No easy way to undo destructive changes, so just reload the working file.
  reducer.loadWorking();
  resetTypeInfo();
}

size_t TypeReducer::tryReduction(CandidateFields fields) {
  std::cerr << "|     trying at i=" << index << " of size " << fields.size()
            << " (" << fieldsSinceLastSuccess << "/" << totalFields << ")\n";
  if (auto reduced = tryRemovingFields(fields)) {
    std::cerr << "|      success removing " << reduced << " fields\n";
    return reduced;
  }
  // TODO: Fall back to trying to make fields nullable, etc.
  return 0;
}

size_t TypeReducer::tryRemovingFields(const CandidateFields& fields) {
  using FieldSet = std::unordered_set<std::pair<HeapType, Index>>;
  // Expand the candidate set to include corresponding fields in supertypes and
  // subtypes.
  FieldSet removedFields;
  CandidateFields work(fields);
  while (!work.empty()) {
    auto [type, index] = work.back();
    work.pop_back();
    if (!removedFields.insert({type, index}).second) {
      // We've already processed this field.
      continue;
    }
    if (auto super = type.getDeclaredSuperType();
        super && index < super->getStruct().fields.size()) {
      work.push_back({*super, index});
    }
    for (auto sub : subtypes.getImmediateSubTypes(type)) {
      work.push_back({sub, index});
    }
  }

  // Eagerly search for struct.gets of non-nullable fields. We won't be able to
  // replace these, and we don't want to find them after doing something
  // destructive that would force us to reload the module. RMWs don't have the
  // same problem because we can just replace them with their provided value.
  for (auto [type, index] : removedFields) {
    if (!type.getStruct().fields[index].type.isNonNullable()) {
      continue;
    }
    for (auto& [_, info] : typeInfo[type]) {
      for (auto** currp : info.fieldExpressions[index]) {
        if ((*currp)->is<StructGet>()) {
          return 0;
        }
      }
    }
  }

  // We have to remove later indices before earlier indices to make sure the
  // indices still point to the intended fields when we get to them.
  CandidateFields orderedRemovedFields(removedFields.begin(),
                                       removedFields.end());
  std::sort(orderedRemovedFields.begin(),
            orderedRemovedFields.end(),
            [&](const auto& a, const auto& b) { return a.second > b.second; });

  // Update expressions that use the removed fields in some way.
  for (auto [type, index] : orderedRemovedFields) {
    for (auto& [func, info] : typeInfo[type]) {
      for (auto*& currp : info.allocations) {
        currp = removeAllocationField(func, currp, index);
      }
      removeNulls(info.allocations);
      for (auto*& currp : info.fieldExpressions[index]) {
        currp = removeAccessorField(func, currp, index);
      }
      removeNulls(info.fieldExpressions[index]);
      // Decrement all uses of higher indices.
      for (auto i = index + 1; i < info.fieldExpressions.size(); ++i) {
        for (auto* currp : info.fieldExpressions[i]) {
          decrementAccessorIndex(*currp);
        }
      }
    }
  }

  // Update the types.
  struct Rewriter : GlobalTypeRewriter {
    const FieldSet& removedFields;

    Rewriter(Module& wasm, const FieldSet& removedFields)
      : GlobalTypeRewriter(wasm), removedFields(removedFields) {}

    void modifyStruct(HeapType oldType, Struct& struct_) override {
      std::vector<Field> newFields;
      const auto& oldFields = oldType.getStruct().fields;
      for (Index i = 0; i < oldFields.size(); ++i) {
        if (!removedFields.count({oldType, i})) {
          newFields.push_back(struct_.fields[i]);
        }
      }
      struct_ = Struct{std::move(newFields)};
    }
  };

  Rewriter{wasm, removedFields}.update();
  PassRunner runner(&wasm);
  ReFinalize().run(&runner, &wasm);

  // TODO: Make this opt-in?
  bool valid = WasmValidator().validate(
    wasm, WasmValidator::Globally /* | WasmValidator::Quiet*/);

  if (reducer.writeAndTestReduction()) {
    // Success! Commit the results.
    reducer.applyTestToWorking();
    // TODO: It would be more efficient to just keep the in-memory IR and update
    // typeInfo in-place with the new types, but this is less code.
    reloadAndReset();
    return removedFields.size();
  }
  assert(valid);
  // Back out the changes by re-loading the working file.
  reloadAndReset();
  return 0;
}

Expression** TypeReducer::removeAllocationField(Function* func,
                                                Expression** currp,
                                                Index index) {
  StructNew* new_ = (*currp)->cast<StructNew>();
  // If we're in a function context, we can use ChildLocalizer to replace the
  // dropped child. Otherwise we can just drop it directly because it must not
  // have side effects.
  if (func) {
    auto* block = ChildLocalizer(new_, func, wasm, {}).getChildrenReplacement();
    new_->operands.erase(new_->operands.begin() + index);
    block->list.push_back(new_);
    block->type = new_->type;
    *currp = block;
    return &block->list.back();
  } else {
    new_->operands.erase(new_->operands.begin() + index);
    return currp;
  }
}

Expression** TypeReducer::removeAccessorField(Function* func,
                                              Expression** currp,
                                              Index index) {
  Builder builder(wasm);
  Expression* curr = *currp;
  if (auto* get = curr->dynCast<StructGet>()) {
    // We should never get here if the field is non-defaultable.
    assert(!get->type.isNonNullable());
    *currp = builder.blockify(
      builder.makeDrop(get->ref),
      builder.makeConstantExpression(Literal::makeZero(get->type)));
    return nullptr;
  } else if (auto* set = curr->dynCast<StructSet>()) {
    *currp = builder.blockify(builder.makeDrop(set->ref),
                              builder.makeDrop(set->value));
    return nullptr;
  } else if (auto* rmw = curr->dynCast<StructRMW>()) {
    *currp = builder.blockify(builder.makeDrop(rmw->ref), rmw->value);
    return nullptr;
  } else if (auto* cmpxchg = curr->dynCast<StructCmpxchg>()) {
    assert(func);
    auto* block =
      ChildLocalizer(cmpxchg, func, wasm, {}).getChildrenReplacement();
    block->list.push_back(cmpxchg->replacement);
    block->type = cmpxchg->type;
    *currp = block;
    return nullptr;
  } else {
    WASM_UNREACHABLE("unexpected accessor");
  }
}

void TypeReducer::decrementAccessorIndex(Expression* curr) {
  if (auto* get = curr->dynCast<StructGet>()) {
    --get->index;
  } else if (auto* set = curr->dynCast<StructSet>()) {
    --set->index;
  } else if (auto* rmw = curr->dynCast<StructRMW>()) {
    --rmw->index;
  } else if (auto* cmpxchg = curr->dynCast<StructCmpxchg>()) {
    --cmpxchg->index;
  } else {
    WASM_UNREACHABLE("unexpected accessor");
  }
}

void TypeReducer::advance() {
  // Advance to the next field, wrapping around to the next type or even back to
  // the first type if necessary.
  ++index;
  ++currField;
  if (currField == typeIt->first.getStruct().fields.size()) {
    currField = 0;
    ++typeIt;
    if (typeIt == typeInfo.end()) {
      assert(index == totalFields);
      index = 0;
      typeIt = typeInfo.begin();
    }
  }
}

size_t TypeReducer::reduce() {
  auto oldFactor = reducer.factor;
  reducer.factor = 1;

  index = 0;
  resetTypeInfo();

  // We will try to remove multiple fields at a time, exponentially increasing
  // and decreasing the number in response to successes and failures.
  Index batchSize = 1;
  std::vector<std::pair<HeapType, Index>> batch;

  // Iterate through the types and fields, adding them to the current batch.
  // When the batch is full, attempt to remove the fields then continue with a
  // fresh batch.
  size_t reduced = false;
  while (fieldsSinceLastSuccess < totalFields) {
    if (!reducer.shouldTryToReduce()) {
      assert(false);
      // Skip this field.
      advance();
      ++fieldsSinceLastSuccess;
      continue;
    }
    // We found a field to try to remove. Add it to the batch.
    assert(batch.size() < batchSize);
    batch.push_back({typeIt->first, currField});
    if (batch.size() < batchSize) {
      // The batch is not ready. Move on to the next field.
      advance();
      ++fieldsSinceLastSuccess;
      continue;
    }
    // We have a full batch. Attempt reductions.
    if (auto newReduced = tryReduction(std::move(batch))) {
      // Success! Increase the batch size.
      reduced += newReduced;
      fieldsSinceLastSuccess = 0;
      batchSize *= 2;
    } else {
      // It didn't work. Continue with a smaller batch.
      batchSize = std::max(1u, batchSize / 2);
      ++fieldsSinceLastSuccess;
      advance();
    }
    assert(batch.empty());
  }

  // If we have a partial batch remaining, go ahead and try to reduce it.
  if (!batch.empty() && tryReduction(std::move(batch))) {
    reduced = true;
  }

  reducer.factor = oldFactor;
  return reduced;
}

} // namespace wasm