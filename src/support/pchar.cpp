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

#include "pchar.h"

namespace wasm {

#ifdef _WIN32

#include "windows.h"

// The conversion functions here will always succeed, with invalid chars
// converted to replacement chars. If there are bugs here they should manifest
// in file-not-found errors and not something worse.

wasm::pstring string_to_pstring(const std::string& s) {
  auto inptr = s.data();
  auto inlen = s.size();
  auto outlen = MultiByteToWideChar(CP_UTF8, 0, inptr, inlen, NULL, 0);
  auto outstr = wasm::pstring(outlen, 0);
  auto outptr = outstr.data();
  MultiByteToWideChar(CP_UTF8, 0, inptr, inlen, outptr, outlen);
  return outstr;
}

std::string pstring_to_string(const wasm::pstring& s) {
  auto inptr = s.data();
  auto inlen = s.size();
  auto outlen = WideCharToMultiByte(CP_UTF8, 0, inptr, inlen, NULL, 0, NULL, NULL);
  auto outstr = std::string(outlen, 0);
  auto outptr = outstr.data();
  WideCharToMultiByte(CP_UTF8, 0, inptr, inlen, outptr, outlen, NULL, NULL);
  return outstr;
}

#else

wasm::pstring string_to_pstring(const std::string& s) {
  return wasm::pstring(s);
}

std::string pstring_to_string(const wasm::pstring& s) {
  return std::string(s);
}

#endif

std::filesystem::path string_to_path(const std::string& s) {
  auto pstring = wasm::string_to_pstring(s);
  return std::filesystem::path(pstring);
}

fspath::fspath(const std::string& path) {
  inner_path = string_to_path(path);
}

fspath::fspath(const char path[]) {
  inner_path = string_to_path(std::string(path));
}

fspath::fspath(const wasm::fspath& path) {
  inner_path = path.inner_path;
}

fspath::fspath(const std::filesystem::path& path) {
  inner_path = path;
}

wasm::fspath fspath::from_pstring(const wasm::pstring& path) {
  return fspath(std::filesystem::path(path));
}

wasm::fspath fspath::operator=(const wasm::fspath& path) const {
  return wasm::fspath(path);
}

const std::filesystem::path& fspath::stdpath() const {
  return inner_path;
}

} // namespace wasm
