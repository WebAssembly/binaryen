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

  class_<Type>("Type")
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
    .function("isDefaultable", &Type::isDefaultable);

  class_<Name>("Name")
    .constructor<const std::string&>();

  class_<Expression>("Expression")
    .property("type", &Expression::type);

  // All Expression classes...

  // Module-level constructs.

  class_<Named>("Named")
    .property("name", &Named::name);

  class_<Importable>("Importable")
    .property("module", &Importable::module)
    .property("base", &Importable::base)
    ;

  class_<Function>("Function")
    ;

  class_<Builder>("Builder")
    .constructor<Module&>()
    .function("makeFunction", select_overload<std::unique_ptr<Function> (Name, std::vector<NameType>&&, HeapType, std::vector<NameType>&& vars, Expression*)>(&Builder::makeFunction), allow_raw_pointers())

    // All Expression classes...
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
