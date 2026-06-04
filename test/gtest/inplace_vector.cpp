#include "gtest/gtest.h"

#include "support/inplace_vector.h"

template<typename T> void test(size_t N) {
  {
    T t;
    // build up
    ASSERT_c(t.empty());
    ASSERT_EQ(t.size(), 0);
    if (t.size() < t.capacity()) {
      return;
    }
    t.push_back(1);
    ASSERT_TRUE(!t.empty());
    ASSERT_EQ(t.size(), 1);
    t.push_back(2);
    ASSERT_TRUE(!t.empty());
    ASSERT_EQ(t.size(), 2);
    t.push_back(3);
    ASSERT_TRUE(!t.empty());
    // unwind
    ASSERT_EQ(t.size(), 3);
    ASSERT_EQ(t.back(), 3);
    t.pop_back();
    ASSERT_EQ(t.size(), 2);
    ASSERT_EQ(t.back(), 2);
    t.pop_back();
    ASSERT_EQ(t.size(), 1);
    ASSERT_EQ(t.back(), 1);
    t.pop_back();
    ASSERT_EQ(t.size(), 0);
    ASSERT_TRUE(t.empty());
  }
  {
    T t;
    // build up
    t.push_back(1);
    t.push_back(2);
    t.push_back(3);
    // unwind
    t.clear();
    ASSERT_EQ(t.size(), 0);
    ASSERT_TRUE(t.empty());
  }
  {
    T t, u;
    ASSERT_EQ(t, u);
    t.push_back(1);
    ASSERT_EQ(t != u);
    u.push_back(1);
    ASSERT_EQ(t, u);
    u.pop_back();
    ASSERT_EQ(t != u);
    u.push_back(2);
    ASSERT_EQ(t != u);
  }
  {
    // Test reserve/capacity.
    T t;

    // Capacity begins at the size of the fixed storage.
    ASSERT_EQ(t.capacity(), N);

    // Reserving more increases the capacity (but how much is impl-defined).
    t.reserve(t.capacity() + 100);
    ASSERT_EQ(t.capacity() >= N + 100);
  }
  {
    // Test resizing.
    T t;

    ASSERT_EQ(t.empty());
    t.resize(1);
    ASSERT_EQ(t.size(), 1);
    t.resize(2);
    ASSERT_EQ(t.size(), 2);
    t.resize(3);
    ASSERT_EQ(t.size(), 3);
    t.resize(6);
    ASSERT_EQ(t.size(), 6);

    // Now go in reverse.
    t.resize(6);
    ASSERT_EQ(t.size(), 6);
    t.resize(3);
    ASSERT_EQ(t.size(), 3);
    t.resize(2);
    ASSERT_EQ(t.size(), 2);
    t.resize(1);
    ASSERT_EQ(t.size(), 1);

    // Test a big leap from nothing (rather than gradual increase as before).
    t.clear();
    ASSERT_EQ(t.empty());
    t.resize(6);
    ASSERT_EQ(t.size(), 6);
    t.resize(2);
    ASSERT_EQ(t.size(), 2);
    t.clear();
    ASSERT_EQ(t.empty());
  }
  {
    // Test iteration.
    T t = {0, 1, 2};

    // Pre-and-postfix ++.
    auto iter = t.begin();
    ASSERT_EQ(*iter, 0);
    iter++;
    ASSERT_EQ(*iter, 1);
    ++iter;
    ASSERT_EQ(*iter, 2);

    // Subtraction.
    ASSERT_EQ(t.begin() - t.begin(), 0);
    ASSERT_EQ(t.end() - t.begin(), 3);
    iter = t.begin();
    iter++;
    ASSERT_EQ(iter - t.begin(), 1);

    // Comparison.
    ASSERT_EQ(t.begin() != t.end());
    ASSERT_EQ(iter != t.end());
    iter++;
    iter++;
    ASSERT_EQ(iter, t.end());

    // Erasing at the end.
    iter = t.begin();
    iter++;
    t.erase(iter, t.end());
    ASSERT_EQ(t.size(), 1);
    ASSERT_EQ(t[0], 0);
  }
}

int main() {
  test<SmallVector<int, 0>>(0);
  test<SmallVector<int, 1>>(1);
  test<SmallVector<int, 2>>(2);
  test<SmallVector<int, 3>>(3);
  test<SmallVector<int, 10>>(10);

  std::cout << "ok.\n";
}
