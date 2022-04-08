#include <cassert>
#include <iostream>

#include "ir/possible-types.h"
#include "wasm-s-parser.h"
#include "wasm.h"

using namespace wasm;
using namespace wasm::PossibleTypes;

std::unique_ptr<Module> parse(std::string module) {
  auto wasm = std::make_unique<Module>();
  wasm->features = FeatureSet::All;
  try {
    SExpressionParser parser(&module.front());
    Element& root = *parser.root;
    SExpressionWasmBuilder builder(*wasm, *root[0], IRProfile::Normal);
  } catch (ParseException& p) {
    p.dump(std::cerr);
    Fatal() << "error in parsing wasm text";
  }
  return wasm;
}

int main() {
  // PossibleTypes requires nominal typing (to find super types).
  wasm::setTypeSystem(TypeSystem::Nominal);

  // A minimal test of the public API of PossibleTypesOracle. See the lit test
  // for coverage of all the internals (using lit makes the result more
  // fuzzable).
  auto wasm = parse(R"(
    (module
      (type $struct (struct))
      (global $null (ref null any) (ref.null any))
      (global $something (ref null any) (struct.new $struct))
    )
  )");
  Oracle oracle(*wasm);
  std::cout << "# of possible types of the $null global: "
            << oracle.getTypes(GlobalLocation{"foo"})[0].size() << '\n';
  std::cout << "# of possible types of the $something global: "
            << oracle.getTypes(GlobalLocation{"something"})[0].size() << '\n';
  for (auto t : oracle.getTypes(GlobalLocation{"something"})[0]) {
    std::cout << "  type: " << t << "\n";
  }

  // TODO: testcase with 2 possible types, as that is not checked by
  //       PossibleTypes yet
}
