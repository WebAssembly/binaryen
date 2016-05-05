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

#include "support/archive.h"

#include <cstring>
#include "support/utilities.h"

static const char* const magic = "!<arch>\n";

class ArchiveMemberHeader {
 public:
  uint8_t fileName[16];
  uint8_t timestamp[12];
  uint8_t UID[6];
  uint8_t GID[6];
  uint8_t accessMode[8];
  uint8_t size[10];  // Size of data only, not including padding or header
  uint8_t magic[2];

  std::string getName() const;
  // Members are not larger than 4GB
  uint32_t getSize() const;
};

std::string ArchiveMemberHeader::getName() const {
  char endChar;
  if (fileName[0] == '/') {
    // Special name (string table or reference, or symbol table)
    endChar = ' ';
  } else {
    endChar = '/';  // regular name
  }
  auto* end =
      static_cast<const uint8_t*>(memchr(fileName, endChar, sizeof(fileName)));
  if (!end) end = fileName + sizeof(fileName);
  return std::string((char*)(fileName), end - fileName);
}

uint32_t ArchiveMemberHeader::getSize() const {
  auto* end = static_cast<const char*>(memchr(size, ' ', sizeof(size)));
  std::string sizeString((const char*)size, end);
  auto sizeInt = std::stoll(sizeString, nullptr, 10);
  if (sizeInt < 0 || sizeInt >= std::numeric_limits<uint32_t>::max()) {
    wasm::Fatal() << "Malformed archive: size parsing failed\n";
  }
  return static_cast<uint32_t>(sizeInt);
}

Archive::Archive(Buffer& b, bool& error) : data(b) {
  error = false;
  if (data.size() < strlen(magic) ||
      memcmp(data.data(), magic, strlen(magic))) {
    error = true;
    return;
  }

  // We require GNU format archives. So the first member may be named "/" and it
  // points to the symbol table.  The next member may optionally be "//" and
  // point to a string table if a filename is too large to fit in the 16-char
  // name field of the header.
  child_iterator it = child_begin(false);
  if (it.hasError()) {
    error = true;
    return;
  }
  child_iterator end = child_end();
  if (it == end) return;  // Empty archive.

  const Child* c = &*it;

  auto increment = [&]() {
    ++it;
    error = it.hasError();
    if (error) return true;
    c = &*it;
    return false;
  };

  std::string name = c->getRawName();
  if (name == "/") {
    symbolTable = c->getBuffer();
    if (increment() || it == end) return;
    name = c->getRawName();
  }

  if (name == "//") {
    stringTable = c->getBuffer();
    if (increment() || it == end) return;
    setFirstRegular(*c);
    return;
  }
  if (name[0] != '/') {
    setFirstRegular(*c);
    return;
  }
  // Not a GNU archive.
  error = true;
}

Archive::Child::Child(const Archive* parent, const uint8_t* data, bool* error)
    : parent(parent), data(data) {
  if (!data) return;
  len = sizeof(ArchiveMemberHeader) + getHeader()->getSize();
  startOfFile = sizeof(ArchiveMemberHeader);
}

uint32_t Archive::Child::getSize() const { return len - startOfFile; }

Archive::SubBuffer Archive::Child::getBuffer() const {
  return {data + startOfFile, getSize()};
}

std::string Archive::Child::getRawName() const {
  return getHeader()->getName();
}

Archive::Child Archive::Child::getNext(bool& error) const {
  size_t toSkip = len;
  // Members are aligned to even byte boundaries.
  if (toSkip & 1) ++toSkip;
  const uint8_t* nextLoc = data + toSkip;
  if (nextLoc >= (uint8_t*)&*parent->data.end()) {  // End of the archive.
    return Child();
  }

  return Child(parent, nextLoc, &error);
}

std::string Archive::Child::getName() const {
  std::string name = getRawName();
  // Check if it's a special name.
  if (name[0] == '/') {
    if (name.size() == 1) {  // Linker member.
      return name;
    }
    if (name.size() == 2 && name[1] == '/') {  // String table.
      return name;
    }
    // It's a long name.
    // Get the offset.
    int offset = std::stoi(name.substr(1), nullptr, 10);

    // Verify it.
    if (offset < 0 || (unsigned)offset >= parent->stringTable.len) {
      wasm::Fatal() << "Malformed archive: name parsing failed\n";
    }

    std::string addr(parent->stringTable.data + offset,
                     parent->stringTable.data + parent->stringTable.len);

    // GNU long file names end with a "/\n".
    size_t end = addr.find('\n');
    return addr.substr(0, end - 1);
  }
  // It's a simple name.
  if (name[name.size() - 1] == '/') {
    return name.substr(0, name.size() - 1);
  }
  return name;
}

Archive::child_iterator Archive::child_begin(bool SkipInternal) const {
  if (data.size() == 0) return child_end();

  if (SkipInternal) {
    child_iterator it;
    it.child = Child(this, firstRegularData, &it.error);
    return it;
  }

  auto* loc = (const uint8_t*)data.data() + strlen(magic);
  child_iterator it;
  it.child = Child(this, loc, &it.error);
  return it;
}

Archive::child_iterator Archive::child_end() const { return Child(); }

namespace {
struct Symbol {
  uint32_t symbolIndex;
  uint32_t stringIndex;
  void next(Archive::SubBuffer& symbolTable) {
    // Symbol table entries are NUL-terminated. Skip past the next NUL.
    stringIndex = strchr((char*)symbolTable.data + stringIndex, '\0') -
                  (char*)symbolTable.data + 1;
    ++symbolIndex;
  }
};
}

static uint32_t read32be(const uint8_t* buf) {
  return static_cast<uint32_t>(buf[0]) << 24 |
         static_cast<uint32_t>(buf[1]) << 16 |
         static_cast<uint32_t>(buf[2]) << 8 | static_cast<uint32_t>(buf[3]);
}

void Archive::dump() const {
  printf("Archive data %p len %zu, firstRegularData %p\n", data.data(),
         data.size(), firstRegularData);
  printf("Symbol table %p, len %u\n", symbolTable.data, symbolTable.len);
  printf("string table %p, len %u\n", stringTable.data, stringTable.len);
  const uint8_t* buf = symbolTable.data;
  if (!buf) {
    for (auto c = child_begin(), e = child_end(); c != e; ++c) {
      printf("Child %p, len %u, name %s, size %u\n", c->data, c->len,
             c->getName().c_str(), c->getSize());
    }
    return;
  }
  uint32_t symbolCount = read32be(buf);
  printf("Symbol count %u\n", symbolCount);
  buf += sizeof(uint32_t) + (symbolCount * sizeof(uint32_t));
  uint32_t string_start_offset = buf - symbolTable.data;
  Symbol sym = {0, string_start_offset};
  while (sym.symbolIndex != symbolCount) {
    printf("Symbol %u, offset %u\n", sym.symbolIndex, sym.stringIndex);
    // get the member
    uint32_t offset = read32be(symbolTable.data + sym.symbolIndex * 4);
    auto* loc = (const uint8_t*)&data[offset];
    child_iterator it;
    it.child = Child(this, loc, &it.error);
    printf("Child %p, len %u\n", it.child.data, it.child.len);
  }
}
