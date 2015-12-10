
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

  Name getStr() {
    std::string str;
    while (*s && !isspace(*s)) {
      str += *s;
      s++;
    }
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
    // params and result
    while (1) {
      if (match(".param")) {
        while (1) {
          func->params.emplace_back(getNextId(), getType());
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
    while (1) {
      skipWhitespace();
      if (match("i32.")) {
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
        }
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
        break;
      }
    }
  }

  void parseData() {
    abort();
  }
};

} // namespace wasm

