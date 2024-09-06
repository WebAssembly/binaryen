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
// The motivation for embedding itables into vtables is to reduce memory usage.
//
// The pass makes the following transformation on the structs related to Java
// classes. For given type `Foo` with `Foo[vtable] = { m1, m2, m3, ... }`
// and  `Foo[itable] = { i1, i2, ...}`, this pass transforms it to
// `Foo[vtable] = { i1, i2, ...., m1, m2, m3, ... }`, and fixes all accesses
// and initializations accordingly.

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
  HeapType vtable;
  HeapType itable;
};

struct J2CLItableMerging : public Pass {
  // Keep track of all the structInfos so that they will be automatically
  // released after the pass is done.
  std::list<StructInfo> structInfos;

  // Globals that hold vtables and itables indexed by their heap type.
  // There is exactly 1 global for each vtable/itable type.
  std::unordered_map<HeapType, Global*> tableGlobalsByType;
  std::unordered_map<HeapType, StructInfo*> structInfoByVtableType;
  std::unordered_map<HeapType, StructInfo*> structInfoByITableType;

  unsigned long itableSize = 0;

  void run(Module* module) override {
    if (!module->features.hasGC()) {
      return;
    }

    if (!getPassOptions().closedWorld) {
      Fatal() << "--merge-j2cl-itables requires --closed-world";
    }

    collectVtableAndItableTypes(*module);
    // Update the indices to access the functions in the vtables and update
    // the construction of the vtable instances.
    updateVtableFieldsAccesses(*module);
    // And now we can transform the accesses to the itable fields into their
    // corresponding vtable fields. Needs to be done after
    // updateVtableFieldsAccesses.
    rerouteItableAccess(*module);
    // The type structures are updated last since types are used as keys in
    // the maps used above.
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
    // 1. Collect all structs that correspond that a Java type.
    for (auto [heapType, typeNameInfo] : wasm.typeNames) {

      if (!heapType.isStruct()) {
        continue;
      }

      auto type = heapType.getStruct();
      if (typeNameInfo.fieldNames.empty() ||
          !typeNameInfo.fieldNames[0].equals("vtable")) {
        continue;
      }
      if (typeNameInfo.fieldNames.size() < 1 ||
          !typeNameInfo.fieldNames[1].equals("itable")) {
        continue;
      }

      auto vtabletype = type.fields[0].type.getHeapType();
      auto itabletype = type.fields[1].type.getHeapType();

      auto structItableSize = itabletype.getStruct().fields.size();

      if (itableSize != 0 && itableSize != structItableSize) {
        Fatal() << "--merge-j2cl-itables needs to be the first pass to run "
                << "on j2cl output. (found itables with different sizes)";
      }

      itableSize = structItableSize;

      // Add a new StructInfo to the list by value so that its memory gets
      // reclaimed automatically on exit.
      structInfos.push_back(StructInfo{heapType, vtabletype, itabletype});
      // Point to the StructInfo just added to the list to be able to look it
      // up by its vtable and itable types.
      structInfoByVtableType[vtabletype] = &structInfos.back();
      structInfoByITableType[itabletype] = &structInfos.back();
    }

    // 2. Collect the globals for vtables and itables.
    for (auto& g : wasm.globals) {
      if (!g->type.isStruct()) {
        continue;
      }
      if (structInfoByVtableType.count(g->type.getHeapType())) {
        tableGlobalsByType[g->type.getHeapType()] = g.get();
      } else if (structInfoByITableType.count(g->type.getHeapType())) {
        tableGlobalsByType[g->type.getHeapType()] = g.get();
      }
    }

    if (itableSize == 0) {
      Fatal() << "--merge-j2cl-itables needs to be the first pass to run "
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

        if (!parent.structInfoByVtableType.count(
              curr->ref->type.getHeapType())) {
          return;
        }
        // This is a struct.get on the vtable.
        // It is ok to just change the index since the field has moved but
        // the type is the same.
        curr->index += parent.itableSize;
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
        // information relating the struct types for the Java class, its vtable
        // and its itable.
        auto structInfo = it->second;

        // Get the global that holds the corresponding itable instance.
        auto* itableGlobal = parent.tableGlobalsByType[structInfo->itable];
        StructNew* itableStructNew = nullptr;

        if (itableGlobal && itableGlobal->init) {
          if (itableGlobal->init->is<GlobalGet>()) {
            // The global might get initialized with the shared empty itable,
            // obtain the itable struct.new from the global.init.
            auto* globalGet = itableGlobal->init->dynCast<GlobalGet>();
            auto* global = getModule()->getGlobal(globalGet->name);
            itableStructNew = global->init->dynCast<StructNew>();
          } else {
            // The global is initialized with a struct.new of the itable.
            itableStructNew = itableGlobal->init->dynCast<StructNew>();
          }
        }

        if (!itableStructNew) {
          Fatal() << "--merge-j2cl-itables needs to be the first pass to run "
                  << "on j2cl output. (itable initializer not found)";
        }
        auto& itableFieldInitializers = itableStructNew->operands;

        // Add the initialization for the itable fields.
        for (Index i = parent.itableSize; i > 0; i--) {
          if (itableFieldInitializers.size() >= i) {
            // The itable was initialized with a struct.new, copy the
            // initialization values.
            curr->operands.insertAt(
              0,
              ExpressionManipulator::copy(itableFieldInitializers[i - 1],
                                          *getModule()));
          } else {
            // The itable was initialized with struct.new_default. So use
            // null values to initialize the itable fields.
            Builder builder(*getModule());
            curr->operands.insertAt(
              0,
              builder.makeRefNull(itableStructNew->type.getHeapType()
                                    .getStruct()
                                    .fields[i - 1]
                                    .type.getHeapType()));
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

        if (!curr->type.isStruct() ||
            !parent.structInfoByITableType.count(curr->type.getHeapType())) {
          return;
        }

        // This is a struct.get that returns an itable type;
        // Change to return the corresponding vtable type.
        Builder builder(*getModule());
        replaceCurrent(builder.makeStructGet(
          0,
          curr->ref,
          parent.structInfoByITableType[curr->type.getHeapType()]
            ->javaClass.getStruct()
            .fields[0]
            .type));
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
        if (parent.structInfoByVtableType.count(oldStructType)) {
          auto& newFields = struct_.fields;

          auto structInfo = parent.structInfoByVtableType[oldStructType];
          // Add the itable fields to the beginning of the vtable.
          auto it = structInfo->itable.getStruct().fields.rbegin();
          while (it != structInfo->itable.getStruct().fields.rend()) {
            newFields.insert(newFields.begin(), *it++);
            newFields[0].type = getTempType(newFields[0].type);
          }

          // Update field names as well. The Type Rewriter cannot do this for
          // us, as it does not know which old fields map to which new ones
          // (it just keeps the names in sequence).
          auto& nameInfo = wasm.typeNames[oldStructType];

          // Make a copy of the old ones before clearing them.
          auto oldFieldNames = nameInfo.fieldNames;

          // Clear the old names and write the new ones.
          nameInfo.fieldNames.clear();
          // Only need to preserve the field names for the vtable fields; the
          // itable fields do not have names (in the original .wat file they
          // are accessed by index).
          for (Index i = 0; i < oldFieldNames.size(); i++) {
            nameInfo.fieldNames[i + parent.itableSize] = oldFieldNames[i];
          }
        }
      }
    };

    TypeRewriter(wasm, *this).update();
  }
};

} // anonymous namespace

Pass* createJ2CLItableMergingPass() { return new J2CLItableMerging(); }
} // namespace wasm