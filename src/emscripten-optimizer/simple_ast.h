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

#ifndef wasm_simple_ast_h
#define wasm_simple_ast_h

#include <algorithm>
#include <cassert>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <functional>
#include <iomanip>
#include <iostream>
#include <limits>
#include <ostream>
#include <set>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include "mixed_arena.h"
#include "parser.h"
#include "snprintf.h"
#include "support/safe_integer.h"

#define errv(str, ...) fprintf(stderr, str "\n", __VA_ARGS__);
#define printErr(str) fprintf(stderr, str "\n");

namespace cashew {

struct Value;
struct Ref;

void dump(const char* str, Ref node, bool pretty = false);

// Reference to a value, plus some operators for convenience
struct Ref {
  Value* inst;

  Ref(Value* v = nullptr) : inst(v) {}

  Value* get() { return inst; }

  Value& operator*() { return *inst; }
  Value* operator->() { return inst; }
  Ref& operator[](unsigned x);
  Ref& operator[](IString x);

  // special conveniences
  bool
  operator==(std::string_view str); // comparison to string, which is by value
  bool operator!=(std::string_view str);
  bool operator==(const IString& str);
  bool operator!=(const IString& str);
  // prevent Ref == number, which is potentially ambiguous; use ->getNumber() ==
  // number
  bool operator==(double d) {
    abort();
    return false;
  }
  bool operator==(Ref other);
  bool operator!(); // check if null, in effect
};

// Arena allocation, free it all on process exit

// A mixed arena for global allocation only, so members do not
// receive an allocator, they all use the global one anyhow
class GlobalMixedArena : public MixedArena {
public:
  template<class T> T* alloc() {
    auto* ret = static_cast<T*>(allocSpace(sizeof(T), alignof(T)));
    new (ret) T();
    return ret;
  }
};

extern GlobalMixedArena arena;

class ArrayStorage : public ArenaVectorBase<ArrayStorage, Ref> {
public:
  void allocate(size_t size) {
    allocatedElements = size;
    data = static_cast<Ref*>(
      arena.allocSpace(sizeof(Ref) * allocatedElements, alignof(Ref)));
  }
};

struct Assign;
struct AssignName;

// Main value type
struct Value {
  enum Type {
    String = 0,
    Number = 1,
    Array = 2,
    Null = 3,
    Bool = 4,
    Object = 5,
    Assign_ = 6, // ref = target
    AssignName_ = 7
  };

  Type type = Null;

  using ObjectStorage = std::unordered_map<IString, Ref>;

  // MSVC does not allow unrestricted unions:
  // http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2008/n2544.pdf
#ifdef _MSC_VER
  IString str;
#endif
  union { // TODO: optimize
#ifndef _MSC_VER
    IString str;
#endif
    double num;
    ArrayStorage* arr;
    bool boo;
    ObjectStorage* obj;
    Ref ref;
  };

  // constructors all copy their input
  Value() {}
  explicit Value(const char* s) { setString(s); }
  explicit Value(double n) { setNumber(n); }
  explicit Value(ArrayStorage& a) {
    setArray();
    *arr = a;
  }
  // no bool constructor - would endanger the double one (int might convert the
  // wrong way)

  ~Value() { free(); }

  void free() {
    if (type == Array) {
      arr->clear();
    } else if (type == Object) {
      delete obj;
    }
    type = Null;
    num = 0;
  }

  Value& setString(const char* s) {
    free();
    type = String;
    str = IString(s);
    return *this;
  }
  Value& setString(const IString& s) {
    free();
    type = String;
    str = s;
    return *this;
  }
  Value& setNumber(double n) {
    free();
    type = Number;
    num = n;
    return *this;
  }
  Value& setArray(ArrayStorage& a) {
    free();
    type = Array;
    arr = arena.alloc<ArrayStorage>();
    *arr = a;
    return *this;
  }
  Value& setArray(size_t size_hint = 0) {
    free();
    type = Array;
    arr = arena.alloc<ArrayStorage>();
    arr->reserve(size_hint);
    return *this;
  }
  Value& setNull() {
    free();
    type = Null;
    return *this;
  }
  // Bool in the name, as otherwise might overload over int
  Value& setBool(bool b) {
    free();
    type = Bool;
    boo = b;
    return *this;
  }
  Value& setObject() {
    free();
    type = Object;
    obj = new ObjectStorage();
    return *this;
  }
  Value& setAssign(Ref target, Ref value);
  Value& setAssignName(IString target, Ref value);

  bool isString() { return type == String; }
  bool isNumber() { return type == Number; }
  bool isArray() { return type == Array; }
  bool isNull() { return type == Null; }
  bool isBool() { return type == Bool; }
  bool isObject() { return type == Object; }
  bool isAssign() { return type == Assign_; }
  bool isAssignName() { return type == AssignName_; }

  // avoid overloading == as it might overload over int
  bool isBool(bool b) { return type == Bool && b == boo; }

  // convenience function to check if something is an array and
  // also has a certain string as the first element. This is a
  // very common operation as the first element defines the node
  // type for most ast nodes
  bool isArray(IString name) { return isArray() && (*this)[0] == name; }

  const char* getCString() {
    assert(isString());
    return str.str.data();
  }
  IString& getIString() {
    assert(isString());
    return str;
  }
  double& getNumber() {
    assert(isNumber());
    return num;
  }
  ArrayStorage& getArray() {
    assert(isArray());
    return *arr;
  }
  bool& getBool() {
    assert(isBool());
    return boo;
  }

  Assign* asAssign();
  AssignName* asAssignName();

  int32_t getInteger() { // convenience function to get a known integer
    assert(wasm::isInteger(getNumber()));
    int32_t ret = getNumber();
    assert(double(ret) == getNumber()); // no loss in conversion
    return ret;
  }

  Value& operator=(const Value& other) {
    free();
    switch (other.type) {
      case String:
        setString(other.str);
        break;
      case Number:
        setNumber(other.num);
        break;
      case Array:
        setArray(*other.arr);
        break;
      case Null:
        setNull();
        break;
      case Bool:
        setBool(other.boo);
        break;
      default:
        abort(); // TODO
    }
    return *this;
  }

  bool operator==(const Value& other) const {
    if (type != other.type) {
      return false;
    }
    switch (other.type) {
      case String:
        return str == other.str;
      case Number:
        return num == other.num;
      case Array:
        return this == &other; // if you want a deep compare, use deepCompare
      case Null:
        break;
      case Bool:
        return boo == other.boo;
      case Object:
        return this == &other; // if you want a deep compare, use deepCompare
      default:
        abort();
    }
    return true;
  }

  char* parse(char* curr) {
  /* space, tab, linefeed/newline, or return */
#define is_json_space(x) (x == 32 || x == 9 || x == 10 || x == 13)
#define skip()                                                                 \
  {                                                                            \
    while (*curr && is_json_space(*curr))                                      \
      curr++;                                                                  \
  }
    skip();
    if (*curr == '"') {
      // String
      curr++;
      char* close = strchr(curr, '"');
      assert(close);
      *close = 0; // end this string, and reuse it straight from the input
      setString(curr);
      curr = close + 1;
    } else if (*curr == '[') {
      // Array
      curr++;
      skip();
      setArray();
      while (*curr != ']') {
        Ref temp = arena.alloc<Value>();
        arr->push_back(temp);
        curr = temp->parse(curr);
        skip();
        if (*curr == ']') {
          break;
        }
        assert(*curr == ',');
        curr++;
        skip();
      }
      curr++;
    } else if (*curr == 'n') {
      // Null
      assert(strncmp(curr, "null", 4) == 0);
      setNull();
      curr += 4;
    } else if (*curr == 't') {
      // Bool true
      assert(strncmp(curr, "true", 4) == 0);
      setBool(true);
      curr += 4;
    } else if (*curr == 'f') {
      // Bool false
      assert(strncmp(curr, "false", 5) == 0);
      setBool(false);
      curr += 5;
    } else if (*curr == '{') {
      // Object
      curr++;
      skip();
      setObject();
      while (*curr != '}') {
        assert(*curr == '"');
        curr++;
        char* close = strchr(curr, '"');
        assert(close);
        *close = 0; // end this string, and reuse it straight from the input
        IString key(curr);
        curr = close + 1;
        skip();
        assert(*curr == ':');
        curr++;
        skip();
        Ref value = arena.alloc<Value>();
        curr = value->parse(curr);
        (*obj)[key] = value;
        skip();
        if (*curr == '}') {
          break;
        }
        assert(*curr == ',');
        curr++;
        skip();
      }
      curr++;
    } else {
      // Number
      char* after;
      setNumber(strtod(curr, &after));
      curr = after;
    }
    return curr;
  }

  void stringify(std::ostream& os, bool pretty = false);

  // String operations

  // Number operations

  // Array operations

  size_t size() {
    assert(isArray());
    return arr->size();
  }

  bool empty() { return size() == 0; }

  void setSize(size_t size) {
    assert(isArray());
    auto old = arr->size();
    if (old != size) {
      arr->resize(size);
    }
    if (old < size) {
      for (auto i = old; i < size; i++) {
        (*arr)[i] = arena.alloc<Value>();
      }
    }
  }

  Ref& operator[](unsigned x) {
    assert(isArray());
    return (*arr)[x];
  }

  Value& push_back(Ref r) {
    assert(isArray());
    arr->push_back(r);
    return *this;
  }
  Ref pop_back() {
    assert(isArray());
    Ref ret = arr->back();
    arr->pop_back();
    return ret;
  }

  Ref back() {
    assert(isArray());
    if (arr->size() == 0) {
      return nullptr;
    }
    return arr->back();
  }

  void splice(int x, int num) {
    assert(isArray());
    arr->erase(arr->begin() + x, arr->begin() + x + num);
  }

  int indexOf(Ref other) {
    assert(isArray());
    for (size_t i = 0; i < arr->size(); i++) {
      if (other == (*arr)[i]) {
        return i;
      }
    }
    return -1;
  }

  Ref map(std::function<Ref(Ref node)> func) {
    assert(isArray());
    Ref ret = arena.alloc<Value>();
    ret->setArray();
    for (size_t i = 0; i < arr->size(); i++) {
      ret->push_back(func((*arr)[i]));
    }
    return ret;
  }

  Ref filter(std::function<bool(Ref node)> func) {
    assert(isArray());
    Ref ret = arena.alloc<Value>();
    ret->setArray();
    for (size_t i = 0; i < arr->size(); i++) {
      Ref curr = (*arr)[i];
      if (func(curr)) {
        ret->push_back(curr);
      }
    }
    return ret;
  }

  /*
  void forEach(std::function<void (Ref)> func) {
    for (size_t i = 0; i < arr->size(); i++) {
      func((*arr)[i]);
    }
  }
  */

  // Null operations

  // Bool operations

  // Object operations

  Ref& operator[](IString x) {
    assert(isObject());
    return (*obj)[x];
  }

  bool has(IString x) {
    assert(isObject());
    return obj->count(x) > 0;
  }
};

struct Assign : public Value {
  Ref value_;

  Assign(Ref targetInit, Ref valueInit) {
    type = Assign_;
    target() = targetInit;
    value() = valueInit;
  }

  Assign() : Assign(nullptr, nullptr) {}

  Ref& target() { return ref; }
  Ref& value() { return value_; }
};

struct AssignName : public Value {
  IString target_;

  AssignName(IString targetInit, Ref valueInit) {
    type = AssignName_;
    target() = targetInit;
    value() = valueInit;
  }

  AssignName() : AssignName(IString(), nullptr) {}

  IString& target() { return target_; }
  Ref& value() { return ref; }
};

// JS printing support

struct JSPrinter {
  bool pretty, finalize;

  char* buffer = nullptr;
  size_t size = 0;
  size_t used = 0;

  int indent = 0;
  bool possibleSpace = false; // add a space to separate identifiers

  Ref ast;

  JSPrinter(bool pretty_, bool finalize_, Ref ast_)
    : pretty(pretty_), finalize(finalize_), ast(ast_) {}

  ~JSPrinter() { free(buffer); }

  void printAst() {
    print(ast);
    ensure(1);
    buffer[used] = 0;
  }

  // Utils

  void ensure(int safety = 100) {
    if (size >= used + safety) {
      return;
    }
    size = std::max((size_t)1024, size * 2) + safety;
    if (!buffer) {
      buffer = (char*)malloc(size);
      if (!buffer) {
        errv("Out of memory allocating %zd bytes for output buffer!", size);
        abort();
      }
    } else {
      char* buf = (char*)realloc(buffer, size);
      if (!buf) {
        free(buffer);
        errv("Out of memory allocating %zd bytes for output buffer!", size);
        abort();
      }
      buffer = buf;
    }
  }

  void emit(char c) {
    maybeSpace(c);
    if (!pretty && c == '}' && buffer[used - 1] == ';') {
      used--; // optimize ;} into }, the ; is not separating anything
    }
    ensure(1);
    buffer[used++] = c;
  }

  void emit(const char* s) {
    maybeSpace(*s);
    int len = strlen(s);
    ensure(len + 1);
    strncpy(buffer + used, s, len + 1);
    used += len;
  }

  void newline() {
    if (!pretty) {
      return;
    }
    emit('\n');
    for (int i = 0; i < indent; i++) {
      emit(' ');
    }
  }

  void space() {
    if (pretty) {
      emit(' ');
    }
  }

  void safeSpace() {
    if (pretty) {
      emit(' ');
    } else {
      possibleSpace = true;
    }
  }

  void maybeSpace(char s) {
    if (possibleSpace) {
      possibleSpace = false;
      if (isIdentPart(s)) {
        emit(' ');
      }
    }
  }

  bool isNothing(Ref node) {
    return node->isArray() && node[0] == TOPLEVEL && node[1]->size() == 0;
  }

  bool isDefun(Ref node) { return node->isArray() && node[0] == DEFUN; }

  bool endsInBlock(Ref node) {
    if (node->isArray() && node[0] == BLOCK) {
      return true;
    }
    // Check for a label on a block
    if (node->isArray() && node[0] == LABEL && endsInBlock(node[2])) {
      return true;
    }
    // Check for an if
    if (node->isArray() && node[0] == IF &&
        endsInBlock(ifHasElse(node) ? node[3] : node[2])) {
      return true;
    }
    return false;
  }

  bool isIf(Ref node) { return node->isArray() && node[0] == IF; }

  void print(Ref node) {
    ensure();
    if (node->isString()) {
      printName(node);
      return;
    }
    if (node->isNumber()) {
      printNum(node);
      return;
    }
    if (node->isAssignName()) {
      printAssignName(node);
      return;
    }
    if (node->isAssign()) {
      printAssign(node);
      return;
    }
    IString type = node[0]->getIString();
    switch (type.str[0]) {
      case 'a': {
        if (type == ARRAY) {
          printArray(node);
        } else {
          abort();
        }
        break;
      }
      case 'b': {
        if (type == BINARY) {
          printBinary(node);
        } else if (type == BLOCK) {
          printBlock(node);
        } else if (type == BREAK) {
          printBreak(node);
        } else {
          abort();
        }
        break;
      }
      case 'c': {
        if (type == CALL) {
          printCall(node);
        } else if (type == CONDITIONAL) {
          printConditional(node);
        } else if (type == CONTINUE) {
          printContinue(node);
        } else {
          abort();
        }
        break;
      }
      case 'd': {
        if (type == DEFUN) {
          printDefun(node);
        } else if (type == DO) {
          printDo(node);
        } else if (type == DOT) {
          printDot(node);
        } else {
          abort();
        }
        break;
      }
      case 'i': {
        if (type == IF) {
          printIf(node);
        } else {
          abort();
        }
        break;
      }
      case 'l': {
        if (type == LABEL) {
          printLabel(node);
        } else {
          abort();
        }
        break;
      }
      case 'n': {
        if (type == NEW) {
          printNew(node);
        } else {
          abort();
        }
        break;
      }
      case 'o': {
        if (type == OBJECT) {
          printObject(node);
        }
        break;
      }
      case 'r': {
        if (type == RETURN) {
          printReturn(node);
        } else {
          abort();
        }
        break;
      }
      case 's': {
        if (type == SUB) {
          printSub(node);
        } else if (type == SEQ) {
          printSeq(node);
        } else if (type == SWITCH) {
          printSwitch(node);
        } else if (type == STRING) {
          printString(node);
        } else {
          abort();
        }
        break;
      }
      case 't': {
        if (type == TOPLEVEL) {
          printToplevel(node);
        } else if (type == TRY) {
          printTry(node);
        } else {
          abort();
        }
        break;
      }
      case 'u': {
        if (type == UNARY_PREFIX) {
          printUnaryPrefix(node);
        } else {
          abort();
        }
        break;
      }
      case 'v': {
        if (type == VAR) {
          printVar(node);
        } else {
          abort();
        }
        break;
      }
      case 'w': {
        if (type == WHILE) {
          printWhile(node);
        } else {
          abort();
        }
        break;
      }
      default: {
        errv("cannot yet print %s\n", type.str.data());
        abort();
      }
    }
  }

  // print a node, and if nothing is emitted, emit something instead
  void print(Ref node, const char* otherwise) {
    auto last = used;
    print(node);
    if (used == last) {
      emit(otherwise);
    }
  }

  void printStats(Ref stats) {
    bool first = true;
    for (size_t i = 0; i < stats->size(); i++) {
      Ref curr = stats[i];
      if (!isNothing(curr)) {
        if (first) {
          first = false;
        } else {
          newline();
        }
        print(curr);
        if (!isDefun(curr) && !endsInBlock(curr) && !isIf(curr)) {
          emit(';');
        }
      }
    }
  }

  void printToplevel(Ref node) {
    if (node[1]->size() > 0) {
      printStats(node[1]);
    }
  }

  void printBlock(Ref node) {
    if (node->size() == 1 || node[1]->size() == 0) {
      emit("{}");
      return;
    }
    emit('{');
    indent++;
    newline();
    printStats(node[1]);
    indent--;
    newline();
    emit('}');
  }

  void printDefun(Ref node) {
    emit("function ");
    emit(node[1]->getCString());
    emit('(');
    Ref args = node[2];
    for (size_t i = 0; i < args->size(); i++) {
      if (i > 0) {
        (pretty ? emit(", ") : emit(','));
      }
      emit(args[i]->getCString());
    }
    emit(')');
    space();
    if (node->size() == 3 || node[3]->size() == 0) {
      emit("{}");
      return;
    }
    emit('{');
    indent++;
    newline();
    printStats(node[3]);
    indent--;
    newline();
    emit('}');
    newline();
  }

  void printAssign(Ref node) {
    auto* assign = node->asAssign();
    printChild(assign->target(), node, -1);
    space();
    emit('=');
    space();
    printChild(assign->value(), node, 1);
  }

  void printAssignName(Ref node) {
    auto* assign = node->asAssignName();
    emit(assign->target().str.data());
    space();
    emit('=');
    space();
    printChild(assign->value(), node, 1);
  }

  void printName(Ref node) { emit(node->getCString()); }

  static char* numToString(double d, bool finalize = true) {
    if (std::isnan(d)) {
      if (std::signbit(d)) {
        return (char*)"-NaN";
      } else {
        return (char*)"NaN";
      }
    } else if (!std::isfinite(d)) {
      if (std::signbit(d)) {
        return (char*)"-Infinity";
      } else {
        return (char*)"Infinity";
      }
    }
    bool neg = d < 0;
    if (neg) {
      d = -d;
    }
    // try to emit the fewest necessary characters
    bool integer = wasm::isInteger(d);
#define BUFFERSIZE 1000
    // f is normal, e is scientific for float, x for integer
    // These need to be thread-local because they are returned.
    thread_local char full_storage_f[BUFFERSIZE];
    thread_local char full_storage_e[BUFFERSIZE];
    // full has one more char, for a possible '-'
    char* storage_f = full_storage_f + 1;
    char* storage_e = full_storage_e + 1;
    auto err_f = std::numeric_limits<double>::quiet_NaN();
    auto err_e = std::numeric_limits<double>::quiet_NaN();
    for (int e = 0; e <= 1; e++) {
      char* buffer = e ? storage_e : storage_f;
      double temp;
      if (!integer) {
        char format[6];
        for (int i = 0; i <= 18; i++) {
          format[0] = '%';
          format[1] = '.';
          if (i < 10) {
            format[2] = '0' + i;
            format[3] = e ? 'e' : 'f';
            format[4] = 0;
          } else {
            format[2] = '1';
            format[3] = '0' + (i - 10);
            format[4] = e ? 'e' : 'f';
            format[5] = 0;
          }
          snprintf(buffer, BUFFERSIZE - 1, format, d);
          sscanf(buffer, "%lf", &temp);
          // errv("%.18f, %.18e   =>   %s   =>   %.18f, %.18e   (%d), ", d, d,
          // buffer, temp, temp, temp == d);
          if (temp == d) {
            break;
          }
        }
      } else {
        // integer
        assert(d >= 0);
        if (wasm::isUInteger64(d)) {
          unsigned long long uu = wasm::toUInteger64(d);
          bool asHex = e && !finalize;
          snprintf(buffer, BUFFERSIZE - 1, asHex ? "0x%llx" : "%llu", uu);
          if (asHex) {
            unsigned long long tempULL;
            sscanf(buffer, "%llx", &tempULL);
            temp = (double)tempULL;
          } else {
            sscanf(buffer, "%lf", &temp);
          }
        } else {
          // too large for a machine integer, just use floats
          // even on integers, e with a dot is useful, e.g. 1.2e+200
          snprintf(buffer, BUFFERSIZE - 1, e ? "%e" : "%.0f", d);
          sscanf(buffer, "%lf", &temp);
        }
        // errv("%.18f, %.18e   =>   %s   =>   %.18f, %.18e, %llu   (%d)\n", d,
        //      d, buffer, temp, temp, uu, temp == d);
      }
      (e ? err_e : err_f) = fabs(temp - d);
      // errv("current attempt: %.18f  =>  %s", d, buffer);
      // assert(temp == d);
      char* dot = strchr(buffer, '.');
      if (dot) {
        // remove trailing zeros
        char* end = dot + 1;
        while (*end >= '0' && *end <= '9') {
          end++;
        }
        end--;
        while (*end == '0') {
          char* copy = end;
          do {
            copy[0] = copy[1];
          } while (*copy++ != 0);
          end--;
        }
        // errv("%.18f  =>   %s", d, buffer);
        // remove preceding zeros
        while (*buffer == '0') {
          char* copy = buffer;
          do {
            copy[0] = copy[1];
          } while (*copy++ != 0);
        }
        // errv("%.18f ===>  %s", d, buffer);
      } else if (!integer || !e) {
        // no dot. try to change 12345000 => 12345e3
        char* end = strchr(buffer, 0);
        end--;
        char* test = end;
        // remove zeros, and also doubles can use at most 24 digits, we can
        // truncate any extras even if not zero
        while ((*test == '0' || test - buffer > 24) && test > buffer) {
          test--;
        }
        int num = end - test;
        if (num >= 3) {
          test++;
          test[0] = 'e';
          if (num < 10) {
            test[1] = '0' + num;
            test[2] = 0;
          } else if (num < 100) {
            test[1] = '0' + (num / 10);
            test[2] = '0' + (num % 10);
            test[3] = 0;
          } else {
            assert(num < 1000);
            test[1] = '0' + (num / 100);
            test[2] = '0' + (num % 100) / 10;
            test[3] = '0' + (num % 10);
            test[4] = 0;
          }
        }
      }
      // errv("..current attempt: %.18f  =>  %s", d, buffer);
    }
    // fprintf(stderr, "options:\n%s\n%s\n (first? %d)\n", storage_e, storage_f,
    //         strlen(storage_e) < strlen(storage_f));
    char* ret;
    if (err_e == err_f) {
      ret = strlen(storage_e) < strlen(storage_f) ? storage_e : storage_f;
    } else {
      ret = err_e < err_f ? storage_e : storage_f;
    }
    if (neg) {
      ret--; // safe to go back one, there is one more char in full_*
      *ret = '-';
    }
    return ret;
  }

  void printNum(Ref node) {
    if (node->getNumber() < 0 && buffer[used - 1] == '-') {
      emit(' '); // cannot join - and - to --, looks like the -- operator
    }
    emit(numToString(node->getNumber(), finalize));
  }

  void printString(Ref node) {
    emit('"');
    emit(node[1]->getCString());
    emit('"');
  }

  // Parens optimizing

  bool capturesOperators(Ref node) {
    Ref type = node[0];
    return type == CALL || type == ARRAY || type == OBJECT || type == SEQ;
  }

  int getPrecedence(Ref node, bool parent) {
    if (node->isAssign() || node->isAssignName()) {
      return OperatorClass::getPrecedence(OperatorClass::Binary, SET);
    }
    if (!node->isArray()) {
      // node is a value
      return -1;
    }
    Ref type = node[0];
    if (type == BINARY || type == UNARY_PREFIX) {
      return OperatorClass::getPrecedence(
        type == BINARY ? OperatorClass::Binary : OperatorClass::Prefix,
        node[1]->getIString());
    } else if (type == SEQ) {
      return OperatorClass::getPrecedence(OperatorClass::Binary, COMMA);
    } else if (type == CALL) {
      // call arguments are split by commas, but call itself is safe
      return parent ? OperatorClass::getPrecedence(OperatorClass::Binary, COMMA)
                    : -1;
    } else if (type == CONDITIONAL) {
      return OperatorClass::getPrecedence(OperatorClass::Tertiary, QUESTION);
    }
    // otherwise, this is something that fixes precedence explicitly, and we can
    // ignore
    return -1; // XXX
  }

  // check whether we need parens for the child, when rendered in the parent
  // @param childPosition -1 means it is printed to the left of parent, 0 means
  //        "anywhere", 1 means right
  bool needParens(Ref parent, Ref child, int childPosition) {
    int parentPrecedence = getPrecedence(parent, true);
    int childPrecedence = getPrecedence(child, false);

    if (childPrecedence > parentPrecedence) {
      return true; // child is definitely a danger
    }
    if (childPrecedence < parentPrecedence) {
      return false; //          definitely cool
    }
    // equal precedence, so associativity (rtl/ltr) is what matters
    // (except for some exceptions, where multiple operators can combine into
    // confusion)
    if (parent->isArray() && parent[0] == UNARY_PREFIX) {
      assert(child[0] == UNARY_PREFIX);
      if ((parent[1] == PLUS || parent[1] == MINUS) && child[1] == parent[1]) {
        // cannot emit ++x when we mean +(+x)
        return true;
      }
    }
    if (childPosition == 0) {
      return true; // child could be anywhere, so always paren
    }
    if (childPrecedence < 0) {
      return false; // both precedences are safe
    }
    // check if child is on the dangerous side
    if (OperatorClass::getRtl(parentPrecedence)) {
      return childPosition < 0;
    } else {
      return childPosition > 0;
    }
  }

  void printChild(Ref child, Ref parent, int childPosition = 0) {
    bool parens = needParens(parent, child, childPosition);
    if (parens) {
      emit('(');
    }
    print(child);
    if (parens) {
      emit(')');
    }
  }

  void printBinary(Ref node) {
    printChild(node[2], node, -1);
    space();
    emit(node[1]->getCString());
    space();
    printChild(node[3], node, 1);
  }

  void printUnaryPrefix(Ref node) {
    if (finalize && node[1] == PLUS &&
        (node[2]->isNumber() ||
         (node[2]->isArray() && node[2][0] == UNARY_PREFIX &&
          node[2][1] == MINUS && node[2][2]->isNumber()))) {
      // emit a finalized number
      int last = used;
      print(node[2]);
      ensure(1);                  // we temporarily append a 0
      char* curr = buffer + last; // ensure might invalidate
      buffer[used] = 0;
      if (strstr(curr, "Infinity")) {
        return;
      }
      if (strstr(curr, "NaN")) {
        return;
      }
      if (strchr(curr, '.')) {
        return; // already a decimal point, all good
      }
      char* e = strchr(curr, 'e');
      if (!e) {
        emit(".0");
        return;
      }
      ensure(3);
      curr = buffer + last; // ensure might invalidate
      char* end = strchr(curr, 0);
      while (end >= e) {
        end[2] = end[0];
        end--;
      }
      e[0] = '.';
      e[1] = '0';
      used += 2;
      return;
    }
    if ((buffer[used - 1] == '-' && node[1] == MINUS) ||
        (buffer[used - 1] == '+' && node[1] == PLUS)) {
      emit(' '); // cannot join - and - to --, looks like the -- operator
    }
    emit(node[1]->getCString());
    printChild(node[2], node, 1);
  }

  void printConditional(Ref node) {
    printChild(node[1], node, -1);
    space();
    emit('?');
    space();
    printChild(node[2], node, 0);
    space();
    emit(':');
    space();
    printChild(node[3], node, 1);
  }

  void printCall(Ref node) {
    printChild(node[1], node, 0);
    emit('(');
    Ref args = node[2];
    for (size_t i = 0; i < args->size(); i++) {
      if (i > 0) {
        (pretty ? emit(", ") : emit(','));
      }
      printChild(args[i], node, 0);
    }
    emit(')');
  }

  void printSeq(Ref node) {
    printChild(node[1], node, -1);
    emit(',');
    space();
    printChild(node[2], node, 1);
  }

  void printDot(Ref node) {
    print(node[1]);
    emit('.');
    emit(node[2]->getCString());
  }

  void printSwitch(Ref node) {
    emit("switch");
    space();
    emit('(');
    print(node[1]);
    emit(')');
    space();
    emit('{');
    newline();
    Ref cases = node[2];
    for (size_t i = 0; i < cases->size(); i++) {
      Ref c = cases[i];
      if (!c[0]) {
        emit("default:");
      } else {
        emit("case ");
        print(c[0]);
        emit(':');
      }
      if (c[1]->size() > 0) {
        indent++;
        newline();
        auto curr = used;
        printStats(c[1]);
        indent--;
        if (curr != used) {
          newline();
        } else {
          used--; // avoid the extra indentation we added tentatively
        }
      } else {
        newline();
      }
    }
    emit('}');
  }

  void printTry(Ref node) {
    emit("try ");
    printBlock(node[1]);
    emit(" catch (");
    printName(node[2]);
    emit(") ");
    printBlock(node[3]);
  }

  void printSub(Ref node) {
    printChild(node[1], node, -1);
    emit('[');
    print(node[2]);
    emit(']');
  }

  void printVar(Ref node) {
    emit("var ");
    Ref args = node[1];
    for (size_t i = 0; i < args->size(); i++) {
      if (i > 0) {
        (pretty ? emit(", ") : emit(','));
      }
      emit(args[i][0]->getCString());
      if (args[i]->size() > 1) {
        space();
        emit('=');
        space();
        print(args[i][1]);
      }
    }
  }

  static bool isBlock(Ref node) {
    return node->isArray() && !node->empty() && node[0] == BLOCK;
  }

  static bool ifHasElse(Ref node) {
    assert(node->isArray() && node[0] == IF);
    return node->size() >= 4 && !!node[3];
  }

  void printIf(Ref node) {
    emit("if");
    safeSpace();
    emit('(');
    print(node[1]);
    emit(')');
    space();
    bool emitsBracesAnyhow = isBlock(node[2]);
    if (!emitsBracesAnyhow) {
      emit('{');
      indent++;
      newline();
    }
    print(node[2]);
    if (!emitsBracesAnyhow) {
      indent--;
      newline();
      emit('}');
    }
    if (ifHasElse(node)) {
      space();
      emit("else");
      safeSpace();
      bool emitsBracesAnyhow = isBlock(node[3]);
      if (!emitsBracesAnyhow) {
        emit('{');
        indent++;
        newline();
      }
      print(node[3]);
      if (!emitsBracesAnyhow) {
        indent--;
        newline();
        emit('}');
      }
    }
  }

  void printDo(Ref node) {
    emit("do");
    safeSpace();
    print(node[2], "{}");
    space();
    emit("while");
    space();
    emit('(');
    print(node[1]);
    emit(')');
  }

  void printWhile(Ref node) {
    emit("while");
    space();
    emit('(');
    print(node[1]);
    emit(')');
    space();
    print(node[2], "{}");
  }

  void printLabel(Ref node) {
    emit(node[1]->getCString());
    space();
    emit(':');
    space();
    print(node[2]);
  }

  void printReturn(Ref node) {
    emit("return");
    if (!!node[1]) {
      emit(' ');
      print(node[1]);
    }
  }

  void printBreak(Ref node) {
    emit("break");
    if (!!node[1]) {
      emit(' ');
      emit(node[1]->getCString());
    }
  }

  void printContinue(Ref node) {
    emit("continue");
    if (!!node[1]) {
      emit(' ');
      emit(node[1]->getCString());
    }
  }

  void printNew(Ref node) {
    emit("new ");
    print(node[1]);
  }

  void printArray(Ref node) {
    emit('[');
    Ref args = node[1];
    for (size_t i = 0; i < args->size(); i++) {
      if (i > 0) {
        (pretty ? emit(", ") : emit(','));
      }
      print(args[i]);
    }
    emit(']');
  }

  void printObject(Ref node) {
    emit('{');
    indent++;
    newline();
    Ref args = node[1];
    for (size_t i = 0; i < args->size(); i++) {
      if (i > 0) {
        pretty ? emit(", ") : emit(',');
        newline();
      }
      bool needQuote = false;
      const char* getterSetter = nullptr;
      const char* setterParam = nullptr;
      const char* str;
      if (args[i][0]->isArray()) {
        if (args[i][0][0] == STRING) {
          // A quoted string.
          needQuote = true;
          str = args[i][0][1]->getCString();
        } else if (args[i][0][0] == GETTER) {
          getterSetter = GETTER.str.data();
          str = args[i][0][1]->getCString();
        } else if (args[i][0][0] == SETTER) {
          getterSetter = SETTER.str.data();
          str = args[i][0][1]->getCString();
          setterParam = args[i][0][2]->getCString();
        } else {
          abort();
        }
      } else {
        // Just a raw string, no quotes.
        str = args[i][0]->getCString();
      }
      const char* check = str;
      while (*check) {
        if (!isalnum(*check) && *check != '_' && *check != '$') {
          needQuote = true;
          break;
        }
        check++;
      }
      if (getterSetter != nullptr) {
        emit(getterSetter);
        space();
      }
      if (needQuote) {
        emit('"');
      }
      emit(str);
      if (needQuote) {
        emit('"');
      }
      if (getterSetter != nullptr) {
        emit('(');
        if (setterParam != nullptr) {
          emit(setterParam);
        }
        emit(')');
      } else {
        emit(":");
      }
      space();
      print(args[i][1]);
    }
    indent--;
    newline();
    emit('}');
  }
};

// cashew builder

class ValueBuilder {
  static Ref makeRawString(const IString& s) {
    return &arena.alloc<Value>()->setString(s);
  }

  static Ref makeNull() { return &arena.alloc<Value>()->setNull(); }

public:
  static Ref makeRawArray(int size_hint = 0) {
    return &arena.alloc<Value>()->setArray(size_hint);
  }

  static Ref makeToplevel() {
    return &makeRawArray(2)
              ->push_back(makeRawString(TOPLEVEL))
              .push_back(makeRawArray());
  }

  static Ref makeString(IString str) {
    return &makeRawArray(2)
              ->push_back(makeRawString(STRING))
              .push_back(makeRawString(str));
  }

  static Ref makeBlock() {
    return &makeRawArray(2)
              ->push_back(makeRawString(BLOCK))
              .push_back(makeRawArray());
  }

  static Ref makeName(IString name) { return makeRawString(name); }

  static void setBlockContent(Ref target, Ref block) {
    if (target[0] == TOPLEVEL) {
      target[1]->setArray(block[1]->getArray());
    } else if (target[0] == DEFUN) {
      target[3]->setArray(block[1]->getArray());
    } else {
      abort();
    }
  }

  static void appendToBlock(Ref block, Ref element) {
    assert(block[0] == BLOCK);
    block[1]->push_back(element);
  }

  static Ref makeCall(Ref target) {
    return &makeRawArray(3)
              ->push_back(makeRawString(CALL))
              .push_back(target)
              .push_back(makeRawArray());
  }
  static Ref makeCall(Ref target, Ref arg) {
    Ref ret = &makeRawArray(3)
                 ->push_back(makeRawString(CALL))
                 .push_back(target)
                 .push_back(makeRawArray());
    ret[2]->push_back(arg);
    return ret;
  }
  static Ref makeCall(IString target) {
    Ref ret = &makeRawArray(3)
                 ->push_back(makeRawString(CALL))
                 .push_back(makeName(target))
                 .push_back(makeRawArray());
    return ret;
  }

  template<typename... Ts> static Ref makeCall(IString target, Ts... args) {
    size_t nArgs = sizeof...(Ts);
    Ref callArgs = makeRawArray(nArgs);
    Ref argArray[] = {args...};
    for (size_t i = 0; i < nArgs; ++i) {
      callArgs->push_back(argArray[i]);
    }
    return &makeRawArray(3)
              ->push_back(makeRawString(CALL))
              .push_back(makeName(target))
              .push_back(callArgs);
  }

  static void appendToCall(Ref call, Ref element) {
    assert(call[0] == CALL);
    call[2]->push_back(element);
  }

  static Ref makeStatement(Ref contents) { return contents; }

  static Ref makeDouble(double num) {
    return &arena.alloc<Value>()->setNumber(num);
  }
  static Ref makeInt(uint32_t num) { return makeDouble(double(num)); }
  static Ref makeInt(int32_t num) { return makeDouble(double(num)); }
  static Ref makeNum(double num) { return makeDouble(num); }

  static Ref makeUnary(IString op, Ref value) {
    return &makeRawArray(3)
              ->push_back(makeRawString(UNARY_PREFIX))
              .push_back(makeRawString(op))
              .push_back(value);
  }

  static Ref makeBinary(Ref left, IString op, Ref right) {
    if (op == SET) {
      if (left->isString()) {
        return &arena.alloc<AssignName>()->setAssignName(left->getIString(),
                                                         right);
      } else {
        return &arena.alloc<Assign>()->setAssign(left, right);
      }
    } else if (op == COMMA) {
      return &makeRawArray(3)
                ->push_back(makeRawString(SEQ))
                .push_back(left)
                .push_back(right);
    } else {
      return &makeRawArray(4)
                ->push_back(makeRawString(BINARY))
                .push_back(makeRawString(op))
                .push_back(left)
                .push_back(right);
    }
  }

  static Ref makePrefix(IString op, Ref right) {
    return &makeRawArray(3)
              ->push_back(makeRawString(UNARY_PREFIX))
              .push_back(makeRawString(op))
              .push_back(right);
  }

  static Ref makeFunction(IString name) {
    return &makeRawArray(4)
              ->push_back(makeRawString(DEFUN))
              .push_back(makeRawString(name))
              .push_back(makeRawArray())
              .push_back(makeRawArray());
  }

  static void appendArgumentToFunction(Ref func, IString arg) {
    assert(func[0] == DEFUN);
    func[2]->push_back(makeRawString(arg));
  }

  static Ref makeVar(bool is_const = false) {
    return &makeRawArray(2)
              ->push_back(makeRawString(VAR))
              .push_back(makeRawArray());
  }

  static void appendToVar(Ref var, IString name, Ref value) {
    assert(var[0] == VAR);
    Ref array = &makeRawArray(1)->push_back(makeRawString(name));
    if (!!value) {
      array->push_back(value);
    }
    var[1]->push_back(array);
  }

  static Ref makeReturn(Ref value) {
    return &makeRawArray(2)
              ->push_back(makeRawString(RETURN))
              .push_back(!!value ? value : makeNull());
  }

  static Ref makeIndexing(Ref target, Ref index) {
    return &makeRawArray(3)
              ->push_back(makeRawString(SUB))
              .push_back(target)
              .push_back(index);
  }

  static Ref makeIf(Ref condition, Ref ifTrue, Ref ifFalse) {
    return &makeRawArray(4)
              ->push_back(makeRawString(IF))
              .push_back(condition)
              .push_back(ifTrue)
              .push_back(!!ifFalse ? ifFalse : makeNull());
  }

  static Ref makeConditional(Ref condition, Ref ifTrue, Ref ifFalse) {
    return &makeRawArray(4)
              ->push_back(makeRawString(CONDITIONAL))
              .push_back(condition)
              .push_back(ifTrue)
              .push_back(ifFalse);
  }

  static Ref makeSeq(Ref left, Ref right) {
    return &makeRawArray(3)
              ->push_back(makeRawString(SEQ))
              .push_back(left)
              .push_back(right);
  }

  static Ref makeDo(Ref body, Ref condition) {
    return &makeRawArray(3)
              ->push_back(makeRawString(DO))
              .push_back(condition)
              .push_back(body);
  }

  static Ref makeWhile(Ref condition, Ref body) {
    return &makeRawArray(3)
              ->push_back(makeRawString(WHILE))
              .push_back(condition)
              .push_back(body);
  }

  static Ref makeFor(Ref init, Ref condition, Ref inc, Ref body) {
    return &makeRawArray(5)
              ->push_back(makeRawString(FOR))
              .push_back(init)
              .push_back(condition)
              .push_back(inc)
              .push_back(body);
  }

  static Ref makeBreak(IString label) {
    return &makeRawArray(2)
              ->push_back(makeRawString(BREAK))
              .push_back(!!label ? makeRawString(label) : makeNull());
  }

  static Ref makeContinue(IString label) {
    return &makeRawArray(2)
              ->push_back(makeRawString(CONTINUE))
              .push_back(!!label ? makeRawString(label) : makeNull());
  }

  static Ref makeLabel(IString name, Ref body) {
    return &makeRawArray(3)
              ->push_back(makeRawString(LABEL))
              .push_back(makeRawString(name))
              .push_back(body);
  }

  static Ref makeSwitch(Ref input) {
    return &makeRawArray(3)
              ->push_back(makeRawString(SWITCH))
              .push_back(input)
              .push_back(makeRawArray());
  }

  static void appendCaseToSwitch(Ref switch_, Ref arg) {
    assert(switch_[0] == SWITCH);
    switch_[2]->push_back(
      &makeRawArray(2)->push_back(arg).push_back(makeRawArray()));
  }

  static void appendDefaultToSwitch(Ref switch_) {
    assert(switch_[0] == SWITCH);
    switch_[2]->push_back(
      &makeRawArray(2)->push_back(makeNull()).push_back(makeRawArray()));
  }

  static void appendCodeToSwitch(Ref switch_, Ref code, bool explicitBlock) {
    assert(switch_[0] == SWITCH);
    assert(code[0] == BLOCK);
    if (!explicitBlock) {
      for (size_t i = 0; i < code[1]->size(); i++) {
        switch_[2]->back()->back()->push_back(code[1][i]);
      }
    } else {
      switch_[2]->back()->back()->push_back(code);
    }
  }

  static Ref makeTry(Ref try_, Ref arg, Ref catch_) {
    assert(try_[0] == BLOCK);
    assert(catch_[0] == BLOCK);
    return &makeRawArray(3)
              ->push_back(makeRawString(TRY))
              .push_back(try_)
              .push_back(arg)
              .push_back(catch_);
  }

  static Ref makeDot(Ref obj, IString key) {
    return &makeRawArray(3)
              ->push_back(makeRawString(DOT))
              .push_back(obj)
              .push_back(makeRawString(key));
  }

  template<typename... Ts> static Ref makeDot(Ref obj, Ref key, Ts... args) {
    return makeDot(makeDot(obj, key), args...);
  }

  static Ref makeDot(Ref obj, Ref key) {
    assert(key->isString());
    return makeDot(obj, key->getIString());
  }

  static Ref makeNew(Ref call) {
    return &makeRawArray(2)->push_back(makeRawString(NEW)).push_back(call);
  }

  static Ref makeArray() {
    return &makeRawArray(2)
              ->push_back(makeRawString(ARRAY))
              .push_back(makeRawArray());
  }

  static void appendToArray(Ref array, Ref element) {
    assert(array[0] == ARRAY);
    array[1]->push_back(element);
  }

  static Ref makeObject() {
    return &makeRawArray(2)
              ->push_back(makeRawString(OBJECT))
              .push_back(makeRawArray());
  }

  static void appendToObject(Ref array, IString key, Ref value) {
    assert(array[0] == OBJECT);
    array[1]->push_back(
      &makeRawArray(2)->push_back(makeRawString(key)).push_back(value));
  }

  static void appendToObjectWithQuotes(Ref array, IString key, Ref value) {
    assert(array[0] == OBJECT);
    array[1]->push_back(
      &makeRawArray(2)->push_back(makeString(key)).push_back(value));
  }

  static void appendToObjectAsGetter(Ref array, IString key, Ref value) {
    assert(array[0] == OBJECT);
    array[1]->push_back(&makeRawArray(2)
                           ->push_back(&makeRawArray(2)
                                          ->push_back(makeRawString(GETTER))
                                          .push_back(makeRawString(key)))
                           .push_back(value));
  }

  static void
  appendToObjectAsSetter(Ref array, IString key, IString param, Ref value) {
    assert(array[0] == OBJECT);
    array[1]->push_back(&makeRawArray(2)
                           ->push_back(&makeRawArray(3)
                                          ->push_back(makeRawString(SETTER))
                                          .push_back(makeRawString(key))
                                          .push_back(makeRawString(param)))
                           .push_back(value));
  }

  static Ref makeSub(Ref obj, Ref index) {
    return &makeRawArray(2)
              ->push_back(makeRawString(SUB))
              .push_back(obj)
              .push_back(index);
  }

  static Ref makePtrShift(Ref ptr, int shifts) {
    return makeBinary(ptr, RSHIFT, makeInt(shifts));
  }
};

// Tolerates 0.0 in the input; does not trust a +() to be there.
class DotZeroValueBuilder : public ValueBuilder {
public:
  static Ref makeDouble(double num) {
    return makePrefix(PLUS, ValueBuilder::makeDouble(num));
  }
};

} // namespace cashew

#endif // wasm_simple_ast_h
