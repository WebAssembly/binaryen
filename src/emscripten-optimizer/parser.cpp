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

#include <unordered_map>

#include "parser.h"

namespace cashew {

// common strings

wasm::IString TOPLEVEL("toplevel");
wasm::IString DEFUN("defun");
wasm::IString BLOCK("block");
wasm::IString VAR("var");
wasm::IString CONST("const");
wasm::IString CONDITIONAL("conditional");
wasm::IString BINARY("binary");
wasm::IString RETURN("return");
wasm::IString IF("if");
wasm::IString ELSE("else");
wasm::IString WHILE("while");
wasm::IString DO("do");
wasm::IString FOR("for");
wasm::IString SEQ("seq");
wasm::IString SUB("sub");
wasm::IString CALL("call");
wasm::IString LABEL("label");
wasm::IString BREAK("break");
wasm::IString CONTINUE("continue");
wasm::IString SWITCH("switch");
wasm::IString STRING("string");
wasm::IString TRY("try");
wasm::IString INF("inf");
wasm::IString NaN("nan");
wasm::IString LLVM_CTTZ_I32("_llvm_cttz_i32");
wasm::IString UDIVMODDI4("___udivmoddi4");
wasm::IString UNARY_PREFIX("unary-prefix");
wasm::IString UNARY_POSTFIX("unary-postfix");
wasm::IString MATH_FROUND("Math_fround");
wasm::IString MATH_CLZ32("Math_clz32");
wasm::IString INT64("i64");
wasm::IString INT64_CONST("i64_const");
wasm::IString SIMD_FLOAT32X4("SIMD_Float32x4");
wasm::IString SIMD_FLOAT64X2("SIMD_Float64x2");
wasm::IString SIMD_INT8X16("SIMD_Int8x16");
wasm::IString SIMD_INT16X8("SIMD_Int16x8");
wasm::IString SIMD_INT32X4("SIMD_Int32x4");
wasm::IString PLUS("+");
wasm::IString MINUS("-");
wasm::IString OR("|");
wasm::IString AND("&");
wasm::IString XOR("^");
wasm::IString L_NOT("!");
wasm::IString B_NOT("~");
wasm::IString LT("<");
wasm::IString GE(">=");
wasm::IString LE("<=");
wasm::IString GT(">");
wasm::IString EQ("==");
wasm::IString NE("!=");
wasm::IString DIV("/");
wasm::IString MOD("%");
wasm::IString MUL("*");
wasm::IString RSHIFT(">>");
wasm::IString LSHIFT("<<");
wasm::IString TRSHIFT(">>>");
wasm::IString HEAP8("HEAP8");
wasm::IString HEAP16("HEAP16");
wasm::IString HEAP32("HEAP32");
wasm::IString HEAPF32("HEAPF32");
wasm::IString HEAPU8("HEAPU8");
wasm::IString HEAPU16("HEAPU16");
wasm::IString HEAPU32("HEAPU32");
wasm::IString HEAPF64("HEAPF64");
wasm::IString F0("f0");
wasm::IString EMPTY("");
wasm::IString FUNCTION("function");
wasm::IString OPEN_PAREN("(");
wasm::IString OPEN_BRACE("[");
wasm::IString OPEN_CURLY("{");
wasm::IString CLOSE_CURLY("}");
wasm::IString COMMA(",");
wasm::IString QUESTION("?");
wasm::IString COLON(":");
wasm::IString CASE("case");
wasm::IString DEFAULT("default");
wasm::IString DOT("dot");
wasm::IString PERIOD(".");
wasm::IString NEW("new");
wasm::IString ARRAY("array");
wasm::IString OBJECT("object");
wasm::IString THROW("throw");
wasm::IString SET("=");
wasm::IString ATOMICS("Atomics");
wasm::IString COMPARE_EXCHANGE("compareExchange");
wasm::IString LOAD("load");
wasm::IString STORE("store");
wasm::IString GETTER("get");
wasm::IString SETTER("set");

IStringSet
  keywords("var const function if else do while for break continue return "
           "switch case default throw try catch finally true false null new");

const char *OPERATOR_INITS = "+-*/%<>&^|~=!,?:.", *SEPARATORS = "([;{}";

int MAX_OPERATOR_SIZE = 3;

std::vector<OperatorClass> operatorClasses;

static std::vector<std::unordered_map<wasm::IString, int>>
  precedences; // op, type => prec

struct Init {
  Init() {
    // operators, rtl, type
    operatorClasses.emplace_back(".", false, OperatorClass::Binary);
    operatorClasses.emplace_back("! ~ + -", true, OperatorClass::Prefix);
    operatorClasses.emplace_back("* / %", false, OperatorClass::Binary);
    operatorClasses.emplace_back("+ -", false, OperatorClass::Binary);
    operatorClasses.emplace_back("<< >> >>>", false, OperatorClass::Binary);
    operatorClasses.emplace_back("< <= > >=", false, OperatorClass::Binary);
    operatorClasses.emplace_back("== !=", false, OperatorClass::Binary);
    operatorClasses.emplace_back("&", false, OperatorClass::Binary);
    operatorClasses.emplace_back("^", false, OperatorClass::Binary);
    operatorClasses.emplace_back("|", false, OperatorClass::Binary);
    operatorClasses.emplace_back("? :", true, OperatorClass::Tertiary);
    operatorClasses.emplace_back("=", true, OperatorClass::Binary);
    operatorClasses.emplace_back(",", true, OperatorClass::Binary);

    precedences.resize(OperatorClass::Tertiary + 1);

    for (size_t prec = 0; prec < operatorClasses.size(); prec++) {
      for (auto curr : operatorClasses[prec].ops) {
        precedences[operatorClasses[prec].type][curr] = prec;
      }
    }
  }
};

Init init;

int OperatorClass::getPrecedence(Type type, wasm::IString op) {
  return precedences[type][op];
}

bool OperatorClass::getRtl(int prec) { return operatorClasses[prec].rtl; }

bool isIdentInit(char x) {
  return (x >= 'a' && x <= 'z') || (x >= 'A' && x <= 'Z') || x == '_' ||
         x == '$';
}
bool isIdentPart(char x) { return isIdentInit(x) || (x >= '0' && x <= '9'); }

} // namespace cashew
