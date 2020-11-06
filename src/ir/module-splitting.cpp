/*
 * Copyright 2020 WebAssembly Community Group participants
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

#include "ir/module-splitting.h"
#include "ir/manipulation.h"
#include "ir/module-utils.h"
#include "ir/names.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace ModuleSplitting {

namespace {

std::unique_ptr<Module> initializeSecondary(const Module& primary) {
  // Create the secondary module and copy trivial properties.
  auto secondary = std::make_unique<Module>();
  secondary->features = primary.features;
  secondary->hasFeaturesSection = primary.hasFeaturesSection;
  return secondary;
}

void shareImportableItems(Module& primary,
                          Module& secondary,
                          Name importNamespace) {
  // Map internal names to (one of) their corresponding export names.
  std::unordered_map<Name, Name> exports;
  for (auto& ex : primary.exports) {
    if (ex->kind != ExternalKind::Function) {
      exports[ex->value] = ex->name;
    }
  }

  auto makeImportExport = [&](Importable& primaryItem,
                              Importable& secondaryItem,
                              Name exportName,
                              ExternalKind kind) {
    secondaryItem.name = primaryItem.name;
    secondaryItem.hasExplicitName = primaryItem.hasExplicitName;
    secondaryItem.module = importNamespace;
    auto exportIt = exports.find(primaryItem.name);
    if (exportIt != exports.end()) {
      secondaryItem.base = exportIt->second;
    } else {
      exportName = Names::getValidExportName(primary, exportName);
      primary.addExport(new Export{exportName, primaryItem.name, kind});
      secondaryItem.base = exportName;
    }
  };

  // TODO: Be more selective by only sharing global items that are actually used
  // in the secondary module, just like we do for functions.

  auto shareMemory = [&](Memory* memory) {
    secondary.memory.exists = true;
    secondary.memory.initial = memory->initial;
    secondary.memory.max = memory->max;
    secondary.memory.shared = memory->shared;
    secondary.memory.indexType = memory->indexType;
    makeImportExport(*memory, secondary.memory, "memory", ExternalKind::Memory);
  };
  ModuleUtils::iterImportedMemories(primary, shareMemory);
  ModuleUtils::iterDefinedMemories(primary, shareMemory);

  auto shareTable = [&](Table* table) {
    secondary.table.exists = true;
    secondary.table.initial = table->initial;
    secondary.table.max = table->max;
    makeImportExport(*table, secondary.table, "table", ExternalKind::Table);
  };
  ModuleUtils::iterImportedTables(primary, shareTable);
  ModuleUtils::iterDefinedTables(primary, shareTable);

  auto shareGlobal = [&](Global* global) {
    assert(primary.features.hasMutableGlobals() &&
           "TODO: add wrapper functions for disallowed mutable globals");
    auto secondaryGlobal = std::make_unique<Global>();
    secondaryGlobal->type = global->type;
    secondaryGlobal->mutable_ = global->mutable_;
    secondaryGlobal->init =
      global->init == nullptr
        ? nullptr
        : ExpressionManipulator::copy(global->init, secondary);
    makeImportExport(*global, *secondaryGlobal, "global", ExternalKind::Global);
    secondary.addGlobal(std::move(secondaryGlobal));
  };
  ModuleUtils::iterImportedGlobals(primary, shareGlobal);
  ModuleUtils::iterDefinedGlobals(primary, shareGlobal);

  auto shareEvent = [&](Event* event) {
    auto secondaryEvent = std::make_unique<Event>();
    secondaryEvent->attribute = event->attribute;
    secondaryEvent->sig = event->sig;
    makeImportExport(*event, *secondaryEvent, "event", ExternalKind::Event);
    secondary.addEvent(std::move(secondaryEvent));
  };
  ModuleUtils::iterImportedEvents(primary, shareEvent);
  ModuleUtils::iterDefinedEvents(primary, shareEvent);
}

template<class F> void forEachElement(Table& table, F f) {
  for (auto& segment : table.segments) {
    assert(segment.offset->is<Const>() &&
           "TODO: handle non-constant segment offsets");
    Index baseOffset = segment.offset->cast<Const>()->value.geti32();
    for (size_t i = 0; i < segment.data.size(); ++i) {
      f(Index(baseOffset + i), segment.data[i]);
    }
  }
}

// Return the first free table slot and the segment to which to append new
// items, if it exists.
Index getFirstFreeTableIndex(Table& table, Table::Segment** outSegment) {
  Index firstFreeIndex = 0;
  *outSegment = nullptr;
  for (auto& segment : table.segments) {
    assert(segment.offset->is<Const>() &&
           "TODO: handle non-constant segment offsets");
    Index segmentBase = segment.offset->cast<Const>()->value.geti32();
    if (segmentBase + segment.data.size() > firstFreeIndex) {
      firstFreeIndex = segmentBase + segment.data.size();
      *outSegment = &segment;
    }
  }
  return firstFreeIndex;
}

// Move the secondary functions out of the primary module and return a map from
// their names to their (eventual) table indices.
void moveFunctions(Module& primary,
                   Module& secondary,
                   const std::set<Name>& secondaryFuncs) {
  // Move the specified functions from the primary to the secondary module.
  std::map<Name, Signature> secondarySignatures;
  for (auto funcName : secondaryFuncs) {
    auto* func = primary.getFunction(funcName);
    secondarySignatures[funcName] = func->sig;
    assert(!func->imported() && "Cannot split off imported functions");
    assert(funcName != primary.start && "Cannot split off start function");
    ModuleUtils::copyFunction(func, secondary);
    primary.removeFunction(funcName);
  }

  // Map secondary functions to their table indices. Assumes each function
  // appears at most once in the table.
  std::map<Name, Index> secondaryIndices;
  auto addIndex = [&](Name secondaryFunc, Index index) {
    auto it = secondaryIndices.insert(std::make_pair(secondaryFunc, index));
    assert(it.second && "Function already has multiple indices");
  };

  // Initialize `secondaryIndices` with the secondary functions that already
  // have table slots.
  forEachElement(primary.table, [&](Index index, Name elem) {
    if (secondaryFuncs.find(elem) != secondaryFuncs.end()) {
      addIndex(elem, index);
    }
  });

  // Keep track of the new items we have to add to the table and where to add
  // them.
  Table::Segment* lastSegment = nullptr;
  Index firstFreeIndex = getFirstFreeTableIndex(primary.table, &lastSegment);
  std::vector<Name> newTableElems;

  auto getIndex = [&](Name secondaryFunc) {
    auto indexIt = secondaryIndices.find(secondaryFunc);
    if (indexIt != secondaryIndices.end()) {
      return indexIt->second;
    } else {
      Index newIndex = firstFreeIndex + newTableElems.size();
      newTableElems.push_back(secondaryFunc);
      addIndex(secondaryFunc, newIndex);
      return newIndex;
    }
  };

  // Update exports of secondary functions in the primary module to export
  // wrapper functions that indirectly call the secondary functions. Reuse the
  // exported function's existing table slot if it exists, otherwise create a
  // new table slot.
  Builder builder(primary);
  for (auto& ex : primary.exports) {
    if (ex->kind != ExternalKind::Function ||
        secondaryFuncs.find(ex->value) == secondaryFuncs.end()) {
      continue;
    }
    Name secondaryFunc = ex->value;
    Index tableIndex = getIndex(secondaryFunc);
    auto func = std::make_unique<Function>();
    func->name = secondaryFunc;
    func->sig = secondarySignatures[secondaryFunc];
    std::vector<Expression*> args;
    for (size_t i = 0, size = func->sig.params.size(); i < size; ++i) {
      args.push_back(builder.makeLocalGet(i, func->sig.params[i]));
    }
    func->body = builder.makeCallIndirect(
      builder.makeConst(Literal(int32_t(tableIndex))), args, func->sig);
    primary.addFunction(std::move(func));
  }

  // Update direct calls of secondary functions to be indirect calls of their
  // corresponding table indices instead.
  struct CallIndirector : public WalkerPass<PostWalker<CallIndirector>> {
    const std::set<Name>& secondaryFuncs;
    const std::map<Name, Signature>& secondarySignatures;
    std::function<Index(Name)> getIndex;
    Builder builder;
    CallIndirector(const std::set<Name>& secondaryFuncs,
                   const std::map<Name, Signature>& secondarySignatures,
                   std::function<Index(Name)> getIndex,
                   Builder builder)
      : secondaryFuncs(secondaryFuncs),
        secondarySignatures(secondarySignatures), getIndex(getIndex),
        builder(builder) {}
    void visitCall(Call* curr) {
      if (secondaryFuncs.find(curr->target) == secondaryFuncs.end()) {
        return;
      }
      replaceCurrent(builder.makeCallIndirect(
        builder.makeConst(Literal(int32_t(getIndex(curr->target)))),
        curr->operands,
        secondarySignatures.find(curr->target)->second,
        curr->isReturn));
    }
    void visitRefFunc(RefFunc* curr) {
      assert(false && "TODO: handle ref.func as well");
    }
  };
  PassRunner runner(&primary);
  CallIndirector(
    secondaryFuncs, secondarySignatures, getIndex, Builder(primary))
    .run(&runner, &primary);

  // Insert new table elements
  if (newTableElems.size()) {
    primary.table.exists = true;
    secondary.table.exists = true;
    // Update table sizes if necessary
    size_t tableSize = firstFreeIndex + newTableElems.size();
    if (primary.table.initial < tableSize) {
      primary.table.initial = tableSize;
      secondary.table.initial = tableSize;
    }
    if (primary.table.max < tableSize) {
      primary.table.max = tableSize;
      secondary.table.max = tableSize;
    }
    if (lastSegment != nullptr) {
      lastSegment->data.insert(
        lastSegment->data.end(), newTableElems.begin(), newTableElems.end());
    } else {
      primary.table.segments.emplace_back(
        builder.makeConst(Literal(int32_t(firstFreeIndex))), newTableElems);
    }
  }
}

void exportImportPrimaryFunctions(Module& primary,
                                  Module& secondary,
                                  const std::set<Name>& primaryFuncs,
                                  Name importNamespace) {
  // Find primary functions called in the secondary module.
  ModuleUtils::ParallelFunctionAnalysis<std::set<Name>> callCollector(
    secondary, [&](Function* func, std::set<Name>& calledPrimaryFuncs) {
      struct CallCollector : PostWalker<CallCollector> {
        const std::set<Name>& primaryFuncs;
        std::set<Name>& calledPrimaryFuncs;
        CallCollector(const std::set<Name>& primaryFuncs,
                      std::set<Name>& calledPrimaryFuncs)
          : primaryFuncs(primaryFuncs), calledPrimaryFuncs(calledPrimaryFuncs) {
        }

        void visitCall(Call* curr) {
          if (primaryFuncs.find(curr->target) != primaryFuncs.end()) {
            calledPrimaryFuncs.insert(curr->target);
          }
        }
      };
      CallCollector(primaryFuncs, calledPrimaryFuncs).walkFunction(func);
    });
  std::set<Name> calledPrimaryFuncs;
  for (auto& entry : callCollector.map) {
    auto& calledFuncs = entry.second;
    calledPrimaryFuncs.insert(calledFuncs.begin(), calledFuncs.end());
  }

  // Find exported primary functions and map to their export names
  std::map<Name, Name> exportedPrimaryFuncs;
  for (auto& ex : primary.exports) {
    if (ex->kind == ExternalKind::Function) {
      exportedPrimaryFuncs.insert(std::make_pair(ex->value, ex->name));
    }
  }

  // Ensure each called primary function is exported and imported
  for (auto primaryFunc : calledPrimaryFuncs) {
    Name exportName;
    auto exportIt = exportedPrimaryFuncs.find(primaryFunc);
    if (exportIt != exportedPrimaryFuncs.end()) {
      exportName = exportIt->second;
    } else {
      exportName = Names::getValidExportName(primary, primaryFunc);
      primary.addExport(
        new Export{exportName, primaryFunc, ExternalKind::Function});
    }
    auto func = std::make_unique<Function>();
    func->module = importNamespace;
    func->base = exportName;
    func->name = primaryFunc;
    func->sig = primary.getFunction(primaryFunc)->sig;
    secondary.addFunction(std::move(func));
  }
}

void setupTablePatching(Module& primary,
                        Module& secondary,
                        const std::set<Name>& secondaryFuncs,
                        Name placeholderNamespace) {
  std::map<Index, Name> replacedElems;
  // Replace table references to secondary functions with an imported
  // placeholder that encodes the table index in its name:
  // `importNamespace`.`index`.
  forEachElement(primary.table, [&](Index index, Name& elem) {
    if (secondaryFuncs.find(elem) != secondaryFuncs.end()) {
      replacedElems[index] = elem;
      auto* secondaryFunc = secondary.getFunction(elem);
      auto placeholder = std::make_unique<Function>();
      placeholder->module = placeholderNamespace;
      placeholder->base = std::to_string(index);
      placeholder->name = Names::getValidFunctionName(
        primary,
        std::string("placeholder_") + std::string(placeholder->base.c_str()));
      placeholder->hasExplicitName = false;
      placeholder->sig = secondaryFunc->sig;
      elem = placeholder->name;
      primary.addFunction(std::move(placeholder));
    }
  });

  // Create active table segments in the secondary module to patch in the
  // original functions when it is instantiated.
  Index currBase = 0;
  std::vector<Name> currData;
  auto finishSegment = [&]() {
    auto* offset = Builder(secondary).makeConst(Literal(int32_t(currBase)));
    secondary.table.segments.emplace_back(offset, currData);
  };
  if (replacedElems.size()) {
    currBase = replacedElems.begin()->first;
  }
  for (auto curr = replacedElems.begin(); curr != replacedElems.end(); ++curr) {
    if (curr->first != currBase + currData.size()) {
      finishSegment();
      currBase = curr->first;
      currData.clear();
    }
    currData.push_back(curr->second);
  }
  if (currData.size()) {
    finishSegment();
  }
}

} // anonymous namespace

std::unique_ptr<Module> splitFunctions(Module& primary, const Config& config) {
  std::set<Name> secondaryFuncs;
  for (auto& func : primary.functions) {
    if (config.primaryFuncs.find(func->name) == config.primaryFuncs.end()) {
      secondaryFuncs.insert(func->name);
    }
  }

  auto ret = initializeSecondary(primary);
  Module& secondary = *ret;
  moveFunctions(primary, secondary, secondaryFuncs);
  exportImportPrimaryFunctions(
    primary, secondary, config.primaryFuncs, config.importNamespace);
  setupTablePatching(
    primary, secondary, secondaryFuncs, config.placeholderNamespace);
  shareImportableItems(primary, secondary, config.importNamespace);
  return ret;
}

} // namespace ModuleSplitting

} // namespace wasm
