/*
 * Copyright 2019 WebAssembly Community Group participants
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

#include "wasm-stack.h"
#include "ir/find_all.h"
#include "wasm-debug.h"

namespace wasm {

void BinaryInstWriter::emitResultType(Type type) {
  if (type == Type::unreachable) {
    o << binaryType(Type::none);
  } else if (type.isTuple()) {
    o << S32LEB(parent.getTypeIndex(Signature(Type::none, type)));
  } else {
    o << binaryType(type);
  }
}

void BinaryInstWriter::visitBlock(Block* curr) {
  breakStack.push_back(curr->name);
  o << int8_t(BinaryConsts::Block);
  emitResultType(curr->type);
}

void BinaryInstWriter::visitIf(If* curr) {
  // the binary format requires this; we have a block if we need one
  // TODO: optimize this in Stack IR (if child is a block, we may break to this
  // instead)
  breakStack.emplace_back(IMPOSSIBLE_CONTINUE);
  o << int8_t(BinaryConsts::If);
  emitResultType(curr->type);
}

void BinaryInstWriter::emitIfElse(If* curr) {
  assert(!breakStack.empty());
  breakStack.pop_back();
  breakStack.emplace_back(IMPOSSIBLE_CONTINUE); // TODO same as If
  if (func && !sourceMap) {
    parent.writeExtraDebugLocation(curr, func, BinaryLocations::Else);
  }
  o << int8_t(BinaryConsts::Else);
}

void BinaryInstWriter::visitLoop(Loop* curr) {
  breakStack.push_back(curr->name);
  o << int8_t(BinaryConsts::Loop);
  emitResultType(curr->type);
}

void BinaryInstWriter::visitBreak(Break* curr) {
  o << int8_t(curr->condition ? BinaryConsts::BrIf : BinaryConsts::Br)
    << U32LEB(getBreakIndex(curr->name));
}

void BinaryInstWriter::visitSwitch(Switch* curr) {
  o << int8_t(BinaryConsts::BrTable) << U32LEB(curr->targets.size());
  for (auto target : curr->targets) {
    o << U32LEB(getBreakIndex(target));
  }
  o << U32LEB(getBreakIndex(curr->default_));
}

void BinaryInstWriter::visitCall(Call* curr) {
  int8_t op =
    curr->isReturn ? BinaryConsts::RetCallFunction : BinaryConsts::CallFunction;
  o << op << U32LEB(parent.getFunctionIndex(curr->target));
}

void BinaryInstWriter::visitCallIndirect(CallIndirect* curr) {
  int8_t op =
    curr->isReturn ? BinaryConsts::RetCallIndirect : BinaryConsts::CallIndirect;
  o << op << U32LEB(parent.getTypeIndex(curr->sig))
    << U32LEB(0); // Reserved flags field
}

void BinaryInstWriter::visitLocalGet(LocalGet* curr) {
  size_t numValues = func->getLocalType(curr->index).size();
  for (Index i = 0; i < numValues; ++i) {
    o << int8_t(BinaryConsts::LocalGet)
      << U32LEB(mappedLocals[std::make_pair(curr->index, i)]);
  }
}

void BinaryInstWriter::visitLocalSet(LocalSet* curr) {
  size_t numValues = func->getLocalType(curr->index).size();
  for (Index i = numValues - 1; i >= 1; --i) {
    o << int8_t(BinaryConsts::LocalSet)
      << U32LEB(mappedLocals[std::make_pair(curr->index, i)]);
  }
  if (!curr->isTee()) {
    o << int8_t(BinaryConsts::LocalSet)
      << U32LEB(mappedLocals[std::make_pair(curr->index, 0)]);
  } else {
    o << int8_t(BinaryConsts::LocalTee)
      << U32LEB(mappedLocals[std::make_pair(curr->index, 0)]);
    for (Index i = 1; i < numValues; ++i) {
      o << int8_t(BinaryConsts::LocalGet)
        << U32LEB(mappedLocals[std::make_pair(curr->index, i)]);
    }
  }
}

void BinaryInstWriter::visitGlobalGet(GlobalGet* curr) {
  // Emit a global.get for each element if this is a tuple global
  Index index = parent.getGlobalIndex(curr->name);
  size_t numValues = curr->type.size();
  for (Index i = 0; i < numValues; ++i) {
    o << int8_t(BinaryConsts::GlobalGet) << U32LEB(index + i);
  }
}

void BinaryInstWriter::visitGlobalSet(GlobalSet* curr) {
  // Emit a global.set for each element if this is a tuple global
  Index index = parent.getGlobalIndex(curr->name);
  size_t numValues = parent.getModule()->getGlobal(curr->name)->type.size();
  for (int i = numValues - 1; i >= 0; --i) {
    o << int8_t(BinaryConsts::GlobalSet) << U32LEB(index + i);
  }
}

void BinaryInstWriter::visitLoad(Load* curr) {
  if (!curr->isAtomic) {
    switch (curr->type.getBasic()) {
      case Type::i32: {
        switch (curr->bytes) {
          case 1:
            o << int8_t(curr->signed_ ? BinaryConsts::I32LoadMem8S
                                      : BinaryConsts::I32LoadMem8U);
            break;
          case 2:
            o << int8_t(curr->signed_ ? BinaryConsts::I32LoadMem16S
                                      : BinaryConsts::I32LoadMem16U);
            break;
          case 4:
            o << int8_t(BinaryConsts::I32LoadMem);
            break;
          default:
            abort();
        }
        break;
      }
      case Type::i64: {
        switch (curr->bytes) {
          case 1:
            o << int8_t(curr->signed_ ? BinaryConsts::I64LoadMem8S
                                      : BinaryConsts::I64LoadMem8U);
            break;
          case 2:
            o << int8_t(curr->signed_ ? BinaryConsts::I64LoadMem16S
                                      : BinaryConsts::I64LoadMem16U);
            break;
          case 4:
            o << int8_t(curr->signed_ ? BinaryConsts::I64LoadMem32S
                                      : BinaryConsts::I64LoadMem32U);
            break;
          case 8:
            o << int8_t(BinaryConsts::I64LoadMem);
            break;
          default:
            abort();
        }
        break;
      }
      case Type::f32:
        o << int8_t(BinaryConsts::F32LoadMem);
        break;
      case Type::f64:
        o << int8_t(BinaryConsts::F64LoadMem);
        break;
      case Type::v128:
        o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::V128Load);
        break;
      case Type::unreachable:
        // the pointer is unreachable, so we are never reached; just don't emit
        // a load
        return;
      case Type::funcref:
      case Type::externref:
      case Type::exnref:
      case Type::anyref:
      case Type::none:
        WASM_UNREACHABLE("unexpected type");
    }
  } else {
    o << int8_t(BinaryConsts::AtomicPrefix);
    switch (curr->type.getBasic()) {
      case Type::i32: {
        switch (curr->bytes) {
          case 1:
            o << int8_t(BinaryConsts::I32AtomicLoad8U);
            break;
          case 2:
            o << int8_t(BinaryConsts::I32AtomicLoad16U);
            break;
          case 4:
            o << int8_t(BinaryConsts::I32AtomicLoad);
            break;
          default:
            WASM_UNREACHABLE("invalid load size");
        }
        break;
      }
      case Type::i64: {
        switch (curr->bytes) {
          case 1:
            o << int8_t(BinaryConsts::I64AtomicLoad8U);
            break;
          case 2:
            o << int8_t(BinaryConsts::I64AtomicLoad16U);
            break;
          case 4:
            o << int8_t(BinaryConsts::I64AtomicLoad32U);
            break;
          case 8:
            o << int8_t(BinaryConsts::I64AtomicLoad);
            break;
          default:
            WASM_UNREACHABLE("invalid load size");
        }
        break;
      }
      case Type::unreachable:
        return;
      default:
        WASM_UNREACHABLE("unexpected type");
    }
  }
  emitMemoryAccess(curr->align, curr->bytes, curr->offset);
}

void BinaryInstWriter::visitStore(Store* curr) {
  if (!curr->isAtomic) {
    switch (curr->valueType.getBasic()) {
      case Type::i32: {
        switch (curr->bytes) {
          case 1:
            o << int8_t(BinaryConsts::I32StoreMem8);
            break;
          case 2:
            o << int8_t(BinaryConsts::I32StoreMem16);
            break;
          case 4:
            o << int8_t(BinaryConsts::I32StoreMem);
            break;
          default:
            abort();
        }
        break;
      }
      case Type::i64: {
        switch (curr->bytes) {
          case 1:
            o << int8_t(BinaryConsts::I64StoreMem8);
            break;
          case 2:
            o << int8_t(BinaryConsts::I64StoreMem16);
            break;
          case 4:
            o << int8_t(BinaryConsts::I64StoreMem32);
            break;
          case 8:
            o << int8_t(BinaryConsts::I64StoreMem);
            break;
          default:
            abort();
        }
        break;
      }
      case Type::f32:
        o << int8_t(BinaryConsts::F32StoreMem);
        break;
      case Type::f64:
        o << int8_t(BinaryConsts::F64StoreMem);
        break;
      case Type::v128:
        o << int8_t(BinaryConsts::SIMDPrefix)
          << U32LEB(BinaryConsts::V128Store);
        break;
      case Type::funcref:
      case Type::externref:
      case Type::exnref:
      case Type::anyref:
      case Type::none:
      case Type::unreachable:
        WASM_UNREACHABLE("unexpected type");
    }
  } else {
    o << int8_t(BinaryConsts::AtomicPrefix);
    switch (curr->valueType.getBasic()) {
      case Type::i32: {
        switch (curr->bytes) {
          case 1:
            o << int8_t(BinaryConsts::I32AtomicStore8);
            break;
          case 2:
            o << int8_t(BinaryConsts::I32AtomicStore16);
            break;
          case 4:
            o << int8_t(BinaryConsts::I32AtomicStore);
            break;
          default:
            WASM_UNREACHABLE("invalid store size");
        }
        break;
      }
      case Type::i64: {
        switch (curr->bytes) {
          case 1:
            o << int8_t(BinaryConsts::I64AtomicStore8);
            break;
          case 2:
            o << int8_t(BinaryConsts::I64AtomicStore16);
            break;
          case 4:
            o << int8_t(BinaryConsts::I64AtomicStore32);
            break;
          case 8:
            o << int8_t(BinaryConsts::I64AtomicStore);
            break;
          default:
            WASM_UNREACHABLE("invalid store size");
        }
        break;
      }
      default:
        WASM_UNREACHABLE("unexpected type");
    }
  }
  emitMemoryAccess(curr->align, curr->bytes, curr->offset);
}

void BinaryInstWriter::visitAtomicRMW(AtomicRMW* curr) {
  o << int8_t(BinaryConsts::AtomicPrefix);

#define CASE_FOR_OP(Op)                                                        \
  case Op:                                                                     \
    switch (curr->type.getBasic()) {                                           \
      case Type::i32:                                                          \
        switch (curr->bytes) {                                                 \
          case 1:                                                              \
            o << int8_t(BinaryConsts::I32AtomicRMW##Op##8U);                   \
            break;                                                             \
          case 2:                                                              \
            o << int8_t(BinaryConsts::I32AtomicRMW##Op##16U);                  \
            break;                                                             \
          case 4:                                                              \
            o << int8_t(BinaryConsts::I32AtomicRMW##Op);                       \
            break;                                                             \
          default:                                                             \
            WASM_UNREACHABLE("invalid rmw size");                              \
        }                                                                      \
        break;                                                                 \
      case Type::i64:                                                          \
        switch (curr->bytes) {                                                 \
          case 1:                                                              \
            o << int8_t(BinaryConsts::I64AtomicRMW##Op##8U);                   \
            break;                                                             \
          case 2:                                                              \
            o << int8_t(BinaryConsts::I64AtomicRMW##Op##16U);                  \
            break;                                                             \
          case 4:                                                              \
            o << int8_t(BinaryConsts::I64AtomicRMW##Op##32U);                  \
            break;                                                             \
          case 8:                                                              \
            o << int8_t(BinaryConsts::I64AtomicRMW##Op);                       \
            break;                                                             \
          default:                                                             \
            WASM_UNREACHABLE("invalid rmw size");                              \
        }                                                                      \
        break;                                                                 \
      default:                                                                 \
        WASM_UNREACHABLE("unexpected type");                                   \
    }                                                                          \
    break

  switch (curr->op) {
    CASE_FOR_OP(Add);
    CASE_FOR_OP(Sub);
    CASE_FOR_OP(And);
    CASE_FOR_OP(Or);
    CASE_FOR_OP(Xor);
    CASE_FOR_OP(Xchg);
    default:
      WASM_UNREACHABLE("unexpected op");
  }
#undef CASE_FOR_OP

  emitMemoryAccess(curr->bytes, curr->bytes, curr->offset);
}

void BinaryInstWriter::visitAtomicCmpxchg(AtomicCmpxchg* curr) {
  o << int8_t(BinaryConsts::AtomicPrefix);
  switch (curr->type.getBasic()) {
    case Type::i32:
      switch (curr->bytes) {
        case 1:
          o << int8_t(BinaryConsts::I32AtomicCmpxchg8U);
          break;
        case 2:
          o << int8_t(BinaryConsts::I32AtomicCmpxchg16U);
          break;
        case 4:
          o << int8_t(BinaryConsts::I32AtomicCmpxchg);
          break;
        default:
          WASM_UNREACHABLE("invalid size");
      }
      break;
    case Type::i64:
      switch (curr->bytes) {
        case 1:
          o << int8_t(BinaryConsts::I64AtomicCmpxchg8U);
          break;
        case 2:
          o << int8_t(BinaryConsts::I64AtomicCmpxchg16U);
          break;
        case 4:
          o << int8_t(BinaryConsts::I64AtomicCmpxchg32U);
          break;
        case 8:
          o << int8_t(BinaryConsts::I64AtomicCmpxchg);
          break;
        default:
          WASM_UNREACHABLE("invalid size");
      }
      break;
    default:
      WASM_UNREACHABLE("unexpected type");
  }
  emitMemoryAccess(curr->bytes, curr->bytes, curr->offset);
}

void BinaryInstWriter::visitAtomicWait(AtomicWait* curr) {
  o << int8_t(BinaryConsts::AtomicPrefix);
  switch (curr->expectedType.getBasic()) {
    case Type::i32: {
      o << int8_t(BinaryConsts::I32AtomicWait);
      emitMemoryAccess(4, 4, curr->offset);
      break;
    }
    case Type::i64: {
      o << int8_t(BinaryConsts::I64AtomicWait);
      emitMemoryAccess(8, 8, curr->offset);
      break;
    }
    default:
      WASM_UNREACHABLE("unexpected type");
  }
}

void BinaryInstWriter::visitAtomicNotify(AtomicNotify* curr) {
  o << int8_t(BinaryConsts::AtomicPrefix) << int8_t(BinaryConsts::AtomicNotify);
  emitMemoryAccess(4, 4, curr->offset);
}

void BinaryInstWriter::visitAtomicFence(AtomicFence* curr) {
  o << int8_t(BinaryConsts::AtomicPrefix) << int8_t(BinaryConsts::AtomicFence)
    << int8_t(curr->order);
}

void BinaryInstWriter::visitSIMDExtract(SIMDExtract* curr) {
  o << int8_t(BinaryConsts::SIMDPrefix);
  switch (curr->op) {
    case ExtractLaneSVecI8x16:
      o << U32LEB(BinaryConsts::I8x16ExtractLaneS);
      break;
    case ExtractLaneUVecI8x16:
      o << U32LEB(BinaryConsts::I8x16ExtractLaneU);
      break;
    case ExtractLaneSVecI16x8:
      o << U32LEB(BinaryConsts::I16x8ExtractLaneS);
      break;
    case ExtractLaneUVecI16x8:
      o << U32LEB(BinaryConsts::I16x8ExtractLaneU);
      break;
    case ExtractLaneVecI32x4:
      o << U32LEB(BinaryConsts::I32x4ExtractLane);
      break;
    case ExtractLaneVecI64x2:
      o << U32LEB(BinaryConsts::I64x2ExtractLane);
      break;
    case ExtractLaneVecF32x4:
      o << U32LEB(BinaryConsts::F32x4ExtractLane);
      break;
    case ExtractLaneVecF64x2:
      o << U32LEB(BinaryConsts::F64x2ExtractLane);
      break;
  }
  o << uint8_t(curr->index);
}

void BinaryInstWriter::visitSIMDReplace(SIMDReplace* curr) {
  o << int8_t(BinaryConsts::SIMDPrefix);
  switch (curr->op) {
    case ReplaceLaneVecI8x16:
      o << U32LEB(BinaryConsts::I8x16ReplaceLane);
      break;
    case ReplaceLaneVecI16x8:
      o << U32LEB(BinaryConsts::I16x8ReplaceLane);
      break;
    case ReplaceLaneVecI32x4:
      o << U32LEB(BinaryConsts::I32x4ReplaceLane);
      break;
    case ReplaceLaneVecI64x2:
      o << U32LEB(BinaryConsts::I64x2ReplaceLane);
      break;
    case ReplaceLaneVecF32x4:
      o << U32LEB(BinaryConsts::F32x4ReplaceLane);
      break;
    case ReplaceLaneVecF64x2:
      o << U32LEB(BinaryConsts::F64x2ReplaceLane);
      break;
  }
  assert(curr->index < 16);
  o << uint8_t(curr->index);
}

void BinaryInstWriter::visitSIMDShuffle(SIMDShuffle* curr) {
  o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::V8x16Shuffle);
  for (uint8_t m : curr->mask) {
    o << m;
  }
}

void BinaryInstWriter::visitSIMDTernary(SIMDTernary* curr) {
  o << int8_t(BinaryConsts::SIMDPrefix);
  switch (curr->op) {
    case Bitselect:
      o << U32LEB(BinaryConsts::V128Bitselect);
      break;
    case QFMAF32x4:
      o << U32LEB(BinaryConsts::F32x4QFMA);
      break;
    case QFMSF32x4:
      o << U32LEB(BinaryConsts::F32x4QFMS);
      break;
    case QFMAF64x2:
      o << U32LEB(BinaryConsts::F64x2QFMA);
      break;
    case QFMSF64x2:
      o << U32LEB(BinaryConsts::F64x2QFMS);
      break;
  }
}

void BinaryInstWriter::visitSIMDShift(SIMDShift* curr) {
  o << int8_t(BinaryConsts::SIMDPrefix);
  switch (curr->op) {
    case ShlVecI8x16:
      o << U32LEB(BinaryConsts::I8x16Shl);
      break;
    case ShrSVecI8x16:
      o << U32LEB(BinaryConsts::I8x16ShrS);
      break;
    case ShrUVecI8x16:
      o << U32LEB(BinaryConsts::I8x16ShrU);
      break;
    case ShlVecI16x8:
      o << U32LEB(BinaryConsts::I16x8Shl);
      break;
    case ShrSVecI16x8:
      o << U32LEB(BinaryConsts::I16x8ShrS);
      break;
    case ShrUVecI16x8:
      o << U32LEB(BinaryConsts::I16x8ShrU);
      break;
    case ShlVecI32x4:
      o << U32LEB(BinaryConsts::I32x4Shl);
      break;
    case ShrSVecI32x4:
      o << U32LEB(BinaryConsts::I32x4ShrS);
      break;
    case ShrUVecI32x4:
      o << U32LEB(BinaryConsts::I32x4ShrU);
      break;
    case ShlVecI64x2:
      o << U32LEB(BinaryConsts::I64x2Shl);
      break;
    case ShrSVecI64x2:
      o << U32LEB(BinaryConsts::I64x2ShrS);
      break;
    case ShrUVecI64x2:
      o << U32LEB(BinaryConsts::I64x2ShrU);
      break;
  }
}

void BinaryInstWriter::visitSIMDLoad(SIMDLoad* curr) {
  o << int8_t(BinaryConsts::SIMDPrefix);
  switch (curr->op) {
    case LoadSplatVec8x16:
      o << U32LEB(BinaryConsts::V8x16LoadSplat);
      break;
    case LoadSplatVec16x8:
      o << U32LEB(BinaryConsts::V16x8LoadSplat);
      break;
    case LoadSplatVec32x4:
      o << U32LEB(BinaryConsts::V32x4LoadSplat);
      break;
    case LoadSplatVec64x2:
      o << U32LEB(BinaryConsts::V64x2LoadSplat);
      break;
    case LoadExtSVec8x8ToVecI16x8:
      o << U32LEB(BinaryConsts::I16x8LoadExtSVec8x8);
      break;
    case LoadExtUVec8x8ToVecI16x8:
      o << U32LEB(BinaryConsts::I16x8LoadExtUVec8x8);
      break;
    case LoadExtSVec16x4ToVecI32x4:
      o << U32LEB(BinaryConsts::I32x4LoadExtSVec16x4);
      break;
    case LoadExtUVec16x4ToVecI32x4:
      o << U32LEB(BinaryConsts::I32x4LoadExtUVec16x4);
      break;
    case LoadExtSVec32x2ToVecI64x2:
      o << U32LEB(BinaryConsts::I64x2LoadExtSVec32x2);
      break;
    case LoadExtUVec32x2ToVecI64x2:
      o << U32LEB(BinaryConsts::I64x2LoadExtUVec32x2);
      break;
    case Load32Zero:
      o << U32LEB(BinaryConsts::V128Load32Zero);
      break;
    case Load64Zero:
      o << U32LEB(BinaryConsts::V128Load64Zero);
      break;
  }
  assert(curr->align);
  emitMemoryAccess(curr->align, /*(unused) bytes=*/0, curr->offset);
}

void BinaryInstWriter::visitMemoryInit(MemoryInit* curr) {
  o << int8_t(BinaryConsts::MiscPrefix);
  o << U32LEB(BinaryConsts::MemoryInit);
  o << U32LEB(curr->segment) << int8_t(0);
}

void BinaryInstWriter::visitDataDrop(DataDrop* curr) {
  o << int8_t(BinaryConsts::MiscPrefix);
  o << U32LEB(BinaryConsts::DataDrop);
  o << U32LEB(curr->segment);
}

void BinaryInstWriter::visitMemoryCopy(MemoryCopy* curr) {
  o << int8_t(BinaryConsts::MiscPrefix);
  o << U32LEB(BinaryConsts::MemoryCopy);
  o << int8_t(0) << int8_t(0);
}

void BinaryInstWriter::visitMemoryFill(MemoryFill* curr) {
  o << int8_t(BinaryConsts::MiscPrefix);
  o << U32LEB(BinaryConsts::MemoryFill);
  o << int8_t(0);
}

void BinaryInstWriter::visitConst(Const* curr) {
  switch (curr->type.getBasic()) {
    case Type::i32: {
      o << int8_t(BinaryConsts::I32Const) << S32LEB(curr->value.geti32());
      break;
    }
    case Type::i64: {
      o << int8_t(BinaryConsts::I64Const) << S64LEB(curr->value.geti64());
      break;
    }
    case Type::f32: {
      o << int8_t(BinaryConsts::F32Const) << curr->value.reinterpreti32();
      break;
    }
    case Type::f64: {
      o << int8_t(BinaryConsts::F64Const) << curr->value.reinterpreti64();
      break;
    }
    case Type::v128: {
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::V128Const);
      std::array<uint8_t, 16> v = curr->value.getv128();
      for (size_t i = 0; i < 16; ++i) {
        o << uint8_t(v[i]);
      }
      break;
    }
    case Type::funcref:
    case Type::externref:
    case Type::exnref:
    case Type::anyref:
    case Type::none:
    case Type::unreachable:
      WASM_UNREACHABLE("unexpected type");
  }
}

void BinaryInstWriter::visitUnary(Unary* curr) {
  switch (curr->op) {
    case ClzInt32:
      o << int8_t(BinaryConsts::I32Clz);
      break;
    case CtzInt32:
      o << int8_t(BinaryConsts::I32Ctz);
      break;
    case PopcntInt32:
      o << int8_t(BinaryConsts::I32Popcnt);
      break;
    case EqZInt32:
      o << int8_t(BinaryConsts::I32EqZ);
      break;
    case ClzInt64:
      o << int8_t(BinaryConsts::I64Clz);
      break;
    case CtzInt64:
      o << int8_t(BinaryConsts::I64Ctz);
      break;
    case PopcntInt64:
      o << int8_t(BinaryConsts::I64Popcnt);
      break;
    case EqZInt64:
      o << int8_t(BinaryConsts::I64EqZ);
      break;
    case NegFloat32:
      o << int8_t(BinaryConsts::F32Neg);
      break;
    case AbsFloat32:
      o << int8_t(BinaryConsts::F32Abs);
      break;
    case CeilFloat32:
      o << int8_t(BinaryConsts::F32Ceil);
      break;
    case FloorFloat32:
      o << int8_t(BinaryConsts::F32Floor);
      break;
    case TruncFloat32:
      o << int8_t(BinaryConsts::F32Trunc);
      break;
    case NearestFloat32:
      o << int8_t(BinaryConsts::F32NearestInt);
      break;
    case SqrtFloat32:
      o << int8_t(BinaryConsts::F32Sqrt);
      break;
    case NegFloat64:
      o << int8_t(BinaryConsts::F64Neg);
      break;
    case AbsFloat64:
      o << int8_t(BinaryConsts::F64Abs);
      break;
    case CeilFloat64:
      o << int8_t(BinaryConsts::F64Ceil);
      break;
    case FloorFloat64:
      o << int8_t(BinaryConsts::F64Floor);
      break;
    case TruncFloat64:
      o << int8_t(BinaryConsts::F64Trunc);
      break;
    case NearestFloat64:
      o << int8_t(BinaryConsts::F64NearestInt);
      break;
    case SqrtFloat64:
      o << int8_t(BinaryConsts::F64Sqrt);
      break;
    case ExtendSInt32:
      o << int8_t(BinaryConsts::I64SExtendI32);
      break;
    case ExtendUInt32:
      o << int8_t(BinaryConsts::I64UExtendI32);
      break;
    case WrapInt64:
      o << int8_t(BinaryConsts::I32WrapI64);
      break;
    case TruncUFloat32ToInt32:
      o << int8_t(BinaryConsts::I32UTruncF32);
      break;
    case TruncUFloat32ToInt64:
      o << int8_t(BinaryConsts::I64UTruncF32);
      break;
    case TruncSFloat32ToInt32:
      o << int8_t(BinaryConsts::I32STruncF32);
      break;
    case TruncSFloat32ToInt64:
      o << int8_t(BinaryConsts::I64STruncF32);
      break;
    case TruncUFloat64ToInt32:
      o << int8_t(BinaryConsts::I32UTruncF64);
      break;
    case TruncUFloat64ToInt64:
      o << int8_t(BinaryConsts::I64UTruncF64);
      break;
    case TruncSFloat64ToInt32:
      o << int8_t(BinaryConsts::I32STruncF64);
      break;
    case TruncSFloat64ToInt64:
      o << int8_t(BinaryConsts::I64STruncF64);
      break;
    case ConvertUInt32ToFloat32:
      o << int8_t(BinaryConsts::F32UConvertI32);
      break;
    case ConvertUInt32ToFloat64:
      o << int8_t(BinaryConsts::F64UConvertI32);
      break;
    case ConvertSInt32ToFloat32:
      o << int8_t(BinaryConsts::F32SConvertI32);
      break;
    case ConvertSInt32ToFloat64:
      o << int8_t(BinaryConsts::F64SConvertI32);
      break;
    case ConvertUInt64ToFloat32:
      o << int8_t(BinaryConsts::F32UConvertI64);
      break;
    case ConvertUInt64ToFloat64:
      o << int8_t(BinaryConsts::F64UConvertI64);
      break;
    case ConvertSInt64ToFloat32:
      o << int8_t(BinaryConsts::F32SConvertI64);
      break;
    case ConvertSInt64ToFloat64:
      o << int8_t(BinaryConsts::F64SConvertI64);
      break;
    case DemoteFloat64:
      o << int8_t(BinaryConsts::F32DemoteI64);
      break;
    case PromoteFloat32:
      o << int8_t(BinaryConsts::F64PromoteF32);
      break;
    case ReinterpretFloat32:
      o << int8_t(BinaryConsts::I32ReinterpretF32);
      break;
    case ReinterpretFloat64:
      o << int8_t(BinaryConsts::I64ReinterpretF64);
      break;
    case ReinterpretInt32:
      o << int8_t(BinaryConsts::F32ReinterpretI32);
      break;
    case ReinterpretInt64:
      o << int8_t(BinaryConsts::F64ReinterpretI64);
      break;
    case ExtendS8Int32:
      o << int8_t(BinaryConsts::I32ExtendS8);
      break;
    case ExtendS16Int32:
      o << int8_t(BinaryConsts::I32ExtendS16);
      break;
    case ExtendS8Int64:
      o << int8_t(BinaryConsts::I64ExtendS8);
      break;
    case ExtendS16Int64:
      o << int8_t(BinaryConsts::I64ExtendS16);
      break;
    case ExtendS32Int64:
      o << int8_t(BinaryConsts::I64ExtendS32);
      break;
    case TruncSatSFloat32ToInt32:
      o << int8_t(BinaryConsts::MiscPrefix)
        << U32LEB(BinaryConsts::I32STruncSatF32);
      break;
    case TruncSatUFloat32ToInt32:
      o << int8_t(BinaryConsts::MiscPrefix)
        << U32LEB(BinaryConsts::I32UTruncSatF32);
      break;
    case TruncSatSFloat64ToInt32:
      o << int8_t(BinaryConsts::MiscPrefix)
        << U32LEB(BinaryConsts::I32STruncSatF64);
      break;
    case TruncSatUFloat64ToInt32:
      o << int8_t(BinaryConsts::MiscPrefix)
        << U32LEB(BinaryConsts::I32UTruncSatF64);
      break;
    case TruncSatSFloat32ToInt64:
      o << int8_t(BinaryConsts::MiscPrefix)
        << U32LEB(BinaryConsts::I64STruncSatF32);
      break;
    case TruncSatUFloat32ToInt64:
      o << int8_t(BinaryConsts::MiscPrefix)
        << U32LEB(BinaryConsts::I64UTruncSatF32);
      break;
    case TruncSatSFloat64ToInt64:
      o << int8_t(BinaryConsts::MiscPrefix)
        << U32LEB(BinaryConsts::I64STruncSatF64);
      break;
    case TruncSatUFloat64ToInt64:
      o << int8_t(BinaryConsts::MiscPrefix)
        << U32LEB(BinaryConsts::I64UTruncSatF64);
      break;
    case SplatVecI8x16:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16Splat);
      break;
    case SplatVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8Splat);
      break;
    case SplatVecI32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4Splat);
      break;
    case SplatVecI64x2:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I64x2Splat);
      break;
    case SplatVecF32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Splat);
      break;
    case SplatVecF64x2:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Splat);
      break;
    case NotVec128:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::V128Not);
      break;
    case AbsVecI8x16:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16Abs);
      break;
    case NegVecI8x16:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16Neg);
      break;
    case AnyTrueVecI8x16:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I8x16AnyTrue);
      break;
    case AllTrueVecI8x16:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I8x16AllTrue);
      break;
    case BitmaskVecI8x16:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I8x16Bitmask);
      break;
    case AbsVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8Abs);
      break;
    case NegVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8Neg);
      break;
    case AnyTrueVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I16x8AnyTrue);
      break;
    case AllTrueVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I16x8AllTrue);
      break;
    case BitmaskVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I16x8Bitmask);
      break;
    case AbsVecI32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4Abs);
      break;
    case NegVecI32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4Neg);
      break;
    case AnyTrueVecI32x4:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I32x4AnyTrue);
      break;
    case AllTrueVecI32x4:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I32x4AllTrue);
      break;
    case BitmaskVecI32x4:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I32x4Bitmask);
      break;
    case NegVecI64x2:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I64x2Neg);
      break;
    case AnyTrueVecI64x2:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I64x2AnyTrue);
      break;
    case AllTrueVecI64x2:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I64x2AllTrue);
      break;
    case AbsVecF32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Abs);
      break;
    case NegVecF32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Neg);
      break;
    case SqrtVecF32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Sqrt);
      break;
    case CeilVecF32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Ceil);
      break;
    case FloorVecF32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Floor);
      break;
    case TruncVecF32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Trunc);
      break;
    case NearestVecF32x4:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::F32x4Nearest);
      break;
    case AbsVecF64x2:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Abs);
      break;
    case NegVecF64x2:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Neg);
      break;
    case SqrtVecF64x2:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Sqrt);
      break;
    case CeilVecF64x2:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Ceil);
      break;
    case FloorVecF64x2:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Floor);
      break;
    case TruncVecF64x2:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Trunc);
      break;
    case NearestVecF64x2:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::F64x2Nearest);
      break;
    case TruncSatSVecF32x4ToVecI32x4:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I32x4TruncSatSF32x4);
      break;
    case TruncSatUVecF32x4ToVecI32x4:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I32x4TruncSatUF32x4);
      break;
    case TruncSatSVecF64x2ToVecI64x2:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I64x2TruncSatSF64x2);
      break;
    case TruncSatUVecF64x2ToVecI64x2:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I64x2TruncSatUF64x2);
      break;
    case ConvertSVecI32x4ToVecF32x4:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::F32x4ConvertSI32x4);
      break;
    case ConvertUVecI32x4ToVecF32x4:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::F32x4ConvertUI32x4);
      break;
    case ConvertSVecI64x2ToVecF64x2:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::F64x2ConvertSI64x2);
      break;
    case ConvertUVecI64x2ToVecF64x2:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::F64x2ConvertUI64x2);
      break;
    case WidenLowSVecI8x16ToVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I16x8WidenLowSI8x16);
      break;
    case WidenHighSVecI8x16ToVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I16x8WidenHighSI8x16);
      break;
    case WidenLowUVecI8x16ToVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I16x8WidenLowUI8x16);
      break;
    case WidenHighUVecI8x16ToVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I16x8WidenHighUI8x16);
      break;
    case WidenLowSVecI16x8ToVecI32x4:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I32x4WidenLowSI16x8);
      break;
    case WidenHighSVecI16x8ToVecI32x4:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I32x4WidenHighSI16x8);
      break;
    case WidenLowUVecI16x8ToVecI32x4:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I32x4WidenLowUI16x8);
      break;
    case WidenHighUVecI16x8ToVecI32x4:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I32x4WidenHighUI16x8);
      break;
    case InvalidUnary:
      WASM_UNREACHABLE("invalid unary op");
  }
}

void BinaryInstWriter::visitBinary(Binary* curr) {
  switch (curr->op) {
    case AddInt32:
      o << int8_t(BinaryConsts::I32Add);
      break;
    case SubInt32:
      o << int8_t(BinaryConsts::I32Sub);
      break;
    case MulInt32:
      o << int8_t(BinaryConsts::I32Mul);
      break;
    case DivSInt32:
      o << int8_t(BinaryConsts::I32DivS);
      break;
    case DivUInt32:
      o << int8_t(BinaryConsts::I32DivU);
      break;
    case RemSInt32:
      o << int8_t(BinaryConsts::I32RemS);
      break;
    case RemUInt32:
      o << int8_t(BinaryConsts::I32RemU);
      break;
    case AndInt32:
      o << int8_t(BinaryConsts::I32And);
      break;
    case OrInt32:
      o << int8_t(BinaryConsts::I32Or);
      break;
    case XorInt32:
      o << int8_t(BinaryConsts::I32Xor);
      break;
    case ShlInt32:
      o << int8_t(BinaryConsts::I32Shl);
      break;
    case ShrUInt32:
      o << int8_t(BinaryConsts::I32ShrU);
      break;
    case ShrSInt32:
      o << int8_t(BinaryConsts::I32ShrS);
      break;
    case RotLInt32:
      o << int8_t(BinaryConsts::I32RotL);
      break;
    case RotRInt32:
      o << int8_t(BinaryConsts::I32RotR);
      break;
    case EqInt32:
      o << int8_t(BinaryConsts::I32Eq);
      break;
    case NeInt32:
      o << int8_t(BinaryConsts::I32Ne);
      break;
    case LtSInt32:
      o << int8_t(BinaryConsts::I32LtS);
      break;
    case LtUInt32:
      o << int8_t(BinaryConsts::I32LtU);
      break;
    case LeSInt32:
      o << int8_t(BinaryConsts::I32LeS);
      break;
    case LeUInt32:
      o << int8_t(BinaryConsts::I32LeU);
      break;
    case GtSInt32:
      o << int8_t(BinaryConsts::I32GtS);
      break;
    case GtUInt32:
      o << int8_t(BinaryConsts::I32GtU);
      break;
    case GeSInt32:
      o << int8_t(BinaryConsts::I32GeS);
      break;
    case GeUInt32:
      o << int8_t(BinaryConsts::I32GeU);
      break;

    case AddInt64:
      o << int8_t(BinaryConsts::I64Add);
      break;
    case SubInt64:
      o << int8_t(BinaryConsts::I64Sub);
      break;
    case MulInt64:
      o << int8_t(BinaryConsts::I64Mul);
      break;
    case DivSInt64:
      o << int8_t(BinaryConsts::I64DivS);
      break;
    case DivUInt64:
      o << int8_t(BinaryConsts::I64DivU);
      break;
    case RemSInt64:
      o << int8_t(BinaryConsts::I64RemS);
      break;
    case RemUInt64:
      o << int8_t(BinaryConsts::I64RemU);
      break;
    case AndInt64:
      o << int8_t(BinaryConsts::I64And);
      break;
    case OrInt64:
      o << int8_t(BinaryConsts::I64Or);
      break;
    case XorInt64:
      o << int8_t(BinaryConsts::I64Xor);
      break;
    case ShlInt64:
      o << int8_t(BinaryConsts::I64Shl);
      break;
    case ShrUInt64:
      o << int8_t(BinaryConsts::I64ShrU);
      break;
    case ShrSInt64:
      o << int8_t(BinaryConsts::I64ShrS);
      break;
    case RotLInt64:
      o << int8_t(BinaryConsts::I64RotL);
      break;
    case RotRInt64:
      o << int8_t(BinaryConsts::I64RotR);
      break;
    case EqInt64:
      o << int8_t(BinaryConsts::I64Eq);
      break;
    case NeInt64:
      o << int8_t(BinaryConsts::I64Ne);
      break;
    case LtSInt64:
      o << int8_t(BinaryConsts::I64LtS);
      break;
    case LtUInt64:
      o << int8_t(BinaryConsts::I64LtU);
      break;
    case LeSInt64:
      o << int8_t(BinaryConsts::I64LeS);
      break;
    case LeUInt64:
      o << int8_t(BinaryConsts::I64LeU);
      break;
    case GtSInt64:
      o << int8_t(BinaryConsts::I64GtS);
      break;
    case GtUInt64:
      o << int8_t(BinaryConsts::I64GtU);
      break;
    case GeSInt64:
      o << int8_t(BinaryConsts::I64GeS);
      break;
    case GeUInt64:
      o << int8_t(BinaryConsts::I64GeU);
      break;

    case AddFloat32:
      o << int8_t(BinaryConsts::F32Add);
      break;
    case SubFloat32:
      o << int8_t(BinaryConsts::F32Sub);
      break;
    case MulFloat32:
      o << int8_t(BinaryConsts::F32Mul);
      break;
    case DivFloat32:
      o << int8_t(BinaryConsts::F32Div);
      break;
    case CopySignFloat32:
      o << int8_t(BinaryConsts::F32CopySign);
      break;
    case MinFloat32:
      o << int8_t(BinaryConsts::F32Min);
      break;
    case MaxFloat32:
      o << int8_t(BinaryConsts::F32Max);
      break;
    case EqFloat32:
      o << int8_t(BinaryConsts::F32Eq);
      break;
    case NeFloat32:
      o << int8_t(BinaryConsts::F32Ne);
      break;
    case LtFloat32:
      o << int8_t(BinaryConsts::F32Lt);
      break;
    case LeFloat32:
      o << int8_t(BinaryConsts::F32Le);
      break;
    case GtFloat32:
      o << int8_t(BinaryConsts::F32Gt);
      break;
    case GeFloat32:
      o << int8_t(BinaryConsts::F32Ge);
      break;

    case AddFloat64:
      o << int8_t(BinaryConsts::F64Add);
      break;
    case SubFloat64:
      o << int8_t(BinaryConsts::F64Sub);
      break;
    case MulFloat64:
      o << int8_t(BinaryConsts::F64Mul);
      break;
    case DivFloat64:
      o << int8_t(BinaryConsts::F64Div);
      break;
    case CopySignFloat64:
      o << int8_t(BinaryConsts::F64CopySign);
      break;
    case MinFloat64:
      o << int8_t(BinaryConsts::F64Min);
      break;
    case MaxFloat64:
      o << int8_t(BinaryConsts::F64Max);
      break;
    case EqFloat64:
      o << int8_t(BinaryConsts::F64Eq);
      break;
    case NeFloat64:
      o << int8_t(BinaryConsts::F64Ne);
      break;
    case LtFloat64:
      o << int8_t(BinaryConsts::F64Lt);
      break;
    case LeFloat64:
      o << int8_t(BinaryConsts::F64Le);
      break;
    case GtFloat64:
      o << int8_t(BinaryConsts::F64Gt);
      break;
    case GeFloat64:
      o << int8_t(BinaryConsts::F64Ge);
      break;

    case EqVecI8x16:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16Eq);
      break;
    case NeVecI8x16:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16Ne);
      break;
    case LtSVecI8x16:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16LtS);
      break;
    case LtUVecI8x16:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16LtU);
      break;
    case GtSVecI8x16:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16GtS);
      break;
    case GtUVecI8x16:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16GtU);
      break;
    case LeSVecI8x16:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16LeS);
      break;
    case LeUVecI8x16:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16LeU);
      break;
    case GeSVecI8x16:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16GeS);
      break;
    case GeUVecI8x16:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16GeU);
      break;
    case EqVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8Eq);
      break;
    case NeVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8Ne);
      break;
    case LtSVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8LtS);
      break;
    case LtUVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8LtU);
      break;
    case GtSVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8GtS);
      break;
    case GtUVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8GtU);
      break;
    case LeSVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8LeS);
      break;
    case LeUVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8LeU);
      break;
    case GeSVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8GeS);
      break;
    case GeUVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8GeU);
      break;
    case EqVecI32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4Eq);
      break;
    case NeVecI32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4Ne);
      break;
    case LtSVecI32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4LtS);
      break;
    case LtUVecI32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4LtU);
      break;
    case GtSVecI32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4GtS);
      break;
    case GtUVecI32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4GtU);
      break;
    case LeSVecI32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4LeS);
      break;
    case LeUVecI32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4LeU);
      break;
    case GeSVecI32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4GeS);
      break;
    case GeUVecI32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4GeU);
      break;
    case EqVecF32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Eq);
      break;
    case NeVecF32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Ne);
      break;
    case LtVecF32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Lt);
      break;
    case GtVecF32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Gt);
      break;
    case LeVecF32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Le);
      break;
    case GeVecF32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Ge);
      break;
    case EqVecF64x2:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Eq);
      break;
    case NeVecF64x2:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Ne);
      break;
    case LtVecF64x2:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Lt);
      break;
    case GtVecF64x2:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Gt);
      break;
    case LeVecF64x2:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Le);
      break;
    case GeVecF64x2:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Ge);
      break;
    case AndVec128:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::V128And);
      break;
    case OrVec128:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::V128Or);
      break;
    case XorVec128:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::V128Xor);
      break;
    case AndNotVec128:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::V128AndNot);
      break;
    case AddVecI8x16:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16Add);
      break;
    case AddSatSVecI8x16:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I8x16AddSatS);
      break;
    case AddSatUVecI8x16:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I8x16AddSatU);
      break;
    case SubVecI8x16:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16Sub);
      break;
    case SubSatSVecI8x16:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I8x16SubSatS);
      break;
    case SubSatUVecI8x16:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I8x16SubSatU);
      break;
    case MulVecI8x16:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16Mul);
      break;
    case MinSVecI8x16:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16MinS);
      break;
    case MinUVecI8x16:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16MinU);
      break;
    case MaxSVecI8x16:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16MaxS);
      break;
    case MaxUVecI8x16:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16MaxU);
      break;
    case AvgrUVecI8x16:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16AvgrU);
      break;
    case AddVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8Add);
      break;
    case AddSatSVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I16x8AddSatS);
      break;
    case AddSatUVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I16x8AddSatU);
      break;
    case SubVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8Sub);
      break;
    case SubSatSVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I16x8SubSatS);
      break;
    case SubSatUVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I16x8SubSatU);
      break;
    case MulVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8Mul);
      break;
    case MinSVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8MinS);
      break;
    case MinUVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8MinU);
      break;
    case MaxSVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8MaxS);
      break;
    case MaxUVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8MaxU);
      break;
    case AvgrUVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8AvgrU);
      break;
    case AddVecI32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4Add);
      break;
    case SubVecI32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4Sub);
      break;
    case MulVecI32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4Mul);
      break;
    case MinSVecI32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4MinS);
      break;
    case MinUVecI32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4MinU);
      break;
    case MaxSVecI32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4MaxS);
      break;
    case MaxUVecI32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4MaxU);
      break;
    case DotSVecI16x8ToVecI32x4:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I32x4DotSVecI16x8);
      break;
    case AddVecI64x2:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I64x2Add);
      break;
    case SubVecI64x2:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I64x2Sub);
      break;
    case MulVecI64x2:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I64x2Mul);
      break;

    case AddVecF32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Add);
      break;
    case SubVecF32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Sub);
      break;
    case MulVecF32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Mul);
      break;
    case DivVecF32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Div);
      break;
    case MinVecF32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Min);
      break;
    case MaxVecF32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Max);
      break;
    case PMinVecF32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4PMin);
      break;
    case PMaxVecF32x4:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4PMax);
      break;
    case AddVecF64x2:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Add);
      break;
    case SubVecF64x2:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Sub);
      break;
    case MulVecF64x2:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Mul);
      break;
    case DivVecF64x2:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Div);
      break;
    case MinVecF64x2:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Min);
      break;
    case MaxVecF64x2:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Max);
      break;
    case PMinVecF64x2:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2PMin);
      break;
    case PMaxVecF64x2:
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2PMax);
      break;

    case NarrowSVecI16x8ToVecI8x16:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I8x16NarrowSI16x8);
      break;
    case NarrowUVecI16x8ToVecI8x16:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I8x16NarrowUI16x8);
      break;
    case NarrowSVecI32x4ToVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I16x8NarrowSI32x4);
      break;
    case NarrowUVecI32x4ToVecI16x8:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::I16x8NarrowUI32x4);
      break;

    case SwizzleVec8x16:
      o << int8_t(BinaryConsts::SIMDPrefix)
        << U32LEB(BinaryConsts::V8x16Swizzle);
      break;

    case InvalidBinary:
      WASM_UNREACHABLE("invalid binary op");
  }
}

void BinaryInstWriter::visitSelect(Select* curr) {
  if (curr->type.isRef()) {
    o << int8_t(BinaryConsts::SelectWithType) << U32LEB(curr->type.size());
    for (size_t i = 0; i < curr->type.size(); i++) {
      o << binaryType(curr->type != Type::unreachable ? curr->type
                                                      : Type::none);
    }
  } else {
    o << int8_t(BinaryConsts::Select);
  }
}

void BinaryInstWriter::visitReturn(Return* curr) {
  o << int8_t(BinaryConsts::Return);
}

void BinaryInstWriter::visitHost(Host* curr) {
  switch (curr->op) {
    case MemorySize: {
      o << int8_t(BinaryConsts::MemorySize);
      break;
    }
    case MemoryGrow: {
      o << int8_t(BinaryConsts::MemoryGrow);
      break;
    }
  }
  o << U32LEB(0); // Reserved flags field
}

void BinaryInstWriter::visitRefNull(RefNull* curr) {
  o << int8_t(BinaryConsts::RefNull)
    << binaryHeapType(curr->type.getHeapType());
}

void BinaryInstWriter::visitRefIsNull(RefIsNull* curr) {
  o << int8_t(BinaryConsts::RefIsNull);
}

void BinaryInstWriter::visitRefFunc(RefFunc* curr) {
  o << int8_t(BinaryConsts::RefFunc)
    << U32LEB(parent.getFunctionIndex(curr->func));
}

void BinaryInstWriter::visitTry(Try* curr) {
  breakStack.emplace_back(IMPOSSIBLE_CONTINUE);
  o << int8_t(BinaryConsts::Try);
  emitResultType(curr->type);
}

void BinaryInstWriter::emitCatch(Try* curr) {
  assert(!breakStack.empty());
  breakStack.pop_back();
  breakStack.emplace_back(IMPOSSIBLE_CONTINUE);
  if (func && !sourceMap) {
    parent.writeExtraDebugLocation(curr, func, BinaryLocations::Catch);
  }
  o << int8_t(BinaryConsts::Catch);
}

void BinaryInstWriter::visitThrow(Throw* curr) {
  o << int8_t(BinaryConsts::Throw) << U32LEB(parent.getEventIndex(curr->event));
}

void BinaryInstWriter::visitRethrow(Rethrow* curr) {
  o << int8_t(BinaryConsts::Rethrow);
}

void BinaryInstWriter::visitBrOnExn(BrOnExn* curr) {
  o << int8_t(BinaryConsts::BrOnExn) << U32LEB(getBreakIndex(curr->name))
    << U32LEB(parent.getEventIndex(curr->event));
}

void BinaryInstWriter::visitNop(Nop* curr) { o << int8_t(BinaryConsts::Nop); }

void BinaryInstWriter::visitUnreachable(Unreachable* curr) {
  o << int8_t(BinaryConsts::Unreachable);
}

void BinaryInstWriter::visitDrop(Drop* curr) {
  size_t numValues = curr->value->type.size();
  for (size_t i = 0; i < numValues; i++) {
    o << int8_t(BinaryConsts::Drop);
  }
}

void BinaryInstWriter::visitPop(Pop* curr) {
  // Turns into nothing in the binary format
}

void BinaryInstWriter::visitTupleMake(TupleMake* curr) {
  // Turns into nothing in the binary format
}

void BinaryInstWriter::visitTupleExtract(TupleExtract* curr) {
  size_t numVals = curr->tuple->type.size();
  // Drop all values after the one we want
  for (size_t i = curr->index + 1; i < numVals; ++i) {
    o << int8_t(BinaryConsts::Drop);
  }
  // If the extracted value is the only one left, we're done
  if (curr->index == 0) {
    return;
  }
  // Otherwise, save it to a scratch local, drop the others, then retrieve it
  assert(scratchLocals.find(curr->type) != scratchLocals.end());
  auto scratch = scratchLocals[curr->type];
  o << int8_t(BinaryConsts::LocalSet) << U32LEB(scratch);
  for (size_t i = 0; i < curr->index; ++i) {
    o << int8_t(BinaryConsts::Drop);
  }
  o << int8_t(BinaryConsts::LocalGet) << U32LEB(scratch);
}

void BinaryInstWriter::emitScopeEnd(Expression* curr) {
  assert(!breakStack.empty());
  breakStack.pop_back();
  if (func && !sourceMap) {
    parent.writeExtraDebugLocation(curr, func, BinaryLocations::End);
  }
  o << int8_t(BinaryConsts::End);
}

void BinaryInstWriter::emitFunctionEnd() { o << int8_t(BinaryConsts::End); }

void BinaryInstWriter::emitUnreachable() {
  o << int8_t(BinaryConsts::Unreachable);
}

void BinaryInstWriter::mapLocalsAndEmitHeader() {
  assert(func && "BinaryInstWriter: function is not set");
  // Map params
  for (Index i = 0; i < func->getNumParams(); i++) {
    mappedLocals[std::make_pair(i, 0)] = i;
  }
  // Normally we map all locals of the same type into a range of adjacent
  // addresses, which is more compact. However, if we need to keep DWARF valid,
  // do not do any reordering at all - instead, do a trivial mapping that
  // keeps everything unmoved.
  if (DWARF) {
    FindAll<TupleExtract> extracts(func->body);
    if (!extracts.list.empty()) {
      Fatal() << "DWARF + multivalue is not yet complete";
    }
    Index varStart = func->getVarIndexBase();
    Index varEnd = varStart + func->getNumVars();
    o << U32LEB(func->getNumVars());
    for (Index i = varStart; i < varEnd; i++) {
      mappedLocals[std::make_pair(i, 0)] = i;
      o << U32LEB(1) << binaryType(func->getLocalType(i));
    }
    return;
  }
  for (auto type : func->vars) {
    for (const auto& t : type) {
      numLocalsByType[t]++;
    }
  }
  countScratchLocals();
  std::map<Type, size_t> currLocalsByType;
  for (Index i = func->getVarIndexBase(); i < func->getNumLocals(); i++) {
    Index j = 0;
    for (const auto& type : func->getLocalType(i)) {
      auto fullIndex = std::make_pair(i, j++);
      Index index = func->getVarIndexBase();
      for (auto& typeCount : numLocalsByType) {
        if (type == typeCount.first) {
          mappedLocals[fullIndex] = index + currLocalsByType[typeCount.first];
          currLocalsByType[type]++;
          break;
        }
        index += typeCount.second;
      }
    }
  }
  setScratchLocals();
  o << U32LEB(numLocalsByType.size());
  for (auto& typeCount : numLocalsByType) {
    o << U32LEB(typeCount.second) << binaryType(typeCount.first);
  }
}

void BinaryInstWriter::countScratchLocals() {
  // Add a scratch register in `numLocalsByType` for each type of
  // tuple.extract with nonzero index present.
  FindAll<TupleExtract> extracts(func->body);
  for (auto* extract : extracts.list) {
    if (extract->type != Type::unreachable && extract->index != 0) {
      scratchLocals[extract->type] = 0;
    }
  }
  for (auto t : scratchLocals) {
    numLocalsByType[t.first]++;
  }
}

void BinaryInstWriter::setScratchLocals() {
  Index index = func->getVarIndexBase();
  for (auto& typeCount : numLocalsByType) {
    index += typeCount.second;
    if (scratchLocals.find(typeCount.first) != scratchLocals.end()) {
      scratchLocals[typeCount.first] = index - 1;
    }
  }
}

void BinaryInstWriter::emitMemoryAccess(size_t alignment,
                                        size_t bytes,
                                        uint32_t offset) {
  o << U32LEB(Log2(alignment ? alignment : bytes));
  o << U32LEB(offset);
}

int32_t BinaryInstWriter::getBreakIndex(Name name) { // -1 if not found
  for (int i = breakStack.size() - 1; i >= 0; i--) {
    if (breakStack[i] == name) {
      return breakStack.size() - 1 - i;
    }
  }
  WASM_UNREACHABLE("break index not found");
}

void StackIRGenerator::emit(Expression* curr) {
  StackInst* stackInst = nullptr;
  if (curr->is<Block>()) {
    stackInst = makeStackInst(StackInst::BlockBegin, curr);
  } else if (curr->is<If>()) {
    stackInst = makeStackInst(StackInst::IfBegin, curr);
  } else if (curr->is<Loop>()) {
    stackInst = makeStackInst(StackInst::LoopBegin, curr);
  } else if (curr->is<Try>()) {
    stackInst = makeStackInst(StackInst::TryBegin, curr);
  } else {
    stackInst = makeStackInst(curr);
  }
  stackIR.push_back(stackInst);
}

void StackIRGenerator::emitScopeEnd(Expression* curr) {
  StackInst* stackInst = nullptr;
  if (curr->is<Block>()) {
    stackInst = makeStackInst(StackInst::BlockEnd, curr);
  } else if (curr->is<If>()) {
    stackInst = makeStackInst(StackInst::IfEnd, curr);
  } else if (curr->is<Loop>()) {
    stackInst = makeStackInst(StackInst::LoopEnd, curr);
  } else if (curr->is<Try>()) {
    stackInst = makeStackInst(StackInst::TryEnd, curr);
  } else {
    WASM_UNREACHABLE("unexpected expr type");
  }
  stackIR.push_back(stackInst);
}

StackInst* StackIRGenerator::makeStackInst(StackInst::Op op,
                                           Expression* origin) {
  auto* ret = allocator.alloc<StackInst>();
  ret->op = op;
  ret->origin = origin;
  auto stackType = origin->type;
  if (origin->is<Block>() || origin->is<Loop>() || origin->is<If>() ||
      origin->is<Try>()) {
    if (stackType == Type::unreachable) {
      // There are no unreachable blocks, loops, or ifs. we emit extra
      // unreachables to fix that up, so that they are valid as having none
      // type.
      stackType = Type::none;
    } else if (op != StackInst::BlockEnd && op != StackInst::IfEnd &&
               op != StackInst::LoopEnd && op != StackInst::TryEnd) {
      // If a concrete type is returned, we mark the end of the construct has
      // having that type (as it is pushed to the value stack at that point),
      // other parts are marked as none).
      stackType = Type::none;
    }
  }
  ret->type = stackType;
  return ret;
}

void StackIRToBinaryWriter::write() {
  writer.mapLocalsAndEmitHeader();
  for (auto* inst : *func->stackIR) {
    if (!inst) {
      continue; // a nullptr is just something we can skip
    }
    switch (inst->op) {
      case StackInst::Basic:
      case StackInst::BlockBegin:
      case StackInst::IfBegin:
      case StackInst::LoopBegin:
      case StackInst::TryBegin: {
        writer.visit(inst->origin);
        break;
      }
      case StackInst::BlockEnd:
      case StackInst::IfEnd:
      case StackInst::LoopEnd:
      case StackInst::TryEnd: {
        writer.emitScopeEnd(inst->origin);
        break;
      }
      case StackInst::IfElse: {
        writer.emitIfElse(inst->origin->cast<If>());
        break;
      }
      case StackInst::Catch: {
        writer.emitCatch(inst->origin->cast<Try>());
        break;
      }
      default:
        WASM_UNREACHABLE("unexpected op");
    }
  }
  writer.emitFunctionEnd();
}

} // namespace wasm
