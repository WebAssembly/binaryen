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

#ifndef wasm_pass_h
#define wasm_pass_h

#include <functional>

#include "mixed_arena.h"
#include "support/utilities.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

class Pass;

//
// Global registry of all passes in /passes/
//
struct PassRegistry {
  PassRegistry();

  static PassRegistry* get();

  using Creator = std::function<Pass*()>;

  void registerPass(const char* name, const char* description, Creator create);

  // Register a pass that's used for internal testing. These passes do not show
  // up in --help.
  void
  registerTestPass(const char* name, const char* description, Creator create);
  std::unique_ptr<Pass> createPass(std::string name);
  std::vector<std::string> getRegisteredNames();
  bool containsPass(const std::string& name);
  std::string getPassDescription(std::string name);
  bool isPassHidden(std::string name);

private:
  void registerPasses();

  struct PassInfo {
    std::string description;
    Creator create;
    bool hidden;
    PassInfo() = default;
    PassInfo(std::string description, Creator create, bool hidden = false)
      : description(description), create(create), hidden(hidden) {}
  };
  std::map<std::string, PassInfo> passInfos;
};

struct InliningOptions {
  // Function size at which we always inline.
  // Typically a size so small that after optimizations, the inlined code will
  // be smaller than the call instruction itself. 2 is a safe number because
  // there is no risk of things like
  //
  //  (func $reverse (param $x i32) (param $y i32)
  //   (call $something (local.get $y) (local.get $x))
  //  )
  //
  // in which case the reversing of the params means we'll possibly need a temp
  // local. But that takes at least 3 nodes, and 2 < 3, while with 2 items we
  // may have a local.get, but no way to require it to be saved instead of
  // directly consumed.
  Index alwaysInlineMaxSize = 2;
  // Function size which we inline when there is only one caller. By default we
  // inline all such functions (as after inlining we can remove the original
  // function).
  Index oneCallerInlineMaxSize = -1;
  // Function size above which we never inline, ignoring the various flexible
  // factors (like whether we are optimizing for size or speed) that could
  // influence us.
  // This is checked after alwaysInlineMaxSize and oneCallerInlineMaxSize, but
  // the order normally won't matter.
  Index flexibleInlineMaxSize = 20;
  // Loops usually mean the function does heavy work, so the call overhead
  // is not significant and we do not inline such functions by default.
  bool allowFunctionsWithLoops = false;
  // The number of ifs to allow partial inlining of their conditions. A value of
  // zero disables partial inlining.
  // TODO: Investigate enabling this. Locally 4 appears useful on real-world
  //       code, but reports of regressions have arrived.
  Index partialInliningIfs = 0;
};

// Forward declaration for FuncEffectsMap.
class EffectAnalyzer;

using FuncEffectsMap = std::unordered_map<Name, EffectAnalyzer>;

struct PassOptions {
  friend Pass;

  // Run passes in debug mode, doing extra validation and timing checks.
  bool debug = false;
  // Whether to run the validator to check for errors.
  bool validate = true;
  // When validating validate globally and not just locally
  bool validateGlobally = true;
  // 0, 1, 2 correspond to -O0, -O1, -O2, etc.
  int optimizeLevel = 0;
  // 0, 1, 2 correspond to -O0, -Os, -Oz
  int shrinkLevel = 0;
  // Tweak thresholds for the Inlining pass.
  InliningOptions inlining;
  // Optimize assuming things like div by 0, bad load/store, will not trap.
  // This is deprecated in favor of trapsNeverHappen.
  bool ignoreImplicitTraps = false;
  // Optimize assuming a trap will never happen at runtime. This is similar to
  // ignoreImplicitTraps, but different:
  //
  //  * ignoreImplicitTraps simply ignores the side effect of trapping when it
  //    computes side effects, and then passes work with that data.
  //  * trapsNeverHappen assumes that if an instruction with a possible trap is
  //    reached, then it does not trap, and an (unreachable) - that always
  //    traps - is never reached.
  //
  // The main difference is that in trapsNeverHappen mode we will not move
  // around code that might trap, like this:
  //
  //  (if (condition) (code))
  //
  // If (code) might trap, ignoreImplicitTraps ignores that trap, and it might
  // end up moving (code) to happen before the (condition), that is,
  // unconditionally. trapsNeverHappen, on the other hand, does not ignore the
  // side effect of the trap; instead, it will potentially remove the trapping
  // instruction, if it can - it is always safe to remove a trap in this mode,
  // as the traps are assumed to not happen. Where it cannot remove the side
  // effect, it will at least not move code around.
  //
  // A consequence of this difference is that code that puts a possible trap
  // behind a condition is unsafe in ignoreImplicitTraps, but safe in
  // trapsNeverHappen. In general, trapsNeverHappen is safe on production code
  // where traps are either fatal errors or assertions, and it is assumed
  // neither of those can happen (and it is undefined behavior if they do).
  //
  // TODO: deprecate and remove ignoreImplicitTraps.
  //
  // Since trapsNeverHappen assumes a trap is never reached, it can in principle
  // remove code like this:
  //
  //   (i32.store ..)
  //   (unreachable)
  //
  // The trap isn't reached, by assumption, and if we reach the store then we'd
  // reach the trap, so we can assume that isn't reached either, and TNH can
  // remove both. We do have a specific limitation here, however, which is that
  // trapsNeverHappen cannot remove calls to *imports*. We assume that an import
  // might do things we cannot understand, so we never eliminate it. For
  // example, in LLVM output we might see this:
  //
  //   (call $abort) ;; a noreturn import - the process is halted with an error
  //   (unreachable)
  //
  // That trap is never actually reached since the abort halts execution. In TNH
  // we can remove the trap but not the call right before it.
  bool trapsNeverHappen = false;
  // Optimize assuming that the low 1K of memory is not valid memory for the
  // application to use. In that case, we can optimize load/store offsets in
  // many cases.
  bool lowMemoryUnused = false;
  enum { LowMemoryBound = 1024 };
  // Whether to allow "loose" math semantics, ignoring corner cases with NaNs
  // and assuming math follows the algebraic rules for associativity and so
  // forth (which IEEE floats do not, strictly speaking). This is inspired by
  // gcc/clang's -ffast-math flag.
  bool fastMath = false;
  // Whether to assume that an imported memory is zero-initialized. Without
  // this, we can do fewer optimizations on memory segments, because if memory
  // *was* modified then the wasm's segments may trample those previous
  // modifications. If memory was zero-initialized then we can remove zeros from
  // the wasm's segments.
  // (This is not a problem if the memory is *not* imported, since then wasm
  // creates it and we know it is all zeros right before the active segments are
  // applied.)
  bool zeroFilledMemory = false;
  // Assume code outside of the module does not inspect or interact with GC and
  // function references, with the goal of being able to aggressively optimize
  // all user-defined types. The outside may hold on to references and pass them
  // back in, but may not inspect their contents, call them, or reflect on their
  // types in any way.
  //
  // By default we do not make this assumption, and assume anything that escapes
  // to the outside may be inspected in detail, which prevents us from e.g.
  // changing the type of any value that may escape except by refining it (so we
  // can't remove or refine fields on an escaping struct type, for example,
  // unless the new type declares the original type as a supertype).
  //
  // Note that the module can still have imports and exports - otherwise it
  // could do nothing at all! - so the meaning of "closed world" is a little
  // subtle here. We do still want to keep imports and exports unchanged, as
  // they form a contract with the outside world. For example, if an import has
  // two parameters, we can't remove one of them. A nuance regarding that is how
  // type equality works between wasm modules using the isorecursive type
  // system: not only do we need to not remove a parameter as just mentioned,
  // but we also want to keep types of things on the boundary unchanged. For
  // example, we should not change an exported function's signature, as the
  // outside may need that type to properly call the export.
  //
  //   * Since the goal of closedWorld is to optimize types aggressively but
  //     types on the module boundary cannot be changed, we assume the producer
  //     has made a mistake and we consider it a validation error if any user
  //     defined types besides the types of imported or exported functions
  //     themselves appear on the module boundary. For example, no user defined
  //     struct type may be a parameter or result of an exported function. This
  //     error may be relaxed or made more configurable in the future.
  bool closedWorld = false;
  // Whether to try to preserve debug info through, which are special calls.
  bool debugInfo = false;
  // Whether to generate StackIR during binary writing. This is on by default
  // in -O2 and above.
  bool generateStackIR = false;
  // Whether to optimize StackIR during binary writing. How we optimize depends
  // on other optimization flags like optimizeLevel. This is on by default in
  // -O2 and above.
  bool optimizeStackIR = false;
  // Whether to print StackIR during binary writing, and if so to what stream.
  // This is mainly useful for debugging.
  std::optional<std::ostream*> printStackIR;
  // Whether we are targeting JS. In that case we want to avoid emitting things
  // in the optimizer that do not translate well to JS, or that could cause us
  // to need extra lowering work or even a loop (where we optimize to something
  // that needs lowering, then we lower it, then we can optimize it again to the
  // original form).
  bool targetJS = false;
  // Arbitrary string arguments from the commandline, which we forward to
  // passes.
  std::unordered_map<std::string, std::string> arguments;
  // Passes to skip and not run.
  std::unordered_set<std::string> passesToSkip;

  // Effect info computed for functions. One pass can generate this and then
  // other passes later can benefit from it. It is up to the sequence of passes
  // to update or discard this when necessary - in particular, when new effects
  // are added to a function this must be changed or we may optimize
  // incorrectly. However, it is extremely rare for a pass to *add* effects;
  // passes normally only remove effects. Passes that do add effects must set
  // addsEffects() so the pass runner is aware of them.
  std::shared_ptr<FuncEffectsMap> funcEffectsMap;

  // -Os is our default
  static constexpr const int DEFAULT_OPTIMIZE_LEVEL = 2;
  static constexpr const int DEFAULT_SHRINK_LEVEL = 1;

  void setDefaultOptimizationOptions() {
    optimizeLevel = DEFAULT_OPTIMIZE_LEVEL;
    shrinkLevel = DEFAULT_SHRINK_LEVEL;
  }

  static PassOptions getWithDefaultOptimizationOptions() {
    PassOptions ret;
    ret.setDefaultOptimizationOptions();
    return ret;
  }

  static PassOptions getWithoutOptimization() {
    return PassOptions(); // defaults are to not optimize
  }

private:
  bool hasArgument(std::string key) { return arguments.count(key) > 0; }

  std::string getArgument(std::string key, std::string errorTextIfMissing) {
    if (!hasArgument(key)) {
      Fatal() << errorTextIfMissing;
    }
    return arguments[key];
  }

  std::string getArgumentOrDefault(std::string key, std::string default_) {
    if (!hasArgument(key)) {
      return default_;
    }
    return arguments[key];
  }
};

//
// Runs a set of passes, in order
//
struct PassRunner {
  Module* wasm;
  MixedArena* allocator;
  std::vector<std::unique_ptr<Pass>> passes;
  PassOptions options;

  PassRunner(Module* wasm) : wasm(wasm), allocator(&wasm->allocator) {}
  PassRunner(Module* wasm, PassOptions options)
    : wasm(wasm), allocator(&wasm->allocator), options(options) {}

  // no copying, we control |passes|
  PassRunner(const PassRunner&) = delete;
  PassRunner& operator=(const PassRunner&) = delete;

  virtual ~PassRunner() = default;

  // But we can make it easy to create a nested runner
  // TODO: Go through and use this in more places
  explicit PassRunner(const PassRunner* runner)
    : wasm(runner->wasm), allocator(runner->allocator),
      options(runner->options), isNested(true) {}

  void setDebug(bool debug) {
    options.debug = debug;
    // validate everything by default if debugging
    options.validateGlobally = debug;
  }
  void setDebugInfo(bool debugInfo) { options.debugInfo = debugInfo; }
  void setValidateGlobally(bool validate) {
    options.validateGlobally = validate;
  }

  // Add a pass using its name.
  void add(std::string passName,
           std::optional<std::string> passArg = std::nullopt);

  // Add a pass given an instance.
  void add(std::unique_ptr<Pass> pass) { doAdd(std::move(pass)); }

  // Clears away all passes that have been added.
  void clear();

  // Adds the pass if there are no DWARF-related issues. There is an issue if
  // there is DWARF and if the pass does not support DWARF (as defined by the
  // pass returning true from invalidatesDWARF); otherwise, if there is no
  // DWARF, or the pass supports it, the pass is added.
  // In contrast to add(), add() will always add the pass, and it will print a
  // warning if there is an issue with DWARF. This method is useful for a pass
  // that is optional, to avoid adding it and therefore avoid getting the
  // warning.
  void addIfNoDWARFIssues(std::string passName);

  // Adds the default set of optimization passes; this is
  // what -O does.
  void addDefaultOptimizationPasses();

  // Adds the default optimization passes that work on
  // individual functions.
  void addDefaultFunctionOptimizationPasses();

  // Adds the default optimization passes that work on
  // entire modules as a whole, and make sense to
  // run before function passes.
  void addDefaultGlobalOptimizationPrePasses();

  // Adds the default optimization passes that work on
  // entire modules as a whole, and make sense to
  // run after function passes.
  // This is run at the very end of the optimization
  // process - you can assume no other opts will be run
  // afterwards.
  void addDefaultGlobalOptimizationPostPasses();

  // Run the passes on the module
  void run();

  // Run the passes on a specific function
  void runOnFunction(Function* func);

  // When running a pass runner within another pass runner, this
  // flag should be set. This influences how pass debugging works,
  // and may influence other things in the future too.
  void setIsNested(bool nested) { isNested = nested; }

  // BINARYEN_PASS_DEBUG is a convenient commandline way to log out the toplevel
  //                     passes, their times, and validate between each pass.
  //                     (we don't recurse pass debug into sub-passes, as it
  //                     doesn't help anyhow and also is bad for e.g. printing
  //                     which is a pass)
  // this method returns whether we are in passDebug mode, and which value:
  //  1: log out each pass that we run, and validate in between (can pass
  //     --no-validation to skip validation).
  //  2: like 1, and also save the last pass's output, so if breakage happens we
  //     can print a useful error. also logs out names of nested passes.
  //  3: like 1, and also dumps out byn-* files for each pass as it is run.
  static int getPassDebug();

  // Returns whether a pass by that name will remove debug info.
  static bool passRemovesDebugInfo(const std::string& name);

protected:
  virtual void doAdd(std::unique_ptr<Pass> pass);

private:
  // Whether this is a nested pass runner.
  bool isNested = false;

  // Whether the passes we have added so far to be run (but not necessarily run
  // yet) have removed DWARF.
  bool addedPassesRemovedDWARF = false;

  void runPass(Pass* pass);
  void runPassOnFunction(Pass* pass, Function* func);

  // After running a pass, handle any changes due to
  // how the pass is defined, such as clearing away any
  // temporary data structures that the pass declares it
  // invalidates.
  // If a function is passed, we operate just on that function;
  // otherwise, the whole module.
  void handleAfterEffects(Pass* pass, Function* func = nullptr);

  bool shouldPreserveDWARF();
};

//
// Core pass class
//
class Pass {
  PassRunner* runner = nullptr;
  friend PassRunner;

public:
  virtual ~Pass() = default;

  // Implement this with code to run the pass on the whole module
  virtual void run(Module* module) { WASM_UNREACHABLE("unimplemented"); }

  // Implement this with code to run the pass on a single function, for
  // a function-parallel pass
  virtual void runOnFunction(Module* module, Function* function) {
    WASM_UNREACHABLE("unimplemented");
  }

  // Function parallelism. By default, passes are not run in parallel, but you
  // can override this method to say that functions are parallelizable. This
  // should always be safe *unless* you do something in the pass that makes it
  // not thread-safe; in other words, the Module and Function objects and
  // so forth are set up so that Functions can be processed in parallel, so
  // if you do not add global state that could be raced on, your pass could be
  // function-parallel.
  //
  // Function-parallel passes create an instance of the Walker class per
  // function. That means that you can't rely on Walker object properties to
  // persist across your functions, and you can't expect a new object to be
  // created for each function either (which could be very inefficient).
  //
  // It is valid for function-parallel passes to read (but not modify) global
  // module state, like globals or imports. However, reading other functions'
  // contents is invalid, as function-parallel tests can be run while still
  // adding functions to the module.
  virtual bool isFunctionParallel() { return false; }

  // This method is used to create instances per function for a
  // function-parallel pass. You may need to override this if you subclass a
  // Walker, as otherwise this will create the parent class.
  virtual std::unique_ptr<Pass> create() { WASM_UNREACHABLE("unimplenented"); }

  // Whether this pass modifies the Binaryen IR in the module. This is true for
  // most passes, except for passes that have no side effects, or passes that
  // only modify other things than Binaryen IR (for example, the Stack IR
  // passes only modify that IR).
  // This property is important as if Binaryen IR is modified, we need to throw
  // out any Stack IR - it would need to be regenerated and optimized.
  virtual bool modifiesBinaryenIR() { return true; }

  // Some passes modify the wasm in a way that we cannot update DWARF properly
  // for. This is used to issue a proper warning about that.
  virtual bool invalidatesDWARF() { return false; }

  // Whether this pass modifies Binaryen IR in ways that may require fixups for
  // non-nullable locals to validate according to the wasm spec. If the pass
  // adds locals not in that form, or moves code around in ways that might break
  // that validation, this must return true. In that case the pass runner will
  // automatically run the necessary fixups afterwards.
  //
  // For more details see the LocalStructuralDominance class.
  virtual bool requiresNonNullableLocalFixups() { return true; }

  // Many passes can remove effects, for example, by finding some path is not
  // reached and removing a throw or a call there. The few passes that *add*
  // effects must mark themselves as such, so that we know to discard global
  // effects after running them. For example, a logging pass that adds new calls
  // to imports must override this to return true.
  virtual bool addsEffects() { return false; }

  void setPassArg(const std::string& value) { passArg = value; }

  std::string name;

  PassRunner* getPassRunner() { return runner; }
  void setPassRunner(PassRunner* runner_) {
    assert((!runner || runner == runner_) && "Pass already had a runner");
    runner = runner_;
  }

  PassOptions& getPassOptions() { return runner->options; }

protected:
  bool hasArgument(const std::string& key);
  std::string getArgument(const std::string& key,
                          const std::string& errorTextIfMissing);
  std::string getArgumentOrDefault(const std::string& key,
                                   const std::string& defaultValue);

  // The main argument of the pass, which can be specified individually for
  // every pass . getArgument() and friends will refer to this value if queried
  // for a key that matches the pass name. All other arguments are taken from
  // the runner / passOptions and therefore are global for all instances of a
  // pass.
  std::optional<std::string> passArg;

  Pass() = default;
  Pass(const Pass&) = default;
  Pass(Pass&&) = default;
  Pass& operator=(const Pass&) = delete;
};

//
// Core pass class that uses AST walking. This class can be parameterized by
// different types of AST walkers.
//
template<typename WalkerType>
class WalkerPass : public Pass, public WalkerType {

protected:
  using super = WalkerPass<WalkerType>;

public:
  void run(Module* module) override {
    assert(getPassRunner());
    // Parallel pass running is implemented in the PassRunner.
    if (isFunctionParallel()) {
      // Reduce opt/shrink levels to a maximum of one in nested runners like
      // these, to balance runtime. We definitely want the full levels in the
      // main passes we run, but nested pass runners are of secondary
      // importance.
      // TODO Investigate the impact of allowing the levels to just pass
      //      through. That seems to cause at least some regression in compile
      //      times in -O3, however, but with careful measurement we may find
      //      the benefits are worth it. For now -O1 is a reasonable compromise
      //      as it has basically linear runtime, unlike -O2 and -O3.
      auto options = getPassOptions();
      options.optimizeLevel = std::min(options.optimizeLevel, 1);
      options.shrinkLevel = std::min(options.shrinkLevel, 1);
      PassRunner runner(module, options);
      runner.setIsNested(true);
      runner.add(create());
      runner.run();
      return;
    }
    // Single-thread running just calls the walkModule traversal.
    WalkerType::walkModule(module);
  }

  // Utility for ad-hoc running.
  void run(PassRunner* runner, Module* module) {
    setPassRunner(runner);
    run(module);
  }

  void runOnFunction(Module* module, Function* func) override {
    assert(getPassRunner());
    WalkerType::walkFunctionInModule(func, module);
  }

  // Utility for ad-hoc running.
  void runOnFunction(PassRunner* runner, Module* module, Function* func) {
    setPassRunner(runner);
    runOnFunction(module, func);
  }

  void runOnModuleCode(PassRunner* runner, Module* module) {
    setPassRunner(runner);
    WalkerType::walkModuleCode(module);
  }
};

} // namespace wasm

#endif // wasm_pass_h
