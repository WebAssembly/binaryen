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
#include <wasm-printing.h>
#include <pass.h>

namespace wasm {

struct PrintSExpression : public Visitor<PrintSExpression> {
  std::ostream& o;
  unsigned indent = 0;

  bool minify;
  const char *maybeSpace;
  const char *maybeNewLine;

  bool fullAST = false; // whether to not elide nodes in output when possible
                        // (like implicit blocks)

  Function* currFunction = nullptr;

  PrintSExpression(std::ostream& o) : o(o) {
    setMinify(false);
  }

  void setMinify(bool minify_) {
    minify = minify_;
    maybeSpace = minify ? "" : " ";
    maybeNewLine = minify ? "" : "\n";
  }

  void setFullAST(bool fullAST_) { fullAST = fullAST_; }

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

  Name printableLocal(Index index) {
    Name name;
    if (currFunction) {
      name = currFunction->tryLocalName(index);
    }
    if (!name.is()) {
      name = Name::fromInt(index);
    }
    return name;
  }

  void visitBlock(Block *curr) {
    // special-case Block, because Block nesting (in their first element) can be incredibly deep
    std::vector<Block*> stack;
    while (1) {
      if (stack.size() > 0) doIndent(o, indent);
      stack.push_back(curr);
      printOpening(o, "block");
      if (curr->name.is()) {
        o << ' ' << curr->name;
      }
      incIndent();
      if (curr->list.size() > 0 && curr->list[0]->is<Block>()) {
        // recurse into the first element
        curr = curr->list[0]->cast<Block>();
        continue;
      } else {
        break; // that's all we can recurse, start to unwind
      }
    }
    auto* top = stack.back();
    while (stack.size() > 0) {
      curr = stack.back();
      stack.pop_back();
      auto& list = curr->list;
      for (size_t i = 0; i < list.size(); i++) {
        if (curr != top && i == 0) {
          // one of the block recursions we already handled
          decIndent();
          o << '\n';
          continue;
        }
        printFullLine(list[i]);
      }
    }
    decIndent();
  }
  void visitIf(If *curr) {
    printOpening(o, "if");
    incIndent();
    printFullLine(curr->condition);
    // ifTrue and False have implict blocks, avoid printing them if possible
    if (!fullAST && curr->ifTrue->is<Block>() && curr->ifTrue->dynCast<Block>()->name.isNull() && curr->ifTrue->dynCast<Block>()->list.size() == 1) {
      printFullLine(curr->ifTrue->dynCast<Block>()->list.back());
    } else {
      printFullLine(curr->ifTrue);
    }
    if (curr->ifFalse) {
      if (!fullAST && curr->ifFalse->is<Block>() && curr->ifFalse->dynCast<Block>()->name.isNull() && curr->ifFalse->dynCast<Block>()->list.size() == 1) {
        printFullLine(curr->ifFalse->dynCast<Block>()->list.back());
      } else {
        printFullLine(curr->ifFalse);
      }
    }
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
    auto block = curr->body->dynCast<Block>();
    if (!fullAST && block && block->name.isNull()) {
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
    printOpening(o, "br_table");
    for (auto& t : curr->targets) {
      o << " " << t;
    }
    o << " " << curr->default_;
    incIndent();
    if (curr->value && !curr->value->is<Nop>()) printFullLine(curr->value);
    printFullLine(curr->condition);
    decIndent();
  }

  template<typename CallBase>
  void printCallBody(CallBase* curr) {
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
    printOpening(o, "get_local ") << printableLocal(curr->index) << ')';
  }
  void visitSetLocal(SetLocal *curr) {
    printOpening(o, "set_local ") << printableLocal(curr->index);
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
    prepareColor(o);
    switch (curr->op) {
      case ClzInt32:               o << "i32.clz";     break;
      case CtzInt32:               o << "i32.ctz";     break;
      case PopcntInt32:            o << "i32.popcnt";  break;
      case EqZInt32:               o << "i32.eqz";     break;
      case ClzInt64:               o << "i64.clz";     break;
      case CtzInt64:               o << "i64.ctz";     break;
      case PopcntInt64:            o << "i64.popcnt";  break;
      case EqZInt64:               o << "i64.eqz";     break;
      case NegFloat32:             o << "f32.neg";     break;
      case AbsFloat32:             o << "f32.abs";     break;
      case CeilFloat32:            o << "f32.ceil";    break;
      case FloorFloat32:           o << "f32.floor";   break;
      case TruncFloat32:           o << "f32.trunc";   break;
      case NearestFloat32:         o << "f32.nearest"; break;
      case SqrtFloat32:            o << "f32.sqrt";    break;
      case NegFloat64:             o << "f64.neg";     break;
      case AbsFloat64:             o << "f64.abs";     break;
      case CeilFloat64:            o << "f64.ceil";    break;
      case FloorFloat64:           o << "f64.floor";   break;
      case TruncFloat64:           o << "f64.trunc";   break;
      case NearestFloat64:         o << "f64.nearest"; break;
      case SqrtFloat64:            o << "f64.sqrt";    break;
      case ExtendSInt32:           o << "i64.extend_s/i32"; break;
      case ExtendUInt32:           o << "i64.extend_u/i32"; break;
      case WrapInt64:              o << "i32.wrap/i64"; break;
      case TruncSFloat32ToInt32:   o << "i32.trunc_s/f32"; break;
      case TruncSFloat32ToInt64:   o << "i64.trunc_s/f32"; break;
      case TruncUFloat32ToInt32:   o << "i32.trunc_u/f32"; break;
      case TruncUFloat32ToInt64:   o << "i64.trunc_u/f32"; break;
      case TruncSFloat64ToInt32:   o << "i32.trunc_s/f64"; break;
      case TruncSFloat64ToInt64:   o << "i64.trunc_s/f64"; break;
      case TruncUFloat64ToInt32:   o << "i32.trunc_u/f64"; break;
      case TruncUFloat64ToInt64:   o << "i64.trunc_u/f64"; break;
      case ReinterpretFloat32:     o << "i32.reinterpret/f32"; break;
      case ReinterpretFloat64:     o << "i64.reinterpret/f64"; break;
      case ConvertUInt32ToFloat32: o << "f32.convert_u/i32"; break;
      case ConvertUInt32ToFloat64: o << "f64.convert_u/i32"; break;
      case ConvertSInt32ToFloat32: o << "f32.convert_s/i32"; break;
      case ConvertSInt32ToFloat64: o << "f64.convert_s/i32"; break;
      case ConvertUInt64ToFloat32: o << "f32.convert_u/i64"; break;
      case ConvertUInt64ToFloat64: o << "f64.convert_u/i64"; break;
      case ConvertSInt64ToFloat32: o << "f32.convert_s/i64"; break;
      case ConvertSInt64ToFloat64: o << "f64.convert_s/i64"; break;
      case PromoteFloat32:         o << "f64.promote/f32"; break;
      case DemoteFloat64:          o << "f32.demote/f64"; break;
      case ReinterpretInt32:       o << "f32.reinterpret/i32"; break;
      case ReinterpretInt64:       o << "f64.reinterpret/i64"; break;
      default: abort();
    }
    incIndent();
    printFullLine(curr->value);
    decIndent();
  }
  void visitBinary(Binary *curr) {
    o << '(';
    prepareColor(o);
    switch (curr->op) {
      case AddInt32:      o << "i32.add";      break;
      case SubInt32:      o << "i32.sub";      break;
      case MulInt32:      o << "i32.mul";      break;
      case DivSInt32:     o << "i32.div_s";    break;
      case DivUInt32:     o << "i32.div_u";    break;
      case RemSInt32:     o << "i32.rem_s";    break;
      case RemUInt32:     o << "i32.rem_u";    break;
      case AndInt32:      o << "i32.and";      break;
      case OrInt32:       o << "i32.or";       break;
      case XorInt32:      o << "i32.xor";      break;
      case ShlInt32:      o << "i32.shl";      break;
      case ShrUInt32:     o << "i32.shr_u";    break;
      case ShrSInt32:     o << "i32.shr_s";    break;
      case RotLInt32:     o << "i32.rotl";     break;
      case RotRInt32:     o << "i32.rotr";     break;
      case EqInt32:       o << "i32.eq";       break;
      case NeInt32:       o << "i32.ne";       break;
      case LtSInt32:      o << "i32.lt_s";     break;
      case LtUInt32:      o << "i32.lt_u";     break;
      case LeSInt32:      o << "i32.le_s";     break;
      case LeUInt32:      o << "i32.le_u";     break;
      case GtSInt32:      o << "i32.gt_s";     break;
      case GtUInt32:      o << "i32.gt_u";     break;
      case GeSInt32:      o << "i32.ge_s";     break;
      case GeUInt32:      o << "i32.ge_u";     break;

      case AddInt64:      o << "i64.add";      break;
      case SubInt64:      o << "i64.sub";      break;
      case MulInt64:      o << "i64.mul";      break;
      case DivSInt64:     o << "i64.div_s";    break;
      case DivUInt64:     o << "i64.div_u";    break;
      case RemSInt64:     o << "i64.rem_s";    break;
      case RemUInt64:     o << "i64.rem_u";    break;
      case AndInt64:      o << "i64.and";      break;
      case OrInt64:       o << "i64.or";       break;
      case XorInt64:      o << "i64.xor";      break;
      case ShlInt64:      o << "i64.shl";      break;
      case ShrUInt64:     o << "i64.shr_u";    break;
      case ShrSInt64:     o << "i64.shr_s";    break;
      case RotLInt64:     o << "i64.rotl";     break;
      case RotRInt64:     o << "i64.rotr";     break;
      case EqInt64:       o << "i64.eq";       break;
      case NeInt64:       o << "i64.ne";       break;
      case LtSInt64:      o << "i64.lt_s";     break;
      case LtUInt64:      o << "i64.lt_u";     break;
      case LeSInt64:      o << "i64.le_s";     break;
      case LeUInt64:      o << "i64.le_u";     break;
      case GtSInt64:      o << "i64.gt_s";     break;
      case GtUInt64:      o << "i64.gt_u";     break;
      case GeSInt64:      o << "i64.ge_s";     break;
      case GeUInt64:      o << "i64.ge_u";     break;

      case AddFloat32:      o << "f32.add";      break;
      case SubFloat32:      o << "f32.sub";      break;
      case MulFloat32:      o << "f32.mul";      break;
      case DivFloat32:      o << "f32.div";      break;
      case CopySignFloat32: o << "f32.copysign"; break;
      case MinFloat32:      o << "f32.min";      break;
      case MaxFloat32:      o << "f32.max";      break;
      case EqFloat32:       o << "f32.eq";       break;
      case NeFloat32:       o << "f32.ne";       break;
      case LtFloat32:       o << "f32.lt";       break;
      case LeFloat32:       o << "f32.le";       break;
      case GtFloat32:       o << "f32.gt";       break;
      case GeFloat32:       o << "f32.ge";       break;

      case AddFloat64:      o << "f64.add";      break;
      case SubFloat64:      o << "f64.sub";      break;
      case MulFloat64:      o << "f64.mul";      break;
      case DivFloat64:      o << "f64.div";      break;
      case CopySignFloat64: o << "f64.copysign"; break;
      case MinFloat64:      o << "f64.min";      break;
      case MaxFloat64:      o << "f64.max";      break;
      case EqFloat64:       o << "f64.eq";       break;
      case NeFloat64:       o << "f64.ne";       break;
      case LtFloat64:       o << "f64.lt";       break;
      case LeFloat64:       o << "f64.le";       break;
      case GtFloat64:       o << "f64.gt";       break;
      case GeFloat64:       o << "f64.ge";       break;

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
      case CurrentMemory: printOpening(o, "current_memory") << ')'; break;
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
    currFunction = curr;
    printOpening(o, "func ", true) << curr->name;
    if (curr->type.is()) {
      o << maybeSpace << "(type " << curr->type << ')';
    }
    if (curr->params.size() > 0) {
      for (size_t i = 0; i < curr->params.size(); i++) {
        o << maybeSpace;
        printMinorOpening(o, "param ") << printableLocal(i) << ' ' << printWasmType(curr->getLocalType(i)) << ")";
      }
    }
    if (curr->result != none) {
      o << maybeSpace;
      printMinorOpening(o, "result ") << printWasmType(curr->result) << ")";
    }
    incIndent();
    for (size_t i = curr->getVarIndexBase(); i < curr->getNumLocals(); i++) {
      doIndent(o, indent);
      printMinorOpening(o, "local ") << printableLocal(i) << ' ' << printWasmType(curr->getLocalType(i)) << ")";
      o << maybeNewLine;
    }
    // It is ok to emit a block here, as a function can directly contain a list, even if our
    // ast avoids that for simplicity. We can just do that optimization here..
    if (!fullAST && curr->body->is<Block>() && curr->body->cast<Block>()->name.isNull()) {
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
    printOpening(o, "memory") << " " << curr->memory.initial;
    if (curr->memory.max && curr->memory.max != Memory::kMaxSize) o << " " << curr->memory.max;
    for (auto segment : curr->memory.segments) {
      o << maybeNewLine;
      o << (minify ? "" : "    ") << "(segment " << segment.offset << " \"";
      for (size_t i = 0; i < segment.data.size(); i++) {
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
    if (curr->memory.exportName.is()) {
      doIndent(o, indent);
      printOpening(o, "export ");
      printText(o, curr->memory.exportName.str) << " memory)";
      o << maybeNewLine;
    }
    if (curr->start.is()) {
      doIndent(o, indent);
      printOpening(o, "start") << " " << curr->start << ")";
      o << maybeNewLine;
    }
    for (auto& child : curr->functionTypes) {
      doIndent(o, indent);
      visitFunctionType(child.get(), true);
      o << maybeNewLine;
    }
    for (auto& child : curr->imports) {
      doIndent(o, indent);
      visitImport(child.get());
      o << maybeNewLine;
    }
    for (auto& child : curr->exports) {
      doIndent(o, indent);
      visitExport(child.get());
      o << maybeNewLine;
    }
    if (curr->table.names.size() > 0) {
      doIndent(o, indent);
      visitTable(&curr->table);
      o << maybeNewLine;
    }
    for (auto& child : curr->functions) {
      doIndent(o, indent);
      visitFunction(child.get());
      o << maybeNewLine;
    }
    decIndent();
    o << maybeNewLine;
  }
};

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

  void run(PassRunner* runner, Module* module) override {
    PrintSExpression print(o);
    print.setMinify(true);
    print.visitModule(module);
  }
};

static RegisterPass<MinifiedPrinter> registerMinifyPass("print-minified", "print in minified s-expression format");

// Prints out a module withough elision, i.e., the full ast

class FullPrinter : public Printer {
  public:
  FullPrinter() : Printer() {}
  FullPrinter(std::ostream& o) : Printer(o) {}

  void run(PassRunner* runner, Module* module) override {
    PrintSExpression print(o);
    print.setFullAST(true);
    print.visitModule(module);
  }
};

static RegisterPass<FullPrinter> registerFullASTPass("print-full", "print in full s-expression format");

// Print individual expressions

std::ostream& WasmPrinter::printExpression(Expression* expression, std::ostream& o, bool minify) {
  PrintSExpression print(o);
  print.setMinify(minify);
  print.visit(expression);
  return o;
}

} // namespace wasm
