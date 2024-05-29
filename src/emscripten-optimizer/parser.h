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

// Pure parsing. Calls methods on a Builder (template argument) to actually
// construct the AST
//
// XXX All parsing methods assume they take ownership of the input string. This
//     lets them reuse parts of it. You will segfault if the input string cannot
//     be reused and written to.

#ifndef wasm_parser_h
#define wasm_parser_h

#include <algorithm>
#include <cstdio>
#include <iostream>
#include <limits>
#include <vector>

#include "support/istring.h"
#include "support/safe_integer.h"

namespace cashew {

using IString = wasm::IString;

// IStringSet

class IStringSet : public std::unordered_set<IString> {
  std::vector<char> data;

public:
  IStringSet() = default;
  IStringSet(const char* init) { // comma-delimited list
    int size = strlen(init) + 1;
    data.resize(size);
    char* curr = &data[0];
    strncpy(curr, init, size);
    while (1) {
      char* end = strchr(curr, ' ');
      if (end) {
        *end = 0;
      }
      insert(curr);
      if (!end) {
        break;
      }
      curr = end + 1;
    }
  }

  bool has(const IString& str) { return count(str) > 0; }
};

class IOrderedStringSet : public std::set<IString> {
public:
  bool has(const IString& str) { return count(str) > 0; }
};

// common strings

extern IString TOPLEVEL;
extern IString DEFUN;
extern IString BLOCK;
extern IString VAR;
extern IString CONST;
extern IString CONDITIONAL;
extern IString BINARY;
extern IString RETURN;
extern IString IF;
extern IString ELSE;
extern IString WHILE;
extern IString DO;
extern IString FOR;
extern IString SEQ;
extern IString SUB;
extern IString CALL;
extern IString LABEL;
extern IString BREAK;
extern IString CONTINUE;
extern IString SWITCH;
extern IString STRING;
extern IString TRY;
extern IString INF;
extern IString NaN;
extern IString LLVM_CTTZ_I32;
extern IString UDIVMODDI4;
extern IString UNARY_PREFIX;
extern IString UNARY_POSTFIX;
extern IString MATH_FROUND;
extern IString MATH_CLZ32;
extern IString INT64;
extern IString INT64_CONST;
extern IString SIMD_FLOAT32X4;
extern IString SIMD_FLOAT64X2;
extern IString SIMD_INT8X16;
extern IString SIMD_INT16X8;
extern IString SIMD_INT32X4;
extern IString PLUS;
extern IString MINUS;
extern IString OR;
extern IString AND;
extern IString XOR;
extern IString L_NOT;
extern IString B_NOT;
extern IString LT;
extern IString GE;
extern IString LE;
extern IString GT;
extern IString EQ;
extern IString NE;
extern IString DIV;
extern IString MOD;
extern IString MUL;
extern IString RSHIFT;
extern IString LSHIFT;
extern IString TRSHIFT;
extern IString HEAP8;
extern IString HEAP16;
extern IString HEAP32;
extern IString HEAPF32;
extern IString HEAPU8;
extern IString HEAPU16;
extern IString HEAPU32;
extern IString HEAPF64;
extern IString F0;
extern IString EMPTY;
extern IString FUNCTION;
extern IString OPEN_PAREN;
extern IString OPEN_BRACE;
extern IString OPEN_CURLY;
extern IString CLOSE_CURLY;
extern IString COMMA;
extern IString QUESTION;
extern IString COLON;
extern IString CASE;
extern IString DEFAULT;
extern IString DOT;
extern IString PERIOD;
extern IString NEW;
extern IString ARRAY;
extern IString OBJECT;
extern IString THROW;
extern IString SET;
extern IString ATOMICS;
extern IString COMPARE_EXCHANGE;
extern IString LOAD;
extern IString STORE;
extern IString GETTER;
extern IString SETTER;

extern const char *OPERATOR_INITS, *SEPARATORS;

extern int MAX_OPERATOR_SIZE, LOWEST_PREC;

struct OperatorClass {
  enum Type { Binary = 0, Prefix = 1, Postfix = 2, Tertiary = 3 };

  IStringSet ops;
  bool rtl;
  Type type;

  OperatorClass(const char* o, bool r, Type t) : ops(o), rtl(r), type(t) {}

  static int getPrecedence(Type type, IString op);
  static bool getRtl(int prec);
};

extern std::vector<OperatorClass> operatorClasses;

extern bool isIdentInit(char x);
extern bool isIdentPart(char x);

} // namespace cashew

#endif // wasm_parser_h
