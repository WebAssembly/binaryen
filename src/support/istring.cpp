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

#include "istring.h"

namespace wasm {

std::string_view IString::interned(std::string_view s, bool reuse) {
  // We need a set of string_views that can be modified in-place to minimize
  // the number of lookups we do. Since set elements cannot normally be
  // modified, wrap the string_views in a container that provides mutability
  // even through a const reference.
  struct MutStringView {
    mutable std::string_view str;
    MutStringView(std::string_view str) : str(str) {}
  };
  struct MutStringViewHash {
    size_t operator()(const MutStringView& mut) const {
      return std::hash<std::string_view>{}(mut.str);
    }
  };
  struct MutStringViewEqual {
    bool operator()(const MutStringView& a, const MutStringView& b) const {
      return a.str == b.str;
    }
  };
  using StringSet =
    std::unordered_set<MutStringView, MutStringViewHash, MutStringViewEqual>;

  // The authoritative global set of interned string views.
  static StringSet globalStrings;

  // The global backing store for interned strings that do not otherwise have
  // stable addresses.
  static std::vector<std::vector<char>> allocated;

  // Guards access to `globalStrings` and `allocated`.
  static std::mutex mutex;

  // A thread-local cache of strings to reduce contention.
  thread_local static StringSet localStrings;

  auto [localIt, localInserted] = localStrings.insert(s);
  if (!localInserted) {
    // We already had a local copy of this string.
    return localIt->str;
  }

  // No copy yet in the local cache. Check the global cache.
  std::unique_lock<std::mutex> lock(mutex);
  auto [globalIt, globalInserted] = globalStrings.insert(s);
  if (!globalInserted) {
    // We already had a global copy of this string. Cache it locally.
    localIt->str = globalIt->str;
    return localIt->str;
  }

  if (!reuse) {
    // We have a new string, but it doesn't have a stable address. Create a copy
    // of the data at a stable address we can use. Make sure it is null
    // terminated so legacy uses that get a C string still work.
    allocated.emplace_back();
    auto& data = allocated.back();
    data.reserve(s.size() + 1);
    data.insert(data.end(), s.begin(), s.end());
    data.push_back('\0');
    s = std::string_view(allocated.back().data(), s.size());
  }

  // Intern our new string.
  localIt->str = globalIt->str = s;
  return s;
}

} // namespace wasm
