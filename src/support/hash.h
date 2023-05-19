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
// `otherDigest` is another digest and not a `size_t` value. This is also useful
// when you want deterministic behavior across systems, as this method does not
// call std::hash, so it does not depend on the behavior of the local machine's
// C++ standard library implementation.
inline void hash_combine(std::size_t& digest, const std::size_t otherDigest) {
  // see: boost/container_hash/hash.hpp
  // The constant is the N-bits reciprocal of the golden ratio:
  //  phi = (1 + sqrt(5)) / 2
#if SIZE_MAX == UINT64_MAX
  //  trunc(2^64 / phi) = 0x9e3779b97f4a7c15
  digest ^= otherDigest + 0x9e3779b97f4a7c15 + (digest << 12) + (digest >> 4);
#else
  //  trunc(2^32 / phi) = 0x9e3779b9
  digest ^= otherDigest + 0x9e3779b9 + (digest << 6) + (digest >> 2);
#endif
}

// Hashes `value` and combines the resulting digest into the existing digest.
// Use instead of `hash_combine` if `value` is not another digest.
template<typename T> inline void rehash(std::size_t& digest, const T& value) {
  hash_combine(digest, hash(value));
}

} // namespace wasm

namespace std {

// Hashing pairs is often useful
template<typename T1, typename T2> struct hash<pair<T1, T2>> {
  size_t operator()(const pair<T1, T2>& p) const {
    auto digest = wasm::hash(p.first);
    wasm::rehash(digest, p.second);
    return digest;
  }
};

// And hashing tuples is useful, too.
template<typename T, typename... Ts> struct hash<tuple<T, Ts...>> {
private:
  template<size_t... I>
  static void rehash(const tuple<T, Ts...>& tup,
                     size_t& digest,
                     std::index_sequence<I...>) {
    (wasm::rehash(digest, std::get<1 + I>(tup)), ...);
  }

public:
  size_t operator()(const tuple<T, Ts...>& tup) const {
    auto digest = wasm::hash(std::get<0>(tup));
    rehash(tup, digest, std::index_sequence_for<Ts...>{});
    return digest;
  }
};

} // namespace std

#endif // wasm_support_hash_h
