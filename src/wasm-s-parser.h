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

#include "wasm.h"
#include "mixed_arena.h"
#include "shared-constants.h"
#include "parsing.h"

namespace wasm {

using namespace cashew;

// Globals

int unhex(char c) {
  if (c >= '0' && c <= '9') return c - '0';
  if (c >= 'a' && c <= 'f') return c - 'a' + 10;
  if (c >= 'A' && c <= 'F') return c - 'A' + 10;
  abort();
}

//
// An element in an S-Expression: a list or a string
//

class Element {
  typedef std::vector<Element*> List;

  bool isList_;
  List list_;
  IString str_;
  bool dollared_;

public:
  Element() : isList_(true) {}

  bool isList() { return isList_; }
  bool isStr() { return !isList_; }
  bool dollared() { return dollared_; }

  // list methods

  List& list() {
    assert(isList_);
    return list_;
  }

  Element* operator[](unsigned i) {
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

  Element* setString(IString str__, bool dollared__) {
    isList_ = false;
    str_ = str__;
    dollared_ = dollared__;
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
};

//
// Generic S-Expression parsing into lists
//

class SExpressionParser {
  char* input;

  MixedArena allocator;

public:
  // Assumes control of and modifies the input.
  SExpressionParser(char* input) : input(input) {
    root = nullptr;
    while (!root) { // keep parsing until we pass an initial comment
      root = parseInnerList();
    }
  }

  Element* root;

private:
  // parses the internal part of a list, inside the parens.
  Element* parseInnerList() {
    if (input[0] == ';') {
      // comment
      input++;
      if (input[0] == ';') {
        while (input[0] != '\n') input++;
        return nullptr;
      }
      input = strstr(input, ";)");
      assert(input);
      return nullptr;
    }
    auto ret = allocator.alloc<Element>();
    while (1) {
      Element* curr = parse();
      if (!curr) return ret;
      ret->list().push_back(curr);
    }
  }

  Element* parse() {
    skipWhitespace();
    if (input[0] == 0 || input[0] == ')') return nullptr;
    if (input[0] == '(') {
      // a list
      input++;
      auto ret = parseInnerList();
      skipWhitespace();
      assert(input[0] == ')');
      input++;
      return ret;
    }
    return parseString();
  }

  void skipWhitespace() {
    while (1) {
      while (isspace(input[0])) input++;
      if (input[0] == ';' && input[1] == ';') {
        while (input[0] && input[0] != '\n') input++;
      } else if (input[0] == '(' && input[1] == ';') {
        input = strstr(input, ";)") + 2;
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
      return allocator.alloc<Element>()->setString(IString(str.c_str(), false), dollared);
    }
    while (input[0] && !isspace(input[0]) && input[0] != ')') input++;
    char temp = input[0];
    input[0] = 0;
    auto ret = allocator.alloc<Element>()->setString(IString(start, false), dollared); // TODO: reuse the string here, carefully
    input[0] = temp;
    return ret;
  }
};

//
// SExpressions => WebAssembly module
//

class SExpressionWasmBuilder {
  AllocatingModule& wasm;
  MixedArena& allocator;
  std::function<void ()> onError;
  int functionCounter;
  std::map<Name, WasmType> functionTypes; // we need to know function return types before we parse their contents
  bool debug;

public:
  // Assumes control of and modifies the input.
  SExpressionWasmBuilder(AllocatingModule& wasm, Element& module, std::function<void ()> onError, bool debug=false) : wasm(wasm), allocator(wasm.allocator), onError(onError), debug(debug) {
    assert(module[0]->str() == MODULE);
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
    Name name;
    if (s[i]->isStr()) {
      name = s[i]->str();
      i++;
    } else {
      // unnamed, use an index
      name = Name::fromInt(functionCounter);
    }
    functionCounter++;
    for (;i < s.size(); i++) {
      Element& curr = *s[i];
      IString id = curr[0]->str();
      if (id == RESULT) {
        functionTypes[name] = stringToWasmType(curr[1]->str());
        return;
      } else if (id == TYPE) {
        Name name = curr[1]->str();
        if (wasm.functionTypesMap.find(name) == wasm.functionTypesMap.end()) onError();
        FunctionType* type = wasm.functionTypesMap[name];
        functionTypes[name] = type->result;
        return;
      }
    }
    functionTypes[name] = none;
  }

  void preParseImports(Element& curr) {
    IString id = curr[0]->str();
    if (id == IMPORT) parseImport(curr);
  }

  void parseModuleElement(Element& curr) {
    IString id = curr[0]->str();
    if (id == FUNC) return parseFunction(curr);
    if (id == MEMORY) return parseMemory(curr);
    if (id == EXPORT) return parseExport(curr);
    if (id == IMPORT) return; // already done
    if (id == TABLE) return parseTable(curr);
    if (id == TYPE) return; // already done
    std::cerr << "bad module element " << id.str << '\n';
    onError();
  }

  // function parsing state
  Function *currFunction = nullptr;
  std::map<Name, WasmType> currLocalTypes;
  size_t localIndex; // params and locals
  size_t otherIndex;
  std::vector<Name> labelStack;

  Name getPrefixedName(std::string prefix) {
    return IString((prefix + std::to_string(otherIndex++)).c_str(), false);
  }

  void parseFunction(Element& s) {
    auto func = currFunction = allocator.alloc<Function>();
    size_t i = 1;
    if (s[i]->isStr()) {
      func->name = s[i]->str();
      i++;
    } else {
      // unnamed, use an index
      func->name = Name::fromInt(functionCounter);
    }
    functionCounter++;
    func->body = nullptr;
    localIndex = 0;
    otherIndex = 0;
    std::vector<NameType> typeParams; // we may have both params and a type. store the type info here
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
            func->params.emplace_back(name, type);
          } else {
            func->locals.emplace_back(name, type);
          }
          localIndex++;
          currLocalTypes[name] = type;
        }
      } else if (id == RESULT) {
        func->result = stringToWasmType(curr[1]->str());
      } else if (id == TYPE) {
        Name name = curr[1]->str();
        func->type = name;
        if (wasm.functionTypesMap.find(name) == wasm.functionTypesMap.end()) onError();
        FunctionType* type = wasm.functionTypesMap[name];
        func->result = type->result;
        for (size_t j = 0; j < type->params.size(); j++) {
          IString name = Name::fromInt(j);
          WasmType currType = type->params[j];
          typeParams.emplace_back(name, currType);
          currLocalTypes[name] = currType;
        }
      } else {
        // body
        if (typeParams.size() > 0 && func->params.size() == 0) {
          func->params = typeParams;
        }
        Expression* ex = parseExpression(curr);
        if (!func->body) {
          func->body = ex;
        } else {
          auto block = func->body->dyn_cast<Block>();
          if (!block) {
            block = allocator.alloc<Block>();
            block->list.push_back(func->body);
            func->body = block;
          }
          block->list.push_back(ex);
        }
      }
    }
    if (!func->body) func->body = allocator.alloc<Nop>();
    wasm.addFunction(func);
    currLocalTypes.clear();
    labelStack.clear();
    currFunction = nullptr;
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
    onError();
    abort();
  }

public:
  Expression* parseExpression(Element* s) {
    return parseExpression(*s);
  }

  #define abort_on(str) { std::cerr << "aborting on " << str << '\n'; onError(); }

  Expression* parseExpression(Element& s) {
    if (debug) std::cerr << "parse expression " << s << '\n';
    IString id = s[0]->str();
    const char *str = id.str;
    const char *dot = strchr(str, '.');
    if (dot) {
      // type.operation (e.g. i32.add)
      WasmType type = stringToWasmType(str, false, true);
      const char *op = dot + 1;
      switch (op[0]) {
        case 'a': {
          if (op[1] == 'b') return makeUnary(s, UnaryOp::Abs, type);
          if (op[1] == 'd') return makeBinary(s, BinaryOp::Add, type);
          if (op[1] == 'n') return makeBinary(s, BinaryOp::And, type);
          abort_on(op);
        }
        case 'c': {
          if (op[1] == 'e') return makeUnary(s, UnaryOp::Ceil, type);
          if (op[1] == 'l') return makeUnary(s, UnaryOp::Clz, type);
          if (op[1] == 'o') {
            if (op[2] == 'p') return makeBinary(s, BinaryOp::CopySign, type);
            if (op[2] == 'n') {
              if (op[3] == 'v') {
                if (op[8] == 's') return makeUnary(s, op[11] == '3' ? UnaryOp::ConvertSInt32 : UnaryOp::ConvertSInt64, type);
                if (op[8] == 'u') return makeUnary(s, op[11] == '3' ? UnaryOp::ConvertUInt32 : UnaryOp::ConvertUInt64, type);
              }
              if (op[3] == 's') return makeConst(s, type);
            }
          }
          if (op[1] == 't') return makeUnary(s, UnaryOp::Ctz, type);
          abort_on(op);
        }
        case 'd': {
          if (op[1] == 'i') {
            if (op[3] == '_') return makeBinary(s, op[4] == 'u' ? BinaryOp::DivU : BinaryOp::DivS, type);
            if (op[3] == 0) return makeBinary(s, BinaryOp::Div, type);
          }
          if (op[1] == 'e') return makeUnary(s,  UnaryOp::DemoteFloat64, type);
          abort_on(op);
        }
        case 'e': {
          if (op[1] == 'q') return makeBinary(s, BinaryOp::Eq, type);
          if (op[1] == 'x') return makeUnary(s, op[7] == 'u' ? UnaryOp::ExtendUInt32 : UnaryOp::ExtendSInt32, type);
          abort_on(op);
        }
        case 'f': {
          if (op[1] == 'l') return makeUnary(s, UnaryOp::Floor, type);
          abort_on(op);
        }
        case 'g': {
          if (op[1] == 't') {
            if (op[2] == '_') return makeBinary(s, op[3] == 'u' ? BinaryOp::GtU : BinaryOp::GtS, type);
            if (op[2] == 0) return makeBinary(s, BinaryOp::Gt, type);
          }
          if (op[1] == 'e') {
            if (op[2] == '_') return makeBinary(s, op[3] == 'u' ? BinaryOp::GeU : BinaryOp::GeS, type);
            if (op[2] == 0) return makeBinary(s, BinaryOp::Ge, type);
          }
          abort_on(op);
        }
        case 'l': {
          if (op[1] == 't') {
            if (op[2] == '_') return makeBinary(s, op[3] == 'u' ? BinaryOp::LtU : BinaryOp::LtS, type);
            if (op[2] == 0) return makeBinary(s, BinaryOp::Lt, type);
          }
          if (op[1] == 'e') {
            if (op[2] == '_') return makeBinary(s, op[3] == 'u' ? BinaryOp::LeU : BinaryOp::LeS, type);
            if (op[2] == 0) return makeBinary(s, BinaryOp::Le, type);
          }
          if (op[1] == 'o') return makeLoad(s, type);
          abort_on(op);
        }
        case 'm': {
          if (op[1] == 'i') return makeBinary(s, BinaryOp::Min, type);
          if (op[1] == 'a') return makeBinary(s, BinaryOp::Max, type);
          if (op[1] == 'u') return makeBinary(s, BinaryOp::Mul, type);
          abort_on(op);
        }
        case 'n': {
          if (op[1] == 'e') {
            if (op[2] == 0) return makeBinary(s, BinaryOp::Ne, type);
            if (op[2] == 'a') return makeUnary(s, UnaryOp::Nearest, type);
            if (op[2] == 'g') return makeUnary(s, UnaryOp::Neg, type);
          }
          abort_on(op);
        }
        case 'o': {
          if (op[1] == 'r') return makeBinary(s, BinaryOp::Or, type);
          abort_on(op);
        }
        case 'p': {
          if (op[1] == 'r') return makeUnary(s,  UnaryOp::PromoteFloat32, type);
          if (op[1] == 'o') return makeUnary(s, UnaryOp::Popcnt, type);
          abort_on(op);
        }
        case 'r': {
          if (op[1] == 'e') {
            if (op[2] == 'm') return makeBinary(s, op[4] == 'u' ? BinaryOp::RemU : BinaryOp::RemS, type);
            if (op[2] == 'i') return makeUnary(s, isWasmTypeFloat(type) ? UnaryOp::ReinterpretInt : UnaryOp::ReinterpretFloat, type);
          }
          abort_on(op);
        }
        case 's': {
          if (op[1] == 'e') return makeSelect(s, type);
          if (op[1] == 'h') {
            if (op[2] == 'l') return makeBinary(s, BinaryOp::Shl, type);
            return makeBinary(s, op[4] == 'u' ? BinaryOp::ShrU : BinaryOp::ShrS, type);
          }
          if (op[1] == 'u') return makeBinary(s, BinaryOp::Sub, type);
          if (op[1] == 'q') return makeUnary(s, UnaryOp::Sqrt, type);
          if (op[1] == 't') return makeStore(s, type);
          abort_on(op);
        }
        case 't': {
          if (op[1] == 'r') {
            if (op[6] == 's') return makeUnary(s, op[9] == '3' ? UnaryOp::TruncSFloat32 : UnaryOp::TruncSFloat64, type);
            if (op[6] == 'u') return makeUnary(s, op[9] == '3' ? UnaryOp::TruncUFloat32 : UnaryOp::TruncUFloat64, type);
            if (op[2] == 'u') return makeUnary(s, UnaryOp::Trunc, type);
          }
          abort_on(op);
        }
        case 'w': {
          if (op[1] == 'r') return makeUnary(s,  UnaryOp::WrapInt64, type);
          abort_on(op);
        }
        case 'x': {
          if (op[1] == 'o') return makeBinary(s, BinaryOp::Xor, type);
          abort_on(op);
        }
        default: abort_on(op);
      }
    } else {
      // other expression
      switch (str[0]) {
        case 'b': {
          if (str[1] == 'l') return makeBlock(s);
          if (str[1] == 'r') return makeBreak(s);
          abort_on(str);
        }
        case 'c': {
          if (str[1] == 'a') {
            if (id == CALL) return makeCall(s);
            if (id == CALL_IMPORT) return makeCallImport(s);
            if (id == CALL_INDIRECT) return makeCallIndirect(s);
          }
          abort_on(str);
        }
        case 'g': {
          if (str[1] == 'e') return makeGetLocal(s);
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
        case 'm': {
          if (str[1] == 'e') return makeHost(s, HostOp::MemorySize);
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
          if (str[1] == 'e') return makeSetLocal(s);
          abort_on(str);
        }
        case 'r': {
          if (str[1] == 'e') return makeReturn(s);
          abort_on(str);
        }
        case 't': {
          if (str[1] == 'a') return makeSwitch(s); // aka tableswitch
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
    ret->type = type;
    return ret;
  }

  Expression* makeSelect(Element& s, WasmType type) {
    auto ret = allocator.alloc<Select>();
    ret->condition = parseExpression(s[1]);
    ret->ifTrue = parseExpression(s[2]);
    ret->ifFalse = parseExpression(s[3]);
    ret->type = type;
    return ret;
  }

  Expression* makeHost(Element& s, HostOp op) {
    auto ret = allocator.alloc<Host>();
    ret->op = op;
    if (op == HostOp::HasFeature) {
      ret->nameOperand = s[1]->str();
    } else {
      parseCallOperands(s, 1, ret);
    }
    ret->finalize();
    return ret;
  }

  Name getLocalName(Element& s) {
    if (s.dollared()) return s.str();
    // this is a numeric index
    size_t i = atoi(s.c_str());
    size_t numParams = currFunction->params.size();
    if (i < numParams) {
      return currFunction->params[i].name;
    } else {
      return currFunction->locals[i - currFunction->params.size()].name;
    }
  }

  Expression* makeGetLocal(Element& s) {
    auto ret = allocator.alloc<GetLocal>();
    ret->name = getLocalName(*s[1]);
    ret->type = currLocalTypes[ret->name];
    return ret;
  }

  Expression* makeSetLocal(Element& s) {
    auto ret = allocator.alloc<SetLocal>();
    ret->name = getLocalName(*s[1]);
    ret->value = parseExpression(s[2]);
    ret->type = currLocalTypes[ret->name];
    return ret;
  }

  Expression* makeBlock(Element& s) {
    auto ret = allocator.alloc<Block>();
    size_t i = 1;
    if (s[1]->isStr()) {
      ret->name = s[1]->str();
      i++;
    } else {
      ret->name = getPrefixedName("block");
    }
    labelStack.push_back(ret->name);
    for (; i < s.size(); i++) {
      ret->list.push_back(parseExpression(s[i]));
    }
    labelStack.pop_back();
    ret->type = ret->list.back()->type;
    return ret;
  }

  Expression* makeConst(Element& s, WasmType type) {
    auto ret = parseConst(s[1]->str(), type, allocator);
    if (!ret) onError();
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
    ret->align = 0;
    while (!s[i]->isList()) {
      const char *str = s[i]->c_str();
      const char *eq = strchr(str, '=');
      assert(eq);
      eq++;
      if (str[0] == 'a') {
        ret->align = atoi(eq);
      } else if (str[0] == 'o') {
        uint64_t offset = atoll(eq);
        if (offset > 0xffffffff) onError();
        ret->offset = offset;
      } else onError();
      i++;
    }
    ret->ptr = parseExpression(s[i]);
    return ret;
  }

  Expression* makeStore(Element& s, WasmType type) {
    const char *extra = strchr(s[0]->c_str(), '.') + 6; // after "type.store"
    auto ret = allocator.alloc<Store>();
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
    size_t i = 1;
    ret->offset = 0;
    ret->align = 0;
    while (!s[i]->isList()) {
      const char *str = s[i]->c_str();
      const char *eq = strchr(str, '=');
      assert(eq);
      eq++;
      if (str[0] == 'a') {
        ret->align = atoi(eq);
      } else if (str[0] == 'o') {
        ret->offset = atoi(eq);
      } else onError();
      i++;
    }
    ret->ptr = parseExpression(s[i]);
    ret->value = parseExpression(s[i+1]);
    return ret;
  }

  Expression* makeIf(Element& s) {
    auto ret = allocator.alloc<If>();
    ret->condition = parseExpression(s[1]);
    ret->ifTrue = parseExpression(s[2]);
    if (s.size() == 4) {
      ret->ifFalse = parseExpression(s[3]);
      ret->type = ret->ifTrue->type == ret->ifFalse->type ? ret->ifTrue->type : none; // if not the same type, this does not return a value
    }
    return ret;
  }

  Expression* makeMaybeBlock(Element& s, size_t i, size_t stopAt=-1) {
    if (s.size() == i+1) return parseExpression(s[i]);
    auto ret = allocator.alloc<Block>();
    for (; i < s.size() && i < stopAt; i++) {
      ret->list.push_back(parseExpression(s[i]));
    }
    if (ret->list.size() > 0) {
      ret->type = ret->list.back()->type;
    }
    return ret;
  }

  Expression* makeLoop(Element& s) {
    auto ret = allocator.alloc<Loop>();
    size_t i = 1;
    if (s[i]->isStr() && s[i+1]->isStr()) { // out can only be named if both are
      ret->out = s[i]->str();
      i++;
    } else {
      ret->out = getPrefixedName("loop-out");
    }
    if (s[i]->isStr()) {
      ret->in = s[i]->str();
      i++;
    } else {
      ret->in = getPrefixedName("loop-in");
    }
    labelStack.push_back(ret->out);
    labelStack.push_back(ret->in);
    ret->body = makeMaybeBlock(s, i);
    labelStack.pop_back();
    labelStack.pop_back();
    return ret;
  }

  Expression* makeCall(Element& s) {
    auto ret = allocator.alloc<Call>();
    ret->target = s[1]->str();
    ret->type = functionTypes[ret->target];
    parseCallOperands(s, 2, ret);
    return ret;
  }

  Expression* makeCallImport(Element& s) {
    auto ret = allocator.alloc<CallImport>();
    ret->target = s[1]->str();
    Import* import = wasm.importsMap[ret->target];
    ret->type = import->type.result;
    parseCallOperands(s, 2, ret);
    return ret;
  }

  Expression* makeCallIndirect(Element& s) {
    auto ret = allocator.alloc<CallIndirect>();
    IString type = s[1]->str();
    assert(wasm.functionTypesMap.find(type) != wasm.functionTypesMap.end());
    ret->fullType = wasm.functionTypesMap[type];
    ret->type = ret->fullType->result;
    ret->target = parseExpression(s[2]);
    parseCallOperands(s, 3, ret);
    return ret;
  }

  template<class T>
  void parseCallOperands(Element& s, size_t i, T* call) {
    while (i < s.size()) {
      call->operands.push_back(parseExpression(s[i]));
      i++;
    }
  }

  Expression* makeBreak(Element& s) {
    auto ret = allocator.alloc<Break>();
    size_t i = 1;
    if (s[0]->str() == BR_IF) {
      ret->condition = parseExpression(s[i]);
      i++;
    }
    if (s[i]->dollared()) {
      ret->name = s[i]->str();
    } else {
      // offset, break to nth outside label
      size_t offset = atol(s[i]->c_str());
      assert(offset < labelStack.size());
      ret->name = labelStack[labelStack.size() - 1 - offset];
    }
    i++;
    if (i < s.size()) {
      ret->value = parseExpression(s[i]);
    }
    return ret;
  }

  Expression* makeReturn(Element& s) {
    // return will likely not remain in wasm, but is in the testcases, for now. fake it
    Block *temp;
    if (!(currFunction->body && (temp = currFunction->body->dyn_cast<Block>()) && temp->name == FAKE_RETURN)) {
      Expression* old = currFunction->body;
      temp = allocator.alloc<Block>();
      temp->name = FAKE_RETURN;
      if (old) temp->list.push_back(old);
      currFunction->body = temp;
    }
    auto ret = allocator.alloc<Break>();
    ret->name = FAKE_RETURN;
    if (s.size() >= 2) {
      ret->value = parseExpression(s[1]);
    }
    return ret;
  }

  Expression* makeSwitch(Element& s) {
    auto ret = allocator.alloc<Switch>();
    size_t i = 1;
    if (s[i]->isStr()) {
      ret->name = s[i]->str();
      i++;
    } else {
      ret->name = getPrefixedName("switch");
    }
    ret->value =  parseExpression(s[i]);
    i++;
    Element& table = *s[i];
    i++;
    for (size_t j = 1; j < table.size(); j++) {
      Element& curr = *table[j];
      if (curr[0]->str() == CASE) {
        ret->targets.push_back(curr[1]->str());
      } else {
        assert(curr[0]->str() == BR);
        assert(curr[1]->str() == ret->name);
        ret->targets.push_back(Name());
      }
    }
    Element& curr = *s[i];
    if (curr[0]->str() == CASE) {
      ret->default_ = curr[1]->str();
    } else {
      assert(curr[0]->str() == BR);
      assert(curr[1]->str() == ret->name);
    }
    i++;
    for (; i < s.size(); i++) {
      Element& curr = *s[i];
      assert(curr[0]->str() == CASE);
      if (curr.size() < 2) onError();
      ret->cases.emplace_back(curr[1]->str(), makeMaybeBlock(curr, 2, curr.size()));
    }
    ret->type = ret->cases.size() > 0 ? ret->cases[0].body->type : none;
    return ret;
  }

  void parseMemory(Element& s) {
    wasm.memory.initial = atoi(s[1]->c_str());
    if (s.size() == 2) return;
    size_t i = 2;
    if (s[i]->isStr()) {
      wasm.memory.max = atoi(s[i]->c_str());
      i++;
    }
    while (i < s.size()) {
      Element& curr = *s[i];
      assert(curr[0]->str() == SEGMENT);
      const char *input = curr[2]->c_str();
      char *data = (char*)malloc(strlen(input)); // over-allocated, since escaping collapses, but whatever
      char *write = data;
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
          } else if (input[1] == 'n') {
            *write++ = '\n';
            input += 2;
          } else if (input[1] == 't') {
            *write++ = '\t';
            input += 2;
          } else {
            *write++ = (char)(unhex(input[1])*16 + unhex(input[2]));
            input += 3;
            continue;
          }
        }
        *write++ = input[0];
        input++;
      }
      wasm.memory.segments.emplace_back(atoi(curr[1]->c_str()), data, write - data);
      i++;
    }
  }

  void parseExport(Element& s) {
    auto ex = allocator.alloc<Export>();
    ex->name = s[1]->str();
    ex->value = s[2]->str();
    wasm.addExport(ex);
  }

  void parseImport(Element& s) {
    auto im = allocator.alloc<Import>();
    im->name = s[1]->str();
    im->module = s[2]->str();
    if (!s[3]->isStr()) onError();
    im->base = s[3]->str();
    if (s.size() > 4) {
      Element& params = *s[4];
      IString id = params[0]->str();
      if (id == PARAM) {
        for (size_t i = 1; i < params.size(); i++) {
          im->type.params.push_back(stringToWasmType(params[i]->str()));
        }
      } else if (id == RESULT) {
        im->type.result = stringToWasmType(params[1]->str());
      } else if (id == TYPE) {
        IString name = params[1]->str();
        assert(wasm.functionTypesMap.find(name) != wasm.functionTypesMap.end());
        im->type = *wasm.functionTypesMap[name];
      } else {
        onError();
      }
      if (s.size() > 5) {
        Element& result = *s[5];
        assert(result[0]->str() == RESULT);
        im->type.result = stringToWasmType(result[1]->str());
      }
    }
    wasm.addImport(im);
  }

  void parseTable(Element& s) {
    for (size_t i = 1; i < s.size(); i++) {
      wasm.table.names.push_back(s[i]->str());
    }
  }

  void parseType(Element& s) {
    auto type = allocator.alloc<FunctionType>();
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
        type->result = stringToWasmType(curr[1]->str());
      }
    }
    wasm.addFunctionType(type);
  }
};

} // namespace wasm

#endif // wasm_wasm_s_parser_h
