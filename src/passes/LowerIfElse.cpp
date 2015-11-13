//
// Lowers if (x) y else z into
//
// L: {
//   if (x) break (y) L
//   z
// }
//
// This is useful for investigating how beneficial if_else is.
//

#include <memory>

#include <wasm.h>
#include <pass.h>

namespace wasm {

struct LowerIfElse : public Pass {
  LowerIfElse() : Pass("lower-if-else") {}

  MixedArena* allocator;
  std::unique_ptr<NameManager> namer;

  void prepare(PassRunner* runner, Module *module) override {
    allocator = runner->allocator;
    namer = std::unique_ptr<NameManager>(new NameManager());
    namer->run(runner, module);
  }

  void visitIf(If *curr) override {
    if (curr->ifFalse) {
      auto block = allocator->alloc<Block>();
      auto name = namer->getUnique("L"); // TODO: getUniqueInFunction
      block->name = name;
      block->list.push_back(curr);
      block->list.push_back(curr->ifFalse);
      curr->ifFalse = nullptr;
      auto break_ = allocator->alloc<Break>();
      break_->name = name;
      break_->value = curr->ifTrue;
      curr->ifTrue = break_;
      replaceCurrent(block);
    }
  }
};

static RegisterPass<LowerIfElse> registerPass;

} // namespace wasm

