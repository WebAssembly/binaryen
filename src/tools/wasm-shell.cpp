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
  // Keyed by module name.
  std::map<Name, std::shared_ptr<Module>> modules;

  // Keyed by instance name.
  std::map<Name, std::shared_ptr<ShellExternalInterface>> interfaces;
  std::map<Name, std::shared_ptr<ModuleRunner>> instances;
  // Used for imports, keyed by instance name.
  std::map<Name, std::shared_ptr<ModuleRunner>> linkedInstances;

  Name lastInstance;
  std::optional<Name> lastModuleDefinition;

  size_t anonymousModuleCounter = 0;

  std::shared_ptr<SharedWaitState> sharedWaitState;

  Options& options;

  struct ThreadState {
    Name name;
    std::vector<WATParser::ScriptEntry> commands;
    size_t pc = 0;
    bool isSuspended = false;
    std::shared_ptr<ModuleRunner> instance = nullptr;
    std::shared_ptr<ContData> suspendedCont = nullptr;
    bool done = false;
    Name lastInstance;
    std::optional<Name> lastModuleDefinition;
  };
  std::vector<ThreadState> activeThreads;

  Shell(Options& options) : options(options) {
    sharedWaitState = std::make_shared<SharedWaitState>();
    buildSpectestModule();
  }

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
    } else if (auto* instantiateModule =
                 std::get_if<ModuleInstantiation>(&cmd)) {
      return doInstantiate(*instantiateModule);
    } else if (auto* thread = std::get_if<ThreadBlock>(&cmd)) {
      return doThread(*thread);
    } else if (auto* wait = std::get_if<Wait>(&cmd)) {
      return doWait(*wait);
    } else {
      WASM_UNREACHABLE("unexpected command");
    }
  }

  Result<> doThread(ThreadBlock& thread) {
    ThreadState state;
    state.name = thread.name;
    state.commands = thread.commands;
    state.lastInstance = lastInstance;
    state.lastModuleDefinition = lastModuleDefinition;
    activeThreads.push_back(std::move(state));
    return Ok{};
  }

  Result<> doWait(Wait& wait) {
    bool found = false;
    for (auto& t : activeThreads) {
      if (t.name == wait.thread) {
        found = true;
        break;
      }
    }
    if (!found) {
      return Err{"wait called for unknown thread"};
    }

    // Round-robin execution
    while (true) {
      bool anyProgress = false;
      bool targetDone = false;

      size_t numThreads = activeThreads.size();
      for (size_t i = 0; i < numThreads; ++i) {
        if (activeThreads[i].done) {
          if (activeThreads[i].name == wait.thread)
            targetDone = true;
          continue;
        }

        if (activeThreads[i].isSuspended) {
          // Check if it's still waiting. WaitQueue sets `isWaiting` to false
          // when notified.
          bool stillWaiting = activeThreads[i].suspendedCont &&
                              activeThreads[i].suspendedCont->isWaiting;

          if (!stillWaiting) {
            // It was woken up! We need to resume it.
            activeThreads[i].isSuspended = false;
            Flow flow;
            try {
              flow = activeThreads[i].instance->resumeContinuation(
                activeThreads[i].suspendedCont);
            } catch (TrapException&) {
              std::cerr << "Thread " << activeThreads[i].name
                        << " trapped upon resume\n";
              activeThreads[i].done = true;
              anyProgress = true;
              continue;
            } catch (...) {
              WASM_UNREACHABLE("unexpected error during resume");
            }
            activeThreads[i].suspendedCont = nullptr;

            if (flow.breakTo == THREAD_SUSPEND_FLOW) {
              // Suspended again
              activeThreads[i].isSuspended = true;
              activeThreads[i].suspendedCont =
                activeThreads[i].instance->getSuspendedContinuation();
              anyProgress = true;
            } else if (flow.suspendTag) {
              activeThreads[i].instance->clearContinuationStore();
              activeThreads[i].done = true; // unhandled suspension
              anyProgress = true;
            } else {
              auto& cmd = activeThreads[i].commands[activeThreads[i].pc].cmd;
              if (auto* assnVar = std::get_if<Assertion>(&cmd)) {
                if (auto* assn = std::get_if<AssertReturn>(assnVar)) {
                  auto assnRes =
                    assertResult(ActionResult(flow.values), assn->expected);
                  if (assnRes.getErr()) {
                    std::cerr << "Thread " << activeThreads[i].name
                              << " error: " << assnRes.getErr()->msg << "\n";
                    activeThreads[i].done = true;
                  } else {
                    activeThreads[i].pc++;
                  }
                } else {
                  activeThreads[i].pc++;
                }
              } else {
                activeThreads[i]
                  .pc++; // Completed the command that originally suspended!
              }
              anyProgress = true;
            }
          }
        } else {
          // Normal execution of the next command.
          std::swap(lastInstance, activeThreads[i].lastInstance);
          std::swap(lastModuleDefinition,
                    activeThreads[i].lastModuleDefinition);

          if (activeThreads[i].pc < activeThreads[i].commands.size()) {
            auto& cmd = activeThreads[i].commands[activeThreads[i].pc].cmd;
            Action* trackAction = nullptr;
            if (auto* act = std::get_if<Action>(&cmd)) {
              trackAction = act;
            } else if (auto* assnVar = std::get_if<Assertion>(&cmd)) {
              if (auto* assn = std::get_if<AssertReturn>(assnVar)) {
                trackAction = &assn->action;
              }
            }

            if (trackAction) {
              auto result = doAction(*trackAction);
              if (std::get_if<ThreadSuspendResult>(&result)) {
                activeThreads[i].isSuspended = true;
                if (auto* invoke = std::get_if<InvokeAction>(trackAction)) {
                  activeThreads[i].instance =
                    instances[invoke->base ? *invoke->base : lastInstance];
                  activeThreads[i].suspendedCont =
                    activeThreads[i].instance->getSuspendedContinuation();
                  std::cerr
                    << "THREAD " << i << " SUSPENDED. suspendedCont is "
                    << (activeThreads[i].suspendedCont ? "VALID" : "NULL")
                    << " instance addr=" << activeThreads[i].instance.get()
                    << "\n";
                } else {
                  std::cerr
                    << "THREAD " << i
                    << " SUSPENDED but trackAction is NOT InvokeAction!\n";
                }
                anyProgress = true;
              } else {
                if (auto* assnVar = std::get_if<Assertion>(&cmd)) {
                  if (auto* assn = std::get_if<AssertReturn>(assnVar)) {
                    auto assnRes = assertResult(result, assn->expected);
                    if (assnRes.getErr()) {
                      std::cerr << "Thread " << activeThreads[i].name
                                << " error: " << assnRes.getErr()->msg << "\n";
                      activeThreads[i].done = true;
                    } else {
                      activeThreads[i].pc++;
                    }
                  } else {
                    activeThreads[i].pc++;
                  }
                } else {
                  activeThreads[i].pc++;
                }
                anyProgress = true;
              }
            } else if (auto* waitCmd = std::get_if<Wait>(&cmd)) {
              bool waitFound = false;
              bool waitDone = false;
              // Avoid using an index loop here since activeThreads might be
              // accessed
              for (size_t j = 0; j < activeThreads.size(); ++j) {
                if (activeThreads[j].name == waitCmd->thread) {
                  waitFound = true;
                  waitDone = activeThreads[j].done;
                  break;
                }
              }
              if (!waitFound) {
                std::cerr << "Thread " << activeThreads[i].name
                          << " error: wait called for unknown thread\n";
                activeThreads[i].done = true;
                anyProgress = true;
              } else if (waitDone) {
                activeThreads[i].pc++;
                anyProgress = true;
              }
            } else {
              // Not an action, wait, or assert_return, just run it
              // (e.g. module instantiation or other assertions)
              auto res = runCommand(cmd);
              if (res.getErr()) {
                std::cerr << "Thread " << activeThreads[i].name
                          << " error: " << res.getErr()->msg << "\n";
                activeThreads[i].done = true;
              } else {
                activeThreads[i].pc++;
                anyProgress = true;
              }
            }
          } else {
            activeThreads[i].done = true;
            anyProgress = true; // finishing counts as progress
          }

          std::swap(lastInstance, activeThreads[i].lastInstance);
          std::swap(lastModuleDefinition,
                    activeThreads[i].lastModuleDefinition);
        }
      }

      if (targetDone) {
        break;
      }

      if (!anyProgress) {
        // Find if target is still suspended
        return Err{"deadlock! no threads can make progress"};
      }
    }
    return Ok{};
  }

  Result<std::shared_ptr<Module>> makeModule(WASTModule& mod) {
    std::shared_ptr<Module> wasm;
    if (auto* quoted = std::get_if<QuotedModule>(&mod.module)) {
      wasm = std::make_shared<Module>();
      wasm->features = FeatureSet::All;
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
    } else if (auto* ptr = std::get_if<std::shared_ptr<Module>>(&mod.module)) {
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

  Result<> doInstantiate(ModuleInstantiation& instantiateModule) {
    auto moduleDefinitionName = instantiateModule.moduleName
                                  ? instantiateModule.moduleName
                                  : lastModuleDefinition;
    if (!moduleDefinitionName) {
      return Err{"No module definition found in module instantiation, and no "
                 "previous module definition was found."};
    }

    auto instanceName = instantiateModule.instanceName
                          ? instantiateModule.instanceName
                          : lastModuleDefinition;
    if (!instanceName) {
      return Err{"No instance name found in module instantiation, and no "
                 "previous module definition was found."};
    }

    return instantiate(*modules[*moduleDefinitionName], *instanceName);
  }

  Result<> instantiate(Module& wasm, Name instanceName) {
    auto interface = std::make_shared<ShellExternalInterface>(linkedInstances);
    auto instance =
      std::make_shared<ModuleRunner>(wasm, interface.get(), linkedInstances);

    // In multithreaded WASM, instances within the same thread should share a
    // stack. However, the `linkedInstances` might contain modules (like memory)
    // shared across ALL threads. If we blindly inherit `continuationStore` from
    // `linkedInstances`, all threads will share the same execution stack,
    // causing segfaults. Therefore, we MUST give this instance a fresh
    // ContinuationStore for its thread execution unless it is supposed to be
    // part of an existing thread's execution. For now, in `wasm-shell`, we
    // simplify by giving every top-level module a fresh store but sharing the
    // WAIT state. (Called function execution across modules will temporarily
    // push to their respective stores, which is not perfect natively but avoids
    // stack data races). Actually, `activeThreads[i]` implies each thread has
    // its own stack.
    auto store = std::make_shared<ContinuationStore>();
    store->sharedWaitState = sharedWaitState;
    instance->setContinuationStore(store);

    lastInstance = instanceName;

    // Even if instantiation fails, the module may have partially instantiated
    // and mutated an imported memory or table. Keep the references alive to
    // ensure that function references stay alive.
    interfaces[instanceName] = interface;
    instances[instanceName] = instance;

    try {

      // This is not an optimization: we want to execute anything, even relaxed
      // SIMD instructions.
      instance->setRelaxedBehavior(ModuleRunner::RelaxedBehavior::Execute);
      instance->instantiate(/* validateImports_=*/true);
    } catch (const std::exception& e) {
      return Err{std::string("failed to instantiate module: ") + e.what()};
    } catch (...) {
      return Err{"failed to instantiate module"};
    }

    return Ok{};
  }

  Result<> addModule(WASTModule& mod) {
    auto module = makeModule(mod);
    CHECK_ERR(module);

    auto wasm = *module;
    if (!wasm->name.is()) {
      wasm->name = Name(std::string("anonymous_") +
                        std::to_string(anonymousModuleCounter++));
    }
    CHECK_ERR(validateModule(*wasm));

    modules[wasm->name] = wasm;
    if (!mod.isDefinition) {
      CHECK_ERR(instantiate(*wasm, wasm->name));
    } else {
      lastModuleDefinition = wasm->name;
    }

    return Ok{};
  }

  Result<> addRegistration(Register& reg) {
    Name instanceName = reg.instanceName ? *reg.instanceName : lastInstance;

    auto instance = instances[instanceName];
    if (!instance) {
      return Err{"register called without a module"};
    }
    linkedInstances[reg.name] = instance;

    // We copy pointers as a registered module's name might still be used
    // in an assertion or invoke command.
    interfaces[reg.name] = interfaces[instanceName];
    instances[reg.name] = instances[instanceName];
    return Ok{};
  }

  struct TrapResult {};
  struct HostLimitResult {};
  struct ExceptionResult {};
  struct SuspensionResult {};
  struct ThreadSuspendResult {};
  using ActionResult = std::variant<Literals,
                                    TrapResult,
                                    HostLimitResult,
                                    ExceptionResult,
                                    SuspensionResult,
                                    ThreadSuspendResult>;

  std::string resultToString(const ActionResult& result) {
    if (std::get_if<TrapResult>(&result)) {
      return "trap";
    } else if (std::get_if<HostLimitResult>(&result)) {
      return "exceeded host limit";
    } else if (std::get_if<ExceptionResult>(&result)) {
      return "exception";
    } else if (std::get_if<SuspensionResult>(&result)) {
      return "suspension";
    } else if (std::get_if<ThreadSuspendResult>(&result)) {
      return "thread_suspend";
    } else if (auto* vals = std::get_if<Literals>(&result)) {
      std::stringstream ss;
      ss << *vals;
      return ss.str();
    } else {
      WASM_UNREACHABLE("unexpected result");
    }
  }

  ActionResult doAction(Action& act) {
    assert(instances[lastInstance].get());
    if (auto* invoke = std::get_if<InvokeAction>(&act)) {
      auto it = instances.find(invoke->base ? *invoke->base : lastInstance);
      if (it == instances.end()) {
        return TrapResult{};
      }
      auto& instance = it->second;
      std::cerr << "doAction invoke name=" << invoke->name
                << " instance addr=" << instance.get() << "\n";
      Flow flow;
      try {
        flow = instance->callExport(invoke->name, invoke->args);
      } catch (TrapException&) {
        return TrapResult{};
      } catch (HostLimitException&) {
        return HostLimitResult{};
      } catch (WasmException&) {
        return ExceptionResult{};
      } catch (...) {
        WASM_UNREACHABLE("unexpected error");
      }
      if (flow.breakTo == THREAD_SUSPEND_FLOW) {
        return ThreadSuspendResult{};
      }
      if (flow.suspendTag) {
        // This is an unhandled suspension. Handle it here - clear the
        // suspension state - so nothing else is affected.
        instance->clearContinuationStore();
        return SuspensionResult{};
      }
      return flow.values;
    } else if (auto* get = std::get_if<GetAction>(&act)) {
      auto it = instances.find(get->base ? *get->base : lastInstance);
      if (it == instances.end()) {
        return TrapResult{};
      }
      auto& instance = it->second;
      try {
        return instance->getExportedGlobalOrTrap(get->name);
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

  Result<> assertResult(const ActionResult& result,
                        const std::vector<ExpectedResult>& expected) {
    std::stringstream err;
    auto* values = std::get_if<Literals>(&result);
    if (!values) {
      return Err{std::string("expected return, got ") + resultToString(result)};
    }
    if (values->size() != expected.size()) {
      err << "expected " << expected.size() << " values, got "
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
      auto& exp = expected[i];
      if (auto* v = std::get_if<Literal>(&exp)) {
        if (val != *v) {
          err << "expected " << *v << ", got " << val << atIndex();
          return Err{err.str()};
        }
      } else if (auto* ref = std::get_if<RefResult>(&exp)) {
        if (!val.type.isRef() ||
            !HeapType::isSubType(val.type.getHeapType(), ref->type)) {
          err << "expected " << ref->type << " reference, got " << val
              << atIndex();
          return Err{err.str()};
        }
      } else if ([[maybe_unused]] auto* nullRef =
                   std::get_if<NullRefResult>(&exp)) {
        if (!val.isNull()) {
          err << "expected ref.null, got " << val << atIndex();
          return Err{err.str()};
        }
      } else if (auto* nan = std::get_if<NaNResult>(&exp)) {
        auto check = checkNaN(val, *nan);
        if (auto* e = check.getErr()) {
          err << e->msg << atIndex();
          return Err{err.str()};
        }
      } else if (auto* lanes = std::get_if<LaneResults>(&exp)) {
        switch (lanes->size()) {
          case 4: {
            auto vals = val.getLanesF32x4();
            for (Index j = 0; j < 4; ++j) {
              auto check = checkLane(vals[j], (*lanes)[j], j);
              if (auto* e = check.getErr()) {
                err << e->msg << atIndex();
                return Err{err.str()};
              }
            }
            break;
          }
          case 2: {
            auto vals = val.getLanesF64x2();
            for (Index j = 0; j < 2; ++j) {
              auto check = checkLane(vals[j], (*lanes)[j], j);
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
        WASM_UNREACHABLE("unexpected result expectation");
      }
    }
    return Ok{};
  }

  Result<> assertReturn(AssertReturn& assn) {
    return assertResult(doAction(assn.action), assn.expected);
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
      case ActionAssertionType::Suspension:
        if (std::get_if<SuspensionResult>(&result)) {
          return Ok{};
        }
        err << "expected suspension";
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

    auto instance = instantiate(**wasm, (*wasm)->name);
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

    WASTModule mod = {/*isDefinition=*/false, spectest};
    auto added = addModule(mod);
    if (added.getErr()) {
      WASM_UNREACHABLE("error building spectest module");
    }
    Register registration{/*name=*/"spectest"};
    modules["spectest"] = spectest;
    auto registered = addRegistration(registration);
    if (registered.getErr()) {
      WASM_UNREACHABLE((std::string("error registering spectest module: ") +
                        registered.getErr()->msg)
                         .c_str());
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

  flush_and_quick_exit(0);
}
