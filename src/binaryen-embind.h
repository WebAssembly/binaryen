#include "binaryen-c.h"
#include <emscripten/bind.h>

namespace {

EMSCRIPTEN_DECLARE_VAL_TYPE(ExpressionList);

EMSCRIPTEN_DECLARE_VAL_TYPE(TypeList);

class Module;

namespace {
class ExpressionFactory {
protected:
  Module* module;

public:
  ExpressionFactory(Module* module);
};

class LocalExpressionFactory : public ExpressionFactory {
public:
  using ExpressionFactory::ExpressionFactory;

  uintptr_t get(BinaryenIndex index, BinaryenType type);
};

class I32ExpressionFactory : public ExpressionFactory {
public:
  using ExpressionFactory::ExpressionFactory;

  uintptr_t add(uintptr_t left, uintptr_t right);
};
} // namespace

class Module {
public:
  uintptr_t ptr;

  Module();

  Module(uintptr_t ptr);

  uintptr_t
  block(const std::string& name, ExpressionList children, uintptr_t type);
  uintptr_t if_(uintptr_t condition, uintptr_t ifTrue, uintptr_t ifFalse);
  uintptr_t loop(const std::string& label, uintptr_t body);
  uintptr_t br(const std::string& label, uintptr_t condition, uintptr_t value);
  const LocalExpressionFactory local = LocalExpressionFactory(this);
  const I32ExpressionFactory i32 = I32ExpressionFactory(this);
  uintptr_t return_(uintptr_t value);

  uintptr_t addFunction(const std::string& name,
                        BinaryenType params,
                        BinaryenType results,
                        TypeList varTypes,
                        uintptr_t body);
  uintptr_t addFunctionExport(const std::string& internalName,
                              const std::string& externalName);

  std::string emitText();
};

Module* parseText(const std::string& text);

BinaryenType createType(TypeList types);
}; // namespace