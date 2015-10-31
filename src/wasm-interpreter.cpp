
// Simple WebAssembly interpreter, designed to be embeddable in JavaScript, so it
// can function as a polyfill.

#include "wasm.h"

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
    class Flow : public Literal {
    public:
      IString breakTo; // if non-null, a break is going on
    };

    // Execute a statement
    class ExpressionRunner : public WasmVisitor<Flow> {
      virtual Flow visitBlock(Block *curr) {
        Flow flow;
        for (auto expression : curr->list) {
          flow = visit(expression);
          if (flow.breakTo) {
            if (flow.breakTo == curr->name) {
              flow.breakTo.clear();
            }
            return flow;
          }
        }
        return flow;
      }
      virtual Flow visitIf(If *curr)  {
      }
      virtual Flow visitLoop(Loop *curr)  {
      }
      virtual Flow visitLabel(Label *curr)  {
      }
      virtual Flow visitBreak(Break *curr)  {
      }
      virtual Flow visitSwitch(Switch *curr)  {
      }
      virtual Flow visitCall(Call *curr)  {
      }
      virtual Flow visitCallImport(CallImport *curr)  {
      }
      virtual Flow visitCallIndirect(CallIndirect *curr)  {
      }
      virtual Flow visitGetLocal(GetLocal *curr)  {
      }
      virtual Flow visitSetLocal(SetLocal *curr)  {
      }
      virtual Flow visitLoad(Load *curr)  {
      }
      virtual Flow visitStore(Store *curr)  {
      }
      virtual Flow visitConst(Const *curr)  {
      }
      virtual Flow visitUnary(Unary *curr)  {
      }
      virtual Flow visitBinary(Binary *curr)  {
      }
      virtual Flow visitCompare(Compare *curr)  {
      }
      virtual Flow visitConvert(Convert *curr)  {
      }
      virtual Flow visitHost(Host *curr)  {
      }
      virtual Flow visitNop(Nop *curr)  {
      }
    };

    return ExpressionRunner().visit(functions[name]->body);
  }

private:
  Module& wasm;

  std::map<IString, Function*> functions;

};

} // namespace wasm

