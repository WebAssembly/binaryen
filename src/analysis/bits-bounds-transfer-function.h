/*
 * Copyright 2023 WebAssembly Community Group participants
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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

    switch (curr->type.getBasic()) {
      case Type::i32:
        currElement.setLiteralValue(curr->value);
        if (collectingResults) {
          exprMaxBounds[curr] = currElement.getUpperBound().value();
        }
        break;
      case Type::i64:
        currElement.setLiteralValue(curr->value);
        if (collectingResults) {
          exprMaxBounds[curr] = currElement.getUpperBound().value();
        }
        break;
      default: {
      }
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
        // TODO: Use a more precise estimate for these cases.
        currElement.setUpperBound(32);
        break;
      }
      case AddInt32: {
        currElement.setUpperBound(
          std::min(Index(32),
                   std::max(left.geti32ApproxUpperBound(),
                            right.geti32ApproxUpperBound()) +
                     1));
        break;
      }
      case MulInt32: {
        currElement.setUpperBound(std::min(Index(32),
                                           left.geti32ApproxUpperBound() +
                                             right.geti32ApproxUpperBound()));
        break;
      }
      case DivSInt32: {
        int32_t maxBitsLeft = left.geti32ApproxUpperBound();
        int32_t maxBitsRight = right.geti32ApproxUpperBound();
        if (maxBitsLeft == 32 || maxBitsRight == 32) {
          currElement.setUpperBound(32);
        } else {
          currElement.setUpperBound(
            std::max(0, maxBitsLeft - maxBitsRight + 1));
        }
        break;
      }
      case DivUInt32: {
        int32_t maxBitsLeft = left.geti32ApproxUpperBound();
        int32_t maxBitsRight = right.geti32ApproxUpperBound();
        currElement.setUpperBound(std::max(0, maxBitsLeft - maxBitsRight + 1));
        break;
      }
      case RemSInt32: {
        std::optional<Literal> constRightValue = right.getLiteral();
        if (constRightValue.has_value()) {
          Index leftUpperBound = left.geti32ApproxUpperBound();
          if (leftUpperBound == 32) {
            currElement.setUpperBound(32);
          } else {
            auto bitsRight =
              Index(wasm::Bits::ceilLog2(constRightValue.value().geti32()));
            currElement.setUpperBound(std::min(leftUpperBound, bitsRight));
          }
        } else {
          currElement.setUpperBound(32);
        }
        break;
      }
      case RemUInt32: {
        std::optional<Literal> constRightValue = right.getLiteral();
        if (constRightValue.has_value()) {
          auto bitsRight =
            Index(wasm::Bits::ceilLog2(constRightValue.value().geti32()));
          currElement.setUpperBound(
            std::min(left.geti32ApproxUpperBound(), bitsRight));
        } else {
          currElement.setUpperBound(32);
        }
        break;
      }
      case AndInt32: {
        currElement.setUpperBound(std::min(left.geti32ApproxUpperBound(),
                                           right.geti32ApproxUpperBound()));
        break;
      }
      case OrInt32:
      case XorInt32: {
        currElement.setUpperBound(std::max(left.geti32ApproxUpperBound(),
                                           right.geti32ApproxUpperBound()));
        break;
      }
      case ShlInt32: {
        std::optional<Literal> constRightValue = right.getLiteral();
        if (constRightValue.has_value()) {
          currElement.setUpperBound(
            std::min(Index(32),
                     left.geti32ApproxUpperBound() +
                       Bits::getEffectiveShifts(
                         constRightValue.value().geti32(), Type::i32)));
        }
        break;
      }
      case ShrUInt32: {
        std::optional<Literal> constRightValue = right.getLiteral();
        if (constRightValue.has_value()) {
          Index leftUpperBound = left.geti32ApproxUpperBound();
          auto shifts =
            std::min(Index(Bits::getEffectiveShifts(
                       constRightValue.value().geti32(), Type::i32)),
                     leftUpperBound);
          currElement.setUpperBound(
            std::max(Index(0), leftUpperBound - shifts));
        } else {
          currElement.setUpperBound(32);
        }
        break;
      }
      case ShrSInt32: {
        std::optional<Literal> constRightValue = right.getLiteral();
        Index leftUpperBound = left.geti32ApproxUpperBound();
        if (constRightValue.has_value()) {
          if (leftUpperBound == 32) {
            currElement.setUpperBound(32);
          } else {
            auto shifts =
              std::min(Index(Bits::getEffectiveShifts(
                         constRightValue.value().geti32(), Type::i32)),
                       leftUpperBound);
            currElement.setUpperBound(
              std::max(Index(0), leftUpperBound - shifts));
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
          std::min(Index(64),
                   std::max(left.geti64ApproxUpperBound(),
                            right.geti64ApproxUpperBound())));
        break;
      }
      case MulInt64: {
        currElement.setUpperBound(std::min(Index(64),
                                           left.geti64ApproxUpperBound() +
                                             right.geti64ApproxUpperBound()));
        break;
      }
      case DivSInt64: {
        int32_t maxBitsLeft = left.geti64ApproxUpperBound();
        int32_t maxBitsRight = right.geti64ApproxUpperBound();
        if (maxBitsLeft == 64 || maxBitsRight == 64) {
          currElement.setUpperBound(64);
        } else {
          currElement.setUpperBound(
            std::max(0, maxBitsLeft - maxBitsRight + 1));
        }
        break;
      }
      case DivUInt64: {
        int32_t maxBitsLeft = left.geti64ApproxUpperBound();
        int32_t maxBitsRight = right.geti64ApproxUpperBound();
        currElement.setUpperBound(std::max(0, maxBitsLeft - maxBitsRight + 1));
        break;
      }
      case RemSInt64: {
        std::optional<Literal> constRightValue = right.getLiteral();
        Index leftUpperBound = left.geti64ApproxUpperBound();
        if (constRightValue.has_value()) {
          if (leftUpperBound == 64) {
            currElement.setUpperBound(64);
          } else {
            auto bitsRight =
              Index(wasm::Bits::ceilLog2(constRightValue.value().geti64()));
            currElement.setUpperBound(std::min(leftUpperBound, bitsRight));
          }
        } else {
          currElement.setUpperBound(64);
        }
        break;
      }
      case RemUInt64: {
        std::optional<Literal> constRightValue = right.getLiteral();
        if (constRightValue.has_value()) {
          auto bitsRight =
            Index(wasm::Bits::ceilLog2(constRightValue.value().geti64()));
          currElement.setUpperBound(
            std::min(left.geti64ApproxUpperBound(), bitsRight));
        } else {
          currElement.setUpperBound(64);
        }
        break;
      }
      case AndInt64: {
        currElement.setUpperBound(std::min(left.geti64ApproxUpperBound(),
                                           right.geti64ApproxUpperBound()));
        break;
      }
      case OrInt64:
      case XorInt64: {
        currElement.setUpperBound(std::max(left.geti64ApproxUpperBound(),
                                           right.geti64ApproxUpperBound()));
        break;
      }
      case ShlInt64: {
        std::optional<Literal> constRightValue = right.getLiteral();
        if (constRightValue.has_value()) {
          currElement.setUpperBound(
            std::min(Index(64),
                     Bits::getEffectiveShifts(constRightValue.value().geti64(),
                                              Type::i64) +
                       left.geti64ApproxUpperBound()));
        } else {
          currElement.setUpperBound(64);
        }
        break;
      }
      case ShrUInt64: {
        std::optional<Literal> constRightValue = right.getLiteral();
        if (constRightValue.has_value()) {
          Index leftUpperBound = left.geti64ApproxUpperBound();
          auto shifts =
            std::min(Index(Bits::getEffectiveShifts(
                       constRightValue.value().geti64(), Type::i64)),
                     leftUpperBound);
          currElement.setUpperBound(
            std::max(Index(0), leftUpperBound - shifts));
        } else {
          currElement.setUpperBound(64);
        }
        break;
      }
      case ShrSInt64: {
        std::optional<Literal> constRightValue = right.getLiteral();
        Index leftUpperBound = left.geti64ApproxUpperBound();
        if (constRightValue.has_value()) {
          if (leftUpperBound == 64) {
            currElement.setUpperBound(64);
          } else {
            auto shifts =
              std::min(Index(Bits::getEffectiveShifts(
                         constRightValue.value().geti64(), Type::i64)),
                       leftUpperBound);
            currElement.setUpperBound(
              std::max(Index(0), leftUpperBound - shifts));
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
      exprMaxBounds[curr] = currElement.getUpperBound().value();
    }

    currState->push(std::move(currElement));
  }

  void visitUnary(Unary* curr) {
    MaxBitsLattice::Element val = currState->pop();
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
      case WrapInt64: {
        currElement.setUpperBound(val.geti64ApproxUpperBound());
        break;
      }
      case ExtendUInt32: {
        currElement.setUpperBound(val.geti32ApproxUpperBound());
        break;
      }
      case ExtendS8Int32: {
        Index upperBound = val.geti32ApproxUpperBound();
        currElement.setUpperBound(upperBound >= 8 ? Index(32) : upperBound);
        break;
      }
      case ExtendS16Int32: {
        Index upperBound = val.geti32ApproxUpperBound();
        currElement.setUpperBound(upperBound >= 16 ? Index(32) : upperBound);
        break;
      }
      case ExtendS8Int64: {
        Index upperBound = val.geti64ApproxUpperBound();
        currElement.setUpperBound(upperBound >= 8 ? Index(64) : upperBound);
        break;
      }
      case ExtendS16Int64: {
        Index upperBound = val.geti64ApproxUpperBound();
        currElement.setUpperBound(upperBound >= 16 ? Index(64) : upperBound);
        break;
      }
      case ExtendS32Int64: {
        Index upperBound = val.geti64ApproxUpperBound();
        currElement.setUpperBound(upperBound >= 32 ? Index(64) : upperBound);
        break;
      }
      // TODO: What's the difference of this with the above?
      case ExtendSInt32: {
        Index upperBound = val.geti32ApproxUpperBound();
        currElement.setUpperBound(upperBound >= 32 ? Index(64) : upperBound);
        break;
      }
      default: {
        addInformation = false;
      }
    }

    if (collectingResults && addInformation) {
      exprMaxBounds[curr] = currElement.getUpperBound().value();
    }

    currState->push(std::move(currElement));
  }

  void visitLocalSet(LocalSet* curr) {
    MaxBitsLattice::Element val = currState->pop();

    if (collectingResults && curr->isTee()) {
      std::optional<Index> upperBound = val.getUpperBound();
      if (upperBound.has_value()) {
        exprMaxBounds[curr] = upperBound.value();
      }
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
