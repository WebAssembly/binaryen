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

#include <chrono>
#include <sstream>

#include "support/colors.h"
#include "passes/passes.h"
#include "pass.h"
#include "wasm-validator.h"
#include "wasm-io.h"
#include "ir/hashed.h"
#include "ir/module-utils.h"

namespace wasm {

// PassRegistry

PassRegistry::PassRegistry() {
  registerPasses();
}

static PassRegistry singleton;

PassRegistry* PassRegistry::get() {
  return &singleton;
}

void PassRegistry::registerPass(const char* name, const char *description, Creator create) {
  assert(passInfos.find(name) == passInfos.end());
  passInfos[name] = PassInfo(description, create);
}

Pass* PassRegistry::createPass(std::string name) {
  if (passInfos.find(name) == passInfos.end()) return nullptr;
  auto ret = passInfos[name].create();
  ret->name = name;
  return ret;
}

std::vector<std::string> PassRegistry::getRegisteredNames() {
  std::vector<std::string> ret;
  for (auto pair : passInfos) {
    ret.push_back(pair.first);
  }
  return ret;
}

std::string PassRegistry::getPassDescription(std::string name) {
  assert(passInfos.find(name) != passInfos.end());
  return passInfos[name].description;
}

// PassRunner

void PassRegistry::registerPasses() {
  registerPass("dae", "removes arguments to calls in an lto-like manner", createDAEPass);
  registerPass("dae-optimizing", "removes arguments to calls in an lto-like manner, and optimizes where we removed", createDAEOptimizingPass);
  registerPass("coalesce-locals", "reduce # of locals by coalescing", createCoalesceLocalsPass);
  registerPass("coalesce-locals-learning", "reduce # of locals by coalescing and learning", createCoalesceLocalsWithLearningPass);
  registerPass("code-pushing", "push code forward, potentially making it not always execute", createCodePushingPass);
  registerPass("code-folding", "fold code, merging duplicates", createCodeFoldingPass);
  registerPass("const-hoisting", "hoist repeated constants to a local", createConstHoistingPass);
  registerPass("dce", "removes unreachable code", createDeadCodeEliminationPass);
  registerPass("dfo", "optimizes using the DataFlow SSA IR", createDataFlowOptsPass);
  registerPass("duplicate-function-elimination", "removes duplicate functions", createDuplicateFunctionEliminationPass);
  registerPass("extract-function", "leaves just one function (useful for debugging)", createExtractFunctionPass);
  registerPass("flatten", "flattens out code, removing nesting", createFlattenPass);
  registerPass("fpcast-emu", "emulates function pointer casts, allowing incorrect indirect calls to (sometimes) work", createFuncCastEmulationPass);
  registerPass("func-metrics", "reports function metrics", createFunctionMetricsPass);
  registerPass("generate-stack-ir", "generate Stack IR", createGenerateStackIRPass);
  registerPass("inlining", "inline functions (you probably want inlining-optimizing)", createInliningPass);
  registerPass("inlining-optimizing", "inline functions and optimizes where we inlined", createInliningOptimizingPass);
  registerPass("legalize-js-interface", "legalizes i64 types on the import/export boundary", createLegalizeJSInterfacePass);
  registerPass("local-cse", "common subexpression elimination inside basic blocks", createLocalCSEPass);
  registerPass("log-execution", "instrument the build with logging of where execution goes", createLogExecutionPass);
  registerPass("i64-to-i32-lowering", "lower all uses of i64s to use i32s instead", createI64ToI32LoweringPass);
  registerPass("instrument-locals", "instrument the build with code to intercept all loads and stores", createInstrumentLocalsPass);
  registerPass("instrument-memory", "instrument the build with code to intercept all loads and stores", createInstrumentMemoryPass);
  registerPass("licm", "loop invariant code motion", createLoopInvariantCodeMotionPass);
  registerPass("memory-packing", "packs memory into separate segments, skipping zeros", createMemoryPackingPass);
  registerPass("merge-blocks", "merges blocks to their parents", createMergeBlocksPass);
  registerPass("merge-locals", "merges locals when beneficial", createMergeLocalsPass);
  registerPass("metrics", "reports metrics", createMetricsPass);
  registerPass("minify-imports", "minifies import names (only those, and not export names), and emits a mapping to the minified ones", createMinifyImportsPass);
  registerPass("minify-imports-and-exports", "minifies both import and export names, and emits a mapping to the minified ones", createMinifyImportsAndExportsPass);
  registerPass("nm", "name list", createNameListPass);
  registerPass("optimize-instructions", "optimizes instruction combinations", createOptimizeInstructionsPass);
  registerPass("optimize-stack-ir", "optimize Stack IR", createOptimizeStackIRPass);
  registerPass("pick-load-signs", "pick load signs based on their uses", createPickLoadSignsPass);
  registerPass("post-emscripten", "miscellaneous optimizations for Emscripten-generated code", createPostEmscriptenPass);
  registerPass("precompute", "computes compile-time evaluatable expressions", createPrecomputePass);
  registerPass("precompute-propagate", "computes compile-time evaluatable expressions and propagates them through locals", createPrecomputePropagatePass);
  registerPass("print", "print in s-expression format", createPrinterPass);
  registerPass("print-minified", "print in minified s-expression format", createMinifiedPrinterPass);
  registerPass("print-full", "print in full s-expression format", createFullPrinterPass);
  registerPass("print-call-graph", "print call graph", createPrintCallGraphPass);
  registerPass("print-stack-ir", "print out Stack IR (useful for internal debugging)", createPrintStackIRPass);
  registerPass("relooper-jump-threading", "thread relooper jumps (fastcomp output only)", createRelooperJumpThreadingPass);
  registerPass("remove-non-js-ops", "removes operations incompatible with js", createRemoveNonJSOpsPass);
  registerPass("remove-imports", "removes imports and replaces them with nops", createRemoveImportsPass);
  registerPass("remove-memory", "removes memory segments", createRemoveMemoryPass);
  registerPass("remove-unused-brs", "removes breaks from locations that are not needed", createRemoveUnusedBrsPass);
  registerPass("remove-unused-module-elements", "removes unused module elements", createRemoveUnusedModuleElementsPass);
  registerPass("remove-unused-nonfunction-module-elements", "removes unused module elements that are not functions", createRemoveUnusedNonFunctionModuleElementsPass);
  registerPass("remove-unused-names", "removes names from locations that are never branched to", createRemoveUnusedNamesPass);
  registerPass("reorder-functions", "sorts functions by access frequency", createReorderFunctionsPass);
  registerPass("reorder-locals", "sorts locals by access frequency", createReorderLocalsPass);
  registerPass("rereloop", "re-optimize control flow using the relooper algorithm", createReReloopPass);
  registerPass("rse", "remove redundant set_locals", createRedundantSetEliminationPass);
  registerPass("safe-heap", "instrument loads and stores to check for invalid behavior", createSafeHeapPass);
  registerPass("simplify-locals", "miscellaneous locals-related optimizations", createSimplifyLocalsPass);
  registerPass("simplify-locals-nonesting", "miscellaneous locals-related optimizations (no nesting at all; preserves flatness)", createSimplifyLocalsNoNestingPass);
  registerPass("simplify-locals-notee", "miscellaneous locals-related optimizations (no tees)", createSimplifyLocalsNoTeePass);
  registerPass("simplify-locals-nostructure", "miscellaneous locals-related optimizations (no structure)", createSimplifyLocalsNoStructurePass);
  registerPass("simplify-locals-notee-nostructure", "miscellaneous locals-related optimizations (no tees or structure)", createSimplifyLocalsNoTeeNoStructurePass);
  registerPass("souperify", "emit Souper IR in text form", createSouperifyPass);
  registerPass("souperify-single-use", "emit Souper IR in text form (single-use nodes only)", createSouperifySingleUsePass);
  registerPass("spill-pointers", "spill pointers to the C stack (useful for Boehm-style GC)", createSpillPointersPass);
  registerPass("ssa", "ssa-ify variables so that they have a single assignment", createSSAifyPass);
  registerPass("trap-mode-clamp", "replace trapping operations with clamping semantics", createTrapModeClamp);
  registerPass("trap-mode-js", "replace trapping operations with js semantics", createTrapModeJS);
  registerPass("untee", "removes tee_locals, replacing them with sets and gets", createUnteePass);
  registerPass("vacuum", "removes obviously unneeded code", createVacuumPass);
//  registerPass("lower-i64", "lowers i64 into pairs of i32s", createLowerInt64Pass);
}

void PassRunner::addDefaultOptimizationPasses() {
  addDefaultGlobalOptimizationPrePasses();
  addDefaultFunctionOptimizationPasses();
  addDefaultGlobalOptimizationPostPasses();
}

void PassRunner::addDefaultFunctionOptimizationPasses() {
  // if we are willing to work very very hard, flatten the IR and do opts
  // that depend on flat IR
  if (options.optimizeLevel >= 4) {
    add("flatten");
    add("local-cse");
  }
  if (!options.debugInfo) { // debug info must be preserved, do not dce it
    add("dce");
  }
  add("remove-unused-brs");
  add("remove-unused-names");
  add("optimize-instructions");
  if (options.optimizeLevel >= 2 || options.shrinkLevel >= 2) {
    add("pick-load-signs");
  }
  // early propagation
  if (options.optimizeLevel >= 3 || options.shrinkLevel >= 2) {
    add("precompute-propagate");
  } else {
    add("precompute");
  }
  if (options.optimizeLevel >= 2 || options.shrinkLevel >= 2) {
    add("code-pushing");
  }
  add("simplify-locals-nostructure"); // don't create if/block return values yet, as coalesce can remove copies that that could inhibit
  add("vacuum"); // previous pass creates garbage
  add("reorder-locals");
  add("remove-unused-brs"); // simplify-locals opens opportunities for optimizations
  // if we are willing to work hard, also optimize copies before coalescing
  if (options.optimizeLevel >= 3 || options.shrinkLevel >= 2) {
    add("merge-locals"); // very slow on e.g. sqlite
  }
  add("coalesce-locals");
  add("simplify-locals");
  add("vacuum"); // previous pass creates garbage
  add("reorder-locals");
  if (options.optimizeLevel >= 3 || options.shrinkLevel >= 1) {
    add("code-folding");
  }
  add("merge-blocks"); // makes remove-unused-brs more effective
  add("remove-unused-brs"); // coalesce-locals opens opportunities
  add("remove-unused-names"); // remove-unused-brs opens opportunities
  add("merge-blocks"); // clean up remove-unused-brs new blocks
  add("optimize-instructions");
  // late propagation
  if (options.optimizeLevel >= 3 || options.shrinkLevel >= 2) {
    add("precompute-propagate");
  } else {
    add("precompute");
  }
  if (options.optimizeLevel >= 2 || options.shrinkLevel >= 1) {
    add("rse"); // after all coalesce-locals, and before a final vacuum
  }
  add("vacuum"); // just to be safe
}

void PassRunner::addDefaultGlobalOptimizationPrePasses() {
  add("duplicate-function-elimination");
}

void PassRunner::addDefaultGlobalOptimizationPostPasses() {
  if (options.optimizeLevel >= 2 || options.shrinkLevel >= 1) {
    add("dae-optimizing");
  }
  // inline when working hard, and when not preserving debug info
  // (inlining+optimizing can remove the annotations)
  if ((options.optimizeLevel >= 2 || options.shrinkLevel >= 2) &&
      !options.debugInfo) {
    add("inlining-optimizing");
  }
  add("duplicate-function-elimination"); // optimizations show more functions as duplicate
  add("remove-unused-module-elements");
  add("memory-packing");
  // perform Stack IR optimizations here, at the very end of the
  // optimization pipeline
  if (options.optimizeLevel >= 2 || options.shrinkLevel >= 1) {
    add("generate-stack-ir");
    add("optimize-stack-ir");
  }
}

static void dumpWast(Name name, Module* wasm) {
  // write out the wast
  static int counter = 0;
  std::string numstr = std::to_string(counter++);
  while (numstr.size() < 3) {
    numstr = '0' + numstr;
  }
  auto fullName = std::string("byn-") + numstr + "-" + name.str + ".wasm";
  Colors::disable();
  ModuleWriter writer;
  writer.setBinary(false); // TODO: add an option for binary
  writer.write(*wasm, fullName);
}

void PassRunner::run() {
  static const int passDebug = getPassDebug();
  if (!isNested && (options.debug || passDebug)) {
    // for debug logging purposes, run each pass in full before running the other
    auto totalTime = std::chrono::duration<double>(0);
    size_t padding = 0;
    WasmValidator::Flags validationFlags = WasmValidator::Minimal;
    if (options.validateGlobally) {
      validationFlags = validationFlags | WasmValidator::Globally;
    }
    std::cerr << "[PassRunner] running passes..." << std::endl;
    for (auto pass : passes) {
      padding = std::max(padding, pass->name.size());
    }
    if (passDebug >= 3) {
      dumpWast("before", wasm);
    }
    for (auto* pass : passes) {
      // ignoring the time, save a printout of the module before, in case this pass breaks it, so we can print the before and after
      std::stringstream moduleBefore;
      if (passDebug == 2) {
        WasmPrinter::printModule(wasm, moduleBefore);
      }
      // prepare to run
      std::cerr << "[PassRunner]   running pass: " << pass->name << "... ";
      for (size_t i = 0; i < padding - pass->name.size(); i++) {
        std::cerr << ' ';
      }
      auto before = std::chrono::steady_clock::now();
      if (pass->isFunctionParallel()) {
        // function-parallel passes should get a new instance per function
        ModuleUtils::iterDefinedFunctions(*wasm, [&](Function* func) {
          runPassOnFunction(pass, func);
        });
      } else {
        runPass(pass);
      }
      auto after = std::chrono::steady_clock::now();
      std::chrono::duration<double> diff = after - before;
      std::cerr << diff.count() << " seconds." << std::endl;
      totalTime += diff;
      // validate, ignoring the time
      std::cerr << "[PassRunner]   (validating)\n";
      if (!WasmValidator().validate(*wasm, options.features, validationFlags)) {
        WasmPrinter::printModule(wasm);
        if (passDebug >= 2) {
          std::cerr << "Last pass (" << pass->name << ") broke validation. Here is the module before: \n" << moduleBefore.str() << "\n";
        } else {
          std::cerr << "Last pass (" << pass->name << ") broke validation. Run with BINARYEN_PASS_DEBUG=2 in the env to see the earlier state, or 3 to dump byn-* files for each pass\n";
        }
        abort();
      }
      if (passDebug >= 3) {
        dumpWast(pass->name, wasm);
      }
    }
    std::cerr << "[PassRunner] passes took " << totalTime.count() << " seconds." << std::endl;
    // validate
    std::cerr << "[PassRunner] (final validation)\n";
    if (!WasmValidator().validate(*wasm, options.features, validationFlags)) {
      WasmPrinter::printModule(wasm);
      std::cerr << "final module does not validate\n";
      abort();
    }
  } else {
    // non-debug normal mode, run them in an optimal manner - for locality it is better
    // to run as many passes as possible on a single function before moving to the next
    std::vector<Pass*> stack;
    auto flush = [&]() {
      if (stack.size() > 0) {
        // run the stack of passes on all the functions, in parallel
        size_t num = ThreadPool::get()->size();
        std::vector<std::function<ThreadWorkState ()>> doWorkers;
        std::atomic<size_t> nextFunction;
        nextFunction.store(0);
        size_t numFunctions = wasm->functions.size();
        for (size_t i = 0; i < num; i++) {
          doWorkers.push_back([&]() {
            auto index = nextFunction.fetch_add(1);
            // get the next task, if there is one
            if (index >= numFunctions) {
              return ThreadWorkState::Finished; // nothing left
            }
            Function* func = this->wasm->functions[index].get();
            if (!func->imported()) {
              // do the current task: run all passes on this function
              for (auto* pass : stack) {
                runPassOnFunction(pass, func);
              }
            }
            if (index + 1 == numFunctions) {
              return ThreadWorkState::Finished; // we did the last one
            }
            return ThreadWorkState::More;
          });
        }
        ThreadPool::get()->work(doWorkers);
      }
      stack.clear();
    };
    for (auto* pass : passes) {
      if (pass->isFunctionParallel()) {
        stack.push_back(pass);
      } else {
        flush();
        runPass(pass);
      }
    }
    flush();
  }
}

void PassRunner::runOnFunction(Function* func) {
  if (options.debug) {
    std::cerr << "[PassRunner] running passes on function " << func->name << std::endl;
  }
  for (auto* pass : passes) {
    runPassOnFunction(pass, func);
  }
}

PassRunner::~PassRunner() {
  for (auto pass : passes) {
    delete pass;
  }
}

void PassRunner::doAdd(Pass* pass) {
  passes.push_back(pass);
  pass->prepareToRun(this, wasm);
}

// Checks that the state is valid before and after a
// pass runs on a function. We run these extra checks when
// pass-debug mode is enabled.
struct AfterEffectFunctionChecker {
  Function* func;
  Name name;

  // Check Stack IR state: if the main IR changes, there should be no
  // stack IR, as the stack IR would be wrong.
  bool beganWithStackIR;
  HashType originalFunctionHash;

  // In the creator we can scan the state of the module and function before the
  // pass runs.
  AfterEffectFunctionChecker(Function* func) : func(func), name(func->name) {
    beganWithStackIR = func->stackIR != nullptr;
    if (beganWithStackIR) {
      originalFunctionHash = FunctionHasher::hashFunction(func);
    }
  }

  // This is called after the pass is run, at which time we can check things.
  void check() {
    assert(func->name == name); // no global module changes should have occurred
    if (beganWithStackIR && func->stackIR) {
      auto after = FunctionHasher::hashFunction(func);
      if (after != originalFunctionHash) {
        Fatal() << "[PassRunner] PASS_DEBUG check failed: had Stack IR before and after the pass ran, and the pass modified the main IR, which invalidates Stack IR - pass should have been marked 'modifiesBinaryenIR'";
      }
    }
  }
};

// Runs checks on the entire module, in a non-function-parallel pass.
// In particular, in such a pass functions may be removed or renamed, track that.
struct AfterEffectModuleChecker {
  Module* module;

  std::vector<AfterEffectFunctionChecker> checkers;

  bool beganWithAnyStackIR;

  AfterEffectModuleChecker(Module* module) : module(module) {
    for (auto& func : module->functions) {
      checkers.emplace_back(func.get());
    }
    beganWithAnyStackIR = hasAnyStackIR();
  }

  void check() {
    if (beganWithAnyStackIR && hasAnyStackIR()) {
      // If anything changed to the functions, that's not good.
      if (checkers.size() != module->functions.size()) {
        error();
      }
      for (Index i = 0; i < checkers.size(); i++) {
        // Did a pointer change? (a deallocated function could cause that)
        if (module->functions[i].get() != checkers[i].func ||
            module->functions[i]->body != checkers[i].func->body) {
          error();
        }
        // Did a name change?
        if (module->functions[i]->name != checkers[i].name) {
          error();
        }
      }
      // Global function state appears to not have been changed: the same
      // functions are there. Look into their contents.
      for (auto& checker : checkers) {
        checker.check();
      }
    }
  }

  void error() {
    Fatal() << "[PassRunner] PASS_DEBUG check failed: had Stack IR before and after the pass ran, and the pass modified global function state - pass should have been marked 'modifiesBinaryenIR'";
  }

  bool hasAnyStackIR() {
    for (auto& func : module->functions) {
      if (func->stackIR) {
        return true;
      }
    }
    return false;
  }
};

void PassRunner::runPass(Pass* pass) {
  std::unique_ptr<AfterEffectModuleChecker> checker;
  if (getPassDebug()) {
    checker = std::unique_ptr<AfterEffectModuleChecker>(
      new AfterEffectModuleChecker(wasm));
  }
  pass->run(this, wasm);
  handleAfterEffects(pass);
  if (getPassDebug()) {
    checker->check();
  }
}

void PassRunner::runPassOnFunction(Pass* pass, Function* func) {
  assert(pass->isFunctionParallel());
  // function-parallel passes get a new instance per function
  auto instance = std::unique_ptr<Pass>(pass->create());
  std::unique_ptr<AfterEffectFunctionChecker> checker;
  if (getPassDebug()) {
    checker = std::unique_ptr<AfterEffectFunctionChecker>(
      new AfterEffectFunctionChecker(func));
  }
  instance->runOnFunction(this, wasm, func);
  handleAfterEffects(pass, func);
  if (getPassDebug()) {
    checker->check();
  }
}

void PassRunner::handleAfterEffects(Pass* pass, Function* func) {
  if (pass->modifiesBinaryenIR()) {
    // If Binaryen IR is modified, Stack IR must be cleared - it would
    // be out of sync in a potentially dangerous way.
    if (func) {
      func->stackIR.reset(nullptr);
    } else {
      for (auto& func : wasm->functions) {
        func->stackIR.reset(nullptr);
      }
    }
  }
}

int PassRunner::getPassDebug() {
  static const int passDebug = getenv("BINARYEN_PASS_DEBUG") ? atoi(getenv("BINARYEN_PASS_DEBUG")) : 0;
  return passDebug;
}

} // namespace wasm
