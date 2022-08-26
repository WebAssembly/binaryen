/*
 * Copyright 2019 WebAssembly Community Group participants
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

#include "utilities.h"

#include <cassert>
#include <cstdlib>
#include <iostream>

#if __has_feature(address_sanitizer) || defined(__SANITIZE_ADDRESS__)
#include "sanitizer/common_interface_defs.h"
#endif

[[noreturn]] void
wasm::handle_unreachable(const char* msg, const char* file, unsigned line) {
#ifndef NDEBUG
  if (msg) {
    std::cerr << msg << "\n";
  }
  std::cerr << "UNREACHABLE executed";
  if (file) {
    std::cerr << " at " << file << ":" << line;
  }
  std::cerr << "!\n";
#if __has_feature(address_sanitizer) || defined(__SANITIZE_ADDRESS__)
  __sanitizer_print_stack_trace();
  __builtin_trap();
#endif
#endif
  abort();
}
