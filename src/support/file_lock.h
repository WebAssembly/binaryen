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

//
// RAII file lock for cross-process synchronization.
//

#ifndef wasm_support_file_lock_h
#define wasm_support_file_lock_h

#include <string>

#ifndef _WIN32
#include <fcntl.h>
#include <sys/file.h>
#include <unistd.h>
#endif

namespace wasm {

struct FileLock {
#ifndef _WIN32
  int fd = -1;
  FileLock(const std::string& path) {
    fd = open(path.c_str(), O_RDWR | O_CREAT, 0666);
    if (fd >= 0) {
      flock(fd, LOCK_EX);
    }
  }
  ~FileLock() {
    if (fd >= 0) {
      flock(fd, LOCK_UN);
      close(fd);
    }
  }
#else
  FileLock(const std::string&) {}
#endif

  FileLock(const FileLock&) = delete;
  FileLock& operator=(const FileLock&) = delete;
};

} // namespace wasm

#endif // wasm_support_file_lock_h
