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
// Threads helpers.
//

#ifndef wasm_support_threads_h
#define wasm_support_threads_h

#include <atomic>
#include <cassert>
#include <condition_variable>
#include <functional>
#include <memory>
#include <mutex>
#include <thread>
#include <vector>

#include "compiler-support.h"

namespace wasm {

// The work state of a helper thread - is there more to do,
// or are we finished for now.
enum class ThreadWorkState { More, Finished };

class ThreadPool;

//
// A helper thread.
//
// You can only create and destroy these on the main thread.
//

class Thread {
  ThreadPool* parent;
  std::unique_ptr<std::thread> thread;
  std::mutex mutex;
  std::condition_variable condition;
  bool done = false;
  std::function<ThreadWorkState()> doWork = nullptr;

public:
  Thread(ThreadPool* parent);
  ~Thread();

  // Start to do work, calling doWork() until
  // it returns false.
  void work(std::function<ThreadWorkState()> doWork);

private:
  static void mainLoop(void* self);
};

//
// A pool of helper threads.
//
// There is only one, to avoid recursive pools using too many cores.
//

class ThreadPool {
  std::vector<std::unique_ptr<Thread>> threads;
  bool running = false;
  std::condition_variable condition;
  std::atomic<size_t> ready;

  // A mutex for creating the pool safely
  static std::mutex creationMutex;
  // A mutex for work() so that the pool can only work on one
  // thing at a time
  static std::mutex workMutex;
  // A mutex for communication with the worker threads
  static std::mutex threadMutex;

private:
  void initialize(size_t num);

public:
  // Get the number of cores we can use.
  static size_t getNumCores();

  // Get the singleton threadpool.
  static ThreadPool* get();

  // Execute a bunch of tasks by the pool. This calls
  // getTask() (in a thread-safe manner) to get tasks, and
  // sends them to workers to be executed. This method
  // blocks until all tasks are complete.
  void work(std::vector<std::function<ThreadWorkState()>>& doWorkers);

  size_t size();

  bool isRunning();

  // Called by helper threads when they are free and ready.
  void notifyThreadIsReady();

private:
  void resetThreadsAreReady();

  bool areThreadsReady();
};

// Verify a code segment is only entered once. Usage:
//    static OnlyOnce onlyOnce;
//    onlyOnce.verify();

class OnlyOnce {
  std::atomic<int> created;

public:
  OnlyOnce() { created.store(0); }

  void verify() {
    [[maybe_unused]] auto before = created.fetch_add(1);
    assert(before == 0);
  }
};

} // namespace wasm

#endif // wasm_support_threads_h
