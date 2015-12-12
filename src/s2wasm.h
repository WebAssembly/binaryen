
//
// .s to WebAssembly translator.
//

#include "wasm.h"
#include "parsing.h"

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

  size_t nextStatic = 0; // location of next static allocation, i.e., the data segment
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

  void findComma() {
    while (*s && *s != ',') s++;
    s++;
    skipWhitespace();
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
    assert(matched);
  }

  void dump(const char *text) {
    std::cerr << "[[" << text << "]]:\n==========\n";
    for (size_t i = 0; i < 60; i++) {
      if (!s[i]) break;
      std::cerr << s[i];
    }
    std::cerr << "\n==========\n";
  }

  #define abort_on(why) { \
    dump(why ":");        \
    abort();              \
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

  Name getStrToComma() {
    std::string str;
    while (*s && !isspace(*s) && *s != ',') {
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
    std::string str;
    while (*s && *s != '=') {
      str += *s;
      s++;
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
        curr->name = getStrToComma();
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
    // fixups
    std::vector<Block*> loopBlocks; // we need to clear their names
    std::set<Name> seenLabels; // if we already used a label, we don't need it in a loop (there is a block above it, with that label)
    // main loop
    while (1) {
      skipWhitespace();
      //dump("main function loop");
      if (match("i32.")) {
        switch (*s) {
          case 'a': {
            if (match("add")) makeBinary(BinaryOp::Add, i32);
            else if (match("and")) makeBinary(BinaryOp::And, i32);
            else abort_on("i32.a");
            break;
          }
          case 'c': {
            if (match("const")) {
              mustMatch("$push");
              findComma();
              if (*s == '.') {
                // global address
                auto curr = allocator.alloc<Const>();
                curr->type = i32;
                addressings.emplace_back(curr, getStr());
                push(curr);
              } else {
                // constant
                push(parseConst(getStr(), i32, allocator));
              }
            } else abort_on("i32.c");
            break;
          }
          case 'e': {
            if (match("eq")) makeBinary(BinaryOp::Eq, i32);
            break;
          }
          case 'g': {
            if (match("gt_s")) makeBinary(BinaryOp::GtS, i32);
            else if (match("gt_u")) makeBinary(BinaryOp::GtU, i32);
            else abort_on("i32.g");
            break;
          }
          case 'n': {
            if (match("ne")) makeBinary(BinaryOp::Ne, i32);
            else abort_on("i32.n");
            break;
          }
          case 'r': {
            if (match("rem_s")) makeBinary(BinaryOp::RemS, i32);
            else if (match("rem_u")) makeBinary(BinaryOp::RemU, i32);
            else abort_on("i32.n");
            break;
          }
          case 's': {
            if (match("shr_s")) makeBinary(BinaryOp::ShrS, i32);
            else if (match("shr_u")) makeBinary(BinaryOp::ShrU, i32);
            else if (match("sub")) makeBinary(BinaryOp::Sub, i32);
            else abort_on("i32.s");
            break;
          }
          default: abort_on("i32.?");
        }
      } else if (match("call")) {
        Name assign;
        if (*s == '$') {
          assign = getAssign();
          skipComma();
        }
        auto curr = allocator.alloc<Call>();
        curr->target = getCommaSeparated();
        while (1) {
          if (!skipComma()) break;
          curr->operands.push_back(getInput());
        }
        std::reverse(curr->operands.begin(), curr->operands.end());
        setOutput(curr, assign);
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
    Name name = getStrToComma();
    skipComma();
    mustMatch("@object");
    mustMatch(".data");
    mustMatch(name.str);
    mustMatch(":");
    mustMatch(".asciz");
    Name buffer = getQuoted();
    mustMatch(".size");
    mustMatch(name.str);
    mustMatch(",");
    size_t size = atoi(getStr().str); // TODO: optimize
    assert(strlen(buffer.str) == size);
    const int ALIGN = 16;
    if (nextStatic == 0) nextStatic = ALIGN;
    // assign the address, add to memory, and increment for the next one
    staticAddresses[name] = nextStatic;
    wasm.memory.segments.emplace_back(nextStatic, buffer.str, size);
    nextStatic += size;
    nextStatic = (nextStatic + ALIGN - 1) & -ALIGN;
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

