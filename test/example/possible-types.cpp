#include <cassert>
#include <iostream>

#include "ir/possible-types.h"
#include "wasm-s-parser.h"
#include "wasm.h"

using namespace wasm;

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
  auto wasm = parse(R"(
    (module
    )
  )");
  PossibleTypesOracle oracle(*wasm);
}
