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

#ifndef wasm_parsing_h
#define wasm_parsing_h

#include <ostream>
#include <sstream>
#include <string>

#include "asmjs/shared-constants.h"
#include "mixed_arena.h"
#include "support/utilities.h"
#include "wasm.h"
#include "wasm-printing.h"

namespace wasm {

inline Expression* parseConst(cashew::IString s, WasmType type, MixedArena& allocator) {
  const char *str = s.str;
  auto ret = allocator.alloc<Const>();
  ret->type = type;
  if (isWasmTypeFloat(type)) {
    if (s == INFINITY_) {
      switch (type) {
        case f32: ret->value = Literal(std::numeric_limits<float>::infinity()); break;
        case f64: ret->value = Literal(std::numeric_limits<double>::infinity()); break;
        default: return nullptr;
      }
      //std::cerr << "make constant " << str << " ==> " << ret->value << '\n';
      return ret;
    }
    if (s == NEG_INFINITY) {
      switch (type) {
        case f32: ret->value = Literal(-std::numeric_limits<float>::infinity()); break;
        case f64: ret->value = Literal(-std::numeric_limits<double>::infinity()); break;
        default: return nullptr;
      }
      //std::cerr << "make constant " << str << " ==> " << ret->value << '\n';
      return ret;
    }
    if (s == NAN_) {
      switch (type) {
        case f32: ret->value = Literal(float(std::nan(""))); break;
        case f64: ret->value = Literal(double(std::nan(""))); break;
        default: return nullptr;
      }
      //std::cerr << "make constant " << str << " ==> " << ret->value << '\n';
      return ret;
    }
    bool negative = str[0] == '-';
    const char *positive = negative ? str + 1 : str;
    if (!negative) {
      if (positive[0] == '+') {
        positive++;
      }
    }
    if (positive[0] == 'n' && positive[1] == 'a' && positive[2] == 'n') {
      const char * modifier = positive[3] == ':' ? positive + 4 : nullptr;
      assert(modifier ? positive[4] == '0' && positive[5] == 'x' : 1);
      switch (type) {
        case f32: {
          uint32_t pattern;
          if (modifier) {
            std::istringstream istr(modifier);
            istr >> std::hex >> pattern;
            pattern |= 0x7f800000U;
          } else {
            pattern = 0x7fc00000U;
          }
          if (negative) pattern |= 0x80000000U;
          if (!std::isnan(bit_cast<float>(pattern))) pattern |= 1U;
          ret->value = Literal(pattern).castToF32();
          break;
        }
        case f64: {
          uint64_t pattern;
          if (modifier) {
            std::istringstream istr(modifier);
            istr >> std::hex >> pattern;
            pattern |= 0x7ff0000000000000ULL;
          } else {
            pattern = 0x7ff8000000000000UL;
          }
          if (negative) pattern |= 0x8000000000000000ULL;
          if (!std::isnan(bit_cast<double>(pattern))) pattern |= 1ULL;
          ret->value = Literal(pattern).castToF64();
          break;
        }
        default: return nullptr;
      }
      //std::cerr << "make constant " << str << " ==> " << ret->value << '\n';
      return ret;
    }
    if (s == NEG_NAN) {
      switch (type) {
        case f32: ret->value = Literal(float(-std::nan(""))); break;
        case f64: ret->value = Literal(double(-std::nan(""))); break;
        default: return nullptr;
      }
      //std::cerr << "make constant " << str << " ==> " << ret->value << '\n';
      return ret;
    }
  }
  switch (type) {
    case i32: {
      if ((str[0] == '0' && str[1] == 'x') || (str[0] == '-' && str[1] == '0' && str[2] == 'x')) {
        bool negative = str[0] == '-';
        if (negative) str++;
        std::istringstream istr(str);
        uint32_t temp;
        istr >> std::hex >> temp;
        ret->value = Literal(negative ? -temp : temp);
      } else {
        std::istringstream istr(str);
        int32_t temp;
        istr >> temp;
        ret->value = Literal(temp);
      }
      break;
    }
    case i64: {
      if ((str[0] == '0' && str[1] == 'x') || (str[0] == '-' && str[1] == '0' && str[2] == 'x')) {
        bool negative = str[0] == '-';
        if (negative) str++;
        std::istringstream istr(str);
        uint64_t temp;
        istr >> std::hex >> temp;
        ret->value = Literal(negative ? -temp : temp);
      } else {
        std::istringstream istr(str);
        int64_t temp;
        istr >> temp;
        ret->value = Literal(temp);
      }
      break;
    }
    case f32: {
      char *end;
      ret->value = Literal(strtof(str, &end));
      break;
    }
    case f64: {
      char *end;
      ret->value = Literal(strtod(str, &end));
      break;
    }
    default: return nullptr;
  }
  assert(ret->value.type == type);
  //std::cerr << "make constant " << str << " ==> " << ret->value << '\n';
  return ret;
}

struct ParseException {
  std::string text;
  size_t line, col;

  ParseException() : text("unknown parse error"), line(-1), col(-1) {}
  ParseException(std::string text) : text(text), line(-1), col(-1) {}
  ParseException(std::string text, size_t line, size_t col) : text(text), line(line), col(col) {}

  void dump(std::ostream& o) {
    Colors::magenta(o);
    o << "[";
    Colors::red(o);
    o << "parse exception: ";
    Colors::green(o);
    o << text;
    if (line != size_t(-1)) {
      Colors::normal(o);
      o << " (at " << line << ":" << col << ")";
    }
    Colors::magenta(o);
    o << "]";
    Colors::normal(o);
  }
};

} // namespace wasm

#endif // wasm_parsing_h
