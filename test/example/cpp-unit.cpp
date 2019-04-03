// test multiple uses of the threadPool

#include <assert.h>

#include <wasm.h>
#include <ir/cost.h>

using namespace wasm;

int main() 
{
  // Some optimizations assume that the cost of a get is zero, e.g. local-cse.
  GetLocal get;
  assert(CostAnalyzer(&get).cost == 0);

  std::cout << "Success.\n";
  return 0;
}
