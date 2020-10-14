#include <cassert>
#include <iostream>

#include <support/space.h>

using namespace wasm;

using Span = BSPNode::Span;

int main() {
  {
    BSPNode root(Span{0, 100});
    // Nothing in root
    assert(!root.hasOverlap(Span{0, 100}));
  }
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
  }
  {
    BSPNode root(Span{0, 100});
    root.add(Span{40, 60});
    // No overlap
    assert(!root.hasOverlap(Span{20, 30}));
  }
  {
    BSPNode root(Span{0, 100});
    root.add(Span{40, 60});
    // Touching, but no overlap
    assert(!root.hasOverlap(Span{20, 40}));
  }
  {
    BSPNode root(Span{0, 100});
    root.add(Span{40, 60});
    // Overlap
    assert(root.hasOverlap(Span{20, 41}));
  }
  {
    BSPNode root(Span{0, 100});
    root.add(Span{40, 60});
    // Overlap
    assert(root.hasOverlap(Span{40, 41}));
  }
  {
    BSPNode root(Span{0, 100});
    root.add(Span{40, 60});
    // Internal
    assert(root.hasOverlap(Span{45, 50}));
  }
  {
    BSPNode root(Span{0, 100});
    root.add(Span{40, 60});
    // Touches other side
    assert(root.hasOverlap(Span{45, 60}));
  }
  {
    BSPNode root(Span{0, 100});
    root.add(Span{40, 60});
    // Overlaps on other side
    assert(root.hasOverlap(Span{45, 70}));
  }
  {
    BSPNode root(Span{0, 100});
    root.add(Span{40, 60});
    // Just inside.
    assert(root.hasOverlap(Span{59, 60}));
  }
  {
    BSPNode root(Span{0, 100});
    root.add(Span{40, 60});
    // Just outside
    assert(!root.hasOverlap(Span{60, 61}));
  }
  {
    BSPNode root(Span{0, 100});
    root.add(Span{40, 60});
    // Totally outside
    assert(!root.hasOverlap(Span{70, 80}));
  }
}
