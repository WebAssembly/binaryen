#include "wasm.h"
#include <emscripten/bind.h>

namespace binaryen {

typedef uint32_t Index;

typedef uintptr_t Type;

EMSCRIPTEN_DECLARE_VAL_TYPE(ExpressionList);

EMSCRIPTEN_DECLARE_VAL_TYPE(TypeList);

namespace {
class ExpressionFactory {
protected:
  wasm::Module* module;

public:
  ExpressionFactory(wasm::Module* module);
};

class LocalExpressionFactory : public ExpressionFactory {
public:
  using ExpressionFactory::ExpressionFactory;

  uintptr_t get(Index index, Type type);
};

class I32ExpressionFactory : public ExpressionFactory {
public:
  using ExpressionFactory::ExpressionFactory;

  uintptr_t add(uintptr_t left, uintptr_t right);
};
} // namespace

class Module {
private:
  wasm::Module* module;

public:
  Module();

  Module(wasm::Module* module);

  const uintptr_t& ptr() const;

  uintptr_t
  block(const std::string& name, ExpressionList children, uintptr_t type);
  uintptr_t if_(uintptr_t condition, uintptr_t ifTrue, uintptr_t ifFalse);
  uintptr_t loop(const std::string& label, uintptr_t body);
  uintptr_t br(const std::string& label, uintptr_t condition, uintptr_t value);
  const LocalExpressionFactory local = LocalExpressionFactory(this->module);
  const I32ExpressionFactory i32 = I32ExpressionFactory(this->module);
  uintptr_t return_(uintptr_t value);

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

namespace {
template<typename Type = wasm::Expression> class Expression {
protected:
  Type* expression;

public:
  Expression(Type* expression) : expression(expression) {}
};

#define DELEGATE_FIELD_MAIN_START

#define DELEGATE_FIELD_CASE_START(id)                                          \
  class id : public Expression<wasm::id> {                                     \
  public:

#define DELEGATE_FIELD_CASE_END(id)                                            \
  }                                                                            \
  ;

#define DELEGATE_FIELD_MAIN_END

#define DELEGATE_FIELD_CHILD(id, field)                                        \
  auto& field() const {                                                        \
    return expression->field;                                                  \
  } // TODO: cast to primitive types & split getter and setter

#define DELEGATE_FIELD_CHILD_VECTOR(id, field)

#define DELEGATE_FIELD_TYPE(id, field)
#define DELEGATE_FIELD_HEAPTYPE(id, field)
#define DELEGATE_FIELD_OPTIONAL_CHILD(id, field)
#define DELEGATE_FIELD_INT(id, field)
#define DELEGATE_FIELD_LITERAL(id, field)
#define DELEGATE_FIELD_NAME(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_USE(id, field)
#define DELEGATE_FIELD_ADDRESS(id, field)
#define DELEGATE_FIELD_INT_ARRAY(id, field)
#define DELEGATE_FIELD_INT_VECTOR(id, field)
#define DELEGATE_FIELD_NAME_VECTOR(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_USE_VECTOR(id, field)
#define DELEGATE_FIELD_TYPE_VECTOR(id, field)

#include "wasm-delegations-fields.def"
} // namespace
}; // namespace binaryen