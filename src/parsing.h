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

#include <cmath>
#include <ostream>
#include <sstream>
#include <string>

#include "shared-constants.h"
#include "asmjs/shared-constants.h"
#include "mixed_arena.h"
#include "support/colors.h"
#include "support/utilities.h"
#include "wasm.h"
#include "wasm-printing.h"

namespace wasm {

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

struct MapParseException {
  std::string text;

  MapParseException() : text("unknown parse error") {}
  MapParseException(std::string text) : text(text) {}

  void dump(std::ostream& o) {
    Colors::magenta(o);
    o << "[";
    Colors::red(o);
    o << "map parse exception: ";
    Colors::green(o);
    o << text;
    Colors::magenta(o);
    o << "]";
    Colors::normal(o);
  }
};

inline Expression* parseConst(cashew::IString s, Type type, MixedArena& allocator) {
  const char *str = s.str;
  auto ret = allocator.alloc<Const>();
  ret->type = type;
  if (isFloatType(type)) {
    if (s == _INFINITY) {
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
    if (s == _NAN) {
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
      if (!(modifier ? positive[4] == '0' && positive[5] == 'x' : 1)) {
        throw ParseException("bad nan input");
      }
      switch (type) {
        case f32: {
          uint32_t pattern;
          if (modifier) {
            std::istringstream istr(modifier);
            istr >> std::hex >> pattern;
            if (istr.fail()) throw ParseException("invalid f32 format");
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
            if (istr.fail()) throw ParseException("invalid f64 format");
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
        if (istr.fail()) throw ParseException("invalid i32 format");
        ret->value = Literal(negative ? -temp : temp);
      } else {
        std::istringstream istr(str[0] == '-' ? str + 1 : str);
        uint32_t temp;
        istr >> temp;
        if (istr.fail()) throw ParseException("invalid i32 format");
        ret->value = Literal(str[0] == '-' ? -temp : temp);
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
        if (istr.fail()) throw ParseException("invalid i64 format");
        ret->value = Literal(negative ? -temp : temp);
      } else {
        std::istringstream istr(str[0] == '-' ? str + 1 : str);
        uint64_t temp;
        istr >> temp;
        if (istr.fail()) throw ParseException("invalid i64 format");
        ret->value = Literal(str[0] == '-' ? -temp : temp);
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
  if (ret->value.type != type) {
    throw ParseException("parsed type does not match expected type");
  }
  //std::cerr << "make constant " << str << " ==> " << ret->value << '\n';
  return ret;
}

// Helper for parsers that may not have unique label names. This transforms
// the names into unique ones, as required by Binaryen IR.
struct UniqueNameMapper {
  std::vector<Name> labelStack;
  std::map<Name, std::vector<Name>> labelMappings; // name in source => stack of uniquified names
  std::map<Name, Name> reverseLabelMapping; // uniquified name => name in source

  Index otherIndex = 0;

  Name getPrefixedName(Name prefix) {
    if (reverseLabelMapping.find(prefix) == reverseLabelMapping.end()) return prefix;
    // make sure to return a unique name not already on the stack
    while (1) {
      Name ret = Name(prefix.str + std::to_string(otherIndex++));
      if (reverseLabelMapping.find(ret) == reverseLabelMapping.end()) return ret;
    }
  }

  // receives a source name. generates a unique name, pushes it, and returns it
  Name pushLabelName(Name sName) {
    Name name = getPrefixedName(sName);
    labelStack.push_back(name);
    labelMappings[sName].push_back(name);
    reverseLabelMapping[name] = sName;
    return name;
  }

  void popLabelName(Name name) {
    assert(labelStack.back() == name);
    labelStack.pop_back();
    labelMappings[reverseLabelMapping[name]].pop_back();
  }

  Name sourceToUnique(Name sName) {
    if (labelMappings.find(sName) == labelMappings.end()) {
      throw ParseException("bad label in sourceToUnique");
    }
    if (labelMappings[sName].empty()) {
      throw ParseException("use of popped label in sourceToUnique");
    }
    return labelMappings[sName].back();
  }

  Name uniqueToSource(Name name) {
    if (reverseLabelMapping.find(name) == reverseLabelMapping.end()) {
      throw ParseException("label mismatch in uniqueToSource");
    }
    return reverseLabelMapping[name];
  }

  void clear() {
    labelStack.clear();
    labelMappings.clear();
    reverseLabelMapping.clear();
  }

  // Given an expression, ensures all names are unique
  static void uniquify(Expression* curr) {
    struct Walker : public ControlFlowWalker<Walker, Visitor<Walker>> {
      UniqueNameMapper mapper;

      static void doPreVisitControlFlow(Walker* self, Expression** currp) {
        auto* curr = *currp;
        if (auto* block = curr->dynCast<Block>()) {
          if (block->name.is()) block->name = self->mapper.pushLabelName(block->name);
        } else if (auto* loop = curr->dynCast<Loop>()) {
          if (loop->name.is()) loop->name = self->mapper.pushLabelName(loop->name);
        }
      }
      static void doPostVisitControlFlow(Walker* self, Expression** currp) {
        auto* curr = *currp;
        if (auto* block = curr->dynCast<Block>()) {
          if (block->name.is()) self->mapper.popLabelName(block->name);
        } else if (auto* loop = curr->dynCast<Loop>()) {
          if (loop->name.is()) self->mapper.popLabelName(loop->name);
        }
      }

      void visitBreak(Break *curr) {
        curr->name = mapper.sourceToUnique(curr->name);
      }
      void visitSwitch(Switch *curr) {
        for (auto& target : curr->targets) {
          target = mapper.sourceToUnique(target);
        }
        curr->default_ = mapper.sourceToUnique(curr->default_);
      }
    };

    Walker walker;
    walker.walk(curr);
  }
};

} // namespace wasm

#endif // wasm_parsing_h
