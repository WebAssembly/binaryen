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
// Pools repeated constants into immutable globals. A constant that is used
// multiple times can often be stored in a global, replacing the bytes of
// encoding the constant each time with the (usually smaller) bytes of a
// global.get. We only do this when the estimated binary size strictly
// decreases, so small constants (which are already very cheap) are left alone.
//
// WARNING: like const-hoisting, this shrinks raw size but can increase gzip
//          size, as removing repeated constants removes redundancy that
//          compressors use.
//

#include <cstring>
#include <map>
#include <string>

#include "ir/module-utils.h"
#include "pass.h"
#include "wasm-binary.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

// The types of constants we consider pooling. More types are possible, but
// these are the ones where pooling can typically pay off.
bool isPoolable(Type type) {
  return type == Type::i32 || type == Type::i64 || type == Type::f32 ||
         type == Type::f64 || type == Type::v128;
}

// The number of bytes an unsigned LEB128 takes.
Index sizeULEB(uint64_t value) {
  Index size = 1;
  while (value >= 0x80) {
    value >>= 7;
    size++;
  }
  return size;
}

template<typename T> Index getWrittenSize(const T& thing) {
  BufferWithRandomAccess buffer;
  buffer << thing;
  return buffer.size();
}

// The number of bytes a constant instruction takes in the binary, including
// the opcode.
Index getConstSize(const Literal& value) {
  auto type = value.type;
  if (type == Type::i32) {
    return 1 + getWrittenSize(S32LEB(value.geti32()));
  }
  if (type == Type::i64) {
    return 1 + getWrittenSize(S64LEB(value.geti64()));
  }
  if (type == Type::f32) {
    return 1 + 4;
  }
  if (type == Type::f64) {
    return 1 + 8;
  }
  assert(type == Type::v128);
  // v128.const has a two-byte prefixed opcode (0xfd 0x0c), unlike the other
  // constant instructions, followed by the 16 bytes of the value.
  return 2 + 16;
}

// A deterministic key for a constant: the basic type and the raw bits. We
// cannot use Literal directly as its comparison depends on Type IDs, which are
// not stable between runs.
struct PoolKey {
  Type::BasicType type;
  uint8_t bits[16];

  bool operator<(const PoolKey& other) const {
    if (type != other.type) {
      return type < other.type;
    }
    return memcmp(bits, other.bits, 16) < 0;
  }
};

struct ConstantPooling : public Pass {
  // We add globals, but do not change any of the locals in the module.
  bool requiresNonNullableLocalFixups() override { return false; }

  void run(Module* module) override {
    using Ptrs = std::vector<Expression**>;

    // Scan all the function bodies. We cannot handle constants in const-
    // expression positions (global initializers, segment offsets, etc.), as
    // those cannot contain a global.get (of a non-imported global), so we only
    // walk function bodies.
    struct Scanner : public PostWalker<Scanner> {
      Ptrs& ptrs;

      Scanner(Ptrs& ptrs) : ptrs(ptrs) {}

      void visitConst(Const* curr) {
        if (isPoolable(curr->type)) {
          ptrs.push_back(getCurrentPointer());
        }
      }
    };

    ModuleUtils::ParallelFunctionAnalysis<Ptrs> analysis(
      *module, [&](Function* func, Ptrs& ptrs) {
        if (!func->imported()) {
          Scanner(ptrs).walk(func->body);
        }
      });

    // Group the constants by their value.
    std::map<PoolKey, Ptrs> groups;
    for (auto& [func, ptrs] : analysis.map) {
      for (auto** ptr : ptrs) {
        auto* curr = (*ptr)->cast<Const>();
        PoolKey key;
        key.type = curr->type.getBasic();
        curr->value.getBits(key.bits);
        groups[key].push_back(ptr);
      }
    }

    // Decide which constants to pool. A pooled constant adds one global
    // (whose entry encodes the constant plus overhead) and replaces each use
    // with a global.get.
    Index existingGlobals = module->globals.size();
    auto globalGetSize = [&](Index index) { return 1 + sizeULEB(index); };

    struct ToPool {
      Const* value;
      Ptrs* ptrs;
      Name name;
    };
    std::vector<ToPool> toPool;

    // The index a pooled global will get. We do not know that for sure, but we
    // compute a conservative bound: if there will be more than 128 globals
    // then some may need two bytes to encode, so assume that.
    Index numGlobals = existingGlobals + groups.size();
    Index getSize = globalGetSize(numGlobals > 0 ? numGlobals - 1 : 0);

    // If the module has no globals at all, we must also pay for the global
    // section itself when we add the first one.
    bool firstPooled = true;

    for (auto& [key, ptrs] : groups) {
      auto* value = (*ptrs[0])->cast<Const>();
      Index constSize = getConstSize(value->value);
      Index count = ptrs.size();
      // This is only valid if the global.get is smaller than the constant.
      if (constSize <= getSize) {
        continue;
      }
      int64_t savings =
        int64_t(count) * (constSize - getSize) - (constSize + 3);
      if (existingGlobals == 0 && firstPooled) {
        savings -= 3;
      }
      if (savings > 0) {
        toPool.push_back({value, &ptrs, Name()});
        firstPooled = false;
      }
    }

    if (toPool.empty()) {
      return;
    }

    // Create the globals, then replace the uses.
    Builder builder(*module);
    Index counter = 0;
    for (auto& entry : toPool) {
      Name name;
      while (true) {
        name = std::string("const$") + std::to_string(counter++);
        if (!module->getGlobalOrNull(name)) {
          break;
        }
      }
      entry.name = name;
      auto global = builder.makeGlobal(
        name, entry.value->type, entry.value, Builder::Immutable);
      module->addGlobal(std::move(global));
    }

    for (auto& entry : toPool) {
      for (auto** ptr : *entry.ptrs) {
        *ptr = builder.makeGlobalGet(entry.name, entry.value->type);
      }
    }
  }
};

} // anonymous namespace

Pass* createConstantPoolingPass() { return new ConstantPooling(); }

} // namespace wasm
