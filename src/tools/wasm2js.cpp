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
// wasm2js console tool
//

#include "wasm2js.h"
#include "optimization-options.h"
#include "pass.h"
#include "support/colors.h"
#include "support/command-line.h"
#include "support/file.h"
#include "wasm-s-parser.h"
#include "wasm2js.h"

using namespace cashew;
using namespace wasm;

// helpers

namespace {

static void optimizeWasm(Module& wasm, PassOptions options) {
  // Perform various optimizations that will be good for JS, but would not be
  // great for wasm in general
  struct OptimizeForJS : public WalkerPass<PostWalker<OptimizeForJS>> {
    bool isFunctionParallel() override { return true; }

    Pass* create() override { return new OptimizeForJS; }

    void visitBinary(Binary* curr) {
      // x - -c (where c is a constant) is larger than x + c, in js (but not
      // necessarily in wasm, where LEBs prefer negatives).
      if (curr->op == SubInt32) {
        if (auto* c = curr->right->dynCast<Const>()) {
          if (c->value.geti32() < 0) {
            curr->op = AddInt32;
            c->value = c->value.neg();
          }
        }
      }
    }
  };

  PassRunner runner(&wasm, options);
  runner.add<OptimizeForJS>();
  runner.run();
}

template<typename T> static void printJS(Ref ast, T& output) {
  JSPrinter jser(true, true, ast);
  jser.printAst();
  output << jser.buffer << std::endl;
}

// Traversals

struct TraverseInfo {
  TraverseInfo() = default;
  TraverseInfo(Ref node) : node(node) {
    assert(node.get());
    if (node->isArray()) {
      for (size_t i = 0; i < node->size(); i++) {
        maybeAdd(node[i]);
      }
    } else if (node->isAssign()) {
      auto assign = node->asAssign();
      maybeAdd(assign->target());
      maybeAdd(assign->value());
    } else if (node->isAssignName()) {
      auto assign = node->asAssignName();
      maybeAdd(assign->value());
    } else {
      // no children
    }
  }
  Ref node;
  bool scanned = false;
  std::vector<Ref> children;

private:
  void maybeAdd(Ref child) {
    if (child.get()) {
      children.push_back(child);
    }
  }
};

// Traverse, calling visit after the children
static void traversePrePost(Ref node,
                            std::function<void(Ref)> visitPre,
                            std::function<void(Ref)> visitPost) {
  std::vector<TraverseInfo> stack;
  stack.push_back(TraverseInfo(node));
  while (!stack.empty()) {
    TraverseInfo& back = stack.back();
    if (!back.scanned) {
      back.scanned = true;
      // This is the first time we see this.
      visitPre(back.node);
      for (auto child : back.children) {
        stack.emplace_back(child);
      }
      continue;
    }
    // Time to post-visit the node itself
    auto node = back.node;
    stack.pop_back();
    visitPost(node);
  }
}

static void traversePost(Ref node, std::function<void(Ref)> visit) {
  traversePrePost(node, [](Ref node) {}, visit);
}

#if 0
static void replaceInPlace(Ref target, Ref value) {
  assert(target->isArray() && value->isArray());
  target->resize(value->size());
  for (size_t i = 0; i < value->size(); i++) {
    target[i] = value[i];
  }
}
#endif

static void optimizeJS(Ref ast) {
  // Helpers

  auto isOrZero = [](Ref node) {
    return node->isArray() && !node->empty() && node[0] == BINARY &&
           node[1] == OR && node[3]->isNumber() && node[3]->getNumber() == 0;
  };

  auto isPlus = [](Ref node) {
    return node->isArray() && !node->empty() && node[0] == UNARY_PREFIX &&
           node[1] == PLUS;
  };

  auto isFround = [](Ref node) {
    return node->isArray() && !node->empty() && node[0] == cashew::CALL &&
           node[1] == MATH_FROUND;
  };

  auto isBitwise = [](Ref node) {
    if (node->isArray() && !node->empty() && node[0] == BINARY) {
      auto op = node[1];
      return op == OR || op == AND || op == XOR || op == RSHIFT ||
             op == TRSHIFT || op == LSHIFT;
    }
    return false;
  };

  auto isUnary = [](Ref node, IString op) {
    return node->isArray() && !node->empty() && node[0] == UNARY_PREFIX &&
           node[1] == op;
  };

  auto isConstantBitwise = [](Ref node, IString op, int num) {
    return node->isArray() && !node->empty() && node[0] == BINARY &&
           node[1] == op && node[3]->isNumber() && node[3]->getNumber() == num;
  };

  auto isWhile = [](Ref node) {
    return node->isArray() && !node->empty() && node[0] == WHILE;
  };

  auto isDo = [](Ref node) {
    return node->isArray() && !node->empty() && node[0] == DO;
  };

  auto isIf = [](Ref node) {
    return node->isArray() && !node->empty() && node[0] == IF;
  };

  auto removeOrZero = [&](Ref node) {
    while (isOrZero(node)) {
      node = node[2];
    }
    return node;
  };

  auto removePlus = [&](Ref node) {
    while (isPlus(node)) {
      node = node[2];
    }
    return node;
  };

  auto removePlusAndFround = [&](Ref node) {
    while (1) {
      if (isFround(node)) {
        node = node[2][0];
      } else if (isPlus(node)) {
        node = node[2];
      } else {
        break;
      }
    }
    return node;
  };

  auto getHeapFromAccess = [](Ref node) { return node[1]->getIString(); };

  auto setHeapOnAccess = [](Ref node, IString heap) {
    node[1] = ValueBuilder::makeName(heap);
  };

  auto isIntegerHeap = [](IString heap) {
    return heap == HEAP8 || heap == HEAPU8 || heap == HEAP16 ||
           heap == HEAPU16 || heap == HEAP32 || heap == HEAPU32;
  };

  auto isFloatHeap = [](IString heap) {
    return heap == HEAPF32 || heap == HEAPF64;
  };

  auto isHeapAccess = [&](Ref node) {
    if (node->isArray() && !node->empty() && node[0] == SUB &&
        node[1]->isString()) {
      auto heap = getHeapFromAccess(node);
      return isIntegerHeap(heap) || isFloatHeap(heap);
    }
    return false;
  };

  auto optimizeBoolean = [&](Ref node) {
    // x ^ 1  =>  !x
    if (isConstantBitwise(node, XOR, 1)) {
      node[0]->setString(UNARY_PREFIX);
      node[1]->setString(L_NOT);
      node[3]->setNull();
    }
    return node;
  };

  // Optimizations

  // Pre-simplification
  traversePost(ast, [&](Ref node) {
    // x >> 0  =>  x | 0
    if (isConstantBitwise(node, RSHIFT, 0)) {
      node[1]->setString(OR);
    }
  });

  traversePost(ast, [&](Ref node) {
    if (isBitwise(node)) {
      // x | 0 going into a bitwise op => skip the | 0
      node[2] = removeOrZero(node[2]);
      node[3] = removeOrZero(node[3]);
      // x | 0 | 0  =>  x | 0
      if (isOrZero(node)) {
        if (isBitwise(node[2])) {
          auto child = node[2];
          node[1] = child[1];
          node[2] = child[2];
          node[3] = child[3];
        }
      }
      // A load into an & may allow using a simpler heap, e.g. HEAPU8[..] & 1
      // (a load of a boolean) may be HEAP8[..] & 1. The signed heaps are more
      // commonly used, so it compresses better, and also they seem to have
      // better performance (perhaps since HEAPU32 is at risk of not being a
      // smallint).
      if (node[1] == AND && isHeapAccess(node[2])) {
        auto heap = getHeapFromAccess(node[2]);
        if (isConstantBitwise(node, AND, 1)) {
          if (heap == HEAPU8) {
            setHeapOnAccess(node[2], HEAP8);
          } else if (heap == HEAPU16) {
            setHeapOnAccess(node[2], HEAP16);
          }
        }
      }
      // Pre-compute constant [op] constant, which the lowering can generate
      // in loads etc.
      if (node[2]->isNumber() && node[3]->isNumber()) {
        int32_t left = node[2]->getNumber();
        int32_t right = node[3]->getNumber();
        if (node[1] == OR) {
          node->setNumber(left | right);
        } else if (node[1] == AND) {
          node->setNumber(left & right);
        } else if (node[1] == XOR) {
          node->setNumber(left ^ right);
        } else if (node[1] == LSHIFT) {
          node->setNumber(left << (right & 31));
        } else if (node[1] == RSHIFT) {
          node->setNumber(int32_t(left) >> int32_t(right & 31));
        } else if (node[1] == TRSHIFT) {
          node->setNumber(uint32_t(left) >> uint32_t(right & 31));
        }
        return;
      }
    }
    // +(+x) => +x
    else if (isPlus(node)) {
      node[2] = removePlus(node[2]);
    }
    // +(+x) => +x
    else if (isFround(node)) {
      node[2] = removePlusAndFround(node[2]);
    } else if (isUnary(node, L_NOT)) {
      node[2] = optimizeBoolean(node[2]);
    }
    // Assignment into a heap coerces.
    else if (node->isAssign()) {
      auto assign = node->asAssign();
      auto target = assign->target();
      if (isHeapAccess(target)) {
        auto heap = getHeapFromAccess(target);
        if (isIntegerHeap(heap)) {
          if (heap == HEAP8 || heap == HEAPU8) {
            while (isOrZero(assign->value()) ||
                   isConstantBitwise(assign->value(), AND, 255)) {
              assign->value() = assign->value()[2];
            }
          } else if (heap == HEAP16 || heap == HEAPU16) {
            while (isOrZero(assign->value()) ||
                   isConstantBitwise(assign->value(), AND, 65535)) {
              assign->value() = assign->value()[2];
            }
          } else {
            assert(heap == HEAP32 || heap == HEAPU32);
            assign->value() = removeOrZero(assign->value());
          }
        } else {
          assert(isFloatHeap(heap));
          if (heap == HEAPF32) {
            assign->value() = removePlusAndFround(assign->value());
          } else {
            assign->value() = removePlus(assign->value());
          }
        }
      }
    } else if (isWhile(node) || isDo(node) || isIf(node)) {
      node[1] = optimizeBoolean(node[1]);
    }
  });

  // Remove unnecessary break/continue labels, when referring to the top level.

  std::vector<Ref> breakCapturers;
  std::vector<Ref> continueCapturers;
  std::unordered_map<IString, Ref>
    labelToValue;                      // maps the label to the loop/etc.
  std::unordered_set<Value*> labelled; // all things with a label on them.
  Value INVALID;
  traversePrePost(
    ast,
    [&](Ref node) {
      if (node->isArray() && !node->empty()) {
        if (node[0] == LABEL) {
          auto label = node[1]->getIString();
          labelToValue[label] = node[2];
          labelled.insert(node[2].get());
        } else if (node[0] == WHILE || node[0] == DO || node[0] == FOR) {
          breakCapturers.push_back(node);
          continueCapturers.push_back(node);
        } else if (node[0] == cashew::BLOCK) {
          if (labelled.count(node.get())) {
            // Cannot break to a block without the label.
            breakCapturers.push_back(Ref(&INVALID));
          }
        } else if (node[0] == SWITCH) {
          breakCapturers.push_back(node);
        }
      }
    },
    [&](Ref node) {
      if (node->isArray() && !node->empty()) {
        if (node[0] == LABEL) {
          auto label = node[1]->getIString();
          labelToValue.erase(label);
          labelled.erase(node[2].get());
        } else if (node[0] == WHILE || node[0] == DO || node[0] == FOR) {
          breakCapturers.pop_back();
          continueCapturers.pop_back();
        } else if (node[0] == cashew::BLOCK) {
          if (labelled.count(node.get())) {
            breakCapturers.pop_back();
          }
        } else if (node[0] == SWITCH) {
          breakCapturers.pop_back();
        } else if (node[0] == BREAK || node[0] == CONTINUE) {
          if (!node[1]->isNull()) {
            auto label = node[1]->getIString();
            assert(labelToValue.count(label));
            auto& capturers =
              node[0] == BREAK ? breakCapturers : continueCapturers;
            assert(!capturers.empty());
            if (capturers.back() == labelToValue[label]) {
              // Success, the break/continue goes exactly where we would if we
              // didn't have the label!
              node[1]->setNull();
            }
          }
        }
      }
    });
}

static void emitWasm(Module& wasm,
                     Output& output,
                     Wasm2JSBuilder::Flags flags,
                     PassOptions options,
                     Name name) {
  if (options.optimizeLevel > 0) {
    optimizeWasm(wasm, options);
  }
  Wasm2JSBuilder wasm2js(flags, options);
  auto js = wasm2js.processWasm(&wasm, name);
  if (options.optimizeLevel >= 2) {
    optimizeJS(js);
  }
  Wasm2JSGlue glue(wasm, output, flags, name);
  glue.emitPre();
  printJS(js, output);
  glue.emitPost();
}

class AssertionEmitter {
public:
  AssertionEmitter(Element& root,
                   SExpressionWasmBuilder& sexpBuilder,
                   Output& out,
                   Wasm2JSBuilder::Flags flags,
                   PassOptions options)
    : root(root), sexpBuilder(sexpBuilder), out(out), flags(flags),
      options(options) {}

  void emit();

private:
  Element& root;
  SExpressionWasmBuilder& sexpBuilder;
  Output& out;
  Wasm2JSBuilder::Flags flags;
  PassOptions options;
  Module tempAllocationModule;

  Ref emitAssertReturnFunc(Builder& wasmBuilder,
                           Element& e,
                           Name testFuncName,
                           Name asmModule);
  Ref emitAssertReturnNanFunc(Builder& wasmBuilder,
                              Element& e,
                              Name testFuncName,
                              Name asmModule);
  Ref emitAssertTrapFunc(Builder& wasmBuilder,
                         Element& e,
                         Name testFuncName,
                         Name asmModule);
  bool isAssertHandled(Element& e);
  void fixCalls(Ref asmjs, Name asmModule);

  Ref processFunction(Function* func) {
    Wasm2JSBuilder sub(flags, options);
    return sub.processStandaloneFunction(&tempAllocationModule, func);
  }

  void emitFunction(Ref func) {
    JSPrinter jser(true, true, func);
    jser.printAst();
    out << jser.buffer << std::endl;
  }
};

Ref AssertionEmitter::emitAssertReturnFunc(Builder& wasmBuilder,
                                           Element& e,
                                           Name testFuncName,
                                           Name asmModule) {
  Expression* actual = sexpBuilder.parseExpression(e[1]);
  Expression* body = nullptr;
  if (e.size() == 2) {
    if (actual->type == none) {
      body = wasmBuilder.blockify(actual,
                                  wasmBuilder.makeConst(Literal(uint32_t(1))));
    } else {
      body = actual;
    }
  } else if (e.size() == 3) {
    Expression* expected = sexpBuilder.parseExpression(e[2]);
    Type resType = expected->type;
    actual->type = resType;
    switch (resType) {
      case i32:
        body = wasmBuilder.makeBinary(EqInt32, actual, expected);
        break;

      case i64:
        body = wasmBuilder.makeCall(
          "i64Equal",
          {actual,
           wasmBuilder.makeCall(WASM_FETCH_HIGH_BITS, {}, i32),
           expected},
          i32);
        break;

      case f32: {
        body = wasmBuilder.makeCall("f32Equal", {actual, expected}, i32);
        break;
      }
      case f64: {
        body = wasmBuilder.makeCall("f64Equal", {actual, expected}, i32);
        break;
      }

      default: {
        std::cerr << "Unhandled type in assert: " << resType << std::endl;
        abort();
      }
    }
  } else {
    assert(false && "Unexpected number of parameters in assert_return");
  }
  std::unique_ptr<Function> testFunc(
    wasmBuilder.makeFunction(testFuncName,
                             std::vector<NameType>{},
                             body->type,
                             std::vector<NameType>{},
                             body));
  Ref jsFunc = processFunction(testFunc.get());
  fixCalls(jsFunc, asmModule);
  emitFunction(jsFunc);
  return jsFunc;
}

Ref AssertionEmitter::emitAssertReturnNanFunc(Builder& wasmBuilder,
                                              Element& e,
                                              Name testFuncName,
                                              Name asmModule) {
  Expression* actual = sexpBuilder.parseExpression(e[1]);
  Expression* body = wasmBuilder.makeCall("isNaN", {actual}, i32);
  std::unique_ptr<Function> testFunc(
    wasmBuilder.makeFunction(testFuncName,
                             std::vector<NameType>{},
                             body->type,
                             std::vector<NameType>{},
                             body));
  Ref jsFunc = processFunction(testFunc.get());
  fixCalls(jsFunc, asmModule);
  emitFunction(jsFunc);
  return jsFunc;
}

Ref AssertionEmitter::emitAssertTrapFunc(Builder& wasmBuilder,
                                         Element& e,
                                         Name testFuncName,
                                         Name asmModule) {
  Name innerFuncName("f");
  Expression* expr = sexpBuilder.parseExpression(e[1]);
  std::unique_ptr<Function> exprFunc(
    wasmBuilder.makeFunction(innerFuncName,
                             std::vector<NameType>{},
                             expr->type,
                             std::vector<NameType>{},
                             expr));
  IString expectedErr = e[2]->str();
  Ref innerFunc = processFunction(exprFunc.get());
  fixCalls(innerFunc, asmModule);
  Ref outerFunc = ValueBuilder::makeFunction(testFuncName);
  outerFunc[3]->push_back(innerFunc);
  Ref tryBlock = ValueBuilder::makeBlock();
  ValueBuilder::appendToBlock(tryBlock, ValueBuilder::makeCall(innerFuncName));
  Ref catchBlock = ValueBuilder::makeBlock();
  ValueBuilder::appendToBlock(
    catchBlock,
    ValueBuilder::makeReturn(ValueBuilder::makeCall(
      ValueBuilder::makeDot(ValueBuilder::makeName(IString("e")),
                            ValueBuilder::makeName(IString("message")),
                            ValueBuilder::makeName(IString("includes"))),
      ValueBuilder::makeString(expectedErr))));
  outerFunc[3]->push_back(ValueBuilder::makeTry(
    tryBlock, ValueBuilder::makeName((IString("e"))), catchBlock));
  outerFunc[3]->push_back(ValueBuilder::makeReturn(ValueBuilder::makeInt(0)));
  emitFunction(outerFunc);
  return outerFunc;
}

bool AssertionEmitter::isAssertHandled(Element& e) {
  return e.isList() && e.size() >= 2 && e[0]->isStr() &&
         (e[0]->str() == Name("assert_return") ||
          e[0]->str() == Name("assert_return_nan") ||
          (flags.pedantic && e[0]->str() == Name("assert_trap"))) &&
         e[1]->isList() && e[1]->size() >= 2 && (*e[1])[0]->isStr() &&
         (*e[1])[0]->str() == Name("invoke");
}

void AssertionEmitter::fixCalls(Ref asmjs, Name asmModule) {
  if (asmjs->isArray()) {
    ArrayStorage& arr = asmjs->getArray();
    for (Ref& r : arr) {
      fixCalls(r, asmModule);
    }
    if (arr.size() > 0 && arr[0]->isString() &&
        arr[0]->getIString() == cashew::CALL) {
      assert(arr.size() >= 2);
      if (arr[1]->getIString() == "f32Equal" ||
          arr[1]->getIString() == "f64Equal" ||
          arr[1]->getIString() == "i64Equal" ||
          arr[1]->getIString() == "isNaN") {
        // ...
      } else if (arr[1]->getIString() == "Math_fround") {
        arr[1]->setString("Math.fround");
      } else {
        Ref fixed = ValueBuilder::makeDot(ValueBuilder::makeName(asmModule),
                                          arr[1]->getIString());
        arr[1]->setArray(fixed->getArray());
      }
    }
  }

  if (asmjs->isAssign()) {
    fixCalls(asmjs->asAssign()->target(), asmModule);
    fixCalls(asmjs->asAssign()->value(), asmModule);
  }
  if (asmjs->isAssignName()) {
    fixCalls(asmjs->asAssignName()->value(), asmModule);
  }
}

void AssertionEmitter::emit() {
  // TODO: nan and infinity shouldn't be needed once literal asm.js code isn't
  // generated
  out << R"(
    var nan = NaN;
    var infinity = Infinity;
  )";

  // When equating floating point values in spec tests we want to use bitwise
  // equality like wasm does. Unfortunately though NaN makes this tricky. JS
  // implementations like Spidermonkey and JSC will canonicalize NaN loads from
  // `Float32Array`, but V8 will not. This means that NaN representations are
  // kind of all over the place and difficult to bitwise equate.
  //
  // To work around this problem we just use a small shim which considers all
  // NaN representations equivalent and otherwise tests for bitwise equality.
  out << R"(
    function f32Equal(a, b) {
       var i = new Int32Array(1);
       var f = new Float32Array(i.buffer);
       f[0] = a;
       var ai = f[0];
       f[0] = b;
       var bi = f[0];

       return (isNaN(a) && isNaN(b)) || a == b;
    }

    function f64Equal(a, b) {
       var i = new Int32Array(2);
       var f = new Float64Array(i.buffer);
       f[0] = a;
       var ai1 = i[0];
       var ai2 = i[1];
       f[0] = b;
       var bi1 = i[0];
       var bi2 = i[1];

       return (isNaN(a) && isNaN(b)) || (ai1 == bi1 && ai2 == bi2);
    }

    function i64Equal(actual_lo, actual_hi, expected_lo, expected_hi) {
       return (actual_lo | 0) == (expected_lo | 0) && (actual_hi | 0) == (expected_hi | 0);
    }
  )";

  Builder wasmBuilder(sexpBuilder.getAllocator());
  Name asmModule = std::string("ret") + ASM_FUNC.str;
  for (size_t i = 0; i < root.size(); ++i) {
    Element& e = *root[i];
    if (e.isList() && e.size() >= 1 && e[0]->isStr() &&
        e[0]->str() == Name("module")) {
      std::stringstream funcNameS;
      funcNameS << ASM_FUNC.c_str() << i;
      std::stringstream moduleNameS;
      moduleNameS << "ret" << ASM_FUNC.c_str() << i;
      Name funcName(funcNameS.str().c_str());
      asmModule = Name(moduleNameS.str().c_str());
      Module wasm;
      SExpressionWasmBuilder builder(wasm, e);
      emitWasm(wasm, out, flags, options, funcName);
      continue;
    }
    if (!isAssertHandled(e)) {
      std::cerr << "skipping " << e << std::endl;
      continue;
    }
    Name testFuncName(IString(("check" + std::to_string(i)).c_str(), false));
    bool isReturn = (e[0]->str() == Name("assert_return"));
    bool isReturnNan = (e[0]->str() == Name("assert_return_nan"));
    Element& testOp = *e[1];
    // Replace "invoke" with "call"
    testOp[0]->setString(IString("call"), false, false);
    // Need to claim dollared to get string as function target
    testOp[1]->setString(testOp[1]->str(), /*dollared=*/true, false);

    if (isReturn) {
      emitAssertReturnFunc(wasmBuilder, e, testFuncName, asmModule);
    } else if (isReturnNan) {
      emitAssertReturnNanFunc(wasmBuilder, e, testFuncName, asmModule);
    } else {
      emitAssertTrapFunc(wasmBuilder, e, testFuncName, asmModule);
    }

    out << "if (!" << testFuncName.str << "()) throw 'assertion failed: " << e
        << "';\n";
  }
}

} // anonymous namespace

// Main

int main(int argc, const char* argv[]) {
  Wasm2JSBuilder::Flags flags;
  OptimizationOptions options("wasm2js",
                              "Transform .wasm/.wast files to asm.js");
  options
    .add("--output",
         "-o",
         "Output file (stdout if not specified)",
         Options::Arguments::One,
         [](Options* o, const std::string& argument) {
           o->extra["output"] = argument;
           Colors::disable();
         })
    .add("--allow-asserts",
         "",
         "Allow compilation of .wast testing asserts",
         Options::Arguments::Zero,
         [&](Options* o, const std::string& argument) {
           flags.allowAsserts = true;
           o->extra["asserts"] = "1";
         })
    .add(
      "--pedantic",
      "",
      "Emulate WebAssembly trapping behavior",
      Options::Arguments::Zero,
      [&](Options* o, const std::string& argument) { flags.pedantic = true; })
    .add(
      "--emscripten",
      "",
      "Emulate the glue in emscripten-compatible form (and not ES6 module "
      "form)",
      Options::Arguments::Zero,
      [&](Options* o, const std::string& argument) { flags.emscripten = true; })
    .add_positional("INFILE",
                    Options::Arguments::One,
                    [](Options* o, const std::string& argument) {
                      o->extra["infile"] = argument;
                    });
  options.parse(argc, argv);
  if (options.debug) {
    flags.debug = true;
  }

  Element* root = nullptr;
  Module wasm;
  Ref js;
  std::unique_ptr<SExpressionParser> sexprParser;
  std::unique_ptr<SExpressionWasmBuilder> sexprBuilder;

  auto& input = options.extra["infile"];
  std::string suffix(".wasm");
  bool binaryInput =
    input.size() >= suffix.size() &&
    input.compare(input.size() - suffix.size(), suffix.size(), suffix) == 0;

  try {
    // If the input filename ends in `.wasm`, then parse it in binary form,
    // otherwise assume it's a `*.wast` file and go from there.
    //
    // Note that we're not using the built-in `ModuleReader` which will also do
    // similar logic here because when testing JS files we use the
    // `--allow-asserts` flag which means we need to parse the extra
    // s-expressions that come at the end of the `*.wast` file after the module
    // is defined.
    if (binaryInput) {
      ModuleReader reader;
      reader.setDebug(options.debug);
      reader.read(input, wasm, "");
      options.applyFeatures(wasm);
    } else {
      auto input(read_file<std::vector<char>>(options.extra["infile"],
                                              Flags::Text,
                                              options.debug ? Flags::Debug
                                                            : Flags::Release));
      if (options.debug) {
        std::cerr << "s-parsing..." << std::endl;
      }
      sexprParser = make_unique<SExpressionParser>(input.data());
      root = sexprParser->root;

      if (options.debug) {
        std::cerr << "w-parsing..." << std::endl;
      }
      sexprBuilder = make_unique<SExpressionWasmBuilder>(wasm, *(*root)[0]);
    }
  } catch (ParseException& p) {
    p.dump(std::cerr);
    Fatal() << "error in parsing input";
  } catch (std::bad_alloc&) {
    Fatal() << "error in building module, std::bad_alloc (possibly invalid "
               "request for silly amounts of memory)";
  }

  if (options.passOptions.validate) {
    if (!WasmValidator().validate(wasm)) {
      WasmPrinter::printModule(&wasm);
      Fatal() << "error in validating input";
    }
  }

  if (options.debug) {
    std::cerr << "j-printing..." << std::endl;
  }
  Output output(options.extra["output"],
                Flags::Text,
                options.debug ? Flags::Debug : Flags::Release);
  if (!binaryInput && options.extra["asserts"] == "1") {
    AssertionEmitter(*root, *sexprBuilder, output, flags, options.passOptions)
      .emit();
  } else {
    emitWasm(wasm, output, flags, options.passOptions, "asmFunc");
  }

  if (options.debug) {
    std::cerr << "done." << std::endl;
  }
}
