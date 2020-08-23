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
#include <type_traits>

#include <ir/abstract.h>
#include <ir/bits.h>
#include <ir/cost.h>
#include <ir/effects.h>
#include <ir/literal-utils.h>
#include <ir/load-utils.h>
#include <ir/manipulation.h>
#include <ir/properties.h>
#include <ir/utils.h>
#include <pass.h>
#include <support/threads.h>
#include <wasm-s-parser.h>
#include <wasm.h>

// TODO: Use the new sign-extension opcodes where appropriate. This needs to be
// conditionalized on the availability of atomics.

namespace wasm {

Name I32_EXPR = "i32.expr";
Name I64_EXPR = "i64.expr";
Name F32_EXPR = "f32.expr";
Name F64_EXPR = "f64.expr";
Name ANY_EXPR = "any.expr";

// Useful information about locals
struct LocalInfo {
  static const Index kUnknown = Index(-1);

  Index maxBits;
  Index signExtedBits;
};

struct LocalScanner : PostWalker<LocalScanner> {
  std::vector<LocalInfo>& localInfo;
  const PassOptions& passOptions;

  LocalScanner(std::vector<LocalInfo>& localInfo,
               const PassOptions& passOptions)
    : localInfo(localInfo), passOptions(passOptions) {}

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

  void visitLocalSet(LocalSet* curr) {
    auto* func = getFunction();
    if (func->isParam(curr->index)) {
      return;
    }
    auto type = getFunction()->getLocalType(curr->index);
    if (type != Type::i32 && type != Type::i64) {
      return;
    }
    // an integer var, worth processing
    auto* value = Properties::getFallthrough(
      curr->value, passOptions, getModule()->features);
    auto& info = localInfo[curr->index];
    info.maxBits = std::max(info.maxBits, Bits::getMaxBits(value, this));
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
      // contradictory information, give up
      info.signExtedBits = LocalInfo::kUnknown;
    }
  }

  // define this for the templated getMaxBits method. we know nothing here yet
  // about locals, so return the maxes
  Index getMaxBitsForLocal(LocalGet* get) { return getBitsForType(get->type); }

  Index getBitsForType(Type type) {
    TODO_SINGLE_COMPOUND(type);
    switch (type.getBasic()) {
      case Type::i32:
        return 32;
      case Type::i64:
        return 64;
      default:
        return -1;
    }
  }
};

// Main pass class
struct OptimizeInstructions
  : public WalkerPass<
      PostWalker<OptimizeInstructions,
                 UnifiedExpressionVisitor<OptimizeInstructions>>> {
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
      LocalScanner scanner(localInfo, getPassOptions());
      scanner.setModule(getModule());
      scanner.walkFunction(func);
    }
    // main walk
    super::doWalkFunction(func);
  }

  void visitExpression(Expression* curr) {
    // we may be able to apply multiple patterns, one may open opportunities
    // that look deeper NB: patterns must not have cycles
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

  // Optimizations that don't yet fit in the pattern DSL, but could be
  // eventually maybe
  Expression* handOptimize(Expression* curr) {
    FeatureSet features = getModule()->features;
    // if this contains dead code, don't bother trying to optimize it, the type
    // might change (if might not be unreachable if just one arm is, for
    // example). this optimization pass focuses on actually executing code. the
    // only exceptions are control flow changes
    if (curr->type == Type::unreachable && !curr->is<Break>() &&
        !curr->is<Switch>() && !curr->is<If>()) {
      return nullptr;
    }
    if (auto* binary = curr->dynCast<Binary>()) {
      if (Properties::isSymmetric(binary)) {
        canonicalize(binary);
      }
      if (auto* ext = Properties::getAlmostSignExt(binary)) {
        Index extraShifts;
        auto bits = Properties::getAlmostSignExtBits(binary, extraShifts);
        if (extraShifts == 0) {
          if (auto* load =
                Properties::getFallthrough(ext, getPassOptions(), features)
                  ->dynCast<Load>()) {
            // pattern match a load of 8 bits and a sign extend using a shl of
            // 24 then shr_s of 24 as well, etc.
            if (LoadUtils::canBeSigned(load) &&
                ((load->bytes == 1 && bits == 8) ||
                 (load->bytes == 2 && bits == 16))) {
              // if the value falls through, we can't alter the load, as it
              // might be captured in a tee
              if (load->signed_ == true || load == ext) {
                load->signed_ = true;
                return ext;
              }
            }
          }
        }
        // if the sign-extend input cannot have a sign bit, we don't need it
        // we also don't need it if it already has an identical-sized sign
        // extend
        if (Bits::getMaxBits(ext, this) + extraShifts < bits ||
            isSignExted(ext, bits)) {
          return removeAlmostSignExt(binary);
        }
      } else if (binary->op == EqInt32 || binary->op == NeInt32) {
        if (auto* c = binary->right->dynCast<Const>()) {
          if (binary->op == EqInt32 && c->value.geti32() == 0) {
            // equal 0 => eqz
            return Builder(*getModule()).makeUnary(EqZInt32, binary->left);
          }
          if (auto* ext = Properties::getSignExtValue(binary->left)) {
            // we are comparing a sign extend to a constant, which means we can
            // use a cheaper zext
            auto bits = Properties::getSignExtBits(binary->left);
            binary->left = makeZeroExt(ext, bits);
            // when we replace the sign-ext of the non-constant with a zero-ext,
            // we are forcing the high bits to be all zero, instead of all zero
            // or all one depending on the sign bit. so we may be changing the
            // high bits from all one to all zero:
            //  * if the constant value's higher bits are mixed, then it can't
            //    be equal anyhow
            //  * if they are all zero, we may get a false true if the
            //    non-constant's upper bits were one. this can only happen if
            //    the non-constant's sign bit is set, so this false true is a
            //    risk only if the constant's sign bit is set (otherwise,
            //    false). But a constant with a sign bit but with upper bits
            //    zero is impossible to be equal to a sign-extended value
            //    anyhow, so the entire thing is false.
            //  * if they were all one, we may get a false false, if the only
            //    difference is in those upper bits. that means we are equal on
            //    the other bits, including the sign bit. so we can just mask
            //    off the upper bits in the constant value, in this case,
            //    forcing them to zero like we do in the zero-extend.
            int32_t constValue = c->value.geti32();
            auto upperConstValue = constValue & ~Bits::lowBitMask(bits);
            uint32_t count = PopCount(upperConstValue);
            auto constSignBit = constValue & (1 << (bits - 1));
            if ((count > 0 && count < 32 - bits) ||
                (constSignBit && count == 0)) {
              // mixed or [zero upper const bits with sign bit set]; the
              // compared values can never be identical, so force something
              // definitely impossible even after zext
              assert(bits < 32);
              c->value = Literal(int32_t(0x80000000));
              // TODO: if no side effects, we can just replace it all with 1 or
              // 0
            } else {
              // otherwise, they are all ones, so we can mask them off as
              // mentioned before
              c->value = c->value.and_(Literal(Bits::lowBitMask(bits)));
            }
            return binary;
          }
        } else if (auto* left = Properties::getSignExtValue(binary->left)) {
          if (auto* right = Properties::getSignExtValue(binary->right)) {
            auto bits = Properties::getSignExtBits(binary->left);
            if (Properties::getSignExtBits(binary->right) == bits) {
              // we are comparing two sign-exts with the same bits, so we may as
              // well replace both with cheaper zexts
              binary->left = makeZeroExt(left, bits);
              binary->right = makeZeroExt(right, bits);
              return binary;
            }
          } else if (auto* load = binary->right->dynCast<Load>()) {
            // we are comparing a load to a sign-ext, we may be able to switch
            // to zext
            auto leftBits = Properties::getSignExtBits(binary->left);
            if (load->signed_ && leftBits == load->bytes * 8) {
              load->signed_ = false;
              binary->left = makeZeroExt(left, leftBits);
              return binary;
            }
          }
        } else if (auto* load = binary->left->dynCast<Load>()) {
          if (auto* right = Properties::getSignExtValue(binary->right)) {
            // we are comparing a load to a sign-ext, we may be able to switch
            // to zext
            auto rightBits = Properties::getSignExtBits(binary->right);
            if (load->signed_ && rightBits == load->bytes * 8) {
              load->signed_ = false;
              binary->right = makeZeroExt(right, rightBits);
              return binary;
            }
          }
        }
        // note that both left and right may be consts, but then we let
        // precompute compute the constant result
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
                if (EffectAnalyzer::canReorder(
                      getPassOptions(), features, sub->right, binary->right)) {
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
        if (ret) {
          return ret;
        }
      } else if (binary->op == SubInt32) {
        auto* ret = optimizeAddedConstants(binary);
        if (ret) {
          return ret;
        }
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
            if (Bits::getMaxBits(binary->left, this) <= maskedBits) {
              // a mask of lower bits is not needed if we are already smaller
              return binary->left;
            }
          }
        }
        // some math operations have trivial results
        Expression* ret = optimizeWithConstantOnRight(binary);
        if (ret) {
          return ret;
        }
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
              } else if (left->op == ShlInt32 || left->op == ShrUInt32 ||
                         left->op == ShrSInt32 || left->op == ShlInt64 ||
                         left->op == ShrUInt64 || left->op == ShrSInt64) {
                // shifts only use an effective amount from the constant, so
                // adding must be done carefully
                auto total = Bits::getEffectiveShifts(leftRight) +
                             Bits::getEffectiveShifts(right);
                if (total == Bits::getEffectiveShifts(total, right->type)) {
                  // no overflow, we can do this
                  leftRight->value = Literal::makeFromInt32(total, right->type);
                  return left;
                } // TODO: handle overflows
              }
            }
          }
        }
        // math operations on a constant power of 2 right side can be optimized
        if (right->type == Type::i32) {
          uint32_t c = right->value.geti32();
          if (IsPowerOf2(c)) {
            switch (binary->op) {
              case MulInt32:
                return optimizePowerOf2Mul(binary, c);
              case RemUInt32:
                return optimizePowerOf2URem(binary, c);
              case DivUInt32:
                return optimizePowerOf2UDiv(binary, c);
              default:
                break;
            }
          }
        }
        if (right->type == Type::i64) {
          uint64_t c = right->value.geti64();
          if (IsPowerOf2(c)) {
            switch (binary->op) {
              case MulInt64:
                return optimizePowerOf2Mul(binary, c);
              case RemUInt64:
                return optimizePowerOf2URem(binary, c);
              case DivUInt64:
                return optimizePowerOf2UDiv(binary, c);
              default:
                break;
            }
          }
        }
      }
      // a bunch of operations on a constant left side can be simplified
      if (binary->left->is<Const>()) {
        Expression* ret = optimizeWithConstantOnLeft(binary);
        if (ret) {
          return ret;
        }
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
        if (auto* ret = conditionalizeExpensiveOnBitwise(binary)) {
          return ret;
        }
      }
      // for or, we can potentially combine
      if (binary->op == OrInt32) {
        if (auto* ret = combineOr(binary)) {
          return ret;
        }
      }
      // relation/comparisons allow for math optimizations
      if (binary->isRelational()) {
        if (auto* ret = optimizeRelational(binary)) {
          return ret;
        }
      }
      // finally, try more expensive operations on the binary in
      // the case that they have no side effects
      if (!EffectAnalyzer(getPassOptions(), features, binary->left)
             .hasSideEffects()) {
        if (ExpressionAnalyzer::equal(binary->left, binary->right)) {
          return optimizeBinaryWithEqualEffectlessChildren(binary);
        }
      }
    } else if (auto* unary = curr->dynCast<Unary>()) {
      if (unary->op == EqZInt32) {
        if (auto* inner = unary->value->dynCast<Binary>()) {
          // Try to invert a relational operation using De Morgan's law
          auto op = invertBinaryOp(inner->op);
          if (op != InvalidBinary) {
            inner->op = op;
            return inner;
          }
        }
        // eqz of a sign extension can be of zero-extension
        if (auto* ext = Properties::getSignExtValue(unary->value)) {
          // we are comparing a sign extend to a constant, which means we can
          // use a cheaper zext
          auto bits = Properties::getSignExtBits(unary->value);
          unary->value = makeZeroExt(ext, bits);
          return unary;
        }
      }
    } else if (auto* set = curr->dynCast<GlobalSet>()) {
      // optimize out a set of a get
      auto* get = set->value->dynCast<GlobalGet>();
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
        if (iff->condition->type != Type::unreachable &&
            ExpressionAnalyzer::equal(iff->ifTrue, iff->ifFalse)) {
          // sides are identical, fold
          // if we can replace the if with one arm, and no side effects in the
          // condition, do that
          auto needCondition =
            EffectAnalyzer(getPassOptions(), features, iff->condition)
              .hasSideEffects();
          auto isSubType = Type::isSubType(iff->ifTrue->type, iff->type);
          if (isSubType && !needCondition) {
            return iff->ifTrue;
          } else {
            Builder builder(*getModule());
            if (isSubType) {
              return builder.makeSequence(builder.makeDrop(iff->condition),
                                          iff->ifTrue);
            } else {
              // the types diff. as the condition is reachable, that means the
              // if must be concrete while the arm is not
              assert(iff->type.isConcrete() &&
                     iff->ifTrue->type == Type::unreachable);
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
      if (auto* c = select->condition->dynCast<Const>()) {
        // constant condition, we can just pick the right side (barring side
        // effects)
        if (c->value.getInteger()) {
          if (!EffectAnalyzer(getPassOptions(), features, select->ifFalse)
                 .hasSideEffects()) {
            return select->ifTrue;
          } else {
            // don't bother - we would need to reverse the order using a temp
            // local, which is bad
          }
        } else {
          if (!EffectAnalyzer(getPassOptions(), features, select->ifTrue)
                 .hasSideEffects()) {
            return select->ifFalse;
          } else {
            Builder builder(*getModule());
            return builder.makeSequence(builder.makeDrop(select->ifTrue),
                                        select->ifFalse);
          }
        }
      }
      if (auto* constTrue = select->ifTrue->dynCast<Const>()) {
        if (auto* constFalse = select->ifFalse->dynCast<Const>()) {
          if (select->type == Type::i32 || select->type == Type::i64) {
            auto trueValue = constTrue->value.getInteger();
            auto falseValue = constFalse->value.getInteger();
            if ((trueValue == 1LL && falseValue == 0LL) ||
                (trueValue == 0LL && falseValue == 1LL)) {
              Builder builder(*getModule());
              Expression* condition = select->condition;
              if (trueValue == 0LL) {
                condition =
                  optimizeBoolean(builder.makeUnary(EqZInt32, condition));
              }
              if (!Properties::emitsBoolean(condition)) {
                // expr ? 1 : 0   ==>   !!expr
                condition = builder.makeUnary(
                  EqZInt32, builder.makeUnary(EqZInt32, condition));
              }
              return select->type == Type::i64
                       ? builder.makeUnary(ExtendUInt32, condition)
                       : condition;
            }
          }
        }
      }
      if (auto* condition = select->condition->dynCast<Unary>()) {
        if (condition->op == EqZInt32) {
          // flip select to remove eqz, if we can reorder
          EffectAnalyzer ifTrue(getPassOptions(), features, select->ifTrue);
          EffectAnalyzer ifFalse(getPassOptions(), features, select->ifFalse);
          if (!ifTrue.invalidates(ifFalse)) {
            select->condition = condition->value;
            std::swap(select->ifTrue, select->ifFalse);
          }
        }
      }
      if (ExpressionAnalyzer::equal(select->ifTrue, select->ifFalse)) {
        // sides are identical, fold
        EffectAnalyzer value(getPassOptions(), features, select->ifTrue);
        if (value.hasSideEffects()) {
          // at best we don't need the condition, but need to execute the value
          // twice. a block is larger than a select by 2 bytes, and
          // we must drop one value, so 3, while we save the condition,
          // so it's not clear this is worth it, TODO
        } else {
          // value has no side effects
          EffectAnalyzer condition(
            getPassOptions(), features, select->condition);
          if (!condition.hasSideEffects()) {
            return select->ifTrue;
          } else {
            // the condition is last, so we need a new local, and it may be
            // a bad idea to use a block like we do for an if. Do it only if we
            // can reorder
            if (!condition.invalidates(value)) {
              Builder builder(*getModule());
              return builder.makeSequence(builder.makeDrop(select->condition),
                                          select->ifTrue);
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
            if (right->type == Type::i32) {
              auto mask = right->value.geti32();
              if ((store->bytes == 1 && mask == 0xff) ||
                  (store->bytes == 2 && mask == 0xffff)) {
                store->value = binary->left;
              }
            }
          }
        } else if (auto* ext = Properties::getSignExtValue(binary)) {
          // if sign extending the exact bit size we store, we can skip the
          // extension if extending something bigger, then we just alter bits we
          // don't save anyhow
          if (Properties::getSignExtBits(binary) >= Index(store->bytes) * 8) {
            store->value = ext;
          }
        }
      } else if (auto* unary = store->value->dynCast<Unary>()) {
        if (unary->op == WrapInt64) {
          // instead of wrapping to 32, just store some of the bits in the i64
          store->valueType = Type::i64;
          store->value = unary->value;
        }
      }
    } else if (auto* memCopy = curr->dynCast<MemoryCopy>()) {
      assert(features.hasBulkMemory());
      if (auto* ret = optimizeMemoryCopy(memCopy)) {
        return ret;
      }
    }
    return nullptr;
  }

  Index getMaxBitsForLocal(LocalGet* get) {
    // check what we know about the local
    return localInfo[get->index].maxBits;
  }

private:
  // Information about our locals
  std::vector<LocalInfo> localInfo;

  // Canonicalizing the order of a symmetric binary helps us
  // write more concise pattern matching code elsewhere.
  void canonicalize(Binary* binary) {
    assert(Properties::isSymmetric(binary));
    FeatureSet features = getModule()->features;
    auto swap = [&]() {
      assert(EffectAnalyzer::canReorder(
        getPassOptions(), features, binary->left, binary->right));
      std::swap(binary->left, binary->right);
    };
    auto maybeSwap = [&]() {
      if (EffectAnalyzer::canReorder(
            getPassOptions(), features, binary->left, binary->right)) {
        swap();
      }
    };
    // Prefer a const on the right.
    if (binary->left->is<Const>() && !binary->right->is<Const>()) {
      return swap();
    }
    if (binary->right->is<Const>()) {
      return;
    }
    // Prefer a get on the right.
    if (binary->left->is<LocalGet>() && !binary->right->is<LocalGet>()) {
      return maybeSwap();
    }
    // Sort by the node id type, if different.
    if (binary->left->_id != binary->right->_id) {
      if (binary->left->_id > binary->right->_id) {
        return maybeSwap();
      }
      return;
    }
    // If the children have the same node id, we have to go deeper.
    if (auto* left = binary->left->dynCast<Unary>()) {
      auto* right = binary->right->cast<Unary>();
      if (left->op > right->op) {
        return maybeSwap();
      }
    }
    if (auto* left = binary->left->dynCast<Binary>()) {
      auto* right = binary->right->cast<Binary>();
      if (left->op > right->op) {
        return maybeSwap();
      }
    }
    if (auto* left = binary->left->dynCast<LocalGet>()) {
      auto* right = binary->right->cast<LocalGet>();
      if (left->index > right->index) {
        return maybeSwap();
      }
    }
  }

  // Optimize given that the expression is flowing into a boolean context
  Expression* optimizeBoolean(Expression* boolean) {
    // TODO use a general getFallthroughs
    if (auto* unary = boolean->dynCast<Unary>()) {
      if (unary) {
        if (unary->op == EqZInt32) {
          auto* unary2 = unary->value->dynCast<Unary>();
          if (unary2 && unary2->op == EqZInt32) {
            // double eqz
            return unary2->value;
          }
          if (auto* binary = unary->value->dynCast<Binary>()) {
            // !(x <=> y)   ==>   x <!=> y
            auto op = invertBinaryOp(binary->op);
            if (op != InvalidBinary) {
              binary->op = op;
              return binary;
            }
          }
        }
      }
    } else if (auto* binary = boolean->dynCast<Binary>()) {
      if (binary->op == SubInt32) {
        if (auto* num = binary->left->dynCast<Const>()) {
          if (num->value.geti32() == 0) {
            // bool(0 - x)   ==>   bool(x)
            return binary->right;
          }
        }
      } else if (binary->op == OrInt32) {
        // an or flowing into a boolean context can consider each input as
        // boolean
        binary->left = optimizeBoolean(binary->left);
        binary->right = optimizeBoolean(binary->right);
      } else if (binary->op == NeInt32) {
        if (auto* num = binary->right->dynCast<Const>()) {
          // x != 0 is just x if it's used as a bool
          if (num->value.geti32() == 0) {
            return binary->left;
          }
          // TODO: Perhaps use it for separate final pass???
          // x != -1   ==>    x ^ -1
          // if (num->value.geti32() == -1) {
          //   binary->op = XorInt32;
          //   return binary;
          // }
        }
      }
      if (auto* ext = Properties::getSignExtValue(binary)) {
        // use a cheaper zero-extent, we just care about the boolean value
        // anyhow
        return makeZeroExt(ext, Properties::getSignExtBits(binary));
      }
    } else if (auto* block = boolean->dynCast<Block>()) {
      if (block->type == Type::i32 && block->list.size() > 0) {
        block->list.back() = optimizeBoolean(block->list.back());
      }
    } else if (auto* iff = boolean->dynCast<If>()) {
      if (iff->type == Type::i32) {
        iff->ifTrue = optimizeBoolean(iff->ifTrue);
        iff->ifFalse = optimizeBoolean(iff->ifFalse);
      }
    } else if (auto* select = boolean->dynCast<Select>()) {
      select->ifTrue = optimizeBoolean(select->ifTrue);
      select->ifFalse = optimizeBoolean(select->ifFalse);
    } else if (auto* tryy = boolean->dynCast<Try>()) {
      if (tryy->type == Type::i32) {
        tryy->body = optimizeBoolean(tryy->body);
        tryy->catchBody = optimizeBoolean(tryy->catchBody);
      }
    }
    // TODO: recurse into br values?
    return boolean;
  }

  // find added constants in an expression tree, including multiplied/shifted,
  // and combine them note that we ignore division/shift-right, as rounding
  // makes this nonlinear, so not a valid opt
  Expression* optimizeAddedConstants(Binary* binary) {
    uint32_t constant = 0;
    std::vector<Const*> constants;

    struct SeekState {
      Expression* curr;
      int mul;
      SeekState(Expression* curr, int mul) : curr(curr), mul(mul) {}
    };
    std::vector<SeekState> seekStack;
    seekStack.emplace_back(binary, 1);
    while (!seekStack.empty()) {
      auto state = seekStack.back();
      seekStack.pop_back();
      auto curr = state.curr;
      auto mul = state.mul;
      if (auto* c = curr->dynCast<Const>()) {
        uint32_t value = c->value.geti32();
        if (value != 0) {
          constant += value * mul;
          constants.push_back(c);
        }
        continue;
      } else if (auto* binary = curr->dynCast<Binary>()) {
        if (binary->op == AddInt32) {
          seekStack.emplace_back(binary->right, mul);
          seekStack.emplace_back(binary->left, mul);
          continue;
        } else if (binary->op == SubInt32) {
          // if the left is a zero, ignore it, it's how we negate ints
          auto* left = binary->left->dynCast<Const>();
          seekStack.emplace_back(binary->right, -mul);
          if (!left || left->value.geti32() != 0) {
            seekStack.emplace_back(binary->left, mul);
          }
          continue;
        } else if (binary->op == ShlInt32) {
          if (auto* c = binary->right->dynCast<Const>()) {
            seekStack.emplace_back(binary->left,
                                   mul * Pow2(Bits::getEffectiveShifts(c)));
            continue;
          }
        } else if (binary->op == MulInt32) {
          if (auto* c = binary->left->dynCast<Const>()) {
            seekStack.emplace_back(binary->right, mul * c->value.geti32());
            continue;
          } else if (auto* c = binary->right->dynCast<Const>()) {
            seekStack.emplace_back(binary->left, mul * c->value.geti32());
            continue;
          }
        }
      }
    };
    // find all factors
    if (constants.size() <= 1) {
      // nothing much to do, except for the trivial case of adding/subbing a
      // zero
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
        FeatureSet features = getModule()->features;
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
          // shifting a 0 is a 0, or anything by 0 has no effect, all unless the
          // shift has side effects
          if (((left && left->value.geti32() == 0) ||
               (right && Bits::getEffectiveShifts(right) == 0)) &&
              !EffectAnalyzer(passOptions, features, curr->right)
                 .hasSideEffects()) {
            replaceCurrent(curr->left);
            return;
          }
        } else if (curr->op == MulInt32) {
          // multiplying by zero is a zero, unless the other side has side
          // effects
          if (left && left->value.geti32() == 0 &&
              !EffectAnalyzer(passOptions, features, curr->right)
                 .hasSideEffects()) {
            replaceCurrent(left);
            return;
          }
          if (right && right->value.geti32() == 0 &&
              !EffectAnalyzer(passOptions, features, curr->left)
                 .hasSideEffects()) {
            replaceCurrent(right);
            return;
          }
        }
      }
    };
    Expression* walked = binary;
    ZeroRemover remover(getPassOptions());
    remover.setModule(getModule());
    remover.walk(walked);
    if (constant == 0) {
      return walked; // nothing more to do
    }
    if (auto* c = walked->dynCast<Const>()) {
      assert(c->value.geti32() == 0);
      c->value = Literal(constant);
      return c;
    }
    Builder builder(*getModule());
    return builder.makeBinary(
      AddInt32, walked, builder.makeConst(Literal(constant)));
  }

  //   expensive1 | expensive2 can be turned into expensive1 ? 1 : expensive2,
  //   and expensive | cheap     can be turned into cheap     ? 1 : expensive,
  // so that we can avoid one expensive computation, if it has no side effects.
  Expression* conditionalizeExpensiveOnBitwise(Binary* binary) {
    // this operation can increase code size, so don't always do it
    auto& options = getPassRunner()->options;
    if (options.optimizeLevel < 2 || options.shrinkLevel > 0) {
      return nullptr;
    }
    const auto MIN_COST = 7;
    assert(binary->op == AndInt32 || binary->op == OrInt32);
    if (binary->right->is<Const>()) {
      return nullptr; // trivial
    }
    // bitwise logical operator on two non-numerical values, check if they are
    // boolean
    auto* left = binary->left;
    auto* right = binary->right;
    if (!Properties::emitsBoolean(left) || !Properties::emitsBoolean(right)) {
      return nullptr;
    }
    FeatureSet features = getModule()->features;
    auto leftEffects = EffectAnalyzer(getPassOptions(), features, left);
    auto rightEffects = EffectAnalyzer(getPassOptions(), features, right);
    auto leftHasSideEffects = leftEffects.hasSideEffects();
    auto rightHasSideEffects = rightEffects.hasSideEffects();
    if (leftHasSideEffects && rightHasSideEffects) {
      return nullptr; // both must execute
    }
    // canonicalize with side effects, if any, happening on the left
    if (rightHasSideEffects) {
      if (CostAnalyzer(left).cost < MIN_COST) {
        return nullptr; // avoidable code is too cheap
      }
      if (leftEffects.invalidates(rightEffects)) {
        return nullptr; // cannot reorder
      }
      std::swap(left, right);
    } else if (leftHasSideEffects) {
      if (CostAnalyzer(right).cost < MIN_COST) {
        return nullptr; // avoidable code is too cheap
      }
    } else {
      // no side effects, reorder based on cost estimation
      auto leftCost = CostAnalyzer(left).cost;
      auto rightCost = CostAnalyzer(right).cost;
      if (std::max(leftCost, rightCost) < MIN_COST) {
        return nullptr; // avoidable code is too cheap
      }
      // canonicalize with expensive code on the right
      if (leftCost > rightCost) {
        std::swap(left, right);
      }
    }
    // worth it! perform conditionalization
    Builder builder(*getModule());
    if (binary->op == OrInt32) {
      return builder.makeIf(
        left, builder.makeConst(Literal(int32_t(1))), right);
    } else { // &
      return builder.makeIf(
        left, right, builder.makeConst(Literal(int32_t(0))));
    }
  }

  // We can combine `or` operations, e.g.
  //   (x > y) | (x == y)    ==>    x >= y
  Expression* combineOr(Binary* binary) {
    assert(binary->op == OrInt32);
    FeatureSet features = getModule()->features;
    if (auto* left = binary->left->dynCast<Binary>()) {
      if (auto* right = binary->right->dynCast<Binary>()) {
        if (left->op != right->op &&
            ExpressionAnalyzer::equal(left->left, right->left) &&
            ExpressionAnalyzer::equal(left->right, right->right) &&
            !EffectAnalyzer(getPassOptions(), features, left->left)
               .hasSideEffects() &&
            !EffectAnalyzer(getPassOptions(), features, left->right)
               .hasSideEffects()) {
          switch (left->op) {
            //   (x > y) | (x == y)    ==>    x >= y
            case EqInt32: {
              if (right->op == GtSInt32) {
                left->op = GeSInt32;
                return left;
              }
              break;
            }
            default: {
            }
          }
        }
      }
    }
    return nullptr;
  }

  // fold constant factors into the offset
  void optimizeMemoryAccess(Expression*& ptr, Address& offset) {
    // ptr may be a const, but it isn't worth folding that in (we still have a
    // const); in fact, it's better to do the opposite for gzip purposes as well
    // as for readability.
    auto* last = ptr->dynCast<Const>();
    if (last) {
      // don't do this if it would wrap the pointer
      uint64_t value64 = last->value.geti32();
      uint64_t offset64 = offset;
      if (value64 <= uint64_t(std::numeric_limits<int32_t>::max()) &&
          offset64 <= uint64_t(std::numeric_limits<int32_t>::max()) &&
          value64 + offset64 <= uint64_t(std::numeric_limits<int32_t>::max())) {
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
  template<typename T> Expression* optimizePowerOf2Mul(Binary* binary, T c) {
    static_assert(std::is_same<T, uint32_t>::value ||
                    std::is_same<T, uint64_t>::value,
                  "type mismatch");
    auto shifts = CountTrailingZeroes<T>(c);
    binary->op = std::is_same<T, uint32_t>::value ? ShlInt32 : ShlInt64;
    binary->right->cast<Const>()->value = Literal(static_cast<T>(shifts));
    return binary;
  }

  // Optimize an unsigned divide / remainder by a power of two on the right
  // This doesn't shrink code size, and VMs likely optimize it anyhow,
  // but it's still worth doing since
  //  * Usually ands are more common than urems.
  //  * The constant is slightly smaller.
  template<typename T> Expression* optimizePowerOf2UDiv(Binary* binary, T c) {
    static_assert(std::is_same<T, uint32_t>::value ||
                    std::is_same<T, uint64_t>::value,
                  "type mismatch");
    auto shifts = CountTrailingZeroes<T>(c);
    binary->op = std::is_same<T, uint32_t>::value ? ShrUInt32 : ShrUInt64;
    binary->right->cast<Const>()->value = Literal(static_cast<T>(shifts));
    return binary;
  }

  template<typename T> Expression* optimizePowerOf2URem(Binary* binary, T c) {
    static_assert(std::is_same<T, uint32_t>::value ||
                    std::is_same<T, uint64_t>::value,
                  "type mismatch");
    binary->op = std::is_same<T, uint32_t>::value ? AndInt32 : AndInt64;
    binary->right->cast<Const>()->value = Literal(c - 1);
    return binary;
  }

  Expression* makeZeroExt(Expression* curr, int32_t bits) {
    Builder builder(*getModule());
    return builder.makeBinary(
      AndInt32, curr, builder.makeConst(Literal(Bits::lowBitMask(bits))));
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
    if (outerConst->value == innerConst->value) {
      return value;
    }
    // add a shift, by reusing the existing node
    innerConst->value = innerConst->value.sub(outerConst->value);
    return inner;
  }

  // check if an expression is already sign-extended
  bool isSignExted(Expression* curr, Index bits) {
    if (Properties::getSignExtValue(curr)) {
      return Properties::getSignExtBits(curr) == bits;
    }
    if (auto* get = curr->dynCast<LocalGet>()) {
      // check what we know about the local
      return localInfo[get->index].signExtedBits == bits;
    }
    return false;
  }

  // optimize trivial math operations, given that the right side of a binary
  // is a constant
  // TODO: templatize on type?
  Expression* optimizeWithConstantOnRight(Binary* binary) {
    FeatureSet features = getModule()->features;
    auto type = binary->right->type;
    auto* right = binary->right->cast<Const>();
    if (type.isInteger()) {
      auto constRight = right->value.getInteger();
      // operations on zero
      if (constRight == 0LL) {
        if (binary->op == Abstract::getBinary(type, Abstract::Shl) ||
            binary->op == Abstract::getBinary(type, Abstract::ShrU) ||
            binary->op == Abstract::getBinary(type, Abstract::ShrS) ||
            binary->op == Abstract::getBinary(type, Abstract::Or) ||
            binary->op == Abstract::getBinary(type, Abstract::Xor)) {
          return binary->left;
        } else if ((binary->op == Abstract::getBinary(type, Abstract::Mul) ||
                    binary->op == Abstract::getBinary(type, Abstract::And)) &&
                   !EffectAnalyzer(getPassOptions(), features, binary->left)
                      .hasSideEffects()) {
          return binary->right;
        } else if (binary->op == EqInt64) {
          return Builder(*getModule()).makeUnary(EqZInt64, binary->left);
        }
      }
      // operations on one
      if (constRight == 1LL) {
        // (signed)x % 1   ==>   0
        if (binary->op == Abstract::getBinary(type, Abstract::RemS) &&
            !EffectAnalyzer(getPassOptions(), features, binary->left)
               .hasSideEffects()) {
          right->value = Literal::makeSingleZero(type);
          return right;
        }
      }
      // operations on all 1s
      if (constRight == -1LL) {
        if (binary->op == Abstract::getBinary(type, Abstract::And)) {
          // x & -1   ==>   x
          return binary->left;
        } else if (binary->op == Abstract::getBinary(type, Abstract::Or) &&
                   !EffectAnalyzer(getPassOptions(), features, binary->left)
                      .hasSideEffects()) {
          // x | -1   ==>   -1
          return binary->right;
        } else if (binary->op == Abstract::getBinary(type, Abstract::RemS) &&
                   !EffectAnalyzer(getPassOptions(), features, binary->left)
                      .hasSideEffects()) {
          // (signed)x % -1     ==>   0
          right->value = Literal::makeSingleZero(type);
          return right;
        } else if (binary->op == Abstract::getBinary(type, Abstract::GtU) &&
                   !EffectAnalyzer(getPassOptions(), features, binary->left)
                      .hasSideEffects()) {
          // (unsigned)x > -1   ==>   0
          right->value = Literal::makeSingleZero(Type::i32);
          right->type = Type::i32;
          return right;
        } else if (binary->op == Abstract::getBinary(type, Abstract::LtU)) {
          // (unsigned)x < -1   ==>   x != -1
          // friendlier to JS emitting as we don't need to write an unsigned
          // -1 value which is large.
          binary->op = Abstract::getBinary(type, Abstract::Ne);
          return binary;
        } else if (binary->op == DivUInt32) {
          // (unsigned)x / -1   ==>   x == -1
          binary->op = Abstract::getBinary(type, Abstract::Eq);
          return binary;
        } else if (binary->op == Abstract::getBinary(type, Abstract::Mul)) {
          // x * -1   ==>   0 - x
          binary->op = Abstract::getBinary(type, Abstract::Sub);
          right->value = Literal::makeSingleZero(type);
          std::swap(binary->left, binary->right);
          return binary;
        } else if (binary->op == Abstract::getBinary(type, Abstract::LeU) &&
                   !EffectAnalyzer(getPassOptions(), features, binary->left)
                      .hasSideEffects()) {
          // (unsigned)x <= -1   ==>   1
          right->value = Literal::makeFromInt32(1, Type::i32);
          right->type = Type::i32;
          return right;
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
        auto value = constRight;
        if (value == 0x40 || value == 0x2000 || value == 0x100000 ||
            value == 0x8000000 || value == 0x400000000LL ||
            value == 0x20000000000LL || value == 0x1000000000000LL ||
            value == 0x80000000000000LL || value == 0x4000000000000000LL) {
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
    if (type.isInteger() || type.isFloat()) {
      // note that this is correct even on floats with a NaN on the left,
      // as a NaN would skip the computation and just return the NaN,
      // and that is precisely what we do here. but, the same with -1
      // (change to a negation) would be incorrect for that reason.
      if (right->value == Literal::makeFromInt32(1, type)) {
        if (binary->op == Abstract::getBinary(type, Abstract::Mul) ||
            binary->op == Abstract::getBinary(type, Abstract::DivS) ||
            binary->op == Abstract::getBinary(type, Abstract::DivU)) {
          return binary->left;
        }
      }
    }
    // TODO: v128 not implemented yet
    return nullptr;
  }

  // optimize trivial math operations, given that the left side of a binary
  // is a constant. since we canonicalize constants to the right for symmetrical
  // operations, we only need to handle asymmetrical ones here
  // TODO: templatize on type?
  Expression* optimizeWithConstantOnLeft(Binary* binary) {
    auto type = binary->left->type;
    auto* left = binary->left->cast<Const>();
    if (type.isInteger()) {
      // operations on zero
      if (left->value == Literal::makeFromInt32(0, type)) {
        if ((binary->op == Abstract::getBinary(type, Abstract::Shl) ||
             binary->op == Abstract::getBinary(type, Abstract::ShrU) ||
             binary->op == Abstract::getBinary(type, Abstract::ShrS)) &&
            !EffectAnalyzer(
               getPassOptions(), getModule()->features, binary->right)
               .hasSideEffects()) {
          return binary->left;
        }
      }
    }
    return nullptr;
  }

  // TODO: templatize on type?
  Expression* optimizeRelational(Binary* binary) {
    // TODO: inequalities can also work, if the constants do not overflow
    auto type = binary->right->type;
    // integer math, even on 2s complement, allows stuff like
    // x + 5 == 7
    //   =>
    //     x == 2
    if (binary->left->type.isInteger()) {
      if (binary->op == Abstract::getBinary(type, Abstract::Eq) ||
          binary->op == Abstract::getBinary(type, Abstract::Ne)) {
        if (auto* left = binary->left->dynCast<Binary>()) {
          if (left->op == Abstract::getBinary(type, Abstract::Add) ||
              left->op == Abstract::getBinary(type, Abstract::Sub)) {
            if (auto* leftConst = left->right->dynCast<Const>()) {
              if (auto* rightConst = binary->right->dynCast<Const>()) {
                return combineRelationalConstants(
                  binary, left, leftConst, nullptr, rightConst);
              } else if (auto* rightBinary = binary->right->dynCast<Binary>()) {
                if (rightBinary->op ==
                      Abstract::getBinary(type, Abstract::Add) ||
                    rightBinary->op ==
                      Abstract::getBinary(type, Abstract::Sub)) {
                  if (auto* rightConst = rightBinary->right->dynCast<Const>()) {
                    return combineRelationalConstants(
                      binary, left, leftConst, rightBinary, rightConst);
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
  // left is also a binary, and has a constant; right may be just a constant, in
  // which case right is nullptr
  Expression* combineRelationalConstants(Binary* binary,
                                         Binary* left,
                                         Const* leftConst,
                                         Binary* right,
                                         Const* rightConst) {
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

  Expression* optimizeMemoryCopy(MemoryCopy* memCopy) {
    FeatureSet features = getModule()->features;

    // memory.copy(x, x, sz)  ==>  nop
    if (!EffectAnalyzer(getPassOptions(), features, memCopy->dest)
           .hasSideEffects() &&
        !EffectAnalyzer(getPassOptions(), features, memCopy->size)
           .hasSideEffects() &&
        ExpressionAnalyzer::equal(memCopy->dest, memCopy->source)) {
      return ExpressionManipulator::nop(memCopy);
    }
    // memory.copy(dst, src, C)  ==>  store(dst, load(src))
    if (auto* csize = memCopy->size->dynCast<Const>()) {
      auto bytes = csize->value.geti32();
      Builder builder(*getModule());

      switch (bytes) {
        case 0: {
          return builder.makeBlock({builder.makeDrop(memCopy->dest),
                                    builder.makeDrop(memCopy->source)});
          break;
        }
        case 1:
        case 2:
        case 4: {
          return builder.makeStore(
            bytes, // bytes
            0,     // offset
            1,     // align
            memCopy->dest,
            builder.makeLoad(bytes, false, 0, 1, memCopy->source, Type::i32),
            Type::i32);
        }
        case 8: {
          return builder.makeStore(
            bytes, // bytes
            0,     // offset
            1,     // align
            memCopy->dest,
            builder.makeLoad(bytes, false, 0, 1, memCopy->source, Type::i64),
            Type::i64);
        }
        case 16: {
          if (getPassOptions().shrinkLevel == 0) {
            // This adds an extra 2 bytes so apply it only for
            // minimal shrink level
            if (features.hasSIMD()) {
              return builder.makeStore(
                bytes, // bytes
                0,     // offset
                1,     // align
                memCopy->dest,
                builder.makeLoad(
                  bytes, false, 0, 1, memCopy->source, Type::v128),
                Type::v128);
            }
          }
        }
        default: {
        }
      }
    }
    return nullptr;
  }

  // given a binary expression with equal children and no side effects in
  // either, we can fold various things
  // TODO: trinaries, things like (x & (y & x)) ?
  Expression* optimizeBinaryWithEqualEffectlessChildren(Binary* binary) {
    // TODO add: perhaps worth doing 2*x if x is quite large?
    switch (binary->op) {
      case SubInt32:
      case XorInt32:
      case SubInt64:
      case XorInt64:
        return LiteralUtils::makeZero(binary->left->type, *getModule());
      case NeInt64:
      case LtSInt64:
      case LtUInt64:
      case GtSInt64:
      case GtUInt64:
      case NeInt32:
      case LtSInt32:
      case LtUInt32:
      case GtSInt32:
      case GtUInt32:
        return LiteralUtils::makeZero(Type::i32, *getModule());
      case AndInt32:
      case OrInt32:
      case AndInt64:
      case OrInt64:
        return binary->left;
      case EqInt32:
      case LeSInt32:
      case LeUInt32:
      case GeSInt32:
      case GeUInt32:
      case EqInt64:
      case LeSInt64:
      case LeUInt64:
      case GeSInt64:
      case GeUInt64:
        return LiteralUtils::makeFromInt32(1, Type::i32, *getModule());
      default:
        return nullptr;
    }
  }

  BinaryOp invertBinaryOp(BinaryOp op) {
    // use de-morgan's laws
    switch (op) {
      case EqInt32:
        return NeInt32;
      case NeInt32:
        return EqInt32;
      case LtSInt32:
        return GeSInt32;
      case LtUInt32:
        return GeUInt32;
      case LeSInt32:
        return GtSInt32;
      case LeUInt32:
        return GtUInt32;
      case GtSInt32:
        return LeSInt32;
      case GtUInt32:
        return LeUInt32;
      case GeSInt32:
        return LtSInt32;
      case GeUInt32:
        return LtUInt32;

      case EqInt64:
        return NeInt64;
      case NeInt64:
        return EqInt64;
      case LtSInt64:
        return GeSInt64;
      case LtUInt64:
        return GeUInt64;
      case LeSInt64:
        return GtSInt64;
      case LeUInt64:
        return GtUInt64;
      case GtSInt64:
        return LeSInt64;
      case GtUInt64:
        return LeUInt64;
      case GeSInt64:
        return LtSInt64;
      case GeUInt64:
        return LtUInt64;

      case EqFloat32:
        return NeFloat32;
      case NeFloat32:
        return EqFloat32;

      case EqFloat64:
        return NeFloat64;
      case NeFloat64:
        return EqFloat64;

      default:
        return InvalidBinary;
    }
  }
};

Pass* createOptimizeInstructionsPass() { return new OptimizeInstructions(); }

} // namespace wasm
