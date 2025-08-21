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
#include <algorithm>
#include <memory>

namespace wasm {

namespace {

using FieldIndices = std::unordered_map<HeapType, std::vector<Index>>;

// Traverse the module, removing uses of the removed indices.
struct FieldRemover : WalkerPass<PostWalker<FieldRemover>> {
  // Map old field indices to new field indices.
  const FieldIndices& fieldIndices;

  FieldRemover(const FieldIndices& fieldIndices) : fieldIndices(fieldIndices) {}

  // Only introduces locals that are set right before they are used.
  bool requiresNonNullableLocalFixups() override { return false; }
  bool isFunctionParallel() override { return true; }
  std::unique_ptr<Pass> create() override {
    return std::make_unique<FieldRemover>(fieldIndices);
  }

  void visitStructNew(StructNew* curr) {
    if (!curr->type.isStruct()) {
      return;
    }
    if (curr->isWithDefault()) {
      // This will remain valid no matter how many fields we remove.
      return;
    }
    auto type = curr->type.getHeapType();
    auto it = fieldIndices.find(type);
    if (it == fieldIndices.end()) {
      return;
    }

    // If we are in a function context, preserve side effects.
    if (auto* func = getFunction()) {
      Block* replacement =
        ChildLocalizer(curr, func, *getModule(), getPassOptions())
          .getChildrenReplacement();
      replacement->list.push_back(curr);
      replacement->type = curr->type;
      replaceCurrent(replacement);
    }

    // Remove the relevant operands.
    const auto& indices = it->second;
    assert(indices.size() == type.getStruct().fields.size());
    assert(indices.size() == curr->operands.size());

    Index numRemoved = 0;
    for (Index i = 0; i < indices.size(); ++i) {
      if (indices[i] == Index(-1)) {
        ++numRemoved;
      } else {
        curr->operands[indices[i]] = curr->operands[i];
      }
    }
    assert(numRemoved > 0);
    assert(numRemoved <= indices.size());

    curr->operands.resize(indices.size() - numRemoved);
  }

  // Update the index and return `true` if we are done updating the expression.
  // Otherwise the expression uses a removed field and needs to be replaced.
  template<typename T> bool updateAccessorIndex(T* curr) {
    if (!curr->ref->type.isStruct()) {
      return true;
    }
    auto it = fieldIndices.find(curr->ref->type.getHeapType());
    if (it == fieldIndices.end()) {
      return true;
    }
    const auto& indices = it->second;
    if (indices[curr->index] != Index(-1)) {
      curr->index = indices[curr->index];
      return true;
    }
    return false;
  }

  void visitStructGet(StructGet* curr) {
    if (updateAccessorIndex(curr)) {
      return;
    }
    if (curr->type.isNonNullable()) {
      // We cannot replace a get of a non-nullable field with a proper value in
      // general. Try to replace it with an unreachable instead. This is at
      // least as useful as just giving up eagerly.
      // TODO: Try to reuse locals or globals with compatible types first.
      Builder builder(*getModule());
      replaceCurrent(builder.blockify(builder.makeDrop(curr->ref),
                                      builder.makeUnreachable()));
      return;
    }
    Builder builder(*getModule());
    replaceCurrent(builder.blockify(
      builder.makeDrop(curr->ref),
      builder.makeConstantExpression(Literal::makeZero(curr->type))));
  }

  void visitStructSet(StructSet* curr) {
    if (updateAccessorIndex(curr)) {
      return;
    }
    Builder builder(*getModule());
    replaceCurrent(builder.blockify(builder.makeDrop(curr->ref),
                                    builder.makeDrop(curr->value)));
  }

  void visitStructRMW(StructRMW* curr) {
    if (updateAccessorIndex(curr)) {
      return;
    }
    Builder builder(*getModule());
    replaceCurrent(builder.blockify(builder.makeDrop(curr->ref), curr->value));
  }

  void visitStructCmpxchg(StructCmpxchg* curr) {
    if (updateAccessorIndex(curr)) {
      return;
    }
    Builder builder(*getModule());
    replaceCurrent(builder.blockify(builder.makeDrop(curr->ref),
                                    builder.makeDrop(curr->expected),
                                    curr->replacement));
  }
};

} // anonymous namespace

void TypeReducer::collectTypeInfo() {
  auto allTypes = ModuleUtils::collectHeapTypes(wasm);
  auto it =
    std::remove_if(allTypes.begin(), allTypes.end(), [&](HeapType type) {
      return !type.isStruct() || type.getStruct().fields.empty();
    });
  allTypes.erase(it, allTypes.end());
  types = std::move(allTypes);

  totalFields = 0;
  for (auto type : types) {
    totalFields += type.getStruct().fields.size();
  }

  subtypes = SubTypes(types);
}

void TypeReducer::resetTypeInfo() {
  // Reload the type information and advance back to the current index.
  collectTypeInfo();
  if (totalFields == 0) {
    return;
  }
  // We may have fewer fields than before, in which case we wrap around.
  Index targetIndex = index % totalFields;
  index = 0;
  currType = 0;
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

void TypeReducer::advance() {
  assert(totalFields > 0);
  // Advance to the next field, wrapping around to the next type or even back to
  // the first type if necessary.
  ++index;
  ++currField;
  if (currField == types[currType].getStruct().fields.size()) {
    currField = 0;
    ++currType;
    if (currType == types.size()) {
      assert(index == totalFields);
      index = currField = currType = 0;
    }
  }
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

  // For each type, use the index vector to map old indices to new indices.
  // Start by collecting and sorting the removed indices for each type, then
  // replace the removed indices by the new index mapping. Removed indices map
  // to -1.
  FieldIndices fieldIndices;
  for (auto& [type, index] : removedFields) {
    fieldIndices[type].push_back(index);
  }
  for (auto& [type, indices] : fieldIndices) {
    std::sort(indices.begin(), indices.end());
    Index removedIndex = 0;
    Index numOldFields = type.getStruct().fields.size();
    std::vector<Index> mapping(numOldFields);
    for (Index index = 0; index < numOldFields; ++index) {
      if (removedIndex < indices.size() && indices[removedIndex] == index) {
        mapping[index] = -1;
        ++removedIndex;
      } else {
        mapping[index] = index - removedIndex;
      }
    }
    std::swap(mapping, indices);
  }

  PassRunner runner(&wasm);
  runner.add(std::make_unique<FieldRemover>(fieldIndices));
  runner.run();
  FieldRemover(fieldIndices).walkModuleCode(&wasm);

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
  ReFinalize().run(&runner, &wasm);

  // TODO: Make this opt-in?
#ifndef NDEBUG
  bool valid = WasmValidator().validate(wasm, WasmValidator::Globally);
#endif

  if (reducer.writeAndTestReduction()) {
    // Success! Commit the results.
    reducer.applyTestToWorking();
    // TODO: It would be more efficient to just keep the in-memory IR and update
    // typeInfo in-place with the new types, but this is less code. This also
    // ensures we skip newly unreachable types.
    reloadAndReset();
    return removedFields.size();
  }
  assert(valid);
  // Back out the changes by re-loading the working file.
  reloadAndReset();
  return 0;
}

size_t TypeReducer::reduce() {
  std::cerr << "|    removing struct fields\n";

  index = 0;
  resetTypeInfo();

  // We will try to remove multiple fields at a time, exponentially increasing
  // and decreasing the number in response to successes and failures. We will
  // also use this as the "bonus" when determining whether to add an element to
  // the batch so the frequency with with we add elements scales with the number
  // of elements we are adding.
  Index batchSize = 1;
  std::vector<std::pair<HeapType, Index>> batch;

  // Iterate through the types and fields, adding them to the current batch.
  // When the batch is full, attempt to remove the fields then continue with a
  // fresh batch.
  size_t reduced = false;
  while (fieldsSinceLastSuccess < totalFields) {
    if (!reducer.shouldTryToReduce(batchSize)) {
      // Skip this field.
      advance();
      ++fieldsSinceLastSuccess;
      continue;
    }
    // We found a field to try to remove. Add it to the batch.
    assert(batch.size() < batchSize);
    batch.push_back({types[currType], currField});
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

  // reducer.factor = oldFactor;
  return reduced;
}

} // namespace wasm