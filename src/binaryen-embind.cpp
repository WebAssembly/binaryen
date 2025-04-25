#include "binaryen-c.h"
#include <emscripten/bind.h>

using namespace emscripten;

namespace {

EMSCRIPTEN_DECLARE_VAL_TYPE(ExpressionList);

EMSCRIPTEN_DECLARE_VAL_TYPE(TypeList);

namespace {
class ExpressionFactory {
protected:
  uintptr_t module;

public:
  ExpressionFactory(uintptr_t module) : module(module) {}
};
} // namespace

class Module {
public:
  uintptr_t ptr;

  Module() : Module(reinterpret_cast<uintptr_t>(BinaryenModuleCreate())) {}

  Module(uintptr_t ptr) : ptr(ptr) {}

  uintptr_t
  block(const std::string& name, ExpressionList children, uintptr_t type) {
    std::vector<uintptr_t> childrenVec =
      convertJSArrayToNumberVector<uintptr_t>(children);
    return reinterpret_cast<uintptr_t>(BinaryenBlock(
      reinterpret_cast<BinaryenModuleRef>(ptr),
      name.c_str(),
      reinterpret_cast<BinaryenExpressionRef*>(childrenVec.begin().base()),
      childrenVec.size(),
      type));
  }

  uintptr_t if_(uintptr_t condition, uintptr_t ifTrue, uintptr_t ifFalse) {
    return reinterpret_cast<uintptr_t>(
      BinaryenIf(reinterpret_cast<BinaryenModuleRef>(ptr),
                 reinterpret_cast<BinaryenExpressionRef>(condition),
                 reinterpret_cast<BinaryenExpressionRef>(ifTrue),
                 reinterpret_cast<BinaryenExpressionRef>(ifFalse)));
  }

  uintptr_t loop(const std::string& label, uintptr_t body) {
    return reinterpret_cast<uintptr_t>(
      BinaryenLoop(reinterpret_cast<BinaryenModuleRef>(ptr),
                   label.c_str(),
                   reinterpret_cast<BinaryenExpressionRef>(body)));
  }

  uintptr_t br(const std::string& label, uintptr_t condition, uintptr_t value) {
    return reinterpret_cast<uintptr_t>(
      BinaryenBreak(reinterpret_cast<BinaryenModuleRef>(ptr),
                    label.c_str(),
                    reinterpret_cast<BinaryenExpressionRef>(condition),
                    reinterpret_cast<BinaryenExpressionRef>(value)));
  }

  uintptr_t addFunction(const std::string& name,
                        BinaryenType params,
                        BinaryenType results,
                        TypeList varTypes,
                        uintptr_t body) {
    std::vector<uintptr_t> varTypesVec =
      convertJSArrayToNumberVector<uintptr_t>(varTypes);
    return reinterpret_cast<uintptr_t>(
      BinaryenAddFunction(reinterpret_cast<BinaryenModuleRef>(ptr),
                          name.c_str(),
                          params,
                          results,
                          varTypesVec.begin().base(),
                          varTypesVec.size(),
                          reinterpret_cast<BinaryenExpressionRef>(body)));
  }

  std::string emitText() {
    char* text = BinaryenModuleAllocateAndWriteText(
      reinterpret_cast<BinaryenModuleRef>(ptr));
    std::string str = text;
    delete text;
    return str;
  }
};

Module* parseText(const std::string& text) {
  return new Module(
    reinterpret_cast<uintptr_t>(BinaryenModuleParse(text.c_str())));
}
}; // namespace

EMSCRIPTEN_BINDINGS(Binaryen) {
  constant("none", BinaryenTypeNone());
  constant("i32", BinaryenTypeInt32());
  constant("i64", BinaryenTypeInt64());

  class_<Module>("Module")
    .constructor()

    .function("block", &Module::block)
    .function("if", &Module::if_)
    .function("loop", &Module::loop)
    .function("br", &Module::br)
    .function("break", &Module::br)
    .function("br_if", &Module::br)

    .function("addFunction", &Module::addFunction)

    .function("emitText", &Module::emitText);

  function("parseText", parseText, allow_raw_pointer<Module>());

  register_type<ExpressionList>("number[]");

  register_type<TypeList>("number[]");
}