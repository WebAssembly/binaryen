#include <algorithm>
#include <cassert>
#include <iostream>
#include <vector>

#include "support/small_set.h"

using namespace wasm;

template<typename T>
void assertContents(T& t, const std::vector<int>& expectedContents) {
  assert(t.size() == expectedContents.size());
  for (auto item : expectedContents) {
    assert(t.count(item) == 1);
  }
  for (auto item : t) {
    assert(std::find(expectedContents.begin(), expectedContents.end(), item) !=
           expectedContents.end());
  }
  for (const auto item : t) {
    assert(std::find(expectedContents.begin(), expectedContents.end(), item) !=
           expectedContents.end());
  }
}

template<typename T> void test() {
  {
    T t;

    // build up with no duplicates
    assert(t.empty());
    assert(t.size() == 0);
    t.insert(1);
    assertContents(t, {1});
    assert(!t.empty());
    assert(t.size() == 1);
    t.insert(2);
    assertContents(t, {1, 2});
    assert(!t.empty());
    assert(t.size() == 2);
    t.insert(3);
    assertContents(t, {1, 2, 3});
    assert(!t.empty());

    // unwind
    assert(t.size() == 3);
    t.erase(3);
    assertContents(t, {1, 2});
    assert(t.size() == 2);
    t.erase(2);
    assertContents(t, {1});
    assert(t.size() == 1);
    t.erase(1);
    assertContents(t, {});
    assert(t.size() == 0);
    assert(t.empty());
  }
  {
    T t;

    // build up with duplicates
    t.insert(1);
    t.insert(2);
    t.insert(2);
    t.insert(3);
    assertContents(t, {1, 2, 3});
    assert(t.size() == 3);

    // unwind by erasing (in the opposite direction from before)
    assert(t.count(1) == 1);
    assert(t.count(2) == 1);
    assert(t.count(3) == 1);
    assert(t.count(1337) == 0);

    t.erase(1);
    assert(t.count(1) == 0);

    assert(t.size() == 2);

    assert(t.count(2) == 1);
    t.erase(2);
    assert(t.count(2) == 0);

    assert(t.size() == 1);

    assert(t.count(3) == 1);
    t.erase(3);

    assert(t.count(1) == 0);
    assert(t.count(2) == 0);
    assert(t.count(3) == 0);
    assert(t.count(1337) == 0);

    assert(t.size() == 0);
  }
  {
    T t;

    // build up
    t.insert(1);
    t.insert(2);
    t.insert(3);

    // unwind by clearing
    t.clear();
    assert(t.size() == 0);
    assert(t.empty());
  }
  {
    T t, u;
    // comparisons
    assert(t == u);
    t.insert(1);
    assert(t != u);
    u.insert(1);
    assert(t == u);
    u.erase(1);
    assert(t != u);
    u.insert(2);
    assert(t != u);
  }
}

void testInternals() {
  {
    SmallSet<int, 1> s;
    // Start out using fixed storage.
    assert(s.TEST_ONLY_NEVER_USE_usingFixed());
    // Adding one item still keeps us using fixed storage, as that is the exact
    // amount we have in fact.
    s.insert(0);
    assert(s.TEST_ONLY_NEVER_USE_usingFixed());
    // Adding one more item forces us to use flexible storage.
    s.insert(1);
    assert(!s.TEST_ONLY_NEVER_USE_usingFixed());
    // Removing an item returns us to size 1, *but we keep using flexible
    // storage*. We do not ping-pong between flexible and fixed; once flexible,
    // we stay that way.
    s.erase(0);
    assert(!s.TEST_ONLY_NEVER_USE_usingFixed());
    // However, removing all items does return us to using fixed storage, should
    // we ever insert again.
    s.erase(1);
    assert(s.empty());
    assert(s.TEST_ONLY_NEVER_USE_usingFixed());
    // And once more we can add an additional item while remaining fixed.
    s.insert(10);
    assert(s.TEST_ONLY_NEVER_USE_usingFixed());
  }
}

int main() {
  test<SmallSet<int, 0>>();
  test<SmallSet<int, 1>>();
  test<SmallSet<int, 2>>();
  test<SmallSet<int, 10>>();

  testInternals();

  std::cout << "ok.\n";
}
