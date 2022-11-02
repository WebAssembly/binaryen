/*
 * Copyright 2022 WebAssembly Community Group participants
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

#include "async-utils.h"
#include "support/file.h"
#include "wasm-binary.h"
#include "wasm.h"

namespace wasm::AsyncUtils {

static const Name ASYNCIFY = "asyncify";
static const Name START_UNWIND = "start_unwind";
static const Name STOP_UNWIND = "stop_unwind";
static const Name START_REWIND = "start_rewind";
static const Name STOP_REWIND = "stop_rewind";

static std::string getFullImportName(Name module, Name base) {
  return std::string(module.str) + '.' + base.toString();
}

class PatternMatcher {
public:
  std::string designation;
  std::set<Name> names;
  std::set<std::string> patterns;
  std::set<std::string> patternsMatched;
  std::map<std::string, std::string> unescaped;

  PatternMatcher(std::string designation,
                 Module& module,
                 const String::Split& list)
    : designation(designation) {
    // The lists contain human-readable strings. Turn them into the
    // internal escaped names for later comparisons
    for (auto& name : list) {
      auto escaped = WasmBinaryBuilder::escape(name);
      unescaped[escaped.toString()] = name;
      if (name.find('*') != std::string::npos) {
        patterns.insert(escaped.toString());
      } else {
        auto* func = module.getFunctionOrNull(escaped);
        if (!func) {
          std::cerr << "warning: Asyncify " << designation
                    << "list contained a non-existing function name: " << name
                    << " (" << escaped << ")\n";
        } else if (func->imported()) {
          Fatal() << "Asyncify " << designation
                  << "list contained an imported function name (use the import "
                     "list for imports): "
                  << name << '\n';
        }
        names.insert(escaped.str);
      }
    }
  }

  bool match(Name funcName) {
    if (names.count(funcName) > 0) {
      return true;
    } else {
      for (auto& pattern : patterns) {
        if (String::wildcardMatch(pattern, funcName.toString())) {
          patternsMatched.insert(pattern);
          return true;
        }
      }
    }
    return false;
  }

  void checkPatternsMatches() {
    for (auto& pattern : patterns) {
      if (patternsMatched.count(pattern) == 0) {
        std::cerr << "warning: Asyncify " << designation
                  << "list contained a non-matching pattern: "
                  << unescaped[pattern] << " (" << pattern << ")\n";
      }
    }
  }
};

std::unique_ptr<ModuleAnalyzer> createAnalyzer(Module* module,
                                               PassOptions& options) {
  // Find which things can change the state.
  auto stateChangingImports = String::trim(read_possible_response_file(
    options.getArgumentOrDefault("asyncify-imports", "")));
  auto ignoreImports =
    options.getArgumentOrDefault("asyncify-ignore-imports", "");
  bool allImportsCanChangeState =
    stateChangingImports == "" && ignoreImports == "";
  String::Split listedImports(stateChangingImports, ",");
  // TODO: consider renaming asyncify-ignore-indirect to
  //       asyncify-ignore-nondirect, but that could break users.
  auto ignoreNonDirect =
    options.getArgumentOrDefault("asyncify-ignore-indirect", "") == "";
  std::string removeListInput =
    options.getArgumentOrDefault("asyncify-removelist", "");
  if (removeListInput.empty()) {
    // Support old name for now to avoid immediate breakage TODO remove
    removeListInput = options.getArgumentOrDefault("asyncify-blacklist", "");
  }
  String::Split removeList(
    String::trim(read_possible_response_file(removeListInput)), ",");
  String::Split addList(
    String::trim(read_possible_response_file(
      options.getArgumentOrDefault("asyncify-addlist", ""))),
    ",");
  std::string onlyListInput =
    options.getArgumentOrDefault("asyncify-onlylist", "");
  if (onlyListInput.empty()) {
    // Support old name for now to avoid immediate breakage TODO remove
    onlyListInput = options.getArgumentOrDefault("asyncify-whitelist", "");
  }
  String::Split onlyList(
    String::trim(read_possible_response_file(onlyListInput)), ",");
  auto asserts = options.getArgumentOrDefault("asyncify-asserts", "") != "";
  auto verbose = options.getArgumentOrDefault("asyncify-verbose", "") != "";

  removeList = handleBracketingOperators(removeList);
  addList = handleBracketingOperators(addList);
  onlyList = handleBracketingOperators(onlyList);

  if (!onlyList.empty() && (!removeList.empty() || !addList.empty())) {
    Fatal() << "It makes no sense to use both an asyncify only-list together "
               "with another list.";
  }

  auto canImportChangeState = [&](Name module, Name base) {
    if (allImportsCanChangeState) {
      return true;
    }
    auto full = getFullImportName(module, base);
    for (auto& listedImport : listedImports) {
      if (String::wildcardMatch(listedImport, full)) {
        return true;
      }
    }
    return false;
  };

  return std::make_unique<ModuleAnalyzer>(*module,
                                          canImportChangeState,
                                          ignoreNonDirect,
                                          removeList,
                                          addList,
                                          onlyList,
                                          asserts,
                                          verbose);
}

ModuleAnalyzer::ModuleAnalyzer(
  Module& module,
  std::function<bool(Name, Name)> canImportChangeState,
  bool canIndirectChangeState,
  const String::Split& removeListInput,
  const String::Split& addListInput,
  const String::Split& onlyListInput,
  bool asserts,
  bool verbose)
  : module(module), canIndirectChangeState(canIndirectChangeState),
    asserts(asserts), verbose(verbose) {

  PatternMatcher removeList("remove", module, removeListInput);
  PatternMatcher addList("add", module, addListInput);
  PatternMatcher onlyList("only", module, onlyListInput);

  // Rename the asyncify imports so their internal name matches the
  // convention. This makes replacing them with the implementations
  // later easier.
  std::map<Name, Name> renamings;
  for (auto& func : module.functions) {
    if (func->module == ASYNCIFY) {
      if (func->base == START_UNWIND) {
        renamings[func->name] = ASYNCIFY_START_UNWIND;
      } else if (func->base == STOP_UNWIND) {
        renamings[func->name] = ASYNCIFY_STOP_UNWIND;
      } else if (func->base == START_REWIND) {
        renamings[func->name] = ASYNCIFY_START_REWIND;
      } else if (func->base == STOP_REWIND) {
        renamings[func->name] = ASYNCIFY_STOP_REWIND;
      } else {
        Fatal() << "call to unidenfied asyncify import: " << func->base;
      }
    }
  }
  ModuleUtils::renameFunctions(module, renamings);

  // Scan to see which functions can directly change the state.
  // Also handle the asyncify imports, removing them (as we will implement
  // them later), and replace calls to them with calls to the later proper
  // name.
  ModuleUtils::CallGraphPropertyAnalysis<Info> scanner(
    module, [&](Function* func, Info& info) {
      info.name = func->name;
      if (func->imported()) {
        // The relevant asyncify imports can definitely change the state.
        if (func->module == ASYNCIFY &&
            (func->base == START_UNWIND || func->base == STOP_REWIND)) {
          info.canChangeState = true;
        } else {
          info.canChangeState = canImportChangeState(func->module, func->base);
          if (verbose && info.canChangeState) {
            std::cout << "[asyncify] " << func->name
                      << " is an import that can change the state\n";
          }
        }
        return;
      }
      struct Walker : PostWalker<Walker> {
        Info& info;
        Module& module;
        bool canIndirectChangeState;

        Walker(Info& info, Module& module, bool canIndirectChangeState)
          : info(info), module(module),
            canIndirectChangeState(canIndirectChangeState) {}

        void visitCall(Call* curr) {
          if (curr->isReturn) {
            Fatal() << "tail calls not yet supported in asyncify";
          }
          auto* target = module.getFunction(curr->target);
          if (target->imported() && target->module == ASYNCIFY) {
            // Redirect the imports to the functions we'll add later.
            if (target->base == START_UNWIND) {
              info.canChangeState = true;
              info.isTopMostRuntime = true;
            } else if (target->base == STOP_UNWIND) {
              info.isBottomMostRuntime = true;
            } else if (target->base == START_REWIND) {
              info.isBottomMostRuntime = true;
            } else if (target->base == STOP_REWIND) {
              info.canChangeState = true;
              info.isTopMostRuntime = true;
            } else {
              WASM_UNREACHABLE("call to unidenfied asyncify import");
            }
          }
        }
        void visitCallIndirect(CallIndirect* curr) {
          if (curr->isReturn) {
            Fatal() << "tail calls not yet supported in asyncify";
          }
          if (canIndirectChangeState) {
            info.canChangeState = true;
          }
          // TODO optimize the other case, at least by type
        }
      };
      Walker walker(info, module, canIndirectChangeState);
      walker.walk(func->body);

      if (info.isBottomMostRuntime) {
        info.canChangeState = false;
        // TODO: issue warnings on suspicious things, like a function in
        //       the bottom-most runtime also doing top-most runtime stuff
        //       like starting and unwinding.
      }
      if (verbose && info.canChangeState) {
        std::cout << "[asyncify] " << func->name
                  << " can change the state due to initial scan\n";
      }
    });

  // Functions in the remove-list are assumed to not change the state.
  for (auto& [func, info] : scanner.map) {
    if (removeList.match(func->name)) {
      info.inRemoveList = true;
      if (verbose && info.canChangeState) {
        std::cout << "[asyncify] " << func->name
                  << " is in the remove-list, ignore\n";
      }
      info.canChangeState = false;
    }
  }

  // Remove the asyncify imports, if any, and any calls to them.
  std::vector<Name> funcsToDelete;
  for (auto& [func, info] : scanner.map) {
    auto& callsTo = info.callsTo;
    if (func->imported() && func->module == ASYNCIFY) {
      funcsToDelete.push_back(func->name);
    }
    std::vector<Function*> callersToDelete;
    for (auto* target : callsTo) {
      if (target->imported() && target->module == ASYNCIFY) {
        callersToDelete.push_back(target);
      }
    }
    for (auto* target : callersToDelete) {
      callsTo.erase(target);
    }
  }
  for (auto name : funcsToDelete) {
    module.removeFunction(name);
  }

  scanner.propagateBack([](const Info& info) { return info.canChangeState; },
                        [](const Info& info) {
                          return !info.isBottomMostRuntime &&
                                 !info.inRemoveList;
                        },
                        [verbose](Info& info, Function* reason) {
                          if (verbose && !info.canChangeState) {
                            std::cout << "[asyncify] " << info.name
                                      << " can change the state due to "
                                      << reason->name << "\n";
                          }
                          info.canChangeState = true;
                        },
                        scanner.IgnoreNonDirectCalls);

  map.swap(scanner.map);

  if (!onlyListInput.empty()) {
    // Only the functions in the only-list can change the state.
    for (auto& func : module.functions) {
      if (!func->imported()) {
        auto& info = map[func.get()];
        bool matched = onlyList.match(func->name);
        info.canChangeState = matched;
        if (matched) {
          info.addedFromList = true;
        }
        if (verbose) {
          std::cout << "[asyncify] " << func->name
                    << "'s state is set based on the only-list to " << matched
                    << '\n';
        }
      }
    }
  }

  if (!addListInput.empty()) {
    for (auto& func : module.functions) {
      if (!func->imported() && addList.match(func->name)) {
        auto& info = map[func.get()];
        if (verbose && !info.canChangeState) {
          std::cout << "[asyncify] " << func->name
                    << " is in the add-list, add\n";
        }
        info.canChangeState = true;
        info.addedFromList = true;
      }
    }
  }

  removeList.checkPatternsMatches();
  addList.checkPatternsMatches();
  onlyList.checkPatternsMatches();
}

bool ModuleAnalyzer::canChangeState(Expression* curr, Function* func) {
  // Look inside to see if we call any of the things we know can change the
  // state.
  // TODO: caching, this is O(N^2)
  struct Walker : PostWalker<Walker> {
    void visitCall(Call* curr) {
      // We only implement these at the very end, but we know that they
      // definitely change the state.
      if (curr->target == ASYNCIFY_START_UNWIND ||
          curr->target == ASYNCIFY_STOP_REWIND ||
          curr->target == ASYNCIFY_GET_CALL_INDEX ||
          curr->target == ASYNCIFY_CHECK_CALL_INDEX) {
        canChangeState = true;
        return;
      }
      if (curr->target == ASYNCIFY_STOP_UNWIND ||
          curr->target == ASYNCIFY_START_REWIND) {
        isBottomMostRuntime = true;
        return;
      }
      // The target may not exist if it is one of our temporary intrinsics.
      auto* target = module->getFunctionOrNull(curr->target);
      if (target && (*map)[target].canChangeState) {
        canChangeState = true;
      }
    }
    void visitCallIndirect(CallIndirect* curr) { hasIndirectCall = true; }
    Module* module;
    ModuleAnalyzer* analyzer;
    Map* map;
    bool hasIndirectCall = false;
    bool canChangeState = false;
    bool isBottomMostRuntime = false;
  };
  Walker walker;
  walker.module = &module;
  walker.analyzer = this;
  walker.map = &map;
  walker.walk(curr);
  // An indirect call is normally ignored if we are ignoring indirect calls.
  // However, see the docs at the top: if the function we are inside was
  // specifically added by the user (in the only-list or the add-list) then we
  // instrument indirect calls from it (this allows specifically allowing some
  // indirect calls but not others).
  if (walker.hasIndirectCall &&
      (canIndirectChangeState || map[func].addedFromList)) {
    walker.canChangeState = true;
  }
  // The bottom-most runtime can never change the state.
  return walker.canChangeState && !walker.isBottomMostRuntime;
}

} // namespace wasm::AsyncUtils
