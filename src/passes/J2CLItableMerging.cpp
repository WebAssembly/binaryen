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

#include <memory>
#include <string_view>
#include <unordered_map>

#include "ir/type-updating.h"
#include "pass.h"
#include "support/utilities.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
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
  // Number of entries at the start of the descriptor that should not change
  // index. If the vtable is a custom descriptor, itable fields are inserted at
  // index 1. Index 0 is preserved for a possible JS prototype.
  static const Index kPreservedDescriptorFields = 1;

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
    auto hasField =
      [](TypeNames& typeNameInfo, int index, std::string_view name) {
        auto it = typeNameInfo.fieldNames.find(index);
        return it != typeNameInfo.fieldNames.end() && it->second.equals(name);
      };

    // 1. Collect all structs that correspond that a Java type.
    for (auto [heapType, typeNameInfo] : wasm.typeNames) {
      if (!heapType.isStruct()) {
        continue;
      }

      // The vtable may either be the first field or the custom descriptor.
      HeapType vtabletype;
      HeapType itabletype;
      auto& type = heapType.getStruct();
      if (auto descriptor = heapType.getDescriptorType()) {
        if (!hasField(typeNameInfo, 0, "itable")) {
          continue;
        }

        vtabletype = *descriptor;
        // If the vtable is a descriptor, we enforce that it has at least 1
        // field for the possible JS prototype and simply assume this
        // downstream. In practice, this is necessary anyway to allow vtables to
        // subtype each other.
        if (vtabletype.getStruct().fields.size() < kPreservedDescriptorFields) {
          Fatal() << "--merge-j2cl-itables needs to be the first pass to run "
                  << "on j2cl output. (descriptor has fewer than expected "
                  << "fields)";
        }

        itabletype = type.fields[0].type.getHeapType();
      } else {
        if (!hasField(typeNameInfo, 0, "vtable") ||
            !hasField(typeNameInfo, 1, "itable")) {
          continue;
        }

        vtabletype = type.fields[0].type.getHeapType();
        itabletype = type.fields[1].type.getHeapType();
      }

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
        auto* structInfo = getStructInfoByVtableType(curr->ref->type);
        if (!structInfo) {
          return;
        }

        // This is a struct.get on the vtable.
        // It is ok to just change the index since the field has moved but
        // the type is the same.
        if (structInfo->javaClass.getDescriptorType()) {
          if (curr->index >= kPreservedDescriptorFields) {
            curr->index += parent.itableSize;
          }
        } else {
          curr->index += parent.itableSize;
        }
      }

      void visitStructNew(StructNew* curr) {
        auto* structInfo = getStructInfoByVtableType(curr->type);
        if (!structInfo) {
          return;
        }

        // The struct.new is for a vtable type and structInfo has the
        // information relating the struct types for the Java class, its vtable
        // and its itable.

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

        size_t insertIndex =
          structInfo->javaClass.getDescriptorType().has_value()
            ? kPreservedDescriptorFields
            : 0;

        // Add the initialization for the itable fields.
        for (Index i = parent.itableSize; i > 0; i--) {
          if (itableFieldInitializers.size() >= i) {
            // The itable was initialized with a struct.new, copy the
            // initialization values.
            curr->operands.insertAt(
              insertIndex,
              ExpressionManipulator::copy(itableFieldInitializers[i - 1],
                                          *getModule()));
          } else {
            // The itable was initialized with struct.new_default. So use
            // null values to initialize the itable fields.
            Builder builder(*getModule());
            curr->operands.insertAt(
              insertIndex,
              builder.makeRefNull(itableStructNew->type.getHeapType()
                                    .getStruct()
                                    .fields[i - 1]
                                    .type.getHeapType()));
          }
        }
      }

      StructInfo* getStructInfoByVtableType(Type type) {
        if (type == Type::unreachable) {
          return nullptr;
        }
        if (auto it = parent.structInfoByVtableType.find(type.getHeapType());
            it != parent.structInfoByVtableType.end()) {
          return it->second;
        }
        return nullptr;
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
        // Determine if the struct.get is to get a field from the itable or the
        // to get the itable itself.

        if (auto* structInfo = getStructInfoByItableType(curr->ref->type)) {
          // This is a struct.get that returns an itable field.
          updateGetItableField(curr, structInfo->javaClass);
          return;
        }

        if (auto* structInfo = getStructInfoByItableType(curr->type)) {
          // This is a struct.get that returns an itable type.
          updateGetItable(curr, structInfo->javaClass);
          return;
        }
      }

      StructInfo* getStructInfoByItableType(Type type) {
        if (type == Type::unreachable || !type.isStruct()) {
          return nullptr;
        }
        if (auto it = parent.structInfoByITableType.find(type.getHeapType());
            it != parent.structInfoByITableType.end()) {
          return it->second;
        }
        return nullptr;
      }

      void updateGetItableField(StructGet* curr, HeapType javaClass) {
        if (!javaClass.getDescriptorType()) {
          return;
        }

        curr->index += kPreservedDescriptorFields;
        if (auto childGet = curr->ref->dynCast<StructGet>()) {
          // The reference is another struct.get. It is getting the itable for
          // the type.
          // Replace it with a ref.get_desc for the vtable, which is the
          // descriptor.
          Builder builder(*getModule());
          curr->ref = builder.makeRefGetDesc(childGet->ref);
          return;
        }

        // We expect the reference to be another struct.get.
        Fatal() << "--merge-j2cl-itables needs to be the first pass to run "
                << "on j2cl output. (itable getter not found) ";
      }

      void updateGetItable(StructGet* curr, HeapType javaClass) {
        if (javaClass.getDescriptorType()) {
          return;
        }

        // Change to return the corresponding vtable type (field 0).
        Builder builder(*getModule());
        replaceCurrent(builder.makeStructGet(
          0,
          curr->ref,
          MemoryOrder::Unordered,
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
        auto structInfoIt = parent.structInfoByVtableType.find(oldStructType);
        if (structInfoIt == parent.structInfoByVtableType.end()) {
          return;
        }

        auto& newFields = struct_.fields;

        auto* structInfo = structInfoIt->second;

        Index insertIndex =
          structInfo->javaClass.getDescriptorType().has_value()
            ? kPreservedDescriptorFields
            : 0;

        // Add the itable fields to the beginning of the vtable.
        auto& itableFields = structInfo->itable.getStruct().fields;
        newFields.insert(newFields.begin() + insertIndex,
                         itableFields.begin(),
                         itableFields.end());
        for (Index i = 0; i < parent.itableSize; i++) {
          newFields[insertIndex + i].type =
            getTempType(newFields[insertIndex + i].type);
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
        for (Index i = 0; i < insertIndex; i++) {
          if (auto name = oldFieldNames[i]) {
            nameInfo.fieldNames[i] = name;
          }
        }
        for (Index i = insertIndex; i < oldFieldNames.size(); i++) {
          if (auto name = oldFieldNames[i]) {
            nameInfo.fieldNames[i + parent.itableSize] = name;
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
