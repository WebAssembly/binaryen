/*
 * Copyright 2026 WebAssembly Community Group participants
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

#ifndef wasm_support_coroutine_h
#define wasm_support_coroutine_h

#include <coroutine>
#include <exception>

namespace wasm {

// A generator that yields T and receives U on resumption (if U is not
// void). The one-way generator (where U is void) provides the following
// methods:
//
//   bool next() - Resume the coroutine and return whether it can be resumed
//                 again.
//   T& get() - Return the current yielded value.
//
// The two-way generator (where U is not void) provides the following methods:
//

//   bool resume(U) - Resume the coroutine and return whether it can be resumed
//                    again.
//   T& get() - Return the current yielded value.
//
// TODO: Make the one-way generator into a forward iterator.
template<typename T, typename U = void> struct Generator;

// One-way generator
template<typename T> struct Generator<T, void> {
  struct promise_type {
    T current_value;

    Generator get_return_object() {
      return {std::coroutine_handle<promise_type>::from_promise(*this)};
    }
    std::suspend_always initial_suspend() { return {}; }
    std::suspend_always final_suspend() noexcept { return {}; }
    void unhandled_exception() { std::terminate(); }
    void return_void() {}

    std::suspend_always yield_value(T value) {
      current_value = std::move(value);
      return {};
    }
  };

  std::coroutine_handle<promise_type> handle;

  Generator(std::coroutine_handle<promise_type> h) : handle(h) {}
  Generator(const Generator&) = delete;
  Generator(Generator&& other) noexcept : handle(other.handle) {
    other.handle = nullptr;
  }
  ~Generator() {
    if (handle) {
      handle.destroy();
    }
  }

  bool next() {
    handle.resume();
    return !handle.done();
  }

  T& get() { return handle.promise().current_value; }
  const T& get() const { return handle.promise().current_value; }
};

// Two-way generator
template<typename T, typename U> struct Generator {
  struct promise_type {
    T current_value;
    U received_value;

    Generator get_return_object() {
      return {std::coroutine_handle<promise_type>::from_promise(*this)};
    }
    std::suspend_always initial_suspend() { return {}; }
    std::suspend_always final_suspend() noexcept { return {}; }
    void unhandled_exception() { std::terminate(); }
    void return_void() {}

    auto yield_value(T value) {
      current_value = std::move(value);
      return YieldAwaiter{this};
    }

    struct YieldAwaiter {
      promise_type* p;
      bool await_ready() const noexcept { return false; }
      void await_suspend(std::coroutine_handle<promise_type>) noexcept {}
      U await_resume() const noexcept { return p->received_value; }
    };
  };

  std::coroutine_handle<promise_type> handle;

  Generator(std::coroutine_handle<promise_type> h) : handle(h) {}
  Generator(const Generator&) = delete;
  Generator(Generator&& other) noexcept : handle(other.handle) {
    other.handle = nullptr;
  }
  ~Generator() {
    if (handle) {
      handle.destroy();
    }
  }

  bool resume(U value) {
    handle.promise().received_value = std::move(value);
    handle.resume();
    return !handle.done();
  }

  T& get() { return handle.promise().current_value; }
  const T& get() const { return handle.promise().current_value; }
};

} // namespace wasm

#endif // wasm_support_coroutine_h
