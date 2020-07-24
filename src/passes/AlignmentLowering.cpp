/*
 * Copyright 2017 WebAssembly Community Group participants
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
// Lowers unaligned loads and stores into aligned loads and stores
// that are smaller. This leaves only aligned operations.
//

#include "ir/bits.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

struct AlignmentLowering : public WalkerPass<PostWalker<AlignmentLowering>> {
  // Core lowering of a 32-bit load. Other loads are done using this.
  Expression* lowerLoadI32(Load* curr) {
    if (curr->align == 0 || curr->align == curr->bytes) {
      return curr;
    }
    Builder builder(*getModule());
    assert(curr->type == Type::i32);
    auto temp = builder.addVar(getFunction(), Type::i32);
    Expression* ret;
    if (curr->bytes == 2) {
      ret = builder.makeBinary(
        OrInt32,
        builder.makeLoad(1,
                         false,
                         curr->offset,
                         1,
                         builder.makeLocalGet(temp, Type::i32),
                         Type::i32),
        builder.makeBinary(
          ShlInt32,
          builder.makeLoad(1,
                           false,
                           curr->offset + 1,
                           1,
                           builder.makeLocalGet(temp, Type::i32),
                           Type::i32),
          builder.makeConst(int32_t(8))));
      if (curr->signed_) {
        ret = Bits::makeSignExt(ret, 2, *getModule());
      }
    } else if (curr->bytes == 4) {
      if (curr->align == 1) {
        ret = builder.makeBinary(
          OrInt32,
          builder.makeBinary(
            OrInt32,
            builder.makeLoad(1,
                             false,
                             curr->offset,
                             1,
                             builder.makeLocalGet(temp, Type::i32),
                             Type::i32),
            builder.makeBinary(
              ShlInt32,
              builder.makeLoad(1,
                               false,
                               curr->offset + 1,
                               1,
                               builder.makeLocalGet(temp, Type::i32),
                               Type::i32),
              builder.makeConst(int32_t(8)))),
          builder.makeBinary(
            OrInt32,
            builder.makeBinary(
              ShlInt32,
              builder.makeLoad(1,
                               false,
                               curr->offset + 2,
                               1,
                               builder.makeLocalGet(temp, Type::i32),
                               Type::i32),
              builder.makeConst(int32_t(16))),
            builder.makeBinary(
              ShlInt32,
              builder.makeLoad(1,
                               false,
                               curr->offset + 3,
                               1,
                               builder.makeLocalGet(temp, Type::i32),
                               Type::i32),
              builder.makeConst(int32_t(24)))));
      } else if (curr->align == 2) {
        ret = builder.makeBinary(
          OrInt32,
          builder.makeLoad(2,
                           false,
                           curr->offset,
                           2,
                           builder.makeLocalGet(temp, Type::i32),
                           Type::i32),
          builder.makeBinary(
            ShlInt32,
            builder.makeLoad(2,
                             false,
                             curr->offset + 2,
                             2,
                             builder.makeLocalGet(temp, Type::i32),
                             Type::i32),
            builder.makeConst(int32_t(16))));
      } else {
        WASM_UNREACHABLE("invalid alignment");
      }
    } else {
      WASM_UNREACHABLE("invalid size");
    }
    return
      builder.makeBlock({builder.makeLocalSet(temp, curr->ptr), ret});
  }

  // Core lowering of a 32-bit store. Other storess are done using this.
  Expression* lowerStoreI32(Store* curr) {
    if (curr->align == 0 || curr->align == curr->bytes) {
      return curr;
    }
    Builder builder(*getModule());
    assert(curr->value->type == Type::i32);
    auto tempPtr = builder.addVar(getFunction(), Type::i32);
    auto tempValue = builder.addVar(getFunction(), Type::i32);
    auto* block =
      builder.makeBlock({builder.makeLocalSet(tempPtr, curr->ptr),
                         builder.makeLocalSet(tempValue, curr->value)});
    if (curr->bytes == 2) {
      block->list.push_back(
        builder.makeStore(1,
                          curr->offset,
                          1,
                          builder.makeLocalGet(tempPtr, Type::i32),
                          builder.makeLocalGet(tempValue, Type::i32),
                          Type::i32));
      block->list.push_back(builder.makeStore(
        1,
        curr->offset + 1,
        1,
        builder.makeLocalGet(tempPtr, Type::i32),
        builder.makeBinary(ShrUInt32,
                           builder.makeLocalGet(tempValue, Type::i32),
                           builder.makeConst(int32_t(8))),
        Type::i32));
    } else if (curr->bytes == 4) {
      if (curr->align == 1) {
        block->list.push_back(
          builder.makeStore(1,
                            curr->offset,
                            1,
                            builder.makeLocalGet(tempPtr, Type::i32),
                            builder.makeLocalGet(tempValue, Type::i32),
                            Type::i32));
        block->list.push_back(builder.makeStore(
          1,
          curr->offset + 1,
          1,
          builder.makeLocalGet(tempPtr, Type::i32),
          builder.makeBinary(ShrUInt32,
                             builder.makeLocalGet(tempValue, Type::i32),
                             builder.makeConst(int32_t(8))),
          Type::i32));
        block->list.push_back(builder.makeStore(
          1,
          curr->offset + 2,
          1,
          builder.makeLocalGet(tempPtr, Type::i32),
          builder.makeBinary(ShrUInt32,
                             builder.makeLocalGet(tempValue, Type::i32),
                             builder.makeConst(int32_t(16))),
          Type::i32));
        block->list.push_back(builder.makeStore(
          1,
          curr->offset + 3,
          1,
          builder.makeLocalGet(tempPtr, Type::i32),
          builder.makeBinary(ShrUInt32,
                             builder.makeLocalGet(tempValue, Type::i32),
                             builder.makeConst(int32_t(24))),
          Type::i32));
      } else if (curr->align == 2) {
        block->list.push_back(
          builder.makeStore(2,
                            curr->offset,
                            2,
                            builder.makeLocalGet(tempPtr, Type::i32),
                            builder.makeLocalGet(tempValue, Type::i32),
                            Type::i32));
        block->list.push_back(builder.makeStore(
          2,
          curr->offset + 2,
          2,
          builder.makeLocalGet(tempPtr, Type::i32),
          builder.makeBinary(ShrUInt32,
                             builder.makeLocalGet(tempValue, Type::i32),
                             builder.makeConst(int32_t(16))),
          Type::i32));
      } else {
        WASM_UNREACHABLE("invalid alignment");
      }
    } else {
      WASM_UNREACHABLE("invalid size");
    }
    block->finalize();
    return block;
  }

  void visitLoad(Load* curr) {
    // If unreachable, just remove the load, which removes the unaligned
    // operation in a trivial way.
    if (curr->type == Type::unreachable) {
      replaceCurrent(curr->ptr);
      return;
    }
    if (curr->align != 0 && curr->align != curr->bytes) {
      replaceCurrent(lowerLoadI32(curr));
    }
  }

  void visitStore(Store* curr) {
    Builder builder(*getModule());
    // If unreachable, just remove the store, which removes the unaligned
    // operation in a trivial way.
    if (curr->type == Type::unreachable) {
      replaceCurrent(builder.makeBlock(
        {builder.makeDrop(curr->ptr), builder.makeDrop(curr->value)}));
      return;
    }
    if (curr->align != 0 && curr->align != curr->bytes) {
      replaceCurrent(lowerStoreI32(curr));
    }
  }
};

Pass* createAlignmentLoweringPass() { return new AlignmentLowering(); }

} // namespace wasm
