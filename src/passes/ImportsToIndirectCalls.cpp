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
#include "wasm-traversal.h"
#include "wasm.h"
#include <fstream>
#include <map>

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

  FunctionImportsToIndirectCalls(std::string sideFnFile) {
    IAT.name = "IAT";
    // myfile.open("added_indirects.json", std::ios::out);
    myfile.open(sideFnFile, std::ios::in);
    char delimiter = ',';
    std::string token;
    std::string output;
    while (std::getline(myfile, output)) {
      std::istringstream line(output);
      while (std::getline(line, token, delimiter)) {
        sideFunctions.push_back(token);
      }
    }
  }

  FunctionImportsToIndirectCalls() {}

  ~FunctionImportsToIndirectCalls() { myfile.close(); }

#pragma optimize("", off)
  void visitCallIndirect(CallIndirect* curr) {
    // if (auto* c = curr->target->dynCast<Const>()) {
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
    //}

    // if (auto* c = curr->target->dynCast<Const>()) {
    //  Index index = c->value.geti32();
    //  if (index >= getModule()->table.segments[0].data.size()) {
    //    std::cout << "index exceeds table size\n";
    //    return;
    //  }
    //  auto name = getModule()->table.segments[0].data[index];
    //  if (!name.is()) {
    //    std::cout << "name is invalid!!!\n";
    //    return;
    //  }
    //  auto* func = getModule()->getFunction(name);
    //  if (func->imported()) {
    //    name = func->base;
    //    if (name.hasSubstring("ZL9init_versv_4518"))
    //      printf("name:%s!!!\n", name.c_str());

    //    // We only replace user imported functions e.g. functions that are not in the JS library
    //    if (std::find(sideFunctions.begin(), sideFunctions.end(), name.c_str()) ==
    //        sideFunctions.end()) {
    //      return;
    //    }

    //    std::vector<Expression*> args;
    //    for (int i = 0; i < curr->operands.size(); ++i) {
    //      args.push_back(curr->operands[i]);
    //    }

    //    auto module = getModule();
    //    auto sig = getSig(func);

    //    if (sig.empty()) {
    //      printf("sig:%s is empty!!!\n", sig.c_str());
    //    }
    //    Name delayLoaderName(std::string("dl$") + name.c_str() + '$' + sig);
    //    auto* delayLoaderFn = getModule()->getFunctionOrNull(delayLoaderName);

    //    // If null, generate an empty dl that will force the
    //    // wasm module to import it from JS. The dl in this case is
    //    // defined in the JS.
    //    if (!delayLoaderFn) {
    //      auto* delayLoaderFn2 =
    //        Builder(*module).makeFunction(delayLoaderName, std::move(func->params), func->result,
    //          {
    //            // call dlopen
    //            // call the target function directly
    //          });

    //      if (!delayLoaderFn2) {
    //        printf("delayLoaderFn2 is null!!! for delayLoaderName:%s\n", delayLoaderName.c_str());
    //        return;
    //      }

    //      delayLoaderFn2->module = "env";
    //      delayLoaderFn2->base = delayLoaderName; // copied from ExtractFunction
    //                                              // : public Pass
    //      module->addFunction(delayLoaderFn2);

    //      // Name thunkInternal(std::string("__Z13sideyInternali"));
    //      module->table.segments[0].data[index] = delayLoaderName;
    //    }
    //  }
    //}
  }

#pragma optimize("", off)
  void visitCall(Call* curr) {
    auto name = curr->target;
    auto* func = getModule()->getFunctionOrNull(name);

    if (!func) {
      printf("name:%s does not exist!!!\n", name.c_str());
      return;
    }

    if (name.hasSubstring("ZL9init_versv_4518"))
      printf("name:%s!!!\n", name.c_str());

    if (!name.isNull()) {
      if (func) {
        if (func->imported()) {
          auto realName = func->base;
          
          // We only replace user imported functions e.g. functions that are not in the JS library
          if (std::find(sideFunctions.begin(), sideFunctions.end(), realName.c_str()) ==
              sideFunctions.end()) {
            return;
          }

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

          if (realName.hasSubstring("__ZN16AcQueryEntityImp23PickMatchesRolloverHintEl")) {
            // printf("visitCall imported fn:%s sig:%s!!!\n", name.c_str(), sig.c_str());
            printf("visitCall imported fn:%s!!!\n", realName.c_str());
          }
            

          auto sig = getSig(func);

          if (sig.empty()) {
            printf("sig:%s is empty!!!\n", sig.c_str());
          }

          //Name delayLoaderName(std::string("dl$") + name.c_str() + '$' + sig);

          // We will not add the signature because for some reason or another, the same fn can have 2 sigs!!!
          // e.g. name:__ZN11AcApViewImp13OnLButtonDownEj7AcPointIiE sig:viii sig:v
          Name delayLoaderName(std::string("dl$") + realName.c_str());
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

            // If the original import function already exists in the table, replace it with the delayLoader
            // else, add it to the table
            bool funcFound = false;
            uint32_t insertIdx = 0;
            for (int i = 0; i < module->table.segments[0].data.size(); ++i) {
              if (module->table.segments[0].data[i] == name) {
                module->table.segments[0].data[i] = delayLoaderName;
                funcFound = true;
                insertIdx = i;
                std::cout << "Found :" << name << " in table. Inserting " << delayLoaderName << " at idx:" << insertIdx << "\n";
                break;
              }
            }
            
            if (funcFound == false) {
              module->table.segments[0].data.push_back(delayLoaderName);
              insertIdx = module->table.initial;
              module->table.initial = module->table.initial + 1;
              /*std::cout << "Cannot find :" << name << " in table!!! Inserting " << delayLoaderName
                        << " at idx:" << insertIdx << "\n";*/
            }

            std::string pair;
            if (!IAT.data.empty())
              IAT.data.emplace_back(',');
            pair = "\"" + std::string(realName.c_str()) + "\"" + ":" + std::to_string(insertIdx);
            std::copy(pair.begin(), pair.end(), std::back_inserter(IAT.data));

            if (realName.hasSubstring("__ZN16AcQueryEntityImp23PickMatchesRolloverHintEl"))
              std::cout << "visitCall pair:" << pair << "\n";

            /*json::Value add_indirects;
            add_indirects.setObject();
            json::Ref value = json::Ref(new json::Value(module->table.initial));
            add_indirects["add_indirects"] = value;
            add_indirects.stringify(myfile);*/

            delayLoaderToTableIdx[delayLoaderName] = insertIdx;
            /*printf("delayLoaderToTableIdx: key:%s value:%d\n", delayLoaderName.c_str(),
              module->table.initial);*/
            
            // printf("delayLoaderToTableIdx: table.initial:%d\n", module->table.initial);
          }
          auto fnType = module->getFunctionType(func->type);
          auto idx = Literal(int32_t(delayLoaderToTableIdx[delayLoaderName]));
          // printf("Assign: delayLoaderName:%s idx:%d\n", delayLoaderName.c_str(),
          // delayLoaderToTableIdx[delayLoaderName]);
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

      visit(segment.offset);
      for (int i = 0; i < segment.data.size(); ++i) {
        auto name = segment.data[i];
        /*std::cout << ' ';
        printName(name, std::cout);*/

        if (name.isNull())
          continue;

        auto* func = getModule()->getFunctionOrNull(name);

        if (!func) {
          printf("func:%s does not exist!!!\n", name.c_str());
          continue;
        }
        if (func->imported()) {
          name = func->base;
          if (name.hasSubstring("__ZN16AcQueryEntityImp23PickMatchesRolloverHintEl"))
            printf("visitTable imported fn:%s!!!\n", name.c_str());

          // We only replace user imported functions e.g. functions that are not in the JS
          // library
          if (std::find(sideFunctions.begin(), sideFunctions.end(), name.c_str()) ==
              sideFunctions.end()) {
            continue;
          }

          auto sig = getSig(func);

          if (sig.empty()) {
            printf("sig:%s is empty!!!\n", sig.c_str());
          }
          //Name delayLoaderName(std::string("dl$") + name.c_str() + '$' + sig);

          // We will not add the signature because for some reason or another, the same fn can have
          // 2 sigs!!! e.g. name:__ZN11AcApViewImp13OnLButtonDownEj7AcPointIiE sig:viii sig:v
          Name delayLoaderName(std::string("dl$") + name.c_str());

          auto* delayLoaderFn = getModule()->getFunctionOrNull(delayLoaderName);

          // If null, generate an empty dl that will force the
          // wasm module to import it from JS. The dl in this case is
          // defined in the JS.
          if (!delayLoaderFn) {
            auto* delayLoaderFn2 =
              Builder(*getModule())
                .makeFunction(delayLoaderName, std::move(func->params), func->result,
                  {
                    // call dlopen
                    // call the target function directly
                  });

            if (!delayLoaderFn2) {
              printf("delayLoaderFn2 is null!!! for delayLoaderName:%s\n", delayLoaderName.c_str());
              continue;
            }

            delayLoaderFn2->module = "env";
            delayLoaderFn2->base = delayLoaderName; // copied from ExtractFunction
                                                    // : public Pass
            getModule()->addFunction(delayLoaderFn2);
          }

          // For table entries replacement, we need to replace them even if the delayloader already exists
          // Name thunkInternal(std::string("__Z13sideyInternali"));
          segment.data[i] = delayLoaderName;

          std::string pair;
          if (!IAT.data.empty())
            IAT.data.emplace_back(',');
          pair = "\"" + std::string(name.c_str()) + "\"" + ":" + std::to_string(i);
          std::copy(pair.begin(), pair.end(), std::back_inserter(IAT.data));
          if (name.hasSubstring("ZN11AcApViewImp13OnLButtonDownEj7AcPointIiE"))
            std::cout << "visitTable pair:" << pair << "\n";
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
  std::vector<std::string> sideFunctions;
};

std::vector<wasm::Name> tableClone;

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

    for (auto& segment : module->table.segments) {
      // Don't print empty segments
      if (segment.data.empty()) {
        continue;
      }

      /*for (auto i = 0; ++i; segment.data.size()) {
        printf("Idx:%d name:%s\n", i, segment.data[i].c_str());
        tableClone.push_back(segment.data[i]);
      }*/
    }

    std::string sideFnFileName = runner->options.arguments["sideFunctions"];
    printf("sideFnFileName:%s\n", sideFnFileName.c_str());
    // Ugly hack to see if current module is a side module
    bool isSideModule = false;
    for (auto& func : module->functions) {
      if (func->name.hasSubstring("post_instantiate")) {
        isSideModule = true;
      }
    }
    if (!isSideModule) {
      FunctionImportsToIndirectCalls(sideFnFileName).run(runner, module);
    } else {
      std::cout << "Side Module detected!!! Ignoring\n";
    }
  }
};

} // anonymous namespace

Pass* createImportsToIndirectCallsPass() { return new ImportsToIndirectCalls(); }

} // namespace wasm
