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

#include "support/colors.h"
#include "support/command-line.h"
#include "support/file.h"
#include "wasm-s-parser.h"
#include "wasm2js.h"
#include "optimization-options.h"

using namespace cashew;
using namespace wasm;

// helpers

namespace {

template<typename T>
static void printJS(Ref ast, T& output) {
  JSPrinter jser(true, true, ast);
  jser.printAst();
  output << jser.buffer << std::endl;
}

static void optimizeJS(Ref ast) {
  // helpers
  auto isOrZero = [](Ref node) {
    return node->isArray() && node->size() > 0 && node[0] == BINARY && node[1] == OR && node[3]->isNumber() && node[3]->getNumber() == 0;
  };

  auto isBitwise = [](Ref node) {
    if (node->isArray() && node->size() > 0 && node[0] == BINARY) {
      auto op = node[1];
      return op == OR || op == AND || op == XOR || op == RSHIFT || op == TRSHIFT || op == LSHIFT;
    }
    return false;
  };

  // x >> 0  =>  x | 0
  traversePost(ast, [](Ref node) {
    if (node->isArray() && node->size() > 0 && node[0] == BINARY && node[1] == RSHIFT && node[3]->isNumber()) {
      if (node[3]->getNumber() == 0) {
        node[1]->setString(OR);
      }
    }
  });

  traversePost(ast, [&](Ref node) {
    // x | 0 | 0  =>  x | 0
    if (isOrZero(node)) {
      while (isOrZero(node[2])) {
        node[2] = node[2][2];
      }
      if (isBitwise(node[2])) {
        auto child = node[2];
        node[1] = child[1];
        node[2] = child[2];
        node[3] = child[3];
      }
    }
    // x | 0 going into a bitwise op => skip the | 0
    else if (isBitwise(node)) {
      while (isOrZero(node[2])) {
        node[2] = node[2][2];
      }
      while (isOrZero(node[3])) {
        node[3] = node[3][2];
      }
    }
  });
}

static void emitWasm(Module& wasm, Output& output, Wasm2JSBuilder::Flags flags, Name name, bool optimize=false) {
  Wasm2JSBuilder wasm2js(flags);
  auto js = wasm2js.processWasm(&wasm, name);
  if (optimize) {
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
                   Wasm2JSBuilder::Flags flags) : root(root), sexpBuilder(sexpBuilder), out(out), flags(flags) {}

  void emit();

private:
  Element& root;
  SExpressionWasmBuilder& sexpBuilder;
  Output& out;
  Wasm2JSBuilder::Flags flags;
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
    Wasm2JSBuilder sub(flags);
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
    if  (actual->type == none) {
      body = wasmBuilder.blockify(
        actual,
        wasmBuilder.makeConst(Literal(uint32_t(1)))
      );
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
          {actual, wasmBuilder.makeCall(WASM_FETCH_HIGH_BITS, {}, i32), expected},
          i32
        );
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
    wasmBuilder.makeFunction(
      testFuncName,
      std::vector<NameType>{},
      body->type,
      std::vector<NameType>{},
      body
    )
  );
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
    wasmBuilder.makeFunction(
      testFuncName,
      std::vector<NameType>{},
      body->type,
      std::vector<NameType>{},
      body
    )
  );
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
                             expr)
  );
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
    ValueBuilder::makeReturn(
      ValueBuilder::makeCall(
        ValueBuilder::makeDot(
          ValueBuilder::makeName(IString("e")),
          ValueBuilder::makeName(IString("message")),
          ValueBuilder::makeName(IString("includes"))
        ),
        ValueBuilder::makeString(expectedErr)
      )
    )
  );
  outerFunc[3]->push_back(ValueBuilder::makeTry(
      tryBlock,
      ValueBuilder::makeName((IString("e"))),
      catchBlock));
  outerFunc[3]->push_back(ValueBuilder::makeReturn(ValueBuilder::makeInt(0)));
  emitFunction(outerFunc);
  return outerFunc;
}

bool AssertionEmitter::isAssertHandled(Element& e) {
  return e.isList() && e.size() >= 2 && e[0]->isStr()
      && (e[0]->str() == Name("assert_return") ||
          e[0]->str() == Name("assert_return_nan") ||
          (flags.pedantic && e[0]->str() == Name("assert_trap")))
      && e[1]->isList() && e[1]->size() >= 2 && (*e[1])[0]->isStr()
      && (*e[1])[0]->str() == Name("invoke");
}

void AssertionEmitter::fixCalls(Ref asmjs, Name asmModule) {
  if (asmjs->isArray()) {
    ArrayStorage& arr = asmjs->getArray();
    for (Ref& r : arr) {
      fixCalls(r, asmModule);
    }
    if (arr.size() > 0 && arr[0]->isString() && arr[0]->getIString() == cashew::CALL) {
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
       return actual_lo == (expected_lo | 0) && actual_hi == (expected_hi | 0);
    }
  )";

  Builder wasmBuilder(sexpBuilder.getAllocator());
  Name asmModule = std::string("ret") + ASM_FUNC.str;
  for (size_t i = 0; i < root.size(); ++i) {
    Element& e = *root[i];
    if (e.isList() && e.size() >= 1 && e[0]->isStr() && e[0]->str() == Name("module")) {
      std::stringstream funcNameS;
      funcNameS << ASM_FUNC.c_str() << i;
      std::stringstream moduleNameS;
      moduleNameS << "ret" << ASM_FUNC.c_str() << i;
      Name funcName(funcNameS.str().c_str());
      asmModule = Name(moduleNameS.str().c_str());
      Module wasm;
      SExpressionWasmBuilder builder(wasm, e);
      emitWasm(wasm, out, flags, funcName);
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

    out << "if (!"
        << testFuncName.str
        << "()) throw 'assertion failed: "
        << e
        << "';\n";
  }
}

} // anonymous namespace

// Main

int main(int argc, const char *argv[]) {
  Wasm2JSBuilder::Flags flags;
  OptimizationOptions options("wasm2js", "Transform .wasm/.wast files to asm.js");
  options
      .add("--output", "-o", "Output file (stdout if not specified)",
           Options::Arguments::One,
           [](Options* o, const std::string& argument) {
             o->extra["output"] = argument;
             Colors::disable();
           })
      .add("--allow-asserts", "", "Allow compilation of .wast testing asserts",
           Options::Arguments::Zero,
           [&](Options* o, const std::string& argument) {
             flags.allowAsserts = true;
             o->extra["asserts"] = "1";
           })
      .add("--pedantic", "", "Emulate WebAssembly trapping behavior",
           Options::Arguments::Zero,
           [&](Options* o, const std::string& argument) {
             flags.pedantic = true;
           })
      .add("--emscripten", "", "Emulate the glue in emscripten-compatible form (and not ES6 module form)",
           Options::Arguments::Zero,
           [&](Options* o, const std::string& argument) {
             flags.emscripten = true;
           })
      .add_positional("INFILE", Options::Arguments::One,
                      [](Options *o, const std::string& argument) {
                        o->extra["infile"] = argument;
                      });
  options.parse(argc, argv);
  if (options.debug) flags.debug = true;

  Element* root = nullptr;
  Module wasm;
  Ref js;
  std::unique_ptr<SExpressionParser> sexprParser;
  std::unique_ptr<SExpressionWasmBuilder> sexprBuilder;

  auto &input = options.extra["infile"];
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
      auto input(
          read_file<std::vector<char>>(options.extra["infile"], Flags::Text, options.debug ? Flags::Debug : Flags::Release));
      if (options.debug) std::cerr << "s-parsing..." << std::endl;
      sexprParser = make_unique<SExpressionParser>(input.data());
      root = sexprParser->root;

      if (options.debug) std::cerr << "w-parsing..." << std::endl;
      sexprBuilder = make_unique<SExpressionWasmBuilder>(wasm, *(*root)[0]);
    }
  } catch (ParseException& p) {
    p.dump(std::cerr);
    Fatal() << "error in parsing input";
  } catch (std::bad_alloc&) {
    Fatal() << "error in building module, std::bad_alloc (possibly invalid request for silly amounts of memory)";
  }

  if (options.passOptions.validate) {
    if (!WasmValidator().validate(wasm)) {
      WasmPrinter::printModule(&wasm);
      Fatal() << "error in validating input";
    }
  }

  if (options.debug) std::cerr << "j-printing..." << std::endl;
  Output output(options.extra["output"], Flags::Text, options.debug ? Flags::Debug : Flags::Release);
  if (!binaryInput && options.extra["asserts"] == "1") {
    AssertionEmitter(*root, *sexprBuilder, output, flags).emit();
  } else {
    emitWasm(wasm, output, flags, "asmFunc", options.passOptions.optimizeLevel > 0);
  }

  if (options.debug) std::cerr << "done." << std::endl;
}
