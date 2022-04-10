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

  {
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
    std::cout << "possible types of the $null global: "
              << oracle.getTypes(GlobalLocation{"foo"}).getType() << '\n';
    std::cout << "possible types of the $something global: "
              << oracle.getTypes(GlobalLocation{"something"}).getType() << '\n';
  }

  {
    // Test for a node with many possible types. The pass limits how many it
    // notices to not use excessive memory, so even though 4 are possible here,
    // we'll just report that more than one is possible using Type::none).
    auto wasm = parse(R"(
      (module
        (type $A (struct_subtype (field i32) data))
        (type $B (struct_subtype (field i64) data))
        (type $C (struct_subtype (field f32) data))
        (type $D (struct_subtype (field f64) data))
        (func $foo (result (ref any))
          (select (result (ref any))
            (select (result (ref any))
              (struct.new $A)
              (struct.new $B)
              (i32.const 0)
            )
            (select (result (ref any))
              (struct.new $C)
              (struct.new $D)
              (i32.const 0)
            )
            (i32.const 0)
          )
        )
      )
    )");
    Oracle oracle(*wasm);
    std::cout
      << "possible types of the function's body: "
      << oracle.getTypes(ResultLocation{wasm->getFunction("foo")}).getType()
      << '\n';
  }
}
