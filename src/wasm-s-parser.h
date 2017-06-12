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

#include "wasm.h"
#include "mixed_arena.h"
#include "parsing.h" // for UniqueNameMapper. TODO: move dependency to cpp file?

namespace wasm {

class SourceLocation
{
public:
  cashew::IString filename;
  uint32_t line;
  uint32_t column;
  SourceLocation(cashew::IString filename_, uint32_t line_, uint32_t column_ = 0)
   : filename(filename_), line(line_), column(column_) {}
};

//
// An element in an S-Expression: a list or a string
//
class Element {
  typedef ArenaVector<Element*> List;

  bool isList_;
  List list_;
  cashew::IString str_;
  bool dollared_;
  bool quoted_;

public:
  Element(MixedArena& allocator) : isList_(true), list_(allocator), line(-1), col(-1), loc(nullptr) {}

  bool isList() const { return isList_; }
  bool isStr() const { return !isList_; }
  bool dollared() const { return isStr() && dollared_; }
  bool quoted() const { return isStr() && quoted_; }

  size_t line, col;
  SourceLocation* loc;

  // list methods
  List& list();
  Element* operator[](unsigned i);
  size_t size() {
    return list().size();
  }

  // string methods
  cashew::IString str() const;
  const char* c_str() const;
  Element* setString(cashew::IString str__, bool dollared__, bool quoted__);
  Element* setMetadata(size_t line_, size_t col_, SourceLocation* loc_);

  // printing
  friend std::ostream& operator<<(std::ostream& o, Element& e);
  void dump();
};

//
// Generic S-Expression parsing into lists
//
class SExpressionParser {
  char* input;
  size_t line;
  char* lineStart;
  SourceLocation* loc;

  MixedArena allocator;

public:
  // Assumes control of and modifies the input.
  SExpressionParser(char* input);
  Element* root;

private:
  Element* parse();
  void skipWhitespace();
  void parseDebugLocation();
  Element* parseString();
};

//
// SExpressions => WebAssembly module
//
class SExpressionWasmBuilder {
  Module& wasm;
  MixedArena& allocator;
  std::vector<Name> functionNames;
  std::vector<Name> functionTypeNames;
  std::vector<Name> globalNames;
  int functionCounter;
  int globalCounter;
  std::map<Name, WasmType> functionTypes; // we need to know function return types before we parse their contents
  std::unordered_map<cashew::IString, Index> debugInfoFileIndices;

public:
  // Assumes control of and modifies the input.
  SExpressionWasmBuilder(Module& wasm, Element& module, Name* moduleName = nullptr);

private:
  // pre-parse types and function definitions, so we know function return types before parsing their contents
  void preParseFunctionType(Element& s);
  bool isImport(Element& curr);
  void preParseImports(Element& curr);
  void parseModuleElement(Element& curr);

  // function parsing state
  std::unique_ptr<Function> currFunction;
  std::map<Name, WasmType> currLocalTypes;
  size_t localIndex; // params and vars
  size_t otherIndex;
  bool brokeToAutoBlock;

  UniqueNameMapper nameMapper;

  Name getFunctionName(Element& s);
  Name getFunctionTypeName(Element& s);
  Name getGlobalName(Element& s);
  void parseStart(Element& s) { wasm.addStart(getFunctionName(*s[1]));}

  // returns the next index in s
  size_t parseFunctionNames(Element& s, Name& name, Name& exportName);
  void parseFunction(Element& s, bool preParseImport = false);

  WasmType stringToWasmType(cashew::IString str, bool allowError=false, bool prefix=false) {
    return stringToWasmType(str.str, allowError, prefix);
  }
  WasmType stringToWasmType(const char* str, bool allowError=false, bool prefix=false);
  bool isWasmType(cashew::IString str) {
    return stringToWasmType(str, true) != none;
  }

public:
  Expression* parseExpression(Element* s) {
    return parseExpression(*s);
  }
  Expression* parseExpression(Element& s);

private:
  Expression* makeExpression(Element& s);
  Expression* makeBinary(Element& s, BinaryOp op, WasmType type);
  Expression* makeUnary(Element& s, UnaryOp op, WasmType type);
  Expression* makeSelect(Element& s);
  Expression* makeDrop(Element& s);
  Expression* makeHost(Element& s, HostOp op);
  Index getLocalIndex(Element& s);
  Expression* makeGetLocal(Element& s);
  Expression* makeTeeLocal(Element& s);
  Expression* makeSetLocal(Element& s);
  Expression* makeGetGlobal(Element& s);
  Expression* makeSetGlobal(Element& s);
  Expression* makeBlock(Element& s);
  Expression* makeThenOrElse(Element& s);
  Expression* makeConst(Element& s, WasmType type);
  Expression* makeLoad(Element& s, WasmType type);
  Expression* makeStore(Element& s, WasmType type);
  Expression* makeIf(Element& s);
  Expression* makeMaybeBlock(Element& s, size_t i, WasmType type);
  Expression* makeLoop(Element& s);
  Expression* makeCall(Element& s);
  Expression* makeCallImport(Element& s);
  Expression* makeCallIndirect(Element& s);
  template<class T>
  void parseCallOperands(Element& s, Index i, Index j, T* call) {
    while (i < j) {
      call->operands.push_back(parseExpression(s[i]));
      i++;
    }
  }
  Name getLabel(Element& s);
  Expression* makeBreak(Element& s);
  Expression* makeBreakTable(Element& s);
  Expression* makeReturn(Element& s);

  WasmType parseOptionalResultType(Element& s, Index& i);

  void stringToBinary(const char* input, size_t size, std::vector<char>& data);
  void parseMemory(Element& s, bool preParseImport = false);
  void parseData(Element& s);
  void parseInnerData(Element& s, Index i = 1, Expression* offset = nullptr);
  void parseExport(Element& s);
  void parseImport(Element& s);
  void parseGlobal(Element& s, bool preParseImport = false);
  void parseTable(Element& s, bool preParseImport = false);
  void parseElem(Element& s);
  void parseInnerElem(Element& s, Index i = 1, Expression* offset = nullptr);
  void parseType(Element& s);
};

} // namespace wasm

#endif // wasm_wasm_s_parser_h
