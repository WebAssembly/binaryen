/*
 * Copyright 2015 WebAssembly Community Group participants
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

#ifndef wasm_parsing_h
#define wasm_parsing_h

#include <cmath>
#include <ostream>
#include <sstream>
#include <string>

#include "mixed_arena.h"
#include "shared-constants.h"
#include "support/colors.h"
#include "support/utilities.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

struct ParseException {
  std::string text;
  size_t line, col;

  ParseException() : text("unknown parse error"), line(-1), col(-1) {}
  ParseException(std::string text) : text(text), line(-1), col(-1) {}
  ParseException(std::string text, size_t line, size_t col)
    : text(text), line(line), col(col) {}

  void dump(std::ostream& o) const;
};

struct MapParseException {
  std::string text;

  MapParseException() : text("unknown parse error") {}
  MapParseException(std::string text) : text(text) {}

  void dump(std::ostream& o) const;
};

// Helper for parsers that may not have unique label names. This transforms
// the names into unique ones, as required by Binaryen IR.
struct UniqueNameMapper {
  std::vector<Name> labelStack;
  // name in source => stack of uniquified names
  std::map<Name, std::vector<Name>> labelMappings;
  std::map<Name, Name> reverseLabelMapping; // uniquified name => name in source

  Index otherIndex = 0;

  Name getPrefixedName(Name prefix);

  // receives a source name. generates a unique name, pushes it, and returns it
  Name pushLabelName(Name sName);

  void popLabelName(Name name);

  Name sourceToUnique(Name sName);

  Name uniqueToSource(Name name);

  void clear();

  // Given an expression, ensures all names are unique
  static void uniquify(Expression* curr);
};

} // namespace wasm

#endif // wasm_parsing_h
