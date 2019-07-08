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

#include "mixed_arena.h"
#include "parsing.h" // for UniqueNameMapper. TODO: move dependency to cpp file?
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

class SourceLocation {
public:
  cashew::IString filename;
  uint32_t line;
  uint32_t column;
  SourceLocation(cashew::IString filename_,
                 uint32_t line_,
                 uint32_t column_ = 0)
    : filename(filename_), line(line_), column(column_) {}
};

//
// An element in an S-Expression: a list or a string
//
class Element {
  typedef ArenaVector<Element*> List;

  bool isList_ = true;
  List list_;
  cashew::IString str_;
  bool dollared_;
  bool quoted_;

public:
  Element(MixedArena& allocator) : list_(allocator) {}

  bool isList() const { return isList_; }
  bool isStr() const { return !isList_; }
  bool dollared() const { return isStr() && dollared_; }
  bool quoted() const { return isStr() && quoted_; }

  size_t line = -1;
  size_t col = -1;
  // original locations at the start/end of the S-Expression list
  SourceLocation* startLoc = nullptr;
  SourceLocation* endLoc = nullptr;

  // list methods
  List& list();
  Element* operator[](unsigned i);
  size_t size() { return list().size(); }

  // string methods
  cashew::IString str() const;
  const char* c_str() const;
  Element* setString(cashew::IString str__, bool dollared__, bool quoted__);
  Element* setMetadata(size_t line_, size_t col_, SourceLocation* startLoc_);

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
  SourceLocation* loc = nullptr;

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
  std::vector<Name> globalNames;
  std::vector<Name> eventNames;
  int functionCounter = 0;
  int globalCounter = 0;
  int eventCounter = 0;
  // we need to know function return types before we parse their contents
  std::map<Name, Type> functionTypes;
  std::unordered_map<cashew::IString, Index> debugInfoFileIndices;

public:
  // Assumes control of and modifies the input.
  SExpressionWasmBuilder(Module& wasm,
                         Element& module,
                         Name* moduleName = nullptr);

private:
  // pre-parse types and function definitions, so we know function return types
  // before parsing their contents
  void preParseFunctionType(Element& s);
  bool isImport(Element& curr);
  void preParseImports(Element& curr);
  void parseModuleElement(Element& curr);

  // function parsing state
  std::unique_ptr<Function> currFunction;
  bool brokeToAutoBlock;

  UniqueNameMapper nameMapper;

  Name getFunctionName(Element& s);
  Name getFunctionTypeName(Element& s);
  Name getGlobalName(Element& s);
  Name getEventName(Element& s);
  void parseStart(Element& s) { wasm.addStart(getFunctionName(*s[1])); }

  // returns the next index in s
  size_t parseFunctionNames(Element& s, Name& name, Name& exportName);
  void parseFunction(Element& s, bool preParseImport = false);

  Type stringToType(cashew::IString str,
                    bool allowError = false,
                    bool prefix = false) {
    return stringToType(str.str, allowError, prefix);
  }
  Type
  stringToType(const char* str, bool allowError = false, bool prefix = false);
  Type stringToLaneType(const char* str);
  bool isType(cashew::IString str) { return stringToType(str, true) != none; }

public:
  Expression* parseExpression(Element* s) { return parseExpression(*s); }
  Expression* parseExpression(Element& s);

  MixedArena& getAllocator() { return allocator; }

private:
  Expression* makeExpression(Element& s);
  Expression* makeUnreachable();
  Expression* makeNop();
  Expression* makeBinary(Element& s, BinaryOp op);
  Expression* makeUnary(Element& s, UnaryOp op);
  Expression* makeSelect(Element& s);
  Expression* makeDrop(Element& s);
  Expression* makeHost(Element& s, HostOp op);
  Index getLocalIndex(Element& s);
  Expression* makeLocalGet(Element& s);
  Expression* makeLocalTee(Element& s);
  Expression* makeLocalSet(Element& s);
  Expression* makeGlobalGet(Element& s);
  Expression* makeGlobalSet(Element& s);
  Expression* makeBlock(Element& s);
  Expression* makeThenOrElse(Element& s);
  Expression* makeConst(Element& s, Type type);
  Expression* makeLoad(Element& s, Type type, bool isAtomic);
  Expression* makeStore(Element& s, Type type, bool isAtomic);
  Expression* makeAtomicRMWOrCmpxchg(Element& s, Type type);
  Expression*
  makeAtomicRMW(Element& s, Type type, uint8_t bytes, const char* extra);
  Expression*
  makeAtomicCmpxchg(Element& s, Type type, uint8_t bytes, const char* extra);
  Expression* makeAtomicWait(Element& s, Type type);
  Expression* makeAtomicNotify(Element& s);
  Expression* makeSIMDExtract(Element& s, SIMDExtractOp op, size_t lanes);
  Expression* makeSIMDReplace(Element& s, SIMDReplaceOp op, size_t lanes);
  Expression* makeSIMDShuffle(Element& s);
  Expression* makeSIMDBitselect(Element& s);
  Expression* makeSIMDShift(Element& s, SIMDShiftOp op);
  Expression* makeMemoryInit(Element& s);
  Expression* makeDataDrop(Element& s);
  Expression* makeMemoryCopy(Element& s);
  Expression* makeMemoryFill(Element& s);
  Expression* makePush(Element& s);
  Expression* makePop(Type type);
  Expression* makeIf(Element& s);
  Expression* makeMaybeBlock(Element& s, size_t i, Type type);
  Expression* makeLoop(Element& s);
  Expression* makeCall(Element& s, bool isReturn);
  Expression* makeCallIndirect(Element& s, bool isReturn);
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

  // Helper functions
  Type parseOptionalResultType(Element& s, Index& i);
  Index parseMemoryLimits(Element& s, Index i);
  std::vector<Type> parseParamOrLocal(Element& s);
  std::vector<NameType> parseParamOrLocal(Element& s, size_t& localIndex);
  Type parseResult(Element& s);
  FunctionType* parseTypeRef(Element& s);
  size_t parseTypeUse(Element& s,
                      size_t startPos,
                      FunctionType*& functionType,
                      std::vector<NameType>& namedParams,
                      Type& result);
  size_t parseTypeUse(Element& s,
                      size_t startPos,
                      FunctionType*& functionType,
                      std::vector<Type>& params,
                      Type& result);
  size_t parseTypeUse(Element& s, size_t startPos, FunctionType*& functionType);

  void stringToBinary(const char* input, size_t size, std::vector<char>& data);
  void parseMemory(Element& s, bool preParseImport = false);
  void parseData(Element& s);
  void parseInnerData(Element& s, Index i, Expression* offset, bool isPassive);
  void parseExport(Element& s);
  void parseImport(Element& s);
  void parseGlobal(Element& s, bool preParseImport = false);
  void parseTable(Element& s, bool preParseImport = false);
  void parseElem(Element& s);
  void parseInnerElem(Element& s, Index i = 1, Expression* offset = nullptr);
  void parseType(Element& s);
  void parseEvent(Element& s, bool preParseImport = false);

  Function::DebugLocation getDebugLocation(const SourceLocation& loc);
};

} // namespace wasm

#endif // wasm_wasm_s_parser_h
