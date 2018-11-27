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

#include <cmath>
#include <cctype>
#include <limits>

#include "asm_v_wasm.h"
#include "asmjs/shared-constants.h"
#include "ir/branch-utils.h"
#include "ir/function-type-utils.h"
#include "shared-constants.h"
#include "wasm-binary.h"
#include "wasm-builder.h"

#define abort_on(str) { throw ParseException(std::string("abort_on ") + str); }
#define element_assert(condition) assert((condition) ? true : (std::cerr << "on: " << *this << '\n' && 0));

using cashew::IString;

namespace {
int unhex(char c) {
  if (c >= '0' && c <= '9') return c - '0';
  if (c >= 'a' && c <= 'f') return c - 'a' + 10;
  if (c >= 'A' && c <= 'F') return c - 'A' + 10;
  throw wasm::ParseException("invalid hexadecimal");
}
}

namespace wasm {

static Address getCheckedAddress(const Element* s, const char* errorText) {
  uint64_t num = atoll(s->c_str());
  if (num > std::numeric_limits<Address::address_t>::max()) {
    throw ParseException(errorText, s->line, s->col);
  }
  return num;
}

Element::List& Element::list() {
  if (!isList()) throw ParseException("expected list", line, col);
  return list_;
}

Element* Element::operator[](unsigned i) {
  if (!isList()) throw ParseException("expected list", line, col);
  if (i >= list().size()) throw ParseException("expected more elements in list", line, col);
  return list()[i];
}

IString Element::str() const {
  if (!isStr()) throw ParseException("expected string", line, col);
  return str_;
}

const char* Element::c_str() const {
  if (!isStr()) throw ParseException("expected string", line, col);
  return str_.str;
}

Element* Element::setString(IString str__, bool dollared__, bool quoted__) {
  isList_ = false;
  str_ = str__;
  dollared_ = dollared__;
  quoted_ = quoted__;
  return this;
}

Element* Element::setMetadata(size_t line_, size_t col_, SourceLocation* startLoc_) {
  line = line_;
  col = col_;
  startLoc = startLoc_;
  return this;
}

std::ostream& operator<<(std::ostream& o, Element& e) {
  if (e.isList_) {
    o << '(';
    for (auto item : e.list_) o << ' ' << *item;
    o << " )";
  } else {
    o << e.str_.str;
  }
  return o;
}

void Element::dump() {
  std::cout << "dumping " << this << " : " << *this << ".\n";
}


SExpressionParser::SExpressionParser(char* input) : input(input), loc(nullptr) {
  root = nullptr;
  line = 1;
  lineStart = input;
  while (!root) { // keep parsing until we pass an initial comment
    root = parse();
  }
}

Element* SExpressionParser::parse() {
  std::vector<Element *> stack;
  std::vector<SourceLocation*> stackLocs;
  Element *curr = allocator.alloc<Element>();
  while (1) {
    skipWhitespace();
    if (input[0] == 0) break;
    if (input[0] == '(') {
      input++;
      stack.push_back(curr);
      curr = allocator.alloc<Element>()->setMetadata(line, input - lineStart - 1, loc);
      stackLocs.push_back(loc);
      assert(stack.size() == stackLocs.size());
    } else if (input[0] == ')') {
      input++;
      curr->endLoc = loc;
      auto last = curr;
      if (stack.empty()) {
        throw ParseException("s-expr stack empty");
      }
      curr = stack.back();
      assert(stack.size() == stackLocs.size());
      stack.pop_back();
      loc = stackLocs.back();
      stackLocs.pop_back();
      curr->list().push_back(last);
    } else {
      curr->list().push_back(parseString());
    }
  }
  if (stack.size() != 0) throw ParseException("stack is not empty", curr->line, curr->col);
  return curr;
}

void SExpressionParser::parseDebugLocation() {
  // Extracting debug location (if valid)
  char* debugLoc = input + 3; // skipping ";;@"
  while (debugLoc[0] && debugLoc[0] == ' ') debugLoc++;
  char* debugLocEnd = debugLoc;
  while (debugLocEnd[0] && debugLocEnd[0] != '\n') debugLocEnd++;
  char* pos = debugLoc;
  while (pos < debugLocEnd && pos[0] != ':') pos++;
  if (pos >= debugLocEnd) {
    return; // no line number
  }
  std::string name(debugLoc, pos);
  char* lineStart = ++pos;
  while (pos < debugLocEnd && pos[0] != ':') pos++;
  std::string lineStr(lineStart, pos);
  if (pos >= debugLocEnd) {
    return; // no column number
  }
  std::string colStr(++pos, debugLocEnd);
  void* buf = allocator.allocSpace(sizeof(SourceLocation), alignof(SourceLocation));
  loc = new (buf) SourceLocation(IString(name.c_str(), false), atoi(lineStr.c_str()), atoi(colStr.c_str()));
}

void SExpressionParser::skipWhitespace() {
  while (1) {
    while (isspace(input[0])) {
      if (input[0] == '\n') {
        line++;
        lineStart = input + 1;
      }
      input++;
    }
    if (input[0] == ';' && input[1] == ';') {
      if (input[2] == '@') {
        parseDebugLocation();
      }
      while (input[0] && input[0] != '\n') input++;
      line++;
      lineStart = ++input;
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
        } else if (input[0] == '\n') {
          line++;
          lineStart = input;
          input++;
        } else {
          input++;
        }
      }
    } else {
      return;
    }
  }
}

Element* SExpressionParser::parseString() {
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
      if (input[0] == 0) throw ParseException("unterminated string", line, start - lineStart);
      if (input[0] == '"') break;
      if (input[0] == '\\') {
        str += input[0];
        if (input[1] == 0) throw ParseException("unterminated string escape", line, start - lineStart);
        str += input[1];
        input += 2;
        continue;
      }
      str += input[0];
      input++;
    }
    input++;
    return allocator.alloc<Element>()->setString(IString(str.c_str(), false), dollared, true)->setMetadata(line, start - lineStart, loc);
  }
  while (input[0] && !isspace(input[0]) && input[0] != ')' && input[0] != '(' && input[0] != ';') input++;
  if (start == input) throw ParseException("expected string", line, input - lineStart);
  char temp = input[0];
  input[0] = 0;
  auto ret = allocator.alloc<Element>()->setString(IString(start, false), dollared, false)->setMetadata(line, start - lineStart, loc);
  input[0] = temp;
  return ret;
}

SExpressionWasmBuilder::SExpressionWasmBuilder(Module& wasm, Element& module, Name* moduleName) : wasm(wasm), allocator(wasm.allocator), globalCounter(0) {
  if (module.size() == 0) throw ParseException("empty toplevel, expected module");
  if (module[0]->str() != MODULE) throw ParseException("toplevel does not start with module");
  if (module.size() == 1) return;
  Index i = 1;
  if (module[i]->dollared()) {
    if (moduleName) {
      *moduleName = module[i]->str();
    }
    i++;
  }
  if (i < module.size() && module[i]->isStr()) {
    // these s-expressions contain a binary module, actually
    std::vector<char> data;
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
  Index implementedFunctions = 0;
  functionCounter = 0;
  for (unsigned j = i; j < module.size(); j++) {
    auto& s = *module[j];
    preParseFunctionType(s);
    preParseImports(s);
    if (s[0]->str() == FUNC && !isImport(s)) {
      implementedFunctions++;
    }
  }
  functionCounter -= implementedFunctions; // we go through the functions again, now parsing them, and the counter begins from where imports ended
  for (unsigned j = i; j < module.size(); j++) {
    parseModuleElement(*module[j]);
  }
}

bool SExpressionWasmBuilder::isImport(Element& curr) {
  for (Index i = 0; i < curr.size(); i++) {
    auto& x = *curr[i];
    if (x.isList() && x.size() > 0 && x[0]->isStr() && x[0]->str() == IMPORT) return true;
  }
  return false;
}

void SExpressionWasmBuilder::preParseImports(Element& curr) {
  IString id = curr[0]->str();
  if (id == IMPORT) parseImport(curr);
  if (isImport(curr)) {
    if (id == FUNC) parseFunction(curr, true /* preParseImport */);
    else if (id == GLOBAL) parseGlobal(curr, true /* preParseImport */);
    else if (id == TABLE) parseTable(curr, true /* preParseImport */);
    else if (id == MEMORY) parseMemory(curr, true /* preParseImport */);
    else throw ParseException("fancy import we don't support yet", curr.line, curr.col);
  }
}

void SExpressionWasmBuilder::parseModuleElement(Element& curr) {
  if (isImport(curr)) return; // already done
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

Name SExpressionWasmBuilder::getFunctionName(Element& s) {
  if (s.dollared()) {
    return s.str();
  } else {
    // index
    size_t offset = atoi(s.str().c_str());
    if (offset >= functionNames.size()) throw ParseException("unknown function in getFunctionName");
    return functionNames[offset];
  }
}

Name SExpressionWasmBuilder::getFunctionTypeName(Element& s) {
  if (s.dollared()) {
    return s.str();
  } else {
    // index
    size_t offset = atoi(s.str().c_str());
    if (offset >= functionTypeNames.size()) throw ParseException("unknown function type in getFunctionTypeName");
    return functionTypeNames[offset];
  }
}

Name SExpressionWasmBuilder::getGlobalName(Element& s) {
  if (s.dollared()) {
    return s.str();
  } else {
    // index
    size_t offset = atoi(s.str().c_str());
    if (offset >= globalNames.size()) throw ParseException("unknown global in getGlobalName");
    return globalNames[offset];
  }
}


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
  std::vector<Type> params;
  for (;i < s.size(); i++) {
    Element& curr = *s[i];
    IString id = curr[0]->str();
    if (id == RESULT) {
      if (curr.size() > 2) throw ParseException("invalid result arity", curr.line, curr.col);
      functionTypes[name] = stringToType(curr[1]->str());
    } else if (id == TYPE) {
      Name typeName = getFunctionTypeName(*curr[1]);
      if (!wasm.getFunctionTypeOrNull(typeName)) throw ParseException("unknown function type", curr.line, curr.col);
      type = wasm.getFunctionType(typeName);
      functionTypes[name] = type->result;
    } else if (id == PARAM && curr.size() > 1) {
      Index j = 1;
      if (curr[j]->dollared()) {
        // dollared input symbols cannot be types
        params.push_back(stringToType(curr[j + 1]->str(), true));
      } else {
        while (j < curr.size()) {
          params.push_back(stringToType(curr[j++]->str(), true));
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
      if (wasm.getFunctionTypeOrNull(functionType->name)) throw ParseException("duplicate function type", s.line, s.col);
      wasm.addFunctionType(functionType.release());
    }
  }
}

size_t SExpressionWasmBuilder::parseFunctionNames(Element& s, Name& name, Name& exportName) {
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
  if (i < s.size() && s[i]->isList()) {
    auto& inner = *s[i];
    if (inner.size() > 0 && inner[0]->str() == EXPORT) {
      exportName = inner[1]->str();
      i++;
    }
  }
#if 0
  if (exportName.is() && !name.is()) {
    name = exportName; // useful for debugging
  }
#endif
  return i;
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
    if (wasm.getExportOrNull(ex->name)) throw ParseException("duplicate export", s.line, s.col);
    wasm.addExport(ex.release());
  }
  Expression* body = nullptr;
  localIndex = 0;
  otherIndex = 0;
  brokeToAutoBlock = false;
  std::vector<NameType> typeParams; // we may have both params and a type. store the type info here
  std::vector<NameType> params;
  std::vector<NameType> vars;
  Type result = none;
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
        Type type = none;
        if (!curr[j]->dollared()) { // dollared input symbols cannot be types
          type = stringToType(curr[j]->str(), true);
        }
        if (type != none) {
          // a type, so an unnamed parameter
          name = Name::fromInt(localIndex);
        } else {
          name = curr[j]->str();
          type = stringToType(curr[j+1]->str());
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
      result = stringToType(curr[1]->str());
    } else if (id == TYPE) {
      Name name = getFunctionTypeName(*curr[1]);
      type = name;
      if (!wasm.getFunctionTypeOrNull(name)) throw ParseException("unknown function type");
      FunctionType* type = wasm.getFunctionType(name);
      result = type->result;
      for (size_t j = 0; j < type->params.size(); j++) {
        IString name = Name::fromInt(j);
        Type currType = type->params[j];
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
    if (!preParseImport) throw ParseException("!preParseImport in func");
    auto im = make_unique<Function>();
    im->name = name;
    im->module = importModule;
    im->base = importBase;
    im->type = type;
    FunctionTypeUtils::fillFunction(im.get(), wasm.getFunctionType(type));
    functionTypes[name] = im->result;
    if (wasm.getFunctionOrNull(im->name)) throw ParseException("duplicate import", s.line, s.col);
    wasm.addFunction(im.release());
    if (currFunction) throw ParseException("import module inside function dec");
    currLocalTypes.clear();
    nameMapper.clear();
    return;
  }
  if (preParseImport) throw ParseException("preParseImport in func");
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
  if (s.startLoc) {
    currFunction->prologLocation.insert(getDebugLocation(*s.startLoc));
  }
  if (s.endLoc) {
    currFunction->epilogLocation.insert(getDebugLocation(*s.endLoc));
  }
  if (wasm.getFunctionOrNull(currFunction->name)) throw ParseException("duplicate function", s.line, s.col);
  wasm.addFunction(currFunction.release());
  currLocalTypes.clear();
  nameMapper.clear();
}

Type SExpressionWasmBuilder::stringToType(const char* str, bool allowError, bool prefix) {
  if (str[0] == 'i') {
    if (str[1] == '3' && str[2] == '2' && (prefix || str[3] == 0)) return i32;
    if (str[1] == '6' && str[2] == '4' && (prefix || str[3] == 0)) return i64;
  }
  if (str[0] == 'f') {
    if (str[1] == '3' && str[2] == '2' && (prefix || str[3] == 0)) return f32;
    if (str[1] == '6' && str[2] == '4' && (prefix || str[3] == 0)) return f64;
  }
  if (allowError) return none;
  throw ParseException("invalid wasm type");
}

Function::DebugLocation SExpressionWasmBuilder::getDebugLocation(const SourceLocation& loc) {
  IString file = loc.filename;
  auto& debugInfoFileNames = wasm.debugInfoFileNames;
  auto iter = debugInfoFileIndices.find(file);
  if (iter == debugInfoFileIndices.end()) {
    Index index = debugInfoFileNames.size();
    debugInfoFileNames.push_back(file.c_str());
    debugInfoFileIndices[file] = index;
  }
  uint32_t fileIndex = debugInfoFileIndices[file];
  return {fileIndex, loc.line, loc.column};
}

Expression* SExpressionWasmBuilder::parseExpression(Element& s) {
  Expression* result = makeExpression(s);
  if (s.startLoc) {
    currFunction->debugLocations[result] = getDebugLocation(*s.startLoc);
  }
  return result;
}

Expression* SExpressionWasmBuilder::makeExpression(Element& s) {
#define INSTRUCTION_PARSER
#include "gen-s-parser.inc"
}

Expression* SExpressionWasmBuilder::makeUnreachable() {
  return allocator.alloc<Unreachable>();
}

Expression* SExpressionWasmBuilder::makeNop() {
  return allocator.alloc<Nop>();
}

Expression* SExpressionWasmBuilder::makeBinary(Element& s, BinaryOp op) {
  auto ret = allocator.alloc<Binary>();
  ret->op = op;
  ret->left = parseExpression(s[1]);
  ret->right = parseExpression(s[2]);
  ret->finalize();
  return ret;
}


Expression* SExpressionWasmBuilder::makeUnary(Element& s, UnaryOp op) {
  auto ret = allocator.alloc<Unary>();
  ret->op = op;
  ret->value = parseExpression(s[1]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeSelect(Element& s) {
  auto ret = allocator.alloc<Select>();
  ret->ifTrue = parseExpression(s[1]);
  ret->ifFalse = parseExpression(s[2]);
  ret->condition = parseExpression(s[3]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeDrop(Element& s) {
  auto ret = allocator.alloc<Drop>();
  ret->value = parseExpression(s[1]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeHost(Element& s, HostOp op) {
  auto ret = allocator.alloc<Host>();
  ret->op = op;
  parseCallOperands(s, 1, s.size(), ret);
  if (ret->op == HostOp::GrowMemory) {
    if (ret->operands.size() != 1) {
      throw ParseException("grow_memory needs one operand");
    }
  } else {
    if (ret->operands.size() != 0) {
      throw ParseException("host needs zero operands");
    }
  }
  ret->finalize();
  return ret;
}

Index SExpressionWasmBuilder::getLocalIndex(Element& s) {
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

Expression* SExpressionWasmBuilder::makeGetLocal(Element& s) {
  auto ret = allocator.alloc<GetLocal>();
  ret->index = getLocalIndex(*s[1]);
  ret->type = currFunction->getLocalType(ret->index);
  return ret;
}

Expression* SExpressionWasmBuilder::makeTeeLocal(Element& s) {
  auto ret = allocator.alloc<SetLocal>();
  ret->index = getLocalIndex(*s[1]);
  ret->value = parseExpression(s[2]);
  ret->setTee(true);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeSetLocal(Element& s) {
  auto ret = allocator.alloc<SetLocal>();
  ret->index = getLocalIndex(*s[1]);
  ret->value = parseExpression(s[2]);
  ret->setTee(false);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeGetGlobal(Element& s) {
  auto ret = allocator.alloc<GetGlobal>();
  ret->name = getGlobalName(*s[1]);
  auto* global = wasm.getGlobalOrNull(ret->name);
  if (!global) {
    throw ParseException("bad get_global name", s.line, s.col);
  }
  ret->type = global->type;
  return ret;
}

Expression* SExpressionWasmBuilder::makeSetGlobal(Element& s) {
  auto ret = allocator.alloc<SetGlobal>();
  ret->name = getGlobalName(*s[1]);
  if (wasm.getGlobalOrNull(ret->name) && !wasm.getGlobalOrNull(ret->name)->mutable_) throw ParseException("set_global of immutable", s.line, s.col);
  ret->value = parseExpression(s[2]);
  ret->finalize();
  return ret;
}


Expression* SExpressionWasmBuilder::makeBlock(Element& s) {
  // special-case Block, because Block nesting (in their first element) can be incredibly deep
  auto curr = allocator.alloc<Block>();
  auto* sp = &s;
  std::vector<std::pair<Element*, Block*>> stack;
  while (1) {
    stack.emplace_back(sp, curr);
    auto& s = *sp;
    Index i = 1;
    Name sName;
    if (i < s.size() && s[i]->isStr()) {
      // could be a name or a type
      if (s[i]->dollared() || stringToType(s[i]->str(), true /* allowError */) == none) {
        sName = s[i++]->str();
      } else {
        sName = "block";
      }
    } else {
      sName = "block";
    }
    curr->name = nameMapper.pushLabelName(sName);
    // block signature
    curr->type = parseOptionalResultType(s, i);
    if (i >= s.size()) break; // empty block
    auto& first = *s[i];
    if (first[0]->str() == BLOCK) {
      // recurse
      curr = allocator.alloc<Block>();
      if (first.startLoc) {
        currFunction->debugLocations[curr] = getDebugLocation(*first.startLoc);
      }
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
      while (i < s.size() && s[i]->isStr()) {
        i++;
      }
      if (i < s.size() && (*s[i])[0]->str() == RESULT) {
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
    nameMapper.popLabelName(curr->name);
    curr->finalize(curr->type);
  }
  return stack[0].second;
}

// Similar to block, but the label is handled by the enclosing if (since there might not be a then or else, ick)
Expression* SExpressionWasmBuilder::makeThenOrElse(Element& s) {
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

Expression* SExpressionWasmBuilder::makeConst(Element& s, Type type) {
  auto ret = parseConst(s[1]->str(), type, allocator);
  if (!ret) throw ParseException("bad const");
  return ret;
}

static uint8_t parseMemBytes(const char*& s, uint8_t fallback) {
  uint8_t ret;
  if (s[0] == '8') {
    ret = 1;
    s++;
  } else if (s[0] == '1') {
    if (s[1] != '6') throw ParseException("expected 16 for memop size");
    ret = 2;
    s += 2;
  } else if (s[0] == '3') {
    if (s[1] != '2') throw ParseException("expected 32 for memop size");;
    ret = 4;
    s += 2;
  } else {
    ret = fallback;
  }
  return ret;
}

static size_t parseMemAttributes(Element& s, Address* offset, Address* align, Address fallback) {
  size_t i = 1;
  *offset = 0;
  *align = fallback;
  while (!s[i]->isList()) {
    const char *str = s[i]->c_str();
    const char *eq = strchr(str, '=');
    if (!eq) throw ParseException("missing = in memory attribute");
    eq++;
    if (*eq == 0) throw ParseException("missing value in memory attribute", s.line, s.col);
    char* endptr;
    uint64_t value = strtoll(eq, &endptr, 10);
    if (*endptr != 0) {
      throw ParseException("bad memory attribute immediate", s.line, s.col);
    }
    if (str[0] == 'a') {
      if (value > std::numeric_limits<uint32_t>::max()) throw ParseException("bad align");
      *align = value;
    } else if (str[0] == 'o') {
      if (value > std::numeric_limits<uint32_t>::max()) throw ParseException("bad offset");
      *offset = value;
    } else throw ParseException("bad memory attribute");
    i++;
  }
  return i;
}

static const char* findMemExtra(const Element& s, size_t skip, bool isAtomic) {
  auto* str = s.c_str();
  auto size = strlen(str);
  auto* ret = strchr(str, '.');
  if (!ret) throw ParseException("missing '.' in memory access", s.line, s.col);
  ret += skip;
  if (isAtomic) ret += 7; // after "type.atomic.load"
  if (ret > str + size) throw ParseException("memory access ends abruptly", s.line, s.col);
  return ret;
}

Expression* SExpressionWasmBuilder::makeLoad(Element& s, Type type, bool isAtomic) {
  const char* extra = findMemExtra(*s[0], 5 /* after "type.load" */, isAtomic);
  auto* ret = allocator.alloc<Load>();
  ret->isAtomic = isAtomic;
  ret->type = type;
  ret->bytes = parseMemBytes(extra, getTypeSize(type));
  ret->signed_ = extra[0] && extra[1] == 's';
  size_t i = parseMemAttributes(s, &ret->offset, &ret->align, ret->bytes);
  ret->ptr = parseExpression(s[i]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeStore(Element& s, Type type, bool isAtomic) {
  const char* extra = findMemExtra(*s[0], 6 /* after "type.store" */, isAtomic);
  auto ret = allocator.alloc<Store>();
  ret->isAtomic = isAtomic;
  ret->valueType = type;
  ret->bytes = parseMemBytes(extra, getTypeSize(type));
  size_t i = parseMemAttributes(s, &ret->offset, &ret->align, ret->bytes);
  ret->ptr = parseExpression(s[i]);
  ret->value = parseExpression(s[i+1]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeAtomicRMWOrCmpxchg(Element& s, Type type) {
  const char* extra = findMemExtra(*s[0], 11 /* after "type.atomic.rmw" */, /* isAtomic = */ false);
  auto bytes = parseMemBytes(extra, getTypeSize(type));
  extra = strchr(extra, '.'); // after the optional '_u' and before the opcode
  if (!extra) throw ParseException("malformed atomic rmw instruction");
  extra++; // after the '.'
  if (!strncmp(extra, "cmpxchg", 7)) return makeAtomicCmpxchg(s, type, bytes, extra);
  return makeAtomicRMW(s, type, bytes, extra);
}

Expression* SExpressionWasmBuilder::makeAtomicRMW(Element& s, Type type, uint8_t bytes, const char* extra) {
  auto ret = allocator.alloc<AtomicRMW>();
  ret->type = type;
  ret->bytes = bytes;
  if (!strncmp(extra, "add", 3)) ret->op = Add;
  else if (!strncmp(extra, "and", 3)) ret->op = And;
  else if (!strncmp(extra, "or", 2)) ret->op = Or;
  else if (!strncmp(extra, "sub", 3)) ret->op = Sub;
  else if (!strncmp(extra, "xor", 3)) ret->op = Xor;
  else if (!strncmp(extra, "xchg", 4)) ret->op = Xchg;
  else throw ParseException("bad atomic rmw operator");
  Address align;
  size_t i = parseMemAttributes(s, &ret->offset, &align, ret->bytes);
  if (align != ret->bytes) throw ParseException("Align of Atomic RMW must match size");
  ret->ptr = parseExpression(s[i]);
  ret->value = parseExpression(s[i+1]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeAtomicCmpxchg(Element& s, Type type, uint8_t bytes, const char* extra) {
  auto ret = allocator.alloc<AtomicCmpxchg>();
  ret->type = type;
  ret->bytes = bytes;
  Address align;
  size_t i = parseMemAttributes(s, &ret->offset, &align, ret->bytes);
  if (align != ret->bytes) throw ParseException("Align of Atomic Cmpxchg must match size");
  ret->ptr = parseExpression(s[i]);
  ret->expected = parseExpression(s[i+1]);
  ret->replacement = parseExpression(s[i+2]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeAtomicWait(Element& s, Type type) {
  auto ret = allocator.alloc<AtomicWait>();
  ret->type = i32;
  ret->expectedType = type;
  ret->ptr = parseExpression(s[1]);
  ret->expected = parseExpression(s[2]);
  ret->timeout = parseExpression(s[3]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeAtomicWake(Element& s) {
  auto ret = allocator.alloc<AtomicWake>();
  ret->type = i32;
  ret->ptr = parseExpression(s[1]);
  ret->wakeCount = parseExpression(s[2]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeIf(Element& s) {
  auto ret = allocator.alloc<If>();
  Index i = 1;
  Name sName;
  if (s[i]->dollared()) {
    // the if is labeled
    sName = s[i++]->str();
  } else {
    sName = "if";
  }
  auto label = nameMapper.pushLabelName(sName);
  // if signature
  Type type = parseOptionalResultType(s, i);
  ret->condition = parseExpression(s[i++]);
  ret->ifTrue = parseExpression(*s[i++]);
  if (i < s.size()) {
    ret->ifFalse = parseExpression(*s[i++]);
  }
  ret->finalize(type);
  nameMapper.popLabelName(label);
  // create a break target if we must
  if (BranchUtils::BranchSeeker::hasNamed(ret, label)) {
    auto* block = allocator.alloc<Block>();
    block->name = label;
    block->list.push_back(ret);
    block->finalize(ret->type);
    return block;
  }
  return ret;
}


Expression* SExpressionWasmBuilder::makeMaybeBlock(Element& s, size_t i, Type type) {
  Index stopAt = -1;
  if (s.size() == i) return allocator.alloc<Nop>();
  if (s.size() == i+1) return parseExpression(s[i]);
  auto ret = allocator.alloc<Block>();
  for (; i < s.size() && i < stopAt; i++) {
    ret->list.push_back(parseExpression(s[i]));
  }
  ret->finalize(type);
  // Note that we do not name these implicit/synthetic blocks. They
  // are the effects of syntactic sugar, and nothing can branch to
  // them anyhow.
  return ret;
}

Type SExpressionWasmBuilder::parseOptionalResultType(Element& s, Index& i) {
  if (s.size() == i)
    return none;

  // TODO(sbc): Remove support for old result syntax (bare streing) once the
  // spec tests are updated.
  if (s[i]->isStr())
    return stringToType(s[i++]->str());

  Element& params = *s[i];
  IString id = params[0]->str();
  if (id != RESULT)
    return none;

  i++;
  return stringToType(params[1]->str());
}

Expression* SExpressionWasmBuilder::makeLoop(Element& s) {
  auto ret = allocator.alloc<Loop>();
  Index i = 1;
  Name sName;
  if (s.size() > i && s[i]->dollared()) {
    sName = s[i++]->str();
  } else {
    sName = "loop-in";
  }
  ret->name = nameMapper.pushLabelName(sName);
  ret->type = parseOptionalResultType(s, i);
  ret->body = makeMaybeBlock(s, i, ret->type);
  nameMapper.popLabelName(ret->name);
  ret->finalize(ret->type);
  return ret;
}

Expression* SExpressionWasmBuilder::makeCall(Element& s) {
  auto target = getFunctionName(*s[1]);
  auto ret = allocator.alloc<Call>();
  ret->target = target;
  ret->type = functionTypes[ret->target];
  parseCallOperands(s, 2, s.size(), ret);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeCallIndirect(Element& s) {
  if (!wasm.table.exists) throw ParseException("no table");
  auto ret = allocator.alloc<CallIndirect>();
  Index i = 1;
  Element& typeElement = *s[i];
  if (typeElement[0]->str() == "type") {
    // type name given
    IString type = typeElement[1]->str();
    auto* fullType = wasm.getFunctionTypeOrNull(type);
    if (!fullType) throw ParseException("invalid call_indirect type", s.line, s.col);
    ret->fullType = fullType->name;
    i++;
  } else {
    // inline type
    FunctionType type;
    while (1) {
      Element& curr = *s[i];
      if (curr[0]->str() == PARAM) {
        for (size_t j = 1; j < curr.size(); j++) {
          type.params.push_back(stringToType(curr[j]->str()));
        }
      } else if (curr[0]->str() == RESULT) {
        type.result = stringToType(curr[1]->str());
      } else {
        break;
      }
      i++;
    }
    ret->fullType = ensureFunctionType(getSig(&type), &wasm)->name;
  }
  ret->type = wasm.getFunctionType(ret->fullType)->result;
  parseCallOperands(s, i, s.size() - 1, ret);
  ret->target = parseExpression(s[s.size() - 1]);
  ret->finalize();
  return ret;
}

Name SExpressionWasmBuilder::getLabel(Element& s) {
  if (s.dollared()) {
    return nameMapper.sourceToUnique(s.str());
  } else {
    // offset, break to nth outside label
    uint64_t offset;
    try {
      offset = std::stoll(s.c_str(), nullptr, 0);
    } catch (std::invalid_argument&) {
      throw ParseException("invalid break offset");
    } catch (std::out_of_range&) {
      throw ParseException("out of range break offset");
    }
    if (offset > nameMapper.labelStack.size()) throw ParseException("invalid label", s.line, s.col);
    if (offset == nameMapper.labelStack.size()) {
      // a break to the function's scope. this means we need an automatic block, with a name
      brokeToAutoBlock = true;
      return FAKE_RETURN;
    }
    return nameMapper.labelStack[nameMapper.labelStack.size() - 1 - offset];
  }
}

Expression* SExpressionWasmBuilder::makeBreak(Element& s) {
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

Expression* SExpressionWasmBuilder::makeBreakTable(Element& s) {
  auto ret = allocator.alloc<Switch>();
  size_t i = 1;
  while (!s[i]->isList()) {
    ret->targets.push_back(getLabel(*s[i++]));
  }
  if (ret->targets.size() == 0) throw ParseException("switch with no targets");
  ret->default_ = ret->targets.back();
  ret->targets.pop_back();
  ret->condition = parseExpression(s[i++]);
  if (i < s.size()) {
    ret->value = ret->condition;
    ret->condition = parseExpression(s[i++]);
  }
  return ret;
}

Expression* SExpressionWasmBuilder::makeReturn(Element& s) {
  auto ret = allocator.alloc<Return>();
  if (s.size() >= 2) {
    ret->value = parseExpression(s[1]);
  }
  return ret;
}

// converts an s-expression string representing binary data into an output sequence of raw bytes
// this appends to data, which may already contain content.
void SExpressionWasmBuilder::stringToBinary(const char* input, size_t size, std::vector<char>& data) {
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

Index SExpressionWasmBuilder::parseMemoryLimits(Element& s, Index i) {
  wasm.memory.initial = getCheckedAddress(s[i++], "excessive memory init");
  if (i == s.size()) {
    wasm.memory.max = Memory::kUnlimitedSize;
    return i;
  }
  uint64_t max = atoll(s[i++]->c_str());
  if (max > Memory::kMaxSize) throw ParseException("total memory must be <= 4GB");
  wasm.memory.max = max;
  return i;
}

void SExpressionWasmBuilder::parseMemory(Element& s, bool preParseImport) {
  if (wasm.memory.exists) throw ParseException("too many memories");
  wasm.memory.exists = true;
  wasm.memory.shared = false;
  Index i = 1;
  if (s[i]->dollared()) {
    wasm.memory.name = s[i++]->str();
  }
  Name importModule, importBase;
  if (s[i]->isList()) {
    auto& inner = *s[i];
    if (inner[0]->str() == EXPORT) {
      auto ex = make_unique<Export>();
      ex->name = inner[1]->str();
      ex->value = wasm.memory.name;
      ex->kind = ExternalKind::Memory;
      if (wasm.getExportOrNull(ex->name)) throw ParseException("duplicate export", s.line, s.col);
      wasm.addExport(ex.release());
      i++;
    } else if (inner[0]->str() == IMPORT) {
      wasm.memory.module = inner[1]->str();
      wasm.memory.base = inner[2]->str();
      i++;
    } else if (inner[0]->str() == "shared") {
      wasm.memory.shared = true;
      parseMemoryLimits(inner, 1);
      i++;
    } else {
      if (!(inner.size() > 0 ? inner[0]->str() != IMPORT : true)) throw ParseException("bad import ending");
      // (memory (data ..)) format
      parseInnerData(*s[i]);
      wasm.memory.initial = wasm.memory.segments[0].data.size();
      return;
    }
  }
  if (!wasm.memory.shared) i = parseMemoryLimits(s, i);

  // Parse memory initializers.
  while (i < s.size()) {
    Element& curr = *s[i];
    size_t j = 1;
    Address offsetValue;
    if (curr[0]->str() == DATA) {
      offsetValue = 0;
    } else {
      offsetValue = getCheckedAddress(curr[j++], "excessive memory offset");
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

void SExpressionWasmBuilder::parseData(Element& s) {
  if (!wasm.memory.exists) throw ParseException("data but no memory");
  Index i = 1;
  if (!s[i]->isList()) {
    // the memory is named
    i++;
  }
  auto* offset = parseExpression(s[i++]);
  parseInnerData(s, i, offset);
}

void SExpressionWasmBuilder::parseInnerData(Element& s, Index i, Expression* offset) {
  std::vector<char> data;
  while (i < s.size()) {
    const char *input = s[i++]->c_str();
    if (auto size = strlen(input)) {
      stringToBinary(input, size, data);
    }
  }
  if (!offset) {
    offset = allocator.alloc<Const>()->set(Literal(int32_t(0)));
  }
  wasm.memory.segments.emplace_back(offset, data.data(), data.size());
}

void SExpressionWasmBuilder::parseExport(Element& s) {
  std::unique_ptr<Export> ex = make_unique<Export>();
  ex->name = s[1]->str();
  if (s[2]->isList()) {
    auto& inner = *s[2];
    ex->value = inner[1]->str();
    if (inner[0]->str() == FUNC) {
      ex->kind = ExternalKind::Function;
    } else if (inner[0]->str() == MEMORY) {
      ex->kind = ExternalKind::Memory;
    } else if (inner[0]->str() == TABLE) {
      ex->kind = ExternalKind::Table;
    } else if (inner[0]->str() == GLOBAL) {
      ex->kind = ExternalKind::Global;
      if (wasm.getGlobalOrNull(ex->value) && wasm.getGlobal(ex->value)->mutable_) throw ParseException("cannot export a mutable global", s.line, s.col);
    } else {
      throw ParseException("invalid export");
    }
  } else if (!s[2]->dollared() && !std::isdigit(s[2]->str()[0])) {
    ex->value = s[3]->str();
    if (s[2]->str() == MEMORY) {
      if (!wasm.memory.exists) throw ParseException("memory exported but no memory");
      ex->kind = ExternalKind::Memory;
    } else if (s[2]->str() == TABLE) {
      ex->kind = ExternalKind::Table;
    } else if (s[2]->str() == GLOBAL) {
      ex->kind = ExternalKind::Global;
    } else {
      throw ParseException("invalid ext export");
    }
  } else {
    // function
    ex->value = s[2]->str();
    ex->kind = ExternalKind::Function;
  }
  if (wasm.getExportOrNull(ex->name)) throw ParseException("duplicate export", s.line, s.col);
  wasm.addExport(ex.release());
}

void SExpressionWasmBuilder::parseImport(Element& s) {
  size_t i = 1;
  bool newStyle = s.size() == 4 && s[3]->isList(); // (import "env" "STACKTOP" (global $stackTop i32))
  auto kind = ExternalKind::Invalid;
  if (newStyle) {
    if ((*s[3])[0]->str() == FUNC) {
      kind = ExternalKind::Function;
    } else if ((*s[3])[0]->str() == MEMORY) {
      kind = ExternalKind::Memory;
      if (wasm.memory.exists) throw ParseException("more than one memory");
      wasm.memory.exists = true;
    } else if ((*s[3])[0]->str() == TABLE) {
      kind = ExternalKind::Table;
      if (wasm.table.exists) throw ParseException("more than one table");
      wasm.table.exists = true;
    } else if ((*s[3])[0]->str() == GLOBAL) {
      kind = ExternalKind::Global;
    } else {
      newStyle = false; // either (param..) or (result..)
    }
  }
  Index newStyleInner = 1;
  Name name;
  if (s.size() > 3 && s[3]->isStr()) {
    name = s[i++]->str();
  } else if (newStyle && newStyleInner < s[3]->size() && (*s[3])[newStyleInner]->dollared()) {
    name = (*s[3])[newStyleInner++]->str();
  }
  if (!name.is()) {
    if (kind == ExternalKind::Function) {
      name = Name("import$function$" + std::to_string(functionCounter++));
      functionNames.push_back(name);
    } else if (kind == ExternalKind::Global) {
      name = Name("import$global" + std::to_string(globalCounter++));
      globalNames.push_back(name);
    } else if (kind == ExternalKind::Memory) {
      name = Name("import$memory$" + std::to_string(0));
    } else if (kind == ExternalKind::Table) {
      name = Name("import$table$" + std::to_string(0));
    } else {
      throw ParseException("invalid import");
    }
  }
  if (!s[i]->quoted()) {
    if (s[i]->str() == MEMORY) {
      kind = ExternalKind::Memory;
    } else if (s[i]->str() == TABLE) {
      kind = ExternalKind::Table;
    } else if (s[i]->str() == GLOBAL) {
      kind = ExternalKind::Global;
    } else {
      throw ParseException("invalid ext import");
    }
    i++;
  } else if (!newStyle) {
    kind = ExternalKind::Function;
  }
  auto module = s[i++]->str();
  if (!s[i]->isStr()) throw ParseException("no name for import");
  auto base = s[i++]->str();
  // parse internals
  Element& inner = newStyle ? *s[3] : s;
  Index j = newStyle ? newStyleInner : i;
  if (kind == ExternalKind::Function) {
    std::unique_ptr<FunctionType> type = make_unique<FunctionType>();
    if (inner.size() > j) {
      Element& params = *inner[j];
      IString id = params[0]->str();
      if (id == PARAM) {
        for (size_t k = 1; k < params.size(); k++) {
          type->params.push_back(stringToType(params[k]->str()));
        }
      } else if (id == RESULT) {
        type->result = stringToType(params[1]->str());
      } else if (id == TYPE) {
        IString name = params[1]->str();
        if (!wasm.getFunctionTypeOrNull(name)) throw ParseException("bad function type for import");
        *type = *wasm.getFunctionType(name);
      } else {
        throw ParseException("bad import element");
      }
      if (inner.size() > j+1) {
        Element& result = *inner[j+1];
        if (result[0]->str() != RESULT) throw ParseException("expected result");
        type->result = stringToType(result[1]->str());
      }
    }
    auto func = make_unique<Function>();
    func->name = name;
    func->module = module;
    func->base = base;
    auto* functionType = ensureFunctionType(getSig(type.get()), &wasm);
    func->type = functionType->name;
    FunctionTypeUtils::fillFunction(func.get(), functionType);
    functionTypes[name] = func->result;
    wasm.addFunction(func.release());
  } else if (kind == ExternalKind::Global) {
    Type type;
    if (inner[j]->isStr()) {
      type = stringToType(inner[j]->str());
    } else {
      auto& inner2 = *inner[j];
      if (inner2[0]->str() != MUT) throw ParseException("expected mut");
      type = stringToType(inner2[1]->str());
      throw ParseException("cannot import a mutable global", s.line, s.col);
    }
    auto global = make_unique<Global>();
    global->name = name;
    global->module = module;
    global->base = base;
    global->type = type;
    wasm.addGlobal(global.release());
  } else if (kind == ExternalKind::Table) {
    wasm.table.module = module;
    wasm.table.base = base;
    if (j < inner.size() - 1) {
      wasm.table.initial = getCheckedAddress(inner[j++], "excessive table init size");
    }
    if (j < inner.size() - 1) {
      wasm.table.max = getCheckedAddress(inner[j++], "excessive table max size");
    } else {
      wasm.table.max = Table::kUnlimitedSize;
    }
    // ends with the table element type
  } else if (kind == ExternalKind::Memory) {
    wasm.memory.module = module;
    wasm.memory.base = base;
    if (inner[j]->isList()) {
      auto& limits = *inner[j];
      if (!(limits[0]->isStr() && limits[0]->str() == "shared")) throw ParseException("bad memory limit declaration");
      wasm.memory.shared = true;
      parseMemoryLimits(limits, 1);
    } else {
      parseMemoryLimits(inner, j);
    }
  }
}

void SExpressionWasmBuilder::parseGlobal(Element& s, bool preParseImport) {
  std::unique_ptr<Global> global = make_unique<Global>();
  size_t i = 1;
  if (s[i]->dollared() && !(s[i]->isStr() && isType(s[i]->str()))) {
    global->name = s[i++]->str();
  } else {
    global->name = Name::fromInt(globalCounter);
  }
  globalCounter++;
  globalNames.push_back(global->name);
  bool mutable_ = false;
  Type type = none;
  bool exported = false;
  Name importModule, importBase;
  while (i < s.size() && s[i]->isList()) {
    auto& inner = *s[i];
    if (inner[0]->str() == EXPORT) {
      auto ex = make_unique<Export>();
      ex->name = inner[1]->str();
      ex->value = global->name;
      ex->kind = ExternalKind::Global;
      if (wasm.getExportOrNull(ex->name)) throw ParseException("duplicate export", s.line, s.col);
      wasm.addExport(ex.release());
      exported = true;
      i++;
    } else if (inner[0]->str() == IMPORT) {
      importModule = inner[1]->str();
      importBase = inner[2]->str();
      i++;
    } else if (inner[0]->str() == MUT) {
      mutable_ = true;
      type = stringToType(inner[1]->str());
      i++;
    } else {
      break;
    }
  }
  if (exported && mutable_) throw ParseException("cannot export a mutable global", s.line, s.col);
  if (type == none) {
    type = stringToType(s[i++]->str());
  }
  if (importModule.is()) {
    // this is an import, actually
    if (!preParseImport) throw ParseException("!preParseImport in global");
    if (mutable_) throw ParseException("cannot import a mutable global", s.line, s.col);
    auto im = make_unique<Global>();
    im->name = global->name;
    im->module = importModule;
    im->base = importBase;
    im->type = type;
    if (wasm.getGlobalOrNull(im->name)) throw ParseException("duplicate import", s.line, s.col);
    wasm.addGlobal(im.release());
    return;
  }
  if (preParseImport) throw ParseException("preParseImport in global");
  global->type = type;
  if (i < s.size()) {
    global->init = parseExpression(s[i++]);
  } else {
    throw ParseException("global without init", s.line, s.col);
  }
  global->mutable_ = mutable_;
  if (i != s.size()) throw ParseException("extra import elements");
  if (wasm.getGlobalOrNull(global->name)) throw ParseException("duplicate import", s.line, s.col);
  wasm.addGlobal(global.release());
}


void SExpressionWasmBuilder::parseTable(Element& s, bool preParseImport) {
  if (wasm.table.exists) throw ParseException("more than one table");
  wasm.table.exists = true;
  Index i = 1;
  if (i == s.size()) return; // empty table in old notation
  if (s[i]->dollared()) {
    wasm.table.name = s[i++]->str();
  }
  if (i == s.size()) return;
  Name importModule, importBase;
  if (s[i]->isList()) {
    auto& inner = *s[i];
    if (inner[0]->str() == EXPORT) {
      auto ex = make_unique<Export>();
      ex->name = inner[1]->str();
      ex->value = wasm.table.name;
      ex->kind = ExternalKind::Table;
      if (wasm.getExportOrNull(ex->name)) throw ParseException("duplicate export", s.line, s.col);
      wasm.addExport(ex.release());
      i++;
    } else if (inner[0]->str() == IMPORT) {
      if (!preParseImport) throw ParseException("!preParseImport in table");
      wasm.table.module = inner[1]->str();
      wasm.table.base = inner[2]->str();
      i++;
    } else {
      throw ParseException("invalid table");
    }
  }
  if (i == s.size()) return;
  if (!s[i]->dollared()) {
    if (s[i]->str() == ANYFUNC) {
      // (table type (elem ..))
      parseInnerElem(*s[i + 1]);
      if (wasm.table.segments.size() > 0) {
        wasm.table.initial = wasm.table.max = wasm.table.segments[0].data.size();
      } else {
        wasm.table.initial = wasm.table.max = 0;
      }
      return;
    }
    // first element isn't dollared, and isn't anyfunc. this could be old syntax for (table 0 1) which means function 0 and 1, or it could be (table initial max? type), look for type
    if (s[s.size() - 1]->str() == ANYFUNC) {
      // (table initial max? type)
      if (i < s.size() - 1) {
        wasm.table.initial = atoi(s[i++]->c_str());
      }
      if (i < s.size() - 1) {
        wasm.table.max = atoi(s[i++]->c_str());
      }
      return;
    }
  }
  // old notation (table func1 func2 ..)
  parseInnerElem(s, i);
  if (wasm.table.segments.size() > 0) {
    wasm.table.initial = wasm.table.max = wasm.table.segments[0].data.size();
  } else {
    wasm.table.initial = wasm.table.max = 0;
  }
}

void SExpressionWasmBuilder::parseElem(Element& s) {
  Index i = 1;
  if (!s[i]->isList()) {
    // the table is named
    i++;
  }
  auto* offset = parseExpression(s[i++]);
  parseInnerElem(s, i, offset);
}

void SExpressionWasmBuilder::parseInnerElem(Element& s, Index i, Expression* offset) {
  if (!wasm.table.exists) throw ParseException("elem without table", s.line, s.col);
  if (!offset) {
    offset = allocator.alloc<Const>()->set(Literal(int32_t(0)));
  }
  Table::Segment segment(offset);
  for (; i < s.size(); i++) {
    segment.data.push_back(getFunctionName(*s[i]));
  }
  wasm.table.segments.push_back(segment);
}

void SExpressionWasmBuilder::parseType(Element& s) {
  std::unique_ptr<FunctionType> type = make_unique<FunctionType>();
  size_t i = 1;
  if (s[i]->isStr()) {
    type->name = s[i]->str();
    i++;
  }
  Element& func = *s[i];
  for (size_t k = 1; k < func.size(); k++) {
    Element& curr = *func[k];
    if (curr[0]->str() == PARAM) {
      for (size_t j = 1; j < curr.size(); j++) {
        type->params.push_back(stringToType(curr[j]->str()));
      }
    } else if (curr[0]->str() == RESULT) {
      if (curr.size() > 2) throw ParseException("invalid result arity", curr.line, curr.col);
      type->result = stringToType(curr[1]->str());
    }
  }
  if (!type->name.is()) {
    type->name = Name::fromInt(wasm.functionTypes.size());
  }
  functionTypeNames.push_back(type->name);
  if (wasm.getFunctionTypeOrNull(type->name)) throw ParseException("duplicate function type", s.line, s.col);
  wasm.addFunctionType(type.release());
}

} // namespace wasm
