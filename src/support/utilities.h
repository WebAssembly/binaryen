/*
 * Copyright 2016 WebAssembly Community Group participants
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

#ifndef wasm_support_utilities_h
#define wasm_support_utilities_h

#include "compiler-support.h"

#include <cassert>
#include <cstdint>
#include <cstring>
#include <iostream>
#include <memory>
#include <sstream>
#include <type_traits>

#include "support/bits.h"

namespace wasm {

// Type punning needs to be done through this function to avoid undefined
// behavior: unions and reinterpret_cast aren't valid approaches.
template<class Destination, class Source>
inline Destination bit_cast(const Source& source) {
  static_assert(sizeof(Destination) == sizeof(Source),
                "bit_cast needs to be between types of the same size");
  static_assert(std::is_trivial_v<Destination> &&
                  std::is_standard_layout_v<Destination>,
                "non-POD bit_cast undefined");
  static_assert(std::is_trivial_v<Source> && std::is_standard_layout_v<Source>,
                "non-POD bit_cast undefined");
  Destination destination;
  std::memcpy(&destination, &source, sizeof(destination));
  return destination;
}

inline size_t alignAddr(size_t address, size_t alignment) {
  assert(alignment && Bits::isPowerOf2((uint32_t)alignment) &&
         "Alignment is not a power of two!");

  assert(address + alignment - 1 >= address);

  return ((address + alignment - 1) & ~(alignment - 1));
}

// For fatal errors which could arise from input (i.e. not assertion failures)
class Fatal {
private:
  std::stringstream buffer;

public:
  Fatal() { buffer << "Fatal: "; }
  template<typename T> Fatal& operator<<(T&& arg) {
    buffer << arg;
    return *this;
  }
#ifndef THROW_ON_FATAL
  [[noreturn]] ~Fatal() {
    std::cerr << buffer.str() << std::endl;
    // Use _Exit here to avoid calling static destructors. This avoids deadlocks
    // in (for example) the thread worker pool, where workers hold a lock while
    // performing their work.
    _Exit(EXIT_FAILURE);
  }
#else
  // This variation is a best-effort attempt to make fatal errors recoverable
  // for embedders of Binaryen as a library, namely wasm-opt-rs.
  //
  // Throwing in destructors is strongly discouraged, since it is easy to
  // accidentally throw during unwinding, which will trigger an abort. Since
  // `Fatal` is a special type that only occurs on error paths, we are hoping it
  // is never constructed during unwinding or while destructing another type.
  [[noreturn]] ~Fatal() noexcept(false) {
    throw std::runtime_error(buffer.str());
  }
#endif
};

[[noreturn]] void handle_unreachable(const char* msg = nullptr,
                                     const char* file = nullptr,
                                     unsigned line = 0);

// If control flow reaches the point of the WASM_UNREACHABLE(), the program is
// undefined.
#ifndef NDEBUG
#define WASM_UNREACHABLE(msg) wasm::handle_unreachable(msg, __FILE__, __LINE__)
#elif defined(WASM_BUILTIN_UNREACHABLE)
#define WASM_UNREACHABLE(msg) WASM_BUILTIN_UNREACHABLE
#else
#define WASM_UNREACHABLE(msg) wasm::handle_unreachable()
#endif

} // namespace wasm

#endif // wasm_support_utilities_h
