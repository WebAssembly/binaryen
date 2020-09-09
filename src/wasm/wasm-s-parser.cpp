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

#include <cctype>
#include <cmath>
#include <limits>

#include "asm_v_wasm.h"
#include "asmjs/shared-constants.h"
#include "ir/branch-utils.h"
#include "shared-constants.h"
#include "wasm-binary.h"

#define abort_on(str)                                                          \
  { throw ParseException(std::string("abort_on ") + str); }
#define element_assert(condition)                                              \
  assert((condition) ? true : (std::cerr << "on: " << *this << '\n' && 0));

using cashew::IString;

namespace {
int unhex(char c) {
  if (c >= '0' && c <= '9') {
    return c - '0';
  }
  if (c >= 'a' && c <= 'f') {
    return c - 'a' + 10;
  }
  if (c >= 'A' && c <= 'F') {
    return c - 'A' + 10;
  }
  throw wasm::ParseException("invalid hexadecimal");
}
} // namespace

namespace wasm {

static Address getCheckedAddress(const Element* s, const char* errorText) {
  uint64_t num = atoll(s->c_str());
  if (num > std::numeric_limits<Address::address_t>::max()) {
    throw ParseException(errorText, s->line, s->col);
  }
  return num;
}

static bool elementStartsWith(Element& s, IString str) {
  return s.isList() && s.size() > 0 && s[0]->isStr() && s[0]->str() == str;
}

Element::List& Element::list() {
  if (!isList()) {
    throw ParseException("expected list", line, col);
  }
  return list_;
}

Element* Element::operator[](unsigned i) {
  if (!isList()) {
    throw ParseException("expected list", line, col);
  }
  if (i >= list().size()) {
    throw ParseException("expected more elements in list", line, col);
  }
  return list()[i];
}

IString Element::str() const {
  if (!isStr()) {
    throw ParseException("expected string", line, col);
  }
  return str_;
}

const char* Element::c_str() const {
  if (!isStr()) {
    throw ParseException("expected string", line, col);
  }
  return str_.str;
}

Element* Element::setString(IString str__, bool dollared__, bool quoted__) {
  isList_ = false;
  str_ = str__;
  dollared_ = dollared__;
  quoted_ = quoted__;
  return this;
}

Element*
Element::setMetadata(size_t line_, size_t col_, SourceLocation* startLoc_) {
  line = line_;
  col = col_;
  startLoc = startLoc_;
  return this;
}

std::ostream& operator<<(std::ostream& o, Element& e) {
  if (e.isList_) {
    o << '(';
    for (auto item : e.list_) {
      o << ' ' << *item;
    }
    o << " )";
  } else {
    o << e.str_.str;
  }
  return o;
}

void Element::dump() {
  std::cout << "dumping " << this << " : " << *this << ".\n";
}

SExpressionParser::SExpressionParser(char* input) : input(input) {
  root = nullptr;
  line = 1;
  lineStart = input;
  while (!root) { // keep parsing until we pass an initial comment
    root = parse();
  }
}

Element* SExpressionParser::parse() {
  std::vector<Element*> stack;
  std::vector<SourceLocation*> stackLocs;
  Element* curr = allocator.alloc<Element>();
  while (1) {
    skipWhitespace();
    if (input[0] == 0) {
      break;
    }
    if (input[0] == '(') {
      input++;
      stack.push_back(curr);
      curr = allocator.alloc<Element>()->setMetadata(
        line, input - lineStart - 1, loc);
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
  if (stack.size() != 0) {
    throw ParseException("stack is not empty", curr->line, curr->col);
  }
  return curr;
}

void SExpressionParser::parseDebugLocation() {
  // Extracting debug location (if valid)
  char* debugLoc = input + 3; // skipping ";;@"
  while (debugLoc[0] && debugLoc[0] == ' ') {
    debugLoc++;
  }
  char* debugLocEnd = debugLoc;
  while (debugLocEnd[0] && debugLocEnd[0] != '\n') {
    debugLocEnd++;
  }
  char* pos = debugLoc;
  while (pos < debugLocEnd && pos[0] != ':') {
    pos++;
  }
  if (pos >= debugLocEnd) {
    return; // no line number
  }
  std::string name(debugLoc, pos);
  char* lineStart = ++pos;
  while (pos < debugLocEnd && pos[0] != ':') {
    pos++;
  }
  std::string lineStr(lineStart, pos);
  if (pos >= debugLocEnd) {
    return; // no column number
  }
  std::string colStr(++pos, debugLocEnd);
  void* buf =
    allocator.allocSpace(sizeof(SourceLocation), alignof(SourceLocation));
  loc = new (buf) SourceLocation(
    IString(name.c_str(), false), atoi(lineStr.c_str()), atoi(colStr.c_str()));
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
      while (input[0] && input[0] != '\n') {
        input++;
      }
      line++;
      if (!input[0]) {
        return;
      }
      lineStart = ++input;
    } else if (input[0] == '(' && input[1] == ';') {
      // Skip nested block comments.
      input += 2;
      int depth = 1;
      while (1) {
        if (!input[0]) {
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
  char* start = input;
  if (input[0] == '"') {
    // parse escaping \", but leave code escaped - we'll handle escaping in
    // memory segments specifically
    input++;
    std::string str;
    while (1) {
      if (input[0] == 0) {
        throw ParseException("unterminated string", line, start - lineStart);
      }
      if (input[0] == '"') {
        break;
      }
      if (input[0] == '\\') {
        str += input[0];
        if (input[1] == 0) {
          throw ParseException(
            "unterminated string escape", line, start - lineStart);
        }
        str += input[1];
        input += 2;
        continue;
      }
      str += input[0];
      input++;
    }
    input++;
    return allocator.alloc<Element>()
      ->setString(IString(str.c_str(), false), dollared, true)
      ->setMetadata(line, start - lineStart, loc);
  }
  while (input[0] && !isspace(input[0]) && input[0] != ')' && input[0] != '(' &&
         input[0] != ';') {
    input++;
  }
  if (start == input) {
    throw ParseException("expected string", line, input - lineStart);
  }
  char temp = input[0];
  input[0] = 0;
  auto ret = allocator.alloc<Element>()
               ->setString(IString(start, false), dollared, false)
               ->setMetadata(line, start - lineStart, loc);
  input[0] = temp;
  return ret;
}

SExpressionWasmBuilder::SExpressionWasmBuilder(Module& wasm,
                                               Element& module,
                                               Name* moduleName)
  : wasm(wasm), allocator(wasm.allocator) {
  if (module.size() == 0) {
    throw ParseException("empty toplevel, expected module");
  }
  if (module[0]->str() != MODULE) {
    throw ParseException("toplevel does not start with module");
  }
  if (module.size() == 1) {
    return;
  }
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
    WasmBinaryBuilder binaryBuilder(wasm, data);
    binaryBuilder.read();
    return;
  }
  Index implementedFunctions = 0;
  functionCounter = 0;
  for (unsigned j = i; j < module.size(); j++) {
    auto& s = *module[j];
    preParseFunctionType(s);
    preParseImports(s);
    if (elementStartsWith(s, FUNC) && !isImport(s)) {
      implementedFunctions++;
    }
  }
  // we go through the functions again, now parsing them, and the counter begins
  // from where imports ended
  functionCounter -= implementedFunctions;
  for (unsigned j = i; j < module.size(); j++) {
    parseModuleElement(*module[j]);
  }
}

bool SExpressionWasmBuilder::isImport(Element& curr) {
  for (Index i = 0; i < curr.size(); i++) {
    auto& x = *curr[i];
    if (elementStartsWith(x, IMPORT)) {
      return true;
    }
  }
  return false;
}

void SExpressionWasmBuilder::preParseImports(Element& curr) {
  IString id = curr[0]->str();
  if (id == IMPORT) {
    parseImport(curr);
  }
  if (isImport(curr)) {
    if (id == FUNC) {
      parseFunction(curr, true /* preParseImport */);
    } else if (id == GLOBAL) {
      parseGlobal(curr, true /* preParseImport */);
    } else if (id == TABLE) {
      parseTable(curr, true /* preParseImport */);
    } else if (id == MEMORY) {
      parseMemory(curr, true /* preParseImport */);
    } else if (id == EVENT) {
      parseEvent(curr, true /* preParseImport */);
    } else {
      throw ParseException(
        "fancy import we don't support yet", curr.line, curr.col);
    }
  }
}

void SExpressionWasmBuilder::parseModuleElement(Element& curr) {
  if (isImport(curr)) {
    return; // already done
  }
  IString id = curr[0]->str();
  if (id == START) {
    return parseStart(curr);
  }
  if (id == FUNC) {
    return parseFunction(curr);
  }
  if (id == MEMORY) {
    return parseMemory(curr);
  }
  if (id == DATA) {
    return parseData(curr);
  }
  if (id == EXPORT) {
    return parseExport(curr);
  }
  if (id == IMPORT) {
    return; // already done
  }
  if (id == GLOBAL) {
    return parseGlobal(curr);
  }
  if (id == TABLE) {
    return parseTable(curr);
  }
  if (id == ELEM) {
    return parseElem(curr);
  }
  if (id == TYPE) {
    return; // already done
  }
  if (id == EVENT) {
    return parseEvent(curr);
  }
  std::cerr << "bad module element " << id.str << '\n';
  throw ParseException("unknown module element", curr.line, curr.col);
}

Name SExpressionWasmBuilder::getFunctionName(Element& s) {
  if (s.dollared()) {
    return s.str();
  } else {
    // index
    size_t offset = atoi(s.str().c_str());
    if (offset >= functionNames.size()) {
      throw ParseException(
        "unknown function in getFunctionName", s.line, s.col);
    }
    return functionNames[offset];
  }
}

Signature SExpressionWasmBuilder::getFunctionSignature(Element& s) {
  if (s.dollared()) {
    auto it = signatureIndices.find(s.str().str);
    if (it == signatureIndices.end()) {
      throw ParseException(
        "unknown function type in getFunctionSignature", s.line, s.col);
    }
    return signatures[it->second];
  } else {
    // index
    size_t offset = atoi(s.str().c_str());
    if (offset >= signatures.size()) {
      throw ParseException(
        "unknown function type in getFunctionSignature", s.line, s.col);
    }
    return signatures[offset];
  }
}

Name SExpressionWasmBuilder::getGlobalName(Element& s) {
  if (s.dollared()) {
    return s.str();
  } else {
    // index
    size_t offset = atoi(s.str().c_str());
    if (offset >= globalNames.size()) {
      throw ParseException("unknown global in getGlobalName", s.line, s.col);
    }
    return globalNames[offset];
  }
}

Name SExpressionWasmBuilder::getEventName(Element& s) {
  if (s.dollared()) {
    return s.str();
  } else {
    // index
    size_t offset = atoi(s.str().c_str());
    if (offset >= eventNames.size()) {
      throw ParseException("unknown event in getEventName", s.line, s.col);
    }
    return eventNames[offset];
  }
}

// Parse various forms of (param ...) or (local ...) element. This ignores all
// parameter or local names when specified.
std::vector<Type> SExpressionWasmBuilder::parseParamOrLocal(Element& s) {
  size_t fakeIndex = 0;
  std::vector<NameType> namedParams = parseParamOrLocal(s, fakeIndex);
  std::vector<Type> params;
  for (auto& p : namedParams) {
    params.push_back(p.type);
  }
  return params;
}

// Parses various forms of (param ...) or (local ...) element:
// (param $name type) (e.g. (param $a i32))
// (param type+)      (e.g. (param i32 f64))
// (local $name type) (e.g. (local $a i32))
// (local type+)      (e.g. (local i32 f64))
// If the name is unspecified, it will create one using localIndex.
std::vector<NameType>
SExpressionWasmBuilder::parseParamOrLocal(Element& s, size_t& localIndex) {
  assert(elementStartsWith(s, PARAM) || elementStartsWith(s, LOCAL));
  std::vector<NameType> namedParams;
  if (s.size() == 1) { // (param) or (local)
    return namedParams;
  }

  for (size_t i = 1; i < s.size(); i++) {
    IString name;
    if (s[i]->dollared()) {
      if (i != 1) {
        throw ParseException("invalid wasm type", s[i]->line, s[i]->col);
      }
      if (i + 1 >= s.size()) {
        throw ParseException("invalid param entry", s.line, s.col);
      }
      name = s[i]->str();
      i++;
    } else {
      name = Name::fromInt(localIndex);
    }
    localIndex++;
    Type type;
    if (s[i]->isStr()) {
      type = stringToType(s[i]->str());
    } else {
      if (elementStartsWith(s, PARAM)) {
        throw ParseException(
          "params may not have tuple types", s[i]->line, s[i]->col);
      }
      type = elementToType(*s[i]);
    }
    namedParams.emplace_back(name, type);
  }
  return namedParams;
}

// Parses (result type) element. (e.g. (result i32))
std::vector<Type> SExpressionWasmBuilder::parseResults(Element& s) {
  assert(elementStartsWith(s, RESULT));
  std::vector<Type> types;
  for (size_t i = 1; i < s.size(); i++) {
    types.push_back(stringToType(s[i]->str()));
  }
  return types;
}

// Parses an element that references an entry in the type section. The element
// should be in the form of (type name) or (type index).
// (e.g. (type $a), (type 0))
Signature SExpressionWasmBuilder::parseTypeRef(Element& s) {
  assert(elementStartsWith(s, TYPE));
  if (s.size() != 2) {
    throw ParseException("invalid type reference", s.line, s.col);
  }
  return getFunctionSignature(*s[1]);
}

// Prases typeuse, a reference to a type definition. It is in the form of either
// (type index) or (type name), possibly augmented by inlined (param) and
// (result) nodes. (type) node can be omitted as well. Outputs are returned by
// parameter references.
// typeuse ::= (type index|name)+ |
//             (type index|name)+ (param ..)* (result ..)* |
//             (param ..)* (result ..)*
size_t
SExpressionWasmBuilder::parseTypeUse(Element& s,
                                     size_t startPos,
                                     Signature& functionSignature,
                                     std::vector<NameType>& namedParams) {
  std::vector<Type> params, results;
  size_t i = startPos;

  bool typeExists = false, paramsOrResultsExist = false;
  if (i < s.size() && elementStartsWith(*s[i], TYPE)) {
    typeExists = true;
    functionSignature = parseTypeRef(*s[i++]);
  }

  size_t paramPos = i;
  size_t localIndex = 0;

  while (i < s.size() && elementStartsWith(*s[i], PARAM)) {
    paramsOrResultsExist = true;
    auto newParams = parseParamOrLocal(*s[i++], localIndex);
    namedParams.insert(namedParams.end(), newParams.begin(), newParams.end());
    for (auto p : newParams) {
      params.push_back(p.type);
    }
  }

  while (i < s.size() && elementStartsWith(*s[i], RESULT)) {
    paramsOrResultsExist = true;
    auto newResults = parseResults(*s[i++]);
    results.insert(results.end(), newResults.begin(), newResults.end());
  }

  auto inlineSig = Signature(Type(params), Type(results));

  // If none of type/param/result exists, this is equivalent to a type that does
  // not have parameters and returns nothing.
  if (!typeExists && !paramsOrResultsExist) {
    paramsOrResultsExist = true;
  }

  if (!typeExists) {
    functionSignature = inlineSig;
  } else if (paramsOrResultsExist) {
    // verify that (type) and (params)/(result) match
    if (inlineSig != functionSignature) {
      throw ParseException("type and param/result don't match",
                           s[paramPos]->line,
                           s[paramPos]->col);
    }
  }

  // Add implicitly defined type to global list so it has an index
  if (std::find(signatures.begin(), signatures.end(), functionSignature) ==
      signatures.end()) {
    signatures.push_back(functionSignature);
  }

  // If only (type) is specified, populate `namedParams`
  if (!paramsOrResultsExist) {
    size_t index = 0;
    for (const auto& param : functionSignature.params) {
      namedParams.emplace_back(Name::fromInt(index++), param);
    }
  }

  return i;
}

// Parses a typeuse. Use this when only FunctionType* is needed.
size_t SExpressionWasmBuilder::parseTypeUse(Element& s,
                                            size_t startPos,
                                            Signature& functionSignature) {
  std::vector<NameType> params;
  return parseTypeUse(s, startPos, functionSignature, params);
}

void SExpressionWasmBuilder::preParseFunctionType(Element& s) {
  IString id = s[0]->str();
  if (id == TYPE) {
    return parseType(s);
  }
  if (id != FUNC) {
    return;
  }
  size_t i = 1;
  Name name, exportName;
  i = parseFunctionNames(s, name, exportName);
  if (!name.is()) {
    // unnamed, use an index
    name = Name::fromInt(functionCounter);
  }
  functionNames.push_back(name);
  functionCounter++;
  Signature sig;
  parseTypeUse(s, i, sig);
  functionTypes[name] = sig.results;
}

size_t SExpressionWasmBuilder::parseFunctionNames(Element& s,
                                                  Name& name,
                                                  Name& exportName) {
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
    if (elementStartsWith(inner, EXPORT)) {
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
  brokeToAutoBlock = false;

  Name name, exportName;
  size_t i = parseFunctionNames(s, name, exportName);
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
    if (wasm.getExportOrNull(ex->name)) {
      throw ParseException("duplicate export", s.line, s.col);
    }
    wasm.addExport(ex.release());
  }

  // parse import
  Name importModule, importBase;
  if (i < s.size() && elementStartsWith(*s[i], IMPORT)) {
    Element& curr = *s[i];
    importModule = curr[1]->str();
    importBase = curr[2]->str();
    i++;
  }

  // parse typeuse: type/param/result
  Signature sig;
  std::vector<NameType> params;
  i = parseTypeUse(s, i, sig, params);

  // when (import) is inside a (func) element, this is not a function definition
  // but an import.
  if (importModule.is()) {
    if (!importBase.size()) {
      throw ParseException("module but no base for import", s.line, s.col);
    }
    if (!preParseImport) {
      throw ParseException("!preParseImport in func", s.line, s.col);
    }
    auto im = make_unique<Function>();
    im->name = name;
    im->module = importModule;
    im->base = importBase;
    im->sig = sig;
    functionTypes[name] = sig.results;
    if (wasm.getFunctionOrNull(im->name)) {
      throw ParseException("duplicate import", s.line, s.col);
    }
    wasm.addFunction(im.release());
    if (currFunction) {
      throw ParseException("import module inside function dec", s.line, s.col);
    }
    nameMapper.clear();
    return;
  }
  // at this point this not an import but a real function definition.
  if (preParseImport) {
    throw ParseException("preParseImport in func", s.line, s.col);
  }

  size_t localIndex = params.size(); // local index for params and locals

  // parse locals
  std::vector<NameType> vars;
  while (i < s.size() && elementStartsWith(*s[i], LOCAL)) {
    auto newVars = parseParamOrLocal(*s[i++], localIndex);
    vars.insert(vars.end(), newVars.begin(), newVars.end());
  }

  // make a new function
  currFunction = std::unique_ptr<Function>(Builder(wasm).makeFunction(
    name, std::move(params), sig.results, std::move(vars)));

  // parse body
  Block* autoBlock = nullptr; // may need to add a block for the very top level
  auto ensureAutoBlock = [&]() {
    if (!autoBlock) {
      autoBlock = allocator.alloc<Block>();
      autoBlock->list.push_back(currFunction->body);
      currFunction->body = autoBlock;
    }
  };
  while (i < s.size()) {
    Expression* ex = parseExpression(*s[i++]);
    if (!currFunction->body) {
      currFunction->body = ex;
    } else {
      ensureAutoBlock();
      autoBlock->list.push_back(ex);
    }
  }

  if (brokeToAutoBlock) {
    ensureAutoBlock();
    autoBlock->name = FAKE_RETURN;
  }
  if (autoBlock) {
    autoBlock->finalize(sig.results);
  }
  if (!currFunction->body) {
    currFunction->body = allocator.alloc<Nop>();
  }
  if (s.startLoc) {
    currFunction->prologLocation.insert(getDebugLocation(*s.startLoc));
  }
  if (s.endLoc) {
    currFunction->epilogLocation.insert(getDebugLocation(*s.endLoc));
  }
  if (wasm.getFunctionOrNull(currFunction->name)) {
    throw ParseException("duplicate function", s.line, s.col);
  }
  wasm.addFunction(currFunction.release());
  nameMapper.clear();
}

Type SExpressionWasmBuilder::stringToType(const char* str,
                                          bool allowError,
                                          bool prefix) {
  if (str[0] == 'i') {
    if (str[1] == '3' && str[2] == '2' && (prefix || str[3] == 0)) {
      return Type::i32;
    }
    if (str[1] == '6' && str[2] == '4' && (prefix || str[3] == 0)) {
      return Type::i64;
    }
  }
  if (str[0] == 'f') {
    if (str[1] == '3' && str[2] == '2' && (prefix || str[3] == 0)) {
      return Type::f32;
    }
    if (str[1] == '6' && str[2] == '4' && (prefix || str[3] == 0)) {
      return Type::f64;
    }
  }
  if (str[0] == 'v') {
    if (str[1] == '1' && str[2] == '2' && str[3] == '8' &&
        (prefix || str[4] == 0)) {
      return Type::v128;
    }
  }
  if (strncmp(str, "funcref", 7) == 0 && (prefix || str[7] == 0)) {
    return Type::funcref;
  }
  if (strncmp(str, "externref", 9) == 0 && (prefix || str[9] == 0)) {
    return Type::externref;
  }
  if (strncmp(str, "exnref", 6) == 0 && (prefix || str[6] == 0)) {
    return Type::exnref;
  }
  if (strncmp(str, "anyref", 6) == 0 && (prefix || str[6] == 0)) {
    return Type::anyref;
  }
  if (allowError) {
    return Type::none;
  }
  throw ParseException(std::string("invalid wasm type: ") + str);
}

HeapType SExpressionWasmBuilder::stringToHeapType(const char* str,
                                                  bool prefix) {
  if (str[0] == 'a') {
    if (str[1] == 'n' && str[2] == 'y' && (prefix || str[3] == 0)) {
      return HeapType::AnyKind;
    }
  }
  if (str[0] == 'e') {
    if (str[1] == 'q' && (prefix || str[2] == 0)) {
      return HeapType::EqKind;
    }
    if (str[1] == 'x') {
      if (str[2] == 'n' && (prefix || str[3] == 0)) {
        return HeapType::ExnKind;
      }
      if (str[2] == 't' && str[3] == 'e' && str[4] == 'r' && str[5] == 'n' &&
          (prefix || str[6] == 0)) {
        return HeapType::ExternKind;
      }
    }
  }
  if (str[0] == 'i') {
    if (str[1] == '3' && str[2] == '1' && (prefix || str[3] == 0)) {
      return HeapType::I31Kind;
    }
  }
  if (str[0] == 'f') {
    if (str[1] == 'u' && str[2] == 'n' && str[3] == 'c' &&
        (prefix || str[4] == 0)) {
      return HeapType::FuncKind;
    }
  }
  throw ParseException(std::string("invalid wasm heap type: ") + str);
}

Type SExpressionWasmBuilder::elementToType(Element& s) {
  if (s.isStr()) {
    return stringToType(s.str(), false, false);
  }
  auto& tuple = s.list();
  std::vector<Type> types;
  for (size_t i = 0; i < s.size(); ++i) {
    types.push_back(stringToType(tuple[i]->str()));
  }
  return Type(types);
}

Type SExpressionWasmBuilder::stringToLaneType(const char* str) {
  if (strcmp(str, "i8x16") == 0) {
    return Type::i32;
  }
  if (strcmp(str, "i16x8") == 0) {
    return Type::i32;
  }
  if (strcmp(str, "i32x4") == 0) {
    return Type::i32;
  }
  if (strcmp(str, "i64x2") == 0) {
    return Type::i64;
  }
  if (strcmp(str, "f32x4") == 0) {
    return Type::f32;
  }
  if (strcmp(str, "f64x2") == 0) {
    return Type::f64;
  }
  return Type::none;
}

Function::DebugLocation
SExpressionWasmBuilder::getDebugLocation(const SourceLocation& loc) {
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
  if (s.startLoc && currFunction) {
    currFunction->debugLocations[result] = getDebugLocation(*s.startLoc);
  }
  return result;
}

Expression* SExpressionWasmBuilder::makeExpression(Element& s){
#define INSTRUCTION_PARSER
#include "gen-s-parser.inc"
}

Expression* SExpressionWasmBuilder::makeUnreachable() {
  return allocator.alloc<Unreachable>();
}

Expression* SExpressionWasmBuilder::makeNop() { return allocator.alloc<Nop>(); }

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
  Index i = 1;
  Type type = parseOptionalResultType(s, i);
  ret->ifTrue = parseExpression(s[i++]);
  ret->ifFalse = parseExpression(s[i++]);
  ret->condition = parseExpression(s[i]);
  if (type.isConcrete()) {
    ret->finalize(type);
  } else {
    ret->finalize();
  }
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
  if (ret->op == HostOp::MemoryGrow) {
    if (ret->operands.size() != 1) {
      throw ParseException("memory.grow needs one operand", s.line, s.col);
    }
  } else {
    if (ret->operands.size() != 0) {
      throw ParseException("host needs zero operands", s.line, s.col);
    }
  }
  ret->finalize();
  return ret;
}

Index SExpressionWasmBuilder::getLocalIndex(Element& s) {
  if (!currFunction) {
    throw ParseException("local access in non-function scope", s.line, s.col);
  }
  if (s.dollared()) {
    auto ret = s.str();
    if (currFunction->localIndices.count(ret) == 0) {
      throw ParseException("bad local name", s.line, s.col);
    }
    return currFunction->getLocalIndex(ret);
  }
  // this is a numeric index
  Index ret = atoi(s.c_str());
  if (ret >= currFunction->getNumLocals()) {
    throw ParseException("bad local index", s.line, s.col);
  }
  return ret;
}

Expression* SExpressionWasmBuilder::makeLocalGet(Element& s) {
  auto ret = allocator.alloc<LocalGet>();
  ret->index = getLocalIndex(*s[1]);
  ret->type = currFunction->getLocalType(ret->index);
  return ret;
}

Expression* SExpressionWasmBuilder::makeLocalTee(Element& s) {
  auto ret = allocator.alloc<LocalSet>();
  ret->index = getLocalIndex(*s[1]);
  ret->value = parseExpression(s[2]);
  ret->makeTee(currFunction->getLocalType(ret->index));
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeLocalSet(Element& s) {
  auto ret = allocator.alloc<LocalSet>();
  ret->index = getLocalIndex(*s[1]);
  ret->value = parseExpression(s[2]);
  ret->makeSet();
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeGlobalGet(Element& s) {
  auto ret = allocator.alloc<GlobalGet>();
  ret->name = getGlobalName(*s[1]);
  auto* global = wasm.getGlobalOrNull(ret->name);
  if (!global) {
    throw ParseException("bad global.get name", s.line, s.col);
  }
  ret->type = global->type;
  return ret;
}

Expression* SExpressionWasmBuilder::makeGlobalSet(Element& s) {
  auto ret = allocator.alloc<GlobalSet>();
  ret->name = getGlobalName(*s[1]);
  if (wasm.getGlobalOrNull(ret->name) &&
      !wasm.getGlobalOrNull(ret->name)->mutable_) {
    throw ParseException("global.set of immutable", s.line, s.col);
  }
  ret->value = parseExpression(s[2]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeBlock(Element& s) {
  if (!currFunction) {
    throw ParseException(
      "block is unallowed outside of functions", s.line, s.col);
  }
  // special-case Block, because Block nesting (in their first element) can be
  // incredibly deep
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
      if (s[i]->dollared() ||
          stringToType(s[i]->str(), true /* allowError */) == Type::none) {
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
    if (i >= s.size()) {
      break; // empty block
    }
    auto& first = *s[i];
    if (elementStartsWith(first, BLOCK)) {
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
      if (i < s.size() && elementStartsWith(*s[i], RESULT)) {
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

// Similar to block, but the label is handled by the enclosing if (since there
// might not be a then or else, ick)
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

template<int Lanes>
static Literal makeLanes(Element& s, MixedArena& allocator, Type lane_t) {
  std::array<Literal, Lanes> lanes;
  for (size_t i = 0; i < Lanes; ++i) {
    Expression* lane = parseConst(s[i + 2]->str(), lane_t, allocator);
    if (lane) {
      lanes[i] = lane->cast<Const>()->value;
    } else {
      throw ParseException(
        "Could not parse v128 lane", s[i + 2]->line, s[i + 2]->col);
    }
  }
  return Literal(lanes);
}

Expression* SExpressionWasmBuilder::makeConst(Element& s, Type type) {
  if (type != Type::v128) {
    auto ret = parseConst(s[1]->str(), type, allocator);
    if (!ret) {
      throw ParseException("bad const", s[1]->line, s[1]->col);
    }
    return ret;
  }

  auto ret = allocator.alloc<Const>();
  Type lane_t = stringToLaneType(s[1]->str().str);
  size_t lanes = s.size() - 2;
  switch (lanes) {
    case 2: {
      if (lane_t != Type::i64 && lane_t != Type::f64) {
        throw ParseException(
          "Unexpected v128 literal lane type", s[1]->line, s[1]->col);
      }
      ret->value = makeLanes<2>(s, allocator, lane_t);
      break;
    }
    case 4: {
      if (lane_t != Type::i32 && lane_t != Type::f32) {
        throw ParseException(
          "Unexpected v128 literal lane type", s[1]->line, s[1]->col);
      }
      ret->value = makeLanes<4>(s, allocator, lane_t);
      break;
    }
    case 8: {
      if (lane_t != Type::i32) {
        throw ParseException(
          "Unexpected v128 literal lane type", s[1]->line, s[1]->col);
      }
      ret->value = makeLanes<8>(s, allocator, lane_t);
      break;
    }
    case 16: {
      if (lane_t != Type::i32) {
        throw ParseException(
          "Unexpected v128 literal lane type", s[1]->line, s[1]->col);
      }
      ret->value = makeLanes<16>(s, allocator, lane_t);
      break;
    }
    default:
      throw ParseException(
        "Unexpected number of lanes in v128 literal", s[1]->line, s[1]->col);
  }
  ret->finalize();
  return ret;
}

static uint8_t parseMemBytes(const char*& s, uint8_t fallback) {
  uint8_t ret;
  if (s[0] == '8') {
    ret = 1;
    s++;
  } else if (s[0] == '1') {
    if (s[1] != '6') {
      throw ParseException(std::string("expected 16 for memop size: ") + s);
    }
    ret = 2;
    s += 2;
  } else if (s[0] == '3') {
    if (s[1] != '2') {
      throw ParseException(std::string("expected 32 for memop size: ") + s);
    };
    ret = 4;
    s += 2;
  } else {
    ret = fallback;
  }
  return ret;
}

static size_t parseMemAttributes(Element& s,
                                 Address& offset,
                                 Address& align,
                                 Address fallbackAlign) {
  size_t i = 1;
  offset = 0;
  align = fallbackAlign;
  while (!s[i]->isList()) {
    const char* str = s[i]->c_str();
    const char* eq = strchr(str, '=');
    if (!eq) {
      throw ParseException(
        "missing = in memory attribute", s[i]->line, s[i]->col);
    }
    eq++;
    if (*eq == 0) {
      throw ParseException(
        "missing value in memory attribute", s[i]->line, s[i]->col);
    }
    char* endptr;
    uint64_t value = strtoll(eq, &endptr, 10);
    if (*endptr != 0) {
      throw ParseException(
        "bad memory attribute immediate", s[i]->line, s[i]->col);
    }
    if (str[0] == 'a') {
      if (value > std::numeric_limits<uint32_t>::max()) {
        throw ParseException("bad align", s[i]->line, s[i]->col);
      }
      align = value;
    } else if (str[0] == 'o') {
      if (value > std::numeric_limits<uint32_t>::max()) {
        throw ParseException("bad offset", s[i]->line, s[i]->col);
      }
      offset = value;
    } else {
      throw ParseException("bad memory attribute", s[i]->line, s[i]->col);
    }
    i++;
  }
  return i;
}

static const char* findMemExtra(const Element& s, size_t skip, bool isAtomic) {
  auto* str = s.c_str();
  auto size = strlen(str);
  auto* ret = strchr(str, '.');
  if (!ret) {
    throw ParseException("missing '.' in memory access", s.line, s.col);
  }
  ret += skip;
  if (isAtomic) {
    ret += 7; // after "type.atomic.load"
  }
  if (ret > str + size) {
    throw ParseException("memory access ends abruptly", s.line, s.col);
  }
  return ret;
}

Expression*
SExpressionWasmBuilder::makeLoad(Element& s, Type type, bool isAtomic) {
  const char* extra = findMemExtra(*s[0], 5 /* after "type.load" */, isAtomic);
  auto* ret = allocator.alloc<Load>();
  ret->isAtomic = isAtomic;
  ret->type = type;
  ret->bytes = parseMemBytes(extra, type.getByteSize());
  ret->signed_ = extra[0] && extra[1] == 's';
  size_t i = parseMemAttributes(s, ret->offset, ret->align, ret->bytes);
  ret->ptr = parseExpression(s[i]);
  ret->finalize();
  return ret;
}

Expression*
SExpressionWasmBuilder::makeStore(Element& s, Type type, bool isAtomic) {
  const char* extra = findMemExtra(*s[0], 6 /* after "type.store" */, isAtomic);
  auto ret = allocator.alloc<Store>();
  ret->isAtomic = isAtomic;
  ret->valueType = type;
  ret->bytes = parseMemBytes(extra, type.getByteSize());
  size_t i = parseMemAttributes(s, ret->offset, ret->align, ret->bytes);
  ret->ptr = parseExpression(s[i]);
  ret->value = parseExpression(s[i + 1]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeAtomicRMWOrCmpxchg(Element& s,
                                                           Type type) {
  const char* extra = findMemExtra(
    *s[0], 11 /* after "type.atomic.rmw" */, /* isAtomic = */ false);
  auto bytes = parseMemBytes(extra, type.getByteSize());
  extra = strchr(extra, '.'); // after the optional '_u' and before the opcode
  if (!extra) {
    throw ParseException("malformed atomic rmw instruction", s.line, s.col);
  }
  extra++; // after the '.'
  if (!strncmp(extra, "cmpxchg", 7)) {
    return makeAtomicCmpxchg(s, type, bytes, extra);
  }
  return makeAtomicRMW(s, type, bytes, extra);
}

Expression* SExpressionWasmBuilder::makeAtomicRMW(Element& s,
                                                  Type type,
                                                  uint8_t bytes,
                                                  const char* extra) {
  auto ret = allocator.alloc<AtomicRMW>();
  ret->type = type;
  ret->bytes = bytes;
  if (!strncmp(extra, "add", 3)) {
    ret->op = Add;
  } else if (!strncmp(extra, "and", 3)) {
    ret->op = And;
  } else if (!strncmp(extra, "or", 2)) {
    ret->op = Or;
  } else if (!strncmp(extra, "sub", 3)) {
    ret->op = Sub;
  } else if (!strncmp(extra, "xor", 3)) {
    ret->op = Xor;
  } else if (!strncmp(extra, "xchg", 4)) {
    ret->op = Xchg;
  } else {
    throw ParseException("bad atomic rmw operator", s.line, s.col);
  }
  Address align;
  size_t i = parseMemAttributes(s, ret->offset, align, ret->bytes);
  if (align != ret->bytes) {
    throw ParseException("Align of Atomic RMW must match size", s.line, s.col);
  }
  ret->ptr = parseExpression(s[i]);
  ret->value = parseExpression(s[i + 1]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeAtomicCmpxchg(Element& s,
                                                      Type type,
                                                      uint8_t bytes,
                                                      const char* extra) {
  auto ret = allocator.alloc<AtomicCmpxchg>();
  ret->type = type;
  ret->bytes = bytes;
  Address align;
  size_t i = parseMemAttributes(s, ret->offset, align, ret->bytes);
  if (align != ret->bytes) {
    throw ParseException(
      "Align of Atomic Cmpxchg must match size", s.line, s.col);
  }
  ret->ptr = parseExpression(s[i]);
  ret->expected = parseExpression(s[i + 1]);
  ret->replacement = parseExpression(s[i + 2]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeAtomicWait(Element& s, Type type) {
  auto ret = allocator.alloc<AtomicWait>();
  ret->type = Type::i32;
  ret->expectedType = type;
  Address align;
  Address expectedAlign;
  if (type == Type::i32) {
    expectedAlign = 4;
  } else if (type == Type::i64) {
    expectedAlign = 8;
  } else {
    WASM_UNREACHABLE("Invalid prefix for atomic.wait");
  }
  size_t i = parseMemAttributes(s, ret->offset, align, expectedAlign);
  if (align != expectedAlign) {
    throw ParseException("Align of atomic.wait must match size", s.line, s.col);
  }
  ret->ptr = parseExpression(s[i]);
  ret->expected = parseExpression(s[i + 1]);
  ret->timeout = parseExpression(s[i + 2]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeAtomicNotify(Element& s) {
  auto ret = allocator.alloc<AtomicNotify>();
  ret->type = Type::i32;
  Address align;
  size_t i = parseMemAttributes(s, ret->offset, align, 4);
  if (align != 4) {
    throw ParseException("Align of atomic.notify must be 4", s.line, s.col);
  }
  ret->ptr = parseExpression(s[i]);
  ret->notifyCount = parseExpression(s[i + 1]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeAtomicFence(Element& s) {
  return allocator.alloc<AtomicFence>();
}

static uint8_t parseLaneIndex(const Element* s, size_t lanes) {
  const char* str = s->c_str();
  char* end;
  auto n = static_cast<unsigned long long>(strtoll(str, &end, 10));
  if (end == str || *end != '\0') {
    throw ParseException("Expected lane index", s->line, s->col);
  }
  if (n > lanes) {
    throw ParseException(
      "lane index must be less than " + std::to_string(lanes), s->line, s->col);
  }
  return uint8_t(n);
}

Expression* SExpressionWasmBuilder::makeSIMDExtract(Element& s,
                                                    SIMDExtractOp op,
                                                    size_t lanes) {
  auto ret = allocator.alloc<SIMDExtract>();
  ret->op = op;
  ret->index = parseLaneIndex(s[1], lanes);
  ret->vec = parseExpression(s[2]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeSIMDReplace(Element& s,
                                                    SIMDReplaceOp op,
                                                    size_t lanes) {
  auto ret = allocator.alloc<SIMDReplace>();
  ret->op = op;
  ret->index = parseLaneIndex(s[1], lanes);
  ret->vec = parseExpression(s[2]);
  ret->value = parseExpression(s[3]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeSIMDShuffle(Element& s) {
  auto ret = allocator.alloc<SIMDShuffle>();
  for (size_t i = 0; i < 16; ++i) {
    ret->mask[i] = parseLaneIndex(s[i + 1], 32);
  }
  ret->left = parseExpression(s[17]);
  ret->right = parseExpression(s[18]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeSIMDTernary(Element& s,
                                                    SIMDTernaryOp op) {
  auto ret = allocator.alloc<SIMDTernary>();
  ret->op = op;
  ret->a = parseExpression(s[1]);
  ret->b = parseExpression(s[2]);
  ret->c = parseExpression(s[3]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeSIMDShift(Element& s, SIMDShiftOp op) {
  auto ret = allocator.alloc<SIMDShift>();
  ret->op = op;
  ret->vec = parseExpression(s[1]);
  ret->shift = parseExpression(s[2]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeSIMDLoad(Element& s, SIMDLoadOp op) {
  auto ret = allocator.alloc<SIMDLoad>();
  ret->op = op;
  Address defaultAlign;
  switch (op) {
    case LoadSplatVec8x16:
      defaultAlign = 1;
      break;
    case LoadSplatVec16x8:
      defaultAlign = 2;
      break;
    case LoadSplatVec32x4:
    case Load32Zero:
      defaultAlign = 4;
      break;
    case LoadSplatVec64x2:
    case LoadExtSVec8x8ToVecI16x8:
    case LoadExtUVec8x8ToVecI16x8:
    case LoadExtSVec16x4ToVecI32x4:
    case LoadExtUVec16x4ToVecI32x4:
    case LoadExtSVec32x2ToVecI64x2:
    case LoadExtUVec32x2ToVecI64x2:
    case Load64Zero:
      defaultAlign = 8;
      break;
  }
  size_t i = parseMemAttributes(s, ret->offset, ret->align, defaultAlign);
  ret->ptr = parseExpression(s[i]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeMemoryInit(Element& s) {
  auto ret = allocator.alloc<MemoryInit>();
  ret->segment = atoi(s[1]->str().c_str());
  ret->dest = parseExpression(s[2]);
  ret->offset = parseExpression(s[3]);
  ret->size = parseExpression(s[4]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeDataDrop(Element& s) {
  auto ret = allocator.alloc<DataDrop>();
  ret->segment = atoi(s[1]->str().c_str());
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeMemoryCopy(Element& s) {
  auto ret = allocator.alloc<MemoryCopy>();
  ret->dest = parseExpression(s[1]);
  ret->source = parseExpression(s[2]);
  ret->size = parseExpression(s[3]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeMemoryFill(Element& s) {
  auto ret = allocator.alloc<MemoryFill>();
  ret->dest = parseExpression(s[1]);
  ret->value = parseExpression(s[2]);
  ret->size = parseExpression(s[3]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makePop(Type type) {
  auto ret = allocator.alloc<Pop>();
  ret->type = type;
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
  if (BranchUtils::BranchSeeker::has(ret, label)) {
    auto* block = allocator.alloc<Block>();
    block->name = label;
    block->list.push_back(ret);
    block->finalize(type);
    return block;
  }
  return ret;
}

Expression*
SExpressionWasmBuilder::makeMaybeBlock(Element& s, size_t i, Type type) {
  Index stopAt = -1;
  if (s.size() == i) {
    return allocator.alloc<Nop>();
  }
  if (s.size() == i + 1) {
    return parseExpression(s[i]);
  }
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
  if (s.size() == i) {
    return Type::none;
  }

  // TODO(sbc): Remove support for old result syntax (bare streing) once the
  // spec tests are updated.
  if (s[i]->isStr()) {
    return stringToType(s[i++]->str());
  }

  Element& results = *s[i];
  IString id = results[0]->str();
  if (id == RESULT) {
    i++;
    return Type(parseResults(results));
  }
  return Type::none;
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

Expression* SExpressionWasmBuilder::makeCall(Element& s, bool isReturn) {
  auto target = getFunctionName(*s[1]);
  auto ret = allocator.alloc<Call>();
  ret->target = target;
  ret->type = functionTypes[ret->target];
  parseCallOperands(s, 2, s.size(), ret);
  ret->isReturn = isReturn;
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeCallIndirect(Element& s,
                                                     bool isReturn) {
  if (!wasm.table.exists) {
    throw ParseException("no table", s.line, s.col);
  }
  Index i = 1;
  auto ret = allocator.alloc<CallIndirect>();
  i = parseTypeUse(s, i, ret->sig);
  parseCallOperands(s, i, s.size() - 1, ret);
  ret->target = parseExpression(s[s.size() - 1]);
  ret->isReturn = isReturn;
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
      throw ParseException("invalid break offset", s.line, s.col);
    } catch (std::out_of_range&) {
      throw ParseException("out of range break offset", s.line, s.col);
    }
    if (offset > nameMapper.labelStack.size()) {
      throw ParseException("invalid label", s.line, s.col);
    }
    if (offset == nameMapper.labelStack.size()) {
      // a break to the function's scope. this means we need an automatic block,
      // with a name
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
  if (i == s.size()) {
    return ret;
  }
  if (elementStartsWith(s, BR_IF)) {
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
  if (ret->targets.size() == 0) {
    throw ParseException("switch with no targets", s.line, s.col);
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

Expression* SExpressionWasmBuilder::makeReturn(Element& s) {
  auto ret = allocator.alloc<Return>();
  if (s.size() >= 2) {
    ret->value = parseExpression(s[1]);
  }
  return ret;
}

Expression* SExpressionWasmBuilder::makeRefNull(Element& s) {
  if (s.size() != 2) {
    throw ParseException("invalid heap type reference", s.line, s.col);
  }
  auto heapType = stringToHeapType(s[1]->str());
  auto ret = allocator.alloc<RefNull>();
  ret->finalize(heapType);
  return ret;
}

Expression* SExpressionWasmBuilder::makeRefIsNull(Element& s) {
  auto ret = allocator.alloc<RefIsNull>();
  ret->value = parseExpression(s[1]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeRefFunc(Element& s) {
  auto func = getFunctionName(*s[1]);
  auto ret = allocator.alloc<RefFunc>();
  ret->func = func;
  ret->finalize();
  return ret;
}

// try-catch-end is written in the folded wast format as
// (try
//   ...
//  (catch
//    ...
//  )
// )
// The parenthesis wrapping 'catch' is just a syntax and does not affect nested
// depths of instructions within.
Expression* SExpressionWasmBuilder::makeTry(Element& s) {
  auto ret = allocator.alloc<Try>();
  Index i = 1;
  Name sName;
  if (s[i]->dollared()) {
    // the try is labeled
    sName = s[i++]->str();
  } else {
    sName = "try";
  }
  auto label = nameMapper.pushLabelName(sName);
  Type type = parseOptionalResultType(s, i); // signature
  if (!elementStartsWith(*s[i], "do")) {
    throw ParseException(
      "try body should start with 'do'", s[i]->line, s[i]->col);
  }
  ret->body = makeTryOrCatchBody(*s[i++], type, true);
  if (!elementStartsWith(*s[i], "catch")) {
    throw ParseException("catch clause does not exist", s[i]->line, s[i]->col);
  }
  ret->catchBody = makeTryOrCatchBody(*s[i++], type, false);
  ret->finalize(type);
  nameMapper.popLabelName(label);
  // create a break target if we must
  if (BranchUtils::BranchSeeker::has(ret, label)) {
    auto* block = allocator.alloc<Block>();
    block->name = label;
    block->list.push_back(ret);
    block->finalize(type);
    return block;
  }
  return ret;
}

Expression*
SExpressionWasmBuilder::makeTryOrCatchBody(Element& s, Type type, bool isTry) {
  if (isTry && !elementStartsWith(s, "do")) {
    throw ParseException("invalid try do clause", s.line, s.col);
  }
  if (!isTry && !elementStartsWith(s, "catch")) {
    throw ParseException("invalid catch clause", s.line, s.col);
  }
  if (s.size() == 1) { // (do) or (catch) without instructions
    return makeNop();
  }
  auto ret = allocator.alloc<Block>();
  for (size_t i = 1; i < s.size(); i++) {
    ret->list.push_back(parseExpression(s[i]));
  }
  if (ret->list.size() == 1) {
    return ret->list[0];
  }
  ret->finalize(type);
  return ret;
}

Expression* SExpressionWasmBuilder::makeThrow(Element& s) {
  auto ret = allocator.alloc<Throw>();
  Index i = 1;

  ret->event = getEventName(*s[i++]);
  if (!wasm.getEventOrNull(ret->event)) {
    throw ParseException("bad event name", s[1]->line, s[1]->col);
  }
  for (; i < s.size(); i++) {
    ret->operands.push_back(parseExpression(s[i]));
  }
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeRethrow(Element& s) {
  auto ret = allocator.alloc<Rethrow>();
  ret->exnref = parseExpression(*s[1]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeBrOnExn(Element& s) {
  auto ret = allocator.alloc<BrOnExn>();
  size_t i = 1;
  ret->name = getLabel(*s[i++]);
  ret->event = getEventName(*s[i++]);
  if (!wasm.getEventOrNull(ret->event)) {
    throw ParseException("bad event name", s[1]->line, s[1]->col);
  }
  ret->exnref = parseExpression(s[i]);

  Event* event = wasm.getEventOrNull(ret->event);
  assert(event && "br_on_exn's event must exist");
  // Copy params info into BrOnExn, because it is necessary when BrOnExn is
  // refinalized without the module.
  ret->sent = event->sig.params;
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeTupleMake(Element& s) {
  auto ret = allocator.alloc<TupleMake>();
  parseCallOperands(s, 1, s.size(), ret);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeTupleExtract(Element& s) {
  auto ret = allocator.alloc<TupleExtract>();
  ret->index = atoi(s[1]->str().c_str());
  ret->tuple = parseExpression(s[2]);
  ret->finalize();
  return ret;
}

// converts an s-expression string representing binary data into an output
// sequence of raw bytes this appends to data, which may already contain
// content.
void SExpressionWasmBuilder::stringToBinary(const char* input,
                                            size_t size,
                                            std::vector<char>& data) {
  auto originalSize = data.size();
  data.resize(originalSize + size);
  char* write = data.data() + originalSize;
  while (1) {
    if (input[0] == 0) {
      break;
    }
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
        *write++ = (char)(unhex(input[1]) * 16 + unhex(input[2]));
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
  uint64_t max = atoll(s[i]->c_str());
  if (max > Memory::kMaxSize) {
    throw ParseException("total memory must be <= 4GB", s[i]->line, s[i]->col);
  }
  wasm.memory.max = max;
  return ++i;
}

void SExpressionWasmBuilder::parseMemory(Element& s, bool preParseImport) {
  if (wasm.memory.exists) {
    throw ParseException("too many memories", s.line, s.col);
  }
  wasm.memory.exists = true;
  wasm.memory.shared = false;
  Index i = 1;
  if (s[i]->dollared()) {
    wasm.memory.name = s[i++]->str();
  }
  Name importModule, importBase;
  if (s[i]->isList()) {
    auto& inner = *s[i];
    if (elementStartsWith(inner, EXPORT)) {
      auto ex = make_unique<Export>();
      ex->name = inner[1]->str();
      ex->value = wasm.memory.name;
      ex->kind = ExternalKind::Memory;
      if (wasm.getExportOrNull(ex->name)) {
        throw ParseException("duplicate export", inner.line, inner.col);
      }
      wasm.addExport(ex.release());
      i++;
    } else if (elementStartsWith(inner, IMPORT)) {
      wasm.memory.module = inner[1]->str();
      wasm.memory.base = inner[2]->str();
      i++;
    } else if (elementStartsWith(inner, SHARED)) {
      wasm.memory.shared = true;
      parseMemoryLimits(inner, 1);
      i++;
    } else {
      if (!(inner.size() > 0 ? inner[0]->str() != IMPORT : true)) {
        throw ParseException("bad import ending", inner.line, inner.col);
      }
      // (memory (data ..)) format
      auto offset = allocator.alloc<Const>()->set(Literal(int32_t(0)));
      parseInnerData(*s[i], 1, offset, false);
      wasm.memory.initial = wasm.memory.segments[0].data.size();
      return;
    }
  }
  if (!wasm.memory.shared) {
    i = parseMemoryLimits(s, i);
  }

  // Parse memory initializers.
  while (i < s.size()) {
    Element& curr = *s[i];
    size_t j = 1;
    Address offsetValue;
    if (elementStartsWith(curr, DATA)) {
      offsetValue = 0;
    } else {
      offsetValue = getCheckedAddress(curr[j++], "excessive memory offset");
    }
    const char* input = curr[j]->c_str();
    auto* offset = allocator.alloc<Const>();
    offset->type = Type::i32;
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
  if (!wasm.memory.exists) {
    throw ParseException("data but no memory", s.line, s.col);
  }
  bool isPassive = false;
  Expression* offset = nullptr;
  Index i = 1;
  if (s[i]->isStr()) {
    // data is passive or named
    if (s[i]->str() == PASSIVE) {
      isPassive = true;
    }
    i++;
  }
  if (!isPassive) {
    offset = parseExpression(s[i]);
  }
  if (s.size() != 3 && s.size() != 4) {
    throw ParseException("Unexpected data items", s.line, s.col);
  }
  parseInnerData(s, s.size() - 1, offset, isPassive);
}

void SExpressionWasmBuilder::parseInnerData(Element& s,
                                            Index i,
                                            Expression* offset,
                                            bool isPassive) {
  std::vector<char> data;
  while (i < s.size()) {
    const char* input = s[i++]->c_str();
    if (auto size = strlen(input)) {
      stringToBinary(input, size, data);
    }
  }
  wasm.memory.segments.emplace_back(
    isPassive, offset, data.data(), data.size());
}

void SExpressionWasmBuilder::parseExport(Element& s) {
  std::unique_ptr<Export> ex = make_unique<Export>();
  ex->name = s[1]->str();
  if (s[2]->isList()) {
    auto& inner = *s[2];
    ex->value = inner[1]->str();
    if (elementStartsWith(inner, FUNC)) {
      ex->kind = ExternalKind::Function;
    } else if (elementStartsWith(inner, MEMORY)) {
      ex->kind = ExternalKind::Memory;
    } else if (elementStartsWith(inner, TABLE)) {
      ex->kind = ExternalKind::Table;
    } else if (elementStartsWith(inner, GLOBAL)) {
      ex->kind = ExternalKind::Global;
    } else if (inner[0]->str() == EVENT) {
      ex->kind = ExternalKind::Event;
    } else {
      throw ParseException("invalid export", inner.line, inner.col);
    }
  } else {
    // function
    ex->value = s[2]->str();
    ex->kind = ExternalKind::Function;
  }
  if (wasm.getExportOrNull(ex->name)) {
    throw ParseException("duplicate export", s.line, s.col);
  }
  wasm.addExport(ex.release());
}

void SExpressionWasmBuilder::parseImport(Element& s) {
  size_t i = 1;
  // (import "env" "STACKTOP" (global $stackTop i32))
  bool newStyle = s.size() == 4 && s[3]->isList();
  auto kind = ExternalKind::Invalid;
  if (newStyle) {
    if (elementStartsWith(*s[3], FUNC)) {
      kind = ExternalKind::Function;
    } else if (elementStartsWith(*s[3], MEMORY)) {
      kind = ExternalKind::Memory;
      if (wasm.memory.exists) {
        throw ParseException("more than one memory", s[3]->line, s[3]->col);
      }
      wasm.memory.exists = true;
    } else if (elementStartsWith(*s[3], TABLE)) {
      kind = ExternalKind::Table;
      if (wasm.table.exists) {
        throw ParseException("more than one table", s[3]->line, s[3]->col);
      }
      wasm.table.exists = true;
    } else if (elementStartsWith(*s[3], GLOBAL)) {
      kind = ExternalKind::Global;
    } else if ((*s[3])[0]->str() == EVENT) {
      kind = ExternalKind::Event;
    } else {
      newStyle = false; // either (param..) or (result..)
    }
  }
  Index newStyleInner = 1;
  Name name;
  if (s.size() > 3 && s[3]->isStr()) {
    name = s[i++]->str();
  } else if (newStyle && newStyleInner < s[3]->size() &&
             (*s[3])[newStyleInner]->dollared()) {
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
    } else if (kind == ExternalKind::Event) {
      name = Name("import$event" + std::to_string(eventCounter++));
      eventNames.push_back(name);
    } else {
      throw ParseException("invalid import", s[3]->line, s[3]->col);
    }
  }
  if (!newStyle) {
    kind = ExternalKind::Function;
  }
  auto module = s[i++]->str();
  if (!s[i]->isStr()) {
    throw ParseException("no name for import", s[i]->line, s[i]->col);
  }
  auto base = s[i]->str();
  if (!module.size() || !base.size()) {
    throw ParseException(
      "imports must have module and base", s[i]->line, s[i]->col);
  }
  i++;
  // parse internals
  Element& inner = newStyle ? *s[3] : s;
  Index j = newStyle ? newStyleInner : i;
  if (kind == ExternalKind::Function) {
    auto func = make_unique<Function>();

    j = parseTypeUse(inner, j, func->sig);
    func->name = name;
    func->module = module;
    func->base = base;
    functionTypes[name] = func->sig.results;
    wasm.addFunction(func.release());
  } else if (kind == ExternalKind::Global) {
    Type type;
    bool mutable_ = false;
    if (inner[j]->isStr()) {
      type = stringToType(inner[j++]->str());
    } else {
      auto& inner2 = *inner[j++];
      if (inner2[0]->str() != MUT) {
        throw ParseException("expected mut", inner2.line, inner2.col);
      }
      type = stringToType(inner2[1]->str());
      mutable_ = true;
    }
    auto global = make_unique<Global>();
    global->name = name;
    global->module = module;
    global->base = base;
    global->type = type;
    global->mutable_ = mutable_;
    wasm.addGlobal(global.release());
  } else if (kind == ExternalKind::Table) {
    wasm.table.module = module;
    wasm.table.base = base;
    if (j < inner.size() - 1) {
      wasm.table.initial =
        getCheckedAddress(inner[j++], "excessive table init size");
    }
    if (j < inner.size() - 1) {
      wasm.table.max =
        getCheckedAddress(inner[j++], "excessive table max size");
    } else {
      wasm.table.max = Table::kUnlimitedSize;
    }
    j++; // funcref
    // ends with the table element type
  } else if (kind == ExternalKind::Memory) {
    wasm.memory.module = module;
    wasm.memory.base = base;
    if (inner[j]->isList()) {
      auto& limits = *inner[j];
      if (!elementStartsWith(limits, SHARED)) {
        throw ParseException(
          "bad memory limit declaration", inner[j]->line, inner[j]->col);
      }
      wasm.memory.shared = true;
      j = parseMemoryLimits(limits, 1);
    } else {
      j = parseMemoryLimits(inner, j);
    }
  } else if (kind == ExternalKind::Event) {
    auto event = make_unique<Event>();
    if (j >= inner.size()) {
      throw ParseException("event does not have an attribute", s.line, s.col);
    }
    auto& attrElem = *inner[j++];
    if (!elementStartsWith(attrElem, ATTR) || attrElem.size() != 2) {
      throw ParseException("invalid attribute", attrElem.line, attrElem.col);
    }
    event->attribute = atoi(attrElem[1]->c_str());
    j = parseTypeUse(inner, j, event->sig);
    event->name = name;
    event->module = module;
    event->base = base;
    wasm.addEvent(event.release());
  }
  // If there are more elements, they are invalid
  if (j < inner.size()) {
    throw ParseException("invalid element", inner[j]->line, inner[j]->col);
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
  Type type = Type::none;
  bool exported = false;
  Name importModule, importBase;
  while (i < s.size() && s[i]->isList()) {
    auto& inner = *s[i++];
    if (elementStartsWith(inner, EXPORT)) {
      auto ex = make_unique<Export>();
      ex->name = inner[1]->str();
      ex->value = global->name;
      ex->kind = ExternalKind::Global;
      if (wasm.getExportOrNull(ex->name)) {
        throw ParseException("duplicate export", s.line, s.col);
      }
      wasm.addExport(ex.release());
      exported = true;
    } else if (elementStartsWith(inner, IMPORT)) {
      importModule = inner[1]->str();
      importBase = inner[2]->str();
    } else if (elementStartsWith(inner, MUT)) {
      mutable_ = true;
      type = elementToType(*inner[1]);
      break;
    } else {
      type = elementToType(inner);
      break;
    }
  }
  if (exported && mutable_) {
    throw ParseException("cannot export a mutable global", s.line, s.col);
  }
  if (type == Type::none) {
    type = stringToType(s[i++]->str());
  }
  if (importModule.is()) {
    // this is an import, actually
    if (!importBase.size()) {
      throw ParseException("module but no base for import", s.line, s.col);
    }
    if (!preParseImport) {
      throw ParseException("!preParseImport in global", s.line, s.col);
    }
    auto im = make_unique<Global>();
    im->name = global->name;
    im->module = importModule;
    im->base = importBase;
    im->type = type;
    im->mutable_ = mutable_;
    if (wasm.getGlobalOrNull(im->name)) {
      throw ParseException("duplicate import", s.line, s.col);
    }
    wasm.addGlobal(im.release());
    return;
  }
  if (preParseImport) {
    throw ParseException("preParseImport in global", s.line, s.col);
  }
  global->type = type;
  if (i < s.size()) {
    global->init = parseExpression(s[i++]);
  } else {
    throw ParseException("global without init", s.line, s.col);
  }
  global->mutable_ = mutable_;
  if (i != s.size()) {
    throw ParseException("extra import elements", s.line, s.col);
  }
  if (wasm.getGlobalOrNull(global->name)) {
    throw ParseException("duplicate import", s.line, s.col);
  }
  wasm.addGlobal(global.release());
}

void SExpressionWasmBuilder::parseTable(Element& s, bool preParseImport) {
  if (wasm.table.exists) {
    throw ParseException("more than one table", s.line, s.col);
  }
  wasm.table.exists = true;
  Index i = 1;
  if (i == s.size()) {
    return; // empty table in old notation
  }
  if (s[i]->dollared()) {
    wasm.table.name = s[i++]->str();
  }
  if (i == s.size()) {
    return;
  }
  Name importModule, importBase;
  if (s[i]->isList()) {
    auto& inner = *s[i];
    if (elementStartsWith(inner, EXPORT)) {
      auto ex = make_unique<Export>();
      ex->name = inner[1]->str();
      ex->value = wasm.table.name;
      ex->kind = ExternalKind::Table;
      if (wasm.getExportOrNull(ex->name)) {
        throw ParseException("duplicate export", inner.line, inner.col);
      }
      wasm.addExport(ex.release());
      i++;
    } else if (elementStartsWith(inner, IMPORT)) {
      if (!preParseImport) {
        throw ParseException("!preParseImport in table", inner.line, inner.col);
      }
      wasm.table.module = inner[1]->str();
      wasm.table.base = inner[2]->str();
      i++;
    } else {
      throw ParseException("invalid table", inner.line, inner.col);
    }
  }
  if (i == s.size()) {
    return;
  }
  if (!s[i]->dollared()) {
    if (s[i]->str() == FUNCREF) {
      // (table type (elem ..))
      parseInnerElem(*s[i + 1]);
      if (wasm.table.segments.size() > 0) {
        wasm.table.initial = wasm.table.max =
          wasm.table.segments[0].data.size();
      } else {
        wasm.table.initial = wasm.table.max = 0;
      }
      return;
    }
    // first element isn't dollared, and isn't funcref. this could be old syntax
    // for (table 0 1) which means function 0 and 1, or it could be (table
    // initial max? type), look for type
    if (s[s.size() - 1]->str() == FUNCREF) {
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

void SExpressionWasmBuilder::parseInnerElem(Element& s,
                                            Index i,
                                            Expression* offset) {
  if (!wasm.table.exists) {
    throw ParseException("elem without table", s.line, s.col);
  }
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
  std::vector<Type> params;
  std::vector<Type> results;
  size_t i = 1;
  if (s[i]->isStr()) {
    std::string name = s[i]->str().str;
    if (signatureIndices.find(name) != signatureIndices.end()) {
      throw ParseException("duplicate function type", s.line, s.col);
    }
    signatureIndices[name] = signatures.size();
    i++;
  }
  Element& func = *s[i];
  for (size_t k = 1; k < func.size(); k++) {
    Element& curr = *func[k];
    if (elementStartsWith(curr, PARAM)) {
      auto newParams = parseParamOrLocal(curr);
      params.insert(params.end(), newParams.begin(), newParams.end());
    } else if (elementStartsWith(curr, RESULT)) {
      auto newResults = parseResults(curr);
      results.insert(results.end(), newResults.begin(), newResults.end());
    }
  }
  signatures.emplace_back(Type(params), Type(results));
}

void SExpressionWasmBuilder::parseEvent(Element& s, bool preParseImport) {
  auto event = make_unique<Event>();
  size_t i = 1;

  // Parse name
  if (s[i]->isStr() && s[i]->dollared()) {
    auto& inner = *s[i++];
    event->name = inner.str();
    if (wasm.getEventOrNull(event->name)) {
      throw ParseException("duplicate event", inner.line, inner.col);
    }
  } else {
    event->name = Name::fromInt(eventCounter);
    assert(!wasm.getEventOrNull(event->name));
  }
  eventCounter++;
  eventNames.push_back(event->name);

  // Parse import, if any
  if (i < s.size() && elementStartsWith(*s[i], IMPORT)) {
    assert(preParseImport && "import element in non-preParseImport mode");
    auto& importElem = *s[i++];
    if (importElem.size() != 3) {
      throw ParseException("invalid import", importElem.line, importElem.col);
    }
    if (!importElem[1]->isStr() || importElem[1]->dollared()) {
      throw ParseException(
        "invalid import module name", importElem[1]->line, importElem[1]->col);
    }
    if (!importElem[2]->isStr() || importElem[2]->dollared()) {
      throw ParseException(
        "invalid import base name", importElem[2]->line, importElem[2]->col);
    }
    event->module = importElem[1]->str();
    event->base = importElem[2]->str();
  }

  // Parse export, if any
  if (i < s.size() && elementStartsWith(*s[i], EXPORT)) {
    auto& exportElem = *s[i++];
    if (event->module.is()) {
      throw ParseException("import and export cannot be specified together",
                           exportElem.line,
                           exportElem.col);
    }
    if (exportElem.size() != 2) {
      throw ParseException("invalid export", exportElem.line, exportElem.col);
    }
    if (!exportElem[1]->isStr() || exportElem[1]->dollared()) {
      throw ParseException(
        "invalid export name", exportElem[1]->line, exportElem[1]->col);
    }
    auto ex = make_unique<Export>();
    ex->name = exportElem[1]->str();
    if (wasm.getExportOrNull(ex->name)) {
      throw ParseException(
        "duplicate export", exportElem[1]->line, exportElem[1]->col);
    }
    ex->value = event->name;
    ex->kind = ExternalKind::Event;
  }

  // Parse attribute
  if (i >= s.size()) {
    throw ParseException("event does not have an attribute", s.line, s.col);
  }
  auto& attrElem = *s[i++];
  if (!elementStartsWith(attrElem, ATTR) || attrElem.size() != 2) {
    throw ParseException("invalid attribute", attrElem.line, attrElem.col);
  }
  if (!attrElem[1]->isStr()) {
    throw ParseException(
      "invalid attribute", attrElem[1]->line, attrElem[1]->col);
  }
  event->attribute = atoi(attrElem[1]->c_str());

  // Parse typeuse
  i = parseTypeUse(s, i, event->sig);

  // If there are more elements, they are invalid
  if (i < s.size()) {
    throw ParseException("invalid element", s[i]->line, s[i]->col);
  }

  wasm.addEvent(event.release());
}

} // namespace wasm
