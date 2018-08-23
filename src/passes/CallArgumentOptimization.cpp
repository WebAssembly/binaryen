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
#include <ir/effects.h>
#include <support/sorted_vector.h>

namespace wasm {

// Information for a function
struct CAOFunctionInfo {
  // The unused parameters, if any.
  SortedVector unusedParams;
  // Maps a function name to the calls going to it.
  std::unordered_map<Name, std::vector<Call*>> calls;
  // Whether the function can be called from places that
  // affect what we can do. For now, any call we don't
  // see inhibits our optimizations, but TODO: an export
  // could be worked around by exporting a thunk that
  // adds the parameter.
  bool hasUnseenCalls = false;
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
  std::unordered_map<Index, LocalUse> localUses;
};

struct CAOScanner : public WalkerPass<CFGWalker<CAOScanner, Visitor<CAOScanner>, CAOBlockInfo>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new CAOScanner(infoMap); }

  CAOScanner(CAOFunctionInfoMap* infoMap) : infoMap(infoMap) {}

  CAOFunctionInfoMap* infoMap;
  CAOFunctionInfo* info;

  Index numParams;

  // cfg traversal work

  void visitGetLocal(GetLocal* curr) {
std::cout << "get local\n";
    if (currBasicBlock) {
std::cout << "  in block\n";
      auto& localUses = currBasicBlock->contents.localUses;
      auto index = curr->index;
      if (localUses.count(index) == 0) {
std::cout << "    add a read\n";
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

  void visitCall(Call* curr) {
    info->calls[curr->target].push_back(curr);
  }

  // main entry point

  void doWalkFunction(Function* func) {
    numParams = func->getNumParams();
    info = &((*infoMap)[func->name]);
    CFGWalker<CAOScanner, Visitor<CAOScanner>, CAOBlockInfo>::doWalkFunction(func);
    // If there are relevant params, check if they are used. (If
    // we can't optimize the function anyhow, there's no point.)
    if (numParams > 0 && !info->hasUnseenCalls) {
      findUnusedParams(func);
    }
  }

  void findUnusedParams(Function* func) {
std::cout << "findUnused in " << func->name << '\n';
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
    std::vector<Item> work;
    work.emplace_back(entry, initial);
    while (!work.empty()) {
      auto item = std::move(work.back());
      work.pop_back();
      auto* block = item.first;
      auto& indexes = item.second;
std::cout << "  BB " << indexes.size() << '\n';
      // Ignore things we've already seen, or we've already seen to be used.
      auto& seenIndexes = seenBlockIndexes[block];
      indexes.filter([&](const Index i) {
        if (seenIndexes.has(i) || usedParams.count(i)) {
          return false;
        } else {
          seenIndexes.insert(i);
          return true;
        }
      });
std::cout << "    later " << indexes.size() << '\n';
      if (indexes.empty()) {
        continue; // nothing more to flow
      }
      auto& localUses = block->contents.localUses;
      SortedVector remainingIndexes;
      for (auto i : indexes) {
        auto iter = localUses.find(i);
        if (iter != localUses.end()) {
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
          work.emplace_back(next, remainingIndexes);
        }
      }
    }
    // We can now compute the unused params.
    for (Index i = 0; i < numParams; i++) {
      if (usedParams.count(i) == 0) {
std::cout << "an unused param in the func " << func->name << " : " << i << '\n';
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
    // Check the influence of the table and exports.
    for (auto& curr : module->exports) {
      if (curr->kind == ExternalKind::Function) {
        infoMap[curr->value].hasUnseenCalls = true;
      }
    }
    for (auto& segment : module->table.segments) {
      for (auto name : segment.data) {
        infoMap[name].hasUnseenCalls = true;
      }
    }
    // Scan all the functions.
    {
      PassRunner runner(module);
      runner.setIsNested(true);
      runner.add<CAOScanner>(&infoMap);
      runner.run();
    }
    // Combine all the info.
    std::unordered_map<Name, std::vector<Call*>> allCalls;
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
std::cout << "calls to " << name << '\n';
      // We can only optimize if we see all the calls and can modify
      // them.
      if (infoMap[name].hasUnseenCalls) continue;
      auto& calls = pair.second;
      auto* func = module->getFunction(name);
      auto numParams = func->getNumParams();
      for (Index i = 0; i < numParams; i++) {
std::cout << "  " << i << '\n';
        Literal value;
        for (auto* call : calls) {
          assert(call->target == name);
          assert(call->operands.size() == numParams);
          auto* operand = call->operands[i];
          if (auto* c = operand->dynCast<Const>()) {
std::cout << "  see " << value << '\n';
            if (value.type == none) {
std::cout << "    frist\n";
              // This is the first value seen.
              value = c->value;
            } else if (value != c->value) {
std::cout << "    diff :(\n";
              // Not identical, give up
              value.type = none;
              break;
            }
          } else {
std::cout << "    notconst\n";
            // Not a constant, give up
            value.type = none;
            break;
          }
        }
        if (value.type != none) {
std::cout << "  yay!\n";
          // Success! We can just apply the constant in the function, which makes
          // the parameter value unused, which lets us remove it later.
          Builder builder(*module);
          func->body = builder.makeSequence(
            builder.makeSetLocal(i, builder.makeConst(value)),
            func->body
          );
          // Mark it as unused, which we know it now is (no point to
          // re-scan just for that).
          infoMap[name].unusedParams.insert(i);
        }
      }
    }
    // We now know which parameters are unused, and can potentially remove them.
    for (auto& pair : allCalls) {
      auto name = pair.first;
std::cout << "latah " << name << '\n';
      auto& calls = pair.second;
      auto* func = module->getFunction(name);
      auto numParams = func->getNumParams();
      if (numParams == 0) continue;
      // Iterate downwards, as we may remove more than one.
      Index i = numParams - 1;
      while (1) {
std::cout << "  chak " << i << '\n';
        if (infoMap[name].unusedParams.has(i)) {
std::cout << "  unused!\n";
          // Great, it's not used. Check if none of the calls has a param with side
          // effects, as that would prevent us removing them (flattening before
          // should have been done).
          bool can = true;
          for (auto* call : calls) {
            auto* operand = call->operands[i];
            if (EffectAnalyzer(runner->options, operand).hasSideEffects()) {
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
    } localUpdater(func, i, newIndex);
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

