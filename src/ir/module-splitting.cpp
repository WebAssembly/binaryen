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

// The process of module splitting involves these steps:
//
//   1. Create the new secondary module.
//
//   2. Export globals, events, tables, and memories from the primary module and
//      import them in the secondary module.
//
//   3. Move the deferred functions from the primary to the secondary module.
//
//   4. For any secondary function exported from the primary module, export in
//      its place a trampoline function that makes an indirect call to its
//      placeholder function (and eventually to the original secondary
//      function), allocating a new table slot for the placeholder if necessary.
//
//   5. Rewrite direct calls from primary functions to secondary functions to be
//      indirect calls to their placeholder functions (and eventually to their
//      original secondary functions), allocating new table slots for the
//      placeholders if necessary.
//
//   6. For each primary function directly called from a secondary function,
//      export the primary function if it is not already exported and import it
//      into the secondary module.
//
//   7. Replace all references to secondary functions in the primary module's
//      table segments with references to imported placeholder functions.
//
//   8. Create new active table segments in the secondary module that will
//      replace all the placeholder function references in the table with
//      references to their corresponding secondary functions upon
//      instantiation.
//
// Functions can be used or referenced three ways in a WebAssembly module: they
// can be exported, called, or placed in a table. The above procedure introduces
// a layer of indirection to each of those mechanisms that removes all
// references to secondary functions from the primary module but restores the
// original program's semantics once the secondary module is instantiated. As
// more mechanisms that reference functions are added in the future, such as
// ref.func instructions, they will have to be modified to use a similar layer
// of indirection.
//
// The code as currently written makes a few assumptions about the module that
// is being split:
//
//   1. It assumes that mutable-globals is allowed. This could be worked around
//      by introducing wrapper functions for globals and rewriting secondary
//      code that accesses them, but now that mutable-globals is shipped on all
//      browsers, hopefully that extra complexity won't be necessary.
//
//   2. It assumes that all table segment offsets are constants. This simplifies
//      the generation of segments to actively patch in the secondary functions
//      without overwriting any other table slots. This assumption could be
//      relaxed by 1) having secondary segments re-write primary function slots
//      as well, 2) allowing addition in segment offsets, or 3) synthesizing a
//      start function to modify the table instead of using segments.
//
//   3. It assumes that each function appears in the table at most once. This
//      isn't necessarily true in general or even for LLVM output after function
//      deduplication. Relaxing this assumption would just require slightly more
//      complex code, so it is a good candidate for a follow up PR.

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

struct TableSlotManager {
  Module& module;
  Table& table;
  Table::Segment* activeSegment = nullptr;
  Index activeBase = 0;
  std::map<Name, Index> funcIndices;

  TableSlotManager(Module& module);

  // Returns the table index for `func`, allocating a new index if necessary.
  Index getIndex(Name func);
  void addIndex(Name func, Index index);
};

void TableSlotManager::addIndex(Name func, Index index) {
  auto it = funcIndices.insert(std::make_pair(func, index));
  assert(it.second && "Function already has multiple indices");
}

TableSlotManager::TableSlotManager(Module& module)
  : module(module), table(module.table) {

  // Finds the segment with the highest occupied table slot so that new items
  // can be inserted contiguously at the end of it without accidentally
  // overwriting any other items. TODO: be more clever about filling gaps in the
  // table, if that is ever useful.
  Index maxIndex = 0;
  for (auto& segment : table.segments) {
    assert(segment.offset->is<Const>() &&
           "TODO: handle non-constant segment offsets");
    Index segmentBase = segment.offset->cast<Const>()->value.geti32();
    if (segmentBase + segment.data.size() >= maxIndex) {
      maxIndex = segmentBase + segment.data.size();
      activeSegment = &segment;
      activeBase = segmentBase;
    }
  }

  // Initialize funcIndices with the functions already in the table.
  forEachElement(table, [&](Index index, Name func) { addIndex(func, index); });
}

Index TableSlotManager::getIndex(Name func) {
  auto indexIt = funcIndices.find(func);
  if (indexIt != funcIndices.end()) {
    return indexIt->second;
  }

  // If there are no segments yet, allocate one.
  if (activeSegment == nullptr) {
    table.exists = true;
    assert(table.segments.size() == 0);
    table.segments.emplace_back(Builder(module).makeConst(int32_t(0)));
    activeSegment = &table.segments.front();
  }

  Index newIndex = activeBase + activeSegment->data.size();
  activeSegment->data.push_back(func);
  addIndex(func, newIndex);
  if (table.initial <= newIndex) {
    table.initial = newIndex + 1;
  }
  if (table.max <= newIndex) {
    table.max = newIndex + 1;
  }
  return newIndex;
}

struct ModuleSplitter {
  const Config& config;
  std::unique_ptr<Module> secondaryPtr;

  Module& primary;
  Module& secondary;

  const std::pair<std::set<Name>, std::set<Name>> classifiedFuncs;
  const std::set<Name>& primaryFuncs;
  const std::set<Name>& secondaryFuncs;

  TableSlotManager tableManager;

  static std::unique_ptr<Module> initSecondary(const Module& primary);
  static std::pair<std::set<Name>, std::set<Name>>
  classifyFuncs(const Module& primary, const Config& config);

  ModuleSplitter(Module& primary, const Config& config)
    : config(config), secondaryPtr(ModuleSplitter::initSecondary(primary)),
      primary(primary), secondary(*secondaryPtr),
      classifiedFuncs(ModuleSplitter::classifyFuncs(primary, config)),
      primaryFuncs(classifiedFuncs.first),
      secondaryFuncs(classifiedFuncs.second), tableManager(primary) {}

  void moveSecondaryFunctions();
  void exportImportPrimaryFunctions();
  void setupTablePatching();
  void shareImportableItems();
};

std::unique_ptr<Module> ModuleSplitter::initSecondary(const Module& primary) {
  // Create the secondary module and copy trivial properties.
  auto secondary = std::make_unique<Module>();
  secondary->features = primary.features;
  secondary->hasFeaturesSection = primary.hasFeaturesSection;
  return secondary;
}

std::pair<std::set<Name>, std::set<Name>>
ModuleSplitter::classifyFuncs(const Module& primary, const Config& config) {
  std::set<Name> primaryFuncs, secondaryFuncs;
  for (auto& func : primary.functions) {
    if (func->imported() || config.primaryFuncs.count(func->name)) {
      primaryFuncs.insert(func->name);
    } else {
      secondaryFuncs.insert(func->name);
    }
  }
  return std::make_pair(primaryFuncs, secondaryFuncs);
}

void ModuleSplitter::moveSecondaryFunctions() {
  // Move the specified functions from the primary to the secondary module.
  for (auto funcName : secondaryFuncs) {
    auto* func = primary.getFunction(funcName);
    assert(!func->imported() && "Cannot split off imported functions");
    assert(funcName != primary.start && "Cannot split off start function");
    ModuleUtils::copyFunction(func, secondary);
    primary.removeFunction(funcName);
  }

  // Update exports of secondary functions in the primary module to export
  // wrapper functions that indirectly call the secondary functions. We are
  // adding secondary function names to the primary table here, but they will be
  // replaced with placeholder functions later along with any references to
  // secondary functions that were already in the table.
  Builder builder(primary);
  for (auto& ex : primary.exports) {
    if (ex->kind != ExternalKind::Function ||
        !secondaryFuncs.count(ex->value)) {
      continue;
    }
    Name secondaryFunc = ex->value;
    Index tableIndex = tableManager.getIndex(secondaryFunc);
    auto func = std::make_unique<Function>();
    func->name = secondaryFunc;
    func->sig = secondary.getFunction(secondaryFunc)->sig;
    std::vector<Expression*> args;
    for (size_t i = 0, size = func->sig.params.size(); i < size; ++i) {
      args.push_back(builder.makeLocalGet(i, func->sig.params[i]));
    }
    func->body = builder.makeCallIndirect(
      builder.makeConst(int32_t(tableIndex)), args, func->sig);
    primary.addFunction(std::move(func));
  }

  // Update direct calls of secondary functions to be indirect calls of their
  // corresponding table indices instead.
  struct CallIndirector : public WalkerPass<PostWalker<CallIndirector>> {
    ModuleSplitter& parent;
    Builder builder;
    CallIndirector(ModuleSplitter& parent)
      : parent(parent), builder(parent.primary) {}
    void visitCall(Call* curr) {
      if (!parent.secondaryFuncs.count(curr->target)) {
        return;
      }
      replaceCurrent(builder.makeCallIndirect(
        builder.makeConst(int32_t(parent.tableManager.getIndex(curr->target))),
        curr->operands,
        parent.secondary.getFunction(curr->target)->sig,
        curr->isReturn));
    }
    void visitRefFunc(RefFunc* curr) {
      assert(false && "TODO: handle ref.func as well");
    }
  };
  PassRunner runner(&primary);
  CallIndirector(*this).run(&runner, &primary);
}

void ModuleSplitter::exportImportPrimaryFunctions() {
  // Find primary functions called in the secondary module.
  ModuleUtils::ParallelFunctionAnalysis<std::vector<Name>> callCollector(
    secondary, [&](Function* func, std::vector<Name>& calledPrimaryFuncs) {
      struct CallCollector : PostWalker<CallCollector> {
        const std::set<Name>& primaryFuncs;
        std::vector<Name>& calledPrimaryFuncs;
        CallCollector(const std::set<Name>& primaryFuncs,
                      std::vector<Name>& calledPrimaryFuncs)
          : primaryFuncs(primaryFuncs), calledPrimaryFuncs(calledPrimaryFuncs) {
        }

        void visitCall(Call* curr) {
          if (primaryFuncs.count(curr->target)) {
            calledPrimaryFuncs.push_back(curr->target);
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
      exportName = Names::getValidExportName(
        primary, config.newExportPrefix + primaryFunc.c_str());
      primary.addExport(
        new Export{exportName, primaryFunc, ExternalKind::Function});
    }
    auto func = std::make_unique<Function>();
    func->module = config.importNamespace;
    func->base = exportName;
    func->name = primaryFunc;
    func->sig = primary.getFunction(primaryFunc)->sig;
    secondary.addFunction(std::move(func));
  }
}

void ModuleSplitter::setupTablePatching() {
  std::map<Index, Name> replacedElems;
  // Replace table references to secondary functions with an imported
  // placeholder that encodes the table index in its name:
  // `importNamespace`.`index`.
  forEachElement(primary.table, [&](Index index, Name& elem) {
    if (secondaryFuncs.find(elem) != secondaryFuncs.end()) {
      replacedElems[index] = elem;
      auto* secondaryFunc = secondary.getFunction(elem);
      auto placeholder = std::make_unique<Function>();
      placeholder->module = config.placeholderNamespace;
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
    auto* offset = Builder(secondary).makeConst(int32_t(currBase));
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

void ModuleSplitter::shareImportableItems() {
  // Map internal names to (one of) their corresponding export names. Don't
  // consider functions because they have already been imported and exported as
  // necessary.
  std::unordered_map<Name, Name> exports;
  for (auto& ex : primary.exports) {
    if (ex->kind != ExternalKind::Function) {
      exports[ex->value] = ex->name;
    }
  }

  auto makeImportExport = [&](Importable& primaryItem,
                              Importable& secondaryItem,
                              const std::string& genericExportName,
                              ExternalKind kind) {
    secondaryItem.name = primaryItem.name;
    secondaryItem.hasExplicitName = primaryItem.hasExplicitName;
    secondaryItem.module = config.importNamespace;
    auto exportIt = exports.find(primaryItem.name);
    if (exportIt != exports.end()) {
      secondaryItem.base = exportIt->second;
    } else {
      Name exportName = Names::getValidExportName(
        primary, config.newExportPrefix + genericExportName);
      primary.addExport(new Export{exportName, primaryItem.name, kind});
      secondaryItem.base = exportName;
    }
  };

  // TODO: Be more selective by only sharing global items that are actually used
  // in the secondary module, just like we do for functions.

  if (primary.memory.exists) {
    secondary.memory.exists = true;
    secondary.memory.initial = primary.memory.initial;
    secondary.memory.max = primary.memory.max;
    secondary.memory.shared = primary.memory.shared;
    secondary.memory.indexType = primary.memory.indexType;
    makeImportExport(
      primary.memory, secondary.memory, "memory", ExternalKind::Memory);
  }

  if (primary.table.exists) {
    secondary.table.exists = true;
    secondary.table.initial = primary.table.initial;
    secondary.table.max = primary.table.max;
    makeImportExport(
      primary.table, secondary.table, "table", ExternalKind::Table);
  }

  for (auto& global : primary.globals) {
    if (global->mutable_) {
      assert(primary.features.hasMutableGlobals() &&
             "TODO: add wrapper functions for disallowed mutable globals");
    }
    auto secondaryGlobal = std::make_unique<Global>();
    secondaryGlobal->type = global->type;
    secondaryGlobal->mutable_ = global->mutable_;
    secondaryGlobal->init =
      global->init == nullptr
        ? nullptr
        : ExpressionManipulator::copy(global->init, secondary);
    makeImportExport(*global, *secondaryGlobal, "global", ExternalKind::Global);
    secondary.addGlobal(std::move(secondaryGlobal));
  }

  for (auto& event : primary.events) {
    auto secondaryEvent = std::make_unique<Event>();
    secondaryEvent->attribute = event->attribute;
    secondaryEvent->sig = event->sig;
    makeImportExport(*event, *secondaryEvent, "event", ExternalKind::Event);
    secondary.addEvent(std::move(secondaryEvent));
  }
}

} // anonymous namespace

std::unique_ptr<Module> splitFunctions(Module& primary, const Config& config) {
  ModuleSplitter splitter(primary, config);

  splitter.moveSecondaryFunctions();
  splitter.exportImportPrimaryFunctions();
  splitter.setupTablePatching();
  splitter.shareImportableItems();

  return std::move(splitter.secondaryPtr);
}

} // namespace ModuleSplitting

} // namespace wasm
