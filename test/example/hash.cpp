#include <cassert>
#include <iostream>

#include <ir/utils.h>

using namespace wasm;

#define assertEqual(left, right)                                               \
  assert(ExpressionAnalyzer::hash(&left) == ExpressionAnalyzer::hash(&right));

#define assertNotEqual(left, right)                                            \
  assert(ExpressionAnalyzer::hash(&left) != ExpressionAnalyzer::hash(&right));

int main() {
  {
    Const x, y;
    x.set(Literal(int32_t(10)));
    y.set(Literal(int32_t(10)));
    assertEqual(x, y);
  }
  {
    // The value matters (with extremely high probability...)
    Const x, y;
    x.set(Literal(int32_t(10)));
    y.set(Literal(int32_t(11)));
    assertNotEqual(x, y);
  }
  {
    // The type matters.
    Const x, y;
    x.set(Literal(int32_t(10)));
    y.set(Literal(int64_t(10)));
    assertNotEqual(x, y);
  }
  {
    // Nested child.
    Drop dx, dy;
    Const x, y;
    x.set(Literal(int32_t(10)));
    y.set(Literal(int32_t(10)));
    dx.value = &x;
    dy.value = &y;
    assertEqual(dx, dy);
  }
  {
    // Nested child.
    Drop dx, dy;
    Const x, y;
    x.set(Literal(int32_t(10)));
    y.set(Literal(int32_t(11)));
    dx.value = &x;
    dy.value = &y;
    assertNotEqual(dx, dy);
  }
  MixedArena arena;
  {
    // Blocks
    Block x(arena);
    Block y(arena);
    assertEqual(x, y);
  }
  {
    // Blocks with contents.
    Block x(arena);
    Block y(arena);
    Nop n;
    y.list.push_back(&n);
    assertNotEqual(x, y);
  }
  {
    // Blocks with names.
    Block x(arena);
    x.name = "foo";
    Block y(arena);
    y.name = "foo";
    assertEqual(x, y);
  }
  {
    // Different block names hash equally - we ignore internal name differences
    // intentionally.
    Block x(arena);
    x.name = "foo";
    Block y(arena);
    y.name = "bar";
    assertEqual(x, y);
  }
  {
    // Different br names are checked relatively as well.
    Break x;
    x.name = "foo";
    Break y;
    y.name = "bar";
    Block z(arena);
    z.name = "foo";
    z.list.push_back(&x);
    Block w(arena);
    w.name = "bar";
    w.list.push_back(&y);
    Block outer1(arena);
    outer1.name = "outer1";
    outer1.list.push_back(&z);
    Block outer2(arena);
    outer2.name = "outer2";
    outer2.list.push_back(&w);
    assertEqual(outer1, outer2);
  }
  {
    // But referring to different relative names leads to a difference.
    Break x;
    x.name = "outer1"; // instead of x, go to the outer label this time
    Break y;
    y.name = "bar";
    Block z(arena);
    z.name = "foo";
    z.list.push_back(&x);
    Block w(arena);
    w.name = "bar";
    w.list.push_back(&y);
    Block outer1(arena);
    outer1.name = "outer1";
    outer1.list.push_back(&z);
    Block outer2(arena);
    outer2.name = "outer2";
    outer2.list.push_back(&w);
    assertNotEqual(outer1, outer2);
  }
  {
    // Indexes.
    LocalGet x, y;
    x.index = 10;
    y.index = 10;
    assertEqual(x, y);
  }
  {
    // Indexes.
    LocalGet x, y;
    x.index = 10;
    y.index = 11;
    assertNotEqual(x, y);
  }
  std::cout << "success.\n";
}
