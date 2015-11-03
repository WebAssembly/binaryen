
//
// Parses WebAssembly code in S-Expression format, as in .wast files.
//

#include "wasm.h"
#include "mixed_arena.h"

namespace wasm {

// Globals

IString MODULE("module"),
        FUNC("func");

//
// Generic S-Expression parsing into lists
//

class SExpressionParser {
  char* input;

  MixedArena allocator;

public:
  // Assumes control of and modifies the input.
  SExpressionParser(char* input) : input(input) {}

  struct List;

  // A list of Elements, or a string
  class Element {
    bool isList;
    union {
      List list_;
      IString str_;
    };

  public:
    Element() : isList(true) {}

    // list methods

    List& list() {
      assert(isList);
      return list_;
    }

    // string methods

    IString str() {
      assert(!isList);
      return str_;
    }

    Element* setString(IString str__) {
      isList = false;
      str_ = str__;
      return this;
    }

  };

  typedef std::vector<Element*> List;

  Element* parseEverything() {
    return parseInnerList();
  }

private:
  // parses the internal part of a list, inside the parens.
  Element* parseInnerList() {
    if (input[0] == ';') {
      // comment
      input++;
      input = strchr(input, ";)");
      assert(input);
      return nullptr;
    }
    auto ret = allocator.alloc<Element>()->setList();
    while (1) {
      Element* curr = parse();
      if (!curr) return ret;
      curr->list().push_back(curr);
    }
  }

  Element* parse() {
    skipWhitespace(input);
    if (!input) return nullptr;
    if (input[0] == '(') {
      // a list
      input++;
      auto ret = parseInnerList();
      skipWhitespace(input);
      assert(input[0] == ')';
      input++;
      return ret;
    }
    return parseString();
  }

  void skipWhitespace() {
    while (isspace(input[0])) input++;
  }

  Element* parseString() {
    char *start = input;
    while (isalnum(input[0]) || input[0] == '_' || input[0] == '$') input++;
    return allocator.alloc<Element>()->setString(IString(start, false)); // TODO: reuse the string here, carefully
  }
};

//
// SExpressions => WebAssembly module
//

class SExpressionWasmBuilder {
  Module& wasm;

  MixedArena allocator;
  SExpressionParser parser;

public:
  // Assumes control of and modifies the input.
  SExpressionWasmBuilder(Module& wasm, char* input) : wasm(wasm), parser(input) {}

  void parse() {
    Element* root = parser.parseEverything();
    assert(root);
    assert(root->list()[0]->str() == MODULE);
    for (unsigned i = 1; i < root->list().size(); i++) {
      parseModuleElement(root->list()[i]);
    }
  }

  void parseModuleElement(Element* curr) {
    IString id = curr->list()[0]->str();
    if (id == FUNC) return parseFunction(curr);
    std::cerr << "bad module element " << id.str << '\n';
    abort();
  }

  void parseFunction(Element* curr) {
  }
};

} // namespace wasm

