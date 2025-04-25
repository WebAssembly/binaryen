#include "binaryen-embind.h"

using namespace emscripten;

namespace {

namespace {
ExpressionFactory::ExpressionFactory(Module* module) : module(module) {}

uintptr_t LocalExpressionFactory::get(BinaryenIndex index, BinaryenType type) {
  return reinterpret_cast<uintptr_t>(BinaryenLocalGet(
    reinterpret_cast<BinaryenModuleRef>(module->ptr), index, type));
}

uintptr_t I32ExpressionFactory::add(uintptr_t left, uintptr_t right) {
  return reinterpret_cast<uintptr_t>(
    BinaryenBinary(reinterpret_cast<BinaryenModuleRef>(module->ptr),
                   BinaryenAddInt32(),
                   reinterpret_cast<BinaryenExpressionRef>(left),
                   reinterpret_cast<BinaryenExpressionRef>(right)));
}
} // namespace

Module::Module()
  : Module(reinterpret_cast<uintptr_t>(BinaryenModuleCreate())) {}

Module::Module(uintptr_t ptr) : ptr(ptr) {}

uintptr_t Module::block(const std::string& name,
                        ExpressionList children,
                        uintptr_t type) {
  std::vector<uintptr_t> childrenVec =
    convertJSArrayToNumberVector<uintptr_t>(children);
  return reinterpret_cast<uintptr_t>(BinaryenBlock(
    reinterpret_cast<BinaryenModuleRef>(ptr),
    name.c_str(),
    reinterpret_cast<BinaryenExpressionRef*>(childrenVec.begin().base()),
    childrenVec.size(),
    type));
}
uintptr_t
Module::if_(uintptr_t condition, uintptr_t ifTrue, uintptr_t ifFalse) {
  return reinterpret_cast<uintptr_t>(
    BinaryenIf(reinterpret_cast<BinaryenModuleRef>(ptr),
               reinterpret_cast<BinaryenExpressionRef>(condition),
               reinterpret_cast<BinaryenExpressionRef>(ifTrue),
               reinterpret_cast<BinaryenExpressionRef>(ifFalse)));
}
uintptr_t Module::loop(const std::string& label, uintptr_t body) {
  return reinterpret_cast<uintptr_t>(
    BinaryenLoop(reinterpret_cast<BinaryenModuleRef>(ptr),
                 label.c_str(),
                 reinterpret_cast<BinaryenExpressionRef>(body)));
}
uintptr_t
Module::br(const std::string& label, uintptr_t condition, uintptr_t value) {
  return reinterpret_cast<uintptr_t>(
    BinaryenBreak(reinterpret_cast<BinaryenModuleRef>(ptr),
                  label.c_str(),
                  reinterpret_cast<BinaryenExpressionRef>(condition),
                  reinterpret_cast<BinaryenExpressionRef>(value)));
}
uintptr_t Module::return_(uintptr_t value) {
  return reinterpret_cast<uintptr_t>(
    BinaryenReturn(reinterpret_cast<BinaryenModuleRef>(ptr),
                   reinterpret_cast<BinaryenExpressionRef>(value)));
}

uintptr_t Module::addFunction(const std::string& name,
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
uintptr_t Module::addFunctionExport(const std::string& internalName,
                                    const std::string& externalName) {
  return reinterpret_cast<uintptr_t>(
    BinaryenAddFunctionExport(reinterpret_cast<BinaryenModuleRef>(ptr),
                              internalName.c_str(),
                              externalName.c_str()));
}

std::string Module::emitText() {
  char* text = BinaryenModuleAllocateAndWriteText(
    reinterpret_cast<BinaryenModuleRef>(ptr));
  std::string str = text;
  delete text;
  return str;
}

Module* parseText(const std::string& text) {
  return new Module(
    reinterpret_cast<uintptr_t>(BinaryenModuleParse(text.c_str())));
}

BinaryenType createType(TypeList types) {
  std::vector<uintptr_t> typesVec =
    convertJSArrayToNumberVector<uintptr_t>(types);
  return BinaryenTypeCreate(typesVec.begin().base(), typesVec.size());
}
} // namespace

EMSCRIPTEN_BINDINGS(Binaryen) {
  constant("none", BinaryenTypeNone());
  constant("i32", BinaryenTypeInt32());
  constant("i64", BinaryenTypeInt64());

  class_<LocalExpressionFactory>("LocalExpressionFactory")
    .function("get", &LocalExpressionFactory::get);

  class_<I32ExpressionFactory>("I32ExpressionFactory")
    .function("add", &I32ExpressionFactory::add);

  class_<Module>("Module")
    .constructor()

    .function("block", &Module::block)
    .function("if", &Module::if_)
    .function("loop", &Module::loop)
    .function("br", &Module::br)
    .function("break", &Module::br)
    .function("br_if", &Module::br)
    .property("local", &Module::local)
    .property("i32", &Module::i32)
    .function("return", &Module::return_)

    .function("addFunction", &Module::addFunction)
    .function("addFunctionExport", &Module::addFunctionExport)

    .function("emitText", &Module::emitText);

  function("parseText", parseText, allow_raw_pointer<Module>());

  function("createType", createType);

  register_type<ExpressionList>("number[]");

  register_type<TypeList>("number[]");
}