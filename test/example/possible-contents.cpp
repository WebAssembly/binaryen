#include <cassert>
#include <iostream>

#include "ir/possible-contents.h"
#include "wasm-s-parser.h"
#include "wasm.h"

using namespace wasm;

// Asserts a == b, in any order.
template<typename T> void assertEqualSymmetric(const T& a, const T& b) {
  std::cout << "\nassertEqualSymmetric\n";
  a.dump(std::cout);
  std::cout << '\n';
  b.dump(std::cout);
  std::cout << '\n';

  assert(a == b);
  assert(b == a);
  assert(!(a != b));
  assert(!(b != a));
}

// Asserts a != b, in any order.
template<typename T> void assertNotEqualSymmetric(const T& a, const T& b) {
  std::cout << "\nassertNotEqualSymmetric\n";
  a.dump(std::cout);
  std::cout << '\n';
  b.dump(std::cout);
  std::cout << '\n';

  assert(a != b);
  assert(b != a);
  assert(!(a == b));
  assert(!(b == a));
}

auto none_ = PossibleContents::none();

auto i32Zero = PossibleContents::literal(Literal(int32_t(0)));
auto i32One = PossibleContents::literal(Literal(int32_t(1)));
auto f64One = PossibleContents::literal(Literal(double(1)));
auto anyNull = PossibleContents::literal(Literal::makeNull(HeapType::any));
auto funcNull = PossibleContents::literal(Literal::makeNull(HeapType::func));

auto i32Global1 = PossibleContents::global("i32Global1", Type::i32);
auto i32Global2 = PossibleContents::global("i32Global2", Type::i32);
auto f64Global = PossibleContents::global("f64Global", Type::f64);
auto anyGlobal = PossibleContents::global("anyGlobal", Type::anyref);

auto func = PossibleContents::literal(
  Literal("func", Type(Signature(Type::none, Type::none), NonNullable)));

auto exactI32 = PossibleContents::exactType(Type::i32);
auto exactAnyref = PossibleContents::exactType(Type::anyref);
auto exactFuncref = PossibleContents::exactType(Type::funcref);
auto exactNonNullAnyref =
  PossibleContents::exactType(Type(HeapType::any, NonNullable));
auto exactNonNullFuncref =
  PossibleContents::exactType(Type(HeapType::func, NonNullable));

auto exactFuncSignatureType = PossibleContents::exactType(
  Type(Signature(Type::none, Type::none), Nullable));
auto exactNonNullFuncSignatureType = PossibleContents::exactType(
  Type(Signature(Type::none, Type::none), NonNullable));

auto many = PossibleContents::many();

static void testComparisons() {
  assertEqualSymmetric(none_, none_);
  assertNotEqualSymmetric(none_, i32Zero);
  assertNotEqualSymmetric(none_, i32Global1);
  assertNotEqualSymmetric(none_, exactI32);
  assertNotEqualSymmetric(none_, many);

  assertEqualSymmetric(i32Zero, i32Zero);
  assertNotEqualSymmetric(i32Zero, i32One);
  assertNotEqualSymmetric(i32Zero, f64One);
  assertNotEqualSymmetric(i32Zero, i32Global1);
  assertNotEqualSymmetric(i32Zero, exactI32);
  assertNotEqualSymmetric(i32Zero, many);

  assertEqualSymmetric(i32Global1, i32Global1);
  assertNotEqualSymmetric(i32Global1, i32Global2);
  assertNotEqualSymmetric(i32Global1, exactI32);
  assertNotEqualSymmetric(i32Global1, many);

  assertEqualSymmetric(exactI32, exactI32);
  assertNotEqualSymmetric(exactI32, exactAnyref);
  assertNotEqualSymmetric(exactI32, many);

  assertEqualSymmetric(many, many);

  // Nulls

  assertNotEqualSymmetric(i32Zero, anyNull);
  assertEqualSymmetric(anyNull, anyNull);
  assertEqualSymmetric(anyNull, funcNull); // All nulls compare equal.

  assertEqualSymmetric(exactNonNullAnyref, exactNonNullAnyref);
  assertNotEqualSymmetric(exactNonNullAnyref, exactAnyref);
}

// Asserts a combined with b (in any order) is equal to c.
template<typename T>
void assertCombination(const T& a, const T& b, const T& c) {
  std::cout << "\nassertCombination\n";
  a.dump(std::cout);
  std::cout << '\n';
  b.dump(std::cout);
  std::cout << '\n';
  c.dump(std::cout);
  std::cout << '\n';

  T temp1 = a;
  temp1.combine(b);
  temp1.dump(std::cout);
  std::cout << '\n';
  assertEqualSymmetric(temp1, c);

  T temp2 = b;
  temp2.combine(a);
  temp2.dump(std::cout);
  std::cout << '\n';
  assertEqualSymmetric(temp2, c);
}

static void testCombinations() {
  // None with anything else becomes the other thing.
  assertCombination(none_, none_, none_);
  assertCombination(none_, i32Zero, i32Zero);
  assertCombination(none_, i32Global1, i32Global1);
  assertCombination(none_, exactI32, exactI32);
  assertCombination(none_, many, many);

  // i32(0) will become Many, unless the value is identical. (We could do
  // exactI32 if only the values differ, but there is no point as subtyping
  // does not exist for this type, and so Many is just as informative.)
  assertCombination(i32Zero, i32Zero, i32Zero);
  assertCombination(i32Zero, i32One, many);
  assertCombination(i32Zero, f64One, many);
  assertCombination(i32Zero, i32Global1, many);
  assertCombination(i32Zero, f64Global, many);
  assertCombination(i32Zero, exactI32, many);
  assertCombination(i32Zero, exactAnyref, many);
  assertCombination(i32Zero, many, many);

  assertCombination(i32Global1, i32Global1, i32Global1);
  assertCombination(i32Global1, i32Global2, many);
  assertCombination(i32Global1, f64Global, many);
  assertCombination(i32Global1, exactI32, many);
  assertCombination(i32Global1, exactAnyref, many);
  assertCombination(i32Global1, many, many);

  assertCombination(exactI32, exactI32, exactI32);
  assertCombination(exactI32, exactAnyref, many);
  assertCombination(exactI32, many, many);

  assertCombination(many, many, many);

  // Exact references: An exact reference only stays exact when combined with
  // the same heap type (nullability may be added, but nothing else).
  assertCombination(exactFuncref, exactAnyref, many);
  assertCombination(exactFuncref, anyGlobal, many);
  assertCombination(exactFuncref, func, many);
  assertCombination(exactFuncref, exactFuncref, exactFuncref);
  assertCombination(exactFuncref, exactNonNullFuncref, exactFuncref);

  std::cout << "\nnulls\n";

  assertCombination(anyNull, i32Zero, many);
  assertCombination(anyNull, anyNull, anyNull);
  assertCombination(anyNull, exactAnyref, exactAnyref);

  // Two nulls go to the lub.
  assertCombination(anyNull, funcNull, anyNull);

  assertCombination(exactNonNullAnyref, exactNonNullAnyref, exactNonNullAnyref);

  // If one is a null and the other is not, it makes the one that is not a null
  // be a nullable type - but keeps the heap type of the other (since the type
  // of the null does not matter, all nulls compare equal).
  assertCombination(anyNull, exactNonNullAnyref, exactAnyref);
  assertCombination(anyNull, exactNonNullFuncref, exactFuncref);

  std::cout << "\nfuncrefs\n";

  // A function reference + a null becomes an exact type (of that sig), plus
  // nullability.
  assertCombination(func, anyNull, exactFuncSignatureType);
  assertCombination(func, funcNull, exactFuncSignatureType);
  assertCombination(exactFuncSignatureType, funcNull, exactFuncSignatureType);
  assertCombination(
    exactNonNullFuncSignatureType, funcNull, exactFuncSignatureType);
  assertCombination(func, exactFuncSignatureType, exactFuncSignatureType);
  assertCombination(
    func, exactNonNullFuncSignatureType, exactNonNullFuncSignatureType);
  assertCombination(func, exactI32, many);

  std::cout << "\nglobals vs nulls\n";

  assertCombination(anyGlobal, anyNull, many);
  assertCombination(anyGlobal, funcNull, many);
}

// Parse a module from text and return it.
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

static void testOracle() {
  {
    // A minimal test of the public API of PossibleTypesOracle. See the lit test
    // for coverage of all the internals (using lit makes the result more
    // fuzzable).
    auto wasm = parse(R"(
      (module
        (type $struct (struct))
        (global $null (ref null any) (ref.null any))
        (global $something i32 (i32.const 42))
      )
    )");
    ContentOracle oracle(*wasm);

    // This will be a null constant.
    std::cout << "possible types of the $null global: ";
    oracle.getContents(GlobalLocation{"null"}).dump(std::cout);
    std::cout << '\n';

    // This will be 42.
    std::cout << "possible types of the $something global: ";
    oracle.getContents(GlobalLocation{"something"}).dump(std::cout);
    std::cout << '\n';
  }

  {
    // Test for a node with many possible types. The pass limits how many it
    // notices to not use excessive memory, so even though 4 are possible here,
    // we'll just report that more than one is possible ("many").
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
    std::cout << "possible types of the function's body: ";
    oracle.getContents(ResultLocation{wasm->getFunction("foo")}).dump(std::cout);
    std::cout << '\n';
  }
}

int main() {
  // Use nominal typing to test struct types.
  wasm::setTypeSystem(TypeSystem::Nominal);

  testComparisons();
  std::cout << '\n';
  testCombinations();
  std::cout << '\n';
  testOracle();
  std::cout << '\n';

  std::cout << "\nok.\n";
}
