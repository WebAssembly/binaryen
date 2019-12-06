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
#include "ir/table-utils.h"
#include "ir/utils.h"
#include "ir/import-utils.h"
#include "ir/function-type-utils.h"
#include "pass.h"
#include "pretty_printing.h"
#include "support/json.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "wasm.h"
#include <fstream>
#include <regex> 

cashew::IString ENV("env");

namespace wasm {

static Name ASSIGN_GOT_ENTIRES("__assign_got_enties");

namespace {

struct FunctionImportsToIndirectCalls
  : public WalkerPass<PostWalker<FunctionImportsToIndirectCalls>> {
  bool isFunctionParallel() override { return false; }

  Pass* create() override { return new FunctionImportsToIndirectCalls(); }

  FunctionImportsToIndirectCalls() {}

  FunctionImportsToIndirectCalls(bool isSide, std::set<std::string> libraryFns)
    : m_isSide(isSide), m_libraryFns(libraryFns) {}

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

  static Function*
  ensureFunctionImport(Module* module, Name name, std::string sig) {
    // Then see if its already imported
    ImportInfo info(*module);
    if (Function* f = info.getImportedFunction(ENV, name)) {
      return f;
    }
    // Failing that create a new function import.
    auto import = new Function;
    import->name = name;
    import->module = ENV;
    import->base = name;
    auto* functionType = ensureFunctionType(sig, module);
    import->type = functionType->name;
    FunctionTypeUtils::fillFunction(import, functionType);
    module->addFunction(import);
    return import;
  }

#pragma optimize("", off)
  void visitCall(Call* curr) {
    auto name = curr->target;

    if (!name.isNull() && !m_isSide) {
      auto module = getModule();
      auto* func = module->getFunction(name);
      if (func) {
        if (func->imported()) {

          bool is_in = m_libraryFns.find(name.c_str()) != m_libraryFns.end();
          if (is_in)
            return;

          is_in = name.hasSubstring("g$") || name.hasSubstring("fp$") ||
                  name.hasSubstring("__wasi_fd_write");

          if (is_in) 
            return;

          std::cerr << "Processing: " << name.c_str() << "\n";
          std::vector<Expression*> args;
          for (int i = 0; i < curr->operands.size(); ++i) {
            args.push_back(curr->operands[i]);
          }
          Builder builder(*module);
          ImportInfo info(*module);

          std::string getterString((std::string("fp$") + name.c_str() +
                                    std::string("$") + getSig(func)).c_str());
          std::replace(getterString.begin(), getterString.end(), '\\', '_');
          Name getter(getterString.c_str());

          // Ensure that the fp$ accessor is in the module, if not add it in.
          std::string fnAddrString((std::string("gp$") + name.c_str() + std::string("$") +
                         getSig(func)).c_str());
          std::replace(fnAddrString.begin(), fnAddrString.end(), '\\', '_');
          Name fnAddr(fnAddrString.c_str());
            
          auto f = info.getImportedFunction(ENV, getter);
          if (!f) {
            f = ensureFunctionImport(module, getter, "i");

            auto* assignFunc = getModule()->getFunction(ASSIGN_GOT_ENTIRES);

            Block* block = static_cast<Block*>(assignFunc->body);

            if (!block)
              return;

            auto* import = new Global;
            
            import->name = fnAddr;
            import->module = "env";
            import->base = getter;
            import->type = i32;
            auto global = module->addGlobal(import);

            Expression* call = builder.makeCall(getter, {}, i32);
            GlobalSet* globalSet = builder.makeGlobalSet(fnAddr, call);
            block->list.push_back(globalSet);
          }
          
          // Replace the call
          Expression* fptr = builder.makeGlobalGet(fnAddr, i32);

          auto fnType = module->getFunctionType(func->type);
          auto indirectCall =
            builder.makeCallIndirect(fnType, fptr, args, curr->isReturn);

          replaceCurrent(indirectCall);
        }
      }
    }
    return;
  }

  //void visitTable(Table* curr) {
  //  for (auto& segment : curr->segments) {
  //    unsigned indent = 0;
  //    const char* maybeNewLine = "\n";
  //    // Don't print empty segments
  //    if (segment.data.empty()) {
  //      continue;
  //    }
  //    doIndent(std::cout, indent);
  //    std::cout << '(';
  //    printMajor(std::cout, "elem ");
  //    visit(segment.offset);
  //    for (auto name : segment.data) {
  //      std::cout << ' ';
  //    }
  //    std::cout << ')' << maybeNewLine;
  //  }
  //}

private:
  std::ofstream myfile;
  bool m_isSide;
  std::set<std::string> m_libraryFns;
};

static Name POST_INSTANTIATE("__post_instantiate");

struct ImportsToIndirectCalls : public Pass {
  void run(PassRunner* runner, Module* module) override {
    Name name = runner->options.getArgument(
      "library-file",
      "ImportsToIndirectCalls usage:  wasm-emscripten-finalize --pass-arg=library-file@FILE_NAME");
    std::cerr << "library-file: " << name << "\n";

    std::ifstream myfile;
    myfile.open(name.c_str(), std::ios::in);
    std::string str;

    myfile.seekg(0, std::ios::end);
    str.reserve(myfile.tellg());
    myfile.seekg(0, std::ios::beg);

    str.assign((std::istreambuf_iterator<char>(myfile)),
               std::istreambuf_iterator<char>());
    str.erase(remove(str.begin(), str.end(), '\''), str.end());
    str.erase(remove(str.begin(), str.end(), '\['), str.end());
    str.erase(remove(str.begin(), str.end(), '\]'), str.end());
    remove_if(str.begin(), str.end(), isspace);

    std::string delimiter = ",";
    std::set<std::string> setStrings;
    size_t pos = 0;
    std::string token;
    while ((pos = str.find(delimiter)) != std::string::npos) {
      token = str.substr(0, pos);
      token.erase(0,1); // remove underscore
      setStrings.insert(token);
      str.erase(0, pos + delimiter.length());
    }

    if (!module->table.exists) {
      Fatal() << "Table does not exist in module!!!";
      return;
    }

    // Create a segment if it does not already exist
    if (module->table.segments.empty()) {
      Table::Segment segment(
        module->allocator.alloc<Const>()->set(Literal(int32_t(0))));

      module->table.initial = 0;
      module->table.max = 0;
      module->table.exists = true;
      module->table.segments.push_back(segment);
    }
    bool isSide = false;
    if (auto* e = module->getExportOrNull(POST_INSTANTIATE)) {
      isSide = true;
    }
    FunctionImportsToIndirectCalls(isSide, setStrings).run(runner, module);
  }
};

} // anonymous namespace

Pass* createImportsToIndirectCallsPass() {
  return new ImportsToIndirectCalls();
}

} // namespace wasm
