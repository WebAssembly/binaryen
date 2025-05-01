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
  wasm::Call* call(const std::string&, ExpressionList operands, TypeID type);
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
    wasm::LocalSet* tee(Index index, wasm::Expression* value, TypeID type);
  }* local = new Local{module};
  const struct Global : ExpressionFactory {
    wasm::GlobalGet* get(const std::string& name, TypeID type);
    wasm::GlobalSet* set(const std::string& name, wasm::Expression* value);
  }* global = new Global{module};
  const struct Table : ExpressionFactory {
    wasm::TableGet*
    get(const std::string& name, wasm::Expression* index, TypeID type);
    wasm::TableSet* set(const std::string& name,
                        wasm::Expression* index,
                        wasm::Expression* value);
    wasm::TableSize* size(const std::string& name);
    wasm::TableGrow* grow(const std::string& name,
                          wasm::Expression* value,
                          wasm::Expression* delta);
  }* table = new Table{module};
  const struct Memory : ExpressionFactory {
    wasm::MemorySize* size(const std::string& name, bool memory64 = false);
    wasm::MemoryGrow* grow(wasm::Expression* value,
                           const std::string& name,
                           bool memory64 = false);
    wasm::MemoryInit* init(const std::string& segment,
                           wasm::Expression* dest,
                           wasm::Expression* offset,
                           wasm::Expression* size,
                           const std::string& name);
    wasm::MemoryCopy* copy(wasm::Expression* dest,
                           wasm::Expression* source,
                           wasm::Expression* size,
                           const std::string& destMemory,
                           const std::string& sourceMemory);
    wasm::MemoryFill* fill(wasm::Expression* dest,
                           wasm::Expression* value,
                           wasm::Expression* size,
                           const std::string& name);
    const struct Atomic : ExpressionFactory {
      wasm::AtomicNotify* notify(wasm::Expression* ptr,
                                 wasm::Expression* notifyCount,
                                 const std::string& name);
      wasm::AtomicWait* wait32(wasm::Expression* ptr,
                               wasm::Expression* expected,
                               wasm::Expression* timeout,
                               const std::string& name);
      wasm::AtomicWait* wait64(wasm::Expression* ptr,
                               wasm::Expression* expected,
                               wasm::Expression* timeout,
                               const std::string& name);
    }* atomic = new Atomic{module};
  }* memory = new Memory{module};
  const struct Data : ExpressionFactory {
    wasm::DataDrop* drop(const std::string& segment);
  }* data = new Data{module};
  const struct I32 : ExpressionFactory {
    wasm::Binary* add(wasm::Expression* left, wasm::Expression* right);
  }* i32 = new I32{module};
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

emscripten::val getExpressionInfo(wasm::Expression* expr);
}; // namespace binaryen