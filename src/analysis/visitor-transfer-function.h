#ifndef wasm_analysis_visitor_transfer_function_h
#define wasm_analysis_visitor_transfer_function_h

#include <queue>

#include "cfg.h"
#include "lattice.h"
#include "wasm-traversal.h"

namespace wasm::analysis {

enum class AnalysisDirection { Forward, Backward };

// Utility for visitor-based transfer functions for forward and backward
// analysis. Forward analysis is chosen by default unless the template parameter
// Backward is true.
template<typename SubType, typename Lattice, AnalysisDirection Direction>
struct VisitorTransferFunc : public Visitor<SubType> {
protected:
  typename Lattice::Element* currState = nullptr;

  // There are two distinct phases in the execution of the analyzer. First,
  // the worklist algorithm will be run to obtain a solution, calling
  // transfer() for each block. Then, to collect the final states, the analyzer
  // will iterate over every block, calling collectResults().

  // As there is only one set of visitor functions, they are used both to
  // mutate intermediate states as the transfer function, and also to
  // collect results from the final states. Therefore, we have the variable
  // collectingResults to signal whether we are collecting results from the
  // solved analysis, as opposed to solving the analysis to the visitor
  // functions.
  bool collectingResults = false;

public:
  // Returns an iterable to all the BasicBlocks which depend on currBlock for
  // information.
  BasicBlock::BasicBlockIterable getDependents(const BasicBlock* currBlock) {
    if constexpr (Direction == AnalysisDirection::Backward) {
      return currBlock->preds();
    } else {
      return currBlock->succs();
    }
  }

  // Executes the transfer function on all the expressions of the corresponding
  // CFG node, starting with the node's input state, and changes the input state
  // to the final output state of the node in place.
  void transfer(const BasicBlock* cfgBlock,
                typename Lattice::Element& inputState) {
    // If the block is empty, we propagate the state by inputState =
    // outputState.

    currState = &inputState;
    if constexpr (Direction == AnalysisDirection::Backward) {
      for (auto cfgIter = cfgBlock->rbegin(); cfgIter != cfgBlock->rend();
           ++cfgIter) {
        static_cast<SubType*>(this)->visit(*cfgIter);
      }
    } else {
      for (auto cfgIter = cfgBlock->begin(); cfgIter != cfgBlock->end();
           ++cfgIter) {
        static_cast<SubType*>(this)->visit(*cfgIter);
      }
    }
    currState = nullptr;
  }

  // Enqueues the worklist before the worklist algorithm is run. We want to
  // evaluate the blocks in an order matching the "flow" of the analysis to
  // reduce the number of state propagations needed. Thus, for a forward
  // analysis, we push all the blocks in order, while for backward analysis, we
  // push them in reverse order, so that later blocks are evaluated before
  // earlier ones.
  void enqueueWorklist(CFG& cfg, std::queue<const BasicBlock*>& worklist) {
    if constexpr (Direction == AnalysisDirection::Backward) {
      for (auto it = cfg.rbegin(); it != cfg.rend(); ++it) {
        worklist.push(&(*it));
      }
    } else {
      for (auto it = cfg.begin(); it != cfg.end(); ++it) {
        worklist.push(&(*it));
      }
    }
  }

  // This is for collecting results after solving an analysis. Implemented in
  // the same way as transfer(), but we also set the collectingResults flag.
  void collectResults(const BasicBlock* cfgBlock,
                      typename Lattice::Element& inputState) {
    collectingResults = true;
    currState = &inputState;
    if constexpr (Direction == AnalysisDirection::Backward) {
      for (auto cfgIter = cfgBlock->rbegin(); cfgIter != cfgBlock->rend();
           ++cfgIter) {
        static_cast<SubType*>(this)->visit(*cfgIter);
      }
    } else {
      for (auto cfgIter = cfgBlock->begin(); cfgIter != cfgBlock->end();
           ++cfgIter) {
        static_cast<SubType*>(this)->visit(*cfgIter);
      }
    }
    currState = nullptr;
    collectingResults = false;
  }
};

} // namespace wasm::analysis

#endif // wasm_analysis_visitor_transfer_function_h
