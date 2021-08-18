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

#include <limits>

#include "optimizer.h"
#include "support/safe_integer.h"

using namespace cashew;

IString JS_FLOAT_ZERO;

IString SIMD_INT8X16_CHECK("SIMD_Int8x16_check");
IString SIMD_INT16X8_CHECK("SIMD_Int16x8_check");
IString SIMD_INT32X4_CHECK("SIMD_Int32x4_check");
IString SIMD_FLOAT32X4_CHECK("SIMD_Float32x4_check");
IString SIMD_FLOAT64X2_CHECK("SIMD_Float64x2_check");
IString TEMP_RET0("tempRet0");

int parseInt(const char* str) {
  int ret = *str - '0';
  while (*(++str)) {
    ret *= 10;
    ret += *str - '0';
  }
  return ret;
}

HeapInfo parseHeap(const char* name) {
  HeapInfo ret;
  if (name[0] != 'H' || name[1] != 'E' || name[2] != 'A' || name[3] != 'P') {
    ret.valid = false;
    return ret;
  }
  ret.valid = true;
  ret.unsign = name[4] == 'U';
  ret.floaty = name[4] == 'F';
  ret.bits = parseInt(name + (ret.unsign || ret.floaty ? 5 : 4));
  ret.type = !ret.floaty ? JS_INT : (ret.bits == 64 ? JS_DOUBLE : JS_FLOAT);
  return ret;
}

JsType detectType(Ref node,
                  JsData* jsData,
                  bool inVarDef,
                  IString minifiedFround,
                  bool allowI64) {
  if (node->isString()) {
    if (jsData) {
      JsType ret = jsData->getType(node->getCString());
      if (ret != JS_NONE) {
        return ret;
      }
    }
    if (!inVarDef) {
      if (node == INF || node == NaN) {
        return JS_DOUBLE;
      }
      if (node == TEMP_RET0) {
        return JS_INT;
      }
      return JS_NONE;
    }
    // We are in a variable definition, where Math_fround(0) optimized into a
    // global constant becomes f0 = Math_fround(0)
    if (JS_FLOAT_ZERO.isNull()) {
      JS_FLOAT_ZERO = node->getIString();
    } else {
      assert(node == JS_FLOAT_ZERO);
    }
    return JS_FLOAT;
  }
  if (node->isNumber()) {
    if (!wasm::isInteger(node->getNumber())) {
      return JS_DOUBLE;
    }
    return JS_INT;
  }
  switch (node[0]->getCString()[0]) {
    case 'u': {
      if (node[0] == UNARY_PREFIX) {
        switch (node[1]->getCString()[0]) {
          case '+':
            return JS_DOUBLE;
          case '-':
            return detectType(
              node[2], jsData, inVarDef, minifiedFround, allowI64);
          case '!':
          case '~':
            return JS_INT;
        }
        break;
      }
      break;
    }
    case 'c': {
      if (node[0] == CALL) {
        if (node[1]->isString()) {
          IString name = node[1]->getIString();
          if (name == MATH_FROUND || name == minifiedFround) {
            return JS_FLOAT;
          } else if (allowI64 && (name == INT64 || name == INT64_CONST)) {
            return JS_INT64;
          } else if (name == SIMD_FLOAT32X4 || name == SIMD_FLOAT32X4_CHECK) {
            return JS_FLOAT32X4;
          } else if (name == SIMD_FLOAT64X2 || name == SIMD_FLOAT64X2_CHECK) {
            return JS_FLOAT64X2;
          } else if (name == SIMD_INT8X16 || name == SIMD_INT8X16_CHECK) {
            return JS_INT8X16;
          } else if (name == SIMD_INT16X8 || name == SIMD_INT16X8_CHECK) {
            return JS_INT16X8;
          } else if (name == SIMD_INT32X4 || name == SIMD_INT32X4_CHECK) {
            return JS_INT32X4;
          }
        }
        return JS_NONE;
      } else if (node[0] == CONDITIONAL) {
        return detectType(node[2], jsData, inVarDef, minifiedFround, allowI64);
      }
      break;
    }
    case 'b': {
      if (node[0] == BINARY) {
        switch (node[1]->getCString()[0]) {
          case '+':
          case '-':
          case '*':
          case '/':
          case '%':
            return detectType(
              node[2], jsData, inVarDef, minifiedFround, allowI64);
          case '|':
          case '&':
          case '^':
          case '<':
          case '>': // handles <<, >>, >>=, <=, >=
          case '=':
          case '!': { // handles ==, !=
            return JS_INT;
          }
        }
      }
      break;
    }
    case 's': {
      if (node[0] == SEQ) {
        return detectType(node[2], jsData, inVarDef, minifiedFround, allowI64);
      } else if (node[0] == SUB) {
        assert(node[1]->isString());
        HeapInfo info = parseHeap(node[1][1]->getCString());
        if (info.valid) {
          return JS_NONE;
        }
        return info.floaty ? JS_DOUBLE : JS_INT; // XXX JS_FLOAT?
      }
      break;
    }
  }
  // dump("horrible", node);
  // assert(0);
  return JS_NONE;
}

static void abort_on(Ref node) {
  node->stringify(std::cerr);
  std::cerr << '\n';
  abort();
}

JsSign detectSign(Ref node, IString minifiedFround) {
  if (node->isString()) {
    return JS_FLEXIBLE;
  }
  if (node->isNumber()) {
    double value = node->getNumber();
    if (value < 0) {
      return JS_SIGNED;
    }
    if (value > uint32_t(-1) || !wasm::isInteger(value)) {
      return JS_NONSIGNED;
    }
    if (wasm::isSInteger32(value)) {
      return JS_FLEXIBLE;
    }
    return JS_UNSIGNED;
  }
  IString type = node[0]->getIString();
  if (type == BINARY) {
    IString op = node[1]->getIString();
    switch (op.str[0]) {
      case '>': {
        if (op == TRSHIFT) {
          return JS_UNSIGNED;
        }
        [[fallthrough]];
      }
      case '|':
      case '&':
      case '^':
      case '<':
      case '=':
      case '!':
        return JS_SIGNED;
      case '+':
      case '-':
        return JS_FLEXIBLE;
      case '*':
      case '/':
      case '%':
        return JS_NONSIGNED; // without a coercion, these are double
      default:
        abort_on(node);
    }
  } else if (type == UNARY_PREFIX) {
    IString op = node[1]->getIString();
    switch (op.str[0]) {
      case '-':
        return JS_FLEXIBLE;
      case '+':
        return JS_NONSIGNED; // XXX double
      case '~':
        return JS_SIGNED;
      default:
        abort_on(node);
    }
  } else if (type == CONDITIONAL) {
    return detectSign(node[2], minifiedFround);
  } else if (type == CALL) {
    if (node[1]->isString() &&
        (node[1] == MATH_FROUND || node[1] == minifiedFround)) {
      return JS_NONSIGNED;
    }
  } else if (type == SEQ) {
    return detectSign(node[2], minifiedFround);
  }
  abort_on(node);
  abort(); // avoid warning
}

Ref makeJsCoercedZero(JsType type) {
  switch (type) {
    case JS_INT:
      return ValueBuilder::makeNum(0);
      break;
    case JS_DOUBLE:
      return ValueBuilder::makeUnary(PLUS, ValueBuilder::makeNum(0));
      break;
    case JS_FLOAT: {
      if (!JS_FLOAT_ZERO.isNull()) {
        return ValueBuilder::makeName(JS_FLOAT_ZERO);
      } else {
        return ValueBuilder::makeCall(MATH_FROUND, ValueBuilder::makeNum(0));
      }
      break;
    }
    case JS_FLOAT32X4: {
      return ValueBuilder::makeCall(SIMD_FLOAT32X4,
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0));
      break;
    }
    case JS_FLOAT64X2: {
      return ValueBuilder::makeCall(
        SIMD_FLOAT64X2, ValueBuilder::makeNum(0), ValueBuilder::makeNum(0));
      break;
    }
    case JS_INT8X16: {
      return ValueBuilder::makeCall(SIMD_INT8X16,
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0));
      break;
    }
    case JS_INT16X8: {
      return ValueBuilder::makeCall(SIMD_INT16X8,
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0));
      break;
    }
    case JS_INT32X4: {
      return ValueBuilder::makeCall(SIMD_INT32X4,
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0),
                                    ValueBuilder::makeNum(0));
      break;
    }
    default:
      assert(0);
  }
  abort();
}

Ref makeJsCoercion(Ref node, JsType type) {
  switch (type) {
    case JS_INT:
      return ValueBuilder::makeBinary(node, OR, ValueBuilder::makeNum(0));
    case JS_DOUBLE:
      return ValueBuilder::makeUnary(PLUS, node);
    case JS_FLOAT:
      return ValueBuilder::makeCall(MATH_FROUND, node);
    case JS_FLOAT32X4:
      return ValueBuilder::makeCall(SIMD_FLOAT32X4_CHECK, node);
    case JS_FLOAT64X2:
      return ValueBuilder::makeCall(SIMD_FLOAT64X2_CHECK, node);
    case JS_INT8X16:
      return ValueBuilder::makeCall(SIMD_INT8X16_CHECK, node);
    case JS_INT16X8:
      return ValueBuilder::makeCall(SIMD_INT16X8_CHECK, node);
    case JS_INT32X4:
      return ValueBuilder::makeCall(SIMD_INT32X4_CHECK, node);
    case JS_NONE:
    default:
      // non-validating code, emit nothing XXX this is dangerous, we should only
      // allow this when we know we are not validating
      return node;
  }
}

Ref makeSigning(Ref node, JsSign sign) {
  assert(sign == JS_SIGNED || sign == JS_UNSIGNED);
  return ValueBuilder::makeBinary(
    node, sign == JS_SIGNED ? OR : TRSHIFT, ValueBuilder::makeNum(0));
}
