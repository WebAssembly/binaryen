/*
 * Copyright 2016 WebAssembly Community Group participants
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
// Prints the call graph in .dot format. You can use http://www.graphviz.org/ to view .dot files.
//


#include <memory>
#include <iomanip>
#include "wasm.h"
#include "pass.h"
#include "ast_utils.h"

namespace wasm {

struct PrintCallGraph : public Pass {
  void run(PassRunner* runner, Module* module) override {
    std::ostream &o = std::cout;
    o << "digraph call {\n"
         "  rankdir = LR;\n"
         "  subgraph cluster_key {\n"
         "    node [shape=box, fontname=courier, fontsize=10];\n"
         "    edge [fontname=courier, fontsize=10];\n"
         "    label = \"Key\";\n"
         "    \"Import\" [style=\"filled\", fillcolor=\"turquoise\"];\n"
         "    \"Export\" [style=\"filled\", fillcolor=\"gray\"];\n"
         "    \"Indirect Target\" [style=\"filled, rounded\", fillcolor=\"white\"];\n"
         "    \"A\" -> \"B\" [style=\"filled, rounded\", label = \"Direct Call\"];\n"
         "  }\n\n"
         "  node [shape=box, fontname=courier, fontsize=10];\n";

    // All Functions
    for (auto& func : module->functions) {
      std::cout << "  \"" << func.get()->name << "\" [style=\"filled\", fillcolor=\"white\"];\n";
    }

    // Imports Nodes
    for (auto& curr : module->imports) {
      if (curr->kind == ExternalKind::Function) {
        o << "  \"" << curr->name << "\" [style=\"filled\", fillcolor=\"turquoise\"];\n";
      }
    }

    // Exports Nodes
    for (auto& curr : module->exports) {
      if (curr->kind == ExternalKind::Function) {
        Function* func = module->getFunction(curr->value);
        o << "  \"" << func->name << "\" [style=\"filled\", fillcolor=\"gray\"];\n";
      }
    }

    struct CallPrinter : public PostWalker<CallPrinter> {
      Module *module;
      Function *currFunction;
      std::set<Name> visitedTargets; // Used to avoid printing duplicate edges.
      std::vector<Function*> allIndirectTargets;
      CallPrinter(Module *module) : module(module) {
        // Walk function bodies.
        for (auto& func : module->functions) {
          currFunction = func.get();
          visitedTargets.clear();
          walk(func.get()->body);
        }
      }
      void visitCall(Call *curr) {
        auto* target = module->getFunction(curr->target);
        if (visitedTargets.count(target->name) > 0) return;
        visitedTargets.insert(target->name);
        std::cout << "  \"" << currFunction->name << "\" -> \"" << target->name << "\"; // call\n";
      }
      void visitCallImport(CallImport *curr) {
        auto name = curr->target;
        if (visitedTargets.count(name) > 0) return;
        visitedTargets.insert(name);
        std::cout << "  \"" << currFunction->name << "\" -> \"" << name << "\"; // callImport\n";
      }
    };
    CallPrinter printer(module);

    // Indirect Targets
    for (auto& segment : module->table.segments) {
      for (auto& curr : segment.data) {
        auto* func = module->getFunction(curr);
        o << "  \"" << func->name << "\" [style=\"filled, rounded\"];\n";
      }
    }

    o << "}\n";
  }
};

Pass *createPrintCallGraphPass() {
  return new PrintCallGraph();
}

} // namespace wasm
