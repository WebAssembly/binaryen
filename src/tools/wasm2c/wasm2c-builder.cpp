/*
 * Copyright 2026 WebAssembly Community Group participants
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

#include <algorithm>
#include <cassert>
#include <iostream>
#include <sstream>
#include <string>
#include <unordered_map>
#include <vector>

#include "tools/wasm2c/c-printer.h"
#include "tools/wasm2c/wasm2c-builder.h"
#include "wasm-stack.h"
#include "wasm-traversal.h"
#include "wasm.h"

// code to be inserted into the generated output
extern const char* HeaderTop;
extern const char* HeaderBottom;
extern const char* SourceIncludes;
extern const char* SourceDeclarations;

namespace wasm {

namespace {

std::string mangleName(const std::string& name) {
  if (name.empty()) {
    return "";
  }
  std::string result;
  bool isFirst = true;
  for (char c : name) {
    if ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') ||
        (c >= '0' && c <= '9')) {
      result += c;
      isFirst = false;
    } else if (c == '_') {
      if (isFirst) {
        result += "0x5F";
        isFirst = false;
      } else {
        result += '_';
      }
    } else {
      char buf[8];
      snprintf(buf, sizeof(buf), "0x%02X", (unsigned char)c);
      result += buf;
      isFirst = false;
    }
  }
  return result;
}

struct FunctionCompiler : public Visitor<FunctionCompiler> {
  CPrinter& c;
  Function* func;
  std::string moduleName;

  // Virtual stack
  size_t stackDepth = 0;
  size_t maxStackDepth = 0;

  FunctionCompiler(CPrinter& c, Function* func, const std::string& moduleName)
    : c(c), func(func), moduleName(moduleName) {}

  void push() {
    stackDepth++;
    if (stackDepth > maxStackDepth) {
      maxStackDepth = stackDepth;
    }
  }

  void pop(size_t n = 1) {
    assert(stackDepth >= n);
    stackDepth -= n;
  }

  std::string stackVar(size_t index) { return "i" + std::to_string(index); }

  std::string top() {
    assert(stackDepth > 0);
    return stackVar(stackDepth - 1);
  }

  std::string popVal() {
    std::string val = top();
    pop();
    return val;
  }

  void pushVal(const std::string& val) {
    push();
    c << top() << " = " << val << ";" << endl;
  }

  // Visitor methods
  void visitLocalGet(LocalGet* curr) {
    std::string name;
    if (func->isParam(curr->index)) {
      name = "var_p" + std::to_string(curr->index);
    } else {
      name = "var_l" + std::to_string(curr->index - func->getNumParams());
    }
    pushVal(name);
  }

  void visitLocalSet(LocalSet* curr) {
    std::string name;
    if (func->isParam(curr->index)) {
      name = "var_p" + std::to_string(curr->index);
    } else {
      name = "var_l" + std::to_string(curr->index - func->getNumParams());
    }
    if (curr->isTee()) {
      c << name << " = " << top() << ";" << endl;
    } else {
      c << name << " = " << popVal() << ";" << endl;
    }
  }

  void visitConst(Const* curr) {
    if (curr->type == Type::i32) {
      pushVal(std::to_string(curr->value.geti32()) + "u");
    } else {
      Fatal() << "Unsupported const type: " << curr->type;
    }
  }

  void visitUnary(Unary* curr) {
    if (curr->type == Type::i32) {
      std::string val = popVal();
      switch (curr->op) {
        case ClzInt32:
          pushVal("I32_CLZ(" + val + ")");
          break;
        case CtzInt32:
          pushVal("I32_CTZ(" + val + ")");
          break;
        case PopcntInt32:
          pushVal("I32_POPCNT(" + val + ")");
          break;
        case EqZInt32:
          pushVal(val + " == 0");
          break;
        case ExtendS8Int32:
          pushVal("(uint32_t)(int32_t)(int8_t)" + val);
          break;
        case ExtendS16Int32:
          pushVal("(uint32_t)(int32_t)(int16_t)" + val);
          break;
        default:
          Fatal() << "Unsupported unary op: " << curr->op;
      }
    } else {
      Fatal() << "Unsupported unary type: " << curr->type;
    }
  }

  void visitBinary(Binary* curr) {
    std::string right = popVal();
    std::string left = popVal();

    if (curr->left->type == Type::i32 && curr->right->type == Type::i32) {
      switch (curr->op) {
        case AddInt32:
          pushVal(left + " + " + right);
          break;
        case SubInt32:
          pushVal(left + " - " + right);
          break;
        case MulInt32:
          pushVal(left + " * " + right);
          break;
        case DivSInt32:
          pushVal("I32_DIV_S(" + left + ", " + right + ")");
          break;
        case DivUInt32:
          pushVal("DIV_U(" + left + ", " + right + ")");
          break;
        case RemSInt32:
          pushVal("I32_REM_S(" + left + ", " + right + ")");
          break;
        case RemUInt32:
          pushVal("REM_U(" + left + ", " + right + ")");
          break;
        case AndInt32:
          pushVal(left + " & " + right);
          break;
        case OrInt32:
          pushVal(left + " | " + right);
          break;
        case XorInt32:
          pushVal(left + " ^ " + right);
          break;
        case ShlInt32:
          pushVal(left + " << (" + right + " & 31)");
          break;
        case ShrSInt32:
          pushVal("(uint32_t)((int32_t)" + left + " >> (" + right + " & 31))");
          break;
        case ShrUInt32:
          pushVal(left + " >> (" + right + " & 31)");
          break;
        case RotLInt32:
          pushVal("I32_ROTL(" + left + ", " + right + ")");
          break;
        case RotRInt32:
          pushVal("I32_ROTR(" + left + ", " + right + ")");
          break;

        // Relational
        case EqInt32:
          pushVal(left + " == " + right);
          break;
        case NeInt32:
          pushVal(left + " != " + right);
          break;
        case LtSInt32:
          pushVal("(int32_t)" + left + " < (int32_t)" + right);
          break;
        case LtUInt32:
          pushVal(left + " < " + right);
          break;
        case LeSInt32:
          pushVal("(int32_t)" + left + " <= (int32_t)" + right);
          break;
        case LeUInt32:
          pushVal(left + " <= " + right);
          break;
        case GtSInt32:
          pushVal("(int32_t)" + left + " > (int32_t)" + right);
          break;
        case GtUInt32:
          pushVal(left + " > " + right);
          break;
        case GeSInt32:
          pushVal("(int32_t)" + left + " >= (int32_t)" + right);
          break;
        case GeUInt32:
          pushVal(left + " >= " + right);
          break;

        default:
          Fatal() << "Unsupported binary op: " << curr->op;
      }
    } else {
      Fatal() << "Unsupported binary operand types";
    }
  }

  void visitDrop(Drop* curr) { pop(); }

  void visitReturn(Return* curr) {
    if (curr->value) {
      c << "return " << popVal() << ";" << endl;
    } else {
      c << "return;" << endl;
    }
  }
};

} // anonymous namespace

void Wasm2CBuilder::processWasm(Module* wasm,
                                std::ostream& cOut,
                                std::ostream& hOut) {
  this->module = wasm;
  std::string moduleName =
    flags.moduleName.empty() ? "test" : mangleName(flags.moduleName);
  std::string guardName = "WASM_H_GENERATED_" + moduleName;
  std::transform(
    guardName.begin(), guardName.end(), guardName.begin(), ::toupper);

  CPrinter h(hOut);
  CPrinter c(cOut);

  // Header file prefix
  h << "/* Automatically generated by wasm2c */" << endl;
  h << "#ifndef " << guardName << endl;
  h << "#define " << guardName << endl << endl;
  h << "#include \"wasm-rt.h\"" << endl << endl;
  h << HeaderTop << endl;

  // Source file prefix
  c << "/* Automatically generated by wasm2c */" << endl;
  c << SourceIncludes << endl;
  if (!flags.headerName.empty()) {
    c << "#include \"" << flags.headerName << "\"" << endl;
  } else {
    c << "#include \"wasm.h\"" << endl;
  }
  c << SourceDeclarations << endl;

  // Track exported functions
  std::unordered_map<Name, std::string> exportedFunctions;
  for (auto& exp : wasm->exports) {
    if (exp->kind == ExternalKind::Function) {
      exportedFunctions[*exp->getInternalName()] = exp->name.toString();
    }
  }

  // Structure context definition
  h << "typedef struct w2c_" << moduleName << " {" << endl;
  h.indent();
  h << "char dummy_member;" << endl;
  h.outdent();
  h << "} w2c_" << moduleName << ";" << endl << endl;

  // Generate declarations in .h and static declarations in .c
  bool printedHeaderDecl = false;
  bool printedSourceDecl = false;
  for (auto& func : wasm->functions) {
    if (func->imported()) {
      continue;
    }

    std::string internalName = mangleName(func->name.toString());
    std::string resType = func->getResults() == Type::i32 ? "uint32_t" : "void";
    if (func->getResults() != Type::i32 && func->getResults() != Type::none) {
      Fatal() << "Unsupported result type: " << func->getResults();
    }

    std::string paramsSig = "w2c_" + moduleName + "*";
    for (size_t i = 0; i < func->getNumParams(); i++) {
      if (func->getLocalType(i) != Type::i32) {
        Fatal() << "Unsupported param type: " << func->getLocalType(i);
      }
      paramsSig += ", uint32_t";
    }

    // Static declaration in .c
    c << "static " << resType << " w2c_" << moduleName << "_" << internalName
      << "_impl(" << paramsSig << ");" << endl;
    printedSourceDecl = true;

    // Non-static declaration in .h if exported
    if (exportedFunctions.count(func->name)) {
      std::string exportedName = mangleName(exportedFunctions[func->name]);
      h << resType << " w2c_" << moduleName << "_" << exportedName << "("
        << paramsSig << ");" << endl;
      printedHeaderDecl = true;
    }
  }
  if (printedHeaderDecl) {
    h << endl;
  }
  if (printedSourceDecl) {
    c << endl;
  }

  // Lifecycle signatures in header
  h << "void wasm2c_" << moduleName << "_instantiate(w2c_" << moduleName << "*";
  h << ");" << endl;
  h << "void wasm2c_" << moduleName << "_free(w2c_" << moduleName << "*);"
    << endl;
  h << "wasm_rt_func_type_t wasm2c_" << moduleName
    << "_get_func_type(uint32_t param_count, uint32_t result_count, ...);"
    << endl;

  // Instantiate hooks
  c << "void wasm2c_" << moduleName << "_instantiate(w2c_" << moduleName
    << "* instance";
  c << ") {" << endl;
  c.indent();
  c << "assert(wasm_rt_is_initialized());" << endl;
  c.outdent();
  c << "}" << endl << endl;

  // Free hooks
  c << "void wasm2c_" << moduleName << "_free(w2c_" << moduleName
    << "* instance) {" << endl;
  c << "}" << endl << endl;

  // Signature match ladders
  c << "wasm_rt_func_type_t wasm2c_" << moduleName
    << "_get_func_type(uint32_t param_count, uint32_t result_count, ...) {"
    << endl;
  c.indent();
  c << "va_list args;" << endl << endl;

  c << "return NULL;" << endl;
  c.outdent();
  c << "}" << endl << endl;

  // Generate function definitions
  PassOptions options;
  ModuleStackIR moduleStackIR(*wasm, options);

  for (auto& func : wasm->functions) {
    if (func->imported()) {
      continue;
    }

    std::string internalName = mangleName(func->name.toString());
    std::string resType = func->getResults() == Type::i32 ? "uint32_t" : "void";
    std::string paramsDecl = "w2c_" + moduleName + "* instance";
    std::string paramsCall = "instance";
    for (size_t i = 0; i < func->getNumParams(); i++) {
      paramsDecl += ", uint32_t var_p" + std::to_string(i);
      paramsCall += ", var_p" + std::to_string(i);
    }

    // Wrapper definition (non-static) if exported
    if (exportedFunctions.count(func->name)) {
      std::string exportedName = mangleName(exportedFunctions[func->name]);
      c << resType << " w2c_" << moduleName << "_" << exportedName << "("
        << paramsDecl << ") {" << endl;
      c.indent();
      if (resType != "void") {
        c << "return ";
      }
      c << "w2c_" << moduleName << "_" << internalName << "_impl(" << paramsCall
        << ");" << endl;
      c.outdent();
      c << "}" << endl << endl;
    }

    // Actual implementation (static)
    c << "static " << resType << " w2c_" << moduleName << "_" << internalName
      << "_impl(" << paramsDecl << ") {" << endl;
    c.indent();

    StackIR* stackIR = moduleStackIR.getStackIROrNull(func.get());
    if (!stackIR) {
      Fatal() << "Failed to generate Stack IR for function " << func->name;
    }

    // Compile body to a stringstream first to count stack depth and locals
    std::stringstream bodyStream;
    CPrinter bodyPrinter(bodyStream);
    bodyPrinter.indent(); // Match indentation
    FunctionCompiler compiler(bodyPrinter, func.get(), moduleName);

    for (auto* inst : *stackIR) {
      if (!inst) {
        continue;
      }
      if (inst->op == StackInst::Basic) {
        compiler.visit(inst->origin);
      } else {
        Fatal() << "Unsupported StackInst op: " << inst->op;
      }
    }

    // Declare virtual stack variables
    for (size_t i = 0; i < compiler.maxStackDepth; i++) {
      c << "uint32_t i" << i << ";" << endl;
    }
    // Declare locals
    for (size_t i = 0; i < func->getNumVars(); i++) {
      if (func->vars[i] != Type::i32) {
        Fatal() << "Unsupported local type: " << func->vars[i];
      }
      c << "uint32_t var_l" << i << " = 0u;" << endl; // Initialize to 0
    }

    // Append body
    c << bodyStream.str();

    // Return value
    if (resType != "void") {
      if (compiler.stackDepth > 0) {
        c << "return " << compiler.top() << ";" << endl;
      }
    }

    c.outdent();
    c << "}" << endl << endl;
  }

  // Header file suffix
  h << endl;
  h << HeaderBottom << endl;
  h << "#endif  /* " << guardName << " */" << endl;
}

} // namespace wasm
