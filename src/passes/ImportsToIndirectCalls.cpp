/*
 * Copyright 2019 WebAssembly Community Group participants
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
// Turn indirect calls into direct calls. This is possible if we know
// the table cannot change, and if we see a constant argument for the
// indirect call's index.
//

#include <unordered_map>

#include "asm_v_wasm.h"
//#include "ir/table-utils.h"
#include "ir/utils.h"
#include "pass.h"
#include "pretty_printing.h"
#include "support/json.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "wasm.h"
#include "wasm-binary.h"
#include <fstream>

void json::Value::stringify(std::ostream& os, bool pretty) {
  static int indent = 0;
#define indentify()                                                                                \
  {                                                                                                \
    for (int i_ = 0; i_ < indent; i_++)                                                            \
      os << "  ";                                                                                  \
  }
  switch (type) {
    case String: {
      if (str.str) {
        os << '"' << str.str << '"';
      } else {
        os << "\"(null)\"";
      }
      break;
    }
    case Number: {
      // doubles can have 17 digits of precision
      os << std::setprecision(17) << num;
      break;
    }
    case Array: {
      if (arr->size() == 0) {
        os << "[]";
        break;
      }
      os << '[';
      if (pretty) {
        os << std::endl;
        indent++;
      }
      for (size_t i = 0; i < arr->size(); i++) {
        if (i > 0) {
          if (pretty) {
            os << "," << std::endl;
          } else {
            os << ", ";
          }
        }
        indentify();
        (*arr)[i]->stringify(os, pretty);
      }
      if (pretty) {
        os << std::endl;
        indent--;
      }
      indentify();
      os << ']';
      break;
    }
    case Null: {
      os << "null";
      break;
    }
    case Bool: {
      os << (boo ? "true" : "false");
      break;
    }
    case Object: {
      os << '{';
      if (pretty) {
        os << std::endl;
        indent++;
      }
      bool first = true;
      for (auto i : *obj) {
        if (first) {
          first = false;
        } else {
          os << ", ";
          if (pretty) {
            os << std::endl;
          }
        }
        indentify();
        os << '"' << i.first.c_str() << "\": ";
        i.second->stringify(os, pretty);
      }
      if (pretty) {
        os << std::endl;
        indent--;
      }
      indentify();
      os << '}';
      break;
    }
    default:
      break;
  }
}

namespace wasm {

namespace {

struct FunctionImportsToIndirectCalls
  : public WalkerPass<PostWalker<FunctionImportsToIndirectCalls>> {
  bool isFunctionParallel() override { return false; }

  Pass* create() override { return new FunctionImportsToIndirectCalls(); }

  FunctionImportsToIndirectCalls() { 
      IAT.name = "IAT";
      myfile.open("added_indirects.json", std::ios::out); 
  }

  ~FunctionImportsToIndirectCalls() { myfile.close(); }

#pragma optimize("", off)
  void visitCallIndirect(CallIndirect* curr) {
    if (auto* c = curr->target->dynCast<Const>()) {
      //  Index index = c->value.geti32();
      //  // If the index is invalid, or the type is wrong, we can
      //  // emit an unreachable here, since in Binaryen it is ok to
      //  // reorder/replace traps when optimizing (but never to
      //  // remove them, at least not by default).
      //  if (index >= flatTable->names.size()) {
      //    replaceWithUnreachable(curr);
      //    return;
      //  }
      //  auto name = flatTable->names[index];
      //  if (!name.is()) {
      //    replaceWithUnreachable(curr);
      //    return;
      //  }
      //  auto* func = getModule()->getFunction(name);
      //  if (getSig(getModule()->getFunctionType(curr->fullType)) !=
      //      getSig(func)) {
      //    replaceWithUnreachable(curr);
      //    return;
      //  }
      //  // Everything looks good!
      //  replaceCurrent(
      //    Builder(*getModule())
      //      .makeCall(name, curr->operands, curr->type, curr->isReturn));
    }
  }

#pragma optimize("", off)
  void visitCall(Call* curr) {
    auto name = curr->target;

    if (!name.isNull()) {
      auto* func = getModule()->getFunction(name);
      if (func) {
        printf("Import %s detected!", name.c_str());
        if (func->imported()) {
          std::vector<Expression*> args;
          for (int i = 0; i < curr->operands.size(); ++i) {
            args.push_back(curr->operands[i]);
          }
          auto module = getModule();
          /*auto* import = new Global;
          Name getter(std::string("g$") + name.c_str());
          import->name = getter;
          import->module = "env";
          import->base = getter;
          import->type = i32;
          auto global = module->addGlobal(import);
          Expression* fptr = Builder(*module).makeGlobalGet(getter, i32);*/
          Name delayLoader(std::string("dl$") + name.c_str());
          auto* delayLoaderFn = getModule()->getFunctionOrNull(delayLoader);

          // If null, generate an empty dl that will force the
          // wasm module to import it from JS. The dl in this case is
          // defined in the JS.
          if (!delayLoaderFn) {
            auto* delayLoaderFn =
              Builder(*module).makeFunction(delayLoader, std::move(func->params), func->result,
                {
                  // call dlopen
                  // call the target function directly
                });
            delayLoaderFn->module = "env";
            delayLoaderFn->base = delayLoaderFn->name; // copied from ExtractFunction
                                               // : public Pass
            module->addFunction(delayLoaderFn);

            ++module->table.max;

            if (module->table.initial == 0) {
              ++module->table.initial; // Validation uses module.table.initial
                                       // * Table::kPageSize to check
                                       // reasonable segment offset
            }
            // Name thunkInternal(std::string("__Z13sideyInternali"));
            module->table.segments[0].data.push_back(delayLoader);
            std::string pair;
            if (!IAT.data.empty())
              IAT.data.emplace_back(',');
            pair = std::to_string(module->table.max.addr) + ":" + std::string(name.c_str());
            std::copy(pair.begin(), pair.end(), std::back_inserter(IAT.data));

            json::Value add_indirects;
            add_indirects.setObject();
            json::Ref value = json::Ref(new json::Value(module->table.max.addr));
            add_indirects["add_indirects"] = value;
            add_indirects.stringify(myfile);
          }

          /*auto* export_ = new Export;
                      export_->name = thunkFunc->name;
                      export_->value = thunkFunc->name;
                      export_->kind = ExternalKind::Function;
                      module->addExport(export_);*/

          auto fnType = module->getFunctionType(func->type);
          // auto idx = Literal(int32_t(table.segments[0].data.size() - 1));
          auto idx = Literal(int32_t(module->table.max.addr - 1));
          std::cout << "idx:" << idx << "\n";
          auto* fptr = Builder(*module).makeConst(idx);
          // Latest upstream will have support for tail calls
          // auto indirectCall = Builder(*module).makeCallIndirect(
          // fnType, fptr, args, curr->isReturn);
          auto indirectCall = Builder(*module).makeCallIndirect(fnType, fptr, args);

          replaceCurrent(indirectCall);
        }
      }
    }
    return;
  }

  static std::ostream& printName(Name name, std::ostream& o) {
    // we need to quote names if they have tricky chars
    if (!name.str || !strpbrk(name.str, "()")) {
      o << name;
    } else {
      o << '"' << name << '"';
    }
    return o;
  }

  void visitTable(Table* curr) {
    for (auto& segment : curr->segments) {
      unsigned indent = 0;
      const char* maybeNewLine = "\n";
      // Don't print empty segments
      if (segment.data.empty()) {
        continue;
      }
      doIndent(std::cout, indent);
      std::cout << '(';
      printMajor(std::cout, "elem ");
      visit(segment.offset);
      for (auto name : segment.data) {
        std::cout << ' ';
        printName(name, std::cout);
      }
      std::cout << ')' << maybeNewLine;
    }
  }

  void visitModule(Module* curr) { 
      // Create a user section to host the Import Address Table
    curr->userSections.push_back(IAT);
  }

private:
  std::ofstream myfile;
  UserSection IAT;
};

struct ImportsToIndirectCalls : public Pass {
  void run(PassRunner* runner, Module* module) override {
    if (!module->table.exists) {
      Fatal() << "Table does not exist in module!!!";
      return;
    }

    // Create a segment if it does not already exist
    if (module->table.segments.empty()) {
      Table::Segment segment(module->allocator.alloc<Const>()->set(Literal(int32_t(0))));

      module->table.initial = 0;
      module->table.max = 0;
      module->table.exists = true;
      module->table.segments.push_back(segment);
    }

    // Ugly hack to see if current module is a side module
    bool isSideModule = false;
    for (auto& func : module->functions) {
      if (func->name.hasSubstring("post_instantiate")) {
        isSideModule = true;
      }
    }
    if (!isSideModule) {
      FunctionImportsToIndirectCalls().run(runner, module);
    }
  }
};

} // anonymous namespace

Pass* createImportsToIndirectCallsPass() { return new ImportsToIndirectCalls(); }

} // namespace wasm
