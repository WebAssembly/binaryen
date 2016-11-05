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
#include <ast_utils.h>
#include <ast/cost.h>
#include <ast/properties.h>

namespace wasm {

Name I32_EXPR  = "i32.expr",
     I64_EXPR  = "i64.expr",
     F32_EXPR  = "f32.expr",
     F64_EXPR  = "f64.expr",
     ANY_EXPR  = "any.expr";

// A pattern
struct Pattern {
  Expression* input;
  Expression* output;

  Pattern(Expression* input, Expression* output) : input(input), output(output) {}
};

// Database of patterns
struct PatternDatabase {
  Module wasm;

  char* input;

  std::map<Expression::Id, std::vector<Pattern>> patternMap; // root expression id => list of all patterns for it TODO optimize more

  PatternDatabase() {
    // generate module
    input = strdup(
      #include "OptimizeInstructions.wast.processed"
    );
    try {
      SExpressionParser parser(input);
      Element& root = *parser.root;
      SExpressionWasmBuilder builder(wasm, *root[0]);
      // parse module form
      auto* func = wasm.getFunction("patterns");
      auto* body = func->body->cast<Block>();
      for (auto* item : body->list) {
        auto* pair = item->cast<Block>();
        patternMap[pair->list[0]->_id].emplace_back(pair->list[0], pair->list[1]);
      }
    } catch (ParseException& p) {
      p.dump(std::cerr);
      Fatal() << "error in parsing wasm binary";
    }
  }

  ~PatternDatabase() {
    free(input);
  };
};

static PatternDatabase* database = nullptr;

struct DatabaseEnsurer {
  DatabaseEnsurer() {
    assert(!database);
    database = new PatternDatabase;
  }
};

// Check for matches and apply them
struct Match {
  Module& wasm;
  Pattern& pattern;

  Match(Module& wasm, Pattern& pattern) : wasm(wasm), pattern(pattern) {}

  std::vector<Expression*> wildcards; // id in i32.any(id) etc. => the expression it represents in this match

  // Comparing/checking

  // Check if we can match to this pattern, updating ourselves with the info if so
  bool check(Expression* seen) {
    // compare seen to the pattern input, doing a special operation for our "wildcards"
    assert(wildcards.size() == 0);
    return ExpressionAnalyzer::flexibleEqual(pattern.input, seen, *this);
  }

  bool compare(Expression* subInput, Expression* subSeen) {
    CallImport* call = subInput->dynCast<CallImport>();
    if (!call || call->operands.size() != 1 || call->operands[0]->type != i32 || !call->operands[0]->is<Const>()) return false;
    Index index = call->operands[0]->cast<Const>()->value.geti32();
    // handle our special functions
    auto checkMatch = [&](WasmType type) {
      if (type != none && subSeen->type != type) return false;
      while (index >= wildcards.size()) {
        wildcards.push_back(nullptr);
      }
      if (!wildcards[index]) {
        // new wildcard
        wildcards[index] = subSeen; // NB: no need to copy
        return true;
      } else {
        // We are seeing this index for a second or later time, check it matches
        return ExpressionAnalyzer::equal(subSeen, wildcards[index]);
      };
    };
    if (call->target == I32_EXPR) {
      if (checkMatch(i32)) return true;
    } else if (call->target == I64_EXPR) {
      if (checkMatch(i64)) return true;
    } else if (call->target == F32_EXPR) {
      if (checkMatch(f32)) return true;
    } else if (call->target == F64_EXPR) {
      if (checkMatch(f64)) return true;
    } else if (call->target == ANY_EXPR) {
      if (checkMatch(none)) return true;
    }
    return false;
  }

  // Applying/copying

  // Apply the match, generate an output expression from the matched input, performing substitutions as necessary
  Expression* apply() {
    return ExpressionManipulator::flexibleCopy(pattern.output, wasm, *this);
  }

  // When copying a wildcard, perform the substitution.
  // TODO: we can reuse nodes, not copying a wildcard when it appears just once, and we can reuse other individual nodes when they are discarded anyhow.
  Expression* copy(Expression* curr) {
    CallImport* call = curr->dynCast<CallImport>();
    if (!call || call->operands.size() != 1 || call->operands[0]->type != i32 || !call->operands[0]->is<Const>()) return nullptr;
    Index index = call->operands[0]->cast<Const>()->value.geti32();
    // handle our special functions
    if (call->target == I32_EXPR || call->target == I64_EXPR || call->target == F32_EXPR || call->target == F64_EXPR || call->target == ANY_EXPR) {
      return ExpressionManipulator::copy(wildcards.at(index), wasm);
    }
    return nullptr;
  }
};

// Main pass class
struct OptimizeInstructions : public WalkerPass<PostWalker<OptimizeInstructions, UnifiedExpressionVisitor<OptimizeInstructions>>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new OptimizeInstructions; }

  void prepareToRun(PassRunner* runner, Module* module) override {
    static DatabaseEnsurer ensurer;
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
    }
  }

  // Optimizations that don't yet fit in the pattern DSL, but could be eventually maybe
  Expression* handOptimize(Expression* curr) {
    if (auto* binary = curr->dynCast<Binary>()) {
      if (Properties::isSymmetric(binary)) {
        // canonicalize a const to the second position
        if (binary->left->is<Const>() && !binary->right->is<Const>()) {
          std::swap(binary->left, binary->right);
        }
      }
      // pattern match a load of 8 bits and a sign extend using a shl of 24 then shr_s of 24 as well, etc.
      if (binary->op == BinaryOp::ShrSInt32 && binary->right->is<Const>()) {
        auto shifts = binary->right->cast<Const>()->value.geti32();
        if (shifts == 24 || shifts == 16) {
          auto* left = binary->left->dynCast<Binary>();
          if (left && left->op == ShlInt32 && left->right->is<Const>() && left->right->cast<Const>()->value.geti32() == shifts) {
            auto* load = left->left->dynCast<Load>();
            if (load && ((load->bytes == 1 && shifts == 24) || (load->bytes == 2 && shifts == 16))) {
              load->signed_ = true;
              return load;
            }
          }
        }
      } else if (binary->op == EqInt32) {
        if (auto* c = binary->right->dynCast<Const>()) {
          if (c->value.geti32() == 0) {
            // equal 0 => eqz
            return Builder(*getModule()).makeUnary(EqZInt32, binary->left);
          }
        }
        if (auto* c = binary->left->dynCast<Const>()) {
          if (c->value.geti32() == 0) {
            // equal 0 => eqz
            return Builder(*getModule()).makeUnary(EqZInt32, binary->right);
          }
        }
      } else if (binary->op == AndInt32) {
        if (auto* right = binary->right->dynCast<Const>()) {
          if (right->type == i32) {
            auto mask = right->value.geti32();
            // and with -1 does nothing (common in asm.js output)
            if (mask == -1) {
              return binary->left;
            }
            // small loads do not need to be masted, the load itself masks
            if (auto* load = binary->left->dynCast<Load>()) {
              if ((load->bytes == 1 && mask == 0xff) ||
                  (load->bytes == 2 && mask == 0xffff)) {
                load->signed_ = false;
                return load;
              }
            } else if (mask == 1 && Properties::emitsBoolean(binary->left)) {
              // (bool) & 1 does not need the outer mask
              return binary->left;
            }
          }
        }
        return conditionalizeExpensiveOnBitwise(binary);
      } else if (binary->op == OrInt32) {
        return conditionalizeExpensiveOnBitwise(binary);
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
      }
    } else if (auto* select = curr->dynCast<Select>()) {
      select->condition = optimizeBoolean(select->condition);
      auto* condition = select->condition->dynCast<Unary>();
      if (condition && condition->op == EqZInt32) {
        // flip select to remove eqz, if we can reorder
        EffectAnalyzer ifTrue(select->ifTrue);
        EffectAnalyzer ifFalse(select->ifFalse);
        if (!ifTrue.invalidates(ifFalse)) {
          select->condition = condition->value;
          std::swap(select->ifTrue, select->ifFalse);
        }
      }
    } else if (auto* br = curr->dynCast<Break>()) {
      if (br->condition) {
        br->condition = optimizeBoolean(br->condition);
      }
    } else if (auto* store = curr->dynCast<Store>()) {
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

private:
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
    auto leftEffects = EffectAnalyzer(left).hasSideEffects();
    auto rightEffects = EffectAnalyzer(right).hasSideEffects();
    if (leftEffects && rightEffects) return nullptr; // both must execute
   // canonicalize with side effects, if any, happening on the left
    if (rightEffects) {
      if (CostAnalyzer(left).cost < MIN_COST) return nullptr; // avoidable code is too cheap
      std::swap(left, right);
    } else if (leftEffects) {
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
};

Pass *createOptimizeInstructionsPass() {
  return new OptimizeInstructions();
}

} // namespace wasm
