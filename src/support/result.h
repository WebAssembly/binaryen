/*
 * Copyright 2023 WebAssembly Community Group participants
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

#ifndef wasm_support_result_h
#define wasm_support_result_h

#include <string>
#include <variant>

namespace wasm {

// Represents a non-erroneous result with no associated data.
struct Ok {};

// Represents the non-erroneous absence of a result.
struct None {};

// Represents an erroneous result with associated error message.
struct Err {
  std::string msg;
};

// Check a Result or MaybeResult for error and return the error if it exists.
#define CHECK_ERR(val)                                                         \
  if (auto _val = (val); auto err = _val.getErr()) {                           \
    return Err{*err};                                                          \
  }

// Represent a result of type T or an error message.
template<typename T = Ok> struct Result {
  std::variant<T, Err> val;

  Result(Result<T>& other) = default;
  Result(Result<T>&& other) = default;
  Result(const Err& e) : val(std::in_place_type<Err>, e) {}
  Result(Err&& e) : val(std::in_place_type<Err>, std::move(e)) {}
  template<typename U = T>
  Result(U&& u) : val(std::in_place_type<T>, std::forward<U>(u)) {}

  Err* getErr() { return std::get_if<Err>(&val); }
  T& operator*() { return *std::get_if<T>(&val); }
  T* operator->() { return std::get_if<T>(&val); }
};

// Represent an optional result of type T or an error message.
template<typename T = Ok> struct MaybeResult {
  std::variant<T, None, Err> val;

  MaybeResult() : val(None{}) {}
  MaybeResult(MaybeResult<T>& other) = default;
  MaybeResult(MaybeResult<T>&& other) = default;
  MaybeResult(const Err& e) : val(std::in_place_type<Err>, e) {}
  MaybeResult(Err&& e) : val(std::in_place_type<Err>, std::move(e)) {}
  template<typename U = T>
  MaybeResult(U&& u) : val(std::in_place_type<T>, std::forward<U>(u)) {}
  template<typename U = T>
  MaybeResult(Result<U>&& u)
    : val(u.getErr() ? std::variant<T, None, Err>{*u.getErr()}
                     : std::variant<T, None, Err>{*u}) {}

  // Whether we have an error or a value. Useful for assignment in loops and if
  // conditions where errors should not get lost.
  operator bool() const { return !std::holds_alternative<None>(val); }

  MaybeResult<T>& operator=(const MaybeResult<T>&) = default;
  MaybeResult<T>& operator=(MaybeResult<T>&&) = default;

  Err* getErr() { return std::get_if<Err>(&val); }
  T& operator*() { return *std::get_if<T>(&val); }
  T* operator->() { return std::get_if<T>(&val); }

  T* getPtr() { return std::get_if<T>(&val); }
};

} // namespace wasm

#endif // wasm_support_result_h
