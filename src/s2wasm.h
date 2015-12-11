
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

  #define abort_on(why) {          \
    printf("%s : %20s\n", why, s); \
    abort();                       \
  }

  void dump(const char *text) {
    std::cerr << text << "\n==========\n" << s << "\n==========\n";
  }

  void unget(Name str) {
    s -= strlen(str.str);
  }

  Name getStr() {
    std::string str;
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

  Name getCommaSeparated() {
    skipWhitespace();
    std::string str;
    while (*s && *s != ',') {
      str += *s;
      s++;
    }
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

  // state

  typedef std::pair<Const*, Name> Addressing;
  std::vector<Addressing> addressings;

  // processors

  void process() {
    while (*s) {
      skipWhitespace();
      if (!*s) break;
      if (*s != '.') break;
      s++;
      if (match("text")) parseText();
      else if (match("data")) parseData();
      else abort_on(s);
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
      else abort_on(s);
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
    auto currBlock = allocator.alloc<Block>();
    func->body = currBlock;
    std::vector<Expression*> stack;
    auto push = [&](Expression* curr) {
      stack.push_back(curr);
    };
    auto pop = [&]() {
      Expression* ret = stack.back();
      stack.pop_back();
      return ret;
    };
    auto getInput = [&]() {
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
      if (assign.str[1] == 'p') { // push
        stack.push_back(curr);
      } else if (assign.str[1] == 'd') { // discard
        currBlock->list.push_back(curr);
      } else { // set to a local
        auto set = allocator.alloc<SetLocal>();
        set->name = assign;
        set->value = curr;
        set->type = curr->type;
        currBlock->list.push_back(set);
      }
    };
    auto makeBinary = [&](BinaryOp op, WasmType type) {
      Name assign = getCommaSeparated();
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
    // main loop
    while (1) {
      skipWhitespace();
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
          case 'n': {
            if (match("ne")) makeBinary(BinaryOp::Ne, i32);
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
        Name assign = getCommaSeparated();
        skipComma();
        auto curr = allocator.alloc<Call>();
        curr->target = getCommaSeparated();
        while (1) {
          if (!skipComma()) break;
          curr->operands.push_back(getInput());
        }
        std::reverse(curr->operands.begin(), curr->operands.end());
        setOutput(curr, assign);
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
          getStr();
          curr->value = pop();
        }
        currBlock->list.push_back(curr);
      } else if (match("func_end0:")) {
        mustMatch(".size");
        mustMatch("main,");
        mustMatch("func_end0-main");
        wasm.addFunction(func);
        return; // the function is done
      } else {
        abort_on("function element");
      }
    }
  }

  void parseData() {
    abort();
  }
};

} // namespace wasm

