/*
 * Copyright 2021 WebAssembly Community Group participants
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

//
// Converts vtables - structs of function references - to use indexes. That is,
// this replaces function reference fields with i32 fields. Specifically,
//
//  (struct (field (ref $functype1)) (field (ref $functype2))
// =>
//  (struct (field (ref i32))        (field (ref i32))
//
// This also creates a table for each field and populates it with the possible
// values. Then struct.news are altered to replace references with indexes, and
// struct.gets are altered to load from the table.
//
// Assumptions:
//  * All function reference fields in structs should be transformed.
//  * Such fields must be written to during creation of a vtable instance, and
//    with a constant ref.func, and never written to with struct.set.
//  * Vtable subtyping is allowed, but not to specialize types of the parent. If
//    that were done, we'd need to add casts to handle the table no having the
//    specialized type (it would have the subtype).
//

#include <mutex>

#include <ir/module-utils.h>
//#include "ir/subtypes.h" // Needed?
#include "ir/utils.h"
#include <pass.h>
#include <wasm.h>
#include <wasm-type.h>
#include <wasm-builder.h>

using namespace std;

namespace wasm {

namespace {

struct MappingInfo {
  // Maps old heap types to new ones.
  std::unordered_map<HeapType, HeapType> oldToNewTypes;

  // For each table, a map of functions in the table to their indexes.
  std::unordered_map<Name, std::unordered_map<Name, Index>> tableFuncIndexes;

  // Maps each (struct, field index of a function reference) to the table in
  // which it is declared.
  std::unordered_map<std::pair<HeapType, Index>, Name> fieldTables;

  // When modifying this data structure in parallel, this mutex must be taken.
  // Using a mutex is reasonable here since we have few edits to make (only for
  // struct.news, which are rare).
  std::mutex mutex;
};

struct GlobalSubtyping : public Pass {
  MappingInfo mapping;

  void run(PassRunner* runner, Module* module) override {
std::cout << "map\n";
    // Create the new types and get a mapping of the old ones to the new.
    mapOldTypesToNew(*module);

    mapFunctionsToTables(runner, *module);

std::cout << "update\n";
    // Update all the types to the new ones.
    updateModule(runner, *module);
  }

  void mapOldTypesToNew(Module& wasm) {
    // Collect all the types.
    std::vector<HeapType> types;
    std::unordered_map<HeapType, Index> typeIndices;
    ModuleUtils::collectHeapTypes(wasm, types, typeIndices);

    // We will need to map types to their indexes.
    std::unordered_map<HeapType, Index> typeToIndex;
    for (Index i = 0; i < types.size(); i++) {
      typeToIndex[types[i]] = i;
    }

    TypeBuilder typeBuilder(types.size());

    // Map an old type to a new type. This is called on the contents of the
    // temporary heap types, so it basically just needs to map to other temp
    // heap types.
    std::function<Type (Type)> getNewType = [&](Type type) {
      if (type.isBasic()) {
        return type;
      }
      if (type.isRef()) {
        return typeBuilder.getTempRefType(
          typeBuilder.getTempHeapType(typeToIndex.at(type.getHeapType())),
          type.getNullability()
        );
      }
      if (type.isRtt()) {
        auto rtt = type.getRtt();
        auto newRtt = rtt;
        newRtt.heapType = 
          typeBuilder.getTempHeapType(typeToIndex.at(type.getHeapType()));
        return typeBuilder.getTempRttType(newRtt);
      }
      if (type.isTuple()) {
        auto& tuple = type.getTuple();
        auto newTuple = tuple;
        for (auto& t : newTuple.types) {
          t = getNewType(t);
        }
        return typeBuilder.getTempTupleType(newTuple);
      }
      WASM_UNREACHABLE("bad type");
    };

    // Map an old type to a new type, for a struct field. This does the special
    // operation we are doing here, which is to replace function referencs with
    // i32s.
    auto getNewTypeForStruct = [&](Type type) -> Type {
      if (type.isFunction()) {
        // This is exactly what we are looking to change!
        return Type::i32;
      }
      return getNewType(type);
    };

    // Create the temporary heap types.
    for (Index i = 0; i < types.size(); i++) {
      auto type = types[i];
      if (type.isSignature()) {
        auto sig = type.getSignature();
        TypeList newParams, newResults;
        for (auto t : sig.params) {
          newParams.push_back(getNewType(t));
        }
        for (auto t : sig.results) {
          newResults.push_back(getNewType(t));
        }
        typeBuilder.setHeapType(i, Signature(typeBuilder.getTempTupleType(newParams), typeBuilder.getTempTupleType(newResults)));
      } else if (type.isStruct()) {
        auto struct_ = type.getStruct();
        // Start with a copy to get mutability/packing/etc.
        auto newStruct = struct_;
        for (auto& field : newStruct.fields) {
          field.type = getNewTypeForStruct(field.type);
        }
        typeBuilder.setHeapType(i, newStruct);
      } else if (type.isArray()) {
        auto array = type.getArray();
        // Start with a copy to get mutability/packing/etc.
        auto newArray = array;
        newArray.element.type = getNewType(newArray.element.type);
        typeBuilder.setHeapType(i, newArray);
      } else {
        WASM_UNREACHABLE("bad type");
      }
    }
    auto newTypes = typeBuilder.build();

    for (Index i = 0; i < types.size(); i++) {
      mapping.oldToNewTypes[types[i]] = newTypes[i];
    }
  }

  void mapFunctionsToTables(PassRunner* runner, Module& wasm) {
    struct CodeScanner
      : public WalkerPass<PostWalker<CodeScanner>> {
      bool isFunctionParallel() override { return true; }

      MappingInfo& mapping;

      CodeScanner(MappingInfo& mapping) : mapping(mapping) {}

      CodeScanner* create() override {
        return new CodeScanner(mapping);
      }

      void visitStructNew(StructNew* curr) {
        for (Index i = 0; i < curr->operands.size(); i++) {
          auto* operand = curr->operands[i];
          if (operand->type.isFunction()) {
            // Note this function so that s
            auto* refFunc = operand->cast<RefFunc>();
            auto heapType = curr->type.getHeapType();
            Index funcIndex;

            // Lock while we are working on the shared mapping data.
            {
              std::lock_guard<std::mutex> lock(mapping.mutex);
              auto fieldTable = getFieldTable(heapType, i);
              funcIndex = getFuncIndex(fieldTable, refFunc->func);
            }

            // Replace the function reference with the proper index.
            operands[i] = Builder(*getModule()).makeConst(int32_t(funcIndex));
          }
        }
      }

      void getFieldTable(HeapType type, Index i) {
        auto& fieldTable = mapping.fieldTables[{heapType, i}];
        if (!fieldTable.is()) {
          // Compute the table in which we will store functions for this field.
          // First, find the supertype in which this field was first defined;
          // all subclasses use the same table for their functions.
          HeapType parent = heapType;
          while (1) {
            HeapType grandParent;
            if (!parent.getSuperType(grandParent)) {
              // No more supers, so parent is the topmost one.
              break;
            }
            if (i >= grandParent.getStruct().fields.size()) {
              // The grand-parent does not have this field, so parent is where
              // it is first defined.
              break;
            }
            // Otherwise, continue up.
            parent = grandParent;
          }

          // We know the proper supertype, and our table is the one it has.
          auto& parentFieldTable = mapping.fieldTables[{parent, i}];
          
        }
      }

      void getFuncIndex(Name fieldTable, Name func) {
        // Get the table info
        auto& tableInfo = mapping.tableFuncIndexes[

      }

struct MappingInfo {
  // Maps old heap types to new ones.
  std::unordered_map<HeapType, HeapType> oldToNewTypes;

  // For each table, a map of functions in the table to their indexes.
  std::unordered_map<Name, std::unordered_map<Name, Index>> tableFuncIndexes;

  // Maps each (struct, field index of a function reference) to the table in
  // which it is declared.
  std::unordered_map<std::pair<HeapType, Index>, Name> fieldTables;

  // When modifying this data structure in parallel, this mutex must be taken.
  // Using a mutex is reasonable here since we have few edits to make (only for
  // struct.news, which are rare).
  std::mutex mutex;
};





    };

    CodeScanner updater(mapping);
    updater.run(runner, &wasm);
    updater.walkModuleCode(&wasm);
  }

  void updateModule(PassRunner* runner, Module& wasm) {
    struct CodeUpdater
      : public WalkerPass<PostWalker<CodeUpdater, UnifiedExpressionVisitor<CodeUpdater>>> {
      bool isFunctionParallel() override { return true; }

      MappingInfo& mapping;

      CodeUpdater(MappingInfo& mapping) : mapping(mapping) {}

      CodeUpdater* create() override {
        return new CodeUpdater(mapping);
      }

      Type update(Type type) {
        if (type.isRef()) {
          return Type(update(type.getHeapType()), type.getNullability());
        }
        if (type.isRtt()) {
          return Type(Rtt(type.getRtt().depth, update(type.getHeapType())));
        }
        return type;
      }

      HeapType update(HeapType type) {
        if (type.isBasic()) {
          return type;
        }
        if (type.isFunction() || type.isData()) {
std::cout << "type: " << type << "\n";
          return mapping.oldToNewTypes.at(type);
        }
        return type;
      }

      Signature update(Signature sig) {
        return Signature(update(sig.params), update(sig.results));
      }

      void visitStructGet(StructGet* curr) {
        if (curr->type.isFunction()) {
          // Read the i32 index, and get the reference from the table.
          curr->type = Type::i32;
          replaceCurrent(
            Builder(*getModule()).makeTableGet(
              ..table..,
              curr
            )
          );
          return;
        }

        // Otherwise, update the type normally.
        curr->type = update(curr->type);
      }

      void visitStructNew(StructNew* curr) {
        for (auto& operand : curr->operands) {
          if (operand->type.isFunction()) {
            auto* refFunc = operand->cast<RefFunc>();
            auto func = refFunc->func;
            // Write an i32 index instead.
            operand = Builder(*getModule()).makeConst(int32_t(..));
          }
        }

        curr->type = update(curr->type);
      }

      // Generic visitor. Specific things were overridden earlier.
      void visitExpression(Expression* curr) {
        // Update the type to the new one.
        curr->type = update(curr->type);

        // Update any other type fields as well.

#define DELEGATE_ID curr->_id

#define DELEGATE_START(id)                                                     \
  auto* cast = curr->cast<id>();                                               \
  WASM_UNUSED(cast);

#define DELEGATE_GET_FIELD(id, name) cast->name

#define DELEGATE_FIELD_TYPE(id, name) \
  cast->name = update(cast->name);

#define DELEGATE_FIELD_HEAPTYPE(id, name) \
  cast->name = update(cast->name);

#define DELEGATE_FIELD_SIGNATURE(id, name) \
  cast->name = update(cast->name);

#define DELEGATE_FIELD_CHILD(id, name)
#define DELEGATE_FIELD_OPTIONAL_CHILD(id, name)
#define DELEGATE_FIELD_INT(id, name)
#define DELEGATE_FIELD_INT_ARRAY(id, name)
#define DELEGATE_FIELD_LITERAL(id, name)
#define DELEGATE_FIELD_NAME(id, name)
#define DELEGATE_FIELD_NAME_VECTOR(id, name)
#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, name)
#define DELEGATE_FIELD_SCOPE_NAME_USE(id, name)
#define DELEGATE_FIELD_SCOPE_NAME_USE_VECTOR(id, name)
#define DELEGATE_FIELD_ADDRESS(id, name)

#include "wasm-delegations-fields.def"
      }
    };

    CodeUpdater updater(mapping);
    updater.run(runner, &wasm);
    updater.walkModuleCode(&wasm);

    // Propagate types after our changes.
    ReFinalize().run(runner, &wasm); // XXX th is is wrong. remove header too

    // Update global locations that refer to types.
    for (auto& table : wasm.tables) {
      table->type = updater.update(table->type);
    }
    for (auto& elementSegment : wasm.elementSegments) {
      elementSegment->type = updater.update(elementSegment->type);
    }
    for (auto& global : wasm.globals) {
      global->type = updater.update(global->type);
    }
    for (auto& func : wasm.functions) {
      func->type = updater.update(func->type);
    }

    for (auto& kv : mapping.oldToNewTypes) {
      auto old = kv.first;
      auto new_ = kv.second;
      if (wasm.typeNames.count(old)) {
        wasm.typeNames[new_] = wasm.typeNames[old];
      }
    }
  }
};

    //SubTypes subTypes(*module);

} // anonymous namespace

Pass* createGlobalSubtypingPass() { return new GlobalSubtyping(); }

} // namespace wasm
