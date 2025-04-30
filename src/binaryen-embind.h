#include "wasm.h"
#include <emscripten/bind.h>

namespace binaryen {

typedef uint32_t Index;

EMSCRIPTEN_DECLARE_VAL_TYPE(Binary);

// https://github.com/emscripten-core/emscripten/issues/24211
EMSCRIPTEN_DECLARE_VAL_TYPE(OptionalString);

EMSCRIPTEN_DECLARE_VAL_TYPE(ExpressionList);

EMSCRIPTEN_DECLARE_VAL_TYPE(NameList);

using TypeID = uint32_t;

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

  wasm::Block* block(OptionalString name,
                     ExpressionList children,
                     std::optional<TypeID> type);
  wasm::If* if_(wasm::Expression* condition,
                wasm::Expression* ifTrue,
                wasm::Expression* ifFalse);
  wasm::Loop* loop(OptionalString label, wasm::Expression* body);
  wasm::Break* br(const std::string& label,
                  wasm::Expression* condition,
                  wasm::Expression* value);
  wasm::Switch* switch_(NameList names,
                        const std::string& defaultName,
                        wasm::Expression* condition,
                        wasm::Expression* value);
  wasm::Call*
  call(const std::string&, ExpressionList operands, TypeID type);
  wasm::CallIndirect* call_indirect(const std::string& table,
                                    wasm::Expression* target,
                                    ExpressionList operands,
                                    TypeID params,
                                    TypeID results);
  wasm::Call*
  return_call(const std::string&, ExpressionList operands, TypeID type);
  wasm::CallIndirect* return_call_indirect(const std::string& table,
                                           wasm::Expression* target,
                                           ExpressionList operands,
                                           TypeID params,
                                           TypeID results);
  const struct Local : ExpressionFactory {
    wasm::LocalGet* get(Index index, TypeID type);
    wasm::LocalSet* set(Index index, wasm::Expression* value);
    wasm::LocalSet*
    tee(Index index, wasm::Expression* value, TypeID type);
  } local{module};
  const struct Global : ExpressionFactory {
    wasm::GlobalGet* get(const std::string& name, TypeID type);
    wasm::GlobalSet* set(const std::string& name, wasm::Expression* value);
  } global{module};
  const struct I32 : ExpressionFactory {
    wasm::Binary* add(wasm::Expression* left, wasm::Expression* right);
  } i32{module};
  wasm::Return* return_(wasm::Expression* value);

  wasm::Function* addFunction(const std::string& name,
                              TypeID params,
                              TypeID results,
                              TypeList varTypes,
                              wasm::Expression* body);
  wasm::Export* addFunctionExport(const std::string& internalName,
                                  const std::string& externalName);

  Binary emitBinary();
  std::string emitText();
  std::string emitStackIR();
  std::string emitAsmjs();

  bool validate();
  void optimize();
  void optimizeFunction(wasm::Function* func);

  void dispose();
};

Module* parseText(const std::string& text);

TypeID createType(TypeList types);
}; // namespace binaryen