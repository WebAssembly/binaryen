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
//   2. Export globals, tags, tables, and memories from the primary module and
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
//      assumes that all segments are active segments (although Binaryen does
//      not yet support passive table segments anyway).

#include "ir/module-splitting.h"
#include "asmjs/shared-constants.h"
#include "ir/element-utils.h"
#include "ir/export-utils.h"
#include "ir/manipulation.h"
#include "ir/module-utils.h"
#include "ir/names.h"
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
  // Ignore functions that already have slots.
  funcIndices.insert({func, slot});
}

TableSlotManager::TableSlotManager(Module& module) : module(module) {
  if (module.features.hasReferenceTypes()) {
    // Just create a new table to manage all primary-to-secondary calls lazily.
    // Do not re-use slots for functions that will already be in existing
    // tables, since that is not correct in the face of table mutations.
    // TODO: Reduce overhead by creating a separate table for each function type
    // if WasmGC is enabled.
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

ElementSegment* TableSlotManager::makeElementSegment() {
  return module.addElementSegment(Builder::makeElementSegment(
    Names::getValidElementSegmentName(module, Name::fromInt(0)),
    activeTable->name,
    Builder(module).makeConst(int32_t(0))));
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
  activeSegment->data.push_back(builder.makeRefFunc(func, type));

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
  std::unique_ptr<Module> secondaryPtr;

  Module& primary;
  Module& secondary;

  const std::pair<std::set<Name>, std::set<Name>> classifiedFuncs;
  const std::set<Name>& primaryFuncs;
  const std::set<Name>& secondaryFuncs;

  TableSlotManager tableManager;

  Names::MinifiedNameGenerator minified;

  // Map from internal function names to (one of) their corresponding export
  // names.
  std::map<Name, Name> exportedPrimaryFuncs;

  // Map placeholder indices to the names of the functions they replace.
  std::map<size_t, Name> placeholderMap;

  // Internal name of the LOAD_SECONDARY_MODULE function.
  Name internalLoadSecondaryModule;

  // Initialization helpers
  static std::unique_ptr<Module> initSecondary(const Module& primary);
  static std::pair<std::set<Name>, std::set<Name>>
  classifyFunctions(Module& primary, const Config& config);
  static std::map<Name, Name> initExportedPrimaryFuncs(const Module& primary);

  // Other helpers
  void exportImportFunction(Name func);
  Expression* maybeLoadSecondary(Builder& builder, Expression* callIndirect);

  // Main splitting steps
  void setupJSPI();
  void moveSecondaryFunctions();
  void thunkExportedSecondaryFunctions();
  void indirectCallsToSecondaryFunctions();
  void indirectReferencesToSecondaryFunctions();
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
  }
};

void ModuleSplitter::setupJSPI() {
  // Support the first version of JSPI, where the JSPI pass added the load
  // secondary module export.
  // TODO: remove this when the new JSPI API is only supported.
  if (primary.getExportOrNull(LOAD_SECONDARY_MODULE)) {
    internalLoadSecondaryModule =
      primary.getExport(LOAD_SECONDARY_MODULE)->value;
    // Remove the exported LOAD_SECONDARY_MODULE function since it's only needed
    // internally.
    primary.removeExport(LOAD_SECONDARY_MODULE);
  } else {
    // Add an imported function to load the secondary module.
    auto import = Builder::makeFunction(ModuleSplitting::LOAD_SECONDARY_MODULE,
                                        Signature(Type::none, Type::none),
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

std::pair<std::set<Name>, std::set<Name>>
ModuleSplitter::classifyFunctions(Module& primary, const Config& config) {
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

  std::set<Name> primaryFuncs, secondaryFuncs;
  for (auto& func : primary.functions) {
    // In JSPI mode exported functions cannot be moved to the secondary
    // module since that would make them async when they may not have the JSPI
    // wrapper. Exported JSPI functions can still benefit from splitting though
    // since only the JSPI wrapper stub will remain in the primary module.
    if (func->imported() || config.primaryFuncs.count(func->name) ||
        (config.jspi && ExportUtils::isExported(primary, *func)) ||
        segmentReferrers.count(func->name)) {
      primaryFuncs.insert(func->name);
    } else {
      assert(func->name != primary.start && "The start function must be kept");
      secondaryFuncs.insert(func->name);
    }
  }
  return std::make_pair(std::move(primaryFuncs), std::move(secondaryFuncs));
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
  if (secondary.getFunctionOrNull(funcName) == nullptr) {
    auto primaryFunc = primary.getFunction(funcName);
    auto func = Builder::makeFunction(funcName, primaryFunc->type, {});
    func->hasExplicitName = primaryFunc->hasExplicitName;
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
    auto* func = primary.addFunction(Builder::makeFunction(
      secondaryFunc, secondary.getFunction(secondaryFunc)->type, {}));
    std::vector<Expression*> args;
    Type params = func->getParams();
    for (size_t i = 0, size = params.size(); i < size; ++i) {
      args.push_back(builder.makeLocalGet(i, params[i]));
    }
    auto tableSlot = tableManager.getSlot(secondaryFunc, func->type);
    func->body = builder.makeCallIndirect(
      tableSlot.tableName, tableSlot.makeExpr(primary), args, func->type);
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
      if (parent.secondaryFuncs.count(curr->func)) {
        map[curr->func].push_back(curr);
      }
    }
  } gatherer(*this);
  gatherer.walkModule(&primary);

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

    auto* oldFunc = secondary.getFunction(name);
    auto newName = Names::getValidFunctionName(
      primary, std::string("trampoline_") + name.toString());

    // Generate the call and the function.
    std::vector<Expression*> args;
    for (Index i = 0; i < oldFunc->getNumParams(); i++) {
      args.push_back(builder.makeLocalGet(i, oldFunc->getLocalType(i)));
    }
    auto* call = builder.makeCall(name, args, oldFunc->getResults());

    primary.addFunction(builder.makeFunction(newName, oldFunc->type, {}, call));

    // Update RefFuncs to refer to it.
    for (auto* refFunc : relevantRefFuncs) {
      refFunc->func = newName;
    }
  }
}

void ModuleSplitter::indirectCallsToSecondaryFunctions() {
  // Update direct calls of secondary functions to be indirect calls of their
  // corresponding table indices instead.
  struct CallIndirector : public PostWalker<CallIndirector> {
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
      auto* func = parent.secondary.getFunction(curr->target);
      auto tableSlot = parent.tableManager.getSlot(curr->target, func->type);

      replaceCurrent(parent.maybeLoadSecondary(
        builder,
        builder.makeCallIndirect(tableSlot.tableName,
                                 tableSlot.makeExpr(parent.primary),
                                 curr->operands,
                                 func->type,
                                 curr->isReturn)));
    }
  };
  CallIndirector(*this).walkModule(&primary);
}

void ModuleSplitter::exportImportCalledPrimaryFunctions() {
  // Find primary functions called/referred in the secondary module.
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
          if (primaryFuncs.count(curr->func)) {
            calledPrimaryFuncs.push_back(curr->func);
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
      placeholderMap[index] = elem;
      auto* secondaryFunc = secondary.getFunction(elem);
      replacedElems[index] = secondaryFunc;
      auto placeholder = std::make_unique<Function>();
      placeholder->module = config.placeholderNamespace;
      placeholder->base = std::to_string(index);
      placeholder->name = Names::getValidFunctionName(
        primary, std::string("placeholder_") + placeholder->base.toString());
      placeholder->hasExplicitName = true;
      placeholder->type = secondaryFunc->type;
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
        auto* func = replacement->second;
        auto* ref = Builder(secondary).makeRefFunc(func->name, func->type);
        secondaryElems.push_back(ref);
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
    Name name = Names::getValidElementSegmentName(
      secondary, Name::fromInt(secondary.elementSegments.size()));
    secondarySeg->setName(name, false);
    secondary.addElementSegment(std::move(secondarySeg));
  };
  for (auto curr = replacedElems.begin(); curr != replacedElems.end(); ++curr) {
    if (curr->first != currBase + currData.size()) {
      finishSegment();
      currBase = curr->first;
      currData.clear();
    }
    auto* func = curr->second;
    currData.push_back(Builder(secondary).makeRefFunc(func->name, func->type));
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

  for (auto& memory : primary.memories) {
    auto secondaryMemory = ModuleUtils::copyMemory(memory.get(), secondary);
    makeImportExport(*memory, *secondaryMemory, "memory", ExternalKind::Memory);
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

  for (auto& tag : primary.tags) {
    auto secondaryTag = std::make_unique<Tag>();
    secondaryTag->sig = tag->sig;
    makeImportExport(*tag, *secondaryTag, "tag", ExternalKind::Tag);
    secondary.addTag(std::move(secondaryTag));
  }
}

} // anonymous namespace

Results splitFunctions(Module& primary, const Config& config) {
  ModuleSplitter split(primary, config);
  return {std::move(split.secondaryPtr), std::move(split.placeholderMap)};
}

} // namespace wasm::ModuleSplitting
