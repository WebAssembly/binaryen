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
// Misc optimizations that are useful for and/or are only valid for
// emscripten output.
//

#include <asmjs/shared-constants.h>
#include <ir/import-utils.h>
#include <ir/localize.h>
#include <ir/memory-utils.h>
#include <ir/module-utils.h>
#include <ir/table-utils.h>
#include <pass.h>
#include <shared-constants.h>
#include <wasm-builder.h>
#include <wasm.h>

namespace wasm {

namespace {

static bool isInvoke(Name name) { return name.startsWith("invoke_"); }

struct OptimizeCalls : public WalkerPass<PostWalker<OptimizeCalls>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new OptimizeCalls; }

  void visitCall(Call* curr) {
    // special asm.js imports can be optimized
    auto* func = getModule()->getFunction(curr->target);
    if (!func->imported()) {
      return;
    }
    if (func->module == GLOBAL_MATH) {
      if (func->base == POW) {
        if (auto* exponent = curr->operands[1]->dynCast<Const>()) {
          if (exponent->value == Literal(double(2.0))) {
            // This is just a square operation, do a multiply
            Localizer localizer(curr->operands[0], getFunction(), getModule());
            Builder builder(*getModule());
            replaceCurrent(builder.makeBinary(
              MulFloat64,
              localizer.expr,
              builder.makeLocalGet(localizer.index, localizer.expr->type)));
          } else if (exponent->value == Literal(double(0.5))) {
            // This is just a square root operation
            replaceCurrent(
              Builder(*getModule()).makeUnary(SqrtFloat64, curr->operands[0]));
          }
        }
      }
    }
  }
};

} // namespace

struct PostEmscripten : public Pass {
  void run(PassRunner* runner, Module* module) override {
    // Apply the sbrk ptr, if it was provided.
    auto sbrkPtrStr =
      runner->options.getArgumentOrDefault("emscripten-sbrk-ptr", "");
    if (sbrkPtrStr != "") {
      auto sbrkPtr = std::stoi(sbrkPtrStr);
      ImportInfo imports(*module);
      auto* func = imports.getImportedFunction(ENV, "emscripten_get_sbrk_ptr");
      if (func) {
        Builder builder(*module);
        func->body = builder.makeConst(Literal(int32_t(sbrkPtr)));
        func->module = func->base = Name();
      }
      // Apply the sbrk ptr value, if it was provided. This lets emscripten set
      // up sbrk entirely in wasm, without depending on the JS side to init
      // anything; this is necessary for standalone wasm mode, in which we do
      // not have any JS. Otherwise, the JS would set this value during
      // startup.
      auto sbrkValStr =
        runner->options.getArgumentOrDefault("emscripten-sbrk-val", "");
      if (sbrkValStr != "") {
        uint32_t sbrkVal = std::stoi(sbrkValStr);
        auto end = sbrkPtr + sizeof(sbrkVal);
        // Flatten memory to make it simple to write to. Later passes can
        // re-optimize it.
        MemoryUtils::ensureExists(module->memory);
        if (!MemoryUtils::flatten(module->memory, end, module)) {
          Fatal() << "cannot apply sbrk-val since memory is not flattenable\n";
        }
        auto& segment = module->memory.segments[0];
        assert(segment.offset->cast<Const>()->value.geti32() == 0);
        assert(end <= segment.data.size());
        memcpy(segment.data.data() + sbrkPtr, &sbrkVal, sizeof(sbrkVal));
      }
    }

    // Optimize calls
    OptimizeCalls().run(runner, module);

    // Optimize exceptions
    optimizeExceptions(runner, module);
  }

  // Optimize exceptions (and setjmp) by removing unnecessary invoke* calls.
  // An invoke is a call to JS with a function pointer; JS does a try-catch
  // and calls the pointer, catching and reporting any error. If we know no
  // exception will be thrown, we can simply skip the invoke.
  void optimizeExceptions(PassRunner* runner, Module* module) {
    // First, check if this code even uses invokes.
    bool hasInvokes = false;
    for (auto& imp : module->functions) {
      if (imp->imported() && imp->module == ENV && isInvoke(imp->base)) {
        hasInvokes = true;
      }
    }
    if (!hasInvokes) {
      return;
    }
    // Next, see if the Table is flat, which we need in order to see where
    // invokes go statically. (In dynamic linking, the table is not flat,
    // and we can't do this.)
    FlatTable flatTable(module->table);
    if (!flatTable.valid) {
      return;
    }
    // This code has exceptions. Find functions that definitely cannot throw,
    // and remove invokes to them.
    struct Info
      : public ModuleUtils::CallGraphPropertyAnalysis<Info>::FunctionInfo {
      bool canThrow = false;
    };
    ModuleUtils::CallGraphPropertyAnalysis<Info> analyzer(
      *module, [&](Function* func, Info& info) {
        if (func->imported()) {
          // Assume any import can throw. We may want to reduce this to just
          // longjmp/cxa_throw/etc.
          info.canThrow = true;
        }
      });

    analyzer.propagateBack([](const Info& info) { return info.canThrow; },
                           [](const Info& info) { return true; },
                           [](Info& info) { info.canThrow = true; });

    // Apply the information.
    struct OptimizeInvokes : public WalkerPass<PostWalker<OptimizeInvokes>> {
      bool isFunctionParallel() override { return true; }

      Pass* create() override { return new OptimizeInvokes(map, flatTable); }

      std::map<Function*, Info>& map;
      FlatTable& flatTable;

      OptimizeInvokes(std::map<Function*, Info>& map, FlatTable& flatTable)
        : map(map), flatTable(flatTable) {}

      void visitCall(Call* curr) {
        if (isInvoke(curr->target)) {
          // The first operand is the function pointer index, which must be
          // constant if we are to optimize it statically.
          if (auto* index = curr->operands[0]->dynCast<Const>()) {
            auto actualTarget = flatTable.names.at(index->value.geti32());
            if (!map[getModule()->getFunction(actualTarget)].canThrow) {
              // This invoke cannot throw! Make it a direct call.
              curr->target = actualTarget;
              for (Index i = 0; i < curr->operands.size() - 1; i++) {
                curr->operands[i] = curr->operands[i + 1];
              }
              curr->operands.resize(curr->operands.size() - 1);
            }
          }
        }
      }
    };
    OptimizeInvokes(analyzer.map, flatTable).run(runner, module);
  }
};

Pass* createPostEmscriptenPass() { return new PostEmscripten(); }

} // namespace wasm
