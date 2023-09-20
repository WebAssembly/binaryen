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

#ifndef parser_parsers_h
#define parser_parsers_h

#include "common.h"
#include "input.h"

namespace wasm::WATParser {

using namespace std::string_view_literals;

// Types
template<typename Ctx> Result<typename Ctx::HeapTypeT> heaptype(Ctx&);
template<typename Ctx> MaybeResult<typename Ctx::RefTypeT> reftype(Ctx&);
template<typename Ctx> Result<typename Ctx::TypeT> valtype(Ctx&);
template<typename Ctx> MaybeResult<typename Ctx::ParamsT> params(Ctx&);
template<typename Ctx> MaybeResult<typename Ctx::ResultsT> results(Ctx&);
template<typename Ctx> MaybeResult<typename Ctx::SignatureT> functype(Ctx&);
template<typename Ctx> Result<typename Ctx::FieldT> storagetype(Ctx&);
template<typename Ctx> Result<typename Ctx::FieldT> fieldtype(Ctx&);
template<typename Ctx> Result<typename Ctx::FieldsT> fields(Ctx&);
template<typename Ctx> MaybeResult<typename Ctx::StructT> structtype(Ctx&);
template<typename Ctx> MaybeResult<typename Ctx::ArrayT> arraytype(Ctx&);
template<typename Ctx> Result<typename Ctx::LimitsT> limits32(Ctx&);
template<typename Ctx> Result<typename Ctx::LimitsT> limits64(Ctx&);
template<typename Ctx> Result<typename Ctx::MemTypeT> memtype(Ctx&);
template<typename Ctx> Result<typename Ctx::GlobalTypeT> globaltype(Ctx&);

// Instructions
template<typename Ctx> MaybeResult<> foldedBlockinstr(Ctx&);
template<typename Ctx> MaybeResult<> unfoldedBlockinstr(Ctx&);
template<typename Ctx> MaybeResult<> blockinstr(Ctx&);
template<typename Ctx> MaybeResult<> plaininstr(Ctx&);
template<typename Ctx> MaybeResult<> instr(Ctx&);
template<typename Ctx> Result<> foldedinstrs(Ctx&);
template<typename Ctx> Result<> instrs(Ctx&);
template<typename Ctx> Result<typename Ctx::ExprT> expr(Ctx&);
template<typename Ctx> Result<typename Ctx::MemargT> memarg(Ctx&, uint32_t);
template<typename Ctx> Result<typename Ctx::BlockTypeT> blocktype(Ctx&);
template<typename Ctx> MaybeResult<> block(Ctx&, bool);
template<typename Ctx> MaybeResult<> ifelse(Ctx&, bool);
template<typename Ctx> Result<> makeUnreachable(Ctx&, Index);
template<typename Ctx> Result<> makeNop(Ctx&, Index);
template<typename Ctx> Result<> makeBinary(Ctx&, Index, BinaryOp op);
template<typename Ctx> Result<> makeUnary(Ctx&, Index, UnaryOp op);
template<typename Ctx> Result<> makeSelect(Ctx&, Index);
template<typename Ctx> Result<> makeDrop(Ctx&, Index);
template<typename Ctx> Result<> makeMemorySize(Ctx&, Index);
template<typename Ctx> Result<> makeMemoryGrow(Ctx&, Index);
template<typename Ctx> Result<> makeLocalGet(Ctx&, Index);
template<typename Ctx> Result<> makeLocalTee(Ctx&, Index);
template<typename Ctx> Result<> makeLocalSet(Ctx&, Index);
template<typename Ctx> Result<> makeGlobalGet(Ctx&, Index);
template<typename Ctx> Result<> makeGlobalSet(Ctx&, Index);
template<typename Ctx> Result<> makeBlock(Ctx&, Index);
template<typename Ctx> Result<> makeThenOrElse(Ctx&, Index);
template<typename Ctx> Result<> makeConst(Ctx&, Index, Type type);
template<typename Ctx>
Result<>
makeLoad(Ctx&, Index, Type type, bool signed_, int bytes, bool isAtomic);
template<typename Ctx>
Result<> makeStore(Ctx&, Index, Type type, int bytes, bool isAtomic);
template<typename Ctx>
Result<> makeAtomicRMW(Ctx&, Index, AtomicRMWOp op, Type type, uint8_t bytes);
template<typename Ctx>
Result<> makeAtomicCmpxchg(Ctx&, Index, Type type, uint8_t bytes);
template<typename Ctx> Result<> makeAtomicWait(Ctx&, Index, Type type);
template<typename Ctx> Result<> makeAtomicNotify(Ctx&, Index);
template<typename Ctx> Result<> makeAtomicFence(Ctx&, Index);
template<typename Ctx>
Result<> makeSIMDExtract(Ctx&, Index, SIMDExtractOp op, size_t lanes);
template<typename Ctx>
Result<> makeSIMDReplace(Ctx&, Index, SIMDReplaceOp op, size_t lanes);
template<typename Ctx> Result<> makeSIMDShuffle(Ctx&, Index);
template<typename Ctx> Result<> makeSIMDTernary(Ctx&, Index, SIMDTernaryOp op);
template<typename Ctx> Result<> makeSIMDShift(Ctx&, Index, SIMDShiftOp op);
template<typename Ctx>
Result<> makeSIMDLoad(Ctx&, Index, SIMDLoadOp op, int bytes);
template<typename Ctx>
Result<> makeSIMDLoadStoreLane(Ctx&, Index, SIMDLoadStoreLaneOp op, int bytes);
template<typename Ctx> Result<> makeMemoryInit(Ctx&, Index);
template<typename Ctx> Result<> makeDataDrop(Ctx&, Index);
template<typename Ctx> Result<> makeMemoryCopy(Ctx&, Index);
template<typename Ctx> Result<> makeMemoryFill(Ctx&, Index);
template<typename Ctx> Result<> makePop(Ctx&, Index);
template<typename Ctx> Result<> makeIf(Ctx&, Index);
template<typename Ctx>
Result<> makeMaybeBlock(Ctx&, Index, size_t i, Type type);
template<typename Ctx> Result<> makeLoop(Ctx&, Index);
template<typename Ctx> Result<> makeCall(Ctx&, Index, bool isReturn);
template<typename Ctx> Result<> makeCallIndirect(Ctx&, Index, bool isReturn);
template<typename Ctx> Result<> makeBreak(Ctx&, Index);
template<typename Ctx> Result<> makeBreakTable(Ctx&, Index);
template<typename Ctx> Result<> makeReturn(Ctx&, Index);
template<typename Ctx> Result<> makeRefNull(Ctx&, Index);
template<typename Ctx> Result<> makeRefIsNull(Ctx&, Index);
template<typename Ctx> Result<> makeRefFunc(Ctx&, Index);
template<typename Ctx> Result<> makeRefEq(Ctx&, Index);
template<typename Ctx> Result<> makeTableGet(Ctx&, Index);
template<typename Ctx> Result<> makeTableSet(Ctx&, Index);
template<typename Ctx> Result<> makeTableSize(Ctx&, Index);
template<typename Ctx> Result<> makeTableGrow(Ctx&, Index);
template<typename Ctx> Result<> makeTableFill(Ctx&, Index);
template<typename Ctx> Result<> makeTry(Ctx&, Index);
template<typename Ctx>
Result<> makeTryOrCatchBody(Ctx&, Index, Type type, bool isTry);
template<typename Ctx> Result<> makeThrow(Ctx&, Index);
template<typename Ctx> Result<> makeRethrow(Ctx&, Index);
template<typename Ctx> Result<> makeTupleMake(Ctx&, Index);
template<typename Ctx> Result<> makeTupleExtract(Ctx&, Index);
template<typename Ctx> Result<> makeCallRef(Ctx&, Index, bool isReturn);
template<typename Ctx> Result<> makeRefI31(Ctx&, Index);
template<typename Ctx> Result<> makeI31Get(Ctx&, Index, bool signed_);
template<typename Ctx> Result<> makeRefTest(Ctx&, Index);
template<typename Ctx> Result<> makeRefCast(Ctx&, Index);
template<typename Ctx> Result<> makeBrOnNull(Ctx&, Index, bool onFail = false);
template<typename Ctx> Result<> makeBrOnCast(Ctx&, Index, bool onFail = false);
template<typename Ctx> Result<> makeStructNew(Ctx&, Index, bool default_);
template<typename Ctx>
Result<> makeStructGet(Ctx&, Index, bool signed_ = false);
template<typename Ctx> Result<> makeStructSet(Ctx&, Index);
template<typename Ctx> Result<> makeArrayNew(Ctx&, Index, bool default_);
template<typename Ctx> Result<> makeArrayNewData(Ctx&, Index);
template<typename Ctx> Result<> makeArrayNewElem(Ctx&, Index);
template<typename Ctx> Result<> makeArrayNewFixed(Ctx&, Index);
template<typename Ctx> Result<> makeArrayGet(Ctx&, Index, bool signed_ = false);
template<typename Ctx> Result<> makeArraySet(Ctx&, Index);
template<typename Ctx> Result<> makeArrayLen(Ctx&, Index);
template<typename Ctx> Result<> makeArrayCopy(Ctx&, Index);
template<typename Ctx> Result<> makeArrayFill(Ctx&, Index);
template<typename Ctx> Result<> makeArrayInitData(Ctx&, Index);
template<typename Ctx> Result<> makeArrayInitElem(Ctx&, Index);
template<typename Ctx> Result<> makeRefAs(Ctx&, Index, RefAsOp op);
template<typename Ctx>
Result<> makeStringNew(Ctx&, Index, StringNewOp op, bool try_);
template<typename Ctx> Result<> makeStringConst(Ctx&, Index);
template<typename Ctx>
Result<> makeStringMeasure(Ctx&, Index, StringMeasureOp op);
template<typename Ctx>
Result<> makeStringEncode(Ctx&, Index, StringEncodeOp op);
template<typename Ctx> Result<> makeStringConcat(Ctx&, Index);
template<typename Ctx> Result<> makeStringEq(Ctx&, Index, StringEqOp);
template<typename Ctx> Result<> makeStringAs(Ctx&, Index, StringAsOp op);
template<typename Ctx> Result<> makeStringWTF8Advance(Ctx&, Index);
template<typename Ctx> Result<> makeStringWTF16Get(Ctx&, Index);
template<typename Ctx> Result<> makeStringIterNext(Ctx&, Index);
template<typename Ctx>
Result<> makeStringIterMove(Ctx&, Index, StringIterMoveOp op);
template<typename Ctx>
Result<> makeStringSliceWTF(Ctx&, Index, StringSliceWTFOp op);
template<typename Ctx> Result<> makeStringSliceIter(Ctx&, Index);

// Modules
template<typename Ctx> MaybeResult<Index> maybeTypeidx(Ctx& ctx);
template<typename Ctx> Result<typename Ctx::HeapTypeT> typeidx(Ctx&);
template<typename Ctx>
Result<typename Ctx::FieldIdxT> fieldidx(Ctx&, typename Ctx::HeapTypeT);
template<typename Ctx> MaybeResult<typename Ctx::MemoryIdxT> maybeMemidx(Ctx&);
template<typename Ctx> Result<typename Ctx::MemoryIdxT> memidx(Ctx&);
template<typename Ctx> MaybeResult<typename Ctx::MemoryIdxT> maybeMemuse(Ctx&);
template<typename Ctx> Result<typename Ctx::GlobalIdxT> globalidx(Ctx&);
template<typename Ctx> Result<typename Ctx::LocalIdxT> localidx(Ctx&);
template<typename Ctx> Result<typename Ctx::TypeUseT> typeuse(Ctx&);
MaybeResult<ImportNames> inlineImport(ParseInput&);
Result<std::vector<Name>> inlineExports(ParseInput&);
template<typename Ctx> Result<> strtype(Ctx&);
template<typename Ctx> MaybeResult<typename Ctx::ModuleNameT> subtype(Ctx&);
template<typename Ctx> MaybeResult<> deftype(Ctx&);
template<typename Ctx> MaybeResult<typename Ctx::LocalsT> locals(Ctx&);
template<typename Ctx> MaybeResult<> func(Ctx&);
template<typename Ctx> MaybeResult<> memory(Ctx&);
template<typename Ctx> MaybeResult<> global(Ctx&);
template<typename Ctx> Result<typename Ctx::DataStringT> datastring(Ctx&);
template<typename Ctx> MaybeResult<> data(Ctx&);
template<typename Ctx> MaybeResult<> modulefield(Ctx&);
template<typename Ctx> Result<> module(Ctx&);

// =========
// Utilities
// =========

// RAII utility for temporarily changing the parsing position of a parsing
// context.
template<typename Ctx> struct WithPosition {
  Ctx& ctx;
  Index original;

  WithPosition(Ctx& ctx, Index pos) : ctx(ctx), original(ctx.in.getPos()) {
    ctx.in.lexer.setIndex(pos);
  }

  ~WithPosition() { ctx.in.lexer.setIndex(original); }
};

// Deduction guide to satisfy -Wctad-maybe-unsupported.
template<typename Ctx> WithPosition(Ctx& ctx, Index) -> WithPosition<Ctx>;

// =====
// Types
// =====

// heaptype ::= x:typeidx => types[x]
//            | 'func'    => func
//            | 'extern'  => extern
template<typename Ctx> Result<typename Ctx::HeapTypeT> heaptype(Ctx& ctx) {
  if (ctx.in.takeKeyword("func"sv)) {
    return ctx.makeFunc();
  }
  if (ctx.in.takeKeyword("any"sv)) {
    return ctx.makeAny();
  }
  if (ctx.in.takeKeyword("extern"sv)) {
    return ctx.makeExtern();
  }
  if (ctx.in.takeKeyword("eq"sv)) {
    return ctx.makeEq();
  }
  if (ctx.in.takeKeyword("i31"sv)) {
    return ctx.makeI31();
  }
  if (ctx.in.takeKeyword("struct"sv)) {
    return ctx.makeStructType();
  }
  if (ctx.in.takeKeyword("array"sv)) {
    return ctx.makeArrayType();
  }
  auto type = typeidx(ctx);
  CHECK_ERR(type);
  return *type;
}

// reftype ::= 'funcref'   => funcref
//           | 'externref' => externref
//           | 'anyref'    => anyref
//           | 'eqref'     => eqref
//           | 'i31ref'    => i31ref
//           | 'structref' => structref
//           | 'arrayref'  => arrayref
//           | '(' ref null? t:heaptype ')' => ref null? t
template<typename Ctx> MaybeResult<typename Ctx::TypeT> reftype(Ctx& ctx) {
  if (ctx.in.takeKeyword("funcref"sv)) {
    return ctx.makeRefType(ctx.makeFunc(), Nullable);
  }
  if (ctx.in.takeKeyword("externref"sv)) {
    return ctx.makeRefType(ctx.makeExtern(), Nullable);
  }
  if (ctx.in.takeKeyword("anyref"sv)) {
    return ctx.makeRefType(ctx.makeAny(), Nullable);
  }
  if (ctx.in.takeKeyword("eqref"sv)) {
    return ctx.makeRefType(ctx.makeEq(), Nullable);
  }
  if (ctx.in.takeKeyword("i31ref"sv)) {
    return ctx.makeRefType(ctx.makeI31(), Nullable);
  }
  if (ctx.in.takeKeyword("structref"sv)) {
    return ctx.makeRefType(ctx.makeStructType(), Nullable);
  }
  if (ctx.in.takeKeyword("arrayref"sv)) {
    return ctx.in.err("arrayref not yet supported");
  }

  if (!ctx.in.takeSExprStart("ref"sv)) {
    return {};
  }

  auto nullability = ctx.in.takeKeyword("null"sv) ? Nullable : NonNullable;

  auto type = heaptype(ctx);
  CHECK_ERR(type);

  if (!ctx.in.takeRParen()) {
    return ctx.in.err("expected end of reftype");
  }

  return ctx.makeRefType(*type, nullability);
}

// numtype ::= 'i32' => i32
//           | 'i64' => i64
//           | 'f32' => f32
//           | 'f64' => f64
// vectype ::= 'v128' => v128
// valtype ::= t:numtype => t
//           | t:vectype => t
//           | t:reftype => t
template<typename Ctx> Result<typename Ctx::TypeT> valtype(Ctx& ctx) {
  if (ctx.in.takeKeyword("i32"sv)) {
    return ctx.makeI32();
  } else if (ctx.in.takeKeyword("i64"sv)) {
    return ctx.makeI64();
  } else if (ctx.in.takeKeyword("f32"sv)) {
    return ctx.makeF32();
  } else if (ctx.in.takeKeyword("f64"sv)) {
    return ctx.makeF64();
  } else if (ctx.in.takeKeyword("v128"sv)) {
    return ctx.makeV128();
  } else if (auto type = reftype(ctx)) {
    CHECK_ERR(type);
    return *type;
  } else {
    return ctx.in.err("expected valtype");
  }
}

// param  ::= '(' 'param id? t:valtype ')' => [t]
//          | '(' 'param t*:valtype* ')' => [t*]
// params ::= param*
template<typename Ctx> MaybeResult<typename Ctx::ParamsT> params(Ctx& ctx) {
  bool hasAny = false;
  auto res = ctx.makeParams();
  while (ctx.in.takeSExprStart("param"sv)) {
    hasAny = true;
    if (auto id = ctx.in.takeID()) {
      // Single named param
      auto type = valtype(ctx);
      CHECK_ERR(type);
      if (!ctx.in.takeRParen()) {
        return ctx.in.err("expected end of param");
      }
      ctx.appendParam(res, *id, *type);
    } else {
      // Repeated unnamed params
      while (!ctx.in.takeRParen()) {
        auto type = valtype(ctx);
        CHECK_ERR(type);
        ctx.appendParam(res, {}, *type);
      }
    }
  }
  if (hasAny) {
    return res;
  }
  return {};
}

// result  ::= '(' 'result' t*:valtype ')' => [t*]
// results ::= result*
template<typename Ctx> MaybeResult<typename Ctx::ResultsT> results(Ctx& ctx) {
  bool hasAny = false;
  auto res = ctx.makeResults();
  while (ctx.in.takeSExprStart("result"sv)) {
    hasAny = true;
    while (!ctx.in.takeRParen()) {
      auto type = valtype(ctx);
      CHECK_ERR(type);
      ctx.appendResult(res, *type);
    }
  }
  if (hasAny) {
    return res;
  }
  return {};
}

// functype ::= '(' 'func' t1*:vec(param) t2*:vec(result) ')' => [t1*] -> [t2*]
template<typename Ctx>
MaybeResult<typename Ctx::SignatureT> functype(Ctx& ctx) {
  if (!ctx.in.takeSExprStart("func"sv)) {
    return {};
  }

  auto parsedParams = params(ctx);
  CHECK_ERR(parsedParams);

  auto parsedResults = results(ctx);
  CHECK_ERR(parsedResults);

  if (!ctx.in.takeRParen()) {
    return ctx.in.err("expected end of functype");
  }

  return ctx.makeFuncType(parsedParams.getPtr(), parsedResults.getPtr());
}

// storagetype ::= valtype | packedtype
// packedtype  ::= i8 | i16
template<typename Ctx> Result<typename Ctx::FieldT> storagetype(Ctx& ctx) {
  if (ctx.in.takeKeyword("i8"sv)) {
    return ctx.makeI8();
  }
  if (ctx.in.takeKeyword("i16"sv)) {
    return ctx.makeI16();
  }
  auto type = valtype(ctx);
  CHECK_ERR(type);
  return ctx.makeStorageType(*type);
}

// fieldtype   ::= t:storagetype               => const t
//               | '(' 'mut' t:storagetype ')' => var t
template<typename Ctx> Result<typename Ctx::FieldT> fieldtype(Ctx& ctx) {
  auto mutability = Immutable;
  if (ctx.in.takeSExprStart("mut"sv)) {
    mutability = Mutable;
  }

  auto field = storagetype(ctx);
  CHECK_ERR(field);

  if (mutability == Mutable) {
    if (!ctx.in.takeRParen()) {
      return ctx.in.err("expected end of field type");
    }
  }

  return ctx.makeFieldType(*field, mutability);
}

// field ::= '(' 'field' id t:fieldtype ')' => [(id, t)]
//         | '(' 'field' t*:fieldtype* ')'  => [(_, t*)*]
//         | fieldtype
template<typename Ctx> Result<typename Ctx::FieldsT> fields(Ctx& ctx) {
  auto res = ctx.makeFields();
  while (true) {
    if (auto t = ctx.in.peek(); !t || t->isRParen()) {
      return res;
    }
    if (ctx.in.takeSExprStart("field")) {
      if (auto id = ctx.in.takeID()) {
        auto field = fieldtype(ctx);
        CHECK_ERR(field);
        if (!ctx.in.takeRParen()) {
          return ctx.in.err("expected end of field");
        }
        ctx.appendField(res, *id, *field);
      } else {
        while (!ctx.in.takeRParen()) {
          auto field = fieldtype(ctx);
          CHECK_ERR(field);
          ctx.appendField(res, {}, *field);
        }
      }
    } else {
      auto field = fieldtype(ctx);
      CHECK_ERR(field);
      ctx.appendField(res, {}, *field);
    }
  }
}

// structtype ::= '(' 'struct' field* ')'
template<typename Ctx> MaybeResult<typename Ctx::StructT> structtype(Ctx& ctx) {
  if (!ctx.in.takeSExprStart("struct"sv)) {
    return {};
  }
  auto namedFields = fields(ctx);
  CHECK_ERR(namedFields);
  if (!ctx.in.takeRParen()) {
    return ctx.in.err("expected end of struct definition");
  }

  return ctx.makeStruct(*namedFields);
}

// arraytype ::= '(' 'array' field ')'
template<typename Ctx> MaybeResult<typename Ctx::ArrayT> arraytype(Ctx& ctx) {
  if (!ctx.in.takeSExprStart("array"sv)) {
    return {};
  }
  auto namedFields = fields(ctx);
  CHECK_ERR(namedFields);
  if (!ctx.in.takeRParen()) {
    return ctx.in.err("expected end of array definition");
  }

  if (auto array = ctx.makeArray(*namedFields)) {
    return *array;
  }
  return ctx.in.err("expected exactly one field in array definition");
}

// limits32 ::= n:u32 m:u32?
template<typename Ctx> Result<typename Ctx::LimitsT> limits32(Ctx& ctx) {
  auto n = ctx.in.takeU32();
  if (!n) {
    return ctx.in.err("expected initial size");
  }
  std::optional<uint64_t> m = ctx.in.takeU32();
  return ctx.makeLimits(uint64_t(*n), m);
}

// limits64 ::= n:u64 m:u64?
template<typename Ctx> Result<typename Ctx::LimitsT> limits64(Ctx& ctx) {
  auto n = ctx.in.takeU64();
  if (!n) {
    return ctx.in.err("expected initial size");
  }
  std::optional<uint64_t> m = ctx.in.takeU64();
  return ctx.makeLimits(uint64_t(*n), m);
}

// memtype ::= (limits32 | 'i32' limits32 | 'i64' limit64) shared?
template<typename Ctx> Result<typename Ctx::MemTypeT> memtype(Ctx& ctx) {
  auto type = Type::i32;
  if (ctx.in.takeKeyword("i64"sv)) {
    type = Type::i64;
  } else {
    ctx.in.takeKeyword("i32"sv);
  }
  auto limits = type == Type::i32 ? limits32(ctx) : limits64(ctx);
  CHECK_ERR(limits);
  bool shared = false;
  if (ctx.in.takeKeyword("shared"sv)) {
    shared = true;
  }
  return ctx.makeMemType(type, *limits, shared);
}

// globaltype ::= t:valtype               => const t
//              | '(' 'mut' t:valtype ')' => var t
template<typename Ctx> Result<typename Ctx::GlobalTypeT> globaltype(Ctx& ctx) {
  auto mutability = Immutable;
  if (ctx.in.takeSExprStart("mut"sv)) {
    mutability = Mutable;
  }

  auto type = valtype(ctx);
  CHECK_ERR(type);

  if (mutability == Mutable && !ctx.in.takeRParen()) {
    return ctx.in.err("expected end of globaltype");
  }

  return ctx.makeGlobalType(mutability, *type);
}

// ============
// Instructions
// ============

// blockinstr ::= block | loop | if-else | try-catch
template<typename Ctx> MaybeResult<> foldedBlockinstr(Ctx& ctx) {
  if (auto i = block(ctx, true)) {
    return i;
  }
  if (auto i = ifelse(ctx, true)) {
    return i;
  }
  // TODO: Other block instructions
  return {};
}

template<typename Ctx> MaybeResult<> unfoldedBlockinstr(Ctx& ctx) {
  if (auto i = block(ctx, false)) {
    return i;
  }
  if (auto i = ifelse(ctx, false)) {
    return i;
  }
  // TODO: Other block instructions
  return {};
}

template<typename Ctx> MaybeResult<> blockinstr(Ctx& ctx) {
  if (auto i = foldedBlockinstr(ctx)) {
    return i;
  }
  if (auto i = unfoldedBlockinstr(ctx)) {
    return i;
  }
  return {};
}

// plaininstr ::= ... all plain instructions ...
template<typename Ctx> MaybeResult<> plaininstr(Ctx& ctx) {
  auto pos = ctx.in.getPos();
  auto keyword = ctx.in.takeKeyword();
  if (!keyword) {
    return {};
  }

#define NEW_INSTRUCTION_PARSER
#define NEW_WAT_PARSER
#include <gen-s-parser.inc>
}

// instr ::= plaininstr | blockinstr
template<typename Ctx> MaybeResult<> instr(Ctx& ctx) {
  // Check for valid strings that are not instructions.
  if (auto tok = ctx.in.peek()) {
    if (auto keyword = tok->getKeyword()) {
      if (keyword == "end"sv || keyword == "then"sv || keyword == "else"sv) {
        return {};
      }
    }
  }
  if (auto i = blockinstr(ctx)) {
    return i;
  }
  if (auto i = plaininstr(ctx)) {
    return i;
  }
  // TODO: Handle folded plain instructions as well.
  return {};
}

template<typename Ctx> Result<> foldedinstrs(Ctx& ctx) {
  if (auto blockinst = foldedBlockinstr(ctx)) {
    CHECK_ERR(blockinst);
    return Ok{};
  }
  // Parse an arbitrary number of folded instructions.
  if (ctx.in.takeLParen()) {
    // A stack of (start, end) position pairs defining the positions of
    // instructions that need to be parsed after their folded children.
    std::vector<std::pair<Index, std::optional<Index>>> foldedInstrs;

    // Begin a folded instruction. Push its start position and a placeholder
    // end position.
    foldedInstrs.push_back({ctx.in.getPos(), {}});
    while (!foldedInstrs.empty()) {
      // Consume everything up to the next paren. This span will be parsed as
      // an instruction later after its folded children have been parsed.
      if (!ctx.in.takeUntilParen()) {
        return ctx.in.err(foldedInstrs.back().first,
                          "unterminated folded instruction");
      }

      if (!foldedInstrs.back().second) {
        // The folded instruction we just started should end here.
        foldedInstrs.back().second = ctx.in.getPos();
      }

      // We have either the start of a new folded child or the end of the last
      // one.
      if (auto blockinst = foldedBlockinstr(ctx)) {
        CHECK_ERR(blockinst);
      } else if (ctx.in.takeLParen()) {
        foldedInstrs.push_back({ctx.in.getPos(), {}});
      } else if (ctx.in.takeRParen()) {
        auto [start, end] = foldedInstrs.back();
        assert(end && "Should have found end of instruction");
        foldedInstrs.pop_back();

        WithPosition with(ctx, start);
        if (auto inst = plaininstr(ctx)) {
          CHECK_ERR(inst);
        } else {
          return ctx.in.err(start, "expected folded instruction");
        }

        if (ctx.in.getPos() != *end) {
          return ctx.in.err("expected end of instruction");
        }
      } else {
        WASM_UNREACHABLE("expected paren");
      }
    }
    return Ok{};
  }
  return ctx.in.err("expected folded instruction");
}

template<typename Ctx> Result<> instrs(Ctx& ctx) {
  bool parsedFolded = false;

  while (true) {
    // Try to parse a folded instruction tree.
    if (!foldedinstrs(ctx).getErr()) {
      continue;
    }

    // Otherwise parse a non-folded instruction.
    if (auto inst = instr(ctx)) {
      CHECK_ERR(inst);
    } else {
      break;
    }
  }

  if (requireFolded && !parsedFolded) {
    return ctx.in.err("expected folded instructions");
  }

  return Ok{};
}

template<typename Ctx> Result<typename Ctx::ExprT> expr(Ctx& ctx) {
  CHECK_ERR(instrs(ctx));
  return ctx.makeExpr();
}

// memarg_n ::= o:offset a:align_n
// offset   ::= 'offset='o:u64 => o | _ => 0
// align_n  ::= 'align='a:u32 => a | _ => n
template<typename Ctx>
Result<typename Ctx::MemargT> memarg(Ctx& ctx, uint32_t n) {
  uint64_t offset = 0;
  uint32_t align = n;
  if (auto o = ctx.in.takeOffset()) {
    offset = *o;
  }
  if (auto a = ctx.in.takeAlign()) {
    align = *a;
  }
  return ctx.getMemarg(offset, align);
}

// blocktype ::= (t:result)? => t? | x,I:typeuse => x if I = {}
template<typename Ctx> Result<typename Ctx::BlockTypeT> blocktype(Ctx& ctx) {
  auto pos = ctx.in.getPos();

  if (auto res = results(ctx)) {
    CHECK_ERR(res);
    if (ctx.getResultsSize(*res) == 1) {
      return ctx.getBlockTypeFromResult(*res);
    }
  }

  // We either had no results or multiple results. Reset and parse again as a
  // type use.
  ctx.in.lexer.setIndex(pos);
  auto use = typeuse(ctx);
  CHECK_ERR(use);

  auto type = ctx.getBlockTypeFromTypeUse(pos, *use);
  CHECK_ERR(type);
  return *type;
}

// block ::= 'block' label blocktype instr* 'end' id?   if id = {} or id = label
//         | '(' 'block' label blocktype instr* ')'
template<typename Ctx> MaybeResult<> block(Ctx& ctx, bool folded) {
  auto pos = ctx.in.getPos();

  if (folded) {
    if (!ctx.in.takeSExprStart("block"sv)) {
      return {};
    }
  } else {
    if (!ctx.in.takeKeyword("block"sv)) {
      return {};
    }
  }

  auto label = ctx.in.takeID();

  auto type = blocktype(ctx);
  CHECK_ERR(type);

  ctx.makeBlock(pos, label, *type);

  CHECK_ERR(instrs(ctx));

  if (folded) {
    if (!ctx.in.takeRParen()) {
      return ctx.in.err("expected ')' at end of block");
    }
  } else {
    if (!ctx.in.takeKeyword("end"sv)) {
      return ctx.in.err("expected 'end' at end of block");
    }
    auto id = ctx.in.takeID();
    if (id && id != label) {
      return ctx.in.err("end label does not match block label");
    }
  }

  return ctx.visitEnd(pos);
}

// if ::= 'if' label blocktype instr1* ('else' id1? instr2*)? 'end' id2?
//      | '(' 'if' label blocktype instr* '(' 'then' instr1* ')'
//            ('(' 'else' instr2* ')')? ')'
template<typename Ctx> MaybeResult<> ifelse(Ctx& ctx, bool folded) {
  auto pos = ctx.in.getPos();

  if (folded) {
    if (!ctx.in.takeSExprStart("if"sv)) {
      return {};
    }
  } else {
    if (!ctx.in.takeKeyword("if"sv)) {
      return {};
    }
  }

  auto label = ctx.in.takeID();

  auto type = blocktype(ctx);
  CHECK_ERR(type);

  if (folded) {
    CHECK_ERR(foldedinstrs(ctx));
  }

  ctx.makeIf(pos, label, *type);

  if (folded && !ctx.in.takeSExprStart("then"sv)) {
    return ctx.in.err("expected 'then' before if instructions");
  }

  CHECK_ERR(instrs(ctx));

  if (folded && !ctx.in.takeRParen()) {
    return ctx.in.err("expected ')' at end of then block");
  }

  if ((folded && ctx.in.takeSExprStart("else"sv)) ||
      (!folded && ctx.in.takeKeyword("else"sv))) {
    auto id1 = ctx.in.takeID();
    if (id1 && id1 != label) {
      return ctx.in.err("else label does not match if label");
    }

    ctx.visitElse(pos);

    CHECK_ERR(instrs(ctx));

    if (folded && !ctx.in.takeRParen()) {
      return ctx.in.err("expected ')' at end of else block");
    }
  }

  if (folded) {
    if (!ctx.in.takeRParen()) {
      return ctx.in.err("expected ')' at end of if");
    }
  } else {
    if (!ctx.in.takeKeyword("end"sv)) {
      return ctx.in.err("expected 'end' at end of if");
    }
  }

  auto id2 = ctx.in.takeID();
  if (id2 && id2 != label) {
    return ctx.in.err("end label does not match if label");
  }

  return ctx.visitEnd(pos);
}

template<typename Ctx> Result<> makeUnreachable(Ctx& ctx, Index pos) {
  return ctx.makeUnreachable(pos);
}

template<typename Ctx> Result<> makeNop(Ctx& ctx, Index pos) {
  return ctx.makeNop(pos);
}

template<typename Ctx> Result<> makeBinary(Ctx& ctx, Index pos, BinaryOp op) {
  return ctx.makeBinary(pos, op);
}

template<typename Ctx> Result<> makeUnary(Ctx& ctx, Index pos, UnaryOp op) {
  return ctx.makeUnary(pos, op);
}

template<typename Ctx> Result<> makeSelect(Ctx& ctx, Index pos) {
  auto res = results(ctx);
  CHECK_ERR(res);
  return ctx.makeSelect(pos, res.getPtr());
}

template<typename Ctx> Result<> makeDrop(Ctx& ctx, Index pos) {
  return ctx.makeDrop(pos);
}

template<typename Ctx> Result<> makeMemorySize(Ctx& ctx, Index pos) {
  auto mem = maybeMemidx(ctx);
  CHECK_ERR(mem);
  return ctx.makeMemorySize(pos, mem.getPtr());
}

template<typename Ctx> Result<> makeMemoryGrow(Ctx& ctx, Index pos) {
  auto mem = maybeMemidx(ctx);
  CHECK_ERR(mem);
  return ctx.makeMemoryGrow(pos, mem.getPtr());
}

template<typename Ctx> Result<> makeLocalGet(Ctx& ctx, Index pos) {
  auto local = localidx(ctx);
  CHECK_ERR(local);
  return ctx.makeLocalGet(pos, *local);
}

template<typename Ctx> Result<> makeLocalTee(Ctx& ctx, Index pos) {
  auto local = localidx(ctx);
  CHECK_ERR(local);
  return ctx.makeLocalTee(pos, *local);
}

template<typename Ctx> Result<> makeLocalSet(Ctx& ctx, Index pos) {
  auto local = localidx(ctx);
  CHECK_ERR(local);
  return ctx.makeLocalSet(pos, *local);
}

template<typename Ctx> Result<> makeGlobalGet(Ctx& ctx, Index pos) {
  auto global = globalidx(ctx);
  CHECK_ERR(global);
  return ctx.makeGlobalGet(pos, *global);
}

template<typename Ctx> Result<> makeGlobalSet(Ctx& ctx, Index pos) {
  auto global = globalidx(ctx);
  CHECK_ERR(global);
  return ctx.makeGlobalSet(pos, *global);
}

template<typename Ctx> Result<> makeBlock(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx> Result<> makeConst(Ctx& ctx, Index pos, Type type) {
  assert(type.isBasic());
  switch (type.getBasic()) {
    case Type::i32:
      if (auto c = ctx.in.takeI32()) {
        return ctx.makeI32Const(pos, *c);
      }
      return ctx.in.err("expected i32");
    case Type::i64:
      if (auto c = ctx.in.takeI64()) {
        return ctx.makeI64Const(pos, *c);
      }
      return ctx.in.err("expected i64");
    case Type::f32:
      if (auto c = ctx.in.takeF32()) {
        return ctx.makeF32Const(pos, *c);
      }
      return ctx.in.err("expected f32");
    case Type::f64:
      if (auto c = ctx.in.takeF64()) {
        return ctx.makeF64Const(pos, *c);
      }
      return ctx.in.err("expected f64");
    case Type::v128:
      return ctx.in.err("unimplemented instruction");
    case Type::none:
    case Type::unreachable:
      break;
  }
  WASM_UNREACHABLE("unexpected type");
}

template<typename Ctx>
Result<> makeLoad(
  Ctx& ctx, Index pos, Type type, bool signed_, int bytes, bool isAtomic) {
  auto mem = maybeMemidx(ctx);
  CHECK_ERR(mem);
  auto arg = memarg(ctx, bytes);
  CHECK_ERR(arg);
  return ctx.makeLoad(pos, type, signed_, bytes, isAtomic, mem.getPtr(), *arg);
}

template<typename Ctx>
Result<> makeStore(Ctx& ctx, Index pos, Type type, int bytes, bool isAtomic) {
  auto mem = maybeMemidx(ctx);
  CHECK_ERR(mem);
  auto arg = memarg(ctx, bytes);
  CHECK_ERR(arg);
  return ctx.makeStore(pos, type, bytes, isAtomic, mem.getPtr(), *arg);
}

template<typename Ctx>
Result<>
makeAtomicRMW(Ctx& ctx, Index pos, AtomicRMWOp op, Type type, uint8_t bytes) {
  auto mem = maybeMemidx(ctx);
  CHECK_ERR(mem);
  auto arg = memarg(ctx, bytes);
  CHECK_ERR(arg);
  return ctx.makeAtomicRMW(pos, op, type, bytes, mem.getPtr(), *arg);
}

template<typename Ctx>
Result<> makeAtomicCmpxchg(Ctx& ctx, Index pos, Type type, uint8_t bytes) {
  auto mem = maybeMemidx(ctx);
  CHECK_ERR(mem);
  auto arg = memarg(ctx, bytes);
  CHECK_ERR(arg);
  return ctx.makeAtomicCmpxchg(pos, type, bytes, mem.getPtr(), *arg);
}

template<typename Ctx> Result<> makeAtomicWait(Ctx& ctx, Index pos, Type type) {
  auto mem = maybeMemidx(ctx);
  CHECK_ERR(mem);
  auto arg = memarg(ctx, type == Type::i32 ? 4 : 8);
  CHECK_ERR(arg);
  return ctx.makeAtomicWait(pos, type, mem.getPtr(), *arg);
}

template<typename Ctx> Result<> makeAtomicNotify(Ctx& ctx, Index pos) {
  auto mem = maybeMemidx(ctx);
  CHECK_ERR(mem);
  auto arg = memarg(ctx, 4);
  CHECK_ERR(arg);
  return ctx.makeAtomicNotify(pos, mem.getPtr(), *arg);
}

template<typename Ctx> Result<> makeAtomicFence(Ctx& ctx, Index pos) {
  return ctx.makeAtomicFence(pos);
}

template<typename Ctx>
Result<> makeSIMDExtract(Ctx& ctx, Index pos, SIMDExtractOp op, size_t) {
  auto lane = ctx.in.takeU8();
  if (!lane) {
    return ctx.in.err("expected lane index");
  }
  return ctx.makeSIMDExtract(pos, op, *lane);
}

template<typename Ctx>
Result<> makeSIMDReplace(Ctx& ctx, Index pos, SIMDReplaceOp op, size_t lanes) {
  auto lane = ctx.in.takeU8();
  if (!lane) {
    return ctx.in.err("expected lane index");
  }
  return ctx.makeSIMDReplace(pos, op, *lane);
}

template<typename Ctx> Result<> makeSIMDShuffle(Ctx& ctx, Index pos) {
  std::array<uint8_t, 16> lanes;
  for (int i = 0; i < 16; ++i) {
    auto lane = ctx.in.takeU8();
    if (!lane) {
      return ctx.in.err("expected lane index");
    }
    lanes[i] = *lane;
  }
  return ctx.makeSIMDShuffle(pos, lanes);
}

template<typename Ctx>
Result<> makeSIMDTernary(Ctx& ctx, Index pos, SIMDTernaryOp op) {
  return ctx.makeSIMDTernary(pos, op);
}

template<typename Ctx>
Result<> makeSIMDShift(Ctx& ctx, Index pos, SIMDShiftOp op) {
  return ctx.makeSIMDShift(pos, op);
}

template<typename Ctx>
Result<> makeSIMDLoad(Ctx& ctx, Index pos, SIMDLoadOp op, int bytes) {
  auto mem = maybeMemidx(ctx);
  CHECK_ERR(mem);
  auto arg = memarg(ctx, bytes);
  CHECK_ERR(arg);
  return ctx.makeSIMDLoad(pos, op, mem.getPtr(), *arg);
}

template<typename Ctx>
Result<>
makeSIMDLoadStoreLane(Ctx& ctx, Index pos, SIMDLoadStoreLaneOp op, int bytes) {
  auto reset = ctx.in.getPos();

  auto retry = [&]() -> Result<> {
    // We failed to parse. Maybe the lane index was accidentally parsed as the
    // optional memory index. Try again without parsing a memory index.
    WithPosition with(ctx, reset);
    auto arg = memarg(ctx, bytes);
    CHECK_ERR(arg);
    auto lane = ctx.in.takeU8();
    if (!lane) {
      return ctx.in.err("expected lane index");
    }
    return ctx.makeSIMDLoadStoreLane(pos, op, nullptr, *arg, *lane);
  };

  auto mem = maybeMemidx(ctx);
  if (mem.getErr()) {
    return retry();
  }
  auto arg = memarg(ctx, bytes);
  CHECK_ERR(arg);
  auto lane = ctx.in.takeU8();
  if (!lane) {
    return retry();
  }
  return ctx.makeSIMDLoadStoreLane(pos, op, mem.getPtr(), *arg, *lane);
}

template<typename Ctx> Result<> makeMemoryInit(Ctx& ctx, Index pos) {
  auto reset = ctx.in.getPos();

  auto retry = [&]() -> Result<> {
    // We failed to parse. Maybe the data index was accidentally parsed as the
    // optional memory index. Try again without parsing a memory index.
    WithPosition with(ctx, reset);
    auto data = dataidx(ctx);
    CHECK_ERR(data);
    return ctx.makeMemoryInit(pos, nullptr, *data);
  };

  auto mem = maybeMemidx(ctx);
  if (mem.getErr()) {
    return retry();
  }
  auto data = dataidx(ctx);
  if (data.getErr()) {
    return retry();
  }
  return ctx.makeMemoryInit(pos, mem.getPtr(), *data);
}

template<typename Ctx> Result<> makeDataDrop(Ctx& ctx, Index pos) {
  auto data = dataidx(ctx);
  CHECK_ERR(data);
  return ctx.makeDataDrop(pos, *data);
}

template<typename Ctx> Result<> makeMemoryCopy(Ctx& ctx, Index pos) {
  auto destMem = maybeMemidx(ctx);
  CHECK_ERR(destMem);
  std::optional<typename Ctx::MemoryIdxT> srcMem = std::nullopt;
  if (destMem) {
    auto mem = memidx(ctx);
    CHECK_ERR(mem);
    srcMem = *mem;
  }
  return ctx.makeMemoryCopy(pos, destMem.getPtr(), srcMem ? &*srcMem : nullptr);
}

template<typename Ctx> Result<> makeMemoryFill(Ctx& ctx, Index pos) {
  auto mem = maybeMemidx(ctx);
  CHECK_ERR(mem);
  return ctx.makeMemoryFill(pos, mem.getPtr());
}

template<typename Ctx> Result<> makePop(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx> Result<> makeIf(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<> makeMaybeBlock(Ctx& ctx, Index pos, size_t i, Type type) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx> Result<> makeLoop(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx> Result<> makeCall(Ctx& ctx, Index pos, bool isReturn) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<> makeCallIndirect(Ctx& ctx, Index pos, bool isReturn) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx> Result<> makeBreak(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx> Result<> makeBreakTable(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx> Result<> makeReturn(Ctx& ctx, Index pos) {
  return ctx.makeReturn(pos);
}

template<typename Ctx> Result<> makeRefNull(Ctx& ctx, Index pos) {
  auto t = heaptype(ctx);
  CHECK_ERR(t);
  return ctx.makeRefNull(pos, *t);
}

template<typename Ctx> Result<> makeRefIsNull(Ctx& ctx, Index pos) {
  return ctx.makeRefIsNull(pos);
}

template<typename Ctx> Result<> makeRefFunc(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx> Result<> makeRefEq(Ctx& ctx, Index pos) {
  return ctx.makeRefEq(pos);
}

template<typename Ctx> Result<> makeTableGet(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx> Result<> makeTableSet(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx> Result<> makeTableSize(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx> Result<> makeTableGrow(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx> Result<> makeTableFill(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx> Result<> makeTry(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<> makeTryOrCatchBody(Ctx& ctx, Index pos, Type type, bool isTry) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx> Result<> makeThrow(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx> Result<> makeRethrow(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx> Result<> makeTupleMake(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx> Result<> makeTupleExtract(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<> makeCallRef(Ctx& ctx, Index pos, bool isReturn) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx> Result<> makeRefI31(Ctx& ctx, Index pos) {
  return ctx.makeRefI31(pos);
}

template<typename Ctx> Result<> makeI31Get(Ctx& ctx, Index pos, bool signed_) {
  return ctx.makeI31Get(pos, signed_);
}

template<typename Ctx> Result<> makeRefTest(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx> Result<> makeRefCast(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx> Result<> makeBrOnNull(Ctx& ctx, Index pos, bool onFail) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx> Result<> makeBrOnCast(Ctx& ctx, Index pos, bool onFail) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<> makeStructNew(Ctx& ctx, Index pos, bool default_) {
  auto type = typeidx(ctx);
  CHECK_ERR(type);
  if (default_) {
    return ctx.makeStructNewDefault(pos, *type);
  }
  return ctx.makeStructNew(pos, *type);
}

template<typename Ctx>
Result<> makeStructGet(Ctx& ctx, Index pos, bool signed_) {
  auto type = typeidx(ctx);
  CHECK_ERR(type);
  auto field = fieldidx(ctx, *type);
  CHECK_ERR(field);
  return ctx.makeStructGet(pos, *type, *field, signed_);
}

template<typename Ctx> Result<> makeStructSet(Ctx& ctx, Index pos) {
  auto type = typeidx(ctx);
  CHECK_ERR(type);
  auto field = fieldidx(ctx, *type);
  CHECK_ERR(field);
  return ctx.makeStructSet(pos, *type, *field);
}

template<typename Ctx>
Result<> makeArrayNew(Ctx& ctx, Index pos, bool default_) {
  auto type = typeidx(ctx);
  CHECK_ERR(type);
  if (default_) {
    return ctx.makeArrayNewDefault(pos, *type);
  }
  return ctx.makeArrayNew(pos, *type);
}

template<typename Ctx> Result<> makeArrayNewData(Ctx& ctx, Index pos) {
  auto type = typeidx(ctx);
  CHECK_ERR(type);
  auto data = dataidx(ctx);
  CHECK_ERR(data);
  return ctx.makeArrayNewData(pos, *type, *data);
}

template<typename Ctx> Result<> makeArrayNewElem(Ctx& ctx, Index pos) {
  auto type = typeidx(ctx);
  CHECK_ERR(type);
  auto data = dataidx(ctx);
  CHECK_ERR(data);
  return ctx.makeArrayNewElem(pos, *type, *data);
}

template<typename Ctx> Result<> makeArrayNewFixed(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<> makeArrayGet(Ctx& ctx, Index pos, bool signed_) {
  auto type = typeidx(ctx);
  CHECK_ERR(type);
  return ctx.makeArrayGet(pos, *type, signed_);
}

template<typename Ctx> Result<> makeArraySet(Ctx& ctx, Index pos) {
  auto type = typeidx(ctx);
  CHECK_ERR(type);
  return ctx.makeArraySet(pos, *type);
}

template<typename Ctx> Result<> makeArrayLen(Ctx& ctx, Index pos) {
  return ctx.makeArrayLen(pos);
}

template<typename Ctx> Result<> makeArrayCopy(Ctx& ctx, Index pos) {
  auto destType = typeidx(ctx);
  CHECK_ERR(destType);
  auto srcType = typeidx(ctx);
  CHECK_ERR(srcType);
  return ctx.makeArrayCopy(pos, *destType, *srcType);
}

template<typename Ctx> Result<> makeArrayFill(Ctx& ctx, Index pos) {
  auto type = typeidx(ctx);
  CHECK_ERR(type);
  return ctx.makeArrayFill(pos, *type);
}

template<typename Ctx> Result<> makeArrayInitData(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx> Result<> makeArrayInitElem(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx> Result<> makeRefAs(Ctx& ctx, Index pos, RefAsOp op) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<> makeStringNew(Ctx& ctx, Index pos, StringNewOp op, bool try_) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx> Result<> makeStringConst(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<> makeStringMeasure(Ctx& ctx, Index pos, StringMeasureOp op) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<> makeStringEncode(Ctx& ctx, Index pos, StringEncodeOp op) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx> Result<> makeStringConcat(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<> makeStringEq(Ctx& ctx, Index pos, StringEqOp op) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<> makeStringAs(Ctx& ctx, Index pos, StringAsOp op) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx> Result<> makeStringWTF8Advance(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx> Result<> makeStringWTF16Get(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx> Result<> makeStringIterNext(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<> makeStringIterMove(Ctx& ctx, Index pos, StringIterMoveOp op) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<> makeStringSliceWTF(Ctx& ctx, Index pos, StringSliceWTFOp op) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx> Result<> makeStringSliceIter(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

// =======
// Modules
// =======

// typeidx ::= x:u32 => x
//           | v:id  => x (if types[x] = v)
template<typename Ctx> MaybeResult<Index> maybeTypeidx(Ctx& ctx) {
  if (auto x = ctx.in.takeU32()) {
    return *x;
  }
  if (auto id = ctx.in.takeID()) {
    // TODO: Fix position to point to start of id, not next element.
    auto idx = ctx.getTypeIndex(*id);
    CHECK_ERR(idx);
    return *idx;
  }
  return {};
}

template<typename Ctx> Result<typename Ctx::HeapTypeT> typeidx(Ctx& ctx) {
  if (auto idx = maybeTypeidx(ctx)) {
    CHECK_ERR(idx);
    return ctx.getHeapTypeFromIdx(*idx);
  }
  return ctx.in.err("expected type index or identifier");
}

// fieldidx_t ::= x:u32 => x
//              | v:id  => x (if t.fields[x] = v)
template<typename Ctx>
Result<typename Ctx::FieldIdxT> fieldidx(Ctx& ctx,
                                         typename Ctx::HeapTypeT type) {
  if (auto x = ctx.in.takeU32()) {
    return ctx.getFieldFromIdx(type, *x);
  }
  if (auto id = ctx.in.takeID()) {
    return ctx.getFieldFromName(type, *id);
  }
  return ctx.in.err("expected field index or identifier");
}

// memidx ::= x:u32 => x
//          | v:id  => x (if memories[x] = v)
template<typename Ctx>
MaybeResult<typename Ctx::MemoryIdxT> maybeMemidx(Ctx& ctx) {
  if (auto x = ctx.in.takeU32()) {
    return ctx.getMemoryFromIdx(*x);
  }
  if (auto id = ctx.in.takeID()) {
    return ctx.getMemoryFromName(*id);
  }
  return {};
}

template<typename Ctx> Result<typename Ctx::MemoryIdxT> memidx(Ctx& ctx) {
  if (auto idx = maybeMemidx(ctx)) {
    CHECK_ERR(idx);
    return *idx;
  }
  return ctx.in.err("expected memory index or identifier");
}

// memuse ::= '(' 'memory' x:memidx ')' => x
template<typename Ctx>
MaybeResult<typename Ctx::MemoryIdxT> maybeMemuse(Ctx& ctx) {
  if (!ctx.in.takeSExprStart("memory"sv)) {
    return {};
  }
  auto idx = memidx(ctx);
  CHECK_ERR(idx);
  if (!ctx.in.takeRParen()) {
    return ctx.in.err("expected end of memory use");
  }
  return *idx;
}

// globalidx ::= x:u32 => x
//             | v:id  => x (if globals[x] = v)
template<typename Ctx> Result<typename Ctx::GlobalIdxT> globalidx(Ctx& ctx) {
  if (auto x = ctx.in.takeU32()) {
    return ctx.getGlobalFromIdx(*x);
  }
  if (auto id = ctx.in.takeID()) {
    return ctx.getGlobalFromName(*id);
  }
  return ctx.in.err("expected global index or identifier");
}

// dataidx ::= x:u32 => x
//           | v:id => x (if data[x] = v)
template<typename Ctx> Result<typename Ctx::DataIdxT> dataidx(Ctx& ctx) {
  if (auto x = ctx.in.takeU32()) {
    return ctx.getDataFromIdx(*x);
  }
  if (auto id = ctx.in.takeID()) {
    return ctx.getDataFromName(*id);
  }
  return ctx.in.err("expected data index or identifier");
}

// localidx ::= x:u32 => x
//            | v:id  => x (if locals[x] = v)
template<typename Ctx> Result<typename Ctx::LocalIdxT> localidx(Ctx& ctx) {
  if (auto x = ctx.in.takeU32()) {
    return ctx.getLocalFromIdx(*x);
  }
  if (auto id = ctx.in.takeID()) {
    return ctx.getLocalFromName(*id);
  }
  return ctx.in.err("expected local index or identifier");
}

// typeuse ::= '(' 'type' x:typeidx ')'                                => x, []
//                 (if typedefs[x] = [t1*] -> [t2*]
//           | '(' 'type' x:typeidx ')' ((t1,IDs):param)* (t2:result)* => x, IDs
//                 (if typedefs[x] = [t1*] -> [t2*])
//           | ((t1,IDs):param)* (t2:result)*                          => x, IDs
//                 (if x is minimum s.t. typedefs[x] = [t1*] -> [t2*])
template<typename Ctx> Result<typename Ctx::TypeUseT> typeuse(Ctx& ctx) {
  auto pos = ctx.in.getPos();
  std::optional<typename Ctx::HeapTypeT> type;
  if (ctx.in.takeSExprStart("type"sv)) {
    auto x = typeidx(ctx);
    CHECK_ERR(x);

    if (!ctx.in.takeRParen()) {
      return ctx.in.err("expected end of type use");
    }

    type = *x;
  }

  auto namedParams = params(ctx);
  CHECK_ERR(namedParams);

  auto resultTypes = results(ctx);
  CHECK_ERR(resultTypes);

  return ctx.makeTypeUse(pos, type, namedParams.getPtr(), resultTypes.getPtr());
}

// ('(' 'import' mod:name nm:name ')')?
MaybeResult<ImportNames> inlineImport(ParseInput& in) {
  if (!in.takeSExprStart("import"sv)) {
    return {};
  }
  auto mod = in.takeName();
  if (!mod) {
    return in.err("expected import module");
  }
  auto nm = in.takeName();
  if (!nm) {
    return in.err("expected import name");
  }
  if (!in.takeRParen()) {
    return in.err("expected end of import");
  }
  // TODO: Return Ok when parsing Decls.
  return {{*mod, *nm}};
}

// ('(' 'export' name ')')*
Result<std::vector<Name>> inlineExports(ParseInput& in) {
  std::vector<Name> exports;
  while (in.takeSExprStart("export"sv)) {
    auto name = in.takeName();
    if (!name) {
      return in.err("expected export name");
    }
    if (!in.takeRParen()) {
      return in.err("expected end of import");
    }
    exports.push_back(*name);
  }
  return exports;
}

// strtype ::= ft:functype   => ft
//           | st:structtype => st
//           | at:arraytype  => at
template<typename Ctx> Result<> strtype(Ctx& ctx) {
  if (auto type = functype(ctx)) {
    CHECK_ERR(type);
    ctx.addFuncType(*type);
    return Ok{};
  }
  if (auto type = structtype(ctx)) {
    CHECK_ERR(type);
    ctx.addStructType(*type);
    return Ok{};
  }
  if (auto type = arraytype(ctx)) {
    CHECK_ERR(type);
    ctx.addArrayType(*type);
    return Ok{};
  }
  return ctx.in.err("expected type description");
}

// subtype ::= '(' 'type' id? '(' 'sub' typeidx? strtype ')' ')'
//           | '(' 'type' id? strtype ')'
template<typename Ctx> MaybeResult<> subtype(Ctx& ctx) {
  auto pos = ctx.in.getPos();

  if (!ctx.in.takeSExprStart("type"sv)) {
    return {};
  }

  Name name;
  if (auto id = ctx.in.takeID()) {
    name = *id;
  }

  if (ctx.in.takeSExprStart("sub"sv)) {
    if (ctx.in.takeKeyword("open"sv)) {
      ctx.setOpen();
    }
    if (auto super = maybeTypeidx(ctx)) {
      CHECK_ERR(super);
      CHECK_ERR(ctx.addSubtype(*super));
    }

    CHECK_ERR(strtype(ctx));

    if (!ctx.in.takeRParen()) {
      return ctx.in.err("expected end of subtype definition");
    }
  } else {
    CHECK_ERR(strtype(ctx));
  }

  if (!ctx.in.takeRParen()) {
    return ctx.in.err("expected end of type definition");
  }

  ctx.finishSubtype(name, pos);
  return Ok{};
}

// deftype ::= '(' 'rec' subtype* ')'
//           | subtype
template<typename Ctx> MaybeResult<> deftype(Ctx& ctx) {
  auto pos = ctx.in.getPos();

  if (ctx.in.takeSExprStart("rec"sv)) {
    size_t startIndex = ctx.getRecGroupStartIndex();
    size_t groupLen = 0;
    while (auto type = subtype(ctx)) {
      CHECK_ERR(type);
      ++groupLen;
    }
    if (!ctx.in.takeRParen()) {
      return ctx.in.err("expected type definition or end of recursion group");
    }
    ctx.addRecGroup(startIndex, groupLen);
  } else if (auto type = subtype(ctx)) {
    CHECK_ERR(type);
  } else {
    return {};
  }

  ctx.finishDeftype(pos);
  return Ok{};
}

// local  ::= '(' 'local id? t:valtype ')' => [t]
//          | '(' 'local t*:valtype* ')' => [t*]
// locals ::= local*
template<typename Ctx> MaybeResult<typename Ctx::LocalsT> locals(Ctx& ctx) {
  bool hasAny = false;
  auto res = ctx.makeLocals();
  while (ctx.in.takeSExprStart("local"sv)) {
    hasAny = true;
    if (auto id = ctx.in.takeID()) {
      // Single named local
      auto type = valtype(ctx);
      CHECK_ERR(type);
      if (!ctx.in.takeRParen()) {
        return ctx.in.err("expected end of local");
      }
      ctx.appendLocal(res, *id, *type);
    } else {
      // Repeated unnamed locals
      while (!ctx.in.takeRParen()) {
        auto type = valtype(ctx);
        CHECK_ERR(type);
        ctx.appendLocal(res, {}, *type);
      }
    }
  }
  if (hasAny) {
    return res;
  }
  return {};
}

// func ::= '(' 'func' id? ('(' 'export' name ')')*
//              x,I:typeuse t*:vec(local) (in:instr)* ')'
//        | '(' 'func' id? ('(' 'export' name ')')*
//              '(' 'import' mod:name nm:name ')' typeuse ')'
template<typename Ctx> MaybeResult<> func(Ctx& ctx) {
  auto pos = ctx.in.getPos();
  if (!ctx.in.takeSExprStart("func"sv)) {
    return {};
  }

  Name name;
  if (auto id = ctx.in.takeID()) {
    name = *id;
  }

  auto exports = inlineExports(ctx.in);
  CHECK_ERR(exports);

  auto import = inlineImport(ctx.in);
  CHECK_ERR(import);

  auto type = typeuse(ctx);
  CHECK_ERR(type);

  std::optional<typename Ctx::LocalsT> localVars;
  if (!import) {
    if (auto l = locals(ctx)) {
      CHECK_ERR(l);
      localVars = *l;
    }
    CHECK_ERR(instrs(ctx));
  }

  if (!ctx.in.takeRParen()) {
    return ctx.in.err("expected end of function");
  }

  CHECK_ERR(
    ctx.addFunc(name, *exports, import.getPtr(), *type, localVars, pos));
  return Ok{};
}

// mem ::= '(' 'memory' id? ('(' 'export' name ')')*
//             ('(' 'data' b:datastring ')' | memtype) ')'
//       | '(' 'memory' id? ('(' 'export' name ')')*
//             '(' 'import' mod:name nm:name ')' memtype ')'
template<typename Ctx> MaybeResult<> memory(Ctx& ctx) {
  auto pos = ctx.in.getPos();
  if (!ctx.in.takeSExprStart("memory"sv)) {
    return {};
  }

  Name name;
  if (auto id = ctx.in.takeID()) {
    name = *id;
  }

  auto exports = inlineExports(ctx.in);
  CHECK_ERR(exports);

  auto import = inlineImport(ctx.in);
  CHECK_ERR(import);

  std::optional<typename Ctx::MemTypeT> mtype;
  std::optional<typename Ctx::DataStringT> data;
  if (ctx.in.takeSExprStart("data"sv)) {
    if (import) {
      return ctx.in.err("imported memories cannot have inline data");
    }
    auto datastr = datastring(ctx);
    CHECK_ERR(datastr);
    if (!ctx.in.takeRParen()) {
      return ctx.in.err("expected end of inline data");
    }
    mtype = ctx.makeMemType(Type::i32, ctx.getLimitsFromData(*datastr), false);
    data = *datastr;
  } else {
    auto type = memtype(ctx);
    CHECK_ERR(type);
    mtype = *type;
  }

  if (!ctx.in.takeRParen()) {
    return ctx.in.err("expected end of memory declaration");
  }

  CHECK_ERR(ctx.addMemory(name, *exports, import.getPtr(), *mtype, pos));

  if (data) {
    CHECK_ERR(ctx.addImplicitData(std::move(*data)));
  }

  return Ok{};
}

// global ::= '(' 'global' id? ('(' 'export' name ')')* gt:globaltype e:expr ')'
//          | '(' 'global' id? ('(' 'export' name ')')*
//                '(' 'import' mod:name nm:name ')' gt:globaltype ')'
template<typename Ctx> MaybeResult<> global(Ctx& ctx) {
  auto pos = ctx.in.getPos();
  if (!ctx.in.takeSExprStart("global"sv)) {
    return {};
  }

  Name name;
  if (auto id = ctx.in.takeID()) {
    name = *id;
  }

  auto exports = inlineExports(ctx.in);
  CHECK_ERR(exports);

  auto import = inlineImport(ctx.in);
  CHECK_ERR(import);

  auto type = globaltype(ctx);
  CHECK_ERR(type);

  std::optional<typename Ctx::ExprT> exp;
  if (!import) {
    auto e = expr(ctx);
    CHECK_ERR(e);
    exp = *e;
  }

  if (!ctx.in.takeRParen()) {
    return ctx.in.err("expected end of global");
  }

  CHECK_ERR(ctx.addGlobal(name, *exports, import.getPtr(), *type, exp, pos));
  return Ok{};
}

// datastring ::= (b:string)* => concat(b*)
template<typename Ctx> Result<typename Ctx::DataStringT> datastring(Ctx& ctx) {
  auto data = ctx.makeDataString();
  while (auto str = ctx.in.takeString()) {
    ctx.appendDataString(data, *str);
  }
  return data;
}

// data ::= '(' 'data' id? b*:datastring ')' => {init b*, mode passive}
//        | '(' 'data' id? x:memuse? ('(' 'offset' e:expr ')' | e:instr)
//               b*:datastring ')
//             => {init b*, mode active {memory x, offset e}}
template<typename Ctx> MaybeResult<> data(Ctx& ctx) {
  auto pos = ctx.in.getPos();
  if (!ctx.in.takeSExprStart("data"sv)) {
    return {};
  }

  Name name;
  if (auto id = ctx.in.takeID()) {
    name = *id;
  }

  auto mem = maybeMemuse(ctx);
  CHECK_ERR(mem);

  std::optional<typename Ctx::ExprT> offset;
  if (ctx.in.takeSExprStart("offset"sv)) {
    auto e = expr(ctx);
    CHECK_ERR(e);
    if (!ctx.in.takeRParen()) {
      return ctx.in.err("expected end of offset expression");
    }
    offset = *e;
  } else if (ctx.in.takeLParen()) {
    CHECK_ERR(instr(ctx));
    auto offsetExpr = ctx.makeExpr();
    CHECK_ERR(offsetExpr);
    offset = *offsetExpr;
    if (!ctx.in.takeRParen()) {
      return ctx.in.err("expected end of offset instruction");
    }
  }

  if (mem && !offset) {
    return ctx.in.err("expected offset for active segment");
  }

  auto str = datastring(ctx);
  CHECK_ERR(str);

  if (!ctx.in.takeRParen()) {
    return ctx.in.err("expected end of data segment");
  }

  CHECK_ERR(ctx.addData(name, mem.getPtr(), offset, std::move(*str), pos));

  return Ok{};
}

// modulefield ::= deftype
//               | import
//               | func
//               | table
//               | memory
//               | global
//               | export
//               | start
//               | elem
//               | data
template<typename Ctx> MaybeResult<> modulefield(Ctx& ctx) {
  if (auto t = ctx.in.peek(); !t || t->isRParen()) {
    return {};
  }
  if (auto res = deftype(ctx)) {
    CHECK_ERR(res);
    return Ok{};
  }
  if (auto res = func(ctx)) {
    CHECK_ERR(res);
    return Ok{};
  }
  if (auto res = memory(ctx)) {
    CHECK_ERR(res);
    return Ok{};
  }
  if (auto res = global(ctx)) {
    CHECK_ERR(res);
    return Ok{};
  }
  if (auto res = data(ctx)) {
    CHECK_ERR(res);
    return Ok{};
  }
  return ctx.in.err("unrecognized module field");
}

// module ::= '(' 'module' id? (m:modulefield)* ')'
//          | (m:modulefield)* eof
template<typename Ctx> Result<> module(Ctx& ctx) {
  bool outer = ctx.in.takeSExprStart("module"sv);

  if (outer) {
    if (auto id = ctx.in.takeID()) {
      ctx.wasm.name = *id;
    }
  }

  while (auto field = modulefield(ctx)) {
    CHECK_ERR(field);
  }

  if (outer && !ctx.in.takeRParen()) {
    return ctx.in.err("expected end of module");
  }

  return Ok{};
}

} // namespace wasm::WATParser

#endif // parser_parsers_h
