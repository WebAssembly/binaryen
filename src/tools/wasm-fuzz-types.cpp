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

#include <optional>
#include <random>
#include <string>

#include "support/command-line.h"
#include "tools/fuzzing/heap-types.h"
#include "tools/fuzzing/random.h"

namespace wasm {

using RandEngine = std::mt19937_64;

uint64_t getSeed() {
  // Return a (truly) random 64-bit value.
  std::random_device rand;
  return std::uniform_int_distribution<uint64_t>{}(rand);
}

struct Fuzzer {
  bool verbose;

  void run(uint64_t seed) {
    // TODO: Reset the global type state to avoid monotonically increasing
    // memory use.
    RandEngine getRand(seed);
    std::cout << "Running with seed " << seed << "\n";

    // 4kb of random bytes should be enough for anyone!
    std::vector<char> bytes(4096);
    for (size_t i = 0; i < bytes.size(); i += sizeof(uint64_t)) {
      *(uint64_t*)(bytes.data() + i) = getRand();
    }
    Random rand(std::move(bytes));

    // TODO: Options to control the size or set it randomly.
    HeapTypeGenerator generator =
      HeapTypeGenerator::create(rand, FeatureSet::All, 20);
    auto result = generator.builder.build();
    if (auto* err = result.getError()) {
      Fatal() << "Failed to build types: " << err->reason << " at index "
              << err->index;
    }
    auto types = *result;

    if (verbose) {
      printTypes(types);
    }

    checkSubtypes(types, generator.subtypeIndices);
    checkLUBs(types);
  }

  void printTypes(const std::vector<HeapType>& types) {
    std::cout << "Built " << types.size() << " types:\n";
    for (size_t i = 0; i < types.size(); ++i) {
      std::cout << i << ": " << types[i] << "\n";
    }
  }

  void checkSubtypes(const std::vector<HeapType>& types,
                     const std::vector<std::vector<Index>>& subtypeIndices) {
    for (size_t super = 0; super < types.size(); ++super) {
      for (auto sub : subtypeIndices[super]) {
        if (!HeapType::isSubType(types[sub], types[super])) {
          Fatal() << "HeapType " << sub << " should be a subtype of HeapType "
                  << super << " but is not!\n"
                  << sub << ": " << types[sub] << "\n"
                  << super << ": " << types[super] << "\n";
        }
      }
    }
  }

  void checkLUBs(const std::vector<HeapType>& types) {
    // For each unordered pair of types...
    for (size_t i = 0; i < types.size(); ++i) {
      for (size_t j = i; j < types.size(); ++j) {
        HeapType a = types[i], b = types[j];
        // Check that their LUB is stable when calculated multiple times and in
        // reverse order.
        HeapType lub = HeapType::getLeastUpperBound(a, b);
        if (lub != HeapType::getLeastUpperBound(b, a) ||
            lub != HeapType::getLeastUpperBound(a, b)) {
          Fatal() << "Could not calculate a stable LUB of HeapTypes " << i
                  << " and " << j << "!\n"
                  << i << ": " << a << "\n"
                  << j << ": " << b << "\n";
        }
        // Check that each type is a subtype of the LUB.
        if (!HeapType::isSubType(a, lub)) {
          Fatal() << "HeapType " << i
                  << " is not a subtype of its LUB with HeapType " << j << "!\n"
                  << i << ": " << a << "\n"
                  << j << ": " << b << "\n"
                  << "lub: " << lub << "\n";
        }
        if (!HeapType::isSubType(b, lub)) {
          Fatal() << "HeapType " << j
                  << " is not a subtype of its LUB with HeapType " << i << "!\n"
                  << i << ": " << a << "\n"
                  << j << ": " << b << "\n"
                  << "lub: " << lub << "\n";
        }
        // Check that the LUB of each type and the original LUB is still the
        // original LUB.
        if (lub != HeapType::getLeastUpperBound(a, lub)) {
          Fatal() << "The LUB of HeapType " << i << " and HeapType " << j
                  << " should be the LUB of itself and HeapType " << i
                  << ", but it is not!\n"
                  << i << ": " << a << "\n"
                  << j << ": " << b << "\n"
                  << "lub: " << lub << "\n";
        }
        if (lub != HeapType::getLeastUpperBound(lub, b)) {
          Fatal() << "The LUB of HeapType " << i << " and HeapType " << j
                  << " should be the LUB of itself and HeapType " << j
                  << ", but it is not!\n"
                  << i << ": " << a << "\n"
                  << j << ": " << b << "\n"
                  << "lub: " << lub << "\n";
        }
      }
    }
  }
};

} // namespace wasm

int main(int argc, const char* argv[]) {
  using namespace wasm;

  const std::string WasmFuzzTypesOption = "wasm-fuzz-types options";

  Options options("wasm-fuzz-types",
                  "Fuzz type construction, canonicalization, and operations");

  std::optional<uint64_t> seed;
  options.add("--seed",
              "",
              "Run a single workload generated by the given seed",
              WasmFuzzTypesOption,
              Options::Arguments::One,
              [&](Options*, const std::string& arg) {
                seed = uint64_t(std::stoull(arg));
              });

  bool verbose = false;
  options.add("--verbose",
              "-v",
              "Print extra information",
              WasmFuzzTypesOption,
              Options::Arguments::Zero,
              [&](Options*, const std::string& arg) { verbose = true; });

  TypeSystem system = TypeSystem::Nominal;
  options.add(
    "--nominal",
    "",
    "Use the nominal type system (default)",
    WasmFuzzTypesOption,
    Options::Arguments::Zero,
    [&](Options*, const std::string& arg) { system = TypeSystem::Nominal; });
  options.add("--structural",
              "",
              "Use the equirecursive type system",
              WasmFuzzTypesOption,
              Options::Arguments::Zero,
              [&](Options*, const std::string& arg) {
                system = TypeSystem::Equirecursive;
              });

  options.parse(argc, argv);

  setTypeSystem(system);

  Fuzzer fuzzer{verbose};
  if (seed) {
    // Run just a single workload with the given seed.
    fuzzer.run(*seed);
  } else {
    // Continuously run workloads with new randomly generated seeds.
    size_t i = 0;
    RandEngine nextSeed(getSeed());
    while (true) {
      std::cout << "Iteration " << ++i << "\n";
      fuzzer.run(nextSeed());
    }
  }
  return 0;
}
