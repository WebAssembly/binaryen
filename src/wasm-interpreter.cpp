
// Simple WebAssembly interpreter, designed to be embeddable in JavaScript, so it
// can function as a polyfill.

#include "wasm.h"

using namespace cashew;
using namespace wasm;

namespace wasm {

// An instance of a WebAssembly module
class ModuleInstance {
public:
  ModuleInstance(Module& wasm) : wasm(wasm) {
    for (auto function : wasm.functions) {
      functions[function->name] = function;
    }
  }

  Literal callFunction(const char *name) {
    return callFunction(IString(name));
  }

  Literal callFunction(IString name) {
    // Stuff that flows around during executing expressions: a literal, or a change in control flow
    class Flow {
    public:
      Flow() {}
      Flow(Literal value) : value(value) {}

      Literal value;
      IString breakTo; // if non-null, a break is going on

      bool breaking() { return breakTo.is(); }

      void clearIf(IString target) {
        if (breakTo == target) {
          breakTo.clear();
        }
      }
    };

    // Execute a statement
    class ExpressionRunner : public WasmVisitor<Flow> {
    private:
      std::vector<Literal> arguments; // filled in before a call, cleared by the call

    public:
      Flow visitBlock(Block *curr) override {
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
        Flow flow = visit(curr->condition);
        if (flow.breaking()) return flow;
        if (flow.value.geti32()) return visit(curr->ifTrue);
        if (curr->ifFalse) return visit(curr->ifFalse);
        return Flow();
      }
      Flow visitLoop(Loop *curr) override {
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
        Flow flow = visit(curr->body);
        flow.clearIf(curr->name);
        return flow;
      }
      Flow visitBreak(Break *curr) override {
        if (curr->condition) {
          Flow flow = visit(curr->condition);
          if (flow.breaking()) return flow;
          if (!flow.value.geti32()) return Flow();
        }
        Flow flow = visit(curr->value);
        if (!flow.breaking()) {
          flow.breakTo = curr->name;
        }
        return flow;
      }
      Flow visitSwitch(Switch *curr) override {
        abort();
      }
      Flow visitCall(Call *curr) override {
      }
      Flow visitCallImport(CallImport *curr) override {
      }
      Flow visitCallIndirect(CallIndirect *curr) override {
      }
      Flow visitGetLocal(GetLocal *curr) override {
      }
      Flow visitSetLocal(SetLocal *curr) override {
      }
      Flow visitLoad(Load *curr) override {
      }
      Flow visitStore(Store *curr) override {
      }
      Flow visitConst(Const *curr) override {
        return Flow(curr->value); // heh
      }
      Flow visitUnary(Unary *curr) override {
      }
      Flow visitBinary(Binary *curr) override {
      }
      Flow visitCompare(Compare *curr) override {
      }
      Flow visitConvert(Convert *curr) override {
      }
      Flow visitHost(Host *curr) override {
      }
      Flow visitNop(Nop *curr) override {
      }
    };

    return ExpressionRunner().visit(functions[name]->body).value;
  }

private:
  Module& wasm;

  std::map<IString, Function*> functions;

};

} // namespace wasm

