/*
 * Copyright 2023 WebAssembly Community Group participants
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

#ifndef parser_wat_parser_h
#define parser_wat_parser_h

#include <string_view>

#include "support/result.h"
#include "wasm.h"

namespace wasm::WATParser {

// Parse a single WAT module.
Result<> parseModule(Module& wasm, std::string_view in);

} // namespace wasm::WATParser

#endif // parser_wat_parser_h
