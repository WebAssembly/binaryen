/*
 * Copyright 2023 WebAssembly Community Group participants
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

#ifndef parser_context_h
#define parser_context_h

#include "common.h"
#include "input.h"
#include "ir/names.h"
#include "support/name.h"
#include "support/result.h"
#include "wasm-builder.h"
#include "wasm-ir-builder.h"
#include "wasm.h"

namespace wasm::WATParser {

using IndexMap = std::unordered_map<Name, Index>;

inline std::vector<Type> getUnnamedTypes(const std::vector<NameType>& named) {
  std::vector<Type> types;
  types.reserve(named.size());
  for (auto& t : named) {
    types.push_back(t.type);
  }
  return types;
}

struct Limits {
  uint64_t initial;
  uint64_t max;
};

struct MemType {
  Type type;
  Limits limits;
  bool shared;
};

struct Memarg {
  uint64_t offset;
  uint32_t align;
};

// The location, possible name, and index in the respective module index space
// of a module-level definition in the input.
struct DefPos {
  Name name;
  Index pos;
  Index index;
};

struct GlobalType {
  Mutability mutability;
  Type type;
};

// A signature type and parameter names (possibly empty), used for parsing
// function types.
struct TypeUse {
  HeapType type;
  std::vector<Name> names;
};

struct NullTypeParserCtx {
  using IndexT = Ok;
  using HeapTypeT = Ok;
  using TypeT = Ok;
  using ParamsT = Ok;
  using ResultsT = size_t;
  using BlockTypeT = Ok;
  using SignatureT = Ok;
  using StorageT = Ok;
  using FieldT = Ok;
  using FieldsT = Ok;
  using StructT = Ok;
  using ArrayT = Ok;
  using LimitsT = Ok;
  using MemTypeT = Ok;
  using GlobalTypeT = Ok;
  using TypeUseT = Ok;
  using LocalsT = Ok;
  using DataStringT = Ok;

  HeapTypeT makeFunc() { return Ok{}; }
  HeapTypeT makeAny() { return Ok{}; }
  HeapTypeT makeExtern() { return Ok{}; }
  HeapTypeT makeEq() { return Ok{}; }
  HeapTypeT makeI31() { return Ok{}; }
  HeapTypeT makeStructType() { return Ok{}; }
  HeapTypeT makeArrayType() { return Ok{}; }

  TypeT makeI32() { return Ok{}; }
  TypeT makeI64() { return Ok{}; }
  TypeT makeF32() { return Ok{}; }
  TypeT makeF64() { return Ok{}; }
  TypeT makeV128() { return Ok{}; }

  TypeT makeRefType(HeapTypeT, Nullability) { return Ok{}; }

  ParamsT makeParams() { return Ok{}; }
  void appendParam(ParamsT&, Name, TypeT) {}

  // We have to count results because whether or not a block introduces a
  // typeuse that may implicitly define a type depends on how many results it
  // has.
  size_t makeResults() { return 0; }
  void appendResult(size_t& results, TypeT) { ++results; }
  size_t getResultsSize(size_t results) { return results; }

  SignatureT makeFuncType(ParamsT*, ResultsT*) { return Ok{}; }

  StorageT makeI8() { return Ok{}; }
  StorageT makeI16() { return Ok{}; }
  StorageT makeStorageType(TypeT) { return Ok{}; }

  FieldT makeFieldType(StorageT, Mutability) { return Ok{}; }

  FieldsT makeFields() { return Ok{}; }
  void appendField(FieldsT&, Name, FieldT) {}

  StructT makeStruct(FieldsT&) { return Ok{}; }

  std::optional<ArrayT> makeArray(FieldsT&) { return Ok{}; }

  GlobalTypeT makeGlobalType(Mutability, TypeT) { return Ok{}; }

  LocalsT makeLocals() { return Ok{}; }
  void appendLocal(LocalsT&, Name, TypeT) {}

  Result<Index> getTypeIndex(Name) { return 1; }
  Result<HeapTypeT> getHeapTypeFromIdx(Index) { return Ok{}; }

  DataStringT makeDataString() { return Ok{}; }
  void appendDataString(DataStringT&, std::string_view) {}

  MemTypeT makeMemType(Type, LimitsT, bool) { return Ok{}; }

  BlockTypeT getBlockTypeFromResult(size_t results) { return Ok{}; }

  Result<> getBlockTypeFromTypeUse(Index, TypeUseT) { return Ok{}; }
};

template<typename Ctx> struct TypeParserCtx {
  using IndexT = Index;
  using HeapTypeT = HeapType;
  using TypeT = Type;
  using ParamsT = std::vector<NameType>;
  using ResultsT = std::vector<Type>;
  using BlockTypeT = HeapType;
  using SignatureT = Signature;
  using StorageT = Field;
  using FieldT = Field;
  using FieldsT = std::pair<std::vector<Name>, std::vector<Field>>;
  using StructT = std::pair<std::vector<Name>, Struct>;
  using ArrayT = Array;
  using LimitsT = Ok;
  using MemTypeT = Ok;
  using LocalsT = std::vector<NameType>;
  using DataStringT = Ok;

  // Map heap type names to their indices.
  const IndexMap& typeIndices;

  TypeParserCtx(const IndexMap& typeIndices) : typeIndices(typeIndices) {}

  Ctx& self() { return *static_cast<Ctx*>(this); }

  HeapTypeT makeFunc() { return HeapType::func; }
  HeapTypeT makeAny() { return HeapType::any; }
  HeapTypeT makeExtern() { return HeapType::ext; }
  HeapTypeT makeEq() { return HeapType::eq; }
  HeapTypeT makeI31() { return HeapType::i31; }
  HeapTypeT makeStructType() { return HeapType::struct_; }
  HeapTypeT makeArrayType() { return HeapType::array; }

  TypeT makeI32() { return Type::i32; }
  TypeT makeI64() { return Type::i64; }
  TypeT makeF32() { return Type::f32; }
  TypeT makeF64() { return Type::f64; }
  TypeT makeV128() { return Type::v128; }

  TypeT makeRefType(HeapTypeT ht, Nullability nullability) {
    return Type(ht, nullability);
  }

  TypeT makeTupleType(const std::vector<Type> types) { return Tuple(types); }

  ParamsT makeParams() { return {}; }
  void appendParam(ParamsT& params, Name id, TypeT type) {
    params.push_back({id, type});
  }

  ResultsT makeResults() { return {}; }
  void appendResult(ResultsT& results, TypeT type) { results.push_back(type); }
  size_t getResultsSize(const ResultsT& results) { return results.size(); }

  SignatureT makeFuncType(ParamsT* params, ResultsT* results) {
    std::vector<Type> empty;
    const auto& paramTypes = params ? getUnnamedTypes(*params) : empty;
    const auto& resultTypes = results ? *results : empty;
    return Signature(self().makeTupleType(paramTypes),
                     self().makeTupleType(resultTypes));
  }

  StorageT makeI8() { return Field(Field::i8, Immutable); }
  StorageT makeI16() { return Field(Field::i16, Immutable); }
  StorageT makeStorageType(TypeT type) { return Field(type, Immutable); }

  FieldT makeFieldType(FieldT field, Mutability mutability) {
    if (field.packedType == Field::not_packed) {
      return Field(field.type, mutability);
    }
    return Field(field.packedType, mutability);
  }

  FieldsT makeFields() { return {}; }
  void appendField(FieldsT& fields, Name name, FieldT field) {
    fields.first.push_back(name);
    fields.second.push_back(field);
  }

  StructT makeStruct(FieldsT& fields) {
    return {std::move(fields.first), Struct(std::move(fields.second))};
  }

  std::optional<ArrayT> makeArray(FieldsT& fields) {
    if (fields.second.size() == 1) {
      return Array(fields.second[0]);
    }
    return {};
  }

  LocalsT makeLocals() { return {}; }
  void appendLocal(LocalsT& locals, Name id, TypeT type) {
    locals.push_back({id, type});
  }

  Result<Index> getTypeIndex(Name id) {
    auto it = typeIndices.find(id);
    if (it == typeIndices.end()) {
      return self().in.err("unknown type identifier");
    }
    return it->second;
  }

  DataStringT makeDataString() { return Ok{}; }
  void appendDataString(DataStringT&, std::string_view) {}

  LimitsT makeLimits(uint64_t, std::optional<uint64_t>) { return Ok{}; }
  LimitsT getLimitsFromData(DataStringT) { return Ok{}; }

  MemTypeT makeMemType(Type, LimitsT, bool) { return Ok{}; }

  HeapType getBlockTypeFromResult(const std::vector<Type> results) {
    assert(results.size() == 1);
    return HeapType(Signature(Type::none, results[0]));
  }
};

struct NullInstrParserCtx {
  using ExprT = Ok;

  using FieldIdxT = Ok;
  using LocalIdxT = Ok;
  using GlobalIdxT = Ok;
  using MemoryIdxT = Ok;
  using DataIdxT = Ok;

  using MemargT = Ok;

  Result<> makeExpr() { return Ok{}; }

  template<typename HeapTypeT> FieldIdxT getFieldFromIdx(HeapTypeT, uint32_t) {
    return Ok{};
  }
  template<typename HeapTypeT> FieldIdxT getFieldFromName(HeapTypeT, Name) {
    return Ok{};
  }
  LocalIdxT getLocalFromIdx(uint32_t) { return Ok{}; }
  LocalIdxT getLocalFromName(Name) { return Ok{}; }
  GlobalIdxT getGlobalFromIdx(uint32_t) { return Ok{}; }
  GlobalIdxT getGlobalFromName(Name) { return Ok{}; }
  MemoryIdxT getMemoryFromIdx(uint32_t) { return Ok{}; }
  MemoryIdxT getMemoryFromName(Name) { return Ok{}; }
  DataIdxT getDataFromIdx(uint32_t) { return Ok{}; }
  DataIdxT getDataFromName(Name) { return Ok{}; }

  MemargT getMemarg(uint64_t, uint32_t) { return Ok{}; }

  template<typename BlockTypeT>
  Result<> makeBlock(Index, std::optional<Name>, BlockTypeT) {
    return Ok{};
  }
  template<typename BlockTypeT>
  Result<> makeIf(Index, std::optional<Name>, BlockTypeT) {
    return Ok{};
  }
  Result<> visitElse() { return Ok{}; }
  template<typename BlockTypeT>
  Result<> makeLoop(Index, std::optional<Name>, BlockTypeT) {
    return Ok{};
  }
  Result<> visitEnd() { return Ok{}; }

  Result<> makeUnreachable(Index) { return Ok{}; }
  Result<> makeNop(Index) { return Ok{}; }
  Result<> makeBinary(Index, BinaryOp) { return Ok{}; }
  Result<> makeUnary(Index, UnaryOp) { return Ok{}; }
  template<typename ResultsT> Result<> makeSelect(Index, ResultsT*) {
    return Ok{};
  }
  Result<> makeDrop(Index) { return Ok{}; }
  Result<> makeMemorySize(Index, MemoryIdxT*) { return Ok{}; }
  Result<> makeMemoryGrow(Index, MemoryIdxT*) { return Ok{}; }
  Result<> makeLocalGet(Index, LocalIdxT) { return Ok{}; }
  Result<> makeLocalTee(Index, LocalIdxT) { return Ok{}; }
  Result<> makeLocalSet(Index, LocalIdxT) { return Ok{}; }
  Result<> makeGlobalGet(Index, GlobalIdxT) { return Ok{}; }
  Result<> makeGlobalSet(Index, GlobalIdxT) { return Ok{}; }

  Result<> makeI32Const(Index, uint32_t) { return Ok{}; }
  Result<> makeI64Const(Index, uint64_t) { return Ok{}; }
  Result<> makeF32Const(Index, float) { return Ok{}; }
  Result<> makeF64Const(Index, double) { return Ok{}; }
  Result<> makeLoad(Index, Type, bool, int, bool, MemoryIdxT*, MemargT) {
    return Ok{};
  }
  Result<> makeStore(Index, Type, int, bool, MemoryIdxT*, MemargT) {
    return Ok{};
  }
  Result<> makeAtomicRMW(Index, AtomicRMWOp, Type, int, MemoryIdxT*, MemargT) {
    return Ok{};
  }
  Result<> makeAtomicCmpxchg(Index, Type, int, MemoryIdxT*, MemargT) {
    return Ok{};
  }
  Result<> makeAtomicWait(Index, Type, MemoryIdxT*, MemargT) { return Ok{}; }
  Result<> makeAtomicNotify(Index, MemoryIdxT*, MemargT) { return Ok{}; }
  Result<> makeAtomicFence(Index) { return Ok{}; }
  Result<> makeSIMDExtract(Index, SIMDExtractOp, uint8_t) { return Ok{}; }
  Result<> makeSIMDReplace(Index, SIMDReplaceOp, uint8_t) { return Ok{}; }
  Result<> makeSIMDShuffle(Index, const std::array<uint8_t, 16>&) {
    return Ok{};
  }
  Result<> makeSIMDTernary(Index, SIMDTernaryOp) { return Ok{}; }
  Result<> makeSIMDShift(Index, SIMDShiftOp) { return Ok{}; }
  Result<> makeSIMDLoad(Index, SIMDLoadOp, MemoryIdxT*, MemargT) {
    return Ok{};
  }
  Result<> makeSIMDLoadStoreLane(
    Index, SIMDLoadStoreLaneOp, MemoryIdxT*, MemargT, uint8_t) {
    return Ok{};
  }
  Result<> makeMemoryInit(Index, MemoryIdxT*, DataIdxT) { return Ok{}; }
  Result<> makeDataDrop(Index, DataIdxT) { return Ok{}; }

  Result<> makeMemoryCopy(Index, MemoryIdxT*, MemoryIdxT*) { return Ok{}; }
  Result<> makeMemoryFill(Index, MemoryIdxT*) { return Ok{}; }

  Result<> makeReturn(Index) { return Ok{}; }
  template<typename HeapTypeT> Result<> makeRefNull(Index, HeapTypeT) {
    return Ok{};
  }
  Result<> makeRefIsNull(Index) { return Ok{}; }

  Result<> makeRefEq(Index) { return Ok{}; }

  Result<> makeRefI31(Index) { return Ok{}; }
  Result<> makeI31Get(Index, bool) { return Ok{}; }

  template<typename HeapTypeT> Result<> makeStructNew(Index, HeapTypeT) {
    return Ok{};
  }
  template<typename HeapTypeT> Result<> makeStructNewDefault(Index, HeapTypeT) {
    return Ok{};
  }
  template<typename HeapTypeT>
  Result<> makeStructGet(Index, HeapTypeT, FieldIdxT, bool) {
    return Ok{};
  }
  template<typename HeapTypeT>
  Result<> makeStructSet(Index, HeapTypeT, FieldIdxT) {
    return Ok{};
  }
  template<typename HeapTypeT> Result<> makeArrayNew(Index, HeapTypeT) {
    return Ok{};
  }
  template<typename HeapTypeT> Result<> makeArrayNewDefault(Index, HeapTypeT) {
    return Ok{};
  }
  template<typename HeapTypeT>
  Result<> makeArrayNewData(Index, HeapTypeT, DataIdxT) {
    return Ok{};
  }
  template<typename HeapTypeT>
  Result<> makeArrayNewElem(Index, HeapTypeT, DataIdxT) {
    return Ok{};
  }
  template<typename HeapTypeT> Result<> makeArrayGet(Index, HeapTypeT, bool) {
    return Ok{};
  }
  template<typename HeapTypeT> Result<> makeArraySet(Index, HeapTypeT) {
    return Ok{};
  }
  Result<> makeArrayLen(Index) { return Ok{}; }
  template<typename HeapTypeT>
  Result<> makeArrayCopy(Index, HeapTypeT, HeapTypeT) {
    return Ok{};
  }
  template<typename HeapTypeT> Result<> makeArrayFill(Index, HeapTypeT) {
    return Ok{};
  }
};

// Phase 1: Parse definition spans for top-level module elements and determine
// their indices and names.
struct ParseDeclsCtx : NullTypeParserCtx, NullInstrParserCtx {
  using DataStringT = std::vector<char>;
  using LimitsT = Limits;
  using MemTypeT = MemType;

  ParseInput in;

  // At this stage we only look at types to find implicit type definitions,
  // which are inserted directly into the context. We cannot materialize or
  // validate any types because we don't know what types exist yet.
  //
  // Declared module elements are inserted into the module, but their bodies are
  // not filled out until later parsing phases.
  Module& wasm;

  // The module element definitions we are parsing in this phase.
  std::vector<DefPos> typeDefs;
  std::vector<DefPos> subtypeDefs;
  std::vector<DefPos> funcDefs;
  std::vector<DefPos> memoryDefs;
  std::vector<DefPos> globalDefs;
  std::vector<DefPos> dataDefs;

  // Positions of typeuses that might implicitly define new types.
  std::vector<Index> implicitTypeDefs;

  // Counters used for generating names for module elements.
  int funcCounter = 0;
  int memoryCounter = 0;
  int globalCounter = 0;
  int dataCounter = 0;

  // Used to verify that all imports come before all non-imports.
  bool hasNonImport = false;

  ParseDeclsCtx(std::string_view in, Module& wasm) : in(in), wasm(wasm) {}

  void addFuncType(SignatureT) {}
  void addStructType(StructT) {}
  void addArrayType(ArrayT) {}
  void setOpen() {}
  Result<> addSubtype(Index) { return Ok{}; }
  void finishSubtype(Name name, Index pos) {
    subtypeDefs.push_back({name, pos, Index(subtypeDefs.size())});
  }
  size_t getRecGroupStartIndex() { return 0; }
  void addRecGroup(Index, size_t) {}
  void finishDeftype(Index pos) {
    typeDefs.push_back({{}, pos, Index(typeDefs.size())});
  }

  std::vector<char> makeDataString() { return {}; }
  void appendDataString(std::vector<char>& data, std::string_view str) {
    data.insert(data.end(), str.begin(), str.end());
  }

  Limits makeLimits(uint64_t n, std::optional<uint64_t> m) {
    return m ? Limits{n, *m} : Limits{n, Memory::kUnlimitedSize};
  }
  Limits getLimitsFromData(const std::vector<char>& data) {
    uint64_t size = (data.size() + Memory::kPageSize - 1) / Memory::kPageSize;
    return {size, size};
  }

  MemType makeMemType(Type type, Limits limits, bool shared) {
    return {type, limits, shared};
  }

  Result<TypeUseT>
  makeTypeUse(Index pos, std::optional<HeapTypeT> type, ParamsT*, ResultsT*) {
    if (!type) {
      implicitTypeDefs.push_back(pos);
    }
    return Ok{};
  }

  Result<Function*> addFuncDecl(Index pos, Name name, ImportNames* importNames);
  Result<> addFunc(Name name,
                   const std::vector<Name>& exports,
                   ImportNames* import,
                   TypeUseT type,
                   std::optional<LocalsT>,
                   Index pos);

  Result<Memory*>
  addMemoryDecl(Index pos, Name name, ImportNames* importNames, MemType type);

  Result<> addMemory(Name name,
                     const std::vector<Name>& exports,
                     ImportNames* import,
                     MemType type,
                     Index pos);

  Result<> addImplicitData(DataStringT&& data);

  Result<Global*> addGlobalDecl(Index pos, Name name, ImportNames* importNames);

  Result<> addGlobal(Name name,
                     const std::vector<Name>& exports,
                     ImportNames* import,
                     GlobalTypeT,
                     std::optional<ExprT>,
                     Index pos);

  Result<> addData(Name name,
                   MemoryIdxT*,
                   std::optional<ExprT>,
                   std::vector<char>&& data,
                   Index pos);
};

// Phase 2: Parse type definitions into a TypeBuilder.
struct ParseTypeDefsCtx : TypeParserCtx<ParseTypeDefsCtx> {
  ParseInput in;

  // We update slots in this builder as we parse type definitions.
  TypeBuilder& builder;

  // Parse the names of types and fields as we go.
  std::vector<TypeNames> names;

  // The index of the subtype definition we are parsing.
  Index index = 0;

  ParseTypeDefsCtx(std::string_view in,
                   TypeBuilder& builder,
                   const IndexMap& typeIndices)
    : TypeParserCtx<ParseTypeDefsCtx>(typeIndices), in(in), builder(builder),
      names(builder.size()) {}

  TypeT makeRefType(HeapTypeT ht, Nullability nullability) {
    return builder.getTempRefType(ht, nullability);
  }

  TypeT makeTupleType(const std::vector<Type> types) {
    return builder.getTempTupleType(types);
  }

  Result<HeapTypeT> getHeapTypeFromIdx(Index idx) {
    if (idx >= builder.size()) {
      return in.err("type index out of bounds");
    }
    return builder[idx];
  }

  void addFuncType(SignatureT& type) { builder[index] = type; }

  void addStructType(StructT& type) {
    auto& [fieldNames, str] = type;
    builder[index] = str;
    for (Index i = 0; i < fieldNames.size(); ++i) {
      if (auto name = fieldNames[i]; name.is()) {
        names[index].fieldNames[i] = name;
      }
    }
  }

  void addArrayType(ArrayT& type) { builder[index] = type; }

  void setOpen() { builder[index].setOpen(); }

  Result<> addSubtype(Index super) {
    if (super >= builder.size()) {
      return in.err("supertype index out of bounds");
    }
    builder[index].subTypeOf(builder[super]);
    return Ok{};
  }

  void finishSubtype(Name name, Index pos) { names[index++].name = name; }

  size_t getRecGroupStartIndex() { return index; }

  void addRecGroup(Index start, size_t len) {
    builder.createRecGroup(start, len);
  }

  void finishDeftype(Index) {}
};

// Phase 3: Parse type uses to find implicitly defined types.
struct ParseImplicitTypeDefsCtx : TypeParserCtx<ParseImplicitTypeDefsCtx> {
  using TypeUseT = Ok;

  ParseInput in;

  // Types parsed so far.
  std::vector<HeapType>& types;

  // Map typeuse positions without an explicit type to the correct type.
  std::unordered_map<Index, HeapType>& implicitTypes;

  // Map signatures to the first defined heap type they match.
  std::unordered_map<Signature, HeapType> sigTypes;

  ParseImplicitTypeDefsCtx(std::string_view in,
                           std::vector<HeapType>& types,
                           std::unordered_map<Index, HeapType>& implicitTypes,
                           const IndexMap& typeIndices)
    : TypeParserCtx<ParseImplicitTypeDefsCtx>(typeIndices), in(in),
      types(types), implicitTypes(implicitTypes) {
    for (auto type : types) {
      if (type.isSignature() && type.getRecGroup().size() == 1) {
        sigTypes.insert({type.getSignature(), type});
      }
    }
  }

  Result<HeapTypeT> getHeapTypeFromIdx(Index idx) {
    if (idx >= types.size()) {
      return in.err("type index out of bounds");
    }
    return types[idx];
  }

  Result<TypeUseT> makeTypeUse(Index pos,
                               std::optional<HeapTypeT>,
                               ParamsT* params,
                               ResultsT* results) {
    std::vector<Type> paramTypes;
    if (params) {
      paramTypes = getUnnamedTypes(*params);
    }

    std::vector<Type> resultTypes;
    if (results) {
      resultTypes = *results;
    }

    auto sig = Signature(Type(paramTypes), Type(resultTypes));
    auto [it, inserted] = sigTypes.insert({sig, HeapType::func});
    if (inserted) {
      auto type = HeapType(sig);
      it->second = type;
      types.push_back(type);
    }
    implicitTypes.insert({pos, it->second});

    return Ok{};
  }
};

// Phase 4: Parse and set the types of module elements.
struct ParseModuleTypesCtx : TypeParserCtx<ParseModuleTypesCtx>,
                             NullInstrParserCtx {
  // In this phase we have constructed all the types, so we can materialize and
  // validate them when they are used.

  using GlobalTypeT = GlobalType;
  using TypeUseT = TypeUse;

  ParseInput in;

  Module& wasm;

  const std::vector<HeapType>& types;
  const std::unordered_map<Index, HeapType>& implicitTypes;

  // The index of the current type.
  Index index = 0;

  ParseModuleTypesCtx(std::string_view in,
                      Module& wasm,
                      const std::vector<HeapType>& types,
                      const std::unordered_map<Index, HeapType>& implicitTypes,
                      const IndexMap& typeIndices)
    : TypeParserCtx<ParseModuleTypesCtx>(typeIndices), in(in), wasm(wasm),
      types(types), implicitTypes(implicitTypes) {}

  Result<HeapTypeT> getHeapTypeFromIdx(Index idx) {
    if (idx >= types.size()) {
      return in.err("type index out of bounds");
    }
    return types[idx];
  }

  Result<TypeUseT> makeTypeUse(Index pos,
                               std::optional<HeapTypeT> type,
                               ParamsT* params,
                               ResultsT* results) {
    std::vector<Name> ids;
    if (params) {
      ids.reserve(params->size());
      for (auto& p : *params) {
        ids.push_back(p.name);
      }
    }

    if (type) {
      return TypeUse{*type, ids};
    }

    auto it = implicitTypes.find(pos);
    assert(it != implicitTypes.end());

    return TypeUse{it->second, ids};
  }

  Result<HeapType> getBlockTypeFromTypeUse(Index pos, TypeUse use) {
    assert(use.type.isSignature());
    if (use.type.getSignature().params != Type::none) {
      return in.err(pos, "block parameters not yet supported");
    }
    // TODO: Once we support block parameters, return an error here if any of
    // them are named.
    return use.type;
  }

  GlobalTypeT makeGlobalType(Mutability mutability, TypeT type) {
    return {mutability, type};
  }

  Result<> addFunc(Name name,
                   const std::vector<Name>&,
                   ImportNames*,
                   TypeUse type,
                   std::optional<LocalsT> locals,
                   Index pos) {
    auto& f = wasm.functions[index];
    if (!type.type.isSignature()) {
      return in.err(pos, "expected signature type");
    }
    f->type = type.type;
    for (Index i = 0; i < type.names.size(); ++i) {
      if (type.names[i].is()) {
        f->setLocalName(i, type.names[i]);
      }
    }
    if (locals) {
      for (auto& l : *locals) {
        Builder::addVar(f.get(), l.name, l.type);
      }
    }
    return Ok{};
  }

  Result<>
  addMemory(Name, const std::vector<Name>&, ImportNames*, MemTypeT, Index) {
    return Ok{};
  }

  Result<> addImplicitData(DataStringT&& data) { return Ok{}; }

  Result<> addGlobal(Name,
                     const std::vector<Name>&,
                     ImportNames*,
                     GlobalType type,
                     std::optional<ExprT>,
                     Index) {
    auto& g = wasm.globals[index];
    g->mutable_ = type.mutability;
    g->type = type.type;
    return Ok{};
  }
};

// Phase 5: Parse module element definitions, including instructions.
struct ParseDefsCtx : TypeParserCtx<ParseDefsCtx> {
  using GlobalTypeT = Ok;
  using TypeUseT = HeapType;

  using ExprT = Expression*;

  using FieldIdxT = Index;
  using LocalIdxT = Index;
  using GlobalIdxT = Name;
  using MemoryIdxT = Name;
  using DataIdxT = Name;

  using MemargT = Memarg;

  ParseInput in;

  Module& wasm;
  Builder builder;

  const std::vector<HeapType>& types;
  const std::unordered_map<Index, HeapType>& implicitTypes;

  // The index of the current module element.
  Index index = 0;

  // The current function being parsed, used to create scratch locals, type
  // local.get, etc.
  Function* func = nullptr;

  IRBuilder irBuilder;

  void setFunction(Function* func) {
    this->func = func;
    irBuilder.setFunction(func);
  }

  ParseDefsCtx(std::string_view in,
               Module& wasm,
               const std::vector<HeapType>& types,
               const std::unordered_map<Index, HeapType>& implicitTypes,
               const IndexMap& typeIndices)
    : TypeParserCtx(typeIndices), in(in), wasm(wasm), builder(wasm),
      types(types), implicitTypes(implicitTypes), irBuilder(wasm) {}

  template<typename T> Result<T> withLoc(Index pos, Result<T> res) {
    if (auto err = res.getErr()) {
      return in.err(pos, err->msg);
    }
    return res;
  }

  template<typename T> Result<T> withLoc(Result<T> res) {
    return withLoc(in.getPos(), res);
  }

  HeapType getBlockTypeFromResult(const std::vector<Type> results) {
    assert(results.size() == 1);
    return HeapType(Signature(Type::none, results[0]));
  }

  Result<HeapType> getBlockTypeFromTypeUse(Index pos, HeapType type) {
    return type;
  }

  GlobalTypeT makeGlobalType(Mutability, TypeT) { return Ok{}; }

  Result<HeapTypeT> getHeapTypeFromIdx(Index idx) {
    if (idx >= types.size()) {
      return in.err("type index out of bounds");
    }
    return types[idx];
  }

  Result<Index> getFieldFromIdx(HeapType type, uint32_t idx) {
    if (!type.isStruct()) {
      return in.err("expected struct type");
    }
    if (idx >= type.getStruct().fields.size()) {
      return in.err("struct index out of bounds");
    }
    return idx;
  }

  Result<Index> getFieldFromName(HeapType type, Name name) {
    // TODO: Field names
    return in.err("symbolic field names note yet supported");
  }

  Result<Index> getLocalFromIdx(uint32_t idx) {
    if (!func) {
      return in.err("cannot access locals outside of a function");
    }
    if (idx >= func->getNumLocals()) {
      return in.err("local index out of bounds");
    }
    return idx;
  }

  Result<Index> getLocalFromName(Name name) {
    if (!func) {
      return in.err("cannot access locals outside of a function");
    }
    if (!func->hasLocalIndex(name)) {
      return in.err("local $" + name.toString() + " does not exist");
    }
    return func->getLocalIndex(name);
  }

  Result<Name> getGlobalFromIdx(uint32_t idx) {
    if (idx >= wasm.globals.size()) {
      return in.err("global index out of bounds");
    }
    return wasm.globals[idx]->name;
  }

  Result<Name> getGlobalFromName(Name name) {
    if (!wasm.getGlobalOrNull(name)) {
      return in.err("global $" + name.toString() + " does not exist");
    }
    return name;
  }

  Result<Name> getMemoryFromIdx(uint32_t idx) {
    if (idx >= wasm.memories.size()) {
      return in.err("memory index out of bounds");
    }
    return wasm.memories[idx]->name;
  }

  Result<Name> getMemoryFromName(Name name) {
    if (!wasm.getMemoryOrNull(name)) {
      return in.err("memory $" + name.toString() + " does not exist");
    }
    return name;
  }

  Result<Name> getDataFromIdx(uint32_t idx) {
    if (idx >= wasm.dataSegments.size()) {
      return in.err("data index out of bounds");
    }
    return wasm.dataSegments[idx]->name;
  }

  Result<Name> getDataFromName(Name name) {
    if (!wasm.getDataSegmentOrNull(name)) {
      return in.err("data $" + name.toString() + " does not exist");
    }
    return name;
  }

  Result<TypeUseT> makeTypeUse(Index pos,
                               std::optional<HeapTypeT> type,
                               ParamsT* params,
                               ResultsT* results);
  Result<> addFunc(Name,
                   const std::vector<Name>&,
                   ImportNames*,
                   TypeUseT,
                   std::optional<LocalsT>,
                   Index pos);

  Result<> addGlobal(Name,
                     const std::vector<Name>&,
                     ImportNames*,
                     GlobalTypeT,
                     std::optional<ExprT> exp,
                     Index);
  Result<>
  addData(Name, Name* mem, std::optional<ExprT> offset, DataStringT, Index pos);
  Result<Index> addScratchLocal(Index pos, Type type) {
    if (!func) {
      return in.err(pos,
                    "scratch local required, but there is no function context");
    }
    Name name = Names::getValidLocalName(*func, "scratch");
    return Builder::addVar(func, name, type);
  }

  Result<Expression*> makeExpr() { return irBuilder.build(); }

  Memarg getMemarg(uint64_t offset, uint32_t align) { return {offset, align}; }

  Result<Name> getMemory(Index pos, Name* mem) {
    if (mem) {
      return *mem;
    }
    if (wasm.memories.empty()) {
      return in.err(pos, "memory required, but there is no memory");
    }
    return wasm.memories[0]->name;
  }

  Result<> makeBlock(Index pos, std::optional<Name> label, HeapType type) {
    // TODO: validate labels?
    // TODO: Move error on input types to here?
    return withLoc(pos,
                   irBuilder.makeBlock(label ? *label : Name{},
                                       type.getSignature().results));
  }

  Result<> makeIf(Index pos, std::optional<Name> label, HeapType type) {
    // TODO: validate labels?
    // TODO: Move error on input types to here?
    return withLoc(
      pos,
      irBuilder.makeIf(label ? *label : Name{}, type.getSignature().results));
  }

  Result<> visitElse() { return withLoc(irBuilder.visitElse()); }

  Result<> makeLoop(Index pos, std::optional<Name> label, HeapType type) {
    // TODO: validate labels?
    // TODO: Move error on input types to here?
    return withLoc(
      pos,
      irBuilder.makeLoop(label ? *label : Name{}, type.getSignature().results));
  }

  Result<> visitEnd() { return withLoc(irBuilder.visitEnd()); }

  Result<> makeUnreachable(Index pos) {
    return withLoc(pos, irBuilder.makeUnreachable());
  }

  Result<> makeNop(Index pos) { return withLoc(pos, irBuilder.makeNop()); }

  Result<> makeBinary(Index pos, BinaryOp op) {
    return withLoc(pos, irBuilder.makeBinary(op));
  }

  Result<> makeUnary(Index pos, UnaryOp op) {
    return withLoc(pos, irBuilder.makeUnary(op));
  }

  Result<> makeSelect(Index pos, std::vector<Type>* res) {
    if (res && res->size()) {
      if (res->size() > 1) {
        return in.err(pos, "select may not have more than one result type");
      }
      return withLoc(pos, irBuilder.makeSelect((*res)[0]));
    }
    return withLoc(pos, irBuilder.makeSelect());
  }

  Result<> makeDrop(Index pos) { return withLoc(pos, irBuilder.makeDrop()); }

  Result<> makeMemorySize(Index pos, Name* mem) {
    auto m = getMemory(pos, mem);
    CHECK_ERR(m);
    return withLoc(pos, irBuilder.makeMemorySize(*m));
  }

  Result<> makeMemoryGrow(Index pos, Name* mem) {
    auto m = getMemory(pos, mem);
    CHECK_ERR(m);
    return withLoc(pos, irBuilder.makeMemoryGrow(*m));
  }

  Result<> makeLocalGet(Index pos, Index local) {
    return withLoc(pos, irBuilder.makeLocalGet(local));
  }

  Result<> makeLocalTee(Index pos, Index local) {
    return withLoc(pos, irBuilder.makeLocalTee(local));
  }

  Result<> makeLocalSet(Index pos, Index local) {
    return withLoc(pos, irBuilder.makeLocalSet(local));
  }

  Result<> makeGlobalGet(Index pos, Name global) {
    return withLoc(pos, irBuilder.makeGlobalGet(global));
  }

  Result<> makeGlobalSet(Index pos, Name global) {
    assert(wasm.getGlobalOrNull(global));
    return withLoc(pos, irBuilder.makeGlobalSet(global));
  }

  Result<> makeI32Const(Index pos, uint32_t c) {
    return withLoc(pos, irBuilder.makeConst(Literal(c)));
  }

  Result<> makeI64Const(Index pos, uint64_t c) {
    return withLoc(pos, irBuilder.makeConst(Literal(c)));
  }

  Result<> makeF32Const(Index pos, float c) {
    return withLoc(pos, irBuilder.makeConst(Literal(c)));
  }

  Result<> makeF64Const(Index pos, double c) {
    return withLoc(pos, irBuilder.makeConst(Literal(c)));
  }

  Result<> makeLoad(Index pos,
                    Type type,
                    bool signed_,
                    int bytes,
                    bool isAtomic,
                    Name* mem,
                    Memarg memarg) {
    auto m = getMemory(pos, mem);
    CHECK_ERR(m);
    if (isAtomic) {
      return withLoc(pos,
                     irBuilder.makeAtomicLoad(bytes, memarg.offset, type, *m));
    }
    return withLoc(pos,
                   irBuilder.makeLoad(
                     bytes, signed_, memarg.offset, memarg.align, type, *m));
  }

  Result<> makeStore(
    Index pos, Type type, int bytes, bool isAtomic, Name* mem, Memarg memarg) {
    auto m = getMemory(pos, mem);
    CHECK_ERR(m);
    if (isAtomic) {
      return withLoc(pos,
                     irBuilder.makeAtomicStore(bytes, memarg.offset, type, *m));
    }
    return withLoc(
      pos, irBuilder.makeStore(bytes, memarg.offset, memarg.align, type, *m));
  }

  Result<> makeAtomicRMW(
    Index pos, AtomicRMWOp op, Type type, int bytes, Name* mem, Memarg memarg) {
    auto m = getMemory(pos, mem);
    CHECK_ERR(m);
    return withLoc(pos,
                   irBuilder.makeAtomicRMW(op, bytes, memarg.offset, type, *m));
  }

  Result<>
  makeAtomicCmpxchg(Index pos, Type type, int bytes, Name* mem, Memarg memarg) {
    auto m = getMemory(pos, mem);
    CHECK_ERR(m);
    return withLoc(pos,
                   irBuilder.makeAtomicCmpxchg(bytes, memarg.offset, type, *m));
  }

  Result<> makeAtomicWait(Index pos, Type type, Name* mem, Memarg memarg) {
    auto m = getMemory(pos, mem);
    CHECK_ERR(m);
    return withLoc(pos, irBuilder.makeAtomicWait(type, memarg.offset, *m));
  }

  Result<> makeAtomicNotify(Index pos, Name* mem, Memarg memarg) {
    auto m = getMemory(pos, mem);
    CHECK_ERR(m);
    return withLoc(pos, irBuilder.makeAtomicNotify(memarg.offset, *m));
  }

  Result<> makeAtomicFence(Index pos) {
    return withLoc(pos, irBuilder.makeAtomicFence());
  }

  Result<> makeSIMDExtract(Index pos, SIMDExtractOp op, uint8_t lane) {
    return withLoc(pos, irBuilder.makeSIMDExtract(op, lane));
  }

  Result<> makeSIMDReplace(Index pos, SIMDReplaceOp op, uint8_t lane) {
    return withLoc(pos, irBuilder.makeSIMDReplace(op, lane));
  }

  Result<> makeSIMDShuffle(Index pos, const std::array<uint8_t, 16>& lanes) {
    return withLoc(pos, irBuilder.makeSIMDShuffle(lanes));
  }

  Result<> makeSIMDTernary(Index pos, SIMDTernaryOp op) {
    return withLoc(pos, irBuilder.makeSIMDTernary(op));
  }

  Result<> makeSIMDShift(Index pos, SIMDShiftOp op) {
    return withLoc(pos, irBuilder.makeSIMDShift(op));
  }

  Result<> makeSIMDLoad(Index pos, SIMDLoadOp op, Name* mem, Memarg memarg) {
    auto m = getMemory(pos, mem);
    CHECK_ERR(m);
    return withLoc(pos,
                   irBuilder.makeSIMDLoad(op, memarg.offset, memarg.align, *m));
  }

  Result<> makeSIMDLoadStoreLane(
    Index pos, SIMDLoadStoreLaneOp op, Name* mem, Memarg memarg, uint8_t lane) {
    auto m = getMemory(pos, mem);
    CHECK_ERR(m);
    return withLoc(pos,
                   irBuilder.makeSIMDLoadStoreLane(
                     op, memarg.offset, memarg.align, lane, *m));
  }

  Result<> makeMemoryInit(Index pos, Name* mem, Name data) {
    auto m = getMemory(pos, mem);
    CHECK_ERR(m);
    return withLoc(pos, irBuilder.makeMemoryInit(data, *m));
  }

  Result<> makeDataDrop(Index pos, Name data) {
    return withLoc(pos, irBuilder.makeDataDrop(data));
  }

  Result<> makeMemoryCopy(Index pos, Name* destMem, Name* srcMem) {
    auto destMemory = getMemory(pos, destMem);
    CHECK_ERR(destMemory);
    auto srcMemory = getMemory(pos, srcMem);
    CHECK_ERR(srcMemory);
    return withLoc(pos, irBuilder.makeMemoryCopy(*destMemory, *srcMemory));
  }

  Result<> makeMemoryFill(Index pos, Name* mem) {
    auto m = getMemory(pos, mem);
    CHECK_ERR(m);
    return withLoc(pos, irBuilder.makeMemoryFill(*m));
  }

  Result<> makeReturn(Index pos) {
    return withLoc(pos, irBuilder.makeReturn());
  }

  Result<> makeRefNull(Index pos, HeapType type) {
    return withLoc(pos, irBuilder.makeRefNull(type));
  }

  Result<> makeRefIsNull(Index pos) {
    return withLoc(pos, irBuilder.makeRefIsNull());
  }

  Result<> makeRefEq(Index pos) { return withLoc(pos, irBuilder.makeRefEq()); }

  Result<> makeRefI31(Index pos) {
    return withLoc(pos, irBuilder.makeRefI31());
  }

  Result<> makeI31Get(Index pos, bool signed_) {
    return withLoc(pos, irBuilder.makeI31Get(signed_));
  }

  Result<> makeStructNew(Index pos, HeapType type) {
    return withLoc(pos, irBuilder.makeStructNew(type));
  }

  Result<> makeStructNewDefault(Index pos, HeapType type) {
    return withLoc(pos, irBuilder.makeStructNewDefault(type));
  }

  Result<> makeStructGet(Index pos, HeapType type, Index field, bool signed_) {
    return withLoc(pos, irBuilder.makeStructGet(type, field, signed_));
  }

  Result<> makeStructSet(Index pos, HeapType type, Index field) {
    return withLoc(pos, irBuilder.makeStructSet(type, field));
  }

  Result<> makeArrayNew(Index pos, HeapType type) {
    return withLoc(pos, irBuilder.makeArrayNew(type));
  }

  Result<> makeArrayNewDefault(Index pos, HeapType type) {
    return withLoc(pos, irBuilder.makeArrayNewDefault(type));
  }

  Result<> makeArrayNewData(Index pos, HeapType type, Name data) {
    return withLoc(pos, irBuilder.makeArrayNewData(type, data));
  }

  Result<> makeArrayNewElem(Index pos, HeapType type, Name elem) {
    return withLoc(pos, irBuilder.makeArrayNewElem(type, elem));
  }

  Result<> makeArrayGet(Index pos, HeapType type, bool signed_) {
    return withLoc(pos, irBuilder.makeArrayGet(type, signed_));
  }

  Result<> makeArraySet(Index pos, HeapType type) {
    return withLoc(pos, irBuilder.makeArraySet(type));
  }

  Result<> makeArrayLen(Index pos) {
    return withLoc(pos, irBuilder.makeArrayLen());
  }

  Result<> makeArrayCopy(Index pos, HeapType destType, HeapType srcType) {
    return withLoc(pos, irBuilder.makeArrayCopy(destType, srcType));
  }

  Result<> makeArrayFill(Index pos, HeapType type) {
    return withLoc(pos, irBuilder.makeArrayFill(type));
  }
};

} // namespace wasm::WATParser

#endif // parser_context_h
