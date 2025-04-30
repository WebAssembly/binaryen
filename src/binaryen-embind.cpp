#include "binaryen-embind.h"
#include "parser/wat-parser.h"
#include "wasm-binary.h"
#include "wasm-builder.h"
#include "wasm-stack.h"
#include "wasm2js.h"
#include <emscripten.h>
#include <mutex>

using namespace emscripten;

namespace binaryen {
static wasm::PassOptions passOptions =
  wasm::PassOptions::getWithDefaultOptimizationOptions();

Module::Module() : Module(new wasm::Module()) {}

Module::Module(wasm::Module* module) : module(module) {}

const uintptr_t& Module::ptr() const {
  return reinterpret_cast<const uintptr_t&>(module);
}

wasm::Block* Module::block(OptionalString name,
                           ExpressionList children,
                           std::optional<TypeID> type) {
  return wasm::Builder(*module).makeBlock(
    name.isNull() ? nullptr : name.as<std::string>(),
    vecFromJSArray<wasm::Expression*>(children, allow_raw_pointers()),
    (std::optional<wasm::Type>)type);
}
wasm::If* Module::if_(wasm::Expression* condition,
                      wasm::Expression* ifTrue,
                      wasm::Expression* ifFalse) {
  return wasm::Builder(*module).makeIf(condition, ifTrue, ifFalse);
}
wasm::Loop* Module::loop(OptionalString label, wasm::Expression* body) {
  return wasm::Builder(*module).makeLoop(
    label.isNull() || label.isUndefined() ? nullptr : label.as<std::string>(),
    body);
}
wasm::Break* Module::br(const std::string& label,
                        wasm::Expression* condition,
                        wasm::Expression* value) {
  return wasm::Builder(*module).makeBreak(label, condition, value);
}
wasm::Switch* Module::switch_(NameList names,
                              const std::string& defaultName,
                              wasm::Expression* condition,
                              wasm::Expression* value) {
  auto strVec = vecFromJSArray<std::string>(names);
  std::vector<wasm::Name> namesVec(strVec.begin(), strVec.end());
  return wasm::Builder(*module).makeSwitch(
    namesVec, defaultName, condition, value);
}
wasm::Call*
Module::call(const std::string& name, ExpressionList operands, TypeID type) {
  return wasm::Builder(*module).makeCall(
    name,
    vecFromJSArray<wasm::Expression*>(operands, allow_raw_pointers()),
    wasm::Type(type));
}
wasm::CallIndirect* Module::call_indirect(const std::string& table,
                                          wasm::Expression* target,
                                          ExpressionList operands,
                                          TypeID params,
                                          TypeID results) {
  return wasm::Builder(*module).makeCallIndirect(
    table,
    target,
    vecFromJSArray<wasm::Expression*>(operands, allow_raw_pointers()),
    wasm::Signature(wasm::Type(params), wasm::Type(results)));
}
wasm::Call* Module::return_call(const std::string& name,
                                ExpressionList operands,
                                TypeID type) {
  return wasm::Builder(*module).makeCall(
    name,
    vecFromJSArray<wasm::Expression*>(operands, allow_raw_pointers()),
    wasm::Type(type),
    true);
}
wasm::CallIndirect* Module::return_call_indirect(const std::string& table,
                                                 wasm::Expression* target,
                                                 ExpressionList operands,
                                                 TypeID params,
                                                 TypeID results) {
  return wasm::Builder(*module).makeCallIndirect(
    table,
    target,
    vecFromJSArray<wasm::Expression*>(operands, allow_raw_pointers()),
    wasm::Signature(wasm::Type(params), wasm::Type(results)),
    true);
}
wasm::LocalGet* Module::Local::get(Index index, TypeID type) {
  return wasm::Builder(*module).makeLocalGet(index, wasm::Type(type));
}
wasm::LocalSet* Module::Local::set(Index index, wasm::Expression* value) {
  return wasm::Builder(*module).makeLocalSet(index, value);
}
wasm::LocalSet*
Module::Local::tee(Index index, wasm::Expression* value, TypeID type) {
  return wasm::Builder(*module).makeLocalTee(index, value, wasm::Type(type));
}
wasm::GlobalGet* Module::Global::get(const std::string& name, TypeID type) {
  return wasm::Builder(*module).makeGlobalGet(name, wasm::Type(type));
}
wasm::GlobalSet* Module::Global::set(const std::string& name,
                                     wasm::Expression* value) {
  return wasm::Builder(*module).makeGlobalSet(name, value);
}
wasm::Binary* Module::I32::add(wasm::Expression* left,
                               wasm::Expression* right) {
  return wasm::Builder(*module).makeBinary(
    wasm::BinaryOp::AddInt32, left, right);
}
wasm::Return* Module::return_(wasm::Expression* value) {
  return wasm::Builder(*module).makeReturn(value);
}

static std::mutex ModuleAddFunctionMutex;

wasm::Function* Module::addFunction(const std::string& name,
                                    TypeID params,
                                    TypeID results,
                                    TypeList varTypes,
                                    wasm::Expression* body) {
  auto* ret = new wasm::Function;
  ret->setExplicitName(name);
  ret->type = wasm::Signature(wasm::Type(params), wasm::Type(results));
  ret->vars = vecFromJSArray<wasm::Type>(varTypes);
  ret->body = body;

  // Lock. This can be called from multiple threads at once, and is a
  // point where they all access and modify the module.
  {
    std::lock_guard<std::mutex> lock(ModuleAddFunctionMutex);
    module->addFunction(ret);
  }

  return ret;
}
wasm::Export* Module::addFunctionExport(const std::string& internalName,
                                        const std::string& externalName) {
  auto* ret =
    new wasm::Export(externalName, wasm::ExternalKind::Function, internalName);
  module->addExport(ret);
  return ret;
}

Binary Module::emitBinary() {
  wasm::BufferWithRandomAccess buffer;
  wasm::WasmBinaryWriter writer(module, buffer, passOptions);
  writer.setNamesSection(passOptions.debugInfo);
  std::ostringstream os;
  // TODO: Source map
  writer.write();
  return val::global("Uint8Array")
    .call<Binary>("from", val(typed_memory_view(buffer.size(), buffer.data())));
}
std::string Module::emitText() {
  std::ostringstream os;
  bool colors = Colors::isEnabled();
  Colors::setEnabled(false); // do not use colors for writing
  os << *module;
  Colors::setEnabled(colors); // restore colors state
  return os.str();
}
std::string Module::emitStackIR() {
  std::ostringstream os;
  bool colors = Colors::isEnabled();
  Colors::setEnabled(false); // do not use colors for writing
  wasm::printStackIR(os, module, passOptions);
  Colors::setEnabled(colors); // restore colors state
  auto str = os.str();
  const size_t len = str.length() + 1;
  char* output = (char*)malloc(len);
  std::copy_n(str.c_str(), len, output);
  return output;
}
std::string Module::emitAsmjs() {
  wasm::Wasm2JSBuilder::Flags flags;
  wasm::Wasm2JSBuilder wasm2js(flags, passOptions);
  auto asmjs = wasm2js.processWasm(module);
  wasm::JSPrinter jser(true, true, asmjs);
  wasm::Output out("", wasm::Flags::Text); // stdout
  wasm::Wasm2JSGlue glue(*module, out, flags, "asmFunc");
  glue.emitPre();
  jser.printAst();
  std::string text(jser.buffer);
  glue.emitPost();
  return text;
}

bool Module::validate() { return wasm::WasmValidator().validate(*module); }
void Module::optimize() {
  wasm::PassRunner passRunner(module);
  passRunner.options = passOptions;
  passRunner.addDefaultOptimizationPasses();
  passRunner.run();
}
void Module::optimizeFunction(wasm::Function* func) {
  wasm::PassRunner passRunner(module);
  passRunner.options = passOptions;
  passRunner.addDefaultFunctionOptimizationPasses();
  passRunner.runOnFunction(func);
}

void Module::dispose() { delete this; }

Module* parseText(const std::string& text) {
  auto* wasm = new wasm::Module;
  auto parsed = wasm::WATParser::parseModule(*wasm, text);
  if (auto* err = parsed.getErr()) {
    wasm::Fatal() << err->msg << "\n";
  }
  return new Module(wasm);
}

TypeID createType(TypeList types) {
  auto typesVec = vecFromJSArray<wasm::Type>(types);
  return wasm::Type(typesVec).getID();
}
} // namespace binaryen

val binaryen::getExpressionInfo(wasm::Expression* expr) {
  using namespace wasm;

  val info = val::object();
  info.set("id", val(expr->_id));
  info.set("type", (binaryen::TypeID)expr->type.getID());

#define DELEGATE_ID expr->_id

#define DELEGATE_START(id) [[maybe_unused]] auto* cast = expr->cast<wasm::id>();

#define DELEGATE_FIELD_CHILD(id, field) info.set(#field, cast->field);
#define DELEGATE_FIELD_OPTIONAL_CHILD(id, field) info.set(#field, cast->field);
#define DELEGATE_FIELD_CHILD_VECTOR(id, field)
#define DELEGATE_FIELD_INT(id, field) info.set(#field, cast->field);
#define DELEGATE_FIELD_INT_ARRAY(id, field)
#define DELEGATE_FIELD_INT_VECTOR(id, field)
#define DELEGATE_FIELD_BOOL(id, field) info.set(#field, cast->field);
#define DELEGATE_FIELD_BOOL_VECTOR(id, field)
#define DELEGATE_FIELD_ENUM(id, field, type)
#define DELEGATE_FIELD_LITERAL(id, field)
#define DELEGATE_FIELD_NAME(id, field) info.set(#field, cast->field.toString());
#define DELEGATE_FIELD_NAME_VECTOR(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, field)                               \
  info.set(#field,                                                             \
           cast->field.size() ? val(cast->field.toString()) : val::null());
#define DELEGATE_FIELD_SCOPE_NAME_USE(id, field) DELEGATE_FIELD_NAME(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_USE_VECTOR(id, field)
#define DELEGATE_FIELD_TYPE(id, field)
#define DELEGATE_FIELD_TYPE_VECTOR(id, field)
#define DELEGATE_FIELD_HEAPTYPE(id, field)
#define DELEGATE_FIELD_ADDRESS(id, field)

#include "wasm-delegations-fields.def"

  return info;
}

namespace {
static std::string uncapitalize(std::string str, int i) {
  str[i] = std::tolower(str[i]);
  return str;
}

static std::string capitalize(std::string str, int i) {
  str[i] = std::toupper(str[i]);
  return str;
}

static std::string normalize(std::string str) {
  if (str.back() == '_')
    str.pop_back();
  if (str.substr(0, 2) == "is")
    str = uncapitalize(str, 2).substr(2);
  return str;
}

#define GETTER(field) capitalize("get" field, 3)
#define SETTER(field) capitalize("set" field, 3)

#define FIELD_GS(target, field, name, getterName, setterName, id, type, ...)   \
  auto getter = [](const wasm::id& expr) { return expr.field; };               \
  auto setter = [](wasm::id& expr, type value) { expr.field = value; };        \
  target.class_function(getterName.c_str(), +getter, ##__VA_ARGS__)            \
    .class_function(setterName.c_str(), +setter, ##__VA_ARGS__)                \
    .function(getterName.c_str(), +getter, ##__VA_ARGS__)                      \
    .function(setterName.c_str(), +setter, ##__VA_ARGS__)                      \
    .property(name, &wasm::id::field, ##__VA_ARGS__);

#define FIELD_BOOL(target, field, name, id, ...)                               \
  {                                                                            \
    std::string propName = normalize(#name);                                   \
    std::string getterName = capitalize("is" + propName, 2);                   \
    std::string setterName = capitalize("set" + propName, 3);                  \
    FIELD_GS(target,                                                           \
             field,                                                            \
             propName.c_str(),                                                 \
             getterName,                                                       \
             setterName,                                                       \
             id,                                                               \
             bool,                                                             \
             ##__VA_ARGS__)                                                    \
  }

#define FIELD(target, field, name, id, type, ...)                              \
  {                                                                            \
    std::string getterName = GETTER(#name);                                    \
    std::string setterName = SETTER(#name);                                    \
    FIELD_GS(                                                                  \
      target, field, #name, getterName, setterName, id, type, ##__VA_ARGS__)   \
  }

#define FIELD_DYN(target, field, name, getter, setter, ...)                    \
  {                                                                            \
    std::string getterName = GETTER(#name);                                    \
    std::string setterName = SETTER(#name);                                    \
    target.class_function(getterName.c_str(), +getter, ##__VA_ARGS__)          \
      .class_function(setterName.c_str(), +setter, ##__VA_ARGS__)              \
      .function(getterName.c_str(), +getter, ##__VA_ARGS__)                    \
      .function(setterName.c_str(), +setter, ##__VA_ARGS__)                    \
      .property(#name, +getter, +setter, ##__VA_ARGS__);                       \
  }
} // namespace

EMSCRIPTEN_BINDINGS(Binaryen) {
  register_type<binaryen::Binary>("Uint8Array");

  register_type<binaryen::OptionalString>("string | null");

  register_optional<binaryen::TypeID>();

  constant<binaryen::TypeID>("none", wasm::Type(wasm::Type::none).getID());
  constant<binaryen::TypeID>("i32", wasm::Type(wasm::Type::i32).getID());
  constant<binaryen::TypeID>("i64", wasm::Type(wasm::Type::i64).getID());
  constant<binaryen::TypeID>("f32", wasm::Type(wasm::Type::f32).getID());
  constant<binaryen::TypeID>("f64", wasm::Type(wasm::Type::f64).getID());
  constant<binaryen::TypeID>("v128", wasm::Type(wasm::Type::v128).getID());
  constant<binaryen::TypeID>(
    "funcref", wasm::Type(wasm::HeapType::func, wasm::Nullable).getID());
  constant<binaryen::TypeID>(
    "externref", wasm::Type(wasm::HeapType::ext, wasm::Nullable).getID());
  constant<binaryen::TypeID>(
    "anyref", wasm::Type(wasm::HeapType::any, wasm::Nullable).getID());
  constant<binaryen::TypeID>(
    "eqref", wasm::Type(wasm::HeapType::eq, wasm::Nullable).getID());
  constant<binaryen::TypeID>(
    "i31ref", wasm::Type(wasm::HeapType::i31, wasm::Nullable).getID());
  constant<binaryen::TypeID>(
    "structref", wasm::Type(wasm::HeapType::struct_, wasm::Nullable).getID());
  constant<binaryen::TypeID>(
    "stringref", wasm::Type(wasm::HeapType::string, wasm::Nullable).getID());
  constant<binaryen::TypeID>(
    "nullref", wasm::Type(wasm::HeapType::none, wasm::Nullable).getID());
  constant<binaryen::TypeID>(
    "nullexternref", wasm::Type(wasm::HeapType::noext, wasm::Nullable).getID());
  constant<binaryen::TypeID>(
    "nullfuncref", wasm::Type(wasm::HeapType::nofunc, wasm::Nullable).getID());
  constant<binaryen::TypeID>("unreachable",
                             wasm::Type(wasm::Type::unreachable).getID());
  constant("auto", val::undefined());

  register_type<binaryen::TypeList>("number[]");

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

  class_<wasm::Function>("Function");

  class_<wasm::Export>("Export");

  class_<binaryen::Module::Local>("Module_Local")
    .function("get",
              &binaryen::Module::Local::get,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function("set",
              &binaryen::Module::Local::set,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function("get",
              &binaryen::Module::Local::tee,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>());

  class_<binaryen::Module::Global>("Module_Global")
    .function("get",
              &binaryen::Module::Global::get,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function("set",
              &binaryen::Module::Global::set,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>());

  class_<binaryen::Module::I32>("Module_I32")
    .function("add",
              &binaryen::Module::I32::add,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>());

  class_<binaryen::Module>("Module")
    .constructor()
    .property("ptr", &binaryen::Module::ptr)

    .function("block",
              &binaryen::Module::block,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function("if",
              &binaryen::Module::if_,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function("loop",
              &binaryen::Module::loop,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function("br",
              &binaryen::Module::br,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function("break",
              &binaryen::Module::br,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function("br_if",
              &binaryen::Module::br,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function("switch",
              &binaryen::Module::switch_,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function(
      "call", &binaryen::Module::call, allow_raw_pointers(), nonnull<ret_val>())
    .function("call_indirect",
              &binaryen::Module::call_indirect,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function("return_call",
              &binaryen::Module::return_call,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function("return_call_indirect",
              &binaryen::Module::return_call_indirect,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .property(
      "local", &binaryen::Module::local, return_value_policy::reference())
    .property(
      "global", &binaryen::Module::global, return_value_policy::reference())
    .property("i32", &binaryen::Module::i32, return_value_policy::reference())
    .function("return",
              &binaryen::Module::return_,
              allow_raw_pointers(),
              nonnull<ret_val>())

    .function("addFunction",
              &binaryen::Module::addFunction,
              allow_raw_pointers(),
              nonnull<ret_val>())
    .function("addFunctionExport",
              &binaryen::Module::addFunctionExport,
              allow_raw_pointers(),
              nonnull<ret_val>())

    .function("emitBinary", &binaryen::Module::emitBinary)
    .function("emitText", &binaryen::Module::emitText)
    .function("emitStackIR", &binaryen::Module::emitStackIR)
    .function("emitAsmjs", &binaryen::Module::emitAsmjs)

    .function("validate", &binaryen::Module::validate)
    .function("optimize", &binaryen::Module::optimize)
    .function("optimizeFunction",
              &binaryen::Module::optimizeFunction,
              allow_raw_pointers())

    .function(
      "dispose",
      &binaryen::Module::dispose) // for compatibility, should be removed later
                                  // in favor of Module.delete()
    ;

  function(
    "parseText", binaryen::parseText, allow_raw_pointers(), nonnull<ret_val>());

  function("createType", binaryen::createType);

  function(
    "getExpressionInfo", binaryen::getExpressionInfo, allow_raw_pointers());

  auto ExpressionWrapper = class_<wasm::Expression>("Expression");
  {
    auto getter = [](const wasm::Expression& expr) { return expr._id; };
    ExpressionWrapper.class_function("getId", +getter)
      .function("getId", +getter)
      .property("id", &wasm::Expression::_id);
  };
  {
    auto getter = [](const wasm::Expression& expr) {
      return binaryen::TypeID(expr.type.getID());
    };
    auto setter = [](wasm::Expression& expr, binaryen::TypeID value) {
      expr.type = wasm::Type(value);
    };
    ExpressionWrapper.class_function("getType", +getter)
      .class_function("setType", +setter)
      .function("getType", +getter)
      .function("setType", +setter)
      .property("type", +getter, +setter);
  };

  register_type<binaryen::ExpressionList>("Expression[]");

  register_type<binaryen::NameList>("string[]");

#define DELEGATE_FIELD_MAIN_START

#define DELEGATE_FIELD_CASE_START(id)                                          \
  [[maybe_unused]] auto id##Wrapper =                                          \
    class_<wasm::id, base<wasm::Expression>>(#id);                             \
  {                                                                            \
    auto getter = [](const wasm::Expression& expr) { return expr._id; };       \
    id##Wrapper.class_function("getId", +getter);                              \
  };                                                                           \
  {                                                                            \
    auto getter = [](const wasm::Expression& expr) {                           \
      return binaryen::TypeID(expr.type.getID());                              \
    };                                                                         \
    auto setter = [](wasm::Expression& expr, binaryen::TypeID value) {         \
      expr.type = wasm::Type(value);                                           \
    };                                                                         \
    id##Wrapper.class_function("getType", +getter)                             \
      .class_function("setType", +setter);                                     \
  };

#define DELEGATE_FIELD_CASE_END(id)

#define DELEGATE_FIELD_MAIN_END

#define DELEGATE_FIELD_CHILD(id, field)                                        \
  FIELD(id##Wrapper,                                                           \
        field,                                                                 \
        field,                                                                 \
        id,                                                                    \
        wasm::Expression*,                                                     \
        allow_raw_pointers(),                                                  \
        nonnull<ret_val>());
#define DELEGATE_FIELD_OPTIONAL_CHILD(id, field)                               \
  FIELD(id##Wrapper, field, field, id, wasm::Expression*, allow_raw_pointers());
#define DELEGATE_FIELD_CHILD_VECTOR(id, field)                                 \
  FIELD_DYN(                                                                   \
    id##Wrapper,                                                               \
    field,                                                                     \
    field,                                                                     \
    [](const wasm::id& expr) {                                                 \
      return binaryen::ExpressionList(                                         \
        val::array(std::vector(expr.field.begin(), expr.field.end())));        \
    },                                                                         \
    [](wasm::id& expr, binaryen::ExpressionList value) {                       \
      expr.field.set(                                                          \
        vecFromJSArray<wasm::Expression*>(value, allow_raw_pointers()));       \
    });
#define DELEGATE_FIELD_INT(id, field)                                          \
  FIELD(id##Wrapper, field, field, id, uint32_t);
#define DELEGATE_FIELD_INT_ARRAY(id, field)
#define DELEGATE_FIELD_INT_VECTOR(id, field)
#define DELEGATE_FIELD_BOOL(id, field)                                         \
  FIELD_BOOL(id##Wrapper, field, field, id);
#define DELEGATE_FIELD_BOOL_VECTOR(id, field)
#define DELEGATE_FIELD_ENUM(id, field, type)
#define DELEGATE_FIELD_LITERAL(id, field)
#define DELEGATE_FIELD_NAME(id, field)                                         \
  FIELD_DYN(                                                                   \
    id##Wrapper,                                                               \
    field,                                                                     \
    field,                                                                     \
    [](const wasm::id& expr) { return expr.field.toString(); },                \
    [](wasm::id& expr, const std::string& value) { expr.field = value; });
#define DELEGATE_FIELD_NAME_VECTOR(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, field)                               \
  FIELD_DYN(                                                                   \
    id##Wrapper,                                                               \
    field,                                                                     \
    field,                                                                     \
    [](const wasm::id& expr) {                                                 \
      return binaryen::OptionalString(                                         \
        expr.field.size() ? val(expr.field.toString()) : val::null());         \
    },                                                                         \
    [](wasm::id& expr, binaryen::OptionalString value) {                       \
      expr.field = value.isNull() ? nullptr : value.as<std::string>();         \
    });
#define DELEGATE_FIELD_SCOPE_NAME_USE(id, field) DELEGATE_FIELD_NAME(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_USE_VECTOR(id, field)                        \
  DELEGATE_FIELD_NAME_VECTOR(id, field)
#define DELEGATE_FIELD_TYPE(id, field)
#define DELEGATE_FIELD_TYPE_VECTOR(id, field)
#define DELEGATE_FIELD_HEAPTYPE(id, field)
#define DELEGATE_FIELD_ADDRESS(id, field)

#include "wasm-delegations-fields.def"
}