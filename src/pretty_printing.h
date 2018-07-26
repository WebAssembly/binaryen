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

//
// Pretty printing helpers
//

#ifndef wasm_pretty_printing_h
#define wasm_pretty_printing_h

#include <ostream>

#include "support/colors.h"

inline std::ostream &doIndent(std::ostream &o, unsigned indent) {
  for (unsigned i = 0; i < indent; i++) {
    o << " ";
  }
  return o;
}

inline std::ostream &prepareMajorColor(std::ostream &o) {
  Colors::red(o);
  Colors::bold(o);
  return o;
}

inline std::ostream &prepareColor(std::ostream &o) {
  Colors::magenta(o);
  Colors::bold(o);
  return o;
}

inline std::ostream &prepareMinorColor(std::ostream &o) {
  Colors::orange(o);
  return o;
}

inline std::ostream &restoreNormalColor(std::ostream &o) {
  Colors::normal(o);
  return o;
}

inline std::ostream& printText(std::ostream &o, const char *str) {
  o << '"';
  Colors::green(o);
  o << str;
  Colors::normal(o);
  return o << '"';
}

inline std::ostream& printMajor(std::ostream &o, const char *str, bool major=false) {
  prepareMajorColor(o);
  o << str;
  restoreNormalColor(o);
  return o;
}

inline std::ostream& printMedium(std::ostream &o, const char *str, bool major=false) {
  prepareColor(o);
  o << str;
  restoreNormalColor(o);
  return o;
}

inline std::ostream& printMinor(std::ostream &o, const char *str) {
  prepareMinorColor(o);
  o << str;
  restoreNormalColor(o);
  return o;
}

#endif // wasm_pretty_printing_h
