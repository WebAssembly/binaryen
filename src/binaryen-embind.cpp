#include "binaryen-embind.h"
#include "parser/wat-parser.h"
#include "wasm-binary.h"
#include "wasm-builder.h"
#include "wasm-stack.h"
#include "wasm2js.h"
#include <emscripten.h>
#include <mutex>

using namespace emscripten;
using namespace std::string_literals;

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
                           std::optional<TypeID> type) const {
  return wasm::Builder(*module).makeBlock(
    name.isNull() ? nullptr : name.as<std::string>(),
    vecFromJSArray<wasm::Expression*>(children, allow_raw_pointers()),
    (std::optional<wasm::Type>)type);
}
wasm::If* Module::if_(wasm::Expression* condition,
                      wasm::Expression* ifTrue,
                      wasm::Expression* ifFalse) const {
  return wasm::Builder(*module).makeIf(condition, ifTrue, ifFalse);
}
wasm::Loop* Module::loop(OptionalString label, wasm::Expression* body) const {
  return wasm::Builder(*module).makeLoop(
    label.isNull() || label.isUndefined() ? nullptr : label.as<std::string>(),
    body);
}
wasm::Break* Module::br(const std::string& label,
                        wasm::Expression* condition,
                        wasm::Expression* value) const {
  return wasm::Builder(*module).makeBreak(label, condition, value);
}
wasm::Switch* Module::switch_(NameList names,
                              const std::string& defaultName,
                              wasm::Expression* condition,
                              wasm::Expression* value) const {
  auto strVec = vecFromJSArray<std::string>(names);
  std::vector<wasm::Name> namesVec(strVec.begin(), strVec.end());
  return wasm::Builder(*module).makeSwitch(
    namesVec, defaultName, condition, value);
}
wasm::Call* Module::call(const std::string& name,
                         ExpressionList operands,
                         TypeID type) const {
  return wasm::Builder(*module).makeCall(
    name,
    vecFromJSArray<wasm::Expression*>(operands, allow_raw_pointers()),
    wasm::Type(type));
}
wasm::CallIndirect* Module::call_indirect(const std::string& table,
                                          wasm::Expression* target,
                                          ExpressionList operands,
                                          TypeID params,
                                          TypeID results) const {
  return wasm::Builder(*module).makeCallIndirect(
    table,
    target,
    vecFromJSArray<wasm::Expression*>(operands, allow_raw_pointers()),
    wasm::Signature(wasm::Type(params), wasm::Type(results)));
}
wasm::Call* Module::return_call(const std::string& name,
                                ExpressionList operands,
                                TypeID type) const {
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
                                                 TypeID results) const {
  return wasm::Builder(*module).makeCallIndirect(
    table,
    target,
    vecFromJSArray<wasm::Expression*>(operands, allow_raw_pointers()),
    wasm::Signature(wasm::Type(params), wasm::Type(results)),
    true);
}
wasm::LocalGet* Module::Local::get(uint32_t index, TypeID type) const {
  return wasm::Builder(*module).makeLocalGet(index, wasm::Type(type));
}
wasm::LocalSet* Module::Local::set(uint32_t index,
                                   wasm::Expression* value) const {
  return wasm::Builder(*module).makeLocalSet(index, value);
}
wasm::LocalSet*
Module::Local::tee(uint32_t index, wasm::Expression* value, TypeID type) const {
  return wasm::Builder(*module).makeLocalTee(index, value, wasm::Type(type));
}
wasm::GlobalGet* Module::Global::get(const std::string& name,
                                     TypeID type) const {
  return wasm::Builder(*module).makeGlobalGet(name, wasm::Type(type));
}
wasm::GlobalSet* Module::Global::set(const std::string& name,
                                     wasm::Expression* value) const {
  return wasm::Builder(*module).makeGlobalSet(name, value);
}
wasm::TableGet* Module::Table::get(const std::string& name,
                                   wasm::Expression* index,
                                   TypeID type) const {
  return wasm::Builder(*module).makeTableGet(name, index, wasm::Type(type));
}
wasm::TableSet* Module::Table::set(const std::string& name,
                                   wasm::Expression* index,
                                   wasm::Expression* value) const {
  return wasm::Builder(*module).makeTableSet(name, index, value);
}
wasm::TableSize* Module::Table::size(const std::string& name) const {
  return wasm::Builder(*module).makeTableSize(name);
}
wasm::TableGrow* Module::Table::grow(const std::string& name,
                                     wasm::Expression* value,
                                     wasm::Expression* delta) const {
  return wasm::Builder(*module).makeTableGrow(name, value, delta);
}
wasm::MemorySize* Module::Memory::size(const std::string& name,
                                       bool memory64) const {
  return wasm::Builder(*module).makeMemorySize(
    name,
    memory64 ? wasm::Builder::MemoryInfo::Memory64
             : wasm::Builder::MemoryInfo::Memory32);
}
wasm::MemoryGrow* Module::Memory::grow(wasm::Expression* value,
                                       const std::string& name,
                                       bool memory64) const {
  return wasm::Builder(*module).makeMemoryGrow(
    value,
    name,
    memory64 ? wasm::Builder::MemoryInfo::Memory64
             : wasm::Builder::MemoryInfo::Memory32);
}
wasm::MemoryInit* Module::Memory::init(const std::string& segment,
                                       wasm::Expression* dest,
                                       wasm::Expression* offset,
                                       wasm::Expression* size,
                                       const std::string& name) const {
  return wasm::Builder(*module).makeMemoryInit(
    segment, dest, offset, size, name);
}
wasm::MemoryCopy* Module::Memory::copy(wasm::Expression* dest,
                                       wasm::Expression* source,
                                       wasm::Expression* size,
                                       const std::string& destMemory,
                                       const std::string& sourceMemory) const {
  return wasm::Builder(*module).makeMemoryCopy(
    dest, source, size, destMemory, sourceMemory);
}
wasm::MemoryFill* Module::Memory::fill(wasm::Expression* dest,
                                       wasm::Expression* value,
                                       wasm::Expression* size,
                                       const std::string& name) const {
  return wasm::Builder(*module).makeMemoryFill(dest, value, size, name);
}
wasm::AtomicNotify*
Module::Memory::Atomic::notify(wasm::Expression* ptr,
                               wasm::Expression* notifyCount,
                               const std::string& name) const {
  return wasm::Builder(*module).makeAtomicNotify(ptr, notifyCount, 0, name);
}
wasm::AtomicWait*
Module::Memory::Atomic::wait32(wasm::Expression* ptr,
                               wasm::Expression* expected,
                               wasm::Expression* timeout,
                               const std::string& name) const {
  return wasm::Builder(*module).makeAtomicWait(
    ptr, expected, timeout, wasm::Type(wasm::Type::i32), 0, name);
}
wasm::AtomicWait*
Module::Memory::Atomic::wait64(wasm::Expression* ptr,
                               wasm::Expression* expected,
                               wasm::Expression* timeout,
                               const std::string& name) const {
  return wasm::Builder(*module).makeAtomicWait(
    ptr, expected, timeout, wasm::Type(wasm::Type::i64), 0, name);
}
wasm::DataDrop* Module::Data::drop(const std::string& segment) const {
  return wasm::Builder(*module).makeDataDrop(segment);
}
wasm::Load* Module::I32::load(uint32_t offset,
                              uint32_t align,
                              wasm::Expression* ptr,
                              const std::string& name) const {
  return wasm::Builder(*module).makeLoad(
    4, true, offset, align, ptr, wasm::Type(wasm::Type::i32), name);
}
wasm::Load* Module::I32::load8_s(uint32_t offset,
                                 uint32_t align,
                                 wasm::Expression* ptr,
                                 const std::string& name) const {
  return wasm::Builder(*module).makeLoad(
    1, true, offset, align, ptr, wasm::Type(wasm::Type::i32), name);
}
wasm::Load* Module::I32::load8_u(uint32_t offset,
                                 uint32_t align,
                                 wasm::Expression* ptr,
                                 const std::string& name) const {
  return wasm::Builder(*module).makeLoad(
    1, false, offset, align, ptr, wasm::Type(wasm::Type::i32), name);
}
wasm::Load* Module::I32::load16_s(uint32_t offset,
                                  uint32_t align,
                                  wasm::Expression* ptr,
                                  const std::string& name) const {
  return wasm::Builder(*module).makeLoad(
    2, true, offset, align, ptr, wasm::Type(wasm::Type::i32), name);
}
wasm::Load* Module::I32::load16_u(uint32_t offset,
                                  uint32_t align,
                                  wasm::Expression* ptr,
                                  const std::string& name) const {
  return wasm::Builder(*module).makeLoad(
    2, false, offset, align, ptr, wasm::Type(wasm::Type::i32), name);
}
wasm::Store* Module::I32::store(uint32_t offset,
                                uint32_t align,
                                wasm::Expression* ptr,
                                wasm::Expression* value,
                                const std::string& name) const {
  return wasm::Builder(*module).makeStore(
    4, offset, align, ptr, value, wasm::Type(wasm::Type::i32), name);
}
wasm::Store* Module::I32::store8(uint32_t offset,
                                 uint32_t align,
                                 wasm::Expression* ptr,
                                 wasm::Expression* value,
                                 const std::string& name) const {
  return wasm::Builder(*module).makeStore(
    1, offset, align, ptr, value, wasm::Type(wasm::Type::i32), name);
}
wasm::Store* Module::I32::store16(uint32_t offset,
                                  uint32_t align,
                                  wasm::Expression* ptr,
                                  wasm::Expression* value,
                                  const std::string& name) const {
  return wasm::Builder(*module).makeStore(
    2, offset, align, ptr, value, wasm::Type(wasm::Type::i32), name);
}
wasm::Const* Module::I32::const_(uint32_t x) const {
  return wasm::Builder(*module).makeConst(x);
}
wasm::Binary* Module::I32::add(wasm::Expression* left,
                               wasm::Expression* right) const {
  return wasm::Builder(*module).makeBinary(
    wasm::BinaryOp::AddInt32, left, right);
}
wasm::Drop* Module::drop(wasm::Expression* value) {
  return wasm::Builder(*module).makeDrop(value);
}
wasm::Return* Module::return_(wasm::Expression* value) {
  return wasm::Builder(*module).makeReturn(value);
}
wasm::Nop* Module::nop() { return wasm::Builder(*module).makeNop(); }
wasm::Unreachable* Module::unreachable() {
  return wasm::Builder(*module).makeUnreachable();
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

val getExpressionInfo(wasm::Expression* expr) {
  using namespace wasm;

  val info = val::object();
  info.set("id", val(expr->_id));
  info.set("type", (binaryen::TypeID)expr->type.getID());

#define DELEGATE_ID expr->_id

#define DELEGATE_START(id) [[maybe_unused]] auto* cast = expr->cast<wasm::id>();

#define DELEGATE_FIELD_CHILD(id, field) info.set(#field, cast->field);
#define DELEGATE_FIELD_OPTIONAL_CHILD(id, field) info.set(#field, cast->field);
#define DELEGATE_FIELD_CHILD_VECTOR(id, field)                                 \
  info.set(#field,                                                             \
           val::array(std::vector<wasm::Expression*>(cast->field.begin(),      \
                                                     cast->field.end())));
#define DELEGATE_FIELD_INT(id, field) info.set(#field, cast->field);
#define DELEGATE_FIELD_INT_ARRAY(id, field)
#define DELEGATE_FIELD_INT_VECTOR(id, field)
#define DELEGATE_FIELD_BOOL(id, field) info.set(#field, cast->field);
#define DELEGATE_FIELD_BOOL_VECTOR(id, field)
#define DELEGATE_FIELD_ENUM(id, field, type)
#define DELEGATE_FIELD_LITERAL(id, field)
#define DELEGATE_FIELD_NAME(id, field) info.set(#field, cast->field.toString());
#define DELEGATE_FIELD_NAME_VECTOR(id, field)                                  \
  {                                                                            \
    std::vector<std::string> vec;                                              \
    vec.reserve(cast->field.size());                                           \
    std::transform(cast->field.begin(),                                        \
                   cast->field.end(),                                          \
                   std::back_inserter(vec),                                    \
                   [](wasm::Name name) { return name.toString(); });           \
    info.set(#field, val::array(vec));                                         \
  }
#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, field)                               \
  info.set(#field,                                                             \
           cast->field.size() ? val(cast->field.toString()) : val::null());
#define DELEGATE_FIELD_SCOPE_NAME_USE(id, field) DELEGATE_FIELD_NAME(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_USE_VECTOR(id, field)                        \
  DELEGATE_FIELD_NAME_VECTOR(id, field)
#define DELEGATE_FIELD_TYPE(id, field)
#define DELEGATE_FIELD_TYPE_VECTOR(id, field)
#define DELEGATE_FIELD_HEAPTYPE(id, field)
#define DELEGATE_FIELD_ADDRESS(id, field)

#include "wasm-delegations-fields.def"

  switch (expr->_id) {
    case Expression::Id::BlockId: {
      auto* cast = expr->cast<wasm::Block>();
      info.set("children",
               val::array(std::vector<wasm::Expression*>(cast->list.begin(),
                                                         cast->list.end())));
      break;
    }
    case Expression::Id::SwitchId: {
      auto* cast = expr->cast<wasm::Switch>();

      info.set("defaultName", cast->default_.toString());

      std::vector<std::string> vec;
      vec.reserve(cast->targets.size());
      std::transform(cast->targets.begin(),
                     cast->targets.end(),
                     std::back_inserter(vec),
                     [](wasm::Name name) { return name.toString(); });
      info.set("names", val::array(vec));
      break;
    }
    case Expression::Id::CallIndirectId: {
      auto* cast = expr->cast<wasm::CallIndirect>();
      wasm::Signature signature = cast->heapType.getSignature();
      info.set("params", binaryen::TypeID(signature.params.getID()));
      info.set("results", binaryen::TypeID(signature.results.getID()));
      break;
    }
    default:
      break;
  }

  return info;
}

std::string toText(wasm::Expression* expr) {
  std::ostringstream os;
  bool colors = Colors::isEnabled();
  Colors::setEnabled(false); // do not use colors for writing
  os << *expr << '\n';
  Colors::setEnabled(colors); // restore colors state
  return os.str();
}

void finalize(wasm::Expression* expr) { wasm::ReFinalizeNode().visit(expr); }
} // namespace binaryen

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
  return str;
}

static std::string unboolenize(std::string str) {
  if (str.substr(0, 2) == "is")
    str = uncapitalize(str, 2).substr(2);
  return str;
}

static std::string unpluralize(std::string str) {
  if (str == "children")
    str = str.substr(0, 5);
  else if (str.back() == 's') {
    str.pop_back();
    if (str.substr(str.size() - 2, 2) == "ie")
      str = str.substr(0, str.size() - 2) + "y";
  }
  return str;
}

#define GETTER_NAME(field) capitalize("get"s + field, 3)
#define BOOL_GETTER_NAME(field) capitalize("is"s + field, 2)
#define SETTER_NAME(field) capitalize("set"s + field, 3)

#define ACCESSOR(target, name, accessor, ...)                                  \
  target.class_function(name, +accessor, ##__VA_ARGS__)                        \
    .function(name, +accessor, ##__VA_ARGS__);

#define FIELD_G(target, id, field, name, getterName, type, cppToJs, ...)       \
  {                                                                            \
    auto getter = [](const wasm::id& expr) { return cppToJs(expr.field); };    \
    ACCESSOR(target, getterName, getter, ##__VA_ARGS__);                       \
    target.property(name, +getter, ##__VA_ARGS__);                             \
  }

#define FIELD_CONST(target, id, field, name, type, cppToJs, ...)               \
  {                                                                            \
    std::string propName = normalize(name);                                    \
    std::string getterName = GETTER_NAME(propName);                            \
    FIELD_G(target,                                                            \
            id,                                                                \
            field,                                                             \
            propName.c_str(),                                                  \
            getterName.c_str(),                                                \
            type,                                                              \
            jsToCpp,                                                           \
            ##__VA_ARGS__);                                                    \
  }

#define FIELD_GS(target,                                                       \
                 id,                                                           \
                 field,                                                        \
                 name,                                                         \
                 getterName,                                                   \
                 setterName,                                                   \
                 type,                                                         \
                 jsToCpp,                                                      \
                 cppToJs,                                                      \
                 ...)                                                          \
  {                                                                            \
    auto getter = [](const wasm::id& expr) {                                   \
      return (type)(cppToJs(expr.field));                                      \
    };                                                                         \
    auto setter = [](wasm::id& expr, type value) {                             \
      expr.field = jsToCpp(value);                                             \
    };                                                                         \
    ACCESSOR(target, getterName, getter, ##__VA_ARGS__);                       \
    ACCESSOR(target, setterName, setter, ##__VA_ARGS__);                       \
    target.property(name, +getter, +setter, ##__VA_ARGS__);                    \
  }

#define FIELD(target, id, field, name, type, jsToCpp, cppToJs, ...)            \
  {                                                                            \
    std::string propName = normalize(name);                                    \
    std::string getterName = GETTER_NAME(propName);                            \
    std::string setterName = SETTER_NAME(propName);                            \
    FIELD_GS(target,                                                           \
             id,                                                               \
             field,                                                            \
             propName.c_str(),                                                 \
             getterName.c_str(),                                               \
             setterName.c_str(),                                               \
             type,                                                             \
             jsToCpp,                                                          \
             cppToJs,                                                          \
             ##__VA_ARGS__);                                                   \
  }

#define FIELD_PROP_G(target, id, field, name, getterName, type, ...)           \
  {                                                                            \
    auto getter = [](const wasm::id& expr) { return expr.field; };             \
    ACCESSOR(target, getterName, getter, ##__VA_ARGS__);                       \
    target.property(name, &wasm::id::field, ##__VA_ARGS__);                    \
  }

#define FIELD_PROP_CONST(target, id, field, name, type, ...)                   \
  {                                                                            \
    std::string propName = normalize(name);                                    \
    std::string getterName = GETTER_NAME(propName);                            \
    FIELD_PROP_G(target,                                                       \
                 id,                                                           \
                 field,                                                        \
                 propName.c_str(),                                             \
                 getterName.c_str(),                                           \
                 type,                                                         \
                 ##__VA_ARGS__);                                               \
  }

#define FIELD_PROP_GS(                                                         \
  target, id, field, name, getterName, setterName, type, ...)                  \
  {                                                                            \
    auto getter = [](const wasm::id& expr) { return (type)(expr.field); };     \
    auto setter = [](wasm::id& expr, type value) { expr.field = value; };      \
    ACCESSOR(target, getterName, getter, ##__VA_ARGS__);                       \
    ACCESSOR(target, setterName, setter, ##__VA_ARGS__);                       \
    target.property(name, &wasm::id::field, ##__VA_ARGS__);                    \
  }

#define FIELD_PROP(target, id, field, name, type, ...)                         \
  {                                                                            \
    std::string propName = normalize(name);                                    \
    std::string getterName = GETTER_NAME(propName);                            \
    std::string setterName = SETTER_NAME(propName);                            \
    FIELD_PROP_GS(target,                                                      \
                  id,                                                          \
                  field,                                                       \
                  propName.c_str(),                                            \
                  getterName.c_str(),                                          \
                  setterName.c_str(),                                          \
                  type,                                                        \
                  ##__VA_ARGS__);                                              \
  }

#define FIELD_PROP_BOOL(target, id, field, name, ...)                          \
  {                                                                            \
    std::string propName = unboolenize(normalize(name));                       \
    std::string getterName = BOOL_GETTER_NAME(propName);                       \
    std::string setterName = SETTER_NAME(propName);                            \
    FIELD_PROP_GS(target,                                                      \
                  id,                                                          \
                  field,                                                       \
                  propName.c_str(),                                            \
                  getterName.c_str(),                                          \
                  setterName.c_str(),                                          \
                  bool,                                                        \
                  ##__VA_ARGS__);                                              \
  }

#define FIELD_VEC(                                                             \
  target, id, field, name, listType, elemType, jsToCpp, cppToJs, ...)          \
  {                                                                            \
    std::string listName = normalize(name);                                    \
    std::string elemName = unpluralize(listName);                              \
    {                                                                          \
      std::string getterName = GETTER_NAME(listName);                          \
      std::string setterName = SETTER_NAME(listName);                          \
      auto getter = [](const wasm::id& expr) {                                 \
        std::vector<elemType> valVec;                                          \
        valVec.reserve(expr.field.size());                                     \
        std::transform(expr.field.begin(),                                     \
                       expr.field.end(),                                       \
                       std::back_inserter(valVec),                             \
                       cppToJs);                                               \
        return listType(val::array(valVec));                                   \
      };                                                                       \
      auto setter = [](wasm::id& expr, listType value) {                       \
        std::vector<elemType> valVec =                                         \
          vecFromJSArray<elemType>(value, ##__VA_ARGS__);                      \
        expr.field.resize(valVec.size());                                      \
        std::transform(                                                        \
          valVec.begin(), valVec.end(), expr.field.begin(), jsToCpp);          \
      };                                                                       \
      ACCESSOR(target, getterName.c_str(), getter, ##__VA_ARGS__);             \
      ACCESSOR(target, setterName.c_str(), setter, ##__VA_ARGS__);             \
      target.property(listName.c_str(), +getter, +setter, ##__VA_ARGS__);      \
    }                                                                          \
    {                                                                          \
      std::string propName = capitalize("num" + listName, 3);                  \
      std::string getterName = GETTER_NAME(propName);                          \
      auto getter = [](const wasm::id& expr) {                                 \
        return uint32_t(expr.field.size());                                    \
      };                                                                       \
      ACCESSOR(target, getterName.c_str(), getter, ##__VA_ARGS__);             \
      target.property(propName.c_str(), +getter, ##__VA_ARGS__);               \
    }                                                                          \
    {                                                                          \
      std::string funcName = capitalize("get" + elemName + "At", 3);           \
      auto func = [](const wasm::id& expr, uint32_t index) {                   \
        assert(index < expr.field.size());                                     \
        return (elemType)cppToJs(expr.field[index]);                           \
      };                                                                       \
      target.class_function(funcName.c_str(), +func, ##__VA_ARGS__)            \
        .function(funcName.c_str(), +func, ##__VA_ARGS__);                     \
    }                                                                          \
    {                                                                          \
      std::string funcName = capitalize("set" + elemName + "At", 3);           \
      auto func = [](wasm::id& expr, uint32_t index, elemType elem) {          \
        assert(index < expr.field.size());                                     \
        expr.field[index] = jsToCpp(elem);                                     \
      };                                                                       \
      target.class_function(funcName.c_str(), +func, ##__VA_ARGS__)            \
        .function(funcName.c_str(), +func, ##__VA_ARGS__);                     \
    }                                                                          \
    {                                                                          \
      std::string funcName = capitalize("append" + elemName, 6);               \
      auto func = [](wasm::id& expr, elemType elem) {                          \
        auto index = expr.field.size();                                        \
        expr.field.push_back(jsToCpp(elem));                                   \
        return index;                                                          \
      };                                                                       \
      target.class_function(funcName.c_str(), +func, ##__VA_ARGS__)            \
        .function(funcName.c_str(), +func, ##__VA_ARGS__);                     \
    }                                                                          \
    {                                                                          \
      std::string funcName = capitalize("insert" + elemName + "At", 6);        \
      auto func = [](wasm::id& expr, uint32_t index, elemType elem) {          \
        expr.field.insertAt(index, jsToCpp(elem));                             \
      };                                                                       \
      target.class_function(funcName.c_str(), +func, ##__VA_ARGS__)            \
        .function(funcName.c_str(), +func, ##__VA_ARGS__);                     \
    }                                                                          \
    {                                                                          \
      std::string funcName = capitalize("remove" + elemName + "At", 6);        \
      auto func = [](wasm::id& expr, uint32_t index) {                         \
        return (elemType)cppToJs(expr.field.removeAt(index));                  \
      };                                                                       \
      target.class_function(funcName.c_str(), +func, ##__VA_ARGS__)            \
        .function(funcName.c_str(), +func, ##__VA_ARGS__);                     \
    }                                                                          \
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

  class_<binaryen::Module::Local>("Module_Local") // TODO: factory class
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

  class_<binaryen::Module::Table>("Module_Table")
    .function("get",
              &binaryen::Module::Table::get,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function("set",
              &binaryen::Module::Table::set,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function("size",
              &binaryen::Module::Table::size,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function("grow",
              &binaryen::Module::Table::grow,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>());

  class_<binaryen::Module::Memory>("Module_Memory")
    .function("size",
              &binaryen::Module::Memory::size,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function("grow",
              &binaryen::Module::Memory::grow,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function("init",
              &binaryen::Module::Memory::init,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function("copy",
              &binaryen::Module::Memory::copy,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function("fill",
              &binaryen::Module::Memory::fill,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .property("atomic",
              &binaryen::Module::Memory::atomic,
              allow_raw_pointers(),
              return_value_policy::reference());

  class_<binaryen::Module::Memory::Atomic>("Module_Memory_Atomic")
    .function("notify",
              &binaryen::Module::Memory::Atomic::notify,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function("wait32",
              &binaryen::Module::Memory::Atomic::wait32,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function("wait64",
              &binaryen::Module::Memory::Atomic::wait64,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>());

  class_<binaryen::Module::Data>("Module_Data")
    .function("drop",
              &binaryen::Module::Data::drop,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>());

  class_<binaryen::Module::I32>("Module_I32")
    .function("load",
              &binaryen::Module::I32::load,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function("load8_s",
              &binaryen::Module::I32::load8_s,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function("load8_u",
              &binaryen::Module::I32::load8_u,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function("load16_s",
              &binaryen::Module::I32::load16_s,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function("load16_u",
              &binaryen::Module::I32::load16_u,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function("store",
              &binaryen::Module::I32::store,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function("store8",
              &binaryen::Module::I32::store16,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function("const",
              &binaryen::Module::I32::const_,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
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
    .property("local",
              &binaryen::Module::local,
              allow_raw_pointers(),
              return_value_policy::reference())
    .property("global",
              &binaryen::Module::global,
              allow_raw_pointers(),
              return_value_policy::reference())
    .property("table",
              &binaryen::Module::table,
              allow_raw_pointers(),
              return_value_policy::reference())
    .property("memory",
              &binaryen::Module::memory,
              allow_raw_pointers(),
              return_value_policy::reference())
    .property("data",
              &binaryen::Module::data,
              allow_raw_pointers(),
              return_value_policy::reference())
    .property("i32",
              &binaryen::Module::i32,
              allow_raw_pointers(),
              return_value_policy::reference())
    .function("drop",
              &binaryen::Module::drop,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function("return",
              &binaryen::Module::return_,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function("nop",
              &binaryen::Module::nop,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function("unreachable",
              &binaryen::Module::unreachable,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())

    .function("addFunction",
              &binaryen::Module::addFunction,
              allow_raw_pointers(),
              return_value_policy::reference(),
              nonnull<ret_val>())
    .function("addFunctionExport",
              &binaryen::Module::addFunctionExport,
              allow_raw_pointers(),
              return_value_policy::reference(),
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

  auto ExpressionWrapper =
    class_<wasm::Expression>("Expression")
      .class_function("finalize", &binaryen::finalize, allow_raw_pointers())
      .function("finalize", &binaryen::finalize, allow_raw_pointers())
      .class_function("toText", &binaryen::toText, allow_raw_pointers())
      .function("toText", &binaryen::toText, allow_raw_pointers());
  FIELD_PROP_CONST(
    ExpressionWrapper, Expression, _id, "id", wasm::Expression::Id);
  FIELD(
    ExpressionWrapper,
    Expression,
    type,
    "type",
    binaryen::TypeID,
    [](binaryen::TypeID value) { return wasm::Type(value); },
    [](wasm::Type value) { return value.getID(); });
  ExpressionWrapper.function(
    "valueOf", +[](const wasm::Expression& expr) {
      return reinterpret_cast<uint32_t>(&expr);
    });

  register_type<binaryen::ExpressionList>("Expression[]");

  register_type<binaryen::NameList>("string[]");

#define DELEGATE_FIELD_MAIN_START

#define DELEGATE_FIELD_CASE_START(id)                                          \
  [[maybe_unused]] auto id##Wrapper =                                          \
    class_<wasm::id, base<wasm::Expression>>(#id).constructor(                 \
      +[](wasm::Expression* expr) {                                            \
        assert(expr->is<wasm::id>());                                          \
        return static_cast<wasm::id*>(expr);                                   \
      },                                                                       \
      allow_raw_pointers());                                                   \
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
  FIELD_PROP(id##Wrapper,                                                      \
             id,                                                               \
             field,                                                            \
             #field,                                                           \
             wasm::Expression*,                                                \
             allow_raw_pointers(),                                             \
             return_value_policy::reference(),                                 \
             nonnull<ret_val>());
#define DELEGATE_FIELD_OPTIONAL_CHILD(id, field)                               \
  FIELD_PROP(id##Wrapper,                                                      \
             id,                                                               \
             field,                                                            \
             #field,                                                           \
             wasm::Expression*,                                                \
             allow_raw_pointers(),                                             \
             return_value_policy::reference());
#define DELEGATE_FIELD_CHILD_VECTOR(id, field)                                 \
  FIELD_VEC(                                                                   \
    id##Wrapper,                                                               \
    id,                                                                        \
    field,                                                                     \
    #field,                                                                    \
    binaryen::ExpressionList,                                                  \
    wasm::Expression*,                                                         \
    [](wasm::Expression* value) { return value; },                             \
    [](wasm::Expression* value) { return value; },                             \
    allow_raw_pointers(),                                                      \
    return_value_policy::reference());
#define DELEGATE_FIELD_INT(id, field)                                          \
  FIELD_PROP(id##Wrapper, id, field, #field, uint32_t);
#define DELEGATE_FIELD_INT_ARRAY(id, field)
#define DELEGATE_FIELD_INT_VECTOR(id, field)
#define DELEGATE_FIELD_BOOL(id, field)                                         \
  FIELD_PROP_BOOL(id##Wrapper, id, field, #field);
#define DELEGATE_FIELD_BOOL_VECTOR(id, field)
#define DELEGATE_FIELD_ENUM(id, field, type)
#define DELEGATE_FIELD_LITERAL(id, field)
#define DELEGATE_FIELD_NAME(id, field)                                         \
  FIELD(                                                                       \
    id##Wrapper,                                                               \
    id,                                                                        \
    field,                                                                     \
    #field,                                                                    \
    const std::string&,                                                        \
    [](const std::string& value) { return value; },                            \
    [](wasm::Name value) { return value.toString(); });
#define DELEGATE_FIELD_NAME_VECTOR(id, field)                                  \
  FIELD_VEC(                                                                   \
    id##Wrapper,                                                               \
    id,                                                                        \
    field,                                                                     \
    #field,                                                                    \
    binaryen::NameList,                                                        \
    std::string,                                                               \
    [](const std::string& value) { return value; },                            \
    [](wasm::Name value) { return value.toString(); });
#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, field)                               \
  FIELD(                                                                       \
    id##Wrapper,                                                               \
    id,                                                                        \
    field,                                                                     \
    #field,                                                                    \
    binaryen::OptionalString,                                                  \
    [](binaryen::OptionalString value) {                                       \
      return value.isNull() ? nullptr : value.as<std::string>();               \
    },                                                                         \
    [](wasm::Name value) {                                                     \
      return binaryen::OptionalString(value.size() ? val(value.toString())     \
                                                   : val::null());             \
    });
#define DELEGATE_FIELD_SCOPE_NAME_USE(id, field) DELEGATE_FIELD_NAME(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_USE_VECTOR(id, field)                        \
  DELEGATE_FIELD_NAME_VECTOR(id, field)
#define DELEGATE_FIELD_TYPE(id, field)                                         \
  FIELD(                                                                       \
    id##Wrapper,                                                               \
    id,                                                                        \
    field,                                                                     \
    #field,                                                                    \
    binaryen::TypeID,                                                          \
    [](binaryen::TypeID value) { return wasm::Type(value); },                  \
    [](wasm::Type value) { return value.getID(); });
#define DELEGATE_FIELD_TYPE_VECTOR(id, field)                                  \
  FIELD_VEC(                                                                   \
    id##Wrapper,                                                               \
    id,                                                                        \
    field,                                                                     \
    #field,                                                                    \
    binaryen::TypeList,                                                        \
    binaryen::TypeID,                                                          \
    [](binaryen::TypeID value) { return wasm::Type(value); },                  \
    [](wasm::Type value) { return value.getID(); });
#define DELEGATE_FIELD_HEAPTYPE(id, field)
#define DELEGATE_FIELD_ADDRESS(id, field)

#include "wasm-delegations-fields.def"

  // Extensions
  { // Block
    FIELD_VEC(
      BlockWrapper,
      Block,
      list,
      "children",
      binaryen::ExpressionList,
      wasm::Expression*,
      [](wasm::Expression* value) { return value; },
      [](wasm::Expression* value) { return value; },
      allow_raw_pointers(),
      return_value_policy::reference());
  }

  { // Switch
    FIELD(
      SwitchWrapper,
      Switch,
      default_,
      "defaultName",
      const std::string&,
      [](const std::string& value) { return value; },
      [](wasm::Name value) { return value.toString(); });
    FIELD_VEC(
      SwitchWrapper,
      Switch,
      targets,
      "names",
      binaryen::NameList,
      std::string,
      [](const std::string& value) { return value; },
      [](wasm::Name value) { return value.toString(); });
  }

  { // CallIndirect
    {
      std::string propName = "params";
      std::string getterName = GETTER_NAME(propName);
      std::string setterName = SETTER_NAME(propName);
      auto getter = [](const wasm::CallIndirect& expr) {
        return binaryen::TypeID(expr.heapType.getSignature().params.getID());
      };
      auto setter = [](wasm::CallIndirect& expr, binaryen::TypeID value) {
        expr.heapType = wasm::Signature(wasm::Type(value),
                                        expr.heapType.getSignature().results);
      };
      ACCESSOR(CallIndirectWrapper, getterName.c_str(), +getter);
      ACCESSOR(CallIndirectWrapper, setterName.c_str(), +setter);
      CallIndirectWrapper.property(propName.c_str(), +getter, +setter);
    }
    {
      std::string propName = "results";
      std::string getterName = GETTER_NAME(propName);
      std::string setterName = SETTER_NAME(propName);
      auto getter = [](const wasm::CallIndirect& expr) {
        return binaryen::TypeID(expr.heapType.getSignature().results.getID());
      };
      auto setter = [](wasm::CallIndirect& expr, binaryen::TypeID value) {
        expr.heapType = wasm::Signature(expr.heapType.getSignature().params,
                                        wasm::Type(value));
      };
      ACCESSOR(CallIndirectWrapper, getterName.c_str(), +getter);
      ACCESSOR(CallIndirectWrapper, setterName.c_str(), +setter);
      CallIndirectWrapper.property(propName.c_str(), +getter, +setter);
    }
  }
}