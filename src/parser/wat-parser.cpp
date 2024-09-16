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

#include "wat-parser.h"
#include "contexts.h"
#include "ir/names.h"
#include "lexer.h"
#include "pass.h"
#include "wasm-type.h"
#include "wasm.h"
#include "wat-parser-internal.h"

// The WebAssembly text format is recursive in the sense that elements may be
// referred to before they are declared. Furthermore, elements may be referred
// to by index or by name. As a result, we need to parse text modules in
// multiple phases.
//
// In the first phase, we find all of the module element declarations and
// record, but do not interpret, the input spans of their corresponding
// definitions. This phase establishes the indices and names of each module
// element so that subsequent phases can look them up.
//
// The second phase parses type definitions to construct the types used in the
// module. This has to be its own phase because we have no way to refer to a
// type before it has been built along with all the other types, unlike for
// other module elements that can be referred to by name before their
// definitions have been parsed.
//
// The third phase further parses and constructs types implicitly defined by
// type uses in functions, blocks, and call_indirect instructions. These
// implicitly defined types may be referred to by index elsewhere.
//
// The fourth phase parses and sets the types of globals, functions, and other
// top-level module elements. These types need to be set before we parse
// instructions because they determine the types of instructions such as
// global.get and ref.func.
//
// The fifth and final phase parses the remaining contents of all module
// elements, including instructions.
//
// Each phase of parsing gets its own context type that is passed to the
// individual parsing functions. There is a parsing function for each element of
// the grammar given in the spec. Parsing functions are templatized so that they
// may be passed the appropriate context type and return the correct result type
// for each phase.

namespace wasm::WATParser {

namespace {

Result<IndexMap> createIndexMap(Lexer& in, const std::vector<DefPos>& defs) {
  IndexMap indices;
  for (auto& def : defs) {
    if (def.name.is()) {
      if (!indices.insert({def.name, def.index}).second) {
        return in.err(def.pos, "duplicate element name");
      }
    }
  }
  return indices;
}

void propagateDebugLocations(Module& wasm) {
  // Copy debug locations from parents or previous siblings to expressions that
  // do not already have their own debug locations.
  PassRunner runner(&wasm);
  runner.add("propagate-debug-locs");
  // The parser should not be responsible for validation.
  runner.setIsNested(true);
  runner.run();
}

// Parse module-level declarations.

// Parse type definitions.

// Parse implicit type definitions and map typeuses without explicit types to
// the correct types.

Result<> doParseModule(Module& wasm, Lexer& input, bool allowExtra) {
  ParseDeclsCtx decls(input, wasm);
  CHECK_ERR(parseDecls(decls));
  if (!allowExtra && !decls.in.empty()) {
    return decls.in.err("Unexpected tokens after module");
  }

  auto typeIndices = createIndexMap(decls.in, decls.typeDefs);
  CHECK_ERR(typeIndices);

  std::vector<HeapType> types;
  std::unordered_map<HeapType, std::unordered_map<Name, Index>> typeNames;
  CHECK_ERR(parseTypeDefs(decls, input, *typeIndices, types, typeNames));

  std::unordered_map<Index, HeapType> implicitTypes;
  CHECK_ERR(
    parseImplicitTypeDefs(decls, input, *typeIndices, types, implicitTypes));

  CHECK_ERR(parseModuleTypes(decls, input, *typeIndices, types, implicitTypes));

  CHECK_ERR(parseDefinitions(
    decls, input, *typeIndices, types, implicitTypes, typeNames));

  propagateDebugLocations(wasm);
  input = decls.in;

  return Ok{};
}

} // anonymous namespace

Result<> parseModule(Module& wasm, std::string_view in) {
  Lexer lexer(in);
  return doParseModule(wasm, lexer, false);
}

Result<> parseModule(Module& wasm, Lexer& lexer) {
  return doParseModule(wasm, lexer, true);
}

} // namespace wasm::WATParser
