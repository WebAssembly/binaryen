#ifndef wasm_analysis_visitor_transfer_function_h
#define wasm_analysis_visitor_transfer_function_h

#include <type_traits>

#include "lattice.h"
#include "monotone-analyzer.h"
#include "wasm-traversal.h"

namespace wasm::analysis {

template<typename SubType, typename Lattice, bool Backward>
struct VisitorTransferFunc : public Visitor<SubType> {
  template<typename T = BasicBlock::Successors>
  T getDependents(const BasicBlock* currBlock, typename std::enable_if<Backward, bool>::type* = 0) {
    return currBlock->succs();
  }

  template<typename T = BasicBlock::Predecessors>
  T getDependents(const BasicBlock* currBlock, typename std::enable_if<!Backward, bool>::type* = 0) {
    return currBlock->preds();
  }

  void transfer(const BasicBlock* cfgBlock, typename Lattice::Element& inputState) {
    currState = &inputState;
    if constexpr(Backward) {
      for (auto cfgIter = cfgBlock->rbegin(); cfgIter != cfgBlock->rend(); ++cfgIter) {
        static_cast<SubType*>(this)->visit(*cfgIter);
      }
    }
    else {
      for (auto cfgIter = cfgBlock->begin(); cfgIter != cfgBlock->end(); ++cfgIter) {
        static_cast<SubType*>(this)->visit(*cfgIter);
      }
    }
    currState = nullptr;
  }

  void enqueueWorklist(CFG& cfg, std::queue<const BasicBlock*>& worklist) {
    if constexpr(Backward) {
      for (auto it = cfg.rbegin(); it != cfg.rend(); ++it) {
        worklist.push(&(*it));
      }
    }
    else {
      for (auto it = cfg.begin(); it != cfg.end(); ++it) {
        worklist.push(&(*it));
      }
    }
  }

  void collectResults(const BasicBlock* cfgBlock, typename Lattice::Element& inputState) {
    currState = &inputState;
    if constexpr(Backward) {
      for (auto cfgIter = cfgBlock->rbegin(); cfgIter != cfgBlock->rend(); ++cfgIter) {
        static_cast<SubType*>(this)->visit(*cfgIter);
      }
    }
    else {
      for (auto cfgIter = cfgBlock->begin(); cfgIter != cfgBlock->end(); ++cfgIter) {
        static_cast<SubType*>(this)->visit(*cfgIter);
      }
    }
    currState = nullptr;
  }

  protected:
  typename Lattice::Element* currState = nullptr;
};

} // namespace wasm::analysis

#endif // wasm_analysis_visitor_transfer_function_h
