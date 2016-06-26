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
    // TODO: do this on first use, with a lock, to avoid startup pause
    // generate module
    input = strdup(
      #include "OptimizeInstructions.wast.processed"
    );
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
  }

  ~PatternDatabase() {
    free(input);
  };
};

static PatternDatabase database;

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

  void visitExpression(Expression* curr) {
    // we may be able to apply multiple patterns, one may open opportunities that look deeper NB: patterns must not have cycles
    while (1) {
      auto iter = database.patternMap.find(curr->_id);
      if (iter == database.patternMap.end()) return;
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
};

Pass *createOptimizeInstructionsPass() {
  return new OptimizeInstructions();
}

} // namespace wasm
