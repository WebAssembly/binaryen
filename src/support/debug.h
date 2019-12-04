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

// Implements BYN_DEBUG macro similar to llvm's include/llvm/Support/Debug.h,
// which can include any code, and in addition and printf-file BYN_TRACE.
//
// To use these macros you must define DEBUG_TYPE to a C string within your
// source code which then acts as the name of a channel which can be
// individually enabled via --debug=<chan>.  Specifying --debug without any
// argument enables all channels.

#ifndef wasm_support_debug_h
#define wasm_support_debug_h

#ifndef NDEBUG

namespace wasm {
bool isDebugEnabled(const char* type);
void setDebugEnabled(const char* types);
} // namespace wasm

#define BYN_DEBUG_WITH_TYPE(TYPE, X)                                           \
  do {                                                                         \
    if (::wasm::isDebugEnabled(TYPE)) {                                        \
      X;                                                                       \
    }                                                                          \
  } while (false)

#define BYN_TRACE_WITH_TYPE(TYPE, MSG)                                         \
  BYN_DEBUG_WITH_TYPE(TYPE, std::cerr << MSG);

#else

#define BYN_DEBUG_WITH_TYPE(...)                                               \
  do {                                                                         \
  } while (false)
#define BYN_TRACE_WITH_TYPE(...)                                               \
  do {                                                                         \
  } while (false)
#define isDebugEnabled(type) (false)
#define setDebugEnabled(types)

#endif

#define BYN_DEBUG(X) BYN_DEBUG_WITH_TYPE(DEBUG_TYPE, X)
#define BYN_TRACE(MSG) BYN_TRACE_WITH_TYPE(DEBUG_TYPE, MSG)

#endif // wasm_support_debug_h
