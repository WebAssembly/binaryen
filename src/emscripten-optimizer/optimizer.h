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

#ifndef wasm_optimizer_h
#define wasm_optimizer_h

#include "simple_ast.h"

extern bool preciseF32, receiveJSON, emitJSON, minifyWhitespace, last;

extern cashew::Ref extraInfo;

//

enum JsType {
  JS_INT = 0,
  JS_DOUBLE,
  JS_FLOAT,
  JS_FLOAT32X4,
  JS_FLOAT64X2,
  JS_INT8X16,
  JS_INT16X8,
  JS_INT32X4,
  JS_INT64,
  JS_NONE // number of types
};

struct JsData;

JsType detectType(cashew::Ref node,
                  JsData* jsData = nullptr,
                  bool inVarDef = false,
                  cashew::IString minifiedFround = cashew::IString(),
                  bool allowI64 = false);

struct JsData {
  struct Local {
    Local() = default;
    Local(JsType type, bool param) : type(type), param(param) {}
    JsType type;
    bool param; // false if a var
  };
  typedef std::unordered_map<cashew::IString, Local> Locals;

  Locals locals;
  std::vector<cashew::IString> params; // in order
  std::vector<cashew::IString> vars;   // in order
  JsType ret;

  cashew::Ref func;

  JsType getType(const cashew::IString& name) {
    auto ret = locals.find(name);
    if (ret != locals.end()) {
      return ret->second.type;
    }
    return JS_NONE;
  }
  void setType(const cashew::IString& name, JsType type) {
    locals[name].type = type;
  }

  bool isLocal(const cashew::IString& name) { return locals.count(name) > 0; }
  bool isParam(const cashew::IString& name) {
    return isLocal(name) && locals[name].param;
  }
  bool isVar(const cashew::IString& name) {
    return isLocal(name) && !locals[name].param;
  }

  // if you want to fill in the data yourself
  JsData() = default;
  // if you want to read data from f, and modify it as you go (parallel to
  // denormalize)
  JsData(cashew::Ref f);

  void denormalize();

  void addParam(cashew::IString name, JsType type) {
    locals[name] = Local(type, true);
    params.push_back(name);
  }
  void addVar(cashew::IString name, JsType type) {
    locals[name] = Local(type, false);
    vars.push_back(name);
  }

  void deleteVar(cashew::IString name) {
    locals.erase(name);
    for (size_t i = 0; i < vars.size(); i++) {
      if (vars[i] == name) {
        vars.erase(vars.begin() + i);
        break;
      }
    }
  }
};

extern cashew::IString JS_FLOAT_ZERO;

extern cashew::IString SIMD_INT8X16_CHECK;
extern cashew::IString SIMD_INT16X8_CHECK;
extern cashew::IString SIMD_INT32X4_CHECK;
extern cashew::IString SIMD_FLOAT32X4_CHECK;
extern cashew::IString SIMD_FLOAT64X2_CHECK;

int parseInt(const char* str);

struct HeapInfo {
  bool valid, unsign, floaty;
  int bits;
  JsType type;
};

HeapInfo parseHeap(const char* name);

enum JsSign {
  // small constants can be signed or unsigned, variables are also flexible
  JS_FLEXIBLE = 0,
  JS_SIGNED = 1,
  JS_UNSIGNED = 2,
  JS_NONSIGNED = 3,
};

extern JsSign detectSign(cashew::Ref node, cashew::IString minifiedFround);

cashew::Ref makeAsmCoercedZero(JsType type);
cashew::Ref makeAsmCoercion(cashew::Ref node, JsType type);

cashew::Ref makeSigning(cashew::Ref node, JsSign sign);

#endif // wasm_optimizer_h
