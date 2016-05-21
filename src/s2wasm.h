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

  bool skipComma() {
    skipWhitespace();
    if (*s != ',') return false;
    s++;
    skipWhitespace();
    return true;
  }

  #define abort_on(why) { \
    dump(why ":");        \
    abort();              \
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
  bool getRelocatableConst(uint32_t* target) {
    if (isdigit(*s) || *s == '-') {
      int32_t val = getInt();
      memcpy(target, &val, sizeof(val));
      return false;
    } else {
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
      linkerObj->addRelocation(kind, target, cleanFunction(name), offset);
      return true;
    }
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

  WasmType getType() {
    if (match("i32")) return i32;
    if (match("i64")) return i64;
    if (match("f32")) return f32;
    if (match("f64")) return f64;
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
      s = strstr(s, ".type");
      if (!s) break;
      mustMatch(".type");
      Name name = getCommaSeparated();
      skipComma();
      if (!match("@function")) continue;
      if (match(".hidden")) mustMatch(name.str);
      mustMatch(name.str);
      if (match(":")) {
        info->implementedFunctions.insert(name);
      } else if (match("=")) {
        Name alias = getAtSeparated();
        mustMatch("@FUNCTION");
        info->aliasedFunctions.insert({name, alias});
      } else {
        abort_on("unknown directive");
      }
    }
  }

  void process() {
    while (*s) {
      skipWhitespace();
      if (debug) dump("process");
      if (!*s) break;
      if (*s != '.') break;
      s++;
      if (match("text")) parseText();
      else if (match("type")) parseType();
      else if (match("weak") || match("hidden") || match("protected") || match("internal")) getStr(); // contents are in the content that follows
      else if (match("imports")) skipImports();
      else if (match("data")) {}
      else if (match("ident")) {}
      else if (match("section")) parseToplevelSection();
      else if (match("align") || match("p2align")) s = strchr(s, '\n');
      else if (match("Lfunc_end")) {
        // skip the next line, which has a .size we can ignore
        s = strstr(s, ".size");
        s = strchr(s, '\n');
      } else if (match("globl")) parseGlobl();
      else abort_on("process");
    }
  }

  void parseToplevelSection() {
    auto section = getCommaSeparated();
    // Initializers are anything in a section whose name begins with .init_array
    if (!strncmp(section.c_str(), ".init_array", strlen(".init_array") - 1)) {
      parseInitializer();
      return;
    }
    s = strchr(s, '\n');
  }

  void parseInitializer() {
    // Ignore the rest of the .section line
    s = strchr(s, '\n');
    skipWhitespace();
    // The section may start with .p2align
    if (match(".p2align")) {
      s = strchr(s, '\n');
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
    assert(*s == '"');
    s++;
    std::string filename;
    while (*s != '"') {
      filename += *s;
      s++;
    }
    s++;
    // TODO: use the filename?
  }

  void parseGlobl() {
    linkerObj->addGlobal(getStr());
    skipWhitespace();
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
    Name name = getStrToSep();
    if (match(" =")) {
      /* alias = */ getAtSeparated();
      mustMatch("@FUNCTION");
      return;
    }

    mustMatch(":");

    if (match(".Lfunc_begin")) {
      s = strchr(s, '\n');
      s++;
      skipWhitespace();
    }

    unsigned nextId = 0;
    auto getNextId = [&nextId]() {
      return cashew::IString(std::to_string(nextId++).c_str(), false);
    };
    wasm::Builder builder(*wasm);
    std::vector<NameType> params;
    WasmType resultType = none;
    std::vector<NameType> vars;

    std::map<Name, WasmType> localTypes;
    // params and result
    while (1) {
      if (match(".param")) {
        while (1) {
          Name name = getNextId();
          WasmType type = getType();
          params.emplace_back(name, type);
          localTypes[name] = type;
          skipWhitespace();
          if (!match(",")) break;
        }
      } else if (match(".result")) {
        resultType = getType();
      } else if (match(".local")) {
        while (1) {
          Name name = getNextId();
          WasmType type = getType();
          vars.emplace_back(name, type);
          localTypes[name] = type;
          skipWhitespace();
          if (!match(",")) break;
        }
      } else break;
    }
    Function* func = builder.makeFunction(name, std::move(params), resultType, std::move(vars));

    // parse body
    func->body = allocator->alloc<Block>();
    std::vector<Expression*> bstack;
    auto addToBlock = [&bstack](Expression* curr) {
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
        addToBlock(curr);
      } else if (assign.str[0] == 'p') { // push
        push(curr);
      } else { // set to a local
        auto set = allocator->alloc<SetLocal>();
        set->index = func->getLocalIndex(assign);
        set->value = curr;
        set->type = curr->type;
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
    auto makeBinary = [&](BinaryOp op, WasmType type) {
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
    auto makeUnary = [&](UnaryOp op, WasmType type) {
      Name assign = getAssign();
      skipComma();
      auto curr = allocator->alloc<Unary>();
      curr->op = op;
      curr->value = getInput();
      curr->finalize();
      setOutput(curr, assign);
    };
    auto makeHost = [&](HostOp op) {
      Name assign = getAssign();
      auto curr = allocator->alloc<Host>();
      curr->op = op;
      setOutput(curr, assign);
    };
    auto makeHost1 = [&](HostOp op) {
      Name assign = getAssign();
      auto curr = allocator->alloc<Host>();
      curr->op = op;
      curr->operands.push_back(getInput());
      setOutput(curr, assign);
    };
    auto makeLoad = [&](WasmType type) {
      skipComma();
      auto curr = allocator->alloc<Load>();
      curr->type = type;
      int32_t bytes = getInt() / CHAR_BIT;
      curr->bytes = bytes > 0 ? bytes : getWasmTypeSize(type);
      curr->signed_ = match("_s");
      match("_u");
      Name assign = getAssign();
      getRelocatableConst(&curr->offset.addr);
      mustMatch("(");
      auto attributes = getAttributes(1);
      curr->ptr = getInput();
      curr->align = curr->bytes;
      if (attributes[0]) {
        assert(strncmp(attributes[0], "p2align=", 8) == 0);
        curr->align = 1U << getInt(attributes[0] + 8);
      }
      setOutput(curr, assign);
    };
    auto makeStore = [&](WasmType type) {
      skipComma();
      auto curr = allocator->alloc<Store>();
      curr->type = type;
      int32_t bytes = getInt() / CHAR_BIT;
      curr->bytes = bytes > 0 ? bytes : getWasmTypeSize(type);
      Name assign = getAssign();
      getRelocatableConst(&curr->offset.addr);
      mustMatch("(");
      auto attributes = getAttributes(2);
      auto inputs = getInputs(2);
      curr->ptr = inputs[0];
      curr->align = curr->bytes;
      if (attributes[0]) {
        assert(strncmp(attributes[0], "p2align=", 8) == 0);
        curr->align = 1U << getInt(attributes[0] + 8);
      }
      curr->value = inputs[1];
      setOutput(curr, assign);
    };
    auto makeSelect = [&](WasmType type) {
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
    auto makeCall = [&](WasmType type) {
      if (match("_indirect")) {
        // indirect call
        Name assign = getAssign();
        int num = getNumInputs();
        auto inputs = getInputs(num);
        auto input = inputs.begin();
        auto* target = *input;
        std::vector<Expression*> operands(++input, inputs.end());
        auto* funcType = ensureFunctionType(getSig(type, operands), wasm);
        assert(type == funcType->result);
        auto* indirect = builder.makeCallIndirect(funcType, target, std::move(operands));
        setOutput(indirect, assign);

      } else {
        // non-indirect call
        Name assign = getAssign();
        Name target = linkerObj->resolveAlias(cleanFunction(getCommaSeparated()));

        Call* curr = allocator->alloc<Call>();
        curr->target = target;
        curr->type = type;
        if (!linkerObj->isFunctionImplemented(target)) {
          linkerObj->addUndefinedFunctionCall(curr);
        }
        skipWhitespace();
        if (*s == ',') {
          skipComma();
          int num = getNumInputs();
          auto inputs = getInputs(num);
          for (int i = 0; i < num; i++) {
            curr->operands.push_back(inputs[i]);
          }
        }
        setOutput(curr, assign);
      }
    };
    #define BINARY_INT_OR_FLOAT(op) (type == i32 ? BinaryOp::op##Int32 : (type == i64 ? BinaryOp::op##Int64 : (type == f32 ? BinaryOp::op##Float32 : BinaryOp::op##Float64)))
    #define BINARY_INT(op) (type == i32 ? BinaryOp::op##Int32 : BinaryOp::op##Int64)
    #define BINARY_FLOAT(op) (type == f32 ? BinaryOp::op##Float32 : BinaryOp::op##Float64)
    auto handleTyped = [&](WasmType type) {
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
              getRelocatableConst((uint32_t*)curr->value.geti32Ptr());
              setOutput(curr, assign);
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
          else if (match("store")) makeStore(type);
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
        return target->cast<Loop>()->in;
      }
    };
    // fixups
    std::vector<Block*> loopBlocks; // we need to clear their names
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
        auto curr = allocator->alloc<Block>();
        curr->name = getNextLabel();
        addToBlock(curr);
        bstack.push_back(curr);
      } else if (match("end_block")) {
        bstack.back()->cast<Block>()->finalize();
        bstack.pop_back();
      } else if (match(".LBB")) {
        s = strchr(s, '\n');
      } else if (match("loop")) {
        auto curr = allocator->alloc<Loop>();
        addToBlock(curr);
        curr->in = getNextLabel();
        curr->out = getNextLabel();
        auto block = allocator->alloc<Block>();
        block->name = curr->out; // temporary, fake - this way, on bstack we have the right label at the right offset for a br
        curr->body = block;
        loopBlocks.push_back(block);
        bstack.push_back(block);
        bstack.push_back(curr);
      } else if (match("end_loop")) {
        bstack.pop_back();
        bstack.pop_back();
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
        curr->type = curr->value->type;
        setOutput(curr, assign);
      } else if (match("return")) {
        addToBlock(builder.makeReturn(*s == '$' ? getInput() : nullptr));
      } else if (match("unreachable")) {
        addToBlock(allocator->alloc<Unreachable>());
      } else if (match("current_memory")) {
        makeHost(CurrentMemory);
      } else if (match("grow_memory")) {
        makeHost1(GrowMemory);
      } else if (match(".endfunc")) {
        break; // the function is done
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
    for (auto block : loopBlocks) {
      block->name = Name();
    }
    func->body->dynCast<Block>()->finalize();
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
        if (getRelocatableConst((uint32_t*)&raw[size])) { // just the size, as we may reallocate; we must fix this later, if it's a relocation
          currRelocations.emplace_back(linkerObj->getCurrentRelocation(), size);
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
    if (*s == ',') {
      skipComma();
      getInt();
    }
    linkerObj->addStatic(size, align, name);
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


};

} // namespace wasm

#endif // wasm_s2wasm_h
