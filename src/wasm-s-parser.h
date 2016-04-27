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
#include "mixed_arena.h"
#include "shared-constants.h"
#include "parsing.h"
#include "asm_v_wasm.h"
#include "ast_utils.h"
#include "wasm-builder.h"

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
  Element(MixedArena& allocator) : Element() {}

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

  void dump() {
    std::cout << "dumping " << this << " : " << *this << ".\n";
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
      if (input[0] == 0)
        break;
      if (input[0] == '(') {
        input++;
        stack.push_back(curr);
        curr = allocator.alloc<Element>();
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
    assert(stack.size() == 0); 
    return curr;
  }

  void skipWhitespace() {
    while (1) {
      while (isspace(input[0])) input++;
      if (input[0] == ';' && input[1] == ';') {
        while (input[0] && input[0] != '\n') input++;
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
      return allocator.alloc<Element>()->setString(IString(str.c_str(), false), dollared);
    }
    while (input[0] && !isspace(input[0]) && input[0] != ')' && input[0] != '(') input++;
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
  Module& wasm;
  MixedArena& allocator;
  std::function<void ()> onError;
  std::vector<Name> functionNames;
  int functionCounter;
  int importCounter;
  std::map<Name, WasmType> functionTypes; // we need to know function return types before we parse their contents

public:
  // Assumes control of and modifies the input.
  SExpressionWasmBuilder(Module& wasm, Element& module, std::function<void ()> onError) : wasm(wasm), allocator(wasm.allocator), onError(onError), importCounter(0) {
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

  // constructor without onError
  SExpressionWasmBuilder(Module& wasm, Element& module) : SExpressionWasmBuilder(wasm, module, [&]() { abort(); }) {}

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
    functionNames.push_back(name);
    functionCounter++;
    for (;i < s.size(); i++) {
      Element& curr = *s[i];
      IString id = curr[0]->str();
      if (id == RESULT) {
        functionTypes[name] = stringToWasmType(curr[1]->str());
        return;
      } else if (id == TYPE) {
        Name typeName = curr[1]->str();
        if (!wasm.checkFunctionType(typeName)) onError();
        FunctionType* type = wasm.getFunctionType(typeName);
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
    if (id == START) return parseStart(curr);
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
  size_t localIndex; // params and vars
  size_t otherIndex;
  std::vector<Name> labelStack;

  Name getPrefixedName(std::string prefix) {
    return IString((prefix + std::to_string(otherIndex++)).c_str(), false);
  }

  Name getFunctionName(Element& s) {
    if (s.dollared()) {
      return s.str();
    } else {
      // index
      size_t offset = atoi(s.str().c_str());
      if (offset >= functionNames.size()) onError();
      return functionNames[offset];
    }
  }

  void parseStart(Element& s) {
    wasm.addStart(getFunctionName(*s[1]));
  }

  void parseFunction(Element& s) {
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
    Expression* body = nullptr;
    localIndex = 0;
    otherIndex = 0;
    std::vector<NameType> typeParams; // we may have both params and a type. store the type info here
    std::vector<NameType> params;
    std::vector<NameType> vars;
    WasmType result = none;
    Name type;
    Block* autoBlock = nullptr; // we may need to add a block for the very top level
    auto makeFunction = [&]() {
      currFunction = Builder(wasm).makeFunction(
        name,
        std::move(params),
        result,
        std::move(vars)
      );
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
        result = stringToWasmType(curr[1]->str());
      } else if (id == TYPE) {
        Name name = curr[1]->str();
        type = name;
        if (!wasm.checkFunctionType(name)) onError();
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
          if (!autoBlock) {
            autoBlock = allocator.alloc<Block>();
            autoBlock->list.push_back(body);
            autoBlock->finalize();
            body = autoBlock;
          }
          autoBlock->list.push_back(ex);
        }
      }
    }
    if (!currFunction) {
      makeFunction();
      body = allocator.alloc<Nop>();
    }
    assert(currFunction->result == result);
    currFunction->body = body;
    currFunction->type = type;
    wasm.addFunction(currFunction);
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
          if (op[1] == 'q') {
            if (op[2] == 0) return makeBinary(s, BinaryOp::Eq, type);
            if (op[2] == 'z') return makeUnary(s, UnaryOp::EqZ, i32);
          }
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
          if (op[1] == 'o' && op[2] == 't') {
            return makeBinary(s, op[3] == 'l' ? BinaryOp::RotL : BinaryOp::RotR, type);
          }
          abort_on(op);
        }
        case 's': {
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
        case 'e': {
          if (str[1] == 'l') return makeThenOrElse(s);
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
        case 'n': {
          if (str[1] == 'o') return allocator.alloc<Nop>();
          abort_on(str);
        }
        case 'p': {
          if (str[1] == 'a') return makeHost(s, HostOp::PageSize);
          abort_on(str);
        }
        case 's': {
          if (str[1] == 'e' && str[2] == 't') return makeSetLocal(s);
          if (str[1] == 'e' && str[2] == 'l') return makeSelect(s);
          abort_on(str);
        }
        case 'r': {
          if (str[1] == 'e') return makeReturn(s);
          abort_on(str);
        }
        case 't': {
          if (str[1] == 'h') return makeThenOrElse(s);
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

  Expression* makeSelect(Element& s) {
    auto ret = allocator.alloc<Select>();
    ret->ifTrue = parseExpression(s[1]);
    ret->ifFalse = parseExpression(s[2]);
    ret->condition = parseExpression(s[3]);
    ret->finalize();
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

  Index getLocalIndex(Element& s) {
    if (s.dollared()) return currFunction->getLocalIndex(s.str());
    // this is a numeric index
    return atoi(s.c_str());
  }

  Expression* makeGetLocal(Element& s) {
    auto ret = allocator.alloc<GetLocal>();
    ret->index = getLocalIndex(*s[1]);
    ret->type = currFunction->getLocalType(ret->index);
    return ret;
  }

  Expression* makeSetLocal(Element& s) {
    auto ret = allocator.alloc<SetLocal>();
    ret->index = getLocalIndex(*s[1]);
    ret->value = parseExpression(s[2]);
    ret->type = currFunction->getLocalType(ret->index);
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
        if (offset > std::numeric_limits<uint32_t>::max()) onError();
        ret->offset = (uint32_t)offset;
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

    // ifTrue and ifFalse may get implicit blocks
    auto handle = [&](const char* title, Element& s) {
      Name name = getPrefixedName(title);
      bool explicitThenElse = false;
      if (s[0]->str() == THEN || s[0]->str() == ELSE) {
        explicitThenElse = true;
        if (s[1]->dollared()) {
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
    ret->finalize();
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
    Import* import = wasm.getImport(ret->target);
    ret->type = import->type->result;
    parseCallOperands(s, 2, ret);
    return ret;
  }

  Expression* makeCallIndirect(Element& s) {
    auto ret = allocator.alloc<CallIndirect>();
    IString type = s[1]->str();
    ret->fullType = wasm.getFunctionType(type);
    assert(ret->fullType);
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
  Name getLabel(Element& s) {
    if (s.dollared()) {
      return s.str();
    } else {
      size_t offset = atol(s.c_str());
      if (offset >= labelStack.size())
        return getPrefixedName("invalid");
      // offset, break to nth outside label
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

  bool hasMemory = false;

  void parseMemory(Element& s) {
    hasMemory = true;

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
      wasm.memory.segments.emplace_back(atoi(curr[1]->c_str()), data, write - data);
      i++;
    }
  }

  void parseExport(Element& s) {
    if (!s[2]->dollared() && !std::isdigit(s[2]->str()[0])) {
      assert(s[2]->str() == MEMORY);
      if (!hasMemory) onError();
      wasm.memory.exportName = s[1]->str();
      return;
    }
    auto ex = allocator.alloc<Export>();
    ex->name = s[1]->str();
    ex->value = s[2]->str();
    wasm.addExport(ex);
  }

  void parseImport(Element& s) {
    auto im = allocator.alloc<Import>();
    size_t i = 1;
    if (s.size() > 3 && s[3]->isStr()) {
      im->name = s[i++]->str();
    } else {
      im->name = Name::fromInt(importCounter);
    }
    importCounter++;
    im->module = s[i++]->str();
    if (!s[i]->isStr()) onError();
    im->base = s[i++]->str();
    FunctionType* type = allocator.alloc<FunctionType>();
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
        if (!wasm.checkFunctionType(name)) onError();
        *type = *wasm.getFunctionType(name);
      } else {
        onError();
      }
      if (s.size() > i+1) {
        Element& result = *s[i+1];
        assert(result[0]->str() == RESULT);
        type->result = stringToWasmType(result[1]->str());
      }
    }
    im->type = ensureFunctionType(getSig(type), &wasm);
    wasm.addImport(im);
  }

  void parseTable(Element& s) {
    for (size_t i = 1; i < s.size(); i++) {
      wasm.table.names.push_back(getFunctionName(*s[i]));
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
