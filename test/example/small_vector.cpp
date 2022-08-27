#include <cassert>
#include <iostream>

#include "support/small_vector.h"

using namespace wasm;

template<typename T> void test(size_t N) {
  {
    T t;
    // build up
    assert(t.empty());
    assert(t.size() == 0);
    t.push_back(1);
    assert(!t.empty());
    assert(t.size() == 1);
    t.push_back(2);
    assert(!t.empty());
    assert(t.size() == 2);
    t.push_back(3);
    assert(!t.empty());
    // unwind
    assert(t.size() == 3);
    assert(t.back() == 3);
    t.pop_back();
    assert(t.size() == 2);
    assert(t.back() == 2);
    t.pop_back();
    assert(t.size() == 1);
    assert(t.back() == 1);
    t.pop_back();
    assert(t.size() == 0);
    assert(t.empty());
  }
  {
    T t;
    // build up
    t.push_back(1);
    t.push_back(2);
    t.push_back(3);
    // unwind
    t.clear();
    assert(t.size() == 0);
    assert(t.empty());
  }
  {
    T t, u;
    assert(t == u);
    t.push_back(1);
    assert(t != u);
    u.push_back(1);
    assert(t == u);
    u.pop_back();
    assert(t != u);
    u.push_back(2);
    assert(t != u);
  }
  {
    // Test reserve/capacity.
    T t;

    // Capacity begins at the size of the fixed storage.
    assert(t.capacity() == N);

    // Reserving more increases the capacity (but how much is impl-defined).
    t.reserve(t.capacity() + 100);
    assert(t.capacity() >= N + 100);
  }
}

int main() {
  test<SmallVector<int, 0>>(0);
  test<SmallVector<int, 1>>(1);
  test<SmallVector<int, 2>>(2);
  test<SmallVector<int, 10>>(10);
  std::cout << "ok.\n";
}
