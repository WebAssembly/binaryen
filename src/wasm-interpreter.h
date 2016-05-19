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

//
// Simple WebAssembly interpreter. This operates directly on the AST,
// for simplicity and clarity. A goal is for it to be possible for
// people to read this code and understand WebAssembly semantics.
//

#ifndef wasm_wasm_interpreter_h
#define wasm_wasm_interpreter_h

#include <limits.h>
#include <sstream>

#include "support/bits.h"
#include "wasm.h"

#ifdef WASM_INTERPRETER_DEBUG
#include "wasm-printing.h"
#endif

namespace wasm {

using namespace cashew;

// Utilities

IString WASM("wasm"),
        RETURN_FLOW("*return:)*");

enum {
  maxCallDepth = 250
};

// Stuff that flows around during executing expressions: a literal, or a change in control flow
class Flow {
public:
  Flow() {}
  Flow(Literal value) : value(value) {}
  Flow(IString breakTo) : breakTo(breakTo) {}

  Literal value;
  IString breakTo; // if non-null, a break is going on

  bool breaking() { return breakTo.is(); }

  void clearIf(IString target) {
    if (breakTo == target) {
      breakTo.clear();
    }
  }

  friend std::ostream& operator<<(std::ostream& o, Flow& flow) {
    o << "(flow " << (flow.breakTo.is() ? flow.breakTo.str : "-") << " : " << flow.value << ')';
    return o;
  }
};

//
// An instance of a WebAssembly module, which can execute it via AST interpretation.
//
// To embed this interpreter, you need to provide an ExternalInterface instance
// (see below) which provides the embedding-specific details, that is, how to
// connect to the embedding implementation.
//
// To call into the interpreter, use callExport.
//

class ModuleInstance {
public:
  typedef std::vector<Literal> LiteralList;

  //
  // You need to implement one of these to create a concrete interpreter. The
  // ExternalInterface provides embedding-specific functionality like calling
  // an imported function or accessing memory.
  //
  struct ExternalInterface {
    virtual void init(Module& wasm) {}
    virtual Literal callImport(Import* import, LiteralList& arguments) = 0;
    virtual Literal load(Load* load, Address addr) = 0;
    virtual void store(Store* store, Address addr, Literal value) = 0;
    virtual void growMemory(Address oldSize, Address newSize) = 0;
    virtual void trap(const char* why) = 0;
  };

  Module& wasm;

  ModuleInstance(Module& wasm, ExternalInterface* externalInterface) : wasm(wasm), externalInterface(externalInterface) {
    memorySize = wasm.memory.initial;
    externalInterface->init(wasm);
    if (wasm.start.is()) {
      LiteralList arguments;
      callFunction(wasm.start, arguments);
    }
  }

  Literal callExport(Name name, LiteralList& arguments) {
    Export *export_ = wasm.checkExport(name);
    if (!export_) externalInterface->trap("callExport not found");
    return callFunction(export_->value, arguments);
  }

  std::string printFunctionStack() {
    std::string ret = "/== (binaryen interpreter stack trace)\n";
    for (int i = int(functionStack.size()) - 1; i >= 0; i--) {
      ret += std::string("|: ") + functionStack[i].str + "\n";
    }
    ret += std::string("\\==\n");
    return ret;
  }

private:

  size_t callDepth = 0;

#ifdef WASM_INTERPRETER_DEBUG
  int indent = 0;
#endif

  // Function stack. We maintain this explicitly to allow printing of
  // stack traces.
  std::vector<Name> functionStack;

  //
  // Calls a function. This can be used both internally (calls from
  // the interpreter to another method), or when you want to call into
  // the module.
  //
  Literal callFunction(IString name, LiteralList& arguments) {

    class FunctionScope {
     public:
      std::vector<Literal> locals;
      Function* function;

      FunctionScope(Function* function, LiteralList& arguments)
          : function(function) {
        if (function->params.size() != arguments.size()) {
          std::cerr << "Function `" << function->name << "` expects "
                    << function->params.size() << " parameters, got "
                    << arguments.size() << " arguments." << std::endl;
          abort();
        }
        locals.resize(function->getNumLocals());
        for (size_t i = 0; i < function->getNumLocals(); i++) {
          if (i < arguments.size()) {
            assert(function->isParam(i));
            if (function->params[i] != arguments[i].type) {
              std::cerr << "Function `" << function->name << "` expects type "
                        << printWasmType(function->params[i])
                        << " for parameter " << i << ", got "
                        << printWasmType(arguments[i].type) << "." << std::endl;
              abort();
            }
            locals[i] = arguments[i];
          } else {
            assert(function->isVar(i));
            locals[i].type = function->getLocalType(i);
          }
        }
      }
    };

#ifdef WASM_INTERPRETER_DEBUG
    struct IndentHandler {
      int& indent;
      const char *name;
      IndentHandler(int& indent, const char *name, Expression *expression) : indent(indent), name(name) {
        doIndent(std::cout, indent);
        std::cout << "visit " << name << " :\n";
        indent++;
#if WASM_INTERPRETER_DEBUG == 2
        doIndent(std::cout, indent);
        std::cout << "\n" << expression << '\n';
        indent++;
#endif
      }
      ~IndentHandler() {
#if WASM_INTERPRETER_DEBUG == 2
        indent--;
#endif
        indent--;
        doIndent(std::cout, indent);
        std::cout << "exit " << name << '\n';
      }
    };
    #define NOTE_ENTER(x) IndentHandler indentHandler(instance.indent, x, curr);
    #define NOTE_NAME(p0) { doIndent(std::cout, instance.indent); std::cout << "name in " << indentHandler.name << '('  << Name(p0) << ")\n"; }
    #define NOTE_EVAL1(p0) { doIndent(std::cout, instance.indent); std::cout << "eval in " << indentHandler.name << '('  << p0 << ")\n"; }
    #define NOTE_EVAL2(p0, p1) { doIndent(std::cout, instance.indent); std::cout << "eval in " << indentHandler.name << '('  << p0 << ", " << p1 << ")\n"; }
#else
    #define NOTE_ENTER(x)
    #define NOTE_NAME(p0)
    #define NOTE_EVAL1(p0)
    #define NOTE_EVAL2(p0, p1)
#endif

    // Execute a statement
    class ExpressionRunner : public Visitor<ExpressionRunner, Flow> {
      ModuleInstance& instance;
      FunctionScope& scope;

    public:
      ExpressionRunner(ModuleInstance& instance, FunctionScope& scope) : instance(instance), scope(scope) {}

      Flow visitBlock(Block *curr) {
        NOTE_ENTER("Block");
        // special-case Block, because Block nesting (in their first element) can be incredibly deep
        std::vector<Block*> stack;
        stack.push_back(curr);
        while (curr->list.size() > 0 && curr->list[0]->is<Block>()) {
          curr = curr->list[0]->cast<Block>();
          stack.push_back(curr);
        }
        Flow flow;
        auto* top = stack.back();
        while (stack.size() > 0) {
          curr = stack.back();
          stack.pop_back();
          if (flow.breaking()) {
            flow.clearIf(curr->name);
            continue;
          }
          auto& list = curr->list;
          for (size_t i = 0; i < list.size(); i++) {
            if (curr != top && i == 0) {
              // one of the block recursions we already handled
              continue;
            }
            flow = visit(list[i]);
            if (flow.breaking()) {
              flow.clearIf(curr->name);
              break;
            }
          }
        }
        return flow;
      }
      Flow visitIf(If *curr) {
        NOTE_ENTER("If");
        Flow flow = visit(curr->condition);
        if (flow.breaking()) return flow;
        NOTE_EVAL1(flow.value);
        if (flow.value.geti32()) {
          Flow flow = visit(curr->ifTrue);
          if (!flow.breaking() && !curr->ifFalse) flow.value = Literal(); // if_else returns a value, but if does not
          return flow;
        }
        if (curr->ifFalse) return visit(curr->ifFalse);
        return Flow();
      }
      Flow visitLoop(Loop *curr) {
        NOTE_ENTER("Loop");
        while (1) {
          Flow flow = visit(curr->body);
          if (flow.breaking()) {
            if (flow.breakTo == curr->in) continue; // lol
            flow.clearIf(curr->out);
          }
          return flow; // loop does not loop automatically, only continue achieves that
        }
      }
      Flow visitBreak(Break *curr) {
        NOTE_ENTER("Break");
        bool condition = true;
        Flow flow(curr->name);
        if (curr->value) {
          flow = visit(curr->value);
          if (flow.breaking()) return flow;
          flow.breakTo = curr->name;
        }
        if (curr->condition) {
          Flow conditionFlow = visit(curr->condition);
          if (conditionFlow.breaking()) return conditionFlow;
          condition = conditionFlow.value.getInteger() != 0;
        }
        return condition ? flow : Flow();
      }
      Flow visitSwitch(Switch *curr) {
        NOTE_ENTER("Switch");
        Flow flow;
        Literal value;
        if (curr->value) {
          flow = visit(curr->value);
          if (flow.breaking()) return flow;
          value = flow.value;
          NOTE_EVAL1(value);
        }
        flow = visit(curr->condition);
        if (flow.breaking()) return flow;
        int64_t index = flow.value.getInteger();
        Name target = curr->default_;
        if (index >= 0 && (size_t)index < curr->targets.size()) {
          target = curr->targets[(size_t)index];
        }
        flow.breakTo = target;
        flow.value = value;
        return flow;
      }

      Flow generateArguments(const ExpressionList& operands, LiteralList& arguments) {
        arguments.reserve(operands.size());
        for (auto expression : operands) {
          Flow flow = visit(expression);
          if (flow.breaking()) return flow;
          arguments.push_back(flow.value);
        }
        return Flow();
      }

      Flow visitCall(Call *curr) {
        NOTE_ENTER("Call");
        NOTE_NAME(curr->target);
        LiteralList arguments;
        Flow flow = generateArguments(curr->operands, arguments);
        if (flow.breaking()) return flow;
        Flow ret = instance.callFunction(curr->target, arguments);
#ifdef WASM_INTERPRETER_DEBUG
        std::cout << "(returned to " << scope.function->name << ")\n";
#endif
        return ret;
      }
      Flow visitCallImport(CallImport *curr) {
        NOTE_ENTER("CallImport");
        LiteralList arguments;
        Flow flow = generateArguments(curr->operands, arguments);
        if (flow.breaking()) return flow;
        return instance.externalInterface->callImport(instance.wasm.getImport(curr->target), arguments);
      }
      Flow visitCallIndirect(CallIndirect *curr) {
        NOTE_ENTER("CallIndirect");
        Flow target = visit(curr->target);
        if (target.breaking()) return target;
        size_t index = target.value.geti32();
        if (index >= instance.wasm.table.names.size()) trap("callIndirect: overflow");
        Name name = instance.wasm.table.names[index];
        Function *func = instance.wasm.getFunction(name);
        if (func->type.is() && func->type != curr->fullType->name) trap("callIndirect: bad type");
        LiteralList arguments;
        Flow flow = generateArguments(curr->operands, arguments);
        if (flow.breaking()) return flow;
        return instance.callFunction(name, arguments);
      }

      Flow visitGetLocal(GetLocal *curr) {
        NOTE_ENTER("GetLocal");
        auto index = curr->index;
        NOTE_EVAL1(index);
        NOTE_EVAL1(scope.locals[index]);
        return scope.locals[index];
      }
      Flow visitSetLocal(SetLocal *curr) {
        NOTE_ENTER("SetLocal");
        auto index = curr->index;
        Flow flow = visit(curr->value);
        if (flow.breaking()) return flow;
        NOTE_EVAL1(index);
        NOTE_EVAL1(flow.value);
        assert(flow.value.type == curr->type);
        scope.locals[index] = flow.value;
        return flow;
      }
      Flow visitLoad(Load *curr) {
        NOTE_ENTER("Load");
        Flow flow = visit(curr->ptr);
        if (flow.breaking()) return flow;
        return instance.externalInterface->load(curr, instance.getFinalAddress(curr, flow.value));
      }
      Flow visitStore(Store *curr) {
        NOTE_ENTER("Store");
        Flow ptr = visit(curr->ptr);
        if (ptr.breaking()) return ptr;
        Flow value = visit(curr->value);
        if (value.breaking()) return value;
        instance.externalInterface->store(curr, instance.getFinalAddress(curr, ptr.value), value.value);
        return value;
      }
      Flow visitConst(Const *curr) {
        NOTE_ENTER("Const");
        NOTE_EVAL1(curr->value);
        return Flow(curr->value); // heh
      }
      Flow visitUnary(Unary *curr) {
        NOTE_ENTER("Unary");
        Flow flow = visit(curr->value);
        if (flow.breaking()) return flow;
        Literal value = flow.value;
        NOTE_EVAL1(value);
        if (value.type == i32) {
          switch (curr->op) {
            case ClzInt32:            return value.countLeadingZeroes();
            case CtzInt32:            return value.countTrailingZeroes();
            case PopcntInt32:         return value.popCount();
            case EqZInt32:            return Literal(int32_t(value == Literal(int32_t(0))));
            case ReinterpretInt32: return value.castToF32();
            case ExtendSInt32:   return value.extendToSI64();
            case ExtendUInt32:   return value.extendToUI64();
            case ConvertUInt32ToFloat32: return value.convertUToF32();
            case ConvertUInt32ToFloat64: return value.convertUToF64();
            case ConvertSInt32ToFloat32: return value.convertSToF32();
            case ConvertSInt32ToFloat64: return value.convertSToF64();
            default: abort();
          }
        }
        if (value.type == i64) {
          switch (curr->op) {
            case ClzInt64:            return value.countLeadingZeroes();
            case CtzInt64:            return value.countTrailingZeroes();
            case PopcntInt64:         return value.popCount();
            case EqZInt64:            return Literal(int32_t(value == Literal(int64_t(0))));
            case WrapInt64:      return value.truncateToI32();
            case ReinterpretInt64: return value.castToF64();
            case ConvertUInt64ToFloat32: return value.convertUToF32();
            case ConvertUInt64ToFloat64: return value.convertUToF64();
            case ConvertSInt64ToFloat32: return value.convertSToF32();
            case ConvertSInt64ToFloat64: return value.convertSToF64();
            default: abort();
          }
        }
        if (value.type == f32) {
          switch (curr->op) {
            case NegFloat32:              return value.neg();
            case AbsFloat32:              return value.abs();
            case CeilFloat32:             return value.ceil();
            case FloorFloat32:            return value.floor();
            case TruncFloat32:            return value.trunc();
            case NearestFloat32:          return value.nearbyint();
            case SqrtFloat32:             return value.sqrt();
            case TruncSFloat32ToInt32:
            case TruncSFloat32ToInt64: return truncSFloat(curr, value);
            case TruncUFloat32ToInt32:
            case TruncUFloat32ToInt64: return truncUFloat(curr, value);
            case ReinterpretFloat32: return value.castToI32();
            case PromoteFloat32:   return value.extendToF64();
            default: abort();
          }
        }
        if (value.type == f64) {
          switch (curr->op) {
            case NegFloat64:              return value.neg();
            case AbsFloat64:              return value.abs();
            case CeilFloat64:             return value.ceil();
            case FloorFloat64:            return value.floor();
            case TruncFloat64:            return value.trunc();
            case NearestFloat64:          return value.nearbyint();
            case SqrtFloat64:             return value.sqrt();
            case TruncSFloat64ToInt32:
            case TruncSFloat64ToInt64: return truncSFloat(curr, value);
            case TruncUFloat64ToInt32:
            case TruncUFloat64ToInt64: return truncUFloat(curr, value);
            case ReinterpretFloat64: return value.castToI64();
            case DemoteFloat64: {
              double val = value.getFloat();
              if (std::isnan(val)) return Literal(float(val));
              if (std::isinf(val)) return Literal(float(val));
              if (val < -std::numeric_limits<float>::max()) return Literal(-std::numeric_limits<float>::infinity());
              if (val > std::numeric_limits<float>::max()) return Literal(std::numeric_limits<float>::infinity());
              return value.truncateToF32();
            }
            default: abort();
          }
        }
        abort();
      }
      Flow visitBinary(Binary *curr) {
        NOTE_ENTER("Binary");
        Flow flow = visit(curr->left);
        if (flow.breaking()) return flow;
        Literal left = flow.value;
        flow = visit(curr->right);
        if (flow.breaking()) return flow;
        Literal right = flow.value;
        NOTE_EVAL2(left, right);
        assert(isConcreteWasmType(curr->left->type) ? left.type == curr->left->type : true);
        assert(isConcreteWasmType(curr->right->type) ? right.type == curr->right->type : true);
        if (left.type == i32) {
          switch (curr->op) {
            case AddInt32:      return left.add(right);
            case SubInt32:      return left.sub(right);
            case MulInt32:      return left.mul(right);
            case DivSInt32: {
              if (right.getInteger() == 0) trap("i32.div_s by 0");
              if (left.getInteger() == std::numeric_limits<int32_t>::min() && right.getInteger() == -1) trap("i32.div_s overflow"); // signed division overflow
              return left.divS(right);
            }
            case DivUInt32: {
              if (right.getInteger() == 0) trap("i32.div_u by 0");
              return left.divU(right);
            }
            case RemSInt32: {
              if (right.getInteger() == 0) trap("i32.rem_s by 0");
              if (left.getInteger() == std::numeric_limits<int32_t>::min() && right.getInteger() == -1) return Literal(int32_t(0));
              return left.remS(right);
            }
            case RemUInt32: {
              if (right.getInteger() == 0) trap("i32.rem_u by 0");
              return left.remU(right);
            }
            case AndInt32:  return left.and_(right);
            case OrInt32:   return left.or_(right);
            case XorInt32:  return left.xor_(right);
            case ShlInt32:  return left.shl(right.and_(Literal(int32_t(31))));
            case ShrUInt32: return left.shrU(right.and_(Literal(int32_t(31))));
            case ShrSInt32: return left.shrS(right.and_(Literal(int32_t(31))));
            case RotLInt32: return left.rotL(right);
            case RotRInt32: return left.rotR(right);
            case EqInt32:   return left.eq(right);
            case NeInt32:   return left.ne(right);
            case LtSInt32:  return left.ltS(right);
            case LtUInt32:  return left.ltU(right);
            case LeSInt32:  return left.leS(right);
            case LeUInt32:  return left.leU(right);
            case GtSInt32:  return left.gtS(right);
            case GtUInt32:  return left.gtU(right);
            case GeSInt32:  return left.geS(right);
            case GeUInt32:  return left.geU(right);
            default: abort();
          }
        } else if (left.type == i64) {
          switch (curr->op) {
            case AddInt64:      return left.add(right);
            case SubInt64:      return left.sub(right);
            case MulInt64:      return left.mul(right);
            case DivSInt64: {
              if (right.getInteger() == 0) trap("i64.div_s by 0");
              if (left.getInteger() == LLONG_MIN && right.getInteger() == -1LL) trap("i64.div_s overflow"); // signed division overflow
              return left.divS(right);
            }
            case DivUInt64: {
              if (right.getInteger() == 0) trap("i64.div_u by 0");
              return left.divU(right);
            }
            case RemSInt64: {
              if (right.getInteger() == 0) trap("i64.rem_s by 0");
              if (left.getInteger() == LLONG_MIN && right.getInteger() == -1LL) return Literal(int64_t(0));
              return left.remS(right);
            }
            case RemUInt64: {
              if (right.getInteger() == 0) trap("i64.rem_u by 0");
              return left.remU(right);
            }
            case AndInt64:  return left.and_(right);
            case OrInt64:   return left.or_(right);
            case XorInt64:  return left.xor_(right);
            case ShlInt64:  return left.shl(right.and_(Literal(int64_t(63))));
            case ShrUInt64: return left.shrU(right.and_(Literal(int64_t(63))));
            case ShrSInt64: return left.shrS(right.and_(Literal(int64_t(63))));
            case RotLInt64: return left.rotL(right);
            case RotRInt64: return left.rotR(right);
            case EqInt64:   return left.eq(right);
            case NeInt64:   return left.ne(right);
            case LtSInt64:  return left.ltS(right);
            case LtUInt64:  return left.ltU(right);
            case LeSInt64:  return left.leS(right);
            case LeUInt64:  return left.leU(right);
            case GtSInt64:  return left.gtS(right);
            case GtUInt64:  return left.gtU(right);
            case GeSInt64:  return left.geS(right);
            case GeUInt64:  return left.geU(right);
            default: abort();
          }
        } else if (left.type == f32 || left.type == f64) {
          switch (curr->op) {
            case AddFloat32:      case AddFloat64:      return left.add(right);
            case SubFloat32:      case SubFloat64:      return left.sub(right);
            case MulFloat32:      case MulFloat64:      return left.mul(right);
            case DivFloat32:      case DivFloat64:      return left.div(right);
            case CopySignFloat32: case CopySignFloat64: return left.copysign(right);
            case MinFloat32:      case MinFloat64:      return left.min(right);
            case MaxFloat32:      case MaxFloat64:      return left.max(right);
            case EqFloat32:       case EqFloat64:       return left.eq(right);
            case NeFloat32:       case NeFloat64:       return left.ne(right);
            case LtFloat32:       case LtFloat64:       return left.lt(right);
            case LeFloat32:       case LeFloat64:       return left.le(right);
            case GtFloat32:       case GtFloat64:       return left.gt(right);
            case GeFloat32:       case GeFloat64:       return left.ge(right);
            default: abort();
          }
        }
        abort();
      }
      Flow visitSelect(Select *curr) {
        NOTE_ENTER("Select");
        Flow ifTrue = visit(curr->ifTrue);
        if (ifTrue.breaking()) return ifTrue;
        Flow ifFalse = visit(curr->ifFalse);
        if (ifFalse.breaking()) return ifFalse;
        Flow condition = visit(curr->condition);
        if (condition.breaking()) return condition;
        NOTE_EVAL1(condition.value);
        return condition.value.geti32() ? ifTrue : ifFalse; // ;-)
      }
      Flow visitReturn(Return *curr) {
        NOTE_ENTER("Return");
        Flow flow;
        if (curr->value) {
          flow = visit(curr->value);
          if (flow.breaking()) return flow;
          NOTE_EVAL1(flow.value);
        }
        flow.breakTo = RETURN_FLOW;
        return flow;
      }
      Flow visitHost(Host *curr) {
        NOTE_ENTER("Host");
        switch (curr->op) {
          case PageSize:   return Literal((int32_t)Memory::kPageSize);
          case CurrentMemory: return Literal(int32_t(instance.memorySize));
          case GrowMemory: {
            Flow flow = visit(curr->operands[0]);
            if (flow.breaking()) return flow;
            int32_t ret = instance.memorySize;
            uint32_t delta = flow.value.geti32();
            if (delta > uint32_t(-1) /Memory::kPageSize) trap("growMemory: delta relatively too big");
            if (instance.memorySize >= uint32_t(-1) - delta) trap("growMemory: delta objectively too big");
            uint32_t newSize = instance.memorySize + delta;
            if (newSize > instance.wasm.memory.max) trap("growMemory: exceeds max");
            instance.externalInterface->growMemory(instance.memorySize * Memory::kPageSize, newSize * Memory::kPageSize);
            instance.memorySize = newSize;
            return Literal(int32_t(ret));
          }
          case HasFeature: {
            IString id = curr->nameOperand;
            if (id == WASM) return Literal(1);
            return Literal((int32_t)0);
          }
          default: abort();
        }
      }
      Flow visitNop(Nop *curr) {
        NOTE_ENTER("Nop");
        return Flow();
      }
      Flow visitUnreachable(Unreachable *curr) {
        NOTE_ENTER("Unreachable");
        trap("unreachable");
        return Flow();
      }

      Literal truncSFloat(Unary* curr, Literal value) {
        double val = value.getFloat();
        if (std::isnan(val)) trap("truncSFloat of nan");
        if (curr->type == i32) {
          if (value.type == f32) {
            if (!isInRangeI32TruncS(value.reinterpreti32())) trap("i32.truncSFloat overflow");
          } else {
            if (!isInRangeI32TruncS(value.reinterpreti64())) trap("i32.truncSFloat overflow");
          }
          return Literal(int32_t(val));
        } else {
          if (value.type == f32) {
            if (!isInRangeI64TruncS(value.reinterpreti32())) trap("i64.truncSFloat overflow");
          } else {
            if (!isInRangeI64TruncS(value.reinterpreti64())) trap("i64.truncSFloat overflow");
          }
          return Literal(int64_t(val));
        }
      }

      Literal truncUFloat(Unary* curr, Literal value) {
        double val = value.getFloat();
        if (std::isnan(val)) trap("truncUFloat of nan");
        if (curr->type == i32) {
          if (value.type == f32) {
            if (!isInRangeI32TruncU(value.reinterpreti32())) trap("i32.truncUFloat overflow");
          } else {
            if (!isInRangeI32TruncU(value.reinterpreti64())) trap("i32.truncUFloat overflow");
          }
          return Literal(uint32_t(val));
        } else {
          if (value.type == f32) {
            if (!isInRangeI64TruncU(value.reinterpreti32())) trap("i64.truncUFloat overflow");
          } else {
            if (!isInRangeI64TruncU(value.reinterpreti64())) trap("i64.truncUFloat overflow");
          }
          return Literal(uint64_t(val));
        }
      }

      void trap(const char* why) {
        instance.externalInterface->trap(why);
      }
    };

    if (callDepth > maxCallDepth) externalInterface->trap("stack limit");
    callDepth++;
    functionStack.push_back(name);

    Function *function = wasm.getFunction(name);
    assert(function);
    FunctionScope scope(function, arguments);

#ifdef WASM_INTERPRETER_DEBUG
    std::cout << "entering " << function->name << '\n';
#endif

    Flow flow = ExpressionRunner(*this, scope).visit(function->body);
    assert(!flow.breaking() || flow.breakTo == RETURN_FLOW); // cannot still be breaking, it means we missed our stop
    Literal ret = flow.value;
    if (function->result == none) ret = Literal();
    assert(function->result == ret.type);
    callDepth--;
    assert(functionStack.back() == name);
    functionStack.pop_back();
#ifdef WASM_INTERPRETER_DEBUG
    std::cout << "exiting " << function->name << " with " << ret << '\n';
#endif
    return ret;
  }

  Address memorySize; // in pages

  template <class LS>
  Address getFinalAddress(LS* curr, Literal ptr) {
    auto trapIfGt = [this](uint64_t lhs, uint64_t rhs, const char* msg) {
      if (lhs > rhs) {
        std::stringstream ss;
        ss << msg << ": " << lhs << " > " << rhs;
        externalInterface->trap(ss.str().c_str());
      }
    };
    Address memorySizeBytes = memorySize * Memory::kPageSize;
    uint64_t addr = ptr.type == i32 ? ptr.geti32() : ptr.geti64();
    trapIfGt(curr->offset, memorySizeBytes, "offset > memory");
    trapIfGt(addr, memorySizeBytes - curr->offset, "final > memory");
    addr += curr->offset;
    trapIfGt(curr->bytes, memorySizeBytes, "bytes > memory");
    trapIfGt(addr, memorySizeBytes - curr->bytes, "highest > memory");
    return addr;
  }

  ExternalInterface* externalInterface;
};

} // namespace wasm

#endif // wasm_wasm_interpreter_h
