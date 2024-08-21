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
#include "parser/wat-parser.h"
#include "pass.h"
#include "support/colors.h"
#include "support/command-line.h"
#include "support/file.h"

using namespace cashew;
using namespace wasm;
using namespace wasm::WATParser;

// helpers

namespace {

static void optimizeWasm(Module& wasm, PassOptions options) {
  // Perform various optimizations that will be good for JS, but would not be
  // great for wasm in general
  struct OptimizeForJS : public WalkerPass<PostWalker<OptimizeForJS>> {
    bool isFunctionParallel() override { return true; }

    std::unique_ptr<Pass> create() override {
      return std::make_unique<OptimizeForJS>();
    }

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
  OptimizeForJS().run(&runner, &wasm);
}

template<typename T> static void printJS(Ref ast, T& output) {
  JSPrinter jser(true, true, ast);
  jser.printAst();
  output << jser.buffer << '\n';
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
  traversePrePost(
    node, [](Ref node) {}, visit);
}

static void replaceInPlace(Ref target, Ref value) {
  assert(target->isArray() && value->isArray());
  target->setSize(value->size());
  for (size_t i = 0; i < value->size(); i++) {
    target[i] = value[i];
  }
}

static void replaceInPlaceIfPossible(Ref target, Ref value) {
  if (target->isArray() && value->isArray()) {
    replaceInPlace(target, value);
  }
}

static void optimizeJS(Ref ast, Wasm2JSBuilder::Flags flags) {
  // Helpers

  auto isBinary = [](Ref node, IString op) {
    return node->isArray() && !node->empty() && node[0] == BINARY &&
           node[1] == op;
  };

  auto isConstantBinary = [&](Ref node, IString op, int num) {
    return isBinary(node, op) && node[3]->isNumber() &&
           node[3]->getNumber() == num;
  };

  auto isOrZero = [&](Ref node) { return isConstantBinary(node, OR, 0); };

  auto isTrshiftZero = [&](Ref node) {
    return isConstantBinary(node, TRSHIFT, 0);
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

  auto isSignedBitwise = [](Ref node) {
    if (node->isArray() && !node->empty() && node[0] == BINARY) {
      auto op = node[1];
      return op == OR || op == AND || op == XOR || op == RSHIFT || op == LSHIFT;
    }
    return false;
  };

  auto isUnary = [](Ref node, IString op) {
    return node->isArray() && !node->empty() && node[0] == UNARY_PREFIX &&
           node[1] == op;
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

  // Optimize given that the expression is flowing into a boolean context
  auto optimizeBoolean = [&](Ref node) {
    // TODO: in some cases it may be possible to turn
    //
    //   if (x | 0)
    //
    // into
    //
    //   if (x)
    //
    // In general this is unsafe if e.g. x is -2147483648 + -2147483648 (which
    // the | 0 turns into 0, but without it is a truthy value).
    //
    // Another issue is that in deterministic mode we care about corner cases
    // that would trap in wasm, like an integer divide by zero:
    //
    //  if ((1 / 0) | 0)  =>  condition is Infinity | 0 = 0 which is falsey
    //
    // while
    //
    //  if (1 / 0)  =>  condition is Infinity which is truthy
    //
    // Thankfully this is not common, and does not occur on % (1 % 0 is a NaN
    // which has the right truthiness), so we could perhaps do
    //
    //   if (!(flags.deterministic && isBinary(node[2], DIV))) return node[2];
    //
    // (but there is still the first issue).
    return node;
  };

  // Optimizations

  // Pre-simplification
  traversePost(ast, [&](Ref node) {
    // x >> 0  =>  x | 0
    if (isConstantBinary(node, RSHIFT, 0)) {
      node[1]->setString(OR);
    }
  });

  traversePost(ast, [&](Ref node) {
    if (isBitwise(node)) {
      // x | 0 going into a bitwise op => skip the | 0
      node[2] = removeOrZero(node[2]);
      node[3] = removeOrZero(node[3]);
      // (x | 0 or similar) | 0  =>  (x | 0 or similar)
      if (isOrZero(node)) {
        if (isSignedBitwise(node[2])) {
          replaceInPlace(node, node[2]);
        }
      }
      if (isHeapAccess(node[2])) {
        auto heap = getHeapFromAccess(node[2]);
        IString replacementHeap;
        // We can avoid a cast of a load by using the load to do it instead.
        if (isOrZero(node)) {
          if (isIntegerHeap(heap)) {
            replacementHeap = heap;
          }
        } else if (isTrshiftZero(node)) {
          // For signed or unsigned loads smaller than 32 bits, doing an | 0
          // was safe either way - they aren't in the range an | 0 can affect.
          // For >>> 0 however, a negative value would change, so we still
          // need the cast.
          if (heap == HEAP32 || heap == HEAPU32) {
            replacementHeap = HEAPU32;
          } else if (heap == HEAPU16) {
            replacementHeap = HEAPU16;
          } else if (heap == HEAPU8) {
            replacementHeap = HEAPU8;
          }
        }
        if (!replacementHeap.isNull()) {
          setHeapOnAccess(node[2], replacementHeap);
          replaceInPlace(node, node[2]);
          return;
        }
        // A load into an & may allow using a simpler heap, e.g. HEAPU8[..] & 1
        // (a load of a boolean) may be HEAP8[..] & 1. The signed heaps are more
        // commonly used, so it compresses better, and also they seem to have
        // better performance (perhaps since HEAPU32 is at risk of not being a
        // smallint).
        if (node[1] == AND) {
          if (isConstantBinary(node, AND, 1)) {
            if (heap == HEAPU8) {
              setHeapOnAccess(node[2], HEAP8);
            } else if (heap == HEAPU16) {
              setHeapOnAccess(node[2], HEAP16);
            }
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
    // Add/subtract can merge coercions up, except when a child is a division,
    // which needs to be eagerly truncated to remove fractional results.
    else if (isBinary(node, PLUS) || isBinary(node, MINUS)) {
      auto left = node[2];
      auto right = node[3];
      if (isOrZero(left) && isOrZero(right) && !isBinary(left[2], DIV) &&
          !isBinary(right[2], DIV)) {
        auto op = node[1]->getIString();
        // Add a coercion on top.
        node[1]->setString(OR);
        node[2] = left;
        node[3] = ValueBuilder::makeNum(0);
        // Add/subtract the inner uncoerced values.
        left[1]->setString(op);
        left[3] = right[2];
      }
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
                   isConstantBinary(assign->value(), AND, 255)) {
              assign->value() = assign->value()[2];
            }
          } else if (heap == HEAP16 || heap == HEAPU16) {
            while (isOrZero(assign->value()) ||
                   isConstantBinary(assign->value(), AND, 65535)) {
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

  // Remove unnecessary break/continue labels, when the name is that of the
  // highest target anyhow, which we would reach without the name.

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

  // Remove unnecessary block/loop labels.

  std::set<IString> usedLabelNames;

  traversePost(ast, [&](Ref node) {
    if (node->isArray() && !node->empty()) {
      if (node[0] == BREAK || node[0] == CONTINUE) {
        if (!node[1]->isNull()) {
          auto label = node[1]->getIString();
          usedLabelNames.insert(label);
        }
      } else if (node[0] == LABEL) {
        auto label = node[1]->getIString();
        if (usedLabelNames.count(label)) {
          // It's used; just erase it from the data structure.
          usedLabelNames.erase(label);
        } else {
          // It's not used - get rid of it.
          replaceInPlaceIfPossible(node, node[2]);
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
    optimizeJS(js, flags);
  }
  Wasm2JSGlue glue(wasm, output, flags, name);
  glue.emitPre();
  printJS(js, output);
  glue.emitPost();
}

class AssertionEmitter {
public:
  AssertionEmitter(WASTScript& script,
                   Output& out,
                   Wasm2JSBuilder::Flags flags,
                   const ToolOptions& options)
    : script(script), out(out), flags(flags), options(options) {}

  void emit();

private:
  WASTScript& script;
  Output& out;
  Wasm2JSBuilder::Flags flags;
  ToolOptions options;
  Module tempAllocationModule;

  Expression* translateInvoke(InvokeAction& invoke, Module& wasm);
  Ref emitAssertReturnFunc(AssertReturn& assn,
                           Module& wasm,
                           Name testFuncName,
                           Name asmModule);
  Ref emitAssertTrapFunc(InvokeAction& invoke,
                         Module& wasm,
                         Name testFuncName,
                         Name asmModule);
  Ref emitInvokeFunc(InvokeAction& invoke,
                     Module& wasm,
                     Name testFuncName,
                     Name asmModule);
  void fixCalls(Ref asmjs, Name asmModule);

  Ref processFunction(Function* func) {
    Wasm2JSBuilder sub(flags, options.passOptions);
    return sub.processStandaloneFunction(&tempAllocationModule, func);
  }

  void emitFunction(Ref func) {
    JSPrinter jser(true, true, func);
    jser.printAst();
    out << jser.buffer << std::endl;
  }
};

Expression* AssertionEmitter::translateInvoke(InvokeAction& invoke,
                                              Module& wasm) {
  std::vector<Expression*> args;
  Builder builder(wasm);
  for (auto& arg : invoke.args) {
    args.push_back(builder.makeConstantExpression(arg));
  }
  Type type =
    wasm.getFunction(wasm.getExport(invoke.name)->value)->getResults();
  return builder.makeCall(invoke.name, args, type);
}

Ref AssertionEmitter::emitAssertReturnFunc(AssertReturn& assn,
                                           Module& wasm,
                                           Name testFuncName,
                                           Name asmModule) {
  if (assn.expected.size() > 1) {
    Fatal() << "multivalue assert_return not supported";
  }
  auto* invoke = std::get_if<InvokeAction>(&assn.action);
  if (!invoke) {
    Fatal() << "only invoke actions are supported in assert_return";
  }
  Expression* actual = translateInvoke(*invoke, wasm);
  Expression* body = nullptr;
  Builder builder(wasm);
  if (assn.expected.empty()) {
    if (actual->type == Type::none) {
      body = builder.blockify(actual, builder.makeConst(uint32_t(1)));
    } else {
      body = actual;
    }
  } else if (auto* expectedVal = std::get_if<Literal>(&assn.expected[0])) {
    if (!expectedVal->type.isBasic()) {
      Fatal() << "unsupported type in assert_return: " << expectedVal->type;
    }
    Expression* expected = builder.makeConstantExpression(*expectedVal);
    switch (expected->type.getBasic()) {
      case Type::i32:
        body = builder.makeBinary(EqInt32, actual, expected);
        break;
      case Type::i64:
        body = builder.makeCall(
          "i64Equal",
          {actual,
           builder.makeCall(WASM_FETCH_HIGH_BITS, {}, Type::i32),
           expected},
          Type::i32);
        break;
      case Type::f32: {
        body = builder.makeCall("f32Equal", {actual, expected}, Type::i32);
        break;
      }
      case Type::f64: {
        body = builder.makeCall("f64Equal", {actual, expected}, Type::i32);
        break;
      }
      default: {
        Fatal() << "Unhandled type in assert: " << expected->type;
      }
    }
  } else if (std::get_if<NaNResult>(&assn.expected[0])) {
    body = builder.makeCall("isNaN", {actual}, Type::i32);
  }
  std::unique_ptr<Function> testFunc(
    builder.makeFunction(testFuncName,
                         std::vector<NameType>{},
                         Signature(Type::none, body->type),
                         std::vector<NameType>{},
                         body));
  Ref jsFunc = processFunction(testFunc.get());
  fixCalls(jsFunc, asmModule);
  emitFunction(jsFunc);
  return jsFunc;
}

Ref AssertionEmitter::emitAssertTrapFunc(InvokeAction& invoke,
                                         Module& wasm,
                                         Name testFuncName,
                                         Name asmModule) {
  Name innerFuncName("f");
  Expression* expr = translateInvoke(invoke, wasm);
  std::unique_ptr<Function> exprFunc(
    Builder(wasm).makeFunction(innerFuncName,
                               std::vector<NameType>{},
                               Signature(Type::none, expr->type),
                               std::vector<NameType>{},
                               expr));
  Ref innerFunc = processFunction(exprFunc.get());
  fixCalls(innerFunc, asmModule);
  Ref outerFunc = ValueBuilder::makeFunction(testFuncName);
  outerFunc[3]->push_back(innerFunc);
  Ref tryBlock = ValueBuilder::makeBlock();
  ValueBuilder::appendToBlock(tryBlock, ValueBuilder::makeCall(innerFuncName));
  Ref catchBlock = ValueBuilder::makeBlock();
  ValueBuilder::appendToBlock(
    catchBlock, ValueBuilder::makeReturn(ValueBuilder::makeInt(1)));
  outerFunc[3]->push_back(ValueBuilder::makeTry(
    tryBlock, ValueBuilder::makeName((IString("e"))), catchBlock));
  outerFunc[3]->push_back(ValueBuilder::makeReturn(ValueBuilder::makeInt(0)));
  emitFunction(outerFunc);
  return outerFunc;
}

Ref AssertionEmitter::emitInvokeFunc(InvokeAction& invoke,
                                     Module& wasm,
                                     Name testFuncName,
                                     Name asmModule) {
  Expression* body = translateInvoke(invoke, wasm);
  std::unique_ptr<Function> testFunc(
    Builder(wasm).makeFunction(testFuncName,
                               std::vector<NameType>{},
                               Signature(Type::none, body->type),
                               std::vector<NameType>{},
                               body));
  Ref jsFunc = processFunction(testFunc.get());
  fixCalls(jsFunc, asmModule);
  emitFunction(jsFunc);
  return jsFunc;
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

  Name asmModule = std::string("ret") + ASM_FUNC.toString();
  // Track the last built module.
  std::shared_ptr<Module> wasm;
  for (Index i = 0; i < script.size(); ++i) {
    Name testFuncName("check" + std::to_string(i));
    auto& cmd = script[i].cmd;
    if (auto* mod = std::get_if<WASTModule>(&cmd)) {
      if (auto* w = std::get_if<std::shared_ptr<Module>>(mod)) {
        wasm = *w;
        options.applyFeatures(*wasm);
        std::stringstream funcNameS;
        funcNameS << ASM_FUNC << i;
        std::stringstream moduleNameS;
        moduleNameS << "ret" << ASM_FUNC << i;
        Name funcName(funcNameS.str());
        asmModule = Name(moduleNameS.str());
        emitWasm(*wasm, out, flags, options.passOptions, funcName);
      } else {
        Fatal() << "unsupported quoted module on line " << script[i].line;
      }
    } else if (auto* assn = std::get_if<Assertion>(&cmd)) {
      if (auto* assnRet = std::get_if<AssertReturn>(assn)) {
        emitAssertReturnFunc(*assnRet, *wasm, testFuncName, asmModule);
      } else if (auto* assnAct = std::get_if<AssertAction>(assn)) {
        if (auto* invoke = std::get_if<InvokeAction>(&assnAct->action);
            invoke && assnAct->type == ActionAssertionType::Trap &&
            flags.pedantic) {
          emitAssertTrapFunc(*invoke, *wasm, testFuncName, asmModule);
        } else {
          // Skip other action assertions.
          continue;
        }
      } else if (std::get_if<AssertModule>(assn)) {
        // Skip module assertions
        continue;
      } else {
        Fatal() << "unsupported assertion on line " << script[i].line;
      }
      out << "if (!" << testFuncName << "()) throw 'assertion failed on line "
          << script[i].line << "';\n";
    } else if (auto* act = std::get_if<Action>(&cmd)) {
      if (auto* invoke = std::get_if<InvokeAction>(act)) {
        emitInvokeFunc(*invoke, *wasm, testFuncName, asmModule);
        out << testFuncName << "();\n";
      } else {
        Fatal() << "unsupported action on line " << script[i].line;
      }
    } else {
      Fatal() << "unsupported command on line " << script[i].line;
    }
  }
}

} // anonymous namespace

// Main

int main(int argc, const char* argv[]) {
  Wasm2JSBuilder::Flags flags;

  const std::string Wasm2JSOption = "wasm2js options";

  OptimizationOptions options("wasm2js",
                              "Transform .wasm/.wat files to asm.js");
  options
    .add("--output",
         "-o",
         "Output file (stdout if not specified)",
         Wasm2JSOption,
         Options::Arguments::One,
         [](Options* o, const std::string& argument) {
           o->extra["output"] = argument;
           Colors::setEnabled(false);
         })
    .add("--allow-asserts",
         "",
         "Allow compilation of .wast testing asserts",
         Wasm2JSOption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& argument) {
           flags.allowAsserts = true;
           o->extra["asserts"] = "1";
         })
    .add(
      "--pedantic",
      "",
      "Emulate WebAssembly trapping behavior",
      Wasm2JSOption,
      Options::Arguments::Zero,
      [&](Options* o, const std::string& argument) { flags.pedantic = true; })
    .add(
      "--emscripten",
      "",
      "Emulate the glue in emscripten-compatible form (and not ES6 module "
      "form)",
      Wasm2JSOption,
      Options::Arguments::Zero,
      [&](Options* o, const std::string& argument) { flags.emscripten = true; })
    .add(
      "--deterministic",
      "",
      "Replace WebAssembly trapping behavior deterministically "
      "(the default is to not care about what would trap in wasm, like a load "
      "out of bounds or integer divide by zero; with this flag, we try to be "
      "deterministic at least in what happens, which might or might not be "
      "to trap like wasm, but at least should not vary)",
      Wasm2JSOption,
      Options::Arguments::Zero,
      [&](Options* o, const std::string& argument) {
        flags.deterministic = true;
      })
    .add(
      "--symbols-file",
      "",
      "Emit a symbols file that maps function indexes to their original names",
      Wasm2JSOption,
      Options::Arguments::One,
      [&](Options* o, const std::string& argument) {
        flags.symbolsFile = argument;
      })
    .add_positional("INFILE",
                    Options::Arguments::One,
                    [](Options* o, const std::string& argument) {
                      o->extra["infile"] = argument;
                    });
  options.parse(argc, argv);
  if (options.debug) {
    flags.debug = true;
  }

  std::optional<WASTScript> script;
  std::shared_ptr<Module> wasm;
  Ref js;

  auto& input = options.extra["infile"];
  std::string suffix(".wasm");
  bool binaryInput =
    input.size() >= suffix.size() &&
    input.compare(input.size() - suffix.size(), suffix.size(), suffix) == 0;

  try {
    // If the input filename ends in `.wasm`, then parse it in binary form,
    // otherwise assume it's a `*.wat` file and go from there.
    //
    // Note that we're not using the built-in `ModuleReader` which will also do
    // similar logic here because when testing JS files we use the
    // `--allow-asserts` flag which means we need to parse the extra
    // s-expressions that come at the end of the `*.wast` file after the module
    // is defined.
    if (binaryInput) {
      wasm = std::make_shared<Module>();
      ModuleReader reader;
      reader.read(input, *wasm, "");
    } else {
      auto input(read_file<std::string>(options.extra["infile"], Flags::Text));

      auto parsed = parseScript(input);
      if (auto* err = parsed.getErr()) {
        Fatal() << err->msg;
      }
      script = std::move(*parsed);

      // Find the first module in the script.
      if (script->empty()) {
        Fatal() << "expected module";
      }
      if (auto* mod = std::get_if<WASTModule>(&(*script)[0].cmd)) {
        if (auto* w = std::get_if<std::shared_ptr<Module>>(mod)) {
          wasm = *w;
        }
      }
      if (!wasm) {
        Fatal() << "expected module as first command in script";
      }
    }
  } catch (ParseException& p) {
    p.dump(std::cerr);
    Fatal() << "error in parsing input";
  } catch (std::bad_alloc&) {
    Fatal() << "error in building module, std::bad_alloc (possibly invalid "
               "request for silly amounts of memory)";
  }

  // TODO: Remove this restriction when wasm2js can handle multiple tables
  if (wasm->tables.size() > 1) {
    Fatal() << "error: modules with multiple tables are not supported yet.";
  }

  options.applyFeatures(*wasm);
  if (options.passOptions.validate) {
    if (!WasmValidator().validate(*wasm)) {
      std::cout << *wasm << '\n';
      Fatal() << "error in validating input";
    }
  }

  if (options.debug) {
    std::cerr << "j-printing..." << std::endl;
  }
  Output output(options.extra["output"], Flags::Text);
  if (script && options.extra["asserts"] == "1") {
    AssertionEmitter(*script, output, flags, options).emit();
  } else {
    emitWasm(*wasm, output, flags, options.passOptions, "asmFunc");
  }

  if (options.debug) {
    std::cerr << "done." << std::endl;
  }
}
