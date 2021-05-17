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
// File helpers.
//

#ifndef wasm_support_file_h
#define wasm_support_file_h

#include <fstream>
#include <string>
#include <utility>
#include <vector>

namespace wasm {

namespace Flags {
enum BinaryOption { Binary, Text };
} // namespace Flags

std::vector<char> read_stdin();

template<typename T>
T read_file(const std::string& filename, Flags::BinaryOption binary);

// Declare the valid explicit specializations.
extern template std::string read_file<>(const std::string&,
                                        Flags::BinaryOption);
extern template std::vector<char> read_file<>(const std::string&,
                                              Flags::BinaryOption);

// Given a string which may be a response file (i.e., a filename starting
// with "@"), if it is a response file read it and return that, or if it
// is not a response file, return it as is.
std::string read_possible_response_file(const std::string&);

class Output {
public:
  // An empty filename or "-" will open stdout instead.
  Output(const std::string& filename, Flags::BinaryOption binary);
  ~Output() = default;
  template<typename T> std::ostream& operator<<(const T& v) { return out << v; }

  std::ostream& getStream() { return out; }

  std::ostream& write(const char* s, std::streamsize c) {
    return out.write(s, c);
  }

private:
  Output() = delete;
  Output(const Output&) = delete;
  Output& operator=(const Output&) = delete;
  std::ofstream outfile;
  std::ostream out;
};

// Copies a file to another file
void copy_file(std::string input, std::string output);

// Retusn the size of a file
size_t file_size(std::string filename);

} // namespace wasm

#endif // wasm_support_file_h
