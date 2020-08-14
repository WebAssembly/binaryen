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

#ifndef wasm_support_hash_h
#define wasm_support_hash_h

#include <functional>
#include <stdint.h>

namespace wasm {

// Computes the digest of `value`.
template<typename T> inline std::size_t hash(const T& value) {
  return std::hash<T>{}(value);
}

// Combines two digests into the first digest. Use instead of `rehash` if
// `otherDigest` is another digest and not a `size_t` value.
static inline void hash_combine(std::uint32_t& digest,
                                const std::uint32_t otherDigest) {
  // see: boost/container_hash/hash.hpp
  // The constant is the N-bits reciprocal of the golden ratio:
  //  phi = (1 + sqrt(5)) / 2
  //  trunc(2^32 / phi) = 0x9e3779b9
  digest ^= otherDigest + 0x9e3779b9 + (digest << 6) + (digest >> 2);
}
static inline void hash_combine(std::uint64_t& digest,
                                const std::uint64_t otherDigest) {
  //  trunc(2^64 / phi) = 0x9e3779b97f4a7c15
  digest ^= otherDigest + 0x9e3779b97f4a7c15 + (digest << 12) + (digest >> 4);
}

// Hashes `value` and combines the resulting digest into the existing digest.
// Use instead of `hash_combine` if `value` is not another digest.
template<typename T> inline void rehash(std::size_t& digest, const T& value) {
  hash_combine(digest, hash(value));
}

} // namespace wasm

#endif // wasm_support_hash_h
