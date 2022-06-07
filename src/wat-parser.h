/*
 * Copyright 2022 WebAssembly Community Group participants
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

#ifndef wasm_wat_parser_h
#define wasm_wat_parser_h

#include <optional>
#include <string_view>

#include "wasm.h"

namespace wasm::WATParser {

struct Ok {};

// struct None {};

struct Err {
  std::string msg;
};

template<typename T = Ok> struct Result {
  // std::variant<T, None, Err> val;
  std::variant<T, Err> val;

  // Result() : val(None{}) {}
  Result(Err& e) : val(std::in_place_type<Err>, e) {}
  Result(Err&& e) : val(std::in_place_type<Err>, std::move(e)) {}
  template<typename U = T>
  Result(U&& u) : val(std::in_place_type<T>, std::forward<U>(u)) {}

  bool ok() const { return std::holds_alternative<T>(val); }

  // Whether we have an error or a truthy value. Useful for assignment in loops
  // and if conditions where errors should not get lost.
  operator bool() const { return !ok() || bool(*std::get_if<T>(&val)); }

  std::optional<Err> getErr() {
    if (auto* err = std::get_if<Err>(&val)) {
      return *err;
    }
    return {};
  }

  T& operator*() { return *std::get_if<T>(&val); }

  T* operator->() { return std::get_if<T>(&val); }
};

// Parse a single WAT module.
Result<> parseModule(Module& wasm, std::string_view in);

} // namespace wasm::WATParser

#endif // wasm_wat_parser.h
