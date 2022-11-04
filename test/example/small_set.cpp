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
  // Also test this using an iterator and a const iterator to also get
  // coverage there.
  for (auto& item : t) {
    assert(std::find(expectedContents.begin(), expectedContents.end(), item) !=
           expectedContents.end());
  }
  for (const auto& item : t) {
    assert(std::find(expectedContents.begin(), expectedContents.end(), item) !=
           expectedContents.end());
  }
}

template<typename T> void testAPI() {
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
  {
    T t, u;
    // comparisons should ignore the order of insertion
    t.insert(1);
    t.insert(2);
    u.insert(2);
    u.insert(1);
    assert(t == u);
  }
  {
    T t, u;
    // comparisons should ignore the mode: in a SmallSet<1>, a set of size 1
    // can be either fixed - if we just grew it to size 1 - or flexible - if we
    // grew it enough to be flexible, then shrank it back (as it only becomes
    // fixed at size 0).
    t.insert(1);

    u.insert(1);
    u.insert(2);

    // one extra item in u
    assert(t != u);
    assert(u != t);

    // remove the extra item
    u.erase(2);

    assert(t == u);
    assert(u == t);
  }
  {
    T t, u;
    // as above, but for size 2, and don't erase the last item added
    t.insert(1);
    t.insert(2);

    u.insert(3);
    u.insert(2);
    u.insert(1);

    // one extra item in u
    assert(t != u);
    assert(u != t);

    // remove the extra item
    u.erase(3);

    assert(t == u);
    assert(u == t);
  }
}

template<typename T> void testInternals() {
  {
    T s;
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

// Iterate over an input object and check we have the same items, in the same
// order, as we expect.
template<typename T>
void assertEqualOrdered(const T& t, const std::vector<int>& expected) {
  size_t index = 0;
  for (auto x : t) {
    assert(index < expected.size());
    assert(x == expected[index]);
    index++;
  }
}

template<typename T> void testOrdering() {
  T t;

  // Do some inserts at the end.
  t.insert(1);
  assertEqualOrdered(t, {1});

  t.insert(2);
  assertEqualOrdered(t, {1, 2});

  t.insert(3);
  assertEqualOrdered(t, {1, 2, 3});

  // Erase the start.
  t.erase(1);
  assertEqualOrdered(t, {2, 3});

  // Insert at the start.
  t.insert(1);
  assertEqualOrdered(t, {1, 2, 3});

  // Erase the end.
  t.erase(3);
  assertEqualOrdered(t, {1, 2});

  // Erase the end.
  t.erase(2);
  assertEqualOrdered(t, {1});

  // Insert at the end.
  t.insert(3);
  assertEqualOrdered(t, {1, 3});

  // Insert at the middle.
  t.insert(2);
  assertEqualOrdered(t, {1, 2, 3});

  // Erase the middle.
  t.erase(2);
  assertEqualOrdered(t, {1, 3});
}

int main() {
  testAPI<SmallSet<int, 0>>();
  testAPI<SmallSet<int, 1>>();
  testAPI<SmallSet<int, 2>>();
  testAPI<SmallSet<int, 3>>();
  testAPI<SmallSet<int, 10>>();

  testAPI<SmallUnorderedSet<int, 0>>();
  testAPI<SmallUnorderedSet<int, 1>>();
  testAPI<SmallUnorderedSet<int, 2>>();
  testAPI<SmallUnorderedSet<int, 3>>();
  testAPI<SmallUnorderedSet<int, 10>>();

  testInternals<SmallSet<int, 1>>();
  testInternals<SmallUnorderedSet<int, 1>>();

  testOrdering<SmallSet<int, 0>>();
  testOrdering<SmallSet<int, 1>>();
  testOrdering<SmallSet<int, 2>>();
  testOrdering<SmallSet<int, 3>>();
  testOrdering<SmallSet<int, 10>>();

  std::cout << "ok.\n";
}
