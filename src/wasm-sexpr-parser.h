
//
// Parses WebAssembly code in S-Expression format, as in .wast files.
//

#include "wasm.h"
#include "mixed_arena.h"

namespace wasm {

using namespace cashew;
// Globals

IString MODULE("module"),
        FUNC("func"),
        PARAM("param"),
        RESULT("result");

//
// An element in an S-Expression: a list or a string
//

class Element {
  typedef std::vector<Element*> List;

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

  Element* operator[](unsigned i) {
    return list()[i];
  }

  size_t size() {
    return list().size();
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

//
// Generic S-Expression parsing into lists
//

class SExpressionParser {
  char* input;

  MixedArena allocator;

public:
  // Assumes control of and modifies the input.
  SExpressionParser(char* input) : input(input) {}

  Element* parseEverything() {
    return parseInnerList();
  }

private:
  // parses the internal part of a list, inside the parens.
  Element* parseInnerList() {
    if (input[0] == ';') {
      // comment
      input++;
      input = strstr(input, ";)");
      assert(input);
      return nullptr;
    }
    auto ret = allocator.alloc<Element>();
    while (1) {
      Element* curr = parse();
      if (!curr) return ret;
      curr->list().push_back(curr);
    }
  }

  Element* parse() {
    skipWhitespace();
    if (!input) return nullptr;
    if (input[0] == '(') {
      // a list
      input++;
      auto ret = parseInnerList();
      skipWhitespace();
      assert(input[0] == ')');
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
    while (input[0] && !isspace(input[0])) input++;
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
    assert((*root)[0]->str() == MODULE);
    for (unsigned i = 1; i < root->size(); i++) {
      parseModuleElement(*(*root)[i]);
    }
  }

private:

  void parseModuleElement(Element& curr) {
    IString id = curr[0]->str();
    if (id == FUNC) return parseFunction(curr);
    std::cerr << "bad module element " << id.str << '\n';
    abort();
  }

  std::map<Name, WasmType> currLocalTypes;

  void parseFunction(Element& s) {
    auto func = allocator.alloc<Function>();
    func->name = s[0]->str();
    for (unsigned i = 1; i < s.size(); i++) {
      Element *curr = s[i];
      IString id = curr[0].str();
      if (id == PARAM) {
        IString name = curr[1].str();
        WasmType type = stringToWasmType(curr[2].str());
        func->params.emplace_back(name, type);
        currLocalTypes[name] = type;
      } else if (id == RESULT) {
        func->result = stringToWasmType(curr[1].str());
      } else {
        func->body = parseExpression(*curr);
      }
    }
    currLocalTypes.clear();
  }

  static WasmType stringToWasmType(IString str) {
    return stringToWasmType(str.str);
  }

  static WasmType stringToWasmType(const char* str) {
    if (str[0] == 'i') {
      if (str[1] == '3') return i32;
      return i64;
    }
    if (str[0] == 'f') {
      if (str[1] == '3') return f32;
      return f64;
    }
    abort();
  }

  Expression* parseExpression(Element& s) {
    IString id = s[0]->str();
    const char *str = id.str;
    const char *dot = strchr(str, '.');
    if (dot) {
      // type.operation (e.g. i32.add)
      WasmType type = stringToWasmType(str);
      const char *op = dot + 1;
      switch (op[0]) {
        case 'a': {
          if (op[1] == 'd') return makeBinary(s, BinaryOp::Add, type);
          if (op[1] == 'n') return makeBinary(s, BinaryOp::And, type);
          abort();
        }
        case 'c': {
          if (op[1] == 'o') {
            if (op[2] == 'p') return makeBinary(s, BinaryOp::CopySign, type);
            if (op[3] == 'n') return makeConvert(s, op[8] == 'u' ? ConvertOp::ConvertUInt32 : ConvertOp::ConvertSInt32, type);
          }
          if (op[1] == 'l') return makeUnary(s, UnaryOp::Clz, type);
          abort();
        }
        case 'd': {
          if (op[1] == 'i') {
            if (op[3] == '_') return makeBinary(s, op[4] == 'u' ? BinaryOp::DivU : BinaryOp::DivS, type);
            if (op[3] == 0) return makeBinary(s, BinaryOp::Div, type);
          }
          abort();
        }
        case 'e': {
          if (op[1] == 'q') return makeCompare(s, RelationalOp::Eq, type);
          abort();
        }
        case 'f': {
          if (op[1] == 'l') return makeUnary(s, UnaryOp::Floor, type);
          abort();
        }
        case 'g': {
          if (op[1] == 't') {
            if (op[2] == '_') return makeCompare(s, op[3] == 'u' ? RelationalOp::GtU : RelationalOp::GtS, type);
            if (op[2] == 0) return makeCompare(s, RelationalOp::Gt, type);
          }
          if (op[1] == 'e') {
            if (op[2] == '_') return makeCompare(s, op[3] == 'u' ? RelationalOp::GeU : RelationalOp::GeS, type);
            if (op[2] == 0) return makeCompare(s, RelationalOp::Ge, type);
          }
          abort();
        }
        case 'l': {
          if (op[1] == 't') {
            if (op[2] == '_') return makeCompare(s, op[3] == 'u' ? RelationalOp::LtU : RelationalOp::LtS, type);
            if (op[2] == 0) return makeCompare(s, RelationalOp::Lt, type);
          }
          if (op[1] == 'e') {
            if (op[2] == '_') return makeCompare(s, op[3] == 'u' ? RelationalOp::LeU : RelationalOp::LeS, type);
            if (op[2] == 0) return makeCompare(s, RelationalOp::Le, type);
          }
          abort();
        }
        case 'm': {
          if (op[1] == 'i') return makeBinary(s, BinaryOp::Min, type);
          if (op[1] == 'a') return makeBinary(s, BinaryOp::Max, type);
          if (op[1] == 'u') return makeBinary(s, BinaryOp::Mul, type);
          abort();
        }
        case 'n': {
          if (op[1] == 'e') {
            if (op[2] == 0) return makeCompare(s, RelationalOp::Ne, type);
            if (op[2] == 'g') return makeUnary(s, UnaryOp::Neg, type);
          }
          abort();
        }
        case 'o': {
          if (op[1] == 'r') return makeBinary(s, BinaryOp::Or, type);
          abort();
        }
        case 'r': {
          if (op[1] == 'e') {
            return makeBinary(s, op[3] == 'u' ? BinaryOp::RemU : BinaryOp::RemS, type);
          }
          abort();
        }
        case 's': {
          if (op[1] == 'h') {
            if (op[2] == 'l') return makeBinary(s, BinaryOp::Shl, type);
            return makeBinary(s, op[4] == 'u' ? BinaryOp::ShrU : BinaryOp::ShrS, type);
          }
          if (op[1] == 'u')  return makeBinary(s, BinaryOp::Sub, type);
          abort();
        }
        case 't': {
          if (op[1] == 'r') return makeConvert(s, ConvertOp::TruncSFloat64, type);
          abort();
        }
        case 'x': {
          if (op[1] == 'o') return makeBinary(s, BinaryOp::Xor, type);
          abort();
        }
        default: abort();
      }
    } else {
      // other expression
      switch (str[0]) {
        case 'g': {
          if (str[1] == 'e') return makeGetLocal(s);
          abort();
        }
        case 's': {
          if (str[1] == 'e') return makeSetLocal(s);
          abort();
        }
        default: abort();
      }
    }
  }

  Expression* makeBinary(Element& s, BinaryOp op, WasmType type) {
    auto ret = allocator.alloc<Binary>();
    ret->op = op;
    ret->left = parseExpression(*s[1]);
    ret->right = parseExpression(*s[2]);
    ret->type = type;
    return ret;
  }

  Expression* makeUnary(Element& s, UnaryOp op, WasmType type) {
    auto ret = allocator.alloc<Unary>();
    ret->op = op;
    ret->value = parseExpression(*s[1]);
    ret->type = type;
    return ret;
  }

  Expression* makeCompare(Element& s, RelationalOp op, WasmType type) {
    auto ret = allocator.alloc<Compare>();
    ret->op = op;
    ret->left = parseExpression(*s[1]);
    ret->right = parseExpression(*s[2]);
    ret->type = type;
    return ret;
  }

  Expression* makeConvert(Element& s, ConvertOp op, WasmType type) {
    auto ret = allocator.alloc<Convert>();
    ret->op = op;
    ret->value = parseExpression(*s[1]);
    ret->type = type;
    return ret;
  }

  Expression* makeGetLocal(Element& s) {
    auto ret = allocator.alloc<GetLocal>();
    ret->name = s[1]->str();
    ret->type = currLocalTypes[ret->name];
    return ret;
  }

  Expression* makeSetLocal(Element& s) {
    auto ret = allocator.alloc<SetLocal>();
    ret->name = s[1]->str();
    ret->value = parseExpression(*s[2]);
    ret->type = currLocalTypes[ret->name];
    return ret;
  }
};

} // namespace wasm

