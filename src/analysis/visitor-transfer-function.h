#ifndef wasm_analysis_visitor_transfer_function_h
#define wasm_analysis_visitor_transfer_function_h

#include <queue>

#include "cfg.h"
#include "lattice.h"
#include "support/unique_deferring_queue.h"
#include "wasm-traversal.h"

namespace wasm::analysis {

enum class AnalysisDirection { Forward, Backward };

// Utility for visitor-based transfer functions for forward and backward
// analysis. Forward analysis is chosen by default unless the template parameter
// Backward is true.
template<typename SubType, Lattice L, AnalysisDirection Direction>
struct VisitorTransferFunc : public Visitor<SubType> {
protected:
  typename L::Element* currState = nullptr;

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
  // Executes the transfer function on all the expressions of the corresponding
  // CFG node, starting with the node's input state, and changes the input state
  // to the final output state of the node in place.
  const std::vector<const BasicBlock*>&
  transfer(const BasicBlock& bb, typename L::Element& inputState) noexcept {
    // If the block is empty, we propagate the state by inputState =
    // outputState.

    currState = &inputState;
    if constexpr (Direction == AnalysisDirection::Backward) {
      for (auto cfgIter = bb.rbegin(); cfgIter != bb.rend(); ++cfgIter) {
        static_cast<SubType*>(this)->visit(*cfgIter);
      }
    } else {
      for (auto* inst : bb) {
        static_cast<SubType*>(this)->visit(inst);
      }
    }
    currState = nullptr;

    if constexpr (Direction == AnalysisDirection::Backward) {
      return bb.preds();
    } else {
      return bb.succs();
    }
  }

  // This is for collecting results after solving an analysis. Implemented in
  // the same way as transfer(), but we also set the collectingResults flag.
  void collectResults(const BasicBlock& bb, typename L::Element& inputState) {
    collectingResults = true;
    currState = &inputState;
    if constexpr (Direction == AnalysisDirection::Backward) {
      for (auto it = bb.rbegin(); it != bb.rend(); ++it) {
        static_cast<SubType*>(this)->visit(*it);
      }
    } else {
      for (auto it = bb.begin(); it != bb.end(); ++it) {
        static_cast<SubType*>(this)->visit(*it);
      }
    }
    currState = nullptr;
    collectingResults = false;
  }
};

} // namespace wasm::analysis

#endif // wasm_analysis_visitor_transfer_function_h
