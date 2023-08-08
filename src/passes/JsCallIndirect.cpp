/*
 * Copyright 2017 WebAssembly Community Group participants
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
// This pass replaces all call_indirect instructions with a call to JS side
// js_call_indirect_xxxx functions that can perform debug analysis of the
// call in question. Must run after FuncCastEmulation pass, if that is
// desired.
//

#include <string>
#include <unordered_map>
#include <unordered_set>

#include <ir/element-utils.h>
#include <ir/literal-utils.h>
#include <pass.h>
#include <wasm-builder.h>
#include <wasm.h>
#include <asm_v_wasm.h>

namespace wasm {

void setFunctionAsImported(std::unique_ptr<Function>& import, Module* m);

typedef std::unordered_map<std::string, std::unique_ptr<Function>>
  JsCallIndirectMap;

struct ParallelJsCallIndirect
  : public WalkerPass<PostWalker<ParallelJsCallIndirect>> {
  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<ParallelJsCallIndirect>();
  }

  void visitCallIndirect(CallIndirect* curr) {
    Module* module = getModule();
    Builder builder(*module);
    std::vector<Expression*> callArgs;
    callArgs.push_back(curr->target);
    callArgs.insert(
      callArgs.end(), curr->operands.begin(), curr->operands.end());
    std::string jsCallIndirect =
      "js_call_indirect_" + getSigFromStructs(curr->type, curr->operands);
    if (module->getFunctionOrNull(jsCallIndirect)) {
      replaceCurrent(builder.makeCall(jsCallIndirect, callArgs, curr->type));
    } else {
      // The code is attempting a call_indirect via a signature that there does not exist
      // any function in the whole program. We can abort here since that will not work at runtime.
      // TODO: Maybe just create on the fly a "js_call_indirect_" function for this nonexisting
      // signature?
      replaceCurrent(builder.makeCall("abort", {}, Type::none));
    }
  }
};

struct JsCallIndirect : public Pass {
  void run(Module* module) override {
    std::unordered_set<Signature> seen_sigs;
    for (std::unique_ptr<Function>& func : module->functions) {
      Signature sig = func->getSig();
      std::string type_str = getSig(sig.results, sig.params);
      if (seen_sigs.find(sig) != seen_sigs.end())
        continue;
      seen_sigs.insert(sig);

      std::vector<Type> params;
      params.push_back(Type::i32);
      for (auto t : sig.params)
        params.push_back(t);
      auto& import =
        Builder::makeFunction(std::string("js_call_indirect_") + type_str,
                               Signature(Type(params), sig.results.getBasic()),
                               {});
      setFunctionAsImported(import, module);
      import->base = type_str;
      module->addFunction(std::move(import));
    }

    // route all call_indirects to js_call_indirect_*() variants
    ParallelJsCallIndirect().run(getPassRunner(), module);
  }
};

Pass* createJsCallIndirectPass() { return new JsCallIndirect(); }

} // namespace wasm
