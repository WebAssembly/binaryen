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

//
// Utility classes for reading and writing LEB values
//

#include "parsing.h"

#ifndef wasm_wasm_leb_h
#define wasm_wasm_leb_h

namespace wasm {

template<typename T, typename MiniT>
struct LEB {
  static_assert(sizeof(MiniT) == 1, "MiniT must be a byte");

  T value;

  LEB() = default;
  LEB(T value) : value(value) {}

  bool hasMore(T temp, MiniT byte) {
    // for signed, we must ensure the last bit has the right sign, as it will zero extend
    return std::is_signed<T>::value ? (temp != 0 && temp != T(-1)) || (value >= 0 && (byte & 64)) || (value < 0 && !(byte & 64)) : (temp != 0);
  }

  void write(std::vector<uint8_t>* out) {
    T temp = value;
    bool more;
    do {
      uint8_t byte = temp & 127;
      temp >>= 7;
      more = hasMore(temp, byte);
      if (more) {
        byte = byte | 128;
      }
      out->push_back(byte);
    } while (more);
  }

  // @minimum: a minimum number of bytes to write, padding as necessary
  // returns the number of bytes written
  size_t writeAt(std::vector<uint8_t>* out, size_t at, size_t minimum = 0) {
    T temp = value;
    size_t offset = 0;
    bool more;
    do {
      uint8_t byte = temp & 127;
      temp >>= 7;
      more = hasMore(temp, byte) || offset + 1 < minimum;
      if (more) {
        byte = byte | 128;
      }
      (*out)[at + offset] = byte;
      offset++;
    } while (more);
    return offset;
  }

  LEB<T, MiniT>& read(std::function<MiniT()> get) {
    value = 0;
    T shift = 0;
    MiniT byte;
    while (1) {
      byte = get();
      bool last = !(byte & 128);
      T payload = byte & 127;
      typedef typename std::make_unsigned<T>::type mask_type;
      auto shift_mask = 0 == shift
                            ? ~mask_type(0)
                            : ((mask_type(1) << (sizeof(T) * 8 - shift)) - 1u);
      T significant_payload = payload & shift_mask;
      if (significant_payload != payload) {
        if (!(std::is_signed<T>::value && last)) {
          throw ParseException("LEB dropped bits only valid for signed LEB");
        }
      }
      value |= significant_payload << shift;
      if (last) break;
      shift += 7;
      if (size_t(shift) >= sizeof(T) * 8) {
        throw ParseException("LEB overflow");
      }
    }
    // If signed LEB, then we might need to sign-extend. (compile should
    // optimize this out if not needed).
    if (std::is_signed<T>::value) {
      shift += 7;
      if ((byte & 64) && size_t(shift) < 8 * sizeof(T)) {
        size_t sext_bits = 8 * sizeof(T) - size_t(shift);
        value <<= sext_bits;
        value >>= sext_bits;
        if (value >= 0) {
          throw ParseException(" LEBsign-extend should produce a negative value");
        }
      }
    }
    return *this;
  }
};

typedef LEB<uint32_t, uint8_t> U32LEB;
typedef LEB<uint64_t, uint8_t> U64LEB;
typedef LEB<int32_t, int8_t> S32LEB;
typedef LEB<int64_t, int8_t> S64LEB;

}; // namespace wasm

#endif // wasm_wasm_leb_h
