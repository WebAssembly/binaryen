/*
 * Copyright 2016 WebAssembly Community Group participants
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

//
// Optimize combinations of instructions
//

#include <algorithm>

#include <wasm.h>
#include <pass.h>
#include <wasm-s-parser.h>
#include <support/threads.h>
#include <ir/abstract.h>
#include <ir/utils.h>
#include <ir/cost.h>
#include <ir/effects.h>
#include <ir/manipulation.h>
#include <ir/properties.h>
#include <ir/literal-utils.h>
#include <ir/load-utils.h>

// TODO: Use the new sign-extension opcodes where appropriate. This needs to be conditionalized on the availability of atomics.

namespace wasm {

Name I32_EXPR  = "i32.expr",
     I64_EXPR  = "i64.expr",
     F32_EXPR  = "f32.expr",
     F64_EXPR  = "f64.expr",
     ANY_EXPR  = "any.expr";

// Utilities

// returns the maximum amount of bits used in an integer expression
// not extremely precise (doesn't look into add operands, etc.)
// LocalInfoProvider is an optional class that can provide answers about
// get_local.
template<typename LocalInfoProvider>
Index getMaxBits(Expression* curr, LocalInfoProvider* localInfoProvider) {
  if (auto* const_ = curr->dynCast<Const>()) {
    switch (curr->type) {
      case i32: return 32 - const_->value.countLeadingZeroes().geti32();
      case i64: return 64 - const_->value.countLeadingZeroes().geti64();
      default: WASM_UNREACHABLE();
    }
  } else if (auto* binary = curr->dynCast<Binary>()) {
    switch (binary->op) {
      // 32-bit
      case AddInt32: case SubInt32: case MulInt32:
      case DivSInt32: case DivUInt32: case RemSInt32:
      case RemUInt32: case RotLInt32: case RotRInt32: return 32;
      case AndInt32: return std::min(getMaxBits(binary->left, localInfoProvider), getMaxBits(binary->right, localInfoProvider));
      case OrInt32: case XorInt32: return std::max(getMaxBits(binary->left, localInfoProvider), getMaxBits(binary->right, localInfoProvider));
      case ShlInt32: {
        if (auto* shifts = binary->right->dynCast<Const>()) {
          return std::min(Index(32), getMaxBits(binary->left, localInfoProvider) + Bits::getEffectiveShifts(shifts));
        }
        return 32;
      }
      case ShrUInt32: {
        if (auto* shift = binary->right->dynCast<Const>()) {
          auto maxBits = getMaxBits(binary->left, localInfoProvider);
          auto shifts = std::min(Index(Bits::getEffectiveShifts(shift)), maxBits); // can ignore more shifts than zero us out
          return std::max(Index(0), maxBits - shifts);
        }
        return 32;
      }
      case ShrSInt32: {
        if (auto* shift = binary->right->dynCast<Const>()) {
          auto maxBits = getMaxBits(binary->left, localInfoProvider);
          if (maxBits == 32) return 32;
          auto shifts = std::min(Index(Bits::getEffectiveShifts(shift)), maxBits); // can ignore more shifts than zero us out
          return std::max(Index(0), maxBits - shifts);
        }
        return 32;
      }
      // 64-bit TODO
      // comparisons
      case EqInt32: case NeInt32: case LtSInt32:
      case LtUInt32: case LeSInt32: case LeUInt32:
      case GtSInt32: case GtUInt32: case GeSInt32:
      case GeUInt32:
      case EqInt64: case NeInt64: case LtSInt64:
      case LtUInt64: case LeSInt64: case LeUInt64:
      case GtSInt64: case GtUInt64: case GeSInt64:
      case GeUInt64:
      case EqFloat32: case NeFloat32:
      case LtFloat32: case LeFloat32: case GtFloat32: case GeFloat32:
      case EqFloat64: case NeFloat64:
      case LtFloat64: case LeFloat64: case GtFloat64: case GeFloat64: return 1;
      default: {}
    }
  } else if (auto* unary = curr->dynCast<Unary>()) {
    switch (unary->op) {
      case ClzInt32: case CtzInt32: case PopcntInt32: return 6;
      case ClzInt64: case CtzInt64: case PopcntInt64: return 7;
      case EqZInt32: case EqZInt64: return 1;
      case WrapInt64: return std::min(Index(32), getMaxBits(unary->value, localInfoProvider));
      default: {}
    }
  } else if (auto* set = curr->dynCast<SetLocal>()) {
    // a tee passes through the value
    return getMaxBits(set->value, localInfoProvider);
  } else if (auto* get = curr->dynCast<GetLocal>()) {
    return localInfoProvider->getMaxBitsForLocal(get);
  } else if (auto* load = curr->dynCast<Load>()) {
    // if signed, then the sign-extension might fill all the bits
    // if unsigned, then we have a limit
    if (LoadUtils::isSignRelevant(load) && !load->signed_) {
      return 8 * load->bytes;
    }
  }
  switch (curr->type) {
    case i32: return 32;
    case i64: return 64;
    case unreachable: return 64; // not interesting, but don't crash
    default: WASM_UNREACHABLE();
  }
}

// Useful information about locals
struct LocalInfo {
  static const Index kUnknown = Index(-1);

  Index maxBits;
  Index signExtedBits;
};

struct LocalScanner : PostWalker<LocalScanner> {
  std::vector<LocalInfo>& localInfo;

  LocalScanner(std::vector<LocalInfo>& localInfo) : localInfo(localInfo) {}

  void doWalkFunction(Function* func) {
    // prepare
    localInfo.resize(func->getNumLocals());
    for (Index i = 0; i < func->getNumLocals(); i++) {
      auto& info = localInfo[i];
      if (func->isParam(i)) {
        info.maxBits = getBitsForType(func->getLocalType(i)); // worst-case
        info.signExtedBits = LocalInfo::kUnknown; // we will never know anything
      } else {
        info.maxBits = info.signExtedBits = 0; // we are open to learning
      }
    }
    // walk
    PostWalker<LocalScanner>::doWalkFunction(func);
    // finalize
    for (Index i = 0; i < func->getNumLocals(); i++) {
      auto& info = localInfo[i];
      if (info.signExtedBits == LocalInfo::kUnknown) {
        info.signExtedBits = 0;
      }
    }
  }

  void visitSetLocal(SetLocal* curr) {
    auto* func = getFunction();
    if (func->isParam(curr->index)) return;
    auto type = getFunction()->getLocalType(curr->index);
    if (type != i32 && type != i64) return;
    // an integer var, worth processing
    auto* value = Properties::getFallthrough(curr->value);
    auto& info = localInfo[curr->index];
    info.maxBits = std::max(info.maxBits, getMaxBits(value, this));
    auto signExtBits = LocalInfo::kUnknown;
    if (Properties::getSignExtValue(value)) {
      signExtBits = Properties::getSignExtBits(value);
    } else if (auto* load = value->dynCast<Load>()) {
      if (LoadUtils::isSignRelevant(load) && load->signed_) {
        signExtBits = load->bytes * 8;
      }
    }
    if (info.signExtedBits == 0) {
      info.signExtedBits = signExtBits; // first info we see
    } else if (info.signExtedBits != signExtBits) {
      info.signExtedBits = LocalInfo::kUnknown; // contradictory information, give up
    }
  }

  // define this for the templated getMaxBits method. we know nothing here yet about locals, so return the maxes
  Index getMaxBitsForLocal(GetLocal* get) {
    return getBitsForType(get->type);
  }

  Index getBitsForType(Type type) {
    switch (type) {
      case i32: return 32;
      case i64: return 64;
      default: return -1;
    }
  }
};

// Main pass class
struct OptimizeInstructions : public WalkerPass<PostWalker<OptimizeInstructions, UnifiedExpressionVisitor<OptimizeInstructions>>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new OptimizeInstructions; }

  void prepareToRun(PassRunner* runner, Module* module) override {
#if 0
    static DatabaseEnsurer ensurer;
#endif
  }

  void doWalkFunction(Function* func) {
    // first, scan locals
    {
      LocalScanner scanner(localInfo);
      scanner.walkFunction(func);
    }
    // main walk
    super::doWalkFunction(func);
  }

  void visitExpression(Expression* curr) {
    // we may be able to apply multiple patterns, one may open opportunities that look deeper NB: patterns must not have cycles
    while (1) {
      auto* handOptimized = handOptimize(curr);
      if (handOptimized) {
        curr = handOptimized;
        replaceCurrent(curr);
        continue;
      }
#if 0
      auto iter = database->patternMap.find(curr->_id);
      if (iter == database->patternMap.end()) return;
      auto& patterns = iter->second;
      bool more = false;
      for (auto& pattern : patterns) {
        Match match(*getModule(), pattern);
        if (match.check(curr)) {
          curr = match.apply();
          replaceCurrent(curr);
          more = true;
          break; // exit pattern for loop, return to main while loop
        }
      }
      if (!more) break;
#else
      break;
#endif
    }
  }

  // Optimizations that don't yet fit in the pattern DSL, but could be eventually maybe
  Expression* handOptimize(Expression* curr) {
    // if this contains dead code, don't bother trying to optimize it, the type
    // might change (if might not be unreachable if just one arm is, for example).
    // this optimization pass focuses on actually executing code. the only
    // exceptions are control flow changes
    if (curr->type == unreachable &&
        !curr->is<Break>() && !curr->is<Switch>() && !curr->is<If>()) {
      return nullptr;
    }
    if (auto* binary = curr->dynCast<Binary>()) {
      if (Properties::isSymmetric(binary)) {
        // canonicalize a const to the second position
        if (binary->left->is<Const>() && !binary->right->is<Const>()) {
          std::swap(binary->left, binary->right);
        }
      }
      if (auto* ext = Properties::getAlmostSignExt(binary)) {
        Index extraShifts;
        auto bits = Properties::getAlmostSignExtBits(binary, extraShifts);
        if (extraShifts == 0) {
          if (auto* load = Properties::getFallthrough(ext)->dynCast<Load>()) {
            // pattern match a load of 8 bits and a sign extend using a shl of 24 then shr_s of 24 as well, etc.
            if (LoadUtils::canBeSigned(load) &&
                ((load->bytes == 1 && bits == 8) || (load->bytes == 2 && bits == 16))) {
              // if the value falls through, we can't alter the load, as it might be captured in a tee
              if (load->signed_ == true || load == ext) {
                load->signed_ = true;
                return ext;
              }
            }
          }
        }
        // if the sign-extend input cannot have a sign bit, we don't need it
        // we also don't need it if it already has an identical-sized sign extend
        if (getMaxBits(ext, this) + extraShifts < bits || isSignExted(ext, bits)) {
          return removeAlmostSignExt(binary);
        }
      } else if (binary->op == EqInt32 || binary->op == NeInt32) {
        if (auto* c = binary->right->dynCast<Const>()) {
          if (binary->op == EqInt32 && c->value.geti32() == 0) {
            // equal 0 => eqz
            return Builder(*getModule()).makeUnary(EqZInt32, binary->left);
          }
          if (auto* ext = Properties::getSignExtValue(binary->left)) {
            // we are comparing a sign extend to a constant, which means we can use a cheaper zext
            auto bits = Properties::getSignExtBits(binary->left);
            binary->left = makeZeroExt(ext, bits);
            // when we replace the sign-ext of the non-constant with a zero-ext, we are forcing
            // the high bits to be all zero, instead of all zero or all one depending on the
            // sign bit. so we may be changing the high bits from all one to all zero:
            //  * if the constant value's higher bits are mixed, then it can't be equal anyhow
            //  * if they are all zero, we may get a false true if the non-constant's upper bits
            //    were one. this can only happen if the non-constant's sign bit is set, so this
            //    false true is a risk only if the constant's sign bit is set (otherwise, false).
            //    But a constant with a sign bit but with upper bits zero is impossible to be
            //    equal to a sign-extended value anyhow, so the entire thing is false.
            //  * if they were all one, we may get a false false, if the only difference is in
            //    those upper bits. that means we are equal on the other bits, including the sign
            //    bit. so we can just mask off the upper bits in the constant value, in this
            //    case, forcing them to zero like we do in the zero-extend.
            int32_t constValue = c->value.geti32();
            auto upperConstValue = constValue & ~Bits::lowBitMask(bits);
            uint32_t count = PopCount(upperConstValue);
            auto constSignBit = constValue & (1 << (bits - 1));
            if ((count > 0 && count < 32 - bits) || (constSignBit && count == 0)) {
              // mixed or [zero upper const bits with sign bit set]; the compared values can never be identical, so
              // force something definitely impossible even after zext
              assert(bits < 32);
              c->value = Literal(int32_t(0x80000000));
              // TODO: if no side effects, we can just replace it all with 1 or 0
            } else {
              // otherwise, they are all ones, so we can mask them off as mentioned before
              c->value = c->value.and_(Literal(Bits::lowBitMask(bits)));
            }
            return binary;
          }
        } else if (auto* left = Properties::getSignExtValue(binary->left)) {
          if (auto* right = Properties::getSignExtValue(binary->right)) {
            auto bits = Properties::getSignExtBits(binary->left);
            if (Properties::getSignExtBits(binary->right) == bits) {
              // we are comparing two sign-exts with the same bits, so we may as well replace both with cheaper zexts
              binary->left = makeZeroExt(left, bits);
              binary->right = makeZeroExt(right, bits);
              return binary;
            }
          } else if (auto* load = binary->right->dynCast<Load>()) {
            // we are comparing a load to a sign-ext, we may be able to switch to zext
            auto leftBits = Properties::getSignExtBits(binary->left);
            if (load->signed_ && leftBits == load->bytes * 8) {
              load->signed_ = false;
              binary->left = makeZeroExt(left, leftBits);
              return binary;
            }
          }
        } else if (auto* load = binary->left->dynCast<Load>()) {
          if (auto* right = Properties::getSignExtValue(binary->right)) {
            // we are comparing a load to a sign-ext, we may be able to switch to zext
            auto rightBits = Properties::getSignExtBits(binary->right);
            if (load->signed_ && rightBits == load->bytes * 8) {
              load->signed_ = false;
              binary->right = makeZeroExt(right, rightBits);
              return binary;
            }
          }
        }
        // note that both left and right may be consts, but then we let precompute compute the constant result
      } else if (binary->op == AddInt32) {
        // try to get rid of (0 - ..), that is, a zero only used to negate an
        // int. an add of a subtract can be flipped in order to remove it:
        //   (i32.add
        //     (i32.sub
        //       (i32.const 0)
        //       X
        //     )
        //     Y
        //   )
        // =>
        //   (i32.sub
        //     Y
        //     X
        //   )
        // Note that this reorders X and Y, so we need to be careful about that.
        if (auto* sub = binary->left->dynCast<Binary>()) {
          if (sub->op == SubInt32) {
            if (auto* subZero = sub->left->dynCast<Const>()) {
              if (subZero->value.geti32() == 0) {
                if (EffectAnalyzer::canReorder(getPassOptions(), sub->right, binary->right)) {
                  sub->left = binary->right;
                  return sub;
                }
              }
            }
          }
        }
        // The flip case is even easier, as no reordering occurs:
        //   (i32.add
        //     Y
        //     (i32.sub
        //       (i32.const 0)
        //       X
        //     )
        //   )
        // =>
        //   (i32.sub
        //     Y
        //     X
        //   )
        if (auto* sub = binary->right->dynCast<Binary>()) {
          if (sub->op == SubInt32) {
            if (auto* subZero = sub->left->dynCast<Const>()) {
              if (subZero->value.geti32() == 0) {
                sub->left = binary->left;
                return sub;
              }
            }
          }
        }
        auto* ret = optimizeAddedConstants(binary);
        if (ret) return ret;
      } else if (binary->op == SubInt32) {
        auto* ret = optimizeAddedConstants(binary);
        if (ret) return ret;
      }
      // a bunch of operations on a constant right side can be simplified
      if (auto* right = binary->right->dynCast<Const>()) {
        if (binary->op == AndInt32) {
          auto mask = right->value.geti32();
          // and with -1 does nothing (common in asm.js output)
          if (mask == -1) {
            return binary->left;
          }
          // small loads do not need to be masked, the load itself masks
          if (auto* load = binary->left->dynCast<Load>()) {
            if ((load->bytes == 1 && mask == 0xff) ||
                (load->bytes == 2 && mask == 0xffff)) {
              load->signed_ = false;
              return binary->left;
            }
          } else if (auto maskedBits = Bits::getMaskedBits(mask)) {
            if (getMaxBits(binary->left, this) <= maskedBits) {
              // a mask of lower bits is not needed if we are already smaller
              return binary->left;
            }
          }
        }
        // some math operations have trivial results
        Expression* ret = optimizeWithConstantOnRight(binary);
        if (ret) return ret;
        // the square of some operations can be merged
        if (auto* left = binary->left->dynCast<Binary>()) {
          if (left->op == binary->op) {
            if (auto* leftRight = left->right->dynCast<Const>()) {
              if (left->op == AndInt32) {
                leftRight->value = leftRight->value.and_(right->value);
                return left;
              } else if (left->op == OrInt32) {
                leftRight->value = leftRight->value.or_(right->value);
                return left;
              } else if (left->op == ShlInt32 || left->op == ShrUInt32 || left->op == ShrSInt32 ||
                         left->op == ShlInt64 || left->op == ShrUInt64 || left->op == ShrSInt64) {
                // shifts only use an effective amount from the constant, so adding must
                // be done carefully
                auto total = Bits::getEffectiveShifts(leftRight) + Bits::getEffectiveShifts(right);
                if (total == Bits::getEffectiveShifts(total, right->type)) {
                  // no overflow, we can do this
                  leftRight->value = LiteralUtils::makeLiteralFromInt32(total, right->type);
                  return left;
                } // TODO: handle overflows
              }
            }
          }
        }
        // math operations on a constant power of 2 right side can be optimized
        if (right->type == i32) {
          uint32_t c = right->value.geti32();
          if (IsPowerOf2(c)) {
            if (binary->op == MulInt32) {
              return optimizePowerOf2Mul(binary, c);
            } else if (binary->op == RemUInt32) {
              return optimizePowerOf2URem(binary, c);
            }
          }
        }
      }
      // a bunch of operations on a constant left side can be simplified
      if (binary->left->is<Const>()) {
        Expression* ret = optimizeWithConstantOnLeft(binary);
        if (ret) return ret;
      }
      // bitwise operations
      if (binary->op == AndInt32) {
        // try de-morgan's AND law,
        //  (eqz X) and (eqz Y) === eqz (X or Y)
        // Note that the OR and XOR laws do not work here, as these
        // are not booleans (we could check if they are, but a boolean
        // would already optimize with the eqz anyhow, unless propagating).
        // But for AND, the left is true iff X and Y are each all zero bits,
        // and the right is true if the union of their bits is zero; same.
        if (auto* left = binary->left->dynCast<Unary>()) {
          if (left->op == EqZInt32) {
            if (auto* right = binary->right->dynCast<Unary>()) {
              if (right->op == EqZInt32) {
                // reuse one unary, drop the other
                auto* leftValue = left->value;
                left->value = binary;
                binary->left = leftValue;
                binary->right = right->value;
                binary->op = OrInt32;
                return left;
              }
            }
          }
        }
      }
      // for and and or, we can potentially conditionalize
      if (binary->op == AndInt32 || binary->op == OrInt32) {
        auto* ret = conditionalizeExpensiveOnBitwise(binary);
        if (ret) return ret;
      }
      // relation/comparisons allow for math optimizations
      if (binary->isRelational()) {
        auto* ret = optimizeRelational(binary);
        if (ret) return ret;
      }
      // finally, try more expensive operations on the binary
      if (!EffectAnalyzer(getPassOptions(), binary->left).hasSideEffects() &&
          ExpressionAnalyzer::equal(binary->left, binary->right)) {
        return optimizeBinaryWithEqualEffectlessChildren(binary);
      }
    } else if (auto* unary = curr->dynCast<Unary>()) {
      // de-morgan's laws
      if (unary->op == EqZInt32) {
        if (auto* inner = unary->value->dynCast<Binary>()) {
          switch (inner->op) {
            case EqInt32:  inner->op = NeInt32;  return inner;
            case NeInt32:  inner->op = EqInt32;  return inner;
            case LtSInt32: inner->op = GeSInt32; return inner;
            case LtUInt32: inner->op = GeUInt32; return inner;
            case LeSInt32: inner->op = GtSInt32; return inner;
            case LeUInt32: inner->op = GtUInt32; return inner;
            case GtSInt32: inner->op = LeSInt32; return inner;
            case GtUInt32: inner->op = LeUInt32; return inner;
            case GeSInt32: inner->op = LtSInt32; return inner;
            case GeUInt32: inner->op = LtUInt32; return inner;

            case EqInt64:  inner->op = NeInt64;  return inner;
            case NeInt64:  inner->op = EqInt64;  return inner;
            case LtSInt64: inner->op = GeSInt64; return inner;
            case LtUInt64: inner->op = GeUInt64; return inner;
            case LeSInt64: inner->op = GtSInt64; return inner;
            case LeUInt64: inner->op = GtUInt64; return inner;
            case GtSInt64: inner->op = LeSInt64; return inner;
            case GtUInt64: inner->op = LeUInt64; return inner;
            case GeSInt64: inner->op = LtSInt64; return inner;
            case GeUInt64: inner->op = LtUInt64; return inner;

            case EqFloat32: inner->op = NeFloat32; return inner;
            case NeFloat32: inner->op = EqFloat32; return inner;

            case EqFloat64: inner->op = NeFloat64; return inner;
            case NeFloat64: inner->op = EqFloat64; return inner;

            default: {}
          }
        }
        // eqz of a sign extension can be of zero-extension
        if (auto* ext = Properties::getSignExtValue(unary->value)) {
          // we are comparing a sign extend to a constant, which means we can use a cheaper zext
          auto bits = Properties::getSignExtBits(unary->value);
          unary->value = makeZeroExt(ext, bits);
          return unary;
        }
      }
    } else if (auto* set = curr->dynCast<SetGlobal>()) {
      // optimize out a set of a get
      auto* get = set->value->dynCast<GetGlobal>();
      if (get && get->name == set->name) {
        ExpressionManipulator::nop(curr);
      }
    } else if (auto* iff = curr->dynCast<If>()) {
      iff->condition = optimizeBoolean(iff->condition);
      if (iff->ifFalse) {
        if (auto* unary = iff->condition->dynCast<Unary>()) {
          if (unary->op == EqZInt32) {
            // flip if-else arms to get rid of an eqz
            iff->condition = unary->value;
            std::swap(iff->ifTrue, iff->ifFalse);
          }
        }
        if (iff->condition->type != unreachable && ExpressionAnalyzer::equal(iff->ifTrue, iff->ifFalse)) {
          // sides are identical, fold
          // if we can replace the if with one arm, and no side effects in the condition, do that
          auto needCondition = EffectAnalyzer(getPassOptions(), iff->condition).hasSideEffects();
          auto typeIsIdentical = iff->ifTrue->type == iff->type;
          if (typeIsIdentical && !needCondition) {
            return iff->ifTrue;
          } else {
            Builder builder(*getModule());
            if (typeIsIdentical) {
              return builder.makeSequence(
                builder.makeDrop(iff->condition),
                iff->ifTrue
              );
            } else {
              // the types diff. as the condition is reachable, that means the if must be
              // concrete while the arm is not
              assert(isConcreteType(iff->type) && iff->ifTrue->type == unreachable);
              // emit a block with a forced type
              auto* ret = builder.makeBlock();
              if (needCondition) {
                ret->list.push_back(builder.makeDrop(iff->condition));
              }
              ret->list.push_back(iff->ifTrue);
              ret->finalize(iff->type);
              return ret;
            }
          }
        }
      }
    } else if (auto* select = curr->dynCast<Select>()) {
      select->condition = optimizeBoolean(select->condition);
      auto* condition = select->condition->dynCast<Unary>();
      if (condition && condition->op == EqZInt32) {
        // flip select to remove eqz, if we can reorder
        EffectAnalyzer ifTrue(getPassOptions(), select->ifTrue);
        EffectAnalyzer ifFalse(getPassOptions(), select->ifFalse);
        if (!ifTrue.invalidates(ifFalse)) {
          select->condition = condition->value;
          std::swap(select->ifTrue, select->ifFalse);
        }
      }
      if (auto* c = select->condition->dynCast<Const>()) {
        // constant condition, we can just pick the right side (barring side effects)
        if (c->value.getInteger()) {
          if (!EffectAnalyzer(getPassOptions(), select->ifFalse).hasSideEffects()) {
            return select->ifTrue;
          } else {
            // don't bother - we would need to reverse the order using a temp local, which is bad
          }
        } else {
          if (!EffectAnalyzer(getPassOptions(), select->ifTrue).hasSideEffects()) {
            return select->ifFalse;
          } else {
            Builder builder(*getModule());
            return builder.makeSequence(
              builder.makeDrop(select->ifTrue),
              select->ifFalse
            );
          }
        }
      }
      if (ExpressionAnalyzer::equal(select->ifTrue, select->ifFalse)) {
        // sides are identical, fold
        EffectAnalyzer value(getPassOptions(), select->ifTrue);
        if (value.hasSideEffects()) {
          // at best we don't need the condition, but need to execute the value
          // twice. a block is larger than a select by 2 bytes, and
          // we must drop one value, so 3, while we save the condition,
          // so it's not clear this is worth it, TODO
        } else {
          // value has no side effects
          EffectAnalyzer condition(getPassOptions(), select->condition);
          if (!condition.hasSideEffects()) {
            return select->ifTrue;
          } else {
            // the condition is last, so we need a new local, and it may be
            // a bad idea to use a block like we do for an if. Do it only if we
            // can reorder
            if (!condition.invalidates(value)) {
              Builder builder(*getModule());
              return builder.makeSequence(
                builder.makeDrop(select->condition),
                select->ifTrue
              );
            }
          }
        }
      }
    } else if (auto* br = curr->dynCast<Break>()) {
      if (br->condition) {
        br->condition = optimizeBoolean(br->condition);
      }
    } else if (auto* load = curr->dynCast<Load>()) {
      optimizeMemoryAccess(load->ptr, load->offset);
    } else if (auto* store = curr->dynCast<Store>()) {
      optimizeMemoryAccess(store->ptr, store->offset);
      // stores of fewer bits truncates anyhow
      if (auto* binary = store->value->dynCast<Binary>()) {
        if (binary->op == AndInt32) {
          if (auto* right = binary->right->dynCast<Const>()) {
            if (right->type == i32) {
              auto mask = right->value.geti32();
              if ((store->bytes == 1 && mask == 0xff) ||
                  (store->bytes == 2 && mask == 0xffff)) {
                store->value = binary->left;
              }
            }
          }
        } else if (auto* ext = Properties::getSignExtValue(binary)) {
          // if sign extending the exact bit size we store, we can skip the extension
          // if extending something bigger, then we just alter bits we don't save anyhow
          if (Properties::getSignExtBits(binary) >= Index(store->bytes) * 8) {
            store->value = ext;
          }
        }
      } else if (auto* unary = store->value->dynCast<Unary>()) {
        if (unary->op == WrapInt64) {
          // instead of wrapping to 32, just store some of the bits in the i64
          store->valueType = i64;
          store->value = unary->value;
        }
      }
    }
    return nullptr;
  }

  Index getMaxBitsForLocal(GetLocal* get) {
    // check what we know about the local
    return localInfo[get->index].maxBits;
  }

private:
  // Information about our locals
  std::vector<LocalInfo> localInfo;

  // Optimize given that the expression is flowing into a boolean context
  Expression* optimizeBoolean(Expression* boolean) {
    if (auto* unary = boolean->dynCast<Unary>()) {
      if (unary && unary->op == EqZInt32) {
        auto* unary2 = unary->value->dynCast<Unary>();
        if (unary2 && unary2->op == EqZInt32) {
          // double eqz
          return unary2->value;
        }
      }
    } else if (auto* binary = boolean->dynCast<Binary>()) {
      if (binary->op == OrInt32) {
        // an or flowing into a boolean context can consider each input as boolean
        binary->left = optimizeBoolean(binary->left);
        binary->right = optimizeBoolean(binary->right);
      } else if (binary->op == NeInt32) {
        // x != 0 is just x if it's used as a bool
        if (auto* num = binary->right->dynCast<Const>()) {
          if (num->value.geti32() == 0) {
            return binary->left;
          }
        }
      }
      if (auto* ext = Properties::getSignExtValue(binary)) {
        // use a cheaper zero-extent, we just care about the boolean value anyhow
        return makeZeroExt(ext, Properties::getSignExtBits(binary));
      }
    } else if (auto* block = boolean->dynCast<Block>()) {
      if (block->type == i32 && block->list.size() > 0) {
        block->list.back() = optimizeBoolean(block->list.back());
      }
    } else if (auto* iff = boolean->dynCast<If>()) {
      if (iff->type == i32) {
        iff->ifTrue = optimizeBoolean(iff->ifTrue);
        iff->ifFalse = optimizeBoolean(iff->ifFalse);
      }
    }
    // TODO: recurse into br values?
    return boolean;
  }

  // find added constants in an expression tree, including multiplied/shifted, and combine them
  // note that we ignore division/shift-right, as rounding makes this nonlinear, so not a valid opt
  Expression* optimizeAddedConstants(Binary* binary) {
    int32_t constant = 0;
    std::vector<Const*> constants;
    std::function<void (Expression*, int)> seek = [&](Expression* curr, int mul) {
      if (auto* c = curr->dynCast<Const>()) {
        auto value = c->value.geti32();
        if (value != 0) {
          constant += value * mul;
          constants.push_back(c);
        }
        return;
      } else if (auto* binary = curr->dynCast<Binary>()) {
        if (binary->op == AddInt32) {
          seek(binary->left, mul);
          seek(binary->right, mul);
          return;
        } else if (binary->op == SubInt32) {
          // if the left is a zero, ignore it, it's how we negate ints
          auto* left = binary->left->dynCast<Const>();
          if (!left || left->value.geti32() != 0) {
            seek(binary->left, mul);
          }
          seek(binary->right, -mul);
          return;
        } else if (binary->op == ShlInt32) {
          if (auto* c = binary->right->dynCast<Const>()) {
            seek(binary->left, mul * Pow2(Bits::getEffectiveShifts(c)));
            return;
          }
        } else if (binary->op == MulInt32) {
          if (auto* c = binary->left->dynCast<Const>()) {
            seek(binary->right, mul * c->value.geti32());
            return;
          } else if (auto* c = binary->right->dynCast<Const>()) {
            seek(binary->left, mul * c->value.geti32());
            return;
          }
        }
      }
    };
    // find all factors
    seek(binary, 1);
    if (constants.size() <= 1) {
      // nothing much to do, except for the trivial case of adding/subbing a zero
      if (auto* c = binary->right->dynCast<Const>()) {
        if (c->value.geti32() == 0) {
          return binary->left;
        }
      }
      return nullptr;
    }
    // wipe out all constants, we'll replace with a single added one
    for (auto* c : constants) {
      c->value = Literal(int32_t(0));
    }
    // remove added/subbed zeros
    struct ZeroRemover : public PostWalker<ZeroRemover> {
      // TODO: we could save the binarys and costs we drop, and reuse them later

      PassOptions& passOptions;

      ZeroRemover(PassOptions& passOptions) : passOptions(passOptions) {}

      void visitBinary(Binary* curr) {
        auto* left = curr->left->dynCast<Const>();
        auto* right = curr->right->dynCast<Const>();
        if (curr->op == AddInt32) {
          if (left && left->value.geti32() == 0) {
            replaceCurrent(curr->right);
            return;
          }
          if (right && right->value.geti32() == 0) {
            replaceCurrent(curr->left);
            return;
          }
        } else if (curr->op == SubInt32) {
          // we must leave a left zero, as it is how we negate ints
          if (right && right->value.geti32() == 0) {
            replaceCurrent(curr->left);
            return;
          }
        } else if (curr->op == ShlInt32) {
          // shifting a 0 is a 0, or anything by 0 has no effect, all unless the shift has side effects
          if (((left && left->value.geti32() == 0) || (right && Bits::getEffectiveShifts(right) == 0)) &&
              !EffectAnalyzer(passOptions, curr->right).hasSideEffects()) {
            replaceCurrent(curr->left);
            return;
          }
        } else if (curr->op == MulInt32) {
          // multiplying by zero is a zero, unless the other side has side effects
          if (left && left->value.geti32() == 0 && !EffectAnalyzer(passOptions, curr->right).hasSideEffects()) {
            replaceCurrent(left);
            return;
          }
          if (right && right->value.geti32() == 0 && !EffectAnalyzer(passOptions, curr->left).hasSideEffects()) {
            replaceCurrent(right);
            return;
          }
        }
      }
    };
    Expression* walked = binary;
    ZeroRemover(getPassOptions()).walk(walked);
    if (constant == 0) return walked; // nothing more to do
    if (auto* c = walked->dynCast<Const>()) {
      assert(c->value.geti32() == 0);
      c->value = Literal(constant);
      return c;
    }
    Builder builder(*getModule());
    return builder.makeBinary(AddInt32,
      walked,
      builder.makeConst(Literal(constant))
    );
  }

  //   expensive1 | expensive2 can be turned into expensive1 ? 1 : expensive2, and
  //   expensive | cheap     can be turned into cheap     ? 1 : expensive,
  // so that we can avoid one expensive computation, if it has no side effects.
  Expression* conditionalizeExpensiveOnBitwise(Binary* binary) {
    // this operation can increase code size, so don't always do it
    auto& options = getPassRunner()->options;
    if (options.optimizeLevel < 2 || options.shrinkLevel > 0) return nullptr;
    const auto MIN_COST = 7;
    assert(binary->op == AndInt32 || binary->op == OrInt32);
    if (binary->right->is<Const>()) return nullptr; // trivial
    // bitwise logical operator on two non-numerical values, check if they are boolean
    auto* left = binary->left;
    auto* right = binary->right;
    if (!Properties::emitsBoolean(left) || !Properties::emitsBoolean(right)) return nullptr;
    auto leftEffects = EffectAnalyzer(getPassOptions(), left);
    auto rightEffects = EffectAnalyzer(getPassOptions(), right);
    auto leftHasSideEffects = leftEffects.hasSideEffects();
    auto rightHasSideEffects = rightEffects.hasSideEffects();
    if (leftHasSideEffects && rightHasSideEffects) return nullptr; // both must execute
    // canonicalize with side effects, if any, happening on the left
    if (rightHasSideEffects) {
      if (CostAnalyzer(left).cost < MIN_COST) return nullptr; // avoidable code is too cheap
      if (leftEffects.invalidates(rightEffects)) return nullptr; // cannot reorder
      std::swap(left, right);
    } else if (leftHasSideEffects) {
      if (CostAnalyzer(right).cost < MIN_COST) return nullptr; // avoidable code is too cheap
    } else {
      // no side effects, reorder based on cost estimation
      auto leftCost = CostAnalyzer(left).cost;
      auto rightCost = CostAnalyzer(right).cost;
      if (std::max(leftCost, rightCost) < MIN_COST) return nullptr; // avoidable code is too cheap
      // canonicalize with expensive code on the right
      if (leftCost > rightCost) {
        std::swap(left, right);
      }
    }
    // worth it! perform conditionalization
    Builder builder(*getModule());
    if (binary->op == OrInt32) {
      return builder.makeIf(left, builder.makeConst(Literal(int32_t(1))), right);
    } else { // &
      return builder.makeIf(left, right, builder.makeConst(Literal(int32_t(0))));
    }
  }

  // fold constant factors into the offset
  void optimizeMemoryAccess(Expression*& ptr, Address& offset) {
    // ptr may be a const, but it isn't worth folding that in (we still have a const); in fact,
    // it's better to do the opposite for gzip purposes as well as for readability.
    auto* last = ptr->dynCast<Const>();
    if (last) {
      // don't do this if it would wrap the pointer
      uint64_t value64 = last->value.geti32();
      uint64_t offset64 = offset;
      if (value64 <= std::numeric_limits<int32_t>::max() &&
          offset64 <= std::numeric_limits<int32_t>::max() &&
          value64 + offset64 <= std::numeric_limits<int32_t>::max()) {
        last->value = Literal(int32_t(value64 + offset64));
        offset = 0;
      }
    }
  }

  // Optimize a multiply by a power of two on the right, which
  // can be a shift.
  // This doesn't shrink code size, and VMs likely optimize it anyhow,
  // but it's still worth doing since
  //  * Often shifts are more common than muls.
  //  * The constant is smaller.
  Expression* optimizePowerOf2Mul(Binary* binary, uint32_t c) {
    uint32_t shifts = CountTrailingZeroes(c);
    binary->op = ShlInt32;
    binary->right->cast<Const>()->value = Literal(int32_t(shifts));
    return binary;
  }

  // Optimize an unsigned divide by a power of two on the right,
  // which can be an AND mask
  // This doesn't shrink code size, and VMs likely optimize it anyhow,
  // but it's still worth doing since
  //  * Usually ands are more common than urems.
  //  * The constant is slightly smaller.
  Expression* optimizePowerOf2URem(Binary* binary, uint32_t c) {
    binary->op = AndInt32;
    binary->right->cast<Const>()->value = Literal(int32_t(c - 1));
    return binary;
  }

  Expression* makeZeroExt(Expression* curr, int32_t bits) {
    Builder builder(*getModule());
    return builder.makeBinary(AndInt32, curr, builder.makeConst(Literal(Bits::lowBitMask(bits))));
  }

  // given an "almost" sign extend - either a proper one, or it
  // has too many shifts left - we remove the sign extend. If there are
  // too many shifts, we split the shifts first, so this removes the
  // two sign extend shifts and adds one (smaller one)
  Expression* removeAlmostSignExt(Binary* outer) {
    auto* inner = outer->left->cast<Binary>();
    auto* outerConst = outer->right->cast<Const>();
    auto* innerConst = inner->right->cast<Const>();
    auto* value = inner->left;
    if (outerConst->value == innerConst->value) return value;
    // add a shift, by reusing the existing node
    innerConst->value = innerConst->value.sub(outerConst->value);
    return inner;
  }

  // check if an expression is already sign-extended
  bool isSignExted(Expression* curr, Index bits) {
    if (Properties::getSignExtValue(curr)) {
      return Properties::getSignExtBits(curr) == bits;
    }
    if (auto* get = curr->dynCast<GetLocal>()) {
      // check what we know about the local
      return localInfo[get->index].signExtedBits == bits;
    }
    return false;
  }

  // optimize trivial math operations, given that the right side of a binary
  // is a constant
  // TODO: templatize on type?
  Expression* optimizeWithConstantOnRight(Binary* binary) {
    auto type = binary->right->type;
    auto* right = binary->right->cast<Const>();
    if (isIntegerType(type)) {
      // operations on zero
      if (right->value == LiteralUtils::makeLiteralFromInt32(0, type)) {
        if (binary->op == Abstract::getBinary(type, Abstract::Shl) ||
            binary->op == Abstract::getBinary(type, Abstract::ShrU) ||
            binary->op == Abstract::getBinary(type, Abstract::ShrS) ||
            binary->op == Abstract::getBinary(type, Abstract::Or) ||
            binary->op == Abstract::getBinary(type, Abstract::Xor)) {
          return binary->left;
        } else if ((binary->op == Abstract::getBinary(type, Abstract::Mul) ||
                    binary->op == Abstract::getBinary(type, Abstract::And)) &&
                   !EffectAnalyzer(getPassOptions(), binary->left).hasSideEffects()) {
          return binary->right;
        }
      }
      // operations on all 1s
      // TODO: shortcut method to create an all-ones?
      if (right->value == Literal(int32_t(-1)) ||
          right->value == Literal(int64_t(-1))) {
        if (binary->op == Abstract::getBinary(type, Abstract::And)) {
          return binary->left;
        } else if (binary->op == Abstract::getBinary(type, Abstract::Or) &&
                   !EffectAnalyzer(getPassOptions(), binary->left).hasSideEffects()) {
          return binary->right;
        }
      }
      // wasm binary encoding uses signed LEBs, which slightly favor negative
      // numbers: -64 is more efficient than +64 etc., as well as other powers
      // of two 7 bits etc. higher. we therefore prefer x - -64 over x + 64.
      // in theory we could just prefer negative numbers over positive, but
      // that can have bad effects on gzip compression (as it would mean more
      // subtractions than the more common additions).
      if (binary->op == Abstract::getBinary(type, Abstract::Add) ||
          binary->op == Abstract::getBinary(type, Abstract::Sub)) {
        auto value = right->value.getInteger();
        if (value == 0x40 ||
            value == 0x2000 ||
            value == 0x100000 ||
            value == 0x8000000 ||
            value == 0x400000000LL ||
            value == 0x20000000000LL ||
            value == 0x1000000000000LL ||
            value == 0x80000000000000LL ||
            value == 0x4000000000000000LL) {
          right->value = right->value.neg();
          if (binary->op == Abstract::getBinary(type, Abstract::Add)) {
            binary->op = Abstract::getBinary(type, Abstract::Sub);
          } else {
            binary->op = Abstract::getBinary(type, Abstract::Add);
          }
          return binary;
        }
      }
    }
    // note that this is correct even on floats with a NaN on the left,
    // as a NaN would skip the computation and just return the NaN,
    // and that is precisely what we do here. but, the same with -1
    // (change to a negation) would be incorrect for that reason.
    if (right->value == LiteralUtils::makeLiteralFromInt32(1, type)) {
      if (binary->op == Abstract::getBinary(type, Abstract::Mul) ||
          binary->op == Abstract::getBinary(type, Abstract::DivS) ||
          binary->op == Abstract::getBinary(type, Abstract::DivU)) {
        return binary->left;
      }
    }
    return nullptr;
  }

  // optimize trivial math operations, given that the left side of a binary
  // is a constant. since we canonicalize constants to the right for symmetrical
  // operations, we only need to handle asymmetrical ones here
  // TODO: templatize on type?
  Expression* optimizeWithConstantOnLeft(Binary* binary) {
    auto type = binary->left->type;
    auto* left = binary->left->cast<Const>();
    if (isIntegerType(type)) {
      // operations on zero
      if (left->value == LiteralUtils::makeLiteralFromInt32(0, type)) {
        if ((binary->op == Abstract::getBinary(type, Abstract::Shl) ||
             binary->op == Abstract::getBinary(type, Abstract::ShrU) ||
             binary->op == Abstract::getBinary(type, Abstract::ShrS)) &&
            !EffectAnalyzer(getPassOptions(), binary->right).hasSideEffects()) {
          return binary->left;
        }
      }
    }
    return nullptr;
  }

  // integer math, even on 2s complement, allows stuff like
  // x + 5 == 7
  //   =>
  //     x == 2
  // TODO: templatize on type?
  Expression* optimizeRelational(Binary* binary) {
    // TODO: inequalities can also work, if the constants do not overflow
    auto type = binary->right->type;
    if (binary->op ==Abstract::getBinary(type, Abstract::Eq) ||
        binary->op ==Abstract::getBinary(type, Abstract::Ne)) {
      if (isIntegerType(binary->left->type)) {
        if (auto* left = binary->left->dynCast<Binary>()) {
          if (left->op == Abstract::getBinary(type, Abstract::Add) ||
              left->op == Abstract::getBinary(type, Abstract::Sub)) {
            if (auto* leftConst = left->right->dynCast<Const>()) {
              if (auto* rightConst = binary->right->dynCast<Const>()) {
                return combineRelationalConstants(binary, left, leftConst, nullptr, rightConst);
              } else if (auto* rightBinary = binary->right->dynCast<Binary>()) {
                if (rightBinary->op == Abstract::getBinary(type, Abstract::Add) ||
                    rightBinary->op == Abstract::getBinary(type, Abstract::Sub)) {
                  if (auto* rightConst = rightBinary->right->dynCast<Const>()) {
                    return combineRelationalConstants(binary, left, leftConst, rightBinary, rightConst);
                  }
                }
              }
            }
          }
        }
      }
    }
    return nullptr;
  }

  // given a relational binary with a const on both sides, combine the constants
  // left is also a binary, and has a constant; right may be just a constant, in which
  // case right is nullptr
  Expression* combineRelationalConstants(Binary* binary, Binary* left, Const* leftConst, Binary* right, Const* rightConst) {
    auto type = binary->right->type;
    // we fold constants to the right
    Literal extra = leftConst->value;
    if (left->op == Abstract::getBinary(type, Abstract::Sub)) {
      extra = extra.neg();
    }
    if (right && right->op == Abstract::getBinary(type, Abstract::Sub)) {
      extra = extra.neg();
    }
    rightConst->value = rightConst->value.sub(extra);
    binary->left = left->left;
    return binary;
  }

  // given a binary expression with equal children and no side effects in either,
  // we can fold various things
  // TODO: trinaries, things like (x & (y & x)) ?
  Expression* optimizeBinaryWithEqualEffectlessChildren(Binary* binary) {
    // TODO add: perhaps worth doing 2*x if x is quite large?
    switch (binary->op) {
      case SubInt32:
      case XorInt32:
      case SubInt64:
      case XorInt64: return LiteralUtils::makeZero(binary->left->type, *getModule());
      case NeInt64:
      case LtSInt64:
      case LtUInt64:
      case GtSInt64:
      case GtUInt64:
      case NeInt32:
      case LtSInt32:
      case LtUInt32:
      case GtSInt32:
      case GtUInt32: return LiteralUtils::makeZero(i32, *getModule());
      case AndInt32:
      case OrInt32:
      case AndInt64:
      case OrInt64:  return binary->left;
      case EqInt32:
      case LeSInt32:
      case LeUInt32:
      case GeSInt32:
      case GeUInt32:
      case EqInt64:
      case LeSInt64:
      case LeUInt64:
      case GeSInt64:
      case GeUInt64: return LiteralUtils::makeFromInt32(1, i32, *getModule());
      default: return nullptr;
    }
  }
};

Pass *createOptimizeInstructionsPass() {
  return new OptimizeInstructions();
}

} // namespace wasm
