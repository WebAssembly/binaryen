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
#include "wasm-binary.h"
#include "wasm-builder.h"
#include "wasm-emscripten.h"
#include "wasm-traversal.h"
#include "wasm.h"
#include <fstream>
#include <map>

std::vector<wasm::Name> tableClone;
typedef std::map<std::string, std::vector<std::string>> mainInfoType;
mainInfoType mainInfo;

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
bool isSideModule = false;

struct FunctionImportsToIndirectCalls
  : public WalkerPass<PostWalker<FunctionImportsToIndirectCalls>> {
  bool isFunctionParallel() override { return false; }

  Pass* create() override { return new FunctionImportsToIndirectCalls(); }

  FunctionImportsToIndirectCalls(std::vector<std::string> sideFns) {
    IAT.name = "IAT";
    wasmImports = sideFns;
  }

  FunctionImportsToIndirectCalls() {}

  ~FunctionImportsToIndirectCalls() { myfile.close(); }

  void visitCallIndirect(CallIndirect* curr) {
     if (auto* c = curr->target->dynCast<Const>()) {
      Index index = c->value.geti32();
      if (index >= getModule()->table.segments[0].data.size()) {
        std::cout << "index exceeds table size\n";
        return;
      }
      auto name = getModule()->table.segments[0].data[index];
      if (!name.is()) {
        std::cout << "name is invalid!!!\n";
        return;
      }
      auto* func = getModule()->getFunction(name);
      if (func->imported()) {
        name = func->base;
        if (name.hasSubstring("ZL9init_versv_4518"))
          printf("name:%s!!!\n", name.c_str());

        // We only replace user imported functions e.g. functions that are not in the JS library
        if (std::find(wasmImports.begin(), wasmImports.end(), name.c_str()) == wasmImports.end()) {
          return;
        }

        std::vector<Expression*> args;
        for (int i = 0; i < curr->operands.size(); ++i) {
          args.push_back(curr->operands[i]);
        }

        auto module = getModule();
        auto sig = getSig(func);

        if (sig.empty()) {
          printf("sig:%s is empty!!!\n", sig.c_str());
        }
        Name delayLoaderName(std::string("dl$") + name.c_str() + '$' + sig);
        auto* delayLoaderFn = getModule()->getFunctionOrNull(delayLoaderName);

        // If null, generate an empty dl that will force the
        // wasm module to import it from JS. The dl in this case is
        // defined in the JS.
        if (!delayLoaderFn) {
          auto* delayLoaderFn2 =
            Builder(*module).makeFunction(delayLoaderName, std::move(func->params), func->result,
              {
                // call dlopen
                // call the target function directly
              });

          if (!delayLoaderFn2) {
            printf("delayLoaderFn2 is null!!! for delayLoaderName:%s\n", delayLoaderName.c_str());
            return;
          }

          delayLoaderFn2->module = "env";
          delayLoaderFn2->base = delayLoaderName; // copied from ExtractFunction
                                                  // : public Pass
          module->addFunction(delayLoaderFn2);

          // Name thunkInternal(std::string("__Z13sideyInternali"));
          module->table.segments[0].data[index] = delayLoaderName;
        }
      }
    }
  }

//#pragma optimize("", off)
  void visitCall(Call* curr) {
    auto name = curr->target;
    auto* func = getModule()->getFunctionOrNull(name);

    if (!func) {
      printf("name:%s does not exist!!!\n", name.c_str());
      return;
    }

    if (!name.isNull()) {
      if (func) {
        if (func->imported()) {
          auto realName = func->base;

          if (!isSideModule) {

            // We only replace user imported functions e.g. functions that are not in the JS library
            if (std::find(wasmImports.begin(), wasmImports.end(), realName.c_str()) ==
                wasmImports.end()) {
              return;
            }

			if (realName.hasSubstring("sidey"))
              std::cout << "visitCall fnName:" << realName << "\n";

            std::vector<Expression*> args;
            for (int i = 0; i < curr->operands.size(); ++i) {
              args.push_back(curr->operands[i]);
            }

            auto module = getModule();

            Name getter(std::string("g$") + realName.c_str());
            Expression* fptr = Builder(*module).makeGlobalGet(getter, i32);

            auto fnType = module->getFunctionType(func->type);
            auto indirectCall = Builder(*module).makeCallIndirect(fnType, fptr, args);

            replaceCurrent(indirectCall);
          } else {
            // TODO: We need the list of exported main functions here!!!
            if (std::find(mainInfo["exports"].begin(), mainInfo["exports"].end(),
                  realName.c_str()) == mainInfo["exports"].end()) {
              return;
            }

            //std::cout << "Side Module converting:" << realName.c_str() << "\n";

            std::vector<Expression*> args;
            for (int i = 0; i < curr->operands.size(); ++i) {
              args.push_back(curr->operands[i]);
            }

            // Global is already added in EmscriptenGlueGenerator::generateAssignGOTEntriesFunction
            auto module = getModule();
            Name getter(std::string("g$") + realName.c_str());
            Expression* fptr = Builder(*module).makeGlobalGet(getter, i32);

            auto fnType = module->getFunctionType(func->type);
            auto indirectCall = Builder(*module).makeCallIndirect(fnType, fptr, args);

            replaceCurrent(indirectCall);
          }
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

    if (!isSideModule) {
      // Handle the case where the imported fn is already in the table because it may be
      // called indirectly.
      for (auto& segment : curr->segments) {
        visit(segment.offset);
        for (int i = 0; i < segment.data.size(); ++i) {
          auto name = segment.data[i];

          if (name.isNull())
            continue;

          auto* func = getModule()->getFunctionOrNull(name);

          if (!func) {
            printf("func:%s does not exist!!!\n", name.c_str());
            continue;
          }
          if (func->imported()) {
            name = func->base;

            // We only replace user imported functions e.g. functions that are not in the JS
            // library
            if (std::find(wasmImports.begin(), wasmImports.end(), name.c_str()) ==
                wasmImports.end()) {
              continue;
            }

            // We will not add the signature because for some reason or another, the same fn can
            // have 2 sigs!!! e.g. name:__ZN11AcApViewImp13OnLButtonDownEj7AcPointIiE sig:viii sig:v
            Name dynamicLoaderName(std::string("fp$") + name.c_str() + std::string("$") +
                                   getSig(func) + std::string("$") + std::to_string(i));

            auto* dynamicLoaderFn = getModule()->getFunctionOrNull(dynamicLoaderName);

            // If null, generate an empty dl that will force the
            // wasm module to import it from JS. The dl in this case is
            // defined in the JS.
            if (!dynamicLoaderFn) {
              auto* dynamicLoaderFn =
                Builder(*getModule())
                  .makeFunction(dynamicLoaderName, std::move(func->params), func->result,
                    {
                      // call dlopen
                      // call the target function directly
                    });

              if (!dynamicLoaderFn) {
                printf(
                  "delayLoaderFn2 is null!!! for delayLoaderName:%s\n", dynamicLoaderName.c_str());
                continue;
              }

              dynamicLoaderFn->module = "env";
              dynamicLoaderFn->base = dynamicLoaderName; // copied from ExtractFunction:public Pass
              getModule()->addFunction(dynamicLoaderFn);
            }
            getModule()->removeFunction(name);
            // std::cout << "visitTable: Replace fn with: " << dynamicLoaderName.c_str() << "\n";
            segment.data[i] = dynamicLoaderName.c_str();
          }
        }
      }
    }
  }

  void visitModule(Module* curr) {
    // Create a user section to host the Import Address Table
    curr->userSections.push_back(IAT);
  }

private:
  std::ifstream myfile;
  UserSection IAT;
  std::map<Name, int> delayLoaderToTableIdx;
  std::vector<std::string> wasmImports;
  std::vector<std::string> mainFunctions;
};

mainInfoType getFunctions(const std::string& mainInfoFileName) {
  mainInfoType mainInfoTemp;
  std::ifstream myfile;
  myfile.open(mainInfoFileName, std::ios::in);

  if (!myfile) {
    std::cout << mainInfoFileName << " not found!!!\n";
    return mainInfoTemp;
  }

  char delimiter = ',';
  std::string token;
  std::string output;
  while (std::getline(myfile, output)) {
    std::istringstream line(output);
    std::getline(line, token, ':');
    std::string header = token;
    std::vector<std::string> functions;
    mainInfoTemp[header] = functions;
    while (std::getline(line, token, delimiter)) {
      mainInfoTemp[header].push_back(token);
    }
  }
  return mainInfoTemp;
}

struct ImportsToIndirectCalls : public Pass {
  void run(PassRunner* runner, Module* module) override {
    //if (!module->table.exists) {
    //  Fatal() << "Table does not exist in module!!!";
    //  return;
    //}

    //// Create a segment if it does not already exist
    //if (module->table.segments.empty()) {
    //  Table::Segment segment(module->allocator.alloc<Const>()->set(Literal(int32_t(0))));

    //  module->table.initial = 0;
    //  module->table.max = 0;
    //  module->table.exists = true;
    //  module->table.segments.push_back(segment);
    //}

    //for (auto& segment : module->table.segments) {
    //  // Don't print empty segments
    //  if (segment.data.empty()) {
    //    continue;
    //  }

    //  /*for (auto i = 0; ++i; segment.data.size()) {
    //    printf("Idx:%d name:%s\n", i, segment.data[i].c_str());
    //    tableClone.push_back(segment.data[i]);
    //  }*/
    //}

    std::string mainInfoFileName = runner->options.arguments["mainInfo"];
    printf("ImportsToIndirectCalls.run mainInfoFileName:%s\n", mainInfoFileName.c_str());
    mainInfo = getFunctions(mainInfoFileName);

	auto* post_instantiate = module->getExportOrNull("__post_instantiate");

	isSideModule = post_instantiate ? true : false;
    EmscriptenGlueGenerator generator(*module);
    if (!isSideModule) {
      // Generate the dynamic loaders first. If not, the original imports will
      // be removed by the pass.
      //generator.generateApplyRelocations(mainInfo["imports"]);
      FunctionImportsToIndirectCalls(mainInfo["imports"]).run(runner, module);
    } else {
      //generator.generatePostInstantiateFunction(mainInfo["exports"]);
      FunctionImportsToIndirectCalls(mainInfo["exports"]).run(runner, module);
    }
  }
};

} // anonymous namespace

Pass* createImportsToIndirectCallsPass() { return new ImportsToIndirectCalls(); }

} // namespace wasm
