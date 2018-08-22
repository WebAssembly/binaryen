/*
 * Copyright 2018 WebAssembly Community Group participants
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
// Optimizes call arguments in a whole-program manner.
//
// Specifically, this does these things:
//
//  * Find functions for whom an argument is always passed the same
//    constant. If so, we can just set that local to that constant
//    in the function.
//  * Find functions that don't use the value passed to an argument.
//    If so, we can avoid even sending and receiving it. (Note how if
//    the previous point was true for an argument, then the second
//    must as well.)
//
// This pass does not depend on flattening, but it may be more effective,
// as then call arguments never have side effects (which we need to
// watch for here).
//

#include <unordered_map>
#include <unordered_set>

#include <wasm.h>
#include <pass.h>
#include <wasm-builder.h>
#include <cfg/cfg-traversal.h>
#include <ir/utils.h>
#include <support/sorted_vector.h>
#include <support/unique_deferring_queue.h>

namespace wasm {

// Information for a function
struct CAOFunctionInfo {
  // The unused parameters, if any.
  SortedVector unusedParams;
  // Maps a function name to the calls going to it.
  std::unordered_map<Name, std::vector<Call*> calls;
};

typedef std::unordered_map<Name, CAOFunctionInfo> CAOFunctionInfoMap;

// Information in a basic block
struct CAOBlockInfo {
  // A local may be read, written, or not accessed in this block.
  // If it is both read and written, we just care about the first
  // action (if it is read first, that's all the info we are
  // looking for; if it is written first, it can't be read later).
  enum LocalUse {
    Read,
    Written
  };
  std::unordered_set<LocalUse> localUses;
};

struct CAOScanner : public WalkerPass<CFGWalker<CAOScanner, Visitor<CAOScanner>, CAOBlockInfo>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new CAOScanner(info); }

  CAOScanner(CAOFunctionInfoMap* infoMap) : infoMap(infoMap) {}

  CAOFunctionInfoMap* infoMap;
  CAOFunctionInfo* info;

  Index numParams;

  // cfg traversal work

  void visitGetLocal(GetLocal* curr) {
    if (currBasicBlock) {
      auto& localUses = currBasicBlock->contents.localUses;
      auto index = curr->index;
      if (localUses.count(index) == 0) {
        localUses[index] = CAOBlockInfo::Read;
      }
    }
  }

  void visitSetLocal(SetLocal* curr) {
    if (currBasicBlock) {
      auto& localUses = currBasicBlock->contents.localUses;
      auto index = curr->index;
      if (localUses.count(index) == 0) {
        localUses[index] = CAOBlockInfo::Written;
      }
    }
  }

  static void visitCall(Call* curr) {
    info->calls[curr->name].push_back(curr);
  }

  // main entry point

  void doWalkFunction(Function* func) {
    numParams = func->getNumParams();
    info = &((*infoMap)[func->info]);
    CFGWalker<CAOScanner, Visitor<CAOScanner>, Info>::doWalkFunction(func);
    // If there are params, check if they are used
    if (numParams > 0) {
      findUnusedParams(func);
    }
  }

  void findUnusedParams(Function* func) {
    // Flow the incoming parameter values, see if they reach a read.
    // Once we've seen a parameter at a block, we need never consider it there
    // again.
    std::unordered_map<BasicBlock*, SortedVector> seenBlockIndexes;
    // Start with all the incoming parameters.
    SortedVector initial;
    for (Index i = 0; i < numParams; i++) {
      initial.push_back(i);
    }
    // The used params, which we now compute.
    std::unordered_set<Index> usedParams;
    // An item of work is a block plus the values arriving there.
    typedef std::pair<BasicBlock*, SortedVector> Item;
    UniqueDeferredQueue<Item> work;
    work.push(Item(entry, initial));
    while (!work.empty()) {
      auto item = work.pop();
      auto* block = item.first;
      auto& indexes = item.second;
      // Ignore things we've already seen, or we've already seen to be used.
      auto& seenIndexes = seenBlockIndexes[block];
      indexes.erase(std::remove_if(indexes.begin(), indexes.end(), [&](const Index i) {
        if (seenIndexes.has(i) || usedParams.count(i)) {
          return true;
        } else {
          seenIndexes.insert(i);
          return false;
        }
      }), indexes.end());
      if (indexes.empty()) {
        continue; // nothing more to flow
      }
      auto& localUses = block->contents.localUses;
      SortedVector remainingIndexes;
      for (auto i : indexes) {
        auto iter = localUses.find(i);
        if (iter != localuses.end()) {
          auto use = iter->second;
          if (use == CAOBlockInfo::Read) {
            usedParams.insert(i);
          }
          // Whether it was a read or a write, we can stop looking at that local here.
        } else {
          remainingIndexes.insert(i);
        }
      }
      // If there are remaining indexes, flow them forward.
      if (!remainingIndexes.empty()) {
        for (auto* next : block->out) {
          work.push(Item(next, remainingIndexes));
        }
      }
    }
    // We can now compute the unused params.
    for (Index i = 0; i < numParams; i++) {
      if (usedParams.count(i) == 0) {
        info->unusedParams.insert(i);
      }
    }
  }
};

struct CallArgumentOptimization : public Pass {
  void run(PassRunner* runner, Module* module) override {
    CAOFunctionInfoMap infoMap;
    // Ensure they all exist so the parallel threads don't modify the data structure.
    for (auto& func : module->functions) {
      infoMap[func->name];
    }
    // Scan all the functions.
    {
      PassRunner runner(module);
      runner.setIsNested(true);
      runner.add<CAOScanner>(&infoMap);
      runner.run();
    }
    // Combine all the info.
    std::unordered_map<Name, std::vector<Call*> allCalls;
    for (auto& pair : infoMap) {
      auto& info = pair.second;
      for (auto& pair : info.calls) {
        auto name = pair.first;
        auto& calls = pair.second;
        auto& allCallsToName = allCalls[name];
        allCallsToName.insert(allCallsToName.end(), calls.begin(), calls.end());
      }
    }
    // We now have a mapping of all call sites for each function. Check which
    // are always passed the same constant for a particular argument.
    for (auto& pair : allCalls) {
      auto name = pair.first;
      auto& calls = pair.second;
      auto* func = module->getFunction(name);
      auto numParams = func->getNumParams();
      for (Index i = 0; i < numParams; i++) {
        Literal value;
        for (auto* call : calls) {
          assert(call->operands.size() == numParams);
          auto* operand = call->operands[i];
          if (auto* c = operand->dynCall<Const>()) {
            if (value.type == none) {
              // This is the first value seen.
              value = c->value;
            } else if (value != c->value) {
              // Not identical, give up
              value.type = none;
              break;
            }
          } else {
            // Not a constant, give up
            value.type = none;
            break;
          }
        }
        if (value.type != none) {
          // Success! We can just apply the constant in the function, which makes
          // the parameter value unused, which lets us remove it later.
          Builder builder(*module);
          func->body = builder.makeSequence(
            builder.makeSetLocal(i, builder.makeConst(value)),
            func->body
          );
          // Mark it as unused (to avoid scanning again).
          infoMap[name].unusedParams.insert(i);
        }
      }
    }
    // FIXME: remove stuff in table and exports, here
    // We now know which parameters are unused, and can potentially remove them.
    for (auto& pair : allCalls) {
      auto name = pair.first;
      auto& calls = pair.second;
      auto* func = module->getFunction(name);
      auto numParams = func->getNumParams();
      if (numParams == 0) continue;
      // Iterate downwards, as we may remove more than one.
      Index i = numParams - 1;
      while (1) {
        if (infoMap[name].unusedParams.has(i)) {
          // Great, it's not used. Check if none of the calls has a param with side
          // effects, as that would prevent us removing them (flattening before
          // should have been done).
          bool can = true;
          for (auto* call : calls) {
            auto* operand = call->operands[i];
            if (EffectAnalyzer(runner->getPassOptions(), operand).hasSideEffects()) {
              can = false;
              break;
            }
          }
          if (can) {
            // Wonderful, nothing stands in our way! Do it.
            // TODO: parallelize this?
            removeParameter(func, i, calls);
          }
        }
        if (i == 0) break;
        i--;
      }
    }
  }

private:
  void removeParameter(Function* func, Index i, std::vector<Call*> calls) {
    // Clear the type, which is no longer accurate.
    func->type = Name();
    // It's cumbersome to adjust local names - TODO don't clear them?
    Builder::clearLocalNames(func);
    // Remove the parameter from the function. We must add a new local
    // for uses of the parameter, but cannot make it use the same index
    // (in general).
    auto type = func->getLocalType(i);
    func->params.erase(func->params.begin() + i);
    Index newIndex = Builder::addVar(func, type);
    // Update local operations.
    struct LocalUpdater : public PostWalker<LocalUpdater> {
      Index removedIndex;
      Index newIndex;
      LocalUpdater(Function* func, Index removedIndex, Index newIndex) : removedIndex(removedIndex), newIndex(newIndex) {
        walk(func->body);
      }
      void visitGetLocal(GetLocal* curr) {
        updateIndex(curr->index);
      }
      void visitSetLocal(SetLocal* curr) {
        updateIndex(curr->index);
      }
      void updateIndex(Index& index) {
        if (index == removedIndex) {
          index = newIndex;
        } else if (index > removedIndex) {
          index--;
        }
      }
    } localUpdater(func);
    // Remove the arguments from the calls.
    for (auto* call : calls) {
      call->operands.erase(call->operands.begin() + i);
    }
  }
};

Pass *createCallArgumentOptimizationPass() {
  return new CallArgumentOptimization();
}

} // namespace wasm

/*
tests:
  * args with side effects
  * in table or in export, prevents us
  * removing more than one - the order matterz
*/

