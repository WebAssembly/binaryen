#include "stringify-walker.h"

#if RECONSTRUCT_DEBUG
#define DBG(statement) statement
#else
#define DBG(statement)
#endif

// Check a Result or MaybeResult for error and call Fatal() if the error exists.
#define ASSERT_ERR(val)                                                        \
  if (auto _val = (val); auto err = _val.getErr()) {                           \
    Fatal() << err->msg;                                                       \
  }

namespace wasm {

ReconstructStringifyWalker::ReconstructStringifyWalker(Module* wasm)
  : existingBuilder(*wasm), outlinedBuilder(*wasm) {
  this->setModule(wasm);
  DBG(std::cout << "\n\nexistingBuilder: " << &existingBuilder
                << " outlinedBuilder: " << &outlinedBuilder);
}

void ReconstructStringifyWalker::addUniqueSymbol(SeparatorReason reason) {
  if (auto curr = reason.getFuncStart()) {
    startExistingFunction(curr->func);
    return;
  }

  // instrCounter is managed manually and incremented at the beginning of
  // addUniqueSymbol() and visitExpression(), except for the case where we are
  // starting a new function, as that resets the counters back to 0.
  instrCounter++;

  DBG(std::string desc);
  if (auto curr = reason.getBlockStart()) {
    ASSERT_ERR(existingBuilder.visitBlockStart(curr->block));
    DBG(desc = "Block Start for ";);
  } else if (auto curr = reason.getIfStart()) {
    ASSERT_ERR(existingBuilder.visitIfStart(curr->iff));
    DBG(desc = "If Start for ";);
  } else if (reason.getEnd()) {
    ASSERT_ERR(existingBuilder.visitEnd());
    DBG(desc = "End for ";);
  } else {
    DBG(desc = "addUniqueSymbol for unhandled instruction ";);
    WASM_UNREACHABLE("unimplemented instruction");
  }
  DBG(printAddUniqueSymbol(desc););
}

void ReconstructStringifyWalker::visitExpression(Expression* curr) {
  maybeBeginSeq();

  if (state == NotInSeq) {
    ASSERT_ERR(existingBuilder.visit(curr));
  }

  if (state == InSeq) {
    ASSERT_ERR(outlinedBuilder.visit(curr));
  }

  DBG(printVisitExpression(curr));
  if (state == InSeq || state == InSkipSeq) {
    maybeEndSeq();
  }
}

void ReconstructStringifyWalker::startExistingFunction(Function* func) {
  ASSERT_ERR(existingBuilder.build());
  ASSERT_ERR(existingBuilder.visitFunctionStart(func));
  instrCounter = 0;
  seqCounter = 0;
  state = NotInSeq;
  DBG(std::cout << "\n\n$" << func->name << " Func Start " << &existingBuilder);
}

ReconstructStringifyWalker::ReconstructState
ReconstructStringifyWalker::getCurrState() {
  instrCounter++;
  // We are either in a sequence or not in a sequence. If we are in a sequence
  // and have already created the body of the outlined function that will be
  // called, then we will skip instructions, otherwise we add the instructions
  // to the outlined function. If we are not in a sequence, then the
  // instructions are sent to the existing function.
  if (seqCounter < sequences.size() &&
      instrCounter >= sequences[seqCounter].startIdx &&
      instrCounter <= sequences[seqCounter].endIdx) {
    return getModule()->getFunction(sequences[seqCounter].func)->body
             ? InSkipSeq
             : InSeq;
  }
  return NotInSeq;
}

void ReconstructStringifyWalker::maybeBeginSeq() {
  auto currState = getCurrState();
  if (currState != state) {
    switch (currState) {
      case NotInSeq:
        return;
      case InSeq:
        transitionToInSeq();
        break;
      case InSkipSeq:
        transitionToInSkipSeq();
        break;
    }
  }
  state = currState;
}

void ReconstructStringifyWalker::transitionToInSeq() {
  Function* outlinedFunc = getModule()->getFunction(sequences[seqCounter].func);
  ASSERT_ERR(outlinedBuilder.visitFunctionStart(outlinedFunc));

  // Add a local.get instruction for every parameter of the outlined function.
  Signature sig = outlinedFunc->type.getSignature();
  for (Index i = 0; i < sig.params.size(); i++) {
    ASSERT_ERR(outlinedBuilder.makeLocalGet(i));
  }

  // Make a call from the existing function to the outlined function. This call
  // will replace the instructions moved to the outlined function
  ASSERT_ERR(existingBuilder.makeCall(outlinedFunc->name, false));
  DBG(std::cout << "\ncreated outlined fn: " << outlinedFunc->name);
}

void ReconstructStringifyWalker::transitionToInSkipSeq() {
  Function* outlinedFunc = getModule()->getFunction(sequences[seqCounter].func);
  ASSERT_ERR(existingBuilder.makeCall(outlinedFunc->name, false));
  DBG(std::cout << "\n\nstarting to skip instructions "
                << sequences[seqCounter].startIdx << " - "
                << sequences[seqCounter].endIdx - 1 << " to "
                << sequences[seqCounter].func << " and adding call() instead");
}

void ReconstructStringifyWalker::maybeEndSeq() {
  if (instrCounter + 1 == sequences[seqCounter].endIdx) {
    transitionToNotInSeq();
  }
}

void ReconstructStringifyWalker::transitionToNotInSeq() {
  if (state == InSeq) {
    ASSERT_ERR(outlinedBuilder.visitEnd());
    DBG(std::cout << "\n\nEnd of sequence to " << &outlinedBuilder);
  }
  // Completed a sequence so increase the seqCounter and reset the state
  seqCounter++;
  state = NotInSeq;
}

#if RECONSTRUCT_DEBUG
void ReconstructStringifyWalker::printAddUniqueSymbol(std::string desc) {
  std::cout << "\n"
            << desc << std::to_string(instrCounter) << " to "
            << &existingBuilder;
}
void ReconstructStringifyWalker::printVisitExpression(Expression* curr) {
  auto* builder = state == InSeq      ? &outlinedBuilder
                  : state == NotInSeq ? &existingBuilder
                                      : nullptr;
  auto verb = state == InSkipSeq ? "skipping " : "adding ";
  std::cout << "\n"
            << verb << std::to_string(instrCounter) << ": "
            << ShallowExpression{curr} << " to " << builder;
}
#endif
} // namespace wasm
