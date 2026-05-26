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

#ifndef wasm_tools_wasm2c_c_printer_h
#define wasm_tools_wasm2c_c_printer_h

#include <iostream>

namespace wasm {

class CPrinter;
typedef CPrinter& (*CPrinterManipulator)(CPrinter&);

class CPrinter {
public:
  std::ostream& out;
  int indentLevel = 0;
  bool startOfLine = true;

  CPrinter(std::ostream& out) : out(out) {}

  void indent() { indentLevel++; }
  void outdent() { indentLevel--; }

  CPrinter& operator<<(CPrinter& (*pf)(CPrinter&)) { return pf(*this); }

  template<typename T> CPrinter& operator<<(const T& val) {
    if (startOfLine) {
      for (int i = 0; i < indentLevel * 2; i++) {
        out << ' ';
      }
      startOfLine = false;
    }
    out << val;
    return *this;
  }
};

inline CPrinter& endl(CPrinter& p) {
  p.out << '\n';
  p.startOfLine = true;
  return p;
}

} // namespace wasm

#endif // wasm_tools_wasm2c_c_printer_h
