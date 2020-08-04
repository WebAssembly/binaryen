// test multiple uses of the threadPool

#include <iostream>

#include <ir/bits.h>
#include <ir/cost.h>
#include <wasm.h>

using namespace wasm;

#define FG_RED   "\x1b[31m"
#define FG_GREEN "\x1b[32m"
#define FG_BLACK "\x1b[30m"

#define BG_RED   "\x1b[41m"
#define BG_BLACK "\x1b[40m"

#define RESET    "\x1b[0m"

template<typename T, typename U>
void assert_equal(T x, U y) {
  if (x != y) {
    std::cerr << '\n'
              << BG_RED FG_BLACK << "  ASSERTION ERROR       " << RESET FG_RED << "\n"
              << FG_RED          << "   Actual:   " << x << '\n'
              << FG_GREEN        << "   Expected: " << y << '\n'
              << RESET           << std::endl;
    abort();
  }
}

void test_bits() {
  Const c;
  c.type = Type::i32;
  c.value = Literal(int32_t(1));
  assert_equal(Bits::getMaxBits(&c), 1);
  c.value = Literal(int32_t(2));
  assert_equal(Bits::getMaxBits(&c), 2);
  c.value = Literal(int32_t(3));
  assert_equal(Bits::getMaxBits(&c), 2);
}

void test_cost() {
  // Some optimizations assume that the cost of a get is zero, e.g. local-cse.
  LocalGet get;
  assert_equal(CostAnalyzer(&get).cost, 0);
}

int main() {
  test_bits();

  test_cost();

  std::cout << "Success" << std::endl;
  return 0;
}
