/*
 * Copyright 2024 WebAssembly Community Group participants
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

// This is a J2CL specific pass that merges itables into vtables. It is meant
// to be run at the beginning before structs corresponding to Java classes are
// optimized.
//
// Embeds itables into vtables to reduce memory usage.
//
// 1. Collect all structs that have both vtable and itable fields.
//   - sanity check that the transformation can be done.
// 2. For each struct that has a vtable and an itable field:
//   - prepend all the fields in the itable into the vtable
//   - modify the initialization of the vtable instances to include
//     the itable initialization.
//   - rewrite all accesses to vtable fields to account for the offsets due
//     to the itable fields.
// 3. Replace the itable types with the corresponding vtable type in all
// the code.
// 4. Rewrite all struct.get of itable fields to use vtable fields instead.
//
// The removal of unused itable fields is expected to be done by running gto.
//

#include <unordered_map>
#include <unordered_set>

#include "ir/effects.h"
#include "ir/localize.h"
#include "ir/ordering.h"
#include "ir/struct-utils.h"
#include "ir/subtypes.h"
#include "ir/type-updating.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm-type.h"
#include "wasm.h"

namespace wasm {

namespace {

// Information about the structs that have vtables and itables.
struct StructInfo {
  HeapType javaClass;
  HeapType itable;
  HeapType vtable;

  StructInfo(const HeapType& javaClass, const HeapType& vtable,
             const HeapType& itable)
      : javaClass(javaClass), itable(itable), vtable(vtable) {}

  void print(std::unordered_map<HeapType, TypeNames> typeNames) {
    std::cout << "javaClass: " << typeNames[javaClass].name << " ("
              << javaClass.getID() << ")" << std::endl;
    std::cout << "vtable: " << typeNames[vtable].name << " (" << vtable.getID()
              << ")" << std::endl;
    std::cout << "itable: " << typeNames[itable].name << " (" << itable.getID()
              << ")" << std::endl;
  }
};

struct J2CLItableMerging : public Pass {
  // Keep track of all the structInfos so that they will be automatically
  // released after the pass is done.
  std::list<StructInfo> structInfos;

  // Globals that hold vtables and itables indexed by their heap type.
  // There is exactly 1 global for each vtable/itable type.
  std::unordered_map<HeapType, std::unique_ptr<Global>*> tableGlobalsByType;
  std::unordered_map<HeapType, StructInfo*> structInfoByVtableType;
  std::unordered_map<HeapType, StructInfo*> structInfoByITableType;

  void run(Module* module) override {
    if (!module->features.hasGC()) {
      return;
    }

    if (!getPassOptions().closedWorld) {
      Fatal() << "j2cl-optimize-memory requires --closed-world";
    }

    collectVtableAndItableTypes(*module);
    updateVtableFieldsAccesses(*module);
    rerouteItableAccess(*module);
    updateTypes(*module);

    // Since now vtables are initialized with `global.get` of the interface
    // vtable instances, we need to reorder the globals.
    PassRunner runner(module);
    runner.add("reorder-globals-always");
    runner.setIsNested(true);
    runner.run();
  }

  // Collects all structs corresponding to Java classes, their vtables and
  // their itables. This is very tied to the way j2cl emits these constructs.
  void collectVtableAndItableTypes(Module& wasm) {
    const auto emptyItableSize = std::numeric_limits<Index>::max();
    // 1. Collect all structs that correspond that a Java type.
    unsigned long itableSize = emptyItableSize;
    for (auto tn : wasm.typeNames) {
      if (!tn.first.isStruct()) {
        continue;
      }

      auto type = tn.first.getStruct();
      if (tn.second.fieldNames.empty() ||
          !tn.second.fieldNames[0].equals("vtable")) {
        continue;
      }
      if (tn.second.fieldNames.size() < 1 ||
          !tn.second.fieldNames[1].equals("itable")) {
        continue;
      }

      auto vtabletype = wasm.typeNames.find(type.fields[0].type.getHeapType());
      auto itabletype = wasm.typeNames.find(type.fields[1].type.getHeapType());

      auto currentItableSize = itabletype->first.getStruct().fields.size();
      if (itableSize == emptyItableSize) {
        itableSize = currentItableSize;
      }

      if (itableSize != currentItableSize) {
        Fatal() << "j2cl-optimize-memory needs to be the first pass to run "
                << "on j2cl output. (found itables with different sizes)";
      }

      structInfos.push_back(
          StructInfo(tn.first, vtabletype->first, itabletype->first));
      structInfoByVtableType[vtabletype->first] = &structInfos.back();
      structInfoByITableType[itabletype->first] = &structInfos.back();
    }

    // 2. Collect the globals for vtables and itables.
    for (auto& g : wasm.globals) {
      if (!g->type.isStruct()) {
        continue;
      }
      if (structInfoByVtableType.find(g->type.getHeapType()) !=
          structInfoByVtableType.end()) {
        tableGlobalsByType[g->type.getHeapType()] = &g;
      } else if (structInfoByITableType.find(g->type.getHeapType()) !=
                 structInfoByITableType.end()) {
        tableGlobalsByType[g->type.getHeapType()] = &g;
      }
    }

    if (itableSize == emptyItableSize) {
      Fatal() << "j2cl-optimize-memory needs to be the first pass to run "
              << "on j2cl output. (no Java classes found)";
    }
  }

  // Fix the indexes of `struct.get` for vtable fields, and prepend the
  // initializers for the itable fields to `struct.new`.
  // Note that there isn't any `struct.set` because the vtable fields are
  // immutable.
  void updateVtableFieldsAccesses(Module& wasm) {
    struct Reindexer : public WalkerPass<PostWalker<Reindexer>> {
      bool isFunctionParallel() override { return true; }

      J2CLItableMerging& parent;

      Reindexer(J2CLItableMerging& parent) : parent(parent) {}

      std::unique_ptr<Pass> create() override {
        return std::make_unique<Reindexer>(parent);
      }

      void visitStructGet(StructGet* curr) {
        if (curr->ref->type == Type::unreachable) {
          return;
        }

        auto it =
            parent.structInfoByVtableType.find(curr->ref->type.getHeapType());
        if (it == parent.structInfoByVtableType.end()) {
          return;
        }
        // It is ok to just change the index since the field has moved but
        // the type is the same.
        curr->index += it->second->itable.getStruct().fields.size();
      }

      void visitStructNew(StructNew* curr) {
        if (curr->type == Type::unreachable) {
          return;
        }

        auto it = parent.structInfoByVtableType.find(curr->type.getHeapType());

        if (it == parent.structInfoByVtableType.end()) {
          return;
        }
        // The struct.new is for a vtable type and structInfo has the
        // information relating the struct types for the Java class, is vtable
        // and its itable.
        auto structInfo = it->second;

        // Get the global that holds the corresponding itable instance.
        auto* itableGlobal = parent.tableGlobalsByType[structInfo->itable];
        StructNew* itableStructNew = nullptr;

        if (itableGlobal && (*itableGlobal)->init) {
          if ((*itableGlobal)->init->is<GlobalGet>()) {
            // The global might get initialized with the shared empty itable,
            // obtain the itable struct.new from the global.init.
            auto* globalGet = (*itableGlobal)->init->dynCast<GlobalGet>();
            auto* global = getModule()->getGlobal(globalGet->name);
            itableStructNew = global->init->dynCast<StructNew>();
          } else {
            // The global is initialized with a struct.new of the itable.
            itableStructNew = (*itableGlobal)->init->dynCast<StructNew>();
          }
        }

        if (!itableStructNew) {
          Fatal() << "j2cl-optimize-memory needs to be the first pass to run "
                  << "on j2cl output. (itable initializer not found)";
        }
        auto& itableFieldInitializers = itableStructNew->operands;
        auto itableSize =
            itableStructNew->type.getHeapType().getStruct().fields.size();

        if (itableSize == 0) {
          // Itables are empty. Nothing to do.
          return;
        }

        // Compute the new size of the vtable.
        Index newSize = curr->operands.size() + itableSize;
        // and resize the struct.new operands to accommodate the itable
        // fields.
        curr->operands.resize(newSize);

        // Move initialization for the existing vtable fields to their
        // new position.
        for (Index i = newSize - 1; i >= itableSize; i--) {
          curr->operands[i] = curr->operands[i - itableSize];
        }

        // Add the initialization for the itable fields.
        for (Index i = 0; i < itableSize; i++) {
          if (itableFieldInitializers.size() > i) {
            // The itable was initialized with a struct.new, copy the
            // initialization values.
            curr->operands[i] = ExpressionManipulator::copy(
                itableFieldInitializers[i], *getModule());
          } else {
            // The itable was initialized with struct.new_default. So use
            // null values to initialize the itable fields.
            Builder builder(*getModule());
            curr->operands[i] =
                builder.makeRefNull(itableStructNew->type.getHeapType()
                                        .getStruct()
                                        .fields[i]
                                        .type.getHeapType());
          }
        }
      }
    };

    Reindexer reindexer(*this);
    reindexer.run(getPassRunner(), &wasm);
    reindexer.runOnModuleCode(getPassRunner(), &wasm);
  }

  // Redirects all itable access by changing `struct.get` of the `itable` field
  // to `struct.get` on the to `vtable` field.
  void rerouteItableAccess(Module& wasm) {
    struct Rerouter : public WalkerPass<PostWalker<Rerouter>> {
      bool isFunctionParallel() override { return true; }

      J2CLItableMerging& parent;

      Rerouter(J2CLItableMerging& parent) : parent(parent) {}

      std::unique_ptr<Pass> create() override {
        return std::make_unique<Rerouter>(parent);
      }

      void visitStructGet(StructGet* curr) {
        if (curr->ref->type == Type::unreachable) {
          return;
        }

        if (curr->type.isStruct() &&
            parent.structInfoByITableType.find(curr->type.getHeapType()) !=
                parent.structInfoByITableType.end()) {
          // This is struct.get that returns an itable type;
          // Change to return the corresponding vtable type.
          Builder builder(*getModule());
          replaceCurrent(builder.makeStructGet(
              0, curr->ref,
              parent.structInfoByITableType[curr->type.getHeapType()]
                  ->javaClass.getStruct()
                  .fields[0]
                  .type));

          return;
        }
      }
    };

    Rerouter rerouter(*this);
    rerouter.run(getPassRunner(), &wasm);
    rerouter.runOnModuleCode(getPassRunner(), &wasm);
  }

  // Modify the struct definitions adding the itable fields to the vtable and
  // preserving the vtable field names.
  void updateTypes(Module& wasm) {
    class TypeRewriter : public GlobalTypeRewriter {
      J2CLItableMerging& parent;

     public:
      TypeRewriter(Module& wasm, J2CLItableMerging& parent)
          : GlobalTypeRewriter(wasm), parent(parent) {}

      void modifyStruct(HeapType oldStructType, Struct& struct_) override {
        if (parent.structInfoByVtableType.find(oldStructType) !=
            parent.structInfoByVtableType.end()) {
          auto& newFields = struct_.fields;

          auto structInfo = parent.structInfoByVtableType[oldStructType];
          // Add the itable fields to the beginning of the vtable.
          auto it = structInfo->itable.getStruct().fields.rbegin();
          while (it != structInfo->itable.getStruct().fields.rend()) {
            newFields.insert(newFields.begin(), *it++);
            newFields[0].type = getTempType(newFields[0].type);
          }

          //  Update field names as well. The Type Rewriter cannot do this for
          //  us, as it does not know which old fields map to which new ones
          //  (it just keeps the names in sequence).
          auto iter = wasm.typeNames.find(oldStructType);
          if (iter != wasm.typeNames.end()) {
            auto& nameInfo = iter->second;

            // Make a copy of the old ones to base ourselves off of as we do
            auto oldFieldNames = nameInfo.fieldNames;

            // Clear the old names and write the new ones.
            nameInfo.fieldNames.clear();
            // Only need to preserve the field names for the vtable fields; the
            // itable fields do not have names (in the original .wat file they
            // are accessed by index).
            for (Index i = 0; i < oldFieldNames.size(); i++) {
              nameInfo.fieldNames[i + structInfo->itable.getStruct()
                                          .fields.size()] = oldFieldNames[i];
            }
          }
        }
      }
    };

    TypeRewriter(wasm, *this).update();
  }
};

}  // anonymous namespace

Pass* createJ2CLItableMergingPass() { return new J2CLItableMerging(); }
}  // namespace wasm