#include <cassert>
#include <iostream>

#include <cfg/domtree.h>
#include <wasm.h>

using namespace wasm;

struct BasicBlock {
  std::vector<BasicBlock*> in;

  void addPred(BasicBlock* pred) { in.push_back(pred); }
};

struct CFG : public std::vector<std::unique_ptr<BasicBlock>> {
  BasicBlock* add() {
    emplace_back(std::make_unique<BasicBlock>());
    return back().get();
  }

  void connect(BasicBlock* pred, BasicBlock* succ) { succ->addPred(pred); }
};

int main() {
  // An empty CFG.
  {
    CFG cfg;

    DomTree<BasicBlock> domTree(cfg);
    assert(domTree.parents.empty());
  }

  // An CFG with just an entry.
  {
    CFG cfg;
    cfg.add();

    DomTree<BasicBlock> domTree(cfg);
    assert(domTree.parents.size() == 1);
    assert(domTree.parents[0] == Index(-1)); // the entry has no parent.
  }

  // entry -> a.
  {
    CFG cfg;
    auto* entry = cfg.add();
    auto* a = cfg.add();
    cfg.connect(entry, a);

    DomTree<BasicBlock> domTree(cfg);
    assert(domTree.parents.size() == 2);
    assert(domTree.parents[0] == Index(-1));
    assert(domTree.parents[1] == 0); // a is dominated by the entry.
  }

  // entry and a non-connected (unreachable) block.
  {
    CFG cfg;
    auto* entry = cfg.add();
    auto* a = cfg.add();

    DomTree<BasicBlock> domTree(cfg);
    assert(domTree.parents.size() == 2);
    assert(domTree.parents[0] == Index(-1));
    assert(domTree.parents[0] == Index(-1)); // unreachables have no parent.
  }

  // entry -> a -> b -> c.
  {
    CFG cfg;
    auto* entry = cfg.add();
    auto* a = cfg.add();
    auto* b = cfg.add();
    auto* c = cfg.add();
    cfg.connect(entry, a);
    cfg.connect(a, b);
    cfg.connect(b, c);

    DomTree<BasicBlock> domTree(cfg);
    assert(domTree.parents.size() == 4);
    assert(domTree.parents[0] == Index(-1));
    assert(domTree.parents[1] == 0);
    assert(domTree.parents[2] == 1);
    assert(domTree.parents[3] == 2);
  }

  // An if:
  //            b
  //           / \
  // entry -> a   d
  //           \ /
  //            c
  {
    CFG cfg;
    auto* entry = cfg.add();
    auto* a = cfg.add();
    auto* b = cfg.add();
    auto* c = cfg.add();
    auto* d = cfg.add();
    cfg.connect(entry, a);
    cfg.connect(a, b);
    cfg.connect(a, c);
    cfg.connect(b, d);
    cfg.connect(c, d);

    DomTree<BasicBlock> domTree(cfg);
    assert(domTree.parents.size() == 5);
    assert(domTree.parents[0] == Index(-1));
    assert(domTree.parents[1] == 0); // a
    assert(domTree.parents[2] == 1); // b
    assert(domTree.parents[3] == 1); // c
    assert(domTree.parents[4] == 1); // d is also dominated by a.
  }

  // A loop:
  //
  // entry -> a -> b -> c -> d
  //               ^         |
  //               |         |
  //               \---------/
  {
    CFG cfg;
    auto* entry = cfg.add();
    auto* a = cfg.add();
    auto* b = cfg.add();
    auto* c = cfg.add();
    auto* d = cfg.add();
    cfg.connect(entry, a);
    cfg.connect(a, b);
    cfg.connect(b, c);
    cfg.connect(c, d);
    cfg.connect(d, b);

    DomTree<BasicBlock> domTree(cfg);
    assert(domTree.parents.size() == 5);
    assert(domTree.parents[0] == Index(-1));
    assert(domTree.parents[1] == 0); // a
    assert(domTree.parents[2] == 1); // b, the loop entry, is dominated by a
    assert(domTree.parents[3] == 2); // c, the loop "middle", is dominated by b
    assert(domTree.parents[4] == 3); // d, the loop "end", is dominated by c
  }

  // The example from figure 4 in [1]. Indexes are copied from there, plus a
  // "b" prefix. Note that this is irreducible control flow, which we do not
  // actually need to handle for wasm.
  //
  // [1] Cooper, Keith D.; Harvey, Timothy J; Kennedy, Ken (2001). "A Simple,
  //       Fast Dominance Algorithm" (PDF).
  //       http://www.hipersoft.rice.edu/grads/publications/dom14.pdf
  {
    CFG cfg;
    auto* b6 = cfg.add(); // The entry.
    auto* b5 = cfg.add();
    auto* b4 = cfg.add();
    auto* b3 = cfg.add();
    auto* b2 = cfg.add();
    auto* b1 = cfg.add();
    cfg.connect(b6, b5);
    cfg.connect(b6, b4);
    cfg.connect(b5, b1);
    cfg.connect(b4, b2);
    cfg.connect(b4, b3);
    cfg.connect(b3, b2);
    cfg.connect(b2, b3);
    cfg.connect(b2, b1);
    cfg.connect(b1, b2);

    DomTree<BasicBlock> domTree(cfg);
    assert(domTree.parents.size() == 6);
    assert(domTree.parents[0] == Index(-1)); // b6;
    // Everything else is dominated only by the entry.
    assert(domTree.parents[1] == 0); // b5
    assert(domTree.parents[2] == 0); // b4
    assert(domTree.parents[3] == 0); // b3
    assert(domTree.parents[4] == 0); // b2
    assert(domTree.parents[5] == 0); // b1
  }

  std::cout << "success.\n";
}
