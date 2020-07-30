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
    return builder.makeBlock({builder.makeLocalSet(temp, curr->ptr), ret});
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
    if (curr->align == 0 || curr->align == curr->bytes) {
      // Nothing to do.
      return;
    }
    Builder builder(*getModule());
    auto type = curr->type.getSingle();
    Expression* replacement;
    switch (type) {
      default:
        WASM_UNREACHABLE("unhandled unaligned load");
      case Type::i32:
        replacement = lowerLoadI32(curr);
        break;
      case Type::f32:
        curr->type = Type::i32;
        replacement = builder.makeUnary(ReinterpretInt32, lowerLoadI32(curr));
        break;
      case Type::i64:
      case Type::f64:
        // Load two 32-bit pieces, and combine them.
        auto temp = builder.addVar(getFunction(), Type::i32);
        auto* set = builder.makeLocalSet(temp, curr->ptr);
        Expression* low =
          lowerLoadI32(builder.makeLoad(4,
                                        false,
                                        curr->offset,
                                        curr->align,
                                        builder.makeLocalGet(temp, Type::i32),
                                        Type::i32));
        low = builder.makeUnary(ExtendUInt32, low);
        Expression* high =
          lowerLoadI32(builder.makeLoad(4,
                                        false,
                                        curr->offset + 4,
                                        curr->align,
                                        builder.makeLocalGet(temp, Type::i32),
                                        Type::i32));
        high = builder.makeUnary(ExtendUInt32, high);
        high =
          builder.makeBinary(ShlInt64, high, builder.makeConst(int64_t(32)));
        auto* combined = builder.makeBinary(OrInt64, low, high);
        replacement = builder.makeSequence(set, combined);
        // Ensure the proper output type.
        if (type == Type::f64) {
          replacement = builder.makeUnary(ReinterpretInt64, replacement);
        }
        break;
    }
    replaceCurrent(replacement);
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
    if (curr->align == 0 || curr->align == curr->bytes) {
      // Nothing to do.
      return;
    }
    auto type = curr->value->type.getSingle();
    Expression* replacement;
    switch (type) {
      default:
        WASM_UNREACHABLE("unhandled unaligned store");
      case Type::i32:
        replacement = lowerStoreI32(curr);
        break;
      case Type::f32:
        curr->type = Type::i32;
        curr->value = builder.makeUnary(ReinterpretFloat32, curr->value);
        replacement = lowerStoreI32(curr);
        break;
      case Type::i64:
      case Type::f64:
        // Ensure an integer input value.
        auto* value = curr->value;
        if (type == Type::f64) {
          value = builder.makeUnary(ReinterpretFloat64, value);
        }
        // Store as two 32-bit pieces.
        auto tempPtr = builder.addVar(getFunction(), Type::i32);
        auto* setPtr = builder.makeLocalSet(tempPtr, curr->ptr);
        auto tempValue = builder.addVar(getFunction(), Type::i64);
        auto* setValue = builder.makeLocalSet(tempValue, value);
        Expression* low = builder.makeUnary(
          WrapInt64, builder.makeLocalGet(tempValue, Type::i64));
        low = lowerStoreI32(
          builder.makeStore(4,
                            curr->offset,
                            curr->align,
                            builder.makeLocalGet(tempPtr, Type::i32),
                            low,
                            Type::i32));
        Expression* high =
          builder.makeBinary(ShrUInt64,
                             builder.makeLocalGet(tempValue, Type::i64),
                             builder.makeConst(int64_t(32)));
        high = builder.makeUnary(WrapInt64, high);
        high = lowerStoreI32(
          builder.makeStore(4,
                            curr->offset + 4,
                            curr->align,
                            builder.makeLocalGet(tempPtr, Type::i32),
                            high,
                            Type::i32));
        replacement = builder.makeBlock({setPtr, setValue, low, high});
        break;
    }
    replaceCurrent(replacement);
  }
};

Pass* createAlignmentLoweringPass() { return new AlignmentLowering(); }

} // namespace wasm
