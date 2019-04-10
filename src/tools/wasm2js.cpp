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

#include "support/base64.h"
#include "support/colors.h"
#include "support/command-line.h"
#include "support/file.h"
#include "wasm-s-parser.h"
#include "wasm2js.h"
#include "tool-options.h"

using namespace cashew;
using namespace wasm;

namespace {

// Wasm2JSGlue emits the core of the module - the functions etc. that would
// be the asm.js function in an asm.js world. This class emits the rest of the
// "glue" around that.
class Wasm2JSGlue {
public:
  Wasm2JSGlue(Module& wasm, Output& out, Wasm2JSBuilder::Flags flags) : wasm(wasm), out(out), flags(flags) {}

  void emitPre();
  void emitPost();
  void emitAsserts(Element& root,
                   SExpressionWasmBuilder& sexpBuilder);

private:
  Module& wasm;
  Output& out;
  Wasm2JSBuilder::Flags flags;

  bool isAssertHandled(Element& e);
  Ref emitAssertReturnFunc(SExpressionWasmBuilder& sexpBuilder,
                           Builder& wasmBuilder,
                           Element& e,
                           Name testFuncName,
                           Name asmModule);
  Ref emitAssertReturnNanFunc(SExpressionWasmBuilder& sexpBuilder,
                              Builder& wasmBuilder,
                              Element& e,
                              Name testFuncName,
                              Name asmModule);
  Ref emitAssertTrapFunc(SExpressionWasmBuilder& sexpBuilder,
                         Builder& wasmBuilder,
                         Element& e,
                         Name testFuncName,
                         Name asmModule);

  void fixCalls(Ref asmjs, Name asmModule);

  Ref processFunction(Function* func) {
    Wasm2JSBuilder sub(flags);
    return sub.processFunction(&wasm, func);
  }

  void emitFunction(Ref func) {
    JSPrinter jser(true, true, func);
    jser.printAst();
    out << jser.buffer << std::endl;
  }
};

void Wasm2JSGlue::emitPre() {
  std::unordered_map<Name, Name> baseModuleMap;

  auto noteImport = [&](Name module, Name base) {
    // Right now codegen requires a flat namespace going into the module,
    // meaning we don't support importing the same name from multiple namespaces yet.
    if (baseModuleMap.count(base) && baseModuleMap[base] != module) {
      Fatal() << "the name " << base << " cannot be imported from "
              << "two different modules yet\n";
      abort();
    }
    baseModuleMap[base] = module;

    out << "import { "
      << base.str
      << " } from '"
      << module.str
      << "';\n";
  };

  ImportInfo imports(wasm);

  ModuleUtils::iterImportedGlobals(wasm, [&](Global* import) {
    Fatal() << "non-function imports aren't supported yet\n";
    noteImport(import->module, import->base);
  });
  ModuleUtils::iterImportedFunctions(wasm, [&](Function* import) {
    noteImport(import->module, import->base);
  });

  out << '\n';
}

void Wasm2JSGlue::emitPost() {
  std::string funcName = "asmFunc";

  // Create an initial `ArrayBuffer` and populate it with static data.
  // Currently we use base64 encoding to encode static data and we decode it at
  // instantiation time.
  //
  // Note that the translation here expects that the lower values of this memory
  // can be used for conversions, so make sure there's at least one page.
  {
    auto pages = wasm.memory.initial == 0 ? 1 : wasm.memory.initial.addr;
    out << "const mem" << funcName << " = new ArrayBuffer("
      << pages * Memory::kPageSize
      << ");\n";
  }

  if (wasm.memory.segments.size() > 0) {
    auto expr = R"(
      function(mem) {
        const _mem = new Uint8Array(mem);
        return function(offset, s) {
          if (typeof Buffer === 'undefined') {
            const bytes = atob(s);
            for (let i = 0; i < bytes.length; i++)
              _mem[offset + i] = bytes.charCodeAt(i);
          } else {
            const bytes = Buffer.from(s, 'base64');
            for (let i = 0; i < bytes.length; i++)
              _mem[offset + i] = bytes[i];
          }
        }
      }
    )";

    // const assign$name = ($expr)(mem$name);
    out << "const assign" << funcName
      << " = (" << expr << ")(mem" << funcName << ");\n";
  }
  for (auto& seg : wasm.memory.segments) {
    assert(!seg.isPassive && "passive segments not implemented yet");
    out << "assign" << funcName << "("
      << constOffset(seg)
      << ", \""
      << base64Encode(seg.data)
      << "\");\n";
  }

  // Actually invoke the `asmFunc` generated function, passing in all global
  // values followed by all imports
  out << "const ret" << funcName << " = " << funcName << "({"
    << "Math,"
    << "Int8Array,"
    << "Uint8Array,"
    << "Int16Array,"
    << "Uint16Array,"
    << "Int32Array,"
    << "Uint32Array,"
    << "Float32Array,"
    << "Float64Array,"
    << "NaN,"
    << "Infinity"
    << "}, {";

  out << "abort:function() { throw new Error('abort'); }";

  ModuleUtils::iterImportedFunctions(wasm, [&](Function* import) {
    out << "," << import->base;
  });
  out << "},mem" << funcName << ");\n";

  if (flags.allowAsserts) {
    return;
  }

  // And now that we have our returned instance, export all our functions
  // that are hanging off it.
  for (auto& exp : wasm.exports) {
    switch (exp->kind) {
      case ExternalKind::Function:
      case ExternalKind::Memory:
        break;

      // Exported globals and function tables aren't supported yet
      default:
        continue;
    }
    std::ostringstream export_name;
    for (auto *ptr = exp->name.str; *ptr; ptr++) {
      if (*ptr == '-') {
        export_name << '_';
      } else {
        export_name << *ptr;
      }
    }
    out << "export const "
      << asmangle(exp->name.str)
      << " = ret"
      << funcName
      << "."
      << asmangle(exp->name.str)
      << ";\n";
  }
}

void Wasm2JSGlue::emitAsserts(Element& root,
                              SExpressionWasmBuilder& sexpBuilder) {

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
  std::stringstream asmModuleS;
  asmModuleS << "ret" << ASM_FUNC.c_str();
  Name asmModule(asmModuleS.str().c_str());
  for (size_t i = 1; i < root.size(); ++i) {
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
      Wasm2JSBuilder sub(flags);
      auto js = sub.processWasm(&wasm);
      JSPrinter jser(true, true, js);
      jser.printAst();
      out << jser.buffer << std::endl;
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
      emitAssertReturnFunc(sexpBuilder, wasmBuilder, e, testFuncName, asmModule);
    } else if (isReturnNan) {
      emitAssertReturnNanFunc(sexpBuilder, wasmBuilder, e, testFuncName, asmModule);
    } else {
      emitAssertTrapFunc(sexpBuilder, wasmBuilder, e, testFuncName, asmModule);
    }

    out << "if (!"
        << testFuncName.str
        << "()) throw 'assertion failed: "
        << e
        << "';\n";
  }
}

Ref Wasm2JSGlue::emitAssertReturnFunc(SExpressionWasmBuilder& sexpBuilder,
                                      Builder& wasmBuilder,
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

Ref Wasm2JSGlue::emitAssertReturnNanFunc(SExpressionWasmBuilder& sexpBuilder,
                                         Builder& wasmBuilder,
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

Ref Wasm2JSGlue::emitAssertTrapFunc(SExpressionWasmBuilder& sexpBuilder,
                                    Builder& wasmBuilder,
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

bool Wasm2JSGlue::isAssertHandled(Element& e) {
  return e.isList() && e.size() >= 2 && e[0]->isStr()
      && (e[0]->str() == Name("assert_return") ||
          e[0]->str() == Name("assert_return_nan") ||
          (flags.pedantic && e[0]->str() == Name("assert_trap")))
      && e[1]->isList() && e[1]->size() >= 2 && (*e[1])[0]->isStr()
      && (*e[1])[0]->str() == Name("invoke");
}

void Wasm2JSGlue::fixCalls(Ref asmjs, Name asmModule) {
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

} // anonymous namespace

int main(int argc, const char *argv[]) {
  Wasm2JSBuilder::Flags builderFlags;
  ToolOptions options("wasm2js", "Transform .wasm/.wast files to asm.js");
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
             builderFlags.allowAsserts = true;
             o->extra["asserts"] = "1";
           })
      .add("--pedantic", "", "Emulate WebAssembly trapping behavior",
           Options::Arguments::Zero,
           [&](Options* o, const std::string& argument) {
             builderFlags.pedantic = true;
           })
      .add_positional("INFILE", Options::Arguments::One,
                      [](Options *o, const std::string& argument) {
                        o->extra["infile"] = argument;
                      });
  options.parse(argc, argv);
  if (options.debug) builderFlags.debug = true;

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
      options.calculateFeatures(wasm);
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
    if (!WasmValidator().validate(wasm, options.passOptions.features)) {
      WasmPrinter::printModule(&wasm);
      Fatal() << "error in validating input";
    }
  }

  if (options.debug) std::cerr << "asming..." << std::endl;
  Wasm2JSBuilder wasm2js(builderFlags);
  js = wasm2js.processWasm(&wasm);

  if (options.debug) std::cerr << "j-printing..." << std::endl;
  Output output(options.extra["output"], Flags::Text, options.debug ? Flags::Debug : Flags::Release);
  Wasm2JSGlue glue(wasm, output, builderFlags);
  glue.emitPre();
  JSPrinter jser(true, true, js);
  jser.printAst();
  output << jser.buffer << std::endl;
  glue.emitPost();
  if (!binaryInput) {
    if (options.extra["asserts"] == "1") {
      if (options.debug) std::cerr << "asserting..." << std::endl;
      glue.emitAsserts(*root, *sexprBuilder);
    }
  }

  if (options.debug) std::cerr << "done." << std::endl;
}
