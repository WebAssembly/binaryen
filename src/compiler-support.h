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

// Forces symbols to be exported from libbinaryen dynamic library. Currently
// we are just using the default flags, causing most of our symbols to have
// "default" visibility, meaning they can all be used from the tool sources.
// However a recent libc++ change caused functions declared in namespace std
// (e.g. hash template specializations) to have hidden visibility. So this
// macro forces them to be exported. In the future if we want to compile
// libbinaryen with -fvisibility-hidden or use a DLL on Windows, we'll need
// to explicitly annotate everything we want to export. But that's probably
// only useful if we want external users to link against libbinaryen.so
// (currently we don't; it's only used to reduce our install size).
#if defined(__ELF__) || defined(__MACH__)
#define DLLEXPORT [[gnu::visibility("default")]]
#else
#define DLLEXPORT
#endif

#endif // wasm_compiler_support_h
