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
    o << "digraph call {\n";
    o << "  rankdir = LR;\n";
    o << "  subgraph cluster_key {\n";
    o << "    node [shape=box, style=rounded, fontname=courier, fontsize=10];\n";
    o << "    edge [fontname=courier, fontsize=10];\n";
    o << "    label = \"Key\";\n";
    o << "    \"Import\" [style=\"filled, rounded\", fillcolor=\"turquoise\"];\n";
    o << "    \"Export\" [style=\"filled, rounded\", fillcolor=\"gray\"];\n";
    o << "    \"A\" -> \"B\" [style=\"filled, rounded\", label = \"Direct Call\"];\n";
    o << "    \"C\" -> \"D\" [style=\"filled, rounded, dashed\", label = \"Possible Indirect Call\"];\n";
    o << "  }\n\n";
    o << "  node [shape=box,style=rounded, fontname=courier, fontsize=10];\n";

    // Imports Nodes
    for (auto& curr : module->imports) {
      if (curr->kind == ExternalKind::Function) {
        o << "  \"" << curr->name << "\" [style=\"filled, rounded\", fillcolor=\"turquoise\"];\n";
      }
    }

    // Exports Nodes
    for (auto& curr : module->exports) {
      if (curr->kind == ExternalKind::Function) {
        Function* func = module->getFunction(curr->value);
        o << "  \"" << func->name << "\" [style=\"filled, rounded\", fillcolor=\"gray\"];\n";
      }
    }

    struct CallPrinter : public PostWalker<CallPrinter, Visitor<CallPrinter>> {
      Module *module;
      Function *currFunction;
      std::set<Name> visitedTargets; // Used to avoid printing duplicate edges.
      std::vector<Function*> allIndirectTargets;
      CallPrinter(Module *module) : module(module) {
        // Gather targets of indirect calls.
        for (auto& segment : module->table.segments) {
          for (auto& curr : segment.data) {
            allIndirectTargets.push_back(module->getFunction(curr));
          }
        }
        // Walk function bodies.
        for (auto& func : module->functions) {
          currFunction = func.get();
          std::cout << "  \"" << func->name << "\";\n";
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
      void visitCallIndirect(CallIndirect *curr) {
        // Find eligible indirect targets.
        auto* currType = module->getFunctionType(curr->fullType);
        for (auto& target : allIndirectTargets) {
          auto* targetType = module->getFunctionType(target->type);
          if (targetType->structuralComparison(*currType)) continue;
          auto name = target->name;
          if (visitedTargets.count(name) > 0) continue;
          visitedTargets.insert(name);
          std::cout << "  \"" << currFunction->name << "\" -> \"" << name << "\" [style=\"dashed\"]; // callIndirect\n";
        }
      }
    };
    CallPrinter printer(module);
    o << "}\n";
  }
};

Pass *createPrintCallGraphPass() {
  return new PrintCallGraph();
}

} // namespace wasm
