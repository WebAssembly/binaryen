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

#ifndef wasm_compiler_support_h
#define wasm_compiler_support_h

#ifndef __has_feature
#define __has_feature(x) 0
#endif

#ifndef __has_builtin
#define __has_builtin(x) 0
#endif

#if __has_builtin(__builtin_unreachable)
#define WASM_BUILTIN_UNREACHABLE __builtin_unreachable()
#elif defined(_MSC_VER)
#define WASM_BUILTIN_UNREACHABLE __assume(false)
#endif

#if __has_builtin(__builtin_expect)
#define WASM_LIKELY(x) __builtin_expect((bool)(x), true)
#define WASM_UNLIKELY(x) __builtin_expect((bool)(x), false)
#else
#define LLVM_LIKELY(x) (x)
#define LLVM_UNLIKELY(x) (x)
#endif

#ifdef __GNUC__
#define WASM_NORETURN __attribute__((noreturn))
#define WASM_ALWAYS_INLINE __attribute__((always_inline)) inline
#elif defined(_MSC_VER)
#define WASM_NORETURN __declspec(noreturn)
#define WASM_ALWAYS_INLINE __forceinline
#else
#define WASM_NORETURN
#define WASM_ALWAYS_INLINE
#endif

// The code might contain TODOs or stubs that read some values but do nothing
// with them. The compiler might fail with [-Werror,-Wunused-variable].
// The WASM_UNUSED(varible) is a wrapper that helps to suppress the error.
#define WASM_UNUSED(expr)                                                      \
  do {                                                                         \
    if (sizeof expr) {                                                         \
      (void)0;                                                                 \
    }                                                                          \
  } while (0)

#endif // wasm_compiler_support_h
