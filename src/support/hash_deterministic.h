/*
 * Copyright 2020 WebAssembly Community Group participants
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

#ifndef wasm_support_hash_deterministic_h
#define wasm_support_hash_deterministic_h

#include <stdint.h>

// Deterministic hashing based on FNV-1a. Should not be combined with standard
// library hashes in a way that makes it lose its guarantees, but can be used
// to derive a standard library digest if guarantees are no longer required.

namespace wasm {

typedef uint32_t hash32_t;

#define FNV_OFFSET 2166136261
#define FNV_PRIME 16777619

// Appends a partial hash of `value` to the existing digest. Use instead of
// `hash32_combine` if `value` is not another digest.
template<typename T> inline void rehash32(hash32_t& digest, T value);
template<> inline void rehash32(hash32_t& digest, uint8_t value) {
  digest = (digest ^ value) * FNV_PRIME;
}
template<> inline void rehash32(hash32_t& digest, uint16_t value) {
  digest = (digest ^ (value & 0xff)) * FNV_PRIME;
  digest = (digest ^ (value >> 8)) * FNV_PRIME;
}
template<> inline void rehash32(hash32_t& digest, uint32_t value) {
  digest = (digest ^ (value & 0xff)) * FNV_PRIME;
  digest = (digest ^ ((value >> 8) & 0xff)) * FNV_PRIME;
  digest = (digest ^ ((value >> 16) & 0xff)) * FNV_PRIME;
  digest = (digest ^ (value >> 24)) * FNV_PRIME;
}
template<> inline void rehash32(hash32_t& digest, uint64_t value) {
  rehash32(digest, uint32_t(value));
  rehash32(digest, uint32_t(value >> 32));
}
// If you came here due to an error complaining about a missing implementation,
// consider casting the value to the best fitting uint type above.

// Computes a 32-bit digest of `value`.
template<typename T> inline hash32_t hash32(T value) {
  hash32_t digest = FNV_OFFSET;
  rehash32(digest, value);
  return digest;
}

// Begins a new 32-bit digest.
static inline hash32_t hash32() { return FNV_OFFSET; }

// Combines two digests into the first digest. Use instead of `rehash32` if
// `otherDigest` is another digest and not an `uint32_t` value.
static inline void hash32_combine(hash32_t& digest, hash32_t otherDigest) {
  // see boost/container_hash/hash.hpp
  digest ^= otherDigest + 0x9e3779b9 + (digest << 6) + (digest >> 2);
}

} // namespace wasm

#endif // wasm_support_hash_deterministic_h
