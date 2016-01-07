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

#include "wasm.h"
#include "parsing.h"
#include "asm_v_wasm.h"

namespace wasm {

cashew::IString EMSCRIPTEN_ASM_CONST("emscripten_asm_const");

//
// S2WasmBuilder - parses a .s file into WebAssembly
//

class S2WasmBuilder {
  AllocatingModule& wasm;
  MixedArena& allocator;
  const char *s;
  bool debug;

public:
 S2WasmBuilder(AllocatingModule& wasm, const char* input, bool debug, size_t globalBase)
     : wasm(wasm), allocator(wasm.allocator), debug(debug), globalBase(globalBase), nextStatic(globalBase) {
    s = input;
    scan();
    s = input;
    prepare();
    process();
    fix();
  }

private:
  // state

  size_t globalBase, // where globals can start to be statically allocated, i.e., the data segment
         nextStatic; // location of next static allocation
  std::map<Name, int32_t> staticAddresses; // name => address

  struct Relocation {
    uint32_t* data;
    Name value;
    int offset;
    Relocation(uint32_t* data, Name value, int offset) : data(data), value(value), offset(offset) {}
  };
  std::vector<Relocation> relocations;

  std::set<Name> implementedFunctions;

  std::map<size_t, size_t> addressSegments; // address => segment index

  std::map<Name, size_t> functionIndexes;

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
    while (*s && !isspace(*s) && *s != ',' && *s != '(' && *s != ')' && *s != ':' && *s != '+' && *s != '-') {
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

  int32_t getInt() {
    int32_t ret = 0;
    bool neg = false;
    if (*s == '-') {
      neg = true;
      s++;
    }
    while (isdigit(*s)) {
      ret *= 10;
      ret += (*s - '0');
      s++;
    }
    if (neg) ret = -ret;
    return ret;
  }

  // gets a constant, which may be a relocation for later.
  // returns whether this is a relocation
  bool getConst(uint32_t* target) {
    if (isdigit(*s) || *s == '-') {
      *target = getInt();
      return false;
    } else {
      // a global constant, we need to fix it up later
      Name name = getStrToSep();
      int offset = 0;
      if (*s == '+') {
        s++;
        offset = getInt();
      } else if (*s == '-') {
        s++;
        offset = -getInt();
      }
      relocations.emplace_back(target, name, offset);
      return true;
    }
  }

  int64_t getInt64() {
    int64_t ret = 0;
    bool neg = false;
    if (*s == '-') {
      neg = true;
      s++;
    }
    while (isdigit(*s)) {
      ret *= 10;
      ret += (*s - '0');
      s++;
    }
    if (neg) ret = -ret;
    return ret;
  }

  Name getCommaSeparated() {
    skipWhitespace();
    std::string str;
    while (*s && *s != ',' && *s != '\n') {
      str += *s;
      s++;
    }
    skipWhitespace();
    return cashew::IString(str.c_str(), false);
  }

  Name getAssign() {
    skipWhitespace();
    if (*s != '$') return Name();
    std::string str;
    const char *before = s;
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

  // processors

  void scan() {
    while (*s) {
      s = strstr(s, "\n	.type	");
      if (!s) break;
      mustMatch("\n	.type	");
      Name name = getCommaSeparated();
      skipComma();
      if (!match("@function")) continue;
      mustMatch(name.str);
      mustMatch(":");
      implementedFunctions.insert(name);
    }
  }

  void prepare() {
    staticAddresses["__stack_pointer"] = 0; // XXX HACK for now
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
      else if (match("section") || match("align")) s = strchr(s, '\n');
      else if (match("globl")) parseGlobl();
      else abort_on("process");
    }
  }

  void parseText() {
    while (*s) {
      skipWhitespace();
      if (!*s) break;
      if (*s != '.') break;
      s++;
      if (match("file")) parseFile();
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
    (void)getStr();
    skipWhitespace();
  }

  void parseFunction() {
    if (debug) dump("func");
    Name name = getStrToSep();
    mustMatch(":");

    unsigned nextId = 0;
    auto getNextId = [&nextId]() {
      return cashew::IString(('$' + std::to_string(nextId++)).c_str(), false);
    };

    auto func = allocator.alloc<Function>();
    func->name = name;
    std::map<Name, WasmType> localTypes;
    // params and result
    while (1) {
      if (match(".param")) {
        while (1) {
          Name name = getNextId();
          WasmType type = getType();
          func->params.emplace_back(name, type);
          localTypes[name] = type;
          skipWhitespace();
          if (!match(",")) break;
        }
      } else if (match(".result")) {
        func->result = getType();
      } else if (match(".local")) {
        while (1) {
          Name name = getNextId();
          WasmType type = getType();
          func->locals.emplace_back(name, type);
          localTypes[name] = type;
          skipWhitespace();
          if (!match(",")) break;
        }
      } else break;
    }
    // parse body
    func->body = allocator.alloc<Block>();
    std::vector<Block*> bstack;
    bstack.push_back(func->body->dyn_cast<Block>());
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
        } else {
          auto curr = allocator.alloc<GetLocal>();
          curr->name = getStrToSep();
          curr->type = localTypes[curr->name];
          inputs[i] = curr;
        }
        if (*s == ')') s++; // tolerate 0(argument) syntax, where we started at the 'a'
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
      if (assign.isNull() || assign.str[1] == 'd') { // discard
        bstack.back()->list.push_back(curr);
      } else if (assign.str[1] == 'p') { // push
        push(curr);
      } else { // set to a local
        auto set = allocator.alloc<SetLocal>();
        set->name = assign;
        set->value = curr;
        set->type = curr->type;
        bstack.back()->list.push_back(set);
      }
    };
    auto makeBinary = [&](BinaryOp op, WasmType type) {
      Name assign = getAssign();
      skipComma();
      auto curr = allocator.alloc<Binary>();
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
      auto curr = allocator.alloc<Unary>();
      curr->op = op;
      curr->value = getInput();
      curr->type = type;
      setOutput(curr, assign);
    };
    auto makeHost = [&](HostOp op) {
      Name assign = getAssign();
      auto curr = allocator.alloc<Host>();
      curr->op = MemorySize;
      setOutput(curr, assign);
    };
    auto makeHost1 = [&](HostOp op) {
      Name assign = getAssign();
      auto curr = allocator.alloc<Host>();
      curr->op = MemorySize;
      curr->operands.push_back(getInput());
      setOutput(curr, assign);
    };
    auto makeLoad = [&](WasmType type) {
      skipComma();
      auto curr = allocator.alloc<Load>();
      curr->type = type;
      int32_t bytes = getInt()/8;
      curr->bytes = bytes > 0 ? bytes : getWasmTypeSize(type);
      curr->signed_ = match("_s");
      match("_u");
      Name assign = getAssign();
      getConst(&curr->offset);
      curr->align = curr->bytes; // XXX
      mustMatch("(");
      curr->ptr = getInput();
      setOutput(curr, assign);
    };
    auto makeStore = [&](WasmType type) {
      skipComma();
      auto curr = allocator.alloc<Store>();
      curr->type = type;
      int32_t bytes = getInt();
      curr->bytes = bytes > 0 ? bytes : getWasmTypeSize(type);
      curr->align = curr->bytes; // XXX
      Name assign = getAssign();
      getConst(&curr->offset);
      mustMatch("(");
      auto inputs = getInputs(2);
      curr->ptr = inputs[0];
      curr->value = inputs[1];
      setOutput(curr, assign);
    };
    auto makeSelect = [&](WasmType type) {
      Name assign = getAssign();
      skipComma();
      auto curr = allocator.alloc<Select>();
      auto inputs = getInputs(3);
      curr->condition = inputs[0];
      curr->ifTrue = inputs[1];
      curr->ifFalse = inputs[2];
      curr->type = type;
      setOutput(curr, assign);
    };
    auto makeCall = [&](WasmType type) {
      CallBase* curr;
      Name assign;
      if (match("_indirect")) {
        auto specific = allocator.alloc<CallIndirect>();
        assign = getAssign();
        specific->target = getInput();
        curr = specific;
      } else {
        assign = getAssign();
        Name target = getCommaSeparated();
        if (implementedFunctions.count(target) > 0) {
          auto specific = allocator.alloc<Call>();
          specific->target = target;
          curr = specific;
        } else {
          auto specific = allocator.alloc<CallImport>();
          specific->target = target;
          curr = specific;
        }
      }
      curr->type = type;
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
      if (curr->is<CallIndirect>()) {
        auto call = curr->dyn_cast<CallIndirect>();
        auto typeName = cashew::IString((std::string("FUNCSIG_") + getSig(call)).c_str(), false);
        if (wasm.functionTypesMap.count(typeName) == 0) {
          auto type = allocator.alloc<FunctionType>();
          *type = sigToFunctionType(getSig(curr));
          type->name = typeName;
          wasm.addFunctionType(type);
          call->fullType = type;
        } else {
          call->fullType = wasm.functionTypesMap[typeName];
        }
      } else if (curr->is<CallImport>()) {
        auto target = curr->cast<CallImport>()->target;
        if (wasm.importsMap.count(target) == 0) {
          auto import = allocator.alloc<Import>();
          import->name = import->base = target;
          import->module = ENV;
          import->type = sigToFunctionType(getSig(curr));
          wasm.addImport(import);
        }
      }
    };
    auto handleTyped = [&](WasmType type) {
      switch (*s) {
        case 'a': {
          if (match("add")) makeBinary(BinaryOp::Add, type);
          else if (match("and")) makeBinary(BinaryOp::And, type);
          else if (match("abs")) makeUnary(UnaryOp::Abs, type);
          else abort_on("type.a");
          break;
        }
        case 'c': {
          if (match("const")) {
            Name assign = getAssign();
            if (type == i32) {
              // may be a relocation
              auto curr = allocator.alloc<Const>();
              curr->type = curr->value.type = i32;
              getConst((uint32_t*)&curr->value.i32);
              setOutput(curr, assign);
            } else {
              cashew::IString str = getStr();
              setOutput(parseConst(str, type, allocator), assign);
            }
          }
          else if (match("call")) makeCall(type);
          else if (match("convert_s/i32")) makeUnary(UnaryOp::ConvertSInt32, type);
          else if (match("convert_u/i32")) makeUnary(UnaryOp::ConvertUInt32, type);
          else if (match("convert_s/i64")) makeUnary(UnaryOp::ConvertSInt64, type);
          else if (match("convert_u/i64")) makeUnary(UnaryOp::ConvertUInt64, type);
          else if (match("clz")) makeUnary(UnaryOp::Clz, type);
          else if (match("ctz")) makeUnary(UnaryOp::Ctz, type);
          else if (match("copysign")) makeBinary(BinaryOp::CopySign, type);
          else if (match("ceil")) makeUnary(UnaryOp::Ceil, type);
          else abort_on("type.c");
          break;
        }
        case 'd': {
          if (match("demote/f64")) makeUnary(UnaryOp::DemoteFloat64, type);
          else if (match("div_s")) makeBinary(BinaryOp::DivS, type);
          else if (match("div_u")) makeBinary(BinaryOp::DivU, type);
          else if (match("div")) makeBinary(BinaryOp::Div, type);
          else abort_on("type.g");
          break;
        }
        case 'e': {
          if (match("eq")) makeBinary(BinaryOp::Eq, i32);
          else if (match("extend_s/i32")) makeUnary(UnaryOp::ExtendSInt32, type);
          else if (match("extend_u/i32")) makeUnary(UnaryOp::ExtendUInt32, type);
          else abort_on("type.e");
          break;
        }
        case 'f': {
          if (match("floor")) makeUnary(UnaryOp::Floor, type);
          else abort_on("type.e");
          break;
        }
        case 'g': {
          if (match("gt_s")) makeBinary(BinaryOp::GtS, i32);
          else if (match("gt_u")) makeBinary(BinaryOp::GtU, i32);
          else if (match("ge_s")) makeBinary(BinaryOp::GeS, i32);
          else if (match("ge_u")) makeBinary(BinaryOp::GeU, i32);
          else if (match("gt")) makeBinary(BinaryOp::Gt, i32);
          else if (match("ge")) makeBinary(BinaryOp::Ge, i32);
          else abort_on("type.g");
          break;
        }
        case 'l': {
          if (match("lt_s")) makeBinary(BinaryOp::LtS, i32);
          else if (match("lt_u")) makeBinary(BinaryOp::LtU, i32);
          else if (match("le_s")) makeBinary(BinaryOp::LeS, i32);
          else if (match("le_u")) makeBinary(BinaryOp::LeU, i32);
          else if (match("load")) makeLoad(type);
          else if (match("lt")) makeBinary(BinaryOp::Lt, i32);
          else if (match("le")) makeBinary(BinaryOp::Le, i32);
          else abort_on("type.g");
          break;
        }
        case 'm': {
          if (match("mul")) makeBinary(BinaryOp::Mul, type);
          else if (match("min")) makeBinary(BinaryOp::Min, type);
          else if (match("max")) makeBinary(BinaryOp::Max, type);
          else abort_on("type.m");
          break;
        }
        case 'n': {
          if (match("neg")) makeUnary(UnaryOp::Neg, type);
          else if (match("nearest")) makeUnary(UnaryOp::Nearest, type);
          else if (match("ne")) makeBinary(BinaryOp::Ne, i32);
          else abort_on("type.n");
          break;
        }
        case 'o': {
          if (match("or")) makeBinary(BinaryOp::Or, type);
          else abort_on("type.o");
          break;
        }
        case 'p': {
          if (match("promote/f32")) makeUnary(UnaryOp::PromoteFloat32, type);
          else if (match("popcnt")) makeUnary(UnaryOp::Popcnt, type);
          else abort_on("type.p");
          break;
        }
        case 'r': {
          if (match("rem_s")) makeBinary(BinaryOp::RemS, type);
          else if (match("rem_u")) makeBinary(BinaryOp::RemU, type);
          else if (match("reinterpret/i32") || match("reinterpret/i64")) makeUnary(UnaryOp::ReinterpretInt, type);
          else if (match("reinterpret/f32") || match("reinterpret/f64")) makeUnary(UnaryOp::ReinterpretFloat, type);
          else abort_on("type.r");
          break;
        }
        case 's': {
          if (match("shr_s")) makeBinary(BinaryOp::ShrS, type);
          else if (match("shr_u")) makeBinary(BinaryOp::ShrU, type);
          else if (match("shl")) makeBinary(BinaryOp::Shl, type);
          else if (match("sub")) makeBinary(BinaryOp::Sub, type);
          else if (match("store")) makeStore(type);
          else if (match("select")) makeSelect(type);
          else if (match("sqrt")) makeUnary(UnaryOp::Sqrt, type);
          else abort_on("type.s");
          break;
        }
        case 't': {
          if (match("trunc_s/f32")) makeUnary(UnaryOp::TruncSFloat32, type);
          else if (match("trunc_u/f32")) makeUnary(UnaryOp::TruncUFloat32, type);
          else if (match("trunc_s/f64")) makeUnary(UnaryOp::TruncSFloat64, type);
          else if (match("trunc_u/f64")) makeUnary(UnaryOp::TruncUFloat64, type);
          else if (match("trunc")) makeUnary(UnaryOp::Trunc, type);
          else abort_on("type.t");
          break;
        }
        case 'w': {
          if (match("wrap/i64")) makeUnary(UnaryOp::WrapInt64, type);
          else abort_on("type.w");
          break;
        }
        case 'x': {
          if (match("xor")) makeBinary(BinaryOp::Xor, type);
          else abort_on("type.x");
          break;
        }
        default: abort_on("type.?");
      }
    };
    // fixups
    std::vector<Block*> loopBlocks; // we need to clear their names
    std::set<Name> seenLabels; // if we already used a label, we don't need it in a loop (there is a block above it, with that label)
    Name lastLabel; // A loop has an 'in' label which appears before it. There might also be a block in between it and the loop, so we have to remember the last label
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
        auto curr = allocator.alloc<Block>();
        curr->name = getStr();
        bstack.back()->list.push_back(curr);
        bstack.push_back(curr);
        seenLabels.insert(curr->name);
      } else if (match("BB")) {
        s -= 2;
        lastLabel = getStrToColon();
        s++;
        skipWhitespace();
        // pop all blocks/loops that reach this target
        // pop all targets with this label
        while (!bstack.empty()) {
          auto curr = bstack.back();
          if (curr->name == lastLabel) {
            bstack.pop_back();
            continue;
          }
          break;
        }
      } else if (match("loop")) {
        auto curr = allocator.alloc<Loop>();
        bstack.back()->list.push_back(curr);
        curr->in = lastLabel;
        Name out = getStr();
        if (seenLabels.count(out) == 0) {
          curr->out = out;
        }
        auto block = allocator.alloc<Block>();
        block->name = out; // temporary, fake
        curr->body = block;
        loopBlocks.push_back(block);
        bstack.push_back(block);
      } else if (match("br")) {
        auto curr = allocator.alloc<Break>();
        if (*s == '_') {
          mustMatch("_if");
          curr->condition = getInput();
          skipComma();
        }
        curr->name = getStr();
        bstack.back()->list.push_back(curr);
      } else if (match("call")) {
        makeCall(none);
      } else if (match("copy_local")) {
        Name assign = getAssign();
        skipComma();
        setOutput(getInput(), assign);
      } else if (match("return")) {
        Block *temp;
        if (!(func->body && (temp = func->body->dyn_cast<Block>()) && temp->name == FAKE_RETURN)) {
          Expression* old = func->body;
          temp = allocator.alloc<Block>();
          temp->name = FAKE_RETURN;
          if (old) temp->list.push_back(old);
          func->body = temp;
        }
        auto curr = allocator.alloc<Break>();
        curr->name = FAKE_RETURN;
        if (*s == '$') {
          curr->value = getInput();
        }
        bstack.back()->list.push_back(curr);
      } else if (match("tableswitch")) {
        auto curr = allocator.alloc<Switch>();
        curr->value = getInput();
        skipComma();
        curr->default_ = getCommaSeparated();
        while (skipComma()) {
          curr->targets.push_back(getCommaSeparated());
        }
        bstack.back()->list.push_back(curr);
      } else if (match("unreachable")) {
        bstack.back()->list.push_back(allocator.alloc<Unreachable>());
      } else if (match("memory_size")) {
        makeHost(MemorySize);
      } else if (match("grow_memory")) {
        makeHost1(GrowMemory);
      } else if (match("func_end")) {
        s = strchr(s, '\n');
        s++;
        s = strchr(s, '\n');
        break; // the function is done
      } else {
        abort_on("function element");
      }
    }
    // finishing touches
    bstack.pop_back(); // remove the base block for the function body
    assert(bstack.empty());
    assert(estack.empty());
    for (auto block : loopBlocks) {
      block->name = Name();
    }
    wasm.addFunction(func);
    // XXX for now, export all functions
    auto exp = allocator.alloc<Export>();
    exp->name = exp->value = func->name;
    wasm.addExport(exp);
  }

  void parseType() {
    if (debug) dump("type");
    Name name = getStrToSep();
    skipComma();
    if (match("@function")) return parseFunction();
    else if (match("@object")) return parseObject(name);
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
    size_t align = 4; // XXX default?
    if (match(".globl")) {
      mustMatch(name.str);
      skipWhitespace();
    }
    if (match(".align")) {
      align = getInt();
      skipWhitespace();
    }
    align = pow(2, align); // convert from power to actual bytes
    if (match(".lcomm")) {
      parseLcomm(name, align);
      return;
    }
    mustMatch(name.str);
    mustMatch(":");
    auto raw = new std::vector<char>(); // leaked intentionally, no new allocation in Memory
    bool zero = true;
    std::vector<std::pair<size_t, size_t>> currRelocations; // [index in relocations, offset in raw]
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
        raw->insert(raw->end(), quoted.begin(), quoted.end());
        if (z) raw->push_back(0);
        zero = false;
      } else if (match(".zero")) {
        int32_t size = getInt();
        if (size <= 0) {
          abort_on(".zero with zero or negative size");
        }
        for (size_t i = 0, e = size; i < e; i++) {
          raw->push_back(0);
        }
      } else if (match(".int8")) {
        size_t size = raw->size();
        raw->resize(size + 1);
        (*(int8_t*)(&(*raw)[size])) = getInt();
        zero = false;
      } else if (match(".int16")) {
        size_t size = raw->size();
        raw->resize(size + 2);
        (*(int16_t*)(&(*raw)[size])) = getInt();
        zero = false;
      } else if (match(".int32")) {
        size_t size = raw->size();
        raw->resize(size + 4);
        if (getConst((uint32_t*)&(*raw)[size])) { // just the size, as we may reallocate; we must fix this later, if it's a relocation
          currRelocations.emplace_back(relocations.size()-1, size);
        }
        zero = false;
      } else if (match(".int64")) {
        size_t size = raw->size();
        raw->resize(size + 8);
        (*(int64_t*)(&(*raw)[size])) = getInt();
        zero = false;
      } else {
        break;
      }
    }
    skipWhitespace();
    size_t size = raw->size();
    if (match(".size")) {
      mustMatch(name.str);
      mustMatch(",");
      size_t seenSize = atoi(getStr().str); // TODO: optimize
      assert(seenSize >= size);
      while (raw->size() < seenSize) {
        raw->push_back(0);
      }
      size = seenSize;
    }
    // raw is now finalized, prepare relocations
    for (auto& curr : currRelocations) {
      auto r = curr.first;
      auto i = curr.second;
      relocations[r].data = (uint32_t*)&(*raw)[i];
    }
    // assign the address, add to memory
    while (nextStatic % align) nextStatic++;
    staticAddresses[name] = nextStatic;
    if (!zero) {
      addressSegments[nextStatic] = wasm.memory.segments.size();
      wasm.memory.segments.emplace_back(nextStatic, (const char*)&(*raw)[0], size);
    }
    nextStatic += size;
    wasm.memory.initial = nextStatic;
  }

  void parseLcomm(Name name, size_t align=1) {
    mustMatch(name.str);
    skipComma();
    size_t size = getInt();
    if (*s == ',') {
      skipComma();
      getInt();
    }
    while (nextStatic % align) nextStatic++;
    staticAddresses[name] = nextStatic;
    nextStatic += size;
    wasm.memory.initial = nextStatic;
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

  void fix() {
    auto ensureFunctionIndex = [&](Name name) {
      if (functionIndexes.count(name) == 0) {
        functionIndexes[name] = wasm.table.names.size();
        wasm.table.names.push_back(name);
        if (debug) std::cerr << "function index: " << name << ": " << functionIndexes[name] << '\n';
      }
    };
    for (auto& relocation : relocations) {
      Name name = relocation.value;
      if (debug) std::cerr << "fix relocation " << name << '\n';
      const auto &symbolAddress = staticAddresses.find(name);
      if (symbolAddress != staticAddresses.end()) {
        *(relocation.data) = symbolAddress->second + relocation.offset;
        if (debug) std::cerr << "  ==> " << *(relocation.data) << '\n';
      } else {
        // must be a function address
        if (wasm.functionsMap.count(name) == 0) {
          std::cerr << "Unknown symbol: " << name << '\n';
          abort_on("Unknown symbol");
        }
        ensureFunctionIndex(name);
        *(relocation.data) = functionIndexes[name] + relocation.offset;
      }
    }
  }

  template<class C>
  void printSet(std::ostream& o, C& c) {
    o << "[";
    bool first = true;
    for (auto& item : c) {
      if (first) first = false;
      else o << ",";
      o << '"' << item << '"';
    }
    o << "]";
  }

public:

  // extra emscripten processing
  void emscriptenGlue(std::ostream& o) {
    if (debug) {
      std::cerr << wasm << '\n';
    }

    wasm.removeImport(EMSCRIPTEN_ASM_CONST); // we create _sig versions

    o << ";; METADATA: { ";
    // find asmConst calls, and emit their metadata
    struct AsmConstWalker : public WasmWalker {
      S2WasmBuilder* parent;

      std::map<std::string, std::set<std::string>> sigsForCode;
      std::map<std::string, size_t> ids;
      std::set<std::string> allSigs;

      AsmConstWalker(S2WasmBuilder* parent) : parent(parent) {}

      void visitCallImport(CallImport* curr) override {
        if (curr->target == EMSCRIPTEN_ASM_CONST) {
          auto arg = curr->operands[0]->cast<Const>();
          size_t segmentIndex = parent->addressSegments[arg->value.geti32()];
          std::string code = escape(parent->wasm.memory.segments[segmentIndex].data);
          int32_t id;
          if (ids.count(code) == 0) {
            id = ids.size();
            ids[code] = id;
          } else {
            id = ids[code];
          }
          std::string sig = getSig(curr);
          sigsForCode[code].insert(sig);
          std::string fixedTarget = std::string("_") + EMSCRIPTEN_ASM_CONST.str + '_' + sig;
          curr->target = cashew::IString(fixedTarget.c_str(), false);
          arg->value = Literal(id);
          // add import, if necessary
          if (allSigs.count(sig) == 0) {
            allSigs.insert(sig);
            auto import = parent->allocator.alloc<Import>();
            import->name = import->base = curr->target;
            import->module = ENV;
            import->type = sigToFunctionType(getSig(curr));
            parent->wasm.addImport(import);
          }
        }
      }

      std::string escape(const char *input) {
        std::string code = input;
        // replace newlines quotes with escaped newlines
        size_t curr = 0;
        while ((curr = code.find("\\n", curr)) != std::string::npos) {
          code = code.replace(curr, 2, "\\\\n");
          curr += 3; // skip this one
        }
        // replace double quotes with escaped single quotes
        curr = 0;
        while ((curr = code.find('"', curr)) != std::string::npos) {
          if (curr == 0 || code[curr-1] != '\\') {
            code = code.replace(curr, 1, "\\" "\"");
            curr += 2; // skip this one
          } else { // already escaped, escape the slash as well
            code = code.replace(curr, 1, "\\" "\\" "\"");
            curr += 3; // skip this one
          }
        }
        return code;
      }
    };
    AsmConstWalker walker(this);
    walker.startWalk(&wasm);
    // print
    o << "\"asmConsts\": {";
    bool first = true;
    for (auto& pair : walker.sigsForCode) {
      auto& code = pair.first;
      auto& sigs = pair.second;
      if (first) first = false;
      else o << ",";
      o << '"' << walker.ids[code] << "\": [\"" << code << "\", ";
      printSet(o, sigs);
      o << "]";
    }
    o << "}";
    o << ",";
    o << "\"staticBump\": " << (nextStatic - globalBase);

    o << " }";
  }
};

} // namespace wasm

#endif // wasm_s2wasm_h
