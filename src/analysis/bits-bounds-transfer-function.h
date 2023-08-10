#ifndef wasm_analysis_bits_bounds_transfer_function_h
#define wasm_analysis_bits_bounds_transfer_function_h

#include <unordered_map>

#include "bits-bounds-lattice.h"
#include "ir/bits.h"
#include "ir/stack-utils.h"
#include "stack-lattice.h"
#include "visitor-transfer-function.h"

namespace wasm::analysis {

class MaxBitsTransferFunction
  : public VisitorTransferFunc<MaxBitsTransferFunction,
                               StackLattice<MaxBitsLattice>,
                               AnalysisDirection::Forward> {
  MaxBitsLattice& bitsLattice;

public:
  std::unordered_map<Expression*, Index> exprMaxBounds;

  MaxBitsTransferFunction(MaxBitsLattice& bitsLattice)
    : bitsLattice(bitsLattice) {}

  void visitConst(Const* curr) {
    MaxBitsLattice::Element currElement = bitsLattice.getBottom();

    bool addInformation = true;
    switch (curr->type.getBasic()) {
      case Type::i32:
        currElement.setUpperBound(
          32 - curr->value.countLeadingZeroes().geti32(), curr->value);
        break;
      case Type::i64:
        currElement.setUpperBound(
          64 - curr->value.countLeadingZeroes().geti64(), curr->value);
        break;
      default: {
        addInformation = false;
      }
    }

    if (collectingResults && addInformation) {
      exprMaxBounds[curr] = currElement.upperBound;
    }

    currState->push(std::move(currElement));
  }

  void visitBinary(Binary* curr) {
    MaxBitsLattice::Element right = currState->pop();
    MaxBitsLattice::Element left = currState->pop();

    MaxBitsLattice::Element currElement = bitsLattice.getBottom();

    bool addInformation = true;
    switch (curr->op) {
      case RotLInt32:
      case RotRInt32:
      case SubInt32: {
        currElement.setUpperBound(32);
        break;
      }
      case AddInt32: {
        currElement.setUpperBound(
          std::min(Index(32), std::max(left.upperBound, right.upperBound) + 1));
        break;
      }
      case MulInt32: {
        currElement.setUpperBound(
          std::min(Index(32), left.upperBound + right.upperBound));
        break;
      }
      case DivSInt32: {
        int32_t maxBitsLeft = left.upperBound;
        int32_t maxBitsRight = right.upperBound;
        if (maxBitsLeft == 32 || maxBitsRight == 32) {
          currElement.setUpperBound(32);
        } else {
          currElement.setUpperBound(
            std::max(0, maxBitsLeft - maxBitsRight + 1));
        }
        break;
      }
      case DivUInt32: {
        int32_t maxBitsLeft = left.upperBound;
        int32_t maxBitsRight = right.upperBound;
        currElement.setUpperBound(std::max(0, maxBitsLeft - maxBitsRight + 1));
        break;
      }
      case RemSInt32: {
        if (right.constVal.has_value()) {
          if (left.upperBound == 32) {
            currElement.setUpperBound(32);
          } else {
            auto bitsRight =
              Index(wasm::Bits::ceilLog2(right.constVal.value().geti32()));
            currElement.setUpperBound(std::min(left.upperBound, bitsRight));
          }
        } else {
          currElement.setUpperBound(32);
        }
        break;
      }
      case RemUInt32: {
        if (right.constVal.has_value()) {
          auto bitsRight =
            Index(wasm::Bits::ceilLog2(right.constVal.value().geti32()));
          currElement.setUpperBound(std::min(left.upperBound, bitsRight));
        } else {
          currElement.setUpperBound(32);
        }
        break;
      }
      case AndInt32: {
        currElement.setUpperBound(std::min(left.upperBound, right.upperBound));
        break;
      }
      case OrInt32:
      case XorInt32: {
        currElement.setUpperBound(std::max(left.upperBound, right.upperBound));
        break;
      }
      case ShlInt32: {
        if (right.constVal.has_value()) {
          currElement.setUpperBound(std::min(
            Index(32),
            left.upperBound + Bits::getEffectiveShifts(
                                right.constVal.value().geti32(), Type::i32)));
        }
        break;
      }
      case ShrUInt32: {
        if (right.constVal.has_value()) {
          auto shifts = std::min(Index(Bits::getEffectiveShifts(
                                   right.constVal.value().geti32(), Type::i32)),
                                 left.upperBound);
          currElement.setUpperBound(
            std::max(Index(0), left.upperBound - shifts));
        } else {
          currElement.setUpperBound(32);
        }
        break;
      }
      case ShrSInt32: {
        if (right.constVal.has_value()) {
          if (left.upperBound == 32) {
            currElement.setUpperBound(32);
          } else {
            auto shifts =
              std::min(Index(Bits::getEffectiveShifts(
                         right.constVal.value().geti32(), Type::i32)),
                       left.upperBound);
            currElement.setUpperBound(
              std::max(Index(0), left.upperBound - shifts));
          }
        } else {
          currElement.setUpperBound(32);
        }
        break;
      }
      case RotLInt64:
      case RotRInt64:
      case SubInt64: {
        currElement.setUpperBound(64);
        break;
      }
      case AddInt64: {
        currElement.setUpperBound(
          std::min(Index(64), std::max(left.upperBound, right.upperBound)));
        break;
      }
      case MulInt64: {
        currElement.setUpperBound(
          std::min(Index(64), left.upperBound + right.upperBound));
        break;
      }
      case DivSInt64: {
        int32_t maxBitsLeft = left.upperBound;
        int32_t maxBitsRight = right.upperBound;
        if (maxBitsLeft == 64 || maxBitsRight == 64) {
          currElement.setUpperBound(64);
        } else {
          currElement.setUpperBound(
            std::max(0, maxBitsLeft - maxBitsRight + 1));
        }
        break;
      }
      case DivUInt64: {
        int32_t maxBitsLeft = left.upperBound;
        int32_t maxBitsRight = right.upperBound;
        currElement.setUpperBound(std::max(0, maxBitsLeft - maxBitsRight + 1));
        break;
      }
      case RemSInt64: {
        if (right.constVal.has_value()) {
          if (left.upperBound == 64) {
            currElement.setUpperBound(64);
          } else {
            auto bitsRight =
              Index(wasm::Bits::ceilLog2(right.constVal.value().geti64()));
            currElement.setUpperBound(std::min(left.upperBound, bitsRight));
          }
        } else {
          currElement.setUpperBound(64);
        }
        break;
      }
      case RemUInt64: {
        if (right.constVal.has_value()) {
          auto bitsRight =
            Index(wasm::Bits::ceilLog2(right.constVal.value().geti64()));
          currElement.setUpperBound(std::min(left.upperBound, bitsRight));
        } else {
          currElement.setUpperBound(64);
        }
        break;
      }
      case AndInt64: {
        currElement.setUpperBound(std::min(left.upperBound, right.upperBound));
        break;
      }
      case OrInt64:
      case XorInt64: {
        currElement.setUpperBound(std::max(left.upperBound, right.upperBound));
        break;
      }
      case ShlInt64: {
        if (right.constVal.has_value()) {
          currElement.setUpperBound(
            std::min(Index(64),
                     Bits::getEffectiveShifts(right.constVal.value().geti64(),
                                              Type::i64) +
                       left.upperBound));
        } else {
          currElement.setUpperBound(64);
        }
        break;
      }
      case ShrUInt64: {
        if (right.constVal.has_value()) {
          auto shifts = std::min(Index(Bits::getEffectiveShifts(
                                   right.constVal.value().geti64(), Type::i64)),
                                 left.upperBound);
          currElement.setUpperBound(
            std::max(Index(0), left.upperBound - shifts));
        } else {
          currElement.setUpperBound(64);
        }
        break;
      }
      case ShrSInt64: {
        if (right.constVal.has_value()) {
          if (left.upperBound == 64) {
            currElement.setUpperBound(64);
          } else {
            auto shifts =
              std::min(Index(Bits::getEffectiveShifts(
                         right.constVal.value().geti64(), Type::i64)),
                       left.upperBound);
            currElement.setUpperBound(
              std::max(Index(0), left.upperBound - shifts));
          }
        } else {
          currElement.setUpperBound(64);
        }
        break;
      }
      default: {
        addInformation = false;
      }
    }

    if (collectingResults && addInformation) {
      exprMaxBounds[curr] = currElement.upperBound;
    }

    currState->push(std::move(currElement));
  }

  void visitUnary(Unary* curr) {
    MaxBitsLattice::Element unaryVal = currState->pop();
    MaxBitsLattice::Element currElement = bitsLattice.getBottom();

    bool addInformation = true;
    switch (curr->op) {
      case ClzInt32:
      case CtzInt32:
      case PopcntInt32: {
        currElement.setUpperBound(6);
        break;
      }
      case ClzInt64:
      case CtzInt64:
      case PopcntInt64: {
        currElement.setUpperBound(7);
        break;
      }
      case WrapInt64:
      case ExtendUInt32: {
        currElement.setUpperBound(unaryVal.upperBound);
        break;
      }
      case ExtendS8Int32: {
        currElement.setUpperBound(
          unaryVal.upperBound >= 8 ? Index(32) : unaryVal.upperBound);
        break;
      }
      case ExtendS16Int32: {
        currElement.setUpperBound(
          unaryVal.upperBound >= 16 ? Index(32) : unaryVal.upperBound);
        break;
      }
      case ExtendS8Int64: {
        currElement.setUpperBound(
          unaryVal.upperBound >= 8 ? Index(64) : unaryVal.upperBound);
        break;
      }
      case ExtendS16Int64: {
        currElement.setUpperBound(
          unaryVal.upperBound >= 16 ? Index(64) : unaryVal.upperBound);
        break;
      }
      case ExtendS32Int64:
      case ExtendSInt32: {
        currElement.setUpperBound(
          unaryVal.upperBound >= 32 ? Index(64) : unaryVal.upperBound);
        break;
      }
      default: {
        addInformation = false;
      }
    }

    if (collectingResults && addInformation) {
      exprMaxBounds[curr] = currElement.upperBound;
    }

    currState->push(std::move(currElement));
  }

  void visitLocalSet(LocalSet* curr) {
    MaxBitsLattice::Element val = currState->pop();

    if (collectingResults && !val.isTop()) {
      exprMaxBounds[curr] = val.upperBound;
    }
  }

  void visitExpression(Expression* curr) {
    StackSignature exprSignature(curr);
    for (size_t i = 0; i < exprSignature.params.size(); ++i) {
      MaxBitsLattice::Element currElement = bitsLattice.getBottom();
      currElement.setTop();
      currState->push(std::move(currElement));
    }

    for (size_t i = 0; i < exprSignature.results.size(); ++i) {
      currState->pop();
    }
  }
};

} // namespace wasm::analysis

#endif // wasm_analysis_bits_bounds_transfer_function_h
