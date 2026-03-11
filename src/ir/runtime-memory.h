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

#ifndef wasm_ir_runtime_memory_h
#define wasm_ir_runtime_memory_h

#include "wasm.h"

namespace wasm {

class RuntimeMemory {
public:
  // Forward declare to avoid circular dependency
  struct ExternalInterface {
    virtual ~ExternalInterface() = default;
    virtual void trap(std::string_view why) = 0;
  };

  RuntimeMemory(Memory memory, ExternalInterface* externalInterface);
  virtual ~RuntimeMemory() = default;

  virtual Literal load(Address addr,
                       Address offset,
                       uint8_t byteCount,
                       MemoryOrder order,
                       Type type,
                       bool signed_) const = 0;

  virtual void store(Address addr,
                     Address offset,
                     uint8_t byteCount,
                     MemoryOrder order,
                     Literal value,
                     Type type) = 0;

  virtual bool grow(Address delta) = 0;

  virtual Address size() const = 0;

  virtual void
  init(Address dest, Address src, Address byteCount, const DataSegment* data) = 0;

  virtual void
  copy(Address dest, Address src, Address byteCount, const RuntimeMemory* srcMemory) = 0;

  virtual void fill(Address dest, uint8_t value, Address byteCount) = 0;

  const Memory* getDefinition() const { return &memoryDefinition; }

  virtual const std::vector<uint8_t>* getBuffer() const { return nullptr; }

  void trap(std::string_view why) const { externalInterface->trap(why); }

protected:
  ExternalInterface* externalInterface;
  const Memory memoryDefinition;
};

class RealRuntimeMemory : public RuntimeMemory {
public:
  RealRuntimeMemory(Memory memory, ExternalInterface* externalInterface);
  virtual ~RealRuntimeMemory() = default;

  Literal load(Address addr,
               Address offset,
               uint8_t byteCount,
               MemoryOrder order,
               Type type,
               bool signed_) const override;

  void store(Address addr,
             Address offset,
             uint8_t byteCount,
             MemoryOrder order,
             Literal value,
             Type type) override;

  bool grow(Address delta) override;

  Address size() const override;

  void
  init(Address dest, Address src, Address byteCount, const DataSegment* data) override;

  void
  copy(Address dest, Address src, Address byteCount, const RuntimeMemory* srcMemory) override;

  void fill(Address dest, uint8_t value, Address byteCount) override;

  void resize(size_t newSize);

  template<typename T> T get(size_t address) const;
  template<typename T> void set(size_t address, T value);

  const std::vector<uint8_t>* getBuffer() const override { return &memory; }
  std::vector<uint8_t>& getBuffer() { return memory; }

protected:
  std::vector<uint8_t> memory;
  Address intendedSize = 0;
};

} // namespace wasm

#endif // wasm_ir_runtime_memory_h
