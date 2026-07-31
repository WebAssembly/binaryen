/*
 * Copyright 2026 WebAssembly Community Group participants
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

// Make all structs and arrays shared and makes all functions unshared. This
// serves two purposes: 1) converts unshared Wasm GC programs to use the shared
// heap for testing, and 2) lowers shared Wasm GC programs that use shared
// functions so they can run on experimental implementations that do not support
// shared functions.
//
// Because shared structs and arrays cannot contain unshared function
// references, replace function references in structs and arrays with indices
// into a function table that will be duplicated on each thread. Because
// arbitrary unknown function references may be written into structs and arrays
// and there is no way to look up a table index given a function reference,
// function references cannot be replaced only inside structs and arrays.
// Replace all function references in the module with table indices and fix up
// all instructions that consume function references (e.g. call_ref, casts)
// accordingly. Use i31 references to represent the table indices to avoid
// further complications from mapping function references to non-reference
// values.

#include "ir/drop.h"
#include "ir/module-utils.h"
#include "ir/names.h"
#include "ir/type-updating.h"
#include "ir/utils.h"
#include "literal.h"
#include "pass.h"
#include "support/name.h"
#include "wasm-builder.h"
#include "wasm-features.h"
#include "wasm-traversal.h"
#include "wasm-type.h"
#include "wasm.h"

#include <unordered_map>
#include <vector>

namespace wasm {

struct MakeSharedObjects
  : WalkerPass<PostWalker<MakeSharedObjects,
                          UnifiedExpressionVisitor<MakeSharedObjects>>> {
  Name tableName;
  std::vector<Name> funcs;
  std::unordered_map<Name, Index> funcIndices;

  Type funcref = Type(HeapTypes::func, Nullable);

  Name getTable() {
    if (!tableName) {
      tableName = Names::getValidTableName(*getModule(), "funcs");
    }
    return tableName;
  }

  Index getIndex(Name func) {
    auto [it, inserted] = funcIndices.insert({func, funcs.size()});
    if (inserted) {
      funcs.push_back(func);
    }
    return it->second;
  }

  HeapType updatedHeapType(HeapType type) {
    if (type.isMaybeShared(HeapType::func) || type.isSignature()) {
      return HeapTypes::i31.getBasic(Shared);
    }
    if (type.isMaybeShared(HeapType::nofunc)) {
      return HeapTypes::none.getBasic(Shared);
    }
    if (type.isBasic()) {
      return type.getBasic(Shared);
    }
    return type;
  }

  Type updatedSingleType(Type type) {
    if (type.isRef()) {
      return type.with(updatedHeapType(type.getHeapType()));
    }
    return type;
  }

  Type updatedType(Type type) {
    if (type.isTuple()) {
      std::vector<Type> elems;
      elems.reserve(type.size());
      for (auto t : type) {
        elems.push_back(updatedSingleType(t));
      }
      return Type(elems);
    }
    return updatedSingleType(type);
  }

  void updateType(Type& type) { type = updatedType(type); }

  void visitRefFunc(RefFunc* curr) {
    Builder builder(*getModule());
    replaceCurrent(builder.makeRefI31(
      builder.makeConst(Literal(getIndex(curr->func))), Shared));
  }

  std::unordered_map<CallRef*, HeapType> callRefTypes;

  void walkFunction(Function* curr) {
    // When we replace call_ref target operands with i31s, we will lose
    // information we need about the intended call target type. Collect those
    // types up front before we update anything.
    struct CallRefCollector : PostWalker<CallRefCollector> {
      std::unordered_map<CallRef*, HeapType>& types;
      CallRefCollector(std::unordered_map<CallRef*, HeapType>& types)
        : types(types) {}
      void visitCallRef(CallRef* curr) {
        if (curr->target->type.isSignature()) {
          types[curr] = curr->target->type.getHeapType();
        }
      }
    };
    CallRefCollector collector(callRefTypes);
    collector.walk(curr->body);
    WalkerPass::walkFunction(curr);
    ReFinalize().walkFunctionInModule(curr, getModule());
  }

  void visitCallRef(CallRef* curr) {
    updateType(curr->type);
    Builder builder(*getModule());
    auto it = callRefTypes.find(curr);
    if (it == callRefTypes.end()) {
      // The target type wasn't a signature, so it must have been null or
      // unreachable.
      replaceCurrent(
        getDroppedChildrenAndAppend(curr,
                                    *getModule(),
                                    getPassOptions(),
                                    builder.makeUnreachable(),
                                    DropMode::IgnoreParentEffects));
      return;
    }
    auto type = it->second;
    callRefTypes.erase(it);
    replaceCurrent(
      builder.makeCallIndirect(getTable(),
                               builder.makeI31Get(curr->target, false),
                               curr->operands,
                               type,
                               curr->isReturn));
  }

  void visitCallIndirect(CallIndirect* curr) {
    updateType(curr->type);
    Builder builder(*getModule());
    Name oldTable = curr->table;
    Type oldTableType = updatedType(getModule()->getTable(oldTable)->type);
    auto* index = builder.makeTableGet(oldTable, curr->target, oldTableType);
    curr->target = builder.makeI31Get(index, false);
    curr->table = getTable();
  }

  void visitRefTest(RefTest* curr) {
    if (curr->type == Type::unreachable) {
      return;
    }
    auto castHeapType = curr->castType.getHeapType();
    if (castHeapType.isMaybeShared(HeapType::func) ||
        castHeapType.isMaybeShared(HeapType::nofunc)) {
      // This always passes or fails except possibly due to nulls.
      updateType(curr->castType);
      return;
    }
    if (!castHeapType.isSignature()) {
      return;
    }
    Builder builder(*getModule());
    if (curr->ref->type.isNonNullable()) {
      // (ref.test castType (table.get $t (i31.get_u ref)))
      curr->ref = builder.makeTableGet(
        getTable(), builder.makeI31Get(curr->ref, false), funcref);
      return;
    }
    // (if (result i32)
    //   (ref.is_null (local.tee $scratch ref))
    //   (then (i32.const 1) OR (i32.const 0))
    //   (else (ref.test castType
    //     (table.get $t (i31.get_u (local.get $scratch))))
    //   )
    // )
    auto scratchType = curr->ref->type;
    Index scratch = Builder::addVar(getFunction(), scratchType);
    auto* cond = builder.makeRefIsNull(
      builder.makeLocalTee(scratch, curr->ref, scratchType));
    auto* ifNull =
      builder.makeConst(Literal(int32_t(curr->castType.isNullable())));
    curr->ref = builder.makeTableGet(
      getTable(),
      builder.makeI31Get(builder.makeLocalGet(scratch, scratchType), false),
      funcref);
    replaceCurrent(builder.makeIf(cond, ifNull, curr, Type::i32));
  }

  void visitRefCast(RefCast* curr) {
    if (curr->type == Type::unreachable) {
      return;
    }
    auto castHeapType = curr->type.getHeapType();
    if (castHeapType.isMaybeShared(HeapType::func) ||
        castHeapType.isMaybeShared(HeapType::nofunc)) {
      // This always passes or fails except possibly due to nulls.
      updateType(curr->type);
      return;
    }
    if (!castHeapType.isSignature()) {
      return;
    }
    if (getPassOptions().trapsNeverHappen) {
      // shared i31 in, shared i31 out, no matter what the cast source and
      // target are.
      replaceCurrent(curr->ref);
      return;
    }
    // (if (result sharedi31ref)
    //   (ref.is_null (local.tee $scratch ref)),
    //   (then (local.get $scratch) OR (unreachable))
    //   (else
    //     (if (result sharedi31ref)
    //        (ref.test castType
    //          (table.get $t (i31.get_u (local.get $scratch)))
    //        (then (ref.as_non_null? (local.get $scratch)))
    //        (else (unreachable))
    //     )
    //   )
    // )
    Builder builder(*getModule());
    auto newCastType = updatedType(curr->type);
    auto scratchType = curr->ref->type;
    Index scratch = Builder::addVar(getFunction(), scratchType);
    auto* tee = builder.makeLocalTee(scratch, curr->ref, scratchType);
    auto* isNull = builder.makeRefIsNull(tee);
    Expression* ifNull = nullptr;
    if (curr->type.isNullable()) {
      ifNull = builder.makeLocalGet(scratch, scratchType);
    } else {
      ifNull = builder.makeUnreachable();
    }
    auto* getScratch = builder.makeLocalGet(scratch, scratchType);
    auto* i31get = builder.makeI31Get(getScratch, false);
    auto* tableGet = builder.makeTableGet(getTable(), i31get, funcref);
    auto* refTest = builder.makeRefTest(tableGet, curr->type);
    Expression* ifPass = builder.makeLocalGet(scratch, scratchType);
    if (curr->type.isNonNullable()) {
      ifPass = builder.makeRefAs(RefAsNonNull, ifPass);
    }
    auto* ifFail = builder.makeUnreachable();
    auto* ifNonNull = builder.makeIf(refTest, ifPass, ifFail, newCastType);
    replaceCurrent(builder.makeIf(isNull, ifNull, ifNonNull, newCastType));
  }

  void visitBrOn(BrOn* curr) {
    if (curr->type == Type::unreachable) {
      return;
    }
    if (curr->op != BrOnCast && curr->op != BrOnCastFail) {
      return;
    }
    auto castHeapType = curr->castType.getHeapType();
    if (castHeapType.isMaybeShared(HeapType::func) ||
        castHeapType.isMaybeShared(HeapType::nofunc)) {
      // This always passes or fails except possibly due to nulls.
      updateType(curr->castType);
      return;
    }
    WASM_UNREACHABLE("TODO: br_on");
  }

  void visitExpression(Expression* curr) {
    updateType(curr->type);

#define DELEGATE_ID curr->_id
#define DELEGATE_START(id) [[maybe_unused]] auto* cast = curr->cast<id>();
#define DELEGATE_GET_FIELD(id, field) cast->field
#define DELEGATE_FIELD_TYPE(id, field) updateType(cast->field);
#define DELEGATE_FIELD_CHILD(id, field)
#define DELEGATE_FIELD_INT(id, field)
#define DELEGATE_FIELD_LITERAL(id, field)
#define DELEGATE_FIELD_NAME(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_USE(id, field)
#define DELEGATE_FIELD_HEAPTYPE(id, field)
#define DELEGATE_FIELD_ADDRESS(id, field)
#include "wasm-delegations-fields.def"
  }

  void visitFunction(Function* curr) {
    for (auto& type : curr->vars) {
      updateType(type);
    }
  }

  void visitTable(Table* curr) { updateType(curr->type); }

  void visitElementSegment(ElementSegment* curr) { updateType(curr->type); }

  void visitGlobal(Global* curr) { updateType(curr->type); }

  void doWalkModule(Module* wasm) {
    wasm->features.setSharedEverything();
    WalkerPass::doWalkModule(wasm);
  }

  void visitModule(Module* wasm) {
    rewriteTypes();
    addFunctionTable();
  }

  void rewriteTypes() {
    auto info = ModuleUtils::getOptimizedIndexedHeapTypes(*getModule());
    TypeBuilder builder(info.types.size());

    auto map = [&](HeapType type) -> HeapType {
      if (auto newType = updatedHeapType(type); newType.isBasic()) {
        return newType;
      }
      return builder[info.indices.at(type)];
    };

    for (Index i = 0; i < info.types.size(); ++i) {
      if (info.types[i].getRecGroupIndex() == 0) {
        builder.createRecGroup(i, info.types[i].getRecGroup().size());
      }
      builder[i].copy(info.types[i], map);
      if (info.types[i].isSignature()) {
        builder[i].setShared(Unshared);
        // `map` will have mapped any supertype to i31, which means the copy
        // will not have its supertype set. Fix it.
        if (auto super = info.types[i].getDeclaredSuperType()) {
          builder[i].subTypeOf(builder[info.indices.at(*super)]);
        }
      }
      builder[i].setShared(info.types[i].isSignature() ? Unshared : Shared);
    }

    auto built = builder.build();
    if (auto* err = built.getError()) {
      Fatal() << "Failed to build types: " << err->index << ": " << err->reason;
    }

    assert(info.types.size() == built->size());
    std::unordered_map<HeapType, HeapType> oldToNew;
    for (Index i = 0; i < info.types.size(); ++i) {
      oldToNew[info.types[i]] = (*built)[i];
    }

    GlobalTypeRewriter rewriter(*getModule(), getPassOptions().worldMode);
    rewriter.mapTypes(oldToNew);
    rewriter.mapTypeNamesAndIndices(oldToNew);
  }

  void addFunctionTable() {
    if (!tableName) {
      return;
    }
    Builder builder(*getModule());
    Table* table = getModule()->addTable(Builder::makeTable(tableName));
    table->type = funcref;
    table->initial = table->max = funcs.size();
    Name segName = Names::getValidElementSegmentName(*getModule(), "funcs");
    auto* offset = builder.makeConst(Literal(int32_t(0)));
    auto* segment = getModule()->addElementSegment(
      Builder::makeElementSegment(segName, tableName, offset));
    segment->type = funcref;

    segment->data.reserve(funcs.size());
    for (auto func : funcs) {
      segment->data.push_back(
        builder.makeRefFunc(func, getModule()->getFunction(func)->type));
    }
  }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<MakeSharedObjects>();
  }
};

Pass* createMakeSharedObjectsPass() { return new MakeSharedObjects(); }

} // namespace wasm
