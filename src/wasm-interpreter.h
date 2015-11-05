//
// Simple WebAssembly interpreter, designed to be embeddable in JavaScript, so it
// can function as a polyfill.
//

#include "wasm.h"

namespace wasm {

using namespace cashew;

//
// An instance of a WebAssembly module, which can execute it via AST interpretation
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
    virtual Literal load(Load* load, Literal ptr) = 0;
    virtual void store(Store* store, Literal ptr, Literal value) = 0;
  };

  ModuleInstance(Module& wasm, ExternalInterface* externalInterface) : wasm(wasm), externalInterface(externalInterface) {
    for (auto function : wasm.functions) {
      functions[function->name] = function;
    }

    externalInterface->init(wasm);
  }

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

      FunctionScope(Function* function, LiteralList& arguments) {
        assert(function->params.size() == arguments.size());
        for (size_t i = 0; i < arguments.size(); i++) {
          assert(function->params[i].type == arguments[i].type);
          locals[function->params[i].name] = arguments[i];
        }
        for (auto& local : function->locals) {
          locals[local.name].type = local.type;
        }
      }
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

      std::ostream& print(std::ostream& o) {
        o << "(flow " << (breakTo.is() ? breakTo.str : "-") << " : " << value << ')';
        return o;
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
        doIndent(std::cout, indent);
        expression->print(std::cout, indent) << '\n';
        indent++;
      }
      ~IndentHandler() {
        indent--;
        indent--;
        doIndent(std::cout, indent);
        std::cout << "exit " << name << '\n';
      }
    };
    #define NOTE_ENTER(x) IndentHandler indentHandler(instance.indent, x, curr);
    #define NOTE_EVAL() { doIndent(std::cout, instance.indent); std::cout << "eval " << indentHandler.name << '\n'; }
    #define NOTE_EVAL1(p0) { doIndent(std::cout, instance.indent); std::cout << "eval " << indentHandler.name << '('  << p0 << ")\n"; }
    #define NOTE_EVAL2(p0, p1) { doIndent(std::cout, instance.indent); std::cout << "eval " << indentHandler.name << '('  << p0 << ", " << p1 << ")\n"; }
#else
    #define NOTE_ENTER(x)
    #define NOTE_EVAL()
    #define NOTE_EVAL1(p0)
    #define NOTE_EVAL2(p0, p1)
#endif

    // Execute a statement
    class ExpressionRunner : public WasmVisitor<Flow> {
      ModuleInstance& instance;
      FunctionScope& scope;

    public:
      ExpressionRunner(ModuleInstance& instance, FunctionScope& scope) : instance(instance), scope(scope) {}

      Flow visitBlock(Block *curr) override {
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
      Flow visitIf(If *curr) override {
        NOTE_ENTER("If");
        Flow flow = visit(curr->condition);
        if (flow.breaking()) return flow;
        NOTE_EVAL1(flow.value);
        if (flow.value.geti32()) return visit(curr->ifTrue);
        if (curr->ifFalse) return visit(curr->ifFalse);
        return Flow();
      }
      Flow visitLoop(Loop *curr) override {
        NOTE_ENTER("Loop");
        while (1) {
          Flow flow = visit(curr->body);
          if (flow.breaking()) {
            if (flow.breakTo == curr->in) continue; // lol
            flow.clearIf(curr->out);
            return flow;
          }
        }
      }
      Flow visitLabel(Label *curr) override {
        NOTE_ENTER("Label");
        Flow flow = visit(curr->body);
        flow.clearIf(curr->name);
        return flow;
      }
      Flow visitBreak(Break *curr) override {
        NOTE_ENTER("Break");
        if (curr->value) {
          Flow flow = visit(curr->value);
          if (!flow.breaking()) {
            flow.breakTo = curr->name;
          }
          return flow;
        }
        return Flow(curr->name);
      }
      Flow visitSwitch(Switch *curr) override {
        NOTE_ENTER("Switch");
        Flow flow = visit(curr->value);
        if (flow.breaking()) {
          flow.clearIf(curr->name);
          return flow;
        }
        NOTE_EVAL1(flow.value);
        int32_t index = flow.value.geti32();
        Name target = curr->default_;
        if (index >= 0 && index < curr->targets.size()) {
          target = curr->targets[index];
        }
        auto iter = curr->caseMap.find(target);
        if (iter == curr->caseMap.end()) {
          // not in the cases, so this is a break outside
          return Flow(target);
        }
        size_t caseIndex = iter->second;
        assert(caseIndex < curr->cases.size());
        while (caseIndex < curr->cases.size()) {
          Switch::Case& c = curr->cases[caseIndex];
          Flow flow = visit(c.body);
          if (flow.breaking()) {
            flow.clearIf(curr->name);
            return flow;
          }
          caseIndex++;
        }
        return Flow();
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

      Flow visitCall(Call *curr) override {
        NOTE_ENTER("Call");
        LiteralList arguments;
        Flow flow = generateArguments(curr->operands, arguments);
        if (flow.breaking()) return flow;
        return instance.callFunction(curr->target, arguments);
      }
      Flow visitCallImport(CallImport *curr) override {
        NOTE_ENTER("CallImport");
        LiteralList arguments;
        Flow flow = generateArguments(curr->operands, arguments);
        if (flow.breaking()) return flow;
        return instance.externalInterface->callImport(&instance.wasm.imports[curr->target], arguments);
      }
      Flow visitCallIndirect(CallIndirect *curr) override {
        NOTE_ENTER("CallIndirect");
        Flow target = visit(curr->target);
        if (target.breaking()) return target;
        size_t index = target.value.geti32();
        assert(index < instance.wasm.table.names.size());
        IString name = instance.wasm.table.names[index];
        LiteralList arguments;
        Flow flow = generateArguments(curr->operands, arguments);
        if (flow.breaking()) return flow;
        return instance.callFunction(name, arguments);
      }

      Flow visitGetLocal(GetLocal *curr) override {
        NOTE_ENTER("GetLocal");
        NOTE_EVAL1(scope.locals[curr->name]);
        return scope.locals[curr->name];
      }
      Flow visitSetLocal(SetLocal *curr) override {
        NOTE_ENTER("SetLocal");
        Flow flow = visit(curr->value);
        if (flow.breaking()) return flow;
        NOTE_EVAL1(flow.value);
        scope.locals[curr->name] = flow.value;
        return flow;
      }
      Flow visitLoad(Load *curr) override {
        NOTE_ENTER("Load");
        Flow flow = visit(curr->ptr);
        if (flow.breaking()) return flow;
        return instance.externalInterface->load(curr, flow.value);
      }
      Flow visitStore(Store *curr) override {
        NOTE_ENTER("Store");
        Flow ptr = visit(curr->ptr);
        if (ptr.breaking()) return ptr;
        Flow value = visit(curr->value);
        if (value.breaking()) return value;
        instance.externalInterface->store(curr, ptr.value, value.value);
        return value;
      }
      Flow visitConst(Const *curr) override {
        NOTE_ENTER("Const");
        NOTE_EVAL1(curr->value);
        return Flow(curr->value); // heh
      }
      Flow visitUnary(Unary *curr) override {
        NOTE_ENTER("Unary");
        Flow flow = visit(curr->value);
        if (flow.breaking()) return flow;
        Literal value = flow.value;
        NOTE_EVAL1(value);
        switch (curr->op) { // rofl
          case Clz:   return Flow(Literal((int32_t)__builtin_clz(value.geti32())));
          case Neg:   return Flow(Literal(-value.getf64()));
          case Floor: return Flow(Literal(floor(value.getf64())));
          default: abort();
        }
      }
      Flow visitBinary(Binary *curr) override {
        NOTE_ENTER("Binary");
        Flow flow = visit(curr->left);
        if (flow.breaking()) return flow;
        Literal left = flow.value;
        flow = visit(curr->right);
        if (flow.breaking()) return flow;
        Literal right = flow.value;
        NOTE_EVAL2(left, right);
        switch (curr->op) { // lmao
          case Add:      return curr->type == i32 ? Flow(Literal(left.geti32() + right.geti32())) : Flow(Literal(left.getf64() + right.getf64()));
          case Sub:      return curr->type == i32 ? Flow(Literal(left.geti32() - right.geti32())) : Flow(Literal(left.getf64() - right.getf64()));
          case Mul:      return curr->type == i32 ? Flow(Literal(left.geti32() * right.geti32())) : Flow(Literal(left.getf64() * right.getf64()));
          case DivS:     return Flow(Literal(left.geti32() / right.geti32()));
          case DivU:     return Flow(Literal(int32_t(uint32_t(left.geti32()) / uint32_t(right.geti32()))));
          case RemS:     return Flow(Literal(left.geti32() % right.geti32()));
          case RemU:     return Flow(Literal(int32_t(uint32_t(left.geti32()) % uint32_t(right.geti32()))));
          case And:      return Flow(Literal(left.geti32() & right.geti32()));
          case Or:       return Flow(Literal(left.geti32() | right.geti32()));
          case Xor:      return Flow(Literal(left.geti32() ^ right.geti32()));
          case Shl:      return Flow(Literal(left.geti32() << right.geti32()));
          case ShrU:     return Flow(Literal(int32_t(uint32_t(left.geti32()) >> uint32_t(right.geti32()))));
          case ShrS:     return Flow(Literal(left.geti32() >> right.geti32()));
          case Div:      return Flow(Literal(left.getf64() / right.getf64()));
          case CopySign: return Flow(Literal(std::copysign(left.getf64(), right.getf64())));
          case Min:      return Flow(Literal(std::min(left.getf64(), right.getf64())));
          case Max:      return Flow(Literal(std::max(left.getf64(), right.getf64())));
          default: abort();
        }
      }
      Flow visitCompare(Compare *curr) override {
        NOTE_ENTER("Compare");
        Flow flow = visit(curr->left);
        if (flow.breaking()) return flow;
        Literal left = flow.value;
        flow = visit(curr->right);
        if (flow.breaking()) return flow;
        Literal right = flow.value;
        NOTE_EVAL2(left, right);
        switch (curr->op) { // :)
          case Eq:  return curr->left->type == i32 ? Flow(Literal(left.geti32() == right.geti32())) : Flow(Literal(left.getf64() == right.getf64()));
          case Ne:  return curr->left->type == i32 ? Flow(Literal(left.geti32() != right.geti32())) : Flow(Literal(left.getf64() != right.getf64()));
          case LtS: return Flow(Literal(left.geti32() < right.geti32()));
          case LtU: return Flow(Literal(uint32_t(left.geti32()) < uint32_t(right.geti32())));
          case LeS: return Flow(Literal(left.geti32() <= right.geti32()));
          case LeU: return Flow(Literal(uint32_t(left.geti32()) <= uint32_t(right.geti32())));
          case GtS: return Flow(Literal(left.geti32() > right.geti32()));
          case GtU: return Flow(Literal(uint32_t(left.geti32()) > uint32_t(right.geti32())));
          case GeS: return Flow(Literal(left.geti32() >= right.geti32()));
          case GeU: return Flow(Literal(uint32_t(left.geti32()) >= uint32_t(right.geti32())));
          case Lt:  return Flow(Literal(left.getf64() < right.getf64()));
          case Le:  return Flow(Literal(left.getf64() <= right.getf64()));
          case Gt:  return Flow(Literal(left.getf64() > right.getf64()));
          case Ge:  return Flow(Literal(left.getf64() >= right.getf64()));
          default: abort();
        }
      }
      Flow visitConvert(Convert *curr) override {
        NOTE_ENTER("Convert");
        Flow flow = visit(curr->value);
        if (flow.breaking()) return flow;
        Literal value = flow.value;
        switch (curr->op) { // :-)
          case ExtendSInt32:     return Flow(Literal(int64_t(value.geti32())));
          case ExtendUInt32:     return Flow(Literal(uint64_t((uint32_t)value.geti32())));
          case WrapInt64:        return Flow(Literal(int32_t(value.geti64())));
          case TruncSFloat32:    return Flow(Literal(int32_t(value.getf32())));
          case TruncUFloat32:    return Flow(Literal(uint32_t(value.getf32())));
          case TruncSFloat64:    return Flow(Literal(int32_t(value.getf64())));
          case TruncUFloat64:    return Flow(Literal(int32_t((uint32_t)value.getf64())));
          case ReinterpretFloat: return curr->type == i32 ? Flow(Literal(value.reinterpreti32())) : Flow(Literal(value.reinterpreti64()));
          case ConvertUInt32:    return Flow(Literal(double(uint32_t(value.geti32()))));
          case ConvertSInt32:    return Flow(Literal(double(int32_t(value.geti32()))));
          case ConvertUInt64:    return Flow(Literal(double((uint64_t)value.geti64())));
          case ConvertSInt64:    return Flow(Literal(double(value.geti64())));
          case PromoteFloat32:   return Flow(Literal(double(value.getf32())));
          case DemoteFloat64:    return Flow(Literal(float(value.getf64())));
          case ReinterpretInt:   return curr->type == f32 ? Flow(Literal(value.reinterpretf32())) : Flow(Literal(value.reinterpretf64()));
          default: abort();
        }
      }
      Flow visitSelect(Select *curr) override {
        NOTE_ENTER("Select");
        Flow condition = visit(curr->condition);
        if (condition.breaking()) return condition;
        NOTE_EVAL1(condition.value);
        Flow ifTrue = visit(curr->ifTrue);
        if (ifTrue.breaking()) return ifTrue;
        Flow ifFalse = visit(curr->ifFalse);
        if (ifFalse.breaking()) return ifFalse;
        return condition.value.geti32() ? ifTrue : ifFalse; // ;-)
      }
      Flow visitHost(Host *curr) override {
        NOTE_ENTER("Host");
        abort();
      }
      Flow visitNop(Nop *curr) override {
        NOTE_ENTER("Nop");
        return Flow();
      }
    };

    Function *function = functions[name];
    FunctionScope scope(function, arguments);
    return ExpressionRunner(*this, scope).visit(function->body).value;
  }

  // Convenience method, for the case where you have no arguments.
  Literal callFunction(IString name) {
    LiteralList empty;
    return callFunction(name, empty);
  }

  std::map<IString, Function*> functions;

private:
  Module& wasm;
  ExternalInterface* externalInterface;
};

} // namespace wasm

