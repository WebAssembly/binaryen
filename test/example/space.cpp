#include <cassert>
#include <iostream>

#include <support/space.h>

using namespace wasm;

using Span = BSPNode::Span;

int main() {
  // No spans
  {
    BSPNode root(Span{0, 100});
    // Nothing in root
    assert(!root.hasOverlap(Span{0, 100}));
  }
  // One span
  {
    BSPNode root(Span{0, 100});
    root.add(Span{0, 100});
    // It is there
    assert(root.hasOverlap(Span{0, 100}));
  }
  {
    BSPNode root(Span{0, 100});
    root.add(Span{40, 60});
    // Exact match
    assert(root.hasOverlap(Span{40, 60}));
    // No overlap
    assert(!root.hasOverlap(Span{20, 30}));
    // Touching, but no overlap
    assert(!root.hasOverlap(Span{20, 40}));
    // Overlap
    assert(root.hasOverlap(Span{20, 41}));
    assert(root.hasOverlap(Span{40, 41}));
    // Internal
    assert(root.hasOverlap(Span{45, 50}));
    // Touches other side
    assert(root.hasOverlap(Span{45, 60}));
    // Overlaps on other side
    assert(root.hasOverlap(Span{45, 70}));
    // Just inside.
    assert(root.hasOverlap(Span{59, 60}));
    // Just outside
    assert(!root.hasOverlap(Span{60, 61}));
    // Totally outside
    assert(!root.hasOverlap(Span{70, 80}));
  }
  // Two spans, different subtrees
  {
    BSPNode root(Span{0, 100});
    root.add(Span{30, 40});
    root.add(Span{60, 70});
    assert(!root.hasOverlap(Span{10, 20}));
    assert(!root.hasOverlap(Span{10, 30}));
    assert(root.hasOverlap(Span{10, 40}));
    assert(root.hasOverlap(Span{35, 40}));
    assert(!root.hasOverlap(Span{40, 60}));
    assert(!root.hasOverlap(Span{45, 55}));
    assert(root.hasOverlap(Span{50, 61}));
    assert(root.hasOverlap(Span{50, 100}));
    assert(root.hasOverlap(Span{60, 70}));
    assert(root.hasOverlap(Span{60, 61}));
    assert(!root.hasOverlap(Span{70, 80}));
    assert(!root.hasOverlap(Span{70, 100}));
  }
  // Two spans, same subtree
  {
    BSPNode root(Span{0, 100});
    root.add(Span{30, 40});
    root.add(Span{40, 45});
    assert(!root.hasOverlap(Span{10, 20}));
    assert(!root.hasOverlap(Span{10, 30}));
    assert(root.hasOverlap(Span{10, 40}));
    assert(root.hasOverlap(Span{35, 40}));
    assert(root.hasOverlap(Span{40, 41}));
    assert(root.hasOverlap(Span{35, 45}));
    assert(!root.hasOverlap(Span{45, 100}));
  }
  std::cout << "success.\n";
}
