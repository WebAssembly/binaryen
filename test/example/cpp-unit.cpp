// test multiple uses of the threadPool

#include <iostream>

#include <ir/bits.h>
#include <ir/cost.h>
#include <wasm.h>

using namespace wasm;

void compare(size_t x, size_t y) {
  if (x != y) {
    std::cout << "comparison error!\n" << x << '\n' << y << '\n';
    abort();
  }
}

void test_bits() {
  Const c;
  c.type = Type::i32;
  c.value = Literal(int32_t(1));
  compare(Bits::getMaxBits(&c), 1);
  c.value = Literal(int32_t(2));
  compare(Bits::getMaxBits(&c), 2);
  c.value = Literal(int32_t(3));
  compare(Bits::getMaxBits(&c), 2);
}

void test_cost() {
  // Some optimizations assume that the cost of a get is zero, e.g. local-cse.
  LocalGet get;
  compare(CostAnalyzer(&get).cost, 0);
}

int main() {
  test_bits();

  test_cost();

  std::cout << "Success.\n";
  return 0;
}
