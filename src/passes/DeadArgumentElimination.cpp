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
// Optimizes call arguments in a whole-program manner, removing ones
// that are not used (dead).
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
//  * Find return values ("return arguments" ;) that are never used.
//
// This pass does not depend on flattening, but it may be more effective,
// as then call arguments never have side effects (which we need to
// watch for here).
//

#include <unordered_map>
#include <unordered_set>

#include "cfg/cfg-traversal.h"
#include "ir/effects.h"
#include "ir/element-utils.h"
#include "ir/module-utils.h"
#include "ir/type-updating.h"
#include "pass.h"
#include "passes/opt-utils.h"
#include "support/sorted_vector.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

// Information for a function
struct DAEFunctionInfo {
  // The unused parameters, if any.
  SortedVector unusedParams;
  // Maps a function name to the calls going to it.
  std::unordered_map<Name, std::vector<Call*>> calls;
  // Map of all calls that are dropped, to their drops' locations (so that
  // if we can optimize out the drop, we can replace the drop there).
  std::unordered_map<Call*, Expression**> droppedCalls;
  // Whether this function contains any tail calls (including indirect tail
  // calls) and the set of functions this function tail calls. Tail-callers and
  // tail-callees cannot have their dropped returns removed because of the
  // constraint that tail-callees must have the same return type as
  // tail-callers. Indirectly tail called functions are already not optimized
  // because being in a table inhibits DAE. TODO: Allow the removal of dropped
  // returns from tail-callers if their tail-callees can have their returns
  // removed as well.
  bool hasTailCalls = false;
  std::unordered_set<Name> tailCallees;
  // Whether the function can be called from places that
  // affect what we can do. For now, any call we don't
  // see inhibits our optimizations, but TODO: an export
  // could be worked around by exporting a thunk that
  // adds the parameter.
  // This is atomic so that we can write to it from any function at any time
  // during the parallel analysis phase which is run in DAEScanner.
  std::atomic<bool> hasUnseenCalls;

  DAEFunctionInfo() { hasUnseenCalls = false; }
};

typedef std::unordered_map<Name, DAEFunctionInfo> DAEFunctionInfoMap;

// Information in a basic block
struct DAEBlockInfo {
  // A local may be read, written, or not accessed in this block.
  // If it is both read and written, we just care about the first
  // action (if it is read first, that's all the info we are
  // looking for; if it is written first, it can't be read later).
  enum LocalUse { Read, Written };
  std::unordered_map<Index, LocalUse> localUses;
};

struct DAEScanner
  : public WalkerPass<
      CFGWalker<DAEScanner, Visitor<DAEScanner>, DAEBlockInfo>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new DAEScanner(infoMap); }

  DAEScanner(DAEFunctionInfoMap* infoMap) : infoMap(infoMap) {}

  DAEFunctionInfoMap* infoMap;
  DAEFunctionInfo* info;

  Index numParams;

  // cfg traversal work

  void visitLocalGet(LocalGet* curr) {
    if (currBasicBlock) {
      auto& localUses = currBasicBlock->contents.localUses;
      auto index = curr->index;
      if (localUses.count(index) == 0) {
        localUses[index] = DAEBlockInfo::Read;
      }
    }
  }

  void visitLocalSet(LocalSet* curr) {
    if (currBasicBlock) {
      auto& localUses = currBasicBlock->contents.localUses;
      auto index = curr->index;
      if (localUses.count(index) == 0) {
        localUses[index] = DAEBlockInfo::Written;
      }
    }
  }

  void visitCall(Call* curr) {
    if (!getModule()->getFunction(curr->target)->imported()) {
      info->calls[curr->target].push_back(curr);
    }
    if (curr->isReturn) {
      info->hasTailCalls = true;
      info->tailCallees.insert(curr->target);
    }
  }

  void visitCallIndirect(CallIndirect* curr) {
    if (curr->isReturn) {
      info->hasTailCalls = true;
    }
  }

  void visitCallRef(CallRef* curr) {
    if (curr->isReturn) {
      info->hasTailCalls = true;
    }
  }

  void visitDrop(Drop* curr) {
    if (auto* call = curr->value->dynCast<Call>()) {
      info->droppedCalls[call] = getCurrentPointer();
    }
  }

  void visitRefFunc(RefFunc* curr) {
    // We can't modify another function in parallel.
    assert((*infoMap).count(curr->func));
    // Treat a ref.func as an unseen call, preventing us from changing the
    // function's type. If we did change it, it could be an observable
    // difference from the outside, if the reference escapes, for example.
    // TODO: look for actual escaping?
    // TODO: create a thunk for external uses that allow internal optimizations
    (*infoMap)[curr->func].hasUnseenCalls = true;
  }

  // main entry point

  void doWalkFunction(Function* func) {
    numParams = func->getNumParams();
    info = &((*infoMap)[func->name]);
    CFGWalker<DAEScanner, Visitor<DAEScanner>, DAEBlockInfo>::doWalkFunction(
      func);
    // If there are relevant params, check if they are used. If we can't
    // optimize the function anyhow, there's no point (note that our check here
    // is technically racy - another thread could update hasUnseenCalls to true
    // around when we check it - but that just means that we might or might not
    // do some extra work, as we'll ignore the results later if we have unseen
    // calls. That is, the check for hasUnseenCalls here is just a minor
    // optimization to avoid pointless work. We can avoid that work if either
    // we know there is an unseen call before the parallel analysis that we are
    // part of, say if we are exported, or if another parallel function finds a
    // RefFunc to us and updates it before we check it).
    if (numParams > 0 && !info->hasUnseenCalls) {
      findUnusedParams();
    }
  }

  void findUnusedParams() {
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
      if (indexes.empty()) {
        continue; // nothing more to flow
      }
      auto& localUses = block->contents.localUses;
      SortedVector remainingIndexes;
      for (auto i : indexes) {
        auto iter = localUses.find(i);
        if (iter != localUses.end()) {
          auto use = iter->second;
          if (use == DAEBlockInfo::Read) {
            usedParams.insert(i);
          }
          // Whether it was a read or a write, we can stop looking at that local
          // here.
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
        info->unusedParams.insert(i);
      }
    }
  }
};

struct DAE : public Pass {
  // This pass changes locals and parameters.
  // FIXME DWARF updating does not handle local changes yet.
  bool invalidatesDWARF() override { return true; }

  bool optimize = false;

  void run(PassRunner* runner, Module* module) override {
    // Iterate to convergence.
    while (1) {
      if (!iteration(runner, module)) {
        break;
      }
    }
  }

  bool iteration(PassRunner* runner, Module* module) {
    allDroppedCalls.clear();

    DAEFunctionInfoMap infoMap;
    // Ensure they all exist so the parallel threads don't modify the data
    // structure.
    for (auto& func : module->functions) {
      infoMap[func->name];
    }
    DAEScanner scanner(&infoMap);
    scanner.walkModuleCode(module);
    for (auto& curr : module->exports) {
      if (curr->kind == ExternalKind::Function) {
        infoMap[curr->value].hasUnseenCalls = true;
      }
    }
    // Scan all the functions.
    scanner.run(runner, module);
    // Combine all the info.
    std::unordered_map<Name, std::vector<Call*>> allCalls;
    std::unordered_set<Name> tailCallees;
    for (auto& pair : infoMap) {
      auto& info = pair.second;
      for (auto& pair : info.calls) {
        auto name = pair.first;
        auto& calls = pair.second;
        auto& allCallsToName = allCalls[name];
        allCallsToName.insert(allCallsToName.end(), calls.begin(), calls.end());
      }
      for (auto& callee : info.tailCallees) {
        tailCallees.insert(callee);
      }
      for (auto& pair : info.droppedCalls) {
        allDroppedCalls[pair.first] = pair.second;
      }
    }
    // We now have a mapping of all call sites for each function. Check which
    // are always passed the same constant for a particular argument.
    for (auto& pair : allCalls) {
      auto name = pair.first;
      // We can only optimize if we see all the calls and can modify
      // them.
      if (infoMap[name].hasUnseenCalls) {
        continue;
      }
      auto& calls = pair.second;
      auto* func = module->getFunction(name);
      auto numParams = func->getNumParams();
      for (Index i = 0; i < numParams; i++) {
        Literal value;
        for (auto* call : calls) {
          assert(call->target == name);
          assert(call->operands.size() == numParams);
          auto* operand = call->operands[i];
          if (auto* c = operand->dynCast<Const>()) {
            if (value.type == Type::none) {
              // This is the first value seen.
              value = c->value;
            } else if (value != c->value) {
              // Not identical, give up
              value = Literal(Type::none);
              break;
            }
          } else {
            // Not a constant, give up
            value = Literal(Type::none);
            break;
          }
        }
        if (value.type != Type::none) {
          // Success! We can just apply the constant in the function, which
          // makes the parameter value unused, which lets us remove it later.
          Builder builder(*module);
          func->body = builder.makeSequence(
            builder.makeLocalSet(i, builder.makeConst(value)), func->body);
          // Mark it as unused, which we know it now is (no point to
          // re-scan just for that).
          infoMap[name].unusedParams.insert(i);
        }
      }
    }
    // Track which functions we changed, and optimize them later if necessary.
    std::unordered_set<Function*> changed;
    // We now know which parameters are unused, and can potentially remove them.
    for (auto& pair : allCalls) {
      auto name = pair.first;
      auto& calls = pair.second;
      if (infoMap[name].hasUnseenCalls) {
        continue;
      }
      auto* func = module->getFunction(name);
      auto numParams = func->getNumParams();
      if (numParams == 0) {
        continue;
      }
      // Iterate downwards, as we may remove more than one.
      Index i = numParams - 1;
      while (1) {
        if (infoMap[name].unusedParams.has(i)) {
          // Great, it's not used. Check if none of the calls has a param with
          // side effects, as that would prevent us removing them (flattening
          // should have been done earlier).
          bool canRemove =
            std::none_of(calls.begin(), calls.end(), [&](Call* call) {
              auto* operand = call->operands[i];
              return EffectAnalyzer(runner->options, module->features, operand)
                .hasSideEffects();
            });
          if (canRemove) {
            // Wonderful, nothing stands in our way! Do it.
            // TODO: parallelize this?
            removeParameter(func, i, calls);
            TypeUpdating::handleNonNullableLocals(func, *module);
            changed.insert(func);
          }
        }
        if (i == 0) {
          break;
        }
        i--;
      }
    }
    // We can also tell which calls have all their return values dropped. Note
    // that we can't do this if we changed anything so far, as we may have
    // modified allCalls (we can't modify a call site twice in one iteration,
    // once to remove a param, once to drop the return value).
    if (changed.empty()) {
      for (auto& func : module->functions) {
        if (func->sig.results == Type::none) {
          continue;
        }
        auto name = func->name;
        if (infoMap[name].hasUnseenCalls) {
          continue;
        }
        if (infoMap[name].hasTailCalls) {
          continue;
        }
        if (tailCallees.find(name) != tailCallees.end()) {
          continue;
        }
        auto iter = allCalls.find(name);
        if (iter == allCalls.end()) {
          continue;
        }
        auto& calls = iter->second;
        bool allDropped =
          std::all_of(calls.begin(), calls.end(), [&](Call* call) {
            return allDroppedCalls.count(call);
          });
        if (!allDropped) {
          continue;
        }
        removeReturnValue(func.get(), calls, module);
        // TODO Removing a drop may also open optimization opportunities in the
        // callers.
        changed.insert(func.get());
      }
    }
    if (optimize && !changed.empty()) {
      OptUtils::optimizeAfterInlining(changed, module, runner);
    }
    return !changed.empty();
  }

private:
  std::unordered_map<Call*, Expression**> allDroppedCalls;

  void removeParameter(Function* func, Index i, std::vector<Call*>& calls) {
    // It's cumbersome to adjust local names - TODO don't clear them?
    Builder::clearLocalNames(func);
    // Remove the parameter from the function. We must add a new local
    // for uses of the parameter, but cannot make it use the same index
    // (in general).
    std::vector<Type> params(func->sig.params.begin(), func->sig.params.end());
    auto type = params[i];
    params.erase(params.begin() + i);
    func->sig.params = Type(params);
    Index newIndex = Builder::addVar(func, type);
    // Update local operations.
    struct LocalUpdater : public PostWalker<LocalUpdater> {
      Index removedIndex;
      Index newIndex;
      LocalUpdater(Function* func, Index removedIndex, Index newIndex)
        : removedIndex(removedIndex), newIndex(newIndex) {
        walk(func->body);
      }
      void visitLocalGet(LocalGet* curr) { updateIndex(curr->index); }
      void visitLocalSet(LocalSet* curr) { updateIndex(curr->index); }
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

  void
  removeReturnValue(Function* func, std::vector<Call*>& calls, Module* module) {
    func->sig.results = Type::none;
    Builder builder(*module);
    // Remove any return values.
    struct ReturnUpdater : public PostWalker<ReturnUpdater> {
      Module* module;
      ReturnUpdater(Function* func, Module* module) : module(module) {
        walk(func->body);
      }
      void visitReturn(Return* curr) {
        auto* value = curr->value;
        assert(value);
        curr->value = nullptr;
        Builder builder(*module);
        replaceCurrent(builder.makeSequence(builder.makeDrop(value), curr));
      }
    } returnUpdater(func, module);
    // Remove any value flowing out.
    if (func->body->type.isConcrete()) {
      func->body = builder.makeDrop(func->body);
    }
    // Remove the drops on the calls.
    for (auto* call : calls) {
      auto iter = allDroppedCalls.find(call);
      assert(iter != allDroppedCalls.end());
      Expression** location = iter->second;
      *location = call;
      // Update the call's type.
      if (call->type != Type::unreachable) {
        call->type = Type::none;
      }
    }
  }
};

Pass* createDAEPass() { return new DAE(); }

Pass* createDAEOptimizingPass() {
  auto* ret = new DAE();
  ret->optimize = true;
  return ret;
}

} // namespace wasm
