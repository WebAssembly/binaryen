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

#include <assert.h>
#include "asmjs/asmangle.h"

std::string asmangle(std::string name) {
  bool mightBeKeyword = true;

  // Names cannot be empty
  if (!name.length()) {
    assert(false && "Name must not be empty");
    name = "$$";
    mightBeKeyword = false;

  // Names must start with a character, $ or _
  } else {
    switch (auto ch = name[0]) {
      case '$':
      case '_':
        mightBeKeyword = false;
        break;
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
        name = "$" + name;
        mightBeKeyword = false;
        break;
      default:
        if (
          !(ch >= 'a' && ch <= 'z') &&
          !(ch >= 'A' && ch <= 'Z')
        ) {
          name = "$" + name.substr(1);
          mightBeKeyword = false;
        }
    }
  }

  // Names must contain only characters, digits, $ or _
  for (size_t i = 1, k = name.length(); i < k; ++i) {
    switch (auto ch = name[i]) {
      case '$':
      case '_':
        mightBeKeyword = false;
        break;
      default:
        if (
          !(ch >= 'a' && ch <= 'z') &&
          !(ch >= 'A' && ch <= 'Z') &&
          !(ch >= '0' && ch <= '9')
        ) {
          name = name.substr(0, i) + "_" + name.substr(i + 1);
          mightBeKeyword = false;
        }
    }
  }

  // Names must not collide with keywords
  auto len = name.length();
  if (mightBeKeyword && len >= 2 && len <= 10) {
    switch (name[0]) {
      case 'a':
        if (name == "arguments") {
          goto mangle;
        }
        break;
      case 'b':
        if (name == "break") {
          goto mangle;
        }
        break;
      case 'c':
        if (
          name == "case" ||
          name == "continue" ||
          name == "catch" ||
          name == "const" ||
          name == "class"
        ) {
          goto mangle;
        }
        break;
      case 'd':
        if (
          name == "do" ||
          name == "default" ||
          name == "debugger"
        ) {
          goto mangle;
        }
        break;
      case 'e':
        if (
          name == "else" ||
          name == "enum" ||
          name == "eval" || // to be sure
          name == "export" ||
          name == "extends"
        ) {
          goto mangle;
        }
        break;
      case 'f':
        if (
          name == "for" ||
          name == "false" ||
          name == "finally" ||
          name == "function"
        ) {
          goto mangle;
        }
        break;
      case 'i':
        if (
          name == "if" ||
          name == "in" ||
          name == "import" ||
          name == "interface" ||
          name == "implements" ||
          name == "instanceof"
        ) {
          goto mangle;
        }
        break;
      case 'l':
        if (name == "let") {
          goto mangle;
        }
        break;
      case 'n':
        if (
          name == "new" ||
          name == "null"
        ) {
          goto mangle;
        }
        break;
      case 'p':
        if (
          name == "public" ||
          name == "package" ||
          name == "private" ||
          name == "protected"
        ) {
          goto mangle;
        }
        break;
      case 'r':
        if (name == "return") {
          goto mangle;
        }
        break;
      case 's':
        if (
          name == "super" ||
          name == "static" ||
          name == "switch"
        ) {
          goto mangle;
        }
        break;
      case 't':
        if (
          name == "try" ||
          name == "this" ||
          name == "true" ||
          name == "throw" ||
          name == "typeof"
        ) {
          goto mangle;
        }
        break;
      case 'v':
        if (
          name == "var" ||
          name == "void"
        ) {
          goto mangle;
        }
        break;
      case 'w':
        if (
          name == "with" ||
          name == "while"
        ) {
          goto mangle;
        }
        break;
      case 'y':
        if (name == "yield") {
          goto mangle;
        }
        break;
      mangle:
        name = name + "_";
    }
  }
  return name;
}
