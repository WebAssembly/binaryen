/*
 * Copyright 2023 WebAssembly Community Group participants
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

#include "analysis/lattice.h"
#include "analysis/liveness-transfer-function.h"
#include "analysis/reaching-definitions-transfer-function.h"

#include "support/command-line.h"
#include "tools/fuzzing.h"
#include "tools/fuzzing/random.h"

namespace wasm {
using RandEngine = std::mt19937_64;
using namespace analysis;

// Helps printing error messages.
std::string LatticeComparisonNames[4] = {
  "No Relation", "Equal", "Less", "Greater"};
std::string LatticeComparisonSymbols[4] = {"?", "=", "<", ">"};

uint64_t getSeed() {
  // Return a (truly) random 64-bit value.
  std::random_device rand;
  return std::uniform_int_distribution<uint64_t>{}(rand);
}

// Utility class which provides methods to check properties of the transfer
// function and lattice of an analysis.
template<typename Lattice, typename TransferFunction> struct AnalysisChecker {
  Lattice& lattice;
  TransferFunction& transferFunction;
  std::string latticeName;
  std::string transferFunctionName;
  uint64_t latticeElementSeed;
  Name funcName;

  AnalysisChecker(Lattice& lattice,
                  TransferFunction& transferFunction,
                  std::string latticeName,
                  std::string transferFunctionName,
                  uint64_t latticeElementSeed,
                  Name funcName)
    : lattice(lattice), transferFunction(transferFunction),
      latticeName(latticeName), transferFunctionName(transferFunctionName),
      latticeElementSeed(latticeElementSeed), funcName(funcName) {}

  void printFailureInfo(std::ostream& os) {
    os << "Error for " << transferFunctionName << " and " << latticeName
       << " at lattice element seed " << latticeElementSeed << " and function "
       << funcName << ".\n";
  }

  // Prints information about a particular test case consisting of a randomly
  // generated function and triple of randomly generate lattice elements.
  void printVerboseFunctionCase(std::ostream& os,
                                typename Lattice::Element& x,
                                typename Lattice::Element& y,
                                typename Lattice::Element& z) {
    os << "Using lattice element seed " << latticeElementSeed << "\nGenerated "
       << latticeName << " elements:\n";
    x.print(os);
    os << ",\n";
    y.print(os);
    os << ",\n";
    z.print(os);
    os << "\nfor " << funcName << " to test " << transferFunctionName
       << ".\n\n";
  }

  // Checks reflexivity of a lattice element, i.e. x = x.
  void checkReflexivity(typename Lattice::Element& element) {
    LatticeComparison result = lattice.compare(element, element);
    if (result != LatticeComparison::EQUAL) {
      std::stringstream ss;
      printFailureInfo(ss);
      ss << "Element ";
      element.print(ss);
      ss << " is not reflexive.\n";
      Fatal() << ss.str();
    }
  }

  // Anti-Symmetry is defined as x <= y and y <= x imply x = y. Due to the
  // fact that the compare(x, y) function of the lattice explicitly tells
  // us if two lattice elements are <, =, or = instead of providing a
  // <= comparison, it is not useful to check for anti-symmetry as it is defined
  // in the fuzzer.
  //
  // Instead, we check for a related concept that x < y implies y > x, and
  // vice versa in this checkAntiSymmetry function.
  void checkAntiSymmetry(typename Lattice::Element& x,
                         typename Lattice::Element& y) {
    LatticeComparison result = lattice.compare(x, y);
    LatticeComparison reverseResult = lattice.compare(y, x);

    if (reverseComparison(result) != reverseResult) {
      std::stringstream ss;
      printFailureInfo(ss);
      x.print(ss);
      ss << " " << LatticeComparisonNames[result] << " ";
      y.print(ss);
      ss << " but reverse direction comparison is "
         << LatticeComparisonNames[reverseResult] << ".\n";
      Fatal() << ss.str();
    }
  }

private:
  // Prints the error message when a triple of lattice elements violates
  // transitivity.
  void printTransitivityError(std::ostream& os,
                              typename Lattice::Element& a,
                              typename Lattice::Element& b,
                              typename Lattice::Element& c,
                              LatticeComparison ab,
                              LatticeComparison bc,
                              LatticeComparison ac) {
    printFailureInfo(os);
    os << "Elements a = ";
    a.print(os);
    os << ", b = ";
    b.print(os);
    os << ", and c = ";
    c.print(os);
    os << " are not transitive. a" << LatticeComparisonSymbols[ab] << "b and b"
       << LatticeComparisonSymbols[bc] << "c, but a"
       << LatticeComparisonSymbols[ac] << "c.\n";
  }

  // Returns true if given a-b and b-c comparisons, the a-c comparison violates
  // transitivity.
  bool violatesTransitivity(LatticeComparison ab,
                            LatticeComparison bc,
                            LatticeComparison ac) {
    if (ab != LatticeComparison::NO_RELATION &&
        (bc == LatticeComparison::EQUAL || bc == ab) && ab != ac) {
      return true;
    } else if (bc != LatticeComparison::NO_RELATION &&
               (ab == LatticeComparison::EQUAL || ab == bc) && bc != ac) {
      return true;
    }
    return false;
  }

public:
  // Given three lattice elements x, y, and z, checks if transitivity holds
  // between them.
  void checkTransitivity(typename Lattice::Element& x,
                         typename Lattice::Element& y,
                         typename Lattice::Element& z) {
    LatticeComparison xy = lattice.compare(x, y);
    LatticeComparison yz = lattice.compare(y, z);
    LatticeComparison xz = lattice.compare(x, z);

    LatticeComparison yx = reverseComparison(xy);
    LatticeComparison zy = reverseComparison(yz);

    // Cover all permutations of x, y, and z.
    if (violatesTransitivity(xy, yz, xz)) {
      std::stringstream ss;
      printTransitivityError(ss, x, y, z, xy, yz, xz);
      Fatal() << ss.str();
    } else if (violatesTransitivity(yx, xz, yz)) {
      std::stringstream ss;
      printTransitivityError(ss, y, x, z, yx, xz, yz);
      Fatal() << ss.str();
    } else if (violatesTransitivity(xz, zy, xy)) {
      std::stringstream ss;
      printTransitivityError(ss, x, z, y, xz, zy, xy);
      Fatal() << ss.str();
    }
  }

  // Given two input - output lattice pairs of a transfer function, checks if
  // the transfer function is monotonic. If this is violated, then we print out
  // the CFG block input which caused the transfer function to exhibit
  // non-monotonic behavior.
  void checkMonotonicity(const BasicBlock* cfgBlock,
                         typename Lattice::Element& first,
                         typename Lattice::Element& second,
                         typename Lattice::Element& firstResult,
                         typename Lattice::Element& secondResult) {
    LatticeComparison beforeCmp = lattice.compare(first, second);
    LatticeComparison afterCmp = lattice.compare(firstResult, secondResult);

    // Cases in which monotonicity is preserved.
    if (beforeCmp == LatticeComparison::NO_RELATION) {
      // If there is no relation in the first place, we can't expect anything.
      return;
    } else if (beforeCmp == LatticeComparison::LESS &&
               (afterCmp == LatticeComparison::LESS ||
                afterCmp == LatticeComparison::EQUAL)) {
      // x < y and f(x) <= f(y)
      return;
    } else if (beforeCmp == LatticeComparison::GREATER &&
               (afterCmp == LatticeComparison::GREATER ||
                afterCmp == LatticeComparison::EQUAL)) {
      // x > y and f(x) >= f(y)
      return;
    } else if (beforeCmp == LatticeComparison::EQUAL &&
               afterCmp == LatticeComparison::EQUAL) {
      // x = y and f(x) = f(y)
      return;
    }

    std::stringstream ss;
    printFailureInfo(ss);

    ss << "Elements ";
    first.print(ss);
    ss << " -> ";
    firstResult.print(ss);
    ss << " and ";
    second.print(ss);
    ss << " -> ";
    secondResult.print(ss);
    ss << "\n show that the transfer function is not monotone when given the "
          "input:\n";
    cfgBlock->print(ss);
    ss << "\n";

    Fatal() << ss.str();
  }

  // Checks lattice-only properties for a triple of lattices.
  void checkLatticeElements(typename Lattice::Element x,
                            typename Lattice::Element y,
                            typename Lattice::Element z) {
    checkReflexivity(x);
    checkReflexivity(y);
    checkReflexivity(z);
    checkAntiSymmetry(x, y);
    checkAntiSymmetry(x, z);
    checkAntiSymmetry(y, z);
    checkTransitivity(x, y, z);
  }

  // Checks transfer function relevant properties given a CFG and three input
  // states. It does this by applying the transfer function on each CFG block
  // using the same three input states each time and then checking properties on
  // the inputs and outputs.
  void checkTransferFunction(CFG& cfg,
                             typename Lattice::Element x,
                             typename Lattice::Element y,
                             typename Lattice::Element z) {
    for (auto cfgIter = cfg.begin(); cfgIter != cfg.end(); ++cfgIter) {
      // Apply transfer function on each lattice element.
      typename Lattice::Element xResult = x;
      transferFunction.transfer(&(*cfgIter), xResult);
      typename Lattice::Element yResult = y;
      transferFunction.transfer(&(*cfgIter), yResult);
      typename Lattice::Element zResult = z;
      transferFunction.transfer(&(*cfgIter), zResult);

      // Check monotonicity for every pair of transfer function outputs.
      checkMonotonicity(&(*cfgIter), x, y, xResult, yResult);
      checkMonotonicity(&(*cfgIter), x, z, xResult, zResult);
      checkMonotonicity(&(*cfgIter), y, z, yResult, zResult);
    }
  }
};

// Struct to set up and check liveness analysis lattice and transfer function.
struct LivenessChecker {
  LivenessTransferFunction transferFunction;
  FiniteIntPowersetLattice lattice;
  AnalysisChecker<FiniteIntPowersetLattice, LivenessTransferFunction> checker;
  LivenessChecker(Function* func, uint64_t latticeElementSeed, Name funcName)
    : lattice(func->getNumLocals()), checker(lattice,
                                             transferFunction,
                                             "FiniteIntPowersetLattice",
                                             "LivenessTransferFunction",
                                             latticeElementSeed,
                                             funcName) {}

  FiniteIntPowersetLattice::Element getRandomElement(Random& rand) {
    FiniteIntPowersetLattice::Element result = lattice.getBottom();

    // Uses rand to randomly select which members are to be included (i. e. flip
    // bits in the bitvector).
    for (size_t i = 0; i < lattice.getSetSize(); ++i) {
      result.set(i, rand.oneIn(2));
    }
    return result;
  }

  // Runs all checks for liveness analysis.
  void runChecks(CFG& cfg, Random& rand, bool verbose) {
    FiniteIntPowersetLattice::Element x = getRandomElement(rand);
    FiniteIntPowersetLattice::Element y = getRandomElement(rand);
    FiniteIntPowersetLattice::Element z = getRandomElement(rand);

    if (verbose) {
      checker.printVerboseFunctionCase(std::cout, x, y, z);
    }

    checker.checkLatticeElements(x, y, z);
    checker.checkTransferFunction(cfg, x, y, z);
  }
};

// Struct to set up and check reaching definitions analysis lattice and transfer
// function.
struct ReachingDefinitionsChecker {
  LocalGraph::GetSetses getSetses;
  LocalGraph::Locations locations;
  ReachingDefinitionsTransferFunction transferFunction;
  AnalysisChecker<FinitePowersetLattice<LocalSet*>,
                  ReachingDefinitionsTransferFunction>
    checker;
  ReachingDefinitionsChecker(Function* func,
                             uint64_t latticeElementSeed,
                             Name funcName)
    : transferFunction(func, getSetses, locations),
      checker(transferFunction.lattice,
              transferFunction,
              "FinitePowersetLattice<LocalSet*>",
              "ReachingDefinitionsTransferFunction",
              latticeElementSeed,
              funcName) {}

  FinitePowersetLattice<LocalSet*>::Element getRandomElement(Random& rand) {
    FinitePowersetLattice<LocalSet*>::Element result =
      transferFunction.lattice.getBottom();

    // Uses rand to randomly select which members are to be included (i. e. flip
    // bits in the bitvector).
    for (size_t i = 0; i < transferFunction.lattice.getSetSize(); ++i) {
      result.set(i, rand.oneIn(2));
    }
    return result;
  }

  // Runs all checks for reaching definitions analysis.
  void runChecks(CFG& cfg, Random& rand, bool verbose) {
    FinitePowersetLattice<LocalSet*>::Element x = getRandomElement(rand);
    FinitePowersetLattice<LocalSet*>::Element y = getRandomElement(rand);
    FinitePowersetLattice<LocalSet*>::Element z = getRandomElement(rand);

    if (verbose) {
      checker.printVerboseFunctionCase(std::cout, x, y, z);
    }

    checker.checkLatticeElements(x, y, z);
    checker.checkTransferFunction(cfg, x, y, z);
  }
};

struct Fuzzer {
  bool verbose;

  Fuzzer(bool verbose) : verbose(verbose) {}

  // Helper function to run per-function tests. latticeElementSeed is used to
  // generate three lattice elements randomly. It is also used to select which
  // analysis is to be tested for the function.
  void runOnFunction(Function* func, uint64_t latticeElementSeed) {
    RandEngine getFuncRand(latticeElementSeed);

    // Fewer bytes are needed to generate three random lattices.
    std::vector<char> funcBytes(128);
    for (size_t i = 0; i < funcBytes.size(); i += sizeof(uint64_t)) {
      *(uint64_t*)(funcBytes.data() + i) = getFuncRand();
    }

    Random rand(std::move(funcBytes));

    CFG cfg = CFG::fromFunction(func);

    switch (rand.upTo(2)) {
      case 0: {
        LivenessChecker livenessChecker(func, latticeElementSeed, func->name);
        livenessChecker.runChecks(cfg, rand, verbose);
        break;
      }
      default: {
        ReachingDefinitionsChecker reachingDefinitionsChecker(
          func, latticeElementSeed, func->name);
        reachingDefinitionsChecker.runChecks(cfg, rand, verbose);
      }
    }
  }

  // Generates a module. The module is used as an input to fuzz transfer
  // functions as well as randomly generated lattice element states. Lattice
  // properties are also fuzzed from the randomly generated states.
  void run(uint64_t seed,
           uint64_t* latticeElementSeed = nullptr,
           std::string* funcName = nullptr) {
    RandEngine getRand(seed);
    std::cout << "Running with seed " << seed << "\n";

    // 4kb of random bytes should be enough for anyone!
    std::vector<char> bytes(4096);
    for (size_t i = 0; i < bytes.size(); i += sizeof(uint64_t)) {
      *(uint64_t*)(bytes.data() + i) = getRand();
    }

    Module testModule;
    TranslateToFuzzReader reader(testModule, std::move(bytes));
    reader.build();

    if (verbose) {
      std::cout << "Generated test module: \n";
      std::cout << testModule;
      std::cout << "\n";
    }

    // If a specific function and lattice element seed is specified, only run
    // that.
    if (latticeElementSeed && funcName) {
      runOnFunction(testModule.getFunction(*funcName), *latticeElementSeed);
      return;
    }

    ModuleUtils::iterDefinedFunctions(testModule, [&](Function* func) {
      uint64_t funcSeed = getRand();
      runOnFunction(func, funcSeed);
    });
  }
};

} // namespace wasm

int main(int argc, const char* argv[]) {
  using namespace wasm;

  const std::string WasmFuzzTypesOption = "wasm-fuzz-lattices options";

  Options options("wasm-fuzz-lattices",
                  "Fuzz lattices for reflexivity, transitivity, and "
                  "anti-symmetry, and tranfer functions for monotonicity.");

  std::optional<uint64_t> seed;
  options.add("--seed",
              "",
              "Run a single workload generated by the given seed",
              WasmFuzzTypesOption,
              Options::Arguments::One,
              [&](Options*, const std::string& arg) {
                seed = uint64_t(std::stoull(arg));
              });

  std::optional<uint64_t> latticeElementSeed;
  options.add("--lattice-element-seed",
              "",
              "Seed which generated the lattice elements to be checked.",
              WasmFuzzTypesOption,
              Options::Arguments::One,
              [&](Options*, const std::string& arg) {
                latticeElementSeed = uint64_t(std::stoull(arg));
              });

  std::optional<std::string> functionName;
  options.add(
    "--function-name",
    "",
    "Name of the function in the module generated by --seed to be checked.",
    WasmFuzzTypesOption,
    Options::Arguments::One,
    [&](Options*, const std::string& arg) { functionName = arg; });

  bool verbose = false;
  options.add("--verbose",
              "-v",
              "Print extra information",
              WasmFuzzTypesOption,
              Options::Arguments::Zero,
              [&](Options*, const std::string& arg) { verbose = true; });

  options.parse(argc, argv);

  Fuzzer fuzzer{verbose};
  if (seed) {
    if (latticeElementSeed && functionName) {
      // Run test a single function and lattice element seed.
      fuzzer.run(*seed, &(*latticeElementSeed), &(*functionName));
    } else {
      // Run just a single workload with the given seed.
      fuzzer.run(*seed);
    }
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
