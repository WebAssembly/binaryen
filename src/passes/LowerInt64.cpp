/*
 * Copyright 2015 WebAssembly Community Group participants
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
// Lowers 64-bit ints to pairs of 32-bit ints, plus some library routines
//
// This is useful for wasm2asm, as JS has no native 64-bit integer support.
//

#include <memory>

#include <wasm.h>
#include <pass.h>

namespace wasm {

cashew::IString GET_HIGH("getHigh");

struct LowerInt64 : public Pass {
  MixedArena* allocator;
  std::unique_ptr<NameManager> namer;

  void prepare(PassRunner* runner, Module *module) override {
    allocator = runner->allocator;
    namer = std::unique_ptr<NameManager>(new NameManager());
    namer->run(runner, module);
  }

  std::map<Expression*, Expression*> fixes; // fixed nodes, outputs of lowering, mapped to their high bits
  std::map<Name, Name> locals; // maps locals which were i64->i32 to their high bits

  void makeGetHigh() {
    auto ret = allocator->alloc<CallImport>();
    ret->target = GET_HIGH;
    ret->type = i32;
    return ret;
  }

  void fixCall(CallBase *call) {
    auto& operands = call->operands;
    for (size_t i = 0; i < operands.size(); i++) {
      auto fix = fixes.find(operands[i]);
      if (fix != fixes.end()) {
        operands.insert(operands.begin() + i + 1, *fix);
      }
    }
    if (curr->type == i64) {
      curr->type = i32;
      fixes[curr] = makeGetHigh(); // called function will setHigh
    }
  }

  void visitCall(Call *curr) {
    fixCall(curr);
  }
  void visitCallImport(CallImport *curr) {
    fixCall(curr);
  }
  void visitCallIndirect(CallIndirect *curr) {
    fixCall(curr);
  }
  void visitGetLocal(GetLocal *curr) {
    if (curr->type == i64) {
      if (locals.count(curr->name) == 0) {
        Name highName = namer->getUnique("high");
        locals[curr->name] = highName;
      };
      curr->type = i32;
      auto high = allocator->alloc<GetLocal>();
      high->name = locals[curr->name];
      high->type = i32;
      fixes[curr] = high;
    }
  }
  void visitSetLocal(SetLocal *curr) {
    if (curr->type == i64) {
      Name highName;
      if (locals.count(curr->name) == 0) {
        highName = namer->getUnique("high");
        locals[curr->name] = highName;
      } else {
        highName = locals[curr->name];
      }
      curr->type = i32;
      auto high = allocator->alloc<GetLocal>();
      high->name = highName;
      high->type = i32;
      fixes[curr] = high;
      // Set the high bits
      auto set = allocator.alloc<SetLocal>();
      set->name = highName;
      set->value = fixes[curr->value];
      set->type = i32;
      assert(set->value);
      auto low = allocator->alloc<GetLocal>();
      low->name = curr->name;
      low->type = i32;
      auto ret = allocator.alloc<Block>();
      ret->list.push_back(curr);
      ret->list.push_back(set);
      ret->list.push_back(low); // so the block returns the low bits
      ret->finalize();
      fixes[ret] = high;
      replaceCurrent(ret);
    }
  }

  // sets an expression to a local, and returns a block
  Block* setToLocalForBlock(Expression *value, Name& local, Block *ret = nullptr) {
    if (!ret) ret = allocator->alloc<Block>();
    if (value->is<GetLocal>()) {
      local = value->name;
    } else if (value->is<SetLocal>()) {
      local = value->name;
    } else {
      auto set = allocator.alloc<SetLocal>();
      set->name = local = namer->getUnique("temp");
      set->value = value;
      set->type = value->type;
      ret->list.push_back(set);
    }
    ret->finalize();
    return ret;
  }

  GetLocal* getLocal(Name name) {
    auto ret = allocator->alloc<GetLocal>();
    ret->name = name;
    ret->type = i32;
    return ret;
  }

  void visitLoad(Load *curr) {
    if (curr->type == i64) {
      Name local;
      auto ret = setToLocalForBlock(curr->ptr, local);
      curr->ptr = getLocal(local);
      curr->type = i32;
      curr->bytes = 4;
      auto high = allocator->alloc<Load>();
      *high = *curr;
      high->ptr = getLocal(local);
      high->offset += 4;
      ret->list.push_back(curr);
      fixes[ret] = high;
      replaceCurrent(ret);
    }
  }
  void visitStore(Store *curr) {
    if (curr->type == i64) {
      Name localPtr, localValue;
      auto ret = setToLocalForBlock(curr->ptr, localPtr);
      setToLocalForBlock(curr->value, localValue);
      curr->ptr = getLocal(localPtr);
      curr->value = getLocal(localValue);
      curr->type = i32;
      curr->bytes = 4;
      auto high = allocator->alloc<Load>();
      *high = *curr;
      high->ptr = getLocal(localPtr);
      high->value = getLocal(localValue);
      high->offset += 4;
      ret->list.push_back(high);
      ret->list.push_back(curr);
      fixes[ret] = high;
      replaceCurrent(ret);
    }
  }
  void visitFunction(Function *curr) {
    // TODO: new params
    for (auto localPair : locals) { // TODO: ignore params
      curr->locals.emplace_back(localPair.second, i32);
    }
    fixes.clear();
    locals.clear();
  }
};

static RegisterPass<LowerInt64> registerPass("lower-i64", "lowers i64 into pairs of i32s");

} // namespace wasm
