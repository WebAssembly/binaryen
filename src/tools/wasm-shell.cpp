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
// A WebAssembly shell, loads a .wast file (WebAssembly in S-Expression format)
// and executes it. This provides similar functionality as the reference
// interpreter, like assert_* calls, so it can run the spec test suite.
//
#include <memory>

#include "execution-results.h"
#include "ir/element-utils.h"
#include "parser/lexer.h"
#include "parser/wat-parser.h"
#include "pass.h"
#include "shell-interface.h"
#include "support/command-line.h"
#include "support/file.h"
#include "support/result.h"
#include "wasm-binary.h"
#include "wasm-interpreter.h"
#include "wasm-validator.h"

using namespace wasm;

using namespace wasm::WATParser;

struct Shell {
  std::map<Name, std::shared_ptr<Module>> modules;
  std::map<Name, std::shared_ptr<ShellExternalInterface>> interfaces;
  std::map<Name, std::shared_ptr<ModuleRunner>> instances;
  // used for imports
  std::map<Name, std::shared_ptr<ModuleRunner>> linkedInstances;

  Name lastModule;

  Options& options;

  Shell(Options& options) : options(options) { buildSpectestModule(); }

  Result<> run(WASTScript& script) {
    size_t i = 0;
    for (auto& entry : script) {
      Colors::red(std::cerr);
      std::cerr << i++ << ' ';
      Colors::normal(std::cerr);
      if (std::get_if<WASTModule>(&entry.cmd)) {
        Colors::green(std::cerr);
        std::cerr << "BUILDING MODULE [line: " << entry.line << "]\n";
        Colors::normal(std::cerr);
      } else if (auto* reg = std::get_if<Register>(&entry.cmd)) {
        Colors::green(std::cerr);
        std::cerr << "REGISTER MODULE INSTANCE AS \"" << reg->name
                  << "\"  [line: " << entry.line << "]\n";
        Colors::normal(std::cerr);
      } else {
        Colors::green(std::cerr);
        std::cerr << "CHECKING [line: " << entry.line << "]\n";
        Colors::normal(std::cerr);
      }
      CHECK_ERR(runCommand(entry.cmd));
    }
    return Ok{};
  }

  Result<> runCommand(WASTCommand& cmd) {
    if (auto* mod = std::get_if<WASTModule>(&cmd)) {
      return addModule(*mod);
    } else if (auto* reg = std::get_if<Register>(&cmd)) {
      return addRegistration(*reg);
    } else if (auto* act = std::get_if<Action>(&cmd)) {
      doAction(*act);
      return Ok{};
    } else if (auto* assn = std::get_if<Assertion>(&cmd)) {
      return doAssertion(*assn);
    } else {
      WASM_UNREACHABLE("unexpected command");
    }
  }

  Result<std::shared_ptr<Module>> makeModule(WASTModule& mod) {
    std::shared_ptr<Module> wasm;
    if (auto* quoted = std::get_if<QuotedModule>(&mod)) {
      wasm = std::make_shared<Module>();
      switch (quoted->type) {
        case QuotedModuleType::Text: {
          CHECK_ERR(parseModule(*wasm, quoted->module));
          break;
        }
        case QuotedModuleType::Binary: {
          std::vector<char> buffer(quoted->module.begin(),
                                   quoted->module.end());
          WasmBinaryReader reader(*wasm, FeatureSet::All, buffer);
          try {
            reader.read();
          } catch (ParseException& p) {
            std::stringstream ss;
            p.dump(ss);
            return Err{ss.str()};
          }
          break;
        }
      }
    } else if (auto* ptr = std::get_if<std::shared_ptr<Module>>(&mod)) {
      wasm = *ptr;
    } else {
      WASM_UNREACHABLE("unexpected module kind");
    }
    wasm->features = FeatureSet::All;
    return wasm;
  }

  Result<> validateModule(Module& wasm) {
    if (!WasmValidator().validate(wasm)) {
      return Err{"failed validation"};
    }
    return Ok{};
  }

  using InstanceInfo = std::pair<std::shared_ptr<ShellExternalInterface>,
                                 std::shared_ptr<ModuleRunner>>;

  Result<InstanceInfo> instantiate(Module& wasm) {
    try {
      auto interface =
        std::make_shared<ShellExternalInterface>(linkedInstances);
      auto instance =
        std::make_shared<ModuleRunner>(wasm, interface.get(), linkedInstances);
      return {{std::move(interface), std::move(instance)}};
    } catch (...) {
      return Err{"failed to instantiate module"};
    }
  }

  Result<> addModule(WASTModule& mod) {
    auto module = makeModule(mod);
    CHECK_ERR(module);

    auto wasm = *module;
    CHECK_ERR(validateModule(*wasm));

    auto instanceInfo = instantiate(*wasm);
    CHECK_ERR(instanceInfo);

    auto& [interface, instance] = *instanceInfo;
    lastModule = wasm->name;
    modules[lastModule] = std::move(wasm);
    interfaces[lastModule] = std::move(interface);
    instances[lastModule] = std::move(instance);

    return Ok{};
  }

  Result<> addRegistration(Register& reg) {
    auto instance = instances[lastModule];
    if (!instance) {
      return Err{"register called without a module"};
    }
    linkedInstances[reg.name] = instance;

    // We copy pointers as a registered module's name might still be used
    // in an assertion or invoke command.
    modules[reg.name] = modules[lastModule];
    interfaces[reg.name] = interfaces[lastModule];
    instances[reg.name] = instances[lastModule];
    return Ok{};
  }

  struct TrapResult {};
  struct HostLimitResult {};
  struct ExceptionResult {};
  using ActionResult =
    std::variant<Literals, TrapResult, HostLimitResult, ExceptionResult>;

  std::string resultToString(ActionResult& result) {
    if (std::get_if<TrapResult>(&result)) {
      return "trap";
    } else if (std::get_if<HostLimitResult>(&result)) {
      return "exceeded host limit";
    } else if (std::get_if<ExceptionResult>(&result)) {
      return "exception";
    } else if (auto* vals = std::get_if<Literals>(&result)) {
      std::stringstream ss;
      ss << *vals;
      return ss.str();
    } else {
      WASM_UNREACHABLE("unexpected result");
    }
  }

  ActionResult doAction(Action& act) {
    assert(instances[lastModule].get());
    if (auto* invoke = std::get_if<InvokeAction>(&act)) {
      auto it = instances.find(invoke->base ? *invoke->base : lastModule);
      if (it == instances.end()) {
        return TrapResult{};
      }
      auto& instance = it->second;
      try {
        return instance->callExport(invoke->name, invoke->args);
      } catch (TrapException&) {
        return TrapResult{};
      } catch (HostLimitException&) {
        return HostLimitResult{};
      } catch (WasmException&) {
        return ExceptionResult{};
      } catch (...) {
        WASM_UNREACHABLE("unexpected error");
      }
    } else if (auto* get = std::get_if<GetAction>(&act)) {
      auto it = instances.find(get->base ? *get->base : lastModule);
      if (it == instances.end()) {
        return TrapResult{};
      }
      auto& instance = it->second;
      try {
        return instance->getExport(get->name);
      } catch (TrapException&) {
        return TrapResult{};
      } catch (...) {
        WASM_UNREACHABLE("unexpected error");
      }
    } else {
      WASM_UNREACHABLE("unexpected action");
    }
  }

  Result<> doAssertion(Assertion& assn) {
    if (auto* ret = std::get_if<AssertReturn>(&assn)) {
      return assertReturn(*ret);
    } else if (auto* act = std::get_if<AssertAction>(&assn)) {
      return assertAction(*act);
    } else if (auto* mod = std::get_if<AssertModule>(&assn)) {
      return assertModule(*mod);
    } else {
      WASM_UNREACHABLE("unexpected assertion");
    }
  }

  Result<> checkNaN(Literal val, NaNResult nan) {
    std::stringstream err;
    switch (nan.kind) {
      case NaNKind::Canonical:
        if (val.type != nan.type || !val.isCanonicalNaN()) {
          err << "expected canonical " << nan.type << " NaN, got " << val;
          return Err{err.str()};
        }
        break;
      case NaNKind::Arithmetic:
        if (val.type != nan.type || !val.isArithmeticNaN()) {
          err << "expected arithmetic " << nan.type << " NaN, got " << val;
          return Err{err.str()};
        }
        break;
    }
    return Ok{};
  }

  Result<> checkLane(Literal val, LaneResult expected, Index index) {
    std::stringstream err;
    if (auto* e = std::get_if<Literal>(&expected)) {
      if (*e != val) {
        err << "expected " << *e << ", got " << val << " at lane " << index;
        return Err{err.str()};
      }
    } else if (auto* nan = std::get_if<NaNResult>(&expected)) {
      auto check = checkNaN(val, *nan);
      if (auto* e = check.getErr()) {
        err << e->msg << " at lane " << index;
        return Err{err.str()};
      }
    } else {
      WASM_UNREACHABLE("unexpected lane expectation");
    }
    return Ok{};
  }

  Result<> assertReturn(AssertReturn& assn) {
    std::stringstream err;
    auto result = doAction(assn.action);
    auto* values = std::get_if<Literals>(&result);
    if (!values) {
      return Err{std::string("expected return, got ") + resultToString(result)};
    }
    if (values->size() != assn.expected.size()) {
      err << "expected " << assn.expected.size() << " values, got "
          << resultToString(result);
      return Err{err.str()};
    }
    for (Index i = 0; i < values->size(); ++i) {
      auto atIndex = [&]() {
        if (values->size() <= 1) {
          return std::string{};
        }
        std::stringstream ss;
        ss << " at index " << i;
        return ss.str();
      };

      Literal val = (*values)[i];
      auto& expected = assn.expected[i];
      if (auto* v = std::get_if<Literal>(&expected)) {
        if (val != *v) {
          err << "expected " << *v << ", got " << val << atIndex();
          return Err{err.str()};
        }
      } else if (auto* ref = std::get_if<RefResult>(&expected)) {
        if (!val.type.isRef() ||
            !HeapType::isSubType(val.type.getHeapType(), ref->type)) {
          err << "expected " << ref->type << " reference, got " << val
              << atIndex();
          return Err{err.str()};
        }
      } else if (auto* nan = std::get_if<NaNResult>(&expected)) {
        auto check = checkNaN(val, *nan);
        if (auto* e = check.getErr()) {
          err << e->msg << atIndex();
          return Err{err.str()};
        }
      } else if (auto* lanes = std::get_if<LaneResults>(&expected)) {
        switch (lanes->size()) {
          case 4: {
            auto vals = val.getLanesF32x4();
            for (Index i = 0; i < 4; ++i) {
              auto check = checkLane(vals[i], (*lanes)[i], i);
              if (auto* e = check.getErr()) {
                err << e->msg << atIndex();
                return Err{err.str()};
              }
            }
            break;
          }
          case 2: {
            auto vals = val.getLanesF64x2();
            for (Index i = 0; i < 2; ++i) {
              auto check = checkLane(vals[i], (*lanes)[i], i);
              if (auto* e = check.getErr()) {
                err << e->msg << atIndex();
                return Err{err.str()};
              }
            }
            break;
          }
          default:
            WASM_UNREACHABLE("unexpected number of lanes");
        }
      } else {
        WASM_UNREACHABLE("unexpected expectation");
      }
    }
    return Ok{};
  }

  Result<> assertAction(AssertAction& assn) {
    std::stringstream err;
    auto result = doAction(assn.action);
    switch (assn.type) {
      case ActionAssertionType::Trap:
        if (std::get_if<TrapResult>(&result)) {
          return Ok{};
        }
        err << "expected trap";
        break;
      case ActionAssertionType::Exhaustion:
        if (std::get_if<HostLimitResult>(&result)) {
          return Ok{};
        }
        err << "expected exhaustion";
        break;
      case ActionAssertionType::Exception:
        if (std::get_if<ExceptionResult>(&result)) {
          return Ok{};
        }
        err << "expected exception";
        break;
    }
    err << ", got " << resultToString(result);
    return Err{err.str()};
  }

  Result<> assertModule(AssertModule& assn) {
    auto wasm = makeModule(assn.wasm);
    if (const auto* err = wasm.getErr()) {
      if (assn.type == ModuleAssertionType::Malformed ||
          assn.type == ModuleAssertionType::Invalid) {
        return Ok{};
      }
      return Err{err->msg};
    }

    if (assn.type == ModuleAssertionType::Malformed) {
      return Err{"expected malformed module"};
    }

    auto valid = validateModule(**wasm);
    if (auto* err = valid.getErr()) {
      if (assn.type == ModuleAssertionType::Invalid) {
        return Ok{};
      }
      return Err{err->msg};
    }

    if (assn.type == ModuleAssertionType::Invalid) {
      return Err{"expected invalid module"};
    }

    auto instance = instantiate(**wasm);
    if (auto* err = instance.getErr()) {
      if (assn.type == ModuleAssertionType::Unlinkable ||
          assn.type == ModuleAssertionType::Trap) {
        return Ok{};
      }
      return Err{err->msg};
    }

    if (assn.type == ModuleAssertionType::Unlinkable) {
      return Err{"expected unlinkable module"};
    }
    if (assn.type == ModuleAssertionType::Trap) {
      return Err{"expected instantiation to trap"};
    }

    WASM_UNREACHABLE("unexpected module assertion");
  }

  // spectest module is a default host-provided module defined by the spec's
  // reference interpreter. It's been replaced by the `(register ...)`
  // mechanism in the recent spec tests, and is kept for legacy tests only.
  //
  // TODO: spectest module is considered deprecated by the spec. Remove when
  // is actually removed from the spec test.
  void buildSpectestModule() {
    auto spectest = std::make_shared<Module>();
    spectest->features = FeatureSet::All;
    Builder builder(*spectest);

    spectest->addGlobal(builder.makeGlobal(Name::fromInt(0),
                                           Type::i32,
                                           builder.makeConst<uint32_t>(666),
                                           Builder::Immutable));
    spectest->addGlobal(builder.makeGlobal(Name::fromInt(1),
                                           Type::i64,
                                           builder.makeConst<uint64_t>(666),
                                           Builder::Immutable));
    spectest->addGlobal(builder.makeGlobal(Name::fromInt(2),
                                           Type::f32,
                                           builder.makeConst<float>(666.6f),
                                           Builder::Immutable));
    spectest->addGlobal(builder.makeGlobal(Name::fromInt(3),
                                           Type::f64,
                                           builder.makeConst<double>(666.6),
                                           Builder::Immutable));
    spectest->addExport(
      builder.makeExport("global_i32", Name::fromInt(0), ExternalKind::Global));
    spectest->addExport(
      builder.makeExport("global_i64", Name::fromInt(1), ExternalKind::Global));
    spectest->addExport(
      builder.makeExport("global_f32", Name::fromInt(2), ExternalKind::Global));
    spectest->addExport(
      builder.makeExport("global_f64", Name::fromInt(3), ExternalKind::Global));

    spectest->addTable(builder.makeTable(
      Name::fromInt(0), Type(HeapType::func, Nullable), 10, 20));
    spectest->addExport(
      builder.makeExport("table", Name::fromInt(0), ExternalKind::Table));

    spectest->addTable(builder.makeTable(
      Name::fromInt(1), Type(HeapType::func, Nullable), 10, 20, Type::i64));
    spectest->addExport(
      builder.makeExport("table64", Name::fromInt(1), ExternalKind::Table));

    Memory* memory =
      spectest->addMemory(builder.makeMemory(Name::fromInt(0), 1, 2));
    spectest->addExport(
      builder.makeExport("memory", memory->name, ExternalKind::Memory));

    // print_* functions are handled separately, no need to define here.

    WASTModule mod = std::move(spectest);
    auto added = addModule(mod);
    if (added.getErr()) {
      WASM_UNREACHABLE("error building spectest module");
    }
    Register registration{"spectest"};
    auto registered = addRegistration(registration);
    if (registered.getErr()) {
      WASM_UNREACHABLE("error registering spectest module");
    }
  }
};

int main(int argc, const char* argv[]) {
  Name entry;
  std::set<size_t> skipped;

  // Read stdin by default.
  std::string infile = "-";
  Options options("wasm-shell", "Execute .wast files");
  options.add_positional(
    "INFILE",
    Options::Arguments::One,
    [&](Options* o, const std::string& argument) { infile = argument; });
  options.parse(argc, argv);

  auto input = read_file<std::string>(infile, Flags::Text);

  // Check that we can parse the script correctly with the new parser.
  auto script = WATParser::parseScript(input);
  if (auto* err = script.getErr()) {
    std::cerr << err->msg << '\n';
    exit(1);
  }

  Lexer lexer(input);
  auto result = Shell(options).run(*script);
  if (auto* err = result.getErr()) {
    std::cerr << err->msg << '\n';
    exit(1);
  }

  Colors::green(std::cerr);
  Colors::bold(std::cerr);
  std::cerr << "all checks passed.\n";
  Colors::normal(std::cerr);
}
