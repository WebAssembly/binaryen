/*
 * Copyright 2022 WebAssembly Community Group participants
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

#include <limits>
#include <mutex>

#include "istring.h"
#include "mixed_arena.h"

namespace wasm {

const char* IString::interned(std::string_view s) {
  if (s.data() == nullptr) {
    return nullptr;
  }

  // A set of interned Views, i.e., that contains our pascal-style strings. We
  // need to query this using a std::string_view, as that is what we receive as
  // input (turning it into pascal-style storage would add overhead). To do so,
  // use overloading in the hash and equality functions (which works thanks to
  // `is_transparent`).
  struct InternedHash {
    using is_transparent = void;
    size_t operator()(View v) const {
      return std::hash<std::string_view>{}(std::string_view(v));
    }
    size_t operator()(std::string_view sv) const {
      return std::hash<std::string_view>{}(sv);
    }
  };
  struct InternedEqual {
    using is_transparent = void;
    bool operator()(View a, View b) const {
      return std::string_view(a) == std::string_view(b);
    }
    bool operator()(std::string_view a, View b) const {
      return a == std::string_view(b);
    }
    bool operator()(View a, std::string_view b) const {
      return std::string_view(a) == b;
    }
    bool operator()(std::string_view a, std::string_view b) const {
      return a == b;
    }
  };
  using StringSet = std::unordered_set<View, InternedHash, InternedEqual>;

  // The authoritative global set of interned string views.
  static StringSet globalStrings;

  // The global backing store for interned strings that do not otherwise have
  // stable addresses.
  static MixedArena arena;

  // Guards access to `globalStrings`. (note: `arena` is thread-safe anyhow)
  static std::mutex mutex;

  // A thread-local cache of strings to reduce contention.
  thread_local static StringSet localStrings;

  if (auto it = localStrings.find(s); it != localStrings.end()) {
    // We already had a local copy of this string.
    return it->internal;
  }

  // No copy yet in the local cache. Check the global cache.
  std::unique_lock<std::mutex> lock(mutex);
  if (auto it = globalStrings.find(s); it != globalStrings.end()) {
    // We already had a global copy of this string. Cache it locally.
    localStrings.insert(*it);
    return it->internal;
  }

  // We have a new string. Create a copy of the data at a stable address with a
  // header we can use. Make sure it is null terminated so legacy uses that get
  // a C string still work.
  size_t size = s.size();
  // The string's size must fit in 32 bits.
  assert(size <= std::numeric_limits<uint32_t>::max());
  char* buffer =
    (char*)arena.allocSpace(sizeof(uint32_t) + size + 1, alignof(uint32_t));
  *(uint32_t*)(buffer) = size;
  char* data = buffer + sizeof(uint32_t);
  std::copy(s.begin(), s.end(), data);
  data[size] = '\0';

  // Intern our new string.
  View v{data};
  globalStrings.insert(v);
  localStrings.insert(v);
  return data;
}

} // namespace wasm
