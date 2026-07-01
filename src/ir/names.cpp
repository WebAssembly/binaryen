/*
 * Copyright 2021 WebAssembly Community Group participants
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

#include "ir/names.h"
#include <sstream>

namespace wasm::Names {

// Reserved words in JS that we will not emit up to size 4 - size 5 and above
// would mean we use an astronomical number of symbols, which is not realistic
// anyhow.
static std::unordered_set<std::string> reserved = {"do",
                                                   "if",
                                                   "in",
                                                   "for",
                                                   "new",
                                                   "try",
                                                   "var",
                                                   "env",
                                                   "let",
                                                   "case",
                                                   "else",
                                                   "enum",
                                                   "void",
                                                   "this",
                                                   "with"};

// Possible initial letters.
static std::string validInitialChars =
  "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_$";

// Possible later letters.
static std::string validLaterChars =
  "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_$0123456789";

std::string MinifiedNameGenerator::getName() {
  std::string name;
  do {
    size_t n = state++;
    std::stringstream ss;
    ss << validInitialChars[n % validInitialChars.size()];
    n /= validInitialChars.size();
    // `m` is the number of `state` counts each of the `n` represents.
    size_t m = validInitialChars.size();
    while (n) {
      if (n % (validLaterChars.size() + 1) == 0) {
        // Skip states that contain zeros in later positions.
        state += m;
        ++n;
      }
      ss << validLaterChars[(n % (validLaterChars.size() + 1)) - 1];
      n /= (validLaterChars.size() + 1);
      m *= (validLaterChars.size() + 1);
    }
    name = ss.str();
  } while (reserved.contains(name));
  return name;
}

static bool isIdChar(char ch) {
  return (ch >= '0' && ch <= '9') || (ch >= 'A' && ch <= 'Z') ||
         (ch >= 'a' && ch <= 'z') || ch == '!' || ch == '#' || ch == '$' ||
         ch == '%' || ch == '&' || ch == '\'' || ch == '*' || ch == '+' ||
         ch == '-' || ch == '.' || ch == '/' || ch == ':' || ch == '<' ||
         ch == '=' || ch == '>' || ch == '?' || ch == '@' || ch == '^' ||
         ch == '_' || ch == '`' || ch == '|' || ch == '~';
}

static char formatNibble(int nibble) {
  return nibble < 10 ? '0' + nibble : 'a' - 10 + nibble;
}

Name escape(Name name) {
  bool allIdChars = true;
  for (char c : name.view()) {
    if (!(allIdChars = isIdChar(c))) {
      break;
    }
  }
  if (allIdChars) {
    return name;
  }
  // encode name, if at least one non-idchar (per WebAssembly spec) was found
  std::string escaped;
  for (char c : name.view()) {
    if (isIdChar(c)) {
      escaped.push_back(c);
      continue;
    }
    // replace non-idchar with `\xx` escape
    escaped.push_back('\\');
    escaped.push_back(formatNibble((unsigned char)c >> 4));
    escaped.push_back(formatNibble((unsigned char)c & 15));
  }
  return escaped;
}

// TODO: consolidate this with other string parsing code in string.cpp and
// lexer.h.
std::string unescape(Name name) {
  std::string output;
  std::string_view input = name.view();
  for (size_t i = 0; i < input.length(); i++) {
    if ((input[i] == '\\') && (i + 2 < input.length()) &&
        isxdigit(input[i + 1]) && isxdigit(input[i + 2])) {
      std::string byte = std::string(input.substr(i + 1, 2));
      i += 2;
      char chr = (char)(int)strtol(byte.c_str(), nullptr, 16);
      output.push_back(chr);
    } else {
      output.push_back(input[i]);
    }
  }
  return output;
}

} // namespace wasm::Names
