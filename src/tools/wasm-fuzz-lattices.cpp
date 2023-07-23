
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

uint64_t getSeed() {
  // Return a (truly) random 64-bit value.
  std::random_device rand;
  return std::uniform_int_distribution<uint64_t>{}(rand);
}

struct Fuzzer {
  bool verbose;

  Random rand;

  Fuzzer(bool verbose) : verbose(verbose), rand({}) {}

  // Checks reflexivity of a lattice element, i.e. x = x.
  template<typename Lattice>
  void checkReflexivity(Lattice& lattice,
                        std::string latticeName,
                        typename Lattice::Element& element) {
    LatticeComparison result = lattice.compare(element, element);
    if (result != LatticeComparison::EQUAL) {
      std::stringstream ss;
      ss << latticeName << " element ";
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

  // Instead, we check for a related concept that x < y implies y > x, and
  // vice versa in this checkAntiSymmetry function.
  template<typename Lattice>
  void checkAntiSymmetry(Lattice& lattice,
                         std::string latticeName,
                         typename Lattice::Element& x,
                         typename Lattice::Element& y) {
    LatticeComparison result = lattice.compare(x, y);
    LatticeComparison reverseResult = lattice.compare(y, x);

    if (reverseComparison(result) != reverseResult) {
      std::stringstream ss;
      ss << latticeName << " has ";
      x.print(ss);
      ss << " " << LatticeComparisonNames[result] << " ";
      y.print(ss);
      ss << " but reverse direction comparison is "
         << LatticeComparisonNames[reverseResult] << ".\n";
      Fatal() << ss.str();
    }
  }

  // Given three lattice elements x, y, and z, checks if transitivity holds
  // between them.
  template<typename Lattice>
  void checkTransitivity(Lattice& lattice,
                         std::string latticeName,
                         typename Lattice::Element& x,
                         typename Lattice::Element& y,
                         typename Lattice::Element& z) {
    LatticeComparison xy = lattice.compare(x, y);
    LatticeComparison yz = lattice.compare(y, z);
    LatticeComparison xz = lattice.compare(x, z);

    LatticeComparison yx = reverseComparison(xy);
    LatticeComparison zy = reverseComparison(yz);

    // Cover all permutations of x, y, and z.
    if (xy != LatticeComparison::NO_RELATION && xy == yz && yz != xz) {
      std::stringstream ss;
      ss << latticeName << " elements a = ";
      x.print(ss);
      ss << ", b = ";
      y.print(ss);
      ss << ", and c = ";
      z.print(ss);
      ss << " are not transitive. a" << LatticeComparisonSymbols[xy]
         << "b and b" << LatticeComparisonSymbols[yz] << "c, but a"
         << LatticeComparisonSymbols[xz] << ".\n";
      Fatal() << ss.str();
    } else if (yx != LatticeComparison::NO_RELATION && yx == xz && xz != yz) {
      std::stringstream ss;
      ss << latticeName << " elements a = ";
      y.print(ss);
      ss << ", b = ";
      x.print(ss);
      ss << ", and c = ";
      z.print(ss);
      ss << " are not transitive. a" << LatticeComparisonSymbols[yx]
         << "b and b" << LatticeComparisonSymbols[xz] << "c, but a"
         << LatticeComparisonSymbols[yz] << ".\n";
      Fatal() << ss.str();
    } else if (xz != LatticeComparison::NO_RELATION && xz == zy && zy != xy) {
      std::stringstream ss;
      ss << latticeName << " elements a = ";
      x.print(ss);
      ss << ", b = ";
      z.print(ss);
      ss << ", and c = ";
      y.print(ss);
      ss << " are not transitive. a" << LatticeComparisonSymbols[xz]
         << "b and b" << LatticeComparisonSymbols[zy] << "c, but a"
         << LatticeComparisonSymbols[xy] << ".\n";
      Fatal() << ss.str();
    }
  }

  // Given two input - output lattice pairs of a transfer function, checks if
  // the transfer function is monotonic. If this is violated, then we print out
  // the CFG block input which caused the transfer function to exhibit
  // non-monotonic behavior.
  template<typename Lattice>
  void checkMonotonicity(Lattice& lattice,
                         std::string latticeName,
                         std::string transferFunctionName,
                         const BasicBlock* cfgBlock,
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

    ss << "The " << latticeName << " elements ";
    first.print(ss);
    ss << " -> ";
    firstResult.print(ss);
    ss << " and ";
    second.print(ss);
    ss << " -> ";
    secondResult.print(ss);
    ss << " show that " << transferFunctionName
       << " is not monotone when given the input:\n";
    cfgBlock->print(ss);
    ss << "\n";

    Fatal() << ss.str();
  }

  // Helper function for checking the properties of lattices and transfer
  // functiosn on a CFG of a randomly generated function. It does this by
  // radomly generating three lattice elements, and then using them as input
  // states for a CFG block on which the transfer function is applied.
  template<typename Lattice, typename TransferFunction>
  void check(CFG& cfg,
             Lattice& lattice,
             std::string latticeName,
             TransferFunction& transferFunction,
             std::string transferFuncName) {
    for (auto cfgIter = cfg.begin(); cfgIter != cfg.end(); ++cfgIter) {
      typename Lattice::Element x = lattice.getRandom(rand);
      typename Lattice::Element y = lattice.getRandom(rand);
      typename Lattice::Element z = lattice.getRandom(rand);

      // Check lattice properties
      checkReflexivity<Lattice>(lattice, latticeName, x);
      checkReflexivity<Lattice>(lattice, latticeName, y);
      checkReflexivity<Lattice>(lattice, latticeName, z);
      checkAntiSymmetry<Lattice>(lattice, latticeName, x, y);
      checkAntiSymmetry<Lattice>(lattice, latticeName, x, z);
      checkAntiSymmetry<Lattice>(lattice, latticeName, y, z);
      checkTransitivity<Lattice>(lattice, latticeName, x, y, z);

      // Apply transfer function on each lattice element.
      typename Lattice::Element xResult = x;
      transferFunction.transfer(&(*cfgIter), xResult);
      typename Lattice::Element yResult = y;
      transferFunction.transfer(&(*cfgIter), yResult);
      typename Lattice::Element zResult = z;
      transferFunction.transfer(&(*cfgIter), zResult);

      // Check monotonicity for every pair of transfer function outputs.
      checkMonotonicity<Lattice>(lattice,
                                 latticeName,
                                 transferFuncName,
                                 &(*cfgIter),
                                 x,
                                 y,
                                 xResult,
                                 yResult);
      checkMonotonicity<Lattice>(lattice,
                                 latticeName,
                                 transferFuncName,
                                 &(*cfgIter),
                                 x,
                                 z,
                                 xResult,
                                 zResult);
      checkMonotonicity<Lattice>(lattice,
                                 latticeName,
                                 transferFuncName,
                                 &(*cfgIter),
                                 y,
                                 z,
                                 yResult,
                                 zResult);
    }
  }

  // Checks properties of the LivenessTransferFunction on a randomly generated
  // module function.
  void checkLivenessTransferFunction(CFG& cfg, Function* func) {
    FiniteIntPowersetLattice lattice(func->getNumLocals());
    LivenessTransferFunction transferFunction;

    check<FiniteIntPowersetLattice, LivenessTransferFunction>(
      cfg,
      lattice,
      "FiniteIntPowersetLattice",
      transferFunction,
      "LivenessTransferFunction");
  }

  // Checks properties of the ReachingDefinitionsTransferFunction on a randomly
  // generated module function.
  void checkReachingDefinitionsTransferFunction(CFG& cfg, Function* func) {
    LocalGraph::GetSetses getSetses;
    LocalGraph::Locations locations;
    ReachingDefinitionsTransferFunction transferFunction(
      func, getSetses, locations);
    check<FinitePowersetLattice<LocalSet*>,
          ReachingDefinitionsTransferFunction>(
      cfg,
      transferFunction.lattice,
      "FinitePowersetLattice<LocalSet*>",
      transferFunction,
      "ReachingDefinitionsTransferFunction");
  }

  // Generates a module. The module is used as an input to fuzz transfer
  // functions as well as randomly generated lattice element states. Lattice
  // properties are also fuzzed from the randomly generated states.
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

    std::vector<char> bytes2 = bytes;

    Module testModule;
    TranslateToFuzzReader reader(testModule, std::move(bytes));
    reader.build();
    rand = Random(std::move(bytes2));

    ModuleUtils::iterDefinedFunctions(testModule, [&](Function* func) {
      CFG cfg = CFG::fromFunction(func);

      uint32_t analysisChoice = rand.pick(2);

      if (analysisChoice == 0) {
        checkLivenessTransferFunction(cfg, func);
      } else if (analysisChoice == 1) {
        checkReachingDefinitionsTransferFunction(cfg, func);
      }
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
