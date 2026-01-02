/*
 * Copyright 2025 WebAssembly Community Group participants
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

// Trivial wrappers to annotate the nullability of pointers.

#ifndef _wasm_support_nullability
#define _wasm_support_nullability

#include <memory>
#include <type_traits>

namespace wasm::nullability {

template<typename T, typename = void> struct is_pointer : std::false_type {};

template<typename T>
struct is_pointer<T, std::void_t<typename std::pointer_traits<T>::element_type>>
  : std::true_type {};

template<typename T> using Nullable = std::enable_if_t<is_pointer<T>::value, T>;

template<typename T> using NonNull = std::enable_if_t<is_pointer<T>::value, T>;

} // namespace wasm::nullability

#endif // _wasm_support_nullability
