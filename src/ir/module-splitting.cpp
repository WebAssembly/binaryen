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
//   1. Create the new secondary modules.
//
//   2. Move the deferred functions from the primary to each of the secondary
//      modules.
//
//   3. For any secondary function exported from the primary module, export in
//      its place a trampoline function that makes an indirect call to its
//      placeholder function (and eventually to the original secondary
//      function), allocating a new table slot for the placeholder if necessary.
//
//   4. Replace all references to each secondary module's functions in the
//      primary module's and each other secondary module's table segments with
//      references to imported placeholder functions.
//
//   5. Rewrite direct calls from primary functions to secondary functions to be
//      indirect calls to their placeholder functions (and eventually to their
//      original secondary functions), allocating new table slots for the
//      placeholders if necessary.
//
//   6. For each primary function directly called from a secondary function,
//      export the primary function if it is not already exported and import it
//      into each secondary module using it.
//
//   7. For each secondary module, create new active table segments in the
//      module that will replace all the placeholder function references in the
//      table with references to their corresponding secondary functions upon
//      instantiation.
//
//   8. Export globals, tags, tables, and memories from the primary module and
//      import them in the secondary modules.
//
//   9. Run RemoveUnusedModuleElements pass on the secondary modules in order to
//      remove unused imports.
//
// Functions can be used or referenced three ways in a WebAssembly module: they
// can be exported, called, or referenced with ref.func. The above procedure
// introduces a layer of indirection to each of those mechanisms that removes
// all references to secondary functions from the primary module but restores
// the original program's semantics once the secondary modules are instantiated.
//
// The code as currently written makes a couple assumptions about the module
// that is being split:
//
//   1. It assumes that mutable-globals is allowed. This could be worked around
//      by introducing wrapper functions for globals and rewriting secondary
//      code that accesses them, but now that mutable-globals is shipped on all
//      browsers, hopefully that extra complexity won't be necessary.
//
//   2. It assumes that either all table segment offsets are constants or there
//      is exactly one segment that may have a non-constant offset. It also
//      assumes that all segments are active segments.

#include "ir/module-splitting.h"
#include "asmjs/shared-constants.h"
#include "ir/export-utils.h"
#include "ir/module-utils.h"
#include "ir/names.h"
#include "ir/utils.h"
#include "pass.h"
#include "support/insert_ordered.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm::ModuleSplitting {

namespace {

static const Name LOAD_SECONDARY_STATUS = "load_secondary_module_status";

template<class F> void forEachElement(Module& module, F f) {
  ModuleUtils::iterActiveElementSegments(module, [&](ElementSegment* segment) {
    Name base = "";
    Index offset = 0;
    if (auto* c = segment->offset->dynCast<Const>()) {
      offset = c->value.getInteger();
    } else if (auto* g = segment->offset->dynCast<GlobalGet>()) {
      base = g->name;
    }
    for (Index i = 0; i < segment->data.size(); ++i) {
      f(segment->table, base, offset + i, segment->data[i]);
    }
  });
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
  ElementSegment* makeElementSegment();

  // Returns the table index for `func`, allocating a new index if necessary.
  Slot getSlot(Name func, HeapType type);
  void addSlot(Name func, Slot slot);
};

Expression* TableSlotManager::Slot::makeExpr(Module& module) {
  Builder builder(module);
  auto* table = module.getTable(tableName);
  auto makeIndex = [&]() {
    return builder.makeConst(Literal::makeFromInt32(index, table->addressType));
  };
  if (global.size()) {
    Expression* getBase = builder.makeGlobalGet(global, table->addressType);
    auto addOp = table->is64() ? AddInt64 : AddInt32;
    return index == 0 ? getBase
                      : builder.makeBinary(addOp, getBase, makeIndex());
  } else {
    return makeIndex();
  }
}

void TableSlotManager::addSlot(Name func, Slot slot) {
  // Ignore functions that already have slots.
  funcIndices.insert({func, slot});
}

TableSlotManager::TableSlotManager(Module& module) : module(module) {
  // If possible, just create a new table to manage all primary-to-secondary
  // calls lazily. Do not re-use slots for functions that will already be in
  // existing tables, since that is not correct in the face of table mutations.
  // However, do not do this for emscripten; its loader code (and dynamic
  // loading in particular) do not support this yet.
  // TODO: Reduce overhead by creating a separate table for each function type
  // if WasmGC is enabled.
  Export* emscriptenTableExport =
    module.getExportOrNull("__indirect_function_table");
  Table* singletonTable =
    module.tables.size() == 1 ? module.tables[0].get() : nullptr;
  bool emscriptenTableImport =
    singletonTable && singletonTable->imported() &&
    singletonTable->module == "env" &&
    singletonTable->base == "__indirect_function_table";

  if (module.features.hasReferenceTypes() && !emscriptenTableExport &&
      !emscriptenTableImport) {
    return;
  }

  // TODO: Reject or handle passive element segments
  auto funcref = Type(HeapType::func, Nullable);
  auto it = std::find_if(
    module.tables.begin(),
    module.tables.end(),
    [&](std::unique_ptr<Table>& table) { return table->type == funcref; });
  if (it == module.tables.end()) {
    // There is no indirect function table, so we will create one lazily.
    return;
  }

  activeTable = it->get();
  ModuleUtils::iterTableSegments(
    module, activeTable->name, [&](ElementSegment* segment) {
      activeTableSegments.push_back(segment);
    });

  if (activeTableSegments.empty()) {
    // There are no active segments, so we will lazily create one and start
    // filling it at index 0.
    activeBase = {activeTable->name, "", 0};
  } else if (activeTableSegments.size() == 1 &&
             activeTableSegments[0]->type == funcref &&
             !activeTableSegments[0]->offset->is<Const>()) {
    // If there is exactly one table segment and that segment has a non-constant
    // offset, append new items to the end of that segment. In all other cases,
    // append new items at constant offsets after all existing items at constant
    // offsets.
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
      Index segmentBase = segment->offset->cast<Const>()->value.getInteger();
      if (segmentBase + segment->data.size() >= maxIndex) {
        maxIndex = segmentBase + segment->data.size();
        activeSegment = segment;
        activeBase = {activeTable->name, "", segmentBase};
      }
    }
  }

  // Initialize funcIndices with the functions already in the table.
  forEachElement(module,
                 [&](Name table, Name base, Index offset, Expression* elem) {
                   if (auto* func = elem->dynCast<RefFunc>()) {
                     addSlot(func->func, {table, base, offset});
                   }
                 });
}

Table* TableSlotManager::makeTable() {
  return module.addTable(
    Builder::makeTable(Names::getValidTableName(module, Name::fromInt(0))));
}

ElementSegment* TableSlotManager::makeElementSegment() {
  Builder builder(module);
  Expression* offset =
    builder.makeConst(Literal::makeFromInt32(0, activeTable->addressType));
  return module.addElementSegment(Builder::makeElementSegment(
    Names::getValidElementSegmentName(module, Name::fromInt(0)),
    activeTable->name,
    offset));
}

TableSlotManager::Slot TableSlotManager::getSlot(Name func, HeapType type) {
  auto slotIt = funcIndices.find(func);
  if (slotIt != funcIndices.end()) {
    return slotIt->second;
  }

  // If there are no segments yet, allocate one.
  if (activeSegment == nullptr) {
    if (activeTable == nullptr) {
      activeTable = makeTable();
      activeBase = {activeTable->name, "", 0};
    }

    // None of the existing segments should refer to the active table
    assert(std::all_of(module.elementSegments.begin(),
                       module.elementSegments.end(),
                       [&](std::unique_ptr<ElementSegment>& segment) {
                         return segment->table != activeTable->name;
                       }));

    activeSegment = makeElementSegment();
  }

  Slot newSlot = {activeBase.tableName,
                  activeBase.global,
                  activeBase.index + Index(activeSegment->data.size())};

  Builder builder(module);
  auto funcType = Type(type, NonNullable, Inexact);
  activeSegment->data.push_back(builder.makeRefFunc(func, funcType));

  addSlot(func, newSlot);
  if (activeTable->initial <= newSlot.index) {
    activeTable->initial = newSlot.index + 1;
    // TODO: handle the active table not being the dylink table (#3823)
    if (module.dylinkSection) {
      module.dylinkSection->tableSize = activeTable->initial;
    }
  }
  if (activeTable->max <= newSlot.index) {
    activeTable->max = newSlot.index + 1;
  }
  return newSlot;
}

struct ModuleSplitter {
  const Config& config;
  std::vector<std::unique_ptr<Module>> secondaries;

  Module& primary;

  std::unordered_set<Name> primaryFuncs;
  std::unordered_set<Name> allSecondaryFuncs;
  std::unordered_map<Name, Index> funcToSecondaryIndex;

  TableSlotManager tableManager;

  Names::MinifiedNameGenerator minified;

  // Map from internal function names to (one of) their corresponding export
  // names.
  std::unordered_map<Name, Name> exportedPrimaryFuncs;

  // For each table, map placeholder indices to the names of the functions they
  // replace.
  std::unordered_map<Name, std::map<size_t, Name>> placeholderMap;

  // Internal name of the LOAD_SECONDARY_MODULE function.
  Name internalLoadSecondaryModule;

  // Map from original secondary function name to its trampoline
  std::unordered_map<Name, Name> trampolineMap;

  // Initialization helpers
  static std::unique_ptr<Module> initSecondary(const Module& primary);
  static std::unordered_map<Name, Name>
  initExportedPrimaryFuncs(const Module& primary);

  // Other helpers
  void exportImportFunction(Name func, const std::set<Module*>& modules);
  Expression* maybeLoadSecondary(Builder& builder, Expression* callIndirect);
  Name getTrampoline(Name funcName);

  // Main splitting steps
  void classifyFunctions();
  void setupJSPI();
  void moveSecondaryFunctions();
  void thunkExportedSecondaryFunctions();
  void indirectReferencesToSecondaryFunctions();
  void indirectCallsToSecondaryFunctions();
  void exportImportCalledPrimaryFunctions();
  void setupTablePatching();
  void shareImportableItems();
  void removeUnusedSecondaryElements();
  void updateIR();

  ModuleSplitter(Module& primary, const Config& config)
    : config(config), primary(primary), tableManager(primary),
      exportedPrimaryFuncs(initExportedPrimaryFuncs(primary)) {
    classifyFunctions();
    if (config.jspi) {
      setupJSPI();
    }
    moveSecondaryFunctions();
    thunkExportedSecondaryFunctions();
    indirectReferencesToSecondaryFunctions();
    indirectCallsToSecondaryFunctions();
    exportImportCalledPrimaryFunctions();
    setupTablePatching();
    shareImportableItems();
    removeUnusedSecondaryElements();
    updateIR();
  }
};

void ModuleSplitter::setupJSPI() {
  // Support the first version of JSPI, where the JSPI pass added the load
  // secondary module export.
  // TODO: remove this when the new JSPI API is only supported.
  if (auto* loadSecondary = primary.getExportOrNull(LOAD_SECONDARY_MODULE);
      loadSecondary && loadSecondary->kind == ExternalKind::Function) {
    internalLoadSecondaryModule = *loadSecondary->getInternalName();
    // Remove the exported LOAD_SECONDARY_MODULE function since it's only needed
    // internally.
    primary.removeExport(LOAD_SECONDARY_MODULE);
  } else {
    // Add an imported function to load the secondary module.
    auto import = Builder::makeFunction(
      ModuleSplitting::LOAD_SECONDARY_MODULE,
      Type(Signature(Type::none, Type::none), NonNullable, Inexact),
      {});
    import->module = ENV;
    import->base = ModuleSplitting::LOAD_SECONDARY_MODULE;
    primary.addFunction(std::move(import));
    internalLoadSecondaryModule = ModuleSplitting::LOAD_SECONDARY_MODULE;
  }
  Builder builder(primary);
  // Add a global to track whether the secondary module has been loaded yet.
  primary.addGlobal(builder.makeGlobal(LOAD_SECONDARY_STATUS,
                                       Type::i32,
                                       builder.makeConst(int32_t(0)),
                                       Builder::Mutable));
  primary.addExport(builder.makeExport(
    LOAD_SECONDARY_STATUS, LOAD_SECONDARY_STATUS, ExternalKind::Global));
}

std::unique_ptr<Module> ModuleSplitter::initSecondary(const Module& primary) {
  // Create the secondary module and copy trivial properties.
  auto secondary = std::make_unique<Module>();
  secondary->features = primary.features;
  secondary->hasFeaturesSection = primary.hasFeaturesSection;
  return secondary;
}

void ModuleSplitter::classifyFunctions() {
  // Find functions that refer to data or element segments. These functions must
  // remain in the primary module because segments cannot be exported to be
  // accessed from the secondary module.
  //
  // TODO: Investigate other options, such as moving the segments to the
  // secondary module or replacing the segment-using instructions in the
  // secondary module with calls to imports.
  ModuleUtils::ParallelFunctionAnalysis<std::vector<Name>>
    segmentReferrerCollector(
      primary, [&](Function* func, std::vector<Name>& segmentReferrers) {
        if (func->imported()) {
          return;
        }

        struct SegmentReferrerCollector
          : PostWalker<SegmentReferrerCollector,
                       UnifiedExpressionVisitor<SegmentReferrerCollector>> {
          bool hasSegmentReference = false;

          void visitExpression(Expression* curr) {

#define DELEGATE_ID curr->_id

#define DELEGATE_START(id) [[maybe_unused]] auto* cast = curr->cast<id>();
#define DELEGATE_GET_FIELD(id, field) cast->field
#define DELEGATE_FIELD_TYPE(id, field)
#define DELEGATE_FIELD_HEAPTYPE(id, field)
#define DELEGATE_FIELD_CHILD(id, field)
#define DELEGATE_FIELD_OPTIONAL_CHILD(id, field)
#define DELEGATE_FIELD_INT(id, field)
#define DELEGATE_FIELD_LITERAL(id, field)
#define DELEGATE_FIELD_NAME(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_USE(id, field)
#define DELEGATE_FIELD_ADDRESS(id, field)

#define DELEGATE_FIELD_NAME_KIND(id, field, kind)                              \
  if (kind == ModuleItemKind::DataSegment ||                                   \
      kind == ModuleItemKind::ElementSegment) {                                \
    hasSegmentReference = true;                                                \
  }

#include "wasm-delegations-fields.def"
          }
        };
        SegmentReferrerCollector collector;
        collector.walkFunction(func);
        if (collector.hasSegmentReference) {
          segmentReferrers.push_back(func->name);
        }
      });

  std::unordered_set<Name> segmentReferrers;
  for (auto& [_, referrers] : segmentReferrerCollector.map) {
    segmentReferrers.insert(referrers.begin(), referrers.end());
  }

  std::unordered_set<Name> configSecondaryFuncs;
  for (auto& funcs : config.secondaryFuncs) {
    configSecondaryFuncs.insert(funcs.begin(), funcs.end());
  }
  for (auto& func : primary.functions) {
    // In JSPI mode exported functions cannot be moved to the secondary
    // module since that would make them async when they may not have the JSPI
    // wrapper. Exported JSPI functions can still benefit from splitting though
    // since only the JSPI wrapper stub will remain in the primary module.
    if (func->imported() || !configSecondaryFuncs.count(func->name) ||
        (config.jspi && ExportUtils::isExported(primary, *func)) ||
        segmentReferrers.count(func->name)) {
      primaryFuncs.insert(func->name);
    } else {
      assert(func->name != primary.start && "The start function must be kept");
      allSecondaryFuncs.insert(func->name);
    }
  }
}

std::unordered_map<Name, Name>
ModuleSplitter::initExportedPrimaryFuncs(const Module& primary) {
  std::unordered_map<Name, Name> functionExportNames;
  for (auto& ex : primary.exports) {
    if (ex->kind == ExternalKind::Function) {
      functionExportNames[*ex->getInternalName()] = ex->name;
    }
  }
  return functionExportNames;
}

void ModuleSplitter::exportImportFunction(Name funcName,
                                          const std::set<Module*>& modules) {
  Name exportName;
  // If the function is already exported, use the existing export name.
  // Otherwise, create a new export for it.
  auto exportIt = exportedPrimaryFuncs.find(funcName);
  if (exportIt != exportedPrimaryFuncs.end()) {
    exportName = exportIt->second;
  } else {
    if (config.minimizeNewExportNames) {
      do {
        exportName = config.newExportPrefix + minified.getName();
      } while (primary.getExportOrNull(exportName) != nullptr);
    } else {
      exportName = Names::getValidExportName(
        primary, config.newExportPrefix + funcName.toString());
    }
    primary.addExport(
      Builder::makeExport(exportName, funcName, ExternalKind::Function));
    exportedPrimaryFuncs[funcName] = exportName;
  }
  // Import the function if it is not already imported into the secondary
  // module.
  for (auto* secondary : modules) {
    if (secondary->getFunctionOrNull(funcName) == nullptr) {
      auto primaryFunc = primary.getFunction(funcName);
      auto func = Builder::makeFunction(funcName, primaryFunc->type, {});
      func->hasExplicitName = primaryFunc->hasExplicitName;
      func->module = config.importNamespace;
      func->base = exportName;
      func->type = func->type.with(Inexact);
      secondary->addFunction(std::move(func));
    }
  }
}

void ModuleSplitter::moveSecondaryFunctions() {
  // Move the specified functions from the primary to the secondary modules.
  for (auto& funcNames : config.secondaryFuncs) {
    auto secondary = initSecondary(primary);
    for (auto funcName : funcNames) {
      if (allSecondaryFuncs.count(funcName)) {
        auto* func = primary.getFunction(funcName);
        ModuleUtils::copyFunction(func, *secondary);
        primary.removeFunction(funcName);
        funcToSecondaryIndex[funcName] = secondaries.size();
      }
    }
    secondaries.push_back(std::move(secondary));
  }
}

Name ModuleSplitter::getTrampoline(Name funcName) {
  auto [it, inserted] = trampolineMap.insert({funcName, Name()});
  if (!inserted) {
    return it->second;
  }

  Builder builder(primary);
  Module& secondary = *secondaries.at(funcToSecondaryIndex.at(funcName));
  auto* oldFunc = secondary.getFunction(funcName);
  auto trampoline = Names::getValidFunctionName(
    primary, std::string("trampoline_") + funcName.toString());
  it->second = trampoline;

  // Generate the call and the function.
  std::vector<Expression*> args;
  for (Index i = 0; i < oldFunc->getNumParams(); i++) {
    args.push_back(builder.makeLocalGet(i, oldFunc->getLocalType(i)));
  }
  auto* call = builder.makeCall(funcName, args, oldFunc->getResults());

  auto func = builder.makeFunction(trampoline, oldFunc->type, {}, call);
  func->hasExplicitName = oldFunc->hasExplicitName;
  primary.addFunction(std::move(func));
  primaryFuncs.insert(trampoline);
  return trampoline;
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
        !allSecondaryFuncs.count(*ex->getInternalName())) {
      continue;
    }
    Name trampoline = getTrampoline(*ex->getInternalName());
    ex->setInternalName(trampoline);
  }
}

Expression* ModuleSplitter::maybeLoadSecondary(Builder& builder,
                                               Expression* callIndirect) {
  if (!config.jspi) {
    return callIndirect;
  }
  // Check if the secondary module is loaded and if it isn't, call the
  // function to load it.
  auto* loadSecondary = builder.makeIf(
    builder.makeUnary(EqZInt32,
                      builder.makeGlobalGet(LOAD_SECONDARY_STATUS, Type::i32)),
    builder.makeCall(internalLoadSecondaryModule, {}, Type::none));
  return builder.makeSequence(loadSecondary, callIndirect);
}

void ModuleSplitter::indirectReferencesToSecondaryFunctions() {
  // Turn references to secondary functions into references to thunks that
  // perform a direct call to the original referent. The direct calls in the
  // thunks will be handled like all other cross-module calls later, in
  // |indirectCallsToSecondaryFunctions|.
  struct Gatherer : public PostWalker<Gatherer> {
    ModuleSplitter& parent;

    Gatherer(ModuleSplitter& parent) : parent(parent) {}

    // Collect RefFuncs in a map from the function name to all RefFuncs that
    // refer to it. We only collect this for secondary funcs.
    InsertOrderedMap<Name, std::vector<RefFunc*>> map;

    void visitRefFunc(RefFunc* curr) {
      Module* currModule = getModule();
      // Add ref.func to the map when
      // 1. ref.func's target func is in one of the secondary modules and
      // 2. the current module is a different module (either the primary module
      //    or a different secondary module)
      if (parent.allSecondaryFuncs.count(curr->func) &&
          (currModule == &parent.primary ||
           parent.secondaries.at(parent.funcToSecondaryIndex.at(curr->func))
               .get() != currModule)) {
        map[curr->func].push_back(curr);
      }
    }
  } gatherer(*this);
  gatherer.walkModule(&primary);
  for (auto& secondaryPtr : secondaries) {
    gatherer.walkModule(secondaryPtr.get());
  }

  // Ignore references to secondary functions that occur in the active segment
  // that will contain the imported placeholders. Indirect calls to table slots
  // initialized by that segment will already go to the right place once the
  // secondary module has been loaded and the table has been patched.
  std::unordered_set<RefFunc*> ignore;
  if (tableManager.activeSegment) {
    for (auto* expr : tableManager.activeSegment->data) {
      if (auto* ref = expr->dynCast<RefFunc>()) {
        ignore.insert(ref);
      }
    }
  }

  // Fix up what we found: Generate trampolines as described earlier, and apply
  // them.
  Builder builder(primary);
  // Generate the new trampoline function and add it to the module.
  for (auto& [name, refFuncs] : gatherer.map) {
    // Find the relevant (non-ignored) RefFuncs. If there are none, we can skip
    // creating a thunk entirely.
    std::vector<RefFunc*> relevantRefFuncs;
    for (auto* refFunc : refFuncs) {
      assert(refFunc->func == name);
      if (!ignore.count(refFunc)) {
        relevantRefFuncs.push_back(refFunc);
      }
    }
    if (relevantRefFuncs.empty()) {
      continue;
    }

    Name trampoline = getTrampoline(name);
    // Update RefFuncs to refer to it.
    for (auto* refFunc : relevantRefFuncs) {
      refFunc->func = trampoline;
    }
  }
}

void ModuleSplitter::indirectCallsToSecondaryFunctions() {
  // Update direct calls of secondary functions to be indirect calls of their
  // corresponding table indices instead.
  struct CallIndirector : public PostWalker<CallIndirector> {
    ModuleSplitter& parent;
    CallIndirector(ModuleSplitter& parent) : parent(parent) {}
    void visitCall(Call* curr) {
      // Return if the call's target is not in one of the secondary module.
      if (!parent.allSecondaryFuncs.count(curr->target)) {
        return;
      }
      // Return if the current module is the same module as the call's target,
      // because we don't need a call_indirect within the same module.
      Module* currModule = getModule();
      if (currModule != &parent.primary &&
          parent.secondaries.at(parent.funcToSecondaryIndex.at(curr->target))
              .get() == currModule) {
        return;
      }

      Builder builder(*getModule());
      Index secIndex = parent.funcToSecondaryIndex.at(curr->target);
      auto* func = parent.secondaries.at(secIndex)->getFunction(curr->target);
      auto tableSlot =
        parent.tableManager.getSlot(curr->target, func->type.getHeapType());

      replaceCurrent(parent.maybeLoadSecondary(
        builder,
        builder.makeCallIndirect(tableSlot.tableName,
                                 tableSlot.makeExpr(parent.primary),
                                 curr->operands,
                                 func->type.getHeapType(),
                                 curr->isReturn)));
    }
  };
  CallIndirector callIndirector(*this);
  callIndirector.walkModule(&primary);
  for (auto& secondaryPtr : secondaries) {
    callIndirector.walkModule(secondaryPtr.get());
  }
}

void ModuleSplitter::exportImportCalledPrimaryFunctions() {
  // Find primary functions called/referred to from the secondary modules.
  using CalledPrimaryToModules = std::map<Name, std::set<Module*>>;
  for (auto& secondaryPtr : secondaries) {
    Module* secondary = secondaryPtr.get();
    ModuleUtils::ParallelFunctionAnalysis<CalledPrimaryToModules> callCollector(
      *secondary,
      [&](Function* func, CalledPrimaryToModules& calledPrimaryToModules) {
        struct CallCollector : PostWalker<CallCollector> {
          const std::unordered_set<Name>& primaryFuncs;
          CalledPrimaryToModules& calledPrimaryToModules;
          CallCollector(const std::unordered_set<Name>& primaryFuncs,
                        CalledPrimaryToModules& calledPrimaryToModules)
            : primaryFuncs(primaryFuncs),
              calledPrimaryToModules(calledPrimaryToModules) {}
          void visitCall(Call* curr) {
            if (primaryFuncs.count(curr->target)) {
              calledPrimaryToModules[curr->target].insert(getModule());
            }
          }
          void visitRefFunc(RefFunc* curr) {
            if (primaryFuncs.count(curr->func)) {
              calledPrimaryToModules[curr->func].insert(getModule());
            }
          }
        };
        CallCollector(primaryFuncs, calledPrimaryToModules)
          .walkFunctionInModule(func, secondary);
      });

    CalledPrimaryToModules calledPrimaryToModules;
    for (auto& [_, map] : callCollector.map) {
      calledPrimaryToModules.merge(map);
    }

    // Ensure each called primary function is exported and imported
    for (auto& [func, modules] : calledPrimaryToModules) {
      exportImportFunction(func, modules);
    }
  }
}

void ModuleSplitter::setupTablePatching() {
  if (!tableManager.activeTable) {
    return;
  }

  std::map<Module*, std::map<Index, Function*>> moduleToReplacedElems;
  // Replace table references to secondary functions with an imported
  // placeholder that encodes the table index in its name:
  // `importNamespace`.`index`.
  forEachElement(
    primary, [&](Name table, Name, Index index, Expression*& elem) {
      auto* ref = elem->dynCast<RefFunc>();
      if (!ref) {
        return;
      }
      if (!allSecondaryFuncs.count(ref->func)) {
        return;
      }
      assert(table == tableManager.activeTable->name);

      placeholderMap[table][index] = ref->func;
      Index secondaryIndex = funcToSecondaryIndex.at(ref->func);
      Module& secondary = *secondaries.at(secondaryIndex);
      Name secondaryName = config.secondaryNames.at(secondaryIndex);
      auto* secondaryFunc = secondary.getFunction(ref->func);
      moduleToReplacedElems[&secondary][index] = secondaryFunc;
      if (!config.usePlaceholders) {
        // TODO: This can create active element segments with lots of nulls. We
        // should optimize them like we do data segments with zeros.
        elem = Builder(primary).makeRefNull(HeapType::nofunc);
        return;
      }
      auto placeholder = std::make_unique<Function>();
      placeholder->module = config.placeholderNamespacePrefix.toString() + "." +
                            secondaryName.toString();
      placeholder->base = std::to_string(index);
      placeholder->name = Names::getValidFunctionName(
        primary, std::string("placeholder_") + placeholder->base.toString());
      placeholder->hasExplicitName = true;
      placeholder->type = secondaryFunc->type.with(Inexact);
      elem = Builder(primary).makeRefFunc(placeholder->name, placeholder->type);
      primary.addFunction(std::move(placeholder));
    });

  if (moduleToReplacedElems.size() == 0) {
    // No placeholders to patch out of the table
    return;
  }

  for (auto& [secondaryPtr, replacedElems] : moduleToReplacedElems) {
    Module& secondary = *secondaryPtr;
    auto secondaryTable =
      ModuleUtils::copyTable(tableManager.activeTable, secondary);

    if (tableManager.activeBase.global.size()) {
      assert(tableManager.activeTableSegments.size() == 1 &&
             "Unexpected number of segments with non-const base");
      assert(secondary.tables.size() == 1 && secondary.elementSegments.empty());
      // Since addition is not currently allowed in initializer expressions, we
      // need to start the new secondary segment where the primary segment
      // starts. The secondary segment will contain the same primary functions
      // as the primary module except in positions where it needs to overwrite a
      // placeholder function. All primary functions in the table therefore need
      // to be imported into the second module. TODO: use better strategies
      // here, such as using ref.func in the start function or standardizing
      // addition in initializer expressions.
      ElementSegment* primarySeg = tableManager.activeTableSegments.front();
      std::vector<Expression*> secondaryElems;
      secondaryElems.reserve(primarySeg->data.size());

      // Copy functions from the primary segment to the secondary segment,
      // replacing placeholders and creating new exports and imports as
      // necessary.
      auto replacement = replacedElems.begin();
      for (Index i = 0;
           i < primarySeg->data.size() && replacement != replacedElems.end();
           ++i) {
        if (replacement->first == i) {
          // primarySeg->data[i] is a placeholder, so use the secondary
          // function.
          auto* func = replacement->second;
          auto* ref = Builder(secondary).makeRefFunc(func->name, func->type);
          secondaryElems.push_back(ref);
          ++replacement;
        } else if (auto* get = primarySeg->data[i]->dynCast<RefFunc>()) {
          exportImportFunction(get->func, {&secondary});
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
      auto* offset = Builder(secondary).makeConst(
        Literal::makeFromInt32(currBase, secondaryTable->addressType));
      auto secondarySeg = std::make_unique<ElementSegment>(
        secondaryTable->name, offset, secondaryTable->type, currData);
      Name name = Names::getValidElementSegmentName(
        secondary, Name::fromInt(secondary.elementSegments.size()));
      secondarySeg->setName(name, false);
      secondary.addElementSegment(std::move(secondarySeg));
    };
    for (auto curr = replacedElems.begin(); curr != replacedElems.end();
         ++curr) {
      if (curr->first != currBase + currData.size()) {
        finishSegment();
        currBase = curr->first;
        currData.clear();
      }
      auto* func = curr->second;
      currData.push_back(
        Builder(secondary).makeRefFunc(func->name, func->type));
    }
    if (currData.size()) {
      finishSegment();
    }
  }
}

void ModuleSplitter::shareImportableItems() {
  // Map internal names to (one of) their corresponding export names. Don't
  // consider functions because they have already been imported and exported as
  // necessary.
  std::unordered_map<std::pair<ExternalKind, Name>, Name> exports;
  for (auto& ex : primary.exports) {
    if (ex->kind != ExternalKind::Function) {
      if (auto* name = ex->getInternalName()) {
        exports[std::make_pair(ex->kind, *name)] = ex->name;
      }
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
      std::string baseName =
        config.newExportPrefix + (config.minimizeNewExportNames
                                    ? minified.getName()
                                    : genericExportName);
      Name exportName = Names::getValidExportName(primary, baseName);
      primary.addExport(new Export(exportName, kind, primaryItem.name));
      secondaryItem.base = exportName;
      exports[std::make_pair(kind, primaryItem.name)] = exportName;
    }
  };

  // TODO: Be more selective by only sharing global items that are actually used
  // in the secondary module, just like we do for functions.

  for (auto& secondaryPtr : secondaries) {
    Module& secondary = *secondaryPtr;
    for (auto& memory : primary.memories) {
      auto secondaryMemory = ModuleUtils::copyMemory(memory.get(), secondary);
      makeImportExport(
        *memory, *secondaryMemory, "memory", ExternalKind::Memory);
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
      makeImportExport(
        *global, *secondaryGlobal, "global", ExternalKind::Global);
      secondary.addGlobal(std::move(secondaryGlobal));
    }

    for (auto& tag : primary.tags) {
      auto secondaryTag = std::make_unique<Tag>();
      secondaryTag->type = tag->type;
      makeImportExport(*tag, *secondaryTag, "tag", ExternalKind::Tag);
      secondary.addTag(std::move(secondaryTag));
    }
  }
}

void ModuleSplitter::removeUnusedSecondaryElements() {
  // TODO: It would be better to be more selective about only exporting and
  // importing those items that the secondary module needs. This would reduce
  // code size in the primary module as well.
  for (auto& secondaryPtr : secondaries) {
    PassRunner runner(secondaryPtr.get());
    // Do not validate here in the middle, as the IR still needs updating later.
    runner.options.validate = false;
    runner.add("remove-unused-module-elements");
    runner.run();
  }
}

void ModuleSplitter::updateIR() {
  // Imported functions may need type updates.
  struct Fixer : public PostWalker<Fixer> {
    void visitRefFunc(RefFunc* curr) {
      auto& wasm = *getModule();
      auto* func = wasm.getFunction(curr->func);
      if (func->type != curr->type) {
        // This became an import, and lost exactness.
        assert(!func->type.isExact());
        assert(curr->type.isExact());
        if (wasm.features.hasCustomDescriptors()) {
          // Add a cast, as the parent may depend on the exactness to validate.
          // TODO: The cast may be needed even without CD enabled
          replaceCurrent(Builder(wasm).makeRefCast(curr, curr->type));
        }
        curr->type = curr->type.with(Inexact);
      }
    }
  } fixer;
  fixer.walkModule(&primary);
  for (auto& secondaryPtr : secondaries) {
    fixer.walkModule(secondaryPtr.get());
  }
}

} // anonymous namespace

Results splitFunctions(Module& primary, const Config& config) {
  ModuleSplitter split(primary, config);
  return {std::move(split.secondaries), std::move(split.placeholderMap)};
}

} // namespace wasm::ModuleSplitting
