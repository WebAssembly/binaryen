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

/* Minimal class for interacting with archives. The API is inspired by LLVM's
 * Archive class, (in case we want to switch to using that at some point);
 * however we are missing useful error-handling capabilities and other utilities
 * that LLVM has (e.g. ErrorOr, MemoryBuffer, StringRef).
 * We only support the GNU format (not the BSD or COFF variants)
 */

#ifndef wasm_support_archive_h
#define wasm_support_archive_h

#include <cstdint>
#include <vector>

#include "wasm.h"

class ArchiveMemberHeader;

class Archive {
  // Vector is char instead of uint8_t because read_file only works with char.
  // Everything else is uint8_t to help distinguish between uses as
  // uninterpreted bytes (most uses) and C strings (a few uses e.g. strchr)
  // because most things in these buffers are not nul-terminated
  using Buffer = std::vector<char>;

 public:
  struct SubBuffer {
    const uint8_t* data;
    uint32_t len;
  };
  class Child {
    friend class Archive;
    const Archive* parent = nullptr;
    // Includes header but not padding byte.
    const uint8_t* data = nullptr;
    uint32_t len = 0;
    // Offset from data to the start of the file
    uint16_t startOfFile = 0;
    const ArchiveMemberHeader* getHeader() const {
      return reinterpret_cast<const ArchiveMemberHeader*>(data);
    }
    Child getNext(bool& error) const;

   public:
    Child(){};
    Child(const Archive* parent, const uint8_t* data, bool* error);
    // Size of actual member data (no header/padding)
    uint32_t getSize() const;
    SubBuffer getBuffer() const;
    std::string getRawName() const;
    std::string getName() const;
    bool operator==(const Child& other) const { return data == other.data; }
  };
  class child_iterator {
    friend class Archive;
    Child child;
    bool error = false;  // TODO: use std::error_code instead?
   public:
    child_iterator() {}
    explicit child_iterator(bool error) : error(error) {}
    child_iterator(const Child& c) : child(c) {}
    const Child* operator->() const { return &child; }
    const Child& operator*() const { return child; }
    bool operator==(const child_iterator& other) const {
      return child == other.child;
    }
    bool operator!=(const child_iterator& other) const {
      return !(*this == other);
    }
    child_iterator& operator++() {
      assert(!error);
      child = child.getNext(error);
      return *this;
    }
    bool hasError() const { return error; }
  };
  Archive(Buffer& buffer, bool& error);
  child_iterator child_begin(bool SkipInternal = true) const;
  child_iterator child_end() const;
  void dump() const;

 private:
  void setFirstRegular(const Child& c) { firstRegularData = c.data; }
  Buffer& data;
  SubBuffer symbolTable = {nullptr, 0};
  SubBuffer stringTable = {nullptr, 0};
  const uint8_t* firstRegularData;
};

#endif  // wasm_support_archive_h
