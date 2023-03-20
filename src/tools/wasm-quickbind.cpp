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

#include "wasm-io.h"
#include "wasm-validator.h"

#include "tool-options.h"

using namespace wasm;

namespace {
  class ShimBuilder {
  public:
    ShimBuilder(Module& inputModule, Module& outputModule) 
      : _inputModule(inputModule)
      , _outputModule(outputModule) 
      , _builder(outputModule) {};


    void build() {
      for (const auto& inputExport : _inputModule.exports) {
        switch (inputExport->kind) {
          case ExternalKind::Function:
            _addExportedFunction(*inputExport);
            break;
          case ExternalKind::Global:
            _addGlobal(*inputExport);
            break;
          case ExternalKind::Memory:
            _addMemory(*inputExport);
            break;
          case ExternalKind::Table:
            _addTable(*inputExport);
            break;
          case ExternalKind::Tag:
            _addTag(*inputExport);
            break;
          default:
            throw "INVALID";
        }
      }
    }

  private:
    void _addExportedFunction(const Export &inputExport) {
      Function* inputFunction = _inputModule.getFunction(inputExport.value);
      std::string globalName = "_qb_g_";
      globalName += inputExport.name.str;
      auto refType = Type(inputFunction->type, Nullability::Nullable);
      auto global = Builder::makeGlobal(
        globalName,
        refType,
        _builder.makeRefNull(inputFunction->type),
        Builder::Mutability::Mutable
      );
      auto bindFunctionType = HeapType(Signature(Type(refType), Type()));
      auto bindFunctionBlock = _builder.makeBlock(
        _builder.makeGlobalSet(
          globalName,
          _builder.makeLocalGet(
            0,
            refType
          )
        )
      );
      std::string bindFunctionName = "_qb_bind_";
      bindFunctionName += inputExport.name.str;
      auto bindFunction = Builder::makeFunction(
        bindFunctionName,
        { NameType("f", refType) },
        bindFunctionType,
        {},
        bindFunctionBlock
      );

      std::vector<LocalGet*> args;
      Type params = inputFunction->getParams();
      for (size_t i = 0; i < inputFunction->getNumParams(); i++) {
        args.push_back(_builder.makeLocalGet(i, params[i]));
      }
      auto proxyFunctionBlock = _builder.makeBlock(
        _builder.makeCallRef(
          _builder.makeGlobalGet(globalName, refType),
          args,
          refType,
          true
        )
      );
      auto proxyFunction = Builder::makeFunction(
        inputExport.name,
        {},
        inputFunction->type,
        {},
        proxyFunctionBlock
      );

      _outputModule.addFunction(std::move(proxyFunction));
      _outputModule.addFunction(std::move(bindFunction));
      _outputModule.addGlobal(std::move(global));
      _outputModule.addExport(Builder::makeExport(
        inputExport.name,
        inputExport.name,
        ExternalKind::Function
      ));
      _outputModule.addExport(Builder::makeExport(
        bindFunctionName,
        bindFunctionName,
        ExternalKind::Function
      ));
    }

    void _addGlobal(const Export& inputExport) {
      Global* inputGlobal = _inputModule.getGlobal(inputExport.value);
      auto outputGlobal = Builder::makeGlobal(
        inputExport.name,
        inputGlobal->type,
        nullptr,
        inputGlobal->mutable_ ? Builder::Mutability::Mutable : Builder::Mutability::Immutable
      );
      outputGlobal->module = "_qb_source";
      outputGlobal->base = inputExport.name;
      _outputModule.addGlobal(std::move(outputGlobal));
      _outputModule.addExport(Builder::makeExport(
        inputExport.name,
        inputExport.name,
        inputExport.kind
      ));
    }

    void _addMemory(const Export& inputExport) {
      Memory* inputMemory = _inputModule.getMemory(inputExport.value);
      auto outputMemory = Builder::makeMemory(
        inputExport.name,
        inputMemory->initial,
        inputMemory->max,
        inputMemory->shared,
        inputMemory->indexType
      );
      outputMemory->module = "_qb_source";
      outputMemory->base = inputExport.name;
      _outputModule.addMemory(std::move(outputMemory));
      _outputModule.addExport(Builder::makeExport(
        inputExport.name,
        inputExport.name,
        inputExport.kind
      ));
    }

    void _addTable(const Export& inputExport) {
      Table* inputTable = _inputModule.getTable(inputExport.value);
      auto outputTable = Builder::makeTable(
        inputExport.name,
        inputTable->type,
        inputTable->initial,
        inputTable->max
      );
      outputTable->module = "_qb_source";
      outputTable->base = inputExport.name;
      _outputModule.addTable(std::move(outputTable));
      _outputModule.addExport(Builder::makeExport(
        inputExport.name,
        inputExport.name,
        inputExport.kind
      ));
    }

    void _addTag(const Export& inputExport) {
      Tag* inputTag = _inputModule.getTag(inputExport.value);
      auto outputTag = Builder::makeTag(
        inputExport.name,
        inputTag->sig
      );
      outputTag->module = "_qb_source";
      outputTag->base = inputExport.name;
      _outputModule.addTag(std::move(outputTag));
      _outputModule.addExport(Builder::makeExport(
        inputExport.name,
        inputExport.name,
        inputExport.kind
      ));
    }


    Module& _inputModule;
    Module& _outputModule;
    Builder _builder;
  };
}

int main(int argc, const char* argv[]) {
  const std::string WasmQuickbindOption = "wasm-quickbind options";
  ToolOptions options("wasm-quickbind",
                      "Create a lightweight shim module for quick binding.");
  options
    .add("--output",
         "-o",
         "Output file (stdout if not specified)",
         WasmQuickbindOption,
         Options::Arguments::One,
         [](Options* o, const std::string& argument) {
         o->extra["output"] = argument;
         Colors::setEnabled(false);
         })
    .add_positional("INFILE",
                    Options::Arguments::One,
                    [](Options* o, const std::string& argument) {
                      o->extra["infile"] = argument;
                    });
  options.parse(argc, argv);
                  
  Module inputModule;
  options.applyFeatures(inputModule);
  try {
    ModuleReader().readBinary(options.extra["infile"], inputModule);
  } catch (ParseException& p) {
    p.dump(std::cerr);
    std::cerr << '\n';
    if (options.debug) {
      Fatal() << "error parsing wasm. here is what we read up to the error:\n"
              << inputModule;
    } else {
      Fatal() << "error parsing wasm (try --debug for more info)";
    }
  } catch (MapParseException& p) {
    p.dump(std::cerr);
    std::cerr << '\n';
    Fatal() << "error in parsing wasm source mapping";
  }

  Module outputModule = Module();
  options.applyFeatures(outputModule);
  ShimBuilder(inputModule, outputModule).build();
  if (!WasmValidator().validate(outputModule, options.passOptions)) {
    throw "Invalid output.";
  }

  ModuleWriter writer;
  writer.setBinary(true);
  writer.setDebugInfo(false);
  writer.write(outputModule, options.extra["output"]);

  return 0;
}
