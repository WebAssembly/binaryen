#include "binaryen-embind.h"
#include "binaryen-c.h"

using namespace emscripten;

namespace binaryen {

namespace {
ExpressionFactory::ExpressionFactory(wasm::Module* module) : module(module) {}

uintptr_t LocalExpressionFactory::get(Index index, Type type) {
  return reinterpret_cast<uintptr_t>(
    BinaryenLocalGet(reinterpret_cast<BinaryenModuleRef>(module), index, type));
}

uintptr_t I32ExpressionFactory::add(uintptr_t left, uintptr_t right) {
  return reinterpret_cast<uintptr_t>(
    BinaryenBinary(reinterpret_cast<BinaryenModuleRef>(module),
                   BinaryenAddInt32(),
                   reinterpret_cast<BinaryenExpressionRef>(left),
                   reinterpret_cast<BinaryenExpressionRef>(right)));
}
} // namespace

Module::Module() : Module(BinaryenModuleCreate()) {}

Module::Module(wasm::Module* module) : module(module) {}

const uintptr_t& Module::ptr() const {
  return reinterpret_cast<const uintptr_t&>(module);
}

uintptr_t Module::block(const std::string& name,
                        ExpressionList children,
                        uintptr_t type) {
  std::vector<uintptr_t> childrenVec =
    convertJSArrayToNumberVector<uintptr_t>(children);
  return reinterpret_cast<uintptr_t>(BinaryenBlock(
    module,
    name.c_str(),
    reinterpret_cast<BinaryenExpressionRef*>(childrenVec.begin().base()),
    childrenVec.size(),
    type));
}
uintptr_t
Module::if_(uintptr_t condition, uintptr_t ifTrue, uintptr_t ifFalse) {
  return reinterpret_cast<uintptr_t>(
    BinaryenIf(module,
               reinterpret_cast<BinaryenExpressionRef>(condition),
               reinterpret_cast<BinaryenExpressionRef>(ifTrue),
               reinterpret_cast<BinaryenExpressionRef>(ifFalse)));
}
uintptr_t Module::loop(const std::string& label, uintptr_t body) {
  return reinterpret_cast<uintptr_t>(BinaryenLoop(
    module, label.c_str(), reinterpret_cast<BinaryenExpressionRef>(body)));
}
uintptr_t
Module::br(const std::string& label, uintptr_t condition, uintptr_t value) {
  return reinterpret_cast<uintptr_t>(
    BinaryenBreak(module,
                  label.c_str(),
                  reinterpret_cast<BinaryenExpressionRef>(condition),
                  reinterpret_cast<BinaryenExpressionRef>(value)));
}
uintptr_t Module::return_(uintptr_t value) {
  return reinterpret_cast<uintptr_t>(
    BinaryenReturn(module, reinterpret_cast<BinaryenExpressionRef>(value)));
}

uintptr_t Module::addFunction(const std::string& name,
                              BinaryenType params,
                              BinaryenType results,
                              TypeList varTypes,
                              uintptr_t body) {
  std::vector<uintptr_t> varTypesVec =
    convertJSArrayToNumberVector<uintptr_t>(varTypes);
  return reinterpret_cast<uintptr_t>(
    BinaryenAddFunction(module,
                        name.c_str(),
                        params,
                        results,
                        varTypesVec.begin().base(),
                        varTypesVec.size(),
                        reinterpret_cast<BinaryenExpressionRef>(body)));
}
uintptr_t Module::addFunctionExport(const std::string& internalName,
                                    const std::string& externalName) {
  return reinterpret_cast<uintptr_t>(BinaryenAddFunctionExport(
    module, internalName.c_str(), externalName.c_str()));
}

std::string Module::emitText() {
  char* text = BinaryenModuleAllocateAndWriteText(module);
  std::string str = text;
  delete text;
  return str;
}

Module* parseText(const std::string& text) {
  return new Module(BinaryenModuleParse(text.c_str()));
}

BinaryenType createType(TypeList types) {
  std::vector<uintptr_t> typeIdsVec =
    convertJSArrayToNumberVector<uintptr_t>(types);
  std::vector<wasm::Type> typesVec(typeIdsVec.begin(), typeIdsVec.end());
  return wasm::Type(typesVec).getID();
}
} // namespace binaryen

EMSCRIPTEN_BINDINGS(Binaryen) {
  constant<uintptr_t>("none", wasm::Type::none);
  constant<uintptr_t>("i32", wasm::Type::i32);
  constant<uintptr_t>("i64", wasm::Type::i64);
  constant<uintptr_t>("f32", wasm::Type::f32);
  constant<uintptr_t>("f64", wasm::Type::f64);
  constant<uintptr_t>("v128", wasm::Type::v128);
  constant<uintptr_t>("funcref",
                      wasm::Type(wasm::HeapType::func, wasm::Nullable).getID());
  constant<uintptr_t>("externref",
                      wasm::Type(wasm::HeapType::ext, wasm::Nullable).getID());
  constant<uintptr_t>("anyref",
                      wasm::Type(wasm::HeapType::any, wasm::Nullable).getID());
  constant<uintptr_t>("eqref",
                      wasm::Type(wasm::HeapType::eq, wasm::Nullable).getID());
  constant<uintptr_t>("i31ref",
                      wasm::Type(wasm::HeapType::i31, wasm::Nullable).getID());
  constant<uintptr_t>(
    "structref", wasm::Type(wasm::HeapType::struct_, wasm::Nullable).getID());
  constant<uintptr_t>(
    "stringref", wasm::Type(wasm::HeapType::string, wasm::Nullable).getID());
  constant<uintptr_t>("nullref",
                      wasm::Type(wasm::HeapType::none, wasm::Nullable).getID());
  constant<uintptr_t>(
    "nullexternref", wasm::Type(wasm::HeapType::noext, wasm::Nullable).getID());
  constant<uintptr_t>(
    "nullfuncref", wasm::Type(wasm::HeapType::nofunc, wasm::Nullable).getID());
  constant<uintptr_t>("unreachable", wasm::Type::unreachable);
  constant<uintptr_t>("auto", uintptr_t(-1));

  constant<uintptr_t>("notPacked", wasm::Field::PackedType::not_packed);
  constant<uintptr_t>("i8", wasm::Field::PackedType::i8);
  constant<uintptr_t>("i16", wasm::Field::PackedType::i16);

  auto expressionIds = enum_<wasm::Expression::Id>("ExpressionIds");
  expressionIds.value("Invalid", wasm::Expression::Id::InvalidId);
#define DELEGATE(CLASS_TO_VISIT)                                               \
  expressionIds.value(#CLASS_TO_VISIT, wasm::Expression::Id::CLASS_TO_VISIT##Id)
#include "wasm-delegations.def"

  constant<uintptr_t>("InvalidId", wasm::Expression::Id::InvalidId);
#define DELEGATE(CLASS_TO_VISIT)                                               \
  constant<uintptr_t>(#CLASS_TO_VISIT "Id",                                    \
                      wasm::Expression::Id::CLASS_TO_VISIT##Id);
#include "wasm-delegations.def"

  class_<binaryen::LocalExpressionFactory>("LocalExpressionFactory")
    .function("get", &binaryen::LocalExpressionFactory::get);

  class_<binaryen::I32ExpressionFactory>("I32ExpressionFactory")
    .function("add", &binaryen::I32ExpressionFactory::add);

  class_<binaryen::Module>("Module")
    .constructor()
    .property("ptr", &binaryen::Module::ptr)

    .function("block", &binaryen::Module::block)
    .function("if", &binaryen::Module::if_)
    .function("loop", &binaryen::Module::loop)
    .function("br", &binaryen::Module::br)
    .function("break", &binaryen::Module::br)
    .function("br_if", &binaryen::Module::br)
    .property("local", &binaryen::Module::local)
    .property("i32", &binaryen::Module::i32)
    .function("return", &binaryen::Module::return_)

    .function("addFunction", &binaryen::Module::addFunction)
    .function("addFunctionExport", &binaryen::Module::addFunctionExport)

    .function("emitText", &binaryen::Module::emitText);

  function(
    "parseText", binaryen::parseText, allow_raw_pointer<binaryen::Module>());

  function("createType", binaryen::createType);

#define DELEGATE_FIELD_MAIN_START

#define DELEGATE_FIELD_CASE_START(id) class_<binaryen::id>(#id)

#define DELEGATE_FIELD_CASE_END(id) ;

#define DELEGATE_FIELD_MAIN_END

#define DELEGATE_FIELD_CHILD(id, field) .property(#field, &binaryen::id::field)

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

  register_type<binaryen::ExpressionList>("number[]");

  register_type<binaryen::TypeList>("number[]");
}