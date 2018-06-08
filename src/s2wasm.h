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
// .s to WebAssembly translator.
//

#ifndef wasm_s2wasm_h
#define wasm_s2wasm_h

#include <limits.h>

#include "wasm.h"
#include "parsing.h"
#include "pass.h"
#include "asm_v_wasm.h"
#include "wasm-builder.h"
#include "wasm-linker.h"

namespace wasm {

//
// S2WasmBuilder - parses a .s file into WebAssembly
//

class S2WasmBuilder {
  const char* inputStart;
  const char* s;
  bool debug;
  Module* wasm;
  MixedArena* allocator;
  LinkerObject* linkerObj;
  std::unique_ptr<LinkerObject::SymbolInfo> symbolInfo;
  std::unordered_map<uint32_t, uint32_t> fileIndexMap;

 public:
  S2WasmBuilder(const char* input, bool debug)
      : inputStart(input),
        s(input),
        debug(debug),
        wasm(nullptr),
        allocator(nullptr),
        linkerObj(nullptr)
        {}

  void build(LinkerObject *obj) {
    // If getSymbolInfo has not already been called, populate the symbol
    // info now.
    if (!symbolInfo) symbolInfo.reset(getSymbolInfo());
    linkerObj = obj;
    wasm = &obj->wasm;
    allocator = &wasm->allocator;

    s = inputStart;
    process();
  }

  // getSymbolInfo scans the .s file to determine what symbols it defines
  // and references.
  LinkerObject::SymbolInfo* getSymbolInfo() {
    if (!symbolInfo) {
      symbolInfo = make_unique<LinkerObject::SymbolInfo>();
      scan(symbolInfo.get());
    }
    return symbolInfo.get();
  }

 private:
  // utilities

  void skipWhitespace() {
    while (1) {
      while (*s && isspace(*s)) s++;
      if (*s != '#') break;
      while (*s != '\n') s++;
    }
  }

  void skipToEOL() {
    s = strchr(s, '\n');
    assert(s);
  }

  bool skipComma() {
    skipWhitespace();
    if (*s != ',') return false;
    s++;
    skipWhitespace();
    return true;
  }

  bool skipEqual() {
    skipWhitespace();
    if (*s != '=') return false;
    s++;
    skipWhitespace();
    return true;
  }

  #define abort_on(why) { \
    dump(why ":");        \
    abort();              \
  }

  bool peek(const char *pattern) {
    return strncmp(s, pattern, strlen(pattern)) == 0;
  }

  // match and skip the pattern, if matched
  bool match(const char *pattern) {
    size_t size = strlen(pattern);
    if (strncmp(s, pattern, size) == 0) {
      s += size;
      skipWhitespace();
      return true;
    }
    return false;
  }

  void mustMatch(const char *pattern) {
    bool matched = match(pattern);
    if (!matched) {
      std::cerr << "<< " << pattern << " >>\n";
      abort_on("bad mustMatch");
    }
  }

  void dump(const char *text) {
    std::cerr << "[[" << text << "]]:\n==========\n";
    for (size_t i = 0; i < 60; i++) {
      if (!s[i]) break;
      std::cerr << s[i];
    }
    std::cerr << "\n==========\n";
  }

  void unget(Name str) {
    s -= strlen(str.str);
  }

  Name getStr() {
    std::string str; // TODO: optimize this and the other get* methods
    while (*s && !isspace(*s)) {
      str += *s;
      s++;
    }
    return cashew::IString(str.c_str(), false);
  }

  void skipToSep() {
    while (*s && !isspace(*s) && *s != ',' && *s != '(' && *s != ')' && *s != ':' && *s != '+' && *s != '-') {
      s++;
    }
  }

  Name getStrToSep() {
    std::string str;
    while (*s && !isspace(*s) && *s != ',' && *s != '(' && *s != ')' && *s != ':' && *s != '+' && *s != '-' && *s != '=') {
      str += *s;
      s++;
    }
    return cashew::IString(str.c_str(), false);
  }

  Name getStrToColon() {
    std::string str;
    while (*s && !isspace(*s) && *s != ':') {
      str += *s;
      s++;
    }
    return cashew::IString(str.c_str(), false);
  }

  // get an int
  int32_t getInt() {
    const char* loc = s;
    uint32_t value = 0;
    bool neg = false;
    if (*loc == '-') {
      neg = true;
      loc++;
    }
    while (isdigit(*loc)) {
      uint32_t digit = *loc - '0';
      if (value > std::numeric_limits<uint32_t>::max() / 10) {
        abort_on("uint32_t overflow");
      }
      value *= 10;
      if (value > std::numeric_limits<uint32_t>::max() - digit) {
        abort_on("uint32_t overflow");
      }
      value += digit;
      loc++;
    }
    if (neg) {
      uint32_t positive_int_min =
          (uint32_t) - (1 + std::numeric_limits<int32_t>::min()) + (uint32_t)1;
      if (value > positive_int_min) {
        abort_on("negative int32_t overflow");
      }
      s = loc;
      return -value;
    }
    s = loc;
    return value;
  }

  // get an int from an arbitrary string, with our full error handling
  int32_t getInt(const char *from) {
    const char *before = s;
    s = from;
    auto ret = getInt();
    s = before;
    return ret;
  }

  // gets a constant, which may be a relocation for later.
  // returns whether this is a relocation
  // TODO: Clean up this and the way relocs are created from parsed objects
  LinkerObject::Relocation* getRelocatableConst(uint32_t* target) {
    if (isdigit(*s) || *s == '-') {
      int32_t val = getInt();
      memcpy(target, &val, sizeof(val));
      return nullptr;
    }

    // a global constant, we need to fix it up later
    Name name = getStrToSep();
    LinkerObject::Relocation::Kind kind = isFunctionName(name) ?
        LinkerObject::Relocation::kFunction :
        LinkerObject::Relocation::kData;
    int offset = 0;
    if (*s == '+') {
      s++;
      offset = getInt();
    } else if (*s == '-') {
      s++;
      offset = -getInt();
    }
    return new LinkerObject::Relocation(
        kind, target, fixEmLongjmp(cleanFunction(name)), offset);
  }

  Expression* relocationToGetGlobal(LinkerObject::Relocation* relocation) {
    if (!relocation) {
      return nullptr;
    }

    auto name = relocation->symbol;
    auto g = allocator->alloc<GetGlobal>();
    g->name = name;
    g->type = i32;

    // Optimization: store any nonnegative addends in their natural place.
    // Only do this for positive addends because load/store offsets cannot be
    // negative.
    if (relocation->addend >= 0) {
      *relocation->data = relocation->addend;
      return g;
    }

    auto c = allocator->alloc<Const>();
    c->type = i32;
    c->value = Literal(relocation->addend);

    auto add = allocator->alloc<Binary>();
    add->type = i32;
    add->op = AddInt32;
    add->left = c;
    add->right = g;
    return add;
  }
  Expression* getRelocatableExpression(uint32_t* target) {
    auto relocation = std::unique_ptr<LinkerObject::Relocation>(getRelocatableConst(target));
    if (!relocation) {
      return nullptr;
    }
    if (linkerObj->isObjectImplemented(relocation->symbol)) {
      linkerObj->addRelocation(relocation.release());
      return nullptr;
    }
    return relocationToGetGlobal(relocation.get());
  }

  int64_t getInt64() {
    const char* loc = s;
    uint64_t value = 0;
    bool neg = false;
    if (*loc == '-') {
      neg = true;
      loc++;
    }
    while (isdigit(*loc)) {
      uint64_t digit = *loc - '0';
      if (value > std::numeric_limits<uint64_t>::max() / 10) {
        abort_on("uint64_t overflow");
      }
      value *= 10;
      if (value > std::numeric_limits<uint64_t>::max() - digit) {
        abort_on("uint64_t overflow");
      }
      value += digit;
      loc++;
    }
    if (neg) {
      uint64_t positive_int_min =
          (uint64_t) - (1 + std::numeric_limits<int64_t>::min()) + (uint64_t)1;
      if (value > positive_int_min) {
        abort_on("negative int64_t overflow");
      }
      s = loc;
      return -value;
    }
    s = loc;
    return value;
  }

  Name getSeparated(char separator) {
    skipWhitespace();
    std::string str;
    while (*s && *s != separator && *s != '\n') {
      str += *s;
      s++;
    }
    skipWhitespace();
    return cashew::IString(str.c_str(), false);
  }
  Name getCommaSeparated() { return getSeparated(','); }
  Name getAtSeparated() { return getSeparated('@'); }

  Name getAssign() {
    skipWhitespace();
    if (*s != '$') return Name();
    const char *before = s;
    s++;
    std::string str;
    while (*s && *s != '=' && *s != '\n' && *s != ',') {
      str += *s;
      s++;
    }
    if (*s != '=') { // not an assign
      s = before;
      return Name();
    }
    s++;
    skipComma();
    return cashew::IString(str.c_str(), false);
  }

  std::vector<char> getQuoted() {
    assert(*s == '"');
    s++;
    std::vector<char> str;
    while (*s && *s != '\"') {
      if (s[0] == '\\') {
        switch (s[1]) {
          case 'n': str.push_back('\n'); s += 2; continue;
          case 'r': str.push_back('\r'); s += 2; continue;
          case 't': str.push_back('\t'); s += 2; continue;
          case 'f': str.push_back('\f'); s += 2; continue;
          case 'b': str.push_back('\b'); s += 2; continue;
          case '\\': str.push_back('\\'); s += 2; continue;
          case '"': str.push_back('"'); s += 2; continue;
          default: {
            if (isdigit(s[1])) {
              int code = (s[1] - '0')*8*8 + (s[2] - '0')*8 + (s[3] - '0');
              str.push_back(char(code));
              s += 4;
              continue;
            } else abort_on("getQuoted-escape");
          }
        }
      }
      str.push_back(*s);
      s++;
    }
    s++;
    skipWhitespace();
    return str;
  }

  Type tryGetType() {
    if (match("i32")) return i32;
    if (match("i64")) return i64;
    if (match("f32")) return f32;
    if (match("f64")) return f64;
    return none;
  }

  Type tryGetTypeWithoutNewline() {
    const char* saved = s;
    Type type = tryGetType();
    if (type != none && strchr(saved, '\n') > s) {
      s = saved;
      type = none;
    }
    return type;
  }

  Type getType() {
    Type t = tryGetType();
    if (t != none) {
      return t;
    }
    abort_on("getType");
  }

  // The LLVM backend emits function names as name@FUNCTION.
  bool isFunctionName(Name name) {
    return !!strstr(name.str, "@FUNCTION");
  }

  // Drop the @ and after it.
  Name cleanFunction(Name name) {
    if (!strchr(name.str, '@')) return name;
    char *temp = strdup(name.str);
    *strchr(temp, '@') = 0;
    Name ret = cashew::IString(temp, false);
    free(temp);
    return ret;
  }

  // processors

  void scan(LinkerObject::SymbolInfo* info) {
    s = inputStart;
    while (*s) {
      skipWhitespace();

      // add function definitions and aliases
      if (match(".type")) {
        Name name = getCommaSeparated();
        skipComma();
        if (!match("@function")) continue;
        if (match(".hidden")) mustMatch(name.str);
        if (match(".set")) { // function aliases
          // syntax: .set alias, original@FUNCTION
          Name name = getCommaSeparated();
          skipComma();
          Name alias = getAtSeparated();
          mustMatch("@FUNCTION");
          auto ret = info->aliasedSymbols.insert({name, LinkerObject::SymbolAlias(alias, LinkerObject::Relocation::kFunction, 0)});
          if (!ret.second) std::cerr << "Unsupported data alias redefinition: " << name << ", skipping...\n";
          continue;
        }

        mustMatch(name.str);
        if (match(":")) {
          info->implementedFunctions.insert(name);
        } else {
          abort_on("unknown directive");
        }
      } else if (match(".import_global")) {
        Name name = getStr();
        info->importedObjects.insert(name);
        s = strchr(s, '\n');
      } else if (match(".set")) { // data aliases
        // syntax: .set alias, original
        Name lhs = getCommaSeparated();
        skipComma();
        Name rhs = getStrToSep();
        assert(!isFunctionName(rhs));
        Offset offset = 0;
        if (*s == '+') {
          s++;
          offset = getInt();
        }

        // check if the rhs is already an alias
        const auto alias = symbolInfo->aliasedSymbols.find(rhs);
        if (alias != symbolInfo->aliasedSymbols.end() && alias->second.kind == LinkerObject::Relocation::kData) {
          offset += alias->second.offset;
          rhs = alias->second.symbol;
        }

        // add the new alias
        auto ret = symbolInfo->aliasedSymbols.insert({lhs, LinkerObject::SymbolAlias(rhs,
          LinkerObject::Relocation::kData, offset)});
        if (!ret.second) std::cerr << "Unsupported function alias redefinition: " << lhs << ", skipping...\n";
      } else {
        s = strchr(s, '\n');
        if (!s)
          break;
      }
    }
  }

  void process() {
    while (*s) {
      skipWhitespace();
      if (debug) dump("process");
      if (!*s) break;
      if (*s != '.') skipObjectAlias(false);
      s++;
      if (match("text")) parseText();
      else if (match("type")) parseType();
      else if (match("weak") || match("hidden") || match("protected") || match("internal")) getStr(); // contents are in the content that follows
      else if (match("imports")) skipImports();
      else if (match("data")) {}
      else if (match("ident")) skipToEOL();
      else if (match("section")) parseToplevelSection();
      else if (match("file")) parseFile();
      else if (match("align") || match("p2align")) skipToEOL();
      else if (match("import_global")) {
        skipToEOL();
        skipWhitespace();
        if (match(".size")) {
          skipToEOL();
        }
      }
      else if (match("globl")) parseGlobl();
      else if (match("functype")) parseFuncType();
      else skipObjectAlias(true);
    }
  }

  void skipObjectAlias(bool prefix) {
    if (debug) dump("object_alias");
    mustMatch("set");

    Name lhs = getCommaSeparated();
    WASM_UNUSED(lhs);
    skipComma();
    Name rhs = getStr();
    WASM_UNUSED(rhs);
    skipWhitespace();

    // if no size attribute (e.g. weak symbol), skip
    if (!match(".size")) return;

    mustMatch(lhs.str);
    mustMatch(",");
    Name size = getStr();
    WASM_UNUSED(size);
    skipWhitespace();
  }

  void parseToplevelSection() {
    auto section = getCommaSeparated();
    // Skipping .debug_ sections
    if (!strncmp(section.c_str(), ".debug_", strlen(".debug_"))) {
      const char *next = strstr(s, ".section");
      s = !next ? s + strlen(s) : next;
      return;
    }
    // Initializers are anything in a section whose name begins with .init_array
    if (!strncmp(section.c_str(), ".init_array", strlen(".init_array") - 1)) {
      parseInitializer();
      return;
    }
    s = strchr(s, '\n');
  }

  void parseInitializer() {
    // Ignore the rest of the .section line
    skipToEOL();
    skipWhitespace();
    // The section may start with .p2align
    if (match(".p2align")) {
      skipToEOL();
      skipWhitespace();
    }
    mustMatch(".int32");
    do {
      linkerObj->addInitializerFunction(cleanFunction(getStr()));
      skipWhitespace();
    } while (match(".int32"));
  }

  void parseText() {
    while (*s) {
      skipWhitespace();
      if (!*s) break;
      if (*s != '.') break;
      s++;
      if (parseVersionMin());
      else if (match("file")) parseFile();
      else if (match("globl")) parseGlobl();
      else if (match("type")) parseType();
      else {
        s--;
        break;
      }
    }
  }

  void parseFile() {
    if (debug) dump("file");
    size_t fileId = 0;
    if (*s != '"') {
      fileId = getInt();
      skipWhitespace();
    }
    auto filename = getQuoted();
    uint32_t index = wasm->debugInfoFileNames.size();
    wasm->debugInfoFileNames.push_back(std::string(filename.begin(), filename.end()));
    fileIndexMap[fileId] = index;
  }

  void parseGlobl() {
    linkerObj->addGlobal(getStr());
    skipWhitespace();
  }

  void parseFuncType() {
    auto decl = make_unique<FunctionType>();
    Name name = getCommaSeparated();
    skipComma();
    if(match("void")) {
      decl->result = none;
    } else {
      decl->result = getType();
    }
    while (*s && skipComma()) decl->params.push_back(getType());
    std::string sig = getSig(decl.get());
    decl->name = "FUNCSIG$" + sig;

    FunctionType *ty = wasm->getFunctionTypeOrNull(decl->name);
    if (!ty) {
      // The wasm module takes ownership of the FunctionType if we insert it.
      // Otherwise it's already in the module and ours is freed.
      ty = decl.release();
      wasm->addFunctionType(ty);
    }
    linkerObj->addExternType(name, ty);
  }

  bool parseVersionMin() {
    if (match("watchos_version_min") || match("tvos_version_min") || match("ios_version_min") || match("macosx_version_min")) {
      s = strchr(s, '\n');
      skipWhitespace();
      return true;
    } else
      return false;
  }

  void parseFunction() {
    if (debug) dump("func");
    if (match(".set")) { // alias
      // syntax: .set alias, original@FUNCTION
      getCommaSeparated();
      skipComma();
      getAtSeparated();
      mustMatch("@FUNCTION");
      return;
    }

    Name name = getStrToSep();
    mustMatch(":");

    Function::DebugLocation debugLocation = { 0, 0, 0 };
    bool useDebugLocation = false;
    auto recordLoc = [&]() {
      if (debug) dump("loc");
      size_t fileId = getInt();
      skipWhitespace();
      uint32_t row = getInt();
      skipWhitespace();
      uint32_t column = getInt();
      auto iter = fileIndexMap.find(fileId);
      if (iter == fileIndexMap.end()) {
        abort_on("idx");
      }
      useDebugLocation = true;
      debugLocation = { iter->second, row, column };
      s = strchr(s, '\n');
    };
    auto recordLabel = [&]() {
      if (debug) dump("label");
      Name label = getStrToSep();
      // TODO: track and create map of labels and their ranges for our AST
      WASM_UNUSED(label);
      s = strchr(s, '\n');
    };

    unsigned nextId = 0;
    auto getNextId = [&nextId]() {
      return cashew::IString(std::to_string(nextId++).c_str(), false);
    };
    wasm::Builder builder(*wasm);
    std::vector<NameType> params;
    Type resultType = none;
    std::vector<NameType> vars;

    std::map<Name, Type> localTypes;
    // params and result
    while (1) {
      if (match(".param")) {
        while (1) {
          Name name = getNextId();
          Type type = getType();
          params.emplace_back(name, type);
          localTypes[name] = type;
          skipWhitespace();
          if (!match(",")) break;
        }
      } else if (match(".result")) {
        resultType = getType();
      } else if (match(".indidx")) {
        int64_t indirectIndex = getInt64();
        skipWhitespace();
        if (indirectIndex < 0) {
          abort_on("indidx");
        }
        linkerObj->addIndirectIndex(name, indirectIndex);
      } else if (match(".local")) {
        while (1) {
          Name name = getNextId();
          Type type = getType();
          vars.emplace_back(name, type);
          localTypes[name] = type;
          skipWhitespace();
          if (!match(",")) break;
        }
      } else if (match(".file")) {
        parseFile();
        skipWhitespace();
      } else if (match(".loc")) {
        recordLoc();
        skipWhitespace();
      } else if (peek(".Lfunc_begin")) {
        recordLabel();
        skipWhitespace();
      } else break;
    }
    Function* func = builder.makeFunction(name, std::move(params), resultType, std::move(vars));

    // parse body
    func->body = allocator->alloc<Block>();
    std::vector<Expression*> bstack;
    auto addToBlock = [&](Expression* curr) {
      if (useDebugLocation) {
        func->debugLocations[curr] = debugLocation;
      }
      Expression* last = bstack.back();
      if (last->is<Loop>()) {
        last = last->cast<Loop>()->body;
      }
      last->cast<Block>()->list.push_back(curr);
    };
    bstack.push_back(func->body);
    std::vector<Expression*> estack;
    auto push = [&](Expression* curr) {
      //std::cerr << "push " << curr << '\n';
      estack.push_back(curr);
    };
    auto pop = [&]() {
      assert(!estack.empty());
      Expression* ret = estack.back();
      assert(ret);
      estack.pop_back();
      //std::cerr << "pop " << ret << '\n';
      return ret;
    };
    auto getNumInputs = [&]() {
      int ret = 1;
      const char *t = s;
      while (*t != '\n') {
        if (*t == ',') ret++;
        t++;
      }
      return ret;
    };
    auto getInputs = [&](int num) {
      // we may have       $pop, $0, $pop, $1     etc., which are getlocals
      // interleaved with stack pops, and the stack pops must be done in
      // *reverse* order, i.e., that input should turn into
      //         lastpop, getlocal(0), firstpop, getlocal(1)
      std::vector<Expression*> inputs; // TODO: optimize (if .s format doesn't change)
      inputs.resize(num);
      for (int i = 0; i < num; i++) {
        if (match("$pop")) {
          skipToSep();
          inputs[i] = nullptr;
        } else if (*s == '$') {
          s++;
          auto curr = allocator->alloc<GetLocal>();
          curr->index = func->getLocalIndex(getStrToSep());
          curr->type = func->getLocalType(curr->index);
          inputs[i] = curr;
        } else {
          abort_on("bad input register");
        }
        if (*s == ')') s++; // tolerate 0(argument) syntax, where we started at the 'a'
        if (*s == ':') { // tolerate :attribute=value syntax (see getAttributes)
          s++;
          skipToSep();
        }
        if (i < num - 1) skipComma();
      }
      for (int i = num-1; i >= 0; i--) {
        if (inputs[i] == nullptr) inputs[i] = pop();
      }
      return inputs;
    };
    auto getInput = [&]() {
      return getInputs(1)[0];
    };
    auto setOutput = [&](Expression* curr, Name assign) {
      if (assign.isNull() || assign.str[0] == 'd') { // drop
        auto* add = curr;
        if (isConcreteType(curr->type)) {
          add = builder.makeDrop(curr);
        }
        addToBlock(add);
      } else if (assign.str[0] == 'p') { // push
        push(curr);
      } else { // set to a local
        auto set = allocator->alloc<SetLocal>();
        set->index = func->getLocalIndex(assign);
        set->value = curr;
        set->type = curr->type;
        set->setTee(false);
        addToBlock(set);
      }
    };
    auto getAttributes = [&](int num) {
      const char *before = s;
      std::vector<const char*> attributes; // TODO: optimize (if .s format doesn't change)
      attributes.resize(num);
      for (int i = 0; i < num; i++) {
        skipToSep();
        if (*s == ')') s++; // tolerate 0(argument) syntax, where we started at the 'a'
        if (*s == ':') {
          attributes[i] = s + 1;
        } else {
          attributes[i] = nullptr;
        }
        if (i < num - 1) skipComma();
      }
      s = before;
      return attributes;
    };
    //
    auto makeBinary = [&](BinaryOp op, Type type) {
      Name assign = getAssign();
      skipComma();
      auto curr = allocator->alloc<Binary>();
      curr->op = op;
      auto inputs = getInputs(2);
      curr->left = inputs[0];
      curr->right = inputs[1];
      curr->finalize();
      assert(curr->type == type);
      setOutput(curr, assign);
    };
    auto makeUnary = [&](UnaryOp op, Type type) {
      Name assign = getAssign();
      skipComma();
      auto curr = allocator->alloc<Unary>();
      curr->op = op;
      curr->value = getInput();
      curr->type = type;
      curr->finalize();
      setOutput(curr, assign);
    };
    auto makeHost = [&](HostOp op) {
      Name assign = getAssign();
      auto curr = allocator->alloc<Host>();
      curr->op = op;
      curr->finalize();
      setOutput(curr, assign);
    };
    auto makeHost1 = [&](HostOp op) {
      Name assign = getAssign();
      auto curr = allocator->alloc<Host>();
      curr->op = op;
      curr->operands.push_back(getInput());
      curr->finalize();
      setOutput(curr, assign);
    };
    auto useRelocationExpression = [&](Expression *expr, Expression *reloc) {
      if (!reloc) {
        return expr;
      }
      // Optimization: if the given expr is (i32.const 0), ignore it
      if (expr->_id == Expression::ConstId &&
          ((Const*)expr)->value.getInteger() == 0) {
        return reloc;
      }

      // Otherwise, need to add relocation expr to given expr
      auto add = allocator->alloc<Binary>();
      add->type = i32;
      add->op = AddInt32;
      add->left = expr;
      add->right = reloc;
      return (Expression*)add;
    };
    auto makeLoad = [&](Type type) {
      skipComma();
      auto curr = allocator->alloc<Load>();
      curr->isAtomic = false;
      curr->type = type;
      int32_t bytes = getInt() / CHAR_BIT;
      curr->bytes = bytes > 0 ? bytes : getTypeSize(type);
      curr->signed_ = match("_s");
      match("_u");
      Name assign = getAssign();
      auto relocation = getRelocatableExpression(&curr->offset.addr);
      mustMatch("(");
      auto attributes = getAttributes(1);
      curr->ptr = useRelocationExpression(getInput(), relocation);
      curr->align = curr->bytes;
      if (attributes[0]) {
        assert(strncmp(attributes[0], "p2align=", 8) == 0);
        curr->align = Address(1) << getInt(attributes[0] + 8);
      }
      setOutput(curr, assign);
    };
    auto makeStore = [&](Type type) {
      auto curr = allocator->alloc<Store>();
      curr->isAtomic = false;
      curr->valueType = type;
      s += strlen("store");
      if(!isspace(*s)) {
        curr->bytes = getInt() / CHAR_BIT;
      } else {
        curr->bytes = getTypeSize(type);
      }
      skipWhitespace();
      auto relocation = getRelocatableExpression(&curr->offset.addr);
      mustMatch("(");
      auto attributes = getAttributes(2);
      auto inputs = getInputs(2);
      curr->ptr = useRelocationExpression(inputs[0], relocation);
      curr->align = curr->bytes;
      if (attributes[0]) {
        assert(strncmp(attributes[0], "p2align=", 8) == 0);
        curr->align = Address(1) << getInt(attributes[0] + 8);
      }
      curr->value = inputs[1];
      curr->finalize();
      addToBlock(curr);
    };
    auto makeSelect = [&](Type type) {
      Name assign = getAssign();
      skipComma();
      auto curr = allocator->alloc<Select>();
      auto inputs = getInputs(3);
      curr->ifTrue = inputs[0];
      curr->ifFalse = inputs[1];
      curr->condition = inputs[2];
      assert(curr->condition->type == i32);
      curr->type = type;
      setOutput(curr, assign);
    };
    auto makeCall = [&](Type type) {
      if (match("_indirect")) {
        // indirect call
        Name assign = getAssign();
        int num = getNumInputs();
        auto inputs = getInputs(num);
        auto* target = *(inputs.end() - 1);
        std::vector<Expression*> operands(inputs.begin(), inputs.end() - 1);
        auto* funcType = ensureFunctionType(getSig(type, operands), wasm);
        assert(type == funcType->result);
        auto* indirect = builder.makeCallIndirect(funcType, target, std::move(operands));
        setOutput(indirect, assign);
      } else {
        // non-indirect call
        Name assign = getAssign();
        Name rawTarget = cleanFunction(getCommaSeparated());
        Call* curr = allocator->alloc<Call>();
        curr->type = type;
        skipWhitespace();
        if (*s == ',') {
          skipComma();
          int num = getNumInputs();
          for (Expression* input : getInputs(num)) {
            curr->operands.push_back(input);
          }
        }
        Name target = linkerObj->resolveAlias(rawTarget, LinkerObject::Relocation::kFunction);
        curr->target = target;
        if (!linkerObj->isFunctionImplemented(target)) {
          linkerObj->addUndefinedFunctionCall(curr);
        }
        setOutput(curr, assign);
      }
    };
    #define BINARY_INT_OR_FLOAT(op) (type == i32 ? BinaryOp::op##Int32 : (type == i64 ? BinaryOp::op##Int64 : (type == f32 ? BinaryOp::op##Float32 : BinaryOp::op##Float64)))
    #define BINARY_INT(op) (type == i32 ? BinaryOp::op##Int32 : BinaryOp::op##Int64)
    #define BINARY_FLOAT(op) (type == f32 ? BinaryOp::op##Float32 : BinaryOp::op##Float64)
    auto handleTyped = [&](Type type) {
      switch (*s) {
        case 'a': {
          if (match("add")) makeBinary(BINARY_INT_OR_FLOAT(Add), type);
          else if (match("and")) makeBinary(BINARY_INT(And), type);
          else if (match("abs")) makeUnary(type == f32 ? UnaryOp::AbsFloat32 : UnaryOp::AbsFloat64, type);
          else abort_on("type.a");
          break;
        }
        case 'c': {
          if (match("const")) {
            Name assign = getAssign();
            if (type == i32) {
              // may be a relocation
              auto curr = allocator->alloc<Const>();
              curr->type = curr->value.type = i32;
              auto relocation = getRelocatableExpression((uint32_t*)curr->value.geti32Ptr());
              auto expr = useRelocationExpression(curr, relocation);
              setOutput(expr, assign);
            } else {
              cashew::IString str = getStr();
              setOutput(parseConst(str, type, *allocator), assign);
            }
          }
          else if (match("call")) makeCall(type);
          else if (match("convert_s/i32")) makeUnary(type == f32 ? UnaryOp::ConvertSInt32ToFloat32 : UnaryOp::ConvertSInt32ToFloat64, type);
          else if (match("convert_u/i32")) makeUnary(type == f32 ? UnaryOp::ConvertUInt32ToFloat32 : UnaryOp::ConvertUInt32ToFloat64, type);
          else if (match("convert_s/i64")) makeUnary(type == f32 ? UnaryOp::ConvertSInt64ToFloat32 : UnaryOp::ConvertSInt64ToFloat64, type);
          else if (match("convert_u/i64")) makeUnary(type == f32 ? UnaryOp::ConvertUInt64ToFloat32 : UnaryOp::ConvertUInt64ToFloat64, type);
          else if (match("clz")) makeUnary(type == i32 ? UnaryOp::ClzInt32 : UnaryOp::ClzInt64, type);
          else if (match("ctz")) makeUnary(type == i32 ? UnaryOp::CtzInt32 : UnaryOp::CtzInt64, type);
          else if (match("copysign")) makeBinary(BINARY_FLOAT(CopySign), type);
          else if (match("ceil")) makeUnary(type == f32 ? UnaryOp::CeilFloat32 : UnaryOp::CeilFloat64, type);
          else abort_on("type.c");
          break;
        }
        case 'd': {
          if (match("demote/f64")) makeUnary(UnaryOp::DemoteFloat64, type);
          else if (match("div_s")) makeBinary(BINARY_INT(DivS), type);
          else if (match("div_u")) makeBinary(BINARY_INT(DivU), type);
          else if (match("div")) makeBinary(BINARY_FLOAT(Div), type);
          else abort_on("type.g");
          break;
        }
        case 'e': {
          if (match("eqz")) makeUnary(type == i32 ? UnaryOp::EqZInt32 : UnaryOp::EqZInt64, type);
          else if (match("eq")) makeBinary(BINARY_INT_OR_FLOAT(Eq), i32);
          else if (match("extend_s/i32")) makeUnary(UnaryOp::ExtendSInt32, type);
          else if (match("extend_u/i32")) makeUnary(UnaryOp::ExtendUInt32, type);
          else abort_on("type.e");
          break;
        }
        case 'f': {
          if (match("floor")) makeUnary(type == f32 ? UnaryOp::FloorFloat32 : UnaryOp::FloorFloat64, type);
          else abort_on("type.e");
          break;
        }
        case 'g': {
          if (match("gt_s")) makeBinary(BINARY_INT(GtS), i32);
          else if (match("gt_u")) makeBinary(BINARY_INT(GtU), i32);
          else if (match("ge_s")) makeBinary(BINARY_INT(GeS), i32);
          else if (match("ge_u")) makeBinary(BINARY_INT(GeU), i32);
          else if (match("gt")) makeBinary(BINARY_FLOAT(Gt), i32);
          else if (match("ge")) makeBinary(BINARY_FLOAT(Ge), i32);
          else abort_on("type.g");
          break;
        }
        case 'l': {
          if (match("lt_s")) makeBinary(BINARY_INT(LtS), i32);
          else if (match("lt_u")) makeBinary(BINARY_INT(LtU), i32);
          else if (match("le_s")) makeBinary(BINARY_INT(LeS), i32);
          else if (match("le_u")) makeBinary(BINARY_INT(LeU), i32);
          else if (match("load")) makeLoad(type);
          else if (match("lt")) makeBinary(BINARY_FLOAT(Lt), i32);
          else if (match("le")) makeBinary(BINARY_FLOAT(Le), i32);
          else abort_on("type.g");
          break;
        }
        case 'm': {
          if (match("mul")) makeBinary(BINARY_INT_OR_FLOAT(Mul), type);
          else if (match("min")) makeBinary(BINARY_FLOAT(Min), type);
          else if (match("max")) makeBinary(BINARY_FLOAT(Max), type);
          else abort_on("type.m");
          break;
        }
        case 'n': {
          if (match("neg")) makeUnary(type == f32 ? UnaryOp::NegFloat32 : UnaryOp::NegFloat64, type);
          else if (match("nearest")) makeUnary(type == f32 ? UnaryOp::NearestFloat32 : UnaryOp::NearestFloat64, type);
          else if (match("ne")) makeBinary(BINARY_INT_OR_FLOAT(Ne), i32);
          else abort_on("type.n");
          break;
        }
        case 'o': {
          if (match("or")) makeBinary(BINARY_INT(Or), type);
          else abort_on("type.o");
          break;
        }
        case 'p': {
          if (match("promote/f32")) makeUnary(UnaryOp::PromoteFloat32, type);
          else if (match("popcnt")) makeUnary(type == i32 ? UnaryOp::PopcntInt32 : UnaryOp::PopcntInt64, type);
          else abort_on("type.p");
          break;
        }
        case 'r': {
          if (match("rem_s")) makeBinary(BINARY_INT(RemS), type);
          else if (match("rem_u")) makeBinary(BINARY_INT(RemU), type);
          else if (match("reinterpret/i32")) makeUnary(UnaryOp::ReinterpretInt32, type);
          else if (match("reinterpret/i64")) makeUnary(UnaryOp::ReinterpretInt64, type);
          else if (match("reinterpret/f32")) makeUnary(UnaryOp::ReinterpretFloat32, type);
          else if (match("reinterpret/f64")) makeUnary(UnaryOp::ReinterpretFloat64, type);
          else if (match("rotl")) makeBinary(BINARY_INT(RotL), type);
          else if (match("rotr")) makeBinary(BINARY_INT(RotR), type);
          else abort_on("type.r");
          break;
        }
        case 's': {
          if (match("shr_s")) makeBinary(BINARY_INT(ShrS), type);
          else if (match("shr_u")) makeBinary(BINARY_INT(ShrU), type);
          else if (match("shl")) makeBinary(BINARY_INT(Shl), type);
          else if (match("sub")) makeBinary(BINARY_INT_OR_FLOAT(Sub), type);
          else if (peek("store")) makeStore(type);
          else if (match("select")) makeSelect(type);
          else if (match("sqrt")) makeUnary(type == f32 ? UnaryOp::SqrtFloat32 : UnaryOp::SqrtFloat64, type);
          else abort_on("type.s");
          break;
        }
        case 't': {
          if (match("trunc_s/f32")) makeUnary(type == i32 ? UnaryOp::TruncSFloat32ToInt32 : UnaryOp::TruncSFloat32ToInt64, type);
          else if (match("trunc_u/f32")) makeUnary(type == i32 ? UnaryOp::TruncUFloat32ToInt32 : UnaryOp::TruncUFloat32ToInt64, type);
          else if (match("trunc_s/f64")) makeUnary(type == i32 ? UnaryOp::TruncSFloat64ToInt32 : UnaryOp::TruncSFloat64ToInt64, type);
          else if (match("trunc_u/f64")) makeUnary(type == i32 ? UnaryOp::TruncUFloat64ToInt32 : UnaryOp::TruncUFloat64ToInt64, type);
          else if (match("trunc")) makeUnary(type == f32 ? UnaryOp::TruncFloat32 : UnaryOp::TruncFloat64, type);
          else abort_on("type.t");
          break;
        }
        case 'w': {
          if (match("wrap/i64")) makeUnary(UnaryOp::WrapInt64, type);
          else abort_on("type.w");
          break;
        }
        case 'x': {
          if (match("xor")) makeBinary(BINARY_INT(Xor), type);
          else abort_on("type.x");
          break;
        }
        default: abort_on("type.?");
      }
    };
    // labels
    size_t nextLabel = 0;
    auto getNextLabel = [&nextLabel]() {
      return cashew::IString(("label$" + std::to_string(nextLabel++)).c_str(), false);
    };
    auto getBranchLabel = [&](uint32_t offset) {
      assert(offset < bstack.size());
      Expression* target = bstack[bstack.size() - 1 - offset];
      if (target->is<Block>()) {
        return target->cast<Block>()->name;
      } else {
        return target->cast<Loop>()->name;
      }
    };
    // main loop
    while (1) {
      skipWhitespace();
      if (debug) dump("main function loop");
      if (match("i32.")) {
        handleTyped(i32);
      } else if (match("i64.")) {
        handleTyped(i64);
      } else if (match("f32.")) {
        handleTyped(f32);
      } else if (match("f64.")) {
        handleTyped(f64);
      } else if (match("block")) {
        Type blockType = tryGetTypeWithoutNewline();
        auto curr = allocator->alloc<Block>();
        curr->type = blockType;
        curr->name = getNextLabel();
        addToBlock(curr);
        bstack.push_back(curr);
      } else if (match("end_block")) {
        auto* block = bstack.back()->cast<Block>();
        block->finalize(block->type);
        if (isConcreteType(block->type) && block->list.size() == 0) {
          // empty blocks that return a value are not valid, fix that up
          block->list.push_back(allocator->alloc<Unreachable>());
          block->finalize();
        }
        bstack.pop_back();
      } else if (peek(".LBB")) {
        // FIXME legacy tests: it can be leftover from "loop" or "block", but it can be a label too
        auto p = s;
        while (*p && *p != ':' && *p != '#' && *p != '\n') p++;
        if (*p == ':') { // it's a label
          recordLabel();
        } else s = strchr(s, '\n');
      } else if (match("loop")) {
        Type loopType = tryGetTypeWithoutNewline();
        auto curr = allocator->alloc<Loop>();
        addToBlock(curr);
        curr->type = loopType;
        curr->name = getNextLabel();
        auto implicitBlock = allocator->alloc<Block>();
        curr->body = implicitBlock;
        implicitBlock->type = loopType;
        bstack.push_back(curr);
      } else if (match("end_loop")) {
        auto* loop = bstack.back()->cast<Loop>();
        bstack.pop_back();
        loop->body->cast<Block>()->finalize();
        loop->finalize(loop->type);
      } else if (match("br_table")) {
        auto curr = allocator->alloc<Switch>();
        curr->condition = getInput();
        while (skipComma()) {
          curr->targets.push_back(getBranchLabel(getInt()));
        }
        assert(curr->targets.size() > 0);
        curr->default_ = curr->targets.back();
        curr->targets.pop_back();
        addToBlock(curr);
      } else if (match("br")) {
        auto curr = allocator->alloc<Break>();
        bool hasCondition = false;
        if (*s == '_') {
          mustMatch("_if");
          hasCondition = true;
        }
        curr->name = getBranchLabel(getInt());
        if (hasCondition) {
          skipComma();
          curr->condition = getInput();
        }
        curr->finalize();
        addToBlock(curr);
      } else if (match("call")) {
        makeCall(none);
      } else if (match("copy_local")) {
        Name assign = getAssign();
        skipComma();
        setOutput(getInput(), assign);
      } else if (match("tee_local")) {
        Name assign = getAssign();
        skipComma();
        auto curr = allocator->alloc<SetLocal>();
        curr->index = func->getLocalIndex(getAssign());
        skipComma();
        curr->value = getInput();
        curr->setTee(true);
        setOutput(curr, assign);
      } else if (match("return")) {
        addToBlock(builder.makeReturn(*s == '$' ? getInput() : nullptr));
      } else if (match("unreachable")) {
        addToBlock(allocator->alloc<Unreachable>());
      } else if (match("current_memory")) {
        makeHost(CurrentMemory);
      } else if (match("grow_memory")) {
        makeHost1(GrowMemory);
      } else if (peek(".Lfunc_end")) {
        // TODO fix handwritten tests to have .endfunc
        recordLabel();
        // skip the next line, which has a .size we can ignore
        s = strstr(s, ".size");
        s = strchr(s, '\n');
        break; // the function is done
      } else if (match(".endfunc")) {
        skipWhitespace();
        // getting all labels at the end of function
        while (peek(".L") && strchr(s, ':') < strchr(s, '\n')) {
          recordLabel();
          skipWhitespace();
        }
        // skip the next line, which has a .size we can ignore
        s = strstr(s, ".size");
        s = strchr(s, '\n');
        break; // the function is done
      } else if (match(".file")) {
        parseFile();
      } else if (match(".loc")) {
        recordLoc();
      } else if (peek(".L") && strchr(s, ':') < strchr(s, '\n')) {
        recordLabel();
      } else {
        abort_on("function element");
      }
    }
    if (!estack.empty()) {
      addToBlock(estack.back());
      estack.pop_back();
    }
    // finishing touches
    bstack.back()->cast<Block>()->finalize();
    bstack.pop_back(); // remove the base block for the function body
    assert(bstack.empty());
    assert(estack.empty());
    func->body->cast<Block>()->finalize();
    wasm->addFunction(func);
  }

  void parseType() {
    if (debug) dump("type");
    Name name = getStrToSep();
    skipComma();
    if (match("@function")) {
      if (match(".hidden")) mustMatch(name.str);
      return parseFunction();
    } else if (match("@object")) {
      return parseObject(name);
    }
    abort_on("parseType");
  }

  void parseObject(Name name) {
    if (debug) std::cerr << "parseObject " << name << '\n';
    if (match(".data") || match(".bss")) {
    } else if (match(".section")) {
      s = strchr(s, '\n');
    } else if (match(".lcomm")) {
      parseLcomm(name);
      return;
    }
    skipWhitespace();
    Address align = 4; // XXX default?
    if (match(".globl")) {
      mustMatch(name.str);
      skipWhitespace();
    }
    if (match(".align") || match(".p2align")) {
      align = getInt();
      skipWhitespace();
    }
    align = (Address)1 << align; // convert from power to actual bytes
    if (match(".lcomm")) {
      parseLcomm(name, align);
      return;
    }
    mustMatch(name.str);
    mustMatch(":");
    std::vector<char> raw;
    bool zero = true;
    std::vector<std::pair<LinkerObject::Relocation*, Address>> currRelocations; // [relocation, offset in raw]
    while (1) {
      skipWhitespace();
      if (match(".asci")) {
        bool z;
        if (match("i")) {
          z = false;
        } else {
          mustMatch("z");
          z = true;
        }
        auto quoted = getQuoted();
        raw.insert(raw.end(), quoted.begin(), quoted.end());
        if (z) raw.push_back(0);
        zero = false;
      } else if (match(".zero") || match(".skip")) {
        Address size = getInt();
        if (size <= 0) {
          abort_on(".zero with zero or negative size");
        }
        unsigned char value = 0;
        if (skipComma()) {
          value = getInt();
          if (value != 0) zero = false;
        }
        for (Address i = 0, e = size; i < e; ++i) {
          raw.push_back(value);
        }
      } else if (match(".int8")) {
        Address size = raw.size();
        raw.resize(size + 1);
        (*(int8_t*)(&raw[size])) = getInt();
        zero = false;
      } else if (match(".int16")) {
        Address size = raw.size();
        raw.resize(size + 2);
        int16_t val = getInt();
        memcpy(&raw[size], &val, sizeof(val));
        zero = false;
      } else if (match(".int32")) {
        Address size = raw.size();
        raw.resize(size + 4);
        auto relocation = getRelocatableConst((uint32_t*)&raw[size]); // just the size, as we may reallocate; we must fix this later, if it's a relocation
        if (relocation) {
          if (!linkerObj->isObjectImplemented(relocation->symbol)) {
            abort_on("s2wasm is currently unable to model imported globals in data segment initializers");
          }
          linkerObj->addRelocation(relocation);
          currRelocations.emplace_back(relocation, size);
        }
        zero = false;
      } else if (match(".int64")) {
        Address size = raw.size();
        raw.resize(size + 8);
        int64_t val = getInt64();
        memcpy(&raw[size], &val, sizeof(val));
        zero = false;
      } else {
        break;
      }
    }
    skipWhitespace();
    Address size = raw.size();
    if (match(".size")) {
      mustMatch(name.str);
      mustMatch(",");
      Address seenSize = atoi(getStr().str); // TODO: optimize
      assert(seenSize >= size);
      while (raw.size() < seenSize) {
        raw.push_back(0);
      }
      size = seenSize;
    }
    // raw is now finalized, prepare relocations
    for (auto& curr : currRelocations) {
      auto* r = curr.first;
      auto i = curr.second;
      r->data = (uint32_t*)&raw[i];
    }
    // assign the address, add to memory
    linkerObj->addStatic(size, align, name);
    if (!zero) {
      linkerObj->addSegment(name, raw);
    }
  }

  void parseLcomm(Name name, Address align=1) {
    mustMatch(name.str);
    skipComma();
    Address size = getInt();
    Address localAlign = 1;
    if (*s == ',') {
      skipComma();
      localAlign = Address(1) << getInt();
    }
    linkerObj->addStatic(size, std::max(align, localAlign), name);
  }

  void skipImports() {
    while (1) {
      if (match(".import")) {
        s = strchr(s, '\n');
        skipWhitespace();
        continue;
      }
      break;
    }
  }

  // This version only converts emscripten_longjmp_jmpbuf and does not deal
  // with invoke wrappers. This is used when we only have a function name as
  // relocatable constant.
  static Name fixEmLongjmp(const Name &name) {
    if (name == "emscripten_longjmp_jmpbuf")
      return "emscripten_longjmp";
    return name;
  }
};

} // namespace wasm

#endif // wasm_s2wasm_h
