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
//
// Although the shared objects prototype supports shared externrefs in general,
// it is not the case that arbitrary unshared externrefs can be made shared. To
// work around this, also lower unshared externrefs to i31ref table indices.
// Unlike function references, which we assume form a closed set whose table
// indices are meaningful across threads, there can be an arbitrary number of
// externrefs at runtime and only those that are imported as globals can be
// assumed to be meaningful across different threads. As a result, the externref
// table supports growing over time and externrefs rather than their table
// indices are still passed at the module boundary, unlike for function
// references.

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

// Track several components used to store references in a table:
//  - The table itself
//  - Runtime functions for converting between references and table indices
//  - Utilities for inserting calls to these runtime functions as necessary.
// The table and runtime functions are only added to the module if they are
// used.
struct LazyTable {
  Module* wasm = nullptr;
  // The desired table name.
  Name base;
  // The non-conflicting version of `base`, if ever accessed.
  Name name;
  // The table type.
  Type type;
  // The names of conversion functions, if ever used.
  Name refToIndexName;
  Name indexToRefName;

  LazyTable(Name base, Type type) : base(base), type(type) {}

  Name getName() {
    assert(wasm);
    if (!name) {
      name = Names::getValidTableName(*wasm, base);
    }
    return name;
  }

  Name getRefToIndexName() {
    assert(wasm);
    if (!refToIndexName) {
      std::string funcName = type.getHeapType().toString() + "_to_index";
      refToIndexName = Names::getValidFunctionName(*wasm, funcName);
      getName();
    }
    return refToIndexName;
  }

  Name getIndexToRefName() {
    assert(wasm);
    if (!indexToRefName) {
      std::string funcName = "index_to_" + type.getHeapType().toString();
      indexToRefName = Names::getValidFunctionName(*wasm, funcName);
      getName();
    }
    return indexToRefName;
  }

  void addRefToIndexFunction() {
    // (func $<t>_to_index (param $ref <t>) (result (ref null (shared i31)))
    //   (local $idx i32)
    //   (if (result (ref null (shared i31)))
    //     (ref.is_null (local.get $ref))
    //     (then
    //       (ref.null (shared none))
    //     )
    //     (else
    //       (if (result (ref (shared i31)))
    //         (i32.ge_s
    //           (local.tee $idx
    //             (table.grow $<table> (local.get $ref) (i32.const 1))
    //           )
    //           (i32.const 0)
    //         )
    //         (then
    //           (ref.i31_shared (local.get $idx))
    //         )
    //         (else
    //           (unreachable)
    //         )
    //       )
    //     )
    //   )
    // )
    Builder builder(*wasm);

    Type sharedI31Nullable = Type(HeapTypes::i31.getBasic(Shared), Nullable);
    Type sharedI31NonNull = Type(HeapTypes::i31.getBasic(Shared), NonNullable);
    auto* isNull = builder.makeRefIsNull(builder.makeLocalGet(0, type));
    auto* retNull = builder.makeRefNull(HeapTypes::none.getBasic(Shared));
    auto* grow = builder.makeTableGrow(getName(),
                                       builder.makeLocalGet(0, type),
                                       builder.makeConst(Literal(int32_t(1))));
    auto* tee = builder.makeLocalTee(1, grow, Type::i32);
    auto* geZero =
      builder.makeBinary(GeSInt32, tee, builder.makeConst(Literal(int32_t(0))));
    auto* retIndex =
      builder.makeRefI31(builder.makeLocalGet(1, Type::i32), Shared);
    auto* checkGrow = builder.makeIf(
      geZero, retIndex, builder.makeUnreachable(), sharedI31NonNull);

    auto* body = builder.makeIf(isNull, retNull, checkGrow, sharedI31Nullable);
    auto func = Builder::makeFunction(
      refToIndexName, Signature(type, sharedI31Nullable), {Type::i32}, body);
    func->hasExplicitName = true;
    wasm->addFunction(std::move(func));
  }

  void addIndexToRefFunction() {
    // (func $index_to_<t> (param $idx (ref null (shared i31))) (result <t>)
    //   (if (result <type>)
    //     (ref.is_null (local.get $idx))
    //     (then
    //       (ref.null <bottom>)
    //     )
    //     (else
    //       (table.get $<table> (i31.get_u (local.get $idx)))
    //     )
    //   )
    // )
    Builder builder(*wasm);

    Type sharedI31Nullable = Type(HeapTypes::i31.getBasic(Shared), Nullable);
    auto* isNull =
      builder.makeRefIsNull(builder.makeLocalGet(0, sharedI31Nullable));
    auto* retNull = builder.makeRefNull(type.getHeapType().getBottom());
    auto* getRef = builder.makeTableGet(
      getName(),
      builder.makeI31Get(builder.makeLocalGet(0, sharedI31Nullable), false),
      type);

    auto* body = builder.makeIf(isNull, retNull, getRef, type);
    auto func = Builder::makeFunction(
      indexToRefName, Signature(sharedI31Nullable, type), {}, body);
    func->hasExplicitName = true;
    wasm->addFunction(std::move(func));
  }

  // Returns true if the table was added. (If it is never used, it will not be
  // added.)
  bool maybeAdd(Address initial, Address max) {
    assert(wasm);
    if (!name) {
      return false;
    }
    Table* table = wasm->addTable(Builder::makeTable(name));
    table->type = type;
    table->initial = initial;
    table->max = max;
    if (refToIndexName) {
      addRefToIndexFunction();
    }
    if (indexToRefName) {
      addIndexToRefFunction();
    }
    return true;
  }

  bool isTableType(Type t) const {
    return t.isRef() && Type::isSubType(t, type);
  }

  bool hasTableType(Type t) const {
    if (t.isTuple()) {
      for (Type elem : t) {
        if (hasTableType(elem)) {
          return true;
        }
      }
      return false;
    }
    return isTableType(t);
  }

  bool funcHasTableType(Function* func) const {
    Signature sig = func->type.getHeapType().getSignature();
    return hasTableType(sig.params) || hasTableType(sig.results);
  }

  Expression* convertToRef(Expression* arg, Type origType) {
    if (!isTableType(origType)) {
      return arg;
    }
    Builder builder(*wasm);
    Expression* res = builder.makeCall(getIndexToRefName(), {arg}, type);
    if (origType != type) {
      res = builder.makeRefCast(res, origType);
    }
    return res;
  }

  Expression* convertToIndex(Expression* arg, Type origType, Type targetType) {
    if (!isTableType(origType)) {
      return arg;
    }
    Builder builder(*wasm);
    Type sharedI31Nullable = Type(HeapTypes::i31.getBasic(Shared), Nullable);
    Expression* res =
      builder.makeCall(getRefToIndexName(), {arg}, sharedI31Nullable);
    if (targetType.isNonNullable()) {
      res = builder.makeRefAs(RefAsNonNull, res);
    }
    return res;
  }
};

struct MakeSharedObjects
  : WalkerPass<PostWalker<MakeSharedObjects,
                          UnifiedExpressionVisitor<MakeSharedObjects>>> {
  Type funcref = Type(HeapTypes::func, Nullable);
  Type externref = Type(HeapTypes::ext, Nullable);

  LazyTable funcTable{"funcs", funcref};
  LazyTable externTable{"externs", externref};
  std::vector<Name> funcs;
  std::unordered_map<Name, Index> funcIndices;
  Name anyToExternName;
  Name externToAnyName;

  Name getAnyToExternName() {
    if (!anyToExternName) {
      anyToExternName =
        Names::getValidFunctionName(*getModule(), "any_to_extern");
    }
    return anyToExternName;
  }

  Name getExternToAnyName() {
    if (!externToAnyName) {
      externToAnyName =
        Names::getValidFunctionName(*getModule(), "extern_to_any");
    }
    return externToAnyName;
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
    if (type == HeapType::ext || type == HeapType::string) {
      return HeapTypes::i31.getBasic(Shared);
    }
    if (type == HeapType::noext) {
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

  Type getBoundaryType(Type origType, Type rewrittenType) {
    Signature origSig = origType.getHeapType().getSignature();
    Signature rewrittenSig = rewrittenType.getHeapType().getSignature();

    std::vector<Type> params;
    Index i = 0;
    for (Type param : origSig.params) {
      if (externTable.isTableType(param)) {
        params.push_back(param);
      } else {
        params.push_back(rewrittenSig.params[i]);
      }
      ++i;
    }

    std::vector<Type> results;
    Index j = 0;
    for (Type result : origSig.results) {
      if (externTable.isTableType(result)) {
        results.push_back(result);
      } else {
        results.push_back(rewrittenSig.results[j]);
      }
      ++j;
    }

    return Type(Signature(Type(params), Type(results)),
                NonNullable,
                origType.getExactness());
  }

  void wrapImport(Function* func, Type origType) {
    // Create a new imported function with the boundary type. The original
    // function (which has lowered param and result types) is no longer an
    // import and is given a body that calls the new import and converts the
    // externrefs to and from indices.
    Builder builder(*getModule());
    Name origName = func->name;
    Name importName = Names::getValidFunctionName(
      *getModule(), origName.toString() + "$import");

    Type boundaryType = getBoundaryType(origType, func->type);

    auto importFunc = std::make_unique<Function>();
    importFunc->name = importName;
    importFunc->module = func->module;
    importFunc->base = func->base;
    importFunc->type = boundaryType;
    importFunc->hasExplicitName = true;

    func->module = Name();
    func->base = Name();
    func->type = Type(func->type.getHeapType(), NonNullable, Exact);

    // Convert indices passed as params to externrefs.
    Signature boundarySig = boundaryType.getHeapType().getSignature();
    std::vector<Expression*> callArgs;
    Index i = 0;
    for (Type param : boundarySig.params) {
      Type localType = func->getParams()[i];
      Expression* get = builder.makeLocalGet(i, localType);
      callArgs.push_back(externTable.convertToRef(get, param));
      ++i;
    }

    Type extResults = boundarySig.results;
    auto* call = builder.makeCall(importName, callArgs, extResults);

    // Convert externrefs received as results to indices.
    if (!externTable.hasTableType(extResults)) {
      func->body = call;
    } else if (extResults.isSingle()) {
      Type targetType = func->getResults();
      func->body = externTable.convertToIndex(call, extResults, targetType);
    } else {
      Index scratch = Builder::addVar(func, extResults);
      auto* set = builder.makeLocalSet(scratch, call);
      std::vector<Expression*> tupleElems;
      Index j = 0;
      for (Type t : extResults) {
        auto* extract = builder.makeTupleExtract(
          builder.makeLocalGet(scratch, extResults), j);
        tupleElems.push_back(
          externTable.convertToIndex(extract, t, func->getResults()[j]));
        ++j;
      }
      auto* tupleMake = builder.makeTupleMake(tupleElems);
      func->body = builder.makeBlock({set, tupleMake});
    }

    getModule()->addFunction(std::move(importFunc));
  }

  Name wrapExport(Export* ex, Type origType) {
    // Wrap the exported function with a new function that calls the original
    // exported function, converting externref params into indices and index
    // results into externrefs.
    Builder builder(*getModule());
    auto* internalFunc = getModule()->getFunction(*ex->getInternalName());
    Name origName = internalFunc->name;
    Name exportWrapperName = Names::getValidFunctionName(
      *getModule(), origName.toString() + "$export");

    Type boundaryType = getBoundaryType(origType, internalFunc->type);

    auto exportWrapper = std::make_unique<Function>();
    exportWrapper->name = exportWrapperName;
    exportWrapper->type = Type(boundaryType.getHeapType(), NonNullable, Exact);
    exportWrapper->hasExplicitName = true;

    // Forward params, converting externrefs to indices.
    Signature boundarySig = boundaryType.getHeapType().getSignature();
    std::vector<Expression*> callArgs;
    Index i = 0;
    for (Type param : boundarySig.params) {
      Type localType = exportWrapper->getParams()[i];
      Expression* get = builder.makeLocalGet(i, localType);
      Type targetType = internalFunc->getParams()[i];
      callArgs.push_back(externTable.convertToIndex(get, param, targetType));
      ++i;
    }

    Type internalResults = internalFunc->getResults();
    auto* call = builder.makeCall(origName, callArgs, internalResults);

    // Forward results, converting indices to externrefs.
    Type extResults = boundarySig.results;
    if (!externTable.hasTableType(extResults)) {
      exportWrapper->body = call;
    } else if (extResults.isSingle()) {
      exportWrapper->body = externTable.convertToRef(call, extResults);
    } else {
      Index scratch = Builder::addVar(exportWrapper.get(), internalResults);
      auto* set = builder.makeLocalSet(scratch, call);
      std::vector<Expression*> tupleElems;
      Index j = 0;
      for (Type t : extResults) {
        auto* extract = builder.makeTupleExtract(
          builder.makeLocalGet(scratch, internalResults), j);
        tupleElems.push_back(externTable.convertToRef(extract, t));
        ++j;
      }
      auto* tupleMake = builder.makeTupleMake(tupleElems);
      exportWrapper->body = builder.makeBlock({set, tupleMake});
    }

    getModule()->addFunction(std::move(exportWrapper));
    ex->setInternalName(exportWrapperName);
    return exportWrapperName;
  }

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
      builder.makeCallIndirect(funcTable.getName(),
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
    curr->table = funcTable.getName();
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
      updateType(curr->castType);
      return;
    }
    Builder builder(*getModule());
    if (curr->ref->type.isNonNullable()) {
      // (ref.test castType (table.get $t (i31.get_u ref)))
      curr->ref = builder.makeTableGet(
        funcTable.getName(), builder.makeI31Get(curr->ref, false), funcref);
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
      funcTable.getName(),
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
      updateType(curr->type);
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
    auto* tableGet = builder.makeTableGet(funcTable.getName(), i31get, funcref);
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

  void visitRefAs(RefAs* curr) {
    if (curr->type == Type::unreachable) {
      return;
    }
    if (curr->op == AnyConvertExtern) {
      Type extType = Type(HeapTypes::ext, curr->type.getNullability());
      Expression* ext = externTable.convertToRef(curr->value, extType);
      Builder builder(*getModule());
      Type sharedAnyNullable = Type(HeapTypes::any.getBasic(Shared), Nullable);
      Expression* call =
        builder.makeCall(getExternToAnyName(), {ext}, sharedAnyNullable);
      if (curr->type.isNonNullable()) {
        call = builder.makeRefAs(RefAsNonNull, call);
      }
      replaceCurrent(call);
    } else if (curr->op == ExternConvertAny) {
      Builder builder(*getModule());
      Expression* call =
        builder.makeCall(getAnyToExternName(), {curr->value}, externref);
      Type extType = Type(HeapTypes::ext, curr->type.getNullability());
      Type targetType = updatedType(curr->type);
      replaceCurrent(externTable.convertToIndex(call, extType, targetType));
    }
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
    funcTable.wasm = wasm;
    externTable.wasm = wasm;
    wasm->features.setSharedEverything();
    WalkerPass::doWalkModule(wasm);
  }

  struct ImportToWrap {
    Function* func;
    Type origType;
  };

  struct ExportToWrap {
    Export* ex;
    Type origType;
  };

  void visitModule(Module* wasm) {
    std::vector<ImportToWrap> importsToWrap;
    for (auto& func : wasm->functions) {
      if (func->imported() && externTable.funcHasTableType(func.get())) {
        importsToWrap.push_back({func.get(), func->type});
      }
    }

    std::vector<ExportToWrap> exportsToWrap;
    for (auto& ex : wasm->exports) {
      if (ex->kind == ExternalKind::Function) {
        if (auto* name = ex->getInternalName()) {
          auto* func = wasm->getFunction(*name);
          if (externTable.funcHasTableType(func)) {
            exportsToWrap.push_back(ExportToWrap{ex.get(), func->type});
          }
        }
      }
    }

    rewriteTypes();

    for (auto& info : importsToWrap) {
      wrapImport(info.func, info.origType);
    }
    std::unordered_map<Function*, Name> wrappedExports;
    for (auto& info : exportsToWrap) {
      auto* internalFunc = wasm->getFunction(*info.ex->getInternalName());
      auto [it, inserted] = wrappedExports.insert({internalFunc, Name()});
      if (inserted) {
        it->second = wrapExport(info.ex, info.origType);
      } else {
        info.ex->setInternalName(it->second);
      }
    }

    addFunctionTable();
    addExternTable();
    ReFinalize().run(getPassRunner(), wasm);
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
      } else {
        builder[i].setShared(Shared);
      }
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
    if (!funcTable.maybeAdd(funcs.size(), funcs.size())) {
      return;
    }
    if (funcs.empty()) {
      return;
    }
    Builder builder(*getModule());
    Name segName = Names::getValidElementSegmentName(*getModule(), "funcs");
    auto* offset = builder.makeConst(Literal(int32_t(0)));
    auto* segment = getModule()->addElementSegment(
      Builder::makeElementSegment(segName, funcTable.getName(), offset));
    segment->type = funcTable.type;

    segment->data.reserve(funcs.size());
    for (auto func : funcs) {
      segment->data.push_back(
        builder.makeRefFunc(func, getModule()->getFunction(func)->type));
    }
  }

  void addAnyToExternFunction() {
    Type sharedAnyNullable = Type(HeapTypes::any.getBasic(Shared), Nullable);
    Type externrefNullable = Type(HeapTypes::ext, Nullable);
    auto importFunc = Builder::makeFunction(
      anyToExternName, Signature(sharedAnyNullable, externrefNullable), {});
    importFunc->module = "env";
    importFunc->base = "any_to_extern";
    importFunc->hasExplicitName = true;
    getModule()->addFunction(std::move(importFunc));
  }

  void addExternToAnyFunction() {
    Type externrefNullable = Type(HeapTypes::ext, Nullable);
    Type sharedAnyNullable = Type(HeapTypes::any.getBasic(Shared), Nullable);
    auto importFunc = Builder::makeFunction(
      externToAnyName, Signature(externrefNullable, sharedAnyNullable), {});
    importFunc->module = "env";
    importFunc->base = "extern_to_any";
    importFunc->hasExplicitName = true;
    getModule()->addFunction(std::move(importFunc));
  }

  void addExternTable() {
    externTable.maybeAdd(0, Table::kUnlimitedSize);
    if (anyToExternName) {
      addAnyToExternFunction();
    }
    if (externToAnyName) {
      addExternToAnyFunction();
    }
  }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<MakeSharedObjects>();
  }
};

Pass* createMakeSharedObjectsPass() { return new MakeSharedObjects(); }

} // namespace wasm
