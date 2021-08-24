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
    assert(domTree.iDoms.empty());
  }

  // An CFG with just an entry.
  {
    CFG cfg;
    cfg.add();

    DomTree<BasicBlock> domTree(cfg);
    assert(domTree.iDoms.size() == 1);
    assert(domTree.iDoms[0] == Index(-1)); // the entry has no parent.
  }

  // entry -> a.
  {
    CFG cfg;
    auto* entry = cfg.add();
    auto* a = cfg.add();
    cfg.connect(entry, a);

    DomTree<BasicBlock> domTree(cfg);
    assert(domTree.iDoms.size() == 2);
    assert(domTree.iDoms[0] == Index(-1));
    assert(domTree.iDoms[1] == 0); // a is dominated by the entry.
  }

  // entry and a non-connected (unreachable) block.
  {
    CFG cfg;
    auto* entry = cfg.add();
    auto* a = cfg.add();

    DomTree<BasicBlock> domTree(cfg);
    assert(domTree.iDoms.size() == 2);
    assert(domTree.iDoms[0] == Index(-1));
    assert(domTree.iDoms[1] == Index(-1)); // unreachables have no parent.
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
    assert(domTree.iDoms.size() == 4);
    assert(domTree.iDoms[0] == Index(-1));
    assert(domTree.iDoms[1] == 0);
    assert(domTree.iDoms[2] == 1);
    assert(domTree.iDoms[3] == 2);
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
    assert(domTree.iDoms.size() == 5);
    assert(domTree.iDoms[0] == Index(-1));
    assert(domTree.iDoms[1] == 0); // a
    assert(domTree.iDoms[2] == 1); // b
    assert(domTree.iDoms[3] == 1); // c
    assert(domTree.iDoms[4] == 1); // d is also dominated by a.
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
    assert(domTree.iDoms.size() == 5);
    assert(domTree.iDoms[0] == Index(-1));
    assert(domTree.iDoms[1] == 0); // a
    assert(domTree.iDoms[2] == 1); // b, the loop entry, is dominated by a
    assert(domTree.iDoms[3] == 2); // c, the loop "middle", is dominated by b
    assert(domTree.iDoms[4] == 3); // d, the loop "end", is dominated by c
  }

  // Subsequent blocks after an unreachable one.
  //
  // entry   a -> b
  //
  // (a is unreachable, and b is reached by a, but in unreachable code)
  {
    CFG cfg;
    auto* entry = cfg.add();
    auto* a = cfg.add();
    auto* b = cfg.add();
    cfg.connect(a, b);

    DomTree<BasicBlock> domTree(cfg);
    assert(domTree.iDoms.size() == 3);
    assert(domTree.iDoms[0] == Index(-1));
    assert(domTree.iDoms[1] == Index(-1)); // a
    assert(domTree.iDoms[2] == Index(-1)); // b
  }

  std::cout << "success.\n";
}
