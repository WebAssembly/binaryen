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

  // entry -> A
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

  std::cout << "success.\n";
}
