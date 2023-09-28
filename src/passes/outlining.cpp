#include "ir/utils.h"
#include "pass.h"
#include "passes/stringify-walker.h"
#include "support/suffix_tree.h"
#include "wasm.h"

namespace wasm {

struct OutliningEval : public Pass {
  void run(Module* module) {
    HashStringifyWalker stringify = HashStringifyWalker();
    stringify.walkModule(module);
    auto substrings =
      StringifyProcessor::repeatSubstrings(stringify.hashString);
    auto result = StringifyProcessor::dedupe(substrings);
    result = StringifyProcessor::filterBranches(result, stringify.exprs);
    result = StringifyProcessor::filterLocalSets(result, stringify.exprs);
    result = StringifyProcessor::filterExpensive(result, stringify.exprs);
    printStats(substrings, result, &stringify);
  }

  void printStats(std::vector<SuffixTree::RepeatedSubstring> substrings,
                  std::vector<SuffixTree::RepeatedSubstring> result,
                  HashStringifyWalker* stringify) {
    std::cout << substrings.size() << " repeat sequences found, ";
    std::cout << "reduced to " << result.size() << std::endl;
    std::cout << "sequences: " << std::endl;
    uint32_t totalSavings = 0;
    for (auto rs : result) {
      size_t startIndex = rs.StartIndices[0];
      uint32_t sizeSaved = StringifyProcessor::savings(rs, stringify->exprs) -
                           StringifyProcessor::cost(rs, stringify->exprs);
      totalSavings += sizeSaved;
      std::cout << "length " << rs.Length << " repeats "
                << rs.StartIndices.size() << "x, ~" << sizeSaved << " bytes:";
      for (size_t i = startIndex; i < startIndex + rs.Length; i++) {
        std::cout << " (" << ShallowExpression{stringify->exprs[i]} << "),";
      }
      std::cout << std::endl;
    }
    std::cout << "Total Savings: ~" << totalSavings << " bytes" << std::endl;
  }
};

Pass* createOutliningEvalPass() { return new OutliningEval(); }

} // namespace wasm
