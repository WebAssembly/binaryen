#include "binaryen-embind.h"
#include "parser/wat-parser.h"
#include "wasm-builder.h"

using namespace emscripten;

namespace binaryen {
Module::Module() : Module(new wasm::Module()) {}

Module::Module(wasm::Module* module) : module(module) {}

const uintptr_t& Module::ptr() const {
  return reinterpret_cast<const uintptr_t&>(module);
}

wasm::Expression* Module::block(const std::string& name,
                                ExpressionList children,
                                std::optional<wasm::Type> type) {
  return wasm::Builder(*module).makeBlock(
    name,
    vecFromJSArray<wasm::Expression*>(children,
                                      allow_raw_pointer<wasm::Expression>()),
    type);
}
wasm::Expression* Module::if_(wasm::Expression* condition,
                              wasm::Expression* ifTrue,
                              wasm::Expression* ifFalse) {
  return wasm::Builder(*module).makeIf(condition, ifTrue, ifFalse);
}
wasm::Expression* Module::loop(const std::string& label,
                               wasm::Expression* body) {
  return wasm::Builder(*module).makeLoop(label, body);
}
wasm::Expression* Module::br(const std::string& label,
                             wasm::Expression* condition,
                             wasm::Expression* value) {
  return wasm::Builder(*module).makeBreak(label, condition, value);
}
wasm::Expression* Module::switch_(NameList names,
                                  const std::string& defaultName,
                                  wasm::Expression* condition,
                                  wasm::Expression* value) {
  auto strVec = vecFromJSArray<std::string>(names);
  std::vector<wasm::Name> namesVec(strVec.begin(), strVec.end());
  return wasm::Builder(*module).makeSwitch(
    namesVec, defaultName, condition, value);
}
wasm::Expression* Module::Local::get(Index index, wasm::Type type) {
  return wasm::Builder(*module).makeLocalGet(index, type);
}

wasm::Expression* Module::I32::add(wasm::Expression* left,
                                   wasm::Expression* right) {
  return wasm::Builder(*module).makeBinary(
    wasm::BinaryOp::AddInt32, left, right);
}
wasm::Expression* Module::return_(wasm::Expression* value) {
  return wasm::Builder(*module).makeReturn(value);
}

/*uintptr_t Module::addFunction(const std::string& name,
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
}*/

std::string Module::emitText() {
  std::ostringstream os;
  bool colors = Colors::isEnabled();
  Colors::setEnabled(false); // do not use colors for writing
  os << *module;
  Colors::setEnabled(colors); // restore colors state
  return os.str();
}

Module* parseText(const std::string& text) {
  auto* wasm = new wasm::Module;
  auto parsed = wasm::WATParser::parseModule(*wasm, text);
  if (auto* err = parsed.getErr()) {
    wasm::Fatal() << err->msg << "\n";
  }
  return new Module(wasm);
}

wasm::Type createType(TypeList types) {
  auto typesVec = vecFromJSArray<wasm::Type>(types);
  return wasm::Type(typesVec);
}
} // namespace binaryen

namespace {
static std::string capitalize(std::string str) {
  assert(!str.empty());
  str[0] = std::toupper(str[0]);
  return str;
}
} // namespace

EMSCRIPTEN_BINDINGS(Binaryen) {
  class_<wasm::Type>("Type");

  register_optional<wasm::Type>();

  constant("none", wasm::Type(wasm::Type::none));
  constant("i32", wasm::Type(wasm::Type::i32));
  constant("i64", wasm::Type(wasm::Type::i64));
  constant("f32", wasm::Type(wasm::Type::f32));
  constant("f64", wasm::Type(wasm::Type::f64));
  constant("v128", wasm::Type(wasm::Type::v128));
  constant("funcref", wasm::Type(wasm::HeapType::func, wasm::Nullable));
  constant("externref", wasm::Type(wasm::HeapType::ext, wasm::Nullable));
  constant("anyref", wasm::Type(wasm::HeapType::any, wasm::Nullable));
  constant("eqref", wasm::Type(wasm::HeapType::eq, wasm::Nullable));
  constant("i31ref", wasm::Type(wasm::HeapType::i31, wasm::Nullable));
  constant("structref", wasm::Type(wasm::HeapType::struct_, wasm::Nullable));
  constant("stringref", wasm::Type(wasm::HeapType::string, wasm::Nullable));
  constant("nullref", wasm::Type(wasm::HeapType::none, wasm::Nullable));
  constant("nullexternref", wasm::Type(wasm::HeapType::noext, wasm::Nullable));
  constant("nullfuncref", wasm::Type(wasm::HeapType::nofunc, wasm::Nullable));
  constant("unreachable", wasm::Type(wasm::Type::unreachable));
  constant("auto", val::undefined());

  register_type<binaryen::TypeList>("Type[]");

  constant<uintptr_t>("notPacked", wasm::Field::PackedType::not_packed);
  constant<uintptr_t>("i8", wasm::Field::PackedType::i8);
  constant<uintptr_t>("i16", wasm::Field::PackedType::i16);

  auto expressionIds = enum_<wasm::Expression::Id>("ExpressionIds");
  expressionIds.value("Invalid", wasm::Expression::Id::InvalidId);
#define DELEGATE(CLASS_TO_VISIT)                                               \
  expressionIds.value(#CLASS_TO_VISIT, wasm::Expression::Id::CLASS_TO_VISIT##Id)
#include "wasm-delegations.def"

  constant("InvalidId", wasm::Expression::Id::InvalidId);
#define DELEGATE(CLASS_TO_VISIT)                                               \
  constant(#CLASS_TO_VISIT "Id", wasm::Expression::Id::CLASS_TO_VISIT##Id);
#include "wasm-delegations.def"

  class_<binaryen::Module::Local>("Module_Local")
    .function("get",
              &binaryen::Module::Local::get,
              allow_raw_pointer<wasm::Expression>());

  class_<binaryen::Module::I32>("Module_I32")
    .function("add",
              &binaryen::Module::I32::add,
              allow_raw_pointer<wasm::Expression>());

  class_<binaryen::Module>("Module")
    .constructor()
    .property("ptr", &binaryen::Module::ptr)

    .function(
      "block", &binaryen::Module::block, allow_raw_pointer<wasm::Expression>())
    .function(
      "if", &binaryen::Module::if_, allow_raw_pointer<wasm::Expression>())
    .function(
      "loop", &binaryen::Module::loop, allow_raw_pointer<wasm::Expression>())
    .function(
      "br", &binaryen::Module::br, allow_raw_pointer<wasm::Expression>())
    .function(
      "break", &binaryen::Module::br, allow_raw_pointer<wasm::Expression>())
    .function(
      "br_if", &binaryen::Module::br, allow_raw_pointer<wasm::Expression>())
    .property(
      "local", &binaryen::Module::local, return_value_policy::reference())
    .property("i32", &binaryen::Module::i32, return_value_policy::reference())
    .function("return",
              &binaryen::Module::return_,
              allow_raw_pointer<wasm::Expression>())

    /*.function("addFunction", &binaryen::Module::addFunction)
    .function("addFunctionExport", &binaryen::Module::addFunctionExport)*/

    .function("emitText", &binaryen::Module::emitText);

  function(
    "parseText", binaryen::parseText, allow_raw_pointer<binaryen::Module>());

  function("createType", binaryen::createType);

  class_<wasm::Expression>("Expression")
    .property("id", &wasm::Expression::_id)
    .property("type", &wasm::Expression::type);

  register_type<binaryen::ExpressionList>("Expression[]");

  register_type<binaryen::NameList>("string[]");

#define DELEGATE_FIELD_MAIN_START

#define DELEGATE_FIELD_CASE_START(id)                                          \
  class_<wasm::id, base<wasm::Expression>>(#id)

#define DELEGATE_FIELD_CASE_END(id) ;

#define DELEGATE_FIELD_MAIN_END

#define DELEGATE_FIELD_CHILD(id, field)                                        \
  .function(("get" + capitalize(#field)).c_str(),                              \
            +[](const wasm::id& expr) { return expr.field; },                  \
            allow_raw_pointer<wasm::Expression>(),                             \
            nonnull<ret_val>())                                                \
    .function(                                                                 \
      ("set" + capitalize(#field)).c_str(),                                    \
      +[](wasm::id& expr, wasm::Expression* value) { expr.field = value; },    \
      allow_raw_pointer<wasm::Expression>() /* nonnull<arg>() */)              \
    .property(                                                                 \
      #field,                                                                  \
      &wasm::id::field,                                                        \
      allow_raw_pointer<                                                       \
        wasm::Expression>() /* nonnull<val>() */) // Embind doesn't support
                                                  // non-null properties yet
#define DELEGATE_FIELD_OPTIONAL_CHILD(id, field)                               \
  .function(("get" + capitalize(#field)).c_str(),                              \
            +[](const wasm::id& expr) { return expr.field; },                  \
            allow_raw_pointer<wasm::Expression>())                             \
    .function(                                                                 \
      ("set" + capitalize(#field)).c_str(),                                    \
      +[](wasm::id& expr, wasm::Expression* value) { expr.field = value; },    \
      allow_raw_pointer<wasm::Expression>())                                   \
    .property(#field, &wasm::id::field, allow_raw_pointer<wasm::Expression>())
#define DELEGATE_FIELD_CHILD_VECTOR(id, field)                                 \
  //.property(#field, &wasm::id::field,
  // allow_raw_pointer<wasm::Expression>())
#define DELEGATE_FIELD_INT(id, field)
#define DELEGATE_FIELD_INT_ARRAY(id, field)
#define DELEGATE_FIELD_INT_VECTOR(id, field)
#define DELEGATE_FIELD_LITERAL(id, field)
#define DELEGATE_FIELD_NAME(id, field)                                         \
  .property(                                                                   \
    #field,                                                                    \
    +[](const wasm::id& expr) { return expr.field.toString(); },               \
    +[](wasm::id& expr, std::string value) { expr.field = value; })
#define DELEGATE_FIELD_NAME_VECTOR(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, field) DELEGATE_FIELD_NAME(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_USE(id, field) DELEGATE_FIELD_NAME(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_USE_VECTOR(id, field)                        \
  DELEGATE_FIELD_NAME_VECTOR(id, field)
#define DELEGATE_FIELD_TYPE(id, field)
#define DELEGATE_FIELD_TYPE_VECTOR(id, field)
#define DELEGATE_FIELD_HEAPTYPE(id, field)
#define DELEGATE_FIELD_ADDRESS(id, field)

#include "wasm-delegations-fields.def"
}