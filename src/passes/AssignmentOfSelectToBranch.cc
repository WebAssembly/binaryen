/*
 * Copyright 2015 WebAssembly Community Group participants
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

// LLVM might transform an assignment inside of an if to a select statement. E.g, the following code
// if (distance < shortestDistance) {
//   shortestDistance = distance;
// }
//
// is transformed to
// shortestDistance = distance < shortestDistance ? distance : shortestDistance
// If such an assignment is inside of a loop it introduce a significant overhead (~4-5%) because of the assignments
// to the variable even in cases where the value does not change. This pass reverts the llvm transformation
// and tries to group as many conditional assignments inside of a loop into a single block.
// @remark The llvm pass might still be desired, e.g. it can be easier for the loop vectorizer to transform if it is
// a select statement instead of a deeply branched if / else.

#include <algorithm>
#include "wasm.h"
#include "pass.h"
#include "ast_utils.h"

namespace wasm {

    struct SelfAssignment {
        If* ifStmt = nullptr;
        size_t blockIndex;
        Expression* initializer = nullptr;
    };

    struct ConditionComparison {
        bool equal;
        bool inverted;
    };

    struct AssignmentOfSelectToBranchPass : WalkerPass<PostWalker<AssignmentOfSelectToBranchPass>> {
    private:
        bool isConditionalSelfAssignment(Expression* expression) {
            auto* setLocal = expression->dynCast<SetLocal>();
            if (setLocal == nullptr || !setLocal->value->is<Select>()) {
                return false;
            }

            auto* select = setLocal->value->cast<Select>();

            // existing = cond ? newValue : existing;
            bool condFalseEqualsSelf = select->ifFalse->is<GetLocal>() && select->ifFalse->cast<GetLocal>()->index == setLocal->index;
            // existing = cond ? existing : newValue;
            bool condTrueEqualsSelf = select->ifTrue->is<GetLocal>() && select->ifTrue->cast<GetLocal>()->index == setLocal->index;

            return condFalseEqualsSelf || condTrueEqualsSelf;
        }
    public:
        bool isFunctionParallel() override { return true; }

        AssignmentOfSelectToBranchPass* create() override {
            return new AssignmentOfSelectToBranchPass();
        }

        void visitBlock(Block* curr) {
            Builder builder { *getModule() };
            // change to optional with c++17
            bool hasPrevious = false;
            SelfAssignment previous = {};

            for (size_t i = 0; i < curr->list.size(); ++i) {
                auto expression = curr->list[i];
                bool isSelfAssignment = isConditionalSelfAssignment(expression);

                if (!isSelfAssignment) {
                    if (hasPrevious) {
                        // insert existing ifStmt
                        insertAssignment(curr, previous, builder);
                        previous = {};
                        hasPrevious = false;
                    }

                    continue;
                }

                SelfAssignment selfAssignment = this->convertSetSelectToIf(expression, i, builder);
                if (!hasPrevious) {
                    // no existing if stmt exist
                    previous = selfAssignment;
                    hasPrevious = true;
                } else {
                    // insert the previous assignment as the conditions do not match, continue working with this assignment
                    previous = mergeOrInsertAssignment(curr, previous, selfAssignment, builder);
                }
            }

            if (hasPrevious) {
                insertAssignment(curr, previous, builder);
                hasPrevious = false;
                previous = {};
            }
        }

    private:
        const SelfAssignment convertSetSelectToIf(Expression* expression, size_t index, Builder& builder) {
            auto* setLocal = expression->cast<SetLocal>();
            auto* select = setLocal->value->cast<Select>();
            Expression* otherValue = nullptr;
            Expression* condition = select->condition;

            SelfAssignment assignment {};
            assignment.blockIndex = index;

            if (select->ifFalse->is<GetLocal>() && select->ifFalse->cast<GetLocal>()->index == setLocal->index) {
                otherValue = select->ifTrue;
            } else {
                condition = builder.makeUnary(UnaryOp::EqZInt32, condition); // invert condition
                otherValue = select->ifFalse;
            }

            // value is a tee local, change it to a pure set and read the value in the true branch
            // Conversion is needed as the value set in the tee local might be used in the condition
            if (auto setValue = otherValue->dynCast<SetLocal>()) {
                otherValue = builder.makeGetLocal(setValue->index, setValue->type);

                setValue->setTee(false);
                assignment.initializer = setValue;
            }

            SetLocal* setInstruction = builder.makeSetLocal(setLocal->index, otherValue);
            assignment.ifStmt = builder.makeIf(condition, setInstruction);

            return assignment;
        }

        ConditionComparison areConditionsEqual(If* first, If* second) const {
            Expression* firstCondition = first->condition;
            Expression* secondCondition = second->condition;
            bool firstNeg = false;
            bool secondNeg = false;

            if (auto* firstUnary = firstCondition->dynCast<Unary>()) {
                if (firstUnary->op == UnaryOp::EqZInt32) {
                    firstCondition = firstUnary->value;
                    firstNeg = true;
                }
            }

            if (auto* secondUnary = secondCondition->dynCast<Unary>()) {
                if (secondUnary->op == UnaryOp::EqZInt32) {
                    secondCondition = secondUnary->value;
                    secondNeg = true;
                }
            }

            bool equal = ExpressionAnalyzer::equal(firstCondition, secondCondition);
            ConditionComparison result {};
            result.inverted = firstNeg != secondNeg;

            if (equal) {
                result.equal = true;
                return result;
            }

            Index index;
            if (auto getLocal = first->condition->dynCast<GetLocal>()) {
                index = getLocal->index;
            } else if (auto setLocal = first->condition->dynCast<SetLocal>()) {
                index = setLocal->index; // a tee local
            } else {
                return result;
            }

            if (auto getLocal = second->condition->dynCast<GetLocal>()) {
                result.equal = index == getLocal->index;
            }

            return result;
        }

        const SelfAssignment mergeOrInsertAssignment(Block* block, const SelfAssignment& previous, const SelfAssignment& next, Builder &builder) const {
            auto conditionComparison = areConditionsEqual(previous.ifStmt, next.ifStmt);
            // do not merge assignments with initializer. They might change the condition value
            if (conditionComparison.equal && next.initializer == nullptr) {
                auto merged = mergeAssignments(previous, next, conditionComparison.inverted, builder);
                block->list[next.blockIndex] = builder.makeNop();
                return merged;
            }

            // Assignments cannot be merged because different conditions are used. Insert the previous block and continue with
            // the new one
            insertAssignment(block, previous, builder);
            return next;
        }

        const SelfAssignment mergeAssignments(const SelfAssignment& first, const SelfAssignment& second, bool inverted, Builder& builder) const {
            SelfAssignment result {};
            result.blockIndex = first.blockIndex;

            if (first.initializer != nullptr && second.initializer != nullptr) {
                result.initializer = builder.blockifyMerge(first.initializer, second.initializer);
            } else if (first.initializer != nullptr) {
                result.initializer = first.initializer;
            } else {
                result.initializer = second.initializer;
            }


            Expression* ifTrue = mergePotentiallyNull(first.ifStmt->ifTrue, inverted ? second.ifStmt->ifFalse : second.ifStmt->ifTrue, builder);
            Expression* ifFalse = mergePotentiallyNull(first.ifStmt->ifFalse, inverted ? second.ifStmt->ifTrue : second.ifStmt->ifFalse, builder);
            result.ifStmt = builder.makeIf(first.ifStmt->condition, ifTrue, ifFalse);

            return result;
        }

        Expression* mergePotentiallyNull(Expression* first, Expression* second, Builder& builder) const {
            if (first != nullptr && second != nullptr) {
                return builder.blockifyMerge(first, second);
            }

            if (first != nullptr) {
                return first;
            }

            return second;
        }

        void insertAssignment(Block* block, const SelfAssignment& assignment, Builder& builder) const {
            if (assignment.initializer != nullptr) {
                block->list[assignment.blockIndex] = builder.makeSequence(assignment.initializer, assignment.ifStmt);
            } else {
                block->list[assignment.blockIndex] = assignment.ifStmt;
            }
        }
    };

    Pass *createAssignmentOfSelectToBranchPass() {
        return new AssignmentOfSelectToBranchPass();
    }
}
