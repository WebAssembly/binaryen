// test multiple uses of the threadPool

#include <iostream>

#include <ir/bits.h>
#include <ir/cost.h>
#include <ir/effects.h>
#include <pass.h>
#include <support/unique_deferring_queue.h>
#include <wasm.h>

using namespace wasm;
using namespace Bits;

#define RESET "\x1b[0m"

#define FG_BLACK "\x1b[30m"
#define FG_RED "\x1b[31m"
#define FG_GREEN "\x1b[32m"
#define FG_YELLOW "\x1b[33m"

#define BG_BLACK "\x1b[40m"
#define BG_RED "\x1b[41m"

static int failsCount = 0;

template<typename T, typename U>
void assert_equal_(T a, U b, int line, const char* file) {
  if (a != b) {
    std::cerr << '\n'
              << BG_RED FG_BLACK << "  ASSERTION ERROR    " << ++failsCount
              << "    " << RESET FG_RED << "\n"
              << FG_RED << "   Actual:   " << a << '\n'
              << FG_GREEN << "   Expected: " << b << "\n\n"
              << FG_YELLOW << "   Line: " << line << '\n'
              << FG_YELLOW << "   File: " << file << '\n'
              << RESET << std::endl;

    std::cout << "actual: " << a << ", expected: " << b << ", line " << line
              << ", file " << file << std::endl;
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
  b.type = Type::i32;

  c0.value = Literal(int32_t(0));
  assert_equal(getMaxBits(&c0), 0);
  c0.value = Literal(int32_t(1));
  assert_equal(getMaxBits(&c0), 1);
  c0.value = Literal(int32_t(2));
  assert_equal(getMaxBits(&c0), 2);
  c0.value = Literal(int32_t(0x80000));
  assert_equal(getMaxBits(&c0), 20);
  c0.value = Literal(int32_t(-1));
  assert_equal(getMaxBits(&c0), 32);

  b.op = AddInt32;
  c0.value = Literal(int32_t(0xFFFF));
  c1.value = Literal(int32_t(0x11));
  assert_equal(getMaxBits(&b), 17);
  c0.value = Literal(int32_t(-1));
  c1.value = Literal(int32_t(2));
  assert_equal(getMaxBits(&b), 32);
  c0.value = Literal(int32_t(-1));
  c1.value = Literal(int32_t(-1));
  assert_equal(getMaxBits(&b), 32);

  b.op = SubInt32;
  c0.value = Literal(int32_t(0xFFFF));
  c1.value = Literal(int32_t(0x11));
  assert_equal(getMaxBits(&b), 32);
  c0.value = Literal(int32_t(-1));
  c1.value = Literal(int32_t(2));
  assert_equal(getMaxBits(&b), 32);
  c0.value = Literal(int32_t(2));
  c1.value = Literal(int32_t(-1));
  assert_equal(getMaxBits(&b), 32);
  c0.value = Literal(int32_t(0));
  c1.value = Literal(int32_t(1));
  assert_equal(getMaxBits(&b), 32);
  c0.value = Literal(int32_t(0x7FFFFFF0));
  c1.value = Literal(int32_t(0x7FFFFFFF));
  assert_equal(getMaxBits(&b), 32);
  c0.value = Literal(int32_t(1));
  c1.value = Literal(int32_t(1));
  assert_equal(getMaxBits(&b), 32);
  c0.value = Literal(int32_t(0));
  c1.value = Literal(int32_t(0x7FFFFFFF));
  assert_equal(getMaxBits(&b), 32);

  b.op = MulInt32;
  c0.value = Literal(int32_t(0xFFFF));
  c1.value = Literal(int32_t(0x11));
  assert_equal(getMaxBits(&b), 21);
  c0.value = Literal(int32_t(0));
  c1.value = Literal(int32_t(1));
  assert_equal(getMaxBits(&b), 1);
  c0.value = Literal(int32_t(1));
  c1.value = Literal(int32_t(0));
  assert_equal(getMaxBits(&b), 1);
  c0.value = Literal(int32_t(3));
  c1.value = Literal(int32_t(3));
  assert_equal(getMaxBits(&b), 4);
  c0.value = Literal(int32_t(2));
  c1.value = Literal(int32_t(-2));
  assert_equal(getMaxBits(&b), 32);

  b.op = DivSInt32;
  c0.value = Literal(int32_t(0));
  c1.value = Literal(int32_t(0xF));
  assert_equal(getMaxBits(&b), 0);
  c0.value = Literal(int32_t(1));
  c1.value = Literal(int32_t(2));
  assert_equal(getMaxBits(&b), 0);
  c0.value = Literal(int32_t(0xFF));
  c1.value = Literal(int32_t(0xFF));
  assert_equal(getMaxBits(&b), 1);
  c0.value = Literal(int32_t(-1));
  c1.value = Literal(int32_t(1));
  assert_equal(getMaxBits(&b), 32);
  c0.value = Literal(int32_t(-1));
  c1.value = Literal(int32_t(2));
  assert_equal(getMaxBits(&b), 32);
  c0.value = Literal(int32_t(0x7FFFFFFF));
  c1.value = Literal(int32_t(3));
  assert_equal(getMaxBits(&b), 30);
  c0.value = Literal(int32_t(0x0000FFFF));
  c1.value = Literal(int32_t(0xFF));
  assert_equal(getMaxBits(&b), 9);
  c0.value = Literal(int32_t(0x00001000));
  c1.value = Literal(int32_t(0x00000FFF));
  assert_equal(getMaxBits(&b), 2);
  c0.value = Literal(int32_t(0x80000000));
  c1.value = Literal(int32_t(-1));
  assert_equal(getMaxBits(&b), 32);
  c0.value = Literal(int32_t(2));
  c1.value = Literal(int32_t(-2));
  assert_equal(getMaxBits(&b), 32);

  b.op = DivUInt32;
  c0.value = Literal(uint32_t(0));
  c1.value = Literal(uint32_t(0xF));
  assert_equal(getMaxBits(&b), 0);
  c0.value = Literal(uint32_t(1));
  c1.value = Literal(uint32_t(2));
  assert_equal(getMaxBits(&b), 0);
  c0.value = Literal(uint32_t(0xFF));
  c1.value = Literal(uint32_t(0xFF));
  assert_equal(getMaxBits(&b), 1);
  c0.value = Literal(uint32_t(-1));
  c1.value = Literal(uint32_t(1));
  assert_equal(getMaxBits(&b), 32);
  c0.value = Literal(uint32_t(-1));
  c1.value = Literal(uint32_t(2));
  assert_equal(getMaxBits(&b), 31);
  c0.value = Literal(uint32_t(0x7FFFFFFF));
  c1.value = Literal(uint32_t(3));
  assert_equal(getMaxBits(&b), 30);
  c0.value = Literal(int32_t(0x0000FFFF));
  c1.value = Literal(int32_t(0xFF));
  assert_equal(getMaxBits(&b), 9);
  c0.value = Literal(int32_t(0x00001000));
  c1.value = Literal(int32_t(0x00000FFF));
  assert_equal(getMaxBits(&b), 2);
  c0.value = Literal(uint32_t(0x80000000));
  c1.value = Literal(uint32_t(-1));
  assert_equal(getMaxBits(&b), 1);
  c0.value = Literal(uint32_t(2));
  c1.value = Literal(uint32_t(-2));
  assert_equal(getMaxBits(&b), 0);

  b.op = RemSInt32;
  c0.value = Literal(int32_t(0));
  c1.value = Literal(int32_t(0xF));
  assert_equal(getMaxBits(&b), 0);
  c0.value = Literal(int32_t(0));
  c1.value = Literal(int32_t(-1));
  assert_equal(getMaxBits(&b), 0);
  c0.value = Literal(int32_t(1));
  c1.value = Literal(int32_t(2));
  assert_equal(getMaxBits(&b), 1);
  c0.value = Literal(int32_t(-1));
  c1.value = Literal(int32_t(2));
  assert_equal(getMaxBits(&b), 32);
  c0.value = Literal(int32_t(3));
  c1.value = Literal(int32_t(-1));
  assert_equal(getMaxBits(&b), 2);
  c0.value = Literal(int32_t(0x7FFFFFFF));
  c1.value = Literal(int32_t(0x7FFFFFFF));
  assert_equal(getMaxBits(&b), 31);

  b.op = RemUInt32;
  c0.value = Literal(uint32_t(0));
  c1.value = Literal(uint32_t(0xF));
  assert_equal(getMaxBits(&b), 0);
  c0.value = Literal(uint32_t(0));
  c1.value = Literal(uint32_t(-1));
  assert_equal(getMaxBits(&b), 0);
  c0.value = Literal(uint32_t(1));
  c1.value = Literal(uint32_t(2));
  assert_equal(getMaxBits(&b), 1);
  c0.value = Literal(uint32_t(-1));
  c1.value = Literal(uint32_t(2));
  assert_equal(getMaxBits(&b), 1);
  c0.value = Literal(uint32_t(3));
  c1.value = Literal(uint32_t(-1));
  assert_equal(getMaxBits(&b), 2);
  c0.value = Literal(uint32_t(0x7FFFFFFF));
  c1.value = Literal(uint32_t(0x7FFFFFFF));
  assert_equal(getMaxBits(&b), 31);

  b.op = AndInt32;
  c0.value = Literal(int32_t(0));
  c1.value = Literal(int32_t(0xF));
  assert_equal(getMaxBits(&b), 0);
  c0.value = Literal(int32_t(0xF));
  c1.value = Literal(int32_t(0));
  assert_equal(getMaxBits(&b), 0);
  c0.value = Literal(int32_t(3));
  c1.value = Literal(int32_t(3));
  assert_equal(getMaxBits(&b), 2);
  c0.value = Literal(int32_t(-1));
  c1.value = Literal(int32_t(3));
  assert_equal(getMaxBits(&b), 2);
  c0.value = Literal(int32_t(3));
  c1.value = Literal(int32_t(-1));
  assert_equal(getMaxBits(&b), 2);

  b.op = OrInt32;
  c0.value = Literal(int32_t(0));
  c1.value = Literal(int32_t(0xF));
  assert_equal(getMaxBits(&b), 4);
  c0.value = Literal(int32_t(0xF));
  c1.value = Literal(int32_t(0));
  assert_equal(getMaxBits(&b), 4);
  c0.value = Literal(int32_t(3));
  c1.value = Literal(int32_t(3));
  assert_equal(getMaxBits(&b), 2);
  c0.value = Literal(int32_t(-1));
  c1.value = Literal(int32_t(3));
  assert_equal(getMaxBits(&b), 32);
  c0.value = Literal(int32_t(3));
  c1.value = Literal(int32_t(-1));
  assert_equal(getMaxBits(&b), 32);

  b.op = XorInt32;
  c0.value = Literal(int32_t(0));
  c1.value = Literal(int32_t(0xF));
  assert_equal(getMaxBits(&b), 4);
  c0.value = Literal(int32_t(0xF));
  c1.value = Literal(int32_t(0));
  assert_equal(getMaxBits(&b), 4);
  c0.value = Literal(int32_t(3));
  c1.value = Literal(int32_t(3));
  assert_equal(getMaxBits(&b), 2);
  c0.value = Literal(int32_t(-1));
  c1.value = Literal(int32_t(3));
  assert_equal(getMaxBits(&b), 32);
  c0.value = Literal(int32_t(3));
  c1.value = Literal(int32_t(-1));
  assert_equal(getMaxBits(&b), 32);

  // --- //
  // i64 //
  // --- //

  c0.type = Type::i64;
  c1.type = Type::i64;
  b.type = Type::i64;

  c0.value = Literal(int64_t(0));
  assert_equal(getMaxBits(&c0), 0);
  c0.value = Literal(int64_t(1));
  assert_equal(getMaxBits(&c0), 1);
  c0.value = Literal(int64_t(2));
  assert_equal(getMaxBits(&c0), 2);
  c0.value = Literal(int64_t(0x80000));
  assert_equal(getMaxBits(&c0), 20);
  c0.value = Literal(int64_t(-1));
  assert_equal(getMaxBits(&c0), 64);

  b.op = AddInt64;
  c0.value = Literal(int64_t(0xFFFF));
  c1.value = Literal(int64_t(0x11));
  assert_equal(getMaxBits(&b), 17);
  c0.value = Literal(int64_t(-1));
  c1.value = Literal(int64_t(2));
  assert_equal(getMaxBits(&b), 64);
  c0.value = Literal(int64_t(-1));
  c1.value = Literal(int64_t(-1));
  assert_equal(getMaxBits(&b), 64);

  b.op = SubInt64;
  c0.value = Literal(int64_t(0xFFFF));
  c1.value = Literal(int64_t(0x11));
  assert_equal(getMaxBits(&b), 64);
  c0.value = Literal(int64_t(-1));
  c1.value = Literal(int64_t(2));
  assert_equal(getMaxBits(&b), 64);
  c0.value = Literal(int64_t(2));
  c1.value = Literal(int64_t(-1));
  assert_equal(getMaxBits(&b), 64);
  c0.value = Literal(int64_t(0));
  c1.value = Literal(int64_t(1));
  assert_equal(getMaxBits(&b), 64);
  c0.value = Literal(int64_t(0x7FFFFFFFFFFFFFF0));
  c1.value = Literal(int64_t(0x7FFFFFFFFFFFFFFF));
  assert_equal(getMaxBits(&b), 64);
  c0.value = Literal(int64_t(1));
  c1.value = Literal(int64_t(1));
  assert_equal(getMaxBits(&b), 64);
  c0.value = Literal(int64_t(0));
  c1.value = Literal(int64_t(0x7FFFFFFFFFFFFFFF));
  assert_equal(getMaxBits(&b), 64);

  b.op = MulInt64;
  c0.value = Literal(int64_t(0xFFFF));
  c1.value = Literal(int64_t(0x11));
  assert_equal(getMaxBits(&b), 21);
  c0.value = Literal(int64_t(0));
  c1.value = Literal(int64_t(1));
  assert_equal(getMaxBits(&b), 1);
  c0.value = Literal(int64_t(1));
  c1.value = Literal(int64_t(0));
  assert_equal(getMaxBits(&b), 1);
  c0.value = Literal(int64_t(3));
  c1.value = Literal(int64_t(3));
  assert_equal(getMaxBits(&b), 4);
  c0.value = Literal(int64_t(2));
  c1.value = Literal(int64_t(-2));
  assert_equal(getMaxBits(&b), 64);

  b.op = DivSInt64;
  c0.value = Literal(int64_t(0));
  c1.value = Literal(int64_t(0xF));
  assert_equal(getMaxBits(&b), 0);
  c0.value = Literal(int64_t(1));
  c1.value = Literal(int64_t(2));
  assert_equal(getMaxBits(&b), 0);
  c0.value = Literal(int64_t(0xFF));
  c1.value = Literal(int64_t(0xFF));
  assert_equal(getMaxBits(&b), 1);
  c0.value = Literal(int64_t(-1));
  c1.value = Literal(int64_t(1));
  assert_equal(getMaxBits(&b), 64);
  c0.value = Literal(int64_t(-1));
  c1.value = Literal(int64_t(2));
  assert_equal(getMaxBits(&b), 64);
  c0.value = Literal(int64_t(0x7FFFFFFFFFFFFFFF));
  c1.value = Literal(int64_t(3));
  assert_equal(getMaxBits(&b), 62);
  c0.value = Literal(int64_t(0x8000000000000000));
  c1.value = Literal(int64_t(-1));
  assert_equal(getMaxBits(&b), 64);
  c0.value = Literal(int64_t(2));
  c1.value = Literal(int64_t(-2));
  assert_equal(getMaxBits(&b), 64);

  b.op = DivUInt64;
  c0.value = Literal(uint64_t(0));
  c1.value = Literal(uint64_t(0xF));
  assert_equal(getMaxBits(&b), 0);
  c0.value = Literal(uint64_t(1));
  c1.value = Literal(uint64_t(2));
  assert_equal(getMaxBits(&b), 0);
  c0.value = Literal(uint64_t(0xFF));
  c1.value = Literal(uint64_t(0xFF));
  assert_equal(getMaxBits(&b), 1);
  c0.value = Literal(uint64_t(-1));
  c1.value = Literal(uint64_t(1));
  assert_equal(getMaxBits(&b), 64);
  c0.value = Literal(uint64_t(-1));
  c1.value = Literal(uint64_t(2));
  assert_equal(getMaxBits(&b), 63);
  c0.value = Literal(uint64_t(0x7FFFFFFFFFFFFFFF));
  c1.value = Literal(uint64_t(3));
  assert_equal(getMaxBits(&b), 62);
  c0.value = Literal(uint64_t(0x8000000000000000));
  c1.value = Literal(uint64_t(-1));
  assert_equal(getMaxBits(&b), 1);
  c0.value = Literal(uint64_t(2));
  c1.value = Literal(uint64_t(-2));
  assert_equal(getMaxBits(&b), 0);

  b.op = RemSInt64;
  c0.value = Literal(int64_t(0));
  c1.value = Literal(int64_t(0xF));
  assert_equal(getMaxBits(&b), 0);
  c0.value = Literal(int64_t(0));
  c1.value = Literal(int64_t(-1));
  assert_equal(getMaxBits(&b), 0);
  c0.value = Literal(int64_t(1));
  c1.value = Literal(int64_t(2));
  assert_equal(getMaxBits(&b), 1);
  c0.value = Literal(int64_t(-1));
  c1.value = Literal(int64_t(2));
  assert_equal(getMaxBits(&b), 64);
  c0.value = Literal(int64_t(3));
  c1.value = Literal(int64_t(-1));
  assert_equal(getMaxBits(&b), 2);
  c0.value = Literal(int64_t(0x7FFFFFFFFFFFFFFF));
  c1.value = Literal(int64_t(0x7FFFFFFFFFFFFFFF));
  assert_equal(getMaxBits(&b), 63);

  b.op = RemUInt64;
  c0.value = Literal(uint64_t(0));
  c1.value = Literal(uint64_t(0xF));
  assert_equal(getMaxBits(&b), 0);
  c0.value = Literal(uint64_t(0));
  c1.value = Literal(uint64_t(-1));
  assert_equal(getMaxBits(&b), 0);
  c0.value = Literal(uint64_t(1));
  c1.value = Literal(uint64_t(2));
  assert_equal(getMaxBits(&b), 1);
  c0.value = Literal(uint64_t(-1));
  c1.value = Literal(uint64_t(2));
  assert_equal(getMaxBits(&b), 1);
  c0.value = Literal(uint64_t(3));
  c1.value = Literal(uint64_t(-1));
  assert_equal(getMaxBits(&b), 2);
  c0.value = Literal(uint64_t(0x7FFFFFFFFFFFFFFF));
  c1.value = Literal(uint64_t(0x7FFFFFFFFFFFFFFF));
  assert_equal(getMaxBits(&b), 63);

  b.op = AndInt64;
  c0.value = Literal(int64_t(0));
  c1.value = Literal(int64_t(0xF));
  assert_equal(getMaxBits(&b), 0);
  c0.value = Literal(int64_t(0xF));
  c1.value = Literal(int64_t(0));
  assert_equal(getMaxBits(&b), 0);
  c0.value = Literal(int64_t(3));
  c1.value = Literal(int64_t(3));
  assert_equal(getMaxBits(&b), 2);
  c0.value = Literal(int64_t(-1));
  c1.value = Literal(int64_t(3));
  assert_equal(getMaxBits(&b), 2);
  c0.value = Literal(int64_t(3));
  c1.value = Literal(int64_t(-1));
  assert_equal(getMaxBits(&b), 2);

  b.op = OrInt64;
  c0.value = Literal(int64_t(0));
  c1.value = Literal(int64_t(0xF));
  assert_equal(getMaxBits(&b), 4);
  c0.value = Literal(int64_t(0xF));
  c1.value = Literal(int64_t(0));
  assert_equal(getMaxBits(&b), 4);
  c0.value = Literal(int64_t(3));
  c1.value = Literal(int64_t(3));
  assert_equal(getMaxBits(&b), 2);
  c0.value = Literal(int64_t(-1));
  c1.value = Literal(int64_t(3));
  assert_equal(getMaxBits(&b), 64);
  c0.value = Literal(int64_t(3));
  c1.value = Literal(int64_t(-1));
  assert_equal(getMaxBits(&b), 64);

  b.op = XorInt64;
  c0.value = Literal(int64_t(0));
  c1.value = Literal(int64_t(0xF));
  assert_equal(getMaxBits(&b), 4);
  c0.value = Literal(int64_t(0xF));
  c1.value = Literal(int64_t(0));
  assert_equal(getMaxBits(&b), 4);
  c0.value = Literal(int64_t(3));
  c1.value = Literal(int64_t(3));
  assert_equal(getMaxBits(&b), 2);
  c0.value = Literal(int64_t(-1));
  c1.value = Literal(int64_t(3));
  assert_equal(getMaxBits(&b), 64);
  c0.value = Literal(int64_t(3));
  c1.value = Literal(int64_t(-1));
  assert_equal(getMaxBits(&b), 64);

  Unary u;
  c0.type = Type::i32;
  u.value = &c0;

  u.type = Type::i64;

  u.op = ExtendUInt32;
  c0.value = Literal(int32_t(0));
  assert_equal(getMaxBits(&u), 0);
  c0.value = Literal(int32_t(1));
  assert_equal(getMaxBits(&u), 1);
  c0.value = Literal(int32_t(0xF));
  assert_equal(getMaxBits(&u), 4);
  c0.value = Literal(int32_t(-1));
  assert_equal(getMaxBits(&u), 32);

  u.op = ExtendSInt32;
  c0.value = Literal(int32_t(0));
  assert_equal(getMaxBits(&u), 0);
  c0.value = Literal(int32_t(1));
  assert_equal(getMaxBits(&u), 1);
  c0.value = Literal(int32_t(0xF));
  assert_equal(getMaxBits(&u), 4);
  c0.value = Literal(int32_t(0x7FFFFFFF));
  assert_equal(getMaxBits(&u), 31);
  c0.value = Literal(int32_t(0x80000000));
  assert_equal(getMaxBits(&u), 64);
  c0.value = Literal(int32_t(-1));
  assert_equal(getMaxBits(&u), 64);

  u.type = Type::i32;
  c0.type = Type::i64;

  u.op = WrapInt64;
  c0.value = Literal(int64_t(0));
  assert_equal(getMaxBits(&u), 0);
  c0.value = Literal(int64_t(0x7FFFFFFF));
  assert_equal(getMaxBits(&u), 31);
  c0.value = Literal(int64_t(0xFFFFFFFF));
  assert_equal(getMaxBits(&u), 32);
  c0.value = Literal(int64_t(0xFFFFFFFFFF));
  assert_equal(getMaxBits(&u), 32);
  c0.value = Literal(int64_t(-1));
  assert_equal(getMaxBits(&u), 32);

  u.type = Type::i32;
  c0.type = Type::i32;

  u.op = ExtendS8Int32;
  c0.value = Literal(int8_t(0));
  assert_equal(getMaxBits(&u), 0);
  c0.value = Literal(int8_t(127));
  assert_equal(getMaxBits(&u), 7);
  c0.value = Literal(int8_t(128));
  assert_equal(getMaxBits(&u), 32);

  u.op = ExtendS16Int32;
  c0.value = Literal(int16_t(0));
  assert_equal(getMaxBits(&u), 0);
  c0.value = Literal(int16_t(0x7FFF));
  assert_equal(getMaxBits(&u), 15);
  c0.value = Literal(int16_t(0x8000));
  assert_equal(getMaxBits(&u), 32);

  u.type = Type::i64;
  c0.type = Type::i32;

  u.op = ExtendS8Int64;
  c0.value = Literal(int8_t(0));
  assert_equal(getMaxBits(&u), 0);
  c0.value = Literal(int8_t(127));
  assert_equal(getMaxBits(&u), 7);
  c0.value = Literal(int8_t(128));
  assert_equal(getMaxBits(&u), 64);

  u.op = ExtendS16Int64;
  c0.value = Literal(int16_t(0));
  assert_equal(getMaxBits(&u), 0);
  c0.value = Literal(int16_t(0x7FFF));
  assert_equal(getMaxBits(&u), 15);
  c0.value = Literal(int16_t(0x8000));
  assert_equal(getMaxBits(&u), 64);

  u.type = Type::i64;
  c0.type = Type::i64;

  u.op = ExtendS32Int64;
  c0.value = Literal(int64_t(0));
  assert_equal(getMaxBits(&u), 0);
  c0.value = Literal(int64_t(0x7FFFFFFFLL));
  assert_equal(getMaxBits(&u), 31);
  c0.value = Literal(int64_t(0xFFFFFFFFLL));
  assert_equal(getMaxBits(&u), 64);
  c0.value = Literal(int64_t(-1LL));
  assert_equal(getMaxBits(&u), 64);
}

void test_cost() {
  // Some optimizations assume that the cost of a get is zero, e.g. local-cse.
  LocalGet get;
  assert_equal(CostAnalyzer(&get).cost, 0);
}

void test_effects() {
  PassOptions options;
  Module module;

  // Unreachables trap.
  Unreachable unreachable;
  assert_equal(EffectAnalyzer(options, module, &unreachable).trap, true);

  // Nops... do not.
  Nop nop;
  assert_equal(EffectAnalyzer(options, module, &nop).trap, false);

  // ArrayCopy can trap, reads arrays, and writes arrays (but not structs).
  {
    Type arrayref = Type(HeapType(Array(Field(Type::i32, Mutable))), Nullable);
    LocalGet dest;
    dest.index = 0;
    dest.type = arrayref;
    LocalGet destIndex;
    destIndex.index = 1;
    destIndex.type = Type::i32;
    LocalGet src;
    src.index = 0;
    src.type = arrayref;
    LocalGet srcIndex;
    srcIndex.index = 1;
    srcIndex.type = Type::i32;
    LocalGet length;
    srcIndex.index = 2;
    srcIndex.type = Type::i32;
    ArrayCopy arrayCopy(module.allocator);
    arrayCopy.destRef = &dest;
    arrayCopy.destIndex = &destIndex;
    arrayCopy.srcRef = &src;
    arrayCopy.srcIndex = &srcIndex;
    arrayCopy.length = &length;
    arrayCopy.finalize();

    EffectAnalyzer effects(options, module);
    effects.visit(&arrayCopy);
    assert_equal(effects.trap, true);
    assert_equal(effects.readsArray, true);
    assert_equal(effects.writesArray, true);
    assert_equal(effects.readsMutableStruct, false);
    assert_equal(effects.writesStruct, false);
  }
}

void test_field() {
  // Simple types
  assert_equal(Field(Type::i32, Immutable).getByteSize(), 4);
  assert_equal(Field(Type::i64, Immutable).getByteSize(), 8);

  // Packed types
  assert_equal(Field(Field::PackedType::i8, Immutable).getByteSize(), 1);
  assert_equal(Field(Field::PackedType::i16, Immutable).getByteSize(), 2);
  assert_equal(Field(Field::PackedType::not_packed, Immutable).getByteSize(),
               4);
}

void test_queue() {
  {
    UniqueDeferredQueue<int> queue;
    queue.push(1);
    queue.push(2);
    queue.push(3);
    queue.push(2);
    // first in was 1
    assert_equal(queue.pop(), 1);
    // next in was 2, but it was added later, so we defer to then, and get the 3
    assert_equal(queue.pop(), 3);
    assert_equal(queue.pop(), 2);
    assert_equal(queue.empty(), true);
  }
  {
    UniqueDeferredQueue<int> queue;
    queue.push(1);
    queue.push(2);
    assert_equal(queue.pop(), 1);
    // clearing clears the queue
    queue.clear();
    assert_equal(queue.empty(), true);
  }
  {
    UniqueNonrepeatingDeferredQueue<int> queue;
    queue.push(1);
    assert_equal(queue.pop(), 1);
    queue.push(1);
    // We never repeat values in this queue, so the last push of 1 is ignored.
    assert_equal(queue.empty(), true);
    // But new values work.
    queue.push(2);
    assert_equal(queue.pop(), 2);
  }
}

int main() {
  test_bits();
  test_cost();
  test_effects();
  test_field();
  test_queue();

  if (failsCount > 0) {
    abort();
  } else {
    std::cout << "Success" << std::endl;
  }
  return 0;
}
