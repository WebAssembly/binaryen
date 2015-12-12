
//
// .s to WebAssembly translator.
//

#include "wasm.h"
#include "parsing.h"
#include "asm_v_wasm.h"

namespace wasm {

extern int debug; // wasm::debug is set in main(), typically from an env var

//
// S2WasmBuilder - parses a .s file into WebAssembly
//

class S2WasmBuilder {
  AllocatingModule& wasm;
  MixedArena& allocator;
  char *s;

public:
  S2WasmBuilder(AllocatingModule& wasm, char *s) : wasm(wasm), allocator(wasm.allocator), s(s) {
    process();
    fix();
  }

private:
  // state

  size_t nextStatic = 1; // location of next static allocation, i.e., the data segment
  std::map<Name, int32_t> staticAddresses; // name => address
  typedef std::pair<Const*, Name> Addressing;
  std::vector<Addressing> addressings; // we fix these up

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

  Name getStrToSep() {
    std::string str;
    while (*s && !isspace(*s) && *s != ',' && *s != ')') {
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
    while (isdigit(*s)) {
      ret *= 10;
      ret += (*s - '0');
      s++;
    }
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
    char *before = s;
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

  Name getQuoted() { // TODO: support 0 in the middle, etc., use a raw buffer, etc.
    assert(*s == '"');
    s++;
    std::string str;
    while (*s && *s != '\"') {
      str += *s;
      s++;
    }
    s++;
    skipWhitespace();
    return cashew::IString(str.c_str(), false);
  }

  WasmType getType() {
    if (match("i32")) return i32;
    if (match("i64")) return i64;
    if (match("f32")) return f32;
    if (match("f64")) return f64;
    abort_on("getType");
  }

  // processors

  void process() {
    while (*s) {
      skipWhitespace();
      if (!*s) break;
      if (*s != '.') break;
      s++;
      if (match("text")) parseText();
      else if (match("type")) parseType();
      else if (match("imports")) skipImports();
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
    unsigned nextId = 0;
    auto getNextId = [&nextId]() {
      return cashew::IString(('$' + std::to_string(nextId++)).c_str(), false);
    };

    if (debug) dump("func");
    Name name = getStr();
    skipWhitespace();
    mustMatch(".type");
    mustMatch(name.str);
    mustMatch(",@function");
    mustMatch(name.str);
    mustMatch(":");
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
    auto getInput = [&]() {
      //dump("getinput");
      if (match("$pop")) {
        while (isdigit(*s)) s++;
        return pop();
      } else {
        auto curr = allocator.alloc<GetLocal>();
        curr->name = getStrToSep();
        curr->type = localTypes[curr->name];
        return (Expression*)curr;
      }
    };
    auto setOutput = [&](Expression* curr, Name assign) {
      if (assign.isNull() || assign.str[1] == 'd') { // discard
        bstack.back()->list.push_back(curr);
      } else if (assign.str[1] == 'p') { // push
        estack.push_back(curr);
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
      curr->right = getInput();
      skipComma();
      curr->left = getInput();
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
      int32_t bytes = getInt();
      curr->bytes = bytes > 0 ? bytes : getWasmTypeSize(type);
      curr->signed_ = match("_u");
      Name assign = getAssign();
      curr->offset = getInt();
      curr->align = curr->bytes; // XXX
      mustMatch("(");
      curr->ptr = getInput();
      mustMatch(")");
      setOutput(curr, assign);
    };
    auto makeStore = [&](WasmType type) {
      skipComma();
      auto curr = allocator.alloc<Store>();
      curr->type = type;
      int32_t bytes = getInt();
      curr->bytes = bytes > 0 ? bytes : getWasmTypeSize(type);
      Name assign = getAssign();
      curr->offset = getInt();
      curr->align = curr->bytes; // XXX
      mustMatch("(");
      curr->ptr = getInput();
      mustMatch(")");
      skipComma();
      curr->value = getInput();
      setOutput(curr, assign);
    };
    auto makeSelect = [&](WasmType type) {
      Name assign = getAssign();
      skipComma();
      auto curr = allocator.alloc<Select>();
      curr->condition = getInput();
      skipComma();
      curr->ifTrue = getInput();
      skipComma();
      curr->ifFalse = getInput();
      skipComma();
      curr->type = type;
      setOutput(curr, assign);
    };
    auto handleTyped = [&](WasmType type) {
      switch (*s) {
        case 'a': {
          if (match("add")) makeBinary(BinaryOp::Add, type);
          else if (match("and")) makeBinary(BinaryOp::And, type);
          else abort_on("type.a");
          break;
        }
        case 'c': {
          if (match("const")) {
            Name assign = getAssign();
            char start = *s;
            cashew::IString str = getStr();
            if (start == '.' || (isalpha(*s) && str != NAN_ && str != INFINITY_)) {
              // global address
              auto curr = allocator.alloc<Const>();
              curr->type = i32;
              addressings.emplace_back(curr, str);
              setOutput(curr, assign);
            } else {
              // constant
              setOutput(parseConst(str, type, allocator), assign);
            }
          } else if (match("convert_s/i32")) makeUnary(UnaryOp::ConvertSInt32, type);
          else if (match("convert_u/i32")) makeUnary(UnaryOp::ConvertUInt32, type);
          else if (match("convert_s/i64")) makeUnary(UnaryOp::ConvertSInt64, type);
          else if (match("convert_u/i64")) makeUnary(UnaryOp::ConvertUInt64, type);
          else if (match("clz")) makeUnary(UnaryOp::Clz, type);
          else if (match("ctz")) makeUnary(UnaryOp::Ctz, type);
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
          else abort_on("type.m");
          break;
        }
        case 'n': {
          if (match("ne")) makeBinary(BinaryOp::Ne, i32);
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
          else abort_on("type.s");
          break;
        }
        case 't': {
          if (match("trunc_s/f32")) makeUnary(UnaryOp::TruncSFloat32, type);
          else if (match("trunc_u/f32")) makeUnary(UnaryOp::TruncUFloat32, type);
          else if (match("trunc_s/f64")) makeUnary(UnaryOp::TruncSFloat64, type);
          else if (match("trunc_u/f64")) makeUnary(UnaryOp::TruncUFloat64, type);
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
      } else if (match("call")) {
        CallBase* curr;
        if (match("_import")) {
          curr = allocator.alloc<CallImport>();
        } else if (match("_indirect")) {
          curr = allocator.alloc<CallIndirect>();
        } else {
          curr = allocator.alloc<Call>();
        }
        Name assign = getAssign();
        if (curr->is<Call>()) {
          curr->dyn_cast<Call>()->target = getCommaSeparated();
        } else if (curr->is<CallImport>()) {
          curr->dyn_cast<CallImport>()->target = getCommaSeparated();
        } else {
          curr->dyn_cast<CallIndirect>()->target = getInput();
        }
        while (1) {
          if (!skipComma()) break;
          curr->operands.push_back(getInput());
        }
        std::reverse(curr->operands.begin(), curr->operands.end());
        setOutput(curr, assign);
        if (curr->is<CallIndirect>()) {
          auto call = curr->dyn_cast<CallIndirect>();
          auto typeName = cashew::IString((std::string("FUNCSIG_") + getSig(call)).c_str(), false);
          if (wasm.functionTypesMap.count(typeName) == 0) {
            auto type = allocator.alloc<FunctionType>();
            type->name = typeName;
            // TODO type->result
            for (auto operand : call->operands) {
              type->params.push_back(operand->type);
            }
            wasm.addFunctionType(type);
            call->fullType = type;
          } else {
            call->fullType = wasm.functionTypesMap[typeName];
          }
        }
      } else if (match("block")) {
        auto curr = allocator.alloc<Block>();
        curr->name = getStr();
        bstack.back()->list.push_back(curr);
        bstack.push_back(curr);
        seenLabels.insert(curr->name);
      } else if (match("BB")) {
        s -= 2;
        Name name = getStrToColon();
        s++;
        skipWhitespace();
        // pop all blocks/loops that reach this target
        // pop all targets with this label
        while (!bstack.empty()) {
          auto curr = bstack.back();
          if (curr->name == name) {
            bstack.pop_back();
            continue;
          }
          break;
        }
        // this may also be a loop beginning
        if (*s == 'l') {
          auto curr = allocator.alloc<Loop>();
          bstack.back()->list.push_back(curr);
          curr->in = name;
          mustMatch("loop");
          Name out = getStr();
          if (seenLabels.count(out) == 0) {
            curr->out = out;
          }
          auto block = allocator.alloc<Block>();
          block->name = out; // temporary, fake
          curr->body = block;
          loopBlocks.push_back(block);
          bstack.push_back(block);
        }
      } else if (match("br")) {
        auto curr = allocator.alloc<Break>();
        if (*s == '_') {
          mustMatch("_if");
          curr->condition = getInput();
          skipComma();
        }
        curr->name = getStr();
        bstack.back()->list.push_back(curr);
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
  }

  void parseType() {
    Name name = getStrToSep();
    skipComma();
    mustMatch("@object");
    mustMatch(".data");
    size_t align = 16; // XXX default?
    if (match(".globl")) {
      mustMatch(name.str);
      if (match(".align")) {
        align = getInt();
      } else abort_on(".global in type");
    }
    skipWhitespace();
    mustMatch(name.str);
    mustMatch(":");
    const char* data;
    char type;
    if (match(".asciz")) {
      Name buffer = getQuoted();
      data = buffer.str;
      type = 0;
    } else if (match(".zero")) {
      int32_t size = getInt();
      data = (const char*)calloc(size, 1);
      type = 1;
    } else abort_on("data");
    skipWhitespace();
    mustMatch(".size");
    mustMatch(name.str);
    mustMatch(",");
    size_t size = atoi(getStr().str); // TODO: optimize
    if (type == 0) {
      assert(strlen(data) == size);
    }
    while (nextStatic % align) nextStatic++;
    // assign the address, add to memory
    staticAddresses[name] = nextStatic;
    wasm.memory.segments.emplace_back(nextStatic, data, size);
    nextStatic += size;
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
    for (auto& pair : addressings) {
      Const* curr = pair.first;
      Name name = pair.second;
      curr->value = Literal(staticAddresses[name]);
      assert(curr->value.i32 > 0);
      curr->type = i32;
    }
  }

};

} // namespace wasm

