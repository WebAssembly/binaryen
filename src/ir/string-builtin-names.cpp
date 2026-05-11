/*
 * Copyright 2026 WebAssembly Community Group participants
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

#include "ir/string-builtin-names.h"

namespace wasm {

namespace StringBuiltins {

const ImportNames fromCharCodeArray{"wasm:js-string", "fromCharCodeArray"};
const ImportNames fromCodePoint{"wasm:js-string", "fromCodePoint"};
const ImportNames concat{"wasm:js-string", "concat"};
const ImportNames intoCharCodeArray{"wasm:js-string", "intoCharCodeArray"};
const ImportNames equals{"wasm:js-string", "equals"};
const ImportNames test{"wasm:js-string", "test"};
const ImportNames compare{"wasm:js-string", "compare"};
const ImportNames length{"wasm:js-string", "length"};
const ImportNames charCodeAt{"wasm:js-string", "charCodeAt"};
const ImportNames substring{"wasm:js-string", "substring"};

const std::array<ImportNames, 10> allBuiltins = {fromCharCodeArray,
                                                 fromCodePoint,
                                                 concat,
                                                 intoCharCodeArray,
                                                 equals,
                                                 test,
                                                 compare,
                                                 length,
                                                 charCodeAt,
                                                 substring};

} // namespace StringBuiltins

} // namespace wasm
