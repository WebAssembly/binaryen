/*
 * Copyright 2026 WebAssembly Community Group participants
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
// Instruments the JSPI (JavaScript Promise Integration) boundary of a module
// with lifecycle hooks, so that the runtime linked into the module can observe
// when a stack-switching fiber is entered, exited, suspended and resumed.
//
// The hooks must run inside the fiber's own wasm frames, at the instruction
// immediately before/after the boundary call: a JS wrapper around a promising
// export or a suspending import only observes the transition a microtask
// later, during which another fiber may already have run. Hence this pass,
// which wraps:
//
//  * every exported function matching the jspi-exports patterns (these are
//    the exports the host wraps with WebAssembly.promising), with the ENTER
//    event before and the EXIT event after the call, and
//  * every imported function matching the jspi-imports patterns (those the
//    host wraps with WebAssembly.Suspending), with the SUSPEND event before
//    and the RESUME event after the call.
//
// The module must export the four hooks the events are delivered to:
//
//   __jspi_enter:   [] -> [i64 token]
//   __jspi_exit:    [i64 token, i32 error] -> []
//   __jspi_suspend: [] -> [i64 token]
//   __jspi_resume:  [i64 token, i32 error] -> []
//
//   token: opaque to the pass. The value returned by the "before" hook (enter,
//          suspend) is kept in a wasm local, which JSPI preserves across the
//          suspension, and passed to the matching "after" hook (exit, resume).
//          The runtime decides what it means (Emscripten uses a pointer to its
//          fiber record).
//   error: 1 when the wrapped call threw, else 0.
//
// All policy lives in those functions; the wrappers only hold their state in
// locals. On an exceptional exit the "after" event is delivered with error=1
// and the exception is then rethrown unchanged, whatever its tag (a JS
// exception or a wasm one). Traps are not exceptions and bypass the hook.
//
// The pass enables the exception handling and reference types features
// (try_table/exnref). Engines reject modules mixing the legacy and
// standardized exception handling instructions, so if the module already uses
// legacy try/catch the wrappers are emitted in that form too.
//
// Arguments (asyncify-imports style: comma or newline separated, '*'
// wildcards, @file response files):
//
//   --pass-arg=jspi-imports@module.base,...   patterns over import module.base
//   --pass-arg=jspi-exports@name,...          patterns over export names
//   --pass-arg=jspi-dyncalls                  also export a wrapped trampoline
//                                             __jspi_dyncall_<sig>(fptr, ...)
//                                             for every function signature in
//                                             the table, so that the host can
//                                             make function pointers promising
//                                             without bypassing the hooks
//   --pass-arg=jspi-dyncall-sigs@sig,...      additional trampoline signatures
//
// <sig> uses the Emscripten signature alphabet of asm_v_wasm.h getSig()
// (result then params; v i j f d), which the host uses to look the
// trampolines up at runtime.
//

#include "asm_v_wasm.h"
#include "ir/element-utils.h"
#include "ir/find_all.h"
#include "ir/module-utils.h"
#include "ir/names.h"
#include "pass.h"
#include "support/file.h"
#include "support/insert_ordered.h"
#include "support/string.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

namespace {

const Name ENTER("__jspi_enter");
const Name EXIT("__jspi_exit");
const Name SUSPEND("__jspi_suspend");
const Name RESUME("__jspi_resume");
const std::string PREFIX = "byn$jspi-hooks$";
const Name ANY_LABEL("byn$jspi-hooks$any");
const Name TRY_LABEL("byn$jspi-hooks$try");

struct JSPIHooks : public Pass {
  // Imports become defined functions that call hooks and throw.
  bool addsEffects() override { return true; }
  // All added locals are numeric or nullable.
  bool requiresNonNullableLocalFixups() override { return false; }
  // New function bodies shift code offsets.
  bool invalidatesDWARF() override { return true; }

  Module* module = nullptr;
  Name enter, exit, suspend, resume;
  bool legacyEH = false;

  void run(Module* module_) override {
    module = module_;

    String::Split importPatterns(String::trim(read_possible_response_file(
                                   getArgumentOrDefault("jspi-imports", ""))),
                                 String::Split::NewLineOr(","));
    String::Split exportPatterns(String::trim(read_possible_response_file(
                                   getArgumentOrDefault("jspi-exports", ""))),
                                 String::Split::NewLineOr(","));

    std::vector<Function*> imports;
    for (auto& func : module->functions) {
      if (func->imported() && !isGenerated(func->name) &&
          matches(importPatterns,
                  func->module.toString() + '.' + func->base.toString())) {
        imports.push_back(func.get());
      }
    }
    std::vector<Export*> exports;
    for (auto& ex : module->exports) {
      if (ex->kind == ExternalKind::Function &&
          !isGenerated(*ex->getInternalName()) &&
          matches(exportPatterns, ex->name.toString())) {
        exports.push_back(ex.get());
      }
    }
    Table* dynCallTable = nullptr;
    String::Split dynCallSigs;
    if (hasArgument("jspi-dyncalls")) {
      for (auto& table : module->tables) {
        if (table->type.isFunction()) {
          dynCallTable = table.get();
          break;
        }
      }
      dynCallSigs = String::Split(
        String::trim(getArgumentOrDefault("jspi-dyncall-sigs", "")),
        String::Split::NewLineOr(","));
    }
    if (imports.empty() && exports.empty() && !dynCallTable) {
      return;
    }

    Signature beforeSig({}, Type::i64);
    Signature afterSig({Type::i64, Type::i32}, Type::none);
    enter = getHook(ENTER, beforeSig);
    exit = getHook(EXIT, afterSig);
    suspend = getHook(SUSPEND, beforeSig);
    resume = getHook(RESUME, afterSig);
    // The hook implementations are never wrapped, even when imported or
    // exported under a matching name.
    auto isHook = [&](Name name) {
      return name == enter || name == exit || name == suspend || name == resume;
    };
    std::erase_if(imports, [&](Function* f) { return isHook(f->name); });
    std::erase_if(exports,
                  [&](Export* ex) { return isHook(*ex->getInternalName()); });
    if (imports.empty() && exports.empty() && !dynCallTable) {
      return;
    }

    legacyEH = usesLegacyEH();
    module->features.enable(FeatureSet::ExceptionHandling |
                            FeatureSet::ReferenceTypes);

    if (!imports.empty()) {
      std::unordered_set<Name> wrapped;
      for (auto* import : imports) {
        wrapImport(import);
        wrapped.insert(import->name);
      }
      // The wrapped functions are now defined, so their exact types differ
      // from the imports they replaced; refinalize references to them.
      struct Refinalizer : public WalkerPass<PostWalker<Refinalizer>> {
        bool isFunctionParallel() override { return true; }
        std::unordered_set<Name>& wrapped;
        Refinalizer(std::unordered_set<Name>& wrapped) : wrapped(wrapped) {}
        std::unique_ptr<Pass> create() override {
          return std::make_unique<Refinalizer>(wrapped);
        }
        void visitRefFunc(RefFunc* curr) {
          if (wrapped.count(curr->func)) {
            curr->finalize(*getModule());
          }
        }
      };
      Refinalizer refinalizer(wrapped);
      refinalizer.run(getPassRunner(), module);
      refinalizer.runOnModuleCode(getPassRunner(), module);
    }
    std::unordered_map<Name, Name> wrappers;
    for (auto* ex : exports) {
      auto* name = ex->getInternalName();
      auto [iter, inserted] = wrappers.insert({*name, Name()});
      if (inserted) {
        iter->second = wrapExport(module->getFunction(*name));
      }
      *name = iter->second;
    }
    if (dynCallTable) {
      makeDynCalls(dynCallTable, dynCallSigs);
    }
  }

private:
  const Type exnref = Type(HeapType::exn, Nullable);

  static bool isGenerated(Name name) {
    return name.startsWith(std::string_view(PREFIX));
  }

  static bool matches(const String::Split& patterns, const std::string& name) {
    for (auto& pattern : patterns) {
      if (String::wildcardMatch(pattern, name)) {
        return true;
      }
    }
    return false;
  }

  Name getHook(Name name, Signature sig) {
    auto* ex = module->getExportOrNull(name);
    if (!ex || ex->kind != ExternalKind::Function) {
      Fatal() << "jspi-hooks: module must export function " << name;
    }
    auto* func = module->getFunction(*ex->getInternalName());
    if (func->getSig() != sig) {
      Fatal() << "jspi-hooks: export " << name << " has type " << func->getSig()
              << " but " << sig << " is required";
    }
    return func->name;
  }

  bool usesLegacyEH() {
    // {legacy, standardized}
    ModuleUtils::ParallelFunctionAnalysis<std::pair<bool, bool>> analysis(
      *module, [](Function* func, std::pair<bool, bool>& found) {
        if (!func->imported()) {
          found = {!FindAll<Try>(func->body).list.empty(),
                   !FindAll<TryTable>(func->body).list.empty()};
        }
      });
    bool legacy = false;
    bool standard = false;
    for (auto& [_, found] : analysis.map) {
      legacy |= found.first;
      standard |= found.second;
    }
    if (legacy && standard) {
      Fatal() << "jspi-hooks: module mixes legacy and standardized exception "
                 "handling; run --translate-to-exnref first";
    }
    return legacy;
  }

  // Moves the import to a new function and turns the original function object
  // into the wrapper, so every existing use (calls, ref.func, element
  // segments, exports) reaches the wrapper without any reference rewriting.
  void wrapImport(Function* import) {
    auto raw = Builder::makeFunction(
      Names::getValidFunctionName(*module,
                                  PREFIX + "import$" + import->name.toString()),
      import->type,
      {});
    raw->module = import->module;
    raw->base = import->base;
    raw->hasExplicitName = true;
    Name rawName = module->addFunction(std::move(raw))->name;
    import->module = Name();
    import->base = Name();
    import->type = import->type.with(Exact);
    makeWrapperBody(import, makeCall(import, rawName), suspend, resume);
  }

  static Type sigType(char c, Type addressType) {
    switch (c) {
      case 'v':
        return Type::none;
      case 'i':
        return Type::i32;
      case 'j':
        return Type::i64;
      case 'f':
        return Type::f32;
      case 'd':
        return Type::f64;
      case 'p':
        return addressType;
      default:
        Fatal() << "jspi-hooks: invalid signature character '" << c << "'";
    }
  }

  void makeDynCalls(Table* table, const String::Split& sigs) {
    InsertOrderedSet<HeapType> types;
    for (auto& segment : module->elementSegments) {
      if (segment->table != table->name) {
        continue;
      }
      ElementUtils::iterElementSegmentFunctionNames(
        segment.get(), [&](Name name, Index) {
          types.insert(module->getFunction(name)->type.getHeapType());
        });
    }
    for (auto& sigStr : sigs) {
      if (sigStr.empty()) {
        Fatal() << "jspi-hooks: empty signature in jspi-dyncall-sigs";
      }
      std::vector<Type> params;
      for (size_t i = 1; i < sigStr.size(); i++) {
        params.push_back(sigType(sigStr[i], table->addressType));
      }
      types.insert(HeapType(
        Signature(Type(params), sigType(sigStr[0], table->addressType))));
    }
    for (auto type : types) {
      auto sig = type.getSignature();
      if (sig.results.isTuple() || !isJSSig(sig)) {
        continue;
      }
      std::string sigStr = getSig(sig.results, sig.params);
      Name name = std::string("__jspi_dyncall_") + sigStr;
      if (module->getExportOrNull(name)) {
        continue;
      }
      std::vector<Type> params{table->addressType};
      for (auto param : sig.params) {
        params.push_back(param);
      }
      auto func = Builder::makeFunction(
        Names::getValidFunctionName(*module, PREFIX + "dyncall$" + sigStr),
        Signature(Type(params), sig.results),
        {});
      func->hasExplicitName = true;
      Builder builder(*module);
      std::vector<Expression*> args;
      for (Index i = 0; i < sig.params.size(); i++) {
        args.push_back(builder.makeLocalGet(i + 1, sig.params[i]));
      }
      auto* call = builder.makeCallIndirect(
        table->name, builder.makeLocalGet(0, table->addressType), args, type);
      auto* added = module->addFunction(std::move(func));
      makeWrapperBody(added, call, enter, exit);
      module->addExport(
        Builder::makeExport(name, added->name, ExternalKind::Function));
    }
  }

  static bool isJSSig(Signature sig) {
    for (auto type : sig.results) {
      if (!type.isNumber() || type == Type::v128) {
        return false;
      }
    }
    for (auto type : sig.params) {
      if (!type.isNumber() || type == Type::v128) {
        return false;
      }
    }
    return true;
  }

  Name wrapExport(Function* target) {
    auto wrapper = Builder::makeFunction(
      Names::getValidFunctionName(*module,
                                  PREFIX + "export$" + target->name.toString()),
      target->type.with(Exact),
      {});
    wrapper->hasExplicitName = true;
    auto* func = module->addFunction(std::move(wrapper));
    makeWrapperBody(func, makeCall(func, target->name), enter, exit);
    return func->name;
  }

  Expression* makeCall(Function* func, Name target) {
    Builder builder(*module);
    auto params = func->getParams();
    std::vector<Expression*> args;
    for (Index i = 0; i < params.size(); i++) {
      args.push_back(builder.makeLocalGet(i, params[i]));
    }
    return builder.makeCall(target, args, func->getResults());
  }

  // Standardized form ($before/$after are enter/exit or suspend/resume):
  //
  //  (local.set $tok (call $before))
  //  (local.set $exn
  //    (block $any (result exnref)
  //      (try_table (catch_all_ref $any)
  //        (local.set $r (call $target params...)))
  //      (call $after (local.get $tok) (i32.const 0))
  //      (return (local.get $r))))
  //  (call $after (local.get $tok) (i32.const 1))
  //  (throw_ref (local.get $exn))
  //
  // Legacy form:
  //
  //  (local.set $tok (call $before))
  //  (try $try
  //    (do (local.set $r (call $target params...)))
  //    (catch_all
  //      (call $after (local.get $tok) (i32.const 1))
  //      (rethrow $try)))
  //  (call $after (local.get $tok) (i32.const 0))
  //  (return (local.get $r))
  void
  makeWrapperBody(Function* func, Expression* call, Name before, Name after) {
    Builder builder(*module);
    auto results = func->getResults();
    bool hasResult = results != Type::none;
    Index tok = Builder::addVar(func, Type::i64);
    Index result = hasResult ? Builder::addVar(func, results) : 0;

    if (hasResult) {
      call = builder.makeLocalSet(result, call);
    }
    auto afterCall = [&](int error) {
      return builder.makeCall(after,
                              {builder.makeLocalGet(tok, Type::i64),
                               builder.makeConst(int32_t(error))},
                              Type::none);
    };
    auto makeReturn = [&]() {
      return builder.makeReturn(
        hasResult ? builder.makeLocalGet(result, results) : nullptr);
    };
    auto* beforeCall =
      builder.makeLocalSet(tok, builder.makeCall(before, {}, Type::i64));

    if (legacyEH) {
      auto* catchAll =
        builder.makeBlock({afterCall(1), builder.makeRethrow(TRY_LABEL)});
      auto* tryExpr =
        builder.makeTry(TRY_LABEL, call, {}, {catchAll}, Type::none);
      func->body = builder.makeBlock(
        {beforeCall, tryExpr, afterCall(0), makeReturn()}, Type::unreachable);
      return;
    }

    Index exn = Builder::addVar(func, exnref);
    auto* tryTable = builder.makeTryTable(call, {Name()}, {ANY_LABEL}, {true});
    auto* anyBlock = builder.makeBlock(
      ANY_LABEL, {tryTable, afterCall(0), makeReturn()}, exnref);
    func->body = builder.makeBlock(
      {beforeCall,
       builder.makeLocalSet(exn, anyBlock),
       afterCall(1),
       builder.makeThrowRef(builder.makeLocalGet(exn, exnref))},
      Type::unreachable);
  }
};

} // anonymous namespace

Pass* createJSPIHooksPass() { return new JSPIHooks(); }

} // namespace wasm
