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

#include <assert.h>

#include <algorithm>
#include <iostream>
#include <string>

#include "threads.h"
#include "compiler-support.h"
#include "utilities.h"


// debugging tools

#ifdef BINARYEN_THREAD_DEBUG
static std::mutex debug;
#define DEBUG_THREAD(x) { std::lock_guard<std::mutex> lock(debug); std::cerr << "[THREAD " << std::this_thread::get_id() << "] " << x; }
#define DEBUG_POOL(x)   { std::lock_guard<std::mutex> lock(debug); std::cerr << "[POOL "   << std::this_thread::get_id() << "] " << x; }
#else
#define DEBUG_THREAD(x)
#define DEBUG_POOL(x)
#endif


namespace wasm {

// Thread

Thread::Thread(ThreadPool* parent) : parent(parent) {
  assert(!parent->isRunning());
  thread = make_unique<std::thread>(mainLoop, this);
}

Thread::~Thread() {
  {
    std::lock_guard<std::mutex> lock(mutex);
    // notify the thread that it can exit
    done = true;
    condition.notify_one();
  }
  thread->join();
}

void Thread::work(std::function<ThreadWorkState ()> doWork_) {
  // TODO: fancy work stealing
  DEBUG_THREAD("send work to thread\n");
  {
    std::lock_guard<std::mutex> lock(mutex);
    // notify the thread that it can do some work
    doWork = doWork_;
    condition.notify_one();
    DEBUG_THREAD("work sent\n");
  }
}

void Thread::mainLoop(void *self_) {
  auto* self = static_cast<Thread*>(self_);
  while (1) {
    DEBUG_THREAD("checking for work\n");
    {
      std::unique_lock<std::mutex> lock(self->mutex);
      if (self->doWork) {
        DEBUG_THREAD("doing work\n");
        // run tasks until they are all done
        while (self->doWork() == ThreadWorkState::More) {}
        self->doWork = nullptr;
      } else if (self->done) {
        DEBUG_THREAD("done\n");
        return;
      }
    }
    self->parent->notifyThreadIsReady();
    {
      std::unique_lock<std::mutex> lock(self->mutex);
      if (!self->done && !self->doWork) {
        DEBUG_THREAD("thread waiting\n");
        self->condition.wait(lock);
      }
    }
  }
}

// ThreadPool

// Global threadPool state. We have a singleton pool, which can only be
// used from one place at a time.

static std::unique_ptr<ThreadPool> pool;

std::mutex ThreadPool::creationMutex;
std::mutex ThreadPool::workMutex;
std::mutex ThreadPool::threadMutex;

void ThreadPool::initialize(size_t num) {
  if (num == 1) return; // no multiple cores, don't create threads
  DEBUG_POOL("initialize()\n");
  std::unique_lock<std::mutex> lock(threadMutex);
  ready.store(threads.size()); // initial state before first resetThreadsAreReady()
  resetThreadsAreReady();
  for (size_t i = 0; i < num; i++) {
    try {
      threads.emplace_back(make_unique<Thread>(this));
    } catch (std::system_error&) {
      // failed to create a thread - don't use multithreading, as if num cores == 1
      DEBUG_POOL("could not create thread\n");
      threads.clear();
      return;
    }
  }
  DEBUG_POOL("initialize() waiting\n");
  condition.wait(lock, [this]() { return areThreadsReady(); });
  DEBUG_POOL("initialize() is done\n");
}

size_t ThreadPool::getNumCores() {
#ifdef __EMSCRIPTEN__
  return 1;
#else
  size_t num = std::max(1U, std::thread::hardware_concurrency());
  if (getenv("BINARYEN_CORES")) {
    num = std::stoi(getenv("BINARYEN_CORES"));
  }
  return num;
#endif
}

ThreadPool* ThreadPool::get() {
  DEBUG_POOL("::get()\n");
  // lock on the creation
  std::lock_guard<std::mutex> poolLock(creationMutex);
  if (!pool) {
    DEBUG_POOL("::get() creating\n");
    std::unique_ptr<ThreadPool> temp = make_unique<ThreadPool>();
    temp->initialize(getNumCores());
    // assign it to the global location now that it is all ready
    pool.swap(temp);
    DEBUG_POOL("::get() created\n");
  }
  return pool.get();
}

void ThreadPool::work(std::vector<std::function<ThreadWorkState ()>>& doWorkers) {
  size_t num = threads.size();
  // If no multiple cores, or on a side thread, do not use worker threads
  if (num == 0) {
    // just run sequentially
    DEBUG_POOL("work() sequentially\n");
    assert(doWorkers.size() > 0);
    while (doWorkers[0]() == ThreadWorkState::More) {}
    return;
  }
  // run in parallel on threads
  // TODO: fancy work stealing
  DEBUG_POOL("work() on threads\n");
  // lock globally on doing work in the pool - the threadPool can only be used
  // from one thread at a time, all others must wait patiently
  std::lock_guard<std::mutex> poolLock(workMutex);
  assert(doWorkers.size() == num);
  assert(!running);
  DEBUG_POOL("running = true\n");
  running = true;
  std::unique_lock<std::mutex> lock(threadMutex);
  resetThreadsAreReady();
  for (size_t i = 0; i < num; i++) {
    threads[i]->work(doWorkers[i]);
  }
  DEBUG_POOL("main thread waiting\n");
  condition.wait(lock, [this]() { return areThreadsReady(); });
  DEBUG_POOL("main thread done waiting\n");
  DEBUG_POOL("running = false\n");
  running = false;
  DEBUG_POOL("work() is done\n");
}

size_t ThreadPool::size() {
  return std::max(size_t(1), threads.size());
}

bool ThreadPool::isRunning() {
  DEBUG_POOL("check if running\n");
  return running;
}

void ThreadPool::notifyThreadIsReady() {
  DEBUG_POOL("notify thread is ready\n";)
  std::lock_guard<std::mutex> lock(threadMutex);
  ready.fetch_add(1);
  condition.notify_one();
}

void ThreadPool::resetThreadsAreReady() {
  DEBUG_POOL("reset threads are ready\n";)
  auto old = ready.exchange(0);
  WASM_UNUSED(old);
  assert(old == threads.size());
}

bool ThreadPool::areThreadsReady() {
  DEBUG_POOL("are threads ready?\n";)
  return ready.load() == threads.size();
}

} // namespace wasm

