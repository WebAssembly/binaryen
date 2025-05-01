#include "wasm.h"
#include <emscripten/bind.h>

namespace binaryen {

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
                     std::optional<TypeID> type) const;
  wasm::If* if_(wasm::Expression* condition,
                wasm::Expression* ifTrue,
                wasm::Expression* ifFalse) const;
  wasm::Loop* loop(OptionalString label, wasm::Expression* body) const;
  wasm::Break* br(const std::string& label,
                  wasm::Expression* condition,
                  wasm::Expression* value) const;
  wasm::Switch* switch_(NameList names,
                        const std::string& defaultName,
                        wasm::Expression* condition,
                        wasm::Expression* value) const;
  wasm::Call*
  call(const std::string&, ExpressionList operands, TypeID type) const;
  wasm::CallIndirect* call_indirect(const std::string& table,
                                    wasm::Expression* target,
                                    ExpressionList operands,
                                    TypeID params,
                                    TypeID results) const;
  wasm::Call*
  return_call(const std::string&, ExpressionList operands, TypeID type) const;
  wasm::CallIndirect* return_call_indirect(const std::string& table,
                                           wasm::Expression* target,
                                           ExpressionList operands,
                                           TypeID params,
                                           TypeID results) const;
  const struct Local : ExpressionFactory {
    wasm::LocalGet* get(uint32_t index, TypeID type) const;
    wasm::LocalSet* set(uint32_t index, wasm::Expression* value) const;
    wasm::LocalSet*
    tee(uint32_t index, wasm::Expression* value, TypeID type) const;
  }* local = new Local{module};
  const struct Global : ExpressionFactory {
    wasm::GlobalGet* get(const std::string& name, TypeID type) const;
    wasm::GlobalSet* set(const std::string& name,
                         wasm::Expression* value) const;
  }* global = new Global{module};
  const struct Table : ExpressionFactory {
    wasm::TableGet*
    get(const std::string& name, wasm::Expression* index, TypeID type) const;
    wasm::TableSet* set(const std::string& name,
                        wasm::Expression* index,
                        wasm::Expression* value) const;
    wasm::TableSize* size(const std::string& name) const;
    wasm::TableGrow* grow(const std::string& name,
                          wasm::Expression* value,
                          wasm::Expression* delta) const;
  }* table = new Table{module};
  const struct Memory : ExpressionFactory {
    wasm::MemorySize* size(const std::string& name,
                           bool memory64 = false) const;
    wasm::MemoryGrow* grow(wasm::Expression* value,
                           const std::string& name,
                           bool memory64 = false) const;
    wasm::MemoryInit* init(const std::string& segment,
                           wasm::Expression* dest,
                           wasm::Expression* offset,
                           wasm::Expression* size,
                           const std::string& name) const;
    wasm::MemoryCopy* copy(wasm::Expression* dest,
                           wasm::Expression* source,
                           wasm::Expression* size,
                           const std::string& destMemory,
                           const std::string& sourceMemory) const;
    wasm::MemoryFill* fill(wasm::Expression* dest,
                           wasm::Expression* value,
                           wasm::Expression* size,
                           const std::string& name) const;
    const struct Atomic : ExpressionFactory {
      wasm::AtomicNotify* notify(wasm::Expression* ptr,
                                 wasm::Expression* notifyCount,
                                 const std::string& name) const;
      wasm::AtomicWait* wait32(wasm::Expression* ptr,
                               wasm::Expression* expected,
                               wasm::Expression* timeout,
                               const std::string& name) const;
      wasm::AtomicWait* wait64(wasm::Expression* ptr,
                               wasm::Expression* expected,
                               wasm::Expression* timeout,
                               const std::string& name) const;
    }* atomic = new Atomic{module};
  }* memory = new Memory{{module}};
  const struct Data : ExpressionFactory {
    wasm::DataDrop* drop(const std::string& segment) const;
  }* data = new Data{module};
  struct I32 : ExpressionFactory {
    wasm::Load* load(uint32_t offset,
                     uint32_t align,
                     wasm::Expression* ptr,
                     const std::string& name) const;
    wasm::Load* load8_s(uint32_t offset,
                        uint32_t align,
                        wasm::Expression* ptr,
                        const std::string& name) const;
    wasm::Load* load8_u(uint32_t offset,
                        uint32_t align,
                        wasm::Expression* ptr,
                        const std::string& name) const;
    wasm::Load* load16_s(uint32_t offset,
                         uint32_t align,
                         wasm::Expression* ptr,
                         const std::string& name) const;
    wasm::Load* load16_u(uint32_t offset,
                         uint32_t align,
                         wasm::Expression* ptr,
                         const std::string& name) const;
    wasm::Store* store(uint32_t offset,
                       uint32_t align,
                       wasm::Expression* ptr,
                       wasm::Expression* value,
                       const std::string& name) const;
    wasm::Store* store8(uint32_t offset,
                        uint32_t align,
                        wasm::Expression* ptr,
                        wasm::Expression* value,
                        const std::string& name) const;
    wasm::Store* store16(uint32_t offset,
                         uint32_t align,
                         wasm::Expression* ptr,
                         wasm::Expression* value,
                         const std::string& name) const;
    wasm::Const* const_(uint32_t x) const;
    wasm::Binary* add(wasm::Expression* left, wasm::Expression* right) const;
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

std::string toText(wasm::Expression* expr);
}; // namespace binaryen