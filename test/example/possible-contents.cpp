#include <cassert>
#include <iostream>

#include "ir/possible-contents.h"
#include "wasm-s-parser.h"
#include "wasm.h"

using namespace wasm;

static std::unique_ptr<Module> parse(std::string module) {
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

template<typename T>
void assertEqualSymmetric(const T& a, const T& b) {
  assert(a == b);
  assert(b == a);
}

template<typename T>
void assertNotEqualSymmetric(const T& a, const T& b) {
  assert(a != b);
  assert(b != a);
  assert(!(a == b));
  assert(!(b == a));
}

static void testPossibleContents() {
  auto none_ = PossibleContents::none();

  auto i32Zero = PossibleContents::constantLiteral(Literal(int32_t(0)));
  auto f64One = PossibleContents::constantLiteral(Literal(double(1)));

  auto global1 = PossibleContents::constantGlobal("global1", Type::i32);
  auto global2 = PossibleContents::constantGlobal("global2", Type::i32);

  auto exactI32 = PossibleContents::exactType(Type::i32);
  auto exactAnyref = PossibleContents::exactType(Type::anyref);

  auto many = PossibleContents::many();
  
  assertEqualSymmetric(none_, none_);
  assertNotEqualSymmetric(none_, i32Zero);
  assertNotEqualSymmetric(none_, global1);
  assertNotEqualSymmetric(none_, exactI32);
  assertNotEqualSymmetric(none_, many);

  assertEqualSymmetric(i32Zero, i32Zero);
  assertNotEqualSymmetric(i32Zero, f64One);
  assertNotEqualSymmetric(i32Zero, global1);
  assertNotEqualSymmetric(i32Zero, exactI32);
  assertNotEqualSymmetric(i32Zero, many);

  assertEqualSymmetric(global1, global1);
  assertNotEqualSymmetric(global1, global2);
  assertNotEqualSymmetric(global1, exactI32);
  assertNotEqualSymmetric(global1, many);

  assertEqualSymmetric(exactI32, exactI32);
  assertNotEqualSymmetric(exactI32, exactAnyref);
  assertNotEqualSymmetric(exactI32, many);

  assertEqualSymmetric(many, many);
}

static void testOracle() {
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
    ContentOracle oracle(*wasm);
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
    ContentOracle oracle(*wasm);
    std::cout
      << "possible types of the function's body: "
      << oracle.getTypes(ResultLocation{wasm->getFunction("foo")}).getType()
      << '\n';
  }
}

int main() {
  // Use nominal typing to test struct types.
  wasm::setTypeSystem(TypeSystem::Nominal);

  testPossibleContents();
  testOracle();

  std::cout << "ok.\n";
}
