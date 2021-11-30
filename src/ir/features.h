/*
 * Copyright 2018 WebAssembly Community Group participants
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

#ifndef wasm_ir_features_h
#define wasm_ir_features_h

#include <ir/iteration.h>
#include <wasm-binary.h>
#include <wasm-traversal.h>
#include <wasm.h>

namespace wasm::Features {

inline FeatureSet get(UnaryOp op) {
  FeatureSet ret;
  switch (op) {
    case TruncSatSFloat32ToInt32:
    case TruncSatUFloat32ToInt32:
    case TruncSatSFloat64ToInt32:
    case TruncSatUFloat64ToInt32:
    case TruncSatSFloat32ToInt64:
    case TruncSatUFloat32ToInt64:
    case TruncSatSFloat64ToInt64:
    case TruncSatUFloat64ToInt64: {
      ret.setTruncSat();
      break;
    }
    case SplatVecI8x16:
    case SplatVecI16x8:
    case SplatVecI32x4:
    case SplatVecI64x2:
    case SplatVecF32x4:
    case SplatVecF64x2:
    case NotVec128:
    case NegVecI8x16:
    case AllTrueVecI8x16:
    case NegVecI16x8:
    case AllTrueVecI16x8:
    case NegVecI32x4:
    case AllTrueVecI32x4:
    case NegVecI64x2:
    case AbsVecF32x4:
    case NegVecF32x4:
    case SqrtVecF32x4:
    case AbsVecF64x2:
    case NegVecF64x2:
    case SqrtVecF64x2:
    case TruncSatSVecF32x4ToVecI32x4:
    case TruncSatUVecF32x4ToVecI32x4:
    case ConvertSVecI32x4ToVecF32x4:
    case ConvertUVecI32x4ToVecF32x4: {
      ret.setSIMD();
      break;
    }
    case ExtendS8Int32:
    case ExtendS16Int32:
    case ExtendS8Int64:
    case ExtendS16Int64:
    case ExtendS32Int64: {
      ret.setSignExt();
      break;
    }
    default: {}
  }
  return ret;
}

inline FeatureSet get(BinaryOp op) {
  FeatureSet ret;
  switch (op) {
    case EqVecI8x16:
    case NeVecI8x16:
    case LtSVecI8x16:
    case LtUVecI8x16:
    case GtSVecI8x16:
    case GtUVecI8x16:
    case LeSVecI8x16:
    case LeUVecI8x16:
    case GeSVecI8x16:
    case GeUVecI8x16:
    case EqVecI16x8:
    case NeVecI16x8:
    case LtSVecI16x8:
    case LtUVecI16x8:
    case GtSVecI16x8:
    case GtUVecI16x8:
    case LeSVecI16x8:
    case LeUVecI16x8:
    case GeSVecI16x8:
    case GeUVecI16x8:
    case EqVecI32x4:
    case NeVecI32x4:
    case LtSVecI32x4:
    case LtUVecI32x4:
    case GtSVecI32x4:
    case GtUVecI32x4:
    case LeSVecI32x4:
    case LeUVecI32x4:
    case GeSVecI32x4:
    case GeUVecI32x4:
    case EqVecF32x4:
    case NeVecF32x4:
    case LtVecF32x4:
    case GtVecF32x4:
    case LeVecF32x4:
    case GeVecF32x4:
    case EqVecF64x2:
    case NeVecF64x2:
    case LtVecF64x2:
    case GtVecF64x2:
    case LeVecF64x2:
    case GeVecF64x2:
    case AndVec128:
    case OrVec128:
    case XorVec128:
    case AddVecI8x16:
    case AddSatSVecI8x16:
    case AddSatUVecI8x16:
    case SubVecI8x16:
    case SubSatSVecI8x16:
    case SubSatUVecI8x16:
    case AddVecI16x8:
    case AddSatSVecI16x8:
    case AddSatUVecI16x8:
    case SubVecI16x8:
    case SubSatSVecI16x8:
    case SubSatUVecI16x8:
    case MulVecI16x8:
    case AddVecI32x4:
    case SubVecI32x4:
    case MulVecI32x4:
    case AddVecI64x2:
    case SubVecI64x2:
    case AddVecF32x4:
    case SubVecF32x4:
    case MulVecF32x4:
    case DivVecF32x4:
    case MinVecF32x4:
    case MaxVecF32x4:
    case AddVecF64x2:
    case SubVecF64x2:
    case MulVecF64x2:
    case DivVecF64x2:
    case MinVecF64x2:
    case MaxVecF64x2: {
      ret.setSIMD();
      break;
    }
    default: {}
  }
  return ret;
}

} // namespace wasm::Features

#endif // wasm_ir_features_h
