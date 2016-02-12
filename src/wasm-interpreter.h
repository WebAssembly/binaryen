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

namespace wasm {

using namespace cashew;

// Utilities

IString WASM("wasm"),
        RETURN_FLOW("*return:)*");

enum {
  pageSize = 64*1024,
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
    virtual Literal load(Load* load, size_t addr) = 0;
    virtual void store(Store* store, size_t addr, Literal value) = 0;
    virtual void growMemory(size_t oldSize, size_t newSize) = 0;
    virtual void trap(const char* why) = 0;
  };

  Module& wasm;

  ModuleInstance(Module& wasm, ExternalInterface* externalInterface) : wasm(wasm), externalInterface(externalInterface) {
    memorySize = wasm.memory.initial;
    externalInterface->init(wasm);
  }

  Literal callExport(IString name, LiteralList& arguments) {
    Export *export_ = wasm.exportsMap[name];
    if (!export_) externalInterface->trap("callExport not found");
    return callFunction(export_->value, arguments);
  }

private:

  size_t callDepth = 0;

#ifdef WASM_INTERPRETER_DEBUG
  int indent = 0;
#endif

  //
  // Calls a function. This can be used both internally (calls from
  // the interpreter to another method), or when you want to call into
  // the module.
  //
  Literal callFunction(IString name, LiteralList& arguments) {

    class FunctionScope {
     public:
      std::map<IString, Literal> locals;
      Function* function;

      FunctionScope(Function* function, LiteralList& arguments)
          : function(function) {
        if (function->params.size() != arguments.size()) {
          std::cerr << "Function `" << function->name << "` expects "
                    << function->params.size() << " parameters, got "
                    << arguments.size() << " arguments." << std::endl;
          abort();
        }
        for (size_t i = 0; i < arguments.size(); i++) {
          if (function->params[i].type != arguments[i].type) {
            std::cerr << "Function `" << function->name << "` expects type "
                      << printWasmType(function->params[i].type)
                      << " for parameter " << i << ", got "
                      << printWasmType(arguments[i].type) << "." << std::endl;
            abort();
          }
          locals[function->params[i].name] = arguments[i];
        }
        for (auto& local : function->locals) {
          locals[local.name].type = local.type;
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
        expression->print(std::cout, indent) << '\n';
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
    class ExpressionRunner : public WasmVisitor<ExpressionRunner, Flow> {
      ModuleInstance& instance;
      FunctionScope& scope;

    public:
      ExpressionRunner(ModuleInstance& instance, FunctionScope& scope) : instance(instance), scope(scope) {}

      Flow visitBlock(Block *curr) {
        NOTE_ENTER("Block");
        Flow flow;
        for (auto expression : curr->list) {
          flow = visit(expression);
          if (flow.breaking()) {
            flow.clearIf(curr->name);
            return flow;
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
          condition = conditionFlow.value.getInteger();
        }
        return condition ? flow : Flow();
      }
      Flow visitSwitch(Switch *curr) {
        NOTE_ENTER("Switch");
        Flow flow = visit(curr->value);
        if (flow.breaking()) {
          flow.clearIf(curr->name);
          return flow;
        }
        NOTE_EVAL1(flow.value);
        int64_t index = flow.value.getInteger();
        Name target = curr->default_;
        if (index >= 0 && (size_t)index < curr->targets.size()) {
          target = curr->targets[index];
        }
        // This is obviously very inefficient. This should be a cached data structure
        std::map<Name, size_t> caseMap; // name => index in cases
        for (size_t i = 0; i < curr->cases.size(); i++) {
          caseMap[curr->cases[i].name] = i;
        }
        auto iter = caseMap.find(target);
        if (iter == caseMap.end()) {
          // not in the cases, so this is a break
          Flow flow(target);
          flow.clearIf(curr->name);
          return flow;
        }
        size_t caseIndex = iter->second;
        assert(caseIndex < curr->cases.size());
        while (caseIndex < curr->cases.size()) {
          Switch::Case& c = curr->cases[caseIndex];
          flow = visit(c.body);
          if (flow.breaking()) {
            flow.clearIf(curr->name);
            break;
          }
          caseIndex++;
        }
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
        return instance.externalInterface->callImport(instance.wasm.importsMap[curr->target], arguments);
      }
      Flow visitCallIndirect(CallIndirect *curr) {
        NOTE_ENTER("CallIndirect");
        Flow target = visit(curr->target);
        if (target.breaking()) return target;
        size_t index = target.value.geti32();
        if (index >= instance.wasm.table.names.size()) trap("callIndirect: overflow");
        Name name = instance.wasm.table.names[index];
        Function *func = instance.wasm.functionsMap[name];
        if (func->type.is() && func->type != curr->fullType->name) trap("callIndirect: bad type");
        LiteralList arguments;
        Flow flow = generateArguments(curr->operands, arguments);
        if (flow.breaking()) return flow;
        return instance.callFunction(name, arguments);
      }

      Flow visitGetLocal(GetLocal *curr) {
        NOTE_ENTER("GetLocal");
        IString name = curr->name;
        NOTE_NAME(name);
        NOTE_EVAL1(scope.locals[name]);
        return scope.locals[name];
      }
      Flow visitSetLocal(SetLocal *curr) {
        NOTE_ENTER("SetLocal");
        IString name = curr->name;
        Flow flow = visit(curr->value);
        if (flow.breaking()) return flow;
        NOTE_NAME(name);
        NOTE_EVAL1(flow.value);
        assert(flow.value.type == curr->type);
        scope.locals[name] = flow.value;
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
            case Clz:            return value.countLeadingZeroes();
            case Ctz:            return value.countTrailingZeroes();
            case Popcnt:         return value.popCount();
            case ReinterpretInt: return value.castToF32();
            case ExtendSInt32:   return value.extendToSI64();
            case ExtendUInt32:   return value.extendToUI64();
            case ConvertUInt32:  return curr->type == f32 ? value.convertUToF32() : value.convertUToF64();
            case ConvertSInt32:  return curr->type == f32 ? value.convertSToF32() : value.convertSToF64();
            default: abort();
          }
        }
        if (value.type == i64) {
          switch (curr->op) {
            case Clz:            return value.countLeadingZeroes();
            case Ctz:            return value.countTrailingZeroes();
            case Popcnt:         return value.popCount();
            case WrapInt64:      return value.truncateToI32();
            case ReinterpretInt: return value.castToF64();
            case ConvertUInt64:  return curr->type == f32 ? value.convertUToF32() : value.convertUToF64();
            case ConvertSInt64:  return curr->type == f32 ? value.convertSToF32() : value.convertSToF64();
            default: abort();
          }
        }
        if (value.type == f32) {
          switch (curr->op) {
            case Neg:              return value.neg();
            case Abs:              return value.abs();
            case Ceil:             return value.ceil();
            case Floor:            return value.floor();
            case Trunc:            return value.trunc();
            case Nearest:          return value.nearbyint();
            case Sqrt:             return value.sqrt();
            case TruncSFloat32:    return truncSFloat(curr, value);
            case TruncUFloat32:    return truncUFloat(curr, value);
            case ReinterpretFloat: return value.castToI32();
            case PromoteFloat32:   return value.extendToF64();
            default: abort();
          }
        }
        if (value.type == f64) {
          switch (curr->op) {
            case Neg:              return value.neg();
            case Abs:              return value.abs();
            case Ceil:             return value.ceil();
            case Floor:            return value.floor();
            case Trunc:            return value.trunc();
            case Nearest:          return value.nearbyint();
            case Sqrt:             return value.sqrt();
            case TruncSFloat64:    return truncSFloat(curr, value);
            case TruncUFloat64:    return truncUFloat(curr, value);
            case ReinterpretFloat: return value.castToI64();
            case DemoteFloat64:    return value.truncateToF32();
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
        assert(left.type == curr->left->type);
        assert(right.type == curr->right->type);
        if (left.type == i32) {
          switch (curr->op) {
            case Add:      return left.add(right);
            case Sub:      return left.sub(right);
            case Mul:      return left.mul(right);
            case DivS: {
              if (right.getInteger() == 0) trap("i32.div_s by 0");
              if (left.getInteger() == INT32_MIN && right.getInteger() == -1) trap("i32.div_s overflow"); // signed division overflow
              return left.divS(right);
            }
            case DivU: {
              if (right.getInteger() == 0) trap("i32.div_u by 0");
              return left.divU(right);
            }
            case RemS: {
              if (right.getInteger() == 0) trap("i32.rem_s by 0");
              if (left.getInteger() == INT32_MIN && right.getInteger() == -1) return Literal(int32_t(0));
              return left.remS(right);
            }
            case RemU: {
              if (right.getInteger() == 0) trap("i32.rem_u by 0");
              return left.remU(right);
            }
            case And:  return left.and_(right);
            case Or:   return left.or_(right);
            case Xor:  return left.xor_(right);
            case Shl:  return left.shl(right.and_(Literal(int32_t(31))));
            case ShrU: return left.shrU(right.and_(Literal(int32_t(31))));
            case ShrS: return left.shrS(right.and_(Literal(int32_t(31))));
            case Eq:   return left.eq(right);
            case Ne:   return left.ne(right);
            case LtS:  return left.ltS(right);
            case LtU:  return left.ltU(right);
            case LeS:  return left.leS(right);
            case LeU:  return left.leU(right);
            case GtS:  return left.gtS(right);
            case GtU:  return left.gtU(right);
            case GeS:  return left.geS(right);
            case GeU:  return left.geU(right);
            default: abort();
          }
        } else if (left.type == i64) {
          switch (curr->op) {
            case Add:      return left.add(right);
            case Sub:      return left.sub(right);
            case Mul:      return left.mul(right);
            case DivS: {
              if (right.getInteger() == 0) trap("i64.div_s by 0");
              if (left.getInteger() == LLONG_MIN && right.getInteger() == -1LL) trap("i64.div_s overflow"); // signed division overflow
              return left.divS(right);
            }
            case DivU: {
              if (right.getInteger() == 0) trap("i64.div_u by 0");
              return left.divU(right);
            }
            case RemS: {
              if (right.getInteger() == 0) trap("i64.rem_s by 0");
              if (left.getInteger() == LLONG_MIN && right.getInteger() == -1LL) return Literal(int64_t(0));
              return left.remS(right);
            }
            case RemU: {
              if (right.getInteger() == 0) trap("i64.rem_u by 0");
              return left.remU(right);
            }
            case And:  return left.and_(right);
            case Or:   return left.or_(right);
            case Xor:  return left.xor_(right);
            case Shl:  return left.shl(right.and_(Literal(int64_t(63))));
            case ShrU: return left.shrU(right.and_(Literal(int64_t(63))));
            case ShrS: return left.shrS(right.and_(Literal(int64_t(63))));
            case Eq:   return left.eq(right);
            case Ne:   return left.ne(right);
            case LtS:  return left.ltS(right);
            case LtU:  return left.ltU(right);
            case LeS:  return left.leS(right);
            case LeU:  return left.leU(right);
            case GtS:  return left.gtS(right);
            case GtU:  return left.gtU(right);
            case GeS:  return left.geS(right);
            case GeU:  return left.geU(right);
            default: abort();
          }
        } else if (left.type == f32 || left.type == f64) {
          switch (curr->op) {
            case Add:      return left.add(right);
            case Sub:      return left.sub(right);
            case Mul:      return left.mul(right);
            case Div:      return left.div(right);
            case CopySign: return left.copysign(right);
            case Min:      return left.min(right);
            case Max:      return left.max(right);
            case Eq:       return left.eq(right);
            case Ne:       return left.ne(right);
            case Lt:       return left.lt(right);
            case Le:       return left.le(right);
            case Gt:       return left.gt(right);
            case Ge:       return left.ge(right);
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
          case PageSize:   return Literal((int32_t)pageSize);
          case MemorySize: return Literal((int32_t)instance.memorySize);
          case GrowMemory: {
            Flow flow = visit(curr->operands[0]);
            if (flow.breaking()) return flow;
            uint32_t delta = flow.value.geti32();
            if (delta % pageSize != 0) trap("growMemory: delta not multiple");
            if (delta > uint32_t(-1) - pageSize) trap("growMemory: delta relatively too big");
            if (instance.memorySize >= uint32_t(-1) - delta) trap("growMemory: delta objectively too big");
            uint32_t newSize = instance.memorySize + delta;
            if (newSize > instance.wasm.memory.max) trap("growMemory: exceeds max");
            instance.externalInterface->growMemory(instance.memorySize, newSize);
            instance.memorySize = newSize;
            return Literal();
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
        if (isnan(val)) trap("truncSFloat of nan");
        if (curr->type == i32) {
          if (val > (double)INT_MAX || val < (double)INT_MIN) trap("i32.truncSFloat overflow");
          return Literal(int32_t(val));
        } else {
          int64_t converted = val;
          if ((val >= 1 && converted <= 0) || val < (double)LLONG_MIN) trap("i32.truncSFloat overflow");
          return Literal(converted);
        }
      }

      Literal truncUFloat(Unary* curr, Literal value) {
        double val = value.getFloat();
        if (isnan(val)) trap("truncUFloat of nan");
        if (curr->type == i32) {
          if (val > (double)UINT_MAX || val <= (double)-1) trap("i64.truncUFloat overflow");
          return Literal(uint32_t(val));
        } else {
          uint64_t converted = val;
          if (converted < val - 1 || val <= (double)-1) trap("i64.truncUFloat overflow");
          return Literal(converted);
        }
      }

      void trap(const char* why) {
        instance.externalInterface->trap(why);
      }
    };

    if (callDepth > maxCallDepth) externalInterface->trap("stack limit");
    callDepth++;

    Function *function = wasm.functionsMap[name];
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
#ifdef WASM_INTERPRETER_DEBUG
    std::cout << "exiting " << function->name << " with " << ret << '\n';
#endif
    return ret;
  }

  size_t memorySize;

  template <class LS>
  size_t getFinalAddress(LS* curr, Literal ptr) {
    auto trapIfGt = [this](size_t lhs, size_t rhs, const char* msg) {
      if (lhs > rhs) {
        std::stringstream ss;
        ss << msg << ": " << lhs << " > " << rhs;
        externalInterface->trap(ss.str().c_str());
      }
    };
    uint64_t addr = ptr.type == i32 ? ptr.geti32() : ptr.geti64();
    trapIfGt(curr->offset, memorySize, "offset > memory");
    trapIfGt(addr, memorySize - curr->offset, "final > memory");
    addr += curr->offset;
    trapIfGt(curr->bytes, memorySize, "bytes > memory");
    trapIfGt(addr, memorySize - curr->bytes, "highest > memory");
    return addr;
  }

  ExternalInterface* externalInterface;
};

} // namespace wasm

#endif // wasm_wasm_interpreter_h
