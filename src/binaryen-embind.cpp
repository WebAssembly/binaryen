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

using namespace wasm;
using namespace emscripten;

Function* (Module::*Module_addFunction)(Function*) = &Module::addFunction; // XXX work around overloaded name

EMSCRIPTEN_BINDINGS(Binaryen) {

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

  class_<Function>("Function")
    ;

  class_<Module>("Module")
    .property("start", &Module::start)
    .function("getFunction", &Module::getFunction, allow_raw_pointers())
    .function("getFunctionOrNull", &Module::getFunctionOrNull, allow_raw_pointers())
    .function("addFunction", Module_addFunction, allow_raw_pointers()) // XXX
    ;

}
