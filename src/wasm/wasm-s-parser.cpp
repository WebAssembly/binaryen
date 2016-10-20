/*
 * Copyright 2015 WebAssembly Community Group participants
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

#include "wasm-s-parser.h"

namespace wasm {

void SExpressionWasmBuilder::preParseFunctionType(Element& s) {
  IString id = s[0]->str();
  if (id == TYPE) return parseType(s);
  if (id != FUNC) return;
  size_t i = 1;
  Name name, exportName;
  i = parseFunctionNames(s, name, exportName);
  if (!name.is()) {
    // unnamed, use an index
    name = Name::fromInt(functionCounter);
  }
  functionNames.push_back(name);
  functionCounter++;
  FunctionType* type = nullptr;
  functionTypes[name] = none;
  std::vector<WasmType> params;
  for (;i < s.size(); i++) {
    Element& curr = *s[i];
    IString id = curr[0]->str();
    if (id == RESULT) {
      if (curr.size() > 2) throw ParseException("invalid result arity", curr.line, curr.col);
      functionTypes[name] = stringToWasmType(curr[1]->str());
    } else if (id == TYPE) {
      Name typeName = getFunctionTypeName(*curr[1]);
      if (!wasm.checkFunctionType(typeName)) throw ParseException("unknown function type", curr.line, curr.col);
      type = wasm.getFunctionType(typeName);
      functionTypes[name] = type->result;
    } else if (id == PARAM && curr.size() > 1) {
      Index j = 1;
      if (curr[j]->dollared()) {
        // dollared input symbols cannot be types
        params.push_back(stringToWasmType(curr[j + 1]->str(), true));
      } else {
        while (j < curr.size()) {
          params.push_back(stringToWasmType(curr[j++]->str(), true));
        }
      }
    }
  }
  if (!type) {
    // if no function type provided, generate one, but reuse a previous one with the
    // right structure if there is one.
    // see https://github.com/WebAssembly/spec/pull/301
    bool need = true;
    std::unique_ptr<FunctionType> functionType = make_unique<FunctionType>();
    functionType->result = functionTypes[name];
    functionType->params = std::move(params);
    for (auto& existing : wasm.functionTypes) {
      if (existing->structuralComparison(*functionType)) {
        need = false;
        break;
      }
    }
    if (need) {
      functionType->name = Name::fromInt(wasm.functionTypes.size());
      functionTypeNames.push_back(functionType->name);
      wasm.addFunctionType(functionType.release());
    }
  }
}


void SExpressionWasmBuilder::parseFunction(Element& s, bool preParseImport) {
  size_t i = 1;
  Name name, exportName;
  i = parseFunctionNames(s, name, exportName);
  if (!preParseImport) {
    if (!name.is()) {
      // unnamed, use an index
      name = Name::fromInt(functionCounter);
    }
    functionCounter++;
  } else {
    // just preparsing, functionCounter was incremented by preParseFunctionType
    if (!name.is()) {
      // unnamed, use an index
      name = functionNames[functionCounter - 1];
    }
  }
  if (exportName.is()) {
    auto ex = make_unique<Export>();
    ex->name = exportName;
    ex->value = name;
    ex->kind = ExternalKind::Function;
    if (wasm.checkExport(ex->name)) throw ParseException("duplicate export", s.line, s.col);
    wasm.addExport(ex.release());
  }
  Expression* body = nullptr;
  localIndex = 0;
  otherIndex = 0;
  brokeToAutoBlock = false;
  std::vector<NameType> typeParams; // we may have both params and a type. store the type info here
  std::vector<NameType> params;
  std::vector<NameType> vars;
  WasmType result = none;
  Name type;
  Block* autoBlock = nullptr; // we may need to add a block for the very top level
  Name importModule, importBase;
  auto makeFunction = [&]() {
    currFunction = std::unique_ptr<Function>(Builder(wasm).makeFunction(
        name,
        std::move(params),
        result,
        std::move(vars)
                                                                        ));
  };
  auto ensureAutoBlock = [&]() {
    if (!autoBlock) {
      autoBlock = allocator.alloc<Block>();
      autoBlock->list.push_back(body);
      body = autoBlock;
    }
  };
  for (;i < s.size(); i++) {
    Element& curr = *s[i];
    IString id = curr[0]->str();
    if (id == PARAM || id == LOCAL) {
      size_t j = 1;
      while (j < curr.size()) {
        IString name;
        WasmType type = none;
        if (!curr[j]->dollared()) { // dollared input symbols cannot be types
          type = stringToWasmType(curr[j]->str(), true);
        }
        if (type != none) {
          // a type, so an unnamed parameter
          name = Name::fromInt(localIndex);
        } else {
          name = curr[j]->str();
          type = stringToWasmType(curr[j+1]->str());
          j++;
        }
        j++;
        if (id == PARAM) {
          params.emplace_back(name, type);
        } else {
          vars.emplace_back(name, type);
        }
        localIndex++;
        currLocalTypes[name] = type;
      }
    } else if (id == RESULT) {
      if (curr.size() > 2) throw ParseException("invalid result arity", curr.line, curr.col);
      result = stringToWasmType(curr[1]->str());
    } else if (id == TYPE) {
      Name name = getFunctionTypeName(*curr[1]);
      type = name;
      if (!wasm.checkFunctionType(name)) throw ParseException("unknown function type");
      FunctionType* type = wasm.getFunctionType(name);
      result = type->result;
      for (size_t j = 0; j < type->params.size(); j++) {
        IString name = Name::fromInt(j);
        WasmType currType = type->params[j];
        typeParams.emplace_back(name, currType);
        currLocalTypes[name] = currType;
      }
    } else if (id == IMPORT) {
      importModule = curr[1]->str();
      importBase = curr[2]->str();
    } else {
      // body
      if (typeParams.size() > 0 && params.size() == 0) {
        params = typeParams;
      }
      if (!currFunction) makeFunction();
      Expression* ex = parseExpression(curr);
      if (!body) {
        body = ex;
      } else {
        ensureAutoBlock();
        autoBlock->list.push_back(ex);
      }
    }
  }
  // see https://github.com/WebAssembly/spec/pull/301
  if (type.isNull()) {
    // if no function type name provided, then we generated one
    std::unique_ptr<FunctionType> functionType = std::unique_ptr<FunctionType>(sigToFunctionType(getSigFromStructs(result, params)));
    for (auto& existing : wasm.functionTypes) {
      if (existing->structuralComparison(*functionType)) {
        type = existing->name;
        break;
      }
    }
    if (!type.is()) throw ParseException("no function type [internal error?]", s.line, s.col);
  }
  if (importModule.is()) {
    // this is an import, actually
    assert(preParseImport);
    std::unique_ptr<Import> im = make_unique<Import>();
    im->name = name;
    im->module = importModule;
    im->base = importBase;
    im->kind = ExternalKind::Function;
    im->functionType = wasm.getFunctionType(type);
    wasm.addImport(im.release());
    assert(!currFunction);
    currLocalTypes.clear();
    nameMapper.clear();
    return;
  }
  assert(!preParseImport);
  if (brokeToAutoBlock) {
    ensureAutoBlock();
    autoBlock->name = FAKE_RETURN;
  }
  if (autoBlock) {
    autoBlock->finalize(result);
  }
  if (!currFunction) {
    makeFunction();
    body = allocator.alloc<Nop>();
  }
  if (currFunction->result != result) throw ParseException("bad func declaration", s.line, s.col);
  currFunction->body = body;
  currFunction->type = type;
  wasm.addFunction(currFunction.release());
  currLocalTypes.clear();
  nameMapper.clear();
}


Expression* SExpressionWasmBuilder::parseExpression(Element& s) {
  element_assert(s.isList(), s);
  IString id = s[0]->str();
  const char *str = id.str;
  const char *dot = strchr(str, '.');
  if (dot) {
    // type.operation (e.g. i32.add)
    WasmType type = stringToWasmType(str, false, true);
    // Local copy to index into op without bounds checking.
    enum { maxNameSize = 15 };
    char op[maxNameSize + 1] = {'\0'};
    strncpy(op, dot + 1, maxNameSize);
#define BINARY_INT_OR_FLOAT(op) (type == i32 ? BinaryOp::op##Int32 : (type == i64 ? BinaryOp::op##Int64 : (type == f32 ? BinaryOp::op##Float32 : BinaryOp::op##Float64)))
#define BINARY_INT(op) (type == i32 ? BinaryOp::op##Int32 : BinaryOp::op##Int64)
#define BINARY_FLOAT(op) (type == f32 ? BinaryOp::op##Float32 : BinaryOp::op##Float64)
    switch (op[0]) {
      case 'a': {
        if (op[1] == 'b') return makeUnary(s, type == f32 ? UnaryOp::AbsFloat32 : UnaryOp::AbsFloat64, type);
        if (op[1] == 'd') return makeBinary(s, BINARY_INT_OR_FLOAT(Add), type);
        if (op[1] == 'n') return makeBinary(s, BINARY_INT(And), type);
        abort_on(op);
      }
      case 'c': {
        if (op[1] == 'e') return makeUnary(s, type == f32 ? UnaryOp::CeilFloat32 : UnaryOp::CeilFloat64, type);
        if (op[1] == 'l') return makeUnary(s, type == i32 ? UnaryOp::ClzInt32 : UnaryOp::ClzInt64, type);
        if (op[1] == 'o') {
          if (op[2] == 'p') return makeBinary(s, BINARY_FLOAT(CopySign), type);
          if (op[2] == 'n') {
            if (op[3] == 'v') {
              if (op[8] == 's') return makeUnary(s, op[11] == '3' ? (type == f32 ? UnaryOp::ConvertSInt32ToFloat32 : UnaryOp::ConvertSInt32ToFloat64) : (type == f32 ? UnaryOp::ConvertSInt64ToFloat32 : UnaryOp::ConvertSInt64ToFloat64), type);
              if (op[8] == 'u') return makeUnary(s, op[11] == '3' ? (type == f32 ? UnaryOp::ConvertUInt32ToFloat32 : UnaryOp::ConvertUInt32ToFloat64) : (type == f32 ? UnaryOp::ConvertUInt64ToFloat32 : UnaryOp::ConvertUInt64ToFloat64), type);
            }
            if (op[3] == 's') return makeConst(s, type);
          }
        }
        if (op[1] == 't') return makeUnary(s, type == i32 ? UnaryOp::CtzInt32 : UnaryOp::CtzInt64, type);
        abort_on(op);
      }
      case 'd': {
        if (op[1] == 'i') {
          if (op[3] == '_') return makeBinary(s, op[4] == 'u' ? BINARY_INT(DivU) : BINARY_INT(DivS), type);
          if (op[3] == 0) return makeBinary(s, BINARY_FLOAT(Div), type);
        }
        if (op[1] == 'e') return makeUnary(s, UnaryOp::DemoteFloat64, type);
        abort_on(op);
      }
      case 'e': {
        if (op[1] == 'q') {
          if (op[2] == 0) return makeBinary(s, BINARY_INT_OR_FLOAT(Eq), type);
          if (op[2] == 'z') return makeUnary(s, type == i32 ? UnaryOp::EqZInt32 : UnaryOp::EqZInt64, type);
        }
        if (op[1] == 'x') return makeUnary(s, op[7] == 'u' ? UnaryOp::ExtendUInt32 : UnaryOp::ExtendSInt32, type);
        abort_on(op);
      }
      case 'f': {
        if (op[1] == 'l') return makeUnary(s, type == f32 ? UnaryOp::FloorFloat32 : UnaryOp::FloorFloat64, type);
        abort_on(op);
      }
      case 'g': {
        if (op[1] == 't') {
          if (op[2] == '_') return makeBinary(s, op[3] == 'u' ? BINARY_INT(GtU) : BINARY_INT(GtS), type);
          if (op[2] == 0) return makeBinary(s, BINARY_FLOAT(Gt), type);
        }
        if (op[1] == 'e') {
          if (op[2] == '_') return makeBinary(s, op[3] == 'u' ? BINARY_INT(GeU) : BINARY_INT(GeS), type);
          if (op[2] == 0) return makeBinary(s, BINARY_FLOAT(Ge), type);
        }
        abort_on(op);
      }
      case 'l': {
        if (op[1] == 't') {
          if (op[2] == '_') return makeBinary(s, op[3] == 'u' ? BINARY_INT(LtU) : BINARY_INT(LtS), type);
          if (op[2] == 0) return makeBinary(s, BINARY_FLOAT(Lt), type);
        }
        if (op[1] == 'e') {
          if (op[2] == '_') return makeBinary(s, op[3] == 'u' ? BINARY_INT(LeU) : BINARY_INT(LeS), type);
          if (op[2] == 0) return makeBinary(s, BINARY_FLOAT(Le), type);
        }
        if (op[1] == 'o') return makeLoad(s, type);
        abort_on(op);
      }
      case 'm': {
        if (op[1] == 'i') return makeBinary(s, BINARY_FLOAT(Min), type);
        if (op[1] == 'a') return makeBinary(s, BINARY_FLOAT(Max), type);
        if (op[1] == 'u') return makeBinary(s, BINARY_INT_OR_FLOAT(Mul), type);
        abort_on(op);
      }
      case 'n': {
        if (op[1] == 'e') {
          if (op[2] == 0) return makeBinary(s, BINARY_INT_OR_FLOAT(Ne), type);
          if (op[2] == 'a') return makeUnary(s, type == f32 ? UnaryOp::NearestFloat32 : UnaryOp::NearestFloat64, type);
          if (op[2] == 'g') return makeUnary(s, type == f32 ? UnaryOp::NegFloat32 : UnaryOp::NegFloat64, type);
        }
        abort_on(op);
      }
      case 'o': {
        if (op[1] == 'r') return makeBinary(s, BINARY_INT(Or), type);
        abort_on(op);
      }
      case 'p': {
        if (op[1] == 'r') return makeUnary(s,  UnaryOp::PromoteFloat32, type);
        if (op[1] == 'o') return makeUnary(s, type == i32 ? UnaryOp::PopcntInt32 : UnaryOp::PopcntInt64, type);
        abort_on(op);
      }
      case 'r': {
        if (op[1] == 'e') {
          if (op[2] == 'm') return makeBinary(s, op[4] == 'u' ? BINARY_INT(RemU) : BINARY_INT(RemS), type);
          if (op[2] == 'i') return makeUnary(s, isWasmTypeFloat(type) ? (type == f32 ? UnaryOp::ReinterpretInt32 : UnaryOp::ReinterpretInt64) : (type == i32 ? UnaryOp::ReinterpretFloat32 : UnaryOp::ReinterpretFloat64), type);
        }
        if (op[1] == 'o' && op[2] == 't') {
          return makeBinary(s, op[3] == 'l' ? BINARY_INT(RotL) : BINARY_INT(RotR), type);
        }
        abort_on(op);
      }
      case 's': {
        if (op[1] == 'h') {
          if (op[2] == 'l') return makeBinary(s, BINARY_INT(Shl), type);
          return makeBinary(s, op[4] == 'u' ? BINARY_INT(ShrU) : BINARY_INT(ShrS), type);
        }
        if (op[1] == 'u') return makeBinary(s, BINARY_INT_OR_FLOAT(Sub), type);
        if (op[1] == 'q') return makeUnary(s, type == f32 ? UnaryOp::SqrtFloat32 : UnaryOp::SqrtFloat64, type);
        if (op[1] == 't') return makeStore(s, type);
        abort_on(op);
      }
      case 't': {
        if (op[1] == 'r') {
          if (op[6] == 's') return makeUnary(s, op[9] == '3' ? (type == i32 ? UnaryOp::TruncSFloat32ToInt32 : UnaryOp::TruncSFloat32ToInt64) : (type == i32 ? UnaryOp::TruncSFloat64ToInt32 : UnaryOp::TruncSFloat64ToInt64), type);
          if (op[6] == 'u') return makeUnary(s, op[9] == '3' ? (type == i32 ? UnaryOp::TruncUFloat32ToInt32 : UnaryOp::TruncUFloat32ToInt64) : (type == i32 ? UnaryOp::TruncUFloat64ToInt32 : UnaryOp::TruncUFloat64ToInt64), type);
          if (op[2] == 'u') return makeUnary(s, type == f32 ? UnaryOp::TruncFloat32 : UnaryOp::TruncFloat64, type);
        }
        abort_on(op);
      }
      case 'w': {
        if (op[1] == 'r') return makeUnary(s,  UnaryOp::WrapInt64, type);
        abort_on(op);
      }
      case 'x': {
        if (op[1] == 'o') return makeBinary(s, BINARY_INT(Xor), type);
        abort_on(op);
      }
      default: abort_on(op);
    }
  } else {
    // other expression
    switch (str[0]) {
      case 'b': {
        if (str[1] == 'l') return makeBlock(s);
        if (str[1] == 'r') {
          if (str[2] == '_' && str[3] == 't') return makeBreakTable(s);
          return makeBreak(s);
        }
        abort_on(str);
      }
      case 'c': {
        if (str[1] == 'a') {
          if (id == CALL) return makeCall(s);
          if (id == CALL_IMPORT) return makeCallImport(s);
          if (id == CALL_INDIRECT) return makeCallIndirect(s);
        } else if (str[1] == 'u') return makeHost(s, HostOp::CurrentMemory);
        abort_on(str);
      }
      case 'd': {
        if (str[1] == 'r') return makeDrop(s);
        abort_on(str);
      }
      case 'e': {
        if (str[1] == 'l') return makeThenOrElse(s);
        abort_on(str);
      }
      case 'g': {
        if (str[1] == 'e') {
          if (str[4] == 'l') return makeGetLocal(s);
          if (str[4] == 'g') return makeGetGlobal(s);
        }
        if (str[1] == 'r') return makeHost(s, HostOp::GrowMemory);
        abort_on(str);
      }
      case 'h': {
        if (str[1] == 'a') return makeHost(s, HostOp::HasFeature);
        abort_on(str);
      }
      case 'i': {
        if (str[1] == 'f') return makeIf(s);
        abort_on(str);
      }
      case 'l': {
        if (str[1] == 'o') return makeLoop(s);
        abort_on(str);
      }
      case 'n': {
        if (str[1] == 'o') return allocator.alloc<Nop>();
        abort_on(str);
      }
      case 'p': {
        if (str[1] == 'a') return makeHost(s, HostOp::PageSize);
        abort_on(str);
      }
      case 's': {
        if (str[1] == 'e' && str[2] == 't') {
          if (str[4] == 'l') return makeSetLocal(s);
          if (str[4] == 'g') return makeSetGlobal(s);
        }
        if (str[1] == 'e' && str[2] == 'l') return makeSelect(s);
        abort_on(str);
      }
      case 'r': {
        if (str[1] == 'e') return makeReturn(s);
        abort_on(str);
      }
      case 't': {
        if (str[1] == 'h') return makeThenOrElse(s);
        if (str[1] == 'e' && str[2] == 'e') return makeTeeLocal(s);
        abort_on(str);
      }
      case 'u': {
        if (str[1] == 'n') return allocator.alloc<Unreachable>();
        abort_on(str);
      }
      default: abort_on(str);
    }
  }
  abort();
}


} // namespace wasm
