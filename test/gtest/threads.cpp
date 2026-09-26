#include "support/threads.h"
#include "gtest/gtest.h"

#ifdef BINARYEN_PTHREAD_WORKERS

#include <pthread.h>

using namespace wasm;

namespace {

size_t getCurrentThreadStackSize() {
#ifdef __APPLE__
  return pthread_get_stacksize_np(pthread_self());
#else
  pthread_attr_t attr;
  if (pthread_getattr_np(pthread_self(), &attr) != 0) {
    return 0;
  }
  size_t size = 0;
  pthread_attr_getstacksize(&attr, &size);
  pthread_attr_destroy(&attr);
  return size;
#endif
}

} // anonymous namespace

TEST(ThreadsTest, WorkerStackSize) {
  auto* pool = ThreadPool::get();
  size_t numThreads = pool->size();
  if (numThreads == 1) {
    GTEST_SKIP() << "no worker threads";
  }
  std::vector<size_t> sizes(numThreads);
  std::vector<std::function<ThreadWorkState()>> workers;
  for (size_t i = 0; i < numThreads; i++) {
    workers.push_back([&sizes, i]() {
      sizes[i] = getCurrentThreadStackSize();
      return ThreadWorkState::Finished;
    });
  }
  pool->work(workers);
  size_t expected = getWorkerThreadStackSize();
  ASSERT_GT(expected, 0u);
  for (auto size : sizes) {
    EXPECT_GE(size, expected);
  }
}

#endif // BINARYEN_PTHREAD_WORKERS
