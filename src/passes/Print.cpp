/*
 * Copyright 2016 WebAssembly Community Group participants
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

//
// Print out text in s-expression format
//

#include <wasm.h>
#include <pass.h>

namespace wasm {

struct PrintSExpression : public WasmVisitor<PrintSExpression, void> {
  std::ostream& o;
  unsigned indent;
  bool minify;
  const char *maybeSpace;
  const char *maybeNewLine;

  PrintSExpression(std::ostream& o, bool minify = false)
    : o(o), indent(0), minify(minify) {
    maybeSpace = minify ? "" : " ";
    maybeNewLine = minify ? "" : "\n";
  }

  void incIndent() {
    if (minify) return;
    o << '\n';
    indent++;
  }
  void decIndent() {
    if (!minify) {
      indent--;
      doIndent(o, indent);
    }
    o << ')';
  }
  void printFullLine(Expression *expression) {
    !minify && doIndent(o, indent);
    visit(expression);
    o << maybeNewLine;
  }
  void visitBlock(Block *curr) {
    printOpening(o, "block");
    if (curr->name.is()) {
      o << ' ' << curr->name;
    }
    incIndent();
    for (auto expression : curr->list) {
      printFullLine(expression);
    }
    decIndent();
  }
  void visitIf(If *curr) {
    printOpening(o, curr->ifFalse ? "if_else" : "if");
    incIndent();
    printFullLine(curr->condition);
    printFullLine(curr->ifTrue);
    if (curr->ifFalse) printFullLine(curr->ifFalse);
    decIndent();
  }
  void visitLoop(Loop *curr) {
    printOpening(o, "loop");
    if (curr->out.is()) {
      o << ' ' << curr->out;
      assert(curr->in.is()); // if just one is printed, it must be the in
    }
    if (curr->in.is()) {
      o << ' ' << curr->in;
    }
    incIndent();
    auto block = curr->body->dyn_cast<Block>();
    if (block && block->name.isNull()) {
      // wasm spec has loops containing children directly, while our ast
      // has a single child for simplicity. print out the optimal form.
      for (auto expression : block->list) {
        printFullLine(expression);
      }
    } else {
      printFullLine(curr->body);
    }
    decIndent();
  }
  void visitBreak(Break *curr) {
    if (curr->condition) {
      printOpening(o, "br_if ") << curr->name;
      incIndent();
    } else {
      printOpening(o, "br ") << curr->name;
      if (!curr->value || curr->value->is<Nop>()) {
        // avoid a new line just for the parens
        o << ")";
        return;
      }
      incIndent();
    }
    if (curr->value && !curr->value->is<Nop>()) printFullLine(curr->value);
    if (curr->condition) {
      printFullLine(curr->condition);
    }
    decIndent();
  }
  void visitSwitch(Switch *curr) {
    printOpening(o, "tableswitch ");
    if (curr->name.is()) o << curr->name;
    incIndent();
    printFullLine(curr->value);
    doIndent(o, indent) << "(table";
    std::set<Name> caseNames;
    for (auto& c : curr->cases) {
      caseNames.insert(c.name);
    }
    for (auto& t : curr->targets) {
      o << maybeSpace << "(" << (caseNames.count(t) == 0 ? "br" : "case") << " " << (t.is() ? t : curr->default_) << ")";
    }
    o << ")";
    if (curr->default_.is()) o << " (" << (caseNames.count(curr->default_) == 0 ? "br" : "case") << " " << curr->default_ << ")";
    o << maybeNewLine;
    for (auto& c : curr->cases) {
      doIndent(o, indent);
      printMinorOpening(o, "case ") << c.name;
      incIndent();
      printFullLine(c.body);
      decIndent();
      o << maybeNewLine;
    }
    decIndent();
  }

  void printCallBody(Call* curr) {
    o << curr->target;
    if (curr->operands.size() > 0) {
      incIndent();
      for (auto operand : curr->operands) {
        printFullLine(operand);
      }
      decIndent();
    } else {
      o << ')';
    }
  }

  void visitCall(Call *curr) {
    printOpening(o, "call ");
    printCallBody(curr);
  }
  void visitCallImport(CallImport *curr) {
    printOpening(o, "call_import ");
    printCallBody(curr);
  }
  void visitCallIndirect(CallIndirect *curr) {
    printOpening(o, "call_indirect ") << curr->fullType->name;
    incIndent();
    printFullLine(curr->target);
    for (auto operand : curr->operands) {
      printFullLine(operand);
    }
    decIndent();
  }
  void visitGetLocal(GetLocal *curr) {
    printOpening(o, "get_local ") << curr->name << ')';
  }
  void visitSetLocal(SetLocal *curr) {
    printOpening(o, "set_local ") << curr->name;
    incIndent();
    printFullLine(curr->value);
    decIndent();
  }
  void visitLoad(Load *curr) {
    o << '(';
    prepareColor(o) << printWasmType(curr->type) << ".load";
    if (curr->bytes < 4 || (curr->type == i64 && curr->bytes < 8)) {
      if (curr->bytes == 1) {
        o << '8';
      } else if (curr->bytes == 2) {
        o << "16";
      } else if (curr->bytes == 4) {
        o << "32";
      } else {
        abort();
      }
      o << (curr->signed_ ? "_s" : "_u");
    }
    restoreNormalColor(o);
    if (curr->offset) {
      o << " offset=" << curr->offset;
    }
    if (curr->align != curr->bytes) {
      o << " align=" << curr->align;
    }
    incIndent();
    printFullLine(curr->ptr);
    decIndent();
  }
  void visitStore(Store *curr) {
    o << '(';
    prepareColor(o) << printWasmType(curr->type) << ".store";
    if (curr->bytes < 4 || (curr->type == i64 && curr->bytes < 8)) {
      if (curr->bytes == 1) {
        o << '8';
      } else if (curr->bytes == 2) {
        o << "16";
      } else if (curr->bytes == 4) {
        o << "32";
      } else {
        abort();
      }
    }
    restoreNormalColor(o);
    if (curr->offset) {
      o << " offset=" << curr->offset;
    }
    if (curr->align != curr->bytes) {
      o << " align=" << curr->align;
    }
    incIndent();
    printFullLine(curr->ptr);
    printFullLine(curr->value);
    decIndent();
  }
  void visitConst(Const *curr) {
    o << curr->value;
  }
  void visitUnary(Unary *curr) {
    o << '(';
    prepareColor(o) << printWasmType(curr->type) << '.';
    switch (curr->op) {
      case Clz:              o << "clz";     break;
      case Ctz:              o << "ctz";     break;
      case Popcnt:           o << "popcnt";  break;
      case Neg:              o << "neg";     break;
      case Abs:              o << "abs";     break;
      case Ceil:             o << "ceil";    break;
      case Floor:            o << "floor";   break;
      case Trunc:            o << "trunc";   break;
      case Nearest:          o << "nearest"; break;
      case Sqrt:             o << "sqrt";    break;
      case ExtendSInt32:     o << "extend_s/i32"; break;
      case ExtendUInt32:     o << "extend_u/i32"; break;
      case WrapInt64:        o << "wrap/i64"; break;
      case TruncSFloat32:    o << "trunc_s/f32"; break;
      case TruncUFloat32:    o << "trunc_u/f32"; break;
      case TruncSFloat64:    o << "trunc_s/f64"; break;
      case TruncUFloat64:    o << "trunc_u/f64"; break;
      case ReinterpretFloat: o << "reinterpret/" << (curr->type == i64 ? "f64" : "f32"); break;
      case ConvertUInt32:    o << "convert_u/i32"; break;
      case ConvertSInt32:    o << "convert_s/i32"; break;
      case ConvertUInt64:    o << "convert_u/i64"; break;
      case ConvertSInt64:    o << "convert_s/i64"; break;
      case PromoteFloat32:   o << "promote/f32"; break;
      case DemoteFloat64:    o << "demote/f64"; break;
      case ReinterpretInt:   o << "reinterpret/" << (curr->type == f64 ? "i64" : "i32"); break;
      default: abort();
    }
    incIndent();
    printFullLine(curr->value);
    decIndent();
  }
  void visitBinary(Binary *curr) {
    o << '(';
    prepareColor(o) << printWasmType(curr->isRelational() ? curr->left->type : curr->type) << '.';
    switch (curr->op) {
      case Add:      o << "add";      break;
      case Sub:      o << "sub";      break;
      case Mul:      o << "mul";      break;
      case DivS:     o << "div_s";    break;
      case DivU:     o << "div_u";    break;
      case RemS:     o << "rem_s";    break;
      case RemU:     o << "rem_u";    break;
      case And:      o << "and";      break;
      case Or:       o << "or";       break;
      case Xor:      o << "xor";      break;
      case Shl:      o << "shl";      break;
      case ShrU:     o << "shr_u";    break;
      case ShrS:     o << "shr_s";    break;
      case Div:      o << "div";      break;
      case CopySign: o << "copysign"; break;
      case Min:      o << "min";      break;
      case Max:      o << "max";      break;
      case Eq:       o << "eq";       break;
      case Ne:       o << "ne";       break;
      case LtS:      o << "lt_s";     break;
      case LtU:      o << "lt_u";     break;
      case LeS:      o << "le_s";     break;
      case LeU:      o << "le_u";     break;
      case GtS:      o << "gt_s";     break;
      case GtU:      o << "gt_u";     break;
      case GeS:      o << "ge_s";     break;
      case GeU:      o << "ge_u";     break;
      case Lt:       o << "lt";       break;
      case Le:       o << "le";       break;
      case Gt:       o << "gt";       break;
      case Ge:       o << "ge";       break;
      default:       abort();
    }
    restoreNormalColor(o);
    incIndent();
    printFullLine(curr->left);
    printFullLine(curr->right);
    decIndent();
  }
  void visitSelect(Select *curr) {
    o << '(';
    prepareColor(o) << "select";
    incIndent();
    printFullLine(curr->ifTrue);
    printFullLine(curr->ifFalse);
    printFullLine(curr->condition);
    decIndent();
  }
  void visitReturn(Return *curr) {
    printOpening(o, "return");
    if (!curr->value || curr->value->is<Nop>()) {
      // avoid a new line just for the parens
      o << ")";
      return;
    }
    incIndent();
    printFullLine(curr->value);
    decIndent();
  }
  void visitHost(Host *curr) {
    switch (curr->op) {
      case PageSize: printOpening(o, "pagesize") << ')'; break;
      case MemorySize: printOpening(o, "memory_size") << ')'; break;
      case GrowMemory: {
        printOpening(o, "grow_memory");
        incIndent();
        printFullLine(curr->operands[0]);
        decIndent();
        break;
      }
      case HasFeature: printOpening(o, "hasfeature ") << curr->nameOperand << ')'; break;
      default: abort();
    }
  }
  void visitNop(Nop *curr) {
    printMinorOpening(o, "nop") << ')';
  }
  void visitUnreachable(Unreachable *curr) {
    printMinorOpening(o, "unreachable") << ')';
  }
  // Module-level visitors
  void visitFunctionType(FunctionType *curr, bool full=false) {
    if (full) {
      printOpening(o, "type") << ' ' << curr->name << " (func";
    }
    if (curr->params.size() > 0) {
      o << maybeSpace;
      printMinorOpening(o, "param");
      for (auto& param : curr->params) {
        o << ' ' << printWasmType(param);
      }
      o << ')';
    }
    if (curr->result != none) {
      o << maybeSpace;
      printMinorOpening(o, "result ") << printWasmType(curr->result) << ')';
    }
    if (full) {
      o << "))";
    }
  }
  void visitImport(Import *curr) {
    printOpening(o, "import ") << curr->name << ' ';
    printText(o, curr->module.str) << ' ';
    printText(o, curr->base.str);
    if (curr->type) visitFunctionType(curr->type);
    o << ')';
  }
  void visitExport(Export *curr) {
    printOpening(o, "export ");
    printText(o, curr->name.str) << ' ' << curr->value << ')';
  }
  void visitFunction(Function *curr) {
    printOpening(o, "func ", true) << curr->name;
    if (curr->type.is()) {
      o << maybeSpace << "(type " << curr->type << ')';
    }
    if (curr->params.size() > 0) {
      for (auto& param : curr->params) {
        o << maybeSpace;
        printMinorOpening(o, "param ") << param.name << ' ' << printWasmType(param.type) << ")";
      }
    }
    if (curr->result != none) {
      o << maybeSpace;
      printMinorOpening(o, "result ") << printWasmType(curr->result) << ")";
    }
    incIndent();
    for (auto& local : curr->locals) {
      doIndent(o, indent);
      printMinorOpening(o, "local ") << local.name << ' ' << printWasmType(local.type) << ")";
      o << maybeNewLine;
    }
    // It is ok to emit a block here, as a function can directly contain a list, even if our
    // ast avoids that for simplicity. We can just do that optimization here..
    if (curr->body->is<Block>() && curr->body->cast<Block>()->name.isNull()) {
      Block* block = curr->body->cast<Block>();
      for (auto item : block->list) {
        printFullLine(item);
      }
    } else {
      printFullLine(curr->body);
    }
    decIndent();
  }
  void visitTable(Table *curr) {
    printOpening(o, "table");
    for (auto name : curr->names) {
      o << ' ' << name;
    }
    o << ')';
  }
  void visitModule(Module *curr) {
    printOpening(o, "module", true);
    incIndent();
    doIndent(o, indent);
    uint32_t initial_pages = (curr->memory.initial + (WASM_PAGE_SIZE - 1)) / WASM_PAGE_SIZE;
    uint32_t max_pages = (curr->memory.max + (WASM_PAGE_SIZE - 1)) / WASM_PAGE_SIZE;
    printOpening(o, "memory") << " " << initial_pages;
    if (max_pages && max_pages != 65535) o << " " << max_pages;
    for (auto segment : curr->memory.segments) {
      o << maybeNewLine;
      o << (minify ? "" : "    ") << "(segment " << segment.offset << " \"";
      for (size_t i = 0; i < segment.size; i++) {
        unsigned char c = segment.data[i];
        switch (c) {
          case '\n': o << "\\n"; break;
          case '\r': o << "\\0d"; break;
          case '\t': o << "\\t"; break;
          case '\f': o << "\\0c"; break;
          case '\b': o << "\\08"; break;
          case '\\': o << "\\\\"; break;
          case '"' : o << "\\\""; break;
          case '\'' : o << "\\'"; break;
          default: {
            if (c >= 32 && c < 127) {
              o << c;
            } else {
              o << std::hex << '\\' << (c/16) << (c%16) << std::dec;
            }
          }
        }
      }
      o << "\")";
    }
    o << ((curr->memory.segments.size() > 0 && !minify) ? "\n  " : "") << ")";
    o << maybeNewLine;
    if (curr->start.is()) {
      doIndent(o, indent);
      printOpening(o, "start") << " " << curr->start << ")";
      o << maybeNewLine;
    }
    for (auto& child : curr->functionTypes) {
      doIndent(o, indent);
      visitFunctionType(child, true);
      o << maybeNewLine;
    }
    for (auto& child : curr->imports) {
      doIndent(o, indent);
      visitImport(child);
      o << maybeNewLine;
    }
    for (auto& child : curr->exports) {
      doIndent(o, indent);
      visitExport(child);
      o << maybeNewLine;
    }
    if (curr->table.names.size() > 0) {
      doIndent(o, indent);
      visitTable(&curr->table);
      o << maybeNewLine;
    }
    for (auto& child : curr->functions) {
      doIndent(o, indent);
      visitFunction(child);
      o << maybeNewLine;
    }
    decIndent();
    o << maybeNewLine;
  }
};

// Pass entry point. Eventually this will direct printing to one of various options.

void Printer::run(PassRunner* runner, Module* module) {
  PrintSExpression print(o);
  print.visitModule(module);
}

static RegisterPass<Printer> registerPass("print", "print in s-expression format");

// Prints out a minified module
class MinifiedPrinter : public Printer {
  public:
  MinifiedPrinter() : Printer() {}
  MinifiedPrinter(std::ostream& o) : Printer(o) {}

  void run(PassRunner* runner, Module* module) override;
};

void MinifiedPrinter::run(PassRunner* runner, Module* module) {
  PrintSExpression print(o, true);
  print.visitModule(module);
}


static RegisterPass<MinifiedPrinter> registerMinifyPass("print-minified", "print in minified s-expression format");

// Print individual expressions

std::ostream& printWasm(Expression* expression, std::ostream& o, bool minify = false) {
  PrintSExpression print(o, minify);
  print.visit(expression);
  return o;
}

} // namespace wasm
