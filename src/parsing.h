
#include "wasm.h"
#include "shared-constants.h"
#include "mixed_arena.h"

namespace wasm {

Expression* parseConst(cashew::IString s, WasmType type, MixedArena& allocator) {
  const char *str = s.str;
  auto ret = allocator.alloc<Const>();
  ret->type = ret->value.type = type;
  if (isWasmTypeFloat(type)) {
    if (s == INFINITY_) {
      switch (type) {
        case f32: ret->value.f32 = std::numeric_limits<float>::infinity(); break;
        case f64: ret->value.f64 = std::numeric_limits<double>::infinity(); break;
        default: return nullptr;
      }
      //std::cerr << "make constant " << str << " ==> " << ret->value << '\n';
      return ret;
    }
    if (s == NEG_INFINITY) {
      switch (type) {
        case f32: ret->value.f32 = -std::numeric_limits<float>::infinity(); break;
        case f64: ret->value.f64 = -std::numeric_limits<double>::infinity(); break;
        default: return nullptr;
      }
      //std::cerr << "make constant " << str << " ==> " << ret->value << '\n';
      return ret;
    }
    if (s == NAN_) {
      switch (type) {
        case f32: ret->value.f32 = std::nan(""); break;
        case f64: ret->value.f64 = std::nan(""); break;
        default: return nullptr;
      }
      //std::cerr << "make constant " << str << " ==> " << ret->value << '\n';
      return ret;
    }
    bool negative = str[0] == '-';
    const char *positive = negative ? str + 1 : str;
    if (positive[0] == '+') positive++;
    if (positive[0] == 'n' && positive[1] == 'a' && positive[2] == 'n') {
      const char * modifier = positive[3] == ':' ? positive + 4 : nullptr;
      assert(modifier ? positive[4] == '0' && positive[5] == 'x' : 1);
      switch (type) {
        case f32: {
          union {
            uint32_t pattern;
            float f;
          } u;
          if (modifier) {
            std::istringstream istr(modifier);
            istr >> std::hex >> u.pattern;
            u.pattern |= 0x7f800000;
          } else {
            u.pattern = 0x7fc00000;
          }
          if (negative) u.pattern |= 0x80000000;
          if (!isnan(u.f)) u.pattern |= 1;
          assert(isnan(u.f));
          ret->value.f32 = u.f;
          break;
        }
        case f64: {
          union {
            uint64_t pattern;
            double d;
          } u;
          if (modifier) {
            std::istringstream istr(modifier);
            istr >> std::hex >> u.pattern;
            u.pattern |= 0x7ff0000000000000LL;
          } else {
            u.pattern = 0x7ff8000000000000L;
          }
          if (negative) u.pattern |= 0x8000000000000000LL;
          if (!isnan(u.d)) u.pattern |= 1;
          assert(isnan(u.d));
          ret->value.f64 = u.d;
          break;
        }
        default: return nullptr;
      }
      //std::cerr << "make constant " << str << " ==> " << ret->value << '\n';
      return ret;
    }
    if (s == NEG_NAN) {
      switch (type) {
        case f32: ret->value.f32 = -std::nan(""); break;
        case f64: ret->value.f64 = -std::nan(""); break;
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
        ret->value.i32 = negative ? -temp : temp;
      } else {
        std::istringstream istr(str);
        int32_t temp;
        istr >> temp;
        ret->value.i32 = temp;
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
        ret->value.i64 = negative ? -temp : temp;
      } else {
        std::istringstream istr(str);
        int64_t temp;
        istr >> temp;
        ret->value.i64 = temp;
      }
      break;
    }
    case f32: {
      char *end;
      ret->value.f32 = strtof(str, &end);
      assert(!isnan(ret->value.f32));
      break;
    }
    case f64: {
      char *end;
      ret->value.f64 = strtod(str, &end);
      assert(!isnan(ret->value.f64));
      break;
    }
    default: return nullptr;
  }
  //std::cerr << "make constant " << str << " ==> " << ret->value << '\n';
  return ret;
}


} // namespace wasm

