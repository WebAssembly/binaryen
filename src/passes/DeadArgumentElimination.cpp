// 16.8,16.7,16.75
// =>
// 14.5
// not a big... win
// allC is 1.65
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
// Optimizes call arguments in a whole-program manner. In particular, this
// removes ones that are not used (dead), but it also does more things:
//
//  * Find functions for whom an argument is always passed the same
//    constant. If so, we can just set that local to that constant
//    in the function.
//  * Find functions that don't use the value passed to an argument.
//    If so, we can avoid even sending and receiving it. (Note how if
//    the previous point was true for an argument, then the second
//    must as well.)
//  * Find return values ("return arguments" ;) that are never used.
//  * Refine the types of arguments, that is make the argument type more
//    specific if all the passed values allow that.
//
// This pass does not depend on flattening, but it may be more effective,
// as then call arguments never have side effects (which we need to
// watch for here).
//

#include <algorithm>
#include <unordered_map>
#include <unordered_set>

#include "ir/effects.h"
#include "ir/element-utils.h"
#include "ir/find_all.h"
#include "ir/lubs.h"
#include "ir/module-utils.h"
#include "ir/return-utils.h"
#include "ir/type-updating.h"
#include "ir/utils.h"
#include "param-utils.h"
#include "pass.h"
#include "passes/opt-utils.h"
#include "support/sorted_vector.h"
#include "support/timing.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

// Information for a function
struct DAEFunctionInfo {
  // Whether this needs to be recomputed. This begins as true for the first
  // computation, and we reset it every time we touch the function.
  bool stale = true;
  // TODO
  bool justUpdated = false;
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
  // The set of functions that have calls from places that limit what we can do.
  // For now, any call we don't see inhibits our optimizations, but TODO: an
  // export could be worked around by exporting a thunk that adds the parameter.
  //
  // This is built up in parallel in each function, and combined at the end.
  std::unordered_set<Name> hasUnseenCalls;

  // Clears all data, which marks us as stale and in need of recomputation.
  void clear() { *this = DAEFunctionInfo(); }

  void markStale() { stale = true; }
};

using DAEFunctionInfoMap = std::unordered_map<Name, DAEFunctionInfo>;

struct DAEScanner
  : public WalkerPass<PostWalker<DAEScanner, Visitor<DAEScanner>>> {
  bool isFunctionParallel() override { return true; }
  bool modifiesBinaryenIR() override { return false; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<DAEScanner>(infoMap);
  }

  DAEScanner(DAEFunctionInfoMap* infoMap) : infoMap(infoMap) {}

  // The map of all infos for all functions.
  DAEFunctionInfoMap* infoMap;

  // The info for the function this instance operates on. We stash this as an
  // optimization.
  DAEFunctionInfo* info = nullptr;

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
    // RefFunc may be visited from either a function, in which case |info| was
    // set, or module-level code (in which case we use the null function name in
    // the infoMap).
    auto* currInfo = info ? info : &(*infoMap)[Name()];

    // Treat a ref.func as an unseen call, preventing us from changing the
    // function's type. If we did change it, it could be an observable
    // difference from the outside, if the reference escapes, for example.
    // TODO: look for actual escaping?
    // TODO: create a thunk for external uses that allow internal optimizations
    currInfo->hasUnseenCalls.insert(curr->func);
  }

  // main entry point

  void doWalkFunction(Function* func) {
    // Set the info for this function.
    info = &((*infoMap)[func->name]);

    if (!info->stale) {
      // Nothing changed since last time.
      info->justUpdated = false;
      return;
    }

    // Clear the data, mark us as no longer stale, and recompute everything.
    info->clear();
    info->stale = false;
    info->justUpdated = true;

    PostWalker<DAEScanner, Visitor<DAEScanner>>::doWalkFunction(func);

    // If there are params, check if they are used.
    // TODO: This work could be avoided if we cannot optimize for other reasons.
    //       That would require deferring this to later and checking that.
    auto numParams = func->getNumParams();
    if (numParams > 0) {
      auto usedParams = ParamUtils::getUsedParams(func, getModule());
      for (Index i = 0; i < numParams; i++) {
        if (usedParams.count(i) == 0) {
          info->unusedParams.insert(i);
        }
      }
    }
  }
};

static Timer scan("scan"), combine("combine"), callerz("callerz"), opt1("opt1"), opt2("opt2"), opt3("opt3"), opt4("opt4"), loc("loc"), oai("oai"),allC("allC");

struct DAE : public Pass {
  // This pass changes locals and parameters.
  // FIXME DWARF updating does not handle local changes yet.
  bool invalidatesDWARF() override { return true; }

  bool optimize = false;

  Index numFunctions;

  // Map of function names to indexes. This lets us use indexes below for speed.
  std::unordered_map<Name, Index> indexes;

  // TODO comment
  struct CallInfo {
    // Store the calls and their origins in parallel vectors, as we need |calls|
    // by itself for certain APIs. This is, origins[i] is the function index in
    // which calls[i] appears.
    std::vector<Call*> calls;
    std::vector<Index> origins;
  };
  // TODO comment
  std::vector<CallInfo> allCalls;

  void run(Module* module) override {
    DAEFunctionInfoMap infoMap;
    // Ensure all entries exist so the parallel threads don't modify the data
    // structure.
    for (auto& func : module->functions) {
      infoMap[func->name];
    }
    // The null name represents module-level code (not in a function).
    infoMap[Name()];

    numFunctions = module->functions.size();

    for (Index i = 0; i < numFunctions; i++) {
      indexes[module->functions[i]->name] = i;
    }

    allCalls.resize(numFunctions);

    // Iterate to convergence.
    while (1) {
      if (!iteration(module, infoMap)) {
        break;
      }
    }

    scan.dump();
    combine.dump();
    callerz.dump();
    opt1.dump();
    opt2.dump();
    opt3.dump();
    opt4.dump();
    loc.dump();
    oai.dump();
    allC.dump();

  }

  // For each function, the set of callers. This is used to propagate changes,
  // e.g. if we remove a return value from a function, the calls might benefit
  // from optimization. It is ok if this is an over-approximation, that is, if
  // we think there are more callers than there are, as it would just lead to
  // unneeded extra scanning of calling functions (in the example just given, if
  // a caller did not actually call, they would not benefit from the extra
  // optimization, but no harm is done, and no optimization missed). Such over-
  // approximation can happen in later optimization iterations: We may manage to
  // remove a call from a function to another (say, after applying a constant
  // param, we see the call is not reached). This is somewhat rare, and the cost
  // of computing this map is significant, so we compute it once at the start
  // and then use that possibly-over-approximating data.
  std::vector<std::vector<Name>> callers;
  // TODO
  std::vector<std::vector<Index>> callees;

  bool iteration(Module* module, DAEFunctionInfoMap& infoMap) {
    std::cout << "iter\n";

    allDroppedCalls.clear();

#if DAE_DEBUG
    // Enable this path to mark all contents as stale at the start of each
    // iteration, which can be used to check for staleness bugs (that is, bugs
    // where something should have been marked stale, but wasn't). Note, though,
    // that staleness bugs can easily cause serious issues with validation (e.g.
    // if data is stale we may miss that there is an additional caller, that
    // prevents refining argument types etc.), so this may not be terribly
    // helpful.
    if (getenv("ALWAYS_MARK_STALE")) {
      for (auto& [_, info] : infoMap) {
        info.markStale();
      }
    }
#endif

scan.start();

    DAEScanner scanner(&infoMap);
    scanner.walkModuleCode(module);
    // Scan all the functions.
    scanner.run(getPassRunner(), module);

scan.stop();

combine.start();

    // Combine all the info from the scan.
    std::vector<bool> tailCallees(numFunctions);
    std::vector<bool> hasUnseenCalls(numFunctions);

    for (auto& [func, info] : infoMap) {
      for (auto& callee : info.tailCallees) {
        tailCallees[indexes[callee]] = true;
      }
      for (auto& [call, dropp] : info.droppedCalls) {
        allDroppedCalls[call] = dropp;
      }
      for (auto& name : info.hasUnseenCalls) {
        hasUnseenCalls[indexes[name]] = true;
      }
    }
    // Exports are considered unseen calls.
    for (auto& curr : module->exports) {
      if (curr->kind == ExternalKind::Function) {
        hasUnseenCalls[indexes[*curr->getInternalName()]] = true;
      }
    }

combine.stop();

callerz.start();
    // See comment above, we compute callers once and never again.
    if (callers.empty()) {
      // Compute first as sets, to deduplicate.
      std::vector<std::unordered_set<Name>> callersSets(numFunctions);
      for (auto& [func, info] : infoMap) {
        for (auto& [name, calls] : info.calls) {
          callersSets[indexes[name]].insert(func);
        }
      }
      // Copy into efficient vectors.
      callers.resize(numFunctions);
      callees.resize(numFunctions);
      for (Index i = 0; i < numFunctions; ++i) {
        auto& set = callersSets[i];
        callers[i] = std::vector<Name>(set.begin(), set.end());
        for (auto& caller : callers[i]) {
          callees[indexes[caller]].push_back(i);
        }
      }
    }
callerz.stop();

allC.start();

    // Recompute parts of allCalls as necessary. We know which function infos
    // were just updated, and start there: If we updated { A, B }, and A calls
    // C while B calls C and D, then the list of all calls must be updated for
    // C and D. First, find those functions called by just-updated functions.
    std::unordered_set<Index> justUpdated;
    std::unordered_set<Index> calledByJustUpdated;
    for (auto& [func, info] : infoMap) {
      if (info.justUpdated) {
//std::cerr << "just updated " << func << '\n';
        auto index = indexes[func];
        justUpdated.insert(index);
        for (auto& callee : callees[index]) {
          calledByJustUpdated.insert(callee);
        }
      }
    }

    auto addCallsFrom = [&](Index caller) {
      auto& info = infoMap[module->functions[caller]->name];
//std::cerr << "processing calls from  " << caller << '\n';
      for (auto& [name, calls] : info.calls) {
        auto& allCallsToName = allCalls[indexes[name]].calls;
        allCallsToName.insert(allCallsToName.end(), calls.begin(), calls.end());
        auto num = calls.size();
        auto& origins = allCalls[indexes[name]].origins;
        for (Index i = 0; i < num; i++) {
          origins.push_back(caller);
        }
      }
    };

std::cout << "  updating allcalls justUpdated=" << justUpdated.size() << ", called by them=" << calledByJustUpdated.size() << " out of " << numFunctions << '\n';
    if (justUpdated.size() + calledByJustUpdated.size() > numFunctions / 10) {
      // Many functions need to be processed to do an incremental update. Just
      // do a full recompute from scratch, which may be faster.
      allCalls.clear();
      allCalls.resize(numFunctions);
      for (Index caller = 0; caller < numFunctions; caller++) {
        addCallsFrom(caller);
      }
    } else {
      // Do an incremental update.
      std::cout << "  incrememt\n";
      // For each such called function, we don't want to alter calls from
      // unchanged functions. That is, if X calls C and D in the example above,
      // and X is not just-updated, then X's calls to C and D are fine as they
      // are. Leaving such calls alone, remove calls from the callers that we did
      // just update, and after that, add them from the fresh data we have on
      // those just-updated functions.
      for (auto& called : calledByJustUpdated) {
        auto& calledCalls = allCalls[called];
        auto oldSize = calledCalls.calls.size();
        assert(oldSize == calledCalls.origins.size());
        Index skip = 0;
        for (Index i = 0; i < calledCalls.calls.size(); i++) {
          if (justUpdated.count(calledCalls.origins[i])) {
            // Remove it by skipping over.
            skip++;
          } else if (skip) {
            // Keep it by writing to the proper place.
            calledCalls.calls[i - skip] = calledCalls.calls[i];
            calledCalls.origins[i - skip] = calledCalls.origins[i];
          }
        }
        if (skip > 0) {
          // Update the sizes after removing things.
          calledCalls.calls.resize(oldSize - skip);
          calledCalls.origins.resize(oldSize - skip);
        }
      }
      // The just-updated callers have been cleaned out of |allCalls|. Add their
      // calls, after which that data structure is up-to-date.
      for (auto& caller : justUpdated) {
        addCallsFrom(caller);
      }
    }
    
allC.stop();
    // Track which functions we changed that are worth re-optimizing at the end.
    std::unordered_set<Function*> worthOptimizing;

    // If we refine return types then we will need to do more type updating
    // at the end.
    bool refinedReturnTypes = false;

    // If we find that localizing call arguments can help (by moving their
    // effects outside, so ParamUtils::removeParameters can handle them), then
    // we do that at the end and perform another cycle. It is simpler to just do
    // another cycle than to track the locations of calls, which is tricky as
    // localization might move a call (if a call happens to be another call's
    // param). In practice it is rare to find call arguments we want to remove,
    // and even more rare to find effects get in the way, so this should not
    // cause much overhead.
    //
    // This set tracks the functions for whom calls to it should be modified.
    std::unordered_set<Name> callTargetsToLocalize;

    // As we optimize, we mark things as stale.
    auto markStale = [&](Name func) {
      // We only ever mark functions stale (not the global scope, which we never
      // modify). An attempt to modify the global scope, identified by a null
      // function name, is a logic bug.
      assert(func.is());
      infoMap[func].markStale();
    };
    auto markCallersStale = [&](Index index) {
      for (auto caller : callers[index]) {
        markStale(caller);
      }
    };

opt1.start();
    // We now have a mapping of all call sites for each function, and can look
    // for optimization opportunities.
    for (Index index = 0; index < numFunctions; index++) {
      auto* func = module->functions[index].get();
      if (func->imported()) {
        continue;
      }
      // We can only optimize if we see all the calls and can modify them.
      if (hasUnseenCalls[index]) {
        continue;
      }
      auto& calls = allCalls[index].calls;
      if (calls.empty()) {
        // Nothing calls this, so it is not worth optimizing.
        continue;
      }
      // Refine argument types before doing anything else. This does not
      // affect whether an argument is used or not, it just refines the type
      // where possible.
      auto name = func->name;
      if (refineArgumentTypes(func, calls, module, infoMap[name])) {
        worthOptimizing.insert(func);
        markStale(func->name);
      }
      // Refine return types as well.
      if (refineReturnTypes(func, calls, module)) {
        refinedReturnTypes = true;
        markStale(name);
        markCallersStale(index);
      }
      auto optimizedIndexes =
        ParamUtils::applyConstantValues({func}, calls, {}, module);
      for (auto i : optimizedIndexes) {
        // Mark it as unused, which we know it now is (no point to re-scan just
        // for that).
        infoMap[name].unusedParams.insert(i);
      }
      if (!optimizedIndexes.empty()) {
        markStale(func->name);
      }
    }
opt1.stop();
    if (refinedReturnTypes) {
opt2.start();
      // Changing a call expression's return type can propagate out to its
      // parents, and so we must refinalize.
      // TODO: We could track in which functions we actually make changes.
      ReFinalize().run(getPassRunner(), module);
opt2.stop();
    }
opt3.start();
    // We now know which parameters are unused, and can potentially remove them.
    for (Index index = 0; index < numFunctions; index++) {
      auto* func = module->functions[index].get();
      if (func->imported()) {
        continue;
      }
      if (hasUnseenCalls[index]) {
        continue;
      }
      auto numParams = func->getNumParams();
      if (numParams == 0) {
        continue;
      }
      auto& calls = allCalls[index].calls;
      if (calls.empty()) {
        continue;
      }
      auto name = func->name;
      auto [removedIndexes, outcome] = ParamUtils::removeParameters(
        {func}, infoMap[name].unusedParams, calls, {}, module, getPassRunner());
      if (!removedIndexes.empty()) {
//std::cerr << "remove param " << func->name << '\n';
        // Success!
        worthOptimizing.insert(func);
        markStale(name);
        markCallersStale(index);
      }
      if (outcome == ParamUtils::RemovalOutcome::Failure) {
        callTargetsToLocalize.insert(name);
      }
    }
opt3.stop();
opt4.start();
    // We can also tell which calls have all their return values dropped. Note
    // that we can't do this if we changed anything so far, as we may have
    // modified allCalls (we can't modify a call site twice in one iteration,
    // once to remove a param, once to drop the return value).
    if (worthOptimizing.empty()) {
      for (Index index = 0; index < numFunctions; index++) {
        auto& func = module->functions[index];
        if (func->imported()) {
          continue;
        }
        if (func->getResults() == Type::none) {
          continue;
        }
        if (hasUnseenCalls[index]) {
          continue;
        }
        auto name = func->name;
        if (infoMap[name].hasTailCalls) {
          continue;
        }
        if (tailCallees[index]) {
          continue;
        }
        auto& calls = allCalls[index].calls;
        if (calls.empty()) {
          continue;
        }
        bool allDropped =
          std::all_of(calls.begin(), calls.end(), [&](Call* call) {
            return allDroppedCalls.count(call);
          });
        if (!allDropped) {
          continue;
        }
        if (removeReturnValue(func.get(), calls, module)) {
          // We should optimize the callers.
          for (auto caller : callers[index]) {
            worthOptimizing.insert(module->getFunction(caller));
          }
        }
        // TODO Removing a drop may also open optimization opportunities in the
        // callers.
        worthOptimizing.insert(func.get());
        markStale(name);
        markCallersStale(index);
      }
    }
opt4.stop();
    if (!callTargetsToLocalize.empty()) {
loc.start();
      ParamUtils::localizeCallsTo(
        callTargetsToLocalize, *module, getPassRunner(), [&](Function* func) {
          markStale(func->name);
        });
loc.stop();
    }
    if (optimize && !worthOptimizing.empty()) {
oai.start();
      OptUtils::optimizeAfterInlining(worthOptimizing, module, getPassRunner());
oai.stop();
    }

    return !worthOptimizing.empty() || refinedReturnTypes ||
           !callTargetsToLocalize.empty();
  }

private:
  std::unordered_map<Call*, Expression**> allDroppedCalls;

  // Returns `true` if the caller should be optimized.
  bool
  removeReturnValue(Function* func, std::vector<Call*>& calls, Module* module) {
    // If the result type is uninhabitable, then the caller knows the call will
    // never return. That useful information would be lost if we did nothing
    // else when removing the return value, but we will insert an `unreachable`
    // after the call in the caller to preserve the optimization effect. TODO:
    // Do this for more complicated uninhabitable types such as non-nullable
    // references to structs with non-nullable reference cycles.
    bool wasReturnUninhabitable =
      func->getResults().isNull() && func->getResults().isNonNullable();
    func->setResults(Type::none);
    // Remove the drops on the calls. Note that we must do this before updating
    // returns in ReturnUpdater, as there may be recursive calls of this
    // function to itself. So we first use the information in allDroppedCalls
    // before the ReturnUpdater potentially invalidates that information as it
    // modifies the function.
    for (auto* call : calls) {
      auto iter = allDroppedCalls.find(call);
      assert(iter != allDroppedCalls.end());
      Expression** location = iter->second;
      if (wasReturnUninhabitable) {
        Builder builder(*module);
        *location = builder.makeSequence(call, builder.makeUnreachable());
      } else {
        *location = call;
      }
      // Update the call's type.
      if (call->type != Type::unreachable) {
        call->type = Type::none;
      }
    }
    // Remove any return values.
    ReturnUtils::removeReturns(func, *module);
    // It's definitely worth optimizing the caller after inserting the
    // unreachable.
    return wasReturnUninhabitable;
  }

  // Given a function and all the calls to it, see if we can refine the type of
  // its arguments. If we only pass in a subtype, we may as well refine the type
  // to that.
  //
  // This assumes that the function has no calls aside from |calls|, that is, it
  // is not exported or called from the table or by reference.
  bool refineArgumentTypes(Function* func,
                           const std::vector<Call*>& calls,
                           Module* module,
                           const DAEFunctionInfo& info) {
    if (!module->features.hasGC()) {
      return false;
    }
    auto numParams = func->getNumParams();
    std::vector<Type> newParamTypes;
    newParamTypes.reserve(numParams);
    std::vector<LUBFinder> lubs(numParams);
    for (Index i = 0; i < numParams; i++) {
      auto originalType = func->getLocalType(i);
      // If the parameter type is not a reference, there is nothing to refine.
      // And if it is unused, also do nothing, as we can leave it to the other
      // parts of this pass to optimize it properly, which avoids having to
      // think about corner cases involving refining the type of an unused
      // param (in particular, unused params are turned into locals, which means
      // we'd need to think about defaultability etc.).
      if (!originalType.isRef() || info.unusedParams.has(i)) {
        newParamTypes.push_back(originalType);
        continue;
      }
      auto& lub = lubs[i];
      for (auto* call : calls) {
        auto* operand = call->operands[i];
        lub.note(operand->type);
        if (lub.getLUB() == originalType) {
          // We failed to refine this parameter to anything more specific.
          break;
        }
      }

      // Nothing is sent here at all; leave such optimizations to DCE.
      if (!lub.noted()) {
        return false;
      }
      newParamTypes.push_back(lub.getLUB());
    }

    // Check if we are able to optimize here before we do the work to scan the
    // function body.
    auto newParams = Type(newParamTypes);
    if (newParams == func->getParams()) {
      return false;
    }

    // We can do this!
    TypeUpdating::updateParamTypes(func, newParamTypes, *module);

    // Update the function's type.
    func->setParams(newParams);

    return true;
  }

  // See if the types returned from a function allow us to define a more refined
  // return type for it. If so, we can update it and all calls going to it.
  //
  // This assumes that the function has no calls aside from |calls|, that is, it
  // is not exported or called from the table or by reference. Exports should be
  // fine, as should indirect calls in principle, but VMs will need to support
  // function subtyping in indirect calls. TODO: relax this when possible
  //
  // Returns whether we optimized.
  //
  // TODO: We may be missing a global optimum here, as e.g. if a function calls
  //       itself and returns that value, then we would not do any change here,
  //       as one of the return values is exactly what it already is. Similar
  //       unoptimality can happen with multiple functions, more local code in
  //       the middle, etc.
  bool refineReturnTypes(Function* func,
                         const std::vector<Call*>& calls,
                         Module* module) {
    auto lub = LUB::getResultsLUB(func, *module);
    if (!lub.noted()) {
      return false;
    }
    auto newType = lub.getLUB();
    if (newType != func->getResults()) {
      func->setResults(newType);
      for (auto* call : calls) {
        if (call->type != Type::unreachable) {
          call->type = newType;
        }
      }
      return true;
    }
    return false;
  }
};

Pass* createDAEPass() { return new DAE(); }

Pass* createDAEOptimizingPass() {
  auto* ret = new DAE();
  ret->optimize = true;
  return ret;
}

} // namespace wasm
