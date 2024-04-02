/*
 * Copyright 2024 WebAssembly Community Group participants
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//==============================
// Binaryen Embind declarations
//==============================

#include <emscripten/bind.h>

#include "wasm.h"
#include "wasm-builder.h"

using namespace wasm;
using namespace emscripten;

// Wrappers for things that don't quite fit with embind.
namespace {

std::string stringify(Module& wasm) {
  std::stringstream str;
  str << wasm;
  return str.str();
}

} // anonymous namespace

EMSCRIPTEN_BINDINGS(Binaryen) {

  function("stringify", &stringify);

  enum_<Type::BasicType>("BasicType")
      .value("i32", Type::BasicType::i32)
  ;

  class_<Type>("Type")
    .constructor<Type::BasicType>()
    .function("isTuple", &Type::isTuple)
    .function("isRef", &Type::isRef)
    .function("isFunction", &Type::isFunction)
    .function("isData", &Type::isData)
    .function("isNullable", &Type::isNullable)
    .function("isNonNullable", &Type::isNonNullable)
    .function("isNull", &Type::isNull)
    .function("isSignature", &Type::isSignature)
    .function("isStruct", &Type::isStruct)
    .function("isArray", &Type::isArray)
    .function("isException", &Type::isException)
    .function("isString", &Type::isString)
    .function("isDefaultable", &Type::isDefaultable)
    .function("getHeapType", &Type::getHeapType)
  ;
  register_vector<Type>("TypeVec");

  value_object<Signature>("Signature")
    .field("params", &Signature::params)
    .field("results", &Signature::results)
  ;

  class_<HeapType>("HeapType")
    .constructor<Signature>()
  ;

  class_<Name>("Name")
    .constructor<const std::string&>();

  class_<Expression>("Expression")
    .property("type", &Expression::type);

  class_<Nop, base<Expression>>("Nop");




#define DELEGATE_ID id

#define DELEGATE_START(id) std::cout << "// " #id << '\n';

#define DELEGATE_END(id) std::cout << '\n';

#define DELEGATE_FIELD_CHILD(id, field)                                        \
  std::cout << "BINARYEN_API BinaryenExpressionRef Binaryen" << #id << "Get"   \
            << #field << "(BinaryenExpressionRef expr);\n";

#define DELEGATE_FIELD_CHILD_VECTOR(id, field)                                 \
  std::cout << "BINARYEN_API BinaryenExpressionRef Binaryen" << #id << "Get"   \
            << #field                                 \
            << "At(BinaryenExpressionRef expr, BinaryenIndex index);\n";

// TODO
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

#define DELEGATE(clazz) \
  class_<clazz, base<Expression>>(#clazz)
#include "wasm-delegations-fields.def"
  ;

#include "wasm-delegations.def"




  // Module-level constructs.

  class_<Named>("Named")
    .property("name", &Named::name);

  class_<Importable>("Importable")
    .property("module", &Importable::module)
    .property("base", &Importable::base)
  ;

  class_<Function>("Function")
  ;

  class_<NameType>("NameType")
    .constructor<Name, Type>()
    .property("name", &NameType::name)
    .property("type", &NameType::type)
  ;
  register_vector<NameType>("NameTypeVec");

  class_<Builder>("Builder")
    .constructor<Module&>()
    .class_function("makeFunction",
              select_overload<std::unique_ptr<Function> (Name,
                                                         HeapType,
                                                         std::vector<Type>&& vars,
                                                         Expression*)
                             >(&Builder::makeFunction), allow_raw_pointers())

  // TODO All Expression classes...
  .function("makeNop", &Builder::makeNop, allow_raw_pointers()) 
  ;

  class_<Module>("Module")
    .smart_ptr_constructor("Module", &std::make_shared<Module>)
    .property("start", &Module::start)
    .function("getFunction", &Module::getFunction, allow_raw_pointers())
    .function("getFunctionOrNull", &Module::getFunctionOrNull, allow_raw_pointers())
    .function("addFunction", select_overload<Function* (Function*)>(&Module::addFunction), allow_raw_pointers())
  ;

}
