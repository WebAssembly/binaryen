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

//
// Parses WebAssembly code in S-Expression format, as in .wast files
// such as are in the spec test suite.
//

#ifndef wasm_wasm_s_parser_h
#define wasm_wasm_s_parser_h

#include <cmath>
#include <cctype>
#include <limits>

#include "wasm.h"
#include "wasm-binary.h"
#include "shared-constants.h"
#include "asmjs/shared-constants.h"
#include "mixed_arena.h"
#include "parsing.h"
#include "asm_v_wasm.h"
#include "ast_utils.h"
#include "wasm-builder.h"

namespace wasm {

using namespace cashew;

// Globals

inline int unhex(char c) {
  if (c >= '0' && c <= '9') return c - '0';
  if (c >= 'a' && c <= 'f') return c - 'a' + 10;
  if (c >= 'A' && c <= 'F') return c - 'A' + 10;
  abort();
}

//
// An element in an S-Expression: a list or a string
//

class Element {
  typedef ArenaVector<Element*> List;

  bool isList_;
  List list_;
  IString str_;
  bool dollared_;
  bool quoted_;

public:
  Element(MixedArena& allocator) : isList_(true), list_(allocator), line(-1), col(-1) {}

  bool isList() { return isList_; }
  bool isStr() { return !isList_; }
  bool dollared() { return dollared_; }
  bool quoted() { return quoted_; }

  size_t line, col;

  // list methods

  List& list() {
    if (!isList()) throw ParseException("expected list", line, col);
    return list_;
  }

  Element* operator[](unsigned i) {
    if (i >= list().size()) throw ParseException("expected more elements in list", line, col);
    return list()[i];
  }

  size_t size() {
    return list().size();
  }

  // string methods

  IString str() {
    assert(!isList_);
    return str_;
  }

  const char* c_str() {
    assert(!isList_);
    return str_.str;
  }

  Element* setString(IString str__, bool dollared__, bool quoted__) {
    isList_ = false;
    str_ = str__;
    dollared_ = dollared__;
    quoted_ = quoted__;
    return this;
  }

  Element* setMetadata(size_t line_, size_t col_) {
    line = line_;
    col = col_;
    return this;
  }

  // printing

  friend std::ostream& operator<<(std::ostream& o, Element& e) {
    if (e.isList_) {
      o << '(';
      for (auto item : e.list_) o << ' ' << *item;
      o << " )";
    } else {
      o << e.str_.str;
    }
    return o;
  }

  void dump() {
    std::cout << "dumping " << this << " : " << *this << ".\n";
  }
};

//
// Generic S-Expression parsing into lists
//

class SExpressionParser {
  char* input;
  size_t line;
  char* lineStart;

  MixedArena allocator;

public:
  // Assumes control of and modifies the input.
  SExpressionParser(char* input) : input(input) {
    root = nullptr;
    line = 0;
    lineStart = input;
    while (!root) { // keep parsing until we pass an initial comment
      root = parse();
    }
  }

  Element* root;

private:
  Element* parse() {
    std::vector<Element *> stack;
    Element *curr = allocator.alloc<Element>();
    while (1) {
      skipWhitespace();
      if (input[0] == 0) break;
      if (input[0] == '(') {
        input++;
        stack.push_back(curr);
        curr = allocator.alloc<Element>()->setMetadata(line, input - lineStart - 1);
      } else if (input[0] == ')') {
        input++;
        auto last = curr;
        curr = stack.back();
        assert(stack.size());
        stack.pop_back();
        curr->list().push_back(last);
      } else {
        curr->list().push_back(parseString());
      }
    }
    if (stack.size() != 0) throw ParseException("stack is not empty", curr->line, curr->col);
    return curr;
  }

  void skipWhitespace() {
    while (1) {
      while (isspace(input[0])) {
        if (input[0] == '\n') {
          line++;
          lineStart = input + 1;
        }
        input++;
      }
      if (input[0] == ';' && input[1] == ';') {
        while (input[0] && input[0] != '\n') input++;
        line++;
        lineStart = input;
      } else if (input[0] == '(' && input[1] == ';') {
        // Skip nested block comments.
        input += 2;
        int depth = 1;
        while (1) {
          if (input[0] == 0) {
            return;
          }
          if (input[0] == '(' && input[1] == ';') {
            input += 2;
            depth++;
          } else if (input[0] == ';' && input[1] == ')') {
            input += 2;
            --depth;
            if (depth == 0) {
              break;
            }
          } else {
            input++;
          }
        }
      } else {
        return;
      }
    }
  }

  Element* parseString() {
    bool dollared = false;
    if (input[0] == '$') {
      input++;
      dollared = true;
    }
    char *start = input;
    if (input[0] == '"') {
      // parse escaping \", but leave code escaped - we'll handle escaping in memory segments specifically
      input++;
      std::string str;
      while (1) {
        if (input[0] == '"') break;
        if (input[0] == '\\') {
          str += input[0];
          str += input[1];
          input += 2;
          continue;
        }
        str += input[0];
        input++;
      }
      input++;
      return allocator.alloc<Element>()->setString(IString(str.c_str(), false), dollared, true)->setMetadata(line, start - lineStart);
    }
    while (input[0] && !isspace(input[0]) && input[0] != ')' && input[0] != '(' && input[0] != ';') input++;
    if (start == input) throw ParseException("expected string", line, input - lineStart);
    char temp = input[0];
    input[0] = 0;
    auto ret = allocator.alloc<Element>()->setString(IString(start, false), dollared, false)->setMetadata(line, start - lineStart);
    input[0] = temp;
    return ret;
  }
};

//
// SExpressions => WebAssembly module
//

class SExpressionWasmBuilder {
  Module& wasm;
  MixedArena& allocator;
  std::vector<Name> functionNames;
  int functionCounter;
  int importCounter;
  int globalCounter;
  std::map<Name, WasmType> functionTypes; // we need to know function return types before we parse their contents

public:
  // Assumes control of and modifies the input.
  SExpressionWasmBuilder(Module& wasm, Element& module) : wasm(wasm), allocator(wasm.allocator), importCounter(0), globalCounter(0) {
    assert(module[0]->str() == MODULE);
    if (module.size() > 1 && module[1]->isStr()) {
      // these s-expressions contain a binary module, actually
      std::vector<char> data;
      size_t i = 1;
      while (i < module.size()) {
        auto str = module[i++]->c_str();
        if (auto size = strlen(str)) {
          stringToBinary(str, size, data);
        }
      }
      WasmBinaryBuilder binaryBuilder(wasm, data, false);
      binaryBuilder.read();
      return;
    }
    functionCounter = 0;
    for (unsigned i = 1; i < module.size(); i++) {
      preParseFunctionType(*module[i]);
      preParseImports(*module[i]);
    }
    functionCounter = 0;
    for (unsigned i = 1; i < module.size(); i++) {
      parseModuleElement(*module[i]);
    }
  }

private:

  // pre-parse types and function definitions, so we know function return types before parsing their contents
  void preParseFunctionType(Element& s) {
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
        Name typeName = curr[1]->str();
        if (!wasm.checkFunctionType(typeName)) throw ParseException("unknown function", curr.line, curr.col);
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
        wasm.addFunctionType(functionType.release());
      }
    }
  }

  void preParseImports(Element& curr) {
    IString id = curr[0]->str();
    if (id == IMPORT) parseImport(curr);
  }

  void parseModuleElement(Element& curr) {
    IString id = curr[0]->str();
    if (id == START) return parseStart(curr);
    if (id == FUNC) return parseFunction(curr);
    if (id == MEMORY) return parseMemory(curr);
    if (id == DATA) return parseData(curr);
    if (id == EXPORT) return parseExport(curr);
    if (id == IMPORT) return; // already done
    if (id == GLOBAL) return parseGlobal(curr);
    if (id == TABLE) return parseTable(curr);
    if (id == ELEM) return parseElem(curr);
    if (id == TYPE) return; // already done
    std::cerr << "bad module element " << id.str << '\n';
    throw ParseException("unknown module element", curr.line, curr.col);
  }

  // function parsing state
  std::unique_ptr<Function> currFunction;
  std::map<Name, WasmType> currLocalTypes;
  size_t localIndex; // params and vars
  size_t otherIndex;
  std::vector<Name> labelStack;
  bool brokeToAutoBlock;

  Name getPrefixedName(std::string prefix) {
    // make sure to return a unique name not already on the stack
    while (1) {
      Name ret = IString((prefix + std::to_string(otherIndex++)).c_str(), false);
      if (std::find(labelStack.begin(), labelStack.end(), ret) == labelStack.end()) return ret;
    }
  }

  Name getFunctionName(Element& s) {
    if (s.dollared()) {
      return s.str();
    } else {
      // index
      size_t offset = atoi(s.str().c_str());
      if (offset >= functionNames.size()) throw ParseException("unknown function");
      return functionNames[offset];
    }
  }

  void parseStart(Element& s) {
    wasm.addStart(getFunctionName(*s[1]));
  }

  // returns the next index in s
  size_t parseFunctionNames(Element& s, Name& name, Name& exportName) {
    size_t i = 1;
    while (i < s.size() && i < 3 && s[i]->isStr()) {
      if (s[i]->quoted()) {
        // an export name
        exportName = s[i]->str();
        i++;
      } else if (s[i]->dollared()) {
        name = s[i]->str();
        i++;
      } else {
        break;
      }
    }
    return i;
  }

  void parseFunction(Element& s) {
    size_t i = 1;
    Name name, exportName;
    i = parseFunctionNames(s, name, exportName);
    if (!name.is()) {
      // unnamed, use an index
      name = Name::fromInt(functionCounter);
    }
    if (exportName.is()) {
      auto ex = make_unique<Export>();
      ex->name = exportName;
      ex->value = name;
      ex->kind = Export::Function;
      wasm.addExport(ex.release());
    }
    functionCounter++;
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
        Name name = curr[1]->str();
        type = name;
        if (!wasm.checkFunctionType(name)) throw ParseException("unknown function");
        FunctionType* type = wasm.getFunctionType(name);
        result = type->result;
        for (size_t j = 0; j < type->params.size(); j++) {
          IString name = Name::fromInt(j);
          WasmType currType = type->params[j];
          typeParams.emplace_back(name, currType);
          currLocalTypes[name] = currType;
        }
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
    if (brokeToAutoBlock) {
      ensureAutoBlock();
      autoBlock->name = FAKE_RETURN;
    }
    if (autoBlock) {
      autoBlock->finalize();
    }
    if (!currFunction) {
      makeFunction();
      body = allocator.alloc<Nop>();
    }
    if (currFunction->result != result) throw ParseException("bad func declaration", s.line, s.col);
    // see https://github.com/WebAssembly/spec/pull/301
    if (type.isNull()) {
      // if no function type name provided, then we generated one
      std::unique_ptr<FunctionType> functionType = std::unique_ptr<FunctionType>(sigToFunctionType(getSig(currFunction.get())));
      for (auto& existing : wasm.functionTypes) {
        if (existing->structuralComparison(*functionType)) {
          type = existing->name;
          break;
        }
      }
      if (!type.is()) throw ParseException("no function type [internal error?]", s.line, s.col);
    }
    currFunction->body = body;
    currFunction->type = type;

    wasm.addFunction(currFunction.release());
    currLocalTypes.clear();
    labelStack.clear();
  }

  WasmType stringToWasmType(IString str, bool allowError=false, bool prefix=false) {
    return stringToWasmType(str.str, allowError, prefix);
  }

  WasmType stringToWasmType(const char* str, bool allowError=false, bool prefix=false) {
    if (str[0] == 'i') {
      if (str[1] == '3' && str[2] == '2' && (prefix || str[3] == 0)) return i32;
      if (str[1] == '6' && str[2] == '4' && (prefix || str[3] == 0)) return i64;
    }
    if (str[0] == 'f') {
      if (str[1] == '3' && str[2] == '2' && (prefix || str[3] == 0)) return f32;
      if (str[1] == '6' && str[2] == '4' && (prefix || str[3] == 0)) return f64;
    }
    if (allowError) return none;
    abort();
  }

public:
  Expression* parseExpression(Element* s) {
    return parseExpression(*s);
  }

  #define abort_on(str) { throw ParseException(std::string("abort_on ") + str); }

  Expression* parseExpression(Element& s) {
    if (!s.isList()) throw ParseException("invalid node for parseExpression, needed list", s.line, s.col);
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

private:
  Expression* makeBinary(Element& s, BinaryOp op, WasmType type) {
    auto ret = allocator.alloc<Binary>();
    ret->op = op;
    ret->left = parseExpression(s[1]);
    ret->right = parseExpression(s[2]);
    ret->finalize();
    return ret;
  }

  Expression* makeUnary(Element& s, UnaryOp op, WasmType type) {
    auto ret = allocator.alloc<Unary>();
    ret->op = op;
    ret->value = parseExpression(s[1]);
    ret->finalize();
    // type is the reported type, e.g. i64.ctz reports i64 (but has a return type of i32, in this case)
    // verify the reported type is correct
    switch (op) {
      case EqZInt32:
      case NegFloat32:
      case AbsFloat32:
      case CeilFloat32:
      case FloorFloat32:
      case TruncFloat32:
      case NearestFloat32:
      case SqrtFloat32:
      case ClzInt32:
      case CtzInt32:
      case PopcntInt32:
      case EqZInt64:
      case NegFloat64:
      case AbsFloat64:
      case CeilFloat64:
      case FloorFloat64:
      case TruncFloat64:
      case NearestFloat64:
      case SqrtFloat64:
      case ClzInt64:
      case CtzInt64:
      case PopcntInt64: {
        if (ret->value->type != unreachable && type != ret->value->type) throw ParseException(std::string("bad type for ") + getExpressionName(ret) + ": " + printWasmType(type) + " vs value type " + printWasmType(ret->value->type), s.line, s.col);
        break;
      }
      case ExtendSInt32: case ExtendUInt32:
      case WrapInt64:
      case PromoteFloat32:
      case DemoteFloat64:
      case TruncSFloat32ToInt32:
      case TruncUFloat32ToInt32:
      case TruncSFloat64ToInt32:
      case TruncUFloat64ToInt32:
      case ReinterpretFloat32:
      case TruncSFloat32ToInt64:
      case TruncUFloat32ToInt64:
      case TruncSFloat64ToInt64:
      case TruncUFloat64ToInt64:
      case ReinterpretFloat64:
      case ReinterpretInt32:
      case ConvertSInt32ToFloat32:
      case ConvertUInt32ToFloat32:
      case ConvertSInt64ToFloat32:
      case ConvertUInt64ToFloat32:
      case ReinterpretInt64:
      case ConvertSInt32ToFloat64:
      case ConvertUInt32ToFloat64:
      case ConvertSInt64ToFloat64:
      case ConvertUInt64ToFloat64: break;
      default: WASM_UNREACHABLE();
    }
    return ret;
  }

  Expression* makeSelect(Element& s) {
    auto ret = allocator.alloc<Select>();
    ret->ifTrue = parseExpression(s[1]);
    ret->ifFalse = parseExpression(s[2]);
    ret->condition = parseExpression(s[3]);
    ret->finalize();
    return ret;
  }

  Expression* makeDrop(Element& s) {
    auto ret = allocator.alloc<Drop>();
    ret->value = parseExpression(s[1]);
    ret->finalize();
    return ret;
  }

  Expression* makeHost(Element& s, HostOp op) {
    auto ret = allocator.alloc<Host>();
    ret->op = op;
    if (op == HostOp::HasFeature) {
      ret->nameOperand = s[1]->str();
    } else {
      parseCallOperands(s, 1, s.size(), ret);
    }
    ret->finalize();
    return ret;
  }

  Index getLocalIndex(Element& s) {
    if (!currFunction) throw ParseException("local access in non-function scope", s.line, s.col);
    if (s.dollared()) {
      auto ret = s.str();
      if (currFunction->localIndices.count(ret) == 0) throw ParseException("bad local name", s.line, s.col);
      return currFunction->getLocalIndex(ret);
    }
    // this is a numeric index
    Index ret = atoi(s.c_str());
    if (ret >= currFunction->getNumLocals()) throw ParseException("bad local index", s.line, s.col);
    return ret;
  }

  Expression* makeGetLocal(Element& s) {
    auto ret = allocator.alloc<GetLocal>();
    ret->index = getLocalIndex(*s[1]);
    ret->type = currFunction->getLocalType(ret->index);
    return ret;
  }

  Expression* makeTeeLocal(Element& s) {
    auto ret = allocator.alloc<SetLocal>();
    ret->index = getLocalIndex(*s[1]);
    ret->value = parseExpression(s[2]);
    ret->setTee(true);
    return ret;
  }
  Expression* makeSetLocal(Element& s) {
    auto ret = allocator.alloc<SetLocal>();
    ret->index = getLocalIndex(*s[1]);
    ret->value = parseExpression(s[2]);
    ret->setTee(false);
    return ret;
  }

  Expression* makeGetGlobal(Element& s) {
    auto ret = allocator.alloc<GetGlobal>();
    ret->name = s[1]->str();
    auto* global = wasm.checkGlobal(ret->name);
    if (!global) throw ParseException("bad get_global name", s.line, s.col);
    ret->type = global->type;
    return ret;
  }

  Expression* makeSetGlobal(Element& s) {
    auto ret = allocator.alloc<SetGlobal>();
    ret->name = s[1]->str();
    ret->value = parseExpression(s[2]);
    return ret;
  }

  Expression* makeBlock(Element& s) {
    // special-case Block, because Block nesting (in their first element) can be incredibly deep
    auto curr = allocator.alloc<Block>();
    auto* sp = &s;
    std::vector<std::pair<Element*, Block*>> stack;
    while (1) {
      stack.emplace_back(sp, curr);
      auto& s = *sp;
      size_t i = 1;
      if (i < s.size() && s[i]->isStr()) {
        curr->name = s[i]->str();
        i++;
      } else {
        curr->name = getPrefixedName("block");
      }
      labelStack.push_back(curr->name);
      if (i >= s.size()) break; // labeled empty block
      auto& first = *s[i];
      if (first[0]->str() == BLOCK) {
        // recurse
        curr = allocator.alloc<Block>();
        sp = &first;
        continue;
      }
      break;
    }
    // we now have a stack of Blocks, with their labels, but no contents yet
    for (int t = int(stack.size()) - 1; t >= 0; t--) {
      auto* sp = stack[t].first;
      auto* curr = stack[t].second;
      auto& s = *sp;
      size_t i = 1;
      if (i < s.size()) {
        if (s[i]->isStr()) {
          i++;
        }
        if (t < int(stack.size()) - 1) {
          // first child is one of our recursions
          curr->list.push_back(stack[t + 1].second);
          i++;
        }
        for (; i < s.size(); i++) {
          curr->list.push_back(parseExpression(s[i]));
        }
      }
      assert(labelStack.back() == curr->name);
      labelStack.pop_back();
      curr->finalize();
    }
    return stack[0].second;
  }

  // Similar to block, but the label is handled by the enclosing if (since there might not be a then or else, ick)
  Expression* makeThenOrElse(Element& s) {
    auto ret = allocator.alloc<Block>();
    size_t i = 1;
    if (s[1]->isStr()) {
      i++;
    }
    for (; i < s.size(); i++) {
      ret->list.push_back(parseExpression(s[i]));
    }
    ret->finalize();
    return ret;
  }

  Expression* makeConst(Element& s, WasmType type) {
    auto ret = parseConst(s[1]->str(), type, allocator);
    if (!ret) throw ParseException("bad const");
    return ret;
  }

  Expression* makeLoad(Element& s, WasmType type) {
    const char *extra = strchr(s[0]->c_str(), '.') + 5; // after "type.load"
    auto ret = allocator.alloc<Load>();
    ret->type = type;
    ret->bytes = getWasmTypeSize(type);
    if (extra[0] == '8') {
      ret->bytes = 1;
      extra++;
    } else if (extra[0] == '1') {
      assert(extra[1] == '6');
      ret->bytes = 2;
      extra += 2;
    } else if (extra[0] == '3') {
      assert(extra[1] == '2');
      ret->bytes = 4;
      extra += 2;
    }
    ret->signed_ = extra[0] && extra[1] == 's';
    size_t i = 1;
    ret->offset = 0;
    ret->align = ret->bytes;
    while (!s[i]->isList()) {
      const char *str = s[i]->c_str();
      const char *eq = strchr(str, '=');
      assert(eq);
      eq++;
      if (str[0] == 'a') {
        ret->align = atoi(eq);
      } else if (str[0] == 'o') {
        uint64_t offset = atoll(eq);
        if (offset > std::numeric_limits<uint32_t>::max()) throw ParseException("bad offset");
        ret->offset = (uint32_t)offset;
      } else throw ParseException("bad load attribute");
      i++;
    }
    ret->ptr = parseExpression(s[i]);
    return ret;
  }

  Expression* makeStore(Element& s, WasmType type) {
    const char *extra = strchr(s[0]->c_str(), '.') + 6; // after "type.store"
    auto ret = allocator.alloc<Store>();
    ret->valueType = type;
    ret->bytes = getWasmTypeSize(type);
    if (extra[0] == '8') {
      ret->bytes = 1;
      extra++;
    } else if (extra[0] == '1') {
      assert(extra[1] == '6');
      ret->bytes = 2;
      extra += 2;
    } else if (extra[0] == '3') {
      assert(extra[1] == '2');
      ret->bytes = 4;
      extra += 2;
    }
    size_t i = 1;
    ret->offset = 0;
    ret->align = ret->bytes;
    while (!s[i]->isList()) {
      const char *str = s[i]->c_str();
      const char *eq = strchr(str, '=');
      assert(eq);
      eq++;
      if (str[0] == 'a') {
        ret->align = atoi(eq);
      } else if (str[0] == 'o') {
        ret->offset = atoi(eq);
      } else throw ParseException("bad store attribute");
      i++;
    }
    ret->ptr = parseExpression(s[i]);
    ret->value = parseExpression(s[i+1]);
    ret->finalize();
    return ret;
  }

  Expression* makeIf(Element& s) {
    auto ret = allocator.alloc<If>();
    ret->condition = parseExpression(s[1]);

    // ifTrue and ifFalse may get implicit blocks
    auto handle = [&](const char* title, Element& s) {
      Name name = getPrefixedName(title);
      bool explicitThenElse = false;
      if (s[0]->str() == THEN || s[0]->str() == ELSE) {
        explicitThenElse = true;
        if (s[1]->isStr() && s[1]->dollared()) {
          name = s[1]->str();
        }
      }
      labelStack.push_back(name);
      auto* ret = parseExpression(&s);
      labelStack.pop_back();
      if (explicitThenElse) {
        ret->dynCast<Block>()->name = name;
      } else {
        // add a block if we must
        if (BreakSeeker::has(ret, name)) {
          auto* block = allocator.alloc<Block>();
          block->name = name;
          block->list.push_back(ret);
          block->finalize();
          ret = block;
        }
      }
      return ret;
    };

    ret->ifTrue = handle("if-true", *s[2]);
    if (s.size() == 4) {
      ret->ifFalse = handle("if-else", *s[3]);
      ret->finalize();
    }
    return ret;
  }

  Expression* makeMaybeBlock(Element& s, size_t i, size_t stopAt=-1) {
    if (s.size() == i) return allocator.alloc<Nop>();
    if (s.size() == i+1) return parseExpression(s[i]);
    auto ret = allocator.alloc<Block>();
    for (; i < s.size() && i < stopAt; i++) {
      ret->list.push_back(parseExpression(s[i]));
    }
    ret->finalize();
    // Note that we do not name these implicit/synthetic blocks. They
    // are the effects of syntactic sugar, and nothing can branch to
    // them anyhow.
    return ret;
  }

  Expression* makeLoop(Element& s) {
    auto ret = allocator.alloc<Loop>();
    size_t i = 1;
    Name out;
    if (s.size() > i + 1 && s[i]->isStr() && s[i + 1]->isStr()) { // out can only be named if both are
      out = s[i]->str();
      i++;
    }
    if (s.size() > i && s[i]->isStr()) {
      ret->name = s[i]->str();
      i++;
    } else {
      ret->name = getPrefixedName("loop-in");
    }
    labelStack.push_back(ret->name);
    ret->body = makeMaybeBlock(s, i);
    labelStack.pop_back();
    ret->finalize();
    if (out.is()) {
      auto* block = allocator.alloc<Block>();
      block->name = out;
      block->list.push_back(ret);
      block->finalize();
      return block;
    }
    return ret;
  }

  Expression* makeCall(Element& s) {
    auto ret = allocator.alloc<Call>();
    ret->target = s[1]->str();
    ret->type = functionTypes[ret->target];
    parseCallOperands(s, 2, s.size(), ret);
    return ret;
  }

  Expression* makeCallImport(Element& s) {
    auto ret = allocator.alloc<CallImport>();
    ret->target = s[1]->str();
    Import* import = wasm.getImport(ret->target);
    ret->type = import->functionType->result;
    parseCallOperands(s, 2, s.size(), ret);
    return ret;
  }

  Expression* makeCallIndirect(Element& s) {
    auto ret = allocator.alloc<CallIndirect>();
    IString type = s[1]->str();
    auto* fullType = wasm.checkFunctionType(type);
    if (!fullType) throw ParseException("invalid call_indirect type", s.line, s.col);
    ret->fullType = fullType->name;
    ret->type = fullType->result;
    parseCallOperands(s, 2, s.size() - 1, ret);
    ret->target = parseExpression(s[s.size() - 1]);
    return ret;
  }

  template<class T>
  void parseCallOperands(Element& s, Index i, Index j, T* call) {
    while (i < j) {
      call->operands.push_back(parseExpression(s[i]));
      i++;
    }
  }
  Name getLabel(Element& s) {
    if (s.dollared()) {
      return s.str();
    } else {
      // offset, break to nth outside label
      uint64_t offset = std::stoll(s.c_str(), nullptr, 0);
      if (offset > labelStack.size()) throw ParseException("invalid label", s.line, s.col);
      if (offset == labelStack.size()) {
        // a break to the function's scope. this means we need an automatic block, with a name
        brokeToAutoBlock = true;
        return FAKE_RETURN;
      }
      return labelStack[labelStack.size() - 1 - offset];
    }
  }
  Expression* makeBreak(Element& s) {
    auto ret = allocator.alloc<Break>();
    size_t i = 1;
    ret->name = getLabel(*s[i]);
    i++;
    if (i == s.size()) return ret;
    if (s[0]->str() == BR_IF) {
      if (i + 1 < s.size()) {
        ret->value = parseExpression(s[i]);
        i++;
      }
      ret->condition = parseExpression(s[i]);
    } else {
      ret->value = parseExpression(s[i]);
    }
    ret->finalize();
    return ret;
  }

  Expression* makeBreakTable(Element& s) {
    auto ret = allocator.alloc<Switch>();
    size_t i = 1;
    while (!s[i]->isList()) {
      ret->targets.push_back(getLabel(*s[i++]));
    }
    ret->default_ = ret->targets.back();
    ret->targets.pop_back();
    ret->condition = parseExpression(s[i++]);
    if (i < s.size()) {
      ret->value = ret->condition;
      ret->condition = parseExpression(s[i++]);
    }
    return ret;
  }

  Expression* makeReturn(Element& s) {
    auto ret = allocator.alloc<Return>();
    if (s.size() >= 2) {
      ret->value = parseExpression(s[1]);
    }
    return ret;
  }

  // converts an s-expression string representing binary data into an output sequence of raw bytes
  // this appends to data, which may already contain content.
  void stringToBinary(const char* input, size_t size, std::vector<char>& data) {
    auto originalSize = data.size();
    data.resize(originalSize + size);
    char *write = data.data() + originalSize;
    while (1) {
      if (input[0] == 0) break;
      if (input[0] == '\\') {
        if (input[1] == '"') {
          *write++ = '"';
          input += 2;
          continue;
        } else if (input[1] == '\'') {
          *write++ = '\'';
          input += 2;
          continue;
        } else if (input[1] == '\\') {
          *write++ = '\\';
          input += 2;
          continue;
        } else if (input[1] == 'n') {
          *write++ = '\n';
          input += 2;
          continue;
        } else if (input[1] == 't') {
          *write++ = '\t';
          input += 2;
          continue;
        } else {
          *write++ = (char)(unhex(input[1])*16 + unhex(input[2]));
          input += 3;
          continue;
        }
      }
      *write++ = input[0];
      input++;
    }
    assert(write >= data.data());
    size_t actual = write - data.data();
    assert(actual <= data.size());
    data.resize(actual);
  }

  bool hasMemory = false;

  void parseMemory(Element& s) {
    hasMemory = true;

    if (s[1]->isList()) {
      // (memory (data ..)) format
      parseData(*s[1]);
      wasm.memory.initial = wasm.memory.segments[0].data.size();
      return;
    }
    wasm.memory.initial = atoi(s[1]->c_str());
    if (s.size() == 2) return;
    size_t i = 2;
    if (s[i]->isStr()) {
      uint64_t max = atoll(s[i]->c_str());
      if (max > Memory::kMaxSize) throw ParseException("total memory must be <= 4GB");
      wasm.memory.max = max;
      i++;
    }
    while (i < s.size()) {
      Element& curr = *s[i];
      size_t j = 1;
      Address offsetValue;
      if (curr[0]->str() == DATA) {
        offsetValue = 0;
      } else {
        offsetValue = atoi(curr[j++]->c_str());
      }
      const char *input = curr[j]->c_str();
      auto* offset = allocator.alloc<Const>();
      offset->type = i32;
      offset->value = Literal(int32_t(offsetValue));
      if (auto size = strlen(input)) {
        std::vector<char> data;
        stringToBinary(input, size, data);
        wasm.memory.segments.emplace_back(offset, data.data(), data.size());
      } else {
        wasm.memory.segments.emplace_back(offset, "", 0);
      }
      i++;
    }
  }

  void parseData(Element& s) {
    Index i = 1;
    Expression* offset;
    if (s[i]->isList()) {
      // there is an init expression
      offset = parseExpression(s[i++]);
    } else {
      offset = allocator.alloc<Const>()->set(Literal(int32_t(0)));
    }
    std::vector<char> data;
    while (i < s.size()) {
      const char *input = s[i++]->c_str();
      if (auto size = strlen(input)) {
        stringToBinary(input, size, data);
      }
    }
    wasm.memory.segments.emplace_back(offset, data.data(), data.size());
  }

  void parseExport(Element& s) {
    std::unique_ptr<Export> ex = make_unique<Export>();
    if (!s[2]->dollared() && !std::isdigit(s[2]->str()[0])) {
      ex->name = s[1]->str();
      if (s[2]->str() == MEMORY) {
        if (!hasMemory) throw ParseException("memory exported but no memory");
        ex->value = Name::fromInt(0);
        ex->kind = Export::Memory;
      } else if (s[2]->str() == TABLE) {
        ex->value = Name::fromInt(0);
        ex->kind = Export::Table;
      } else if (s[2]->str() == GLOBAL) {
        ex->value = s[3]->str();
        ex->kind = Export::Table;
      } else {
        WASM_UNREACHABLE();
      }
    } else {
      // function
      ex->name = s[1]->str();
      ex->value = s[2]->str();
      ex->kind = Export::Function;
    }
    wasm.addExport(ex.release());
  }

  void parseImport(Element& s) {
    std::unique_ptr<Import> im = make_unique<Import>();
    size_t i = 1;
    if (s.size() > 3 && s[3]->isStr()) {
      im->name = s[i++]->str();
    } else {
      im->name = Name::fromInt(importCounter);
    }
    importCounter++;
    if (!s[i]->quoted()) {
      if (s[i]->str() == MEMORY) {
        im->kind = Import::Memory;
      } else if (s[2]->str() == TABLE) {
        im->kind = Import::Table;
      } else if (s[2]->str() == GLOBAL) {
        im->kind = Import::Table;
      } else {
        WASM_UNREACHABLE();
      }
      i++;
    } else {
      im->kind = Import::Function;
    }
    im->module = s[i++]->str();
    if (!s[i]->isStr()) throw ParseException("no name for import");
    im->base = s[i++]->str();
    if (im->kind == Import::Function) {
      std::unique_ptr<FunctionType> type = make_unique<FunctionType>();
      if (s.size() > i) {
        Element& params = *s[i];
        IString id = params[0]->str();
        if (id == PARAM) {
          for (size_t i = 1; i < params.size(); i++) {
            type->params.push_back(stringToWasmType(params[i]->str()));
          }
        } else if (id == RESULT) {
          type->result = stringToWasmType(params[1]->str());
        } else if (id == TYPE) {
          IString name = params[1]->str();
          if (!wasm.checkFunctionType(name)) throw ParseException("bad function type for import");
          *type = *wasm.getFunctionType(name);
        } else {
          throw ParseException("bad import element");
        }
        if (s.size() > i+1) {
          Element& result = *s[i+1];
          assert(result[0]->str() == RESULT);
          type->result = stringToWasmType(result[1]->str());
        }
      }
      im->functionType = ensureFunctionType(getSig(type.get()), &wasm);
    } else if (im->kind == Import::Global) {
      im->globalType = stringToWasmType(s[i]->str());
    }
    wasm.addImport(im.release());
  }

  void parseGlobal(Element& s) {
    std::unique_ptr<Global> global = make_unique<Global>();
    size_t i = 1;
    if (s.size() == 4) {
      global->name = s[i++]->str();
    } else {
      global->name = Name::fromInt(globalCounter);
    }
    globalCounter++;
    global->type = stringToWasmType(s[i++]->str());
    global->init = parseExpression(s[i++]);
    assert(i == s.size());
    wasm.addGlobal(global.release());
  }

  bool seenTable = false;

  void parseTable(Element& s) {
    seenTable = true;

    if (s.size() == 1) return; // empty table in old notation
    if (!s[1]->dollared()) {
      if (s[1]->str() == ANYFUNC) {
        // (table type (elem ..))
        parseElem(*s[2]);
        wasm.table.initial = wasm.table.max = wasm.table.segments[0].data.size();
        return;
      }
      // first element isn't dollared, and isn't anyfunc. this could be old syntax for (table 0 1) which means function 0 and 1, or it could be (table initial max? type), look for type
      if (s[s.size() - 1]->str() == ANYFUNC) {
        // (table initial max? type)
        wasm.table.initial = atoi(s[1]->c_str());
        wasm.table.max = atoi(s[2]->c_str());
        return;
      }
    }
    // old notation (table func1 func2 ..)
    parseElem(s);
    wasm.table.initial = wasm.table.max = wasm.table.segments[0].data.size();
  }

  void parseElem(Element& s) {
    if (!seenTable) throw ParseException("elem without table", s.line, s.col);
    Index i = 1;
    Expression* offset;
    if (s[i]->isList()) {
      // there is an init expression
      offset = parseExpression(s[i++]);
    } else {
      offset = allocator.alloc<Const>()->set(Literal(int32_t(0)));
    }
    Table::Segment segment(offset);
    for (; i < s.size(); i++) {
      segment.data.push_back(getFunctionName(*s[i]));
    }
    wasm.table.segments.push_back(segment);
  }

  void parseType(Element& s) {
    std::unique_ptr<FunctionType> type = make_unique<FunctionType>();
    size_t i = 1;
    if (s[i]->isStr()) {
      type->name = s[i]->str();
      i++;
    }
    Element& func = *s[i];
    assert(func.isList());
    for (size_t i = 1; i < func.size(); i++) {
      Element& curr = *func[i];
      if (curr[0]->str() == PARAM) {
        for (size_t j = 1; j < curr.size(); j++) {
          type->params.push_back(stringToWasmType(curr[j]->str()));
        }
      } else if (curr[0]->str() == RESULT) {
        if (curr.size() > 2) throw ParseException("invalid result arity", curr.line, curr.col);
        type->result = stringToWasmType(curr[1]->str());
      }
    }
    wasm.addFunctionType(type.release());
  }
};

} // namespace wasm

#endif // wasm_wasm_s_parser_h
