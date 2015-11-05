
//
// Parses WebAssembly code in S-Expression format, as in .wast files.
//

#include <cmath>
#include <sstream>

#include "wasm.h"
#include "mixed_arena.h"

#define abort_on(str) { std::cerr << "aborting on " << str << '\n'; abort(); }

namespace wasm {

int debug;

using namespace cashew;
// Globals

IString MODULE("module"),
        FUNC("func"),
        PARAM("param"),
        RESULT("result"),
        MEMORY("memory"),
        SEGMENT("segment"),
        EXPORT("export"),
        IMPORT("import"),
        TABLE("table"),
        LOCAL("local"),
        TYPE("type"),
        CALL("call"),
        CALL_IMPORT("call_import"),
        CALL_INDIRECT("call_indirect"),
        INFINITY_("infinity"),
        NEG_INFINITY("-infinity"),
        NAN_("nan");

//
// An element in an S-Expression: a list or a string
//

class Element {
  typedef std::vector<Element*> List;

  bool isList_;
  List list_;
  IString str_;

public:
  Element() : isList_(true) {}

  bool isList() { return isList_; }
  bool isStr() { return !isList_; }

  // list methods

  List& list() {
    assert(isList_);
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
    assert(!isList_);
    return str_;
  }

  const char* c_str() {
    assert(!isList_);
    return str_.str;
  }

  Element* setString(IString str__) {
    isList_ = false;
    str_ = str__;
    return this;
  }

  // printing

  friend std::ostream& operator<<(std::ostream& o, Element& e) {
    if (e.isList_) {
      o << '(';
      for (auto item : e.list_) o << ' ' << *item;
      o << " )";
    } else {
      o << e.str_.str;
    }
    return o;
  }
};

//
// Generic S-Expression parsing into lists
//

class SExpressionParser {
  char *beginning;
  char* input;

  MixedArena allocator;

public:
  // Assumes control of and modifies the input.
  SExpressionParser(char* input) : beginning(input), input(input) {
    root = parseInnerList();
  }

  Element* root;

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
      ret->list().push_back(curr);
    }
  }

  Element* parse() {
    skipWhitespace();
    if (input[0] == 0 || input[0] == ')') return nullptr;
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
    while (1) {
      while (isspace(input[0])) input++;
      if (input[0] == ';' && input[1] == ';') {
        while (input[0] != '\n') input++;
      } else {
        return;
      }
    }
  }

  Element* parseString() {
    if (input[0] == '$') input++; // names begin with $, but we don't need that internally
    char *start = input;
    bool quoted = false;
    if (input[0] == '"') {
      quoted = true;
      start++;
      input = strchr(start, '"');
      assert(input);
      input++;
    } else {
      while (input[0] && !isspace(input[0]) && input[0] != ')') input++;
    }
    char temp = input[0];
    input[0] = 0;
    if (quoted) input[-1] = 0;
    auto ret = allocator.alloc<Element>()->setString(IString(start, false)); // TODO: reuse the string here, carefully
    input[0] = temp;
    return ret;
  }
};

//
// SExpressions => WebAssembly module
//

class SExpressionWasmBuilder {
  Module& wasm;

  MixedArena allocator;

public:
  // Assumes control of and modifies the input.
  SExpressionWasmBuilder(Module& wasm, Element& module) : wasm(wasm) {
    assert(module[0]->str() == MODULE);
    for (unsigned i = 1; i < module.size(); i++) {
      parseModuleElement(*module[i]);
    }
  }

private:

  void parseModuleElement(Element& curr) {
    IString id = curr[0]->str();
    if (id == FUNC) return parseFunction(curr);
    if (id == MEMORY) return parseMemory(curr);
    if (id == EXPORT) return parseExport(curr);
    if (id == IMPORT) return parseImport(curr);
    if (id == TABLE) return parseTable(curr);
    if (id == TYPE) return parseType(curr);
    std::cerr << "bad module element " << id.str << '\n';
    abort();
  }

  std::map<Name, WasmType> currLocalTypes;

  void parseFunction(Element& s) {
    auto func = allocator.alloc<Function>();
    func->name = s[1]->str();
    func->body = nullptr;
    for (unsigned i = 2; i < s.size(); i++) {
      Element& curr = *s[i];
      IString id = curr[0]->str();
      if (id == PARAM) {
        IString name = curr[1]->str();
        WasmType type = stringToWasmType(curr[2]->str());
        func->params.emplace_back(name, type);
        currLocalTypes[name] = type;
      } else if (id == RESULT) {
        func->result = stringToWasmType(curr[1]->str());
      } else if (id == LOCAL) {
        IString name = curr[1]->str();
        WasmType type = stringToWasmType(curr[2]->str());
        func->locals.emplace_back(name, type);
        currLocalTypes[name] = type;
      } else {
        Expression* ex = parseExpression(curr);
        if (!func->body) {
          func->body = ex;
        } else {
          auto block = func->body->dyn_cast<Block>();
          if (!block) {
            block = allocator.alloc<Block>();
            block->list.push_back(func->body);
            func->body = block;
          }
          block->list.push_back(ex);
        }
      }
    }
    wasm.functions.push_back(func);
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

public:
  Expression* parseExpression(Element* s) {
    return parseExpression(*s);
  }

  Expression* parseExpression(Element& s) {
    if (debug) std::cerr << "parse expression " << s << '\n';
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
          abort_on(op);
        }
        case 'c': {
          if (op[1] == 'o') {
            if (op[2] == 'p') return makeBinary(s, BinaryOp::CopySign, type);
            if (op[2] == 'n') {
              if (op[3] == 'v') {
                if (op[8] == 's') return makeConvert(s, op[11] == '3' ? ConvertOp::ConvertSInt32 : ConvertOp::ConvertSInt64, type);
                if (op[8] == 'u') return makeConvert(s, op[11] == '3' ? ConvertOp::ConvertUInt32 : ConvertOp::ConvertUInt64, type);
              }
              if (op[3] == 's') return makeConst(s, type);
            }
          }
          if (op[1] == 'l') return makeUnary(s, UnaryOp::Clz, type);
          abort_on(op);
        }
        case 'd': {
          if (op[1] == 'i') {
            if (op[3] == '_') return makeBinary(s, op[4] == 'u' ? BinaryOp::DivU : BinaryOp::DivS, type);
            if (op[3] == 0) return makeBinary(s, BinaryOp::Div, type);
          }
          if (op[1] == 'e') return makeConvert(s,  ConvertOp::DemoteFloat64, type);
          abort_on(op);
        }
        case 'e': {
          if (op[1] == 'q') return makeCompare(s, RelationalOp::Eq, type);
          if (op[1] == 'x') return makeConvert(s, op[7] == 'u' ? ConvertOp::ExtendUInt32 : ConvertOp::ExtendSInt32, type);
          abort_on(op);
        }
        case 'f': {
          if (op[1] == 'l') return makeUnary(s, UnaryOp::Floor, type);
          abort_on(op);
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
          abort_on(op);
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
          if (op[1] == 'o') return makeLoad(s, type);
          abort_on(op);
        }
        case 'm': {
          if (op[1] == 'i') return makeBinary(s, BinaryOp::Min, type);
          if (op[1] == 'a') return makeBinary(s, BinaryOp::Max, type);
          if (op[1] == 'u') return makeBinary(s, BinaryOp::Mul, type);
          abort_on(op);
        }
        case 'n': {
          if (op[1] == 'e') {
            if (op[2] == 0) return makeCompare(s, RelationalOp::Ne, type);
            if (op[2] == 'g') return makeUnary(s, UnaryOp::Neg, type);
          }
          abort_on(op);
        }
        case 'o': {
          if (op[1] == 'r') return makeBinary(s, BinaryOp::Or, type);
          abort_on(op);
        }
        case 'p': {
          if (op[1] == 'r') return makeConvert(s,  ConvertOp::PromoteFloat32, type);
          abort_on(op);
        }
        case 'r': {
          if (op[1] == 'e') {
            if (op[2] == 'm') return makeBinary(s, op[4] == 'u' ? BinaryOp::RemU : BinaryOp::RemS, type);
            if (op[2] == 'i') return makeConvert(s, isWasmTypeFloat(type) ? ConvertOp::ReinterpretInt : ConvertOp::ReinterpretFloat, type);
          }
          abort_on(op);
        }
        case 's': {
          if (op[1] == 'h') {
            if (op[2] == 'l') return makeBinary(s, BinaryOp::Shl, type);
            return makeBinary(s, op[4] == 'u' ? BinaryOp::ShrU : BinaryOp::ShrS, type);
          }
          if (op[1] == 'u') return makeBinary(s, BinaryOp::Sub, type);
          if (op[1] == 't') return makeStore(s, type);
          abort_on(op);
        }
        case 't': {
          if (op[1] == 'r') {
            if (op[6] == 's') return makeConvert(s, op[9] == '3' ? ConvertOp::TruncSFloat32 : ConvertOp::TruncSFloat64, type);
            if (op[6] == 'u') return makeConvert(s, op[9] == '3' ? ConvertOp::TruncUFloat32 : ConvertOp::TruncUFloat64, type);
            abort();
          }
          abort_on(op);
        }
        case 'w': {
          if (op[1] == 'r') return makeConvert(s,  ConvertOp::WrapInt64, type);
          abort_on(op);
        }
        case 'x': {
          if (op[1] == 'o') return makeBinary(s, BinaryOp::Xor, type);
          abort_on(op);
        }
        default: abort_on(op);
      }
    } else {
      // other expression
      switch (str[0]) {
        case 'b': {
          if (str[1] == 'l') return makeBlock(s);
          if (str[1] == 'r') return makeBreak(s);
          abort_on(str);
        }
        case 'c': {
          if (str[1] == 'a') {
            if (id == CALL) return makeCall(s);
            if (id == CALL_IMPORT) return makeCallImport(s);
            if (id == CALL_INDIRECT) return makeCallIndirect(s);
          }
          abort_on(str);
        }
        case 'g': {
          if (str[1] == 'e') return makeGetLocal(s);
          abort_on(str);
        }
        case 'i': {
          if (str[1] == 'f') return makeIf(s);
          abort_on(str);
        }
        case 'l': {
          if (str[1] == 'o') return makeLoop(s);
          abort_on(str);
        }
        case 'n': {
          if (str[1] == 'o') return allocator.alloc<Nop>();
          abort_on(str);
        }
        case 's': {
          if (str[1] == 'e') return makeSetLocal(s);
          abort_on(str);
        }
        default: abort_on(str);
      }
    }
  }

private:
  Expression* makeBinary(Element& s, BinaryOp op, WasmType type) {
    auto ret = allocator.alloc<Binary>();
    ret->op = op;
    ret->left = parseExpression(s[1]);
    ret->right = parseExpression(s[2]);
    ret->type = type;
    return ret;
  }

  Expression* makeUnary(Element& s, UnaryOp op, WasmType type) {
    auto ret = allocator.alloc<Unary>();
    ret->op = op;
    ret->value = parseExpression(s[1]);
    ret->type = type;
    return ret;
  }

  Expression* makeCompare(Element& s, RelationalOp op, WasmType type) {
    auto ret = allocator.alloc<Compare>();
    ret->op = op;
    ret->left = parseExpression(s[1]);
    ret->right = parseExpression(s[2]);
    ret->inputType = type;
    return ret;
  }

  Expression* makeConvert(Element& s, ConvertOp op, WasmType type) {
    auto ret = allocator.alloc<Convert>();
    ret->op = op;
    ret->value = parseExpression(s[1]);
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
    ret->value = parseExpression(s[2]);
    ret->type = currLocalTypes[ret->name];
    return ret;
  }

  Expression* makeBlock(Element& s) {
    auto ret = allocator.alloc<Block>();
    size_t i = 1;
    if (s[1]->isStr()) {
      ret->name = s[1]->str();
      i++;
    }
    for (; i < s.size(); i++) {
      ret->list.push_back(parseExpression(s[i]));
    }
    return ret;
  }

  Expression* makeConst(Element& s, WasmType type) {
    auto ret = allocator.alloc<Const>();
    ret->type = ret->value.type = type;
    if (isWasmTypeFloat(type)) {
      if (s[1]->str() == INFINITY_) {
        switch (type) {
          case f32: ret->value.f32 = std::numeric_limits<float>::infinity(); break;
          case f64: ret->value.f64 = std::numeric_limits<double>::infinity(); break;
          default: abort();
        }
        return ret;
      }
      if (s[1]->str() == NEG_INFINITY) {
        switch (type) {
          case f32: ret->value.f32 = -std::numeric_limits<float>::infinity(); break;
          case f64: ret->value.f64 = -std::numeric_limits<double>::infinity(); break;
          default: abort();
        }
        return ret;
      }
      if (s[1]->str() == NAN_) {
        switch (type) {
          case f32: ret->value.f32 = std::nan(""); break;
          case f64: ret->value.f64 = std::nan(""); break;
          default: abort();
        }
        return ret;
      }
    }
    const char *str = s[1]->c_str();
    size_t size;
    switch (type) {
      case i32: {
        const char *str = s[1]->c_str();
        std::istringstream istr(str);
        int32_t temp;
        if (str[0] == '0' && str[1] == 'x') {
          uint32_t temp2;
          istr >> std::hex >> temp2;
          temp = temp2;
        } else {
          istr >> temp;
        }
        ret->value.i32 = temp;
        break;
      }
      case i64: {
        const char *str = s[1]->c_str();
        std::istringstream istr(str);
        int64_t temp;
        if (str[0] == '0' && str[1] == 'x') {
          uint64_t temp2;
          istr >> std::hex >> temp2;
          temp = temp2;
        } else {
          istr >> temp;
        }
        ret->value.i64 = temp;
        break;
      }
      case f32: ret->value.f32 = std::stof(str, &size);  break;
      case f64: ret->value.f64 = std::stod(str, &size);  break;
      default: abort();
    }
    return ret;
  }

  Expression* makeLoad(Element& s, WasmType type) {
    const char *extra = strchr(s[0]->c_str(), '.') + 5; // after "type.load"
    auto ret = allocator.alloc<Load>();
    ret->type = type;
    ret->bytes = getWasmTypeSize(type);
    if (extra[0] == '8') {
      ret->bytes = 1;
      extra++;
    } else if (extra[0] == '1') {
      assert(extra[1] == '6');
      ret->bytes = 2;
      extra += 2;
    }
    ret->signed_ = extra[0] && extra[1] == 's';
    size_t i = 1;
    ret->offset = 0;
    ret->align = 0;
    while (!s[i]->isList()) {
      const char *str = s[i]->c_str();
      const char *eq = strchr(str, '=');
      assert(eq);
      eq++;
      if (str[0] == 'a') {
        ret->align = atoi(eq);
      } else if (str[0] == 'o') {
        ret->offset = atoi(eq);
      } else abort();
      i++;
    }
    ret->ptr = parseExpression(s[i]);
    return ret;
  }

  Expression* makeStore(Element& s, WasmType type) {
    const char *extra = strchr(s[0]->c_str(), '.') + 6; // after "type.store"
    auto ret = allocator.alloc<Store>();
    ret->type = type;
    ret->bytes = getWasmTypeSize(type);
    if (extra[0] == '8') {
      ret->bytes = 1;
      extra++;
    } else if (extra[0] == '1') {
      assert(extra[1] == '6');
      ret->bytes = 2;
      extra += 2;
    }
    size_t i = 1;
    ret->offset = 0;
    ret->align = 0;
    while (!s[i]->isList()) {
      const char *str = s[i]->c_str();
      const char *eq = strchr(str, '=');
      assert(eq);
      eq++;
      if (str[0] == 'a') {
        ret->align = atoi(eq);
      } else if (str[0] == 'o') {
        ret->offset = atoi(eq);
      } else abort();
      i++;
    }
    ret->ptr = parseExpression(s[i]);
    ret->value = parseExpression(s[i+1]);
    return ret;
  }

  Expression* makeIf(Element& s) {
    auto ret = allocator.alloc<If>();
    ret->condition = parseExpression(s[1]);
    ret->ifTrue = parseExpression(s[2]);
    if (s.size() == 4) {
      ret->ifFalse = parseExpression(s[3]);
    }
    return ret;
  }

  Expression* makeLoop(Element& s) {
    auto ret = allocator.alloc<Loop>();
    size_t i = 1;
    if (s[i]->isStr()) {
      ret->out = s[i]->str();
      i++;
    }
    if (s[i]->isStr()) {
      ret->in = s[i]->str();
      i++;
    }
    ret->body = parseExpression(s[i]);
    return ret;
  }

  Expression* makeCall(Element& s) {
    auto ret = allocator.alloc<Call>();
    ret->target = s[1]->str();
    parseCallOperands(s, 2, ret);
    return ret;
  }

  Expression* makeCallImport(Element& s) {
    auto ret = allocator.alloc<CallImport>();
    ret->target = s[1]->str();
    parseCallOperands(s, 2, ret);
    return ret;
  }

  Expression* makeCallIndirect(Element& s) {
    auto ret = allocator.alloc<CallIndirect>();
    IString type = s[1]->str();
    assert(wasm.functionTypes.find(type) != wasm.functionTypes.end());
    ret->type = wasm.functionTypes[type];
    ret->target = parseExpression(s[2]);
    parseCallOperands(s, 3, ret);
    return ret;
  }

  template<class T>
  void parseCallOperands(Element& s, size_t i, T* call) {
    while (i < s.size()) {
      call->operands.push_back(parseExpression(s[i]));
      i++;
    }
  }

  Expression* makeBreak(Element& s) {
    auto ret = allocator.alloc<Break>();
    ret->name = s[1]->str();
    if (s.size() == 3) {
      ret->value = parseExpression(s[2]);
    }
    return ret;
  }

  void parseMemory(Element& s) {
    wasm.memory.initial = atoi(s[1]->c_str());
    if (s.size() == 2) return;
    size_t i = 2;
    if (s[i]->isStr()) {
      wasm.memory.max = atoi(s[i]->c_str());
      i++;
    }
    while (i < s.size()) {
      Element& curr = *s[i];
      assert(curr[0]->str() == SEGMENT);
      char *data = strdup(curr[2]->c_str()); // TODO: handle non-null-terminated?
      wasm.memory.segments.emplace_back(atoi(curr[1]->c_str()), data, strlen(data));
      i++;
    }
  }

  void parseExport(Element& s) {
    Export ex;
    ex.name = s[1]->str();
    ex.value = s[2]->str();
    wasm.exports.push_back(ex);
  }

  void parseImport(Element& s) {
    Import im;
    im.name = s[1]->str();
    im.module = s[2]->str();
    im.base = s[3]->str();
    Element& params = *s[4];
    if (params[0]->str() == PARAM) {
      for (size_t i = 1; i < params.size(); i++) {
        im.type.params.push_back(stringToWasmType(params[i]->str()));
      }
    } else {
      abort();
    }
    assert(s.size() == 5);
    wasm.imports[im.name] = im;
  }

  void parseTable(Element& s) {
    for (size_t i = 1; i < s.size(); i++) {
      wasm.table.names.push_back(s[i]->str());
    }
  }

  void parseType(Element& s) {
    auto type = allocator.alloc<FunctionType>();
    type->name = s[1]->str();
    Element& func = *s[2];
    assert(func.isList());
    for (size_t i = 1; i < func.size(); i++) {
      Element& curr = *func[i];
      if (curr[0]->str() == PARAM) {
        for (size_t j = 1; j < curr.size(); j++) {
          type->params.push_back(stringToWasmType(curr[j]->str()));
        }
      } else if (curr[0]->str() == RESULT) {
        type->result = stringToWasmType(curr[1]->str());
      }
    }
    wasm.functionTypes[type->name] = type;
  }
};

} // namespace wasm

