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

#ifndef wasm_wasm_module_building_h
#define wasm_wasm_module_building_h

#include "pass.h"
#include <support/threads.h>
#include <wasm.h>

namespace wasm {

#ifdef BINARYEN_THREAD_DEBUG
static std::mutex debug;
#define DEBUG_THREAD(x)                                                        \
  {                                                                            \
    std::lock_guard<std::mutex> lock(debug);                                   \
    std::cerr << "[OptimizingIncrementalModuleBuilder Threading (thread: "     \
              << std::this_thread::get_id() << ")] " << x;                     \
    std::cerr << '\n';                                                         \
  }
#else
#define DEBUG_THREAD(x)
#endif

//
// OptimizingIncrementalModuleBuilder
//
// Helps build wasm modules efficiently. If you build a module by
// adding function by function, and you want to optimize them, this class
// starts optimizing using worker threads *while you are still adding*.
// It runs function optimization passes at that time. This does not
// run global optimization after that by default, but you can do that
// to by calling optimizeGlobally(), which runs the the global post-passes
// (we can't run the pre-passes, as they must be run before function
// passes, and no such time is possible here given that we receive
// functions one by one and optimize them).
//
// This might also be faster than normal module optimization since it
// runs all passes on each function, then goes on to the next function
// which is better for data locality.
//
// Usage: Create an instance, passing it the module and the total
//        number of functions. Then call addFunction as you have
//        new functions to add (this also adds it to the module). Finally,
//        call finish() when all functions have been added.
//
// This avoids locking by using atomics. We allocate an array of nullptrs
// that represent all the functions, and as we add a function, we place it
// at the next index. Each worker will read from the start to the end,
// and when a non-nullptr is found, the worker optimizes that function and
// nulls it. There is also an end marker that is not nullptr nor the address of
// a valid function, which represents that beyond this point we have not
// yet filled in. In other words,
//    * the main thread fills everything with the end marker
//    * the main thread transforms a marker entry into a function
//    * workers pause when they see the marker
//    * workers skip over nullptrs
//    * workers transform functions into nullptrs, and optimize them
//    * we keep an atomic count of the number of active workers and
//      the number of optimized functions.
//    * after adding a function, the main thread notifys up workers if
//      it calculates there is work for them.
//    * a lock is used for going to sleep and waking up.
// Locking should be rare, as optimization is
// generally slower than generation; in the optimal case, we never
// lock beyond the first step, and all further work is lock-free.
//
// N.B.: Optimizing functions in parallel with adding functions is possible,
//       but the rest of the global state of the module should be fixed,
//       such as globals, imports, etc. Function-parallel optimization passes
//       may read (but not modify) those fields.

class OptimizingIncrementalModuleBuilder {
  Module* wasm;
  uint32_t numFunctions;
  PassOptions passOptions;
  std::function<void(PassRunner&)> addPrePasses;
  Function* endMarker;
  std::atomic<Function*>* list;
  uint32_t nextFunction; // only used on main thread
  uint32_t numWorkers;
  std::vector<std::unique_ptr<std::thread>> threads;
  std::atomic<uint32_t> liveWorkers, activeWorkers, availableFuncs,
    finishedFuncs;
  std::mutex mutex;
  std::condition_variable condition;
  bool finishing;
  bool debug;
  bool validateGlobally;

public:
  // numFunctions must be equal to the number of functions allocated, or higher.
  // Knowing this bounds helps avoid locking.
  OptimizingIncrementalModuleBuilder(
    Module* wasm,
    Index numFunctions,
    PassOptions passOptions,
    std::function<void(PassRunner&)> addPrePasses,
    bool debug,
    bool validateGlobally)
    : wasm(wasm), numFunctions(numFunctions), passOptions(passOptions),
      addPrePasses(addPrePasses), endMarker(nullptr), list(nullptr),
      nextFunction(0), numWorkers(0), liveWorkers(0), activeWorkers(0),
      availableFuncs(0), finishedFuncs(0), finishing(false), debug(debug),
      validateGlobally(validateGlobally) {

    if (!useWorkers()) {
      // if we shouldn't use threads, don't
      return;
    }

    // prepare work list
    endMarker = new Function();
    list = new std::atomic<Function*>[numFunctions];
    for (uint32_t i = 0; i < numFunctions; i++) {
      list[i].store(endMarker);
    }
    // create workers
    DEBUG_THREAD("creating workers");
    numWorkers = ThreadPool::getNumCores();
    assert(numWorkers >= 1);
    // worth it to use threads
    liveWorkers.store(0);
    activeWorkers.store(0);
    // TODO: one less, and add it at the very end, to not compete with main
    // thread?
    for (uint32_t i = 0; i < numWorkers; i++) {
      createWorker();
    }
    waitUntilAllReady();
    DEBUG_THREAD("workers are ready");
    // prepare the rest of the initial state
    availableFuncs.store(0);
    finishedFuncs.store(0);
  }

  ~OptimizingIncrementalModuleBuilder() {
    delete[] list;
    delete endMarker;
  }

  bool useWorkers() {
    return numFunctions > 0 && !debug && ThreadPool::getNumCores() > 1 &&
           !PassRunner::getPassDebug();
  }

  // Add a function to the module, and to be optimized
  void addFunction(Function* func) {
    wasm->addFunction(func);
    if (!useWorkers()) {
      return; // we optimize at the end in that case
    }
    queueFunction(func);
    // notify workers if needed
    auto notify = availableFuncs.load();
    for (uint32_t i = 0; i < notify; i++) {
      notifyWorker();
    }
  }

  // All functions have been added, block until all are optimized, and then do
  // global optimizations. When this returns, the module is ready and optimized.
  void finish() {
    if (!useWorkers()) {
      // optimize each function now that we are done adding functions,
      // then optimize globally
      PassRunner passRunner(wasm, passOptions);
      if (debug) {
        passRunner.setDebug(true);
        passRunner.setValidateGlobally(validateGlobally);
      }
      addPrePasses(passRunner);
      passRunner.addDefaultFunctionOptimizationPasses();
      passRunner.run();
    } else {
      DEBUG_THREAD("finish()ing");
      assert(nextFunction == numFunctions);
      notifyAllWorkers();
      waitUntilAllFinished();
    }
    // TODO: clear side thread allocators from module allocator, as these
    // threads were transient
  }

private:
  void createWorker() {
    DEBUG_THREAD("create a worker");
    threads.emplace_back(std::make_unique<std::thread>(workerMain, this));
  }

  void notifyWorker() {
    DEBUG_THREAD("notify a worker");
    std::lock_guard<std::mutex> lock(mutex);
    condition.notify_one();
  }

  void notifyAllWorkers() {
    DEBUG_THREAD("notify all workers");
    std::lock_guard<std::mutex> lock(mutex);
    condition.notify_all();
  }

  void waitUntilAllReady() {
    DEBUG_THREAD("wait until all workers are ready");
    std::unique_lock<std::mutex> lock(mutex);
    if (liveWorkers.load() < numWorkers) {
      condition.wait(lock,
                     [this]() { return liveWorkers.load() == numWorkers; });
    }
  }

  void waitUntilAllFinished() {
    DEBUG_THREAD("wait until all workers are finished");
    {
      std::unique_lock<std::mutex> lock(mutex);
      finishing = true;
      if (liveWorkers.load() > 0) {
        condition.wait(lock, [this]() { return liveWorkers.load() == 0; });
      }
    }
    DEBUG_THREAD("joining");
    for (auto& thread : threads) {
      thread->join();
    }
    DEBUG_THREAD("joined");
  }

  void queueFunction(Function* func) {
    DEBUG_THREAD("queue function");
    // TODO: if we are given more than we expected, use a slower work queue?
    assert(nextFunction < numFunctions);
    list[nextFunction++].store(func);
    availableFuncs++;
  }

  void optimizeGlobally() {
    PassRunner passRunner(wasm, passOptions);
    passRunner.addDefaultGlobalOptimizationPostPasses();
    passRunner.run();
  }

  // worker code

  void optimizeFunction(Function* func) {
    PassRunner passRunner(wasm, passOptions);
    addPrePasses(passRunner);
    passRunner.addDefaultFunctionOptimizationPasses();
    passRunner.runOnFunction(func);
  }

  static void workerMain(OptimizingIncrementalModuleBuilder* self) {
    DEBUG_THREAD("workerMain");
    {
      std::lock_guard<std::mutex> lock(self->mutex);
      self->liveWorkers++;
      self->activeWorkers++;
      self->condition.notify_all();
    }
    for (uint32_t i = 0; i < self->numFunctions; i++) {
      DEBUG_THREAD("workerMain iteration " << i);
      if (self->list[i].load() == self->endMarker) {
        // sleep, this entry isn't ready yet
        DEBUG_THREAD("workerMain sleep");
        self->activeWorkers--;
        {
          std::unique_lock<std::mutex> lock(self->mutex);
          // while waiting for the lock, things may have ended
          if (!self->finishing) {
            self->condition.wait(lock);
          }
        }
        // continue
        DEBUG_THREAD("workerMain continue");
        self->activeWorkers++;
        i--;
        continue;
      }
      DEBUG_THREAD("workerMain exchange item");
      auto* func = self->list[i].exchange(nullptr);
      if (func == nullptr) {
        DEBUG_THREAD("workerMain sees was already taken");
        continue; // someone else has taken this one
      }
      // we have work to do!
      DEBUG_THREAD("workerMain work on " << size_t(func));
      self->availableFuncs--;
      self->optimizeFunction(func);
      self->finishedFuncs++;
    }
    DEBUG_THREAD("workerMain ready to exit");
    {
      std::lock_guard<std::mutex> lock(self->mutex);
      self->liveWorkers--;
      self->condition.notify_all();
    }
    DEBUG_THREAD("workerMain exiting");
  }
};

} // namespace wasm

#endif // wasm_wasm_module_building_h
