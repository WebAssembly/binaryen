#include "ir/names.h"
#include "ir/utils.h"
#include "pass.h"
#include "passes/stringify-walker.h"
#include "support/suffix_tree.h"
#include "wasm.h"

#define OUTLINING_DEBUG 0

#if OUTLINING_DEBUG
#define DBG(statement) statement
#else
#define DBG(statement)
#endif

namespace wasm {

struct Outlining : public Pass {
  void run(Module* module) {
    HashStringifyWalker stringify;
    stringify.walkModule(module);
    auto substrings =
      StringifyProcessor::repeatSubstrings(stringify.hashString);
    DBG(printHashString(stringify.hashString, stringify.exprs));
    substrings = StringifyProcessor::dedupe(substrings);
    substrings =
      StringifyProcessor::filterBranches(substrings, stringify.exprs);
    substrings =
      StringifyProcessor::filterLocalSets(substrings, stringify.exprs);
    substrings =
      StringifyProcessor::filterLocalGets(substrings, stringify.exprs);

    auto sequences = makeSequences(module, substrings, stringify);
    outline(module, sequences);
  }

  Name addOutlinedFunction(Module* module,
                           const SuffixTree::RepeatedSubstring& substring,
                           const std::vector<Expression*>& exprs) {
    auto startIdx = substring.StartIndices[0];
    // The outlined functions can be named anything. Use the start index of
    // the first time the outlined sequence was seen in the module to help
    // with debugging later.
    Name outlinedFunc = Names::getValidFunctionName(
      *module, std::string("outline$") + std::to_string(startIdx));
    // Calculate the function signature for the outlined sequence.
    StackSignature sig;
    for (uint32_t exprIdx = startIdx; exprIdx < startIdx + substring.Length;
         exprIdx++) {
      sig += StackSignature(exprs[exprIdx]);
    }
    module->addFunction(Builder::makeFunction(
      outlinedFunc, Signature(sig.params, sig.results), {}));
    return outlinedFunc;
  }

  using Sequences =
    std::unordered_map<Name, std::vector<wasm::OutliningSequence>>;

  // Converts an array of SuffixTree::RepeatedSubstring to a mapping of original
  // functions to repeated sequences they contain.
  Sequences makeSequences(Module* module,
                          const Substrings& substrings,
                          const HashStringifyWalker& stringify) {
    Sequences seqByFunc;
    for (auto& substring : substrings) {
      Name outlinedFunc =
        addOutlinedFunction(module, substring, stringify.exprs);
      for (auto seqIdx : substring.StartIndices) {
        // seqIdx is relative to the entire program; making the idx of the
        // sequence relative to its function makes outlining easier because we
        // walk functions
        auto [relativeIdx, existingFunc] = stringify.makeRelative(seqIdx);
        auto seq = OutliningSequence(
          relativeIdx, relativeIdx + substring.Length, outlinedFunc);
        seqByFunc[existingFunc].push_back(seq);
      }
    }
    return seqByFunc;
  }

  void outline(Module* module, Sequences seqByFunc) {
    // TODO: Make this a function-parallel sub-pass.
    ReconstructStringifyWalker reconstruct(module);
    std::vector<Name> keys(seqByFunc.size());
    std::transform(seqByFunc.begin(), seqByFunc.end(), keys.begin(), [](auto pair) { return pair.first; });
    for (auto func : keys) {
      reconstruct.sequences = std::move(seqByFunc[func]);
      reconstruct.doWalkFunction(module->getFunction(func));
    }
  }

#if OUTLINING_DEBUG
  void printHashString(const std::vector<uint32_t>& hashString,
                       const std::vector<Expression*>& exprs) {
    std::cout << "\n\n";
    for (Index idx = 0; idx < hashString.size(); idx++) {
      Expression* expr = exprs[idx];
      if (expr) {
        std::cout << idx << " - " << hashString[idx] << ": "
                  << ShallowExpression{expr} << "\n";
      } else {
        std::cout << idx << ": unique symbol\n";
      }
    }
  }
#endif
};

Pass* createOutliningPass() { return new Outlining(); }

} // namespace wasm
