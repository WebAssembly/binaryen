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

#include "parser/lexer.h"
#include "support/result.h"
#include "wasm.h"

namespace wasm::WATParser {

// Parse a single WAT module.
Result<> parseModule(Module& wasm, std::string_view in);

// Parse a single WAT module that may have other things after it, as in a wast
// file.
Result<> parseModule(Module& wasm, Lexer& lexer);

Result<Literal> parseConst(Lexer& lexer);

struct InvokeAction {
  std::optional<Name> base;
  Name name;
  Literals args;
};

struct GetAction {
  std::optional<Name> base;
  Name name;
};

using Action = std::variant<InvokeAction, GetAction>;

struct RefResult {
  HeapType type;
};

enum class NaNKind { Canonical, Arithmetic };

struct NaNResult {
  NaNKind kind;
  Type type;
};

using LaneResult = std::variant<Literal, NaNResult>;

using LaneResults = std::vector<LaneResult>;

using ExpectedResult = std::variant<Literal, RefResult, NaNResult, LaneResults>;

using ExpectedResults = std::vector<ExpectedResult>;

struct AssertReturn {
  Action action;
  ExpectedResults expected;
};

enum class ActionAssertionType { Trap, Exhaustion, Exception };

struct AssertAction {
  ActionAssertionType type;
  Action action;
};

enum class QuotedModuleType { Text, Binary };

struct QuotedModule {
  QuotedModuleType type;
  std::string module;
};

using WASTModule = std::variant<QuotedModule, std::shared_ptr<Module>>;

enum class ModuleAssertionType { Trap, Malformed, Invalid, Unlinkable };

struct AssertModule {
  ModuleAssertionType type;
  WASTModule wasm;
};

using Assertion = std::variant<AssertReturn, AssertAction, AssertModule>;

struct Register {
  Name name;
};

using WASTCommand = std::variant<WASTModule, Register, Action, Assertion>;

struct ScriptEntry {
  WASTCommand cmd;
  size_t line;
};

using WASTScript = std::vector<ScriptEntry>;

Result<WASTScript> parseScript(std::string_view in);

} // namespace wasm::WATParser

#endif // parser_wat_parser_h
