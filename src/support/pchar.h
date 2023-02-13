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
// The platform char / string type.
//
// Used entirely for managing unicode-correct paths on windows.
//

#ifndef wasm_support_pchar_h
#define wasm_support_pchar_h

#include <filesystem>

namespace wasm {

// The platform string type.
//
// basic_string<wchar_t> on Windows, basic_string<char> elsewhere
typedef std::filesystem::path::string_type pstring;
typedef std::filesystem::path::value_type pchar;

// Conversion from string to pstring.
//
// On windows this performs a UTF-8 to UTF-16 conversion, on the assumption that
// the incoming string was previously created through pstring_to_string.
//
// If a non-UTF-8 string is passed as input, then the output will contain
// replacement characters.
//
// On non-windows this just copies the string..
pstring string_to_pstring(const std::string& s);

// Conversion from pstring to string.
//
// On windows this performs a UTF-16 to UTF-8 conversion, on the assumption that
// the pstring was received from the wmain function as UTF-16.
//
// If a non-UTF-16 string is passed as input, then the output will contain
// replacement characters.
//
// On non-windows this just copies the string.
std::string pstring_to_string(const pstring& s);

// A light wrapper around std::filesystem::path
//
// This class only exists to avoid silent errors: the copy constructor performs
// conversion from UTF-8 on windows where the std::filesystem::path constructor
// silently does not.
//
// Using this in APIs instead of std::filesystem::path allows paths to be
// seamlessly and correctly constructed from strings without the possibility of
// silently forgetting a conversion from UTF-8.
//
// The above is true as long as all paths encoded as strings are UTF-8, which is
// true on windows if all CLI arguments are processed through the Options::parse
// method.
class fspath {
public:
  fspath(): inner_path() { }
  fspath(const std::string& path);
  fspath(const char path[]);
  fspath(const wasm::fspath& path);

  // This exists to satisfy one conversion in read_possible_response_file.
  //
  // We can't have a constructor from pstring - on windows pstring
  // and string are the same type.
  //
  // We could also make the private constructor from filesystem::path public,
  // and the compiler would use it as an implicit conversion from pstring; but
  // because filesystem::path also has a lossy conversion from string that
  // motivates the existence of this class, we choose to hide that conversion
  // and use this explicit static method.
  static wasm::fspath from_pstring(const wasm::pstring& path);

  wasm::fspath operator=(const wasm::fspath& path) const;

  const std::filesystem::path& stdpath() const;

private:
  fspath(const std::filesystem::path& path);

  std::filesystem::path inner_path;
};
  
} // namespace wasm

#endif // wasm_support_pchar_h
