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

#ifndef wasm_support_color_h
#define wasm_support_color_h

#include <iosfwd>

namespace Colors {

void setEnabled(bool enabled);
bool isEnabled();

#if defined(__linux__) || defined(__APPLE__)
void outputColorCode(std::ostream& stream, const char* colorCode);
inline void normal(std::ostream& stream) { outputColorCode(stream, "\033[0m"); }
inline void red(std::ostream& stream) { outputColorCode(stream, "\033[31m"); }
inline void magenta(std::ostream& stream) {
  outputColorCode(stream, "\033[35m");
}
inline void orange(std::ostream& stream) {
  outputColorCode(stream, "\033[33m");
}
inline void grey(std::ostream& stream) { outputColorCode(stream, "\033[37m"); }
inline void green(std::ostream& stream) { outputColorCode(stream, "\033[32m"); }
inline void blue(std::ostream& stream) { outputColorCode(stream, "\033[34m"); }
inline void bold(std::ostream& stream) { outputColorCode(stream, "\033[1m"); }
#elif defined(_WIN32)
void outputColorCode(std::ostream& stream, const unsigned short& colorCode);
inline void normal(std::ostream& stream) { outputColorCode(stream, 0x07); }
inline void red(std::ostream& stream) { outputColorCode(stream, 0x0c); }
inline void magenta(std::ostream& stream) { outputColorCode(stream, 0x05); }
inline void orange(std::ostream& stream) { outputColorCode(stream, 0x06); }
inline void grey(std::ostream& stream) { outputColorCode(stream, 0x08); }
inline void green(std::ostream& stream) { outputColorCode(stream, 0x02); }
inline void blue(std::ostream& stream) { outputColorCode(stream, 0x09); }
inline void bold(std::ostream& stream) { /* Do nothing */
}
#else
inline void normal(std::ostream& stream) {}
inline void red(std::ostream& stream) {}
inline void magenta(std::ostream& stream) {}
inline void orange(std::ostream& stream) {}
inline void grey(std::ostream& stream) {}
inline void green(std::ostream& stream) {}
inline void blue(std::ostream& stream) {}
inline void bold(std::ostream& stream) {}
#endif

} // namespace Colors

#endif // wasm_support_color_h
