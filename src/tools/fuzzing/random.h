/*
 * Copyright 2021 WebAssembly Community Group participants
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

#ifndef wasm_tools_fuzzing_random_h
#define wasm_tools_fuzzing_random_h

#include <cstdint>
#include <map>
#include <vector>

#include "wasm-features.h"

namespace wasm {

class Random {
  // The input seed bytes.
  std::vector<char> bytes;
  // The current position in `bytes`.
  size_t pos = 0;
  // Whether we already cycled through all the input (which might mean we should
  // try to finish things off).
  bool finishedInput = false;
  // After we finish the input, we start going through it again, but xoring
  // so it's not identical.
  int xorFactor = 0;
  // Features used for picking among FeatureOptions.
  FeatureSet features;

public:
  Random(std::vector<char>&& bytes, FeatureSet features);
  Random(std::vector<char>&& bytes)
    : Random(std::move(bytes), FeatureSet::All) {}

  // Methods for getting random data.
  int8_t get();
  int16_t get16();
  int32_t get32();
  int64_t get64();
  float getFloat();
  double getDouble();

  // Choose an integer value in [0, x). This doesn't use a perfectly uniform
  // distribution, but it's fast and reasonable.
  uint32_t upTo(uint32_t x);
  bool oneIn(uint32_t x) { return upTo(x) == 0; }

  // Apply upTo twice, generating a skewed distribution towards
  // low values.
  uint32_t upToSquared(uint32_t x) { return upTo(upTo(x)); }

  bool finished() { return finishedInput; }

  // Pick from a vector-like container
  template<typename T> const typename T::value_type& pick(const T& vec) {
    assert(!vec.empty());
    auto index = upTo(vec.size());
    return vec[index];
  }

  // Pick from a fixed list
  template<typename T, typename... Args> T pick(T first, Args... args) {
    auto num = sizeof...(Args) + 1;
    auto temp = upTo(num);
    return pickGivenNum<T>(temp, first, args...);
  }

  template<typename T> T pickGivenNum(size_t num, T first) {
    assert(num == 0);
    return first;
  }

// Trick to avoid a bug in GCC 7.x.
// Upstream bug report: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=82800
#define GCC_VERSION                                                            \
  (__GNUC__ * 10000 + __GNUC_MINOR__ * 100 + __GNUC_PATCHLEVEL__)
#if GCC_VERSION > 70000 && GCC_VERSION < 70300
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wmaybe-uninitialized"
#endif

  template<typename T, typename... Args>
  T pickGivenNum(size_t num, T first, Args... args) {
    if (num == 0) {
      return first;
    }
    return pickGivenNum<T>(num - 1, args...);
  }

#if GCC_VERSION > 70000 && GCC_VERSION < 70300
#pragma GCC diagnostic pop
#endif

  template<typename T> struct FeatureOptions {
    template<typename... Ts>
    FeatureOptions<T>& add(FeatureSet feature, T option, Ts... rest) {
      options[feature].push_back(option);
      return add(feature, rest...);
    }

    struct WeightedOption {
      T option;
      size_t weight;
    };

    template<typename... Ts>
    FeatureOptions<T>&
    add(FeatureSet feature, WeightedOption weightedOption, Ts... rest) {
      for (size_t i = 0; i < weightedOption.weight; i++) {
        options[feature].push_back(weightedOption.option);
      }
      return add(feature, rest...);
    }

    FeatureOptions<T>& add(FeatureSet feature) { return *this; }

    std::map<FeatureSet, std::vector<T>> options;
  };

  template<typename T> std::vector<T> items(FeatureOptions<T>& picker) {
    std::vector<T> matches;
    for (const auto& item : picker.options) {
      if (features.has(item.first)) {
        matches.reserve(matches.size() + item.second.size());
        matches.insert(matches.end(), item.second.begin(), item.second.end());
      }
    }
    return matches;
  }

  template<typename T> const T pick(FeatureOptions<T>& picker) {
    return pick(items(picker));
  }
};

} // namespace wasm

#endif // wasm_tools_fuzzing_random_h
