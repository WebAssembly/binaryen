/*
 * Copyright 2018 WebAssembly Community Group participants
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

#include "asmjs/asmangle.h"
#include <assert.h>

namespace wasm {

std::string asmangle(std::string name) {
  // Wasm allows empty names as exports etc., but JS doesn't allow such
  // identifiers.
  if (name.empty()) {
    name = "$";
  }

  bool mightBeKeyword = true;
  size_t i = 1;

  assert(!name.empty());

  // Names must start with a character, $ or _
  switch (auto ch = name[0]) {
    case '0':
    case '1':
    case '2':
    case '3':
    case '4':
    case '5':
    case '6':
    case '7':
    case '8':
    case '9': {
      name = "$" + name;
      i = 2;
      goto notKeyword;
    }
    notKeyword:
    case '$':
    case '_': {
      mightBeKeyword = false;
      break;
    }
    default: {
      if (!(ch >= 'a' && ch <= 'z') && !(ch >= 'A' && ch <= 'Z')) {
        name = "$" + name.substr(1);
        mightBeKeyword = false;
      }
    }
  }

  // Names must contain only characters, digits, $ or _
  size_t len = name.length();
  for (; i < len; ++i) {
    switch (char ch = name[i]) {
      case '0':
      case '1':
      case '2':
      case '3':
      case '4':
      case '5':
      case '6':
      case '7':
      case '8':
      case '9':
      case '$':
      case '_': {
        mightBeKeyword = false;
        break;
      }
      default: {
        if (!(ch >= 'a' && ch <= 'z') && !(ch >= 'A' && ch <= 'Z')) {
          name = name.substr(0, i) + "_" + name.substr(i + 1);
          mightBeKeyword = false;
        }
      }
    }
  }

  // Names must not collide with keywords
  if (mightBeKeyword && len >= 2 && len <= 10) {
    switch (name[0]) {
      case 'a': {
        if (name == "arguments") {
          goto mangleKeyword;
        }
        break;
      }
      case 'b': {
        if (name == "break") {
          goto mangleKeyword;
        }
        break;
      }
      case 'c': {
        if (name == "case" || name == "continue" || name == "catch" ||
            name == "const" || name == "class") {
          goto mangleKeyword;
        }
        break;
      }
      case 'd': {
        if (name == "do" || name == "default" || name == "debugger") {
          goto mangleKeyword;
        }
        break;
      }
      case 'e': {
        if (name == "else" || name == "enum" || name == "eval" || // to be sure
            name == "export" || name == "extends") {
          goto mangleKeyword;
        }
        break;
      }
      case 'f': {
        if (name == "for" || name == "false" || name == "finally" ||
            name == "function") {
          goto mangleKeyword;
        }
        break;
      }
      case 'i': {
        if (name == "if" || name == "in" || name == "import" ||
            name == "interface" || name == "implements" ||
            name == "instanceof") {
          goto mangleKeyword;
        }
        break;
      }
      case 'l': {
        if (name == "let") {
          goto mangleKeyword;
        }
        break;
      }
      case 'n': {
        if (name == "new" || name == "null") {
          goto mangleKeyword;
        }
        break;
      }
      case 'p': {
        if (name == "public" || name == "package" || name == "private" ||
            name == "protected") {
          goto mangleKeyword;
        }
        break;
      }
      case 'r': {
        if (name == "return") {
          goto mangleKeyword;
        }
        break;
      }
      case 's': {
        if (name == "super" || name == "static" || name == "switch") {
          goto mangleKeyword;
        }
        break;
      }
      case 't': {
        if (name == "try" || name == "this" || name == "true" ||
            name == "throw" || name == "typeof") {
          goto mangleKeyword;
        }
        break;
      }
      case 'v': {
        if (name == "var" || name == "void") {
          goto mangleKeyword;
        }
        break;
      }
      case 'w': {
        if (name == "with" || name == "while") {
          goto mangleKeyword;
        }
        break;
      }
      case 'y': {
        if (name == "yield") {
          goto mangleKeyword;
        }
        break;
      }
      mangleKeyword : { name = name + "_"; }
    }
  }
  return name;
}

} // namespace wasm
