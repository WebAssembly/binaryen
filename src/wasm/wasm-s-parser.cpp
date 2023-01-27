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

#include "ir/branch-utils.h"
#include "ir/table-utils.h"
#include "shared-constants.h"
#include "support/string.h"
#include "wasm-binary.h"
#include "wasm-builder.h"

#define abort_on(str)                                                          \
  { throw ParseException(std::string("abort_on ") + str); }
#define element_assert(condition)                                              \
  assert((condition) ? true : (std::cerr << "on: " << *this << '\n' && 0));

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

static Name STRUCT("struct"), FIELD("field"), ARRAY("array"),
  FUNC_SUBTYPE("func_subtype"), STRUCT_SUBTYPE("struct_subtype"),
  ARRAY_SUBTYPE("array_subtype"), EXTENDS("extends"), REC("rec"), I8("i8"),
  I16("i16"), DECLARE("declare"), ITEM("item"), OFFSET("offset");

static Address getAddress(const Element* s) {
  return std::stoll(s->toString());
}

static void
checkAddress(Address a, const char* errorText, const Element* errorElem) {
  if (a > std::numeric_limits<Address::address32_t>::max()) {
    throw ParseException(errorText, errorElem->line, errorElem->col);
  }
}

static bool elementStartsWith(Element& s, IString str) {
  return s.isList() && s.size() > 0 && s[0]->isStr() && s[0]->str() == str;
}

static bool elementStartsWith(Element* s, IString str) {
  return elementStartsWith(*s, str);
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

std::string Element::toString() const {
  if (!isStr()) {
    throw ParseException("expected string", line, col);
  }
  return str_.toString();
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
    if (e.dollared()) {
      o << '$';
    }
    o << e.str_.str;
  }
  return o;
}

void Element::dump() {
  std::cout << "dumping " << this << " : " << *this << ".\n";
}

SExpressionParser::SExpressionParser(char const* input) : input(input) {
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
  char const* debugLoc = input + 3; // skipping ";;@"
  while (debugLoc[0] && debugLoc[0] == ' ') {
    debugLoc++;
  }
  char const* debugLocEnd = debugLoc;
  while (debugLocEnd[0] && debugLocEnd[0] != '\n') {
    debugLocEnd++;
  }
  char const* pos = debugLoc;
  while (pos < debugLocEnd && pos[0] != ':') {
    pos++;
  }
  if (pos >= debugLocEnd) {
    return; // no line number
  }
  std::string name(debugLoc, pos);
  char const* lineStart = ++pos;
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
  char const* start = input;
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

  std::string temp;
  temp.assign(start, input - start);

  auto ret = allocator.alloc<Element>()
               ->setString(IString(temp.c_str(), false), dollared, false)
               ->setMetadata(line, start - lineStart, loc);

  return ret;
}

SExpressionWasmBuilder::SExpressionWasmBuilder(Module& wasm,
                                               Element& module,
                                               IRProfile profile)
  : wasm(wasm), allocator(wasm.allocator), profile(profile) {
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
    wasm.name = module[i]->str();
    if (module.size() == 2) {
      return;
    }
    i++;
  }

  // spec tests have a `binary` keyword after the optional module name. Skip it
  Name BINARY("binary");
  if (module[i]->isStr() && module[i]->str() == BINARY &&
      !module[i]->quoted()) {
    i++;
  }

  if (i < module.size() && module[i]->isStr()) {
    // these s-expressions contain a binary module, actually
    std::vector<char> data;
    for (; i < module.size(); ++i) {
      stringToBinary(*module[i], module[i]->str().str, data);
    }
    // TODO: support applying features here
    WasmBinaryBuilder binaryBuilder(wasm, FeatureSet::MVP, data);
    binaryBuilder.read();
    return;
  }

  preParseHeapTypes(module);

  Index implementedFunctions = 0;
  functionCounter = 0;
  for (unsigned j = i; j < module.size(); j++) {
    auto& s = *module[j];
    preParseFunctionType(s);
    preParseImports(s);
    preParseMemory(s);
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
    } else if (id == TAG) {
      parseTag(curr, true /* preParseImport */);
    } else {
      throw ParseException(
        "fancy import we don't support yet", curr.line, curr.col);
    }
  }
}

void SExpressionWasmBuilder::preParseMemory(Element& curr) {
  IString id = curr[0]->str();
  if (id == MEMORY && !isImport(curr)) {
    parseMemory(curr);
  }
}

void SExpressionWasmBuilder::parseModuleElement(Element& curr) {
  if (isImport(curr)) {
    return; // already done
  }
  IString id = curr[0]->str();
  if (id == MEMORY) {
    return; // already done
  }
  if (id == START) {
    return parseStart(curr);
  }
  if (id == FUNC) {
    return parseFunction(curr);
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
  if (id == REC) {
    return; // already done
  }
  if (id == TAG) {
    return parseTag(curr);
  }
  std::cerr << "bad module element " << id.str << '\n';
  throw ParseException("unknown module element", curr.line, curr.col);
}

int SExpressionWasmBuilder::parseIndex(Element& s) {
  try {
    return std::stoi(s.toString());
  } catch (...) {
    throw ParseException("expected integer", s.line, s.col);
  }
}

Name SExpressionWasmBuilder::getFunctionName(Element& s) {
  if (s.dollared()) {
    return s.str();
  } else {
    // index
    size_t offset = parseIndex(s);
    if (offset >= functionNames.size()) {
      throw ParseException(
        "unknown function in getFunctionName", s.line, s.col);
    }
    return functionNames[offset];
  }
}

Name SExpressionWasmBuilder::getTableName(Element& s) {
  if (s.dollared()) {
    return s.str();
  } else {
    // index
    size_t offset = parseIndex(s);
    if (offset >= tableNames.size()) {
      throw ParseException("unknown table in getTableName", s.line, s.col);
    }
    return tableNames[offset];
  }
}

bool SExpressionWasmBuilder::isMemory64(Name memoryName) {
  auto* memory = wasm.getMemoryOrNull(memoryName);
  if (!memory) {
    throw ParseException("invalid memory name in isMemory64");
  }
  return memory->is64();
}

Name SExpressionWasmBuilder::getMemoryNameAtIdx(Index i) {
  if (i >= memoryNames.size()) {
    throw ParseException("unknown memory in getMemoryName");
  }
  return memoryNames[i];
}

Name SExpressionWasmBuilder::getMemoryName(Element& s) {
  if (s.dollared()) {
    return s.str();
  } else {
    // index
    size_t offset = parseIndex(s);
    return getMemoryNameAtIdx(offset);
  }
}

Name SExpressionWasmBuilder::getGlobalName(Element& s) {
  if (s.dollared()) {
    return s.str();
  } else {
    // index
    size_t offset = parseIndex(s);
    if (offset >= globalNames.size()) {
      throw ParseException("unknown global in getGlobalName", s.line, s.col);
    }
    return globalNames[offset];
  }
}

Name SExpressionWasmBuilder::getTagName(Element& s) {
  if (s.dollared()) {
    return s.str();
  } else {
    // index
    size_t offset = parseIndex(s);
    if (offset >= tagNames.size()) {
      throw ParseException("unknown tag in getTagName", s.line, s.col);
    }
    return tagNames[offset];
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
    type = elementToType(*s[i]);
    if (elementStartsWith(s, PARAM) && type.isTuple()) {
      throw ParseException(
        "params may not have tuple types", s[i]->line, s[i]->col);
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
    types.push_back(elementToType(*s[i]));
  }
  return types;
}

// Parses an element that references an entry in the type section. The element
// should be in the form of (type name) or (type index).
// (e.g. (type $a), (type 0))
HeapType SExpressionWasmBuilder::parseTypeRef(Element& s) {
  assert(elementStartsWith(s, TYPE));
  if (s.size() != 2) {
    throw ParseException("invalid type reference", s.line, s.col);
  }
  auto heapType = parseHeapType(*s[1]);
  if (!heapType.isSignature()) {
    throw ParseException("expected signature type", s.line, s.col);
  }
  return heapType;
}

// Parses typeuse, a reference to a type definition. It is in the form of either
// (type index) or (type name), possibly augmented by inlined (param) and
// (result) nodes. (type) node can be omitted as well. Outputs are returned by
// parameter references.
// typeuse ::= (type index|name)+ |
//             (type index|name)+ (param ..)* (result ..)* |
//             (param ..)* (result ..)*
size_t
SExpressionWasmBuilder::parseTypeUse(Element& s,
                                     size_t startPos,
                                     HeapType& functionType,
                                     std::vector<NameType>& namedParams) {
  std::vector<Type> params, results;
  size_t i = startPos;

  bool typeExists = false, paramsOrResultsExist = false;
  if (i < s.size() && elementStartsWith(*s[i], TYPE)) {
    typeExists = true;
    functionType = parseTypeRef(*s[i++]);
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
    functionType = inlineSig;
  } else if (paramsOrResultsExist) {
    // verify that (type) and (params)/(result) match
    if (inlineSig != functionType.getSignature()) {
      throw ParseException("type and param/result don't match",
                           s[paramPos]->line,
                           s[paramPos]->col);
    }
  }

  // Add implicitly defined type to global list so it has an index
  if (std::find(types.begin(), types.end(), functionType) == types.end()) {
    types.push_back(functionType);
  }

  // If only (type) is specified, populate `namedParams`
  if (!paramsOrResultsExist) {
    size_t index = 0;
    assert(functionType.isSignature());
    Signature sig = functionType.getSignature();
    for (const auto& param : sig.params) {
      namedParams.emplace_back(Name::fromInt(index++), param);
    }
  }

  return i;
}

// Parses a typeuse. Use this when only FunctionType* is needed.
size_t SExpressionWasmBuilder::parseTypeUse(Element& s,
                                            size_t startPos,
                                            HeapType& functionType) {
  std::vector<NameType> params;
  return parseTypeUse(s, startPos, functionType, params);
}

void SExpressionWasmBuilder::preParseHeapTypes(Element& module) {
  // Iterate through each individual type definition, calling `f` with the
  // definition and its recursion group number.
  auto forEachType = [&](auto f) {
    size_t groupNumber = 0;
    for (auto* elemPtr : module) {
      auto& elem = *elemPtr;
      if (elementStartsWith(elem, TYPE)) {
        f(elem, groupNumber++);
      } else if (elementStartsWith(elem, REC)) {
        for (auto* innerPtr : elem) {
          auto& inner = *innerPtr;
          if (elementStartsWith(inner, TYPE)) {
            f(inner, groupNumber);
          }
        }
        ++groupNumber;
      }
    }
  };

  // Map type names to indices
  size_t numTypes = 0;
  forEachType([&](Element& elem, size_t) {
    if (elem[1]->dollared()) {
      std::string name = elem[1]->toString();
      if (!typeIndices.insert({name, numTypes}).second) {
        throw ParseException("duplicate function type", elem.line, elem.col);
      }
    }
    ++numTypes;
  });

  TypeBuilder builder(numTypes);

  // Create recursion groups
  size_t currGroup = 0, groupStart = 0, groupLength = 0;
  auto finishGroup = [&]() {
    builder.createRecGroup(groupStart, groupLength);
    groupStart = groupStart + groupLength;
    groupLength = 0;
  };
  forEachType([&](Element&, size_t group) {
    if (group != currGroup) {
      finishGroup();
      currGroup = group;
    }
    ++groupLength;
  });
  finishGroup();

  auto parseRefType = [&](Element& elem) -> Type {
    // '(' 'ref' 'null'? ht ')'
    auto nullable =
      elem[1]->isStr() && *elem[1] == NULL_ ? Nullable : NonNullable;
    auto& referent = nullable ? *elem[2] : *elem[1];
    auto name = referent.toString();
    if (referent.dollared()) {
      return builder.getTempRefType(builder[typeIndices[name]], nullable);
    } else if (String::isNumber(name)) {
      size_t index = parseIndex(referent);
      if (index >= numTypes) {
        throw ParseException("invalid type index", elem.line, elem.col);
      }
      return builder.getTempRefType(builder[index], nullable);
    } else {
      return Type(stringToHeapType(referent.str()), nullable);
    }
  };

  auto parseValType = [&](Element& elem) {
    if (elem.isStr()) {
      return stringToType(elem.str());
    } else if (*elem[0] == REF) {
      return parseRefType(elem);
    } else {
      throw ParseException("unknown valtype kind", elem[0]->line, elem[0]->col);
    }
  };

  auto parseParams = [&](Element& elem) {
    auto it = ++elem.begin();
    if (it != elem.end() && (*it)->dollared()) {
      ++it;
    }
    std::vector<Type> params;
    for (auto end = elem.end(); it != end; ++it) {
      params.push_back(parseValType(**it));
    }
    return params;
  };

  auto parseResults = [&](Element& elem) {
    std::vector<Type> results;
    for (auto it = ++elem.begin(); it != elem.end(); ++it) {
      results.push_back(parseValType(**it));
    }
    return results;
  };

  auto parseSignatureDef = [&](Element& elem, bool nominal) {
    // '(' 'func' vec(param) vec(result) ')'
    // param ::= '(' 'param' id? valtype ')'
    // result ::= '(' 'result' valtype ')'
    std::vector<Type> params, results;
    auto end = elem.end() - (nominal ? 1 : 0);
    for (auto it = ++elem.begin(); it != end; ++it) {
      Element& curr = **it;
      if (elementStartsWith(curr, PARAM)) {
        auto newParams = parseParams(curr);
        params.insert(params.end(), newParams.begin(), newParams.end());
      } else if (elementStartsWith(curr, RESULT)) {
        auto newResults = parseResults(curr);
        results.insert(results.end(), newResults.begin(), newResults.end());
      }
    }
    return Signature(builder.getTempTupleType(params),
                     builder.getTempTupleType(results));
  };

  // Parses a field, and notes the name if one is found.
  auto parseField = [&](Element* elem, Name& name) {
    Mutability mutable_ = Immutable;
    // elem is a list, containing either
    //   TYPE
    // or
    //   (field TYPE)
    // or
    //   (field $name TYPE)
    if (elementStartsWith(elem, FIELD)) {
      if (elem->size() == 3) {
        name = (*elem)[1]->str();
      }
      elem = (*elem)[elem->size() - 1];
    }
    // The element may also be (mut (..)).
    if (elementStartsWith(elem, MUT)) {
      mutable_ = Mutable;
      elem = (*elem)[1];
    }
    if (elem->isStr()) {
      // elem is a simple string name like "i32". It can be a normal wasm
      // type, or one of the special types only available in fields.
      if (*elem == I8) {
        return Field(Field::i8, mutable_);
      } else if (*elem == I16) {
        return Field(Field::i16, mutable_);
      }
    }
    // Otherwise it's an arbitrary type.
    return Field(parseValType(*elem), mutable_);
  };

  auto parseStructDef = [&](Element& elem, size_t typeIndex, bool nominal) {
    FieldList fields;
    Index end = elem.size() - (nominal ? 1 : 0);
    for (Index i = 1; i < end; i++) {
      Name name;
      fields.emplace_back(parseField(elem[i], name));
      if (name.is()) {
        // Only add the name to the map if it exists.
        fieldNames[typeIndex][i - 1] = name;
      }
    }
    return Struct(fields);
  };

  auto parseArrayDef = [&](Element& elem) {
    Name unused;
    return Array(parseField(elem[1], unused));
  };

  size_t index = 0;
  forEachType([&](Element& elem, size_t) {
    Element& def = elem[1]->dollared() ? *elem[2] : *elem[1];
    Element& kind = *def[0];
    bool hasSupertype =
      kind == FUNC_SUBTYPE || kind == STRUCT_SUBTYPE || kind == ARRAY_SUBTYPE;
    if (kind == FUNC || kind == FUNC_SUBTYPE) {
      builder[index] = parseSignatureDef(def, hasSupertype);
    } else if (kind == STRUCT || kind == STRUCT_SUBTYPE) {
      builder[index] = parseStructDef(def, index, hasSupertype);
    } else if (kind == ARRAY || kind == ARRAY_SUBTYPE) {
      builder[index] = parseArrayDef(def);
    } else {
      throw ParseException("unknown heaptype kind", kind.line, kind.col);
    }
    Element* super = nullptr;
    if (hasSupertype) {
      super = def[def.size() - 1];
      if (super->dollared()) {
        // OK
      } else if (kind == FUNC_SUBTYPE && super->str() == FUNC) {
        // OK; no supertype
        super = nullptr;
      } else if ((kind == STRUCT_SUBTYPE || kind == ARRAY_SUBTYPE) &&
                 super->str() == DATA) {
        // OK; no supertype
        super = nullptr;
      } else {
        throw ParseException("unknown supertype", super->line, super->col);
      }
    } else if (elementStartsWith(elem[elem.size() - 1], EXTENDS)) {
      // '(' 'extends' $supertype ')'
      Element& extends = *elem[elem.size() - 1];
      super = extends[1];
    }
    if (super) {
      auto it = typeIndices.find(super->toString());
      if (it == typeIndices.end()) {
        throw ParseException("unknown supertype", super->line, super->col);
      }
      builder[index].subTypeOf(builder[it->second]);
    }
    ++index;
  });

  auto result = builder.build();
  if (auto* err = result.getError()) {
    // Find the name to provide a better error message.
    std::stringstream msg;
    msg << "Invalid type: " << err->reason;
    for (auto& [name, index] : typeIndices) {
      if (index == err->index) {
        Fatal() << msg.str() << " at type $" << name;
      }
    }
    // No name, just report the index.
    Fatal() << msg.str() << " at index " << err->index;
  }
  types = *result;

  for (auto& [name, index] : typeIndices) {
    auto type = types[index];
    // A type may appear in the type section more than once, but we canonicalize
    // types internally, so there will be a single name chosen for that type. Do
    // so determistically.
    if (wasm.typeNames.count(type) && wasm.typeNames[type].name.str < name) {
      continue;
    }
    auto& currTypeNames = wasm.typeNames[type];
    currTypeNames.name = name;
    if (type.isStruct()) {
      currTypeNames.fieldNames = fieldNames[index];
    }
  }
}

void SExpressionWasmBuilder::preParseFunctionType(Element& s) {
  IString id = s[0]->str();
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
  parseTypeUse(s, i, functionTypes[name]);
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
  bool hasExplicitName = name.is();
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
  HeapType type;
  std::vector<NameType> params;
  i = parseTypeUse(s, i, type, params);

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
    im->setName(name, hasExplicitName);
    im->module = importModule;
    im->base = importBase;
    im->type = type;
    functionTypes[name] = type;
    if (wasm.getFunctionOrNull(im->name)) {
      throw ParseException("duplicate import", s.line, s.col);
    }
    wasm.addFunction(std::move(im));
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
  currFunction = std::unique_ptr<Function>(
    Builder(wasm).makeFunction(name, std::move(params), type, std::move(vars)));
  currFunction->profile = profile;

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
    autoBlock->finalize(type.getSignature().results);
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

Type SExpressionWasmBuilder::stringToType(std::string_view str,
                                          bool allowError,
                                          bool prefix) {
  if (str.size() >= 3) {
    if (str[0] == 'i') {
      if (str[1] == '3' && str[2] == '2' && (prefix || str.size() == 3)) {
        return Type::i32;
      }
      if (str[1] == '6' && str[2] == '4' && (prefix || str.size() == 3)) {
        return Type::i64;
      }
    }
    if (str[0] == 'f') {
      if (str[1] == '3' && str[2] == '2' && (prefix || str.size() == 3)) {
        return Type::f32;
      }
      if (str[1] == '6' && str[2] == '4' && (prefix || str.size() == 3)) {
        return Type::f64;
      }
    }
  }
  if (str.size() >= 4) {
    if (str[0] == 'v') {
      if (str[1] == '1' && str[2] == '2' && str[3] == '8' &&
          (prefix || str.size() == 4)) {
        return Type::v128;
      }
    }
  }
  if (str.substr(0, 7) == "funcref" && (prefix || str.size() == 7)) {
    return Type(HeapType::func, Nullable);
  }
  if (str.substr(0, 9) == "externref" && (prefix || str.size() == 9)) {
    return Type(HeapType::ext, Nullable);
  }
  if (str.substr(0, 6) == "anyref" && (prefix || str.size() == 6)) {
    return Type(HeapType::any, Nullable);
  }
  if (str.substr(0, 5) == "eqref" && (prefix || str.size() == 5)) {
    return Type(HeapType::eq, Nullable);
  }
  if (str.substr(0, 6) == "i31ref" && (prefix || str.size() == 6)) {
    return Type(HeapType::i31, Nullable);
  }
  if (str.substr(0, 9) == "structref" && (prefix || str.size() == 9)) {
    return Type(HeapType::struct_, Nullable);
  }
  if (str.substr(0, 8) == "arrayref" && (prefix || str.size() == 8)) {
    return Type(HeapType::array, Nullable);
  }
  if (str.substr(0, 9) == "stringref" && (prefix || str.size() == 9)) {
    return Type(HeapType::string, Nullable);
  }
  if (str.substr(0, 15) == "stringview_wtf8" && (prefix || str.size() == 15)) {
    return Type(HeapType::stringview_wtf8, Nullable);
  }
  if (str.substr(0, 16) == "stringview_wtf16" && (prefix || str.size() == 16)) {
    return Type(HeapType::stringview_wtf16, Nullable);
  }
  if (str.substr(0, 15) == "stringview_iter" && (prefix || str.size() == 15)) {
    return Type(HeapType::stringview_iter, Nullable);
  }
  if (str.substr(0, 7) == "nullref" && (prefix || str.size() == 7)) {
    return Type(HeapType::none, Nullable);
  }
  if (str.substr(0, 13) == "nullexternref" && (prefix || str.size() == 13)) {
    return Type(HeapType::noext, Nullable);
  }
  if (str.substr(0, 11) == "nullfuncref" && (prefix || str.size() == 11)) {
    return Type(HeapType::nofunc, Nullable);
  }
  if (allowError) {
    return Type::none;
  }
  throw ParseException(std::string("invalid wasm type: ") +
                       std::string(str.data(), str.size()));
}

HeapType SExpressionWasmBuilder::stringToHeapType(std::string_view str,
                                                  bool prefix) {
  if (str.substr(0, 4) == "func" && (prefix || str.size() == 4)) {
    return HeapType::func;
  }
  if (str.substr(0, 2) == "eq" && (prefix || str.size() == 2)) {
    return HeapType::eq;
  }
  if (str.substr(0, 6) == "extern" && (prefix || str.size() == 6)) {
    return HeapType::ext;
  }
  if (str.substr(0, 3) == "any" && (prefix || str.size() == 3)) {
    return HeapType::any;
  }
  if (str.substr(0, 3) == "i31" && (prefix || str.size() == 3)) {
    return HeapType::i31;
  }
  if (str.substr(0, 6) == "struct" && (prefix || str.size() == 6)) {
    return HeapType::struct_;
  }
  if (str.substr(0, 5) == "array" && (prefix || str.size() == 5)) {
    return HeapType::array;
  }
  if (str.substr(0, 6) == "string" && (prefix || str.size() == 6)) {
    return HeapType::string;
  }
  if (str.substr(0, 15) == "stringview_wtf8" && (prefix || str.size() == 15)) {
    return HeapType::stringview_wtf8;
  }
  if (str.substr(0, 16) == "stringview_wtf16" && (prefix || str.size() == 16)) {
    return HeapType::stringview_wtf16;
  }
  if (str.substr(0, 15) == "stringview_iter" && (prefix || str.size() == 15)) {
    return HeapType::stringview_iter;
  }
  if (str.substr(0, 4) == "none" && (prefix || str.size() == 4)) {
    return HeapType::none;
  }
  if (str.substr(0, 8) == "noextern" && (prefix || str.size() == 8)) {
    return HeapType::noext;
  }
  if (str.substr(0, 6) == "nofunc" && (prefix || str.size() == 6)) {
    return HeapType::nofunc;
  }
  throw ParseException(std::string("invalid wasm heap type: ") +
                       std::string(str.data(), str.size()));
}

Type SExpressionWasmBuilder::elementToType(Element& s) {
  if (s.isStr()) {
    return stringToType(s.str());
  }
  auto& list = s.list();
  auto size = list.size();
  if (elementStartsWith(s, REF)) {
    // It's a reference. It should be in the form
    //   (ref $name)
    // or
    //   (ref null $name)
    // and also $name can be the expanded structure of the type and not a name,
    // so something like (ref (func (result i32))), etc.
    if (size != 2 && size != 3) {
      throw ParseException(
        std::string("invalid reference type size"), s.line, s.col);
    }
    if (size == 3 && *list[1] != NULL_) {
      throw ParseException(
        std::string("invalid reference type qualifier"), s.line, s.col);
    }
    Nullability nullable = NonNullable;
    size_t i = 1;
    if (size == 3) {
      nullable = Nullable;
      i++;
    }
    return Type(parseHeapType(*s[i]), nullable);
  }
  // It's a tuple.
  std::vector<Type> types;
  for (size_t i = 0; i < s.size(); ++i) {
    types.push_back(elementToType(*list[i]));
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

HeapType SExpressionWasmBuilder::getFunctionType(Name name, Element& s) {
  auto iter = functionTypes.find(name);
  if (iter == functionTypes.end()) {
    throw ParseException(
      "invalid call target: " + std::string(name.str), s.line, s.col);
  }
  return iter->second;
}

Function::DebugLocation
SExpressionWasmBuilder::getDebugLocation(const SourceLocation& loc) {
  IString file = loc.filename;
  auto& debugInfoFileNames = wasm.debugInfoFileNames;
  auto iter = debugInfoFileIndices.find(file);
  if (iter == debugInfoFileIndices.end()) {
    Index index = debugInfoFileNames.size();
    debugInfoFileNames.push_back(file.toString());
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

Expression* SExpressionWasmBuilder::makeMemorySize(Element& s) {
  auto ret = allocator.alloc<MemorySize>();
  Index i = 1;
  Name memory;
  if (s.size() > 1) {
    memory = getMemoryName(*s[i++]);
  } else {
    memory = getMemoryNameAtIdx(0);
  }
  ret->memory = memory;
  if (isMemory64(memory)) {
    ret->make64();
  }
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeMemoryGrow(Element& s) {
  auto ret = allocator.alloc<MemoryGrow>();
  Index i = 1;
  Name memory;
  if (s.size() > 2) {
    memory = getMemoryName(*s[i++]);
  } else {
    memory = getMemoryNameAtIdx(0);
  }
  ret->memory = memory;
  if (isMemory64(memory)) {
    ret->make64();
  }
  ret->delta = parseExpression(s[i]);
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
  Index ret = parseIndex(s);
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
  // The information we need for the stack of blocks here is the element we are
  // converting, the block we are converting it to, and whether it originally
  // had a name or not (which will be useful later).
  struct Info {
    Element* element;
    Block* block;
    bool hadName;
  };
  std::vector<Info> stack;
  while (1) {
    auto& s = *sp;
    Index i = 1;
    Name sName;
    bool hadName = false;
    if (i < s.size() && s[i]->isStr()) {
      // could be a name or a type
      if (s[i]->dollared() ||
          stringToType(s[i]->str(), true /* allowError */) == Type::none) {
        sName = s[i++]->str();
        hadName = true;
      } else {
        sName = "block";
      }
    } else {
      sName = "block";
    }
    stack.emplace_back(Info{sp, curr, hadName});
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
    auto* sp = stack[t].element;
    auto* curr = stack[t].block;
    auto hadName = stack[t].hadName;
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
        curr->list.push_back(stack[t + 1].block);
        i++;
      }
      for (; i < s.size(); i++) {
        curr->list.push_back(parseExpression(s[i]));
      }
    }
    nameMapper.popLabelName(curr->name);
    curr->finalize(curr->type);
    // If the block never had a name, and one was not needed in practice (even
    // if one did not exist, perhaps a break targeted it by index), then we can
    // remove the name. Note that we only do this if it never had a name: if it
    // did, we don't want to change anything; we just want to be the same as
    // the code we are loading - if there was no name before, we don't want one
    // now, so that we roundtrip text precisely.
    if (!hadName && !BranchUtils::BranchSeeker::has(curr, curr->name)) {
      curr->name = Name();
    }
  }
  return stack[0].block;
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

static Expression* parseConst(IString s, Type type, MixedArena& allocator) {
  const char* str = s.str.data();
  auto ret = allocator.alloc<Const>();
  ret->type = type;
  if (type.isFloat()) {
    if (s == _INFINITY) {
      switch (type.getBasic()) {
        case Type::f32:
          ret->value = Literal(std::numeric_limits<float>::infinity());
          break;
        case Type::f64:
          ret->value = Literal(std::numeric_limits<double>::infinity());
          break;
        default:
          return nullptr;
      }
      return ret;
    }
    if (s == NEG_INFINITY) {
      switch (type.getBasic()) {
        case Type::f32:
          ret->value = Literal(-std::numeric_limits<float>::infinity());
          break;
        case Type::f64:
          ret->value = Literal(-std::numeric_limits<double>::infinity());
          break;
        default:
          return nullptr;
      }
      return ret;
    }
    if (s == _NAN) {
      switch (type.getBasic()) {
        case Type::f32:
          ret->value = Literal(float(std::nan("")));
          break;
        case Type::f64:
          ret->value = Literal(double(std::nan("")));
          break;
        default:
          return nullptr;
      }
      return ret;
    }
    bool negative = str[0] == '-';
    const char* positive = negative ? str + 1 : str;
    if (!negative) {
      if (positive[0] == '+') {
        positive++;
      }
    }
    if (positive[0] == 'n' && positive[1] == 'a' && positive[2] == 'n') {
      const char* modifier = positive[3] == ':' ? positive + 4 : nullptr;
      if (!(modifier ? positive[4] == '0' && positive[5] == 'x' : 1)) {
        throw ParseException("bad nan input");
      }
      switch (type.getBasic()) {
        case Type::f32: {
          uint32_t pattern;
          if (modifier) {
            std::istringstream istr(modifier);
            istr >> std::hex >> pattern;
            if (istr.fail()) {
              throw ParseException("invalid f32 format");
            }
            pattern |= 0x7f800000U;
          } else {
            pattern = 0x7fc00000U;
          }
          if (negative) {
            pattern |= 0x80000000U;
          }
          if (!std::isnan(bit_cast<float>(pattern))) {
            pattern |= 1U;
          }
          ret->value = Literal(pattern).castToF32();
          break;
        }
        case Type::f64: {
          uint64_t pattern;
          if (modifier) {
            std::istringstream istr(modifier);
            istr >> std::hex >> pattern;
            if (istr.fail()) {
              throw ParseException("invalid f64 format");
            }
            pattern |= 0x7ff0000000000000ULL;
          } else {
            pattern = 0x7ff8000000000000UL;
          }
          if (negative) {
            pattern |= 0x8000000000000000ULL;
          }
          if (!std::isnan(bit_cast<double>(pattern))) {
            pattern |= 1ULL;
          }
          ret->value = Literal(pattern).castToF64();
          break;
        }
        default:
          return nullptr;
      }
      // std::cerr << "make constant " << str << " ==> " << ret->value << '\n';
      return ret;
    }
    if (s == NEG_NAN) {
      switch (type.getBasic()) {
        case Type::f32:
          ret->value = Literal(float(-std::nan("")));
          break;
        case Type::f64:
          ret->value = Literal(double(-std::nan("")));
          break;
        default:
          return nullptr;
      }
      // std::cerr << "make constant " << str << " ==> " << ret->value << '\n';
      return ret;
    }
  }
  switch (type.getBasic()) {
    case Type::i32: {
      if ((str[0] == '0' && str[1] == 'x') ||
          (str[0] == '-' && str[1] == '0' && str[2] == 'x')) {
        bool negative = str[0] == '-';
        if (negative) {
          str++;
        }
        std::istringstream istr(str);
        uint32_t temp;
        istr >> std::hex >> temp;
        if (istr.fail()) {
          throw ParseException("invalid i32 format");
        }
        ret->value = Literal(negative ? -temp : temp);
      } else {
        std::istringstream istr(str[0] == '-' ? str + 1 : str);
        uint32_t temp;
        istr >> temp;
        if (istr.fail()) {
          throw ParseException("invalid i32 format");
        }
        ret->value = Literal(str[0] == '-' ? -temp : temp);
      }
      break;
    }
    case Type::i64: {
      if ((str[0] == '0' && str[1] == 'x') ||
          (str[0] == '-' && str[1] == '0' && str[2] == 'x')) {
        bool negative = str[0] == '-';
        if (negative) {
          str++;
        }
        std::istringstream istr(str);
        uint64_t temp;
        istr >> std::hex >> temp;
        if (istr.fail()) {
          throw ParseException("invalid i64 format");
        }
        ret->value = Literal(negative ? -temp : temp);
      } else {
        std::istringstream istr(str[0] == '-' ? str + 1 : str);
        uint64_t temp;
        istr >> temp;
        if (istr.fail()) {
          throw ParseException("invalid i64 format");
        }
        ret->value = Literal(str[0] == '-' ? -temp : temp);
      }
      break;
    }
    case Type::f32: {
      char* end;
      ret->value = Literal(strtof(str, &end));
      break;
    }
    case Type::f64: {
      char* end;
      ret->value = Literal(strtod(str, &end));
      break;
    }
    case Type::v128:
      WASM_UNREACHABLE("unexpected const type");
    case Type::none:
    case Type::unreachable: {
      return nullptr;
    }
  }
  if (ret->value.type != type) {
    throw ParseException("parsed type does not match expected type");
  }
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
  Type lane_t = stringToLaneType(s[1]->str().str.data());
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

static size_t parseMemAttributes(size_t i,
                                 Element& s,
                                 Address& offset,
                                 Address& align,
                                 bool memory64) {
  // Parse "align=X" and "offset=X" arguments, bailing out on anything else.
  while (!s[i]->isList()) {
    const char* str = s[i]->str().str.data();
    if (strncmp(str, "align", 5) != 0 && strncmp(str, "offset", 6) != 0) {
      return i;
    }
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
      if (!memory64 && value > std::numeric_limits<uint32_t>::max()) {
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

bool SExpressionWasmBuilder::hasMemoryIdx(Element& s,
                                          Index defaultSize,
                                          Index i) {
  if (s.size() > defaultSize && !s[i]->isList() &&
      strncmp(s[i]->str().str.data(), "align", 5) != 0 &&
      strncmp(s[i]->str().str.data(), "offset", 6) != 0) {
    return true;
  }
  return false;
}

Expression* SExpressionWasmBuilder::makeLoad(
  Element& s, Type type, bool signed_, int bytes, bool isAtomic) {
  auto* ret = allocator.alloc<Load>();
  ret->type = type;
  ret->bytes = bytes;
  ret->signed_ = signed_;
  ret->offset = 0;
  ret->align = bytes;
  ret->isAtomic = isAtomic;
  Index i = 1;
  Name memory;
  // Check to make sure there are more than the default args & this str isn't
  // the mem attributes
  if (hasMemoryIdx(s, 2, i)) {
    memory = getMemoryName(*s[i++]);
  } else {
    memory = getMemoryNameAtIdx(0);
  }
  ret->memory = memory;
  i = parseMemAttributes(i, s, ret->offset, ret->align, isMemory64(memory));
  ret->ptr = parseExpression(s[i]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeStore(Element& s,
                                              Type type,
                                              int bytes,
                                              bool isAtomic) {
  auto ret = allocator.alloc<Store>();
  ret->bytes = bytes;
  ret->offset = 0;
  ret->align = bytes;
  ret->isAtomic = isAtomic;
  ret->valueType = type;
  Index i = 1;
  Name memory;
  // Check to make sure there are more than the default args & this str isn't
  // the mem attributes
  if (hasMemoryIdx(s, 3, i)) {
    memory = getMemoryName(*s[i++]);
  } else {
    memory = getMemoryNameAtIdx(0);
  }
  ret->memory = memory;
  i = parseMemAttributes(i, s, ret->offset, ret->align, isMemory64(memory));
  ret->ptr = parseExpression(s[i]);
  ret->value = parseExpression(s[i + 1]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeAtomicRMW(Element& s,
                                                  AtomicRMWOp op,
                                                  Type type,
                                                  uint8_t bytes) {
  auto ret = allocator.alloc<AtomicRMW>();
  ret->type = type;
  ret->op = op;
  ret->bytes = bytes;
  ret->offset = 0;
  Index i = 1;
  Name memory;
  // Check to make sure there are more than the default args & this str isn't
  // the mem attributes
  if (hasMemoryIdx(s, 3, i)) {
    memory = getMemoryName(*s[i++]);
  } else {
    memory = getMemoryNameAtIdx(0);
  }
  ret->memory = memory;
  Address align = bytes;
  i = parseMemAttributes(i, s, ret->offset, align, isMemory64(memory));
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
                                                      uint8_t bytes) {
  auto ret = allocator.alloc<AtomicCmpxchg>();
  ret->type = type;
  ret->bytes = bytes;
  ret->offset = 0;
  Index i = 1;
  Name memory;
  // Check to make sure there are more than the default args & this str isn't
  // the mem attributes
  if (hasMemoryIdx(s, 4, i)) {
    memory = getMemoryName(*s[i++]);
  } else {
    memory = getMemoryNameAtIdx(0);
  }
  ret->memory = memory;
  Address align = ret->bytes;
  i = parseMemAttributes(i, s, ret->offset, align, isMemory64(memory));
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
  ret->offset = 0;
  ret->expectedType = type;
  Index i = 1;
  Name memory;
  // Check to make sure there are more than the default args & this str isn't
  // the mem attributes
  if (hasMemoryIdx(s, 4, i)) {
    memory = getMemoryName(*s[i++]);
  } else {
    memory = getMemoryNameAtIdx(0);
  }
  ret->memory = memory;
  Address expectedAlign = type == Type::i64 ? 8 : 4;
  Address align = expectedAlign;
  i = parseMemAttributes(i, s, ret->offset, align, isMemory64(memory));
  if (align != expectedAlign) {
    throw ParseException(
      "Align of memory.atomic.wait must match size", s.line, s.col);
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
  ret->offset = 0;
  Index i = 1;
  Name memory;
  // Check to make sure there are more than the default args & this str isn't
  // the mem attributes
  if (hasMemoryIdx(s, 3, i)) {
    memory = getMemoryName(*s[i++]);
  } else {
    memory = getMemoryNameAtIdx(0);
  }
  ret->memory = memory;
  Address align = 4;
  i = parseMemAttributes(i, s, ret->offset, align, isMemory64(memory));
  if (align != 4) {
    throw ParseException(
      "Align of memory.atomic.notify must be 4", s.line, s.col);
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
  const char* str = s->str().str.data();
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

Expression*
SExpressionWasmBuilder::makeSIMDLoad(Element& s, SIMDLoadOp op, int bytes) {
  auto ret = allocator.alloc<SIMDLoad>();
  ret->op = op;
  ret->offset = 0;
  ret->align = bytes;
  Index i = 1;
  Name memory;
  // Check to make sure there are more than the default args & this str isn't
  // the mem attributes
  if (hasMemoryIdx(s, 2, i)) {
    memory = getMemoryName(*s[i++]);
  } else {
    memory = getMemoryNameAtIdx(0);
  }
  ret->memory = memory;
  i = parseMemAttributes(i, s, ret->offset, ret->align, isMemory64(memory));
  ret->ptr = parseExpression(s[i]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeSIMDLoadStoreLane(
  Element& s, SIMDLoadStoreLaneOp op, int bytes) {
  auto* ret = allocator.alloc<SIMDLoadStoreLane>();
  ret->op = op;
  ret->offset = 0;
  ret->align = bytes;
  size_t lanes;
  switch (op) {
    case Load8LaneVec128:
    case Store8LaneVec128:
      lanes = 16;
      break;
    case Load16LaneVec128:
    case Store16LaneVec128:
      lanes = 8;
      break;
    case Load32LaneVec128:
    case Store32LaneVec128:
      lanes = 4;
      break;
    case Load64LaneVec128:
    case Store64LaneVec128:
      lanes = 2;
      break;
    default:
      WASM_UNREACHABLE("Unexpected SIMDLoadStoreLane op");
  }
  Index i = 1;
  Name memory;
  // Check to make sure there are more than the default args & this str isn't
  // the mem attributes
  if (hasMemoryIdx(s, 4, i)) {
    memory = getMemoryName(*s[i++]);
  } else {
    memory = getMemoryNameAtIdx(0);
  }
  ret->memory = memory;
  i = parseMemAttributes(i, s, ret->offset, ret->align, isMemory64(memory));
  ret->index = parseLaneIndex(s[i++], lanes);
  ret->ptr = parseExpression(s[i++]);
  ret->vec = parseExpression(s[i]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeMemoryInit(Element& s) {
  auto ret = allocator.alloc<MemoryInit>();
  Index i = 1;
  Name memory;
  if (s.size() > 5) {
    memory = getMemoryName(*s[i++]);
  } else {
    memory = getMemoryNameAtIdx(0);
  }
  ret->memory = memory;
  ret->segment = parseIndex(*s[i++]);
  ret->dest = parseExpression(s[i++]);
  ret->offset = parseExpression(s[i++]);
  ret->size = parseExpression(s[i]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeDataDrop(Element& s) {
  auto ret = allocator.alloc<DataDrop>();
  ret->segment = parseIndex(*s[1]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeMemoryCopy(Element& s) {
  auto ret = allocator.alloc<MemoryCopy>();
  Index i = 1;
  Name destMemory;
  Name sourceMemory;
  if (s.size() > 4) {
    destMemory = getMemoryName(*s[i++]);
    sourceMemory = getMemoryName(*s[i++]);
  } else {
    destMemory = getMemoryNameAtIdx(0);
    sourceMemory = getMemoryNameAtIdx(0);
  }
  ret->destMemory = destMemory;
  ret->sourceMemory = sourceMemory;
  ret->dest = parseExpression(s[i++]);
  ret->source = parseExpression(s[i++]);
  ret->size = parseExpression(s[i]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeMemoryFill(Element& s) {
  auto ret = allocator.alloc<MemoryFill>();
  Index i = 1;
  Name memory;
  if (s.size() > 4) {
    memory = getMemoryName(*s[i++]);
  } else {
    memory = getMemoryNameAtIdx(0);
  }
  ret->memory = memory;
  ret->dest = parseExpression(s[i++]);
  ret->value = parseExpression(s[i++]);
  ret->size = parseExpression(s[i]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makePop(Element& s) {
  auto ret = allocator.alloc<Pop>();
  std::vector<Type> types;
  for (size_t i = 1; i < s.size(); ++i) {
    types.push_back(elementToType(*s[i]));
  }
  ret->type = Type(types);
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
  ret->type = getFunctionType(ret->target, s).getSignature().results;
  parseCallOperands(s, 2, s.size(), ret);
  ret->isReturn = isReturn;
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeCallIndirect(Element& s,
                                                     bool isReturn) {
  if (wasm.tables.empty()) {
    throw ParseException("no tables", s.line, s.col);
  }
  Index i = 1;
  auto ret = allocator.alloc<CallIndirect>();
  if (s[i]->isStr()) {
    ret->table = s[i++]->str();
  } else {
    ret->table = wasm.tables.front()->name;
  }
  HeapType callType;
  i = parseTypeUse(s, i, callType);
  ret->heapType = callType;
  parseCallOperands(s, i, s.size() - 1, ret);
  ret->target = parseExpression(s[s.size() - 1]);
  ret->isReturn = isReturn;
  ret->finalize();
  return ret;
}

Name SExpressionWasmBuilder::getLabel(Element& s, LabelType labelType) {
  if (s.dollared()) {
    return nameMapper.sourceToUnique(s.str());
  } else {
    // offset, break to nth outside label
    uint64_t offset;
    try {
      offset = std::stoll(s.toString(), nullptr, 0);
    } catch (std::invalid_argument&) {
      throw ParseException("invalid break offset", s.line, s.col);
    } catch (std::out_of_range&) {
      throw ParseException("out of range break offset", s.line, s.col);
    }
    if (offset > nameMapper.labelStack.size()) {
      throw ParseException("invalid label", s.line, s.col);
    }
    if (offset == nameMapper.labelStack.size()) {
      if (labelType == LabelType::Break) {
        // a break to the function's scope. this means we need an automatic
        // block, with a name
        brokeToAutoBlock = true;
        return FAKE_RETURN;
      }
      // This is a delegate that delegates to the caller
      return DELEGATE_CALLER_TARGET;
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
  auto ret = allocator.alloc<RefNull>();
  // The heap type may be just "func", that is, the whole thing is just
  // (ref.null func), or it may be the name of a defined type, such as
  // (ref.null $struct.FOO)
  if (s[1]->dollared()) {
    ret->finalize(parseHeapType(*s[1]).getBottom());
  } else {
    ret->finalize(stringToHeapType(s[1]->str()).getBottom());
  }
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
  // To support typed function refs, we give the reference not just a general
  // funcref, but a specific subtype with the actual signature.
  ret->finalize(Type(getFunctionType(func, s), NonNullable));
  return ret;
}

Expression* SExpressionWasmBuilder::makeRefEq(Element& s) {
  auto ret = allocator.alloc<RefEq>();
  ret->left = parseExpression(s[1]);
  ret->right = parseExpression(s[2]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeTableGet(Element& s) {
  auto tableName = s[1]->str();
  auto* index = parseExpression(s[2]);
  auto* table = wasm.getTableOrNull(tableName);
  if (!table) {
    throw ParseException("invalid table name in table.get", s.line, s.col);
  }
  return Builder(wasm).makeTableGet(tableName, index, table->type);
}

Expression* SExpressionWasmBuilder::makeTableSet(Element& s) {
  auto tableName = s[1]->str();
  auto* table = wasm.getTableOrNull(tableName);
  if (!table) {
    throw ParseException("invalid table name in table.set", s.line, s.col);
  }
  auto* index = parseExpression(s[2]);
  auto* value = parseExpression(s[3]);
  return Builder(wasm).makeTableSet(tableName, index, value);
}

Expression* SExpressionWasmBuilder::makeTableSize(Element& s) {
  auto tableName = s[1]->str();
  auto* table = wasm.getTableOrNull(tableName);
  if (!table) {
    throw ParseException("invalid table name in table.size", s.line, s.col);
  }
  return Builder(wasm).makeTableSize(tableName);
}

Expression* SExpressionWasmBuilder::makeTableGrow(Element& s) {
  auto tableName = s[1]->str();
  auto* table = wasm.getTableOrNull(tableName);
  if (!table) {
    throw ParseException("invalid table name in table.grow", s.line, s.col);
  }
  auto* value = parseExpression(s[2]);
  if (!value->type.isRef()) {
    throw ParseException("only reference types are valid for tables");
  }
  auto* delta = parseExpression(s[3]);
  return Builder(wasm).makeTableGrow(tableName, value, delta);
}

// try can be either in the form of try-catch or try-delegate.
// try-catch is written in the folded wast format as
// (try
//  (do
//    ...
//  )
//  (catch $e
//    ...
//  )
//  ...
//  (catch_all
//    ...
//  )
// )
// Any number of catch blocks can exist, including none. Zero or one catch_all
// block can exist, and if it does, it should be at the end. There should be at
// least one catch or catch_all body per try.
//
// try-delegate is written in the folded format as
// (try
//  (do
//    ...
//  )
//  (delegate $label)
// )
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
  ret->name = nameMapper.pushLabelName(sName);
  Type type = parseOptionalResultType(s, i); // signature

  if (!elementStartsWith(*s[i], "do")) {
    throw ParseException(
      "try body should start with 'do'", s[i]->line, s[i]->col);
  }
  ret->body = makeMaybeBlock(*s[i++], 1, type);

  while (i < s.size() && elementStartsWith(*s[i], "catch")) {
    Element& inner = *s[i++];
    if (inner.size() < 2) {
      throw ParseException("invalid catch block", inner.line, inner.col);
    }
    Name tag = getTagName(*inner[1]);
    if (!wasm.getTagOrNull(tag)) {
      throw ParseException("bad tag name", inner[1]->line, inner[1]->col);
    }
    ret->catchTags.push_back(getTagName(*inner[1]));
    ret->catchBodies.push_back(makeMaybeBlock(inner, 2, type));
  }

  if (i < s.size() && elementStartsWith(*s[i], "catch_all")) {
    ret->catchBodies.push_back(makeMaybeBlock(*s[i++], 1, type));
  }

  // 'delegate' cannot target its own try. So we pop the name here.
  nameMapper.popLabelName(ret->name);

  if (i < s.size() && elementStartsWith(*s[i], "delegate")) {
    Element& inner = *s[i++];
    if (inner.size() != 2) {
      throw ParseException("invalid delegate", inner.line, inner.col);
    }
    ret->delegateTarget = getLabel(*inner[1], LabelType::Exception);
  }

  if (i != s.size()) {
    throw ParseException(
      "there should be at most one catch_all block at the end", s.line, s.col);
  }

  ret->finalize(type);

  // create a break target if we must
  if (BranchUtils::BranchSeeker::has(ret, ret->name)) {
    auto* block = allocator.alloc<Block>();
    // We create a different name for the wrapping block, because try's name can
    // be used by internal delegates
    block->name = nameMapper.pushLabelName(sName);
    // For simplicity, try's name can only be targeted by delegates and
    // rethrows. Make the branches target the new wrapping block instead.
    BranchUtils::replaceBranchTargets(ret, ret->name, block->name);
    block->list.push_back(ret);
    nameMapper.popLabelName(block->name);
    block->finalize(type);
    return block;
  }
  return ret;
}

Expression* SExpressionWasmBuilder::makeThrow(Element& s) {
  auto ret = allocator.alloc<Throw>();
  Index i = 1;

  ret->tag = getTagName(*s[i++]);
  if (!wasm.getTagOrNull(ret->tag)) {
    throw ParseException("bad tag name", s[1]->line, s[1]->col);
  }
  for (; i < s.size(); i++) {
    ret->operands.push_back(parseExpression(s[i]));
  }
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeRethrow(Element& s) {
  auto ret = allocator.alloc<Rethrow>();
  ret->target = getLabel(*s[1], LabelType::Exception);
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
  ret->index = parseIndex(*s[1]);
  ret->tuple = parseExpression(s[2]);
  if (ret->tuple->type != Type::unreachable &&
      ret->index >= ret->tuple->type.size()) {
    throw ParseException("Bad index on tuple.extract", s[1]->line, s[1]->col);
  }
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeCallRef(Element& s, bool isReturn) {
  HeapType sigType = parseHeapType(*s[1]);
  std::vector<Expression*> operands;
  parseOperands(s, 2, s.size() - 1, operands);
  auto* target = parseExpression(s[s.size() - 1]);

  if (!sigType.isSignature()) {
    throw ParseException(
      std::string(isReturn ? "return_call_ref" : "call_ref") +
        " type annotation should be a signature",
      s.line,
      s.col);
  }
  return Builder(wasm).makeCallRef(
    target, operands, sigType.getSignature().results, isReturn);
}

Expression* SExpressionWasmBuilder::makeI31New(Element& s) {
  auto ret = allocator.alloc<I31New>();
  ret->value = parseExpression(s[1]);
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeI31Get(Element& s, bool signed_) {
  auto ret = allocator.alloc<I31Get>();
  ret->i31 = parseExpression(s[1]);
  ret->signed_ = signed_;
  ret->finalize();
  return ret;
}

Expression* SExpressionWasmBuilder::makeRefTest(Element& s,
                                                std::optional<Type> castType) {
  int i = 1;
  if (!castType) {
    auto nullability = NonNullable;
    if (s[0]->str().str != "ref.test_static" && s[1]->str().str == "null") {
      nullability = Nullable;
      ++i;
    }
    auto type = parseHeapType(*s[i++]);
    castType = Type(type, nullability);
  }
  auto* ref = parseExpression(*s[i++]);
  return Builder(wasm).makeRefTest(ref, *castType);
}

Expression* SExpressionWasmBuilder::makeRefCast(Element& s,
                                                std::optional<Type> castType) {
  int i = 1;
  bool legacy = false;
  if (!castType) {
    Nullability nullability = NonNullable;
    if (s[0]->str().str == "ref.cast_static") {
      legacy = true;
    } else if (s[i]->str().str == "null") {
      nullability = Nullable;
      ++i;
    }
    auto type = parseHeapType(*s[i++]);
    castType = Type(type, nullability);
  }
  auto* ref = parseExpression(*s[i++]);
  if (legacy) {
    // Legacy polymorphic behavior.
    castType = Type(castType->getHeapType(), ref->type.getNullability());
  }
  return Builder(wasm).makeRefCast(ref, *castType, RefCast::Safe);
}

Expression* SExpressionWasmBuilder::makeRefCastNop(Element& s) {
  auto heapType = parseHeapType(*s[1]);
  auto* ref = parseExpression(*s[2]);
  // Legacy polymorphic behavior.
  auto type = Type(heapType, ref->type.getNullability());
  return Builder(wasm).makeRefCast(ref, type, RefCast::Unsafe);
}

Expression* SExpressionWasmBuilder::makeBrOnNull(Element& s, bool onFail) {
  int i = 1;
  auto name = getLabel(*s[i++]);
  auto* ref = parseExpression(*s[i]);
  auto op = onFail ? BrOnNonNull : BrOnNull;
  return Builder(wasm).makeBrOn(op, name, ref);
}

Expression* SExpressionWasmBuilder::makeBrOnCast(Element& s,
                                                 std::optional<Type> castType,
                                                 bool onFail) {
  int i = 1;
  auto name = getLabel(*s[i++]);
  if (!castType) {
    auto nullability = NonNullable;
    if (s[i]->str().str == "null") {
      nullability = Nullable;
      ++i;
    }
    auto type = parseHeapType(*s[i++]);
    castType = Type(type, nullability);
  }
  auto* ref = parseExpression(*s[i]);
  auto op = onFail ? BrOnCastFail : BrOnCast;
  return Builder(wasm).makeBrOn(op, name, ref, *castType);
}

Expression* SExpressionWasmBuilder::makeStructNew(Element& s, bool default_) {
  auto heapType = parseHeapType(*s[1]);
  auto numOperands = s.size() - 2;
  if (default_ && numOperands > 0) {
    throw ParseException("arguments provided for struct.new", s.line, s.col);
  }
  std::vector<Expression*> operands;
  operands.resize(numOperands);
  for (Index i = 0; i < numOperands; i++) {
    operands[i] = parseExpression(*s[i + 2]);
  }
  return Builder(wasm).makeStructNew(heapType, operands);
}

Index SExpressionWasmBuilder::getStructIndex(Element& type, Element& field) {
  if (field.dollared()) {
    auto name = field.str();
    auto index = typeIndices[type.toString()];
    auto struct_ = types[index].getStruct();
    auto& fields = struct_.fields;
    const auto& names = fieldNames[index];
    for (Index i = 0; i < fields.size(); i++) {
      auto it = names.find(i);
      if (it != names.end() && it->second == name) {
        return i;
      }
    }
    throw ParseException("bad struct field name", field.line, field.col);
  }
  // this is a numeric index
  return parseIndex(field);
}

Expression* SExpressionWasmBuilder::makeStructGet(Element& s, bool signed_) {
  auto heapType = parseHeapType(*s[1]);
  if (!heapType.isStruct()) {
    throw ParseException("bad struct heap type", s.line, s.col);
  }
  auto index = getStructIndex(*s[1], *s[2]);
  auto type = heapType.getStruct().fields[index].type;
  auto ref = parseExpression(*s[3]);
  validateHeapTypeUsingChild(ref, heapType, s);
  return Builder(wasm).makeStructGet(index, ref, type, signed_);
}

Expression* SExpressionWasmBuilder::makeStructSet(Element& s) {
  auto heapType = parseHeapType(*s[1]);
  if (!heapType.isStruct()) {
    throw ParseException("bad struct heap type", s.line, s.col);
  }
  auto index = getStructIndex(*s[1], *s[2]);
  auto ref = parseExpression(*s[3]);
  validateHeapTypeUsingChild(ref, heapType, s);
  auto value = parseExpression(*s[4]);
  return Builder(wasm).makeStructSet(index, ref, value);
}

Expression* SExpressionWasmBuilder::makeArrayNew(Element& s, bool default_) {
  auto heapType = parseHeapType(*s[1]);
  Expression* init = nullptr;
  size_t i = 2;
  if (!default_) {
    init = parseExpression(*s[i++]);
  }
  auto* size = parseExpression(*s[i++]);
  return Builder(wasm).makeArrayNew(heapType, size, init);
}

Expression* SExpressionWasmBuilder::makeArrayNewSeg(Element& s,
                                                    ArrayNewSegOp op) {
  auto heapType = parseHeapType(*s[1]);
  Index seg = parseIndex(*s[2]);
  Expression* offset = parseExpression(*s[3]);
  Expression* size = parseExpression(*s[4]);
  return Builder(wasm).makeArrayNewSeg(op, heapType, seg, offset, size);
}

Expression* SExpressionWasmBuilder::makeArrayInitStatic(Element& s) {
  auto heapType = parseHeapType(*s[1]);
  size_t i = 2;
  std::vector<Expression*> values;
  while (i < s.size()) {
    values.push_back(parseExpression(*s[i++]));
  }
  return Builder(wasm).makeArrayInit(heapType, values);
}

Expression* SExpressionWasmBuilder::makeArrayGet(Element& s, bool signed_) {
  auto heapType = parseHeapType(*s[1]);
  if (!heapType.isArray()) {
    throw ParseException("bad array heap type", s.line, s.col);
  }
  auto ref = parseExpression(*s[2]);
  auto type = heapType.getArray().element.type;
  validateHeapTypeUsingChild(ref, heapType, s);
  auto index = parseExpression(*s[3]);
  return Builder(wasm).makeArrayGet(ref, index, type, signed_);
}

Expression* SExpressionWasmBuilder::makeArraySet(Element& s) {
  auto heapType = parseHeapType(*s[1]);
  auto ref = parseExpression(*s[2]);
  validateHeapTypeUsingChild(ref, heapType, s);
  auto index = parseExpression(*s[3]);
  auto value = parseExpression(*s[4]);
  return Builder(wasm).makeArraySet(ref, index, value);
}

Expression* SExpressionWasmBuilder::makeArrayLen(Element& s) {
  // There may or may not be a type annotation.
  Index i = 1;
  try {
    parseHeapType(*s[i]);
    ++i;
  } catch (...) {
  }
  auto ref = parseExpression(*s[i]);
  return Builder(wasm).makeArrayLen(ref);
}

Expression* SExpressionWasmBuilder::makeArrayCopy(Element& s) {
  auto destHeapType = parseHeapType(*s[1]);
  auto srcHeapType = parseHeapType(*s[2]);
  auto destRef = parseExpression(*s[3]);
  validateHeapTypeUsingChild(destRef, destHeapType, s);
  auto destIndex = parseExpression(*s[4]);
  auto srcRef = parseExpression(*s[5]);
  validateHeapTypeUsingChild(srcRef, srcHeapType, s);
  auto srcIndex = parseExpression(*s[6]);
  auto length = parseExpression(*s[7]);
  return Builder(wasm).makeArrayCopy(
    destRef, destIndex, srcRef, srcIndex, length);
}

Expression* SExpressionWasmBuilder::makeRefAs(Element& s, RefAsOp op) {
  auto* value = parseExpression(s[1]);
  if (!value->type.isRef() && value->type != Type::unreachable) {
    throw ParseException("ref.as child must be a ref", s.line, s.col);
  }
  return Builder(wasm).makeRefAs(op, value);
}

Expression*
SExpressionWasmBuilder::makeStringNew(Element& s, StringNewOp op, bool try_) {
  size_t i = 1;
  Expression* length = nullptr;
  if (op == StringNewWTF8 || op == StringNewUTF8) {
    if (!try_) {
      std::string_view str = s[i++]->str().str;
      if (str == "utf8") {
        op = StringNewUTF8;
      } else if (str == "wtf8") {
        op = StringNewWTF8;
      } else if (str == "replace") {
        op = StringNewReplace;
      } else {
        throw ParseException("bad string.new op", s.line, s.col);
      }
    }
    length = parseExpression(s[i + 1]);
    return Builder(wasm).makeStringNew(op, parseExpression(s[i]), length, try_);
  } else if (op == StringNewWTF16) {
    length = parseExpression(s[i + 1]);
    return Builder(wasm).makeStringNew(op, parseExpression(s[i]), length, try_);
  } else if (op == StringNewWTF8Array || op == StringNewUTF8Array) {
    if (!try_) {
      std::string_view str = s[i++]->str().str;
      if (str == "utf8") {
        op = StringNewUTF8Array;
      } else if (str == "wtf8") {
        op = StringNewWTF8Array;
      } else if (str == "replace") {
        op = StringNewReplaceArray;
      } else {
        throw ParseException("bad string.new op", s.line, s.col);
      }
    }
    auto* start = parseExpression(s[i + 1]);
    auto* end = parseExpression(s[i + 2]);
    return Builder(wasm).makeStringNew(
      op, parseExpression(s[i]), start, end, try_);
  } else if (op == StringNewWTF16Array) {
    auto* start = parseExpression(s[i + 1]);
    auto* end = parseExpression(s[i + 2]);
    return Builder(wasm).makeStringNew(
      op, parseExpression(s[i]), start, end, try_);
  } else if (op == StringNewFromCodePoint) {
    return Builder(wasm).makeStringNew(
      op, parseExpression(s[i]), nullptr, try_);
  } else {
    throw ParseException("bad string.new op", s.line, s.col);
  }
}

Expression* SExpressionWasmBuilder::makeStringConst(Element& s) {
  std::vector<char> data;
  stringToBinary(*s[1], s[1]->str().str, data);
  Name str = std::string_view(data.data(), data.size());
  return Builder(wasm).makeStringConst(str);
}

Expression* SExpressionWasmBuilder::makeStringMeasure(Element& s,
                                                      StringMeasureOp op) {
  size_t i = 1;
  if (op == StringMeasureWTF8) {
    std::string_view str = s[i++]->str().str;
    if (str == "utf8") {
      op = StringMeasureUTF8;
    } else if (str == "wtf8") {
      op = StringMeasureWTF8;
    } else {
      throw ParseException("bad string.measure op", s.line, s.col);
    }
  }
  return Builder(wasm).makeStringMeasure(op, parseExpression(s[i]));
}

Expression* SExpressionWasmBuilder::makeStringEncode(Element& s,
                                                     StringEncodeOp op) {
  size_t i = 1;
  Expression* start = nullptr;
  if (op == StringEncodeWTF8) {
    std::string_view str = s[i++]->str().str;
    if (str == "utf8") {
      op = StringEncodeUTF8;
    } else if (str == "wtf8") {
      op = StringEncodeWTF8;
    } else {
      throw ParseException("bad string.new op", s.line, s.col);
    }
  } else if (op == StringEncodeWTF8Array) {
    std::string_view str = s[i++]->str().str;
    if (str == "utf8") {
      op = StringEncodeUTF8Array;
    } else if (str == "wtf8") {
      op = StringEncodeWTF8Array;
    } else {
      throw ParseException("bad string.new op", s.line, s.col);
    }
    start = parseExpression(s[i + 2]);
  } else if (op == StringEncodeWTF16Array) {
    start = parseExpression(s[i + 2]);
  }
  return Builder(wasm).makeStringEncode(
    op, parseExpression(s[i]), parseExpression(s[i + 1]), start);
}

Expression* SExpressionWasmBuilder::makeStringConcat(Element& s) {
  return Builder(wasm).makeStringConcat(parseExpression(s[1]),
                                        parseExpression(s[2]));
}

Expression* SExpressionWasmBuilder::makeStringEq(Element& s, StringEqOp op) {
  return Builder(wasm).makeStringEq(
    op, parseExpression(s[1]), parseExpression(s[2]));
}

Expression* SExpressionWasmBuilder::makeStringAs(Element& s, StringAsOp op) {
  return Builder(wasm).makeStringAs(op, parseExpression(s[1]));
}

Expression* SExpressionWasmBuilder::makeStringWTF8Advance(Element& s) {
  return Builder(wasm).makeStringWTF8Advance(
    parseExpression(s[1]), parseExpression(s[2]), parseExpression(s[3]));
}

Expression* SExpressionWasmBuilder::makeStringWTF16Get(Element& s) {
  return Builder(wasm).makeStringWTF16Get(parseExpression(s[1]),
                                          parseExpression(s[2]));
}

Expression* SExpressionWasmBuilder::makeStringIterNext(Element& s) {
  return Builder(wasm).makeStringIterNext(parseExpression(s[1]));
}

Expression* SExpressionWasmBuilder::makeStringIterMove(Element& s,
                                                       StringIterMoveOp op) {
  return Builder(wasm).makeStringIterMove(
    op, parseExpression(s[1]), parseExpression(s[2]));
}

Expression* SExpressionWasmBuilder::makeStringSliceWTF(Element& s,
                                                       StringSliceWTFOp op) {
  return Builder(wasm).makeStringSliceWTF(
    op, parseExpression(s[1]), parseExpression(s[2]), parseExpression(s[3]));
}

Expression* SExpressionWasmBuilder::makeStringSliceIter(Element& s) {
  return Builder(wasm).makeStringSliceIter(parseExpression(s[1]),
                                           parseExpression(s[2]));
}

// converts an s-expression string representing binary data into an output
// sequence of raw bytes this appends to data, which may already contain
// content.
void SExpressionWasmBuilder::stringToBinary(Element& s,
                                            std::string_view str,
                                            std::vector<char>& data) {
  auto originalSize = data.size();
  data.resize(originalSize + str.size());
  char* write = data.data() + originalSize;
  const char* end = str.data() + str.size();
  for (const char* input = str.data(); input < end;) {
    if (input[0] == '\\') {
      if (input + 1 >= end) {
        throw ParseException("Unterminated escape sequence", s.line, s.col);
      }
      if (input[1] == 't') {
        *write++ = '\t';
        input += 2;
        continue;
      } else if (input[1] == 'n') {
        *write++ = '\n';
        input += 2;
        continue;
      } else if (input[1] == 'r') {
        *write++ = '\r';
        input += 2;
        continue;
      } else if (input[1] == '"') {
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
      } else {
        if (input + 2 >= end) {
          throw ParseException("Unterminated escape sequence", s.line, s.col);
        }
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

Index SExpressionWasmBuilder::parseMemoryIndex(
  Element& s, Index i, std::unique_ptr<Memory>& memory) {
  if (i < s.size() && s[i]->isStr()) {
    if (s[i]->str() == "i64") {
      i++;
      memory->indexType = Type::i64;
    } else if (s[i]->str() == "i32") {
      i++;
      memory->indexType = Type::i32;
    }
  }
  return i;
}

Index SExpressionWasmBuilder::parseMemoryLimits(
  Element& s, Index i, std::unique_ptr<Memory>& memory) {
  i = parseMemoryIndex(s, i, memory);
  if (i == s.size()) {
    throw ParseException("missing memory limits", s.line, s.col);
  }
  auto initElem = s[i++];
  memory->initial = getAddress(initElem);
  if (!memory->is64()) {
    checkAddress(memory->initial, "excessive memory init", initElem);
  }
  if (i == s.size()) {
    memory->max = Memory::kUnlimitedSize;
  } else {
    auto maxElem = s[i++];
    memory->max = getAddress(maxElem);
    if (!memory->is64() && memory->max > Memory::kMaxSize32) {
      throw ParseException(
        "total memory must be <= 4GB", maxElem->line, maxElem->col);
    }
  }
  return i;
}

void SExpressionWasmBuilder::parseMemory(Element& s, bool preParseImport) {
  auto memory = make_unique<Memory>();
  memory->shared = false;
  Index i = 1;
  if (s[i]->dollared()) {
    memory->setExplicitName(s[i++]->str());
  } else {
    memory->name = Name::fromInt(memoryCounter++);
  }
  memoryNames.push_back(memory->name);

  i = parseMemoryIndex(s, i, memory);
  Name importModule, importBase;
  if (s[i]->isList()) {
    auto& inner = *s[i];
    if (elementStartsWith(inner, EXPORT)) {
      auto ex = make_unique<Export>();
      ex->name = inner[1]->str();
      ex->value = memory->name;
      ex->kind = ExternalKind::Memory;
      if (wasm.getExportOrNull(ex->name)) {
        throw ParseException("duplicate export", inner.line, inner.col);
      }
      wasm.addExport(ex.release());
      i++;
    } else if (elementStartsWith(inner, IMPORT)) {
      memory->module = inner[1]->str();
      memory->base = inner[2]->str();
      i++;
    } else if (elementStartsWith(inner, SHARED)) {
      memory->shared = true;
      parseMemoryLimits(inner, 1, memory);
      i++;
    } else {
      if (!(inner.size() > 0 ? inner[0]->str() != IMPORT : true)) {
        throw ParseException("bad import ending", inner.line, inner.col);
      }
      // (memory (data ..)) format
      auto j = parseMemoryIndex(inner, 1, memory);
      auto offset = allocator.alloc<Const>();
      if (memory->is64()) {
        offset->set(Literal(int64_t(0)));
      } else {
        offset->set(Literal(int32_t(0)));
      }
      auto seg = Builder::makeDataSegment(
        Name::fromInt(dataCounter++), memory->name, false, offset);
      parseInnerData(inner, j, seg);
      memory->initial = seg->data.size();
      wasm.addDataSegment(std::move(seg));
      wasm.addMemory(std::move(memory));
      return;
    }
  }
  if (!memory->shared) {
    i = parseMemoryLimits(s, i, memory);
  }

  // Parse memory initializers.
  while (i < s.size()) {
    Element& curr = *s[i];
    size_t j = 1;
    Address offsetValue;
    if (elementStartsWith(curr, DATA)) {
      offsetValue = 0;
    } else {
      auto offsetElem = curr[j++];
      offsetValue = getAddress(offsetElem);
      if (!memory->is64()) {
        checkAddress(offsetValue, "excessive memory offset", offsetElem);
      }
    }
    std::string_view input = curr[j]->str().str;
    auto* offset = allocator.alloc<Const>();
    if (memory->is64()) {
      offset->type = Type::i64;
      offset->value = Literal(offsetValue);
    } else {
      offset->type = Type::i32;
      offset->value = Literal(int32_t(offsetValue));
    }
    if (input.size()) {
      std::vector<char> data;
      stringToBinary(*curr[j], input, data);
      auto segment = Builder::makeDataSegment(Name::fromInt(dataCounter++),
                                              memory->name,
                                              false,
                                              offset,
                                              data.data(),
                                              data.size());
      segment->hasExplicitName = false;
      wasm.addDataSegment(std::move(segment));
    } else {
      auto segment = Builder::makeDataSegment(
        Name::fromInt(dataCounter++), memory->name, false, offset);
      segment->hasExplicitName = false;
      wasm.addDataSegment(std::move(segment));
    }
    i++;
  }
  wasm.addMemory(std::move(memory));
}

void SExpressionWasmBuilder::parseData(Element& s) {
  Index i = 1;
  Name name = Name::fromInt(dataCounter++);
  bool hasExplicitName = false;
  Name memory;
  bool isPassive = true;
  Expression* offset = nullptr;

  if (s[i]->isStr() && s[i]->dollared()) {
    name = s[i++]->str();
    hasExplicitName = true;
  }

  if (s[i]->isList()) {
    // Optional (memory <memoryidx>)
    if (elementStartsWith(s[i], MEMORY)) {
      auto& inner = *s[i++];
      memory = getMemoryName(*inner[1]);
    } else {
      memory = getMemoryNameAtIdx(0);
    }
    // Offset expression (offset (<expr>)) | (<expr>)
    auto& inner = *s[i++];
    if (elementStartsWith(inner, OFFSET)) {
      offset = parseExpression(inner[1]);
    } else {
      offset = parseExpression(inner);
    }
    isPassive = false;
  }

  auto seg = Builder::makeDataSegment(name, memory, isPassive, offset);
  seg->hasExplicitName = hasExplicitName;
  parseInnerData(s, i, seg);
  wasm.addDataSegment(std::move(seg));
}

void SExpressionWasmBuilder::parseInnerData(Element& s,
                                            Index i,
                                            std::unique_ptr<DataSegment>& seg) {
  std::vector<char> data;
  while (i < s.size()) {
    std::string_view input = s[i++]->str().str;
    stringToBinary(s, input, data);
  }
  seg->data.resize(data.size());
  std::copy_n(data.data(), data.size(), seg->data.begin());
}

void SExpressionWasmBuilder::parseExport(Element& s) {
  std::unique_ptr<Export> ex = make_unique<Export>();
  ex->name = s[1]->str();
  if (s[2]->isList()) {
    auto& inner = *s[2];
    if (elementStartsWith(inner, FUNC)) {
      ex->kind = ExternalKind::Function;
      ex->value = getFunctionName(*inner[1]);
    } else if (elementStartsWith(inner, MEMORY)) {
      ex->kind = ExternalKind::Memory;
      ex->value = inner[1]->str();
    } else if (elementStartsWith(inner, TABLE)) {
      ex->kind = ExternalKind::Table;
      ex->value = getTableName(*inner[1]);
    } else if (elementStartsWith(inner, GLOBAL)) {
      ex->kind = ExternalKind::Global;
      ex->value = getGlobalName(*inner[1]);
    } else if (inner[0]->str() == TAG) {
      ex->kind = ExternalKind::Tag;
      ex->value = getTagName(*inner[1]);
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
    } else if (elementStartsWith(*s[3], TABLE)) {
      kind = ExternalKind::Table;
    } else if (elementStartsWith(*s[3], GLOBAL)) {
      kind = ExternalKind::Global;
    } else if ((*s[3])[0]->str() == TAG) {
      kind = ExternalKind::Tag;
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
  bool hasExplicitName = name.is();
  if (!hasExplicitName) {
    if (kind == ExternalKind::Function) {
      name = Name("fimport$" + std::to_string(functionCounter++));
      functionNames.push_back(name);
    } else if (kind == ExternalKind::Global) {
      // Handled in `parseGlobal`.
    } else if (kind == ExternalKind::Memory) {
      name = Name("mimport$" + std::to_string(memoryCounter++));
    } else if (kind == ExternalKind::Table) {
      name = Name("timport$" + std::to_string(tableCounter++));
    } else if (kind == ExternalKind::Tag) {
      name = Name("eimport$" + std::to_string(tagCounter++));
      tagNames.push_back(name);
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

    j = parseTypeUse(inner, j, func->type);
    func->setName(name, hasExplicitName);
    func->module = module;
    func->base = base;
    functionTypes[name] = func->type;
    wasm.addFunction(func.release());
  } else if (kind == ExternalKind::Global) {
    parseGlobal(inner, true);
    j++;
    auto& global = wasm.globals.back();
    global->module = module;
    global->base = base;
  } else if (kind == ExternalKind::Table) {
    auto table = make_unique<Table>();
    table->setName(name, hasExplicitName);
    table->module = module;
    table->base = base;
    tableNames.push_back(name);

    if (j < inner.size() - 1) {
      auto initElem = inner[j++];
      table->initial = getAddress(initElem);
      checkAddress(table->initial, "excessive table init size", initElem);
    }
    if (j < inner.size() - 1) {
      auto maxElem = inner[j++];
      table->max = getAddress(maxElem);
      checkAddress(table->max, "excessive table max size", maxElem);
    } else {
      table->max = Table::kUnlimitedSize;
    }

    wasm.addTable(std::move(table));

    j++; // funcref
    // ends with the table element type
  } else if (kind == ExternalKind::Memory) {
    auto memory = make_unique<Memory>();
    memory->setName(name, hasExplicitName);
    memory->module = module;
    memory->base = base;
    memoryNames.push_back(name);

    if (inner[j]->isList()) {
      auto& limits = *inner[j];
      if (!elementStartsWith(limits, SHARED)) {
        throw ParseException(
          "bad memory limit declaration", inner[j]->line, inner[j]->col);
      }
      memory->shared = true;
      j = parseMemoryLimits(limits, 1, memory);
    } else {
      j = parseMemoryLimits(inner, j, memory);
    }

    wasm.addMemory(std::move(memory));
  } else if (kind == ExternalKind::Tag) {
    auto tag = make_unique<Tag>();
    HeapType tagType;
    j = parseTypeUse(inner, j, tagType);
    tag->sig = tagType.getSignature();
    tag->setName(name, hasExplicitName);
    tag->module = module;
    tag->base = base;
    wasm.addTag(tag.release());
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
    global->setExplicitName(s[i++]->str());
  } else if (preParseImport) {
    global->name = Name("gimport$" + std::to_string(globalCounter));
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
  global->type = type;
  if (i < s.size()) {
    global->init = parseExpression(s[i++]);
  } else if (!preParseImport) {
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
  std::unique_ptr<Table> table = make_unique<Table>();
  Index i = 1;
  if (s[i]->dollared()) {
    table->setExplicitName(s[i++]->str());
  } else {
    table->name = Name::fromInt(tableCounter++);
  }
  tableNames.push_back(table->name);

  Name importModule, importBase;
  if (s[i]->isList()) {
    auto& inner = *s[i];
    if (elementStartsWith(inner, EXPORT)) {
      auto ex = make_unique<Export>();
      ex->name = inner[1]->str();
      ex->value = table->name;
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
      table->module = inner[1]->str();
      table->base = inner[2]->str();
      i++;
    } else if (!elementStartsWith(inner, REF)) {
      throw ParseException("invalid table", inner.line, inner.col);
    }
  }

  bool hasExplicitLimit = false;

  if (s[i]->isStr() && String::isNumber(s[i]->toString())) {
    table->initial = parseIndex(*s[i++]);
    hasExplicitLimit = true;
  }
  if (s[i]->isStr() && String::isNumber(s[i]->toString())) {
    table->max = parseIndex(*s[i++]);
  }

  table->type = elementToType(*s[i++]);
  if (!table->type.isRef()) {
    throw ParseException("Only reference types are valid for tables");
  }

  if (i < s.size() && s[i]->isList()) {
    if (hasExplicitLimit) {
      throw ParseException(
        "Table cannot have both explicit limits and an inline (elem ...)");
    }
    // (table type (elem ..))
    parseElem(*s[i], table.get());
    auto it = std::find_if(wasm.elementSegments.begin(),
                           wasm.elementSegments.end(),
                           [&](std::unique_ptr<ElementSegment>& segment) {
                             return segment->table == table->name;
                           });
    if (it != wasm.elementSegments.end()) {
      table->initial = table->max = it->get()->data.size();
    } else {
      table->initial = table->max = 0;
    }
  }

  wasm.addTable(std::move(table));
}

// parses an elem segment
// elem  ::= (elem (table tableidx)? (offset (expr)) reftype vec(item (expr)))
//         | (elem reftype vec(item (expr)))
//         | (elem declare reftype vec(item (expr)))
//
// abbreviation:
//   (offset (expr)) ≡ (expr)
//     (item (expr)) ≡ (expr)
//                 ϵ ≡ (table 0)
//
//        funcref vec(ref.func) ≡ func vec(funcidx)
//   (elem (expr) vec(funcidx)) ≡ (elem (table 0) (offset (expr)) func
//                                vec(funcidx))
//
void SExpressionWasmBuilder::parseElem(Element& s, Table* table) {
  Index i = 1;
  Name name = Name::fromInt(elemCounter++);
  bool hasExplicitName = false;
  bool isPassive = true;
  bool usesExpressions = false;

  if (table) {
    Expression* offset = allocator.alloc<Const>()->set(Literal(int32_t(0)));
    auto segment = std::make_unique<ElementSegment>(table->name, offset);
    segment->setName(name, hasExplicitName);
    parseElemFinish(s, segment, i, s[i]->isList());
    return;
  }

  if (s[i]->isStr() && s[i]->dollared()) {
    name = s[i++]->str();
    hasExplicitName = true;
  }
  if (s[i]->isStr() && s[i]->str() == DECLARE) {
    // We don't store declared segments in the IR
    return;
  }

  auto segment = std::make_unique<ElementSegment>();
  segment->setName(name, hasExplicitName);

  if (s[i]->isList() && !elementStartsWith(s[i], REF)) {
    // Optional (table <tableidx>)
    if (elementStartsWith(s[i], TABLE)) {
      auto& inner = *s[i++];
      segment->table = getTableName(*inner[1]);
    }

    // Offset expression (offset (<expr>)) | (<expr>)
    auto& inner = *s[i++];
    if (elementStartsWith(inner, OFFSET)) {
      if (inner.size() > 2) {
        throw ParseException(
          "Invalid offset for an element segment.", s.line, s.col);
      }
      segment->offset = parseExpression(inner[1]);
    } else {
      segment->offset = parseExpression(inner);
    }
    isPassive = false;
  }

  if (i < s.size()) {
    if (s[i]->isStr() && s[i]->dollared()) {
      usesExpressions = false;
    } else if (s[i]->isStr() && s[i]->str() == FUNC) {
      usesExpressions = false;
      i += 1;
    } else {
      segment->type = elementToType(*s[i]);
      usesExpressions = true;
      i += 1;

      if (!segment->type.isFunction()) {
        throw ParseException(
          "Invalid type for an element segment.", s.line, s.col);
      }
    }
  }

  if (!isPassive && segment->table.isNull()) {
    if (wasm.tables.empty()) {
      throw ParseException("active element without table", s.line, s.col);
    }
    table = wasm.tables.front().get();
    segment->table = table->name;
  }

  // We may be post-MVP also due to type reasons or otherwise, as detected by
  // the utility function for Binaryen IR.
  usesExpressions =
    usesExpressions || TableUtils::usesExpressions(segment.get(), &wasm);

  parseElemFinish(s, segment, i, usesExpressions);
}

ElementSegment* SExpressionWasmBuilder::parseElemFinish(
  Element& s,
  std::unique_ptr<ElementSegment>& segment,
  Index i,
  bool usesExpressions) {

  for (; i < s.size(); i++) {
    if (!s[i]->isList()) {
      // An MVP-style declaration: just a function name.
      auto func = getFunctionName(*s[i]);
      segment->data.push_back(
        Builder(wasm).makeRefFunc(func, functionTypes[func]));
      continue;
    }
    if (!usesExpressions) {
      throw ParseException("expected an MVP-style $funcname in elem.");
    }
    auto& inner = *s[i];
    if (elementStartsWith(inner, ITEM)) {
      if (inner[1]->isList()) {
        // (item (ref.func $f))
        segment->data.push_back(parseExpression(inner[1]));
      } else {
        // (item ref.func $f)
        inner.list().removeAt(0);
        segment->data.push_back(parseExpression(inner));
      }
    } else {
      segment->data.push_back(parseExpression(inner));
    }
  }
  return wasm.addElementSegment(std::move(segment));
}

HeapType SExpressionWasmBuilder::parseHeapType(Element& s) {
  if (s.isStr()) {
    // It's a string.
    if (s.dollared()) {
      auto it = typeIndices.find(s.toString());
      if (it == typeIndices.end()) {
        throw ParseException("unknown dollared function type", s.line, s.col);
      }
      return types[it->second];
    } else {
      // It may be a numerical index, or it may be a built-in type name like
      // "i31".
      auto str = s.toString();
      if (String::isNumber(str)) {
        size_t offset = parseIndex(s);
        if (offset >= types.size()) {
          throw ParseException("unknown indexed function type", s.line, s.col);
        }
        return types[offset];
      }
      return stringToHeapType(s.str(), /* prefix = */ false);
    }
  }
  throw ParseException("invalid heap type", s.line, s.col);
}

void SExpressionWasmBuilder::parseTag(Element& s, bool preParseImport) {
  auto tag = make_unique<Tag>();
  size_t i = 1;

  // Parse name
  if (s[i]->isStr() && s[i]->dollared()) {
    auto& inner = *s[i++];
    tag->setExplicitName(inner.str());
    if (wasm.getTagOrNull(tag->name)) {
      throw ParseException("duplicate tag", inner.line, inner.col);
    }
  } else {
    tag->name = Name::fromInt(tagCounter);
    assert(!wasm.getTagOrNull(tag->name));
  }
  tagCounter++;
  tagNames.push_back(tag->name);

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
    tag->module = importElem[1]->str();
    tag->base = importElem[2]->str();
  }

  // Parse export, if any
  if (i < s.size() && elementStartsWith(*s[i], EXPORT)) {
    auto& exportElem = *s[i++];
    if (tag->module.is()) {
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
    ex->value = tag->name;
    ex->kind = ExternalKind::Tag;
    wasm.addExport(ex.release());
  }

  // Parse typeuse
  HeapType tagType;
  i = parseTypeUse(s, i, tagType);
  tag->sig = tagType.getSignature();

  // If there are more elements, they are invalid
  if (i < s.size()) {
    throw ParseException("invalid element", s[i]->line, s[i]->col);
  }

  wasm.addTag(tag.release());
}

void SExpressionWasmBuilder::validateHeapTypeUsingChild(Expression* child,
                                                        HeapType heapType,
                                                        Element& s) {
  if (child->type == Type::unreachable) {
    return;
  }
  if (!child->type.isRef() ||
      !HeapType::isSubType(child->type.getHeapType(), heapType)) {
    throw ParseException("bad heap type: expected " + heapType.toString() +
                           " but found " + child->type.toString(),
                         s.line,
                         s.col);
  }
}

} // namespace wasm
