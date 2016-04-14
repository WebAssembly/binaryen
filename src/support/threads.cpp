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

#include <iostream>

#include "threads.h"


// debugging tools

#ifdef BINARYEN_THREAD_DEBUG
static std::mutex debug;
#define DEBUG_PRINT(x) { std::lock_guard<std::mutex> lock(debug); x; }
#else
#define DEBUG_PRINT(x)
#endif


namespace wasm {

// Global thread information

std::atomic_bool setMainThreadId(false);
std::thread::id mainThreadId;

struct MainThreadNoter {
  MainThreadNoter() {
    // global ctors are called on main thread
    mainThreadId = std::this_thread::get_id();
    setMainThreadId = true;
  }
};

static MainThreadNoter mainThreadNoter;

static std::unique_ptr<ThreadPool> pool;


// Thread

Thread::Thread() {
  // main thread object's constructor itself can
  // happen before onMainThread is ready
  assert(onMainThread());
  thread = std::unique_ptr<std::thread>(new std::thread(mainLoop, this));
}

Thread::~Thread() {
  assert(onMainThread());
  {
    std::lock_guard<std::mutex> lock(mutex);
    done = true;
    condition.notify_one();
  }
  thread->join();
}

void Thread::work(std::function<ThreadWorkState ()> doWork_) {
  // TODO: fancy work stealing
  DEBUG_PRINT(std::cerr << "[Thread] send work to thread\n");
  assert(onMainThread());
  {
    std::lock_guard<std::mutex> lock(mutex);
    doWork = doWork_;
    condition.notify_one();
    DEBUG_PRINT(std::cerr << "[Thread] work sent\n");
  }
}

bool Thread::onMainThread() {
  // mainThread Id might not be set yet if we are in a global ctor, but
  // that is on the main thread anyhow
  return !setMainThreadId || std::this_thread::get_id() == mainThreadId;
}

void Thread::mainLoop(void *self_) {
  auto* self = static_cast<Thread*>(self_);
  while (1) {
    DEBUG_PRINT(std::cerr << "[Thread] checking for work\n");
    {
      std::unique_lock<std::mutex> lock(self->mutex);
      if (self->doWork) {
        DEBUG_PRINT(std::cerr << "[Thread] doing work\n");
        // run tasks until they are all done
        while (self->doWork() == ThreadWorkState::More) {}
        self->doWork = nullptr;
      } else if (self->done) {
        DEBUG_PRINT(std::cerr << "[Thread] done\n");
        return;
      }
    }
    ThreadPool::get()->notifyThreadIsReady();
    {
      std::unique_lock<std::mutex> lock(self->mutex);
      if (!self->done && !self->doWork) {
        DEBUG_PRINT(std::cerr << "[Thread] thread waiting\n");
        self->condition.wait(lock);
      }
    }
  }
}


// ThreadPool

void ThreadPool::initialize(size_t num) {
  if (num == 1) return; // no multiple cores, don't create threads
  DEBUG_PRINT(std::cerr << "[Pool] initialize()\n");
  std::unique_lock<std::mutex> lock(mutex);
  ready.store(threads.size()); // initial state before first resetThreadsAreReady()
  resetThreadsAreReady();
  for (size_t i = 0; i < num; i++) {
    threads.emplace_back(std::unique_ptr<Thread>(new Thread()));
  }
  DEBUG_PRINT(std::cerr << "[Pool] initialize() waiting\n");
  condition.wait(lock, [this]() { return areThreadsReady(); });
  DEBUG_PRINT(std::cerr << "[Pool] initialize() is done\n");
}

ThreadPool* ThreadPool::get() {
  if (!pool) {
    assert(Thread::onMainThread());
    size_t num = std::thread::hardware_concurrency();
    if (num < 2) num = 1;
    pool = std::unique_ptr<ThreadPool>(new ThreadPool());
    pool->initialize(num);
  }
  return pool.get();
}

void ThreadPool::work(std::vector<std::function<ThreadWorkState ()>>& doWorkers) {
  size_t num = threads.size();
  // If no multiple cores, or on a side thread, do not use worker threads
  if (num == 0 || !Thread::onMainThread()) {
    // just run sequentially
    DEBUG_PRINT(std::cerr << "[Pool] work() sequentially\n");
    assert(doWorkers.size() > 0);
    while (doWorkers[0]() == ThreadWorkState::More) {}
    return;
  }
  // run in parallel on threads
  // TODO: fancy work stealing
  DEBUG_PRINT(std::cerr << "[Pool] work() on threads\n");
  assert(doWorkers.size() == num);
  assert(!running);
  running = true;
  std::unique_lock<std::mutex> lock(mutex);
  resetThreadsAreReady();
  for (size_t i = 0; i < num; i++) {
    threads[i]->work(doWorkers[i]);
  }
  DEBUG_PRINT(std::cerr << "[Pool] main thread waiting\n");
  condition.wait(lock, [this]() { return areThreadsReady(); });
  DEBUG_PRINT(std::cerr << "[Pool] main thread waiting\n");
  running = false;
  DEBUG_PRINT(std::cerr << "[Pool] work() is done\n");
}

size_t ThreadPool::size() {
  return threads.size();
}

bool ThreadPool::isRunning() {
  return pool && pool->running;
}

void ThreadPool::notifyThreadIsReady() {
  DEBUG_PRINT(std::cerr << "[Pool] notify thread is ready\n";)
  std::lock_guard<std::mutex> lock(mutex);
  ready.fetch_add(1);
  condition.notify_one();
}

void ThreadPool::resetThreadsAreReady() {
  DEBUG_PRINT(std::cerr << "[Pool] reset threads are ready\n";)
  assert(ready.load() == threads.size());
  ready.store(0);
}

bool ThreadPool::areThreadsReady() {
  DEBUG_PRINT(std::cerr << "[Pool] are threads ready?\n";)
  return ready.load() == threads.size();
}

} // namespace wasm

