/*
 * Copyright 2022 WebAssembly Community Group participants
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

#include "module-utils.h"
#include "ir/debug.h"
#include "ir/intrinsics.h"
#include "ir/manipulation.h"
#include "ir/properties.h"
#include "support/insert_ordered.h"
#include "support/topological_sort.h"

namespace wasm::ModuleUtils {

// Update the file name indices when moving a set of debug locations from one
// module to another.
static void updateLocationSet(std::set<Function::DebugLocation>& locations,
                              std::vector<Index>& fileIndexMap) {
  std::set<Function::DebugLocation> updatedLocations;

  for (auto iter : locations) {
    iter.fileIndex = fileIndexMap[iter.fileIndex];
    updatedLocations.insert(iter);
  }
  locations.clear();
  std::swap(locations, updatedLocations);
}

// Copies a function into a module. If newName is provided it is used as the
// name of the function (otherwise the original name is copied). If fileIndexMap
// is specified, it is used to rename source map filename indices when copying
// the function from one module to another one.
Function* copyFunction(Function* func,
                       Module& out,
                       Name newName,
                       std::optional<std::vector<Index>> fileIndexMap) {
  auto ret = std::make_unique<Function>();
  ret->name = newName.is() ? newName : func->name;
  ret->hasExplicitName = func->hasExplicitName;
  ret->type = func->type;
  ret->vars = func->vars;
  ret->localNames = func->localNames;
  ret->localIndices = func->localIndices;
  ret->body = ExpressionManipulator::copy(func->body, out);
  debug::copyDebugInfo(func->body, ret->body, func, ret.get());
  ret->prologLocation = func->prologLocation;
  ret->epilogLocation = func->epilogLocation;
  // Update file indices if needed
  if (fileIndexMap) {
    for (auto& iter : ret->debugLocations) {
      iter.second.fileIndex = (*fileIndexMap)[iter.second.fileIndex];
    }
    updateLocationSet(ret->prologLocation, *fileIndexMap);
    updateLocationSet(ret->epilogLocation, *fileIndexMap);
  }
  ret->module = func->module;
  ret->base = func->base;
  ret->noFullInline = func->noFullInline;
  ret->noPartialInline = func->noPartialInline;

  // TODO: copy Stack IR
  assert(!func->stackIR);
  return out.addFunction(std::move(ret));
}

Global* copyGlobal(Global* global, Module& out) {
  auto* ret = new Global();
  ret->name = global->name;
  ret->hasExplicitName = global->hasExplicitName;
  ret->type = global->type;
  ret->mutable_ = global->mutable_;
  ret->module = global->module;
  ret->base = global->base;
  if (global->imported()) {
    ret->init = nullptr;
  } else {
    ret->init = ExpressionManipulator::copy(global->init, out);
  }
  out.addGlobal(ret);
  return ret;
}

Tag* copyTag(Tag* tag, Module& out) {
  auto* ret = new Tag();
  ret->name = tag->name;
  ret->hasExplicitName = tag->hasExplicitName;
  ret->sig = tag->sig;
  ret->module = tag->module;
  ret->base = tag->base;
  out.addTag(ret);
  return ret;
}

ElementSegment* copyElementSegment(const ElementSegment* segment, Module& out) {
  auto copy = [&](std::unique_ptr<ElementSegment>&& ret) {
    ret->name = segment->name;
    ret->hasExplicitName = segment->hasExplicitName;
    ret->type = segment->type;
    ret->data.reserve(segment->data.size());
    for (auto* item : segment->data) {
      ret->data.push_back(ExpressionManipulator::copy(item, out));
    }

    return out.addElementSegment(std::move(ret));
  };

  if (segment->table.isNull()) {
    return copy(std::make_unique<ElementSegment>());
  } else {
    auto offset = ExpressionManipulator::copy(segment->offset, out);
    return copy(std::make_unique<ElementSegment>(segment->table, offset));
  }
}

Table* copyTable(const Table* table, Module& out) {
  auto ret = std::make_unique<Table>();
  ret->name = table->name;
  ret->hasExplicitName = table->hasExplicitName;
  ret->type = table->type;
  ret->module = table->module;
  ret->base = table->base;

  ret->initial = table->initial;
  ret->max = table->max;

  return out.addTable(std::move(ret));
}

Memory* copyMemory(const Memory* memory, Module& out) {
  auto ret = Builder::makeMemory(memory->name);
  ret->hasExplicitName = memory->hasExplicitName;
  ret->initial = memory->initial;
  ret->max = memory->max;
  ret->shared = memory->shared;
  ret->indexType = memory->indexType;
  ret->module = memory->module;
  ret->base = memory->base;

  return out.addMemory(std::move(ret));
}

DataSegment* copyDataSegment(const DataSegment* segment, Module& out) {
  auto ret = Builder::makeDataSegment();
  ret->name = segment->name;
  ret->hasExplicitName = segment->hasExplicitName;
  ret->memory = segment->memory;
  ret->isPassive = segment->isPassive;
  if (!segment->isPassive) {
    auto offset = ExpressionManipulator::copy(segment->offset, out);
    ret->offset = offset;
  }
  ret->data = segment->data;

  return out.addDataSegment(std::move(ret));
}

// Copies named toplevel module items (things of kind ModuleItemKind). See
// copyModule() for something that also copies exports, the start function, etc.
void copyModuleItems(const Module& in, Module& out) {
  // If the source module has some debug information, we first compute how
  // to map file name indices from this modules to file name indices in
  // the target module.
  std::optional<std::vector<Index>> fileIndexMap;
  if (!in.debugInfoFileNames.empty()) {
    std::unordered_map<std::string, Index> debugInfoFileIndices;
    for (Index i = 0; i < out.debugInfoFileNames.size(); i++) {
      debugInfoFileIndices[out.debugInfoFileNames[i]] = i;
    }
    fileIndexMap.emplace();
    for (Index i = 0; i < in.debugInfoFileNames.size(); i++) {
      std::string file = in.debugInfoFileNames[i];
      auto iter = debugInfoFileIndices.find(file);
      if (iter == debugInfoFileIndices.end()) {
        Index index = out.debugInfoFileNames.size();
        out.debugInfoFileNames.push_back(file);
        debugInfoFileIndices[file] = index;
      }
      fileIndexMap->push_back(debugInfoFileIndices[file]);
    }
  }

  for (auto& curr : in.functions) {
    copyFunction(curr.get(), out, Name(), fileIndexMap);
  }
  for (auto& curr : in.globals) {
    copyGlobal(curr.get(), out);
  }
  for (auto& curr : in.tags) {
    copyTag(curr.get(), out);
  }
  for (auto& curr : in.elementSegments) {
    copyElementSegment(curr.get(), out);
  }
  for (auto& curr : in.tables) {
    copyTable(curr.get(), out);
  }
  for (auto& curr : in.memories) {
    copyMemory(curr.get(), out);
  }
  for (auto& curr : in.dataSegments) {
    copyDataSegment(curr.get(), out);
  }

  for (auto& [type, names] : in.typeNames) {
    if (!out.typeNames.count(type)) {
      out.typeNames[type] = names;
    }
  }
}

// TODO: merge this with copyModuleItems, and add options for copying
// exports and other things that are currently different between them,
// if we still need those differences.
void copyModule(const Module& in, Module& out) {
  // we use names throughout, not raw pointers, so simple copying is fine
  // for everything *but* expressions
  for (auto& curr : in.exports) {
    out.addExport(std::make_unique<Export>(*curr));
  }
  copyModuleItems(in, out);
  out.start = in.start;
  out.customSections = in.customSections;
  out.debugInfoFileNames = in.debugInfoFileNames;
  out.features = in.features;
}

void clearModule(Module& wasm) {
  wasm.~Module();
  new (&wasm) Module;
}

// Renaming

// Rename functions along with all their uses.
// Note that for this to work the functions themselves don't necessarily need
// to exist.  For example, it is possible to remove a given function and then
// call this to redirect all of its uses.
template<typename T> void renameFunctions(Module& wasm, T& map) {
  // Update the function itself.
  for (auto& [oldName, newName] : map) {
    if (Function* func = wasm.getFunctionOrNull(oldName)) {
      assert(!wasm.getFunctionOrNull(newName) || func->name == newName);
      func->name = newName;
    }
  }
  wasm.updateMaps();

  // Update all references to it.
  struct Updater : public WalkerPass<PostWalker<Updater>> {
    bool isFunctionParallel() override { return true; }

    T& map;

    void maybeUpdate(Name& name) {
      if (auto iter = map.find(name); iter != map.end()) {
        name = iter->second;
      }
    }

    Updater(T& map) : map(map) {}

    std::unique_ptr<Pass> create() override {
      return std::make_unique<Updater>(map);
    }

    void visitCall(Call* curr) { maybeUpdate(curr->target); }

    void visitRefFunc(RefFunc* curr) { maybeUpdate(curr->func); }
  };

  Updater updater(map);
  updater.maybeUpdate(wasm.start);
  PassRunner runner(&wasm);
  updater.run(&runner, &wasm);
  updater.runOnModuleCode(&runner, &wasm);
}

void renameFunction(Module& wasm, Name oldName, Name newName) {
  std::map<Name, Name> map;
  map[oldName] = newName;
  renameFunctions(wasm, map);
}

namespace {

// Helper for collecting HeapTypes and their frequencies.
struct Counts {
  InsertOrderedMap<HeapType, size_t> counts;

  // Multivalue control flow structures need a function type, but the identity
  // of the function type (i.e. what recursion group it is in or whether it is
  // final) doesn't matter. Save them for the end to see if we can re-use an
  // existing function type with the necessary signature.
  InsertOrderedMap<Signature, size_t> controlFlowSignatures;

  void note(HeapType type) {
    if (!type.isBasic()) {
      counts[type]++;
    }
  }
  void note(Type type) {
    for (HeapType ht : type.getHeapTypeChildren()) {
      note(ht);
    }
  }
  // Ensure a type is included without increasing its count.
  void include(HeapType type) {
    if (!type.isBasic()) {
      counts[type];
    }
  }
  void include(Type type) {
    for (HeapType ht : type.getHeapTypeChildren()) {
      include(ht);
    }
  }
  void noteControlFlow(Signature sig) {
    // TODO: support control flow input parameters.
    assert(sig.params.size() == 0);
    if (sig.results.isTuple()) {
      // We have to use a function type.
      controlFlowSignatures[sig]++;
    } else if (sig.results != Type::none) {
      // The result type can be emitted directly instead of using a function
      // type.
      note(sig.results[0]);
    }
  }
};

struct CodeScanner
  : PostWalker<CodeScanner, UnifiedExpressionVisitor<CodeScanner>> {
  Counts& counts;

  CodeScanner(Module& wasm, Counts& counts) : counts(counts) {
    setModule(&wasm);
  }

  void visitExpression(Expression* curr) {
    if (auto* call = curr->dynCast<CallIndirect>()) {
      counts.note(call->heapType);
    } else if (auto* call = curr->dynCast<CallRef>()) {
      counts.note(call->target->type);
    } else if (curr->is<RefNull>()) {
      counts.note(curr->type);
    } else if (curr->is<Select>() && curr->type.isRef()) {
      // This select will be annotated in the binary, so note it.
      counts.note(curr->type);
    } else if (curr->is<StructNew>()) {
      counts.note(curr->type);
    } else if (curr->is<ArrayNew>()) {
      counts.note(curr->type);
    } else if (curr->is<ArrayNewData>()) {
      counts.note(curr->type);
    } else if (curr->is<ArrayNewElem>()) {
      counts.note(curr->type);
    } else if (curr->is<ArrayNewFixed>()) {
      counts.note(curr->type);
    } else if (auto* copy = curr->dynCast<ArrayCopy>()) {
      counts.note(copy->destRef->type);
      counts.note(copy->srcRef->type);
    } else if (auto* fill = curr->dynCast<ArrayFill>()) {
      counts.note(fill->ref->type);
    } else if (auto* init = curr->dynCast<ArrayInitData>()) {
      counts.note(init->ref->type);
    } else if (auto* init = curr->dynCast<ArrayInitElem>()) {
      counts.note(init->ref->type);
    } else if (auto* cast = curr->dynCast<RefCast>()) {
      counts.note(cast->type);
    } else if (auto* cast = curr->dynCast<RefTest>()) {
      counts.note(cast->castType);
    } else if (auto* cast = curr->dynCast<BrOn>()) {
      if (cast->op == BrOnCast || cast->op == BrOnCastFail) {
        counts.note(cast->ref->type);
        counts.note(cast->castType);
      }
    } else if (auto* get = curr->dynCast<StructGet>()) {
      counts.note(get->ref->type);
      // If the type we read is a reference type then we must include it. It is
      // not written in the binary format, so it doesn't need to be counted, but
      // it does need to be taken into account in the IR (this may be the only
      // place this type appears in the entire binary, and we must scan all
      // types as the analyses that use us depend on that). TODO: This is kind
      // of a hack, so it would be nice to remove. If we could remove it, we
      // could also remove some of the pruning logic in getHeapTypeCounts below.
      counts.include(get->type);
    } else if (auto* set = curr->dynCast<StructSet>()) {
      counts.note(set->ref->type);
    } else if (auto* get = curr->dynCast<ArrayGet>()) {
      counts.note(get->ref->type);
      // See note on StructGet above.
      counts.include(get->type);
    } else if (auto* set = curr->dynCast<ArraySet>()) {
      counts.note(set->ref->type);
    } else if (auto* contBind = curr->dynCast<ContBind>()) {
      counts.note(contBind->contTypeBefore);
      counts.note(contBind->contTypeAfter);
    } else if (auto* contNew = curr->dynCast<ContNew>()) {
      counts.note(contNew->contType);
    } else if (auto* resume = curr->dynCast<Resume>()) {
      counts.note(resume->contType);
    } else if (Properties::isControlFlowStructure(curr)) {
      counts.noteControlFlow(Signature(Type::none, curr->type));
    }
  }
};

// Count the number of times each heap type that would appear in the binary is
// referenced. If `prune`, exclude types that are never referenced, even though
// a binary would be invalid without them.
InsertOrderedMap<HeapType, size_t> getHeapTypeCounts(Module& wasm,
                                                     bool prune = false) {
  // Collect module-level info.
  Counts counts;
  CodeScanner(wasm, counts).walkModuleCode(&wasm);
  for (auto& curr : wasm.globals) {
    counts.note(curr->type);
  }
  for (auto& curr : wasm.tags) {
    counts.note(curr->sig);
  }
  for (auto& curr : wasm.tables) {
    counts.note(curr->type);
  }
  for (auto& curr : wasm.elementSegments) {
    counts.note(curr->type);
  }

  // Collect info from functions in parallel.
  ModuleUtils::ParallelFunctionAnalysis<Counts, Immutable, InsertOrderedMap>
    analysis(wasm, [&](Function* func, Counts& counts) {
      counts.note(func->type);
      for (auto type : func->vars) {
        counts.note(type);
      }
      if (!func->imported()) {
        CodeScanner(wasm, counts).walk(func->body);
      }
    });

  // Combine the function info with the module info.
  for (auto& [_, functionCounts] : analysis.map) {
    for (auto& [type, count] : functionCounts.counts) {
      counts.counts[type] += count;
    }
    for (auto& [sig, count] : functionCounts.controlFlowSignatures) {
      counts.controlFlowSignatures[sig] += count;
    }
  }

  if (prune) {
    // Remove types that are not actually used.
    auto it = counts.counts.begin();
    while (it != counts.counts.end()) {
      if (it->second == 0) {
        auto deleted = it++;
        counts.counts.erase(deleted);
      } else {
        ++it;
      }
    }
  }

  // Recursively traverse each reference type, which may have a child type that
  // is itself a reference type. This reflects an appearance in the binary
  // format that is in the type section itself. As we do this we may find more
  // and more types, as nested children of previous ones. Each such type will
  // appear in the type section once, so we just need to visit it once. Also
  // track which recursion groups we've already processed to avoid quadratic
  // behavior when there is a single large group.
  UniqueNonrepeatingDeferredQueue<HeapType> newTypes;
  std::unordered_map<Signature, HeapType> seenSigs;
  auto noteNewType = [&](HeapType type) {
    newTypes.push(type);
    if (type.isSignature()) {
      seenSigs.insert({type.getSignature(), type});
    }
  };
  for (auto& [type, _] : counts.counts) {
    noteNewType(type);
  }
  auto controlFlowIt = counts.controlFlowSignatures.begin();
  std::unordered_set<RecGroup> includedGroups;
  while (!newTypes.empty()) {
    while (!newTypes.empty()) {
      auto ht = newTypes.pop();
      for (HeapType child : ht.getHeapTypeChildren()) {
        if (!child.isBasic()) {
          if (!counts.counts.count(child)) {
            noteNewType(child);
          }
          counts.note(child);
        }
      }

      if (auto super = ht.getDeclaredSuperType()) {
        if (!counts.counts.count(*super)) {
          noteNewType(*super);
          // We should unconditionally count supertypes, but while the type
          // system is in flux, skip counting them to keep the type orderings in
          // nominal test outputs more similar to the orderings in the
          // equirecursive outputs. FIXME
          counts.include(*super);
        }
      }

      // Make sure we've noted the complete recursion group of each type as
      // well.
      if (!prune) {
        auto recGroup = ht.getRecGroup();
        if (includedGroups.insert(recGroup).second) {
          for (auto type : recGroup) {
            if (!counts.counts.count(type)) {
              noteNewType(type);
              counts.include(type);
            }
          }
        }
      }
    }

    // We've found all the types there are to find without considering more
    // control flow types. Consider one more control flow type and repeat.
    for (; controlFlowIt != counts.controlFlowSignatures.end();
         ++controlFlowIt) {
      auto& [sig, count] = *controlFlowIt;
      if (auto it = seenSigs.find(sig); it != seenSigs.end()) {
        counts.counts[it->second] += count;
      } else {
        // We've never seen this signature before, so add a type for it.
        HeapType type(sig);
        noteNewType(type);
        counts.counts[type] += count;
        break;
      }
    }
  }

  return counts.counts;
}

void setIndices(IndexedHeapTypes& indexedTypes) {
  for (Index i = 0; i < indexedTypes.types.size(); i++) {
    indexedTypes.indices[indexedTypes.types[i]] = i;
  }
}

InsertOrderedSet<HeapType> getPublicTypeSet(Module& wasm) {
  InsertOrderedSet<HeapType> publicTypes;

  auto notePublic = [&](HeapType type) {
    if (type.isBasic()) {
      return;
    }
    // All the rec group members are public as well.
    for (auto member : type.getRecGroup()) {
      if (!publicTypes.insert(member)) {
        // We've already inserted this rec group.
        break;
      }
    }
  };

  // TODO: Consider Tags as well, but they should store HeapTypes instead of
  // Signatures first.
  ModuleUtils::iterImportedTables(wasm, [&](Table* table) {
    assert(table->type.isRef());
    notePublic(table->type.getHeapType());
  });
  ModuleUtils::iterImportedGlobals(wasm, [&](Global* global) {
    if (global->type.isRef()) {
      notePublic(global->type.getHeapType());
    }
  });
  ModuleUtils::iterImportedFunctions(wasm, [&](Function* func) {
    // We can ignore call.without.effects, which is implemented as an import but
    // functionally is a call within the module.
    if (!Intrinsics(wasm).isCallWithoutEffects(func)) {
      notePublic(func->type);
    }
  });
  for (auto& ex : wasm.exports) {
    switch (ex->kind) {
      case ExternalKind::Function: {
        auto* func = wasm.getFunction(ex->value);
        notePublic(func->type);
        continue;
      }
      case ExternalKind::Table: {
        auto* table = wasm.getTable(ex->value);
        assert(table->type.isRef());
        notePublic(table->type.getHeapType());
        continue;
      }
      case ExternalKind::Memory:
        // Never a reference type.
        continue;
      case ExternalKind::Global: {
        auto* global = wasm.getGlobal(ex->value);
        if (global->type.isRef()) {
          notePublic(global->type.getHeapType());
        }
        continue;
      }
      case ExternalKind::Tag:
        // TODO
        continue;
      case ExternalKind::Invalid:
        break;
    }
    WASM_UNREACHABLE("unexpected export kind");
  }

  // Ignorable public types are public.
  for (auto type : getIgnorablePublicTypes()) {
    notePublic(type);
  }

  // Find all the other public types reachable from directly publicized types.
  std::vector<HeapType> workList(publicTypes.begin(), publicTypes.end());
  while (workList.size()) {
    auto curr = workList.back();
    workList.pop_back();
    for (auto t : curr.getReferencedHeapTypes()) {
      if (!t.isBasic() && publicTypes.insert(t)) {
        workList.push_back(t);
      }
    }
  }

  return publicTypes;
}

} // anonymous namespace

std::vector<HeapType> collectHeapTypes(Module& wasm) {
  auto counts = getHeapTypeCounts(wasm);
  std::vector<HeapType> types;
  types.reserve(counts.size());
  for (auto& [type, _] : counts) {
    types.push_back(type);
  }
  return types;
}

std::vector<HeapType> getPublicHeapTypes(Module& wasm) {
  auto publicTypes = getPublicTypeSet(wasm);
  std::vector<HeapType> types;
  types.reserve(publicTypes.size());
  for (auto type : publicTypes) {
    types.push_back(type);
  }
  return types;
}

std::vector<HeapType> getPrivateHeapTypes(Module& wasm) {
  auto usedTypes = getHeapTypeCounts(wasm, true);
  auto publicTypes = getPublicTypeSet(wasm);
  std::vector<HeapType> types;
  for (auto& [type, _] : usedTypes) {
    if (!publicTypes.count(type)) {
      types.push_back(type);
    }
  }
  return types;
}

IndexedHeapTypes getOptimizedIndexedHeapTypes(Module& wasm) {
  auto counts = getHeapTypeCounts(wasm);

  // Types have to be arranged into topologically ordered recursion groups.
  // Under isorecrsive typing, the topological sort has to take all referenced
  // rec groups into account. First, sort the groups by average use count among
  // their members so that the later topological sort will place frequently used
  // types first.
  struct GroupInfo {
    size_t index;
    double useCount = 0;
    std::unordered_set<RecGroup> preds;
    std::vector<RecGroup> sortedPreds;
    GroupInfo(size_t index) : index(index) {}
    bool operator<(const GroupInfo& other) const {
      if (useCount != other.useCount) {
        return useCount < other.useCount;
      }
      return index > other.index;
    }
  };

  struct GroupInfoMap : std::unordered_map<RecGroup, GroupInfo> {
    void sort(std::vector<RecGroup>& groups) {
      std::sort(groups.begin(), groups.end(), [&](auto& a, auto& b) {
        return this->at(a) < this->at(b);
      });
    }
  };

  // Collect the information that will be used to sort the recursion groups.
  GroupInfoMap groupInfos;
  for (auto& [type, _] : counts) {
    RecGroup group = type.getRecGroup();
    // Try to initialize a new info or get the existing info.
    auto& info = groupInfos.insert({group, {groupInfos.size()}}).first->second;
    // Update the reference count.
    info.useCount += counts.at(type);
    // Collect predecessor groups.
    for (auto child : type.getReferencedHeapTypes()) {
      if (!child.isBasic()) {
        RecGroup otherGroup = child.getRecGroup();
        if (otherGroup != group) {
          info.preds.insert(otherGroup);
        }
      }
    }
  }

  // Fix up the use counts to be averages to ensure groups are used comensurate
  // with the amount of index space they occupy. Skip this for nominal types
  // since their internal group size is always 1.
  for (auto& [group, info] : groupInfos) {
    info.useCount /= group.size();
  }

  // Sort the predecessors so the most used will be visited first.
  for (auto& [group, info] : groupInfos) {
    info.sortedPreds.insert(
      info.sortedPreds.end(), info.preds.begin(), info.preds.end());
    groupInfos.sort(info.sortedPreds);
    info.preds.clear();
  }

  struct RecGroupSort : TopologicalSort<RecGroup, RecGroupSort> {
    GroupInfoMap& groupInfos;
    RecGroupSort(GroupInfoMap& groupInfos) : groupInfos(groupInfos) {
      // Sort all the groups so the topological sort visits the most used first.
      std::vector<RecGroup> sortedGroups;
      sortedGroups.reserve(groupInfos.size());
      for (auto& [group, _] : groupInfos) {
        sortedGroups.push_back(group);
      }
      groupInfos.sort(sortedGroups);
      for (auto group : sortedGroups) {
        push(group);
      }
    }

    void pushPredecessors(RecGroup group) {
      for (auto pred : groupInfos.at(group).sortedPreds) {
        push(pred);
      }
    }
  };

  // Perform the topological sort and collect the types.
  IndexedHeapTypes indexedTypes;
  indexedTypes.types.reserve(counts.size());
  for (auto group : RecGroupSort(groupInfos)) {
    for (auto member : group) {
      indexedTypes.types.push_back(member);
    }
  }
  setIndices(indexedTypes);
  return indexedTypes;
}

} // namespace wasm::ModuleUtils
