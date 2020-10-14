#include <cassert>
#include <iostream>

#include <support/space.h>

using namespace wasm;

using Span = DisjointSpans::Span;

int main() {
  // No spans
  {
    DisjointSpans root;
    // Nothing in root
    assert(!root.checkOverlap(Span{0, 100}));
  }
  // One span
  {
    DisjointSpans root;
    root.add(Span{0, 100});
    // It is there
    assert(root.checkOverlap(Span{0, 100}));
  }
  {
    DisjointSpans root;
    root.add(Span{40, 60});
    // Exact match
    assert(root.checkOverlap(Span{40, 60}));
    // No overlap
    assert(!root.checkOverlap(Span{20, 30}));
    // Touching, but no overlap
    assert(!root.checkOverlap(Span{20, 40}));
    // Overlap
    assert(root.checkOverlap(Span{20, 41}));
    assert(root.checkOverlap(Span{40, 41}));
    // Internal
    assert(root.checkOverlap(Span{45, 50}));
    // Touches other side
    assert(root.checkOverlap(Span{45, 60}));
    // Overlaps on other side
    assert(root.checkOverlap(Span{45, 70}));
    // Just inside.
    assert(root.checkOverlap(Span{59, 60}));
    // Just outside
    assert(!root.checkOverlap(Span{60, 61}));
    // Totally outside
    assert(!root.checkOverlap(Span{70, 80}));
  }
  // Two spans, different subtrees
  {
    DisjointSpans root;
    root.add(Span{30, 40});
    root.add(Span{60, 70});
    assert(!root.checkOverlap(Span{10, 20}));
    assert(!root.checkOverlap(Span{10, 30}));
    assert(root.checkOverlap(Span{10, 40}));
    assert(root.checkOverlap(Span{35, 40}));
    assert(!root.checkOverlap(Span{40, 60}));
    assert(!root.checkOverlap(Span{45, 55}));
    assert(root.checkOverlap(Span{50, 61}));
    assert(root.checkOverlap(Span{50, 100}));
    assert(root.checkOverlap(Span{60, 70}));
    assert(root.checkOverlap(Span{60, 61}));
    assert(!root.checkOverlap(Span{70, 80}));
    assert(!root.checkOverlap(Span{70, 100}));
  }
  // Two spans, same subtree
  {
    DisjointSpans root;
    root.add(Span{30, 40});
    root.add(Span{40, 45});
    assert(!root.checkOverlap(Span{10, 20}));
    assert(!root.checkOverlap(Span{10, 30}));
    assert(root.checkOverlap(Span{10, 40}));
    assert(root.checkOverlap(Span{35, 40}));
    assert(root.checkOverlap(Span{40, 41}));
    assert(root.checkOverlap(Span{35, 45}));
    assert(!root.checkOverlap(Span{45, 100}));
  }
  // "Pixels"
  {
    const int N = 40;
    for (int i = 0; i < N; i++) {
      DisjointSpans root;
      for (int j = 0; j < N; j++) {
        // add all pixels but the i-th
        if (j != i) {
          root.add(Span{j, j + 1});
        }
      }
      for (int j = 0; j < N; j++) {
        if (j != i) {
          assert(root.checkOverlap(Span{j, j + 1}));
        } else {
          assert(!root.checkOverlap(Span{j, j + 1}));
        }
      }
      assert(root.checkOverlap(Span{10, N + 10}));
      assert(!root.checkOverlap(Span{N + 10, N + 20}));
    }
  }
  // Large numbers.
  {
    DisjointSpans root;
    assert(!root.checkOverlap(Span{2948, 2949}));
    root.add(Span{2948, 2949});
    assert(root.checkOverlap(Span{2948, 2949}));
    assert(root.checkOverlap(Span{2940, 2949}));
    assert(root.checkOverlap(Span{2948, 2959}));
    assert(root.checkOverlap(Span{0, 18766}));
    assert(!root.checkOverlap(Span{2000, 2001}));
    assert(!root.checkOverlap(Span{3000, 3001}));
  }
  std::cout << "success.\n";
}
