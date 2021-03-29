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
//   2. It assumes that either all table segment offsets are constants or there
//      is exactly one segment that may have a non-constant offset. It also
//      assumes that all segments are active segments (although Binaryen does
//      not yet support passive table segments anyway).
//
//   3. It assumes that each function appears in the table at most once. This
//      isn't necessarily true in general or even for LLVM output after function
//      deduplication. Relaxing this assumption would just require slightly more
//      complex code, so it is a good candidate for a follow up PR.

#include "ir/module-splitting.h"
#include "ir/element-utils.h"
#include "ir/manipulation.h"
#include "ir/module-utils.h"
#include "ir/names.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace ModuleSplitting {

namespace {

template<class F> void forEachElement(Module& module, F f) {
  ModuleUtils::iterActiveElementSegments(module, [&](ElementSegment* segment) {
    Name base = "";
    Index offset = 0;
    if (auto* c = segment->offset->dynCast<Const>()) {
      offset = c->value.geti32();
    } else if (auto* g = segment->offset->dynCast<GlobalGet>()) {
      base = g->name;
    }
    ElementUtils::iterElementSegmentFunctionNames(
      segment, [&](Name& entry, Index i) {
        f(segment->table, base, offset + i, entry);
      });
  });
}

static RefFunc* makeRefFunc(Module& wasm, Function* func) {
  // FIXME: make the type NonNullable when we support it!
  return Builder(wasm).makeRefFunc(func->name,
                                   Type(HeapType(func->sig), Nullable));
}

struct TableSlotManager {
  struct Slot {
    Name tableName;

    // If `global` is empty, then this slot is at a statically known index.
    Name global;
    Index index = 0;

    // Generate code to compute the index of this table slot
    Expression* makeExpr(Module& module);
  };
  Module& module;
  Table* activeTable = nullptr;
  ElementSegment* activeSegment = nullptr;
  Slot activeBase;
  std::map<Name, Slot> funcIndices;
  std::vector<ElementSegment*> activeTableSegments;

  TableSlotManager(Module& module);

  Table* makeTable();

  // Returns the table index for `func`, allocating a new index if necessary.
  Slot getSlot(RefFunc* entry);
  void addSlot(Name func, Slot slot);
};

Expression* TableSlotManager::Slot::makeExpr(Module& module) {
  Builder builder(module);
  auto makeIndex = [&]() { return builder.makeConst(int32_t(index)); };
  if (global.size()) {
    Expression* getBase = builder.makeGlobalGet(global, Type::i32);
    return index == 0 ? getBase
                      : builder.makeBinary(AddInt32, getBase, makeIndex());
  } else {
    return makeIndex();
  }
}

void TableSlotManager::addSlot(Name func, Slot slot) {
  auto it = funcIndices.insert(std::make_pair(func, slot));
  WASM_UNUSED(it);
  assert(it.second && "Function already has multiple table slots");
}

TableSlotManager::TableSlotManager(Module& module) : module(module) {
  // TODO: Reject or handle passive element segments

  auto it = std::find_if(module.tables.begin(),
                         module.tables.end(),
                         [&](std::unique_ptr<Table>& table) {
                           return table->type == Type::funcref;
                         });
  if (it == module.tables.end()) {
    return;
  }

  activeTable = it->get();
  ModuleUtils::iterTableSegments(
    module, activeTable->name, [&](ElementSegment* segment) {
      activeTableSegments.push_back(segment);
    });

  // If there is exactly one table segment and that segment has a non-constant
  // offset, append new items to the end of that segment. In all other cases,
  // append new items at constant offsets after all existing items at constant
  // offsets.
  if (activeTableSegments.size() == 1 &&
      activeTableSegments[0]->type == Type::funcref &&
      !activeTableSegments[0]->offset->is<Const>()) {
    assert(activeTableSegments[0]->offset->is<GlobalGet>() &&
           "Unexpected initializer instruction");
    activeSegment = activeTableSegments[0];
    activeBase = {activeTable->name,
                  activeTableSegments[0]->offset->cast<GlobalGet>()->name,
                  0};
  } else {
    // Finds the segment with the highest occupied table slot so that new items
    // can be inserted contiguously at the end of it without accidentally
    // overwriting any other items. TODO: be more clever about filling gaps in
    // the table, if that is ever useful.
    Index maxIndex = 0;
    for (auto& segment : activeTableSegments) {
      assert(segment->offset->is<Const>() &&
             "Unexpected non-const segment offset with multiple segments");
      Index segmentBase = segment->offset->cast<Const>()->value.geti32();
      if (segmentBase + segment->data.size() >= maxIndex) {
        maxIndex = segmentBase + segment->data.size();
        activeSegment = segment;
        activeBase = {activeTable->name, "", segmentBase};
      }
    }
  }

  // Initialize funcIndices with the functions already in the table.
  forEachElement(module, [&](Name table, Name base, Index offset, Name func) {
    addSlot(func, {table, base, offset});
  });
}

Table* TableSlotManager::makeTable() {
  return module.addTable(
    Builder::makeTable(Names::getValidTableName(module, Name::fromInt(0))));
}

TableSlotManager::Slot TableSlotManager::getSlot(RefFunc* entry) {
  auto slotIt = funcIndices.find(entry->func);
  if (slotIt != funcIndices.end()) {
    return slotIt->second;
  }

  // If there are no segments yet, allocate one.
  if (activeSegment == nullptr) {
    if (activeTable == nullptr) {
      activeTable = makeTable();
      activeBase = {activeTable->name, "", 0};
    }

    assert(std::all_of(module.elementSegments.begin(),
                       module.elementSegments.end(),
                       [&](std::unique_ptr<ElementSegment>& segment) {
                         return segment->table != activeTable->name;
                       }));
    auto segment = std::make_unique<ElementSegment>(
      activeTable->name, Builder(module).makeConst(int32_t(0)));
    segment->setName(Name::fromInt(0), false);
    activeSegment = segment.get();
    module.addElementSegment(std::move(segment));
  }

  Slot newSlot = {activeBase.tableName,
                  activeBase.global,
                  activeBase.index + Index(activeSegment->data.size())};

  activeSegment->data.push_back(entry);

  addSlot(entry->func, newSlot);
  if (activeTable->initial <= newSlot.index) {
    activeTable->initial = newSlot.index + 1;
  }
  if (activeTable->max <= newSlot.index) {
    activeTable->max = newSlot.index + 1;
  }
  return newSlot;
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

  // Map from internal function names to (one of) their corresponding export
  // names.
  std::map<Name, Name> exportedPrimaryFuncs;

  // Initialization helpers
  static std::unique_ptr<Module> initSecondary(const Module& primary);
  static std::pair<std::set<Name>, std::set<Name>>
  classifyFunctions(const Module& primary, const Config& config);
  static std::map<Name, Name> initExportedPrimaryFuncs(const Module& primary);

  // Other helpers
  void exportImportFunction(Name func);

  // Main splitting steps
  void moveSecondaryFunctions();
  void thunkExportedSecondaryFunctions();
  void indirectCallsToSecondaryFunctions();
  void exportImportCalledPrimaryFunctions();
  void setupTablePatching();
  void shareImportableItems();

  ModuleSplitter(Module& primary, const Config& config)
    : config(config), secondaryPtr(initSecondary(primary)), primary(primary),
      secondary(*secondaryPtr),
      classifiedFuncs(classifyFunctions(primary, config)),
      primaryFuncs(classifiedFuncs.first),
      secondaryFuncs(classifiedFuncs.second), tableManager(primary),
      exportedPrimaryFuncs(initExportedPrimaryFuncs(primary)) {
    moveSecondaryFunctions();
    thunkExportedSecondaryFunctions();
    indirectCallsToSecondaryFunctions();
    exportImportCalledPrimaryFunctions();
    setupTablePatching();
    shareImportableItems();
  }
};

std::unique_ptr<Module> ModuleSplitter::initSecondary(const Module& primary) {
  // Create the secondary module and copy trivial properties.
  auto secondary = std::make_unique<Module>();
  secondary->features = primary.features;
  secondary->hasFeaturesSection = primary.hasFeaturesSection;
  return secondary;
}

std::pair<std::set<Name>, std::set<Name>>
ModuleSplitter::classifyFunctions(const Module& primary, const Config& config) {
  std::set<Name> primaryFuncs, secondaryFuncs;
  for (auto& func : primary.functions) {
    if (func->imported() || config.primaryFuncs.count(func->name)) {
      primaryFuncs.insert(func->name);
    } else {
      assert(func->name != primary.start && "The start function must be kept");
      secondaryFuncs.insert(func->name);
    }
  }
  return std::make_pair(primaryFuncs, secondaryFuncs);
}

std::map<Name, Name>
ModuleSplitter::initExportedPrimaryFuncs(const Module& primary) {
  std::map<Name, Name> functionExportNames;
  for (auto& ex : primary.exports) {
    if (ex->kind == ExternalKind::Function) {
      functionExportNames[ex->value] = ex->name;
    }
  }
  return functionExportNames;
}

void ModuleSplitter::exportImportFunction(Name funcName) {
  Name exportName;
  // If the function is already exported, use the existing export name.
  // Otherwise, create a new export for it.
  auto exportIt = exportedPrimaryFuncs.find(funcName);
  if (exportIt != exportedPrimaryFuncs.end()) {
    exportName = exportIt->second;
  } else {
    exportName = Names::getValidExportName(
      primary, config.newExportPrefix + funcName.c_str());
    primary.addExport(
      Builder::makeExport(exportName, funcName, ExternalKind::Function));
    exportedPrimaryFuncs[funcName] = exportName;
  }
  // Import the function if it is not already imported into the secondary
  // module.
  if (secondary.getFunctionOrNull(funcName) == nullptr) {
    auto func =
      Builder::makeFunction(funcName, primary.getFunction(funcName)->sig, {});
    func->module = config.importNamespace;
    func->base = exportName;
    secondary.addFunction(std::move(func));
  }
}

void ModuleSplitter::moveSecondaryFunctions() {
  // Move the specified functions from the primary to the secondary module.
  for (auto funcName : secondaryFuncs) {
    auto* func = primary.getFunction(funcName);
    ModuleUtils::copyFunction(func, secondary);
    primary.removeFunction(funcName);
  }
}

void ModuleSplitter::thunkExportedSecondaryFunctions() {
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
    if (primary.getFunctionOrNull(secondaryFunc)) {
      // We've already created a thunk for this function
      continue;
    }
    auto func = std::make_unique<Function>();
    func->name = secondaryFunc;
    func->sig = secondary.getFunction(secondaryFunc)->sig;
    std::vector<Expression*> args;
    for (size_t i = 0, size = func->sig.params.size(); i < size; ++i) {
      args.push_back(builder.makeLocalGet(i, func->sig.params[i]));
    }

    auto tableSlot = tableManager.getSlot(makeRefFunc(primary, func.get()));
    func->body = builder.makeCallIndirect(
      tableSlot.tableName, tableSlot.makeExpr(primary), args, func->sig);
    primary.addFunction(std::move(func));
  }
}

void ModuleSplitter::indirectCallsToSecondaryFunctions() {
  // Update direct calls of secondary functions to be indirect calls of their
  // corresponding table indices instead.
  struct CallIndirector : public WalkerPass<PostWalker<CallIndirector>> {
    ModuleSplitter& parent;
    Builder builder;
    CallIndirector(ModuleSplitter& parent)
      : parent(parent), builder(parent.primary) {}
    // Avoid visitRefFunc on element segment data
    void walkElementSegment(ElementSegment* segment) {}
    void visitCall(Call* curr) {
      if (!parent.secondaryFuncs.count(curr->target)) {
        return;
      }
      auto func = parent.secondary.getFunction(curr->target);
      auto tableSlot =
        parent.tableManager.getSlot(makeRefFunc(parent.primary, func));
      replaceCurrent(
        builder.makeCallIndirect(tableSlot.tableName,
                                 tableSlot.makeExpr(parent.primary),
                                 curr->operands,
                                 func->sig,
                                 curr->isReturn));
    }
    void visitRefFunc(RefFunc* curr) {
      assert(false && "TODO: handle ref.func as well");
    }
  };
  PassRunner runner(&primary);
  CallIndirector(*this).run(&runner, &primary);
}

void ModuleSplitter::exportImportCalledPrimaryFunctions() {
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
        void visitRefFunc(RefFunc* curr) {
          assert(false && "TODO: handle ref.func as well");
        }
      };
      CallCollector(primaryFuncs, calledPrimaryFuncs).walkFunction(func);
    });
  std::set<Name> calledPrimaryFuncs;
  for (auto& entry : callCollector.map) {
    auto& calledFuncs = entry.second;
    calledPrimaryFuncs.insert(calledFuncs.begin(), calledFuncs.end());
  }

  // Ensure each called primary function is exported and imported
  for (auto func : calledPrimaryFuncs) {
    exportImportFunction(func);
  }
}

void ModuleSplitter::setupTablePatching() {
  if (!tableManager.activeTable) {
    return;
  }

  std::map<Index, Function*> replacedElems;
  // Replace table references to secondary functions with an imported
  // placeholder that encodes the table index in its name:
  // `importNamespace`.`index`.
  forEachElement(primary, [&](Name, Name, Index index, Name& elem) {
    if (secondaryFuncs.count(elem)) {
      auto* secondaryFunc = secondary.getFunction(elem);
      replacedElems[index] = secondaryFunc;
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

  if (replacedElems.size() == 0) {
    // No placeholders to patch out of the table
    return;
  }

  auto secondaryTable =
    ModuleUtils::copyTable(tableManager.activeTable, secondary);

  if (tableManager.activeBase.global.size()) {
    assert(tableManager.activeTableSegments.size() == 1 &&
           "Unexpected number of segments with non-const base");
    assert(secondary.tables.size() == 1 && secondary.elementSegments.empty());
    // Since addition is not currently allowed in initializer expressions, we
    // need to start the new secondary segment where the primary segment starts.
    // The secondary segment will contain the same primary functions as the
    // primary module except in positions where it needs to overwrite a
    // placeholder function. All primary functions in the table therefore need
    // to be imported into the second module. TODO: use better strategies here,
    // such as using ref.func in the start function or standardizing addition in
    // initializer expressions.
    ElementSegment* primarySeg = tableManager.activeTableSegments.front();
    std::vector<Expression*> secondaryElems;
    secondaryElems.reserve(primarySeg->data.size());

    // Copy functions from the primary segment to the secondary segment,
    // replacing placeholders and creating new exports and imports as necessary.
    auto replacement = replacedElems.begin();
    for (Index i = 0;
         i < primarySeg->data.size() && replacement != replacedElems.end();
         ++i) {
      if (replacement->first == i) {
        // primarySeg->data[i] is a placeholder, so use the secondary function.
        secondaryElems.push_back(makeRefFunc(secondary, replacement->second));
        ++replacement;
      } else if (auto* get = primarySeg->data[i]->dynCast<RefFunc>()) {
        exportImportFunction(get->func);
        auto* copied =
          ExpressionManipulator::copy(primarySeg->data[i], secondary);
        secondaryElems.push_back(copied);
      }
    }

    auto offset = ExpressionManipulator::copy(primarySeg->offset, secondary);
    auto secondarySeg = std::make_unique<ElementSegment>(
      secondaryTable->name, offset, secondaryTable->type, secondaryElems);
    secondarySeg->setName(primarySeg->name, primarySeg->hasExplicitName);
    secondary.addElementSegment(std::move(secondarySeg));
    return;
  }

  // Create active table segments in the secondary module to patch in the
  // original functions when it is instantiated.
  Index currBase = replacedElems.begin()->first;
  std::vector<Expression*> currData;
  auto finishSegment = [&]() {
    auto* offset = Builder(secondary).makeConst(int32_t(currBase));
    auto secondarySeg = std::make_unique<ElementSegment>(
      secondaryTable->name, offset, secondaryTable->type, currData);
    secondarySeg->setName(Name::fromInt(secondary.elementSegments.size()),
                          false);
    secondary.addElementSegment(std::move(secondarySeg));
  };
  for (auto curr = replacedElems.begin(); curr != replacedElems.end(); ++curr) {
    if (curr->first != currBase + currData.size()) {
      finishSegment();
      currBase = curr->first;
      currData.clear();
    }
    currData.push_back(makeRefFunc(secondary, curr->second));
  }
  if (currData.size()) {
    finishSegment();
  }
}

void ModuleSplitter::shareImportableItems() {
  // Map internal names to (one of) their corresponding export names. Don't
  // consider functions because they have already been imported and exported as
  // necessary.
  std::unordered_map<std::pair<ExternalKind, Name>, Name> exports;
  for (auto& ex : primary.exports) {
    if (ex->kind != ExternalKind::Function) {
      exports[std::make_pair(ex->kind, ex->value)] = ex->name;
    }
  }

  auto makeImportExport = [&](Importable& primaryItem,
                              Importable& secondaryItem,
                              const std::string& genericExportName,
                              ExternalKind kind) {
    secondaryItem.name = primaryItem.name;
    secondaryItem.hasExplicitName = primaryItem.hasExplicitName;
    secondaryItem.module = config.importNamespace;
    auto exportIt = exports.find(std::make_pair(kind, primaryItem.name));
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

  for (auto& table : primary.tables) {
    auto secondaryTable = secondary.getTableOrNull(table->name);
    if (!secondaryTable) {
      secondaryTable = ModuleUtils::copyTable(table.get(), secondary);
    }

    makeImportExport(*table, *secondaryTable, "table", ExternalKind::Table);
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
  return std::move(ModuleSplitter(primary, config).secondaryPtr);
}

} // namespace ModuleSplitting

} // namespace wasm
