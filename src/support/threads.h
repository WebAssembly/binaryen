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
#include <condition_variable>
#include <memory>
#include <mutex>
#include <thread>
#include <vector>

namespace wasm {

// The work state of a helper thread - is there more to do,
// or are we finished for now.
enum class ThreadWorkState {
  More,
  Finished
};

//
// A helper thread.
//
// You can only create and destroy these on the main thread.
//

class Thread {
  std::unique_ptr<std::thread> thread;
  std::mutex mutex;
  std::condition_variable condition;
  bool done = false;
  std::function<ThreadWorkState ()> doWork = nullptr;

public:
  Thread();
  ~Thread();

  // Start to do work, calling doWork() until
  // it returns false.
  void work(std::function<ThreadWorkState ()> doWork);

private:
  static void mainLoop(void *self);
};

//
// A pool of helper threads.
//
// There is only one, to avoid recursive pools using too many cores.
//

class ThreadPool {
  std::vector<std::unique_ptr<Thread>> threads;
  bool running = false;
  std::mutex mutex;
  std::condition_variable condition;
  std::atomic<size_t> ready;

private:
  void initialize(size_t num);

public:
  // Get the singleton threadpool. This can return null
  // if there is just one thread available.
  static ThreadPool* get();

  // Execute a bunch of tasks by the pool. This calls
  // getTask() (in a thread-safe manner) to get tasks, and
  // sends them to workers to be executed. This method
  // blocks until all tasks are complete.
  void work(std::vector<std::function<ThreadWorkState ()>>& doWorkers);

  size_t size();

  static bool isRunning();

  // Called by helper threads when they are free and ready.
  void notifyThreadIsReady();

private:
  void resetThreadsAreReady();

  bool areThreadsReady();
};

} // namespace wasm

#endif  // wasm_support_threads_h
