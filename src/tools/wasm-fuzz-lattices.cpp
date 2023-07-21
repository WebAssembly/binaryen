
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
  void checkReflexivity(Lattice& lattice, typename Lattice::Element& element) {
    analysis::LatticeComparison result = lattice.compare(element, element);
    if (result != analysis::LatticeComparison::EQUAL) {
      std::stringstream ss;
      ss << "Lattice ";
      element.print(ss);
      ss << " is not reflexive.\n";
      Fatal() << ss.str();
    }
  }

  // Checks that given two lattice elements x and y, if x < y, then y > x. We
  // don't actually check anti-symmetry since the lattice comparison has an
  // explicit equality comparison.
  template<typename Lattice>
  void checkAntiSymmetry(Lattice& lattice,
                         typename Lattice::Element& x,
                         typename Lattice::Element& y) {
    analysis::LatticeComparison result = lattice.compare(x, y);
    analysis::LatticeComparison reverseResult = lattice.compare(y, x);
    if (result == analysis::LatticeComparison::GREATER &&
        reverseResult != analysis::LatticeComparison::LESS) {
      std::stringstream ss;
      ss << "Lattices x = ";
      x.print(ss);
      ss << " and y = ";
      y.print(ss);
      ss << " are not anti-symmetric. x > y, but y < x is not true.\n";
      Fatal() << ss.str();
    } else if (result == analysis::LatticeComparison::LESS &&
               reverseResult != analysis::LatticeComparison::GREATER) {
      std::stringstream ss;
      ss << "Lattices x = ";
      x.print(ss);
      ss << " and y = ";
      y.print(ss);
      ss << " are not anti-symmetric. x < y, but y > x is not true.\n";
      Fatal() << ss.str();
    }
  }

private:
  // Helper to print out error messages for the numerous cases of transitivity
  // checking.
  template<typename Lattice>
  void transitivityErrorPrinter(std::ostream& os,
                                typename Lattice::Element& x,
                                typename Lattice::Element& y,
                                typename Lattice::Element& z,
                                std::string relation1,
                                std::string relation2,
                                std::string failedRelation) {
    os << "Lattices x = ";
    x.print(os);
    os << ", y = ";
    y.print(os);
    os << ", and z = ";
    z.print(os);
    os << " are not transitive. " << relation1 << " and " << relation2
       << ", but " << failedRelation << " is not true.\n";
  }

public:
  // Given three lattice elements, checks if transitivity applies (i.e. x > y
  // and y > z implies x > z).
  template<typename Lattice>
  void checkTransitivity(Lattice& lattice,
                         typename Lattice::Element& x,
                         typename Lattice::Element& y,
                         typename Lattice::Element& z) {
    analysis::LatticeComparison xy = lattice.compare(x, y);
    analysis::LatticeComparison yz = lattice.compare(y, z);
    analysis::LatticeComparison xz = lattice.compare(x, z);

    // We must enumerate every possible ordering between the three lattice
    // elements in which transitivity could be violated. We check by using a
    // case consisting of two orderings, and then checking if the third ordering
    // obeys transitivity.

    if (xy == analysis::LatticeComparison::EQUAL &&
        yz == analysis::LatticeComparison::EQUAL) {
      if (xz != analysis::LatticeComparison::EQUAL) {
        std::stringstream ss;
        transitivityErrorPrinter<Lattice>(
          ss, x, y, z, "x = y", "y = z", "x = z");
        Fatal() << ss.str();
      }
    } else if (xy == analysis::LatticeComparison::LESS &&
               yz == analysis::LatticeComparison::LESS) {
      if (xz != analysis::LatticeComparison::LESS) {
        std::stringstream ss;
        transitivityErrorPrinter<Lattice>(
          ss, x, y, z, "x < y", "y < z", "x < z");
        Fatal() << ss.str();
      }
    } else if (xy == analysis::LatticeComparison::GREATER &&
               yz == analysis::LatticeComparison::GREATER) {
      if (xz != analysis::LatticeComparison::GREATER) {
        std::stringstream ss;
        transitivityErrorPrinter<Lattice>(
          ss, x, y, z, "x > y", "y > z", "x > z");
        Fatal() << ss.str();
      }
    } else if (xz == analysis::LatticeComparison::EQUAL &&
               yz == analysis::LatticeComparison::EQUAL) {
      if (xy != analysis::LatticeComparison::EQUAL) {
        std::stringstream ss;
        transitivityErrorPrinter<Lattice>(
          ss, x, y, z, "x = z", "z = y", "x = y");
        Fatal() << ss.str();
      }
    } else if (xz == analysis::LatticeComparison::LESS &&
               yz == analysis::LatticeComparison::GREATER) {
      if (xy != analysis::LatticeComparison::LESS) {
        std::stringstream ss;
        transitivityErrorPrinter<Lattice>(
          ss, x, y, z, "x < z", "z < y", "x < y");
        Fatal() << ss.str();
      }
    } else if (xz == analysis::LatticeComparison::GREATER &&
               yz == analysis::LatticeComparison::LESS) {
      if (xy != analysis::LatticeComparison::GREATER) {
        std::stringstream ss;
        transitivityErrorPrinter<Lattice>(
          ss, x, y, z, "x > z", "z > y", "x > y");
        Fatal() << ss.str();
      }
    } else if (xy == analysis::LatticeComparison::EQUAL &&
               xz == analysis::LatticeComparison::EQUAL) {
      if (yz != analysis::LatticeComparison::EQUAL) {
        std::stringstream ss;
        transitivityErrorPrinter<Lattice>(
          ss, x, y, z, "y = x", "x = z", "y = z");
        Fatal() << ss.str();
      }
    } else if (xy == analysis::LatticeComparison::LESS &&
               xz == analysis::LatticeComparison::GREATER) {
      if (yz != analysis::LatticeComparison::GREATER) {
        std::stringstream ss;
        transitivityErrorPrinter<Lattice>(
          ss, x, y, z, "y > x", "x > z", "y > z");
        Fatal() << ss.str();
      }
    } else if (xy == analysis::LatticeComparison::GREATER &&
               xz == analysis::LatticeComparison::LESS) {
      if (yz != analysis::LatticeComparison::LESS) {
        std::stringstream ss;
        transitivityErrorPrinter<Lattice>(
          ss, x, y, z, "y < x", "x < z", "y < z");
        Fatal() << ss.str();
      }
    }
  }

  // Given two input - output lattice pairs of a transfer function, checks if
  // the transfer function is monotonic. If this is violated, then we print out
  // the CFG block input which caused the transfer function to exhibit
  // non-monotonic behavior.
  template<typename Lattice>
  void checkMonotonicity(Lattice& lattice,
                         std::string transferFunctionName,
                         const analysis::BasicBlock* cfgBlock,
                         typename Lattice::Element& first,
                         typename Lattice::Element& second,
                         typename Lattice::Element& firstResult,
                         typename Lattice::Element& secondResult) {
    analysis::LatticeComparison beforeCmp = lattice.compare(first, second);
    analysis::LatticeComparison afterCmp =
      lattice.compare(firstResult, secondResult);

    // Cases in which monotonicity is preserved.
    if (beforeCmp == analysis::LatticeComparison::NO_RELATION) {
      // If there is no relation in the first place, we can't expect anything.
      return;
    } else if (beforeCmp == analysis::LatticeComparison::LESS &&
               (afterCmp == analysis::LatticeComparison::LESS ||
                afterCmp == analysis::LatticeComparison::EQUAL)) {
      // x < y and f(x) <= f(y)
      return;
    } else if (beforeCmp == analysis::LatticeComparison::GREATER &&
               (afterCmp == analysis::LatticeComparison::GREATER ||
                afterCmp == analysis::LatticeComparison::EQUAL)) {
      // x > y and f(x) >= f(y)
      return;
    } else if (beforeCmp == analysis::LatticeComparison::EQUAL &&
               afterCmp == analysis::LatticeComparison::EQUAL) {
      // x = y and f(x) = f(y)
      return;
    }

    std::stringstream ss;

    ss << "The lattice elements ";
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
  void check(analysis::CFG& cfg,
             Lattice& lattice,
             TransferFunction& transferFunction,
             std::string transferFuncName) {
    for (auto cfgIter = cfg.begin(); cfgIter != cfg.end(); ++cfgIter) {
      typename Lattice::Element x = lattice.getRandom(rand);
      typename Lattice::Element y = lattice.getRandom(rand);
      typename Lattice::Element z = lattice.getRandom(rand);

      // Check lattice properties
      checkReflexivity<Lattice>(lattice, x);
      checkReflexivity<Lattice>(lattice, y);
      checkReflexivity<Lattice>(lattice, z);
      checkAntiSymmetry<Lattice>(lattice, x, y);
      checkAntiSymmetry<Lattice>(lattice, x, z);
      checkAntiSymmetry<Lattice>(lattice, y, z);
      checkTransitivity<Lattice>(lattice, x, y, z);

      // Apply transfer function on each lattice element.
      typename Lattice::Element xResult = x;
      transferFunction.transfer(&(*cfgIter), xResult);
      typename Lattice::Element yResult = y;
      transferFunction.transfer(&(*cfgIter), yResult);
      typename Lattice::Element zResult = z;
      transferFunction.transfer(&(*cfgIter), zResult);

      // Check monotonicity for every pair of transfer function outputs.
      checkMonotonicity<Lattice>(
        lattice, transferFuncName, &(*cfgIter), x, y, xResult, yResult);
      checkMonotonicity<Lattice>(
        lattice, transferFuncName, &(*cfgIter), x, z, xResult, zResult);
      checkMonotonicity<Lattice>(
        lattice, transferFuncName, &(*cfgIter), y, z, yResult, zResult);
    }
  }

  // Checks properties of the LivenessTransferFunction on a randomly generated
  // module function.
  void checkLivenessTransferFunction(analysis::CFG& cfg, Function* func) {
    analysis::FiniteIntPowersetLattice lattice(func->getNumLocals());
    analysis::LivenessTransferFunction transferFunction;

    check<analysis::FiniteIntPowersetLattice,
          analysis::LivenessTransferFunction>(
      cfg, lattice, transferFunction, "LivenessTransferFunction");
  }

  // Checks properties of the ReachingDefinitionsTransferFunction on a randomly
  // generated module function.
  void checkReachingDefinitionsTransferFunction(analysis::CFG& cfg,
                                                Function* func) {
    LocalGraph::GetSetses getSetses;
    LocalGraph::Locations locations;
    analysis::ReachingDefinitionsTransferFunction transferFunction(
      func, getSetses, locations);
    check<analysis::FinitePowersetLattice<LocalSet*>,
          analysis::ReachingDefinitionsTransferFunction>(
      cfg,
      transferFunction.lattice,
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

    for (auto& func : testModule.functions) {
      Function* currFunc = func.get();
      // Imported functions can't be fuzzed here as they don't have a body.
      if (currFunc->imported()) {
        continue;
      }
      analysis::CFG cfg = analysis::CFG::fromFunction(currFunc);

      checkLivenessTransferFunction(cfg, currFunc);
      checkReachingDefinitionsTransferFunction(cfg, currFunc);
    }
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
