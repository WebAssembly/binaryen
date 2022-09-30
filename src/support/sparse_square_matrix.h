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

// A helper type for potentially sparse N*N matrix container.

#pragma once

#include <assert.h>
#include <stdint.h>
#include <unordered_map>
#include <vector>

template<typename Ty> class sparse_square_matrix {
  std::vector<Ty> denseStorage;
  std::unordered_map<uint64_t, Ty> sparseStorage;
  uint32_t N;

public:
  sparse_square_matrix() : N(0) {}

  explicit sparse_square_matrix(int N) : N(N) {
    if (N < DenseLimit) {
      denseStorage.resize(N * N);
    }
  }

  static const size_t DenseLimit = 8192;

  uint32_t width() const { return N; }

  bool usingDenseStorage() const { return !denseStorage.empty(); }

  void set(uint32_t i, uint32_t j, const Ty& value) {
    assert(i < N);
    assert(j < N);
    if (usingDenseStorage()) {
      denseStorage[i * N + j] = value;
    } else {
      sparseStorage[i * N + j] = value;
    }
  }

  const Ty get(uint32_t i, uint32_t j) const {
    assert(i < N);
    assert(j < N);
    if (usingDenseStorage()) {
      return denseStorage[i * N + j];
    }
    auto iter = sparseStorage.find(i * N + j);
    return iter == sparseStorage.end() ? Ty() : iter->second;
  }

  // Resizes the matrix to a new n*n size, and clears all entries
  // to the default-initialized value.
  void recreate(uint32_t n) {
    N = n;
    denseStorage.clear();
    sparseStorage.clear();
    if (N < DenseLimit) {
      denseStorage.resize(N * N);
    }
  }
};
