// test multiple uses of the threadPool

#include <iostream>

#include <ir/bits.h>
#include <ir/cost.h>
#include <wasm.h>

using namespace wasm;

#define FG_RED    "\x1b[31m"
#define FG_GREEN  "\x1b[32m"
#define FG_BLACK  "\x1b[30m"
#define FG_YELLOW "\x1b[33m"

#define BG_RED   "\x1b[41m"
#define BG_BLACK "\x1b[40m"

#define RESET    "\x1b[0m"

static int failsCount = 0;

template<typename T, typename U>
void assert_equal_(T a, U b, int line, const char* file) {
  if (a != b) {
    std::cerr << '\n'
              << BG_RED FG_BLACK << "  ASSERTION ERROR    "
              << ++failsCount    << "    "
              << RESET FG_RED    << "\n"
              << FG_RED          << "   Actual:   " << a << '\n'
              << FG_GREEN        << "   Expected: " << b << "\n\n"
              << FG_YELLOW       << "   Line: "     << line << '\n'
              << FG_YELLOW       << "   File: "     << file << '\n'
              << RESET           << std::endl;

    std::cout << "actual: "     << a
              << ", expected: " << b
              << ", line "      << line
              << ", file "      << file
              << std::endl;
  }
}

#define assert_equal(a, b) assert_equal_((a), (b), __LINE__, __FILE__)

void test_bits() {
  Const c0, c1;
  Binary b;

  b.left = &c0;
  b.right = &c1;

  // --- //
  // i32 //
  // --- //

  c0.type = Type::i32;
  c1.type = Type::i32;
  b.type  = Type::i32;

  c0.value = Literal(int32_t(0));
  assert_equal(Bits::getMaxBits(&c0), 0);
  c0.value = Literal(int32_t(1));
  assert_equal(Bits::getMaxBits(&c0), 1);
  c0.value = Literal(int32_t(2));
  assert_equal(Bits::getMaxBits(&c0), 2);
  c0.value = Literal(int32_t(0x80000));
  assert_equal(Bits::getMaxBits(&c0), 20);
  c0.value = Literal(int32_t(-1));
  assert_equal(Bits::getMaxBits(&c0), 32);

  b.op = AddInt32;
  c0.value = Literal(int32_t(0xFFFF));
  c1.value = Literal(int32_t(0x11));
  assert_equal(Bits::getMaxBits(&b), 32);
  c0.value = Literal(int32_t(-1));
  c1.value = Literal(int32_t(2));
  assert_equal(Bits::getMaxBits(&b), 32);

  b.op = SubInt32;
  c0.value = Literal(int32_t(0xFFFF));
  c1.value = Literal(int32_t(0x11));
  assert_equal(Bits::getMaxBits(&b), 32);
  c0.value = Literal(int32_t(-1));
  c1.value = Literal(int32_t(2));
  assert_equal(Bits::getMaxBits(&b), 32);

  b.op = MulInt32;
  c0.value = Literal(int32_t(0xFFFF));
  c1.value = Literal(int32_t(0x11));
  assert_equal(Bits::getMaxBits(&b), 21);
  c0.value = Literal(int32_t(0));
  c1.value = Literal(int32_t(1));
  assert_equal(Bits::getMaxBits(&b), 0);
  c0.value = Literal(int32_t(1));
  c1.value = Literal(int32_t(0));
  assert_equal(Bits::getMaxBits(&b), 0);
  c0.value = Literal(int32_t(3));
  c1.value = Literal(int32_t(3));
  assert_equal(Bits::getMaxBits(&b), 4);
  c0.value = Literal(int32_t(2));
  c1.value = Literal(int32_t(-2));
  assert_equal(Bits::getMaxBits(&b), 32);

  b.op = DivSInt32;
  c0.value = Literal(int32_t(0));
  c1.value = Literal(int32_t(0xF));
  assert_equal(Bits::getMaxBits(&b), 0);
  c0.value = Literal(int32_t( 1));
  c1.value = Literal(int32_t( 2));
  assert_equal(Bits::getMaxBits(&b), 0);
  c0.value = Literal(int32_t(0xFF));
  c1.value = Literal(int32_t(0xFF));
  assert_equal(Bits::getMaxBits(&b), 1);
  c0.value = Literal(int32_t(-1));
  c1.value = Literal(int32_t( 1));
  assert_equal(Bits::getMaxBits(&b), 32);
  c0.value = Literal(int32_t(-1));
  c1.value = Literal(int32_t( 2));
  assert_equal(Bits::getMaxBits(&b), 32);
  c0.value = Literal(int32_t(0x7FFFFFFF));
  c1.value = Literal(int32_t(3));
  assert_equal(Bits::getMaxBits(&b), 30);
  c0.value = Literal(int32_t(0x80000000));
  c1.value = Literal(int32_t(-1));
  assert_equal(Bits::getMaxBits(&b), 32);


  b.op = DivUInt32;
  c0.value = Literal(uint32_t(0));
  c1.value = Literal(uint32_t(0xF));
  assert_equal(Bits::getMaxBits(&b), 0);
  c0.value = Literal(uint32_t( 1));
  c1.value = Literal(uint32_t( 2));
  assert_equal(Bits::getMaxBits(&b), 0);
  c0.value = Literal(uint32_t(0xFF));
  c1.value = Literal(uint32_t(0xFF));
  assert_equal(Bits::getMaxBits(&b), 1);
  c0.value = Literal(uint32_t(-1));
  c1.value = Literal(uint32_t( 1));
  assert_equal(Bits::getMaxBits(&b), 32);
  c0.value = Literal(uint32_t(-1));
  c1.value = Literal(uint32_t( 2));
  assert_equal(Bits::getMaxBits(&b), 31);
  c0.value = Literal(uint32_t(0x7FFFFFFF));
  c1.value = Literal(uint32_t(3));
  assert_equal(Bits::getMaxBits(&b), 30);
  c0.value = Literal(uint32_t(0x80000000));
  c1.value = Literal(uint32_t(-1));
  assert_equal(Bits::getMaxBits(&b), 1);


  // --- //
  // i64 //
  // --- //

  c0.type = Type::i64;
  c1.type = Type::i64;
  b.type  = Type::i64;

  // Const: i64

  c0.value = Literal(int64_t(0));
  assert_equal(Bits::getMaxBits(&c0), 0);
  c0.value = Literal(int64_t(1));
  assert_equal(Bits::getMaxBits(&c0), 1);
  c0.value = Literal(int64_t(2));
  assert_equal(Bits::getMaxBits(&c0), 2);
  c0.value = Literal(int64_t(0x80000));
  assert_equal(Bits::getMaxBits(&c0), 20);
  c0.value = Literal(int64_t(-1));
  assert_equal(Bits::getMaxBits(&c0), 64);

  b.op = AddInt64;
  c0.value = Literal(int64_t(0xFFFF));
  c1.value = Literal(int64_t(0x11));
  assert_equal(Bits::getMaxBits(&b), 64);
  c0.value = Literal(int64_t(-1));
  c1.value = Literal(int64_t(2));
  assert_equal(Bits::getMaxBits(&b), 64);

  b.op = SubInt64;
  c0.value = Literal(int64_t(0xFFFF));
  c1.value = Literal(int64_t(0x11));
  assert_equal(Bits::getMaxBits(&b), 64);
  c0.value = Literal(int64_t(-1));
  c1.value = Literal(int64_t(2));
  assert_equal(Bits::getMaxBits(&b), 64);

  b.op = MulInt64;
  c0.value = Literal(int64_t(0xFFFF));
  c1.value = Literal(int64_t(0x11));
  assert_equal(Bits::getMaxBits(&b), 21);
  c0.value = Literal(int64_t(0));
  c1.value = Literal(int64_t(1));
  assert_equal(Bits::getMaxBits(&b), 0);
  c0.value = Literal(int64_t(1));
  c1.value = Literal(int64_t(0));
  assert_equal(Bits::getMaxBits(&b), 0);
  c0.value = Literal(int64_t(3));
  c1.value = Literal(int64_t(3));
  assert_equal(Bits::getMaxBits(&b), 4);
  c0.value = Literal(int64_t(2));
  c1.value = Literal(int64_t(-2));
  assert_equal(Bits::getMaxBits(&b), 64);

  b.op = DivSInt64;
  c0.value = Literal(int64_t(0));
  c1.value = Literal(int64_t(0xF));
  assert_equal(Bits::getMaxBits(&b), 0);
  c0.value = Literal(int64_t( 1));
  c1.value = Literal(int64_t( 2));
  assert_equal(Bits::getMaxBits(&b), 0);
  c0.value = Literal(int64_t(0xFF));
  c1.value = Literal(int64_t(0xFF));
  assert_equal(Bits::getMaxBits(&b), 1);
  c0.value = Literal(int64_t(-1));
  c1.value = Literal(int64_t( 1));
  assert_equal(Bits::getMaxBits(&b), 64);
  c0.value = Literal(int64_t(-1));
  c1.value = Literal(int64_t( 2));
  assert_equal(Bits::getMaxBits(&b), 64);
  c0.value = Literal(int64_t(0x7FFFFFFFFFFFFFFF));
  c1.value = Literal(int64_t(3));
  assert_equal(Bits::getMaxBits(&b), 62);
  c0.value = Literal(int64_t(0x8000000000000000));
  c1.value = Literal(int64_t(-1));
  assert_equal(Bits::getMaxBits(&b), 64);


  b.op = DivUInt64;
  c0.value = Literal(uint64_t(0));
  c1.value = Literal(uint64_t(0xF));
  assert_equal(Bits::getMaxBits(&b), 0);
  c0.value = Literal(uint64_t( 1));
  c1.value = Literal(uint64_t( 2));
  assert_equal(Bits::getMaxBits(&b), 0);
  c0.value = Literal(uint64_t(0xFF));
  c1.value = Literal(uint64_t(0xFF));
  assert_equal(Bits::getMaxBits(&b), 1);
  c0.value = Literal(uint64_t(-1));
  c1.value = Literal(uint64_t( 1));
  assert_equal(Bits::getMaxBits(&b), 64);
  c0.value = Literal(uint64_t(-1));
  c1.value = Literal(uint64_t( 2));
  assert_equal(Bits::getMaxBits(&b), 63);
  c0.value = Literal(uint64_t(0x7FFFFFFFFFFFFFFF));
  c1.value = Literal(uint64_t(3));
  assert_equal(Bits::getMaxBits(&b), 62);
  c0.value = Literal(uint64_t(0x8000000000000000));
  c1.value = Literal(uint64_t(-1));
  assert_equal(Bits::getMaxBits(&b), 1);
}

void test_cost() {
  // Some optimizations assume that the cost of a get is zero, e.g. local-cse.
  LocalGet get;
  assert_equal(CostAnalyzer(&get).cost, 0);
}

int main() {
  test_bits();
  test_cost();

  if (failsCount > 0) {
    abort();
  } else {
    std::cout << "Success" << std::endl;
  }
  return 0;
}
