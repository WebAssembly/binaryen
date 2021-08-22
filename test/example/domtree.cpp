#include <cassert>
#include <iostream>

#include <cfg/domtree.h>
#include <wasm.h>

using namespace wasm;

// Ids are useful for debugging.
static Index nextId = 0;

struct BasicBlock {
  Index id;

  std::vector<BasicBlock*> in;

  BasicBlock() : id(nextId++) {}

  void addPred(BasicBlock* pred) { in.push_back(pred); }
};

struct CFG : public std::vector<std::unique_ptr<BasicBlock>> {
  BasicBlock* add() {
    emplace_back(std::make_unique<BasicBlock>());
    return back().get();
  }

  void connect(BasicBlock* pred, BasicBlock* succ) {
    succ->addPred(pred);
  }
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
    assert(domTree.parents[0] == Index(-1)); // the entry has no parent.
    assert(domTree.parents[1] == 0); // a is dominated by the entry.
  }

  // entry and a non-connected (unreachable) block.
  {
    CFG cfg;
    auto* entry = cfg.add();
    auto* a = cfg.add();

    DomTree<BasicBlock> domTree(cfg);
    assert(domTree.parents.size() == 2);
    assert(domTree.parents[0] == Index(-1)); // the entry has no parent.
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
    assert(domTree.parents[0] == Index(-1)); // the entry has no parent.
    assert(domTree.parents[1] == 0);
    assert(domTree.parents[2] == 1);
    assert(domTree.parents[3] == 2);
  }

  std::cout << "success.\n";
}
