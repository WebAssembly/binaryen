/*
 * Copyright 2024 WebAssembly Community Group participants
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

#ifndef wasm_stdckdint_h
#define wasm_stdckdint_h

// This is a partial "polyfill" for the C23 file stdckdint.h. It allows us to
// use that API even in older compilers.

namespace std {

template<typename T> bool ckd_add(T* output, T a, T b) {
#if __has_builtin(__builtin_add_overflow)
  return __builtin_add_overflow(a, b, output);
#else
  // Atm this polyfill only supports unsigned types.
  static_assert(std::is_unsigned_v<T>);

  T result = a + b;
  if (result < a) {
    return true;
  }
  *output = result;
  return false;
#endif
}

} // namespace std

#endif // wasm_stdckdint_h
