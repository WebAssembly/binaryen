#include "wasm.h"
#include <emscripten/bind.h>

namespace binaryen {

typedef uint32_t Index;

typedef uintptr_t Type;

EMSCRIPTEN_DECLARE_VAL_TYPE(ExpressionList);

EMSCRIPTEN_DECLARE_VAL_TYPE(TypeList);

struct ExpressionFactory {
  wasm::Module* module;
};

class Module {
private:
  wasm::Module* module;

public:
  Module();

  Module(wasm::Module* module);

  const uintptr_t& ptr() const;

  wasm::Expression*
  block(const std::string& name, ExpressionList children, uintptr_t type);
  wasm::Expression* if_(wasm::Expression* condition,
                        wasm::Expression* ifTrue,
                        wasm::Expression* ifFalse);
  wasm::Expression* loop(const std::string& label, wasm::Expression* body);
  wasm::Expression* br(const std::string& label,
                       wasm::Expression* condition,
                       wasm::Expression* value);
  const struct Local : ExpressionFactory {
    wasm::Expression* get(Index index, Type type);
  } local{module};
  const struct I32 : ExpressionFactory {
    wasm::Expression* add(wasm::Expression* left, wasm::Expression* right);
  } i32{module};
  wasm::Expression* return_(wasm::Expression* value);

  uintptr_t addFunction(const std::string& name,
                        Type params,
                        Type results,
                        TypeList varTypes,
                        uintptr_t body);
  uintptr_t addFunctionExport(const std::string& internalName,
                              const std::string& externalName);

  std::string emitText();
};

Module* parseText(const std::string& text);

Type createType(TypeList types);
}; // namespace binaryen