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
    printStats(substrings, result, &stringify);
  }

  void printStats(std::vector<SuffixTree::RepeatedSubstring> substrings,
                  std::vector<SuffixTree::RepeatedSubstring> result,
                  HashStringifyWalker* stringify) {
    std::cout << substrings.size() << " substrings found, ";
    std::cout << "reduced to " << result.size() << std::endl;
    for (auto rs : result) {
      size_t startIndex = rs.StartIndices[0];
      std::cout << rs.StartIndices.size() << "x, ~"
                << rs.StartIndices.size() * rs.Length * Measurer::BytesPerExpr
                << " size:";
      for (size_t i = startIndex; i < startIndex + rs.Length; i++) {
        std::cout << stringify->hashString[i] << " ("
                  << ShallowExpression{stringify->exprs[i]} << "), ";
      }
      std::cout << std::endl;
    }
  }
};

Pass* createOutliningEvalPass() { return new OutliningEval(); }

} // namespace wasm
