/*
 * Copyright 2021 WebAssembly Community Group participants
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

#include "ir/eh-utils.h"
#include "ir/find_all.h"
#include "ir/iteration.h"
#include "ir/properties.h"
#include "wasm-builder.h"

namespace wasm {

namespace EHUtils {

// Finds the first 'pop' in the given catch body that does not belong to an
// inner try's catch, and sets `isInvalid` to true if the pop is enclosed in a
// control flow structure (other than an unnamed block) or is not in the catch
// body's first-descendant line.
static Expression** findPopPtr(Expression*& catchBody,
                               bool& isInvalid,
                               bool stopIfInvalid = false) {
  struct PopFinder : PostWalker<PopFinder> {
    bool isInvalid = false;
    bool stopIfInvalid = false;
    bool pushedTask = false;
    Expression** popPtr = nullptr;

    PopFinder(Expression*& catchBody, bool stopIfInvalid)
      : stopIfInvalid(stopIfInvalid) {
      walk(catchBody);
    }

    void pushTask(TaskFunc func, Expression** currp) {
      pushedTask = true;
      PostWalker<PopFinder>::pushTask(func, currp);
    }

    void maybePushTask(TaskFunc func, Expression** currp) {
      if (*currp) {
        pushTask(func, currp);
      }
    }

    static void scan(PopFinder* self, Expression** currp) {
      if (self->popPtr || (self->stopIfInvalid && self->isInvalid)) {
        return;
      }

      Expression* curr = *currp;
      if (curr->is<Pop>()) {
        self->popPtr = currp;
        return;
      }

      if (auto* try_ = curr->dynCast<Try>()) {
        self->isInvalid = true;
        if (!self->stopIfInvalid) {
          // Do not walk into inner catch bodies; pops in inner catch bodies
          // belong to the inner catches.
          self->pushTask(scan, &try_->body);
        }
        return;
      }

      if (!self->isInvalid && Properties::isControlFlowStructure(curr)) {
        if (curr->is<If>()) {
          // If's condition is a value child who comes before an 'if'
          // instruction in binary, so it is fine if a 'pop' is in there. We
          // don't allow a 'pop' to be in an 'if''s then or else body because
          // they are not first descendants. PostWalker scans the condition
          // first, and if the pop is not in the condition, reaching the end of
          // the condition's first-descendant line will set `isInvalid` before
          // the arms are scanned.
        } else if (auto* block = curr->dynCast<Block>()) {
          // Unnamed blocks are not emitted in the binary format, so a 'pop' at
          // the beginning of an unnamed block is valid. Named blocks may be
          // emitted if targeted by branches, so treat any 'pop' inside a named
          // block as invalid.
          if (block->name.is()) {
            self->isInvalid = true;
          }
        } else {
          assert(curr->is<Loop>() || curr->is<TryTable>());
          self->isInvalid = true;
        }
      }

      if (self->stopIfInvalid && self->isInvalid) {
        return;
      }

      // If PostWalker::scan doesn't push a task to scan any children, then we
      // must have reached a leaf node. The first leaf reached is the leftmost
      // leaf, and the only valid place for a Pop to appear. We already know
      // this is not a Pop, so if this is a leaf, then any later Pop will be
      // invalid.
      self->pushedTask = false;
      PostWalker<PopFinder>::scan(self, currp);
      if (!self->pushedTask) {
        self->isInvalid = true;
      }
    }
  } finder(catchBody, stopIfInvalid);

  isInvalid = finder.isInvalid;
  return finder.popPtr;
}

bool containsValidDanglingPop(Expression* catchBody) {
  bool isInvalid = false;
  auto* popPtr = findPopPtr(catchBody, isInvalid, /*stopIfInvalid=*/true);
  return popPtr != nullptr && !isInvalid;
}

void handleBlockNestedPop(Try* try_, Function* func, Module& wasm) {
  Builder builder(wasm);
  for (Index i = 0; i < try_->catchTags.size(); i++) {
    Name tagName = try_->catchTags[i];
    auto* tag = wasm.getTag(tagName);
    if (tag->params() == Type::none) {
      continue;
    }

    auto*& catchBody = try_->catchBodies[i];
    bool isInvalid = false;
    Expression** popPtr = findPopPtr(catchBody, isInvalid);
    assert(popPtr && "Pop has not been found in this catch");

    // Change code like
    // (catch $e
    //   ...
    //   (block
    //     (pop i32)
    //   )
    // )
    // into
    // (catch $e
    //   (local.set $new
    //     (pop i32)
    //   )
    //   ...
    //   (block
    //     (local.get $new)
    //   )
    // )
    if (isInvalid) {
      Expression* pop = *popPtr;
      Index newLocal = builder.addVar(func, pop->type);
      *popPtr = builder.makeLocalGet(newLocal, pop->type);
      catchBody =
        builder.makeSequence(builder.makeLocalSet(newLocal, pop), catchBody);
    }
  }
}

void handleBlockNestedPops(Function* func, Module& wasm, FeaturePolicy policy) {
  if (policy == FeaturePolicy::SkipIfNoEH &&
      !wasm.features.hasExceptionHandling()) {
    return;
  }
  FindAll<Try> trys(func->body);
  for (auto* try_ : trys.list) {
    handleBlockNestedPop(try_, func, wasm);
  }
}

Pop* findPop(Expression* expr) {
  auto pops = findPops(expr);
  if (pops.size() == 0) {
    return nullptr;
  }
  assert(pops.size() == 1);
  return pops[0];
}

SmallVector<Pop*, 1> findPops(Expression* expr) {
  SmallVector<Pop*, 1> pops;
  SmallVector<Expression*, 8> work;
  work.push_back(expr);
  while (!work.empty()) {
    auto* curr = work.back();
    work.pop_back();
    if (auto* pop = curr->dynCast<Pop>()) {
      pops.push_back(pop);
    } else if (auto* try_ = curr->dynCast<Try>()) {
      // We don't go into inner catch bodies; pops in inner catch bodies
      // belong to the inner catches
      work.push_back(try_->body);
    } else {
      for (auto* child : ChildIterator(curr)) {
        work.push_back(child);
      }
    }
  }
  return pops;
};

} // namespace EHUtils

} // namespace wasm
